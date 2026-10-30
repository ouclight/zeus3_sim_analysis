module bist_scan_top_aux #(
    parameter   ARRAY_ADDR_WIDTH      = 13+8                               ,
    parameter   MC_SHORT_MODE         = 4                                  ,
    parameter   CHECKBIT_WIDTH        = 16                                 ,
    parameter   ARRAY_ROW_ADDR_WIDTH  = 13                                 ,
    parameter   ARRAY_COL_ADDR_WIDTH  = 8                                  ,
    parameter   ARRAY_DATA_WIDTH      = 256  
)(
  //-------------clock and reset signal--------------
  input                                                                      clk                                 ,
  input                                                                      rst_n                               ,
  input                                                                      global_bist_clr                     ,
  input      [3:0]                                                           mc_bist_grant                       ,//{bank3_grt,bank2_grt,bank1_grt,bank0_grt}
  input      [1:0]                                                           short_mode                          ,

  //-------------control signal----------------------                       
  input                                                                      global_mc_bist_start                ,
  input                                                                      global_mc_bist_en                   ,
  input                                                                      mc_bist_en                          ,
  input                                                                      bist_csl_vmc_en                     ,//default 1


  input                                                                      csl_scan_addr_range_sel             ,//default 1,scan all addr
  input                                                                      csl_scan_check_sel                  ,//default 1,check 266 bit rdata
  input      [3:0]                                                           wl_single_pattern_rd_num            ,//max 16,default 1:read one time
  input      [67:0]                                                          csl_bist_pattern_sel                ,//every bit correspond to every pattern,1:valid
  input      [67:0]                                                          wl_bist_pattern_sel                 ,
  input                                                                      csl_scan_mode_sel                   ,//0:abort 1:continue,default 0
  input      [68*32-1:0]                                                     bist_pattern_all                    ,
  

  output                                                                     bist_success_status                 ,
  //output                                                                     bist_finish_status                  ,
  output                                                                     bist_finish_intr                    ,
  input                                                                      bist_finish_clr                     ,
  input                                                                      bist_finish_int_mask                ,
  input      [4:0]                                                           csl_err_threshold                   ,
  input                                                                      mc_timeout_flag                     ,
  output     [2:0]                                                           bist_scan_status                    , //wl_scan_working,csl_scan_working,bank_scan_working
  //-------------data signal------------------------
  output                                                                     bank_scan_frame_vld                 ,
  input                                                                      bank_scan_frame_rdy                 ,
  output     [3+ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ADDR_WIDTH+2-1 :0]     bank_scan_frame_data                ,//rw_flag,sof,eof,data,row,col
  input                                                                      bank_scan_rvalid                    ,
  input      [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                           bank_scan_rdata                     ,

  output                                                                     csl_scan_frame_vld                  ,
  input                                                                      csl_scan_frame_rdy                  ,
  output     [3+ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ADDR_WIDTH+2-1 :0]     csl_scan_frame_data                 ,//rw_flag,sof,eof,data,row,col
  input                                                                      csl_scan_rvalid                     ,
  input      [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                           csl_scan_rdata                      ,

  output                                                                     wl_scan_frame_vld                   ,
  input                                                                      wl_scan_frame_rdy                   ,
  output     [3+ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ADDR_WIDTH+2-1 :0]     wl_scan_frame_data                  ,//rw_flag,sof,eof,data,row,col
  input                                                                      wl_scan_rvalid                      ,
  input      [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                           wl_scan_rdata                       ,
  //-------------error wl record signal------------
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl0_part0                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl1_part0                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl0_part1                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl1_part1                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl0_part2                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl1_part2                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl0_part3                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl1_part3                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl0_part4                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl1_part4                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl0_part5                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl1_part5                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl0_part6                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl1_part6                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl0_part7                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl1_part7                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl0_part8                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl1_part8                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl0_part9                 ,
  output     [ARRAY_COL_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_csl1_part9                 ,
 
 
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl0                       ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl1                       ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl2                       ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl3                       ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl4                       ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl5                       ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl6                       ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl7                       ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl8                       ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl9                       ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl10                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl11                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl12                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl13                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl14                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl15                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl16                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl17                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl18                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl19                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl20                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl21                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl22                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl23                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl24                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl25                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl26                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl27                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl28                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl29                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl30                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl31                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl32                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl33                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl34                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl35                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl36                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl37                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl38                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl39                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl40                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl41                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl42                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl43                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl44                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl45                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl46                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl47                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl48                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl49                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl50                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl51                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl52                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl53                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl54                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl55                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl56                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl57                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl58                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl59                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl60                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl61                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl62                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl63                      ,
// -- 202500702 modify by yy --begin 
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl64                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl65                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl66                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl67                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl68                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl69                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl70                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl71                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl72                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl73                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl74                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl75                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl76                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl77                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl78                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl79                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl80                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl81                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl82                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl83                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl84                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl85                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl86                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl87                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl88                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl89                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl90                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl91                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl92                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl93                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl94                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl95                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl96                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl97                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl98                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl99                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl100                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl101                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl102                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl103                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl104                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl105                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl106                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl107                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl108                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl109                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl110                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl111                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl112                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl113                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl114                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl115                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl116                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl117                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl118                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl119                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl120                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl121                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl122                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl123                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl124                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl125                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl126                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl127                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl128                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl129                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl130                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl131                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl132                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl133                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl134                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl135                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl136                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl137                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl138                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl139                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl140                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl141                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl142                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl143                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl144                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl145                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl146                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl147                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl148                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl149                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl150                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl151                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl152                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl153                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl154                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl155                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl156                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl157                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl158                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl159                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl160                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl161                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl162                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl163                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl164                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl165                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl166                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl167                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl168                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl169                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl170                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl171                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl172                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl173                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl174                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl175                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl176                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl177                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl178                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl179                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl180                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl181                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl182                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl183                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl184                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl185                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl186                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl187                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl188                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl189                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl190                      ,
  output     [ARRAY_ROW_ADDR_WIDTH*MC_SHORT_MODE-1:0]                        bank_err_wl191                      ,
// --end 

// -- 202500702 modify by yy --begin 
  // output     [7*MC_SHORT_MODE-1:0]                                           bank_err_wl_cnt                    , 
  output     [8*MC_SHORT_MODE-1:0]                                           bank_err_wl_cnt                    , 
// --end 
  output     [MC_SHORT_MODE-1:0]                                             bank_err_wl_cnt_change_flag        ,

  output     [MC_SHORT_MODE-1:0]                                             bank_bist_finish                   ,

  output     [MC_SHORT_MODE-1:0]                                             bank_bist_success                  ,

  output     [MC_SHORT_MODE-1:0]                                             bank_bist_bank_fail                


                            
);
//---------------------------------------------------------------
//wire and reg define
wire                                                                    wl_init_frame_vld    ;
wire                                                                    wl_init_frame_rdy    ;
wire     [3+ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ADDR_WIDTH-2 :0]      wl_init_frame_data   ;//rw_flag,sof,eof,data,row,col
wire                                                                    wl_init_rvalid       ;
wire     [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                          wl_init_rdata        ; 

wire                                                                    bist_bank_success    ;
wire                                                                    bank_scan_finish     ;
wire                                                                    csl_scan_finish      ;
wire                                                                    bank_scan_working    ;
wire                                                                    csl_scan_working     ;
wire                                                                    wl_scan_working      ;
wire                                                                    bist_csl_fail        ;

reg      [68*32-1:0]                                                    csl_selected_pattern ;
reg      [6:0]                                                          csl_pattern_index    ;

reg      [68*32-1:0]                                                    wl_selected_pattern  ;
reg      [6:0]                                                          wl_pattern_index     ;

wire     [1:0]                                                          bist_layer_id        ;
wire                                                                    bist_serial_start    ;
integer  II;

wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl0_part0_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl1_part0_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl0_part1_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl1_part1_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl0_part2_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl1_part2_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl0_part3_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl1_part3_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl0_part4_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl1_part4_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl0_part5_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl1_part5_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl0_part6_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl1_part6_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl0_part7_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl1_part7_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl0_part8_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl1_part8_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl0_part9_tmp  ;
wire     [ARRAY_COL_ADDR_WIDTH-1:0]                                     bank_err_csl1_part9_tmp  ;

wire                                                                    bank_bist_finish_int ;

reg                                                                     bank3_bist_work             ;
wire     [MC_SHORT_MODE-1:0]                                            all_bank_bist_finish_status ;
wire     [MC_SHORT_MODE-1:0]                                            all_bank_bist_success_status;

wire     [MC_SHORT_MODE-1:0]                                           bank_bist_wl_success         ;
wire     [MC_SHORT_MODE-1:0]                                           bank_bist_wl_finish          ;
reg                                                                     grant_bist_finish           ;
reg                                                                     grant_bist_success          ;

reg      [2:0]                                                          index                       ;
wire     [2:0]                                                          bist_scan_fsm               ;
wire                                                                    bank_bist_csl_fail          ;
wire                                                                    bist_finish_status          ;
//-----------------------bist FSM-------------------------

reg     [2:0]   SCAN_CS;
reg     [2:0]   SCAN_NS;

localparam IDLE       = 3'b000,
           BANK0      = 3'b001,
           BANK1      = 3'b010,
           BANK2      = 3'b011,
           BANK3      = 3'b100 ;



always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)
        SCAN_CS <= IDLE;
    else 
        SCAN_CS <= SCAN_NS;
end



assign bist_layer_id = SCAN_CS - 1'b1;
assign bist_scan_fsm = SCAN_CS ;
assign bist_serial_start = global_mc_bist_start || (SCAN_CS != SCAN_NS && SCAN_CS != IDLE && SCAN_NS != IDLE);

//---------------------------------------------------------------
bist_scan_aux #(
          .ARRAY_ADDR_WIDTH      (ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH ),
          .CHECKBIT_WIDTH        (CHECKBIT_WIDTH                            ),
          .MC_SHORT_MODE         (MC_SHORT_MODE                             ),
          .ARRAY_ROW_ADDR_WIDTH  (ARRAY_ROW_ADDR_WIDTH                      ),
          .ARRAY_COL_ADDR_WIDTH  (ARRAY_COL_ADDR_WIDTH                      ),
          .ARRAY_DATA_WIDTH      (ARRAY_DATA_WIDTH                          )
)bist_scan_u(
  //-------------clock and reset signal--------------
          .clk                                 (clk                               ),
          .rst_n                               (rst_n                             ),
          .global_bist_clr                     (global_bist_clr                   ),
          .bist_layer_id                       (bist_layer_id                     ),
          .bist_scan_fsm                       (bist_scan_fsm                     ),
          
          .global_mc_bist_start                (bist_serial_start                 ),
          .global_mc_bist_en                   (global_mc_bist_en                 ),
          .mc_bist_en                          (mc_bist_en                        ),
          .bist_csl_vmc_en                     (bist_csl_vmc_en                   ),
          .csl_scan_addr_range_sel             (csl_scan_addr_range_sel           ),//default 1,scan all addr
          .csl_scan_check_sel                  (csl_scan_check_sel                ),//default 1,check 272 bit rdata
          .csl_scan_mode_sel                   (csl_scan_mode_sel                 ),//0:abort 1:continue,default 0
 
          .wl_single_pattern_rd_num            (wl_single_pattern_rd_num          ),
          .csl_bist_pattern_sel                (csl_bist_pattern_sel              ),
          .wl_bist_pattern_sel                 (wl_bist_pattern_sel               ),
          .bist_pattern_all                    (bist_pattern_all                  ),
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
          
          .err_csl0_part0                      (bank_err_csl0_part0_tmp           ),
          .err_csl1_part0                      (bank_err_csl1_part0_tmp           ),
          .err_csl0_part1                      (bank_err_csl0_part1_tmp           ),
          .err_csl1_part1                      (bank_err_csl1_part1_tmp           ),
          .err_csl0_part2                      (bank_err_csl0_part2_tmp           ),
          .err_csl1_part2                      (bank_err_csl1_part2_tmp           ),
          .err_csl0_part3                      (bank_err_csl0_part3_tmp           ),
          .err_csl1_part3                      (bank_err_csl1_part3_tmp           ),
          .err_csl0_part4                      (bank_err_csl0_part4_tmp           ),
          .err_csl1_part4                      (bank_err_csl1_part4_tmp           ),
          .err_csl0_part5                      (bank_err_csl0_part5_tmp           ),
          .err_csl1_part5                      (bank_err_csl1_part5_tmp           ),
          .err_csl0_part6                      (bank_err_csl0_part6_tmp           ),
          .err_csl1_part6                      (bank_err_csl1_part6_tmp           ),
          .err_csl0_part7                      (bank_err_csl0_part7_tmp           ),
          .err_csl1_part7                      (bank_err_csl1_part7_tmp           ),
          .err_csl0_part8                      (bank_err_csl0_part8_tmp           ),
          .err_csl1_part8                      (bank_err_csl1_part8_tmp           ),
          .err_csl0_part9                      (bank_err_csl0_part9_tmp           ),
          .err_csl1_part9                      (bank_err_csl1_part9_tmp           ),

          
          .err_wl0                             (bank_err_wl0                      ),
          .err_wl1                             (bank_err_wl1                      ),
          .err_wl2                             (bank_err_wl2                      ),
          .err_wl3                             (bank_err_wl3                      ),
          .err_wl4                             (bank_err_wl4                      ),
          .err_wl5                             (bank_err_wl5                      ),
          .err_wl6                             (bank_err_wl6                      ),
          .err_wl7                             (bank_err_wl7                      ),
          .err_wl8                             (bank_err_wl8                      ),
          .err_wl9                             (bank_err_wl9                      ),
          .err_wl10                            (bank_err_wl10                     ),
          .err_wl11                            (bank_err_wl11                     ),
          .err_wl12                            (bank_err_wl12                     ),
          .err_wl13                            (bank_err_wl13                     ),
          .err_wl14                            (bank_err_wl14                     ),
          .err_wl15                            (bank_err_wl15                     ),
          .err_wl16                            (bank_err_wl16                     ),
          .err_wl17                            (bank_err_wl17                     ),
          .err_wl18                            (bank_err_wl18                     ),
          .err_wl19                            (bank_err_wl19                     ),
          .err_wl20                            (bank_err_wl20                     ),
          .err_wl21                            (bank_err_wl21                     ),
          .err_wl22                            (bank_err_wl22                     ),
          .err_wl23                            (bank_err_wl23                     ),
          .err_wl24                            (bank_err_wl24                     ),
          .err_wl25                            (bank_err_wl25                     ),
          .err_wl26                            (bank_err_wl26                     ),
          .err_wl27                            (bank_err_wl27                     ),
          .err_wl28                            (bank_err_wl28                     ),
          .err_wl29                            (bank_err_wl29                     ),
          .err_wl30                            (bank_err_wl30                     ),
          .err_wl31                            (bank_err_wl31                     ),
          .err_wl32                            (bank_err_wl32                     ),
          .err_wl33                            (bank_err_wl33                     ),
          .err_wl34                            (bank_err_wl34                     ),
          .err_wl35                            (bank_err_wl35                     ),
          .err_wl36                            (bank_err_wl36                     ),
          .err_wl37                            (bank_err_wl37                     ),
          .err_wl38                            (bank_err_wl38                     ),
          .err_wl39                            (bank_err_wl39                     ),
          .err_wl40                            (bank_err_wl40                     ),
          .err_wl41                            (bank_err_wl41                     ),
          .err_wl42                            (bank_err_wl42                     ),
          .err_wl43                            (bank_err_wl43                     ),
          .err_wl44                            (bank_err_wl44                     ),
          .err_wl45                            (bank_err_wl45                     ),
          .err_wl46                            (bank_err_wl46                     ),
          .err_wl47                            (bank_err_wl47                     ),
          .err_wl48                            (bank_err_wl48                     ),
          .err_wl49                            (bank_err_wl49                     ),
          .err_wl50                            (bank_err_wl50                     ),
          .err_wl51                            (bank_err_wl51                     ),
          .err_wl52                            (bank_err_wl52                     ),
          .err_wl53                            (bank_err_wl53                     ),
          .err_wl54                            (bank_err_wl54                     ),
          .err_wl55                            (bank_err_wl55                     ),
          .err_wl56                            (bank_err_wl56                     ),
          .err_wl57                            (bank_err_wl57                     ),
          .err_wl58                            (bank_err_wl58                     ),
          .err_wl59                            (bank_err_wl59                     ),
          .err_wl60                            (bank_err_wl60                     ),
          .err_wl61                            (bank_err_wl61                     ),
          .err_wl62                            (bank_err_wl62                     ),
          .err_wl63                            (bank_err_wl63                     ),
// -- 202500702 modify by yy --begin 
          .err_wl64                            (bank_err_wl64                     ),
          .err_wl65                            (bank_err_wl65                     ),
          .err_wl66                            (bank_err_wl66                     ),
          .err_wl67                            (bank_err_wl67                     ),
          .err_wl68                            (bank_err_wl68                     ),
          .err_wl69                            (bank_err_wl69                     ),
          .err_wl70                            (bank_err_wl70                     ),
          .err_wl71                            (bank_err_wl71                     ),
          .err_wl72                            (bank_err_wl72                     ),
          .err_wl73                            (bank_err_wl73                     ),
          .err_wl74                            (bank_err_wl74                     ),
          .err_wl75                            (bank_err_wl75                     ),
          .err_wl76                            (bank_err_wl76                     ),
          .err_wl77                            (bank_err_wl77                     ),
          .err_wl78                            (bank_err_wl78                     ),
          .err_wl79                            (bank_err_wl79                     ),
          .err_wl80                            (bank_err_wl80                     ),
          .err_wl81                            (bank_err_wl81                     ),
          .err_wl82                            (bank_err_wl82                     ),
          .err_wl83                            (bank_err_wl83                     ),
          .err_wl84                            (bank_err_wl84                     ),
          .err_wl85                            (bank_err_wl85                     ),
          .err_wl86                            (bank_err_wl86                     ),
          .err_wl87                            (bank_err_wl87                     ),
          .err_wl88                            (bank_err_wl88                     ),
          .err_wl89                            (bank_err_wl89                     ),
          .err_wl90                            (bank_err_wl90                     ),
          .err_wl91                            (bank_err_wl91                     ),
          .err_wl92                            (bank_err_wl92                     ),
          .err_wl93                            (bank_err_wl93                     ),
          .err_wl94                            (bank_err_wl94                     ),
          .err_wl95                            (bank_err_wl95                     ),
          .err_wl96                            (bank_err_wl96                     ),
          .err_wl97                            (bank_err_wl97                     ),
          .err_wl98                            (bank_err_wl98                     ),
          .err_wl99                            (bank_err_wl99                     ),
          .err_wl100                            (bank_err_wl100                     ),
          .err_wl101                            (bank_err_wl101                     ),
          .err_wl102                            (bank_err_wl102                     ),
          .err_wl103                            (bank_err_wl103                     ),
          .err_wl104                            (bank_err_wl104                     ),
          .err_wl105                            (bank_err_wl105                     ),
          .err_wl106                            (bank_err_wl106                     ),
          .err_wl107                            (bank_err_wl107                     ),
          .err_wl108                            (bank_err_wl108                     ),
          .err_wl109                            (bank_err_wl109                     ),
          .err_wl110                            (bank_err_wl110                     ),
          .err_wl111                            (bank_err_wl111                     ),
          .err_wl112                            (bank_err_wl112                     ),
          .err_wl113                            (bank_err_wl113                     ),
          .err_wl114                            (bank_err_wl114                     ),
          .err_wl115                            (bank_err_wl115                     ),
          .err_wl116                            (bank_err_wl116                     ),
          .err_wl117                            (bank_err_wl117                     ),
          .err_wl118                            (bank_err_wl118                     ),
          .err_wl119                            (bank_err_wl119                     ),
          .err_wl120                            (bank_err_wl120                     ),
          .err_wl121                            (bank_err_wl121                     ),
          .err_wl122                            (bank_err_wl122                     ),
          .err_wl123                            (bank_err_wl123                     ),
          .err_wl124                            (bank_err_wl124                     ),
          .err_wl125                            (bank_err_wl125                     ),
          .err_wl126                            (bank_err_wl126                     ),
          .err_wl127                            (bank_err_wl127                     ),
          .err_wl128                            (bank_err_wl128                     ),
          .err_wl129                            (bank_err_wl129                     ),
          .err_wl130                            (bank_err_wl130                     ),
          .err_wl131                            (bank_err_wl131                     ),
          .err_wl132                            (bank_err_wl132                     ),
          .err_wl133                            (bank_err_wl133                     ),
          .err_wl134                            (bank_err_wl134                     ),
          .err_wl135                            (bank_err_wl135                     ),
          .err_wl136                            (bank_err_wl136                     ),
          .err_wl137                            (bank_err_wl137                     ),
          .err_wl138                            (bank_err_wl138                     ),
          .err_wl139                            (bank_err_wl139                     ),
          .err_wl140                            (bank_err_wl140                     ),
          .err_wl141                            (bank_err_wl141                     ),
          .err_wl142                            (bank_err_wl142                     ),
          .err_wl143                            (bank_err_wl143                     ),
          .err_wl144                            (bank_err_wl144                     ),
          .err_wl145                            (bank_err_wl145                     ),
          .err_wl146                            (bank_err_wl146                     ),
          .err_wl147                            (bank_err_wl147                     ),
          .err_wl148                            (bank_err_wl148                     ),
          .err_wl149                            (bank_err_wl149                     ),
          .err_wl150                            (bank_err_wl150                     ),
          .err_wl151                            (bank_err_wl151                     ),
          .err_wl152                            (bank_err_wl152                     ),
          .err_wl153                            (bank_err_wl153                     ),
          .err_wl154                            (bank_err_wl154                     ),
          .err_wl155                            (bank_err_wl155                     ),
          .err_wl156                            (bank_err_wl156                     ),
          .err_wl157                            (bank_err_wl157                     ),
          .err_wl158                            (bank_err_wl158                     ),
          .err_wl159                            (bank_err_wl159                     ),
          .err_wl160                            (bank_err_wl160                     ),
          .err_wl161                            (bank_err_wl161                     ),
          .err_wl162                            (bank_err_wl162                     ),
          .err_wl163                            (bank_err_wl163                     ),
          .err_wl164                            (bank_err_wl164                     ),
          .err_wl165                            (bank_err_wl165                     ),
          .err_wl166                            (bank_err_wl166                     ),
          .err_wl167                            (bank_err_wl167                     ),
          .err_wl168                            (bank_err_wl168                     ),
          .err_wl169                            (bank_err_wl169                     ),
          .err_wl170                            (bank_err_wl170                     ),
          .err_wl171                            (bank_err_wl171                     ),
          .err_wl172                            (bank_err_wl172                     ),
          .err_wl173                            (bank_err_wl173                     ),
          .err_wl174                            (bank_err_wl174                     ),
          .err_wl175                            (bank_err_wl175                     ),
          .err_wl176                            (bank_err_wl176                     ),
          .err_wl177                            (bank_err_wl177                     ),
          .err_wl178                            (bank_err_wl178                     ),
          .err_wl179                            (bank_err_wl179                     ),
          .err_wl180                            (bank_err_wl180                     ),
          .err_wl181                            (bank_err_wl181                     ),
          .err_wl182                            (bank_err_wl182                     ),
          .err_wl183                            (bank_err_wl183                     ),
          .err_wl184                            (bank_err_wl184                     ),
          .err_wl185                            (bank_err_wl185                     ),
          .err_wl186                            (bank_err_wl186                     ),
          .err_wl187                            (bank_err_wl187                     ),
          .err_wl188                            (bank_err_wl188                     ),
          .err_wl189                            (bank_err_wl189                     ),
          .err_wl190                            (bank_err_wl190                     ),
          .err_wl191                            (bank_err_wl191                     ),
          // --end 
          .bank_err_wl_cnt                     (bank_err_wl_cnt                   ),

          .bank_err_wl_cnt_change_flag         (bank_err_wl_cnt_change_flag       ),

          .bank_bist_wl_success                (bank_bist_wl_success              ),
           
          .bank_bist_wl_finish                 (bank_bist_wl_finish               ),

          .bist_bank_success                   (bank_bist_bank_success            ),
          .bist_csl_fail                       (bank_bist_csl_fail                ),
          .bist_bank_fail                      (bank_bist_bank_fail_tmp           ),
//          .bist_finish_int_mask                (bist_finish_mask                  ),
          .bist_finish_clr                     (bist_finish_clr                   )
);





generate
if(MC_SHORT_MODE==4)begin:inst0
reg                                                             bank0_bist_success                 ;
reg                                                             bank1_bist_success                 ;
reg                                                             bank2_bist_success                 ;
reg                                                             bank3_bist_success                 ;
reg                                                             bank0_bist_finish                  ;
reg                                                             bank1_bist_finish                  ;
reg                                                             bank2_bist_finish                  ;
reg                                                             bank3_bist_finish                  ;
reg                                                             bank3_bist_work                    ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part9               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part9               ;

reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part9               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part9               ;

reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part9               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part9               ;

wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl0_part0               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl1_part0               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl0_part1               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl1_part1               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl0_part2               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl1_part2               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl0_part3               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl1_part3               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl0_part4               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl1_part4               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl0_part5               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl1_part5               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl0_part6               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl1_part6               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl0_part7               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl1_part7               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl0_part8               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl1_part8               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl0_part9               ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                                 bank3_err_csl1_part9               ;

reg                                                             bank0_bist_bank_fail               ;
reg                                                             bank1_bist_bank_fail               ;
reg                                                             bank2_bist_bank_fail               ;
wire                                                            bank3_bist_bank_fail               ;

always @(*)begin
    case(SCAN_CS)
    IDLE:begin
        if(global_mc_bist_start && mc_bist_grant[0])
            SCAN_NS = BANK0;
        else if(global_mc_bist_start && mc_bist_grant[1:0]==2'b10)
            SCAN_NS = BANK1;
        else if(global_mc_bist_start && mc_bist_grant[2:0]==3'b100)
            SCAN_NS = BANK2;
        else if(global_mc_bist_start && mc_bist_grant[3:0]==4'b1000)
            SCAN_NS = BANK3;        
        else
            SCAN_NS = SCAN_CS;
    end
    BANK0:begin
        if(bank0_bist_finish && mc_bist_grant[3:1]==3'b000)
            SCAN_NS = IDLE;
        else if(bank0_bist_finish && mc_bist_grant[1])
            SCAN_NS = BANK1;
        else if(bank0_bist_finish && mc_bist_grant[2:1]==2'b10)
            SCAN_NS = BANK2;
        else if(bank0_bist_finish && mc_bist_grant[3:1]==3'b100)
            SCAN_NS = BANK3;
        else
            SCAN_NS = SCAN_CS;
    end
    BANK1:begin
        if(bank1_bist_finish && mc_bist_grant[3:2]==2'b00)
            SCAN_NS = IDLE;
        else if(bank1_bist_finish && mc_bist_grant[2])
            SCAN_NS = BANK2;
        else if(bank1_bist_finish && mc_bist_grant[3:2]==2'b10)
            SCAN_NS = BANK3;
        else
            SCAN_NS = SCAN_CS;
    end
    BANK2:begin
        if(bank2_bist_finish && mc_bist_grant[3]==1'b0)
            SCAN_NS = IDLE;
        else if(bank2_bist_finish && mc_bist_grant[3])
            SCAN_NS = BANK3;
        else
            SCAN_NS = SCAN_CS;
    end
    BANK3:begin
        if(bank3_bist_finish)
            SCAN_NS = IDLE;
        else
            SCAN_NS = SCAN_CS;
    end
    default:SCAN_NS = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank0_err_csl0_part0 <= 8'hFF;
        bank0_err_csl1_part0 <= 8'hFF;
        bank0_err_csl0_part1 <= 8'hFF;
        bank0_err_csl1_part1 <= 8'hFF;
        bank0_err_csl0_part2 <= 8'hFF;
        bank0_err_csl1_part2 <= 8'hFF;
        bank0_err_csl0_part3 <= 8'hFF;
        bank0_err_csl1_part3 <= 8'hFF;
        bank0_err_csl0_part4 <= 8'hFF;
        bank0_err_csl1_part4 <= 8'hFF;
        bank0_err_csl0_part5 <= 8'hFF;
        bank0_err_csl1_part5 <= 8'hFF;
        bank0_err_csl0_part6 <= 8'hFF;
        bank0_err_csl1_part6 <= 8'hFF;
        bank0_err_csl0_part7 <= 8'hFF;
        bank0_err_csl1_part7 <= 8'hFF;
        bank0_err_csl0_part8 <= 8'hFF;
        bank0_err_csl1_part8 <= 8'hFF;
        bank0_err_csl0_part9 <= 8'hFF;
        bank0_err_csl1_part9 <= 8'hFF;
        bank0_bist_bank_fail  <= 1'b0;
        
    end
    else if(global_mc_bist_start)begin
        bank0_err_csl0_part0 <= 8'hFF;
        bank0_err_csl1_part0 <= 8'hFF;
        bank0_err_csl0_part1 <= 8'hFF;
        bank0_err_csl1_part1 <= 8'hFF;
        bank0_err_csl0_part2 <= 8'hFF;
        bank0_err_csl1_part2 <= 8'hFF;
        bank0_err_csl0_part3 <= 8'hFF;
        bank0_err_csl1_part3 <= 8'hFF;
        bank0_err_csl0_part4 <= 8'hFF;
        bank0_err_csl1_part4 <= 8'hFF;
        bank0_err_csl0_part5 <= 8'hFF;
        bank0_err_csl1_part5 <= 8'hFF;
        bank0_err_csl0_part6 <= 8'hFF;
        bank0_err_csl1_part6 <= 8'hFF;
        bank0_err_csl0_part7 <= 8'hFF;
        bank0_err_csl1_part7 <= 8'hFF;
        bank0_err_csl0_part8 <= 8'hFF;
        bank0_err_csl1_part8 <= 8'hFF;
        bank0_err_csl0_part9 <= 8'hFF;
        bank0_err_csl1_part9 <= 8'hFF;
        bank0_bist_bank_fail  <= 1'b0;

    end
    else if(SCAN_NS == BANK0) begin
        bank0_err_csl0_part0 <= bank_err_csl0_part0_tmp;
        bank0_err_csl1_part0 <= bank_err_csl1_part0_tmp;
        bank0_err_csl0_part1 <= bank_err_csl0_part1_tmp;
        bank0_err_csl1_part1 <= bank_err_csl1_part1_tmp;
        bank0_err_csl0_part2 <= bank_err_csl0_part2_tmp;
        bank0_err_csl1_part2 <= bank_err_csl1_part2_tmp;
        bank0_err_csl0_part3 <= bank_err_csl0_part3_tmp;
        bank0_err_csl1_part3 <= bank_err_csl1_part3_tmp;
        bank0_err_csl0_part4 <= bank_err_csl0_part4_tmp;
        bank0_err_csl1_part4 <= bank_err_csl1_part4_tmp;
        bank0_err_csl0_part5 <= bank_err_csl0_part5_tmp;
        bank0_err_csl1_part5 <= bank_err_csl1_part5_tmp;
        bank0_err_csl0_part6 <= bank_err_csl0_part6_tmp;
        bank0_err_csl1_part6 <= bank_err_csl1_part6_tmp;
        bank0_err_csl0_part7 <= bank_err_csl0_part7_tmp;
        bank0_err_csl1_part7 <= bank_err_csl1_part7_tmp;
        bank0_err_csl0_part8 <= bank_err_csl0_part8_tmp;
        bank0_err_csl1_part8 <= bank_err_csl1_part8_tmp;
        bank0_err_csl0_part9 <= bank_err_csl0_part9_tmp;
        bank0_err_csl1_part9 <= bank_err_csl1_part9_tmp;
        bank0_bist_bank_fail  <= bank_bist_bank_fail_tmp;
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank1_err_csl0_part0 <= 8'hFF;
        bank1_err_csl1_part0 <= 8'hFF;
        bank1_err_csl0_part1 <= 8'hFF;
        bank1_err_csl1_part1 <= 8'hFF;
        bank1_err_csl0_part2 <= 8'hFF;
        bank1_err_csl1_part2 <= 8'hFF;
        bank1_err_csl0_part3 <= 8'hFF;
        bank1_err_csl1_part3 <= 8'hFF;
        bank1_err_csl0_part4 <= 8'hFF;
        bank1_err_csl1_part4 <= 8'hFF;
        bank1_err_csl0_part5 <= 8'hFF;
        bank1_err_csl1_part5 <= 8'hFF;
        bank1_err_csl0_part6 <= 8'hFF;
        bank1_err_csl1_part6 <= 8'hFF;
        bank1_err_csl0_part7 <= 8'hFF;
        bank1_err_csl1_part7 <= 8'hFF;
        bank1_err_csl0_part8 <= 8'hFF;
        bank1_err_csl1_part8 <= 8'hFF;
        bank1_err_csl0_part9 <= 8'hFF;
        bank1_err_csl1_part9 <= 8'hFF;
        bank1_bist_bank_fail  <= 1'b0;

    end
    else if(global_mc_bist_start)begin
        bank1_err_csl0_part0 <= 8'hFF;
        bank1_err_csl1_part0 <= 8'hFF;
        bank1_err_csl0_part1 <= 8'hFF;
        bank1_err_csl1_part1 <= 8'hFF;
        bank1_err_csl0_part2 <= 8'hFF;
        bank1_err_csl1_part2 <= 8'hFF;
        bank1_err_csl0_part3 <= 8'hFF;
        bank1_err_csl1_part3 <= 8'hFF;
        bank1_err_csl0_part4 <= 8'hFF;
        bank1_err_csl1_part4 <= 8'hFF;
        bank1_err_csl0_part5 <= 8'hFF;
        bank1_err_csl1_part5 <= 8'hFF;
        bank1_err_csl0_part6 <= 8'hFF;
        bank1_err_csl1_part6 <= 8'hFF;
        bank1_err_csl0_part7 <= 8'hFF;
        bank1_err_csl1_part7 <= 8'hFF;
        bank1_err_csl0_part8 <= 8'hFF;
        bank1_err_csl1_part8 <= 8'hFF;
        bank1_err_csl0_part9 <= 8'hFF;
        bank1_err_csl1_part9 <= 8'hFF;
        bank1_bist_bank_fail  <= 1'b0;
    end
    else if(SCAN_NS == BANK1) begin
        bank1_err_csl0_part0 <= bank_err_csl0_part0_tmp;
        bank1_err_csl1_part0 <= bank_err_csl1_part0_tmp;
        bank1_err_csl0_part1 <= bank_err_csl0_part1_tmp;
        bank1_err_csl1_part1 <= bank_err_csl1_part1_tmp;
        bank1_err_csl0_part2 <= bank_err_csl0_part2_tmp;
        bank1_err_csl1_part2 <= bank_err_csl1_part2_tmp;
        bank1_err_csl0_part3 <= bank_err_csl0_part3_tmp;
        bank1_err_csl1_part3 <= bank_err_csl1_part3_tmp;
        bank1_err_csl0_part4 <= bank_err_csl0_part4_tmp;
        bank1_err_csl1_part4 <= bank_err_csl1_part4_tmp;
        bank1_err_csl0_part5 <= bank_err_csl0_part5_tmp;
        bank1_err_csl1_part5 <= bank_err_csl1_part5_tmp;
        bank1_err_csl0_part6 <= bank_err_csl0_part6_tmp;
        bank1_err_csl1_part6 <= bank_err_csl1_part6_tmp;
        bank1_err_csl0_part7 <= bank_err_csl0_part7_tmp;
        bank1_err_csl1_part7 <= bank_err_csl1_part7_tmp;
        bank1_err_csl0_part8 <= bank_err_csl0_part8_tmp;
        bank1_err_csl1_part8 <= bank_err_csl1_part8_tmp;
        bank1_err_csl0_part9 <= bank_err_csl0_part9_tmp;
        bank1_err_csl1_part9 <= bank_err_csl1_part9_tmp;
        bank1_bist_bank_fail  <= bank_bist_bank_fail_tmp;

    end
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank2_err_csl0_part0 <= 8'hFF;
        bank2_err_csl1_part0 <= 8'hFF;
        bank2_err_csl0_part1 <= 8'hFF;
        bank2_err_csl1_part1 <= 8'hFF;
        bank2_err_csl0_part2 <= 8'hFF;
        bank2_err_csl1_part2 <= 8'hFF;
        bank2_err_csl0_part3 <= 8'hFF;
        bank2_err_csl1_part3 <= 8'hFF;
        bank2_err_csl0_part4 <= 8'hFF;
        bank2_err_csl1_part4 <= 8'hFF;
        bank2_err_csl0_part5 <= 8'hFF;
        bank2_err_csl1_part5 <= 8'hFF;
        bank2_err_csl0_part6 <= 8'hFF;
        bank2_err_csl1_part6 <= 8'hFF;
        bank2_err_csl0_part7 <= 8'hFF;
        bank2_err_csl1_part7 <= 8'hFF;
        bank2_err_csl0_part8 <= 8'hFF;
        bank2_err_csl1_part8 <= 8'hFF;
        bank2_err_csl0_part9 <= 8'hFF;
        bank2_err_csl1_part9 <= 8'hFF;
        bank2_bist_bank_fail  <= 1'b0;

    end
    else if(global_mc_bist_start)begin
        bank2_err_csl0_part0 <= 8'hFF;
        bank2_err_csl1_part0 <= 8'hFF;
        bank2_err_csl0_part1 <= 8'hFF;
        bank2_err_csl1_part1 <= 8'hFF;
        bank2_err_csl0_part2 <= 8'hFF;
        bank2_err_csl1_part2 <= 8'hFF;
        bank2_err_csl0_part3 <= 8'hFF;
        bank2_err_csl1_part3 <= 8'hFF;
        bank2_err_csl0_part4 <= 8'hFF;
        bank2_err_csl1_part4 <= 8'hFF;
        bank2_err_csl0_part5 <= 8'hFF;
        bank2_err_csl1_part5 <= 8'hFF;
        bank2_err_csl0_part6 <= 8'hFF;
        bank2_err_csl1_part6 <= 8'hFF;
        bank2_err_csl0_part7 <= 8'hFF;
        bank2_err_csl1_part7 <= 8'hFF;
        bank2_err_csl0_part8 <= 8'hFF;
        bank2_err_csl1_part8 <= 8'hFF;
        bank2_err_csl0_part9 <= 8'hFF;
        bank2_err_csl1_part9 <= 8'hFF;
        bank2_bist_bank_fail  <= 1'b0;

    end
    else if(SCAN_NS == BANK2) begin
        bank2_err_csl0_part0 <= bank_err_csl0_part0_tmp;
        bank2_err_csl1_part0 <= bank_err_csl1_part0_tmp;
        bank2_err_csl0_part1 <= bank_err_csl0_part1_tmp;
        bank2_err_csl1_part1 <= bank_err_csl1_part1_tmp;
        bank2_err_csl0_part2 <= bank_err_csl0_part2_tmp;
        bank2_err_csl1_part2 <= bank_err_csl1_part2_tmp;
        bank2_err_csl0_part3 <= bank_err_csl0_part3_tmp;
        bank2_err_csl1_part3 <= bank_err_csl1_part3_tmp;
        bank2_err_csl0_part4 <= bank_err_csl0_part4_tmp;
        bank2_err_csl1_part4 <= bank_err_csl1_part4_tmp;
        bank2_err_csl0_part5 <= bank_err_csl0_part5_tmp;
        bank2_err_csl1_part5 <= bank_err_csl1_part5_tmp;
        bank2_err_csl0_part6 <= bank_err_csl0_part6_tmp;
        bank2_err_csl1_part6 <= bank_err_csl1_part6_tmp;
        bank2_err_csl0_part7 <= bank_err_csl0_part7_tmp;
        bank2_err_csl1_part7 <= bank_err_csl1_part7_tmp;
        bank2_err_csl0_part8 <= bank_err_csl0_part8_tmp;
        bank2_err_csl1_part8 <= bank_err_csl1_part8_tmp;
        bank2_err_csl0_part9 <= bank_err_csl0_part9_tmp;
        bank2_err_csl1_part9 <= bank_err_csl1_part9_tmp;
        bank2_bist_bank_fail  <= bank_bist_bank_fail_tmp;

    end
end


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank3_bist_work <= 1'b0;
    else if(global_mc_bist_start)
        bank3_bist_work<= 1'b0;
    else if(SCAN_CS==BANK3)
        bank3_bist_work <= 1'b1;
end

assign bank3_err_csl0_part0 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl0_part0_tmp : 8'hFF;             
assign bank3_err_csl1_part0 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl1_part0_tmp : 8'hFF;             
assign bank3_err_csl0_part1 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl0_part1_tmp : 8'hFF;             
assign bank3_err_csl1_part1 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl1_part1_tmp : 8'hFF;             
assign bank3_err_csl0_part2 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl0_part2_tmp : 8'hFF;             
assign bank3_err_csl1_part2 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl1_part2_tmp : 8'hFF;             
assign bank3_err_csl0_part3 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl0_part3_tmp : 8'hFF;             
assign bank3_err_csl1_part3 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl1_part3_tmp : 8'hFF;             
assign bank3_err_csl0_part4 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl0_part4_tmp : 8'hFF;             
assign bank3_err_csl1_part4 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl1_part4_tmp : 8'hFF;             
assign bank3_err_csl0_part5 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl0_part5_tmp : 8'hFF;             
assign bank3_err_csl1_part5 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl1_part5_tmp : 8'hFF;             
assign bank3_err_csl0_part6 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl0_part6_tmp : 8'hFF;             
assign bank3_err_csl1_part6 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl1_part6_tmp : 8'hFF;             
assign bank3_err_csl0_part7 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl0_part7_tmp : 8'hFF;             
assign bank3_err_csl1_part7 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl1_part7_tmp : 8'hFF;             
assign bank3_err_csl0_part8 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl0_part8_tmp : 8'hFF;             
assign bank3_err_csl1_part8 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl1_part8_tmp : 8'hFF;             
assign bank3_err_csl0_part9 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl0_part9_tmp : 8'hFF;             
assign bank3_err_csl1_part9 = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_err_csl1_part9_tmp : 8'hFF;   

assign bank3_bist_bank_fail = mc_bist_grant[3] && short_mode==2'b11 && bank3_bist_work ? bank_bist_bank_fail_tmp : 1'b0;


assign bank_err_csl0_part0 = {bank3_err_csl0_part0,bank2_err_csl0_part0,bank1_err_csl0_part0,bank0_err_csl0_part0};
assign bank_err_csl1_part0 = {bank3_err_csl1_part0,bank2_err_csl1_part0,bank1_err_csl1_part0,bank0_err_csl1_part0};
assign bank_err_csl0_part1 = {bank3_err_csl0_part1,bank2_err_csl0_part1,bank1_err_csl0_part1,bank0_err_csl0_part1};
assign bank_err_csl1_part1 = {bank3_err_csl1_part1,bank2_err_csl1_part1,bank1_err_csl1_part1,bank0_err_csl1_part1};
assign bank_err_csl0_part2 = {bank3_err_csl0_part2,bank2_err_csl0_part2,bank1_err_csl0_part2,bank0_err_csl0_part2};
assign bank_err_csl1_part2 = {bank3_err_csl1_part2,bank2_err_csl1_part2,bank1_err_csl1_part2,bank0_err_csl1_part2};
assign bank_err_csl0_part3 = {bank3_err_csl0_part3,bank2_err_csl0_part3,bank1_err_csl0_part3,bank0_err_csl0_part3};
assign bank_err_csl1_part3 = {bank3_err_csl1_part3,bank2_err_csl1_part3,bank1_err_csl1_part3,bank0_err_csl1_part3};
assign bank_err_csl0_part4 = {bank3_err_csl0_part4,bank2_err_csl0_part4,bank1_err_csl0_part4,bank0_err_csl0_part4};
assign bank_err_csl1_part4 = {bank3_err_csl1_part4,bank2_err_csl1_part4,bank1_err_csl1_part4,bank0_err_csl1_part4};
assign bank_err_csl0_part5 = {bank3_err_csl0_part5,bank2_err_csl0_part5,bank1_err_csl0_part5,bank0_err_csl0_part5};
assign bank_err_csl1_part5 = {bank3_err_csl1_part5,bank2_err_csl1_part5,bank1_err_csl1_part5,bank0_err_csl1_part5};
assign bank_err_csl0_part6 = {bank3_err_csl0_part6,bank2_err_csl0_part6,bank1_err_csl0_part6,bank0_err_csl0_part6};
assign bank_err_csl1_part6 = {bank3_err_csl1_part6,bank2_err_csl1_part6,bank1_err_csl1_part6,bank0_err_csl1_part6};
assign bank_err_csl0_part7 = {bank3_err_csl0_part7,bank2_err_csl0_part7,bank1_err_csl0_part7,bank0_err_csl0_part7};
assign bank_err_csl1_part7 = {bank3_err_csl1_part7,bank2_err_csl1_part7,bank1_err_csl1_part7,bank0_err_csl1_part7};
assign bank_err_csl0_part8 = {bank3_err_csl0_part8,bank2_err_csl0_part8,bank1_err_csl0_part8,bank0_err_csl0_part8};
assign bank_err_csl1_part8 = {bank3_err_csl1_part8,bank2_err_csl1_part8,bank1_err_csl1_part8,bank0_err_csl1_part8};
assign bank_err_csl0_part9 = {bank3_err_csl0_part9,bank2_err_csl0_part9,bank1_err_csl0_part9,bank0_err_csl0_part9};
assign bank_err_csl1_part9 = {bank3_err_csl1_part9,bank2_err_csl1_part9,bank1_err_csl1_part9,bank0_err_csl1_part9};
assign bank_bist_bank_fail = {bank3_bist_bank_fail,bank2_bist_bank_fail,bank1_bist_bank_fail,bank0_bist_bank_fail};



always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_bist_finish <= 1'b0;
    else if(global_mc_bist_start || bist_finish_clr)
        bank0_bist_finish <= 1'b0;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b0 && (bank_bist_bank_fail[0] || bank_bist_wl_finish[0] || bank_bist_csl_fail))
        bank0_bist_finish <= 1'b1;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b1 && (bank_bist_bank_fail[0] || bank_bist_wl_finish[0]))
        bank0_bist_finish <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank1_bist_finish <= 1'b0;
    else if(global_mc_bist_start || bist_finish_clr)
        bank1_bist_finish <= 1'b0;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b0 && (bank_bist_bank_fail[1] || bank_bist_wl_finish[1] || bank_bist_csl_fail))
        bank1_bist_finish <= 1'b1;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b1 && (bank_bist_bank_fail[1] || bank_bist_wl_finish[1]))
        bank1_bist_finish <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank2_bist_finish <= 1'b0;
    else if(global_mc_bist_start || bist_finish_clr)
        bank2_bist_finish <= 1'b0;
    else if(SCAN_CS == BANK2 && csl_scan_mode_sel==1'b0 && (bank_bist_bank_fail[2] || bank_bist_wl_finish[2] || bank_bist_csl_fail))
        bank2_bist_finish <= 1'b1;
    else if(SCAN_CS == BANK2 && csl_scan_mode_sel==1'b1 && (bank_bist_bank_fail[2] || bank_bist_wl_finish[2]))
        bank2_bist_finish <= 1'b1;
end


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank3_bist_finish <= 1'b0;
    else if(global_mc_bist_start || bist_finish_clr)
        bank3_bist_finish <= 1'b0;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b0 && (bank_bist_bank_fail[3] || bank_bist_wl_finish[3] || bank_bist_csl_fail))
        bank3_bist_finish <= 1'b1;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b1 && (bank_bist_bank_fail[3] || bank_bist_wl_finish[3]))
        bank3_bist_finish <= 1'b1;
end


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_bist_success <= 1'b0;
    else if(global_mc_bist_start)
        bank0_bist_success <= 1'b0;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b0 && bank_bist_bank_success && bank_bist_wl_success[0] && !bank_bist_csl_fail )
        bank0_bist_success <= 1'b1;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b1 && bank_bist_bank_success && bank_bist_wl_success[0])
        bank0_bist_success <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank1_bist_success <= 1'b0;
    else if(global_mc_bist_start)
        bank1_bist_success <= 1'b0;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b0 && bank_bist_bank_success && bank_bist_wl_success[1] && !bank_bist_csl_fail )
        bank1_bist_success <= 1'b1;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b1 && bank_bist_bank_success && bank_bist_wl_success[1])
        bank1_bist_success <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank2_bist_success <= 1'b0;
    else if(global_mc_bist_start)
        bank2_bist_success <= 1'b0;
    else if(SCAN_CS == BANK2 && csl_scan_mode_sel==1'b0 && bank_bist_bank_success && bank_bist_wl_success[2] && !bank_bist_csl_fail )
        bank2_bist_success <= 1'b1;
    else if(SCAN_CS == BANK2 && csl_scan_mode_sel==1'b1 && bank_bist_bank_success && bank_bist_wl_success[2])
        bank2_bist_success <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank3_bist_success <= 1'b0;
    else if(global_mc_bist_start)
        bank3_bist_success <= 1'b0;
    else if(SCAN_CS == BANK3 && csl_scan_mode_sel==1'b0 && bank_bist_bank_success && bank_bist_wl_success[3] && !bank_bist_csl_fail )
        bank3_bist_success <= 1'b1;
    else if(SCAN_CS == BANK3 && csl_scan_mode_sel==1'b1 && bank_bist_bank_success && bank_bist_wl_success[3])
        bank3_bist_success <= 1'b1;
end

assign bank_bist_finish = {bank3_bist_finish,bank2_bist_finish,bank1_bist_finish,bank0_bist_finish} ;
assign bank_bist_success = {bank3_bist_success,bank2_bist_success,bank1_bist_success,bank0_bist_success} ;
assign all_bank_bist_finish_status = {bank3_bist_finish,bank2_bist_finish,bank1_bist_finish,bank0_bist_finish} ;
assign all_bank_bist_success_status = {bank3_bist_success,bank2_bist_success,bank1_bist_success,bank0_bist_success} ;
end
else if(MC_SHORT_MODE==3)begin:inst1

reg                                                             bank0_bist_success                 ;
reg                                                             bank1_bist_success                 ;
reg                                                             bank2_bist_success                 ;
reg                                                             bank0_bist_finish                  ;
reg                                                             bank1_bist_finish                  ;
reg                                                             bank2_bist_finish                  ;
wire                                                            bank3_bist_finish                  ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part9               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part9               ;

reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part9               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part9               ;

reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl0_part9               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank2_err_csl1_part9               ;

reg                                                             bank0_bist_bank_fail               ;
reg                                                             bank1_bist_bank_fail               ;
reg                                                             bank2_bist_bank_fail               ;

assign bank3_bist_finish = 1'b0;
always @(*)begin
    case(SCAN_CS)
    IDLE:begin
        if(global_mc_bist_start && mc_bist_grant[0])
            SCAN_NS = BANK0;
        else if(global_mc_bist_start && mc_bist_grant[1:0]==2'b10)
            SCAN_NS = BANK1;
        else if(global_mc_bist_start && mc_bist_grant[2:0]==3'b100)
            SCAN_NS = BANK2;
        else if(global_mc_bist_start && mc_bist_grant[3:0]==4'b1000)
            SCAN_NS = BANK3;        
        else
            SCAN_NS = SCAN_CS;
    end
    BANK0:begin
        if(bank0_bist_finish && mc_bist_grant[3:1]==3'b000)
            SCAN_NS = IDLE;
        else if(bank0_bist_finish && mc_bist_grant[1])
            SCAN_NS = BANK1;
        else if(bank0_bist_finish && mc_bist_grant[2:1]==2'b10)
            SCAN_NS = BANK2;
        else if(bank0_bist_finish && mc_bist_grant[3:1]==3'b100)
            SCAN_NS = BANK3;
        else
            SCAN_NS = SCAN_CS;
    end
    BANK1:begin
        if(bank1_bist_finish && mc_bist_grant[3:2]==2'b00)
            SCAN_NS = IDLE;
        else if(bank1_bist_finish && mc_bist_grant[2])
            SCAN_NS = BANK2;
        else if(bank1_bist_finish && mc_bist_grant[3:2]==2'b10)
            SCAN_NS = BANK3;
        else
            SCAN_NS = SCAN_CS;
    end
    BANK2:begin
        if(bank2_bist_finish && mc_bist_grant[3]==1'b0)
            SCAN_NS = IDLE;
        else if(bank2_bist_finish && mc_bist_grant[3])
            SCAN_NS = BANK3;
        else
            SCAN_NS = SCAN_CS;
    end
    BANK3:begin
        if(bank3_bist_finish)
            SCAN_NS = IDLE;
        else
            SCAN_NS = SCAN_CS;
    end
    default:SCAN_NS = IDLE;
    endcase
end
always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank0_err_csl0_part0 <= 8'hFF;
        bank0_err_csl1_part0 <= 8'hFF;
        bank0_err_csl0_part1 <= 8'hFF;
        bank0_err_csl1_part1 <= 8'hFF;
        bank0_err_csl0_part2 <= 8'hFF;
        bank0_err_csl1_part2 <= 8'hFF;
        bank0_err_csl0_part3 <= 8'hFF;
        bank0_err_csl1_part3 <= 8'hFF;
        bank0_err_csl0_part4 <= 8'hFF;
        bank0_err_csl1_part4 <= 8'hFF;
        bank0_err_csl0_part5 <= 8'hFF;
        bank0_err_csl1_part5 <= 8'hFF;
        bank0_err_csl0_part6 <= 8'hFF;
        bank0_err_csl1_part6 <= 8'hFF;
        bank0_err_csl0_part7 <= 8'hFF;
        bank0_err_csl1_part7 <= 8'hFF;
        bank0_err_csl0_part8 <= 8'hFF;
        bank0_err_csl1_part8 <= 8'hFF;
        bank0_err_csl0_part9 <= 8'hFF;
        bank0_err_csl1_part9 <= 8'hFF;
        bank0_bist_bank_fail  <= 1'b0;
        
    end
    else if(global_mc_bist_start)begin
        bank0_err_csl0_part0 <= 8'hFF;
        bank0_err_csl1_part0 <= 8'hFF;
        bank0_err_csl0_part1 <= 8'hFF;
        bank0_err_csl1_part1 <= 8'hFF;
        bank0_err_csl0_part2 <= 8'hFF;
        bank0_err_csl1_part2 <= 8'hFF;
        bank0_err_csl0_part3 <= 8'hFF;
        bank0_err_csl1_part3 <= 8'hFF;
        bank0_err_csl0_part4 <= 8'hFF;
        bank0_err_csl1_part4 <= 8'hFF;
        bank0_err_csl0_part5 <= 8'hFF;
        bank0_err_csl1_part5 <= 8'hFF;
        bank0_err_csl0_part6 <= 8'hFF;
        bank0_err_csl1_part6 <= 8'hFF;
        bank0_err_csl0_part7 <= 8'hFF;
        bank0_err_csl1_part7 <= 8'hFF;
        bank0_err_csl0_part8 <= 8'hFF;
        bank0_err_csl1_part8 <= 8'hFF;
        bank0_err_csl0_part9 <= 8'hFF;
        bank0_err_csl1_part9 <= 8'hFF;
        bank0_bist_bank_fail  <= 1'b0;

    end
    else if(SCAN_NS == BANK0) begin
        bank0_err_csl0_part0 <= bank_err_csl0_part0_tmp;
        bank0_err_csl1_part0 <= bank_err_csl1_part0_tmp;
        bank0_err_csl0_part1 <= bank_err_csl0_part1_tmp;
        bank0_err_csl1_part1 <= bank_err_csl1_part1_tmp;
        bank0_err_csl0_part2 <= bank_err_csl0_part2_tmp;
        bank0_err_csl1_part2 <= bank_err_csl1_part2_tmp;
        bank0_err_csl0_part3 <= bank_err_csl0_part3_tmp;
        bank0_err_csl1_part3 <= bank_err_csl1_part3_tmp;
        bank0_err_csl0_part4 <= bank_err_csl0_part4_tmp;
        bank0_err_csl1_part4 <= bank_err_csl1_part4_tmp;
        bank0_err_csl0_part5 <= bank_err_csl0_part5_tmp;
        bank0_err_csl1_part5 <= bank_err_csl1_part5_tmp;
        bank0_err_csl0_part6 <= bank_err_csl0_part6_tmp;
        bank0_err_csl1_part6 <= bank_err_csl1_part6_tmp;
        bank0_err_csl0_part7 <= bank_err_csl0_part7_tmp;
        bank0_err_csl1_part7 <= bank_err_csl1_part7_tmp;
        bank0_err_csl0_part8 <= bank_err_csl0_part8_tmp;
        bank0_err_csl1_part8 <= bank_err_csl1_part8_tmp;
        bank0_err_csl0_part9 <= bank_err_csl0_part9_tmp;
        bank0_err_csl1_part9 <= bank_err_csl1_part9_tmp;
        bank0_bist_bank_fail  <= bank_bist_bank_fail_tmp;
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank1_err_csl0_part0 <= 8'hFF;
        bank1_err_csl1_part0 <= 8'hFF;
        bank1_err_csl0_part1 <= 8'hFF;
        bank1_err_csl1_part1 <= 8'hFF;
        bank1_err_csl0_part2 <= 8'hFF;
        bank1_err_csl1_part2 <= 8'hFF;
        bank1_err_csl0_part3 <= 8'hFF;
        bank1_err_csl1_part3 <= 8'hFF;
        bank1_err_csl0_part4 <= 8'hFF;
        bank1_err_csl1_part4 <= 8'hFF;
        bank1_err_csl0_part5 <= 8'hFF;
        bank1_err_csl1_part5 <= 8'hFF;
        bank1_err_csl0_part6 <= 8'hFF;
        bank1_err_csl1_part6 <= 8'hFF;
        bank1_err_csl0_part7 <= 8'hFF;
        bank1_err_csl1_part7 <= 8'hFF;
        bank1_err_csl0_part8 <= 8'hFF;
        bank1_err_csl1_part8 <= 8'hFF;
        bank1_err_csl0_part9 <= 8'hFF;
        bank1_err_csl1_part9 <= 8'hFF;
        bank1_bist_bank_fail  <= 1'b0;

    end
    else if(global_mc_bist_start)begin
        bank1_err_csl0_part0 <= 8'hFF;
        bank1_err_csl1_part0 <= 8'hFF;
        bank1_err_csl0_part1 <= 8'hFF;
        bank1_err_csl1_part1 <= 8'hFF;
        bank1_err_csl0_part2 <= 8'hFF;
        bank1_err_csl1_part2 <= 8'hFF;
        bank1_err_csl0_part3 <= 8'hFF;
        bank1_err_csl1_part3 <= 8'hFF;
        bank1_err_csl0_part4 <= 8'hFF;
        bank1_err_csl1_part4 <= 8'hFF;
        bank1_err_csl0_part5 <= 8'hFF;
        bank1_err_csl1_part5 <= 8'hFF;
        bank1_err_csl0_part6 <= 8'hFF;
        bank1_err_csl1_part6 <= 8'hFF;
        bank1_err_csl0_part7 <= 8'hFF;
        bank1_err_csl1_part7 <= 8'hFF;
        bank1_err_csl0_part8 <= 8'hFF;
        bank1_err_csl1_part8 <= 8'hFF;
        bank1_err_csl0_part9 <= 8'hFF;
        bank1_err_csl1_part9 <= 8'hFF;
        bank1_bist_bank_fail  <= 1'b0;
    end
    else if(SCAN_NS == BANK1) begin
        bank1_err_csl0_part0 <= bank_err_csl0_part0_tmp;
        bank1_err_csl1_part0 <= bank_err_csl1_part0_tmp;
        bank1_err_csl0_part1 <= bank_err_csl0_part1_tmp;
        bank1_err_csl1_part1 <= bank_err_csl1_part1_tmp;
        bank1_err_csl0_part2 <= bank_err_csl0_part2_tmp;
        bank1_err_csl1_part2 <= bank_err_csl1_part2_tmp;
        bank1_err_csl0_part3 <= bank_err_csl0_part3_tmp;
        bank1_err_csl1_part3 <= bank_err_csl1_part3_tmp;
        bank1_err_csl0_part4 <= bank_err_csl0_part4_tmp;
        bank1_err_csl1_part4 <= bank_err_csl1_part4_tmp;
        bank1_err_csl0_part5 <= bank_err_csl0_part5_tmp;
        bank1_err_csl1_part5 <= bank_err_csl1_part5_tmp;
        bank1_err_csl0_part6 <= bank_err_csl0_part6_tmp;
        bank1_err_csl1_part6 <= bank_err_csl1_part6_tmp;
        bank1_err_csl0_part7 <= bank_err_csl0_part7_tmp;
        bank1_err_csl1_part7 <= bank_err_csl1_part7_tmp;
        bank1_err_csl0_part8 <= bank_err_csl0_part8_tmp;
        bank1_err_csl1_part8 <= bank_err_csl1_part8_tmp;
        bank1_err_csl0_part9 <= bank_err_csl0_part9_tmp;
        bank1_err_csl1_part9 <= bank_err_csl1_part9_tmp;
        bank1_bist_bank_fail  <= bank_bist_bank_fail_tmp;

    end
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank2_err_csl0_part0 <= 8'hFF;
        bank2_err_csl1_part0 <= 8'hFF;
        bank2_err_csl0_part1 <= 8'hFF;
        bank2_err_csl1_part1 <= 8'hFF;
        bank2_err_csl0_part2 <= 8'hFF;
        bank2_err_csl1_part2 <= 8'hFF;
        bank2_err_csl0_part3 <= 8'hFF;
        bank2_err_csl1_part3 <= 8'hFF;
        bank2_err_csl0_part4 <= 8'hFF;
        bank2_err_csl1_part4 <= 8'hFF;
        bank2_err_csl0_part5 <= 8'hFF;
        bank2_err_csl1_part5 <= 8'hFF;
        bank2_err_csl0_part6 <= 8'hFF;
        bank2_err_csl1_part6 <= 8'hFF;
        bank2_err_csl0_part7 <= 8'hFF;
        bank2_err_csl1_part7 <= 8'hFF;
        bank2_err_csl0_part8 <= 8'hFF;
        bank2_err_csl1_part8 <= 8'hFF;
        bank2_err_csl0_part9 <= 8'hFF;
        bank2_err_csl1_part9 <= 8'hFF;
        bank2_bist_bank_fail  <= 1'b0;

    end
    else if(global_mc_bist_start)begin
        bank2_err_csl0_part0 <= 8'hFF;
        bank2_err_csl1_part0 <= 8'hFF;
        bank2_err_csl0_part1 <= 8'hFF;
        bank2_err_csl1_part1 <= 8'hFF;
        bank2_err_csl0_part2 <= 8'hFF;
        bank2_err_csl1_part2 <= 8'hFF;
        bank2_err_csl0_part3 <= 8'hFF;
        bank2_err_csl1_part3 <= 8'hFF;
        bank2_err_csl0_part4 <= 8'hFF;
        bank2_err_csl1_part4 <= 8'hFF;
        bank2_err_csl0_part5 <= 8'hFF;
        bank2_err_csl1_part5 <= 8'hFF;
        bank2_err_csl0_part6 <= 8'hFF;
        bank2_err_csl1_part6 <= 8'hFF;
        bank2_err_csl0_part7 <= 8'hFF;
        bank2_err_csl1_part7 <= 8'hFF;
        bank2_err_csl0_part8 <= 8'hFF;
        bank2_err_csl1_part8 <= 8'hFF;
        bank2_err_csl0_part9 <= 8'hFF;
        bank2_err_csl1_part9 <= 8'hFF;
        bank2_bist_bank_fail  <= 1'b0;

    end
    else if(SCAN_NS == BANK2) begin
        bank2_err_csl0_part0 <= bank_err_csl0_part0_tmp;
        bank2_err_csl1_part0 <= bank_err_csl1_part0_tmp;
        bank2_err_csl0_part1 <= bank_err_csl0_part1_tmp;
        bank2_err_csl1_part1 <= bank_err_csl1_part1_tmp;
        bank2_err_csl0_part2 <= bank_err_csl0_part2_tmp;
        bank2_err_csl1_part2 <= bank_err_csl1_part2_tmp;
        bank2_err_csl0_part3 <= bank_err_csl0_part3_tmp;
        bank2_err_csl1_part3 <= bank_err_csl1_part3_tmp;
        bank2_err_csl0_part4 <= bank_err_csl0_part4_tmp;
        bank2_err_csl1_part4 <= bank_err_csl1_part4_tmp;
        bank2_err_csl0_part5 <= bank_err_csl0_part5_tmp;
        bank2_err_csl1_part5 <= bank_err_csl1_part5_tmp;
        bank2_err_csl0_part6 <= bank_err_csl0_part6_tmp;
        bank2_err_csl1_part6 <= bank_err_csl1_part6_tmp;
        bank2_err_csl0_part7 <= bank_err_csl0_part7_tmp;
        bank2_err_csl1_part7 <= bank_err_csl1_part7_tmp;
        bank2_err_csl0_part8 <= bank_err_csl0_part8_tmp;
        bank2_err_csl1_part8 <= bank_err_csl1_part8_tmp;
        bank2_err_csl0_part9 <= bank_err_csl0_part9_tmp;
        bank2_err_csl1_part9 <= bank_err_csl1_part9_tmp;
        bank2_bist_bank_fail  <= bank_bist_bank_fail_tmp;

    end
end


assign bank_err_csl0_part0 = {bank2_err_csl0_part0,bank1_err_csl0_part0,bank0_err_csl0_part0};
assign bank_err_csl1_part0 = {bank2_err_csl1_part0,bank1_err_csl1_part0,bank0_err_csl1_part0};
assign bank_err_csl0_part1 = {bank2_err_csl0_part1,bank1_err_csl0_part1,bank0_err_csl0_part1};
assign bank_err_csl1_part1 = {bank2_err_csl1_part1,bank1_err_csl1_part1,bank0_err_csl1_part1};
assign bank_err_csl0_part2 = {bank2_err_csl0_part2,bank1_err_csl0_part2,bank0_err_csl0_part2};
assign bank_err_csl1_part2 = {bank2_err_csl1_part2,bank1_err_csl1_part2,bank0_err_csl1_part2};
assign bank_err_csl0_part3 = {bank2_err_csl0_part3,bank1_err_csl0_part3,bank0_err_csl0_part3};
assign bank_err_csl1_part3 = {bank2_err_csl1_part3,bank1_err_csl1_part3,bank0_err_csl1_part3};
assign bank_err_csl0_part4 = {bank2_err_csl0_part4,bank1_err_csl0_part4,bank0_err_csl0_part4};
assign bank_err_csl1_part4 = {bank2_err_csl1_part4,bank1_err_csl1_part4,bank0_err_csl1_part4};
assign bank_err_csl0_part5 = {bank2_err_csl0_part5,bank1_err_csl0_part5,bank0_err_csl0_part5};
assign bank_err_csl1_part5 = {bank2_err_csl1_part5,bank1_err_csl1_part5,bank0_err_csl1_part5};
assign bank_err_csl0_part6 = {bank2_err_csl0_part6,bank1_err_csl0_part6,bank0_err_csl0_part6};
assign bank_err_csl1_part6 = {bank2_err_csl1_part6,bank1_err_csl1_part6,bank0_err_csl1_part6};
assign bank_err_csl0_part7 = {bank2_err_csl0_part7,bank1_err_csl0_part7,bank0_err_csl0_part7};
assign bank_err_csl1_part7 = {bank2_err_csl1_part7,bank1_err_csl1_part7,bank0_err_csl1_part7};
assign bank_err_csl0_part8 = {bank2_err_csl0_part8,bank1_err_csl0_part8,bank0_err_csl0_part8};
assign bank_err_csl1_part8 = {bank2_err_csl1_part8,bank1_err_csl1_part8,bank0_err_csl1_part8};
assign bank_err_csl0_part9 = {bank2_err_csl0_part9,bank1_err_csl0_part9,bank0_err_csl0_part9};
assign bank_err_csl1_part9 = {bank2_err_csl1_part9,bank1_err_csl1_part9,bank0_err_csl1_part9};

assign bank_bist_bank_fail = {bank2_bist_bank_fail,bank1_bist_bank_fail,bank0_bist_bank_fail};


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_bist_finish <= 1'b0;
    else if(global_mc_bist_start || bist_finish_clr)
        bank0_bist_finish <= 1'b0;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b0 && (bank_bist_bank_fail[0] || bank_bist_wl_finish[0] || bank_bist_csl_fail))
        bank0_bist_finish <= 1'b1;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b1 && (bank_bist_bank_fail[0] || bank_bist_wl_finish[0]))
        bank0_bist_finish <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank1_bist_finish <= 1'b0;
    else if(global_mc_bist_start || bist_finish_clr)
        bank1_bist_finish <= 1'b0;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b0 && (bank_bist_bank_fail[1] || bank_bist_wl_finish[1] || bank_bist_csl_fail))
        bank1_bist_finish <= 1'b1;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b1 && (bank_bist_bank_fail[1] || bank_bist_wl_finish[1]))
        bank1_bist_finish <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank2_bist_finish <= 1'b0;
    else if(global_mc_bist_start || bist_finish_clr)
        bank2_bist_finish <= 1'b0;
    else if(SCAN_CS == BANK2 && csl_scan_mode_sel==1'b0 && (bank_bist_bank_fail[2] || bank_bist_wl_finish[2] || bank_bist_csl_fail))
        bank2_bist_finish <= 1'b1;
    else if(SCAN_CS == BANK2 && csl_scan_mode_sel==1'b1 && (bank_bist_bank_fail[2] || bank_bist_wl_finish[2]))
        bank2_bist_finish <= 1'b1;
end




always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_bist_success <= 1'b0;
    else if(global_mc_bist_start)
        bank0_bist_success <= 1'b0;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b0 && bank_bist_bank_success && bank_bist_wl_success[0] && !bank_bist_csl_fail )
        bank0_bist_success <= 1'b1;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b1 && bank_bist_bank_success && bank_bist_wl_success[0])
        bank0_bist_success <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank1_bist_success <= 1'b0;
    else if(global_mc_bist_start)
        bank1_bist_success <= 1'b0;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b0 && bank_bist_bank_success && bank_bist_wl_success[1] && !bank_bist_csl_fail )
        bank1_bist_success <= 1'b1;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b1 && bank_bist_bank_success && bank_bist_wl_success[1])
        bank1_bist_success <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank2_bist_success <= 1'b0;
    else if(global_mc_bist_start)
        bank2_bist_success <= 1'b0;
    else if(SCAN_CS == BANK2 && csl_scan_mode_sel==1'b0 && bank_bist_bank_success && bank_bist_wl_success[2] && !bank_bist_csl_fail )
        bank2_bist_success <= 1'b1;
    else if(SCAN_CS == BANK2 && csl_scan_mode_sel==1'b1 && bank_bist_bank_success && bank_bist_wl_success[2])
        bank2_bist_success <= 1'b1;
end

assign bank_bist_finish = {bank2_bist_finish,bank1_bist_finish,bank0_bist_finish} ;
assign bank_bist_success = {bank2_bist_success,bank1_bist_success,bank0_bist_success} ;
assign all_bank_bist_finish_status = {bank2_bist_finish,bank1_bist_finish,bank0_bist_finish} ;
assign all_bank_bist_success_status = {bank2_bist_success,bank1_bist_success,bank0_bist_success} ;
end
else if(MC_SHORT_MODE==2)begin:inst2


reg                                                             bank0_bist_success                 ;
reg                                                             bank1_bist_success                 ;
reg                                                             bank0_bist_finish                  ;
reg                                                             bank1_bist_finish                  ;
wire                                                            bank2_bist_finish                  ;
wire                                                            bank3_bist_finish                  ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part9               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part9               ;

reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part9               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part9               ;
reg                                                             bank0_bist_bank_fail               ;
reg                                                             bank1_bist_bank_fail               ;

assign bank2_bist_finish = 1'b0;
assign bank3_bist_finish = 1'b0;

always @(*)begin
    case(SCAN_CS)
    IDLE:begin
        if(global_mc_bist_start && mc_bist_grant[0])
            SCAN_NS = BANK0;
        else if(global_mc_bist_start && mc_bist_grant[1:0]==2'b10)
            SCAN_NS = BANK1;
        else if(global_mc_bist_start && mc_bist_grant[2:0]==3'b100)
            SCAN_NS = BANK2;
        else if(global_mc_bist_start && mc_bist_grant[3:0]==4'b1000)
            SCAN_NS = BANK3;        
        else
            SCAN_NS = SCAN_CS;
    end
    BANK0:begin
        if(bank0_bist_finish && mc_bist_grant[3:1]==3'b000)
            SCAN_NS = IDLE;
        else if(bank0_bist_finish && mc_bist_grant[1])
            SCAN_NS = BANK1;
        else if(bank0_bist_finish && mc_bist_grant[2:1]==2'b10)
            SCAN_NS = BANK2;
        else if(bank0_bist_finish && mc_bist_grant[3:1]==3'b100)
            SCAN_NS = BANK3;
        else
            SCAN_NS = SCAN_CS;
    end
    BANK1:begin
        if(bank1_bist_finish && mc_bist_grant[3:2]==2'b00)
            SCAN_NS = IDLE;
        else if(bank1_bist_finish && mc_bist_grant[2])
            SCAN_NS = BANK2;
        else if(bank1_bist_finish && mc_bist_grant[3:2]==2'b10)
            SCAN_NS = BANK3;
        else
            SCAN_NS = SCAN_CS;
    end
    BANK2:begin
        if(bank2_bist_finish && mc_bist_grant[3]==1'b0)
            SCAN_NS = IDLE;
        else if(bank2_bist_finish && mc_bist_grant[3])
            SCAN_NS = BANK3;
        else
            SCAN_NS = SCAN_CS;
    end
    BANK3:begin
        if(bank3_bist_finish)
            SCAN_NS = IDLE;
        else
            SCAN_NS = SCAN_CS;
    end
    default:SCAN_NS = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank0_err_csl0_part0 <= 8'hFF;
        bank0_err_csl1_part0 <= 8'hFF;
        bank0_err_csl0_part1 <= 8'hFF;
        bank0_err_csl1_part1 <= 8'hFF;
        bank0_err_csl0_part2 <= 8'hFF;
        bank0_err_csl1_part2 <= 8'hFF;
        bank0_err_csl0_part3 <= 8'hFF;
        bank0_err_csl1_part3 <= 8'hFF;
        bank0_err_csl0_part4 <= 8'hFF;
        bank0_err_csl1_part4 <= 8'hFF;
        bank0_err_csl0_part5 <= 8'hFF;
        bank0_err_csl1_part5 <= 8'hFF;
        bank0_err_csl0_part6 <= 8'hFF;
        bank0_err_csl1_part6 <= 8'hFF;
        bank0_err_csl0_part7 <= 8'hFF;
        bank0_err_csl1_part7 <= 8'hFF;
        bank0_err_csl0_part8 <= 8'hFF;
        bank0_err_csl1_part8 <= 8'hFF;
        bank0_err_csl0_part9 <= 8'hFF;
        bank0_err_csl1_part9 <= 8'hFF;
        bank0_bist_bank_fail  <= 1'b0;
        
    end
    else if(global_mc_bist_start)begin
        bank0_err_csl0_part0 <= 8'hFF;
        bank0_err_csl1_part0 <= 8'hFF;
        bank0_err_csl0_part1 <= 8'hFF;
        bank0_err_csl1_part1 <= 8'hFF;
        bank0_err_csl0_part2 <= 8'hFF;
        bank0_err_csl1_part2 <= 8'hFF;
        bank0_err_csl0_part3 <= 8'hFF;
        bank0_err_csl1_part3 <= 8'hFF;
        bank0_err_csl0_part4 <= 8'hFF;
        bank0_err_csl1_part4 <= 8'hFF;
        bank0_err_csl0_part5 <= 8'hFF;
        bank0_err_csl1_part5 <= 8'hFF;
        bank0_err_csl0_part6 <= 8'hFF;
        bank0_err_csl1_part6 <= 8'hFF;
        bank0_err_csl0_part7 <= 8'hFF;
        bank0_err_csl1_part7 <= 8'hFF;
        bank0_err_csl0_part8 <= 8'hFF;
        bank0_err_csl1_part8 <= 8'hFF;
        bank0_err_csl0_part9 <= 8'hFF;
        bank0_err_csl1_part9 <= 8'hFF;
        bank0_bist_bank_fail  <= 1'b0;

    end
    else if(SCAN_NS == BANK0) begin
        bank0_err_csl0_part0 <= bank_err_csl0_part0_tmp;
        bank0_err_csl1_part0 <= bank_err_csl1_part0_tmp;
        bank0_err_csl0_part1 <= bank_err_csl0_part1_tmp;
        bank0_err_csl1_part1 <= bank_err_csl1_part1_tmp;
        bank0_err_csl0_part2 <= bank_err_csl0_part2_tmp;
        bank0_err_csl1_part2 <= bank_err_csl1_part2_tmp;
        bank0_err_csl0_part3 <= bank_err_csl0_part3_tmp;
        bank0_err_csl1_part3 <= bank_err_csl1_part3_tmp;
        bank0_err_csl0_part4 <= bank_err_csl0_part4_tmp;
        bank0_err_csl1_part4 <= bank_err_csl1_part4_tmp;
        bank0_err_csl0_part5 <= bank_err_csl0_part5_tmp;
        bank0_err_csl1_part5 <= bank_err_csl1_part5_tmp;
        bank0_err_csl0_part6 <= bank_err_csl0_part6_tmp;
        bank0_err_csl1_part6 <= bank_err_csl1_part6_tmp;
        bank0_err_csl0_part7 <= bank_err_csl0_part7_tmp;
        bank0_err_csl1_part7 <= bank_err_csl1_part7_tmp;
        bank0_err_csl0_part8 <= bank_err_csl0_part8_tmp;
        bank0_err_csl1_part8 <= bank_err_csl1_part8_tmp;
        bank0_err_csl0_part9 <= bank_err_csl0_part9_tmp;
        bank0_err_csl1_part9 <= bank_err_csl1_part9_tmp;
        bank0_bist_bank_fail  <= bank_bist_bank_fail_tmp;
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank1_err_csl0_part0 <= 8'hFF;
        bank1_err_csl1_part0 <= 8'hFF;
        bank1_err_csl0_part1 <= 8'hFF;
        bank1_err_csl1_part1 <= 8'hFF;
        bank1_err_csl0_part2 <= 8'hFF;
        bank1_err_csl1_part2 <= 8'hFF;
        bank1_err_csl0_part3 <= 8'hFF;
        bank1_err_csl1_part3 <= 8'hFF;
        bank1_err_csl0_part4 <= 8'hFF;
        bank1_err_csl1_part4 <= 8'hFF;
        bank1_err_csl0_part5 <= 8'hFF;
        bank1_err_csl1_part5 <= 8'hFF;
        bank1_err_csl0_part6 <= 8'hFF;
        bank1_err_csl1_part6 <= 8'hFF;
        bank1_err_csl0_part7 <= 8'hFF;
        bank1_err_csl1_part7 <= 8'hFF;
        bank1_err_csl0_part8 <= 8'hFF;
        bank1_err_csl1_part8 <= 8'hFF;
        bank1_err_csl0_part9 <= 8'hFF;
        bank1_err_csl1_part9 <= 8'hFF;
        bank1_bist_bank_fail  <= 1'b0;

    end
    else if(global_mc_bist_start)begin
        bank1_err_csl0_part0 <= 8'hFF;
        bank1_err_csl1_part0 <= 8'hFF;
        bank1_err_csl0_part1 <= 8'hFF;
        bank1_err_csl1_part1 <= 8'hFF;
        bank1_err_csl0_part2 <= 8'hFF;
        bank1_err_csl1_part2 <= 8'hFF;
        bank1_err_csl0_part3 <= 8'hFF;
        bank1_err_csl1_part3 <= 8'hFF;
        bank1_err_csl0_part4 <= 8'hFF;
        bank1_err_csl1_part4 <= 8'hFF;
        bank1_err_csl0_part5 <= 8'hFF;
        bank1_err_csl1_part5 <= 8'hFF;
        bank1_err_csl0_part6 <= 8'hFF;
        bank1_err_csl1_part6 <= 8'hFF;
        bank1_err_csl0_part7 <= 8'hFF;
        bank1_err_csl1_part7 <= 8'hFF;
        bank1_err_csl0_part8 <= 8'hFF;
        bank1_err_csl1_part8 <= 8'hFF;
        bank1_err_csl0_part9 <= 8'hFF;
        bank1_err_csl1_part9 <= 8'hFF;
        bank1_bist_bank_fail  <= 1'b0;
    end
    else if(SCAN_NS == BANK1) begin
        bank1_err_csl0_part0 <= bank_err_csl0_part0_tmp;
        bank1_err_csl1_part0 <= bank_err_csl1_part0_tmp;
        bank1_err_csl0_part1 <= bank_err_csl0_part1_tmp;
        bank1_err_csl1_part1 <= bank_err_csl1_part1_tmp;
        bank1_err_csl0_part2 <= bank_err_csl0_part2_tmp;
        bank1_err_csl1_part2 <= bank_err_csl1_part2_tmp;
        bank1_err_csl0_part3 <= bank_err_csl0_part3_tmp;
        bank1_err_csl1_part3 <= bank_err_csl1_part3_tmp;
        bank1_err_csl0_part4 <= bank_err_csl0_part4_tmp;
        bank1_err_csl1_part4 <= bank_err_csl1_part4_tmp;
        bank1_err_csl0_part5 <= bank_err_csl0_part5_tmp;
        bank1_err_csl1_part5 <= bank_err_csl1_part5_tmp;
        bank1_err_csl0_part6 <= bank_err_csl0_part6_tmp;
        bank1_err_csl1_part6 <= bank_err_csl1_part6_tmp;
        bank1_err_csl0_part7 <= bank_err_csl0_part7_tmp;
        bank1_err_csl1_part7 <= bank_err_csl1_part7_tmp;
        bank1_err_csl0_part8 <= bank_err_csl0_part8_tmp;
        bank1_err_csl1_part8 <= bank_err_csl1_part8_tmp;
        bank1_err_csl0_part9 <= bank_err_csl0_part9_tmp;
        bank1_err_csl1_part9 <= bank_err_csl1_part9_tmp;
        bank1_bist_bank_fail  <= bank_bist_bank_fail_tmp;

    end
end
assign bank_err_csl0_part0 = {bank1_err_csl0_part0,bank0_err_csl0_part0};
assign bank_err_csl1_part0 = {bank1_err_csl1_part0,bank0_err_csl1_part0};
assign bank_err_csl0_part1 = {bank1_err_csl0_part1,bank0_err_csl0_part1};
assign bank_err_csl1_part1 = {bank1_err_csl1_part1,bank0_err_csl1_part1};
assign bank_err_csl0_part2 = {bank1_err_csl0_part2,bank0_err_csl0_part2};
assign bank_err_csl1_part2 = {bank1_err_csl1_part2,bank0_err_csl1_part2};
assign bank_err_csl0_part3 = {bank1_err_csl0_part3,bank0_err_csl0_part3};
assign bank_err_csl1_part3 = {bank1_err_csl1_part3,bank0_err_csl1_part3};
assign bank_err_csl0_part4 = {bank1_err_csl0_part4,bank0_err_csl0_part4};
assign bank_err_csl1_part4 = {bank1_err_csl1_part4,bank0_err_csl1_part4};
assign bank_err_csl0_part5 = {bank1_err_csl0_part5,bank0_err_csl0_part5};
assign bank_err_csl1_part5 = {bank1_err_csl1_part5,bank0_err_csl1_part5};
assign bank_err_csl0_part6 = {bank1_err_csl0_part6,bank0_err_csl0_part6};
assign bank_err_csl1_part6 = {bank1_err_csl1_part6,bank0_err_csl1_part6};
assign bank_err_csl0_part7 = {bank1_err_csl0_part7,bank0_err_csl0_part7};
assign bank_err_csl1_part7 = {bank1_err_csl1_part7,bank0_err_csl1_part7};
assign bank_err_csl0_part8 = {bank1_err_csl0_part8,bank0_err_csl0_part8};
assign bank_err_csl1_part8 = {bank1_err_csl1_part8,bank0_err_csl1_part8};
assign bank_err_csl0_part9 = {bank1_err_csl0_part9,bank0_err_csl0_part9};
assign bank_err_csl1_part9 = {bank1_err_csl1_part9,bank0_err_csl1_part9};
assign bank_bist_bank_fail = {bank1_bist_bank_fail,bank0_bist_bank_fail};

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_bist_finish <= 1'b0;
    else if(global_mc_bist_start || bist_finish_clr)
        bank0_bist_finish <= 1'b0;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b0 && (bank_bist_bank_fail[0] || bank_bist_wl_finish[0] || bank_bist_csl_fail))
        bank0_bist_finish <= 1'b1;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b1 && (bank_bist_bank_fail[0] || bank_bist_wl_finish[0]))
        bank0_bist_finish <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank1_bist_finish <= 1'b0;
    else if(global_mc_bist_start || bist_finish_clr)
        bank1_bist_finish <= 1'b0;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b0 && (bank_bist_bank_fail[1] || bank_bist_wl_finish[1] || bank_bist_csl_fail))
        bank1_bist_finish <= 1'b1;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b1 && (bank_bist_bank_fail[1] || bank_bist_wl_finish[1]))
        bank1_bist_finish <= 1'b1;
end




always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_bist_success <= 1'b0;
    else if(global_mc_bist_start)
        bank0_bist_success <= 1'b0;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b0 && bank_bist_bank_success && bank_bist_wl_success[0] && !bank_bist_csl_fail )
        bank0_bist_success <= 1'b1;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b1 && bank_bist_bank_success && bank_bist_wl_success[0])
        bank0_bist_success <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank1_bist_success <= 1'b0;
    else if(global_mc_bist_start)
        bank1_bist_success <= 1'b0;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b0 && bank_bist_bank_success && bank_bist_wl_success[1] && !bank_bist_csl_fail )
        bank1_bist_success <= 1'b1;
    else if(SCAN_CS == BANK1 && csl_scan_mode_sel==1'b1 && bank_bist_bank_success && bank_bist_wl_success[1])
        bank1_bist_success <= 1'b1;
end

assign bank_bist_finish = {bank1_bist_finish,bank0_bist_finish} ;
assign bank_bist_success = {bank1_bist_success,bank0_bist_success} ;

assign all_bank_bist_finish_status = {bank1_bist_finish,bank0_bist_finish} ;
assign all_bank_bist_success_status = {bank1_bist_success,bank0_bist_success} ;
end
else begin:inst3
reg                                                             bank0_bist_success                 ;
reg                                                             bank0_bist_finish                  ;
wire                                                            bank1_bist_finish                  ;
wire                                                            bank2_bist_finish                  ;
wire                                                            bank3_bist_finish                  ;

reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl0_part9               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank0_err_csl1_part9               ;

reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part0               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part1               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part2               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part3               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part4               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part5               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part6               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part7               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part8               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl0_part9               ;
reg [ARRAY_COL_ADDR_WIDTH-1:0]                                  bank1_err_csl1_part9               ;
reg                                                             bank0_bist_bank_fail               ;

assign bank1_bist_finish = 1'b0;
assign bank2_bist_finish = 1'b0;
assign bank3_bist_finish = 1'b0;

always @(*)begin
    case(SCAN_CS)
    IDLE:begin
        if(global_mc_bist_start && mc_bist_grant[0])
            SCAN_NS = BANK0;
        else if(global_mc_bist_start && mc_bist_grant[1:0]==2'b10)
            SCAN_NS = BANK1;
        else if(global_mc_bist_start && mc_bist_grant[2:0]==3'b100)
            SCAN_NS = BANK2;
        else if(global_mc_bist_start && mc_bist_grant[3:0]==4'b1000)
            SCAN_NS = BANK3;        
        else
            SCAN_NS = SCAN_CS;
    end
    BANK0:begin
        if(bank0_bist_finish && mc_bist_grant[3:1]==3'b000)
            SCAN_NS = IDLE;
        else if(bank0_bist_finish && mc_bist_grant[1])
            SCAN_NS = BANK1;
        else if(bank0_bist_finish && mc_bist_grant[2:1]==2'b10)
            SCAN_NS = BANK2;
        else if(bank0_bist_finish && mc_bist_grant[3:1]==3'b100)
            SCAN_NS = BANK3;
        else
            SCAN_NS = SCAN_CS;
    end
    BANK1:begin
        if(bank1_bist_finish && mc_bist_grant[3:2]==2'b00)
            SCAN_NS = IDLE;
        else if(bank1_bist_finish && mc_bist_grant[2])
            SCAN_NS = BANK2;
        else if(bank1_bist_finish && mc_bist_grant[3:2]==2'b10)
            SCAN_NS = BANK3;
        else
            SCAN_NS = SCAN_CS;
    end
    BANK2:begin
        if(bank2_bist_finish && mc_bist_grant[3]==1'b0)
            SCAN_NS = IDLE;
        else if(bank2_bist_finish && mc_bist_grant[3])
            SCAN_NS = BANK3;
        else
            SCAN_NS = SCAN_CS;
    end
    BANK3:begin
        if(bank3_bist_finish)
            SCAN_NS = IDLE;
        else
            SCAN_NS = SCAN_CS;
    end
    default:SCAN_NS = IDLE;
    endcase
end


always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank0_err_csl0_part0 <= 8'hFF;
        bank0_err_csl1_part0 <= 8'hFF;
        bank0_err_csl0_part1 <= 8'hFF;
        bank0_err_csl1_part1 <= 8'hFF;
        bank0_err_csl0_part2 <= 8'hFF;
        bank0_err_csl1_part2 <= 8'hFF;
        bank0_err_csl0_part3 <= 8'hFF;
        bank0_err_csl1_part3 <= 8'hFF;
        bank0_err_csl0_part4 <= 8'hFF;
        bank0_err_csl1_part4 <= 8'hFF;
        bank0_err_csl0_part5 <= 8'hFF;
        bank0_err_csl1_part5 <= 8'hFF;
        bank0_err_csl0_part6 <= 8'hFF;
        bank0_err_csl1_part6 <= 8'hFF;
        bank0_err_csl0_part7 <= 8'hFF;
        bank0_err_csl1_part7 <= 8'hFF;
        bank0_err_csl0_part8 <= 8'hFF;
        bank0_err_csl1_part8 <= 8'hFF;
        bank0_err_csl0_part9 <= 8'hFF;
        bank0_err_csl1_part9 <= 8'hFF;
        bank0_bist_bank_fail  <= 1'b0;
        
    end
    else if(global_mc_bist_start)begin
        bank0_err_csl0_part0 <= 8'hFF;
        bank0_err_csl1_part0 <= 8'hFF;
        bank0_err_csl0_part1 <= 8'hFF;
        bank0_err_csl1_part1 <= 8'hFF;
        bank0_err_csl0_part2 <= 8'hFF;
        bank0_err_csl1_part2 <= 8'hFF;
        bank0_err_csl0_part3 <= 8'hFF;
        bank0_err_csl1_part3 <= 8'hFF;
        bank0_err_csl0_part4 <= 8'hFF;
        bank0_err_csl1_part4 <= 8'hFF;
        bank0_err_csl0_part5 <= 8'hFF;
        bank0_err_csl1_part5 <= 8'hFF;
        bank0_err_csl0_part6 <= 8'hFF;
        bank0_err_csl1_part6 <= 8'hFF;
        bank0_err_csl0_part7 <= 8'hFF;
        bank0_err_csl1_part7 <= 8'hFF;
        bank0_err_csl0_part8 <= 8'hFF;
        bank0_err_csl1_part8 <= 8'hFF;
        bank0_err_csl0_part9 <= 8'hFF;
        bank0_err_csl1_part9 <= 8'hFF;
        bank0_bist_bank_fail  <= 1'b0;

    end
    else if(SCAN_NS == BANK0) begin
        bank0_err_csl0_part0 <= bank_err_csl0_part0_tmp;
        bank0_err_csl1_part0 <= bank_err_csl1_part0_tmp;
        bank0_err_csl0_part1 <= bank_err_csl0_part1_tmp;
        bank0_err_csl1_part1 <= bank_err_csl1_part1_tmp;
        bank0_err_csl0_part2 <= bank_err_csl0_part2_tmp;
        bank0_err_csl1_part2 <= bank_err_csl1_part2_tmp;
        bank0_err_csl0_part3 <= bank_err_csl0_part3_tmp;
        bank0_err_csl1_part3 <= bank_err_csl1_part3_tmp;
        bank0_err_csl0_part4 <= bank_err_csl0_part4_tmp;
        bank0_err_csl1_part4 <= bank_err_csl1_part4_tmp;
        bank0_err_csl0_part5 <= bank_err_csl0_part5_tmp;
        bank0_err_csl1_part5 <= bank_err_csl1_part5_tmp;
        bank0_err_csl0_part6 <= bank_err_csl0_part6_tmp;
        bank0_err_csl1_part6 <= bank_err_csl1_part6_tmp;
        bank0_err_csl0_part7 <= bank_err_csl0_part7_tmp;
        bank0_err_csl1_part7 <= bank_err_csl1_part7_tmp;
        bank0_err_csl0_part8 <= bank_err_csl0_part8_tmp;
        bank0_err_csl1_part8 <= bank_err_csl1_part8_tmp;
        bank0_err_csl0_part9 <= bank_err_csl0_part9_tmp;
        bank0_err_csl1_part9 <= bank_err_csl1_part9_tmp;
        bank0_bist_bank_fail  <= bank_bist_bank_fail_tmp;
    end
end

assign bank_err_csl0_part0 = bank0_err_csl0_part0;
assign bank_err_csl1_part0 = bank0_err_csl1_part0;
assign bank_err_csl0_part1 = bank0_err_csl0_part1;
assign bank_err_csl1_part1 = bank0_err_csl1_part1;
assign bank_err_csl0_part2 = bank0_err_csl0_part2;
assign bank_err_csl1_part2 = bank0_err_csl1_part2;
assign bank_err_csl0_part3 = bank0_err_csl0_part3;
assign bank_err_csl1_part3 = bank0_err_csl1_part3;
assign bank_err_csl0_part4 = bank0_err_csl0_part4;
assign bank_err_csl1_part4 = bank0_err_csl1_part4;
assign bank_err_csl0_part5 = bank0_err_csl0_part5;
assign bank_err_csl1_part5 = bank0_err_csl1_part5;
assign bank_err_csl0_part6 = bank0_err_csl0_part6;
assign bank_err_csl1_part6 = bank0_err_csl1_part6;
assign bank_err_csl0_part7 = bank0_err_csl0_part7;
assign bank_err_csl1_part7 = bank0_err_csl1_part7;
assign bank_err_csl0_part8 = bank0_err_csl0_part8;
assign bank_err_csl1_part8 = bank0_err_csl1_part8;
assign bank_err_csl0_part9 = bank0_err_csl0_part9;
assign bank_err_csl1_part9 = bank0_err_csl1_part9;

assign bank_bist_bank_fail = bank0_bist_bank_fail;




always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_bist_finish <= 1'b0;
    else if(global_mc_bist_start || bist_finish_clr)
        bank0_bist_finish <= 1'b0;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b0 && (bank_bist_bank_fail[0] || bank_bist_wl_finish[0] || bank_bist_csl_fail))
        bank0_bist_finish <= 1'b1;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b1 && (bank_bist_bank_fail[0] || bank_bist_wl_finish[0]))
        bank0_bist_finish <= 1'b1;
end






always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_bist_success <= 1'b0;
    else if(global_mc_bist_start)
        bank0_bist_success <= 1'b0;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b0 && bank_bist_bank_success && bank_bist_wl_success[0] && !bank_bist_csl_fail )
        bank0_bist_success <= 1'b1;
    else if(SCAN_CS == BANK0 && csl_scan_mode_sel==1'b1 && bank_bist_bank_success && bank_bist_wl_success[0])
        bank0_bist_success <= 1'b1;
end


assign bank_bist_finish = bank0_bist_finish ;
assign bank_bist_success = bank0_bist_success ;

assign all_bank_bist_finish_status = bank0_bist_finish;
assign all_bank_bist_success_status = bank0_bist_success ;
end
endgenerate

always @(*)begin
    grant_bist_finish = 1'b0;
    grant_bist_success = 1'b0;
    for(II=0;II<MC_SHORT_MODE;II=II+1)begin
        if(II==0)begin
            if(mc_bist_grant[II])begin
                grant_bist_finish = all_bank_bist_finish_status[II];
                grant_bist_success = all_bank_bist_success_status[II];
            end
        end
        else begin
            if(mc_bist_grant[II])begin
                grant_bist_finish = grant_bist_finish && all_bank_bist_finish_status[II];
                grant_bist_success = grant_bist_success && all_bank_bist_success_status[II];
            end
        end
    end
end
assign bist_finish_status =  grant_bist_finish;
assign bist_success_status = grant_bist_success;
assign bist_finish_intr = bist_finish_int_mask ? 1'b0 : bist_finish_status;

endmodule
