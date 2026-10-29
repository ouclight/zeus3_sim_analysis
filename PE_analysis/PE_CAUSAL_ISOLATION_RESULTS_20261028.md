# C/I有效PE隔离结果：移除VP/ST重叠后仍为861 cycles

2026-10-28。对照C=`d4d53df3f4be`、I=`648b2dc564b1`。两组DONE，数值严格逐位PASS，运行时隔离验收PASS。

**本次形成了有效因果对照：把VP/ST执行移出两核完整N512稳态窗口后，PE稳态仍为861，且两组每核全部9条PE的开始、完成时间戳完全相同。本案例的VP/ST并发不是861稳态的限制因素。** 该结论不等于已证明MC是唯一根因，也不排除PE内部OL1输出、激活或权重返回链自身的限制。

## 1. 控制变量与正确性

这是固定精确二进制小数的合成诊断，不是原生产权重数值的重新采集。shape为M1/K4096/N8448，双核，各核8条N512及1条N128 PE；完整块local/page128、KC、w1/c32/k4。两组相同输入8192 B、输出初值33792 B、独立CPU golden33792 B，以及两核各35651584 B（34 MiB）权重，逐文件SHA256一致。

C使用旧D的独立结果缓冲和原同步；I仅清除前8条PE的SendMails.VP与随后8处VP的RecvMails.PE，保留末PE发送及首VP等待。共16处mail位改变，代码长度、数学字段、指令数量和地址均不变。不修改生产kernel、编译器或RTL。

| 检查 | C | I |
|---|---|---|
| 远端functional | 1353ea86055d，逐位PASS | 87208a660b03，逐位PASS |
| VCS任务 | d4d53df3f4be，DONE | 648b2dc564b1，DONE |
| 命名输出output_ptr | 33792 B，与golden逐字节相同 | 33792 B，与golden逐字节相同 |
| max_abs_diff / cosine | 0 / 1 | 0 / 1 |
| VCS post-pass checks | PASS | PASS |
| 每核事件数 | 9 PE、18 VP、9 ST | 9 PE、18 VP、9 ST |
| trace | sealed，funnel/writer clean，无overflow/truncation | 相同 |
| 环境 | MC模式、400 MHz | 相同 |

六项身份rtl_tag、simv、frozen RTL、mapping、implementation、server build digest全部相同。rtl_tag为tag_PN100_R1_20250928。observer仍标记draft、metric_eligible=false，不将结果称作认证硬件指标；以下使用完整raw命令trace和物理对齐时间，不使用meta.actual_cycles作为全局时间。

## 2. 运行时隔离确实成立

以下先使用各核自己的raw cycle时间，不跨核直接比较绝对时间戳：

| 核/配置 | 最后PE完成 | 首VP开始 | 首ST开始 | 首VP−末PE | 首ST−末PE |
|---|---:|---:|---:|---:|---:|
| core0 C | 17502 | 11206 | 11425 | −6296 | −6077 |
| core0 I | 17502 | 17534 | 17753 | +32 | +251 |
| core1 C | 9853 | 3557 | 3776 | −6296 | −6077 |
| core1 I | 9853 | 9885 | 10104 | +32 | +251 |

C中每个完整块完成间隔都重叠2条VP、1条ST；I中每核7个完整块完成间隔均重叠0条VP/ST。首VP至少等本核最后PE完成后32拍，首ST则晚251拍。因此这次不再是“源码写在后面，实际仍重叠”的无效隔离。

再通过trace_time_alignment把两核事件转换到同一物理时间：I的任一完整块稳态窗口内，来自**任一核**的VP/ST重叠计数均为0。最早VP/ST开始比两核中较晚的第8条完整N512完成晚296拍。

边界：mail同步是核内屏障，不是全芯片屏障。物理对齐后最早VP比另一核最后N128尾块完成早5拍；因此不宣称整个PE阶段全程没有跨核VP/ST。但这5拍只在尾块末尾，不涉及本次7个完整块稳态窗口。

## 3. PE时间完全没有变化

| 测量 | C core0/core1 | I core0/core1 | 差值 |
|---|---:|---:|---:|
| 首PE事件生命周期 | 953 / 953 | 953 / 953 | 0 |
| 7个完整块完成间隔 | 全部861 / 全部861 | 全部861 / 全部861 | 全部0 |
| N128尾块完成间隔 | 301 / 301 | 301 / 301 | 0 |
| 首PE start至末PE end | 7281 / 7281 | 7281 / 7281 | 0 |
| 双核物理对齐全算子时间 | 8239 | 9919 | +1680，约+20.39% |

不仅中位数相同，C/I每核9条PE的全部start/end都逐项相同：

```text
core0 PE end：11174,12035,12896,13757,14618,15479,16340,17201,17502
core1 PE end： 3525, 4386, 5247, 6108, 6969, 7830, 8691, 9552, 9853
```

PE跨度可交叉核算为`953 + 7×861 + 301 = 7281`。后续PE start含队列等候，不能用每个事件duration表示内部MAC活跃时间。

I全局变慢是延后VP/ST失去原有重叠的可见代价，不是PE吞吐退化。最后ST相对本核最后PE：core0由+310变+1990，core1由+369变+2049，均增加1680，与全局增量一致。400 MHz下全局时间从20.5975 µs增至24.7975 µs，差4.2 µs。

## 4. 对861根因的约束

### 已经证实的排除项

在当前固定数据、binary配对和硬件版本下，**VP/ST执行并发造成的资源竞争或反压不是PE稳态861的有效限制因素**：有并发和无并发时PE时间线完全相同。仅靠把VP/ST移后无法从861逼近条件512，生产优化不应采用本次隔离同步。

这比旧B/D对照更强：旧D实际稳态仍重叠VP/ST，不能排除它们的影响；本次I经过raw trace确认确实把它们移出完整块稳态窗口。

### 仍然没有证明的内容

本次没有直接测出MC服务时间、GDG额度生命周期、Hub最慢路等待、WL1接收反压、AL1断流或OL1输出等待。它排除了一个具体外部竞争因素，不能把剩余349拍全部标成MC等待，也不能宣布15笔窗口一定满过。PE自身结果输出到L2等路径仍存在于隔离期间，“无VP/ST”不等于“无任何结果写回”。

8 KiB/拍仍只是条件接口容量。工作量折算的59.47%不是WL1端口busy率；本次也没有直接观察8个group各自的内部就绪情况。

## 5. 下一步

C/I的isolation_gate已PASS，地址工作集Spread/Alias的前置隔离条件现已满足；两组此前functional均逐位PASS。后续应按既有授权和门控提交/分析这对任务：相同I binary、输入、golden、权重payload，只改变索引引用的物理页工作集。

若Alias相对Spread明显变快，进一步支持地址局部性相关MC/返回服务机制有贡献；若无变化，则这次工作集收缩无收益，不能直接证明MC不受限。再结合真实返回链计数testbench的窗口/慢路/消费者反压敏感性，决定缺哪项MC配置或计数。合成testbench不能替代生产内部计数。

## 6. 文件与复现

任务根目录：

```text
/DATA210/Application/liumx/TMPDIR/torch_zeus_vcs/lm_head_m1_causal_isolation_20261028_r1
  C/remote_vcs/     # C的raw trace、结果、alignment、身份和日志
  I/remote_vcs/     # I的同类文件
  mail_patch_audit.json
  isolation_gate.json
  analyze.py
```

下载结果后在该目录执行`/DATA210/Application/liumx/miniconda3/envs/torch_zeus/bin/python analyze.py`，可重算正确性、身份、封存完整性、同核隔离门控及PE间隔。

归档证据：[isolation_gate.json](artifacts/causal_isolation_results_20261028/isolation_gate.json)。跨核重叠复核脚本及额外指标见同目录的[recheck.py](artifacts/causal_isolation_results_20261028/recheck.py)和[extended_metrics.json](artifacts/causal_isolation_results_20261028/extended_metrics.json)。
