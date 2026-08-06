# C++版 Trace-only 模式：生成指令级 Timing Trace

> Trace-only 的主要功能是在跳过大部分 Tensor Payload 计算的同时，保留动态控制流、指令调度、逻辑时序和同步关系，生成 Timing Trace，用于调度与抽象性能分析。

## 核心执行流程

```text
指令流 + Runtime 参数
          │
          ▼
   执行动态控制流
 Fetch / Decode / Jump / Loop
          │
          ▼
   推进指令调度模型
 Latency / Issue Gap / In-flight
          │
          ▼
   处理同步与等待
 Mail / CT_SEND-WAIT / Drain
          │
          ▼
 跳过大部分 Tensor Payload
 PE矩阵乘、VP数值计算和完整写回
          │
          ▼
     生成 Timing Trace
 发射Tick / 完成Tick / Executor / Mail
```

## 保留与跳过的内容

| Trace-only保留 | Trace-only跳过 |
|---|---|
| 动态取指、译码、跳转和循环 | 大部分PE矩阵乘 |
| Executor指令分派 | 大部分VP数值计算 |
| 指令Latency和Issue Gap | 完整Tensor Payload搬运与写回 |
| 多指令In-flight和Drain | Output Dump |
| Mail、CT同步和指令等待 | Golden Compare |
| 必要的Runtime参数读取 | 数值正确性验证 |
| Timing Trace生成 | 默认不执行Dependency Conflict Analysis |

## 主要输出及作用

```text
Timing Trace
   ├── 指令何时发射、何时完成
   ├── 指令在哪个Core和Executor执行
   ├── 指令Latency与持续时间
   ├── Send/Receive Mail关系
   ├── Executor之间的并行重叠
   └── 当前Timing模型下的关键路径
```

Timing Trace可用于：

- 还原LD、PE、VP、ST等Executor的执行时间线；
- 分析指令等待谁、等待多久；
- 观察Executor并行度和流水空泡；
- 分析Latency、Issue Gap和流水排空；
- 比较不同Tiling或Schedule方案；
- 为Timing模型校准和性能回归提供数据。

## Timing Trace不等于Timing Race

```text
Timing Trace
回答：指令什么时候发射、等待和完成？

Race / Dependency Analysis
回答：重叠内存访问之间是否缺少可靠的先后关系？
```

- Trace-only主要生成 **Timing Trace**，不是“Timing Race”。
- Timing Trace可以帮助人工观察可疑的执行顺序，但不以本次Tick先后直接证明内存访问安全。
- Python的在线Race Detector观察实际并发执行中的抢跑。
- C++的Dependency Conflict Analysis通过Memory Effect和Happens-Before图检查RAW、WAR、WAW，主要由`analysis-only`或显式分析选项承担。

## 功能边界

> Trace-only回答的是“当前Timing模型下，指令如何调度和重叠”，不能回答“Tensor数值是否正确”。

- 不执行完整Payload，不能进行Golden Compare；
- Timing结果依赖Latency、Issue Gap及资源模型；
- 未经RTL或芯片数据校准时，适合调度分析和相对比较；
- 不能直接作为芯片绝对周期或性能签核结果；
- 不等同于RTL信号级Trace；
- 对依赖计算结果的动态控制流，需要保留必要数据或采用Functional模式验证。

## 一句话总结

> Trace-only通过“保留控制和时序、跳过大规模数据计算”，低成本生成确定性的指令级Timing Trace，主要服务于调度分析、流水优化和抽象性能评估，而不是数值验证或在线Race检测。
