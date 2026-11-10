# 原厂DW模型接入与M1/M4本地验证

日期：2026-11-03。接续[FIFO empty时序校准](PE_FIFO_RETURN_TIMING_RESULTS_20261103.md)。

**已接入四个同版本原厂DW模型并完成本地验证。M1 local稳态572拍，M4 normal稳态1177拍，均与上一轮校准模型一致；单MC及M1/M4三份完整运行日志逐字一致。DW同步器/RAM行为替代没有解释本轮条件下的289拍差距。**

> **后续统筹审计修正（见第6节）：** 本地572拍使用WSTMOD=1、WIDXEN=0；归档远端M1程序WMode=3按当前RTL对应WSTMOD=1、WIDXEN=1。此前“local/k4”简称掩盖了索引路径覆盖差异。**第7节已完成真实索引页对照：572→607拍，增加35拍；仍未复现861拍。**不能只把剩余差异归为PHY或远端未知配置。

## 1. 本轮替换范围

使用新提供的`code/Zeus518/EDA/synopsys/syn/U-2022.12/dw/sim_ver`中的四个同版本模型：

- `DW_fifo_s2_sf.v`
- `DW_fifoctl_s2_sf.v`
- `DWsc_sync.v`
- `DW_ram_r_w_s_dff.v`

本轮不再编译上一轮的`support.sv`，因此返回FIFO所用同步器和RAM已由原厂模型提供。MC清单指向同一个U-2022.12安装目录；这与所见工程清单一致，但不能确认远端861拍任务也使用该版本。

原文件保持不变。测试目录副本将`translate_off/on`改为普通注释，使Verilator能够执行原仿真主体；FIFO顶层增加仅用于守恒检查的push/pop计数。控制器、同步器及RAM行为没有人工添加延迟或重写。来源哈希和修改范围由[模型审计脚本](artifacts/pe_original_dw_20261103/audit.py)核验。

未启用`DW_MODEL_MISSAMPLES`随机采样模式；采用当前FIFO实例指定的同步级数和复位模式。原厂模型的其它配置不能由本轮结果一概推断。

## 2. 不变条件

- 单核8-group、64个PE、256条MC通路。
- MC profile=1，MC与PE均400MHz，命令驱动PHY模型tAA=7ns。
- M1 local V-cache：w1/c32/k4、N512、K4096。
- M4 normal：w4/c16/k1、N512、K4096。
- 每组连续3条PE指令；A和W仍为BF16全1，FP32输出期望4096。
- 无刷新、无其它背景流量；仍未接入加密PHY原模型，也没有增加双核竞争。
- 不修改生产RTL、kernel或Triton编译器，不发送远端任务。

## 3. 分层验证

### 3.1 FIFO单元

[原厂DW单元目录](artifacts/pe_original_dw_20261103/)：

- 405笔带输入空闲、下游暂停、队列满及指针回绕的传输，全部按序通过。
- 相对最初简化FIFO，空队列第一笔可读时刻仍由第4拍变为第5拍；与上一轮校准模型一致。
- 连续512笔后续传输最大读间隔仍为1拍，两侧总计513笔均正确。

使用Icarus运行，保留四态检查；没有用全1数据掩盖这项FIFO顺序检查。

### 3.2 单MC＋GDG返回/credit闭环

[单MC目录](artifacts/mc_original_dw_20261103/)使用真实MC读控制、GDG返回/credit链及原厂DW返回FIFO。

4096笔请求全部完成，数据顺序、ECC、请求/返回/credit守恒及队列排空通过。**整个run.log与上一轮校准模型逐字一致**，包含4096笔的接受、CAS、PHY返回、MC返回、ECC及额度释放时间。

| 指标 | 上一轮校准FIFO | 本轮原厂DW |
| --- | ---: | ---: |
| 各环节请求/返回数量 | 4096 | 4096 |
| CAS首尾窗口，含首尾拍 | 4507拍 | 4507拍 |
| credit halt统计 | 410拍 | 410拍 |
| MC请求端未ready统计 | 410拍 | 410拍 |
| 返回/Hub接收反压 | 0 / 0 | 0 / 0 |
| 最大在途额度 | 15 | 15 |

### 3.3 完整8-group计算

[完整8-group结果目录](artifacts/pec_original_dw_x8_20261103/)。M1/M4使用同一新编译二进制，以`+M=1/4`选择指令和输入行数。

| 配置 | 最初简化FIFO | 上一轮校准FIFO＋同步器/RAM替代 | 本轮原厂DW四件套 |
| --- | ---: | ---: | ---: |
| M1 local w1/c32/k4 | 570拍 | 572拍 | **572拍** |
| M4 normal w4/c16/k1 | 1177拍 | 1177拍 | **1177拍** |

本轮完成时刻：

- M1：874、1446、2018拍，间隔572、572拍。
- M4：1817、2994、4171拍，间隔1177、1177拍。

以第二、第三块的group0窗口为例，8个group统计一致：

| 计算接口指标 | M1 local | M4 normal |
| --- | ---: | ---: |
| 每块MAC窗口，含首尾拍 | 551 | 1157 |
| 每PE每块有效MAC拍 | 256 | 1024 |
| 窗口内weight-invalid | 295 | 0 |
| 窗口内activation-invalid | 0 | 133 |
| 窗口内command-invalid / pipe-not-ready / OL1输出阻塞 | 0 / 0 / 0 | 0 / 0 / 0 |
| 相邻块MAC窗口之间空拍 | 21 | 20 |

M1相邻有效MAC间隔仍为252个2拍、2个15拍、1个16拍；M4为1016个1拍、7个20拍。上述计数与上一轮全部一致。单个接口的valid/ready统计不等于对全部内部等待做了互斥分解。

正确性检查全部通过：

- M1：1536个FP32输出均为4096，每PE三块累计768个有效MAC拍。
- M4：6144个FP32输出均为4096，每PE三块累计3072个有效MAC拍；每group权重分发3072次、弹出768次，4:1复用守恒。
- 两组256条MC通路均分别完成1536笔接受、MC接收、CAS、PHY返回、ECC解码、credit释放和下游接收，全部排空。
- 每group每块512笔请求地址序列通过断言。
- 两组`analysis.json`全部内容与上一轮相同；不仅完成间隔相同，**完整run.log的SHA256也相同**，见[日志一致性记录](artifacts/pec_original_dw_x8_20261103/raw_log_equality.json)。
- 原厂四个来源文件哈希未变化；上一轮校准台架98个来源文件，以及更早两个台架各94个来源文件哈希均未变化。

全1计算数据验证累加数量、计算路径及输出完整性；它不替代任意生产权重的布局排列验证。FIFO单元和单MC测试另外使用了可区分的数据检查顺序。


## 4. 复现入口

```bash
python /DATA210/Application/liumx/code/algorithm/bjxx/artifacts/pe_original_dw_20261103/audit.py
python /DATA210/Application/liumx/code/algorithm/bjxx/artifacts/pe_original_dw_20261103/run.py
python /DATA210/Application/liumx/code/algorithm/bjxx/artifacts/mc_original_dw_20261103/run.py
python /DATA210/Application/liumx/code/algorithm/bjxx/artifacts/pec_original_dw_x8_20261103/build.py
python /DATA210/Application/liumx/code/algorithm/bjxx/artifacts/pec_original_dw_x8_20261103/run.py
python /DATA210/Application/liumx/code/algorithm/bjxx/artifacts/pec_original_dw_x8_20261103/compare.py
```

完整编译通常需要数十分钟；两组计算验证需要数分钟。

## 5. 本轮结论

1. **所提供DW目录可以在当前本地工具中使用。**已经完成Icarus单元/单MC验证，以及Verilator完整8-group验证；不需要root或安装VCS即可运行本轮模型。
2. **返回FIFO的两个行为替代依赖已消除。**本轮四件套全部来自同一U-2022.12安装目录；在本次时钟、同步级数、负载和确定性采样条件下，与上次校准结果完全一致。
3. **不能继续将剩余差距归咎于“仍缺DW同步器/RAM”。**M1本地仍572拍，远端历史861拍，差289拍；这不是已测得的某一级等待时间，也不证明所有DW配置均与远端一致。
4. 本轮没有接入原厂加密PHY、完整远端初始化/时钟/编译宏和双核生产连接。若继续定位，应以这些生产证据校准模型，而不是继续调整返回延迟去拟合861。M4的1177拍一致仍不能独立证明M1高频供数路径已覆盖远端全部行为。

本轮没有获得新的kernel性能优化收益；成果是移除了DW行为替代这一项模型不确定性，并保留了可重跑的原厂依赖台架。

## 6. 全链路统筹审计：先确认覆盖差异，再解释周期（2026-11-03）

本节重新核查台架源代码、归档生产反汇编及现有逐周期结果，**未新增仿真**。审计字段、数值和源码SHA256见[环境对齐审计](artifacts/pe_environment_alignment_20261103/audit.json)。

### 6.1 最重要的已确认差异：本地关闭了生产程序使用的索引模式

| 对象 | 源码/程序证据 | 结论 |
| --- | --- | --- |
| 861基线B归档程序 | `lm_head_m1_deferred_vp_st_20261028_r1/B/kernel.disasm.S:78`配置WMode[3]；:79配置WBS[7]及w1/c32/k4 | 生产程序包含索引模式及页大小配置 |
| 当前指令前解码 | `code/rtl/zeus518/inst_ctrl/inst518_pe_inst_predecode.v:445`：wstore_mode=wmode[1]，widx_en=wmode[0]；:497将二者编码进命令 | WMode=3对应V-cache且启用索引 |
| WL1解码 | `wl1_518_inst_decode.v:114`与`:116`：WIDXEN位58，WSTMOD位59 | 可直接核查台架生成字 |
| 当前台架driver.cpp的M1 q5 | 设置bit59，没有设置bit58 | 本地为WSTMOD=1、WIDXEN=0，即直接地址V-cache子路径 |
| 本地driver与lane | 每条指令每MC只期望512个values字，地址128…639，重复3次；PHY只返回BF16全1 | 未发送实际索引数据，也未回放生产完整请求流 |

这是明确的**测试覆盖不匹配**，不是已证明的289拍根因。生产WIDXEN结论来自归档程序结合当前RTL解码，尚无远端内部解码信号；当前本地RTL与远端构建版本仍需区分。

此前“真实WL1指令/索引控制已实例化”的说法仅表示模块存在，**不表示索引分支被激活和验证过**。同为w1/c32/k4、同样4MiB values，不能认为两组执行同一条供数流程。M4 normal不启用索引，因此它的1177拍吻合也没有验证M1特有的索引状态机。

### 6.2 索引模式为什么可能增加持续空洞

当前RTL `wl1_518_weight_ctrl.v:922–964` 的索引状态机为：

```text
IDX_BLOCK_RD：发索引读取
        ↓ 请求握手
IDX_WAIT_DAT：等索引返回
        ↓ weight_index_rd_data_flag
IDX_WAIT_CAL：依据索引生成values读取
        ↓ 索引块边界/相关计数变化
再次发索引读取
```

- `IDX_WAIT_DAT`期间两种请求发出标志均为0，`:1363`因此关闭`c_weight_rd_vld`。
- 索引有效条件`:981`包含返回握手且outstanding==1，不是本地组合立即得到索引。
- `:1355`将索引返回从普通权重数据有效流中剔除，它不能直接供MAC计算。
- 即使索引字节数很少，先读取索引再得到values地址的依赖也可能制造等待；等待能否被预取数据覆盖，要看真实FIFO存量和状态切换。

因此“values连续＋接口字节容量足够”不代表“始终有values请求可发”。这条机制是具体可验证的方向，不需要先人为增加PHY延迟。还不能把索引读取次数、每次等待或总损失猜成289拍；应以WBS、PIDX、地址及真实状态轨迹计数。

### 6.3 当前逐周期数据流及覆盖清单

```text
测试驱动生成三条PEC命令，预写L2激活（不是完整kernel.zbin回放）
    ├─ PEC → L2读激活 → AL1 → MAC
    └─ PEC → WL1指令/地址控制
               ↓ 本地WIDXEN=0，仅values请求
           双Hub请求分发 → GDG请求FIFO/credit
               ↓ 直接连接部分MC功能读链
           mc_frame2frame_aux → frame2array_aux
               ↓ CAS/行列地址
           C++ PHY模型：每个CAS后7ns返回全1数据
               ↓
           原厂DW返回FIFO → ECC → GDG返回/credit释放
               ↓
           Hub汇合 → WL1整理/缓存 → PE权重接口 → MAC
                                                        ↓
                                               OL1累加 → group输出 → PEC → L2
```

| 环节 | 已验证内容 | 与完整设计/实际运行尚不一致或未知的部分 |
| --- | --- | --- |
| 指令入口 | 真实PEC和下游命令控制 | 手工生成3条控制指令，非完整IQ/CT/zbin运行；WBS/PIDX索引描述符未复现 |
| 权重地址 | 每lane 512个连续values字，逐笔断言 | 关闭索引；生产各块values地址递进，本地重复128…639；完整索引+values流未对齐 |
| Hub/WL1 | 真实分发、响应汇合、formatter及8group接收反压 | DIN/uscale/写请求禁用；部分外围控制和映射为手工连接/常量 |
| GDG | 原RTL请求/返回FIFO、15笔额度、请求流水 | 直接构造rr_data，未实例化完整gdg_unit；读写仲裁器缺省纯读单测无额外气泡，但完整wrapper仍未回归 |
| MC | 原RTL功能读控制、行列映射、ECC、DW返回FIFO | 未完整实例化mc_subsys_top/mc_top_aux及MC仲裁、APB/TRIM初始化；配置直接接常量；刷新/BIST关闭 |
| PHY/阵列 | 按真实CAS发起固定7ns返回 | 未执行原厂加密PHY和阵列模型，返回数据不是从完整存储模型按地址读出 |
| 时钟/映射 | 400MHz同频、固定相位；splicing=1，bank_map=0xe4等常量 | 远端MC实际频率/相位和寄存器读回未知；trace的Core频率不能代替MC频率 |
| AL1/MAC/OL1 | 64个真实PE，ready自然产生，输出数值验证 | 全1数据不是任意生产张量；只代表当前命令与供数条件 |
| L2/输出 | 真实PEC/L2计算读写，完成与回读门控 | 激活由测试端预填，无完整LD/VP/ST系统流量；但远端C/I对照已经排除该案例VP/ST并发是861原因 |
| 双核/顶层 | 单核8group全部接齐 | 未展开可匹配的双核生产顶层；此前源码审计发现包装层端口版本不一致，不能随意加一个共享MC仲裁器 |
| 库与版本 | 原厂DW四件套已验证，消除了相应替代模型 | 导入sim_model filelist选择PHY_IP_20251023，而此前关注09_12；仍不知远端实际选用哪个；两态Verilator不是同一VCS执行环境 |

“未覆盖/配置未知”不等于“该环节已经被证明出错”。特别是不能仅凭PHY未接入就认定289拍在PHY，也不能因双核运行就认定MC争用。生产MC完整包装层包含`mc_frame_arbiter_aux`等模块，而本地lane只实例化功能读子模块，需明确这一范围。

### 6.4 512、572、861分别是什么

固定M1/N512/K4096、BF16，每块：

```text
标量MAC数 = 512×4096 = 2,097,152
有效权重 = 512×4096×2B = 4,194,304B = 4MiB
计算容量 = 64PE×128 MAC/拍 = 8192 MAC/拍
纯算术下界 = 256拍
条件权重容量 = 256 MC通路×32B/MC拍 = 8192B/MC拍
同频条件的values传输下界 = 512拍
```

512拍要求各通路能持续服务、返回和接收，未计索引流量/依赖、换行及启动交接。它不是实测带宽，也不是整条指令的必达耗时。计算与供数可重叠，不能先把256和512相加。

本地572拍能根据真实事件做如下端点分解：

```text
理想256个MAC每两拍一次，首末含首尾 = 1+255×2 = 511拍
实际稳态窗口 = 1+252×2+2×15+1×16 = 551拍
长间隔相对两拍基准的额外跨度 = 2×(15−2)+(16−2) = 40拍
相邻MAC窗口之间空拍 = 21拍
持续周期 = 551+21 = 572拍
```

512是供数容量计数，511是有效MAC首末端点窗口，两者口径差1，不能把它当成硬件优化。三个长间隔对应此前观察的每64个MAC边界；MC真实读控制的换行空洞有跨实验支持，但40拍是计算接口观察值，不应与MC、credit、Hub各处等待计数重复相加。

以第二块group0为例，首MAC=837、末MAC=1387，PEC完成=1446；第三块首MAC=1409、末MAC=1959，PEC完成=2018。两块完成相差572；末MAC到PEC完成均59拍。**这59拍已与下一块启动重叠，不能再加到572上。**

| 指标 | 本地非索引M1 | 远端归档索引M1 |
| --- | ---: | ---: |
| 块完成间隔 | 572 | 861 |
| 有效values工作量/条件容量比512/T | 89.51% | 59.47% |
| 有效算术工作量/峰值比256/T | 44.76% | 29.73% |
| 每512个有效values传输拍折算时间T/512 | 1.1172 | 1.6816 |

这些是有效工作量比值，不是接口实际active计数。`861−572=289`是**两个覆盖范围不同的实验差值**，不能称作已经定位的289拍MC等待。

### 6.5 为什么M4更高效仍不能证明M1供数模型正确

M4每块仍读4MiB权重，但总MAC为M1的4倍。每份权重跨4行输入复用，纯算术下界1024拍，高于512拍权重容量下界。实测1177拍对应87.00%算术利用率，计算窗口内weight-valid持续为1。

M1/k4交错的是四个不同输出组，缓解同一累加结果的反馈依赖，但每次仍需新权重，未获得四行权重复用。此外当前本地M1还关闭了生产索引分支；M4 normal天然不走该分支。因此M4吻合既不能排除M1带宽压力差异，也不能验证M1的索引依赖。

### 6.6 下一步应先做的确定性对齐

优先级应由“先追加密PHY”调整为“先把已知生产指令/索引语义接进台架”：

1. 从冻结B/C/I或典型861任务提取完整BR描述符、WMode/WBS/PIDX、每条PE参数、两核索引页及values地址；保存解码清单。核对当前前解码中的V-cache PIDX交换与生产ABI，不能只改bit58。
2. 保留当前MC时序和原厂DW、单核8group及PHY tAA不变，建立地址驱动的存储映射，实际返回合法索引字及对应values。当前“CAS后永远返回BF16全1”的驱动不能用于索引模式。
3. 先做同一values映射的非索引/索引受控对照，再恢复生产跨块地址递进；每次只改变一个因素。回归M4 normal以检验共用路径。
4. 计数分开记录索引请求、values请求、索引返回等待、values有效请求为0的周期、MC valid&&!ready、credit halt、Hub部分返回、WL1有数据但PE拒收。索引等待还需与MAC缺权重区间求交，只有传播到关键路径的部分才增加总时间。
5. 守恒门控改为“按索引/values分别核验”，保留values每MC每块512笔；不能继续要求整个请求流恰好512笔，也不能为通过测试简单删除地址断言。数值应有能区分页/行的数据，避免全1掩盖索引错误。

只有该对照完成，才能判断索引路径解释了多少剩余差距。若仍有偏差，再按有效filelist逐项补完整GDG/MC包装层、生产配置和PHY；缺少远端配置时只报告条件结果，不通过扫延迟寻找861。

本次统筹结论是：**当前最明确、可在本地继续修正的缺口是生产索引路径未被激活，不应再把“有真实RTL模块”当作“运行了相同的生产路径”。** 这项核查不需要重新编译Triton，也不需要先复制28GB VCS。


## 7. 真实索引页受控对照（2026-11-03，已完成）

本轮在独立目录[pec_index_control_x8_20261103](artifacts/pec_index_control_x8_20261103/)中修改测试驱动和校验，不修改生产RTL。MC时序profile=1、400MHz、PHY tAA=7ns、原厂DW模型、PEC/L2与64个PE均保持不变。

### 7.1 对照合同

- 两组均为M1、N512、K4096、w1/c32/k4，连续重复首个tile三次。尚非生产程序的三个连续不同tile，也不是完整zbin回放。
- A与values仍用BF16全1，期望1536个FP32输出均为4096。真实索引页取自归档B的core0权重文件前16KiB，保留源文件与页SHA256。
- 两组均补发opcode5描述符：WBS=7、PIDXWN/WK/WC=0；SC/DC统一为4095/511。
- direct：WSTMOD=1、WIDXEN=0，WSADDR指向values；indexed：WSTMOD=1、WIDXEN=1，WSADDR指向索引页。
- PHY模型在收到真实CAS后保留请求地址，到原有tAA时刻根据地址返回索引或values；不按第几次返回硬塞索引、不增加人为等待。
- 每一笔MC地址均与独立期望序列校验；索引经过GDG及Hub时逐字校验。保留ECC、credit守恒、所有MC排空、各PE有效MAC次数及L2输出数值检查。

### 7.2 静态展开已核验

真实索引前32项是`64+8*p`，其中`p=0…31`。WBS编码7表示页内128个归约元素；每页包含2个64元素的C miniblock。令`c=0…63`、输出组`g=0…3`、返回半拍`b=0…1`，单MC的32B word地址为：

```text
page = index[c//2] = 64 + 8*(c//2)
word = 2*page + 2*(4*(c%2)+g) + b
     = 128 + 8*c + 2*g + b
```

按c、g、b遍历，恰好得到`128…639`，与direct组相同。512笔展开结果见[address_expansion.json](artifacts/pec_index_control_x8_20261103/address_expansion.json)。这只是静态期望，动态仿真仍必须通过相同断言。

索引请求在`wl1_518_weight_rd_ctrl.v`中由地址bit9选择单个Hub；当前基址为0，因此只访问Hub0。values请求使用双Hub。预期每条指令每group多读一次512B索引，八个group共4KiB；前32项能放入128项索引寄存器。不能将预留16KiB索引页大小当作本条指令实际读取量，也不能仅按4KiB/带宽推断依赖等待时间。

预期三条指令各Hub0 MC完成1539笔，各Hub1 MC完成1536笔；values工作量不变。需由动态结果确认是否存在额外重复索引请求。

### 7.3 动态结果

同一二进制的两组运行及分析均通过，详见[results.json](artifacts/pec_index_control_x8_20261103/results.json)、[comparison.json](artifacts/pec_index_control_x8_20261103/comparison.json)和[执行状态](artifacts/pec_index_control_x8_20261103/execution_status.json)。

| 指标 | direct，WIDXEN=0 | indexed，WIDXEN=1 |
| --- | ---: | ---: |
| 三块PEC完成时刻 | 875 / 1447 / 2019 | 889 / 1496 / 2103 |
| 两次完成间隔 | 572 / 572 | **607 / 607** |
| 稳态每块MAC窗口，含首尾 | 551 | 551 |
| 每PE每块有效MAC拍 | 256 | 256 |
| MAC窗口内weight-invalid | 295 | 295 |
| MAC窗口内activation-invalid / command-invalid / pipe-not-ready / OL1输出阻塞 | 0 / 0 / 0 / 0 | 0 / 0 / 0 / 0 |
| 相邻MAC窗口之间空拍 | 21 | **56** |
| 每条指令每group的values请求 | 512 | 512 |
| 每条指令每group的索引请求 | 0 | 1，仅Hub0 |

8个group的稳态MAC窗口及上述空拍数一致。两组窗口内有效MAC间隔分布也一致：252个2拍、2个15拍、1个16拍。新增索引并未在本轮条件下加剧块内的持续供数空洞。

动态验证通过：

- 各group每块values地址均为`128…639`；索引组额外访问索引地址0，无其它重复索引读取。
- direct全部256条MC通路各完成1536笔；indexed的128条Hub0通路各1539笔、128条Hub1通路各1536笔。接受、MC接收、CAS、PHY返回、ECC、credit释放、下游接收计数全部相等，队列排空。
- 两组各1536个FP32输出逐位等于4096；每个PE累计768个有效MAC拍。
- 生产RTL和原厂DW来源哈希与上一轮一致，没有修改这些源码。
- [错误索引反例](artifacts/pec_index_control_x8_20261103/negative_index/status.json)：仅修改首个索引字，GDG返回逐字检查按预期失败（`GDG data ID=0`）。这验证了索引校验生效；可用`negative.py`重跑。

### 7.4 新增35拍的逐周期证据

以indexed的group0第二条指令为例：

```text
c=815       接受索引请求，IDX_BLOCK_RD
c=816…849   IDX_WAIT_DAT，共34拍；不发新的values请求
c=849       索引返回握手、更新索引寄存器
c=850       第一笔values请求握手
c=887       第二块第一拍有效MAC
c=1437      第二块最后一拍有效MAC
c=1496      第二块PEC完成
```

这里索引请求到第一笔values请求相隔35拍。此前第一块的最后一个MAC在c=830，说明部分索引等待与前一块计算重叠，**不能把34拍状态计数直接称为34拍全PE停机**。

同口径的受控结果是：

```text
direct ：551拍MAC窗口 + 21拍相邻窗口空拍 = 572拍
indexed：551拍MAC窗口 + 56拍相邻窗口空拍 = 607拍
差值   ：                                 35拍
```

这是两组本地模型中可复核的窗口分解，不是将MC、MAC、OL1各自耗时机械相加。首块完成只相差14拍，与稳态35拍不同，不应用首块启动时间代替稳态。

### 7.5 对861拍问题的结论与下一步

**此前关闭索引确实漏测了开销：在当前固定环境中为35拍/块。但接入真实索引后仍只有607拍，没有复现861拍。** `861−607=254`仍是跨环境差值，不能称为已测得的某级254拍等待，也不能把本轮35拍直接等同于远端索引开销。

本轮32个索引项覆盖完整K4096，values地址与direct一致，因而不支持“每换一个输出组都必须重新读索引，造成大量块内空洞”的解释。当前WIDXEN路径的主要新增效应是跨指令的索引依赖。

下一步应先把测试驱动从“首tile重复三次”换成归档生产的连续tile索引基址、values基址及相应描述符流，保持本轮MC/PHY/DW条件不变；核查每条实际展开的请求和MAC间隔。随后再对齐完整程序的生产配置及拓扑。不能通过继续增加PHY延迟将607人为拉到861。

此轮仍用可说明范围的诊断values，不是原生产随机权重的逐位数值回放；加密PHY、远端初始化/时钟/宏、双核连接等边界也没有因本轮通过而自动得到验证。

复现：

```bash
python /DATA210/Application/liumx/code/algorithm/bjxx/artifacts/pec_index_control_x8_20261103/build.py
python /DATA210/Application/liumx/code/algorithm/bjxx/artifacts/pec_index_control_x8_20261103/run.py
```

`run.py`使用同一二进制运行两组，任何地址、数值、守恒或完成检查失败都会停止分析。


## 8. 连续tile地址流对照（2026-11-03，已完成）

使用[pec_production_tiles_x8_20261103](artifacts/pec_production_tiles_x8_20261103/)台架，保持第7节的MC/PHY/DW、PEC/L2、单核8-group、BF16全1数值数据不变。

两组均启用索引，均在4个公共shape命令后，为每个tile发送WSADDR、WBS/PIDX、执行命令，共13个命令字。`repeat`重复首tile；`sequential`使用归档前三个完整tile。两组输出仍写入三个独立本地L2区域便于读回验证，不包含生产VP/ST、完整指令取指程序及双核执行。

| tile | 索引字节基址 | values字节基址 | 每MC索引word地址 | 每MC的512个values word地址 |
| --- | ---: | ---: | ---: | --- |
| 0 | 0 | 1MiB | 0 | 128…639 |
| 1 | 16KiB | 5MiB | 2 | 640…1151 |
| 2 | 32KiB | 9MiB | 4 | 1152…1663 |

此处字节基址是归档单核权重映像内偏移；MC word为32B，已去掉跨group/Hub/MC交织的地址位，不能直接用字节偏移除以32得到。

归档打包脚本`lm_head_m1_local_vcache_20261027_r1/prepare.py`的`pack_core`为每tile分配16KiB索引页和4MiB values。台架从归档B的core0文件直接抽取前三页原始索引，核对每页每group前32项为`64+256*tile+8*p`，其余项为该tile的起始页。来源哈希见[experiment.json](artifacts/pec_production_tiles_x8_20261103/experiment.json)，逐笔展开见[address_expansion.json](artifacts/pec_production_tiles_x8_20261103/address_expansion.json)。

WBS=7、PIDXWN/WK/WC=0、TC=4095、TK=511、WC=511、MTW/MTC/MTK编码0/31/3保持不变。地址驱动PHY在接收到实际CAS后根据地址选择相应归档索引页，values仍为受控全1区域。没有按返回笔数伪造地址、跳过索引或额外添加等待。

动态验证包括13个实际命令字、WL1解码字段、三个实际基址、每笔MC地址、索引字节、ECC及credit守恒、64个PE的MAC次数和1536个FP32输出。两组仿真、地址/数值分析和逐周期对照已全部通过。


### 8.1 仿真结果

| 指标 | repeat：重复首tile | sequential：连续前三tile |
| --- | ---: | ---: |
| PEC完成时刻 | 889 / 1496 / 2103 | 889 / 1496 / 2103 |
| 完成间隔 | 607 / 607 | **607 / 607** |
| 每块MAC窗口，含首尾拍 | 551 | 551 |
| 相邻MAC窗口空拍 | 56 | 56 |
| 每PE每块有效MAC拍 | 256 | 256 |
| 窗口内weight-invalid | 295 | 295 |
| 稳态索引WAIT_DAT状态拍数（group0） | 34 | 34 |
| 实际下发命令字 | 13 | 13 |

两组全部1536个FP32输出逐位为4096，64个PE各完成768个有效MAC拍。每条Hub0 MC通路完成1539笔，Hub1通路完成1536笔；接受、MC接收、CAS、PHY返回、ECC解码、credit释放和接收计数守恒，全部排空。

实际WL1解码：repeat的索引基址始终0；sequential依次出现`0x0、0x4000、0x8000`，WBS=7、PIDX=0及shape正确。每条MC的动态地址全部通过第8节地址表的逐笔断言。因此这不是仅改了台架标签而仍访问同一批权重。

更强的对照证据见[comparison.json](artifacts/pec_production_tiles_x8_20261103/comparison.json)：

- 8个group的17,288条COMPUTE监测行逐行一致，包括MAC、权重/激活valid、接收ready、command、pipeline和OL1输出接口。
- 去掉地址字段后，8个group的17,288条WL1 CTRL监测行逐行一致。
- 代表性MC0的2,160条MCSTEP记录，去掉row/col地址字段后逐行一致；全部256条MC通路的累计统计也一致。
- 本轮repeat与第7节9命令字indexed对照的完成间隔、窗口、索引等待、MC计数统计一致，证明本轮额外重发描述符未改变该稳态。
- 88个生产RTL/DW等来源文件哈希与上一轮一致。

这说明在**当前单核8-group、固定MC/PHY配置、前三个完整tile的范围内**，连续新地址没有制造额外请求空洞，不能用“之前重复首tile所以错误地得到607拍”解释剩余差距。

### 8.2 结论边界

本轮修正的是索引/权重地址序列覆盖，不是新的kernel提速。稳态仍为607拍，历史远端861拍仍差254拍；没有依据将这254拍归为某个单独模块等待。

本轮未覆盖：整个单核8个完整tile加N128尾tile、另一核共享拓扑与背景流量、生产随机权重数值回放、完整zbin取指/调度/LD/VP/ST程序、远端实际初始化/时钟/宏、加密PHY模型。不得将前三tile的地址对照扩展为“远端所有地址及环境均已对齐”。

若继续，应围绕这些尚未对齐的边界推进；不再重复仅改变这三个tile基址的同类测试，也不通过人为增加PHY延迟去拟合861。

### 8.3 复现及证据

- [运行状态](artifacts/pec_production_tiles_x8_20261103/execution_status.json)：两组退出码0。
- [逐group/MC分析](artifacts/pec_production_tiles_x8_20261103/results.json)。
- [来源、地址与描述符合同](artifacts/pec_production_tiles_x8_20261103/experiment.json)。
- [相对上一轮的台架修改](artifacts/pec_production_tiles_x8_20261103/testbench_changes.patch)。

```bash
python /DATA210/Application/liumx/code/algorithm/bjxx/artifacts/pec_production_tiles_x8_20261103/build.py
python /DATA210/Application/liumx/code/algorithm/bjxx/artifacts/pec_production_tiles_x8_20261103/run.py
```


## 9. 当前仿真覆盖统筹与逐周期性能审计（2026-11-03）

本节以第8节连续tile台架为当前基线。第6节中“关闭索引、重复首tile、WBS/PIDX未覆盖”是当时状态，已由第7、8节修正；不能继续把这些列为当前遗漏。本轮复跑已有`compare.py`核验日志和来源，未重新执行RTL仿真、修改RTL或编译器。

**结论：已解释当前本地条件下的607拍；尚未解释远端861拍。已经找到并修正一个真实覆盖遗漏——生产索引分支；其本地受控影响为35拍。剩余254拍首先是环境一致性问题，尚不能归因到某一级硬件。**

### 9.1 按证据强度整理已有实验

| 实验 | 可以采用的结论 | 不可扩展的结论 |
| --- | --- | --- |
| 远端C/I，完整块稳态均861 | 此案例移除两核VP/ST稳态并发没有改变PE时间线 | 不能排除PE自身输出、权重返回或其它内部限制 |
| 原厂DW替换校准模型，M1=572、M4=1177且日志一致 | 已验证配置中DW替代差异不是性能差距来源 | 不能据此证明整个MC/PHY已经等价 |
| 真实索引开关，572→607 | 生产索引依赖确实有额外开销，本地为35拍 | 不能把远端索引开销也直接指定为35拍 |
| 重复首tile/连续前三tile，均607 | 当前配置中前三tile新地址和描述符重发没有追加气泡 | 未覆盖整核8个完整tile、尾块或其它核 |
| M4 normal本地1177与历史表现吻合 | 低权重消费压力、四行复用路径具有交叉验证 | 不能验证M1高频新权重消费和索引分支 |

早期人为DIN竞争、可调PHY延迟、ready周期屏蔽仅是敏感性实验。即使结果接近861，也不构成生产根因证据，不纳入当前周期归因。

### 9.2 哪些已对齐，哪些明确不同，哪些尚无法确认

| 环节 | 当前实际执行内容 | 一致性判断 |
| --- | --- | --- |
| shape及权重描述 | M1/N512/K4096，w1/c32/k4；编码0/31/3；WMode索引分支、WBS=7、PIDX=0 | 已对齐选定归档前三完整tile字段；不是split-K |
| 索引与values地址 | 归档原始索引页；实际RTL展开地址，CAS地址逐笔检查 | 已对齐前三tile；values为全1，非生产随机权重 |
| PEC、8-group、64PE、AL1/MAC/OL1、L2 | 实际RTL执行，计算侧自然产生ready，输出读回逐位检查 | 已覆盖所选RTL及当前配置，不再是always-ready计算端 |
| WL1及Hub | 实际指令、索引、分发、返回汇合和权重整理控制 | 有真实模块，但外围连接是台架；DIN/uscale/写流量关闭 |
| GDG | 实际请求转换、返回FIFO和credit链 | 未实例化完整生产gdg_unit包装及全部客户端连接 |
| MC | 实际`mc_frame2frame_aux`、`frame2array_aux`、ECC和DW返回FIFO | **功能读子路径，不是完整mc_subsys_top/mc_top_aux**；MC帧仲裁、初始化/APB/TRIM运行过程未覆盖 |
| MC配置 | PROFILE=1：tRC=19、tRAS=13、tRP=6、tRCD=6、tRTP=1等；open-page、bank_map=0xe4、splicing=1；刷新/BIST关闭 | 是本地明确配置；不等于远端寄存器读回，也不证明远端必有刷新干扰 |
| PHY | 接实际CAS和行列地址，7ns后产生地址对应数据与返回脉冲 | **C++行为替代**，没有运行加密PHY/阵列模型；并非实际PHY所有时序约束 |
| 时钟 | PE与256条MC通路均400MHz，MC相对PE固定300ps相位偏移，MC之间同相 | 本地确定；远端MC频率、各域相位/CDC配置未知 |
| 程序与输出 | 手工13字命令流、预填激活、三个独立L2输出区 | **不是完整zbin取指/同步/LD/VP/ST程序**；指令交接和缓冲复用范围不同 |
| 芯片拓扑 | 单核8-group、256条MC服务实例 | **未展开匹配的双核生产顶层**；不能凭“双核”推断存在共享MC争用 |
| 编译/版本 | Verilator，`FPGA/RTLSIM/USE_SPRAM_SIM_MODEL`，当前源码和原厂DW | 与远端VCS二进制、宏、参数、源码对应关系未逐项证明；同tag不自动代表同一展开网表 |

“模块来自生产RTL”只保证该模块源码来源，不保证它的端口绑定、宏分支、外部请求及运行配置与生产一致。当前最重要的已知差异集中在**完整GDG/MC包装与客户端、PHY行为、指令/输出驱动**；时钟和双核实际共享关系属于待确认项，不能说已经发现配置错误。

来源：当前台架的[lane.sv](artifacts/pec_production_tiles_x8_20261103/lane.sv)、[driver.cpp](artifacts/pec_production_tiles_x8_20261103/driver.cpp)、[build.py](artifacts/pec_production_tiles_x8_20261103/build.py)、[run.py](artifacts/pec_production_tiles_x8_20261103/run.py)。`FULL_PATHS=1`是台架选项，不代表已经包含完整芯片生产路径。

### 9.3 一块计算实际经过的流程与时刻

```text
手工命令 → 真实PEC/WL1解码
                  ↓
索引读请求 → Hub/GDG → MC读控制 → CAS → PHY替代模型
                  ↑                         ↓
             索引寄存器 ← Hub ← FIFO/ECC/GDG返回
                  ↓
values地址展开 → 同一供数返回链 → WL1整理/缓存
                                           ↓ 权重valid/ready
预填L2 → PEC/AL1 → 激活 ────────────────→ MAC
                                           ↓
                                  OL1部分和读/加/写
                                           ↓
                                  group输出 → PEC/L2
```

各级并行流水，必须追踪握手和同一请求身份，不能逐级耗时相加。当前group0第二块的实际事件如下：

| core cycle | 事件 | 解读 |
| ---: | --- | --- |
| 815 | 接受第二块索引请求 | 第一块尚未计算结束 |
| 816…849 | 索引WAIT_DAT | 34拍状态占用，不是34拍全PE停机 |
| 830 | 第一块最后有效MAC | 与索引等待重叠 |
| 849 | 索引返回握手 | 可以解除索引地址依赖 |
| 850 | 第二块第一笔values请求 | 比索引请求晚35拍 |
| 887 | 第二块首有效MAC | 首values请求到首MAC为37拍，包含多级流水 |
| 1437 | 第二块末有效MAC | 256次有效MAC分布于551拍窗口 |
| 1494 | 第三块首有效MAC | 早于第二块PEC完成 |
| 1496 | 第二块PEC完成 | 末MAC后59拍，但已与下一块重叠 |
| 2103 | 第三块PEC完成 | 完成间隔607拍 |

其它group有不同绝对起点；第8节统计确认每个group窗口形态及稳态相同。不能把group0绝对时刻当作全核同一时刻。远端861取自相邻完整N512 PE事件的**完成间隔**；不是每条事件duration，也不是有效MAC拍数。本地取PEC完成间隔，当前可比较稳定输出速率；远端observer与本地PEC完成信号的具体映射仍应在生产集成时核对。

### 9.4 512与607可以怎样解释，哪些还不能解释

每块4MiB BF16权重、2,097,152次标量MAC。若全部256条通路每MC拍接收32B且与PE同频，values容量下界为512拍；算术下界256拍。每拍全阵列有效MAC需要16KiB新权重，理想接口每拍8KiB，所以M1平均两拍才能支持一次全阵列MAC。MTK4交错输出累加链，没有增加跨输入行的权重复用。

本地实际有效MAC事件给出严格的端点核算：

```text
256次有效MAC之间共有255个间隔：252个2拍、2个15拍、1个16拍
理想首末MAC窗口：1 + 255×2 = 511拍
实际首末MAC窗口：1 + 252×2 + 2×15 + 1×16 = 551拍
长间隔额外跨度：40拍
相邻窗口空拍：56拍
稳态完成间隔：551 + 56 = 607拍
```

511是首末MAC含端点的跨度；512是values吞吐容量口径，不能混用。窗口内295拍weight-invalid中，255拍已存在于理想每两拍一次MAC的窗口，额外40拍来自三个长间隔。这里是接口事件分解，不把上游MC等待、FIFO等待、credit等待重复累加。每64次MAC边界长间隔的上游关联应继续用同一请求的CAS/返回/接收时间证明，不能由周期形状直接宣布某一级是唯一原因。

索引开启只把窗口间空拍21变为56；551拍窗口未改变。因此当前证据既支持“局部计算反馈可与供数重叠”，也证明“索引及块间交接不在512理想容量中”。**本地并未出现M1/k4因OL1反馈必然拖到861的现象。**

远端缺少相同内部事件，不能将`861−607=254`拆成MC或PHY等待。工作量折算：607拍时`512/607≈84.35%`、`256/607≈42.17%`；861拍时分别59.47%、29.73%。这些是容量/算术效率，不是测得的端口busy率。

M4 normal同样权重服务四行输入，算术工作量下界1024拍、权重下界仍512拍。因此其1177拍对应约87%算术利用率，与M1的29.73%不能直接比较后判断硬件是否异常。M4可以掩盖供数间隔，且不走同一索引分支。

### 9.5 下一步应以结构一致性和可验证事件为门槛

1. **先审计生产filelist展开及模块端口绑定。**从当前lane到完整GDG/MC包装层逐项列出缺失实例、固定端口、宏分支及其生效条件。明确哪些在纯读时也必经，哪些仅刷新/其它客户端启用才生效。优先接入可证明遗漏的必经控制；保留同一MC配置及PHY模型。没有拓扑证据，不添加假想的双核共享仲裁器。
2. **补齐归档程序的请求和结果缓冲合同。**覆盖每核8个完整tile及尾块，检查实际描述符、地址、mail依赖和输出区域复用；记录下一条命令何时可发、何时被接受。已有C/I证明VP/ST并发不是本案例限制，故不重复单纯延后VP/ST的实验。完整程序对照应针对尚未验证的取指/交接和输出缓冲条件。
3. **对新增模块记录因果事件，而非只看总cycles。**每笔记录请求有效/接受、MC接受、CAS、PHY返回、FIFO非空、Hub分量到齐、WL1送出、MAC接受和credit释放。对每个长MAC间隔找第一处偏离原台架的事件；上游未发与下游拒收分开统计，并检查重叠。累计stall值只能描述状态，不能直接相加为端到端延迟。
4. **最后校准外部环境。**只有获得可核验的初始化值、时钟及匹配PHY模型后，才称为生产环境对齐。在缺少这些信息时可以给出模型条件及解析容量上界，不能通过扫描返回延迟找到861后声称根因已定位。

通过标准是：新连接仍满足地址、数值、请求/返回/credit守恒；相同条件下新增周期可追溯到具体真实握手门控；M4作为共用路径回归。若完善包装层后仍607，也是一项明确排除结果，而不是再把254拍命名为未知模块等待。


## 10. GDG/MC包装控制与生产指令交接复查（2026-11-03）

本轮直接检查本地生产源码及B归档反汇编，并补做两个实际仲裁器的小型RTL单测。未改变生产RTL、编译器或原607拍台架，未重跑完整8-group。**结果没有发现普通纯读条件下这些被省略的仲裁模块必然产生持续空洞；不能把剩余254拍归因于“包装层没接”。**

### 10.1 生产链中实际省略了什么

源码根：`code/rtl`、`code/Zeus518/IP/ZGGX/MC_2025_09_12/rtl`。以下行号对应本轮读取的文件。

| 模块/控制 | 生产连接及源码位置 | 当前台架差异与复查结论 |
| --- | --- | --- |
| GDG读写仲裁 | `gdg/gdg_unit/gdg_unit.v:417`，AR forward pipe之后、axi2frame之前；`gdg_unit_rw_rr_arbiter.v`默认非GDG_UNIT_REW分支 | 台架保留AR forward pipe，直接构造纯读rr_data，绕过仲裁。默认分支仅AR有效时组合grant选读，不必隔拍授权。REW分支未纳入本次单测，也未确认远端宏 |
| MC ECC包装 | `mc_subsys_top/mc_subsys_top.v:199`及`ecc/mc_ecc_wrapper.v:69–72` | 生产请求valid/ready直通；包含错误地址记录FIFO，台架只有编码/解码，非完整包装。该FIFO不参与请求ready门控；不能看到FIFO就推断信用限流。ECC编译分支、错误及配置仍须对齐 |
| MC debug | `mc/mc_wrapper_aux.v:173`接`mc_frame_debug_aux`；后者`:66–74` | debug关闭时请求和返回直通；debug开启时走另一条行为路径。台架绕过此选择，不能默认远端也关闭 |
| 初始化门控 | `mc/mc_top_aux.v:3822–3832` | 当global_dram_init_en有效且初始化未完成时，功能请求valid/ready受阻；初始化完成后解除。它不是源码规定的每个tile重复初始化 |
| MC帧仲裁 | `mc/mc_top_aux.v:3835–3868`，6个输入，功能端口bit3 | 台架将frame2frame直接连frame2array，省略此仲裁。仲裁复位选择值8即功能端口；仅功能请求有效时保持该端口。其它输入为bank/csl/wl扫描、rescan、dram_init，**不是两个PE Core直接在此轮询** |
| VMC地址重映射 | `mc/mc_top_aux.v:4001`；`mc/vmc_top_aux.v:525–530` | 台架绕过生产VMC。该模块无时钟端口，valid/ready直通；开启映射可改变行列位置及后续MC时序，不能说始终无影响，但它自身没有新增寄存器拍 |
| MC timeout | `mc/mc_top_aux.v:4026`；`mc/mc_timeout_aux.v:58–61,126–128` | 请求握手直通；未触发timeout替代返回时，返回也直通。不是每笔读都额外等待timeout计数器 |
| 刷新/时序/PHY | frame2array及其外围 | 台架刷新关闭、固定时序及7ns地址驱动返回仍是条件模型，本轮没有补齐这些实际运行条件 |

生产功能读路径更准确的表示为：

```text
AR forward pipe → GDG读写仲裁 → axi2frame/credit
 → ECC包装 → debug选择 → frame2frame
 → 初始化门控 → MC帧仲裁 → VMC映射 → timeout直通/替代选择
 → frame2array → PHY
返回：PHY → frame2array → timeout → 帧仲裁返回分流
 → frame2frame → debug → ECC → GDG返回FIFO → Hub/WL1
```

这是所检查源文件连接，不是已经确认远端simv展开的网表。省略的模块既有纯组合直通，也有条件门控；不能按模块数量增加固定延迟。

额外一致性问题：MC顶层使用AXI_SLV_NUM=6，但仲裁源码的port_sel及返回解复用仍有5位常量/仅覆盖0…4的写法。本轮功能端口3可正常验证；初始化端口5及模式切换必须单独审查，不能由此宣称生产故障或将其解释成861。

### 10.2 两个真实仲裁器的动态确认

单测源码及运行脚本位于[wrapper_control_audit_20261103](artifacts/wrapper_control_audit_20261103/)。直接编译原`gdg_unit_rw_rr_arbiter`、原`z518_l2_round_robin_arbiter`、原`mc_frame_arbiter_aux`（6输入、312bit帧、266bit返回），没有复制或改写其算法。

- 仅GDG读端口及MC功能端口有效，非功能请求关闭。
- 前512拍请求连续、接收连续：512笔握手，无仲裁插泡。
- 总2048拍，后段加入确定性请求空洞和接收反压；逐拍检查输出valid、ready及地址数据。
- PASS：总1566笔接受，与直通预期相等。
- 测试覆盖当前纯读假设，不覆盖并发写、扫描/初始化、GDG_UNIT_REW宏、返回路或完整MC系统。不能将其结果称为完整包装层集成PASS。

复现：`bash code/algorithm/bjxx/artifacts/wrapper_control_audit_20261103/run.sh`。结果见同目录`run.log`。

### 10.3 归档程序的交接并不是“每条PE等待VP/ST”

读取归档`TMPDIR/torch_zeus_vcs/lm_head_m1_deferred_vp_st_20261028_r1/B/kernel.disasm.S`：

- 第81行首PE_CONV为`RecvMails[LD]`，对应前面的激活LD。
- 第103、148、187、226、265、304、343、383行共8条后续PE_CONV均为`RecvMails[]`。
- 完整块PE主要`SendMails[VP, ST]`。这是通知下游，不能反向解释成PE等待VP/ST。
- B中的输出描述符BR29/BR28对应8192/10240等交替区域，与本地三块独立输出区不同。
- 反汇编不直接证明取指始终足够，也不能替代mail计数、队列反压、缓冲复用生命周期的动态验证。

结合已完成C/I远端对照：独立结果缓冲并把VP/ST移出完整块稳态窗口后仍861，且PE开始/结束时间相同。因此**再次把VP/ST等待或原B的交替缓冲作为首要猜测，证据不足**。若继续审计交接，应关注具体IQ/CT/前解码接受条件，而非重复移动VP/ST。

### 10.4 本轮后的优先级

1. 不能继续将“缺少仲裁模块”笼统列为最可能的254拍来源。此次已在纯功能读条件下验证两个仲裁器不降低持续接受率，并静态确认debug/timeout关闭和VMC握手的直通条件。
2. 若补完整包装，应先做单MC集成，明确debug、初始化、VMC、ECC与刷新等端口绑定；保持时钟和PHY模型不变，并比较每笔接受/CAS/返回/credit。普通分支应先满足与子模块台架等价，而不是预期加入模块后自然接近861。
3. 剩余可改变持续服务的边界是实际宏/参数和时钟、映射/刷新/其它请求是否生效、PHY返回行为以及完整指令驱动。它们仍是待核对项，不是已定位根因。没有生产配置时，源码可证明条件行为，不能唯一推断远端861。
4. 目前无需用户新增文件完成上述审计。完整生产集成若报出缺失依赖，再提供准确模块及引用点；当前不需要重新编译triton_shared或切换分支。

## 11. 时钟、返回FIFO与credit连接审计（2026-11-03）

> 2026-11-03后续新增设计文档：PE/WL1/GDG资料明确标注Core/PE/AXI 500MHz、MC 400MHz，见[设计文档复核与时钟仿真](PE_DESIGN_DOC_CLOCK_REPLAY_20261103.md)。这补充了设计目标依据，仍未确认861任务的实际配置。

本轮检查现有生产RTL、MC测试环境、SDC、I任务远端归档和本地source_manifest；没有修改时序去拟合861，没有重新运行全核仿真。

### 11.1 已确认的连接与一个具体配置差异候选

`code/rtl/nddg/rtl/nddg_subsys_wrapper.v:1338–1341`将GDG的i_aclk/i_mc_clk分别接gdg_axi_clk/gdg_mc_clk，二者来自nddg_crm。`nddg_crm.v:783–822`显示：AXI取pll_div_even_or_ref_clk，MC取pll_div_odd_or_ref_clk。两支路分别经过门控、复位释放，再到GDG；`gdg_top.v:1108–1136`还包含冗余通路的独立时钟门控。门控不是固定插入若干数据等待拍，只有实际使能状态才能判断其影响。

`nddg_crm.v:574–650`两分频器来自同一PLL输出，各自可旁路、使能并选择参考时钟。`nddg_crm_reg_regs.v`的局部寄存器偏移：

| 偏移 | 内容 | 源码复位值 |
| --- | --- | --- |
| 0x28 | PLL分频输出/参考时钟选择 | 1 |
| 0x2c | odd分频参数[6:2]、bypass[1]、enable[0] | 5、0、1 |
| 0x30 | even分频参数[6:2]、bypass[1]、enable[0] | 4、0、1 |

**生产设计不是把AXI与MC直接短接成同一个时钟。**当前本地驱动则强制PE/AXI及MC均400MHz，固定300ps相位差，这是明确的建模选择。若实际选择PLL分频支路、分频4/5且未旁路，则MC/AXI频率比为4/5；这只是可核验的条件分支，不是当前远端已测值。参考时钟选择、PLL运行状态、APB初始化写入以及仿真顶层force/bypass都可能改变结果。不能将复位字段直接称为运行频率，也不能把trace core频率直接当GDG AXI频率。

例如**假设**PE与AXI均400MHz且MC为320MHz，单凭MC端每拍32B的条件容量，下界会由512 PE拍变成640 PE拍。该算例仅说明时钟换算能产生显著差异，不证明861由此造成，也不能将原607简单乘1.25得到新仿真结果。

### 11.2 credit并不是从OL1完成返回的

实际源码链如下：

```text
AXI域：rr_valid && rr_ready → outstanding加1
         ↓ 请求异步FIFO（AXI写，MC读）
MC域：frame2array/CAS/PHY返回/ECC
         ↓ 返回异步FIFO（MC写，AXI读）
AXI域：rvalid && rready → outstanding减1 → 恢复请求额度
         ↓ Hub/WL1缓存、后续MAC/OL1
```

- `gdg_axi2frame.v:65–102`：计数加1事件来自rr_hs，发生在请求FIFO入口，并非MC实际接受；rr_ready受FIFO full及flow_ctrl_halt共同控制。
- `gdg_rdata_buffer.v:37–60`：received等于返回FIFO的valid&&ready，读时钟为i_aclk；不等待MAC或OL1完成。
- `gdg_flowctrl.v:33–51`：outstanding在i_aclk域更新，阈值15。文件中部分“mc domain”注释不能替代实际时钟连接；i_mc_clk并未用于这两个计数always块。
- 若Hub/WL1下游不能接收，rready下降仍可延后credit释放。释放早于MAC，不等于与计算端反压无关。
- 不存在一条另行等待OL1、再跨域回MC的credit线。请求前向及数据返回的FIFO可见性共同构成额度占用时间。

### 11.3 本地已包含的跨时钟部分

请求和返回使用`asyn_fifo_boreg`，AW=4（16项）、PN=2。当前实际编译来源是`code/rtl/common/asyn_fifo_boreg.v`，已在最新source_manifest记录；不能因仓库另有同名文件而猜测本地使用了其它版本。

该FIFO通过`sync_cdc2_gray`→`syn_cdc2_single`同步指针，PN=2时直接使用二级同步结果，没有再串两级PN流水。empty为读指针与同步后的写指针比较。因此MC数据到达并不等于AXI域立即可见；相位和频率影响何时解除empty。

本地FPGA宏对应两级寄存器同步；所检查的518默认T28及S28分支也是两个标准单元串联。故目前没有源码证据支持“本地两级、生产必定多级”的猜测。标准单元模型时序、真实宏和版本仍需要实际构建证据。现有607结果已经包含这条GDG双向FIFO与credit机制，不能把它们作为整体遗漏重新加一遍延迟。

### 11.4 已有记录能确认什么

- I任务`remote_vcs/vcs/trace_time_alignment.json`给出cycle_period_ps=2500，即所记录core trace的400MHz时间单位；不能据此确定MC时钟。
- `vcs_status_regs.json`是核心状态/inbox等运行后快照，当前记录没有上述CRM分频及选择寄存器读回。
- 所检查的任务log、observer/对齐记录未找到能确定MC实际频率、相位及CRM初始化值的记录。
- MC交付SDC的clk_sys约束为2.5ns。它是设计约束，不是远端运行测量。
- `test/mc_env/tb/mc_tb.sv`声明period_clk=2.5，但其clk实际还有PLL连接及相关分支，不能只读取这个变量就当作生产时钟配置；该UVM环境本身也不等于远端整芯片任务。

### 11.5 下一步所需的是具体运行证据

无需继续复制整套EDA工具。若要确认上述时钟候选，需要匹配861任务的以下任一组证据：

1. 仿真顶层时钟生成/force脚本，明确PE、GDG AXI和MC的实际周期及相位；或
2. CRM运行初始化/读回，至少局部0x28/0x2c/0x30，并结合PLL、时钟门控及实际时钟源连接；这些是局部偏移，不能直接当总线绝对地址读取。

另需实际filelist/宏来确认采用哪个nddg_crm、FIFO和同步单元分支。当前已有源码足以建立上述连接事实，但不能恢复缺失的远端运行配置。若做本地4/5时钟比对照，应明确标注“源码支持的条件实验”，保留当前同频基线，不将条件结果认定为生产复现。


## 12. 文档时钟配置下M4 normal补跑（2026-11-03）

已完成400/400MHz与文档500/400MHz两组M4/N512/K4096、normal w4/c16/k1本地对照。两组PEC完成均为1817/2994/4171拍，稳态均1177拍；物理时间分别2942.5ns、2354ns。6144个输出逐位、64PE计数、4行权重复用、256MC请求/返回/credit守恒及排空全部通过，同频基线逐项复现历史结果。计算窗口内两组均缺权重0拍、缺激活133拍、有效MAC1024拍，算术效率87.00%。详细数据见[时钟对照报告第6节](PE_DESIGN_DOC_CLOCK_REPLAY_20261103.md)。

该结果与M1提频后的751拍/1502ns不同：M4物理时间随计算侧提频降低20%，M1仅降低约1%。这是各自布局与shape在当前台架的时钟敏感性结果，不代表已确认远端生产时钟或861根因。
