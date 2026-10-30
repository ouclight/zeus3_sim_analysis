module apb2reg_mc_1short1_top_aux_cfg_if #(
    parameter APB_ADDR_WIDTH = 11,
    parameter APB_DATA_WIDTH = 32
    )
    (
    // common input ports 
    input                               pclk,
    input                               presetn,
    input                               psel,
    input                               penable,
    input    [APB_ADDR_WIDTH-1:0]       paddr,
    input                               pwrite,
    input    [APB_DATA_WIDTH-1:0]       pwdata,
    output                              pready,

    // special input port 
    // register name : mc_id_reg , address:0x0
    input  [31:0]                        mc_id_i,// read only signal
    // register name : err_wl0_1_bank0_reg , address:0xb0
    input  [12:0]                        err_wl0_bank0_i,// read only signal
    input  [12:0]                        err_wl1_bank0_i,// read only signal
    // register name : err_wl2_3_bank0_reg , address:0xb4
    input  [12:0]                        err_wl2_bank0_i,// read only signal
    input  [12:0]                        err_wl3_bank0_i,// read only signal
    // register name : err_wl4_5_bank0_reg , address:0xb8
    input  [12:0]                        err_wl4_bank0_i,// read only signal
    input  [12:0]                        err_wl5_bank0_i,// read only signal
    // register name : err_wl6_7_bank0_reg , address:0xbc
    input  [12:0]                        err_wl6_bank0_i,// read only signal
    input  [12:0]                        err_wl7_bank0_i,// read only signal
    // register name : err_wl8_9_bank0_reg , address:0xc0
    input  [12:0]                        err_wl8_bank0_i,// read only signal
    input  [12:0]                        err_wl9_bank0_i,// read only signal
    // register name : err_wl10_11_bank0_reg , address:0xc4
    input  [12:0]                        err_wl10_bank0_i,// read only signal
    input  [12:0]                        err_wl11_bank0_i,// read only signal
    // register name : err_wl12_13_bank0_reg , address:0xc8
    input  [12:0]                        err_wl12_bank0_i,// read only signal
    input  [12:0]                        err_wl13_bank0_i,// read only signal
    // register name : err_wl14_15_bank0_reg , address:0xcc
    input  [12:0]                        err_wl14_bank0_i,// read only signal
    input  [12:0]                        err_wl15_bank0_i,// read only signal
    // register name : err_wl16_17_bank0_reg , address:0xd0
    input  [12:0]                        err_wl16_bank0_i,// read only signal
    input  [12:0]                        err_wl17_bank0_i,// read only signal
    // register name : err_wl18_19_bank0_reg , address:0xd4
    input  [12:0]                        err_wl18_bank0_i,// read only signal
    input  [12:0]                        err_wl19_bank0_i,// read only signal
    // register name : err_wl20_21_bank0_reg , address:0xd8
    input  [12:0]                        err_wl20_bank0_i,// read only signal
    input  [12:0]                        err_wl21_bank0_i,// read only signal
    // register name : err_wl22_23_bank0_reg , address:0xdc
    input  [12:0]                        err_wl22_bank0_i,// read only signal
    input  [12:0]                        err_wl23_bank0_i,// read only signal
    // register name : err_wl24_25_bank0_reg , address:0xe0
    input  [12:0]                        err_wl24_bank0_i,// read only signal
    input  [12:0]                        err_wl25_bank0_i,// read only signal
    // register name : err_wl26_27_bank0_reg , address:0xe4
    input  [12:0]                        err_wl26_bank0_i,// read only signal
    input  [12:0]                        err_wl27_bank0_i,// read only signal
    // register name : err_wl28_29_bank0_reg , address:0xe8
    input  [12:0]                        err_wl28_bank0_i,// read only signal
    input  [12:0]                        err_wl29_bank0_i,// read only signal
    // register name : err_wl30_31_bank0_reg , address:0xec
    input  [12:0]                        err_wl30_bank0_i,// read only signal
    input  [12:0]                        err_wl31_bank0_i,// read only signal
    // register name : err_wl32_33_bank0_reg , address:0xf0
    input  [12:0]                        err_wl32_bank0_i,// read only signal
    input  [12:0]                        err_wl33_bank0_i,// read only signal
    // register name : err_wl34_35_bank0_reg , address:0xf4
    input  [12:0]                        err_wl34_bank0_i,// read only signal
    input  [12:0]                        err_wl35_bank0_i,// read only signal
    // register name : err_wl36_37_bank0_reg , address:0xf8
    input  [12:0]                        err_wl36_bank0_i,// read only signal
    input  [12:0]                        err_wl37_bank0_i,// read only signal
    // register name : err_wl38_39_bank0_reg , address:0xfc
    input  [12:0]                        err_wl38_bank0_i,// read only signal
    input  [12:0]                        err_wl39_bank0_i,// read only signal
    // register name : err_wl40_41_bank0_reg , address:0x100
    input  [12:0]                        err_wl40_bank0_i,// read only signal
    input  [12:0]                        err_wl41_bank0_i,// read only signal
    // register name : err_wl42_43_bank0_reg , address:0x104
    input  [12:0]                        err_wl42_bank0_i,// read only signal
    input  [12:0]                        err_wl43_bank0_i,// read only signal
    // register name : err_wl44_45_bank0_reg , address:0x108
    input  [12:0]                        err_wl44_bank0_i,// read only signal
    input  [12:0]                        err_wl45_bank0_i,// read only signal
    // register name : err_wl46_47_bank0_reg , address:0x10c
    input  [12:0]                        err_wl46_bank0_i,// read only signal
    input  [12:0]                        err_wl47_bank0_i,// read only signal
    // register name : err_wl48_49_bank0_reg , address:0x110
    input  [12:0]                        err_wl48_bank0_i,// read only signal
    input  [12:0]                        err_wl49_bank0_i,// read only signal
    // register name : err_wl50_51_bank0_reg , address:0x114
    input  [12:0]                        err_wl50_bank0_i,// read only signal
    input  [12:0]                        err_wl51_bank0_i,// read only signal
    // register name : err_wl52_53_bank0_reg , address:0x118
    input  [12:0]                        err_wl52_bank0_i,// read only signal
    input  [12:0]                        err_wl53_bank0_i,// read only signal
    // register name : err_wl54_55_bank0_reg , address:0x11c
    input  [12:0]                        err_wl54_bank0_i,// read only signal
    input  [12:0]                        err_wl55_bank0_i,// read only signal
    // register name : err_wl56_57_bank0_reg , address:0x120
    input  [12:0]                        err_wl56_bank0_i,// read only signal
    input  [12:0]                        err_wl57_bank0_i,// read only signal
    // register name : err_wl58_59_bank0_reg , address:0x124
    input  [12:0]                        err_wl58_bank0_i,// read only signal
    input  [12:0]                        err_wl59_bank0_i,// read only signal
    // register name : err_wl60_61_bank0_reg , address:0x128
    input  [12:0]                        err_wl60_bank0_i,// read only signal
    input  [12:0]                        err_wl61_bank0_i,// read only signal
    // register name : err_wl62_63_bank0_reg , address:0x12c
    input  [12:0]                        err_wl62_bank0_i,// read only signal
    input  [12:0]                        err_wl63_bank0_i,// read only signal
    // register name : err_csl_part0_1_bank0_reg , address:0x130
    input  [7:0]                        err_csl0_part0_bank0_i,// read only signal
    input  [7:0]                        err_csl1_part0_bank0_i,// read only signal
    input  [7:0]                        err_csl0_part1_bank0_i,// read only signal
    input  [7:0]                        err_csl1_part1_bank0_i,// read only signal
    // register name : err_csl_part2_3_bank0_reg , address:0x134
    input  [7:0]                        err_csl0_part2_bank0_i,// read only signal
    input  [7:0]                        err_csl1_part2_bank0_i,// read only signal
    input  [7:0]                        err_csl0_part3_bank0_i,// read only signal
    input  [7:0]                        err_csl1_part3_bank0_i,// read only signal
    // register name : err_csl_part4_5_bank0_reg , address:0x138
    input  [7:0]                        err_csl0_part4_bank0_i,// read only signal
    input  [7:0]                        err_csl1_part4_bank0_i,// read only signal
    input  [7:0]                        err_csl0_part5_bank0_i,// read only signal
    input  [7:0]                        err_csl1_part5_bank0_i,// read only signal
    // register name : err_csl_part6_7_bank0_reg , address:0x13c
    input  [7:0]                        err_csl0_part6_bank0_i,// read only signal
    input  [7:0]                        err_csl1_part6_bank0_i,// read only signal
    input  [7:0]                        err_csl0_part7_bank0_i,// read only signal
    input  [7:0]                        err_csl1_part7_bank0_i,// read only signal
    // register name : err_csl_part8_9_bank0_reg , address:0x140
    input  [7:0]                        err_csl0_part8_bank0_i,// read only signal
    input  [7:0]                        err_csl1_part8_bank0_i,// read only signal
    input  [7:0]                        err_csl0_part9_bank0_i,// read only signal
    input  [7:0]                        err_csl1_part9_bank0_i,// read only signal
    // register name : mc_rf_start_dbg_reg , address:0x14c
    input                        mc_rf_start_dbg_i,// read only signal
    // register name : mc_timeout_flag_reg , address:0x150
    input                        mc_timeout_flag_i,// read only signal
    // register name : mc_bist_status_reg , address:0x154
    input  [2:0]                        mc_bist_status_i,// read only signal
    input                        mc_bist_path_fail_bank0_i,// read only signal
    input                        dram_init_finish_i,// read only signal
    // register name : bist_finish_and_success_reg , address:0x158
    input                        bist_finish_bank0_i,// read only signal
    input                        bist_rescan_finish_bank0_i,// read only signal
    input                        bank_success_bank0_i,// read only signal
    input                        bist_rescan_success_bank0_i,// read only signal
    // register name : mc_bist_rescan_fail_num_bank0_reg , address:0x15c
    input  [19:0]                        mc_bist_rescan_fail_num_bank0_i,// read only signal
    // register name : mc_bist_err_wl_reg , address:0x16c
    input  [6:0]                        mc_bist_err_wl_num_bank0_i,// read only signal
    input                        err_wl_num_change_flag_bank0_i,// read only signal
    // register name : rescan_round_result_1_reg , address:0x178
    input  [14:0]                        rescan_round_result_bank0_i,// read only signal
    // register name : mc_frame2array_dbg_reg , address:0x1b4
    input  [4:0]                        dbg_next_state_array_i,// read only signal
    input  [4:0]                        dbg_current_state_array_i,// read only signal
    input  [1:0]                        dbg_r_data_cnt_i,// read only signal
    input                        dbg_refresh_flag_i,// read only signal
    input  [1:0]                        dbg_r_frame_cnt_i,// read only signal
    input  [1:0]                        dbg_w_frame_cnt_i,// read only signal
    // register name : dbg_frame_store_0_reg , address:0x1b8
    input  [31:0]                        dbg_frame_store_0_i,// read only signal
    // register name : dbg_frame_store_1_reg , address:0x1bc
    input  [31:0]                        dbg_frame_store_1_i,// read only signal
    // register name : dbg_frame_store_2_reg , address:0x1c0
    input  [31:0]                        dbg_frame_store_2_i,// read only signal
    // register name : dbg_frame_store_3_reg , address:0x1c4
    input  [31:0]                        dbg_frame_store_3_i,// read only signal
    // register name : dbg_frame_store_4_reg , address:0x1c8
    input  [31:0]                        dbg_frame_store_4_i,// read only signal
    // register name : dbg_frame_store_5_reg , address:0x1cc
    input  [31:0]                        dbg_frame_store_5_i,// read only signal
    // register name : dbg_frame_store_6_reg , address:0x1d0
    input  [31:0]                        dbg_frame_store_6_i,// read only signal
    // register name : dbg_frame_store_7_reg , address:0x1d4
    input  [31:0]                        dbg_frame_store_7_i,// read only signal
    // register name : dbg_frame_store_8_reg , address:0x1d8
    input  [31:0]                        dbg_frame_store_8_i,// read only signal
    // register name : dbg_frame_store_9_reg , address:0x1dc
    input  [1:0]                        dbg_frame_store_9_i,// read only signal
    // register name : dbg_rdata_store_0_reg , address:0x1e0
    input  [31:0]                        dbg_rdata_store_0_i,// read only signal
    // register name : dbg_rdata_store_1_reg , address:0x1e4
    input  [31:0]                        dbg_rdata_store_1_i,// read only signal
    // register name : dbg_rdata_store_2_reg , address:0x1e8
    input  [31:0]                        dbg_rdata_store_2_i,// read only signal
    // register name : dbg_rdata_store_3_reg , address:0x1ec
    input  [31:0]                        dbg_rdata_store_3_i,// read only signal
    // register name : dbg_rdata_store_4_reg , address:0x1f0
    input  [31:0]                        dbg_rdata_store_4_i,// read only signal
    // register name : dbg_rdata_store_5_reg , address:0x1f4
    input  [31:0]                        dbg_rdata_store_5_i,// read only signal
    // register name : dbg_rdata_store_6_reg , address:0x1f8
    input  [31:0]                        dbg_rdata_store_6_i,// read only signal
    // register name : dbg_rdata_store_7_reg , address:0x1fc
    input  [31:0]                        dbg_rdata_store_7_i,// read only signal
    // register name : dbg_rdata_store_8_reg , address:0x200
    input  [9:0]                        dbg_rdata_store_8_i,// read only signal
    // register name : mc_ecc_ce_ctrl_reg , address:0x204
    input                        mc_ecc_ce_overflow_int_i,// read only signal
    input  [4:0]                        mc_ecc_ce_cnt_i,// read only signal
    // register name : mc_ecc_ce_addr0_reg , address:0x208
    input  [21:0]                        mc_ecc_ce_addr0_i,// read only signal
    input                        mc_ecc_ce_addr_vld0_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt0_i,// read only signal
    // register name : mc_ecc_ce_addr1_reg , address:0x20c
    input  [21:0]                        mc_ecc_ce_addr1_i,// read only signal
    input                        mc_ecc_ce_addr_vld1_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt1_i,// read only signal
    // register name : mc_ecc_ce_addr2_reg , address:0x210
    input  [21:0]                        mc_ecc_ce_addr2_i,// read only signal
    input                        mc_ecc_ce_addr_vld2_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt2_i,// read only signal
    // register name : mc_ecc_ce_addr3_reg , address:0x214
    input  [21:0]                        mc_ecc_ce_addr3_i,// read only signal
    input                        mc_ecc_ce_addr_vld3_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt3_i,// read only signal
    // register name : mc_ecc_ce_addr4_reg , address:0x218
    input  [21:0]                        mc_ecc_ce_addr4_i,// read only signal
    input                        mc_ecc_ce_addr_vld4_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt4_i,// read only signal
    // register name : mc_ecc_ce_addr5_reg , address:0x21c
    input  [21:0]                        mc_ecc_ce_addr5_i,// read only signal
    input                        mc_ecc_ce_addr_vld5_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt5_i,// read only signal
    // register name : mc_ecc_ce_addr6_reg , address:0x220
    input  [21:0]                        mc_ecc_ce_addr6_i,// read only signal
    input                        mc_ecc_ce_addr_vld6_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt6_i,// read only signal
    // register name : mc_ecc_ce_addr7_reg , address:0x224
    input  [21:0]                        mc_ecc_ce_addr7_i,// read only signal
    input                        mc_ecc_ce_addr_vld7_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt7_i,// read only signal
    // register name : mc_ecc_ce_addr8_reg , address:0x228
    input  [21:0]                        mc_ecc_ce_addr8_i,// read only signal
    input                        mc_ecc_ce_addr_vld8_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt8_i,// read only signal
    // register name : mc_ecc_ce_addr9_reg , address:0x22c
    input  [21:0]                        mc_ecc_ce_addr9_i,// read only signal
    input                        mc_ecc_ce_addr_vld9_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt9_i,// read only signal
    // register name : mc_ecc_ce_addr10_reg , address:0x230
    input  [21:0]                        mc_ecc_ce_addr10_i,// read only signal
    input                        mc_ecc_ce_addr_vld10_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt10_i,// read only signal
    // register name : mc_ecc_ce_addr11_reg , address:0x234
    input  [21:0]                        mc_ecc_ce_addr11_i,// read only signal
    input                        mc_ecc_ce_addr_vld11_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt11_i,// read only signal
    // register name : mc_ecc_ce_addr12_reg , address:0x238
    input  [21:0]                        mc_ecc_ce_addr12_i,// read only signal
    input                        mc_ecc_ce_addr_vld12_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt12_i,// read only signal
    // register name : mc_ecc_ce_addr13_reg , address:0x23c
    input  [21:0]                        mc_ecc_ce_addr13_i,// read only signal
    input                        mc_ecc_ce_addr_vld13_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt13_i,// read only signal
    // register name : mc_ecc_ce_addr14_reg , address:0x240
    input  [21:0]                        mc_ecc_ce_addr14_i,// read only signal
    input                        mc_ecc_ce_addr_vld14_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt14_i,// read only signal
    // register name : mc_ecc_ce_addr15_reg , address:0x244
    input  [21:0]                        mc_ecc_ce_addr15_i,// read only signal
    input                        mc_ecc_ce_addr_vld15_i,// read only signal
    input  [7:0]                        mc_ecc_ce_addr_cnt15_i,// read only signal
    // register name : mc_ecc_uce_ctrl_reg , address:0x248
    input                        mc_ecc_uce_int_i,// read only signal
    input  [2:0]                        mc_ecc_uce_cnt_i,// read only signal
    // register name : mc_ecc_uce_addr0_reg , address:0x24c
    input  [21:0]                        mc_ecc_uce_addr0_i,// read only signal
    input                        mc_ecc_uce_addr_vld0_i,// read only signal
    // register name : mc_ecc_uce_addr1_reg , address:0x250
    input  [21:0]                        mc_ecc_uce_addr1_i,// read only signal
    input                        mc_ecc_uce_addr_vld1_i,// read only signal
    // register name : mc_ecc_uce_addr2_reg , address:0x254
    input  [21:0]                        mc_ecc_uce_addr2_i,// read only signal
    input                        mc_ecc_uce_addr_vld2_i,// read only signal
    // register name : mc_ecc_uce_addr3_reg , address:0x258
    input  [21:0]                        mc_ecc_uce_addr3_i,// read only signal
    input                        mc_ecc_uce_addr_vld3_i,// read only signal
    // register name : mc_page_status_reg , address:0x25c
    input                        mc_page_status_i,// read only signal
    // register name : hang_timeout_status_reg , address:0x260
    input                        hang_timeout_status_i,// read only signal
    // register name : bist_clk_cnt_reg , address:0x270
    input  [31:0]                        bist_clk_cnt_i,// read only signal
 
    // W1C output ports
    // register name : mc_timeout_clr_reg , address:0x148
    output reg mc_timeout_clr_o,
    // register name : rescan_finish_clr_reg , address:0x170
    output reg rescan_finish_clr_o,
    // register name : bist_finish_clr_reg , address:0x180
    output reg bist_finish_clr_o,
    // register name : mc_ecc_ce_ctrl_reg , address:0x204
    output reg mc_ecc_ce_int_clr_o,
    // register name : mc_ecc_uce_ctrl_reg , address:0x248
    output reg mc_ecc_uce_int_clr_o,
    // register name : hang_timeout_clr_reg , address:0x268
    output reg hang_timeout_clr_o,

    // special output ports
    // register name : mc_work_ctrl_reg , address:0x4
    output reg mc_en_o,
    output reg mc_rf_cfg_sel_o,
    output reg mc_debug_en_o,
    output reg mc_wl_vmc_en_o,
    output reg mc_bl_vmc_en_o,
    output reg mc_bist_en_o,
    output reg mc_rescan_addr_range_sel_o,
    output reg mc_csl_scan_addr_range_sel_o,
    output reg mc_csl_scan_check_sel_o,
    output reg mc_csl_scan_mode_sel_o,
    output reg mc_rdata_invert_sel_o,
    output reg mc_rdrdy_n_en_o,
    output reg mc_rf_en_o,
    output reg mc_rf_burst_split_en_o,
    output reg mc_fake_bresp_en_o,
    output reg mc_ecc_en_o,
    output reg mc_all_bank_act_en_o,
    output reg mc2phy_dram0_mask_o,
    output reg mc2phy_dram1_mask_o,
    output reg mc2phy_dram2_mask_o,
    output reg mc2phy_dram3_mask_o,
    // register name : phy_timing_cfg0_reg , address:0x8
    output reg [7:0] bank_radd_set_time_o,
    output reg [3:0] cadd_set_time_o,
    output reg [7:0] r_cas_set_time_o,
    output reg [7:0] w_cas_set_time_o,
    // register name : mc_rf_period_cfg1_reg , address:0xc
    output reg [31:0] mc_rf_period_1_o,
    // register name : mc_rf_start_cfg1_reg , address:0x10
    output reg [31:0] mc_rf_start_1_o,
    // register name : mc_rf_period_cfg2_reg , address:0x14
    output reg [31:0] mc_rf_period_2_o,
    // register name : mc_rf_start_cfg2_reg , address:0x18
    output reg [31:0] mc_rf_start_2_o,
    // register name : mc_vmc_wl_num0_1_bank0_reg , address:0x1c
    output reg [12:0] mc_vmc_wl_num0_bank0_o,
    output reg [12:0] mc_vmc_wl_num1_bank0_o,
    // register name : mc_vmc_wl_num2_3_bank0_reg , address:0x20
    output reg [12:0] mc_vmc_wl_num2_bank0_o,
    output reg [12:0] mc_vmc_wl_num3_bank0_o,
    // register name : mc_vmc_wl_num4_5_bank0_reg , address:0x24
    output reg [12:0] mc_vmc_wl_num4_bank0_o,
    output reg [12:0] mc_vmc_wl_num5_bank0_o,
    // register name : mc_vmc_wl_num6_7_bank0_reg , address:0x28
    output reg [12:0] mc_vmc_wl_num6_bank0_o,
    output reg [12:0] mc_vmc_wl_num7_bank0_o,
    // register name : mc_vmc_wl_num8_9_bank0_reg , address:0x2c
    output reg [12:0] mc_vmc_wl_num8_bank0_o,
    output reg [12:0] mc_vmc_wl_num9_bank0_o,
    // register name : mc_vmc_wl_num10_11_bank0_reg , address:0x30
    output reg [12:0] mc_vmc_wl_num10_bank0_o,
    output reg [12:0] mc_vmc_wl_num11_bank0_o,
    // register name : mc_vmc_wl_num12_13_bank0_reg , address:0x34
    output reg [12:0] mc_vmc_wl_num12_bank0_o,
    output reg [12:0] mc_vmc_wl_num13_bank0_o,
    // register name : mc_vmc_wl_num14_15_bank0_reg , address:0x38
    output reg [12:0] mc_vmc_wl_num14_bank0_o,
    output reg [12:0] mc_vmc_wl_num15_bank0_o,
    // register name : mc_vmc_wl_num16_17_bank0_reg , address:0x3c
    output reg [12:0] mc_vmc_wl_num16_bank0_o,
    output reg [12:0] mc_vmc_wl_num17_bank0_o,
    // register name : mc_vmc_wl_num18_19_bank0_reg , address:0x40
    output reg [12:0] mc_vmc_wl_num18_bank0_o,
    output reg [12:0] mc_vmc_wl_num19_bank0_o,
    // register name : mc_vmc_wl_num20_21_bank0_reg , address:0x44
    output reg [12:0] mc_vmc_wl_num20_bank0_o,
    output reg [12:0] mc_vmc_wl_num21_bank0_o,
    // register name : mc_vmc_wl_num22_23_bank0_reg , address:0x48
    output reg [12:0] mc_vmc_wl_num22_bank0_o,
    output reg [12:0] mc_vmc_wl_num23_bank0_o,
    // register name : mc_vmc_wl_num24_25_bank0_reg , address:0x4c
    output reg [12:0] mc_vmc_wl_num24_bank0_o,
    output reg [12:0] mc_vmc_wl_num25_bank0_o,
    // register name : mc_vmc_wl_num26_27_bank0_reg , address:0x50
    output reg [12:0] mc_vmc_wl_num26_bank0_o,
    output reg [12:0] mc_vmc_wl_num27_bank0_o,
    // register name : mc_vmc_wl_num28_29_bank0_reg , address:0x54
    output reg [12:0] mc_vmc_wl_num28_bank0_o,
    output reg [12:0] mc_vmc_wl_num29_bank0_o,
    // register name : mc_vmc_wl_num30_31_bank0_reg , address:0x58
    output reg [12:0] mc_vmc_wl_num30_bank0_o,
    output reg [12:0] mc_vmc_wl_num31_bank0_o,
    // register name : mc_vmc_wl_num32_33_bank0_reg , address:0x5c
    output reg [12:0] mc_vmc_wl_num32_bank0_o,
    output reg [12:0] mc_vmc_wl_num33_bank0_o,
    // register name : mc_vmc_wl_num34_35_bank0_reg , address:0x60
    output reg [12:0] mc_vmc_wl_num34_bank0_o,
    output reg [12:0] mc_vmc_wl_num35_bank0_o,
    // register name : mc_vmc_wl_num36_37_bank0_reg , address:0x64
    output reg [12:0] mc_vmc_wl_num36_bank0_o,
    output reg [12:0] mc_vmc_wl_num37_bank0_o,
    // register name : mc_vmc_wl_num38_39_bank0_reg , address:0x68
    output reg [12:0] mc_vmc_wl_num38_bank0_o,
    output reg [12:0] mc_vmc_wl_num39_bank0_o,
    // register name : mc_vmc_wl_num40_41_bank0_reg , address:0x6c
    output reg [12:0] mc_vmc_wl_num40_bank0_o,
    output reg [12:0] mc_vmc_wl_num41_bank0_o,
    // register name : mc_vmc_wl_num42_43_bank0_reg , address:0x70
    output reg [12:0] mc_vmc_wl_num42_bank0_o,
    output reg [12:0] mc_vmc_wl_num43_bank0_o,
    // register name : mc_vmc_wl_num44_45_bank0_reg , address:0x74
    output reg [12:0] mc_vmc_wl_num44_bank0_o,
    output reg [12:0] mc_vmc_wl_num45_bank0_o,
    // register name : mc_vmc_wl_num46_47_bank0_reg , address:0x78
    output reg [12:0] mc_vmc_wl_num46_bank0_o,
    output reg [12:0] mc_vmc_wl_num47_bank0_o,
    // register name : mc_vmc_wl_num48_49_bank0_reg , address:0x7c
    output reg [12:0] mc_vmc_wl_num48_bank0_o,
    output reg [12:0] mc_vmc_wl_num49_bank0_o,
    // register name : mc_vmc_wl_num50_51_bank0_reg , address:0x80
    output reg [12:0] mc_vmc_wl_num50_bank0_o,
    output reg [12:0] mc_vmc_wl_num51_bank0_o,
    // register name : mc_vmc_wl_num52_53_bank0_reg , address:0x84
    output reg [12:0] mc_vmc_wl_num52_bank0_o,
    output reg [12:0] mc_vmc_wl_num53_bank0_o,
    // register name : mc_vmc_wl_num54_55_bank0_reg , address:0x88
    output reg [12:0] mc_vmc_wl_num54_bank0_o,
    output reg [12:0] mc_vmc_wl_num55_bank0_o,
    // register name : mc_vmc_wl_num56_57_bank0_reg , address:0x8c
    output reg [12:0] mc_vmc_wl_num56_bank0_o,
    output reg [12:0] mc_vmc_wl_num57_bank0_o,
    // register name : mc_vmc_wl_num58_59_bank0_reg , address:0x90
    output reg [12:0] mc_vmc_wl_num58_bank0_o,
    output reg [12:0] mc_vmc_wl_num59_bank0_o,
    // register name : mc_vmc_wl_num60_61_bank0_reg , address:0x94
    output reg [12:0] mc_vmc_wl_num60_bank0_o,
    output reg [12:0] mc_vmc_wl_num61_bank0_o,
    // register name : mc_vmc_wl_num62_63_bank0_reg , address:0x98
    output reg [12:0] mc_vmc_wl_num62_bank0_o,
    output reg [12:0] mc_vmc_wl_num63_bank0_o,
    // register name : mc_vmc_bl_num0_part0_1_bank0_reg , address:0x9c
    output reg [7:0] mc_vmc_bl_num0_part0_bank0_o,
    output reg [7:0] mc_vmc_bl_num1_part0_bank0_o,
    output reg [7:0] mc_vmc_bl_num0_part1_bank0_o,
    output reg [7:0] mc_vmc_bl_num1_part1_bank0_o,
    // register name : mc_vmc_bl_num0_part2_3_bank0_reg , address:0xa0
    output reg [7:0] mc_vmc_bl_num0_part2_bank0_o,
    output reg [7:0] mc_vmc_bl_num1_part2_bank0_o,
    output reg [7:0] mc_vmc_bl_num0_part3_bank0_o,
    output reg [7:0] mc_vmc_bl_num1_part3_bank0_o,
    // register name : mc_vmc_bl_num0_part4_5_bank0_reg , address:0xa4
    output reg [7:0] mc_vmc_bl_num0_part4_bank0_o,
    output reg [7:0] mc_vmc_bl_num1_part4_bank0_o,
    output reg [7:0] mc_vmc_bl_num0_part5_bank0_o,
    output reg [7:0] mc_vmc_bl_num1_part5_bank0_o,
    // register name : mc_vmc_bl_num0_part6_7_bank0_reg , address:0xa8
    output reg [7:0] mc_vmc_bl_num0_part6_bank0_o,
    output reg [7:0] mc_vmc_bl_num1_part6_bank0_o,
    output reg [7:0] mc_vmc_bl_num0_part7_bank0_o,
    output reg [7:0] mc_vmc_bl_num1_part7_bank0_o,
    // register name : mc_vmc_bl_num0_part8_9_bank0_reg , address:0xac
    output reg [7:0] mc_vmc_bl_num0_part8_bank0_o,
    output reg [7:0] mc_vmc_bl_num1_part8_bank0_o,
    output reg [7:0] mc_vmc_bl_num0_part9_bank0_o,
    output reg [7:0] mc_vmc_bl_num1_part9_bank0_o,
    // register name : mc_bank_cfg_reg_reg , address:0x144
    output reg [7:0] mc_bank_map_id_o,
    output reg [3:0] mc_bist_grant_o,
    // register name : rescan_finish_mask_reg , address:0x174
    output reg rescan_finish_mask_o,
    // register name : bist_finish_mask_reg , address:0x184
    output reg bist_finish_mask_o,
    // register name : hang_timeout_th_reg , address:0x188
    output reg [31:0] hang_timeout_th_o,
    // register name : bist_pattern_reg0_reg , address:0x18c
    output reg [31:0] bist_pattern_reg0_o,
    // register name : bist_pattern_reg1_reg , address:0x190
    output reg [31:0] bist_pattern_reg1_o,
    // register name : bist_pattern_reg2_reg , address:0x194
    output reg [31:0] bist_pattern_reg2_o,
    // register name : bist_pattern_reg3_reg , address:0x198
    output reg [31:0] bist_pattern_reg3_o,
    // register name : csl_bist_pattern_sel0_reg , address:0x19c
    output reg [31:0] csl_bist_pattern_sel0_o,
    // register name : csl_bist_pattern_sel1_reg , address:0x1a0
    output reg [31:0] csl_bist_pattern_sel1_o,
    // register name : csl_bist_pattern_sel2_reg , address:0x1a4
    output reg [3:0] csl_bist_pattern_sel2_o,
    // register name : wl_bist_pattern_sel0_reg , address:0x1a8
    output reg [31:0] wl_bist_pattern_sel0_o,
    // register name : wl_bist_pattern_sel1_reg , address:0x1ac
    output reg [31:0] wl_bist_pattern_sel1_o,
    // register name : wl_bist_pattern_sel2_reg , address:0x1b0
    output reg [3:0] wl_bist_pattern_sel2_o,
    // register name : mc_ecc_ce_ctrl_reg , address:0x204
    output reg [4:0] mc_ecc_ce_th_o,
    output reg mc_ecc_ce_int_mask_o,
    output reg mc_ecc_ce_int_en_o,
    // register name : mc_ecc_uce_ctrl_reg , address:0x248
    output reg mc_ecc_uce_int_mask_o,
    // register name : hang_timeout_mask_reg , address:0x264
    output reg hang_timeout_mask_o,
    // register name : hang_timeout_en_reg , address:0x26c
    output reg hang_timeout_en_o,
    // common output ports 
    output reg pslverr,
    output reg [APB_DATA_WIDTH-1:0]  prdata
    );

    //-------- regs --------
    //-------  Wires ---------
    wire apb_write_sel ;
    wire apb_sel ;
    wire apb_read_sel ;
    //read and write enable signals
    assign apb_write_sel   = psel &&  pwrite && (penable);
    assign apb_read_sel    = psel && (~pwrite) && (~penable);
    assign apb_sel         = psel && (~penable);
assign pready = 1'b1;
    //pslverr 
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'hc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h10)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h14)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h18)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h1c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h20)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h24)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h28)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h2c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h30)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h34)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h38)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h3c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h40)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h44)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h48)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h4c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h50)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h54)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h58)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h5c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h60)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h64)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h68)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h6c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h70)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h74)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h78)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h7c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h80)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h84)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h88)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h8c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h90)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h94)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h98)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h9c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'ha0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'ha4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'ha8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'hac)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hb0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hb4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hb8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hbc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hc0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hc4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hc8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hcc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hd0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hd4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hd8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hdc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'he0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'he4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'he8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hec)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hf0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hf4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hf8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'hfc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h100)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h104)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h108)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h10c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h110)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h114)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h118)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h11c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h120)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h124)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h128)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h12c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h130)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h134)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h138)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h13c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h140)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h144)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h148)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h14c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h150)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h154)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h158)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h15c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h16c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h170)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h174)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h178)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h180)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h184)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h188)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h18c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h190)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h194)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h198)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h19c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h1a0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h1a4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h1a8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h1ac)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h1b0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1b4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1b8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1bc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1c0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1c4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1c8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1cc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1d0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1d4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1d8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1dc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1e0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1e4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1e8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1ec)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1f0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1f4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1f8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h1fc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h200)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h204)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h208)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h20c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h210)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h214)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h218)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h21c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h220)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h224)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h228)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h22c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h230)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h234)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h238)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h23c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h240)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h244)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h248)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h24c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h250)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h254)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h258)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h25c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h260)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h264)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h268)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h26c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h270)) begin
            pslverr <= 1'h0;
        end
        else begin
            pslverr <= 1'h1;
        end
    end
    // register name : mc_work_ctrl_reg , address:0x4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_en_o <= 1'b0;
            mc_rf_cfg_sel_o <= 1'b0;
            mc_debug_en_o <= 1'b0;
            mc_wl_vmc_en_o <= 1'b0;
            mc_bl_vmc_en_o <= 1'b0;
            mc_bist_en_o <= 1'b1;
            mc_rescan_addr_range_sel_o <= 1'b1;
            mc_csl_scan_addr_range_sel_o <= 1'b1;
            mc_csl_scan_check_sel_o <= 1'b1;
            mc_csl_scan_mode_sel_o <= 1'b0;
            mc_rdata_invert_sel_o <= 1'b0;
            mc_rdrdy_n_en_o <= 1'b1;
            mc_rf_en_o <= 1'b1;
            mc_rf_burst_split_en_o <= 1'b1;
            mc_fake_bresp_en_o <= 1'b0;
            mc_ecc_en_o <= 1'b0;
            mc_all_bank_act_en_o <= 1'b0;
            mc2phy_dram0_mask_o <= 1'b1;
            mc2phy_dram1_mask_o <= 1'b1;
            mc2phy_dram2_mask_o <= 1'b1;
            mc2phy_dram3_mask_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 11'h4)) begin
            mc_en_o <= pwdata[0];
            mc_rf_cfg_sel_o <= pwdata[1];
            mc_debug_en_o <= pwdata[2];
            mc_wl_vmc_en_o <= pwdata[3];
            mc_bl_vmc_en_o <= pwdata[4];
            mc_bist_en_o <= pwdata[5];
            mc_rescan_addr_range_sel_o <= pwdata[6];
            mc_csl_scan_addr_range_sel_o <= pwdata[7];
            mc_csl_scan_check_sel_o <= pwdata[8];
            mc_csl_scan_mode_sel_o <= pwdata[9];
            mc_rdata_invert_sel_o <= pwdata[10];
            mc_rdrdy_n_en_o <= pwdata[11];
            mc_rf_en_o <= pwdata[12];
            mc_rf_burst_split_en_o <= pwdata[13];
            mc_fake_bresp_en_o <= pwdata[14];
            mc_ecc_en_o <= pwdata[15];
            mc_all_bank_act_en_o <= pwdata[16];
            mc2phy_dram0_mask_o <= pwdata[17];
            mc2phy_dram1_mask_o <= pwdata[18];
            mc2phy_dram2_mask_o <= pwdata[19];
            mc2phy_dram3_mask_o <= pwdata[20];
        end
    end
    // register name : phy_timing_cfg0_reg , address:0x8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bank_radd_set_time_o <= 8'h0;
            cadd_set_time_o <= 4'h0;
            r_cas_set_time_o <= 8'h0;
            w_cas_set_time_o <= 8'h0;
        end
        else if (apb_write_sel && (paddr == 11'h8)) begin
            bank_radd_set_time_o <= pwdata[7:0];
            cadd_set_time_o <= pwdata[11:8];
            r_cas_set_time_o <= pwdata[19:12];
            w_cas_set_time_o <= pwdata[27:20];
        end
    end
    // register name : mc_rf_period_cfg1_reg , address:0xc
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_rf_period_1_o <= 32'h30D4000;
        end
        else if (apb_write_sel && (paddr == 11'hc)) begin
            mc_rf_period_1_o <= pwdata[31:0];
        end
    end
    // register name : mc_rf_start_cfg1_reg , address:0x10
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_rf_start_1_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 11'h10)) begin
            mc_rf_start_1_o <= pwdata[31:0];
        end
    end
    // register name : mc_rf_period_cfg2_reg , address:0x14
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_rf_period_2_o <= 32'h30D4000;
        end
        else if (apb_write_sel && (paddr == 11'h14)) begin
            mc_rf_period_2_o <= pwdata[31:0];
        end
    end
    // register name : mc_rf_start_cfg2_reg , address:0x18
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_rf_start_2_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 11'h18)) begin
            mc_rf_start_2_o <= pwdata[31:0];
        end
    end
    // register name : mc_vmc_wl_num0_1_bank0_reg , address:0x1c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num0_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num1_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h1c)) begin
            mc_vmc_wl_num0_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num1_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num2_3_bank0_reg , address:0x20
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num2_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num3_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h20)) begin
            mc_vmc_wl_num2_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num3_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num4_5_bank0_reg , address:0x24
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num4_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num5_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h24)) begin
            mc_vmc_wl_num4_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num5_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num6_7_bank0_reg , address:0x28
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num6_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num7_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h28)) begin
            mc_vmc_wl_num6_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num7_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num8_9_bank0_reg , address:0x2c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num8_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num9_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h2c)) begin
            mc_vmc_wl_num8_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num9_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num10_11_bank0_reg , address:0x30
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num10_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num11_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h30)) begin
            mc_vmc_wl_num10_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num11_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num12_13_bank0_reg , address:0x34
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num12_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num13_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h34)) begin
            mc_vmc_wl_num12_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num13_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num14_15_bank0_reg , address:0x38
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num14_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num15_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h38)) begin
            mc_vmc_wl_num14_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num15_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num16_17_bank0_reg , address:0x3c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num16_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num17_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h3c)) begin
            mc_vmc_wl_num16_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num17_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num18_19_bank0_reg , address:0x40
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num18_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num19_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h40)) begin
            mc_vmc_wl_num18_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num19_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num20_21_bank0_reg , address:0x44
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num20_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num21_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h44)) begin
            mc_vmc_wl_num20_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num21_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num22_23_bank0_reg , address:0x48
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num22_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num23_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h48)) begin
            mc_vmc_wl_num22_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num23_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num24_25_bank0_reg , address:0x4c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num24_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num25_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h4c)) begin
            mc_vmc_wl_num24_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num25_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num26_27_bank0_reg , address:0x50
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num26_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num27_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h50)) begin
            mc_vmc_wl_num26_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num27_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num28_29_bank0_reg , address:0x54
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num28_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num29_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h54)) begin
            mc_vmc_wl_num28_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num29_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num30_31_bank0_reg , address:0x58
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num30_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num31_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h58)) begin
            mc_vmc_wl_num30_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num31_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num32_33_bank0_reg , address:0x5c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num32_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num33_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h5c)) begin
            mc_vmc_wl_num32_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num33_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num34_35_bank0_reg , address:0x60
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num34_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num35_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h60)) begin
            mc_vmc_wl_num34_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num35_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num36_37_bank0_reg , address:0x64
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num36_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num37_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h64)) begin
            mc_vmc_wl_num36_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num37_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num38_39_bank0_reg , address:0x68
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num38_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num39_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h68)) begin
            mc_vmc_wl_num38_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num39_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num40_41_bank0_reg , address:0x6c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num40_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num41_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h6c)) begin
            mc_vmc_wl_num40_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num41_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num42_43_bank0_reg , address:0x70
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num42_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num43_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h70)) begin
            mc_vmc_wl_num42_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num43_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num44_45_bank0_reg , address:0x74
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num44_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num45_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h74)) begin
            mc_vmc_wl_num44_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num45_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num46_47_bank0_reg , address:0x78
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num46_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num47_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h78)) begin
            mc_vmc_wl_num46_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num47_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num48_49_bank0_reg , address:0x7c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num48_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num49_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h7c)) begin
            mc_vmc_wl_num48_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num49_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num50_51_bank0_reg , address:0x80
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num50_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num51_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h80)) begin
            mc_vmc_wl_num50_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num51_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num52_53_bank0_reg , address:0x84
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num52_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num53_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h84)) begin
            mc_vmc_wl_num52_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num53_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num54_55_bank0_reg , address:0x88
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num54_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num55_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h88)) begin
            mc_vmc_wl_num54_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num55_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num56_57_bank0_reg , address:0x8c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num56_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num57_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h8c)) begin
            mc_vmc_wl_num56_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num57_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num58_59_bank0_reg , address:0x90
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num58_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num59_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h90)) begin
            mc_vmc_wl_num58_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num59_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num60_61_bank0_reg , address:0x94
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num60_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num61_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h94)) begin
            mc_vmc_wl_num60_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num61_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num62_63_bank0_reg , address:0x98
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num62_bank0_o <= 13'h1FFF;
            mc_vmc_wl_num63_bank0_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h98)) begin
            mc_vmc_wl_num62_bank0_o <= pwdata[12:0];
            mc_vmc_wl_num63_bank0_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_bl_num0_part0_1_bank0_reg , address:0x9c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part0_bank0_o <= 8'hFF;
            mc_vmc_bl_num1_part0_bank0_o <= 8'hFF;
            mc_vmc_bl_num0_part1_bank0_o <= 8'hFF;
            mc_vmc_bl_num1_part1_bank0_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 11'h9c)) begin
            mc_vmc_bl_num0_part0_bank0_o <= pwdata[7:0];
            mc_vmc_bl_num1_part0_bank0_o <= pwdata[15:8];
            mc_vmc_bl_num0_part1_bank0_o <= pwdata[23:16];
            mc_vmc_bl_num1_part1_bank0_o <= pwdata[31:24];
        end
    end
    // register name : mc_vmc_bl_num0_part2_3_bank0_reg , address:0xa0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part2_bank0_o <= 8'hFF;
            mc_vmc_bl_num1_part2_bank0_o <= 8'hFF;
            mc_vmc_bl_num0_part3_bank0_o <= 8'hFF;
            mc_vmc_bl_num1_part3_bank0_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 11'ha0)) begin
            mc_vmc_bl_num0_part2_bank0_o <= pwdata[7:0];
            mc_vmc_bl_num1_part2_bank0_o <= pwdata[15:8];
            mc_vmc_bl_num0_part3_bank0_o <= pwdata[23:16];
            mc_vmc_bl_num1_part3_bank0_o <= pwdata[31:24];
        end
    end
    // register name : mc_vmc_bl_num0_part4_5_bank0_reg , address:0xa4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part4_bank0_o <= 8'hFF;
            mc_vmc_bl_num1_part4_bank0_o <= 8'hFF;
            mc_vmc_bl_num0_part5_bank0_o <= 8'hFF;
            mc_vmc_bl_num1_part5_bank0_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 11'ha4)) begin
            mc_vmc_bl_num0_part4_bank0_o <= pwdata[7:0];
            mc_vmc_bl_num1_part4_bank0_o <= pwdata[15:8];
            mc_vmc_bl_num0_part5_bank0_o <= pwdata[23:16];
            mc_vmc_bl_num1_part5_bank0_o <= pwdata[31:24];
        end
    end
    // register name : mc_vmc_bl_num0_part6_7_bank0_reg , address:0xa8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part6_bank0_o <= 8'hFF;
            mc_vmc_bl_num1_part6_bank0_o <= 8'hFF;
            mc_vmc_bl_num0_part7_bank0_o <= 8'hFF;
            mc_vmc_bl_num1_part7_bank0_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 11'ha8)) begin
            mc_vmc_bl_num0_part6_bank0_o <= pwdata[7:0];
            mc_vmc_bl_num1_part6_bank0_o <= pwdata[15:8];
            mc_vmc_bl_num0_part7_bank0_o <= pwdata[23:16];
            mc_vmc_bl_num1_part7_bank0_o <= pwdata[31:24];
        end
    end
    // register name : mc_vmc_bl_num0_part8_9_bank0_reg , address:0xac
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part8_bank0_o <= 8'hFF;
            mc_vmc_bl_num1_part8_bank0_o <= 8'hFF;
            mc_vmc_bl_num0_part9_bank0_o <= 8'hFF;
            mc_vmc_bl_num1_part9_bank0_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 11'hac)) begin
            mc_vmc_bl_num0_part8_bank0_o <= pwdata[7:0];
            mc_vmc_bl_num1_part8_bank0_o <= pwdata[15:8];
            mc_vmc_bl_num0_part9_bank0_o <= pwdata[23:16];
            mc_vmc_bl_num1_part9_bank0_o <= pwdata[31:24];
        end
    end
    // register name : mc_bank_cfg_reg_reg , address:0x144
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank_map_id_o <= 8'hE4;
            mc_bist_grant_o <= 4'hF;
        end
        else if (apb_write_sel && (paddr == 11'h144)) begin
            mc_bank_map_id_o <= pwdata[7:0];
            mc_bist_grant_o <= pwdata[11:8];
        end
    end
    // register name : rescan_finish_mask_reg , address:0x174
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            rescan_finish_mask_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 11'h174)) begin
            rescan_finish_mask_o <= pwdata[0];
        end
    end
    // register name : bist_finish_mask_reg , address:0x184
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_finish_mask_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 11'h184)) begin
            bist_finish_mask_o <= pwdata[0];
        end
    end
    // register name : hang_timeout_th_reg , address:0x188
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_th_o <= 32'h186a00;
        end
        else if (apb_write_sel && (paddr == 11'h188)) begin
            hang_timeout_th_o <= pwdata[31:0];
        end
    end
    // register name : bist_pattern_reg0_reg , address:0x18c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_pattern_reg0_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 11'h18c)) begin
            bist_pattern_reg0_o <= pwdata[31:0];
        end
    end
    // register name : bist_pattern_reg1_reg , address:0x190
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_pattern_reg1_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 11'h190)) begin
            bist_pattern_reg1_o <= pwdata[31:0];
        end
    end
    // register name : bist_pattern_reg2_reg , address:0x194
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_pattern_reg2_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 11'h194)) begin
            bist_pattern_reg2_o <= pwdata[31:0];
        end
    end
    // register name : bist_pattern_reg3_reg , address:0x198
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_pattern_reg3_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 11'h198)) begin
            bist_pattern_reg3_o <= pwdata[31:0];
        end
    end
    // register name : csl_bist_pattern_sel0_reg , address:0x19c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            csl_bist_pattern_sel0_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 11'h19c)) begin
            csl_bist_pattern_sel0_o <= pwdata[31:0];
        end
    end
    // register name : csl_bist_pattern_sel1_reg , address:0x1a0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            csl_bist_pattern_sel1_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 11'h1a0)) begin
            csl_bist_pattern_sel1_o <= pwdata[31:0];
        end
    end
    // register name : csl_bist_pattern_sel2_reg , address:0x1a4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            csl_bist_pattern_sel2_o <= 4'h0;
        end
        else if (apb_write_sel && (paddr == 11'h1a4)) begin
            csl_bist_pattern_sel2_o <= pwdata[3:0];
        end
    end
    // register name : wl_bist_pattern_sel0_reg , address:0x1a8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            wl_bist_pattern_sel0_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 11'h1a8)) begin
            wl_bist_pattern_sel0_o <= pwdata[31:0];
        end
    end
    // register name : wl_bist_pattern_sel1_reg , address:0x1ac
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            wl_bist_pattern_sel1_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 11'h1ac)) begin
            wl_bist_pattern_sel1_o <= pwdata[31:0];
        end
    end
    // register name : wl_bist_pattern_sel2_reg , address:0x1b0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            wl_bist_pattern_sel2_o <= 4'h0;
        end
        else if (apb_write_sel && (paddr == 11'h1b0)) begin
            wl_bist_pattern_sel2_o <= pwdata[3:0];
        end
    end
    // register name : mc_ecc_ce_ctrl_reg , address:0x204
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_ecc_ce_th_o <= 5'h5;
            mc_ecc_ce_int_mask_o <= 1'b0;
            mc_ecc_ce_int_en_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 11'h204)) begin
            mc_ecc_ce_th_o <= pwdata[12:8];
            mc_ecc_ce_int_mask_o <= pwdata[24];
            mc_ecc_ce_int_en_o <= pwdata[25];
        end
    end
    // register name : mc_ecc_uce_ctrl_reg , address:0x248
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_ecc_uce_int_mask_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h248)) begin
            mc_ecc_uce_int_mask_o <= pwdata[12];
        end
    end
    // register name : hang_timeout_mask_reg , address:0x264
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_mask_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 11'h264)) begin
            hang_timeout_mask_o <= pwdata[0];
        end
    end
    // register name : hang_timeout_en_reg , address:0x26c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_en_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 11'h26c)) begin
            hang_timeout_en_o <= pwdata[0];
        end
    end
    // read register
    //when read a WO signal, will give it 0.
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0)
            prdata <= {APB_DATA_WIDTH{1'b0}};// default value is 0
        else
            if(apb_read_sel) begin
                case(paddr)
                11'h0: //register name:mc_id_reg,address:0x0
                prdata <= {mc_id_i};
                11'h4: //register name:mc_work_ctrl_reg,address:0x4
                prdata <= {11'h0,mc2phy_dram3_mask_o,mc2phy_dram2_mask_o,mc2phy_dram1_mask_o,mc2phy_dram0_mask_o,mc_all_bank_act_en_o,mc_ecc_en_o,mc_fake_bresp_en_o,mc_rf_burst_split_en_o,mc_rf_en_o,mc_rdrdy_n_en_o,mc_rdata_invert_sel_o,mc_csl_scan_mode_sel_o,mc_csl_scan_check_sel_o,mc_csl_scan_addr_range_sel_o,mc_rescan_addr_range_sel_o,mc_bist_en_o,mc_bl_vmc_en_o,mc_wl_vmc_en_o,mc_debug_en_o,mc_rf_cfg_sel_o,mc_en_o};
                11'h8: //register name:phy_timing_cfg0_reg,address:0x8
                prdata <= {4'h0,w_cas_set_time_o,r_cas_set_time_o,cadd_set_time_o,bank_radd_set_time_o};
                11'hc: //register name:mc_rf_period_cfg1_reg,address:0xc
                prdata <= {mc_rf_period_1_o};
                11'h10: //register name:mc_rf_start_cfg1_reg,address:0x10
                prdata <= {mc_rf_start_1_o};
                11'h14: //register name:mc_rf_period_cfg2_reg,address:0x14
                prdata <= {mc_rf_period_2_o};
                11'h18: //register name:mc_rf_start_cfg2_reg,address:0x18
                prdata <= {mc_rf_start_2_o};
                11'h1c: //register name:mc_vmc_wl_num0_1_bank0_reg,address:0x1c
                prdata <= {6'h0,mc_vmc_wl_num1_bank0_o,mc_vmc_wl_num0_bank0_o};
                11'h20: //register name:mc_vmc_wl_num2_3_bank0_reg,address:0x20
                prdata <= {6'h0,mc_vmc_wl_num3_bank0_o,mc_vmc_wl_num2_bank0_o};
                11'h24: //register name:mc_vmc_wl_num4_5_bank0_reg,address:0x24
                prdata <= {6'h0,mc_vmc_wl_num5_bank0_o,mc_vmc_wl_num4_bank0_o};
                11'h28: //register name:mc_vmc_wl_num6_7_bank0_reg,address:0x28
                prdata <= {6'h0,mc_vmc_wl_num7_bank0_o,mc_vmc_wl_num6_bank0_o};
                11'h2c: //register name:mc_vmc_wl_num8_9_bank0_reg,address:0x2c
                prdata <= {6'h0,mc_vmc_wl_num9_bank0_o,mc_vmc_wl_num8_bank0_o};
                11'h30: //register name:mc_vmc_wl_num10_11_bank0_reg,address:0x30
                prdata <= {6'h0,mc_vmc_wl_num11_bank0_o,mc_vmc_wl_num10_bank0_o};
                11'h34: //register name:mc_vmc_wl_num12_13_bank0_reg,address:0x34
                prdata <= {6'h0,mc_vmc_wl_num13_bank0_o,mc_vmc_wl_num12_bank0_o};
                11'h38: //register name:mc_vmc_wl_num14_15_bank0_reg,address:0x38
                prdata <= {6'h0,mc_vmc_wl_num15_bank0_o,mc_vmc_wl_num14_bank0_o};
                11'h3c: //register name:mc_vmc_wl_num16_17_bank0_reg,address:0x3c
                prdata <= {6'h0,mc_vmc_wl_num17_bank0_o,mc_vmc_wl_num16_bank0_o};
                11'h40: //register name:mc_vmc_wl_num18_19_bank0_reg,address:0x40
                prdata <= {6'h0,mc_vmc_wl_num19_bank0_o,mc_vmc_wl_num18_bank0_o};
                11'h44: //register name:mc_vmc_wl_num20_21_bank0_reg,address:0x44
                prdata <= {6'h0,mc_vmc_wl_num21_bank0_o,mc_vmc_wl_num20_bank0_o};
                11'h48: //register name:mc_vmc_wl_num22_23_bank0_reg,address:0x48
                prdata <= {6'h0,mc_vmc_wl_num23_bank0_o,mc_vmc_wl_num22_bank0_o};
                11'h4c: //register name:mc_vmc_wl_num24_25_bank0_reg,address:0x4c
                prdata <= {6'h0,mc_vmc_wl_num25_bank0_o,mc_vmc_wl_num24_bank0_o};
                11'h50: //register name:mc_vmc_wl_num26_27_bank0_reg,address:0x50
                prdata <= {6'h0,mc_vmc_wl_num27_bank0_o,mc_vmc_wl_num26_bank0_o};
                11'h54: //register name:mc_vmc_wl_num28_29_bank0_reg,address:0x54
                prdata <= {6'h0,mc_vmc_wl_num29_bank0_o,mc_vmc_wl_num28_bank0_o};
                11'h58: //register name:mc_vmc_wl_num30_31_bank0_reg,address:0x58
                prdata <= {6'h0,mc_vmc_wl_num31_bank0_o,mc_vmc_wl_num30_bank0_o};
                11'h5c: //register name:mc_vmc_wl_num32_33_bank0_reg,address:0x5c
                prdata <= {6'h0,mc_vmc_wl_num33_bank0_o,mc_vmc_wl_num32_bank0_o};
                11'h60: //register name:mc_vmc_wl_num34_35_bank0_reg,address:0x60
                prdata <= {6'h0,mc_vmc_wl_num35_bank0_o,mc_vmc_wl_num34_bank0_o};
                11'h64: //register name:mc_vmc_wl_num36_37_bank0_reg,address:0x64
                prdata <= {6'h0,mc_vmc_wl_num37_bank0_o,mc_vmc_wl_num36_bank0_o};
                11'h68: //register name:mc_vmc_wl_num38_39_bank0_reg,address:0x68
                prdata <= {6'h0,mc_vmc_wl_num39_bank0_o,mc_vmc_wl_num38_bank0_o};
                11'h6c: //register name:mc_vmc_wl_num40_41_bank0_reg,address:0x6c
                prdata <= {6'h0,mc_vmc_wl_num41_bank0_o,mc_vmc_wl_num40_bank0_o};
                11'h70: //register name:mc_vmc_wl_num42_43_bank0_reg,address:0x70
                prdata <= {6'h0,mc_vmc_wl_num43_bank0_o,mc_vmc_wl_num42_bank0_o};
                11'h74: //register name:mc_vmc_wl_num44_45_bank0_reg,address:0x74
                prdata <= {6'h0,mc_vmc_wl_num45_bank0_o,mc_vmc_wl_num44_bank0_o};
                11'h78: //register name:mc_vmc_wl_num46_47_bank0_reg,address:0x78
                prdata <= {6'h0,mc_vmc_wl_num47_bank0_o,mc_vmc_wl_num46_bank0_o};
                11'h7c: //register name:mc_vmc_wl_num48_49_bank0_reg,address:0x7c
                prdata <= {6'h0,mc_vmc_wl_num49_bank0_o,mc_vmc_wl_num48_bank0_o};
                11'h80: //register name:mc_vmc_wl_num50_51_bank0_reg,address:0x80
                prdata <= {6'h0,mc_vmc_wl_num51_bank0_o,mc_vmc_wl_num50_bank0_o};
                11'h84: //register name:mc_vmc_wl_num52_53_bank0_reg,address:0x84
                prdata <= {6'h0,mc_vmc_wl_num53_bank0_o,mc_vmc_wl_num52_bank0_o};
                11'h88: //register name:mc_vmc_wl_num54_55_bank0_reg,address:0x88
                prdata <= {6'h0,mc_vmc_wl_num55_bank0_o,mc_vmc_wl_num54_bank0_o};
                11'h8c: //register name:mc_vmc_wl_num56_57_bank0_reg,address:0x8c
                prdata <= {6'h0,mc_vmc_wl_num57_bank0_o,mc_vmc_wl_num56_bank0_o};
                11'h90: //register name:mc_vmc_wl_num58_59_bank0_reg,address:0x90
                prdata <= {6'h0,mc_vmc_wl_num59_bank0_o,mc_vmc_wl_num58_bank0_o};
                11'h94: //register name:mc_vmc_wl_num60_61_bank0_reg,address:0x94
                prdata <= {6'h0,mc_vmc_wl_num61_bank0_o,mc_vmc_wl_num60_bank0_o};
                11'h98: //register name:mc_vmc_wl_num62_63_bank0_reg,address:0x98
                prdata <= {6'h0,mc_vmc_wl_num63_bank0_o,mc_vmc_wl_num62_bank0_o};
                11'h9c: //register name:mc_vmc_bl_num0_part0_1_bank0_reg,address:0x9c
                prdata <= {mc_vmc_bl_num1_part1_bank0_o,mc_vmc_bl_num0_part1_bank0_o,mc_vmc_bl_num1_part0_bank0_o,mc_vmc_bl_num0_part0_bank0_o};
                11'ha0: //register name:mc_vmc_bl_num0_part2_3_bank0_reg,address:0xa0
                prdata <= {mc_vmc_bl_num1_part3_bank0_o,mc_vmc_bl_num0_part3_bank0_o,mc_vmc_bl_num1_part2_bank0_o,mc_vmc_bl_num0_part2_bank0_o};
                11'ha4: //register name:mc_vmc_bl_num0_part4_5_bank0_reg,address:0xa4
                prdata <= {mc_vmc_bl_num1_part5_bank0_o,mc_vmc_bl_num0_part5_bank0_o,mc_vmc_bl_num1_part4_bank0_o,mc_vmc_bl_num0_part4_bank0_o};
                11'ha8: //register name:mc_vmc_bl_num0_part6_7_bank0_reg,address:0xa8
                prdata <= {mc_vmc_bl_num1_part7_bank0_o,mc_vmc_bl_num0_part7_bank0_o,mc_vmc_bl_num1_part6_bank0_o,mc_vmc_bl_num0_part6_bank0_o};
                11'hac: //register name:mc_vmc_bl_num0_part8_9_bank0_reg,address:0xac
                prdata <= {mc_vmc_bl_num1_part9_bank0_o,mc_vmc_bl_num0_part9_bank0_o,mc_vmc_bl_num1_part8_bank0_o,mc_vmc_bl_num0_part8_bank0_o};
                11'hb0: //register name:err_wl0_1_bank0_reg,address:0xb0
                prdata <= {6'h0,err_wl1_bank0_i,err_wl0_bank0_i};
                11'hb4: //register name:err_wl2_3_bank0_reg,address:0xb4
                prdata <= {6'h0,err_wl3_bank0_i,err_wl2_bank0_i};
                11'hb8: //register name:err_wl4_5_bank0_reg,address:0xb8
                prdata <= {6'h0,err_wl5_bank0_i,err_wl4_bank0_i};
                11'hbc: //register name:err_wl6_7_bank0_reg,address:0xbc
                prdata <= {6'h0,err_wl7_bank0_i,err_wl6_bank0_i};
                11'hc0: //register name:err_wl8_9_bank0_reg,address:0xc0
                prdata <= {6'h0,err_wl9_bank0_i,err_wl8_bank0_i};
                11'hc4: //register name:err_wl10_11_bank0_reg,address:0xc4
                prdata <= {6'h0,err_wl11_bank0_i,err_wl10_bank0_i};
                11'hc8: //register name:err_wl12_13_bank0_reg,address:0xc8
                prdata <= {6'h0,err_wl13_bank0_i,err_wl12_bank0_i};
                11'hcc: //register name:err_wl14_15_bank0_reg,address:0xcc
                prdata <= {6'h0,err_wl15_bank0_i,err_wl14_bank0_i};
                11'hd0: //register name:err_wl16_17_bank0_reg,address:0xd0
                prdata <= {6'h0,err_wl17_bank0_i,err_wl16_bank0_i};
                11'hd4: //register name:err_wl18_19_bank0_reg,address:0xd4
                prdata <= {6'h0,err_wl19_bank0_i,err_wl18_bank0_i};
                11'hd8: //register name:err_wl20_21_bank0_reg,address:0xd8
                prdata <= {6'h0,err_wl21_bank0_i,err_wl20_bank0_i};
                11'hdc: //register name:err_wl22_23_bank0_reg,address:0xdc
                prdata <= {6'h0,err_wl23_bank0_i,err_wl22_bank0_i};
                11'he0: //register name:err_wl24_25_bank0_reg,address:0xe0
                prdata <= {6'h0,err_wl25_bank0_i,err_wl24_bank0_i};
                11'he4: //register name:err_wl26_27_bank0_reg,address:0xe4
                prdata <= {6'h0,err_wl27_bank0_i,err_wl26_bank0_i};
                11'he8: //register name:err_wl28_29_bank0_reg,address:0xe8
                prdata <= {6'h0,err_wl29_bank0_i,err_wl28_bank0_i};
                11'hec: //register name:err_wl30_31_bank0_reg,address:0xec
                prdata <= {6'h0,err_wl31_bank0_i,err_wl30_bank0_i};
                11'hf0: //register name:err_wl32_33_bank0_reg,address:0xf0
                prdata <= {6'h0,err_wl33_bank0_i,err_wl32_bank0_i};
                11'hf4: //register name:err_wl34_35_bank0_reg,address:0xf4
                prdata <= {6'h0,err_wl35_bank0_i,err_wl34_bank0_i};
                11'hf8: //register name:err_wl36_37_bank0_reg,address:0xf8
                prdata <= {6'h0,err_wl37_bank0_i,err_wl36_bank0_i};
                11'hfc: //register name:err_wl38_39_bank0_reg,address:0xfc
                prdata <= {6'h0,err_wl39_bank0_i,err_wl38_bank0_i};
                11'h100: //register name:err_wl40_41_bank0_reg,address:0x100
                prdata <= {6'h0,err_wl41_bank0_i,err_wl40_bank0_i};
                11'h104: //register name:err_wl42_43_bank0_reg,address:0x104
                prdata <= {6'h0,err_wl43_bank0_i,err_wl42_bank0_i};
                11'h108: //register name:err_wl44_45_bank0_reg,address:0x108
                prdata <= {6'h0,err_wl45_bank0_i,err_wl44_bank0_i};
                11'h10c: //register name:err_wl46_47_bank0_reg,address:0x10c
                prdata <= {6'h0,err_wl47_bank0_i,err_wl46_bank0_i};
                11'h110: //register name:err_wl48_49_bank0_reg,address:0x110
                prdata <= {6'h0,err_wl49_bank0_i,err_wl48_bank0_i};
                11'h114: //register name:err_wl50_51_bank0_reg,address:0x114
                prdata <= {6'h0,err_wl51_bank0_i,err_wl50_bank0_i};
                11'h118: //register name:err_wl52_53_bank0_reg,address:0x118
                prdata <= {6'h0,err_wl53_bank0_i,err_wl52_bank0_i};
                11'h11c: //register name:err_wl54_55_bank0_reg,address:0x11c
                prdata <= {6'h0,err_wl55_bank0_i,err_wl54_bank0_i};
                11'h120: //register name:err_wl56_57_bank0_reg,address:0x120
                prdata <= {6'h0,err_wl57_bank0_i,err_wl56_bank0_i};
                11'h124: //register name:err_wl58_59_bank0_reg,address:0x124
                prdata <= {6'h0,err_wl59_bank0_i,err_wl58_bank0_i};
                11'h128: //register name:err_wl60_61_bank0_reg,address:0x128
                prdata <= {6'h0,err_wl61_bank0_i,err_wl60_bank0_i};
                11'h12c: //register name:err_wl62_63_bank0_reg,address:0x12c
                prdata <= {6'h0,err_wl63_bank0_i,err_wl62_bank0_i};
                11'h130: //register name:err_csl_part0_1_bank0_reg,address:0x130
                prdata <= {err_csl1_part1_bank0_i,err_csl0_part1_bank0_i,err_csl1_part0_bank0_i,err_csl0_part0_bank0_i};
                11'h134: //register name:err_csl_part2_3_bank0_reg,address:0x134
                prdata <= {err_csl1_part3_bank0_i,err_csl0_part3_bank0_i,err_csl1_part2_bank0_i,err_csl0_part2_bank0_i};
                11'h138: //register name:err_csl_part4_5_bank0_reg,address:0x138
                prdata <= {err_csl1_part5_bank0_i,err_csl0_part5_bank0_i,err_csl1_part4_bank0_i,err_csl0_part4_bank0_i};
                11'h13c: //register name:err_csl_part6_7_bank0_reg,address:0x13c
                prdata <= {err_csl1_part7_bank0_i,err_csl0_part7_bank0_i,err_csl1_part6_bank0_i,err_csl0_part6_bank0_i};
                11'h140: //register name:err_csl_part8_9_bank0_reg,address:0x140
                prdata <= {err_csl1_part9_bank0_i,err_csl0_part9_bank0_i,err_csl1_part8_bank0_i,err_csl0_part8_bank0_i};
                11'h144: //register name:mc_bank_cfg_reg_reg,address:0x144
                prdata <= {20'h0,mc_bist_grant_o,mc_bank_map_id_o};
                11'h148: //register name:mc_timeout_clr_reg,address:0x148
                prdata <= {31'h0,mc_timeout_clr_o};
                11'h14c: //register name:mc_rf_start_dbg_reg,address:0x14c
                prdata <= {31'h0,mc_rf_start_dbg_i};
                11'h150: //register name:mc_timeout_flag_reg,address:0x150
                prdata <= {31'h0,mc_timeout_flag_i};
                11'h154: //register name:mc_bist_status_reg,address:0x154
                prdata <= {27'h0,dram_init_finish_i,mc_bist_path_fail_bank0_i,mc_bist_status_i};
                11'h158: //register name:bist_finish_and_success_reg,address:0x158
                prdata <= {28'h0,bist_rescan_success_bank0_i,bank_success_bank0_i,bist_rescan_finish_bank0_i,bist_finish_bank0_i};
                11'h15c: //register name:mc_bist_rescan_fail_num_bank0_reg,address:0x15c
                prdata <= {12'h0,mc_bist_rescan_fail_num_bank0_i};
                11'h16c: //register name:mc_bist_err_wl_reg,address:0x16c
                prdata <= {24'h0,err_wl_num_change_flag_bank0_i,mc_bist_err_wl_num_bank0_i};
                11'h170: //register name:rescan_finish_clr_reg,address:0x170
                prdata <= {31'h0,rescan_finish_clr_o};
                11'h174: //register name:rescan_finish_mask_reg,address:0x174
                prdata <= {31'h0,rescan_finish_mask_o};
                11'h178: //register name:rescan_round_result_1_reg,address:0x178
                prdata <= {17'h0,rescan_round_result_bank0_i};
                11'h180: //register name:bist_finish_clr_reg,address:0x180
                prdata <= {31'h0,bist_finish_clr_o};
                11'h184: //register name:bist_finish_mask_reg,address:0x184
                prdata <= {31'h0,bist_finish_mask_o};
                11'h188: //register name:hang_timeout_th_reg,address:0x188
                prdata <= {hang_timeout_th_o};
                11'h18c: //register name:bist_pattern_reg0_reg,address:0x18c
                prdata <= {bist_pattern_reg0_o};
                11'h190: //register name:bist_pattern_reg1_reg,address:0x190
                prdata <= {bist_pattern_reg1_o};
                11'h194: //register name:bist_pattern_reg2_reg,address:0x194
                prdata <= {bist_pattern_reg2_o};
                11'h198: //register name:bist_pattern_reg3_reg,address:0x198
                prdata <= {bist_pattern_reg3_o};
                11'h19c: //register name:csl_bist_pattern_sel0_reg,address:0x19c
                prdata <= {csl_bist_pattern_sel0_o};
                11'h1a0: //register name:csl_bist_pattern_sel1_reg,address:0x1a0
                prdata <= {csl_bist_pattern_sel1_o};
                11'h1a4: //register name:csl_bist_pattern_sel2_reg,address:0x1a4
                prdata <= {28'h0,csl_bist_pattern_sel2_o};
                11'h1a8: //register name:wl_bist_pattern_sel0_reg,address:0x1a8
                prdata <= {wl_bist_pattern_sel0_o};
                11'h1ac: //register name:wl_bist_pattern_sel1_reg,address:0x1ac
                prdata <= {wl_bist_pattern_sel1_o};
                11'h1b0: //register name:wl_bist_pattern_sel2_reg,address:0x1b0
                prdata <= {28'h0,wl_bist_pattern_sel2_o};
                11'h1b4: //register name:mc_frame2array_dbg_reg,address:0x1b4
                prdata <= {2'h0,dbg_w_frame_cnt_i,2'h0,dbg_r_frame_cnt_i,3'h0,dbg_refresh_flag_i,2'h0,dbg_r_data_cnt_i,3'h0,dbg_current_state_array_i,3'h0,dbg_next_state_array_i};
                11'h1b8: //register name:dbg_frame_store_0_reg,address:0x1b8
                prdata <= {dbg_frame_store_0_i};
                11'h1bc: //register name:dbg_frame_store_1_reg,address:0x1bc
                prdata <= {dbg_frame_store_1_i};
                11'h1c0: //register name:dbg_frame_store_2_reg,address:0x1c0
                prdata <= {dbg_frame_store_2_i};
                11'h1c4: //register name:dbg_frame_store_3_reg,address:0x1c4
                prdata <= {dbg_frame_store_3_i};
                11'h1c8: //register name:dbg_frame_store_4_reg,address:0x1c8
                prdata <= {dbg_frame_store_4_i};
                11'h1cc: //register name:dbg_frame_store_5_reg,address:0x1cc
                prdata <= {dbg_frame_store_5_i};
                11'h1d0: //register name:dbg_frame_store_6_reg,address:0x1d0
                prdata <= {dbg_frame_store_6_i};
                11'h1d4: //register name:dbg_frame_store_7_reg,address:0x1d4
                prdata <= {dbg_frame_store_7_i};
                11'h1d8: //register name:dbg_frame_store_8_reg,address:0x1d8
                prdata <= {dbg_frame_store_8_i};
                11'h1dc: //register name:dbg_frame_store_9_reg,address:0x1dc
                prdata <= {30'h0,dbg_frame_store_9_i};
                11'h1e0: //register name:dbg_rdata_store_0_reg,address:0x1e0
                prdata <= {dbg_rdata_store_0_i};
                11'h1e4: //register name:dbg_rdata_store_1_reg,address:0x1e4
                prdata <= {dbg_rdata_store_1_i};
                11'h1e8: //register name:dbg_rdata_store_2_reg,address:0x1e8
                prdata <= {dbg_rdata_store_2_i};
                11'h1ec: //register name:dbg_rdata_store_3_reg,address:0x1ec
                prdata <= {dbg_rdata_store_3_i};
                11'h1f0: //register name:dbg_rdata_store_4_reg,address:0x1f0
                prdata <= {dbg_rdata_store_4_i};
                11'h1f4: //register name:dbg_rdata_store_5_reg,address:0x1f4
                prdata <= {dbg_rdata_store_5_i};
                11'h1f8: //register name:dbg_rdata_store_6_reg,address:0x1f8
                prdata <= {dbg_rdata_store_6_i};
                11'h1fc: //register name:dbg_rdata_store_7_reg,address:0x1fc
                prdata <= {dbg_rdata_store_7_i};
                11'h200: //register name:dbg_rdata_store_8_reg,address:0x200
                prdata <= {22'h0,dbg_rdata_store_8_i};
                11'h204: //register name:mc_ecc_ce_ctrl_reg,address:0x204
                prdata <= {6'h0,mc_ecc_ce_int_en_o,mc_ecc_ce_int_mask_o,3'h0,mc_ecc_ce_cnt_i,3'h0,mc_ecc_ce_th_o,3'h0,mc_ecc_ce_overflow_int_i,3'h0,mc_ecc_ce_int_clr_o};
                11'h208: //register name:mc_ecc_ce_addr0_reg,address:0x208
                prdata <= {mc_ecc_ce_addr_cnt0_i,1'h0,mc_ecc_ce_addr_vld0_i,mc_ecc_ce_addr0_i};
                11'h20c: //register name:mc_ecc_ce_addr1_reg,address:0x20c
                prdata <= {mc_ecc_ce_addr_cnt1_i,1'h0,mc_ecc_ce_addr_vld1_i,mc_ecc_ce_addr1_i};
                11'h210: //register name:mc_ecc_ce_addr2_reg,address:0x210
                prdata <= {mc_ecc_ce_addr_cnt2_i,1'h0,mc_ecc_ce_addr_vld2_i,mc_ecc_ce_addr2_i};
                11'h214: //register name:mc_ecc_ce_addr3_reg,address:0x214
                prdata <= {mc_ecc_ce_addr_cnt3_i,1'h0,mc_ecc_ce_addr_vld3_i,mc_ecc_ce_addr3_i};
                11'h218: //register name:mc_ecc_ce_addr4_reg,address:0x218
                prdata <= {mc_ecc_ce_addr_cnt4_i,1'h0,mc_ecc_ce_addr_vld4_i,mc_ecc_ce_addr4_i};
                11'h21c: //register name:mc_ecc_ce_addr5_reg,address:0x21c
                prdata <= {mc_ecc_ce_addr_cnt5_i,1'h0,mc_ecc_ce_addr_vld5_i,mc_ecc_ce_addr5_i};
                11'h220: //register name:mc_ecc_ce_addr6_reg,address:0x220
                prdata <= {mc_ecc_ce_addr_cnt6_i,1'h0,mc_ecc_ce_addr_vld6_i,mc_ecc_ce_addr6_i};
                11'h224: //register name:mc_ecc_ce_addr7_reg,address:0x224
                prdata <= {mc_ecc_ce_addr_cnt7_i,1'h0,mc_ecc_ce_addr_vld7_i,mc_ecc_ce_addr7_i};
                11'h228: //register name:mc_ecc_ce_addr8_reg,address:0x228
                prdata <= {mc_ecc_ce_addr_cnt8_i,1'h0,mc_ecc_ce_addr_vld8_i,mc_ecc_ce_addr8_i};
                11'h22c: //register name:mc_ecc_ce_addr9_reg,address:0x22c
                prdata <= {mc_ecc_ce_addr_cnt9_i,1'h0,mc_ecc_ce_addr_vld9_i,mc_ecc_ce_addr9_i};
                11'h230: //register name:mc_ecc_ce_addr10_reg,address:0x230
                prdata <= {mc_ecc_ce_addr_cnt10_i,1'h0,mc_ecc_ce_addr_vld10_i,mc_ecc_ce_addr10_i};
                11'h234: //register name:mc_ecc_ce_addr11_reg,address:0x234
                prdata <= {mc_ecc_ce_addr_cnt11_i,1'h0,mc_ecc_ce_addr_vld11_i,mc_ecc_ce_addr11_i};
                11'h238: //register name:mc_ecc_ce_addr12_reg,address:0x238
                prdata <= {mc_ecc_ce_addr_cnt12_i,1'h0,mc_ecc_ce_addr_vld12_i,mc_ecc_ce_addr12_i};
                11'h23c: //register name:mc_ecc_ce_addr13_reg,address:0x23c
                prdata <= {mc_ecc_ce_addr_cnt13_i,1'h0,mc_ecc_ce_addr_vld13_i,mc_ecc_ce_addr13_i};
                11'h240: //register name:mc_ecc_ce_addr14_reg,address:0x240
                prdata <= {mc_ecc_ce_addr_cnt14_i,1'h0,mc_ecc_ce_addr_vld14_i,mc_ecc_ce_addr14_i};
                11'h244: //register name:mc_ecc_ce_addr15_reg,address:0x244
                prdata <= {mc_ecc_ce_addr_cnt15_i,1'h0,mc_ecc_ce_addr_vld15_i,mc_ecc_ce_addr15_i};
                11'h248: //register name:mc_ecc_uce_ctrl_reg,address:0x248
                prdata <= {19'h0,mc_ecc_uce_int_mask_o,1'h0,mc_ecc_uce_cnt_i,3'h0,mc_ecc_uce_int_i,3'h0,mc_ecc_uce_int_clr_o};
                11'h24c: //register name:mc_ecc_uce_addr0_reg,address:0x24c
                prdata <= {9'h0,mc_ecc_uce_addr_vld0_i,mc_ecc_uce_addr0_i};
                11'h250: //register name:mc_ecc_uce_addr1_reg,address:0x250
                prdata <= {9'h0,mc_ecc_uce_addr_vld1_i,mc_ecc_uce_addr1_i};
                11'h254: //register name:mc_ecc_uce_addr2_reg,address:0x254
                prdata <= {9'h0,mc_ecc_uce_addr_vld2_i,mc_ecc_uce_addr2_i};
                11'h258: //register name:mc_ecc_uce_addr3_reg,address:0x258
                prdata <= {9'h0,mc_ecc_uce_addr_vld3_i,mc_ecc_uce_addr3_i};
                11'h25c: //register name:mc_page_status_reg,address:0x25c
                prdata <= {31'h0,mc_page_status_i};
                11'h260: //register name:hang_timeout_status_reg,address:0x260
                prdata <= {31'h0,hang_timeout_status_i};
                11'h264: //register name:hang_timeout_mask_reg,address:0x264
                prdata <= {31'h0,hang_timeout_mask_o};
                11'h268: //register name:hang_timeout_clr_reg,address:0x268
                prdata <= {31'h0,hang_timeout_clr_o};
                11'h26c: //register name:hang_timeout_en_reg,address:0x26c
                prdata <= {31'h0,hang_timeout_en_o};
                11'h270: //register name:bist_clk_cnt_reg,address:0x270
                prdata <= {bist_clk_cnt_i};
            default:
                prdata <= {APB_DATA_WIDTH{1'b1}}; //  means read a non-exist address
            endcase
        end
        else begin
            prdata <= {APB_DATA_WIDTH{1'b0}};
        end
    end
    // register name : mc_timeout_clr_reg , address:0x148
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_timeout_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h148)) begin
            mc_timeout_clr_o <= pwdata[0];
        end
        else
            mc_timeout_clr_o <= 1'b0;

    end
    // register name : rescan_finish_clr_reg , address:0x170
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            rescan_finish_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h170)) begin
            rescan_finish_clr_o <= pwdata[0];
        end
        else
            rescan_finish_clr_o <= 1'b0;

    end
    // register name : bist_finish_clr_reg , address:0x180
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_finish_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h180)) begin
            bist_finish_clr_o <= pwdata[0];
        end
        else
            bist_finish_clr_o <= 1'b0;

    end
    // register name : mc_ecc_ce_ctrl_reg , address:0x204
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_ecc_ce_int_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h204)) begin
            mc_ecc_ce_int_clr_o <= pwdata[0];
        end
        else
            mc_ecc_ce_int_clr_o <= 1'b0;

    end
    // register name : mc_ecc_uce_ctrl_reg , address:0x248
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_ecc_uce_int_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h248)) begin
            mc_ecc_uce_int_clr_o <= pwdata[0];
        end
        else
            mc_ecc_uce_int_clr_o <= 1'b0;

    end
    // register name : hang_timeout_clr_reg , address:0x268
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h268)) begin
            hang_timeout_clr_o <= pwdata[0];
        end
        else
            hang_timeout_clr_o <= 1'b0;

    end
endmodule
// Below is the information of "mc_1short1_top_aux" in register sheet, can use as a reference if have unexpected issues in this verilog file.
// 0x0___(mc_id_reg)___(mc_id)___0___32___RO___0x0
// 0x4___(mc_work_ctrl_reg)___(mc_en)___0___1___RW___0x0
// 0x4___(mc_work_ctrl_reg)___(mc_rf_cfg_sel)___1___1___RW___0x0
// 0x4___(mc_work_ctrl_reg)___(mc_debug_en)___2___1___RW___0x0
// 0x4___(mc_work_ctrl_reg)___(mc_wl_vmc_en)___3___1___RW___0x0
// 0x4___(mc_work_ctrl_reg)___(mc_bl_vmc_en)___4___1___RW___0x0
// 0x4___(mc_work_ctrl_reg)___(mc_bist_en)___5___1___RW___0x1
// 0x4___(mc_work_ctrl_reg)___(mc_rescan_addr_range_sel)___6___1___RW___0x1
// 0x4___(mc_work_ctrl_reg)___(mc_csl_scan_addr_range_sel)___7___1___RW___0x1
// 0x4___(mc_work_ctrl_reg)___(mc_csl_scan_check_sel)___8___1___RW___0x1
// 0x4___(mc_work_ctrl_reg)___(mc_csl_scan_mode_sel)___9___1___RW___0x0
// 0x4___(mc_work_ctrl_reg)___(mc_rdata_invert_sel)___10___1___RW___0x0
// 0x4___(mc_work_ctrl_reg)___(mc_rdrdy_n_en)___11___1___RW___0x0
// 0x4___(mc_work_ctrl_reg)___(mc_rf_en)___12___1___RW___0x1
// 0x4___(mc_work_ctrl_reg)___(mc_rf_burst_split_en)___13___1___RW___0x1
// 0x4___(mc_work_ctrl_reg)___(mc_fake_bresp_en)___14___1___RW___0x0
// 0x4___(mc_work_ctrl_reg)___(mc_ecc_en)___15___1___RW___0x0
// 0x4___(mc_work_ctrl_reg)___(mc_all_bank_act_en)___16___1___RW___0x0
// 0x4___(mc_work_ctrl_reg)___(mc2phy_dram0_mask)___17___1___RW___0x1
// 0x4___(mc_work_ctrl_reg)___(mc2phy_dram1_mask)___18___1___RW___0x1
// 0x4___(mc_work_ctrl_reg)___(mc2phy_dram2_mask)___19___1___RW___0x1
// 0x4___(mc_work_ctrl_reg)___(mc2phy_dram3_mask)___20___1___RW___0x1
// 0x4___(mc_work_ctrl_reg)___(reserved)___21___11___NA___0x0
// 0x8___(phy_timing_cfg0_reg)___(bank_radd_set_time)___0___8___RW___0x0
// 0x8___(phy_timing_cfg0_reg)___(cadd_set_time)___8___4___RW___0x0
// 0x8___(phy_timing_cfg0_reg)___(r_cas_set_time)___12___8___RW___0x0
// 0x8___(phy_timing_cfg0_reg)___(w_cas_set_time)___20___8___RW___0x0
// 0x8___(phy_timing_cfg0_reg)___(reserved)___28___4___NA___NA
// 0xc___(mc_rf_period_cfg1_reg)___(mc_rf_period_1)___0___32___RW___0x30D4000
// 0x10___(mc_rf_start_cfg1_reg)___(mc_rf_start_1)___0___32___RW___0xFFFFFFFF
// 0x14___(mc_rf_period_cfg2_reg)___(mc_rf_period_2)___0___32___RW___0x30D4000
// 0x18___(mc_rf_start_cfg2_reg)___(mc_rf_start_2)___0___32___RW___0xFFFFFFFF
// 0x1c___(mc_vmc_wl_num0_1_bank0_reg)___(mc_vmc_wl_num0_bank0)___0___13___RW___0x1FFF
// 0x1c___(mc_vmc_wl_num0_1_bank0_reg)___(mc_vmc_wl_num1_bank0)___13___13___RW___0x1FFF
// 0x1c___(mc_vmc_wl_num0_1_bank0_reg)___(reserved)___26___6___NA___NA
// 0x20___(mc_vmc_wl_num2_3_bank0_reg)___(mc_vmc_wl_num2_bank0)___0___13___RW___0x1FFF
// 0x20___(mc_vmc_wl_num2_3_bank0_reg)___(mc_vmc_wl_num3_bank0)___13___13___RW___0x1FFF
// 0x20___(mc_vmc_wl_num2_3_bank0_reg)___(reserved)___26___6___NA___NA
// 0x24___(mc_vmc_wl_num4_5_bank0_reg)___(mc_vmc_wl_num4_bank0)___0___13___RW___0x1FFF
// 0x24___(mc_vmc_wl_num4_5_bank0_reg)___(mc_vmc_wl_num5_bank0)___13___13___RW___0x1FFF
// 0x24___(mc_vmc_wl_num4_5_bank0_reg)___(reserved)___26___6___NA___NA
// 0x28___(mc_vmc_wl_num6_7_bank0_reg)___(mc_vmc_wl_num6_bank0)___0___13___RW___0x1FFF
// 0x28___(mc_vmc_wl_num6_7_bank0_reg)___(mc_vmc_wl_num7_bank0)___13___13___RW___0x1FFF
// 0x28___(mc_vmc_wl_num6_7_bank0_reg)___(reserved)___26___6___NA___NA
// 0x2c___(mc_vmc_wl_num8_9_bank0_reg)___(mc_vmc_wl_num8_bank0)___0___13___RW___0x1FFF
// 0x2c___(mc_vmc_wl_num8_9_bank0_reg)___(mc_vmc_wl_num9_bank0)___13___13___RW___0x1FFF
// 0x2c___(mc_vmc_wl_num8_9_bank0_reg)___(reserved)___26___6___NA___NA
// 0x30___(mc_vmc_wl_num10_11_bank0_reg)___(mc_vmc_wl_num10_bank0)___0___13___RW___0x1FFF
// 0x30___(mc_vmc_wl_num10_11_bank0_reg)___(mc_vmc_wl_num11_bank0)___13___13___RW___0x1FFF
// 0x30___(mc_vmc_wl_num10_11_bank0_reg)___(reserved)___26___6___NA___NA
// 0x34___(mc_vmc_wl_num12_13_bank0_reg)___(mc_vmc_wl_num12_bank0)___0___13___RW___0x1FFF
// 0x34___(mc_vmc_wl_num12_13_bank0_reg)___(mc_vmc_wl_num13_bank0)___13___13___RW___0x1FFF
// 0x34___(mc_vmc_wl_num12_13_bank0_reg)___(reserved)___26___6___NA___NA
// 0x38___(mc_vmc_wl_num14_15_bank0_reg)___(mc_vmc_wl_num14_bank0)___0___13___RW___0x1FFF
// 0x38___(mc_vmc_wl_num14_15_bank0_reg)___(mc_vmc_wl_num15_bank0)___13___13___RW___0x1FFF
// 0x38___(mc_vmc_wl_num14_15_bank0_reg)___(reserved)___26___6___NA___NA
// 0x3c___(mc_vmc_wl_num16_17_bank0_reg)___(mc_vmc_wl_num16_bank0)___0___13___RW___0x1FFF
// 0x3c___(mc_vmc_wl_num16_17_bank0_reg)___(mc_vmc_wl_num17_bank0)___13___13___RW___0x1FFF
// 0x3c___(mc_vmc_wl_num16_17_bank0_reg)___(reserved)___26___6___NA___NA
// 0x40___(mc_vmc_wl_num18_19_bank0_reg)___(mc_vmc_wl_num18_bank0)___0___13___RW___0x1FFF
// 0x40___(mc_vmc_wl_num18_19_bank0_reg)___(mc_vmc_wl_num19_bank0)___13___13___RW___0x1FFF
// 0x40___(mc_vmc_wl_num18_19_bank0_reg)___(reserved)___26___6___NA___NA
// 0x44___(mc_vmc_wl_num20_21_bank0_reg)___(mc_vmc_wl_num20_bank0)___0___13___RW___0x1FFF
// 0x44___(mc_vmc_wl_num20_21_bank0_reg)___(mc_vmc_wl_num21_bank0)___13___13___RW___0x1FFF
// 0x44___(mc_vmc_wl_num20_21_bank0_reg)___(reserved)___26___6___NA___NA
// 0x48___(mc_vmc_wl_num22_23_bank0_reg)___(mc_vmc_wl_num22_bank0)___0___13___RW___0x1FFF
// 0x48___(mc_vmc_wl_num22_23_bank0_reg)___(mc_vmc_wl_num23_bank0)___13___13___RW___0x1FFF
// 0x48___(mc_vmc_wl_num22_23_bank0_reg)___(reserved)___26___6___NA___NA
// 0x4c___(mc_vmc_wl_num24_25_bank0_reg)___(mc_vmc_wl_num24_bank0)___0___13___RW___0x1FFF
// 0x4c___(mc_vmc_wl_num24_25_bank0_reg)___(mc_vmc_wl_num25_bank0)___13___13___RW___0x1FFF
// 0x4c___(mc_vmc_wl_num24_25_bank0_reg)___(reserved)___26___6___NA___NA
// 0x50___(mc_vmc_wl_num26_27_bank0_reg)___(mc_vmc_wl_num26_bank0)___0___13___RW___0x1FFF
// 0x50___(mc_vmc_wl_num26_27_bank0_reg)___(mc_vmc_wl_num27_bank0)___13___13___RW___0x1FFF
// 0x50___(mc_vmc_wl_num26_27_bank0_reg)___(reserved)___26___6___NA___NA
// 0x54___(mc_vmc_wl_num28_29_bank0_reg)___(mc_vmc_wl_num28_bank0)___0___13___RW___0x1FFF
// 0x54___(mc_vmc_wl_num28_29_bank0_reg)___(mc_vmc_wl_num29_bank0)___13___13___RW___0x1FFF
// 0x54___(mc_vmc_wl_num28_29_bank0_reg)___(reserved)___26___6___NA___NA
// 0x58___(mc_vmc_wl_num30_31_bank0_reg)___(mc_vmc_wl_num30_bank0)___0___13___RW___0x1FFF
// 0x58___(mc_vmc_wl_num30_31_bank0_reg)___(mc_vmc_wl_num31_bank0)___13___13___RW___0x1FFF
// 0x58___(mc_vmc_wl_num30_31_bank0_reg)___(reserved)___26___6___NA___NA
// 0x5c___(mc_vmc_wl_num32_33_bank0_reg)___(mc_vmc_wl_num32_bank0)___0___13___RW___0x1FFF
// 0x5c___(mc_vmc_wl_num32_33_bank0_reg)___(mc_vmc_wl_num33_bank0)___13___13___RW___0x1FFF
// 0x5c___(mc_vmc_wl_num32_33_bank0_reg)___(reserved)___26___6___NA___NA
// 0x60___(mc_vmc_wl_num34_35_bank0_reg)___(mc_vmc_wl_num34_bank0)___0___13___RW___0x1FFF
// 0x60___(mc_vmc_wl_num34_35_bank0_reg)___(mc_vmc_wl_num35_bank0)___13___13___RW___0x1FFF
// 0x60___(mc_vmc_wl_num34_35_bank0_reg)___(reserved)___26___6___NA___NA
// 0x64___(mc_vmc_wl_num36_37_bank0_reg)___(mc_vmc_wl_num36_bank0)___0___13___RW___0x1FFF
// 0x64___(mc_vmc_wl_num36_37_bank0_reg)___(mc_vmc_wl_num37_bank0)___13___13___RW___0x1FFF
// 0x64___(mc_vmc_wl_num36_37_bank0_reg)___(reserved)___26___6___NA___NA
// 0x68___(mc_vmc_wl_num38_39_bank0_reg)___(mc_vmc_wl_num38_bank0)___0___13___RW___0x1FFF
// 0x68___(mc_vmc_wl_num38_39_bank0_reg)___(mc_vmc_wl_num39_bank0)___13___13___RW___0x1FFF
// 0x68___(mc_vmc_wl_num38_39_bank0_reg)___(reserved)___26___6___NA___NA
// 0x6c___(mc_vmc_wl_num40_41_bank0_reg)___(mc_vmc_wl_num40_bank0)___0___13___RW___0x1FFF
// 0x6c___(mc_vmc_wl_num40_41_bank0_reg)___(mc_vmc_wl_num41_bank0)___13___13___RW___0x1FFF
// 0x6c___(mc_vmc_wl_num40_41_bank0_reg)___(reserved)___26___6___NA___NA
// 0x70___(mc_vmc_wl_num42_43_bank0_reg)___(mc_vmc_wl_num42_bank0)___0___13___RW___0x1FFF
// 0x70___(mc_vmc_wl_num42_43_bank0_reg)___(mc_vmc_wl_num43_bank0)___13___13___RW___0x1FFF
// 0x70___(mc_vmc_wl_num42_43_bank0_reg)___(reserved)___26___6___NA___NA
// 0x74___(mc_vmc_wl_num44_45_bank0_reg)___(mc_vmc_wl_num44_bank0)___0___13___RW___0x1FFF
// 0x74___(mc_vmc_wl_num44_45_bank0_reg)___(mc_vmc_wl_num45_bank0)___13___13___RW___0x1FFF
// 0x74___(mc_vmc_wl_num44_45_bank0_reg)___(reserved)___26___6___NA___NA
// 0x78___(mc_vmc_wl_num46_47_bank0_reg)___(mc_vmc_wl_num46_bank0)___0___13___RW___0x1FFF
// 0x78___(mc_vmc_wl_num46_47_bank0_reg)___(mc_vmc_wl_num47_bank0)___13___13___RW___0x1FFF
// 0x78___(mc_vmc_wl_num46_47_bank0_reg)___(reserved)___26___6___NA___NA
// 0x7c___(mc_vmc_wl_num48_49_bank0_reg)___(mc_vmc_wl_num48_bank0)___0___13___RW___0x1FFF
// 0x7c___(mc_vmc_wl_num48_49_bank0_reg)___(mc_vmc_wl_num49_bank0)___13___13___RW___0x1FFF
// 0x7c___(mc_vmc_wl_num48_49_bank0_reg)___(reserved)___26___6___NA___NA
// 0x80___(mc_vmc_wl_num50_51_bank0_reg)___(mc_vmc_wl_num50_bank0)___0___13___RW___0x1FFF
// 0x80___(mc_vmc_wl_num50_51_bank0_reg)___(mc_vmc_wl_num51_bank0)___13___13___RW___0x1FFF
// 0x80___(mc_vmc_wl_num50_51_bank0_reg)___(reserved)___26___6___NA___NA
// 0x84___(mc_vmc_wl_num52_53_bank0_reg)___(mc_vmc_wl_num52_bank0)___0___13___RW___0x1FFF
// 0x84___(mc_vmc_wl_num52_53_bank0_reg)___(mc_vmc_wl_num53_bank0)___13___13___RW___0x1FFF
// 0x84___(mc_vmc_wl_num52_53_bank0_reg)___(reserved)___26___6___NA___NA
// 0x88___(mc_vmc_wl_num54_55_bank0_reg)___(mc_vmc_wl_num54_bank0)___0___13___RW___0x1FFF
// 0x88___(mc_vmc_wl_num54_55_bank0_reg)___(mc_vmc_wl_num55_bank0)___13___13___RW___0x1FFF
// 0x88___(mc_vmc_wl_num54_55_bank0_reg)___(reserved)___26___6___NA___NA
// 0x8c___(mc_vmc_wl_num56_57_bank0_reg)___(mc_vmc_wl_num56_bank0)___0___13___RW___0x1FFF
// 0x8c___(mc_vmc_wl_num56_57_bank0_reg)___(mc_vmc_wl_num57_bank0)___13___13___RW___0x1FFF
// 0x8c___(mc_vmc_wl_num56_57_bank0_reg)___(reserved)___26___6___NA___NA
// 0x90___(mc_vmc_wl_num58_59_bank0_reg)___(mc_vmc_wl_num58_bank0)___0___13___RW___0x1FFF
// 0x90___(mc_vmc_wl_num58_59_bank0_reg)___(mc_vmc_wl_num59_bank0)___13___13___RW___0x1FFF
// 0x90___(mc_vmc_wl_num58_59_bank0_reg)___(reserved)___26___6___NA___NA
// 0x94___(mc_vmc_wl_num60_61_bank0_reg)___(mc_vmc_wl_num60_bank0)___0___13___RW___0x1FFF
// 0x94___(mc_vmc_wl_num60_61_bank0_reg)___(mc_vmc_wl_num61_bank0)___13___13___RW___0x1FFF
// 0x94___(mc_vmc_wl_num60_61_bank0_reg)___(reserved)___26___6___NA___NA
// 0x98___(mc_vmc_wl_num62_63_bank0_reg)___(mc_vmc_wl_num62_bank0)___0___13___RW___0x1FFF
// 0x98___(mc_vmc_wl_num62_63_bank0_reg)___(mc_vmc_wl_num63_bank0)___13___13___RW___0x1FFF
// 0x98___(mc_vmc_wl_num62_63_bank0_reg)___(reserved)___26___6___NA___NA
// 0x9c___(mc_vmc_bl_num0_part0_1_bank0_reg)___(mc_vmc_bl_num0_part0_bank0)___0___8___RW___0xFF
// 0x9c___(mc_vmc_bl_num0_part0_1_bank0_reg)___(mc_vmc_bl_num1_part0_bank0)___8___8___RW___0xFF
// 0x9c___(mc_vmc_bl_num0_part0_1_bank0_reg)___(mc_vmc_bl_num0_part1_bank0)___16___8___RW___0xFF
// 0x9c___(mc_vmc_bl_num0_part0_1_bank0_reg)___(mc_vmc_bl_num1_part1_bank0)___24___8___RW___0xFF
// 0xa0___(mc_vmc_bl_num0_part2_3_bank0_reg)___(mc_vmc_bl_num0_part2_bank0)___0___8___RW___0xFF
// 0xa0___(mc_vmc_bl_num0_part2_3_bank0_reg)___(mc_vmc_bl_num1_part2_bank0)___8___8___RW___0xFF
// 0xa0___(mc_vmc_bl_num0_part2_3_bank0_reg)___(mc_vmc_bl_num0_part3_bank0)___16___8___RW___0xFF
// 0xa0___(mc_vmc_bl_num0_part2_3_bank0_reg)___(mc_vmc_bl_num1_part3_bank0)___24___8___RW___0xFF
// 0xa4___(mc_vmc_bl_num0_part4_5_bank0_reg)___(mc_vmc_bl_num0_part4_bank0)___0___8___RW___0xFF
// 0xa4___(mc_vmc_bl_num0_part4_5_bank0_reg)___(mc_vmc_bl_num1_part4_bank0)___8___8___RW___0xFF
// 0xa4___(mc_vmc_bl_num0_part4_5_bank0_reg)___(mc_vmc_bl_num0_part5_bank0)___16___8___RW___0xFF
// 0xa4___(mc_vmc_bl_num0_part4_5_bank0_reg)___(mc_vmc_bl_num1_part5_bank0)___24___8___RW___0xFF
// 0xa8___(mc_vmc_bl_num0_part6_7_bank0_reg)___(mc_vmc_bl_num0_part6_bank0)___0___8___RW___0xFF
// 0xa8___(mc_vmc_bl_num0_part6_7_bank0_reg)___(mc_vmc_bl_num1_part6_bank0)___8___8___RW___0xFF
// 0xa8___(mc_vmc_bl_num0_part6_7_bank0_reg)___(mc_vmc_bl_num0_part7_bank0)___16___8___RW___0xFF
// 0xa8___(mc_vmc_bl_num0_part6_7_bank0_reg)___(mc_vmc_bl_num1_part7_bank0)___24___8___RW___0xFF
// 0xac___(mc_vmc_bl_num0_part8_9_bank0_reg)___(mc_vmc_bl_num0_part8_bank0)___0___8___RW___0xFF
// 0xac___(mc_vmc_bl_num0_part8_9_bank0_reg)___(mc_vmc_bl_num1_part8_bank0)___8___8___RW___0xFF
// 0xac___(mc_vmc_bl_num0_part8_9_bank0_reg)___(mc_vmc_bl_num0_part9_bank0)___16___8___RW___0xFF
// 0xac___(mc_vmc_bl_num0_part8_9_bank0_reg)___(mc_vmc_bl_num1_part9_bank0)___24___8___RW___0xFF
// 0xb0___(err_wl0_1_bank0_reg)___(err_wl0_bank0)___0___13___RO___0x1FFF
// 0xb0___(err_wl0_1_bank0_reg)___(err_wl1_bank0)___13___13___RO___0x1FFF
// 0xb0___(err_wl0_1_bank0_reg)___(reserved)___26___6___NA___NA
// 0xb4___(err_wl2_3_bank0_reg)___(err_wl2_bank0)___0___13___RO___0x1FFF
// 0xb4___(err_wl2_3_bank0_reg)___(err_wl3_bank0)___13___13___RO___0x1FFF
// 0xb4___(err_wl2_3_bank0_reg)___(reserved)___26___6___NA___NA
// 0xb8___(err_wl4_5_bank0_reg)___(err_wl4_bank0)___0___13___RO___0x1FFF
// 0xb8___(err_wl4_5_bank0_reg)___(err_wl5_bank0)___13___13___RO___0x1FFF
// 0xb8___(err_wl4_5_bank0_reg)___(reserved)___26___6___NA___NA
// 0xbc___(err_wl6_7_bank0_reg)___(err_wl6_bank0)___0___13___RO___0x1FFF
// 0xbc___(err_wl6_7_bank0_reg)___(err_wl7_bank0)___13___13___RO___0x1FFF
// 0xbc___(err_wl6_7_bank0_reg)___(reserved)___26___6___NA___NA
// 0xc0___(err_wl8_9_bank0_reg)___(err_wl8_bank0)___0___13___RO___0x1FFF
// 0xc0___(err_wl8_9_bank0_reg)___(err_wl9_bank0)___13___13___RO___0x1FFF
// 0xc0___(err_wl8_9_bank0_reg)___(reserved)___26___6___NA___NA
// 0xc4___(err_wl10_11_bank0_reg)___(err_wl10_bank0)___0___13___RO___0x1FFF
// 0xc4___(err_wl10_11_bank0_reg)___(err_wl11_bank0)___13___13___RO___0x1FFF
// 0xc4___(err_wl10_11_bank0_reg)___(reserved)___26___6___NA___NA
// 0xc8___(err_wl12_13_bank0_reg)___(err_wl12_bank0)___0___13___RO___0x1FFF
// 0xc8___(err_wl12_13_bank0_reg)___(err_wl13_bank0)___13___13___RO___0x1FFF
// 0xc8___(err_wl12_13_bank0_reg)___(reserved)___26___6___NA___NA
// 0xcc___(err_wl14_15_bank0_reg)___(err_wl14_bank0)___0___13___RO___0x1FFF
// 0xcc___(err_wl14_15_bank0_reg)___(err_wl15_bank0)___13___13___RO___0x1FFF
// 0xcc___(err_wl14_15_bank0_reg)___(reserved)___26___6___NA___NA
// 0xd0___(err_wl16_17_bank0_reg)___(err_wl16_bank0)___0___13___RO___0x1FFF
// 0xd0___(err_wl16_17_bank0_reg)___(err_wl17_bank0)___13___13___RO___0x1FFF
// 0xd0___(err_wl16_17_bank0_reg)___(reserved)___26___6___NA___NA
// 0xd4___(err_wl18_19_bank0_reg)___(err_wl18_bank0)___0___13___RO___0x1FFF
// 0xd4___(err_wl18_19_bank0_reg)___(err_wl19_bank0)___13___13___RO___0x1FFF
// 0xd4___(err_wl18_19_bank0_reg)___(reserved)___26___6___NA___NA
// 0xd8___(err_wl20_21_bank0_reg)___(err_wl20_bank0)___0___13___RO___0x1FFF
// 0xd8___(err_wl20_21_bank0_reg)___(err_wl21_bank0)___13___13___RO___0x1FFF
// 0xd8___(err_wl20_21_bank0_reg)___(reserved)___26___6___NA___NA
// 0xdc___(err_wl22_23_bank0_reg)___(err_wl22_bank0)___0___13___RO___0x1FFF
// 0xdc___(err_wl22_23_bank0_reg)___(err_wl23_bank0)___13___13___RO___0x1FFF
// 0xdc___(err_wl22_23_bank0_reg)___(reserved)___26___6___NA___NA
// 0xe0___(err_wl24_25_bank0_reg)___(err_wl24_bank0)___0___13___RO___0x1FFF
// 0xe0___(err_wl24_25_bank0_reg)___(err_wl25_bank0)___13___13___RO___0x1FFF
// 0xe0___(err_wl24_25_bank0_reg)___(reserved)___26___6___NA___NA
// 0xe4___(err_wl26_27_bank0_reg)___(err_wl26_bank0)___0___13___RO___0x1FFF
// 0xe4___(err_wl26_27_bank0_reg)___(err_wl27_bank0)___13___13___RO___0x1FFF
// 0xe4___(err_wl26_27_bank0_reg)___(reserved)___26___6___NA___NA
// 0xe8___(err_wl28_29_bank0_reg)___(err_wl28_bank0)___0___13___RO___0x1FFF
// 0xe8___(err_wl28_29_bank0_reg)___(err_wl29_bank0)___13___13___RO___0x1FFF
// 0xe8___(err_wl28_29_bank0_reg)___(reserved)___26___6___NA___NA
// 0xec___(err_wl30_31_bank0_reg)___(err_wl30_bank0)___0___13___RO___0x1FFF
// 0xec___(err_wl30_31_bank0_reg)___(err_wl31_bank0)___13___13___RO___0x1FFF
// 0xec___(err_wl30_31_bank0_reg)___(reserved)___26___6___NA___NA
// 0xf0___(err_wl32_33_bank0_reg)___(err_wl32_bank0)___0___13___RO___0x1FFF
// 0xf0___(err_wl32_33_bank0_reg)___(err_wl33_bank0)___13___13___RO___0x1FFF
// 0xf0___(err_wl32_33_bank0_reg)___(reserved)___26___6___NA___NA
// 0xf4___(err_wl34_35_bank0_reg)___(err_wl34_bank0)___0___13___RO___0x1FFF
// 0xf4___(err_wl34_35_bank0_reg)___(err_wl35_bank0)___13___13___RO___0x1FFF
// 0xf4___(err_wl34_35_bank0_reg)___(reserved)___26___6___NA___NA
// 0xf8___(err_wl36_37_bank0_reg)___(err_wl36_bank0)___0___13___RO___0x1FFF
// 0xf8___(err_wl36_37_bank0_reg)___(err_wl37_bank0)___13___13___RO___0x1FFF
// 0xf8___(err_wl36_37_bank0_reg)___(reserved)___26___6___NA___NA
// 0xfc___(err_wl38_39_bank0_reg)___(err_wl38_bank0)___0___13___RO___0x1FFF
// 0xfc___(err_wl38_39_bank0_reg)___(err_wl39_bank0)___13___13___RO___0x1FFF
// 0xfc___(err_wl38_39_bank0_reg)___(reserved)___26___6___NA___NA
// 0x100___(err_wl40_41_bank0_reg)___(err_wl40_bank0)___0___13___RO___0x1FFF
// 0x100___(err_wl40_41_bank0_reg)___(err_wl41_bank0)___13___13___RO___0x1FFF
// 0x100___(err_wl40_41_bank0_reg)___(reserved)___26___6___NA___NA
// 0x104___(err_wl42_43_bank0_reg)___(err_wl42_bank0)___0___13___RO___0x1FFF
// 0x104___(err_wl42_43_bank0_reg)___(err_wl43_bank0)___13___13___RO___0x1FFF
// 0x104___(err_wl42_43_bank0_reg)___(reserved)___26___6___NA___NA
// 0x108___(err_wl44_45_bank0_reg)___(err_wl44_bank0)___0___13___RO___0x1FFF
// 0x108___(err_wl44_45_bank0_reg)___(err_wl45_bank0)___13___13___RO___0x1FFF
// 0x108___(err_wl44_45_bank0_reg)___(reserved)___26___6___NA___NA
// 0x10c___(err_wl46_47_bank0_reg)___(err_wl46_bank0)___0___13___RO___0x1FFF
// 0x10c___(err_wl46_47_bank0_reg)___(err_wl47_bank0)___13___13___RO___0x1FFF
// 0x10c___(err_wl46_47_bank0_reg)___(reserved)___26___6___NA___NA
// 0x110___(err_wl48_49_bank0_reg)___(err_wl48_bank0)___0___13___RO___0x1FFF
// 0x110___(err_wl48_49_bank0_reg)___(err_wl49_bank0)___13___13___RO___0x1FFF
// 0x110___(err_wl48_49_bank0_reg)___(reserved)___26___6___NA___NA
// 0x114___(err_wl50_51_bank0_reg)___(err_wl50_bank0)___0___13___RO___0x1FFF
// 0x114___(err_wl50_51_bank0_reg)___(err_wl51_bank0)___13___13___RO___0x1FFF
// 0x114___(err_wl50_51_bank0_reg)___(reserved)___26___6___NA___NA
// 0x118___(err_wl52_53_bank0_reg)___(err_wl52_bank0)___0___13___RO___0x1FFF
// 0x118___(err_wl52_53_bank0_reg)___(err_wl53_bank0)___13___13___RO___0x1FFF
// 0x118___(err_wl52_53_bank0_reg)___(reserved)___26___6___NA___NA
// 0x11c___(err_wl54_55_bank0_reg)___(err_wl54_bank0)___0___13___RO___0x1FFF
// 0x11c___(err_wl54_55_bank0_reg)___(err_wl55_bank0)___13___13___RO___0x1FFF
// 0x11c___(err_wl54_55_bank0_reg)___(reserved)___26___6___NA___NA
// 0x120___(err_wl56_57_bank0_reg)___(err_wl56_bank0)___0___13___RO___0x1FFF
// 0x120___(err_wl56_57_bank0_reg)___(err_wl57_bank0)___13___13___RO___0x1FFF
// 0x120___(err_wl56_57_bank0_reg)___(reserved)___26___6___NA___NA
// 0x124___(err_wl58_59_bank0_reg)___(err_wl58_bank0)___0___13___RO___0x1FFF
// 0x124___(err_wl58_59_bank0_reg)___(err_wl59_bank0)___13___13___RO___0x1FFF
// 0x124___(err_wl58_59_bank0_reg)___(reserved)___26___6___NA___NA
// 0x128___(err_wl60_61_bank0_reg)___(err_wl60_bank0)___0___13___RO___0x1FFF
// 0x128___(err_wl60_61_bank0_reg)___(err_wl61_bank0)___13___13___RO___0x1FFF
// 0x128___(err_wl60_61_bank0_reg)___(reserved)___26___6___NA___NA
// 0x12c___(err_wl62_63_bank0_reg)___(err_wl62_bank0)___0___13___RO___0x1FFF
// 0x12c___(err_wl62_63_bank0_reg)___(err_wl63_bank0)___13___13___RO___0x1FFF
// 0x12c___(err_wl62_63_bank0_reg)___(reserved)___26___6___NA___NA
// 0x130___(err_csl_part0_1_bank0_reg)___(err_csl0_part0_bank0)___0___8___RO___0xFF
// 0x130___(err_csl_part0_1_bank0_reg)___(err_csl1_part0_bank0)___8___8___RO___0xFF
// 0x130___(err_csl_part0_1_bank0_reg)___(err_csl0_part1_bank0)___16___8___RO___0xFF
// 0x130___(err_csl_part0_1_bank0_reg)___(err_csl1_part1_bank0)___24___8___RO___0xFF
// 0x134___(err_csl_part2_3_bank0_reg)___(err_csl0_part2_bank0)___0___8___RO___0xFF
// 0x134___(err_csl_part2_3_bank0_reg)___(err_csl1_part2_bank0)___8___8___RO___0xFF
// 0x134___(err_csl_part2_3_bank0_reg)___(err_csl0_part3_bank0)___16___8___RO___0xFF
// 0x134___(err_csl_part2_3_bank0_reg)___(err_csl1_part3_bank0)___24___8___RO___0xFF
// 0x138___(err_csl_part4_5_bank0_reg)___(err_csl0_part4_bank0)___0___8___RO___0xFF
// 0x138___(err_csl_part4_5_bank0_reg)___(err_csl1_part4_bank0)___8___8___RO___0xFF
// 0x138___(err_csl_part4_5_bank0_reg)___(err_csl0_part5_bank0)___16___8___RO___0xFF
// 0x138___(err_csl_part4_5_bank0_reg)___(err_csl1_part5_bank0)___24___8___RO___0xFF
// 0x13c___(err_csl_part6_7_bank0_reg)___(err_csl0_part6_bank0)___0___8___RO___0xFF
// 0x13c___(err_csl_part6_7_bank0_reg)___(err_csl1_part6_bank0)___8___8___RO___0xFF
// 0x13c___(err_csl_part6_7_bank0_reg)___(err_csl0_part7_bank0)___16___8___RO___0xFF
// 0x13c___(err_csl_part6_7_bank0_reg)___(err_csl1_part7_bank0)___24___8___RO___0xFF
// 0x140___(err_csl_part8_9_bank0_reg)___(err_csl0_part8_bank0)___0___8___RO___0xFF
// 0x140___(err_csl_part8_9_bank0_reg)___(err_csl1_part8_bank0)___8___8___RO___0xFF
// 0x140___(err_csl_part8_9_bank0_reg)___(err_csl0_part9_bank0)___16___8___RO___0xFF
// 0x140___(err_csl_part8_9_bank0_reg)___(err_csl1_part9_bank0)___24___8___RO___0xFF
// 0x144___(mc_bank_cfg_reg_reg)___(mc_bank_map_id)___0___8___RW___0xE4
// 0x144___(mc_bank_cfg_reg_reg)___(mc_bist_grant)___8___4___RW___0xF
// 0x144___(mc_bank_cfg_reg_reg)___(reserved)___12___20___NA___NA
// 0x148___(mc_timeout_clr_reg)___(mc_timeout_clr)___0___1___W1C___0x0
// 0x148___(mc_timeout_clr_reg)___(reserved)___1___31___NA___NA
// 0x14c___(mc_rf_start_dbg_reg)___(mc_rf_start_dbg)___0___1___RO___0x0
// 0x14c___(mc_rf_start_dbg_reg)___(reserved)___1___31___NA___NA
// 0x150___(mc_timeout_flag_reg)___(mc_timeout_flag)___0___1___RO___0x0
// 0x150___(mc_timeout_flag_reg)___(reserved)___1___31___NA___NA
// 0x154___(mc_bist_status_reg)___(mc_bist_status)___0___3___RO___0x0
// 0x154___(mc_bist_status_reg)___(mc_bist_path_fail_bank0)___3___1___RO___0x0
// 0x154___(mc_bist_status_reg)___(dram_init_finish)___4___1___RO___0x0
// 0x154___(mc_bist_status_reg)___(reserved)___5___27___NA___NA
// 0x158___(bist_finish_and_success_reg)___(bist_finish_bank0)___0___1___RO___0x0
// 0x158___(bist_finish_and_success_reg)___(bist_rescan_finish_bank0)___1___1___RO___0x0
// 0x158___(bist_finish_and_success_reg)___(bank_success_bank0)___2___1___RO___0x0
// 0x158___(bist_finish_and_success_reg)___(bist_rescan_success_bank0)___3___1___RO___0x0
// 0x158___(bist_finish_and_success_reg)___(reserved)___4___28___NA___NA
// 0x15c___(mc_bist_rescan_fail_num_bank0_reg)___(mc_bist_rescan_fail_num_bank0)___0___20___RO___0x0
// 0x15c___(mc_bist_rescan_fail_num_bank0_reg)___(reserved)___20___12___NA___NA
// 0x16c___(mc_bist_err_wl_reg)___(mc_bist_err_wl_num_bank0)___0___7___RO___0x0
// 0x16c___(mc_bist_err_wl_reg)___(err_wl_num_change_flag_bank0)___7___1___RO___0x0
// 0x16c___(mc_bist_err_wl_reg)___(reserved)___8___24___NA___NA
// 0x170___(rescan_finish_clr_reg)___(rescan_finish_clr)___0___1___W1C___0x0
// 0x170___(rescan_finish_clr_reg)___(reserved)___1___31___NA___NA
// 0x174___(rescan_finish_mask_reg)___(rescan_finish_mask)___0___1___RW___0x1
// 0x174___(rescan_finish_mask_reg)___(reserved)___1___31___NA___NA
// 0x178___(rescan_round_result_1_reg)___(rescan_round_result_bank0)___0___15___RO___0x0
// 0x178___(rescan_round_result_1_reg)___(reserved)___15___17___NA___NA
// 0x180___(bist_finish_clr_reg)___(bist_finish_clr)___0___1___W1C___0x0
// 0x180___(bist_finish_clr_reg)___(reserved)___1___31___NA___NA
// 0x184___(bist_finish_mask_reg)___(bist_finish_mask)___0___1___RW___0x1
// 0x184___(bist_finish_mask_reg)___(reserved)___1___31___NA___NA
// 0x188___(hang_timeout_th_reg)___(hang_timeout_th)___0___32___RW___0x186a00
// 0x18c___(bist_pattern_reg0_reg)___(bist_pattern_reg0)___0___32___RW___0x0
// 0x190___(bist_pattern_reg1_reg)___(bist_pattern_reg1)___0___32___RW___0x0
// 0x194___(bist_pattern_reg2_reg)___(bist_pattern_reg2)___0___32___RW___0x0
// 0x198___(bist_pattern_reg3_reg)___(bist_pattern_reg3)___0___32___RW___0x0
// 0x19c___(csl_bist_pattern_sel0_reg)___(csl_bist_pattern_sel0)___0___32___RW___0xFFFFFFFF
// 0x1a0___(csl_bist_pattern_sel1_reg)___(csl_bist_pattern_sel1)___0___32___RW___0xFFFFFFFF
// 0x1a4___(csl_bist_pattern_sel2_reg)___(csl_bist_pattern_sel2)___0___4___RW___0x0
// 0x1a4___(csl_bist_pattern_sel2_reg)___(reserved)___4___28___NA___NA
// 0x1a8___(wl_bist_pattern_sel0_reg)___(wl_bist_pattern_sel0)___0___32___RW___0xFFFFFFFF
// 0x1ac___(wl_bist_pattern_sel1_reg)___(wl_bist_pattern_sel1)___0___32___RW___0xFFFFFFFF
// 0x1b0___(wl_bist_pattern_sel2_reg)___(wl_bist_pattern_sel2)___0___4___RW___0x0
// 0x1b0___(wl_bist_pattern_sel2_reg)___(reserved)___4___28___NA___NA
// 0x1b4___(mc_frame2array_dbg_reg)___(dbg_next_state_array)___0___5___RO___0x0
// 0x1b4___(mc_frame2array_dbg_reg)___(reserved)___5___3___NA___NA
// 0x1b4___(mc_frame2array_dbg_reg)___(dbg_current_state_array)___8___5___RO___0x0
// 0x1b4___(mc_frame2array_dbg_reg)___(reserved)___13___3___NA___NA
// 0x1b4___(mc_frame2array_dbg_reg)___(dbg_r_data_cnt)___16___2___RO___0x0
// 0x1b4___(mc_frame2array_dbg_reg)___(reserved)___18___2___NA___NA
// 0x1b4___(mc_frame2array_dbg_reg)___(dbg_refresh_flag)___20___1___RO___0x0
// 0x1b4___(mc_frame2array_dbg_reg)___(reserved)___21___3___NA___NA
// 0x1b4___(mc_frame2array_dbg_reg)___(dbg_r_frame_cnt)___24___2___RO___0x0
// 0x1b4___(mc_frame2array_dbg_reg)___(reserved)___26___2___NA___NA
// 0x1b4___(mc_frame2array_dbg_reg)___(dbg_w_frame_cnt)___28___2___RO___0x0
// 0x1b4___(mc_frame2array_dbg_reg)___(reserved)___30___2___NA___NA
// 0x1b8___(dbg_frame_store_0_reg)___(dbg_frame_store_0)___0___32___RO___0x0
// 0x1bc___(dbg_frame_store_1_reg)___(dbg_frame_store_1)___0___32___RO___0x0
// 0x1c0___(dbg_frame_store_2_reg)___(dbg_frame_store_2)___0___32___RO___0x0
// 0x1c4___(dbg_frame_store_3_reg)___(dbg_frame_store_3)___0___32___RO___0x0
// 0x1c8___(dbg_frame_store_4_reg)___(dbg_frame_store_4)___0___32___RO___0x0
// 0x1cc___(dbg_frame_store_5_reg)___(dbg_frame_store_5)___0___32___RO___0x0
// 0x1d0___(dbg_frame_store_6_reg)___(dbg_frame_store_6)___0___32___RO___0x0
// 0x1d4___(dbg_frame_store_7_reg)___(dbg_frame_store_7)___0___32___RO___0x0
// 0x1d8___(dbg_frame_store_8_reg)___(dbg_frame_store_8)___0___32___RO___0x0
// 0x1dc___(dbg_frame_store_9_reg)___(dbg_frame_store_9)___0___2___RO___0x0
// 0x1dc___(dbg_frame_store_9_reg)___(reserved)___2___30___NA___NA
// 0x1e0___(dbg_rdata_store_0_reg)___(dbg_rdata_store_0)___0___32___RO___0x0
// 0x1e4___(dbg_rdata_store_1_reg)___(dbg_rdata_store_1)___0___32___RO___0x0
// 0x1e8___(dbg_rdata_store_2_reg)___(dbg_rdata_store_2)___0___32___RO___0x0
// 0x1ec___(dbg_rdata_store_3_reg)___(dbg_rdata_store_3)___0___32___RO___0x0
// 0x1f0___(dbg_rdata_store_4_reg)___(dbg_rdata_store_4)___0___32___RO___0x0
// 0x1f4___(dbg_rdata_store_5_reg)___(dbg_rdata_store_5)___0___32___RO___0x0
// 0x1f8___(dbg_rdata_store_6_reg)___(dbg_rdata_store_6)___0___32___RO___0x0
// 0x1fc___(dbg_rdata_store_7_reg)___(dbg_rdata_store_7)___0___32___RO___0x0
// 0x200___(dbg_rdata_store_8_reg)___(dbg_rdata_store_8)___0___10___RO___0x0
// 0x200___(dbg_rdata_store_8_reg)___(reserved)___10___22___NA___NA
// 0x204___(mc_ecc_ce_ctrl_reg)___(mc_ecc_ce_int_clr)___0___1___W1C___0x0
// 0x204___(mc_ecc_ce_ctrl_reg)___(reserved)___1___3___NA___NA
// 0x204___(mc_ecc_ce_ctrl_reg)___(mc_ecc_ce_overflow_int)___4___1___RO___0x0
// 0x204___(mc_ecc_ce_ctrl_reg)___(reserved)___5___3___NA___NA
// 0x204___(mc_ecc_ce_ctrl_reg)___(mc_ecc_ce_th)___8___5___RW___0x5
// 0x204___(mc_ecc_ce_ctrl_reg)___(reserved)___13___3___NA___NA
// 0x204___(mc_ecc_ce_ctrl_reg)___(mc_ecc_ce_cnt)___16___5___RO___0x0
// 0x204___(mc_ecc_ce_ctrl_reg)___(reserved)___21___3___NA___NA
// 0x204___(mc_ecc_ce_ctrl_reg)___(mc_ecc_ce_int_mask)___24___1___RW___0x0
// 0x204___(mc_ecc_ce_ctrl_reg)___(reserved)___25___7___NA___NA
// 0x208___(mc_ecc_ce_addr0_reg)___(mc_ecc_ce_addr0)___0___22___RO___0x3FFFFF
// 0x208___(mc_ecc_ce_addr0_reg)___(mc_ecc_ce_addr_vld0)___22___1___RO___0x0
// 0x208___(mc_ecc_ce_addr0_reg)___(reserved)___23___1___NA___NA
// 0x208___(mc_ecc_ce_addr0_reg)___(mc_ecc_ce_addr_cnt0)___24___8___RO___0x0
// 0x20c___(mc_ecc_ce_addr1_reg)___(mc_ecc_ce_addr1)___0___22___RO___0x3FFFFF
// 0x20c___(mc_ecc_ce_addr1_reg)___(mc_ecc_ce_addr_vld1)___22___1___RO___0x0
// 0x20c___(mc_ecc_ce_addr1_reg)___(reserved)___23___1___NA___NA
// 0x20c___(mc_ecc_ce_addr1_reg)___(mc_ecc_ce_addr_cnt1)___24___8___RO___0x0
// 0x210___(mc_ecc_ce_addr2_reg)___(mc_ecc_ce_addr2)___0___22___RO___0x3FFFFF
// 0x210___(mc_ecc_ce_addr2_reg)___(mc_ecc_ce_addr_vld2)___22___1___RO___0x0
// 0x210___(mc_ecc_ce_addr2_reg)___(reserved)___23___1___NA___NA
// 0x210___(mc_ecc_ce_addr2_reg)___(mc_ecc_ce_addr_cnt2)___24___8___RO___0x0
// 0x214___(mc_ecc_ce_addr3_reg)___(mc_ecc_ce_addr3)___0___22___RO___0x3FFFFF
// 0x214___(mc_ecc_ce_addr3_reg)___(mc_ecc_ce_addr_vld3)___22___1___RO___0x0
// 0x214___(mc_ecc_ce_addr3_reg)___(reserved)___23___1___NA___NA
// 0x214___(mc_ecc_ce_addr3_reg)___(mc_ecc_ce_addr_cnt3)___24___8___RO___0x0
// 0x218___(mc_ecc_ce_addr4_reg)___(mc_ecc_ce_addr4)___0___22___RO___0x3FFFFF
// 0x218___(mc_ecc_ce_addr4_reg)___(mc_ecc_ce_addr_vld4)___22___1___RO___0x0
// 0x218___(mc_ecc_ce_addr4_reg)___(reserved)___23___1___NA___NA
// 0x218___(mc_ecc_ce_addr4_reg)___(mc_ecc_ce_addr_cnt4)___24___8___RO___0x0
// 0x21c___(mc_ecc_ce_addr5_reg)___(mc_ecc_ce_addr5)___0___22___RO___0x3FFFFF
// 0x21c___(mc_ecc_ce_addr5_reg)___(mc_ecc_ce_addr_vld5)___22___1___RO___0x0
// 0x21c___(mc_ecc_ce_addr5_reg)___(reserved)___23___1___NA___NA
// 0x21c___(mc_ecc_ce_addr5_reg)___(mc_ecc_ce_addr_cnt5)___24___8___RO___0x0
// 0x220___(mc_ecc_ce_addr6_reg)___(mc_ecc_ce_addr6)___0___22___RO___0x3FFFFF
// 0x220___(mc_ecc_ce_addr6_reg)___(mc_ecc_ce_addr_vld6)___22___1___RO___0x0
// 0x220___(mc_ecc_ce_addr6_reg)___(reserved)___23___1___NA___NA
// 0x220___(mc_ecc_ce_addr6_reg)___(mc_ecc_ce_addr_cnt6)___24___8___RO___0x0
// 0x224___(mc_ecc_ce_addr7_reg)___(mc_ecc_ce_addr7)___0___22___RO___0x3FFFFF
// 0x224___(mc_ecc_ce_addr7_reg)___(mc_ecc_ce_addr_vld7)___22___1___RO___0x0
// 0x224___(mc_ecc_ce_addr7_reg)___(reserved)___23___1___NA___NA
// 0x224___(mc_ecc_ce_addr7_reg)___(mc_ecc_ce_addr_cnt7)___24___8___RO___0x0
// 0x228___(mc_ecc_ce_addr8_reg)___(mc_ecc_ce_addr8)___0___22___RO___0x3FFFFF
// 0x228___(mc_ecc_ce_addr8_reg)___(mc_ecc_ce_addr_vld8)___22___1___RO___0x0
// 0x228___(mc_ecc_ce_addr8_reg)___(reserved)___23___1___NA___NA
// 0x228___(mc_ecc_ce_addr8_reg)___(mc_ecc_ce_addr_cnt8)___24___8___RO___0x0
// 0x22c___(mc_ecc_ce_addr9_reg)___(mc_ecc_ce_addr9)___0___22___RO___0x3FFFFF
// 0x22c___(mc_ecc_ce_addr9_reg)___(mc_ecc_ce_addr_vld9)___22___1___RO___0x0
// 0x22c___(mc_ecc_ce_addr9_reg)___(reserved)___23___1___NA___NA
// 0x22c___(mc_ecc_ce_addr9_reg)___(mc_ecc_ce_addr_cnt9)___24___8___RO___0x0
// 0x230___(mc_ecc_ce_addr10_reg)___(mc_ecc_ce_addr10)___0___22___RO___0x3FFFFF
// 0x230___(mc_ecc_ce_addr10_reg)___(mc_ecc_ce_addr_vld10)___22___1___RO___0x0
// 0x230___(mc_ecc_ce_addr10_reg)___(reserved)___23___1___NA___NA
// 0x230___(mc_ecc_ce_addr10_reg)___(mc_ecc_ce_addr_cnt10)___24___8___RO___0x0
// 0x234___(mc_ecc_ce_addr11_reg)___(mc_ecc_ce_addr11)___0___22___RO___0x3FFFFF
// 0x234___(mc_ecc_ce_addr11_reg)___(mc_ecc_ce_addr_vld11)___22___1___RO___0x0
// 0x234___(mc_ecc_ce_addr11_reg)___(reserved)___23___1___NA___NA
// 0x234___(mc_ecc_ce_addr11_reg)___(mc_ecc_ce_addr_cnt11)___24___8___RO___0x0
// 0x238___(mc_ecc_ce_addr12_reg)___(mc_ecc_ce_addr12)___0___22___RO___0x3FFFFF
// 0x238___(mc_ecc_ce_addr12_reg)___(mc_ecc_ce_addr_vld12)___22___1___RO___0x0
// 0x238___(mc_ecc_ce_addr12_reg)___(reserved)___23___1___NA___NA
// 0x238___(mc_ecc_ce_addr12_reg)___(mc_ecc_ce_addr_cnt12)___24___8___RO___0x0
// 0x23c___(mc_ecc_ce_addr13_reg)___(mc_ecc_ce_addr13)___0___22___RO___0x3FFFFF
// 0x23c___(mc_ecc_ce_addr13_reg)___(mc_ecc_ce_addr_vld13)___22___1___RO___0x0
// 0x23c___(mc_ecc_ce_addr13_reg)___(reserved)___23___1___NA___NA
// 0x23c___(mc_ecc_ce_addr13_reg)___(mc_ecc_ce_addr_cnt13)___24___8___RO___0x0
// 0x240___(mc_ecc_ce_addr14_reg)___(mc_ecc_ce_addr14)___0___22___RO___0x3FFFFF
// 0x240___(mc_ecc_ce_addr14_reg)___(mc_ecc_ce_addr_vld14)___22___1___RO___0x0
// 0x240___(mc_ecc_ce_addr14_reg)___(reserved)___23___1___NA___NA
// 0x240___(mc_ecc_ce_addr14_reg)___(mc_ecc_ce_addr_cnt14)___24___8___RO___0x0
// 0x244___(mc_ecc_ce_addr15_reg)___(mc_ecc_ce_addr15)___0___22___RO___0x3FFFFF
// 0x244___(mc_ecc_ce_addr15_reg)___(mc_ecc_ce_addr_vld15)___22___1___RO___0x0
// 0x244___(mc_ecc_ce_addr15_reg)___(reserved)___23___1___NA___NA
// 0x244___(mc_ecc_ce_addr15_reg)___(mc_ecc_ce_addr_cnt15)___24___8___RO___0x0
// 0x248___(mc_ecc_uce_ctrl_reg)___(mc_ecc_uce_int_clr)___0___1___W1C___0x0
// 0x248___(mc_ecc_uce_ctrl_reg)___(reserved)___1___3___NA___NA
// 0x248___(mc_ecc_uce_ctrl_reg)___(mc_ecc_uce_int)___4___1___RO___0x0
// 0x248___(mc_ecc_uce_ctrl_reg)___(reserved)___5___3___NA___NA
// 0x248___(mc_ecc_uce_ctrl_reg)___(mc_ecc_uce_cnt)___8___3___RO___0x0
// 0x248___(mc_ecc_uce_ctrl_reg)___(reserved)___11___1___NA___NA
// 0x248___(mc_ecc_uce_ctrl_reg)___(mc_ecc_uce_int_mask)___12___1___RW___0x0
// 0x248___(mc_ecc_uce_ctrl_reg)___(reserved)___13___19___NA___NA
// 0x24c___(mc_ecc_uce_addr0_reg)___(mc_ecc_uce_addr0)___0___22___RO___0x3FFFFF
// 0x24c___(mc_ecc_uce_addr0_reg)___(mc_ecc_uce_addr_vld0)___22___1___RO___0x0
// 0x24c___(mc_ecc_uce_addr0_reg)___(reserved)___23___9___NA___NA
// 0x250___(mc_ecc_uce_addr1_reg)___(mc_ecc_uce_addr1)___0___22___RO___0x3FFFFF
// 0x250___(mc_ecc_uce_addr1_reg)___(mc_ecc_uce_addr_vld1)___22___1___RO___0x0
// 0x250___(mc_ecc_uce_addr1_reg)___(reserved)___23___9___NA___NA
// 0x254___(mc_ecc_uce_addr2_reg)___(mc_ecc_uce_addr2)___0___22___RO___0x3FFFFF
// 0x254___(mc_ecc_uce_addr2_reg)___(mc_ecc_uce_addr_vld2)___22___1___RO___0x0
// 0x254___(mc_ecc_uce_addr2_reg)___(reserved)___23___9___NA___NA
// 0x258___(mc_ecc_uce_addr3_reg)___(mc_ecc_uce_addr3)___0___22___RO___0x3FFFFF
// 0x258___(mc_ecc_uce_addr3_reg)___(mc_ecc_uce_addr_vld3)___22___1___RO___0x0
// 0x258___(mc_ecc_uce_addr3_reg)___(reserved)___23___9___NA___NA
// 0x25c___(mc_page_status_reg)___(mc_page_status)___0___1___RO___0x1
// 0x25c___(mc_page_status_reg)___(reserved)___1___31___NA___reserved
// 0x260___(hang_timeout_status_reg)___(hang_timeout_status)___0___1___RO___0x0
// 0x260___(hang_timeout_status_reg)___(reserved)___1___31___NA___NA
// 0x264___(hang_timeout_mask_reg)___(hang_timeout_mask)___0___1___RW___0x1
// 0x264___(hang_timeout_mask_reg)___(reserved)___1___31___NA___NA
// 0x268___(hang_timeout_clr_reg)___(hang_timeout_clr)___0___1___W1C___0x0
// 0x268___(hang_timeout_clr_reg)___(reserved)___1___31___NA___NA
// 0x26c___(hang_timeout_en_reg)___(hang_timeout_en)___0___1___RW___0x1
// 0x26c___(hang_timeout_en_reg)___(reserved)___1___31___NA___NA
// 0x270___(bist_clk_cnt_reg)___(bist_clk_cnt)___0___32___RO___0x0
