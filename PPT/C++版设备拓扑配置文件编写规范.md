# C++版设备拓扑配置文件编写规范

> Topology文件只描述“每个Device的4个远端Port分别连接到哪个Device”，不描述内存大小、基地址、路由算法或单次Launch参数。

## 1. 基本文件结构

```json
{
  "version": 1,
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

## 2. 顶层字段规范

| 字段 | 必需 | 取值 | 说明 |
|---|---:|---|---|
| `version` | 否 | 建议为`1` | 当前加载器不使用该字段进行版本判断，但建议保留以便配置管理 |
| `address_abi` | 是 | `zeus3-port-v1` | 必须与仿真器Port地址ABI一致 |
| `devices` | 是 | JSON数组 | 至少包含一个Device，且按Device ID顺序声明 |

错误示例：

```json
{
  "address_abi": "other-abi",
  "devices": []
}
```

会分别触发：

```text
topology address_abi must be zeus3-port-v1
fabric topology must contain at least one device
```

## 3. Device字段规范

每个Device必须包含：

```json
{
  "id": 0,
  "cores": 2,
  "ports": {
    "0": null,
    "1": null,
    "2": null,
    "3": null
  }
}
```

| 字段 | 必需 | 规则 | 说明 |
|---|---:|---|---|
| `id` | 是 | 从`0`开始连续递增 | Device ID同时用于Resident数组和Fabric路由索引 |
| `cores` | 是 | 当前必须为`2` | 每个Fabric Device固定建模两个Core |
| `ports` | 是 | JSON对象 | 必须完整声明4个Port |

Device必须按以下顺序放入数组：

```text
devices[0].id = 0
devices[1].id = 1
devices[2].id = 2
……
devices[N].id = N
```

不允许：

```text
ID从1开始
ID不连续
数组顺序与ID不一致
cores不是2
```

## 4. Port字段规范

每个Device必须声明全部4个Port：

```json
"ports": {
  "0": null,
  "1": null,
  "2": null,
  "3": null
}
```

每个Port只能使用两种值。

### 未连接

```json
"0": null
```

表示该Port没有连接远端Device。指令访问该Port Window时，Memory Router会按MISS或路由失败处理。

### 连接目标Device

```json
"0": {
  "target_device": 3
}
```

表示当前Device的Port 0直接连接到Device 3。

`target_device`必须：

- 是整数；
- 指向`devices`数组中已声明的Device；
- 不能超出`0～device_count-1`。

## 5. Port Window地址ABI

Topology决定“Port连接到谁”，指令地址决定“使用哪个Port”。

| 地址类型 | 地址范围 | 计算方式 |
|---|---|---|
| Local | 不加Port Base | 当前Device本地地址 |
| Port 0 | `[0x80000000000, 0xA0000000000)` | `0x80000000000 + 目标本地地址` |
| Port 1 | `[0xA0000000000, 0xC0000000000)` | `0xA0000000000 + 目标本地地址` |
| Port 2 | `[0xC0000000000, 0xE0000000000)` | `0xC0000000000 + 目标本地地址` |
| Port 3 | `[0xE0000000000, 0x100000000000)` | `0xE0000000000 + 目标本地地址` |

示例：

```text
Device 0 Port 0 → Device 1
目标本地地址     = 0x00100002000

指令中的远端地址
  = 0x80000000000 + 0x00100002000
  = 通过Device 0的Port 0访问Device 1的目标地址
```

## 6. 本地目标地址空间

Port Window内部携带的是目标Device的本地地址。

| 本地空间 | Base | 说明 |
|---|---|---|
| NPU0 L2 | `0x00100000000` | 目标Device Core 0的L2 |
| NPU1 L2 | `0x00101000000` | 目标Device Core 1的L2 |
| LDG0/WDRAM0 | `0x10000000000` | 目标Device Core 0权重空间 |
| GDG0 | `0x10F00000000` | 目标Device GDG0 |
| LDG1/WDRAM1 | `0x11000000000` | 目标Device Core 1权重空间 |
| GDG1 | `0x11F00000000` | 目标Device GDG1 |

Topology不重复声明这些Base和Size，它们由`zeus3-port-v1`地址ABI统一定义。

## 7. 连接方向规范

当前配置描述的是有向端口映射：

```json
Device 0 Port 0 → Device 1
```

不会自动生成：

```text
Device 1 → Device 0
```

如果需要双向互访，必须在两个Device中分别配置：

```json
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
```

工程上建议：

- 物理链路为双向时，配置也保持双向；
- 在评审时检查每条`A → B`是否存在预期的`B → A`；
- 明确Port编号与编译器地址编码的对应关系。

当前加载器不强制连接必须双向。

## 8. 直接连接与多跳边界

Topology中的一条Port映射表示直接连接：

```text
Device A Port N → Device B
```

当前Memory Router根据源Device和Port直接选择一个目标Device，不会自动搜索：

```text
A → B → C
```

因此，如果Device A需要直接通过某个Port访问Device C，该Port必须显式指向C。Topology不是通用图路由协议，也不自动执行最短路径计算。

## 9. 单Device示例

```json
{
  "version": 1,
  "address_abi": "zeus3-port-v1",
  "devices": [
    {
      "id": 0,
      "cores": 2,
      "ports": {
        "0": null,
        "1": null,
        "2": null,
        "3": null
      }
    }
  ]
}
```

说明：

- 只有Device 0；
- Device 0包含两个Core；
- 所有远端Port断开；
- 只能执行本地存储访问。

## 10. 双Device互联示例

```json
{
  "version": 1,
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

连接关系：

```text
Device 0 Port 0 ─────► Device 1
Device 1 Port 0 ─────► Device 0
```

## 11. 常见错误

| 配置错误 | 结果 |
|---|---|
| `address_abi`不是`zeus3-port-v1` | Topology加载失败 |
| `devices`为空或不是数组 | Topology加载失败 |
| Device ID不连续 | Topology加载失败 |
| Device数组顺序与ID不一致 | Topology加载失败 |
| `cores`不等于2 | Topology加载失败 |
| 缺少任意Port 0～3 | Topology加载失败 |
| Port值不是`null`或目标对象 | Topology加载失败 |
| `target_device`不是整数 | Topology加载失败 |
| 目标Device不存在 | Topology加载失败 |
| 只配置A→B但预期双向访问 | B→A访问失败 |
| 指令Port Window与配置Port不一致 | 访问被路由到错误Device |

## 12. 推荐检查清单

```text
□ address_abi是否为zeus3-port-v1
□ Device ID是否从0开始连续
□ devices数组是否按照ID排序
□ 每个Device的cores是否为2
□ 每个Device是否声明全部4个Port
□ 未连接Port是否显式写成null
□ target_device是否真实存在
□ 双向链路是否配置了两个方向
□ Port编号是否与编译器远端地址一致
□ 是否误以为Topology支持自动多跳路由
```

## 13. 使用方式

Daemon启动时指定：

```bash
cpp/build/zeus3sim \
  --daemon \
  --socket /tmp/zeus3sim.sock \
  --topology <topology.json>
```

One-shot使用：

```bash
cpp/build/zeus3sim_oneshot \
  -c <case_folder> \
  --topology <topology.json>
```

如果不指定Topology，仿真器使用内置单Device默认配置，Device 0的4个远端Port全部断开。

## 14. 功能边界

- Topology只描述Port到Device的连接关系；
- 不描述L2、GDG和WDRAM基地址，地址由固定ABI定义；
- 不描述链路Latency、带宽、仲裁和拥塞；
- 不提供自动多跳路由；
- 不在单次Launch中动态修改；
- 不决定激活哪些Core，活动Core由Launch的`entry_addrs`和`num_cores`确定。

## 15. 一句话总结

> 编写Topology时，需要为每个连续编号的Device固定声明2个Core和4个Port，并将每个Port配置为`null`或一个直接目标Device；指令通过Port Window选择端口，Topology再决定该访问路由到哪个Device。
