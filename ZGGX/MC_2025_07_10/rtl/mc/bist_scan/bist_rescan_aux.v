module bist_rescan_aux #(
    parameter   RESCAN_ROUND_NUM      = 15                                 ,
    parameter   ARRAY_ADDR_WIDTH      = 13+8                               ,
    parameter   MC_SHORT_MODE         = 4                                  ,
    parameter   CHECKBIT_WIDTH        = 16                                 ,
    parameter   ARRAY_ROW_ADDR_WIDTH  = 13                                 ,
    parameter   ARRAY_COL_ADDR_WIDTH  = 8                                  ,
    parameter   ARRAY_DATA_WIDTH      = 256
)(
  //-------------clock and reset signal--------------
  input                                                                         clk                                 ,
  input                                                                         rst_n                               ,
  //-------------control signal----------------------                                                               
  input      [1:0]                                                              bist_layer_id                       ,
  input                                                                         global_mc_bist_en                   ,
  input                                                                         global_mc_rescan_start              ,//default 0
  input                                                                         mc_bist_en                          ,
  input      [67:0]                                                             wl_bist_pattern_sel                 ,
  input      [68*32-1:0]                                                        bist_pattern_all                    ,
  													                              			                  
  input      [3:0]                                                              bist_rescan_num                     ,//default 3
  output reg [19:0]                                                             bist_rescan_fail_num                ,
  output reg [RESCAN_ROUND_NUM-1:0]                                             rescan_round_result                 ,
  input                                                                         bist_rescan_sel                     ,//1:7360-64,0:7360,default 1
													                              					              
  output                                                                        bist_rescan_success                 ,
  //output                                                                        bist_rescan_finish                  ,
  output reg                                                                    bist_rescan_finish_status           ,
  input                                                                         rescan_finish_clr                   ,
  //input                                                                         rescan_finish_mask                  ,
  output                                                                        rescan_working                      ,
  //-------------data signal------------------------                                      
  output reg                                                                    rescan_frame_vld                    ,
  input                                                                         rescan_frame_rdy                    ,
  output     [3+CHECKBIT_WIDTH+ARRAY_DATA_WIDTH+ARRAY_ADDR_WIDTH+2-1 :0]        rescan_frame_data                   ,//rw_flag,sof,eof,data,row,col
  input                                                                         rescan_rvalid                       ,
  input      [CHECKBIT_WIDTH+ARRAY_DATA_WIDTH-1:0]                              rescan_rdata                        
);



//wire and reg
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                rescan_row_end_addr                  ;

reg    [6:0]                                     rescan_pattern_num_cnt_status        ;
wire                                             rescan_row_write_done                ;
wire                                             wl_single_pattern_done               ;

reg    [6:0]                                     rescan_pattern_num_cnt_status_inner  ;

reg    [3:0]                                     rescan_num_cnt_status_inner          ;
reg    [3:0]                                     rescan_num_cnt                       ;
wire                                             rescan_num_cnt_allow                 ;

reg                                              frame_data_rw_flag                   ;
reg                                              frame_data_sof                       ;
reg                                              frame_data_eof                       ;
reg    [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]     frame_data                           ;
reg    [ARRAY_COL_ADDR_WIDTH-1:0]                frame_data_send_col_addr             ;
reg    [ARRAY_ROW_ADDR_WIDTH-1:0]                frame_data_send_row_addr             ;
reg    [ARRAY_COL_ADDR_WIDTH-1:0]                receive_col_addr                     ;
reg    [ARRAY_ROW_ADDR_WIDTH-1:0]                receive_row_addr                     ;

reg    [4:0]                                     data_noback_req_cnt                  ; //data no back, read request cnt
																		              
reg    [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]     frame_golden_data                    ;
wire   [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]     check_data                           ;
reg    [19:0]                                    err_bit_cnt                          ;
																		              
reg                                              bist_wl_fail                         ;
reg                                              rescan_row_status_r                  ;

reg    [3:0]                                     single_pattern_rd_times_cnt_inner    ;
reg    [3:0]                                     single_pattern_rd_times_cnt          ;
integer                                          II                                   ;
integer                                          JJ                                   ;
integer                                          KK                                   ;

wire   [ARRAY_COL_ADDR_WIDTH-1:0]                rescan_col_end_addr                  ;
wire   [6:0]                                     bist_wl_scan_num                     ;
reg    [6:0]                                     wl_pattern_cnt                       ;
reg    [6:0]                                     pattern_index                        ;
reg    [6:0]                                     pattern_index_reg                    ;
reg    [67:0]                                    wl_bist_pattern_sel_new              ;                  

//--------------------------------------------------
assign  rescan_row_end_addr   =  13'd299;
///////////assign rescan_row_end_addr = bist_rescan_sel ? 13'h1C7F : 13'h1CBF;//1:7295 0:7359
assign rescan_col_end_addr = bist_rescan_sel ? 8'h7F : 8'h81 ;//1:127 0:129
localparam  IDLE                 = 2'b00  ,
            WR_ADDR              = 2'b01  ,
            RD_ADDR              = 2'b11  ;

reg [1:0] FSM_CS;
reg [1:0] FSM_NS;

always @(*)begin
    wl_pattern_cnt = 7'h0;
    for(JJ=0;JJ<68;JJ=JJ+1)begin:select_rescan_pattern_cnt
        if(wl_bist_pattern_sel[JJ]==1'b1)begin
            wl_pattern_cnt = wl_pattern_cnt + 1'b1;
        end
    end
end

assign  bist_wl_scan_num = wl_pattern_cnt ;


always @(*)begin
    pattern_index = 7'h0;
     if((FSM_CS==IDLE && FSM_NS==WR_ADDR)||wl_single_pattern_done) begin
        for(KK=68;KK>0;KK=KK-1)begin:gen_pattern_index
            if(wl_bist_pattern_sel_new[KK-1]==1'b1)
                pattern_index = KK-1;
        end       
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        wl_bist_pattern_sel_new <= 68'h0;
    else if(FSM_NS==IDLE)
        wl_bist_pattern_sel_new <= wl_bist_pattern_sel ;
    else if((FSM_CS==IDLE && FSM_NS==WR_ADDR) || wl_single_pattern_done)
        wl_bist_pattern_sel_new <= wl_bist_pattern_sel_new ^ (1'b1 << pattern_index);
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        pattern_index_reg <= 7'h0;
    else if((FSM_CS==IDLE && FSM_NS==WR_ADDR) || wl_single_pattern_done)
        pattern_index_reg <= pattern_index;
end
//-------------------------------gen_pattern num-----------------------------------------
always @(*) begin
    if(global_mc_rescan_start)
        rescan_pattern_num_cnt_status = 7'h0 ;
    else if(wl_single_pattern_done && rescan_pattern_num_cnt_status_inner==bist_wl_scan_num-1)
        rescan_pattern_num_cnt_status = 7'h0 ;
    else if(wl_single_pattern_done)
        rescan_pattern_num_cnt_status = rescan_pattern_num_cnt_status_inner + 1'b1 ;
    else 
        rescan_pattern_num_cnt_status = rescan_pattern_num_cnt_status_inner  ;
end
//assign rescan_pattern_num_allow = rescan_pattern_num_cnt_status < bist_wl_scan_num && FSM_CS==RD_ADDR; 

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        rescan_pattern_num_cnt_status_inner   <=  7'h0   ;
    end
    else begin
        rescan_pattern_num_cnt_status_inner   <= rescan_pattern_num_cnt_status  ;
    end
end
//-------------------------------gen_rescan_cnt-----------------------------

always @(*) begin
    if(global_mc_rescan_start)
        rescan_num_cnt = 4'h0 ;
    else if(wl_single_pattern_done && rescan_pattern_num_cnt_status_inner==bist_wl_scan_num-1)
        rescan_num_cnt = rescan_num_cnt_status_inner + 1'b1 ;
    else 
        rescan_num_cnt = rescan_num_cnt_status_inner  ;
    end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
       rescan_num_cnt_status_inner  <= 4'h0   ;
    end
    else begin
       rescan_num_cnt_status_inner <=  rescan_num_cnt;
    end
end

assign rescan_num_cnt_allow = rescan_num_cnt <  bist_rescan_num; 


//----------------------------------------------------------------------------
//FSM design
//----------------------------------------------------------------------------

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
      if (global_mc_bist_en && global_mc_rescan_start && mc_bist_en)
        FSM_NS = WR_ADDR;
      else
        FSM_NS = FSM_CS;
    end
    WR_ADDR: begin
      if (rescan_row_write_done)
        FSM_NS = RD_ADDR;
      else
        FSM_NS = FSM_CS;
    end 
    RD_ADDR : begin
        if(rescan_num_cnt_allow && wl_single_pattern_done)//<64 pattern,<rescan cnt
          FSM_NS = WR_ADDR;
        else if(!rescan_num_cnt_allow && rescan_pattern_num_cnt_status_inner == bist_wl_scan_num-1 && wl_single_pattern_done)
          FSM_NS = IDLE;
        else
          FSM_NS = FSM_CS;
      end
    default: FSM_NS = IDLE;
endcase
end
//----------------------------------------------------------------------------
assign rescan_frame_data = {frame_data_rw_flag,frame_data_sof,frame_data_eof,frame_data,bist_layer_id,frame_data_send_row_addr,frame_data_send_col_addr} ;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        data_noback_req_cnt  <=  5'h0 ;
    end
    else if((rescan_frame_vld && rescan_frame_rdy && FSM_CS==RD_ADDR) && rescan_rvalid) begin
        data_noback_req_cnt  <=  data_noback_req_cnt   ;
    end
    else if(rescan_frame_vld && rescan_frame_rdy && FSM_CS==RD_ADDR) begin
        data_noback_req_cnt  <=  data_noback_req_cnt + 1'b1  ;
    end
    else if(rescan_rvalid) begin
        data_noback_req_cnt  <=  data_noback_req_cnt - 1'b1  ;
    end
end



always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        rescan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==WR_ADDR) begin
        if(!rescan_row_write_done)
            rescan_frame_vld <= 1'b1  ;
    end
    else if(FSM_CS==RD_ADDR) begin
        //if(wl_single_pattern_done)
//        if(!rescan_num_cnt_allow)
//            rescan_frame_vld   <=  1'b0   ;
//        else if(frame_data_send_row_addr!=rescan_row_end_addr || frame_data_send_col_addr!=rescan_col_end_addr)
//            rescan_frame_vld   <=  1'b1   ;
//azy
        if(frame_data_send_row_addr == rescan_row_end_addr && frame_data_send_col_addr == rescan_col_end_addr && rescan_frame_vld && rescan_frame_rdy)
            rescan_frame_vld   <=  1'b0   ;
//azy
    end
 end

always @(*) begin  //rw_flag
    if(FSM_CS==WR_ADDR)
        frame_data_rw_flag = 1'b1 ;
    else if(FSM_CS==RD_ADDR)
        frame_data_rw_flag = 1'b0 ;
    else
        frame_data_rw_flag = 1'b0 ;
end
always @(*) begin  //sof
    if(FSM_CS==WR_ADDR && frame_data_send_col_addr==8'h0)
        frame_data_sof = 1'b1 ;
    else if(FSM_CS==RD_ADDR && frame_data_send_col_addr==8'h0)
        frame_data_sof = 1'b1 ;
    else
        frame_data_sof = 1'b0 ;
end
always @(*) begin  //eof
    if(FSM_CS==WR_ADDR && frame_data_send_col_addr==rescan_col_end_addr)
        frame_data_eof = 1'b1 ;
    else if(FSM_CS==RD_ADDR && frame_data_send_col_addr==rescan_col_end_addr)
        frame_data_eof = 1'b1 ;
    else
        frame_data_eof = 1'b0 ;
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        frame_data  <=  {CHECKBIT_WIDTH+ARRAY_DATA_WIDTH{1'h0}} ;
    end
    else if(FSM_NS == WR_ADDR) begin
        if(frame_data_send_row_addr[1:0]==2'b00)
        frame_data  <=  {34{bist_pattern_all[(pattern_index_reg*32+0)+:8]}} ;
        else if(frame_data_send_row_addr[1:0]==2'b01)
        frame_data  <=  {34{bist_pattern_all[(pattern_index_reg*32+8)+:8]}} ;
        else if(frame_data_send_row_addr[1:0]==2'b10)
        frame_data  <=  {34{bist_pattern_all[(pattern_index_reg*32+16)+:8]}} ;
        else if(frame_data_send_row_addr[1:0]==2'b11)
        frame_data  <=  {34{bist_pattern_all[(pattern_index_reg*32+24)+:8]}} ;
    end
    else if(FSM_CS==RD_ADDR) begin
        frame_data  <= {CHECKBIT_WIDTH+ARRAY_DATA_WIDTH{1'h0}} ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        frame_data_send_col_addr  <=  {ARRAY_COL_ADDR_WIDTH{1'h0}} ;
    end
    else if(global_mc_rescan_start)
        frame_data_send_col_addr  <=  {ARRAY_COL_ADDR_WIDTH{1'h0}} ;
    else if(FSM_CS == WR_ADDR) begin
        if(frame_data_send_col_addr == rescan_col_end_addr && rescan_frame_vld && rescan_frame_rdy)
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
        else if(rescan_frame_vld && rescan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_ADDR) begin
        if(wl_single_pattern_done) 
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
         else if(frame_data_send_col_addr == rescan_col_end_addr && rescan_frame_vld && rescan_frame_rdy)
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH{1'h0}}   ;
//        else if(frame_data_send_row_addr!=rescan_row_end_addr && frame_data_send_col_addr==6'h3F && rescan_frame_vld && rescan_frame_rdy)
        else if(frame_data_send_col_addr!=rescan_col_end_addr && rescan_frame_vld && rescan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        frame_data_send_row_addr  <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}} ;
    end
    else if(global_mc_rescan_start)
        frame_data_send_row_addr  <=   {ARRAY_ROW_ADDR_WIDTH{1'h0}};
    else if(FSM_CS == WR_ADDR) begin
        if(frame_data_send_row_addr==rescan_row_end_addr && frame_data_send_col_addr == rescan_col_end_addr && rescan_frame_vld && rescan_frame_rdy)
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_col_addr == rescan_col_end_addr && rescan_frame_vld && rescan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_ADDR) begin
        if(wl_single_pattern_done) 
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr == rescan_row_end_addr && frame_data_send_col_addr == rescan_col_end_addr && rescan_frame_vld && rescan_frame_rdy)
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr != rescan_row_end_addr && frame_data_send_col_addr == rescan_col_end_addr && rescan_frame_vld && rescan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
end

assign rescan_row_write_done = (FSM_CS==WR_ADDR) && (frame_data_send_row_addr == rescan_row_end_addr) && frame_data_send_col_addr==rescan_col_end_addr && rescan_frame_vld && rescan_frame_rdy; 
//----------------------------------------------------------------------------

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        receive_col_addr  <=  {ARRAY_COL_ADDR_WIDTH{1'h0}} ;
    end
    else if(global_mc_rescan_start)
        receive_col_addr  <=  {ARRAY_COL_ADDR_WIDTH-1{1'h0}} ;
    else if(FSM_CS == RD_ADDR) begin
        if(wl_single_pattern_done) 
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH-1{1'h0}}   ;
        else if(receive_col_addr == rescan_col_end_addr && rescan_rvalid)
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH-1{1'h0}}   ;
        else if(rescan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        receive_row_addr  <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}} ;
    end
    else if(global_mc_rescan_start)
        receive_row_addr  <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}} ;
    else if(FSM_CS == RD_ADDR) begin
        if(wl_single_pattern_done || (receive_row_addr == rescan_row_end_addr && receive_col_addr == rescan_col_end_addr && rescan_rvalid)) 
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(receive_col_addr == rescan_col_end_addr && rescan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
end
always @(*)begin
    if(FSM_CS==RD_ADDR) begin
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


always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bist_wl_fail  <=  1'b0 ;
    end
    else if(FSM_CS == WR_ADDR && rescan_pattern_num_cnt_status_inner==0) begin
        bist_wl_fail  <=  1'b0 ;
    end
    else if(FSM_CS == RD_ADDR && rescan_rvalid && rescan_rdata!=frame_golden_data) begin 
        bist_wl_fail  <=  1'b1 ;
    end
end

assign check_data = rescan_rvalid ? rescan_rdata ^ frame_golden_data : 'h0;

always @(*)begin
    err_bit_cnt = 20'h0;
    for(II=0;II<(ARRAY_DATA_WIDTH+CHECKBIT_WIDTH);II=II+1)begin:gen_err_bit_cnt
        if(check_data[II]==1'b1)
            err_bit_cnt = err_bit_cnt+1'b1;
        end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bist_rescan_fail_num <= 20'h0;
    else if(global_mc_rescan_start)
        bist_rescan_fail_num <= 20'h0;
    else
        bist_rescan_fail_num <= (20'hfffff - bist_rescan_fail_num >= err_bit_cnt) ? bist_rescan_fail_num + err_bit_cnt : 20'hfffff;
end
        //always @(posedge clk or negedge rst_n)begin
//    if(!rst_n)
//       rescan_row_status_r <= 1'b0;
//    else 
//       rescan_row_status_r  <= rescan_row_status;
//end
//assign  rescan_row_status_pos = rescan_row_status && !rescan_row_status_r ;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};
    else if(global_mc_rescan_start)
        rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};
    else if(wl_single_pattern_done && rescan_pattern_num_cnt_status_inner==bist_wl_scan_num-1 && !bist_wl_fail)
        rescan_round_result[rescan_num_cnt_status_inner] <= 1'b1;
    end

assign bist_rescan_success =  |rescan_round_result;

//assign rescan_row_status = bist_wl_fail ;

assign wl_single_pattern_done = receive_row_addr == rescan_row_end_addr && receive_col_addr == rescan_col_end_addr && rescan_rvalid && data_noback_req_cnt==5'h1 ;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bist_rescan_finish_status   <=  1'b0   ;
    end
    else if(rescan_finish_clr || global_mc_rescan_start) begin
        bist_rescan_finish_status   <=  1'b0   ;
    end
    else if(!rescan_num_cnt_allow && wl_single_pattern_done) begin
        bist_rescan_finish_status   <=  1'b1   ;
    end
end

//always @(posedge clk)begin
//    if(ras_clr) begin
//        bist_rescan_finish_status_ras   <=  1'b0   ;
//    end
//    else if(rescan_finish_clr || global_mc_rescan_start) begin
//        bist_rescan_finish_status_ras   <=  1'b0   ;
//    end
//    else if(!rescan_num_cnt_allow) begin
//        bist_rescan_finish_status_ras   <=  1'b1   ;
//    end
//end

assign rescan_working = (FSM_CS==WR_ADDR || FSM_CS==RD_ADDR) ;

//assign bist_rescan_finish = rescan_finish_mask ? 1'b0 : bist_rescan_finish_status ;
endmodule
