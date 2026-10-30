


module apb2reg_mc_top_aux_cfg_if #(
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

    // special input port 
    // register name : mc_id_reg , address:0x0
    input  [31:0]                        mc_id_i,// read only signal
    // register name : err_wl0_1_reg , address:0xb0
    input  [12:0]                        err_wl0_i,// read only signal
    input  [12:0]                        err_wl1_i,// read only signal
    // register name : err_wl2_3_reg , address:0xb4
    input  [12:0]                        err_wl2_i,// read only signal
    input  [12:0]                        err_wl3_i,// read only signal
    // register name : err_wl4_5_reg , address:0xb8
    input  [12:0]                        err_wl4_i,// read only signal
    input  [12:0]                        err_wl5_i,// read only signal
    // register name : err_wl6_7_reg , address:0xbc
    input  [12:0]                        err_wl6_i,// read only signal
    input  [12:0]                        err_wl7_i,// read only signal
    // register name : err_wl8_9_reg , address:0xc0
    input  [12:0]                        err_wl8_i,// read only signal
    input  [12:0]                        err_wl9_i,// read only signal
    // register name : err_wl10_11_reg , address:0xc4
    input  [12:0]                        err_wl10_i,// read only signal
    input  [12:0]                        err_wl11_i,// read only signal
    // register name : err_wl12_13_reg , address:0xc8
    input  [12:0]                        err_wl12_i,// read only signal
    input  [12:0]                        err_wl13_i,// read only signal
    // register name : err_wl14_15_reg , address:0xcc
    input  [12:0]                        err_wl14_i,// read only signal
    input  [12:0]                        err_wl15_i,// read only signal
    // register name : err_wl16_17_reg , address:0xd0
    input  [12:0]                        err_wl16_i,// read only signal
    input  [12:0]                        err_wl17_i,// read only signal
    // register name : err_wl18_19_reg , address:0xd4
    input  [12:0]                        err_wl18_i,// read only signal
    input  [12:0]                        err_wl19_i,// read only signal
    // register name : err_wl20_21_reg , address:0xd8
    input  [12:0]                        err_wl20_i,// read only signal
    input  [12:0]                        err_wl21_i,// read only signal
    // register name : err_wl22_23_reg , address:0xdc
    input  [12:0]                        err_wl22_i,// read only signal
    input  [12:0]                        err_wl23_i,// read only signal
    // register name : err_wl24_25_reg , address:0xe0
    input  [12:0]                        err_wl24_i,// read only signal
    input  [12:0]                        err_wl25_i,// read only signal
    // register name : err_wl26_27_reg , address:0xe4
    input  [12:0]                        err_wl26_i,// read only signal
    input  [12:0]                        err_wl27_i,// read only signal
    // register name : err_wl28_29_reg , address:0xe8
    input  [12:0]                        err_wl28_i,// read only signal
    input  [12:0]                        err_wl29_i,// read only signal
    // register name : err_wl30_31_reg , address:0xec
    input  [12:0]                        err_wl30_i,// read only signal
    input  [12:0]                        err_wl31_i,// read only signal
    // register name : err_wl32_33_reg , address:0xf0
    input  [12:0]                        err_wl32_i,// read only signal
    input  [12:0]                        err_wl33_i,// read only signal
    // register name : err_wl34_35_reg , address:0xf4
    input  [12:0]                        err_wl34_i,// read only signal
    input  [12:0]                        err_wl35_i,// read only signal
    // register name : err_wl36_37_reg , address:0xf8
    input  [12:0]                        err_wl36_i,// read only signal
    input  [12:0]                        err_wl37_i,// read only signal
    // register name : err_wl38_39_reg , address:0xfc
    input  [12:0]                        err_wl38_i,// read only signal
    input  [12:0]                        err_wl39_i,// read only signal
    // register name : err_wl40_41_reg , address:0x100
    input  [12:0]                        err_wl40_i,// read only signal
    input  [12:0]                        err_wl41_i,// read only signal
    // register name : err_wl42_43_reg , address:0x104
    input  [12:0]                        err_wl42_i,// read only signal
    input  [12:0]                        err_wl43_i,// read only signal
    // register name : err_wl44_45_reg , address:0x108
    input  [12:0]                        err_wl44_i,// read only signal
    input  [12:0]                        err_wl45_i,// read only signal
    // register name : err_wl46_47_reg , address:0x10c
    input  [12:0]                        err_wl46_i,// read only signal
    input  [12:0]                        err_wl47_i,// read only signal
    // register name : err_wl48_49_reg , address:0x110
    input  [12:0]                        err_wl48_i,// read only signal
    input  [12:0]                        err_wl49_i,// read only signal
    // register name : err_wl50_51_reg , address:0x114
    input  [12:0]                        err_wl50_i,// read only signal
    input  [12:0]                        err_wl51_i,// read only signal
    // register name : err_wl52_53_reg , address:0x118
    input  [12:0]                        err_wl52_i,// read only signal
    input  [12:0]                        err_wl53_i,// read only signal
    // register name : err_wl54_55_reg , address:0x11c
    input  [12:0]                        err_wl54_i,// read only signal
    input  [12:0]                        err_wl55_i,// read only signal
    // register name : err_wl56_57_reg , address:0x120
    input  [12:0]                        err_wl56_i,// read only signal
    input  [12:0]                        err_wl57_i,// read only signal
    // register name : err_wl58_59_reg , address:0x124
    input  [12:0]                        err_wl58_i,// read only signal
    input  [12:0]                        err_wl59_i,// read only signal
    // register name : err_wl60_61_reg , address:0x128
    input  [12:0]                        err_wl60_i,// read only signal
    input  [12:0]                        err_wl61_i,// read only signal
    // register name : err_wl62_63_reg , address:0x12c
    input  [12:0]                        err_wl62_i,// read only signal
    input  [12:0]                        err_wl63_i,// read only signal
    // register name : err_csl_part0_1_reg , address:0x130
    input  [7:0]                        err_csl0_part0_i,// read only signal
    input  [7:0]                        err_csl1_part0_i,// read only signal
    input  [7:0]                        err_csl0_part1_i,// read only signal
    input  [7:0]                        err_csl1_part1_i,// read only signal
    // register name : err_csl_part2_3_reg , address:0x134
    input  [7:0]                        err_csl0_part2_i,// read only signal
    input  [7:0]                        err_csl1_part2_i,// read only signal
    input  [7:0]                        err_csl0_part3_i,// read only signal
    input  [7:0]                        err_csl1_part3_i,// read only signal
    // register name : err_csl_part4_5_reg , address:0x138
    input  [7:0]                        err_csl0_part4_i,// read only signal
    input  [7:0]                        err_csl1_part4_i,// read only signal
    input  [7:0]                        err_csl0_part5_i,// read only signal
    input  [7:0]                        err_csl1_part5_i,// read only signal
    // register name : err_csl_part6_7_reg , address:0x13c
    input  [7:0]                        err_csl0_part6_i,// read only signal
    input  [7:0]                        err_csl1_part6_i,// read only signal
    input  [7:0]                        err_csl0_part7_i,// read only signal
    input  [7:0]                        err_csl1_part7_i,// read only signal
    // register name : err_csl_part8_9_reg , address:0x140
    input  [7:0]                        err_csl0_part8_i,// read only signal
    input  [7:0]                        err_csl1_part8_i,// read only signal
    input  [7:0]                        err_csl0_part9_i,// read only signal
    input  [7:0]                        err_csl1_part9_i,// read only signal
    // register name : mc_rf_start_dbg_reg , address:0x148
    input                        mc_rf_start_dbg_i,// read only signal
    // register name : mc_timeout_flag_reg , address:0x14c
    input                        mc_timeout_flag_i,// read only signal
    // register name : mc_bist_status_reg , address:0x150
    input  [2:0]                        mc_bist_status_i,// read only signal
    input                        mc_bist_path_fail_i,// read only signal
    input                        dram_init_finish_i,// read only signal
    // register name : bist_finish_reg , address:0x154
    input                        bist_finish_i,// read only signal
    input                        bist_rescan_finish_i,// read only signal
    // register name : bank_success_reg , address:0x158
    input                        bank_success_i,// read only signal
    input                        bist_rescan_success_i,// read only signal
    // register name : mc_bist_rescan_fail_num_reg , address:0x15c
    input  [19:0]                        mc_bist_rescan_fail_num_i,// read only signal
    // register name : mc_bist_err_wl_reg , address:0x160
    input  [6:0]                        mc_bist_err_wl_num_i,// read only signal
    input                        err_wl_num_change_flag_i,// read only signal
    // register name : rescan_round_result_reg , address:0x16c
    input  [14:0]                        rescan_round_result_i,// read only signal
    // register name : mc_frame2array_dbg_reg , address:0x1a4
    input  [4:0]                        dbg_next_state_array_i,// read only signal
    input  [4:0]                        dbg_current_state_array_i,// read only signal
    input  [1:0]                        dbg_r_data_cnt_i,// read only signal
    input                        dbg_refresh_flag_i,// read only signal
    input  [1:0]                        dbg_r_frame_cnt_i,// read only signal
    input  [1:0]                        dbg_w_frame_cnt_i,// read only signal
    // register name : dbg_frame_store_0_reg , address:0x1a8
    input  [31:0]                        dbg_frame_store_0_i,// read only signal
    // register name : dbg_frame_store_1_reg , address:0x1ac
    input  [31:0]                        dbg_frame_store_1_i,// read only signal
    // register name : dbg_frame_store_2_reg , address:0x1b0
    input  [31:0]                        dbg_frame_store_2_i,// read only signal
    // register name : dbg_frame_store_3_reg , address:0x1b4
    input  [31:0]                        dbg_frame_store_3_i,// read only signal
    // register name : dbg_frame_store_4_reg , address:0x1b8
    input  [31:0]                        dbg_frame_store_4_i,// read only signal
    // register name : dbg_frame_store_5_reg , address:0x1bc
    input  [31:0]                        dbg_frame_store_5_i,// read only signal
    // register name : dbg_frame_store_6_reg , address:0x1c0
    input  [31:0]                        dbg_frame_store_6_i,// read only signal
    // register name : dbg_frame_store_7_reg , address:0x1c4
    input  [31:0]                        dbg_frame_store_7_i,// read only signal
    // register name : dbg_frame_store_8_reg , address:0x1c8
    input  [31:0]                        dbg_frame_store_8_i,// read only signal
    // register name : dbg_frame_store_9_reg , address:0x1cc
    input  [1:0]                        dbg_frame_store_9_i,// read only signal
    // register name : dbg_rdata_store_0_reg , address:0x1d0
    input  [31:0]                        dbg_rdata_store_0_i,// read only signal
    // register name : dbg_rdata_store_1_reg , address:0x1d4
    input  [31:0]                        dbg_rdata_store_1_i,// read only signal
    // register name : dbg_rdata_store_2_reg , address:0x1d8
    input  [31:0]                        dbg_rdata_store_2_i,// read only signal
    // register name : dbg_rdata_store_3_reg , address:0x1dc
    input  [31:0]                        dbg_rdata_store_3_i,// read only signal
    // register name : dbg_rdata_store_4_reg , address:0x1e0
    input  [31:0]                        dbg_rdata_store_4_i,// read only signal
    // register name : dbg_rdata_store_5_reg , address:0x1e4
    input  [31:0]                        dbg_rdata_store_5_i,// read only signal
    // register name : dbg_rdata_store_6_reg , address:0x1e8
    input  [31:0]                        dbg_rdata_store_6_i,// read only signal
    // register name : dbg_rdata_store_7_reg , address:0x1ec
    input  [31:0]                        dbg_rdata_store_7_i,// read only signal
    // register name : dbg_rdata_store_8_reg , address:0x1f0
    input  [9:0]                        dbg_rdata_store_8_i,// read only signal
    // register name : mc_page_status_reg , address:0x1f4
    input                        mc_page_status_i,// read only signal
    // register name : hang_timeout_status_reg , address:0x1f8
    input                        hang_timeout_status_i,// read only signal
    // register name : mc_ecc_ce_ctrl , address:0x208
    input                        mc_ecc_ce_overflow_int_i,// read only signal
    input  [4:0]                        mc_ecc_ce_cnt_i,// read only signal
    // register name : mc_ecc_ce_addr0 , address:0x20c
    input  [21:0]                        mc_ecc_ce_addr0_i,// read only signal
    input                        mc_ecc_ce_addr_vld0_i,// read only signal
    // register name : mc_ecc_ce_addr1 , address:0x210
    input  [21:0]                        mc_ecc_ce_addr1_i,// read only signal
    input                        mc_ecc_ce_addr_vld1_i,// read only signal
    // register name : mc_ecc_ce_addr2 , address:0x214
    input  [21:0]                        mc_ecc_ce_addr2_i,// read only signal
    input                        mc_ecc_ce_addr_vld2_i,// read only signal
    // register name : mc_ecc_ce_addr3 , address:0x218
    input  [21:0]                        mc_ecc_ce_addr3_i,// read only signal
    input                        mc_ecc_ce_addr_vld3_i,// read only signal
    // register name : mc_ecc_ce_addr4 , address:0x21c
    input  [21:0]                        mc_ecc_ce_addr4_i,// read only signal
    input                        mc_ecc_ce_addr_vld4_i,// read only signal
    // register name : mc_ecc_ce_addr5 , address:0x220
    input  [21:0]                        mc_ecc_ce_addr5_i,// read only signal
    input                        mc_ecc_ce_addr_vld5_i,// read only signal
    // register name : mc_ecc_ce_addr6 , address:0x224
    input  [21:0]                        mc_ecc_ce_addr6_i,// read only signal
    input                        mc_ecc_ce_addr_vld6_i,// read only signal
    // register name : mc_ecc_ce_addr7 , address:0x228
    input  [21:0]                        mc_ecc_ce_addr7_i,// read only signal
    input                        mc_ecc_ce_addr_vld7_i,// read only signal
    // register name : mc_ecc_ce_addr8 , address:0x22c
    input  [21:0]                        mc_ecc_ce_addr8_i,// read only signal
    input                        mc_ecc_ce_addr_vld8_i,// read only signal
    // register name : mc_ecc_ce_addr9 , address:0x230
    input  [21:0]                        mc_ecc_ce_addr9_i,// read only signal
    input                        mc_ecc_ce_addr_vld9_i,// read only signal
    // register name : mc_ecc_ce_addr10 , address:0x234
    input  [21:0]                        mc_ecc_ce_addr10_i,// read only signal
    input                        mc_ecc_ce_addr_vld10_i,// read only signal
    // register name : mc_ecc_ce_addr11 , address:0x238
    input  [21:0]                        mc_ecc_ce_addr11_i,// read only signal
    input                        mc_ecc_ce_addr_vld11_i,// read only signal
    // register name : mc_ecc_ce_addr12 , address:0x23c
    input  [21:0]                        mc_ecc_ce_addr12_i,// read only signal
    input                        mc_ecc_ce_addr_vld12_i,// read only signal
    // register name : mc_ecc_ce_addr13 , address:0x240
    input  [21:0]                        mc_ecc_ce_addr13_i,// read only signal
    input                        mc_ecc_ce_addr_vld13_i,// read only signal
    // register name : mc_ecc_ce_addr14 , address:0x244
    input  [21:0]                        mc_ecc_ce_addr14_i,// read only signal
    input                        mc_ecc_ce_addr_vld14_i,// read only signal
    // register name : mc_ecc_ce_addr15 , address:0x248
    input  [21:0]                        mc_ecc_ce_addr15_i,// read only signal
    input                        mc_ecc_ce_addr_vld15_i,// read only signal
    // register name : mc_ecc_uce_ctrl , address:0x24c
    input                        mc_ecc_uce_int_i,// read only signal
    input  [2:0]                        mc_ecc_uce_cnt_i,// read only signal
    // register name : mc_ecc_uce_addr0 , address:0x250
    input  [21:0]                        mc_ecc_uce_addr0_i,// read only signal
    input                        mc_ecc_uce_addr_vld0_i,// read only signal
    // register name : mc_ecc_uce_addr1 , address:0x254
    input  [21:0]                        mc_ecc_uce_addr1_i,// read only signal
    input                        mc_ecc_uce_addr_vld1_i,// read only signal
    // register name : mc_ecc_uce_addr2 , address:0x258
    input  [21:0]                        mc_ecc_uce_addr2_i,// read only signal
    input                        mc_ecc_uce_addr_vld2_i,// read only signal
    // register name : mc_ecc_uce_addr3 , address:0x25c
    input  [21:0]                        mc_ecc_uce_addr3_i,// read only signal
    input                        mc_ecc_uce_addr_vld3_i,// read only signal
 
    // W1C output ports
    // register name : mc_timeout_clr_reg , address:0x144
    output reg mc_timeout_clr_o,
    // register name : rescan_finish_clr_reg , address:0x164
    output reg rescan_finish_clr_o,
    // register name : bist_finish_clr_reg , address:0x170
    output reg bist_finish_clr_o,
    // register name : hang_timeout_clr_reg , address:0x200
    output reg hang_timeout_clr_o,
    // register name : mc_ecc_ce_ctrl , address:0x208
    output reg mc_ecc_ce_int_clr_o,
    // register name : mc_ecc_uce_ctrl , address:0x24c
    output reg mc_ecc_uce_int_clr_o,

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
    output reg mc_ecc_en_o,
    output reg mc_rf_burst_split_en_o,
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
    // register name : mc_vmc_wl_num0_1_reg , address:0x1c
    output reg [12:0] mc_vmc_wl_num0_o,
    output reg [12:0] mc_vmc_wl_num1_o,
    // register name : mc_vmc_wl_num2_3_reg , address:0x20
    output reg [12:0] mc_vmc_wl_num2_o,
    output reg [12:0] mc_vmc_wl_num3_o,
    // register name : mc_vmc_wl_num4_5_reg , address:0x24
    output reg [12:0] mc_vmc_wl_num4_o,
    output reg [12:0] mc_vmc_wl_num5_o,
    // register name : mc_vmc_wl_num6_7_reg , address:0x28
    output reg [12:0] mc_vmc_wl_num6_o,
    output reg [12:0] mc_vmc_wl_num7_o,
    // register name : mc_vmc_wl_num8_9_reg , address:0x2c
    output reg [12:0] mc_vmc_wl_num8_o,
    output reg [12:0] mc_vmc_wl_num9_o,
    // register name : mc_vmc_wl_num10_11_reg , address:0x30
    output reg [12:0] mc_vmc_wl_num10_o,
    output reg [12:0] mc_vmc_wl_num11_o,
    // register name : mc_vmc_wl_num12_13_reg , address:0x34
    output reg [12:0] mc_vmc_wl_num12_o,
    output reg [12:0] mc_vmc_wl_num13_o,
    // register name : mc_vmc_wl_num14_15_reg , address:0x38
    output reg [12:0] mc_vmc_wl_num14_o,
    output reg [12:0] mc_vmc_wl_num15_o,
    // register name : mc_vmc_wl_num16_17_reg , address:0x3c
    output reg [12:0] mc_vmc_wl_num16_o,
    output reg [12:0] mc_vmc_wl_num17_o,
    // register name : mc_vmc_wl_num18_19_reg , address:0x40
    output reg [12:0] mc_vmc_wl_num18_o,
    output reg [12:0] mc_vmc_wl_num19_o,
    // register name : mc_vmc_wl_num20_21_reg , address:0x44
    output reg [12:0] mc_vmc_wl_num20_o,
    output reg [12:0] mc_vmc_wl_num21_o,
    // register name : mc_vmc_wl_num22_23_reg , address:0x48
    output reg [12:0] mc_vmc_wl_num22_o,
    output reg [12:0] mc_vmc_wl_num23_o,
    // register name : mc_vmc_wl_num24_25_reg , address:0x4c
    output reg [12:0] mc_vmc_wl_num24_o,
    output reg [12:0] mc_vmc_wl_num25_o,
    // register name : mc_vmc_wl_num26_27_reg , address:0x50
    output reg [12:0] mc_vmc_wl_num26_o,
    output reg [12:0] mc_vmc_wl_num27_o,
    // register name : mc_vmc_wl_num28_29_reg , address:0x54
    output reg [12:0] mc_vmc_wl_num28_o,
    output reg [12:0] mc_vmc_wl_num29_o,
    // register name : mc_vmc_wl_num30_31_reg , address:0x58
    output reg [12:0] mc_vmc_wl_num30_o,
    output reg [12:0] mc_vmc_wl_num31_o,
    // register name : mc_vmc_wl_num32_33_reg , address:0x5c
    output reg [12:0] mc_vmc_wl_num32_o,
    output reg [12:0] mc_vmc_wl_num33_o,
    // register name : mc_vmc_wl_num34_35_reg , address:0x60
    output reg [12:0] mc_vmc_wl_num34_o,
    output reg [12:0] mc_vmc_wl_num35_o,
    // register name : mc_vmc_wl_num36_37_reg , address:0x64
    output reg [12:0] mc_vmc_wl_num36_o,
    output reg [12:0] mc_vmc_wl_num37_o,
    // register name : mc_vmc_wl_num38_39_reg , address:0x68
    output reg [12:0] mc_vmc_wl_num38_o,
    output reg [12:0] mc_vmc_wl_num39_o,
    // register name : mc_vmc_wl_num40_41_reg , address:0x6c
    output reg [12:0] mc_vmc_wl_num40_o,
    output reg [12:0] mc_vmc_wl_num41_o,
    // register name : mc_vmc_wl_num42_43_reg , address:0x70
    output reg [12:0] mc_vmc_wl_num42_o,
    output reg [12:0] mc_vmc_wl_num43_o,
    // register name : mc_vmc_wl_num44_45_reg , address:0x74
    output reg [12:0] mc_vmc_wl_num44_o,
    output reg [12:0] mc_vmc_wl_num45_o,
    // register name : mc_vmc_wl_num46_47_reg , address:0x78
    output reg [12:0] mc_vmc_wl_num46_o,
    output reg [12:0] mc_vmc_wl_num47_o,
    // register name : mc_vmc_wl_num48_49_reg , address:0x7c
    output reg [12:0] mc_vmc_wl_num48_o,
    output reg [12:0] mc_vmc_wl_num49_o,
    // register name : mc_vmc_wl_num50_51_reg , address:0x80
    output reg [12:0] mc_vmc_wl_num50_o,
    output reg [12:0] mc_vmc_wl_num51_o,
    // register name : mc_vmc_wl_num52_53_reg , address:0x84
    output reg [12:0] mc_vmc_wl_num52_o,
    output reg [12:0] mc_vmc_wl_num53_o,
    // register name : mc_vmc_wl_num54_55_reg , address:0x88
    output reg [12:0] mc_vmc_wl_num54_o,
    output reg [12:0] mc_vmc_wl_num55_o,
    // register name : mc_vmc_wl_num56_57_reg , address:0x8c
    output reg [12:0] mc_vmc_wl_num56_o,
    output reg [12:0] mc_vmc_wl_num57_o,
    // register name : mc_vmc_wl_num58_59_reg , address:0x90
    output reg [12:0] mc_vmc_wl_num58_o,
    output reg [12:0] mc_vmc_wl_num59_o,
    // register name : mc_vmc_wl_num60_61_reg , address:0x94
    output reg [12:0] mc_vmc_wl_num60_o,
    output reg [12:0] mc_vmc_wl_num61_o,
    // register name : mc_vmc_wl_num62_63_reg , address:0x98
    output reg [12:0] mc_vmc_wl_num62_o,
    output reg [12:0] mc_vmc_wl_num63_o,
    // register name : mc_vmc_bl_num0_part0_1_reg , address:0x9c
    output reg [7:0] mc_vmc_bl_num0_part0_o,
    output reg [7:0] mc_vmc_bl_num1_part0_o,
    output reg [7:0] mc_vmc_bl_num0_part1_o,
    output reg [7:0] mc_vmc_bl_num1_part1_o,
    // register name : mc_vmc_bl_num0_part2_3_reg , address:0xa0
    output reg [7:0] mc_vmc_bl_num0_part2_o,
    output reg [7:0] mc_vmc_bl_num1_part2_o,
    output reg [7:0] mc_vmc_bl_num0_part3_o,
    output reg [7:0] mc_vmc_bl_num1_part3_o,
    // register name : mc_vmc_bl_num0_part4_5_reg , address:0xa4
    output reg [7:0] mc_vmc_bl_num0_part4_o,
    output reg [7:0] mc_vmc_bl_num1_part4_o,
    output reg [7:0] mc_vmc_bl_num0_part5_o,
    output reg [7:0] mc_vmc_bl_num1_part5_o,
    // register name : mc_vmc_bl_num0_part6_7_reg , address:0xa8
    output reg [7:0] mc_vmc_bl_num0_part6_o,
    output reg [7:0] mc_vmc_bl_num1_part6_o,
    output reg [7:0] mc_vmc_bl_num0_part7_o,
    output reg [7:0] mc_vmc_bl_num1_part7_o,
    // register name : mc_vmc_bl_num0_part8_9_reg , address:0xac
    output reg [7:0] mc_vmc_bl_num0_part8_o,
    output reg [7:0] mc_vmc_bl_num1_part8_o,
    output reg [7:0] mc_vmc_bl_num0_part9_o,
    output reg [7:0] mc_vmc_bl_num1_part9_o,
    // register name : rescan_finish_mask_reg , address:0x168
    output reg rescan_finish_mask_o,
    // register name : bist_finish_mask_reg , address:0x174
    output reg bist_finish_mask_o,
    // register name : hang_timeout_th_reg , address:0x178
    output reg [31:0] hang_timeout_th_o,
    // register name : bist_pattern_reg0_reg , address:0x17c
    output reg [31:0] bist_pattern_reg0_o,
    // register name : bist_pattern_reg1_reg , address:0x180
    output reg [31:0] bist_pattern_reg1_o,
    // register name : bist_pattern_reg2_reg , address:0x184
    output reg [31:0] bist_pattern_reg2_o,
    // register name : bist_pattern_reg3_reg , address:0x188
    output reg [31:0] bist_pattern_reg3_o,
    // register name : csl_bist_pattern_sel0_reg , address:0x18c
    output reg [31:0] csl_bist_pattern_sel0_o,
    // register name : csl_bist_pattern_sel1_reg , address:0x190
    output reg [31:0] csl_bist_pattern_sel1_o,
    // register name : csl_bist_pattern_sel2_reg , address:0x194
    output reg [3:0] csl_bist_pattern_sel2_o,
    // register name : wl_bist_pattern_sel0_reg , address:0x198
    output reg [31:0] wl_bist_pattern_sel0_o,
    // register name : wl_bist_pattern_sel1_reg , address:0x19c
    output reg [31:0] wl_bist_pattern_sel1_o,
    // register name : wl_bist_pattern_sel2_reg , address:0x1a0
    output reg [3:0] wl_bist_pattern_sel2_o,
    // register name : hang_timeout_mask_reg , address:0x1fc
    output reg hang_timeout_mask_o,
    // register name : hang_timeout_en_reg , address:0x204
    output reg hang_timeout_en_o,
    // register name : mc_ecc_ce_ctrl , address:0x208
    output reg [4:0] mc_ecc_ce_th_o,
    output reg mc_ecc_ce_int_mask_o,
    // register name : mc_ecc_uce_ctrl , address:0x24c
    output reg mc_ecc_uce_int_mask_o,
    // common output ports 
    output reg [APB_DATA_WIDTH-1:0]  prdata
    );

    //-------- regs --------
    reg [31:0] mc_id_apb_dff;// read only signal
    reg [12:0] err_wl0_apb_dff;// read only signal
    reg [12:0] err_wl1_apb_dff;// read only signal
    reg [12:0] err_wl2_apb_dff;// read only signal
    reg [12:0] err_wl3_apb_dff;// read only signal
    reg [12:0] err_wl4_apb_dff;// read only signal
    reg [12:0] err_wl5_apb_dff;// read only signal
    reg [12:0] err_wl6_apb_dff;// read only signal
    reg [12:0] err_wl7_apb_dff;// read only signal
    reg [12:0] err_wl8_apb_dff;// read only signal
    reg [12:0] err_wl9_apb_dff;// read only signal
    reg [12:0] err_wl10_apb_dff;// read only signal
    reg [12:0] err_wl11_apb_dff;// read only signal
    reg [12:0] err_wl12_apb_dff;// read only signal
    reg [12:0] err_wl13_apb_dff;// read only signal
    reg [12:0] err_wl14_apb_dff;// read only signal
    reg [12:0] err_wl15_apb_dff;// read only signal
    reg [12:0] err_wl16_apb_dff;// read only signal
    reg [12:0] err_wl17_apb_dff;// read only signal
    reg [12:0] err_wl18_apb_dff;// read only signal
    reg [12:0] err_wl19_apb_dff;// read only signal
    reg [12:0] err_wl20_apb_dff;// read only signal
    reg [12:0] err_wl21_apb_dff;// read only signal
    reg [12:0] err_wl22_apb_dff;// read only signal
    reg [12:0] err_wl23_apb_dff;// read only signal
    reg [12:0] err_wl24_apb_dff;// read only signal
    reg [12:0] err_wl25_apb_dff;// read only signal
    reg [12:0] err_wl26_apb_dff;// read only signal
    reg [12:0] err_wl27_apb_dff;// read only signal
    reg [12:0] err_wl28_apb_dff;// read only signal
    reg [12:0] err_wl29_apb_dff;// read only signal
    reg [12:0] err_wl30_apb_dff;// read only signal
    reg [12:0] err_wl31_apb_dff;// read only signal
    reg [12:0] err_wl32_apb_dff;// read only signal
    reg [12:0] err_wl33_apb_dff;// read only signal
    reg [12:0] err_wl34_apb_dff;// read only signal
    reg [12:0] err_wl35_apb_dff;// read only signal
    reg [12:0] err_wl36_apb_dff;// read only signal
    reg [12:0] err_wl37_apb_dff;// read only signal
    reg [12:0] err_wl38_apb_dff;// read only signal
    reg [12:0] err_wl39_apb_dff;// read only signal
    reg [12:0] err_wl40_apb_dff;// read only signal
    reg [12:0] err_wl41_apb_dff;// read only signal
    reg [12:0] err_wl42_apb_dff;// read only signal
    reg [12:0] err_wl43_apb_dff;// read only signal
    reg [12:0] err_wl44_apb_dff;// read only signal
    reg [12:0] err_wl45_apb_dff;// read only signal
    reg [12:0] err_wl46_apb_dff;// read only signal
    reg [12:0] err_wl47_apb_dff;// read only signal
    reg [12:0] err_wl48_apb_dff;// read only signal
    reg [12:0] err_wl49_apb_dff;// read only signal
    reg [12:0] err_wl50_apb_dff;// read only signal
    reg [12:0] err_wl51_apb_dff;// read only signal
    reg [12:0] err_wl52_apb_dff;// read only signal
    reg [12:0] err_wl53_apb_dff;// read only signal
    reg [12:0] err_wl54_apb_dff;// read only signal
    reg [12:0] err_wl55_apb_dff;// read only signal
    reg [12:0] err_wl56_apb_dff;// read only signal
    reg [12:0] err_wl57_apb_dff;// read only signal
    reg [12:0] err_wl58_apb_dff;// read only signal
    reg [12:0] err_wl59_apb_dff;// read only signal
    reg [12:0] err_wl60_apb_dff;// read only signal
    reg [12:0] err_wl61_apb_dff;// read only signal
    reg [12:0] err_wl62_apb_dff;// read only signal
    reg [12:0] err_wl63_apb_dff;// read only signal
    reg [7:0] err_csl0_part0_apb_dff;// read only signal
    reg [7:0] err_csl1_part0_apb_dff;// read only signal
    reg [7:0] err_csl0_part1_apb_dff;// read only signal
    reg [7:0] err_csl1_part1_apb_dff;// read only signal
    reg [7:0] err_csl0_part2_apb_dff;// read only signal
    reg [7:0] err_csl1_part2_apb_dff;// read only signal
    reg [7:0] err_csl0_part3_apb_dff;// read only signal
    reg [7:0] err_csl1_part3_apb_dff;// read only signal
    reg [7:0] err_csl0_part4_apb_dff;// read only signal
    reg [7:0] err_csl1_part4_apb_dff;// read only signal
    reg [7:0] err_csl0_part5_apb_dff;// read only signal
    reg [7:0] err_csl1_part5_apb_dff;// read only signal
    reg [7:0] err_csl0_part6_apb_dff;// read only signal
    reg [7:0] err_csl1_part6_apb_dff;// read only signal
    reg [7:0] err_csl0_part7_apb_dff;// read only signal
    reg [7:0] err_csl1_part7_apb_dff;// read only signal
    reg [7:0] err_csl0_part8_apb_dff;// read only signal
    reg [7:0] err_csl1_part8_apb_dff;// read only signal
    reg [7:0] err_csl0_part9_apb_dff;// read only signal
    reg [7:0] err_csl1_part9_apb_dff;// read only signal
    reg mc_rf_start_dbg_apb_dff;// read only signal
    reg mc_timeout_flag_apb_dff;// read only signal
    reg [2:0] mc_bist_status_apb_dff;// read only signal
    reg mc_bist_path_fail_apb_dff;// read only signal
    reg dram_init_finish_apb_dff;// read only signal
    reg bist_finish_apb_dff;// read only signal
    reg bist_rescan_finish_apb_dff;// read only signal
    reg bank_success_apb_dff;// read only signal
    reg bist_rescan_success_apb_dff;// read only signal
    reg [19:0] mc_bist_rescan_fail_num_apb_dff;// read only signal
    reg [6:0] mc_bist_err_wl_num_apb_dff;// read only signal
    reg err_wl_num_change_flag_apb_dff;// read only signal
    reg [14:0] rescan_round_result_apb_dff;// read only signal
    reg [4:0] dbg_next_state_array_apb_dff;// read only signal
    reg [4:0] dbg_current_state_array_apb_dff;// read only signal
    reg [1:0] dbg_r_data_cnt_apb_dff;// read only signal
    reg dbg_refresh_flag_apb_dff;// read only signal
    reg [1:0] dbg_r_frame_cnt_apb_dff;// read only signal
    reg [1:0] dbg_w_frame_cnt_apb_dff;// read only signal
    reg [31:0] dbg_frame_store_0_apb_dff;// read only signal
    reg [31:0] dbg_frame_store_1_apb_dff;// read only signal
    reg [31:0] dbg_frame_store_2_apb_dff;// read only signal
    reg [31:0] dbg_frame_store_3_apb_dff;// read only signal
    reg [31:0] dbg_frame_store_4_apb_dff;// read only signal
    reg [31:0] dbg_frame_store_5_apb_dff;// read only signal
    reg [31:0] dbg_frame_store_6_apb_dff;// read only signal
    reg [31:0] dbg_frame_store_7_apb_dff;// read only signal
    reg [31:0] dbg_frame_store_8_apb_dff;// read only signal
    reg [1:0] dbg_frame_store_9_apb_dff;// read only signal
    reg [31:0] dbg_rdata_store_0_apb_dff;// read only signal
    reg [31:0] dbg_rdata_store_1_apb_dff;// read only signal
    reg [31:0] dbg_rdata_store_2_apb_dff;// read only signal
    reg [31:0] dbg_rdata_store_3_apb_dff;// read only signal
    reg [31:0] dbg_rdata_store_4_apb_dff;// read only signal
    reg [31:0] dbg_rdata_store_5_apb_dff;// read only signal
    reg [31:0] dbg_rdata_store_6_apb_dff;// read only signal
    reg [31:0] dbg_rdata_store_7_apb_dff;// read only signal
    reg [9:0] dbg_rdata_store_8_apb_dff;// read only signal
    reg mc_page_status_apb_dff;// read only signal
    reg hang_timeout_status_apb_dff;// read only signal
    reg mc_ecc_ce_overflow_int_apb_dff;// read only signal
    reg [4:0] mc_ecc_ce_cnt_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr0_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld0_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr1_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld1_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr2_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld2_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr3_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld3_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr4_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld4_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr5_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld5_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr6_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld6_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr7_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld7_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr8_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld8_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr9_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld9_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr10_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld10_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr11_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld11_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr12_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld12_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr13_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld13_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr14_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld14_apb_dff;// read only signal
    reg [21:0] mc_ecc_ce_addr15_apb_dff;// read only signal
    reg mc_ecc_ce_addr_vld15_apb_dff;// read only signal
    reg mc_ecc_uce_int_apb_dff;// read only signal
    reg [2:0] mc_ecc_uce_cnt_apb_dff;// read only signal
    reg [21:0] mc_ecc_uce_addr0_apb_dff;// read only signal
    reg mc_ecc_uce_addr_vld0_apb_dff;// read only signal
    reg [21:0] mc_ecc_uce_addr1_apb_dff;// read only signal
    reg mc_ecc_uce_addr_vld1_apb_dff;// read only signal
    reg [21:0] mc_ecc_uce_addr2_apb_dff;// read only signal
    reg mc_ecc_uce_addr_vld2_apb_dff;// read only signal
    reg [21:0] mc_ecc_uce_addr3_apb_dff;// read only signal
    reg mc_ecc_uce_addr_vld3_apb_dff;// read only signal
    //-------  Wires ---------
    wire apb_write_sel ;
    wire apb_read_sel ;
    //read and write enable signals
    assign apb_write_sel    = psel &&  pwrite && (penable);
    assign apb_read_sel     = psel && (~pwrite) && (~penable);

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
            mc_rdrdy_n_en_o <= 1'b0;
            mc_ecc_en_o <= 1'b0;
            mc_rf_burst_split_en_o <= 1'b1;
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
            mc_ecc_en_o <= pwdata[12];
            mc_rf_burst_split_en_o <= pwdata[13];
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
    // register name : mc_vmc_wl_num0_1_reg , address:0x1c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num0_o <= 13'h1FFF;
            mc_vmc_wl_num1_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h1c)) begin
            mc_vmc_wl_num0_o <= pwdata[12:0];
            mc_vmc_wl_num1_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num2_3_reg , address:0x20
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num2_o <= 13'h1FFF;
            mc_vmc_wl_num3_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h20)) begin
            mc_vmc_wl_num2_o <= pwdata[12:0];
            mc_vmc_wl_num3_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num4_5_reg , address:0x24
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num4_o <= 13'h1FFF;
            mc_vmc_wl_num5_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h24)) begin
            mc_vmc_wl_num4_o <= pwdata[12:0];
            mc_vmc_wl_num5_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num6_7_reg , address:0x28
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num6_o <= 13'h1FFF;
            mc_vmc_wl_num7_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h28)) begin
            mc_vmc_wl_num6_o <= pwdata[12:0];
            mc_vmc_wl_num7_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num8_9_reg , address:0x2c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num8_o <= 13'h1FFF;
            mc_vmc_wl_num9_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h2c)) begin
            mc_vmc_wl_num8_o <= pwdata[12:0];
            mc_vmc_wl_num9_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num10_11_reg , address:0x30
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num10_o <= 13'h1FFF;
            mc_vmc_wl_num11_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h30)) begin
            mc_vmc_wl_num10_o <= pwdata[12:0];
            mc_vmc_wl_num11_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num12_13_reg , address:0x34
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num12_o <= 13'h1FFF;
            mc_vmc_wl_num13_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h34)) begin
            mc_vmc_wl_num12_o <= pwdata[12:0];
            mc_vmc_wl_num13_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num14_15_reg , address:0x38
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num14_o <= 13'h1FFF;
            mc_vmc_wl_num15_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h38)) begin
            mc_vmc_wl_num14_o <= pwdata[12:0];
            mc_vmc_wl_num15_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num16_17_reg , address:0x3c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num16_o <= 13'h1FFF;
            mc_vmc_wl_num17_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h3c)) begin
            mc_vmc_wl_num16_o <= pwdata[12:0];
            mc_vmc_wl_num17_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num18_19_reg , address:0x40
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num18_o <= 13'h1FFF;
            mc_vmc_wl_num19_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h40)) begin
            mc_vmc_wl_num18_o <= pwdata[12:0];
            mc_vmc_wl_num19_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num20_21_reg , address:0x44
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num20_o <= 13'h1FFF;
            mc_vmc_wl_num21_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h44)) begin
            mc_vmc_wl_num20_o <= pwdata[12:0];
            mc_vmc_wl_num21_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num22_23_reg , address:0x48
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num22_o <= 13'h1FFF;
            mc_vmc_wl_num23_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h48)) begin
            mc_vmc_wl_num22_o <= pwdata[12:0];
            mc_vmc_wl_num23_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num24_25_reg , address:0x4c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num24_o <= 13'h1FFF;
            mc_vmc_wl_num25_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h4c)) begin
            mc_vmc_wl_num24_o <= pwdata[12:0];
            mc_vmc_wl_num25_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num26_27_reg , address:0x50
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num26_o <= 13'h1FFF;
            mc_vmc_wl_num27_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h50)) begin
            mc_vmc_wl_num26_o <= pwdata[12:0];
            mc_vmc_wl_num27_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num28_29_reg , address:0x54
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num28_o <= 13'h1FFF;
            mc_vmc_wl_num29_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h54)) begin
            mc_vmc_wl_num28_o <= pwdata[12:0];
            mc_vmc_wl_num29_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num30_31_reg , address:0x58
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num30_o <= 13'h1FFF;
            mc_vmc_wl_num31_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h58)) begin
            mc_vmc_wl_num30_o <= pwdata[12:0];
            mc_vmc_wl_num31_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num32_33_reg , address:0x5c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num32_o <= 13'h1FFF;
            mc_vmc_wl_num33_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h5c)) begin
            mc_vmc_wl_num32_o <= pwdata[12:0];
            mc_vmc_wl_num33_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num34_35_reg , address:0x60
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num34_o <= 13'h1FFF;
            mc_vmc_wl_num35_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h60)) begin
            mc_vmc_wl_num34_o <= pwdata[12:0];
            mc_vmc_wl_num35_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num36_37_reg , address:0x64
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num36_o <= 13'h1FFF;
            mc_vmc_wl_num37_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h64)) begin
            mc_vmc_wl_num36_o <= pwdata[12:0];
            mc_vmc_wl_num37_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num38_39_reg , address:0x68
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num38_o <= 13'h1FFF;
            mc_vmc_wl_num39_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h68)) begin
            mc_vmc_wl_num38_o <= pwdata[12:0];
            mc_vmc_wl_num39_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num40_41_reg , address:0x6c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num40_o <= 13'h1FFF;
            mc_vmc_wl_num41_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h6c)) begin
            mc_vmc_wl_num40_o <= pwdata[12:0];
            mc_vmc_wl_num41_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num42_43_reg , address:0x70
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num42_o <= 13'h1FFF;
            mc_vmc_wl_num43_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h70)) begin
            mc_vmc_wl_num42_o <= pwdata[12:0];
            mc_vmc_wl_num43_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num44_45_reg , address:0x74
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num44_o <= 13'h1FFF;
            mc_vmc_wl_num45_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h74)) begin
            mc_vmc_wl_num44_o <= pwdata[12:0];
            mc_vmc_wl_num45_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num46_47_reg , address:0x78
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num46_o <= 13'h1FFF;
            mc_vmc_wl_num47_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h78)) begin
            mc_vmc_wl_num46_o <= pwdata[12:0];
            mc_vmc_wl_num47_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num48_49_reg , address:0x7c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num48_o <= 13'h1FFF;
            mc_vmc_wl_num49_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h7c)) begin
            mc_vmc_wl_num48_o <= pwdata[12:0];
            mc_vmc_wl_num49_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num50_51_reg , address:0x80
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num50_o <= 13'h1FFF;
            mc_vmc_wl_num51_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h80)) begin
            mc_vmc_wl_num50_o <= pwdata[12:0];
            mc_vmc_wl_num51_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num52_53_reg , address:0x84
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num52_o <= 13'h1FFF;
            mc_vmc_wl_num53_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h84)) begin
            mc_vmc_wl_num52_o <= pwdata[12:0];
            mc_vmc_wl_num53_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num54_55_reg , address:0x88
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num54_o <= 13'h1FFF;
            mc_vmc_wl_num55_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h88)) begin
            mc_vmc_wl_num54_o <= pwdata[12:0];
            mc_vmc_wl_num55_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num56_57_reg , address:0x8c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num56_o <= 13'h1FFF;
            mc_vmc_wl_num57_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h8c)) begin
            mc_vmc_wl_num56_o <= pwdata[12:0];
            mc_vmc_wl_num57_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num58_59_reg , address:0x90
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num58_o <= 13'h1FFF;
            mc_vmc_wl_num59_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h90)) begin
            mc_vmc_wl_num58_o <= pwdata[12:0];
            mc_vmc_wl_num59_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num60_61_reg , address:0x94
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num60_o <= 13'h1FFF;
            mc_vmc_wl_num61_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h94)) begin
            mc_vmc_wl_num60_o <= pwdata[12:0];
            mc_vmc_wl_num61_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_wl_num62_63_reg , address:0x98
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num62_o <= 13'h1FFF;
            mc_vmc_wl_num63_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 11'h98)) begin
            mc_vmc_wl_num62_o <= pwdata[12:0];
            mc_vmc_wl_num63_o <= pwdata[25:13];
        end
    end
    // register name : mc_vmc_bl_num0_part0_1_reg , address:0x9c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part0_o <= 8'hFF;
            mc_vmc_bl_num1_part0_o <= 8'hFF;
            mc_vmc_bl_num0_part1_o <= 8'hFF;
            mc_vmc_bl_num1_part1_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 11'h9c)) begin
            mc_vmc_bl_num0_part0_o <= pwdata[7:0];
            mc_vmc_bl_num1_part0_o <= pwdata[15:8];
            mc_vmc_bl_num0_part1_o <= pwdata[23:16];
            mc_vmc_bl_num1_part1_o <= pwdata[31:24];
        end
    end
    // register name : mc_vmc_bl_num0_part2_3_reg , address:0xa0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part2_o <= 8'hFF;
            mc_vmc_bl_num1_part2_o <= 8'hFF;
            mc_vmc_bl_num0_part3_o <= 8'hFF;
            mc_vmc_bl_num1_part3_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 11'ha0)) begin
            mc_vmc_bl_num0_part2_o <= pwdata[7:0];
            mc_vmc_bl_num1_part2_o <= pwdata[15:8];
            mc_vmc_bl_num0_part3_o <= pwdata[23:16];
            mc_vmc_bl_num1_part3_o <= pwdata[31:24];
        end
    end
    // register name : mc_vmc_bl_num0_part4_5_reg , address:0xa4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part4_o <= 8'hFF;
            mc_vmc_bl_num1_part4_o <= 8'hFF;
            mc_vmc_bl_num0_part5_o <= 8'hFF;
            mc_vmc_bl_num1_part5_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 11'ha4)) begin
            mc_vmc_bl_num0_part4_o <= pwdata[7:0];
            mc_vmc_bl_num1_part4_o <= pwdata[15:8];
            mc_vmc_bl_num0_part5_o <= pwdata[23:16];
            mc_vmc_bl_num1_part5_o <= pwdata[31:24];
        end
    end
    // register name : mc_vmc_bl_num0_part6_7_reg , address:0xa8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part6_o <= 8'hFF;
            mc_vmc_bl_num1_part6_o <= 8'hFF;
            mc_vmc_bl_num0_part7_o <= 8'hFF;
            mc_vmc_bl_num1_part7_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 11'ha8)) begin
            mc_vmc_bl_num0_part6_o <= pwdata[7:0];
            mc_vmc_bl_num1_part6_o <= pwdata[15:8];
            mc_vmc_bl_num0_part7_o <= pwdata[23:16];
            mc_vmc_bl_num1_part7_o <= pwdata[31:24];
        end
    end
    // register name : mc_vmc_bl_num0_part8_9_reg , address:0xac
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part8_o <= 8'hFF;
            mc_vmc_bl_num1_part8_o <= 8'hFF;
            mc_vmc_bl_num0_part9_o <= 8'hFF;
            mc_vmc_bl_num1_part9_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 11'hac)) begin
            mc_vmc_bl_num0_part8_o <= pwdata[7:0];
            mc_vmc_bl_num1_part8_o <= pwdata[15:8];
            mc_vmc_bl_num0_part9_o <= pwdata[23:16];
            mc_vmc_bl_num1_part9_o <= pwdata[31:24];
        end
    end
    // register name : rescan_finish_mask_reg , address:0x168
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            rescan_finish_mask_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 11'h168)) begin
            rescan_finish_mask_o <= pwdata[0];
        end
    end
    // register name : bist_finish_mask_reg , address:0x174
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_finish_mask_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 11'h174)) begin
            bist_finish_mask_o <= pwdata[0];
        end
    end
    // register name : hang_timeout_th_reg , address:0x178
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_th_o <= 32'h186a00;
        end
        else if (apb_write_sel && (paddr == 11'h178)) begin
            hang_timeout_th_o <= pwdata[31:0];
        end
    end
    // register name : bist_pattern_reg0_reg , address:0x17c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_pattern_reg0_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 11'h17c)) begin
            bist_pattern_reg0_o <= pwdata[31:0];
        end
    end
    // register name : bist_pattern_reg1_reg , address:0x180
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_pattern_reg1_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 11'h180)) begin
            bist_pattern_reg1_o <= pwdata[31:0];
        end
    end
    // register name : bist_pattern_reg2_reg , address:0x184
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_pattern_reg2_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 11'h184)) begin
            bist_pattern_reg2_o <= pwdata[31:0];
        end
    end
    // register name : bist_pattern_reg3_reg , address:0x188
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_pattern_reg3_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 11'h188)) begin
            bist_pattern_reg3_o <= pwdata[31:0];
        end
    end
    // register name : csl_bist_pattern_sel0_reg , address:0x18c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            csl_bist_pattern_sel0_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 11'h18c)) begin
            csl_bist_pattern_sel0_o <= pwdata[31:0];
        end
    end
    // register name : csl_bist_pattern_sel1_reg , address:0x190
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            csl_bist_pattern_sel1_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 11'h190)) begin
            csl_bist_pattern_sel1_o <= pwdata[31:0];
        end
    end
    // register name : csl_bist_pattern_sel2_reg , address:0x194
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            csl_bist_pattern_sel2_o <= 4'h0;
        end
        else if (apb_write_sel && (paddr == 11'h194)) begin
            csl_bist_pattern_sel2_o <= pwdata[3:0];
        end
    end
    // register name : wl_bist_pattern_sel0_reg , address:0x198
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            wl_bist_pattern_sel0_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 11'h198)) begin
            wl_bist_pattern_sel0_o <= pwdata[31:0];
        end
    end
    // register name : wl_bist_pattern_sel1_reg , address:0x19c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            wl_bist_pattern_sel1_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 11'h19c)) begin
            wl_bist_pattern_sel1_o <= pwdata[31:0];
        end
    end
    // register name : wl_bist_pattern_sel2_reg , address:0x1a0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            wl_bist_pattern_sel2_o <= 4'h0;
        end
        else if (apb_write_sel && (paddr == 11'h1a0)) begin
            wl_bist_pattern_sel2_o <= pwdata[3:0];
        end
    end
    // register name : hang_timeout_mask_reg , address:0x1fc
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_mask_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 11'h1fc)) begin
            hang_timeout_mask_o <= pwdata[0];
        end
    end
    // register name : hang_timeout_en_reg , address:0x204
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_en_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 11'h204)) begin
            hang_timeout_en_o <= pwdata[0];
        end
    end
    // register name : mc_ecc_ce_ctrl , address:0x208
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_ecc_ce_th_o <= 5'h5;
            mc_ecc_ce_int_mask_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h208)) begin
            mc_ecc_ce_th_o <= pwdata[12:8];
            mc_ecc_ce_int_mask_o <= pwdata[24];
        end
    end
    // register name : mc_ecc_uce_ctrl , address:0x24c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_ecc_uce_int_mask_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h24c)) begin
            mc_ecc_uce_int_mask_o <= pwdata[12];
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
                prdata <= {mc_id_apb_dff};
                11'h4: //register name:mc_work_ctrl_reg,address:0x4
                prdata <= {18'h0,mc_rf_burst_split_en_o,mc_ecc_en_o,mc_rdrdy_n_en_o,mc_rdata_invert_sel_o,mc_csl_scan_mode_sel_o,mc_csl_scan_check_sel_o,mc_csl_scan_addr_range_sel_o,mc_rescan_addr_range_sel_o,mc_bist_en_o,mc_bl_vmc_en_o,mc_wl_vmc_en_o,mc_debug_en_o,mc_rf_cfg_sel_o,mc_en_o};
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
                11'h1c: //register name:mc_vmc_wl_num0_1_reg,address:0x1c
                prdata <= {6'h0,mc_vmc_wl_num1_o,mc_vmc_wl_num0_o};
                11'h20: //register name:mc_vmc_wl_num2_3_reg,address:0x20
                prdata <= {6'h0,mc_vmc_wl_num3_o,mc_vmc_wl_num2_o};
                11'h24: //register name:mc_vmc_wl_num4_5_reg,address:0x24
                prdata <= {6'h0,mc_vmc_wl_num5_o,mc_vmc_wl_num4_o};
                11'h28: //register name:mc_vmc_wl_num6_7_reg,address:0x28
                prdata <= {6'h0,mc_vmc_wl_num7_o,mc_vmc_wl_num6_o};
                11'h2c: //register name:mc_vmc_wl_num8_9_reg,address:0x2c
                prdata <= {6'h0,mc_vmc_wl_num9_o,mc_vmc_wl_num8_o};
                11'h30: //register name:mc_vmc_wl_num10_11_reg,address:0x30
                prdata <= {6'h0,mc_vmc_wl_num11_o,mc_vmc_wl_num10_o};
                11'h34: //register name:mc_vmc_wl_num12_13_reg,address:0x34
                prdata <= {6'h0,mc_vmc_wl_num13_o,mc_vmc_wl_num12_o};
                11'h38: //register name:mc_vmc_wl_num14_15_reg,address:0x38
                prdata <= {6'h0,mc_vmc_wl_num15_o,mc_vmc_wl_num14_o};
                11'h3c: //register name:mc_vmc_wl_num16_17_reg,address:0x3c
                prdata <= {6'h0,mc_vmc_wl_num17_o,mc_vmc_wl_num16_o};
                11'h40: //register name:mc_vmc_wl_num18_19_reg,address:0x40
                prdata <= {6'h0,mc_vmc_wl_num19_o,mc_vmc_wl_num18_o};
                11'h44: //register name:mc_vmc_wl_num20_21_reg,address:0x44
                prdata <= {6'h0,mc_vmc_wl_num21_o,mc_vmc_wl_num20_o};
                11'h48: //register name:mc_vmc_wl_num22_23_reg,address:0x48
                prdata <= {6'h0,mc_vmc_wl_num23_o,mc_vmc_wl_num22_o};
                11'h4c: //register name:mc_vmc_wl_num24_25_reg,address:0x4c
                prdata <= {6'h0,mc_vmc_wl_num25_o,mc_vmc_wl_num24_o};
                11'h50: //register name:mc_vmc_wl_num26_27_reg,address:0x50
                prdata <= {6'h0,mc_vmc_wl_num27_o,mc_vmc_wl_num26_o};
                11'h54: //register name:mc_vmc_wl_num28_29_reg,address:0x54
                prdata <= {6'h0,mc_vmc_wl_num29_o,mc_vmc_wl_num28_o};
                11'h58: //register name:mc_vmc_wl_num30_31_reg,address:0x58
                prdata <= {6'h0,mc_vmc_wl_num31_o,mc_vmc_wl_num30_o};
                11'h5c: //register name:mc_vmc_wl_num32_33_reg,address:0x5c
                prdata <= {6'h0,mc_vmc_wl_num33_o,mc_vmc_wl_num32_o};
                11'h60: //register name:mc_vmc_wl_num34_35_reg,address:0x60
                prdata <= {6'h0,mc_vmc_wl_num35_o,mc_vmc_wl_num34_o};
                11'h64: //register name:mc_vmc_wl_num36_37_reg,address:0x64
                prdata <= {6'h0,mc_vmc_wl_num37_o,mc_vmc_wl_num36_o};
                11'h68: //register name:mc_vmc_wl_num38_39_reg,address:0x68
                prdata <= {6'h0,mc_vmc_wl_num39_o,mc_vmc_wl_num38_o};
                11'h6c: //register name:mc_vmc_wl_num40_41_reg,address:0x6c
                prdata <= {6'h0,mc_vmc_wl_num41_o,mc_vmc_wl_num40_o};
                11'h70: //register name:mc_vmc_wl_num42_43_reg,address:0x70
                prdata <= {6'h0,mc_vmc_wl_num43_o,mc_vmc_wl_num42_o};
                11'h74: //register name:mc_vmc_wl_num44_45_reg,address:0x74
                prdata <= {6'h0,mc_vmc_wl_num45_o,mc_vmc_wl_num44_o};
                11'h78: //register name:mc_vmc_wl_num46_47_reg,address:0x78
                prdata <= {6'h0,mc_vmc_wl_num47_o,mc_vmc_wl_num46_o};
                11'h7c: //register name:mc_vmc_wl_num48_49_reg,address:0x7c
                prdata <= {6'h0,mc_vmc_wl_num49_o,mc_vmc_wl_num48_o};
                11'h80: //register name:mc_vmc_wl_num50_51_reg,address:0x80
                prdata <= {6'h0,mc_vmc_wl_num51_o,mc_vmc_wl_num50_o};
                11'h84: //register name:mc_vmc_wl_num52_53_reg,address:0x84
                prdata <= {6'h0,mc_vmc_wl_num53_o,mc_vmc_wl_num52_o};
                11'h88: //register name:mc_vmc_wl_num54_55_reg,address:0x88
                prdata <= {6'h0,mc_vmc_wl_num55_o,mc_vmc_wl_num54_o};
                11'h8c: //register name:mc_vmc_wl_num56_57_reg,address:0x8c
                prdata <= {6'h0,mc_vmc_wl_num57_o,mc_vmc_wl_num56_o};
                11'h90: //register name:mc_vmc_wl_num58_59_reg,address:0x90
                prdata <= {6'h0,mc_vmc_wl_num59_o,mc_vmc_wl_num58_o};
                11'h94: //register name:mc_vmc_wl_num60_61_reg,address:0x94
                prdata <= {6'h0,mc_vmc_wl_num61_o,mc_vmc_wl_num60_o};
                11'h98: //register name:mc_vmc_wl_num62_63_reg,address:0x98
                prdata <= {6'h0,mc_vmc_wl_num63_o,mc_vmc_wl_num62_o};
                11'h9c: //register name:mc_vmc_bl_num0_part0_1_reg,address:0x9c
                prdata <= {mc_vmc_bl_num1_part1_o,mc_vmc_bl_num0_part1_o,mc_vmc_bl_num1_part0_o,mc_vmc_bl_num0_part0_o};
                11'ha0: //register name:mc_vmc_bl_num0_part2_3_reg,address:0xa0
                prdata <= {mc_vmc_bl_num1_part3_o,mc_vmc_bl_num0_part3_o,mc_vmc_bl_num1_part2_o,mc_vmc_bl_num0_part2_o};
                11'ha4: //register name:mc_vmc_bl_num0_part4_5_reg,address:0xa4
                prdata <= {mc_vmc_bl_num1_part5_o,mc_vmc_bl_num0_part5_o,mc_vmc_bl_num1_part4_o,mc_vmc_bl_num0_part4_o};
                11'ha8: //register name:mc_vmc_bl_num0_part6_7_reg,address:0xa8
                prdata <= {mc_vmc_bl_num1_part7_o,mc_vmc_bl_num0_part7_o,mc_vmc_bl_num1_part6_o,mc_vmc_bl_num0_part6_o};
                11'hac: //register name:mc_vmc_bl_num0_part8_9_reg,address:0xac
                prdata <= {mc_vmc_bl_num1_part9_o,mc_vmc_bl_num0_part9_o,mc_vmc_bl_num1_part8_o,mc_vmc_bl_num0_part8_o};
                11'hb0: //register name:err_wl0_1_reg,address:0xb0
                prdata <= {6'h0,err_wl1_apb_dff,err_wl0_apb_dff};
                11'hb4: //register name:err_wl2_3_reg,address:0xb4
                prdata <= {6'h0,err_wl3_apb_dff,err_wl2_apb_dff};
                11'hb8: //register name:err_wl4_5_reg,address:0xb8
                prdata <= {6'h0,err_wl5_apb_dff,err_wl4_apb_dff};
                11'hbc: //register name:err_wl6_7_reg,address:0xbc
                prdata <= {6'h0,err_wl7_apb_dff,err_wl6_apb_dff};
                11'hc0: //register name:err_wl8_9_reg,address:0xc0
                prdata <= {6'h0,err_wl9_apb_dff,err_wl8_apb_dff};
                11'hc4: //register name:err_wl10_11_reg,address:0xc4
                prdata <= {6'h0,err_wl11_apb_dff,err_wl10_apb_dff};
                11'hc8: //register name:err_wl12_13_reg,address:0xc8
                prdata <= {6'h0,err_wl13_apb_dff,err_wl12_apb_dff};
                11'hcc: //register name:err_wl14_15_reg,address:0xcc
                prdata <= {6'h0,err_wl15_apb_dff,err_wl14_apb_dff};
                11'hd0: //register name:err_wl16_17_reg,address:0xd0
                prdata <= {6'h0,err_wl17_apb_dff,err_wl16_apb_dff};
                11'hd4: //register name:err_wl18_19_reg,address:0xd4
                prdata <= {6'h0,err_wl19_apb_dff,err_wl18_apb_dff};
                11'hd8: //register name:err_wl20_21_reg,address:0xd8
                prdata <= {6'h0,err_wl21_apb_dff,err_wl20_apb_dff};
                11'hdc: //register name:err_wl22_23_reg,address:0xdc
                prdata <= {6'h0,err_wl23_apb_dff,err_wl22_apb_dff};
                11'he0: //register name:err_wl24_25_reg,address:0xe0
                prdata <= {6'h0,err_wl25_apb_dff,err_wl24_apb_dff};
                11'he4: //register name:err_wl26_27_reg,address:0xe4
                prdata <= {6'h0,err_wl27_apb_dff,err_wl26_apb_dff};
                11'he8: //register name:err_wl28_29_reg,address:0xe8
                prdata <= {6'h0,err_wl29_apb_dff,err_wl28_apb_dff};
                11'hec: //register name:err_wl30_31_reg,address:0xec
                prdata <= {6'h0,err_wl31_apb_dff,err_wl30_apb_dff};
                11'hf0: //register name:err_wl32_33_reg,address:0xf0
                prdata <= {6'h0,err_wl33_apb_dff,err_wl32_apb_dff};
                11'hf4: //register name:err_wl34_35_reg,address:0xf4
                prdata <= {6'h0,err_wl35_apb_dff,err_wl34_apb_dff};
                11'hf8: //register name:err_wl36_37_reg,address:0xf8
                prdata <= {6'h0,err_wl37_apb_dff,err_wl36_apb_dff};
                11'hfc: //register name:err_wl38_39_reg,address:0xfc
                prdata <= {6'h0,err_wl39_apb_dff,err_wl38_apb_dff};
                11'h100: //register name:err_wl40_41_reg,address:0x100
                prdata <= {6'h0,err_wl41_apb_dff,err_wl40_apb_dff};
                11'h104: //register name:err_wl42_43_reg,address:0x104
                prdata <= {6'h0,err_wl43_apb_dff,err_wl42_apb_dff};
                11'h108: //register name:err_wl44_45_reg,address:0x108
                prdata <= {6'h0,err_wl45_apb_dff,err_wl44_apb_dff};
                11'h10c: //register name:err_wl46_47_reg,address:0x10c
                prdata <= {6'h0,err_wl47_apb_dff,err_wl46_apb_dff};
                11'h110: //register name:err_wl48_49_reg,address:0x110
                prdata <= {6'h0,err_wl49_apb_dff,err_wl48_apb_dff};
                11'h114: //register name:err_wl50_51_reg,address:0x114
                prdata <= {6'h0,err_wl51_apb_dff,err_wl50_apb_dff};
                11'h118: //register name:err_wl52_53_reg,address:0x118
                prdata <= {6'h0,err_wl53_apb_dff,err_wl52_apb_dff};
                11'h11c: //register name:err_wl54_55_reg,address:0x11c
                prdata <= {6'h0,err_wl55_apb_dff,err_wl54_apb_dff};
                11'h120: //register name:err_wl56_57_reg,address:0x120
                prdata <= {6'h0,err_wl57_apb_dff,err_wl56_apb_dff};
                11'h124: //register name:err_wl58_59_reg,address:0x124
                prdata <= {6'h0,err_wl59_apb_dff,err_wl58_apb_dff};
                11'h128: //register name:err_wl60_61_reg,address:0x128
                prdata <= {6'h0,err_wl61_apb_dff,err_wl60_apb_dff};
                11'h12c: //register name:err_wl62_63_reg,address:0x12c
                prdata <= {6'h0,err_wl63_apb_dff,err_wl62_apb_dff};
                11'h130: //register name:err_csl_part0_1_reg,address:0x130
                prdata <= {err_csl1_part1_apb_dff,err_csl0_part1_apb_dff,err_csl1_part0_apb_dff,err_csl0_part0_apb_dff};
                11'h134: //register name:err_csl_part2_3_reg,address:0x134
                prdata <= {err_csl1_part3_apb_dff,err_csl0_part3_apb_dff,err_csl1_part2_apb_dff,err_csl0_part2_apb_dff};
                11'h138: //register name:err_csl_part4_5_reg,address:0x138
                prdata <= {err_csl1_part5_apb_dff,err_csl0_part5_apb_dff,err_csl1_part4_apb_dff,err_csl0_part4_apb_dff};
                11'h13c: //register name:err_csl_part6_7_reg,address:0x13c
                prdata <= {err_csl1_part7_apb_dff,err_csl0_part7_apb_dff,err_csl1_part6_apb_dff,err_csl0_part6_apb_dff};
                11'h140: //register name:err_csl_part8_9_reg,address:0x140
                prdata <= {err_csl1_part9_apb_dff,err_csl0_part9_apb_dff,err_csl1_part8_apb_dff,err_csl0_part8_apb_dff};
                11'h144: //register name:mc_timeout_clr_reg,address:0x144
                prdata <= {31'h0,mc_timeout_clr_o};
                11'h148: //register name:mc_rf_start_dbg_reg,address:0x148
                prdata <= {31'h0,mc_rf_start_dbg_apb_dff};
                11'h14c: //register name:mc_timeout_flag_reg,address:0x14c
                prdata <= {31'h0,mc_timeout_flag_apb_dff};
                11'h150: //register name:mc_bist_status_reg,address:0x150
                prdata <= {27'h0,dram_init_finish_apb_dff,mc_bist_path_fail_apb_dff,mc_bist_status_apb_dff};
                11'h154: //register name:bist_finish_reg,address:0x154
                prdata <= {30'h0,bist_rescan_finish_apb_dff,bist_finish_apb_dff};
                11'h158: //register name:bank_success_reg,address:0x158
                prdata <= {30'h0,bist_rescan_success_apb_dff,bank_success_apb_dff};
                11'h15c: //register name:mc_bist_rescan_fail_num_reg,address:0x15c
                prdata <= {12'h0,mc_bist_rescan_fail_num_apb_dff};
                11'h160: //register name:mc_bist_err_wl_reg,address:0x160
                prdata <= {24'h0,err_wl_num_change_flag_apb_dff,mc_bist_err_wl_num_apb_dff};
                11'h164: //register name:rescan_finish_clr_reg,address:0x164
                prdata <= {31'h0,rescan_finish_clr_o};
                11'h168: //register name:rescan_finish_mask_reg,address:0x168
                prdata <= {31'h0,rescan_finish_mask_o};
                11'h16c: //register name:rescan_round_result_reg,address:0x16c
                prdata <= {17'h0,rescan_round_result_apb_dff};
                11'h170: //register name:bist_finish_clr_reg,address:0x170
                prdata <= {31'h0,bist_finish_clr_o};
                11'h174: //register name:bist_finish_mask_reg,address:0x174
                prdata <= {31'h0,bist_finish_mask_o};
                11'h178: //register name:hang_timeout_th_reg,address:0x178
                prdata <= {hang_timeout_th_o};
                11'h17c: //register name:bist_pattern_reg0_reg,address:0x17c
                prdata <= {bist_pattern_reg0_o};
                11'h180: //register name:bist_pattern_reg1_reg,address:0x180
                prdata <= {bist_pattern_reg1_o};
                11'h184: //register name:bist_pattern_reg2_reg,address:0x184
                prdata <= {bist_pattern_reg2_o};
                11'h188: //register name:bist_pattern_reg3_reg,address:0x188
                prdata <= {bist_pattern_reg3_o};
                11'h18c: //register name:csl_bist_pattern_sel0_reg,address:0x18c
                prdata <= {csl_bist_pattern_sel0_o};
                11'h190: //register name:csl_bist_pattern_sel1_reg,address:0x190
                prdata <= {csl_bist_pattern_sel1_o};
                11'h194: //register name:csl_bist_pattern_sel2_reg,address:0x194
                prdata <= {28'h0,csl_bist_pattern_sel2_o};
                11'h198: //register name:wl_bist_pattern_sel0_reg,address:0x198
                prdata <= {wl_bist_pattern_sel0_o};
                11'h19c: //register name:wl_bist_pattern_sel1_reg,address:0x19c
                prdata <= {wl_bist_pattern_sel1_o};
                11'h1a0: //register name:wl_bist_pattern_sel2_reg,address:0x1a0
                prdata <= {28'h0,wl_bist_pattern_sel2_o};
                11'h1a4: //register name:mc_frame2array_dbg_reg,address:0x1a4
                prdata <= {2'h0,dbg_w_frame_cnt_apb_dff,2'h0,dbg_r_frame_cnt_apb_dff,3'h0,dbg_refresh_flag_apb_dff,2'h0,dbg_r_data_cnt_apb_dff,3'h0,dbg_current_state_array_apb_dff,3'h0,dbg_next_state_array_apb_dff};
                11'h1a8: //register name:dbg_frame_store_0_reg,address:0x1a8
                prdata <= {dbg_frame_store_0_apb_dff};
                11'h1ac: //register name:dbg_frame_store_1_reg,address:0x1ac
                prdata <= {dbg_frame_store_1_apb_dff};
                11'h1b0: //register name:dbg_frame_store_2_reg,address:0x1b0
                prdata <= {dbg_frame_store_2_apb_dff};
                11'h1b4: //register name:dbg_frame_store_3_reg,address:0x1b4
                prdata <= {dbg_frame_store_3_apb_dff};
                11'h1b8: //register name:dbg_frame_store_4_reg,address:0x1b8
                prdata <= {dbg_frame_store_4_apb_dff};
                11'h1bc: //register name:dbg_frame_store_5_reg,address:0x1bc
                prdata <= {dbg_frame_store_5_apb_dff};
                11'h1c0: //register name:dbg_frame_store_6_reg,address:0x1c0
                prdata <= {dbg_frame_store_6_apb_dff};
                11'h1c4: //register name:dbg_frame_store_7_reg,address:0x1c4
                prdata <= {dbg_frame_store_7_apb_dff};
                11'h1c8: //register name:dbg_frame_store_8_reg,address:0x1c8
                prdata <= {dbg_frame_store_8_apb_dff};
                11'h1cc: //register name:dbg_frame_store_9_reg,address:0x1cc
                prdata <= {30'h0,dbg_frame_store_9_apb_dff};
                11'h1d0: //register name:dbg_rdata_store_0_reg,address:0x1d0
                prdata <= {dbg_rdata_store_0_apb_dff};
                11'h1d4: //register name:dbg_rdata_store_1_reg,address:0x1d4
                prdata <= {dbg_rdata_store_1_apb_dff};
                11'h1d8: //register name:dbg_rdata_store_2_reg,address:0x1d8
                prdata <= {dbg_rdata_store_2_apb_dff};
                11'h1dc: //register name:dbg_rdata_store_3_reg,address:0x1dc
                prdata <= {dbg_rdata_store_3_apb_dff};
                11'h1e0: //register name:dbg_rdata_store_4_reg,address:0x1e0
                prdata <= {dbg_rdata_store_4_apb_dff};
                11'h1e4: //register name:dbg_rdata_store_5_reg,address:0x1e4
                prdata <= {dbg_rdata_store_5_apb_dff};
                11'h1e8: //register name:dbg_rdata_store_6_reg,address:0x1e8
                prdata <= {dbg_rdata_store_6_apb_dff};
                11'h1ec: //register name:dbg_rdata_store_7_reg,address:0x1ec
                prdata <= {dbg_rdata_store_7_apb_dff};
                11'h1f0: //register name:dbg_rdata_store_8_reg,address:0x1f0
                prdata <= {22'h0,dbg_rdata_store_8_apb_dff};
                11'h1f4: //register name:mc_page_status_reg,address:0x1f4
                prdata <= {31'h0,mc_page_status_apb_dff};
                11'h1f8: //register name:hang_timeout_status_reg,address:0x1f8
                prdata <= {31'h0,hang_timeout_status_apb_dff};
                11'h1fc: //register name:hang_timeout_mask_reg,address:0x1fc
                prdata <= {31'h0,hang_timeout_mask_o};
                11'h200: //register name:hang_timeout_clr_reg,address:0x200
                prdata <= {31'h0,hang_timeout_clr_o};
                11'h204: //register name:hang_timeout_en_reg,address:0x204
                prdata <= {31'h0,hang_timeout_en_o};
                11'h208: //register name:mc_ecc_ce_ctrl,address:0x208
                prdata <= {7'h0,mc_ecc_ce_int_mask_o,3'h0,mc_ecc_ce_cnt_apb_dff,3'h0,mc_ecc_ce_th_o,3'h0,mc_ecc_ce_overflow_int_apb_dff,3'h0,mc_ecc_ce_int_clr_o};
                11'h20c: //register name:mc_ecc_ce_addr0,address:0x20c
                prdata <= {9'h0,mc_ecc_ce_addr_vld0_apb_dff,mc_ecc_ce_addr0_apb_dff};
                11'h210: //register name:mc_ecc_ce_addr1,address:0x210
                prdata <= {9'h0,mc_ecc_ce_addr_vld1_apb_dff,mc_ecc_ce_addr1_apb_dff};
                11'h214: //register name:mc_ecc_ce_addr2,address:0x214
                prdata <= {9'h0,mc_ecc_ce_addr_vld2_apb_dff,mc_ecc_ce_addr2_apb_dff};
                11'h218: //register name:mc_ecc_ce_addr3,address:0x218
                prdata <= {9'h0,mc_ecc_ce_addr_vld3_apb_dff,mc_ecc_ce_addr3_apb_dff};
                11'h21c: //register name:mc_ecc_ce_addr4,address:0x21c
                prdata <= {9'h0,mc_ecc_ce_addr_vld4_apb_dff,mc_ecc_ce_addr4_apb_dff};
                11'h220: //register name:mc_ecc_ce_addr5,address:0x220
                prdata <= {9'h0,mc_ecc_ce_addr_vld5_apb_dff,mc_ecc_ce_addr5_apb_dff};
                11'h224: //register name:mc_ecc_ce_addr6,address:0x224
                prdata <= {9'h0,mc_ecc_ce_addr_vld6_apb_dff,mc_ecc_ce_addr6_apb_dff};
                11'h228: //register name:mc_ecc_ce_addr7,address:0x228
                prdata <= {9'h0,mc_ecc_ce_addr_vld7_apb_dff,mc_ecc_ce_addr7_apb_dff};
                11'h22c: //register name:mc_ecc_ce_addr8,address:0x22c
                prdata <= {9'h0,mc_ecc_ce_addr_vld8_apb_dff,mc_ecc_ce_addr8_apb_dff};
                11'h230: //register name:mc_ecc_ce_addr9,address:0x230
                prdata <= {9'h0,mc_ecc_ce_addr_vld9_apb_dff,mc_ecc_ce_addr9_apb_dff};
                11'h234: //register name:mc_ecc_ce_addr10,address:0x234
                prdata <= {9'h0,mc_ecc_ce_addr_vld10_apb_dff,mc_ecc_ce_addr10_apb_dff};
                11'h238: //register name:mc_ecc_ce_addr11,address:0x238
                prdata <= {9'h0,mc_ecc_ce_addr_vld11_apb_dff,mc_ecc_ce_addr11_apb_dff};
                11'h23c: //register name:mc_ecc_ce_addr12,address:0x23c
                prdata <= {9'h0,mc_ecc_ce_addr_vld12_apb_dff,mc_ecc_ce_addr12_apb_dff};
                11'h240: //register name:mc_ecc_ce_addr13,address:0x240
                prdata <= {9'h0,mc_ecc_ce_addr_vld13_apb_dff,mc_ecc_ce_addr13_apb_dff};
                11'h244: //register name:mc_ecc_ce_addr14,address:0x244
                prdata <= {9'h0,mc_ecc_ce_addr_vld14_apb_dff,mc_ecc_ce_addr14_apb_dff};
                11'h248: //register name:mc_ecc_ce_addr15,address:0x248
                prdata <= {9'h0,mc_ecc_ce_addr_vld15_apb_dff,mc_ecc_ce_addr15_apb_dff};
                11'h24c: //register name:mc_ecc_uce_ctrl,address:0x24c
                prdata <= {19'h0,mc_ecc_uce_int_mask_o,1'h0,mc_ecc_uce_cnt_apb_dff,3'h0,mc_ecc_uce_int_apb_dff,3'h0,mc_ecc_uce_int_clr_o};
                11'h250: //register name:mc_ecc_uce_addr0,address:0x250
                prdata <= {9'h0,mc_ecc_uce_addr_vld0_apb_dff,mc_ecc_uce_addr0_apb_dff};
                11'h254: //register name:mc_ecc_uce_addr1,address:0x254
                prdata <= {9'h0,mc_ecc_uce_addr_vld1_apb_dff,mc_ecc_uce_addr1_apb_dff};
                11'h258: //register name:mc_ecc_uce_addr2,address:0x258
                prdata <= {9'h0,mc_ecc_uce_addr_vld2_apb_dff,mc_ecc_uce_addr2_apb_dff};
                11'h25c: //register name:mc_ecc_uce_addr3,address:0x25c
                prdata <= {9'h0,mc_ecc_uce_addr_vld3_apb_dff,mc_ecc_uce_addr3_apb_dff};
            default:
                prdata <= {APB_DATA_WIDTH{1'b1}}; //  means read a non-exist address
            endcase
        end
        else begin
            prdata <= {APB_DATA_WIDTH{1'b0}};
        end
    end
    // for read only logic.
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0)
        begin
        //read only signal.
            mc_id_apb_dff <= 32'h0;  //Register mc_id,Address 0x0
            err_wl0_apb_dff <= 13'h1FFF;  //Register err_wl0,Address 0xb0
            err_wl1_apb_dff <= 13'h1FFF;  //Register err_wl1,Address 0xb0
            err_wl2_apb_dff <= 13'h1FFF;  //Register err_wl2,Address 0xb4
            err_wl3_apb_dff <= 13'h1FFF;  //Register err_wl3,Address 0xb4
            err_wl4_apb_dff <= 13'h1FFF;  //Register err_wl4,Address 0xb8
            err_wl5_apb_dff <= 13'h1FFF;  //Register err_wl5,Address 0xb8
            err_wl6_apb_dff <= 13'h1FFF;  //Register err_wl6,Address 0xbc
            err_wl7_apb_dff <= 13'h1FFF;  //Register err_wl7,Address 0xbc
            err_wl8_apb_dff <= 13'h1FFF;  //Register err_wl8,Address 0xc0
            err_wl9_apb_dff <= 13'h1FFF;  //Register err_wl9,Address 0xc0
            err_wl10_apb_dff <= 13'h1FFF;  //Register err_wl10,Address 0xc4
            err_wl11_apb_dff <= 13'h1FFF;  //Register err_wl11,Address 0xc4
            err_wl12_apb_dff <= 13'h1FFF;  //Register err_wl12,Address 0xc8
            err_wl13_apb_dff <= 13'h1FFF;  //Register err_wl13,Address 0xc8
            err_wl14_apb_dff <= 13'h1FFF;  //Register err_wl14,Address 0xcc
            err_wl15_apb_dff <= 13'h1FFF;  //Register err_wl15,Address 0xcc
            err_wl16_apb_dff <= 13'h1FFF;  //Register err_wl16,Address 0xd0
            err_wl17_apb_dff <= 13'h1FFF;  //Register err_wl17,Address 0xd0
            err_wl18_apb_dff <= 13'h1FFF;  //Register err_wl18,Address 0xd4
            err_wl19_apb_dff <= 13'h1FFF;  //Register err_wl19,Address 0xd4
            err_wl20_apb_dff <= 13'h1FFF;  //Register err_wl20,Address 0xd8
            err_wl21_apb_dff <= 13'h1FFF;  //Register err_wl21,Address 0xd8
            err_wl22_apb_dff <= 13'h1FFF;  //Register err_wl22,Address 0xdc
            err_wl23_apb_dff <= 13'h1FFF;  //Register err_wl23,Address 0xdc
            err_wl24_apb_dff <= 13'h1FFF;  //Register err_wl24,Address 0xe0
            err_wl25_apb_dff <= 13'h1FFF;  //Register err_wl25,Address 0xe0
            err_wl26_apb_dff <= 13'h1FFF;  //Register err_wl26,Address 0xe4
            err_wl27_apb_dff <= 13'h1FFF;  //Register err_wl27,Address 0xe4
            err_wl28_apb_dff <= 13'h1FFF;  //Register err_wl28,Address 0xe8
            err_wl29_apb_dff <= 13'h1FFF;  //Register err_wl29,Address 0xe8
            err_wl30_apb_dff <= 13'h1FFF;  //Register err_wl30,Address 0xec
            err_wl31_apb_dff <= 13'h1FFF;  //Register err_wl31,Address 0xec
            err_wl32_apb_dff <= 13'h1FFF;  //Register err_wl32,Address 0xf0
            err_wl33_apb_dff <= 13'h1FFF;  //Register err_wl33,Address 0xf0
            err_wl34_apb_dff <= 13'h1FFF;  //Register err_wl34,Address 0xf4
            err_wl35_apb_dff <= 13'h1FFF;  //Register err_wl35,Address 0xf4
            err_wl36_apb_dff <= 13'h1FFF;  //Register err_wl36,Address 0xf8
            err_wl37_apb_dff <= 13'h1FFF;  //Register err_wl37,Address 0xf8
            err_wl38_apb_dff <= 13'h1FFF;  //Register err_wl38,Address 0xfc
            err_wl39_apb_dff <= 13'h1FFF;  //Register err_wl39,Address 0xfc
            err_wl40_apb_dff <= 13'h1FFF;  //Register err_wl40,Address 0x100
            err_wl41_apb_dff <= 13'h1FFF;  //Register err_wl41,Address 0x100
            err_wl42_apb_dff <= 13'h1FFF;  //Register err_wl42,Address 0x104
            err_wl43_apb_dff <= 13'h1FFF;  //Register err_wl43,Address 0x104
            err_wl44_apb_dff <= 13'h1FFF;  //Register err_wl44,Address 0x108
            err_wl45_apb_dff <= 13'h1FFF;  //Register err_wl45,Address 0x108
            err_wl46_apb_dff <= 13'h1FFF;  //Register err_wl46,Address 0x10c
            err_wl47_apb_dff <= 13'h1FFF;  //Register err_wl47,Address 0x10c
            err_wl48_apb_dff <= 13'h1FFF;  //Register err_wl48,Address 0x110
            err_wl49_apb_dff <= 13'h1FFF;  //Register err_wl49,Address 0x110
            err_wl50_apb_dff <= 13'h1FFF;  //Register err_wl50,Address 0x114
            err_wl51_apb_dff <= 13'h1FFF;  //Register err_wl51,Address 0x114
            err_wl52_apb_dff <= 13'h1FFF;  //Register err_wl52,Address 0x118
            err_wl53_apb_dff <= 13'h1FFF;  //Register err_wl53,Address 0x118
            err_wl54_apb_dff <= 13'h1FFF;  //Register err_wl54,Address 0x11c
            err_wl55_apb_dff <= 13'h1FFF;  //Register err_wl55,Address 0x11c
            err_wl56_apb_dff <= 13'h1FFF;  //Register err_wl56,Address 0x120
            err_wl57_apb_dff <= 13'h1FFF;  //Register err_wl57,Address 0x120
            err_wl58_apb_dff <= 13'h1FFF;  //Register err_wl58,Address 0x124
            err_wl59_apb_dff <= 13'h1FFF;  //Register err_wl59,Address 0x124
            err_wl60_apb_dff <= 13'h1FFF;  //Register err_wl60,Address 0x128
            err_wl61_apb_dff <= 13'h1FFF;  //Register err_wl61,Address 0x128
            err_wl62_apb_dff <= 13'h1FFF;  //Register err_wl62,Address 0x12c
            err_wl63_apb_dff <= 13'h1FFF;  //Register err_wl63,Address 0x12c
            err_csl0_part0_apb_dff <= 8'hFF;  //Register err_csl0_part0,Address 0x130
            err_csl1_part0_apb_dff <= 8'hFF;  //Register err_csl1_part0,Address 0x130
            err_csl0_part1_apb_dff <= 8'hFF;  //Register err_csl0_part1,Address 0x130
            err_csl1_part1_apb_dff <= 8'hFF;  //Register err_csl1_part1,Address 0x130
            err_csl0_part2_apb_dff <= 8'hFF;  //Register err_csl0_part2,Address 0x134
            err_csl1_part2_apb_dff <= 8'hFF;  //Register err_csl1_part2,Address 0x134
            err_csl0_part3_apb_dff <= 8'hFF;  //Register err_csl0_part3,Address 0x134
            err_csl1_part3_apb_dff <= 8'hFF;  //Register err_csl1_part3,Address 0x134
            err_csl0_part4_apb_dff <= 8'hFF;  //Register err_csl0_part4,Address 0x138
            err_csl1_part4_apb_dff <= 8'hFF;  //Register err_csl1_part4,Address 0x138
            err_csl0_part5_apb_dff <= 8'hFF;  //Register err_csl0_part5,Address 0x138
            err_csl1_part5_apb_dff <= 8'hFF;  //Register err_csl1_part5,Address 0x138
            err_csl0_part6_apb_dff <= 8'hFF;  //Register err_csl0_part6,Address 0x13c
            err_csl1_part6_apb_dff <= 8'hFF;  //Register err_csl1_part6,Address 0x13c
            err_csl0_part7_apb_dff <= 8'hFF;  //Register err_csl0_part7,Address 0x13c
            err_csl1_part7_apb_dff <= 8'hFF;  //Register err_csl1_part7,Address 0x13c
            err_csl0_part8_apb_dff <= 8'hFF;  //Register err_csl0_part8,Address 0x140
            err_csl1_part8_apb_dff <= 8'hFF;  //Register err_csl1_part8,Address 0x140
            err_csl0_part9_apb_dff <= 8'hFF;  //Register err_csl0_part9,Address 0x140
            err_csl1_part9_apb_dff <= 8'hFF;  //Register err_csl1_part9,Address 0x140
            mc_rf_start_dbg_apb_dff <= 1'b0;  //Register mc_rf_start_dbg,Address 0x148
            mc_timeout_flag_apb_dff <= 1'b0;  //Register mc_timeout_flag,Address 0x14c
            mc_bist_status_apb_dff <= 3'h0;  //Register mc_bist_status,Address 0x150
            mc_bist_path_fail_apb_dff <= 1'b0;  //Register mc_bist_path_fail,Address 0x150
            dram_init_finish_apb_dff <= 1'b0;  //Register dram_init_finish,Address 0x150
            bist_finish_apb_dff <= 1'b0;  //Register bist_finish,Address 0x154
            bist_rescan_finish_apb_dff <= 1'b0;  //Register bist_rescan_finish,Address 0x154
            bank_success_apb_dff <= 1'b0;  //Register bank_success,Address 0x158
            bist_rescan_success_apb_dff <= 1'b0;  //Register bist_rescan_success,Address 0x158
            mc_bist_rescan_fail_num_apb_dff <= 20'h0;  //Register mc_bist_rescan_fail_num,Address 0x15c
            mc_bist_err_wl_num_apb_dff <= 7'h0;  //Register mc_bist_err_wl_num,Address 0x160
            err_wl_num_change_flag_apb_dff <= 1'b0;  //Register err_wl_num_change_flag,Address 0x160
            rescan_round_result_apb_dff <= 15'h0;  //Register rescan_round_result,Address 0x16c
            dbg_next_state_array_apb_dff <= 5'h0;  //Register dbg_next_state_array,Address 0x1a4
            dbg_current_state_array_apb_dff <= 5'h0;  //Register dbg_current_state_array,Address 0x1a4
            dbg_r_data_cnt_apb_dff <= 2'h0;  //Register dbg_r_data_cnt,Address 0x1a4
            dbg_refresh_flag_apb_dff <= 1'b0;  //Register dbg_refresh_flag,Address 0x1a4
            dbg_r_frame_cnt_apb_dff <= 2'h0;  //Register dbg_r_frame_cnt,Address 0x1a4
            dbg_w_frame_cnt_apb_dff <= 2'h0;  //Register dbg_w_frame_cnt,Address 0x1a4
            dbg_frame_store_0_apb_dff <= 32'h0;  //Register dbg_frame_store_0,Address 0x1a8
            dbg_frame_store_1_apb_dff <= 32'h0;  //Register dbg_frame_store_1,Address 0x1ac
            dbg_frame_store_2_apb_dff <= 32'h0;  //Register dbg_frame_store_2,Address 0x1b0
            dbg_frame_store_3_apb_dff <= 32'h0;  //Register dbg_frame_store_3,Address 0x1b4
            dbg_frame_store_4_apb_dff <= 32'h0;  //Register dbg_frame_store_4,Address 0x1b8
            dbg_frame_store_5_apb_dff <= 32'h0;  //Register dbg_frame_store_5,Address 0x1bc
            dbg_frame_store_6_apb_dff <= 32'h0;  //Register dbg_frame_store_6,Address 0x1c0
            dbg_frame_store_7_apb_dff <= 32'h0;  //Register dbg_frame_store_7,Address 0x1c4
            dbg_frame_store_8_apb_dff <= 32'h0;  //Register dbg_frame_store_8,Address 0x1c8
            dbg_frame_store_9_apb_dff <= 2'h0;  //Register dbg_frame_store_9,Address 0x1cc
            dbg_rdata_store_0_apb_dff <= 32'h0;  //Register dbg_rdata_store_0,Address 0x1d0
            dbg_rdata_store_1_apb_dff <= 32'h0;  //Register dbg_rdata_store_1,Address 0x1d4
            dbg_rdata_store_2_apb_dff <= 32'h0;  //Register dbg_rdata_store_2,Address 0x1d8
            dbg_rdata_store_3_apb_dff <= 32'h0;  //Register dbg_rdata_store_3,Address 0x1dc
            dbg_rdata_store_4_apb_dff <= 32'h0;  //Register dbg_rdata_store_4,Address 0x1e0
            dbg_rdata_store_5_apb_dff <= 32'h0;  //Register dbg_rdata_store_5,Address 0x1e4
            dbg_rdata_store_6_apb_dff <= 32'h0;  //Register dbg_rdata_store_6,Address 0x1e8
            dbg_rdata_store_7_apb_dff <= 32'h0;  //Register dbg_rdata_store_7,Address 0x1ec
            dbg_rdata_store_8_apb_dff <= 10'h0;  //Register dbg_rdata_store_8,Address 0x1f0
            mc_page_status_apb_dff <= 1'b1;  //Register mc_page_status,Address 0x1f4
            hang_timeout_status_apb_dff <= 1'b0;  //Register hang_timeout_status,Address 0x1f8
            mc_ecc_ce_overflow_int_apb_dff <= 1'b0;  //Register mc_ecc_ce_overflow_int,Address 0x208
            mc_ecc_ce_cnt_apb_dff <= 5'h0;  //Register mc_ecc_ce_cnt,Address 0x208
            mc_ecc_ce_addr0_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr0,Address 0x20c
            mc_ecc_ce_addr_vld0_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld0,Address 0x20c
            mc_ecc_ce_addr1_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr1,Address 0x210
            mc_ecc_ce_addr_vld1_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld1,Address 0x210
            mc_ecc_ce_addr2_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr2,Address 0x214
            mc_ecc_ce_addr_vld2_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld2,Address 0x214
            mc_ecc_ce_addr3_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr3,Address 0x218
            mc_ecc_ce_addr_vld3_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld3,Address 0x218
            mc_ecc_ce_addr4_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr4,Address 0x21c
            mc_ecc_ce_addr_vld4_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld4,Address 0x21c
            mc_ecc_ce_addr5_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr5,Address 0x220
            mc_ecc_ce_addr_vld5_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld5,Address 0x220
            mc_ecc_ce_addr6_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr6,Address 0x224
            mc_ecc_ce_addr_vld6_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld6,Address 0x224
            mc_ecc_ce_addr7_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr7,Address 0x228
            mc_ecc_ce_addr_vld7_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld7,Address 0x228
            mc_ecc_ce_addr8_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr8,Address 0x22c
            mc_ecc_ce_addr_vld8_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld8,Address 0x22c
            mc_ecc_ce_addr9_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr9,Address 0x230
            mc_ecc_ce_addr_vld9_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld9,Address 0x230
            mc_ecc_ce_addr10_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr10,Address 0x234
            mc_ecc_ce_addr_vld10_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld10,Address 0x234
            mc_ecc_ce_addr11_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr11,Address 0x238
            mc_ecc_ce_addr_vld11_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld11,Address 0x238
            mc_ecc_ce_addr12_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr12,Address 0x23c
            mc_ecc_ce_addr_vld12_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld12,Address 0x23c
            mc_ecc_ce_addr13_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr13,Address 0x240
            mc_ecc_ce_addr_vld13_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld13,Address 0x240
            mc_ecc_ce_addr14_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr14,Address 0x244
            mc_ecc_ce_addr_vld14_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld14,Address 0x244
            mc_ecc_ce_addr15_apb_dff <= 22'h0;  //Register mc_ecc_ce_addr15,Address 0x248
            mc_ecc_ce_addr_vld15_apb_dff <= 1'b0;  //Register mc_ecc_ce_addr_vld15,Address 0x248
            mc_ecc_uce_int_apb_dff <= 1'b0;  //Register mc_ecc_uce_int,Address 0x24c
            mc_ecc_uce_cnt_apb_dff <= 3'h0;  //Register mc_ecc_uce_cnt,Address 0x24c
            mc_ecc_uce_addr0_apb_dff <= 22'h0;  //Register mc_ecc_uce_addr0,Address 0x250
            mc_ecc_uce_addr_vld0_apb_dff <= 1'b0;  //Register mc_ecc_uce_addr_vld0,Address 0x250
            mc_ecc_uce_addr1_apb_dff <= 22'h0;  //Register mc_ecc_uce_addr1,Address 0x254
            mc_ecc_uce_addr_vld1_apb_dff <= 1'b0;  //Register mc_ecc_uce_addr_vld1,Address 0x254
            mc_ecc_uce_addr2_apb_dff <= 22'h0;  //Register mc_ecc_uce_addr2,Address 0x258
            mc_ecc_uce_addr_vld2_apb_dff <= 1'b0;  //Register mc_ecc_uce_addr_vld2,Address 0x258
            mc_ecc_uce_addr3_apb_dff <= 22'h0;  //Register mc_ecc_uce_addr3,Address 0x25c
            mc_ecc_uce_addr_vld3_apb_dff <= 1'b0;  //Register mc_ecc_uce_addr_vld3,Address 0x25c
        end
        else
        begin
        //read only signal,input from other module
            mc_id_apb_dff <= mc_id_i; //Register mc_id,Address 0x0
            err_wl0_apb_dff <= err_wl0_i; //Register err_wl0,Address 0xb0
            err_wl1_apb_dff <= err_wl1_i; //Register err_wl1,Address 0xb0
            err_wl2_apb_dff <= err_wl2_i; //Register err_wl2,Address 0xb4
            err_wl3_apb_dff <= err_wl3_i; //Register err_wl3,Address 0xb4
            err_wl4_apb_dff <= err_wl4_i; //Register err_wl4,Address 0xb8
            err_wl5_apb_dff <= err_wl5_i; //Register err_wl5,Address 0xb8
            err_wl6_apb_dff <= err_wl6_i; //Register err_wl6,Address 0xbc
            err_wl7_apb_dff <= err_wl7_i; //Register err_wl7,Address 0xbc
            err_wl8_apb_dff <= err_wl8_i; //Register err_wl8,Address 0xc0
            err_wl9_apb_dff <= err_wl9_i; //Register err_wl9,Address 0xc0
            err_wl10_apb_dff <= err_wl10_i; //Register err_wl10,Address 0xc4
            err_wl11_apb_dff <= err_wl11_i; //Register err_wl11,Address 0xc4
            err_wl12_apb_dff <= err_wl12_i; //Register err_wl12,Address 0xc8
            err_wl13_apb_dff <= err_wl13_i; //Register err_wl13,Address 0xc8
            err_wl14_apb_dff <= err_wl14_i; //Register err_wl14,Address 0xcc
            err_wl15_apb_dff <= err_wl15_i; //Register err_wl15,Address 0xcc
            err_wl16_apb_dff <= err_wl16_i; //Register err_wl16,Address 0xd0
            err_wl17_apb_dff <= err_wl17_i; //Register err_wl17,Address 0xd0
            err_wl18_apb_dff <= err_wl18_i; //Register err_wl18,Address 0xd4
            err_wl19_apb_dff <= err_wl19_i; //Register err_wl19,Address 0xd4
            err_wl20_apb_dff <= err_wl20_i; //Register err_wl20,Address 0xd8
            err_wl21_apb_dff <= err_wl21_i; //Register err_wl21,Address 0xd8
            err_wl22_apb_dff <= err_wl22_i; //Register err_wl22,Address 0xdc
            err_wl23_apb_dff <= err_wl23_i; //Register err_wl23,Address 0xdc
            err_wl24_apb_dff <= err_wl24_i; //Register err_wl24,Address 0xe0
            err_wl25_apb_dff <= err_wl25_i; //Register err_wl25,Address 0xe0
            err_wl26_apb_dff <= err_wl26_i; //Register err_wl26,Address 0xe4
            err_wl27_apb_dff <= err_wl27_i; //Register err_wl27,Address 0xe4
            err_wl28_apb_dff <= err_wl28_i; //Register err_wl28,Address 0xe8
            err_wl29_apb_dff <= err_wl29_i; //Register err_wl29,Address 0xe8
            err_wl30_apb_dff <= err_wl30_i; //Register err_wl30,Address 0xec
            err_wl31_apb_dff <= err_wl31_i; //Register err_wl31,Address 0xec
            err_wl32_apb_dff <= err_wl32_i; //Register err_wl32,Address 0xf0
            err_wl33_apb_dff <= err_wl33_i; //Register err_wl33,Address 0xf0
            err_wl34_apb_dff <= err_wl34_i; //Register err_wl34,Address 0xf4
            err_wl35_apb_dff <= err_wl35_i; //Register err_wl35,Address 0xf4
            err_wl36_apb_dff <= err_wl36_i; //Register err_wl36,Address 0xf8
            err_wl37_apb_dff <= err_wl37_i; //Register err_wl37,Address 0xf8
            err_wl38_apb_dff <= err_wl38_i; //Register err_wl38,Address 0xfc
            err_wl39_apb_dff <= err_wl39_i; //Register err_wl39,Address 0xfc
            err_wl40_apb_dff <= err_wl40_i; //Register err_wl40,Address 0x100
            err_wl41_apb_dff <= err_wl41_i; //Register err_wl41,Address 0x100
            err_wl42_apb_dff <= err_wl42_i; //Register err_wl42,Address 0x104
            err_wl43_apb_dff <= err_wl43_i; //Register err_wl43,Address 0x104
            err_wl44_apb_dff <= err_wl44_i; //Register err_wl44,Address 0x108
            err_wl45_apb_dff <= err_wl45_i; //Register err_wl45,Address 0x108
            err_wl46_apb_dff <= err_wl46_i; //Register err_wl46,Address 0x10c
            err_wl47_apb_dff <= err_wl47_i; //Register err_wl47,Address 0x10c
            err_wl48_apb_dff <= err_wl48_i; //Register err_wl48,Address 0x110
            err_wl49_apb_dff <= err_wl49_i; //Register err_wl49,Address 0x110
            err_wl50_apb_dff <= err_wl50_i; //Register err_wl50,Address 0x114
            err_wl51_apb_dff <= err_wl51_i; //Register err_wl51,Address 0x114
            err_wl52_apb_dff <= err_wl52_i; //Register err_wl52,Address 0x118
            err_wl53_apb_dff <= err_wl53_i; //Register err_wl53,Address 0x118
            err_wl54_apb_dff <= err_wl54_i; //Register err_wl54,Address 0x11c
            err_wl55_apb_dff <= err_wl55_i; //Register err_wl55,Address 0x11c
            err_wl56_apb_dff <= err_wl56_i; //Register err_wl56,Address 0x120
            err_wl57_apb_dff <= err_wl57_i; //Register err_wl57,Address 0x120
            err_wl58_apb_dff <= err_wl58_i; //Register err_wl58,Address 0x124
            err_wl59_apb_dff <= err_wl59_i; //Register err_wl59,Address 0x124
            err_wl60_apb_dff <= err_wl60_i; //Register err_wl60,Address 0x128
            err_wl61_apb_dff <= err_wl61_i; //Register err_wl61,Address 0x128
            err_wl62_apb_dff <= err_wl62_i; //Register err_wl62,Address 0x12c
            err_wl63_apb_dff <= err_wl63_i; //Register err_wl63,Address 0x12c
            err_csl0_part0_apb_dff <= err_csl0_part0_i; //Register err_csl0_part0,Address 0x130
            err_csl1_part0_apb_dff <= err_csl1_part0_i; //Register err_csl1_part0,Address 0x130
            err_csl0_part1_apb_dff <= err_csl0_part1_i; //Register err_csl0_part1,Address 0x130
            err_csl1_part1_apb_dff <= err_csl1_part1_i; //Register err_csl1_part1,Address 0x130
            err_csl0_part2_apb_dff <= err_csl0_part2_i; //Register err_csl0_part2,Address 0x134
            err_csl1_part2_apb_dff <= err_csl1_part2_i; //Register err_csl1_part2,Address 0x134
            err_csl0_part3_apb_dff <= err_csl0_part3_i; //Register err_csl0_part3,Address 0x134
            err_csl1_part3_apb_dff <= err_csl1_part3_i; //Register err_csl1_part3,Address 0x134
            err_csl0_part4_apb_dff <= err_csl0_part4_i; //Register err_csl0_part4,Address 0x138
            err_csl1_part4_apb_dff <= err_csl1_part4_i; //Register err_csl1_part4,Address 0x138
            err_csl0_part5_apb_dff <= err_csl0_part5_i; //Register err_csl0_part5,Address 0x138
            err_csl1_part5_apb_dff <= err_csl1_part5_i; //Register err_csl1_part5,Address 0x138
            err_csl0_part6_apb_dff <= err_csl0_part6_i; //Register err_csl0_part6,Address 0x13c
            err_csl1_part6_apb_dff <= err_csl1_part6_i; //Register err_csl1_part6,Address 0x13c
            err_csl0_part7_apb_dff <= err_csl0_part7_i; //Register err_csl0_part7,Address 0x13c
            err_csl1_part7_apb_dff <= err_csl1_part7_i; //Register err_csl1_part7,Address 0x13c
            err_csl0_part8_apb_dff <= err_csl0_part8_i; //Register err_csl0_part8,Address 0x140
            err_csl1_part8_apb_dff <= err_csl1_part8_i; //Register err_csl1_part8,Address 0x140
            err_csl0_part9_apb_dff <= err_csl0_part9_i; //Register err_csl0_part9,Address 0x140
            err_csl1_part9_apb_dff <= err_csl1_part9_i; //Register err_csl1_part9,Address 0x140
            mc_rf_start_dbg_apb_dff <= mc_rf_start_dbg_i; //Register mc_rf_start_dbg,Address 0x148
            mc_timeout_flag_apb_dff <= mc_timeout_flag_i; //Register mc_timeout_flag,Address 0x14c
            mc_bist_status_apb_dff <= mc_bist_status_i; //Register mc_bist_status,Address 0x150
            mc_bist_path_fail_apb_dff <= mc_bist_path_fail_i; //Register mc_bist_path_fail,Address 0x150
            dram_init_finish_apb_dff <= dram_init_finish_i; //Register dram_init_finish,Address 0x150
            bist_finish_apb_dff <= bist_finish_i; //Register bist_finish,Address 0x154
            bist_rescan_finish_apb_dff <= bist_rescan_finish_i; //Register bist_rescan_finish,Address 0x154
            bank_success_apb_dff <= bank_success_i; //Register bank_success,Address 0x158
            bist_rescan_success_apb_dff <= bist_rescan_success_i; //Register bist_rescan_success,Address 0x158
            mc_bist_rescan_fail_num_apb_dff <= mc_bist_rescan_fail_num_i; //Register mc_bist_rescan_fail_num,Address 0x15c
            mc_bist_err_wl_num_apb_dff <= mc_bist_err_wl_num_i; //Register mc_bist_err_wl_num,Address 0x160
            err_wl_num_change_flag_apb_dff <= err_wl_num_change_flag_i; //Register err_wl_num_change_flag,Address 0x160
            rescan_round_result_apb_dff <= rescan_round_result_i; //Register rescan_round_result,Address 0x16c
            dbg_next_state_array_apb_dff <= dbg_next_state_array_i; //Register dbg_next_state_array,Address 0x1a4
            dbg_current_state_array_apb_dff <= dbg_current_state_array_i; //Register dbg_current_state_array,Address 0x1a4
            dbg_r_data_cnt_apb_dff <= dbg_r_data_cnt_i; //Register dbg_r_data_cnt,Address 0x1a4
            dbg_refresh_flag_apb_dff <= dbg_refresh_flag_i; //Register dbg_refresh_flag,Address 0x1a4
            dbg_r_frame_cnt_apb_dff <= dbg_r_frame_cnt_i; //Register dbg_r_frame_cnt,Address 0x1a4
            dbg_w_frame_cnt_apb_dff <= dbg_w_frame_cnt_i; //Register dbg_w_frame_cnt,Address 0x1a4
            dbg_frame_store_0_apb_dff <= dbg_frame_store_0_i; //Register dbg_frame_store_0,Address 0x1a8
            dbg_frame_store_1_apb_dff <= dbg_frame_store_1_i; //Register dbg_frame_store_1,Address 0x1ac
            dbg_frame_store_2_apb_dff <= dbg_frame_store_2_i; //Register dbg_frame_store_2,Address 0x1b0
            dbg_frame_store_3_apb_dff <= dbg_frame_store_3_i; //Register dbg_frame_store_3,Address 0x1b4
            dbg_frame_store_4_apb_dff <= dbg_frame_store_4_i; //Register dbg_frame_store_4,Address 0x1b8
            dbg_frame_store_5_apb_dff <= dbg_frame_store_5_i; //Register dbg_frame_store_5,Address 0x1bc
            dbg_frame_store_6_apb_dff <= dbg_frame_store_6_i; //Register dbg_frame_store_6,Address 0x1c0
            dbg_frame_store_7_apb_dff <= dbg_frame_store_7_i; //Register dbg_frame_store_7,Address 0x1c4
            dbg_frame_store_8_apb_dff <= dbg_frame_store_8_i; //Register dbg_frame_store_8,Address 0x1c8
            dbg_frame_store_9_apb_dff <= dbg_frame_store_9_i; //Register dbg_frame_store_9,Address 0x1cc
            dbg_rdata_store_0_apb_dff <= dbg_rdata_store_0_i; //Register dbg_rdata_store_0,Address 0x1d0
            dbg_rdata_store_1_apb_dff <= dbg_rdata_store_1_i; //Register dbg_rdata_store_1,Address 0x1d4
            dbg_rdata_store_2_apb_dff <= dbg_rdata_store_2_i; //Register dbg_rdata_store_2,Address 0x1d8
            dbg_rdata_store_3_apb_dff <= dbg_rdata_store_3_i; //Register dbg_rdata_store_3,Address 0x1dc
            dbg_rdata_store_4_apb_dff <= dbg_rdata_store_4_i; //Register dbg_rdata_store_4,Address 0x1e0
            dbg_rdata_store_5_apb_dff <= dbg_rdata_store_5_i; //Register dbg_rdata_store_5,Address 0x1e4
            dbg_rdata_store_6_apb_dff <= dbg_rdata_store_6_i; //Register dbg_rdata_store_6,Address 0x1e8
            dbg_rdata_store_7_apb_dff <= dbg_rdata_store_7_i; //Register dbg_rdata_store_7,Address 0x1ec
            dbg_rdata_store_8_apb_dff <= dbg_rdata_store_8_i; //Register dbg_rdata_store_8,Address 0x1f0
            mc_page_status_apb_dff <= mc_page_status_i; //Register mc_page_status,Address 0x1f4
            hang_timeout_status_apb_dff <= hang_timeout_status_i; //Register hang_timeout_status,Address 0x1f8
            mc_ecc_ce_overflow_int_apb_dff <= mc_ecc_ce_overflow_int_i; //Register mc_ecc_ce_overflow_int,Address 0x208
            mc_ecc_ce_cnt_apb_dff <= mc_ecc_ce_cnt_i; //Register mc_ecc_ce_cnt,Address 0x208
            mc_ecc_ce_addr0_apb_dff <= mc_ecc_ce_addr0_i; //Register mc_ecc_ce_addr0,Address 0x20c
            mc_ecc_ce_addr_vld0_apb_dff <= mc_ecc_ce_addr_vld0_i; //Register mc_ecc_ce_addr_vld0,Address 0x20c
            mc_ecc_ce_addr1_apb_dff <= mc_ecc_ce_addr1_i; //Register mc_ecc_ce_addr1,Address 0x210
            mc_ecc_ce_addr_vld1_apb_dff <= mc_ecc_ce_addr_vld1_i; //Register mc_ecc_ce_addr_vld1,Address 0x210
            mc_ecc_ce_addr2_apb_dff <= mc_ecc_ce_addr2_i; //Register mc_ecc_ce_addr2,Address 0x214
            mc_ecc_ce_addr_vld2_apb_dff <= mc_ecc_ce_addr_vld2_i; //Register mc_ecc_ce_addr_vld2,Address 0x214
            mc_ecc_ce_addr3_apb_dff <= mc_ecc_ce_addr3_i; //Register mc_ecc_ce_addr3,Address 0x218
            mc_ecc_ce_addr_vld3_apb_dff <= mc_ecc_ce_addr_vld3_i; //Register mc_ecc_ce_addr_vld3,Address 0x218
            mc_ecc_ce_addr4_apb_dff <= mc_ecc_ce_addr4_i; //Register mc_ecc_ce_addr4,Address 0x21c
            mc_ecc_ce_addr_vld4_apb_dff <= mc_ecc_ce_addr_vld4_i; //Register mc_ecc_ce_addr_vld4,Address 0x21c
            mc_ecc_ce_addr5_apb_dff <= mc_ecc_ce_addr5_i; //Register mc_ecc_ce_addr5,Address 0x220
            mc_ecc_ce_addr_vld5_apb_dff <= mc_ecc_ce_addr_vld5_i; //Register mc_ecc_ce_addr_vld5,Address 0x220
            mc_ecc_ce_addr6_apb_dff <= mc_ecc_ce_addr6_i; //Register mc_ecc_ce_addr6,Address 0x224
            mc_ecc_ce_addr_vld6_apb_dff <= mc_ecc_ce_addr_vld6_i; //Register mc_ecc_ce_addr_vld6,Address 0x224
            mc_ecc_ce_addr7_apb_dff <= mc_ecc_ce_addr7_i; //Register mc_ecc_ce_addr7,Address 0x228
            mc_ecc_ce_addr_vld7_apb_dff <= mc_ecc_ce_addr_vld7_i; //Register mc_ecc_ce_addr_vld7,Address 0x228
            mc_ecc_ce_addr8_apb_dff <= mc_ecc_ce_addr8_i; //Register mc_ecc_ce_addr8,Address 0x22c
            mc_ecc_ce_addr_vld8_apb_dff <= mc_ecc_ce_addr_vld8_i; //Register mc_ecc_ce_addr_vld8,Address 0x22c
            mc_ecc_ce_addr9_apb_dff <= mc_ecc_ce_addr9_i; //Register mc_ecc_ce_addr9,Address 0x230
            mc_ecc_ce_addr_vld9_apb_dff <= mc_ecc_ce_addr_vld9_i; //Register mc_ecc_ce_addr_vld9,Address 0x230
            mc_ecc_ce_addr10_apb_dff <= mc_ecc_ce_addr10_i; //Register mc_ecc_ce_addr10,Address 0x234
            mc_ecc_ce_addr_vld10_apb_dff <= mc_ecc_ce_addr_vld10_i; //Register mc_ecc_ce_addr_vld10,Address 0x234
            mc_ecc_ce_addr11_apb_dff <= mc_ecc_ce_addr11_i; //Register mc_ecc_ce_addr11,Address 0x238
            mc_ecc_ce_addr_vld11_apb_dff <= mc_ecc_ce_addr_vld11_i; //Register mc_ecc_ce_addr_vld11,Address 0x238
            mc_ecc_ce_addr12_apb_dff <= mc_ecc_ce_addr12_i; //Register mc_ecc_ce_addr12,Address 0x23c
            mc_ecc_ce_addr_vld12_apb_dff <= mc_ecc_ce_addr_vld12_i; //Register mc_ecc_ce_addr_vld12,Address 0x23c
            mc_ecc_ce_addr13_apb_dff <= mc_ecc_ce_addr13_i; //Register mc_ecc_ce_addr13,Address 0x240
            mc_ecc_ce_addr_vld13_apb_dff <= mc_ecc_ce_addr_vld13_i; //Register mc_ecc_ce_addr_vld13,Address 0x240
            mc_ecc_ce_addr14_apb_dff <= mc_ecc_ce_addr14_i; //Register mc_ecc_ce_addr14,Address 0x244
            mc_ecc_ce_addr_vld14_apb_dff <= mc_ecc_ce_addr_vld14_i; //Register mc_ecc_ce_addr_vld14,Address 0x244
            mc_ecc_ce_addr15_apb_dff <= mc_ecc_ce_addr15_i; //Register mc_ecc_ce_addr15,Address 0x248
            mc_ecc_ce_addr_vld15_apb_dff <= mc_ecc_ce_addr_vld15_i; //Register mc_ecc_ce_addr_vld15,Address 0x248
            mc_ecc_uce_int_apb_dff <= mc_ecc_uce_int_i; //Register mc_ecc_uce_int,Address 0x24c
            mc_ecc_uce_cnt_apb_dff <= mc_ecc_uce_cnt_i; //Register mc_ecc_uce_cnt,Address 0x24c
            mc_ecc_uce_addr0_apb_dff <= mc_ecc_uce_addr0_i; //Register mc_ecc_uce_addr0,Address 0x250
            mc_ecc_uce_addr_vld0_apb_dff <= mc_ecc_uce_addr_vld0_i; //Register mc_ecc_uce_addr_vld0,Address 0x250
            mc_ecc_uce_addr1_apb_dff <= mc_ecc_uce_addr1_i; //Register mc_ecc_uce_addr1,Address 0x254
            mc_ecc_uce_addr_vld1_apb_dff <= mc_ecc_uce_addr_vld1_i; //Register mc_ecc_uce_addr_vld1,Address 0x254
            mc_ecc_uce_addr2_apb_dff <= mc_ecc_uce_addr2_i; //Register mc_ecc_uce_addr2,Address 0x258
            mc_ecc_uce_addr_vld2_apb_dff <= mc_ecc_uce_addr_vld2_i; //Register mc_ecc_uce_addr_vld2,Address 0x258
            mc_ecc_uce_addr3_apb_dff <= mc_ecc_uce_addr3_i; //Register mc_ecc_uce_addr3,Address 0x25c
            mc_ecc_uce_addr_vld3_apb_dff <= mc_ecc_uce_addr_vld3_i; //Register mc_ecc_uce_addr_vld3,Address 0x25c
        end
    end
    // register name : mc_timeout_clr_reg , address:0x144
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_timeout_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h144)) begin
            mc_timeout_clr_o <= pwdata[0];
        end
        else
            mc_timeout_clr_o <= 1'b0;

    end
    // register name : rescan_finish_clr_reg , address:0x164
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            rescan_finish_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h164)) begin
            rescan_finish_clr_o <= pwdata[0];
        end
        else
            rescan_finish_clr_o <= 1'b0;

    end
    // register name : bist_finish_clr_reg , address:0x170
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_finish_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h170)) begin
            bist_finish_clr_o <= pwdata[0];
        end
        else
            bist_finish_clr_o <= 1'b0;

    end
    // register name : hang_timeout_clr_reg , address:0x200
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h200)) begin
            hang_timeout_clr_o <= pwdata[0];
        end
        else
            hang_timeout_clr_o <= 1'b0;

    end
    // register name : mc_ecc_ce_ctrl , address:0x208
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_ecc_ce_int_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h208)) begin
            mc_ecc_ce_int_clr_o <= pwdata[0];
        end
        else
            mc_ecc_ce_int_clr_o <= 1'b0;

    end
    // register name : mc_ecc_uce_ctrl , address:0x24c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_ecc_uce_int_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h24c)) begin
            mc_ecc_uce_int_clr_o <= pwdata[0];
        end
        else
            mc_ecc_uce_int_clr_o <= 1'b0;

    end
endmodule
// Below is the information of "mc_top_aux" in register sheet, can use as a reference if have unexpected issues in this verilog file.
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
// 0x4___(mc_work_ctrl_reg)___(mc_ecc_en)___12___1___RW___0x0
// 0x4___(mc_work_ctrl_reg)___(mc_rf_burst_split_en)___13___1___RW___0x1
// 0x4___(mc_work_ctrl_reg)___(reserved)___14___18___NA___0x0
// 0x8___(phy_timing_cfg0_reg)___(bank_radd_set_time)___0___8___RW___0x0
// 0x8___(phy_timing_cfg0_reg)___(cadd_set_time)___8___4___RW___0x0
// 0x8___(phy_timing_cfg0_reg)___(r_cas_set_time)___12___8___RW___0x0
// 0x8___(phy_timing_cfg0_reg)___(w_cas_set_time)___20___8___RW___0x0
// 0x8___(phy_timing_cfg0_reg)___(reserved)___28___4___NA___0x0
// 0xc___(mc_rf_period_cfg1_reg)___(mc_rf_period_1)___0___32___RW___0x30D4000
// 0x10___(mc_rf_start_cfg1_reg)___(mc_rf_start_1)___0___32___RW___0xFFFFFFFF
// 0x14___(mc_rf_period_cfg2_reg)___(mc_rf_period_2)___0___32___RW___0x30D4000
// 0x18___(mc_rf_start_cfg2_reg)___(mc_rf_start_2)___0___32___RW___0xFFFFFFFF
// 0x1c___(mc_vmc_wl_num0_1_reg)___(mc_vmc_wl_num0)___0___13___RW___0x1FFF
// 0x1c___(mc_vmc_wl_num0_1_reg)___(mc_vmc_wl_num1)___13___13___RW___0x1FFF
// 0x1c___(mc_vmc_wl_num0_1_reg)___(reserved)___26___6___NA___NA
// 0x20___(mc_vmc_wl_num2_3_reg)___(mc_vmc_wl_num2)___0___13___RW___0x1FFF
// 0x20___(mc_vmc_wl_num2_3_reg)___(mc_vmc_wl_num3)___13___13___RW___0x1FFF
// 0x20___(mc_vmc_wl_num2_3_reg)___(reserved)___26___6___NA___NA
// 0x24___(mc_vmc_wl_num4_5_reg)___(mc_vmc_wl_num4)___0___13___RW___0x1FFF
// 0x24___(mc_vmc_wl_num4_5_reg)___(mc_vmc_wl_num5)___13___13___RW___0x1FFF
// 0x24___(mc_vmc_wl_num4_5_reg)___(reserved)___26___6___NA___NA
// 0x28___(mc_vmc_wl_num6_7_reg)___(mc_vmc_wl_num6)___0___13___RW___0x1FFF
// 0x28___(mc_vmc_wl_num6_7_reg)___(mc_vmc_wl_num7)___13___13___RW___0x1FFF
// 0x28___(mc_vmc_wl_num6_7_reg)___(reserved)___26___6___NA___NA
// 0x2c___(mc_vmc_wl_num8_9_reg)___(mc_vmc_wl_num8)___0___13___RW___0x1FFF
// 0x2c___(mc_vmc_wl_num8_9_reg)___(mc_vmc_wl_num9)___13___13___RW___0x1FFF
// 0x2c___(mc_vmc_wl_num8_9_reg)___(reserved)___26___6___NA___NA
// 0x30___(mc_vmc_wl_num10_11_reg)___(mc_vmc_wl_num10)___0___13___RW___0x1FFF
// 0x30___(mc_vmc_wl_num10_11_reg)___(mc_vmc_wl_num11)___13___13___RW___0x1FFF
// 0x30___(mc_vmc_wl_num10_11_reg)___(reserved)___26___6___NA___NA
// 0x34___(mc_vmc_wl_num12_13_reg)___(mc_vmc_wl_num12)___0___13___RW___0x1FFF
// 0x34___(mc_vmc_wl_num12_13_reg)___(mc_vmc_wl_num13)___13___13___RW___0x1FFF
// 0x34___(mc_vmc_wl_num12_13_reg)___(reserved)___26___6___NA___NA
// 0x38___(mc_vmc_wl_num14_15_reg)___(mc_vmc_wl_num14)___0___13___RW___0x1FFF
// 0x38___(mc_vmc_wl_num14_15_reg)___(mc_vmc_wl_num15)___13___13___RW___0x1FFF
// 0x38___(mc_vmc_wl_num14_15_reg)___(reserved)___26___6___NA___NA
// 0x3c___(mc_vmc_wl_num16_17_reg)___(mc_vmc_wl_num16)___0___13___RW___0x1FFF
// 0x3c___(mc_vmc_wl_num16_17_reg)___(mc_vmc_wl_num17)___13___13___RW___0x1FFF
// 0x3c___(mc_vmc_wl_num16_17_reg)___(reserved)___26___6___NA___NA
// 0x40___(mc_vmc_wl_num18_19_reg)___(mc_vmc_wl_num18)___0___13___RW___0x1FFF
// 0x40___(mc_vmc_wl_num18_19_reg)___(mc_vmc_wl_num19)___13___13___RW___0x1FFF
// 0x40___(mc_vmc_wl_num18_19_reg)___(reserved)___26___6___NA___NA
// 0x44___(mc_vmc_wl_num20_21_reg)___(mc_vmc_wl_num20)___0___13___RW___0x1FFF
// 0x44___(mc_vmc_wl_num20_21_reg)___(mc_vmc_wl_num21)___13___13___RW___0x1FFF
// 0x44___(mc_vmc_wl_num20_21_reg)___(reserved)___26___6___NA___NA
// 0x48___(mc_vmc_wl_num22_23_reg)___(mc_vmc_wl_num22)___0___13___RW___0x1FFF
// 0x48___(mc_vmc_wl_num22_23_reg)___(mc_vmc_wl_num23)___13___13___RW___0x1FFF
// 0x48___(mc_vmc_wl_num22_23_reg)___(reserved)___26___6___NA___NA
// 0x4c___(mc_vmc_wl_num24_25_reg)___(mc_vmc_wl_num24)___0___13___RW___0x1FFF
// 0x4c___(mc_vmc_wl_num24_25_reg)___(mc_vmc_wl_num25)___13___13___RW___0x1FFF
// 0x4c___(mc_vmc_wl_num24_25_reg)___(reserved)___26___6___NA___NA
// 0x50___(mc_vmc_wl_num26_27_reg)___(mc_vmc_wl_num26)___0___13___RW___0x1FFF
// 0x50___(mc_vmc_wl_num26_27_reg)___(mc_vmc_wl_num27)___13___13___RW___0x1FFF
// 0x50___(mc_vmc_wl_num26_27_reg)___(reserved)___26___6___NA___NA
// 0x54___(mc_vmc_wl_num28_29_reg)___(mc_vmc_wl_num28)___0___13___RW___0x1FFF
// 0x54___(mc_vmc_wl_num28_29_reg)___(mc_vmc_wl_num29)___13___13___RW___0x1FFF
// 0x54___(mc_vmc_wl_num28_29_reg)___(reserved)___26___6___NA___NA
// 0x58___(mc_vmc_wl_num30_31_reg)___(mc_vmc_wl_num30)___0___13___RW___0x1FFF
// 0x58___(mc_vmc_wl_num30_31_reg)___(mc_vmc_wl_num31)___13___13___RW___0x1FFF
// 0x58___(mc_vmc_wl_num30_31_reg)___(reserved)___26___6___NA___NA
// 0x5c___(mc_vmc_wl_num32_33_reg)___(mc_vmc_wl_num32)___0___13___RW___0x1FFF
// 0x5c___(mc_vmc_wl_num32_33_reg)___(mc_vmc_wl_num33)___13___13___RW___0x1FFF
// 0x5c___(mc_vmc_wl_num32_33_reg)___(reserved)___26___6___NA___NA
// 0x60___(mc_vmc_wl_num34_35_reg)___(mc_vmc_wl_num34)___0___13___RW___0x1FFF
// 0x60___(mc_vmc_wl_num34_35_reg)___(mc_vmc_wl_num35)___13___13___RW___0x1FFF
// 0x60___(mc_vmc_wl_num34_35_reg)___(reserved)___26___6___NA___NA
// 0x64___(mc_vmc_wl_num36_37_reg)___(mc_vmc_wl_num36)___0___13___RW___0x1FFF
// 0x64___(mc_vmc_wl_num36_37_reg)___(mc_vmc_wl_num37)___13___13___RW___0x1FFF
// 0x64___(mc_vmc_wl_num36_37_reg)___(reserved)___26___6___NA___NA
// 0x68___(mc_vmc_wl_num38_39_reg)___(mc_vmc_wl_num38)___0___13___RW___0x1FFF
// 0x68___(mc_vmc_wl_num38_39_reg)___(mc_vmc_wl_num39)___13___13___RW___0x1FFF
// 0x68___(mc_vmc_wl_num38_39_reg)___(reserved)___26___6___NA___NA
// 0x6c___(mc_vmc_wl_num40_41_reg)___(mc_vmc_wl_num40)___0___13___RW___0x1FFF
// 0x6c___(mc_vmc_wl_num40_41_reg)___(mc_vmc_wl_num41)___13___13___RW___0x1FFF
// 0x6c___(mc_vmc_wl_num40_41_reg)___(reserved)___26___6___NA___NA
// 0x70___(mc_vmc_wl_num42_43_reg)___(mc_vmc_wl_num42)___0___13___RW___0x1FFF
// 0x70___(mc_vmc_wl_num42_43_reg)___(mc_vmc_wl_num43)___13___13___RW___0x1FFF
// 0x70___(mc_vmc_wl_num42_43_reg)___(reserved)___26___6___NA___NA
// 0x74___(mc_vmc_wl_num44_45_reg)___(mc_vmc_wl_num44)___0___13___RW___0x1FFF
// 0x74___(mc_vmc_wl_num44_45_reg)___(mc_vmc_wl_num45)___13___13___RW___0x1FFF
// 0x74___(mc_vmc_wl_num44_45_reg)___(reserved)___26___6___NA___NA
// 0x78___(mc_vmc_wl_num46_47_reg)___(mc_vmc_wl_num46)___0___13___RW___0x1FFF
// 0x78___(mc_vmc_wl_num46_47_reg)___(mc_vmc_wl_num47)___13___13___RW___0x1FFF
// 0x78___(mc_vmc_wl_num46_47_reg)___(reserved)___26___6___NA___NA
// 0x7c___(mc_vmc_wl_num48_49_reg)___(mc_vmc_wl_num48)___0___13___RW___0x1FFF
// 0x7c___(mc_vmc_wl_num48_49_reg)___(mc_vmc_wl_num49)___13___13___RW___0x1FFF
// 0x7c___(mc_vmc_wl_num48_49_reg)___(reserved)___26___6___NA___NA
// 0x80___(mc_vmc_wl_num50_51_reg)___(mc_vmc_wl_num50)___0___13___RW___0x1FFF
// 0x80___(mc_vmc_wl_num50_51_reg)___(mc_vmc_wl_num51)___13___13___RW___0x1FFF
// 0x80___(mc_vmc_wl_num50_51_reg)___(reserved)___26___6___NA___NA
// 0x84___(mc_vmc_wl_num52_53_reg)___(mc_vmc_wl_num52)___0___13___RW___0x1FFF
// 0x84___(mc_vmc_wl_num52_53_reg)___(mc_vmc_wl_num53)___13___13___RW___0x1FFF
// 0x84___(mc_vmc_wl_num52_53_reg)___(reserved)___26___6___NA___NA
// 0x88___(mc_vmc_wl_num54_55_reg)___(mc_vmc_wl_num54)___0___13___RW___0x1FFF
// 0x88___(mc_vmc_wl_num54_55_reg)___(mc_vmc_wl_num55)___13___13___RW___0x1FFF
// 0x88___(mc_vmc_wl_num54_55_reg)___(reserved)___26___6___NA___NA
// 0x8c___(mc_vmc_wl_num56_57_reg)___(mc_vmc_wl_num56)___0___13___RW___0x1FFF
// 0x8c___(mc_vmc_wl_num56_57_reg)___(mc_vmc_wl_num57)___13___13___RW___0x1FFF
// 0x8c___(mc_vmc_wl_num56_57_reg)___(reserved)___26___6___NA___NA
// 0x90___(mc_vmc_wl_num58_59_reg)___(mc_vmc_wl_num58)___0___13___RW___0x1FFF
// 0x90___(mc_vmc_wl_num58_59_reg)___(mc_vmc_wl_num59)___13___13___RW___0x1FFF
// 0x90___(mc_vmc_wl_num58_59_reg)___(reserved)___26___6___NA___NA
// 0x94___(mc_vmc_wl_num60_61_reg)___(mc_vmc_wl_num60)___0___13___RW___0x1FFF
// 0x94___(mc_vmc_wl_num60_61_reg)___(mc_vmc_wl_num61)___13___13___RW___0x1FFF
// 0x94___(mc_vmc_wl_num60_61_reg)___(reserved)___26___6___NA___NA
// 0x98___(mc_vmc_wl_num62_63_reg)___(mc_vmc_wl_num62)___0___13___RW___0x1FFF
// 0x98___(mc_vmc_wl_num62_63_reg)___(mc_vmc_wl_num63)___13___13___RW___0x1FFF
// 0x98___(mc_vmc_wl_num62_63_reg)___(reserved)___26___6___NA___NA
// 0x9c___(mc_vmc_bl_num0_part0_1_reg)___(mc_vmc_bl_num0_part0)___0___8___RW___0xFF
// 0x9c___(mc_vmc_bl_num0_part0_1_reg)___(mc_vmc_bl_num1_part0)___8___8___RW___0xFF
// 0x9c___(mc_vmc_bl_num0_part0_1_reg)___(mc_vmc_bl_num0_part1)___16___8___RW___0xFF
// 0x9c___(mc_vmc_bl_num0_part0_1_reg)___(mc_vmc_bl_num1_part1)___24___8___RW___0xFF
// 0xa0___(mc_vmc_bl_num0_part2_3_reg)___(mc_vmc_bl_num0_part2)___0___8___RW___0xFF
// 0xa0___(mc_vmc_bl_num0_part2_3_reg)___(mc_vmc_bl_num1_part2)___8___8___RW___0xFF
// 0xa0___(mc_vmc_bl_num0_part2_3_reg)___(mc_vmc_bl_num0_part3)___16___8___RW___0xFF
// 0xa0___(mc_vmc_bl_num0_part2_3_reg)___(mc_vmc_bl_num1_part3)___24___8___RW___0xFF
// 0xa4___(mc_vmc_bl_num0_part4_5_reg)___(mc_vmc_bl_num0_part4)___0___8___RW___0xFF
// 0xa4___(mc_vmc_bl_num0_part4_5_reg)___(mc_vmc_bl_num1_part4)___8___8___RW___0xFF
// 0xa4___(mc_vmc_bl_num0_part4_5_reg)___(mc_vmc_bl_num0_part5)___16___8___RW___0xFF
// 0xa4___(mc_vmc_bl_num0_part4_5_reg)___(mc_vmc_bl_num1_part5)___24___8___RW___0xFF
// 0xa8___(mc_vmc_bl_num0_part6_7_reg)___(mc_vmc_bl_num0_part6)___0___8___RW___0xFF
// 0xa8___(mc_vmc_bl_num0_part6_7_reg)___(mc_vmc_bl_num1_part6)___8___8___RW___0xFF
// 0xa8___(mc_vmc_bl_num0_part6_7_reg)___(mc_vmc_bl_num0_part7)___16___8___RW___0xFF
// 0xa8___(mc_vmc_bl_num0_part6_7_reg)___(mc_vmc_bl_num1_part7)___24___8___RW___0xFF
// 0xac___(mc_vmc_bl_num0_part8_9_reg)___(mc_vmc_bl_num0_part8)___0___8___RW___0xFF
// 0xac___(mc_vmc_bl_num0_part8_9_reg)___(mc_vmc_bl_num1_part8)___8___8___RW___0xFF
// 0xac___(mc_vmc_bl_num0_part8_9_reg)___(mc_vmc_bl_num0_part9)___16___8___RW___0xFF
// 0xac___(mc_vmc_bl_num0_part8_9_reg)___(mc_vmc_bl_num1_part9)___24___8___RW___0xFF
// 0xb0___(err_wl0_1_reg)___(err_wl0)___0___13___RO___0x1FFF
// 0xb0___(err_wl0_1_reg)___(err_wl1)___13___13___RO___0x1FFF
// 0xb0___(err_wl0_1_reg)___(reserved)___26___6___NA___NA
// 0xb4___(err_wl2_3_reg)___(err_wl2)___0___13___RO___0x1FFF
// 0xb4___(err_wl2_3_reg)___(err_wl3)___13___13___RO___0x1FFF
// 0xb4___(err_wl2_3_reg)___(reserved)___26___6___NA___NA
// 0xb8___(err_wl4_5_reg)___(err_wl4)___0___13___RO___0x1FFF
// 0xb8___(err_wl4_5_reg)___(err_wl5)___13___13___RO___0x1FFF
// 0xb8___(err_wl4_5_reg)___(reserved)___26___6___NA___NA
// 0xbc___(err_wl6_7_reg)___(err_wl6)___0___13___RO___0x1FFF
// 0xbc___(err_wl6_7_reg)___(err_wl7)___13___13___RO___0x1FFF
// 0xbc___(err_wl6_7_reg)___(reserved)___26___6___NA___NA
// 0xc0___(err_wl8_9_reg)___(err_wl8)___0___13___RO___0x1FFF
// 0xc0___(err_wl8_9_reg)___(err_wl9)___13___13___RO___0x1FFF
// 0xc0___(err_wl8_9_reg)___(reserved)___26___6___NA___NA
// 0xc4___(err_wl10_11_reg)___(err_wl10)___0___13___RO___0x1FFF
// 0xc4___(err_wl10_11_reg)___(err_wl11)___13___13___RO___0x1FFF
// 0xc4___(err_wl10_11_reg)___(reserved)___26___6___NA___NA
// 0xc8___(err_wl12_13_reg)___(err_wl12)___0___13___RO___0x1FFF
// 0xc8___(err_wl12_13_reg)___(err_wl13)___13___13___RO___0x1FFF
// 0xc8___(err_wl12_13_reg)___(reserved)___26___6___NA___NA
// 0xcc___(err_wl14_15_reg)___(err_wl14)___0___13___RO___0x1FFF
// 0xcc___(err_wl14_15_reg)___(err_wl15)___13___13___RO___0x1FFF
// 0xcc___(err_wl14_15_reg)___(reserved)___26___6___NA___NA
// 0xd0___(err_wl16_17_reg)___(err_wl16)___0___13___RO___0x1FFF
// 0xd0___(err_wl16_17_reg)___(err_wl17)___13___13___RO___0x1FFF
// 0xd0___(err_wl16_17_reg)___(reserved)___26___6___NA___NA
// 0xd4___(err_wl18_19_reg)___(err_wl18)___0___13___RO___0x1FFF
// 0xd4___(err_wl18_19_reg)___(err_wl19)___13___13___RO___0x1FFF
// 0xd4___(err_wl18_19_reg)___(reserved)___26___6___NA___NA
// 0xd8___(err_wl20_21_reg)___(err_wl20)___0___13___RO___0x1FFF
// 0xd8___(err_wl20_21_reg)___(err_wl21)___13___13___RO___0x1FFF
// 0xd8___(err_wl20_21_reg)___(reserved)___26___6___NA___NA
// 0xdc___(err_wl22_23_reg)___(err_wl22)___0___13___RO___0x1FFF
// 0xdc___(err_wl22_23_reg)___(err_wl23)___13___13___RO___0x1FFF
// 0xdc___(err_wl22_23_reg)___(reserved)___26___6___NA___NA
// 0xe0___(err_wl24_25_reg)___(err_wl24)___0___13___RO___0x1FFF
// 0xe0___(err_wl24_25_reg)___(err_wl25)___13___13___RO___0x1FFF
// 0xe0___(err_wl24_25_reg)___(reserved)___26___6___NA___NA
// 0xe4___(err_wl26_27_reg)___(err_wl26)___0___13___RO___0x1FFF
// 0xe4___(err_wl26_27_reg)___(err_wl27)___13___13___RO___0x1FFF
// 0xe4___(err_wl26_27_reg)___(reserved)___26___6___NA___NA
// 0xe8___(err_wl28_29_reg)___(err_wl28)___0___13___RO___0x1FFF
// 0xe8___(err_wl28_29_reg)___(err_wl29)___13___13___RO___0x1FFF
// 0xe8___(err_wl28_29_reg)___(reserved)___26___6___NA___NA
// 0xec___(err_wl30_31_reg)___(err_wl30)___0___13___RO___0x1FFF
// 0xec___(err_wl30_31_reg)___(err_wl31)___13___13___RO___0x1FFF
// 0xec___(err_wl30_31_reg)___(reserved)___26___6___NA___NA
// 0xf0___(err_wl32_33_reg)___(err_wl32)___0___13___RO___0x1FFF
// 0xf0___(err_wl32_33_reg)___(err_wl33)___13___13___RO___0x1FFF
// 0xf0___(err_wl32_33_reg)___(reserved)___26___6___NA___NA
// 0xf4___(err_wl34_35_reg)___(err_wl34)___0___13___RO___0x1FFF
// 0xf4___(err_wl34_35_reg)___(err_wl35)___13___13___RO___0x1FFF
// 0xf4___(err_wl34_35_reg)___(reserved)___26___6___NA___NA
// 0xf8___(err_wl36_37_reg)___(err_wl36)___0___13___RO___0x1FFF
// 0xf8___(err_wl36_37_reg)___(err_wl37)___13___13___RO___0x1FFF
// 0xf8___(err_wl36_37_reg)___(reserved)___26___6___NA___NA
// 0xfc___(err_wl38_39_reg)___(err_wl38)___0___13___RO___0x1FFF
// 0xfc___(err_wl38_39_reg)___(err_wl39)___13___13___RO___0x1FFF
// 0xfc___(err_wl38_39_reg)___(reserved)___26___6___NA___NA
// 0x100___(err_wl40_41_reg)___(err_wl40)___0___13___RO___0x1FFF
// 0x100___(err_wl40_41_reg)___(err_wl41)___13___13___RO___0x1FFF
// 0x100___(err_wl40_41_reg)___(reserved)___26___6___NA___NA
// 0x104___(err_wl42_43_reg)___(err_wl42)___0___13___RO___0x1FFF
// 0x104___(err_wl42_43_reg)___(err_wl43)___13___13___RO___0x1FFF
// 0x104___(err_wl42_43_reg)___(reserved)___26___6___NA___NA
// 0x108___(err_wl44_45_reg)___(err_wl44)___0___13___RO___0x1FFF
// 0x108___(err_wl44_45_reg)___(err_wl45)___13___13___RO___0x1FFF
// 0x108___(err_wl44_45_reg)___(reserved)___26___6___NA___NA
// 0x10c___(err_wl46_47_reg)___(err_wl46)___0___13___RO___0x1FFF
// 0x10c___(err_wl46_47_reg)___(err_wl47)___13___13___RO___0x1FFF
// 0x10c___(err_wl46_47_reg)___(reserved)___26___6___NA___NA
// 0x110___(err_wl48_49_reg)___(err_wl48)___0___13___RO___0x1FFF
// 0x110___(err_wl48_49_reg)___(err_wl49)___13___13___RO___0x1FFF
// 0x110___(err_wl48_49_reg)___(reserved)___26___6___NA___NA
// 0x114___(err_wl50_51_reg)___(err_wl50)___0___13___RO___0x1FFF
// 0x114___(err_wl50_51_reg)___(err_wl51)___13___13___RO___0x1FFF
// 0x114___(err_wl50_51_reg)___(reserved)___26___6___NA___NA
// 0x118___(err_wl52_53_reg)___(err_wl52)___0___13___RO___0x1FFF
// 0x118___(err_wl52_53_reg)___(err_wl53)___13___13___RO___0x1FFF
// 0x118___(err_wl52_53_reg)___(reserved)___26___6___NA___NA
// 0x11c___(err_wl54_55_reg)___(err_wl54)___0___13___RO___0x1FFF
// 0x11c___(err_wl54_55_reg)___(err_wl55)___13___13___RO___0x1FFF
// 0x11c___(err_wl54_55_reg)___(reserved)___26___6___NA___NA
// 0x120___(err_wl56_57_reg)___(err_wl56)___0___13___RO___0x1FFF
// 0x120___(err_wl56_57_reg)___(err_wl57)___13___13___RO___0x1FFF
// 0x120___(err_wl56_57_reg)___(reserved)___26___6___NA___NA
// 0x124___(err_wl58_59_reg)___(err_wl58)___0___13___RO___0x1FFF
// 0x124___(err_wl58_59_reg)___(err_wl59)___13___13___RO___0x1FFF
// 0x124___(err_wl58_59_reg)___(reserved)___26___6___NA___NA
// 0x128___(err_wl60_61_reg)___(err_wl60)___0___13___RO___0x1FFF
// 0x128___(err_wl60_61_reg)___(err_wl61)___13___13___RO___0x1FFF
// 0x128___(err_wl60_61_reg)___(reserved)___26___6___NA___NA
// 0x12c___(err_wl62_63_reg)___(err_wl62)___0___13___RO___0x1FFF
// 0x12c___(err_wl62_63_reg)___(err_wl63)___13___13___RO___0x1FFF
// 0x12c___(err_wl62_63_reg)___(reserved)___26___6___NA___NA
// 0x130___(err_csl_part0_1_reg)___(err_csl0_part0)___0___8___RO___0xFF
// 0x130___(err_csl_part0_1_reg)___(err_csl1_part0)___8___8___RO___0xFF
// 0x130___(err_csl_part0_1_reg)___(err_csl0_part1)___16___8___RO___0xFF
// 0x130___(err_csl_part0_1_reg)___(err_csl1_part1)___24___8___RO___0xFF
// 0x134___(err_csl_part2_3_reg)___(err_csl0_part2)___0___8___RO___0xFF
// 0x134___(err_csl_part2_3_reg)___(err_csl1_part2)___8___8___RO___0xFF
// 0x134___(err_csl_part2_3_reg)___(err_csl0_part3)___16___8___RO___0xFF
// 0x134___(err_csl_part2_3_reg)___(err_csl1_part3)___24___8___RO___0xFF
// 0x138___(err_csl_part4_5_reg)___(err_csl0_part4)___0___8___RO___0xFF
// 0x138___(err_csl_part4_5_reg)___(err_csl1_part4)___8___8___RO___0xFF
// 0x138___(err_csl_part4_5_reg)___(err_csl0_part5)___16___8___RO___0xFF
// 0x138___(err_csl_part4_5_reg)___(err_csl1_part5)___24___8___RO___0xFF
// 0x13c___(err_csl_part6_7_reg)___(err_csl0_part6)___0___8___RO___0xFF
// 0x13c___(err_csl_part6_7_reg)___(err_csl1_part6)___8___8___RO___0xFF
// 0x13c___(err_csl_part6_7_reg)___(err_csl0_part7)___16___8___RO___0xFF
// 0x13c___(err_csl_part6_7_reg)___(err_csl1_part7)___24___8___RO___0xFF
// 0x140___(err_csl_part8_9_reg)___(err_csl0_part8)___0___8___RO___0xFF
// 0x140___(err_csl_part8_9_reg)___(err_csl1_part8)___8___8___RO___0xFF
// 0x140___(err_csl_part8_9_reg)___(err_csl0_part9)___16___8___RO___0xFF
// 0x140___(err_csl_part8_9_reg)___(err_csl1_part9)___24___8___RO___0xFF
// 0x144___(mc_timeout_clr_reg)___(mc_timeout_clr)___0___1___W1C___0x0
// 0x144___(mc_timeout_clr_reg)___(reserved)___1___31___NA___NA
// 0x148___(mc_rf_start_dbg_reg)___(mc_rf_start_dbg)___0___1___RO___0x0
// 0x148___(mc_rf_start_dbg_reg)___(reserved)___1___31___NA___NA
// 0x14c___(mc_timeout_flag_reg)___(mc_timeout_flag)___0___1___RO___0x0
// 0x14c___(mc_timeout_flag_reg)___(reserved)___1___31___NA___NA
// 0x150___(mc_bist_status_reg)___(mc_bist_status)___0___3___RO___0x0
// 0x150___(mc_bist_status_reg)___(mc_bist_path_fail)___3___1___RO___0x0
// 0x150___(mc_bist_status_reg)___(dram_init_finish)___4___1___RO___0x0
// 0x150___(mc_bist_status_reg)___(reserved)___5___27___NA___NA
// 0x154___(bist_finish_reg)___(bist_finish)___0___1___RO___0x0
// 0x154___(bist_finish_reg)___(bist_rescan_finish)___1___1___RO___0x0
// 0x154___(bist_finish_reg)___(reserved)___2___30___NA___NA
// 0x158___(bank_success_reg)___(bank_success)___0___1___RO___0x0
// 0x158___(bank_success_reg)___(bist_rescan_success)___1___1___RO___0x0
// 0x158___(bank_success_reg)___(reserved)___2___30___NA___NA
// 0x15c___(mc_bist_rescan_fail_num_reg)___(mc_bist_rescan_fail_num)___0___20___RO___0x0
// 0x15c___(mc_bist_rescan_fail_num_reg)___(reserved)___20___12___NA___NA
// 0x160___(mc_bist_err_wl_reg)___(mc_bist_err_wl_num)___0___7___RO___0x0
// 0x160___(mc_bist_err_wl_reg)___(err_wl_num_change_flag)___7___1___RO___0x0
// 0x160___(mc_bist_err_wl_reg)___(reserved)___8___24___NA___NA
// 0x164___(rescan_finish_clr_reg)___(rescan_finish_clr)___0___1___W1C___0x0
// 0x164___(rescan_finish_clr_reg)___(reserved)___1___31___NA___NA
// 0x168___(rescan_finish_mask_reg)___(rescan_finish_mask)___0___1___RW___0x1
// 0x168___(rescan_finish_mask_reg)___(reserved)___1___31___NA___NA
// 0x16c___(rescan_round_result_reg)___(rescan_round_result)___0___15___RO___0x0
// 0x16c___(rescan_round_result_reg)___(reserved)___15___17___NA___NA
// 0x170___(bist_finish_clr_reg)___(bist_finish_clr)___0___1___W1C___0x0
// 0x170___(bist_finish_clr_reg)___(reserved)___1___31___NA___NA
// 0x174___(bist_finish_mask_reg)___(bist_finish_mask)___0___1___RW___0x1
// 0x174___(bist_finish_mask_reg)___(reserved)___1___31___NA___NA
// 0x178___(hang_timeout_th_reg)___(hang_timeout_th)___0___32___RW___0x186a00
// 0x17c___(bist_pattern_reg0_reg)___(bist_pattern_reg0)___0___32___RW___0x0
// 0x180___(bist_pattern_reg1_reg)___(bist_pattern_reg1)___0___32___RW___0x0
// 0x184___(bist_pattern_reg2_reg)___(bist_pattern_reg2)___0___32___RW___0x0
// 0x188___(bist_pattern_reg3_reg)___(bist_pattern_reg3)___0___32___RW___0x0
// 0x18c___(csl_bist_pattern_sel0_reg)___(csl_bist_pattern_sel0)___0___32___RW___0xFFFFFFFF
// 0x190___(csl_bist_pattern_sel1_reg)___(csl_bist_pattern_sel1)___0___32___RW___0xFFFFFFFF
// 0x194___(csl_bist_pattern_sel2_reg)___(csl_bist_pattern_sel2)___0___4___RW___0x0
// 0x194___(csl_bist_pattern_sel2_reg)___(reserved)___4___28___NA___NA
// 0x198___(wl_bist_pattern_sel0_reg)___(wl_bist_pattern_sel0)___0___32___RW___0xFFFFFFFF
// 0x19c___(wl_bist_pattern_sel1_reg)___(wl_bist_pattern_sel1)___0___32___RW___0xFFFFFFFF
// 0x1a0___(wl_bist_pattern_sel2_reg)___(wl_bist_pattern_sel2)___0___4___RW___0x0
// 0x1a0___(wl_bist_pattern_sel2_reg)___(reserved)___4___28___NA___NA
// 0x1a4___(mc_frame2array_dbg_reg)___(dbg_next_state_array)___0___5___RO___0x0
// 0x1a4___(mc_frame2array_dbg_reg)___(reserved)___5___3___NA___NA
// 0x1a4___(mc_frame2array_dbg_reg)___(dbg_current_state_array)___8___5___RO___0x0
// 0x1a4___(mc_frame2array_dbg_reg)___(reserved)___13___3___NA___NA
// 0x1a4___(mc_frame2array_dbg_reg)___(dbg_r_data_cnt)___16___2___RO___0x0
// 0x1a4___(mc_frame2array_dbg_reg)___(reserved)___18___2___NA___NA
// 0x1a4___(mc_frame2array_dbg_reg)___(dbg_refresh_flag)___20___1___RO___0x0
// 0x1a4___(mc_frame2array_dbg_reg)___(reserved)___21___3___NA___NA
// 0x1a4___(mc_frame2array_dbg_reg)___(dbg_r_frame_cnt)___24___2___RO___0x0
// 0x1a4___(mc_frame2array_dbg_reg)___(reserved)___26___2___NA___NA
// 0x1a4___(mc_frame2array_dbg_reg)___(dbg_w_frame_cnt)___28___2___RO___0x0
// 0x1a4___(mc_frame2array_dbg_reg)___(reserved)___30___2___NA___NA
// 0x1a8___(dbg_frame_store_0_reg)___(dbg_frame_store_0)___0___32___RO___0x0
// 0x1ac___(dbg_frame_store_1_reg)___(dbg_frame_store_1)___0___32___RO___0x0
// 0x1b0___(dbg_frame_store_2_reg)___(dbg_frame_store_2)___0___32___RO___0x0
// 0x1b4___(dbg_frame_store_3_reg)___(dbg_frame_store_3)___0___32___RO___0x0
// 0x1b8___(dbg_frame_store_4_reg)___(dbg_frame_store_4)___0___32___RO___0x0
// 0x1bc___(dbg_frame_store_5_reg)___(dbg_frame_store_5)___0___32___RO___0x0
// 0x1c0___(dbg_frame_store_6_reg)___(dbg_frame_store_6)___0___32___RO___0x0
// 0x1c4___(dbg_frame_store_7_reg)___(dbg_frame_store_7)___0___32___RO___0x0
// 0x1c8___(dbg_frame_store_8_reg)___(dbg_frame_store_8)___0___32___RO___0x0
// 0x1cc___(dbg_frame_store_9_reg)___(dbg_frame_store_9)___0___2___RO___0x0
// 0x1cc___(dbg_frame_store_9_reg)___(reserved)___2___30___NA___NA
// 0x1d0___(dbg_rdata_store_0_reg)___(dbg_rdata_store_0)___0___32___RO___0x0
// 0x1d4___(dbg_rdata_store_1_reg)___(dbg_rdata_store_1)___0___32___RO___0x0
// 0x1d8___(dbg_rdata_store_2_reg)___(dbg_rdata_store_2)___0___32___RO___0x0
// 0x1dc___(dbg_rdata_store_3_reg)___(dbg_rdata_store_3)___0___32___RO___0x0
// 0x1e0___(dbg_rdata_store_4_reg)___(dbg_rdata_store_4)___0___32___RO___0x0
// 0x1e4___(dbg_rdata_store_5_reg)___(dbg_rdata_store_5)___0___32___RO___0x0
// 0x1e8___(dbg_rdata_store_6_reg)___(dbg_rdata_store_6)___0___32___RO___0x0
// 0x1ec___(dbg_rdata_store_7_reg)___(dbg_rdata_store_7)___0___32___RO___0x0
// 0x1f0___(dbg_rdata_store_8_reg)___(dbg_rdata_store_8)___0___10___RO___0x0
// 0x1f0___(dbg_rdata_store_8_reg)___(reserved)___10___22___NA___NA
// 0x1f4___(mc_page_status_reg)___(mc_page_status)___0___1___RO___0x1
// 0x1f4___(mc_page_status_reg)___(reserved)___1___31___NA___reserved
// 0x1f8___(hang_timeout_status_reg)___(hang_timeout_status)___0___1___RO___0x0
// 0x1f8___(hang_timeout_status_reg)___(reserved)___1___31___NA___NA
// 0x1fc___(hang_timeout_mask_reg)___(hang_timeout_mask)___0___1___RW___0x1
// 0x1fc___(hang_timeout_mask_reg)___(reserved)___1___31___NA___NA
// 0x200___(hang_timeout_clr_reg)___(hang_timeout_clr)___0___1___W1C___0x0
// 0x200___(hang_timeout_clr_reg)___(reserved)___1___31___NA___NA
// 0x204___(hang_timeout_en_reg)___(hang_timeout_en)___0___1___RW___0x1
// 0x204___(hang_timeout_en_reg)___(reserved)___1___31___NA___NA
// 0x208___(mc_ecc_ce_ctrl)___(mc_ecc_ce_int_clr)___0___1___W1C___0x0
// 0x208___(mc_ecc_ce_ctrl)___(reserved)___1___3___NA___NA
// 0x208___(mc_ecc_ce_ctrl)___(mc_ecc_ce_overflow_int)___4___1___RO___0x0
// 0x208___(mc_ecc_ce_ctrl)___(reserved)___5___3___NA___NA
// 0x208___(mc_ecc_ce_ctrl)___(mc_ecc_ce_th)___8___5___RW___0x5
// 0x208___(mc_ecc_ce_ctrl)___(reserved)___13___3___NA___NA
// 0x208___(mc_ecc_ce_ctrl)___(mc_ecc_ce_cnt)___16___5___RO___0x0
// 0x208___(mc_ecc_ce_ctrl)___(reserved)___21___3___NA___NA
// 0x208___(mc_ecc_ce_ctrl)___(mc_ecc_ce_int_mask)___24___1___RW___0x0
// 0x208___(mc_ecc_ce_ctrl)___(reserved)___25___7___NA___NA
// 0x20c___(mc_ecc_ce_addr0)___(mc_ecc_ce_addr0)___0___22___RO___0x0
// 0x20c___(mc_ecc_ce_addr0)___(mc_ecc_ce_addr_vld0)___22___1___RO___0x0
// 0x20c___(mc_ecc_ce_addr0)___(reserved)___23___9___NA___NA
// 0x210___(mc_ecc_ce_addr1)___(mc_ecc_ce_addr1)___0___22___RO___0x0
// 0x210___(mc_ecc_ce_addr1)___(mc_ecc_ce_addr_vld1)___22___1___RO___0x0
// 0x210___(mc_ecc_ce_addr1)___(reserved)___23___9___NA___NA
// 0x214___(mc_ecc_ce_addr2)___(mc_ecc_ce_addr2)___0___22___RO___0x0
// 0x214___(mc_ecc_ce_addr2)___(mc_ecc_ce_addr_vld2)___22___1___RO___0x0
// 0x214___(mc_ecc_ce_addr2)___(reserved)___23___9___NA___NA
// 0x218___(mc_ecc_ce_addr3)___(mc_ecc_ce_addr3)___0___22___RO___0x0
// 0x218___(mc_ecc_ce_addr3)___(mc_ecc_ce_addr_vld3)___22___1___RO___0x0
// 0x218___(mc_ecc_ce_addr3)___(reserved)___23___9___NA___NA
// 0x21c___(mc_ecc_ce_addr4)___(mc_ecc_ce_addr4)___0___22___RO___0x0
// 0x21c___(mc_ecc_ce_addr4)___(mc_ecc_ce_addr_vld4)___22___1___RO___0x0
// 0x21c___(mc_ecc_ce_addr4)___(reserved)___23___9___NA___NA
// 0x220___(mc_ecc_ce_addr5)___(mc_ecc_ce_addr5)___0___22___RO___0x0
// 0x220___(mc_ecc_ce_addr5)___(mc_ecc_ce_addr_vld5)___22___1___RO___0x0
// 0x220___(mc_ecc_ce_addr5)___(reserved)___23___9___NA___NA
// 0x224___(mc_ecc_ce_addr6)___(mc_ecc_ce_addr6)___0___22___RO___0x0
// 0x224___(mc_ecc_ce_addr6)___(mc_ecc_ce_addr_vld6)___22___1___RO___0x0
// 0x224___(mc_ecc_ce_addr6)___(reserved)___23___9___NA___NA
// 0x228___(mc_ecc_ce_addr7)___(mc_ecc_ce_addr7)___0___22___RO___0x0
// 0x228___(mc_ecc_ce_addr7)___(mc_ecc_ce_addr_vld7)___22___1___RO___0x0
// 0x228___(mc_ecc_ce_addr7)___(reserved)___23___9___NA___NA
// 0x22c___(mc_ecc_ce_addr8)___(mc_ecc_ce_addr8)___0___22___RO___0x0
// 0x22c___(mc_ecc_ce_addr8)___(mc_ecc_ce_addr_vld8)___22___1___RO___0x0
// 0x22c___(mc_ecc_ce_addr8)___(reserved)___23___9___NA___NA
// 0x230___(mc_ecc_ce_addr9)___(mc_ecc_ce_addr9)___0___22___RO___0x0
// 0x230___(mc_ecc_ce_addr9)___(mc_ecc_ce_addr_vld9)___22___1___RO___0x0
// 0x230___(mc_ecc_ce_addr9)___(reserved)___23___9___NA___NA
// 0x234___(mc_ecc_ce_addr10)___(mc_ecc_ce_addr10)___0___22___RO___0x0
// 0x234___(mc_ecc_ce_addr10)___(mc_ecc_ce_addr_vld10)___22___1___RO___0x0
// 0x234___(mc_ecc_ce_addr10)___(reserved)___23___9___NA___NA
// 0x238___(mc_ecc_ce_addr11)___(mc_ecc_ce_addr11)___0___22___RO___0x0
// 0x238___(mc_ecc_ce_addr11)___(mc_ecc_ce_addr_vld11)___22___1___RO___0x0
// 0x238___(mc_ecc_ce_addr11)___(reserved)___23___9___NA___NA
// 0x23c___(mc_ecc_ce_addr12)___(mc_ecc_ce_addr12)___0___22___RO___0x0
// 0x23c___(mc_ecc_ce_addr12)___(mc_ecc_ce_addr_vld12)___22___1___RO___0x0
// 0x23c___(mc_ecc_ce_addr12)___(reserved)___23___9___NA___NA
// 0x240___(mc_ecc_ce_addr13)___(mc_ecc_ce_addr13)___0___22___RO___0x0
// 0x240___(mc_ecc_ce_addr13)___(mc_ecc_ce_addr_vld13)___22___1___RO___0x0
// 0x240___(mc_ecc_ce_addr13)___(reserved)___23___9___NA___NA
// 0x244___(mc_ecc_ce_addr14)___(mc_ecc_ce_addr14)___0___22___RO___0x0
// 0x244___(mc_ecc_ce_addr14)___(mc_ecc_ce_addr_vld14)___22___1___RO___0x0
// 0x244___(mc_ecc_ce_addr14)___(reserved)___23___9___NA___NA
// 0x248___(mc_ecc_ce_addr15)___(mc_ecc_ce_addr15)___0___22___RO___0x0
// 0x248___(mc_ecc_ce_addr15)___(mc_ecc_ce_addr_vld15)___22___1___RO___0x0
// 0x248___(mc_ecc_ce_addr15)___(reserved)___23___9___NA___NA
// 0x24c___(mc_ecc_uce_ctrl)___(mc_ecc_uce_int_clr)___0___1___W1C___0x0
// 0x24c___(mc_ecc_uce_ctrl)___(reserved)___1___3___NA___NA
// 0x24c___(mc_ecc_uce_ctrl)___(mc_ecc_uce_int)___4___1___RO___0x0
// 0x24c___(mc_ecc_uce_ctrl)___(reserved)___5___3___NA___NA
// 0x24c___(mc_ecc_uce_ctrl)___(mc_ecc_uce_cnt)___8___3___RO___0x0
// 0x24c___(mc_ecc_uce_ctrl)___(reserved)___11___1___NA___NA
// 0x24c___(mc_ecc_uce_ctrl)___(mc_ecc_uce_int_mask)___12___1___RW___0x0
// 0x24c___(mc_ecc_uce_ctrl)___(reserved)___13___19___NA___NA
// 0x250___(mc_ecc_uce_addr0)___(mc_ecc_uce_addr0)___0___22___RO___0x0
// 0x250___(mc_ecc_uce_addr0)___(mc_ecc_uce_addr_vld0)___22___1___RO___0x0
// 0x250___(mc_ecc_uce_addr0)___(reserved)___23___9___NA___NA
// 0x254___(mc_ecc_uce_addr1)___(mc_ecc_uce_addr1)___0___22___RO___0x0
// 0x254___(mc_ecc_uce_addr1)___(mc_ecc_uce_addr_vld1)___22___1___RO___0x0
// 0x254___(mc_ecc_uce_addr1)___(reserved)___23___9___NA___NA
// 0x258___(mc_ecc_uce_addr2)___(mc_ecc_uce_addr2)___0___22___RO___0x0
// 0x258___(mc_ecc_uce_addr2)___(mc_ecc_uce_addr_vld2)___22___1___RO___0x0
// 0x258___(mc_ecc_uce_addr2)___(reserved)___23___9___NA___NA
// 0x25c___(mc_ecc_uce_addr3)___(mc_ecc_uce_addr3)___0___22___RO___0x0
// 0x25c___(mc_ecc_uce_addr3)___(mc_ecc_uce_addr_vld3)___22___1___RO___0x0
// 0x25c___(mc_ecc_uce_addr3)___(reserved)___23___9___NA___NA
