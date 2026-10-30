module bist_rescan_aux_top #(
    parameter   RESCAN_ROUND_NUM    = 15,
    parameter   MC_CTRL_BANK_NUM    = 2,
    parameter   MC_FRAME_WIDTH      = 292   // wr,sof,eof,bank_sel,ecc,data,row,col
)(
  //-------------clock and reset signal--------------
  input                                               clk                                 ,
  input                                               rst_n                               ,
  //input                                               ras_clr                             ,
  //-------------control signal----------------------                                     
  input                                               global_mc_bist_en                   ,
  input                                               global_mc_rescan_start              ,//default 0
  input                                               mc_bist_en                          ,
  //input      [6:0]                                    bist_wl_scan_num                    ,//pattern num				
  input      [3:0]                                    bist_rescan_num                     ,//default 3
  output     [20*MC_CTRL_BANK_NUM-1:0]                bist_rescan_fail_num                ,
  output     [RESCAN_ROUND_NUM*MC_CTRL_BANK_NUM-1:0]  rescan_round_result                 ,
  input                                               bist_rescan_sel                     ,//1:7360-64,0:7360,default 1
  //input      [31:0]                                   bist_pattern0                       ,
  //input      [31:0]                                   bist_pattern1                       ,
  //input      [31:0]                                   bist_pattern2                       ,
  //input      [31:0]                                   bist_pattern3                       ,
  //input      [31:0]                                   bist_pattern4                       ,
  //input      [31:0]                                   bist_pattern5                       ,
  //input      [31:0]                                   bist_pattern6                       ,
  //input      [31:0]                                   bist_pattern7                       ,
  //input      [31:0]                                   bist_pattern8                       ,
  //input      [31:0]                                   bist_pattern9                       ,
  //input      [31:0]                                   bist_pattern10                      ,
  //input      [31:0]                                   bist_pattern11                      ,
  //input      [31:0]                                   bist_pattern12                      ,
  //input      [31:0]                                   bist_pattern13                      ,
  //input      [31:0]                                   bist_pattern14                      ,
  //input      [31:0]                                   bist_pattern15                      ,
  //input      [31:0]                                   bist_pattern16                      ,
  //input      [31:0]                                   bist_pattern17                      ,
  //input      [31:0]                                   bist_pattern18                      ,
  //input      [31:0]                                   bist_pattern19                      ,
  //input      [31:0]                                   bist_pattern20                      ,
  //input      [31:0]                                   bist_pattern21                      ,
  //input      [31:0]                                   bist_pattern22                      ,
  //input      [31:0]                                   bist_pattern23                      ,
  //input      [31:0]                                   bist_pattern24                      ,
  //input      [31:0]                                   bist_pattern25                      ,
  //input      [31:0]                                   bist_pattern26                      ,
  //input      [31:0]                                   bist_pattern27                      ,
  //input      [31:0]                                   bist_pattern28                      ,
  //input      [31:0]                                   bist_pattern29                      ,
  //input      [31:0]                                   bist_pattern30                      ,
  //input      [31:0]                                   bist_pattern31                      ,
  //input      [31:0]                                   bist_pattern32                      ,
  //input      [31:0]                                   bist_pattern33                      ,
  //input      [31:0]                                   bist_pattern34                      ,
  //input      [31:0]                                   bist_pattern35                      ,
  //input      [31:0]                                   bist_pattern36                      ,
  //input      [31:0]                                   bist_pattern37                      ,
  //input      [31:0]                                   bist_pattern38                      ,
  //input      [31:0]                                   bist_pattern39                      ,
  //input      [31:0]                                   bist_pattern40                      ,
  //input      [31:0]                                   bist_pattern41                      ,
  //input      [31:0]                                   bist_pattern42                      ,
  //input      [31:0]                                   bist_pattern43                      ,
  //input      [31:0]                                   bist_pattern44                      ,
  //input      [31:0]                                   bist_pattern45                      ,
  //input      [31:0]                                   bist_pattern46                      ,
  //input      [31:0]                                   bist_pattern47                      ,
  //input      [31:0]                                   bist_pattern48                      ,
  //input      [31:0]                                   bist_pattern49                      ,
  //input      [31:0]                                   bist_pattern50                      ,
  //input      [31:0]                                   bist_pattern51                      ,
  //input      [31:0]                                   bist_pattern52                      ,
  //input      [31:0]                                   bist_pattern53                      ,
  //input      [31:0]                                   bist_pattern54                      ,
  //input      [31:0]                                   bist_pattern55                      ,
  //input      [31:0]                                   bist_pattern56                      ,
  //input      [31:0]                                   bist_pattern57                      ,
  //input      [31:0]                                   bist_pattern58                      ,
  //input      [31:0]                                   bist_pattern59                      ,
  //input      [31:0]                                   bist_pattern60                      ,
  //input      [31:0]                                   bist_pattern61                      ,
  //input      [31:0]                                   bist_pattern62                      ,
  //input      [31:0]                                   bist_pattern63                      ,  
  //input      [31:0]                                   bist_pattern_reg0                   ,
  //input      [31:0]                                   bist_pattern_reg1                   ,
  //input      [31:0]                                   bist_pattern_reg2                   ,
  //input      [31:0]                                   bist_pattern_reg3                   ,

  input      [68*32-1:0]                              bist_pattern_all                    ,
  input      [31:0]                                   wl_bist_pattern_sel0                ,
  input      [31:0]                                   wl_bist_pattern_sel1                ,
  input      [3:0]                                    wl_bist_pattern_sel2                ,
																			              
  output reg                                          bist_rescan_success                 ,
  output reg                                          bist_rescan_finish                  ,
  output reg                                          bist_rescan_finish_status           ,
  //output reg                                          bist_rescan_finish_status_ras       ,
  input                                               rescan_finish_clr                   ,
  input                                               rescan_finish_mask                  ,
//  output                                              rescan_working                      ,
  //-------------data signal------------------------                                      
  output reg                                          rescan_frame_vld                    ,
  input                                               rescan_frame_rdy                    ,
  output reg [MC_FRAME_WIDTH-1 :0]                    rescan_frame_data                   ,//rw_flag,sof,eof,data,row,col
  input                                               rescan_rvalid                       ,
  input      [266-1:0]                                rescan_rdata                        ,
  //========================wy add 0427===================================
  input                                               bist_scan_start_bank                ,
  input                                               bist_scan_end_bank                  ,
  output                                              bank0_bist_rescan_success           ,
  output                                              bank0_bist_rescan_finish            ,
  output                                              bank0_bist_rescan_finish_status     ,
  output                                              bank1_bist_rescan_success           ,
  output                                              bank1_bist_rescan_finish            ,
  output                                              bank1_bist_rescan_finish_status     ,
  output    [1:0]                                     bank_scan_fsm_status                 
);

localparam  IDLE  = 2'd0,
            BANK0 = 2'd1,
            BANK1 = 2'd2;

wire                    bank0_global_mc_bist_en;
wire                    bank0_mc_bist_en;
reg                     bank0_global_mc_rescan_start;
wire    [3+266+21-1:0]  bank0_rescan_frame_data;
wire                    bank0_rescan_frame_vld;
reg                     bank0_rescan_rvalid;

wire                    bank1_global_mc_bist_en;
wire                    bank1_mc_bist_en;
reg                     bank1_global_mc_rescan_start;
wire    [3+266+21-1:0]  bank1_rescan_frame_data;
wire                    bank1_rescan_frame_vld;
reg                     bank1_rescan_rvalid;

wire    [67:0]          wl_bist_pattern_sel;
//========================Logic=========================================
reg     [1:0]   RESCAN_CS;
reg     [1:0]   RESCAN_NS;

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        RESCAN_CS <= IDLE;
    else
        RESCAN_CS <= RESCAN_NS;
end

always @(*)
begin
    case(RESCAN_CS)
        IDLE: begin
            if(global_mc_bist_en && global_mc_rescan_start && mc_bist_en) begin
                if(bist_scan_start_bank == 1'b0)
                    RESCAN_NS = BANK0;
                else
                    RESCAN_NS = BANK1;
            end
            else
                RESCAN_NS = IDLE;
        end
        BANK0: begin
            if (bank0_bist_rescan_finish_status) begin
                if(bist_scan_end_bank == 1'b0)
                    RESCAN_NS = IDLE;
                else
                    RESCAN_NS = BANK1;
            end
            else
                RESCAN_NS = BANK0;
        end
        BANK1: begin
            if (bank1_bist_rescan_finish_status) begin
                RESCAN_NS = IDLE;
            end
            else
                RESCAN_NS = BANK1;
        end
        default: RESCAN_NS = IDLE;
    endcase
end

//========================Pattern select================================
//assign bist_pattern_all =  {bist_pattern_reg3,bist_pattern_reg2,bist_pattern_reg1,bist_pattern_reg0,
//                            bist_pattern63,bist_pattern62,bist_pattern61,bist_pattern60,bist_pattern59,bist_pattern58,bist_pattern57,bist_pattern56,
//                            bist_pattern55,bist_pattern54,bist_pattern53,bist_pattern52,bist_pattern51,bist_pattern50,bist_pattern49,bist_pattern48,
//                            bist_pattern47,bist_pattern46,bist_pattern45,bist_pattern44,bist_pattern43,bist_pattern42,bist_pattern41,bist_pattern40,
//                            bist_pattern39,bist_pattern38,bist_pattern37,bist_pattern36,bist_pattern35,bist_pattern34,bist_pattern33,bist_pattern32,
//                            bist_pattern31,bist_pattern30,bist_pattern29,bist_pattern28,bist_pattern27,bist_pattern26,bist_pattern25,bist_pattern24,
//                            bist_pattern23,bist_pattern22,bist_pattern21,bist_pattern20,bist_pattern19,bist_pattern18,bist_pattern17,bist_pattern16,
//                            bist_pattern15,bist_pattern14,bist_pattern13,bist_pattern12,bist_pattern11,bist_pattern10,bist_pattern9,bist_pattern8,
//                            bist_pattern7,bist_pattern6,bist_pattern5,bist_pattern4,bist_pattern3,bist_pattern2,bist_pattern1,bist_pattern0};


assign wl_bist_pattern_sel  = {wl_bist_pattern_sel2,wl_bist_pattern_sel1,wl_bist_pattern_sel0} ;


assign  bank0_global_mc_bist_en = (RESCAN_CS == BANK0) ? global_mc_bist_en : 1'b0;
//assign  bank0_global_mc_rescan_start = (RESCAN_CS == IDLE && RESCAN_NS == BANK0);
assign  bank0_mc_bist_en = (RESCAN_CS == BANK0) ? mc_bist_en : 1'b0;

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank0_global_mc_rescan_start <= 1'b0;
    else if(RESCAN_CS == IDLE && RESCAN_NS == BANK0)
        bank0_global_mc_rescan_start <= 1'b1;
    else
        bank0_global_mc_rescan_start <= 1'b0;
end

bist_rescan_aux #(
    .RESCAN_ROUND_NUM   (RESCAN_ROUND_NUM   )
)bist_rescan_aux_u0(
  .clk                                 (clk     ),
  .rst_n                               (rst_n   ),

  .global_mc_bist_en                   (bank0_global_mc_bist_en                     ),
  .global_mc_rescan_start              (bank0_global_mc_rescan_start                ),//default 0
  .mc_bist_en                          (bank0_mc_bist_en                            ),
  //.bist_wl_scan_num                    (bist_wl_scan_num                            ),//pattern num
  .bist_rescan_num                     (bist_rescan_num                             ),//default 3
  .bist_rescan_fail_num                (bist_rescan_fail_num[19:0]                  ),
  .rescan_round_result                 (rescan_round_result[RESCAN_ROUND_NUM-1:0]   ),
  .bist_rescan_sel                     (bist_rescan_sel                             ),//1:7360-64,0:7360,default 1
  .wl_bist_pattern_sel                 (wl_bist_pattern_sel                         ),
  .bist_pattern_all                    (bist_pattern_all                            ),

  //.bist_pattern0                       (bist_pattern0                               ),
  //.bist_pattern1                       (bist_pattern1                               ),
  //.bist_pattern2                       (bist_pattern2                               ),
  //.bist_pattern3                       (bist_pattern3                               ),
  //.bist_pattern4                       (bist_pattern4                               ),
  //.bist_pattern5                       (bist_pattern5                               ),
  //.bist_pattern6                       (bist_pattern6                               ),
  //.bist_pattern7                       (bist_pattern7                               ),
  //.bist_pattern8                       (bist_pattern8                               ),
  //.bist_pattern9                       (bist_pattern9                               ),
  //.bist_pattern10                      (bist_pattern10                              ),
  //.bist_pattern11                      (bist_pattern11                              ),
  //.bist_pattern12                      (bist_pattern12                              ),
  //.bist_pattern13                      (bist_pattern13                              ),
  //.bist_pattern14                      (bist_pattern14                              ),
  //.bist_pattern15                      (bist_pattern15                              ),
  //.bist_pattern16                      (bist_pattern16                              ),
  //.bist_pattern17                      (bist_pattern17                              ),
  //.bist_pattern18                      (bist_pattern18                              ),
  //.bist_pattern19                      (bist_pattern19                              ),
  //.bist_pattern20                      (bist_pattern20                              ),
  //.bist_pattern21                      (bist_pattern21                              ),
  //.bist_pattern22                      (bist_pattern22                              ),
  //.bist_pattern23                      (bist_pattern23                              ),
  //.bist_pattern24                      (bist_pattern24                              ),
  //.bist_pattern25                      (bist_pattern25                              ),
  //.bist_pattern26                      (bist_pattern26                              ),
  //.bist_pattern27                      (bist_pattern27                              ),
  //.bist_pattern28                      (bist_pattern28                              ),
  //.bist_pattern29                      (bist_pattern29                              ),
  //.bist_pattern30                      (bist_pattern30                              ),
  //.bist_pattern31                      (bist_pattern31                              ),
  //.bist_pattern32                      (bist_pattern32                              ),
  //.bist_pattern33                      (bist_pattern33                              ),
  //.bist_pattern34                      (bist_pattern34                              ),
  //.bist_pattern35                      (bist_pattern35                              ),
  //.bist_pattern36                      (bist_pattern36                              ),
  //.bist_pattern37                      (bist_pattern37                              ),
  //.bist_pattern38                      (bist_pattern38                              ),
  //.bist_pattern39                      (bist_pattern39                              ),
  //.bist_pattern40                      (bist_pattern40                              ),
  //.bist_pattern41                      (bist_pattern41                              ),
  //.bist_pattern42                      (bist_pattern42                              ),
  //.bist_pattern43                      (bist_pattern43                              ),
  //.bist_pattern44                      (bist_pattern44                              ),
  //.bist_pattern45                      (bist_pattern45                              ),
  //.bist_pattern46                      (bist_pattern46                              ),
  //.bist_pattern47                      (bist_pattern47                              ),
  //.bist_pattern48                      (bist_pattern48                              ),
  //.bist_pattern49                      (bist_pattern49                              ),
  //.bist_pattern50                      (bist_pattern50                              ),
  //.bist_pattern51                      (bist_pattern51                              ),
  //.bist_pattern52                      (bist_pattern52                              ),
  //.bist_pattern53                      (bist_pattern53                              ),
  //.bist_pattern54                      (bist_pattern54                              ),
  //.bist_pattern55                      (bist_pattern55                              ),
  //.bist_pattern56                      (bist_pattern56                              ),
  //.bist_pattern57                      (bist_pattern57                              ),
  //.bist_pattern58                      (bist_pattern58                              ),
  //.bist_pattern59                      (bist_pattern59                              ),
  //.bist_pattern60                      (bist_pattern60                              ),
  //.bist_pattern61                      (bist_pattern61                              ),
  //.bist_pattern62                      (bist_pattern62                              ),
  //.bist_pattern63                      (bist_pattern63                              ),  
																			              
  .bist_rescan_success                 (bank0_bist_rescan_success                   ),
  .bist_rescan_finish                  (bank0_bist_rescan_finish                    ),
  .bist_rescan_finish_status           (bank0_bist_rescan_finish_status             ),
  .rescan_finish_clr                   (rescan_finish_clr                           ),
  .rescan_finish_mask                  (rescan_finish_mask                          ),
  .rescan_frame_vld                    (bank0_rescan_frame_vld                      ),
  .rescan_frame_rdy                    (rescan_frame_rdy                            ),
  .rescan_frame_data                   (bank0_rescan_frame_data                     ),//rw_flag,sof,eof,data,row,col
  .rescan_rvalid                       (bank0_rescan_rvalid                         ),
  .rescan_rdata                        (rescan_rdata                                )
);

assign  bank1_global_mc_bist_en = (RESCAN_CS == BANK1) ? global_mc_bist_en : 1'b0;
//assign  bank1_global_mc_rescan_start = (RESCAN_CS == BANK0 && RESCAN_NS == BANK1);
assign  bank1_mc_bist_en = (RESCAN_CS == BANK1) ? mc_bist_en : 1'b0;

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank1_global_mc_rescan_start <= 1'b0;
    else if((RESCAN_CS == BANK0 || RESCAN_CS == IDLE) && RESCAN_NS == BANK1)
        bank1_global_mc_rescan_start <= 1'b1;
    else
        bank1_global_mc_rescan_start <= 1'b0;
end
bist_rescan_aux #(
    .RESCAN_ROUND_NUM   (RESCAN_ROUND_NUM   )
)bist_rescan_aux_u1(
  .clk                                 (clk     ),
  .rst_n                               (rst_n   ),

  .global_mc_bist_en                   (bank1_global_mc_bist_en                     ),
  .global_mc_rescan_start              (bank1_global_mc_rescan_start                ),//default 0
  .mc_bist_en                          (bank1_mc_bist_en                            ),
  //.bist_wl_scan_num                    (bist_wl_scan_num                            ),//pattern num
  .bist_rescan_num                     (bist_rescan_num                             ),//default 3
  .bist_rescan_fail_num                (bist_rescan_fail_num[39:20]                 ),
  .rescan_round_result                 (rescan_round_result[MC_CTRL_BANK_NUM*RESCAN_ROUND_NUM-1:RESCAN_ROUND_NUM]),
  .bist_rescan_sel                     (bist_rescan_sel                             ),//1:7360-64,0:7360,default 1
  .wl_bist_pattern_sel                 (wl_bist_pattern_sel                         ),
  .bist_pattern_all                    (bist_pattern_all                            ),
  //.bist_pattern0                       (bist_pattern0                               ),
  //.bist_pattern1                       (bist_pattern1                               ),
  //.bist_pattern2                       (bist_pattern2                               ),
  //.bist_pattern3                       (bist_pattern3                               ),
  //.bist_pattern4                       (bist_pattern4                               ),
  //.bist_pattern5                       (bist_pattern5                               ),
  //.bist_pattern6                       (bist_pattern6                               ),
  //.bist_pattern7                       (bist_pattern7                               ),
  //.bist_pattern8                       (bist_pattern8                               ),
  //.bist_pattern9                       (bist_pattern9                               ),
  //.bist_pattern10                      (bist_pattern10                              ),
  //.bist_pattern11                      (bist_pattern11                              ),
  //.bist_pattern12                      (bist_pattern12                              ),
  //.bist_pattern13                      (bist_pattern13                              ),
  //.bist_pattern14                      (bist_pattern14                              ),
  //.bist_pattern15                      (bist_pattern15                              ),
  //.bist_pattern16                      (bist_pattern16                              ),
  //.bist_pattern17                      (bist_pattern17                              ),
  //.bist_pattern18                      (bist_pattern18                              ),
  //.bist_pattern19                      (bist_pattern19                              ),
  //.bist_pattern20                      (bist_pattern20                              ),
  //.bist_pattern21                      (bist_pattern21                              ),
  //.bist_pattern22                      (bist_pattern22                              ),
  //.bist_pattern23                      (bist_pattern23                              ),
  //.bist_pattern24                      (bist_pattern24                              ),
  //.bist_pattern25                      (bist_pattern25                              ),
  //.bist_pattern26                      (bist_pattern26                              ),
  //.bist_pattern27                      (bist_pattern27                              ),
  //.bist_pattern28                      (bist_pattern28                              ),
  //.bist_pattern29                      (bist_pattern29                              ),
  //.bist_pattern30                      (bist_pattern30                              ),
  //.bist_pattern31                      (bist_pattern31                              ),
  //.bist_pattern32                      (bist_pattern32                              ),
  //.bist_pattern33                      (bist_pattern33                              ),
  //.bist_pattern34                      (bist_pattern34                              ),
  //.bist_pattern35                      (bist_pattern35                              ),
  //.bist_pattern36                      (bist_pattern36                              ),
  //.bist_pattern37                      (bist_pattern37                              ),
  //.bist_pattern38                      (bist_pattern38                              ),
  //.bist_pattern39                      (bist_pattern39                              ),
  //.bist_pattern40                      (bist_pattern40                              ),
  //.bist_pattern41                      (bist_pattern41                              ),
  //.bist_pattern42                      (bist_pattern42                              ),
  //.bist_pattern43                      (bist_pattern43                              ),
  //.bist_pattern44                      (bist_pattern44                              ),
  //.bist_pattern45                      (bist_pattern45                              ),
  //.bist_pattern46                      (bist_pattern46                              ),
  //.bist_pattern47                      (bist_pattern47                              ),
  //.bist_pattern48                      (bist_pattern48                              ),
  //.bist_pattern49                      (bist_pattern49                              ),
  //.bist_pattern50                      (bist_pattern50                              ),
  //.bist_pattern51                      (bist_pattern51                              ),
  //.bist_pattern52                      (bist_pattern52                              ),
  //.bist_pattern53                      (bist_pattern53                              ),
  //.bist_pattern54                      (bist_pattern54                              ),
  //.bist_pattern55                      (bist_pattern55                              ),
  //.bist_pattern56                      (bist_pattern56                              ),
  //.bist_pattern57                      (bist_pattern57                              ),
  //.bist_pattern58                      (bist_pattern58                              ),
  //.bist_pattern59                      (bist_pattern59                              ),
  //.bist_pattern60                      (bist_pattern60                              ),
  //.bist_pattern61                      (bist_pattern61                              ),
  //.bist_pattern62                      (bist_pattern62                              ),
  //.bist_pattern63                      (bist_pattern63                              ),  
																			              
  .bist_rescan_success                 (bank1_bist_rescan_success                   ),
  .bist_rescan_finish                  (bank1_bist_rescan_finish                    ),
  .bist_rescan_finish_status           (bank1_bist_rescan_finish_status             ),
  .rescan_finish_clr                   (rescan_finish_clr                           ),
  .rescan_finish_mask                  (rescan_finish_mask                          ),
  .rescan_frame_vld                    (bank1_rescan_frame_vld                      ),
  .rescan_frame_rdy                    (rescan_frame_rdy                            ),
  .rescan_frame_data                   (bank1_rescan_frame_data                     ),//rw_flag,sof,eof,data,row,col
  .rescan_rvalid                       (bank1_rescan_rvalid                         ),
  .rescan_rdata                        (rescan_rdata                                )
);

always @(*)
begin
    case({bist_scan_end_bank,bist_scan_start_bank})
        2'b00: begin
            bist_rescan_success = bank0_bist_rescan_success;
            bist_rescan_finish  = bank0_bist_rescan_finish;
            bist_rescan_finish_status = bank0_bist_rescan_finish_status;
        end
        2'b10: begin
            bist_rescan_success = bank0_bist_rescan_success && bank1_bist_rescan_success;
            bist_rescan_finish  = bank0_bist_rescan_finish  && bank1_bist_rescan_finish;
            bist_rescan_finish_status = bank0_bist_rescan_finish_status && bank1_bist_rescan_finish_status;
        end
        2'b11: begin
            bist_rescan_success = bank1_bist_rescan_success;
            bist_rescan_finish  = bank1_bist_rescan_finish;
            bist_rescan_finish_status = bank1_bist_rescan_finish_status;
        end
        default: begin
            bist_rescan_success = 1'b0;
            bist_rescan_finish  = 1'b0;
            bist_rescan_finish_status = 1'b0;
        end
    endcase
end

always @(*)
begin
    rescan_frame_vld = 1'b0;
    bank0_rescan_rvalid = 1'b0;
    bank1_rescan_rvalid = 1'b0;
    rescan_frame_data = 'd0;
    if(RESCAN_CS == BANK0) begin
        rescan_frame_vld = bank0_rescan_frame_vld;
        rescan_frame_data = {bank0_rescan_frame_data[289:287],2'b01,bank0_rescan_frame_data[286:0]};
        bank0_rescan_rvalid = rescan_rvalid;
    end
    else if(RESCAN_CS == BANK1) begin
        rescan_frame_vld = bank1_rescan_frame_vld;
        rescan_frame_data = {bank1_rescan_frame_data[289:287],2'b10,bank1_rescan_frame_data[286:0]};
        bank1_rescan_rvalid = rescan_rvalid;
    end
    else begin
        rescan_frame_vld = 1'b0;
        bank0_rescan_rvalid = 1'b0;
        bank1_rescan_rvalid = 1'b0;
        rescan_frame_data = 'd0;
    end
end

assign  bank_scan_fsm_status = RESCAN_CS;
endmodule
