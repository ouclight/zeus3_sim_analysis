# C++版四种执行模式适用场景

| 模式 | 主要功能 | 适用场景 |
|---|---|---|
| `functional` | 执行真实Tensor计算和存储读写，并进行Dump与Golden Compare | 日常功能验证、编译器输出验证、检查最终结果 |
| `trace-only` | 跳过大部分Tensor计算，保留控制流、调度、同步和Timing Trace | 时序分析、流水重叠分析、关键路径定位、Schedule比较 |
| `analysis-only` | 生成Memory Effect和依赖图，检查RAW、WAR、WAW | 检查缺失Mail、Buffer重叠、跨Executor或跨Core内存冲突 |
| `full-debug` | 同时执行Payload、Trace、冲突分析和Golden Compare | 复杂问题深度定位，联合分析数据错误、执行时序和依赖关系 |

## 简单选择

```text
看结果是否正确        → functional
看指令如何调度        → trace-only
看内存依赖是否安全    → analysis-only
结果、时序、依赖全看  → full-debug
```

## 使用边界

- `trace-only`和`analysis-only`不验证Tensor数值；
- `full-debug`信息最完整，但运行和输出开销最大；
- Timing模型未经硬件校准时，`trace-only`结果不能作为芯片绝对性能。
