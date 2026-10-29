# PE供数减量与计算比例对照：五组用例及VCS提交（2026-10-28）

用户授权：构造测试并提交带trace VCS。独立合成诊断，不是新生产pytest捕获；不修改设计RTL或生产kernel。

## 五组矩阵

| 用例 | M/N/K（全算子） | 每条PE完整块 | MTW/MTC/MTK | 控制变量 |
|---|---|---|---|---|
| ComputeM1 | 1/8448/4096 | N512 | 1/16/4 | 计算比例基线 |
| ComputeM2 | 2/8448/4096 | N512 | 2/16/4 | 同权重、2行输入 |
| ComputeM4 | 4/8448/4096 | N512 | 4/16/4 | 同权重、4行输入 |
| CacheSpread | 1/2048/4096 | N128 | 1/32/1 | 每K128页访问不同物理副本 |
| CacheHit | 1/2048/4096 | N128 | 1/32/1 | 32项都引用同一K128页 |

所有用例为双核、local V-cache/page128。Compute每核8条N512+1条N128尾块；Cache每核8条N128，无尾块。计算对照三组统一c16，避免M4/c32的AL1容量非法；MTW×MTC<=64、MTW×MTK<=16。

Cache两组在同一对内计算、操作数、binary、输入、golden一致，只改索引；权重payload及大小不变。重复页为合成条件，不能对正常模型强行alias。N128/page128每条Hub地址循环4个word，可落入已核查的4槽读缓冲；N512/page128的16-word循环不能直接替代。

## 本地验证与隔离

prepare.py从已保存D源码模板生成新的source.py，固定N/K，修正M>1输出行stride为N；保留独立PE结果缓冲。编译并逐条审计PE_SETM_M后，按反汇编位置移除前面PE的VP发送位及后续VP的PE接收位，保留末PE→首VP的唯一同步；math字段不变。最终binary的mail位补丁记录于instruction_audit.json；source.py是补丁前源码，unpatched.zbin保留。

五组Zeus3FunctionalSimulator均逐位PASS。Cache独立CPU FP64/FP32点积精确一致，再按原BF16-visible路径构造FP32 golden。Compute使用已验证exact-dyadic golden逐行重复，输入行也精确重复。每组有独立_init目录、init.json、output.bin和replay.log。

只有本地PASS、preflight通过、文件哈希不变、远端functional逐位PASS、远端权重相对基址0验证通过，run_remote.py才会提交VCS。每组均64 MiB trace、21600秒超时；Pre Built已有binary，不使用Relay编译toolchain。完成后仍需raw trace验收同核及跨核完整块VP/ST隔离，不因mail静态审计而提前声称运行时隔离成立。

## 返回链testbench

入口tb/run_n128.py。使用真实未改动返回链RTL：N128/K4096、w1/c32/k1的请求/格式整理，128个逻辑请求、64份PE片段，一个硬件group。边界MC数据人为每4个word重复，使不同地址组与命中组的PE payload完全相同。每PE前两个phase保存后逐次校验，8 PE的payload摘要在四个对照中一致。

| MC边界（人为设定） | 不同地址/每MC请求 | 命中组/每MC请求 | 首请求至末片段，不同/命中 |
|---|---:|---:|---:|
| LAT=4、II=1 | 128 | 4 | 143 / 142 |
| LAT=23、II=1 | 128 | 4 | 258 / 161 |

没有MAC算术，PE为常ready消费者；没有初始索引与完整指令生命周期，不是远端周期预测。LAT=23不是实际MC延迟。testbench确认了真实4槽读缓冲存在复用能力，且该序列让MC读取减少；冻结simv上是否同样命中及减少多少请求，须保留版本与可观测性边界。

## 结果解释边界

Compute每条N512：M1/M2/M4算术容量下界分别256/512/1024拍，同一唯一权重4 MiB、上游条件容量下界512拍；M变化同时增加激活/输出工作。不得仅按权重文件大小认定实际MC流量相同，也不得因周期随M增长就直接称纯MAC瓶颈。

Cache的N128/k1只有一条普通OL1累加链，可能受约4拍局部反馈限制。即使MC读减量，周期不降也可能是该链掩盖收益。因此Cache对比只用于判定该shape下上游读影响，不与N512/k4的861直接作减法；它不是纯算术峰值测试。

本地日志与tb结果已保存；远端回执逐例写入submission_functional.json/submission_vcs.json，全部提交后写vcs_handoff.json。


## 数据与回放目录

任务根目录：`/DATA210/Application/liumx/TMPDIR/torch_zeus_vcs/lm_head_supply_compute_controls_20261028_r1`。各用例子目录含source.py、kernel.zbin、config.json、config_vcs.json、输入、golden、两核权重；对应`<用例名>_init`含Zeus3FunctionalSimulator的init.json和回放文件。binary mail补丁独立记录，source.py不能单独代表最终同步。

证据归档：[控制变量审计](artifacts/supply_compute_controls_20261028/comparison_gate.json)、[真实返回链TB结果](artifacts/supply_compute_controls_20261028/tb_results.json)、[设计源码哈希](artifacts/supply_compute_controls_20261028/tb_source_manifest.json)。

后续运行check_job.py下载各组VCS结果，再执行analyze.py核查输出、trace完整性、硬件版本及运行时隔离；提交成功不表示已获VCS性能结论。


## 已提交回执

所有用例本地和远端functional严格逐位PASS、preflight及权重基址验证通过。均为双核、64 MiB trace、6小时超时，无Relay编译toolchain。

| 用例 | Functional Job ID | VCS Job ID | 提交后状态 |
|---|---|---|---|
| ComputeM1 | `623aa4ca6ae3` | `9a3f509d08d9` | RUNNING |
| ComputeM2 | `0e46fd86df1e` | `2b9ce78819b0` | RUNNING |
| ComputeM4 | `203e44b1c8ed` | `49edd52fbb9e` | RUNNING |
| CacheSpread | `301c26320f37` | `68599fa3807d` | RUNNING |
| CacheHit | `d306ff63449e` | `50bc1dd8d226` | RUNNING |

回执归档：[vcs_handoff_status.json](artifacts/supply_compute_controls_20261028/vcs_handoff_status.json)。待任务完成后验收VCS数值及trace，不提前声称已构成计算受限或无供数限制场景。


## 供数/计算五组任务的完成结果（2026-10-28，四组完成）

ComputeM1 `9a3f509d08d9`查询时仍RUNNING，未标为数值失败；另外四组VCS均逐位PASS、trace sealed。M2 N512稳态863，M4稳态1075，M4相对1024拍算术容量折算95.26%；N128连续/命中对照均292，全部PE时间戳相同。N128有单链反馈限制，且远端MC请求数不可观测，不能用无收益排除N512的供数限制。Cache core0最后一个窗口有另一核VP重叠，已从隔离统计剔除，剩余窗口仍292。详见[供数与计算比例结果](PE_SUPPLY_COMPUTE_RESULTS_20261028.md)。
