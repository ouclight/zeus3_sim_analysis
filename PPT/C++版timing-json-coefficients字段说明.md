# C++版 timing.json：coefficients字段说明

> `coefficients`用于描述“指令工作量变化会增加或减少多少执行周期”，使Latency不再是固定常数，而是能够随数据量、Shape、MAC数量和流水结构动态变化。

## 1. 基本计算公式

```text
最终Latency
  = ceil(
      latency_cycles
      + Σ(coefficients[特征名] × 指令特征值)
    )
```

- `latency_cycles`：指令的基础启动周期；
- `coefficients`：各工作量特征对Latency的权重；
- 指令特征值：仿真器根据发射时锁存的BR、PE和VP配置计算；
- `ceil`：计算结果向上取整为整数Cycle。

`issue_gap_coefficients`使用相同公式，但作用对象不同：

```text
最终Issue Gap
  = ceil(
      issue_gap_cycles
      + Σ(issue_gap_coefficients[特征名] × 指令特征值)
    )
```

| 字段 | 表示什么 |
|---|---|
| `coefficients` | 工作量对单条指令完成Latency的影响 |
| `issue_gap_coefficients` | 工作量对同一Executor连续发射间隔的影响 |

## 2. 示例：LD搬运指令

```json
{
  "latency_cycles": 20,
  "issue_gap_cycles": 2,
  "coefficients": {
    "bytes": 0.03125
  },
  "issue_gap_coefficients": {
    "rows": 0.25
  }
}
```

假设当前LD指令：

```text
bytes = 1024
rows  = 8
```

计算结果：

```text
Latency
  = ceil(20 + 1024 × 0.03125)
  = 52 cycles

Issue Gap
  = ceil(2 + 8 × 0.25)
  = 4 cycles
```

含义：

- 该LD指令从开始到完成需要52个逻辑周期；
- 同一LD Executor最早可在4个周期后继续发射下一条指令；
- 因此可以表达“单条指令延迟较长，但流水吞吐较高”。

## 3. 示例：PE计算指令

```json
{
  "latency_cycles": 12,
  "issue_gap_cycles": 4,
  "coefficients": {
    "pe_macs": 0.001
  },
  "retire_in_order": true
}
```

假设：

```text
pe_macs = W × C × K = 32768
```

则：

```text
Latency
  = ceil(12 + 32768 × 0.001)
  = ceil(44.768)
  = 45 cycles
```

含义：

> 基础启动需要12周期，计算量每增加1000个MAC约增加1个周期。

实际系数必须由RTL、VCS、FPGA或芯片数据拟合，示例数值不代表真实硬件性能。

## 4. 仿真器可提供的通用特征

| 特征 | 含义 |
|---|---|
| `constant` | 固定值1，可用于增加额外常数项 |
| `elements` | 相关BR描述符中的最大元素数量 |
| `bytes` | 相关BR描述符中的最大逻辑字节数 |
| `rows` | Tensor逻辑行数 |
| `padded_bytes` | 按数据格式和通道对齐后的字节数 |
| `padding_rows` | 逻辑行小于16B、需要L2行补齐的行数 |

说明：

- 多个BR参与指令时，通用`elements`、`bytes`、`rows`主要取相关描述符中的最大值；
- `padded_bytes`反映通道对齐后的实际搬运规模；
- `padding_rows`用于表达短行被补齐到16B L2行宽产生的额外开销。

## 5. PE专用特征

| 特征 | 含义 |
|---|---|
| `pe_w` | PE输入宽度W |
| `pe_c` | 输入/权重通道数C |
| `pe_k` | 输出通道或输出维度K |
| `pe_macs` | `W × C × K`，近似计算工作量 |
| `pe_mtw` | PE Mini-Tile宽度 |
| `pe_mtc` | PE Mini-Tile通道维度 |
| `pe_mtk` | PE Mini-Tile输出维度 |
| `pe_minitile_volume` | `MTW × MTC × MTK` |
| `pe_analytical_cycles` | 根据PE分阶段解析、加载、计算和写回公式得到的分析周期 |

两种常见建模方式：

```text
简单线性模型：
Latency = base + pe_macs × coefficient

分析模型校准：
Latency = base + pe_analytical_cycles × scale
```

`pe_analytical_cycles`是结构化分析特征，不等于已经完成硬件签核的真实周期，仍需使用实测数据拟合系数。

## 6. VP专用特征

| 特征 | 含义 |
|---|---|
| `vp_work` | 元素数量与启用功能组合形成的总体工作量 |
| `vp_vector_stages` | 启用的向量流水Stage数量 |
| `vp_scalar_stages` | 启用的标量流水Stage数量 |
| `vp_stage_work` | 元素数、Lane模式和向量Stage综合工作量 |
| `vp_tree_work` | Tree Reduction相关工作量 |
| `vp_scalar_work` | 行数与标量Stage综合工作量 |
| `vp_32_lane_work` | 32-Lane模式下的额外工作量 |
| `vp_fp32_work` | FP32源数据对应的工作量 |
| `vp_input_bytes` | 输入数据总字节数 |
| `vp_output_bytes` | 输出数据总字节数 |
| `vp_io_bytes` | 输入与输出字节数之和 |
| `vp_extra_input_bytes` | 多输入相对最大单输入增加的字节数 |
| `vp_parameter_bytes` | 参数加载类指令的输入字节数 |

这些特征可以分别拟合：

- 不同VP Stage组合；
- 64-Lane与32-Lane路径差异；
- Tree Reduction成本；
- FP32路径成本；
- 多输入及参数加载流量。

## 7. coefficients如何发挥作用

```text
指令发射
   │
   ▼
锁存BR、PE、VP配置
   │
   ▼
提取bytes / rows / pe_macs / vp_stage_work等特征
   │
   ▼
读取timing.json中的基础周期和coefficients
   │
   ▼
计算Latency与Issue Gap
   │
   ▼
Scheduler生成开始、完成和下一次可发射Tick
   │
   ▼
Timing Trace呈现流水重叠与关键路径
```

它使同一种指令在不同Shape下得到不同Timing：

```text
LD 256B  → 较短Latency
LD 4096B → 较长Latency

PE小矩阵 → 较少周期
PE大矩阵 → 较多周期
```

## 8. 配置与使用边界

- `coefficients`是Timing JSON v2能力，单位必须为`cycles`；
- 模型主要服务于C++版`trace-only`校准流水路径；
- JSON中未提供的特征系数视为0；
- 配置了仿真器不认识的特征名时，该项当前不会参与计算，因此应通过校准工具和测试检查拼写；
- 系数可以是小数，最终结果统一向上取整；
- 系数可以为负，但最终结果必须是有限且非负，否则仿真报错；
- 最终Issue Gap在非Fast模式下必须大于0；
- 命令行`--cost EXEC=TICKS`或`--cost EXEC.INST=TICKS`会清除对应v2系数，并把Latency和Issue Gap都设为固定值；
- 所有系数来自JSON，仿真器不内置已校准系数；
- 未经硬件数据拟合和验证，计算结果只能视为抽象Timing估计。

## 9. 一句话总结

> `coefficients`把指令的Shape、数据量和计算规模转换为附加周期，使固定Cost模型升级为“基础周期 + 工作量相关周期”的可校准性能模型；其准确度取决于特征选择和RTL/芯片数据拟合质量。
