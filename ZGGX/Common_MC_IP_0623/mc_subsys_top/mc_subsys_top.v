/**
 * File              : mc_subsys_top.v
 * Author            : dongl
 * Date              : 24.06.2025
 * Last Modified Date: 24.06.2025
 * COPYRIGHT(c) 2021 - 2024, BJXX, ALL RIGHTS RESERVED.
 */


module mc_subsys_top #(
        parameter    USE_MC_ECC           = 1 ,  //1: use MC internal ECC; 0: dont use MC internal ECC
        parameter    MC_SHORT_MODE        = 1 ,  //only support: 1: 1short1; 2: 1short2; 3: 1short3; 4: 1short4;
        parameter    APB_DATA_WIDTH       = 32,
        parameter    APB_ADDR_WIDTH       = 11,
        parameter    ARRAY_DATA_WIDTH     = 256,
        parameter    ARRAY_ROW_ADDR_WIDTH = 13,
        parameter    ARRAY_COL_ADDR_WIDTH = 7,
        parameter    CHECKBIT_WIDTH       = 16,
        parameter    PATTERN_WIDTH        = 32,
        parameter    CSL_ERR_TH_WIDTH     = 5,
        parameter    HUB_FRAME_WIDTH      = ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+6
        )(
        input                                                  clk                               ,
        input                                                  rst_n                             ,
        input                                                  ras_clr                           ,
        input    [31:0]                                        mc_id                             ,
        input                                                  mc_rf_start                       ,
        input                                                  global_rf_sel_en                  , 
        input                                                  global_rf_sel                     ,
        input                                                  global_mc_bist_start              ,
        input                                                  global_mc_bist_en                 ,
        input                                                  global_mc_rescan_start            ,
        input    [4:0]                                         global_dram_init_en               ,
        input                                                  global_bist_clr                   ,
        input    [3:0]                                         bist_rescan_num                   ,
        input                                                  mc_scan_timeout_en                ,
        input                                                  mc_bist_csl_vmc_en                ,
        input                                                  rf_range_change_en                ,
        input                                                  pre_precharge                     ,
        input                                                  page_mode_switch                  ,
        input    [ARRAY_ROW_ADDR_WIDTH*2-1:0]                  rf_addr                           ,
        input                                                  dbg_data_store_en                 ,
        //-------------------------APB bus-------------------------//
        input                                                  apb_clk                           ,
        input                                                  apb_rst_n                         ,
        input                                                  apb_sel                           ,
        input                                                  apb_enable                        ,
        input                                                  apb_write                         ,
        input    [APB_ADDR_WIDTH-1:0]                          apb_addr                          ,
        input    [APB_DATA_WIDTH-1:0]                          apb_wdata                         ,
        output   [APB_DATA_WIDTH-1:0]                          apb_rdata                         ,
        output                                                 apb_pslverr                       ,
        //-------------------------ARRAY interface-------------------------//
        output   [MC_SHORT_MODE-1:0]                           bnksel_n                          ,
        output   [MC_SHORT_MODE-1:0]                           gcas_wr                           ,
        output   [MC_SHORT_MODE-1:0]                           gcas_rd                           ,
        output   [ARRAY_ROW_ADDR_WIDTH-1:0]                    gradd_n                           ,
        output   [ARRAY_COL_ADDR_WIDTH:0]                      gcadd                             ,
        output   [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]         wdl                               ,
        output                                                 wdl_oe                            ,
        input                                                  rdrdy_n                           ,
        input    [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]         rdl                               ,
        //-------------------------PHY timing cfg-------------------------//
        output   [7:0]                                         bank_radd_set_time_o              ,
        output   [3:0]                                         cadd_set_time_o                   ,
        output   [7:0]                                         r_cas_set_time_o                  ,
        output   [7:0]                                         w_cas_set_time_o                  ,
        //-------------------------ARRAY timing cfg-------------------------//
        input    [5:0]                                         mc_trc_cfg                        ,
        input    [4:0]                                         mc_tras_cfg                       ,
        input    [3:0]                                         mc_trp_cfg                        ,
        input    [4:0]                                         mc_trcd_cfg                       ,
        input    [0:0]                                         mc_trtp_cfg                       ,
        input    [3:0]                                         mc_twr_cfg                        ,
        input    [2:0]                                         mc_twtr_cfg                       ,
        input    [3:0]                                         mc_trtw_cfg                       ,
        //-------------------------Frame,response,read data-------------------------//
        input                                                  hub_frame_vld                     ,
        output                                                 hub_frame_rdy                     ,
        input    [HUB_FRAME_WIDTH-1:0]                         hub_frame_data                    ,
        input                                                  mc_bresp_rdy                      ,
        output   [1:0]                                         mc_bresp                          ,
        output                                                 mc_bresp_vld                      ,
        output                                                 mc_rvalid                         ,
        output   [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]         mc_rdata                          ,
        output   [1:0]                                         mc_rresp                          ,
        //-------------------------others control signals-------------------------//
        input    [CSL_ERR_TH_WIDTH-1:0]                        csl_err_threshold                 ,
        input    [3:0]                                         bist_wl_scan_single_pattern_rd_num,
        output                                                 bist_rescan_success               ,
        output                                                 bist_rescan_finish                ,
        input    [31:0]                                        mc_timeout_th                     ,
        input                                                  mc_rf_start_sel                   ,
        input    [31:0]                                        rf_start_time                     ,
        input                                                  mc_rf_period_sel                  ,
        input    [ARRAY_ROW_ADDR_WIDTH-1:0]                    rf_row_num                        ,
        input    [31:0]                                        rf_single_interval                ,
        input    [2:0]                                         rf_gear_id                        ,
        input                                                  rf_gear_up_en                     ,
        output                                                 mc_sys_rst_n                      ,
        output                                                 mc_apb_rst_n                      ,
        output                                                 bist_finish_intr                  ,
        output                                                 mc_timeout_intr                   ,
        output                                                 mc_bank_success                   ,
        output                                                 mc_ecc_ce_overflow_int            ,
        output                                                 mc_ecc_uce_int                    ,
        //-------------------------monitor-------------------------//
        output   [99:0]                                        monitor_signals     
    );




localparam MC_CE_RECORD_NUM    = 16;
localparam MC_UCE_RECORD_NUM   = 4;
localparam MC_ERR_ADDR_WIDTH   = ARRAY_COL_ADDR_WIDTH+ARRAY_ROW_ADDR_WIDTH+2;





wire   [ARRAY_COL_ADDR_WIDTH-1:0]                  hub_col_addr          ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                  hub_row_addr          ;
wire   [1:0]                                       hub_bank_addr         ;
wire   [ARRAY_DATA_WIDTH-1:0]                      hub_wdata             ;
wire   [CHECKBIT_WIDTH-1:0]                        hub_checkbit          ;
wire                                               hub_sof               ;
wire                                               hub_eof               ;
wire                                               hub_rw_flag           ;
wire                                               hub_strobe            ;

wire                                               mc_ecc_en             ;
wire                                               hub_frame_vld_inner   ;
wire                                               hub_frame_rdy_inner   ;
wire   [HUB_FRAME_WIDTH-3:0]                       hub_frame_data_inner  ;
wire   [HUB_FRAME_WIDTH-1:0]                       hub_frame_data_ecc    ;
wire                                               mc_rvalid_inner       ;
wire   [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]       mc_rdata_inner        ;
wire   [4:0]                                       mc_ecc_ce_th          ;
wire                                               mc_ecc_ce_int_clr     ;
wire   [4:0]                                       mc_ecc_ce_cnt         ;
wire   [MC_CE_RECORD_NUM*MC_ERR_ADDR_WIDTH-1:0]    mc_ecc_ce_addr        ;
wire   [MC_CE_RECORD_NUM-1:0]                      mc_ecc_ce_addr_vld    ;
wire                                               mc_ecc_uce_int_clr    ;
wire   [2:0]                                       mc_ecc_uce_cnt        ;
wire   [MC_UCE_RECORD_NUM-1:0]                     mc_ecc_uce_addr_vld   ;
wire   [MC_UCE_RECORD_NUM*MC_ERR_ADDR_WIDTH-1:0]   mc_ecc_uce_addr       ;
wire                                               ecc_decode_rvalid     ;
wire   [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]       ecc_decode_rdata      ;
wire   [1:0]                                       ecc_decode_rresp      ;
wire                                               mc_ecc_ce_int_mask    ;
wire                                               mc_ecc_uce_int_mask   ;
wire                                               mc_ecc_ce_int_tmp     ;
wire                                               mc_ecc_uce_int_tmp    ;



assign {hub_strobe,hub_rw_flag,hub_sof,hub_eof,hub_checkbit,hub_wdata,hub_bank_addr,hub_row_addr,hub_col_addr} = hub_frame_data;



generate
if(USE_MC_ECC==1)begin
wire   [ARRAY_COL_ADDR_WIDTH-1:0]                  ecc_col_addr          ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                  ecc_row_addr          ;
wire   [1:0]                                       ecc_bank_addr         ;
wire   [ARRAY_DATA_WIDTH-1:0]                      ecc_wdata             ;
wire   [CHECKBIT_WIDTH-1:0]                        ecc_checkbit          ;
wire                                               ecc_sof               ;
wire                                               ecc_eof               ;
wire                                               ecc_rw_flag           ;
wire                                               ecc_strobe            ;

assign {ecc_strobe,ecc_rw_flag,ecc_sof,ecc_eof,ecc_checkbit,ecc_wdata,ecc_bank_addr,ecc_row_addr,ecc_col_addr} = hub_frame_data_ecc;
assign mc_ecc_ce_overflow_int = ~mc_ecc_ce_int_mask & mc_ecc_ce_int_tmp;
assign mc_ecc_uce_int         = ~mc_ecc_uce_int_mask & mc_ecc_uce_int_tmp;

mc_ecc_wrapper mc_ecc_wrapper_u(
        .clk                   (clk                   ),
        .rst_n                 (rst_n                 ),
        .mc_ecc_en             (mc_ecc_en             ),
        .s_hub_frame_vld       (hub_frame_vld         ),
        .s_hub_frame_rdy       (hub_frame_rdy         ),
        .s_hub_frame_data      (hub_frame_data        ),
        .m_hub_frame_vld       (hub_frame_vld_inner   ),
        .m_hub_frame_rdy       (hub_frame_rdy_inner   ),
        .m_hub_frame_data      (hub_frame_data_ecc    ),
        .mc_rvalid             (mc_rvalid_inner       ),
        .mc_rdata              (mc_rdata_inner        ),
        .ecc_decode_rvalid     (ecc_decode_rvalid     ),
        .ecc_decode_rdata      (ecc_decode_rdata      ),
        .ecc_decode_rresp      (ecc_decode_rresp      ),
        .mc_ecc_ce_th          (mc_ecc_ce_th          ),
        .mc_ecc_ce_int_clr     (mc_ecc_ce_int_clr     ),
        .mc_ecc_ce_overflow_int(mc_ecc_ce_int_tmp     ),
        .mc_ecc_ce_cnt         (mc_ecc_ce_cnt         ),
        .mc_ecc_ce_addr        (mc_ecc_ce_addr        ),
        .mc_ecc_ce_addr_vld    (mc_ecc_ce_addr_vld    ),
        .mc_ecc_uce_int_clr    (mc_ecc_uce_int_clr    ),
        .mc_ecc_uce_int        (mc_ecc_uce_int_tmp    ),
        .mc_ecc_uce_cnt        (mc_ecc_uce_cnt        ),
        .mc_ecc_uce_addr_vld   (mc_ecc_uce_addr_vld   ),
        .mc_ecc_uce_addr       (mc_ecc_uce_addr       )
    );
    assign hub_frame_data_inner = {ecc_strobe,ecc_rw_flag,ecc_sof,ecc_eof,ecc_checkbit,ecc_wdata,ecc_row_addr,ecc_col_addr};
    assign mc_rvalid = ecc_decode_rvalid;
    assign mc_rresp  = ecc_decode_rresp;
    assign mc_rdata  = ecc_decode_rdata;
end
else begin
assign mc_rvalid              = mc_rvalid_inner;
assign mc_rdata               = mc_rdata_inner;
assign hub_frame_vld_inner    = hub_frame_vld;
assign hub_frame_rdy          = hub_frame_rdy_inner;
assign hub_frame_data_inner   = {hub_strobe,hub_rw_flag,hub_sof,hub_eof,hub_checkbit,hub_wdata,hub_row_addr,hub_col_addr};
assign mc_ecc_ce_overflow_int = 1'b0;
assign mc_ecc_ce_cnt          = 5'd0;
assign mc_ecc_ce_addr         = {(MC_CE_RECORD_NUM*MC_ERR_ADDR_WIDTH){1'b0}};
assign mc_ecc_ce_addr_vld     = {MC_CE_RECORD_NUM{1'b0}};
assign mc_ecc_uce_int         = 1'b0;
assign mc_ecc_uce_cnt         = 3'd0;
assign mc_ecc_uce_addr_vld    = {MC_UCE_RECORD_NUM{1'b0}};
assign mc_ecc_uce_addr        = {(MC_UCE_RECORD_NUM*MC_ERR_ADDR_WIDTH){1'b0}};
assign mc_ecc_ce_int_tmp      = 1'b0;
assign mc_ecc_uce_int_tmp     = 1'b0;
assign mc_rresp               = 2'd0;
end
endgenerate




generate
if(MC_SHORT_MODE==1)begin
mc_wrapper_aux mc_wrapper_aux_u(
        .clk                               (clk                               ),
        .rst_n                             (rst_n                             ),
        .ras_clr                           (ras_clr                           ),
        .mc_id_soc                         (mc_id                             ),
        .mc_rf_start                       (mc_rf_start                       ),
        .global_rf_sel_en                  (global_rf_sel_en                  ), 
        .global_rf_sel                     (global_rf_sel                     ),
        .global_mc_bist_start              (global_mc_bist_start              ),
        .global_mc_bist_en                 (global_mc_bist_en                 ),
        .global_mc_rescan_start            (global_mc_rescan_start            ),
        .global_dram_init_en               (global_dram_init_en               ),
        .global_bist_clr                   (global_bist_clr                   ),
        .bist_rescan_num                   (bist_rescan_num                   ),
        .mc_scan_timeout_en                (mc_scan_timeout_en                ),
        .mc_bist_csl_vmc_en                (mc_bist_csl_vmc_en                ),
        .rf_range_change_en                (rf_range_change_en                ),
        .pre_precharge                     (pre_precharge                     ),
        .page_mode_switch                  (page_mode_switch                  ),
        .rf_addr                           (rf_addr                           ),
        .dbg_data_store_en                 (dbg_data_store_en                 ),
        .apb_clk                           (apb_clk                           ),
        .apb_rst_n                         (apb_rst_n                         ),
        .soc_apb_sel                       (apb_sel                           ),
        .soc_apb_enable                    (apb_enable                        ),
        .soc_apb_write                     (apb_write                         ),
        .soc_apb_addr                      (apb_addr                          ),
        .soc_apb_wdata                     (apb_wdata                         ),
        .soc_apb_rdata                     (apb_rdata                         ),
        .soc_apb_pslverr                   (apb_pslverr                       ),
        .bnksel_n                          (bnksel_n                          ), 
        .gradd_n                           (gradd_n                           ),
        .gcas_wr                           (gcas_wr                           ),
        .gcas_rd                           (gcas_rd                           ),
        .gcadd                             (gcadd                             ),
        .wdl                               (wdl                               ),
        .wdl_oe                            (wdl_oe                            ),
        .rdrdy_n                           (rdrdy_n                           ),
        .rdl                               (rdl                               ),
        .hub_frame_vld                     (hub_frame_vld_inner               ),
        .hub_frame_rdy                     (hub_frame_rdy_inner               ),
        .hub_frame_data                    (hub_frame_data_inner              ),
        .mc_bresp_rdy                      (mc_bresp_rdy                      ),
        .mc_bresp                          (mc_bresp                          ),
        .mc_bresp_vld                      (mc_bresp_vld                      ),
        .mc_rvalid                         (mc_rvalid_inner                   ),
        .mc_rdata                          (mc_rdata_inner                    ),
        .bank_radd_set_time_o              (bank_radd_set_time_o              ),
        .cadd_set_time_o                   (cadd_set_time_o                   ),
        .r_cas_set_time_o                  (r_cas_set_time_o                  ),
        .w_cas_set_time_o                  (w_cas_set_time_o                  ),
        .mc_trc_cfg                        (mc_trc_cfg                        ),
        .mc_tras_cfg                       (mc_tras_cfg                       ),
        .mc_trp_cfg                        (mc_trp_cfg                        ),
        .mc_trcd_cfg                       (mc_trcd_cfg                       ),
        .mc_trtp_cfg                       (mc_trtp_cfg                       ),
        .mc_twr_cfg                        (mc_twr_cfg                        ),
        .mc_twtr_cfg                       (mc_twtr_cfg                       ),
        .mc_trtw_cfg                       (mc_trtw_cfg                       ),
        .csl_err_threshold                 (csl_err_threshold                 ),
        .bist_wl_scan_single_pattern_rd_num(bist_wl_scan_single_pattern_rd_num),
        .bist_rescan_success               (bist_rescan_success               ),
        .bist_rescan_finish                (bist_rescan_finish                ),
        .mc_timeout_th                     (mc_timeout_th                     ),
        .mc_rf_start_sel                   (mc_rf_start_sel                   ),
        .rf_start_time                     (rf_start_time                     ),
        .mc_rf_period_sel                  (mc_rf_period_sel                  ),
        .rf_row_num                        (rf_row_num                        ),
        .rf_single_interval                (rf_single_interval                ),
        .rf_gear_id                        (rf_gear_id                        ),
        .rf_gear_up_en                     (rf_gear_up_en                     ),
        .mc_sys_rst_n                      (mc_sys_rst_n                      ),
        .mc_apb_rst_n                      (mc_apb_rst_n                      ),
        .bist_finish_intr                  (bist_finish_intr                  ),
        .mc_timeout_intr                   (mc_timeout_intr                   ),
        .mc_bank_success                   (mc_bank_success                   ),
        .monitor_signals                   (monitor_signals                   ),
        .mc_ecc_en                         (mc_ecc_en                         ),
        .mc_ecc_ce_overflow_int            (mc_ecc_ce_int_tmp                 ),
        .mc_ecc_ce_cnt                     (mc_ecc_ce_cnt                     ),
        .mc_ecc_ce_addr                    (mc_ecc_ce_addr                    ),
        .mc_ecc_ce_addr_vld                (mc_ecc_ce_addr_vld                ),
        .mc_ecc_uce_int                    (mc_ecc_uce_int_tmp                ),
        .mc_ecc_uce_cnt                    (mc_ecc_uce_cnt                    ),
        .mc_ecc_uce_addr                   (mc_ecc_uce_addr                   ),
        .mc_ecc_uce_addr_vld               (mc_ecc_uce_addr_vld               ),
        .mc_ecc_ce_th                      (mc_ecc_ce_th                      ),
        .mc_ecc_ce_int_clr                 (mc_ecc_ce_int_clr                 ),
        .mc_ecc_uce_int_clr                (mc_ecc_uce_int_clr                ),
        .mc_ecc_ce_int_mask                (mc_ecc_ce_int_mask                ),
        .mc_ecc_uce_int_mask               (mc_ecc_uce_int_mask               )
    );
end
else if(MC_SHORT_MODE==2)begin
assign bnksel_n[1] = 1'b1;
assign gcas_wr[1]  = 1'b0;
assign gcas_rd[1]  = 1'b0;
mc_wrapper_aux mc_wrapper_aux_u(
        .clk                               (clk                               ),
        .rst_n                             (rst_n                             ),
        .ras_clr                           (ras_clr                           ),
        .mc_id_soc                         (mc_id                             ),
        .mc_rf_start                       (mc_rf_start                       ),
        .global_rf_sel_en                  (global_rf_sel_en                  ), 
        .global_rf_sel                     (global_rf_sel                     ),
        .global_mc_bist_start              (global_mc_bist_start              ),
        .global_mc_bist_en                 (global_mc_bist_en                 ),
        .global_mc_rescan_start            (global_mc_rescan_start            ),
        .global_dram_init_en               (global_dram_init_en               ),
        .global_bist_clr                   (global_bist_clr                   ),
        .bist_rescan_num                   (bist_rescan_num                   ),
        .mc_scan_timeout_en                (mc_scan_timeout_en                ),
        .mc_bist_csl_vmc_en                (mc_bist_csl_vmc_en                ),
        .rf_range_change_en                (rf_range_change_en                ),
        .pre_precharge                     (pre_precharge                     ),
        .page_mode_switch                  (page_mode_switch                  ),
        .rf_addr                           (rf_addr                           ),
        .dbg_data_store_en                 (dbg_data_store_en                 ),
        .apb_clk                           (apb_clk                           ),
        .apb_rst_n                         (apb_rst_n                         ),
        .soc_apb_sel                       (apb_sel                           ),
        .soc_apb_enable                    (apb_enable                        ),
        .soc_apb_write                     (apb_write                         ),
        .soc_apb_addr                      (apb_addr                          ),
        .soc_apb_wdata                     (apb_wdata                         ),
        .soc_apb_rdata                     (apb_rdata                         ),
        .soc_apb_pslverr                   (apb_pslverr                       ),
        .bnksel_n                          (bnksel_n[0]                       ), 
        .gradd_n                           (gradd_n                           ),
        .gcas_wr                           (gcas_wr[0]                        ),
        .gcas_rd                           (gcas_rd[0]                        ),
        .gcadd                             (gcadd                             ),
        .wdl                               (wdl                               ),
        .wdl_oe                            (wdl_oe                            ),
        .rdrdy_n                           (rdrdy_n                           ),
        .rdl                               (rdl                               ),
        .hub_frame_vld                     (hub_frame_vld_inner               ),
        .hub_frame_rdy                     (hub_frame_rdy_inner               ),
        .hub_frame_data                    (hub_frame_data_inner              ),
        .mc_bresp_rdy                      (mc_bresp_rdy                      ),
        .mc_bresp                          (mc_bresp                          ),
        .mc_bresp_vld                      (mc_bresp_vld                      ),
        .mc_rvalid                         (mc_rvalid_inner                   ),
        .mc_rdata                          (mc_rdata_inner                    ),
        .bank_radd_set_time_o              (bank_radd_set_time_o              ),
        .cadd_set_time_o                   (cadd_set_time_o                   ),
        .r_cas_set_time_o                  (r_cas_set_time_o                  ),
        .w_cas_set_time_o                  (w_cas_set_time_o                  ),
        .mc_trc_cfg                        (mc_trc_cfg                        ),
        .mc_tras_cfg                       (mc_tras_cfg                       ),
        .mc_trp_cfg                        (mc_trp_cfg                        ),
        .mc_trcd_cfg                       (mc_trcd_cfg                       ),
        .mc_trtp_cfg                       (mc_trtp_cfg                       ),
        .mc_twr_cfg                        (mc_twr_cfg                        ),
        .mc_twtr_cfg                       (mc_twtr_cfg                       ),
        .mc_trtw_cfg                       (mc_trtw_cfg                       ),
        .csl_err_threshold                 (csl_err_threshold                 ),
        .bist_wl_scan_single_pattern_rd_num(bist_wl_scan_single_pattern_rd_num),
        .bist_rescan_success               (bist_rescan_success               ),
        .bist_rescan_finish                (bist_rescan_finish                ),
        .mc_timeout_th                     (mc_timeout_th                     ),
        .mc_rf_start_sel                   (mc_rf_start_sel                   ),
        .rf_start_time                     (rf_start_time                     ),
        .mc_rf_period_sel                  (mc_rf_period_sel                  ),
        .rf_row_num                        (rf_row_num                        ),
        .rf_single_interval                (rf_single_interval                ),
        .rf_gear_id                        (rf_gear_id                        ),
        .rf_gear_up_en                     (rf_gear_up_en                     ),
        .mc_sys_rst_n                      (mc_sys_rst_n                      ),
        .mc_apb_rst_n                      (mc_apb_rst_n                      ),
        .bist_finish_intr                  (bist_finish_intr                  ),
        .mc_timeout_intr                   (mc_timeout_intr                   ),
        .mc_bank_success                   (mc_bank_success                   ),
        .monitor_signals                   (monitor_signals                   ),
        .mc_ecc_en                         (mc_ecc_en                         ),
        .mc_ecc_ce_overflow_int            (mc_ecc_ce_int_tmp                 ),
        .mc_ecc_ce_cnt                     (mc_ecc_ce_cnt                     ),
        .mc_ecc_ce_addr                    (mc_ecc_ce_addr                    ),
        .mc_ecc_ce_addr_vld                (mc_ecc_ce_addr_vld                ),
        .mc_ecc_uce_int                    (mc_ecc_uce_int_tmp                ),
        .mc_ecc_uce_cnt                    (mc_ecc_uce_cnt                    ),
        .mc_ecc_uce_addr                   (mc_ecc_uce_addr                   ),
        .mc_ecc_uce_addr_vld               (mc_ecc_uce_addr_vld               ),
        .mc_ecc_ce_th                      (mc_ecc_ce_th                      ),
        .mc_ecc_ce_int_clr                 (mc_ecc_ce_int_clr                 ),
        .mc_ecc_uce_int_clr                (mc_ecc_uce_int_clr                ),
        .mc_ecc_ce_int_mask                (mc_ecc_ce_int_mask                ),
        .mc_ecc_uce_int_mask               (mc_ecc_uce_int_mask               )
    );
end
else if(MC_SHORT_MODE==3)begin
assign bnksel_n[2:1] = 2'b11;
assign gcas_wr[2:1]  = 2'b00;
assign gcas_rd[2:1]  = 2'b00;
mc_wrapper_aux mc_wrapper_aux_u(
        .clk                               (clk                               ),
        .rst_n                             (rst_n                             ),
        .ras_clr                           (ras_clr                           ),
        .mc_id_soc                         (mc_id                             ),
        .mc_rf_start                       (mc_rf_start                       ),
        .global_rf_sel_en                  (global_rf_sel_en                  ), 
        .global_rf_sel                     (global_rf_sel                     ),
        .global_mc_bist_start              (global_mc_bist_start              ),
        .global_mc_bist_en                 (global_mc_bist_en                 ),
        .global_mc_rescan_start            (global_mc_rescan_start            ),
        .global_dram_init_en               (global_dram_init_en               ),
        .global_bist_clr                   (global_bist_clr                   ),
        .bist_rescan_num                   (bist_rescan_num                   ),
        .mc_scan_timeout_en                (mc_scan_timeout_en                ),
        .mc_bist_csl_vmc_en                (mc_bist_csl_vmc_en                ),
        .rf_range_change_en                (rf_range_change_en                ),
        .pre_precharge                     (pre_precharge                     ),
        .page_mode_switch                  (page_mode_switch                  ),
        .rf_addr                           (rf_addr                           ),
        .dbg_data_store_en                 (dbg_data_store_en                 ),
        .apb_clk                           (apb_clk                           ),
        .apb_rst_n                         (apb_rst_n                         ),
        .soc_apb_sel                       (apb_sel                           ),
        .soc_apb_enable                    (apb_enable                        ),
        .soc_apb_write                     (apb_write                         ),
        .soc_apb_addr                      (apb_addr                          ),
        .soc_apb_wdata                     (apb_wdata                         ),
        .soc_apb_rdata                     (apb_rdata                         ),
        .soc_apb_pslverr                   (apb_pslverr                       ),
        .bnksel_n                          (bnksel_n[0]                       ), 
        .gradd_n                           (gradd_n                           ),
        .gcas_wr                           (gcas_wr[0]                        ),
        .gcas_rd                           (gcas_rd[0]                        ),
        .gcadd                             (gcadd                             ),
        .wdl                               (wdl                               ),
        .wdl_oe                            (wdl_oe                            ),
        .rdrdy_n                           (rdrdy_n                           ),
        .rdl                               (rdl                               ),
        .hub_frame_vld                     (hub_frame_vld_inner               ),
        .hub_frame_rdy                     (hub_frame_rdy_inner               ),
        .hub_frame_data                    (hub_frame_data_inner              ),
        .mc_bresp_rdy                      (mc_bresp_rdy                      ),
        .mc_bresp                          (mc_bresp                          ),
        .mc_bresp_vld                      (mc_bresp_vld                      ),
        .mc_rvalid                         (mc_rvalid_inner                   ),
        .mc_rdata                          (mc_rdata_inner                    ),
        .bank_radd_set_time_o              (bank_radd_set_time_o              ),
        .cadd_set_time_o                   (cadd_set_time_o                   ),
        .r_cas_set_time_o                  (r_cas_set_time_o                  ),
        .w_cas_set_time_o                  (w_cas_set_time_o                  ),
        .mc_trc_cfg                        (mc_trc_cfg                        ),
        .mc_tras_cfg                       (mc_tras_cfg                       ),
        .mc_trp_cfg                        (mc_trp_cfg                        ),
        .mc_trcd_cfg                       (mc_trcd_cfg                       ),
        .mc_trtp_cfg                       (mc_trtp_cfg                       ),
        .mc_twr_cfg                        (mc_twr_cfg                        ),
        .mc_twtr_cfg                       (mc_twtr_cfg                       ),
        .mc_trtw_cfg                       (mc_trtw_cfg                       ),
        .csl_err_threshold                 (csl_err_threshold                 ),
        .bist_wl_scan_single_pattern_rd_num(bist_wl_scan_single_pattern_rd_num),
        .bist_rescan_success               (bist_rescan_success               ),
        .bist_rescan_finish                (bist_rescan_finish                ),
        .mc_timeout_th                     (mc_timeout_th                     ),
        .mc_rf_start_sel                   (mc_rf_start_sel                   ),
        .rf_start_time                     (rf_start_time                     ),
        .mc_rf_period_sel                  (mc_rf_period_sel                  ),
        .rf_row_num                        (rf_row_num                        ),
        .rf_single_interval                (rf_single_interval                ),
        .rf_gear_id                        (rf_gear_id                        ),
        .rf_gear_up_en                     (rf_gear_up_en                     ),
        .mc_sys_rst_n                      (mc_sys_rst_n                      ),
        .mc_apb_rst_n                      (mc_apb_rst_n                      ),
        .bist_finish_intr                  (bist_finish_intr                  ),
        .mc_timeout_intr                   (mc_timeout_intr                   ),
        .mc_bank_success                   (mc_bank_success                   ),
        .monitor_signals                   (monitor_signals                   ),
        .mc_ecc_en                         (mc_ecc_en                         ),
        .mc_ecc_ce_overflow_int            (mc_ecc_ce_int_tmp                 ),
        .mc_ecc_ce_cnt                     (mc_ecc_ce_cnt                     ),
        .mc_ecc_ce_addr                    (mc_ecc_ce_addr                    ),
        .mc_ecc_ce_addr_vld                (mc_ecc_ce_addr_vld                ),
        .mc_ecc_uce_int                    (mc_ecc_uce_int_tmp                ),
        .mc_ecc_uce_cnt                    (mc_ecc_uce_cnt                    ),
        .mc_ecc_uce_addr                   (mc_ecc_uce_addr                   ),
        .mc_ecc_uce_addr_vld               (mc_ecc_uce_addr_vld               ),
        .mc_ecc_ce_th                      (mc_ecc_ce_th                      ),
        .mc_ecc_ce_int_clr                 (mc_ecc_ce_int_clr                 ),
        .mc_ecc_uce_int_clr                (mc_ecc_uce_int_clr                ),
        .mc_ecc_ce_int_mask                (mc_ecc_ce_int_mask                ),
        .mc_ecc_uce_int_mask               (mc_ecc_uce_int_mask               )
    );
end
else begin
assign bnksel_n[3:1] = 3'b111;
assign gcas_wr[3:1]  = 3'b000;
assign gcas_rd[3:1]  = 3'b000;
mc_wrapper_aux mc_wrapper_aux_u(
        .clk                               (clk                               ),
        .rst_n                             (rst_n                             ),
        .ras_clr                           (ras_clr                           ),
        .mc_id_soc                         (mc_id                             ),
        .mc_rf_start                       (mc_rf_start                       ),
        .global_rf_sel_en                  (global_rf_sel_en                  ), 
        .global_rf_sel                     (global_rf_sel                     ),
        .global_mc_bist_start              (global_mc_bist_start              ),
        .global_mc_bist_en                 (global_mc_bist_en                 ),
        .global_mc_rescan_start            (global_mc_rescan_start            ),
        .global_dram_init_en               (global_dram_init_en               ),
        .global_bist_clr                   (global_bist_clr                   ),
        .bist_rescan_num                   (bist_rescan_num                   ),
        .mc_scan_timeout_en                (mc_scan_timeout_en                ),
        .mc_bist_csl_vmc_en                (mc_bist_csl_vmc_en                ),
        .rf_range_change_en                (rf_range_change_en                ),
        .pre_precharge                     (pre_precharge                     ),
        .page_mode_switch                  (page_mode_switch                  ),
        .rf_addr                           (rf_addr                           ),
        .dbg_data_store_en                 (dbg_data_store_en                 ),
        .apb_clk                           (apb_clk                           ),
        .apb_rst_n                         (apb_rst_n                         ),
        .soc_apb_sel                       (apb_sel                           ),
        .soc_apb_enable                    (apb_enable                        ),
        .soc_apb_write                     (apb_write                         ),
        .soc_apb_addr                      (apb_addr                          ),
        .soc_apb_wdata                     (apb_wdata                         ),
        .soc_apb_rdata                     (apb_rdata                         ),
        .soc_apb_pslverr                   (apb_pslverr                       ),
        .bnksel_n                          (bnksel_n[0]                       ), 
        .gradd_n                           (gradd_n                           ),
        .gcas_wr                           (gcas_wr[0]                        ),
        .gcas_rd                           (gcas_rd[0]                        ),
        .gcadd                             (gcadd                             ),
        .wdl                               (wdl                               ),
        .wdl_oe                            (wdl_oe                            ),
        .rdrdy_n                           (rdrdy_n                           ),
        .rdl                               (rdl                               ),
        .hub_frame_vld                     (hub_frame_vld_inner               ),
        .hub_frame_rdy                     (hub_frame_rdy_inner               ),
        .hub_frame_data                    (hub_frame_data_inner              ),
        .mc_bresp_rdy                      (mc_bresp_rdy                      ),
        .mc_bresp                          (mc_bresp                          ),
        .mc_bresp_vld                      (mc_bresp_vld                      ),
        .mc_rvalid                         (mc_rvalid_inner                   ),
        .mc_rdata                          (mc_rdata_inner                    ),
        .bank_radd_set_time_o              (bank_radd_set_time_o              ),
        .cadd_set_time_o                   (cadd_set_time_o                   ),
        .r_cas_set_time_o                  (r_cas_set_time_o                  ),
        .w_cas_set_time_o                  (w_cas_set_time_o                  ),
        .mc_trc_cfg                        (mc_trc_cfg                        ),
        .mc_tras_cfg                       (mc_tras_cfg                       ),
        .mc_trp_cfg                        (mc_trp_cfg                        ),
        .mc_trcd_cfg                       (mc_trcd_cfg                       ),
        .mc_trtp_cfg                       (mc_trtp_cfg                       ),
        .mc_twr_cfg                        (mc_twr_cfg                        ),
        .mc_twtr_cfg                       (mc_twtr_cfg                       ),
        .mc_trtw_cfg                       (mc_trtw_cfg                       ),
        .csl_err_threshold                 (csl_err_threshold                 ),
        .bist_wl_scan_single_pattern_rd_num(bist_wl_scan_single_pattern_rd_num),
        .bist_rescan_success               (bist_rescan_success               ),
        .bist_rescan_finish                (bist_rescan_finish                ),
        .mc_timeout_th                     (mc_timeout_th                     ),
        .mc_rf_start_sel                   (mc_rf_start_sel                   ),
        .rf_start_time                     (rf_start_time                     ),
        .mc_rf_period_sel                  (mc_rf_period_sel                  ),
        .rf_row_num                        (rf_row_num                        ),
        .rf_single_interval                (rf_single_interval                ),
        .rf_gear_id                        (rf_gear_id                        ),
        .rf_gear_up_en                     (rf_gear_up_en                     ),
        .mc_sys_rst_n                      (mc_sys_rst_n                      ),
        .mc_apb_rst_n                      (mc_apb_rst_n                      ),
        .bist_finish_intr                  (bist_finish_intr                  ),
        .mc_timeout_intr                   (mc_timeout_intr                   ),
        .mc_bank_success                   (mc_bank_success                   ),
        .monitor_signals                   (monitor_signals                   ),
        .mc_ecc_en                         (mc_ecc_en                         ),
        .mc_ecc_ce_overflow_int            (mc_ecc_ce_int_tmp                 ),
        .mc_ecc_ce_cnt                     (mc_ecc_ce_cnt                     ),
        .mc_ecc_ce_addr                    (mc_ecc_ce_addr                    ),
        .mc_ecc_ce_addr_vld                (mc_ecc_ce_addr_vld                ),
        .mc_ecc_uce_int                    (mc_ecc_uce_int_tmp                ),
        .mc_ecc_uce_cnt                    (mc_ecc_uce_cnt                    ),
        .mc_ecc_uce_addr                   (mc_ecc_uce_addr                   ),
        .mc_ecc_uce_addr_vld               (mc_ecc_uce_addr_vld               ),
        .mc_ecc_ce_th                      (mc_ecc_ce_th                      ),
        .mc_ecc_ce_int_clr                 (mc_ecc_ce_int_clr                 ),
        .mc_ecc_uce_int_clr                (mc_ecc_uce_int_clr                ),
        .mc_ecc_ce_int_mask                (mc_ecc_ce_int_mask                ),
        .mc_ecc_uce_int_mask               (mc_ecc_uce_int_mask               )
    );
end
endgenerate





endmodule
