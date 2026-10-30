module mc_wrapper_aux #(
                parameter    APB_DATA_WIDTH       = 32,
                parameter    APB_ADDR_WIDTH       = 11,
                parameter    ARRAY_DATA_WIDTH     = 256,
                parameter    ARRAY_ROW_ADDR_WIDTH = 13,
                parameter    ARRAY_COL_ADDR_WIDTH = 8,
                parameter    CHECKBIT_WIDTH       = 16,
                parameter    PATTERN_WIDTH        = 32,
                parameter    CSL_ERR_TH_WIDTH     = 5,
                parameter    MC_SHORT_MODE        = 2,
                parameter    HUB_FRAME_WIDTH      = ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+3+1+2
        )(
                input                                                  clk                 ,
                input                                                  rst_n               ,
                input                                                  ras_clr             ,
                input    [31:0]                                        mc_id               ,

                input                                                  mc_rf_start         ,
                input                                                  global_rf_sel_en    , 
                input                                                  global_rf_sel       ,
                input                                                  global_mc_bist_start,//pulse signal
                input                                                  global_mc_bist_en   ,
                input                                                  global_mc_rescan_start ,//default 0,pulse signal
                input                                                  global_dram_init_en ,
                output                                                 mc2phy_dram0_mask   ,
                output                                                 mc2phy_dram1_mask   ,
                output                                                 mc2phy_dram2_mask   ,
                output                                                 mc2phy_dram3_mask   ,



                input                                                  global_rf_cnt_clr   ,
                input                                                  global_bist_clr     ,//pulse signal
                input    [3:0]                                         bist_rescan_num     ,//default 3,max 8
                input                                                  mc_scan_timeout_en  ,//initial scan timeout en
                input                                                  mc_bist_csl_vmc_en  ,

                input                                                  rf_range_change_en  ,
                input                                                  pre_precharge       ,
                input                                                  page_mode_switch    ,
                input    [ARRAY_ROW_ADDR_WIDTH*2-1:0]                  rf_addr             ,//{rf_start_addr,rf_end_addr}

                input                                                  dbg_data_store_en   ,//dbg function, store latest frame and rdata 
                //apb bus
                input                                                  apb_clk             ,
                input                                                  apb_rst_n           ,
                //pe apb bus
                //input                                                  pe_apb_sel          ,
                //input                                                  pe_apb_enable       ,
                //input                                                  pe_apb_write        ,
                //input    [APB_ADDR_WIDTH-1:0]                          pe_apb_addr         ,
                //input    [APB_DATA_WIDTH-1:0]                          pe_apb_wdata        ,
                //output   [APB_DATA_WIDTH-1:0]                          pe_apb_rdata        ,
                //output                                                 pe_apb_pslverr      ,
                //output                                                 pe_apb_pready       ,
                //soc apb bus
                input                                                  apb_sel             ,
                input                                                  apb_enable          ,
                input                                                  apb_write           ,
                input    [APB_ADDR_WIDTH-1:0]                          apb_addr            ,
                input    [APB_DATA_WIDTH-1:0]                          apb_wdata           ,
                output   [APB_DATA_WIDTH-1:0]                          apb_rdata           ,
                output                                                 apb_pslverr         ,
                output                                                 apb_pready          ,

                //array interface

                output   [MC_SHORT_MODE-1:0]                           bnksel_n            , 
                output   [MC_SHORT_MODE-1:0]                           gcas_wr             ,
                output   [MC_SHORT_MODE-1:0]                           gcas_rd             ,
            
                output   [ARRAY_ROW_ADDR_WIDTH-1:0]                    gradd_n             ,
                output   [ARRAY_COL_ADDR_WIDTH-1:0]                    gcadd               ,
                //output                                                 wrrdy_n             ,
                output   [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]         wdl                 ,
                output                                                 wdl_oe              ,
                input                                                  rdrdy_n             ,
                input    [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]         rdl                 ,
                //hub to mc frame
                input                                                  hub_frame_vld       ,
                output                                                 hub_frame_rdy       ,
                input    [HUB_FRAME_WIDTH-2:0]                         hub_frame_data      ,//layer_id,vld,rw_flag,sof,eof,checkbit,data,row,col
                //bresp
                output reg                                             mc_bresp            ,
                output reg                                             mc_bresp_vld        ,
                //array read data
                output                                                 mc_rvalid           ,
                output   [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]         mc_rdata            ,
                //phy timing cfg
                output   [7:0]                                         bank_radd_set_time_o,
                output   [3:0]                                         cadd_set_time_o     ,
                output   [7:0]                                         r_cas_set_time_o    ,
                output   [7:0]                                         w_cas_set_time_o    ,
                //output   [7:0]                                         cas_wrrdy_time_o    ,
                //array timing cfg
                input    [5:0]                                         mc_trc_cfg          ,//active to active time
                input    [4:0]                                         mc_tras_cfg         ,//rcd active to precharge time
                input    [3:0]                                         mc_trp_cfg          ,//precharge time
                input    [4:0]                                         mc_trcd_cfg         ,//write rcd time
                input    [0:0]                                         mc_trtp_cfg         ,//rd cas rising edge to precharge time
                input    [3:0]                                         mc_twr_cfg          ,//wr cas falling edge to precharge time
                input    [2:0]                                         mc_twtr_cfg         ,//write cas To Read cas time
                input    [3:0]                                         mc_trtw_cfg         ,//Read cas To Write cas time

                
                input    [CSL_ERR_TH_WIDTH-1:0]                        csl_err_threshold   ,
                input    [3:0]                                         wl_single_pattern_rd_num,
                output                                                 bist_rescan_success ,
                output                                                 bist_rescan_finish  ,
                //timeout
                input    [31:0]                                        mc_timeout_th       ,
                //stc ctrl
                input                                                  mc_rf_start_sel     ,//0:sel input rf start,1:sel mc local cfg
                input    [31:0]                                        rf_start_time       ,//dap_aux cfg rf start time
                input                                                  mc_rf_period_sel    ,//0:sel input rf period,1:sel mc local,default 0

                input    [ARRAY_ROW_ADDR_WIDTH-1:0]                    rf_row_num          ,
                input    [31:0]                                        rf_single_interval  ,
                input    [2:0]                                         rf_gear_id          ,//0:64ms,1:32ms,2:16ms,3:8ms,4:4ms
                input                                                  rf_gear_up_en       ,//pulse signal
                
                //rst release rst
                //output                                                 mc_sys_rst_release  ,
                //output                                                 mc_apb_rst_release  , 
                //intrupt
                output                                                 bist_finish_intr    ,
                output                                                 mc_timeout_intr     ,
                //bist success
                output                                                 mc_bank_success     ,
                //monitor
                output   [49:0]                                        monitor_signals     ,
                //ECC info
                output                                                mc_ecc_en                 ,
                input                                                 mc_ecc_ce_overflow_int    ,
                input  [4:0]                                          mc_ecc_ce_cnt             ,
                input  [16*22-1:0]                                    mc_ecc_ce_addr            ,
                input  [15:0]                                         mc_ecc_ce_addr_vld        ,
                input  [16*8-1:0]                                     mc_ecc_ce_addr_cnt        ,
                input                                                 mc_ecc_uce_int            ,
                input  [2:0]                                          mc_ecc_uce_cnt            ,
                input  [4*22-1:0]                                     mc_ecc_uce_addr           ,
                input  [3:0]                                          mc_ecc_uce_addr_vld       ,
                output [4:0]                                          mc_ecc_ce_th              ,
                output                                                mc_ecc_ce_int_clr         ,
                output                                                mc_ecc_uce_int_clr        ,
                output                                                mc_ecc_ce_int_mask        ,
                output                                                mc_ecc_ce_int_en          ,
                output                                                mc_ecc_uce_int_mask       
    );
wire                                             mc_debug_en         ;
wire                                             mc_fake_bresp_en    ;
wire                                             mc_frame_vld        ;
wire                                             mc_frame_rdy        ;
wire     [HUB_FRAME_WIDTH-2:0]                   mc_frame_data       ;
wire                                             mc_back_rvalid      ;
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]   mc_back_rdata       ;
wire                                             rst_mc_n            ;
wire                                             presetn             ;
wire                                             bank_success        ;
wire                                             bist_finish_int     ;
wire                                             rescan_finish_intr  ;


//-----------------------------reset release------------------------------------
/*
wl_rst_sync_aux u_rst_mc_n(
    .clk_i       (clk),
    .rst_n_i     (rst_n),
    .rst_n_sync_o(rst_mc_n)
);
wl_rst_sync_aux u_rst_apb_n(
    .clk_i       (apb_clk),
    .rst_n_i     (apb_rst_n),
    .rst_n_sync_o(presetn)
);

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
*/
//assign mc_sys_rst_release     = rst_mc_n;
//assign mc_apb_rst_release     = presetn;
assign presetn = apb_rst_n  ;
assign rst_mc_n = rst_n;
assign mc_bank_success  = bank_success ;
assign bist_finish_intr = rescan_finish_intr | bist_finish_int ;

mc_frame_debug_aux #(
                .HUB_FRAME_WIDTH   (HUB_FRAME_WIDTH-1),
                .ARRAY_DATA_WIDTH  (ARRAY_DATA_WIDTH+CHECKBIT_WIDTH)
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
                .mc_rvalid     (mc_rvalid       ),
                .mc_rdata      (mc_rdata        )
    );



////--------------------------generate bresponse---------------------------////

always @(posedge clk or negedge rst_mc_n)begin
    if(!rst_mc_n)begin
        mc_bresp_vld <= 1'b0;
        mc_bresp <= 1'b0;
    end
    else if (hub_frame_vld && hub_frame_rdy && hub_frame_data[HUB_FRAME_WIDTH-3] && mc_fake_bresp_en)begin
        mc_bresp_vld <= 1'b1;
        mc_bresp <= 1'b0;
    end
    else if(hub_frame_vld && hub_frame_rdy && hub_frame_data[HUB_FRAME_WIDTH-3] && hub_frame_data[HUB_FRAME_WIDTH-2] && !mc_fake_bresp_en)begin
        mc_bresp_vld <= 1'b1;
        mc_bresp <= 1'b0;
    end
    else begin
        mc_bresp_vld <= 1'b0;
        mc_bresp <= 1'b0;
    end
end


mc_top_aux #(
               .APB_DATA_WIDTH       (APB_DATA_WIDTH        ),
               .APB_ADDR_WIDTH       (APB_ADDR_WIDTH        ),
               .MC_SHORT_MODE        (MC_SHORT_MODE         ),
               .ARRAY_DATA_WIDTH     (ARRAY_DATA_WIDTH      ),
               .ARRAY_ROW_ADDR_WIDTH (ARRAY_ROW_ADDR_WIDTH  ),
               .ARRAY_COL_ADDR_WIDTH (ARRAY_COL_ADDR_WIDTH  ),
               .PATTERN_WIDTH        (PATTERN_WIDTH         ),
               .CSL_ERR_TH_WIDTH     (CSL_ERR_TH_WIDTH      ),
               .CHECKBIT_WIDTH       (CHECKBIT_WIDTH        ),
               .FRAME_WIDTH          (HUB_FRAME_WIDTH       )
)mc_top_u(

                .clk                 (clk                  ),
                .rst_n               (rst_mc_n             ),
                .mc_id               (mc_id                ),
                .ras_clr             (ras_clr              ),

                .mc_rf_start         (mc_rf_start          ),
                .mc_fake_bresp_en    (mc_fake_bresp_en     ),
                .global_rf_sel_en    (global_rf_sel_en     ), 
                .mc2phy_dram0_mask   (mc2phy_dram0_mask    ),
                .mc2phy_dram1_mask   (mc2phy_dram1_mask    ),
                .mc2phy_dram2_mask   (mc2phy_dram2_mask    ),
                .mc2phy_dram3_mask   (mc2phy_dram3_mask    ),


                .global_rf_sel       (global_rf_sel        ),
                .global_mc_bist_start(global_mc_bist_start ),
                .global_mc_bist_en   (global_mc_bist_en    ),
                .global_mc_rescan_start (global_mc_rescan_start),
                .global_dram_init_en (global_dram_init_en  ),
                .global_rf_cnt_clr   (global_rf_cnt_clr    ),//clear rf_cnt,default 1
                .global_bist_clr     (global_bist_clr      ),
                .mc_bist_csl_vmc_en  (mc_bist_csl_vmc_en   ),
                .bist_rescan_num     (bist_rescan_num      ),
                .bist_rescan_success (bist_rescan_success  ),
                .bist_rescan_finish  (rescan_finish_intr   ),
                .bist_rescan_finish_status(bist_rescan_finish),

                .mc_debug_en         (mc_debug_en          ),
                .mc_scan_timeout_en  (mc_scan_timeout_en   ),
                .bist_finish_intr    (bist_finish_int      ),
                .rf_range_change_en  (rf_range_change_en   ),
                .pre_precharge       (pre_precharge        ),
                .page_mode_switch    (page_mode_switch     ),
                .rf_addr             (rf_addr              ),
                .dbg_data_store_en   (dbg_data_store_en    ),
                
                .apb_clk             (apb_clk              ),
                .apb_rst_n           (presetn              ),
                
                //.pe_apb_sel          (pe_apb_sel           ),
                //.pe_apb_enable       (pe_apb_enable        ),
                //.pe_apb_write        (pe_apb_write         ),
                //.pe_apb_addr         (pe_apb_addr          ),
                //.pe_apb_wdata        (pe_apb_wdata         ),
                //.pe_apb_rdata        (pe_apb_rdata         ),
                
                .apb_sel             (apb_sel              ),
                .apb_enable          (apb_enable           ),
                .apb_write           (apb_write            ),
                .apb_addr            (apb_addr             ),
                .apb_wdata           (apb_wdata            ),
                .apb_rdata           (apb_rdata            ),
                .apb_pready          (apb_pready           ),

                .mc_tras_cfg         (mc_tras_cfg          ),//rcd active to precharge time
                .mc_trp_cfg          (mc_trp_cfg           ),//precharge time
                .mc_trc_cfg          (mc_trc_cfg           ),//active to active time
                .mc_trcd_cfg         (mc_trcd_cfg          ),//read rcd time
                .mc_trtp_cfg         (mc_trtp_cfg          ),//rd cas rising edge to precharge time
                .mc_twr_cfg          (mc_twr_cfg           ),//wr cas falling edge to precharge time
                .mc_twtr_cfg         (mc_twtr_cfg          ),//write cas To Read cas time
                .mc_trtw_cfg         (mc_trtw_cfg          ),//Read cas To Write cas time

                .csl_err_threshold   (csl_err_threshold    ),
                .bist_success_status (bank_success         ),
                .wl_single_pattern_rd_num(wl_single_pattern_rd_num),
                
                .mc_timeout_th       (mc_timeout_th        ),
                
                .bnksel_n            (bnksel_n             ), 
                .gradd_n             (gradd_n              ),
                .gcas_wr             (gcas_wr              ),
                .gcas_rd             (gcas_rd              ),
                .gcadd               (gcadd                ),
                //.wrrdy_n             (wrrdy_n              ),
                .wdl                 (wdl                  ),
                .wdl_oe              (wdl_oe               ),
                .rdrdy_n             (rdrdy_n              ),
                .rdl                 (rdl                  ),
                
                .hub_frame_vld       (mc_frame_vld         ),
                .hub_frame_rdy       (mc_frame_rdy         ),
                .hub_frame_data      (mc_frame_data        ),
                
                .mc_rvalid           (mc_back_rvalid       ),
                .mc_rdata            (mc_back_rdata        ),
                
                .bank_radd_set_time  (bank_radd_set_time_o ),
                .cadd_set_time       (cadd_set_time_o      ),
                .r_cas_set_time      (r_cas_set_time_o     ),
                .w_cas_set_time      (w_cas_set_time_o     ),
                //.cas_wrrdy_time      (cas_wrrdy_time_o     ),
                
                .hang_timeout_intr   (mc_timeout_intr      ),
                .monitor_signals     (monitor_signals      ),
                //rf 
                .mc_rf_start_sel     (mc_rf_start_sel      ),
                .rf_start_time       (rf_start_time        ),
                .rf_single_interval  (rf_single_interval   ),
                .rf_gear_up_en       (rf_gear_up_en        ),
                .mc_rf_period_sel    (mc_rf_period_sel     ),
                .rf_row_num          (rf_row_num           ),
                .rf_gear_id          (rf_gear_id           ),

                .apb_pslverr         (apb_pslverr          ),

                .mc_ecc_en                 (mc_ecc_en                 ),
                .mc_ecc_ce_overflow_int    (mc_ecc_ce_overflow_int    ),
                .mc_ecc_ce_cnt             (mc_ecc_ce_cnt             ),
                .mc_ecc_ce_addr            (mc_ecc_ce_addr            ),
                .mc_ecc_ce_addr_vld        (mc_ecc_ce_addr_vld        ),
                .mc_ecc_ce_addr_cnt        (mc_ecc_ce_addr_cnt        ),
                .mc_ecc_uce_int            (mc_ecc_uce_int            ),
                .mc_ecc_uce_cnt            (mc_ecc_uce_cnt            ),
                .mc_ecc_uce_addr           (mc_ecc_uce_addr           ),
                .mc_ecc_uce_addr_vld       (mc_ecc_uce_addr_vld       ),
                .mc_ecc_ce_th              (mc_ecc_ce_th              ),
                .mc_ecc_ce_int_clr         (mc_ecc_ce_int_clr         ),
                .mc_ecc_uce_int_clr        (mc_ecc_uce_int_clr        ),
                .mc_ecc_ce_int_mask        (mc_ecc_ce_int_mask        ),
                .mc_ecc_ce_int_en          (mc_ecc_ce_int_en          ),
                .mc_ecc_uce_int_mask       (mc_ecc_uce_int_mask       )
    );










endmodule
