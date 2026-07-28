建议这一页围绕一个核心观点展开：

> 仿真器不只支持离线Case运行，还可以通过Daemon和共享内存接入Runtime，使用接近真实软件栈的方式提交并执行NPU任务。

# 页面标题

> 仿真器与Runtime集成：打通编译器输出到NPU执行验证链路

副标题：

> 通过Resident Daemon、共享内存和异步Launch接口，在真实硬件前验证Runtime与NPU程序的协作关系。

# 推荐版式

建议采用“上方架构图、下方三栏说明”的版式：

```
┌─────────────────────────────────────────────────────┐
│                 Runtime集成架构图                    │
└─────────────────────────────────────────────────────┘

┌────────────────┬────────────────┬───────────────────┐
│ 为什么需要     │ 如何实现       │ 带来的价值        │
└────────────────┴────────────────┴───────────────────┘

底部：功能边界说明
```

# 上方：集成架构图

```
┌────────────────────┐
│   编译器生成结果    │
│ 指令、参数、权重    │
└─────────┬──────────┘
          ▼
┌─────────────────────────────┐
│           Runtime           │
│ 内存分配 / 数据传输 / Launch│
│ Stream同步 / Device管理     │
└─────────┬───────────────────┘
          │
          │ 共享内存写入数据
          │ Register / Enqueue / Wait
          ▼
┌─────────────────────────────┐
│     Simulator Resident      │
│           Daemon            │
│ Device注册 / Launch队列     │
│ 状态管理 / 错误返回         │
└─────────┬───────────────────┘
          ▼
┌─────────────────────────────┐
│       C++ SystemSimulator   │
│ Core调度 / 指令执行         │
│ Memory Router / Port Fabric │
│ Trace / Conflict Analysis   │
└─────────┬───────────────────┘
          │
          ▼
┌─────────────────────────────┐
│        执行结果与诊断        │
│ Output / Trace / Snapshot   │
│ Launch状态 / 错误信息       │
└─────────────────────────────┘
```

图中建议突出两条通道：

```
控制通道：Unix Socket
Register / Enqueue / Wait / Status

数据通道：POSIX Shared Memory
Code / Args / Input / Weight / Output
```

这是当前集成架构最重要的设计点：控制和大数据传输分离。

# 下方左栏：为什么需要集成

## 验证完整软件链路

传统Case运行主要验证：

```
指令文件 → 仿真器 → 输出结果
```

Runtime集成后可以验证：

```
编译器 → Runtime → 内存 → Launch → 仿真器
```

主要必要性包括：

- 验证Runtime能否正确提交编译器生成的程序；
- 验证代码、参数、权重和输入数据的内存布局；
- 验证入口地址和动态运行参数；
- 验证Device、Core和Stream生命周期；
- 提前发现Runtime与仿真器之间的ABI问题；
- 在真实硬件不可用时进行软硬件接口联调。

精简文案：

> 从“单独验证指令”扩展到“验证指令如何被Runtime加载、提交和执行”。

# 下方中栏：如何实现

建议列出五点：

### Resident Daemon

仿真器作为常驻服务运行，避免每个Launch重复启动和初始化。

### 共享内存

Runtime直接准备：

- 指令；
- Runtime参数；
- 输入；
- 权重；
- 输出空间。

仿真器映射同一份内存，减少大数据通过Socket复制。

### 异步Launch

控制接口支持：

```
Register Device
      ↓
Enqueue Launch
      ↓
Return Launch ID
      ↓
Wait / Query Status
```

### 地址ABI与Topology

- Runtime将地址编码为本地地址或Port Window地址；
- Topology描述Port连接关系；
- Memory Router将访问路由到本地或远端Device。

### 结构化结果

返回：

- Launch状态；
- 错误原因；
- Trace；
- 冲突报告；
- Snapshot和输出数据。

# 下方右栏：带来的好处

## 更接近真实使用方式

Runtime使用Device注册、内存和Launch接口驱动仿真器，而不是依赖人工准备Case。

## 提前发现接口问题

可以发现：

- 地址编码错误；
- 共享内存布局不一致；
- 入口地址错误；
- Runtime参数错误；
- Device或Core选择错误；
- 远端路由配置错误；
- 同步和生命周期问题。

## 提高批量执行效率

- Daemon保持常驻；
- Resident Memory可复用；
- 多次Launch不必重复启动进程；
- 适合编译器回归和自动化测试。

## 增强可诊断性

相较真实硬件，仿真器可以提供：

- 指令级Trace；
- Executor状态；
- Memory访问记录；
- Dependency Conflict；
- 明确的结构化错误信息。

# 功能闭环图

如果页面空间允许，可以在架构图右侧增加一个小闭环：

```
编译器生成程序
       │
       ▼
Runtime写入内存
       │
       ▼
提交Launch
       │
       ▼
仿真器执行
       │
       ▼
结果与Trace
       │
       └────────► 反馈编译器/Runtime修正
```

# 底部边界声明

建议用浅灰色小字：

> Runtime集成主要验证软件接口、内存布局、Launch流程和指令功能，不等同于真实驱动、操作系统和硬件行为；共享内存、地址ABI和Port Fabric是仿真约定，不能直接代表芯片物理实现。

# 一页PPT可直接使用的精简文案

## 仿真器与Runtime集成：验证完整NPU软件执行链路

> 仿真器通过Resident Daemon、共享内存和异步Launch接口接入Runtime，使编译器生成的NPU程序能够按照接近真实软件栈的方式被加载、提交和执行。

```
编译器
  │ 指令、参数
  ▼
Runtime
  │ 共享内存：Code / Args / Input / Weight / Output
  │ 控制接口：Register / Enqueue / Wait
  ▼
Simulator Daemon
  │ Device管理、Launch调度
  ▼
SystemSimulator
  │ Core、Memory、Fabric、Executor
  ▼
Result / Trace / Conflict / Snapshot
```

| 必要性                   | 实现方式              | 带来的价值              |
| ------------------------ | --------------------- | ----------------------- |
| 验证完整软件链路         | Resident Daemon       | 接近真实Runtime调用方式 |
| 验证内存和地址ABI        | POSIX共享内存         | 减少大数据复制          |
| 验证动态参数和入口地址   | 异步Launch接口        | 支持连续、批量任务      |
| 验证Device及跨Device访问 | Topology和Port Fabric | 提前发现路由问题        |
| 硬件前置联调             | Trace和结构化错误     | 提高问题定位效率        |

页面总结句：

> Runtime集成将仿真器从“离线指令执行工具”扩展为“可被软件栈直接调用的NPU虚拟执行环境”，用于在真实硬件前验证程序加载、内存管理、任务提交和指令执行全过程。