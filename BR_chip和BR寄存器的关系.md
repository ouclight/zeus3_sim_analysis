`BRx` 和 `BRx_chip` 是两套同结构的 BR 寄存器镜像，初始化时都按同一个 `BR` 模板创建，见 [regfile.py (line 81)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/regs/regfile.py:81)。

核心区别可以理解为：

- `BRx`：仿真器执行主体使用的 BR 描述寄存器。
- `BRx_chip`：保存部分字段的“芯片原始写入值/未做仿真语义变换的值”，目前主要给 `CT_BMOVM` 读回。

**结构上相同**

两者每个 `BRn` 都包含：

```
MD_0        activation 描述
MD_1        weight 描述
MD          当前模式，0=activation, 1=weight
raw data    Source / Tile / Point Index / Addr&Mode 原始打包字段
key_list
```

定义位置：[regfile.py (line 81)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/regs/regfile.py:81)

**为什么需要两套**

在 `CT_SETBM-*` 写 BR 的很多尺寸字段时，`BRx` 会写入 `value + 1`，而 `BRx_chip` 写入原始 `value`。

例如 `CT_SETBM-A BRx[S] [SN,SH,SW,SC]`：

```
BRx['MD_0']['SN'] = _plus1(value)
BRx_chip['MD_0']['SN'] = value
```

见 [CT_excuter_class.py (line 449)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/CT_excuter_class.py:449)。

这说明：

- `BRx` 里的 `SN/SH/SW/SC/TN/...` 更像仿真计算直接使用的“实际尺寸”。
- `BRx_chip` 里的对应字段更像指令写入/硬件可读回的“编码值”。

所以如果指令写 `SN=3`，仿真器内部可能把 `BRx.MD_0.SN` 变成 `4`，但 `BRx_chip.MD_0.SN` 保留 `3`。

**谁使用 BRx**

绝大多数执行器读 `BRx`，例如：

- `LD/ST/DT/SI/SO/LW/PE/VP` 执行时读取 `BRx` 作为 src/dst block 描述。
- dispatcher latch BR 信息时也 deepcopy `BRx`。
- BR 合法性检查、reg config tracker 也主要看 `BRx`。

这意味着真实数据搬运/计算主要依赖 `BRx` 的仿真语义值。

**谁使用 BRx_chip**

目前明显使用 `BRx_chip` 的主要是 `CT_BMOVM`：

```
CT_BMOVM Rx BRa[Imme]
```

会根据 `BRa.MD` 从 `BRx_chip['BRa']['MD_0']` 或 `BRx_chip['BRa']['MD_1']` 读字段，见 [CT_excuter_class.py (line 314)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/CT_excuter_class.py:314)。

这符合“从 BR 中读回用户设置值”的语义：读回原始值，而不是仿真内部已经 `+1` 的尺寸值。

**同步关系并不完整**

它们不是自动同步的主从关系，而是由各条 CT_SETB 指令手动维护。

目前代码里：

- `CT_SETBM-A/W [S]`、`[T]`、`[PI]`、`CT_SETBS-A/W` 的很多字段会同时写 `BRx` 和 `BRx_chip`。
- `CT_SETBM-A/W [AM]`、`CT_SETBI-A/W` 主要只写 `BRx`，没有同步写 `BRx_chip`。
- `CT_SETB-A/W BRx BRy` 只 deepcopy `BRx`，没有同步复制 `BRx_chip`。

因此不能简单认为 `BRx_chip == BRx 的硬件镜像`。更准确地说：`BRx_chip` 是一个“部分维护的原始字段镜像”，当前主要服务于 `CT_BMOVM` 的字段读回。

还有一个值得注意的问题：`CT_BMOVM {Rx,Ry} BRa[Addr]` 当前代码读的是：

```
BRx_chip['BRa']['SAddr']
```

见 [CT_excuter_class.py (line 322)](/home/zhangds/Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/CT_excuter_class.py:322)。

但 BR 模板里没有顶层 `SAddr`，只有 `MD_0['SAddr']` 和 `MD_1['SAddr']`。所以这条路径看起来很可疑，可能会触发 `KeyError`，或者至少和 `CT_BMOVM Rx BRa[Imme]` 的按 MD 读法不一致。