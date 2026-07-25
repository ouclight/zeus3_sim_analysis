C++版仿真器的执行流程可以概括为：

> 客户端准备常驻内存并提交Launch，Daemon完成设备注册和任务调度，SystemSimulator创建Core执行环境，各Core通过确定性Tick Scheduler推进指令，数据类指令经过Effect规划和可选Payload执行，最后输出Trace、冲突报告、Dump和Golden Compare结果。

# 1. 总体执行流程

```
编译器输出 / Case目录 / Runtime
                │
                ▼
      One-shot Client或外部Runtime
      解析配置、准备共享内存
                │
                ▼
          C++ Resident Daemon
    Register Device / Enqueue Launch
                │
                ▼
          Per-Device Worker
                │
                ▼
          SystemSimulator
    创建Core、存储系统和互连拓扑
                │
                ▼
       Device-local Global Loop
                │
       ┌────────┴────────┐
       ▼                 ▼
   Core 0 Scheduler   Core 1 Scheduler
       │                 │
       └────────┬────────┘
                ▼
       CT取指、译码和指令分派
                │
                ▼
     Executor Unit与Mailbox调度
                │
                ▼
        Data Executor Pipeline
                │
      ┌─────────┴─────────┐
      ▼                   ▼
 Effect/Footprint规划   Payload执行
                      （按模式可跳过）
      │                   │
      └─────────┬─────────┘
                ▼
       Memory Router / Port Fabric
                │
                ▼
    L2 / GDG / Weight DDR / 远端内存
                │
                ▼
   Trace / Conflict Analysis / Dump
                │
                ▼
      Golden Compare与Launch结果
```

------

# 2. 执行入口

C++版有两个主要入口，但最终都走同一条Daemon执行路径。

## 2.1 外部Runtime入口

外部Runtime负责：

1. 创建并初始化resident shared memory；
2. 向Daemon注册Device；
3. 将代码、参数、权重和输入数据写入共享内存；
4. 通过`enqueue_launch`提交任务；
5. 通过`wait_launch`等待结果。

典型交互：

```
Runtime
   │
   ├── 创建GDG/WDRAM共享内存
   ├── 写入程序、参数和输入数据
   ├── register device
   ├── enqueue_launch
   ├── wait_launch
   └── 读取结果
```

## 2.2 One-shot Case入口

`zeus3sim_oneshot`用于兼容传统case目录：

```
zeus3sim_oneshot -c <case_folder>
```

它本身不直接执行指令，而是一个客户端适配器：

1. 读取case目录中的`init.json`；
2. 解析指令和内存初始化文件；
3. 创建POSIX共享内存；
4. 将case数据复制到resident memory；
5. 连接已有Daemon，或临时启动一个Daemon；
6. 注册Device；
7. 提交Launch；
8. 等待Launch完成；
9. 将共享内存中的结果dump到文件；
10. 与golden文件比较；
11. 关闭临时Daemon并清理资源。

因此：

> One-shot和外部Runtime虽然输入形式不同，但都通过Daemon执行，不存在绕过Daemon的另一套核心执行语义。

------

# 3. Daemon启动与初始化

Daemon典型启动方式：

```
zeus3sim --daemon --socket <socket_path> \
  --topology <topology.json> \
  --timing <timing.json>
```

启动阶段完成以下工作：

## 3.1 解析命令行配置

主要包括：

- Unix socket路径；
- Device拓扑；
- timing/cost配置；
- conflict report目录；
- 是否保存冲突明细；
- 是否在发现冲突时让Launch失败。

## 3.2 加载Topology

Topology定义：

- 有哪些Device；
- 每个Device的端口；
- 每个port连接到哪个远端Device；
- 哪些端口断开；
- 远端地址应当如何路由。

没有显式Topology时，默认使用单Device、远端端口断开的配置。

## 3.3 加载Cost Model

Cost Model定义：

- CT发射间隔；
- 不同executor的默认Latency；
- 具体指令的Latency；
- Issue Gap；
- Drain Policy；
- Retirement Policy；
- 与数据规模相关的系数。

## 3.4 建立控制服务

Daemon创建Unix socket，进入请求循环，接受：

- Device注册；
- Launch提交；
- Launch状态查询；
- Launch等待；
- 注销；
- 关闭Daemon。

------

# 4. Device注册与Resident Memory映射

Runtime或One-shot首先发送Device注册请求。

注册过程中，Daemon会：

1. 验证Device ID；
2. 检查共享内存名称和大小；
3. 使用`mmap`映射已有POSIX shared memory；
4. 将共享内存绑定到模拟地址空间；
5. 建立Device与内存对象的生命周期关系。

主要内存对象包括：

- Die级GDG DDR；
- Core 0的Weight DDR；
- Core 1的Weight DDR；
- Core本地L2在仿真过程中创建和管理。

需要注意：

> Daemon不负责从原始文件初始化resident memory。Runtime或One-shot必须在Launch前准备好代码、参数、权重和输入数据。

------

# 5. Launch提交

客户端通过`enqueue_launch`提交一次执行任务。

Launch请求主要包含：

- 目标Device；
- Core数量；
- 每个Core的入口地址`entry_addrs`；
- 执行模式；
- conflict analysis选项；
- trace输出选项；
- 可选的Launch级策略覆盖。

Daemon收到请求后：

1. 校验Device是否已注册；
2. 校验入口地址和Core数量；
3. 为Launch分配唯一ID；
4. 创建Launch状态对象；
5. 将任务放入对应Device的工作队列；
6. 立即向客户端返回Launch ID。

这是异步语义：

```
enqueue_launch
      │
      └── 立即返回launch_id

wait_launch(launch_id)
      │
      └── 等待执行结束并返回结果
```

------

# 6. Per-Device Worker执行Launch

Daemon为Device维护独立的worker。

当worker从队列中取出Launch后，会：

1. 将Launch状态设为running；
2. 创建或初始化SystemSimulator；
3. 绑定该Device的resident memory；
4. 应用Topology和Cost Model；
5. 为两个本地Core创建执行上下文；
6. 设置每个Core的入口PC；
7. 进入Device级确定性执行循环。

当前resident执行模型中，每个Device固定建模两个本地Core。不同Device可由不同worker线程推进，但同一Device内部的两个Core由统一执行逻辑协调。

------

# 7. SystemSimulator初始化

SystemSimulator是一次系统执行的核心组织者。

初始化内容包括：

## 7.1 Core状态

每个Core维护：

- PC；
- 通用寄存器；
- BR、VR、AR、RR等寄存器；
- L2；
- 指令程序或指令读取视图；
- mailbox；
- executor状态；
- timing trace；
- pending memory effect。

## 7.2 存储系统

建立：

- 本地L2；
- GDG DDR映射；
- Weight DDR映射；
- Memory Router；
- Port Address Decoder；
- Remote Fabric Service。

## 7.3 同步系统

建立：

- executor mailbox；
- CT_SEND/CT_WAIT token bank；
- Core之间的同步回调；
- SISO transfer；
- 同lane FIFO顺序；
- 系统级effect log。

## 7.4 调度系统

每个Core创建TickScheduler，包括：

- CT Dispatch；
- LD、LW、ST、DT、VP、PE、SI、SO executor；
- Cost Model；
- Trace Detail；
- 当前tick；
- 下一次允许发射的时间；
- 未完成的副作用序列。

------

# 8. Device级全局执行循环

C++版的核心特征是确定性离散事件推进。

概念上每轮执行：

```
while 任一Core未结束或仍有未完成工作:
    1. 推进所有Core的executor
    2. 提交在当前tick完成的指令
    3. 更新内存、寄存器和mailbox
    4. 尝试为各Core执行CT dispatch
    5. 处理跨Core同步和远端访问
    6. 收集trace和effect
    7. 计算是否可以fast-forward
    8. 推进全局逻辑时间
```

同一逻辑时间下，各Core使用固定顺序推进，避免宿主机线程调度改变模拟结果。

如果所有Core都在等待未来事件，并且中间没有可能改变状态的操作，调度器可以跳过空闲tick：

```
tick 100
   │
   │ 当前没有可发射指令
   │ 最近executor完成事件在tick 500
   ▼
直接跳转到tick 500
```

这样能够避免长Latency操作导致逐tick空转。

------

# 9. 单个Core的Tick执行流程

每个Core的TickScheduler在一个逻辑时刻主要做两件事：

1. 推进已有executor任务；
2. 尝试通过CT分派下一条指令。

## 9.1 推进Executor

对于每个executor：

```
检查当前任务状态
       │
       ├── 尚未到完成时间：保持busy
       │
       └── 已到完成时间
               │
               ├── 提交寄存器/内存副作用
               ├── 发送mail
               ├── 生成trace end事件
               ├── 退休pending effect
               └── executor变为可发射状态
```

## 9.2 CT取指和译码

CT根据当前PC：

1. 从程序存储空间取指；
2. 通过Decoder解析指令；
3. 得到mnemonic、字段、mail mask和地址字段；
4. 判断是CT自身指令还是数据executor指令。

## 9.3 检查发射条件

发射前检查：

- 目标executor是否能接收新指令；
- receive mail是否满足；
- Issue Gap是否满足；
- 是否需要等待前序任务drain；
- 是否有必须先完成的memory effect；
- CT_WAIT token是否满足；
- 是否存在同步或资源阻塞。

条件不满足时：

```
PC保持不变
当前Core进入stall
等待后续tick或其他事件解除条件
```

## 9.4 指令分派

如果是CT指令：

- 直接在CT执行路径处理；
- 更新寄存器、PC、loop或同步状态。

如果是数据指令：

- 将已译码指令和必要寄存器快照放入对应executor；
- 计算Latency和Issue Gap；
- 注册pending effect；
- 更新PC；
- 记录指令发射trace。

------

# 10. CT指令执行

CT主要处理控制面行为，例如：

- 顺序更新PC；
- 条件跳转；
- 循环；
- 寄存器设置；
- Core同步；
- CT_SEND；
- CT_WAIT；
- 程序结束。

典型控制流：

```
取CT指令
   │
   ├── 普通配置：更新寄存器 → PC前进
   ├── 条件跳转：检查条件 → 更新目标PC
   ├── CT_SEND：向目标Core增加token
   ├── CT_WAIT：检查/消费token，不满足则stall
   └── CT_ED：停止继续取指
```

`CT_ED`只表示CT不再分派新指令。已经发射到executor但尚未完成的工作仍需排空。

因此Core真正结束通常要求：

```
CT已结束
    AND
所有executor空闲
    AND
所有必要副作用已经提交
```

------

# 11. 数据Executor执行流程

LD、LW、ST、DT、VP、PE、SI、SO等数据类指令进入统一的Data Executor Pipeline。

## 11.1 锁存执行参数

指令发射时锁存：

- 指令字段；
- 相关BR/AR等寄存器；
- 地址；
  -Shape和Stride；
- 数据格式；
- mail信息；
- semantic sequence ID。

锁存是为了防止指令等待期间寄存器被后续CT指令修改。

## 11.2 生成Deferred Memory Operation

Executor首先规划操作，而不是立即修改内存：

- 读取哪个存储空间；
- 起始地址；
- 访问范围；
- 读还是写；
- 数据格式；
- Tile布局；
- 目标owner；
- 是否为远端访问。

可以抽象为：

```
Instruction
    │
    ▼
Memory/Compute Plan
    ├── Read  L2(core0) [A, B)
    ├── Read  GDG       [C, D)
    └── Write L2(core0) [E, F)
```

这份规划同时服务于：

- 功能执行；
- Trace；
- Dependency Analysis；
- Analysis-only模式。

## 11.3 执行Payload

在`functional`或`full-debug`模式下，执行实际数据操作：

- 从源内存读取；
- 做格式转换；
- 执行VP或PE计算；
- 完成Tile布局转换；
- 将结果写入目标内存。

在`trace-only`或`analysis-only`模式下，大部分tensor payload不会真正materialize。

## 11.4 记录Effect

每条动态指令产生Effect Log，包括：

- 动态节点ID；
- Core和executor；
- PC；
- memory resource；
- 地址范围；
- 读写类型；
- mail和同步边；
- 发射与完成tick。

------

# 12. Memory Router与远端访问

所有数据访问通过Memory Router归一化处理。

```
Executor地址
     │
     ▼
判断地址类型
     │
     ├── 本地L2 ─────────► 当前Core L2
     ├── 本地GDG ────────► 当前Device GDG
     ├── 本地Weight ─────► 当前Core WDRAM
     └── Port Window
              │
              ▼
       Port Address Decoder
              │
              ▼
          Fabric Topology
              │
              ▼
     Remote Fabric Service
              │
              ▼
远端Device的L2/GDG/Weight DDR
```

如果出现以下情况，访问失败：

- 地址不属于有效空间；
- Port未连接；
- 目标Device不存在；
- 访问越界；
- 地址或尺寸不满足要求；
- 远端访问模式不受支持。

------

# 13. Mailbox与依赖处理

数据指令通常包含receive mail和send mail信息。

## 13.1 Receive Mail

指令发射前检查：

```
所需mail token是否全部存在？
   │
   ├── 否：保持等待，不消费token
   └── 是：原子消费token并允许发射
```

## 13.2 Send Mail

指令功能完成并提交副作用后：

```
完成数据写入
    │
    ▼
增加目标mailbox token
    │
    ▼
唤醒依赖该mail的后续指令
```

重要语义是：

> 数据指令的send mail应与完成/提交语义关联，而不是仅在指令进入executor时发送。

这样能够表达“数据真正可见后，下游才能启动”的依赖关系。

------

# 14. Timing计算

指令发射时，Cost Model根据指令类型和工作量计算：

```
TimingEstimate
    ├── latency_cycles
    ├── issue_gap_cycles
    ├── drain_prior
    └── retire_in_order
```

例如：

```
PE_CONV Latency =
    基础Latency
  + PE MAC数量 × 系数
  + minitile数量 × 系数
  + padding开销
```

调度器据此计算：

- 指令完成tick；
- 下一条同executor指令最早发射tick；
- 是否允许多指令in-flight；
- 是否需要等待前序任务排空；
- 是否允许越过前序指令退休。

当前校准的多in-flight pipeline主要用于`trace-only`性能路径。功能模式仍偏向保守执行，以保证Payload提交语义稳定。

------

# 15. 四种执行模式的流程差异

| 执行阶段             | Functional | Trace-only | Analysis-only | Full-debug |
| -------------------- | ---------- | ---------- | ------------- | ---------- |
| 取指和控制流         | 是         | 是         | 是            | 是         |
| Executor调度         | 是         | 是         | 是            | 是         |
| Mail和同步           | 是         | 是         | 是            | 是         |
| Timing计算           | 是         | 是         | 是            | 是         |
| Memory Effect规划    | 是         | 是         | 是            | 是         |
| Tensor Payload执行   | 是         | 否         | 否            | 是         |
| Dependency Analysis  | 显式启用时 | 否         | 是            | 是         |
| Trace输出            | 可选       | 主要输出   | 可选          | 是         |
| Dump和Golden Compare | 是         | 否         | 否            | 是         |

需要特别强调：

- `trace-only`适合研究调度tick和流水重叠；
- `analysis-only`适合快速检查内存依赖；
- 两者都不能证明Tensor数值结果正确；
- `functional`适合普通功能回归；
- `full-debug`信息最全，但运行成本也最高。

------

# 16. Launch结束与结果生成

当所有目标Core满足结束条件后，SystemSimulator进入收尾阶段。

## 16.1 Trace输出

根据配置输出：

- 每Core timing trace；
- 二进制trace；
- 可选JSON trace；
- 总event数量；
- trace是否因上限截断。

## 16.2 Dependency Conflict Analysis

如果启用分析：

1. 汇总本次Launch的Global Effect Log；
2. 构建happens-before graph；
3. 将远端访问归一化到实际memory owner；
4. 按memory resource扫描地址区间重叠；
5. 报告无可证明顺序的RAW、WAR和WAW；
6. 输出文本和JSON报告；
7. 如果启用`fail-on-conflict`，将冲突转为Launch失败。

## 16.3 更新Launch状态

执行成功：

```
queued → running → completed
```

执行失败：

```
queued → running → failed
```

错误信息包括：

- 译码失败；
- 非法地址；
- 越界访问；
- 未连接端口；
- 不支持的数据格式或指令模式；
- 同步失败；
- conflict gate失败；
- 内部执行异常。

------

# 17. One-shot的Dump与Golden Compare

Daemon完成Launch后，One-shot客户端继续完成case兼容流程：

1. 读取resident shared memory中的结果；
2. 按`init.json`指定范围dump；
3. 生成`simu_out*.bin`等输出；
4. 查找case中的golden文件；
5. 对比仿真结果和golden；
6. 根据对比结果返回进程退出码；
7. 清理临时Daemon和共享内存。

因此Golden Compare主要属于One-shot客户端的case生命周期，而不是Core Scheduler的指令执行逻辑。

------

# 18. PPT可直接使用的一页总结图

```
① 准备阶段
Case / Runtime
  └─ 准备代码、参数、输入、权重和共享内存

② 控制阶段
One-shot / Runtime
  └─ Register Device → Enqueue Launch → Wait Launch

③ 系统初始化
Daemon / SystemSimulator
  └─ 绑定Memory → 创建Core → 加载Topology和Cost Model

④ 指令推进
Global Event Loop
  └─ Executor完成 → CT取指译码 → 条件检查 → 指令发射

⑤ 数据执行
Data Executor Pipeline
  └─ 锁存参数 → 规划Effect → 可选Payload → 提交结果

⑥ 存储与同步
Memory Router / Mailbox / CT Sync
  └─ 本地或远端访问 → Mail发送消费 → 跨Core同步

⑦ 结果阶段
Trace / Analysis / Dump / Compare
  └─ 输出执行结果、冲突报告和Launch状态
```

一句话总结：

> C++版采用“Resident Daemon控制面 + SystemSimulator系统层 + 确定性事件调度 + Executor数据管线 + 统一存储路由 + Effect诊断”的分层执行架构，将指令控制、数值执行、性能时序和依赖分析组织在同一条Launch生命周期中。