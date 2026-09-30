# gemm_normal_dense_bf16xbf16_bf16dst_bf16acc_128x128x128_2core Kernel 与汇编匹配分析

## 1. 分析对象

- Kernel 源文件：`/home/zhangds/workspace/triton_shared/python/zeus_business_kernels/dense_ffn/gemm_normal_dense_bf16xbf16_bf16dst_bf16acc_128x128x128_2core.py`
- 测试目录：`/home/zhangds/workspace/test_kernel/gemm_normal_dense_bf16_128x128x128_2core/`
- 本次 CASE 参数：`M=128, K=128, N=256`，双核执行。
- 文本汇编：`core0.disasm`、`core1.disasm`；对应的 `.inst` 是二进制指令流，不能直接按文本阅读。

## 2. Kernel 算法

该 kernel 实现矩阵乘法：

```text
C[M,N] = A[M,K] × B[K,N]
```

输入和输出均为 BF16；`tl.dot` 的结果转换为 BF16 后累加。两个 core 沿 N 维切分：每个 core 负责 `N_per_core = N / 2` 列。权重指针从 `w_ptr_list[core_id]` 读取，因此 core 0 和 core 1 使用各自的权重分片。

执行步骤如下：

1. 读取 `core_id`，计算 `N_per_core` 以及 M/N/K 三个方向上的 block 数。
2. 为 A、B 和 C 构造 block pointer：
   - A 的逻辑形状为 `(M,K)`，步长 `(K,1)`；
   - 每个 core 的 B 权重形状为 `(N_per_core,K)`，存储时后续转置参与乘法；
   - C 的形状为 `(M,CORE_NUM,N_per_core)`，通过 core 维偏移写入完整输出 `(M,N)`。
3. 对每个 M block、N block 初始化 `BLOCK_M × BLOCK_N` 的 BF16 累加器为零。
4. 遍历 K block，加载 A tile 和权重 tile；边界位置用 zero padding。
5. 计算 `A_tile × transpose(B_tile)`，将结果转成 BF16，并累加到累加器。
6. 将累加器写回 C 的当前 tile。

本例的编译常量为：`CORE_NUM=2`、`BLOCK_M=128`、`BLOCK_K=128`、`BLOCK_N=128`。因此在 `M=128,K=128,N=256` 的 CASE 中，每个 core 实际执行 1 个 M tile、1 个 N tile、1 个 K tile；汇编仍保留通用循环和边界分支。

## 3. 编译中间表示

生成的 ZeusHigh MLIR 文件为：

`/home/zhangds/workspace/triton_shared/python/zeus_business_kernels/dense_ffn/out/gemm_normal_dense_bf16xbf16_bf16dst_bf16acc_128x128x128_2core__M128_K128_N256_N_per_core128_N_total256_K_per_core64_run_pid3182544/gemm_normal_dense_bf16xbf16_bf16dst_bf16acc_128x128x128_2core.zeushigh.mlir`

其中关键结构是：

- `arith.divsi` 计算 `N/2`；
- 外层 M/N 循环和内层 K 循环；
- `zeus_high.vp op_type="fill"` 初始化累加器；
- `zeus_high.pe op_type="matmul"` 执行 tile 矩阵乘；
- `zeus_high.vp op_type="add"` 完成累加；
- `zeus_high.store` 写回输出。

该 MLIR 为源代码算法到硬件指令的中间桥梁。

## 4. 汇编分析

### 4.1 双核划分与参数准备

`core0.disasm` 开头以 `CT_MOV_R_I ... Imme[0]` 设置 core ID 0；`core1.disasm` 对应位置为 `Imme[1]`。随后通过 `LD_MOV`、`CT_VMOVM` 等指令读取 kernel 参数和指针，并用 CT 算术指令及条件跳转计算 `N_per_core`、ceil-div block 数和循环边界。

这与源代码的 `tl.program_id(0)`、`N // CORE_NUM` 和 `tl.cdiv` 对应。

### 4.2 累加器及 descriptor 初始化

汇编中出现 `VP_MAIL`、`VP_STSR`，并设置 A/B/C 的 block descriptor。descriptor 中可以看到 128×128 tile 的形状字段（例如 `W[127]`、`C[127]`）。这些指令对应 `tl.zeros((128,128), dtype=bf16)` 和 `make_block_ptr`。

### 4.3 A 和权重加载

两份反汇编均包含 `LD_MOV`、`LD_MAIL` 以及权重模式的 `CT_SETBM_AM_W`、`CT_SETBM_S_W`、`CT_SETBM_T_W`。其中输入 A 使用片上 buffer（反汇编中可见 `BRx[5]` 和 128 tile 大小），权重 descriptor 使用每个 core 的权重地址。这对应：

```python
a_tile = tl.load(..., boundary_check=(0, 1), padding_option="zero")
b_tile_nk = tl.load(..., boundary_check=(0, 1), padding_option="zero", memory_type="weight")
```

### 4.4 PE 矩阵乘和 VP 累加

每个 core 的主体都包含：

```text
PE_SETM_M ... WBS[7] MTW[3] MTK[0] MTC[1]
PE_SETM_U ...
PE_CONV ...
VP_DTSR ...
```

`PE_SETM_M/PE_SETM_U` 配置 PE 的矩阵操作；`PE_CONV` 发起矩阵乘；`VP_DTSR` 接收并处理 PE 结果。其后配套的 `VP_MAIL`、`PE_MAIL`、`LD_MAIL` 完成 PE、VP、LD 之间的数据同步。该结构与 MLIR 中的 `zeus_high.pe op_type="matmul"` 以及后续 `zeus_high.vp op_type="add"` 一致。

### 4.5 输出写回

尾部可见 `CT_SETBM_AM_A`、`CT_SETBM_S_A`、`CT_SETBM_T_A`，其 descriptor 形状字段包含 `SH[127]`、`SW[1]`，随后由 `ST_MOV ... BRy[9] BRa[8]` 发起存储。输出地址包含 core 维偏移，因此 core 0 写 N 的前 128 列，core 1 写后 128 列。这对应源代码的 C block pointer 和 `tl.store`。

### 4.6 循环和结束

反汇编中有 `CT_JMP`、`CT_JGE`、`CT_JL` 等循环/边界控制指令，末尾为 `CT_ED`。这些指令对应 M、N、K 三重循环和 kernel 结束。虽然本 CASE 每个方向只有一个 tile，通用循环控制仍会被编译保留。

## 5. core0 与 core1 对照

两份反汇编的主体结构相同，差别主要是：

- core ID 常量分别为 0 和 1；
- 权重和输出地址使用不同的 core 分片/偏移；
- 少量 prologue 指令和地址因核间初始化不同而有偏移。

这正是双核沿 N 维分块的预期结果，不是算法不一致。

## 6. 仿真结果与结论

该 CASE 已完成 prepare-only、functional simulator 和 verify-only。`verify-only` 返回 `PASS OK`；`golden_output.bin`、`output.bin` 和 `simu_out0.bin` 均为 65536 字节，SHA256 均为：

`512aee854c75cdd1a7e0498f60c97191ca5f80e48698a5af4ad480234c72b346`

因此可以得出：

**在 `M=128,K=128,N=256` 这个 CASE 上，汇编与 kernel 算法执行步骤匹配，并且功能仿真结果逐字节通过校验。**

需要保留一个范围说明：本 CASE 只有一个 K tile，尚未验证多 K tile 时 BF16 中间累加的行为。源码在每个 K tile 后把 dot 结果转为 BF16 再累加，而通用 golden 实现通常以 FP32 `matmul` 后统一编码 BF16；如果要覆盖 `K > 128`，建议再增加多 K block CASE，专门检查每个 K tile 的 BF16 截断和累加顺序。

