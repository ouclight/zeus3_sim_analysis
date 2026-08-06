# Instruction Trace与Executor Trace的区别及适用场景

> Instruction Trace关注“程序执行了哪些指令、走了哪条控制路径”；Executor Trace关注“指令进入哪个执行单元、何时开始、等待和完成”。

## 1. 核心区别

| 对比维度 | Instruction Trace | Executor Trace |
|---|---|---|
| 观察对象 | 动态指令流 | 各类Executor的执行活动 |
| 核心问题 | 执行了什么、执行顺序是什么 | 在哪里执行、何时执行、为何等待 |
| 主要字段 | Core、PC、Mnemonic、指令字段、控制跳转 | Executor、Instance、Start/End、Duration、Mail |
| 主要视角 | 程序和控制流视角 | 执行资源和流水视角 |
| 典型粒度 | 每条动态取指或分派指令 | 每次Executor任务的开始、完成和同步事件 |
| 适合定位 | 跳转、循环、漏执行、重复执行、指令参数 | Mail等待、Executor繁忙、流水空泡、并行重叠 |
| 性能用途 | 统计动态指令数和控制路径 | 分析利用率、Stall和关键路径 |

## 2. 图示理解

同一段程序：

```text
PC 0x100：LD_MOV
PC 0x140：PE_CONV
PC 0x180：VP_STSR
PC 0x1C0：ST_MOV
```

### Instruction Trace看到的内容

```text
执行顺序

Core 0
  PC 0x100  LD_MOV
      │
      ▼
  PC 0x140  PE_CONV
      │
      ▼
  PC 0x180  VP_STSR
      │
      ▼
  PC 0x1C0  ST_MOV
```

它主要回答：

```text
是否执行了这条指令？
PC是否正确？
循环执行了多少次？
条件跳转走了哪条分支？
指令字段是否符合预期？
```

### Executor Trace看到的内容

```text
逻辑时间 →

LD：  ███████████████│完成并发送PE Mail

PE：  ···等待LD······│████████████████████│完成

VP：  ·············等待PE···············│████████│

ST：  ·················等待VP··················│██████│
```

它主要回答：

```text
指令被分派到哪个Executor？
什么时候开始和完成？
等待了哪个Mail？
Executor是否繁忙？
不同Executor是否并行？
```

## 3. 同一条指令在两类Trace中的含义

以`PE_CONV @ PC 0x140`为例：

### Instruction Trace

```json
{
  "core": 0,
  "pc": "0x140",
  "instruction": "PE_CONV",
  "event": "dispatch"
}
```

含义：

> Core 0的控制流执行到了PC 0x140，并识别、分派了一条PE_CONV指令。

### Executor Trace

```text
Tick 10  PE_CONV  WAIT_MAIL: LD
Tick 20  PE_CONV  START
Tick 70  PE_CONV  COMPLETE
Tick 70  PE_CONV  SEND_MAIL: VP
```

含义：

> 指令虽然已经到达PE路径，但先等待LD，随后在Tick 20开始计算，并在Tick 70完成。

因此：

```text
Instruction Trace中的“已经执行到”
不一定等于
Executor Trace中的“已经完成”
```

## 4. Instruction Trace的适用场景

### 控制流问题

例如预期：

```text
LD → PE → VP → ST
```

实际：

```text
LD → PE → CT_JUMP → ST
```

可以定位：

- VP指令被跳过；
- 条件跳转结果错误；
- Jump Target错误；
- CT循环次数错误；
- 动态Shape或Runtime参数错误。

### 指令生成问题

可以检查：

- 指令是否缺失或重复；
- Opcode和Mnemonic是否正确；
- 实际PC是否符合编译器预期；
- Shape、Stride、数据格式等字段是否正确编码；
- 多Core入口地址是否正确。

### 典型使用场景

```text
程序是否走了正确路径？
某条指令为什么没有执行？
循环为什么少执行或多执行？
编译器实际生成了哪些动态指令？
```

## 5. Executor Trace的适用场景

### 同步和等待问题

例如：

```text
PE_CONV长期处于WAIT_MAIL: LD
```

可以检查：

- LD是否发送了正确Mail；
- PE是否接收了错误Mail；
- 上游指令是否尚未完成；
- Mail是否被其他指令提前消费；
- 是否形成执行死锁。

### 调度和性能问题

可以分析：

- LD、PE、VP、ST是否有效重叠；
- Executor Busy和Idle时间；
- Issue Gap是否造成吞吐限制；
- Drain是否导致流水排空；
- 哪条依赖链构成关键路径；
- 编译Schedule是否存在流水空泡。

### 多实例Executor问题

可以观察：

- 指令被路由到哪个Executor Instance；
- 多个DT或VP实例是否负载均衡；
- 是否存在某个实例繁忙而其他实例空闲。

### 典型使用场景

```text
指令为什么迟迟没有开始？
时间消耗在哪个Executor？
谁在等待谁？
执行单元是否充分并行？
```

## 6. 两类Trace如何配合定位问题

```text
Golden Compare失败
        │
        ▼
Instruction Trace
确认指令路径、PC和执行次数
        │
        ▼
Executor Trace
确认指令等待、开始和完成顺序
        │
        ▼
Memory Effect / Conflict Report
确认实际访问范围和依赖关系
        │
        ▼
Memory Dump
确认数据从哪条指令开始错误
```

示例：

```text
现象：VP输出全为0

Instruction Trace：
VP_STSR确实出现在动态指令流中

Executor Trace：
VP_STSR一直等待PE Mail，没有开始执行

结论：
不是控制流漏掉VP，而是PE→VP的同步关系存在问题
```

## 7. Python与C++呈现方式

### Python版

通常以不同层级的Trace文件呈现：

```text
Core/Instruction Trace
  → 观察PC、CT、指令顺序和寄存器变化

Executor Trace
  → 观察LD、PE、VP等执行区间和Mail事件
```

### C++版

C++ Timing Trace的事件通常同时带有：

- PC；
- Opcode和Mnemonic；
- Executor及Instance；
- Start/End Tick；
- Send/Receive Mail；
- 主要Memory Range。

因此C++版更多是在统一Timing Trace中按不同维度观察：

```text
按PC/Mnemonic查看
  → Instruction视角

按Executor/Instance/Phase查看
  → Executor视角
```

不应简单理解为C++一定生成两套完全独立格式的Trace文件。

## 8. 使用选择

```text
看执行了哪些指令、走了哪条路径
→ Instruction Trace

看指令在哪里执行、为何等待、何时完成
→ Executor Trace

定位复杂功能或并发问题
→ 两者联合使用
```

## 9. 功能边界

- Instruction Trace只覆盖本次实际执行的动态路径，不证明未执行分支正确；
- Executor Trace反映指令级执行单元状态，不等同于RTL内部流水级状态；
- Trace中的逻辑Tick依赖Timing模型，未经校准不能直接代表芯片绝对周期；
- Trace可以帮助定位可疑顺序，但内存访问是否安全应结合Memory Effect和Dependency Analysis判断；
- Trace记录“过程”，最终数值是否正确仍需结合Memory Dump和Golden Compare。

## 10. 一句话总结

> Instruction Trace从程序视角回答“执行了什么”；Executor Trace从硬件资源抽象视角回答“如何执行、等待多久”。两者结合，才能同时定位控制流错误与调度同步问题。
