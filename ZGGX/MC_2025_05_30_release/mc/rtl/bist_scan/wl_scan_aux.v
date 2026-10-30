module wl_scan_aux (
  //-------------clock and reset signal--------------
  input                                               clk                                 ,
  input                                               rst_n                               ,
//  input                                               ras_clr                             ,
  //-------------control signal----------------------                                     
  input                                               global_mc_bist_start                ,
  input                                               global_mc_bist_en                   ,
  input                                               mc_bist_en                          ,
  input                                               global_bist_clr                     ,
  
  input                                               csl_scan_finish                     ,
																		                  
  //input      [6:0]                                    bist_wl_scan_num                    ,
  input      [3:0]                                    bist_wl_scan_single_pattern_rd_num  ,//max 16,default 0:read one time
  
  input      [68*32-1:0]                              bist_pattern_all                    ,
  input      [67:0]                                   wl_bist_pattern_sel                 ,
    
  output                                              bist_wl_success                     ,
  output reg                                          bist_wl_finish                      ,
  input                                               bist_finish_clr                     ,
  output                                              wl_scan_working                     ,
  output     [6:0]                                    err_wl_cnt                          ,//1:diff 0: same
  output reg                                          err_wl_cnt_change_flag              ,
  //-------------data signal------------------------                                      
  output reg                                          wl_scan_frame_vld                   ,
  input                                               wl_scan_frame_rdy                   ,
  output     [1+1+1+266+13+7-1 :0]                    wl_scan_frame_data                  ,//rw_flag,sof,eof,data,row,col
  input                                               wl_scan_rvalid                      ,
  input      [266-1:0]                                wl_scan_rdata                       ,
  //-------------error wl record signal------------
  output     [12:0]                                   err_wl0                             ,
  output     [12:0]                                   err_wl1                             ,
  output     [12:0]                                   err_wl2                             ,
  output     [12:0]                                   err_wl3                             ,
  output     [12:0]                                   err_wl4                             ,
  output     [12:0]                                   err_wl5                             ,
  output     [12:0]                                   err_wl6                             ,
  output     [12:0]                                   err_wl7                             ,
  output     [12:0]                                   err_wl8                             ,
  output     [12:0]                                   err_wl9                             ,
  output     [12:0]                                   err_wl10                            ,
  output     [12:0]                                   err_wl11                            ,
  output     [12:0]                                   err_wl12                            ,
  output     [12:0]                                   err_wl13                            ,
  output     [12:0]                                   err_wl14                            ,
  output     [12:0]                                   err_wl15                            ,
  output     [12:0]                                   err_wl16                            ,
  output     [12:0]                                   err_wl17                            ,
  output     [12:0]                                   err_wl18                            ,
  output     [12:0]                                   err_wl19                            ,
  output     [12:0]                                   err_wl20                            ,
  output     [12:0]                                   err_wl21                            ,
  output     [12:0]                                   err_wl22                            ,
  output     [12:0]                                   err_wl23                            ,
  output     [12:0]                                   err_wl24                            ,
  output     [12:0]                                   err_wl25                            ,
  output     [12:0]                                   err_wl26                            ,
  output     [12:0]                                   err_wl27                            ,
  output     [12:0]                                   err_wl28                            ,
  output     [12:0]                                   err_wl29                            ,
  output     [12:0]                                   err_wl30                            ,
  output     [12:0]                                   err_wl31                            ,
  output     [12:0]                                   err_wl32                            ,
  output     [12:0]                                   err_wl33                            ,
  output     [12:0]                                   err_wl34                            ,
  output     [12:0]                                   err_wl35                            ,
  output     [12:0]                                   err_wl36                            ,
  output     [12:0]                                   err_wl37                            ,
  output     [12:0]                                   err_wl38                            ,
  output     [12:0]                                   err_wl39                            ,
  output     [12:0]                                   err_wl40                            ,
  output     [12:0]                                   err_wl41                            ,
  output     [12:0]                                   err_wl42                            ,
  output     [12:0]                                   err_wl43                            ,
  output     [12:0]                                   err_wl44                            ,
  output     [12:0]                                   err_wl45                            ,
  output     [12:0]                                   err_wl46                            ,
  output     [12:0]                                   err_wl47                            ,
  output     [12:0]                                   err_wl48                            ,
  output     [12:0]                                   err_wl49                            ,
  output     [12:0]                                   err_wl50                            ,
  output     [12:0]                                   err_wl51                            ,
  output     [12:0]                                   err_wl52                            ,
  output     [12:0]                                   err_wl53                            ,
  output     [12:0]                                   err_wl54                            ,
  output     [12:0]                                   err_wl55                            ,
  output     [12:0]                                   err_wl56                            ,
  output     [12:0]                                   err_wl57                            ,
  output     [12:0]                                   err_wl58                            ,
  output     [12:0]                                   err_wl59                            ,
  output     [12:0]                                   err_wl60                            ,
  output     [12:0]                                   err_wl61                            ,
  output     [12:0]                                   err_wl62                            ,
  output     [12:0]                                   err_wl63                 


);


//wire and reg
wire   [12:0]                                    wl_scan_row_end_addr               ;

//reg                                              wl_scan_working_status ;
reg    [6:0]                                     wl_scan_num_cnt_status             ;
wire                                             wl_scan_row_status                 ;
wire   [6:0]                                     wl_scan_err_cnt                    ;
wire                                             err_wl_same                        ;
wire                                             wl_scan_row_write_done             ;
wire                                             wl_single_pattern_done             ;

reg    [6:0]                                     wl_scan_num_cnt_status_inner       ;
wire                                             wl_scan_num_cnt_allow              ;

reg                                              frame_data_rw_flag                 ;
reg                                              frame_data_sof                     ;
reg                                              frame_data_eof                     ;
reg    [265:0]                                   frame_data                         ;
reg    [6:0]                                     frame_data_send_col_addr           ;
reg    [12:0]                                    frame_data_send_row_addr           ;
reg    [6:0]                                     receive_col_addr                   ;
reg    [12:0]                                    receive_row_addr                   ;

reg    [4:0]                                     data_noback_req_cnt                ; //data no back, read request cnt
																		            
reg    [265:0]                                   frame_golden_data                  ;
																		            
reg    [13*64-1:0]                               err_wl_store                       ;
reg                                              bist_wl_fail                       ;
reg                                              wl_scan_row_status_r               ;
wire                                             wl_scan_row_status_pos             ;

reg    [4:0]                                     single_pattern_rd_times_cnt_inner  ;
reg    [4:0]                                     single_pattern_rd_times_cnt        ;
wire                                             wl_single_rd_done                  ;
wire                                             wl_scan_rd_cnt_allow               ;
reg    [6:0]                                     err_wl_cnt_r                       ;
wire   [6:0]                                     bist_wl_scan_num                   ;
reg    [6:0]                                     wl_pattern_cnt                     ;
reg    [6:0]                                     pattern_index                      ;
reg    [6:0]                                     pattern_index_reg                  ;
reg    [67:0]                                    wl_bist_pattern_sel_new            ;

integer                                          II                                 ;
integer                                          KK                                 ;

//reg                                              rd_frame_done                      ; //azy
//--------------------------------------------------
////////////assign  wl_scan_row_end_addr = 13'h1CC0 - 1'b1;//7360
assign  wl_scan_row_end_addr   =  13'd299;//14719

assign  err_wl_cnt = wl_scan_err_cnt;

always @(*)begin
    wl_pattern_cnt = 7'h0;
    for(II=0;II<68;II=II+1)begin:gen_wl_pattern_cnt
        if(wl_bist_pattern_sel[II]==1'b1)begin
            wl_pattern_cnt = wl_pattern_cnt + 1'b1;
        end
    end
end

assign  bist_wl_scan_num =  wl_pattern_cnt; 


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        err_wl_cnt_r <= 7'h0 ;
    else if((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (!bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0)) 
        err_wl_cnt_r <= err_wl_cnt ;
end

//20250408 add by hy
wire    s_err_wl_cnt_change_cona;
wire    s_err_wl_cnt_change_conb;
assign  s_err_wl_cnt_change_cona = (wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num));
assign  s_err_wl_cnt_change_conb = (!bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0);
//end by hy

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        err_wl_cnt_change_flag <= 1'b0;
    else if(global_mc_bist_start)
        err_wl_cnt_change_flag <= 1'b0;
//    else if((err_wl_cnt != err_wl_cnt_r) && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (!bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0)))
    else if((err_wl_cnt != err_wl_cnt_r) && (s_err_wl_cnt_change_cona || s_err_wl_cnt_change_conb)) //20250408 add by hy
        err_wl_cnt_change_flag <= 1'b1;
end

//assign err_wl_cnt_change_flag =  err_wl_cnt != err_wl_cnt_r ;

localparam  IDLE                 = 2'b00  ,
            WR_ADDR              = 2'b01  ,
            RD_ADDR              = 2'b11  ;

reg [1:0] FSM_CS;
reg [1:0] FSM_NS;

//------------------------------------------------------------------------

always @(*)begin
    pattern_index = 7'h0;
    if((FSM_CS==IDLE && FSM_NS==WR_ADDR) || wl_single_pattern_done) begin
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
    else if((FSM_CS==IDLE && FSM_NS==WR_ADDR) || wl_single_pattern_done )
        wl_bist_pattern_sel_new <= wl_bist_pattern_sel_new ^ (1'b1 << pattern_index);
end


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        pattern_index_reg <= 7'h0;
    else if((FSM_CS==IDLE && FSM_NS==WR_ADDR) || wl_single_pattern_done)
        pattern_index_reg <= pattern_index;
end


always @(*) begin
    if(global_mc_bist_start)
        wl_scan_num_cnt_status = 7'h0 ;
    else if(wl_scan_row_status)
        wl_scan_num_cnt_status = 7'h0 ;
    else if(wl_single_pattern_done)
        wl_scan_num_cnt_status = wl_scan_num_cnt_status_inner + 1'b1 ;
    else 
        wl_scan_num_cnt_status = wl_scan_num_cnt_status_inner  ;
end
assign wl_scan_num_cnt_allow = (wl_scan_num_cnt_status > 7'h0) && (wl_scan_num_cnt_status < bist_wl_scan_num ) ; 

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        wl_scan_num_cnt_status_inner   <=  7'h0   ;
    end
    else begin
        wl_scan_num_cnt_status_inner   <= wl_scan_num_cnt_status  ;
    end
end
//-------------------------------gen_rd_times_cnt-----------------------------
always @(*) begin
    if(global_mc_bist_start)
        single_pattern_rd_times_cnt = 5'h0 ;
    else if(wl_scan_row_status || FSM_CS==WR_ADDR)
        single_pattern_rd_times_cnt = 5'h0 ;
    else if(wl_single_rd_done)
        single_pattern_rd_times_cnt = single_pattern_rd_times_cnt_inner + 1'b1 ;
    else 
        single_pattern_rd_times_cnt = single_pattern_rd_times_cnt_inner  ;
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
       single_pattern_rd_times_cnt_inner <= 5'h0   ;
   end
    else begin
       single_pattern_rd_times_cnt_inner <= single_pattern_rd_times_cnt ;
   end
end


assign wl_scan_rd_cnt_allow = (single_pattern_rd_times_cnt > 5'h0) && (single_pattern_rd_times_cnt < bist_wl_scan_single_pattern_rd_num+1'b1) ; 

assign wl_single_rd_done    = receive_row_addr == wl_scan_row_end_addr && (receive_col_addr == 7'h7F) && wl_scan_rvalid && data_noback_req_cnt==5'h1 ;

//----------------------------------------------------------------------------
//FSM design
//----------------------------------------------------------------------------
//20250408 add by hy
wire    s_fsm_cona;
wire    s_fsm_conb;
assign  s_fsm_cona = (wl_single_pattern_done && !wl_scan_num_cnt_allow && !wl_scan_rd_cnt_allow && !wl_scan_row_status);
assign  s_fsm_conb = (wl_scan_num_cnt_allow && frame_data_send_col_addr==7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy);
//end by hy

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
      if ( csl_scan_finish && global_mc_bist_en && mc_bist_en)
        FSM_NS = WR_ADDR;
      else
        FSM_NS = FSM_CS;
    end
    WR_ADDR: begin
      if (wl_scan_row_write_done)
        FSM_NS = RD_ADDR;
      else
        FSM_NS = FSM_CS;
    end 
    RD_ADDR : begin
        if(wl_single_pattern_done && wl_scan_num_cnt_allow && !wl_scan_rd_cnt_allow && !wl_scan_row_status)
          FSM_NS = WR_ADDR;
        else if(s_fsm_cona || (wl_scan_row_status && (s_fsm_conb ||(frame_data_send_col_addr==7'h0)))) //20250408 add by hy
        
          FSM_NS = IDLE;
        else
          FSM_NS = FSM_CS;
      end
    default: FSM_NS = IDLE;
endcase
end
//----------------------------------------------------------------------------
assign wl_scan_frame_data = {frame_data_rw_flag,frame_data_sof,frame_data_eof,frame_data,frame_data_send_row_addr,frame_data_send_col_addr} ;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        data_noback_req_cnt  <=  5'h0 ;
    end
    else if((wl_scan_frame_vld && wl_scan_frame_rdy && FSM_CS==RD_ADDR) && wl_scan_rvalid) begin
        data_noback_req_cnt  <=  data_noback_req_cnt   ;
    end
    else if(wl_scan_frame_vld && wl_scan_frame_rdy && FSM_CS==RD_ADDR) begin
        data_noback_req_cnt  <=  data_noback_req_cnt + 1'b1  ;
    end
    else if(wl_scan_rvalid) begin
        data_noback_req_cnt  <=  data_noback_req_cnt - 1'b1  ;
    end
end

/* azy
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        rd_frame_done <= 1'b0;
    else if(FSM_CS!=RD_ADDR)
        rd_frame_done <= 1'b0;
    else if(FSM_CS==RD_ADDR && !wl_scan_row_status && frame_data_send_col_addr==7'h7F && frame_data_send_row_addr==wl_scan_row_end_addr && wl_scan_frame_vld && wl_scan_frame_rdy)
        rd_frame_done <= 1'b1;
end
*/

//20250408 add by hy
wire    s_wl_scan_cona;
wire    s_wl_scan_conb;
assign  s_wl_scan_cona = (frame_data_send_col_addr==7'h7F && frame_data_send_row_addr==wl_scan_row_end_addr && wl_scan_frame_vld && wl_scan_frame_rdy && !wl_scan_row_status);
assign  s_wl_scan_conb = ((frame_data_send_col_addr==7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy) ||(frame_data_send_col_addr==7'h0));
//end by hy

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        wl_scan_frame_vld   <=  1'b0   ;
    end
    else if(FSM_CS==WR_ADDR) begin
        if(!wl_scan_row_write_done)
            wl_scan_frame_vld <= 1'b1  ;
        end
    else if(FSM_CS==RD_ADDR) begin
//        if((frame_data_send_col_addr==7'h7F && frame_data_send_row_addr==wl_scan_row_end_addr && wl_scan_frame_vld && wl_scan_frame_rdy && !wl_scan_row_status) || (wl_scan_row_status && ((frame_data_send_col_addr==7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy) ||(frame_data_send_col_addr==7'h0))))
        if(s_wl_scan_cona || (wl_scan_row_status && s_wl_scan_conb)) //20250408 add by hy
            wl_scan_frame_vld   <=  1'b0   ;
//azy
//        else if(!wl_scan_row_status && (frame_data_send_row_addr!=wl_scan_row_end_addr || frame_data_send_col_addr!=7'h7F || wl_scan_rd_cnt_allow) && !rd_frame_done)
//            wl_scan_frame_vld   <=  1'b1   ;
        else if(!wl_scan_row_status && wl_scan_rd_cnt_allow && wl_single_rd_done)
            wl_scan_frame_vld   <=  1'b1   ;
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
    if(FSM_CS==WR_ADDR && frame_data_send_col_addr==7'h0)
        frame_data_sof = 1'b1 ;
    else if(FSM_CS==RD_ADDR && frame_data_send_col_addr==7'h0)
        frame_data_sof = 1'b1 ;
    else
        frame_data_sof = 1'b0 ;
end
always @(*) begin  //eof
    if(FSM_CS==WR_ADDR && frame_data_send_col_addr==7'h7F)
        frame_data_eof = 1'b1 ;
    else if(FSM_CS==RD_ADDR && frame_data_send_col_addr==7'h7F)
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
        frame_data  <=  {bist_pattern_all[(pattern_index_reg*32+0)+:2],{33{bist_pattern_all[(pattern_index_reg*32+0)+:8]}}} ;
        else if(frame_data_send_row_addr[1:0]==2'b01)
        frame_data  <=  {bist_pattern_all[(pattern_index_reg*32+8)+:2],{33{bist_pattern_all[(pattern_index_reg*32+8)+:8]}}} ;
        else if(frame_data_send_row_addr[1:0]==2'b10)
        frame_data  <=  {bist_pattern_all[(pattern_index_reg*32+16)+:2],{33{bist_pattern_all[(pattern_index_reg*32+16)+:8]}}} ;
        else if(frame_data_send_row_addr[1:0]==2'b11)
        frame_data  <=  {bist_pattern_all[(pattern_index_reg*32+24)+:2],{33{bist_pattern_all[(pattern_index_reg*32+24)+:8]}}} ;
    end
    else if(FSM_CS==RD_ADDR) begin
        frame_data  <= 266'h0 ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        frame_data_send_col_addr  <=  7'h0 ;
    end
    else if(global_mc_bist_start)
        frame_data_send_col_addr  <=  7'h0 ;
    else if(FSM_CS == WR_ADDR) begin
        if(frame_data_send_col_addr == 7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_col_addr   <=  7'h0   ;
        else if(wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_ADDR) begin
        if((wl_single_pattern_done && !wl_scan_row_status) || (wl_scan_row_status && frame_data_send_col_addr==7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy)) 
            frame_data_send_col_addr   <=  7'h0   ;
         else if(frame_data_send_col_addr == 7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_col_addr   <=  7'h0   ;
//        else if(frame_data_send_row_addr!=wl_scan_row_end_addr && frame_data_send_col_addr==6'h3F && wl_scan_frame_vld && wl_scan_frame_rdy)
        else if(frame_data_send_col_addr!=7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy)
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
        if(frame_data_send_row_addr==wl_scan_row_end_addr && frame_data_send_col_addr == 7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_row_addr   <=  13'h0   ;
        else if(frame_data_send_col_addr == 7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_ADDR) begin
        if((wl_single_pattern_done && !wl_scan_row_status) || (wl_scan_row_status && frame_data_send_col_addr==7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy)) 
            frame_data_send_row_addr   <=  13'h0   ;
        else if(frame_data_send_row_addr == wl_scan_row_end_addr && frame_data_send_col_addr == 7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_row_addr   <=  13'h0   ;
        else if(frame_data_send_row_addr != wl_scan_row_end_addr && frame_data_send_col_addr == 7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
end

assign wl_scan_row_write_done = (FSM_CS==WR_ADDR) && (frame_data_send_row_addr == wl_scan_row_end_addr) && frame_data_send_col_addr==7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy; 
//----------------------------------------------------------------------------

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        receive_col_addr  <=  7'h0 ;
    end
    else if(global_mc_bist_start)
        receive_col_addr  <=  7'h0 ;
    else if(FSM_CS == RD_ADDR) begin
        if(wl_single_pattern_done) 
            receive_col_addr   <=  7'h0   ;
        else if(receive_row_addr == wl_scan_row_end_addr && receive_col_addr == 7'h7F && wl_scan_rvalid)
            receive_col_addr   <=  7'h0   ;
        else if(wl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        receive_row_addr  <=  13'h0 ;
    end
    else if(global_mc_bist_start)
        receive_row_addr  <=  13'h0 ;
    else if(FSM_CS == RD_ADDR) begin
        if(wl_single_pattern_done || (receive_row_addr == wl_scan_row_end_addr && receive_col_addr == 7'h7F && wl_scan_rvalid)) 
            receive_row_addr   <=  13'h0   ;
        else if(receive_col_addr == 7'h7F && wl_scan_rvalid)
            receive_row_addr   <= receive_row_addr + 1'b1 ;
    end
end
always @(*)begin
    if(FSM_CS==RD_ADDR) begin
        if(receive_row_addr[1:0]==2'b00)
        frame_golden_data  =  {bist_pattern_all[(pattern_index_reg*32+0)+:2],{33{bist_pattern_all[(pattern_index_reg*32+0)+:8]}}} ;
        else if(receive_row_addr[1:0]==2'b01)
        frame_golden_data  =  {bist_pattern_all[(pattern_index_reg*32+8)+:2],{33{bist_pattern_all[(pattern_index_reg*32+8)+:8]}}} ;
        else if(receive_row_addr[1:0]==2'b10)
        frame_golden_data  =  {bist_pattern_all[(pattern_index_reg*32+16)+:2],{33{bist_pattern_all[(pattern_index_reg*32+16)+:8]}}} ;
        else if(receive_row_addr[1:0]==2'b11)
        frame_golden_data  =  {bist_pattern_all[(pattern_index_reg*32+24)+:2],{33{bist_pattern_all[(pattern_index_reg*32+24)+:8]}}} ;
        else
        frame_golden_data  = 266'h0 ;
    end
    else begin
        frame_golden_data  = 266'h0 ;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_wl_store  <=  {64{13'h1FFF}} ;
    end
    else if(global_bist_clr) begin
        err_wl_store  <=  {64{13'h1FFF}} ;
    end
    else if(FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same && (wl_scan_err_cnt<7'd64)) begin 
        err_wl_store  <=  {err_wl_store[63*13-1:0],receive_row_addr} ;
    end
end




assign err_wl_same = (err_wl_store[63*13+:13]==receive_row_addr)||(err_wl_store[62*13+:13]==receive_row_addr)||(err_wl_store[61*13+:13]==receive_row_addr)||
(err_wl_store[60*13+:13]==receive_row_addr)||(err_wl_store[59*13+:13]==receive_row_addr)||(err_wl_store[58*13+:13]==receive_row_addr)||
(err_wl_store[57*13+:13]==receive_row_addr)||(err_wl_store[56*13+:13]==receive_row_addr)||(err_wl_store[55*13+:13]==receive_row_addr)||
(err_wl_store[54*13+:13]==receive_row_addr)||(err_wl_store[53*13+:13]==receive_row_addr)||(err_wl_store[52*13+:13]==receive_row_addr)||
(err_wl_store[51*13+:13]==receive_row_addr)||(err_wl_store[50*13+:13]==receive_row_addr)||(err_wl_store[49*13+:13]==receive_row_addr)||
(err_wl_store[48*13+:13]==receive_row_addr)||(err_wl_store[47*13+:13]==receive_row_addr)||(err_wl_store[46*13+:13]==receive_row_addr)||
(err_wl_store[45*13+:13]==receive_row_addr)||(err_wl_store[44*13+:13]==receive_row_addr)||(err_wl_store[43*13+:13]==receive_row_addr)||
(err_wl_store[42*13+:13]==receive_row_addr)||(err_wl_store[41*13+:13]==receive_row_addr)||(err_wl_store[40*13+:13]==receive_row_addr)||
(err_wl_store[39*13+:13]==receive_row_addr)||(err_wl_store[38*13+:13]==receive_row_addr)||(err_wl_store[37*13+:13]==receive_row_addr)||
(err_wl_store[36*13+:13]==receive_row_addr)||(err_wl_store[35*13+:13]==receive_row_addr)||(err_wl_store[34*13+:13]==receive_row_addr)||
(err_wl_store[33*13+:13]==receive_row_addr)||(err_wl_store[32*13+:13]==receive_row_addr)||(err_wl_store[31*13+:13]==receive_row_addr)||
(err_wl_store[30*13+:13]==receive_row_addr)||(err_wl_store[29*13+:13]==receive_row_addr)||(err_wl_store[28*13+:13]==receive_row_addr)||
(err_wl_store[27*13+:13]==receive_row_addr)||(err_wl_store[26*13+:13]==receive_row_addr)||(err_wl_store[25*13+:13]==receive_row_addr)||
(err_wl_store[24*13+:13]==receive_row_addr)||(err_wl_store[23*13+:13]==receive_row_addr)||(err_wl_store[22*13+:13]==receive_row_addr)||
(err_wl_store[21*13+:13]==receive_row_addr)||(err_wl_store[20*13+:13]==receive_row_addr)||(err_wl_store[19*13+:13]==receive_row_addr)||
(err_wl_store[18*13+:13]==receive_row_addr)||(err_wl_store[17*13+:13]==receive_row_addr)||(err_wl_store[16*13+:13]==receive_row_addr)||
(err_wl_store[15*13+:13]==receive_row_addr)||(err_wl_store[14*13+:13]==receive_row_addr)||(err_wl_store[13*13+:13]==receive_row_addr)||
(err_wl_store[12*13+:13]==receive_row_addr)||(err_wl_store[11*13+:13]==receive_row_addr)||(err_wl_store[10*13+:13]==receive_row_addr)||
(err_wl_store[9*13+:13]==receive_row_addr)||(err_wl_store[8*13+:13]==receive_row_addr)||(err_wl_store[7*13+:13]==receive_row_addr)||
(err_wl_store[6*13+:13]==receive_row_addr)||(err_wl_store[5*13+:13]==receive_row_addr)||(err_wl_store[4*13+:13]==receive_row_addr)||
(err_wl_store[3*13+:13]==receive_row_addr)||(err_wl_store[2*13+:13]==receive_row_addr)||(err_wl_store[1*13+:13]==receive_row_addr)||
(err_wl_store[0*13+:13]==receive_row_addr);

assign wl_scan_err_cnt = (err_wl_store[63*13+:13]!=13'h1FFF)+(err_wl_store[62*13+:13]!=13'h1FFF)+(err_wl_store[61*13+:13]!=13'h1FFF)+(err_wl_store[60*13+:13]!=13'h1FFF)+
(err_wl_store[59*13+:13]!=13'h1FFF)+(err_wl_store[58*13+:13]!=13'h1FFF)+(err_wl_store[57*13+:13]!=13'h1FFF)+(err_wl_store[56*13+:13]!=13'h1FFF)+
(err_wl_store[55*13+:13]!=13'h1FFF)+(err_wl_store[54*13+:13]!=13'h1FFF)+(err_wl_store[53*13+:13]!=13'h1FFF)+(err_wl_store[52*13+:13]!=13'h1FFF)+
(err_wl_store[51*13+:13]!=13'h1FFF)+(err_wl_store[50*13+:13]!=13'h1FFF)+(err_wl_store[49*13+:13]!=13'h1FFF)+(err_wl_store[48*13+:13]!=13'h1FFF)+
(err_wl_store[47*13+:13]!=13'h1FFF)+(err_wl_store[46*13+:13]!=13'h1FFF)+(err_wl_store[45*13+:13]!=13'h1FFF)+(err_wl_store[44*13+:13]!=13'h1FFF)+
(err_wl_store[43*13+:13]!=13'h1FFF)+(err_wl_store[42*13+:13]!=13'h1FFF)+(err_wl_store[41*13+:13]!=13'h1FFF)+(err_wl_store[40*13+:13]!=13'h1FFF)+
(err_wl_store[39*13+:13]!=13'h1FFF)+(err_wl_store[38*13+:13]!=13'h1FFF)+(err_wl_store[37*13+:13]!=13'h1FFF)+(err_wl_store[36*13+:13]!=13'h1FFF)+
(err_wl_store[35*13+:13]!=13'h1FFF)+(err_wl_store[34*13+:13]!=13'h1FFF)+(err_wl_store[33*13+:13]!=13'h1FFF)+(err_wl_store[32*13+:13]!=13'h1FFF)+
(err_wl_store[31*13+:13]!=13'h1FFF)+(err_wl_store[30*13+:13]!=13'h1FFF)+(err_wl_store[29*13+:13]!=13'h1FFF)+(err_wl_store[28*13+:13]!=13'h1FFF)+
(err_wl_store[27*13+:13]!=13'h1FFF)+(err_wl_store[26*13+:13]!=13'h1FFF)+(err_wl_store[25*13+:13]!=13'h1FFF)+(err_wl_store[24*13+:13]!=13'h1FFF)+
(err_wl_store[23*13+:13]!=13'h1FFF)+(err_wl_store[22*13+:13]!=13'h1FFF)+(err_wl_store[21*13+:13]!=13'h1FFF)+(err_wl_store[20*13+:13]!=13'h1FFF)+
(err_wl_store[19*13+:13]!=13'h1FFF)+(err_wl_store[18*13+:13]!=13'h1FFF)+(err_wl_store[17*13+:13]!=13'h1FFF)+(err_wl_store[16*13+:13]!=13'h1FFF)+
(err_wl_store[15*13+:13]!=13'h1FFF)+(err_wl_store[14*13+:13]!=13'h1FFF)+(err_wl_store[13*13+:13]!=13'h1FFF)+(err_wl_store[12*13+:13]!=13'h1FFF)+
(err_wl_store[11*13+:13]!=13'h1FFF)+(err_wl_store[10*13+:13]!=13'h1FFF)+(err_wl_store[9*13+:13]!=13'h1FFF)+(err_wl_store[8*13+:13]!=13'h1FFF)+
(err_wl_store[7*13+:13]!=13'h1FFF)+(err_wl_store[6*13+:13]!=13'h1FFF)+(err_wl_store[5*13+:13]!=13'h1FFF)+(err_wl_store[4*13+:13]!=13'h1FFF)+
(err_wl_store[3*13+:13]!=13'h1FFF)+(err_wl_store[2*13+:13]!=13'h1FFF)+(err_wl_store[1*13+:13]!=13'h1FFF)+(err_wl_store[0*13+:13]!=13'h1FFF) ;



always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bist_wl_fail  <=  1'b0 ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bist_wl_fail  <=  1'b0 ;
    end
    else if(FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same && (wl_scan_err_cnt==7'd64)) begin 
        bist_wl_fail  <=  1'b1 ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
       wl_scan_row_status_r <= 1'b0;
    else 
       wl_scan_row_status_r  <= wl_scan_row_status;
end
assign  wl_scan_row_status_pos = wl_scan_row_status && !wl_scan_row_status_r ;

assign bist_wl_success = bist_wl_finish && !bist_wl_fail ;

assign wl_scan_row_status = bist_wl_fail ;

assign wl_single_pattern_done = ((!bist_wl_fail && receive_row_addr == wl_scan_row_end_addr) && (receive_col_addr == 7'h7F) && !wl_scan_rd_cnt_allow && wl_scan_rvalid && data_noback_req_cnt==5'h1 )|| wl_scan_row_status_pos;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bist_wl_finish   <=  1'b0   ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bist_wl_finish   <=  1'b0   ;
    end
    else if((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (wl_scan_row_status && data_noback_req_cnt==5'h0)) begin
        bist_wl_finish   <=  1'b1   ;
    end
end

assign wl_scan_working = (FSM_CS==WR_ADDR || FSM_CS==RD_ADDR) ;


assign {err_wl63,err_wl62,err_wl61,err_wl60,err_wl59,err_wl58,err_wl57,err_wl56,err_wl55,err_wl54,err_wl53,err_wl52,
        err_wl51,err_wl50,err_wl49,err_wl48,err_wl47,err_wl46,err_wl45,err_wl44,err_wl43,err_wl42,err_wl41,err_wl40,
        err_wl39,err_wl38,err_wl37,err_wl36,err_wl35,err_wl34,err_wl33,err_wl32,err_wl31,err_wl30,err_wl29,err_wl28,
        err_wl27,err_wl26,err_wl25,err_wl24,err_wl23,err_wl22,err_wl21,err_wl20,err_wl19,err_wl18,err_wl17,err_wl16,
        err_wl15,err_wl14,err_wl13,err_wl12,err_wl11,err_wl10,err_wl9,err_wl8,err_wl7,err_wl6,err_wl5,err_wl4,
        err_wl3,err_wl2,err_wl1,err_wl0 } = err_wl_store ; 
        
        
endmodule
