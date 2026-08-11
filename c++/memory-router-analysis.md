# C++ 仿真器 `MemoryRouter` 介绍与执行流程

分析对象：

- `cpp/include/zeus3sim/runtime/memory_router.h`
- `cpp/src/runtime/memory_router.cpp`

分析基线：分支 `feature/python-multi-device-port-fabric`，commit `c921fe6bbf62`

## 1. 定位与核心职责

`MemoryRouter` 是 C++ 仿真器的统一内存地址路由层。它接收：

```text
发起访问的核 CoreId{device/die, core}
+ 指令产生的原始地址 raw_addr
+ 访问长度 size_bytes
+ 本次指令允许访问的空间集合
```

然后确定：

```text
地址属于 L2、GDG 还是 LDG
+ 资源由哪个 device/die、哪个 core 拥有
+ port-window 地址映射后的真实目标地址
+ 是否为跨设备访问
+ 依赖分析中何时对远端可见
```

它把地址解释、拓扑路由、实际 backing 选择和访问日志连接起来，但不拥有内存。

可以把整体关系概括为：

```text
LD / ST / LW / SI / SO executor
                 │
                 ▼
           MemoryRouter
        ┌────────┼─────────┐
        ▼        ▼         ▼
PortAddress   Fabric     CostModel
Decoder       Topology   remote cost
        └────────┼─────────┘
                 ▼
        SystemMemoryContext
     ┌───────────┼───────────┐
     ▼           ▼           ▼
  GDG[die]   L2[die,core]  LDG[die,core]
```

关键职责边界如下：

| 组件 | 负责什么 | 不负责什么 |
|---|---|---|
| `PortAddressDecoder` | 解码固定 local/port-window address ABI | 不知道 port 连到哪个 device |
| `FabricTopology` | 给出 source device 的某个 port 连接到哪个 target device | 不解释地址、不持有内存 |
| `SystemMemoryContext` | 持有或绑定所有 device/core 的 GDG、L2、LDG | 不根据 port 地址选择 owner |
| `MemoryRouter` | 组合前三者，完成 owner/地址解析及实际读写 | 不解析指令 tile 描述、不模拟网络包 |
| executor | 解释 LD/ST/LW/SI/SO 的指令和 tile 语义 | 不应自行维护跨设备 backing 指针表 |

## 2. 构造参数与生命周期

```cpp
MemoryRouter(SystemMemoryContext& memory,
             const PortAddressDecoder* decoder,
             const FabricTopology* fabric_topology,
             const CostModel& cost_model,
             std::recursive_mutex* memory_mutex = nullptr);
```

五个参数均为借用关系：

- `memory`：完整系统 memory view；
- `decoder`：local aperture 和 remote port-window 解码器，可以为空；
- `fabric_topology`：port 到 target device 的映射，可以为空；
- `cost_model`：远端 memory cost 来源；
- `memory_mutex`：可选共享递归锁，用于并发 device worker。

`MemoryRouter` 不接管这些对象的生命周期，它们必须比 router 活得更久。

`SystemSimulator::run_launch()` 每次调用都会创建一个局部 `PortAddressDecoder` 和一个局部 `MemoryRouter`，再把 router 指针注入本次 launch 的所有活跃核。

普通 case 模式中，router 通常指向 launch-local `SystemMemoryContext`；daemon resident 模式中，各 device worker 的 router 指向同一个 session `RemoteFabricService::memory()`、同一 topology 和同一 memory mutex。

## 3. 内存所有权模型

C++ 系统内存采用：

```text
device == die
```

`SystemMemoryContext` 的资源粒度是：

- `GDG[die]`：每个 device/die 一份共享 GDG manager，其中可包含 GDG0、GDG1 block；
- `L2[die, core]`：每个 core 一份 L2；
- `LDG[die, core]`：每个 core 一份 weight DDR/LDG。

`CoreTopology` 提供：

```text
linear_core = die * cores_per_die + core
```

resident daemon 可以用 runtime-owned shared-memory DDR manager 替换某个 die 的 GDG 或某个 core 的 LDG；router 始终通过 `SystemMemoryContext::gdg()/ldg()/l2()` 取 backing，因此不需要知道 backing 是内部 vector 还是外部 shm mapping。

## 4. Port-fabric 地址 ABI

当前 ABI 名称为：

```text
zeus3-port-v1
```

每个 device 固定有 4 个远端 port，每个 device 固定有 2 个 core。

## 4.1 Port window

| Window | 地址范围 | 计算方式 |
|---|---|---|
| Local | 不加 port base | 当前 device 的 local aperture address |
| Port 0 | `[0x80000000000, 0xA0000000000)` | `0x80000000000 + target_local_addr` |
| Port 1 | `[0xA0000000000, 0xC0000000000)` | `0xA0000000000 + target_local_addr` |
| Port 2 | `[0xC0000000000, 0xE0000000000)` | `0xC0000000000 + target_local_addr` |
| Port 3 | `[0xE0000000000, 0x100000000000)` | `0xE0000000000 + target_local_addr` |

远端地址的形式是：

```text
raw_addr = port_base(port_id) + target_device_local_aperture_address
```

地址本身只携带 port ID，不直接携带 target device ID。目标 device 必须根据发起访问的 source device 和 topology 共同确定。

## 4.2 Local target aperture

| 空间 | Base | Aperture size | `target_index` |
|---|---:|---:|---:|
| NPU0 L2 | `0x00100000000` | `0x200000` | 0 |
| NPU1 L2 | `0x00101000000` | `0x200000` | 1 |
| LDG0 | `0x10000000000` | `0x400000000` | 0 |
| GDG0 | `0x10F00000000` | `0x40000000` | 0 |
| LDG1 | `0x11000000000` | `0x400000000` | 1 |
| GDG1 | `0x11F00000000` | `0x40000000` | 1 |

对 L2，解码后的 `target_addr` 是 L2 内部 byte offset；对 GDG/LDG，`target_addr` 保留目标 memory space 的硬件基址加 offset。

## 4.3 `allowed_spaces`

调用者传入 `std::vector<RemoteSpace>` 限制 port decoder 可以接受的空间，例如：

```cpp
{RemoteSpace::L2}
{RemoteSpace::GDG, RemoteSpace::LDG}
{RemoteSpace::L2, RemoteSpace::GDG, RemoteSpace::LDG}
```

它用于防止某条只允许 LDG 的指令把地址错误解释成 L2/GDG。

Port decoder 同时检查整个 `[addr, addr + size)` 是否落在同一个 port window 和同一个 aperture 内，越界返回 no-hit。

## 5. Topology 的作用

Topology JSON 只描述 port 连接关系。例如：

```json
{
  "address_abi": "zeus3-port-v1",
  "devices": [
    {
      "id": 0,
      "cores": 2,
      "ports": {
        "0": {"target_device": 1},
        "1": null,
        "2": null,
        "3": null
      }
    },
    {
      "id": 1,
      "cores": 2,
      "ports": {
        "0": {"target_device": 0},
        "1": null,
        "2": null,
        "3": null
      }
    }
  ]
}
```

当 D0 访问 port 0 时：

```text
FabricTopology::target_device(0, 0) == 1
```

Topology 有以下约束：

- device ID 必须从 0 连续编号；
- 每个 device 必须恰好 2 cores；
- 必须声明 4 个 port；
- port 可以是 `null` 或一个 target device；
- target device 必须存在。

连接是按 source device 独立声明的；代码不自动要求双向对称。若需要 D0→D1 和 D1→D0，必须分别配置。

没有 topology 文件时，默认是 single-device、全部 remote ports disconnected。此时本地访问仍可工作，真正 remote port 访问失败。

## 6. `RoutedAddress` 表示什么

`resolve()` 返回 `RoutedAddress`：

| 字段 | 含义 |
|---|---|
| `kind` | 最终资源类型：L2/GDG/LDG |
| `owner` | 资源所有者；L2/LDG 使用 die+core，GDG 主要使用 die |
| `target_index` | L2/LDG core index 或 GDG0/GDG1 index |
| `raw_addr` | 指令原始地址，保留 port prefix |
| `target_addr` | 去掉 port window 后、供目标 backing 使用的地址 |
| `target_base_addr` | 目标 aperture/backing base |
| `size_bytes` | 访问长度 |
| `mapped` | 是否经过 `PortAddressDecoder` aperture 解码 |
| `remote` | 是否使用 remote port window |
| `fabric_cost` | CostModel 中的 remote memory cost |

`mapped` 和 `remote` 不是同一个概念：

- 直接命中本地 GDG/issuer LDG backing：`mapped=false, remote=false`；
- 通过 local aperture 解码到同 device L2/LDG/GDG：`mapped=true, remote=false`；
- 通过 port window 解码：`mapped=true, remote=true`。

`owner.core` 对 die-shared GDG 没有实际寻址意义，代码将其设为 0；真正区分 GDG0/GDG1 的是 `target_index`。

`RoutedAddress::resource()` 把结果转换成依赖分析的全局资源身份：

- L2 → `MemoryResource::l2(owner.die, owner.core)`；
- GDG → `MemoryResource::gdg(owner.die)`，并用 `space` 区分 GDG0/GDG1；
- LDG → `MemoryResource::weight(owner.die, owner.core)`。

## 7. `resolve()` 的详细流程

代码位置：`memory_router.cpp:36-109`。

流程如下：

```text
resolve(issuer, raw_addr, size, allowed_spaces)
        │
        ├─ size == 0 → invalid_argument
        ├─ issuer 不在 memory topology → out_of_range
        │
        ▼
raw_addr 是否直接落入 issuer.die 的 GDG backing？
        ├─ 是 → owner=issuer.die，kind=GDG，直接返回
        │
        ▼
raw_addr 是否直接落入 issuer core 的 LDG backing？
        ├─ 是 → owner=issuer，kind=LDG，直接返回
        │
        ▼
调用 PortAddressDecoder::lookup_address()
        ├─ no hit → MemoryRouter: MISS
        │
        ▼
hit.remote ?
        ├─ 否 → target_device = issuer.die
        └─ 是 → topology.target_device(issuer.die, port_id)
                   ├─ 无 topology → missing fabric topology
                   ├─ port=null → disconnected port
                   └─ 得到 target_device
        │
        ▼
target_core = GDG ? 0 : hit.target_index
检查 target owner 在 SystemMemoryContext topology 内
        │
        ▼
生成 RoutedAddress
```

## 7.1 本地直达优先

本地 GDG 和当前 issuer core 的 LDG backing 检查发生在 port decoder 之前。这保证 resident shm 中已经映射的普通硬件地址优先按本地内存处理。

这两个 early return 不经过 `allowed_spaces` 过滤；`allowed_spaces` 只传给后续 `PortAddressDecoder`。上层 tile helper 会再次验证 kind，例如 `read_l2_tile()` 发现结果不是 L2 会报错，但通用 `read()/write()` 调用者仍应传入与指令语义一致的地址。

## 7.2 Local aperture

如果地址没有直接命中 issuer backing，但符合 local aperture，decoder 返回 `remote=false`：

- local NPU0/NPU1 aperture 可以访问同 device 的 core0/core1 L2；
- local LDG0/LDG1 aperture选择同 device 的 core0/core1 LDG；
- local GDG0/GDG1 选择同 device 的 GDG block。

## 7.3 Remote port

如果地址落入 port window：

1. decoder 从地址得到 `port_id` 和 port 内部 local address；
2. topology 根据 `(issuer.die, port_id)` 得到 target device；
3. aperture 的 `target_index` 决定 target core 或 GDG index；
4. router 得到最终 owner 和 target address。

当前只支持单跳映射。router 不会在 target device 上继续查另一个 port，也不计算路由路径。

## 8. 地址转换示例

假设：

```text
D0.port0 → D1
```

## 8.1 D0C0 写 D1 的 GDG0

```text
raw_addr
= port0_base + GDG0_base + 0x20
= 0x80000000000 + 0x10F00000000 + 0x20
= 0x90F00000020
```

解析结果：

```text
kind              = GDG
owner.die         = 1
target_index      = 0
target_addr       = 0x10F00000020
remote            = true
```

最终访问 `SystemMemoryContext::gdg(1)`。

## 8.2 D0C0 写 D1C1 的 L2

```text
raw_addr
= port0_base + NPU1_L2_base + 0x40
= 0x80101000040
```

解析结果：

```text
kind              = L2
owner              = CoreId{1, 1}
target_index       = 1
target_addr        = 0x40
remote             = true
```

最终访问 `SystemMemoryContext::l2(CoreId{1,1})` 的 offset `0x40`。

## 8.3 D0C0 写 D1C1 的 LDG

```text
raw_addr
= port0_base + LDG1_base + 0x40
= 0x91000000040
```

解析结果：

```text
kind              = LDG
owner              = CoreId{1, 1}
target_base_addr   = 0x11000000000
target_addr        = 0x11000000040
remote             = true
```

最终访问 `SystemMemoryContext::ldg(CoreId{1,1})`。daemon resident 模式下通常是目标设备注册的 core1 WDRAM shared-memory backing。

## 9. 通用 byte 访问接口

## 9.1 `read()`

```cpp
std::vector<uint8_t> read(
    CoreId issuer,
    uint64_t raw_addr,
    uint64_t size_bytes,
    const std::vector<RemoteSpace>& allowed_spaces,
    tick_t executor_end_tick,
    GlobalEffectLog* log = nullptr,
    uint64_t event_id = 0) const;
```

步骤：

1. 加共享 memory lock；
2. 调用 `resolve()`；
3. 根据 kind 选择 `memory_.l2()/gdg()/ldg()`；
4. 从 `target_addr` 读取指定长度；
5. 可选追加 READ/SOURCE access log；
6. 返回 payload vector。

底层 backing 的容量/范围异常统一包装成：

```text
MemoryRouter CapacityUnsupported: ...
```

## 9.2 `write()`

有 raw pointer 和 `std::vector<uint8_t>` 两个重载。步骤与 read 对称：

1. 加锁；
2. resolve；
3. 选择目标 L2/GDG/LDG backing；
4. 同步写入；
5. 可选追加 WRITE/DESTINATION access log。

vector 重载只转调 pointer/size 重载。

## 10. 为什么有 L2 tile 专用接口

L2 不只是线性 byte array。LD/ST/SISO 的 BR/RR 描述符包含 tile shape、rolling buffer 等布局语义，直接按连续 bytes 访问可能与本地 L2 行为不一致。

因此 router 提供：

- `read_l2_tile()`
- `write_l2_tile()`

它们先用 `raw_addr` 解析 L2 owner，再复制 BR：

```cpp
BRRegister target_br = br;
target_br.md0.saddr = routed.target_addr;
```

之后对目标 `L2Buffer` 调用 `read_br_tile()/write_br_tile()`，保留与本地操作一致的 BR/RR tile layout 语义。

这两个接口只允许 `RemoteSpace::L2`；解析到其他 kind 会报：

```text
MemoryRouter: expected L2 route
```

## 11. Local L2 tile helper 与 SISO

另外两个接口：

- `read_local_l2_tile(owner, ...)`
- `write_local_l2_tile(owner, ...)`

不解释 port 地址，调用者直接提供明确的 owner。它们主要服务 SO/SI：

- SO 从自己的 local L2 读取 tile，再把 snapshot push 到 inter-core queue；
- SI 从 queue pop payload，再写入自己的 local L2。

即使 owner 是本核，这些 helper 仍统一使用 memory mutex 和可选 effect logging，使 daemon 多 worker 下的 L2 访问具有一致锁边界。

## 12. `validate_siso_l2_peer()`

SO/SI 指令同时携带：

- DID/CID：显式 peer；
- BR 中的 L2 地址描述。

router 用 `validate_siso_l2_peer(self, peer, raw_addr)` 检查两者没有矛盾。

有两种兼容路径：

### Peer-local L2 offset

```text
raw_addr < L2Buffer::TOTAL_SIZE
```

当前 compiler 可能直接在 descriptor 中放 peer-local L2 byte offset。这种情况下只验证 self/peer CoreId 都有效，然后接受地址。

### Physical aperture address

较大的地址必须经 `PortAddressDecoder` 解码为 L2，并且：

```text
decoded target device == peer.die
decoded target_index  == peer.core
```

否则报：

```text
MemoryRouter: SISO peer must decode to peer L2
```

这可避免 DID/CID 指向一个 peer、BR port 地址却指向另一个 peer。

## 13. `ddr_for()`、`l2_for()` 和显式锁

`ddr_for(routed)` 返回：

- GDG route → `memory_.gdg(owner.die)`；
- LDG route → `memory_.ldg(owner)`；
- L2 route → 抛异常。

`l2_for(routed)` 只接受 L2 route。

这两个接口只返回 backing 引用，不自动覆盖调用者后续整段复合操作的锁生命周期。

例如 `LWExecutor` 需要在目标 LDG 上执行多次 read/transform/write，做法是：

```cpp
auto routed = router.resolve(...);
auto lock = router.lock_memory();
DDRManager& ddr = router.ddr_for(routed);
// 在 lock 生命周期内完成复合操作
```

## 14. 并发模型和递归锁

`memory_mutex` 是可选 `std::recursive_mutex*`。

如果为空，`lock_memory()` 返回不持锁的 `unique_lock`；普通单线程 case launch 依赖系统调度器的顺序执行。

daemon 模式传入 `RemoteFabricService::memory_mutex()`。不同 device worker 可以并发运行，各自的 router 共享这把锁。

之所以必须是递归锁，是因为公开方法会嵌套：

```text
read()/write()/read_l2_tile()/write_l2_tile()
  → 先 lock_memory()
  → 再调用 resolve()
       → resolve() 再 lock_memory()
```

普通 `std::mutex` 在这里会造成同线程自锁。

锁覆盖的是 router 介导的实际内存解析和访问。若某段代码取得 backing 引用后绕过 router 直接操作，则必须像 `LWExecutor` 一样显式保持 `lock_memory()`，否则不受该锁保护。

## 15. Executor 接入点

`CoreInstanceRuntime::wire_remote_contexts()` 将同一个核级 router 注入：

| Executor | Router 用途 |
|---|---|
| LD | 判断源是 local/remote L2、GDG、LDG；读取数据 |
| ST | 判断目标是 local/remote L2、GDG、LDG；写入数据 |
| LW | 解析 LDG owner，并在锁内直接操作目标 weight DDR |
| SO | 校验 peer L2 地址；从本地 L2 读取 tile |
| SI | 校验 peer L2 地址；把 queue payload 写入本地 L2 |

PE、VP、DT 等只操作本核已有 L2/weight view，当前没有单独注入 port router。

## 15.1 LD

LD 先调用 `resolve()` 判断 source kind：

- remote/local aperture L2 → `read_l2_tile()`；
- GDG/LDG → `read()`；
- 最终把提取的 tile 写入本核 L2。

## 15.2 ST

ST 先读取本核 L2 tile，再解析 destination：

- L2 → `write_l2_tile()`；
- GDG/LDG → 对 NHWC stride 的每个 chunk 调用 `write()`。

## 15.3 LW

LW 保留 kcache/vcache weight transform 语义，但通过 router 解析 LDG owner。它使用 `ddr_for()` 获取目标 backing，并显式持有 memory lock 完成整个复合操作。

## 15.4 SO/SI

SO/SI 的 payload 本身通过 `InterCoreQueue` 传输，router 不负责 queue routing。router 的作用是：

- 验证 descriptor 地址确实匹配 DID/CID peer；
- 统一 local L2 tile 访问和锁边界。

## 16. 远端时延与 effect log

成功解码的 route 会取得：

```cpp
fabric_cost = cost_model.get_fabric_remote_memory_cost();
```

`RoutedAddress::visible_tick()` 定义为：

```text
remote == false:
    visible_tick = executor_end_tick

remote == true:
    visible_tick = executor_end_tick + fabric_cost
```

当调用者传入 `GlobalEffectLog*` 和 `event_id` 时，router 追加：

- 全局 resource owner；
- raw address；
- target address；
- size；
- READ/WRITE；
- SOURCE/DESTINATION role；
- remote 标记；
- visible tick。

但要准确理解：router 的 `read()/write()` 是同步访问，远端 write 会在函数执行时立即修改共享 backing。`fabric_cost` 当前用于 effect/依赖分析中的可见时间元数据，不是一个延迟队列，也不会让 backing 到 `visible_tick` 才发生变化。

生产运行中的 executor effect 还可通过 `DeferredMemoryOp → effect_log_bridge → classify_address()` 生成系统级访问记录；这条分析路径复用相同的 PortAddressDecoder/FabricTopology 规则，但不是直接调用 `MemoryRouter::append_access()`。

## 17. 错误语义

| 情况 | 结果 |
|---|---|
| `size_bytes == 0` | `invalid_argument` |
| issuer 不在 memory topology | `out_of_range` |
| 地址不属于允许的 aperture | `MemoryRouter: MISS` |
| remote 地址但没有 topology | `MemoryRouter: missing fabric topology` |
| topology 中 port 为 null | `MemoryRouter: disconnected port` |
| target device/core 超出 memory topology | `out_of_range` |
| backing 访问越界/容量不支持 | `MemoryRouter CapacityUnsupported: ...` |
| tile helper 解析到非 L2 | `MemoryRouter: expected L2 route` |
| `ddr_for()` 收到 L2 | `routed address is not DDR` |
| `l2_for()` 收到 GDG/LDG | `routed address is not L2` |
| SISO descriptor 与 peer 不一致 | `SISO peer must decode to peer L2` |

这些异常没有在 router 内转换成 simulator result，通常会沿 executor callback、scheduler、`SystemSimulator::run_launch()` 向上传播；daemon worker 在更外层把异常记录为 launch failed。

## 18. 设计收益

### 18.1 消除 executor-specific remote pointer bundle

LD/ST/LW 不再各自维护一套远端 device/core backing 指针和临时 remote map。owner 只由固定 address ABI 与 session topology 决定。

### 18.2 本地和远端使用同一资源模型

最终访问都落到 `SystemMemoryContext` 的 GDG/L2/LDG，因而 resident external backing 与 case-owned backing 使用同一个 router API。

### 18.3 地址、owner 和诊断信息一致

`RoutedAddress` 同时保留 raw/target 地址、owner、remote 和 fabric cost，使实际访问与依赖诊断可以使用同一套概念。

### 18.4 支持 daemon per-device worker

每个 device worker 可以保持独立、确定性的核级 scheduler，同时通过共享 memory context 和 mutex 观察跨设备 remote memory effect。

## 19. 当前边界与风险点

### 19.1 不是完整 NoC/fabric 时序模型

当前只有固定 remote memory cost 元数据，没有：

- 链路带宽；
- 拥塞；
- 仲裁；
- 包拆分；
- 多跳路径；
- 按 visible tick 延迟提交 backing。

### 19.2 Topology 是直接单跳映射

一个 port 直接得到 target device。不会检查物理链路对称性，也不会从 target device 继续转发。

### 19.3 Direct-local early return 不应用 `allowed_spaces`

本地 GDG/issuer LDG backing 命中优先于 decoder，并直接返回。调用者不能只依赖 `allowed_spaces` 拒绝这两类直接命中，需要结合指令自己的 kind 检查。

### 19.4 L2 tile aperture 边界只用首地址解析

`read_l2_tile()/write_l2_tile()` 调用 `resolve(raw_addr, 1, L2)`，port decoder 只验证首字节落在 aperture；完整 tile 是否越界由后续 `L2Buffer::read_br_tile()/write_br_tile()` 的布局和容量校验承担。

### 19.5 SISO peer-local offset 是兼容模式

小于 L2 总容量的 raw offset 直接接受，无法仅凭地址再次证明其属于 DID/CID 指定 peer；这里依赖指令显式 peer 字段和 queue wiring。

### 19.6 Address classification 有第二条实现路径

依赖日志的 `classify_address()` 与实际 `MemoryRouter::resolve()` 使用相同 decoder/topology 概念，但实现是分开的。未来调整 address precedence、aperture 或 owner 规则时，需要同步测试两条路径，避免实际访问与分析报告漂移。

### 19.7 LDG backing base 需要遵守 device-local ABI

Port decoder 的 LDG0/LDG1 是 target device-local core 0/1 aperture。resident daemon 注册的 external LDG backing按 local core base 建立。若其他调用者自行绑定 external LDG，必须保证 DDRManager block base 与 `target_addr/target_base_addr` 一致。

## 20. 测试覆盖

当前测试覆盖了：

- local L2/LDG/GDG aperture 解码；
- 四个 remote port window 解码；
- allowed space 和 aperture/window bounds；
- topology JSON 加载与校验；
- remote GDG 路由；
- remote L2 byte 访问；
- remote L2 BR/RR tile helper；
- remote LDG 与 external backing；
- disconnected port 异常；
- fabric cost 对 `visible_tick` 的影响；
- LW remote LDG destination。

代表性断言：executor end tick 为 20、remote fabric cost 为 1234 时，访问日志的：

```text
visible_tick == 1254
```

## 21. 一次远端 ST 写的完整调用链

```text
SystemSimulator::run_launch()
  → CoreInstanceRuntime::step()
    → TickScheduler::step()
      → ST ExecutorUnit 到达 COMMIT
        → MemoryMaterializer::materialize(ST)
          → STExecutor::execute()
            → STExecutor::exec_st_mov()
              → MemoryRouter::resolve()
                → PortAddressDecoder::lookup_address()
                → FabricTopology::target_device()
              → MemoryRouter::write()/write_l2_tile()
                → SystemMemoryContext 选择目标 backing
                → 同步写入目标 GDG/LDG/L2
                → 可选 append memory access
```

## 22. 阅读建议

理解 `MemoryRouter` 时建议按以下顺序阅读：

1. `memory_layout.h`：本地 GDG/LDG 基址；
2. `port_address_decoder.h/.cpp`：port window 和 aperture；
3. `fabric_topology.h/.cpp`：port→device；
4. `system_memory.h/.cpp`：owner→backing；
5. `memory_router.h/.cpp`：组合逻辑；
6. LD/ST/LW/SI/SO executor：指令如何使用 router；
7. system runtime tests：验证具体地址转换。

## 23. 关键源码索引

- `cpp/include/zeus3sim/runtime/memory_router.h:24-47`：`RoutedMemoryKind` 和 `RoutedAddress`
- `cpp/include/zeus3sim/runtime/memory_router.h:49-142`：router API
- `cpp/src/runtime/memory_router.cpp:8-21`：route 到 dependency resource
- `cpp/src/runtime/memory_router.cpp:23-34`：构造和可选递归锁
- `cpp/src/runtime/memory_router.cpp:36-109`：`resolve()`
- `cpp/src/runtime/memory_router.cpp:111-186`：通用 byte read/write
- `cpp/src/runtime/memory_router.cpp:188-245`：remote L2 tile read/write
- `cpp/src/runtime/memory_router.cpp:247-302`：local L2 tile helper
- `cpp/src/runtime/memory_router.cpp:304-336`：SISO peer 验证
- `cpp/src/runtime/memory_router.cpp:338-353`：backing accessor
- `cpp/src/runtime/memory_router.cpp:355-372`：access log
- `cpp/include/zeus3sim/memory/port_address_decoder.h:20-44`：port/aperture 常量和 hit
- `cpp/src/memory/port_address_decoder.cpp:48-84`：inner aperture 解码
- `cpp/src/memory/port_address_decoder.cpp:100-125`：port-window 解码
- `cpp/include/zeus3sim/runtime/fabric_topology.h:21-47`：topology 模型
- `cpp/src/runtime/fabric_topology.cpp:24-120`：topology 加载和校验
- `cpp/include/zeus3sim/runtime/system_memory.h:22-99`：系统内存 owner 模型
- `cpp/src/runtime/system_memory.cpp:38-122`：owned/external backing
- `cpp/src/runtime/system_simulator.cpp:248-253`：router 创建
- `cpp/src/runtime/core_instance.cpp:281-308`：router 注入 executor
- `cpp/src/executor/ld/ld_executor.cpp:71-119,177-207`：LD route/read
- `cpp/src/executor/st/st_executor.cpp:75-113,168-195`：ST route/write
- `cpp/src/executor/lw/lw_executor.cpp:329-353`：LW route/backing/lock
- `cpp/src/executor/so/so_executor.cpp:26-35,93-136`：SO peer 验证和 local L2 read
- `cpp/src/executor/si/si_executor.cpp:27-36,105-166`：SI peer 验证和 local L2 write
- `cpp/include/zeus3sim/runtime/remote_fabric_service.h:23-50`：daemon 共享 memory/mutex
- `cpp/src/runtime/effect_log_bridge.cpp:79-107`：依赖分析的 routed access classification
- `cpp/tests/test_remote_address.cpp:38-132`：ABI/topology 测试
- `cpp/tests/test_remote_address.cpp:169-202`：remote route/disconnected port 测试
- `cpp/tests/test_system_runtime.cpp:400-510`：shared backing、fabric cost、L2/LDG 测试

