# 导入ZGGX后：真实MC本地仿真可行性复核

2026-10-29。用户已将同一tag下完整IP/ZGGX和design/filelist复制到本机。本轮实际检查源码、清单、工具及编译兼容性；没有修改生产RTL或解密模型。

**结论：主要MC源码和模型文件现已可用，已比此前更接近实际；当前完整MC＋PHY逐周期仿真仍未启动。剩余阻塞为DesignWare配套依赖和兼容加密模型的仿真工具，另有当前Verilator版本的语法兼容问题。没有新增完成周期/数值PASS结果。**

## 1. 新导入内容解决了什么

导入根目录：
- /DATA210/Application/liumx/code/Zeus518/IP/ZGGX
- /DATA210/Application/liumx/code/Zeus518/design/filelist

现在可找到mc_subsys_top、mc_wrapper_aux、frame2array_aux、mc_frame_arbiter_aux、初始化、BIST、配置、ECC及相应common模块；之前缺失的MC主体及主要控制依赖已补齐。

Phy模型也已找到，但它是受保护的仿真源码。存在文件不等于当前工具能够执行。

## 2. 按实际清单确定候选版本

复制来的design/filelist明确给出：
- filelist_gdg_unit.f引用filelist_mc_subsys_top.f；
- filelist_mc_subsys_top.f引用 **MC_2025_09_12/rtl**；
- filelist_sim_model.f引用该MC版本下的sedram_gen4_model，以及 **PHY/PHY_IP_20251023/verilog** 的hb_macro和phy_spine_u/d；
- filelist_mc_wrapper_aux.f另有Common_MC_IP_0623路径，不能与当前gdg_unit入口的版本混淆。

因此后续以MC_2025_09_12＋PHY_IP_20251023作为该清单指定的候选组合，而不是凭目录日期挑选9月PHY或7月MC。该清单仍不是远端861任务实际构建版本的证明。

独立MC自带测试环境又使用tb/quad/phy内的模型；运行自带测试时需保留它自己的版本关系，不能未经核对就换成顶层清单版本。

## 3. 路径和依赖审计

对filelist_mc_subsys_top.f中的49条源文件引用：
- 35条MC IP源文件可直接映射到新目录；
- 4条design/rtl/common文件由已有code/rtl/common提供候选；
- 8条DesignWare引用在MC_2025_05_30_release/common/rtl找到同名候选文件；
- 2条原始引用仍无本地候选：DW_ram_r_w_s_dff.v、DWsc_sync.v。

这些候选路径已经生成独立mc_sources.f，未改原始清单和源码。使用旧MC目录附带DW文件只用于依赖探测，不代表已经证明其版本与清单要求的Synopsys库一致。

进一步编译发现，附带DW_lod.v、DW_lzd.v引用的：
- DW_lod_function.inc
- DW_lzd_function.inc

也未找到。只复制几个DW_*.v不足以组成完整依赖。最终需要与实际工程配套的完整dw/sim_ver及include依赖，或可用的对应仿真库。

## 4. 实际执行的编译检查

|检查|结果|
|---|---|
|MC_2025_09_12的mc_subsys_top＋可用DW候选，Verilator lint|失败：缺两个DW include；另有未定宽大数常量的工具兼容报错|
|PHY_IP_20251023的hb_macro，Verilator lint|失败：不识别protected/endprotected，无法解析保护段|
|同一PHY，Icarus -tnull|失败：保护指令无法处理，随后语法错误|
|VCS/vlogan/xrun/vsim命令查找|当前PATH均未找到|

当前Verilator还对bank_scan_aux.v和mc_timeout_aux.v中的未定宽常量'h123456789abcdef报告超过32位。这是工具对源码语法处理的兼容问题，不据此判定RTL功能错误；本轮未修改源文件来消除此报错。

因此现阶段不能把整个真实MC服务接回PE并报告新的cycles。

## 5. PHY与存储模型的实际情况

顶层清单引用的10个模型文件均以protected或protected128保护段开始，包括：
- 存储模型Config-AC和CUBE各bank；
- hb_macro_bnk_230m_4s_sample；
- phy_spine_d、phy_spine_u。

不应将保护段忽略成空模块，或删除后只留下接口声明来取得“编译通过”。也不以旧版明文CUBE模型替代后称为同版生产时序。

IP自带sim/Makefile明确调用vlogan编译和vcs展开，使用UVM、APB VIP及参数覆盖。当前本地没有找到这些命令，不能保证加密文件复制过来后由现有工具直接运行。

Makefile还会根据FIXTAA选项生成不同tAA覆盖：默认RANDOM_TAA为6～7之间，另一分支为2.478；gen.txt也有tAA层级赋值。后续必须记录实际选项、单位/时标、随机种子及覆盖对象，不能沿用人为LAT4或擅自假定模型默认时序就是原任务配置。

## 6. 目前可行的推进方式

优先补齐运行环境，而非继续添加人为服务模式：
1. 定位本机可用的VCS/vlogan环境或兼容该保护格式的工具；若工具在其他机器，只能在那里执行相应编译运行，结果需明确标注运行位置。
2. 补齐匹配版本的DesignWare sim_ver/include或相应编译库。
3. 单MC采用精简testbench，尽量不依赖原UVM/APB VIP；APB初始化和MC/PHY时钟、时序寄存器仍须保留真实含义。
4. 先跑真实写入/读回、时序及错误检查，再接入完整Hub、PEC/L2/PE；DIN诊断负载关闭。
5. 原生产861任务的构建宏、时钟/MC参数、版本仍需对应。候选MC测试跑通，不直接等于复现861。

完整源码已经使这条路线具体可实施；当前不能承诺在仅有Verilator/Icarus的本地环境中执行这些加密模型。

## 7. 证据和复现

- [复核脚本](artifacts/mc_import_audit_20261029/audit.py)
- [版本选择、路径映射、工具及命令JSON](artifacts/mc_import_audit_20261029/results.json)
- [展开后的MC候选源文件清单](artifacts/mc_import_audit_20261029/mc_sources.f)
- [MC编译错误](artifacts/mc_import_audit_20261029/controller_lint.log)
- [PHY的Verilator编译日志](artifacts/mc_import_audit_20261029/phy_verilator.log)
- [PHY的Icarus编译日志](artifacts/mc_import_audit_20261029/phy_iverilog.log)
- [源文件哈希](artifacts/mc_import_audit_20261029/source_manifest.json)

audit.py保存各探测的真实返回码；脚本本身成功保存报告，不表示子编译或仿真PASS。simulation_executed=false。没有启动原Makefile，避免其在原IP目录自动创建运行目录和修改参数文件。
