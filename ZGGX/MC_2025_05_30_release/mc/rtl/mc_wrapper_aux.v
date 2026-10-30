module mc_wrapper_aux #(
                parameter    APB_DATA_WIDTH       = 32,
                parameter    APB_ADDR_WIDTH       = 12,
                parameter    ARRAY_DATA_WIDTH     = 256,
                parameter    ARRAY_ROW_ADDR_WIDTH = 13,
                parameter    ARRAY_COL_ADDR_WIDTH = 8,
                parameter    CHECKBIT_WIDTH       = 10,
                parameter    PATTERN_WIDTH        = 32,
                parameter    CSL_ERR_TH_WIDTH     = 5,
                parameter    ARRAY_RSV_WIDTH      = 6,
                parameter    HUB_FRAME_WIDTH      = ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+3+2
        )(
                input                                                           clk                      ,
                input                                                           rst_n                    ,
                input    [31:0]                                                 mc_id                    , //wy up
                input                                                           mc_rf_start_en           , //wy up level signal  
                input                                                           global_rf_sel_en         , 
                input                                                           global_rf_sel            ,
                input                                                           global_mc_bist_start     ,//pulse signal
                input                                                           global_mc_bist_en        ,
                input                                                           global_mc_rescan_start   ,//default 0,pulse signal
                input    [4:0]                                                  global_dram_init_en      ,//[0]:dram_init_en,[1]:rf_cnt_clr,clear rf_cnt,[4:2]:reserved
                input                                                           global_bist_clr          ,//pulse signal
                input    [3:0]                                                  bist_rescan_num          ,//default 3,max 8
                input                                                           mc_scan_timeout_en       ,//initial scan timeout en
                input                                                           mc_bist_csl_vmc_en       ,

                input                                                           rf_range_change_en       ,
                input                                                           pre_precharge            ,
                input                                                           page_mode_switch         ,
                input    [ARRAY_ROW_ADDR_WIDTH*2-1:0]                           rf_addr                  ,//{rf_start_addr,rf_end_addr}

                //soc apb bus
                input                                                           apb_clk                  ,
                input                                                           apb_rst_n                ,
                input                                                           apb_sel                  ,
                input                                                           apb_enable               ,
                input                                                           apb_write                ,
                input    [APB_ADDR_WIDTH-1:0]                                   apb_addr                 ,
                input    [APB_DATA_WIDTH-1:0]                                   apb_wdata                ,
                output   [APB_DATA_WIDTH-1:0]                                   apb_rdata                ,
                output                                                          apb_pslverr              ,

                //array interface
                output   [1:0]                                                  bnksel_n                 , //wy up
                output   [ARRAY_ROW_ADDR_WIDTH-1:0]                             gradd_n                  ,
                output                                                          gcas_wr                  ,
                output                                                          gcas_rd                  ,
                output   [ARRAY_COL_ADDR_WIDTH-1:0]                             gcadd                    ,
                //output                                                        wrrdy_n                  ,
                output   [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_RSV_WIDTH-1:0]  wdl                      ,
                output                                                          wdl_oe                   ,
                input                                                           rdrdy_n                  ,
                input    [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_RSV_WIDTH-1:0]  rdl                      ,
                //hub to mc frame
                input                                                           hub_frame_vld            ,
                output                                                          hub_frame_rdy            ,
                input    [HUB_FRAME_WIDTH-CHECKBIT_WIDTH-2-1:0]                 hub_frame_data           ,//wy up add bank_sel
                //bresp
                input                                                           mc_bresp_rdy             ,
                output reg  [1:0]                                               mc_bresp                 ,
                output reg                                                      mc_bresp_vld             ,
                //array read data
                output                                                          mc_rvalid                ,
                output   [ARRAY_DATA_WIDTH+0-1:0]                               mc_rdata                 , //wy up
                output      [1:0]                                               mc_rresp                 , //wy add
                //phy timing cfg
                output   [3:0]                                                  bank_radd_set_time_o     ,
                output   [3:0]                                                  cadd_set_time_o          ,
                output   [7:0]                                                  r_cas_set_time_o         ,
                output   [7:0]                                                  w_cas_set_time_o         ,
                //output   [7:0]                                                  cas_wrrdy_time_o         ,
                //array timing cfg
                input    [5:0]                                                  mc_trc_cfg               ,//active to active time
                input    [4:0]                                                  mc_tras_cfg              ,//rcd active to precharge time
                input    [3:0]                                                  mc_trp_cfg               ,//precharge time
                input    [4:0]                                                  mc_trcd_cfg              ,//write rcd time
                input    [0:0]                                                  mc_trtp_cfg              ,//rd cas rising edge to precharge time
                input    [3:0]                                                  mc_twr_cfg               ,//wr cas falling edge to precharge time
                input    [2:0]                                                  mc_twtr_cfg              ,//write cas To Read cas time
                input    [3:0]                                                  mc_trtw_cfg              ,//Read cas To Write cas time
                //input    [6:0]                                                  bist_csl_scan_num        ,
                //input    [6:0]                                                  bist_wl_scan_num         ,
                input    [CSL_ERR_TH_WIDTH-1:0]                                 csl_err_threshold        ,
                input    [3:0]                                                  bist_wl_scan_single_pattern_rd_num,
                output                                                          bist_rescan_success      ,
                output                                                          bist_rescan_finish       ,
                //timeout
                input    [31:0]                                                 mc_timeout_th            ,
                //stc ctrl
                input                                                           mc_rf_start_sel          ,//0:sel input rf start,1:sel mc local cfg
                input    [31:0]                                                 rf_start_time            ,//tile cfg rf start time
                input    [31:0]                                                 rf_period                ,//tile sel
                input                                                           rf_period_up_en          ,//pulse signal
                input                                                           mc_rf_period_sel         ,//0:sel input rf period,1:sel mc local,default 0
                //rst release rst
                output                                                          mc_sys_rst_ok            ,// wy up
                output                                                          mc_apb_rst_ok            ,// wy up 
                //intrupt
                output                                                          bist_finish_intr         ,
                output                                                          mc_timeout_intr          ,
                //bist success
                output                                                          mc_bank_success          ,
                //monitor
                output   [99:0]                                                 monitor_signals          ,
                //wy add
                output                                                          global_dram_init_finish_intr ,
                input                                                           global_ecc_en            ,
                input                                                           global_ecc_sel           ,
                output                                                          mc_ce_overflow_intr      ,
                output                                                          mc_uce_intr              ,
                input   [31:0]                                                  a2f_dbg_ar_cnt           ,
                input   [31:0]                                                  a2f_dbg_r_cnt            ,
                input   [31:0]                                                  a2f_dbg_aw_cnt           ,
                input   [31:0]                                                  a2f_dbg_w_cnt            ,
                input   [31:0]                                                  a2f_dbg_b_cnt            ,
                input   [31:0]                                                  a2f_dbg_axi_len_err_addr ,
                input                                                           a2f_dbg_axi_len_err      ,
                output  [31:0]                                                  a2f_dbg_reserve_in       ,
                input   [31:0]                                                  a2f_dbg_reserve_out     

    );
wire                                             mc_debug_en         ;
wire                                             mc_frame_vld        ;
wire                                             mc_frame_rdy        ;
wire     [HUB_FRAME_WIDTH-CHECKBIT_WIDTH-2-1:0]  mc_frame_data       ;
wire                                             mc_back_rvalid      ;
wire     [ARRAY_DATA_WIDTH+0-1:0]                mc_back_rdata       ; // wy up
wire     [1:0]                                   mc_back_rresp       ; // wy up
wire                                             rst_mc_n            ;
wire                                             presetn             ;
wire                                             bank_success        ;
//wire                                             bist_rescan_finish  ;
wire                                             bist_finish_int     ;
wire                                             rescan_finish_intr  ;

//wy add 
//wire    ras_clr;
//assign  ras_clr = 1'b0;
wire    dbg_data_store_en;
assign  dbg_data_store_en = 1'b1;

//-----------------------------reset release------------------------------------
wl_dft_rst_sync_aux u_rst_mc_n(
    .clk_i       (clk),
    .rst_n_i     (rst_n),
    .dft_mode_i  (1'b0),
    .dft_rst_n_i (1'b1),
    .rst_n_sync_o(rst_mc_n)
);
wl_dft_rst_sync_aux u_rst_apb_n(
    .clk_i       (apb_clk),
    .rst_n_i     (apb_rst_n),
    .dft_mode_i  (1'b0),
    .dft_rst_n_i (1'b1),
    .rst_n_sync_o(presetn)
);

assign mc_sys_rst_ok     = rst_mc_n;
assign mc_apb_rst_ok     = presetn;
assign mc_bank_success  = bank_success ;
assign bist_finish_intr = rescan_finish_intr | bist_finish_int ;

mc_frame_debug_aux #(
                .HUB_FRAME_WIDTH   (HUB_FRAME_WIDTH-CHECKBIT_WIDTH-2),
                .ARRAY_DATA_WIDTH  (ARRAY_DATA_WIDTH)
)mc_frame_debug_u
(
                .clk           (clk             ),
                .rst_n         (rst_mc_n        ),
                .mc_debug_en   (mc_debug_en     ),
                .hub_frame_vld (hub_frame_vld   ),
                .hub_frame_rdy (hub_frame_rdy   ),
                .hub_frame_data(hub_frame_data  ),
                .mc_frame_vld  (mc_frame_vld    ),
                .mc_frame_rdy  (mc_frame_rdy    ),
                .mc_frame_data (mc_frame_data   ),
                .mc_back_rvalid(mc_back_rvalid  ),
                .mc_back_rdata (mc_back_rdata   ),
                .mc_back_rresp (mc_back_rresp   ),
                .mc_rvalid     (mc_rvalid       ),
                .mc_rdata      (mc_rdata        ),
                .mc_rresp      (mc_rresp        )
    );


////--------------------------generate bresponse---------------------------////

always @(posedge clk or negedge rst_mc_n)begin
    if(!rst_mc_n)begin
        mc_bresp_vld <= 1'b0;
        mc_bresp <= 2'b00;
    end
    else if (hub_frame_vld && hub_frame_rdy && hub_frame_data[HUB_FRAME_WIDTH-CHECKBIT_WIDTH-2-1])begin // wy up
        mc_bresp_vld <= 1'b1;
        mc_bresp <= 2'b00;
    end
    else begin
        mc_bresp_vld <= 1'b0;
        mc_bresp <= 2'b00;
    end
end


mc_top_aux #(
               .APB_DATA_WIDTH       (APB_DATA_WIDTH        ),
               .APB_ADDR_WIDTH       (APB_ADDR_WIDTH        ),
               .ARRAY_DATA_WIDTH     (ARRAY_DATA_WIDTH      ),
               .ARRAY_ROW_ADDR_WIDTH (ARRAY_ROW_ADDR_WIDTH  ),
               .ARRAY_COL_ADDR_WIDTH (ARRAY_COL_ADDR_WIDTH  ),
               .PATTERN_WIDTH        (PATTERN_WIDTH         ),
               .CSL_ERR_TH_WIDTH     (CSL_ERR_TH_WIDTH      ),
               .CHECKBIT_WIDTH       (CHECKBIT_WIDTH        ),
               .ARRAY_RSV_WIDTH      (ARRAY_RSV_WIDTH       ),               
               .FRAME_WIDTH          (HUB_FRAME_WIDTH       )
)mc_top_u(

                .clk                        (clk                            ),
                .rst_n                      (rst_mc_n                       ),
                .mc_id_soc                  (mc_id                          ),
                //.ras_clr                    (ras_clr                        ),

                .mc_rf_start                (mc_rf_start_en                 ), //wy up
                .global_rf_sel_en           (global_rf_sel_en               ), 
                .global_rf_sel              (global_rf_sel                  ),
                .global_mc_bist_start       (global_mc_bist_start           ),
                .global_mc_bist_en          (global_mc_bist_en              ),
                .global_mc_rescan_start     (global_mc_rescan_start         ),
                .global_dram_init_en        (global_dram_init_en[0]         ),
                .global_rf_cnt_clr          (global_dram_init_en[1]         ),//clear rf_cnt,default 0
                .global_bist_clr            (global_bist_clr                ),
                .mc_bist_csl_vmc_en         (mc_bist_csl_vmc_en             ),
                .bist_rescan_num            (bist_rescan_num                ),
                .bist_rescan_success        (bist_rescan_success            ),
                .bist_rescan_finish         (rescan_finish_intr             ),
                .bist_rescan_finish_status  (bist_rescan_finish             ),
                //.mc_dram_init_finish (mc_dram_init_finish  ),

                .mc_debug_en                (mc_debug_en                    ),
                .mc_scan_timeout_en         (mc_scan_timeout_en             ),
                .bist_finish_int            (bist_finish_int                ),
                .rf_range_change_en         (rf_range_change_en             ),
                .pre_precharge              (pre_precharge                  ),
                .page_mode_switch           (page_mode_switch               ),
                .rf_addr                    (rf_addr                        ),
                .dbg_data_store_en          (dbg_data_store_en              ),
                
                .apb_clk                    (apb_clk                        ),
                .apb_rst_n                  (presetn                        ),
                
                //wy up
                .soc_apb_sel                (apb_sel                        ),
                .soc_apb_enable             (apb_enable                     ),
                .soc_apb_write              (apb_write                      ),
                .soc_apb_addr               (apb_addr                       ),
                .soc_apb_wdata              (apb_wdata                      ),
                .soc_apb_rdata              (apb_rdata                      ),

                .mc_tras_cfg                (mc_tras_cfg                    ),//rcd active to precharge time
                .mc_trp_cfg                 (mc_trp_cfg                     ),//precharge time
                .mc_trc_cfg                 (mc_trc_cfg                     ),//active to active time
                .mc_trcd_cfg                (mc_trcd_cfg                    ),//read rcd time
                .mc_trtp_cfg                (mc_trtp_cfg                    ),//rd cas rising edge to precharge time
                .mc_twr_cfg                 (mc_twr_cfg                     ),//wr cas falling edge to precharge time
                .mc_twtr_cfg                (mc_twtr_cfg                    ),//write cas To Read cas time
                .mc_trtw_cfg                (mc_trtw_cfg                    ),//Read cas To Write cas time
                //.bist_csl_scan_num          (bist_csl_scan_num              ),
                //.bist_wl_scan_num           (bist_wl_scan_num               ),
                .csl_err_threshold          (csl_err_threshold              ),
                .bank_success               (bank_success                   ),
                .bist_wl_scan_single_pattern_rd_num(bist_wl_scan_single_pattern_rd_num),
                
                .mc_timeout_th              (mc_timeout_th                  ),
                
                .bnksel_n                   (bnksel_n                       ), 
                .gradd_n                    (gradd_n                        ),
                .gcas_wr                    (gcas_wr                        ),
                .gcas_rd                    (gcas_rd                        ),
                .gcadd                      (gcadd                          ),
                //.wrrdy_n                    (wrrdy_n                        ),
                .wdl                        (wdl                            ),
                .wdl_oe                     (wdl_oe                         ),
                .rdrdy_n                    (rdrdy_n                        ),
                .rdl                        (rdl                            ),
                
                .hub_frame_vld              (mc_frame_vld                   ),
                .hub_frame_rdy              (mc_frame_rdy                   ),
                .hub_frame_data             (mc_frame_data                  ),
                
                .mc_rvalid                  (mc_back_rvalid                 ),
                .mc_rdata                   (mc_back_rdata                  ),
                .mc_rresp                   (mc_back_rresp                  ),
                
                .bank_radd_set_time         (bank_radd_set_time_o           ),
                .cadd_set_time              (cadd_set_time_o                ),
                .r_cas_set_time             (r_cas_set_time_o               ),
                .w_cas_set_time             (w_cas_set_time_o               ),
                //.cas_wrrdy_time             (cas_wrrdy_time_o               ),
                .cas_wrrdy_time             (                               ),
                
                .hang_timeout_intr          (mc_timeout_intr                ),
                .monitor_signals            (monitor_signals                ),
                //rf 
                .mc_rf_start_sel            (mc_rf_start_sel                ),
                .rf_start_time              (rf_start_time                  ),
                .rf_period                  (rf_period                      ),
                .rf_period_up_en            (rf_period_up_en                ),
                .mc_rf_period_sel           (mc_rf_period_sel               ),

                .soc_apb_pslverr            (apb_pslverr                    ),    
                //wy add 
                .global_dram_init_finish_int(global_dram_init_finish_intr   ),
                .global_ecc_en              (global_ecc_en                  ),
                .global_ecc_sel             (global_ecc_sel                 ),
                .mc_ecc_ce_int              (mc_ce_overflow_intr            ),
                .mc_ecc_uce_int             (mc_uce_intr                    ),
                .a2f_dbg_ar_cnt             (a2f_dbg_ar_cnt                 ),
                .a2f_dbg_r_cnt              (a2f_dbg_r_cnt                  ),
                .a2f_dbg_aw_cnt             (a2f_dbg_aw_cnt                 ),
                .a2f_dbg_w_cnt              (a2f_dbg_w_cnt                  ),
                .a2f_dbg_b_cnt              (a2f_dbg_b_cnt                  ),
                .a2f_dbg_axi_len_err_addr   (a2f_dbg_axi_len_err_addr       ),
                .a2f_dbg_axi_len_err        (a2f_dbg_axi_len_err            ),
                .a2f_dbg_reserve_in         (a2f_dbg_reserve_in             ),
                .a2f_dbg_reserve_out        (a2f_dbg_reserve_out            )
    );

endmodule
