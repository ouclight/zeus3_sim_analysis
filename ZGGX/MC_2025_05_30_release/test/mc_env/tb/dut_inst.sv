wire                            soc_apb_sel   ;
wire                            soc_apb_enable;
wire                            soc_apb_write ;
wire    [`APB_ADDR_WIDTH-1:0]   soc_apb_addr  ;
wire    [`APB_DATA_WIDTH-1:0]   soc_apb_wdata ;
wire    [`APB_DATA_WIDTH-1:0]   soc_apb_rdata ;


genvar M;
generate
for (M=0;M<1;M=M+1) begin
    assign apb_if_gen[M].m_svt_apb_if.pclk      = pclk  ;
    assign apb_if_gen[M].m_svt_apb_if.presetn   = apb_rst_n;
    assign apb_if_gen[M].m_svt_apb_if.pslverr[0]= 'h0   ;
    assign apb_if_gen[M].m_svt_apb_if.pready[0] = 'h1   ;
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

mc_wrapper_aux m_mc_wrapper_aux(
    //{{{
    .clk                        (clk                            ),
    .rst_n                      (rst_n                          ),
    .mc_id                      (u_tb_if.mc_id_soc              ),

    //-----refresh
    .mc_rf_start_en             (u_tb_if.mc_rf_start            ),
    .global_rf_sel_en           (u_tb_if.global_rf_sel_en       ),
    .global_rf_sel              (u_tb_if.global_rf_sel          ),
    .mc_rf_start_sel            (u_tb_if.mc_rf_start_sel        ),//0:sel input rf start,1:sel mc local cfg
    .rf_start_time              (u_tb_if.rf_start_time          ),
    .rf_period                  (u_tb_if.rf_period              ),
    .mc_rf_period_sel           (u_tb_if.mc_rf_period_sel       ),  //0:sel input rf period,1:sel mc local,default 0
    .rf_range_change_en         (u_tb_if.rf_range_change_en     ),
    .rf_addr                    (u_tb_if.rf_addr                ),
    .rf_period_up_en            (u_tb_if.rf_period_up_en        ),  //add by hy @20250212

    //-----ecc
    .global_ecc_en              (u_tb_if.global_ecc_en          ),
    .global_ecc_sel             (u_tb_if.global_ecc_sel         ),

    .global_dram_init_finish_intr   (u_tb_if.global_init_finish ),

    //-----apb
    .apb_clk                    (pclk                           ),
    .apb_rst_n                  (apb_rst_n                      ),
    .apb_sel                    (soc_apb_sel                    ),
    .apb_enable                 (soc_apb_enable                 ),
    .apb_write                  (soc_apb_write                  ),
    .apb_addr                   (soc_apb_addr                   ),
    .apb_wdata                  (soc_apb_wdata                  ),
    .apb_rdata                  (soc_apb_rdata                  ),

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

    //-----frame
    .hub_frame_vld              (m_frame_agent_if.mc_frame_vld  ),
    .hub_frame_rdy              (m_frame_agent_if.mc_frame_rdy  ),
    .hub_frame_data             (m_frame_agent_if.mc_frame_data ),
    .mc_bresp_rdy               (m_frame_agent_if.mc_bresp_rdy  ),
    .mc_bresp                   (m_frame_agent_if.mc_bresp      ),
    .mc_bresp_vld               (m_frame_agent_if.mc_bresp_vld  ),
    .mc_rvalid                  (m_frame_agent_if.mc_rvalid     ),
    .mc_rdata                   (m_frame_agent_if.mc_rdata      ),

    //-----config
    .bank_radd_set_time_o       (u_tb_if.bank_radd_set_time_o   ),
    .cadd_set_time_o            (u_tb_if.cadd_set_time_o        ),
    .r_cas_set_time_o           (u_tb_if.r_cas_set_time_o       ),
    .w_cas_set_time_o           (u_tb_if.w_cas_set_time_o       ),

    .mc_tras_cfg                (u_tb_if.mc_tras_cfg            ),
    .mc_trp_cfg                 (u_tb_if.mc_trp_cfg             ),
    .mc_trc_cfg                 (u_tb_if.mc_trc_cfg             ),
    //.mc_trcd_r_cfg              (u_tb_if.mc_trcd_r_cfg          ),
    //.mc_trcd_w_cfg              (u_tb_if.mc_trcd_w_cfg          ),
    .mc_trcd_cfg                (u_tb_if.mc_trcd_cfg          ),
    .mc_trtp_cfg                (u_tb_if.mc_trtp_cfg            ),
    .mc_twr_cfg                 (u_tb_if.mc_twr_cfg             ),
    .mc_twtr_cfg                (u_tb_if.mc_twtr_cfg            ),
    .mc_trtw_cfg                (u_tb_if.mc_trtw_cfg            ),

    //-----bist
    .global_mc_bist_start       (u_tb_if.global_mc_bist_start   ),
    .global_mc_bist_en          (u_tb_if.global_mc_bist_en      ),
    .csl_err_threshold          (u_tb_if.csl_err_threshold      ),
    .bist_wl_scan_single_pattern_rd_num (u_tb_if.bist_wl_scan_single_pattern_rd_num),
    .bist_rescan_finish         (u_tb_if.bist_rescan_finish),
    .bist_rescan_success        (u_tb_if.bist_rescan_success),

    .mc_timeout_th              (u_tb_if.mc_timeout_th          ),
    .mc_bank_success            (u_tb_if.mc_bank_success        ),
    .bist_finish_intr           (u_tb_if.bist_finish_intr       ),
    .mc_timeout_intr            (u_tb_if.mc_timeout_intr        ),
    .monitor_signals            (u_tb_if.monitor_signals        ),
    .mc_sys_rst_ok              (u_tb_if.mc_sys_rst_n           ),
    .mc_apb_rst_ok              (u_tb_if.mc_apb_rst_n           ),
    .pre_precharge              (u_tb_if.pre_precharge          ),
    .page_mode_switch           (u_tb_if.page_mode_switch       ),
    .mc_scan_timeout_en         (u_tb_if.mc_scan_timeout_en     ),
    .global_mc_rescan_start     (u_tb_if.global_mc_rescan_start ),
    .bist_rescan_num            (u_tb_if.bist_rescan_num        ),
    .global_dram_init_en        (u_tb_if.global_dram_init_en    ),
    .mc_bist_csl_vmc_en         (u_tb_if.mc_bist_csl_vmc_en     ),
    .global_bist_clr            (u_tb_if.global_bist_clr        ),

    //-----a2f_dbg
    .a2f_dbg_ar_cnt             (u_tb_if.a2f_dbg_ar_cnt                    ),
    .a2f_dbg_r_cnt              (u_tb_if.a2f_dbg_r_cnt                     ),
    .a2f_dbg_aw_cnt             (u_tb_if.a2f_dbg_aw_cnt                    ),
    .a2f_dbg_w_cnt              (u_tb_if.a2f_dbg_w_cnt                     ),
    .a2f_dbg_b_cnt              (u_tb_if.a2f_dbg_b_cnt                     ),
    .a2f_dbg_axi_len_err_addr   (u_tb_if.a2f_dbg_axi_len_err_addr          ),
    .a2f_dbg_axi_len_err        (u_tb_if.a2f_dbg_axi_len_err               ),
    .a2f_dbg_reserve_in         (u_tb_if.a2f_dbg_reserve_in                ),
    .a2f_dbg_reserve_out        (u_tb_if.a2f_dbg_reserve_out               )

);      //}}}
