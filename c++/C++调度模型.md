C++版采用的是：

> Device内确定性的离散时间调度模型：以逻辑Tick表示模拟时间，由Device级全局事件循环协调两个Core，每个Core内部由CT Dispatch和多个Executor Unit共同推进。

它不是依靠宿主机线程实际运行时间来模拟NPU时序，也不是完整的RTL逐周期仿真。

# 1. 调度模型总体结构

```
                         Resident Daemon
                               │
                 每个Device对应一个Worker
                               │
                               ▼
                    Device Global Event Loop
                  统一协调本Device的两个Core
                               │
                  ┌────────────┴────────────┐
                  ▼                         ▼
             Core 0 Scheduler          Core 1 Scheduler
                  │                         │
          ┌───────┴────────┐        ┌───────┴────────┐
          ▼                ▼        ▼                ▼
     CT Dispatch      Executor Units CT Dispatch  Executor Units
                         │                            │
       ┌────┬────┬────┬──┴─┬────┬────┬────┐         │
       LD   LW   ST   DT   VP   PE   SI   SO         │
                         │                            │
                         └────────────┬───────────────┘
                                      ▼
                         Mailbox / CT Sync / SISO
                                      │
                                      ▼
                         Memory Router / Port Fabric
```

其中：

- Daemon管理Device注册、Launch队列和任务状态；
- 不同Device可以由不同宿主机Worker线程执行；
- 同一Device内部固定包含两个Core；
- 两个Core由统一的Device级循环确定性推进；
- 每个Core有一个CT分派单元和8类数据Executor；
- Executor之间通过Mailbox、CT同步和Memory Effect建立依赖。

------

# 2. 为什么称为离散时间模型

C++版使用逻辑Tick表示NPU模拟时间。

例如：

```
逻辑时间
  0      10      20      30      40      50
  │       │       │       │       │       │
LD│████████████████│完成
  │                └──发送Mail
  │
PE│                 ███████████████████████│完成
  │                 ▲
  │                 └──收到LD的Mail后开始
```

这里的`20`和`50`表示模拟周期，而不是宿主CPU实际执行了20或50纳秒。

因此：

- 宿主机CPU快慢不改变逻辑周期；
- 操作系统调度不会直接改变Device内指令顺序；
- 同一输入和Timing配置可以稳定复现；
- 可以比较不同编译调度方案的逻辑关键路径。

------

# 3. Device级全局调度

C++版不是让两个Core各自完全独立地运行，而是通过Device级全局循环协调。

概念流程如下：

```
┌────────────────────────────────────────────┐
│          Device Global Event Loop          │
└─────────────────────┬──────────────────────┘
                      │
                      ▼
          确定当前Device的逻辑Tick
                      │
                      ▼
          推进Core 0和Core 1的Executor
                      │
                      ▼
        提交当前Tick已经完成的指令Effect
                      │
                      ▼
       更新Memory、Mailbox和CT Sync Token
                      │
                      ▼
            尝试执行两个Core的CT分派
                      │
                      ▼
         记录Trace并判断是否已经结束
                      │
             ┌────────┴────────┐
             │                 │
             ▼                 ▼
       仍有可执行工作       暂无可执行工作
             │                 │
             ▼                 ▼
       推进下一个Tick      Fast-forward到下一事件
```

采用统一循环的原因是：

- 保证Core间Mail和Token在确定时间可见；
- 对两个Core使用固定推进顺序；
- 避免宿主机线程调度改变同步结果；
- 便于生成可重复的系统级Trace；
- 便于计算整个Device的完成时间。

------

# 4. 单个Core的Scheduler组成

每个Core的Scheduler主要包括：

```
                  Tick Scheduler
                        │
          ┌─────────────┴─────────────┐
          ▼                           ▼
     CT Dispatch                 Executor Units
          │                           │
  Fetch / Decode / Branch    LD / LW / ST / DT
  Register / CT Sync         VP / PE / SI / SO
          │                           │
          └─────────────┬─────────────┘
                        ▼
                Mailbox与Pending Effect
```

## CT Dispatch负责

- 根据PC取指；
- 解析指令；
- 执行跳转、循环和寄存器配置；
- 判断目标Executor；
- 检查接收Mail；
- 检查Executor是否允许发射；
- 执行CT_SEND和CT_WAIT；
- 更新PC；
- 处理程序结束。

## Executor Unit负责

- 接收CT分派的数据指令；
- 保存发射时的寄存器和描述符；
- 计算Latency和Issue Gap；
- 维护指令执行状态；
- 到达完成Tick后提交副作用；
- 写入寄存器或存储；
- 发送Mail；
- 记录Timing Event。

------

# 5. 一个Tick内发生什么

单Core的概念执行顺序可以表示为：

```
Tick开始
   │
   ▼
① 推进所有Executor
   │
   ├── 检查运行中指令是否到达完成时间
   ├── 完成数据计算或Memory Effect
   ├── 提交内存和寄存器修改
   └── 发送完成Mail
   │
   ▼
② CT尝试分派下一条指令
   │
   ├── Fetch
   ├── Decode
   ├── 检查Mail
   ├── 检查Executor状态
   ├── 检查Issue Gap和Drain
   └── 执行CT或发射到Executor
   │
   ▼
③ 收集Trace和系统Effect
   │
   ▼
④ 判断Core是否完成
   │
   ▼
Tick结束
```

先处理Executor完成，再尝试CT分派，意味着：

> 在当前Tick完成的上游指令，其Mail或结果可以影响当前Tick后续的CT分派判断。

具体可见性仍由提交规则和同步语义约束。

------

# 6. CT指令的分派流程

```
                 当前PC
                    │
                    ▼
                  Fetch
                    │
                    ▼
                  Decode
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
       CT类指令             数据类指令
          │                   │
          ▼                   ▼
 条件跳转/配置/同步       确定目标Executor
          │                   │
          │                   ▼
          │             检查Receive Mail
          │                   │
          │                   ▼
          │             检查资源和时序条件
          │                   │
          │          ┌────────┴────────┐
          │          ▼                 ▼
          │        满足              不满足
          │          │                 │
          │          ▼                 ▼
          │      发射指令         保持PC并Stall
          │          │
          └──────────┴──────► 更新或保持PC
```

数据指令发射前需要检查：

- 目标Executor是否能够接收；
- 需要的Mail是否齐备；
- 上一条指令的Issue Gap是否结束；
- 是否要求前序指令排空；
- 是否存在不能越过的Pending Effect；
- 同步条件是否满足。

如果任一条件不满足，CT不会跳过该指令，而是保持PC并等待。

------

# 7. Executor状态模型

可以将Executor抽象为以下状态机：

```
                  ┌──────────┐
                  │   Idle   │
                  └────┬─────┘
                       │ 接收指令
                       ▼
                  ┌──────────┐
                  │  Issued  │
                  └────┬─────┘
                       │ 满足执行条件
                       ▼
                  ┌──────────┐
                  │ Running  │
                  └────┬─────┘
                       │ 到达完成Tick
                       ▼
                  ┌──────────┐
                  │Complete  │
                  └────┬─────┘
                       │ 提交Effect/发送Mail
                       ▼
                  ┌──────────┐
                  │ Retired  │
                  └────┬─────┘
                       │
                       └──────────► Idle
```

在支持多条指令In-flight的模式下，同一Executor中可能同时存在：

```
已发射但未开始
+
正在执行
+
已经完成但等待按序退休
```

因此Executor不再只是简单的`busy/idle`开关，而是一个带队列和退休约束的流水状态机。

------

# 8. Latency和Issue Gap

性能调度中最关键的两个参数是：

| 参数               | 含义                                   |
| ------------------ | -------------------------------------- |
| `latency_cycles`   | 指令从开始执行到完成需要的周期         |
| `issue_gap_cycles` | 同一Executor连续接收两条指令的最小间隔 |

例如PE指令Latency为30周期，Issue Gap为10周期：

```
时间      0       10      20      30      40      50
          │       │       │       │       │       │

PE指令1   ██████████████████████████████
PE指令2           ██████████████████████████████
PE指令3                   ██████████████████████████████
          ▲       ▲       ▲
          发射1   发射2   发射3
```

结果：

- 每条指令需要30周期完成；
- 但每10周期可以发射一条；
- 三条指令总时间约为50周期；
- 不是`30 × 3 = 90`周期。

这使调度器能够表达：

- 流水线吞吐；
- 多条指令重叠；
- 长Latency、高吞吐执行单元；
- 编译器调度对关键路径的影响。

------

# 9. Drain与退休顺序

某些指令不能简单按照Issue Gap继续执行。

## Drain Prior

表示当前指令执行前，需要等待同Executor此前工作完成。

典型用途：

- Mail或Barrier；
- 需要保证此前数据已经提交的指令；
- 流水线排空点。

```
计算1 ─────────────┐
计算2     ─────────┤
                   ▼
              等待全部完成
                   │
                   ▼
                 MAIL
```

## Retire In Order

表示指令即使提前完成，也需要按照发射顺序提交。

```
发射顺序：A → B

A：长Latency ────────────────── 完成
B：短Latency      ─── 完成，但等待A
                              │
                              ▼
                         A退休 → B退休
```

它用于保持：

- 同一执行lane的顺序语义；
- 内存副作用顺序；
- Mail发送顺序；
- Trace中的语义提交顺序。

------

# 10. Mailbox如何影响调度

Mailbox负责Executor之间的依赖同步。

```
        LD Executor                         PE Executor
             │                                   │
             │ 读取并写入L2                      │ 等待Receive Mail
             │                                   │
             ▼                                   │
        数据写入完成                             │
             │                                   │
             └──────── Send Mail ───────────────►│
                                                 │
                                                 ▼
                                            开始PE计算
```

调度规则：

1. 下游指令在CT位置等待；
2. Scheduler检查需要的Receive Mail；
3. Mail未到达时，CT保持Stall；
4. 上游Executor完成并提交数据；
5. 上游发送Mail；
6. 下游原子消费Mail；
7. 下游指令被发射。

重点是：

> Mail通常与指令完成或副作用提交关联，而不是仅与指令开始关联。

------

# 11. CT_SEND与CT_WAIT

CT同步用于Core之间的控制同步。

```
Core 0                              Core 1
  │                                   │
  │ 执行前置任务                      │ CT_WAIT
  │                                   │   │
  ▼                                   │   │ 未满足，Stall
CT_SEND ─────────────► Token Bank     │   │
                      增加Token        │   │
                                      │   ▼
                                      └─ 消费Token，继续执行
```

当前Resident Daemon模型中：

- CT同步ID是Device-local bitmap；
- bit 0表示当前Device的Core 0；
- bit 1表示当前Device的Core 1；
- 不同Device维护各自的Token Bank。

因此CT_SEND/WAIT主要用于本Device两个Core之间的同步。

------

# 12. Pending Effect机制

C++版不仅记录“指令是否完成”，还记录尚未提交的副作用。

```
指令发射
   │
   ▼
注册Pending Effect
   │
   ├── 读取哪些地址
   ├── 写入哪些地址
   ├── 影响哪些寄存器
   └── 产生哪些同步事件
   │
   ▼
指令执行完成
   │
   ▼
提交Memory/Register Effect
   │
   ▼
退休Pending Effect
```

Pending Effect用于避免：

- 后续CT存储访问越过此前未完成的数据指令；
- 后续Executor过早看到尚未提交的数据；
- 功能执行顺序与Timing Trace顺序不一致；
- Conflict Analyzer遗漏动态访问关系。

------

# 13. Fast-forward机制

如果Scheduler逐Tick推进一个高Latency指令，会产生大量无意义循环：

```
Tick 100：PE开始
Tick 101：无事件
Tick 102：无事件
...
Tick 999：无事件
Tick 1000：PE完成
```

C++版可以在证明中间没有可见事件时直接跳转：

```
Tick 100
   │
   │ 下一事件为PE在Tick 1000完成
   │ 中间没有CT发射、Mail、同步或回调
   ▼
Tick 1000
```

Fast-forward的条件必须保守，只有在以下情况下才能跳过：

- 中间没有Executor完成；
- 没有更早的CT可发射时间；
- 没有Mailbox或Token变化；
- 没有需要逐Tick发布的事件；
- 所有Core都认可相同的安全跳转窗口。

这使仿真复杂度更接近“动态指令和事件数量”，而不是模拟周期总数。

------

# 14. 多Core调度示例

假设Core 0加载数据，完成后通知Core 1执行PE：

```
逻辑Tick      0       10      20      30      40      50

Core 0 CT     发射LD                   CT_SEND
              │                          │
Core 0 LD     ████████████████████████   │
                                         │
Token Bank                              +1
                                         │
Core 1 CT     CT_WAIT阻塞────────────────┘  发射PE
                                              │
Core 1 PE                                     ███████████████
```

对应调度过程：

1. Tick 0：Core 0发射LD；
2. Core 1执行CT_WAIT，Token不足，保持Stall；
3. Device全局循环推进；
4. LD到达完成时间并提交数据；
5. Core 0执行CT_SEND；
6. Core 1观察到Token并消费；
7. Core 1继续取指并发射PE；
8. 所有Core的CT结束且Executor排空后，Launch结束。

------

# 15. 不同执行模式下的调度差异

| 模式          | 控制流 | Timing调度 | Tensor Payload | 多In-flight   | 主要用途       |
| ------------- | ------ | ---------- | -------------- | ------------- | -------------- |
| Functional    | 执行   | 执行       | 执行           | 当前偏保守    | 功能结果验证   |
| Trace-only    | 执行   | 执行       | 大部分跳过     | Timing v2支持 | 调度和性能分析 |
| Analysis-only | 执行   | 执行       | 跳过           | 当前偏保守    | 依赖冲突分析   |
| Full-debug    | 执行   | 执行       | 执行           | 当前偏保守    | 完整问题定位   |

需要注意：

- 校准的Latency、Issue Gap和多In-flight主要在`trace-only` Timing v2路径中发挥作用；
- Functional模式更重视Payload提交和功能顺序稳定；
- Trace-only不执行完整Tensor Payload，因此不能验证数值结果；
- Analysis-only重点保留Memory Effect和依赖关系。

------

# 16. 调度结束条件

遇到程序结束指令，不一定代表Core立即结束。

```
                CT遇到结束指令
                       │
                       ▼
                 停止继续取指
                       │
                       ▼
           检查所有Executor是否已经空闲
                       │
            ┌──────────┴──────────┐
            ▼                     ▼
          未空闲                 已空闲
            │                     │
            ▼                     ▼
       继续推进Tick       检查Pending Effect
                                  │
                         ┌────────┴────────┐
                         ▼                 ▼
                       未提交            已清空
                         │                 │
                         ▼                 ▼
                     继续推进          Core完成
```

系统Launch完成通常要求：

- 所有活动Core都停止取指；
- 所有Executor都完成；
- 所有必要的Memory Effect都已提交；
- 系统没有尚待处理的执行任务。

------

# 17. 调度模型的主要特点

| 特点           | 说明                                           |
| -------------- | ---------------------------------------------- |
| 确定性         | Device内使用固定顺序推进，不依赖宿主机线程交错 |
| 离散逻辑时间   | Tick表示模拟时间，不是CPU实际运行时间          |
| Executor并行   | 不同Executor可以在逻辑时间上重叠               |
| 流水建模       | 支持Latency、Issue Gap和多指令In-flight        |
| 依赖驱动       | Mail、CT同步、FIFO和Pending Effect影响发射     |
| 事件跳转       | 无事件区间可以Fast-forward                     |
| 功能与分析分层 | Payload执行和Effect规划可以按模式选择          |
| 可配置         | Timing参数可以按Executor或具体指令配置         |
| 可复现         | 相同输入和配置通常生成相同的逻辑Trace          |

------

# 18. 调度模型的功能边界

当前调度器可以表达：

- 指令发射和完成时间；
- Executor忙闲状态；
- 多Executor重叠；
- 同Executor流水吞吐；
- Mail和同步等待；
- Drain和退休顺序；
- 抽象关键路径；
- 多Core的确定性协调。

当前不能完整表达：

- RTL每一级流水寄存器；
- L2 Bank争用；
- Cache命中和替换；
- DDR控制器队列；
- Fabric真实带宽和仲裁；
- NoC拥塞和背压细节；
- 功耗、温度和动态频率；
- 所有硬件内部性能Hazard。

因此准确定位是：

> C++版调度器是确定性的指令级离散事件调度模型，可以作为功能调度和可校准性能分析的基础，但不是完整的RTL周期精确调度器。

# PPT一页版总结图

```
                     Device Global Event Loop
                              │
               ┌──────────────┴──────────────┐
               ▼                             ▼
        Core 0 Tick Scheduler         Core 1 Tick Scheduler
               │                             │
      ┌────────┴────────┐           ┌────────┴────────┐
      ▼                 ▼           ▼                 ▼
 CT Fetch/Decode    Executor推进  CT Fetch/Decode   Executor推进
      │                 │           │                 │
      └────────┬────────┘           └────────┬────────┘
               │                             │
               └──────────────┬──────────────┘
                              ▼
                   Mail / CT Sync / SISO
                              │
                              ▼
                  Effect提交与Memory访问
                              │
                              ▼
             计算下一事件时间并Fast-forward
                              │
                              └────────► 下一轮
```

一句话总结：

> C++版调度模型以Device级逻辑时间为主线，通过CT分派、Executor状态机、Mailbox同步、Pending Effect和Fast-forward机制，确定性地模拟多Core、多执行单元之间的并行与依赖关系。