module csl_scan_aux #(
    parameter   ARRAY_ADDR_WIDTH      = 13+8                               ,
    parameter   ARRAY_COL_ADDR_WIDTH  = 8                                  ,
    parameter   ARRAY_ROW_ADDR_WIDTH  = 13                                 ,
    parameter   CHECKBIT_WIDTH        = 16                                 ,
    parameter   ARRAY_DATA_WIDTH      = 256  
)(
  //-------------clock and reset signal--------------
  input                                                                   clk                  ,
  input                                                                   rst_n                ,
  //-------------control signal----------------------                    
  input      [1:0]                                                        bist_layer_id        ,  
  input                                                                   global_mc_bist_start ,
  input                                                                   global_mc_bist_en    ,
  input                                                                   csl_scan_addr_range_sel,//default 1,scan all addr
  input                                                                   csl_scan_check_sel    ,//default 1,check 272 bits rdata
  input                                                                   csl_scan_mode_sel     ,//0:abort 1:continue,default 0
  input                                                                   mc_bist_en            ,
  input                                                                   bank_scan_finish      ,
  input                                                                   bist_finish_clr       ,
  input      [4:0]                                                        csl_err_threshold     ,
  output reg                                                              csl_scan_finish       ,
  output reg                                                              csl_scan_fail         ,
  output                                                                  csl_scan_working      ,
  input      [68*32-1:0]                                                  bist_pattern_all      ,
  input      [67:0]                                                       csl_bist_pattern_sel  ,

  //-------------data signal------------------------
  output reg                                                              csl_scan_frame_vld    ,
  input                                                                   csl_scan_frame_rdy    ,
  output     [3+CHECKBIT_WIDTH+ARRAY_DATA_WIDTH+ARRAY_ADDR_WIDTH+2-1 :0]  csl_scan_frame_data   ,//rw_flag,sof,eof,data,row,col
  input                                                                   csl_scan_rvalid       ,
  input      [CHECKBIT_WIDTH+ARRAY_DATA_WIDTH-1:0]                        csl_scan_rdata        ,
  //-------------error csl record signal------------
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl0_part0        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl1_part0        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl0_part1        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl1_part1        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl0_part2        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl1_part2        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl0_part3        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl1_part3        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl0_part4        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl1_part4        ,

  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl0_part5        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl1_part5        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl0_part6        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl1_part6        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl0_part7        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl1_part7        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl0_part8        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl1_part8        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl0_part9        ,
  output reg [ARRAY_COL_ADDR_WIDTH-1:0]                                   err_csl1_part9        



);


//wire and reg

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
reg    [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]     frame_data                     ;
reg    [ARRAY_COL_ADDR_WIDTH-1:0]                frame_data_send_col_addr       ;
reg    [ARRAY_ROW_ADDR_WIDTH-1:0]                frame_data_send_row_addr       ;
reg    [ARRAY_COL_ADDR_WIDTH-1:0]                receive_col_addr               ;
reg    [ARRAY_ROW_ADDR_WIDTH-1:0]                receive_row_addr               ;

reg    [4:0]                                     data_noback_req_cnt            ; //data no back, read request cnt


reg    [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]     frame_golden_data              ;
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


wire   [ARRAY_COL_ADDR_WIDTH-1:0]                col_end_addr                   ;
wire                                             rdata_diff_flag                ;
wire                                             csl_scan_success_status        ;
wire                                             csl_scan_fail_status           ;
wire   [6:0]                                     bist_csl_scan_num              ;
//--------------------------------------------------
//assign  csl_scan_row_up_start_addr   =  14'h0    ;
/////////////assign  csl_scan_row_up_end_addr     =  13'hE60 - 1'b1 ;//7360/2-1,
/////////////assign  csl_scan_row_down_start_addr =  13'hE60 ;//7360
/////////////assign  csl_scan_row_down_end_addr   =  13'h1CC0 - 1'b1 ;//7359

wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part0_end_addr    ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part1_start_addr  ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part1_end_addr    ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part2_start_addr  ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part2_end_addr    ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part3_start_addr  ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part3_end_addr    ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part4_start_addr  ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part4_end_addr    ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part5_start_addr  ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part5_end_addr    ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part6_start_addr  ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part6_end_addr    ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part7_start_addr  ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part7_end_addr    ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part8_start_addr  ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part8_end_addr    ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part9_start_addr  ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                csl_scan_row_part9_end_addr    ;

reg    [3:0]                                     FSM_CS                         ;
reg    [3:0]                                     FSM_NS                         ;

reg    [6:0]                                     pattern_index                  ;
reg    [6:0]                                     pattern_index_reg              ;

reg    [6:0]                                     csl_pattern_cnt                ;
reg    [67:0]                                    csl_bist_pattern_sel_new       ;
integer                                          JJ                             ;
integer                                          KK                             ;
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



always @(*)begin
    csl_pattern_cnt = 7'h0;
    for(JJ=0;JJ<68;JJ=JJ+1)begin:gen_csl_pattern_cnt
        if(csl_bist_pattern_sel[JJ]==1'b1)begin
            csl_pattern_cnt = csl_pattern_cnt + 1'b1;
        end
    end
end


assign  bist_csl_scan_num = csl_pattern_cnt ;


always @(*)begin
    pattern_index = 7'h0;
    if((FSM_CS==IDLE && FSM_NS==WR_ADDR) || (csl_single_pattern_done)) begin
        for(KK=68;KK>0;KK=KK-1)begin:gen_pattern_index
            if(csl_bist_pattern_sel_new[KK-1]==1'b1)
                pattern_index = KK-1;
        end       
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        csl_bist_pattern_sel_new <= 68'h0;
    else if(FSM_NS==IDLE)
        csl_bist_pattern_sel_new <= csl_bist_pattern_sel ;
    else if((FSM_CS==IDLE && FSM_NS==WR_ADDR) || csl_single_pattern_done)
        csl_bist_pattern_sel_new <= csl_bist_pattern_sel_new ^ (1'b1 << pattern_index);
end




always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        pattern_index_reg <= 7'h0;
    else if((FSM_CS==IDLE && FSM_NS==WR_ADDR) || csl_single_pattern_done)
        pattern_index_reg <= pattern_index;
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    FSM_CS <= IDLE ;
  end
  else begin
    FSM_CS <= FSM_NS ;
  end
end

always @(*)begin
    if(csl_scan_mode_sel)begin//3 csl error continue scan
        case(FSM_CS)
        IDLE: begin
          if (bank_scan_finish && global_mc_bist_en && mc_bist_en)
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
            if(csl_scan_row_part0_single_done)
              FSM_NS = RD_PART1_ADDR;  
            else
              FSM_NS = FSM_CS;
        end
        RD_PART1_ADDR : begin
            if(csl_scan_row_part1_single_done)// 3 csl err
              FSM_NS = RD_PART2_ADDR;
            else
              FSM_NS = FSM_CS;
        end
        RD_PART2_ADDR : begin
            if(csl_scan_row_part2_single_done)// 3 csl err
              FSM_NS = RD_PART3_ADDR;
            else
              FSM_NS = FSM_CS;
          end
        RD_PART3_ADDR : begin
            if(csl_scan_row_part3_single_done)// 3 csl err
              FSM_NS = RD_PART4_ADDR;
            else
              FSM_NS = FSM_CS;
        end
        RD_PART4_ADDR : begin
            if(csl_scan_row_part4_single_done)// 3 csl err
              FSM_NS = RD_PART5_ADDR;
            else
              FSM_NS = FSM_CS;
        end
        RD_PART5_ADDR : begin
            if(csl_scan_row_part5_single_done)// 3 csl err
              FSM_NS = RD_PART6_ADDR;
            else
              FSM_NS = FSM_CS;
        end
        RD_PART6_ADDR : begin
            if(csl_scan_row_part6_single_done)// 3 csl err
              FSM_NS = RD_PART7_ADDR;
            else
              FSM_NS = FSM_CS;
        end
        RD_PART7_ADDR : begin
            if(csl_scan_row_part7_single_done)// 3 csl err
              FSM_NS = RD_PART8_ADDR;
            else
              FSM_NS = FSM_CS;
        end
        RD_PART8_ADDR : begin
            if(csl_scan_row_part8_single_done)// 3 csl err
              FSM_NS = RD_PART9_ADDR;
            else
              FSM_NS = FSM_CS;
        end
        RD_PART9_ADDR : begin
            if(csl_scan_row_part9_single_done && csl_scan_num_cnt_allow)
              FSM_NS = WR_ADDR;
            else if(csl_scan_row_part9_single_done && !csl_scan_num_cnt_allow)//all pattern done
              FSM_NS = IDLE;
            else
              FSM_NS = FSM_CS;
        end
        default: FSM_NS = IDLE;
    endcase
    end
    else begin//3 err csl abort scan
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
end
//----------------------------------------------------------------------------
assign csl_scan_frame_data = {frame_data_rw_flag,frame_data_sof,frame_data_eof,frame_data,bist_layer_id,frame_data_send_row_addr,frame_data_send_col_addr} ;

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
        else if((frame_data_send_row_addr==csl_scan_row_part0_end_addr && frame_data_send_col_addr == col_end_addr && csl_scan_frame_rdy) || (csl_scan_row_part0_status && !csl_scan_mode_sel))
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART1_ADDR) begin
        if(!csl_scan_row_part1_status &&(frame_data_send_row_addr!=csl_scan_row_part1_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part1_end_addr && frame_data_send_col_addr == col_end_addr && csl_scan_frame_rdy) || (csl_scan_row_part1_status && !csl_scan_mode_sel))
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART2_ADDR) begin
        if(!csl_scan_row_part2_status &&(frame_data_send_row_addr!=csl_scan_row_part2_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part2_end_addr && frame_data_send_col_addr == col_end_addr && csl_scan_frame_rdy) || (csl_scan_row_part2_status && !csl_scan_mode_sel))
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART3_ADDR) begin
        if(!csl_scan_row_part3_status &&(frame_data_send_row_addr!=csl_scan_row_part3_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part3_end_addr && frame_data_send_col_addr == col_end_addr && csl_scan_frame_rdy) || (csl_scan_row_part3_status && !csl_scan_mode_sel))
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART4_ADDR) begin
        if(!csl_scan_row_part4_status && (frame_data_send_row_addr!=csl_scan_row_part4_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part4_end_addr && frame_data_send_col_addr==col_end_addr && csl_scan_frame_rdy) || (csl_scan_row_part4_status && !csl_scan_mode_sel))
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART5_ADDR) begin
        if(!csl_scan_row_part5_status && (frame_data_send_row_addr!=csl_scan_row_part5_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part5_end_addr && frame_data_send_col_addr==col_end_addr && csl_scan_frame_rdy) || (csl_scan_row_part5_status && !csl_scan_mode_sel))
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART6_ADDR) begin
        if(!csl_scan_row_part6_status && (frame_data_send_row_addr!=csl_scan_row_part6_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part6_end_addr && frame_data_send_col_addr==col_end_addr && csl_scan_frame_rdy) || (csl_scan_row_part6_status && !csl_scan_mode_sel))
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART7_ADDR) begin
        if(!csl_scan_row_part7_status && (frame_data_send_row_addr!=csl_scan_row_part7_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part7_end_addr && frame_data_send_col_addr==col_end_addr && csl_scan_frame_rdy) || (csl_scan_row_part7_status && !csl_scan_mode_sel))
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART8_ADDR) begin
        if(!csl_scan_row_part8_status && (frame_data_send_row_addr!=csl_scan_row_part8_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part8_end_addr && frame_data_send_col_addr==col_end_addr && csl_scan_frame_rdy) || (csl_scan_row_part8_status && !csl_scan_mode_sel))
            csl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==RD_PART9_ADDR) begin
        if(!csl_scan_row_part9_status && (frame_data_send_row_addr!=csl_scan_row_part9_end_addr || frame_data_send_col_addr!=col_end_addr))
            csl_scan_frame_vld   <=  1'b1   ;
        else if((frame_data_send_row_addr==csl_scan_row_part9_end_addr && frame_data_send_col_addr==col_end_addr && csl_scan_frame_rdy) || (csl_scan_row_part9_status && !csl_scan_mode_sel))
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
        frame_data  <=  {CHECKBIT_WIDTH+ARRAY_DATA_WIDTH{1'h0}} ;
    end
    else if(FSM_CS == WR_ADDR) begin
        if(frame_data_send_row_addr[1:0]==2'b00)
        frame_data  <=  {34{bist_pattern_all[(pattern_index_reg*32+0)+:8]}} ;
        else if(frame_data_send_row_addr[1:0]==2'b01)
        frame_data  <=  {34{bist_pattern_all[(pattern_index_reg*32+8)+:8]}} ;
        else if(frame_data_send_row_addr[1:0]==2'b10)
        frame_data  <=  {34{bist_pattern_all[(pattern_index_reg*32+16)+:8]}} ;
        else if(frame_data_send_row_addr[1:0]==2'b11)
        frame_data  <=  {34{bist_pattern_all[(pattern_index_reg*32+24)+:8]}} ;
    end
    else
        frame_data  <= {CHECKBIT_WIDTH+ARRAY_DATA_WIDTH{1'h0}} ;
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        frame_data_send_col_addr  <=  {ARRAY_COL_ADDR_WIDTH{1'h0}} ;
    end
    else if(global_mc_bist_start)
        frame_data_send_col_addr   <=   {ARRAY_COL_ADDR_WIDTH{1'h0}}  ;
    else if(FSM_CS == WR_ADDR) begin
        if(frame_data_send_col_addr == col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART0_ADDR) begin
        if(csl_scan_row_part0_single_done) 
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part0_end_addr && frame_data_send_col_addr!=col_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART1_ADDR) begin
        if(csl_scan_row_part1_single_done) 
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part1_end_addr && frame_data_send_col_addr!=col_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART2_ADDR) begin
        if(csl_scan_row_part2_single_done) 
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part2_end_addr && frame_data_send_col_addr!=col_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART3_ADDR) begin
        if(csl_scan_row_part3_single_done) 
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part3_end_addr && frame_data_send_col_addr!=col_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end    
    else if(FSM_CS == RD_PART4_ADDR) begin
        if(csl_scan_row_part4_single_done) 
            frame_data_send_col_addr   <= {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part4_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART5_ADDR) begin
        if(csl_scan_row_part5_single_done) 
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part5_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART6_ADDR) begin
        if(csl_scan_row_part6_single_done) 
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part6_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART7_ADDR) begin
        if(csl_scan_row_part7_single_done) 
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part7_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART8_ADDR) begin
        if(csl_scan_row_part8_single_done) 
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part8_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
        end
    else if(FSM_CS == RD_PART9_ADDR) begin
        if(csl_scan_row_part9_single_done) 
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part9_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        frame_data_send_row_addr  <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}} ;
    end
    else if(global_mc_bist_start)
        frame_data_send_row_addr  <= {ARRAY_ROW_ADDR_WIDTH{1'h0}}  ;
    else if(FSM_CS == WR_ADDR) begin
        if(frame_data_send_row_addr==csl_scan_row_part9_end_addr && frame_data_send_col_addr == col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}  ;
        else if(frame_data_send_col_addr == col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART0_ADDR) begin
        if(csl_scan_row_part0_single_done && !csl_scan_row_part0_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part1_start_addr   ;
        else if(csl_scan_row_part0_single_done && csl_scan_row_part0_status && !csl_scan_mode_sel) 
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part0_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr!=csl_scan_row_part0_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART1_ADDR) begin
        if(csl_scan_row_part1_single_done && !csl_scan_row_part1_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part2_start_addr   ;
        else if(csl_scan_row_part1_single_done && csl_scan_row_part1_status && !csl_scan_mode_sel) 
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part1_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part1_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part1_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART2_ADDR) begin
        if(csl_scan_row_part2_single_done && !csl_scan_row_part2_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part3_start_addr   ;
        else if(csl_scan_row_part2_single_done && csl_scan_row_part2_status && !csl_scan_mode_sel) 
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part2_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part2_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part2_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART3_ADDR) begin
        if(csl_scan_row_part3_single_done && !csl_scan_row_part3_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part4_start_addr   ;
        else if(csl_scan_row_part3_single_done && csl_scan_row_part3_status && !csl_scan_mode_sel) 
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part3_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part3_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part3_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART4_ADDR) begin
        if(csl_scan_row_part4_single_done && !csl_scan_row_part4_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part5_start_addr   ;
        else if(csl_scan_row_part4_single_done && csl_scan_row_part4_status && !csl_scan_mode_sel) 
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part4_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part4_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part4_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART5_ADDR) begin
        if(csl_scan_row_part5_single_done && !csl_scan_row_part5_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part6_start_addr   ;
        else if(csl_scan_row_part5_single_done && csl_scan_row_part5_status && !csl_scan_mode_sel) 
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part5_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part5_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part5_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART6_ADDR) begin
        if(csl_scan_row_part6_single_done && !csl_scan_row_part6_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part7_start_addr   ;
        else if(csl_scan_row_part6_single_done && csl_scan_row_part6_status && !csl_scan_mode_sel) 
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part6_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part6_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part6_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART7_ADDR) begin
        if(csl_scan_row_part7_single_done && !csl_scan_row_part7_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part8_start_addr   ;
        else if(csl_scan_row_part7_single_done && csl_scan_row_part7_status && !csl_scan_mode_sel) 
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part7_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part7_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part7_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART8_ADDR) begin
        if(csl_scan_row_part8_single_done && !csl_scan_row_part8_status) 
            frame_data_send_row_addr   <=  csl_scan_row_part9_start_addr   ;
        else if(csl_scan_row_part8_single_done && csl_scan_row_part8_status && !csl_scan_mode_sel) 
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr==csl_scan_row_part8_end_addr && frame_data_send_col_addr!=col_end_addr && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <=  csl_scan_row_part8_start_addr  ;
        else if(frame_data_send_row_addr!=csl_scan_row_part8_end_addr  && csl_scan_frame_vld && csl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART9_ADDR) begin
        if(csl_scan_row_part9_single_done && !csl_scan_row_part9_status) 
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}} ;
        else if(csl_scan_row_part9_single_done && csl_scan_row_part9_status && !csl_scan_mode_sel)
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}} ;
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
        receive_col_addr  <= {ARRAY_COL_ADDR_WIDTH{1'h0}}  ;
    end
    else if(global_mc_bist_start)
        receive_col_addr  <=  {ARRAY_COL_ADDR_WIDTH{1'h0}} ;
    else if(FSM_CS == RD_PART0_ADDR) begin
        if(csl_scan_row_part0_single_done) 
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr == csl_scan_row_part0_end_addr && receive_col_addr != col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end    
    else if(FSM_CS == RD_PART1_ADDR) begin
        if(csl_scan_row_part1_single_done) 
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr == csl_scan_row_part1_end_addr && receive_col_addr != col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART2_ADDR) begin
        if(csl_scan_row_part2_single_done) 
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr == csl_scan_row_part2_end_addr && receive_col_addr != col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART3_ADDR) begin
        if(csl_scan_row_part3_single_done) 
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr == csl_scan_row_part3_end_addr && receive_col_addr != col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART4_ADDR) begin
        if(csl_scan_row_part4_single_done) 
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr == csl_scan_row_part4_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART5_ADDR) begin
        if(csl_scan_row_part5_single_done) 
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr == csl_scan_row_part5_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART6_ADDR) begin
        if(csl_scan_row_part6_single_done) 
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr == csl_scan_row_part6_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART7_ADDR) begin
        if(csl_scan_row_part7_single_done) 
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr == csl_scan_row_part7_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART8_ADDR) begin
        if(csl_scan_row_part8_single_done) 
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr == csl_scan_row_part8_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART9_ADDR) begin
        if(csl_scan_row_part9_single_done) 
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr == csl_scan_row_part9_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        receive_row_addr  <= {ARRAY_ROW_ADDR_WIDTH{1'h0}}  ;
    end
    else if(global_mc_bist_start)
        receive_row_addr  <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}} ;
    else if(FSM_CS == RD_PART0_ADDR) begin
        if(csl_scan_row_part0_single_done && !csl_scan_row_part0_status) 
            receive_row_addr   <=  csl_scan_row_part1_start_addr   ;
        else if(csl_scan_row_part0_single_done && csl_scan_row_part0_status && !csl_scan_mode_sel) 
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr==csl_scan_row_part0_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr!=csl_scan_row_part0_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
        end

    else if(FSM_CS == RD_PART1_ADDR) begin
        if(csl_scan_row_part1_single_done && !csl_scan_row_part1_status) 
            receive_row_addr   <=  csl_scan_row_part2_start_addr   ;
        else if(csl_scan_row_part1_single_done && csl_scan_row_part1_status && !csl_scan_mode_sel) 
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr==csl_scan_row_part1_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part1_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part1_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART2_ADDR) begin
        if(csl_scan_row_part2_single_done && !csl_scan_row_part2_status) 
            receive_row_addr   <=  csl_scan_row_part3_start_addr   ;
        else if(csl_scan_row_part2_single_done && csl_scan_row_part2_status && !csl_scan_mode_sel) 
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr==csl_scan_row_part2_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part2_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part2_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART3_ADDR) begin
        if(csl_scan_row_part3_single_done && !csl_scan_row_part3_status) 
            receive_row_addr   <=  csl_scan_row_part4_start_addr   ;
        else if(csl_scan_row_part3_single_done && csl_scan_row_part3_status && !csl_scan_mode_sel) 
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr==csl_scan_row_part3_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part3_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part3_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART4_ADDR) begin
        if(csl_scan_row_part4_single_done && !csl_scan_row_part4_status) 
            receive_row_addr   <=  csl_scan_row_part5_start_addr   ;
        else if(csl_scan_row_part4_single_done && csl_scan_row_part4_status && !csl_scan_mode_sel) 
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr==csl_scan_row_part4_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part4_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part4_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART5_ADDR) begin
        if(csl_scan_row_part5_single_done && !csl_scan_row_part5_status) 
            receive_row_addr   <=  csl_scan_row_part6_start_addr   ;
        else if(csl_scan_row_part5_single_done && csl_scan_row_part5_status && !csl_scan_mode_sel) 
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr==csl_scan_row_part5_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part5_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part5_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART6_ADDR) begin
        if(csl_scan_row_part6_single_done && !csl_scan_row_part6_status) 
            receive_row_addr   <=  csl_scan_row_part7_start_addr   ;
        else if(csl_scan_row_part6_single_done && csl_scan_row_part6_status && !csl_scan_mode_sel) 
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr==csl_scan_row_part6_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part6_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part6_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART7_ADDR) begin
        if(csl_scan_row_part7_single_done && !csl_scan_row_part7_status) 
            receive_row_addr   <=  csl_scan_row_part8_start_addr   ;
        else if(csl_scan_row_part7_single_done && csl_scan_row_part7_status && !csl_scan_mode_sel) 
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr==csl_scan_row_part7_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part7_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part7_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART8_ADDR) begin
        if(csl_scan_row_part8_single_done && !csl_scan_row_part8_status) 
            receive_row_addr   <=  csl_scan_row_part9_start_addr   ;
        else if(csl_scan_row_part8_single_done && csl_scan_row_part8_status && !csl_scan_mode_sel) 
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(receive_row_addr==csl_scan_row_part8_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <= csl_scan_row_part8_start_addr    ;
        else if(receive_row_addr!=csl_scan_row_part8_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_PART9_ADDR) begin
        if(csl_scan_row_part9_single_done && !csl_scan_row_part9_status) 
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(csl_scan_row_part9_single_done && csl_scan_row_part9_status && !csl_scan_mode_sel)
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ; 
        else if(receive_row_addr==csl_scan_row_part9_end_addr && receive_col_addr!=col_end_addr && csl_scan_rvalid)
            receive_row_addr   <=  csl_scan_row_part9_start_addr ;
        else if(receive_row_addr!=csl_scan_row_part9_end_addr && csl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
        end
end
always @(*)begin
    if(!(FSM_CS==IDLE || FSM_CS==WR_ADDR)) begin
        if(receive_row_addr[1:0]==2'b00)
        frame_golden_data  =  {34{bist_pattern_all[(pattern_index_reg*32+0)+:8]}} ;
        else if(receive_row_addr[1:0]==2'b01)
        frame_golden_data  =  {34{bist_pattern_all[(pattern_index_reg*32+8)+:8]}} ;
        else if(receive_row_addr[1:0]==2'b10)
        frame_golden_data  =  {34{bist_pattern_all[(pattern_index_reg*32+16)+:8]}} ;
        else if(receive_row_addr[1:0]==2'b11)
        frame_golden_data  =  {34{bist_pattern_all[(pattern_index_reg*32+24)+:8]}} ;
        else
        frame_golden_data  = {CHECKBIT_WIDTH+ARRAY_DATA_WIDTH{1'h0}} ;
    end
    else begin
        frame_golden_data  = {CHECKBIT_WIDTH+ARRAY_DATA_WIDTH{1'h0}} ;
    end
end


assign rdata_diff_flag = csl_scan_check_sel ? csl_scan_rdata!=frame_golden_data : csl_scan_rdata[255:0]!=frame_golden_data[255:0] ; 

always @(*)begin
    if(FSM_CS == RD_PART0_ADDR) begin
        if(csl_scan_row_part0_single_done) 
            csl_err_cnt   =  5'h0   ;
        else if(frame_data_send_row_addr=='h0 && csl_scan_frame_vld && csl_scan_frame_rdy)
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
        err_csl0_part0      <=  {ARRAY_COL_ADDR_WIDTH{1'h1}} ;
        err_csl1_part0      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part0_flag <=  1'b0  ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part0      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part0      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part0_flag <=  1'b0  ;        
        
    end
    else if(FSM_CS == RD_PART0_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold ) begin
        if(err_csl0_part0=={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl1_part0=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part0      <=  receive_col_addr   ;
            err_csl1_part0      <=  err_csl1_part0     ;
            err_csl2_part0_flag <=  1'b0               ;            
        end
        else if(err_csl0_part0!=receive_col_addr && err_csl1_part0=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part0      <=  err_csl0_part0     ;
            err_csl1_part0      <=  receive_col_addr   ;
            err_csl2_part0_flag <=  1'b0               ;
        end
        else if(err_csl1_part0!={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl0_part0!=receive_col_addr && err_csl1_part0!=receive_col_addr)begin
            err_csl0_part0      <=  err_csl0_part0     ;
            err_csl1_part0      <=  err_csl1_part0     ;
            err_csl2_part0_flag <=  1'b1               ;
        end
    end
end
//part1
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part1      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part1      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part1_flag <=  1'b0  ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part1      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part1      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part1_flag <=  1'b0  ;        
        
    end
    else if(FSM_CS == RD_PART1_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part1=={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl1_part1=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part1      <=  receive_col_addr   ;
            err_csl1_part1      <=  err_csl1_part1     ;
            err_csl2_part1_flag <=  1'b0               ;            
        end
        else if(err_csl0_part1!=receive_col_addr && err_csl1_part1=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part1      <=  err_csl0_part1     ;
            err_csl1_part1      <=  receive_col_addr   ;
            err_csl2_part1_flag <=  1'b0               ;
        end
        else if(err_csl1_part1!={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl0_part1!=receive_col_addr && err_csl1_part1!=receive_col_addr)begin
            err_csl0_part1      <=  err_csl0_part1     ;
            err_csl1_part1      <=  err_csl1_part1     ;
            err_csl2_part1_flag <=  1'b1               ;
        end
    end
end

//part2
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part2      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part2      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part2_flag <=  1'b0  ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part2      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part2      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part2_flag <=  1'b0  ;        
        
    end
    else if(FSM_CS == RD_PART2_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part2=={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl1_part2=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part2      <=  receive_col_addr   ;
            err_csl1_part2      <=  err_csl1_part2     ;
            err_csl2_part2_flag <=  1'b0               ;            
        end
        else if(err_csl0_part2!=receive_col_addr && err_csl1_part2=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part2      <=  err_csl0_part2     ;
            err_csl1_part2      <=  receive_col_addr   ;
            err_csl2_part2_flag <=  1'b0               ;
        end
        else if(err_csl1_part2!={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl0_part2!=receive_col_addr && err_csl1_part2!=receive_col_addr)begin
            err_csl0_part2      <=  err_csl0_part2     ;
            err_csl1_part2      <=  err_csl1_part2     ;
            err_csl2_part2_flag <=  1'b1               ;
        end
    end
end

//part3
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part3      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part3      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part3_flag <=  1'b0  ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part3      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part3      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part3_flag <=  1'b0  ;        
        
    end
    else if(FSM_CS == RD_PART3_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part3=={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl1_part3=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part3      <=  receive_col_addr   ;
            err_csl1_part3      <=  err_csl1_part3     ;
            err_csl2_part3_flag <=  1'b0               ;            
        end
        else if(err_csl0_part3!=receive_col_addr && err_csl1_part3=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part3      <=  err_csl0_part3     ;
            err_csl1_part3      <=  receive_col_addr   ;
            err_csl2_part3_flag <=  1'b0               ;
        end
        else if(err_csl1_part3!={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl0_part3!=receive_col_addr && err_csl1_part3!=receive_col_addr)begin
            err_csl0_part3      <=  err_csl0_part3     ;
            err_csl1_part3      <=  err_csl1_part3     ;
            err_csl2_part3_flag <=  1'b1               ;
        end
    end
end
//part4
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part4      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part4      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part4_flag <= 1'b0   ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part4      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part4      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part4_flag <= 1'b0   ;
    end
    else if(FSM_CS == RD_PART4_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part4=={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl1_part4=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part4      <=  receive_col_addr   ;
            err_csl1_part4      <=  err_csl1_part4     ;
            err_csl2_part4_flag <=  1'b0               ;
        end
        else if(err_csl0_part4!=receive_col_addr && err_csl1_part4=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part4      <=  err_csl0_part4     ;
            err_csl1_part4      <=  receive_col_addr   ;
            err_csl2_part4_flag <=  1'b0               ;
        end
        else if(err_csl1_part4!={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl0_part4!=receive_col_addr && err_csl1_part4!=receive_col_addr)begin
            err_csl0_part4      <=  err_csl0_part4     ;
            err_csl1_part4      <=  err_csl1_part4     ;
            err_csl2_part4_flag <= 1'b1                ;
        end

    end
end
//part5
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part5      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part5      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part5_flag <= 1'b0   ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part5      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part5      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part5_flag <= 1'b0   ;
    end
    else if(FSM_CS == RD_PART5_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part5=={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl1_part5=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part5      <=  receive_col_addr   ;
            err_csl1_part5      <=  err_csl1_part5     ;
            err_csl2_part5_flag <=  1'b0               ;
        end
        else if(err_csl0_part5!=receive_col_addr && err_csl1_part5=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part5      <=  err_csl0_part5     ;
            err_csl1_part5      <=  receive_col_addr   ;
            err_csl2_part5_flag <=  1'b0               ;
        end
        else if(err_csl1_part5!={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl0_part5!=receive_col_addr && err_csl1_part5!=receive_col_addr)begin
            err_csl0_part5      <=  err_csl0_part5     ;
            err_csl1_part5      <=  err_csl1_part5     ;
            err_csl2_part5_flag <= 1'b1                ;
        end

    end
end
//part6
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part6      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part6      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part6_flag <= 1'b0   ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part6      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part6      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part6_flag <= 1'b0   ;
    end
    else if(FSM_CS == RD_PART6_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part6=={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl1_part6=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part6      <=  receive_col_addr   ;
            err_csl1_part6      <=  err_csl1_part6     ;
            err_csl2_part6_flag <=  1'b0               ;
        end
        else if(err_csl0_part6!=receive_col_addr && err_csl1_part6=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part6      <=  err_csl0_part6     ;
            err_csl1_part6      <=  receive_col_addr   ;
            err_csl2_part6_flag <=  1'b0               ;
        end
        else if(err_csl1_part6!={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl0_part6!=receive_col_addr && err_csl1_part6!=receive_col_addr)begin
            err_csl0_part6      <=  err_csl0_part6     ;
            err_csl1_part6      <=  err_csl1_part6     ;
            err_csl2_part6_flag <= 1'b1                ;
        end

    end
end
//part7
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part7      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part7      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part7_flag <= 1'b0   ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part7      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part7      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part7_flag <= 1'b0   ;
    end
    else if(FSM_CS == RD_PART7_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part7=={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl1_part7=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part7      <=  receive_col_addr   ;
            err_csl1_part7      <=  err_csl1_part7     ;
            err_csl2_part7_flag <=  1'b0               ;
        end
        else if(err_csl0_part7!=receive_col_addr && err_csl1_part7=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part7      <=  err_csl0_part7     ;
            err_csl1_part7      <=  receive_col_addr   ;
            err_csl2_part7_flag <=  1'b0               ;
        end
        else if(err_csl1_part7!={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl0_part7!=receive_col_addr && err_csl1_part7!=receive_col_addr)begin
            err_csl0_part7      <=  err_csl0_part7     ;
            err_csl1_part7      <=  err_csl1_part7     ;
            err_csl2_part7_flag <= 1'b1                ;
        end

    end
end
//part8
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part8      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part8      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part8_flag <= 1'b0   ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part8      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part8      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part8_flag <= 1'b0   ;
    end
    else if(FSM_CS == RD_PART8_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part8=={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl1_part8=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part8      <=  receive_col_addr   ;
            err_csl1_part8      <=  err_csl1_part8     ;
            err_csl2_part8_flag <=  1'b0               ;
        end
        else if(err_csl0_part8!=receive_col_addr && err_csl1_part8=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part8      <=  err_csl0_part8     ;
            err_csl1_part8      <=  receive_col_addr   ;
            err_csl2_part8_flag <=  1'b0               ;
        end
        else if(err_csl1_part8!={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl0_part8!=receive_col_addr && err_csl1_part8!=receive_col_addr)begin
            err_csl0_part8      <=  err_csl0_part8     ;
            err_csl1_part8      <=  err_csl1_part8     ;
            err_csl2_part8_flag <= 1'b1                ;
        end

    end
end
//part9
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_csl0_part9      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part9      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part9_flag <= 1'b0   ;
    end
    else if(global_mc_bist_start) begin
        err_csl0_part9      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl1_part9      <=  {ARRAY_COL_ADDR_WIDTH{1'b1}} ;
        err_csl2_part9_flag <= 1'b0   ;
    end
    else if(FSM_CS == RD_PART9_ADDR && csl_scan_rvalid && csl_err_cnt==csl_err_threshold) begin
        if(err_csl0_part9=={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl1_part9=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part9      <=  receive_col_addr   ;
            err_csl1_part9      <=  err_csl1_part9     ;
            err_csl2_part9_flag <=  1'b0               ;
        end
        else if(err_csl0_part9!=receive_col_addr && err_csl1_part9=={ARRAY_COL_ADDR_WIDTH{1'b1}}) begin 
            err_csl0_part9      <=  err_csl0_part9     ;
            err_csl1_part9      <=  receive_col_addr   ;
            err_csl2_part9_flag <=  1'b0               ;
        end
        else if(err_csl1_part9!={ARRAY_COL_ADDR_WIDTH{1'b1}} && err_csl0_part9!=receive_col_addr && err_csl1_part9!=receive_col_addr)begin
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

assign csl_scan_row_part0_status = csl_scan_mode_sel==1'b0 ? (err_csl0_part0!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && (err_csl1_part0!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && err_csl2_part0_flag : 1'b0;
assign csl_scan_row_part1_status = csl_scan_mode_sel==1'b0 ? (err_csl0_part1!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && (err_csl1_part1!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && err_csl2_part1_flag : 1'b0;
assign csl_scan_row_part2_status = csl_scan_mode_sel==1'b0 ? (err_csl0_part2!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && (err_csl1_part2!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && err_csl2_part2_flag : 1'b0;
assign csl_scan_row_part3_status = csl_scan_mode_sel==1'b0 ? (err_csl0_part3!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && (err_csl1_part3!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && err_csl2_part3_flag : 1'b0;
assign csl_scan_row_part4_status = csl_scan_mode_sel==1'b0 ? (err_csl0_part4!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && (err_csl1_part4!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && err_csl2_part4_flag : 1'b0;
assign csl_scan_row_part5_status = csl_scan_mode_sel==1'b0 ? (err_csl0_part5!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && (err_csl1_part5!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && err_csl2_part5_flag : 1'b0;
assign csl_scan_row_part6_status = csl_scan_mode_sel==1'b0 ? (err_csl0_part6!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && (err_csl1_part6!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && err_csl2_part6_flag : 1'b0;
assign csl_scan_row_part7_status = csl_scan_mode_sel==1'b0 ? (err_csl0_part7!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && (err_csl1_part7!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && err_csl2_part7_flag : 1'b0;
assign csl_scan_row_part8_status = csl_scan_mode_sel==1'b0 ? (err_csl0_part8!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && (err_csl1_part8!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && err_csl2_part8_flag : 1'b0;
assign csl_scan_row_part9_status = csl_scan_mode_sel==1'b0 ? (err_csl0_part9!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && (err_csl1_part9!={ARRAY_COL_ADDR_WIDTH{1'b1}}) && err_csl2_part9_flag : 1'b0;



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
assign csl_scan_row_part0_single_done_pre = csl_scan_mode_sel==1'b0 ? ((!csl_scan_row_part0_status && receive_row_addr == csl_scan_row_part0_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part0_status_pos) : (receive_row_addr == csl_scan_row_part0_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1);

assign csl_scan_row_part1_single_done_pre = csl_scan_mode_sel==1'b0 ? ((!csl_scan_row_part1_status && receive_row_addr == csl_scan_row_part1_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part1_status_pos) : (receive_row_addr == csl_scan_row_part1_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1);

assign csl_scan_row_part2_single_done_pre = csl_scan_mode_sel==1'b0 ? ((!csl_scan_row_part2_status && receive_row_addr == csl_scan_row_part2_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part2_status_pos) : (receive_row_addr == csl_scan_row_part2_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1);

assign csl_scan_row_part3_single_done_pre = csl_scan_mode_sel==1'b0 ? ((!csl_scan_row_part3_status && receive_row_addr == csl_scan_row_part3_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part3_status_pos) : (receive_row_addr == csl_scan_row_part3_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1);

assign csl_scan_row_part4_single_done_pre = csl_scan_mode_sel==1'b0 ? ((!csl_scan_row_part4_status && receive_row_addr == csl_scan_row_part4_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part4_status_pos) : (receive_row_addr == csl_scan_row_part4_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1);

assign csl_scan_row_part5_single_done_pre = csl_scan_mode_sel==1'b0 ? ((!csl_scan_row_part5_status && receive_row_addr == csl_scan_row_part5_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part5_status_pos) : (receive_row_addr == csl_scan_row_part5_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1);

assign csl_scan_row_part6_single_done_pre = csl_scan_mode_sel==1'b0 ? ((!csl_scan_row_part6_status && receive_row_addr == csl_scan_row_part6_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part6_status_pos) : (receive_row_addr == csl_scan_row_part6_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1);

assign csl_scan_row_part7_single_done_pre = csl_scan_mode_sel==1'b0 ? ((!csl_scan_row_part7_status && receive_row_addr == csl_scan_row_part7_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part7_status_pos) : (receive_row_addr == csl_scan_row_part7_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1);

assign csl_scan_row_part8_single_done_pre = csl_scan_mode_sel==1'b0 ? ((!csl_scan_row_part8_status && receive_row_addr == csl_scan_row_part8_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part8_status_pos) : (receive_row_addr == csl_scan_row_part8_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1);

assign csl_scan_row_part9_single_done_pre = csl_scan_mode_sel==1'b0 ? ((!csl_scan_row_part9_status && receive_row_addr == csl_scan_row_part9_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1) || csl_scan_row_part9_status_pos) : (receive_row_addr == csl_scan_row_part9_end_addr && receive_col_addr == col_end_addr && csl_scan_rvalid && data_noback_req_cnt==5'h1);



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

assign csl_single_pattern_done = csl_scan_mode_sel==1'b0 ? (csl_scan_row_part0_single_done && csl_scan_row_part0_status) ||
                                                           (csl_scan_row_part1_single_done && csl_scan_row_part1_status) ||
                                                           (csl_scan_row_part2_single_done && csl_scan_row_part2_status) ||
                                                           (csl_scan_row_part3_single_done && csl_scan_row_part3_status) ||
                                                           (csl_scan_row_part4_single_done && csl_scan_row_part4_status) ||
                                                           (csl_scan_row_part5_single_done && csl_scan_row_part5_status) ||
                                                           (csl_scan_row_part6_single_done && csl_scan_row_part6_status) ||
                                                           (csl_scan_row_part7_single_done && csl_scan_row_part7_status) ||
                                                           (csl_scan_row_part8_single_done && csl_scan_row_part8_status) ||
                                                           csl_scan_row_part9_single_done 
                                                           :csl_scan_row_part9_single_done ;


assign csl_scan_success_status = csl_scan_mode_sel==1'b0 ? 
                                 !csl_scan_row_part0_status && !csl_scan_row_part1_status && !csl_scan_row_part2_status && !csl_scan_row_part3_status 
                                 && !csl_scan_row_part4_status && !csl_scan_row_part5_status && !csl_scan_row_part6_status && !csl_scan_row_part7_status 
                                 && !csl_scan_row_part8_status && !csl_scan_row_part9_status 
                                 :csl_scan_row_part9_single_done ;


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
assign csl_scan_fail_status = csl_scan_mode_sel==1'b0 ? err_csl2_part0_flag || err_csl2_part1_flag || err_csl2_part2_flag || err_csl2_part3_flag || err_csl2_part4_flag || 
                              err_csl2_part5_flag || err_csl2_part6_flag || err_csl2_part7_flag || err_csl2_part8_flag || err_csl2_part9_flag : 1'b0;
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        csl_scan_fail <= 1'b0;
    else if(bist_finish_clr || global_mc_bist_start)
        csl_scan_fail <= 1'b0;
    else if(csl_scan_fail_status && csl_single_pattern_done)
        csl_scan_fail <= 1'b1;
end
endmodule
