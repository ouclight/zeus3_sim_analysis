module bist_scan_aux #(
    parameter   ARRAY_ADDR_WIDTH      = 13+8                               ,
    parameter   CHECKBIT_WIDTH        = 16                                 ,
    parameter   ARRAY_ROW_ADDR_WIDTH  = 13                                 ,
    parameter   ARRAY_COL_ADDR_WIDTH  = 8                                  ,
    parameter   ARRAY_DATA_WIDTH      = 256  
)( //-------------clock and reset signal--------------
  input                                                         clk                                 ,
  input                                                         rst_n                               ,
  input                                                         global_bist_clr                     ,

  //-------------control signal----------------------
  input                                                         global_mc_bist_start                ,
  input                                                         global_mc_bist_en                   ,
  input                                                         mc_bist_en                          ,
  input                                                         bist_csl_vmc_en                     ,//default 1


  input                                                         csl_scan_addr_range_sel             ,//default 1,scan all addr
  input                                                         csl_scan_check_sel                  ,//default 1,check 272 bit rdata
  input      [3:0]                                              bist_wl_scan_single_pattern_rd_num  ,//max 16,default 0:read one time
  input      [67:0]                                             csl_bist_pattern_sel                ,//every bit correspond to every pattern,1:valid
  input      [67:0]                                             wl_bist_pattern_sel                 ,
  input                                                         csl_scan_mode_sel                   ,//0:abort 1:continue,default 0
  input      [68*32-1:0]                                        bist_pattern_all                    ,
  

  output                                                        bist_success                        ,
  output                                                        bist_finish                         ,
  output                                                        bist_bank_finish                    ,//apb debug
  output                                                        bist_finish_int                     ,
  input                                                         bist_finish_clr                     ,
  input                                                         bist_finish_int_mask                ,
  input      [4:0]                                              csl_err_threshold                   ,
  input                                                         mc_timeout_flag                     ,
  output     [2:0]                                              bist_scan_status                    , //wl_scan_working,csl_scan_working,bank_scan_working
  //-------------data signal------------------------
  output                                                        bank_scan_frame_vld                 ,
  input                                                         bank_scan_frame_rdy                 ,
  output     [3+CHECKBIT_WIDTH+256+ARRAY_ADDR_WIDTH-1 :0]       bank_scan_frame_data                ,//rw_flag,sof,eof,data,row,col
  input                                                         bank_scan_rvalid                    ,
  input      [CHECKBIT_WIDTH+ARRAY_DATA_WIDTH-1:0]              bank_scan_rdata                     ,

  output                                                        csl_scan_frame_vld                  ,
  input                                                         csl_scan_frame_rdy                  ,

  output     [3+CHECKBIT_WIDTH+ARRAY_DATA_WIDTH+ARRAY_ADDR_WIDTH-1 :0] csl_scan_frame_data          ,//rw_flag,sof,eof,data,row,col
  input                                                         csl_scan_rvalid                     ,
  input      [CHECKBIT_WIDTH+ARRAY_DATA_WIDTH-1:0]              csl_scan_rdata                      ,

  output                                                        wl_scan_frame_vld                   ,
  input                                                         wl_scan_frame_rdy                   ,
  output     [3+CHECKBIT_WIDTH+ARRAY_DATA_WIDTH+ARRAY_ADDR_WIDTH-1 :0] wl_scan_frame_data           ,//rw_flag,sof,eof,data,row,col
  input                                                         wl_scan_rvalid                      ,
  input      [CHECKBIT_WIDTH+ARRAY_DATA_WIDTH-1:0]              wl_scan_rdata                       ,
  //-------------error wl record signal------------
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl0_part0                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl1_part0                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl0_part1                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl1_part1                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl0_part2                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl1_part2                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl0_part3                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl1_part3                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl0_part4                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl1_part4                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl0_part5                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl1_part5                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl0_part6                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl1_part6                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl0_part7                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl1_part7                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl0_part8                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl1_part8                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl0_part9                      ,
  output     [ARRAY_COL_ADDR_WIDTH-1:0]                         err_csl1_part9                      ,


  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl0                             ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl1                             ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl2                             ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl3                             ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl4                             ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl5                             ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl6                             ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl7                             ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl8                             ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl9                             ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl10                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl11                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl12                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl13                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl14                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl15                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl16                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl17                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl18                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl19                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl20                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl21                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl22                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl23                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl24                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl25                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl26                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl27                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl28                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl29                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl30                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl31                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl32                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl33                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl34                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl35                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl36                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl37                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl38                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl39                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl40                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl41                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl42                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl43                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl44                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl45                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl46                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl47                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl48                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl49                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl50                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl51                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl52                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl53                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl54                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl55                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl56                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl57                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl58                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl59                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl60                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl61                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl62                            ,
  output     [ARRAY_ROW_ADDR_WIDTH-1:0]                         err_wl63                            ,
  output     [6:0]                                              err_wl_cnt                          , 
  output                                                        err_wl_cnt_change_flag
  
                            
);
//---------------------------------------------------------------
//wire and reg define
wire                                                                      wl_init_frame_vld    ;
wire                                                                      wl_init_frame_rdy    ;
wire     [3+CHECKBIT_WIDTH+ARRAY_DATA_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH-2 :0]                    wl_init_frame_data   ;//rw_flag,sof,eof,data,row,col
wire                                                                      wl_init_rvalid       ;
wire     [CHECKBIT_WIDTH+ARRAY_DATA_WIDTH-1:0]                            wl_init_rdata        ; 

wire                                                                      bist_bank_success    ;
wire                                                                      bist_wl_success      ;
wire                                                                      bist_wl_finish       ;
wire                                                                      bank_scan_finish     ;
wire                                                                      csl_scan_finish      ;
wire                                                                      bank_scan_working    ;
wire                                                                      csl_scan_working     ;
wire                                                                      wl_scan_working      ;
wire                                                                      bist_csl_fail        ;
            
reg      [68*32-1:0]                                                      csl_selected_pattern ;
reg      [6:0]                                                            csl_pattern_index    ;

reg      [68*32-1:0]                                                      wl_selected_pattern  ;
reg      [6:0]                                                            wl_pattern_index     ;


integer  II;




assign  bist_success     = csl_scan_mode_sel==1'b0 ? bist_bank_success && bist_wl_success && !bist_csl_fail : bist_bank_success && bist_wl_success;

assign  bist_finish      = csl_scan_mode_sel==1'b0 ? bist_bank_finish || bist_wl_finish || bist_csl_fail : bist_bank_finish || bist_wl_finish;

assign  bist_finish_int  = bist_finish_int_mask ? 1'b0 : bist_finish ;

assign  bist_scan_status = {wl_scan_working,csl_scan_working,bank_scan_working };

//-------------------bist pattern select-------------------------
always @(*)begin
    wl_pattern_index = 7'h0;
    for(II=0;II<68;II=II+1)begin:select_valid_wl_bist_pattern
        if(wl_bist_pattern_sel[II]==1'b1)begin
            wl_pattern_index = wl_pattern_index + 1'b1;
        end
    end
end

//---------------------------------------------------------------
bank_scan_aux #(
          .ARRAY_ADDR_WIDTH    (ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH ),
          .CHECKBIT_WIDTH      (CHECKBIT_WIDTH                            ),
          .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH                          )
)U_bank_scan(
  .clk                  (clk                   ),
  .rst_n                (rst_n                 ),
  //.ras_clr              (ras_clr               ),
  .global_mc_bist_start (global_mc_bist_start  ),
  .global_mc_bist_en    (global_mc_bist_en     ),
  .mc_bist_en           (mc_bist_en            ),
  .bist_bank_success    (bist_bank_success     ),
  .bist_bank_finish     (bist_bank_finish      ),
  .bist_finish_clr      (bist_finish_clr       ),
  .mc_timeout_flag      (mc_timeout_flag       ),
  .bank_scan_finish     (bank_scan_finish      ),
  .bank_scan_working    (bank_scan_working     ),
  .bank_scan_frame_vld  (bank_scan_frame_vld   ),
  .bank_scan_frame_rdy  (bank_scan_frame_rdy   ),
  .bank_scan_frame_data (bank_scan_frame_data  ),//rw_flag,sof,eof,data,row,col
  .bank_scan_rvalid     (bank_scan_rvalid      ),
  .bank_scan_rdata      (bank_scan_rdata       ));

csl_scan_aux #(
          .ARRAY_ADDR_WIDTH    (ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH ),
          .CHECKBIT_WIDTH      (CHECKBIT_WIDTH                            ),
          .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH                      ),
          .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH                      ),
          .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH                          )
)U_csl_scan(
  .clk                  (clk                   ),
  .rst_n                (rst_n                 ),
  //.bist_csl_vmc_en      (bist_csl_vmc_en       ),
  .csl_scan_addr_range_sel(csl_scan_addr_range_sel),
  .csl_scan_check_sel   (csl_scan_check_sel    ),
  .csl_scan_mode_sel    (csl_scan_mode_sel     ),
  .global_mc_bist_start (global_mc_bist_start  ),
  .global_mc_bist_en    (global_mc_bist_en     ),
  .mc_bist_en           (mc_bist_en            ),
  .bist_finish_clr      (bist_finish_clr       ),
  .bank_scan_finish     (bank_scan_finish      ),
  //.bist_csl_scan_num    (bist_csl_scan_num     ),
  .csl_err_threshold    (csl_err_threshold     ),
    .csl_scan_finish      (csl_scan_finish       ) ,
  .csl_scan_fail        (bist_csl_fail         ) ,
  .csl_scan_working     (csl_scan_working      ) ,
  .csl_scan_frame_vld   (csl_scan_frame_vld    ) ,
  .csl_scan_frame_rdy   (csl_scan_frame_rdy    ) ,
  .csl_scan_frame_data  (csl_scan_frame_data   ) ,//rw_flag,sof,eof,data,row,col
  .csl_scan_rvalid      (csl_scan_rvalid       ) ,
  .csl_scan_rdata       (csl_scan_rdata        ) ,

  .bist_pattern_all     (bist_pattern_all      ) ,
  .csl_bist_pattern_sel (csl_bist_pattern_sel  ) ,
  
  .err_csl0_part0       (err_csl0_part0        ) ,
  .err_csl1_part0       (err_csl1_part0        ) ,
  .err_csl0_part1       (err_csl0_part1        ) ,
  .err_csl1_part1       (err_csl1_part1        ) ,
  .err_csl0_part2       (err_csl0_part2        ) ,
  .err_csl1_part2       (err_csl1_part2        ) ,
  .err_csl0_part3       (err_csl0_part3        ) ,
  .err_csl1_part3       (err_csl1_part3        ) ,
  .err_csl0_part4       (err_csl0_part4        ) ,
  .err_csl1_part4       (err_csl1_part4        ) ,
  .err_csl0_part5       (err_csl0_part5        ) ,
  .err_csl1_part5       (err_csl1_part5        ) ,
  .err_csl0_part6       (err_csl0_part6        ) ,
  .err_csl1_part6       (err_csl1_part6        ) ,
  .err_csl0_part7       (err_csl0_part7        ) ,
  .err_csl1_part7       (err_csl1_part7        ) ,
  .err_csl0_part8       (err_csl0_part8        ) ,
  .err_csl1_part8       (err_csl1_part8        ) ,
  .err_csl0_part9       (err_csl0_part9        ) ,
  .err_csl1_part9       (err_csl1_part9        ) 



  );

wl_scan_aux #(
          .ARRAY_ADDR_WIDTH    (ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH ),
          .CHECKBIT_WIDTH      (CHECKBIT_WIDTH                            ),
          .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH                      ),
          .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH                      ),
          .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH                          )
)U_wl_scan(
  .clk                  (clk                   ) ,
  .rst_n                (rst_n                 ) ,
  .global_mc_bist_start (global_mc_bist_start  ) ,
  .global_mc_bist_en    (global_mc_bist_en     ) ,
  .global_bist_clr      (global_bist_clr       ) ,
  .err_wl_cnt           (err_wl_cnt            ) ,
  .err_wl_cnt_change_flag(err_wl_cnt_change_flag),
  .mc_bist_en           (mc_bist_en            ) ,
  .csl_scan_finish      (csl_scan_finish       ) ,
  //.bist_wl_scan_num     (bist_wl_scan_num      ) ,
  .bist_wl_scan_single_pattern_rd_num(bist_wl_scan_single_pattern_rd_num),
  .bist_pattern_all     (bist_pattern_all      ) ,
  .wl_bist_pattern_sel  (wl_bist_pattern_sel    ) ,
  .bist_wl_success      (bist_wl_success       ) , 
  .bist_wl_finish       (bist_wl_finish        ) ,
  .bist_finish_clr      (bist_finish_clr       ) ,
  .wl_scan_working      (wl_scan_working       ) ,
  .wl_scan_frame_vld    (wl_init_frame_vld     ) ,
  .wl_scan_frame_rdy    (wl_init_frame_rdy     ) ,
  .wl_scan_frame_data   (wl_init_frame_data    ) ,//rw_flag,sof,eof,data,row,col
  .wl_scan_rvalid       (wl_init_rvalid        ) ,
  .wl_scan_rdata        (wl_init_rdata         ) ,
  .err_wl0              (err_wl0               ) ,
  .err_wl1              (err_wl1               ) ,
  .err_wl2              (err_wl2               ) ,
  .err_wl3              (err_wl3               ) ,
  .err_wl4              (err_wl4               ) ,
  .err_wl5              (err_wl5               ) ,
  .err_wl6              (err_wl6               ) ,
  .err_wl7              (err_wl7               ) ,
  .err_wl8              (err_wl8               ) ,
  .err_wl9              (err_wl9               ) ,
  .err_wl10             (err_wl10              )  ,
  .err_wl11             (err_wl11              )  ,
  .err_wl12             (err_wl12              )  ,
  .err_wl13             (err_wl13              )  ,
  .err_wl14             (err_wl14              )  ,
  .err_wl15             (err_wl15              )  ,
  .err_wl16             (err_wl16              )  ,
  .err_wl17             (err_wl17              )  ,
  .err_wl18             (err_wl18              )  ,
  .err_wl19             (err_wl19              )  ,
  .err_wl20             (err_wl20              )  ,
  .err_wl21             (err_wl21              )  ,
  .err_wl22             (err_wl22              )  ,
  .err_wl23             (err_wl23              )  ,
  .err_wl24             (err_wl24              )  ,
  .err_wl25             (err_wl25              )  ,
  .err_wl26             (err_wl26              )  ,
  .err_wl27             (err_wl27              )  ,
  .err_wl28             (err_wl28              )  ,
  .err_wl29             (err_wl29              )  ,
  .err_wl30             (err_wl30              )  ,
  .err_wl31             (err_wl31              )  ,
  .err_wl32             (err_wl32              )  ,
  .err_wl33             (err_wl33              )  ,
  .err_wl34             (err_wl34              )  ,
  .err_wl35             (err_wl35              )  ,
  .err_wl36             (err_wl36              )  ,
  .err_wl37             (err_wl37              )  ,
  .err_wl38             (err_wl38              )  ,
  .err_wl39             (err_wl39              )  ,
  .err_wl40             (err_wl40              )  ,
  .err_wl41             (err_wl41              )  ,
  .err_wl42             (err_wl42              )  ,
  .err_wl43             (err_wl43              )  ,
  .err_wl44             (err_wl44              )  ,
  .err_wl45             (err_wl45              )  ,
  .err_wl46             (err_wl46              )  ,
  .err_wl47             (err_wl47              )  ,
  .err_wl48             (err_wl48              )  ,
  .err_wl49             (err_wl49              )  ,
  .err_wl50             (err_wl50              )  ,
  .err_wl51             (err_wl51              )  ,
  .err_wl52             (err_wl52              )  ,
  .err_wl53             (err_wl53              )  ,
  .err_wl54             (err_wl54              )  ,
  .err_wl55             (err_wl55              )  ,
  .err_wl56             (err_wl56              )  ,
  .err_wl57             (err_wl57              )  ,
  .err_wl58             (err_wl58              )  ,
  .err_wl59             (err_wl59              )  ,
  .err_wl60             (err_wl60              )  ,
  .err_wl61             (err_wl61              )  ,
  .err_wl62             (err_wl62              )  ,
  .err_wl63             (err_wl63              ) 
   );

bist_csl_vmc_aux #(

          .ARRAY_ADDR_WIDTH    (ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH ),
          .CHECKBIT_WIDTH      (CHECKBIT_WIDTH                            ),
          .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH                      ),
          .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH                      ),
          .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH                          )

)U_bist_csl_vmc(
  .bist_csl_vmc_en      (bist_csl_vmc_en     ),
  .err_csl0_part0       (err_csl0_part0      ),
  .err_csl1_part0       (err_csl1_part0      ),
  .err_csl0_part1       (err_csl0_part1      ),
  .err_csl1_part1       (err_csl1_part1      ),
  .err_csl0_part2       (err_csl0_part2      ),
  .err_csl1_part2       (err_csl1_part2      ),
  .err_csl0_part3       (err_csl0_part3      ),
  .err_csl1_part3       (err_csl1_part3      ),
  .err_csl0_part4       (err_csl0_part4      ),
  .err_csl1_part4       (err_csl1_part4      ),
  .err_csl0_part5       (err_csl0_part5      ),
  .err_csl1_part5       (err_csl1_part5      ),
  .err_csl0_part6       (err_csl0_part6      ),
  .err_csl1_part6       (err_csl1_part6      ),
  .err_csl0_part7       (err_csl0_part7      ),
  .err_csl1_part7       (err_csl1_part7      ),
  .err_csl0_part8       (err_csl0_part8      ),
  .err_csl1_part8       (err_csl1_part8      ),
  .err_csl0_part9       (err_csl0_part9      ),
  .err_csl1_part9       (err_csl1_part9      ),

  .wl_init_frame_vld    (wl_init_frame_vld   ),
  .wl_init_frame_rdy    (wl_init_frame_rdy   ),
  .wl_init_frame_data   (wl_init_frame_data  ),//rw_flag,sof,eof,data,row,col
  .wl_init_rvalid       (wl_init_rvalid      ),
  .wl_init_rdata        (wl_init_rdata       ), 
  .wl_vmc_frame_vld     (wl_scan_frame_vld   ),
  .wl_vmc_frame_rdy     (wl_scan_frame_rdy   ),
  .wl_vmc_frame_data    (wl_scan_frame_data  ),//rw_flag,sof,eof,data,row,col
  .wl_vmc_rvalid        (wl_scan_rvalid      ),
  .wl_vmc_rdata         (wl_scan_rdata       )  );  

endmodule
