# 实际MC控制器与存储模型：本地接入预检

2026-10-29。用户要求关闭额外DIN流量，使用实际MC控制器及存储时序模型进行逐周期仿真。本轮执行了依赖审计和实际模块的最小编译/展开检查。

**结果：当前源码不完整，实际MC控制器编译未通过，尚未进入逐周期运行。没有新增PE完成周期或数值PASS结果。** 此前521、686、858/857拍均仍来自LAT4/II1服务模型，不能标记为实际MC结果。

## 1. 实际调用链及缺失点

生产路径：
```text
WL1 Hub
  → gdg_unit
     → mc_ctrl_phy_wrap
        → mc_subsys_top                         缺失
        → hb_macro_bnk_230m_4s_sample           缺失
           → 存储阵列接口/模型
```

已核实：
- gdg_unit.v:560实例化mc_ctrl_phy_wrap，配置USE_MC_ECC=1、MC_SHORT_MODE=2等。
- mc_ctrl_phy_wrap.v:184实例化mc_subsys_top。
- mc_ctrl_phy_wrap.v:450在非FPGA_MC_PHY分支实例化hb_macro_bnk_230m_4s_sample。
- 本地存在mc_top_aux.v，但它不是mc_subsys_top，也没有可直接替代的完整依赖链。

对code/rtl内的.v/.sv/.vp建立模块定义索引，没有找到mc_subsys_top、mc_wrapper_aux、hb_macro_bnk_230m_4s_sample。另对code、code1、70_20_server中的相关源文件搜索，也没有找到对应定义。

## 2. 最小编译检查

|检查|工具|实际结果|
|---|---|---|
|mc_ctrl_phy_wrap实际PHY分支|Verilator lint/elaboration|失败：缺mc_subsys_top、hb_macro_bnk_230m_4s_sample|
|mc_ctrl_phy_wrap的FPGA_MC_PHY替代分支|Verilator lint/elaboration|失败：给输入rdrdy_n_array_0/1赋值被当前工具拒绝|
|现有mc_top_aux|Verilator lint/elaboration|失败：缺12类子模块|
|CUBE_HC03_TOP及双bank行为模型|Icarus -tnull|编译展开通过；尚未进行访问时序或数值运行|

没有使用黑盒、空模块或自行编写的控制器替代缺失模块，生产RTL未修改。

FPGA_MC_PHY分支即使处理工具兼容性，也仍然无mc_subsys_top定义；它内部的MODEL_RD_LATENCY=10是另一种简化bank模型，不能当作真实PHY服务已经匹配。

## 3. mc_top_aux缺失的子模块

本次最小编译直接报告：

- DW_sync
- pulse2pulse_aux
- apb2reg_mc_1short2_top_aux_cfg_if
- wl_clkgate_aux
- bist_scan_top_aux
- bist_rescan_top_aux
- mc_frame_arbiter_aux
- mc_frame2frame_aux
- dram_init_wr_aux
- mc_timeout_aux
- frame2array_aux
- vmc_top_aux

它们包含本次真正需要的帧仲裁、帧转换、阵列访问、初始化和配置功能，不能删除后继续声称完成了实际MC仿真。

## 4. 编译清单也指向外部IP

本地清单：
[MC文件清单](/DATA210/Application/liumx/code/rtl/zeus518/filelist/filelist_mc_wrapper_aux.f)

其中引用：
```text
$RTL_PATH/Zeus518/IP/ZGGX/MC_2025_05_30_release/...
/Tool/EDA/synopsys/syn/U-2022.12/dw/sim_ver/...
```

当前RTL_PATH未设置，46条源文件引用按现有环境均无法解析到文件。进一步在本地RTL按basename查找，仅找到其中mc_top_aux.v的一个候选副本，其余未找到。

因此问题不只是把RTL_PATH指向当前code/rtl：所需IP源文件本身并不齐全。现有mc_top_aux副本位于mc_0718_fixed，清单引用另一个release；版本也需要核对，不能直接混用。

本地存在PHY的.lib/.db文件，但没有相应行为模型的Verilog定义，不能将时序库文件当作可执行的存储仿真模型。

## 5. 已有CUBE模型能做什么

本地有：
- CUBE_HC03_TOP.v
- CUBE_HC03.v
- CUBE_HC03_BK0.v / CUBE_HC03_BK1.v
- Config-AC.v

模型包含按物理时间检查的tRAS、tRC、tRCD、tRP、tCCD等约束。它可作为存储侧行为模型候选，并已通过独立编译展开。

但它不能替代缺失的MC控制器：
- 模型接收bank/行列地址/读写控制，不能直接接Hub的读请求。
- 控制器必须生成合法访问时序，并处理请求、数据及返回路径。
- 还须确认CUBE版本与生产PHY/MC配置匹配；本次没有这项版本对应证据。
- 编译展开成功不代表经过真实访问的时序检查或数值测试。

没有为了产生新的cycles而绕过MC，直接用人为控制序列驱动CUBE。

## 6. 继续所需的具体材料

需要完整、相互匹配的一组内容：
1. mc_subsys_top及其传递依赖，或远端实际使用的完整MC release/编译库。
2. hb_macro_bnk_230m_4s_sample对应的仿真模型，或明确确认可使用本地CUBE的适配及版本。
3. 配套MC编译清单、必要仿真库和宏定义。
4. 生产MC的APB初始化、时序寄存器设置、page/short模式、刷新/ECC配置及PE/MC时钟关系。

第一、二项的源码/工程目录是当前明确阻塞。取得后先完成单MC真实写入/读取和时序检查，再接回完整Hub及现有PEC/L2/PE；关闭诊断DIN，保留原权重和1536个FP32回读门控，逐级观察请求接受、阵列命令、数据返回和MAC接收。

## 7. 复现与原始证据

预检脚本在实际MC无法展开时返回2；这个返回码明确表示依赖不完整，不是仿真PASS。

- [预检脚本](artifacts/mc_service_preflight_20261029/preflight.py)
- [模块/文件依赖与编译命令JSON](artifacts/mc_service_preflight_20261029/results.json)
- [实际PHY分支编译日志](artifacts/mc_service_preflight_20261029/actual_phy.log)
- [FPGA bank替代分支日志](artifacts/mc_service_preflight_20261029/fpga_bank_alternative.log)
- [mc_top_aux编译日志](artifacts/mc_service_preflight_20261029/aux_controller.log)
- [CUBE独立展开日志](artifacts/mc_service_preflight_20261029/cube_elaboration.log)
- [预检摘要](artifacts/mc_service_preflight_20261029/preflight_summary.log)
- [源文件SHA256](artifacts/mc_service_preflight_20261029/source_manifest.json)

执行：
```bash
python3 /DATA210/Application/liumx/code/algorithm/bjxx/artifacts/mc_service_preflight_20261029/preflight.py
```

本轮准确状态是“实际MC依赖验证失败，等待完整IP/模型路径”，不是“实际MC逐周期仿真已经完成”。


## 2026-10-29：ZGGX及顶层清单已导入后的状态

主要MC源码和PHY模型已复制到本机；顶层清单指定MC_2025_09_12＋PHY_IP_20251023。此前“MC主体源码缺失”的阻塞已解除，当前实际编译仍被DesignWare配套缺失、加密模型工具支持和Verilator语法兼容阻塞，没有新增实际MC周期结果。详见[导入后可行性复核及编译日志](PE_MC_IMPORT_AUDIT_20261029.md)。
