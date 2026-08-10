# C++ `SystemSimulator::run_launch` 执行流程解析

分析对象：`cpp/src/runtime/system_simulator.cpp:191`

分析基线：分支 `feature/python-multi-device-port-fabric`，commit `c921fe6bbf62`

## 1. 函数定位

```cpp
SystemSimulatorResult SystemSimulator::run_launch(
    const SimConfig& config,
    Decoder& decoder,
    CostModel& cost_model,
    const SystemSimulatorOptions& options);
```

`run_launch` 是一次系统级 launch 的总编排器。它本身不解释每一条指令，也不直接实现 LD、ST、PE、SI、SO 等执行语义；这些工作由每个 `CoreInstanceRuntime` 内部的 `TickScheduler` 和 executor 完成。

它主要负责：

1. 确定本次 launch 的 die/core 拓扑和活跃核集合；
2. 创建或借用系统级内存、互连队列、CT 同步状态；
3. 为每个活跃核构造 `CoreInstanceRuntime`；
4. 用一个确定性的全局事件循环轮询推进各核；
5. 在安全时对所有核统一 fast-forward；
6. 执行 trace、dump、依赖冲突分析和 golden compare 等收尾工作；
7. 汇总并返回 launch 是否成功。

可以把它理解为：

```text
配置和运行选项
      │
      ▼
建立/接入系统资源
  ├─ SystemMemoryContext：GDG、LDG、L2
  ├─ MemoryRouter：本地/远端地址路由
  ├─ InterCoreQueue[][]：SISO 通信
  └─ CoreSyncContext：CT wait/signal
      │
      ▼
为每个 active core 创建 CoreInstanceRuntime
      │
      ▼
全局循环：按稳定顺序每核 step 一次 → 计算公共 fast-forward 窗口
      │
      ▼
finalize → 冲突分析 → dump/golden compare → success
```

## 2. 输入与输出

### 2.1 `config`

`SimConfig` 提供系统规模、指令入口、case 初始化数据、dump 信息和数值模式等静态配置。

本函数直接依赖的关键字段包括：

- `config.core_map.die_number`
- `config.core_map.cores_per_die`
- `config.core_map.instruction_addrs`
- `config.dies[*].gdg_inits/gdg_dumps`
- `config.core_configs[*][*].weight_inits/weight_dumps`
- `config.float2fixed_rounding_mode`

die 数和每 die 核数均通过 `std::max(1, ...)` 归一化，因此配置为 0 时实际按 1 处理。

全局线性核号定义为：

```text
linear_core_id = die * cores_per_die + core
```

### 2.2 `decoder`

所有核共享同一个 `Decoder` 引用。每个核初始化时从其所属 die 的 GDG 中读取入口地址对应的指令流，并调用 `decoder.decode_program()` 解码到该核自己的 `program`。

### 2.3 `cost_model`

所有核和 `MemoryRouter` 共享同一个 `CostModel`。它既提供 executor 的时延模型，也提供远端 fabric memory access 的成本。

### 2.4 `options`

`SystemSimulatorOptions` 同时承载普通 case 模式和 daemon resident 模式的运行参数。主要分为：

- 输出控制：`verbose`、trace 路径、case 目录；
- pipeline 控制：执行模式、是否物化内存、是否 dump、是否 golden compare、是否做冲突分析；
- PE GEMM 后端及统计；
- resident 参数：入口地址、活跃核；
- 外部资源注入：系统内存、SISO 队列、CT 同步上下文、fabric topology、共享内存锁。

### 2.5 返回值与异常

返回值目前只有：

```cpp
struct SystemSimulatorResult {
    bool success = true;
};
```

`success=false` 的典型来源是：

- 某个活跃核初始化失败，例如入口地址无法读取或程序为空；
- 某个核 finalize 后状态不正常，例如 dump 失败；
- 开启 `fail_on_conflict` 后检测到依赖冲突；
- golden compare 失败。

拓扑越界、外部资源尺寸不足、路由失败等结构性错误通常直接抛异常，不会转换成 `success=false`。调用者需要负责捕获异常；daemon 的 device worker 就在更外层把异常转换为 launch failed 状态。

## 3. 详细执行阶段

## 3.1 计算逻辑拓扑

代码位置：`system_simulator.cpp:196-198`。

函数首先计算：

```cpp
dies = max(1, die_number);
cores_per_die = max(1, cores_per_die);
cores_total = dies * cores_per_die;
```

这里描述的是本次 `run_launch` 可见的完整逻辑拓扑，不等于一定会运行所有核。真正参与本次调度的集合稍后由 `active_linear_cores` 决定。

## 3.2 建立或借用 `SystemMemoryContext`

代码位置：`system_simulator.cpp:200-230`。

存在两条路径。

### 普通 case 模式

当 `options.external_memory_context == nullptr` 时，函数创建 launch-local `SystemMemoryContext`：

- 每个 die 有自己的 GDG；
- 每个 core 有自己的 LDG 和 L2；
- 可用 `external_gdgs`、`external_weight_ddrs` 局部替换 GDG/LDG backing；
- 最后调用 `load_from_config()` 加载 case 中的 GDG/weight 初始化文件。

这些资源的生命周期只持续到本次 `run_launch` 返回。

### daemon resident 模式

当传入 `external_memory_context` 时，函数直接借用 session/fabric 级内存：

- 不创建 launch-local 内存；
- 不调用 `load_from_config()`；
- 不重新绑定 `external_gdgs` 或 `external_weight_ddrs`；
- 多个 device worker 的 launch 可以看到同一份 fabric memory view。

随后会校验外部内存拓扑至少覆盖本次配置声明的 `dies × cores_per_die`。这里只检查维度“不小于”，不要求完全相等。

## 3.3 建立全局内存视图和地址路由器

代码位置：`system_simulator.cpp:232-253`。

函数把系统内存整理成供各核借用的扁平指针视图：

- `gdg_ptrs[die]`：每 die 一个 GDG；
- `l2_ptrs[linear_core]`：每核一个 L2；
- `weight_ptrs[linear_core]`：每核一个 LDG/weight DDR。

随后创建：

```cpp
PortAddressDecoder port_decoder;
MemoryRouter memory_router(
    *system_memory,
    &port_decoder,
    options.fabric_topology,
    cost_model,
    options.memory_mutex);
```

这一步是多设备互连的关键：

- `PortAddressDecoder` 解释固定 port-window 地址 ABI；
- `MemoryRouter` 先识别 issuing core 的本地 GDG/LDG；
- 对 port-window 地址，根据 `fabric_topology` 将 `(issuing device, port id)` 映射到目标 device；
- 最终把访问路由到目标设备/核的 L2、GDG 或 LDG；
- 若传入 `memory_mutex`，路由解析和读写会受共享递归锁保护，以协调并发 device workers。

没有 `fabric_topology` 并不影响普通本地地址访问，但真正的 remote port 访问会因缺少 topology 而失败。

## 3.4 建立或借用系统级 SISO 队列矩阵

代码位置：`system_simulator.cpp:255-270`。

SISO 队列被组织为：

```text
ic_queues[source_linear_core][target_linear_core]
```

如果没有传入 `external_inter_core_queues`，本函数创建一个 `cores_total × cores_total` 的 launch-local 队列矩阵；否则借用外部矩阵。

外部矩阵必须至少覆盖整个逻辑拓扑。函数会检查行数和每行列数，不足时抛异常。

在 daemon 模式中，外部队列来自 session 的 `RemoteFabricService`，因此不同 device worker 创建的 `CoreInstanceRuntime` 可以通过同一个队列矩阵交换 SISO 数据。

## 3.5 推导 pipeline 行为

代码位置：`system_simulator.cpp:271-280`。

函数从 pipeline 和命令行选项派生四个开关：

- `run_conflict_analysis`：pipeline 请求、指定报告目录或 `fail_on_conflict` 任一成立即开启；
- `collect_effect_log`：与冲突分析同步开启；
- `materialize_memory`：是否真正执行数据 payload 对内存的影响；
- `dump_outputs`：要求 phase3、pipeline dump 和物化内存同时开启；
- `compare_outputs`：要求 pipeline compare、未设置 `no_compare` 且物化内存。

因此 trace-only 等不物化内存的模式不会 dump 或做 golden compare。

## 3.6 选择 CT 同步上下文和活跃核

代码位置：`system_simulator.cpp:282-293`。

若没有传入 `external_sync_context`，函数创建 launch-local `LaunchCtSyncContext`。其 token 逻辑是：

```text
tokens[waiter_linear_core][sender_linear_core]
```

- signal 向目标核对应的 sender token 加一；
- wait 只有在 mask 指定的所有 source token 均大于 0 时才一次性各减一；
- mask bit 超过拓扑核数时抛异常。

daemon 模式传入 `RemoteFabricService` 作为外部 CT 上下文，使 CT 同步状态可以超出单次 `run_launch` 的局部生命周期，并与其他 device worker 协作。

活跃核来自 `options.active_linear_cores`。若该 vector 为空，语义不是“运行零个核”，而是“运行拓扑中的所有核”。因此当前 API 无法用空 vector 明确表达零活跃核。

## 3.7 为每个活跃核构造 `CoreInstanceRuntime`

代码位置：`system_simulator.cpp:295-327`。

每个线性核号先做范围检查，再反算：

```text
die  = linear / cores_per_die
core = linear % cores_per_die
```

随后构造 `CoreInstanceContext`，把系统级资源和核级身份一次性注入该 runtime。关键绑定包括：

- 本核的 `(die, core)`；
- 本 die 的 GDG；
- 全拓扑 L2 指针数组；
- 全拓扑 SISO 队列矩阵；
- 本核 LDG；
- `MemoryRouter`；
- CT 同步上下文；
- resident entry address；
- 本核的全局 L2/queue index；
- 可选的全局 effect log。

`CoreInstanceRuntime::initialize()` 进一步完成：

1. 取得或创建 weight DDR；
2. 从 GDG 的入口地址读取并解码程序；
3. 初始化 `CoreState`，包括 DID、CID、PC、栈和舍入模式；
4. 创建 CT/LD/LW/PE/DT/VP/ST/SI/SO executor；
5. 将 LD、ST、LW、SI、SO 接到统一 `MemoryRouter`；
6. 将 SI/SO 接到全局队列矩阵；
7. 初始化 `TickScheduler`，注册 CT、同步和 data-executor 回调。

任一核初始化返回 false 时，`result.success` 会立即置为 false，但函数仍保留该 runtime，并继续初始化和执行其他核。初始化失败的 runtime 因 `skipped=true` 被视为 done。

## 3.8 全局确定性 tick 循环

代码位置：`system_simulator.cpp:329-355`。

核心循环为：

```text
while 仍有未完成核：
    all_done = true
    按 active_linear_cores 的 vector 顺序：
        未完成核执行一次 runtime.step()
        若仍未完成，则 all_done = false
    若全部结束：退出
    计算所有未完成核共同安全的 fast-forward 窗口
    skip == 0：下一轮继续逐 tick 推进
    skip == unbounded：yield 当前 OS 线程，等待外部 fabric 事件
    其他：所有未完成核统一 fast_forward(skip)
```

这里有三个重要语义。

### 每个 `step()` 是核级一个 tick

`CoreInstanceRuntime::step()` 最终调用本核 `TickScheduler::step()`。一个 scheduler tick 会推进 executor、处理 CT dispatch，并收集 trace 事件。

### 同一次 `run_launch` 内不是多线程并行核

所有活跃核由一个线程按 `active_linear_cores` 的稳定顺序协作推进。这带来确定性，但它不是“每核一个线程”。

daemon 可以有多个 device worker 线程；这时每个 worker 各自运行一个 `run_launch` 循环，并借助共享 memory、queue 和 sync context 进行跨设备通信。

### fast-forward 必须对所有未完成核安全

`compute_global_fast_forward_window()` 收集各 runtime 的 `idle_fast_forward_limit()`：

- 任一核返回 0：不能跳，继续逐 tick；
- 有有限窗口：取所有有限值中的最小值，并让所有未完成核跳相同 tick 数；
- 所有活跃核都无限等待：返回 `kUnboundedFastForward`，调用 `std::this_thread::yield()`。

统一取最小窗口可避免某个核跳过它本应观察到的内部事件。

`kUnboundedFastForward` 在 async daemon 场景不是立即判定死锁，因为另一个 device worker 之后可能发布当前核等待的远端 SISO/CT/fabric 事件。因此函数选择保持 launch 存活并让出 CPU。

需要注意：这里没有超时或死锁检测。如果所有相关设备都不会再产生所需事件，launch 可能无限 yield，直到进程被外部停止。

局部变量 `global_tick` 只在本函数中累加，目前不参与返回值、日志或调度判断；每核权威时间仍是各自 `TickScheduler::current_tick()`。

## 3.9 核级收尾

代码位置：`system_simulator.cpp:356-360`。

主循环结束后，先汇总检查每核 mailbox。若存在未消费 token，只打印 grouped warning，不把 launch 判为失败。这与 Python backend 的策略保持一致。

随后对每个 runtime 调用 `finalize()`：

- 将该核的 runtime effect 转换并追加到系统级 `GlobalEffectLog`；
- 打印 tick/event 统计；
- 写 binary/JSON trace；
- 按配置 dump GDG/weight 输出。

finalize 后若某核 `ok()==false`，系统结果置为失败。

## 3.10 系统级冲突分析

代码位置：`system_simulator.cpp:362-368`。

若启用冲突分析，所有活跃核的 effect 会合成一份 dependency trace，再由 `DependencyConflictAnalyzer` 分析。

指定报告目录时生成：

- `conflicts_system.txt`
- `conflicts_system.json`

只有 `fail_on_conflict=true` 时，发现冲突才会把 launch 标记为失败；否则报告用于诊断，不改变成功状态。

## 3.11 dump 后的 golden compare

代码位置：`system_simulator.cpp:370-379`。

仅当 `dump_outputs && compare_outputs` 时执行。函数从第一条 GDG dump 或 weight dump 推导 `df`，然后对 `case_folder` 调用 `compare_golden()`。

daemon 通常设置 `no_compare=true`，因为输出保留在共享内存中，由 runtime 通过 D2H 读取，不走 case 文件的 golden compare 流程。

## 4. 普通 case 模式与 daemon 模式对比

| 项目 | 普通 case 模式 | daemon resident 模式 |
|---|---|---|
| 内存所有权 | `run_launch` 创建 launch-local `SystemMemoryContext` | 借用 session 的 `RemoteFabricService::memory()` |
| 初始化数据 | `load_from_config()` 加载文件 | 数据已通过注册/shared memory 驻留 |
| 指令入口 | `config.core_map.instruction_addrs` | `options.entry_addrs` |
| 活跃核 | 默认整个拓扑 | 通常只包含目标 device 本次提交的核 |
| SISO 队列 | launch-local 矩阵 | session 共享矩阵 |
| CT 同步 | launch-local token 矩阵 | session/fabric 外部同步上下文 |
| fabric topology | 可选；远端访问需要 | 由 daemon 启动时 topology 提供 |
| 内存并发锁 | 通常为空 | 使用 fabric 共享 `recursive_mutex` |
| dump/golden | 按 pipeline/case 选项执行 | 通常关闭 golden compare，结果留在 resident memory |
| 并发模型 | 一个 `run_launch` 顺序推进全部活跃核 | 每 device 一个 worker；每 worker 各有一个 `run_launch` |

## 5. daemon 调用关系

daemon 路径的直接调用位于 `cpp/src/daemon/daemon.cpp`：

```text
客户端 enqueue_launch(device=N)
    │
    ▼
AsyncSession 将 launch_id 放入 device N 的工作队列
    │
    ▼
device_worker_loop(N)
    │
    ▼
run_device_launch(...)
    ├─ 把 device-local core placement 转为全局 linear core id
    ├─ 构造全拓扑 global_entry_addrs
    ├─ 仅把本设备本次核加入 active_linear_cores
    ├─ 注入 RemoteFabricService 的共享资源
    └─ 调用 SystemSimulator::run_launch(...)
```

所以“一次 daemon launch 请求”仍只针对一个 device。多设备并发由多个 device worker 的独立 `run_launch` 调用组成，跨设备可见性由以下共享对象保证：

- `SystemMemoryContext`
- `InterCoreQueue` 矩阵
- `CoreSyncContext`/`RemoteFabricService`
- `FabricTopology`
- memory mutex

这一区分非常关键：`config` 描述的是完整 fabric 的地址空间规模；`active_linear_cores` 描述本次 worker 实际推进哪些核。

## 6. 成功、失败和阻塞语义总结

| 情况 | 行为 |
|---|---|
| 活跃核入口无映射或程序为空 | 该核跳过，`success=false`，其他核继续 |
| active core 越界 | 抛 `std::out_of_range` |
| 外部 memory/queue 拓扑太小 | 抛异常 |
| remote port 无 topology 或未连接 | 内存执行阶段抛异常 |
| mailbox 有剩余 token | 仅 warning，不失败 |
| 冲突存在但未设置 `fail_on_conflict` | 可产出报告，不失败 |
| 冲突存在且设置 `fail_on_conflict` | `success=false` |
| dump 或 golden compare 失败 | `success=false` |
| 所有未完成核等待外部无倒计时事件 | 持续 `yield()` 等待，不自动失败或超时 |

## 7. 阅读该函数时应特别注意的设计点

1. `run_launch` 是资源与调度编排层，具体指令语义在 `CoreInstanceRuntime`、`TickScheduler` 和 executor 中。
2. `active_linear_cores` 决定实际执行集合；逻辑拓扑仍可能覆盖更多未在本次 launch 中运行的核。
3. 本函数始终创建一个新的 `MemoryRouter`，但它可以指向 session 共享的 memory/topology/mutex。
4. 同一 `run_launch` 内各核是单线程、稳定顺序推进；跨设备并发来自 daemon 的多个 worker。
5. launch-local CT 上下文和 daemon 外部 CT 上下文的生命周期不同，不能把前者的 token 生命周期套用到 resident session。
6. 空 `active_linear_cores` 表示全核运行，不表示 no-op。
7. `success=false` 与抛异常是两条不同的失败通道。
8. 外部事件无限等待是为异步跨设备协作保留的行为，同时也是潜在永久挂起点。

## 8. 关键源码索引

- `cpp/src/runtime/system_simulator.cpp:35-80`：launch-local CT token 上下文
- `cpp/src/runtime/system_simulator.cpp:98-115`：全局 fast-forward 窗口计算
- `cpp/src/runtime/system_simulator.cpp:117-154`：系统依赖冲突分析
- `cpp/src/runtime/system_simulator.cpp:156-187`：dirty mailbox 汇总告警
- `cpp/src/runtime/system_simulator.cpp:191-230`：拓扑与系统内存生命周期
- `cpp/src/runtime/system_simulator.cpp:232-270`：内存视图、路由器和 SISO 队列
- `cpp/src/runtime/system_simulator.cpp:271-293`：pipeline、同步上下文和 active cores
- `cpp/src/runtime/system_simulator.cpp:295-327`：每核 runtime 构造与初始化
- `cpp/src/runtime/system_simulator.cpp:329-355`：全局 tick/fast-forward 循环
- `cpp/src/runtime/system_simulator.cpp:356-381`：finalize、分析、compare 和返回
- `cpp/src/runtime/core_instance.cpp:82-150`：核 runtime 初始化、step 和 finalize
- `cpp/src/runtime/core_instance.cpp:190-237`：resident/case 指令入口读取和解码
- `cpp/src/runtime/core_instance.cpp:257-323`：executor、远端路由与 SISO wiring
- `cpp/src/runtime/core_instance.cpp:325-386`：`TickScheduler` 回调 wiring
- `cpp/src/runtime/memory_router.cpp:36-109`：本地/port-window/fabric 地址解析
- `cpp/src/daemon/daemon.cpp:265-365`：daemon 对 `run_launch` 的适配与调用

