# PE_SETM_M 指令 MT 参数分析

## 1. 结论

`PE_SETM_M` 中的 `MTW`、`MTK`、`MTC` 用来配置一次 `PE_CONV` 内部的 MiniTile 计算分块。它们主要影响 PE 利用率、输入/输出缓冲占用、数据复用和执行周期，并不直接表示 GEMM 的整体形状。

仓库中最明确的语义来源是尚未合入当前 `master` 的分支 `origin/wt/minitile-search`，对应提交：

```text
d2cabd7 feat(SetPeHWParams): search PE minitile via Capstone timing model [CONTRACT]
```

该提交明确了 MT 参数与 GEMM 维度的映射、缓冲约束和减一编码契约。

## 2. GEMM 与 PE 维度映射

对于标准 GEMM：

```text
A[M, K_algo] × B[K_algo, N] → C[M, N]
```

Zeus PE 使用的硬件维度命名如下：

| GEMM 维度 | PE 维度 | 指令字段 | 含义 |
|---|---|---|---|
| `M` | `W` | `MTW` | 一次 MiniTile 处理的输出行或 batch 位置数量 |
| `N` | `K` | `MTK` | 一次 MiniTile 处理的输出通道组数量 |
| `K_algo` | `C` | `MTC` | 一次 MiniTile 覆盖的规约或输入通道组数量 |

即：

```text
BLOCK_M → W → MTW
BLOCK_N → K → MTK
BLOCK_K → C → MTC
```

需要特别注意，PE 的维度命名与通常的 GEMM 命名并不一致：

```text
PE 的 K = GEMM 的 N（输出通道）
PE 的 C = GEMM 的 K（规约维）
```

未合入提交 `d2cabd7` 将其标记为跨模块契约：如果将 `MTK` 和 `MTC` 对调，当前功能仿真可能无法发现，错误可能只在 RTL/VCS 上暴露。

## 3. MTW：W/M 方向深度

`MTW` 控制一个 MiniTile 同时处理多少个 M 方向位置，也就是多少行输出。

增大 MTW 通常会：

- 让同一批 Weight 服务更多输入行；
- 提高 Weight 复用率；
- 减少 W/M 方向的 MiniTile 数量；
- 增加 Input Buffer 和 Output Buffer 的占用。

MTW 同时受到输入和输出缓冲容量约束：

```text
w × c <= Input Buffer 容量
w × k <= Output Buffer 容量
```

其中 `w`、`c`、`k` 表示 MiniTile 的真实尺寸。

## 4. MTK：输出通道/N 方向深度

`MTK` 中的 K 是 PE 硬件的输出通道维，对应 GEMM 的 N。

增大 MTK 通常会：

- 让一个 MiniTile 同时生成更多输出通道；
- 减少 N/输出通道方向的 MiniTile 数量；
- 提高输入激活数据的复用率；
- 增加 Output Buffer 或累加器占用；
- 增加一个 MiniTile 需要读取的 Weight 数量。

它主要受到以下约束：

```text
w × k <= Output Buffer 容量
```

## 5. MTC：规约/K_algo 方向深度

`MTC` 中的 C 是输入通道或规约维，对应 GEMM 的 `K_algo`。

增大 MTC 通常会：

- 在一个 MiniTile 内完成更多规约累加；
- 减少规约方向的 MiniTile 数量；
- 延长单个 MiniTile 的计算时间；
- 增加 Input Buffer 占用；
- 在合适配置下更好地隐藏 Weight 或 Activation 加载延迟。

它主要受到以下约束：

```text
w × c <= Input Buffer 容量
```

## 6. MiniTile 数量和性能关系

未合入分支中的 Capstone 模型使用真实 MiniTile 尺寸：

```text
w = MTW_field + 1
k = MTK_field + 1
c = MTC_field + 1
```

各方向分块数近似为：

```text
N_TW = ceil(BLOCK_M / w)

N_TK = ceil(
    BLOCK_N /
    (N_Core × MAC_N_eff × k)
)

N_TC = ceil(
    BLOCK_K /
    (N_PE × MAC_K × c)
)
```

总 MiniTile 数为：

```text
N_m = N_TW × N_TK × N_TC
```

模型采用的基准硬件规模为：

```text
N_Core = 8
N_PE   = 8
MAC_N  = 16
MAC_K  = 16
```

对于 1-byte Weight，基础覆盖范围为：

```text
N_Core × MAC_N = 8 × 16 = 128 个输出通道
N_PE × MAC_K   = 8 × 16 = 128 个规约通道
```

因此：

- `MTK+1` 是基本输出通道覆盖范围的倍数；
- `MTC+1` 是基本规约范围的倍数；
- `MTW+1` 是同时处理的输出行数。

MiniTile 不能简单地取最大值，因为增大一个维度会占用更多 SRAM，并可能压缩另外两个维度的可选范围。最优组合需要综合考虑计算周期、加载延迟、写回延迟和缓冲容量。

## 7. YMode 与 MT 参数的关系

`YMode` 决定 PE Array 的 Y 方向采用哪种切分方式：

```text
YMode = 0 → KW，切 W
YMode = 1 → KC，切 C
```

它决定 MiniTile 如何映射到 PE Array，而 `MTW/MTK/MTC` 决定各维度的分块深度。当前正常 lowering 固定生成 `ymode = "KC"`。

相关枚举定义：

```text
include/triton-shared/Dialect/ZeusLow/IR/ZeusLowEnums.td
```

## 8. ISA 减一编码

ISA 定义说明 MT 字段采用减一编码：

```text
MTW_field = real_w - 1
MTK_field = real_k - 1
MTC_field = real_c - 1
```

例如真实 MiniTile 为：

```text
w = 13
k = 1
c = 4
```

理论编码应为：

```text
MTW[12] MTK[0] MTC[3]
```

ISA 字段定义位于：

```text
include/triton-shared/Target/ZeusV3/ISA/InstrInfo.def
```

字段宽度为：

| 字段 | Bit | 宽度 |
|---|---:|---:|
| `MTW` | `[20:16]` | 5 bit |
| `MTK` | `[12:8]` | 5 bit |
| `MTC` | `[5:0]` | 6 bit |

## 9. 当前 master 的实现状态

当前 `master` 的 `SetPeHWParamsPass` 没有根据 shape 搜索 MiniTile，而是在参数缺失时统一设置：

```text
mtw = 1
mtk = 1
mtc = 1
```

对应文件：

```text
lib/Dialect/ZeusHigh/Transforms/SetPeHWParams.cpp
```

当前 `InstructionSelector` 还会直接把属性值写入 ISA 字段，没有执行规范要求的减一编码：

```text
lib/Target/ZeusV3/CodeGen/InstructionSelector.cpp
```

提交 `d2cabd7` 中的未合入实现进行了以下修正：

1. 根据 `BLOCK_M/BLOCK_N/BLOCK_K` 和数据类型搜索最优 MiniTile；
2. 明确 MLIR 属性保存真实 `w/k/c` 尺寸；
3. 在 InstructionSelector 中统一执行 `-1` 编码；
4. 修复仅设置 `mtk` 时可能不发射 `PE_SETM_M` 的问题。

## 10. 仿真与验证边界

未合入提交明确指出：

- 当前功能模拟器不读取 MiniTile 参数；
- 因此 `mtw/mtk/mtc=1` 通常不会影响 cos-sim 的功能正确性；
- MiniTile 的主要收益体现在 RTL 和真实硬件性能；
- MT 参数错误或 `MTK/MTC` 对调，功能仿真可能无法发现；
- 最终需要通过 VCS/RTL 时序或真实性能测试验证。

因此，当前能够确认的定位是：

```text
MTW：控制输出行/M 方向复用深度
MTK：控制输出通道/N 方向分块深度
MTC：控制规约/K_algo 方向分块深度
```

它们共同决定一次 PE MiniTile 的工作量、片上缓冲占用和数据复用方式，是 PE 性能调优参数，而不是普通的软件循环参数。
