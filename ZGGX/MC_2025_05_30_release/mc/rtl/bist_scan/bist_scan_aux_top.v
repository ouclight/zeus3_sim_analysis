module bist_scan_aux_top #(
    parameter   MC_FRAME_WIDTH = 292
)(
    //-------------clock and reset signal--------------
    input                                               clk                                 ,
    input                                               rst_n                               ,
    input                                               global_bist_clr                     ,

    //-------------control signal----------------------
    input                                               global_mc_bist_start                ,
    input                                               global_mc_bist_en                   ,
    input                                               mc_bist_en                          ,
    input                                               bist_csl_vmc_en                     ,//default 1
    //input      [6:0]                                    bist_csl_scan_num                   ,
    //input      [6:0]                                    bist_wl_scan_num                    ,
    input                                               csl_scan_addr_range_sel             ,//default 1,scan all addr
    input                                               csl_scan_check_sel                  ,//default 1,check 266 bit rdata
    input      [3:0]                                    bist_wl_scan_single_pattern_rd_num  ,//max 16,default 0:read one time
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
    input      [31:0]                                   csl_bist_pattern_sel0               ,
    input      [31:0]                                   csl_bist_pattern_sel1               ,
    input      [3:0]                                    csl_bist_pattern_sel2               ,
    input      [31:0]                                   wl_bist_pattern_sel0                ,
    input      [31:0]                                   wl_bist_pattern_sel1                ,
    input      [3:0]                                    wl_bist_pattern_sel2                ,
    input                                               csl_scan_mode_sel                   ,

    output  reg                                         bist_success                        ,
    output  reg                                         bist_finish                         ,
    output  reg                                         bist_bank_finish                    ,//apb debug
    output  reg                                         bist_finish_int                     ,
    input                                               bist_finish_clr                     ,
    input                                               bist_finish_int_mask                ,
    input      [4:0]                                    csl_err_threshold                   ,
    input                                               mc_timeout_flag                     ,
    output  reg[2:0]                                    bist_scan_status                    , //wl_scan_working,csl_scan_working,bank_scan_working
    //-------------data signal------------------------
    output  reg                                         bank_scan_frame_vld                 ,
    input                                               bank_scan_frame_rdy                 ,
    output  reg[MC_FRAME_WIDTH-1 :0]                    bank_scan_frame_data                ,//rw_flag,sof,eof,data,row,col
    input                                               bank_scan_rvalid                    ,
    input      [266-1:0]                                bank_scan_rdata                     ,

    output  reg                                         csl_scan_frame_vld                  ,
    input                                               csl_scan_frame_rdy                  ,
    output  reg[MC_FRAME_WIDTH-1 :0]                    csl_scan_frame_data                 ,//rw_flag,sof,eof,data,row,col
    input                                               csl_scan_rvalid                     ,
    input      [266-1:0]                                csl_scan_rdata                      ,

    output  reg                                         wl_scan_frame_vld                   ,
    input                                               wl_scan_frame_rdy                   ,
    output  reg[MC_FRAME_WIDTH-1 :0]                    wl_scan_frame_data                  ,//rw_flag,sof,eof,data,row,col
    input                                               wl_scan_rvalid                      ,
    input      [266-1:0]                                wl_scan_rdata                       ,
    //-------------error wl record signal------------
    output     [7:0]                                    bank0_err_csl0_part0                ,
    output     [7:0]                                    bank0_err_csl1_part0                ,
    output     [7:0]                                    bank0_err_csl0_part1                ,
    output     [7:0]                                    bank0_err_csl1_part1                ,
    output     [7:0]                                    bank0_err_csl0_part2                ,
    output     [7:0]                                    bank0_err_csl1_part2                ,
    output     [7:0]                                    bank0_err_csl0_part3                ,
    output     [7:0]                                    bank0_err_csl1_part3                ,
    output     [7:0]                                    bank0_err_csl0_part4                ,
    output     [7:0]                                    bank0_err_csl1_part4                ,
    output     [7:0]                                    bank0_err_csl0_part5                ,
    output     [7:0]                                    bank0_err_csl1_part5                ,
    output     [7:0]                                    bank0_err_csl0_part6                ,
    output     [7:0]                                    bank0_err_csl1_part6                ,
    output     [7:0]                                    bank0_err_csl0_part7                ,
    output     [7:0]                                    bank0_err_csl1_part7                ,
    output     [7:0]                                    bank0_err_csl0_part8                ,
    output     [7:0]                                    bank0_err_csl1_part8                ,
    output     [7:0]                                    bank0_err_csl0_part9                ,
    output     [7:0]                                    bank0_err_csl1_part9                ,

    output     [12:0]                                   bank0_err_wl0                       ,
    output     [12:0]                                   bank0_err_wl1                       ,
    output     [12:0]                                   bank0_err_wl2                       ,
    output     [12:0]                                   bank0_err_wl3                       ,
    output     [12:0]                                   bank0_err_wl4                       ,
    output     [12:0]                                   bank0_err_wl5                       ,
    output     [12:0]                                   bank0_err_wl6                       ,
    output     [12:0]                                   bank0_err_wl7                       ,
    output     [12:0]                                   bank0_err_wl8                       ,
    output     [12:0]                                   bank0_err_wl9                       ,
    output     [12:0]                                   bank0_err_wl10                      ,
    output     [12:0]                                   bank0_err_wl11                      ,
    output     [12:0]                                   bank0_err_wl12                      ,
    output     [12:0]                                   bank0_err_wl13                      ,
    output     [12:0]                                   bank0_err_wl14                      ,
    output     [12:0]                                   bank0_err_wl15                      ,
    output     [12:0]                                   bank0_err_wl16                      ,
    output     [12:0]                                   bank0_err_wl17                      ,
    output     [12:0]                                   bank0_err_wl18                      ,
    output     [12:0]                                   bank0_err_wl19                      ,
    output     [12:0]                                   bank0_err_wl20                      ,
    output     [12:0]                                   bank0_err_wl21                      ,
    output     [12:0]                                   bank0_err_wl22                      ,
    output     [12:0]                                   bank0_err_wl23                      ,
    output     [12:0]                                   bank0_err_wl24                      ,
    output     [12:0]                                   bank0_err_wl25                      ,
    output     [12:0]                                   bank0_err_wl26                      ,
    output     [12:0]                                   bank0_err_wl27                      ,
    output     [12:0]                                   bank0_err_wl28                      ,
    output     [12:0]                                   bank0_err_wl29                      ,
    output     [12:0]                                   bank0_err_wl30                      ,
    output     [12:0]                                   bank0_err_wl31                      ,
    output     [12:0]                                   bank0_err_wl32                      ,
    output     [12:0]                                   bank0_err_wl33                      ,
    output     [12:0]                                   bank0_err_wl34                      ,
    output     [12:0]                                   bank0_err_wl35                      ,
    output     [12:0]                                   bank0_err_wl36                      ,
    output     [12:0]                                   bank0_err_wl37                      ,
    output     [12:0]                                   bank0_err_wl38                      ,
    output     [12:0]                                   bank0_err_wl39                      ,
    output     [12:0]                                   bank0_err_wl40                      ,
    output     [12:0]                                   bank0_err_wl41                      ,
    output     [12:0]                                   bank0_err_wl42                      ,
    output     [12:0]                                   bank0_err_wl43                      ,
    output     [12:0]                                   bank0_err_wl44                      ,
    output     [12:0]                                   bank0_err_wl45                      ,
    output     [12:0]                                   bank0_err_wl46                      ,
    output     [12:0]                                   bank0_err_wl47                      ,
    output     [12:0]                                   bank0_err_wl48                      ,
    output     [12:0]                                   bank0_err_wl49                      ,
    output     [12:0]                                   bank0_err_wl50                      ,
    output     [12:0]                                   bank0_err_wl51                      ,
    output     [12:0]                                   bank0_err_wl52                      ,
    output     [12:0]                                   bank0_err_wl53                      ,
    output     [12:0]                                   bank0_err_wl54                      ,
    output     [12:0]                                   bank0_err_wl55                      ,
    output     [12:0]                                   bank0_err_wl56                      ,
    output     [12:0]                                   bank0_err_wl57                      ,
    output     [12:0]                                   bank0_err_wl58                      ,
    output     [12:0]                                   bank0_err_wl59                      ,
    output     [12:0]                                   bank0_err_wl60                      ,
    output     [12:0]                                   bank0_err_wl61                      ,
    output     [12:0]                                   bank0_err_wl62                      ,
    output     [12:0]                                   bank0_err_wl63                      ,
    output     [6:0]                                    bank0_err_wl_cnt                    , 
    output                                              bank0_err_wl_cnt_change_flag        ,

    output     [7:0]                                    bank1_err_csl0_part0                ,
    output     [7:0]                                    bank1_err_csl1_part0                ,
    output     [7:0]                                    bank1_err_csl0_part1                ,
    output     [7:0]                                    bank1_err_csl1_part1                ,
    output     [7:0]                                    bank1_err_csl0_part2                ,
    output     [7:0]                                    bank1_err_csl1_part2                ,
    output     [7:0]                                    bank1_err_csl0_part3                ,
    output     [7:0]                                    bank1_err_csl1_part3                ,
    output     [7:0]                                    bank1_err_csl0_part4                ,
    output     [7:0]                                    bank1_err_csl1_part4                ,
    output     [7:0]                                    bank1_err_csl0_part5                ,
    output     [7:0]                                    bank1_err_csl1_part5                ,
    output     [7:0]                                    bank1_err_csl0_part6                ,
    output     [7:0]                                    bank1_err_csl1_part6                ,
    output     [7:0]                                    bank1_err_csl0_part7                ,
    output     [7:0]                                    bank1_err_csl1_part7                ,
    output     [7:0]                                    bank1_err_csl0_part8                ,
    output     [7:0]                                    bank1_err_csl1_part8                ,
    output     [7:0]                                    bank1_err_csl0_part9                ,
    output     [7:0]                                    bank1_err_csl1_part9                ,

    output     [12:0]                                   bank1_err_wl0                       ,
    output     [12:0]                                   bank1_err_wl1                       ,
    output     [12:0]                                   bank1_err_wl2                       ,
    output     [12:0]                                   bank1_err_wl3                       ,
    output     [12:0]                                   bank1_err_wl4                       ,
    output     [12:0]                                   bank1_err_wl5                       ,
    output     [12:0]                                   bank1_err_wl6                       ,
    output     [12:0]                                   bank1_err_wl7                       ,
    output     [12:0]                                   bank1_err_wl8                       ,
    output     [12:0]                                   bank1_err_wl9                       ,
    output     [12:0]                                   bank1_err_wl10                      ,
    output     [12:0]                                   bank1_err_wl11                      ,
    output     [12:0]                                   bank1_err_wl12                      ,
    output     [12:0]                                   bank1_err_wl13                      ,
    output     [12:0]                                   bank1_err_wl14                      ,
    output     [12:0]                                   bank1_err_wl15                      ,
    output     [12:0]                                   bank1_err_wl16                      ,
    output     [12:0]                                   bank1_err_wl17                      ,
    output     [12:0]                                   bank1_err_wl18                      ,
    output     [12:0]                                   bank1_err_wl19                      ,
    output     [12:0]                                   bank1_err_wl20                      ,
    output     [12:0]                                   bank1_err_wl21                      ,
    output     [12:0]                                   bank1_err_wl22                      ,
    output     [12:0]                                   bank1_err_wl23                      ,
    output     [12:0]                                   bank1_err_wl24                      ,
    output     [12:0]                                   bank1_err_wl25                      ,
    output     [12:0]                                   bank1_err_wl26                      ,
    output     [12:0]                                   bank1_err_wl27                      ,
    output     [12:0]                                   bank1_err_wl28                      ,
    output     [12:0]                                   bank1_err_wl29                      ,
    output     [12:0]                                   bank1_err_wl30                      ,
    output     [12:0]                                   bank1_err_wl31                      ,
    output     [12:0]                                   bank1_err_wl32                      ,
    output     [12:0]                                   bank1_err_wl33                      ,
    output     [12:0]                                   bank1_err_wl34                      ,
    output     [12:0]                                   bank1_err_wl35                      ,
    output     [12:0]                                   bank1_err_wl36                      ,
    output     [12:0]                                   bank1_err_wl37                      ,
    output     [12:0]                                   bank1_err_wl38                      ,
    output     [12:0]                                   bank1_err_wl39                      ,
    output     [12:0]                                   bank1_err_wl40                      ,
    output     [12:0]                                   bank1_err_wl41                      ,
    output     [12:0]                                   bank1_err_wl42                      ,
    output     [12:0]                                   bank1_err_wl43                      ,
    output     [12:0]                                   bank1_err_wl44                      ,
    output     [12:0]                                   bank1_err_wl45                      ,
    output     [12:0]                                   bank1_err_wl46                      ,
    output     [12:0]                                   bank1_err_wl47                      ,
    output     [12:0]                                   bank1_err_wl48                      ,
    output     [12:0]                                   bank1_err_wl49                      ,
    output     [12:0]                                   bank1_err_wl50                      ,
    output     [12:0]                                   bank1_err_wl51                      ,
    output     [12:0]                                   bank1_err_wl52                      ,
    output     [12:0]                                   bank1_err_wl53                      ,
    output     [12:0]                                   bank1_err_wl54                      ,
    output     [12:0]                                   bank1_err_wl55                      ,
    output     [12:0]                                   bank1_err_wl56                      ,
    output     [12:0]                                   bank1_err_wl57                      ,
    output     [12:0]                                   bank1_err_wl58                      ,
    output     [12:0]                                   bank1_err_wl59                      ,
    output     [12:0]                                   bank1_err_wl60                      ,
    output     [12:0]                                   bank1_err_wl61                      ,
    output     [12:0]                                   bank1_err_wl62                      ,
    output     [12:0]                                   bank1_err_wl63                      ,
    output     [6:0]                                    bank1_err_wl_cnt                    , 
    output                                              bank1_err_wl_cnt_change_flag        ,
    input                                               bist_scan_start_bank                ,
    input                                               bist_scan_end_bank                  ,
    output     [1:0]                                    bist_scan_fsm_status                
);


localparam  IDLE = 2'b00,
            BANK0 = 2'b01,
            BANK1 = 2'b10;

wire                    bank0_scan_frame_vld;
wire    [266+21+3-1:0]  bank0_scan_frame_data;
wire                    bank0_csl_scan_frame_vld;
wire    [266+21+3-1:0]  bank0_csl_scan_frame_data;
wire                    bank0_wl_scan_frame_vld;
wire    [266+21+3-1:0]  bank0_wl_scan_frame_data;

wire                    bank0_bist_success;
wire                    bank0_bist_finish;
wire                    bank0_bist_bank_finish;
wire                    bank0_bist_finish_int;
wire    [2:0]           bank0_bist_scan_status;

reg                     bank0_scan_rvalid;
reg                     bank0_csl_scan_rvalid;
reg                    bank0_wl_scan_rvalid;

reg                     bank0_global_mc_bist_start;


wire                    bank1_scan_frame_vld;
wire    [266+21+3-1:0]  bank1_scan_frame_data;
wire                    bank1_csl_scan_frame_vld;
wire    [266+21+3-1:0]  bank1_csl_scan_frame_data;
wire                    bank1_wl_scan_frame_vld;
wire    [266+21+3-1:0]  bank1_wl_scan_frame_data;

wire                    bank1_bist_success;
wire                    bank1_bist_finish;
wire                    bank1_bist_bank_finish;
wire                    bank1_bist_finish_int;
wire    [2:0]           bank1_bist_scan_status;

reg                     bank1_scan_rvalid;
reg                     bank1_csl_scan_rvalid;
reg                     bank1_wl_scan_rvalid;
reg                     bank1_global_mc_bist_start;

wire    [67:0]          csl_bist_pattern_sel;
wire    [67:0]          wl_bist_pattern_sel;
//========================Logic=========================================
reg     [1:0]   SCAN_CS;
reg     [1:0]   SCAN_NS;

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        SCAN_CS <= IDLE;
    else
        SCAN_CS <= SCAN_NS;
end

always @(*)
begin
    case(SCAN_CS)
        IDLE: begin
            if(global_mc_bist_start && global_mc_bist_en && mc_bist_en) begin
                if(bist_scan_start_bank == 1'b0)
                    SCAN_NS = BANK0;
                else
                    SCAN_NS = BANK1;
            end
            else
                SCAN_NS = IDLE;
        end
        BANK0: begin
            if(bank0_bist_finish) begin
                if(bist_scan_end_bank == 1'b0)
                    SCAN_NS = IDLE;
                else
                    SCAN_NS = BANK1;
            end
            else
                SCAN_NS = BANK0;
        end
        BANK1: begin
            if(bank1_bist_finish)
                SCAN_NS = IDLE;
            else
                SCAN_NS = BANK1;
        end
        default: SCAN_NS = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank0_global_mc_bist_start <= 1'b0;
    else if(SCAN_CS == IDLE && SCAN_NS == BANK0)
        bank0_global_mc_bist_start <= 1'b1;
    else
        bank0_global_mc_bist_start <= 1'b0;
end

//========================pattern select================================
//assign bist_pattern_all =  {bist_pattern_reg3,bist_pattern_reg2,bist_pattern_reg1,bist_pattern_reg0,
//                            bist_pattern63,bist_pattern62,bist_pattern61,bist_pattern60,bist_pattern59,bist_pattern58,bist_pattern57,bist_pattern56,
//                            bist_pattern55,bist_pattern54,bist_pattern53,bist_pattern52,bist_pattern51,bist_pattern50,bist_pattern49,bist_pattern48,
//                            bist_pattern47,bist_pattern46,bist_pattern45,bist_pattern44,bist_pattern43,bist_pattern42,bist_pattern41,bist_pattern40,
//                            bist_pattern39,bist_pattern38,bist_pattern37,bist_pattern36,bist_pattern35,bist_pattern34,bist_pattern33,bist_pattern32,
//                            bist_pattern31,bist_pattern30,bist_pattern29,bist_pattern28,bist_pattern27,bist_pattern26,bist_pattern25,bist_pattern24,
//                            bist_pattern23,bist_pattern22,bist_pattern21,bist_pattern20,bist_pattern19,bist_pattern18,bist_pattern17,bist_pattern16,
//                            bist_pattern15,bist_pattern14,bist_pattern13,bist_pattern12,bist_pattern11,bist_pattern10,bist_pattern9,bist_pattern8,
//                            bist_pattern7,bist_pattern6,bist_pattern5,bist_pattern4,bist_pattern3,bist_pattern2,bist_pattern1,bist_pattern0};


assign csl_bist_pattern_sel = {csl_bist_pattern_sel2,csl_bist_pattern_sel1,csl_bist_pattern_sel0} ;
assign wl_bist_pattern_sel  = {wl_bist_pattern_sel2,wl_bist_pattern_sel1,wl_bist_pattern_sel0} ;


bist_scan_aux bank0_bist_scan_aux_u0(
    .clk                                 (clk                                   ),
    .rst_n                               (rst_n                                 ),
    .global_bist_clr                     (global_bist_clr                       ),
    .global_mc_bist_start                (bank0_global_mc_bist_start            ),
    .global_mc_bist_en                   (global_mc_bist_en                     ),
    .mc_bist_en                          (mc_bist_en                            ),
    .bist_csl_vmc_en                     (bist_csl_vmc_en                       ),//default 1
    //.bist_csl_scan_num                   (bist_csl_scan_num                     ),
    //.bist_wl_scan_num                    (bist_wl_scan_num                      ),
    .csl_scan_addr_range_sel             (csl_scan_addr_range_sel               ),//default 1,scan all addr
    .csl_scan_check_sel                  (csl_scan_check_sel                    ),//default 1,check 266 bit rdata
    .bist_wl_scan_single_pattern_rd_num  (bist_wl_scan_single_pattern_rd_num    ),//max 16,default 0:read one time
    .csl_bist_pattern_sel                (csl_bist_pattern_sel                  ),//every bit correspond to every pattern,1:valid
    .wl_bist_pattern_sel                 (wl_bist_pattern_sel                   ),
    .csl_scan_mode_sel                   (csl_scan_mode_sel                     ),//0:abort 1:continue,default 0
    .bist_pattern_all                    (bist_pattern_all                      ),

    .bist_success                        (bank0_bist_success                    ),
    .bist_finish                         (bank0_bist_finish                     ),
    .bist_bank_finish                    (bank0_bist_bank_finish                ),//apb debug
    .bist_finish_int                     (bank0_bist_finish_int                 ),
    .bist_finish_clr                     (bist_finish_clr                       ),
    .bist_finish_int_mask                (bist_finish_int_mask                  ),
    .csl_err_threshold                   (csl_err_threshold                     ),
    .mc_timeout_flag                     (mc_timeout_flag                       ),
    .bist_scan_status                    (bank0_bist_scan_status                ), //wl_scan_working,csl_scan_working,bank_scan_working
  //-------------data signal------------------------
    .bank_scan_frame_vld                 (bank0_scan_frame_vld                  ),
    .bank_scan_frame_rdy                 (bank_scan_frame_rdy                   ),
    .bank_scan_frame_data                (bank0_scan_frame_data                 ),//rw_flag,sof,eof,data,row,col
    .bank_scan_rvalid                    (bank0_scan_rvalid                     ),
    .bank_scan_rdata                     (bank_scan_rdata                       ),

    .csl_scan_frame_vld                  (bank0_csl_scan_frame_vld              ),
    .csl_scan_frame_rdy                  (csl_scan_frame_rdy                    ),
    .csl_scan_frame_data                 (bank0_csl_scan_frame_data             ),//rw_flag,sof,eof,data,row,col
    .csl_scan_rvalid                     (bank0_csl_scan_rvalid                 ),
    .csl_scan_rdata                      (csl_scan_rdata                        ),

    .wl_scan_frame_vld                   (bank0_wl_scan_frame_vld               ),
    .wl_scan_frame_rdy                   (wl_scan_frame_rdy                     ),
    .wl_scan_frame_data                  (bank0_wl_scan_frame_data              ),//rw_flag,sof,eof,data,row,col
    .wl_scan_rvalid                      (bank0_wl_scan_rvalid                  ),
    .wl_scan_rdata                       (wl_scan_rdata                         ),
  //-------------error wl record signal------------
    .err_csl0_part0                      (bank0_err_csl0_part0                  ),
    .err_csl1_part0                      (bank0_err_csl1_part0                  ),
    .err_csl0_part1                      (bank0_err_csl0_part1                  ),
    .err_csl1_part1                      (bank0_err_csl1_part1                  ),
    .err_csl0_part2                      (bank0_err_csl0_part2                  ),
    .err_csl1_part2                      (bank0_err_csl1_part2                  ),
    .err_csl0_part3                      (bank0_err_csl0_part3                  ),
    .err_csl1_part3                      (bank0_err_csl1_part3                  ),
    .err_csl0_part4                      (bank0_err_csl0_part4                  ),
    .err_csl1_part4                      (bank0_err_csl1_part4                  ),
    .err_csl0_part5                      (bank0_err_csl0_part5                  ),
    .err_csl1_part5                      (bank0_err_csl1_part5                  ),
    .err_csl0_part6                      (bank0_err_csl0_part6                  ),
    .err_csl1_part6                      (bank0_err_csl1_part6                  ),
    .err_csl0_part7                      (bank0_err_csl0_part7                  ),
    .err_csl1_part7                      (bank0_err_csl1_part7                  ),
    .err_csl0_part8                      (bank0_err_csl0_part8                  ),
    .err_csl1_part8                      (bank0_err_csl1_part8                  ),
    .err_csl0_part9                      (bank0_err_csl0_part9                  ),
    .err_csl1_part9                      (bank0_err_csl1_part9                  ),

    .err_wl0                             (bank0_err_wl0                         ),
    .err_wl1                             (bank0_err_wl1                         ),
    .err_wl2                             (bank0_err_wl2                         ),
    .err_wl3                             (bank0_err_wl3                         ),
    .err_wl4                             (bank0_err_wl4                         ),
    .err_wl5                             (bank0_err_wl5                         ),
    .err_wl6                             (bank0_err_wl6                         ),
    .err_wl7                             (bank0_err_wl7                         ),
    .err_wl8                             (bank0_err_wl8                         ),
    .err_wl9                             (bank0_err_wl9                         ),
    .err_wl10                            (bank0_err_wl10                        ),
    .err_wl11                            (bank0_err_wl11                        ),
    .err_wl12                            (bank0_err_wl12                        ),
    .err_wl13                            (bank0_err_wl13                        ),
    .err_wl14                            (bank0_err_wl14                        ),
    .err_wl15                            (bank0_err_wl15                        ),
    .err_wl16                            (bank0_err_wl16                        ),
    .err_wl17                            (bank0_err_wl17                        ),
    .err_wl18                            (bank0_err_wl18                        ),
    .err_wl19                            (bank0_err_wl19                        ),
    .err_wl20                            (bank0_err_wl20                        ),
    .err_wl21                            (bank0_err_wl21                        ),
    .err_wl22                            (bank0_err_wl22                        ),
    .err_wl23                            (bank0_err_wl23                        ),
    .err_wl24                            (bank0_err_wl24                        ),
    .err_wl25                            (bank0_err_wl25                        ),
    .err_wl26                            (bank0_err_wl26                        ),
    .err_wl27                            (bank0_err_wl27                        ),
    .err_wl28                            (bank0_err_wl28                        ),
    .err_wl29                            (bank0_err_wl29                        ),
    .err_wl30                            (bank0_err_wl30                        ),
    .err_wl31                            (bank0_err_wl31                        ),
    .err_wl32                            (bank0_err_wl32                        ),
    .err_wl33                            (bank0_err_wl33                        ),
    .err_wl34                            (bank0_err_wl34                        ),
    .err_wl35                            (bank0_err_wl35                        ),
    .err_wl36                            (bank0_err_wl36                        ),
    .err_wl37                            (bank0_err_wl37                        ),
    .err_wl38                            (bank0_err_wl38                        ),
    .err_wl39                            (bank0_err_wl39                        ),
    .err_wl40                            (bank0_err_wl40                        ),
    .err_wl41                            (bank0_err_wl41                        ),
    .err_wl42                            (bank0_err_wl42                        ),
    .err_wl43                            (bank0_err_wl43                        ),
    .err_wl44                            (bank0_err_wl44                        ),
    .err_wl45                            (bank0_err_wl45                        ),
    .err_wl46                            (bank0_err_wl46                        ),
    .err_wl47                            (bank0_err_wl47                        ),
    .err_wl48                            (bank0_err_wl48                        ),
    .err_wl49                            (bank0_err_wl49                        ),
    .err_wl50                            (bank0_err_wl50                        ),
    .err_wl51                            (bank0_err_wl51                        ),
    .err_wl52                            (bank0_err_wl52                        ),
    .err_wl53                            (bank0_err_wl53                        ),
    .err_wl54                            (bank0_err_wl54                        ),
    .err_wl55                            (bank0_err_wl55                        ),
    .err_wl56                            (bank0_err_wl56                        ),
    .err_wl57                            (bank0_err_wl57                        ),
    .err_wl58                            (bank0_err_wl58                        ),
    .err_wl59                            (bank0_err_wl59                        ),
    .err_wl60                            (bank0_err_wl60                        ),
    .err_wl61                            (bank0_err_wl61                        ),
    .err_wl62                            (bank0_err_wl62                        ),
    .err_wl63                            (bank0_err_wl63                        ),
    .err_wl_cnt                          (bank0_err_wl_cnt                      ), 
    .err_wl_cnt_change_flag              (bank0_err_wl_cnt_change_flag          )
);

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank1_global_mc_bist_start <= 1'b0;
    else if((SCAN_CS == IDLE || SCAN_CS == BANK0) && SCAN_NS == BANK1)
        bank1_global_mc_bist_start <= 1'b1;
    else
        bank1_global_mc_bist_start <= 1'b0;
end

bist_scan_aux bank1_bist_scan_aux_u0(
    .clk                                 (clk                                   ),
    .rst_n                               (rst_n                                 ),
    .global_bist_clr                     (global_bist_clr                       ),
    .global_mc_bist_start                (bank1_global_mc_bist_start            ),
    .global_mc_bist_en                   (global_mc_bist_en                     ),
    .mc_bist_en                          (mc_bist_en                            ),
    .bist_csl_vmc_en                     (bist_csl_vmc_en                       ),//default 1
    //.bist_csl_scan_num                   (bist_csl_scan_num                     ),
    //.bist_wl_scan_num                    (bist_wl_scan_num                      ),
    .csl_scan_addr_range_sel             (csl_scan_addr_range_sel               ),//default 1,scan all addr
    .csl_scan_check_sel                  (csl_scan_check_sel                    ),//default 1,check 266 bit rdata
    .bist_wl_scan_single_pattern_rd_num  (bist_wl_scan_single_pattern_rd_num    ),//max 16,default 0:read one time
    .csl_bist_pattern_sel                (csl_bist_pattern_sel                  ),//every bit correspond to every pattern,1:valid
    .wl_bist_pattern_sel                 (wl_bist_pattern_sel                   ),
    .csl_scan_mode_sel                   (csl_scan_mode_sel                     ),//0:abort 1:continue,default 0
    .bist_pattern_all                    (bist_pattern_all                      ),

    .bist_success                        (bank1_bist_success                    ),
    .bist_finish                         (bank1_bist_finish                     ),
    .bist_bank_finish                    (bank1_bist_bank_finish                ),//apb debug
    .bist_finish_int                     (bank1_bist_finish_int                 ),
    .bist_finish_clr                     (bist_finish_clr                       ),
    .bist_finish_int_mask                (bist_finish_int_mask                  ),
    .csl_err_threshold                   (csl_err_threshold                     ),
    .mc_timeout_flag                     (mc_timeout_flag                       ),
    .bist_scan_status                    (bank1_bist_scan_status                ), //wl_scan_working,csl_scan_working,bank_scan_working
  //-------------data signal------------------------
    .bank_scan_frame_vld                 (bank1_scan_frame_vld                  ),
    .bank_scan_frame_rdy                 (bank_scan_frame_rdy                   ),
    .bank_scan_frame_data                (bank1_scan_frame_data                 ),//rw_flag,sof,eof,data,row,col
    .bank_scan_rvalid                    (bank1_scan_rvalid                     ),
    .bank_scan_rdata                     (bank_scan_rdata                       ),

    .csl_scan_frame_vld                  (bank1_csl_scan_frame_vld              ),
    .csl_scan_frame_rdy                  (csl_scan_frame_rdy                    ),
    .csl_scan_frame_data                 (bank1_csl_scan_frame_data             ),//rw_flag,sof,eof,data,row,col
    .csl_scan_rvalid                     (bank1_csl_scan_rvalid                 ),
    .csl_scan_rdata                      (csl_scan_rdata                        ),

    .wl_scan_frame_vld                   (bank1_wl_scan_frame_vld               ),
    .wl_scan_frame_rdy                   (wl_scan_frame_rdy                     ),
    .wl_scan_frame_data                  (bank1_wl_scan_frame_data              ),//rw_flag,sof,eof,data,row,col
    .wl_scan_rvalid                      (bank1_wl_scan_rvalid                  ),
    .wl_scan_rdata                       (wl_scan_rdata                         ),
  //-------------error wl record signal------------
    .err_csl0_part0                      (bank1_err_csl0_part0                  ),
    .err_csl1_part0                      (bank1_err_csl1_part0                  ),
    .err_csl0_part1                      (bank1_err_csl0_part1                  ),
    .err_csl1_part1                      (bank1_err_csl1_part1                  ),
    .err_csl0_part2                      (bank1_err_csl0_part2                  ),
    .err_csl1_part2                      (bank1_err_csl1_part2                  ),
    .err_csl0_part3                      (bank1_err_csl0_part3                  ),
    .err_csl1_part3                      (bank1_err_csl1_part3                  ),
    .err_csl0_part4                      (bank1_err_csl0_part4                  ),
    .err_csl1_part4                      (bank1_err_csl1_part4                  ),
    .err_csl0_part5                      (bank1_err_csl0_part5                  ),
    .err_csl1_part5                      (bank1_err_csl1_part5                  ),
    .err_csl0_part6                      (bank1_err_csl0_part6                  ),
    .err_csl1_part6                      (bank1_err_csl1_part6                  ),
    .err_csl0_part7                      (bank1_err_csl0_part7                  ),
    .err_csl1_part7                      (bank1_err_csl1_part7                  ),
    .err_csl0_part8                      (bank1_err_csl0_part8                  ),
    .err_csl1_part8                      (bank1_err_csl1_part8                  ),
    .err_csl0_part9                      (bank1_err_csl0_part9                  ),
    .err_csl1_part9                      (bank1_err_csl1_part9                  ),

    .err_wl0                             (bank1_err_wl0                         ),
    .err_wl1                             (bank1_err_wl1                         ),
    .err_wl2                             (bank1_err_wl2                         ),
    .err_wl3                             (bank1_err_wl3                         ),
    .err_wl4                             (bank1_err_wl4                         ),
    .err_wl5                             (bank1_err_wl5                         ),
    .err_wl6                             (bank1_err_wl6                         ),
    .err_wl7                             (bank1_err_wl7                         ),
    .err_wl8                             (bank1_err_wl8                         ),
    .err_wl9                             (bank1_err_wl9                         ),
    .err_wl10                            (bank1_err_wl10                        ),
    .err_wl11                            (bank1_err_wl11                        ),
    .err_wl12                            (bank1_err_wl12                        ),
    .err_wl13                            (bank1_err_wl13                        ),
    .err_wl14                            (bank1_err_wl14                        ),
    .err_wl15                            (bank1_err_wl15                        ),
    .err_wl16                            (bank1_err_wl16                        ),
    .err_wl17                            (bank1_err_wl17                        ),
    .err_wl18                            (bank1_err_wl18                        ),
    .err_wl19                            (bank1_err_wl19                        ),
    .err_wl20                            (bank1_err_wl20                        ),
    .err_wl21                            (bank1_err_wl21                        ),
    .err_wl22                            (bank1_err_wl22                        ),
    .err_wl23                            (bank1_err_wl23                        ),
    .err_wl24                            (bank1_err_wl24                        ),
    .err_wl25                            (bank1_err_wl25                        ),
    .err_wl26                            (bank1_err_wl26                        ),
    .err_wl27                            (bank1_err_wl27                        ),
    .err_wl28                            (bank1_err_wl28                        ),
    .err_wl29                            (bank1_err_wl29                        ),
    .err_wl30                            (bank1_err_wl30                        ),
    .err_wl31                            (bank1_err_wl31                        ),
    .err_wl32                            (bank1_err_wl32                        ),
    .err_wl33                            (bank1_err_wl33                        ),
    .err_wl34                            (bank1_err_wl34                        ),
    .err_wl35                            (bank1_err_wl35                        ),
    .err_wl36                            (bank1_err_wl36                        ),
    .err_wl37                            (bank1_err_wl37                        ),
    .err_wl38                            (bank1_err_wl38                        ),
    .err_wl39                            (bank1_err_wl39                        ),
    .err_wl40                            (bank1_err_wl40                        ),
    .err_wl41                            (bank1_err_wl41                        ),
    .err_wl42                            (bank1_err_wl42                        ),
    .err_wl43                            (bank1_err_wl43                        ),
    .err_wl44                            (bank1_err_wl44                        ),
    .err_wl45                            (bank1_err_wl45                        ),
    .err_wl46                            (bank1_err_wl46                        ),
    .err_wl47                            (bank1_err_wl47                        ),
    .err_wl48                            (bank1_err_wl48                        ),
    .err_wl49                            (bank1_err_wl49                        ),
    .err_wl50                            (bank1_err_wl50                        ),
    .err_wl51                            (bank1_err_wl51                        ),
    .err_wl52                            (bank1_err_wl52                        ),
    .err_wl53                            (bank1_err_wl53                        ),
    .err_wl54                            (bank1_err_wl54                        ),
    .err_wl55                            (bank1_err_wl55                        ),
    .err_wl56                            (bank1_err_wl56                        ),
    .err_wl57                            (bank1_err_wl57                        ),
    .err_wl58                            (bank1_err_wl58                        ),
    .err_wl59                            (bank1_err_wl59                        ),
    .err_wl60                            (bank1_err_wl60                        ),
    .err_wl61                            (bank1_err_wl61                        ),
    .err_wl62                            (bank1_err_wl62                        ),
    .err_wl63                            (bank1_err_wl63                        ),
    .err_wl_cnt                          (bank1_err_wl_cnt                      ), 
    .err_wl_cnt_change_flag              (bank1_err_wl_cnt_change_flag          )
);


always @(*)
begin
    bank_scan_frame_vld = 1'b0;
    bank_scan_frame_data = 'd0;
    bank0_scan_rvalid = 1'b0;
    csl_scan_frame_vld = 1'b0;
    csl_scan_frame_data = 'd0;
    bank0_csl_scan_rvalid = 1'b0;
    wl_scan_frame_vld = 1'b0;
    wl_scan_frame_data = 1'd0;
    bank0_wl_scan_rvalid = 1'b0;
    bank1_scan_rvalid = 1'b0;
    bank1_csl_scan_rvalid = 1'b0;
    bank1_wl_scan_rvalid = 1'b0;
    if(SCAN_CS == BANK0) begin
        bank_scan_frame_vld = bank0_scan_frame_vld;
        bank_scan_frame_data = {bank0_scan_frame_data[289:287],2'b01,bank0_scan_frame_data[286:0]};
        bank0_scan_rvalid = bank_scan_rvalid;
        csl_scan_frame_vld = bank0_csl_scan_frame_vld;
        csl_scan_frame_data = {bank0_csl_scan_frame_data[289:287],2'b01,bank0_csl_scan_frame_data[286:00]};
        bank0_csl_scan_rvalid = csl_scan_rvalid;
        wl_scan_frame_vld = bank0_wl_scan_frame_vld;
        wl_scan_frame_data = {bank0_wl_scan_frame_data[289:287],2'b01,bank0_wl_scan_frame_data[286:0]};
        bank0_wl_scan_rvalid = wl_scan_rvalid;
    end
    else if(SCAN_CS == BANK1)begin
        bank_scan_frame_vld = bank1_scan_frame_vld;
        bank_scan_frame_data = {bank1_scan_frame_data[289:287],2'b10,bank1_scan_frame_data[286:0]};
        bank1_scan_rvalid = bank_scan_rvalid;
        csl_scan_frame_vld = bank1_csl_scan_frame_vld;
        csl_scan_frame_data = {bank1_csl_scan_frame_data[289:287],2'b10,bank1_csl_scan_frame_data[286:0]};
        bank1_csl_scan_rvalid = csl_scan_rvalid;
        wl_scan_frame_vld = bank1_wl_scan_frame_vld;
        wl_scan_frame_data = {bank1_wl_scan_frame_data[289:287],2'b10,bank1_wl_scan_frame_data[286:0]};
        bank1_wl_scan_rvalid = wl_scan_rvalid;
    end
end

always @(*)
begin
    case({bist_scan_end_bank,bist_scan_start_bank})
        2'b00: begin
            bist_success = bank0_bist_success;
            bist_finish  = bank0_bist_finish;
            bist_bank_finish = bank0_bist_bank_finish;
            bist_finish_int = bank0_bist_finish_int;
            bist_scan_status = bank0_bist_scan_status;
        end
        2'b10: begin
            bist_success = bank0_bist_success && bank1_bist_success;
            bist_finish  = bank0_bist_finish && bank1_bist_finish;
            bist_bank_finish = bank0_bist_bank_finish && bank1_bist_bank_finish;
            bist_finish_int = bank0_bist_finish_int && bank1_bist_finish_int;
            bist_scan_status = (SCAN_CS == BANK0) ? bank0_bist_scan_status : 
                               ((SCAN_CS == BANK1) ? bank1_bist_scan_status : (bank0_bist_scan_status & bank1_bist_scan_status)) ;
        end
        2'b11: begin
            bist_success = bank1_bist_success;
            bist_finish  = bank1_bist_finish;
            bist_bank_finish = bank1_bist_bank_finish;
            bist_finish_int = bank1_bist_finish_int;
            bist_scan_status = bank1_bist_scan_status;
        end
        default: begin
            bist_success = 1'b0;
            bist_finish  = 1'b0;
            bist_bank_finish = 1'b0;
            bist_finish_int = 1'b0;
            bist_scan_status = 1'b0;
        end
    endcase
end

assign  bist_scan_fsm_status = SCAN_CS;


endmodule
