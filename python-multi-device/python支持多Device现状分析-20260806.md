当前 Python 仿真器已经具备一些多设备基础能力，但分成了三套不同路径，不能等同于“已支持 topology 驱动的 daemon 多设备互连”。

| 路径                               | 当前能力                                         | 主要限制                                           |
| ---------------------------------- | ------------------------------------------------ | -------------------------------------------------- |
| case-folder / in-process           | 可一次创建多个 die/core，并进行跨 die 访存与同步 | 使用旧 `remote_address_map`/硬编码 D2D 路由        |
| 正式 Python daemon package         | 能加载 topology、注册多个 device                 | topology 尚未进入执行期访存                        |
| `main_torch_zeus.py` legacy daemon | 支持多连接、多 rank、namespace-only register     | 各设备上下文独立，launch 全局串行，无 port routing |

## 1. In-process 多 die/core 建模

`NPUSimulator` 可以根据：

```
{
  "core_map": {
    "die_number": 2,
    "cores_per_die": 2
  }
}
```

创建多个 die 和 core。

相关实现位于 [simulator.py (line 276)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/simulator.py:276)。

它会为每个 die/core 创建：

- 独立 `NPUCore`
- 每 die 的 GDG manager
- 每 core 的 weight/LDG manager
- 每 core 的 L2
- memory conflict tracker
- dependency recorder
- CT/SISO 状态

所以 Python 核心模型本身不是只能创建一台设备。

## 2. 旧式跨 die L2/GDG/LDG 访问

当前 in-process 路径已经能模拟：

- remote L2
- remote GDG
- remote LDG/weight
- local peer L2
- 跨 die memory owner 识别
- 容量检查
- descriptor/tile 读写

地址解析位于：

- [remote_address_decoder.py](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/memory/remote_address_decoder.py)
- [core.py (line 211)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/core.py:211)
- [fabric.py (line 82)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/distributed/fabric.py:82)

LD/ST 已统一通过 Fabric seam：

```
core.fabric.ld_read_tile(...)
core.fabric.st_write_tile(...)
```

这为以后替换成 topology router 提供了较好的接入点。

但这套能力依赖：

- `remote_address_map`
- `remote_l2_map`
- `default_remote_address_map()`
- 硬编码 `D2D_PREFIX[(source_die, target_die)]`

因此它表达的是：

```
地址 prefix 直接隐含目标 die
```

而不是新的：

```
地址选择 port
    → topology[source_device][port]
    → target device
```

## 3. 多核和部分跨 die 同步

当前单个 `NPUSimulator` 内支持：

- CT_SEND/CT_WAIT
- SI/SO MOV
- SI/SO SYN
- mailbox
- parallel/parallel-pc
- deterministic gate
- timeout/deadlock detection

Fabric 接口已经覆盖：

- `ct_send_signal()`
- `siso_si_mov()`
- `siso_so_mov()`
- `siso_si_syn()`
- `siso_so_syn()`

接口定义见 [fabric.py (line 35)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/distributed/fabric.py:35)。

不过当前 SI/SO 仍通过：

```
remote_core_index = DID * cores_per_die + CID
npu.cores[remote_core_index]
```

直接查找同一 `NPUSimulator` 中的目标 core。因此只能用于所有设备/core 同处一个 simulator instance 的旧模式，不能直接用于多个 daemon resident launch。

CT 当前也仍基于全局 `CORE_ID_MAP`，尚未完全切换到 C++ resident daemon 的“device-local CT bitmap”语义。

## 4. `topology.json` 加载和校验

Python 已经有完整的基础 topology loader：

[topology.py (line 16)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/port_fabric/topology.py:16)

目前支持：

- `address_abi == "zeus3-port-v1"`
- device id 从 0 连续
- 每个 device 固定两个 core
- 每个 device 四个 port
- port 为 `null` 或 `target_device`
- target device 范围校验
- 默认单 device、四 port 全断开
- `(source_device, port) -> target_device`

例如：

```
topology.target_device(0, 2)
```

可以返回 port2 连接的目标设备。

当前主要缺少 digest、linear core helper 和更严格的 boolean/未知字段校验。

## 5. 固定 port-window 地址解码

Python 已有独立的 `zeus3-port-v1` 地址解码器：

[address_decoder.py (line 30)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/port_fabric/address_decoder.py:30)

能够识别：

- port0：`0x800_0000_0000`
- port1：`0xA00_0000_0000`
- port2：`0xC00_0000_0000`
- port3：`0xE00_0000_0000`
- remote port 内的 L2/GDG/LDG aperture
- local L2/GDG/LDG aperture
- port id
- inner address
- target core/GDG index
- offset
- 跨窗口范围错误

它已经完成了：

```
raw address → port_id + inner address + memory space
```

但尚未完成：

```
port_id + source device
    → topology target device
    → target resident manager/L2
```

也就是说，目前有 decoder，没有执行期 router。

## 6. Python daemon 能加载 topology

正式 Python daemon 支持：

```
python -m npu_core_simulator.daemon \
  --socket tcp://127.0.0.1:9000 \
  --topology topology.json
```

入口见 [server.py (line 71)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/daemon/server.py:71)。

daemon 启动时会：

- 加载 topology
- 校验 topology
- 将 topology 注入 `DaemonSession`
- 在 register 时检查 device 是否属于 topology

注册校验见 [session.py (line 135)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/daemon/session.py:135)。

因此控制面已经知道 daemon 有多少设备。

## 7. 多 device resident registration

`DaemonSession` 可以保存：

```
_registrations: dict[int, RuntimeRegistration]
```

不同 device 可以分别注册：

```
{
  "cmd": "register",
  "device": 0,
  "shm_namespace": "device0_namespace"
}
{
  "cmd": "register",
  "device": 1,
  "shm_namespace": "device1_namespace"
}
```

它支持：

- device 范围检查
- namespace-only register
- GDG0/GDG1 shared memory
- 每 core WDRAM shared memory
- 重复注册替换
- shutdown 关闭 mapping

resident adapter 位于 [resident_memory.py](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/daemon/resident_memory.py)。

但每个 registration 仍是独立对象。一次 launch 只得到当前 device 的 registration，不能查询其他 device 的 memory context。

## 8. Runtime launch 和 active core placement

新提交已经支持：

```
{
  "device": 0,
  "entry_addrs": [1234],
  "core_ids": [1],
  "num_cores": 1
}
```

表示该 entry 在 core1 执行。

实现位于 [runtime_launch.py (line 65)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/daemon/runtime_launch.py:65)。

`NPUSimulator` 也已经支持 `active_cores`：

- 所有必要 core slot 可以被构造
- 只启动指定 core
- 只 join 指定 core
- 只检查 active core mailbox

见 [simulator.py (line 280)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/simulator.py:280)。

这对多设备实现很有帮助，因为以后可以准确表达：

```
device 1 的 core 1 是本次 active core
```

但当前只解决 device 内 core placement，尚未解决 physical device identity。runtime launch 仍明确限制：

```
die_number == 1
```

见 [runtime_launch.py (line 89)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/daemon/runtime_launch.py:89)。

## 9. Resident shared-memory ABI

Python 已能映射 runtime-owned：

- GDG0
- GDG1
- WDRAM core0
- WDRAM core1

并将它们包装成 `MemoryManager`，供 `NPUSimulator` 使用。

另外 `main_torch_zeus.py` 已支持 runtime 的 namespace-only register 约定，证明以下命名契约可用：

```
<namespace>_gdg0
<namespace>_gdg1
<namespace>_wdram_c0
<namespace>_wdram_c1
```

这为多设备 `ResidentFabricContext` 提供了可靠的 per-device storage 基础。

## 10. 实验性 distributed/WireFabric 基础

仓库还有实验性多进程能力：

- `Fabric` 抽象
- `InProcessFabric`
- `WireFabric`
- wire protocol
- local broker/transport
- core process
- memory server
- inbound server
- SISO/CT 消息

位于：

```
npu_core_simulator/distributed/
```

它表明跨进程访存和同步可以通过 Fabric seam 接入。

但它不是当前 daemon port-fabric 的实现，不能直接等同于 topology 多设备支持：

- 路由责任模型不同
- 生命周期不同
- resident shared memory contract 不同
- 尚未与 daemon session 集成
- 不应把 wire control/data protocol 与 daemon protocol混合

## 11. L2 契约能力

当前 Python 和 C++ 已经统一了一部分 L2 规则：

- BR 首地址 16-byte 对齐
- CT scalar 4-byte 对齐
- CT vector 16-byte 对齐
- RTL 丢弃低地址位时显式报错

实现位于 [l2_address_contract.py](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/memory/l2_address_contract.py)。

这对未来 remote L2 parity 很有价值，但目前尚无：

- session-addressable L2
- launch-start active-core reset
- remote L2 的 topology owner
- registration/launch 外的稳定 L2 owner
- 目标 core RR/descriptor 生命周期定义

## 当前实际能力边界

当前可以做到：

```
单个 NPUSimulator
  → 多 die、多 core
  → 旧映射驱动的跨 die L2/GDG/LDG
  → 同进程 CT/SISO
```

以及：

```
Python daemon
  → 加载 topology
  → 注册多个 device namespace
  → 每次执行一个单-device resident launch
```

当前不能做到：

```
device 0 runtime launch
  → 访问 port0 地址
  → 查询 topology
  → 定位 device 1
  → 读写 device 1 resident GDG/LDG/L2
```

核心缺口正是二者之间缺少：

```
ResidentFabricContext
+ RegistrationLease
+ FabricMemoryRouter
+ launch_device/physical DID
+ session L2
```

所以最准确的描述是：

> Python 仿真器已经具备多设备对象模型、旧式跨 die 地址访问、topology 控制面、固定 port 地址解码、resident memory 和 Fabric 接口，但还没有把这些组件连接成 topology 驱动的 daemon 多设备执行路径。