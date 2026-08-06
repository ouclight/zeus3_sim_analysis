# C++版 Timing.json：配置指令逻辑时序模型

> Timing.json用于告诉仿真器“不同指令需要多少逻辑周期、同一Executor多久可以继续发射下一条指令，以及同步点是否需要等待流水排空”，从而生成可配置、可校准的Timing Trace。

## 1. 为什么需要Timing.json

功能语义只能回答：

```text
这条指令做什么？
执行后的数据结果是什么？
```

Timing.json进一步回答：

```text
指令何时发射？
需要多少周期完成？
下一条指令何时可以进入同一Executor？
不同Executor能否重叠执行？
Mail和Barrier造成多少等待？
```

如果没有校准配置，仿真器只能使用内置的粗粒度默认Cost；加入Timing.json后，可以根据指令类型和工作量估算逻辑时序。

## 2. 它在仿真流程中的位置

```text
指令 + 发射时锁存的BR/PE/VP配置
                 │
                 ▼
          提取Timing特征
 bytes / rows / pe_macs / vp_stage_work
                 │
                 ▼
            Timing.json
 基础周期 + 特征系数 + 流水策略
                 │
                 ▼
             Cost Model
  Latency / Issue Gap / Drain / Retire
                 │
                 ▼
           Tick Scheduler
  计算开始Tick、完成Tick和下一发射时间
                 │
                 ▼
           Timing Trace
 执行重叠 / Stall / 利用率 / 关键路径
```

## 3. 推荐配置格式

```json
{
  "schema_version": 2,
  "units": "cycles",
  "ct_dispatch_gap_cycles": 2,
  "executors": {
    "LD": {
      "instructions": {
        "LD_MOV": {
          "latency_cycles": 20,
          "issue_gap_cycles": 2,
          "coefficients": {
            "bytes": 0.03125
          },
          "issue_gap_coefficients": {
            "rows": 0.25
          }
        }
      }
    },
    "PE": {
      "instructions": {
        "PE_CONV": {
          "latency_cycles": 12,
          "issue_gap_cycles": 4,
          "coefficients": {
            "pe_macs": 0.001
          },
          "retire_in_order": true
        }
      }
    }
  }
}
```

## 4. 关键字段

| 字段 | 作用 |
|---|---|
| `schema_version` | 选择Timing Schema；推荐使用版本2 |
| `units` | v2必须为`cycles` |
| `ct_dispatch_gap_cycles` | CT连续成功分派两条指令的最小间隔 |
| `latency_cycles` | 单条指令从开始到完成的基础周期 |
| `issue_gap_cycles` | 同一Executor连续发射两条指令的基础间隔 |
| `coefficients` | 工作量特征对Latency的附加影响 |
| `issue_gap_coefficients` | 工作量特征对Issue Gap的附加影响 |
| `drain_prior` | 当前指令执行前是否等待同Lane此前工作排空 |
| `retire_in_order` | 同Lane指令是否按发射顺序退休 |

## 5. Latency与Issue Gap

```text
Latency：一条指令多久完成
Issue Gap：同一Executor多久可以再发一条
```

例如：

```text
Latency = 30 cycles
Issue Gap = 10 cycles

PE指令1：██████████████████████████████
PE指令2：          ██████████████████████████████
PE指令3：                    ██████████████████████████████
            <---10--->
```

这使仿真器能够表达长Latency但高吞吐的流水线，而不是简单地把所有指令周期串行相加。

## 6. 工作量系数如何生效

Latency计算：

```text
最终Latency
  = ceil(
      latency_cycles
      + Σ(coefficients[特征名] × 特征值)
    )
```

Issue Gap采用相同方法：

```text
最终Issue Gap
  = ceil(
      issue_gap_cycles
      + Σ(issue_gap_coefficients[特征名] × 特征值)
    )
```

常用特征：

| 类型 | 代表特征 | 表达的工作量 |
|---|---|---|
| 通用 | `bytes`、`rows`、`padded_bytes` | 数据量、逐行处理和对齐开销 |
| PE | `pe_macs`、`pe_mtw/mtc/mtk` | 矩阵计算量和Mini-Tile结构 |
| VP | `vp_stage_work`、`vp_tree_work` | VP流水Stage、Lane和归约工作量 |

示例：

```text
LD基础Latency = 20
bytes = 1024
bytes系数 = 0.03125

最终Latency = ceil(20 + 1024 × 0.03125)
            = 52 cycles
```

## 7. Timing.json带来的能力

- 为不同Executor和具体指令配置Timing；
- 区分单条指令延迟和流水吞吐；
- 表达多条指令In-flight和Executor并行重叠；
- 表达Mail、Barrier和Drain带来的等待；
- 使相同指令随Shape和数据量产生不同周期；
- 支持比较不同Tiling和Schedule方案；
- 为RTL、VCS、FPGA或芯片数据校准提供参数入口。

## 8. 使用方式

Daemon启动时加载：

```bash
cpp/build/zeus3sim \
  --daemon \
  --socket /tmp/zeus3sim.sock \
  --timing <timing.json>
```

结合Trace-only使用：

```bash
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --trace-only \
  --trace-output trace/core \
  --timing <timing.json>
```

临时固定Cost覆盖：

```bash
--cost PE.PE_CONV=100
```

命令行`--cost`会将对应指令的Latency和Issue Gap设为固定值，并清除对应v2特征系数，适合调试，不适合保留校准模型。

## 9. 功能边界

> Timing.json改变的是“指令在逻辑时间上如何调度”，不应改变“指令最终做什么”。

- 主要服务于C++版`trace-only`的校准流水模型；
- 不负责验证PE、VP等Tensor数值是否正确；
- 不替代Memory Effect和Dependency Conflict Analysis；
- 当前模型尚未完整覆盖L2 Bank、DDR队列和Fabric争用；
- 默认值和示例系数不代表真实芯片性能；
- 只有使用RTL、VCS、FPGA或芯片数据校准并验证后，才能用于指定范围的性能评估；
- 未经校准时，更适合调度分析和方案相对比较，不能作为芯片绝对周期签核。

## 10. 一页PPT推荐总结

```text
Timing.json
   │
   ├── 配置一条指令多久完成       → Latency
   ├── 配置多久能再发下一条       → Issue Gap
   ├── 配置工作量如何增加周期       → Coefficients
   ├── 配置同步点是否等待流水排空   → Drain
   └── 配置指令是否按序退休         → Retire
```

一句话总结：

> Timing.json是C++版仿真器的逻辑时序参数入口，它把固定指令Cost扩展为与数据量、计算规模和流水结构相关的可校准模型，并驱动Scheduler生成Timing Trace、执行重叠和关键路径。
