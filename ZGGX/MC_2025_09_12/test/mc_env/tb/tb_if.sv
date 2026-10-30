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

logic   [7:0]                   bank_radd_set_time_o;
logic   [3:0]                   cadd_set_time_o     ;
logic   [7:0]                   r_cas_set_time_o    ;
logic   [7:0]                   w_cas_set_time_o    ;
logic   [7:0]                   cas_wrrdy_time_o    ;

logic   [4:0]                   mc_tras_cfg     ='d12  ;
logic   [3:0]                   mc_trp_cfg      ='d5   ;
logic   [5:0]                   mc_trc_cfg      ='d17  ;
logic   [4:0]                   mc_trcd_cfg     ='d6   ;
logic   [0:0]                   mc_trtp_cfg     ='d0   ;
logic   [3:0]                   mc_twr_cfg      ='d6   ;
logic   [2:0]                   mc_twtr_cfg     ='d3   ;
logic   [3:0]                   mc_trtw_cfg     ='d4   ;
logic   [1:0]                   mc_trcb_cfg     ='d1   ;   //20250716

logic   [12:0]                  rf_row_num         = 'd7360; 
logic   [31:0]                  rf_single_interval = 'h186a000;
logic   [2:0]                   rf_gear_id         = 'd0;        
logic                           rf_gear_up_en      = 'd0;
logic                           ras_clr            = 'd0;          
logic                           dbg_data_store_en  = 'd1;
logic                           mc2phy_dram0_mask       ;
logic                           mc2phy_dram1_mask       ;
logic                           mc2phy_dram2_mask       ;
logic                           mc2phy_dram3_mask       ;
logic                           xbank_en            = 0 ;
logic   [7:0]                   bankmap             = 8'b11_10_01_00;
logic                           loopback_en         = 0 ;

//--------------------feedthrough---------------
logic                           clk_in_asic_in  ;  
logic                           ls_en_asic_in = 1;
logic                           reset_n_asic_in ;
logic                           clk_in_asic_out ;
logic                           ls_en_asic_out  ;
logic                           reset_n_asic_out;
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

logic   [`CSL_ERR_TH_WIDTH-1:0]  csl_err_threshold=16;                       
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
logic   [49:0]                   monitor_signals     ;

//---------- add by hy 20241223 -----------------
logic                           monitor_enable=1;

//---------- add by hy 20250108 -----------------
logic                           mc_bank_success;


//---------- add by hy 20241227 -----------------
logic                           rf_request;
assign                          rf_request = `MC_TOP.frame2array_u.rf_req;

logic   [31:0]                  rf_cnt;
assign                          rf_cnt = `MC_TOP.frame2array_u.rf_cnt;

logic   [4:0]                   fsm;
assign                          fsm = `MC_TOP.frame2array_u.FSM_CS;
logic   [4:0]                   fsm_ns;
assign                          fsm_ns = `MC_TOP.frame2array_u.FSM_NS;
logic   [13:0]                  gradd_n;
assign                          gradd_n = `MC_TOP.frame2array_u.gradd_n;
logic   [7:0]                   gcadd;
assign                          gcadd = `MC_TOP.frame2array_u.gcadd;
logic                           wl_rd_num;
//assign                          wl_rd_num = `MC_TOP.bist_scan_top_u.bist_scan_u.U_wl_scan.single_pattern_rd_times_cnt_inner;
logic                           wl_scan_row_status;
//assign                          wl_scan_row_status = `MC_TOP.bist_scan_top_u.bist_scan_u.U_wl_scan.wl_scan_row_status;
logic                           wl_single_rd_done;
//assign                          wl_single_rd_done = `MC_TOP.bist_scan_top_u.bist_scan_u.U_wl_scan.wl_single_rd_done;
//----------add by zjh 20241217------------------
logic   [0:0]                   mc_rf_start_sel ='d0      ;
logic   [31:0]                  rf_start_time   ='d10     ;
logic   [31:0]                  rf_period       =32'h30d4000;//64ms
logic   [0:0]                   mc_rf_period_sel='d0      ;
//logic                           mc_sys_rst_n;
//logic                           mc_apb_rst_n;

logic                           rf_range_change_en='d0;
logic                           pre_precharge='d0;
logic                           page_mode_switch='d0;
logic   [`ROW_ADDR_WIDTH*2-1:0]  rf_addr={13'h0,13'h1cbf};

logic                           pe_slverr;
//assign                          pe_slverr=`MC_WRAPPER.pe_apb_pslverr;
logic                           pe_penable;
//assign                          pe_penable=`MC_WRAPPER.pe_apb_enable;
logic                           pe_psel;
//assign                          pe_psel=`MC_WRAPPER.pe_apb_sel;

logic                           soc_slverr;
assign                          soc_slverr=`MC_SUBSYS.apb_pslverr;
logic                           soc_penable;
assign                          soc_penable=`MC_SUBSYS.apb_enable;
logic                           soc_psel;
assign                          soc_psel=`MC_SUBSYS.apb_sel;
//----------add by zjh 20241217 end------------------
logic                           cnt_load    =   'd1 ;
logic   [5:0]                   div_cnt     =   'd0 ;      
logic                           rst_ongoing_flag = 0;

logic                           apb_rst_n           ;
assign                          apb_rst_n   =   mc_tb.apb_rst_n ;

logic                           mc_sys_rst_n;
logic                           mc_apb_rst_n;

logic                           pclk                ;
assign                          pclk        =   mc_tb.pclk ;

logic                           wrapper_clk,wrapper_apb_clk;
assign                          wrapper_clk = `MC_SUBSYS.clk;
assign                          wrapper_apb_clk = `MC_SUBSYS.apb_clk;

logic [`BANK_ADDR_WIDTH-1:0]    gcas_wr;
assign                          gcas_wr = `MC_SUBSYS.gcas_wr;

logic [`BANK_ADDR_WIDTH-1:0]    gcas_rd;
assign                          gcas_rd = `MC_SUBSYS.gcas_rd;

logic                           ecc_clk,ecc_top_clk;
`ifndef CHKBIT
assign                          ecc_clk = `MC_SUBSYS.inst0.mc_ecc_wrapper_u.clk;
assign                          ecc_top_clk = `MC_SUBSYS.inst0.mc_ecc_wrapper_u.mc_ecc_top_u.clk;
`endif

logic                           bist_clk;
assign                          bist_clk = `MC_TOP.bist_scan_top_u.bist_scan_u.clk;

//------------ rtl inner clk for clk check -------------
logic                           mc_fram_debug_clk   ;
assign                          mc_fram_debug_clk = `MC_WRAPPER.mc_frame_debug_u.clk;

logic                           mc_top_clk          ;
assign                          mc_top_clk  =   `MC_TOP.clk;

logic                           mc_top_apb_clk      ;
assign                          mc_top_apb_clk  =   `MC_TOP.apb_clk;

logic                           apb2reg_mc_soc_top_cfg_if_apb_clk;
assign                          apb2reg_mc_soc_top_cfg_if_apb_clk  = `MC_TOP_APB.pclk;

logic                           apb2reg_mc_pe_top_cfg_if_apb_clk;
//assign                          apb2reg_mc_pe_top_cfg_if_apb_clk  = `MC_TOP.apb2reg_mc_pe_top_cfg_if_u.pclk;

logic                           mc_frame2frame_clk  ;
assign                          mc_frame2frame_clk = `MC_TOP.mc_frame2frame_u.clk;

logic                           frame_arbiter_clk   ;
assign                          frame_arbiter_clk = `MC_TOP.frame_arbiter_u.clk;

logic                           mc_timeout_clk      ;
assign                          mc_timeout_clk  = `MC_TOP.mc_timeout_u.clk;

logic                           frame2array_clk     ;
assign                          frame2array_clk = `MC_TOP.frame2array_u.clk;

logic                           U0_mc_ctrl_DW_sync_clk;
assign                          U0_mc_ctrl_DW_sync_clk = `MC_TOP.U0_mc_ctrl_DW_sync.clk_d;
logic                           U1_mc_ctrl_DW_sync_clk;
assign                          U1_mc_ctrl_DW_sync_clk = `MC_TOP.U1_mc_ctrl_DW_sync.clk_d;
logic                           U2_mc_ctrl_DW_sync_clk;
assign                          U2_mc_ctrl_DW_sync_clk = `MC_TOP.U2_mc_ctrl_DW_sync.clk_d;

logic                           ipdb_pulse2pulse_inst_u0_clk;
assign                          ipdb_pulse2pulse_inst_u0_clk = `MC_TOP.ipdb_pulse2pulse_inst_u0.clk2;
logic                           ipdb_pulse2pulse_inst_u1_clk;
assign                          ipdb_pulse2pulse_inst_u1_clk = `MC_TOP.ipdb_pulse2pulse_inst_u1.clk2;
logic                           ipdb_pulse2pulse_inst_u2_clk;
assign                          ipdb_pulse2pulse_inst_u2_clk = `MC_TOP.ipdb_pulse2pulse_inst_u2.clk2;
logic                           ipdb_pulse2pulse_inst_u3_clk;
assign                          ipdb_pulse2pulse_inst_u3_clk = `MC_TOP.ipdb_pulse2pulse_inst_u3.clk2;

logic                           ipdb_pulse2pulse_inst_u0_apb_clk;
assign                          ipdb_pulse2pulse_inst_u0_apb_clk = `MC_TOP.ipdb_pulse2pulse_inst_u0.clk1;
logic                           ipdb_pulse2pulse_inst_u1_apb_clk;
assign                          ipdb_pulse2pulse_inst_u1_apb_clk = `MC_TOP.ipdb_pulse2pulse_inst_u1.clk1;
logic                           ipdb_pulse2pulse_inst_u2_apb_clk;
assign                          ipdb_pulse2pulse_inst_u2_apb_clk = `MC_TOP.ipdb_pulse2pulse_inst_u2.clk1;
logic                           ipdb_pulse2pulse_inst_u3_apb_clk;
assign                          ipdb_pulse2pulse_inst_u3_apb_clk = `MC_TOP.ipdb_pulse2pulse_inst_u3.clk1;

logic                           bist_scan_clk,dram_init_clk,bist_rescan_clk,wl_clkgate_clk,rst_mc_n_clk,rst_apb_n_clk;
assign                          bist_scan_clk = `MC_TOP.bist_scan_top_u.bist_scan_u.clk;
assign                          dram_init_clk = `MC_TOP.dram_init_wr_aux_u.clk;
assign                          bist_rescan_clk = `MC_TOP.U_bist_rescan_top_aux.U_bist_rescan_aux.clk;
assign                          wl_clkgate_clk = `MC_TOP.wl_clkgate_aux_u.clk_i;
assign                          rst_mc_n_clk = `MC_SUBSYS.u_rst_mc_n.clk_i;
assign                          rst_apb_n_clk = `MC_SUBSYS.u_rst_apb_n.clk_i;

logic                           global_bist_clr_sync_apb_clk,global_mc_bist_start_sync_apb_clk,global_mc_rescan_start_sync_apb_clk;   
assign                          global_bist_clr_sync_apb_clk = `MC_TOP.u_global_bist_clr_sync.clk1;
assign                          global_mc_bist_start_sync_apb_clk = `MC_TOP.u_global_mc_bist_start_sync.clk1;
assign                          global_mc_rescan_start_sync_apb_clk = `MC_TOP.u_global_mc_rescan_start_sync.clk1;

logic                           global_bist_clr_sync_mc_clk,global_mc_bist_start_sync_mc_clk,global_mc_rescan_start_sync_mc_clk;   
assign                          global_bist_clr_sync_mc_clk = `MC_TOP.u_global_bist_clr_sync.clk2;
assign                          global_mc_bist_start_sync_mc_clk = `MC_TOP.u_global_mc_bist_start_sync.clk2;
assign                          global_mc_rescan_start_sync_mc_clk = `MC_TOP.u_global_mc_rescan_start_sync.clk2;
//----------------------------------------

logic   [2:0]                   reset_chk_times = 3'b000;    //used to reset check
logic                           reset_vseq=1'b0;

logic                           clk_freq_en =   1   ;

//logic   s_cnt_load_syn;
//assign  s_cnt_load_syn=mc_tb.m_wl_freq_erase.s_cnt_load_syn;

logic                           timeout_case    =   0;

logic                           mc_en;
assign                          mc_en=`MC_TOP.frame2array_u.mc_en;
logic                           wl_vmc_en;
logic                           bl_vmc_en;
assign  wl_vmc_en   =   `MC_TOP_APB.mc_wl_vmc_en_o;
assign  bl_vmc_en   =   `MC_TOP_APB.mc_bl_vmc_en_o;

logic                           csl_scan_working;
logic                           wl_scan_working;
assign  csl_scan_working    = `MC_TOP.bist_scan_top_u.bist_scan_u.csl_scan_working;
assign  wl_scan_working     = `MC_TOP.bist_scan_top_u.bist_scan_u.wl_scan_working;
logic   bist_test_en    =   1'b0;
logic   debug_test_en   =   1'b0;      
logic   error_inject    =   1'b0;      
logic   case_finish_flag =  1'b0;
logic   bist_finish_reg ;
//assign  bist_finish_reg=`MC_TOP_APB.bist_finish_i ;
logic   bist_finish_int;
assign  bist_finish_int    = `MC_SUBSYS.bist_finish_intr;
logic   bist_csl_fail;
assign  bist_csl_fail=`MC_TOP.bist_scan_top_u.bist_scan_u.bist_csl_fail;
//logic   [5:0]   s_div_cnt;       
//assign  s_div_cnt=mc_tb.m_wl_freq_erase.s_div_cnt;
logic   cycle_640_check_en  = 0;
//logic   csl_up_done;
//assign  csl_up_done=`MC_TOP.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_row_up_single_done;

logic   csl_part0_done;
logic   csl_part1_done;
logic   csl_part2_done;
logic   csl_part3_done;
logic   csl_part4_done;
//assign  csl_part0_done=`MC_TOP.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_row_part0_single_done;
//assign  csl_part1_done=`MC_TOP.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_row_part1_single_done;
//assign  csl_part2_done=`MC_TOP.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_row_part2_single_done;
//assign  csl_part3_done=`MC_TOP.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_row_part3_single_done;
//assign  csl_part4_done=`MC_TOP.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_row_part4_single_done;
//2025/2/19 add
logic   bist_rescan_finish;//O
logic   bist_rescan_success;//0
logic   global_mc_rescan_start=0;//I
logic   [3:0]                   bist_rescan_num=3;//I
logic   [3:0]                   bist_wl_scan_single_pattern_rd_num=0;//I
logic                           rf_period_up_en=0;//I
logic   mc_dram_init_wr_finish;//O
assign  mc_dram_init_wr_finish  =   `MC_TOP.dram_init_wr_aux_u.mc_dram_init_finish;
logic   mc_bist_csl_vmc_en=1;//I

logic   dump_ready;
logic   global_bist_clr=0;
`ifdef NO_INIT
    logic  global_dram_init_en=1'b0;
`else
    logic  global_dram_init_en=1'b1;
`endif
logic   global_rf_cnt_clr = 1'b1; 
//for gating check
logic   bist_inner_global_mc_bist_en;
assign  bist_inner_global_mc_bist_en = `MC_TOP.global_mc_bist_en_tmp;

//---- for arbiter check ---
logic [5:0] arb_s_valid_i;
assign arb_s_valid_i = `MC_TOP.frame_arbiter_u.s_tvalid[5:0];

logic [1793:0]  arb_s_data_i;
assign arb_s_data_i = `MC_TOP.frame_arbiter_u.s_tdata[1793:0];


logic [271:0]   arb_m_rdata_i;
assign arb_m_rdata_i = `MC_TOP.frame_arbiter_u.array_rdata[271:0];

logic   arb_m_rdata_vld_i;
assign arb_m_rdata_vld_i = `MC_TOP.frame_arbiter_u.array_rvalid;

logic arb_m_ready_i;
assign arb_m_ready_i = `MC_TOP.frame_arbiter_u.m_tready;

logic [5:0] arb_port_choose;
assign arb_port_choose = `MC_TOP.frame_arbiter_u.port_choose_array;

logic [5:0] arb_s_ready_o;
assign arb_s_ready_o = `MC_TOP.frame_arbiter_u.s_tready[5:0];

logic arb_m_vld_o;
assign arb_m_vld_o = `MC_TOP.frame_arbiter_u.m_tvalid;

logic [298:0] arb_m_data_o;
assign arb_m_data_o = `MC_TOP.frame_arbiter_u.m_tdata[298:0];

logic [4:0] arb_s_rvld_o;
assign arb_s_rvld_o = {`MC_TOP.frame_arbiter_u.rescan_rvalid, `MC_TOP.frame_arbiter_u.func_rvalid, `MC_TOP.frame_arbiter_u.bist_wl_rvalid, `MC_TOP.frame_arbiter_u.bist_csl_rvalid, `MC_TOP.frame_arbiter_u.bist_path_rvalid};

logic [272*5-1:0]   arb_s_rdata_o;
assign arb_s_rdata_o = {`MC_TOP.frame_arbiter_u.rescan_rdata, `MC_TOP.frame_arbiter_u.func_rdata, `MC_TOP.frame_arbiter_u.bist_wl_rdata, `MC_TOP.frame_arbiter_u.bist_csl_rdata, `MC_TOP.frame_arbiter_u.bist_path_rdata};
//--------------------------


logic               global_ecc_en   = 1;
logic               global_ecc_sel  = 0;
logic               invert_en       = 0 ;
logic               chkbit          = 0 ;
logic               ce_of_intr          ;
logic               uce_intr            ;
logic               rdrdy_mask_en   = 0 ;
logic               b_rdrdy_n_phy_0     ;
logic               b_rdrdy_n_phy_1     ;
assign              b_rdrdy_n_phy_0 = mc_tb.rdrdy_n_phy_0;
assign              b_rdrdy_n_phy_1 = mc_tb.rdrdy_n_phy_1;
logic[1:0]          b_bist_scan_cs      ;
//assign              b_bist_scan_cs  = `MC_TOP.bist_scan_top_u.bist_scan_u.SCAN_CS[1:0];//need change
logic[1:0]          b_bist_scan_ns      ;
//assign              b_bist_scan_ns  = `MC_TOP.bist_scan_top_u.bist_scan_u.SCAN_NS[1:0];

logic               gcas_wr_array_0;
logic               gcas_wr_array_1;
logic     [12:0]    gradd_array_0;
logic     [7:0]     gcadd_array_0;
`ifndef SIM_COV
    assign              gcas_wr_array_0 = mc_tb.u_phy_group.gcas_wr_array_0;
    assign              gcas_wr_array_1 = mc_tb.u_phy_group.gcas_wr_array_1;
    assign              gradd_array_0 = mc_tb.u_phy_group.gradd_array[12:0];
    assign              gcadd_array_0 = mc_tb.u_phy_group.gcadd_array[7:0];
`else
    assign              gcas_wr_array_0 = mc_tb.u_quad_group.g_cas_wr_i_BK0;
    assign              gcas_wr_array_1 = mc_tb.u_quad_group.g_cas_wr_i_BK1;
    assign              gradd_array_0   = mc_tb.u_quad_group.g_radd_i_BK;
    assign              gcadd_array_0   = mc_tb.u_quad_group.g_cadd_i_BK;
`endif
logic               mc_apb_rst_ok;
assign              mc_apb_rst_ok = `MC_SUBSYS.mc_apb_rst_ok;

logic               debug_rd_without_wr = 0;
logic               mc_fake_bresp_en;
logic               bnksel_n_array_d0_0;
logic               bnksel_n_array_d1_0;
logic               bnksel_n_array_d2_0;
logic               bnksel_n_array_d3_0;
logic     [7:0]     gcadd_asic_0;
logic               gcas_rd_en_asic_d0_0;
logic               gcas_rd_en_asic_d1_0;
logic               gcas_rd_en_asic_d2_0;
logic               gcas_rd_en_asic_d3_0;
logic               gcas_rd_array_d0_0;
logic               gcas_rd_array_d1_0;
logic               gcas_rd_array_d2_0;
logic               gcas_rd_array_d3_0;
logic               gcas_wr_en_asic_d0_0;
logic               gcas_wr_en_asic_d1_0;
logic               gcas_wr_en_asic_d2_0;
logic               gcas_wr_en_asic_d3_0;
logic               gcas_wr_array_d0_0;
logic               gcas_wr_array_d1_0;
logic               gcas_wr_array_d2_0;
logic               gcas_wr_array_d3_0;
logic [271:0]       wdata_asic_0;
`ifndef SIM_COV
    assign              bnksel_n_array_d0_0 = mc_tb.u_phy_group.bnksel_n_array_0;
    assign              bnksel_n_array_d1_0 = mc_tb.u_phy_group.bnksel_n_array_1;
  //assign              bnksel_n_array_d2_0 = mc_tb.u_phy_group.bnksel_n_array_d2_0;
    assign              gcadd_asic_0 = mc_tb.u_phy_group.gcadd_asic[7:0];
    assign              gcas_rd_en_asic_d0_0 = mc_tb.u_phy_group.gcas_rd_en_asic_0;
    assign              gcas_rd_en_asic_d1_0 = mc_tb.u_phy_group.gcas_rd_en_asic_1;
  //assign              gcas_rd_en_asic_d2_0 = mc_tb.u_phy_group.gcas_rd_en_asic_d2_0;
    assign              gcas_rd_array_d0_0 = mc_tb.u_phy_group.gcas_rd_array_0;
    assign              gcas_rd_array_d1_0 = mc_tb.u_phy_group.gcas_rd_array_1;
  //assign              gcas_rd_array_d2_0 = mc_tb.u_phy_group.gcas_rd_array_d2_0;
    assign              gcas_wr_en_asic_d0_0 = mc_tb.u_phy_group.gcas_wr_en_asic_0;
    assign              gcas_wr_en_asic_d1_0 = mc_tb.u_phy_group.gcas_wr_en_asic_1;
  //assign              gcas_wr_en_asic_d2_0 = mc_tb.u_phy_group.gcas_wr_en_asic_d2_0;
    assign              gcas_wr_array_d0_0 = mc_tb.u_phy_group.gcas_wr_array_0;
    assign              gcas_wr_array_d1_0 = mc_tb.u_phy_group.gcas_wr_array_1;
  //assign              gcas_wr_array_d2_0 = mc_tb.u_phy_group.gcas_wr_array_d2_0;
    assign              wdata_asic_0 = mc_tb.u_phy_group.wdata_asic[271:0];
`else
    assign              bnksel_n_array_d0_0  = mc_tb.u_quad_group.bnksel_n_i_bk0;
    assign              bnksel_n_array_d1_0  = mc_tb.u_quad_group.bnksel_n_i_bk1;
    assign              bnksel_n_array_d2_0  = mc_tb.u_quad_group.bnksel_n_i_bk2;
    assign              bnksel_n_array_d3_0  = mc_tb.u_quad_group.bnksel_n_i_bk3;
    assign              gcadd_asic_0         = mc_tb.u_quad_group.g_cadd_i_BK;
    assign              gcas_rd_en_asic_d0_0 = mc_tb.u_quad_group.g_cas_rd_i_BK0;
    assign              gcas_rd_en_asic_d1_0 = mc_tb.u_quad_group.g_cas_rd_i_BK1;
    assign              gcas_rd_en_asic_d2_0 = mc_tb.u_quad_group.g_cas_rd_i_BK2;
    assign              gcas_rd_en_asic_d3_0 = mc_tb.u_quad_group.g_cas_rd_i_BK3;
    assign              gcas_rd_array_d0_0   = mc_tb.u_quad_group.g_cas_rd_i_BK0;
    assign              gcas_rd_array_d1_0   = mc_tb.u_quad_group.g_cas_rd_i_BK1;
    assign              gcas_rd_array_d2_0   = mc_tb.u_quad_group.g_cas_rd_i_BK2;
    assign              gcas_rd_array_d3_0   = mc_tb.u_quad_group.g_cas_rd_i_BK3;
    assign              gcas_wr_en_asic_d0_0 = mc_tb.u_quad_group.g_cas_wr_i_BK0;
    assign              gcas_wr_en_asic_d1_0 = mc_tb.u_quad_group.g_cas_wr_i_BK1;
    assign              gcas_wr_en_asic_d2_0 = mc_tb.u_quad_group.g_cas_wr_i_BK2;
    assign              gcas_wr_en_asic_d3_0 = mc_tb.u_quad_group.g_cas_wr_i_BK3;
    assign              gcas_wr_array_d0_0   = mc_tb.u_quad_group.g_cas_wr_i_BK0;
    assign              gcas_wr_array_d1_0   = mc_tb.u_quad_group.g_cas_wr_i_BK1;
    assign              gcas_wr_array_d2_0   = mc_tb.u_quad_group.g_cas_wr_i_BK2;
    assign              gcas_wr_array_d3_0   = mc_tb.u_quad_group.g_cas_wr_i_BK3;
    assign              wdata_asic_0         = m_array_agent_if.wdl;
`endif
logic csl_single_pattern_done;
assign csl_single_pattern_done = `MC_TOP.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_single_pattern_done;
logic wl_single_pattern_done;
assign wl_single_pattern_done = `MC_TOP.bist_scan_top_u.bist_scan_u.U_wl_scan_top.wl_single_pattern_done;
logic [2:0] bist_scan_state;
assign bist_scan_state = mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.SCAN_CS[2:0];
logic close_page;
assign close_page = mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.mc_frame2frame_u.close_page;
assign  mc_rf_cfg_sel_o = `MC_TOP_APB.mc_rf_cfg_sel_o;
assign  mc_en_o = `MC_TOP_APB.mc_en_o;
assign  mon_mc_rvalid = `MC_WRAPPER.mc_back_rvalid;
logic [1:0]  mon_mc_rdata;
assign  mon_mc_rdata[1:0] = `MC_WRAPPER.mc_back_rdata[1:0];
logic inner_precharge;
assign inner_precharge = mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.frame2array_u.inner_precharge;
logic mc_frame_rdy;
assign mc_frame_rdy = mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.frame2array_u.mc_frame_rdy;
assign push_full = mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.frame2array_u.U_rdata_async_fifo.push_full;
endinterface
`endif
