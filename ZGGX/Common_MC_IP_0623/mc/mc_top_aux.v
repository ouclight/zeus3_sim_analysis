module mc_top_aux #(
                parameter    APB_DATA_WIDTH       = 32,
                parameter    APB_ADDR_WIDTH       = 12,
                parameter    ARRAY_DATA_WIDTH     = 256,
                parameter    ARRAY_ROW_ADDR_WIDTH = 13,
                parameter    ARRAY_COL_ADDR_WIDTH = 8,
                parameter    PATTERN_WIDTH        = 32,
                parameter    CSL_ERR_TH_WIDTH     = 5,
                parameter    CHECKBIT_WIDTH       = 16,
                parameter    FRAME_WIDTH          = 3+ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH
        )(

                input                                                 clk                    ,
                input                                                 rst_n                  ,
                input    [31:0]                                       mc_id_soc              ,
                //input    [31:0]                                       mc_id_pe               ,
                input                                                 ras_clr                ,

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

                //output                                                mc_dram_init_finish ,
                                                 
                output                                                mc_debug_en            ,
                input                                                 mc_scan_timeout_en     ,
                output                                                bist_finish_int        ,

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
                //soc apb bus
                input                                                 soc_apb_sel            ,
                input                                                 soc_apb_enable         ,
                input                                                 soc_apb_write          ,
                input    [APB_ADDR_WIDTH-1:0]                         soc_apb_addr           ,
                input    [APB_DATA_WIDTH-1:0]                         soc_apb_wdata          ,
                output   [APB_DATA_WIDTH-1:0]                         soc_apb_rdata          ,
                output                                                soc_apb_pslverr        ,


                //array timing cfg
                input    [5:0]                                        mc_trc_cfg             ,//active to active time
                input    [4:0]                                        mc_tras_cfg            ,//rcd active to precharge time
                input    [3:0]                                        mc_trp_cfg             ,//precharge time
                input    [4:0]                                        mc_trcd_cfg            ,//write rcd time
                input    [0:0]                                        mc_trtp_cfg            ,//rd cas rising edge to precharge time
                input    [3:0]                                        mc_twr_cfg             ,//wr cas falling edge to precharge time
                input    [2:0]                                        mc_twtr_cfg            ,//write cas To Read cas time
                input    [3:0]                                        mc_trtw_cfg            ,//Read cas To Write cas time
                //bist pattern 
                //input    [6:0]                                        bist_csl_scan_num      ,
                //input    [6:0]                                        bist_wl_scan_num       ,
                input    [3:0]                                        bist_wl_scan_single_pattern_rd_num ,//max 16,default 0 :read one time
                input    [CSL_ERR_TH_WIDTH-1:0]                       csl_err_threshold      ,
                output                                                bank_success           ,
                //timeout
                input    [31:0]                                       mc_timeout_th          ,

                //array interface
                output                                                bnksel_n               , 
                output   [ARRAY_ROW_ADDR_WIDTH-1:0]                   gradd_n                ,
                output                                                gcas_wr                ,
                output                                                gcas_rd                ,
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

                //monitor
                output   [99:0]                                       monitor_signals        ,
                //ECC info
                output                                                mc_ecc_en                 ,
                input                                                 mc_ecc_ce_overflow_int    ,
                input  [4:0]                                          mc_ecc_ce_cnt             ,
                input  [16*22-1:0]                                    mc_ecc_ce_addr            ,
                input  [15:0]                                         mc_ecc_ce_addr_vld        ,
                input                                                 mc_ecc_uce_int            ,
                input  [2:0]                                          mc_ecc_uce_cnt            ,
                input  [4*22-1:0]                                     mc_ecc_uce_addr           ,
                input  [3:0]                                          mc_ecc_uce_addr_vld       ,
                output [4:0]                                          mc_ecc_ce_th              ,
                output                                                mc_ecc_ce_int_clr         ,
                output                                                mc_ecc_uce_int_clr        ,
                output                                                mc_ecc_ce_int_mask        ,
                output                                                mc_ecc_uce_int_mask


    );

wire       [31:0]                                                  mc_rf_period_1          ;
wire       [31:0]                                                  mc_rf_period_2          ;
wire       [31:0]                                                  mc_rf_start_1           ;
wire       [31:0]                                                  mc_rf_start_2           ;
wire                                                               mc_timeout_flag         ;
wire                                                               bist_finish             ;
wire                                                               bist_bank_finish        ;
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
wire       [FRAME_WIDTH-1:0]                                       mc_frame_vmc_data       ;  

wire                                                               array_frame_vld         ;
wire                                                               array_frame_rdy         ;
wire       [FRAME_WIDTH-1:0]                                       array_frame_data        ;  
wire                                                               array_rvalid            ;
wire       [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                   array_rdata             ;
wire                                                               arb_rvalid              ;
wire       [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                   arb_rdata               ;


wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl0_part0          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl1_part0          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl0_part1          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl1_part1          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl0_part2          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl1_part2          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl0_part3          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl1_part3          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl0_part4          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl1_part4          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl0_part5          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl1_part5          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl0_part6          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl1_part6          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl0_part7          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl1_part7          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl0_part8          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl1_part8          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl0_part9          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              err_csl1_part9          ; 
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl0                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl1                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl2                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl3                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl4                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl5                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl6                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl7                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl8                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl9                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl10                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl11                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl12                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl13                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl14                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl15                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl16                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl17                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl18                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl19                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl20                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl21                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl22                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl23                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl24                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl25                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl26                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl27                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl28                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl29                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl30                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl31                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl32                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl33                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl34                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl35                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl36                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl37                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl38                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl39                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl40                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl41                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl42                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl43                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl44                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl45                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl46                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl47                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl48                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl49                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl50                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl51                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl52                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl53                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl54                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl55                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl56                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl57                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl58                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl59                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl60                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl61                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl62                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              err_wl63                ; 

wire                                                               bank_scan_frame_vld     ;
wire                                                               bank_scan_frame_rdy     ;
wire     [FRAME_WIDTH-2:0]                                         bank_scan_frame_data    ;//rw_flag,sof,eof,data,row,col
wire                                                               bank_scan_rvalid        ;
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     bank_scan_rdata         ;

wire                                                               csl_scan_frame_vld      ;
wire                                                               csl_scan_frame_rdy      ;
wire     [FRAME_WIDTH-2:0]                                         csl_scan_frame_data     ;//rw_flag,sof,eof,data,row,col
wire                                                               csl_scan_rvalid         ;
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     csl_scan_rdata          ;

wire                                                               wl_scan_frame_vld       ;
wire                                                               wl_scan_frame_rdy       ;
wire     [FRAME_WIDTH-2:0]                                         wl_scan_frame_data      ;//rw_flag,sof,eof,data,row,col
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     wl_scan_rdata           ;
wire                                                               wl_scan_rvalid          ;

wire                                                               rescan_frame_vld        ;
wire                                                               rescan_frame_rdy        ;
wire     [FRAME_WIDTH-2:0]                                         rescan_frame_data       ;//rw_flag,sof,eof,data,row,col[5:0]
wire                                                               rescan_rvalid           ;
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     rescan_rdata            ;


wire                                                               func_frame_vld          ;
wire                                                               func_frame_rdy          ;
wire     [FRAME_WIDTH-1:0]                                         func_frame_data         ;//rw_flag,sof,eof,data,row,col
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     func_rdata              ;
wire                                                               func_rvalid             ;

wire                                                               dram_init_frame_vld     ;
wire                                                               dram_init_frame_rdy     ;
wire     [FRAME_WIDTH-2:0]                                         dram_init_frame_data    ;//rw_flag,sof,eof,data,row,col
 
wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             remap_wl_addr           ;
wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             remap_csl_addr          ;

wire                                                               mc_rf_cfg_sel_tmp       ;
wire                                                               hang_timeout_en         ;
wire                                                               hang_timeout_en_tmp     ;
wire                                                               global_mc_bist_en_tmp   ;
wire                                                               global_rf_sel_en_tmp    ;
wire                                                               global_mc_bist_start_tmp;
wire                                                               global_mc_rescan_start_tmp;
wire                                                               global_bist_clr_tmp     ;
wire                                                               mc_bist_csl_vmc_en_tmp  ;
wire                                                               mc_rf_period_sel_tmp    ;
wire                                                               mc_rf_start_sel_tmp     ;
wire                                                               mc_en                   ;
wire                                                               mc_wl_vmc_en            ;
wire                                                               mc_bl_vmc_en            ;
wire                                                               mc_wl_vmc_en_tmp        ;
wire                                                               mc_bl_vmc_en_tmp        ;

wire                                                               bist_finish_mask        ;
wire                                                               rescan_finish_mask      ;
wire                                                               mc_en_tmp               ;
wire                                                               bist_finish_mask_tmp    ;
wire                                                               rescan_finish_mask_tmp  ;

wire                                                               mc_timeout_clr          ;
wire                                                               bist_finish_clr         ;
wire                                                               rescan_finish_clr  ;
wire                                                               hang_timeout_clr        ;

wire                                                               mc_timeout_clr_tmp      ;
wire                                                               rescan_finish_clr_tmp   ;
wire                                                               bist_finish_clr_tmp     ;
wire                                                               hang_timeout_clr_tmp    ;
wire                                                               mc_scan_timeout_en_tmp  ;

wire                                                               rf_range_change_en_tmp  ;
wire                                                               pre_precharge_tmp       ;
wire                                                               hang_timeout_mask_tmp   ;
wire                                                               page_mode_switch_tmp    ;
wire       [31:0]                                                  hang_timeout_th         ;

wire                                                               rf_req                  ;
wire       [4:0]                                                   array_fsm_cs            ;
wire       [4:0]                                                   array_fsm_ns            ;

wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              rf_start_raddr          ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              rf_end_raddr            ;
wire                                                               mc_rf_cfg_sel           ;
wire                                                               hang_timeout_mask       ;
//wire                                                               bank_success            ;
wire                                                               mc_bist_en              ;
wire                                                               mc_page_status          ;
wire                                                               hang_timeout_status     ;
wire                                                               inner_precharge         ;
wire       [2:0]                                                   bist_scan_status        ;
wire                                                               clk_bist                ;
wire       [19:0]                                                  bist_rescan_fail_num    ;
wire                                                               dram_init_finish        ;   
//wire                                                               hub_frame_rdy_tmp       ;
wire       [6:0]                                                   err_wl_cnt              ;

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
wire                                                               err_wl_cnt_change_flag  ;
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
wire                                                               mc_rdrdy_n_en_tmp              ;
wire                                                               rdrdy_n_monitor                ;
wire       [68*32-1:0]                                             bist_pattern_all               ;
wire                                                               dram_init_working              ;
wire                                                               rf_burst_split_en              ;
wire                                                               rf_burst_split_en_tmp          ;
wire                                                               mc_ecc_ce_int_clr_inner        ;
wire                                                               mc_ecc_uce_int_clr_inner       ;
wire                                                               mc_ecc_ce_int_mask_o           ;
wire                                                               mc_ecc_uce_int_mask_o          ;


assign rf_end_raddr = rf_addr[ARRAY_ROW_ADDR_WIDTH-1:0];
assign rf_start_raddr = rf_addr[ARRAY_ROW_ADDR_WIDTH*2-1:ARRAY_ROW_ADDR_WIDTH];

assign bist_working = (|bist_scan_status) || rescan_working ;
//assign hub_frame_rdy = global_dram_init_en ? hub_frame_rdy_tmp && dram_init_finish :  hub_frame_rdy_tmp;

//--------------------------------------signal sync start-------------------------------
DW_sync #(
        .width         (11             ),
        .f_sync_type   (2              ),
        .tst_mode      (0              ),
        .verif_en      (1              )
        )U0_mc_ctrl_DW_sync( 
        .clk_d         (clk                                                                             ),
        .rst_d_n       (rst_n                                                                           ),
        .init_d_n      (1'b1                                                                            ),
        .data_s        ({mc_rf_cfg_sel,mc_wl_vmc_en,mc_bl_vmc_en,global_rf_cnt_clr,global_rf_sel_en,
                        global_mc_bist_en,mc_rf_period_sel,mc_rf_start_sel,rf_range_change_en,pre_precharge,page_mode_switch}  ),
        .test          (1'b0                                                                            ),
        .data_d        ({mc_rf_cfg_sel_tmp,mc_wl_vmc_en_tmp,mc_bl_vmc_en_tmp,global_rf_cnt_clr_tmp,global_rf_sel_en_tmp,
                        global_mc_bist_en_tmp,mc_rf_period_sel_tmp,mc_rf_start_sel_tmp,rf_range_change_en_tmp,pre_precharge_tmp,page_mode_switch_tmp} )
        ); 

DW_sync #(
        .width         (8             ),
        .f_sync_type   (2              ),
        .tst_mode      (0              ),
        .verif_en      (1              )
        )U1_mc_ctrl_DW_sync( 
        .clk_d         (clk                                                                                                      ),
        .rst_d_n       (rst_n                                                                                                    ),
        .init_d_n      (1'b1                                                                                                     ),
        .data_s        ({mc_en,bist_finish_mask,rescan_finish_mask,mc_csl_scan_check_sel,global_dram_init_en,
                         mc_bist_csl_vmc_en,mc_rdata_invert_sel,rf_burst_split_en}                                                                 ),
        .test          (1'b0                                                                                                     ),
        .data_d        ({mc_en_tmp,bist_finish_mask_tmp,rescan_finish_mask_tmp,mc_csl_scan_check_sel_tmp,global_dram_init_en_tmp,
                        mc_bist_csl_vmc_en_tmp,mc_rdata_invert_sel_tmp,rf_burst_split_en_tmp}                                                          )
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
        .data_s        ({mc_scan_timeout_en,hang_timeout_mask,hang_timeout_en,mc_rescan_addr_range_sel,mc_csl_scan_addr_range_sel,csl_scan_mode_sel,mc_rdrdy_n_en}),
        .test          (1'b0                                                                                                   ),
        .data_d        ({mc_scan_timeout_en_tmp,hang_timeout_mask_tmp,hang_timeout_en_tmp,mc_rescan_addr_range_sel_tmp,mc_csl_scan_addr_range_sel_tmp,csl_scan_mode_sel_tmp,mc_rdrdy_n_en_tmp})
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
    )ecc_ce_int_clr_sync(
      //-------------clock_1 domain -------------------------------
        .clk1  (apb_clk                 ),
        .rst1_n(apb_rst_n               ),
        .in    (mc_ecc_ce_int_clr_inner ),
      //-------------clock_2 domain -------------------------------
        .clk2  (clk                     ),
        .rst2_n(rst_n                   ),
        .out   (mc_ecc_ce_int_clr       ) 
    );


pulse2pulse_aux#(
        .IN_RST_VALUE (1'b0),  
        .SPREAD_NUM   (6'd4),
        .OUT_RST_VALUE(1'b0)
    )ecc_uce_int_clr_sync(
      //-------------clock_1 domain -------------------------------
        .clk1  (apb_clk                 ),
        .rst1_n(apb_rst_n               ),
        .in    (mc_ecc_uce_int_clr_inner ),
      //-------------clock_2 domain -------------------------------
        .clk2  (clk                     ),
        .rst2_n(rst_n                   ),
        .out   (mc_ecc_uce_int_clr       ) 
    );


DW_sync #(
        .width         (2             ),
        .f_sync_type   (2              ),
        .tst_mode      (0              ),
        .verif_en      (1              )
        )ecc_mask_sync( 
        .clk_d         (clk                                         ),
        .rst_d_n       (rst_n                                       ),
        .init_d_n      (1'b1                                        ),
        .data_s        ({mc_ecc_ce_int_mask_o,mc_ecc_uce_int_mask_o}),
        .test          (1'b0                                        ),
        .data_d        ({mc_ecc_ce_int_mask,mc_ecc_uce_int_mask}    )
        );






//--------------------------------------signal sync done-------------------------------
apb2reg_mc_top_aux_cfg_if #(
    .APB_ADDR_WIDTH (APB_ADDR_WIDTH),
    .APB_DATA_WIDTH (APB_DATA_WIDTH)
)apb2reg_mc_soc_top_cfg_if_u(
// common input ports 
          .pclk                      (apb_clk           ),
          .presetn                   (apb_rst_n         ),
          .psel                      (soc_apb_sel       ),
          .penable                   (soc_apb_enable    ),
          .paddr                     (soc_apb_addr      ),
          .pwrite                    (soc_apb_write     ),
          .pwdata                    (soc_apb_wdata     ),
          .mc_id_i                   (mc_id_soc         ),// read only signal
          .dbg_next_state_array_i    (dbg_next_state    ),// read only signal
          .dbg_current_state_array_i (dbg_current_state ),// read only signal
          .dbg_r_data_cnt_i          (dbg_r_data_cnt    ),// read only signal
          .dbg_refresh_flag_i        (dbg_refresh_flag  ),// read only signal
          .dbg_r_frame_cnt_i         (dbg_r_frame_cnt   ),// read only signal
          .dbg_w_frame_cnt_i         (dbg_w_frame_cnt   ),// read only signal
          .mc_timeout_flag_i         (mc_timeout_flag   ),// read only signal
          .bist_finish_i             (bist_finish       ),// read only signal
          .bist_rescan_success_i     (bist_rescan_success),
          .bank_success_i            (bank_success      ),// read only signal
          .err_csl0_part0_i          (err_csl0_part0    ),// read only signal
          .err_csl1_part0_i          (err_csl1_part0    ),// read only signal
          .err_csl0_part1_i          (err_csl0_part1    ),// read only signal
          .err_csl1_part1_i          (err_csl1_part1    ),// read only signal
          .err_csl0_part2_i          (err_csl0_part2    ),// read only signal
          .err_csl1_part2_i          (err_csl1_part2    ),// read only signal
          .err_csl0_part3_i          (err_csl0_part3    ),// read only signal
          .err_csl1_part3_i          (err_csl1_part3    ),// read only signal
          .err_csl0_part4_i          (err_csl0_part4    ),// read only signal
          .err_csl1_part4_i          (err_csl1_part4    ),// read only signal
          .err_csl0_part5_i          (err_csl0_part5    ),// read only signal
          .err_csl1_part5_i          (err_csl1_part5    ),// read only signal
          .err_csl0_part6_i          (err_csl0_part6    ),// read only signal
          .err_csl1_part6_i          (err_csl1_part6    ),// read only signal
          .err_csl0_part7_i          (err_csl0_part7    ),// read only signal
          .err_csl1_part7_i          (err_csl1_part7    ),// read only signal
          .err_csl0_part8_i          (err_csl0_part8    ),// read only signal
          .err_csl1_part8_i          (err_csl1_part8    ),// read only signal
          .err_csl0_part9_i          (err_csl0_part9    ),// read only signal
          .err_csl1_part9_i          (err_csl1_part9    ),// read only signal


          .err_wl0_i                 (err_wl0           ),// read only signal
          .err_wl1_i                 (err_wl1           ),// read only signal
          .err_wl2_i                 (err_wl2           ),// read only signal
          .err_wl3_i                 (err_wl3           ),// read only signal
          .err_wl4_i                 (err_wl4           ),// read only signal
          .err_wl5_i                 (err_wl5           ),// read only signal
          .err_wl6_i                 (err_wl6           ),// read only signal
          .err_wl7_i                 (err_wl7           ),// read only signal
          .err_wl8_i                 (err_wl8           ),// read only signal
          .err_wl9_i                 (err_wl9           ),// read only signal
          .err_wl10_i                (err_wl10          ),// read only signal
          .err_wl11_i                (err_wl11          ),// read only signal
          .err_wl12_i                (err_wl12          ),// read only signal
          .err_wl13_i                (err_wl13          ),// read only signal
          .err_wl14_i                (err_wl14          ),// read only signal
          .err_wl15_i                (err_wl15          ),// read only signal
          .err_wl16_i                (err_wl16          ),// read only signal
          .err_wl17_i                (err_wl17          ),// read only signal
          .err_wl18_i                (err_wl18          ),// read only signal
          .err_wl19_i                (err_wl19          ),// read only signal
          .err_wl20_i                (err_wl20          ),// read only signal
          .err_wl21_i                (err_wl21          ),// read only signal
          .err_wl22_i                (err_wl22          ),// read only signal
          .err_wl23_i                (err_wl23          ),// read only signal
          .err_wl24_i                (err_wl24          ),// read only signal
          .err_wl25_i                (err_wl25          ),// read only signal
          .err_wl26_i                (err_wl26          ),// read only signal
          .err_wl27_i                (err_wl27          ),// read only signal
          .err_wl28_i                (err_wl28          ),// read only signal
          .err_wl29_i                (err_wl29          ),// read only signal
          .err_wl30_i                (err_wl30          ),// read only signal
          .err_wl31_i                (err_wl31          ),// read only signal
          .err_wl32_i                (err_wl32          ),// read only signal
          .err_wl33_i                (err_wl33          ),// read only signal
          .err_wl34_i                (err_wl34          ),// read only signal
          .err_wl35_i                (err_wl35          ),// read only signal
          .err_wl36_i                (err_wl36          ),// read only signal
          .err_wl37_i                (err_wl37          ),// read only signal
          .err_wl38_i                (err_wl38          ),// read only signal
          .err_wl39_i                (err_wl39          ),// read only signal
          .err_wl40_i                (err_wl40          ),// read only signal
          .err_wl41_i                (err_wl41          ),// read only signal
          .err_wl42_i                (err_wl42          ),// read only signal
          .err_wl43_i                (err_wl43          ),// read only signal
          .err_wl44_i                (err_wl44          ),// read only signal
          .err_wl45_i                (err_wl45          ),// read only signal
          .err_wl46_i                (err_wl46          ),// read only signal
          .err_wl47_i                (err_wl47          ),// read only signal
          .err_wl48_i                (err_wl48          ),// read only signal
          .err_wl49_i                (err_wl49          ),// read only signal
          .err_wl50_i                (err_wl50          ),// read only signal
          .err_wl51_i                (err_wl51          ),// read only signal
          .err_wl52_i                (err_wl52          ),// read only signal
          .err_wl53_i                (err_wl53          ),// read only signal
          .err_wl54_i                (err_wl54          ),// read only signal
          .err_wl55_i                (err_wl55          ),// read only signal
          .err_wl56_i                (err_wl56          ),// read only signal
          .err_wl57_i                (err_wl57          ),// read only signal
          .err_wl58_i                (err_wl58          ),// read only signal
          .err_wl59_i                (err_wl59          ),// read only signal
          .err_wl60_i                (err_wl60          ),// read only signal
          .err_wl61_i                (err_wl61          ),// read only signal
          .err_wl62_i                (err_wl62          ),// read only signal
          .err_wl63_i                (err_wl63          ),// read only signal
          
          .mc_timeout_clr_o          (mc_timeout_clr    ),
          .bist_finish_clr_o         (bist_finish_clr   ),
          
          .mc_en_o                   (mc_en             ),
          .mc_rf_cfg_sel_o           (mc_rf_cfg_sel     ),
          .mc_debug_en_o             (mc_debug_en       ),
          .mc_wl_vmc_en_o            (mc_wl_vmc_en      ),
          .mc_bl_vmc_en_o            (mc_bl_vmc_en      ),
          .mc_bist_en_o              (mc_bist_en        ),
          .mc_rdrdy_n_en_o           (mc_rdrdy_n_en     ),
          .mc_rescan_addr_range_sel_o  (mc_rescan_addr_range_sel  ),
          .mc_csl_scan_addr_range_sel_o(mc_csl_scan_addr_range_sel),
          .mc_csl_scan_check_sel_o     (mc_csl_scan_check_sel     ),
          .mc_rdata_invert_sel_o       (mc_rdata_invert_sel       ),
          .mc_rf_burst_split_en_o    (rf_burst_split_en ),
          .bank_radd_set_time_o      (bank_radd_set_time),
          .cadd_set_time_o           (cadd_set_time     ),
          .r_cas_set_time_o          (r_cas_set_time    ),
          .w_cas_set_time_o          (w_cas_set_time    ),
          //.cas_wrrdy_time_o          (cas_wrrdy_time    ),
          .mc_rf_period_1_o          (mc_rf_period_1    ),
          .mc_rf_start_1_o           (mc_rf_start_1     ),
          .mc_rf_period_2_o          (mc_rf_period_2    ),
          .mc_rf_start_2_o           (mc_rf_start_2     ),
          .mc_vmc_wl_num0_o          (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num1_o          (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num2_o          (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num3_o          (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num4_o          (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*4 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num5_o          (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*5 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num6_o          (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*6 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num7_o          (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*7 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num8_o          (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*8 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num9_o          (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*9 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num10_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*10 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num11_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*11 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num12_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*12 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num13_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*13 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num14_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*14 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num15_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*15 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num16_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*16 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num17_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*17 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num18_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*18 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num19_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*19 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num20_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*20 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num21_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*21 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num22_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*22 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num23_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*23 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num24_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*24 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num25_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*25 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num26_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*26 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num27_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*27 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num28_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*28 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num29_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*29 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num30_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*30 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num31_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*31 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num32_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*32 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num33_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*33 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num34_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*34 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num35_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*35 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num36_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*36 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num37_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*37 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num38_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*38 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num39_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*39 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num40_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*40 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num41_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*41 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num42_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*42 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num43_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*43 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num44_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*44 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num45_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*45 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num46_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*46 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num47_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*47 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num48_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*48 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num49_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*49 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num50_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*50 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num51_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*51 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num52_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*52 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num53_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*53 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num54_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*54 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num55_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*55 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num56_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*56 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num57_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*57 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num58_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*58 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num59_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*59 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num60_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*60 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num61_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*61 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num62_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*62 +: ARRAY_ROW_ADDR_WIDTH]),
          .mc_vmc_wl_num63_o         (remap_wl_addr[ARRAY_ROW_ADDR_WIDTH*63 +: ARRAY_ROW_ADDR_WIDTH]),
          
          .mc_vmc_bl_num0_part0_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part0_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part1_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part1_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part2_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*4 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part2_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*5 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part3_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*6 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part3_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*7 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part4_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*8 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part4_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*9 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part5_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*10 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part5_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*11 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part6_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*12 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part6_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*13 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part7_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*14 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part7_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*15 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part8_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*16 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part8_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*17 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num0_part9_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*18 +: ARRAY_COL_ADDR_WIDTH]),
          .mc_vmc_bl_num1_part9_o    (remap_csl_addr[ARRAY_COL_ADDR_WIDTH*19 +: ARRAY_COL_ADDR_WIDTH]),

          .mc_rf_start_dbg_i         (mc_rf_start                ),
          .mc_bist_status_i          (bist_scan_status           ),
          .mc_bist_path_fail_i       (bist_bank_finish           ),
          .dram_init_finish_i        (dram_init_finish           ),
          .mc_bist_rescan_fail_num_i (bist_rescan_fail_num       ),
          .mc_bist_err_wl_num_i      (err_wl_cnt                 ),
          .err_wl_num_change_flag_i  (err_wl_cnt_change_flag     ),
          .bist_rescan_finish_i      (bist_rescan_finish_status  ),
          //.bist_rescan_finish_ras_i  (bist_rescan_finish_status_ras),
          .bist_pattern_reg0_o       (bist_pattern_reg0          ),
          .bist_pattern_reg1_o       (bist_pattern_reg1          ),
          .bist_pattern_reg2_o       (bist_pattern_reg2          ),
          .bist_pattern_reg3_o       (bist_pattern_reg3          ),
          .csl_bist_pattern_sel0_o   (csl_bist_pattern_sel0      ),
          .csl_bist_pattern_sel1_o   (csl_bist_pattern_sel1      ),
          .csl_bist_pattern_sel2_o   (csl_bist_pattern_sel2      ),

          .wl_bist_pattern_sel0_o    (wl_bist_pattern_sel0       ),
          .wl_bist_pattern_sel1_o    (wl_bist_pattern_sel1       ),
          .wl_bist_pattern_sel2_o    (wl_bist_pattern_sel2       ),

          .mc_csl_scan_mode_sel_o    (csl_scan_mode_sel          ),

          .bist_finish_mask_o        (bist_finish_mask           ),
          .rescan_finish_mask_o      (rescan_finish_mask         ),
          .rescan_finish_clr_o       (rescan_finish_clr          ),
          .rescan_round_result_i     (rescan_round_result        ),

          .hang_timeout_th_o         (hang_timeout_th            ),
          //dbg data store beginmc_ecc_ce_int_mask_o
          .dbg_frame_store_0_i       (dbg_store_latest_frame[0*32+:32] ),
          .dbg_frame_store_1_i       (dbg_store_latest_frame[1*32+:32] ),
          .dbg_frame_store_2_i       (dbg_store_latest_frame[2*32+:32] ),
          .dbg_frame_store_3_i       (dbg_store_latest_frame[3*32+:32] ),
          .dbg_frame_store_4_i       (dbg_store_latest_frame[4*32+:32] ),
          .dbg_frame_store_5_i       (dbg_store_latest_frame[5*32+:32] ),
          .dbg_frame_store_6_i       (dbg_store_latest_frame[6*32+:32] ),
          .dbg_frame_store_7_i       (dbg_store_latest_frame[7*32+:32] ),
          .dbg_frame_store_8_i       (dbg_store_latest_frame[8*32+:32] ),
          .dbg_frame_store_9_i       (dbg_store_latest_frame[9*32+:2]  ),
          .dbg_rdata_store_0_i       (dbg_store_latest_rdata[0*32+:32] ),
          .dbg_rdata_store_1_i       (dbg_store_latest_rdata[1*32+:32] ),
          .dbg_rdata_store_2_i       (dbg_store_latest_rdata[2*32+:32] ),
          .dbg_rdata_store_3_i       (dbg_store_latest_rdata[3*32+:32] ),
          .dbg_rdata_store_4_i       (dbg_store_latest_rdata[4*32+:32] ),
          .dbg_rdata_store_5_i       (dbg_store_latest_rdata[5*32+:32] ),
          .dbg_rdata_store_6_i       (dbg_store_latest_rdata[6*32+:32] ),
          .dbg_rdata_store_7_i       (dbg_store_latest_rdata[7*32+:32] ),
          .dbg_rdata_store_8_i       (dbg_store_latest_rdata[8*32+:10] ),
          .mc_page_status_i          (mc_page_status    ),// read only signal
          .hang_timeout_status_i     (hang_timeout_status),
          .hang_timeout_mask_o       (hang_timeout_mask ),
          .hang_timeout_clr_o        (hang_timeout_clr  ),
          .hang_timeout_en_o         (hang_timeout_en   ),

          //dbg data store end
          .prdata                    (soc_apb_rdata              ),
          //.pslverr                   (soc_apb_pslverr            ),
          .mc_ecc_ce_overflow_int_i  (mc_ecc_ce_overflow_int      ),
          .mc_ecc_ce_cnt_i           (mc_ecc_ce_cnt               ),
          .mc_ecc_ce_addr0_i         (mc_ecc_ce_addr[0*22+:22]    ),
          .mc_ecc_ce_addr_vld0_i     (mc_ecc_ce_addr_vld[0]       ),
          .mc_ecc_ce_addr1_i         (mc_ecc_ce_addr[1*22+:22]    ),
          .mc_ecc_ce_addr_vld1_i     (mc_ecc_ce_addr_vld[1]       ),
          .mc_ecc_ce_addr2_i         (mc_ecc_ce_addr[2*22+:22]    ),
          .mc_ecc_ce_addr_vld2_i     (mc_ecc_ce_addr_vld[2]       ),
          .mc_ecc_ce_addr3_i         (mc_ecc_ce_addr[3*22+:22]    ),
          .mc_ecc_ce_addr_vld3_i     (mc_ecc_ce_addr_vld[3]       ),
          .mc_ecc_ce_addr4_i         (mc_ecc_ce_addr[4*22+:22]    ),
          .mc_ecc_ce_addr_vld4_i     (mc_ecc_ce_addr_vld[4]       ),
          .mc_ecc_ce_addr5_i         (mc_ecc_ce_addr[5*22+:22]    ),
          .mc_ecc_ce_addr_vld5_i     (mc_ecc_ce_addr_vld[5]       ),
          .mc_ecc_ce_addr6_i         (mc_ecc_ce_addr[6*22+:22]    ),
          .mc_ecc_ce_addr_vld6_i     (mc_ecc_ce_addr_vld[6]       ),
          .mc_ecc_ce_addr7_i         (mc_ecc_ce_addr[7*22+:22]    ),
          .mc_ecc_ce_addr_vld7_i     (mc_ecc_ce_addr_vld[7]       ),
          .mc_ecc_ce_addr8_i         (mc_ecc_ce_addr[8*22+:22]    ),
          .mc_ecc_ce_addr_vld8_i     (mc_ecc_ce_addr_vld[8]       ),
          .mc_ecc_ce_addr9_i         (mc_ecc_ce_addr[9*22+:22]    ),
          .mc_ecc_ce_addr_vld9_i     (mc_ecc_ce_addr_vld[9]       ),
          .mc_ecc_ce_addr10_i        (mc_ecc_ce_addr[10*22+:22]   ),
          .mc_ecc_ce_addr_vld10_i    (mc_ecc_ce_addr_vld[10]      ),
          .mc_ecc_ce_addr11_i        (mc_ecc_ce_addr[11*22+:22]   ),
          .mc_ecc_ce_addr_vld11_i    (mc_ecc_ce_addr_vld[11]      ),
          .mc_ecc_ce_addr12_i        (mc_ecc_ce_addr[12*22+:22]   ),
          .mc_ecc_ce_addr_vld12_i    (mc_ecc_ce_addr_vld[12]      ),
          .mc_ecc_ce_addr13_i        (mc_ecc_ce_addr[13*22+:22]   ),
          .mc_ecc_ce_addr_vld13_i    (mc_ecc_ce_addr_vld[13]      ),
          .mc_ecc_ce_addr14_i        (mc_ecc_ce_addr[14*22+:22]   ),
          .mc_ecc_ce_addr_vld14_i    (mc_ecc_ce_addr_vld[14]      ),
          .mc_ecc_ce_addr15_i        (mc_ecc_ce_addr[15*22+:22]   ),
          .mc_ecc_ce_addr_vld15_i    (mc_ecc_ce_addr_vld[15]      ),
          .mc_ecc_uce_int_i          (mc_ecc_uce_int              ),
          .mc_ecc_uce_cnt_i          (mc_ecc_uce_cnt              ),
          .mc_ecc_uce_addr0_i        (mc_ecc_uce_addr[0*22+:22]   ),
          .mc_ecc_uce_addr_vld0_i    (mc_ecc_uce_addr_vld[0]      ),
          .mc_ecc_uce_addr1_i        (mc_ecc_uce_addr[1*22+:22]   ),
          .mc_ecc_uce_addr_vld1_i    (mc_ecc_uce_addr_vld[1]      ),
          .mc_ecc_uce_addr2_i        (mc_ecc_uce_addr[2*22+:22]   ),
          .mc_ecc_uce_addr_vld2_i    (mc_ecc_uce_addr_vld[2]      ),
          .mc_ecc_uce_addr3_i        (mc_ecc_uce_addr[3*22+:22]   ),
          .mc_ecc_uce_addr_vld3_i    (mc_ecc_uce_addr_vld[3]      ),
          .mc_ecc_ce_th_o            (mc_ecc_ce_th                ),
          .mc_ecc_ce_int_clr_o       (mc_ecc_ce_int_clr_inner     ),
          .mc_ecc_uce_int_clr_o      (mc_ecc_uce_int_clr_inner    ),
          .mc_ecc_en_o               (mc_ecc_en                   ),
          .mc_ecc_ce_int_mask_o      (mc_ecc_ce_int_mask_o        ),
          .mc_ecc_uce_int_mask_o     (mc_ecc_uce_int_mask_o       )
    );

assign soc_apb_pslverr = 'd0;
//apb2reg_mc_pe_top_aux_cfg_if #(
//          .APB_ADDR_WIDTH (APB_ADDR_WIDTH),
//          .APB_DATA_WIDTH (APB_DATA_WIDTH)
//)apb2reg_mc_pe_top_cfg_if_u(
//          // common input ports 
//          .pclk                      (apb_clk           ),
//          .presetn                   (apb_rst_n         ),
//          .psel                      (pe_apb_sel        ),
//          .penable                   (pe_apb_enable     ),
//          .paddr                     (pe_apb_addr       ),
//          .pwrite                    (pe_apb_write      ),
//          .pwdata                    (pe_apb_wdata      ),
//          
//          .mc_id_i                   (mc_id_pe          ),// read only signal
//          .mc_page_status_i          (mc_page_status    ),// read only signal
//          
//          .hang_timeout_status_i     (hang_timeout_status),
//          .hang_timeout_mask_o       (hang_timeout_mask ),
//          .hang_timeout_clr_o        (hang_timeout_clr  ),
//          .hang_timeout_en_o         (hang_timeout_en   ),
//
//          .prdata                    (pe_apb_rdata      ),
//          .pslverr                   (pe_apb_pslverr    )
//
//    );


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

bist_scan_aux #(
                .ARRAY_ADDR_WIDTH    (ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH ),
                .CHECKBIT_WIDTH      (CHECKBIT_WIDTH                            ),
                .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH                      ),
                .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH                      ),
                .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH                          )
)bist_scan_u(
  //-------------clock and reset signal--------------
          .clk                                 (clk_bist                          ),
          .rst_n                               (rst_n                             ),
          //.ras_clr                             (ras_clr                           ),
          .global_bist_clr                     (global_bist_clr_tmp               ),
          
          .global_mc_bist_start                (global_mc_bist_start_tmp          ),
          .global_mc_bist_en                   (global_mc_bist_en_tmp             ),
          .mc_bist_en                          (mc_bist_en                        ),
          .bist_csl_vmc_en                     (mc_bist_csl_vmc_en_tmp            ),
          .csl_scan_addr_range_sel             (mc_csl_scan_addr_range_sel_tmp    ),//default 1,scan all addr
          .csl_scan_check_sel                  (mc_csl_scan_check_sel_tmp         ),//default 1,check 272 bit rdata
          .csl_scan_mode_sel                   (csl_scan_mode_sel_tmp             ),//0:abort 1:continue,default 0
 
          .bist_wl_scan_single_pattern_rd_num  (bist_wl_scan_single_pattern_rd_num),
          .csl_bist_pattern_sel                (csl_bist_pattern_sel              ),
          .wl_bist_pattern_sel                 (wl_bist_pattern_sel               ),
          .bist_pattern_all                    (bist_pattern_all                  ),
          .bist_success                        (bank_success                      ),
          .bist_finish                         (bist_finish                       ),
          .bist_finish_int                     (bist_finish_int                   ),
          .bist_bank_finish                    (bist_bank_finish                  ),
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
          
          .err_csl0_part0                      (err_csl0_part0                    ),
          .err_csl1_part0                      (err_csl1_part0                    ),
          .err_csl0_part1                      (err_csl0_part1                    ),
          .err_csl1_part1                      (err_csl1_part1                    ),
          .err_csl0_part2                      (err_csl0_part2                    ),
          .err_csl1_part2                      (err_csl1_part2                    ),
          .err_csl0_part3                      (err_csl0_part3                    ),
          .err_csl1_part3                      (err_csl1_part3                    ),
          .err_csl0_part4                      (err_csl0_part4                    ),
          .err_csl1_part4                      (err_csl1_part4                    ),
          .err_csl0_part5                      (err_csl0_part5                    ),
          .err_csl1_part5                      (err_csl1_part5                    ),
          .err_csl0_part6                      (err_csl0_part6                    ),
          .err_csl1_part6                      (err_csl1_part6                    ),
          .err_csl0_part7                      (err_csl0_part7                    ),
          .err_csl1_part7                      (err_csl1_part7                    ),
          .err_csl0_part8                      (err_csl0_part8                    ),
          .err_csl1_part8                      (err_csl1_part8                    ),
          .err_csl0_part9                      (err_csl0_part9                    ),
          .err_csl1_part9                      (err_csl1_part9                    ),

          
          .err_wl0                             (err_wl0                           ),
          .err_wl1                             (err_wl1                           ),
          .err_wl2                             (err_wl2                           ),
          .err_wl3                             (err_wl3                           ),
          .err_wl4                             (err_wl4                           ),
          .err_wl5                             (err_wl5                           ),
          .err_wl6                             (err_wl6                           ),
          .err_wl7                             (err_wl7                           ),
          .err_wl8                             (err_wl8                           ),
          .err_wl9                             (err_wl9                           ),
          .err_wl10                            (err_wl10                          ),
          .err_wl11                            (err_wl11                          ),
          .err_wl12                            (err_wl12                          ),
          .err_wl13                            (err_wl13                          ),
          .err_wl14                            (err_wl14                          ),
          .err_wl15                            (err_wl15                          ),
          .err_wl16                            (err_wl16                          ),
          .err_wl17                            (err_wl17                          ),
          .err_wl18                            (err_wl18                          ),
          .err_wl19                            (err_wl19                          ),
          .err_wl20                            (err_wl20                          ),
          .err_wl21                            (err_wl21                          ),
          .err_wl22                            (err_wl22                          ),
          .err_wl23                            (err_wl23                          ),
          .err_wl24                            (err_wl24                          ),
          .err_wl25                            (err_wl25                          ),
          .err_wl26                            (err_wl26                          ),
          .err_wl27                            (err_wl27                          ),
          .err_wl28                            (err_wl28                          ),
          .err_wl29                            (err_wl29                          ),
          .err_wl30                            (err_wl30                          ),
          .err_wl31                            (err_wl31                          ),
          .err_wl32                            (err_wl32                          ),
          .err_wl33                            (err_wl33                          ),
          .err_wl34                            (err_wl34                          ),
          .err_wl35                            (err_wl35                          ),
          .err_wl36                            (err_wl36                          ),
          .err_wl37                            (err_wl37                          ),
          .err_wl38                            (err_wl38                          ),
          .err_wl39                            (err_wl39                          ),
          .err_wl40                            (err_wl40                          ),
          .err_wl41                            (err_wl41                          ),
          .err_wl42                            (err_wl42                          ),
          .err_wl43                            (err_wl43                          ),
          .err_wl44                            (err_wl44                          ),
          .err_wl45                            (err_wl45                          ),
          .err_wl46                            (err_wl46                          ),
          .err_wl47                            (err_wl47                          ),
          .err_wl48                            (err_wl48                          ),
          .err_wl49                            (err_wl49                          ),
          .err_wl50                            (err_wl50                          ),
          .err_wl51                            (err_wl51                          ),
          .err_wl52                            (err_wl52                          ),
          .err_wl53                            (err_wl53                          ),
          .err_wl54                            (err_wl54                          ),
          .err_wl55                            (err_wl55                          ),
          .err_wl56                            (err_wl56                          ),
          .err_wl57                            (err_wl57                          ),
          .err_wl58                            (err_wl58                          ),
          .err_wl59                            (err_wl59                          ),
          .err_wl60                            (err_wl60                          ),
          .err_wl61                            (err_wl61                          ),
          .err_wl62                            (err_wl62                          ),
          .err_wl63                            (err_wl63                          ),
          .err_wl_cnt                          (err_wl_cnt                        ),
          .err_wl_cnt_change_flag              (err_wl_cnt_change_flag            )
          

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

                .rf_burst_split_en   (rf_burst_split_en_tmp),
                
                .pre_precharge       (pre_precharge_tmp    ),//pre precharge en
                .inner_precharge     (inner_precharge      ),
                .page_mode_switch    (page_mode_switch_tmp ),//1:open page,0:close page
                .mc_page_status      (mc_page_status       ),
                .rf_req              (rf_req               ),
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
                .array_rdata         (func_rdata           )

);

bist_rescan_aux #(
                .ARRAY_ADDR_WIDTH    (ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH ),
                .CHECKBIT_WIDTH      (CHECKBIT_WIDTH                            ),
                .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH                      ),
                .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH                      ),
                .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH                          )
            )U_bist_rescan_aux(
  //-------------clock and reset signal--------------
                .clk                      (clk_bist            ),
                .rst_n                    (rst_n               ),
                .bist_rescan_sel          (mc_rescan_addr_range_sel_tmp  ),
                                          
                .global_mc_bist_en        (global_mc_bist_en_tmp),
                .global_mc_rescan_start   (global_mc_rescan_start_tmp    ),//default 0
                .mc_bist_en               (mc_bist_en          ),
                			              
                .bist_rescan_num          (bist_rescan_num     ),//default 3
                //.bist_wl_scan_num         (bist_wl_scan_num   ),
                .wl_bist_pattern_sel      (wl_bist_pattern_sel ),
                .bist_pattern_all         (bist_pattern_all    ),
                .bist_rescan_fail_num     (bist_rescan_fail_num),
                .rescan_round_result      (rescan_round_result ),
                                															              
                .bist_rescan_success      (bist_rescan_success ),
                .bist_rescan_finish       (bist_rescan_finish  ),
                .bist_rescan_finish_status(bist_rescan_finish_status    ),
                .rescan_finish_clr        (rescan_finish_clr_tmp ),
                .rescan_finish_mask       (rescan_finish_mask_tmp),
                .rescan_working           (rescan_working     ),
                                          
                .rescan_frame_vld         (rescan_frame_vld    ),
                .rescan_frame_rdy         (rescan_frame_rdy    ),
                .rescan_frame_data        (rescan_frame_data   ),//rw_flag,sof,eof,data,row,col
                .rescan_rvalid            (rescan_rvalid       ),
                .rescan_rdata             (rescan_rdata        )
);


dram_init_wr_aux #(
                .ROW_ADDR_WIDTH           (ARRAY_ROW_ADDR_WIDTH  ),
                .COL_ADDR_WIDTH           (ARRAY_COL_ADDR_WIDTH  ),
                .WL_NUM                   (7360                  ),
                .CHECKBIT_WIDTH           (CHECKBIT_WIDTH        ),
                .FRAME_WIDTH              (ARRAY_COL_ADDR_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+3)
)dram_init_wr_aux_u(
  
                .clk                      (clk                    ),
                .rst_n                    (rst_n                  ),
                //.ras_clr                (ras_clr          ),
                .global_dram_init_en      (global_dram_init_en_tmp),
                .mc_dram_init_en          (mc_en_tmp              ),										
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
               .TDATA_WIDTH         (ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+3+1),//256bit data,10bit checkbit,21bit addr
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


vmc_top_aux #(
                .ARRAY_ROW_ADDR_WIDTH (ARRAY_ROW_ADDR_WIDTH),
                .ARRAY_COL_ADDR_WIDTH (ARRAY_COL_ADDR_WIDTH),
                .CHECKBIT_WIDTH       (CHECKBIT_WIDTH      ),
                .ARRAY_DATA_WIDTH     (ARRAY_DATA_WIDTH    ),
                .WL_NUM               (7360                 ),
                .FRAME_WIDTH          (FRAME_WIDTH         )
)vmc_top_aux_u(
                .vmc_wl_en            (mc_wl_vmc_en_tmp    ),
                .remap_wl_addr        (remap_wl_addr       ),//64
                .vmc_bl_en            (mc_bl_vmc_en_tmp    ),
                .remap_csl_addr       (remap_csl_addr      ),//2,[ARRAY_COL_ADDR_WIDTH*2-1:0]:part0,lsb
                
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
        .FRAME_WIDTH           (FRAME_WIDTH                )
)mc_timeout_u(
        .clk                   (clk                        ),
        .rst_n                 (rst_n                      ),
        //.ras_clr             (ras_clr                  ),
        .timeout_en            (mc_scan_timeout_en_tmp     ),//initail scan use
        .timeout_clr           (mc_timeout_clr_tmp         ),
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

                


frame2array_aux #(
                .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH    ),
                .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH),
                .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH),
                .CHECKBIT_WIDTH      (CHECKBIT_WIDTH      ),
                .MC_FRAME_WIDTH      (ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+3+1)
        )frame2array_u(
                .clk                   (clk                 ),
                .rst_n                 (rst_n               ),
                .ras_clr               (ras_clr             ),
                .mc_en                 (mc_en_tmp           ),
                .mc_rf_start           (mc_rf_start         ),
                .global_rf_sel_en      (global_rf_sel_en_tmp),
                .global_rf_cnt_clr     (global_rf_cnt_clr_tmp),
                .mc_rdata_invert_sel   (mc_rdata_invert_sel_tmp),
                .mc_rdrdy_n_en         (mc_rdrdy_n_en_tmp   ),
                .global_rf_sel         (global_rf_sel       ),
                .mc_rf_cfg_sel         (mc_rf_cfg_sel_tmp   ),
                .mc_trc_cfg            (mc_trc_cfg          ),
                .mc_tras_cfg           (mc_tras_cfg         ),
                .mc_trp_cfg            (mc_trp_cfg          ),
                .mc_trcd_cfg           (mc_trcd_cfg         ),
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
                .mc_rf_period_sel      (mc_rf_period_sel_tmp ),

                .rf_gear_up_en         (rf_gear_up_en       ),
                .rf_gear_id            (rf_gear_id          ),
                .rf_row_num            (rf_row_num          ),
                .rf_single_interval   (rf_single_interval   )


    );


assign monitor_signals = {
                        75'd0,       
                        hub_frame_data[FRAME_WIDTH-2:FRAME_WIDTH-3],
                        hub_frame_data[1:0],
                        hub_frame_rdy      ,
                        hub_frame_vld      ,
                        mc_rdata[1:0]      ,
                        mc_rvalid          ,
                        bnksel_n           ,
                        gradd_n[1:0]       , 
                        gcas_wr            , 
                        gcas_rd            , 
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
      dbg_store_latest_frame <= {FRAME_WIDTH-2{1'b0}};
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
