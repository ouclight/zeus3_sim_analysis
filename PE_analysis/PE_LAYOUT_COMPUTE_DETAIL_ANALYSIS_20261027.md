# normal 与 local V-cache 权重布局的计算细节对照：新布局为什么能提升 M1 效率

日期：2026-10-27。分析对象：`PE_ROOFLINE_ANALYSIS_20261022.md` 第 13/14/15 节的既有实测与静态 RTL。范围：Zeus518 稠密 BF16 M1 LM-head，`[1,4096] × [8448,4096]ᵀ`，BLOCK_N512，双核，400 MHz。约束：不修改 RTL、不新增 VCS 任务；本文是对已有证据的再分析，不替代主报告的证据归档。

## 0. 一句话结论

**新布局本身不提速，它把 normal 布局下"k1 才连续、k4 必然跨行"的绑定，改成了"k4 才连续"。k4 是隐藏 OL1 累加反馈所必需的；新布局让 k4 的 4 条独立累加链第一次可以在连续供数下运行。**

| 配置 | 完整 N512 稳态 | 相对 normal/k1 |
|---|---:|---:|
| normal / k1 | 1015 | 1.000× |
| normal / k2 | 4864 | 4.792× |
| normal / k4 | 4864 | 4.792× |
| local V-cache / k1 | 1051 | 1.035× |
| local V-cache / k2 | 897 | 0.884× |
| local V-cache / k4 | **861** | **0.848×** |

- 换布局但保持 k1（1051）比 normal/k1 慢 3.55%，说明**布局本身没有白送的收益**。
- 同一份 local 权重文件，只改 8 条完整块 PE 的 MTK 字段：1051 → 897 → 861，说明**新布局的收益来自与 MTK 的联合调整**。
- normal 布局下改同样的 MTK 字段：1015 → 4864 → 4864，说明**MTK 单独增加链数不仅无益，还会触发供数侧的大幅回退**。

## 1. 分析口径与证据分层

| 证据类型 | 本文中的内容 | 可以支持什么 | 不能支持什么 |
|---|---|---|---|
| VCS 实测稳态 | 1015／4864／1051／897／861 cycles | 同一配置下的完成间隔比较 | 内部 active/stall、MC 字节、FIFO/credit 状态 |
| 静态 RTL | 地址公式、MTK/MTC 计数次序、OL1 credit、FIFO 深度、MTW 重放 | 结构性机制与请求顺序 | 实际请求日志、实际等待占比 |
| 静态打包代码 | `prepare.py` 的 7D 物理排列、索引页 ABI | 元素级物理位置与抽象块序列 | 硬件内部实际取数时序 |
| 推断/假设 | 每块大跳变惩罚、MC 持续带宽、行局部性阈值 | 一致性与后续验证方向 | 已证实的瓶颈归因 |

稳态时间沿用主报告口径：同核相邻完整 N512 PE 指令的完成时间差；全局时间取 `trace_time_alignment.json → kernel.duration_cycles`。权重字节与 TFLOPS 仍按数学所需 4 MiB、4,194,304 FLOPs 折算，**不是硬件计数器测得的实际流量**。

## 2. 什么没变，什么变了

### 2.1 没有变的部分

先固定这些不变量，否则容易把收益归错地方：

- 数学矩阵、BF16 位模式、K4096 完整归约不变。
- 每个输出通道仍按 64 个 C 轮次（C64）从 k=0 到 k=4095 累加，OL1 的 FP32 累加次序不变。
- 每核仍是 2 LD、9 PE、18 VP、9 ST；完整块仍是 4 MiB 数学权重。
- PE 指令数、VP/ST 路径、输出 BF16 可见舍入路径不变。

因此 bit-exact 是预期结果：MTK 只改变**不同输出通道组之间的时间交错**，不改变任一输出自己的 K 归约次序。local 打包只改变元素位置，不改变数值或算术。

### 2.2 变了的四个层面

| 维度 | normal | local V-cache |
|---|---|---|
| 物理排列 | `[输出组33, C块64, 通道128, K内64]` | `[K0 32, K1 2, 输出组4, 组内8, K64, 通道16]` |
| 跨全核 16 KiB 块编号 | `block(og,c) = og×64 + c` | `block(og,c) = og + 4c` |
| 同 C 位置相邻输出组 | 相距 1 MiB（单 group 128 KiB） | 相距 16 KiB（单 group 2 KiB） |
| 寻址方式 | K-cache，WMode0，直接地址 | V-cache，WMode3，16 KiB 索引页 + 块内 K/C 交换 |
| WBS | raw9，真实 512 K | raw7，真实 128 K |
| 每核权重文件 | 33 MiB | 34 MiB（144 KiB 索引 + 对齐填充） |
| 完整块选型 | M1/M2 为 c32 | M1 为 c32；M4 为 c16 |

完整块物理排列来自 [prepare.py:19](artifacts/m1_local_vcache_20261027/prepare.py#L19)：

```python
original = np.frombuffer(src, dtype='<u2').reshape(33, 64, 128, 64) \
             .transpose(0, 2, 1, 3).reshape(4224, 4096)   # normal

packed = (matrix.T.copy()
          .reshape(32, 2, 64, 4, 8, 16)
          .transpose(0, 1, 3, 4, 2, 5).copy())            # local tile
```

local 的物理维度为 `[K0=32, K1=2, 输出组n0=4, 组内n1=8, K64, 通道n2=16]`：**同一 128 K 块内的 4 个输出组被放在相邻的 16 KiB 区域内**，而不是像 normal 那样各自占一整条 1 MiB 的 K 行。

## 3. 两种布局的请求流

### 3.1 normal 的块顺序

normal 按 `(输出组, C块)` 线性编号：

```text
block(og, c) = og × 64 + c        og∈[0,3]，c∈[0,63]
```

- k1：`0,1,2,3,...` —— 整个 4 MiB tile 完全顺序；
- k2：`0,64,1,65,2,66,...` —— 同一 C 位置交错 2 个输出组，每次跨 1 MiB；
- k4：`0,64,128,192,1,65,129,193,...` —— 同一 C 位置交错 4 个输出组，每次跨 1 MiB，回跳约 3 MiB。

### 3.2 local 的块顺序

local 按 `(输出组, 128 K块)` 交错编号：

```text
block(og, c) = og + 4c            og∈[0,3]，c∈[0,63]
```

- k1：`0,4,8,12,...` —— 单输出组先走，步长 4 个 16 KiB 块（64 KiB）；
- k2：`0,1,4,5,8,9,...` —— 两输出组相邻，再跳 3 个块；
- k4：`0,1,2,3,4,5,...` —— 四输出组恰好填满连续块，整个 tile 完全顺序。

### 3.3 跳变统计

以跨全核 16 KiB 逻辑块为统计单位（256 块/tile），对相邻块的绝对距离计数：

| 配置 | 前 8 个块 | 255 次转移中 >256 KiB 的次数 | 主要步长 |
|---|---|---:|---|
| normal/k1 | 0,1,2,3,4,5,6,7 | **0** | 16 KiB |
| normal/k2 | 0,64,1,65,2,66,3,67 | 254 | 1 MiB 级 |
| normal/k4 | 0,64,128,192,1,65,129,193 | 255 | 1 MiB～3 MiB 级 |
| local/k1 | 0,4,8,12,16,20,24,28 | 3（仅输出组边界） | 64 KiB |
| local/k2 | 0,1,4,5,8,9,12,13 | 1（仅输出组边界） | 16/48 KiB |
| local/k4 | 0,1,2,3,4,5,6,7 | **0** | 16 KiB |

**边界：**以上是静态地址公式推出的抽象次序，不是内部 MC/WL1 请求日志；16 KiB 逻辑块是"跨全部 8 个 group 的一个满算周期权重"的编号单位，单 group 对应 2 KiB 基本块。不能把 1 MiB 抽象跳变直接当成某一次 hub 传输。

## 4. RTL 关键细节：WSTMOD 交换了 MTK/MTC 的地址步长

主报告第 14.4 节已经指出：normal/K-cache 下 `cur_kc_rdaddr_1` 将 `mtk_cnt × 行跨度` 与 `mtc_cnt × 2 KiB` 相加，且 MTK 是内层计数。本文补充一个更直接的结构事实：**V-cache 模式下这两项的乘数互换了。**

归档 RTL 中：

```text
K-cache (WSTMOD=0):
  cur_kc_rdaddr_1 = base + MTK × row_span + MTC × 1 + tc/tk 项

V-cache (WSTMOD=1):
  cur_kc_rdaddr_2 = base + MTK × 1        + MTC × row_span + tc/tk 项
```

地址项以 2 KiB miniblock 为单位；`row_span = weight_wc_miniblock_num`。见 [wl1_518_weight_ctrl.v:468](artifacts/m1_mtk_sweep_20261027/rtl/wl1_518_weight_ctrl.v#L468)、[:470](artifacts/m1_mtk_sweep_20261027/rtl/wl1_518_weight_ctrl.v#L470)、[:1311](artifacts/m1_mtk_sweep_20261027/rtl/wl1_518_weight_ctrl.v#L1311)、[:1314](artifacts/m1_mtk_sweep_20261027/rtl/wl1_518_weight_ctrl.v#L1314)、[:1319](artifacts/m1_mtk_sweep_20261027/rtl/wl1_518_weight_ctrl.v#L1319)、模式选择 [:1335](artifacts/m1_mtk_sweep_20261027/rtl/wl1_518_weight_ctrl.v#L1335)。

MTK 是内层计数器（每次读握手递增，满了才轮到 MTC），见 [:579](artifacts/m1_mtk_sweep_20261027/rtl/wl1_518_weight_ctrl.v#L579)、[:594](artifacts/m1_mtk_sweep_20261027/rtl/wl1_518_weight_ctrl.v#L594)。由此：

- **normal/K-cache**：内层 MTK 每切一次输出组就跨一个完整 C 行；k>1 必然跨行。
- **local/V-cache**：内层 MTK 每次只走相邻地址；k>1 仍然连续。
- 代价是 V-cache 把行跨度放到外层 MTC 上，所以 **k1 反而变成跨行**。

这解释了为什么"换布局"和"改 MTK"不能分开看：**物理 pack 必须和 WSTMOD 选择的地址公式匹配**。normal pack 匹配 K-cache 公式，local pack 匹配 V-cache 公式；只改 MTK 不改 pack，等于让地址公式与物理排列错配，normal/k2、k4 的 4864 就是这种错配的表现。V-cache 的索引页/页大小语义见 [core.py:2228](../../triton_qmnpu/python/triton/language/core.py#L2228)、参考示例 [gemm_vcache_bf16xbf16_bf16dst_bf16acc_128x128x128_1core.py](../../triton_shared/python/zeus_examples/GEMM/gemm_vcache_bf16xbf16_bf16dst_bf16acc_128x128x128_1core.py)、索引表 ABI [index_put_kvcache_index.py:12](../../triton_shared/python/zeus_examples/GEMM/index_put_kvcache_index.py#L12)。

## 5. OL1 反馈与"独立链"

OL1 的依赖链在主报告第 13 节已推导：旧部分和读 → 三级 FP32 流水 → 写回 → 寄存 credit 增加 → 下一拍才可再次读。控制上 `scaling_data_rdy = sum_in_tmp_vld & pipe_rdy[0]`（[pe518_ol1_ctrl.v:79](references/code/rtl/zeus518/pegroup/pe518_ol1_ctrl.v#L79)）；credit 是寄存的、没有同周期旁路（[pe518_ol1_buffer_ctrl.v:239](references/code/rtl/zeus518/pegroup/pe518_ol1_buffer_ctrl.v#L239)、[:264](references/code/rtl/zeus518/pegroup/pe518_ol1_buffer_ctrl.v#L264)）。

把 M1/N512/K4096 归一化成"256 个 16 KiB 逻辑块"（每块正好是全核一个满算周期的权重）：

| 独立链 L | OL1 反馈允许的节奏 | 每块下界 |
|---:|---:|---:|
| 1 | 每 4 拍一次 | 4.0 cycles/块 |
| 2 | 每 2 拍一次 | 2.0 cycles/块 |
| 4 | 每拍一次 | 1.0 cycles/块 |

权重接口的条件下界是 **2.0 cycles/块**（8192 B/cycle）。因此：

```text
每块实际时间 ≥ max(4/L, 2.0)
```

- L=1 时由 OL1 反馈主导；
- L≥2 后 OL1 不再是瓶颈，供数/其它路径接管；
- L=4 相比 L=2 只把反馈下界从 2.0 降到 1.0；如果供数侧仍停在 3.5 cycles/块，多出来的两条链**几乎没有收益**——这正是 local/k2→k4 只再省 36 cycles 的原因。

**MTK 是"输出组交错数"**，是单行内增加 L 的软件旋钮；**MTW 是"多输入行重放"**，是另一条增加 L 的路径（M2/M4）。两者不要混为一谈。

## 6. 六组实测的统一解释

### 6.1 归一化表

| 配置 | 稳态 cycles | cycles/16 KiB 块 | 下界 max(4/L, 2) | 实测−下界 | 绑定侧 |
|---|---:|---:|---:|---:|---|
| normal/k1 | 1015 | 3.96 | 4.0 | −0.04 | OL1 反馈（首轮绕过） |
| normal/k2 | 4864 | 19.00 | 2.0 | +17.0 | 供数（跨行） |
| normal/k4 | 4864 | 19.00 | 2.0 | +17.0 | 供数（跨行） |
| local/k1 | 1051 | 4.11 | 4.0 | +0.11 | OL1 反馈 + 少量布局/索引开销 |
| local/k2 | 897 | 3.50 | 2.0 | +1.50 | 供数/其它 |
| local/k4 | 861 | 3.36 | 2.0 | +1.36 | 供数/其它 |

"cycles/16 KiB 块"是稳态时间除以 256 个逻辑块的归一化诊断量，**不是**每拍硬件计数器；"下界"来自 OL1 控制模型与 8192 B/cycle 接口条件，二者都不是实测持续带宽。

### 6.2 2×2 对照

| 稳态 cycles | normal | local V-cache |
|---|---:|---:|
| MTK1 | 1015 | 1051 |
| MTK2 | 4864 | 897 |
| MTK4 | 4864 | **861** |

这张 2×2 是全文最重要的对照：同一 MTK 在两个布局下效果相反，说明**布局与 MTK 是互补项，不是两个独立收益**。

### 6.3 逐项解释

1. **normal/k1（1015）**：请求流完全顺序（100% ≤16 KiB），L=1。1015 与 OL1 单链模型 `4×253+3=1015` 完全一致；这是"连续供数 + 反馈受限"的基线。
2. **normal/k2、k4（4864）**：L 已经 ≥2，但请求流约每块一次 1 MiB 级跳变（254/255 与 255/255）。实测 19 cycles/块，是接口条件 2.0 的 9.5 倍。两者精确相等，说明**链数不是这一档的主导变量**；与"每块一次大跳变"的统计一致。按 3.96 + P ≈ 19.0 估算 P≈15 cycles/次，但这只是与数据形态一致的假设，不能据此认定 DRAM row/bank 冲突或 MC 带宽饱和。
3. **local/k1（1051）**：L=1，反馈下界 4.0；实测 4.11，仅高出 0.11 cycles/块（约 28 cycles/tile）。这是 V-cache 索引页、WBS/描述符、64 KiB 步进等非 MTK 成本的量级。完整块 +36、N128 尾块 +45（256→301），两者一致指向"每 tile 约几十 cycles 的固定/半固定开销"。
4. **local/k2（897）**：L=2，反馈下界 2.0，实测 3.50；供数/其它成为绑定侧。请求流主要是 +16/+48 KiB，只有 1 次输出组边界的 ~4 MiB 跳变。
5. **local/k4（861）**：L=4，反馈下界 1.0，实测 3.36；请求流 100% ≤16 KiB，是六组中唯一"完全顺序 + 4 链"的组合。相对 normal/k1 的 1015 缩短 154 cycles（15.17%），但相对接口条件 512 仍有 349 cycles。
6. **local/k2→k4 只省 36 cycles（4.01%）**：L=2 已经足以把 4 拍反馈隐藏到 2.0 cycles/块，k4 多出的 2 条链不再提高下界；这 36 cycles 更像是 k2 的 48 KiB 间隔变成 k4 的完全连续所带来的供数局部性收益，而不是"链数翻倍"的收益。

### 6.4 861 距 512 的 349 cycles

512 是"8 group × 2 hub × 512 B/cycle 每拍完整返回"的**接口条件容量**，不是已测持续带宽，也未计入索引访问、重复物理读、AL1/输出等成本。861 对应的有效权重速率是：

```text
4,194,304 B / 861 cycles = 4871 B/cycle
4871 / 8192 = 59.5%
```

这只是"数学所需字节 ÷ 完成时间"的端到端有效比率，**不是端口 busy 率**。剩余 349 cycles 的可能来源（均未分离）：

- MC 对该访问模式的持续带宽低于接口峰值（若约 60%，861 已接近持续上限；但用 861 反推带宽再解释 861 会形成循环论证）；
- WL1 输出 FIFO 很浅：2048-bit×2/PE = 512 B/PE、4 KiB/group（[weight_data_format.v:1035](references/code/rtl/zeus518/wl1/wl1_518_weight_data_format.v#L1035)），只相当于全速 MAC 约 2 拍的权重，平滑不了大的返回抖动；
- hub 的 16 路 256-bit 响应用 AND 汇合，单路慢响应会拖住整个 4096-bit beat；
- AL1 激活供给、subtile 切换、索引/描述符、输出/VP/ST 的内部反压；
- 实际物理流量大于 4 MiB（重复读、索引页、对齐填充等）。

在取得内部计数前，不能把 349 直接标成"纯供数等待"，也不能二选一归因。

## 7. 与 M2/M4 的对照：两种"加链"不是一回事

| | M1/k1 normal | M2 normal | M4 normal c16 | local/k4 |
|---|---:|---:|---:|---:|
| 行数 | 1 | 2 | 4 | 1 |
| 独立链来源 | 无 | 2 个输入行 | 4 个输入行 | 4 个输出组 |
| 权重复用 | 无 | MTW FIFO 重放 | MTW FIFO 重放 | 无 |
| 稳态 cycles | 1015 | 1022 | 1177 | 861 |
| 每行摊销 | 1015 | 511 | 294 | 861 |

- M2/M4 的收益来自**同一份权重通过 MTW 重放服务多行**：`weight_fifo_rd_en` 只有在 `r_mtw_cnt` 达到 `internal_mtw_cnt_max` 后才 pop（[weight_data_format.v:1126](references/code/rtl/zeus518/wl1/wl1_518_weight_data_format.v#L1126)）。M2 的 1022 基本等于其 OL1 模型 1019，是"反馈受限但吞吐翻倍"的典型。
- local+MTK 的收益来自**同一行内交错多个输出组**，没有权重复用，是单行延迟优化。local/k4 的 861 不能与 M2 的"511 cycles/行"直接比较：前者是一行 861，后者是两行合计 1022。若业务有多行可合并，M2/M4 仍是吞吐主轴；local 布局是 M1 延迟路径。二者能否叠加（local 布局 + M2/M4）本轮没有 A/B，不能外推。
- M4 的 c16 与 M1 的 c32 是实际代码生成差异，不能把 M4 的 1177 全部归因于单一计算量或单一链数因素。

## 8. 证据边界：现在还不能下的结论

1. **请求流序列是静态地址公式的抽象次序，不是内部请求日志。** 不能把 1 MiB 跳变直接当成某一次 MC 事务，也不能把 19 cycles/块直接称为 DRAM 行激活时间。
2. **normal vs local 不是纯布局 A/B。** WMode、WBS、descriptor、索引页都变了。干净对照是 **local/k1/k2/k4**：同一物理文件、同一布局，仅 8 条完整块 PE 的 MTK 字段不同（§15.8）。normal/k1/k2/k4 同样是"同一 normal 文件、仅 MTK 字段不同"（§14.2）。
3. **k1 的 +36 cycles 可以作为非 MTK 开销的近似上界。** 它包含索引页、V-cache 寻址、WBS/描述符、64 KiB 步进等，量级只有几十 cycles；因此它不足以解释 normal/k2 与 local/k2 之间约 4000 cycles 的差距。后者应表述为 **MTK×物理顺序的交互项**，而不是"V-cache 索引开销"。
4. **normal/k2 与 k4 的 4864 相等只说明"链数不是这一档的主导变量"**，不能证明是 MC 带宽、FIFO 深度或 DRAM bank 冲突中的哪一个；需要内部计数或可隔离的反事实实验。
5. **N128 尾块是反证**：它只有 1 个输出组，k4 用不上，稳态 256→301（+45）；这与"新布局收益依赖多输出组交错"一致，也说明每 tile 的固定索引/描述符成本约几十 cycles。
6. 其他限制沿用主报告：每组只有一次运行；M4 的 c16 混杂；本地 RTL 未与封存 simv 逐文件对应；远端 functional 的三元素差异是经授权的诊断例外，最终 PASS 来自 RTL named output；本 fixture 的 bit-exact 不替代完整数值合同。

## 9. 可跟进的验证方向

### 9.1 内部计数（优先级最高）

在同一 local/k4 与 normal/k2 窗口内同步统计：

- MC 实际读字节、hub 每拍有效返回率；
- WL1 输出 FIFO 空/满拍数；
- `avlb_mtc_cnt` 不满足导致的 OL1 入口等待；
- MAC accept 与 AL1/WL1 valid 的比值；
- 每 group 的请求地址序列，验证 WSTMOD 交换步长的静态推断。

这能直接区分"持续 MC 只有 ~60%"、"FIFO 太浅"、"OL1 credit 抖动"、"AL1 激活等待"等假设。

### 9.2 受控实验

1. 固定 local 布局，做 k8/N1024 或 k3，看 861 是饱和还是继续下降；normal 侧做 k3/k8，看 4864 是平台还是随 k 变化，检验"每块一次大跳变"的饱和解释。
2. 若 ISA 允许，做一个"normal 寻址 + 16 KiB 输出组交错 pack"的对照，把**物理顺序**与**索引/V-cache 开销**分开；或固定 local 布局、强制 k1 走类似 k4 的遍历顺序，把**链数**与**请求顺序**分开。
3. 变 page_size/WBS（128/256/512）和索引页位置，测量 local/k1 固定开销来源；用非零分配基址验证索引重定位。
4. 若生产关心吞吐，另做 local 布局 + M2/M4 的同数据 A/B，不要用 M1 的 861 去推断 M4 的每行收益。
5. 所有新对照保持同 shape、同数学权重、同 golden、严格 bit-exact 门禁，并记录每组运行次数与方差。

### 9.3 文档层面

本文可作为主报告第 15 节的后续对照：建议在 `PE_ROOFLINE_ANALYSIS_20261022.md` 中新增一节"两种布局的请求顺序与 WSTMOD 步长交换"，只引用本文的表和 RTL 行号，不改变第 14/15 节的实测结论与证据边界。

## 10. 证据与复现入口

### 10.1 实测数据

- [normal/k1/k2/k4 分析](artifacts/m1_mtk_sweep_20261027/analysis.json)、[重算脚本](artifacts/m1_mtk_sweep_20261027/analyze.py)、[归档 SHA](artifacts/m1_mtk_sweep_20261027/evidence_manifest.json)。
- [local V-cache/k1/k2/k4 分析](artifacts/m1_local_vcache_20261027/analysis.json)、[重算脚本](artifacts/m1_local_vcache_20261027/analyze.py)、[打包脚本](artifacts/m1_local_vcache_20261027/prepare.py)、[打包审计](artifacts/m1_local_vcache_20261027/pack_audit.json)、[归档 SHA](artifacts/m1_local_vcache_20261027/evidence_manifest.json)。
- 主报告：[PE_ROOFLINE_ANALYSIS_20261022.md](PE_ROOFLINE_ANALYSIS_20261022.md) 第 13/14/15 节。

### 10.2 RTL 与编译器

- K/V-cache 地址与 MTK/MTC 计数：[wl1_518_weight_ctrl.v](artifacts/m1_mtk_sweep_20261027/rtl/wl1_518_weight_ctrl.v)。
- OL1 反馈与 credit：[pe518_ol1_ctrl.v](references/code/rtl/zeus518/pegroup/pe518_ol1_ctrl.v)、[pe518_ol1_buffer_ctrl.v](references/code/rtl/zeus518/pegroup/pe518_ol1_buffer_ctrl.v)。
- WL1 输出 FIFO 与 MTW 重放：[wl1_518_weight_data_format.v](references/code/rtl/zeus518/wl1/wl1_518_weight_data_format.v)。
- V-cache page_size 语义：[core.py](../../triton_qmnpu/python/triton/language/core.py#L2228)；参考示例：[gemm_vcache_bf16xbf16_bf16dst_bf16acc_128x128x128_1core.py](../../triton_shared/python/zeus_examples/GEMM/gemm_vcache_bf16xbf16_bf16dst_bf16acc_128x128x128_1core.py)；索引表 ABI：[index_put_kvcache_index.py](../../triton_shared/python/zeus_examples/GEMM/index_put_kvcache_index.py)。

本文只做既有证据的再分析，没有修改生产 kernel、编译器或 RTL，也没有发起新的 VCS 任务。


## 11. 后续MTC对照：c64几乎不改变861-cycle稳态

已完成任务`b51c58b73ced`（local/N512/w1/c64/k4）VCS与原golden逐字节PASS。相对c32基线，双核七个完整块完成间隔均由861变860，首块953→952，尾块301不变；全局8219→8211，仅减少8 cycles（0.0973%）。版本、MC模式、时钟及trace完整性核对一致，raw trace与Polarsight起止点一致。

这次仅改变8条完整块的MTC字段，使C-minitile数2→1。它没有显著消除原来距512的差距，不支持“少一次C分块交接就能节省数百周期”的预期；但也不能将1-cycle净差值视为单独测出的边界开销，或反向证明剩余时间全来自内存。完整拆分与证据见[主报告18.1](PE_ROOFLINE_ANALYSIS_20261022.md#181-c64任务完成稳态861860未形成明显收益)及[结构化数据](artifacts/m1_local_vcache_mtc_20261027/analysis.json)。本节只分析既有任务，未新增提交。

## 12. MTC三点对照完成：863 / 861 / 860，下一步转向N1024局部布局

c16任务`ee1432e769f7` DONE且VCS与原golden逐字节PASS，完整块稳态863、首块955、尾块301、全局8235 cycles。与c32的861/8219、c64的860/8211对照，在相同局部权重、k4和尾块配置下，双核均恰好满足`T_steady=859+N_TC`，N_TC分别4/2/1。该式只是三个受控测量点的经验关系，859不是已证明的权重供数时间或可达下界。

MTC从16到64仅净省3个稳态周期，说明该配置范围内继续调MTC难以获得明显收益，不能将距512的差距归给C分块次数。c16没有Polarsight，使用其独立raw trace解码；身份、MC模式、时钟、地址及trace完整性核查通过。完整证据见[主报告18.2与18.3](PE_ROOFLINE_ANALYSIS_20261022.md)和[三组结构化结果](artifacts/m1_local_vcache_mtc_20261027/analysis.json)。

下一步优先验证重新打包的N1024 tile-local V-cache与w1/c32/k8，完整K4096及原输出数值路径不变。P由4改8、索引与values一起重建，每核4个完整块加N128尾块。单条N1024要与两条当前N512的1720 cycles比较，条件权重下界也相应为1024 cycles；不能仍要求单条N1024达到512。k8旨在匹配P8连续遍历与摊薄交接，不保证增加链数必然提速。本轮只分析完成任务，没有新增提交。


## 13. 后续五候选的trace VCS回执

| 候选 | 完整块配置 | Functional ID | Trace VCS ID |
|---|---|---|---|
| A | N1024/k8/c32/page128 | `97f938489f69` | `e4f67e52e260` |
| B | N1024/k4/c32/page128 | `b6e86d79835e` | `774bd91700ac` |
| C | N512/k4/c32/page256 | `82f3368f95be` | `8baea411f552` |
| D | N512/k4/c32/page512 | `7b7836029717` | `da8a092f2aee` |
| E | N512/k8/c32/page128 | `eb3dbb76973a` | `a11fe1901880` |

本地数值全部逐字节通过；远端functional仅复现历史相同3元素差异，按授权继续，最终VCS数值及性能待核查。全部trace64 MiB、6小时超时。布局/索引受控差异与完整回执见[主报告第19节](PE_ROOFLINE_ANALYSIS_20261022.md)及[任务目录说明](/DATA210/Application/liumx/TMPDIR/torch_zeus_vcs/lm_head_m1_local_vcache_five_candidates_20261027_r1/README.md)。

## 14. 五候选完成：宽局部布局+k8小幅获益，其余无收益

五组均DONE、VCS与原golden逐字节一致。原始双核trace重算如下：

| 候选 | 完整块稳态cycles | 每512输出等效cycles | 全局cycles |
|---|---:|---:|---:|
| 原N512/k4/c32/page128 | 861 | 861 | 8219 |
| 原N512/k4/c64/page128 | 860 | 860 | 8211 |
| **A：N1024/k8/c32/page128** | **1673** | **836.5** | **8021** |
| B：N1024/k4/c32/page128 | 1753 | 876.5 | 8341 |
| C：N512/k4/c32/page256 | 861 | 861 | 8219 |
| D：N512/k4/c32/page512 | 861 | 861 | 8219 |
| E：N512/k8/c32/page128 | 861 | 861 | 8219 |

A/B共用相同P8局部权重，仅4条完整块MTK不同，k8使其全局8341→8021；宽tile本身没有保证收益。A较原最快c64全局缩短2.314%，按相同输出量稳态缩短2.733%，成为当前固定案例最快已验证候选。其PE跨度7085，相比c32的7281减少196，外部before/after净省2，总计节省198 cycles。

C/D的索引按page_size重建、values排列实际相同，仅8条WBS字段变化；C/D/E双核全部PE起止与原c32一致。增大page_size没有获得收益；N512名义MTK8也没有获得额外有效输出或节拍改善。后者与N512只有4个128输出组一致，但未采集内部裁剪状态，不将命令时序当成内部信号证明。

A按每512输出的836.5仍明显高于512-cycle条件参考，不能认定剩余差距全是内存等待。当前保留A为后续优化基线，生产化仍需索引重定位与数值/shape回归。本节没有新增任务或修改生产实现。

完整版本、地址、trace完整性、时序拆分及比较边界见[主报告19.1～19.5](PE_ROOFLINE_ANALYSIS_20261022.md)。[结构化结果](artifacts/m1_local_vcache_five_candidates_20261027/analysis.json)及[对照图](artifacts/m1_local_vcache_five_candidates_20261027/five_candidates_cycles.svg)已归档。

## 15. 当前A的实际工作shape与MAC/OL1负荷

当前最快固定测试为`[1,4096] × [8448,4096]ᵀ`，双核各4224输出；每核4条N1024加1条N128尾块。完整PE是`[1,4096] × [1024,4096]ᵀ`，w1/c32/k8、page128、KC：两个C2048 minitile覆盖完整归约，每块8 MiB权重，结果4 KiB。不是完整模型词表N248320的本轮测量。

8个group分担输出、组内8个PE分担归约，每PE16个ALU，每ALU8个BF16乘法lane，共8192 lane。对当前k8，每ALU有8个不同输出的本PE局部部分和；每输出由该PE处理512个归约元素，64轮×8乘法，最后由组内8个PE归约成完整输出。每ALU总计8×64=512个有效片段输入，其中8个首轮不依赖旧和，504个后续输入依赖旧和。

RTL在minitile内W先推进、再K、再C；w1/k8提供8个输出轮转。局部理想4拍OL1反馈在无其它反压时可被8链覆盖，因此不能直接用原k1单链每4拍更新解释当前1673。但只有参数和静态顺序，并没有证明实际无气泡运行。

```text
A：LD → L2 → AL1归约分片 ─────────┐
                                 ├→ MAC八乘积 → 加法树 → OL1读旧和/累加/写回
W：局部V-cache索引 → MC → WL1 ───┘                      ↓
                                      组内8PE归约 → VP原数值路径 → ST
```

| 比较口径 | 当前N1024块 |
|---|---:|
| 有效工作量 | 4194304 MAC / 8388608 FLOPs |
| 纯算术满拍下界 | 512 cycles |
| 条件权重接口下界 | 1024 cycles |
| 实测稳态 | 1673 cycles |
| 有效工作折算算术容量比 | 30.60% |
| 相对条件权重接口容量 | 61.21% |

达到1024也不意味着MAC/OL1每拍满算：满阵列一份输入需要16 KiB权重，条件接口每拍只能给8 KiB，M1不跨输入行复用权重时平均只能支撑两拍一份满阵列输入。每ALU的OL1有效片段输入密度按实际时间折算约0.306个/拍，理想供数下约0.5个/拍；都不是逐拍busy计数。当前等效每个满阵列有效计算拍约3.268 cycles，仍比条件供数参考的2大。

结论是**空间shape与槽位足够，实际有效时间吞吐偏低；不能确认OL1持续满载，也未定位649周期差距的来源**。需在MAC valid/ready和OL1输入valid、旧和valid、pipeline ready及切换ready之间区分缺输入和反压，不能仅看PE命令耗时。详细shape、Mermaid流程、有效工作计数及RTL门控见[主报告第20节](PE_ROOFLINE_ANALYSIS_20261022.md)和[工作量记录](artifacts/m1_local_vcache_A_work_accounting_20261027/accounting.json)。本节没有新增仿真或生产修改。

## 16. 2026-10-28：无wave、无RTL修改的持续吞吐定位计划

目标不是预设“WL1只有六成带宽”，而是核查条件容量下界，并区分物理地址敏感性、固定成本、随K增长的持续成本。N512比较512 cycles，N1024比较1024 cycles；均不是已证明可达到的完整指令周期。

| 顺序 | 工作 | 控制条件与判定 |
|---|---|---|
| 1 | 只读核查GDG可持续带宽 | 核查MC命令间隔、bank/row映射、CDC、真实时钟、在途窗口、汇合缓冲。区分RTL默认值与封存simv实际配置，不能由接口位宽直接断言持续吞吐 |
| 2 | N512/k4/c32地址相位对照 | 复用逐位PASS固定案例的同一zbin、输入、golden、布局、两核数和trace设置；只移动values物理位置并重定位索引。先确认实际MC地址位变化，再检查本地逐位结果和远端放置 |
| 3 | 完整K扫描 | M1/N512/k4、相同布局规则，K1024/2048/4096；容量允许再8192。每组完整点积独立golden，不用split-K合并。核查编译后配置，排除自动改MTK/MTC造成混杂 |
| 4 | 必要时单核/双核对照 | 固定被测核代码、地址、数据；仅让另一核空闲或运行。用于检验跨核共享，不预设它是瓶颈 |

分析采用T≈固定成本+字节数/有效持续吞吐的趋势模型；截距不能直接命名为索引耗时，斜率不能直接命名为纯GDG时间。地址变化导致节拍变化支持地址相关限制；相同则只排除所测地址相位，不能排除全部bank冲突。

已有page128/256/512、MTC16/32/64和N512/N1024对照不重复盲扫。每阶段保留原始证据、哈希、独立目录和停止条件；本地数值失败不得提交性能测试，远端functional异常不得冒充PASS。远端VCS沿用trace64 MiB、6小时超时。计划分阶段执行，未取得job ID或完成结果不得标成已执行。

执行记录见[持续吞吐排查日志](PE_SUSTAINED_THROUGHPUT_INVESTIGATION_20261028.md)。


### 16.1 本轮推进回执

已完成GDG/CDC/限流静态核查；地址相位三组本地逐位PASS，原值K前缀保留数值差异证据，精确小数K1024/2048/4096诊断本地和远端functional全部逐位PASS。六组trace VCS均已提交并核查RUNNING：

| 案例 | VCS job ID | 最近核查状态 |
|---|---|---|
| P0 | `d0b613524783` | RUNNING |
| P1 | `e7cdd41933fd` | RUNNING |
| P64 | `4f53c0f671d5` | RUNNING |
| K1024 | `3a604eca2224` | RUNNING |
| K2048 | `4215bd539428` | RUNNING |
| K4096 | `92514e33df47` | RUNNING |

地址组三个functional仍标记失败，仅因复现全文哈希完全相同的历史3元素差异，按用户本轮明确授权继续；未放宽原VCS数值阈值。全部VCS为64 MiB trace、6小时超时，当前尚无性能结果。具体输入性质、Simulator路径、静态发现及结果判定规则集中于[排查日志](PE_SUSTAINED_THROUGHPUT_INVESTIGATION_20261028.md)。


### 2026-10-28已完成任务更新

最新五组DONE、P0原位重跑仍RUNNING。五组VCS均原定golden逐位PASS。P64右移1 MiB仍861 cycles，精确小数K4096的双核全部PE时序与历史原始数据一致；K2048为454，K1024原始trace暂定251，P1右移16 KiB暂定870。P1/K1024缺少服务端完整会话证据，不作为已封存时序结论。

证据完整的K2048/4096两点得到经验T≈47+203.5×权重MiB，支持主要剩余成本随工作量增长，而非主要由一次性启动造成；不能把斜率当成纯MC耗时或证明15笔窗口触发。完整判定、固定开销边界和图见[已完成持续吞吐结果](PE_SUSTAINED_THROUGHPUT_RESULTS_20261028.md)。本轮没有新增任务或代码优化。


### P0/P1原位重复性补充（2026-10-28）

六组VCS现全部DONE。P0原位重跑逐位PASS，稳态861、全局8219，双核全部PE起止与历史c32及P64一致，trace会话已封存且clean。P1刷新后仍只有raw 870的暂定时序，数值PASS但会话DestroySession证据缺口未修复。16 KiB移址改变MC列相位/128-word边界覆盖，提供小幅地址敏感性的线索，尚非bank冲突实测；起址调整未找到收益，也不足以解释主要349-cycle差距。详见[结果第6节](PE_SUSTAINED_THROUGHPUT_RESULTS_20261028.md)。


## local/k4逐组请求时序的静态推导

已按当前packed文件和RTL枚举256个C64×N128工作片段及512次双Hubvalues请求，不使用仿真或wave，也不以861拟合延迟。每轮顺序G0～G3，各16 KiB；理想请求占用0/1、2/3、4/5、6/7拍，下一C轮G0为8/9拍。读取可领先MAC，四组无需在首组开始前全部到齐；固定返回延迟在窗口足够时只平移流水，不自动造成持续缺供。

c32仅在内部C32边界显式空1拍，请求跨度513拍；c16/c64分别515/512，与既有稳态863/860相对于c32的差值一致，但不是对完整861周期的拆解。MC返回/消费延迟与15笔门控、AL1/OL1切换条件仍需闭合。详细公式、每个ALU需要的W[n,k]、地址样本验证和完整CSV见[逐组静态时序推导](PE_LOCAL_K4_STATIC_REQUEST_TIMELINE_20261028.md)。
