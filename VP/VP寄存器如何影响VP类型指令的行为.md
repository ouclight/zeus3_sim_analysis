`VP_reg` 对 VP 类型指令的影响可以理解成：**它不是一个被 VP 指令统一读取的普通寄存器堆，而是一组 VP 数据通路配置寄存器。`VP_SET\*` 写配置，`VP_STSR/VP_DTSR` 执行时读取这些配置，决定启用哪些 VP 子模块、每个子模块怎么计算、结果写到哪里。**

关键机制在 dispatch 阶段：

```
"VP_reg_latched": deepcopy(self.core.core_regs.VP_reg)
```

见 [instruction_dispatch.py (line 463)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_dispatch/instruction_dispatch.py:463)。也就是说，`VP_STSR/VP_DTSR` 入队时会 latch 一份 `VP_reg` 快照，后续 executor 用这份 `vp_reg` 执行，避免执行过程中被后面的 `VP_SET*` 改掉。

**整体执行模型**
`VP_STSR` 是单输入 tensor：读 `SrcBlockA-BRy`，按 `VP_reg` 配置做一串 VP 计算，写到 `DstBlock-BRx`。入口在 [VP_excuter_class.py (line 501)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/VP_excuter_class.py:501)。

`VP_DTSR` 是双输入 tensor：读 `SrcBlockA-BRy` 和 `SrcBlockB-BRz`，很多模块可以选择 `data_y` 作为另一个操作数。入口在 [VP_excuter_class.py (line 727)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/VP_excuter_class.py:727)。

执行顺序大致是：

```
读输入 -> 可选 NEG -> compare/dispart/sum0/param/mul/floor/sum1/shift
     -> sum_tree -> scalar 模块链 -> relu/post_cal -> 写回 L2
```

**1. `LUTG0 / LUTG1 / LUTS`：决定哪些 VP 子模块启用**

这是最核心的 enable 配置。

在 `VP_STSR` 中：

- `LUTG0[0]/[1]`：compare / mask compare
- `LUTG0[2]`：dispart
- `LUTG0[3]`：sum0
- `LUTG0[4]`：param 分段拟合
- `LUTG0[5]`：mul
- `LUTG0[6]`：floor
- `LUTG0[7]`：sum1
- `LUTG0[8]`：shift
- `LUTG0[9]`：sum tree
- `LUTG0[10]`：输出 vector / scalar 选择相关

这些分支集中在 [VP_excuter_class.py (line 536)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/VP_excuter_class.py:536)。

`CGPM.CgPM == 0` 时走 64 lane，只用 engine A；`CGPM.CgPM == 1` 时走 32 lane，会按 engine A 再 engine B 的路径执行。

**2. `MD`：输入预处理、量化、分段参数模式**

`MD` 由 `VP_SETM-LUT` 写入，字段拆解在 [VP_excuter_class.py (line 390)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/VP_excuter_class.py:390)。

当前明显影响：

- `MD.IQEN`：在 `VP_STSR/VP_DTSR` 开始时做输入取反，代码注释写作 `NEG`。
- `MD.QEN`：在 `VP_post_cal()` 中启用输出量化，计算 `data_x = data_x * QK + QB`。
- `MD.SEGE / MD.SEGN`：控制分段拟合模块是加载参数还是使用已加载参数，以及 32/64 段模式。

`QEN` 逻辑见 [VP_excuter_class.py (line 901)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/VP_excuter_class.py:901)。

**3. `QK / QB`：输出量化参数**

`QK` 和 `QB` 由 `VP_SETV-QK/QB` 写入。它们只有在 `MD.QEN == 1` 时影响结果：

```
data_x = data_x * qk + qb
```

所以如果 `QEN` 没开，`QK/QB` 配了也不会影响当前 VP 输出。

**4. `GPMD / GPFS / CGPM`：决定 compare、sum、mul、tree 的具体模式**

这几组是 VP compute 的“模式选择器”。

例如 compare 模块 `VP_cal_compare_2()` 会组合读取：

```
LUTG0 bits
GPMD.CMPATM
GPMD.CMPM
GPFS.CMPATS
GPFS.TREED
GPFS.CMPD
CGPM.TKV
CGPM.MSKRC
GPFS.CMPS
```

见 [VP_excuter_class.py (line 924)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/VP_excuter_class.py:924)。

它们决定是：

- 做 max 还是 min：`GPFS.CMPS`
- compare tree / compare acc / two operand compare
- 是否走 top-k / mask 输出
- 输出 vector 还是 scalar
- 是否使用 `CMPV`、`MSKV`、`result_register.CMP_GROUP`

**5. `STDW/STDH/KWS/KHS/IPW/IPH/PADV`：kernel/pooling 类路径参数**

这些由 `VP_SETP-KERN` 和 `VP_SETP-IPOS` 写入。

在 compare-pool 或 sum-tree-pool 路径中使用：

- `KWS/KHS`：kernel width/height
- `STDW/STDH`：stride width/height
- `IPW/IPH`：input position / padding 偏移，代码里做了符号扩展
- `PADV`：padding value

compare-pool 使用位置见 [VP_excuter_class.py (line 973)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/VP_excuter_class.py:973)。sum-tree-pool 使用位置见 [VP_excuter_class.py (line 2043)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/VP_excuter_class.py:2043)。

**6. `SG0V / SG1V / MG0V / MULV / SUMV / CMPV / MSKV`：各子模块的常量操作数**

这些由 `VP_SETV-*` 写入，只有对应模式选择了“常量输入”时才生效。

典型例子：

- `SG0V`：sum0 模块选择常量标量时使用。
- `MG0V`：mul 模块选择常量乘数、PReLU 斜率、avgpool coeff 等路径时使用。
- `CMPV`：compare two x constant 路径使用。
- `MSKV`：mask clear / mask fill 路径使用。
- `MULV`：scalar mul 常量路径使用。
- `SUMV`：scalar sum 常量路径使用。

例如 sum0 里 `SRLC[1] == 0` 时使用 `SG0V`，否则使用 `result_register.SUM0_GROUP`，见 [VP_excuter_class.py (line 1162)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/VP_excuter_class.py:1162)。

**7. `SRLC`：决定常量还是内部结果寄存器**

`SRLC` 是一组“scalar read select”位，很多模块用它选择操作数来源。

例子：

- `SRLC[1]`：sum0 使用 `SG0V` 还是 `result_register.SUM0_GROUP`
- `SRLC[2]`：mul 使用 `MG0V` 还是 `result_register.MUL_GROUP`
- `SRLC[4]`：scalar mul 使用 `MULV` 还是 `result_register.MUL_SCALAR`
- `SRLC[5]`：scalar sum 使用 `SUMV` 还是 `result_register.SUM_SCALAR`

所以 `SRLC` 会改变“本次计算使用 VP_SETV 配的常量，还是使用前序 scalar 结果”。

**8. `SCMD / SCFS / SCSQ`：scalar 子链控制**

scalar 模块由 `LUTS` 启用，再由 `SCMD/SCFS/SCSQ` 决定行为：

- `SCFS.DPTSS + SCMD.SCDPTM`：scalar dispart 输出指数/尾数。
- `SCMD.SCMM`：scalar mul 模式，常量乘、寄存器乘、分段 k、平方。
- `SCMD.SCSM + SCFS.SUMM`：scalar sum 是加/减常量、寄存器或分段 b。
- `SCFS.SWRS`：把 scalar 结果写到哪个 `result_register` 槽。
- `SCSQ`：scalar sqrt 的牛顿迭代次数，0/1/2/3 对应 1/2/4/16 次。

`SCSQ` 使用见 [VP_excuter_class.py (line 2354)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/VP_excuter_class.py:2354)。

**9. `result_register / param_gen_\* / mask_info`：内部状态**

这些虽然放在 `VP_reg` 里，但更像 VP executor 的内部临时寄存器/缓存：

- `result_register`：保存中间 vector/scalar 结果，以及 `CMP_GROUP/SUM0_GROUP/MUL_GROUP/...` 这类可被后续模块读取的 R operand。
- `param_gen_engine_a/b/scalar`：保存分段拟合参数 `bp/k/b` 以及选中的 `k/b`。
- `mask_info`：top-k/mask compare 过程中保存 index/value。
- `shift_engine_b`：dispart 输出给后续 shift/scalar shift 的指数数据。

这些会跨 VP 子模块产生影响，尤其在一条 VP 指令内部或相关 VP 指令之间形成中间状态依赖。

**一句话总结**

`VP_reg` 影响 VP 指令行为的方式主要有三类：

1. **模块开关**：`LUTG0/LUTG1/LUTS` 决定走哪些计算模块。
2. **模式选择**：`MD/CGPM/GPMD/GPFS/SCMD/SCFS/QMD/SRLC` 决定每个模块的具体分支。
3. **操作数/参数**：`QK/QB/SG0V/MG0V/CMPV/STDW/KWS/...` 提供常量、kernel 参数、padding 参数、分段拟合参数等。

但注意：**不是每个 VP 指令都会读取所有 `VP_reg` 字段。只有当前 `LUT\*` 和模式位选中的子路径，才会消费对应字段。**