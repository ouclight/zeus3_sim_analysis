module csl_scan_aux (
  //-------------clock and reset signal--------------
  input                                               clk                  ,
  input                                               rst_n                ,
  //-------------control signal----------------------
  input                                               global_mc_bist_start ,
  input                                               global_mc_bist_en    ,
  input                                               csl_scan_addr_range_sel,//default 1,scan all addr
  input                                               csl_scan_check_sel    ,//default 1,check 266 bits rdata
  input                                               mc_bist_en            ,
  input                                               bank_scan_finish      ,
  input                                               bist_finish_clr       ,
  input      [6:0]                                    bist_csl_scan_num     ,
  input      [4:0]                                    csl_err_threshold     ,
  input      [31:0]                                   bist_pattern0         ,
  input      [31:0]                                   bist_pattern1         ,
  input      [31:0]                                   bist_pattern2         ,
  input      [31:0]                                   bist_pattern3         ,
  input      [31:0]                                   bist_pattern4         ,
  input      [31:0]                                   bist_pattern5         ,
  input      [31:0]                                   bist_pattern6         ,
  input      [31:0]                                   bist_pattern7         ,
  input      [31:0]                                   bist_pattern8         ,
  input      [31:0]                                   bist_pattern9         ,
  input      [31:0]                                   bist_pattern10        ,
  input      [31:0]                                   bist_pattern11        ,
  input      [31:0]                                   bist_pattern12        ,
  input      [31:0]                                   bist_pattern13        ,
  input      [31:0]                                   bist_pattern14        ,
  input      [31:0]                                   bist_pattern15        ,
  input      [31:0]                                   bist_pattern16        ,
  input      [31:0]                                   bist_pattern17        ,
  input      [31:0]                                   bist_pattern18        ,
  input      [31:0]                                   bist_pattern19        ,
  input      [31:0]                                   bist_pattern20        ,
  input      [31:0]                                   bist_pattern21        ,
  input      [31:0]                                   bist_pattern22        ,
  input      [31:0]                                   bist_pattern23        ,
  input      [31:0]                                   bist_pattern24        ,
  input      [31:0]                                   bist_pattern25        ,
  input      [31:0]                                   bist_pattern26        ,
  input      [31:0]                                   bist_pattern27        ,
  input      [31:0]                                   bist_pattern28        ,
  input      [31:0]                                   bist_pattern29        ,
  input      [31:0]                                   bist_pattern30        ,
  input      [31:0]                                   bist_pattern31        ,
  input      [31:0]                                   bist_pattern32        ,
  input      [31:0]                                   bist_pattern33        ,
  input      [31:0]                                   bist_pattern34        ,
  input      [31:0]                                   bist_pattern35        ,
  input      [31:0]                                   bist_pattern36        ,
  input      [31:0]                                   bist_pattern37        ,
  input      [31:0]                                   bist_pattern38        ,
  input      [31:0]                                   bist_pattern39        ,
  input      [31:0]                                   bist_pattern40        ,
  input      [31:0]                                   bist_pattern41        ,
  input      [31:0]                                   bist_pattern42        ,
  input      [31:0]                                   bist_pattern43        ,
  input      [31:0]                                   bist_pattern44        ,
  input      [31:0]                                   bist_pattern45        ,
  input      [31:0]                                   bist_pattern46        ,
  input      [31:0]                                   bist_pattern47        ,
  input      [31:0]                                   bist_pattern48        ,
  input      [31:0]                                   bist_pattern49        ,
  input      [31:0]                                   bist_pattern50        ,
  input      [31:0]                                   bist_pattern51        ,
  input      [31:0]                                   bist_pattern52        ,
  input      [31:0]                                   bist_pattern53        ,
  input      [31:0]                                   bist_pattern54        ,
  input      [31:0]                                   bist_pattern55        ,
  input      [31:0]                                   bist_pattern56        ,
  input      [31:0]                                   bist_pattern57        ,
  input      [31:0]                                   bist_pattern58        ,
  input      [31:0]                                   bist_pattern59        ,
  input      [31:0]                                   bist_pattern60        ,
  input      [31:0]                                   bist_pattern61        ,
  input      [31:0]                                   bist_pattern62        ,
  input      [31:0]                                   bist_pattern63        ,  
  output reg                                          csl_scan_finish       ,
  output reg                                          csl_scan_fail         ,
  output                                              csl_scan_working      ,
  //-------------data signal------------------------
  output reg                                          csl_scan_frame_vld    ,
  input                                               csl_scan_frame_rdy    ,
  output     [1+1+1+266+13+8-1 :0]                    csl_scan_frame_data   ,//rw_flag,sof,eof,data,row,col
  input                                               csl_scan_rvalid       ,
  input      [266-1:0]                                csl_scan_rdata        ,
  //-------------error csl record signal------------
  output reg [7:0]                                    err_csl0_part0        ,
  output reg [7:0]                                    err_csl1_part0        ,
  output reg [7:0]                                    err_csl0_part1        ,
  output reg [7:0]                                    err_csl1_part1        ,
  output reg [7:0]                                    err_csl0_part2        ,
  output reg [7:0]                                    err_csl1_part2        ,
  output reg [7:0]                                    err_csl0_part3        ,
  output reg [7:0]                                    err_csl1_part3        ,
  output reg [7:0]                                    err_csl0_part4        ,
  output reg [7:0]                                    err_csl1_part4        ,

  output reg [7:0]                                    err_csl0_part5        ,
  output reg [7:0]                                    err_csl1_part5        ,
  output reg [7:0]                                    err_csl0_part6        ,
  output reg [7:0]                                    err_csl1_part6        ,
  output reg [7:0]                                    err_csl0_part7        ,
  output reg [7:0]                                    err_csl1_part7        ,
  output reg [7:0]                                    err_csl0_part8        ,
  output reg [7:0]                                    err_csl1_part8        ,
  output reg [7:0]                                    err_csl0_part9        ,
  output reg [7:0]                                    err_csl1_part9        



);


//wire and reg
wire   [32*64-1:0]                               bist_pattern_store             ;

reg    [6:0]                                     csl_scan_num_cnt_status        ;
wire                                             csl_scan_row_part0_status      ;
wire                                             csl_scan_row_part1_status      ;
wire                                             csl_scan_row_part2_status      ;
wire                                             csl_scan_row_part3_status      ;
wire                                             csl_scan_row_part4_status      ;
wire                                             csl_scan_row_part5_status      ;
wire                                             csl_scan_row_part6_status      ;
wire                                             csl_scan_row_part7_status      ;
wire                                             csl_scan_row_part8_status      ;
wire                                             csl_scan_row_part9_status      ;


wire                                             csl_scan_row_write_done        ;
reg                                              csl_scan_row_part0_single_done ;
reg                                              csl_scan_row_part1_single_done ;
reg                                              csl_scan_row_part2_single_done ;
reg                                              csl_scan_row_part3_single_done ;
reg                                              csl_scan_row_part4_single_done ;
reg                                              csl_scan_row_part5_single_done ;
reg                                              csl_scan_row_part6_single_done ;
reg                                              csl_scan_row_part7_single_done ;
reg                                              csl_scan_row_part8_single_done ;
reg                                              csl_scan_row_part9_single_done ;

//azy
wire                                             csl_scan_row_part0_single_done_pre ;
wire                                             csl_scan_row_part1_single_done_pre ;
wire                                             csl_scan_row_part2_single_done_pre ;
wire                                             csl_scan_row_part3_single_done_pre ;
wire                                             csl_scan_row_part4_single_done_pre ;
wire                                             csl_scan_row_part5_single_done_pre ;
wire                                             csl_scan_row_part6_single_done_pre ;
wire                                             csl_scan_row_part7_single_done_pre ;
wire                                             csl_scan_row_part8_single_done_pre ;
wire                                             csl_scan_row_part9_single_done_pre ;

wire                                             csl_single_pattern_done        ;
//azy
reg    [6:0]                                     csl_scan_num_cnt_status_inner  ;
wire                                             csl_scan_num_cnt_allow         ;

reg                                              frame_data_rw_flag             ;
reg                                              frame_data_sof                 ;
reg                                              frame_data_eof                 ;
reg    [265:0]                                   frame_data                     ;
reg    [7:0]                                     frame_data_send_col_addr       ;
reg    [12:0]                                    frame_data_send_row_addr       ;
reg    [7:0]                                     receive_col_addr               ;
reg    [12:0]                                    receive_row_addr               ;

reg    [4:0]                                     data_noback_req_cnt            ; //data no back, read request cnt


reg    [265:0]                                   frame_golden_data              ;
reg    [4:0]                                     csl_err_cnt_inner              ;
reg    [4:0]                                     csl_err_cnt                    ;
reg                                              err_csl2_part0_flag            ;
reg                                              err_csl2_part1_flag            ;
reg                                              err_csl2_part2_flag            ;
reg                                              err_csl2_part3_flag            ;
reg                                              err_csl2_part4_flag            ;
reg                                              err_csl2_part5_flag            ;
reg                                              err_csl2_part6_flag            ;
reg                                              err_csl2_part7_flag            ;
reg                                              err_csl2_part8_flag            ;
reg                                              err_csl2_part9_flag            ;

reg                                              csl_scan_row_part0_status_r    ;
reg                                              csl_scan_row_part1_status_r    ;
reg                                              csl_scan_row_part2_status_r    ;
reg                                              csl_scan_row_part3_status_r    ;
reg                                              csl_scan_row_part4_status_r    ;
reg                                              csl_scan_row_part5_status_r    ;
reg                                              csl_scan_row_part6_status_r    ;
reg                                              csl_scan_row_part7_status_r    ;
reg                                              csl_scan_row_part8_status_r    ;
reg                                              csl_scan_row_part9_status_r    ;

wire                                             csl_scan_row_part0_status_pos  ;
wire                                             csl_scan_row_part1_status_pos  ;
wire                                             csl_scan_row_part2_status_pos  ;
wire                                             csl_scan_row_part3_status_pos  ;
wire                                             csl_scan_row_part4_status_pos  ;
wire                                             csl_scan_row_part5_status_pos  ;
wire                                             csl_scan_row_part6_status_pos  ;
wire                                             csl_scan_row_part7_status_pos  ;
wire                                             csl_scan_row_part8_status_pos  ;
wire                                             csl_scan_row_part9_status_pos  ;


wire   [7:0]                                     col_end_addr                   ;
wire                                             rdata_diff_flag                ;
wire                                             csl_scan_success_status        ;
wire                                             csl_scan_fail_status           ;
//--------------------------------------------------
//assign  csl_scan_row_up_start_addr   =  14'h0    ;
/////////////assign  csl_scan_row_up_end_addr     =  13'hE60 - 1'b1 ;//7360/2-1,
/////////////assign  csl_scan_row_down_start_addr =  13'hE60 ;//7360
/////////////assign  csl_scan_row_down_end_addr   =  13'h1CC0 - 1'b1 ;//7359

wire   [12:0]                                    csl_scan_row_part0_end_addr    ;
wire   [12:0]                                    csl_scan_row_part1_start_addr  ;
wire   [12:0]                                    csl_scan_row_part1_end_addr    ;
wire   [12:0]                                    csl_scan_row_part2_start_addr  ;
wire   [12:0]                                    csl_scan_row_part2_end_addr    ;
wire   [12:0]                                    csl_scan_row_part3_start_addr  ;
wire   [12:0]                                    csl_scan_row_part3_end_addr    ;
wire   [12:0]                                    csl_scan_row_part4_start_addr  ;
wire   [12:0]                                    csl_scan_row_part4_end_addr    ;
wire   [12:0]                                    csl_scan_row_part5_start_addr  ;
wire   [12:0]                                    csl_scan_row_part5_end_addr    ;
wire   [12:0]                                    csl_scan_row_part6_start_addr  ;
wire   [12:0]                                    csl_scan_row_part6_end_addr    ;
wire   [12:0]                                    csl_scan_row_part7_start_addr  ;
wire   [12:0]                                    csl_scan_row_part7_end_addr    ;
wire   [12:0]                                    csl_scan_row_part8_start_addr  ;
wire   [12:0]                                    csl_scan_row_part8_end_addr    ;
wire   [12:0]                                    csl_scan_row_part9_start_addr  ;
wire   [12:0]                                    csl_scan_row_part9_end_addr    ;

/////////assign csl_scan_row_part0_end_addr   = 13'h2df ;//735
/////////assign csl_scan_row_part1_start_addr = csl_scan_row_part0_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part1_end_addr   = csl_scan_row_part1_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part2_start_addr = csl_scan_row_part1_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part2_end_addr   = csl_scan_row_part2_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part3_start_addr = csl_scan_row_part2_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part3_end_addr   = csl_scan_row_part3_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part4_start_addr = csl_scan_row_part3_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part4_end_addr   = csl_scan_row_part4_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part5_start_addr = csl_scan_row_part4_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part5_end_addr   = csl_scan_row_part5_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part6_start_addr = csl_scan_row_part5_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part6_end_addr   = csl_scan_row_part6_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part7_start_addr = csl_scan_row_part6_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part7_end_addr   = csl_scan_row_part7_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part8_start_addr = csl_scan_row_part7_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part8_end_addr   = csl_scan_row_part8_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part9_start_addr = csl_scan_row_part8_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part9_end_addr   = csl_scan_row_part9_start_addr + 13'h2df  ;

assign  col_end_addr = csl_scan_addr_range_sel ?  8'h81 : 8'h7f;//129 or 127

///////////////assign  csl_scan_row_up_end_addr     =  13'd63;//test
///////////////assign  csl_scan_row_down_start_addr =  13'd64;//test
///////////////assign  csl_scan_row_down_end_addr   =  13'd127;//test
assign csl_scan_row_part0_end_addr   = 13'd29 ;
assign csl_scan_row_part1_start_addr = csl_scan_row_part0_end_addr   + 13'h1    ;//test
assign csl_scan_row_part1_end_addr   = csl_scan_row_part1_start_addr + 13'd29  ;//test
assign csl_scan_row_part2_start_addr = csl_scan_row_part1_end_addr   + 13'h1    ;//test
assign csl_scan_row_part2_end_addr   = csl_scan_row_part2_start_addr + 13'd29  ;//test
assign csl_scan_row_part3_start_addr = csl_scan_row_part2_end_addr   + 13'h1    ;//test
assign csl_scan_row_part3_end_addr   = csl_scan_row_part3_start_addr + 13'd29  ;//test
assign csl_scan_row_part4_start_addr = csl_scan_row_part3_end_addr   + 13'h1    ;//test
assign csl_scan_row_part4_end_addr   = csl_scan_row_part4_start_addr + 13'd29  ;//test
assign csl_scan_row_part5_start_addr = csl_scan_row_part4_end_addr   + 13'h1    ;//test
assign csl_scan_row_part5_end_addr   = csl_scan_row_part5_start_addr + 13'd29  ;//test
assign csl_scan_row_part6_start_addr = csl_scan_row_part5_end_addr   + 13'h1    ;//test
assign csl_scan_row_part6_end_addr   = csl_scan_row_part6_start_addr + 13'd29  ;//test
assign csl_scan_row_part7_start_addr = csl_scan_row_part6_end_addr   + 13'h1    ;//test
assign csl_scan_row_part7_end_addr   = csl_scan_row_part7_start_addr + 13'd29  ;//test
assign csl_scan_row_part8_start_addr = csl_scan_row_part7_end_addr   + 13'h1    ;//test
assign csl_scan_row_part8_end_addr   = csl_scan_row_part8_start_addr + 13'd29  ;//test
assign csl_scan_row_part9_start_addr = csl_scan_row_part8_end_addr   + 13'h1    ;//test
assign csl_scan_row_part9_end_addr   = csl_scan_row_part9_start_addr + 13'd29  ;//test



assign  bist_pattern_store = {bist_pattern63, bist_pattern62, bist_pattern61, bist_pattern60,bist_pattern59, bist_pattern58, bist_pattern57, bist_pattern56,
                              bist_pattern55, bist_pattern54, bist_pattern53, bist_pattern52,bist_pattern51, bist_pattern50, bist_pattern49, bist_pattern48,
                              bist_pattern47, bist_pattern46, bist_pattern45, bist_pattern44,bist_pattern43, bist_pattern42, bist_pattern41, bist_pattern40,
                              bist_pattern39, bist_pattern38, bist_pattern37, bist_pattern36,bist_pattern35, bist_pattern34, bist_pattern33, bist_pattern32,
                              bist_pattern31, bist_pattern30, bist_pattern29, bist_pattern28,bist_pattern27, bist_pattern26, bist_pattern25, bist_pattern24,
                              bist_pattern23, bist_pattern22, bist_pattern21, bist_pattern20,bist_pattern19, bist_pattern18, bist_pattern17, bist_pattern16,
                              bist_pattern15, bist_pattern14, bist_pattern13, bist_pattern12,bist_pattern11, bist_pattern10, bist_pattern9, bist_pattern8,
                              bist_pattern7, bist_pattern6, bist_pattern5, bist_pattern4,bist_pattern3, bist_pattern2, bist_pattern1, bist_pattern0 };

//------------------------------------------------------------------------
always @(*) begin
    if(csl_single_pattern_done)
        csl_scan_num_cnt_status = csl_scan_num_cnt_status_inner + 1'b1 ;
    else 
        csl_scan_num_cnt_status = csl_scan_num_cnt_status_inner  ;
end
assign csl_scan_num_cnt_allow = (csl_scan_num_cnt_status > 7'h0) && (csl_scan_num_cnt_status < bist_csl_scan_num ) ; 

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        csl_scan_num_cnt_status_inner   <=  7'h0   ;
    end
    else if(global_mc_bist_start)
        csl_scan_num_cnt_status_inner   <=  7'h0   ;
    else begin
        csl_scan_num_cnt_status_inner   <= csl_scan_num_cnt_status  ;
    end
end

//----------------------------------------------------------------------------
//FSM design
//----------------------------------------------------------------------------
localparam  IDLE                 = 4'b0000  ,
            WR_ADDR              = 4'b0001  ,
            RD_PART0_ADDR        = 4'b0010  ,
            RD_PART1_ADDR        = 4'b0011  ,
            RD_PART2_ADDR        = 4'b0100  ,
            RD_PART3_ADDR        = 4'b0101  ,
            RD_PART4_ADDR        = 4'b0110  ,
            RD_PART5_ADDR        = 4'b0111  ,
            RD_PART6_ADDR        = 4'b1000  ,
            RD_PART7_ADDR        = 4'b1001  ,
            RD_PART8_ADDR        = 4'b1010  ,
            RD_PART9_ADDR        = 4'b1011  ;


reg [3:0] FSM_CS;
reg [3:0] FSM_NS;

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    FSM_CS <= IDLE ;
  end
  else begin
    FSM_CS <= FSM_NS ;
  end
end

always @(*)
begin
  case(FSM_CS)
    IDLE: begin
      if ( bank_scan_finish && global_mc_bist_en && mc_bist_en)
        FSM_NS = WR_ADDR;
      else
        FSM_NS = FSM_CS;
    end
    WR_ADDR: begin
      if (csl_scan_row_write_done)
        FSM_NS = RD_PART0_ADDR;
      else
        FSM_NS = FSM_CS;
    end 
    RD_PART0_ADDR : begin
        if (csl_scan_row_part0_single_done && !csl_scan_row_part0_status)
          FSM_NS = RD_PART1_ADDR;
        else if(csl_scan_row_part0_single_done && csl_scan_row_part0_status)// 3 csl err
          FSM_NS = IDLE;
        else
          FSM_NS = FSM_CS;
    end
    RD_PART1_ADDR : begin
        if (csl_scan_row_part1_single_done && !csl_scan_row_part1_status)
          FSM_NS = RD_PART2_ADDR;
        else if(csl_scan_row_part1_single_done && csl_scan_row_part1_status)// 3 csl err
          FSM_NS = IDLE;
        else
          FSM_NS = FSM_CS;
    end
    RD_PART2_ADDR : begin
        if (csl_scan_row_part2_single_done && !csl_scan_row_part2_status)
          FSM_NS = RD_PART3_ADDR;
        else if(csl_scan_row_part2_single_done && csl_scan_row_part2_status)// 3 csl err
          FSM_NS = IDLE;
        else
          FSM_NS = FSM_CS;
      end
    RD_PART3_ADDR : begin
        if (csl_scan_row_part3_single_done && !csl_scan_row_part3_status)
          FSM_NS = RD_PART4_ADDR;
        else if(csl_scan_row_part3_single_done && csl_scan_row_part3_status)// 3 csl err
          FSM_NS = IDLE;
        else
          FSM_NS = FSM_CS;
    end
    RD_PART4_ADDR : begin
        if (csl_scan_row_part4_single_done && !csl_scan_row_part4_status)
          FSM_NS = RD_PART5_ADDR;
        else if(csl_scan_row_part4_single_done && csl_scan_row_part4_status)// 3 csl err
          FSM_NS = IDLE;
        else
          FSM_NS = FSM_CS;
    end
    RD_PART5_ADDR : begin
        if (csl_scan_row_part5_single_done && !csl_scan_row_part5_status)
          FSM_NS = RD_PART6_ADDR;
        else if(csl_scan_row_part5_single_done && csl_scan_row_part5_status)// 3 csl err
          FSM_NS = IDLE;
        else
          FSM_NS = FSM_CS;
    end
    RD_PART6_ADDR : begin
        if (csl_scan_row_part6_single_done && !csl_scan_row_part6_status)
          FSM_NS = RD_PART7_ADDR;
        else if(csl_scan_row_part6_single_done && csl_scan_row_part6_status)// 3 csl err
          FSM_NS = IDLE;
        else
          FSM_NS = FSM_CS;
    end
    RD_PART7_ADDR : begin
        if (csl_scan_row_part7_single_done && !csl_scan_row_part7_status)
          FSM_NS = RD_PART8_ADDR;
        else if(csl_scan_row_part7_single_done && csl_scan_row_part7_status)// 3 csl err
          FSM_NS = IDLE;
        else
          FSM_NS = FSM_CS;
      end
    RD_PART8_ADDR : begin
        if (csl_scan_row_part8_single_done && !csl_scan_row_part8_status)
          FSM_NS = RD_PART9_ADDR;
        else if(csl_scan_row_part8_single_done && csl_scan_row_part8_status)// 3 csl err
          FSM_NS = IDLE;
        else
          FSM_NS = FSM_CS;
    end
    RD_PART9_ADDR : begin
        if(csl_scan_row_part9_single_done && csl_scan_num_cnt_allow && !csl_scan_row_part9_status)
          FSM_NS = WR_ADDR;
        else if(csl_scan_row_part9_single_done && csl_scan_row_part9_status)// 3 err
          FSM_NS = IDLE;          
        else if(csl_scan_row_part9_single_done && !csl_scan_num_cnt_allow && !csl_scan_row_part9_status)//all pattern done
          FSM_NS = IDLE;
        else
          FSM_NS = FSM_CS;
    end
    default: FSM_NS = IDLE;
endcase
end
//----------------------------------------------------------------------------
assign csl_scan_frame_data = {frame_data_rw_flag,frame_data_sof,frame_data_eof,frame_data,frame_data_send_row_addr,frame_data_send_col_addr} ;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        data_noback_req_cnt  <=  5'h0 ;
    end
    else if((csl_scan_frame_vld && csl_scan_frame_rdy && !(FSM_CS==IDLE || FSM_CS==WR_ADDR)) && csl_scan_rvalid) begin//read state
        data_noback_req_cnt  <=  data_noback_req_cnt   ;
    end
    else if(csl_scan_frame_vld && csl_scan_frame_rdy && !(FSM_CS==IDLE || FSM_CS==WR_ADDR)) begin
        data_noback_req_cnt  <=  data_noback_req_cnt + 1'b1  ;
    end
    else if( csl_scan_rvalid) begin
        data_noback_req_cnt  <=  data_noback_req_cnt - 1'b1  ;
    end
end


always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==WR_ADDR) begin
        if(!csl_scan_row_write_done)
            csl_scan_frame_vld   <=  1'b1   ;
    end
    else if(FSM_CS==RD_PART0_ADDR) begin
        if(!csl_scan_row_part0_status &&(frame_data_send_row_addr!=csl_scan_row_part0_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part0_end_addr && frame_data_send_col_addr == col_end_addr && csl_scan_frame_rdy) || csl_scan_row_part0_status)
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART1_ADDR) begin
        if(!csl_scan_row_part1_status &&(frame_data_send_row_addr!=csl_scan_row_part1_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part1_end_addr && frame_data_send_col_addr == col_end_addr && csl_scan_frame_rdy) || csl_scan_row_part1_status)
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART2_ADDR) begin
        if(!csl_scan_row_part2_status &&(frame_data_send_row_addr!=csl_scan_row_part2_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part2_end_addr && frame_data_send_col_addr == col_end_addr && csl_scan_frame_rdy) || csl_scan_row_part2_status)
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART3_ADDR) begin
        if(!csl_scan_row_part3_status &&(frame_data_send_row_addr!=csl_scan_row_part3_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part3_end_addr && frame_data_send_col_addr == col_end_addr && csl_scan_frame_rdy) || csl_scan_row_part3_status)
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART4_ADDR) begin
        if(!csl_scan_row_part4_status && (frame_data_send_row_addr!=csl_scan_row_part4_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part4_end_addr && frame_data_send_col_addr==col_end_addr && csl_scan_frame_rdy)|| csl_scan_row_part4_status)
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART5_ADDR) begin
        if(!csl_scan_row_part5_status && (frame_data_send_row_addr!=csl_scan_row_part5_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part5_end_addr && frame_data_send_col_addr==col_end_addr && csl_scan_frame_rdy)|| csl_scan_row_part5_status)
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART6_ADDR) begin
        if(!csl_scan_row_part6_status && (frame_data_send_row_addr!=csl_scan_row_part6_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part6_end_addr && frame_data_send_col_addr==col_end_addr && csl_scan_frame_rdy)|| csl_scan_row_part6_status)
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART7_ADDR) begin
        if(!csl_scan_row_part7_status && (frame_data_send_row_addr!=csl_scan_row_part7_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part7_end_addr && frame_data_send_col_addr==col_end_addr && csl_scan_frame_rdy)|| csl_scan_row_part7_status)
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART8_ADDR) begin
        if(!csl_scan_row_part8_status && (frame_data_send_row_addr!=csl_scan_row_part8_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part8_end_addr && frame_data_send_col_addr==col_end_addr && csl_scan_frame_rdy)|| csl_scan_row_part8_status)
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART9_ADDR) begin
        if(!csl_scan_row_part9_status && (frame_data_send_row_addr!=csl_scan_row_part9_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part9_end_addr && frame_data_send_col_addr==col_end_addr && csl_scan_frame_rdy)|| csl_scan_row_part9_status)
            csl_scan_frame_vld   <=  1'b0   ;
    end
end

always @(*) begin  //rw_flag
    if(FSM_CS==WR_ADDR)
        frame_data_rw_flag = 1'b1 ;
    else
        frame_data_rw_flag = 1'b0 ;
end

always @(*) begin  //sof
    if(FSM_CS==WR_ADDR && frame_data_send_col_addr==8'h0)
        frame_data_sof = 1'b1 ;
    else if(!(FSM_CS==IDLE || FSM_CS==WR_ADDR))
        frame_data_sof = 1'b1 ;
    else
        frame_data_sof = 1'b0 ;
    end
always @(*) begin  //eof
    if(FSM_CS==WR_ADDR && frame_data_send_col_addr==col_end_addr)
        frame_data_eof = 1'b1 ;
    else if(!(FSM_CS==IDLE || FSM_CS==WR_ADDR))
        frame_data_eof = 1'b1 ;
    else
        frame_data_eof = 1'b0 ;
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        frame_data  <=  266'h0 ;
    end
    else if(FSM_CS == WR_ADDR) begin
        if(frame_data_send_row_addr[1:0]==2'b00)
        frame_data  <=  {bist_pattern_store[(csl_scan_num_cnt_status*32+0)+:2],{33{bist_pattern_store[(csl_scan_num_cnt_status*32+0)+:8]}}} ;
        else if(frame_data_send_row_addr[1:0]==2'b01)
        frame_data  <=  {bist_pattern_store[(csl_scan_num_cnt_status*32+8)+:2],{33{bist_pattern_store[(csl_scan_num_cnt_status*32+8)+:8]}}} ;
        else if(frame_data_send_row_addr[1:0]==2'b10)
        frame_data  <=  {bist_pattern_store[(csl_scan_num_cnt_status*32+16)+:2],{33{bist_pattern_store[(csl_scan_num_cnt_status*32+16)+:8]}}} ;
        else if(frame_data_send_row_addr[1:0]==2'b11)
        frame_data  <=  {bist_pattern_store[(csl_scan_num_cnt_status*32+24)+:2],{33{bist_pattern_store[(csl_scan_num_cnt_status*32+24)+:8]}}} ;
    end
    else
        frame_data  <= 266'h0 ;
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        frame_data_send_col_addr  <=  8'h0 ;
    end
    else if(global_mc_bist_start)
        frame_data_send_col_addr   <=  8'h0   ;
    else if(FSM_CS == WR_ADDR) begin
        if(frame_data_send_col_addr == col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <=  8'h0   ;
        else if(csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART0_ADDR) begin
        if(csl_scan_row_part0_single_done) 
            frame_data_send_col_addr   <=  8'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part0_end_addr && frame_data_send_col_addr!=col_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART1_ADDR) begin
        if(csl_scan_row_part1_single_done) 
            frame_data_send_col_addr   <=  8'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part1_end_addr && frame_data_send_col_addr!=col_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART2_ADDR) begin
        if(csl_scan_row_part2_single_done) 
            frame_data_send_col_addr   <=  8'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part2_end_addr && frame_data_send_col_addr!=col_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART3_ADDR) begin
        if(csl_scan_row_part3_single_done) 
            frame_data_send_col_addr   <=  8'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part3_end_addr && frame_data_send_col_addr!=col_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end    
    else if(FSM_CS == RD_PART4_ADDR) begin
        if(csl_scan_row_part4_single_done) 
            frame_data_send_col_addr   <=  8'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part4_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART5_ADDR) begin
        if(csl_scan_row_part5_single_done) 
            frame_data_send_col_addr   <=  8'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part5_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART6_ADDR) begin
        if(csl_scan_row_part6_single_done) 
            frame_data_send_col_addr   <=  8'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part6_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART7_ADDR) begin
        if(csl_scan_row_part7_single_done) 
            frame_data_send_col_addr   <=  8'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part7_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART8_ADDR) begin
        if(csl_scan_row_part8_single_done) 
            frame_data_send_col_addr   <=  8'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part8_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
        end
    else if(FSM_CS == RD_PART9_ADDR) begin
        if(csl_scan_row_part9_single_done) 
            frame_data_send_col_addr   <=  8'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part9_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        frame_data_send_row_addr  <=  13'h0 ;
    end
    else if(global_mc_bist_start)
        frame_data_send_row_addr  <=  13'h0 ;
    else if(FSM_CS == WR_ADDR) begin
        if(frame_data_send_row_addr==csl_scan_row_part9_end_addr && frame_data_send_col_addr == col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  13'h0  ;
        else if(frame_data_send_col_addr == col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART0_ADDR) begin
        if(csl_scan_row_part0_single_done && !csl_scan_row_part0_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part1_start_addr   ;
        else if(csl_scan_row_part0_single_done && csl_scan_row_part0_status) 
            frame_data_send_row_addr   <=  13'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part0_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  13'h0   ;
        else if(frame_data_send_row_addr!=csl_scan_row_part0_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART1_ADDR) begin
        if(csl_scan_row_part1_single_done && !csl_scan_row_part1_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part2_start_addr   ;
        else if(csl_scan_row_part1_single_done && csl_scan_row_part1_status) 
            frame_data_send_row_addr   <=  13'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part1_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part1_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part1_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART2_ADDR) begin
        if(csl_scan_row_part2_single_done && !csl_scan_row_part2_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part3_start_addr   ;
        else if(csl_scan_row_part2_single_done && csl_scan_row_part2_status) 
            frame_data_send_row_addr   <=  13'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part2_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part2_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part2_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART3_ADDR) begin
        if(csl_scan_row_part3_single_done && !csl_scan_row_part3_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part4_start_addr   ;
        else if(csl_scan_row_part3_single_done && csl_scan_row_part3_status) 
            frame_data_send_row_addr   <=  13'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part3_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part3_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part3_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART4_ADDR) begin
        if(csl_scan_row_part4_single_done && !csl_scan_row_part4_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part5_start_addr   ;
        else if(csl_scan_row_part4_single_done && csl_scan_row_part4_status) 
            frame_data_send_row_addr   <=  13'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part4_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part4_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part4_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART5_ADDR) begin
        if(csl_scan_row_part5_single_done && !csl_scan_row_part5_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part6_start_addr   ;
        else if(csl_scan_row_part5_single_done && csl_scan_row_part5_status) 
            frame_data_send_row_addr   <=  13'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part5_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part5_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part5_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART6_ADDR) begin
        if(csl_scan_row_part6_single_done && !csl_scan_row_part6_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part7_start_addr   ;
        else if(csl_scan_row_part6_single_done && csl_scan_row_part6_status) 
            frame_data_send_row_addr   <=  13'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part6_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part6_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part6_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART7_ADDR) begin
        if(csl_scan_row_part7_single_done && !csl_scan_row_part7_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part8_start_addr   ;
        else if(csl_scan_row_part7_single_done && csl_scan_row_part7_status) 
            frame_data_send_row_addr   <=  13'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part7_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part7_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part7_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART8_ADDR) begin
        if(csl_scan_row_part8_single_done && !csl_scan_row_part8_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part9_start_addr   ;
        else if(csl_scan_row_part8_single_done && csl_scan_row_part8_status) 
            frame_data_send_row_addr   <=  13'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part8_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part8_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part8_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART9_ADDR) begin
        if(csl_scan_row_part9_single_done && !csl_scan_row_part9_status) 
            frame_data_send_row_addr   <=  13'h0 ;
        else if(csl_scan_row_part9_single_done && csl_scan_row_part9_status)
            frame_data_send_row_addr   <=  13'h0 ;
        else if(frame_data_send_row_addr==csl_scan_row_part9_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part9_start_addr   ;
        else if(frame_data_send_row_addr!=csl_scan_row_part9_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
end

assign csl_scan_row_write_done = ((FSM_CS==WR_ADDR) && (frame_data_send_row_addr == csl_scan_row_part9_end_addr) && frame_data_send_col_addr == col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy) ;
                            
//----------------------------------------------------------------------------

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        receive_col_addr  <=  8'h0 ;
    end
    else if(global_mc_bist_start)
        receive_col_addr  <=  8'h0 ;
    else if(FSM_CS == RD_PART0_ADDR) begin
        if(csl_scan_row_part0_single_done) 
            receive_col_addr   <=  8'h0   ;
        else if(receive_row_addr == csl_scan_row_part0_end_addr && receive_col_addr != col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end    
    else if(FSM_CS == RD_PART1_ADDR) begin
        if(csl_scan_row_part1_single_done) 
            receive_col_addr   <=  8'h0   ;
        else if(receive_row_addr == csl_scan_row_part1_end_addr && receive_col_addr != col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART2_ADDR) begin
        if(csl_scan_row_part2_single_done) 
            receive_col_addr   <=  8'h0   ;
        else if(receive_row_addr == csl_scan_row_part2_end_addr && receive_col_addr != col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART3_ADDR) begin
        if(csl_scan_row_part3_single_done) 
            receive_col_addr   <=  8'h0   ;
        else if(receive_row_addr == csl_scan_row_part3_end_addr && receive_col_addr != col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART4_ADDR) begin
        if(csl_scan_row_part4_single_done) 
            receive_col_addr   <=  8'h0   ;
        else if(receive_row_addr == csl_scan_row_part4_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART5_ADDR) begin
        if(csl_scan_row_part5_single_done) 
            receive_col_addr   <=  8'h0   ;
        else if(receive_row_addr == csl_scan_row_part5_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART6_ADDR) begin
        if(csl_scan_row_part6_single_done) 
            receive_col_addr   <=  8'h0   ;
        else if(receive_row_addr == csl_scan_row_part6_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART7_ADDR) begin
        if(csl_scan_row_part7_single_done) 
            receive_col_addr   <=  8'h0   ;
        else if(receive_row_addr == csl_scan_row_part7_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART8_ADDR) begin
        if(csl_scan_row_part8_single_done) 
            receive_col_addr   <=  8'h0   ;
        else if(receive_row_addr == csl_scan_row_part8_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART9_ADDR) begin
        if(csl_scan_row_part9_single_done) 
            receive_col_addr   <=  8'h0   ;
        else if(receive_row_addr == csl_scan_row_part9_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        receive_row_addr  <=  13'h0 ;
    end
    else if(global_mc_bist_start)
        receive_row_addr  <=  13'h0 ;
    else if(FSM_CS == RD_PART0_ADDR) begin
        if(csl_scan_row_part0_single_done && !csl_scan_row_part0_status) 
            receive_row_addr   <=  csl_scan_row_part1_start_addr   ;
        else if(csl_scan_row_part0_single_done && csl_scan_row_part0_status) 
            receive_row_addr   <=  13'h0   ;
        else if(receive_row_addr==csl_scan_row_part0_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <=  13'h0   ;
        else if(receive_row_addr!=csl_scan_row_part0_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
        end

    else if(FSM_CS == RD_PART1_ADDR) begin
        if(csl_scan_row_part1_single_done && !csl_scan_row_part1_status) 
            receive_row_addr   <=  csl_scan_row_part2_start_addr   ;
        else if(csl_scan_row_part1_single_done && csl_scan_row_part1_status) 
            receive_row_addr   <=  13'h0   ;
        else if(receive_row_addr==csl_scan_row_part1_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part1_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part1_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART2_ADDR) begin
        if(csl_scan_row_part2_single_done && !csl_scan_row_part2_status) 
            receive_row_addr   <=  csl_scan_row_part3_start_addr   ;
        else if(csl_scan_row_part2_single_done && csl_scan_row_part2_status) 
            receive_row_addr   <=  13'h0   ;
        else if(receive_row_addr==csl_scan_row_part2_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part2_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part1_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART3_ADDR) begin
        if(csl_scan_row_part3_single_done && !csl_scan_row_part3_status) 
            receive_row_addr   <=  csl_scan_row_part4_start_addr   ;
        else if(csl_scan_row_part3_single_done && csl_scan_row_part3_status) 
            receive_row_addr   <=  13'h0   ;
        else if(receive_row_addr==csl_scan_row_part3_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part3_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part3_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART4_ADDR) begin
        if(csl_scan_row_part4_single_done && !csl_scan_row_part4_status) 
            receive_row_addr   <=  csl_scan_row_part5_start_addr   ;
        else if(csl_scan_row_part4_single_done && csl_scan_row_part4_status) 
            receive_row_addr   <=  13'h0   ;
        else if(receive_row_addr==csl_scan_row_part4_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part4_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part4_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART5_ADDR) begin
        if(csl_scan_row_part5_single_done && !csl_scan_row_part5_status) 
            receive_row_addr   <=  csl_scan_row_part6_start_addr   ;
        else if(csl_scan_row_part5_single_done && csl_scan_row_part5_status) 
            receive_row_addr   <=  13'h0   ;
        else if(receive_row_addr==csl_scan_row_part5_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part5_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part5_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART6_ADDR) begin
        if(csl_scan_row_part6_single_done && !csl_scan_row_part6_status) 
            receive_row_addr   <=  csl_scan_row_part7_start_addr   ;
        else if(csl_scan_row_part6_single_done && csl_scan_row_part6_status) 
            receive_row_addr   <=  13'h0   ;
        else if(receive_row_addr==csl_scan_row_part6_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part6_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part6_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART7_ADDR) begin
        if(csl_scan_row_part7_single_done && !csl_scan_row_part7_status) 
            receive_row_addr   <=  csl_scan_row_part8_start_addr   ;
        else if(csl_scan_row_part7_single_done && csl_scan_row_part7_status) 
            receive_row_addr   <=  13'h0   ;
        else if(receive_row_addr==csl_scan_row_part7_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part7_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part7_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART8_ADDR) begin
        if(csl_scan_row_part8_single_done && !csl_scan_row_part8_status) 
            receive_row_addr   <=  csl_scan_row_part9_start_addr   ;
        else if(csl_scan_row_part8_single_done && csl_scan_row_part8_status) 
            receive_row_addr   <=  13'h0   ;
        else if(receive_row_addr==csl_scan_row_part8_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part8_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part8_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART9_ADDR) begin
        if(csl_scan_row_part9_single_done && !csl_scan_row_part9_status) 
            receive_row_addr   <=  13'h0   ;
        else if(csl_scan_row_part9_single_done && csl_scan_row_part9_status)
            receive_row_addr   <=  13'h0   ; 
        else if(receive_row_addr==csl_scan_row_part9_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <=  csl_scan_row_part9_start_addr ;
        else if(receive_row_addr!=csl_scan_row_part9_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
        end
end
always @(*)begin
    if(!(FSM_CS==IDLE || FSM_CS==WR_ADDR)) begin
        if(receive_row_addr[1:0]==2'b00)
        frame_golden_data  =  {bist_pattern_store[(csl_scan_num_cnt_status_inner*32+0)+:2],{33{bist_pattern_store[(csl_scan_num_cnt_status_inner*32+0)+:8]}}} ;
        else if(receive_row_addr[1:0]==2'b01)
        frame_golden_data  =  {bist_pattern_store[(csl_scan_num_cnt_status_inner*32+8)+:2],{33{bist_pattern_store[(csl_scan_num_cnt_status_inner*32+8)+:8]}}} ;
        else if(receive_row_addr[1:0]==2'b10)
        frame_golden_data  =  {bist_pattern_store[(csl_scan_num_cnt_status_inner*32+16)+:2],{33{bist_pattern_store[(csl_scan_num_cnt_status_inner*32+16)+:8]}}} ;
        else if(receive_row_addr[1:0]==2'b11)
        frame_golden_data  =  {bist_pattern_store[(csl_scan_num_cnt_status_inner*32+24)+:2],{33{bist_pattern_store[(csl_scan_num_cnt_status_inner*32+24)+:8]}}} ;
        else
        frame_golden_data  = 266'h0 ;
    end
    else begin
        frame_golden_data  = 266'h0 ;
    end
end


assign rdata_diff_flag = csl_scan_check_sel ? csl_scan_rdata!=frame_golden_data : csl_scan_rdata[255:0]!=frame_golden_data[255:0] ; 

always @(*)begin
    if(FSM_CS == RD_PART0_ADDR) begin
        if(csl_scan_row_part0_single_done) 
            csl_err_cnt   =  5'h0   ;
        else if(frame_data_send_row_addr==13'h0 && csl_scan_frame_vld && csl_scan_frame_rdy)
            csl_err_cnt   =  5'h0   ;
        else if(csl_scan_rvalid && rdata_diff_flag && (csl_err_cnt_inner<csl_err_threshold))
            csl_err_cnt   = csl_err_cnt_inner + 1'b1 ;
        else
            csl_err_cnt   = csl_err_cnt_inner ;
    end
    else if(FSM_CS == RD_PART1_ADDR) begin
        if(csl_scan_row_part1_single_done) 
            csl_err_cnt   =  5'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part1_start_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            csl_err_cnt   =  5'h0   ;
        else if(csl_scan_rvalid && rdata_diff_flag && (csl_err_cnt_inner<csl_err_threshold))
            csl_err_cnt   = csl_err_cnt_inner + 1'b1 ;
        else
            csl_err_cnt   = csl_err_cnt_inner ;
    end
    else if(FSM_CS == RD_PART2_ADDR) begin
        if(csl_scan_row_part2_single_done) 
            csl_err_cnt   =  5'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part2_start_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            csl_err_cnt   =  5'h0   ;
        else if(csl_scan_rvalid && rdata_diff_flag && (csl_err_cnt_inner<csl_err_threshold))
            csl_err_cnt   = csl_err_cnt_inner + 1'b1 ;
        else
            csl_err_cnt   = csl_err_cnt_inner ;
    end
    else if(FSM_CS == RD_PART3_ADDR) begin
        if(csl_scan_row_part3_single_done) 
            csl_err_cnt   =  5'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part3_start_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            csl_err_cnt   =  5'h0   ;
        else if(csl_scan_rvalid && rdata_diff_flag && (csl_err_cnt_inner<csl_err_threshold))
            csl_err_cnt   = csl_err_cnt_inner + 1'b1 ;
        else
            csl_err_cnt   = csl_err_cnt_inner ;
    end
    else if(FSM_CS == RD_PART4_ADDR) begin
        if(csl_scan_row_part4_single_done) 
            csl_err_cnt   =  5'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part4_start_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            csl_err_cnt   =  5'h0   ;
        else if(csl_scan_rvalid && rdata_diff_flag && (csl_err_cnt_inner<csl_err_threshold))
            csl_err_cnt   = csl_err_cnt_inner + 1'b1 ;
        else
            csl_err_cnt   = csl_err_cnt_inner ;
    end
    else if(FSM_CS == RD_PART5_ADDR) begin
        if(csl_scan_row_part5_single_done) 
            csl_err_cnt   =  5'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part5_start_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            csl_err_cnt   =  5'h0   ;
        else if(csl_scan_rvalid && rdata_diff_flag && (csl_err_cnt_inner<csl_err_threshold))
            csl_err_cnt   = csl_err_cnt_inner + 1'b1 ;
        else
            csl_err_cnt   = csl_err_cnt_inner ;
    end
    else if(FSM_CS == RD_PART6_ADDR) begin
        if(csl_scan_row_part6_single_done) 
            csl_err_cnt   =  5'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part6_start_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            csl_err_cnt   =  5'h0   ;
        else if(csl_scan_rvalid && rdata_diff_flag && (csl_err_cnt_inner<csl_err_threshold))
            csl_err_cnt   = csl_err_cnt_inner + 1'b1 ;
        else
            csl_err_cnt   = csl_err_cnt_inner ;
    end
    else if(FSM_CS == RD_PART7_ADDR) begin
        if(csl_scan_row_part7_single_done) 
            csl_err_cnt   =  5'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part7_start_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            csl_err_cnt   =  5'h0   ;
        else if(csl_scan_rvalid && rdata_diff_flag && (csl_err_cnt_inner<csl_err_threshold))
            csl_err_cnt   = csl_err_cnt_inner + 1'b1 ;
        else
            csl_err_cnt   = csl_err_cnt_inner ;
    end
    else if(FSM_CS == RD_PART8_ADDR) begin
        if(csl_scan_row_part8_single_done) 
            csl_err_cnt   =  5'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part8_start_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            csl_err_cnt   =  5'h0   ;
        else if(csl_scan_rvalid && rdata_diff_flag && (csl_err_cnt_inner<csl_err_threshold))
            csl_err_cnt   = csl_err_cnt_inner + 1'b1 ;
        else
            csl_err_cnt   = csl_err_cnt_inner ;
    end
    else if(FSM_CS == RD_PART9_ADDR) begin
        if(csl_scan_row_part9_single_done) 
            csl_err_cnt   =  5'h0   ;
        else if(frame_data_send_row_addr==csl_scan_row_part9_start_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            csl_err_cnt   =  5'h0   ;
        else if(csl_scan_rvalid && rdata_diff_flag && (csl_err_cnt_inner<csl_err_threshold))
            csl_err_cnt   = csl_err_cnt_inner + 1'b1 ;
        else
            csl_err_cnt   = csl_err_cnt_inner ;
    end

    else begin
            csl_err_cnt   = csl_err_cnt_inner ;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        csl_err_cnt_inner   <=  5'h0        ;
    end
    else begin
        csl_err_cnt_inner   <= csl_err_cnt  ;
    end
end
//part0
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part0      <=  8'hFF ;
        err_csl1_part0      <=  8'hFF ;
        err_csl2_part0_flag <=  1'b0  ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part0      <=  8'hFF ;
        err_csl1_part0      <=  8'hFF ;
        err_csl2_part0_flag <=  1'b0  ;        
        
    end
    else if(FSM_CS == RD_PART0_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part0==8'hFF && err_csl1_part0==8'hFF) begin 
            err_csl0_part0      <=  receive_col_addr   ;
            err_csl1_part0      <=  err_csl1_part0     ;
            err_csl2_part0_flag <=  1'b0               ;            
        end
        else if(err_csl0_part0!=receive_col_addr && err_csl1_part0==8'hFF) begin 
            err_csl0_part0      <=  err_csl0_part0     ;
            err_csl1_part0      <=  receive_col_addr   ;
            err_csl2_part0_flag <=  1'b0               ;
        end
        else if(err_csl1_part0!=8'hFF && err_csl0_part0!=receive_col_addr && err_csl1_part0!=receive_col_addr)begin
            err_csl0_part0      <=  err_csl0_part0     ;
            err_csl1_part0      <=  err_csl1_part0     ;
            err_csl2_part0_flag <=  1'b1               ;
        end
    end
end
//part1
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part1      <=  8'hFF ;
        err_csl1_part1      <=  8'hFF ;
        err_csl2_part1_flag <=  1'b0  ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part1      <=  8'hFF ;
        err_csl1_part1      <=  8'hFF ;
        err_csl2_part1_flag <=  1'b0  ;        
        
    end
    else if(FSM_CS == RD_PART1_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part1==8'hFF && err_csl1_part1==8'hFF) begin 
            err_csl0_part1      <=  receive_col_addr   ;
            err_csl1_part1      <=  err_csl1_part1     ;
            err_csl2_part1_flag <=  1'b0               ;            
        end
        else if(err_csl0_part1!=receive_col_addr && err_csl1_part1==8'hFF) begin 
            err_csl0_part1      <=  err_csl0_part1     ;
            err_csl1_part1      <=  receive_col_addr   ;
            err_csl2_part1_flag <=  1'b0               ;
        end
        else if(err_csl1_part1!=8'hFF && err_csl0_part1!=receive_col_addr && err_csl1_part1!=receive_col_addr)begin
            err_csl0_part1      <=  err_csl0_part1     ;
            err_csl1_part1      <=  err_csl1_part1     ;
            err_csl2_part1_flag <=  1'b1               ;
        end
    end
end

//part2
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part2      <=  8'hFF ;
        err_csl1_part2      <=  8'hFF ;
        err_csl2_part2_flag <=  1'b0  ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part2      <=  8'hFF ;
        err_csl1_part2      <=  8'hFF ;
        err_csl2_part2_flag <=  1'b0  ;        
        
    end
    else if(FSM_CS == RD_PART2_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part2==8'hFF && err_csl1_part2==8'hFF) begin 
            err_csl0_part2      <=  receive_col_addr   ;
            err_csl1_part2      <=  err_csl1_part2     ;
            err_csl2_part2_flag <=  1'b0               ;            
        end
        else if(err_csl0_part2!=receive_col_addr && err_csl1_part2==8'hFF) begin 
            err_csl0_part2      <=  err_csl0_part2     ;
            err_csl1_part2      <=  receive_col_addr   ;
            err_csl2_part2_flag <=  1'b0               ;
        end
        else if(err_csl1_part2!=8'hFF && err_csl0_part2!=receive_col_addr && err_csl1_part2!=receive_col_addr)begin
            err_csl0_part2      <=  err_csl0_part2     ;
            err_csl1_part2      <=  err_csl1_part2     ;
            err_csl2_part2_flag <=  1'b1               ;
        end
    end
end

//part3
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part3      <=  8'hFF ;
        err_csl1_part3      <=  8'hFF ;
        err_csl2_part3_flag <=  1'b0  ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part3      <=  8'hFF ;
        err_csl1_part3      <=  8'hFF ;
        err_csl2_part3_flag <=  1'b0  ;        
        
    end
    else if(FSM_CS == RD_PART3_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part3==8'hFF && err_csl1_part3==8'hFF) begin 
            err_csl0_part3      <=  receive_col_addr   ;
            err_csl1_part3      <=  err_csl1_part3     ;
            err_csl2_part3_flag <=  1'b0               ;            
        end
        else if(err_csl0_part3!=receive_col_addr && err_csl1_part3==8'hFF) begin 
            err_csl0_part3      <=  err_csl0_part3     ;
            err_csl1_part3      <=  receive_col_addr   ;
            err_csl2_part3_flag <=  1'b0               ;
        end
        else if(err_csl1_part3!=8'hFF && err_csl0_part3!=receive_col_addr && err_csl1_part3!=receive_col_addr)begin
            err_csl0_part3      <=  err_csl0_part3     ;
            err_csl1_part3      <=  err_csl1_part3     ;
            err_csl2_part3_flag <=  1'b1               ;
        end
    end
end
//part4
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part4      <=  8'hFF ;
        err_csl1_part4      <=  8'hFF ;
        err_csl2_part4_flag <= 1'b0   ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part4      <=  8'hFF ;
        err_csl1_part4      <=  8'hFF ;
        err_csl2_part4_flag <= 1'b0   ;
    end
    else if(FSM_CS == RD_PART4_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part4==8'hFF && err_csl1_part4==8'hFF) begin 
            err_csl0_part4      <=  receive_col_addr   ;
            err_csl1_part4      <=  err_csl1_part4     ;
            err_csl2_part4_flag <=  1'b0               ;
        end
        else if(err_csl0_part4!=receive_col_addr && err_csl1_part4==8'hFF) begin 
            err_csl0_part4      <=  err_csl0_part4     ;
            err_csl1_part4      <=  receive_col_addr   ;
            err_csl2_part4_flag <=  1'b0               ;
        end
        else if(err_csl1_part4!=8'hFF && err_csl0_part4!=receive_col_addr && err_csl1_part4!=receive_col_addr)begin
            err_csl0_part4      <=  err_csl0_part4     ;
            err_csl1_part4      <=  err_csl1_part4     ;
            err_csl2_part4_flag <= 1'b1                ;
        end

    end
end
//part5
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part5      <=  8'hFF ;
        err_csl1_part5      <=  8'hFF ;
        err_csl2_part5_flag <= 1'b0   ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part5      <=  8'hFF ;
        err_csl1_part5      <=  8'hFF ;
        err_csl2_part5_flag <= 1'b0   ;
    end
    else if(FSM_CS == RD_PART5_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part5==8'hFF && err_csl1_part5==8'hFF) begin 
            err_csl0_part5      <=  receive_col_addr   ;
            err_csl1_part5      <=  err_csl1_part5     ;
            err_csl2_part5_flag <=  1'b0               ;
        end
        else if(err_csl0_part5!=receive_col_addr && err_csl1_part5==8'hFF) begin 
            err_csl0_part5      <=  err_csl0_part5     ;
            err_csl1_part5      <=  receive_col_addr   ;
            err_csl2_part5_flag <=  1'b0               ;
        end
        else if(err_csl1_part5!=8'hFF && err_csl0_part5!=receive_col_addr && err_csl1_part5!=receive_col_addr)begin
            err_csl0_part5      <=  err_csl0_part5     ;
            err_csl1_part5      <=  err_csl1_part5     ;
            err_csl2_part5_flag <= 1'b1                ;
        end

    end
end
//part6
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part6      <=  8'hFF ;
        err_csl1_part6      <=  8'hFF ;
        err_csl2_part6_flag <= 1'b0   ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part6      <=  8'hFF ;
        err_csl1_part6      <=  8'hFF ;
        err_csl2_part6_flag <= 1'b0   ;
    end
    else if(FSM_CS == RD_PART6_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part6==8'hFF && err_csl1_part6==8'hFF) begin 
            err_csl0_part6      <=  receive_col_addr   ;
            err_csl1_part6      <=  err_csl1_part6     ;
            err_csl2_part6_flag <=  1'b0               ;
        end
        else if(err_csl0_part6!=receive_col_addr && err_csl1_part6==8'hFF) begin 
            err_csl0_part6      <=  err_csl0_part6     ;
            err_csl1_part6      <=  receive_col_addr   ;
            err_csl2_part6_flag <=  1'b0               ;
        end
        else if(err_csl1_part6!=8'hFF && err_csl0_part6!=receive_col_addr && err_csl1_part6!=receive_col_addr)begin
            err_csl0_part6      <=  err_csl0_part6     ;
            err_csl1_part6      <=  err_csl1_part6     ;
            err_csl2_part6_flag <= 1'b1                ;
        end

    end
end
//part7
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part7      <=  8'hFF ;
        err_csl1_part7      <=  8'hFF ;
        err_csl2_part7_flag <= 1'b0   ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part7      <=  8'hFF ;
        err_csl1_part7      <=  8'hFF ;
        err_csl2_part7_flag <= 1'b0   ;
    end
    else if(FSM_CS == RD_PART7_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part7==8'hFF && err_csl1_part7==8'hFF) begin 
            err_csl0_part7      <=  receive_col_addr   ;
            err_csl1_part7      <=  err_csl1_part7     ;
            err_csl2_part7_flag <=  1'b0               ;
        end
        else if(err_csl0_part7!=receive_col_addr && err_csl1_part7==8'hFF) begin 
            err_csl0_part7      <=  err_csl0_part7     ;
            err_csl1_part7      <=  receive_col_addr   ;
            err_csl2_part7_flag <=  1'b0               ;
        end
        else if(err_csl1_part7!=8'hFF && err_csl0_part7!=receive_col_addr && err_csl1_part7!=receive_col_addr)begin
            err_csl0_part7      <=  err_csl0_part7     ;
            err_csl1_part7      <=  err_csl1_part7     ;
            err_csl2_part7_flag <= 1'b1                ;
        end

    end
end
//part8
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part8      <=  8'hFF ;
        err_csl1_part8      <=  8'hFF ;
        err_csl2_part8_flag <= 1'b0   ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part8      <=  8'hFF ;
        err_csl1_part8      <=  8'hFF ;
        err_csl2_part8_flag <= 1'b0   ;
    end
    else if(FSM_CS == RD_PART8_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part8==8'hFF && err_csl1_part8==8'hFF) begin 
            err_csl0_part8      <=  receive_col_addr   ;
            err_csl1_part8      <=  err_csl1_part8     ;
            err_csl2_part8_flag <=  1'b0               ;
        end
        else if(err_csl0_part8!=receive_col_addr && err_csl1_part8==8'hFF) begin 
            err_csl0_part8      <=  err_csl0_part8     ;
            err_csl1_part8      <=  receive_col_addr   ;
            err_csl2_part8_flag <=  1'b0               ;
        end
        else if(err_csl1_part8!=8'hFF && err_csl0_part8!=receive_col_addr && err_csl1_part8!=receive_col_addr)begin
            err_csl0_part8      <=  err_csl0_part8     ;
            err_csl1_part8      <=  err_csl1_part8     ;
            err_csl2_part8_flag <= 1'b1                ;
        end

    end
end
//part9
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part9      <=  8'hFF ;
        err_csl1_part9      <=  8'hFF ;
        err_csl2_part9_flag <= 1'b0   ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part9      <=  8'hFF ;
        err_csl1_part9      <=  8'hFF ;
        err_csl2_part9_flag <= 1'b0   ;
    end
    else if(FSM_CS == RD_PART9_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part9==8'hFF && err_csl1_part9==8'hFF) begin 
            err_csl0_part9      <=  receive_col_addr   ;
            err_csl1_part9      <=  err_csl1_part9     ;
            err_csl2_part9_flag <=  1'b0               ;
        end
        else if(err_csl0_part9!=receive_col_addr && err_csl1_part9==8'hFF) begin 
            err_csl0_part9      <=  err_csl0_part9     ;
            err_csl1_part9      <=  receive_col_addr   ;
            err_csl2_part9_flag <=  1'b0               ;
        end
        else if(err_csl1_part9!=8'hFF && err_csl0_part9!=receive_col_addr && err_csl1_part9!=receive_col_addr)begin
            err_csl0_part9      <=  err_csl0_part9     ;
            err_csl1_part9      <=  err_csl1_part9     ;
            err_csl2_part9_flag <= 1'b1                ;
        end

    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        csl_scan_row_part0_status_r <= 1'b0;
        csl_scan_row_part1_status_r <= 1'b0;
        csl_scan_row_part2_status_r <= 1'b0;
        csl_scan_row_part3_status_r <= 1'b0;
        csl_scan_row_part4_status_r <= 1'b0;
        csl_scan_row_part5_status_r <= 1'b0;
        csl_scan_row_part6_status_r <= 1'b0;
        csl_scan_row_part7_status_r <= 1'b0;
        csl_scan_row_part8_status_r <= 1'b0;
        csl_scan_row_part9_status_r <= 1'b0;
    end
    else begin
        csl_scan_row_part0_status_r <= csl_scan_row_part0_status;
        csl_scan_row_part1_status_r <= csl_scan_row_part1_status;
        csl_scan_row_part2_status_r <= csl_scan_row_part2_status;
        csl_scan_row_part3_status_r <= csl_scan_row_part3_status;
        csl_scan_row_part4_status_r <= csl_scan_row_part4_status;
        csl_scan_row_part5_status_r <= csl_scan_row_part5_status;
        csl_scan_row_part6_status_r <= csl_scan_row_part6_status;
        csl_scan_row_part7_status_r <= csl_scan_row_part7_status;
        csl_scan_row_part8_status_r <= csl_scan_row_part8_status;
        csl_scan_row_part9_status_r <= csl_scan_row_part9_status;

    end
end


assign csl_scan_row_part0_status_pos = csl_scan_row_part0_status && !csl_scan_row_part0_status_r ;
assign csl_scan_row_part1_status_pos = csl_scan_row_part1_status && !csl_scan_row_part1_status_r ;
assign csl_scan_row_part2_status_pos = csl_scan_row_part2_status && !csl_scan_row_part2_status_r ;
assign csl_scan_row_part3_status_pos = csl_scan_row_part3_status && !csl_scan_row_part3_status_r ;
assign csl_scan_row_part4_status_pos = csl_scan_row_part4_status && !csl_scan_row_part4_status_r ;
assign csl_scan_row_part5_status_pos = csl_scan_row_part5_status && !csl_scan_row_part5_status_r ;
assign csl_scan_row_part6_status_pos = csl_scan_row_part6_status && !csl_scan_row_part6_status_r ;
assign csl_scan_row_part7_status_pos = csl_scan_row_part7_status && !csl_scan_row_part7_status_r ;
assign csl_scan_row_part8_status_pos = csl_scan_row_part8_status && !csl_scan_row_part8_status_r ;
assign csl_scan_row_part9_status_pos = csl_scan_row_part9_status && !csl_scan_row_part9_status_r ;

assign csl_scan_row_part0_status = (err_csl0_part0!=8'hFF) && (err_csl1_part0!=8'hFF) && err_csl2_part0_flag;
assign csl_scan_row_part1_status = (err_csl0_part1!=8'hFF) && (err_csl1_part1!=8'hFF) && err_csl2_part1_flag;
assign csl_scan_row_part2_status = (err_csl0_part2!=8'hFF) && (err_csl1_part2!=8'hFF) && err_csl2_part2_flag;
assign csl_scan_row_part3_status = (err_csl0_part3!=8'hFF) && (err_csl1_part3!=8'hFF) && err_csl2_part3_flag;
assign csl_scan_row_part4_status = (err_csl0_part4!=8'hFF) && (err_csl1_part4!=8'hFF) && err_csl2_part4_flag;
assign csl_scan_row_part5_status = (err_csl0_part5!=8'hFF) && (err_csl1_part5!=8'hFF) && err_csl2_part5_flag;
assign csl_scan_row_part6_status = (err_csl0_part6!=8'hFF) && (err_csl1_part6!=8'hFF) && err_csl2_part6_flag;
assign csl_scan_row_part7_status = (err_csl0_part7!=8'hFF) && (err_csl1_part7!=8'hFF) && err_csl2_part7_flag;
assign csl_scan_row_part8_status = (err_csl0_part8!=8'hFF) && (err_csl1_part8!=8'hFF) && err_csl2_part8_flag;
assign csl_scan_row_part9_status = (err_csl0_part9!=8'hFF) && (err_csl1_part9!=8'hFF) && err_csl2_part9_flag;

//assign csl_scan_row_part0_single_done = ((!csl_scan_row_part0_status && receive_row_addr == csl_scan_row_part0_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part0_status_pos) ;
//
//assign csl_scan_row_part1_single_done = ((!csl_scan_row_part1_status && receive_row_addr == csl_scan_row_part1_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part1_status_pos) ;
//
//assign csl_scan_row_part2_single_done = ((!csl_scan_row_part2_status && receive_row_addr == csl_scan_row_part2_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part2_status_pos) ;
//
//assign csl_scan_row_part3_single_done = ((!csl_scan_row_part3_status && receive_row_addr == csl_scan_row_part3_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part3_status_pos) ;
//
//assign csl_scan_row_part4_single_done = ((!csl_scan_row_part4_status && receive_row_addr == csl_scan_row_part4_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part4_status_pos) ;

//azy
assign csl_scan_row_part0_single_done_pre = ((!csl_scan_row_part0_status && receive_row_addr == csl_scan_row_part0_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part0_status_pos) ;

assign csl_scan_row_part1_single_done_pre = ((!csl_scan_row_part1_status && receive_row_addr == csl_scan_row_part1_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part1_status_pos) ;

assign csl_scan_row_part2_single_done_pre = ((!csl_scan_row_part2_status && receive_row_addr == csl_scan_row_part2_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part2_status_pos) ;

assign csl_scan_row_part3_single_done_pre = ((!csl_scan_row_part3_status && receive_row_addr == csl_scan_row_part3_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part3_status_pos) ;

assign csl_scan_row_part4_single_done_pre = ((!csl_scan_row_part4_status && receive_row_addr == csl_scan_row_part4_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part4_status_pos) ;

assign csl_scan_row_part5_single_done_pre = ((!csl_scan_row_part5_status && receive_row_addr == csl_scan_row_part5_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part5_status_pos) ;

assign csl_scan_row_part6_single_done_pre = ((!csl_scan_row_part6_status && receive_row_addr == csl_scan_row_part6_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part6_status_pos) ;

assign csl_scan_row_part7_single_done_pre = ((!csl_scan_row_part7_status && receive_row_addr == csl_scan_row_part7_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part7_status_pos) ;

assign csl_scan_row_part8_single_done_pre = ((!csl_scan_row_part8_status && receive_row_addr == csl_scan_row_part8_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part8_status_pos) ;

assign csl_scan_row_part9_single_done_pre = ((!csl_scan_row_part9_status && receive_row_addr == csl_scan_row_part9_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part9_status_pos) ;



always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        csl_scan_row_part0_single_done <=  1'b0 ;                           
        csl_scan_row_part1_single_done <=  1'b0 ;                            
        csl_scan_row_part2_single_done <=  1'b0 ;                              
        csl_scan_row_part3_single_done <=  1'b0 ;                               
        csl_scan_row_part4_single_done <=  1'b0 ;
        csl_scan_row_part5_single_done <=  1'b0 ;                           
        csl_scan_row_part6_single_done <=  1'b0 ;                            
        csl_scan_row_part7_single_done <=  1'b0 ;                              
        csl_scan_row_part8_single_done <=  1'b0 ;                               
        csl_scan_row_part9_single_done <=  1'b0 ;

    end
    else begin
        csl_scan_row_part0_single_done <=  csl_scan_row_part0_single_done_pre ;                         
        csl_scan_row_part1_single_done <=  csl_scan_row_part1_single_done_pre ;                          
        csl_scan_row_part2_single_done <=  csl_scan_row_part2_single_done_pre ;                            
        csl_scan_row_part3_single_done <=  csl_scan_row_part3_single_done_pre ;                             
        csl_scan_row_part4_single_done <=  csl_scan_row_part4_single_done_pre ;
        csl_scan_row_part5_single_done <=  csl_scan_row_part5_single_done_pre ;                         
        csl_scan_row_part6_single_done <=  csl_scan_row_part6_single_done_pre ;                          
        csl_scan_row_part7_single_done <=  csl_scan_row_part7_single_done_pre ;                            
        csl_scan_row_part8_single_done <=  csl_scan_row_part8_single_done_pre ;                             
        csl_scan_row_part9_single_done <=  csl_scan_row_part9_single_done_pre ;

    end
end
//azy

assign csl_single_pattern_done = (csl_scan_row_part0_single_done && csl_scan_row_part0_status) ||
                                 (csl_scan_row_part1_single_done && csl_scan_row_part1_status) ||
                                 (csl_scan_row_part2_single_done && csl_scan_row_part2_status) ||
                                 (csl_scan_row_part3_single_done && csl_scan_row_part3_status) ||
                                 (csl_scan_row_part4_single_done && csl_scan_row_part4_status) ||
                                 (csl_scan_row_part5_single_done && csl_scan_row_part5_status) ||
                                 (csl_scan_row_part6_single_done && csl_scan_row_part6_status) ||
                                 (csl_scan_row_part7_single_done && csl_scan_row_part7_status) ||
                                 (csl_scan_row_part8_single_done && csl_scan_row_part8_status) ||
                                 csl_scan_row_part9_single_done;


assign csl_scan_success_status = !csl_scan_row_part0_status && !csl_scan_row_part1_status && !csl_scan_row_part2_status && !csl_scan_row_part3_status && !csl_scan_row_part4_status && !csl_scan_row_part5_status && !csl_scan_row_part6_status && !csl_scan_row_part7_status && !csl_scan_row_part8_status && !csl_scan_row_part9_status ;
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        csl_scan_finish   <=  1'b0   ;
    end
    else if(csl_scan_num_cnt_status==bist_csl_scan_num && !csl_scan_finish && csl_scan_success_status && csl_single_pattern_done) begin
        csl_scan_finish   <= 1'b1   ;
    end
    else begin
        csl_scan_finish   <= 1'b0    ;
    end
end

assign csl_scan_working = FSM_CS != IDLE ;
assign csl_scan_fail_status = err_csl2_part0_flag || err_csl2_part1_flag || err_csl2_part2_flag || err_csl2_part3_flag || err_csl2_part4_flag || 
                              err_csl2_part5_flag || err_csl2_part6_flag || err_csl2_part7_flag || err_csl2_part8_flag || err_csl2_part9_flag ;
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        csl_scan_fail <= 1'b0;
    else if(bist_finish_clr || global_mc_bist_start)
        csl_scan_fail <= 1'b0;
    else if(csl_scan_fail_status && csl_single_pattern_done)
        csl_scan_fail <= 1'b1;
end
endmodule
