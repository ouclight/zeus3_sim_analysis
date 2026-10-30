/*
*********************************-Verilog-****************************************
-- All rights reserved.
-- Copyright (c) 2018 -        Xi'an UniIC
**********************************************************************************
-- Project         :   
-- Filename        :   apb2reg_mc_wrapper_cfg_if.v
-- Language        :   Verilog
-- Author          :   wuyong
-- Create Date     :   2025-05-09
**********************************************************************************
-- Abstract        :   Register block of mc_wrapper 
-- Description     :
--                     Act as a slave of apb, have register Read/Write function.
--                     Generated from register excel sheet by script.
**********************************************************************************
-- History:
-- Date (y-m-d)       Versions          Author            Description
-- 2025-05-09          1.0              wuyong             initial version
--
**********************************************************************************
*/

//=================================================================================
// Include File Here

module apb2reg_mc_wrapper_cfg_if #(
    parameter APB_ADDR_WIDTH = 12,
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
    // register name : mc_frame2array_dbg_reg , address:0xb0
    input  [4:0]                        dbg_next_state_array_i,// read only signal
    input  [4:0]                        dbg_current_state_array_i,// read only signal
    input  [1:0]                        dbg_r_data_cnt_i,// read only signal
    input                        dbg_refresh_flag_i,// read only signal
    input  [1:0]                        dbg_r_frame_cnt_i,// read only signal
    input  [1:0]                        dbg_w_frame_cnt_i,// read only signal
    // register name : mc_rf_start_dbg_reg , address:0xb8
    input                        mc_rf_start_dbg_i,// read only signal
    // register name : mc_timeout_flag_reg , address:0xbc
    input                        mc_timeout_flag_i,// read only signal
    // register name : mc_bist_status_reg , address:0xc0
    input  [2:0]                        mc_bist_status_i,// read only signal
    input                        mc_bist_path_fail_i,// read only signal
    input                        dram_init_finish_i,// read only signal
    // register name : bist_finish_reg , address:0xc4
    input                        bist_finish_i,// read only signal
    input                        bist_rescan_finish_i,// read only signal
    // register name : bank_success_reg , address:0xc8
    input                        bank_success_i,// read only signal
    input                        bist_rescan_success_i,// read only signal
    // register name : err_csl0_reg , address:0xcc
    input  [7:0]                        err_csl0_part0_i,// read only signal
    input  [7:0]                        err_csl1_part0_i,// read only signal
    input  [7:0]                        err_csl0_part1_i,// read only signal
    input  [7:0]                        err_csl1_part1_i,// read only signal
    // register name : err_csl1_reg , address:0xd0
    input  [7:0]                        err_csl0_part2_i,// read only signal
    input  [7:0]                        err_csl1_part2_i,// read only signal
    input  [7:0]                        err_csl0_part3_i,// read only signal
    input  [7:0]                        err_csl1_part3_i,// read only signal
    // register name : err_csl2_reg , address:0xd4
    input  [7:0]                        err_csl0_part4_i,// read only signal
    input  [7:0]                        err_csl1_part4_i,// read only signal
    input  [7:0]                        err_csl0_part5_i,// read only signal
    input  [7:0]                        err_csl1_part5_i,// read only signal
    // register name : err_csl3_reg , address:0xd8
    input  [7:0]                        err_csl0_part6_i,// read only signal
    input  [7:0]                        err_csl1_part6_i,// read only signal
    input  [7:0]                        err_csl0_part7_i,// read only signal
    input  [7:0]                        err_csl1_part7_i,// read only signal
    // register name : err_csl4_reg , address:0xdc
    input  [7:0]                        err_csl0_part8_i,// read only signal
    input  [7:0]                        err_csl1_part8_i,// read only signal
    input  [7:0]                        err_csl0_part9_i,// read only signal
    input  [7:0]                        err_csl1_part9_i,// read only signal
    // register name : err_wl0_reg , address:0xe0
    input  [12:0]                        err_wl0_i,// read only signal
    input  [12:0]                        err_wl1_i,// read only signal
    // register name : err_wl1_reg , address:0xe4
    input  [12:0]                        err_wl2_i,// read only signal
    input  [12:0]                        err_wl3_i,// read only signal
    // register name : err_wl2_reg , address:0xe8
    input  [12:0]                        err_wl4_i,// read only signal
    input  [12:0]                        err_wl5_i,// read only signal
    // register name : err_wl3_reg , address:0xec
    input  [12:0]                        err_wl6_i,// read only signal
    input  [12:0]                        err_wl7_i,// read only signal
    // register name : err_wl4_reg , address:0xf0
    input  [12:0]                        err_wl8_i,// read only signal
    input  [12:0]                        err_wl9_i,// read only signal
    // register name : err_wl5_reg , address:0xf4
    input  [12:0]                        err_wl10_i,// read only signal
    input  [12:0]                        err_wl11_i,// read only signal
    // register name : err_wl6_reg , address:0xf8
    input  [12:0]                        err_wl12_i,// read only signal
    input  [12:0]                        err_wl13_i,// read only signal
    // register name : err_wl7_reg , address:0xfc
    input  [12:0]                        err_wl14_i,// read only signal
    input  [12:0]                        err_wl15_i,// read only signal
    // register name : err_wl8_reg , address:0x100
    input  [12:0]                        err_wl16_i,// read only signal
    input  [12:0]                        err_wl17_i,// read only signal
    // register name : err_wl9_reg , address:0x104
    input  [12:0]                        err_wl18_i,// read only signal
    input  [12:0]                        err_wl19_i,// read only signal
    // register name : err_wl10_reg , address:0x108
    input  [12:0]                        err_wl20_i,// read only signal
    input  [12:0]                        err_wl21_i,// read only signal
    // register name : err_wl11_reg , address:0x10c
    input  [12:0]                        err_wl22_i,// read only signal
    input  [12:0]                        err_wl23_i,// read only signal
    // register name : err_wl12_reg , address:0x110
    input  [12:0]                        err_wl24_i,// read only signal
    input  [12:0]                        err_wl25_i,// read only signal
    // register name : err_wl13_reg , address:0x114
    input  [12:0]                        err_wl26_i,// read only signal
    input  [12:0]                        err_wl27_i,// read only signal
    // register name : err_wl14_reg , address:0x118
    input  [12:0]                        err_wl28_i,// read only signal
    input  [12:0]                        err_wl29_i,// read only signal
    // register name : err_wl15_reg , address:0x11c
    input  [12:0]                        err_wl30_i,// read only signal
    input  [12:0]                        err_wl31_i,// read only signal
    // register name : err_wl16_reg , address:0x120
    input  [12:0]                        err_wl32_i,// read only signal
    input  [12:0]                        err_wl33_i,// read only signal
    // register name : err_wl17_reg , address:0x124
    input  [12:0]                        err_wl34_i,// read only signal
    input  [12:0]                        err_wl35_i,// read only signal
    // register name : err_wl18_reg , address:0x128
    input  [12:0]                        err_wl36_i,// read only signal
    input  [12:0]                        err_wl37_i,// read only signal
    // register name : err_wl19_reg , address:0x12c
    input  [12:0]                        err_wl38_i,// read only signal
    input  [12:0]                        err_wl39_i,// read only signal
    // register name : err_wl20_reg , address:0x130
    input  [12:0]                        err_wl40_i,// read only signal
    input  [12:0]                        err_wl41_i,// read only signal
    // register name : err_wl21_reg , address:0x134
    input  [12:0]                        err_wl42_i,// read only signal
    input  [12:0]                        err_wl43_i,// read only signal
    // register name : err_wl22_reg , address:0x138
    input  [12:0]                        err_wl44_i,// read only signal
    input  [12:0]                        err_wl45_i,// read only signal
    // register name : err_wl23_reg , address:0x13c
    input  [12:0]                        err_wl46_i,// read only signal
    input  [12:0]                        err_wl47_i,// read only signal
    // register name : err_wl24_reg , address:0x140
    input  [12:0]                        err_wl48_i,// read only signal
    input  [12:0]                        err_wl49_i,// read only signal
    // register name : err_wl25_reg , address:0x144
    input  [12:0]                        err_wl50_i,// read only signal
    input  [12:0]                        err_wl51_i,// read only signal
    // register name : err_wl26_reg , address:0x148
    input  [12:0]                        err_wl52_i,// read only signal
    input  [12:0]                        err_wl53_i,// read only signal
    // register name : err_wl27_reg , address:0x14c
    input  [12:0]                        err_wl54_i,// read only signal
    input  [12:0]                        err_wl55_i,// read only signal
    // register name : err_wl28_reg , address:0x150
    input  [12:0]                        err_wl56_i,// read only signal
    input  [12:0]                        err_wl57_i,// read only signal
    // register name : err_wl29_reg , address:0x154
    input  [12:0]                        err_wl58_i,// read only signal
    input  [12:0]                        err_wl59_i,// read only signal
    // register name : err_wl30_reg , address:0x158
    input  [12:0]                        err_wl60_i,// read only signal
    input  [12:0]                        err_wl61_i,// read only signal
    // register name : err_wl31_reg , address:0x15c
    input  [12:0]                        err_wl62_i,// read only signal
    input  [12:0]                        err_wl63_i,// read only signal
    // register name : mc_bist_rescan_fail_num_reg , address:0x16c
    input  [19:0]                        mc_bist_rescan_fail_num_i,// read only signal
    // register name : mc_bist_err_wl_reg , address:0x170
    input  [6:0]                        mc_bist_err_wl_num_i,// read only signal
    input                        err_wl_num_change_flag_i,// read only signal
    // register name : rescan_round_result_reg , address:0x17c
    input  [14:0]                        rescan_round_result_i,// read only signal
    // register name : dbg_frame_store_0_reg , address:0x180
    input  [31:0]                        dbg_frame_store_0_i,// read only signal
    // register name : dbg_frame_store_1_reg , address:0x184
    input  [31:0]                        dbg_frame_store_1_i,// read only signal
    // register name : dbg_frame_store_2_reg , address:0x188
    input  [31:0]                        dbg_frame_store_2_i,// read only signal
    // register name : dbg_frame_store_3_reg , address:0x18c
    input  [31:0]                        dbg_frame_store_3_i,// read only signal
    // register name : dbg_frame_store_4_reg , address:0x190
    input  [31:0]                        dbg_frame_store_4_i,// read only signal
    // register name : dbg_frame_store_5_reg , address:0x194
    input  [31:0]                        dbg_frame_store_5_i,// read only signal
    // register name : dbg_frame_store_6_reg , address:0x198
    input  [31:0]                        dbg_frame_store_6_i,// read only signal
    // register name : dbg_frame_store_7_reg , address:0x19c
    input  [31:0]                        dbg_frame_store_7_i,// read only signal
    // register name : dbg_frame_store_8_reg , address:0x1a0
    input  [31:0]                        dbg_frame_store_8_i,// read only signal
    // register name : dbg_frame_store_9_reg , address:0x1a4
    input  [1:0]                        dbg_frame_store_9_i,// read only signal
    // register name : dbg_rdata_store_0_reg , address:0x1a8
    input  [31:0]                        dbg_rdata_store_0_i,// read only signal
    // register name : dbg_rdata_store_1_reg , address:0x1ac
    input  [31:0]                        dbg_rdata_store_1_i,// read only signal
    // register name : dbg_rdata_store_2_reg , address:0x1b0
    input  [31:0]                        dbg_rdata_store_2_i,// read only signal
    // register name : dbg_rdata_store_3_reg , address:0x1b4
    input  [31:0]                        dbg_rdata_store_3_i,// read only signal
    // register name : dbg_rdata_store_4_reg , address:0x1b8
    input  [31:0]                        dbg_rdata_store_4_i,// read only signal
    // register name : dbg_rdata_store_5_reg , address:0x1bc
    input  [31:0]                        dbg_rdata_store_5_i,// read only signal
    // register name : dbg_rdata_store_6_reg , address:0x1c0
    input  [31:0]                        dbg_rdata_store_6_i,// read only signal
    // register name : dbg_rdata_store_7_reg , address:0x1c4
    input  [31:0]                        dbg_rdata_store_7_i,// read only signal
    // register name : dbg_rdata_store_8_reg , address:0x1c8
    input  [9:0]                        dbg_rdata_store_8_i,// read only signal
    // register name : mc_ecc_int_status_reg , address:0x1f8
    input                        mc_ecc_ce_int_status_i,// read only signal
    input                        mc_ecc_uce_int_status_i,// read only signal
    input  [4:0]                        mc_ecc_ce_cnt_i,// read only signal
    // register name : mc_ecc_ce_addr0_reg , address:0x1fc
    input  [31:0]                        mc_ecc_ce_addr0_i,// read only signal
    // register name : mc_ecc_ce_addr1_reg , address:0x200
    input  [31:0]                        mc_ecc_ce_addr1_i,// read only signal
    // register name : mc_ecc_ce_addr2_reg , address:0x204
    input  [31:0]                        mc_ecc_ce_addr2_i,// read only signal
    // register name : mc_ecc_ce_addr3_reg , address:0x208
    input  [31:0]                        mc_ecc_ce_addr3_i,// read only signal
    // register name : mc_ecc_ce_addr4_reg , address:0x20c
    input  [31:0]                        mc_ecc_ce_addr4_i,// read only signal
    // register name : mc_ecc_ce_addr5_reg , address:0x210
    input  [31:0]                        mc_ecc_ce_addr5_i,// read only signal
    // register name : mc_ecc_ce_addr6_reg , address:0x214
    input  [31:0]                        mc_ecc_ce_addr6_i,// read only signal
    // register name : mc_ecc_ce_addr7_reg , address:0x218
    input  [31:0]                        mc_ecc_ce_addr7_i,// read only signal
    // register name : mc_ecc_ce_addr8_reg , address:0x21c
    input  [31:0]                        mc_ecc_ce_addr8_i,// read only signal
    // register name : mc_ecc_ce_addr9_reg , address:0x220
    input  [31:0]                        mc_ecc_ce_addr9_i,// read only signal
    // register name : mc_ecc_ce_addr10_reg , address:0x224
    input  [31:0]                        mc_ecc_ce_addr10_i,// read only signal
    // register name : mc_ecc_ce_addr11_reg , address:0x228
    input  [31:0]                        mc_ecc_ce_addr11_i,// read only signal
    // register name : mc_ecc_ce_addr12_reg , address:0x22c
    input  [31:0]                        mc_ecc_ce_addr12_i,// read only signal
    // register name : mc_ecc_ce_addr13_reg , address:0x230
    input  [31:0]                        mc_ecc_ce_addr13_i,// read only signal
    // register name : mc_ecc_ce_addr14_reg , address:0x234
    input  [31:0]                        mc_ecc_ce_addr14_i,// read only signal
    // register name : mc_ecc_ce_addr15_reg , address:0x238
    input  [31:0]                        mc_ecc_ce_addr15_i,// read only signal
    // register name : mc_ecc_uce_addr0_reg , address:0x23c
    input  [31:0]                        mc_ecc_uce_addr0_i,// read only signal
    // register name : mc_ecc_uce_addr1_reg , address:0x240
    input  [31:0]                        mc_ecc_uce_addr1_i,// read only signal
    // register name : mc_ecc_uce_addr2_reg , address:0x244
    input  [31:0]                        mc_ecc_uce_addr2_i,// read only signal
    // register name : mc_ecc_uce_addr3_reg , address:0x248
    input  [31:0]                        mc_ecc_uce_addr3_i,// read only signal
    // register name : axi2frame_dbg0_reg , address:0x250
    input  [31:0]                        a2f_dbg_ar_cnt_i,// read only signal
    // register name : axi2frame_dbg1_reg , address:0x254
    input  [31:0]                        a2f_dbg_r_cnt_i,// read only signal
    // register name : axi2frame_dbg2_reg , address:0x258
    input  [31:0]                        a2f_dbg_aw_cnt_i,// read only signal
    // register name : axi2frame_dbg3_reg , address:0x25c
    input  [31:0]                        a2f_dbg_w_cnt_i,// read only signal
    // register name : axi2frame_dbg4_reg , address:0x260
    input  [31:0]                        a2f_dbg_b_cnt_i,// read only signal
    // register name : axi2frame_dbg5_reg , address:0x264
    input  [31:0]                        a2f_dbg_axi_len_err_addr_i,// read only signal
    // register name : axi2frame_dbg6_reg , address:0x268
    input                        a2f_dbg_axi_len_err_i,// read only signal
    // register name : axi2frame_dbg8_reg , address:0x270
    input  [31:0]                        a2f_dbg_reserve_out_i,// read only signal
    // register name : mc_page_status_reg , address:0x274
    input                        mc_page_status_i,// read only signal
    // register name : hang_timeout_status_reg , address:0x278
    input                        hang_timeout_status_i,// read only signal
    // register name : bank1_err_wl_num0_reg , address:0x31c
    input  [12:0]                        bank1_err_wl0_i,// read only signal
    input  [12:0]                        bank1_err_wl1_i,// read only signal
    // register name : bank1_err_wl_num1_reg , address:0x320
    input  [12:0]                        bank1_err_wl2_i,// read only signal
    input  [12:0]                        bank1_err_wl3_i,// read only signal
    // register name : bank1_err_wl_num2_reg , address:0x324
    input  [12:0]                        bank1_err_wl4_i,// read only signal
    input  [12:0]                        bank1_err_wl5_i,// read only signal
    // register name : bank1_err_wl_num3_reg , address:0x328
    input  [12:0]                        bank1_err_wl6_i,// read only signal
    input  [12:0]                        bank1_err_wl7_i,// read only signal
    // register name : bank1_err_wl_num4_reg , address:0x32c
    input  [12:0]                        bank1_err_wl8_i,// read only signal
    input  [12:0]                        bank1_err_wl9_i,// read only signal
    // register name : bank1_err_wl_num5_reg , address:0x330
    input  [12:0]                        bank1_err_wl10_i,// read only signal
    input  [12:0]                        bank1_err_wl11_i,// read only signal
    // register name : bank1_err_wl_num6_reg , address:0x334
    input  [12:0]                        bank1_err_wl12_i,// read only signal
    input  [12:0]                        bank1_err_wl13_i,// read only signal
    // register name : bank1_err_wl_num7_reg , address:0x338
    input  [12:0]                        bank1_err_wl14_i,// read only signal
    input  [12:0]                        bank1_err_wl15_i,// read only signal
    // register name : bank1_err_wl_num8_reg , address:0x33c
    input  [12:0]                        bank1_err_wl16_i,// read only signal
    input  [12:0]                        bank1_err_wl17_i,// read only signal
    // register name : bank1_err_wl_num9_reg , address:0x340
    input  [12:0]                        bank1_err_wl18_i,// read only signal
    input  [12:0]                        bank1_err_wl19_i,// read only signal
    // register name : bank1_err_wl_num10_reg , address:0x344
    input  [12:0]                        bank1_err_wl20_i,// read only signal
    input  [12:0]                        bank1_err_wl21_i,// read only signal
    // register name : bank1_err_wl_num11_reg , address:0x348
    input  [12:0]                        bank1_err_wl22_i,// read only signal
    input  [12:0]                        bank1_err_wl23_i,// read only signal
    // register name : bank1_err_wl_num12_reg , address:0x34c
    input  [12:0]                        bank1_err_wl24_i,// read only signal
    input  [12:0]                        bank1_err_wl25_i,// read only signal
    // register name : bank1_err_wl_num13_reg , address:0x350
    input  [12:0]                        bank1_err_wl26_i,// read only signal
    input  [12:0]                        bank1_err_wl27_i,// read only signal
    // register name : bank1_err_wl_num14_reg , address:0x354
    input  [12:0]                        bank1_err_wl28_i,// read only signal
    input  [12:0]                        bank1_err_wl29_i,// read only signal
    // register name : bank1_err_wl_num15_reg , address:0x358
    input  [12:0]                        bank1_err_wl30_i,// read only signal
    input  [12:0]                        bank1_err_wl31_i,// read only signal
    // register name : bank1_err_wl_num16_reg , address:0x35c
    input  [12:0]                        bank1_err_wl32_i,// read only signal
    input  [12:0]                        bank1_err_wl33_i,// read only signal
    // register name : bank1_err_wl_num17_reg , address:0x360
    input  [12:0]                        bank1_err_wl34_i,// read only signal
    input  [12:0]                        bank1_err_wl35_i,// read only signal
    // register name : bank1_err_wl_num18_reg , address:0x364
    input  [12:0]                        bank1_err_wl36_i,// read only signal
    input  [12:0]                        bank1_err_wl37_i,// read only signal
    // register name : bank1_err_wl_num19_reg , address:0x368
    input  [12:0]                        bank1_err_wl38_i,// read only signal
    input  [12:0]                        bank1_err_wl39_i,// read only signal
    // register name : bank1_err_wl_num20_reg , address:0x36c
    input  [12:0]                        bank1_err_wl40_i,// read only signal
    input  [12:0]                        bank1_err_wl41_i,// read only signal
    // register name : bank1_err_wl_num21_reg , address:0x370
    input  [12:0]                        bank1_err_wl42_i,// read only signal
    input  [12:0]                        bank1_err_wl43_i,// read only signal
    // register name : bank1_err_wl_num22_reg , address:0x374
    input  [12:0]                        bank1_err_wl44_i,// read only signal
    input  [12:0]                        bank1_err_wl45_i,// read only signal
    // register name : bank1_err_wl_num23_reg , address:0x378
    input  [12:0]                        bank1_err_wl46_i,// read only signal
    input  [12:0]                        bank1_err_wl47_i,// read only signal
    // register name : bank1_err_wl_num24_reg , address:0x37c
    input  [12:0]                        bank1_err_wl48_i,// read only signal
    input  [12:0]                        bank1_err_wl49_i,// read only signal
    // register name : bank1_err_wl_num25_reg , address:0x380
    input  [12:0]                        bank1_err_wl50_i,// read only signal
    input  [12:0]                        bank1_err_wl51_i,// read only signal
    // register name : bank1_err_wl_num26_reg , address:0x384
    input  [12:0]                        bank1_err_wl52_i,// read only signal
    input  [12:0]                        bank1_err_wl53_i,// read only signal
    // register name : bank1_err_wl_num27_reg , address:0x388
    input  [12:0]                        bank1_err_wl54_i,// read only signal
    input  [12:0]                        bank1_err_wl55_i,// read only signal
    // register name : bank1_err_wl_num28_reg , address:0x38c
    input  [12:0]                        bank1_err_wl56_i,// read only signal
    input  [12:0]                        bank1_err_wl57_i,// read only signal
    // register name : bank1_err_wl_num29_reg , address:0x390
    input  [12:0]                        bank1_err_wl58_i,// read only signal
    input  [12:0]                        bank1_err_wl59_i,// read only signal
    // register name : bank1_err_wl_num30_reg , address:0x394
    input  [12:0]                        bank1_err_wl60_i,// read only signal
    input  [12:0]                        bank1_err_wl61_i,// read only signal
    // register name : bank1_err_wl_num31_reg , address:0x398
    input  [12:0]                        bank1_err_wl62_i,// read only signal
    input  [12:0]                        bank1_err_wl63_i,// read only signal
    // register name : bank1_err_csl_part0_reg , address:0x39c
    input  [7:0]                        bank1_err_csl0_part0_i,// read only signal
    input  [7:0]                        bank1_err_csl1_part0_i,// read only signal
    input  [7:0]                        bank1_err_csl0_part1_i,// read only signal
    input  [7:0]                        bank1_err_csl1_part1_i,// read only signal
    // register name : bank1_err_csl_part1_reg , address:0x3a0
    input  [7:0]                        bank1_err_csl0_part2_i,// read only signal
    input  [7:0]                        bank1_err_csl1_part2_i,// read only signal
    input  [7:0]                        bank1_err_csl0_part3_i,// read only signal
    input  [7:0]                        bank1_err_csl1_part3_i,// read only signal
    // register name : bank1_err_csl_part2_reg , address:0x3a4
    input  [7:0]                        bank1_err_csl0_part4_i,// read only signal
    input  [7:0]                        bank1_err_csl1_part4_i,// read only signal
    input  [7:0]                        bank1_err_csl0_part5_i,// read only signal
    input  [7:0]                        bank1_err_csl1_part5_i,// read only signal
    // register name : bank1_err_csl_part3_reg , address:0x3a8
    input  [7:0]                        bank1_err_csl0_part6_i,// read only signal
    input  [7:0]                        bank1_err_csl1_part6_i,// read only signal
    input  [7:0]                        bank1_err_csl0_part7_i,// read only signal
    input  [7:0]                        bank1_err_csl1_part7_i,// read only signal
    // register name : bank1_err_csl_part4_reg , address:0x3ac
    input  [7:0]                        bank1_err_csl0_part8_i,// read only signal
    input  [7:0]                        bank1_err_csl1_part8_i,// read only signal
    input  [7:0]                        bank1_err_csl0_part9_i,// read only signal
    input  [7:0]                        bank1_err_csl1_part9_i,// read only signal
    // register name : mc_bank1_bist_rescan_fail_num_reg , address:0x3b0
    input  [19:0]                        mc_bank1_bist_rescan_fail_num_i,// read only signal
    // register name : mc_bank1_bist_err_wl_reg , address:0x3b4
    input  [6:0]                        mc_bank1_bist_err_wl_num_i,// read only signal
    input                        err_bank1_wl_num_change_flag_i,// read only signal
    // register name : bank1_rescan_round_result_reg , address:0x3b8
    input  [14:0]                        bank1_rescan_round_result_i,// read only signal
 
    // W1C output ports
    // register name : mc_frame2array_dbg_reg , address:0xb0
    output reg ras_clr_o,
    // register name : mc_timeout_clr_reg , address:0xb4
    output reg mc_timeout_clr_o,
    // register name : bist_finish_clr_reg , address:0x160
    output reg bist_finish_clr_o,
    // register name : rescan_finish_clr_reg , address:0x174
    output reg rescan_finish_clr_o,
    // register name : mc_ecc_ctrl_reg , address:0x1f4
    output reg mc_ecc_ce_int_clr_o,
    output reg mc_ecc_uce_int_clr_o,
    // register name : hang_timeout_clr_reg , address:0x280
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
    // register name : phy_timing_cfg0_reg , address:0x8
    output reg [3:0] bank_radd_set_time_o,
    output reg [3:0] cadd_set_time_o,
    output reg [7:0] r_cas_set_time_o,
    output reg [7:0] w_cas_set_time_o,
    output reg [7:0] cas_wrrdy_time_o,
    // register name : mc_rf_period_cfg1_reg , address:0xc
    output reg [31:0] mc_rf_period_1_o,
    // register name : mc_rf_start_cfg1_reg , address:0x10
    output reg [31:0] mc_rf_start_1_o,
    // register name : mc_rf_period_cfg2_reg , address:0x14
    output reg [31:0] mc_rf_period_2_o,
    // register name : mc_rf_start_cfg2_reg , address:0x18
    output reg [31:0] mc_rf_start_2_o,
    // register name : mc_vmc_wl_num0_reg , address:0x1c
    output reg [12:0] mc_vmc_wl_num0_o,
    output reg [12:0] mc_vmc_wl_num1_o,
    // register name : mc_vmc_wl_num1_reg , address:0x20
    output reg [12:0] mc_vmc_wl_num2_o,
    output reg [12:0] mc_vmc_wl_num3_o,
    // register name : mc_vmc_wl_num2_reg , address:0x24
    output reg [12:0] mc_vmc_wl_num4_o,
    output reg [12:0] mc_vmc_wl_num5_o,
    // register name : mc_vmc_wl_num3_reg , address:0x28
    output reg [12:0] mc_vmc_wl_num6_o,
    output reg [12:0] mc_vmc_wl_num7_o,
    // register name : mc_vmc_wl_num4_reg , address:0x2c
    output reg [12:0] mc_vmc_wl_num8_o,
    output reg [12:0] mc_vmc_wl_num9_o,
    // register name : mc_vmc_wl_num5_reg , address:0x30
    output reg [12:0] mc_vmc_wl_num10_o,
    output reg [12:0] mc_vmc_wl_num11_o,
    // register name : mc_vmc_wl_num6_reg , address:0x34
    output reg [12:0] mc_vmc_wl_num12_o,
    output reg [12:0] mc_vmc_wl_num13_o,
    // register name : mc_vmc_wl_num7_reg , address:0x38
    output reg [12:0] mc_vmc_wl_num14_o,
    output reg [12:0] mc_vmc_wl_num15_o,
    // register name : mc_vmc_wl_num8_reg , address:0x3c
    output reg [12:0] mc_vmc_wl_num16_o,
    output reg [12:0] mc_vmc_wl_num17_o,
    // register name : mc_vmc_wl_num9_reg , address:0x40
    output reg [12:0] mc_vmc_wl_num18_o,
    output reg [12:0] mc_vmc_wl_num19_o,
    // register name : mc_vmc_wl_num10_reg , address:0x44
    output reg [12:0] mc_vmc_wl_num20_o,
    output reg [12:0] mc_vmc_wl_num21_o,
    // register name : mc_vmc_wl_num11_reg , address:0x48
    output reg [12:0] mc_vmc_wl_num22_o,
    output reg [12:0] mc_vmc_wl_num23_o,
    // register name : mc_vmc_wl_num12_reg , address:0x4c
    output reg [12:0] mc_vmc_wl_num24_o,
    output reg [12:0] mc_vmc_wl_num25_o,
    // register name : mc_vmc_wl_num13_reg , address:0x50
    output reg [12:0] mc_vmc_wl_num26_o,
    output reg [12:0] mc_vmc_wl_num27_o,
    // register name : mc_vmc_wl_num14_reg , address:0x54
    output reg [12:0] mc_vmc_wl_num28_o,
    output reg [12:0] mc_vmc_wl_num29_o,
    // register name : mc_vmc_wl_num15_reg , address:0x58
    output reg [12:0] mc_vmc_wl_num30_o,
    output reg [12:0] mc_vmc_wl_num31_o,
    // register name : mc_vmc_wl_num16_reg , address:0x5c
    output reg [12:0] mc_vmc_wl_num32_o,
    output reg [12:0] mc_vmc_wl_num33_o,
    // register name : mc_vmc_wl_num17_reg , address:0x60
    output reg [12:0] mc_vmc_wl_num34_o,
    output reg [12:0] mc_vmc_wl_num35_o,
    // register name : mc_vmc_wl_num18_reg , address:0x64
    output reg [12:0] mc_vmc_wl_num36_o,
    output reg [12:0] mc_vmc_wl_num37_o,
    // register name : mc_vmc_wl_num19_reg , address:0x68
    output reg [12:0] mc_vmc_wl_num38_o,
    output reg [12:0] mc_vmc_wl_num39_o,
    // register name : mc_vmc_wl_num20_reg , address:0x6c
    output reg [12:0] mc_vmc_wl_num40_o,
    output reg [12:0] mc_vmc_wl_num41_o,
    // register name : mc_vmc_wl_num21_reg , address:0x70
    output reg [12:0] mc_vmc_wl_num42_o,
    output reg [12:0] mc_vmc_wl_num43_o,
    // register name : mc_vmc_wl_num22_reg , address:0x74
    output reg [12:0] mc_vmc_wl_num44_o,
    output reg [12:0] mc_vmc_wl_num45_o,
    // register name : mc_vmc_wl_num23_reg , address:0x78
    output reg [12:0] mc_vmc_wl_num46_o,
    output reg [12:0] mc_vmc_wl_num47_o,
    // register name : mc_vmc_wl_num24_reg , address:0x7c
    output reg [12:0] mc_vmc_wl_num48_o,
    output reg [12:0] mc_vmc_wl_num49_o,
    // register name : mc_vmc_wl_num25_reg , address:0x80
    output reg [12:0] mc_vmc_wl_num50_o,
    output reg [12:0] mc_vmc_wl_num51_o,
    // register name : mc_vmc_wl_num26_reg , address:0x84
    output reg [12:0] mc_vmc_wl_num52_o,
    output reg [12:0] mc_vmc_wl_num53_o,
    // register name : mc_vmc_wl_num27_reg , address:0x88
    output reg [12:0] mc_vmc_wl_num54_o,
    output reg [12:0] mc_vmc_wl_num55_o,
    // register name : mc_vmc_wl_num28_reg , address:0x8c
    output reg [12:0] mc_vmc_wl_num56_o,
    output reg [12:0] mc_vmc_wl_num57_o,
    // register name : mc_vmc_wl_num29_reg , address:0x90
    output reg [12:0] mc_vmc_wl_num58_o,
    output reg [12:0] mc_vmc_wl_num59_o,
    // register name : mc_vmc_wl_num30_reg , address:0x94
    output reg [12:0] mc_vmc_wl_num60_o,
    output reg [12:0] mc_vmc_wl_num61_o,
    // register name : mc_vmc_wl_num31_reg , address:0x98
    output reg [12:0] mc_vmc_wl_num62_o,
    output reg [12:0] mc_vmc_wl_num63_o,
    // register name : mc_vmc_bl_num0_reg , address:0x9c
    output reg [7:0] mc_vmc_bl_num0_part0_o,
    output reg [7:0] mc_vmc_bl_num1_part0_o,
    output reg [7:0] mc_vmc_bl_num0_part1_o,
    output reg [7:0] mc_vmc_bl_num1_part1_o,
    // register name : mc_vmc_bl_num1_reg , address:0xa0
    output reg [7:0] mc_vmc_bl_num0_part2_o,
    output reg [7:0] mc_vmc_bl_num1_part2_o,
    output reg [7:0] mc_vmc_bl_num0_part3_o,
    output reg [7:0] mc_vmc_bl_num1_part3_o,
    // register name : mc_vmc_bl_num2_reg , address:0xa4
    output reg [7:0] mc_vmc_bl_num0_part4_o,
    output reg [7:0] mc_vmc_bl_num1_part4_o,
    output reg [7:0] mc_vmc_bl_num0_part5_o,
    output reg [7:0] mc_vmc_bl_num1_part5_o,
    // register name : mc_vmc_bl_num3_reg , address:0xa8
    output reg [7:0] mc_vmc_bl_num0_part6_o,
    output reg [7:0] mc_vmc_bl_num1_part6_o,
    output reg [7:0] mc_vmc_bl_num0_part7_o,
    output reg [7:0] mc_vmc_bl_num1_part7_o,
    // register name : mc_vmc_bl_num4_reg , address:0xac
    output reg [7:0] mc_vmc_bl_num0_part8_o,
    output reg [7:0] mc_vmc_bl_num1_part8_o,
    output reg [7:0] mc_vmc_bl_num0_part9_o,
    output reg [7:0] mc_vmc_bl_num1_part9_o,
    // register name : bist_finish_mask_reg , address:0x164
    output reg bist_finish_mask_o,
    // register name : hang_timeout_th_reg , address:0x168
    output reg [31:0] hang_timeout_th_o,
    // register name : rescan_finish_mask_reg , address:0x178
    output reg rescan_finish_mask_o,
    // register name : bist_pattern_reg0_reg , address:0x1cc
    output reg [31:0] bist_pattern_reg0_o,
    // register name : bist_pattern_reg1_reg , address:0x1d0
    output reg [31:0] bist_pattern_reg1_o,
    // register name : bist_pattern_reg2_reg , address:0x1d4
    output reg [31:0] bist_pattern_reg2_o,
    // register name : bist_pattern_reg3_reg , address:0x1d8
    output reg [31:0] bist_pattern_reg3_o,
    // register name : csl_bist_pattern_sel0_reg , address:0x1dc
    output reg [31:0] csl_bist_pattern_sel0_o,
    // register name : csl_bist_pattern_sel1_reg , address:0x1e0
    output reg [31:0] csl_bist_pattern_sel1_o,
    // register name : csl_bist_pattern_sel2_reg , address:0x1e4
    output reg [3:0] csl_bist_pattern_sel2_o,
    // register name : wl_bist_pattern_sel0_reg , address:0x1e8
    output reg [31:0] wl_bist_pattern_sel0_o,
    // register name : wl_bist_pattern_sel1_reg , address:0x1ec
    output reg [31:0] wl_bist_pattern_sel1_o,
    // register name : wl_bist_pattern_sel2_reg , address:0x1f0
    output reg [3:0] wl_bist_pattern_sel2_o,
    // register name : mc_ecc_ctrl_reg , address:0x1f4
    output reg mc_ecc_en_o,
    output reg [4:0] mc_ecc_ce_th_o,
    output reg mc_ecc_ce_int_mask_o,
    output reg mc_ecc_uce_int_mask_o,
    // register name : bist_scan_ctrl_reg , address:0x24c
    output reg bist_scan_start_bank_o,
    output reg bist_scan_end_bank_o,
    // register name : axi2frame_dbg7_reg , address:0x26c
    output reg [31:0] a2f_dbg_reserve_in_o,
    // register name : hang_timeout_mask_reg , address:0x27c
    output reg hang_timeout_mask_o,
    // register name : hang_timeout_en_reg , address:0x284
    output reg hang_timeout_en_o,
    // register name : mc_bank1_vmc_wl_num0_reg , address:0x288
    output reg [12:0] mc_bank1_vmc_wl_num0_o,
    output reg [12:0] mc_bank1_vmc_wl_num1_o,
    // register name : mc_bank1_vmc_wl_num1_reg , address:0x28c
    output reg [12:0] mc_bank1_vmc_wl_num2_o,
    output reg [12:0] mc_bank1_vmc_wl_num3_o,
    // register name : mc_bank1_vmc_wl_num2_reg , address:0x290
    output reg [12:0] mc_bank1_vmc_wl_num4_o,
    output reg [12:0] mc_bank1_vmc_wl_num5_o,
    // register name : mc_bank1_vmc_wl_num3_reg , address:0x294
    output reg [12:0] mc_bank1_vmc_wl_num6_o,
    output reg [12:0] mc_bank1_vmc_wl_num7_o,
    // register name : mc_bank1_vmc_wl_num4_reg , address:0x298
    output reg [12:0] mc_bank1_vmc_wl_num8_o,
    output reg [12:0] mc_bank1_vmc_wl_num9_o,
    // register name : mc_bank1_vmc_wl_num5_reg , address:0x29c
    output reg [12:0] mc_bank1_vmc_wl_num10_o,
    output reg [12:0] mc_bank1_vmc_wl_num11_o,
    // register name : mc_bank1_vmc_wl_num6_reg , address:0x2a0
    output reg [12:0] mc_bank1_vmc_wl_num12_o,
    output reg [12:0] mc_bank1_vmc_wl_num13_o,
    // register name : mc_bank1_vmc_wl_num7_reg , address:0x2a4
    output reg [12:0] mc_bank1_vmc_wl_num14_o,
    output reg [12:0] mc_bank1_vmc_wl_num15_o,
    // register name : mc_bank1_vmc_wl_num8_reg , address:0x2a8
    output reg [12:0] mc_bank1_vmc_wl_num16_o,
    output reg [12:0] mc_bank1_vmc_wl_num17_o,
    // register name : mc_bank1_vmc_wl_num9_reg , address:0x2ac
    output reg [12:0] mc_bank1_vmc_wl_num18_o,
    output reg [12:0] mc_bank1_vmc_wl_num19_o,
    // register name : mc_bank1_vmc_wl_num10_reg , address:0x2b0
    output reg [12:0] mc_bank1_vmc_wl_num20_o,
    output reg [12:0] mc_bank1_vmc_wl_num21_o,
    // register name : mc_bank1_vmc_wl_num11_reg , address:0x2b4
    output reg [12:0] mc_bank1_vmc_wl_num22_o,
    output reg [12:0] mc_bank1_vmc_wl_num23_o,
    // register name : mc_bank1_vmc_wl_num12_reg , address:0x2b8
    output reg [12:0] mc_bank1_vmc_wl_num24_o,
    output reg [12:0] mc_bank1_vmc_wl_num25_o,
    // register name : mc_bank1_vmc_wl_num13_reg , address:0x2bc
    output reg [12:0] mc_bank1_vmc_wl_num26_o,
    output reg [12:0] mc_bank1_vmc_wl_num27_o,
    // register name : mc_bank1_vmc_wl_num14_reg , address:0x2c0
    output reg [12:0] mc_bank1_vmc_wl_num28_o,
    output reg [12:0] mc_bank1_vmc_wl_num29_o,
    // register name : mc_bank1_vmc_wl_num15_reg , address:0x2c4
    output reg [12:0] mc_bank1_vmc_wl_num30_o,
    output reg [12:0] mc_bank1_vmc_wl_num31_o,
    // register name : mc_bank1_vmc_wl_num16_reg , address:0x2c8
    output reg [12:0] mc_bank1_vmc_wl_num32_o,
    output reg [12:0] mc_bank1_vmc_wl_num33_o,
    // register name : mc_bank1_vmc_wl_num17_reg , address:0x2cc
    output reg [12:0] mc_bank1_vmc_wl_num34_o,
    output reg [12:0] mc_bank1_vmc_wl_num35_o,
    // register name : mc_bank1_vmc_wl_num18_reg , address:0x2d0
    output reg [12:0] mc_bank1_vmc_wl_num36_o,
    output reg [12:0] mc_bank1_vmc_wl_num37_o,
    // register name : mc_bank1_vmc_wl_num19_reg , address:0x2d4
    output reg [12:0] mc_bank1_vmc_wl_num38_o,
    output reg [12:0] mc_bank1_vmc_wl_num39_o,
    // register name : mc_bank1_vmc_wl_num20_reg , address:0x2d8
    output reg [12:0] mc_bank1_vmc_wl_num40_o,
    output reg [12:0] mc_bank1_vmc_wl_num41_o,
    // register name : mc_bank1_vmc_wl_num21_reg , address:0x2dc
    output reg [12:0] mc_bank1_vmc_wl_num42_o,
    output reg [12:0] mc_bank1_vmc_wl_num43_o,
    // register name : mc_bank1_vmc_wl_num22_reg , address:0x2e0
    output reg [12:0] mc_bank1_vmc_wl_num44_o,
    output reg [12:0] mc_bank1_vmc_wl_num45_o,
    // register name : mc_bank1_vmc_wl_num23_reg , address:0x2e4
    output reg [12:0] mc_bank1_vmc_wl_num46_o,
    output reg [12:0] mc_bank1_vmc_wl_num47_o,
    // register name : mc_bank1_vmc_wl_num24_reg , address:0x2e8
    output reg [12:0] mc_bank1_vmc_wl_num48_o,
    output reg [12:0] mc_bank1_vmc_wl_num49_o,
    // register name : mc_bank1_vmc_wl_num25_reg , address:0x2ec
    output reg [12:0] mc_bank1_vmc_wl_num50_o,
    output reg [12:0] mc_bank1_vmc_wl_num51_o,
    // register name : mc_bank1_vmc_wl_num26_reg , address:0x2f0
    output reg [12:0] mc_bank1_vmc_wl_num52_o,
    output reg [12:0] mc_bank1_vmc_wl_num53_o,
    // register name : mc_bank1_vmc_wl_num27_reg , address:0x2f4
    output reg [12:0] mc_bank1_vmc_wl_num54_o,
    output reg [12:0] mc_bank1_vmc_wl_num55_o,
    // register name : mc_bank1_vmc_wl_num28_reg , address:0x2f8
    output reg [12:0] mc_bank1_vmc_wl_num56_o,
    output reg [12:0] mc_bank1_vmc_wl_num57_o,
    // register name : mc_bank1_vmc_wl_num29_reg , address:0x2fc
    output reg [12:0] mc_bank1_vmc_wl_num58_o,
    output reg [12:0] mc_bank1_vmc_wl_num59_o,
    // register name : mc_bank1_vmc_wl_num30_reg , address:0x300
    output reg [12:0] mc_bank1_vmc_wl_num60_o,
    output reg [12:0] mc_bank1_vmc_wl_num61_o,
    // register name : mc_bank1_vmc_wl_num31_reg , address:0x304
    output reg [12:0] mc_bank1_vmc_wl_num62_o,
    output reg [12:0] mc_bank1_vmc_wl_num63_o,
    // register name : mc_bank1_vmc_bl_num0_reg , address:0x308
    output reg [7:0] mc_bank1_vmc_bl_num0_part0_o,
    output reg [7:0] mc_bank1_vmc_bl_num1_part0_o,
    output reg [7:0] mc_bank1_vmc_bl_num0_part1_o,
    output reg [7:0] mc_bank1_vmc_bl_num1_part1_o,
    // register name : mc_bank1_vmc_bl_num1_reg , address:0x30c
    output reg [7:0] mc_bank1_vmc_bl_num0_part2_o,
    output reg [7:0] mc_bank1_vmc_bl_num1_part2_o,
    output reg [7:0] mc_bank1_vmc_bl_num0_part3_o,
    output reg [7:0] mc_bank1_vmc_bl_num1_part3_o,
    // register name : mc_bank1_vmc_bl_num2_reg , address:0x310
    output reg [7:0] mc_bank1_vmc_bl_num0_part4_o,
    output reg [7:0] mc_bank1_vmc_bl_num1_part4_o,
    output reg [7:0] mc_bank1_vmc_bl_num0_part5_o,
    output reg [7:0] mc_bank1_vmc_bl_num1_part5_o,
    // register name : mc_bank1_vmc_bl_num3_reg , address:0x314
    output reg [7:0] mc_bank1_vmc_bl_num0_part6_o,
    output reg [7:0] mc_bank1_vmc_bl_num1_part6_o,
    output reg [7:0] mc_bank1_vmc_bl_num0_part7_o,
    output reg [7:0] mc_bank1_vmc_bl_num1_part7_o,
    // register name : mc_bank1_vmc_bl_num4_reg , address:0x318
    output reg [7:0] mc_bank1_vmc_bl_num0_part8_o,
    output reg [7:0] mc_bank1_vmc_bl_num1_part8_o,
    output reg [7:0] mc_bank1_vmc_bl_num0_part9_o,
    output reg [7:0] mc_bank1_vmc_bl_num1_part9_o,
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

    //pslverr 
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'hc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h10)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h14)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h18)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h1c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h20)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h24)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h28)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h30)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h34)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h38)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h3c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h40)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h44)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h48)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h4c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h50)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h54)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h58)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h5c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h60)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h64)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h68)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h6c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h70)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h74)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h78)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h7c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h80)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h84)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h88)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h8c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h90)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h94)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h98)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h9c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'ha0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'ha4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'ha8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'hac)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hb0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'hb4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hb8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hbc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hc0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hc4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hc8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hcc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hd0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hd4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hd8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hdc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'he0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'he4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'he8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hec)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hf0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hf4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hf8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'hfc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h100)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h104)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h108)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h10c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h110)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h114)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h118)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h11c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h120)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h124)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h128)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h12c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h130)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h134)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h138)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h13c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h140)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h144)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h148)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h14c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h150)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h154)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h158)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h15c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h160)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h164)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h168)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h16c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h170)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h174)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h178)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h17c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h180)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h184)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h188)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h18c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h190)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h194)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h198)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h19c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h1a0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h1a4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h1a8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h1ac)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h1b0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h1b4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h1b8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h1bc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h1c0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h1c4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h1c8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h1cc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h1d0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h1d4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h1d8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h1dc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h1e0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h1e4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h1e8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h1ec)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h1f0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h1f4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h1f8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h1fc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h200)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h204)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h208)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h20c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h210)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h214)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h218)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h21c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h220)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h224)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h228)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h22c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h230)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h234)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h238)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h23c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h240)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h244)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h248)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h24c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h250)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h254)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h258)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h25c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h260)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h264)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h268)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h26c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h270)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h274)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h278)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h27c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h280)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h284)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h288)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h28c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h290)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h294)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h298)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h29c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2a0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2a4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2a8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2ac)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2b0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2b4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2b8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2bc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2c0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2c4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2c8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2cc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2d0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2d4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2d8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2dc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2e0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2e4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2e8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2ec)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2f0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2f4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2f8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h2fc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h300)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h304)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h308)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h30c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h310)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h314)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 12'h318)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h31c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h320)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h324)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h328)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h32c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h330)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h334)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h338)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h33c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h340)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h344)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h348)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h34c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h350)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h354)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h358)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h35c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h360)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h364)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h368)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h36c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h370)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h374)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h378)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h37c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h380)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h384)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h388)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h38c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h390)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h394)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h398)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h39c)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h3a0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h3a4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h3a8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h3ac)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h3b0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h3b4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 12'h3b8)) begin
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
        end
        else if (apb_write_sel && (paddr == 12'h4)) begin
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
        end
    end
    // register name : phy_timing_cfg0_reg , address:0x8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bank_radd_set_time_o <= 4'h0;
            cadd_set_time_o <= 4'h0;
            r_cas_set_time_o <= 8'h0;
            w_cas_set_time_o <= 8'h0;
            cas_wrrdy_time_o <= 8'h0;
        end
        else if (apb_write_sel && (paddr == 12'h8)) begin
            bank_radd_set_time_o <= pwdata[3:0];
            cadd_set_time_o <= pwdata[7:4];
            r_cas_set_time_o <= pwdata[15:8];
            w_cas_set_time_o <= pwdata[23:16];
            cas_wrrdy_time_o <= pwdata[31:24];
        end
    end
    // register name : mc_rf_period_cfg1_reg , address:0xc
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_rf_period_1_o <= 32'h186A000;
        end
        else if (apb_write_sel && (paddr == 12'hc)) begin
            mc_rf_period_1_o <= pwdata[31:0];
        end
    end
    // register name : mc_rf_start_cfg1_reg , address:0x10
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_rf_start_1_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 12'h10)) begin
            mc_rf_start_1_o <= pwdata[31:0];
        end
    end
    // register name : mc_rf_period_cfg2_reg , address:0x14
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_rf_period_2_o <= 32'h186A000;
        end
        else if (apb_write_sel && (paddr == 12'h14)) begin
            mc_rf_period_2_o <= pwdata[31:0];
        end
    end
    // register name : mc_rf_start_cfg2_reg , address:0x18
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_rf_start_2_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 12'h18)) begin
            mc_rf_start_2_o <= pwdata[31:0];
        end
    end
    // register name : mc_vmc_wl_num0_reg , address:0x1c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num0_o <= 13'h1FFF;
            mc_vmc_wl_num1_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h1c)) begin
            mc_vmc_wl_num0_o <= pwdata[12:0];
            mc_vmc_wl_num1_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num1_reg , address:0x20
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num2_o <= 13'h1FFF;
            mc_vmc_wl_num3_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h20)) begin
            mc_vmc_wl_num2_o <= pwdata[12:0];
            mc_vmc_wl_num3_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num2_reg , address:0x24
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num4_o <= 13'h1FFF;
            mc_vmc_wl_num5_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h24)) begin
            mc_vmc_wl_num4_o <= pwdata[12:0];
            mc_vmc_wl_num5_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num3_reg , address:0x28
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num6_o <= 13'h1FFF;
            mc_vmc_wl_num7_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h28)) begin
            mc_vmc_wl_num6_o <= pwdata[12:0];
            mc_vmc_wl_num7_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num4_reg , address:0x2c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num8_o <= 13'h1FFF;
            mc_vmc_wl_num9_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2c)) begin
            mc_vmc_wl_num8_o <= pwdata[12:0];
            mc_vmc_wl_num9_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num5_reg , address:0x30
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num10_o <= 13'h1FFF;
            mc_vmc_wl_num11_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h30)) begin
            mc_vmc_wl_num10_o <= pwdata[12:0];
            mc_vmc_wl_num11_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num6_reg , address:0x34
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num12_o <= 13'h1FFF;
            mc_vmc_wl_num13_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h34)) begin
            mc_vmc_wl_num12_o <= pwdata[12:0];
            mc_vmc_wl_num13_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num7_reg , address:0x38
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num14_o <= 13'h1FFF;
            mc_vmc_wl_num15_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h38)) begin
            mc_vmc_wl_num14_o <= pwdata[12:0];
            mc_vmc_wl_num15_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num8_reg , address:0x3c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num16_o <= 13'h1FFF;
            mc_vmc_wl_num17_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h3c)) begin
            mc_vmc_wl_num16_o <= pwdata[12:0];
            mc_vmc_wl_num17_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num9_reg , address:0x40
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num18_o <= 13'h1FFF;
            mc_vmc_wl_num19_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h40)) begin
            mc_vmc_wl_num18_o <= pwdata[12:0];
            mc_vmc_wl_num19_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num10_reg , address:0x44
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num20_o <= 13'h1FFF;
            mc_vmc_wl_num21_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h44)) begin
            mc_vmc_wl_num20_o <= pwdata[12:0];
            mc_vmc_wl_num21_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num11_reg , address:0x48
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num22_o <= 13'h1FFF;
            mc_vmc_wl_num23_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h48)) begin
            mc_vmc_wl_num22_o <= pwdata[12:0];
            mc_vmc_wl_num23_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num12_reg , address:0x4c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num24_o <= 13'h1FFF;
            mc_vmc_wl_num25_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h4c)) begin
            mc_vmc_wl_num24_o <= pwdata[12:0];
            mc_vmc_wl_num25_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num13_reg , address:0x50
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num26_o <= 13'h1FFF;
            mc_vmc_wl_num27_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h50)) begin
            mc_vmc_wl_num26_o <= pwdata[12:0];
            mc_vmc_wl_num27_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num14_reg , address:0x54
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num28_o <= 13'h1FFF;
            mc_vmc_wl_num29_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h54)) begin
            mc_vmc_wl_num28_o <= pwdata[12:0];
            mc_vmc_wl_num29_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num15_reg , address:0x58
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num30_o <= 13'h1FFF;
            mc_vmc_wl_num31_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h58)) begin
            mc_vmc_wl_num30_o <= pwdata[12:0];
            mc_vmc_wl_num31_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num16_reg , address:0x5c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num32_o <= 13'h1FFF;
            mc_vmc_wl_num33_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h5c)) begin
            mc_vmc_wl_num32_o <= pwdata[12:0];
            mc_vmc_wl_num33_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num17_reg , address:0x60
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num34_o <= 13'h1FFF;
            mc_vmc_wl_num35_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h60)) begin
            mc_vmc_wl_num34_o <= pwdata[12:0];
            mc_vmc_wl_num35_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num18_reg , address:0x64
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num36_o <= 13'h1FFF;
            mc_vmc_wl_num37_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h64)) begin
            mc_vmc_wl_num36_o <= pwdata[12:0];
            mc_vmc_wl_num37_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num19_reg , address:0x68
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num38_o <= 13'h1FFF;
            mc_vmc_wl_num39_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h68)) begin
            mc_vmc_wl_num38_o <= pwdata[12:0];
            mc_vmc_wl_num39_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num20_reg , address:0x6c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num40_o <= 13'h1FFF;
            mc_vmc_wl_num41_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h6c)) begin
            mc_vmc_wl_num40_o <= pwdata[12:0];
            mc_vmc_wl_num41_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num21_reg , address:0x70
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num42_o <= 13'h1FFF;
            mc_vmc_wl_num43_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h70)) begin
            mc_vmc_wl_num42_o <= pwdata[12:0];
            mc_vmc_wl_num43_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num22_reg , address:0x74
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num44_o <= 13'h1FFF;
            mc_vmc_wl_num45_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h74)) begin
            mc_vmc_wl_num44_o <= pwdata[12:0];
            mc_vmc_wl_num45_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num23_reg , address:0x78
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num46_o <= 13'h1FFF;
            mc_vmc_wl_num47_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h78)) begin
            mc_vmc_wl_num46_o <= pwdata[12:0];
            mc_vmc_wl_num47_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num24_reg , address:0x7c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num48_o <= 13'h1FFF;
            mc_vmc_wl_num49_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h7c)) begin
            mc_vmc_wl_num48_o <= pwdata[12:0];
            mc_vmc_wl_num49_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num25_reg , address:0x80
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num50_o <= 13'h1FFF;
            mc_vmc_wl_num51_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h80)) begin
            mc_vmc_wl_num50_o <= pwdata[12:0];
            mc_vmc_wl_num51_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num26_reg , address:0x84
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num52_o <= 13'h1FFF;
            mc_vmc_wl_num53_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h84)) begin
            mc_vmc_wl_num52_o <= pwdata[12:0];
            mc_vmc_wl_num53_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num27_reg , address:0x88
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num54_o <= 13'h1FFF;
            mc_vmc_wl_num55_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h88)) begin
            mc_vmc_wl_num54_o <= pwdata[12:0];
            mc_vmc_wl_num55_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num28_reg , address:0x8c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num56_o <= 13'h1FFF;
            mc_vmc_wl_num57_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h8c)) begin
            mc_vmc_wl_num56_o <= pwdata[12:0];
            mc_vmc_wl_num57_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num29_reg , address:0x90
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num58_o <= 13'h1FFF;
            mc_vmc_wl_num59_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h90)) begin
            mc_vmc_wl_num58_o <= pwdata[12:0];
            mc_vmc_wl_num59_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num30_reg , address:0x94
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num60_o <= 13'h1FFF;
            mc_vmc_wl_num61_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h94)) begin
            mc_vmc_wl_num60_o <= pwdata[12:0];
            mc_vmc_wl_num61_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_wl_num31_reg , address:0x98
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_wl_num62_o <= 13'h1FFF;
            mc_vmc_wl_num63_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h98)) begin
            mc_vmc_wl_num62_o <= pwdata[12:0];
            mc_vmc_wl_num63_o <= pwdata[28:16];
        end
    end
    // register name : mc_vmc_bl_num0_reg , address:0x9c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part0_o <= 8'hFF;
            mc_vmc_bl_num1_part0_o <= 8'hFF;
            mc_vmc_bl_num0_part1_o <= 8'hFF;
            mc_vmc_bl_num1_part1_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 12'h9c)) begin
            mc_vmc_bl_num0_part0_o <= pwdata[7:0];
            mc_vmc_bl_num1_part0_o <= pwdata[15:8];
            mc_vmc_bl_num0_part1_o <= pwdata[23:16];
            mc_vmc_bl_num1_part1_o <= pwdata[31:24];
        end
    end
    // register name : mc_vmc_bl_num1_reg , address:0xa0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part2_o <= 8'hFF;
            mc_vmc_bl_num1_part2_o <= 8'hFF;
            mc_vmc_bl_num0_part3_o <= 8'hFF;
            mc_vmc_bl_num1_part3_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 12'ha0)) begin
            mc_vmc_bl_num0_part2_o <= pwdata[7:0];
            mc_vmc_bl_num1_part2_o <= pwdata[15:8];
            mc_vmc_bl_num0_part3_o <= pwdata[23:16];
            mc_vmc_bl_num1_part3_o <= pwdata[31:24];
        end
    end
    // register name : mc_vmc_bl_num2_reg , address:0xa4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part4_o <= 8'hFF;
            mc_vmc_bl_num1_part4_o <= 8'hFF;
            mc_vmc_bl_num0_part5_o <= 8'hFF;
            mc_vmc_bl_num1_part5_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 12'ha4)) begin
            mc_vmc_bl_num0_part4_o <= pwdata[7:0];
            mc_vmc_bl_num1_part4_o <= pwdata[15:8];
            mc_vmc_bl_num0_part5_o <= pwdata[23:16];
            mc_vmc_bl_num1_part5_o <= pwdata[31:24];
        end
    end
    // register name : mc_vmc_bl_num3_reg , address:0xa8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part6_o <= 8'hFF;
            mc_vmc_bl_num1_part6_o <= 8'hFF;
            mc_vmc_bl_num0_part7_o <= 8'hFF;
            mc_vmc_bl_num1_part7_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 12'ha8)) begin
            mc_vmc_bl_num0_part6_o <= pwdata[7:0];
            mc_vmc_bl_num1_part6_o <= pwdata[15:8];
            mc_vmc_bl_num0_part7_o <= pwdata[23:16];
            mc_vmc_bl_num1_part7_o <= pwdata[31:24];
        end
    end
    // register name : mc_vmc_bl_num4_reg , address:0xac
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_vmc_bl_num0_part8_o <= 8'hFF;
            mc_vmc_bl_num1_part8_o <= 8'hFF;
            mc_vmc_bl_num0_part9_o <= 8'hFF;
            mc_vmc_bl_num1_part9_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 12'hac)) begin
            mc_vmc_bl_num0_part8_o <= pwdata[7:0];
            mc_vmc_bl_num1_part8_o <= pwdata[15:8];
            mc_vmc_bl_num0_part9_o <= pwdata[23:16];
            mc_vmc_bl_num1_part9_o <= pwdata[31:24];
        end
    end
    // register name : bist_finish_mask_reg , address:0x164
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_finish_mask_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 12'h164)) begin
            bist_finish_mask_o <= pwdata[0];
        end
    end
    // register name : hang_timeout_th_reg , address:0x168
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_th_o <= 32'h186a00;
        end
        else if (apb_write_sel && (paddr == 12'h168)) begin
            hang_timeout_th_o <= pwdata[31:0];
        end
    end
    // register name : rescan_finish_mask_reg , address:0x178
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            rescan_finish_mask_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 12'h178)) begin
            rescan_finish_mask_o <= pwdata[0];
        end
    end
    // register name : bist_pattern_reg0_reg , address:0x1cc
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_pattern_reg0_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 12'h1cc)) begin
            bist_pattern_reg0_o <= pwdata[31:0];
        end
    end
    // register name : bist_pattern_reg1_reg , address:0x1d0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_pattern_reg1_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 12'h1d0)) begin
            bist_pattern_reg1_o <= pwdata[31:0];
        end
    end
    // register name : bist_pattern_reg2_reg , address:0x1d4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_pattern_reg2_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 12'h1d4)) begin
            bist_pattern_reg2_o <= pwdata[31:0];
        end
    end
    // register name : bist_pattern_reg3_reg , address:0x1d8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_pattern_reg3_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 12'h1d8)) begin
            bist_pattern_reg3_o <= pwdata[31:0];
        end
    end
    // register name : csl_bist_pattern_sel0_reg , address:0x1dc
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            csl_bist_pattern_sel0_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 12'h1dc)) begin
            csl_bist_pattern_sel0_o <= pwdata[31:0];
        end
    end
    // register name : csl_bist_pattern_sel1_reg , address:0x1e0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            csl_bist_pattern_sel1_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 12'h1e0)) begin
            csl_bist_pattern_sel1_o <= pwdata[31:0];
        end
    end
    // register name : csl_bist_pattern_sel2_reg , address:0x1e4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            csl_bist_pattern_sel2_o <= 4'h0;
        end
        else if (apb_write_sel && (paddr == 12'h1e4)) begin
            csl_bist_pattern_sel2_o <= pwdata[3:0];
        end
    end
    // register name : wl_bist_pattern_sel0_reg , address:0x1e8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            wl_bist_pattern_sel0_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 12'h1e8)) begin
            wl_bist_pattern_sel0_o <= pwdata[31:0];
        end
    end
    // register name : wl_bist_pattern_sel1_reg , address:0x1ec
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            wl_bist_pattern_sel1_o <= 32'hFFFFFFFF;
        end
        else if (apb_write_sel && (paddr == 12'h1ec)) begin
            wl_bist_pattern_sel1_o <= pwdata[31:0];
        end
    end
    // register name : wl_bist_pattern_sel2_reg , address:0x1f0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            wl_bist_pattern_sel2_o <= 4'h0;
        end
        else if (apb_write_sel && (paddr == 12'h1f0)) begin
            wl_bist_pattern_sel2_o <= pwdata[3:0];
        end
    end
    // register name : mc_ecc_ctrl_reg , address:0x1f4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_ecc_en_o <= 1'b0;
            mc_ecc_ce_th_o <= 5'h10;
            mc_ecc_ce_int_mask_o <= 1'b0;
            mc_ecc_uce_int_mask_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 12'h1f4)) begin
            mc_ecc_en_o <= pwdata[0];
            mc_ecc_ce_th_o <= pwdata[8:4];
            mc_ecc_ce_int_mask_o <= pwdata[20];
            mc_ecc_uce_int_mask_o <= pwdata[28];
        end
    end
    // register name : bist_scan_ctrl_reg , address:0x24c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_scan_start_bank_o <= 1'b0;
            bist_scan_end_bank_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 12'h24c)) begin
            bist_scan_start_bank_o <= pwdata[0];
            bist_scan_end_bank_o <= pwdata[4];
        end
    end
    // register name : axi2frame_dbg7_reg , address:0x26c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            a2f_dbg_reserve_in_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 12'h26c)) begin
            a2f_dbg_reserve_in_o <= pwdata[31:0];
        end
    end
    // register name : hang_timeout_mask_reg , address:0x27c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_mask_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 12'h27c)) begin
            hang_timeout_mask_o <= pwdata[0];
        end
    end
    // register name : hang_timeout_en_reg , address:0x284
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_en_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 12'h284)) begin
            hang_timeout_en_o <= pwdata[0];
        end
    end
    // register name : mc_bank1_vmc_wl_num0_reg , address:0x288
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num0_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num1_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h288)) begin
            mc_bank1_vmc_wl_num0_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num1_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num1_reg , address:0x28c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num2_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num3_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h28c)) begin
            mc_bank1_vmc_wl_num2_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num3_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num2_reg , address:0x290
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num4_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num5_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h290)) begin
            mc_bank1_vmc_wl_num4_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num5_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num3_reg , address:0x294
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num6_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num7_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h294)) begin
            mc_bank1_vmc_wl_num6_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num7_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num4_reg , address:0x298
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num8_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num9_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h298)) begin
            mc_bank1_vmc_wl_num8_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num9_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num5_reg , address:0x29c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num10_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num11_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h29c)) begin
            mc_bank1_vmc_wl_num10_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num11_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num6_reg , address:0x2a0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num12_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num13_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2a0)) begin
            mc_bank1_vmc_wl_num12_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num13_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num7_reg , address:0x2a4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num14_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num15_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2a4)) begin
            mc_bank1_vmc_wl_num14_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num15_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num8_reg , address:0x2a8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num16_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num17_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2a8)) begin
            mc_bank1_vmc_wl_num16_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num17_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num9_reg , address:0x2ac
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num18_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num19_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2ac)) begin
            mc_bank1_vmc_wl_num18_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num19_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num10_reg , address:0x2b0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num20_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num21_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2b0)) begin
            mc_bank1_vmc_wl_num20_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num21_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num11_reg , address:0x2b4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num22_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num23_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2b4)) begin
            mc_bank1_vmc_wl_num22_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num23_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num12_reg , address:0x2b8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num24_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num25_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2b8)) begin
            mc_bank1_vmc_wl_num24_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num25_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num13_reg , address:0x2bc
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num26_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num27_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2bc)) begin
            mc_bank1_vmc_wl_num26_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num27_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num14_reg , address:0x2c0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num28_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num29_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2c0)) begin
            mc_bank1_vmc_wl_num28_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num29_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num15_reg , address:0x2c4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num30_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num31_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2c4)) begin
            mc_bank1_vmc_wl_num30_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num31_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num16_reg , address:0x2c8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num32_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num33_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2c8)) begin
            mc_bank1_vmc_wl_num32_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num33_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num17_reg , address:0x2cc
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num34_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num35_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2cc)) begin
            mc_bank1_vmc_wl_num34_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num35_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num18_reg , address:0x2d0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num36_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num37_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2d0)) begin
            mc_bank1_vmc_wl_num36_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num37_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num19_reg , address:0x2d4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num38_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num39_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2d4)) begin
            mc_bank1_vmc_wl_num38_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num39_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num20_reg , address:0x2d8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num40_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num41_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2d8)) begin
            mc_bank1_vmc_wl_num40_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num41_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num21_reg , address:0x2dc
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num42_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num43_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2dc)) begin
            mc_bank1_vmc_wl_num42_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num43_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num22_reg , address:0x2e0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num44_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num45_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2e0)) begin
            mc_bank1_vmc_wl_num44_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num45_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num23_reg , address:0x2e4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num46_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num47_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2e4)) begin
            mc_bank1_vmc_wl_num46_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num47_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num24_reg , address:0x2e8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num48_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num49_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2e8)) begin
            mc_bank1_vmc_wl_num48_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num49_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num25_reg , address:0x2ec
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num50_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num51_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2ec)) begin
            mc_bank1_vmc_wl_num50_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num51_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num26_reg , address:0x2f0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num52_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num53_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2f0)) begin
            mc_bank1_vmc_wl_num52_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num53_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num27_reg , address:0x2f4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num54_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num55_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2f4)) begin
            mc_bank1_vmc_wl_num54_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num55_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num28_reg , address:0x2f8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num56_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num57_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2f8)) begin
            mc_bank1_vmc_wl_num56_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num57_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num29_reg , address:0x2fc
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num58_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num59_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h2fc)) begin
            mc_bank1_vmc_wl_num58_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num59_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num30_reg , address:0x300
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num60_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num61_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h300)) begin
            mc_bank1_vmc_wl_num60_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num61_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_wl_num31_reg , address:0x304
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_wl_num62_o <= 13'h1FFF;
            mc_bank1_vmc_wl_num63_o <= 13'h1FFF;
        end
        else if (apb_write_sel && (paddr == 12'h304)) begin
            mc_bank1_vmc_wl_num62_o <= pwdata[12:0];
            mc_bank1_vmc_wl_num63_o <= pwdata[28:16];
        end
    end
    // register name : mc_bank1_vmc_bl_num0_reg , address:0x308
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_bl_num0_part0_o <= 8'hFF;
            mc_bank1_vmc_bl_num1_part0_o <= 8'hFF;
            mc_bank1_vmc_bl_num0_part1_o <= 8'hFF;
            mc_bank1_vmc_bl_num1_part1_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 12'h308)) begin
            mc_bank1_vmc_bl_num0_part0_o <= pwdata[7:0];
            mc_bank1_vmc_bl_num1_part0_o <= pwdata[15:8];
            mc_bank1_vmc_bl_num0_part1_o <= pwdata[23:16];
            mc_bank1_vmc_bl_num1_part1_o <= pwdata[31:24];
        end
    end
    // register name : mc_bank1_vmc_bl_num1_reg , address:0x30c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_bl_num0_part2_o <= 8'hFF;
            mc_bank1_vmc_bl_num1_part2_o <= 8'hFF;
            mc_bank1_vmc_bl_num0_part3_o <= 8'hFF;
            mc_bank1_vmc_bl_num1_part3_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 12'h30c)) begin
            mc_bank1_vmc_bl_num0_part2_o <= pwdata[7:0];
            mc_bank1_vmc_bl_num1_part2_o <= pwdata[15:8];
            mc_bank1_vmc_bl_num0_part3_o <= pwdata[23:16];
            mc_bank1_vmc_bl_num1_part3_o <= pwdata[31:24];
        end
    end
    // register name : mc_bank1_vmc_bl_num2_reg , address:0x310
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_bl_num0_part4_o <= 8'hFF;
            mc_bank1_vmc_bl_num1_part4_o <= 8'hFF;
            mc_bank1_vmc_bl_num0_part5_o <= 8'hFF;
            mc_bank1_vmc_bl_num1_part5_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 12'h310)) begin
            mc_bank1_vmc_bl_num0_part4_o <= pwdata[7:0];
            mc_bank1_vmc_bl_num1_part4_o <= pwdata[15:8];
            mc_bank1_vmc_bl_num0_part5_o <= pwdata[23:16];
            mc_bank1_vmc_bl_num1_part5_o <= pwdata[31:24];
        end
    end
    // register name : mc_bank1_vmc_bl_num3_reg , address:0x314
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_bl_num0_part6_o <= 8'hFF;
            mc_bank1_vmc_bl_num1_part6_o <= 8'hFF;
            mc_bank1_vmc_bl_num0_part7_o <= 8'hFF;
            mc_bank1_vmc_bl_num1_part7_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 12'h314)) begin
            mc_bank1_vmc_bl_num0_part6_o <= pwdata[7:0];
            mc_bank1_vmc_bl_num1_part6_o <= pwdata[15:8];
            mc_bank1_vmc_bl_num0_part7_o <= pwdata[23:16];
            mc_bank1_vmc_bl_num1_part7_o <= pwdata[31:24];
        end
    end
    // register name : mc_bank1_vmc_bl_num4_reg , address:0x318
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_bank1_vmc_bl_num0_part8_o <= 8'hFF;
            mc_bank1_vmc_bl_num1_part8_o <= 8'hFF;
            mc_bank1_vmc_bl_num0_part9_o <= 8'hFF;
            mc_bank1_vmc_bl_num1_part9_o <= 8'hFF;
        end
        else if (apb_write_sel && (paddr == 12'h318)) begin
            mc_bank1_vmc_bl_num0_part8_o <= pwdata[7:0];
            mc_bank1_vmc_bl_num1_part8_o <= pwdata[15:8];
            mc_bank1_vmc_bl_num0_part9_o <= pwdata[23:16];
            mc_bank1_vmc_bl_num1_part9_o <= pwdata[31:24];
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
                12'h0: //register name:mc_id_reg,address:0x0
                prdata <= {mc_id_i};
                12'h4: //register name:mc_work_ctrl_reg,address:0x4
                prdata <= {22'h0,mc_csl_scan_mode_sel_o,mc_csl_scan_check_sel_o,mc_csl_scan_addr_range_sel_o,mc_rescan_addr_range_sel_o,mc_bist_en_o,mc_bl_vmc_en_o,mc_wl_vmc_en_o,mc_debug_en_o,mc_rf_cfg_sel_o,mc_en_o};
                12'h8: //register name:phy_timing_cfg0_reg,address:0x8
                prdata <= {cas_wrrdy_time_o,w_cas_set_time_o,r_cas_set_time_o,cadd_set_time_o,bank_radd_set_time_o};
                12'hc: //register name:mc_rf_period_cfg1_reg,address:0xc
                prdata <= {mc_rf_period_1_o};
                12'h10: //register name:mc_rf_start_cfg1_reg,address:0x10
                prdata <= {mc_rf_start_1_o};
                12'h14: //register name:mc_rf_period_cfg2_reg,address:0x14
                prdata <= {mc_rf_period_2_o};
                12'h18: //register name:mc_rf_start_cfg2_reg,address:0x18
                prdata <= {mc_rf_start_2_o};
                12'h1c: //register name:mc_vmc_wl_num0_reg,address:0x1c
                prdata <= {3'h0,mc_vmc_wl_num1_o,3'h0,mc_vmc_wl_num0_o};
                12'h20: //register name:mc_vmc_wl_num1_reg,address:0x20
                prdata <= {3'h0,mc_vmc_wl_num3_o,3'h0,mc_vmc_wl_num2_o};
                12'h24: //register name:mc_vmc_wl_num2_reg,address:0x24
                prdata <= {3'h0,mc_vmc_wl_num5_o,3'h0,mc_vmc_wl_num4_o};
                12'h28: //register name:mc_vmc_wl_num3_reg,address:0x28
                prdata <= {3'h0,mc_vmc_wl_num7_o,3'h0,mc_vmc_wl_num6_o};
                12'h2c: //register name:mc_vmc_wl_num4_reg,address:0x2c
                prdata <= {3'h0,mc_vmc_wl_num9_o,3'h0,mc_vmc_wl_num8_o};
                12'h30: //register name:mc_vmc_wl_num5_reg,address:0x30
                prdata <= {3'h0,mc_vmc_wl_num11_o,3'h0,mc_vmc_wl_num10_o};
                12'h34: //register name:mc_vmc_wl_num6_reg,address:0x34
                prdata <= {3'h0,mc_vmc_wl_num13_o,3'h0,mc_vmc_wl_num12_o};
                12'h38: //register name:mc_vmc_wl_num7_reg,address:0x38
                prdata <= {3'h0,mc_vmc_wl_num15_o,3'h0,mc_vmc_wl_num14_o};
                12'h3c: //register name:mc_vmc_wl_num8_reg,address:0x3c
                prdata <= {3'h0,mc_vmc_wl_num17_o,3'h0,mc_vmc_wl_num16_o};
                12'h40: //register name:mc_vmc_wl_num9_reg,address:0x40
                prdata <= {3'h0,mc_vmc_wl_num19_o,3'h0,mc_vmc_wl_num18_o};
                12'h44: //register name:mc_vmc_wl_num10_reg,address:0x44
                prdata <= {3'h0,mc_vmc_wl_num21_o,3'h0,mc_vmc_wl_num20_o};
                12'h48: //register name:mc_vmc_wl_num11_reg,address:0x48
                prdata <= {3'h0,mc_vmc_wl_num23_o,3'h0,mc_vmc_wl_num22_o};
                12'h4c: //register name:mc_vmc_wl_num12_reg,address:0x4c
                prdata <= {3'h0,mc_vmc_wl_num25_o,3'h0,mc_vmc_wl_num24_o};
                12'h50: //register name:mc_vmc_wl_num13_reg,address:0x50
                prdata <= {3'h0,mc_vmc_wl_num27_o,3'h0,mc_vmc_wl_num26_o};
                12'h54: //register name:mc_vmc_wl_num14_reg,address:0x54
                prdata <= {3'h0,mc_vmc_wl_num29_o,3'h0,mc_vmc_wl_num28_o};
                12'h58: //register name:mc_vmc_wl_num15_reg,address:0x58
                prdata <= {3'h0,mc_vmc_wl_num31_o,3'h0,mc_vmc_wl_num30_o};
                12'h5c: //register name:mc_vmc_wl_num16_reg,address:0x5c
                prdata <= {3'h0,mc_vmc_wl_num33_o,3'h0,mc_vmc_wl_num32_o};
                12'h60: //register name:mc_vmc_wl_num17_reg,address:0x60
                prdata <= {3'h0,mc_vmc_wl_num35_o,3'h0,mc_vmc_wl_num34_o};
                12'h64: //register name:mc_vmc_wl_num18_reg,address:0x64
                prdata <= {3'h0,mc_vmc_wl_num37_o,3'h0,mc_vmc_wl_num36_o};
                12'h68: //register name:mc_vmc_wl_num19_reg,address:0x68
                prdata <= {3'h0,mc_vmc_wl_num39_o,3'h0,mc_vmc_wl_num38_o};
                12'h6c: //register name:mc_vmc_wl_num20_reg,address:0x6c
                prdata <= {3'h0,mc_vmc_wl_num41_o,3'h0,mc_vmc_wl_num40_o};
                12'h70: //register name:mc_vmc_wl_num21_reg,address:0x70
                prdata <= {3'h0,mc_vmc_wl_num43_o,3'h0,mc_vmc_wl_num42_o};
                12'h74: //register name:mc_vmc_wl_num22_reg,address:0x74
                prdata <= {3'h0,mc_vmc_wl_num45_o,3'h0,mc_vmc_wl_num44_o};
                12'h78: //register name:mc_vmc_wl_num23_reg,address:0x78
                prdata <= {3'h0,mc_vmc_wl_num47_o,3'h0,mc_vmc_wl_num46_o};
                12'h7c: //register name:mc_vmc_wl_num24_reg,address:0x7c
                prdata <= {3'h0,mc_vmc_wl_num49_o,3'h0,mc_vmc_wl_num48_o};
                12'h80: //register name:mc_vmc_wl_num25_reg,address:0x80
                prdata <= {3'h0,mc_vmc_wl_num51_o,3'h0,mc_vmc_wl_num50_o};
                12'h84: //register name:mc_vmc_wl_num26_reg,address:0x84
                prdata <= {3'h0,mc_vmc_wl_num53_o,3'h0,mc_vmc_wl_num52_o};
                12'h88: //register name:mc_vmc_wl_num27_reg,address:0x88
                prdata <= {3'h0,mc_vmc_wl_num55_o,3'h0,mc_vmc_wl_num54_o};
                12'h8c: //register name:mc_vmc_wl_num28_reg,address:0x8c
                prdata <= {3'h0,mc_vmc_wl_num57_o,3'h0,mc_vmc_wl_num56_o};
                12'h90: //register name:mc_vmc_wl_num29_reg,address:0x90
                prdata <= {3'h0,mc_vmc_wl_num59_o,3'h0,mc_vmc_wl_num58_o};
                12'h94: //register name:mc_vmc_wl_num30_reg,address:0x94
                prdata <= {3'h0,mc_vmc_wl_num61_o,3'h0,mc_vmc_wl_num60_o};
                12'h98: //register name:mc_vmc_wl_num31_reg,address:0x98
                prdata <= {3'h0,mc_vmc_wl_num63_o,3'h0,mc_vmc_wl_num62_o};
                12'h9c: //register name:mc_vmc_bl_num0_reg,address:0x9c
                prdata <= {mc_vmc_bl_num1_part1_o,mc_vmc_bl_num0_part1_o,mc_vmc_bl_num1_part0_o,mc_vmc_bl_num0_part0_o};
                12'ha0: //register name:mc_vmc_bl_num1_reg,address:0xa0
                prdata <= {mc_vmc_bl_num1_part3_o,mc_vmc_bl_num0_part3_o,mc_vmc_bl_num1_part2_o,mc_vmc_bl_num0_part2_o};
                12'ha4: //register name:mc_vmc_bl_num2_reg,address:0xa4
                prdata <= {mc_vmc_bl_num1_part5_o,mc_vmc_bl_num0_part5_o,mc_vmc_bl_num1_part4_o,mc_vmc_bl_num0_part4_o};
                12'ha8: //register name:mc_vmc_bl_num3_reg,address:0xa8
                prdata <= {mc_vmc_bl_num1_part7_o,mc_vmc_bl_num0_part7_o,mc_vmc_bl_num1_part6_o,mc_vmc_bl_num0_part6_o};
                12'hac: //register name:mc_vmc_bl_num4_reg,address:0xac
                prdata <= {mc_vmc_bl_num1_part9_o,mc_vmc_bl_num0_part9_o,mc_vmc_bl_num1_part8_o,mc_vmc_bl_num0_part8_o};
                12'hb0: //register name:mc_frame2array_dbg_reg,address:0xb0
                prdata <= {ras_clr_o,1'h0,dbg_w_frame_cnt_i,2'h0,dbg_r_frame_cnt_i,3'h0,dbg_refresh_flag_i,2'h0,dbg_r_data_cnt_i,3'h0,dbg_current_state_array_i,3'h0,dbg_next_state_array_i};
                12'hb4: //register name:mc_timeout_clr_reg,address:0xb4
                prdata <= {31'h0,mc_timeout_clr_o};
                12'hb8: //register name:mc_rf_start_dbg_reg,address:0xb8
                prdata <= {31'h0,mc_rf_start_dbg_i};
                12'hbc: //register name:mc_timeout_flag_reg,address:0xbc
                prdata <= {31'h0,mc_timeout_flag_i};
                12'hc0: //register name:mc_bist_status_reg,address:0xc0
                prdata <= {27'h0,dram_init_finish_i,mc_bist_path_fail_i,mc_bist_status_i};
                12'hc4: //register name:bist_finish_reg,address:0xc4
                prdata <= {30'h0,bist_rescan_finish_i,bist_finish_i};
                12'hc8: //register name:bank_success_reg,address:0xc8
                prdata <= {30'h0,bist_rescan_success_i,bank_success_i};
                12'hcc: //register name:err_csl0_reg,address:0xcc
                prdata <= {err_csl1_part1_i,err_csl0_part1_i,err_csl1_part0_i,err_csl0_part0_i};
                12'hd0: //register name:err_csl1_reg,address:0xd0
                prdata <= {err_csl1_part3_i,err_csl0_part3_i,err_csl1_part2_i,err_csl0_part2_i};
                12'hd4: //register name:err_csl2_reg,address:0xd4
                prdata <= {err_csl1_part5_i,err_csl0_part5_i,err_csl1_part4_i,err_csl0_part4_i};
                12'hd8: //register name:err_csl3_reg,address:0xd8
                prdata <= {err_csl1_part7_i,err_csl0_part7_i,err_csl1_part6_i,err_csl0_part6_i};
                12'hdc: //register name:err_csl4_reg,address:0xdc
                prdata <= {err_csl1_part9_i,err_csl0_part9_i,err_csl1_part8_i,err_csl0_part8_i};
                12'he0: //register name:err_wl0_reg,address:0xe0
                prdata <= {3'h0,err_wl1_i,3'h0,err_wl0_i};
                12'he4: //register name:err_wl1_reg,address:0xe4
                prdata <= {3'h0,err_wl3_i,3'h0,err_wl2_i};
                12'he8: //register name:err_wl2_reg,address:0xe8
                prdata <= {3'h0,err_wl5_i,3'h0,err_wl4_i};
                12'hec: //register name:err_wl3_reg,address:0xec
                prdata <= {3'h0,err_wl7_i,3'h0,err_wl6_i};
                12'hf0: //register name:err_wl4_reg,address:0xf0
                prdata <= {3'h0,err_wl9_i,3'h0,err_wl8_i};
                12'hf4: //register name:err_wl5_reg,address:0xf4
                prdata <= {3'h0,err_wl11_i,3'h0,err_wl10_i};
                12'hf8: //register name:err_wl6_reg,address:0xf8
                prdata <= {3'h0,err_wl13_i,3'h0,err_wl12_i};
                12'hfc: //register name:err_wl7_reg,address:0xfc
                prdata <= {3'h0,err_wl15_i,3'h0,err_wl14_i};
                12'h100: //register name:err_wl8_reg,address:0x100
                prdata <= {3'h0,err_wl17_i,3'h0,err_wl16_i};
                12'h104: //register name:err_wl9_reg,address:0x104
                prdata <= {3'h0,err_wl19_i,3'h0,err_wl18_i};
                12'h108: //register name:err_wl10_reg,address:0x108
                prdata <= {3'h0,err_wl21_i,3'h0,err_wl20_i};
                12'h10c: //register name:err_wl11_reg,address:0x10c
                prdata <= {3'h0,err_wl23_i,3'h0,err_wl22_i};
                12'h110: //register name:err_wl12_reg,address:0x110
                prdata <= {3'h0,err_wl25_i,3'h0,err_wl24_i};
                12'h114: //register name:err_wl13_reg,address:0x114
                prdata <= {3'h0,err_wl27_i,3'h0,err_wl26_i};
                12'h118: //register name:err_wl14_reg,address:0x118
                prdata <= {3'h0,err_wl29_i,3'h0,err_wl28_i};
                12'h11c: //register name:err_wl15_reg,address:0x11c
                prdata <= {3'h0,err_wl31_i,3'h0,err_wl30_i};
                12'h120: //register name:err_wl16_reg,address:0x120
                prdata <= {3'h0,err_wl33_i,3'h0,err_wl32_i};
                12'h124: //register name:err_wl17_reg,address:0x124
                prdata <= {3'h0,err_wl35_i,3'h0,err_wl34_i};
                12'h128: //register name:err_wl18_reg,address:0x128
                prdata <= {3'h0,err_wl37_i,3'h0,err_wl36_i};
                12'h12c: //register name:err_wl19_reg,address:0x12c
                prdata <= {3'h0,err_wl39_i,3'h0,err_wl38_i};
                12'h130: //register name:err_wl20_reg,address:0x130
                prdata <= {3'h0,err_wl41_i,3'h0,err_wl40_i};
                12'h134: //register name:err_wl21_reg,address:0x134
                prdata <= {3'h0,err_wl43_i,3'h0,err_wl42_i};
                12'h138: //register name:err_wl22_reg,address:0x138
                prdata <= {3'h0,err_wl45_i,3'h0,err_wl44_i};
                12'h13c: //register name:err_wl23_reg,address:0x13c
                prdata <= {3'h0,err_wl47_i,3'h0,err_wl46_i};
                12'h140: //register name:err_wl24_reg,address:0x140
                prdata <= {3'h0,err_wl49_i,3'h0,err_wl48_i};
                12'h144: //register name:err_wl25_reg,address:0x144
                prdata <= {3'h0,err_wl51_i,3'h0,err_wl50_i};
                12'h148: //register name:err_wl26_reg,address:0x148
                prdata <= {3'h0,err_wl53_i,3'h0,err_wl52_i};
                12'h14c: //register name:err_wl27_reg,address:0x14c
                prdata <= {3'h0,err_wl55_i,3'h0,err_wl54_i};
                12'h150: //register name:err_wl28_reg,address:0x150
                prdata <= {3'h0,err_wl57_i,3'h0,err_wl56_i};
                12'h154: //register name:err_wl29_reg,address:0x154
                prdata <= {3'h0,err_wl59_i,3'h0,err_wl58_i};
                12'h158: //register name:err_wl30_reg,address:0x158
                prdata <= {3'h0,err_wl61_i,3'h0,err_wl60_i};
                12'h15c: //register name:err_wl31_reg,address:0x15c
                prdata <= {3'h0,err_wl63_i,3'h0,err_wl62_i};
                12'h160: //register name:bist_finish_clr_reg,address:0x160
                prdata <= {31'h0,bist_finish_clr_o};
                12'h164: //register name:bist_finish_mask_reg,address:0x164
                prdata <= {31'h0,bist_finish_mask_o};
                12'h168: //register name:hang_timeout_th_reg,address:0x168
                prdata <= {hang_timeout_th_o};
                12'h16c: //register name:mc_bist_rescan_fail_num_reg,address:0x16c
                prdata <= {12'h0,mc_bist_rescan_fail_num_i};
                12'h170: //register name:mc_bist_err_wl_reg,address:0x170
                prdata <= {24'h0,err_wl_num_change_flag_i,mc_bist_err_wl_num_i};
                12'h174: //register name:rescan_finish_clr_reg,address:0x174
                prdata <= {31'h0,rescan_finish_clr_o};
                12'h178: //register name:rescan_finish_mask_reg,address:0x178
                prdata <= {31'h0,rescan_finish_mask_o};
                12'h17c: //register name:rescan_round_result_reg,address:0x17c
                prdata <= {17'h0,rescan_round_result_i};
                12'h180: //register name:dbg_frame_store_0_reg,address:0x180
                prdata <= {dbg_frame_store_0_i};
                12'h184: //register name:dbg_frame_store_1_reg,address:0x184
                prdata <= {dbg_frame_store_1_i};
                12'h188: //register name:dbg_frame_store_2_reg,address:0x188
                prdata <= {dbg_frame_store_2_i};
                12'h18c: //register name:dbg_frame_store_3_reg,address:0x18c
                prdata <= {dbg_frame_store_3_i};
                12'h190: //register name:dbg_frame_store_4_reg,address:0x190
                prdata <= {dbg_frame_store_4_i};
                12'h194: //register name:dbg_frame_store_5_reg,address:0x194
                prdata <= {dbg_frame_store_5_i};
                12'h198: //register name:dbg_frame_store_6_reg,address:0x198
                prdata <= {dbg_frame_store_6_i};
                12'h19c: //register name:dbg_frame_store_7_reg,address:0x19c
                prdata <= {dbg_frame_store_7_i};
                12'h1a0: //register name:dbg_frame_store_8_reg,address:0x1a0
                prdata <= {dbg_frame_store_8_i};
                12'h1a4: //register name:dbg_frame_store_9_reg,address:0x1a4
                prdata <= {30'h0,dbg_frame_store_9_i};
                12'h1a8: //register name:dbg_rdata_store_0_reg,address:0x1a8
                prdata <= {dbg_rdata_store_0_i};
                12'h1ac: //register name:dbg_rdata_store_1_reg,address:0x1ac
                prdata <= {dbg_rdata_store_1_i};
                12'h1b0: //register name:dbg_rdata_store_2_reg,address:0x1b0
                prdata <= {dbg_rdata_store_2_i};
                12'h1b4: //register name:dbg_rdata_store_3_reg,address:0x1b4
                prdata <= {dbg_rdata_store_3_i};
                12'h1b8: //register name:dbg_rdata_store_4_reg,address:0x1b8
                prdata <= {dbg_rdata_store_4_i};
                12'h1bc: //register name:dbg_rdata_store_5_reg,address:0x1bc
                prdata <= {dbg_rdata_store_5_i};
                12'h1c0: //register name:dbg_rdata_store_6_reg,address:0x1c0
                prdata <= {dbg_rdata_store_6_i};
                12'h1c4: //register name:dbg_rdata_store_7_reg,address:0x1c4
                prdata <= {dbg_rdata_store_7_i};
                12'h1c8: //register name:dbg_rdata_store_8_reg,address:0x1c8
                prdata <= {22'h0,dbg_rdata_store_8_i};
                12'h1cc: //register name:bist_pattern_reg0_reg,address:0x1cc
                prdata <= {bist_pattern_reg0_o};
                12'h1d0: //register name:bist_pattern_reg1_reg,address:0x1d0
                prdata <= {bist_pattern_reg1_o};
                12'h1d4: //register name:bist_pattern_reg2_reg,address:0x1d4
                prdata <= {bist_pattern_reg2_o};
                12'h1d8: //register name:bist_pattern_reg3_reg,address:0x1d8
                prdata <= {bist_pattern_reg3_o};
                12'h1dc: //register name:csl_bist_pattern_sel0_reg,address:0x1dc
                prdata <= {csl_bist_pattern_sel0_o};
                12'h1e0: //register name:csl_bist_pattern_sel1_reg,address:0x1e0
                prdata <= {csl_bist_pattern_sel1_o};
                12'h1e4: //register name:csl_bist_pattern_sel2_reg,address:0x1e4
                prdata <= {28'h0,csl_bist_pattern_sel2_o};
                12'h1e8: //register name:wl_bist_pattern_sel0_reg,address:0x1e8
                prdata <= {wl_bist_pattern_sel0_o};
                12'h1ec: //register name:wl_bist_pattern_sel1_reg,address:0x1ec
                prdata <= {wl_bist_pattern_sel1_o};
                12'h1f0: //register name:wl_bist_pattern_sel2_reg,address:0x1f0
                prdata <= {28'h0,wl_bist_pattern_sel2_o};
                12'h1f4: //register name:mc_ecc_ctrl_reg,address:0x1f4
                prdata <= {3'h0,mc_ecc_uce_int_mask_o,3'h0,mc_ecc_uce_int_clr_o,3'h0,mc_ecc_ce_int_mask_o,3'h0,mc_ecc_ce_int_clr_o,7'h0,mc_ecc_ce_th_o,3'h0,mc_ecc_en_o};
                12'h1f8: //register name:mc_ecc_int_status_reg,address:0x1f8
                prdata <= {19'h0,mc_ecc_ce_cnt_i,3'h0,mc_ecc_uce_int_status_i,3'h0,mc_ecc_ce_int_status_i};
                12'h1fc: //register name:mc_ecc_ce_addr0_reg,address:0x1fc
                prdata <= {mc_ecc_ce_addr0_i};
                12'h200: //register name:mc_ecc_ce_addr1_reg,address:0x200
                prdata <= {mc_ecc_ce_addr1_i};
                12'h204: //register name:mc_ecc_ce_addr2_reg,address:0x204
                prdata <= {mc_ecc_ce_addr2_i};
                12'h208: //register name:mc_ecc_ce_addr3_reg,address:0x208
                prdata <= {mc_ecc_ce_addr3_i};
                12'h20c: //register name:mc_ecc_ce_addr4_reg,address:0x20c
                prdata <= {mc_ecc_ce_addr4_i};
                12'h210: //register name:mc_ecc_ce_addr5_reg,address:0x210
                prdata <= {mc_ecc_ce_addr5_i};
                12'h214: //register name:mc_ecc_ce_addr6_reg,address:0x214
                prdata <= {mc_ecc_ce_addr6_i};
                12'h218: //register name:mc_ecc_ce_addr7_reg,address:0x218
                prdata <= {mc_ecc_ce_addr7_i};
                12'h21c: //register name:mc_ecc_ce_addr8_reg,address:0x21c
                prdata <= {mc_ecc_ce_addr8_i};
                12'h220: //register name:mc_ecc_ce_addr9_reg,address:0x220
                prdata <= {mc_ecc_ce_addr9_i};
                12'h224: //register name:mc_ecc_ce_addr10_reg,address:0x224
                prdata <= {mc_ecc_ce_addr10_i};
                12'h228: //register name:mc_ecc_ce_addr11_reg,address:0x228
                prdata <= {mc_ecc_ce_addr11_i};
                12'h22c: //register name:mc_ecc_ce_addr12_reg,address:0x22c
                prdata <= {mc_ecc_ce_addr12_i};
                12'h230: //register name:mc_ecc_ce_addr13_reg,address:0x230
                prdata <= {mc_ecc_ce_addr13_i};
                12'h234: //register name:mc_ecc_ce_addr14_reg,address:0x234
                prdata <= {mc_ecc_ce_addr14_i};
                12'h238: //register name:mc_ecc_ce_addr15_reg,address:0x238
                prdata <= {mc_ecc_ce_addr15_i};
                12'h23c: //register name:mc_ecc_uce_addr0_reg,address:0x23c
                prdata <= {mc_ecc_uce_addr0_i};
                12'h240: //register name:mc_ecc_uce_addr1_reg,address:0x240
                prdata <= {mc_ecc_uce_addr1_i};
                12'h244: //register name:mc_ecc_uce_addr2_reg,address:0x244
                prdata <= {mc_ecc_uce_addr2_i};
                12'h248: //register name:mc_ecc_uce_addr3_reg,address:0x248
                prdata <= {mc_ecc_uce_addr3_i};
                12'h24c: //register name:bist_scan_ctrl_reg,address:0x24c
                prdata <= {27'h0,bist_scan_end_bank_o,3'h0,bist_scan_start_bank_o};
                12'h250: //register name:axi2frame_dbg0_reg,address:0x250
                prdata <= {a2f_dbg_ar_cnt_i};
                12'h254: //register name:axi2frame_dbg1_reg,address:0x254
                prdata <= {a2f_dbg_r_cnt_i};
                12'h258: //register name:axi2frame_dbg2_reg,address:0x258
                prdata <= {a2f_dbg_aw_cnt_i};
                12'h25c: //register name:axi2frame_dbg3_reg,address:0x25c
                prdata <= {a2f_dbg_w_cnt_i};
                12'h260: //register name:axi2frame_dbg4_reg,address:0x260
                prdata <= {a2f_dbg_b_cnt_i};
                12'h264: //register name:axi2frame_dbg5_reg,address:0x264
                prdata <= {a2f_dbg_axi_len_err_addr_i};
                12'h268: //register name:axi2frame_dbg6_reg,address:0x268
                prdata <= {31'h0,a2f_dbg_axi_len_err_i};
                12'h26c: //register name:axi2frame_dbg7_reg,address:0x26c
                prdata <= {a2f_dbg_reserve_in_o};
                12'h270: //register name:axi2frame_dbg8_reg,address:0x270
                prdata <= {a2f_dbg_reserve_out_i};
                12'h274: //register name:mc_page_status_reg,address:0x274
                prdata <= {31'h0,mc_page_status_i};
                12'h278: //register name:hang_timeout_status_reg,address:0x278
                prdata <= {31'h0,hang_timeout_status_i};
                12'h27c: //register name:hang_timeout_mask_reg,address:0x27c
                prdata <= {31'h0,hang_timeout_mask_o};
                12'h280: //register name:hang_timeout_clr_reg,address:0x280
                prdata <= {31'h0,hang_timeout_clr_o};
                12'h284: //register name:hang_timeout_en_reg,address:0x284
                prdata <= {31'h0,hang_timeout_en_o};
                12'h288: //register name:mc_bank1_vmc_wl_num0_reg,address:0x288
                prdata <= {3'h0,mc_bank1_vmc_wl_num1_o,3'h0,mc_bank1_vmc_wl_num0_o};
                12'h28c: //register name:mc_bank1_vmc_wl_num1_reg,address:0x28c
                prdata <= {3'h0,mc_bank1_vmc_wl_num3_o,3'h0,mc_bank1_vmc_wl_num2_o};
                12'h290: //register name:mc_bank1_vmc_wl_num2_reg,address:0x290
                prdata <= {3'h0,mc_bank1_vmc_wl_num5_o,3'h0,mc_bank1_vmc_wl_num4_o};
                12'h294: //register name:mc_bank1_vmc_wl_num3_reg,address:0x294
                prdata <= {3'h0,mc_bank1_vmc_wl_num7_o,3'h0,mc_bank1_vmc_wl_num6_o};
                12'h298: //register name:mc_bank1_vmc_wl_num4_reg,address:0x298
                prdata <= {3'h0,mc_bank1_vmc_wl_num9_o,3'h0,mc_bank1_vmc_wl_num8_o};
                12'h29c: //register name:mc_bank1_vmc_wl_num5_reg,address:0x29c
                prdata <= {3'h0,mc_bank1_vmc_wl_num11_o,3'h0,mc_bank1_vmc_wl_num10_o};
                12'h2a0: //register name:mc_bank1_vmc_wl_num6_reg,address:0x2a0
                prdata <= {3'h0,mc_bank1_vmc_wl_num13_o,3'h0,mc_bank1_vmc_wl_num12_o};
                12'h2a4: //register name:mc_bank1_vmc_wl_num7_reg,address:0x2a4
                prdata <= {3'h0,mc_bank1_vmc_wl_num15_o,3'h0,mc_bank1_vmc_wl_num14_o};
                12'h2a8: //register name:mc_bank1_vmc_wl_num8_reg,address:0x2a8
                prdata <= {3'h0,mc_bank1_vmc_wl_num17_o,3'h0,mc_bank1_vmc_wl_num16_o};
                12'h2ac: //register name:mc_bank1_vmc_wl_num9_reg,address:0x2ac
                prdata <= {3'h0,mc_bank1_vmc_wl_num19_o,3'h0,mc_bank1_vmc_wl_num18_o};
                12'h2b0: //register name:mc_bank1_vmc_wl_num10_reg,address:0x2b0
                prdata <= {3'h0,mc_bank1_vmc_wl_num21_o,3'h0,mc_bank1_vmc_wl_num20_o};
                12'h2b4: //register name:mc_bank1_vmc_wl_num11_reg,address:0x2b4
                prdata <= {3'h0,mc_bank1_vmc_wl_num23_o,3'h0,mc_bank1_vmc_wl_num22_o};
                12'h2b8: //register name:mc_bank1_vmc_wl_num12_reg,address:0x2b8
                prdata <= {3'h0,mc_bank1_vmc_wl_num25_o,3'h0,mc_bank1_vmc_wl_num24_o};
                12'h2bc: //register name:mc_bank1_vmc_wl_num13_reg,address:0x2bc
                prdata <= {3'h0,mc_bank1_vmc_wl_num27_o,3'h0,mc_bank1_vmc_wl_num26_o};
                12'h2c0: //register name:mc_bank1_vmc_wl_num14_reg,address:0x2c0
                prdata <= {3'h0,mc_bank1_vmc_wl_num29_o,3'h0,mc_bank1_vmc_wl_num28_o};
                12'h2c4: //register name:mc_bank1_vmc_wl_num15_reg,address:0x2c4
                prdata <= {3'h0,mc_bank1_vmc_wl_num31_o,3'h0,mc_bank1_vmc_wl_num30_o};
                12'h2c8: //register name:mc_bank1_vmc_wl_num16_reg,address:0x2c8
                prdata <= {3'h0,mc_bank1_vmc_wl_num33_o,3'h0,mc_bank1_vmc_wl_num32_o};
                12'h2cc: //register name:mc_bank1_vmc_wl_num17_reg,address:0x2cc
                prdata <= {3'h0,mc_bank1_vmc_wl_num35_o,3'h0,mc_bank1_vmc_wl_num34_o};
                12'h2d0: //register name:mc_bank1_vmc_wl_num18_reg,address:0x2d0
                prdata <= {3'h0,mc_bank1_vmc_wl_num37_o,3'h0,mc_bank1_vmc_wl_num36_o};
                12'h2d4: //register name:mc_bank1_vmc_wl_num19_reg,address:0x2d4
                prdata <= {3'h0,mc_bank1_vmc_wl_num39_o,3'h0,mc_bank1_vmc_wl_num38_o};
                12'h2d8: //register name:mc_bank1_vmc_wl_num20_reg,address:0x2d8
                prdata <= {3'h0,mc_bank1_vmc_wl_num41_o,3'h0,mc_bank1_vmc_wl_num40_o};
                12'h2dc: //register name:mc_bank1_vmc_wl_num21_reg,address:0x2dc
                prdata <= {3'h0,mc_bank1_vmc_wl_num43_o,3'h0,mc_bank1_vmc_wl_num42_o};
                12'h2e0: //register name:mc_bank1_vmc_wl_num22_reg,address:0x2e0
                prdata <= {3'h0,mc_bank1_vmc_wl_num45_o,3'h0,mc_bank1_vmc_wl_num44_o};
                12'h2e4: //register name:mc_bank1_vmc_wl_num23_reg,address:0x2e4
                prdata <= {3'h0,mc_bank1_vmc_wl_num47_o,3'h0,mc_bank1_vmc_wl_num46_o};
                12'h2e8: //register name:mc_bank1_vmc_wl_num24_reg,address:0x2e8
                prdata <= {3'h0,mc_bank1_vmc_wl_num49_o,3'h0,mc_bank1_vmc_wl_num48_o};
                12'h2ec: //register name:mc_bank1_vmc_wl_num25_reg,address:0x2ec
                prdata <= {3'h0,mc_bank1_vmc_wl_num51_o,3'h0,mc_bank1_vmc_wl_num50_o};
                12'h2f0: //register name:mc_bank1_vmc_wl_num26_reg,address:0x2f0
                prdata <= {3'h0,mc_bank1_vmc_wl_num53_o,3'h0,mc_bank1_vmc_wl_num52_o};
                12'h2f4: //register name:mc_bank1_vmc_wl_num27_reg,address:0x2f4
                prdata <= {3'h0,mc_bank1_vmc_wl_num55_o,3'h0,mc_bank1_vmc_wl_num54_o};
                12'h2f8: //register name:mc_bank1_vmc_wl_num28_reg,address:0x2f8
                prdata <= {3'h0,mc_bank1_vmc_wl_num57_o,3'h0,mc_bank1_vmc_wl_num56_o};
                12'h2fc: //register name:mc_bank1_vmc_wl_num29_reg,address:0x2fc
                prdata <= {3'h0,mc_bank1_vmc_wl_num59_o,3'h0,mc_bank1_vmc_wl_num58_o};
                12'h300: //register name:mc_bank1_vmc_wl_num30_reg,address:0x300
                prdata <= {3'h0,mc_bank1_vmc_wl_num61_o,3'h0,mc_bank1_vmc_wl_num60_o};
                12'h304: //register name:mc_bank1_vmc_wl_num31_reg,address:0x304
                prdata <= {3'h0,mc_bank1_vmc_wl_num63_o,3'h0,mc_bank1_vmc_wl_num62_o};
                12'h308: //register name:mc_bank1_vmc_bl_num0_reg,address:0x308
                prdata <= {mc_bank1_vmc_bl_num1_part1_o,mc_bank1_vmc_bl_num0_part1_o,mc_bank1_vmc_bl_num1_part0_o,mc_bank1_vmc_bl_num0_part0_o};
                12'h30c: //register name:mc_bank1_vmc_bl_num1_reg,address:0x30c
                prdata <= {mc_bank1_vmc_bl_num1_part3_o,mc_bank1_vmc_bl_num0_part3_o,mc_bank1_vmc_bl_num1_part2_o,mc_bank1_vmc_bl_num0_part2_o};
                12'h310: //register name:mc_bank1_vmc_bl_num2_reg,address:0x310
                prdata <= {mc_bank1_vmc_bl_num1_part5_o,mc_bank1_vmc_bl_num0_part5_o,mc_bank1_vmc_bl_num1_part4_o,mc_bank1_vmc_bl_num0_part4_o};
                12'h314: //register name:mc_bank1_vmc_bl_num3_reg,address:0x314
                prdata <= {mc_bank1_vmc_bl_num1_part7_o,mc_bank1_vmc_bl_num0_part7_o,mc_bank1_vmc_bl_num1_part6_o,mc_bank1_vmc_bl_num0_part6_o};
                12'h318: //register name:mc_bank1_vmc_bl_num4_reg,address:0x318
                prdata <= {mc_bank1_vmc_bl_num1_part9_o,mc_bank1_vmc_bl_num0_part9_o,mc_bank1_vmc_bl_num1_part8_o,mc_bank1_vmc_bl_num0_part8_o};
                12'h31c: //register name:bank1_err_wl_num0_reg,address:0x31c
                prdata <= {3'h0,bank1_err_wl1_i,3'h0,bank1_err_wl0_i};
                12'h320: //register name:bank1_err_wl_num1_reg,address:0x320
                prdata <= {3'h0,bank1_err_wl3_i,3'h0,bank1_err_wl2_i};
                12'h324: //register name:bank1_err_wl_num2_reg,address:0x324
                prdata <= {3'h0,bank1_err_wl5_i,3'h0,bank1_err_wl4_i};
                12'h328: //register name:bank1_err_wl_num3_reg,address:0x328
                prdata <= {3'h0,bank1_err_wl7_i,3'h0,bank1_err_wl6_i};
                12'h32c: //register name:bank1_err_wl_num4_reg,address:0x32c
                prdata <= {3'h0,bank1_err_wl9_i,3'h0,bank1_err_wl8_i};
                12'h330: //register name:bank1_err_wl_num5_reg,address:0x330
                prdata <= {3'h0,bank1_err_wl11_i,3'h0,bank1_err_wl10_i};
                12'h334: //register name:bank1_err_wl_num6_reg,address:0x334
                prdata <= {3'h0,bank1_err_wl13_i,3'h0,bank1_err_wl12_i};
                12'h338: //register name:bank1_err_wl_num7_reg,address:0x338
                prdata <= {3'h0,bank1_err_wl15_i,3'h0,bank1_err_wl14_i};
                12'h33c: //register name:bank1_err_wl_num8_reg,address:0x33c
                prdata <= {3'h0,bank1_err_wl17_i,3'h0,bank1_err_wl16_i};
                12'h340: //register name:bank1_err_wl_num9_reg,address:0x340
                prdata <= {3'h0,bank1_err_wl19_i,3'h0,bank1_err_wl18_i};
                12'h344: //register name:bank1_err_wl_num10_reg,address:0x344
                prdata <= {3'h0,bank1_err_wl21_i,3'h0,bank1_err_wl20_i};
                12'h348: //register name:bank1_err_wl_num11_reg,address:0x348
                prdata <= {3'h0,bank1_err_wl23_i,3'h0,bank1_err_wl22_i};
                12'h34c: //register name:bank1_err_wl_num12_reg,address:0x34c
                prdata <= {3'h0,bank1_err_wl25_i,3'h0,bank1_err_wl24_i};
                12'h350: //register name:bank1_err_wl_num13_reg,address:0x350
                prdata <= {3'h0,bank1_err_wl27_i,3'h0,bank1_err_wl26_i};
                12'h354: //register name:bank1_err_wl_num14_reg,address:0x354
                prdata <= {3'h0,bank1_err_wl29_i,3'h0,bank1_err_wl28_i};
                12'h358: //register name:bank1_err_wl_num15_reg,address:0x358
                prdata <= {3'h0,bank1_err_wl31_i,3'h0,bank1_err_wl30_i};
                12'h35c: //register name:bank1_err_wl_num16_reg,address:0x35c
                prdata <= {3'h0,bank1_err_wl33_i,3'h0,bank1_err_wl32_i};
                12'h360: //register name:bank1_err_wl_num17_reg,address:0x360
                prdata <= {3'h0,bank1_err_wl35_i,3'h0,bank1_err_wl34_i};
                12'h364: //register name:bank1_err_wl_num18_reg,address:0x364
                prdata <= {3'h0,bank1_err_wl37_i,3'h0,bank1_err_wl36_i};
                12'h368: //register name:bank1_err_wl_num19_reg,address:0x368
                prdata <= {3'h0,bank1_err_wl39_i,3'h0,bank1_err_wl38_i};
                12'h36c: //register name:bank1_err_wl_num20_reg,address:0x36c
                prdata <= {3'h0,bank1_err_wl41_i,3'h0,bank1_err_wl40_i};
                12'h370: //register name:bank1_err_wl_num21_reg,address:0x370
                prdata <= {3'h0,bank1_err_wl43_i,3'h0,bank1_err_wl42_i};
                12'h374: //register name:bank1_err_wl_num22_reg,address:0x374
                prdata <= {3'h0,bank1_err_wl45_i,3'h0,bank1_err_wl44_i};
                12'h378: //register name:bank1_err_wl_num23_reg,address:0x378
                prdata <= {3'h0,bank1_err_wl47_i,3'h0,bank1_err_wl46_i};
                12'h37c: //register name:bank1_err_wl_num24_reg,address:0x37c
                prdata <= {3'h0,bank1_err_wl49_i,3'h0,bank1_err_wl48_i};
                12'h380: //register name:bank1_err_wl_num25_reg,address:0x380
                prdata <= {3'h0,bank1_err_wl51_i,3'h0,bank1_err_wl50_i};
                12'h384: //register name:bank1_err_wl_num26_reg,address:0x384
                prdata <= {3'h0,bank1_err_wl53_i,3'h0,bank1_err_wl52_i};
                12'h388: //register name:bank1_err_wl_num27_reg,address:0x388
                prdata <= {3'h0,bank1_err_wl55_i,3'h0,bank1_err_wl54_i};
                12'h38c: //register name:bank1_err_wl_num28_reg,address:0x38c
                prdata <= {3'h0,bank1_err_wl57_i,3'h0,bank1_err_wl56_i};
                12'h390: //register name:bank1_err_wl_num29_reg,address:0x390
                prdata <= {3'h0,bank1_err_wl59_i,3'h0,bank1_err_wl58_i};
                12'h394: //register name:bank1_err_wl_num30_reg,address:0x394
                prdata <= {3'h0,bank1_err_wl61_i,3'h0,bank1_err_wl60_i};
                12'h398: //register name:bank1_err_wl_num31_reg,address:0x398
                prdata <= {3'h0,bank1_err_wl63_i,3'h0,bank1_err_wl62_i};
                12'h39c: //register name:bank1_err_csl_part0_reg,address:0x39c
                prdata <= {bank1_err_csl1_part1_i,bank1_err_csl0_part1_i,bank1_err_csl1_part0_i,bank1_err_csl0_part0_i};
                12'h3a0: //register name:bank1_err_csl_part1_reg,address:0x3a0
                prdata <= {bank1_err_csl1_part3_i,bank1_err_csl0_part3_i,bank1_err_csl1_part2_i,bank1_err_csl0_part2_i};
                12'h3a4: //register name:bank1_err_csl_part2_reg,address:0x3a4
                prdata <= {bank1_err_csl1_part5_i,bank1_err_csl0_part5_i,bank1_err_csl1_part4_i,bank1_err_csl0_part4_i};
                12'h3a8: //register name:bank1_err_csl_part3_reg,address:0x3a8
                prdata <= {bank1_err_csl1_part7_i,bank1_err_csl0_part7_i,bank1_err_csl1_part6_i,bank1_err_csl0_part6_i};
                12'h3ac: //register name:bank1_err_csl_part4_reg,address:0x3ac
                prdata <= {bank1_err_csl1_part9_i,bank1_err_csl0_part9_i,bank1_err_csl1_part8_i,bank1_err_csl0_part8_i};
                12'h3b0: //register name:mc_bank1_bist_rescan_fail_num_reg,address:0x3b0
                prdata <= {12'h0,mc_bank1_bist_rescan_fail_num_i};
                12'h3b4: //register name:mc_bank1_bist_err_wl_reg,address:0x3b4
                prdata <= {24'h0,err_bank1_wl_num_change_flag_i,mc_bank1_bist_err_wl_num_i};
                12'h3b8: //register name:bank1_rescan_round_result_reg,address:0x3b8
                prdata <= {17'h0,bank1_rescan_round_result_i};
            default:
                prdata <= {APB_DATA_WIDTH{1'b1}}; //  means read a non-exist address
            endcase
        end
        else begin
            prdata <= {APB_DATA_WIDTH{1'b0}};
        end
    end
    // register name : mc_frame2array_dbg_reg , address:0xb0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            ras_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 12'hb0)) begin
            ras_clr_o <= pwdata[31];
        end
        else
            ras_clr_o <= 1'b0;

    end
    // register name : mc_timeout_clr_reg , address:0xb4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_timeout_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 12'hb4)) begin
            mc_timeout_clr_o <= pwdata[0];
        end
        else
            mc_timeout_clr_o <= 1'b0;

    end
    // register name : bist_finish_clr_reg , address:0x160
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            bist_finish_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 12'h160)) begin
            bist_finish_clr_o <= pwdata[0];
        end
        else
            bist_finish_clr_o <= 1'b0;

    end
    // register name : rescan_finish_clr_reg , address:0x174
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            rescan_finish_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 12'h174)) begin
            rescan_finish_clr_o <= pwdata[0];
        end
        else
            rescan_finish_clr_o <= 1'b0;

    end
    // register name : mc_ecc_ctrl_reg , address:0x1f4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_ecc_ce_int_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 12'h1f4)) begin
            mc_ecc_ce_int_clr_o <= pwdata[16];
        end
        else
            mc_ecc_ce_int_clr_o <= 1'b0;

    end
    // register name : mc_ecc_ctrl_reg , address:0x1f4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            mc_ecc_uce_int_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 12'h1f4)) begin
            mc_ecc_uce_int_clr_o <= pwdata[24];
        end
        else
            mc_ecc_uce_int_clr_o <= 1'b0;

    end
    // register name : hang_timeout_clr_reg , address:0x280
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 12'h280)) begin
            hang_timeout_clr_o <= pwdata[0];
        end
        else
            hang_timeout_clr_o <= 1'b0;

    end
endmodule
// Below is the information of "mc_wrapper" in register sheet, can use as a reference if have unexpected issues in this verilog file.
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
// 0x4___(mc_work_ctrl_reg)___(reserved)___10___22___NA___0x0
// 0x8___(phy_timing_cfg0_reg)___(bank_radd_set_time)___0___4___RW___0x0
// 0x8___(phy_timing_cfg0_reg)___(cadd_set_time)___4___4___RW___0x0
// 0x8___(phy_timing_cfg0_reg)___(r_cas_set_time)___8___8___RW___0x0
// 0x8___(phy_timing_cfg0_reg)___(w_cas_set_time)___16___8___RW___0x0
// 0x8___(phy_timing_cfg0_reg)___(cas_wrrdy_time)___24___8___RW___0x0
// 0xc___(mc_rf_period_cfg1_reg)___(mc_rf_period_1)___0___32___RW___0x186A000
// 0x10___(mc_rf_start_cfg1_reg)___(mc_rf_start_1)___0___32___RW___0xFFFFFFFF
// 0x14___(mc_rf_period_cfg2_reg)___(mc_rf_period_2)___0___32___RW___0x186A000
// 0x18___(mc_rf_start_cfg2_reg)___(mc_rf_start_2)___0___32___RW___0xFFFFFFFF
// 0x1c___(mc_vmc_wl_num0_reg)___(mc_vmc_wl_num0)___0___13___RW___0x1FFF
// 0x1c___(mc_vmc_wl_num0_reg)___(reserved)___13___3___NA___NA
// 0x1c___(mc_vmc_wl_num0_reg)___(mc_vmc_wl_num1)___16___13___RW___0x1FFF
// 0x1c___(mc_vmc_wl_num0_reg)___(reserved)___29___3___NA___NA
// 0x20___(mc_vmc_wl_num1_reg)___(mc_vmc_wl_num2)___0___13___RW___0x1FFF
// 0x20___(mc_vmc_wl_num1_reg)___(reserved)___13___3___NA___NA
// 0x20___(mc_vmc_wl_num1_reg)___(mc_vmc_wl_num3)___16___13___RW___0x1FFF
// 0x20___(mc_vmc_wl_num1_reg)___(reserved)___29___3___NA___NA
// 0x24___(mc_vmc_wl_num2_reg)___(mc_vmc_wl_num4)___0___13___RW___0x1FFF
// 0x24___(mc_vmc_wl_num2_reg)___(reserved)___13___3___NA___NA
// 0x24___(mc_vmc_wl_num2_reg)___(mc_vmc_wl_num5)___16___13___RW___0x1FFF
// 0x24___(mc_vmc_wl_num2_reg)___(reserved)___29___3___NA___NA
// 0x28___(mc_vmc_wl_num3_reg)___(mc_vmc_wl_num6)___0___13___RW___0x1FFF
// 0x28___(mc_vmc_wl_num3_reg)___(reserved)___13___3___NA___NA
// 0x28___(mc_vmc_wl_num3_reg)___(mc_vmc_wl_num7)___16___13___RW___0x1FFF
// 0x28___(mc_vmc_wl_num3_reg)___(reserved)___29___3___NA___NA
// 0x2c___(mc_vmc_wl_num4_reg)___(mc_vmc_wl_num8)___0___13___RW___0x1FFF
// 0x2c___(mc_vmc_wl_num4_reg)___(reserved)___13___3___NA___NA
// 0x2c___(mc_vmc_wl_num4_reg)___(mc_vmc_wl_num9)___16___13___RW___0x1FFF
// 0x2c___(mc_vmc_wl_num4_reg)___(reserved)___29___3___NA___NA
// 0x30___(mc_vmc_wl_num5_reg)___(mc_vmc_wl_num10)___0___13___RW___0x1FFF
// 0x30___(mc_vmc_wl_num5_reg)___(reserved)___13___3___NA___NA
// 0x30___(mc_vmc_wl_num5_reg)___(mc_vmc_wl_num11)___16___13___RW___0x1FFF
// 0x30___(mc_vmc_wl_num5_reg)___(reserved)___29___3___NA___NA
// 0x34___(mc_vmc_wl_num6_reg)___(mc_vmc_wl_num12)___0___13___RW___0x1FFF
// 0x34___(mc_vmc_wl_num6_reg)___(reserved)___13___3___NA___NA
// 0x34___(mc_vmc_wl_num6_reg)___(mc_vmc_wl_num13)___16___13___RW___0x1FFF
// 0x34___(mc_vmc_wl_num6_reg)___(reserved)___29___3___NA___NA
// 0x38___(mc_vmc_wl_num7_reg)___(mc_vmc_wl_num14)___0___13___RW___0x1FFF
// 0x38___(mc_vmc_wl_num7_reg)___(reserved)___13___3___NA___NA
// 0x38___(mc_vmc_wl_num7_reg)___(mc_vmc_wl_num15)___16___13___RW___0x1FFF
// 0x38___(mc_vmc_wl_num7_reg)___(reserved)___29___3___NA___NA
// 0x3c___(mc_vmc_wl_num8_reg)___(mc_vmc_wl_num16)___0___13___RW___0x1FFF
// 0x3c___(mc_vmc_wl_num8_reg)___(reserved)___13___3___NA___NA
// 0x3c___(mc_vmc_wl_num8_reg)___(mc_vmc_wl_num17)___16___13___RW___0x1FFF
// 0x3c___(mc_vmc_wl_num8_reg)___(reserved)___29___3___NA___NA
// 0x40___(mc_vmc_wl_num9_reg)___(mc_vmc_wl_num18)___0___13___RW___0x1FFF
// 0x40___(mc_vmc_wl_num9_reg)___(reserved)___13___3___NA___NA
// 0x40___(mc_vmc_wl_num9_reg)___(mc_vmc_wl_num19)___16___13___RW___0x1FFF
// 0x40___(mc_vmc_wl_num9_reg)___(reserved)___29___3___NA___NA
// 0x44___(mc_vmc_wl_num10_reg)___(mc_vmc_wl_num20)___0___13___RW___0x1FFF
// 0x44___(mc_vmc_wl_num10_reg)___(reserved)___13___3___NA___NA
// 0x44___(mc_vmc_wl_num10_reg)___(mc_vmc_wl_num21)___16___13___RW___0x1FFF
// 0x44___(mc_vmc_wl_num10_reg)___(reserved)___29___3___NA___NA
// 0x48___(mc_vmc_wl_num11_reg)___(mc_vmc_wl_num22)___0___13___RW___0x1FFF
// 0x48___(mc_vmc_wl_num11_reg)___(reserved)___13___3___NA___NA
// 0x48___(mc_vmc_wl_num11_reg)___(mc_vmc_wl_num23)___16___13___RW___0x1FFF
// 0x48___(mc_vmc_wl_num11_reg)___(reserved)___29___3___NA___NA
// 0x4c___(mc_vmc_wl_num12_reg)___(mc_vmc_wl_num24)___0___13___RW___0x1FFF
// 0x4c___(mc_vmc_wl_num12_reg)___(reserved)___13___3___NA___NA
// 0x4c___(mc_vmc_wl_num12_reg)___(mc_vmc_wl_num25)___16___13___RW___0x1FFF
// 0x4c___(mc_vmc_wl_num12_reg)___(reserved)___29___3___NA___NA
// 0x50___(mc_vmc_wl_num13_reg)___(mc_vmc_wl_num26)___0___13___RW___0x1FFF
// 0x50___(mc_vmc_wl_num13_reg)___(reserved)___13___3___NA___NA
// 0x50___(mc_vmc_wl_num13_reg)___(mc_vmc_wl_num27)___16___13___RW___0x1FFF
// 0x50___(mc_vmc_wl_num13_reg)___(reserved)___29___3___NA___NA
// 0x54___(mc_vmc_wl_num14_reg)___(mc_vmc_wl_num28)___0___13___RW___0x1FFF
// 0x54___(mc_vmc_wl_num14_reg)___(reserved)___13___3___NA___NA
// 0x54___(mc_vmc_wl_num14_reg)___(mc_vmc_wl_num29)___16___13___RW___0x1FFF
// 0x54___(mc_vmc_wl_num14_reg)___(reserved)___29___3___NA___NA
// 0x58___(mc_vmc_wl_num15_reg)___(mc_vmc_wl_num30)___0___13___RW___0x1FFF
// 0x58___(mc_vmc_wl_num15_reg)___(reserved)___13___3___NA___NA
// 0x58___(mc_vmc_wl_num15_reg)___(mc_vmc_wl_num31)___16___13___RW___0x1FFF
// 0x58___(mc_vmc_wl_num15_reg)___(reserved)___29___3___NA___NA
// 0x5c___(mc_vmc_wl_num16_reg)___(mc_vmc_wl_num32)___0___13___RW___0x1FFF
// 0x5c___(mc_vmc_wl_num16_reg)___(reserved)___13___3___NA___NA
// 0x5c___(mc_vmc_wl_num16_reg)___(mc_vmc_wl_num33)___16___13___RW___0x1FFF
// 0x5c___(mc_vmc_wl_num16_reg)___(reserved)___29___3___NA___NA
// 0x60___(mc_vmc_wl_num17_reg)___(mc_vmc_wl_num34)___0___13___RW___0x1FFF
// 0x60___(mc_vmc_wl_num17_reg)___(reserved)___13___3___NA___NA
// 0x60___(mc_vmc_wl_num17_reg)___(mc_vmc_wl_num35)___16___13___RW___0x1FFF
// 0x60___(mc_vmc_wl_num17_reg)___(reserved)___29___3___NA___NA
// 0x64___(mc_vmc_wl_num18_reg)___(mc_vmc_wl_num36)___0___13___RW___0x1FFF
// 0x64___(mc_vmc_wl_num18_reg)___(reserved)___13___3___NA___NA
// 0x64___(mc_vmc_wl_num18_reg)___(mc_vmc_wl_num37)___16___13___RW___0x1FFF
// 0x64___(mc_vmc_wl_num18_reg)___(reserved)___29___3___NA___NA
// 0x68___(mc_vmc_wl_num19_reg)___(mc_vmc_wl_num38)___0___13___RW___0x1FFF
// 0x68___(mc_vmc_wl_num19_reg)___(reserved)___13___3___NA___NA
// 0x68___(mc_vmc_wl_num19_reg)___(mc_vmc_wl_num39)___16___13___RW___0x1FFF
// 0x68___(mc_vmc_wl_num19_reg)___(reserved)___29___3___NA___NA
// 0x6c___(mc_vmc_wl_num20_reg)___(mc_vmc_wl_num40)___0___13___RW___0x1FFF
// 0x6c___(mc_vmc_wl_num20_reg)___(reserved)___13___3___NA___NA
// 0x6c___(mc_vmc_wl_num20_reg)___(mc_vmc_wl_num41)___16___13___RW___0x1FFF
// 0x6c___(mc_vmc_wl_num20_reg)___(reserved)___29___3___NA___NA
// 0x70___(mc_vmc_wl_num21_reg)___(mc_vmc_wl_num42)___0___13___RW___0x1FFF
// 0x70___(mc_vmc_wl_num21_reg)___(reserved)___13___3___NA___NA
// 0x70___(mc_vmc_wl_num21_reg)___(mc_vmc_wl_num43)___16___13___RW___0x1FFF
// 0x70___(mc_vmc_wl_num21_reg)___(reserved)___29___3___NA___NA
// 0x74___(mc_vmc_wl_num22_reg)___(mc_vmc_wl_num44)___0___13___RW___0x1FFF
// 0x74___(mc_vmc_wl_num22_reg)___(reserved)___13___3___NA___NA
// 0x74___(mc_vmc_wl_num22_reg)___(mc_vmc_wl_num45)___16___13___RW___0x1FFF
// 0x74___(mc_vmc_wl_num22_reg)___(reserved)___29___3___NA___NA
// 0x78___(mc_vmc_wl_num23_reg)___(mc_vmc_wl_num46)___0___13___RW___0x1FFF
// 0x78___(mc_vmc_wl_num23_reg)___(reserved)___13___3___NA___NA
// 0x78___(mc_vmc_wl_num23_reg)___(mc_vmc_wl_num47)___16___13___RW___0x1FFF
// 0x78___(mc_vmc_wl_num23_reg)___(reserved)___29___3___NA___NA
// 0x7c___(mc_vmc_wl_num24_reg)___(mc_vmc_wl_num48)___0___13___RW___0x1FFF
// 0x7c___(mc_vmc_wl_num24_reg)___(reserved)___13___3___NA___NA
// 0x7c___(mc_vmc_wl_num24_reg)___(mc_vmc_wl_num49)___16___13___RW___0x1FFF
// 0x7c___(mc_vmc_wl_num24_reg)___(reserved)___29___3___NA___NA
// 0x80___(mc_vmc_wl_num25_reg)___(mc_vmc_wl_num50)___0___13___RW___0x1FFF
// 0x80___(mc_vmc_wl_num25_reg)___(reserved)___13___3___NA___NA
// 0x80___(mc_vmc_wl_num25_reg)___(mc_vmc_wl_num51)___16___13___RW___0x1FFF
// 0x80___(mc_vmc_wl_num25_reg)___(reserved)___29___3___NA___NA
// 0x84___(mc_vmc_wl_num26_reg)___(mc_vmc_wl_num52)___0___13___RW___0x1FFF
// 0x84___(mc_vmc_wl_num26_reg)___(reserved)___13___3___NA___NA
// 0x84___(mc_vmc_wl_num26_reg)___(mc_vmc_wl_num53)___16___13___RW___0x1FFF
// 0x84___(mc_vmc_wl_num26_reg)___(reserved)___29___3___NA___NA
// 0x88___(mc_vmc_wl_num27_reg)___(mc_vmc_wl_num54)___0___13___RW___0x1FFF
// 0x88___(mc_vmc_wl_num27_reg)___(reserved)___13___3___NA___NA
// 0x88___(mc_vmc_wl_num27_reg)___(mc_vmc_wl_num55)___16___13___RW___0x1FFF
// 0x88___(mc_vmc_wl_num27_reg)___(reserved)___29___3___NA___NA
// 0x8c___(mc_vmc_wl_num28_reg)___(mc_vmc_wl_num56)___0___13___RW___0x1FFF
// 0x8c___(mc_vmc_wl_num28_reg)___(reserved)___13___3___NA___NA
// 0x8c___(mc_vmc_wl_num28_reg)___(mc_vmc_wl_num57)___16___13___RW___0x1FFF
// 0x8c___(mc_vmc_wl_num28_reg)___(reserved)___29___3___NA___NA
// 0x90___(mc_vmc_wl_num29_reg)___(mc_vmc_wl_num58)___0___13___RW___0x1FFF
// 0x90___(mc_vmc_wl_num29_reg)___(reserved)___13___3___NA___NA
// 0x90___(mc_vmc_wl_num29_reg)___(mc_vmc_wl_num59)___16___13___RW___0x1FFF
// 0x90___(mc_vmc_wl_num29_reg)___(reserved)___29___3___NA___NA
// 0x94___(mc_vmc_wl_num30_reg)___(mc_vmc_wl_num60)___0___13___RW___0x1FFF
// 0x94___(mc_vmc_wl_num30_reg)___(reserved)___13___3___NA___NA
// 0x94___(mc_vmc_wl_num30_reg)___(mc_vmc_wl_num61)___16___13___RW___0x1FFF
// 0x94___(mc_vmc_wl_num30_reg)___(reserved)___29___3___NA___NA
// 0x98___(mc_vmc_wl_num31_reg)___(mc_vmc_wl_num62)___0___13___RW___0x1FFF
// 0x98___(mc_vmc_wl_num31_reg)___(reserved)___13___3___NA___NA
// 0x98___(mc_vmc_wl_num31_reg)___(mc_vmc_wl_num63)___16___13___RW___0x1FFF
// 0x98___(mc_vmc_wl_num31_reg)___(reserved)___29___3___NA___NA
// 0x9c___(mc_vmc_bl_num0_reg)___(mc_vmc_bl_num0_part0)___0___8___RW___0xFF
// 0x9c___(mc_vmc_bl_num0_reg)___(mc_vmc_bl_num1_part0)___8___8___RW___0xFF
// 0x9c___(mc_vmc_bl_num0_reg)___(mc_vmc_bl_num0_part1)___16___8___RW___0xFF
// 0x9c___(mc_vmc_bl_num0_reg)___(mc_vmc_bl_num1_part1)___24___8___RW___0xFF
// 0xa0___(mc_vmc_bl_num1_reg)___(mc_vmc_bl_num0_part2)___0___8___RW___0xFF
// 0xa0___(mc_vmc_bl_num1_reg)___(mc_vmc_bl_num1_part2)___8___8___RW___0xFF
// 0xa0___(mc_vmc_bl_num1_reg)___(mc_vmc_bl_num0_part3)___16___8___RW___0xFF
// 0xa0___(mc_vmc_bl_num1_reg)___(mc_vmc_bl_num1_part3)___24___8___RW___0xFF
// 0xa4___(mc_vmc_bl_num2_reg)___(mc_vmc_bl_num0_part4)___0___8___RW___0xFF
// 0xa4___(mc_vmc_bl_num2_reg)___(mc_vmc_bl_num1_part4)___8___8___RW___0xFF
// 0xa4___(mc_vmc_bl_num2_reg)___(mc_vmc_bl_num0_part5)___16___8___RW___0xFF
// 0xa4___(mc_vmc_bl_num2_reg)___(mc_vmc_bl_num1_part5)___24___8___RW___0xFF
// 0xa8___(mc_vmc_bl_num3_reg)___(mc_vmc_bl_num0_part6)___0___8___RW___0xFF
// 0xa8___(mc_vmc_bl_num3_reg)___(mc_vmc_bl_num1_part6)___8___8___RW___0xFF
// 0xa8___(mc_vmc_bl_num3_reg)___(mc_vmc_bl_num0_part7)___16___8___RW___0xFF
// 0xa8___(mc_vmc_bl_num3_reg)___(mc_vmc_bl_num1_part7)___24___8___RW___0xFF
// 0xac___(mc_vmc_bl_num4_reg)___(mc_vmc_bl_num0_part8)___0___8___RW___0xFF
// 0xac___(mc_vmc_bl_num4_reg)___(mc_vmc_bl_num1_part8)___8___8___RW___0xFF
// 0xac___(mc_vmc_bl_num4_reg)___(mc_vmc_bl_num0_part9)___16___8___RW___0xFF
// 0xac___(mc_vmc_bl_num4_reg)___(mc_vmc_bl_num1_part9)___24___8___RW___0xFF
// 0xb0___(mc_frame2array_dbg_reg)___(dbg_next_state_array)___0___5___RO___0x0
// 0xb0___(mc_frame2array_dbg_reg)___(reserved)___5___3___NA___NA
// 0xb0___(mc_frame2array_dbg_reg)___(dbg_current_state_array)___8___5___RO___0x0
// 0xb0___(mc_frame2array_dbg_reg)___(reserved)___13___3___NA___NA
// 0xb0___(mc_frame2array_dbg_reg)___(dbg_r_data_cnt)___16___2___RO___0x0
// 0xb0___(mc_frame2array_dbg_reg)___(reserved)___18___2___NA___NA
// 0xb0___(mc_frame2array_dbg_reg)___(dbg_refresh_flag)___20___1___RO___0x0
// 0xb0___(mc_frame2array_dbg_reg)___(reserved)___21___3___NA___NA
// 0xb0___(mc_frame2array_dbg_reg)___(dbg_r_frame_cnt)___24___2___RO___0x0
// 0xb0___(mc_frame2array_dbg_reg)___(reserved)___26___2___NA___NA
// 0xb0___(mc_frame2array_dbg_reg)___(dbg_w_frame_cnt)___28___2___RO___0x0
// 0xb0___(mc_frame2array_dbg_reg)___(reserved)___30___1___NA___NA
// 0xb0___(mc_frame2array_dbg_reg)___(ras_clr)___31___1___W1C___0x0
// 0xb4___(mc_timeout_clr_reg)___(mc_timeout_clr)___0___1___W1C___0x0
// 0xb4___(mc_timeout_clr_reg)___(reserved)___1___31___NA___NA
// 0xb8___(mc_rf_start_dbg_reg)___(mc_rf_start_dbg)___0___1___RO___0x0
// 0xb8___(mc_rf_start_dbg_reg)___(reserved)___1___31___NA___NA
// 0xbc___(mc_timeout_flag_reg)___(mc_timeout_flag)___0___1___RO___0x0
// 0xbc___(mc_timeout_flag_reg)___(reserved)___1___31___NA___NA
// 0xc0___(mc_bist_status_reg)___(mc_bist_status)___0___3___RO___0x0
// 0xc0___(mc_bist_status_reg)___(mc_bist_path_fail)___3___1___RO___0x0
// 0xc0___(mc_bist_status_reg)___(dram_init_finish)___4___1___RO___0x0
// 0xc0___(mc_bist_status_reg)___(reserved)___5___27___NA___NA
// 0xc4___(bist_finish_reg)___(bist_finish)___0___1___RO___0x0
// 0xc4___(bist_finish_reg)___(bist_rescan_finish)___1___1___RO___0x0
// 0xc4___(bist_finish_reg)___(reserved)___2___30___NA___NA
// 0xc8___(bank_success_reg)___(bank_success)___0___1___RO___0x0
// 0xc8___(bank_success_reg)___(bist_rescan_success)___1___1___RO___0x0
// 0xc8___(bank_success_reg)___(reserved)___2___30___NA___NA
// 0xcc___(err_csl0_reg)___(err_csl0_part0)___0___8___RO___0xFF
// 0xcc___(err_csl0_reg)___(err_csl1_part0)___8___8___RO___0xFF
// 0xcc___(err_csl0_reg)___(err_csl0_part1)___16___8___RO___0xFF
// 0xcc___(err_csl0_reg)___(err_csl1_part1)___24___8___RO___0xFF
// 0xd0___(err_csl1_reg)___(err_csl0_part2)___0___8___RO___0xFF
// 0xd0___(err_csl1_reg)___(err_csl1_part2)___8___8___RO___0xFF
// 0xd0___(err_csl1_reg)___(err_csl0_part3)___16___8___RO___0xFF
// 0xd0___(err_csl1_reg)___(err_csl1_part3)___24___8___RO___0xFF
// 0xd4___(err_csl2_reg)___(err_csl0_part4)___0___8___RO___0xFF
// 0xd4___(err_csl2_reg)___(err_csl1_part4)___8___8___RO___0xFF
// 0xd4___(err_csl2_reg)___(err_csl0_part5)___16___8___RO___0xFF
// 0xd4___(err_csl2_reg)___(err_csl1_part5)___24___8___RO___0xFF
// 0xd8___(err_csl3_reg)___(err_csl0_part6)___0___8___RO___0xFF
// 0xd8___(err_csl3_reg)___(err_csl1_part6)___8___8___RO___0xFF
// 0xd8___(err_csl3_reg)___(err_csl0_part7)___16___8___RO___0xFF
// 0xd8___(err_csl3_reg)___(err_csl1_part7)___24___8___RO___0xFF
// 0xdc___(err_csl4_reg)___(err_csl0_part8)___0___8___RO___0xFF
// 0xdc___(err_csl4_reg)___(err_csl1_part8)___8___8___RO___0xFF
// 0xdc___(err_csl4_reg)___(err_csl0_part9)___16___8___RO___0xFF
// 0xdc___(err_csl4_reg)___(err_csl1_part9)___24___8___RO___0xFF
// 0xe0___(err_wl0_reg)___(err_wl0)___0___13___RO___0x1FFF
// 0xe0___(err_wl0_reg)___(reserved)___13___3___NA___NA
// 0xe0___(err_wl0_reg)___(err_wl1)___16___13___RO___0x1FFF
// 0xe0___(err_wl0_reg)___(reserved)___29___3___NA___NA
// 0xe4___(err_wl1_reg)___(err_wl2)___0___13___RO___0x1FFF
// 0xe4___(err_wl1_reg)___(reserved)___13___3___NA___NA
// 0xe4___(err_wl1_reg)___(err_wl3)___16___13___RO___0x1FFF
// 0xe4___(err_wl1_reg)___(reserved)___29___3___NA___NA
// 0xe8___(err_wl2_reg)___(err_wl4)___0___13___RO___0x1FFF
// 0xe8___(err_wl2_reg)___(reserved)___13___3___NA___NA
// 0xe8___(err_wl2_reg)___(err_wl5)___16___13___RO___0x1FFF
// 0xe8___(err_wl2_reg)___(reserved)___29___3___NA___NA
// 0xec___(err_wl3_reg)___(err_wl6)___0___13___RO___0x1FFF
// 0xec___(err_wl3_reg)___(reserved)___13___3___NA___NA
// 0xec___(err_wl3_reg)___(err_wl7)___16___13___RO___0x1FFF
// 0xec___(err_wl3_reg)___(reserved)___29___3___NA___NA
// 0xf0___(err_wl4_reg)___(err_wl8)___0___13___RO___0x1FFF
// 0xf0___(err_wl4_reg)___(reserved)___13___3___NA___NA
// 0xf0___(err_wl4_reg)___(err_wl9)___16___13___RO___0x1FFF
// 0xf0___(err_wl4_reg)___(reserved)___29___3___NA___NA
// 0xf4___(err_wl5_reg)___(err_wl10)___0___13___RO___0x1FFF
// 0xf4___(err_wl5_reg)___(reserved)___13___3___NA___NA
// 0xf4___(err_wl5_reg)___(err_wl11)___16___13___RO___0x1FFF
// 0xf4___(err_wl5_reg)___(reserved)___29___3___NA___NA
// 0xf8___(err_wl6_reg)___(err_wl12)___0___13___RO___0x1FFF
// 0xf8___(err_wl6_reg)___(reserved)___13___3___NA___NA
// 0xf8___(err_wl6_reg)___(err_wl13)___16___13___RO___0x1FFF
// 0xf8___(err_wl6_reg)___(reserved)___29___3___NA___NA
// 0xfc___(err_wl7_reg)___(err_wl14)___0___13___RO___0x1FFF
// 0xfc___(err_wl7_reg)___(reserved)___13___3___NA___NA
// 0xfc___(err_wl7_reg)___(err_wl15)___16___13___RO___0x1FFF
// 0xfc___(err_wl7_reg)___(reserved)___29___3___NA___NA
// 0x100___(err_wl8_reg)___(err_wl16)___0___13___RO___0x1FFF
// 0x100___(err_wl8_reg)___(reserved)___13___3___NA___NA
// 0x100___(err_wl8_reg)___(err_wl17)___16___13___RO___0x1FFF
// 0x100___(err_wl8_reg)___(reserved)___29___3___NA___NA
// 0x104___(err_wl9_reg)___(err_wl18)___0___13___RO___0x1FFF
// 0x104___(err_wl9_reg)___(reserved)___13___3___NA___NA
// 0x104___(err_wl9_reg)___(err_wl19)___16___13___RO___0x1FFF
// 0x104___(err_wl9_reg)___(reserved)___29___3___NA___NA
// 0x108___(err_wl10_reg)___(err_wl20)___0___13___RO___0x1FFF
// 0x108___(err_wl10_reg)___(reserved)___13___3___NA___NA
// 0x108___(err_wl10_reg)___(err_wl21)___16___13___RO___0x1FFF
// 0x108___(err_wl10_reg)___(reserved)___29___3___NA___NA
// 0x10c___(err_wl11_reg)___(err_wl22)___0___13___RO___0x1FFF
// 0x10c___(err_wl11_reg)___(reserved)___13___3___NA___NA
// 0x10c___(err_wl11_reg)___(err_wl23)___16___13___RO___0x1FFF
// 0x10c___(err_wl11_reg)___(reserved)___29___3___NA___NA
// 0x110___(err_wl12_reg)___(err_wl24)___0___13___RO___0x1FFF
// 0x110___(err_wl12_reg)___(reserved)___13___3___NA___NA
// 0x110___(err_wl12_reg)___(err_wl25)___16___13___RO___0x1FFF
// 0x110___(err_wl12_reg)___(reserved)___29___3___NA___NA
// 0x114___(err_wl13_reg)___(err_wl26)___0___13___RO___0x1FFF
// 0x114___(err_wl13_reg)___(reserved)___13___3___NA___NA
// 0x114___(err_wl13_reg)___(err_wl27)___16___13___RO___0x1FFF
// 0x114___(err_wl13_reg)___(reserved)___29___3___NA___NA
// 0x118___(err_wl14_reg)___(err_wl28)___0___13___RO___0x1FFF
// 0x118___(err_wl14_reg)___(reserved)___13___3___NA___NA
// 0x118___(err_wl14_reg)___(err_wl29)___16___13___RO___0x1FFF
// 0x118___(err_wl14_reg)___(reserved)___29___3___NA___NA
// 0x11c___(err_wl15_reg)___(err_wl30)___0___13___RO___0x1FFF
// 0x11c___(err_wl15_reg)___(reserved)___13___3___NA___NA
// 0x11c___(err_wl15_reg)___(err_wl31)___16___13___RO___0x1FFF
// 0x11c___(err_wl15_reg)___(reserved)___29___3___NA___NA
// 0x120___(err_wl16_reg)___(err_wl32)___0___13___RO___0x1FFF
// 0x120___(err_wl16_reg)___(reserved)___13___3___NA___NA
// 0x120___(err_wl16_reg)___(err_wl33)___16___13___RO___0x1FFF
// 0x120___(err_wl16_reg)___(reserved)___29___3___NA___NA
// 0x124___(err_wl17_reg)___(err_wl34)___0___13___RO___0x1FFF
// 0x124___(err_wl17_reg)___(reserved)___13___3___NA___NA
// 0x124___(err_wl17_reg)___(err_wl35)___16___13___RO___0x1FFF
// 0x124___(err_wl17_reg)___(reserved)___29___3___NA___NA
// 0x128___(err_wl18_reg)___(err_wl36)___0___13___RO___0x1FFF
// 0x128___(err_wl18_reg)___(reserved)___13___3___NA___NA
// 0x128___(err_wl18_reg)___(err_wl37)___16___13___RO___0x1FFF
// 0x128___(err_wl18_reg)___(reserved)___29___3___NA___NA
// 0x12c___(err_wl19_reg)___(err_wl38)___0___13___RO___0x1FFF
// 0x12c___(err_wl19_reg)___(reserved)___13___3___NA___NA
// 0x12c___(err_wl19_reg)___(err_wl39)___16___13___RO___0x1FFF
// 0x12c___(err_wl19_reg)___(reserved)___29___3___NA___NA
// 0x130___(err_wl20_reg)___(err_wl40)___0___13___RO___0x1FFF
// 0x130___(err_wl20_reg)___(reserved)___13___3___NA___NA
// 0x130___(err_wl20_reg)___(err_wl41)___16___13___RO___0x1FFF
// 0x130___(err_wl20_reg)___(reserved)___29___3___NA___NA
// 0x134___(err_wl21_reg)___(err_wl42)___0___13___RO___0x1FFF
// 0x134___(err_wl21_reg)___(reserved)___13___3___NA___NA
// 0x134___(err_wl21_reg)___(err_wl43)___16___13___RO___0x1FFF
// 0x134___(err_wl21_reg)___(reserved)___29___3___NA___NA
// 0x138___(err_wl22_reg)___(err_wl44)___0___13___RO___0x1FFF
// 0x138___(err_wl22_reg)___(reserved)___13___3___NA___NA
// 0x138___(err_wl22_reg)___(err_wl45)___16___13___RO___0x1FFF
// 0x138___(err_wl22_reg)___(reserved)___29___3___NA___NA
// 0x13c___(err_wl23_reg)___(err_wl46)___0___13___RO___0x1FFF
// 0x13c___(err_wl23_reg)___(reserved)___13___3___NA___NA
// 0x13c___(err_wl23_reg)___(err_wl47)___16___13___RO___0x1FFF
// 0x13c___(err_wl23_reg)___(reserved)___29___3___NA___NA
// 0x140___(err_wl24_reg)___(err_wl48)___0___13___RO___0x1FFF
// 0x140___(err_wl24_reg)___(reserved)___13___3___NA___NA
// 0x140___(err_wl24_reg)___(err_wl49)___16___13___RO___0x1FFF
// 0x140___(err_wl24_reg)___(reserved)___29___3___NA___NA
// 0x144___(err_wl25_reg)___(err_wl50)___0___13___RO___0x1FFF
// 0x144___(err_wl25_reg)___(reserved)___13___3___NA___NA
// 0x144___(err_wl25_reg)___(err_wl51)___16___13___RO___0x1FFF
// 0x144___(err_wl25_reg)___(reserved)___29___3___NA___NA
// 0x148___(err_wl26_reg)___(err_wl52)___0___13___RO___0x1FFF
// 0x148___(err_wl26_reg)___(reserved)___13___3___NA___NA
// 0x148___(err_wl26_reg)___(err_wl53)___16___13___RO___0x1FFF
// 0x148___(err_wl26_reg)___(reserved)___29___3___NA___NA
// 0x14c___(err_wl27_reg)___(err_wl54)___0___13___RO___0x1FFF
// 0x14c___(err_wl27_reg)___(reserved)___13___3___NA___NA
// 0x14c___(err_wl27_reg)___(err_wl55)___16___13___RO___0x1FFF
// 0x14c___(err_wl27_reg)___(reserved)___29___3___NA___NA
// 0x150___(err_wl28_reg)___(err_wl56)___0___13___RO___0x1FFF
// 0x150___(err_wl28_reg)___(reserved)___13___3___NA___NA
// 0x150___(err_wl28_reg)___(err_wl57)___16___13___RO___0x1FFF
// 0x150___(err_wl28_reg)___(reserved)___29___3___NA___NA
// 0x154___(err_wl29_reg)___(err_wl58)___0___13___RO___0x1FFF
// 0x154___(err_wl29_reg)___(reserved)___13___3___NA___NA
// 0x154___(err_wl29_reg)___(err_wl59)___16___13___RO___0x1FFF
// 0x154___(err_wl29_reg)___(reserved)___29___3___NA___NA
// 0x158___(err_wl30_reg)___(err_wl60)___0___13___RO___0x1FFF
// 0x158___(err_wl30_reg)___(reserved)___13___3___NA___NA
// 0x158___(err_wl30_reg)___(err_wl61)___16___13___RO___0x1FFF
// 0x158___(err_wl30_reg)___(reserved)___29___3___NA___NA
// 0x15c___(err_wl31_reg)___(err_wl62)___0___13___RO___0x1FFF
// 0x15c___(err_wl31_reg)___(reserved)___13___3___NA___NA
// 0x15c___(err_wl31_reg)___(err_wl63)___16___13___RO___0x1FFF
// 0x15c___(err_wl31_reg)___(reserved)___29___3___NA___NA
// 0x160___(bist_finish_clr_reg)___(bist_finish_clr)___0___1___W1C___0x0
// 0x160___(bist_finish_clr_reg)___(reserved)___1___31___NA___NA
// 0x164___(bist_finish_mask_reg)___(bist_finish_mask)___0___1___RW___0x1
// 0x164___(bist_finish_mask_reg)___(reserved)___1___31___NA___NA
// 0x168___(hang_timeout_th_reg)___(hang_timeout_th)___0___32___RW___0x186a00
// 0x16c___(mc_bist_rescan_fail_num_reg)___(mc_bist_rescan_fail_num)___0___20___RO___0x0
// 0x16c___(mc_bist_rescan_fail_num_reg)___(reserved)___20___12___NA___NA
// 0x170___(mc_bist_err_wl_reg)___(mc_bist_err_wl_num)___0___7___RO___0x0
// 0x170___(mc_bist_err_wl_reg)___(err_wl_num_change_flag)___7___1___RO___0x0
// 0x170___(mc_bist_err_wl_reg)___(reserved)___8___24___NA___NA
// 0x174___(rescan_finish_clr_reg)___(rescan_finish_clr)___0___1___W1C___0x0
// 0x174___(rescan_finish_clr_reg)___(reserved)___1___31___NA___NA
// 0x178___(rescan_finish_mask_reg)___(rescan_finish_mask)___0___1___RW___0x1
// 0x178___(rescan_finish_mask_reg)___(reserved)___1___31___NA___NA
// 0x17c___(rescan_round_result_reg)___(rescan_round_result)___0___15___RO___0x0
// 0x17c___(rescan_round_result_reg)___(reserved)___15___17___NA___NA
// 0x180___(dbg_frame_store_0_reg)___(dbg_frame_store_0)___0___32___RO___0x0
// 0x184___(dbg_frame_store_1_reg)___(dbg_frame_store_1)___0___32___RO___0x0
// 0x188___(dbg_frame_store_2_reg)___(dbg_frame_store_2)___0___32___RO___0x0
// 0x18c___(dbg_frame_store_3_reg)___(dbg_frame_store_3)___0___32___RO___0x0
// 0x190___(dbg_frame_store_4_reg)___(dbg_frame_store_4)___0___32___RO___0x0
// 0x194___(dbg_frame_store_5_reg)___(dbg_frame_store_5)___0___32___RO___0x0
// 0x198___(dbg_frame_store_6_reg)___(dbg_frame_store_6)___0___32___RO___0x0
// 0x19c___(dbg_frame_store_7_reg)___(dbg_frame_store_7)___0___32___RO___0x0
// 0x1a0___(dbg_frame_store_8_reg)___(dbg_frame_store_8)___0___32___RO___0x0
// 0x1a4___(dbg_frame_store_9_reg)___(dbg_frame_store_9)___0___2___RO___0x0
// 0x1a4___(dbg_frame_store_9_reg)___(reserved)___2___30___NA___NA
// 0x1a8___(dbg_rdata_store_0_reg)___(dbg_rdata_store_0)___0___32___RO___0x0
// 0x1ac___(dbg_rdata_store_1_reg)___(dbg_rdata_store_1)___0___32___RO___0x0
// 0x1b0___(dbg_rdata_store_2_reg)___(dbg_rdata_store_2)___0___32___RO___0x0
// 0x1b4___(dbg_rdata_store_3_reg)___(dbg_rdata_store_3)___0___32___RO___0x0
// 0x1b8___(dbg_rdata_store_4_reg)___(dbg_rdata_store_4)___0___32___RO___0x0
// 0x1bc___(dbg_rdata_store_5_reg)___(dbg_rdata_store_5)___0___32___RO___0x0
// 0x1c0___(dbg_rdata_store_6_reg)___(dbg_rdata_store_6)___0___32___RO___0x0
// 0x1c4___(dbg_rdata_store_7_reg)___(dbg_rdata_store_7)___0___32___RO___0x0
// 0x1c8___(dbg_rdata_store_8_reg)___(dbg_rdata_store_8)___0___10___RO___0x0
// 0x1c8___(dbg_rdata_store_8_reg)___(reserved)___10___22___NA___NA
// 0x1cc___(bist_pattern_reg0_reg)___(bist_pattern_reg0)___0___32___RW___0x0
// 0x1d0___(bist_pattern_reg1_reg)___(bist_pattern_reg1)___0___32___RW___0x0
// 0x1d4___(bist_pattern_reg2_reg)___(bist_pattern_reg2)___0___32___RW___0x0
// 0x1d8___(bist_pattern_reg3_reg)___(bist_pattern_reg3)___0___32___RW___0x0
// 0x1dc___(csl_bist_pattern_sel0_reg)___(csl_bist_pattern_sel0)___0___32___RW___0xFFFFFFFF
// 0x1e0___(csl_bist_pattern_sel1_reg)___(csl_bist_pattern_sel1)___0___32___RW___0xFFFFFFFF
// 0x1e4___(csl_bist_pattern_sel2_reg)___(csl_bist_pattern_sel2)___0___4___RW___0x0
// 0x1e4___(csl_bist_pattern_sel2_reg)___(reserved)___4___28___NA___NA
// 0x1e8___(wl_bist_pattern_sel0_reg)___(wl_bist_pattern_sel0)___0___32___RW___0xFFFFFFFF
// 0x1ec___(wl_bist_pattern_sel1_reg)___(wl_bist_pattern_sel1)___0___32___RW___0xFFFFFFFF
// 0x1f0___(wl_bist_pattern_sel2_reg)___(wl_bist_pattern_sel2)___0___4___RW___0x0
// 0x1f0___(wl_bist_pattern_sel2_reg)___(reserved)___4___28___NA___NA
// 0x1f4___(mc_ecc_ctrl_reg)___(mc_ecc_en)___0___1___RW___0x0
// 0x1f4___(mc_ecc_ctrl_reg)___(reserved)___1___3___NA___NA
// 0x1f4___(mc_ecc_ctrl_reg)___(mc_ecc_ce_th)___4___5___RW___0x10
// 0x1f4___(mc_ecc_ctrl_reg)___(reserved)___9___7___NA___Na
// 0x1f4___(mc_ecc_ctrl_reg)___(mc_ecc_ce_int_clr)___16___1___W1C___0x0
// 0x1f4___(mc_ecc_ctrl_reg)___(reserved)___17___3___NA___NA
// 0x1f4___(mc_ecc_ctrl_reg)___(mc_ecc_ce_int_mask)___20___1___RW___0x0
// 0x1f4___(mc_ecc_ctrl_reg)___(reserved)___21___3___NA___NA
// 0x1f4___(mc_ecc_ctrl_reg)___(mc_ecc_uce_int_clr)___24___1___W1C___0x0
// 0x1f4___(mc_ecc_ctrl_reg)___(reserved)___25___3___NA___NA
// 0x1f4___(mc_ecc_ctrl_reg)___(mc_ecc_uce_int_mask)___28___1___RW___0x0
// 0x1f4___(mc_ecc_ctrl_reg)___(reserved)___29___3___NA___NA
// 0x1f8___(mc_ecc_int_status_reg)___(mc_ecc_ce_int_status)___0___1___RO___0x0
// 0x1f8___(mc_ecc_int_status_reg)___(reserved)___1___3___NA___NA
// 0x1f8___(mc_ecc_int_status_reg)___(mc_ecc_uce_int_status)___4___1___RO___0x0
// 0x1f8___(mc_ecc_int_status_reg)___(reserved)___5___3___NA___NA
// 0x1f8___(mc_ecc_int_status_reg)___(mc_ecc_ce_cnt)___8___5___RO___0x0
// 0x1f8___(mc_ecc_int_status_reg)___(reserved)___13___19___NA___NA
// 0x1fc___(mc_ecc_ce_addr0_reg)___(mc_ecc_ce_addr0)___0___32___RO___0x0
// 0x200___(mc_ecc_ce_addr1_reg)___(mc_ecc_ce_addr1)___0___32___RO___0x0
// 0x204___(mc_ecc_ce_addr2_reg)___(mc_ecc_ce_addr2)___0___32___RO___0x0
// 0x208___(mc_ecc_ce_addr3_reg)___(mc_ecc_ce_addr3)___0___32___RO___0x0
// 0x20c___(mc_ecc_ce_addr4_reg)___(mc_ecc_ce_addr4)___0___32___RO___0x0
// 0x210___(mc_ecc_ce_addr5_reg)___(mc_ecc_ce_addr5)___0___32___RO___0x0
// 0x214___(mc_ecc_ce_addr6_reg)___(mc_ecc_ce_addr6)___0___32___RO___0x0
// 0x218___(mc_ecc_ce_addr7_reg)___(mc_ecc_ce_addr7)___0___32___RO___0x0
// 0x21c___(mc_ecc_ce_addr8_reg)___(mc_ecc_ce_addr8)___0___32___RO___0x0
// 0x220___(mc_ecc_ce_addr9_reg)___(mc_ecc_ce_addr9)___0___32___RO___0x0
// 0x224___(mc_ecc_ce_addr10_reg)___(mc_ecc_ce_addr10)___0___32___RO___0x0
// 0x228___(mc_ecc_ce_addr11_reg)___(mc_ecc_ce_addr11)___0___32___RO___0x0
// 0x22c___(mc_ecc_ce_addr12_reg)___(mc_ecc_ce_addr12)___0___32___RO___0x0
// 0x230___(mc_ecc_ce_addr13_reg)___(mc_ecc_ce_addr13)___0___32___RO___0x0
// 0x234___(mc_ecc_ce_addr14_reg)___(mc_ecc_ce_addr14)___0___32___RO___0x0
// 0x238___(mc_ecc_ce_addr15_reg)___(mc_ecc_ce_addr15)___0___32___RO___0x0
// 0x23c___(mc_ecc_uce_addr0_reg)___(mc_ecc_uce_addr0)___0___32___RO___0x0
// 0x240___(mc_ecc_uce_addr1_reg)___(mc_ecc_uce_addr1)___0___32___RO___0x0
// 0x244___(mc_ecc_uce_addr2_reg)___(mc_ecc_uce_addr2)___0___32___RO___0x0
// 0x248___(mc_ecc_uce_addr3_reg)___(mc_ecc_uce_addr3)___0___32___RO___0x0
// 0x24c___(bist_scan_ctrl_reg)___(bist_scan_start_bank)___0___1___RW___0x0
// 0x24c___(bist_scan_ctrl_reg)___(reserved)___1___3___NA___NA
// 0x24c___(bist_scan_ctrl_reg)___(bist_scan_end_bank)___4___1___RW___0x1
// 0x24c___(bist_scan_ctrl_reg)___(reserved)___5___27___NA___NA
// 0x250___(axi2frame_dbg0_reg)___(a2f_dbg_ar_cnt)___0___32___RO___0x0
// 0x254___(axi2frame_dbg1_reg)___(a2f_dbg_r_cnt)___0___32___RO___0x0
// 0x258___(axi2frame_dbg2_reg)___(a2f_dbg_aw_cnt)___0___32___RO___0x0
// 0x25c___(axi2frame_dbg3_reg)___(a2f_dbg_w_cnt)___0___32___RO___0x0
// 0x260___(axi2frame_dbg4_reg)___(a2f_dbg_b_cnt)___0___32___RO___0x0
// 0x264___(axi2frame_dbg5_reg)___(a2f_dbg_axi_len_err_addr)___0___32___RO___0x0
// 0x268___(axi2frame_dbg6_reg)___(a2f_dbg_axi_len_err)___0___1___RO___0x0
// 0x268___(axi2frame_dbg6_reg)___(reserved)___1___31___NA___NA
// 0x26c___(axi2frame_dbg7_reg)___(a2f_dbg_reserve_in)___0___32___RW___0x0
// 0x270___(axi2frame_dbg8_reg)___(a2f_dbg_reserve_out)___0___32___RO___0x0
// 0x274___(mc_page_status_reg)___(mc_page_status)___0___1___RO___0x1
// 0x274___(mc_page_status_reg)___(reserved)___1___31___NA___reserved
// 0x278___(hang_timeout_status_reg)___(hang_timeout_status)___0___1___RO___0x0
// 0x278___(hang_timeout_status_reg)___(reserved)___1___31___NA___NA
// 0x27c___(hang_timeout_mask_reg)___(hang_timeout_mask)___0___1___RW___0x1
// 0x27c___(hang_timeout_mask_reg)___(reserved)___1___31___NA___NA
// 0x280___(hang_timeout_clr_reg)___(hang_timeout_clr)___0___1___W1C___0x0
// 0x280___(hang_timeout_clr_reg)___(reserved)___1___31___NA___NA
// 0x284___(hang_timeout_en_reg)___(hang_timeout_en)___0___1___RW___0x1
// 0x284___(hang_timeout_en_reg)___(reserved)___1___31___NA___NA
// 0x288___(mc_bank1_vmc_wl_num0_reg)___(mc_bank1_vmc_wl_num0)___0___13___RW___0x1FFF
// 0x288___(mc_bank1_vmc_wl_num0_reg)___(reserved)___13___3___NA___NA
// 0x288___(mc_bank1_vmc_wl_num0_reg)___(mc_bank1_vmc_wl_num1)___16___13___RW___0x1FFF
// 0x288___(mc_bank1_vmc_wl_num0_reg)___(reserved)___29___3___NA___NA
// 0x28c___(mc_bank1_vmc_wl_num1_reg)___(mc_bank1_vmc_wl_num2)___0___13___RW___0x1FFF
// 0x28c___(mc_bank1_vmc_wl_num1_reg)___(reserved)___13___3___NA___NA
// 0x28c___(mc_bank1_vmc_wl_num1_reg)___(mc_bank1_vmc_wl_num3)___16___13___RW___0x1FFF
// 0x28c___(mc_bank1_vmc_wl_num1_reg)___(reserved)___29___3___NA___NA
// 0x290___(mc_bank1_vmc_wl_num2_reg)___(mc_bank1_vmc_wl_num4)___0___13___RW___0x1FFF
// 0x290___(mc_bank1_vmc_wl_num2_reg)___(reserved)___13___3___NA___NA
// 0x290___(mc_bank1_vmc_wl_num2_reg)___(mc_bank1_vmc_wl_num5)___16___13___RW___0x1FFF
// 0x290___(mc_bank1_vmc_wl_num2_reg)___(reserved)___29___3___NA___NA
// 0x294___(mc_bank1_vmc_wl_num3_reg)___(mc_bank1_vmc_wl_num6)___0___13___RW___0x1FFF
// 0x294___(mc_bank1_vmc_wl_num3_reg)___(reserved)___13___3___NA___NA
// 0x294___(mc_bank1_vmc_wl_num3_reg)___(mc_bank1_vmc_wl_num7)___16___13___RW___0x1FFF
// 0x294___(mc_bank1_vmc_wl_num3_reg)___(reserved)___29___3___NA___NA
// 0x298___(mc_bank1_vmc_wl_num4_reg)___(mc_bank1_vmc_wl_num8)___0___13___RW___0x1FFF
// 0x298___(mc_bank1_vmc_wl_num4_reg)___(reserved)___13___3___NA___NA
// 0x298___(mc_bank1_vmc_wl_num4_reg)___(mc_bank1_vmc_wl_num9)___16___13___RW___0x1FFF
// 0x298___(mc_bank1_vmc_wl_num4_reg)___(reserved)___29___3___NA___NA
// 0x29c___(mc_bank1_vmc_wl_num5_reg)___(mc_bank1_vmc_wl_num10)___0___13___RW___0x1FFF
// 0x29c___(mc_bank1_vmc_wl_num5_reg)___(reserved)___13___3___NA___NA
// 0x29c___(mc_bank1_vmc_wl_num5_reg)___(mc_bank1_vmc_wl_num11)___16___13___RW___0x1FFF
// 0x29c___(mc_bank1_vmc_wl_num5_reg)___(reserved)___29___3___NA___NA
// 0x2a0___(mc_bank1_vmc_wl_num6_reg)___(mc_bank1_vmc_wl_num12)___0___13___RW___0x1FFF
// 0x2a0___(mc_bank1_vmc_wl_num6_reg)___(reserved)___13___3___NA___NA
// 0x2a0___(mc_bank1_vmc_wl_num6_reg)___(mc_bank1_vmc_wl_num13)___16___13___RW___0x1FFF
// 0x2a0___(mc_bank1_vmc_wl_num6_reg)___(reserved)___29___3___NA___NA
// 0x2a4___(mc_bank1_vmc_wl_num7_reg)___(mc_bank1_vmc_wl_num14)___0___13___RW___0x1FFF
// 0x2a4___(mc_bank1_vmc_wl_num7_reg)___(reserved)___13___3___NA___NA
// 0x2a4___(mc_bank1_vmc_wl_num7_reg)___(mc_bank1_vmc_wl_num15)___16___13___RW___0x1FFF
// 0x2a4___(mc_bank1_vmc_wl_num7_reg)___(reserved)___29___3___NA___NA
// 0x2a8___(mc_bank1_vmc_wl_num8_reg)___(mc_bank1_vmc_wl_num16)___0___13___RW___0x1FFF
// 0x2a8___(mc_bank1_vmc_wl_num8_reg)___(reserved)___13___3___NA___NA
// 0x2a8___(mc_bank1_vmc_wl_num8_reg)___(mc_bank1_vmc_wl_num17)___16___13___RW___0x1FFF
// 0x2a8___(mc_bank1_vmc_wl_num8_reg)___(reserved)___29___3___NA___NA
// 0x2ac___(mc_bank1_vmc_wl_num9_reg)___(mc_bank1_vmc_wl_num18)___0___13___RW___0x1FFF
// 0x2ac___(mc_bank1_vmc_wl_num9_reg)___(reserved)___13___3___NA___NA
// 0x2ac___(mc_bank1_vmc_wl_num9_reg)___(mc_bank1_vmc_wl_num19)___16___13___RW___0x1FFF
// 0x2ac___(mc_bank1_vmc_wl_num9_reg)___(reserved)___29___3___NA___NA
// 0x2b0___(mc_bank1_vmc_wl_num10_reg)___(mc_bank1_vmc_wl_num20)___0___13___RW___0x1FFF
// 0x2b0___(mc_bank1_vmc_wl_num10_reg)___(reserved)___13___3___NA___NA
// 0x2b0___(mc_bank1_vmc_wl_num10_reg)___(mc_bank1_vmc_wl_num21)___16___13___RW___0x1FFF
// 0x2b0___(mc_bank1_vmc_wl_num10_reg)___(reserved)___29___3___NA___NA
// 0x2b4___(mc_bank1_vmc_wl_num11_reg)___(mc_bank1_vmc_wl_num22)___0___13___RW___0x1FFF
// 0x2b4___(mc_bank1_vmc_wl_num11_reg)___(reserved)___13___3___NA___NA
// 0x2b4___(mc_bank1_vmc_wl_num11_reg)___(mc_bank1_vmc_wl_num23)___16___13___RW___0x1FFF
// 0x2b4___(mc_bank1_vmc_wl_num11_reg)___(reserved)___29___3___NA___NA
// 0x2b8___(mc_bank1_vmc_wl_num12_reg)___(mc_bank1_vmc_wl_num24)___0___13___RW___0x1FFF
// 0x2b8___(mc_bank1_vmc_wl_num12_reg)___(reserved)___13___3___NA___NA
// 0x2b8___(mc_bank1_vmc_wl_num12_reg)___(mc_bank1_vmc_wl_num25)___16___13___RW___0x1FFF
// 0x2b8___(mc_bank1_vmc_wl_num12_reg)___(reserved)___29___3___NA___NA
// 0x2bc___(mc_bank1_vmc_wl_num13_reg)___(mc_bank1_vmc_wl_num26)___0___13___RW___0x1FFF
// 0x2bc___(mc_bank1_vmc_wl_num13_reg)___(reserved)___13___3___NA___NA
// 0x2bc___(mc_bank1_vmc_wl_num13_reg)___(mc_bank1_vmc_wl_num27)___16___13___RW___0x1FFF
// 0x2bc___(mc_bank1_vmc_wl_num13_reg)___(reserved)___29___3___NA___NA
// 0x2c0___(mc_bank1_vmc_wl_num14_reg)___(mc_bank1_vmc_wl_num28)___0___13___RW___0x1FFF
// 0x2c0___(mc_bank1_vmc_wl_num14_reg)___(reserved)___13___3___NA___NA
// 0x2c0___(mc_bank1_vmc_wl_num14_reg)___(mc_bank1_vmc_wl_num29)___16___13___RW___0x1FFF
// 0x2c0___(mc_bank1_vmc_wl_num14_reg)___(reserved)___29___3___NA___NA
// 0x2c4___(mc_bank1_vmc_wl_num15_reg)___(mc_bank1_vmc_wl_num30)___0___13___RW___0x1FFF
// 0x2c4___(mc_bank1_vmc_wl_num15_reg)___(reserved)___13___3___NA___NA
// 0x2c4___(mc_bank1_vmc_wl_num15_reg)___(mc_bank1_vmc_wl_num31)___16___13___RW___0x1FFF
// 0x2c4___(mc_bank1_vmc_wl_num15_reg)___(reserved)___29___3___NA___NA
// 0x2c8___(mc_bank1_vmc_wl_num16_reg)___(mc_bank1_vmc_wl_num32)___0___13___RW___0x1FFF
// 0x2c8___(mc_bank1_vmc_wl_num16_reg)___(reserved)___13___3___NA___NA
// 0x2c8___(mc_bank1_vmc_wl_num16_reg)___(mc_bank1_vmc_wl_num33)___16___13___RW___0x1FFF
// 0x2c8___(mc_bank1_vmc_wl_num16_reg)___(reserved)___29___3___NA___NA
// 0x2cc___(mc_bank1_vmc_wl_num17_reg)___(mc_bank1_vmc_wl_num34)___0___13___RW___0x1FFF
// 0x2cc___(mc_bank1_vmc_wl_num17_reg)___(reserved)___13___3___NA___NA
// 0x2cc___(mc_bank1_vmc_wl_num17_reg)___(mc_bank1_vmc_wl_num35)___16___13___RW___0x1FFF
// 0x2cc___(mc_bank1_vmc_wl_num17_reg)___(reserved)___29___3___NA___NA
// 0x2d0___(mc_bank1_vmc_wl_num18_reg)___(mc_bank1_vmc_wl_num36)___0___13___RW___0x1FFF
// 0x2d0___(mc_bank1_vmc_wl_num18_reg)___(reserved)___13___3___NA___NA
// 0x2d0___(mc_bank1_vmc_wl_num18_reg)___(mc_bank1_vmc_wl_num37)___16___13___RW___0x1FFF
// 0x2d0___(mc_bank1_vmc_wl_num18_reg)___(reserved)___29___3___NA___NA
// 0x2d4___(mc_bank1_vmc_wl_num19_reg)___(mc_bank1_vmc_wl_num38)___0___13___RW___0x1FFF
// 0x2d4___(mc_bank1_vmc_wl_num19_reg)___(reserved)___13___3___NA___NA
// 0x2d4___(mc_bank1_vmc_wl_num19_reg)___(mc_bank1_vmc_wl_num39)___16___13___RW___0x1FFF
// 0x2d4___(mc_bank1_vmc_wl_num19_reg)___(reserved)___29___3___NA___NA
// 0x2d8___(mc_bank1_vmc_wl_num20_reg)___(mc_bank1_vmc_wl_num40)___0___13___RW___0x1FFF
// 0x2d8___(mc_bank1_vmc_wl_num20_reg)___(reserved)___13___3___NA___NA
// 0x2d8___(mc_bank1_vmc_wl_num20_reg)___(mc_bank1_vmc_wl_num41)___16___13___RW___0x1FFF
// 0x2d8___(mc_bank1_vmc_wl_num20_reg)___(reserved)___29___3___NA___NA
// 0x2dc___(mc_bank1_vmc_wl_num21_reg)___(mc_bank1_vmc_wl_num42)___0___13___RW___0x1FFF
// 0x2dc___(mc_bank1_vmc_wl_num21_reg)___(reserved)___13___3___NA___NA
// 0x2dc___(mc_bank1_vmc_wl_num21_reg)___(mc_bank1_vmc_wl_num43)___16___13___RW___0x1FFF
// 0x2dc___(mc_bank1_vmc_wl_num21_reg)___(reserved)___29___3___NA___NA
// 0x2e0___(mc_bank1_vmc_wl_num22_reg)___(mc_bank1_vmc_wl_num44)___0___13___RW___0x1FFF
// 0x2e0___(mc_bank1_vmc_wl_num22_reg)___(reserved)___13___3___NA___NA
// 0x2e0___(mc_bank1_vmc_wl_num22_reg)___(mc_bank1_vmc_wl_num45)___16___13___RW___0x1FFF
// 0x2e0___(mc_bank1_vmc_wl_num22_reg)___(reserved)___29___3___NA___NA
// 0x2e4___(mc_bank1_vmc_wl_num23_reg)___(mc_bank1_vmc_wl_num46)___0___13___RW___0x1FFF
// 0x2e4___(mc_bank1_vmc_wl_num23_reg)___(reserved)___13___3___NA___NA
// 0x2e4___(mc_bank1_vmc_wl_num23_reg)___(mc_bank1_vmc_wl_num47)___16___13___RW___0x1FFF
// 0x2e4___(mc_bank1_vmc_wl_num23_reg)___(reserved)___29___3___NA___NA
// 0x2e8___(mc_bank1_vmc_wl_num24_reg)___(mc_bank1_vmc_wl_num48)___0___13___RW___0x1FFF
// 0x2e8___(mc_bank1_vmc_wl_num24_reg)___(reserved)___13___3___NA___NA
// 0x2e8___(mc_bank1_vmc_wl_num24_reg)___(mc_bank1_vmc_wl_num49)___16___13___RW___0x1FFF
// 0x2e8___(mc_bank1_vmc_wl_num24_reg)___(reserved)___29___3___NA___NA
// 0x2ec___(mc_bank1_vmc_wl_num25_reg)___(mc_bank1_vmc_wl_num50)___0___13___RW___0x1FFF
// 0x2ec___(mc_bank1_vmc_wl_num25_reg)___(reserved)___13___3___NA___NA
// 0x2ec___(mc_bank1_vmc_wl_num25_reg)___(mc_bank1_vmc_wl_num51)___16___13___RW___0x1FFF
// 0x2ec___(mc_bank1_vmc_wl_num25_reg)___(reserved)___29___3___NA___NA
// 0x2f0___(mc_bank1_vmc_wl_num26_reg)___(mc_bank1_vmc_wl_num52)___0___13___RW___0x1FFF
// 0x2f0___(mc_bank1_vmc_wl_num26_reg)___(reserved)___13___3___NA___NA
// 0x2f0___(mc_bank1_vmc_wl_num26_reg)___(mc_bank1_vmc_wl_num53)___16___13___RW___0x1FFF
// 0x2f0___(mc_bank1_vmc_wl_num26_reg)___(reserved)___29___3___NA___NA
// 0x2f4___(mc_bank1_vmc_wl_num27_reg)___(mc_bank1_vmc_wl_num54)___0___13___RW___0x1FFF
// 0x2f4___(mc_bank1_vmc_wl_num27_reg)___(reserved)___13___3___NA___NA
// 0x2f4___(mc_bank1_vmc_wl_num27_reg)___(mc_bank1_vmc_wl_num55)___16___13___RW___0x1FFF
// 0x2f4___(mc_bank1_vmc_wl_num27_reg)___(reserved)___29___3___NA___NA
// 0x2f8___(mc_bank1_vmc_wl_num28_reg)___(mc_bank1_vmc_wl_num56)___0___13___RW___0x1FFF
// 0x2f8___(mc_bank1_vmc_wl_num28_reg)___(reserved)___13___3___NA___NA
// 0x2f8___(mc_bank1_vmc_wl_num28_reg)___(mc_bank1_vmc_wl_num57)___16___13___RW___0x1FFF
// 0x2f8___(mc_bank1_vmc_wl_num28_reg)___(reserved)___29___3___NA___NA
// 0x2fc___(mc_bank1_vmc_wl_num29_reg)___(mc_bank1_vmc_wl_num58)___0___13___RW___0x1FFF
// 0x2fc___(mc_bank1_vmc_wl_num29_reg)___(reserved)___13___3___NA___NA
// 0x2fc___(mc_bank1_vmc_wl_num29_reg)___(mc_bank1_vmc_wl_num59)___16___13___RW___0x1FFF
// 0x2fc___(mc_bank1_vmc_wl_num29_reg)___(reserved)___29___3___NA___NA
// 0x300___(mc_bank1_vmc_wl_num30_reg)___(mc_bank1_vmc_wl_num60)___0___13___RW___0x1FFF
// 0x300___(mc_bank1_vmc_wl_num30_reg)___(reserved)___13___3___NA___NA
// 0x300___(mc_bank1_vmc_wl_num30_reg)___(mc_bank1_vmc_wl_num61)___16___13___RW___0x1FFF
// 0x300___(mc_bank1_vmc_wl_num30_reg)___(reserved)___29___3___NA___NA
// 0x304___(mc_bank1_vmc_wl_num31_reg)___(mc_bank1_vmc_wl_num62)___0___13___RW___0x1FFF
// 0x304___(mc_bank1_vmc_wl_num31_reg)___(reserved)___13___3___NA___NA
// 0x304___(mc_bank1_vmc_wl_num31_reg)___(mc_bank1_vmc_wl_num63)___16___13___RW___0x1FFF
// 0x304___(mc_bank1_vmc_wl_num31_reg)___(reserved)___29___3___NA___NA
// 0x308___(mc_bank1_vmc_bl_num0_reg)___(mc_bank1_vmc_bl_num0_part0)___0___8___RW___0xFF
// 0x308___(mc_bank1_vmc_bl_num0_reg)___(mc_bank1_vmc_bl_num1_part0)___8___8___RW___0xFF
// 0x308___(mc_bank1_vmc_bl_num0_reg)___(mc_bank1_vmc_bl_num0_part1)___16___8___RW___0xFF
// 0x308___(mc_bank1_vmc_bl_num0_reg)___(mc_bank1_vmc_bl_num1_part1)___24___8___RW___0xFF
// 0x30c___(mc_bank1_vmc_bl_num1_reg)___(mc_bank1_vmc_bl_num0_part2)___0___8___RW___0xFF
// 0x30c___(mc_bank1_vmc_bl_num1_reg)___(mc_bank1_vmc_bl_num1_part2)___8___8___RW___0xFF
// 0x30c___(mc_bank1_vmc_bl_num1_reg)___(mc_bank1_vmc_bl_num0_part3)___16___8___RW___0xFF
// 0x30c___(mc_bank1_vmc_bl_num1_reg)___(mc_bank1_vmc_bl_num1_part3)___24___8___RW___0xFF
// 0x310___(mc_bank1_vmc_bl_num2_reg)___(mc_bank1_vmc_bl_num0_part4)___0___8___RW___0xFF
// 0x310___(mc_bank1_vmc_bl_num2_reg)___(mc_bank1_vmc_bl_num1_part4)___8___8___RW___0xFF
// 0x310___(mc_bank1_vmc_bl_num2_reg)___(mc_bank1_vmc_bl_num0_part5)___16___8___RW___0xFF
// 0x310___(mc_bank1_vmc_bl_num2_reg)___(mc_bank1_vmc_bl_num1_part5)___24___8___RW___0xFF
// 0x314___(mc_bank1_vmc_bl_num3_reg)___(mc_bank1_vmc_bl_num0_part6)___0___8___RW___0xFF
// 0x314___(mc_bank1_vmc_bl_num3_reg)___(mc_bank1_vmc_bl_num1_part6)___8___8___RW___0xFF
// 0x314___(mc_bank1_vmc_bl_num3_reg)___(mc_bank1_vmc_bl_num0_part7)___16___8___RW___0xFF
// 0x314___(mc_bank1_vmc_bl_num3_reg)___(mc_bank1_vmc_bl_num1_part7)___24___8___RW___0xFF
// 0x318___(mc_bank1_vmc_bl_num4_reg)___(mc_bank1_vmc_bl_num0_part8)___0___8___RW___0xFF
// 0x318___(mc_bank1_vmc_bl_num4_reg)___(mc_bank1_vmc_bl_num1_part8)___8___8___RW___0xFF
// 0x318___(mc_bank1_vmc_bl_num4_reg)___(mc_bank1_vmc_bl_num0_part9)___16___8___RW___0xFF
// 0x318___(mc_bank1_vmc_bl_num4_reg)___(mc_bank1_vmc_bl_num1_part9)___24___8___RW___0xFF
// 0x31c___(bank1_err_wl_num0_reg)___(bank1_err_wl0)___0___13___RO___0x1FFF
// 0x31c___(bank1_err_wl_num0_reg)___(reserved)___13___3___NA___NA
// 0x31c___(bank1_err_wl_num0_reg)___(bank1_err_wl1)___16___13___RO___0x1FFF
// 0x31c___(bank1_err_wl_num0_reg)___(reserved)___29___3___NA___NA
// 0x320___(bank1_err_wl_num1_reg)___(bank1_err_wl2)___0___13___RO___0x1FFF
// 0x320___(bank1_err_wl_num1_reg)___(reserved)___13___3___NA___NA
// 0x320___(bank1_err_wl_num1_reg)___(bank1_err_wl3)___16___13___RO___0x1FFF
// 0x320___(bank1_err_wl_num1_reg)___(reserved)___29___3___NA___NA
// 0x324___(bank1_err_wl_num2_reg)___(bank1_err_wl4)___0___13___RO___0x1FFF
// 0x324___(bank1_err_wl_num2_reg)___(reserved)___13___3___NA___NA
// 0x324___(bank1_err_wl_num2_reg)___(bank1_err_wl5)___16___13___RO___0x1FFF
// 0x324___(bank1_err_wl_num2_reg)___(reserved)___29___3___NA___NA
// 0x328___(bank1_err_wl_num3_reg)___(bank1_err_wl6)___0___13___RO___0x1FFF
// 0x328___(bank1_err_wl_num3_reg)___(reserved)___13___3___NA___NA
// 0x328___(bank1_err_wl_num3_reg)___(bank1_err_wl7)___16___13___RO___0x1FFF
// 0x328___(bank1_err_wl_num3_reg)___(reserved)___29___3___NA___NA
// 0x32c___(bank1_err_wl_num4_reg)___(bank1_err_wl8)___0___13___RO___0x1FFF
// 0x32c___(bank1_err_wl_num4_reg)___(reserved)___13___3___NA___NA
// 0x32c___(bank1_err_wl_num4_reg)___(bank1_err_wl9)___16___13___RO___0x1FFF
// 0x32c___(bank1_err_wl_num4_reg)___(reserved)___29___3___NA___NA
// 0x330___(bank1_err_wl_num5_reg)___(bank1_err_wl10)___0___13___RO___0x1FFF
// 0x330___(bank1_err_wl_num5_reg)___(reserved)___13___3___NA___NA
// 0x330___(bank1_err_wl_num5_reg)___(bank1_err_wl11)___16___13___RO___0x1FFF
// 0x330___(bank1_err_wl_num5_reg)___(reserved)___29___3___NA___NA
// 0x334___(bank1_err_wl_num6_reg)___(bank1_err_wl12)___0___13___RO___0x1FFF
// 0x334___(bank1_err_wl_num6_reg)___(reserved)___13___3___NA___NA
// 0x334___(bank1_err_wl_num6_reg)___(bank1_err_wl13)___16___13___RO___0x1FFF
// 0x334___(bank1_err_wl_num6_reg)___(reserved)___29___3___NA___NA
// 0x338___(bank1_err_wl_num7_reg)___(bank1_err_wl14)___0___13___RO___0x1FFF
// 0x338___(bank1_err_wl_num7_reg)___(reserved)___13___3___NA___NA
// 0x338___(bank1_err_wl_num7_reg)___(bank1_err_wl15)___16___13___RO___0x1FFF
// 0x338___(bank1_err_wl_num7_reg)___(reserved)___29___3___NA___NA
// 0x33c___(bank1_err_wl_num8_reg)___(bank1_err_wl16)___0___13___RO___0x1FFF
// 0x33c___(bank1_err_wl_num8_reg)___(reserved)___13___3___NA___NA
// 0x33c___(bank1_err_wl_num8_reg)___(bank1_err_wl17)___16___13___RO___0x1FFF
// 0x33c___(bank1_err_wl_num8_reg)___(reserved)___29___3___NA___NA
// 0x340___(bank1_err_wl_num9_reg)___(bank1_err_wl18)___0___13___RO___0x1FFF
// 0x340___(bank1_err_wl_num9_reg)___(reserved)___13___3___NA___NA
// 0x340___(bank1_err_wl_num9_reg)___(bank1_err_wl19)___16___13___RO___0x1FFF
// 0x340___(bank1_err_wl_num9_reg)___(reserved)___29___3___NA___NA
// 0x344___(bank1_err_wl_num10_reg)___(bank1_err_wl20)___0___13___RO___0x1FFF
// 0x344___(bank1_err_wl_num10_reg)___(reserved)___13___3___NA___NA
// 0x344___(bank1_err_wl_num10_reg)___(bank1_err_wl21)___16___13___RO___0x1FFF
// 0x344___(bank1_err_wl_num10_reg)___(reserved)___29___3___NA___NA
// 0x348___(bank1_err_wl_num11_reg)___(bank1_err_wl22)___0___13___RO___0x1FFF
// 0x348___(bank1_err_wl_num11_reg)___(reserved)___13___3___NA___NA
// 0x348___(bank1_err_wl_num11_reg)___(bank1_err_wl23)___16___13___RO___0x1FFF
// 0x348___(bank1_err_wl_num11_reg)___(reserved)___29___3___NA___NA
// 0x34c___(bank1_err_wl_num12_reg)___(bank1_err_wl24)___0___13___RO___0x1FFF
// 0x34c___(bank1_err_wl_num12_reg)___(reserved)___13___3___NA___NA
// 0x34c___(bank1_err_wl_num12_reg)___(bank1_err_wl25)___16___13___RO___0x1FFF
// 0x34c___(bank1_err_wl_num12_reg)___(reserved)___29___3___NA___NA
// 0x350___(bank1_err_wl_num13_reg)___(bank1_err_wl26)___0___13___RO___0x1FFF
// 0x350___(bank1_err_wl_num13_reg)___(reserved)___13___3___NA___NA
// 0x350___(bank1_err_wl_num13_reg)___(bank1_err_wl27)___16___13___RO___0x1FFF
// 0x350___(bank1_err_wl_num13_reg)___(reserved)___29___3___NA___NA
// 0x354___(bank1_err_wl_num14_reg)___(bank1_err_wl28)___0___13___RO___0x1FFF
// 0x354___(bank1_err_wl_num14_reg)___(reserved)___13___3___NA___NA
// 0x354___(bank1_err_wl_num14_reg)___(bank1_err_wl29)___16___13___RO___0x1FFF
// 0x354___(bank1_err_wl_num14_reg)___(reserved)___29___3___NA___NA
// 0x358___(bank1_err_wl_num15_reg)___(bank1_err_wl30)___0___13___RO___0x1FFF
// 0x358___(bank1_err_wl_num15_reg)___(reserved)___13___3___NA___NA
// 0x358___(bank1_err_wl_num15_reg)___(bank1_err_wl31)___16___13___RO___0x1FFF
// 0x358___(bank1_err_wl_num15_reg)___(reserved)___29___3___NA___NA
// 0x35c___(bank1_err_wl_num16_reg)___(bank1_err_wl32)___0___13___RO___0x1FFF
// 0x35c___(bank1_err_wl_num16_reg)___(reserved)___13___3___NA___NA
// 0x35c___(bank1_err_wl_num16_reg)___(bank1_err_wl33)___16___13___RO___0x1FFF
// 0x35c___(bank1_err_wl_num16_reg)___(reserved)___29___3___NA___NA
// 0x360___(bank1_err_wl_num17_reg)___(bank1_err_wl34)___0___13___RO___0x1FFF
// 0x360___(bank1_err_wl_num17_reg)___(reserved)___13___3___NA___NA
// 0x360___(bank1_err_wl_num17_reg)___(bank1_err_wl35)___16___13___RO___0x1FFF
// 0x360___(bank1_err_wl_num17_reg)___(reserved)___29___3___NA___NA
// 0x364___(bank1_err_wl_num18_reg)___(bank1_err_wl36)___0___13___RO___0x1FFF
// 0x364___(bank1_err_wl_num18_reg)___(reserved)___13___3___NA___NA
// 0x364___(bank1_err_wl_num18_reg)___(bank1_err_wl37)___16___13___RO___0x1FFF
// 0x364___(bank1_err_wl_num18_reg)___(reserved)___29___3___NA___NA
// 0x368___(bank1_err_wl_num19_reg)___(bank1_err_wl38)___0___13___RO___0x1FFF
// 0x368___(bank1_err_wl_num19_reg)___(reserved)___13___3___NA___NA
// 0x368___(bank1_err_wl_num19_reg)___(bank1_err_wl39)___16___13___RO___0x1FFF
// 0x368___(bank1_err_wl_num19_reg)___(reserved)___29___3___NA___NA
// 0x36c___(bank1_err_wl_num20_reg)___(bank1_err_wl40)___0___13___RO___0x1FFF
// 0x36c___(bank1_err_wl_num20_reg)___(reserved)___13___3___NA___NA
// 0x36c___(bank1_err_wl_num20_reg)___(bank1_err_wl41)___16___13___RO___0x1FFF
// 0x36c___(bank1_err_wl_num20_reg)___(reserved)___29___3___NA___NA
// 0x370___(bank1_err_wl_num21_reg)___(bank1_err_wl42)___0___13___RO___0x1FFF
// 0x370___(bank1_err_wl_num21_reg)___(reserved)___13___3___NA___NA
// 0x370___(bank1_err_wl_num21_reg)___(bank1_err_wl43)___16___13___RO___0x1FFF
// 0x370___(bank1_err_wl_num21_reg)___(reserved)___29___3___NA___NA
// 0x374___(bank1_err_wl_num22_reg)___(bank1_err_wl44)___0___13___RO___0x1FFF
// 0x374___(bank1_err_wl_num22_reg)___(reserved)___13___3___NA___NA
// 0x374___(bank1_err_wl_num22_reg)___(bank1_err_wl45)___16___13___RO___0x1FFF
// 0x374___(bank1_err_wl_num22_reg)___(reserved)___29___3___NA___NA
// 0x378___(bank1_err_wl_num23_reg)___(bank1_err_wl46)___0___13___RO___0x1FFF
// 0x378___(bank1_err_wl_num23_reg)___(reserved)___13___3___NA___NA
// 0x378___(bank1_err_wl_num23_reg)___(bank1_err_wl47)___16___13___RO___0x1FFF
// 0x378___(bank1_err_wl_num23_reg)___(reserved)___29___3___NA___NA
// 0x37c___(bank1_err_wl_num24_reg)___(bank1_err_wl48)___0___13___RO___0x1FFF
// 0x37c___(bank1_err_wl_num24_reg)___(reserved)___13___3___NA___NA
// 0x37c___(bank1_err_wl_num24_reg)___(bank1_err_wl49)___16___13___RO___0x1FFF
// 0x37c___(bank1_err_wl_num24_reg)___(reserved)___29___3___NA___NA
// 0x380___(bank1_err_wl_num25_reg)___(bank1_err_wl50)___0___13___RO___0x1FFF
// 0x380___(bank1_err_wl_num25_reg)___(reserved)___13___3___NA___NA
// 0x380___(bank1_err_wl_num25_reg)___(bank1_err_wl51)___16___13___RO___0x1FFF
// 0x380___(bank1_err_wl_num25_reg)___(reserved)___29___3___NA___NA
// 0x384___(bank1_err_wl_num26_reg)___(bank1_err_wl52)___0___13___RO___0x1FFF
// 0x384___(bank1_err_wl_num26_reg)___(reserved)___13___3___NA___NA
// 0x384___(bank1_err_wl_num26_reg)___(bank1_err_wl53)___16___13___RO___0x1FFF
// 0x384___(bank1_err_wl_num26_reg)___(reserved)___29___3___NA___NA
// 0x388___(bank1_err_wl_num27_reg)___(bank1_err_wl54)___0___13___RO___0x1FFF
// 0x388___(bank1_err_wl_num27_reg)___(reserved)___13___3___NA___NA
// 0x388___(bank1_err_wl_num27_reg)___(bank1_err_wl55)___16___13___RO___0x1FFF
// 0x388___(bank1_err_wl_num27_reg)___(reserved)___29___3___NA___NA
// 0x38c___(bank1_err_wl_num28_reg)___(bank1_err_wl56)___0___13___RO___0x1FFF
// 0x38c___(bank1_err_wl_num28_reg)___(reserved)___13___3___NA___NA
// 0x38c___(bank1_err_wl_num28_reg)___(bank1_err_wl57)___16___13___RO___0x1FFF
// 0x38c___(bank1_err_wl_num28_reg)___(reserved)___29___3___NA___NA
// 0x390___(bank1_err_wl_num29_reg)___(bank1_err_wl58)___0___13___RO___0x1FFF
// 0x390___(bank1_err_wl_num29_reg)___(reserved)___13___3___NA___NA
// 0x390___(bank1_err_wl_num29_reg)___(bank1_err_wl59)___16___13___RO___0x1FFF
// 0x390___(bank1_err_wl_num29_reg)___(reserved)___29___3___NA___NA
// 0x394___(bank1_err_wl_num30_reg)___(bank1_err_wl60)___0___13___RO___0x1FFF
// 0x394___(bank1_err_wl_num30_reg)___(reserved)___13___3___NA___NA
// 0x394___(bank1_err_wl_num30_reg)___(bank1_err_wl61)___16___13___RO___0x1FFF
// 0x394___(bank1_err_wl_num30_reg)___(reserved)___29___3___NA___NA
// 0x398___(bank1_err_wl_num31_reg)___(bank1_err_wl62)___0___13___RO___0x1FFF
// 0x398___(bank1_err_wl_num31_reg)___(reserved)___13___3___NA___NA
// 0x398___(bank1_err_wl_num31_reg)___(bank1_err_wl63)___16___13___RO___0x1FFF
// 0x398___(bank1_err_wl_num31_reg)___(reserved)___29___3___NA___NA
// 0x39c___(bank1_err_csl_part0_reg)___(bank1_err_csl0_part0)___0___8___RO___0xFF
// 0x39c___(bank1_err_csl_part0_reg)___(bank1_err_csl1_part0)___8___8___RO___0xFF
// 0x39c___(bank1_err_csl_part0_reg)___(bank1_err_csl0_part1)___16___8___RO___0xFF
// 0x39c___(bank1_err_csl_part0_reg)___(bank1_err_csl1_part1)___24___8___RO___0xFF
// 0x3a0___(bank1_err_csl_part1_reg)___(bank1_err_csl0_part2)___0___8___RO___0xFF
// 0x3a0___(bank1_err_csl_part1_reg)___(bank1_err_csl1_part2)___8___8___RO___0xFF
// 0x3a0___(bank1_err_csl_part1_reg)___(bank1_err_csl0_part3)___16___8___RO___0xFF
// 0x3a0___(bank1_err_csl_part1_reg)___(bank1_err_csl1_part3)___24___8___RO___0xFF
// 0x3a4___(bank1_err_csl_part2_reg)___(bank1_err_csl0_part4)___0___8___RO___0xFF
// 0x3a4___(bank1_err_csl_part2_reg)___(bank1_err_csl1_part4)___8___8___RO___0xFF
// 0x3a4___(bank1_err_csl_part2_reg)___(bank1_err_csl0_part5)___16___8___RO___0xFF
// 0x3a4___(bank1_err_csl_part2_reg)___(bank1_err_csl1_part5)___24___8___RO___0xFF
// 0x3a8___(bank1_err_csl_part3_reg)___(bank1_err_csl0_part6)___0___8___RO___0xFF
// 0x3a8___(bank1_err_csl_part3_reg)___(bank1_err_csl1_part6)___8___8___RO___0xFF
// 0x3a8___(bank1_err_csl_part3_reg)___(bank1_err_csl0_part7)___16___8___RO___0xFF
// 0x3a8___(bank1_err_csl_part3_reg)___(bank1_err_csl1_part7)___24___8___RO___0xFF
// 0x3ac___(bank1_err_csl_part4_reg)___(bank1_err_csl0_part8)___0___8___RO___0xFF
// 0x3ac___(bank1_err_csl_part4_reg)___(bank1_err_csl1_part8)___8___8___RO___0xFF
// 0x3ac___(bank1_err_csl_part4_reg)___(bank1_err_csl0_part9)___16___8___RO___0xFF
// 0x3ac___(bank1_err_csl_part4_reg)___(bank1_err_csl1_part9)___24___8___RO___0xFF
// 0x3b0___(mc_bank1_bist_rescan_fail_num_reg)___(mc_bank1_bist_rescan_fail_num)___0___20___RO___0x0
// 0x3b0___(mc_bank1_bist_rescan_fail_num_reg)___(reserved)___20___12___NA___NA
// 0x3b4___(mc_bank1_bist_err_wl_reg)___(mc_bank1_bist_err_wl_num)___0___7___RO___0x0
// 0x3b4___(mc_bank1_bist_err_wl_reg)___(err_bank1_wl_num_change_flag)___7___1___RO___0x0
// 0x3b4___(mc_bank1_bist_err_wl_reg)___(reserved)___8___24___NA___NA
// 0x3b8___(bank1_rescan_round_result_reg)___(bank1_rescan_round_result)___0___15___RO___0x0
// 0x3b8___(bank1_rescan_round_result_reg)___(reserved)___15___17___NA___NA

