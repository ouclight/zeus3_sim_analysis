# core0.disasm 与 GEMM 算法执行流程对照分析

## 1. 文件和结论范围

- 反汇编文件：`/home/zhangds/workspace/test_kernel/gemm_normal_dense_bf16_128x128x128_2core/core0.disasm`
- 文件规模：405 行，指令地址范围 `0x00000000`–`0x00000ca0`。
- 对照 kernel：`gemm_normal_dense_bf16xbf16_bf16dst_bf16acc_128x128x128_2core.py`
- CASE：`M=128, K=128, N=256`，`CORE_NUM=2`，所以 core0 负责输出列 `0..127`，`N_per_core=128`。

本报告按源程序执行顺序解释 `core0.disasm`。反汇编中的 `CT_*` 主要负责控制流、地址和 descriptor 计算，`LD_*` 负责加载，`PE_*` 负责矩阵计算，`VP_*` 负责向量/累加和同步，`ST_*` 负责存储。

## 2. 源算法基准

源 kernel 的核心计算为：

```text
C[M,N] = A[M,K] × B[K,N]
```

每个 core 读取 `w_ptr_list[core_id]` 对应的权重分片。A 是 `(M,K)`，每个权重分片按 `(N_per_core,K)` 保存，加载后转置参与 `A_tile × B_tile^T`。算法使用 `128×128×128` tile：初始化 BF16 累加器，遍历 K tile，执行 dot 并累加，最后写回 C 的对应 N 分片。

本 CASE 的 tile 数均为 1：

```text
ceil(M/128) = 1
ceil(N_per_core/128) = 1
ceil(K/128) = 1
```

因此实际运行不会展开多个 M/N/K tile，但生成代码保留通用循环和尾块分支。

## 3. 分段对照

### 3.1 启动、core ID 和参数 descriptor（`0x0000–0x00f0`）

关键指令：

```text
0x0000 CT_ST
0x0008 CT_MOV_R_I Rx[31] Imme[0]
0x0010 CT_SETA IE[1] ARx[30] Addr[284166680]
0x0018 CT_JMP Label[32]
...
0x0040 CT_MOV_R_I Rx[4] Imme[0]
0x0048/0x0060 CT_SETBI_A BRx[0]/BRx[1] Addr[0]
0x0050/0x0068 CT_SETBM_AM_A ...
0x0058/0x0070 CT_SETBS_A ... C[8]
0x0078 LD_MOV ... SendMails[CT]
0x0080 CT_MAIL ... RecvMails[LD]
```

`Rx[31]=0` 是 core0 的核号设置；core1 的对应反汇编位置设置为 1。`CT_SETA` 建立参数区地址，`CT_SETBI/SETBM_*` 建立参数读取所需的地址模式。`LD_MOV` 从参数区取出参数/指针，并用 CT/LD mailbox 同步。

这对应源代码中的 `core_id = tl.program_id(0)`、kernel 参数读取和 `w_ptr_list` 访问准备。该段没有执行 GEMM，而是在为后续计算准备寄存器和寻址状态。

### 3.2 计算 `N_per_core`、block 数及边界（`0x0098–0x0358`）

该段密集使用 `CT_VMOVM_R_VR[I]`、`CT_SUB*`、`CT_ADD*`、`CT_ASR/LSR`、`CT_MULU` 和 `CT_JL/JGE/JO`：

```text
0x0098–0x00f0  从向量寄存器/参数区提取 M、K、N 和相关步长
0x00f8–0x0120  比较并选择循环/尾块路径
0x0150–0x0218  整数除法、ceil-div 和 tile 尺寸计算
0x0220–0x0250  计算按 128 元素缩放后的地址/计数
0x0270–0x0358  M/N/K 边界判断和块尺寸选择
```

其中多处 `Imme[127]`、`Imme[128]`、`Imme[64]` 与 128 tile、元素/字节寻址和边界修正有关。`CT_JL`、`CT_JGE` 等分支实现 `tl.cdiv` 对应的整除/尾块处理。

对当前 CASE，M、K、`N_per_core` 都等于 128，因此主路径选择完整 tile（而不是小于 128 的尾 tile）。这与源代码的 `tl.cdiv(M, BLOCK_M)`、`tl.cdiv(N_per_core, BLOCK_N)`、`tl.cdiv(K, BLOCK_K)` 相符。

### 3.3 累加器清零和 C tile descriptor（`0x0368–0x0430`）

关键指令：

```text
0x0368 ST_MAIL SendMails[VP]
0x0370 VP_MAIL SendMails[VP]
0x0380–0x03b8  M/N tile 循环计数判断
0x03c0 CT_MULU_R_R_I Rx[5] ... Imme[128]
0x03c8 CT_SETBI_A BRx[2] Addr[0]
0x03d0 CT_SETBM_AM_A ... BRx[2] ... DF[5]
0x03d8 CT_SETBS_A ... W[127] C[127]
0x03e0–0x03f8  BRx[3] 的 A/输出形状和步长 descriptor
0x0400 CT_SETBM_PI_A ...
0x0430 VP_STSR CSS[4] BRx[3] BRa[3]
```

`W[127] C[127]` 表明当前计算 tile 的宽度/通道维为 128。`VP_STSR` 将 VP 侧状态/存储资源初始化，并通过 mailbox 与 VP/ST 协同；其功能对应 `acc = tl.zeros((BLOCK_M, BLOCK_N), dtype=tl.bfloat16)` 以及输出 tile descriptor 准备。

### 3.4 权重 descriptor 和 A/权重加载准备（`0x0438–0x04d0`）

关键指令：

```text
0x0490 CT_SETBM_AM_W ... BRx[4] ...
0x0498 CT_SETBM_AM_W ... BRx[4] ... DF[5]
0x04a8 CT_SETBM_S_W ... SK[127] SC[27]
0x04b0 CT_SETBM_T_W ... TK[127] TC[127]
0x04c0 CT_SETBM_T_A ... BRx[2] ... TW[27]
0x04c8 PE_MAIL SendMails[LD]
0x04d0 VP_MAIL SendMails[PE]
```

`BRx[4]` 是权重访问 descriptor：`SK[127]`、`TK[127]` 显示 K 方向和 tile 方向均配置为 128；`SC[27]` 是权重分片的列/通道寻址偏移。`PE_MAIL` 和 `VP_MAIL` 把权重加载、PE 运算和 VP 累加串起来。

这对应：

```python
b_tile_nk = tl.load(weight_ptr, boundary_check=(0, 1),
                     padding_option="zero", memory_type="weight")
```

### 3.5 A tile 片上缓冲和加载循环（`0x04d8–0x07e8`）

关键指令：

```text
0x0518 VP_MAIL SendMails[VP]
0x0520 CT_MULU_R_R_I Rx[9] ... Imme[128]
0x0528 CT_SETBI_A BRx[5] Addr[32768]
0x0530 CT_SETBM_AM_A ... BRx[5] ... DF[5]
0x0538 CT_SETBS_A ... W[127] C[127]
...
0x05f0 CT_SETBM_T_A ...
0x0600–0x0798 大量 CT 位移、掩码、乘法、加法
0x07a0/0x07a8 CT_SETBM_AM_A ... BRx[6]
0x07b8 CT_SETBM_S_A ... SW[127] SC[28]
0x07c0 CT_SETBM_T_A ... TW[127] TC[127]
0x07e0 CT_SETBM_PI_A ...
0x07e8 LD_MOV ... BRx[5] BRa[6] SendMails[PE]
```

`BRx[5] Addr[32768]` 设置 A tile 的片上缓冲基址；`W[127] C[127]` 说明 A tile 为 128×128。`BRx[6]` 是 PE/VP 之间使用的中间 tile descriptor。`0x0600–0x0798` 虽然没有显式的高级指令名，但其位移、掩码、乘法和加法是在计算实际基址、stride、half/BF16 元素地址和 mailbox 参数，并非额外的矩阵算法。

`LD_MOV ... SendMails[PE] RecvMails[PE]` 表示 LD 将 A/权重数据送入 PE，同时等待 PE 侧资源；这对应源代码中的两个 `tl.load`。

### 3.6 PE 矩阵乘（`0x07f0–0x08b0`）

关键指令：

```text
0x07f0 CT_SETBI_A BRx[7] Addr[65536]
0x07f8/0x0800 CT_SETBM_AM_A / CT_SETBS_A ... W[127] C[127]
0x0860 CT_SETBM_T_W ...
0x0868 CT_SETBM_PI_W ... PIC[9]
0x0870 CT_SETBM_T_A ...
0x0888–0x0898 CT_SETBM_AM_A / CT_SETBM_AM_W
0x08a0 PE_SETM_M ... WBS[7] MTW[3] MTK[0] MTC[1]
0x08a8 PE_SETM_U ...
0x08b0 PE_CONV CM[2] BRx[7] BRa[5] BRb[4]
```

`BRx[7] Addr[65536]` 配置 PE 输出/中间 tile 的资源，多个 `CT_SETBM_*` 配置 A、权重和结果的形状及步长。`PE_SETM_M` 选择矩阵乘模式和 tile 参数，`PE_SETM_U` 设置 PE 微操作资源，`PE_CONV` 正式发起计算。`BRa[5]` 和 `BRb[4]` 分别对应 A tile 和权重 tile，因此该指令组直接对应：

```python
c_tile = tl.dot(a_tile, tl.trans(b_tile_nk)).to(tl.bfloat16)
```

### 3.7 VP 接收和累加（`0x08b8–0x0968`）

关键指令：

```text
0x08b8 CT_SUBU_R_R_I ...
0x08c8 VP_SETM_LUT ...
0x08d0 VP_SETM_CMD ...
0x08d8 VP_SETM_CFS ...
0x08e0 VP_DTSR CSS[4] BRx[2] BRa[2] BRb[7]
0x08e8–0x08f8 更新 K/循环计数并跳转
0x0900 VP_MAIL SendMails[ST]
0x0908 VP_MAIL SendMails[VP]
0x0910 LD_MAIL ... RecvMails[PE]
0x0918 PE_MAIL ... RecvMails[VP]
```

`VP_DTSR` 从 PE 结果 descriptor（`BRb[7]`）取数，并与累加器 descriptor（`BRa[2]`）进行 VP 侧处理；`VP_SETM_*` 设置 VP 的数据通路。其后 mailbox 指令保证 PE、LD、VP、ST 的时序。该段对应源代码的 `acc += c_tile`。

由于本 CASE 只有一个 K tile，K 循环在一次 `PE_CONV`/`VP_DTSR` 后结束；对于更大的 K，`0x08e8–0x08f8` 所在回跳路径会再次装载 K tile 并累加。

### 3.8 输出 descriptor 和 store（`0x0968–0x0c78`）

关键指令：

```text
0x09b8 CT_SETBI_A BRx[8] Addr[0]
0x09c0 CT_SETBM_AM_A ... BRx[8] ... DF[5]
0x09c8 CT_SETBS_A ... H[127] W[0] C[127]
0x09e0 CT_SETBM_T_A ... TH[27] TC[28]
0x0c10 CT_SETBM_AM_A ... BRx[9]
0x0c18 CT_SETBM_AM_A ... BRx[9] ... DF[5]
0x0c28 CT_SETBM_S_A ... SH[127] SW[1] SC[28]
0x0c30 CT_SETBM_T_A ... TH[127] TW[0] TC[127]
0x0c50 CT_SETBM_PI_A ... BRx[9]
0x0c58 ST_MOV DDE[1] ARx[29] BRy[9] BRa[8] SendMails[VP]
```

`BRx[8]` 描述待存储的累加结果，`BRx[9]` 描述全局输出地址和步长。`SH[127]`、`TH[127]` 表示输出行方向 tile 高度为 128；`SW[1]` 体现输出布局的 N/通道步长；`ST_MOV` 将 VP 中的累加结果写回全局 C。

core0 的输出基址和通道偏移对应 N 的前半部分，即逻辑范围 `C[:,0:128]`。这与源代码中 C block pointer 的 offsets `(0, core_id, 0)` 及最终 `tl.store` 相符。

### 3.9 N/M 循环回跳和结束（`0x0c60–0x0ca0`）

```text
0x0c60 CT_ADD_R_R_I Rx[26] Ra[23] Imme[1]
0x0c68 CT_MOV_R_R Rx[23] Ra[26]
0x0c70 CT_JMP Label[4294965008]
0x0c78 VP_MAIL ... RecvMails[VP]
0x0c80 VP_MAIL ... RecvMails[ST]
0x0c88 CT_ADD_R_R_I Rx[26] Ra[22] Imme[1]
0x0c90 CT_MOV_R_R Rx[22] Ra[26]
0x0c98 CT_JMP Label[4294964632]
0x0ca0 CT_ED
```

这里更新 N/M block 计数并回跳到前面的循环入口；循环完成后等待 VP/ST mailbox，最后 `CT_ED` 结束 kernel。当前 CASE 只有一个 M block 和一个 N block，所以运行时每个回跳只需通过一次终止判断。

## 4. 算法—汇编对应关系汇总

| 算法步骤 | 主要汇编位置 | 对应证据 |
|---|---:|---|
| 获取 core0、读取参数 | `0x0008–0x0080` | `Rx[31]=0`、`LD_MOV`、参数 descriptor |
| 计算 `N_per_core`/ceil-div | `0x0098–0x0358` | CT 算术、`CT_JL/JGE/JO`、常量 127/128 |
| 初始化累加器 | `0x0368–0x0430` | `VP_STSR`、128×128 descriptor |
| 配置并加载权重 | `0x0438–0x04d0` | `BRx[4]`、`SK/TK[127]`、`PE_MAIL` |
| 配置并加载 A tile | `0x0518–0x07e8` | `BRx[5] Addr[32768]`、A tile 128×128、`LD_MOV` |
| PE dot/matmul | `0x07f0–0x08b0` | `PE_SETM_M`、`PE_SETM_U`、`PE_CONV` |
| VP 累加 | `0x08b8–0x0918` | `VP_SETM_*`、`VP_DTSR`、同步 mailbox |
| C tile 写回 | `0x09b8–0x0c58` | 输出 descriptor、`ST_MOV` |
| 循环和结束 | `0x0c60–0x0ca0` | `CT_JMP`、mailbox、`CT_ED` |

## 5. 判断

`core0.disasm` 与 kernel 的算法流程是匹配的：

1. 通过 `Rx[31]=0` 明确 core0 身份；
2. 通过 CT 算术和分支实现 block 划分/边界处理；
3. 通过 descriptor 配置表达 128×128×128 tile；
4. 通过 LD/PE/VP 的 mailbox 链路完成 A、权重加载、PE dot 和累加；
5. 通过输出 descriptor 与 `ST_MOV` 写回 core0 的 N 分片；
6. 通过循环回跳和 `CT_ED` 完成 kernel 生命周期。

结合该 CASE 已有的 `verify-only: PASS OK`，以及 golden/output/simulator 输出逐字节一致，可以确认该反汇编在当前 `M=128,K=128,N=256` 场景下实现了预期算法。

## 6. 注意事项

这是针对当前 CASE 的静态反汇编对照，不等同于对所有动态形状的形式证明。特别是当前 `K=128` 只有一个 K tile；若验证 `K>128`，应增加多 K tile CASE，检查 `VP_DTSR` 回跳路径上的 BF16 中间截断和累加顺序。源代码是在每个 K tile 的 dot 结果转成 BF16 后累加，而单 K tile CASE 无法覆盖这一差异。

