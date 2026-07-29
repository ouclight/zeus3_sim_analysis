下面以一个简化的执行链为例，说明各类输出形式以及它们如何发挥作用：

```
LD：将输入从GDG加载到L2区域A
      │
      ▼
PE：读取A，计算后写入L2区域B
      │
      ▼
VP：读取B，激活后写入L2区域C
      │
      ▼
ST：将C写回GDG输出区域
```

以下JSON和日志均为便于PPT展示的简化示例，不代表完整文件字段。

# 1. Golden Compare：判断最终结果是否正确

## 输出形式

仿真结束后，将模拟输出与预期Golden比较：

```
Simulation output : simu_out0.bin
Golden output     : output.bin

Cosine similarity : 0.999998
Max absolute error: 0.000122
Result            : Test Success
```

失败示例：

```
Mismatch detected
Element index     : 128
Expected          : 1.500000
Actual            : 0.000000
Result            : Test Failure
```

## 如何起作用

```
仿真器执行指令
      │
      ▼
从指定GDG/L2区域Dump输出
      │
      ▼
按照指定数据格式解析
      │
      ▼
与Golden逐元素或按容差比较
      │
      ▼
生成Success/Failure结论
```

## 能帮助发现什么

- 最终计算结果错误；
- 数据少写或多写；
- 数据格式不一致；
- 输出地址错误；
- Shape或Stride错误；
- 数值精度和舍入差异。

## 边界

Golden失败只能说明结果不一致，不能直接判断问题来自编译器、Runtime、仿真器还是Golden本身。

------

# 2. Memory Dump：查看寄存器和内存状态

## 输出形式

仿真器可以将内存区域导出为二进制文件：

```
simu_out0.bin
gdg0.bin
```

也可以将内容转成便于查看的形式：

```
Core 0 L2 @ 0x2000:

Offset    BF16 value
0x0000    1.0000
0x0002    2.0000
0x0004    3.0000
0x0006    4.0000
```

寄存器状态示例：

```
PC  = 0x00000140
R0  = 32
AR0 = 0x10F00001000
BR1.base = 0x2000
BR1.shape = [1, 2, 4, 16]
```

## 如何起作用

Executor执行过程中会修改架构状态：

```
LD执行
  → GDG读取
  → L2写入

PE执行
  → L2读取
  → 计算
  → L2结果写回
```

仿真结束或触发Snapshot时，将指定内存区域保存下来。

## 如何定位问题

假设最终Golden失败：

```
最终输出错误
    │
    ▼
检查VP输出区域C：已经错误
    │
    ▼
检查PE输出区域B：已经错误
    │
    ▼
检查LD输入区域A：数据正确
```

可以判断问题大概率发生在PE阶段，而不是LD阶段。

Memory Dump用于回答：

> 数据从哪一步开始出现错误？

## 边界

Dump只能看到架构可见状态，不能看到RTL内部FIFO、流水寄存器和握手信号。

------

# 3. Instruction Trace：查看执行了哪些指令

## 输出形式

Python版典型输出文件包括：

```
log_npu_level.json
log_并行_core0.json
log_并行_executor_core0.json
```

C++版可以生成二进制Trace，并进一步导出JSON。

简化后的Instruction Trace：

```
[
  {
    "tick": 0,
    "core": 0,
    "pc": "0x100",
    "instruction": "LD_MOV",
    "event": "dispatch"
  },
  {
    "tick": 20,
    "core": 0,
    "pc": "0x140",
    "instruction": "PE_CONV",
    "event": "dispatch"
  },
  {
    "tick": 80,
    "core": 0,
    "pc": "0x180",
    "instruction": "VP_STSR",
    "event": "dispatch"
  }
]
```

## 如何起作用

每次发生关键执行事件时，仿真器记录：

- Device和Core；
- PC；
- 指令名称；
- 发射或完成事件；
- 逻辑Tick或时间；
- 阻塞原因；
- Mail信息。

## 能帮助发现什么

假设编译器预期执行：

```
LD → PE → VP → ST
```

实际Trace显示：

```
LD → PE → CT Jump → ST
```

说明VP所在分支没有执行，问题可能来自：

- 跳转条件错误；
- 寄存器配置错误；
- 编译器生成了错误的目标PC；
- 动态参数不符合预期。

Instruction Trace用于回答：

> 程序实际走了哪条执行路径？

## 边界

Trace只覆盖本次动态路径，不能说明未执行分支是否正确。

------

# 4. Executor Trace：查看指令如何等待和完成

## 输出形式

简化示例：

```
Tick 0    LD   LD_MOV   DISPATCH
Tick 0    LD   LD_MOV   START
Tick 20   LD   LD_MOV   COMPLETE
Tick 20   LD   LD_MOV   SEND_MAIL: PE

Tick 1    PE   PE_CONV  WAIT_MAIL: LD
Tick 20   PE   PE_CONV  RECEIVE_MAIL: LD
Tick 20   PE   PE_CONV  START
Tick 70   PE   PE_CONV  COMPLETE
```

也可以表示为时间线：

```
时间 →
LD： ████████████████████│完成并发送Mail
PE： ···等待LD Mail······│████████████████████████│
```

## 如何起作用

Executor在状态变化时记录事件：

```
Idle
  → 接收指令
  → 等待Mail
  → 开始执行
  → 完成
  → 提交结果
  → 发送Mail
  → Retire
```

## 能帮助发现什么

例如PE长时间没有开始：

```
PE_CONV WAIT_MAIL: LD
```

可以检查：

- LD是否发送了Mail；
- PE是否配置了错误的Receive Mail；
- Mail是否被其他指令消费；
- 上游指令是否根本没有执行；
- 是否发生死锁。

Executor Trace用于回答：

> 指令为什么没有执行，或者为什么执行得晚？

## 边界

这是指令级或Executor级状态，不等同于RTL内部流水级状态。

------

# 5. Memory Effect：查看指令读写了哪些内存

## 输出形式

简化示例：

```
{
  "node": 42,
  "core": 0,
  "pc": "0x140",
  "executor": "PE",
  "instruction": "PE_CONV",
  "accesses": [
    {
      "resource": "L2(device=0,core=0)",
      "mode": "read",
      "start": "0x2000",
      "end": "0x3000"
    },
    {
      "resource": "DDR_WEIGHT(device=0,core=0)",
      "mode": "read",
      "start": "0x10000000000",
      "end": "0x10000002000"
    },
    {
      "resource": "L2(device=0,core=0)",
      "mode": "write",
      "start": "0x4000",
      "end": "0x5000"
    }
  ]
}
```

## 如何起作用

指令发射后，仿真器根据：

- 地址寄存器；
- Shape；
- Stride；
- 数据格式；
- Tile布局；
- Topology；

计算这条指令的访问足迹：

```
读哪个内存
写哪个内存
起始地址
结束地址
```

## 能帮助发现什么

假设PE本应写入：

```
L2 [0x4000, 0x5000)
```

但Effect显示：

```
L2 [0x4200, 0x5200)
```

说明可能存在：

- 目标地址错误；
- BR配置错误；
- Offset计算错误；
- Shape或Stride错误。

Memory Effect用于回答：

> 这条指令实际读写了哪段内存？

## 边界

Memory Effect记录地址和读写行为，不代表真实Tensor数值已经正确计算。

------

# 6. Conflict Report：检查指令依赖是否完整

## 输出形式

文本报告示例：

```
Unordered memory conflicts: 1

Conflict: RAW
Resource: L2(device=0, core=0)
Overlap : [0x4800, 0x5000)

Writer:
  node=42, pc=0x140, executor=PE

Reader:
  node=43, pc=0x180, executor=VP

Reason:
  No happens-before path between node 42 and node 43
```

JSON形式示例：

```
{
  "total": 1,
  "has_cycle": false,
  "conflicts": [
    {
      "kind": "RAW",
      "node_a": 42,
      "node_b": 43,
      "overlap_start": 18432,
      "overlap_end": 20480
    }
  ]
}
```

## 如何起作用

分析器分两步工作。

第一步检查地址重叠：

```
PE写L2：
0x4000 ├────────────────────┤ 0x5000

VP读L2：
       0x4800 ├────────────────────┤ 0x5800
```

第二步检查依赖关系：

```
是否存在：
PE完成 → Send Mail → VP接收Mail
```

如果不存在FIFO、Mail、CT同步或SISO路径，就报告未排序RAW冲突。

## 能帮助发现什么

- 上游忘记发送Mail；
- 下游Receive Mail配置错误；
- 两个Core访问同一内存但缺少同步；
- 双缓冲区域错误重叠；
- 多条写指令顺序不明确。

Conflict Report用于回答：

> 有重叠内存访问的指令之间，是否存在可证明的执行顺序？

## 边界

报告冲突表示模型无法证明有序，不代表硬件一定会算错；无报告也不证明所有未执行路径都安全。

------

# 7. Timing Trace：分析调度和抽象性能

## 输出形式

简化示例：

```
Instruction   Start   End   Latency   Stall
LD_MOV          0      20      20       0
PE_CONV        20      70      50      19
VP_STSR        70      95      25      10
ST_MOV         95     115      20       0

Total cycles: 115
```

时间线形式更适合PPT：

```
Tick       0        20            70       95      115
           │         │             │        │        │
LD         ██████████
PE                   █████████████████████████
VP                                               ███████████
ST                                                          █████████
```

更好的流水调度可能是：

```
Tick       0        20       40       60       80
LD         ██████████
PE                   ████████████████████
LD2                         ██████████
VP                                       █████████
```

## 如何起作用

Cost Model为每条指令计算：

- Latency；
- Issue Gap；
- Drain；
- 退休顺序；
- 与Bytes、Rows、MACs相关的工作量。

Scheduler根据这些信息生成逻辑时间线。

## 能帮助发现什么

- 哪个Executor是瓶颈；
- 哪条指令等待Mail；
- 流水线中是否存在Bubble；
- LD、PE、VP、ST是否有效重叠；
- 两个编译Schedule哪个关键路径更短。

Timing Trace用于回答：

> 当前Timing模型下，时间消耗在哪里？

## 边界

未经RTL或芯片数据校准时，逻辑Tick只能用于抽象或相对分析，不能直接代表芯片真实周期。

------

# 8. Launch Status和错误信息：支持Runtime联调

## 输出形式

提交响应：

```
{
  "status": 0,
  "launch_id": 12,
  "state": "queued"
}
```

查询响应：

```
{
  "status": 0,
  "launch_id": 12,
  "state": "running",
  "device": 0,
  "stream_id": 0
}
```

失败响应：

```
{
  "status": 1,
  "launch_id": 12,
  "state": "failed",
  "device": 0,
  "error": "MemoryRouter: routed target outside memory topology"
}
```

## 如何起作用

Daemon为每次Launch维护状态机：

```
queued
   │
   ▼
running
   │
   ├──► completed
   │
   └──► failed
```

Runtime通过`query_launch`或`wait_launch`获取执行结果。

## 能帮助发现什么

- Device没有注册；
- 入口地址错误；
- 共享内存映射失败；
- 远端Port未连接；
- 地址越界；
- 指令执行异常；
- Conflict Gate失败。

## 边界

`completed`只表示Launch正常结束，不等于Golden Compare一定通过。

------

# 9. Snapshot：保留失败现场

## 输出形式

调用：

```
{
  "cmd": "snapshot",
  "device": 0,
  "dir": "out",
  "reason": "launch_failed"
}
```

当前可输出：

```
out/
├── gdg0.bin
└── last_launch.json
```

`last_launch.json`示例：

```
{
  "reason": "launch_failed",
  "device": 0,
  "last_launch": {
    "launch_id": 12,
    "state": "failed"
  }
}
```

## 如何起作用

在失败发生后，将Resident Memory和Launch上下文保存到文件，供离线分析。

主要作用：

- 保留失败时输入和输出；
- 检查Runtime是否正确写入数据；
- 支持问题复现；
- 为跨团队分析提供统一现场。

## 边界

Snapshot是诊断快照，不是完整Checkpoint，不能从该位置恢复所有Core和Executor状态继续执行。

# 10. 各类输出如何组合使用

最典型的问题定位流程：

```
① Golden Compare失败
          │
          ▼
② Memory Dump确定首个异常数据区域
          │
          ▼
③ Memory Effect找到最后写入该区域的指令
          │
          ▼
④ Instruction Trace检查控制路径
          │
          ▼
⑤ Executor Trace检查Mail和执行顺序
          │
          ▼
⑥ Conflict Report检查是否缺少依赖
          │
          ▼
⑦ Snapshot保留现场供离线复现
```

例如：

```
现象：
最终输出全为0

分析：
Golden      → 确认输出错误
Memory Dump → PE输出区域仍为0
Effect      → PE应该写入该区域
Trace       → PE实际没有开始
Executor    → PE一直等待LD Mail
Conflict    → LD和PE之间缺少可证明顺序

结论：
编译指令流遗漏或错误配置了LD→PE的Mail依赖
```

# PPT精简表

| 输出形式          | 示例                         | 如何起作用                         |
| ----------------- | ---------------------------- | ---------------------------------- |
| Golden Compare    | `Expected 1.5, Actual 0`     | 比较最终输出，判断当前Case是否通过 |
| Memory Dump       | `L2[0x2000]=...`             | 查看中间数据，定位首次异常位置     |
| Instruction Trace | `PC 0x140: PE_CONV`          | 还原实际控制流                     |
| Executor Trace    | `PE WAIT_MAIL: LD`           | 解释指令为何等待或延迟             |
| Memory Effect     | `PE Write L2[0x4000,0x5000)` | 记录指令实际读写范围               |
| Conflict Report   | `RAW: PE→VP unordered`       | 检查重叠访问是否存在依赖           |
| Timing Trace      | `PE: Tick 20～70`            | 分析逻辑时间、重叠和瓶颈           |
| Launch Status     | `state=failed`               | 支持Runtime异步任务和错误管理      |
| Snapshot          | `gdg0.bin`                   | 保存失败现场供离线分析             |

一句话总结：

> Golden负责发现“结果错了”，Dump和Effect帮助找到“数据错在哪里”，Trace解释“执行过程如何发生”，Conflict检查“依赖是否完整”，Timing分析“时间消耗在哪里”，Launch Status和Snapshot则支撑Runtime联调和问题留档。