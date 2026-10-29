# PE隔离、地址工作集与返回链计数实验执行记录

## 1. 当前进度

本轮不修改设计RTL、生产kernel或编译器。VCS使用固定数据的诊断二进制，testbench在本地用真实RTL进行计数，不生成wave，不使用FPGA硬件。

| 阶段 | 当前完成项 | 尚未完成项 |
|---|---|---|
| C/I有效隔离 | 本地/远端functional及VCS逐位PASS；运行时隔离PASS；两核稳态均861，PE全部时间戳相同 | VP/ST并发已排除为本例稳态限制；继续地址工作集对照 |
| Spread/Alias地址工作集 | functional/VCS均逐位PASS；同核/跨核完整块隔离PASS；Spread 861、Alias 836 | 小工作集有25拍/块净收益；实际MC请求数与具体归因尚未观测 |
| 返回链RTL计数 | 真实返回FIFO/额度计数、MC返回路由、Hub汇合/缓存、WL1整理及8PE分发已编译并运行8组；无wave | 不是完整MC/PE算术实现，不能据此认定生产861的内部归因 |

地址组functional：Spread=`1a762b7e3269`；Alias=`c671b38e2303`。两组实际命名输出33792 B均与各自独立CPU golden逐字节一致。用户随后明确回复“授权可以继续提交？”，C/I具体上传阻塞已解除，授权另存于任务目录upload_authorization.json。

## 2. 有效隔离的实现与验收

目录：`/DATA210/Application/liumx/TMPDIR/torch_zeus_vcs/lm_head_m1_causal_isolation_20261028_r1`。

沿用旧D的9份独立PE结果缓冲，不依靠源码顺序作同步。C保留原D的所有指令位；I只清除前8条PE的VP发送位和后续8处VP的PE接收位。最后PE仍向VP发送，首VP仍等待PE，因此这个唯一通知必须来自最后PE。ST仍等待原VP链，不能在首VP之前执行。

数学字段、指令数量、代码地址/分支、输入/权重、golden完全相同。没有插入指令或修改生产源码。mailbox当前RTL MW=6，8笔PE→ST未消费通知在计数范围内；仍须VCS检查最终mailbox为零。采用现有精确小数诊断避免历史functional的3元素差异，本轮没有申请或使用数值例外。

静态审计和本地回放不能代替运行时验证。分析脚本要求：

```text
两组输出逐位PASS、post-pass检查通过
版本一致、MC模式、400MHz、trace sealed且funnel/writer clean
I的两核 first_VP_start >= last_PE_end
I的两核 first_ST_start >= last_PE_end
I的两核7个完整块间隔均无VP/ST重叠
```

只有满足上述条件，写出的`isolation_gate.json`才是PASS。稳态周期由完整块完成间隔得到，不以meta.actual_cycles替代；global取物理alignment。observer draft/metric_eligible=false继续如实保留。

## 3. 地址工作集对照具体改变什么

目录：`/DATA210/Application/liumx/TMPDIR/torch_zeus_vcs/lm_head_m1_workingset_20261028_r1`。

每核8个完整N512块，各有32个K128页；一页128 KiB。两份权重镜像均保留全部页副本、同样34 MiB文件大小及完全相同payload。

| 项目 | Spread | Alias |
|---|---|---|
| 逻辑K4096权重 | 同一K128内容重复32次 | 完全相同 |
| 物理数据 | 32份页副本 | 同样32份副本，文件payload未删 |
| 有效索引 | 依次指向32个不同副本 | 32项都指向首副本 |
| 完整块每MC地址工作集 | 512 word | 16 word |
| 尾块 | 原始精确小数数据及索引 | 完全相同，不做别名 |
| kernel/golden | 相同 | 相同 |

每页含完整的四输出组，所以不改变G0/G1/G2/G3之间的权重语义。所有逻辑页解引用后逐字节核对，CPU FP32与FP64点积一致，最终按原BF16-visible输出方式建立golden。两组不是原生产值，只用于存储工作集诊断。

16-word重复周期超过4槽地址缓存，不能把Alias称作“必然减少32倍请求”。后续真实VCS若变快，说明地址局部性相关机制有贡献；若不变，只否定这次工作集收缩的收益。未测动态MC请求数时，不宣称传输量降低。

## 4. 无wave的真实RTL返回链testbench

目录：[artifacts/rtl_return_chain_20261028](artifacts/rtl_return_chain_20261028)。入口[run.py](artifacts/rtl_return_chain_20261028/run.py)，[结果JSON](artifacts/rtl_return_chain_20261028/results.json)，[源码哈希](artifacts/rtl_return_chain_20261028/source_manifest.json)。

范围为一个硬件group：双Hub×16MC，各MC512次values请求，形成256份2 KiB/group片段并送8个PE输入。请求源按已核查的连续地址与c32边界插入1拍气泡；不包括初始索引获取、跨指令交接、MAC算术和最终OL1输出。因此不是完整861的复现。

直接编译未修改的真实设计模块：`gdg_flowctrl`、`gdg_rdata_buffer`及其async FIFO、每MC的`hub_mc_req_ctrl`返回缓冲/仲裁、16路汇合、Hub返回pipe、`weight_rd_ctrl`及4槽读缓存、`weight_data_format`及8PE分发。没有用手写Python替代这些模块。

边界模型明确保留：请求CDC/MC引擎用可调延迟和服务间隔的队列代替；PE用可控ready消费者代替；各时钟目前同频同相。使用Verilator 4.028；`-DFPGA`仅选择common RTL中不依赖工艺单元库的行为级复位/CDC双触发器分支，不涉及FPGA硬件。当前本地源码尚未证明与冻结simv完全相同。

先尝试Icarus 10.3，现有named-block/组合过程遇到兼容问题和零时间调度；改用Verilator而未修改设计RTL。构建命令、日志和边界参数回显均保存。每例检查32个MC的accepted=returned=released=512、地址与返回顺序、无额度上下溢/返回FIFO溢出、8PE各接收256份片段。参数必须在日志回显，避免仿真器优化空plusarg分支导致所有配置实际使用默认值。

### 已运行的对照

| 条件（均为TB人为边界） | 请求跨度 | PE输入片段跨度 | 首请求至末片段 | 整理反压拍数 |
|---|---:|---:|---:|---:|
| 返回延迟参数4，服务II=1，消费者常ready | 513 | 512 | 527 | 0 |
| 延迟参数14 | 611 | 613 | 638 | 0 |
| 延迟参数23 | 908 | 919 | 953 | 0 |
| 延迟参数40 | 1469 | 1497 | 1548 | 0 |
| 延迟4，服务II=2 | 999 | 1021 | 1037 | 0 |
| 仅一个MC额外延迟30 | 1271 | 1293 | 1338 | 0 |
| 消费者每16拍关闭12拍 | 1301 | 1361 | 1376 | 839 |
| 地址工作集16 word，其余同理想条件 | 513 | 512 | 527 | 0 |

“PE输入片段跨度”仅为接收第1份到第256份的区间，不能与完整PE命令稳态861直接当成同一测量。

原始额度计数提供了机制区分：理想条件额度生命周期7拍、在途最大7，不限流；延迟参数14/23/40的实际TB额度生命周期分别17/26/43拍，在途达到15且停发，但`rvalid&&!rready`为0，属于窗口覆盖不足而非消费者不收。单慢路出现其它MC的返回阻塞；消费者关闭时，整理、Hub及GDG返回出现反压。23仍是人为扫描点，不能拿其953与生产首PE953数字相同作因果推断。

这些结果验证真实返回链在理想边界下具备每两拍一片段的能力，并证明计数能够区分窗口限制与返回反压；**没有证明生产861具体属于哪一种**。

新增alias16例在相同真实4槽读缓存中，32个MC仍各接收/返回/释放512笔请求，与spread式连续地址相同；它独立验证了当前full-tile 16-word循环没有在该理想边界中减少物理读请求。真实MC的bank/row服务差异仍未建模，所以不能用该例的相同527拍预测远端Spread/Alias一定相同。

## 5. 后续执行门控

1. C/I具体上传已获授权，`run_remote.py`严格functional通过再发trace VCS。
2. 两组VCS完成后，分别执行`check_job.py --variant C/I --mode vcs`下载，再运行`analyze.py`验收真实隔离。
3. 地址组已有functional PASS；只有隔离gate通过，`submit_vcs_after_isolation.py`才允许提交地址VCS。脚本同时检查functional后的bundle哈希未变。
4. 根据有效隔离的稳态差值与地址工作集差值，再决定是否需要补齐MC配置或采集内部计数。testbench的敏感性结果不替代这些任务结果。

## 6. C/I上传授权解除后的提交回执

C/I远端functional均严格逐位PASS：C=`1353ea86055d`，I=`87208a660b03`。已提交64 MiB trace、6小时VCS：C=`d4d53df3f4be`（已DONE、逐位PASS），I=`648b2dc564b1`（已DONE、逐位PASS）。两组均为既有zbin的Pre Built，无Relay编译器toolchain。运行时隔离现已验收PASS；地址组VCS隔离前置条件已满足。

I首次上传遇到RESOURCE_EXHAUSTED并发上传限额，未取得Job ID；已查询本人最近100条任务确认无同名I任务，保留失败日志后仅重试I，未重复提交C。重试后functional严格通过，才提交I VCS。


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
