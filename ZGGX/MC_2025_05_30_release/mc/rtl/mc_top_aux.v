module mc_top_aux #(
                parameter    APB_DATA_WIDTH       = 32,
                parameter    APB_ADDR_WIDTH       = 12,
                parameter    ARRAY_DATA_WIDTH     = 256,
                parameter    ARRAY_ROW_ADDR_WIDTH = 13,
                parameter    ARRAY_COL_ADDR_WIDTH = 8,
                parameter    PATTERN_WIDTH        = 32,
                parameter    CSL_ERR_TH_WIDTH     = 5,
                parameter    CHECKBIT_WIDTH       = 10,
                parameter    ARRAY_RSV_WIDTH      = 6,
                parameter    FRAME_WIDTH          = 292
        )(

                input                                                               clk                    ,
                input                                                               rst_n                  ,
                input    [31:0]                                                     mc_id_soc              ,

                input                                                               mc_rf_start            ,
                input                                                               global_rf_sel_en       , 
                input                                                               global_rf_sel          ,
                input                                                               global_mc_bist_start   ,
                input                                                               global_mc_bist_en      ,
                input                                                               global_bist_clr        ,
                input                                                               global_mc_rescan_start ,
                input                                                               global_dram_init_en    ,
                input                                                               global_rf_cnt_clr      ,//default 0
                input                                                               mc_bist_csl_vmc_en     ,
                input    [3:0]                                                      bist_rescan_num        ,//default 3,max 8
                output                                                              bist_rescan_success    ,
                output                                                              bist_rescan_finish     ,
                output                                                              bist_rescan_finish_status,

                //output                                                              mc_dram_init_finish ,
                                                 
                output                                                              mc_debug_en            ,
                input                                                               mc_scan_timeout_en     ,
                output                                                              bist_finish_int        ,

                input                                                               rf_range_change_en     ,
                input                                                               pre_precharge          ,
                input                                                               page_mode_switch       ,
                input    [ARRAY_ROW_ADDR_WIDTH*2-1:0]                               rf_addr                ,//{rf_start_addr,rf_end_addr}
                input                                                               dbg_data_store_en      ,//dbg function, store latest frame and rdata
                
                //apb bus
                input                                                               apb_clk                ,
                input                                                               apb_rst_n              ,
                //soc apb bus
                input                                                               soc_apb_sel            ,
                input                                                               soc_apb_enable         ,
                input                                                               soc_apb_write          ,
                input    [APB_ADDR_WIDTH-1:0]                                       soc_apb_addr           ,
                input    [APB_DATA_WIDTH-1:0]                                       soc_apb_wdata          ,
                output   [APB_DATA_WIDTH-1:0]                                       soc_apb_rdata          ,
                output                                                              soc_apb_pslverr        ,
                //array timing cfg
                input    [5:0]                                                      mc_trc_cfg             ,//active to active time
                input    [4:0]                                                      mc_tras_cfg            ,//rcd active to precharge time
                input    [3:0]                                                      mc_trp_cfg             ,//precharge time
                input    [4:0]                                                      mc_trcd_cfg            ,//write rcd time
                input    [0:0]                                                      mc_trtp_cfg            ,//rd cas rising edge to precharge time
                input    [3:0]                                                      mc_twr_cfg             ,//wr cas falling edge to precharge time
                input    [2:0]                                                      mc_twtr_cfg            ,//write cas To Read cas time
                input    [3:0]                                                      mc_trtw_cfg            ,//Read cas To Write cas time
                //bist pattern
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern0          ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern1          ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern2          ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern3          ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern4          ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern5          ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern6          ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern7          ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern8          ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern9          ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern10         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern11         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern12         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern13         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern14         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern15         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern16         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern17         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern18         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern19         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern20         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern21         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern22         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern23         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern24         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern25         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern26         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern27         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern28         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern29         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern30         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern31         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern32         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern33         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern34         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern35         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern36         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern37         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern38         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern39         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern40         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern41         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern42         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern43         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern44         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern45         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern46         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern47         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern48         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern49         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern50         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern51         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern52         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern53         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern54         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern55         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern56         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern57         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern58         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern59         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern60         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern61         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern62         ,
                //input    [PATTERN_WIDTH-1:0]                                        bist_pattern63         ,
                //input    [6:0]                                                      bist_csl_scan_num      ,
                //input    [6:0]                                                      bist_wl_scan_num       ,
                input    [3:0]                                                      bist_wl_scan_single_pattern_rd_num ,//max 16,default 0 :read one time
                input    [CSL_ERR_TH_WIDTH-1:0]                                     csl_err_threshold      ,
                output                                                              bank_success           ,
                //timeout
                input    [31:0]                                                     mc_timeout_th          ,

                //array interface
                output   [1:0]                                                      bnksel_n               , 
                output   [ARRAY_ROW_ADDR_WIDTH-1:0]                                 gradd_n                ,
                output                                                              gcas_wr                ,
                output                                                              gcas_rd                ,
                output   [ARRAY_COL_ADDR_WIDTH-1:0]                                 gcadd                  ,
                //output                                                            wrrdy_n                ,
                output   [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_RSV_WIDTH-1:0]      wdl                    ,
                output                                                              wdl_oe                 ,
                input                                                               rdrdy_n                ,
                input    [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_RSV_WIDTH-1:0]      rdl                    ,
                //hub to mc frame
                input                                                               hub_frame_vld          ,
                output                                                              hub_frame_rdy          ,
                input    [FRAME_WIDTH-CHECKBIT_WIDTH-2-1:0]                         hub_frame_data         ,
                //array read data
                output                                                              mc_rvalid              ,
                output   [ARRAY_DATA_WIDTH-1:0]                                     mc_rdata               , //wy up
                output   [1:0]                                                      mc_rresp               , //wy add
                //phy timing cfg
                output   [3:0]                                                      bank_radd_set_time     ,
                output   [3:0]                                                      cadd_set_time          ,
                output   [7:0]                                                      r_cas_set_time         ,
                output   [7:0]                                                      w_cas_set_time         ,
                output   [7:0]                                                      cas_wrrdy_time         ,
                //intrrupt
                output                                                              hang_timeout_intr      ,
                //STC and DFS ctrl
                input                                                               mc_rf_start_sel        ,//0:sel input rf start,1:sel mc local cfg
                input    [31:0]                                                     rf_start_time          ,//dap_aux cfg rf start time
                input    [31:0]                                                     rf_period              ,
                input                                                               rf_period_up_en        ,
                input                                                               mc_rf_period_sel       ,//0:sel input rf period,1:sel mc local,default 0
                //monitor
                output   [99:0]                                                     monitor_signals        ,
                //wy add
                output                                                              global_dram_init_finish_int,
                input                                                               global_ecc_en            ,
                input                                                               global_ecc_sel           ,
                output                                                              mc_ecc_ce_int            ,
                output                                                              mc_ecc_uce_int           ,
                input   [31:0]                                                      a2f_dbg_ar_cnt           ,
                input   [31:0]                                                      a2f_dbg_r_cnt            ,
                input   [31:0]                                                      a2f_dbg_aw_cnt           ,
                input   [31:0]                                                      a2f_dbg_w_cnt            ,
                input   [31:0]                                                      a2f_dbg_b_cnt            ,
                input   [31:0]                                                      a2f_dbg_axi_len_err_addr ,
                input                                                               a2f_dbg_axi_len_err      ,
                output  [31:0]                                                      a2f_dbg_reserve_in       ,
                input   [31:0]                                                      a2f_dbg_reserve_out      
    );

localparam  MC_ERR_ADDR_WIDTH = ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH;
localparam  MC_CE_RECORD_NUM  = 16;
localparam  MC_UCE_RECORD_NUM = 4;
//
wire       [31:0]                                                  mc_rf_period_1               ;
wire       [31:0]                                                  mc_rf_period_2               ;
wire       [31:0]                                                  mc_rf_start_1                ;
wire       [31:0]                                                  mc_rf_start_2                ;
wire                                                               mc_timeout_flag              ;
wire                                                               bist_finish                  ;
wire                                                               bist_bank_finish             ;
wire       [1:0]                                                   dbg_w_frame_cnt              ;  
wire       [1:0]                                                   dbg_r_frame_cnt              ;  
wire       [1:0]                                                   dbg_r_data_cnt               ;  
wire                                                               dbg_refresh_flag             ;
wire       [4:0]                                                   dbg_current_state            ;   
wire       [4:0]                                                   dbg_next_state               ;
wire                                                               mc_frame_vld                 ;
wire                                                               mc_frame_rdy                 ;
wire       [FRAME_WIDTH-1:0]                                       mc_frame_data                ;//wy up
wire                                                               mc_frame_vmc_vld             ;
wire                                                               mc_frame_vmc_rdy             ;
wire       [FRAME_WIDTH-1:0]                                       mc_frame_vmc_data            ;// wy up  

wire                                                               array_frame_vld              ;
wire                                                               array_frame_rdy              ;
wire       [FRAME_WIDTH-1:0]                                       array_frame_data             ;//wy up
wire                                                               array_rvalid                 ;
wire       [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                   array_rdata                  ;
wire                                                               arb_rvalid                   ;
wire       [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                   arb_rdata                    ;

wire       [6:0]                                                   err_wl_cnt                   ;

wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl0_part0          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl1_part0          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl0_part1          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl1_part1          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl0_part2          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl1_part2          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl0_part3          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl1_part3          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl0_part4          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl1_part4          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl0_part5          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl1_part5          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl0_part6          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl1_part6          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl0_part7          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl1_part7          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl0_part8          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl1_part8          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl0_part9          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank0_err_csl1_part9          ; 

wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl0                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl1                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl2                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl3                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl4                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl5                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl6                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl7                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl8                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl9                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl10                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl11                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl12                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl13                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl14                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl15                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl16                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl17                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl18                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl19                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl20                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl21                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl22                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl23                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl24                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl25                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl26                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl27                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl28                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl29                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl30                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl31                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl32                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl33                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl34                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl35                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl36                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl37                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl38                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl39                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl40                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl41                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl42                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl43                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl44                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl45                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl46                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl47                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl48                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl49                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl50                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl51                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl52                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl53                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl54                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl55                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl56                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl57                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl58                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl59                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl60                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl61                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl62                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank0_err_wl63                ; 

wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl0_part0          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl1_part0          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl0_part1          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl1_part1          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl0_part2          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl1_part2          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl0_part3          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl1_part3          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl0_part4          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl1_part4          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl0_part5          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl1_part5          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl0_part6          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl1_part6          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl0_part7          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl1_part7          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl0_part8          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl1_part8          ; 
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl0_part9          ;
wire       [ARRAY_COL_ADDR_WIDTH-1:0]                              bank1_err_csl1_part9          ; 

wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl0                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl1                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl2                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl3                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl4                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl5                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl6                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl7                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl8                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl9                 ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl10                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl11                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl12                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl13                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl14                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl15                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl16                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl17                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl18                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl19                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl20                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl21                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl22                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl23                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl24                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl25                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl26                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl27                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl28                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl29                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl30                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl31                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl32                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl33                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl34                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl35                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl36                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl37                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl38                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl39                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl40                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl41                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl42                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl43                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl44                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl45                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl46                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl47                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl48                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl49                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl50                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl51                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl52                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl53                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl54                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl55                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl56                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl57                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl58                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl59                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl60                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl61                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl62                ;
wire       [ARRAY_ROW_ADDR_WIDTH-1:0]                              bank1_err_wl63                ; 
wire                                                               bank_scan_frame_vld     ;
wire                                                               bank_scan_frame_rdy     ;
wire     [FRAME_WIDTH-1:0]                                         bank_scan_frame_data    ;//wy up rw_flag,sof,eof,data,row,col
wire                                                               bank_scan_rvalid        ;
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     bank_scan_rdata         ;

wire                                                               csl_scan_frame_vld      ;
wire                                                               csl_scan_frame_rdy      ;
wire     [FRAME_WIDTH-1:0]                                         csl_scan_frame_data     ;//wy up rw_flag,sof,eof,data,row,col
wire                                                               csl_scan_rvalid         ;
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     csl_scan_rdata          ;

wire                                                               wl_scan_frame_vld       ;
wire                                                               wl_scan_frame_rdy       ;
wire     [FRAME_WIDTH-1:0]                                         wl_scan_frame_data      ;//wy up rw_flag,sof,eof,data,row,col
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     wl_scan_rdata           ;
wire                                                               wl_scan_rvalid          ;

wire                                                               rescan_frame_vld        ;
wire                                                               rescan_frame_rdy        ;
wire     [FRAME_WIDTH-1:0]                                         rescan_frame_data       ;//wy up rw_flag,sof,eof,data,row,col[5:0]
wire                                                               rescan_rvalid           ;
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     rescan_rdata            ;


wire                                                               func_frame_vld          ;
wire                                                               func_frame_rdy          ;
wire     [FRAME_WIDTH-1:0]                                         func_frame_data         ;//wy up rw_flag,sof,eof,data,row,col
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                     func_rdata              ;
wire                                                               func_rvalid             ;

wire                                                               dram_init_frame_vld     ;
wire                                                               dram_init_frame_rdy     ;
wire     [FRAME_WIDTH-1:0]                                         dram_init_frame_data    ;//wy up rw_flag,sof,eof,data,row,col
 
reg      [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             remap_wl_addr           ;
reg      [ARRAY_COL_ADDR_WIDTH*20-1:0]                             remap_csl_addr          ;

wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             remap_bank0_wl_addr    ;
wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             remap_bank0_csl_addr     ;
wire     [ARRAY_ROW_ADDR_WIDTH*64-1:0]                             remap_bank1_wl_addr    ;
wire     [ARRAY_COL_ADDR_WIDTH*20-1:0]                             remap_bank1_csl_addr     ;

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
wire       [39:0]                                                  bist_rescan_fail_num    ;
wire                                                               dram_init_finish        ;   
//wire                                                               hub_frame_rdy_tmp       ;
wire       [6:0]                                                   bank0_err_wl_cnt        ;
wire       [6:0]                                                   bank1_err_wl_cnt        ;

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
wire                                                               bank0_err_wl_cnt_change_flag  ;
wire                                                               bank1_err_wl_cnt_change_flag  ;
wire                                                               mc_rescan_addr_range_sel       ;           
wire                                                               mc_rescan_addr_range_sel_tmp   ;
wire                                                               mc_csl_scan_addr_range_sel     ;
wire                                                               mc_csl_scan_addr_range_sel_tmp ;
wire                                                               mc_csl_scan_check_sel          ;
wire                                                               mc_csl_scan_check_sel_tmp      ;
wire                                                               global_rf_cnt_clr_tmp          ;
wire                                                               global_dram_init_en_tmp        ;
wire       [15*2-1:0]                                              rescan_round_result     ;
//wire                                                               bist_or_rescan_finish   ;
reg        [FRAME_WIDTH-2-1:0]                                     dbg_store_latest_frame         ; // wy up
reg        [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                   dbg_store_latest_rdata         ;

//wy add

wire        [ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH-1:0]         func_addr               ;                
wire                                                                mc_ecc_en               ;
wire                                                                mc_cfg_ecc_en           ;
wire        [4:0]                                                   mc_ecc_ce_th            ;
wire                                                                mc_ecc_ce_int_clr       ;
wire                                                                mc_ecc_ce_int_status    ;
wire        [4:0]                                                   mc_ecc_ce_cnt           ;
wire        [MC_CE_RECORD_NUM*MC_ERR_ADDR_WIDTH-1:0]                mc_ecc_ce_addr          ;
wire        [MC_CE_RECORD_NUM-1:0]                                  mc_ecc_ce_addr_vld      ;
wire                                                                mc_ecc_uce_int_clr      ;
wire                                                                mc_ecc_uce_int_status   ;
wire        [2:0]                                                   mc_ecc_uce_cnt          ;
wire        [MC_UCE_RECORD_NUM-1:0]                                 mc_ecc_uce_addr_vld     ;
wire        [MC_UCE_RECORD_NUM*MC_ERR_ADDR_WIDTH-1:0]               mc_ecc_uce_addr         ;
wire                                                                mc_ecc_ce_int_mask      ;
wire                                                                mc_ecc_uce_int_mask     ;
wire                                                                bist_scan_start_bank    ;
wire                                                                bist_scan_end_bank      ;
wire        [31:0]                                                  bist_pattern_reg0       ;
wire        [31:0]                                                  bist_pattern_reg1       ;
wire        [31:0]                                                  bist_pattern_reg2       ;
wire        [31:0]                                                  bist_pattern_reg3       ;
wire        [31:0]                                                  wl_bist_pattern_sel0    ;
wire        [31:0]                                                  wl_bist_pattern_sel1    ;
wire        [3:0]                                                   wl_bist_pattern_sel2    ;
wire        [31:0]                                                  csl_bist_pattern_sel0   ;
wire        [31:0]                                                  csl_bist_pattern_sel1   ;
wire        [3:0]                                                   csl_bist_pattern_sel2   ;
wire                                                                csl_scan_mode_sel       ;
wire        [31:0]                                                  bist_pattern0           ;             
wire        [31:0]                                                  bist_pattern1           ;             
wire        [31:0]                                                  bist_pattern2           ;             
wire        [31:0]                                                  bist_pattern3           ;             
wire        [31:0]                                                  bist_pattern4           ;             
wire        [31:0]                                                  bist_pattern5           ;             
wire        [31:0]                                                  bist_pattern6           ;             
wire        [31:0]                                                  bist_pattern7           ;             
wire        [31:0]                                                  bist_pattern8           ;             
wire        [31:0]                                                  bist_pattern9           ;             
wire        [31:0]                                                  bist_pattern10          ;             
wire        [31:0]                                                  bist_pattern11          ;             
wire        [31:0]                                                  bist_pattern12          ;             
wire        [31:0]                                                  bist_pattern13          ;             
wire        [31:0]                                                  bist_pattern14          ;             
wire        [31:0]                                                  bist_pattern15          ;             
wire        [31:0]                                                  bist_pattern16          ;             
wire        [31:0]                                                  bist_pattern17          ;             
wire        [31:0]                                                  bist_pattern18          ;             
wire        [31:0]                                                  bist_pattern19          ;             
wire        [31:0]                                                  bist_pattern20          ;             
wire        [31:0]                                                  bist_pattern21          ;             
wire        [31:0]                                                  bist_pattern22          ;             
wire        [31:0]                                                  bist_pattern23          ;             
wire        [31:0]                                                  bist_pattern24          ;             
wire        [31:0]                                                  bist_pattern25          ;             
wire        [31:0]                                                  bist_pattern26          ;             
wire        [31:0]                                                  bist_pattern27          ;             
wire        [31:0]                                                  bist_pattern28          ;             
wire        [31:0]                                                  bist_pattern29          ;             
wire        [31:0]                                                  bist_pattern30          ;             
wire        [31:0]                                                  bist_pattern31          ;             
wire        [31:0]                                                  bist_pattern32          ;             
wire        [31:0]                                                  bist_pattern33          ;             
wire        [31:0]                                                  bist_pattern34          ;             
wire        [31:0]                                                  bist_pattern35          ;             
wire        [31:0]                                                  bist_pattern36          ;             
wire        [31:0]                                                  bist_pattern37          ;             
wire        [31:0]                                                  bist_pattern38          ;             
wire        [31:0]                                                  bist_pattern39          ;             
wire        [31:0]                                                  bist_pattern40          ;             
wire        [31:0]                                                  bist_pattern41          ;             
wire        [31:0]                                                  bist_pattern42          ;             
wire        [31:0]                                                  bist_pattern43          ;             
wire        [31:0]                                                  bist_pattern44          ;             
wire        [31:0]                                                  bist_pattern45          ;             
wire        [31:0]                                                  bist_pattern46          ;             
wire        [31:0]                                                  bist_pattern47          ;             
wire        [31:0]                                                  bist_pattern48          ;             
wire        [31:0]                                                  bist_pattern49          ;             
wire        [31:0]                                                  bist_pattern50          ;             
wire        [31:0]                                                  bist_pattern51          ;             
wire        [31:0]                                                  bist_pattern52          ;             
wire        [31:0]                                                  bist_pattern53          ;             
wire        [31:0]                                                  bist_pattern54          ;             
wire        [31:0]                                                  bist_pattern55          ;             
wire        [31:0]                                                  bist_pattern56          ;             
wire        [31:0]                                                  bist_pattern57          ;             
wire        [31:0]                                                  bist_pattern58          ;             
wire        [31:0]                                                  bist_pattern59          ;             
wire        [31:0]                                                  bist_pattern60          ;             
wire        [31:0]                                                  bist_pattern61          ;             
wire        [31:0]                                                  bist_pattern62          ;             
wire        [31:0]                                                  bist_pattern63          ;   
wire        [68*32-1:0]                                             bist_pattern_all;

wire        [1:0]                                                   bist_scan_fsm_status;
wire        [1:0]                                                   bank_scan_fsm_status;
wire        [MC_ERR_ADDR_WIDTH-1:0]                                 array_addr;
wire        [MC_ERR_ADDR_WIDTH-1:0]                                 arb_addr;

wire                                                                ras_clr;

assign  mc_ecc_en = global_ecc_sel ? global_ecc_en : mc_cfg_ecc_en;
assign  mc_ecc_ce_int = mc_ecc_ce_int_status && (!mc_ecc_ce_int_mask);
assign  mc_ecc_uce_int = mc_ecc_uce_int_status && (!mc_ecc_uce_int_mask);

assign rf_end_raddr = rf_addr[ARRAY_ROW_ADDR_WIDTH-1:0];
assign rf_start_raddr = rf_addr[ARRAY_ROW_ADDR_WIDTH*2-1:ARRAY_ROW_ADDR_WIDTH];
//assign hub_frame_rdy = global_dram_init_en ? hub_frame_rdy_tmp && dram_init_finish :  hub_frame_rdy_tmp;
assign  global_dram_init_finish_int = dram_init_finish;

wire    rescan_working;
wire    dram_init_working;
wire    bist_working;

assign bist_working = (bist_scan_fsm_status != 2'b00) || rescan_working ;
assign  rescan_working = (bank_scan_fsm_status != 2'b00);
assign dram_init_working = global_dram_init_en_tmp && mc_en_tmp ? !dram_init_finish : 1'b0;


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
        .width         (6              ),
        .f_sync_type   (2              ),
        .tst_mode      (0              ),
        .verif_en      (1              )
        )U1_mc_ctrl_DW_sync( 
        .clk_d         (clk                                                                                                      ),
        .rst_d_n       (rst_n                                                                                                    ),
        .init_d_n      (1'b1                                                                                                     ),
        .data_s        ({mc_en,bist_finish_mask,rescan_finish_mask,mc_csl_scan_check_sel,global_dram_init_en,mc_bist_csl_vmc_en}                    ),
        .test          (1'b0                                                                                                     ),
        .data_d        ({mc_en_tmp,bist_finish_mask_tmp,rescan_finish_mask_tmp,mc_csl_scan_check_sel_tmp,global_dram_init_en_tmp,mc_bist_csl_vmc_en_tmp})
        );
DW_sync #(
        .width         (5              ),
        .f_sync_type   (2              ),
        .tst_mode      (0              ),
        .verif_en      (1              )
        )U2_mc_ctrl_DW_sync( 
        .clk_d         (clk                                                          ),
        .rst_d_n       (rst_n                                                        ),
        .init_d_n      (1'b1                                                         ),
        .data_s        ({mc_scan_timeout_en,hang_timeout_mask,hang_timeout_en,mc_rescan_addr_range_sel,mc_csl_scan_addr_range_sel}                ),
        .test          (1'b0                                                                                                   ),
        .data_d        ({mc_scan_timeout_en_tmp,hang_timeout_mask_tmp,hang_timeout_en_tmp,mc_rescan_addr_range_sel_tmp,mc_csl_scan_addr_range_sel_tmp})
        );

    d35_pulse2pulse_aux#(
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

    d35_pulse2pulse_aux#(
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

    d35_pulse2pulse_aux#(
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

//--------------------------------------signal sync done-------------------------------

apb2reg_mc_wrapper_cfg_if #(
    .APB_ADDR_WIDTH     (APB_ADDR_WIDTH   ),
    .APB_DATA_WIDTH     (APB_DATA_WIDTH   )
    )apb2reg_mc_wrapper_cfg_if_u(
    .pclk                           (apb_clk                            ),
    .presetn                        (apb_rst_n                          ),
    .psel                           (soc_apb_sel                        ),
    .penable                        (soc_apb_enable                     ),
    .paddr                          (soc_apb_addr                       ),
    .pwrite                         (soc_apb_write                      ),
    .pwdata                         (soc_apb_wdata                      ),
    .mc_id_i                        (mc_id_soc                          ),             
    .dbg_next_state_array_i         (dbg_next_state                     ),
    .dbg_current_state_array_i      (dbg_current_state                  ),
    .dbg_r_data_cnt_i               (dbg_r_data_cnt                     ),
    .dbg_refresh_flag_i             (dbg_refresh_flag                   ),
    .dbg_r_frame_cnt_i              (dbg_r_frame_cnt                    ),
    .dbg_w_frame_cnt_i              (dbg_w_frame_cnt                    ),
    .mc_rf_start_dbg_i              (mc_rf_start                        ),
    .mc_timeout_flag_i              (mc_timeout_flag                    ),
    .mc_bist_status_i               (bist_scan_status                   ),
    .mc_bist_path_fail_i            (bist_bank_finish                   ),
    .dram_init_finish_i             (dram_init_finish                   ),       
    .bist_finish_i                  (bist_finish                        ),
    .bist_rescan_finish_i           (bist_rescan_finish_status          ),
    .bank_success_i                 (bank_success                       ),
    .bist_rescan_success_i          (bist_rescan_success                ),
    .err_csl0_part0_i               (bank0_err_csl0_part0               ),
    .err_csl1_part0_i               (bank0_err_csl1_part0               ),
    .err_csl0_part1_i               (bank0_err_csl0_part1               ),
    .err_csl1_part1_i               (bank0_err_csl1_part1               ),
    .err_wl0_i                      (bank0_err_wl0                      ),
    .err_wl1_i                      (bank0_err_wl1                      ),
    .err_wl2_i                      (bank0_err_wl2                      ),
    .err_wl3_i                      (bank0_err_wl3                      ),
    .err_wl4_i                      (bank0_err_wl4                      ),
    .err_wl5_i                      (bank0_err_wl5                      ),
    .err_wl6_i                      (bank0_err_wl6                      ),
    .err_wl7_i                      (bank0_err_wl7                      ),
    .err_wl8_i                      (bank0_err_wl8                      ),
    .err_wl9_i                      (bank0_err_wl9                      ),
    .err_wl10_i                     (bank0_err_wl10                     ),
    .err_wl11_i                     (bank0_err_wl11                     ),
    .err_wl12_i                     (bank0_err_wl12                     ),
    .err_wl13_i                     (bank0_err_wl13                     ),
    .err_wl14_i                     (bank0_err_wl14                     ),
    .err_wl15_i                     (bank0_err_wl15                     ),
    .err_wl16_i                     (bank0_err_wl16                     ),
    .err_wl17_i                     (bank0_err_wl17                     ),
    .err_wl18_i                     (bank0_err_wl18                     ),
    .err_wl19_i                     (bank0_err_wl19                     ),
    .err_wl20_i                     (bank0_err_wl20                     ),
    .err_wl21_i                     (bank0_err_wl21                     ),
    .err_wl22_i                     (bank0_err_wl22                     ),
    .err_wl23_i                     (bank0_err_wl23                     ),
    .err_wl24_i                     (bank0_err_wl24                     ),
    .err_wl25_i                     (bank0_err_wl25                     ),
    .err_wl26_i                     (bank0_err_wl26                     ),
    .err_wl27_i                     (bank0_err_wl27                     ),
    .err_wl28_i                     (bank0_err_wl28                     ),
    .err_wl29_i                     (bank0_err_wl29                     ),
    .err_wl30_i                     (bank0_err_wl30                     ),
    .err_wl31_i                     (bank0_err_wl31                     ),
    .err_wl32_i                     (bank0_err_wl32                     ),
    .err_wl33_i                     (bank0_err_wl33                     ),
    .err_wl34_i                     (bank0_err_wl34                     ),
    .err_wl35_i                     (bank0_err_wl35                     ),
    .err_wl36_i                     (bank0_err_wl36                     ),
    .err_wl37_i                     (bank0_err_wl37                     ),
    .err_wl38_i                     (bank0_err_wl38                     ),
    .err_wl39_i                     (bank0_err_wl39                     ),
    .err_wl40_i                     (bank0_err_wl40                     ),
    .err_wl41_i                     (bank0_err_wl41                     ),
    .err_wl42_i                     (bank0_err_wl42                     ),
    .err_wl43_i                     (bank0_err_wl43                     ),
    .err_wl44_i                     (bank0_err_wl44                     ),
    .err_wl45_i                     (bank0_err_wl45                     ),
    .err_wl46_i                     (bank0_err_wl46                     ),
    .err_wl47_i                     (bank0_err_wl47                     ),
    .err_wl48_i                     (bank0_err_wl48                     ),
    .err_wl49_i                     (bank0_err_wl49                     ),
    .err_wl50_i                     (bank0_err_wl50                     ),
    .err_wl51_i                     (bank0_err_wl51                     ),
    .err_wl52_i                     (bank0_err_wl52                     ),
    .err_wl53_i                     (bank0_err_wl53                     ),
    .err_wl54_i                     (bank0_err_wl54                     ),
    .err_wl55_i                     (bank0_err_wl55                     ),
    .err_wl56_i                     (bank0_err_wl56                     ),
    .err_wl57_i                     (bank0_err_wl57                     ),
    .err_wl58_i                     (bank0_err_wl58                     ),
    .err_wl59_i                     (bank0_err_wl59                     ),
    .err_wl60_i                     (bank0_err_wl60                     ),
    .err_wl61_i                     (bank0_err_wl61                     ),
    .err_wl62_i                     (bank0_err_wl62                     ),
    .err_wl63_i                     (bank0_err_wl63                     ),
    .mc_bist_rescan_fail_num_i      (bist_rescan_fail_num[19:0]         ),
    .mc_bist_err_wl_num_i           (bank0_err_wl_cnt                   ),
    .err_wl_num_change_flag_i       (bank0_err_wl_cnt_change_flag       ),
    .rescan_round_result_i          (rescan_round_result[14:0]          ),
    .err_csl0_part2_i               (bank0_err_csl0_part2               ),
    .err_csl1_part2_i               (bank0_err_csl1_part2               ),
    .err_csl0_part3_i               (bank0_err_csl0_part3               ),
    .err_csl1_part3_i               (bank0_err_csl1_part3               ),
    .err_csl0_part4_i               (bank0_err_csl0_part4               ),
    .err_csl1_part4_i               (bank0_err_csl1_part4               ),
    .dbg_frame_store_0_i            (dbg_store_latest_frame[0*32+:32]    ),
    .dbg_frame_store_1_i            (dbg_store_latest_frame[1*32+:32]    ),
    .dbg_frame_store_2_i            (dbg_store_latest_frame[2*32+:32]    ),
    .dbg_frame_store_3_i            (dbg_store_latest_frame[3*32+:32]    ),
    .dbg_frame_store_4_i            (dbg_store_latest_frame[4*32+:32]    ),
    .dbg_frame_store_5_i            (dbg_store_latest_frame[5*32+:32]    ),
    .dbg_frame_store_6_i            (dbg_store_latest_frame[6*32+:32]    ),
    .dbg_frame_store_7_i            (dbg_store_latest_frame[7*32+:32]    ),
    .dbg_frame_store_8_i            (dbg_store_latest_frame[8*32+:32]    ),
    .dbg_frame_store_9_i            (dbg_store_latest_frame[9*32+:2]     ),
    .dbg_rdata_store_0_i            (dbg_store_latest_rdata[0*32+:32]    ),
    .dbg_rdata_store_1_i            (dbg_store_latest_rdata[1*32+:32]    ),
    .dbg_rdata_store_2_i            (dbg_store_latest_rdata[2*32+:32]    ),
    .dbg_rdata_store_3_i            (dbg_store_latest_rdata[3*32+:32]    ),
    .dbg_rdata_store_4_i            (dbg_store_latest_rdata[4*32+:32]    ),
    .dbg_rdata_store_5_i            (dbg_store_latest_rdata[5*32+:32]    ),
    .dbg_rdata_store_6_i            (dbg_store_latest_rdata[6*32+:32]    ),
    .dbg_rdata_store_7_i            (dbg_store_latest_rdata[7*32+:32]    ),
    .dbg_rdata_store_8_i            (dbg_store_latest_rdata[8*32+:10]    ),
    .err_csl0_part5_i               (bank0_err_csl0_part5                ),
    .err_csl1_part5_i               (bank0_err_csl1_part5                ),
    .err_csl0_part6_i               (bank0_err_csl0_part6                ),
    .err_csl1_part6_i               (bank0_err_csl1_part6                ),
    .err_csl0_part7_i               (bank0_err_csl0_part7                ),
    .err_csl1_part7_i               (bank0_err_csl1_part7                ),
    .err_csl0_part8_i               (bank0_err_csl0_part8                ),
    .err_csl1_part8_i               (bank0_err_csl1_part8                ),
    .err_csl0_part9_i               (bank0_err_csl0_part9                ),
    .err_csl1_part9_i               (bank0_err_csl1_part9                ),
    .mc_ecc_ce_int_status_i         (mc_ecc_ce_int_status                ),
    .mc_ecc_uce_int_status_i        (mc_ecc_uce_int_status               ),
    .mc_ecc_ce_cnt_i                (mc_ecc_ce_cnt                       ),
    .mc_ecc_ce_addr0_i              ({mc_ecc_ce_addr_vld[0],10'b0,mc_ecc_ce_addr[0*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] }        ),
    .mc_ecc_ce_addr1_i              ({mc_ecc_ce_addr_vld[1],10'b0,mc_ecc_ce_addr[1*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] }        ),
    .mc_ecc_ce_addr2_i              ({mc_ecc_ce_addr_vld[2],10'b0,mc_ecc_ce_addr[2*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] }        ),
    .mc_ecc_ce_addr3_i              ({mc_ecc_ce_addr_vld[3],10'b0,mc_ecc_ce_addr[3*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] }        ),
    .mc_ecc_ce_addr4_i              ({mc_ecc_ce_addr_vld[4],10'b0,mc_ecc_ce_addr[4*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] }        ),
    .mc_ecc_ce_addr5_i              ({mc_ecc_ce_addr_vld[5],10'b0,mc_ecc_ce_addr[5*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] }        ),
    .mc_ecc_ce_addr6_i              ({mc_ecc_ce_addr_vld[6],10'b0,mc_ecc_ce_addr[6*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] }        ),
    .mc_ecc_ce_addr7_i              ({mc_ecc_ce_addr_vld[7],10'b0,mc_ecc_ce_addr[7*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] }        ),
    .mc_ecc_ce_addr8_i              ({mc_ecc_ce_addr_vld[8],10'b0,mc_ecc_ce_addr[8*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] }        ),
    .mc_ecc_ce_addr9_i              ({mc_ecc_ce_addr_vld[9],10'b0,mc_ecc_ce_addr[9*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] }        ),
    .mc_ecc_ce_addr10_i             ({mc_ecc_ce_addr_vld[10],10'b0,mc_ecc_ce_addr[10*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH]}       ),
    .mc_ecc_ce_addr11_i             ({mc_ecc_ce_addr_vld[11],10'b0,mc_ecc_ce_addr[11*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH]}       ),
    .mc_ecc_ce_addr12_i             ({mc_ecc_ce_addr_vld[12],10'b0,mc_ecc_ce_addr[12*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH]}       ),
    .mc_ecc_ce_addr13_i             ({mc_ecc_ce_addr_vld[13],10'b0,mc_ecc_ce_addr[13*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH]}       ),
    .mc_ecc_ce_addr14_i             ({mc_ecc_ce_addr_vld[14],10'b0,mc_ecc_ce_addr[14*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH]}       ),
    .mc_ecc_ce_addr15_i             ({mc_ecc_ce_addr_vld[15],10'b0,mc_ecc_ce_addr[15*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH]}       ),
    .mc_ecc_uce_addr0_i             ({mc_ecc_uce_addr_vld[0],10'b0,mc_ecc_uce_addr[0*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH]}       ),
    .mc_ecc_uce_addr1_i             ({mc_ecc_uce_addr_vld[1],10'b0,mc_ecc_uce_addr[1*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH]}       ),
    .mc_ecc_uce_addr2_i             ({mc_ecc_uce_addr_vld[2],10'b0,mc_ecc_uce_addr[2*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH]}       ),
    .mc_ecc_uce_addr3_i             ({mc_ecc_uce_addr_vld[3],10'b0,mc_ecc_uce_addr[3*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH]}       ),
    .a2f_dbg_ar_cnt_i               (a2f_dbg_ar_cnt                                                         ),
    .a2f_dbg_r_cnt_i                (a2f_dbg_r_cnt                                                          ),
    .a2f_dbg_aw_cnt_i               (a2f_dbg_aw_cnt                                                         ),
    .a2f_dbg_w_cnt_i                (a2f_dbg_w_cnt                                                          ),
    .a2f_dbg_b_cnt_i                (a2f_dbg_b_cnt                                                          ),
    .a2f_dbg_axi_len_err_addr_i     (a2f_dbg_axi_len_err_addr                                               ),
    .a2f_dbg_axi_len_err_i          (a2f_dbg_axi_len_err                                                    ),
    .a2f_dbg_reserve_out_i          (a2f_dbg_reserve_out                                                    ),
    .mc_page_status_i               (mc_page_status                                                         ),
    .hang_timeout_status_i          (hang_timeout_status                                                    ),
    .bank1_err_wl0_i                (bank1_err_wl0                                                          ),
    .bank1_err_wl1_i                (bank1_err_wl1                                                          ),
    .bank1_err_wl2_i                (bank1_err_wl2                                                          ),
    .bank1_err_wl3_i                (bank1_err_wl3                                                          ),
    .bank1_err_wl4_i                (bank1_err_wl4                                                          ),
    .bank1_err_wl5_i                (bank1_err_wl5                                                          ),
    .bank1_err_wl6_i                (bank1_err_wl6                                                          ),
    .bank1_err_wl7_i                (bank1_err_wl7                                                          ),
    .bank1_err_wl8_i                (bank1_err_wl8                                                          ),
    .bank1_err_wl9_i                (bank1_err_wl9                                                          ),
    .bank1_err_wl10_i               (bank1_err_wl10                                                         ),
    .bank1_err_wl11_i               (bank1_err_wl11                                                         ),
    .bank1_err_wl12_i               (bank1_err_wl12                                                         ),
    .bank1_err_wl13_i               (bank1_err_wl13                                                         ),
    .bank1_err_wl14_i               (bank1_err_wl14                                                         ),
    .bank1_err_wl15_i               (bank1_err_wl15                                                         ),
    .bank1_err_wl16_i               (bank1_err_wl16                                                         ),
    .bank1_err_wl17_i               (bank1_err_wl17                                                         ),
    .bank1_err_wl18_i               (bank1_err_wl18                                                         ),
    .bank1_err_wl19_i               (bank1_err_wl19                                                         ),
    .bank1_err_wl20_i               (bank1_err_wl20                                                         ),
    .bank1_err_wl21_i               (bank1_err_wl21                                                         ),
    .bank1_err_wl22_i               (bank1_err_wl22                                                         ),
    .bank1_err_wl23_i               (bank1_err_wl23                                                         ),
    .bank1_err_wl24_i               (bank1_err_wl24                                                         ),
    .bank1_err_wl25_i               (bank1_err_wl25                                                         ),
    .bank1_err_wl26_i               (bank1_err_wl26                                                         ),
    .bank1_err_wl27_i               (bank1_err_wl27                                                         ),
    .bank1_err_wl28_i               (bank1_err_wl28                                                         ),
    .bank1_err_wl29_i               (bank1_err_wl29                                                         ),
    .bank1_err_wl30_i               (bank1_err_wl30                                                         ),
    .bank1_err_wl31_i               (bank1_err_wl31                                                         ),
    .bank1_err_wl32_i               (bank1_err_wl32                                                         ),
    .bank1_err_wl33_i               (bank1_err_wl33                                                         ),
    .bank1_err_wl34_i               (bank1_err_wl34                                                         ),
    .bank1_err_wl35_i               (bank1_err_wl35                                                         ),
    .bank1_err_wl36_i               (bank1_err_wl36                                                         ),
    .bank1_err_wl37_i               (bank1_err_wl37                                                         ),
    .bank1_err_wl38_i               (bank1_err_wl38                                                         ),
    .bank1_err_wl39_i               (bank1_err_wl39                                                         ),
    .bank1_err_wl40_i               (bank1_err_wl40                                                         ),
    .bank1_err_wl41_i               (bank1_err_wl41                                                         ),
    .bank1_err_wl42_i               (bank1_err_wl42                                                         ),
    .bank1_err_wl43_i               (bank1_err_wl43                                                         ),
    .bank1_err_wl44_i               (bank1_err_wl44                                                         ),
    .bank1_err_wl45_i               (bank1_err_wl45                                                         ),
    .bank1_err_wl46_i               (bank1_err_wl46                                                         ),
    .bank1_err_wl47_i               (bank1_err_wl47                                                         ),
    .bank1_err_wl48_i               (bank1_err_wl48                                                         ),
    .bank1_err_wl49_i               (bank1_err_wl49                                                         ),
    .bank1_err_wl50_i               (bank1_err_wl50                                                         ),
    .bank1_err_wl51_i               (bank1_err_wl51                                                         ),
    .bank1_err_wl52_i               (bank1_err_wl52                                                         ),
    .bank1_err_wl53_i               (bank1_err_wl53                                                         ),
    .bank1_err_wl54_i               (bank1_err_wl54                                                         ),
    .bank1_err_wl55_i               (bank1_err_wl55                                                         ),
    .bank1_err_wl56_i               (bank1_err_wl56                                                         ),
    .bank1_err_wl57_i               (bank1_err_wl57                                                         ),
    .bank1_err_wl58_i               (bank1_err_wl58                                                         ),
    .bank1_err_wl59_i               (bank1_err_wl59                                                         ),
    .bank1_err_wl60_i               (bank1_err_wl60                                                         ),
    .bank1_err_wl61_i               (bank1_err_wl61                                                         ),
    .bank1_err_wl62_i               (bank1_err_wl62                                                         ),
    .bank1_err_wl63_i               (bank1_err_wl63                                                         ),
    .bank1_err_csl0_part0_i         (bank1_err_csl0_part0                                                   ),
    .bank1_err_csl1_part0_i         (bank1_err_csl1_part0                                                   ),
    .bank1_err_csl0_part1_i         (bank1_err_csl0_part1                                                   ),
    .bank1_err_csl1_part1_i         (bank1_err_csl1_part1                                                   ),
    .bank1_err_csl0_part2_i         (bank1_err_csl0_part2                                                   ),
    .bank1_err_csl1_part2_i         (bank1_err_csl1_part2                                                   ),
    .bank1_err_csl0_part3_i         (bank1_err_csl0_part3                                                   ),
    .bank1_err_csl1_part3_i         (bank1_err_csl1_part3                                                   ),
    .bank1_err_csl0_part4_i         (bank1_err_csl0_part4                                                   ),
    .bank1_err_csl1_part4_i         (bank1_err_csl1_part4                                                   ),
    .bank1_err_csl0_part5_i         (bank1_err_csl0_part5                                                   ),
    .bank1_err_csl1_part5_i         (bank1_err_csl1_part5                                                   ),
    .bank1_err_csl0_part6_i         (bank1_err_csl0_part6                                                   ),
    .bank1_err_csl1_part6_i         (bank1_err_csl1_part6                                                   ),
    .bank1_err_csl0_part7_i         (bank1_err_csl0_part7                                                   ),
    .bank1_err_csl1_part7_i         (bank1_err_csl1_part7                                                   ),
    .bank1_err_csl0_part8_i         (bank1_err_csl0_part8                                                   ),
    .bank1_err_csl1_part8_i         (bank1_err_csl1_part8                                                   ),
    .bank1_err_csl0_part9_i         (bank1_err_csl0_part9                                                   ),
    .bank1_err_csl1_part9_i         (bank1_err_csl1_part9                                                   ),
 
    .mc_timeout_clr_o               (mc_timeout_clr                                                         ),
    .bist_finish_clr_o              (bist_finish_clr                                                        ),
    .rescan_finish_clr_o            (rescan_finish_clr                                                      ),
    .mc_ecc_ce_int_clr_o            (mc_ecc_ce_int_clr                                                      ),
    .mc_ecc_uce_int_clr_o           (mc_ecc_uce_int_clr                                                     ),
    .hang_timeout_clr_o             (hang_timeout_clr                                                       ),

    .mc_en_o                        (mc_en                                                                  ),
    .mc_rf_cfg_sel_o                (mc_rf_cfg_sel                                                          ),
    .mc_debug_en_o                  (mc_debug_en                                                            ),
    .mc_wl_vmc_en_o                 (mc_wl_vmc_en                                                           ),
    .mc_bl_vmc_en_o                 (mc_bl_vmc_en                                                           ),
    .mc_bist_en_o                   (mc_bist_en                                                             ),
    .mc_rescan_addr_range_sel_o     (mc_rescan_addr_range_sel                                               ),
    .mc_csl_scan_addr_range_sel_o   (mc_csl_scan_addr_range_sel                                             ),
    .mc_csl_scan_check_sel_o        (mc_csl_scan_check_sel                                                  ),
    .bank_radd_set_time_o           (bank_radd_set_time                                                     ),
    .cadd_set_time_o                (cadd_set_time                                                          ),
    .r_cas_set_time_o               (r_cas_set_time                                                         ),
    .w_cas_set_time_o               (w_cas_set_time                                                         ),
    .cas_wrrdy_time_o               (cas_wrrdy_time                                                         ),
    .mc_rf_period_1_o               (mc_rf_period_1                                                         ),
    .mc_rf_start_1_o                (mc_rf_start_1                                                          ),
    .mc_rf_period_2_o               (mc_rf_period_2                                                         ),
    .mc_rf_start_2_o                (mc_rf_start_2                                                          ),
    .mc_vmc_wl_num0_o               (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_vmc_wl_num1_o               (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_vmc_wl_num2_o               (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_vmc_wl_num3_o               (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_vmc_wl_num4_o               (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*4 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_vmc_wl_num5_o               (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*5 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_vmc_wl_num6_o               (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*6 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_vmc_wl_num7_o               (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*7 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_vmc_wl_num8_o               (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*8 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_vmc_wl_num9_o               (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*9 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_vmc_wl_num10_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*10 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num11_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*11 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num12_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*12 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num13_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*13 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num14_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*14 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num15_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*15 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num16_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*16 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num17_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*17 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num18_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*18 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num19_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*19 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num20_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*20 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num21_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*21 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num22_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*22 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num23_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*23 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num24_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*24 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num25_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*25 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num26_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*26 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num27_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*27 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num28_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*28 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num29_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*29 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num30_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*30 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num31_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*31 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num32_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*32 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num33_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*33 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num34_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*34 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num35_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*35 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num36_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*36 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num37_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*37 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num38_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*38 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num39_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*39 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num40_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*40 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num41_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*41 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num42_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*42 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num43_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*43 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num44_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*44 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num45_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*45 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num46_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*46 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num47_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*47 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num48_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*48 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num49_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*49 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num50_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*50 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num51_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*51 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num52_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*52 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num53_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*53 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num54_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*54 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num55_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*55 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num56_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*56 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num57_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*57 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num58_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*58 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num59_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*59 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num60_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*60 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num61_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*61 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num62_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*62 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_wl_num63_o              (remap_bank0_wl_addr[ARRAY_ROW_ADDR_WIDTH*63 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_vmc_bl_num0_part0_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_vmc_bl_num1_part0_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_vmc_bl_num0_part1_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_vmc_bl_num1_part1_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]   ),
    .bist_finish_mask_o             (bist_finish_mask                                                       ),
    .hang_timeout_th_o              (hang_timeout_th                                                        ),
    .rescan_finish_mask_o           (rescan_finish_mask                                                     ),
    .mc_vmc_bl_num0_part2_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*4 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_vmc_bl_num1_part2_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*5 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_vmc_bl_num0_part3_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*6 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_vmc_bl_num1_part3_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*7 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_vmc_bl_num0_part4_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*8 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_vmc_bl_num1_part4_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*9 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_vmc_bl_num0_part5_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*10 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_vmc_bl_num1_part5_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*11 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_vmc_bl_num0_part6_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*12 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_vmc_bl_num1_part6_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*13 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_vmc_bl_num0_part7_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*14 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_vmc_bl_num1_part7_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*15 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_vmc_bl_num0_part8_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*16 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_vmc_bl_num1_part8_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*17 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_vmc_bl_num0_part9_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*18 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_vmc_bl_num1_part9_o         (remap_bank0_csl_addr[ARRAY_COL_ADDR_WIDTH*19 +: ARRAY_COL_ADDR_WIDTH]  ),
    .bist_pattern_reg0_o            (bist_pattern_reg0                                                      ),
    .bist_pattern_reg1_o            (bist_pattern_reg1                                                      ),
    .bist_pattern_reg2_o            (bist_pattern_reg2                                                      ),
    .bist_pattern_reg3_o            (bist_pattern_reg3                                                      ),
    .csl_bist_pattern_sel0_o        (csl_bist_pattern_sel0                                                  ),
    .csl_bist_pattern_sel1_o        (csl_bist_pattern_sel1                                                  ),
    .csl_bist_pattern_sel2_o        (csl_bist_pattern_sel2                                                  ),
    .wl_bist_pattern_sel0_o         (wl_bist_pattern_sel0                                                   ),
    .wl_bist_pattern_sel1_o         (wl_bist_pattern_sel1                                                   ),
    .wl_bist_pattern_sel2_o         (wl_bist_pattern_sel2                                                   ),
    .mc_csl_scan_mode_sel_o         (csl_scan_mode_sel                                                      ),    
    .mc_ecc_en_o                    (mc_cfg_ecc_en                                                          ),
    .mc_ecc_ce_th_o                 (mc_ecc_ce_th                                                           ),
    .mc_ecc_ce_int_mask_o           (mc_ecc_ce_int_mask                                                     ),
    .mc_ecc_uce_int_mask_o          (mc_ecc_uce_int_mask                                                    ),
    .bist_scan_start_bank_o         (bist_scan_start_bank                                                   ),
    .bist_scan_end_bank_o           (bist_scan_end_bank                                                     ),
    .a2f_dbg_reserve_in_o           (a2f_dbg_reserve_in                                                     ),
    .hang_timeout_mask_o            (hang_timeout_mask                                                      ),
    .hang_timeout_en_o              (hang_timeout_en                                                        ),
    .ras_clr_o                      (ras_clr                                                                ),
    .mc_bank1_vmc_wl_num0_o         (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*0 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_bank1_vmc_wl_num1_o         (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*1 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_bank1_vmc_wl_num2_o         (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*2 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_bank1_vmc_wl_num3_o         (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*3 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_bank1_vmc_wl_num4_o         (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*4 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_bank1_vmc_wl_num5_o         (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*5 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_bank1_vmc_wl_num6_o         (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*6 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_bank1_vmc_wl_num7_o         (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*7 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_bank1_vmc_wl_num8_o         (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*8 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_bank1_vmc_wl_num9_o         (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*9 +: ARRAY_ROW_ADDR_WIDTH]    ),
    .mc_bank1_vmc_wl_num10_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*10 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num11_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*11 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num12_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*12 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num13_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*13 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num14_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*14 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num15_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*15 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num16_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*16 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num17_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*17 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num18_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*18 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num19_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*19 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num20_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*20 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num21_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*21 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num22_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*22 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num23_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*23 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num24_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*24 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num25_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*25 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num26_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*26 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num27_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*27 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num28_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*28 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num29_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*29 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num30_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*30 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num31_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*31 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num32_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*32 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num33_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*33 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num34_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*34 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num35_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*35 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num36_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*36 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num37_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*37 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num38_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*38 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num39_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*39 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num40_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*40 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num41_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*41 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num42_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*42 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num43_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*43 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num44_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*44 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num45_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*45 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num46_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*46 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num47_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*47 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num48_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*48 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num49_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*49 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num50_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*50 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num51_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*51 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num52_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*52 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num53_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*53 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num54_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*54 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num55_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*55 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num56_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*56 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num57_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*57 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num58_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*58 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num59_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*59 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num60_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*60 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num61_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*61 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num62_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*62 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_wl_num63_o        (remap_bank1_wl_addr[ARRAY_ROW_ADDR_WIDTH*63 +: ARRAY_ROW_ADDR_WIDTH]   ),
    .mc_bank1_vmc_bl_num0_part0_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*0 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_bank1_vmc_bl_num1_part0_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*1 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_bank1_vmc_bl_num0_part1_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*2 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_bank1_vmc_bl_num1_part1_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*3 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_bank1_vmc_bl_num0_part2_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*4 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_bank1_vmc_bl_num1_part2_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*5 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_bank1_vmc_bl_num0_part3_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*6 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_bank1_vmc_bl_num1_part3_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*7 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_bank1_vmc_bl_num0_part4_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*8 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_bank1_vmc_bl_num1_part4_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*9 +: ARRAY_COL_ADDR_WIDTH]   ),
    .mc_bank1_vmc_bl_num0_part5_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*10 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_bank1_vmc_bl_num1_part5_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*11 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_bank1_vmc_bl_num0_part6_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*12 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_bank1_vmc_bl_num1_part6_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*13 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_bank1_vmc_bl_num0_part7_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*14 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_bank1_vmc_bl_num1_part7_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*15 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_bank1_vmc_bl_num0_part8_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*16 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_bank1_vmc_bl_num1_part8_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*17 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_bank1_vmc_bl_num0_part9_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*18 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_bank1_vmc_bl_num1_part9_o   (remap_bank1_csl_addr[ARRAY_COL_ADDR_WIDTH*19 +: ARRAY_COL_ADDR_WIDTH]  ),
    .mc_bank1_bist_rescan_fail_num_i(bist_rescan_fail_num[39:20]                                            ),
    .mc_bank1_bist_err_wl_num_i     (bank1_err_wl_cnt                                                       ),
    .err_bank1_wl_num_change_flag_i (bank1_err_wl_cnt_change_flag                                           ),
    .bank1_rescan_round_result_i    (rescan_round_result[29:15]                                             ),
    .pslverr                        (soc_apb_pslverr                                                        ),
    .prdata                         (soc_apb_rdata                                                          )
);

wl_clkgate_aux wl_clkgate_aux_u(
     .clk_i      (clk),
     .dft_se     (1'b0),
     .en         (global_mc_bist_en_tmp),
     .clk_o      (clk_bist)
     
 );


// wy up
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




bist_scan_aux_top #(
    .MC_FRAME_WIDTH      (FRAME_WIDTH        )   
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
          .csl_scan_check_sel                  (mc_csl_scan_check_sel_tmp         ),//default 1,check 266 bit rdata
 
          //.bist_csl_scan_num                   (bist_csl_scan_num                 ),
          //.bist_wl_scan_num                    (bist_wl_scan_num                  ),
          .bist_wl_scan_single_pattern_rd_num  (bist_wl_scan_single_pattern_rd_num),
          //.bist_pattern0                       (bist_pattern0                     ),
          //.bist_pattern1                       (bist_pattern1                     ),
          //.bist_pattern2                       (bist_pattern2                     ),
          //.bist_pattern3                       (bist_pattern3                     ),
          //.bist_pattern4                       (bist_pattern4                     ),
          //.bist_pattern5                       (bist_pattern5                     ),
          //.bist_pattern6                       (bist_pattern6                     ),
          //.bist_pattern7                       (bist_pattern7                     ),
          //.bist_pattern8                       (bist_pattern8                     ),
          //.bist_pattern9                       (bist_pattern9                     ),
          //.bist_pattern10                      (bist_pattern10                    ),
          //.bist_pattern11                      (bist_pattern11                    ),
          //.bist_pattern12                      (bist_pattern12                    ),
          //.bist_pattern13                      (bist_pattern13                    ),
          //.bist_pattern14                      (bist_pattern14                    ),
          //.bist_pattern15                      (bist_pattern15                    ),
          //.bist_pattern16                      (bist_pattern16                    ),
          //.bist_pattern17                      (bist_pattern17                    ),
          //.bist_pattern18                      (bist_pattern18                    ),
          //.bist_pattern19                      (bist_pattern19                    ),
          //.bist_pattern20                      (bist_pattern20                    ),
          //.bist_pattern21                      (bist_pattern21                    ),
          //.bist_pattern22                      (bist_pattern22                    ),
          //.bist_pattern23                      (bist_pattern23                    ),
          //.bist_pattern24                      (bist_pattern24                    ),
          //.bist_pattern25                      (bist_pattern25                    ),
          //.bist_pattern26                      (bist_pattern26                    ),
          //.bist_pattern27                      (bist_pattern27                    ),
          //.bist_pattern28                      (bist_pattern28                    ),
          //.bist_pattern29                      (bist_pattern29                    ),
          //.bist_pattern30                      (bist_pattern30                    ),
          //.bist_pattern31                      (bist_pattern31                    ),
          //.bist_pattern32                      (bist_pattern32                    ),
          //.bist_pattern33                      (bist_pattern33                    ),
          //.bist_pattern34                      (bist_pattern34                    ),
          //.bist_pattern35                      (bist_pattern35                    ),
          //.bist_pattern36                      (bist_pattern36                    ),
          //.bist_pattern37                      (bist_pattern37                    ),
          //.bist_pattern38                      (bist_pattern38                    ),
          //.bist_pattern39                      (bist_pattern39                    ),
          //.bist_pattern40                      (bist_pattern40                    ),
          //.bist_pattern41                      (bist_pattern41                    ),
          //.bist_pattern42                      (bist_pattern42                    ),
          //.bist_pattern43                      (bist_pattern43                    ),
          //.bist_pattern44                      (bist_pattern44                    ),
          //.bist_pattern45                      (bist_pattern45                    ),
          //.bist_pattern46                      (bist_pattern46                    ),
          //.bist_pattern47                      (bist_pattern47                    ),
          //.bist_pattern48                      (bist_pattern48                    ),
          //.bist_pattern49                      (bist_pattern49                    ),
          //.bist_pattern50                      (bist_pattern50                    ),
          //.bist_pattern51                      (bist_pattern51                    ),
          //.bist_pattern52                      (bist_pattern52                    ),
          //.bist_pattern53                      (bist_pattern53                    ),
          //.bist_pattern54                      (bist_pattern54                    ),
          //.bist_pattern55                      (bist_pattern55                    ),
          //.bist_pattern56                      (bist_pattern56                    ),
          //.bist_pattern57                      (bist_pattern57                    ),
          //.bist_pattern58                      (bist_pattern58                    ),
          //.bist_pattern59                      (bist_pattern59                    ),
          //.bist_pattern60                      (bist_pattern60                    ),
          //.bist_pattern61                      (bist_pattern61                    ),
          //.bist_pattern62                      (bist_pattern62                    ),
          //.bist_pattern63                      (bist_pattern63                    ),  
          //.bist_pattern_reg0                   (bist_pattern_reg0                 ),
          //.bist_pattern_reg1                   (bist_pattern_reg1                 ),
          //.bist_pattern_reg2                   (bist_pattern_reg2                 ),
          //.bist_pattern_reg3                   (bist_pattern_reg3                 ),
          .bist_pattern_all                    (bist_pattern_all                  ),
          .csl_bist_pattern_sel0               (csl_bist_pattern_sel0             ),
          .csl_bist_pattern_sel1               (csl_bist_pattern_sel1             ),
          .csl_bist_pattern_sel2               (csl_bist_pattern_sel2             ),
          .wl_bist_pattern_sel0                (wl_bist_pattern_sel0              ),
          .wl_bist_pattern_sel1                (wl_bist_pattern_sel1              ),
          .wl_bist_pattern_sel2                (wl_bist_pattern_sel2              ),
          .csl_scan_mode_sel                   (csl_scan_mode_sel                 ),
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
          
          .bank0_err_csl0_part0                (bank0_err_csl0_part0              ),
          .bank0_err_csl1_part0                (bank0_err_csl1_part0              ),
          .bank0_err_csl0_part1                (bank0_err_csl0_part1              ),
          .bank0_err_csl1_part1                (bank0_err_csl1_part1              ),
          .bank0_err_csl0_part2                (bank0_err_csl0_part2              ),
          .bank0_err_csl1_part2                (bank0_err_csl1_part2              ),
          .bank0_err_csl0_part3                (bank0_err_csl0_part3              ),
          .bank0_err_csl1_part3                (bank0_err_csl1_part3              ),
          .bank0_err_csl0_part4                (bank0_err_csl0_part4              ),
          .bank0_err_csl1_part4                (bank0_err_csl1_part4              ),
          .bank0_err_csl0_part5                (bank0_err_csl0_part5              ),
          .bank0_err_csl1_part5                (bank0_err_csl1_part5              ),
          .bank0_err_csl0_part6                (bank0_err_csl0_part6              ),
          .bank0_err_csl1_part6                (bank0_err_csl1_part6              ),
          .bank0_err_csl0_part7                (bank0_err_csl0_part7              ),
          .bank0_err_csl1_part7                (bank0_err_csl1_part7              ),
          .bank0_err_csl0_part8                (bank0_err_csl0_part8              ),
          .bank0_err_csl1_part8                (bank0_err_csl1_part8              ),
          .bank0_err_csl0_part9                (bank0_err_csl0_part9              ),
          .bank0_err_csl1_part9                (bank0_err_csl1_part9              ),
          
          .bank0_err_wl0                       (bank0_err_wl0                     ),
          .bank0_err_wl1                       (bank0_err_wl1                     ),
          .bank0_err_wl2                       (bank0_err_wl2                     ),
          .bank0_err_wl3                       (bank0_err_wl3                     ),
          .bank0_err_wl4                       (bank0_err_wl4                     ),
          .bank0_err_wl5                       (bank0_err_wl5                     ),
          .bank0_err_wl6                       (bank0_err_wl6                     ),
          .bank0_err_wl7                       (bank0_err_wl7                     ),
          .bank0_err_wl8                       (bank0_err_wl8                     ),
          .bank0_err_wl9                       (bank0_err_wl9                     ),
          .bank0_err_wl10                      (bank0_err_wl10                    ),
          .bank0_err_wl11                      (bank0_err_wl11                    ),
          .bank0_err_wl12                      (bank0_err_wl12                    ),
          .bank0_err_wl13                      (bank0_err_wl13                    ),
          .bank0_err_wl14                      (bank0_err_wl14                    ),
          .bank0_err_wl15                      (bank0_err_wl15                    ),
          .bank0_err_wl16                      (bank0_err_wl16                    ),
          .bank0_err_wl17                      (bank0_err_wl17                    ),
          .bank0_err_wl18                      (bank0_err_wl18                    ),
          .bank0_err_wl19                      (bank0_err_wl19                    ),
          .bank0_err_wl20                      (bank0_err_wl20                    ),
          .bank0_err_wl21                      (bank0_err_wl21                    ),
          .bank0_err_wl22                      (bank0_err_wl22                    ),
          .bank0_err_wl23                      (bank0_err_wl23                    ),
          .bank0_err_wl24                      (bank0_err_wl24                    ),
          .bank0_err_wl25                      (bank0_err_wl25                    ),
          .bank0_err_wl26                      (bank0_err_wl26                    ),
          .bank0_err_wl27                      (bank0_err_wl27                    ),
          .bank0_err_wl28                      (bank0_err_wl28                    ),
          .bank0_err_wl29                      (bank0_err_wl29                    ),
          .bank0_err_wl30                      (bank0_err_wl30                    ),
          .bank0_err_wl31                      (bank0_err_wl31                    ),
          .bank0_err_wl32                      (bank0_err_wl32                    ),
          .bank0_err_wl33                      (bank0_err_wl33                    ),
          .bank0_err_wl34                      (bank0_err_wl34                    ),
          .bank0_err_wl35                      (bank0_err_wl35                    ),
          .bank0_err_wl36                      (bank0_err_wl36                    ),
          .bank0_err_wl37                      (bank0_err_wl37                    ),
          .bank0_err_wl38                      (bank0_err_wl38                    ),
          .bank0_err_wl39                      (bank0_err_wl39                    ),
          .bank0_err_wl40                      (bank0_err_wl40                    ),
          .bank0_err_wl41                      (bank0_err_wl41                    ),
          .bank0_err_wl42                      (bank0_err_wl42                    ),
          .bank0_err_wl43                      (bank0_err_wl43                    ),
          .bank0_err_wl44                      (bank0_err_wl44                    ),
          .bank0_err_wl45                      (bank0_err_wl45                    ),
          .bank0_err_wl46                      (bank0_err_wl46                    ),
          .bank0_err_wl47                      (bank0_err_wl47                    ),
          .bank0_err_wl48                      (bank0_err_wl48                    ),
          .bank0_err_wl49                      (bank0_err_wl49                    ),
          .bank0_err_wl50                      (bank0_err_wl50                    ),
          .bank0_err_wl51                      (bank0_err_wl51                    ),
          .bank0_err_wl52                      (bank0_err_wl52                    ),
          .bank0_err_wl53                      (bank0_err_wl53                    ),
          .bank0_err_wl54                      (bank0_err_wl54                    ),
          .bank0_err_wl55                      (bank0_err_wl55                    ),
          .bank0_err_wl56                      (bank0_err_wl56                    ),
          .bank0_err_wl57                      (bank0_err_wl57                    ),
          .bank0_err_wl58                      (bank0_err_wl58                    ),
          .bank0_err_wl59                      (bank0_err_wl59                    ),
          .bank0_err_wl60                      (bank0_err_wl60                    ),
          .bank0_err_wl61                      (bank0_err_wl61                    ),
          .bank0_err_wl62                      (bank0_err_wl62                    ),
          .bank0_err_wl63                      (bank0_err_wl63                    ),
          .bank0_err_wl_cnt                    (bank0_err_wl_cnt                  ),
          .bank0_err_wl_cnt_change_flag        (bank0_err_wl_cnt_change_flag      ),
          
          .bank1_err_csl0_part0                (bank1_err_csl0_part0              ),
          .bank1_err_csl1_part0                (bank1_err_csl1_part0              ),
          .bank1_err_csl0_part1                (bank1_err_csl0_part1              ),
          .bank1_err_csl1_part1                (bank1_err_csl1_part1              ),
          .bank1_err_csl0_part2                (bank1_err_csl0_part2              ),
          .bank1_err_csl1_part2                (bank1_err_csl1_part2              ),
          .bank1_err_csl0_part3                (bank1_err_csl0_part3              ),
          .bank1_err_csl1_part3                (bank1_err_csl1_part3              ),
          .bank1_err_csl0_part4                (bank1_err_csl0_part4              ),
          .bank1_err_csl1_part4                (bank1_err_csl1_part4              ),
          .bank1_err_csl0_part5                (bank1_err_csl0_part5              ),
          .bank1_err_csl1_part5                (bank1_err_csl1_part5              ),
          .bank1_err_csl0_part6                (bank1_err_csl0_part6              ),
          .bank1_err_csl1_part6                (bank1_err_csl1_part6              ),
          .bank1_err_csl0_part7                (bank1_err_csl0_part7              ),
          .bank1_err_csl1_part7                (bank1_err_csl1_part7              ),
          .bank1_err_csl0_part8                (bank1_err_csl0_part8              ),
          .bank1_err_csl1_part8                (bank1_err_csl1_part8              ),
          .bank1_err_csl0_part9                (bank1_err_csl0_part9              ),
          .bank1_err_csl1_part9                (bank1_err_csl1_part9              ),
          
          .bank1_err_wl0                       (bank1_err_wl0                     ),
          .bank1_err_wl1                       (bank1_err_wl1                     ),
          .bank1_err_wl2                       (bank1_err_wl2                     ),
          .bank1_err_wl3                       (bank1_err_wl3                     ),
          .bank1_err_wl4                       (bank1_err_wl4                     ),
          .bank1_err_wl5                       (bank1_err_wl5                     ),
          .bank1_err_wl6                       (bank1_err_wl6                     ),
          .bank1_err_wl7                       (bank1_err_wl7                     ),
          .bank1_err_wl8                       (bank1_err_wl8                     ),
          .bank1_err_wl9                       (bank1_err_wl9                     ),
          .bank1_err_wl10                      (bank1_err_wl10                    ),
          .bank1_err_wl11                      (bank1_err_wl11                    ),
          .bank1_err_wl12                      (bank1_err_wl12                    ),
          .bank1_err_wl13                      (bank1_err_wl13                    ),
          .bank1_err_wl14                      (bank1_err_wl14                    ),
          .bank1_err_wl15                      (bank1_err_wl15                    ),
          .bank1_err_wl16                      (bank1_err_wl16                    ),
          .bank1_err_wl17                      (bank1_err_wl17                    ),
          .bank1_err_wl18                      (bank1_err_wl18                    ),
          .bank1_err_wl19                      (bank1_err_wl19                    ),
          .bank1_err_wl20                      (bank1_err_wl20                    ),
          .bank1_err_wl21                      (bank1_err_wl21                    ),
          .bank1_err_wl22                      (bank1_err_wl22                    ),
          .bank1_err_wl23                      (bank1_err_wl23                    ),
          .bank1_err_wl24                      (bank1_err_wl24                    ),
          .bank1_err_wl25                      (bank1_err_wl25                    ),
          .bank1_err_wl26                      (bank1_err_wl26                    ),
          .bank1_err_wl27                      (bank1_err_wl27                    ),
          .bank1_err_wl28                      (bank1_err_wl28                    ),
          .bank1_err_wl29                      (bank1_err_wl29                    ),
          .bank1_err_wl30                      (bank1_err_wl30                    ),
          .bank1_err_wl31                      (bank1_err_wl31                    ),
          .bank1_err_wl32                      (bank1_err_wl32                    ),
          .bank1_err_wl33                      (bank1_err_wl33                    ),
          .bank1_err_wl34                      (bank1_err_wl34                    ),
          .bank1_err_wl35                      (bank1_err_wl35                    ),
          .bank1_err_wl36                      (bank1_err_wl36                    ),
          .bank1_err_wl37                      (bank1_err_wl37                    ),
          .bank1_err_wl38                      (bank1_err_wl38                    ),
          .bank1_err_wl39                      (bank1_err_wl39                    ),
          .bank1_err_wl40                      (bank1_err_wl40                    ),
          .bank1_err_wl41                      (bank1_err_wl41                    ),
          .bank1_err_wl42                      (bank1_err_wl42                    ),
          .bank1_err_wl43                      (bank1_err_wl43                    ),
          .bank1_err_wl44                      (bank1_err_wl44                    ),
          .bank1_err_wl45                      (bank1_err_wl45                    ),
          .bank1_err_wl46                      (bank1_err_wl46                    ),
          .bank1_err_wl47                      (bank1_err_wl47                    ),
          .bank1_err_wl48                      (bank1_err_wl48                    ),
          .bank1_err_wl49                      (bank1_err_wl49                    ),
          .bank1_err_wl50                      (bank1_err_wl50                    ),
          .bank1_err_wl51                      (bank1_err_wl51                    ),
          .bank1_err_wl52                      (bank1_err_wl52                    ),
          .bank1_err_wl53                      (bank1_err_wl53                    ),
          .bank1_err_wl54                      (bank1_err_wl54                    ),
          .bank1_err_wl55                      (bank1_err_wl55                    ),
          .bank1_err_wl56                      (bank1_err_wl56                    ),
          .bank1_err_wl57                      (bank1_err_wl57                    ),
          .bank1_err_wl58                      (bank1_err_wl58                    ),
          .bank1_err_wl59                      (bank1_err_wl59                    ),
          .bank1_err_wl60                      (bank1_err_wl60                    ),
          .bank1_err_wl61                      (bank1_err_wl61                    ),
          .bank1_err_wl62                      (bank1_err_wl62                    ),
          .bank1_err_wl63                      (bank1_err_wl63                    ),
          .bank1_err_wl_cnt                    (bank1_err_wl_cnt                  ),
          .bank1_err_wl_cnt_change_flag        (bank1_err_wl_cnt_change_flag      ),
          .bist_scan_start_bank                (bist_scan_start_bank              ),
          .bist_scan_end_bank                  (bist_scan_end_bank                ),
          .bist_scan_fsm_status                (bist_scan_fsm_status              )     
);

d35_pulse2pulse_aux ipdb_pulse2pulse_inst_u0 ( 
    .clk1   (apb_clk                ),
    .rst1_n (apb_rst_n              ),
    .in     (mc_timeout_clr         ),
    .clk2   (clk                    ),
    .rst2_n (rst_n                  ),
    .out    (mc_timeout_clr_tmp     )    
);
d35_pulse2pulse_aux ipdb_pulse2pulse_inst_u1 ( 
    .clk1   (apb_clk                ),
    .rst1_n (apb_rst_n              ),
    .in     (bist_finish_clr        ),
    .clk2   (clk                    ),
    .rst2_n (rst_n                  ),
    .out    (bist_finish_clr_tmp    )    
);
d35_pulse2pulse_aux ipdb_pulse2pulse_inst_u2 ( 
    .clk1   (apb_clk                ),
    .rst1_n (apb_rst_n              ),
    .in     (hang_timeout_clr       ),
    .clk2   (clk                    ),
    .rst2_n (rst_n                  ),
    .out    (hang_timeout_clr_tmp   )    
);

d35_pulse2pulse_aux ipdb_pulse2pulse_inst_u3 ( 
    .clk1   (apb_clk                ),
    .rst1_n (apb_rst_n              ),
    .in     (rescan_finish_clr      ),
    .clk2   (clk                    ),
    .rst2_n (rst_n                  ),
    .out    (rescan_finish_clr_tmp  )    
);
//assign bist_or_rescan_finish = bist_rescan_finish || bist_finish ;


mc_frame2frame_aux #(
                .FRAME_WIDTH         (FRAME_WIDTH           ),
                .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH  ),
                .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH  ),
                .CHECKBIT_WIDTH      (CHECKBIT_WIDTH        ),
                .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH      ),
                .WL_NUM              (7360                  ),
                .MC_CE_RECORD_NUM    (MC_CE_RECORD_NUM      ),
                .MC_UCE_RECORD_NUM   (MC_UCE_RECORD_NUM     ),
                .MC_ERR_ADDR_WIDTH   (MC_ERR_ADDR_WIDTH     )
        )mc_frame2frame_u(
                .clk                        (clk                    ),
                .rst_n                      (rst_n                  ),
                
                .vmc_wl_en                  (mc_wl_vmc_en_tmp       ),
                .vmc_bl_en                  (mc_bl_vmc_en_tmp       ),
                
                .pre_precharge              (pre_precharge_tmp      ),//pre precharge en
                .inner_precharge            (inner_precharge        ),
                .page_mode_switch           (page_mode_switch_tmp   ),//1:open page,0:close page
                .mc_page_status             (mc_page_status         ),
                .rf_req                     (rf_req                 ),
                .array_fsm_cs               (array_fsm_cs           ),
                .array_fsm_ns               (array_fsm_ns           ),

                .hub_frame_vld              (hub_frame_vld          ),
                .hub_frame_rdy              (hub_frame_rdy          ),
                .hub_frame_data             (hub_frame_data         ),
                
                .mc_rvalid                  (mc_rvalid              ),
                .mc_rdata                   (mc_rdata               ),
                .mc_rresp                   (mc_rresp               ),
                
                .mc_frame_vld               (func_frame_vld         ),
                .mc_frame_rdy               (func_frame_rdy         ),
                .mc_frame_data              (func_frame_data        ),
                
                .array_rvalid               (func_rvalid            ),
                .array_rdata                (func_rdata             ),
                //wy add
                .array_ar_addr              (func_addr              ),                
                .mc_ecc_en                  (mc_ecc_en              ),
                .mc_ecc_ce_th               (mc_ecc_ce_th           ),
                .mc_ecc_ce_int_clr          (mc_ecc_ce_int_clr      ),
                .mc_ecc_ce_overflow_int     (mc_ecc_ce_int_status   ),
                .mc_ecc_ce_cnt              (mc_ecc_ce_cnt          ),
                .mc_ecc_ce_addr             (mc_ecc_ce_addr         ),
                .mc_ecc_ce_addr_vld         (mc_ecc_ce_addr_vld     ),
                .mc_ecc_uce_int_clr         (mc_ecc_uce_int_clr     ),
                .mc_ecc_uce_int             (mc_ecc_uce_int_status  ),
                .mc_ecc_uce_cnt             (mc_ecc_uce_cnt         ),
                .mc_ecc_uce_addr_vld        (mc_ecc_uce_addr_vld    ),
                .mc_ecc_uce_addr            (mc_ecc_uce_addr        ),
                //wy add
                .bist_working               (bist_working           ),
                .dram_init_working          (dram_init_working      )

);

//wy up
bist_rescan_aux_top #(
    .RESCAN_ROUND_NUM   (15             ),
    .MC_CTRL_BANK_NUM   (2              ), 
    .MC_FRAME_WIDTH     (FRAME_WIDTH    )   // wr,sof,eof,bank_sel,ecc,data,row,col
)U_bist_rescan_aux(
  //-------------clock and reset signal--------------
    .clk                      (clk_bist                     ),
    .rst_n                    (rst_n                        ),
    .bist_rescan_sel          (mc_rescan_addr_range_sel_tmp ),
                              
    .global_mc_bist_en        (global_mc_bist_en_tmp        ),
    .global_mc_rescan_start   (global_mc_rescan_start_tmp   ),//default 0
    .mc_bist_en               (mc_bist_en                   ),
    			              
    .bist_rescan_num          (bist_rescan_num              ),//default 3
    //.bist_wl_scan_num         (bist_wl_scan_num             ),
    .bist_rescan_fail_num     (bist_rescan_fail_num         ),
    .rescan_round_result      (rescan_round_result          ),
    //.bist_pattern0            (bist_pattern0                ),
    //.bist_pattern1            (bist_pattern1                ),
    //.bist_pattern2            (bist_pattern2                ),
    //.bist_pattern3            (bist_pattern3                ),
    //.bist_pattern4            (bist_pattern4                ),
    //.bist_pattern5            (bist_pattern5                ),
    //.bist_pattern6            (bist_pattern6                ),
    //.bist_pattern7            (bist_pattern7                ),
    //.bist_pattern8            (bist_pattern8                ),
    //.bist_pattern9            (bist_pattern9                ),
    //.bist_pattern10           (bist_pattern10               ),
    //.bist_pattern11           (bist_pattern11               ),
    //.bist_pattern12           (bist_pattern12               ),
    //.bist_pattern13           (bist_pattern13               ),
    //.bist_pattern14           (bist_pattern14               ),
    //.bist_pattern15           (bist_pattern15               ),
    //.bist_pattern16           (bist_pattern16               ),
    //.bist_pattern17           (bist_pattern17               ),
    //.bist_pattern18           (bist_pattern18               ),
    //.bist_pattern19           (bist_pattern19               ),
    //.bist_pattern20           (bist_pattern20               ),
    //.bist_pattern21           (bist_pattern21               ),
    //.bist_pattern22           (bist_pattern22               ),
    //.bist_pattern23           (bist_pattern23               ),
    //.bist_pattern24           (bist_pattern24               ),
    //.bist_pattern25           (bist_pattern25               ),
    //.bist_pattern26           (bist_pattern26               ),
    //.bist_pattern27           (bist_pattern27               ),
    //.bist_pattern28           (bist_pattern28               ),
    //.bist_pattern29           (bist_pattern29               ),
    //.bist_pattern30           (bist_pattern30               ),
    //.bist_pattern31           (bist_pattern31               ),
    //.bist_pattern32           (bist_pattern32               ),
    //.bist_pattern33           (bist_pattern33               ),
    //.bist_pattern34           (bist_pattern34               ),
    //.bist_pattern35           (bist_pattern35               ),
    //.bist_pattern36           (bist_pattern36               ),
    //.bist_pattern37           (bist_pattern37               ),
    //.bist_pattern38           (bist_pattern38               ),
    //.bist_pattern39           (bist_pattern39               ),
    //.bist_pattern40           (bist_pattern40               ),
    //.bist_pattern41           (bist_pattern41               ),
    //.bist_pattern42           (bist_pattern42               ),
    //.bist_pattern43           (bist_pattern43               ),
    //.bist_pattern44           (bist_pattern44               ),
    //.bist_pattern45           (bist_pattern45               ),
    //.bist_pattern46           (bist_pattern46               ),
    //.bist_pattern47           (bist_pattern47               ),
    //.bist_pattern48           (bist_pattern48               ),
    //.bist_pattern49           (bist_pattern49               ),
    //.bist_pattern50           (bist_pattern50               ),
    //.bist_pattern51           (bist_pattern51               ),
    //.bist_pattern52           (bist_pattern52               ),
    //.bist_pattern53           (bist_pattern53               ),
    //.bist_pattern54           (bist_pattern54               ),
    //.bist_pattern55           (bist_pattern55               ),
    //.bist_pattern56           (bist_pattern56               ),
    //.bist_pattern57           (bist_pattern57               ),
    //.bist_pattern58           (bist_pattern58               ),
    //.bist_pattern59           (bist_pattern59               ),
    //.bist_pattern60           (bist_pattern60               ),
    //.bist_pattern61           (bist_pattern61               ),
    //.bist_pattern62           (bist_pattern62               ),
    //.bist_pattern63           (bist_pattern63               ),
    //.bist_pattern_reg0        (bist_pattern_reg0            ),
    //.bist_pattern_reg1        (bist_pattern_reg1            ),
    //.bist_pattern_reg2        (bist_pattern_reg2            ),
    //.bist_pattern_reg3        (bist_pattern_reg3            ),
    .wl_bist_pattern_sel0     (wl_bist_pattern_sel0         ),
    .wl_bist_pattern_sel1     (wl_bist_pattern_sel1         ),
    .wl_bist_pattern_sel2     (wl_bist_pattern_sel2         ),
    .bist_pattern_all         (bist_pattern_all             ),											              			              
    .bist_rescan_success      (bist_rescan_success          ),
    .bist_rescan_finish       (bist_rescan_finish           ),
    .bist_rescan_finish_status(bist_rescan_finish_status    ),
    //.bist_rescan_finish_status_ras(bist_rescan_finish_status_ras),
    .rescan_finish_clr        (rescan_finish_clr_tmp        ),
    .rescan_finish_mask       (rescan_finish_mask_tmp       ),
    //.rescan_working           (rescan_working     ),
                              
    .rescan_frame_vld         (rescan_frame_vld             ),
    .rescan_frame_rdy         (rescan_frame_rdy             ),
    .rescan_frame_data        (rescan_frame_data            ),//rw_flag,sof,eof,data,row,col
    .rescan_rvalid            (rescan_rvalid                ),
    .rescan_rdata             (rescan_rdata                 ),
    //wy add 
    .bist_scan_start_bank                (bist_scan_start_bank              ),
    .bist_scan_end_bank                  (bist_scan_end_bank                ),
    .bank0_bist_rescan_success           (                                  ),
    .bank0_bist_rescan_finish            (                                  ),
    .bank0_bist_rescan_finish_status     (                                  ),
    .bank1_bist_rescan_success           (                                  ),
    .bank1_bist_rescan_finish            (                                  ),
    .bank1_bist_rescan_finish_status     (                                  ),
    .bank_scan_fsm_status                (bank_scan_fsm_status              )                 
);


//wy up
dram_init_wr_top #(
                .ROW_ADDR_WIDTH           (ARRAY_ROW_ADDR_WIDTH  ),
                .COL_ADDR_WIDTH           (ARRAY_COL_ADDR_WIDTH  ),
                .WL_NUM                   (7360                  ),
                .FRAME_WIDTH              (FRAME_WIDTH           )
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


//wy up
mc_frame_arbiter_aux #(
               .AXI_SLV_NUM         (6),
               .TDATA_WIDTH         (FRAME_WIDTH                    ),//256bit data,10bit checkbit,21bit addr,2bit wy up
               .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH+CHECKBIT_WIDTH)

)frame_arbiter_u(
                .clk                 (clk                  ),
                .rst_n               (rst_n                ),
                
                .s_tvalid            ({dram_init_frame_vld,rescan_frame_vld_tmp,func_frame_vld_tmp,wl_scan_frame_vld_tmp,csl_scan_frame_vld_tmp,bank_scan_frame_vld_tmp}   ),
                .s_tready            ({dram_init_frame_rdy,rescan_frame_rdy_tmp,func_frame_rdy_tmp,wl_scan_frame_rdy_tmp,csl_scan_frame_rdy_tmp,bank_scan_frame_rdy_tmp}   ),
                //.s_tdata             ({1'b1,dram_init_frame_data,1'b1,rescan_frame_data,func_frame_data,1'b1,wl_scan_frame_data,1'b1,csl_scan_frame_data,1'b1,bank_scan_frame_data}),
                .s_tdata             ({dram_init_frame_data,rescan_frame_data,func_frame_data,wl_scan_frame_data,csl_scan_frame_data,bank_scan_frame_data}),
                
                .m_tvalid            (mc_frame_vld         ),
                .m_tready            (mc_frame_rdy         ),
                .m_tdata             (mc_frame_data        ),


                .array_rvalid        (arb_rvalid           ),
                .array_rdata         (arb_rdata            ),
                .array_addr          (arb_addr             ),

                .bist_path_rvalid    (bank_scan_rvalid     ),
                .bist_path_rdata     (bank_scan_rdata      ),          

                .bist_csl_rvalid     (csl_scan_rvalid      ),
                .bist_csl_rdata      (csl_scan_rdata       ),      
                
                .bist_wl_rvalid      (wl_scan_rvalid       ),
                .bist_wl_rdata       (wl_scan_rdata        ),     
 
                .func_rvalid         (func_rvalid          ),
                .func_rdata          (func_rdata           ),
                .func_addr           (func_addr            ),

                .rescan_rvalid       (rescan_rvalid        ),
                .rescan_rdata        (rescan_rdata         )

);

//wy add
always @* begin
    if(mc_frame_vld) begin
        case(mc_frame_data[288:287])
            2'b00: begin
                remap_wl_addr = remap_bank0_wl_addr;
                remap_csl_addr = remap_bank0_csl_addr;
            end
            2'b01: begin
                remap_wl_addr = remap_bank0_wl_addr;
                remap_csl_addr = remap_bank0_csl_addr;
            end
            2'b10: begin
                remap_wl_addr = remap_bank1_wl_addr;
                remap_csl_addr = remap_bank1_csl_addr;
            end
            2'b11: begin
                remap_wl_addr = remap_bank0_wl_addr;
                remap_csl_addr = remap_bank0_csl_addr;
            end
        endcase
    end
    else begin
        remap_wl_addr = remap_bank0_wl_addr;
        remap_csl_addr = remap_bank0_csl_addr;
    end
end

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
        .mc_addr               (arb_addr                   ),
                
        .mc_frame_vld          (array_frame_vld            ),
        .mc_frame_rdy          (array_frame_rdy            ),
        .mc_frame_data         (array_frame_data           ),
        
        .array_rvalid          (array_rvalid               ),
        .array_rdata           (array_rdata                ),
        .array_addr            (array_addr                 )
   
);

                


frame2array_aux #(
                .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH      ),
                .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH  ),
                .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH  ),
                .CHECKBIT_WIDTH      (CHECKBIT_WIDTH        ),
                .MC_FRAME_WIDTH      (FRAME_WIDTH           ),
                .ARRAY_RSV_WIDTH     (ARRAY_RSV_WIDTH       )
        )frame2array_u(
                .clk                   (clk                 ),
                .rst_n                 (rst_n               ),
                .ras_clr               (ras_clr             ),
                .mc_en                 (mc_en_tmp           ),
                .mc_rf_start           (mc_rf_start         ),
                .global_rf_sel_en      (global_rf_sel_en_tmp),
                .global_rf_cnt_clr     (global_rf_cnt_clr_tmp),
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
                .array_addr            (array_addr          ),
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
                //rf 
                .mc_rf_start_sel       (mc_rf_start_sel_tmp ),
                .rf_start_time         (rf_start_time       ),
                .rf_period             (rf_period           ),
                .rf_period_up_en       (rf_period_up_en     ),
                .mc_rf_period_sel      (mc_rf_period_sel_tmp)

    );

assign monitor_signals = {
                        72'd0,       
                        bank_scan_fsm_status, // 2bit
                        bist_scan_fsm_status, // 2bit
                        hub_frame_data[FRAME_WIDTH-CHECKBIT_WIDTH-4:FRAME_WIDTH-5-CHECKBIT_WIDTH],
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
                        mc_en              
                        };

//------------------dbg frame/data store begin---------------------
  always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0) begin
      dbg_store_latest_frame <= {FRAME_WIDTH-2{1'b0}};
    end
    else if (dbg_data_store_en && hub_frame_vld && hub_frame_rdy)begin
      dbg_store_latest_frame[FRAME_WIDTH-CHECKBIT_WIDTH-2-1:0] <= hub_frame_data;
      dbg_store_latest_frame[289:280] <= 'd0;

    end
  end
  always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0) begin
      dbg_store_latest_rdata <= {ARRAY_DATA_WIDTH+CHECKBIT_WIDTH{1'b0}};
    end
    else if (dbg_data_store_en && mc_rvalid)begin
      dbg_store_latest_rdata[ARRAY_DATA_WIDTH-1:0] <= mc_rdata;
      dbg_store_latest_rdata[ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:ARRAY_DATA_WIDTH] <= {CHECKBIT_WIDTH{1'b1}};
    end
  end

//------------------dbg frame/data store begin---------------------


endmodule
