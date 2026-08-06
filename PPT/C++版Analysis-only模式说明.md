# C++版 Analysis-only 模式：分析内存依赖与潜在冲突

> Analysis-only的主要功能是在跳过大部分Tensor Payload计算的同时，执行动态控制流、规划Memory Effect、构建Happens-Before依赖图，并检查重叠内存访问是否存在可靠的先后顺序。

## 核心执行流程

```text
指令流 + Runtime参数
          │
          ▼
   执行动态控制流
 Fetch / Decode / Jump / Loop
          │
          ▼
  规划每条指令的Memory Effect
 读/写资源 + 地址范围 + 发起Core
          │
          ▼
    记录指令同步关系
 FIFO / Mail / CT Sync / SISO
          │
          ▼
  构建Happens-Before依赖图
          │
          ▼
 扫描同一Memory Resource的重叠访问
          │
          ▼
  输出RAW / WAR / WAW冲突报告
```

## 保留与跳过的内容

| Analysis-only保留 | Analysis-only跳过 |
|---|---|
| 动态取指、译码、跳转和循环 | 大部分PE矩阵乘 |
| Executor分派和动态指令顺序 | 大部分VP数值计算 |
| 必要的Runtime参数读取 | 完整Tensor Payload搬运与写回 |
| Memory Effect规划 | Output Dump |
| 本地及远端Memory Owner解析 | Golden Compare |
| FIFO、Mail、CT Sync和SISO关系 | 数值正确性验证 |
| RAW、WAR、WAW依赖检查 | 默认不以Timing Tick判断访问安全 |

## Memory Effect记录什么

```text
PE_CONV @ PC 0x140
  Read  L2(Device 0, Core 0) [0x2000, 0x3000)
  Read  WDRAM(Device 0, Core 0) [0x10000000000, ...)
  Write L2(Device 0, Core 0) [0x4000, 0x5000)

VP_STSR @ PC 0x180
  Read  L2(Device 0, Core 0) [0x4800, 0x5800)
  Write L2(Device 0, Core 0) [0x6000, 0x7000)
```

Memory Effect回答：

- 哪条动态指令发起访问；
- 由哪个Device、Core和Executor发起；
- 访问L2、GDG还是Weight DDR；
- 是读还是写；
- 访问哪段字节范围；
- 远端地址最终归属于哪个Memory Owner。

## 依赖分析如何判断冲突

```text
PE Write L2 [0x4000, 0x5000)
VP Read  L2 [0x4800, 0x5800)
              │
              ▼
      地址存在重叠，形成潜在RAW
              │
      ┌───────┴────────┐
      ▼                ▼
PE ──Mail──► VP      无依赖路径
顺序可以证明         报告RAW冲突
```

地址重叠本身不一定是错误。只有同时满足以下条件才需要检查顺序：

1. 两次访问属于同一个Memory Resource；
2. 地址范围发生重叠；
3. 至少一方是写操作；
4. 依赖图无法证明任一方向先于另一方向。

## 主要输出及作用

典型报告：

```text
Conflict: RAW
Resource: L2(Device 0, Core 0)
Overlap : [0x4800, 0x5000)

Writer: PE_CONV @ PC 0x140
Reader: VP_STSR @ PC 0x180
Reason: No happens-before path
```

报告可用于：

- 发现上游指令漏发Mail；
- 发现下游Receive Mail配置错误；
- 检查跨Executor和跨Core同步；
- 发现双缓冲地址错误重叠；
- 检查本地及远端内存访问关系；
- 在CI中将未排序冲突作为失败条件。

## Analysis-only与Trace-only的区别

| 对比项 | Analysis-only | Trace-only |
|---|---|---|
| 主要问题 | 内存访问顺序是否安全 | 指令如何调度、等待和完成 |
| 核心数据 | Memory Effect、依赖边 | Timing Event |
| 主要输出 | RAW/WAR/WAW冲突报告 | Timing Trace |
| 是否依赖Cost判断安全 | 否 | Cost决定时间线 |
| 是否验证数值结果 | 否 | 否 |
| 是否执行Golden Compare | 否 | 否 |

大白话理解：

```text
Analysis-only：谁读写了哪段内存，顺序是否可靠？
Trace-only：谁在什么Tick开始、等待和完成？
```

## 报告生成条件

- One-shot使用`--analysis-only`时，可通过`--conflict-report-dir <dir>`明确指定报告目录；未指定时，One-shot兼容路径可使用Case下的默认分析目录。
- 直接向Daemon发送`execution_mode: "analysis-only"`时，如果没有配置`conflict_report_dir`、Daemon默认报告目录、`fail_on_conflict`或其他分析输出策略，不应假设一定会生成落盘报告。
- 使用`--conflict-report-details`可保存每条冲突明细；默认策略可以只保存完整冲突总数，减少报告体积。
- 使用`--fail-on-conflict`可将发现冲突升级为Launch失败。

## 功能边界

> Analysis-only回答的是“本次动态路径中，重叠内存访问是否存在可证明的先后关系”，不能回答“Tensor数值是否正确”。

- 不执行完整Payload，不能进行Golden Compare；
- 只覆盖本次实际执行到的动态路径；
- 不比较Memory中的具体数值；
- 不分析Read-Read访问；
- 不检测L2 Bank、Cache、容量和Fabric争用；
- 报告冲突表示模型无法证明有序，不等于硬件一定出错；
- 没有报告也不能证明未执行路径全部安全；
- 结果依赖Memory Footprint和同步Effect记录是否完整。

## 一句话总结

> Analysis-only通过“保留控制和访问足迹、跳过大规模数值计算”，低成本生成Memory Effect和依赖冲突分析结果，主要用于发现缺失Mail、Buffer重叠及跨Executor/跨Core的RAW、WAR、WAW问题。
