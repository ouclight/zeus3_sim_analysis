# M1局部V-cache持续吞吐排查（2026-10-28）

## 当前执行状态

计划已写入，静态核查和本地验证已完成本轮可做部分。六组trace VCS均已取得job ID；最新六组全部DONE。六组数值全部逐位PASS，四组有完整时序会话证据，P1/K1024的周期暂定。详见[已完成结果分析](PE_SUSTAINED_THROUGHPUT_RESULTS_20261028.md)。

| 案例 | VCS job ID | 最近核查状态 |
|---|---|---|
| P0 | `d0b613524783` | DONE |
| P1 | `e7cdd41933fd` | DONE |
| P64 | `4f53c0f671d5` | DONE |
| K1024 | `3a604eca2224` | DONE |
| K2048 | `4215bd539428` | DONE |
| K4096 | `92514e33df47` | DONE |

地址三组：本地原golden逐位PASS；远端functional仅历史相同3元素差异，全文哈希一致且基址正确，按用户本轮明确例外授权继续，原VCS golden/阈值不变。K扫描三组：精确小数合成诊断，本地及远端functional全部逐位PASS；独立CPU参考、正确权重基址均核验。

最初自动审批拒绝上传的问题已由用户明确授权解除；当前没有待审批项。已分析五组：P64保持861，P1暂定870，K1024/2048/4096为251（暂定）/454/861；经验关系约47+203.5×权重MiB，指向随工作量持续增长的成本。尚未定位具体模块，P0已复现861及历史完整双核PE时序，P1刷新后仍缺会话证据。

[完整回执与Simulator路径](artifacts/m1_sustained_throughput_20261028/vcs_handoff.json)、[解释规则](artifacts/m1_sustained_throughput_20261028/analysis_contract.json)。

## 范围与基线

不修改RTL，不依赖wave。固定回归样本为local/N512/k4/c32/page128，M1/K4096/总N8448，双核各4224输出，原VCS `cf3ce68d7307`，稳态861 cycles。采用其已有zbin及原输入/golden，不声称重新捕获生产运行。当前最佳A为N1024/k8、1673 cycles，另作规模对照。

分阶段计划与判定标准见[布局分析第16节](PE_LAYOUT_COMPUTE_DETAIL_ANALYSIS_20261027.md)。

## 阶段1：GDG静态核查

已确认如下源码机制；均为当前本地RTL，不是封存simv配置读回：

- 每Hub返回4096 bit，双Hub组合8192 bit；每组2 KiB权重基本块需要两份双Hub返回。8组给出每核8 KiB/PE周期的条件接口容量。
- WL1的每Hub请求缓冲配置在途额度32、返回缓冲深度4；继续向下不能只沿用“32笔”评估整个链。
- `gdg_flowctrl.v`的读在途计数达到15就令`flow_ctrl_halt`为真，该计数从AXI侧接收请求到返回FIFO在AXI侧被消费：`rdata_buffer_received = rdata_buffer_rvalid && rdata_buffer_rready`，并非MC刚返回就释放额度。因此下游不消费也会占住这15笔额度。**这是链上另一处可能收紧有效窗口的限流机制，不证明当前触发。** 稳态满足带宽延迟积，平均未返回请求数≈请求速率×请求至返回被消费的延迟；不能把该15直接乘任意延迟推成实际周期。
- `gdg_axi2frame.v`使用深度16的异步frame FIFO连接AXI/MC时钟域，满或flow halt都会停止接收。源码注释的500/800 MHz不是本任务实测时钟，不用于带宽计算。
- GDG地址转换受`splicing_mode`影响。模式0：col=MC地址[6:0]、bank=bit7、row=[20:8]；模式1包含加0x1A000及重映射。该寄存器本地复位默认1，不能假设任务实际采用模式0。
- tRC/tRCD/tRP等来自可写寄存器；本地复位值不能替代VCS启动配置。
- 当前目录只找到`mc_top_aux`，未找到其依赖的`mc_frame2frame_aux`、`mc_frame_arbiter_aux`、`vmc_top_aux`等完整模块定义。MC内部真实发命令间隔和行命中策略尚无法从现有文件完整闭合。

结论：512 cycles继续保留为**条件接口下界**，不是已证明的GDG持续吞吐。新发现的15笔窗口、CDC以及运行时splicing模式应纳入后续证据核查，暂不归因为主瓶颈。

## 阶段2：地址相位对照设计

选择三组：P0原位、P1 values整体右移16 KiB、P64整体右移1 MiB。索引区及PE指令不动，所有tile的索引页号统一加1或64，values顺序逐字节保持。P0同样重跑用于控制运行环境漂移。

按此前双Hub装载映射，16 KiB物理镜像步长对应每个逻辑MC地址增加2个32 B字；1 MiB对应增加128个字。该关系只用于保证测试覆盖不同MC地址相位；bank解释仍取决于实际splicing配置。固定对齐无法覆盖所有列位或所有bank情形。

先完成索引目标区间、values一致性、zbin/输入/golden哈希审计，再进行Zeus3FunctionalSimulator init.json本地回放和提交前检查。远端functional验证通过后才进入trace VCS；不自动扩大历史functional异常的特定候选授权。

## 阶段3和4

完整K扫描的本地执行记录见后文；单核/双核对照尚未执行。避免把不受控的归约和编译配置变化混入结果。

## 阶段2本地验证与上传审批历史（当前状态见文首）

| 案例 | values偏移 | 本地逐位结果 | 远端 |
|---|---:|---|---|
| P0 | 0 | PASS，33792/33792 B | VCS已提交，见文首 |
| P1 | 16 KiB | PASS，33792/33792 B | VCS已提交，见文首 |
| P64 | 1 MiB | PASS，33792/33792 B | VCS已提交，见文首 |

全部zbin、source、输入、golden哈希相同，索引重定位与values一致性审计通过；三组Pre Built预检查通过。[结构化本地结果](artifacts/m1_sustained_throughput_20261028/local_address_phase_results.json)、[RTL快照与哈希](artifacts/m1_sustained_throughput_20261028/rtl_manifest.json)已归档。

独立任务目录：`/DATA210/Application/liumx/TMPDIR/torch_zeus_vcs/lm_head_m1_address_phase_20261028_r1`。`P0_init`、`P1_init`、`P64_init`包含Zeus3FunctionalSimulator完整init.json回放；`P0`、`P1`、`P64`包含canonical Pre Built。

本地最初因sandbox禁止Unix socket而启动失败，允许本地socket后全部通过，不是计算数值错误。远端P0 functional上传被自动审批拒绝，理由是尚未明确授权这些具体输入/权重payload到Relay；当时向用户请求授权，未改通道绕过；用户随后明确授权，现已有job ID。functional失败仍如实保留，不改写为PASS。

## 阶段3：原始数值前缀的本地探路

K1024/K2048使用原始输入和逻辑权重前缀，各自完整点积；本地编译后8条完整块的MTK=4/MTC=32/WBS=128未变，仍9条PE。不是split-K。原K4096的golden不能直接用于新K，故独立生成CPU FP32累加→BF16→FP32参考，同时用FP64检查舍入敏感性。

| K | 与CPU FP32参考不同元素 | 最大绝对差 | CPU FP32与FP64在BF16可见结果的差异元素数 |
|---|---:|---:|---:|
| 1024 | 1/8448 | 0.001953125 | 0 |
| 2048 | 5/8448 | 0.001953125 | 6 |

两组没有通过严格数值门控，未提交性能任务；不以本地模拟器输出替换golden、不放宽阈值。K2048存在参考归约舍入敏感性，也不能将全部差异直接判成编译器错误。目录：`/DATA210/Application/liumx/TMPDIR/torch_zeus_vcs/lm_head_m1_k_scan_20261028_r1`，保留CPU参考、反汇编与逐项差异。

为继续隔离吞吐而不混入舍入歧义，另行准备明确标注为合成诊断的exact-dyadic数据：非零±1/16至±8/16；每项乘积为1/256的整数倍，K≤4096所有可能的部分和均能精确表示于FP32。K1024/2048/4096统一使用这种数值规则和相同归档布局/源码，先验证CPU FP32/FP64完全一致再回放。该组只能诊断硬件路径趋势，不能当作原生产输入的性能或数值结论。


### 精确数值诊断本地结果

K1024/K2048/K4096三组全部与独立CPU参考逐字节一致（每组33792 B），CPU FP32与FP64中间结果完全相同。反汇编均9条PE，完整块保持w1/c32/k4/page128。目录：`/DATA210/Application/liumx/TMPDIR/torch_zeus_vcs/lm_head_m1_k_scan_exact_dyadic_20261028_r1`，各`K*_init`可直接回放。[结构化结果](artifacts/m1_sustained_throughput_20261028/local_exact_dyadic_results.json)。本地functional没有硬件周期意义，未从其运行时间拟合GDG吞吐。

K1024/2048分别覆盖一个C-minitile（K1024的有效C轮数少于c32），K4096覆盖两个；拟合时须保留这个结构变化，不能只对三个总耗时机械线性回归。该组三个远端上传和测试随后另获用户明确授权，远端functional全部逐位PASS，VCS已提交，见文首。

### 地址任务上传授权更新

用户随后明确回复“授权上传并测试”，原上传阻塞已解除。三组functional已提交：P0=`49a671951afc`，P1=`e5f0a0d5e840`，P64=`33f12d06e195`。数值确认仅历史相同3元素差异、全文输出哈希一致，权重相对基址均0；用户另行授权此严格例外后，已提交VCS，见文首。


## 后续分析入口与停止条件

1. 远端VCS完成后先核对原named output、post-pass checks、实际MC模式、时钟、trace完整性及simv/RTL/mapping/build身份。任一不匹配先停止跨组周期比较。
2. 地址对照采用本轮P0作参考，分别列双核完整PE完成间隔、首块、尾块、PE外部开销及全局对齐周期。padding上传字节不计入计算权重量。
3. 精确K扫描先比较K4096与原数据P0；若数据值改变节拍，先研究数据敏感路径，不能直接外推K趋势。若一致，再列K1024/2048/4096稳态和相邻差分；显式标注C-minitile从1变2的混杂。
4. 命令trace不能唯一划分MC缺供、激活缺供和后级反压。本轮结果若仍不能区分，应给出排除范围和剩余假设，不把拟合项冒充内部等待计数。


### P0/P1后续核查

P0已DONE，逐位PASS、完整会话证据clean，稳态861、全局8219，双核全部PE起止与历史原位及P64一致。P1刷新远端文件后仍为数值PASS、raw稳态870，exact DestroySession证据缺失未修复。静态投影显示16 KiB移址把MC列相位0改成2，涉及更多128-word区间，是地址敏感性的线索，不证明bank冲突。详见[结果第6节](PE_SUSTAINED_THROUGHPUT_RESULTS_20261028.md)。未新增任务。


## 后续消费侧/MTW排查更新

同编译器B=`b06c42294eae`、D=`e74ceaf68752`均DONE、VCS逐位PASS，稳态均861。D未形成运行时隔离，因此不用于排除VP/ST干扰。MTW五组合法配置已本地逐位PASS，暂未远端提交；M4/w4/c32超容量，保留统一c16及c32对照。详细核验见[消费侧与MTW排查记录](PE_CONSUMER_AND_MTW_INVESTIGATION_20261028.md)。

## 因果诊断执行：有效隔离、地址工作集、真实RTL计数

已按用户指示执行，完整记录见[PE_CAUSAL_DIAGNOSTICS_EXECUTION_20261028.md](PE_CAUSAL_DIAGNOSTICS_EXECUTION_20261028.md)。

- C/I：通过16处配对mail位修改，让首VP只接收最后PE的唯一完成通知；数学和数据不变。两组本地逐位PASS、preflight PASS。C/I远端functional均严格逐位PASS：C=`1353ea86055d`，I=`87208a660b03`。已提交64 MiB trace、6小时VCS：C=`d4d53df3f4be`（查询时RUNNING），I=`648b2dc564b1`（查询时QUEUED）。两组均为既有zbin的Pre Built，无Relay编译器toolchain。运行时隔离尚待trace验收；地址组VCS继续按门控等待。
- Spread/Alias：同一隔离binary、同逻辑权重/input/golden/payload，仅索引不同；完整块每MC地址工作集512→16 word，尾块不变。本地及远端functional逐位PASS：Spread=`1a762b7e3269`、Alias=`c671b38e2303`。用户已明确授权该批上传；VCS按门控等待隔离trace通过。
- RTL testbench：未修改设计RTL，Verilator运行真实GDG返回FIFO/15笔计数、每MC返回缓冲、16路汇合、双Hub缓存、WL1整理及8PE分发。8组计数完成；理想边界请求跨度513拍，增大返回延迟能触发15笔限流且无返回反压，慢路和消费者停顿产生不同计数特征。地址16-word循环仍各MC512笔读。MC时序和PE消费者是声明的边界模型，不是生产861复现。


## 跟进：从权重和激活准备到MAC、OL1的逐拍说明（2026-10-28）

详见[M1 local/k4逐拍数据流说明](PE_M1_LOCAL_K4_CYCLE_DATAFLOW_20261028.md)。新增面向初学者的64 PE分工、MC/双Hub/WL1传输量、PEC至AL1的激活拆分与广播、理想请求/接受时序，以及MAC至OL1的E0～E9局部流水表。区分4 MiB工作量、8 KiB/拍条件返回容量、16 KiB/次全阵列操作数、局部7拍写回延迟和实测861稳态；没有将条件时序写成实测内部波形。


## C/I完成后的有效隔离结论（2026-10-28）

C=`d4d53df3f4be`、I=`648b2dc564b1`均DONE且命名输出严格逐位PASS。I两核7个完整N512稳态窗口内均无任一核VP/ST执行；稳态仍全部861，C/I每核9条PE全部start/end完全相同。因此VP/ST并发不是本案例861稳态的限制因素。全局从8239变9919，是延后后处理失去重叠的代价，非PE变慢。地址工作集隔离门控已PASS。详见[C/I隔离结果与证据](PE_CAUSAL_ISOLATION_RESULTS_20261028.md)。


### Spread/Alias trace VCS已提交（2026-10-28）

隔离gate PASS，两组既有functional严格逐位PASS、preflight PASS，提交前bundle哈希未变。Spread=`b2924754e9a3`、Alias=`fa19a2e0f6bc`，提交后查询均RUNNING；均为双核Pre Built既有I binary，MC模式请求、trace 64 MiB、超时21600秒（6小时），无Relay toolchain。任务目录：`/DATA210/Application/liumx/TMPDIR/torch_zeus_vcs/lm_head_m1_workingset_20261028_r1`。使用合成重复页诊断数据，不是新采集的生产权重。回执见[workingset_vcs_handoff.json](artifacts/causal_isolation_results_20261028/workingset_vcs_handoff.json)。


## Spread/Alias完成结果（2026-10-28）

Spread=`b2924754e9a3`、Alias=`fa19a2e0f6bc`均DONE、VCS命名输出33792 B逐位PASS。两核7个完整块间隔均为Spread 861、Alias 836，每块减少25拍；全局9919→9719。两组完整块窗口均无任一核VP/ST重叠、六项硬件身份相同。索引是唯一权重文件差异，工作集缩小32倍不代表实际传输量减少32倍。该对照证明地址工作集/序列对性能有贡献，尚不能唯一归因MC换行、缓存或窗口；仍有324拍相对条件512下界的差距。详见[地址工作集结果分析](PE_WORKINGSET_RESULTS_20261028.md)。


## 供数减量与计算比例对照已提交（2026-10-28）

已准备并本地/远端functional逐位验证五组。N512、c16/k4的M1/M2/M4 VCS分别为`9a3f509d08d9`、`2b9ce78819b0`、`49edd52fbb9e`；N128/c32/k1的连续页/四地址命中对照为`68599fa3807d`、`50bc1dd8d226`。提交后均RUNNING，64 MiB trace、6小时。真实RTL返回链TB在N128边界下保持64份相同PE片段，MC读取128→4；这是本地模型计数，非远端VCS计数。详见[五组测试及回放方案](PE_SUPPLY_COMPUTE_CONTROLS_20261028.md)。


## 供数/计算五组任务的完成结果（2026-10-28，四组完成）

ComputeM1 `9a3f509d08d9`查询时仍RUNNING，未标为数值失败；另外四组VCS均逐位PASS、trace sealed。M2 N512稳态863，M4稳态1075，M4相对1024拍算术容量折算95.26%；N128连续/命中对照均292，全部PE时间戳相同。N128有单链反馈限制，且远端MC请求数不可观测，不能用无收益排除N512的供数限制。Cache core0最后一个窗口有另一核VP重叠，已从隔离统计剔除，剩余窗口仍292。详见[供数与计算比例结果](PE_SUPPLY_COMPUTE_RESULTS_20261028.md)。
