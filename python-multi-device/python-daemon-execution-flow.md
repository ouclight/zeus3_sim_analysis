# Python Daemon 模式执行流程梳理

日期：2026-08-07  
代码基线：`feature/python-multi-device-port-fabric` / `b010516e82b826448be02c4606d9127a6fe56d53`

## 1. 结论摘要

仓库中存在两套 Python daemon 实现：

| 实现 | 入口 | 协议/连接 | 主要用途 |
|---|---|---|---|
| 正式 daemon package | `python -m npu_core_simulator.daemon` | 4-byte little-endian length + JSON；当前 server 仅接受 TCP；每个 request 建立一条连接 | `main.py --backend daemon` case-folder 执行，以及 runtime `register/enqueue_launch` resident 执行 |
| legacy daemon | `python main_torch_zeus.py --daemon` | 相同 framing；Unix domain socket；每条 connection 可发送多个 request | torch_zeus/runtime 的历史 resident、多连接/multi-rank 兼容路径 |

两者共享 `NPUSimulator` 和大部分 executor/memory 实现，但控制面、registration 生命周期、
launch 返回格式和调度模型不同。

正式 daemon package 是后续 topology 驱动多设备互连的推荐落点。它已经加载
`topology.json`、按 device 保存 registration，并提供固定 port 地址 decoder；但当前 topology
只用于 register 范围校验，尚未进入执行期访存路由。

legacy daemon 可以接受多个 device connection，并已支持 namespace-only register，但每个
connection 的 resident memory 相互独立，launch 由全局锁串行执行；`--topology` 当前只被 CLI
接受，没有加载或参与路由。

---

## 2. 正式 daemon package 的模块关系

```text
main.py --backend daemon
        │
        ▼
DaemonClient.transact()
        │  4B little-endian length + JSON
        ▼
npu_core_simulator.daemon.server
        │
        ▼
DaemonSession
  ├── enqueue_case ───────► case_runner.run_case
  ├── register ───────────► open_resident_memory
  ├── enqueue_launch ─────► runtime_launch.run_runtime_launch
  ├── query/wait/wait_all
  └── shutdown
        │
        ▼
ThreadPoolExecutor(max_workers=1)
        │
        ▼
NPUSimulator
```

主要文件：

| 文件 | 职责 |
|---|---|
| `main.py` | case CLI、backend 选择、daemon case client |
| `npu_core_simulator/daemon/__main__.py` | module 入口 |
| `npu_core_simulator/daemon/protocol.py` | framing、JSON 编解码、endpoint 解析 |
| `npu_core_simulator/daemon/client.py` | 同步 request/reply client |
| `npu_core_simulator/daemon/server.py` | TCP listen、connection thread、命令分发 |
| `npu_core_simulator/daemon/session.py` | launch records、executor、registrations、shutdown |
| `npu_core_simulator/daemon/resident_memory.py` | runtime-owned shared memory 映射 |
| `npu_core_simulator/daemon/runtime_launch.py` | resident launch request 到 `NPUSimulator` 的 adapter |
| `npu_core_simulator/case_runner.py` | case-folder 完整执行、dump、compare |

---

## 3. 正式 daemon 的启动流程

### 3.1 命令入口

```bash
python -m npu_core_simulator.daemon \
  --socket tcp://127.0.0.1:9000 \
  [--topology topology.json]
```

执行链：

```text
daemon/__main__.py
  → daemon.server.main()
  → build_parser()
  → run_server(endpoint, topology_path)
```

### 3.2 Topology 初始化

当调用方没有显式注入 `DaemonSession` 时：

```python
topology = FabricTopology.load_or_default(topology_path)
session = DaemonSession(topology=topology)
```

- 提供文件：读取并校验 `zeus3-port-v1` topology。
- 未提供文件：创建 device0、两个 core、四个 port 全断开的默认 topology。
- 当前 topology 只用于 `register` 的 device 范围检查。
- topology 当前没有传入 `NPUSimulator` 或 `InProcessFabric`。

### 3.3 Listener 与 connection thread

`protocol.parse_endpoint()` 可以解析 TCP 和 Unix endpoint，但正式 server 当前显式拒绝非 TCP：

```text
if parsed.kind != "tcp":
    raise RuntimeError(...)
```

server：

1. 创建 TCP listener。
2. `listen(16)`。
3. 每 0.2 秒检查一次 stop event。
4. 每 accept 一条连接，创建一个 daemon connection thread。
5. 每个 connection thread 只读取一个 request、返回一个 reply，然后关闭连接。

这意味着正式 `DaemonClient.transact()` 每次命令都会重新连接：

```text
connect → send one frame → read one frame → close
```

---

## 4. 正式 daemon 控制协议

### 4.1 Framing

```text
[4-byte little-endian body length][UTF-8 JSON body]
```

JSON 使用紧凑编码，不要求 ASCII-only。

### 4.2 支持的命令

| 命令 | 入口 | 作用 |
|---|---|---|
| `hello` | `DaemonSession.hello()` | 当前只返回 `{"status":"ok"}` |
| `enqueue_case` | `DaemonSession.enqueue_case()` | 异步执行完整 case-folder |
| `register` | `DaemonSession.register()` | 将 device 绑定到 resident shm namespace |
| `enqueue_launch` | `DaemonSession.enqueue_launch()` | 异步执行 runtime resident launch |
| `query_launch` | `DaemonSession.query_launch()` | 非阻塞查询 launch |
| `wait_launch` | `DaemonSession.wait_launch()` | 阻塞等待一个 launch |
| `wait_all` | `DaemonSession.wait_all()` | 按 launch id 顺序等待全部 launch |
| `shutdown` | `DaemonSession.shutdown(wait=False)` | 标记停止；server finally 中完成等待和资源释放 |

未知命令返回：

```json
{"status":"error", "error":"unknown cmd ..."}
```

### 4.3 Launch 状态

`LaunchRecord` 当前只保存：

```python
launch_id
future
```

状态由 `Future` 临时推导：

- future 未完成：`running`
- future 完成且 `RunResult.ok`：`ok`
- future 完成但结果失败或抛异常：`error`

当前没有独立的 `queued` 状态，因此在线程池排队但尚未执行的 launch 也会被报告为
`running`。

---

## 5. Case-folder daemon backend 执行流程

### 5.1 Client 侧

调用方式：

```bash
python main.py \
  -c /path/to/case \
  --backend daemon \
  --daemon-socket tcp://127.0.0.1:9000 \
  [其他普通 case 参数]
```

当前 `--backend daemon` 必须显式提供 `--daemon-socket`，不会自动启动临时 daemon。

执行序列：

```text
main.main()
  → validate_cli_args()
  → run_daemon_backend()
  → options_from_args()
  → dataclass as dict
  → 路径转为 client 侧绝对路径
  → transact(enqueue_case)
  → 获取 launch_id
  → transact(wait_launch)
  → 用 daemon exit_code 作为 CLI exit code
```

请求示意：

```json
{
  "cmd": "enqueue_case",
  "case_folder": "/abs/path/to/case",
  "options": {
    "case_folder": "/abs/path/to/case",
    "mode": "parallel-pc",
    "timing_policy": "middle",
    "trace_enabled": true,
    "compare_enabled": true
  }
}
```

### 5.2 Session 侧入队

`DaemonSession.enqueue_case()`：

1. 校验 `case_folder`。
2. 将兼容字段 `compare` 改名为 `compare_enabled`。
3. 构造 `CaseRunOptions`。
4. 在 session lock 内分配单调递增 `launch_id`。
5. 向 `ThreadPoolExecutor` 提交：

```python
run_case(case_folder, options)
```

6. 保存 `LaunchRecord`。
7. 立即返回 launch id。

默认 executor 为：

```python
ThreadPoolExecutor(max_workers=1)
```

因此 `enqueue_case` 和 `enqueue_launch` 共用一个全局串行工作队列。

### 5.3 Daemon worker 中的 case 生命周期

```text
case_runner.run_case
  → quiet_mode
  → load_case_data
      → 检查 case 目录和 init.json
      → 读取 init.json
      → 将 case/path 改写成 daemon 主机绝对路径
      → 加载 inst.json/指令定义
      → 注入 CLI options
      → 构造 NPUSimulator
  → apply_runner_options
      → timing cost overrides
      → serial fast mode
  → execute_simulator
      → run / run_parallel / run_parallel_PC
  → finalize_run
      → race summary（可选）
      → dependency conflict report
      → dump memory 与 trace
      → compare
      → RunResult
```

case artifacts 在 daemon 进程能够访问的 `case_folder` 下生成。client 与 daemon 不共享文件
系统时，仅把 client 本地绝对路径传给 daemon 是不够的。

---

## 6. Runtime resident launch 执行流程

resident 路径由外部 runtime/client 直接发送 `register` 和 `enqueue_launch`，不是
`main.py --backend daemon` 的 `enqueue_case` 路径。

### 6.1 Register

请求：

```json
{
  "cmd": "register",
  "device": 0,
  "shm_namespace": "zeus_v3_123_0"
}
```

处理流程：

```text
server.dispatch_request
  → DaemonSession.register
      → 拒绝 obsolete memory layout 字段
      → 解析 device/namespace
      → 检查 device < topology.device_count
      → open_resident_memory(namespace)
      → 创建 RuntimeRegistration
      → 安装到 _registrations[device]
      → 若旧 registration 存在，立即 close 旧 context
```

正式 daemon 明确拒绝：

```text
shm, shm_size, gdg0_base,
wdram_base, wdram_size, wdram_stride,
wdram_prefix, wdram_cores,
remote_address_map
```

### 6.2 Resident shared-memory 映射

namespace 展开为：

```text
<namespace>_gdg0
<namespace>_gdg1
<namespace>_wdram_c0
<namespace>_wdram_c1
```

`open_resident_memory()`：

1. 通过 `multiprocessing.shared_memory.SharedMemory(create=False)` 打开每个 segment。
2. 将 segment 映射为一维 `numpy.int8` view。
3. 为 GDG 创建一个 `MemoryManager`，挂载 GDG0/GDG1 external blocks。
4. 为两个 core 分别创建 weight `MemoryManager`。
5. 返回维度为单 die 的 `ResidentMemoryContext`：

```python
gdg_managers = [gdg_manager]
weight_managers = [[weight_core0, weight_core1]]
```

当前 adapter 明确拒绝 `die_number != 1`。runtime 拥有 shm 的创建和 unlink 生命周期；daemon
只负责 close 自己的 handle。

### 6.3 Enqueue launch

请求示意：

```json
{
  "cmd": "enqueue_launch",
  "device": 0,
  "entry_addrs": [1862290632704],
  "num_cores": 1,
  "core_ids": [1],
  "execution_mode": "functional"
}
```

`DaemonSession.enqueue_launch()`：

1. 拒绝 launch-level `remote_address_map`、`code_addr`、`args_addr`、`host_seq`。
2. 从 `_registrations[device]` 取当前 registration。
3. 未注册则立即返回错误。
4. 分配 `launch_id`。
5. 向同一个全局单 worker executor 提交：

```python
run_runtime_launch(request_copy, registration)
```

6. 立即返回 launch id。

registration 对象在 enqueue 时捕获，但当前没有 generation/refcount。若同一 device 在 launch
执行期间重新 register，session 会立即 close 旧 context，可能影响仍在使用旧 numpy/shm view
的 launch。

### 6.4 Request 到 simulator 参数

`run_runtime_launch()`：

1. 校验非空 `entry_addrs`。
2. 校验 `len(entry_addrs) == num_cores`。
3. 解析 `core_ids`：每个 entry 对应一个 device-local core slot；默认 `[0..N-1]`。
4. 检查 core id 非负且互不重复。
5. 校验 execution mode：
   - `functional`
   - `trace-only`
   - `analysis-only`
   - `full-debug`
6. 当前要求 request 的 `die_number` 省略或等于 1。
7. 构造 core-indexed `INSTRUCTION_ADDR` 和 `active_cores`。

当单个 entry 放到 core1 时：

```python
core_map = {
    "die_number": 1,
    "cores_per_die": 2,
    "INSTRUCTION_ADDR": [entry0, entry0],
    "active_cores": [1],
}
```

idle core0 也填可读 entry，因为正式 runtime adapter 没有启用 deferred instruction fetch，core
构造期间就会取指；idle core 之后不会被启动。

### 6.5 NPUSimulator 构造

```python
NPUSimulator(
    指令录入(),
    simu_params,
    memory_context=registration.memory_context,
)
```

构造过程：

1. 校验 external memory manager matrix 与 `core_map` 维度相同。
2. 直接复用 registration 的 GDG/weight managers，不按 case init 文件初始化 DDR。
3. 为所有 core slot 创建新的 `NPUCore`：
   - 新 PC/寄存器
   - 新 L2
   - 新 executor/dispatch worker
   - 新 CT/SISO 状态
4. 根据 `active_cores` 建立执行子集。
5. 构造旧 `RemoteAddressDecoder`：若没有 request/case remote map，则使用
   `default_remote_address_map(die_number=1, cores_per_die=...)`。
6. 每个 core 默认使用 `InProcessFabric`。

关键点：request 中的 `device` 没有传入 `NPUSimulator`。因此即使 registration key 是 device1，
新建 core 的物理 DID 仍为 0，执行期也看不到其他 device registration。

### 6.6 执行与完成

正式 resident launch 无论 active core 数量，当前固定调用：

```python
simulator.run_parallel_PC()
```

`run_parallel_PC()`：

1. 启用 memory-conflict serialization。
2. 启用本 `NPUSimulator` 内的 deterministic gate。
3. 启动每个 active core 的 `dispatch_thread_PC`。
4. join 全部 active core。
5. 汇总 worker thread exception。
6. 检查 dirty mailbox。
7. 关闭 deterministic gate。

随后只执行：

```python
simulator.report_dependency_conflicts()
```

正式 resident path 当前不调用 case runner 的 dump/compare。返回值是简化的 `RunResult`，
dependency report 是否成功决定 exit code。

---

## 7. Shutdown 流程

收到 `shutdown` request 时：

1. connection thread 先设置 server `stop_event`。
2. 调用 `session.shutdown(wait=False)`，只设置 `_shutting_down=True` 后立即回复。
3. listener loop 退出。
4. server `finally` 再调用 `session.shutdown()`：
   - `ThreadPoolExecutor.shutdown(wait=True, cancel_futures=False)`
   - 等待已入队 launch 完成
   - close 全部 current registrations
   - 设置 `_shutdown_complete`
5. listener 关闭。
6. connection threads 最多各 join `CONNECTION_JOIN_TIMEOUT_SECONDS`。

shutdown 后新的 enqueue 会被拒绝；已经提交的 future 不会被取消。

---

## 8. 正式 daemon 当前的并发模型

```text
TCP connection handling: 多线程
launch execution:         全局 ThreadPoolExecutor(max_workers=1)
device 内 active cores:   parallel-pc 多线程
不同 device launch:       串行
```

因此：

- 多个 client 可以并发发请求。
- launch 可以异步入队。
- 所有 case launch 和 resident launch 共享同一条串行队列。
- 同一个 launch 内的 active cores 可以并发。
- 不同 device 的 launch 当前不会同时执行。

---

## 9. Legacy `main_torch_zeus.py` daemon 流程

### 9.1 启动

```bash
python main_torch_zeus.py \
  --daemon \
  --socket /path/to/unix.sock \
  [--topology topology.json]
```

它使用 Unix domain socket。每 accept 一条 connection 创建一个 daemon thread，但该 thread
会循环读取多个 request，直到 connection 关闭。

### 9.2 Connection-local registration

每条 connection 持有自己的：

```python
ctx = {
    "device": ...,
    "gdg0_view": ...,
    "weight_views": ...,
    "scratch_dir": ...,
    "last_launch": ...,
}
```

支持两种 register wire shape：

1. 显式传 GDG/WDRAM layout 的旧格式。
2. 只传 `shm_namespace`，daemon 按固定 ABI 推导 shm 名、base、stride、size。

这里的多 device 表示多个 connection 各自注册一个 device context，不表示执行期已经能从一个
device 的 port 地址访问另一条 connection 的 memory。

### 9.3 Legacy launch

legacy 使用同步命令 `launch`，不是正式 daemon 的异步 `enqueue_launch/wait_launch`。

所有 connection 共用：

```python
launch_lock = threading.Lock()
```

因此 launch 流程为：

```text
connection thread
  → with global launch_lock
  → _daemon_run_launch(connection-local ctx)
  → 构造 fresh NPUSimulator(die_number=1)
  → 将 GDG/weight DDR block 指向该 connection 的 shm view
  → active core 延迟取指
  → 单核默认 serial；多核默认 parallel-pc
  → conflict/race summary
  → 同步 reply
```

每次 launch 新建 PC、寄存器、L2 和执行器；GDG/weight shm 跨 launch 保留。

### 9.4 Legacy topology 的真实状态

CLI 接受 `--topology`，但当前代码没有读取 `_a.topology`、没有创建 `FabricTopology`，也没有把
它传给 simulator。因此该参数目前只是启动命令兼容项，不参与：

- device 数量校验
- port target 查询
- remote GDG/LDG/L2 路由

legacy daemon 上 multi-rank 测试通过，只能证明多 connection resident launch 和 runtime 层
协作可用，不能证明 simulator 内的多设备 port-fabric 已经可用。

### 9.5 Legacy 与正式 daemon 的协议差异

| 项目 | 正式 daemon package | legacy daemon |
|---|---|---|
| Socket | 当前仅 TCP | Unix domain socket |
| Connection | 一个 request/reply 后关闭 | 同一 connection 可循环多次 request/reply |
| 成功状态 | `"status":"ok"` | `"status":0` |
| Runtime launch | `enqueue_launch` + `wait_launch` | 同步 `launch` |
| Case-folder | 支持 `enqueue_case` | 不走 case runner daemon protocol |
| Registration owner | session `_registrations[device]` | connection-local `ctx` |
| Launch scheduler | 全局单 worker executor | 全局 `launch_lock` |
| Topology loader | 有 | 无，CLI 参数未使用 |

---

## 10. 当前多设备能力边界

正式 daemon 已经具备：

- daemon 启动时加载并校验 topology。
- register device 必须位于 topology 范围内。
- 可同时保存多个 device registration。
- 每个 device resident GDG0/GDG1/WDRAM 映射能力。
- `core_ids`/`active_cores` device-local core placement。
- 固定 `zeus3-port-v1` port address decoder（目前未接执行路径）。
- LD/ST/CT/SISO/fetch 的 Fabric seam。

尚未具备：

- session 级 `ResidentFabricContext`。
- registration generation/lease。
- source device + port id 到 target device 的执行期 router。
- launch request 的 physical `device` 注入 core DID。
- 一个 launch 访问其他 device registration。
- session-addressable remote L2。
- active-core launch-start L2 reset contract。
- per-device launch queue 和不同 device 并发。
- session 级跨设备 SISO。
- topology digest/capability hello。
- 跨 launch/device conflict detection 和全局 deterministic ordering。

当前正式 resident 执行实质上仍是：

```text
registration[device N]
  → 构造一个 die_number=1、DID=0 的 NPUSimulator
  → 仅访问该 registration 的 memory_context
```

目标多设备执行应演进为：

```text
DaemonSession
  → ResidentFabricContext(topology, registration generations, session L2)
  → launch(device N) 获取 RegistrationLease
  → core physical DID=N
  → PortFabric router(source=N, raw address)
  → target device GDG/LDG/L2
```

---

## 11. 建议的调试观察点

### 控制面

- server 收到的 command、connection/thread id。
- launch id、device、core_ids、execution mode。
- topology ABI、device count、digest。
- registration namespace、generation、refcount、retired 状态。

### 执行面

- core physical DID/CID 与 launch-local slot。
- raw address、port id、inner address。
- routed target device/core/space/index。
- active core L2 reset 时机。
- disconnected/unregistered/capacity error 分类。

### 生命周期

- launch 入队、开始、完成、失败。
- registration lease acquire/release。
- retired shm context 实际 close 时机。
- shutdown 时 pending futures、active workers、remaining leases。

---

## 12. 一句话流程概括

正式 Python daemon 当前是一个“TCP 控制面 + 全局单 worker + 每 launch 新建
`NPUSimulator` + per-device resident shm registration”的异步执行器；它已具备 topology 控制
面和多 device registration，但执行期仍是单 device，尚缺把 topology、所有 registration 和
session L2 统一起来的 resident port-fabric 数据面。

