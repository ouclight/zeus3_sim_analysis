# PE MiniTile 参数配置与 AL1/OL1 约束

## 1. 参数对应关系

对于 GEMM：

```text
C[M, N] = A[M, K_algo] × B[K_algo, N]
```

PE 硬件维度映射为：

```text
W = BLOCK_M
K = BLOCK_N       // PE 的 K 是输出通道维
C = BLOCK_K       // PE 的 C 是规约维
```

MiniTile 参数对应：

| 参数 | 真实尺寸 | 作用 |
|---|---|---|
| `MTW` | `w` | 同时计算多少个 M/W 方向输出行 |
| `MTK` | `k` | 同时计算多少组输出通道 |
| `MTC` | `c` | 同时覆盖多少组规约通道 |

需要特别注意：

```text
MTK 对应 GEMM N
MTC 对应 GEMM K_algo
```

## 2. 属性值和 ISA 编码

ZeusHigh/ZeusLow IR 属性保存真实尺寸：

```text
mtw = w
mtk = k
mtc = c
```

`PE_SETM_M` 的 ISA 字段使用减一编码：

```text
MTW_field = w - 1
MTK_field = k - 1
MTC_field = c - 1
```

例如 IR 中配置：

```mlir
mtw = 4
mtk = 4
mtc = 2
```

最终汇编为：

```asm
PE_SETM_M ... MTW[3] MTK[3] MTC[1]
```

CodeGen 转换位置：

```text
/home/zhangds/triton_shared/lib/Target/ZeusV3/CodeGen/InstructionSelector.cpp
```

当前编译器将对应的 EN/IE 全部置 1：

```text
MTW_EN = MTK_EN = MTC_EN = 1
MTW_IE = MTK_IE = MTC_IE = 1
```

即全部更新且全部使用立即数。

## 3. 为什么受 AL1 约束

AL1 可以理解为 PE 的 Activation/Input L1 Buffer。

一个 MiniTile 在计算时，需要保存：

```text
w 个输出行 × c 个规约分组
```

因此 AL1 占用与下面的乘积成正比：

```text
AL1 occupancy ∝ w × c
```

必须满足：

```text
w × c <= S_AL1
```

当前模型将它写为：

```cpp
w * c <= sIB
```

原因如下：

- `w` 增大：同时驻留更多输入行；
- `c` 增大：每行同时驻留更多规约数据；
- `k` 增大不会复制 Activation，因为同一份 Activation 可以被不同输出通道复用。

所以 AL1 约束的是 `MTW × MTC`，不直接约束 `MTK`。

## 4. 为什么受 OL1 约束

OL1 可以理解为 PE 的 Output/Accumulator L1 Buffer。

一个 MiniTile 需要保存的输出部分和数量为：

```text
w 个输出行 × k 个输出通道组
```

因此：

```text
OL1 occupancy ∝ w × k
```

必须满足：

```text
w × k <= S_OL1
```

当前模型写为：

```cpp
w * k <= sOB
```

原因如下：

- `w` 增大：输出行数增多；
- `k` 增大：并行输出通道数增多；
- `c` 是规约深度，不产生新的输出位置；不同 `c` 分组会累加到同一批 `w×k` accumulator。

所以 OL1 约束的是 `MTW × MTK`，不直接约束 `MTC`。

```text
Activation tile             Partial-output tile
┌──────────── c ────────┐   ┌──────── k ────────┐
│                       │   │                    │
w       存入 AL1        │   w      存入 OL1     │
│                       │   │                    │
└───────────────────────┘   └────────────────────┘

AL1: w × c
OL1: w × k
```

## 5. 不同 dtype 下的容量

当前仓库使用 Capstone 模型中的基准容量：

```text
S_AL1_BASE = 64
S_OL1_BASE = 16
```

根据数据类型缩放：

```text
S_AL1 = 64 / act_bytes
S_OL1 = 16 × weight_bytes / act_bytes
MAC_N_eff = 16 / weight_bytes
```

相关实现：

```text
/home/zhangds/triton_shared/include/triton-shared/Dialect/ZeusHigh/Transforms/PeHWSpec.h
/home/zhangds/triton_shared/lib/Dialect/ZeusHigh/Transforms/SetPeHWParams.cpp
```

常见组合为：

| Act | Weight | `S_AL1` | `S_OL1` | 合法约束 |
|---|---|---:|---:|---|
| INT8/FP8 | INT8/FP8 | 64 | 16 | `w×c≤64`，`w×k≤16` |
| FP8 | INT4 | 64 | 8 | `w×c≤64`，`w×k≤8` |
| BF16 | BF16 | 32 | 16 | `w×c≤32`，`w×k≤16` |

这里的 64、16、32、8 是模型归一化后的 MiniTile 容量单位，不是直接的字节数。

## 6. 具体选值方法

假设计算 Tile 为：

```text
BLOCK_M = W
BLOCK_N = K_hw
BLOCK_K = C_hw
```

首先确定 dtype 对应的：

```text
macNEff
sAL1
sOL1
```

然后枚举真实尺寸：

```text
w >= 1
k >= 1
c >= 1
```

要求同时满足：

```text
w × c <= sAL1
w × k <= sOL1
```

还要避免超过实际计算 Tile：

```text
w <= BLOCK_M

k <= ceil(
    BLOCK_N /
    (N_Core × MAC_N_eff)
)

c <= ceil(
    BLOCK_K /
    (N_PE × MAC_K)
)
```

当前硬件模型：

```text
N_Core = 8
N_PE   = 8
MAC_K  = 16
```

因此：

```text
一个 k 单位覆盖：8 × MAC_N_eff 个输出通道
一个 c 单位覆盖：8 × 16 = 128 个规约通道
```

编译器不是简单选择最大的 `w/k/c`，而是对所有合法组合计算延迟：

```text
T_total =
    decode
  + activation load
  + compute
  + weight stall
  + output writeback
```

选择 `T_total` 最小的组合。延迟相同时优先：

```text
更大的 k
其次更大的 c
最后更大的 w
```

搜索实现在：

```text
/home/zhangds/triton_shared/lib/Dialect/ZeusHigh/Transforms/SetPeHWParams.cpp
```

## 7. 配置示例

假设：

```text
BLOCK_M = 128
BLOCK_K = 256
BLOCK_N = 1024
```

### 7.1 FP8 × FP8

```text
act_bytes    = 1
weight_bytes = 1
S_AL1 = 64
S_OL1 = 16
```

模型搜索结果：

```text
w = 4
c = 2
k = 4
```

缓冲约束：

```text
AL1: w × c = 4 × 2 = 8  <= 64
OL1: w × k = 4 × 4 = 16 <= 16
```

IR 配置：

```mlir
mtw = 4
mtk = 4
mtc = 2
```

ISA 编码：

```text
MTW[3] MTK[3] MTC[1]
```

### 7.2 BF16 × BF16

模型结果：

```text
w = 8
c = 1
k = 2
```

约束：

```text
AL1: 8 × 1 = 8  <= 32
OL1: 8 × 2 = 16 <= 16
```

IR：

```mlir
mtw = 8
mtk = 2
mtc = 1
```

ISA：

```text
MTW[7] MTK[1] MTC[0]
```

### 7.3 FP8 × INT4

模型结果：

```text
w = 8
c = 1
k = 1
```

约束：

```text
AL1: 8 × 1 = 8 <= 64
OL1: 8 × 1 = 8 <= 8
```

IR：

```mlir
mtw = 8
mtk = 1
mtc = 1
```

ISA：

```text
MTW[7] MTK[0] MTC[0]
```

## 8. 配置原则

不能分别把三个参数都设置到最大，因为 `MTW` 同时消耗 AL1 和 OL1：

```text
增大 MTW
 ├─ 压缩可用 MTC：受 AL1 限制
 └─ 压缩可用 MTK：受 OL1 限制
```

例如 INT8 下：

```text
w=16, c=4  → w×c=64，AL1 刚好装满
w=16, k=1  → w×k=16，OL1 刚好装满
```

此时不能继续增加 `c` 或 `k`。

反过来：

```text
w=1, c=64, k=16
```

也同时达到两个缓冲上限，但这种单行、深规约、多输出通道配置未必具有最短执行时间。实际最优值还取决于 BLOCK shape、加载延迟、Weight DRAM 访问和写回开销。

## 9. 验证边界

当前 AL1/OL1 常量和时序公式来自 Capstone 模型，仓库注释仍标记为“待真实 Zeus V3 PE 硬件规格确认”。此外，功能模拟器目前不读取 MiniTile 参数。因此配置结果主要需要通过 RTL/VCS 或真机性能测试验证。
