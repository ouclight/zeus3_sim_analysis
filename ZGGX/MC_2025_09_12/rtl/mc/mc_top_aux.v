module mc_top_aux #(
                parameter    APB_DATA_WIDTH       = 32,
                parameter    APB_ADDR_WIDTH       = 12,
                parameter    MC_SHORT_MODE        = 4,
                parameter    ARRAY_DATA_WIDTH     = 256,
                parameter    RESCAN_ROUND_NUM     = 15,
                parameter    ARRAY_ROW_ADDR_WIDTH = 13,
                parameter    ARRAY_COL_ADDR_WIDTH = 8,
                parameter    PATTERN_WIDTH        = 32,
                parameter    CSL_ERR_TH_WIDTH     = 5,
                parameter    CHECKBIT_WIDTH       = 16,
                parameter    FRAME_WIDTH          = 3+ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+2+1,
                parameter    VMC_FRAME_WIDTH      = 3+ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+2+1
        )(

                input                                                 clk                    ,
                input                                                 rst_n                  ,
                input    [31:0]                                       mc_id                  ,
                input                                                 ras_clr                ,
                //input    [1:0]                                        mc_short_mode          ,
                output                                                mc_fake_bresp_en       ,
                output                                                mc2phy_dram0_mask      ,
                output                                                mc2phy_dram1_mask      ,
                output                                                mc2phy_dram2_mask      ,
                output                                                mc2phy_dram3_mask      ,
                input                                                 mc_rf_start            ,
                input                                                 global_rf_sel_en       , 
                input                                                 global_rf_sel          ,
                input                                                 global_mc_bist_start   ,
                input                                                 global_mc_bist_en      ,
                input                                                 global_bist_clr        ,
                input                                                 global_mc_rescan_start ,
                input                                                 global_dram_init_en    ,
                input                                                 global_rf_cnt_clr      ,//default 0
                input                                                 mc_bist_csl_vmc_en     ,
                input    [3:0]                                        bist_rescan_num        ,//default 3,max 8
                output                                                bist_rescan_success    ,
                output                                                bist_rescan_finish     ,
                output                                                bist_rescan_finish_status,

                                                 
                output                                                mc_debug_en            ,
                input                                                 mc_scan_timeout_en     ,
                output                                                bist_finish_intr       ,

                input                                                 rf_range_change_en     ,
                input                                                 pre_precharge          ,
                input                                                 page_mode_switch       ,
                input    [ARRAY_ROW_ADDR_WIDTH*2-1:0]                 rf_addr                ,//{rf_start_addr,rf_end_addr}
                input                                                 dbg_data_store_en      ,//dbg function, store latest frame and rdata
                
                //apb bus
                input                                                 apb_clk                ,
                input                                                 apb_rst_n              ,
                //pe apb bus
                //input                                                 pe_apb_sel             ,
                //input                                                 pe_apb_enable          ,
                //input                                                 pe_apb_write           ,
                //input    [APB_ADDR_WIDTH-1:0]                         pe_apb_addr            ,
                //input    [APB_DATA_WIDTH-1:0]                         pe_apb_wdata           ,
                //output   [APB_DATA_WIDTH-1:0]                         pe_apb_rdata           ,
                //output                                                pe_apb_pslverr         ,
                //output                                                pe_apb_pready          ,
                //soc apb bus
                input                                                 apb_sel            ,
                input                                                 apb_enable         ,
                input                                                 apb_write          ,
                input    [APB_ADDR_WIDTH-1:0]                         apb_addr           ,
                input    [APB_DATA_WIDTH-1:0]                         apb_wdata          ,
                output   [APB_DATA_WIDTH-1:0]                         apb_rdata          ,
                output                                                apb_pslverr        ,
                output                                                apb_pready         ,


                //array timing cfg
                input    [5:0]                                        mc_trc_cfg             ,//active to active time
                input    [4:0]                                        mc_tras_cfg            ,//rcd active to precharge time
                input    [3:0]                                        mc_trp_cfg             ,//precharge time
                input    [4:0]                                        mc_trcd_cfg            ,//write rcd time
                input    [1:0]                                        mc_trcb_cfg            ,
                input    [0:0]                                        mc_trtp_cfg            ,//rd cas rising edge to precharge time
                input    [3:0]                                        mc_twr_cfg             ,//wr cas falling edge to precharge time
                input    [2:0]                                        mc_twtr_cfg            ,//write cas To Read cas time
                input    [3:0]                                        mc_trtw_cfg            ,//Read cas To Write cas time
                input    [3:0]                                        wl_single_pattern_rd_num,//max 16,default 0 :read one time
                input    [CSL_ERR_TH_WIDTH-1:0]                       csl_err_threshold      ,
                output                                                bist_success_status    ,
                //timeout
                input    [31:0]                                       mc_timeout_th          ,

                //array interface
                output   [MC_SHORT_MODE-1:0]                          bnksel_n               , 
                output   [MC_SHORT_MODE-1:0]                          gcas_wr                ,
                output   [MC_SHORT_MODE-1:0]                          gcas_rd                ,

                output   [ARRAY_ROW_ADDR_WIDTH-1:0]                   gradd_n                ,
                output   [ARRAY_COL_ADDR_WIDTH-1:0]                   gcadd                  ,
                //output                                                wrrdy_n                ,
                output   [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]        wdl                    ,
                output                                                wdl_oe                 ,
                input                                                 rdrdy_n                ,
                input    [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]        rdl                    ,
                //hub to mc frame
                input                                                 hub_frame_vld          ,
                output                                                hub_frame_rdy          ,
                input    [FRAME_WIDTH-2:0]                            hub_frame_data         ,
                //array read data
                output                                                mc_rvalid              ,
                output   [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]        mc_rdata               ,
                //phy timing cfg
                output   [7:0]                                        bank_radd_set_time     ,
                output   [3:0]                                        cadd_set_time          ,
                output   [7:0]                                        r_cas_set_time         ,
                output   [7:0]                                        w_cas_set_time         ,
                //output   [7:0]                                        cas_wrrdy_time         ,
                //intrrupt
                output                                                hang_timeout_intr      ,
                //STC and DFS ctrl
                input                                                 mc_rf_start_sel        ,//0:sel input rf start,1:sel mc local cfg
                input    [31:0]                                       rf_start_time          ,//dap_aux cfg rf start time
                input                                                 mc_rf_period_sel       ,//0:sel input rf period,1:sel mc local,default 0
                
                input                                                 rf_gear_up_en          ,
                input    [2:0]                                        rf_gear_id             ,        
                input    [12:0]                                       rf_row_num             ,        
                input    [31:0]                                       rf_single_interval     ,    

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
                output                                                mc_ecc_uce_int_mask		,  
                //monitor
                output   [49:0]                                       monitor_signals     

    );
wire       [31:0]                                                  mc_rf_period_1          ;
wire       [31:0]                                                  mc_rf_period_2          ;
wire       [31:0]                                                  mc_rf_start_1           ;
wire       [31:0]                                                  mc_rf_start_2           ;
wire                                                               mc_timeout_flag         ;
wire                                                               bist_timeout_clr        ;
wire       [1:0]                                                   dbg_w_frame_cnt         ;  
wire       [1:0]                                                   dbg_r_frame_cnt         ;  
wire       [1:0]                                                   dbg_r_data_cnt          ;  
wire                                                               dbg_refresh_flag        ;
wire       [4:0]                                                   dbg_current_state       ;   
wire       [4:0]                                                   dbg_next_state          ;
wire                                                               mc_frame_vld            ;
wire                                                               mc_frame_rdy            ;
wire       [FRAME_WIDTH-1:0]                                       mc_frame_data           ;  
wire                                                               mc_frame_vmc_vld        ;
wire                                                               mc_frame_vmc_rdy        ;
wire       [VMC_FRAME_WIDTH-1:0]                                   mc_frame_vmc_data       ;  

wire                                                               array_frame_vld         ;
wire                                                               array_frame_rdy         ;
wire       [VMC_FRAME_WIDTH-1:0]                                   array_frame_data        ;  
wire                                                               array_rvalid            ;
wire       [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                   array_rdata             ;
wire                                                               arb_rvalid              ;
wire       [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                   arb_rdata               ;


wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl0_part0     ;
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl1_part0     ;
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl0_part1     ;
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl1_part1     ; 
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl0_part2     ;
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl1_part2     ; 
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl0_part3     ;
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl1_part3     ; 
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl0_part4     ;
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl1_part4     ; 
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl0_part5     ;
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl1_part5     ;
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl0_part6     ;
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl1_part6     ; 
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl0_part7     ;
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl1_part7     ; 
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl0_part8     ;
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl1_part8     ; 
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl0_part9     ;
wire       [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_csl1_part9     ; 




wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl0            ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl1            ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl2            ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl3            ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl4            ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl5            ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl6            ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl7            ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl8            ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl9            ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl10           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl11           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl12           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl13           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl14           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl15           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl16           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl17           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl18           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl19           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl20           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl21           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl22           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl23           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl24           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl25           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl26           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl27           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl28           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl29           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl30           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl31           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl32           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl33           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl34           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl35           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl36           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl37           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl38           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl39           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl40           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl41           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl42           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl43           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl44           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl45           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl46           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl47           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl48           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl49           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl50           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl51           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl52           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl53           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl54           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl55           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl56           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl57           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl58           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl59           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl60           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl61           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl62           ;
wire       [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                bank_err_wl63           ; 

wire                                                               bank_scan_frame_vld          ;
wire                                                               bank_scan_frame_rdy          ;
wire     [FRAME_WIDTH-2:0]                                         bank_scan_frame_data         ;//rw_flag,sof,eof,data,row,col
wire                                                               bank_scan_rvalid             ;
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     bank_scan_rdata              ;

wire                                                               csl_scan_frame_vld           ;
wire                                                               csl_scan_frame_rdy           ;
wire     [FRAME_WIDTH-2:0]                                         csl_scan_frame_data          ;//rw_flag,sof,eof,data,row,col
wire                                                               csl_scan_rvalid              ;
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     csl_scan_rdata               ;

wire                                                               wl_scan_frame_vld            ;
wire                                                               wl_scan_frame_rdy            ;
wire     [FRAME_WIDTH-2:0]                                         wl_scan_frame_data           ;//rw_flag,sof,eof,data,row,col
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     wl_scan_rdata                ;
wire                                                               wl_scan_rvalid               ;

wire                                                               rescan_frame_vld             ;
wire                                                               rescan_frame_rdy             ;
wire     [FRAME_WIDTH-2:0]                                         rescan_frame_data            ;//rw_flag,sof,eof,data,row,col[5:0]
wire                                                               rescan_rvalid                ;
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     rescan_rdata                 ;


wire                                                               func_frame_vld               ;
wire                                                               func_frame_rdy               ;
wire     [FRAME_WIDTH-1:0]                                         func_frame_data              ;//rw_flag,sof,eof,data,row,col
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     func_rdata                   ;
wire                                                               func_rvalid                  ;

wire                                                               dram_init_frame_vld          ;
wire                                                               dram_init_frame_rdy          ;
wire     [FRAME_WIDTH-2:0]                                         dram_init_frame_data         ;//rw_flag,sof,eof,data,row,col
 

reg      [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE*64-1:0]               remap_wl_addr_tmp            ;
reg      [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE*20-1:0]               remap_csl_addr_tmp           ;


wire                                                               mc_rf_cfg_sel_tmp            ;
wire                                                               hang_timeout_en              ;
wire                                                               hang_timeout_en_tmp          ;
wire                                                               global_mc_bist_en_tmp        ;
wire                                                               global_rf_sel_en_tmp         ;
wire                                                               global_mc_bist_start_tmp     ;
wire                                                               global_mc_rescan_start_tmp   ;
wire                                                               global_bist_clr_tmp          ;
wire                                                               mc_bist_csl_vmc_en_tmp       ;
wire                                                               mc_rf_period_sel_tmp         ;
wire                                                               mc_rf_start_sel_tmp          ;
wire                                                               mc_en                        ;
wire                                                               mc_wl_vmc_en                 ;
wire                                                               mc_bl_vmc_en                 ;
wire                                                               mc_wl_vmc_en_tmp             ;
wire                                                               mc_bl_vmc_en_tmp             ;

wire                                                               bist_finish_mask             ;
wire                                                               rescan_finish_mask           ;
wire                                                               mc_en_tmp                    ;
wire                                                               bist_finish_mask_tmp         ;
wire                                                               rescan_finish_mask_tmp       ;

wire                                                               mc_timeout_clr               ;
wire                                                               bist_finish_clr              ;
wire                                                               rescan_finish_clr            ;
wire                                                               hang_timeout_clr             ;

wire                                                               mc_timeout_clr_tmp           ;
wire                                                               rescan_finish_clr_tmp        ;
wire                                                               bist_finish_clr_tmp          ;
wire                                                               hang_timeout_clr_tmp         ;
wire                                                               mc_scan_timeout_en_tmp       ;

wire                                                               rf_range_change_en_tmp       ;
wire                                                               pre_precharge_tmp            ;
wire                                                               hang_timeout_mask_tmp        ;
wire                                                               page_mode_switch_tmp         ;
wire                                                               mc_rf_en                     ;
wire                                                               mc_rf_en_tmp                 ;
wire                                                               mc_rf_burst_split_en         ;
wire                                                               mc_rf_burst_split_en_tmp     ;
wire       [31:0]                                                  hang_timeout_th              ;

wire                                                               rf_req                       ;
wire       [4:0]                                                   array_fsm_cs                 ;
wire       [4:0]                                                   array_fsm_ns                 ;

wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              rf_start_raddr               ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              rf_end_raddr                 ;
wire                                                               mc_rf_cfg_sel                ;
wire                                                               hang_timeout_mask            ;
//wire                                                             bist_success_status            ;
wire                                                               mc_bist_en                   ;
wire                                                               mc_page_status               ;
wire                                                               mc_all_bank_act_en           ;
wire                                                               hang_timeout_status          ;
wire                                                               inner_precharge              ;
wire       [2:0]                                                   bist_scan_status             ;
wire                                                               clk_bist                     ;
//wire       [19:0]                                                  bist_rescan_fail_num         ;
//`ifdef COMMON_MC
wire                                                               dram_init_finish             ;   //wy up
//`endif
//wire                                                               hub_frame_rdy_tmp       ;
wire       [7*MC_SHORT_MODE-1:0]                                   bank_err_wl_cnt              ;
wire       [MC_SHORT_MODE-1:0]                                     bank_err_wl_cnt_change_flag  ;
wire       [MC_SHORT_MODE-1:0]                                     bank_bist_finish             ;

wire       [MC_SHORT_MODE-1:0]                                     bank_bist_success            ;

wire       [MC_SHORT_MODE-1:0]                                     bank_bist_bank_fail          ;
  
wire       [20*MC_SHORT_MODE-1:0]                                  bank_rescan_fail_num          ;
wire       [1*MC_SHORT_MODE-1:0]                                   bank_rescan_finish_status     ;
wire       [1*MC_SHORT_MODE-1:0]                                   bank_rescan_success_status    ;
wire       [RESCAN_ROUND_NUM*MC_SHORT_MODE-1:0]                    bank_rescan_round_result      ;
      


wire                                                               rescan_frame_vld_tmp    ;
wire                                                               func_frame_vld_tmp      ;
wire                                                               wl_scan_frame_vld_tmp   ;
wire                                                               csl_scan_frame_vld_tmp  ;
wire                                                               bank_scan_frame_vld_tmp ;

wire                                                               rescan_frame_rdy_tmp    ;
wire                                                               func_frame_rdy_tmp      ;
wire                                                               wl_scan_frame_rdy_tmp   ;
wire                                                               csl_scan_frame_rdy_tmp  ;
wire                                                               bank_scan_frame_rdy_tmp ;
wire                                                               rescan_working          ;
wire                                                               bist_working            ;
wire                                                               mc_rescan_addr_range_sel       ;           
wire                                                               mc_rescan_addr_range_sel_tmp   ;
wire                                                               mc_csl_scan_addr_range_sel     ;
wire                                                               mc_csl_scan_addr_range_sel_tmp ;
wire                                                               mc_csl_scan_check_sel          ;
wire                                                               mc_csl_scan_check_sel_tmp      ;
wire                                                               global_rf_cnt_clr_tmp          ;
wire                                                               global_dram_init_en_tmp        ;
wire                                                               mc_rdata_invert_sel            ;
wire                                                               mc_rdata_invert_sel_tmp        ;
wire       [14:0]                                                  rescan_round_result            ;
//wire                                                               bist_or_rescan_finish   ;
reg        [FRAME_WIDTH-2:0]                                       dbg_store_latest_frame         ;
reg        [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                   dbg_store_latest_rdata         ;

wire       [31:0]                                                  bist_pattern0                  ;             
wire       [31:0]                                                  bist_pattern1                  ;             
wire       [31:0]                                                  bist_pattern2                  ;             
wire       [31:0]                                                  bist_pattern3                  ;             
wire       [31:0]                                                  bist_pattern4                  ;             
wire       [31:0]                                                  bist_pattern5                  ;             
wire       [31:0]                                                  bist_pattern6                  ;             
wire       [31:0]                                                  bist_pattern7                  ;             
wire       [31:0]                                                  bist_pattern8                  ;             
wire       [31:0]                                                  bist_pattern9                  ;             
wire       [31:0]                                                  bist_pattern10                 ;             
wire       [31:0]                                                  bist_pattern11                 ;             
wire       [31:0]                                                  bist_pattern12                 ;             
wire       [31:0]                                                  bist_pattern13                 ;             
wire       [31:0]                                                  bist_pattern14                 ;             
wire       [31:0]                                                  bist_pattern15                 ;             
wire       [31:0]                                                  bist_pattern16                 ;             
wire       [31:0]                                                  bist_pattern17                 ;             
wire       [31:0]                                                  bist_pattern18                 ;             
wire       [31:0]                                                  bist_pattern19                 ;             
wire       [31:0]                                                  bist_pattern20                 ;             
wire       [31:0]                                                  bist_pattern21                 ;             
wire       [31:0]                                                  bist_pattern22                 ;             
wire       [31:0]                                                  bist_pattern23                 ;             
wire       [31:0]                                                  bist_pattern24                 ;             
wire       [31:0]                                                  bist_pattern25                 ;             
wire       [31:0]                                                  bist_pattern26                 ;             
wire       [31:0]                                                  bist_pattern27                 ;             
wire       [31:0]                                                  bist_pattern28                 ;             
wire       [31:0]                                                  bist_pattern29                 ;             
wire       [31:0]                                                  bist_pattern30                 ;             
wire       [31:0]                                                  bist_pattern31                 ;             
wire       [31:0]                                                  bist_pattern32                 ;             
wire       [31:0]                                                  bist_pattern33                 ;             
wire       [31:0]                                                  bist_pattern34                 ;             
wire       [31:0]                                                  bist_pattern35                 ;             
wire       [31:0]                                                  bist_pattern36                 ;             
wire       [31:0]                                                  bist_pattern37                 ;             
wire       [31:0]                                                  bist_pattern38                 ;             
wire       [31:0]                                                  bist_pattern39                 ;             
wire       [31:0]                                                  bist_pattern40                 ;             
wire       [31:0]                                                  bist_pattern41                 ;             
wire       [31:0]                                                  bist_pattern42                 ;             
wire       [31:0]                                                  bist_pattern43                 ;             
wire       [31:0]                                                  bist_pattern44                 ;             
wire       [31:0]                                                  bist_pattern45                 ;             
wire       [31:0]                                                  bist_pattern46                 ;             
wire       [31:0]                                                  bist_pattern47                 ;             
wire       [31:0]                                                  bist_pattern48                 ;             
wire       [31:0]                                                  bist_pattern49                 ;             
wire       [31:0]                                                  bist_pattern50                 ;             
wire       [31:0]                                                  bist_pattern51                 ;             
wire       [31:0]                                                  bist_pattern52                 ;             
wire       [31:0]                                                  bist_pattern53                 ;             
wire       [31:0]                                                  bist_pattern54                 ;             
wire       [31:0]                                                  bist_pattern55                 ;             
wire       [31:0]                                                  bist_pattern56                 ;             
wire       [31:0]                                                  bist_pattern57                 ;             
wire       [31:0]                                                  bist_pattern58                 ;             
wire       [31:0]                                                  bist_pattern59                 ;             
wire       [31:0]                                                  bist_pattern60                 ;             
wire       [31:0]                                                  bist_pattern61                 ;             
wire       [31:0]                                                  bist_pattern62                 ;             
wire       [31:0]                                                  bist_pattern63                 ;   
wire       [31:0]                                                  bist_pattern_reg0              ;
wire       [31:0]                                                  bist_pattern_reg1              ;
wire       [31:0]                                                  bist_pattern_reg2              ;
wire       [31:0]                                                  bist_pattern_reg3              ;
wire       [67:0]                                                  csl_bist_pattern_sel           ;
wire       [67:0]                                                  wl_bist_pattern_sel            ;
wire       [31:0]                                                  csl_bist_pattern_sel0          ;
wire       [31:0]                                                  csl_bist_pattern_sel1          ;
wire       [3:0]                                                   csl_bist_pattern_sel2          ;
wire       [31:0]                                                  wl_bist_pattern_sel0           ;
wire       [31:0]                                                  wl_bist_pattern_sel1           ;
wire       [3:0]                                                   wl_bist_pattern_sel2           ;
wire                                                               csl_scan_mode_sel              ;
wire                                                               csl_scan_mode_sel_tmp          ;
wire                                                               mc_rdrdy_n_en                  ;
//wire                                                               mc_rdrdy_n_en_tmp              ;
wire                                                               rdrdy_n_monitor                ;
wire       [68*32-1:0]                                             bist_pattern_all               ;
wire                                                               dram_init_working              ;
//reg        [1:0]                                                   layer_id                       ;
wire       [7:0]                                                   bank_map_id                    ;//{bank3_id,bank2_id,bank1_id,bank0_id}
wire       [1:0]                                                   short_mode                     ;
wire       [3:0]                                                   mc_bist_grant                  ;

wire                                                               mc_ecc_en_tmp                  ;
wire                                                               mc_ecc_ce_int_clr_inner        ;
wire                                                               mc_ecc_uce_int_clr_inner       ;
wire                                                               mc_ecc_ce_int_mask_o           ;
wire                                                               mc_ecc_ce_int_en_o             ;
wire                                                               mc_ecc_uce_int_mask_o          ;
wire       [4:0]                                                   mc_ecc_ce_th_tmp               ;
wire                                                               mc_all_bank_act_en_tmp         ;
//wire       [1:0]                                                   mc_short_mode_tmp              ;
wire       [31:0]                                                  bist_clk_cnt_test              ;

wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank0_remap_wl_addr            ;
wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank0_remap_csl_addr           ;
wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank1_remap_wl_addr            ;
wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank1_remap_csl_addr           ;
wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank2_remap_wl_addr            ;
wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank2_remap_csl_addr           ;
wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank3_remap_wl_addr            ;
wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank3_remap_csl_addr           ;

wire       [4-1:0]                                                 bnksel_n_mon                   ;
wire       [4-1:0]                                                 gcas_rd_mon                    ;
wire       [4-1:0]                                                 gcas_wr_mon                    ;

//`ifndef COMMON_MC
//  wy add mc loopback
wire                                                 mc_loopback_en     ;   // 1 enable loopback ; 0 disable loopback
wire    [MC_SHORT_MODE-1:0]                          bnksel_n_mc        ;
wire    [ARRAY_ROW_ADDR_WIDTH-1:0]                   gradd_n_mc         ;
wire    [MC_SHORT_MODE-1:0]                          gcas_rd_mc         ;
wire    [MC_SHORT_MODE-1:0]                          gcas_wr_mc         ;
wire    [ARRAY_COL_ADDR_WIDTH-1:0]                   gcadd_mc           ;
wire    [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]        wdl_mc             ;
wire                                                 wdl_oe_mc          ;
wire                                                 rdrdy_n_mc         ;
wire    [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]        rdl_mc             ;
    
wire                                                 afifo_push         ;
wire                                                 afifo_pop          ;
wire                                                 afifo_empty        ;
//`endif

localparam  IDLE                 = 5'b00000  ,
            RF_UP_RADDR          = 5'b00001  ,
            RF_TRAS_CNT          = 5'b00011  ,
            RF_PRECHARGE         = 5'b00010  ,
            RF_TRP_CNT           = 5'b00110  ,
            W_UP_RADDR           = 5'b00111  ,
            W_TRCD_CNT           = 5'b00101  ,
            W_DATA               = 5'b00100  ,
            W_DATA_LAST          = 5'b01100  ,
            W_TWR_CNT            = 5'b01101  ,
            W_PRECHARGE          = 5'b01111  ,
            W_TRP_CNT            = 5'b01110  ,
            R_UP_RADDR           = 5'b01010  ,
            R_TRCD_CNT           = 5'b01011  ,
            R_DATA               = 5'b01001  ,
            R_DATA_LAST_WITH_PRE = 5'b01000  ,
            R_DATA_LAST          = 5'b11000  ,
            R_TRTP_CNT           = 5'b11001  ,
            R_PRECHARGE          = 5'b10000  ,
            R_TRP_CNT            = 5'b11010  ,
            WTR_CNT_LOAD         = 5'b11011  ,
            RTW_CNT_LOAD         = 5'b11100  ,

            WTR_CNT              = 5'b11101  ,//add write to read state
            RTW_CNT              = 5'b11110  ;//add read to write state





assign rf_end_raddr = rf_addr[ARRAY_ROW_ADDR_WIDTH-1:0];
assign rf_start_raddr = rf_addr[ARRAY_ROW_ADDR_WIDTH*2-1:ARRAY_ROW_ADDR_WIDTH];

assign bist_working = (|bist_scan_status) || rescan_working ;
//assign hub_frame_rdy = global_dram_init_en ? hub_frame_rdy_tmp && dram_init_finish :  hub_frame_rdy_tmp;

//--------------------------------------signal sync start-------------------------------
DW_sync #(
        .width         (15             ),
        .f_sync_type   (2              ),
        .tst_mode      (0              ),
        .verif_en      (1              )
        )U0_mc_ctrl_DW_sync( 
        .clk_d         (clk                                                                             ),
        .rst_d_n       (rst_n                                                                           ),
        .init_d_n      (1'b1                                                                            ),
        .data_s        ({mc_rf_cfg_sel,mc_wl_vmc_en,mc_bl_vmc_en,global_rf_cnt_clr,global_rf_sel_en,
                        global_mc_bist_en,mc_rf_period_sel,mc_rf_start_sel,rf_range_change_en,pre_precharge,page_mode_switch,mc_ecc_en_tmp,mc_ecc_ce_int_mask_o,mc_ecc_uce_int_mask_o,mc_ecc_ce_int_en_o}  ),
        .test          (1'b0                                                                            ),
        .data_d        ({mc_rf_cfg_sel_tmp,mc_wl_vmc_en_tmp,mc_bl_vmc_en_tmp,global_rf_cnt_clr_tmp,global_rf_sel_en_tmp,
                        global_mc_bist_en_tmp,mc_rf_period_sel_tmp,mc_rf_start_sel_tmp,rf_range_change_en_tmp,pre_precharge_tmp,page_mode_switch_tmp,mc_ecc_en,mc_ecc_ce_int_mask,mc_ecc_uce_int_mask,mc_ecc_ce_int_en} )
        ); 

DW_sync #(
        .width         (9             ),
        .f_sync_type   (2              ),
        .tst_mode      (0              ),
        .verif_en      (1              )
        )U1_mc_ctrl_DW_sync( 
        .clk_d         (clk                                                                                                      ),
        .rst_d_n       (rst_n                                                                                                    ),
        .init_d_n      (1'b1                                                                                                     ),
        .data_s        ({mc_en,bist_finish_mask,rescan_finish_mask,mc_csl_scan_check_sel,global_dram_init_en,
                         mc_bist_csl_vmc_en,mc_rdata_invert_sel,mc_rf_en,mc_rf_burst_split_en}                                                                 ),
        .test          (1'b0                                                                                                     ),
        .data_d        ({mc_en_tmp,bist_finish_mask_tmp,rescan_finish_mask_tmp,mc_csl_scan_check_sel_tmp,global_dram_init_en_tmp,
                        mc_bist_csl_vmc_en_tmp,mc_rdata_invert_sel_tmp,mc_rf_en_tmp,mc_rf_burst_split_en_tmp}                                                          )
        );
DW_sync #(
        .width         (7              ),
        .f_sync_type   (2              ),
        .tst_mode      (0              ),
        .verif_en      (1              )
        )U2_mc_ctrl_DW_sync( 
        .clk_d         (clk                                                          ),
        .rst_d_n       (rst_n                                                        ),
        .init_d_n      (1'b1                                                         ),
        .data_s        ({mc_scan_timeout_en,hang_timeout_mask,hang_timeout_en,mc_rescan_addr_range_sel,mc_csl_scan_addr_range_sel,csl_scan_mode_sel,mc_all_bank_act_en}),
        .test          (1'b0                                                                                                   ),
        .data_d        ({mc_scan_timeout_en_tmp,hang_timeout_mask_tmp,hang_timeout_en_tmp,mc_rescan_addr_range_sel_tmp,mc_csl_scan_addr_range_sel_tmp,csl_scan_mode_sel_tmp,mc_all_bank_act_en_tmp})
        );

    pulse2pulse_aux#(
        .IN_RST_VALUE (1'b0),  

        .SPREAD_NUM   (6'd4),
        .OUT_RST_VALUE(1'b0)
    )u_global_mc_bist_start_sync(
      //-------------clock_1 domain -------------------------------
        .clk1  (apb_clk                 ),
        .rst1_n(apb_rst_n               ),
        .in    (global_mc_bist_start    ),
      //-------------clock_2 domain -------------------------------
        .clk2  (clk                     ),
        .rst2_n(rst_n                   ),
        .out   (global_mc_bist_start_tmp) 
    );

    pulse2pulse_aux#(
        .IN_RST_VALUE (1'b0),  
        .SPREAD_NUM   (6'd4),
        .OUT_RST_VALUE(1'b0)
    )u_global_mc_rescan_start_sync(
      //-------------clock_1 domain -------------------------------
        .clk1  (apb_clk                 ),
        .rst1_n(apb_rst_n               ),
        .in    (global_mc_rescan_start  ),
      //-------------clock_2 domain -------------------------------
        .clk2  (clk                     ),
        .rst2_n(rst_n                   ),
        .out   (global_mc_rescan_start_tmp) 
    );

    pulse2pulse_aux#(
        .IN_RST_VALUE (1'b0),  
        .SPREAD_NUM   (6'd4),
        .OUT_RST_VALUE(1'b0)
    )u_global_bist_clr_sync(
      //-------------clock_1 domain -------------------------------
        .clk1  (apb_clk             ),
        .rst1_n(apb_rst_n           ),
        .in    (global_bist_clr     ),
      //-------------clock_2 domain -------------------------------
        .clk2  (clk                 ),
        .rst2_n(rst_n               ),
        .out   (global_bist_clr_tmp ) 
    );  

pulse2pulse_aux#(
        .IN_RST_VALUE (1'b0),  
        .SPREAD_NUM   (6'd4),
        .OUT_RST_VALUE(1'b0)
    )ecc_ce_clr_sync(
      //-------------clock_1 domain -------------------------------
        .clk1  (apb_clk                ),
        .rst1_n(apb_rst_n              ),
        .in    (mc_ecc_ce_int_clr_inner),
      //-------------clock_2 domain -------------------------------
        .clk2  (clk                    ),
        .rst2_n(rst_n                  ),
        .out   (mc_ecc_ce_int_clr      ) 
    ); 

pulse2pulse_aux#(
        .IN_RST_VALUE (1'b0),  
        .SPREAD_NUM   (6'd4),
        .OUT_RST_VALUE(1'b0)
    )ecc_uce_clr_sync(
      //-------------clock_1 domain -------------------------------
        .clk1  (apb_clk                 ),
        .rst1_n(apb_rst_n               ),
        .in    (mc_ecc_uce_int_clr_inner),
      //-------------clock_2 domain -------------------------------
        .clk2  (clk                     ),
        .rst2_n(rst_n                   ),
        .out   (mc_ecc_uce_int_clr      ) 
    );





//--------------------------------------signal sync done-------------------------------
generate
if(MC_SHORT_MODE==4) begin:signal_define0
    wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank0_remap_wl_addr          ;
    wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank0_remap_csl_addr         ;
    wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank1_remap_wl_addr          ;
    wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank1_remap_csl_addr         ;
    wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank2_remap_wl_addr          ;
    wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank2_remap_csl_addr         ;
    wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank3_remap_wl_addr          ;
    wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank3_remap_csl_addr         ;
end
else if(MC_SHORT_MODE==3) begin:signal_define1

    wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank0_remap_wl_addr          ;
    wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank0_remap_csl_addr         ;
    wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank1_remap_wl_addr          ;
    wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank1_remap_csl_addr         ;
    wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank2_remap_wl_addr          ;
    wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank2_remap_csl_addr         ;
end
else if(MC_SHORT_MODE==2) begin:signal_define2

    wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank0_remap_wl_addr          ;
    wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank0_remap_csl_addr         ;
    wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank1_remap_wl_addr          ;
    wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank1_remap_csl_addr         ;
end
else begin:signal_define3

    wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             bank0_remap_wl_addr          ;
    wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             bank0_remap_csl_addr         ;
end
endgenerate






generate
if(MC_SHORT_MODE==4)begin:inst0
apb2reg_mc_1short4_top_aux_cfg_if #(
    .APB_ADDR_WIDTH (APB_ADDR_WIDTH),
    .APB_DATA_WIDTH (APB_DATA_WIDTH)
)apb2reg_mc_top_cfg_if_u0(
// common input ports 
          .pclk                            (apb_clk           ),
          .presetn                         (apb_rst_n         ),
          .psel                            (apb_sel           ),
          .penable                         (apb_enable        ),
          .paddr                           (apb_addr          ),
          .pwrite                          (apb_write         ),
          .pwdata                          (apb_wdata         ),
          .pready                          (apb_pready         ),
          .mc_id_i                         (mc_id             ),// read only signal
          .dbg_next_state_array_i          (dbg_next_state    ),// read only signal
          .dbg_current_state_array_i       (dbg_current_state ),// read only signal
          .dbg_r_data_cnt_i                (dbg_r_data_cnt    ),// read only signal
          .dbg_refresh_flag_i              (dbg_refresh_flag  ),// read only signal
          .dbg_r_frame_cnt_i               (dbg_r_frame_cnt   ),// read only signal
          .dbg_w_frame_cnt_i               (dbg_w_frame_cnt   ),// read only signal
          .mc_timeout_flag_i               (mc_timeout_flag   ),// read only signal
          //.mc_timeout_flag_bank1_i         (mc_timeout_flag_bank1),// read only signal
          //.mc_timeout_flag_bank2_i         (mc_timeout_flag_bank2),// read only signal
          //.mc_timeout_flag_bank3_i         (mc_timeout_flag_bank3),// read only signal

          //.bist_finish_i                   (bist_finish_status),// read only signal
          //.bist_rescan_success_i           (bist_rescan_success),
          //.bist_success_status_i           (bist_success_status),// read only signal
          .err_csl0_part0_bank0_i          (bank_err_csl0_part0[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part0_bank0_i          (bank_err_csl1_part0[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part1_bank0_i          (bank_err_csl0_part1[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part1_bank0_i          (bank_err_csl1_part1[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part2_bank0_i          (bank_err_csl0_part2[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part2_bank0_i          (bank_err_csl1_part2[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part3_bank0_i          (bank_err_csl0_part3[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part3_bank0_i          (bank_err_csl1_part3[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part4_bank0_i          (bank_err_csl0_part4[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part4_bank0_i          (bank_err_csl1_part4[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part5_bank0_i          (bank_err_csl0_part5[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part5_bank0_i          (bank_err_csl1_part5[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part6_bank0_i          (bank_err_csl0_part6[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part6_bank0_i          (bank_err_csl1_part6[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part7_bank0_i          (bank_err_csl0_part7[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part7_bank0_i          (bank_err_csl1_part7[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part8_bank0_i          (bank_err_csl0_part8[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part8_bank0_i          (bank_err_csl1_part8[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part9_bank0_i          (bank_err_csl0_part9[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part9_bank0_i          (bank_err_csl1_part9[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_wl0_bank0_i                 (bank_err_wl0[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl1_bank0_i                 (bank_err_wl1[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl2_bank0_i                 (bank_err_wl2[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl3_bank0_i                 (bank_err_wl3[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl4_bank0_i                 (bank_err_wl4[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl5_bank0_i                 (bank_err_wl5[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl6_bank0_i                 (bank_err_wl6[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl7_bank0_i                 (bank_err_wl7[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl8_bank0_i                 (bank_err_wl8[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl9_bank0_i                 (bank_err_wl9[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl10_bank0_i                (bank_err_wl10[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl11_bank0_i                (bank_err_wl11[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl12_bank0_i                (bank_err_wl12[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl13_bank0_i                (bank_err_wl13[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl14_bank0_i                (bank_err_wl14[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl15_bank0_i                (bank_err_wl15[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl16_bank0_i                (bank_err_wl16[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl17_bank0_i                (bank_err_wl17[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl18_bank0_i                (bank_err_wl18[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl19_bank0_i                (bank_err_wl19[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl20_bank0_i                (bank_err_wl20[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl21_bank0_i                (bank_err_wl21[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl22_bank0_i                (bank_err_wl22[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl23_bank0_i                (bank_err_wl23[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl24_bank0_i                (bank_err_wl24[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl25_bank0_i                (bank_err_wl25[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl26_bank0_i                (bank_err_wl26[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl27_bank0_i                (bank_err_wl27[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl28_bank0_i                (bank_err_wl28[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl29_bank0_i                (bank_err_wl29[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl30_bank0_i                (bank_err_wl30[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl31_bank0_i                (bank_err_wl31[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl32_bank0_i                (bank_err_wl32[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl33_bank0_i                (bank_err_wl33[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl34_bank0_i                (bank_err_wl34[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl35_bank0_i                (bank_err_wl35[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl36_bank0_i                (bank_err_wl36[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl37_bank0_i                (bank_err_wl37[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl38_bank0_i                (bank_err_wl38[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl39_bank0_i                (bank_err_wl39[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl40_bank0_i                (bank_err_wl40[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl41_bank0_i                (bank_err_wl41[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl42_bank0_i                (bank_err_wl42[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl43_bank0_i                (bank_err_wl43[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl44_bank0_i                (bank_err_wl44[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl45_bank0_i                (bank_err_wl45[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl46_bank0_i                (bank_err_wl46[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl47_bank0_i                (bank_err_wl47[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl48_bank0_i                (bank_err_wl48[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl49_bank0_i                (bank_err_wl49[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl50_bank0_i                (bank_err_wl50[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl51_bank0_i                (bank_err_wl51[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl52_bank0_i                (bank_err_wl52[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl53_bank0_i                (bank_err_wl53[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl54_bank0_i                (bank_err_wl54[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl55_bank0_i                (bank_err_wl55[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl56_bank0_i                (bank_err_wl56[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl57_bank0_i                (bank_err_wl57[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl58_bank0_i                (bank_err_wl58[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl59_bank0_i                (bank_err_wl59[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl60_bank0_i                (bank_err_wl60[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl61_bank0_i                (bank_err_wl61[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl62_bank0_i                (bank_err_wl62[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl63_bank0_i                (bank_err_wl63[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          ////bank1
          .err_csl0_part0_bank1_i          (bank_err_csl0_part0[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part0_bank1_i          (bank_err_csl1_part0[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part1_bank1_i          (bank_err_csl0_part1[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part1_bank1_i          (bank_err_csl1_part1[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part2_bank1_i          (bank_err_csl0_part2[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part2_bank1_i          (bank_err_csl1_part2[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part3_bank1_i          (bank_err_csl0_part3[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part3_bank1_i          (bank_err_csl1_part3[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part4_bank1_i          (bank_err_csl0_part4[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part4_bank1_i          (bank_err_csl1_part4[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part5_bank1_i          (bank_err_csl0_part5[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part5_bank1_i          (bank_err_csl1_part5[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part6_bank1_i          (bank_err_csl0_part6[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part6_bank1_i          (bank_err_csl1_part6[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part7_bank1_i          (bank_err_csl0_part7[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part7_bank1_i          (bank_err_csl1_part7[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part8_bank1_i          (bank_err_csl0_part8[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part8_bank1_i          (bank_err_csl1_part8[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl0_part9_bank1_i          (bank_err_csl0_part9[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_csl1_part9_bank1_i          (bank_err_csl1_part9[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),// read only signal
          .err_wl0_bank1_i                 (bank_err_wl0[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl1_bank1_i                 (bank_err_wl1[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl2_bank1_i                 (bank_err_wl2[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl3_bank1_i                 (bank_err_wl3[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl4_bank1_i                 (bank_err_wl4[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl5_bank1_i                 (bank_err_wl5[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl6_bank1_i                 (bank_err_wl6[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl7_bank1_i                 (bank_err_wl7[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl8_bank1_i                 (bank_err_wl8[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl9_bank1_i                 (bank_err_wl9[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl10_bank1_i                (bank_err_wl10[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl11_bank1_i                (bank_err_wl11[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl12_bank1_i                (bank_err_wl12[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl13_bank1_i                (bank_err_wl13[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl14_bank1_i                (bank_err_wl14[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl15_bank1_i                (bank_err_wl15[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl16_bank1_i                (bank_err_wl16[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl17_bank1_i                (bank_err_wl17[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl18_bank1_i                (bank_err_wl18[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl19_bank1_i                (bank_err_wl19[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl20_bank1_i                (bank_err_wl20[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl21_bank1_i                (bank_err_wl21[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl22_bank1_i                (bank_err_wl22[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl23_bank1_i                (bank_err_wl23[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl24_bank1_i                (bank_err_wl24[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl25_bank1_i                (bank_err_wl25[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl26_bank1_i                (bank_err_wl26[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl27_bank1_i                (bank_err_wl27[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl28_bank1_i                (bank_err_wl28[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl29_bank1_i                (bank_err_wl29[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl30_bank1_i                (bank_err_wl30[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl31_bank1_i                (bank_err_wl31[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl32_bank1_i                (bank_err_wl32[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl33_bank1_i                (bank_err_wl33[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl34_bank1_i                (bank_err_wl34[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl35_bank1_i                (bank_err_wl35[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl36_bank1_i                (bank_err_wl36[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl37_bank1_i                (bank_err_wl37[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl38_bank1_i                (bank_err_wl38[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl39_bank1_i                (bank_err_wl39[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl40_bank1_i                (bank_err_wl40[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl41_bank1_i                (bank_err_wl41[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl42_bank1_i                (bank_err_wl42[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl43_bank1_i                (bank_err_wl43[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl44_bank1_i                (bank_err_wl44[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl45_bank1_i                (bank_err_wl45[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl46_bank1_i                (bank_err_wl46[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl47_bank1_i                (bank_err_wl47[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl48_bank1_i                (bank_err_wl48[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl49_bank1_i                (bank_err_wl49[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl50_bank1_i                (bank_err_wl50[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl51_bank1_i                (bank_err_wl51[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl52_bank1_i                (bank_err_wl52[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl53_bank1_i                (bank_err_wl53[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl54_bank1_i                (bank_err_wl54[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl55_bank1_i                (bank_err_wl55[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl56_bank1_i                (bank_err_wl56[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl57_bank1_i                (bank_err_wl57[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl58_bank1_i                (bank_err_wl58[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl59_bank1_i                (bank_err_wl59[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl60_bank1_i                (bank_err_wl60[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl61_bank1_i                (bank_err_wl61[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl62_bank1_i                (bank_err_wl62[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl63_bank1_i                (bank_err_wl63[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          ////bank2
          .err_csl0_part0_bank2_i          (bank_err_csl0_part0[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part0_bank2_i          (bank_err_csl1_part0[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part1_bank2_i          (bank_err_csl0_part1[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part1_bank2_i          (bank_err_csl1_part1[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part2_bank2_i          (bank_err_csl0_part2[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part2_bank2_i          (bank_err_csl1_part2[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part3_bank2_i          (bank_err_csl0_part3[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part3_bank2_i          (bank_err_csl1_part3[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part4_bank2_i          (bank_err_csl0_part4[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part4_bank2_i          (bank_err_csl1_part4[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part5_bank2_i          (bank_err_csl0_part5[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part5_bank2_i          (bank_err_csl1_part5[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part6_bank2_i          (bank_err_csl0_part6[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part6_bank2_i          (bank_err_csl1_part6[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part7_bank2_i          (bank_err_csl0_part7[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part7_bank2_i          (bank_err_csl1_part7[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part8_bank2_i          (bank_err_csl0_part8[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part8_bank2_i          (bank_err_csl1_part8[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part9_bank2_i          (bank_err_csl0_part9[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part9_bank2_i          (bank_err_csl1_part9[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_wl0_bank2_i                 (bank_err_wl0[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl1_bank2_i                 (bank_err_wl1[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl2_bank2_i                 (bank_err_wl2[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl3_bank2_i                 (bank_err_wl3[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl4_bank2_i                 (bank_err_wl4[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl5_bank2_i                 (bank_err_wl5[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl6_bank2_i                 (bank_err_wl6[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl7_bank2_i                 (bank_err_wl7[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl8_bank2_i                 (bank_err_wl8[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl9_bank2_i                 (bank_err_wl9[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl10_bank2_i                (bank_err_wl10[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl11_bank2_i                (bank_err_wl11[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl12_bank2_i                (bank_err_wl12[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl13_bank2_i                (bank_err_wl13[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl14_bank2_i                (bank_err_wl14[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl15_bank2_i                (bank_err_wl15[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl16_bank2_i                (bank_err_wl16[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl17_bank2_i                (bank_err_wl17[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl18_bank2_i                (bank_err_wl18[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl19_bank2_i                (bank_err_wl19[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl20_bank2_i                (bank_err_wl20[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl21_bank2_i                (bank_err_wl21[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl22_bank2_i                (bank_err_wl22[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl23_bank2_i                (bank_err_wl23[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl24_bank2_i                (bank_err_wl24[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl25_bank2_i                (bank_err_wl25[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl26_bank2_i                (bank_err_wl26[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl27_bank2_i                (bank_err_wl27[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl28_bank2_i                (bank_err_wl28[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl29_bank2_i                (bank_err_wl29[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl30_bank2_i                (bank_err_wl30[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl31_bank2_i                (bank_err_wl31[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl32_bank2_i                (bank_err_wl32[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl33_bank2_i                (bank_err_wl33[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl34_bank2_i                (bank_err_wl34[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl35_bank2_i                (bank_err_wl35[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl36_bank2_i                (bank_err_wl36[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl37_bank2_i                (bank_err_wl37[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl38_bank2_i                (bank_err_wl38[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl39_bank2_i                (bank_err_wl39[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl40_bank2_i                (bank_err_wl40[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl41_bank2_i                (bank_err_wl41[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl42_bank2_i                (bank_err_wl42[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl43_bank2_i                (bank_err_wl43[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl44_bank2_i                (bank_err_wl44[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl45_bank2_i                (bank_err_wl45[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl46_bank2_i                (bank_err_wl46[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl47_bank2_i                (bank_err_wl47[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl48_bank2_i                (bank_err_wl48[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl49_bank2_i                (bank_err_wl49[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl50_bank2_i                (bank_err_wl50[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl51_bank2_i                (bank_err_wl51[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl52_bank2_i                (bank_err_wl52[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl53_bank2_i                (bank_err_wl53[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl54_bank2_i                (bank_err_wl54[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl55_bank2_i                (bank_err_wl55[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl56_bank2_i                (bank_err_wl56[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl57_bank2_i                (bank_err_wl57[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl58_bank2_i                (bank_err_wl58[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl59_bank2_i                (bank_err_wl59[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl60_bank2_i                (bank_err_wl60[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl61_bank2_i                (bank_err_wl61[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl62_bank2_i                (bank_err_wl62[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl63_bank2_i                (bank_err_wl63[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          ////bank3
          .err_csl0_part0_bank3_i          (bank_err_csl0_part0[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part0_bank3_i          (bank_err_csl1_part0[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part1_bank3_i          (bank_err_csl0_part1[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part1_bank3_i          (bank_err_csl1_part1[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part2_bank3_i          (bank_err_csl0_part2[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part2_bank3_i          (bank_err_csl1_part2[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part3_bank3_i          (bank_err_csl0_part3[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part3_bank3_i          (bank_err_csl1_part3[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part4_bank3_i          (bank_err_csl0_part4[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part4_bank3_i          (bank_err_csl1_part4[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part5_bank3_i          (bank_err_csl0_part5[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part5_bank3_i          (bank_err_csl1_part5[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part6_bank3_i          (bank_err_csl0_part6[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part6_bank3_i          (bank_err_csl1_part6[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part7_bank3_i          (bank_err_csl0_part7[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part7_bank3_i          (bank_err_csl1_part7[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part8_bank3_i          (bank_err_csl0_part8[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part8_bank3_i          (bank_err_csl1_part8[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part9_bank3_i          (bank_err_csl0_part9[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part9_bank3_i          (bank_err_csl1_part9[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal


          .err_wl0_bank3_i                 (bank_err_wl0[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl1_bank3_i                 (bank_err_wl1[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl2_bank3_i                 (bank_err_wl2[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl3_bank3_i                 (bank_err_wl3[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl4_bank3_i                 (bank_err_wl4[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl5_bank3_i                 (bank_err_wl5[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl6_bank3_i                 (bank_err_wl6[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl7_bank3_i                 (bank_err_wl7[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl8_bank3_i                 (bank_err_wl8[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl9_bank3_i                 (bank_err_wl9[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl10_bank3_i                (bank_err_wl10[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl11_bank3_i                (bank_err_wl11[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl12_bank3_i                (bank_err_wl12[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl13_bank3_i                (bank_err_wl13[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl14_bank3_i                (bank_err_wl14[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl15_bank3_i                (bank_err_wl15[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl16_bank3_i                (bank_err_wl16[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl17_bank3_i                (bank_err_wl17[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl18_bank3_i                (bank_err_wl18[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl19_bank3_i                (bank_err_wl19[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl20_bank3_i                (bank_err_wl20[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl21_bank3_i                (bank_err_wl21[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl22_bank3_i                (bank_err_wl22[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl23_bank3_i                (bank_err_wl23[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl24_bank3_i                (bank_err_wl24[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl25_bank3_i                (bank_err_wl25[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl26_bank3_i                (bank_err_wl26[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl27_bank3_i                (bank_err_wl27[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl28_bank3_i                (bank_err_wl28[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl29_bank3_i                (bank_err_wl29[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl30_bank3_i                (bank_err_wl30[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl31_bank3_i                (bank_err_wl31[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl32_bank3_i                (bank_err_wl32[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl33_bank3_i                (bank_err_wl33[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl34_bank3_i                (bank_err_wl34[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl35_bank3_i                (bank_err_wl35[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl36_bank3_i                (bank_err_wl36[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl37_bank3_i                (bank_err_wl37[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl38_bank3_i                (bank_err_wl38[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl39_bank3_i                (bank_err_wl39[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl40_bank3_i                (bank_err_wl40[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl41_bank3_i                (bank_err_wl41[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl42_bank3_i                (bank_err_wl42[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl43_bank3_i                (bank_err_wl43[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl44_bank3_i                (bank_err_wl44[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl45_bank3_i                (bank_err_wl45[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl46_bank3_i                (bank_err_wl46[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl47_bank3_i                (bank_err_wl47[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl48_bank3_i                (bank_err_wl48[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl49_bank3_i                (bank_err_wl49[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl50_bank3_i                (bank_err_wl50[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl51_bank3_i                (bank_err_wl51[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl52_bank3_i                (bank_err_wl52[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl53_bank3_i                (bank_err_wl53[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl54_bank3_i                (bank_err_wl54[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl55_bank3_i                (bank_err_wl55[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl56_bank3_i                (bank_err_wl56[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl57_bank3_i                (bank_err_wl57[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl58_bank3_i                (bank_err_wl58[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl59_bank3_i                (bank_err_wl59[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl60_bank3_i                (bank_err_wl60[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl61_bank3_i                (bank_err_wl61[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl62_bank3_i                (bank_err_wl62[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl63_bank3_i                (bank_err_wl63[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal

          
          .mc_timeout_clr_o                (mc_timeout_clr    ),
          .bist_finish_clr_o               (bist_finish_clr   ),
          
          .mc_en_o                         (mc_en             ),
          .mc_rf_cfg_sel_o                 (mc_rf_cfg_sel     ),
          .mc_debug_en_o                   (mc_debug_en       ),
          .mc_wl_vmc_en_o                  (mc_wl_vmc_en      ),
          .mc_bl_vmc_en_o                  (mc_bl_vmc_en      ),
          .mc_bist_en_o                    (mc_bist_en        ),
          .mc_rdrdy_n_en_o                 (mc_rdrdy_n_en     ),
          .mc_all_bank_act_en_o            (mc_all_bank_act_en),
          .mc2phy_dram0_mask_o             (mc2phy_dram0_mask),

          .mc2phy_dram1_mask_o             (mc2phy_dram1_mask),
          .mc2phy_dram2_mask_o             (mc2phy_dram2_mask),

          .mc2phy_dram3_mask_o             (mc2phy_dram3_mask),

          .mc_rescan_addr_range_sel_o      (mc_rescan_addr_range_sel  ),
          .mc_csl_scan_addr_range_sel_o    (mc_csl_scan_addr_range_sel),
          .mc_csl_scan_check_sel_o         (mc_csl_scan_check_sel     ),
          .mc_rdata_invert_sel_o           (mc_rdata_invert_sel       ),
          .mc_rf_en_o                      (mc_rf_en                  ),
          .mc_rf_burst_split_en_o          (mc_rf_burst_split_en      ),
          .mc_fake_bresp_en_o              (mc_fake_bresp_en          ),

          .bank_radd_set_time_o            (bank_radd_set_time),
          .cadd_set_time_o                 (cadd_set_time     ),
          .r_cas_set_time_o                (r_cas_set_time    ),
          .w_cas_set_time_o                (w_cas_set_time    ),
          .mc_rf_period_1_o                (mc_rf_period_1    ),
          .mc_rf_start_1_o                 (mc_rf_start_1     ),
          .mc_rf_period_2_o                (mc_rf_period_2    ),
          .mc_rf_start_2_o                 (mc_rf_start_2     ),
          .mc_vmc_wl_num0_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num1_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num2_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num3_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num4_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*4 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num5_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*5 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num6_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*6 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num7_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*7 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num8_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*8 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num9_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*9 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num10_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*10 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num11_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*11 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num12_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*12 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num13_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*13 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num14_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*14 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num15_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*15 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num16_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*16 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num17_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*17 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num18_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*18 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num19_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*19 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num20_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*20 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num21_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*21 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num22_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*22 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num23_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*23 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num24_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*24 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num25_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*25 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num26_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*26 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num27_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*27 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num28_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*28 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num29_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*29 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num30_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*30 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num31_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*31 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num32_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*32 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num33_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*33 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num34_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*34 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num35_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*35 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num36_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*36 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num37_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*37 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num38_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*38 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num39_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*39 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num40_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*40 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num41_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*41 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num42_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*42 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num43_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*43 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num44_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*44 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num45_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*45 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num46_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*46 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num47_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*47 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num48_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*48 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num49_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*49 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num50_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*50 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num51_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*51 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num52_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*52 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num53_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*53 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num54_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*54 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num55_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*55 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num56_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*56 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num57_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*57 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num58_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*58 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num59_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*59 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num60_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*60 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num61_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*61 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num62_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*62 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num63_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*63 +: ARRAY_ROW_ADDR_WIDTH]),
          
          .mc_vmc_bl_num0_part0_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part0_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part1_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part1_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part2_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*4 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part2_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*5 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part3_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*6 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part3_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*7 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part4_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*8 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part4_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*9 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part5_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*10 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part5_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*11 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part6_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*12 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part6_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*13 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part7_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*14 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part7_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*15 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part8_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*16 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part8_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*17 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part9_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*18 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part9_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*19 +: ARRAY_COL_ADDR_WIDTH]),
          //bank1
          .mc_vmc_wl_num0_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num1_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num2_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num3_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num4_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*4 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num5_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*5 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num6_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*6 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num7_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*7 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num8_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*8 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num9_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*9 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num10_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*10 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num11_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*11 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num12_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*12 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num13_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*13 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num14_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*14 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num15_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*15 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num16_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*16 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num17_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*17 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num18_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*18 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num19_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*19 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num20_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*20 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num21_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*21 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num22_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*22 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num23_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*23 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num24_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*24 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num25_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*25 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num26_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*26 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num27_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*27 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num28_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*28 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num29_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*29 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num30_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*30 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num31_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*31 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num32_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*32 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num33_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*33 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num34_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*34 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num35_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*35 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num36_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*36 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num37_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*37 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num38_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*38 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num39_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*39 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num40_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*40 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num41_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*41 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num42_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*42 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num43_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*43 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num44_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*44 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num45_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*45 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num46_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*46 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num47_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*47 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num48_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*48 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num49_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*49 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num50_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*50 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num51_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*51 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num52_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*52 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num53_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*53 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num54_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*54 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num55_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*55 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num56_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*56 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num57_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*57 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num58_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*58 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num59_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*59 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num60_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*60 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num61_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*61 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num62_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*62 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num63_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*63 +: ARRAY_ROW_ADDR_WIDTH]),
          
          .mc_vmc_bl_num0_part0_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part0_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part1_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part1_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part2_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*4 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part2_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*5 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part3_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*6 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part3_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*7 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part4_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*8 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part4_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*9 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part5_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*10 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part5_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*11 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part6_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*12 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part6_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*13 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part7_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*14 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part7_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*15 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part8_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*16 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part8_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*17 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part9_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*18 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part9_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*19 +: ARRAY_COL_ADDR_WIDTH]),
          //bank2
          .mc_vmc_wl_num0_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num1_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num2_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num3_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num4_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*4 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num5_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*5 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num6_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*6 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num7_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*7 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num8_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*8 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num9_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*9 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num10_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*10 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num11_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*11 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num12_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*12 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num13_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*13 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num14_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*14 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num15_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*15 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num16_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*16 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num17_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*17 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num18_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*18 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num19_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*19 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num20_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*20 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num21_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*21 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num22_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*22 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num23_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*23 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num24_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*24 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num25_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*25 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num26_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*26 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num27_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*27 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num28_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*28 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num29_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*29 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num30_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*30 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num31_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*31 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num32_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*32 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num33_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*33 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num34_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*34 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num35_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*35 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num36_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*36 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num37_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*37 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num38_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*38 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num39_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*39 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num40_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*40 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num41_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*41 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num42_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*42 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num43_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*43 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num44_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*44 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num45_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*45 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num46_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*46 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num47_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*47 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num48_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*48 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num49_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*49 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num50_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*50 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num51_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*51 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num52_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*52 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num53_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*53 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num54_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*54 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num55_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*55 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num56_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*56 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num57_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*57 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num58_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*58 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num59_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*59 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num60_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*60 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num61_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*61 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num62_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*62 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num63_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*63 +: ARRAY_ROW_ADDR_WIDTH]),
          
          .mc_vmc_bl_num0_part0_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part0_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part1_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part1_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part2_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*4 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part2_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*5 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part3_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*6 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part3_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*7 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part4_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*8 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part4_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*9 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part5_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*10 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part5_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*11 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part6_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*12 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part6_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*13 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part7_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*14 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part7_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*15 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part8_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*16 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part8_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*17 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part9_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*18 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part9_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*19 +: ARRAY_COL_ADDR_WIDTH]),
           //bank3
          .mc_vmc_wl_num0_bank3_o          (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num1_bank3_o          (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num2_bank3_o          (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num3_bank3_o          (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num4_bank3_o          (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*4 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num5_bank3_o          (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*5 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num6_bank3_o          (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*6 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num7_bank3_o          (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*7 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num8_bank3_o          (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*8 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num9_bank3_o          (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*9 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num10_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*10 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num11_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*11 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num12_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*12 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num13_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*13 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num14_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*14 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num15_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*15 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num16_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*16 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num17_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*17 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num18_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*18 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num19_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*19 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num20_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*20 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num21_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*21 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num22_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*22 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num23_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*23 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num24_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*24 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num25_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*25 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num26_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*26 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num27_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*27 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num28_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*28 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num29_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*29 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num30_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*30 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num31_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*31 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num32_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*32 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num33_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*33 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num34_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*34 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num35_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*35 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num36_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*36 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num37_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*37 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num38_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*38 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num39_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*39 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num40_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*40 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num41_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*41 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num42_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*42 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num43_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*43 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num44_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*44 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num45_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*45 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num46_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*46 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num47_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*47 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num48_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*48 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num49_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*49 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num50_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*50 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num51_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*51 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num52_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*52 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num53_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*53 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num54_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*54 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num55_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*55 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num56_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*56 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num57_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*57 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num58_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*58 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num59_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*59 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num60_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*60 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num61_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*61 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num62_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*62 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num63_bank3_o         (bank3_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*63 +: ARRAY_ROW_ADDR_WIDTH]),
          
          .mc_vmc_bl_num0_part0_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part0_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part1_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part1_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part2_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*4 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part2_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*5 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part3_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*6 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part3_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*7 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part4_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*8 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part4_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*9 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part5_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*10 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part5_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*11 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part6_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*12 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part6_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*13 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part7_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*14 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part7_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*15 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part8_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*16 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part8_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*17 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part9_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*18 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part9_bank3_o    (bank3_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*19 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_rf_start_dbg_i               (mc_rf_start                ),
          .mc_bist_status_i                (bist_scan_status           ),
          //.mc_bist_path_fail_i             (bist_bank_fail           ),
          .dram_init_finish_i              (dram_init_finish           ),
          //.mc_bist_rescan_fail_num_i       (bist_rescan_fail_num       ),

          .mc_bist_err_wl_num_bank0_i      (bank_err_wl_cnt[7*0 +:7]        ),
          .err_wl_num_change_flag_bank0_i  (bank_err_wl_cnt_change_flag[0]  ),
          .mc_bist_err_wl_num_bank1_i      (bank_err_wl_cnt[7*1 +:7]        ),
          .err_wl_num_change_flag_bank1_i  (bank_err_wl_cnt_change_flag[1]  ),
          .mc_bist_err_wl_num_bank2_i      (bank_err_wl_cnt[7*2 +:7]        ),
          .err_wl_num_change_flag_bank2_i  (bank_err_wl_cnt_change_flag[2]  ),
          .mc_bist_err_wl_num_bank3_i      (bank_err_wl_cnt[7*3 +:7]        ),
          .err_wl_num_change_flag_bank3_i  (bank_err_wl_cnt_change_flag[3]  ),

          .bist_finish_bank0_i             (bank_bist_finish[0]           ),
          .bist_finish_bank1_i             (bank_bist_finish[1]           ),
          .bist_finish_bank2_i             (bank_bist_finish[2]           ),
          .bist_finish_bank3_i             (bank_bist_finish[3]           ),

          .bank_success_bank0_i            (bank_bist_success[0]          ),
          .bank_success_bank1_i            (bank_bist_success[1]          ),
          .bank_success_bank2_i            (bank_bist_success[2]          ),
          .bank_success_bank3_i            (bank_bist_success[3]          ),

          .mc_bist_path_fail_bank0_i       (bank_bist_bank_fail[0]        ),
          .mc_bist_path_fail_bank1_i       (bank_bist_bank_fail[1]        ),
          .mc_bist_path_fail_bank2_i       (bank_bist_bank_fail[2]        ),
          .mc_bist_path_fail_bank3_i       (bank_bist_bank_fail[3]        ),

          .bist_rescan_finish_bank0_i      (bank_rescan_finish_status[0]),
          .bist_rescan_finish_bank1_i      (bank_rescan_finish_status[1]),
          .bist_rescan_finish_bank2_i      (bank_rescan_finish_status[2]),
          .bist_rescan_finish_bank3_i      (bank_rescan_finish_status[3]),

          .bist_rescan_success_bank0_i     (bank_rescan_success_status[0]),
          .bist_rescan_success_bank1_i     (bank_rescan_success_status[1]),
          .bist_rescan_success_bank2_i     (bank_rescan_success_status[2]),
          .bist_rescan_success_bank3_i     (bank_rescan_success_status[3]),

          .mc_bist_rescan_fail_num_bank0_i (bank_rescan_fail_num[19:0]  ),
          .mc_bist_rescan_fail_num_bank1_i (bank_rescan_fail_num[39:20] ),
          .mc_bist_rescan_fail_num_bank2_i (bank_rescan_fail_num[59:40] ),
          .mc_bist_rescan_fail_num_bank3_i (bank_rescan_fail_num[79:60] ),


          .rescan_round_result_bank0_i     (bank_rescan_round_result[RESCAN_ROUND_NUM-1:0]                   ),
          .rescan_round_result_bank1_i     (bank_rescan_round_result[RESCAN_ROUND_NUM*2-1:RESCAN_ROUND_NUM]  ),
          .rescan_round_result_bank2_i     (bank_rescan_round_result[RESCAN_ROUND_NUM*3-1:RESCAN_ROUND_NUM*2]),
          .rescan_round_result_bank3_i     (bank_rescan_round_result[RESCAN_ROUND_NUM*4-1:RESCAN_ROUND_NUM*3]),


          //.bist_rescan_finish_ras_i  (bist_rescan_finish_status_ras),
          .bist_pattern_reg0_o             (bist_pattern_reg0          ),
          .bist_pattern_reg1_o             (bist_pattern_reg1          ),
          .bist_pattern_reg2_o             (bist_pattern_reg2          ),
          .bist_pattern_reg3_o             (bist_pattern_reg3          ),
          .csl_bist_pattern_sel0_o         (csl_bist_pattern_sel0      ),
          .csl_bist_pattern_sel1_o         (csl_bist_pattern_sel1      ),
          .csl_bist_pattern_sel2_o         (csl_bist_pattern_sel2      ),

          .wl_bist_pattern_sel0_o          (wl_bist_pattern_sel0       ),
          .wl_bist_pattern_sel1_o          (wl_bist_pattern_sel1       ),
          .wl_bist_pattern_sel2_o          (wl_bist_pattern_sel2       ),

          .mc_csl_scan_mode_sel_o          (csl_scan_mode_sel          ),

          .bist_finish_mask_o              (bist_finish_mask           ),
          .rescan_finish_mask_o            (rescan_finish_mask         ),
          .rescan_finish_clr_o             (rescan_finish_clr          ),
          //.rescan_round_result_i           (rescan_round_result        ),
          .mc_bist_grant_o                 (mc_bist_grant              ),
          .mc_bank_map_id_o                (bank_map_id                ),
          .hang_timeout_th_o               (hang_timeout_th            ),
          //dbg data store begin
          .dbg_frame_store_0_i             (dbg_store_latest_frame[0*32+:32] ),
          .dbg_frame_store_1_i             (dbg_store_latest_frame[1*32+:32] ),
          .dbg_frame_store_2_i             (dbg_store_latest_frame[2*32+:32] ),
          .dbg_frame_store_3_i             (dbg_store_latest_frame[3*32+:32] ),
          .dbg_frame_store_4_i             (dbg_store_latest_frame[4*32+:32] ),
          .dbg_frame_store_5_i             (dbg_store_latest_frame[5*32+:32] ),
          .dbg_frame_store_6_i             (dbg_store_latest_frame[6*32+:32] ),
          .dbg_frame_store_7_i             (dbg_store_latest_frame[7*32+:32] ),
          .dbg_frame_store_8_i             (dbg_store_latest_frame[8*32+:32] ),
          .dbg_frame_store_9_i             (dbg_store_latest_frame[9*32+:10] ),
          .dbg_rdata_store_0_i             (dbg_store_latest_rdata[0*32+:32] ),
          .dbg_rdata_store_1_i             (dbg_store_latest_rdata[1*32+:32] ),
          .dbg_rdata_store_2_i             (dbg_store_latest_rdata[2*32+:32] ),
          .dbg_rdata_store_3_i             (dbg_store_latest_rdata[3*32+:32] ),
          .dbg_rdata_store_4_i             (dbg_store_latest_rdata[4*32+:32] ),
          .dbg_rdata_store_5_i             (dbg_store_latest_rdata[5*32+:32] ),
          .dbg_rdata_store_6_i             (dbg_store_latest_rdata[6*32+:32] ),
          .dbg_rdata_store_7_i             (dbg_store_latest_rdata[7*32+:32] ),
          .dbg_rdata_store_8_i             (dbg_store_latest_rdata[8*32+:16] ),

          .mc_page_status_i                (mc_page_status                   ),// read only signal
          .hang_timeout_status_i           (hang_timeout_status              ),
          .hang_timeout_mask_o             (hang_timeout_mask                ),
          .hang_timeout_clr_o              (hang_timeout_clr                 ),
          .hang_timeout_en_o               (hang_timeout_en                  ),
          .bist_clk_cnt_i                  (bist_clk_cnt_test                ),

          //ecc
          .mc_ecc_ce_overflow_int_i        (mc_ecc_ce_overflow_int     ),
          .mc_ecc_ce_cnt_i                 (mc_ecc_ce_cnt              ),
          .mc_ecc_ce_addr0_i               (mc_ecc_ce_addr[0*22+:22]   ),
          .mc_ecc_ce_addr_vld0_i           (mc_ecc_ce_addr_vld[0]      ),
          .mc_ecc_ce_addr_cnt0_i           (mc_ecc_ce_addr_cnt[0*8+:8] ),
          .mc_ecc_ce_addr1_i               (mc_ecc_ce_addr[1*22+:22]   ),
          .mc_ecc_ce_addr_vld1_i           (mc_ecc_ce_addr_vld[1]      ),
          .mc_ecc_ce_addr_cnt1_i           (mc_ecc_ce_addr_cnt[1*8+:8] ),
          .mc_ecc_ce_addr2_i               (mc_ecc_ce_addr[2*22+:22]   ),
          .mc_ecc_ce_addr_vld2_i           (mc_ecc_ce_addr_vld[2]      ),
          .mc_ecc_ce_addr_cnt2_i           (mc_ecc_ce_addr_cnt[2*8+:8] ),
          .mc_ecc_ce_addr3_i               (mc_ecc_ce_addr[3*22+:22]   ),
          .mc_ecc_ce_addr_vld3_i           (mc_ecc_ce_addr_vld[3]      ),
          .mc_ecc_ce_addr_cnt3_i           (mc_ecc_ce_addr_cnt[3*8+:8] ),
          .mc_ecc_ce_addr4_i               (mc_ecc_ce_addr[4*22+:22]   ),
          .mc_ecc_ce_addr_vld4_i           (mc_ecc_ce_addr_vld[4]      ),
          .mc_ecc_ce_addr_cnt4_i           (mc_ecc_ce_addr_cnt[4*8+:8] ),
          .mc_ecc_ce_addr5_i               (mc_ecc_ce_addr[5*22+:22]   ),
          .mc_ecc_ce_addr_vld5_i           (mc_ecc_ce_addr_vld[5]      ),
          .mc_ecc_ce_addr_cnt5_i           (mc_ecc_ce_addr_cnt[5*8+:8] ),
          .mc_ecc_ce_addr6_i               (mc_ecc_ce_addr[6*22+:22]   ),
          .mc_ecc_ce_addr_vld6_i           (mc_ecc_ce_addr_vld[6]      ),
          .mc_ecc_ce_addr_cnt6_i           (mc_ecc_ce_addr_cnt[6*8+:8] ),
          .mc_ecc_ce_addr7_i               (mc_ecc_ce_addr[7*22+:22]   ),
          .mc_ecc_ce_addr_vld7_i           (mc_ecc_ce_addr_vld[7]      ),
          .mc_ecc_ce_addr_cnt7_i           (mc_ecc_ce_addr_cnt[7*8+:8] ),
          .mc_ecc_ce_addr8_i               (mc_ecc_ce_addr[8*22+:22]   ),
          .mc_ecc_ce_addr_vld8_i           (mc_ecc_ce_addr_vld[8]      ),
          .mc_ecc_ce_addr_cnt8_i           (mc_ecc_ce_addr_cnt[8*8+:8] ),
          .mc_ecc_ce_addr9_i               (mc_ecc_ce_addr[9*22+:22]   ),
          .mc_ecc_ce_addr_vld9_i           (mc_ecc_ce_addr_vld[9]      ),
          .mc_ecc_ce_addr_cnt9_i           (mc_ecc_ce_addr_cnt[9*8+:8] ),
          .mc_ecc_ce_addr10_i              (mc_ecc_ce_addr[10*22+:22]  ),
          .mc_ecc_ce_addr_vld10_i          (mc_ecc_ce_addr_vld[10]     ),
          .mc_ecc_ce_addr_cnt10_i          (mc_ecc_ce_addr_cnt[10*8+:8]),
          .mc_ecc_ce_addr11_i              (mc_ecc_ce_addr[11*22+:22]  ),
          .mc_ecc_ce_addr_vld11_i          (mc_ecc_ce_addr_vld[11]     ),
          .mc_ecc_ce_addr_cnt11_i          (mc_ecc_ce_addr_cnt[11*8+:8]),
          .mc_ecc_ce_addr12_i              (mc_ecc_ce_addr[12*22+:22]  ),
          .mc_ecc_ce_addr_vld12_i          (mc_ecc_ce_addr_vld[12]     ),
          .mc_ecc_ce_addr_cnt12_i          (mc_ecc_ce_addr_cnt[12*8+:8]),
          .mc_ecc_ce_addr13_i              (mc_ecc_ce_addr[13*22+:22]  ),
          .mc_ecc_ce_addr_vld13_i          (mc_ecc_ce_addr_vld[13]     ),
          .mc_ecc_ce_addr_cnt13_i          (mc_ecc_ce_addr_cnt[13*8+:8]),
          .mc_ecc_ce_addr14_i              (mc_ecc_ce_addr[14*22+:22]  ),
          .mc_ecc_ce_addr_vld14_i          (mc_ecc_ce_addr_vld[14]     ),
          .mc_ecc_ce_addr_cnt14_i          (mc_ecc_ce_addr_cnt[14*8+:8]),
          .mc_ecc_ce_addr15_i              (mc_ecc_ce_addr[15*22+:22]  ),
          .mc_ecc_ce_addr_vld15_i          (mc_ecc_ce_addr_vld[15]     ),
          .mc_ecc_ce_addr_cnt15_i          (mc_ecc_ce_addr_cnt[15*8+:8]),
          .mc_ecc_uce_int_i                (mc_ecc_uce_int             ),
          .mc_ecc_uce_cnt_i                (mc_ecc_uce_cnt             ),
          .mc_ecc_uce_addr0_i              (mc_ecc_uce_addr[0*22+:22]  ),
          .mc_ecc_uce_addr_vld0_i          (mc_ecc_uce_addr_vld[0]     ),
          .mc_ecc_uce_addr1_i              (mc_ecc_uce_addr[1*22+:22]  ),
          .mc_ecc_uce_addr_vld1_i          (mc_ecc_uce_addr_vld[1]     ),
          .mc_ecc_uce_addr2_i              (mc_ecc_uce_addr[2*22+:22]  ),
          .mc_ecc_uce_addr_vld2_i          (mc_ecc_uce_addr_vld[2]     ),
          .mc_ecc_uce_addr3_i              (mc_ecc_uce_addr[3*22+:22]  ),
          .mc_ecc_uce_addr_vld3_i          (mc_ecc_uce_addr_vld[3]     ),
          .mc_ecc_ce_th_o                  (mc_ecc_ce_th               ),
          .mc_ecc_ce_int_clr_o             (mc_ecc_ce_int_clr_inner    ),
          .mc_ecc_uce_int_clr_o            (mc_ecc_uce_int_clr_inner   ),
          .mc_ecc_en_o                     (mc_ecc_en_tmp              ),
          .mc_ecc_ce_int_mask_o            (mc_ecc_ce_int_mask_o       ),
          .mc_ecc_ce_int_en_o              (mc_ecc_ce_int_en_o         ),
          .mc_ecc_uce_int_mask_o           (mc_ecc_uce_int_mask_o      ),


          //dbg data store end
          .prdata                          (apb_rdata                   ),
          .pslverr                         (apb_pslverr                 )
    );

end
else if(MC_SHORT_MODE==3)begin:inst1
apb2reg_mc_1short3_top_aux_cfg_if #(
    .APB_ADDR_WIDTH (APB_ADDR_WIDTH),
    .APB_DATA_WIDTH (APB_DATA_WIDTH)
)apb2reg_mc_top_cfg_if_u1(
// common input ports 
          .pclk                            (apb_clk           ),
          .presetn                         (apb_rst_n         ),
          .psel                            (apb_sel           ),
          .penable                         (apb_enable        ),
          .paddr                           (apb_addr          ),
          .pwrite                          (apb_write         ),
          .pwdata                          (apb_wdata         ),
          .pready                          (apb_pready        ),
          .mc_id_i                         (mc_id             ),// read only signal
          .dbg_next_state_array_i          (dbg_next_state    ),// read only signal
          .dbg_current_state_array_i       (dbg_current_state ),// read only signal
          .dbg_r_data_cnt_i                (dbg_r_data_cnt    ),// read only signal
          .dbg_refresh_flag_i              (dbg_refresh_flag  ),// read only signal
          .dbg_r_frame_cnt_i               (dbg_r_frame_cnt   ),// read only signal
          .dbg_w_frame_cnt_i               (dbg_w_frame_cnt   ),// read only signal
          .mc_timeout_flag_i               (mc_timeout_flag   ),// read only signal
          //.bist_finish_i                   (bist_finish_status),// read only signal
          //.bist_rescan_success_i           (bist_rescan_success),
          //.bist_success_status_i           (bist_success_status),// read only signal
          .err_csl0_part0_bank0_i          (bank_err_csl0_part0[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part0_bank0_i          (bank_err_csl1_part0[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part1_bank0_i          (bank_err_csl0_part1[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part1_bank0_i          (bank_err_csl1_part1[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part2_bank0_i          (bank_err_csl0_part2[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part2_bank0_i          (bank_err_csl1_part2[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part3_bank0_i          (bank_err_csl0_part3[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part3_bank0_i          (bank_err_csl1_part3[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part4_bank0_i          (bank_err_csl0_part4[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part4_bank0_i          (bank_err_csl1_part4[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part5_bank0_i          (bank_err_csl0_part5[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part5_bank0_i          (bank_err_csl1_part5[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part6_bank0_i          (bank_err_csl0_part6[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part6_bank0_i          (bank_err_csl1_part6[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part7_bank0_i          (bank_err_csl0_part7[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part7_bank0_i          (bank_err_csl1_part7[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part8_bank0_i          (bank_err_csl0_part8[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part8_bank0_i          (bank_err_csl1_part8[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part9_bank0_i          (bank_err_csl0_part9[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part9_bank0_i          (bank_err_csl1_part9[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_wl0_bank0_i                 (bank_err_wl0[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl1_bank0_i                 (bank_err_wl1[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl2_bank0_i                 (bank_err_wl2[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl3_bank0_i                 (bank_err_wl3[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl4_bank0_i                 (bank_err_wl4[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl5_bank0_i                 (bank_err_wl5[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl6_bank0_i                 (bank_err_wl6[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl7_bank0_i                 (bank_err_wl7[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl8_bank0_i                 (bank_err_wl8[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl9_bank0_i                 (bank_err_wl9[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl10_bank0_i                (bank_err_wl10[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl11_bank0_i                (bank_err_wl11[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl12_bank0_i                (bank_err_wl12[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl13_bank0_i                (bank_err_wl13[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl14_bank0_i                (bank_err_wl14[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl15_bank0_i                (bank_err_wl15[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl16_bank0_i                (bank_err_wl16[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl17_bank0_i                (bank_err_wl17[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl18_bank0_i                (bank_err_wl18[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl19_bank0_i                (bank_err_wl19[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl20_bank0_i                (bank_err_wl20[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl21_bank0_i                (bank_err_wl21[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl22_bank0_i                (bank_err_wl22[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl23_bank0_i                (bank_err_wl23[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl24_bank0_i                (bank_err_wl24[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl25_bank0_i                (bank_err_wl25[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl26_bank0_i                (bank_err_wl26[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl27_bank0_i                (bank_err_wl27[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl28_bank0_i                (bank_err_wl28[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl29_bank0_i                (bank_err_wl29[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl30_bank0_i                (bank_err_wl30[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl31_bank0_i                (bank_err_wl31[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl32_bank0_i                (bank_err_wl32[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl33_bank0_i                (bank_err_wl33[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl34_bank0_i                (bank_err_wl34[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl35_bank0_i                (bank_err_wl35[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl36_bank0_i                (bank_err_wl36[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl37_bank0_i                (bank_err_wl37[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl38_bank0_i                (bank_err_wl38[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl39_bank0_i                (bank_err_wl39[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl40_bank0_i                (bank_err_wl40[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl41_bank0_i                (bank_err_wl41[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl42_bank0_i                (bank_err_wl42[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl43_bank0_i                (bank_err_wl43[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl44_bank0_i                (bank_err_wl44[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl45_bank0_i                (bank_err_wl45[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl46_bank0_i                (bank_err_wl46[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl47_bank0_i                (bank_err_wl47[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl48_bank0_i                (bank_err_wl48[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl49_bank0_i                (bank_err_wl49[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl50_bank0_i                (bank_err_wl50[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl51_bank0_i                (bank_err_wl51[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl52_bank0_i                (bank_err_wl52[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl53_bank0_i                (bank_err_wl53[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl54_bank0_i                (bank_err_wl54[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl55_bank0_i                (bank_err_wl55[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl56_bank0_i                (bank_err_wl56[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl57_bank0_i                (bank_err_wl57[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl58_bank0_i                (bank_err_wl58[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl59_bank0_i                (bank_err_wl59[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl60_bank0_i                (bank_err_wl60[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl61_bank0_i                (bank_err_wl61[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl62_bank0_i                (bank_err_wl62[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl63_bank0_i                (bank_err_wl63[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          ////bank1
          .err_csl0_part0_bank1_i          (bank_err_csl0_part0[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part0_bank1_i          (bank_err_csl1_part0[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part1_bank1_i          (bank_err_csl0_part1[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part1_bank1_i          (bank_err_csl1_part1[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part2_bank1_i          (bank_err_csl0_part2[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part2_bank1_i          (bank_err_csl1_part2[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part3_bank1_i          (bank_err_csl0_part3[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part3_bank1_i          (bank_err_csl1_part3[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part4_bank1_i          (bank_err_csl0_part4[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part4_bank1_i          (bank_err_csl1_part4[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part5_bank1_i          (bank_err_csl0_part5[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part5_bank1_i          (bank_err_csl1_part5[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part6_bank1_i          (bank_err_csl0_part6[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part6_bank1_i          (bank_err_csl1_part6[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part7_bank1_i          (bank_err_csl0_part7[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part7_bank1_i          (bank_err_csl1_part7[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part8_bank1_i          (bank_err_csl0_part8[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part8_bank1_i          (bank_err_csl1_part8[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part9_bank1_i          (bank_err_csl0_part9[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part9_bank1_i          (bank_err_csl1_part9[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_wl0_bank1_i                 (bank_err_wl0[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl1_bank1_i                 (bank_err_wl1[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl2_bank1_i                 (bank_err_wl2[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl3_bank1_i                 (bank_err_wl3[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl4_bank1_i                 (bank_err_wl4[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl5_bank1_i                 (bank_err_wl5[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl6_bank1_i                 (bank_err_wl6[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl7_bank1_i                 (bank_err_wl7[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl8_bank1_i                 (bank_err_wl8[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl9_bank1_i                 (bank_err_wl9[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl10_bank1_i                (bank_err_wl10[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl11_bank1_i                (bank_err_wl11[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl12_bank1_i                (bank_err_wl12[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl13_bank1_i                (bank_err_wl13[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl14_bank1_i                (bank_err_wl14[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl15_bank1_i                (bank_err_wl15[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl16_bank1_i                (bank_err_wl16[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl17_bank1_i                (bank_err_wl17[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl18_bank1_i                (bank_err_wl18[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl19_bank1_i                (bank_err_wl19[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl20_bank1_i                (bank_err_wl20[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl21_bank1_i                (bank_err_wl21[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl22_bank1_i                (bank_err_wl22[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl23_bank1_i                (bank_err_wl23[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl24_bank1_i                (bank_err_wl24[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl25_bank1_i                (bank_err_wl25[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl26_bank1_i                (bank_err_wl26[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl27_bank1_i                (bank_err_wl27[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl28_bank1_i                (bank_err_wl28[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl29_bank1_i                (bank_err_wl29[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl30_bank1_i                (bank_err_wl30[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl31_bank1_i                (bank_err_wl31[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl32_bank1_i                (bank_err_wl32[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl33_bank1_i                (bank_err_wl33[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl34_bank1_i                (bank_err_wl34[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl35_bank1_i                (bank_err_wl35[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl36_bank1_i                (bank_err_wl36[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl37_bank1_i                (bank_err_wl37[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl38_bank1_i                (bank_err_wl38[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl39_bank1_i                (bank_err_wl39[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl40_bank1_i                (bank_err_wl40[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl41_bank1_i                (bank_err_wl41[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl42_bank1_i                (bank_err_wl42[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl43_bank1_i                (bank_err_wl43[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl44_bank1_i                (bank_err_wl44[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl45_bank1_i                (bank_err_wl45[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl46_bank1_i                (bank_err_wl46[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl47_bank1_i                (bank_err_wl47[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl48_bank1_i                (bank_err_wl48[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl49_bank1_i                (bank_err_wl49[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl50_bank1_i                (bank_err_wl50[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl51_bank1_i                (bank_err_wl51[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl52_bank1_i                (bank_err_wl52[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl53_bank1_i                (bank_err_wl53[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl54_bank1_i                (bank_err_wl54[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl55_bank1_i                (bank_err_wl55[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl56_bank1_i                (bank_err_wl56[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl57_bank1_i                (bank_err_wl57[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl58_bank1_i                (bank_err_wl58[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl59_bank1_i                (bank_err_wl59[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl60_bank1_i                (bank_err_wl60[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl61_bank1_i                (bank_err_wl61[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl62_bank1_i                (bank_err_wl62[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl63_bank1_i                (bank_err_wl63[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          ////bank2
          .err_csl0_part0_bank2_i          (bank_err_csl0_part0[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part0_bank2_i          (bank_err_csl1_part0[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part1_bank2_i          (bank_err_csl0_part1[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part1_bank2_i          (bank_err_csl1_part1[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part2_bank2_i          (bank_err_csl0_part2[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part2_bank2_i          (bank_err_csl1_part2[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part3_bank2_i          (bank_err_csl0_part3[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part3_bank2_i          (bank_err_csl1_part3[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part4_bank2_i          (bank_err_csl0_part4[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part4_bank2_i          (bank_err_csl1_part4[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part5_bank2_i          (bank_err_csl0_part5[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part5_bank2_i          (bank_err_csl1_part5[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part6_bank2_i          (bank_err_csl0_part6[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part6_bank2_i          (bank_err_csl1_part6[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part7_bank2_i          (bank_err_csl0_part7[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part7_bank2_i          (bank_err_csl1_part7[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part8_bank2_i          (bank_err_csl0_part8[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part8_bank2_i          (bank_err_csl1_part8[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part9_bank2_i          (bank_err_csl0_part9[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part9_bank2_i          (bank_err_csl1_part9[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_wl0_bank2_i                 (bank_err_wl0[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl1_bank2_i                 (bank_err_wl1[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl2_bank2_i                 (bank_err_wl2[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl3_bank2_i                 (bank_err_wl3[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl4_bank2_i                 (bank_err_wl4[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl5_bank2_i                 (bank_err_wl5[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl6_bank2_i                 (bank_err_wl6[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl7_bank2_i                 (bank_err_wl7[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl8_bank2_i                 (bank_err_wl8[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl9_bank2_i                 (bank_err_wl9[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl10_bank2_i                (bank_err_wl10[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl11_bank2_i                (bank_err_wl11[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl12_bank2_i                (bank_err_wl12[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl13_bank2_i                (bank_err_wl13[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl14_bank2_i                (bank_err_wl14[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl15_bank2_i                (bank_err_wl15[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl16_bank2_i                (bank_err_wl16[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl17_bank2_i                (bank_err_wl17[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl18_bank2_i                (bank_err_wl18[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl19_bank2_i                (bank_err_wl19[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl20_bank2_i                (bank_err_wl20[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl21_bank2_i                (bank_err_wl21[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl22_bank2_i                (bank_err_wl22[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl23_bank2_i                (bank_err_wl23[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl24_bank2_i                (bank_err_wl24[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl25_bank2_i                (bank_err_wl25[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl26_bank2_i                (bank_err_wl26[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl27_bank2_i                (bank_err_wl27[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl28_bank2_i                (bank_err_wl28[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl29_bank2_i                (bank_err_wl29[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl30_bank2_i                (bank_err_wl30[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl31_bank2_i                (bank_err_wl31[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl32_bank2_i                (bank_err_wl32[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl33_bank2_i                (bank_err_wl33[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl34_bank2_i                (bank_err_wl34[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl35_bank2_i                (bank_err_wl35[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl36_bank2_i                (bank_err_wl36[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl37_bank2_i                (bank_err_wl37[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl38_bank2_i                (bank_err_wl38[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl39_bank2_i                (bank_err_wl39[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl40_bank2_i                (bank_err_wl40[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl41_bank2_i                (bank_err_wl41[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl42_bank2_i                (bank_err_wl42[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl43_bank2_i                (bank_err_wl43[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl44_bank2_i                (bank_err_wl44[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl45_bank2_i                (bank_err_wl45[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl46_bank2_i                (bank_err_wl46[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl47_bank2_i                (bank_err_wl47[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl48_bank2_i                (bank_err_wl48[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl49_bank2_i                (bank_err_wl49[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl50_bank2_i                (bank_err_wl50[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl51_bank2_i                (bank_err_wl51[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl52_bank2_i                (bank_err_wl52[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl53_bank2_i                (bank_err_wl53[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl54_bank2_i                (bank_err_wl54[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl55_bank2_i                (bank_err_wl55[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl56_bank2_i                (bank_err_wl56[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl57_bank2_i                (bank_err_wl57[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl58_bank2_i                (bank_err_wl58[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl59_bank2_i                (bank_err_wl59[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl60_bank2_i                (bank_err_wl60[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl61_bank2_i                (bank_err_wl61[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl62_bank2_i                (bank_err_wl62[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl63_bank2_i                (bank_err_wl63[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          
          .mc_timeout_clr_o                (mc_timeout_clr    ),
          .bist_finish_clr_o               (bist_finish_clr   ),
          
          .mc_en_o                         (mc_en             ),
          .mc_rf_cfg_sel_o                 (mc_rf_cfg_sel     ),
          .mc_debug_en_o                   (mc_debug_en       ),
          .mc_wl_vmc_en_o                  (mc_wl_vmc_en      ),
          .mc_bl_vmc_en_o                  (mc_bl_vmc_en      ),
          .mc_bist_en_o                    (mc_bist_en        ),
          .mc_rdrdy_n_en_o                 (mc_rdrdy_n_en     ),
          .mc_all_bank_act_en_o            (mc_all_bank_act_en),

          .mc2phy_dram0_mask_o             (mc2phy_dram0_mask),

          .mc2phy_dram1_mask_o             (mc2phy_dram1_mask),
          .mc2phy_dram2_mask_o             (mc2phy_dram2_mask),

          .mc2phy_dram3_mask_o             (mc2phy_dram3_mask),
          .mc_rescan_addr_range_sel_o      (mc_rescan_addr_range_sel  ),
          .mc_csl_scan_addr_range_sel_o    (mc_csl_scan_addr_range_sel),
          .mc_csl_scan_check_sel_o         (mc_csl_scan_check_sel     ),
          .mc_rdata_invert_sel_o           (mc_rdata_invert_sel       ),
          .mc_rf_burst_split_en_o          (mc_rf_burst_split_en      ),
          .mc_rf_en_o                      (mc_rf_en                  ),
          .mc_fake_bresp_en_o              (mc_fake_bresp_en          ),
          .bank_radd_set_time_o            (bank_radd_set_time),
          .cadd_set_time_o                 (cadd_set_time     ),
          .r_cas_set_time_o                (r_cas_set_time    ),
          .w_cas_set_time_o                (w_cas_set_time    ),
          .mc_rf_period_1_o                (mc_rf_period_1    ),
          .mc_rf_start_1_o                 (mc_rf_start_1     ),
          .mc_rf_period_2_o                (mc_rf_period_2    ),
          .mc_rf_start_2_o                 (mc_rf_start_2     ),
          .mc_vmc_wl_num0_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num1_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num2_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num3_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num4_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*4 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num5_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*5 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num6_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*6 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num7_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*7 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num8_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*8 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num9_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*9 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num10_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*10 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num11_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*11 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num12_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*12 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num13_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*13 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num14_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*14 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num15_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*15 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num16_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*16 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num17_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*17 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num18_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*18 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num19_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*19 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num20_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*20 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num21_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*21 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num22_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*22 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num23_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*23 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num24_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*24 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num25_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*25 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num26_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*26 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num27_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*27 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num28_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*28 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num29_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*29 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num30_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*30 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num31_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*31 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num32_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*32 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num33_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*33 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num34_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*34 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num35_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*35 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num36_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*36 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num37_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*37 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num38_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*38 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num39_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*39 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num40_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*40 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num41_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*41 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num42_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*42 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num43_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*43 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num44_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*44 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num45_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*45 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num46_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*46 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num47_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*47 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num48_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*48 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num49_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*49 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num50_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*50 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num51_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*51 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num52_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*52 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num53_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*53 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num54_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*54 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num55_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*55 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num56_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*56 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num57_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*57 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num58_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*58 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num59_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*59 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num60_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*60 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num61_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*61 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num62_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*62 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num63_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*63 +: ARRAY_ROW_ADDR_WIDTH]),
          
          .mc_vmc_bl_num0_part0_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part0_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part1_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part1_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part2_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*4 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part2_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*5 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part3_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*6 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part3_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*7 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part4_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*8 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part4_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*9 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part5_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*10 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part5_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*11 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part6_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*12 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part6_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*13 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part7_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*14 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part7_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*15 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part8_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*16 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part8_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*17 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part9_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*18 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part9_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*19 +: ARRAY_COL_ADDR_WIDTH]),
          //bank1
          .mc_vmc_wl_num0_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num1_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num2_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num3_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num4_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*4 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num5_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*5 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num6_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*6 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num7_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*7 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num8_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*8 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num9_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*9 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num10_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*10 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num11_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*11 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num12_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*12 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num13_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*13 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num14_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*14 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num15_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*15 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num16_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*16 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num17_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*17 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num18_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*18 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num19_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*19 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num20_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*20 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num21_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*21 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num22_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*22 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num23_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*23 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num24_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*24 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num25_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*25 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num26_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*26 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num27_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*27 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num28_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*28 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num29_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*29 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num30_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*30 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num31_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*31 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num32_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*32 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num33_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*33 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num34_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*34 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num35_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*35 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num36_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*36 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num37_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*37 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num38_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*38 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num39_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*39 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num40_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*40 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num41_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*41 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num42_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*42 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num43_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*43 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num44_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*44 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num45_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*45 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num46_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*46 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num47_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*47 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num48_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*48 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num49_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*49 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num50_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*50 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num51_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*51 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num52_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*52 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num53_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*53 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num54_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*54 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num55_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*55 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num56_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*56 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num57_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*57 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num58_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*58 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num59_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*59 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num60_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*60 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num61_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*61 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num62_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*62 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num63_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*63 +: ARRAY_ROW_ADDR_WIDTH]),
          
          .mc_vmc_bl_num0_part0_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part0_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part1_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part1_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part2_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*4 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part2_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*5 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part3_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*6 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part3_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*7 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part4_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*8 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part4_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*9 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part5_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*10 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part5_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*11 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part6_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*12 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part6_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*13 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part7_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*14 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part7_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*15 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part8_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*16 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part8_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*17 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part9_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*18 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part9_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*19 +: ARRAY_COL_ADDR_WIDTH]),
          //bank2
          .mc_vmc_wl_num0_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num1_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num2_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num3_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num4_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*4 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num5_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*5 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num6_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*6 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num7_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*7 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num8_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*8 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num9_bank2_o          (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*9 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num10_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*10 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num11_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*11 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num12_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*12 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num13_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*13 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num14_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*14 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num15_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*15 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num16_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*16 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num17_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*17 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num18_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*18 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num19_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*19 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num20_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*20 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num21_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*21 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num22_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*22 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num23_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*23 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num24_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*24 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num25_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*25 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num26_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*26 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num27_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*27 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num28_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*28 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num29_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*29 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num30_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*30 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num31_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*31 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num32_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*32 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num33_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*33 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num34_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*34 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num35_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*35 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num36_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*36 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num37_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*37 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num38_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*38 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num39_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*39 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num40_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*40 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num41_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*41 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num42_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*42 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num43_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*43 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num44_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*44 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num45_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*45 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num46_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*46 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num47_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*47 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num48_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*48 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num49_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*49 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num50_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*50 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num51_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*51 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num52_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*52 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num53_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*53 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num54_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*54 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num55_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*55 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num56_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*56 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num57_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*57 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num58_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*58 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num59_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*59 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num60_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*60 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num61_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*61 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num62_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*62 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num63_bank2_o         (bank2_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*63 +: ARRAY_ROW_ADDR_WIDTH]),
          
          .mc_vmc_bl_num0_part0_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part0_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part1_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part1_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part2_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*4 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part2_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*5 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part3_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*6 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part3_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*7 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part4_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*8 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part4_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*9 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part5_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*10 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part5_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*11 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part6_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*12 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part6_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*13 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part7_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*14 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part7_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*15 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part8_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*16 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part8_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*17 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part9_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*18 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part9_bank2_o    (bank2_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*19 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_rf_start_dbg_i               (mc_rf_start                ),
          .mc_bist_status_i                (bist_scan_status           ),
          //.mc_bist_path_fail_i             (bist_bank_fail           ),
          .dram_init_finish_i              (dram_init_finish           ),
          //.mc_bist_rescan_fail_num_i       (bist_rescan_fail_num       ),



          .mc_bist_err_wl_num_bank0_i      (bank_err_wl_cnt[7*0 +:7]        ),
          .err_wl_num_change_flag_bank0_i  (bank_err_wl_cnt_change_flag[0]  ),
          .mc_bist_err_wl_num_bank1_i      (bank_err_wl_cnt[7*1 +:7]        ),
          .err_wl_num_change_flag_bank1_i  (bank_err_wl_cnt_change_flag[1]  ),
          .mc_bist_err_wl_num_bank2_i      (bank_err_wl_cnt[7*2 +:7]        ),
          .err_wl_num_change_flag_bank2_i  (bank_err_wl_cnt_change_flag[2]  ),
          //.mc_bist_err_wl_num_bank3_i      (bank_err_wl_cnt[7*3 +:7]        ),
          //.err_wl_num_change_flag_bank3_i  (bank_err_wl_cnt_change_flag[3]  ),

          .bist_finish_bank0_i             (bank_bist_finish[0]           ),
          .bist_finish_bank1_i             (bank_bist_finish[1]           ),
          .bist_finish_bank2_i             (bank_bist_finish[2]           ),
          //.bist_finish_bank3_i             (bank_bist_finish[3]           ),

          .bank_success_bank0_i            (bank_bist_success[0]          ),
          .bank_success_bank1_i            (bank_bist_success[1]          ),
          .bank_success_bank2_i            (bank_bist_success[2]          ),
          //.bank_success_bank3_i            (bank_bist_success[3]          ),

          .mc_bist_path_fail_bank0_i       (bank_bist_bank_fail[0]        ),
          .mc_bist_path_fail_bank1_i       (bank_bist_bank_fail[1]        ),
          .mc_bist_path_fail_bank2_i       (bank_bist_bank_fail[2]        ),
          //.mc_bist_path_fail_bank3_i       (bank_bist_bank_fail[3]        ),

          .bist_rescan_finish_bank0_i      (bank_rescan_finish_status[0]),
          .bist_rescan_finish_bank1_i      (bank_rescan_finish_status[1]),
          .bist_rescan_finish_bank2_i      (bank_rescan_finish_status[2]),
          //.bist_rescan_finish_bank3_i      (bank_rescan_finish_status[3]),

          .bist_rescan_success_bank0_i     (bank_rescan_success_status[0]),
          .bist_rescan_success_bank1_i     (bank_rescan_success_status[1]),
          .bist_rescan_success_bank2_i     (bank_rescan_success_status[2]),
          //.bist_rescan_success_bank3_i     (bank_rescan_success_status[3]),

          .mc_bist_rescan_fail_num_bank0_i (bank_rescan_fail_num[19:0]  ),
          .mc_bist_rescan_fail_num_bank1_i (bank_rescan_fail_num[39:20] ),
          .mc_bist_rescan_fail_num_bank2_i (bank_rescan_fail_num[59:40] ),
          //.mc_bist_rescan_fail_num_bank3_i (bank_rescan_fail_num[79:60] ),


          .rescan_round_result_bank0_i     (bank_rescan_round_result[RESCAN_ROUND_NUM-1:0]                   ),
          .rescan_round_result_bank1_i     (bank_rescan_round_result[RESCAN_ROUND_NUM*2-1:RESCAN_ROUND_NUM]  ),
          .rescan_round_result_bank2_i     (bank_rescan_round_result[RESCAN_ROUND_NUM*3-1:RESCAN_ROUND_NUM*2]),
          //.rescan_round_result_bank3_i     (bank_rescan_round_result[RESCAN_ROUND_NUM*4-1:RESCAN_ROUND_NUM*3]),

          //.bist_rescan_finish_ras_i  (bist_rescan_finish_status_ras),
          .bist_pattern_reg0_o             (bist_pattern_reg0          ),
          .bist_pattern_reg1_o             (bist_pattern_reg1          ),
          .bist_pattern_reg2_o             (bist_pattern_reg2          ),
          .bist_pattern_reg3_o             (bist_pattern_reg3          ),
          .csl_bist_pattern_sel0_o         (csl_bist_pattern_sel0      ),
          .csl_bist_pattern_sel1_o         (csl_bist_pattern_sel1      ),
          .csl_bist_pattern_sel2_o         (csl_bist_pattern_sel2      ),

          .wl_bist_pattern_sel0_o          (wl_bist_pattern_sel0       ),
          .wl_bist_pattern_sel1_o          (wl_bist_pattern_sel1       ),
          .wl_bist_pattern_sel2_o          (wl_bist_pattern_sel2       ),

          .mc_csl_scan_mode_sel_o          (csl_scan_mode_sel          ),

          .bist_finish_mask_o              (bist_finish_mask           ),
          .rescan_finish_mask_o            (rescan_finish_mask         ),
          .rescan_finish_clr_o             (rescan_finish_clr          ),
          //.rescan_round_result_i           (rescan_round_result        ),
          .mc_bist_grant_o                 (mc_bist_grant              ),
          .mc_bank_map_id_o                (bank_map_id                ),
          .hang_timeout_th_o               (hang_timeout_th            ),
          //dbg data store begin
          .dbg_frame_store_0_i             (dbg_store_latest_frame[0*32+:32] ),
          .dbg_frame_store_1_i             (dbg_store_latest_frame[1*32+:32] ),
          .dbg_frame_store_2_i             (dbg_store_latest_frame[2*32+:32] ),
          .dbg_frame_store_3_i             (dbg_store_latest_frame[3*32+:32] ),
          .dbg_frame_store_4_i             (dbg_store_latest_frame[4*32+:32] ),
          .dbg_frame_store_5_i             (dbg_store_latest_frame[5*32+:32] ),
          .dbg_frame_store_6_i             (dbg_store_latest_frame[6*32+:32] ),
          .dbg_frame_store_7_i             (dbg_store_latest_frame[7*32+:32] ),
          .dbg_frame_store_8_i             (dbg_store_latest_frame[8*32+:32] ),
          .dbg_frame_store_9_i             (dbg_store_latest_frame[9*32+:10] ),
          .dbg_rdata_store_0_i             (dbg_store_latest_rdata[0*32+:32] ),
          .dbg_rdata_store_1_i             (dbg_store_latest_rdata[1*32+:32] ),
          .dbg_rdata_store_2_i             (dbg_store_latest_rdata[2*32+:32] ),
          .dbg_rdata_store_3_i             (dbg_store_latest_rdata[3*32+:32] ),
          .dbg_rdata_store_4_i             (dbg_store_latest_rdata[4*32+:32] ),
          .dbg_rdata_store_5_i             (dbg_store_latest_rdata[5*32+:32] ),
          .dbg_rdata_store_6_i             (dbg_store_latest_rdata[6*32+:32] ),
          .dbg_rdata_store_7_i             (dbg_store_latest_rdata[7*32+:32] ),
          .dbg_rdata_store_8_i             (dbg_store_latest_rdata[8*32+:16] ),


          .mc_page_status_i                (mc_page_status                   ),// read only signal
          .hang_timeout_status_i           (hang_timeout_status              ),
          .hang_timeout_mask_o             (hang_timeout_mask                ),
          .hang_timeout_clr_o              (hang_timeout_clr                 ),
          .hang_timeout_en_o               (hang_timeout_en                  ),
          .bist_clk_cnt_i                  (bist_clk_cnt_test                ),

          //ecc
          .mc_ecc_ce_overflow_int_i        (mc_ecc_ce_overflow_int     ),
          .mc_ecc_ce_cnt_i                 (mc_ecc_ce_cnt              ),
          .mc_ecc_ce_addr0_i               (mc_ecc_ce_addr[0*22+:22]   ),
          .mc_ecc_ce_addr_vld0_i           (mc_ecc_ce_addr_vld[0]      ),
          .mc_ecc_ce_addr_cnt0_i           (mc_ecc_ce_addr_cnt[0*8+:8] ),
          .mc_ecc_ce_addr1_i               (mc_ecc_ce_addr[1*22+:22]   ),
          .mc_ecc_ce_addr_vld1_i           (mc_ecc_ce_addr_vld[1]      ),
          .mc_ecc_ce_addr_cnt1_i           (mc_ecc_ce_addr_cnt[1*8+:8] ),
          .mc_ecc_ce_addr2_i               (mc_ecc_ce_addr[2*22+:22]   ),
          .mc_ecc_ce_addr_vld2_i           (mc_ecc_ce_addr_vld[2]      ),
          .mc_ecc_ce_addr_cnt2_i           (mc_ecc_ce_addr_cnt[2*8+:8] ),
          .mc_ecc_ce_addr3_i               (mc_ecc_ce_addr[3*22+:22]   ),
          .mc_ecc_ce_addr_vld3_i           (mc_ecc_ce_addr_vld[3]      ),
          .mc_ecc_ce_addr_cnt3_i           (mc_ecc_ce_addr_cnt[3*8+:8] ),
          .mc_ecc_ce_addr4_i               (mc_ecc_ce_addr[4*22+:22]   ),
          .mc_ecc_ce_addr_vld4_i           (mc_ecc_ce_addr_vld[4]      ),
          .mc_ecc_ce_addr_cnt4_i           (mc_ecc_ce_addr_cnt[4*8+:8] ),
          .mc_ecc_ce_addr5_i               (mc_ecc_ce_addr[5*22+:22]   ),
          .mc_ecc_ce_addr_vld5_i           (mc_ecc_ce_addr_vld[5]      ),
          .mc_ecc_ce_addr_cnt5_i           (mc_ecc_ce_addr_cnt[5*8+:8] ),
          .mc_ecc_ce_addr6_i               (mc_ecc_ce_addr[6*22+:22]   ),
          .mc_ecc_ce_addr_vld6_i           (mc_ecc_ce_addr_vld[6]      ),
          .mc_ecc_ce_addr_cnt6_i           (mc_ecc_ce_addr_cnt[6*8+:8] ),
          .mc_ecc_ce_addr7_i               (mc_ecc_ce_addr[7*22+:22]   ),
          .mc_ecc_ce_addr_vld7_i           (mc_ecc_ce_addr_vld[7]      ),
          .mc_ecc_ce_addr_cnt7_i           (mc_ecc_ce_addr_cnt[7*8+:8] ),
          .mc_ecc_ce_addr8_i               (mc_ecc_ce_addr[8*22+:22]   ),
          .mc_ecc_ce_addr_vld8_i           (mc_ecc_ce_addr_vld[8]      ),
          .mc_ecc_ce_addr_cnt8_i           (mc_ecc_ce_addr_cnt[8*8+:8] ),
          .mc_ecc_ce_addr9_i               (mc_ecc_ce_addr[9*22+:22]   ),
          .mc_ecc_ce_addr_vld9_i           (mc_ecc_ce_addr_vld[9]      ),
          .mc_ecc_ce_addr_cnt9_i           (mc_ecc_ce_addr_cnt[9*8+:8] ),
          .mc_ecc_ce_addr10_i              (mc_ecc_ce_addr[10*22+:22]  ),
          .mc_ecc_ce_addr_vld10_i          (mc_ecc_ce_addr_vld[10]     ),
          .mc_ecc_ce_addr_cnt10_i          (mc_ecc_ce_addr_cnt[10*8+:8]),
          .mc_ecc_ce_addr11_i              (mc_ecc_ce_addr[11*22+:22]  ),
          .mc_ecc_ce_addr_vld11_i          (mc_ecc_ce_addr_vld[11]     ),
          .mc_ecc_ce_addr_cnt11_i          (mc_ecc_ce_addr_cnt[11*8+:8]),
          .mc_ecc_ce_addr12_i              (mc_ecc_ce_addr[12*22+:22]  ),
          .mc_ecc_ce_addr_vld12_i          (mc_ecc_ce_addr_vld[12]     ),
          .mc_ecc_ce_addr_cnt12_i          (mc_ecc_ce_addr_cnt[12*8+:8]),
          .mc_ecc_ce_addr13_i              (mc_ecc_ce_addr[13*22+:22]  ),
          .mc_ecc_ce_addr_vld13_i          (mc_ecc_ce_addr_vld[13]     ),
          .mc_ecc_ce_addr_cnt13_i          (mc_ecc_ce_addr_cnt[13*8+:8]),
          .mc_ecc_ce_addr14_i              (mc_ecc_ce_addr[14*22+:22]  ),
          .mc_ecc_ce_addr_vld14_i          (mc_ecc_ce_addr_vld[14]     ),
          .mc_ecc_ce_addr_cnt14_i          (mc_ecc_ce_addr_cnt[14*8+:8]),
          .mc_ecc_ce_addr15_i              (mc_ecc_ce_addr[15*22+:22]  ),
          .mc_ecc_ce_addr_vld15_i          (mc_ecc_ce_addr_vld[15]     ),
          .mc_ecc_ce_addr_cnt15_i          (mc_ecc_ce_addr_cnt[15*8+:8]),
          .mc_ecc_uce_int_i                (mc_ecc_uce_int             ),
          .mc_ecc_uce_cnt_i                (mc_ecc_uce_cnt             ),
          .mc_ecc_uce_addr0_i              (mc_ecc_uce_addr[0*22+:22]  ),
          .mc_ecc_uce_addr_vld0_i          (mc_ecc_uce_addr_vld[0]     ),
          .mc_ecc_uce_addr1_i              (mc_ecc_uce_addr[1*22+:22]  ),
          .mc_ecc_uce_addr_vld1_i          (mc_ecc_uce_addr_vld[1]     ),
          .mc_ecc_uce_addr2_i              (mc_ecc_uce_addr[2*22+:22]  ),
          .mc_ecc_uce_addr_vld2_i          (mc_ecc_uce_addr_vld[2]     ),
          .mc_ecc_uce_addr3_i              (mc_ecc_uce_addr[3*22+:22]  ),
          .mc_ecc_uce_addr_vld3_i          (mc_ecc_uce_addr_vld[3]     ),
          .mc_ecc_ce_th_o                  (mc_ecc_ce_th               ),
          .mc_ecc_ce_int_clr_o             (mc_ecc_ce_int_clr_inner     ),
          .mc_ecc_uce_int_clr_o            (mc_ecc_uce_int_clr_inner    ),
          .mc_ecc_en_o                     (mc_ecc_en_tmp               ),
          .mc_ecc_ce_int_mask_o            (mc_ecc_ce_int_mask_o        ),
          .mc_ecc_ce_int_en_o              (mc_ecc_ce_int_en_o          ),
          .mc_ecc_uce_int_mask_o           (mc_ecc_uce_int_mask_o       ),
          //dbg data store end
          .prdata                          (apb_rdata                   ),
          .pslverr                         (apb_pslverr                 )
    );
end
else if(MC_SHORT_MODE==2)begin:inst2
apb2reg_mc_1short2_top_aux_cfg_if #(
    .APB_ADDR_WIDTH (APB_ADDR_WIDTH),
    .APB_DATA_WIDTH (APB_DATA_WIDTH)
)apb2reg_mc_top_cfg_if_u2(
// common input ports 
          .pclk                            (apb_clk           ),
          .presetn                         (apb_rst_n         ),
          .psel                            (apb_sel           ),
          .penable                         (apb_enable        ),
          .paddr                           (apb_addr          ),
          .pwrite                          (apb_write         ),
          .pwdata                          (apb_wdata         ),
          .pready                          (apb_pready         ),
          .mc_id_i                         (mc_id             ),// read only signal
          .dbg_next_state_array_i          (dbg_next_state    ),// read only signal
          .dbg_current_state_array_i       (dbg_current_state ),// read only signal
          .dbg_r_data_cnt_i                (dbg_r_data_cnt    ),// read only signal
          .dbg_refresh_flag_i              (dbg_refresh_flag  ),// read only signal
          .dbg_r_frame_cnt_i               (dbg_r_frame_cnt   ),// read only signal
          .dbg_w_frame_cnt_i               (dbg_w_frame_cnt   ),// read only signal
          .mc_timeout_flag_i               (mc_timeout_flag   ),// read only signal
          //.bist_finish_i                   (bist_finish_status),// read only signal
          //.bist_rescan_success_i           (bist_rescan_success),
          //.bist_success_status_i           (bist_success_status),// read only signal
          .err_csl0_part0_bank0_i          (bank_err_csl0_part0[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part0_bank0_i          (bank_err_csl1_part0[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part1_bank0_i          (bank_err_csl0_part1[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part1_bank0_i          (bank_err_csl1_part1[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part2_bank0_i          (bank_err_csl0_part2[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part2_bank0_i          (bank_err_csl1_part2[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part3_bank0_i          (bank_err_csl0_part3[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part3_bank0_i          (bank_err_csl1_part3[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part4_bank0_i          (bank_err_csl0_part4[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part4_bank0_i          (bank_err_csl1_part4[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part5_bank0_i          (bank_err_csl0_part5[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part5_bank0_i          (bank_err_csl1_part5[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part6_bank0_i          (bank_err_csl0_part6[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part6_bank0_i          (bank_err_csl1_part6[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part7_bank0_i          (bank_err_csl0_part7[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part7_bank0_i          (bank_err_csl1_part7[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part8_bank0_i          (bank_err_csl0_part8[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part8_bank0_i          (bank_err_csl1_part8[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part9_bank0_i          (bank_err_csl0_part9[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part9_bank0_i          (bank_err_csl1_part9[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_wl0_bank0_i                 (bank_err_wl0[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl1_bank0_i                 (bank_err_wl1[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl2_bank0_i                 (bank_err_wl2[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl3_bank0_i                 (bank_err_wl3[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl4_bank0_i                 (bank_err_wl4[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl5_bank0_i                 (bank_err_wl5[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl6_bank0_i                 (bank_err_wl6[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl7_bank0_i                 (bank_err_wl7[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl8_bank0_i                 (bank_err_wl8[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl9_bank0_i                 (bank_err_wl9[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl10_bank0_i                (bank_err_wl10[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl11_bank0_i                (bank_err_wl11[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl12_bank0_i                (bank_err_wl12[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl13_bank0_i                (bank_err_wl13[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl14_bank0_i                (bank_err_wl14[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl15_bank0_i                (bank_err_wl15[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl16_bank0_i                (bank_err_wl16[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl17_bank0_i                (bank_err_wl17[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl18_bank0_i                (bank_err_wl18[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl19_bank0_i                (bank_err_wl19[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl20_bank0_i                (bank_err_wl20[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl21_bank0_i                (bank_err_wl21[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl22_bank0_i                (bank_err_wl22[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl23_bank0_i                (bank_err_wl23[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl24_bank0_i                (bank_err_wl24[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl25_bank0_i                (bank_err_wl25[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl26_bank0_i                (bank_err_wl26[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl27_bank0_i                (bank_err_wl27[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl28_bank0_i                (bank_err_wl28[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl29_bank0_i                (bank_err_wl29[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl30_bank0_i                (bank_err_wl30[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl31_bank0_i                (bank_err_wl31[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl32_bank0_i                (bank_err_wl32[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl33_bank0_i                (bank_err_wl33[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl34_bank0_i                (bank_err_wl34[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl35_bank0_i                (bank_err_wl35[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl36_bank0_i                (bank_err_wl36[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl37_bank0_i                (bank_err_wl37[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl38_bank0_i                (bank_err_wl38[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl39_bank0_i                (bank_err_wl39[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl40_bank0_i                (bank_err_wl40[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl41_bank0_i                (bank_err_wl41[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl42_bank0_i                (bank_err_wl42[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl43_bank0_i                (bank_err_wl43[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl44_bank0_i                (bank_err_wl44[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl45_bank0_i                (bank_err_wl45[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl46_bank0_i                (bank_err_wl46[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl47_bank0_i                (bank_err_wl47[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl48_bank0_i                (bank_err_wl48[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl49_bank0_i                (bank_err_wl49[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl50_bank0_i                (bank_err_wl50[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl51_bank0_i                (bank_err_wl51[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl52_bank0_i                (bank_err_wl52[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl53_bank0_i                (bank_err_wl53[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl54_bank0_i                (bank_err_wl54[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl55_bank0_i                (bank_err_wl55[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl56_bank0_i                (bank_err_wl56[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl57_bank0_i                (bank_err_wl57[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl58_bank0_i                (bank_err_wl58[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl59_bank0_i                (bank_err_wl59[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl60_bank0_i                (bank_err_wl60[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl61_bank0_i                (bank_err_wl61[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl62_bank0_i                (bank_err_wl62[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl63_bank0_i                (bank_err_wl63[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          ////bank1
          .err_csl0_part0_bank1_i          (bank_err_csl0_part0[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl1_part0_bank1_i          (bank_err_csl1_part0[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl0_part1_bank1_i          (bank_err_csl0_part1[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl1_part1_bank1_i          (bank_err_csl1_part1[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl0_part2_bank1_i          (bank_err_csl0_part2[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl1_part2_bank1_i          (bank_err_csl1_part2[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl0_part3_bank1_i          (bank_err_csl0_part3[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl1_part3_bank1_i          (bank_err_csl1_part3[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl0_part4_bank1_i          (bank_err_csl0_part4[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl1_part4_bank1_i          (bank_err_csl1_part4[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl0_part5_bank1_i          (bank_err_csl0_part5[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl1_part5_bank1_i          (bank_err_csl1_part5[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl0_part6_bank1_i          (bank_err_csl0_part6[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl1_part6_bank1_i          (bank_err_csl1_part6[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl0_part7_bank1_i          (bank_err_csl0_part7[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl1_part7_bank1_i          (bank_err_csl1_part7[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl0_part8_bank1_i          (bank_err_csl0_part8[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl1_part8_bank1_i          (bank_err_csl1_part8[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl0_part9_bank1_i          (bank_err_csl0_part9[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_csl1_part9_bank1_i          (bank_err_csl1_part9[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),// read only signal
          .err_wl0_bank1_i                 (bank_err_wl0[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl1_bank1_i                 (bank_err_wl1[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl2_bank1_i                 (bank_err_wl2[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl3_bank1_i                 (bank_err_wl3[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl4_bank1_i                 (bank_err_wl4[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl5_bank1_i                 (bank_err_wl5[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl6_bank1_i                 (bank_err_wl6[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl7_bank1_i                 (bank_err_wl7[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl8_bank1_i                 (bank_err_wl8[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl9_bank1_i                 (bank_err_wl9[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]           ),// read only signal
          .err_wl10_bank1_i                (bank_err_wl10[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl11_bank1_i                (bank_err_wl11[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl12_bank1_i                (bank_err_wl12[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl13_bank1_i                (bank_err_wl13[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl14_bank1_i                (bank_err_wl14[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl15_bank1_i                (bank_err_wl15[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl16_bank1_i                (bank_err_wl16[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl17_bank1_i                (bank_err_wl17[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl18_bank1_i                (bank_err_wl18[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl19_bank1_i                (bank_err_wl19[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl20_bank1_i                (bank_err_wl20[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl21_bank1_i                (bank_err_wl21[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl22_bank1_i                (bank_err_wl22[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl23_bank1_i                (bank_err_wl23[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl24_bank1_i                (bank_err_wl24[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl25_bank1_i                (bank_err_wl25[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl26_bank1_i                (bank_err_wl26[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl27_bank1_i                (bank_err_wl27[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl28_bank1_i                (bank_err_wl28[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl29_bank1_i                (bank_err_wl29[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl30_bank1_i                (bank_err_wl30[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl31_bank1_i                (bank_err_wl31[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl32_bank1_i                (bank_err_wl32[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl33_bank1_i                (bank_err_wl33[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl34_bank1_i                (bank_err_wl34[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl35_bank1_i                (bank_err_wl35[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl36_bank1_i                (bank_err_wl36[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl37_bank1_i                (bank_err_wl37[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl38_bank1_i                (bank_err_wl38[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl39_bank1_i                (bank_err_wl39[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl40_bank1_i                (bank_err_wl40[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl41_bank1_i                (bank_err_wl41[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl42_bank1_i                (bank_err_wl42[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl43_bank1_i                (bank_err_wl43[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl44_bank1_i                (bank_err_wl44[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl45_bank1_i                (bank_err_wl45[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl46_bank1_i                (bank_err_wl46[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl47_bank1_i                (bank_err_wl47[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl48_bank1_i                (bank_err_wl48[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl49_bank1_i                (bank_err_wl49[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl50_bank1_i                (bank_err_wl50[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl51_bank1_i                (bank_err_wl51[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl52_bank1_i                (bank_err_wl52[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl53_bank1_i                (bank_err_wl53[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl54_bank1_i                (bank_err_wl54[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl55_bank1_i                (bank_err_wl55[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl56_bank1_i                (bank_err_wl56[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl57_bank1_i                (bank_err_wl57[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl58_bank1_i                (bank_err_wl58[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl59_bank1_i                (bank_err_wl59[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl60_bank1_i                (bank_err_wl60[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl61_bank1_i                (bank_err_wl61[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl62_bank1_i                (bank_err_wl62[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          .err_wl63_bank1_i                (bank_err_wl63[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]          ),// read only signal
          
          .mc_timeout_clr_o                (mc_timeout_clr    ),
          .bist_finish_clr_o               (bist_finish_clr   ),
          
          .mc_en_o                         (mc_en             ),
          .mc_rf_cfg_sel_o                 (mc_rf_cfg_sel     ),
          .mc_debug_en_o                   (mc_debug_en       ),
          .mc_wl_vmc_en_o                  (mc_wl_vmc_en      ),
          .mc_bl_vmc_en_o                  (mc_bl_vmc_en      ),
          .mc_bist_en_o                    (mc_bist_en        ),
          .mc_rdrdy_n_en_o                 (mc_rdrdy_n_en     ),
          .mc_all_bank_act_en_o            (mc_all_bank_act_en),
          .mc2phy_dram0_mask_o             (mc2phy_dram0_mask),
          .mc2phy_dram1_mask_o             (mc2phy_dram1_mask),
          .mc2phy_dram2_mask_o             (mc2phy_dram2_mask),
          .mc2phy_dram3_mask_o             (mc2phy_dram3_mask),
          .mc_rescan_addr_range_sel_o      (mc_rescan_addr_range_sel  ),
          .mc_csl_scan_addr_range_sel_o    (mc_csl_scan_addr_range_sel),
          .mc_csl_scan_check_sel_o         (mc_csl_scan_check_sel     ),
          .mc_rdata_invert_sel_o           (mc_rdata_invert_sel       ),
          .mc_rf_burst_split_en_o          (mc_rf_burst_split_en      ),
          .mc_rf_en_o                      (mc_rf_en                  ),
          .mc_fake_bresp_en_o              (mc_fake_bresp_en          ),

          .bank_radd_set_time_o            (bank_radd_set_time),
          .cadd_set_time_o                 (cadd_set_time     ),
          .r_cas_set_time_o                (r_cas_set_time    ),
          .w_cas_set_time_o                (w_cas_set_time    ),
          .mc_rf_period_1_o                (mc_rf_period_1    ),
          .mc_rf_start_1_o                 (mc_rf_start_1     ),
          .mc_rf_period_2_o                (mc_rf_period_2    ),
          .mc_rf_start_2_o                 (mc_rf_start_2     ),
          .mc_vmc_wl_num0_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num1_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num2_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num3_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num4_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*4 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num5_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*5 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num6_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*6 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num7_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*7 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num8_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*8 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num9_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*9 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num10_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*10 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num11_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*11 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num12_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*12 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num13_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*13 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num14_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*14 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num15_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*15 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num16_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*16 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num17_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*17 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num18_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*18 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num19_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*19 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num20_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*20 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num21_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*21 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num22_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*22 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num23_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*23 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num24_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*24 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num25_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*25 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num26_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*26 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num27_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*27 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num28_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*28 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num29_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*29 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num30_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*30 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num31_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*31 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num32_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*32 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num33_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*33 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num34_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*34 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num35_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*35 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num36_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*36 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num37_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*37 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num38_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*38 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num39_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*39 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num40_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*40 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num41_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*41 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num42_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*42 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num43_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*43 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num44_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*44 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num45_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*45 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num46_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*46 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num47_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*47 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num48_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*48 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num49_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*49 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num50_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*50 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num51_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*51 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num52_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*52 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num53_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*53 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num54_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*54 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num55_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*55 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num56_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*56 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num57_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*57 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num58_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*58 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num59_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*59 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num60_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*60 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num61_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*61 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num62_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*62 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num63_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*63 +: ARRAY_ROW_ADDR_WIDTH]),
          
          .mc_vmc_bl_num0_part0_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part0_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part1_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part1_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part2_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*4 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part2_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*5 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part3_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*6 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part3_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*7 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part4_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*8 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part4_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*9 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part5_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*10 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part5_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*11 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part6_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*12 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part6_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*13 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part7_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*14 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part7_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*15 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part8_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*16 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part8_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*17 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part9_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*18 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part9_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*19 +: ARRAY_COL_ADDR_WIDTH]),
          //bank1
          .mc_vmc_wl_num0_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num1_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num2_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num3_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num4_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*4 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num5_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*5 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num6_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*6 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num7_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*7 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num8_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*8 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num9_bank1_o          (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*9 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num10_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*10 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num11_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*11 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num12_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*12 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num13_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*13 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num14_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*14 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num15_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*15 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num16_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*16 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num17_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*17 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num18_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*18 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num19_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*19 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num20_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*20 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num21_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*21 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num22_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*22 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num23_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*23 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num24_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*24 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num25_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*25 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num26_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*26 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num27_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*27 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num28_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*28 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num29_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*29 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num30_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*30 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num31_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*31 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num32_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*32 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num33_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*33 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num34_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*34 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num35_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*35 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num36_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*36 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num37_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*37 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num38_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*38 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num39_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*39 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num40_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*40 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num41_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*41 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num42_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*42 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num43_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*43 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num44_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*44 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num45_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*45 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num46_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*46 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num47_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*47 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num48_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*48 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num49_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*49 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num50_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*50 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num51_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*51 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num52_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*52 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num53_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*53 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num54_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*54 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num55_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*55 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num56_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*56 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num57_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*57 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num58_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*58 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num59_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*59 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num60_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*60 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num61_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*61 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num62_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*62 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num63_bank1_o         (bank1_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*63 +: ARRAY_ROW_ADDR_WIDTH]),
          
          .mc_vmc_bl_num0_part0_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part0_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part1_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part1_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part2_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*4 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part2_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*5 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part3_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*6 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part3_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*7 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part4_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*8 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part4_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*9 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part5_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*10 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part5_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*11 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part6_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*12 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part6_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*13 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part7_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*14 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part7_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*15 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part8_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*16 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part8_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*17 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part9_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*18 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part9_bank1_o    (bank1_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*19 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_rf_start_dbg_i               (mc_rf_start                ),
          .mc_bist_status_i                (bist_scan_status           ),
          //.mc_bist_path_fail_i             (bist_bank_fail           ),
          .dram_init_finish_i              (dram_init_finish           ),
          //.mc_bist_rescan_fail_num_i       (bist_rescan_fail_num       ),

          .mc_bist_err_wl_num_bank0_i      (bank_err_wl_cnt[7*0 +:7]        ),
          .err_wl_num_change_flag_bank0_i  (bank_err_wl_cnt_change_flag[0]  ),
          .mc_bist_err_wl_num_bank1_i      (bank_err_wl_cnt[7*1 +:7]        ),
          .err_wl_num_change_flag_bank1_i  (bank_err_wl_cnt_change_flag[1]  ),
          //.mc_bist_err_wl_num_bank2_i      (bank_err_wl_cnt[7*2 +:7]        ),
          //.err_wl_num_change_flag_bank2_i  (bank_err_wl_cnt_change_flag[2]  ),
          //.mc_bist_err_wl_num_bank3_i      (bank_err_wl_cnt[7*3 +:7]        ),
          //.err_wl_num_change_flag_bank3_i  (bank_err_wl_cnt_change_flag[3]  ),

          .bist_finish_bank0_i             (bank_bist_finish[0]           ),
          .bist_finish_bank1_i             (bank_bist_finish[1]           ),
          //.bist_finish_bank2_i             (bank_bist_finish[2]           ),
          //.bist_finish_bank3_i             (bank_bist_finish[3]           ),

          .bank_success_bank0_i            (bank_bist_success[0]          ),
          .bank_success_bank1_i            (bank_bist_success[1]          ),
          //.bank_success_bank2_i            (bank_bist_success[2]          ),
          //.bank_success_bank3_i            (bank_bist_success[3]          ),

          .mc_bist_path_fail_bank0_i       (bank_bist_bank_fail[0]        ),
          .mc_bist_path_fail_bank1_i       (bank_bist_bank_fail[1]        ),
          //.mc_bist_path_fail_bank2_i       (bank_bist_bank_fail[2]        ),
          //.mc_bist_path_fail_bank3_i       (bank_bist_bank_fail[3]        ),

          .bist_rescan_finish_bank0_i      (bank_rescan_finish_status[0]),
          .bist_rescan_finish_bank1_i      (bank_rescan_finish_status[1]),
          //.bist_rescan_finish_bank2_i      (bank_rescan_finish_status[2]),
          //.bist_rescan_finish_bank3_i      (bank_rescan_finish_status[3]),

          .bist_rescan_success_bank0_i     (bank_rescan_success_status[0]),
          .bist_rescan_success_bank1_i     (bank_rescan_success_status[1]),
          //.bist_rescan_success_bank2_i     (bank_rescan_success_status[2]),
          //.bist_rescan_success_bank3_i     (bank_rescan_success_status[3]),

          .mc_bist_rescan_fail_num_bank0_i (bank_rescan_fail_num[19:0]  ),
          .mc_bist_rescan_fail_num_bank1_i (bank_rescan_fail_num[39:20] ),
          //.mc_bist_rescan_fail_num_bank2_i (bank_rescan_fail_num[59:40] ),
          //.mc_bist_rescan_fail_num_bank3_i (bank_rescan_fail_num[79:60] ),


          .rescan_round_result_bank0_i     (bank_rescan_round_result[RESCAN_ROUND_NUM-1:0]                   ),
          .rescan_round_result_bank1_i     (bank_rescan_round_result[RESCAN_ROUND_NUM*2-1:RESCAN_ROUND_NUM]  ),
          //.rescan_round_result_bank2_i     (bank_rescan_round_result[RESCAN_ROUND_NUM*3-1:RESCAN_ROUND_NUM*2]),
          //.rescan_round_result_bank3_i     (bank_rescan_round_result[RESCAN_ROUND_NUM*4-1:RESCAN_ROUND_NUM*3]),



          .bist_pattern_reg0_o             (bist_pattern_reg0          ),
          .bist_pattern_reg1_o             (bist_pattern_reg1          ),
          .bist_pattern_reg2_o             (bist_pattern_reg2          ),
          .bist_pattern_reg3_o             (bist_pattern_reg3          ),
          .csl_bist_pattern_sel0_o         (csl_bist_pattern_sel0      ),
          .csl_bist_pattern_sel1_o         (csl_bist_pattern_sel1      ),
          .csl_bist_pattern_sel2_o         (csl_bist_pattern_sel2      ),

          .wl_bist_pattern_sel0_o          (wl_bist_pattern_sel0       ),
          .wl_bist_pattern_sel1_o          (wl_bist_pattern_sel1       ),
          .wl_bist_pattern_sel2_o          (wl_bist_pattern_sel2       ),

          .mc_csl_scan_mode_sel_o          (csl_scan_mode_sel          ),

          .bist_finish_mask_o              (bist_finish_mask           ),
          .rescan_finish_mask_o            (rescan_finish_mask         ),
          .rescan_finish_clr_o             (rescan_finish_clr          ),
          //.rescan_round_result_i           (rescan_round_result        ),
          .mc_bist_grant_o                 (mc_bist_grant              ),
          .mc_bank_map_id_o                (bank_map_id                ),
          .hang_timeout_th_o               (hang_timeout_th            ),
          //dbg data store begin
          .dbg_frame_store_0_i             (dbg_store_latest_frame[0*32+:32] ),
          .dbg_frame_store_1_i             (dbg_store_latest_frame[1*32+:32] ),
          .dbg_frame_store_2_i             (dbg_store_latest_frame[2*32+:32] ),
          .dbg_frame_store_3_i             (dbg_store_latest_frame[3*32+:32] ),
          .dbg_frame_store_4_i             (dbg_store_latest_frame[4*32+:32] ),
          .dbg_frame_store_5_i             (dbg_store_latest_frame[5*32+:32] ),
          .dbg_frame_store_6_i             (dbg_store_latest_frame[6*32+:32] ),
          .dbg_frame_store_7_i             (dbg_store_latest_frame[7*32+:32] ),
          .dbg_frame_store_8_i             (dbg_store_latest_frame[8*32+:32] ),
          .dbg_frame_store_9_i             (dbg_store_latest_frame[9*32+:10] ),
          .dbg_rdata_store_0_i             (dbg_store_latest_rdata[0*32+:32] ),
          .dbg_rdata_store_1_i             (dbg_store_latest_rdata[1*32+:32] ),
          .dbg_rdata_store_2_i             (dbg_store_latest_rdata[2*32+:32] ),
          .dbg_rdata_store_3_i             (dbg_store_latest_rdata[3*32+:32] ),
          .dbg_rdata_store_4_i             (dbg_store_latest_rdata[4*32+:32] ),
          .dbg_rdata_store_5_i             (dbg_store_latest_rdata[5*32+:32] ),
          .dbg_rdata_store_6_i             (dbg_store_latest_rdata[6*32+:32] ),
          .dbg_rdata_store_7_i             (dbg_store_latest_rdata[7*32+:32] ),
          .dbg_rdata_store_8_i             (dbg_store_latest_rdata[8*32+:16] ),

          .mc_page_status_i                (mc_page_status                   ),// read only signal
          .hang_timeout_status_i           (hang_timeout_status              ),
          .hang_timeout_mask_o             (hang_timeout_mask                ),
          .hang_timeout_clr_o              (hang_timeout_clr                 ),
          .hang_timeout_en_o               (hang_timeout_en                  ),
          .bist_clk_cnt_i                  (bist_clk_cnt_test                ),
          
          //ecc
          .mc_ecc_ce_overflow_int_i        (mc_ecc_ce_overflow_int     ),
          .mc_ecc_ce_cnt_i                 (mc_ecc_ce_cnt              ),
          .mc_ecc_ce_addr0_i               (mc_ecc_ce_addr[0*22+:22]   ),
          .mc_ecc_ce_addr_vld0_i           (mc_ecc_ce_addr_vld[0]      ),
          .mc_ecc_ce_addr_cnt0_i           (mc_ecc_ce_addr_cnt[0*8+:8] ),
          .mc_ecc_ce_addr1_i               (mc_ecc_ce_addr[1*22+:22]   ),
          .mc_ecc_ce_addr_vld1_i           (mc_ecc_ce_addr_vld[1]      ),
          .mc_ecc_ce_addr_cnt1_i           (mc_ecc_ce_addr_cnt[1*8+:8] ),
          .mc_ecc_ce_addr2_i               (mc_ecc_ce_addr[2*22+:22]   ),
          .mc_ecc_ce_addr_vld2_i           (mc_ecc_ce_addr_vld[2]      ),
          .mc_ecc_ce_addr_cnt2_i           (mc_ecc_ce_addr_cnt[2*8+:8] ),
          .mc_ecc_ce_addr3_i               (mc_ecc_ce_addr[3*22+:22]   ),
          .mc_ecc_ce_addr_vld3_i           (mc_ecc_ce_addr_vld[3]      ),
          .mc_ecc_ce_addr_cnt3_i           (mc_ecc_ce_addr_cnt[3*8+:8] ),
          .mc_ecc_ce_addr4_i               (mc_ecc_ce_addr[4*22+:22]   ),
          .mc_ecc_ce_addr_vld4_i           (mc_ecc_ce_addr_vld[4]      ),
          .mc_ecc_ce_addr_cnt4_i           (mc_ecc_ce_addr_cnt[4*8+:8] ),
          .mc_ecc_ce_addr5_i               (mc_ecc_ce_addr[5*22+:22]   ),
          .mc_ecc_ce_addr_vld5_i           (mc_ecc_ce_addr_vld[5]      ),
          .mc_ecc_ce_addr_cnt5_i           (mc_ecc_ce_addr_cnt[5*8+:8] ),
          .mc_ecc_ce_addr6_i               (mc_ecc_ce_addr[6*22+:22]   ),
          .mc_ecc_ce_addr_vld6_i           (mc_ecc_ce_addr_vld[6]      ),
          .mc_ecc_ce_addr_cnt6_i           (mc_ecc_ce_addr_cnt[6*8+:8] ),
          .mc_ecc_ce_addr7_i               (mc_ecc_ce_addr[7*22+:22]   ),
          .mc_ecc_ce_addr_vld7_i           (mc_ecc_ce_addr_vld[7]      ),
          .mc_ecc_ce_addr_cnt7_i           (mc_ecc_ce_addr_cnt[7*8+:8] ),
          .mc_ecc_ce_addr8_i               (mc_ecc_ce_addr[8*22+:22]   ),
          .mc_ecc_ce_addr_vld8_i           (mc_ecc_ce_addr_vld[8]      ),
          .mc_ecc_ce_addr_cnt8_i           (mc_ecc_ce_addr_cnt[8*8+:8] ),
          .mc_ecc_ce_addr9_i               (mc_ecc_ce_addr[9*22+:22]   ),
          .mc_ecc_ce_addr_vld9_i           (mc_ecc_ce_addr_vld[9]      ),
          .mc_ecc_ce_addr_cnt9_i           (mc_ecc_ce_addr_cnt[9*8+:8] ),
          .mc_ecc_ce_addr10_i              (mc_ecc_ce_addr[10*22+:22]  ),
          .mc_ecc_ce_addr_vld10_i          (mc_ecc_ce_addr_vld[10]     ),
          .mc_ecc_ce_addr_cnt10_i          (mc_ecc_ce_addr_cnt[10*8+:8]),
          .mc_ecc_ce_addr11_i              (mc_ecc_ce_addr[11*22+:22]  ),
          .mc_ecc_ce_addr_vld11_i          (mc_ecc_ce_addr_vld[11]     ),
          .mc_ecc_ce_addr_cnt11_i          (mc_ecc_ce_addr_cnt[11*8+:8]),
          .mc_ecc_ce_addr12_i              (mc_ecc_ce_addr[12*22+:22]  ),
          .mc_ecc_ce_addr_vld12_i          (mc_ecc_ce_addr_vld[12]     ),
          .mc_ecc_ce_addr_cnt12_i          (mc_ecc_ce_addr_cnt[12*8+:8]),
          .mc_ecc_ce_addr13_i              (mc_ecc_ce_addr[13*22+:22]  ),
          .mc_ecc_ce_addr_vld13_i          (mc_ecc_ce_addr_vld[13]     ),
          .mc_ecc_ce_addr_cnt13_i          (mc_ecc_ce_addr_cnt[13*8+:8]),
          .mc_ecc_ce_addr14_i              (mc_ecc_ce_addr[14*22+:22]  ),
          .mc_ecc_ce_addr_vld14_i          (mc_ecc_ce_addr_vld[14]     ),
          .mc_ecc_ce_addr_cnt14_i          (mc_ecc_ce_addr_cnt[14*8+:8]),
          .mc_ecc_ce_addr15_i              (mc_ecc_ce_addr[15*22+:22]  ),
          .mc_ecc_ce_addr_vld15_i          (mc_ecc_ce_addr_vld[15]     ),
          .mc_ecc_ce_addr_cnt15_i          (mc_ecc_ce_addr_cnt[15*8+:8]),
          .mc_ecc_uce_int_i                (mc_ecc_uce_int             ),
          .mc_ecc_uce_cnt_i                (mc_ecc_uce_cnt             ),
          .mc_ecc_uce_addr0_i              (mc_ecc_uce_addr[0*22+:22]  ),
          .mc_ecc_uce_addr_vld0_i          (mc_ecc_uce_addr_vld[0]     ),
          .mc_ecc_uce_addr1_i              (mc_ecc_uce_addr[1*22+:22]  ),
          .mc_ecc_uce_addr_vld1_i          (mc_ecc_uce_addr_vld[1]     ),
          .mc_ecc_uce_addr2_i              (mc_ecc_uce_addr[2*22+:22]  ),
          .mc_ecc_uce_addr_vld2_i          (mc_ecc_uce_addr_vld[2]     ),
          .mc_ecc_uce_addr3_i              (mc_ecc_uce_addr[3*22+:22]  ),
          .mc_ecc_uce_addr_vld3_i          (mc_ecc_uce_addr_vld[3]     ),
          .mc_ecc_ce_th_o                  (mc_ecc_ce_th               ),
          .mc_ecc_ce_int_clr_o             (mc_ecc_ce_int_clr_inner     ),
          .mc_ecc_uce_int_clr_o            (mc_ecc_uce_int_clr_inner    ),
          .mc_ecc_en_o                     (mc_ecc_en_tmp               ),
          .mc_ecc_ce_int_mask_o            (mc_ecc_ce_int_mask_o        ),
          .mc_ecc_ce_int_en_o              (mc_ecc_ce_int_en_o         ),
          .mc_ecc_uce_int_mask_o           (mc_ecc_uce_int_mask_o       ),


          //dbg data store end
          .prdata                          (apb_rdata                   ),
          .pslverr                         (apb_pslverr                 )
    );  

end
else begin:inst3
apb2reg_mc_1short1_top_aux_cfg_if #(
    .APB_ADDR_WIDTH (APB_ADDR_WIDTH),
    .APB_DATA_WIDTH (APB_DATA_WIDTH)
)apb2reg_mc_top_cfg_if_u3(
// common input ports 
          .pclk                            (apb_clk           ),
          .presetn                         (apb_rst_n         ),
          .psel                            (apb_sel           ),
          .penable                         (apb_enable        ),
          .paddr                           (apb_addr          ),
          .pwrite                          (apb_write         ),
          .pwdata                          (apb_wdata         ),
          .pready                          (apb_pready         ),
          .mc_id_i                         (mc_id             ),// read only signal
          .dbg_next_state_array_i          (dbg_next_state    ),// read only signal
          .dbg_current_state_array_i       (dbg_current_state ),// read only signal
          .dbg_r_data_cnt_i                (dbg_r_data_cnt    ),// read only signal
          .dbg_refresh_flag_i              (dbg_refresh_flag  ),// read only signal
          .dbg_r_frame_cnt_i               (dbg_r_frame_cnt   ),// read only signal
          .dbg_w_frame_cnt_i               (dbg_w_frame_cnt   ),// read only signal
          .mc_timeout_flag_i               (mc_timeout_flag   ),// read only signal
          //.bist_finish_i                   (bist_finish_status),// read only signal
          //.bist_rescan_success_i           (bist_rescan_success),
          //.bist_success_status_i           (bist_success_status),// read only signal
          .err_csl0_part0_bank0_i          (bank_err_csl0_part0[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part0_bank0_i          (bank_err_csl1_part0[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part1_bank0_i          (bank_err_csl0_part1[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part1_bank0_i          (bank_err_csl1_part1[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part2_bank0_i          (bank_err_csl0_part2[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part2_bank0_i          (bank_err_csl1_part2[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part3_bank0_i          (bank_err_csl0_part3[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part3_bank0_i          (bank_err_csl1_part3[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part4_bank0_i          (bank_err_csl0_part4[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part4_bank0_i          (bank_err_csl1_part4[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part5_bank0_i          (bank_err_csl0_part5[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part5_bank0_i          (bank_err_csl1_part5[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part6_bank0_i          (bank_err_csl0_part6[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part6_bank0_i          (bank_err_csl1_part6[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part7_bank0_i          (bank_err_csl0_part7[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part7_bank0_i          (bank_err_csl1_part7[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part8_bank0_i          (bank_err_csl0_part8[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part8_bank0_i          (bank_err_csl1_part8[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl0_part9_bank0_i          (bank_err_csl0_part9[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_csl1_part9_bank0_i          (bank_err_csl1_part9[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]    ),// read only signal
          .err_wl0_bank0_i                 (bank_err_wl0[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl1_bank0_i                 (bank_err_wl1[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl2_bank0_i                 (bank_err_wl2[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl3_bank0_i                 (bank_err_wl3[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl4_bank0_i                 (bank_err_wl4[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl5_bank0_i                 (bank_err_wl5[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl6_bank0_i                 (bank_err_wl6[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl7_bank0_i                 (bank_err_wl7[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl8_bank0_i                 (bank_err_wl8[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl9_bank0_i                 (bank_err_wl9[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]   ),// read only signal
          .err_wl10_bank0_i                (bank_err_wl10[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl11_bank0_i                (bank_err_wl11[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl12_bank0_i                (bank_err_wl12[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl13_bank0_i                (bank_err_wl13[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl14_bank0_i                (bank_err_wl14[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl15_bank0_i                (bank_err_wl15[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl16_bank0_i                (bank_err_wl16[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl17_bank0_i                (bank_err_wl17[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl18_bank0_i                (bank_err_wl18[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl19_bank0_i                (bank_err_wl19[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl20_bank0_i                (bank_err_wl20[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl21_bank0_i                (bank_err_wl21[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl22_bank0_i                (bank_err_wl22[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl23_bank0_i                (bank_err_wl23[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl24_bank0_i                (bank_err_wl24[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl25_bank0_i                (bank_err_wl25[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl26_bank0_i                (bank_err_wl26[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl27_bank0_i                (bank_err_wl27[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl28_bank0_i                (bank_err_wl28[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl29_bank0_i                (bank_err_wl29[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl30_bank0_i                (bank_err_wl30[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl31_bank0_i                (bank_err_wl31[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl32_bank0_i                (bank_err_wl32[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl33_bank0_i                (bank_err_wl33[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl34_bank0_i                (bank_err_wl34[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl35_bank0_i                (bank_err_wl35[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl36_bank0_i                (bank_err_wl36[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl37_bank0_i                (bank_err_wl37[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl38_bank0_i                (bank_err_wl38[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl39_bank0_i                (bank_err_wl39[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl40_bank0_i                (bank_err_wl40[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl41_bank0_i                (bank_err_wl41[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl42_bank0_i                (bank_err_wl42[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl43_bank0_i                (bank_err_wl43[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl44_bank0_i                (bank_err_wl44[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl45_bank0_i                (bank_err_wl45[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl46_bank0_i                (bank_err_wl46[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl47_bank0_i                (bank_err_wl47[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl48_bank0_i                (bank_err_wl48[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl49_bank0_i                (bank_err_wl49[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl50_bank0_i                (bank_err_wl50[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl51_bank0_i                (bank_err_wl51[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl52_bank0_i                (bank_err_wl52[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl53_bank0_i                (bank_err_wl53[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl54_bank0_i                (bank_err_wl54[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl55_bank0_i                (bank_err_wl55[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl56_bank0_i                (bank_err_wl56[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl57_bank0_i                (bank_err_wl57[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl58_bank0_i                (bank_err_wl58[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl59_bank0_i                (bank_err_wl59[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl60_bank0_i                (bank_err_wl60[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl61_bank0_i                (bank_err_wl61[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl62_bank0_i                (bank_err_wl62[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          .err_wl63_bank0_i                (bank_err_wl63[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]  ),// read only signal
          
          .mc_timeout_clr_o                (mc_timeout_clr    ),
          .bist_finish_clr_o               (bist_finish_clr   ),
          
          .mc_en_o                         (mc_en             ),
          .mc_rf_cfg_sel_o                 (mc_rf_cfg_sel     ),
          .mc_debug_en_o                   (mc_debug_en       ),
          .mc_wl_vmc_en_o                  (mc_wl_vmc_en      ),
          .mc_bl_vmc_en_o                  (mc_bl_vmc_en      ),
          .mc_bist_en_o                    (mc_bist_en        ),
          .mc_rdrdy_n_en_o                 (mc_rdrdy_n_en     ),
          .mc_all_bank_act_en_o            (mc_all_bank_act_en),
          .mc2phy_dram0_mask_o             (mc2phy_dram0_mask),
          .mc2phy_dram1_mask_o             (mc2phy_dram1_mask),
          .mc2phy_dram2_mask_o             (mc2phy_dram2_mask),
          .mc2phy_dram3_mask_o             (mc2phy_dram3_mask),
          .mc_rescan_addr_range_sel_o      (mc_rescan_addr_range_sel  ),
          .mc_csl_scan_addr_range_sel_o    (mc_csl_scan_addr_range_sel),
          .mc_csl_scan_check_sel_o         (mc_csl_scan_check_sel     ),
          .mc_rdata_invert_sel_o           (mc_rdata_invert_sel       ),
          .mc_rf_burst_split_en_o          (mc_rf_burst_split_en      ),
          .mc_rf_en_o                      (mc_rf_en                  ),
          .mc_fake_bresp_en_o              (mc_fake_bresp_en          ),

          .bank_radd_set_time_o            (bank_radd_set_time),
          .cadd_set_time_o                 (cadd_set_time     ),
          .r_cas_set_time_o                (r_cas_set_time    ),
          .w_cas_set_time_o                (w_cas_set_time    ),
          .mc_rf_period_1_o                (mc_rf_period_1    ),
          .mc_rf_start_1_o                 (mc_rf_start_1     ),
          .mc_rf_period_2_o                (mc_rf_period_2    ),
          .mc_rf_start_2_o                 (mc_rf_start_2     ),
          .mc_vmc_wl_num0_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num1_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num2_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num3_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num4_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*4 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num5_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*5 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num6_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*6 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num7_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*7 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num8_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*8 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num9_bank0_o          (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*9 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num10_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*10 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num11_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*11 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num12_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*12 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num13_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*13 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num14_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*14 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num15_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*15 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num16_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*16 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num17_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*17 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num18_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*18 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num19_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*19 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num20_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*20 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num21_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*21 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num22_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*22 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num23_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*23 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num24_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*24 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num25_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*25 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num26_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*26 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num27_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*27 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num28_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*28 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num29_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*29 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num30_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*30 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num31_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*31 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num32_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*32 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num33_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*33 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num34_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*34 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num35_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*35 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num36_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*36 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num37_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*37 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num38_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*38 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num39_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*39 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num40_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*40 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num41_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*41 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num42_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*42 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num43_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*43 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num44_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*44 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num45_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*45 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num46_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*46 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num47_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*47 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num48_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*48 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num49_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*49 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num50_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*50 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num51_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*51 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num52_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*52 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num53_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*53 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num54_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*54 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num55_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*55 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num56_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*56 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num57_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*57 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num58_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*58 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num59_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*59 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num60_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*60 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num61_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*61 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num62_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*62 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num63_bank0_o         (bank0_remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*63 +: ARRAY_ROW_ADDR_WIDTH]),
          
          .mc_vmc_bl_num0_part0_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part0_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part1_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part1_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part2_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*4 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part2_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*5 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part3_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*6 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part3_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*7 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part4_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*8 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part4_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*9 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part5_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*10 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part5_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*11 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part6_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*12 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part6_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*13 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part7_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*14 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part7_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*15 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part8_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*16 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part8_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*17 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part9_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*18 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part9_bank0_o    (bank0_remap_csl_addr[ARRAY_COL_ADDR_WIDTH*19 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_rf_start_dbg_i               (mc_rf_start                ),
          .mc_bist_status_i                (bist_scan_status           ),
          //.mc_bist_path_fail_i             (bist_bank_fail           ),
          .dram_init_finish_i              (dram_init_finish           ),
          //.mc_bist_rescan_fail_num_i       (bist_rescan_fail_num       ),

          .mc_bist_err_wl_num_bank0_i      (bank_err_wl_cnt[7*0 +:7]        ),
          .err_wl_num_change_flag_bank0_i  (bank_err_wl_cnt_change_flag[0]  ),
          //.mc_bist_err_wl_num_bank1_i      (bank_err_wl_cnt[7*1 +:7]        ),
          //.err_wl_num_change_flag_bank1_i  (bank_err_wl_cnt_change_flag[1]  ),
          //.mc_bist_err_wl_num_bank2_i      (bank_err_wl_cnt[7*2 +:7]        ),
          //.err_wl_num_change_flag_bank2_i  (bank_err_wl_cnt_change_flag[2]  ),
          //.mc_bist_err_wl_num_bank3_i      (bank_err_wl_cnt[7*3 +:7]        ),
          //.err_wl_num_change_flag_bank3_i  (bank_err_wl_cnt_change_flag[3]  ),

          .bist_finish_bank0_i             (bank_bist_finish[0]           ),
          //.bist_finish_bank1_i             (bank_bist_finish[1]           ),
          //.bist_finish_bank2_i             (bank_bist_finish[2]           ),
          //.bist_finish_bank3_i             (bank_bist_finish[3]           ),

          .bank_success_bank0_i            (bank_bist_success[0]          ),
          //.bank_success_bank1_i            (bank_bist_success[1]          ),
          //.bank_success_bank2_i            (bank_bist_success[2]          ),
          //.bank_success_bank3_i            (bank_bist_success[3]          ),

          .mc_bist_path_fail_bank0_i       (bank_bist_bank_fail[0]        ),
          //.mc_bist_path_fail_bank1_i       (bank_bist_bank_fail[1]        ),
          //.mc_bist_path_fail_bank2_i       (bank_bist_bank_fail[2]        ),
          //.mc_bist_path_fail_bank3_i       (bank_bist_bank_fail[3]        ),

          .bist_rescan_finish_bank0_i      (bank_rescan_finish_status[0]),
          //.bist_rescan_finish_bank1_i      (bank_rescan_finish_status[1]),
          //.bist_rescan_finish_bank2_i      (bank_rescan_finish_status[2]),
          //.bist_rescan_finish_bank3_i      (bank_rescan_finish_status[3]),

          .bist_rescan_success_bank0_i     (bank_rescan_success_status[0]),
          //.bist_rescan_success_bank1_i     (bank_rescan_success_status[1]),
          //.bist_rescan_success_bank2_i     (bank_rescan_success_status[2]),
          //.bist_rescan_success_bank3_i     (bank_rescan_success_status[3]),

          .mc_bist_rescan_fail_num_bank0_i (bank_rescan_fail_num[19:0]  ),
          //.mc_bist_rescan_fail_num_bank1_i (bank_rescan_fail_num[39:20] ),
          //.mc_bist_rescan_fail_num_bank2_i (bank_rescan_fail_num[59:40] ),
          //.mc_bist_rescan_fail_num_bank3_i (bank_rescan_fail_num[79:60] ),


          .rescan_round_result_bank0_i     (bank_rescan_round_result[RESCAN_ROUND_NUM-1:0]                   ),
          //.rescan_round_result_bank1_i     (bank_rescan_round_result[RESCAN_ROUND_NUM*2-1:RESCAN_ROUND_NUM]  ),
          //.rescan_round_result_bank2_i     (bank_rescan_round_result[RESCAN_ROUND_NUM*3-1:RESCAN_ROUND_NUM*2]),
          //.rescan_round_result_bank3_i     (bank_rescan_round_result[RESCAN_ROUND_NUM*4-1:RESCAN_ROUND_NUM*3]),


          .bist_pattern_reg0_o             (bist_pattern_reg0          ),
          .bist_pattern_reg1_o             (bist_pattern_reg1          ),
          .bist_pattern_reg2_o             (bist_pattern_reg2          ),
          .bist_pattern_reg3_o             (bist_pattern_reg3          ),
          .csl_bist_pattern_sel0_o         (csl_bist_pattern_sel0      ),
          .csl_bist_pattern_sel1_o         (csl_bist_pattern_sel1      ),
          .csl_bist_pattern_sel2_o         (csl_bist_pattern_sel2      ),

          .wl_bist_pattern_sel0_o          (wl_bist_pattern_sel0       ),
          .wl_bist_pattern_sel1_o          (wl_bist_pattern_sel1       ),
          .wl_bist_pattern_sel2_o          (wl_bist_pattern_sel2       ),

          .mc_csl_scan_mode_sel_o          (csl_scan_mode_sel          ),

          .bist_finish_mask_o              (bist_finish_mask           ),
          .rescan_finish_mask_o            (rescan_finish_mask         ),
          .rescan_finish_clr_o             (rescan_finish_clr          ),
          //.rescan_round_result_i           (rescan_round_result        ),
          .mc_bist_grant_o                 (mc_bist_grant              ),
          .mc_bank_map_id_o                (bank_map_id                ),
          .hang_timeout_th_o               (hang_timeout_th            ),
          //dbg data store begin
          .dbg_frame_store_0_i             (dbg_store_latest_frame[0*32+:32] ),
          .dbg_frame_store_1_i             (dbg_store_latest_frame[1*32+:32] ),
          .dbg_frame_store_2_i             (dbg_store_latest_frame[2*32+:32] ),
          .dbg_frame_store_3_i             (dbg_store_latest_frame[3*32+:32] ),
          .dbg_frame_store_4_i             (dbg_store_latest_frame[4*32+:32] ),
          .dbg_frame_store_5_i             (dbg_store_latest_frame[5*32+:32] ),
          .dbg_frame_store_6_i             (dbg_store_latest_frame[6*32+:32] ),
          .dbg_frame_store_7_i             (dbg_store_latest_frame[7*32+:32] ),
          .dbg_frame_store_8_i             (dbg_store_latest_frame[8*32+:32] ),
          .dbg_frame_store_9_i             (dbg_store_latest_frame[9*32+:10] ),
          .dbg_rdata_store_0_i             (dbg_store_latest_rdata[0*32+:32] ),
          .dbg_rdata_store_1_i             (dbg_store_latest_rdata[1*32+:32] ),
          .dbg_rdata_store_2_i             (dbg_store_latest_rdata[2*32+:32] ),
          .dbg_rdata_store_3_i             (dbg_store_latest_rdata[3*32+:32] ),
          .dbg_rdata_store_4_i             (dbg_store_latest_rdata[4*32+:32] ),
          .dbg_rdata_store_5_i             (dbg_store_latest_rdata[5*32+:32] ),
          .dbg_rdata_store_6_i             (dbg_store_latest_rdata[6*32+:32] ),
          .dbg_rdata_store_7_i             (dbg_store_latest_rdata[7*32+:32] ),
          .dbg_rdata_store_8_i             (dbg_store_latest_rdata[8*32+:16] ),

          .mc_page_status_i                (mc_page_status                   ),// read only signal
          .hang_timeout_status_i           (hang_timeout_status              ),
          .hang_timeout_mask_o             (hang_timeout_mask                ),
          .hang_timeout_clr_o              (hang_timeout_clr                 ),
          .hang_timeout_en_o               (hang_timeout_en                  ),
          .bist_clk_cnt_i                  (bist_clk_cnt_test                ),
          
          //ecc
          .mc_ecc_ce_overflow_int_i        (mc_ecc_ce_overflow_int     ),
          .mc_ecc_ce_cnt_i                 (mc_ecc_ce_cnt              ),
          .mc_ecc_ce_addr0_i               (mc_ecc_ce_addr[0*22+:22]   ),
          .mc_ecc_ce_addr_vld0_i           (mc_ecc_ce_addr_vld[0]      ),
          .mc_ecc_ce_addr_cnt0_i           (mc_ecc_ce_addr_cnt[0*8+:8] ),
          .mc_ecc_ce_addr1_i               (mc_ecc_ce_addr[1*22+:22]   ),
          .mc_ecc_ce_addr_vld1_i           (mc_ecc_ce_addr_vld[1]      ),
          .mc_ecc_ce_addr_cnt1_i           (mc_ecc_ce_addr_cnt[1*8+:8] ),
          .mc_ecc_ce_addr2_i               (mc_ecc_ce_addr[2*22+:22]   ),
          .mc_ecc_ce_addr_vld2_i           (mc_ecc_ce_addr_vld[2]      ),
          .mc_ecc_ce_addr_cnt2_i           (mc_ecc_ce_addr_cnt[2*8+:8] ),
          .mc_ecc_ce_addr3_i               (mc_ecc_ce_addr[3*22+:22]   ),
          .mc_ecc_ce_addr_vld3_i           (mc_ecc_ce_addr_vld[3]      ),
          .mc_ecc_ce_addr_cnt3_i           (mc_ecc_ce_addr_cnt[3*8+:8] ),
          .mc_ecc_ce_addr4_i               (mc_ecc_ce_addr[4*22+:22]   ),
          .mc_ecc_ce_addr_vld4_i           (mc_ecc_ce_addr_vld[4]      ),
          .mc_ecc_ce_addr_cnt4_i           (mc_ecc_ce_addr_cnt[4*8+:8] ),
          .mc_ecc_ce_addr5_i               (mc_ecc_ce_addr[5*22+:22]   ),
          .mc_ecc_ce_addr_vld5_i           (mc_ecc_ce_addr_vld[5]      ),
          .mc_ecc_ce_addr_cnt5_i           (mc_ecc_ce_addr_cnt[5*8+:8] ),
          .mc_ecc_ce_addr6_i               (mc_ecc_ce_addr[6*22+:22]   ),
          .mc_ecc_ce_addr_vld6_i           (mc_ecc_ce_addr_vld[6]      ),
          .mc_ecc_ce_addr_cnt6_i           (mc_ecc_ce_addr_cnt[6*8+:8] ),
          .mc_ecc_ce_addr7_i               (mc_ecc_ce_addr[7*22+:22]   ),
          .mc_ecc_ce_addr_vld7_i           (mc_ecc_ce_addr_vld[7]      ),
          .mc_ecc_ce_addr_cnt7_i           (mc_ecc_ce_addr_cnt[7*8+:8] ),
          .mc_ecc_ce_addr8_i               (mc_ecc_ce_addr[8*22+:22]   ),
          .mc_ecc_ce_addr_vld8_i           (mc_ecc_ce_addr_vld[8]      ),
          .mc_ecc_ce_addr_cnt8_i           (mc_ecc_ce_addr_cnt[8*8+:8] ),
          .mc_ecc_ce_addr9_i               (mc_ecc_ce_addr[9*22+:22]   ),
          .mc_ecc_ce_addr_vld9_i           (mc_ecc_ce_addr_vld[9]      ),
          .mc_ecc_ce_addr_cnt9_i           (mc_ecc_ce_addr_cnt[9*8+:8] ),
          .mc_ecc_ce_addr10_i              (mc_ecc_ce_addr[10*22+:22]  ),
          .mc_ecc_ce_addr_vld10_i          (mc_ecc_ce_addr_vld[10]     ),
          .mc_ecc_ce_addr_cnt10_i          (mc_ecc_ce_addr_cnt[10*8+:8]),
          .mc_ecc_ce_addr11_i              (mc_ecc_ce_addr[11*22+:22]  ),
          .mc_ecc_ce_addr_vld11_i          (mc_ecc_ce_addr_vld[11]     ),
          .mc_ecc_ce_addr_cnt11_i          (mc_ecc_ce_addr_cnt[11*8+:8]),
          .mc_ecc_ce_addr12_i              (mc_ecc_ce_addr[12*22+:22]  ),
          .mc_ecc_ce_addr_vld12_i          (mc_ecc_ce_addr_vld[12]     ),
          .mc_ecc_ce_addr_cnt12_i          (mc_ecc_ce_addr_cnt[12*8+:8]),
          .mc_ecc_ce_addr13_i              (mc_ecc_ce_addr[13*22+:22]  ),
          .mc_ecc_ce_addr_vld13_i          (mc_ecc_ce_addr_vld[13]     ),
          .mc_ecc_ce_addr_cnt13_i          (mc_ecc_ce_addr_cnt[13*8+:8]),
          .mc_ecc_ce_addr14_i              (mc_ecc_ce_addr[14*22+:22]  ),
          .mc_ecc_ce_addr_vld14_i          (mc_ecc_ce_addr_vld[14]     ),
          .mc_ecc_ce_addr_cnt14_i          (mc_ecc_ce_addr_cnt[14*8+:8]),
          .mc_ecc_ce_addr15_i              (mc_ecc_ce_addr[15*22+:22]  ),
          .mc_ecc_ce_addr_vld15_i          (mc_ecc_ce_addr_vld[15]     ),
          .mc_ecc_ce_addr_cnt15_i          (mc_ecc_ce_addr_cnt[15*8+:8]),
          .mc_ecc_uce_int_i                (mc_ecc_uce_int             ),
          .mc_ecc_uce_cnt_i                (mc_ecc_uce_cnt             ),
          .mc_ecc_uce_addr0_i              (mc_ecc_uce_addr[0*22+:22]  ),
          .mc_ecc_uce_addr_vld0_i          (mc_ecc_uce_addr_vld[0]     ),
          .mc_ecc_uce_addr1_i              (mc_ecc_uce_addr[1*22+:22]  ),
          .mc_ecc_uce_addr_vld1_i          (mc_ecc_uce_addr_vld[1]     ),
          .mc_ecc_uce_addr2_i              (mc_ecc_uce_addr[2*22+:22]  ),
          .mc_ecc_uce_addr_vld2_i          (mc_ecc_uce_addr_vld[2]     ),
          .mc_ecc_uce_addr3_i              (mc_ecc_uce_addr[3*22+:22]  ),
          .mc_ecc_uce_addr_vld3_i          (mc_ecc_uce_addr_vld[3]     ),
          .mc_ecc_ce_th_o                  (mc_ecc_ce_th               ),
          .mc_ecc_ce_int_clr_o             (mc_ecc_ce_int_clr_inner     ),
          .mc_ecc_uce_int_clr_o            (mc_ecc_uce_int_clr_inner    ),
          .mc_ecc_en_o                     (mc_ecc_en_tmp               ),
          .mc_ecc_ce_int_mask_o            (mc_ecc_ce_int_mask_o        ),
          .mc_ecc_ce_int_en_o              (mc_ecc_ce_int_en_o          ),
          .mc_ecc_uce_int_mask_o           (mc_ecc_uce_int_mask_o       ),

          .prdata                          (apb_rdata                   ),
          .pslverr                         (apb_pslverr                 )
    );


end
endgenerate
/*
apb2reg_mc_pe_top_aux_cfg_if #(
          .APB_ADDR_WIDTH (APB_ADDR_WIDTH),
          .APB_DATA_WIDTH (APB_DATA_WIDTH)
)apb2reg_mc_pe_top_cfg_if_u(
          // common input ports 
          .pclk                      (apb_clk           ),
          .presetn                   (apb_rst_n         ),
          .psel                      (pe_apb_sel        ),
          .penable                   (pe_apb_enable     ),
          .paddr                     (pe_apb_addr       ),
          .pwrite                    (pe_apb_write      ),
          .pwdata                    (pe_apb_wdata      ),
          .pready                    (pe_apb_ready      ),

          
          .mc_id_i                   (mc_id_pe          ),// read only signal
          .mc_page_status_i          (mc_page_status    ),// read only signal
          
          .hang_timeout_status_i     (hang_timeout_status),
          .hang_timeout_mask_o       (hang_timeout_mask ),
          .hang_timeout_clr_o        (hang_timeout_clr  ),
          .hang_timeout_en_o         (hang_timeout_en   ),

          .prdata                    (pe_apb_rdata      ),
          .pslverr                   (pe_apb_pslverr    )

    );

*/
wl_clkgate_aux wl_clkgate_aux_u(
     .clk_i      (clk),
     .dft_se     (1'b0),
     .en         (global_mc_bist_en_tmp),
     .clk_o      (clk_bist)
     
 );

assign  bist_pattern0  = 32'h0000_0000;
assign  bist_pattern1  = 32'hFFFF_FFFF;
assign  bist_pattern2  = 32'h5555_5555;
assign  bist_pattern3  = 32'hAAAA_AAAA;
assign  bist_pattern4  = 32'h00FF_00FF;
assign  bist_pattern5  = 32'hFF00_FF00;
assign  bist_pattern6  = 32'h55AA_55AA;
assign  bist_pattern7  = 32'hAA55_AA55;
assign  bist_pattern8  = 32'h0055_0055;
assign  bist_pattern9  = 32'h00AA_00AA;
assign  bist_pattern10  = 32'h5500_5500;
assign  bist_pattern11  = 32'hAA00_AA00;
assign  bist_pattern12  = 32'h0000_FFFF;
assign  bist_pattern13  = 32'hFFFF_0000;
assign  bist_pattern14  = 32'h00FF_FF00;
assign  bist_pattern15  = 32'hFF00_00FF;
assign  bist_pattern16  = 32'h3333_3333;
assign  bist_pattern17  = 32'hCCCC_CCCC;
assign  bist_pattern18  = 32'h9999_9999;
assign  bist_pattern19  = 32'h6666_6666;
assign  bist_pattern20  = 32'h33CC_33CC;
assign  bist_pattern21  = 32'hCC33_CC33;
assign  bist_pattern22  = 32'h6699_6699;
assign  bist_pattern23  = 32'h9966_9966;
assign  bist_pattern24  = 32'h1212_1212;
assign  bist_pattern25  = 32'h2424_2424;
assign  bist_pattern26  = 32'h4848_4848;
assign  bist_pattern27  = 32'h8181_8181;
assign  bist_pattern28  = 32'hEDED_EDED;
assign  bist_pattern29  = 32'hDBDB_DBDB;
assign  bist_pattern30  = 32'hB7B7_B7B7;
assign  bist_pattern31  = 32'h7E7E_7E7E;
assign  bist_pattern32  = 32'hED12_ED12;
assign  bist_pattern33  = 32'hDB24_DB24;
assign  bist_pattern34  = 32'hB748_B748;
assign  bist_pattern35  = 32'h7E81_7E81;
assign  bist_pattern36  = 32'h12ED_12ED;
assign  bist_pattern37  = 32'h24DB_24DB;
assign  bist_pattern38  = 32'h48B7_48B7;
assign  bist_pattern39  = 32'h817E_817E;
assign  bist_pattern40  = 32'h0012_0012;
assign  bist_pattern41  = 32'h0024_0024;
assign  bist_pattern42  = 32'h0048_0048;
assign  bist_pattern43  = 32'h0081_0081;
assign  bist_pattern44  = 32'h1200_1200;
assign  bist_pattern45  = 32'h2400_2400;
assign  bist_pattern46  = 32'h4800_4800;
assign  bist_pattern47  = 32'h8100_8100;
assign  bist_pattern48  = 32'h0101_0101;
assign  bist_pattern49  = 32'h0202_0202;
assign  bist_pattern50  = 32'h0404_0404;
assign  bist_pattern51  = 32'h0808_0808;
assign  bist_pattern52  = 32'h1010_1010;
assign  bist_pattern53  = 32'h2020_2020;
assign  bist_pattern54  = 32'h4040_4040;
assign  bist_pattern55  = 32'h8080_8080;
assign  bist_pattern56  = 32'hFEFE_FEFE;
assign  bist_pattern57  = 32'hFDFD_FDFD;
assign  bist_pattern58  = 32'hFBFB_FBFB;
assign  bist_pattern59  = 32'hF7F7_F7F7;
assign  bist_pattern60  = 32'hEFEF_EFEF;
assign  bist_pattern61  = 32'hDFDF_DFDF;
assign  bist_pattern62  = 32'hBFBF_BFBF;
assign  bist_pattern63  = 32'h7F7F_7F7F;

assign bist_pattern_all =  {bist_pattern_reg3,bist_pattern_reg2,bist_pattern_reg1,bist_pattern_reg0,
                            bist_pattern63,bist_pattern62,bist_pattern61,bist_pattern60,bist_pattern59,bist_pattern58,bist_pattern57,bist_pattern56,
                            bist_pattern55,bist_pattern54,bist_pattern53,bist_pattern52,bist_pattern51,bist_pattern50,bist_pattern49,bist_pattern48,
                            bist_pattern47,bist_pattern46,bist_pattern45,bist_pattern44,bist_pattern43,bist_pattern42,bist_pattern41,bist_pattern40,
                            bist_pattern39,bist_pattern38,bist_pattern37,bist_pattern36,bist_pattern35,bist_pattern34,bist_pattern33,bist_pattern32,
                            bist_pattern31,bist_pattern30,bist_pattern29,bist_pattern28,bist_pattern27,bist_pattern26,bist_pattern25,bist_pattern24,
                            bist_pattern23,bist_pattern22,bist_pattern21,bist_pattern20,bist_pattern19,bist_pattern18,bist_pattern17,bist_pattern16,
                            bist_pattern15,bist_pattern14,bist_pattern13,bist_pattern12,bist_pattern11,bist_pattern10,bist_pattern9,bist_pattern8,
                            bist_pattern7,bist_pattern6,bist_pattern5,bist_pattern4,bist_pattern3,bist_pattern2,bist_pattern1,bist_pattern0};


assign csl_bist_pattern_sel = {csl_bist_pattern_sel2,csl_bist_pattern_sel1,csl_bist_pattern_sel0} ;
assign wl_bist_pattern_sel  = {wl_bist_pattern_sel2,wl_bist_pattern_sel1,wl_bist_pattern_sel0} ;

//assign mc_short_mode_tmp = MC_SHORT_MODE[1:0];

bist_scan_top_aux #(
                .ARRAY_ADDR_WIDTH    (ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH ),
                .MC_SHORT_MODE       (MC_SHORT_MODE                             ), 
                .CHECKBIT_WIDTH      (CHECKBIT_WIDTH                            ),
                .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH                      ),
                .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH                      ),
                .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH                          )
)bist_scan_top_u(
  //-------------clock and reset signal--------------
          .clk                                 (clk_bist                          ),
          .rst_n                               (rst_n                             ),
          .global_bist_clr                     (global_bist_clr_tmp               ),
          .mc_bist_grant                       (mc_bist_grant                     ),
          //.short_mode                          (mc_short_mode_tmp                 ),
          
          .global_mc_bist_start                (global_mc_bist_start_tmp          ),
          .global_mc_bist_en                   (global_mc_bist_en_tmp             ),
          .mc_bist_en                          (mc_bist_en                        ),
          .bist_csl_vmc_en                     (mc_bist_csl_vmc_en_tmp            ),
          .csl_scan_addr_range_sel             (mc_csl_scan_addr_range_sel_tmp    ),//default 1,scan all addr
          .csl_scan_check_sel                  (mc_csl_scan_check_sel_tmp         ),//default 1,check 272 bit rdata
          .csl_scan_mode_sel                   (csl_scan_mode_sel_tmp             ),//0:abort 1:continue,default 0
 
          .wl_single_pattern_rd_num            (wl_single_pattern_rd_num          ),
          .csl_bist_pattern_sel                (csl_bist_pattern_sel              ),
          .wl_bist_pattern_sel                 (wl_bist_pattern_sel               ),
          .bist_pattern_all                    (bist_pattern_all                  ),
          .bist_success_status                 (bist_success_status               ),
//          .bist_finish_status                  (bist_finish_status                ),
          .bist_finish_intr                    (bist_finish_intr                  ),
          .bist_finish_int_mask                (bist_finish_mask_tmp              ),
          .bist_finish_clr                     (bist_finish_clr_tmp               ),
          .csl_err_threshold                   (csl_err_threshold                 ),
          .mc_timeout_flag                     (mc_timeout_flag                   ),
          .bist_scan_status                    (bist_scan_status                  ), //wl_scan_working,csl_scan_working,bank_scan_working
          
          .bank_scan_frame_vld                 (bank_scan_frame_vld               ),
          .bank_scan_frame_rdy                 (bank_scan_frame_rdy               ),
          .bank_scan_frame_data                (bank_scan_frame_data              ),//rw_flag,sof,eof,data,row,col
          .bank_scan_rvalid                    (bank_scan_rvalid                  ),
          .bank_scan_rdata                     (bank_scan_rdata                   ),
          
          .csl_scan_frame_vld                  (csl_scan_frame_vld                ),
          .csl_scan_frame_rdy                  (csl_scan_frame_rdy                ),
          .csl_scan_frame_data                 (csl_scan_frame_data               ),//rw_flag,sof,eof,data,row,col
          .csl_scan_rvalid                     (csl_scan_rvalid                   ),
          .csl_scan_rdata                      (csl_scan_rdata                    ),
          
          .wl_scan_frame_vld                   (wl_scan_frame_vld                 ),
          .wl_scan_frame_rdy                   (wl_scan_frame_rdy                 ),
          .wl_scan_frame_data                  (wl_scan_frame_data                ),//rw_flag,sof,eof,data,row,col
          .wl_scan_rvalid                      (wl_scan_rvalid                    ),
          .wl_scan_rdata                       (wl_scan_rdata                     ),
          
          .bank_err_csl0_part0                 (bank_err_csl0_part0               ),
          .bank_err_csl1_part0                 (bank_err_csl1_part0               ),
          .bank_err_csl0_part1                 (bank_err_csl0_part1               ),
          .bank_err_csl1_part1                 (bank_err_csl1_part1               ),
          .bank_err_csl0_part2                 (bank_err_csl0_part2               ),
          .bank_err_csl1_part2                 (bank_err_csl1_part2               ),
          .bank_err_csl0_part3                 (bank_err_csl0_part3               ),
          .bank_err_csl1_part3                 (bank_err_csl1_part3               ),
          .bank_err_csl0_part4                 (bank_err_csl0_part4               ),
          .bank_err_csl1_part4                 (bank_err_csl1_part4               ),
          .bank_err_csl0_part5                 (bank_err_csl0_part5               ),
          .bank_err_csl1_part5                 (bank_err_csl1_part5               ),
          .bank_err_csl0_part6                 (bank_err_csl0_part6               ),
          .bank_err_csl1_part6                 (bank_err_csl1_part6               ),
          .bank_err_csl0_part7                 (bank_err_csl0_part7               ),
          .bank_err_csl1_part7                 (bank_err_csl1_part7               ),
          .bank_err_csl0_part8                 (bank_err_csl0_part8               ),
          .bank_err_csl1_part8                 (bank_err_csl1_part8               ),
          .bank_err_csl0_part9                 (bank_err_csl0_part9               ),
          .bank_err_csl1_part9                 (bank_err_csl1_part9               ),


          .bank_err_wl0                        (bank_err_wl0                      ),
          .bank_err_wl1                        (bank_err_wl1                      ),
          .bank_err_wl2                        (bank_err_wl2                      ),
          .bank_err_wl3                        (bank_err_wl3                      ),
          .bank_err_wl4                        (bank_err_wl4                      ),
          .bank_err_wl5                        (bank_err_wl5                      ),
          .bank_err_wl6                        (bank_err_wl6                      ),
          .bank_err_wl7                        (bank_err_wl7                      ),
          .bank_err_wl8                        (bank_err_wl8                      ),
          .bank_err_wl9                        (bank_err_wl9                      ),
          .bank_err_wl10                       (bank_err_wl10                     ),
          .bank_err_wl11                       (bank_err_wl11                     ),
          .bank_err_wl12                       (bank_err_wl12                     ),
          .bank_err_wl13                       (bank_err_wl13                     ),
          .bank_err_wl14                       (bank_err_wl14                     ),
          .bank_err_wl15                       (bank_err_wl15                     ),
          .bank_err_wl16                       (bank_err_wl16                     ),
          .bank_err_wl17                       (bank_err_wl17                     ),
          .bank_err_wl18                       (bank_err_wl18                     ),
          .bank_err_wl19                       (bank_err_wl19                     ),
          .bank_err_wl20                       (bank_err_wl20                     ),
          .bank_err_wl21                       (bank_err_wl21                     ),
          .bank_err_wl22                       (bank_err_wl22                     ),
          .bank_err_wl23                       (bank_err_wl23                     ),
          .bank_err_wl24                       (bank_err_wl24                     ),
          .bank_err_wl25                       (bank_err_wl25                     ),
          .bank_err_wl26                       (bank_err_wl26                     ),
          .bank_err_wl27                       (bank_err_wl27                     ),
          .bank_err_wl28                       (bank_err_wl28                     ),
          .bank_err_wl29                       (bank_err_wl29                     ),
          .bank_err_wl30                       (bank_err_wl30                     ),
          .bank_err_wl31                       (bank_err_wl31                     ),
          .bank_err_wl32                       (bank_err_wl32                     ),
          .bank_err_wl33                       (bank_err_wl33                     ),
          .bank_err_wl34                       (bank_err_wl34                     ),
          .bank_err_wl35                       (bank_err_wl35                     ),
          .bank_err_wl36                       (bank_err_wl36                     ),
          .bank_err_wl37                       (bank_err_wl37                     ),
          .bank_err_wl38                       (bank_err_wl38                     ),
          .bank_err_wl39                       (bank_err_wl39                     ),
          .bank_err_wl40                       (bank_err_wl40                     ),
          .bank_err_wl41                       (bank_err_wl41                     ),
          .bank_err_wl42                       (bank_err_wl42                     ),
          .bank_err_wl43                       (bank_err_wl43                     ),
          .bank_err_wl44                       (bank_err_wl44                     ),
          .bank_err_wl45                       (bank_err_wl45                     ),
          .bank_err_wl46                       (bank_err_wl46                     ),
          .bank_err_wl47                       (bank_err_wl47                     ),
          .bank_err_wl48                       (bank_err_wl48                     ),
          .bank_err_wl49                       (bank_err_wl49                     ),
          .bank_err_wl50                       (bank_err_wl50                     ),
          .bank_err_wl51                       (bank_err_wl51                     ),
          .bank_err_wl52                       (bank_err_wl52                     ),
          .bank_err_wl53                       (bank_err_wl53                     ),
          .bank_err_wl54                       (bank_err_wl54                     ),
          .bank_err_wl55                       (bank_err_wl55                     ),
          .bank_err_wl56                       (bank_err_wl56                     ),
          .bank_err_wl57                       (bank_err_wl57                     ),
          .bank_err_wl58                       (bank_err_wl58                     ),
          .bank_err_wl59                       (bank_err_wl59                     ),
          .bank_err_wl60                       (bank_err_wl60                     ),
          .bank_err_wl61                       (bank_err_wl61                     ),
          .bank_err_wl62                       (bank_err_wl62                     ),
          .bank_err_wl63                       (bank_err_wl63                     ),
          .bank_err_wl_cnt                     (bank_err_wl_cnt                   ),
          .bank_err_wl_cnt_change_flag         (bank_err_wl_cnt_change_flag       ),
          .bank_bist_finish                    (bank_bist_finish                  ),

          .bank_bist_success                   (bank_bist_success                 ),

          .bank_bist_bank_fail                 (bank_bist_bank_fail               ),
          .bist_timeout_clr                    (bist_timeout_clr                  )

);
pulse2pulse_aux ipdb_pulse2pulse_inst_u0 ( 
    .clk1   (apb_clk                ),
    .rst1_n (apb_rst_n              ),
    .in     (mc_timeout_clr         ),
    .clk2   (clk                    ),
    .rst2_n (rst_n                  ),
    .out    (mc_timeout_clr_tmp     )    
);
pulse2pulse_aux ipdb_pulse2pulse_inst_u1 ( 
    .clk1   (apb_clk                ),
    .rst1_n (apb_rst_n              ),
    .in     (bist_finish_clr        ),
    .clk2   (clk                    ),
    .rst2_n (rst_n                  ),
    .out    (bist_finish_clr_tmp    )    
);
pulse2pulse_aux ipdb_pulse2pulse_inst_u2 ( 
    .clk1   (apb_clk                ),
    .rst1_n (apb_rst_n              ),
    .in     (hang_timeout_clr       ),
    .clk2   (clk                    ),
    .rst2_n (rst_n                  ),
    .out    (hang_timeout_clr_tmp   )    
);

pulse2pulse_aux ipdb_pulse2pulse_inst_u3 ( 
    .clk1   (apb_clk                ),
    .rst1_n (apb_rst_n              ),
    .in     (rescan_finish_clr      ),
    .clk2   (clk                    ),
    .rst2_n (rst_n                  ),
    .out    (rescan_finish_clr_tmp  )    
);
//assign bist_or_rescan_finish = bist_rescan_finish || bist_finish ;

assign dram_init_working = global_dram_init_en_tmp && mc_en_tmp ? !dram_init_finish : 1'b0;
mc_frame2frame_aux #(
                .FRAME_WIDTH         (FRAME_WIDTH          ),
                .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH ),
                .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH ),
                .CHECKBIT_WIDTH      (CHECKBIT_WIDTH       ),
                .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH     )
        )mc_frame2frame_u(
                .clk                 (clk                  ),
                .rst_n               (rst_n                ),
                
                .vmc_wl_en           (mc_wl_vmc_en_tmp     ),
                .vmc_bl_en           (mc_bl_vmc_en_tmp     ),
                .rf_burst_split_en   (mc_rf_burst_split_en_tmp),
                

                .inner_precharge     (inner_precharge      ),
                .page_mode_switch    (page_mode_switch_tmp ),//1:open page,0:close page
                .mc_all_bank_act_en  (mc_all_bank_act_en_tmp),
                .mc_page_status      (mc_page_status       ),
                .rf_req              (rf_req               ),
                .bank_map_id         (bank_map_id          ),
                .array_fsm_cs        (array_fsm_cs         ),
                .array_fsm_ns        (array_fsm_ns         ),
                .bist_working        (bist_working         ),
                .dram_init_working   (dram_init_working    ),

                .hub_frame_vld       (hub_frame_vld        ),
                .hub_frame_rdy       (hub_frame_rdy        ),
                .hub_frame_data      (hub_frame_data       ),
                
                .mc_rvalid           (mc_rvalid            ),
                .mc_rdata            (mc_rdata             ),
                
                .mc_frame_vld        (func_frame_vld       ),
                .mc_frame_rdy        (func_frame_rdy       ),
                .mc_frame_data       (func_frame_data      ),
                
                .array_rvalid        (func_rvalid          ),
                .array_rdata         (func_rdata           ),
                .pre_precharge       (pre_precharge_tmp    )

);

bist_rescan_top_aux #(
                .ARRAY_ADDR_WIDTH    (ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH ),
                .CHECKBIT_WIDTH      (CHECKBIT_WIDTH                            ),
                .RESCAN_ROUND_NUM    (RESCAN_ROUND_NUM                          ),
                .MC_SHORT_MODE       (MC_SHORT_MODE                             ),
                .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH                      ),
                .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH                      ),
                .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH                          )
            )U_bist_rescan_top_aux(
  //-------------clock and reset signal--------------
                .clk                        (clk_bist                    ),
                .rst_n                      (rst_n                       ),

                .mc_bist_grant              (mc_bist_grant               ),
                .bist_rescan_sel            (mc_rescan_addr_range_sel_tmp),
                                          
                .global_mc_bist_en          (global_mc_bist_en_tmp       ),
                .global_mc_rescan_start     (global_mc_rescan_start_tmp  ),//default 0
                .mc_bist_en                 (mc_bist_en                  ),
                			              
                .bist_rescan_num            (bist_rescan_num             ),//default 3
                .wl_bist_pattern_sel        (wl_bist_pattern_sel         ),
                .bist_pattern_all           (bist_pattern_all            ),
                                															              
                .bist_rescan_success        (bist_rescan_success         ),
                .bist_rescan_finish_intr    (bist_rescan_finish          ),
                .bist_rescan_finish_status  (bist_rescan_finish_status   ),
                .rescan_finish_clr          (rescan_finish_clr_tmp       ),
                .rescan_finish_mask         (rescan_finish_mask_tmp      ),
                .rescan_working             (rescan_working              ),
                .bist_clk_cnt_test          (bist_clk_cnt_test           ),
                                            
                .rescan_frame_vld           (rescan_frame_vld            ),
                .rescan_frame_rdy           (rescan_frame_rdy            ),
                .rescan_frame_data          (rescan_frame_data           ),//rw_flag,sof,eof,data,row,col
                .rescan_rvalid              (rescan_rvalid               ),
                .rescan_rdata               (rescan_rdata                ),

                .bank_rescan_fail_num       (bank_rescan_fail_num        ),
                .bank_rescan_finish_status  (bank_rescan_finish_status   ),
                .bank_rescan_success_status (bank_rescan_success_status  ),
                .bank_rescan_round_result   (bank_rescan_round_result    )

);








dram_init_wr_aux #(
                .ROW_ADDR_WIDTH           (ARRAY_ROW_ADDR_WIDTH  ),
                .COL_ADDR_WIDTH           (ARRAY_COL_ADDR_WIDTH  ),
                .MC_SHORT_MODE            (MC_SHORT_MODE         ),
                .WL_NUM                   (7360                  ),
                .CHECKBIT_WIDTH           (CHECKBIT_WIDTH        ),
                .FRAME_WIDTH              (ARRAY_COL_ADDR_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+3+2)
)dram_init_wr_aux_u(
  
                .clk                      (clk                    ),
                .rst_n                    (rst_n                  ),
                //.ras_clr                (ras_clr          ),
                .global_dram_init_en      (global_dram_init_en_tmp),
                .mc_dram_init_en          (mc_en_tmp&&mc_rf_start ),										
                .mc_dram_init_finish      (dram_init_finish       ),
  
                .dram_init_frame_vld      (dram_init_frame_vld    ),
                .dram_init_frame_rdy      (dram_init_frame_rdy    ),
                .dram_init_frame_data     (dram_init_frame_data   )//rw_flag,sof,eof,data,row,col
);



assign  rescan_frame_rdy     = global_dram_init_en_tmp ? rescan_frame_rdy_tmp && dram_init_finish : rescan_frame_rdy_tmp;
assign  func_frame_rdy       = global_dram_init_en_tmp ? func_frame_rdy_tmp && dram_init_finish : func_frame_rdy_tmp;
assign  wl_scan_frame_rdy    = global_dram_init_en_tmp ? wl_scan_frame_rdy_tmp && dram_init_finish : wl_scan_frame_rdy_tmp;
assign  csl_scan_frame_rdy   = global_dram_init_en_tmp ? csl_scan_frame_rdy_tmp && dram_init_finish : csl_scan_frame_rdy_tmp;
assign  bank_scan_frame_rdy  = global_dram_init_en_tmp ? bank_scan_frame_rdy_tmp && dram_init_finish : bank_scan_frame_rdy_tmp;

assign  rescan_frame_vld_tmp    = global_dram_init_en_tmp ? rescan_frame_vld && dram_init_finish : rescan_frame_vld ;
assign  func_frame_vld_tmp      = global_dram_init_en_tmp ? func_frame_vld && dram_init_finish : func_frame_vld ;
assign  wl_scan_frame_vld_tmp   = global_dram_init_en_tmp ? wl_scan_frame_vld && dram_init_finish : wl_scan_frame_vld ;
assign  csl_scan_frame_vld_tmp  = global_dram_init_en_tmp ? csl_scan_frame_vld && dram_init_finish : csl_scan_frame_vld ;
assign  bank_scan_frame_vld_tmp = global_dram_init_en_tmp ? bank_scan_frame_vld && dram_init_finish : bank_scan_frame_vld ;


mc_frame_arbiter_aux #(
               .AXI_SLV_NUM         (6),
               .TDATA_WIDTH         (ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+3+2+1),//256bit data,10bit checkbit,21bit addr
               .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH+CHECKBIT_WIDTH)

)frame_arbiter_u(
                .clk                 (clk                  ),
                .rst_n               (rst_n                ),
                
                .s_tvalid            ({dram_init_frame_vld,rescan_frame_vld_tmp,func_frame_vld_tmp,wl_scan_frame_vld_tmp,csl_scan_frame_vld_tmp,bank_scan_frame_vld_tmp}   ),
                .s_tready            ({dram_init_frame_rdy,rescan_frame_rdy_tmp,func_frame_rdy_tmp,wl_scan_frame_rdy_tmp,csl_scan_frame_rdy_tmp,bank_scan_frame_rdy_tmp}   ),
                .s_tdata             ({1'b1,dram_init_frame_data,1'b1,rescan_frame_data,func_frame_data,1'b1,wl_scan_frame_data,1'b1,csl_scan_frame_data,1'b1,bank_scan_frame_data}),
                
                .m_tvalid            (mc_frame_vld         ),
                .m_tready            (mc_frame_rdy         ),
                .m_tdata             (mc_frame_data        ),


                .array_rvalid        (arb_rvalid           ),
                .array_rdata         (arb_rdata            ),

                .bist_path_rvalid    (bank_scan_rvalid     ),
                .bist_path_rdata     (bank_scan_rdata      ),          

                .bist_csl_rvalid     (csl_scan_rvalid      ),
                .bist_csl_rdata      (csl_scan_rdata       ),      
                
                .bist_wl_rvalid      (wl_scan_rvalid       ),
                .bist_wl_rdata       (wl_scan_rdata        ),     
 
                .func_rvalid         (func_rvalid          ),
                .func_rdata          (func_rdata           ),

                .rescan_rvalid       (rescan_rvalid        ),
                .rescan_rdata        (rescan_rdata         )

);



//generate
//if(MC_SHORT_MODE>=2) begin
//    always @(*)begin
//        if(bank_map_id[3:2]==2'b00)begin
//            remap_wl_addr_tmp[1*ARRAY_ROW_ADDR_WIDTH*64 +: ARRAY_ROW_ADDR_WIDTH*64] = bank0_remap_wl_addr;
//            remap_csl_addr_tmp[1*ARRAY_COL_ADDR_WIDTH*20 +: ARRAY_COL_ADDR_WIDTH*20] = bank0_remap_csl_addr;
//            
//        end
//        else if(bank_map_id[3:2]==2'b01)begin
//            remap_wl_addr_tmp[1*ARRAY_ROW_ADDR_WIDTH*64 +: ARRAY_ROW_ADDR_WIDTH*64] = bank1_remap_wl_addr;
//            remap_csl_addr_tmp[1*ARRAY_COL_ADDR_WIDTH*20 +: ARRAY_COL_ADDR_WIDTH*20] = bank1_remap_csl_addr;
//            
//        end
//        else if(bank_map_id[3:2]==2'b10)begin
//            remap_wl_addr_tmp[1*ARRAY_ROW_ADDR_WIDTH*64 +: ARRAY_ROW_ADDR_WIDTH*64] = bank2_remap_wl_addr;
//            remap_csl_addr_tmp[1*ARRAY_COL_ADDR_WIDTH*20 +: ARRAY_COL_ADDR_WIDTH*20] = bank2_remap_csl_addr;
//            
//        end
//        else begin
//            remap_wl_addr_tmp[1*ARRAY_ROW_ADDR_WIDTH*64 +: ARRAY_ROW_ADDR_WIDTH*64] = bank3_remap_wl_addr;
//            remap_csl_addr_tmp[1*ARRAY_COL_ADDR_WIDTH*20 +: ARRAY_COL_ADDR_WIDTH*20] = bank3_remap_csl_addr;
//            
//        end
//    end
//end
//endgenerate
//
//generate
//if(MC_SHORT_MODE>=3) begin
//    always @(*)begin
//        if(bank_map_id[5:4]==2'b00)begin
//            remap_wl_addr_tmp[2*ARRAY_ROW_ADDR_WIDTH*64 +: ARRAY_ROW_ADDR_WIDTH*64] = bank0_remap_wl_addr;
//            remap_csl_addr_tmp[2*ARRAY_COL_ADDR_WIDTH*20 +: ARRAY_COL_ADDR_WIDTH*20] = bank0_remap_csl_addr;
//            
//        end
//        else if(bank_map_id[5:4]==2'b01)begin
//            remap_wl_addr_tmp[2*ARRAY_ROW_ADDR_WIDTH*64 +: ARRAY_ROW_ADDR_WIDTH*64] = bank1_remap_wl_addr;
//            remap_csl_addr_tmp[2*ARRAY_COL_ADDR_WIDTH*20 +: ARRAY_COL_ADDR_WIDTH*20] = bank1_remap_csl_addr;
//            
//        end
//        else if(bank_map_id[5:4]==2'b10)begin
//            remap_wl_addr_tmp[2*ARRAY_ROW_ADDR_WIDTH*64 +: ARRAY_ROW_ADDR_WIDTH*64] = bank2_remap_wl_addr;
//            remap_csl_addr_tmp[2*ARRAY_COL_ADDR_WIDTH*20 +: ARRAY_COL_ADDR_WIDTH*20] = bank2_remap_csl_addr;
//            
//        end
//        else begin
//            remap_wl_addr_tmp[2*ARRAY_ROW_ADDR_WIDTH*64 +: ARRAY_ROW_ADDR_WIDTH*64] = bank3_remap_wl_addr;
//            remap_csl_addr_tmp[2*ARRAY_COL_ADDR_WIDTH*20 +: ARRAY_COL_ADDR_WIDTH*20] = bank3_remap_csl_addr;
//            
//        end
//    end
//end
//endgenerate
//
//generate
//if(MC_SHORT_MODE>=4) begin
//    always @(*)begin
//        if(bank_map_id[7:6]==2'b00)begin
//            remap_wl_addr_tmp[3*ARRAY_ROW_ADDR_WIDTH*64 +: ARRAY_ROW_ADDR_WIDTH*64] = bank0_remap_wl_addr;
//            remap_csl_addr_tmp[3*ARRAY_COL_ADDR_WIDTH*20 +: ARRAY_COL_ADDR_WIDTH*20] = bank0_remap_csl_addr;
//            
//        end
//        else if(bank_map_id[7:6]==2'b01)begin
//            remap_wl_addr_tmp[3*ARRAY_ROW_ADDR_WIDTH*64 +: ARRAY_ROW_ADDR_WIDTH*64] = bank1_remap_wl_addr;
//            remap_csl_addr_tmp[3*ARRAY_COL_ADDR_WIDTH*20 +: ARRAY_COL_ADDR_WIDTH*20] = bank1_remap_csl_addr;
//            
//        end
//        else if(bank_map_id[7:6]==2'b10)begin
//            remap_wl_addr_tmp[3*ARRAY_ROW_ADDR_WIDTH*64 +: ARRAY_ROW_ADDR_WIDTH*64] = bank2_remap_wl_addr;
//            remap_csl_addr_tmp[3*ARRAY_COL_ADDR_WIDTH*20 +: ARRAY_COL_ADDR_WIDTH*20] = bank2_remap_csl_addr;
//            
//        end
//        else begin
//            remap_wl_addr_tmp[3*ARRAY_ROW_ADDR_WIDTH*64 +: ARRAY_ROW_ADDR_WIDTH*64] = bank3_remap_wl_addr;
//            remap_csl_addr_tmp[3*ARRAY_COL_ADDR_WIDTH*20 +: ARRAY_COL_ADDR_WIDTH*20] = bank3_remap_csl_addr;
//            
//        end
//    end
//end
//endgenerate

//generate
//if(MC_SHORT_MODE==4)begin 
//
//
//end
//else if(MC_SHORT_MODE==3)begin
//
//
//assign bank3_remap_wl_addr = {64{13'h1FFF}};
//assign bank3_remap_csl_addr = {64{8'hFF}};
//
//
//
//
//
//end
//else if(MC_SHORT_MODE==2)begin
//
//
//assign bank2_remap_wl_addr = {64{13'h1FFF}};
//assign bank2_remap_csl_addr = {64{8'hFF}};
//assign bank3_remap_wl_addr = {64{13'h1FFF}};
//assign bank3_remap_csl_addr = {64{8'hFF}};
//
//
//
//end
/////MC_SHORT_MODE==1
//else begin
//assign bank1_remap_wl_addr = {64{13'h1FFF}};
//assign bank1_remap_csl_addr = {64{8'hFF}};
//assign bank2_remap_wl_addr = {64{13'h1FFF}};
//assign bank2_remap_csl_addr = {64{8'hFF}};
//assign bank3_remap_wl_addr = {64{13'h1FFF}};
//assign bank3_remap_csl_addr = {64{8'hFF}};
//end
//endgenerate

vmc_top_aux #(
                .ARRAY_ROW_ADDR_WIDTH (ARRAY_ROW_ADDR_WIDTH),
                .ARRAY_COL_ADDR_WIDTH (ARRAY_COL_ADDR_WIDTH),
                .CHECKBIT_WIDTH       (CHECKBIT_WIDTH      ),
                .ARRAY_DATA_WIDTH     (ARRAY_DATA_WIDTH    ),
                .WL_NUM               (7360                ),
                .MC_SHORT_MODE        (MC_SHORT_MODE       ),
                .FRAME_WIDTH          (FRAME_WIDTH         )
)vmc_top_aux_u(
                .vmc_wl_en            (mc_wl_vmc_en_tmp    ),
                .remap_wl_addr        (remap_wl_addr_tmp   ),//64
                .vmc_bl_en            (mc_bl_vmc_en_tmp    ),
                .remap_csl_addr       (remap_csl_addr_tmp  ),//2,[ARRAY_COL_ADDR_WIDTH*2-1:0]:part0,lsb
                
                .frame_vld            (mc_frame_vld        ),
                .frame_rdy            (mc_frame_rdy        ),
                .frame_data           (mc_frame_data       ),

                .frame_vmc_vld        (mc_frame_vmc_vld    ),
                .frame_vmc_rdy        (mc_frame_vmc_rdy    ),
                .frame_vmc_data       (mc_frame_vmc_data   )
);   



mc_timeout_aux #(
        .ARRAY_ROW_ADDR_WIDTH  (ARRAY_ROW_ADDR_WIDTH       ), 
        .ARRAY_COL_ADDR_WIDTH  (ARRAY_COL_ADDR_WIDTH       ),
        .CHECKBIT_WIDTH        (CHECKBIT_WIDTH             ), 
        .ARRAY_DATA_WIDTH      (ARRAY_DATA_WIDTH           ), 
        .FRAME_WIDTH           (VMC_FRAME_WIDTH            )
)mc_timeout_u(
        .clk                   (clk                        ),
        .rst_n                 (rst_n                      ),
        //.ras_clr             (ras_clr                  ),
        .timeout_en            (mc_scan_timeout_en_tmp     ),//initail scan use
        .timeout_clr           (mc_timeout_clr_tmp||bist_timeout_clr),
        .timeout_th            (mc_timeout_th              ),
        .timeout_status        (mc_timeout_flag            ),//1:read req timeout flag
        
        .hang_timeout_intr     (hang_timeout_intr          ),//normal func use
        .hang_timeout_clr      (hang_timeout_clr_tmp       ),
        .hang_timeout_mask     (hang_timeout_mask_tmp      ),
        .hang_timeout_status   (hang_timeout_status        ),
        .hang_timeout_th       (hang_timeout_th            ),
        .hang_timeout_en       (hang_timeout_en_tmp        ),
                
        .timeout_sel_en        (mc_scan_timeout_en_tmp     ),//1:initial scan 0:normal  
                
        .hub_frame_vld         (mc_frame_vmc_vld           ),
        .hub_frame_rdy         (mc_frame_vmc_rdy           ),
        .hub_frame_data        (mc_frame_vmc_data          ),
        
        .mc_rvalid             (arb_rvalid                 ),
        .mc_rdata              (arb_rdata                  ),
                
        .mc_frame_vld          (array_frame_vld            ),
        .mc_frame_rdy          (array_frame_rdy            ),
        .mc_frame_data         (array_frame_data           ),
        
        .array_rvalid          (array_rvalid               ),
        .array_rdata           (array_rdata                ) 
   
);


//`ifndef COMMON_MC
//mc_loopback_aux #(
//    .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH    ),
//    .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH),
//    .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH),
//    .CHECKBIT_WIDTH      (CHECKBIT_WIDTH      ),
//    .MC_SHORT_MODE       (MC_SHORT_MODE       ),
//    .MC_FRAME_WIDTH      (VMC_FRAME_WIDTH)
//)mc_loopback_aux_u(
//    .clk                 (clk               ),
//    .rst_n               (rst_n             ),
//    .bnksel_n_mc         (bnksel_n_mc       ),
//    .gradd_n_mc          (gradd_n_mc        ),
//    .gcas_rd_mc          (gcas_rd_mc        ),
//    .gcas_wr_mc          (gcas_wr_mc        ),
//    .gcadd_mc            (gcadd_mc          ),
//    .wdl_mc              (wdl_mc            ),
//    .wdl_oe_mc           (wdl_oe_mc         ),
//    .rdrdy_n_mc          (rdrdy_n_mc        ),
//    .rdl_mc              (rdl_mc            ),
//                                           
//    .mc_loopback_en      (mc_loopback_en    ),   // 1 enable loopback ; 0 disable loopback
//    .afifo_push          (afifo_push        ),
//    .afifo_pop           (afifo_pop         ),
//    .afifo_empty         (afifo_empty       ),
//
//    .bnksel_n            (bnksel_n          ),
//    .gradd_n             (gradd_n           ),
//    .gcas_rd             (gcas_rd           ),
//    .gcas_wr             (gcas_wr           ),
//    .gcadd               (gcadd             ),
//    .wdl                 (wdl               ),
//    .wdl_oe              (wdl_oe            ),
//    .rdrdy_n             (rdrdy_n           ),
//    .rdl                 (rdl               )
//);
//`endif                


frame2array_aux #(
                .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH    ),
                .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH),
                .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH),
                .CHECKBIT_WIDTH      (CHECKBIT_WIDTH      ),
                .MC_SHORT_MODE       (MC_SHORT_MODE       ),
                //.MC_FRAME_WIDTH      (ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+3+2+1)
                .MC_FRAME_WIDTH      (VMC_FRAME_WIDTH)
        )frame2array_u(
                .clk                   (clk                 ),
                .rst_n                 (rst_n               ),
                .ras_clr               (ras_clr             ),
                .mc_en                 (mc_en_tmp           ),
                .mc_rf_start           (mc_rf_start         ),
                .global_rf_sel_en      (global_rf_sel_en_tmp),
                .global_rf_cnt_clr     (global_rf_cnt_clr_tmp),
                .mc_rf_en              (mc_rf_en_tmp         ),
                .mc_all_bank_act_en    (mc_all_bank_act_en_tmp),
                //.mc_rf_burst_split_en  (mc_rf_burst_split_en_tmp),
                .mc_rdata_invert_sel   (mc_rdata_invert_sel_tmp),
                .mc_rdrdy_n_en         (mc_rdrdy_n_en       ),
                .global_rf_sel         (global_rf_sel       ),
                .mc_rf_cfg_sel         (mc_rf_cfg_sel_tmp   ),
                .mc_trc_cfg            (mc_trc_cfg          ),
                .mc_tras_cfg           (mc_tras_cfg         ),
                .mc_trp_cfg            (mc_trp_cfg          ),
                .mc_trcd_cfg           (mc_trcd_cfg         ),
                .mc_trcb_cfg           (mc_trcb_cfg         ),
                .mc_trtp_cfg           (mc_trtp_cfg         ),
                .mc_twr_cfg            (mc_twr_cfg          ),
                .mc_twtr_cfg           (mc_twtr_cfg         ),
                .mc_trtw_cfg           (mc_trtw_cfg         ),

                .array_fsm_cs          (array_fsm_cs        ),
                .array_fsm_ns          (array_fsm_ns        ),

                .mc_rf_period_1        (mc_rf_period_1      ),
                .mc_rf_period_2        (mc_rf_period_2      ),
                .mc_rf_start_1         (mc_rf_start_1       ),
                .mc_rf_start_2         (mc_rf_start_2       ),

                .rf_range_change_en    (rf_range_change_en_tmp),
                .rf_start_raddr        (rf_start_raddr      ),
                .rf_end_raddr          (rf_end_raddr        ),

                .inner_precharge       (inner_precharge     ),
                .rf_req                (rf_req              ),

                .mc_frame_vld          (array_frame_vld     ),
                .mc_frame_rdy          (array_frame_rdy     ),
                .mc_frame_data         (array_frame_data    ),
                .array_rvalid          (array_rvalid        ),
                .array_rdata           (array_rdata         ),
                //`ifdef COMMON_MC
                .bnksel_n              (bnksel_n            ),
                .gradd_n               (gradd_n             ),
                .gcas_rd               (gcas_rd             ),
                .gcas_wr               (gcas_wr             ),
                .gcadd                 (gcadd               ),
//                .wrrdy_n               (wrrdy_n             ),
                .wdl                   (wdl                 ),
                .wdl_oe                (wdl_oe              ),
                .rdrdy_n               (rdrdy_n             ),
                .rdl                   (rdl                 ),
                //`else
                //.bnksel_n              (bnksel_n_mc         ),
                //.gradd_n               (gradd_n_mc          ),
                //.gcas_rd               (gcas_rd_mc          ),
                //.gcas_wr               (gcas_wr_mc          ),
                //.gcadd                 (gcadd_mc            ),
//              //  .wrrdy_n               (wrrdy_n             ),
                //.wdl                   (wdl_mc              ),
                //.wdl_oe                (wdl_oe_mc           ),
                //.rdrdy_n               (rdrdy_n_mc          ),
                //.rdl                   (rdl_mc              ),
                //`endif
                .dbg_w_frame_cnt       (dbg_w_frame_cnt     ),  
                .dbg_r_frame_cnt       (dbg_r_frame_cnt     ),  
                .dbg_r_data_cnt        (dbg_r_data_cnt      ),  
                .dbg_refresh_flag      (dbg_refresh_flag    ),
                .dbg_current_state     (dbg_current_state   ),   
                .dbg_next_state        (dbg_next_state      ),
                .rdrdy_n_monitor       (rdrdy_n_monitor     ),
                //rf 
                .mc_rf_start_sel       (mc_rf_start_sel_tmp ),
                .rf_start_time         (rf_start_time       ),
                .mc_rf_period_sel      (mc_rf_period_sel_tmp),
                //`ifndef COMMON_MC
                //.rd_empty              (afifo_empty         ),  // wy add mc loopback
                //.afifo_push            (afifo_push          ),  // wy add mc loopback
                //.afifo_pop             (afifo_pop           ),  // wy add mc loopback
                //`endif
                //.mc_loopback_en        (mc_loopback_en      ),  // wy add mc loopback
                .rf_gear_up_en         (rf_gear_up_en       ),
                .rf_gear_id            (rf_gear_id          ),
                .rf_row_num            (rf_row_num          ),
                .rf_single_interval    (rf_single_interval  )


    );

generate
if(MC_SHORT_MODE==4) begin
    always @(*)begin
        remap_wl_addr_tmp  = {bank3_remap_wl_addr,  bank2_remap_wl_addr,  bank1_remap_wl_addr,  bank0_remap_wl_addr };
        remap_csl_addr_tmp = {bank3_remap_csl_addr, bank2_remap_csl_addr, bank1_remap_csl_addr, bank0_remap_csl_addr};
    end
end
else if(MC_SHORT_MODE==3) begin
    always @(*)begin
        remap_wl_addr_tmp  = {bank2_remap_wl_addr,  bank1_remap_wl_addr,  bank0_remap_wl_addr };
        remap_csl_addr_tmp = {bank2_remap_csl_addr, bank1_remap_csl_addr, bank0_remap_csl_addr};
    end
end
else if(MC_SHORT_MODE==2) begin
    always @(*)begin
        remap_wl_addr_tmp  = {bank1_remap_wl_addr,  bank0_remap_wl_addr };
        remap_csl_addr_tmp = {bank1_remap_csl_addr, bank0_remap_csl_addr};
    end
end
else begin
    always @(*)begin
        remap_wl_addr_tmp  = bank0_remap_wl_addr ;
        remap_csl_addr_tmp = bank0_remap_csl_addr;
    end
end
endgenerate
//assign rf_working = array_fsm_cs == 5'd1 || array_fsm_cs == 5'd3|| array_fsm_cs == 5'd2 || array_fsm_cs == 5'd6 ;

//always @(posedge clk or negedge rst_n)begin
//    if(!rst_n)
//        layer_id <= 2'b00;
//    else if(array_frame_vld && array_frame_rdy)
//        layer_id <= array_frame_data[ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+2-1 -:2];
//end

//assign layer_id = array_frame_data[ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+2-1 -:2];
/*
always @(*)begin
    if(rf_working || dram_init_working)begin
        if(mc_short_mode==2'b11)
            bnksel_n = {4{bnksel_n_tmp}};
        else if(mc_short_mode==2'b10)
            bnksel_n = {1'b1,3{bnksel_n_tmp}};
        else if(mc_short_mode==2'b01)
            bnksel_n = {2'b11,2{bnksel_n_tmp}};
        else 
            bnksel_n = {3'b111,bnksel_n_tmp};
    end
    else begin
        case(layer_id)
        2'b00:begin
            if(bank_map_id[1:0]==2'b00)
                bnksel_n = {3'b111,bnksel_n_tmp};
            else if(bank_map_id[1:0]==2'b01)
                bnksel_n = {2'b11,bnksel_n_tmp,1'b1};
            else if(bank_map_id[1:0]==2'b10)
                bnksel_n = {1'b1,bnksel_n_tmp,2'b11};
            else 
                bnksel_n = {bnksel_n_tmp,3'b111};
        end
        2'b01:begin
            if(bank_map_id[3:2]==2'b00)
                bnksel_n = {3'b111,bnksel_n_tmp};
            else if(bank_map_id[3:2]==2'b01)
                bnksel_n = {2'b11,bnksel_n_tmp,1'b1};
            else if(bank_map_id[3:2]==2'b10)
                bnksel_n = {1'b1,bnksel_n_tmp,2'b11};
            else 
                bnksel_n = {bnksel_n_tmp,3'b111};
        end
        2'b10:begin
            if(bank_map_id[5:4]==2'b00)
                bnksel_n = {3'b111,bnksel_n_tmp};
            else if(bank_map_id[5:4]==2'b01)
                bnksel_n = {2'b11,bnksel_n_tmp,1'b1};
            else if(bank_map_id[5:4]==2'b10)
                bnksel_n = {nit
                1'b1,bnksel_n_tmp,2'b11};
            else 
                bnksel_n = {bnksel_n_tmp,3'b111};
        end
        2'b11:begin
            if(bank_map_id[7:6]==2'b00)
                bnksel_n = {3'b111,bnksel_n_tmp};
            else if(bank_map_id[7:6]==2'b01)
                bnksel_n = {2'b11,bnksel_n_tmp,1'b1};
            else if(bank_map_id[7:6]==2'b10)
                bnksel_n = {1'b1,bnksel_n_tmp,2'b11};
            else 
                bnksel_n = {bnksel_n_tmp,3'b111};
        end
        endcase
    end
end
*/
//reg      rf_work_flag             ;

//always @(posedge clk or negedge rst_n)begin
//    if(!rst_n)
//        rf_work_flag <= 1'b0;
//    else if(array_fsm_cs==RF_TRP_CNT && array_fsm_ns==IDLE)
//        rf_work_flag <= 1'b0;
//    else if(array_fsm_ns==RF_UP_RADDR)
//        rf_work_flag <= 1'b1;
//    end

//always @(posedge clk or negedge rst_n)begin
//    if(!rst_n)
//        dram_init_last_work_flag <= 1'b0;
//    else if(array_fsm_ns==IDLE && dram_init_finish)
//       dram_init_last_work_flag <= 1'b0;
//    else if(dram_init_frame_vld && dram_init_frame_rdy && dram_init_frame_data[7:0]==8'h7F && dram_init_frame_data[20:8]==13'h1C7F)
//       dram_init_last_work_flag <= 1'b1;
//end

//assign dram_init_work_flag = dram_init_working || dram_init_last_work_flag;

//always @(*)begin
//    if(dram_init_working || dram_init_last_work_flag)begin
//    	bnksel_n = {MC_SHORT_MODE{bnksel_n_tmp}};
//        gcas_wr  = {MC_SHORT_MODE{gcas_wr_tmp}};
//        gcas_rd  = {MC_SHORT_MODE{gcas_rd_tmp}};
//    end
//    else begin
//        bnksel_n = bnksel_n_tmp;
//        gcas_wr = gcas_wr_tmp;
//        gcas_rd = gcas_rd_tmp;  	
//    end
//end

generate
if(MC_SHORT_MODE==4) begin
    assign bnksel_n_mon =  bnksel_n;
    assign gcas_wr_mon  =  gcas_wr;
    assign gcas_rd_mon  =  gcas_rd;
end
else if(MC_SHORT_MODE==3)begin
    assign bnksel_n_mon =  {1'b1,bnksel_n};
    assign gcas_wr_mon  =  {1'b0,gcas_wr};
    assign gcas_rd_mon  =  {1'b0,gcas_rd};

end
else if(MC_SHORT_MODE==2)begin
    assign bnksel_n_mon =  {2'b1,bnksel_n};
    assign gcas_wr_mon  =  {2'b0,gcas_wr};
    assign gcas_rd_mon  =  {2'b0,gcas_rd};

end
else begin
    assign bnksel_n_mon =  {3'b1,bnksel_n};
    assign gcas_wr_mon  =  {3'b0,gcas_wr};
    assign gcas_rd_mon  =  {3'b0,gcas_rd};

end
endgenerate 

assign monitor_signals = {
                        16'd0,       
                        hub_frame_data[FRAME_WIDTH-2:FRAME_WIDTH-3],
                        hub_frame_data[1:0],
                        hub_frame_rdy      ,
                        hub_frame_vld      ,
                        mc_rdata[1:0]      ,
                        mc_rvalid          ,
                        bnksel_n_mon       ,
                        gradd_n[1:0]       , 
                        gcas_wr_mon        , 
                        gcas_rd_mon        , 
                        gcadd[1:0]         ,
                        wdl[1:0]           ,     
                        wdl_oe             ,
                        mc_rf_start        ,              
                        global_rf_sel_en   ,
                        global_rf_sel      ,   
                        mc_rf_cfg_sel      ,
                        rdrdy_n_monitor    ,
                        mc_en              
                        };

//------------------dbg frame/data store begin---------------------
  always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0) begin
      dbg_store_latest_frame <= {(FRAME_WIDTH-1){1'b0}};
    end
    else if (dbg_data_store_en && hub_frame_vld && hub_frame_rdy)begin
      dbg_store_latest_frame <= hub_frame_data;
    end
  end
  always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0) begin
      dbg_store_latest_rdata <= {ARRAY_DATA_WIDTH+CHECKBIT_WIDTH{1'b0}};
    end
    else if (dbg_data_store_en && mc_rvalid)begin
      dbg_store_latest_rdata <= mc_rdata;
    end
  end

//------------------dbg frame/data store begin---------------------


endmodule
