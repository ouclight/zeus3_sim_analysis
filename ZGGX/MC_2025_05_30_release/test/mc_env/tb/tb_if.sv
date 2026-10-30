`ifndef __TOP_IF_SV__
`define __TOP_IF_SV__
interface tb_if(input clk,input rst_n);

logic   [31:0]                  mc_id_pe=32'h0         ;
logic   [31:0]                  mc_id_soc=32'h0         ;
logic                           mc_rf_start=1'b0         ;
logic                           global_rf_sel_en=0    ;
logic                           global_rf_sel=0       ;
logic                           global_mc_bist_start = 'b0;
logic                           global_mc_bist_en    = 'b1;
logic                           global_mc_eccerr    ;
logic                           global_init_finish  ;

logic   [3:0]                   bank_radd_set_time_o;
logic   [3:0]                   cadd_set_time_o     ;
logic   [7:0]                   r_cas_set_time_o    ;
logic   [7:0]                   w_cas_set_time_o    ;
logic   [7:0]                   cas_wrrdy_time_o    ;

logic   [4:0]                   mc_tras_cfg     ='d22   ;
logic   [3:0]                   mc_trp_cfg      ='d11   ;
logic   [5:0]                   mc_trc_cfg      ='d33   ;
logic   [4:0]                   mc_trcd_cfg     ='d12   ;
logic   [0:0]                   mc_trtp_cfg     ='d0    ;
logic   [3:0]                   mc_twr_cfg      ='d12   ;
logic   [2:0]                   mc_twtr_cfg     ='d4    ;
logic   [3:0]                   mc_trtw_cfg     ='d6    ;

//--------------------a2f_dbg--------------------
logic   [31:0]                  a2f_dbg_ar_cnt              ;
logic   [31:0]                  a2f_dbg_r_cnt               ;
logic   [31:0]                  a2f_dbg_aw_cnt              ;
logic   [31:0]                  a2f_dbg_w_cnt               ;
logic   [31:0]                  a2f_dbg_b_cnt               ;
logic   [31:0]                  a2f_dbg_axi_len_err_addr    ;
logic                           a2f_dbg_axi_len_err         ;
logic   [31:0]                  a2f_dbg_reserve_in          ;
logic   [31:0]                  a2f_dbg_reserve_out         ;

//----------------------- phy cfg ----------------------
//add by hy 20250212
//logic   [1:0]   cfg_dly_bnksel_n_0  = 'h0;
//logic   [1:0]   cfg_dly_gcadd_0     = 'h0;
//logic   [1:0]   cfg_dly_gcas_rd_0   = 'h0;
//logic   [1:0]   cfg_dly_gcas_wr_0   = 'h0;
//logic   [1:0]   cfg_pulse_gcas_wr_0 = 'h2;
logic           ls_en_asic_0        = 'h1;
logic           ls_en_asic_1        = 'h1;

//------------------------------------------------------
logic   [8:0]                       tp_array_asic0;

logic   [`PATTERN_WIDTH-1:0]     bist_pattern[64]  ;

logic   [6:0]                    bist_csl_scan_num   ;
logic   [6:0]                    bist_wl_scan_num    ;

logic   [`CSL_ERR_TH_WIDTH-1:0]  csl_err_threshold   ;                       
logic   [31:0]                   mc_timeout_th='d600000;                      
logic                           mc_scan_timeout_en=0;
//logic   [2:0]                    tc_ctrl             ;rtl 414 delete                       
//logic   [31:0]                   rf_period0          ;
//logic   [31:0]                   rf_period1          ;
//logic   [31:0]                   rf_period2          ;
//logic   [31:0]                   rf_period3          ;
//logic   [31:0]                   rf_period4          ;
logic                            mc_timeout_intr     ;
logic                            bist_finish_intr    ;                   
logic   [99:0]                   monitor_signals     ;

//---------- add by hy 20241223 -----------------
logic                           monitor_enable=1;

//---------- add by hy 20250108 -----------------
logic                           mc_bank_success;


//---------- add by hy 20241227 -----------------
logic                           rf_request;
assign                          rf_request = mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_req;

logic   [31:0]                  rf_cnt;
assign                          rf_cnt = mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt;

logic   [4:0]                   fsm;
assign                          fsm = mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.FSM_CS;
logic   [13:0]                  gradd_n;
assign                          gradd_n = mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.gradd_n;
logic   [7:0]                   gcadd;
assign                          gcadd = mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.gcadd;
logic                           wl_rd_num;
//assign                          wl_rd_num = mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_wl_scan.single_pattern_rd_times_cnt_inner;
logic                           wl_scan_row_status;
//assign                          wl_scan_row_status = mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_wl_scan.wl_scan_row_status;
logic                           wl_single_rd_done;
//assign                          wl_single_rd_done = mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_wl_scan.wl_single_rd_done;
//----------add by zjh 20241217------------------
logic   [0:0]                   mc_rf_start_sel ='d0      ;
logic   [31:0]                  rf_start_time   ='d0      ;
logic   [31:0]                  rf_period       =32'h30d4000;//64ms
logic   [0:0]                   mc_rf_period_sel='d0      ;
//logic                           mc_sys_rst_n;
//logic                           mc_apb_rst_n;

logic                           rf_range_change_en='d0;
logic                           pre_precharge='d0;
logic                           page_mode_switch='d0;
logic   [`ROW_ADDR_WIDTH*2-1:0]  rf_addr={13'h0,13'h1cbf};

logic                           pe_slverr;
//assign                          pe_slverr=mc_tb.m_mc_wrapper_aux.pe_apb_pslverr;
logic                           pe_penable;
//assign                          pe_penable=mc_tb.m_mc_wrapper_aux.pe_apb_enable;
logic                           pe_psel;
//assign                          pe_psel=mc_tb.m_mc_wrapper_aux.pe_apb_sel;

logic                           soc_slverr;
assign                          soc_slverr=mc_tb.m_mc_wrapper_aux.apb_pslverr;
logic                           soc_penable;
assign                          soc_penable=mc_tb.m_mc_wrapper_aux.apb_enable;
logic                           soc_psel;
assign                          soc_psel=mc_tb.m_mc_wrapper_aux.apb_sel;
//----------add by zjh 20241217 end------------------
logic                           cnt_load    =   'd1 ;
logic   [5:0]                   div_cnt     =   'd0 ;      
logic                           rst_ongoing_flag = 0;

logic                           apb_rst_n           ;
assign                          apb_rst_n   =   mc_tb.apb_rst_n ;

logic                           ras_clr = 0         ;

logic                           mc_sys_rst_n;
logic                           mc_apb_rst_n;

logic                           pclk                ;
assign                          pclk        =   mc_tb.pclk ;

logic                           gcas_wr;
assign                          gcas_wr = mc_tb.m_mc_wrapper_aux.gcas_wr;

logic                           gcas_rd;
assign                          gcas_rd = mc_tb.m_mc_wrapper_aux.gcas_rd;

logic                           bist_clk;
assign                          bist_clk = mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.clk;
//------------ rtl inner clk for clk check -------------
logic                           mc_fram_debug_clk   ;
assign                          mc_fram_debug_clk = mc_tb.m_mc_wrapper_aux.mc_frame_debug_u.clk;

logic                           mc_top_clk          ;
assign                          mc_top_clk  =   mc_tb.m_mc_wrapper_aux.mc_top_u.clk;

logic                           mc_top_apb_clk      ;
assign                          mc_top_apb_clk  =   mc_tb.m_mc_wrapper_aux.mc_top_u.apb_clk;

logic                           apb2reg_mc_soc_top_cfg_if_apb_clk;
assign                          apb2reg_mc_soc_top_cfg_if_apb_clk  = mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_wrapper_cfg_if_u.pclk;

logic                           apb2reg_mc_pe_top_cfg_if_apb_clk;
//assign                          apb2reg_mc_pe_top_cfg_if_apb_clk  = mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_pe_top_cfg_if_u.pclk;

logic                           mc_frame2frame_clk  ;
assign                          mc_frame2frame_clk = mc_tb.m_mc_wrapper_aux.mc_top_u.mc_frame2frame_u.clk;

logic                           frame_arbiter_clk   ;
assign                          frame_arbiter_clk = mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.clk;

logic                           mc_timeout_clk      ;
assign                          mc_timeout_clk  = mc_tb.m_mc_wrapper_aux.mc_top_u.mc_timeout_u.clk;

logic                           frame2array_clk     ;
assign                          frame2array_clk = mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.clk;

logic                           U0_mc_ctrl_DW_sync_clk;
assign                          U0_mc_ctrl_DW_sync_clk = mc_tb.m_mc_wrapper_aux.mc_top_u.U0_mc_ctrl_DW_sync.clk_d;
logic                           U1_mc_ctrl_DW_sync_clk;
assign                          U1_mc_ctrl_DW_sync_clk = mc_tb.m_mc_wrapper_aux.mc_top_u.U1_mc_ctrl_DW_sync.clk_d;
logic                           U2_mc_ctrl_DW_sync_clk;
assign                          U2_mc_ctrl_DW_sync_clk = mc_tb.m_mc_wrapper_aux.mc_top_u.U2_mc_ctrl_DW_sync.clk_d;

logic                           ipdb_pulse2pulse_inst_u0_clk;
assign                          ipdb_pulse2pulse_inst_u0_clk = mc_tb.m_mc_wrapper_aux.mc_top_u.ipdb_pulse2pulse_inst_u0.clk2;
logic                           ipdb_pulse2pulse_inst_u1_clk;
assign                          ipdb_pulse2pulse_inst_u1_clk = mc_tb.m_mc_wrapper_aux.mc_top_u.ipdb_pulse2pulse_inst_u1.clk2;
logic                           ipdb_pulse2pulse_inst_u2_clk;
assign                          ipdb_pulse2pulse_inst_u2_clk = mc_tb.m_mc_wrapper_aux.mc_top_u.ipdb_pulse2pulse_inst_u2.clk2;

logic                           ipdb_pulse2pulse_inst_u0_apb_clk;
assign                          ipdb_pulse2pulse_inst_u0_apb_clk = mc_tb.m_mc_wrapper_aux.mc_top_u.ipdb_pulse2pulse_inst_u0.clk1;
logic                           ipdb_pulse2pulse_inst_u1_apb_clk;
assign                          ipdb_pulse2pulse_inst_u1_apb_clk = mc_tb.m_mc_wrapper_aux.mc_top_u.ipdb_pulse2pulse_inst_u1.clk1;
logic                           ipdb_pulse2pulse_inst_u2_apb_clk;
assign                          ipdb_pulse2pulse_inst_u2_apb_clk = mc_tb.m_mc_wrapper_aux.mc_top_u.ipdb_pulse2pulse_inst_u2.clk1;
//----------------------------------------

logic   [2:0]                   reset_chk_times = 3'b000;    //used to reset check
logic                           reset_vseq=1'b0;

logic                           clk_freq_en =   1   ;

//logic   s_cnt_load_syn;
//assign  s_cnt_load_syn=mc_tb.m_wl_freq_erase.s_cnt_load_syn;

logic                           timeout_case    =   0;

logic                           mc_en;
assign                          mc_en=mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.mc_en;
logic                           wl_vmc_en;
logic                           bl_vmc_en;
//assign  wl_vmc_en   =   mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.mc_wl_vmc_en_o;
//assign  bl_vmc_en   =   mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.mc_bl_vmc_en_o;

logic                           csl_scan_working;
logic                           wl_scan_working;
//assign  csl_scan_working    = mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.csl_scan_working;
//assign  wl_scan_working     = mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.wl_scan_working;
logic   bist_test_en    =   1'b0;
logic   debug_test_en   =   1'b0;      
logic   error_inject    =   1'b0;      
logic   case_finish_flag =  1'b0;
logic   bist_finish_reg ;
//assign  bist_finish_reg=mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.bist_finish_i ;
logic   bist_finish_int ;
//assign  bist_finish_int=mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.bist_finish_int;
logic   bist_csl_fail;
//assign  bist_csl_fail=mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.bist_csl_fail;
//logic   [5:0]   s_div_cnt;       
//assign  s_div_cnt=mc_tb.m_wl_freq_erase.s_div_cnt;
logic   cycle_640_check_en  = 0;
//logic   csl_up_done;
//assign  csl_up_done=mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.csl_scan_row_up_single_done;

logic   csl_part0_done;
logic   csl_part1_done;
logic   csl_part2_done;
logic   csl_part3_done;
logic   csl_part4_done;
//assign  csl_part0_done=mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.csl_scan_row_part0_single_done;
//assign  csl_part1_done=mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.csl_scan_row_part1_single_done;
//assign  csl_part2_done=mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.csl_scan_row_part2_single_done;
//assign  csl_part3_done=mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.csl_scan_row_part3_single_done;
//assign  csl_part4_done=mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.csl_scan_row_part4_single_done;
//2025/2/19 add
logic   bist_rescan_finish;//O
logic   bist_rescan_success;//0
logic   global_mc_rescan_start=0;//I
logic   [3:0]                   bist_rescan_num=3;//I
logic   [3:0]                   bist_wl_scan_single_pattern_rd_num=0;//I
logic                           rf_period_up_en=0;//I
logic   mc_dram_init_wr_finish;//O
assign  mc_dram_init_wr_finish  =   mc_tb.m_mc_wrapper_aux.mc_top_u.dram_init_wr_aux_u.mc_dram_init_finish;
logic   mc_bist_csl_vmc_en=1;//I

logic   dump_ready;
logic   global_bist_clr=0;
logic   dbg_data_store_en=0;
`ifdef NO_INIT
    logic [4:0] global_dram_init_en=2'b10;
`else
    logic [4:0] global_dram_init_en=2'b11;
`endif

//for gating check
logic   bist_inner_global_mc_bist_en;
assign  bist_inner_global_mc_bist_en = mc_tb.m_mc_wrapper_aux.mc_top_u.global_mc_bist_en_tmp;

//---- for arbiter check ---
logic [5:0] arb_s_valid_i;
assign arb_s_valid_i = mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.s_tvalid[5:0];

logic [1751:0]  arb_s_data_i;
assign arb_s_data_i = mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.s_tdata[1751:0];


logic [265:0]   arb_m_rdata_i;
assign arb_m_rdata_i = mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.array_rdata[265:0];

logic   arb_m_rdata_vld_i;
assign arb_m_rdata_vld_i = mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.array_rvalid;

logic arb_m_ready_i;
assign arb_m_ready_i = mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.m_tready;

logic [5:0] arb_port_choose;
assign arb_port_choose = mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.port_choose_array;

logic [5:0] arb_s_ready_o;
assign arb_s_ready_o = mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.s_tready[5:0];

logic arb_m_vld_o;
assign arb_m_vld_o = mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.m_tvalid;

logic [291:0] arb_m_data_o;
assign arb_m_data_o = mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.m_tdata[291:0];

logic [4:0] arb_s_rvld_o;
assign arb_s_rvld_o = {mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.rescan_rvalid, mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.func_rvalid, mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.bist_wl_rvalid, mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.bist_csl_rvalid, mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.bist_path_rvalid};

logic [266*5-1:0]   arb_s_rdata_o;
assign arb_s_rdata_o = {mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.rescan_rdata, mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.func_rdata, mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.bist_wl_rdata, mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.bist_csl_rdata, mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.bist_path_rdata};
//--------------------------


logic               global_ecc_en   = 0;
logic               global_ecc_sel  = 0;
endinterface

`endif
