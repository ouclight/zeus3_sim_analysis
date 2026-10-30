    parameter   MC_SHORT_MODE = 2;

`ifdef CHKBIT
    parameter   USE_MC_ECC = 0;
`else
    parameter   USE_MC_ECC = 1;
`endif

wire                            soc_apb_sel   ;
wire                            soc_apb_enable;
wire                            soc_apb_write ;
wire    [`APB_ADDR_WIDTH-1:0]   soc_apb_addr  ;
wire    [`APB_DATA_WIDTH-1:0]   soc_apb_wdata ;
wire    [`APB_DATA_WIDTH-1:0]   soc_apb_rdata ;
wire                            soc_apb_pready;

genvar M;
generate
for (M=0;M<1;M=M+1) begin
    assign apb_if_gen[M].m_svt_apb_if.pclk      = pclk  ;
    assign apb_if_gen[M].m_svt_apb_if.presetn   = apb_rst_n;
    assign apb_if_gen[M].m_svt_apb_if.pslverr[0]= 'h0   ;
    assign apb_if_gen[M].m_svt_apb_if.pready[0] = soc_apb_pready    ;
    if(M==0)begin
        assign apb_if_gen[M].m_svt_apb_if.prdata[0] = soc_apb_rdata ;
    end
    else begin
        assign apb_if_gen[M].m_svt_apb_if.prdata[0] = soc_apb_rdata ;
    end
end
endgenerate

assign  soc_apb_sel     =   apb_if_gen[0].m_svt_apb_if.psel     ;
assign  soc_apb_enable  =   apb_if_gen[0].m_svt_apb_if.penable  ;
assign  soc_apb_write   =   apb_if_gen[0].m_svt_apb_if.pwrite   ;
assign  soc_apb_addr    =   apb_if_gen[0].m_svt_apb_if.paddr    ;
assign  soc_apb_wdata   =   apb_if_gen[0].m_svt_apb_if.pwdata   ;

assign  u_tb_if.clk_in_asic_in = clk_pll;
assign  u_tb_if.reset_n_asic_in = u_tb_if.mc_sys_rst_n;
mc_subsys_top#(
    .MC_SHORT_MODE(MC_SHORT_MODE),
    .USE_MC_ECC(USE_MC_ECC)
    )m_mc_subsys_top(
    //{{{
    .clk                        (clk                            ),
    .rst_n                      (rst_n                          ),
    .ras_clr                    (u_tb_if.ras_clr                ),
    .mc_id                      (u_tb_if.mc_id_soc              ),

    //-----refresh
    .mc_rf_start_en             (u_tb_if.mc_rf_start            ),
    .global_rf_sel_en           (u_tb_if.global_rf_sel_en       ),
    .global_rf_sel              (u_tb_if.global_rf_sel          ),
    .global_mc_bist_start       (u_tb_if.global_mc_bist_start   ),
    .global_mc_bist_en          (u_tb_if.global_mc_bist_en      ),
    .global_mc_rescan_start     (u_tb_if.global_mc_rescan_start ),

    .global_dram_init_en        (u_tb_if.global_dram_init_en    ),//(u_tb_if.global_dram_init_en[0] ),
    .global_bist_clr            (u_tb_if.global_bist_clr        ),
    .bist_rescan_num            (u_tb_if.bist_rescan_num        ),
    .mc_scan_timeout_en         (u_tb_if.mc_scan_timeout_en     ),
    .mc_bist_csl_vmc_en         (u_tb_if.mc_bist_csl_vmc_en     ),
    .rf_range_change_en         (u_tb_if.rf_range_change_en     ),
    .pre_precharge              (u_tb_if.pre_precharge          ),
    .page_mode_switch           (u_tb_if.page_mode_switch       ),
    .rf_addr                    (u_tb_if.rf_addr                ),
    .dbg_data_store_en          (u_tb_if.dbg_data_store_en      ),
    .mc2phy_dram_mask           ({u_tb_if.mc2phy_dram3_mask, u_tb_if.mc2phy_dram2_mask, u_tb_if.mc2phy_dram1_mask, u_tb_if.mc2phy_dram0_mask}),
    .global_rf_cnt_clr          (u_tb_if.global_rf_cnt_clr      ),//(u_tb_if.global_dram_init_en[1] ),        
    //-----apb
    .apb_clk                    (pclk                           ),
    .apb_rst_n                  (apb_rst_n                      ),
    .apb_sel                    (soc_apb_sel                    ),
    .apb_enable                 (soc_apb_enable                 ),
    .apb_write                  (soc_apb_write                  ),
    .apb_addr                   (soc_apb_addr                   ),
    .apb_wdata                  (soc_apb_wdata                  ),
    .apb_rdata                  (soc_apb_rdata                  ),
    .apb_pslverr                (soc_apb_pslverr                ),
    .apb_pready                 (soc_apb_pready                 ),
    
    //-----ram
    .bnksel_n                   (m_array_agent_if.bnksel_n      ),
    .gradd_n                    (m_array_agent_if.gradd_n       ),
    .gcas_wr                    (m_array_agent_if.gcas_wr       ),
    .gcas_rd                    (m_array_agent_if.gcas_rd       ),
    .gcadd                      (m_array_agent_if.gcadd         ),
    .wdl                        (m_array_agent_if.wdl           ),
    .wdl_oe                     (m_array_agent_if.wdl_oe        ),
    .rdrdy_n                    (m_array_agent_if.rdrdy_n       ),
    .rdl                        (m_array_agent_if.rdl           ),

    //-----config
    .bank_radd_set_time_o       (u_tb_if.bank_radd_set_time_o   ),
    .cadd_set_time_o            (u_tb_if.cadd_set_time_o        ),
    .r_cas_set_time_o           (u_tb_if.r_cas_set_time_o       ),
    .w_cas_set_time_o           (u_tb_if.w_cas_set_time_o       ),

    .mc_tras_cfg                (u_tb_if.mc_tras_cfg            ),
    .mc_trp_cfg                 (u_tb_if.mc_trp_cfg             ),
    .mc_trc_cfg                 (u_tb_if.mc_trc_cfg             ),
    .mc_trcd_cfg                (u_tb_if.mc_trcd_cfg            ),
    .mc_trtp_cfg                (u_tb_if.mc_trtp_cfg            ),
    .mc_twr_cfg                 (u_tb_if.mc_twr_cfg             ),
    .mc_twtr_cfg                (u_tb_if.mc_twtr_cfg            ),
    .mc_trtw_cfg                (u_tb_if.mc_trtw_cfg            ),
    .mc_trcb_cfg                (u_tb_if.mc_trcb_cfg            ),   //default 1: gcas_wr/rd switch bank dly 1cycle 
    //-----frame
    .hub_frame_vld              (m_frame_agent_if.mc_frame_vld  ),
    .hub_frame_rdy              (m_frame_agent_if.mc_frame_rdy  ),
    .hub_frame_data             (m_frame_agent_if.mc_frame_data ),
    `ifndef COMMON_MC
    .mc_bresp                   (m_frame_agent_if.mc_bresp      ),
    `endif
    .mc_bresp_vld               (m_frame_agent_if.mc_bresp_vld  ),
    .mc_rvalid                  (m_frame_agent_if.mc_rvalid     ),
    .mc_rdata                   (m_frame_agent_if.mc_rdata      ),
    .mc_rresp                   (m_frame_agent_if.mc_rresp      ),

    //-----bist
    .csl_err_threshold          (u_tb_if.csl_err_threshold      ),
    .bist_wl_scan_single_pattern_rd_num (u_tb_if.bist_wl_scan_single_pattern_rd_num),
    .bist_rescan_success        (u_tb_if.bist_rescan_success    ),
    `ifndef COMMON_MC
    .bist_rescan_finish_intr    (u_tb_if.bist_rescan_finish     ),
    `else 
    .bist_rescan_finish         (u_tb_if.bist_rescan_finish     ),
    `endif
    .mc_timeout_th              (u_tb_if.mc_timeout_th          ),
    .mc_rf_start_sel            (u_tb_if.mc_rf_start_sel        ),//0:sel input rf start,1:sel mc local cfg
    .rf_start_time              (u_tb_if.rf_start_time          ),
    .mc_rf_period_sel           (u_tb_if.mc_rf_period_sel       ),  //0:sel input rf period,1:sel mc local,default 0
    .rf_row_num                 (u_tb_if.rf_row_num             ),    
    .rf_single_interval         (u_tb_if.rf_single_interval     ),
    .rf_gear_id                 (u_tb_if.rf_gear_id             ),
    .rf_gear_up_en              (u_tb_if.rf_gear_up_en          ),
    .mc_sys_rst_ok              (u_tb_if.mc_sys_rst_n           ),
    .mc_apb_rst_ok              (u_tb_if.mc_apb_rst_n           ),
    .bist_finish_intr           (u_tb_if.bist_finish_intr       ),
    .mc_timeout_intr            (u_tb_if.mc_timeout_intr        ),
    .mc_bank_success            (u_tb_if.mc_bank_success        ),
    .mc_ce_overflow_intr        (u_tb_if.ce_of_intr             ),
    .mc_uce_intr                (u_tb_if.uce_intr               ),
   
    
    .monitor_signals            (u_tb_if.monitor_signals           )
);      //}}}
