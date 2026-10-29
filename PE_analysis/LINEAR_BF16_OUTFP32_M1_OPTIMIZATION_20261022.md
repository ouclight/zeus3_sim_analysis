# linear_bf16_outfp32：M1 LM-head 优化效果、实现方法与继续优化的限制

日期：2026-10-22。对象：`code1/torch_zeus/sgl-kernel-zeus-triton/python/common/linear/sgl_linear_bf16_outfp32.py`。本文基于已归档VCS实验及最新OL1反馈分析，不包含新的性能测试。

## 1. 当前交付与结论

当前最优已验证方案将固定M1 LM-head合同从 **10514 cycles降到9425 cycles**，延迟下降 **10.36%**、加速 **1.11554×**；400 MHz下从 **26.285 μs降到23.5625 μs**。原定2×目标5257 cycles未达到。

交付的典型最优实现为[sgl_linear_bf16_outfp32_m1_best.py](kernels/sgl_linear_bf16_outfp32_m1_best.py)。它是当前生产文件的完整原样副本，与最终封存`e14_final/source.py`逐字节相同，包含kernel、包装入口、LocalMem pack和其它原有分支；其中本文讨论的是自动分派的M1专用路径。

```text
源码 SHA256：
b043fdb54448bb0459fa9a660d3fddc1dc1d0eb131bc3544c347c1de0d50e2e2
```

该源码的最终生成代码段与最佳E12实测版本一致。**9425来自E12任务b8502c46ecdb的完整全局对齐证据**；最终精简版本另一次复核数值通过、单核时序一致，但缺全局对齐sidecar，不将其称作第二次精确测得9425。

“不能继续优化”在本文中的准确含义是：**在当前M1/w1/k1执行映射、完整K归约和严格数值合同不变时，已测软件调度、tile和分组选项没有突破1015-cycle稳态节拍；继续只消减外围开销不足以支持2×。** 这不是证明所有合法ISA/布局优化均不可能。

## 2. 适用的业务合同与计时范围

| 项目 | 本次已验证范围 |
|---|---|
| 数学运算 | `input[1,4096] @ weight[8448,4096].T` |
| 输入、权重 | BF16 |
| 输出ABI | FP32 `[1,8448]`，保留全部8448个结果 |
| 数值可见性 | `BF16_VISIBLE=1`：FP32 dot/必要加法后经BF16再扩展FP32 |
| 核数 | 2，各处理4224输出通道 |
| 分块 | 每核8个N512完整块和1个N128尾块；每个dot覆盖完整K4096 |
| 权重布局 | 原normal LocalMem packed ABI，两核各33 MiB，无新增布局转换 |
| 运行环境 | 同一封存simv及冻结编译器，MC模式，400 MHz |
| 性能边界 | 最早first_accept到最晚task_done的对齐observer时间 |

上述时间不包含host侧初次pack、权重预装和Python启动，不能当作应用端到端延迟。源码副本不含输入、权重数据或zbin，仍依赖原Torch-Zeus/Triton环境。

专用分支要求`bf16_visible=True`且`(M,N,K,core_num)=(1,8448,4096,2)`。普通FP32可见性、其它shape和核数不属于9425性能结论。已有显式wide入口优先于该自动分派；复现本方案时保持`ZEUS_LINEAR_OUTFP32_WIDE`未设置或关闭。

## 3. 优化效果：收益发生在哪里

| 指标 | baseline | 最佳E12 | 变化 |
|---|---:|---:|---:|
| VCS任务 | `8fcf4f964721` | `b8502c46ecdb` | 相同固定合同 |
| 全局对齐cycles | 10514 | **9425** | **−1089** |
| 耗时/μs，400 MHz | 26.2850 | **23.5625** | −2.7225 |
| core0/core1 cycles | 10281 / 10514 | 9290 / 9425 | −991 / −1089 |
| 每核VP命令数 | 36 | 18 | 减半 |
| 完整N512稳态完成间隔 | 1015 | **1015** | 未改变 |
| 8448输出逐位比较 | PASS | PASS | 原golden保留 |
| mailbox / 双核trace | PASS / complete | PASS / complete | 无放宽门禁 |

这里10.36%是延迟下降；1.11554×相当于固定工作量吞吐提高约11.55%，两者分母不同。

沿最后完成的core1，以互不重叠时间段记账：

| 阶段/cycles | baseline | E12 | 节省 |
|---|---:|---:|---:|
| first_accept→首PE开始 | 775 | 569 | 206 |
| 首PE开始→末PE完成 | 9266 | 8486 | 780 |
| 末PE完成→task_done | 473 | 370 | 103 |
| 合计 | **10514** | **9425** | **1089** |

该分解说明优化缩短了准备、PE工作在外层排程中的跨度和收尾，但不能把780解释为MAC本身加快。PE跨度可能包含等待并与VP/ST重叠；首部和尾部也不是纯LD或全部VP/ST时间。

## 4. 保留下来的优化方法

### 4.1 固定合同分派与一块前看

专用分支静态展开每核输出块，保留独立`previous/current`结果。在处理上一块的舍入/存储前，先表达下一块dot，让后端有机会重叠PE、VP、ST：

```python
# 排程示意，完整实现见所附py；不是另一个经过VCS验证的kernel。
previous = dot(full_K, tile_0)
for tile in remaining_full_tiles:
    current = dot(full_K, tile)
    postprocess_and_store(previous)
    previous = current
tail_dot = dot(full_K, tail)
postprocess_and_store(previous)
postprocess_and_store(tail_dot)
```

激活在每核该M块内一次`tl.load`并保持存活，供后续dot使用；这不等于每个AL1永久驻留完整激活。`previous/current`的独立SSA生命周期交给后端同步和分配处理，没有手工复用仍在读的结果缓冲。

仅“一块前看”实验E05并未提速，说明收益不能全部归给这个写法；最终有效方案是前看、固定合同控制简化与局部descriptor等改动的组合。

### 4.2 简化完整K单次控制，保留数值保护

每个输出仍由一条完整K4096的dot完成，不拆K。固定合同用`PIPELINE_K=4096`专门化形状和描述符运算。

BF16可见结果仍保留FP32加法：以运行时ABI参数`K-STATIC_K`构造合同下精确为零的accumulator，再加dot，最后转BF16并扩展FP32。这样消除原单次K循环的控制开销，同时保留防止后端将dot/cast融合为饱和BF16结果的保护，以及原有零值相关行为。

不能将此写法泛化为任意K：专用路径依赖入口保证K4096与constexpr一致。也不能直接删去FP32加法，只因数学上加零等价就认定浮点特殊值和编译器融合行为相同。

### 4.3 使用局部输出descriptor

已知每个完整块及尾块均在界内，将输出descriptor描述为当前tile的局部区域，基址包含核偏移和tile偏移，减少全局边界/描述符控制。

当前分支严格限制`BLOCK_M=1`，局部descriptor使用`strides=(WIDTH,1)`在单行上与全局N stride等价。**不能直接放开为M2/M4**：多行必须使用正确的全局N行跨度；此前M2/M4诊断任务对此单独做过修正。

### 4.4 保持normal权重及原归约语义

保持原打包字节、每核权重归属和物理ABI；按输出块选择权重地址，不新增每次调用repack/decode。当前最佳源码不保留失败布局或临时实验开关。

没有修改编译器、RTL、时钟或仿真时间模型，也没有减少输出、换golden、放宽误差阈值来获得性能。

## 5. 为什么目前难以继续显著提速

### 5.1 指令级外围优化没有改变稳态

完整N512块仍以1015cycles完成。已有trace中下一条PE命令生命周期在上一条完成前就已开始，软件没有明显“算完才发下一条”的空档；但生命周期提前不等于所有内部依赖已满足。

已有连续PE诊断把主要VP/ST后处理移到PE批次之后，仍出现1015节拍，说明外部VP/ST交错不是该节拍的必要原因。仅增加在途PE命令、增大tile或继续削减CT/VP控制，没有现成证据支持大幅改变它。

### 5.2 最新RTL分析：OL1累加反馈限制独立链吞吐

PE不仅做乘法，还要将每个C片段的部分和累加到OL1。当前本地RTL中，累加必须读取旧部分和，经过三级FP32流水写回，再由寄存credit使旧和可读；同一条链理想情况下约每4拍继续一次。

```text
旧部分和 → 加上当前片段部分和 → 三级流水写回OL1
    ↑                                  ↓
    └──── 下一拍取得可用credit后继续 ──────┘
```

M1实际为KC BF16、w1/k1/c32。每个ALU内有效独立累加链少，即使权重和激活均充分，反馈依赖也可反压前面的MAC及WL1接收。跨不同ALU有大量并行输出，不代表每个ALU自身有足够交错链。

数学K4096对应64个C64轮次，每组覆盖128个输出通道。局部控制模型由3级流水和寄存credit直接推导：

```text
每组输入窗口 = 1个首轮 + 63个依赖轮次×4 = 253 cycles
M1局部窗口 = (N/128)×253 + 3个末端流水周期
```

| 每条PE输出规模 | 局部模型 | 实测稳态间隔 |
|---|---:|---:|
| N128 | 256 | 256 |
| N512 | 1015 | 1015 |
| N1024 | 2027 | 2027 |

模型没有拟合额外等待参数，三个N规模同时吻合，是OL1反馈结构性解释的强证据。它仍是局部Python控制模型，不是完整RTL仿真或冻结simv内部逐拍验证；模型窗口与PE完成间隔边界不同，不能宣布其它等待均为零或已经证明唯一瓶颈。

### 5.3 为什么512-cycle供数下界不是可达承诺

单核N512/K4096权重4 MiB；纯算术下界256cycles，按双hub接口满速假设得到供数下界512cycles。取max只能给出**未纳入OL1反馈依赖**的容量下界，不能据此认定现有M1实现应达到512。

原接口Roofline还需叠加独立累加链与反馈延迟约束。对长归约的近似：

```text
P_feedback(L) ≈ P_peak × min(L/4, 1)
P_cap ≈ min(P_peak, B_weight×Iw, P_feedback(L), 其它约束)
```

L是每ALU有效独立链数，Iw是权重边界算术强度；二者不是通用恒等关系。M1/k1下L约1，约25%的算术容量比可以由反馈解释；“仅为理想接口上限50%”不等同于MC带宽利用率只有50%。

![OL1反馈、原容量与实测对照](artifacts/pe_roofline_ol1_20261022/pe_roofline_measured_ol1.png)

完整推导、硬件独立容量曲线族和局部模型边界见[PE分析文档第13节](PE_ROOFLINE_ANALYSIS_20261022.md#13-代入实际-isa-后的-ol1-反馈节拍推导2026-10-22补充)。

### 5.4 只去除外围开销，不能达到原2×目标

若保持当前每核PE跨度8486不变，即使把E12的首部569和尾部370全部消除，最多也仅能从9425降到8486，约 **1.111×进一步加速**；这只是乐观的条件估算，首尾成本并非实际可全部删除。

原目标5257低于该固定PE跨度，因此要接近2×必须改变指令内部执行节拍或工作映射。8486不是所有合法ISA方案的硬件下限；更不能把原始实验8/8预算结束当成优化空间已被数学穷尽。

## 6. 已测试方向与排除范围

| 方向 | 结果 | 当前判断 |
|---|---|---|
| 仅前看流水，E05 | 10915cycles | 单独采用无收益 |
| c64，E06 | 10589cycles，稳态仍1015 | 当前M1分组调整未隐藏反馈依赖 |
| K常量化，E07 | 10585cycles | 单独常量化不足以改善整体 |
| N128，后续诊断 | 全局9550；四块稳态1024 | 比E12慢，不替换N512 |
| N1024，旧E03流水 | 稳态2027；全局仅有≥10610下界 | 单纯合并tile基本不改善单位输出吞吐 |
| E12+N1024，E13 | 仅本地PASS | 没有远端性能结论 |
| 整核V-cache，E16 | 22050cycles，稳态2543 | 该具体布局退化；不外推全部V-cache方案 |
| 已测split-K | 消去探针全8448输出错误 | 改变归约顺序，违反本次数值合同 |
| 已测KW路径 | 固定golden三项不一致，max_abs 0.0009765625 | 该实现不满足严格逐位要求 |
| Cu64、mtk>1 | 有既有退化证据，本轮未新增远端验证 | 未证明所有此类配置非法或永远无收益 |

表中VCS任务与证据详见[RESULTS快照](artifacts/m1_optimization_20261022/RESULTS_snapshot.md)。其中较早的“主要受权重供数限制”是历史模型判断，应结合本报告及最新OL1反馈推导阅读，不能当作已测得的MC瓶颈。

## 7. 仍可能存在的优化空间

业务允许真实多行合并时，M2/M4已显示吞吐收益：相对M1，全算子每行吞吐约 **1.943×/3.341×**。增加独立行累加链可隐藏部分反馈延迟，同时复用权重。其输入是多个真实内存行，不是将单行复制若干次后丢弃输出；增加批处理不能直接降低原M1延迟。

若必须保持M1，值得探索的是：现有ISA和权重布局能否让**同一ALU交错多个独立输出通道**，保持每个输出的完整K归约顺序，从而隐藏OL1反馈延迟。MTK/布局联合调整属于待验证方向，没有可直接替换当前实现的已验证候选。现有正确性、供数和数值限制都必须保留。

因此当前交付结论是：保留E12等价M1专用实现；继续扫描外层tile、CT同步或指令数量的优先级较低。新的显著收益应以改变独立累加链组织为依据，而不是承诺通过外围排程将1015直接减半。

## 8. Python实现入口、使用条件及复现

完整源码：[kernels/sgl_linear_bf16_outfp32_m1_best.py](kernels/sgl_linear_bf16_outfp32_m1_best.py)。主要位置：

| 函数/分支 | 作用 |
|---|---|
| `_pipeline_dot` | 从normal LocalMem权重构造tile并做完整K dot |
| `_pipeline_store` | 保留数值保护，BF16可见转换及局部descriptor存储 |
| `sgl_linear_bf16_outfp32_lmem_kernel`的`if PIPELINE_N` | 单行固定合同的一块前看主路径 |
| `linear_bf16_outfp32` | shape、visibility与核数检查及自动分派 |
| `linear_bf16_outfp32_bf16_visible` | 本次LM-head使用的BF16可见包装入口 |
| `pack` | 原LocalMem权重打包合同 |

普通包装入口默认`bf16_visible=False`，不会自动等同于本次已测LM-head合同。调用时使用BF16可见入口或显式传`bf16_visible=True`。核心启动常量为：

```python
CORE_NUM = 2
BLOCK_M = 1
BLOCK_N = 512
BLOCK_K = 4096
BF16_VISIBLE = 1
PIPELINE_N = 8448
PIPELINE_K = 4096
WEIGHT_ROW_ALIGN = 64
```

副本保留生产模块内容和函数名，没有改变kernel实现。改名后的副本未重新做VCS；性能依据是它与生产/封存源码相同，以及封存生成代码段等价。它不是可用普通CPU/CUDA Triton直接执行的独立基准程序。

复现使用原冻结工具链与生产capture工作流，参考[复现说明快照](artifacts/m1_optimization_20261022/REPRODUCE_snapshot.md)。冻结zecc SHA为`a138e477d7b8f8d6d5dbf690a352bebb617a096fcd266d93a2d0dd85eba5d3c3`。换编译器、pack或数值融合策略后，需要重新验证，不能沿用9425结论。

## 9. 正确性与验证证据

- E12固定输入的8448个FP32输出与原golden逐位一致，162 mailbox字段全零，双核trace及全局对齐完整。
- 最终生产源码生成代码段与E12相同；最终复核`05b2b1fc6ce1`输出和mailbox通过，每核9290/9425复现，但缺全局对齐，精确全局cycles记为null。
- 归档的实际仓库20项pytest通过；8组shape/visibility分派与独立baseline逐位一致；扩展Inf/NaN、±0、BF16 ties、溢出/消去及underflow/invalid-product验证为本地C++证据，不冒充特殊值RTL覆盖。
- 严格同步检查记录47 plans/94 events VERIFIED且no-fallback；未手工删除mail或覆盖物理缓冲生命周期。
- 本次文档交付仅核对SHA、归档副本及Python语法，没有新运行VCS、修改生产源码或重新执行上述历史测试。

| 证据 | 文件 |
|---|---|
| 本报告数值、SHA和来源清单 | [summary.json](artifacts/m1_optimization_20261022/summary.json) |
| 最佳方案选择 | [BEST.json](artifacts/m1_optimization_20261022/BEST.json) |
| E12完整时序/数值 | [E12_analysis.json](artifacts/m1_optimization_20261022/E12_analysis.json) |
| 最终复核及对齐限制 | [E14_analysis.json](artifacts/m1_optimization_20261022/E14_analysis.json) |
| 生成代码段等价 | [code_equivalence.json](artifacts/m1_optimization_20261022/code_equivalence.json) |
| 阶段分解 | [stage_breakdown.json](artifacts/m1_optimization_20261022/stage_breakdown.json) |
| 数值及同步审阅 | [final_code_review.md](artifacts/m1_optimization_20261022/final_code_review.md) |
| RTL/容量/OL1完整推导 | [PE_ROOFLINE_ANALYSIS_20261022.md](PE_ROOFLINE_ANALYSIS_20261022.md) |
