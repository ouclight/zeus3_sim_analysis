module wl_scan_top_aux #(
    parameter   ARRAY_ADDR_WIDTH      = 13+8                               ,
    parameter   MC_SHORT_MODE         = 4                                  ,
    parameter   CHECKBIT_WIDTH        = 16                                 ,
    parameter   ARRAY_ROW_ADDR_WIDTH  = 13                                 ,
    parameter   ARRAY_COL_ADDR_WIDTH  = 8                                  ,
    parameter   ARRAY_DATA_WIDTH      = 256  
)
(
  //-------------clock and reset signal--------------
  input                                                                    clk                                 ,
  input                                                                    rst_n                               ,
  //-------------control signal----------------------                             
  input      [1:0]                                                         bist_layer_id                       ,
  input      [2:0]                                                         bist_scan_fsm                       ,

  input                                                                    global_mc_bist_start                ,
  input                                                                    global_mc_bist_en                   ,
  input                                                                    mc_bist_en                          ,
  input                                                                    global_bist_clr                     ,
  
  input                                                                    csl_scan_finish                     ,
													                         				                  
  input      [3:0]                                                         wl_single_pattern_rd_num            ,//max 16,default 0:read one time
  
  input      [68*32-1:0]                                                   bist_pattern_all                    ,
  input      [67:0]                                                        wl_bist_pattern_sel                 ,
    
  output     [MC_SHORT_MODE-1:0]                                           bank_bist_wl_success               ,
  output     [MC_SHORT_MODE-1:0]                                           bank_bist_wl_finish                ,

  input                                                                    bist_finish_clr                     ,
  output                                                                   wl_scan_working                     ,
                                                                                        
  output     [7*MC_SHORT_MODE-1:0]                                         bank_err_wl_cnt                     ,

  output     [MC_SHORT_MODE-1:0]                                           bank_err_wl_cnt_change_flag         ,//1:diff 0: same
  //-------------data signal------------------------                                                           
  output reg                                                               wl_scan_frame_vld                   ,
  input                                                                    wl_scan_frame_rdy                   ,
  output     [3+CHECKBIT_WIDTH+ARRAY_DATA_WIDTH+ARRAY_ADDR_WIDTH+2-2 :0]   wl_scan_frame_data                  ,//rw_flag,sof,eof,data,row,col
  input                                                                    wl_scan_rvalid                      ,
  input      [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                         wl_scan_rdata                       ,
  //-------------error wl record signal------------
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl0                             ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl1                             ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl2                             ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl3                             ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl4                             ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl5                             ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl6                             ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl7                             ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl8                             ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl9                             ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl10                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl11                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl12                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl13                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl14                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl15                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl16                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl17                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl18                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl19                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl20                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl21                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl22                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl23                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl24                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl25                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl26                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl27                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl28                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl29                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl30                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl31                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl32                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl33                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl34                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl35                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl36                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl37                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl38                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl39                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl40                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl41                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl42                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl43                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl44                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl45                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl46                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl47                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl48                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl49                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl50                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl51                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl52                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl53                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl54                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl55                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl56                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl57                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl58                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl59                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl60                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl61                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl62                            ,
  output     [MC_SHORT_MODE*ARRAY_ROW_ADDR_WIDTH-1:0]                      err_wl63                 


);


//wire and reg
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                wl_scan_row_end_addr               ;

reg    [6:0]                                     wl_scan_num_cnt_status             ;
reg                                              wl_scan_row_status                 ;
wire   [6:0]                                     wl_scan_err_cnt                    ;

wire                                             wl_scan_row_write_done             ;
wire                                             wl_single_pattern_done             ;

reg    [6:0]                                     wl_scan_num_cnt_status_inner       ;
wire                                             wl_scan_num_cnt_allow              ;

reg                                              frame_data_rw_flag                 ;
reg                                              frame_data_sof                     ;
reg                                              frame_data_eof                     ;
reg    [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]     frame_data                         ;
reg    [ARRAY_COL_ADDR_WIDTH-2:0]                frame_data_send_col_addr           ;
reg    [ARRAY_ROW_ADDR_WIDTH-1:0]                frame_data_send_row_addr           ;
reg    [ARRAY_COL_ADDR_WIDTH-2:0]                receive_col_addr                   ;
reg    [ARRAY_ROW_ADDR_WIDTH-1:0]                receive_row_addr                   ;

reg    [4:0]                                     data_noback_req_cnt                ; //data no back, read request cnt
																		            
reg    [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]     frame_golden_data                  ;
																		            




reg                                              wl_scan_row_status_r               ;
wire                                             wl_scan_row_status_pos             ;

reg    [4:0]                                     single_pattern_rd_times_cnt_inner  ;
reg    [4:0]                                     single_pattern_rd_times_cnt        ;
wire                                             wl_single_rd_done                  ;
wire                                             wl_scan_rd_cnt_allow               ;


wire   [6:0]                                     bist_wl_scan_num                   ;
reg    [6:0]                                     wl_pattern_cnt                     ;
reg    [6:0]                                     pattern_index                      ;
reg    [6:0]                                     pattern_index_reg                  ;
reg    [67:0]                                    wl_bist_pattern_sel_new            ;

integer                                          II                                 ;
integer                                          KK                                 ;

//--------------------------------------------------
`ifndef BIST_SIM
assign  wl_scan_row_end_addr = 13'h1CC0 - 1'b1;//7360
`else
assign  wl_scan_row_end_addr   =  13'd299;//14719
`endif

localparam 
           BANK0      = 3'b001,
           BANK1      = 3'b010,
           BANK2      = 3'b011,
           BANK3      = 3'b100 ;


always @(*)begin
    wl_pattern_cnt = 7'h0;
    for(II=0;II<68;II=II+1)begin:gen_wl_pattern_cnt
        if(wl_bist_pattern_sel[II]==1'b1)begin
            wl_pattern_cnt = wl_pattern_cnt + 1'b1;
        end
    end
end

assign  bist_wl_scan_num =  wl_pattern_cnt; 


localparam  IDLE                 = 2'b00   ,
            WR_ADDR              = 2'b01   ,
            RD_ADDR              = 2'b11   ;


            

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


assign wl_scan_rd_cnt_allow = (single_pattern_rd_times_cnt > 5'h0) && (single_pattern_rd_times_cnt < wl_single_pattern_rd_num+1'b1) ; 

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
      if (csl_scan_finish && global_mc_bist_en && mc_bist_en)
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
assign wl_scan_frame_data = {frame_data_rw_flag,frame_data_sof,frame_data_eof,frame_data,bist_layer_id,frame_data_send_row_addr,frame_data_send_col_addr} ;

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
        if(s_wl_scan_cona || (wl_scan_row_status && s_wl_scan_conb)) //20250408 add by hy
            wl_scan_frame_vld   <=  1'b0   ;
        else if(!wl_scan_row_status && wl_scan_rd_cnt_allow && wl_single_rd_done)
            wl_scan_frame_vld   <=  1'b1   ;
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
        frame_data  <=  {CHECKBIT_WIDTH+ARRAY_DATA_WIDTH{1'h0}}  ;
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
    else if(FSM_CS==RD_ADDR) begin
        frame_data  <= {CHECKBIT_WIDTH+ARRAY_DATA_WIDTH{1'h0}}  ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        frame_data_send_col_addr  <=  {ARRAY_COL_ADDR_WIDTH-1{1'h0}}  ;
    end
    else if(global_mc_bist_start)
        frame_data_send_col_addr  <=  {ARRAY_COL_ADDR_WIDTH-1{1'h0}}  ;
    else if(FSM_CS == WR_ADDR) begin
        if(frame_data_send_col_addr == {ARRAY_COL_ADDR_WIDTH-1{1'h1}} && wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH-1{1'h0}}    ;
        else if(wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_ADDR) begin
        if((wl_single_pattern_done && !wl_scan_row_status) || (wl_scan_row_status && frame_data_send_col_addr=={ARRAY_COL_ADDR_WIDTH-1{1'h1}} && wl_scan_frame_vld && wl_scan_frame_rdy)) 
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH-1{1'h0}}    ;
         else if(frame_data_send_col_addr == 7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_col_addr   <=  {ARRAY_COL_ADDR_WIDTH-1{1'h0}}    ;
//        else if(frame_data_send_row_addr!=wl_scan_row_end_addr && frame_data_send_col_addr==6'h3F && wl_scan_frame_vld && wl_scan_frame_rdy)
        else if(frame_data_send_col_addr!= {ARRAY_COL_ADDR_WIDTH-1{1'h1}} && wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_col_addr   <= frame_data_send_col_addr + 1'b1 ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        frame_data_send_row_addr  <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}} ;
    end
    else if(global_mc_bist_start)
        frame_data_send_row_addr  <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}} ;
    else if(FSM_CS == WR_ADDR) begin
        if(frame_data_send_row_addr==wl_scan_row_end_addr && frame_data_send_col_addr == {ARRAY_COL_ADDR_WIDTH-1{1'h1}} && wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_col_addr == {ARRAY_COL_ADDR_WIDTH-1{1'h1}} && wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
    else if(FSM_CS == RD_ADDR) begin
        if((wl_single_pattern_done && !wl_scan_row_status) || (wl_scan_row_status && frame_data_send_col_addr=={ARRAY_COL_ADDR_WIDTH-1{1'h1}} && wl_scan_frame_vld && wl_scan_frame_rdy)) 
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr == wl_scan_row_end_addr && frame_data_send_col_addr == {ARRAY_COL_ADDR_WIDTH-1{1'h1}} && wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(frame_data_send_row_addr != wl_scan_row_end_addr && frame_data_send_col_addr == {ARRAY_COL_ADDR_WIDTH-1{1'h1}} && wl_scan_frame_vld && wl_scan_frame_rdy)
            frame_data_send_row_addr   <= frame_data_send_row_addr + 1'b1 ;
    end
end

assign wl_scan_row_write_done = (FSM_CS==WR_ADDR) && (frame_data_send_row_addr == wl_scan_row_end_addr) && frame_data_send_col_addr==7'h7F && wl_scan_frame_vld && wl_scan_frame_rdy; 
//----------------------------------------------------------------------------

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        receive_col_addr  <= {ARRAY_COL_ADDR_WIDTH-1{1'h0}}  ;
    end
    else if(global_mc_bist_start)
        receive_col_addr  <=  {ARRAY_COL_ADDR_WIDTH-1{1'h0}} ;
    else if(FSM_CS == RD_ADDR) begin
        if(wl_single_pattern_done) 
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH-1{1'h0}}   ;
        else if(receive_row_addr == wl_scan_row_end_addr && receive_col_addr == {ARRAY_COL_ADDR_WIDTH-1{1'h1}} && wl_scan_rvalid)
            receive_col_addr   <=  {ARRAY_COL_ADDR_WIDTH-1{1'h0}}   ;
        else if(wl_scan_rvalid)
            receive_col_addr   <= receive_col_addr + 1'b1 ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        receive_row_addr  <= {ARRAY_ROW_ADDR_WIDTH{1'h0}}  ;
    end
    else if(global_mc_bist_start)
        receive_row_addr  <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}} ;
    else if(FSM_CS == RD_ADDR) begin
        if(wl_single_pattern_done || (receive_row_addr == wl_scan_row_end_addr && receive_col_addr == {ARRAY_COL_ADDR_WIDTH-1{1'h1}} && wl_scan_rvalid)) 
            receive_row_addr   <=  {ARRAY_ROW_ADDR_WIDTH{1'h0}}   ;
        else if(receive_col_addr == {ARRAY_COL_ADDR_WIDTH-1{1'h1}} && wl_scan_rvalid)
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




////output err wl
generate
if(MC_SHORT_MODE==4)begin:inst0

wire   [6:0]                                     bank0_err_wl_cnt                   ; 
wire   [6:0]                                     bank1_err_wl_cnt                   ; 
wire   [6:0]                                     bank2_err_wl_cnt                   ; 
wire   [6:0]                                     bank3_err_wl_cnt                   ; 
reg    [ARRAY_ROW_ADDR_WIDTH*64-1:0]             err_wl_store0                      ;
reg    [ARRAY_ROW_ADDR_WIDTH*64-1:0]             err_wl_store1                      ;
reg    [ARRAY_ROW_ADDR_WIDTH*64-1:0]             err_wl_store2                      ;
reg    [ARRAY_ROW_ADDR_WIDTH*64-1:0]             err_wl_store3                      ;

wire                                             err_wl_same0                       ;
wire                                             err_wl_same1                       ;
wire                                             err_wl_same2                       ;
wire                                             err_wl_same3                       ;    

reg                                              bank0_bist_wl_fail                 ;
reg                                              bank1_bist_wl_fail                 ;
reg                                              bank2_bist_wl_fail                 ;
reg                                              bank3_bist_wl_fail                 ;


wire                                             bank0_bist_wl_success              ; 
wire                                             bank1_bist_wl_success              ; 
wire                                             bank2_bist_wl_success              ; 
wire                                             bank3_bist_wl_success              ; 



reg                                              bank0_bist_wl_finish               ;
reg                                              bank1_bist_wl_finish               ;
reg                                              bank2_bist_wl_finish               ;
reg                                              bank3_bist_wl_finish               ;
reg                                              bank0_err_wl_cnt_change_flag       ; //1:diff 0: same
reg                                              bank1_err_wl_cnt_change_flag       ; 
reg                                              bank2_err_wl_cnt_change_flag       ; 
reg                                              bank3_err_wl_cnt_change_flag       ; 
reg    [6:0]                                     bank0_err_wl_cnt_r                 ;
reg    [6:0]                                     bank1_err_wl_cnt_r                 ;
reg    [6:0]                                     bank2_err_wl_cnt_r                 ;
reg    [6:0]                                     bank3_err_wl_cnt_r                 ;

wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl0                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl1                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl2                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl3                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl4                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl5                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl6                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl7                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl8                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl9                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl10                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl11                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl12                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl13                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl14                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl15                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl16                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl17                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl18                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl19                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl20                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl21                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl22                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl23                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl24                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl25                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl26                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl27                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl28                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl29                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl30                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl31                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl32                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl33                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl34                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl35                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl36                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl37                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl38                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl39                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl40                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl41                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl42                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl43                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl44                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl45                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl46                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl47                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl48                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl49                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl50                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl51                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl52                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl53                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl54                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl55                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl56                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl57                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl58                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl59                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl60                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl61                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl62                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl63                     ;

wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl0                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl1                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl2                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl3                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl4                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl5                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl6                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl7                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl8                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl9                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl10                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl11                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl12                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl13                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl14                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl15                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl16                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl17                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl18                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl19                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl20                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl21                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl22                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl23                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl24                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl25                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl26                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl27                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl28                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl29                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl30                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl31                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl32                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl33                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl34                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl35                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl36                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl37                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl38                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl39                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl40                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl41                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl42                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl43                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl44                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl45                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl46                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl47                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl48                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl49                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl50                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl51                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl52                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl53                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl54                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl55                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl56                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl57                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl58                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl59                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl60                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl61                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl62                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl63                     ;


wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl0                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl1                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl2                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl3                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl4                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl5                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl6                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl7                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl8                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl9                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl10                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl11                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl12                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl13                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl14                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl15                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl16                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl17                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl18                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl19                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl20                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl21                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl22                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl23                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl24                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl25                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl26                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl27                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl28                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl29                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl30                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl31                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl32                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl33                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl34                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl35                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl36                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl37                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl38                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl39                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl40                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl41                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl42                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl43                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl44                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl45                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl46                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl47                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl48                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl49                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl50                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl51                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl52                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl53                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl54                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl55                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl56                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl57                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl58                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl59                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl60                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl61                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl62                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl63                     ;



wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl0                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl1                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl2                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl3                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl4                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl5                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl6                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl7                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl8                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl9                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl10                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl11                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl12                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl13                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl14                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl15                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl16                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl17                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl18                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl19                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl20                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl21                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl22                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl23                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl24                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl25                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl26                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl27                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl28                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl29                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl30                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl31                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl32                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl33                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl34                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl35                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl36                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl37                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl38                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl39                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl40                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl41                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl42                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl43                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl44                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl45                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl46                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl47                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl48                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl49                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl50                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl51                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl52                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl53                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl54                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl55                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl56                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl57                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl58                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl59                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl60                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl61                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl62                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank3_err_wl63                     ;

////--------------------bank0------------------------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_wl_store0  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(global_bist_clr) begin
        err_wl_store0  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(bist_scan_fsm==BANK0 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same0 && (bank0_err_wl_cnt<7'd64)) begin 
        err_wl_store0  <=  {err_wl_store0[63*ARRAY_ROW_ADDR_WIDTH-1:0],receive_row_addr} ;
    end
end

assign err_wl_same0 = bist_scan_fsm==BANK0 ? 
((err_wl_store0[63*13+:13]==receive_row_addr)||(err_wl_store0[62*13+:13]==receive_row_addr)||(err_wl_store0[61*13+:13]==receive_row_addr)||
(err_wl_store0[60*13+:13]==receive_row_addr)||(err_wl_store0[59*13+:13]==receive_row_addr)||(err_wl_store0[58*13+:13]==receive_row_addr)||
(err_wl_store0[57*13+:13]==receive_row_addr)||(err_wl_store0[56*13+:13]==receive_row_addr)||(err_wl_store0[55*13+:13]==receive_row_addr)||
(err_wl_store0[54*13+:13]==receive_row_addr)||(err_wl_store0[53*13+:13]==receive_row_addr)||(err_wl_store0[52*13+:13]==receive_row_addr)||
(err_wl_store0[51*13+:13]==receive_row_addr)||(err_wl_store0[50*13+:13]==receive_row_addr)||(err_wl_store0[49*13+:13]==receive_row_addr)||
(err_wl_store0[48*13+:13]==receive_row_addr)||(err_wl_store0[47*13+:13]==receive_row_addr)||(err_wl_store0[46*13+:13]==receive_row_addr)||
(err_wl_store0[45*13+:13]==receive_row_addr)||(err_wl_store0[44*13+:13]==receive_row_addr)||(err_wl_store0[43*13+:13]==receive_row_addr)||
(err_wl_store0[42*13+:13]==receive_row_addr)||(err_wl_store0[41*13+:13]==receive_row_addr)||(err_wl_store0[40*13+:13]==receive_row_addr)||
(err_wl_store0[39*13+:13]==receive_row_addr)||(err_wl_store0[38*13+:13]==receive_row_addr)||(err_wl_store0[37*13+:13]==receive_row_addr)||
(err_wl_store0[36*13+:13]==receive_row_addr)||(err_wl_store0[35*13+:13]==receive_row_addr)||(err_wl_store0[34*13+:13]==receive_row_addr)||
(err_wl_store0[33*13+:13]==receive_row_addr)||(err_wl_store0[32*13+:13]==receive_row_addr)||(err_wl_store0[31*13+:13]==receive_row_addr)||
(err_wl_store0[30*13+:13]==receive_row_addr)||(err_wl_store0[29*13+:13]==receive_row_addr)||(err_wl_store0[28*13+:13]==receive_row_addr)||
(err_wl_store0[27*13+:13]==receive_row_addr)||(err_wl_store0[26*13+:13]==receive_row_addr)||(err_wl_store0[25*13+:13]==receive_row_addr)||
(err_wl_store0[24*13+:13]==receive_row_addr)||(err_wl_store0[23*13+:13]==receive_row_addr)||(err_wl_store0[22*13+:13]==receive_row_addr)||
(err_wl_store0[21*13+:13]==receive_row_addr)||(err_wl_store0[20*13+:13]==receive_row_addr)||(err_wl_store0[19*13+:13]==receive_row_addr)||
(err_wl_store0[18*13+:13]==receive_row_addr)||(err_wl_store0[17*13+:13]==receive_row_addr)||(err_wl_store0[16*13+:13]==receive_row_addr)||
(err_wl_store0[15*13+:13]==receive_row_addr)||(err_wl_store0[14*13+:13]==receive_row_addr)||(err_wl_store0[13*13+:13]==receive_row_addr)||
(err_wl_store0[12*13+:13]==receive_row_addr)||(err_wl_store0[11*13+:13]==receive_row_addr)||(err_wl_store0[10*13+:13]==receive_row_addr)||
(err_wl_store0[9*13+:13]==receive_row_addr)||(err_wl_store0[8*13+:13]==receive_row_addr)||(err_wl_store0[7*13+:13]==receive_row_addr)||
(err_wl_store0[6*13+:13]==receive_row_addr)||(err_wl_store0[5*13+:13]==receive_row_addr)||(err_wl_store0[4*13+:13]==receive_row_addr)||
(err_wl_store0[3*13+:13]==receive_row_addr)||(err_wl_store0[2*13+:13]==receive_row_addr)||(err_wl_store0[1*13+:13]==receive_row_addr)||
(err_wl_store0[0*13+:13]==receive_row_addr)) : 1'b0;

assign bank0_err_wl_cnt = 
(err_wl_store0[63*13+:13]!=13'h1FFF)+(err_wl_store0[62*13+:13]!=13'h1FFF)+(err_wl_store0[61*13+:13]!=13'h1FFF)+(err_wl_store0[60*13+:13]!=13'h1FFF)+
(err_wl_store0[59*13+:13]!=13'h1FFF)+(err_wl_store0[58*13+:13]!=13'h1FFF)+(err_wl_store0[57*13+:13]!=13'h1FFF)+(err_wl_store0[56*13+:13]!=13'h1FFF)+
(err_wl_store0[55*13+:13]!=13'h1FFF)+(err_wl_store0[54*13+:13]!=13'h1FFF)+(err_wl_store0[53*13+:13]!=13'h1FFF)+(err_wl_store0[52*13+:13]!=13'h1FFF)+
(err_wl_store0[51*13+:13]!=13'h1FFF)+(err_wl_store0[50*13+:13]!=13'h1FFF)+(err_wl_store0[49*13+:13]!=13'h1FFF)+(err_wl_store0[48*13+:13]!=13'h1FFF)+
(err_wl_store0[47*13+:13]!=13'h1FFF)+(err_wl_store0[46*13+:13]!=13'h1FFF)+(err_wl_store0[45*13+:13]!=13'h1FFF)+(err_wl_store0[44*13+:13]!=13'h1FFF)+
(err_wl_store0[43*13+:13]!=13'h1FFF)+(err_wl_store0[42*13+:13]!=13'h1FFF)+(err_wl_store0[41*13+:13]!=13'h1FFF)+(err_wl_store0[40*13+:13]!=13'h1FFF)+
(err_wl_store0[39*13+:13]!=13'h1FFF)+(err_wl_store0[38*13+:13]!=13'h1FFF)+(err_wl_store0[37*13+:13]!=13'h1FFF)+(err_wl_store0[36*13+:13]!=13'h1FFF)+
(err_wl_store0[35*13+:13]!=13'h1FFF)+(err_wl_store0[34*13+:13]!=13'h1FFF)+(err_wl_store0[33*13+:13]!=13'h1FFF)+(err_wl_store0[32*13+:13]!=13'h1FFF)+
(err_wl_store0[31*13+:13]!=13'h1FFF)+(err_wl_store0[30*13+:13]!=13'h1FFF)+(err_wl_store0[29*13+:13]!=13'h1FFF)+(err_wl_store0[28*13+:13]!=13'h1FFF)+
(err_wl_store0[27*13+:13]!=13'h1FFF)+(err_wl_store0[26*13+:13]!=13'h1FFF)+(err_wl_store0[25*13+:13]!=13'h1FFF)+(err_wl_store0[24*13+:13]!=13'h1FFF)+
(err_wl_store0[23*13+:13]!=13'h1FFF)+(err_wl_store0[22*13+:13]!=13'h1FFF)+(err_wl_store0[21*13+:13]!=13'h1FFF)+(err_wl_store0[20*13+:13]!=13'h1FFF)+
(err_wl_store0[19*13+:13]!=13'h1FFF)+(err_wl_store0[18*13+:13]!=13'h1FFF)+(err_wl_store0[17*13+:13]!=13'h1FFF)+(err_wl_store0[16*13+:13]!=13'h1FFF)+
(err_wl_store0[15*13+:13]!=13'h1FFF)+(err_wl_store0[14*13+:13]!=13'h1FFF)+(err_wl_store0[13*13+:13]!=13'h1FFF)+(err_wl_store0[12*13+:13]!=13'h1FFF)+
(err_wl_store0[11*13+:13]!=13'h1FFF)+(err_wl_store0[10*13+:13]!=13'h1FFF)+(err_wl_store0[9*13+:13]!=13'h1FFF)+(err_wl_store0[8*13+:13]!=13'h1FFF)+
(err_wl_store0[7*13+:13]!=13'h1FFF)+(err_wl_store0[6*13+:13]!=13'h1FFF)+(err_wl_store0[5*13+:13]!=13'h1FFF)+(err_wl_store0[4*13+:13]!=13'h1FFF)+
(err_wl_store0[3*13+:13]!=13'h1FFF)+(err_wl_store0[2*13+:13]!=13'h1FFF)+(err_wl_store0[1*13+:13]!=13'h1FFF)+(err_wl_store0[0*13+:13]!=13'h1FFF) ;

assign {bank0_err_wl63,bank0_err_wl62,bank0_err_wl61,bank0_err_wl60,bank0_err_wl59,bank0_err_wl58,bank0_err_wl57,bank0_err_wl56,bank0_err_wl55,bank0_err_wl54,
        bank0_err_wl53,bank0_err_wl52,bank0_err_wl51,bank0_err_wl50,bank0_err_wl49,bank0_err_wl48,bank0_err_wl47,bank0_err_wl46,bank0_err_wl45,bank0_err_wl44,
        bank0_err_wl43,bank0_err_wl42,bank0_err_wl41,bank0_err_wl40,bank0_err_wl39,bank0_err_wl38,bank0_err_wl37,bank0_err_wl36,bank0_err_wl35,bank0_err_wl34,
        bank0_err_wl33,bank0_err_wl32,bank0_err_wl31,bank0_err_wl30,bank0_err_wl29,bank0_err_wl28,bank0_err_wl27,bank0_err_wl26,bank0_err_wl25,bank0_err_wl24,
        bank0_err_wl23,bank0_err_wl22,bank0_err_wl21,bank0_err_wl20,bank0_err_wl19,bank0_err_wl18,bank0_err_wl17,bank0_err_wl16,bank0_err_wl15,bank0_err_wl14,
        bank0_err_wl13,bank0_err_wl12,bank0_err_wl11,bank0_err_wl10,bank0_err_wl9,bank0_err_wl8,bank0_err_wl7,bank0_err_wl6,bank0_err_wl5,bank0_err_wl4,
        bank0_err_wl3,bank0_err_wl2,bank0_err_wl1,bank0_err_wl0 } = err_wl_store0 ; 


        
////--------------------bank1------------------------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_wl_store1  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(global_bist_clr) begin
        err_wl_store1  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(bist_scan_fsm==BANK1 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same1 && (bank1_err_wl_cnt < 7'd64)) begin 
        err_wl_store1  <=  {err_wl_store1[63*ARRAY_ROW_ADDR_WIDTH-1:0],receive_row_addr} ;
    end
end

assign err_wl_same1 =  bist_scan_fsm==BANK1 ?
((err_wl_store1[63*13+:13]==receive_row_addr)||(err_wl_store1[62*13+:13]==receive_row_addr)||(err_wl_store1[61*13+:13]==receive_row_addr)||
(err_wl_store1[60*13+:13]==receive_row_addr)||(err_wl_store1[59*13+:13]==receive_row_addr)||(err_wl_store1[58*13+:13]==receive_row_addr)||
(err_wl_store1[57*13+:13]==receive_row_addr)||(err_wl_store1[56*13+:13]==receive_row_addr)||(err_wl_store1[55*13+:13]==receive_row_addr)||
(err_wl_store1[54*13+:13]==receive_row_addr)||(err_wl_store1[53*13+:13]==receive_row_addr)||(err_wl_store1[52*13+:13]==receive_row_addr)||
(err_wl_store1[51*13+:13]==receive_row_addr)||(err_wl_store1[50*13+:13]==receive_row_addr)||(err_wl_store1[49*13+:13]==receive_row_addr)||
(err_wl_store1[48*13+:13]==receive_row_addr)||(err_wl_store1[47*13+:13]==receive_row_addr)||(err_wl_store1[46*13+:13]==receive_row_addr)||
(err_wl_store1[45*13+:13]==receive_row_addr)||(err_wl_store1[44*13+:13]==receive_row_addr)||(err_wl_store1[43*13+:13]==receive_row_addr)||
(err_wl_store1[42*13+:13]==receive_row_addr)||(err_wl_store1[41*13+:13]==receive_row_addr)||(err_wl_store1[40*13+:13]==receive_row_addr)||
(err_wl_store1[39*13+:13]==receive_row_addr)||(err_wl_store1[38*13+:13]==receive_row_addr)||(err_wl_store1[37*13+:13]==receive_row_addr)||
(err_wl_store1[36*13+:13]==receive_row_addr)||(err_wl_store1[35*13+:13]==receive_row_addr)||(err_wl_store1[34*13+:13]==receive_row_addr)||
(err_wl_store1[33*13+:13]==receive_row_addr)||(err_wl_store1[32*13+:13]==receive_row_addr)||(err_wl_store1[31*13+:13]==receive_row_addr)||
(err_wl_store1[30*13+:13]==receive_row_addr)||(err_wl_store1[29*13+:13]==receive_row_addr)||(err_wl_store1[28*13+:13]==receive_row_addr)||
(err_wl_store1[27*13+:13]==receive_row_addr)||(err_wl_store1[26*13+:13]==receive_row_addr)||(err_wl_store1[25*13+:13]==receive_row_addr)||
(err_wl_store1[24*13+:13]==receive_row_addr)||(err_wl_store1[23*13+:13]==receive_row_addr)||(err_wl_store1[22*13+:13]==receive_row_addr)||
(err_wl_store1[21*13+:13]==receive_row_addr)||(err_wl_store1[20*13+:13]==receive_row_addr)||(err_wl_store1[19*13+:13]==receive_row_addr)||
(err_wl_store1[18*13+:13]==receive_row_addr)||(err_wl_store1[17*13+:13]==receive_row_addr)||(err_wl_store1[16*13+:13]==receive_row_addr)||
(err_wl_store1[15*13+:13]==receive_row_addr)||(err_wl_store1[14*13+:13]==receive_row_addr)||(err_wl_store1[13*13+:13]==receive_row_addr)||
(err_wl_store1[12*13+:13]==receive_row_addr)||(err_wl_store1[11*13+:13]==receive_row_addr)||(err_wl_store1[10*13+:13]==receive_row_addr)||
(err_wl_store1[9*13+:13]==receive_row_addr)||(err_wl_store1[8*13+:13]==receive_row_addr)||(err_wl_store1[7*13+:13]==receive_row_addr)||
(err_wl_store1[6*13+:13]==receive_row_addr)||(err_wl_store1[5*13+:13]==receive_row_addr)||(err_wl_store1[4*13+:13]==receive_row_addr)||
(err_wl_store1[3*13+:13]==receive_row_addr)||(err_wl_store1[2*13+:13]==receive_row_addr)||(err_wl_store1[1*13+:13]==receive_row_addr)||
(err_wl_store1[0*13+:13]==receive_row_addr)) : 1'b0;

assign bank1_err_wl_cnt = 
(err_wl_store1[63*13+:13]!=13'h1FFF)+(err_wl_store1[62*13+:13]!=13'h1FFF)+(err_wl_store1[61*13+:13]!=13'h1FFF)+(err_wl_store1[60*13+:13]!=13'h1FFF)+
(err_wl_store1[59*13+:13]!=13'h1FFF)+(err_wl_store1[58*13+:13]!=13'h1FFF)+(err_wl_store1[57*13+:13]!=13'h1FFF)+(err_wl_store1[56*13+:13]!=13'h1FFF)+
(err_wl_store1[55*13+:13]!=13'h1FFF)+(err_wl_store1[54*13+:13]!=13'h1FFF)+(err_wl_store1[53*13+:13]!=13'h1FFF)+(err_wl_store1[52*13+:13]!=13'h1FFF)+
(err_wl_store1[51*13+:13]!=13'h1FFF)+(err_wl_store1[50*13+:13]!=13'h1FFF)+(err_wl_store1[49*13+:13]!=13'h1FFF)+(err_wl_store1[48*13+:13]!=13'h1FFF)+
(err_wl_store1[47*13+:13]!=13'h1FFF)+(err_wl_store1[46*13+:13]!=13'h1FFF)+(err_wl_store1[45*13+:13]!=13'h1FFF)+(err_wl_store1[44*13+:13]!=13'h1FFF)+
(err_wl_store1[43*13+:13]!=13'h1FFF)+(err_wl_store1[42*13+:13]!=13'h1FFF)+(err_wl_store1[41*13+:13]!=13'h1FFF)+(err_wl_store1[40*13+:13]!=13'h1FFF)+
(err_wl_store1[39*13+:13]!=13'h1FFF)+(err_wl_store1[38*13+:13]!=13'h1FFF)+(err_wl_store1[37*13+:13]!=13'h1FFF)+(err_wl_store1[36*13+:13]!=13'h1FFF)+
(err_wl_store1[35*13+:13]!=13'h1FFF)+(err_wl_store1[34*13+:13]!=13'h1FFF)+(err_wl_store1[33*13+:13]!=13'h1FFF)+(err_wl_store1[32*13+:13]!=13'h1FFF)+
(err_wl_store1[31*13+:13]!=13'h1FFF)+(err_wl_store1[30*13+:13]!=13'h1FFF)+(err_wl_store1[29*13+:13]!=13'h1FFF)+(err_wl_store1[28*13+:13]!=13'h1FFF)+
(err_wl_store1[27*13+:13]!=13'h1FFF)+(err_wl_store1[26*13+:13]!=13'h1FFF)+(err_wl_store1[25*13+:13]!=13'h1FFF)+(err_wl_store1[24*13+:13]!=13'h1FFF)+
(err_wl_store1[23*13+:13]!=13'h1FFF)+(err_wl_store1[22*13+:13]!=13'h1FFF)+(err_wl_store1[21*13+:13]!=13'h1FFF)+(err_wl_store1[20*13+:13]!=13'h1FFF)+
(err_wl_store1[19*13+:13]!=13'h1FFF)+(err_wl_store1[18*13+:13]!=13'h1FFF)+(err_wl_store1[17*13+:13]!=13'h1FFF)+(err_wl_store1[16*13+:13]!=13'h1FFF)+
(err_wl_store1[15*13+:13]!=13'h1FFF)+(err_wl_store1[14*13+:13]!=13'h1FFF)+(err_wl_store1[13*13+:13]!=13'h1FFF)+(err_wl_store1[12*13+:13]!=13'h1FFF)+
(err_wl_store1[11*13+:13]!=13'h1FFF)+(err_wl_store1[10*13+:13]!=13'h1FFF)+(err_wl_store1[9*13+:13]!=13'h1FFF)+(err_wl_store1[8*13+:13]!=13'h1FFF)+
(err_wl_store1[7*13+:13]!=13'h1FFF)+(err_wl_store1[6*13+:13]!=13'h1FFF)+(err_wl_store1[5*13+:13]!=13'h1FFF)+(err_wl_store1[4*13+:13]!=13'h1FFF)+
(err_wl_store1[3*13+:13]!=13'h1FFF)+(err_wl_store1[2*13+:13]!=13'h1FFF)+(err_wl_store1[1*13+:13]!=13'h1FFF)+(err_wl_store1[0*13+:13]!=13'h1FFF) ;

assign {bank1_err_wl63,bank1_err_wl62,bank1_err_wl61,bank1_err_wl60,bank1_err_wl59,bank1_err_wl58,bank1_err_wl57,bank1_err_wl56,bank1_err_wl55,bank1_err_wl54,
        bank1_err_wl53,bank1_err_wl52,bank1_err_wl51,bank1_err_wl50,bank1_err_wl49,bank1_err_wl48,bank1_err_wl47,bank1_err_wl46,bank1_err_wl45,bank1_err_wl44,
        bank1_err_wl43,bank1_err_wl42,bank1_err_wl41,bank1_err_wl40,bank1_err_wl39,bank1_err_wl38,bank1_err_wl37,bank1_err_wl36,bank1_err_wl35,bank1_err_wl34,
        bank1_err_wl33,bank1_err_wl32,bank1_err_wl31,bank1_err_wl30,bank1_err_wl29,bank1_err_wl28,bank1_err_wl27,bank1_err_wl26,bank1_err_wl25,bank1_err_wl24,
        bank1_err_wl23,bank1_err_wl22,bank1_err_wl21,bank1_err_wl20,bank1_err_wl19,bank1_err_wl18,bank1_err_wl17,bank1_err_wl16,bank1_err_wl15,bank1_err_wl14,
        bank1_err_wl13,bank1_err_wl12,bank1_err_wl11,bank1_err_wl10,bank1_err_wl9,bank1_err_wl8,bank1_err_wl7,bank1_err_wl6,bank1_err_wl5,bank1_err_wl4,
        bank1_err_wl3,bank1_err_wl2,bank1_err_wl1,bank1_err_wl0 } = err_wl_store1 ; 
        
////--------------------bank2------------------------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_wl_store2  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(global_bist_clr) begin
        err_wl_store2  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(bist_scan_fsm==BANK2 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same2 && (bank2_err_wl_cnt < 7'd64)) begin 
        err_wl_store2  <=  {err_wl_store2[63*ARRAY_ROW_ADDR_WIDTH-1:0],receive_row_addr} ;
    end
end

assign err_wl_same2 =  bist_scan_fsm==BANK2 ?
((err_wl_store2[63*13+:13]==receive_row_addr)||(err_wl_store2[62*13+:13]==receive_row_addr)||(err_wl_store2[61*13+:13]==receive_row_addr)||
(err_wl_store2[60*13+:13]==receive_row_addr)||(err_wl_store2[59*13+:13]==receive_row_addr)||(err_wl_store2[58*13+:13]==receive_row_addr)||
(err_wl_store2[57*13+:13]==receive_row_addr)||(err_wl_store2[56*13+:13]==receive_row_addr)||(err_wl_store2[55*13+:13]==receive_row_addr)||
(err_wl_store2[54*13+:13]==receive_row_addr)||(err_wl_store2[53*13+:13]==receive_row_addr)||(err_wl_store2[52*13+:13]==receive_row_addr)||
(err_wl_store2[51*13+:13]==receive_row_addr)||(err_wl_store2[50*13+:13]==receive_row_addr)||(err_wl_store2[49*13+:13]==receive_row_addr)||
(err_wl_store2[48*13+:13]==receive_row_addr)||(err_wl_store2[47*13+:13]==receive_row_addr)||(err_wl_store2[46*13+:13]==receive_row_addr)||
(err_wl_store2[45*13+:13]==receive_row_addr)||(err_wl_store2[44*13+:13]==receive_row_addr)||(err_wl_store2[43*13+:13]==receive_row_addr)||
(err_wl_store2[42*13+:13]==receive_row_addr)||(err_wl_store2[41*13+:13]==receive_row_addr)||(err_wl_store2[40*13+:13]==receive_row_addr)||
(err_wl_store2[39*13+:13]==receive_row_addr)||(err_wl_store2[38*13+:13]==receive_row_addr)||(err_wl_store2[37*13+:13]==receive_row_addr)||
(err_wl_store2[36*13+:13]==receive_row_addr)||(err_wl_store2[35*13+:13]==receive_row_addr)||(err_wl_store2[34*13+:13]==receive_row_addr)||
(err_wl_store2[33*13+:13]==receive_row_addr)||(err_wl_store2[32*13+:13]==receive_row_addr)||(err_wl_store2[31*13+:13]==receive_row_addr)||
(err_wl_store2[30*13+:13]==receive_row_addr)||(err_wl_store2[29*13+:13]==receive_row_addr)||(err_wl_store2[28*13+:13]==receive_row_addr)||
(err_wl_store2[27*13+:13]==receive_row_addr)||(err_wl_store2[26*13+:13]==receive_row_addr)||(err_wl_store2[25*13+:13]==receive_row_addr)||
(err_wl_store2[24*13+:13]==receive_row_addr)||(err_wl_store2[23*13+:13]==receive_row_addr)||(err_wl_store2[22*13+:13]==receive_row_addr)||
(err_wl_store2[21*13+:13]==receive_row_addr)||(err_wl_store2[20*13+:13]==receive_row_addr)||(err_wl_store2[19*13+:13]==receive_row_addr)||
(err_wl_store2[18*13+:13]==receive_row_addr)||(err_wl_store2[17*13+:13]==receive_row_addr)||(err_wl_store2[16*13+:13]==receive_row_addr)||
(err_wl_store2[15*13+:13]==receive_row_addr)||(err_wl_store2[14*13+:13]==receive_row_addr)||(err_wl_store2[13*13+:13]==receive_row_addr)||
(err_wl_store2[12*13+:13]==receive_row_addr)||(err_wl_store2[11*13+:13]==receive_row_addr)||(err_wl_store2[10*13+:13]==receive_row_addr)||
(err_wl_store2[9*13+:13]==receive_row_addr)||(err_wl_store2[8*13+:13]==receive_row_addr)||(err_wl_store2[7*13+:13]==receive_row_addr)||
(err_wl_store2[6*13+:13]==receive_row_addr)||(err_wl_store2[5*13+:13]==receive_row_addr)||(err_wl_store2[4*13+:13]==receive_row_addr)||
(err_wl_store2[3*13+:13]==receive_row_addr)||(err_wl_store2[2*13+:13]==receive_row_addr)||(err_wl_store2[1*13+:13]==receive_row_addr)||
(err_wl_store2[0*13+:13]==receive_row_addr)) : 1'b0;

assign bank2_err_wl_cnt = 
(err_wl_store2[63*13+:13]!=13'h1FFF)+(err_wl_store2[62*13+:13]!=13'h1FFF)+(err_wl_store2[61*13+:13]!=13'h1FFF)+(err_wl_store2[60*13+:13]!=13'h1FFF)+
(err_wl_store2[59*13+:13]!=13'h1FFF)+(err_wl_store2[58*13+:13]!=13'h1FFF)+(err_wl_store2[57*13+:13]!=13'h1FFF)+(err_wl_store2[56*13+:13]!=13'h1FFF)+
(err_wl_store2[55*13+:13]!=13'h1FFF)+(err_wl_store2[54*13+:13]!=13'h1FFF)+(err_wl_store2[53*13+:13]!=13'h1FFF)+(err_wl_store2[52*13+:13]!=13'h1FFF)+
(err_wl_store2[51*13+:13]!=13'h1FFF)+(err_wl_store2[50*13+:13]!=13'h1FFF)+(err_wl_store2[49*13+:13]!=13'h1FFF)+(err_wl_store2[48*13+:13]!=13'h1FFF)+
(err_wl_store2[47*13+:13]!=13'h1FFF)+(err_wl_store2[46*13+:13]!=13'h1FFF)+(err_wl_store2[45*13+:13]!=13'h1FFF)+(err_wl_store2[44*13+:13]!=13'h1FFF)+
(err_wl_store2[43*13+:13]!=13'h1FFF)+(err_wl_store2[42*13+:13]!=13'h1FFF)+(err_wl_store2[41*13+:13]!=13'h1FFF)+(err_wl_store2[40*13+:13]!=13'h1FFF)+
(err_wl_store2[39*13+:13]!=13'h1FFF)+(err_wl_store2[38*13+:13]!=13'h1FFF)+(err_wl_store2[37*13+:13]!=13'h1FFF)+(err_wl_store2[36*13+:13]!=13'h1FFF)+
(err_wl_store2[35*13+:13]!=13'h1FFF)+(err_wl_store2[34*13+:13]!=13'h1FFF)+(err_wl_store2[33*13+:13]!=13'h1FFF)+(err_wl_store2[32*13+:13]!=13'h1FFF)+
(err_wl_store2[31*13+:13]!=13'h1FFF)+(err_wl_store2[30*13+:13]!=13'h1FFF)+(err_wl_store2[29*13+:13]!=13'h1FFF)+(err_wl_store2[28*13+:13]!=13'h1FFF)+
(err_wl_store2[27*13+:13]!=13'h1FFF)+(err_wl_store2[26*13+:13]!=13'h1FFF)+(err_wl_store2[25*13+:13]!=13'h1FFF)+(err_wl_store2[24*13+:13]!=13'h1FFF)+
(err_wl_store2[23*13+:13]!=13'h1FFF)+(err_wl_store2[22*13+:13]!=13'h1FFF)+(err_wl_store2[21*13+:13]!=13'h1FFF)+(err_wl_store2[20*13+:13]!=13'h1FFF)+
(err_wl_store2[19*13+:13]!=13'h1FFF)+(err_wl_store2[18*13+:13]!=13'h1FFF)+(err_wl_store2[17*13+:13]!=13'h1FFF)+(err_wl_store2[16*13+:13]!=13'h1FFF)+
(err_wl_store2[15*13+:13]!=13'h1FFF)+(err_wl_store2[14*13+:13]!=13'h1FFF)+(err_wl_store2[13*13+:13]!=13'h1FFF)+(err_wl_store2[12*13+:13]!=13'h1FFF)+
(err_wl_store2[11*13+:13]!=13'h1FFF)+(err_wl_store2[10*13+:13]!=13'h1FFF)+(err_wl_store2[9*13+:13]!=13'h1FFF)+(err_wl_store2[8*13+:13]!=13'h1FFF)+
(err_wl_store2[7*13+:13]!=13'h1FFF)+(err_wl_store2[6*13+:13]!=13'h1FFF)+(err_wl_store2[5*13+:13]!=13'h1FFF)+(err_wl_store2[4*13+:13]!=13'h1FFF)+
(err_wl_store2[3*13+:13]!=13'h1FFF)+(err_wl_store2[2*13+:13]!=13'h1FFF)+(err_wl_store2[1*13+:13]!=13'h1FFF)+(err_wl_store2[0*13+:13]!=13'h1FFF) ;

assign {bank2_err_wl63,bank2_err_wl62,bank2_err_wl61,bank2_err_wl60,bank2_err_wl59,bank2_err_wl58,bank2_err_wl57,bank2_err_wl56,bank2_err_wl55,bank2_err_wl54,
        bank2_err_wl53,bank2_err_wl52,bank2_err_wl51,bank2_err_wl50,bank2_err_wl49,bank2_err_wl48,bank2_err_wl47,bank2_err_wl46,bank2_err_wl45,bank2_err_wl44,
        bank2_err_wl43,bank2_err_wl42,bank2_err_wl41,bank2_err_wl40,bank2_err_wl39,bank2_err_wl38,bank2_err_wl37,bank2_err_wl36,bank2_err_wl35,bank2_err_wl34,
        bank2_err_wl33,bank2_err_wl32,bank2_err_wl31,bank2_err_wl30,bank2_err_wl29,bank2_err_wl28,bank2_err_wl27,bank2_err_wl26,bank2_err_wl25,bank2_err_wl24,
        bank2_err_wl23,bank2_err_wl22,bank2_err_wl21,bank2_err_wl20,bank2_err_wl19,bank2_err_wl18,bank2_err_wl17,bank2_err_wl16,bank2_err_wl15,bank2_err_wl14,
        bank2_err_wl13,bank2_err_wl12,bank2_err_wl11,bank2_err_wl10,bank2_err_wl9,bank2_err_wl8,bank2_err_wl7,bank2_err_wl6,bank2_err_wl5,bank2_err_wl4,
        bank2_err_wl3,bank2_err_wl2,bank2_err_wl1,bank2_err_wl0 } = err_wl_store2 ; 
////--------------------bank3------------------------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_wl_store3  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(global_bist_clr) begin
        err_wl_store3  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(bist_scan_fsm==BANK3 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same3 && (bank3_err_wl_cnt < 7'd64)) begin 
        err_wl_store3  <=  {err_wl_store3[63*ARRAY_ROW_ADDR_WIDTH-1:0],receive_row_addr} ;
    end
end

assign err_wl_same3 =  bist_scan_fsm==BANK3 ?
((err_wl_store3[63*13+:13]==receive_row_addr)||(err_wl_store3[62*13+:13]==receive_row_addr)||(err_wl_store3[61*13+:13]==receive_row_addr)||
(err_wl_store3[60*13+:13]==receive_row_addr)||(err_wl_store3[59*13+:13]==receive_row_addr)||(err_wl_store3[58*13+:13]==receive_row_addr)||
(err_wl_store3[57*13+:13]==receive_row_addr)||(err_wl_store3[56*13+:13]==receive_row_addr)||(err_wl_store3[55*13+:13]==receive_row_addr)||
(err_wl_store3[54*13+:13]==receive_row_addr)||(err_wl_store3[53*13+:13]==receive_row_addr)||(err_wl_store3[52*13+:13]==receive_row_addr)||
(err_wl_store3[51*13+:13]==receive_row_addr)||(err_wl_store3[50*13+:13]==receive_row_addr)||(err_wl_store3[49*13+:13]==receive_row_addr)||
(err_wl_store3[48*13+:13]==receive_row_addr)||(err_wl_store3[47*13+:13]==receive_row_addr)||(err_wl_store3[46*13+:13]==receive_row_addr)||
(err_wl_store3[45*13+:13]==receive_row_addr)||(err_wl_store3[44*13+:13]==receive_row_addr)||(err_wl_store3[43*13+:13]==receive_row_addr)||
(err_wl_store3[42*13+:13]==receive_row_addr)||(err_wl_store3[41*13+:13]==receive_row_addr)||(err_wl_store3[40*13+:13]==receive_row_addr)||
(err_wl_store3[39*13+:13]==receive_row_addr)||(err_wl_store3[38*13+:13]==receive_row_addr)||(err_wl_store3[37*13+:13]==receive_row_addr)||
(err_wl_store3[36*13+:13]==receive_row_addr)||(err_wl_store3[35*13+:13]==receive_row_addr)||(err_wl_store3[34*13+:13]==receive_row_addr)||
(err_wl_store3[33*13+:13]==receive_row_addr)||(err_wl_store3[32*13+:13]==receive_row_addr)||(err_wl_store3[31*13+:13]==receive_row_addr)||
(err_wl_store3[30*13+:13]==receive_row_addr)||(err_wl_store3[29*13+:13]==receive_row_addr)||(err_wl_store3[28*13+:13]==receive_row_addr)||
(err_wl_store3[27*13+:13]==receive_row_addr)||(err_wl_store3[26*13+:13]==receive_row_addr)||(err_wl_store3[25*13+:13]==receive_row_addr)||
(err_wl_store3[24*13+:13]==receive_row_addr)||(err_wl_store3[23*13+:13]==receive_row_addr)||(err_wl_store3[22*13+:13]==receive_row_addr)||
(err_wl_store3[21*13+:13]==receive_row_addr)||(err_wl_store3[20*13+:13]==receive_row_addr)||(err_wl_store3[19*13+:13]==receive_row_addr)||
(err_wl_store3[18*13+:13]==receive_row_addr)||(err_wl_store3[17*13+:13]==receive_row_addr)||(err_wl_store3[16*13+:13]==receive_row_addr)||
(err_wl_store3[15*13+:13]==receive_row_addr)||(err_wl_store3[14*13+:13]==receive_row_addr)||(err_wl_store3[13*13+:13]==receive_row_addr)||
(err_wl_store3[12*13+:13]==receive_row_addr)||(err_wl_store3[11*13+:13]==receive_row_addr)||(err_wl_store3[10*13+:13]==receive_row_addr)||
(err_wl_store3[9*13+:13]==receive_row_addr)||(err_wl_store3[8*13+:13]==receive_row_addr)||(err_wl_store3[7*13+:13]==receive_row_addr)||
(err_wl_store3[6*13+:13]==receive_row_addr)||(err_wl_store3[5*13+:13]==receive_row_addr)||(err_wl_store3[4*13+:13]==receive_row_addr)||
(err_wl_store3[3*13+:13]==receive_row_addr)||(err_wl_store3[2*13+:13]==receive_row_addr)||(err_wl_store3[1*13+:13]==receive_row_addr)||
(err_wl_store3[0*13+:13]==receive_row_addr)) : 1'b0;

assign bank3_err_wl_cnt = 
(err_wl_store3[63*13+:13]!=13'h1FFF)+(err_wl_store3[62*13+:13]!=13'h1FFF)+(err_wl_store3[61*13+:13]!=13'h1FFF)+(err_wl_store3[60*13+:13]!=13'h1FFF)+
(err_wl_store3[59*13+:13]!=13'h1FFF)+(err_wl_store3[58*13+:13]!=13'h1FFF)+(err_wl_store3[57*13+:13]!=13'h1FFF)+(err_wl_store3[56*13+:13]!=13'h1FFF)+
(err_wl_store3[55*13+:13]!=13'h1FFF)+(err_wl_store3[54*13+:13]!=13'h1FFF)+(err_wl_store3[53*13+:13]!=13'h1FFF)+(err_wl_store3[52*13+:13]!=13'h1FFF)+
(err_wl_store3[51*13+:13]!=13'h1FFF)+(err_wl_store3[50*13+:13]!=13'h1FFF)+(err_wl_store3[49*13+:13]!=13'h1FFF)+(err_wl_store3[48*13+:13]!=13'h1FFF)+
(err_wl_store3[47*13+:13]!=13'h1FFF)+(err_wl_store3[46*13+:13]!=13'h1FFF)+(err_wl_store3[45*13+:13]!=13'h1FFF)+(err_wl_store3[44*13+:13]!=13'h1FFF)+
(err_wl_store3[43*13+:13]!=13'h1FFF)+(err_wl_store3[42*13+:13]!=13'h1FFF)+(err_wl_store3[41*13+:13]!=13'h1FFF)+(err_wl_store3[40*13+:13]!=13'h1FFF)+
(err_wl_store3[39*13+:13]!=13'h1FFF)+(err_wl_store3[38*13+:13]!=13'h1FFF)+(err_wl_store3[37*13+:13]!=13'h1FFF)+(err_wl_store3[36*13+:13]!=13'h1FFF)+
(err_wl_store3[35*13+:13]!=13'h1FFF)+(err_wl_store3[34*13+:13]!=13'h1FFF)+(err_wl_store3[33*13+:13]!=13'h1FFF)+(err_wl_store3[32*13+:13]!=13'h1FFF)+
(err_wl_store3[31*13+:13]!=13'h1FFF)+(err_wl_store3[30*13+:13]!=13'h1FFF)+(err_wl_store3[29*13+:13]!=13'h1FFF)+(err_wl_store3[28*13+:13]!=13'h1FFF)+
(err_wl_store3[27*13+:13]!=13'h1FFF)+(err_wl_store3[26*13+:13]!=13'h1FFF)+(err_wl_store3[25*13+:13]!=13'h1FFF)+(err_wl_store3[24*13+:13]!=13'h1FFF)+
(err_wl_store3[23*13+:13]!=13'h1FFF)+(err_wl_store3[22*13+:13]!=13'h1FFF)+(err_wl_store3[21*13+:13]!=13'h1FFF)+(err_wl_store3[20*13+:13]!=13'h1FFF)+
(err_wl_store3[19*13+:13]!=13'h1FFF)+(err_wl_store3[18*13+:13]!=13'h1FFF)+(err_wl_store3[17*13+:13]!=13'h1FFF)+(err_wl_store3[16*13+:13]!=13'h1FFF)+
(err_wl_store3[15*13+:13]!=13'h1FFF)+(err_wl_store3[14*13+:13]!=13'h1FFF)+(err_wl_store3[13*13+:13]!=13'h1FFF)+(err_wl_store3[12*13+:13]!=13'h1FFF)+
(err_wl_store3[11*13+:13]!=13'h1FFF)+(err_wl_store3[10*13+:13]!=13'h1FFF)+(err_wl_store3[9*13+:13]!=13'h1FFF)+(err_wl_store3[8*13+:13]!=13'h1FFF)+
(err_wl_store3[7*13+:13]!=13'h1FFF)+(err_wl_store3[6*13+:13]!=13'h1FFF)+(err_wl_store3[5*13+:13]!=13'h1FFF)+(err_wl_store3[4*13+:13]!=13'h1FFF)+
(err_wl_store3[3*13+:13]!=13'h1FFF)+(err_wl_store3[2*13+:13]!=13'h1FFF)+(err_wl_store3[1*13+:13]!=13'h1FFF)+(err_wl_store3[0*13+:13]!=13'h1FFF) ;

assign {bank3_err_wl63,bank3_err_wl62,bank3_err_wl61,bank3_err_wl60,bank3_err_wl59,bank3_err_wl58,bank3_err_wl57,bank3_err_wl56,bank3_err_wl55,bank3_err_wl54,
        bank3_err_wl53,bank3_err_wl52,bank3_err_wl51,bank3_err_wl50,bank3_err_wl49,bank3_err_wl48,bank3_err_wl47,bank3_err_wl46,bank3_err_wl45,bank3_err_wl44,
        bank3_err_wl43,bank3_err_wl42,bank3_err_wl41,bank3_err_wl40,bank3_err_wl39,bank3_err_wl38,bank3_err_wl37,bank3_err_wl36,bank3_err_wl35,bank3_err_wl34,
        bank3_err_wl33,bank3_err_wl32,bank3_err_wl31,bank3_err_wl30,bank3_err_wl29,bank3_err_wl28,bank3_err_wl27,bank3_err_wl26,bank3_err_wl25,bank3_err_wl24,
        bank3_err_wl23,bank3_err_wl22,bank3_err_wl21,bank3_err_wl20,bank3_err_wl19,bank3_err_wl18,bank3_err_wl17,bank3_err_wl16,bank3_err_wl15,bank3_err_wl14,
        bank3_err_wl13,bank3_err_wl12,bank3_err_wl11,bank3_err_wl10,bank3_err_wl9,bank3_err_wl8,bank3_err_wl7,bank3_err_wl6,bank3_err_wl5,bank3_err_wl4,
        bank3_err_wl3,bank3_err_wl2,bank3_err_wl1,bank3_err_wl0 } = err_wl_store3 ; 



assign bank_bist_wl_finish = {bank3_bist_wl_finish,bank2_bist_wl_finish,bank1_bist_wl_finish,bank0_bist_wl_finish};
assign bank_bist_wl_success = {bank3_bist_wl_success,bank2_bist_wl_success,bank1_bist_wl_success,bank0_bist_wl_success};
assign bank_err_wl_cnt_change_flag = {bank3_err_wl_cnt_change_flag,bank2_err_wl_cnt_change_flag,bank1_err_wl_cnt_change_flag,bank0_err_wl_cnt_change_flag};
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank0_bist_wl_finish   <=  1'b0   ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank0_bist_wl_finish   <=  1'b0   ;
    end
    else if(bist_scan_fsm==BANK0 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (wl_scan_row_status && data_noback_req_cnt==5'h0))) begin
        bank0_bist_wl_finish   <=  1'b1   ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank1_bist_wl_finish   <=  1'b0   ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank1_bist_wl_finish   <=  1'b0   ;
    end
    else if(bist_scan_fsm==BANK1 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (wl_scan_row_status && data_noback_req_cnt==5'h0))) begin
        bank1_bist_wl_finish   <=  1'b1   ;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank2_bist_wl_finish   <=  1'b0   ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank2_bist_wl_finish   <=  1'b0   ;
    end
    else if(bist_scan_fsm==BANK2 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (wl_scan_row_status && data_noback_req_cnt==5'h0))) begin
        bank2_bist_wl_finish   <=  1'b1   ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank3_bist_wl_finish   <=  1'b0   ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank3_bist_wl_finish   <=  1'b0   ;
    end
    else if(bist_scan_fsm==BANK3 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (wl_scan_row_status && data_noback_req_cnt==5'h0))) begin
        bank3_bist_wl_finish   <=  1'b1   ;
    end
end

always @(*)begin
    if(bist_scan_fsm==BANK0)
        wl_scan_row_status = bank0_bist_wl_fail ;
    else if(bist_scan_fsm==BANK1)
        wl_scan_row_status = bank1_bist_wl_fail ;
    else if(bist_scan_fsm==BANK2)
        wl_scan_row_status = bank2_bist_wl_fail ;
    else if(bist_scan_fsm==BANK3)
        wl_scan_row_status = bank3_bist_wl_fail ;
    else
        wl_scan_row_status = 1'b0 ;
end


assign bank0_bist_wl_success = bist_scan_fsm==BANK0 && bank0_bist_wl_finish && !bank0_bist_wl_fail ;
assign bank1_bist_wl_success = bist_scan_fsm==BANK1 && bank1_bist_wl_finish && !bank1_bist_wl_fail ;
assign bank2_bist_wl_success = bist_scan_fsm==BANK2 && bank2_bist_wl_finish && !bank2_bist_wl_fail ;
assign bank3_bist_wl_success = bist_scan_fsm==BANK3 && bank3_bist_wl_finish && !bank3_bist_wl_fail ;


always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank0_bist_wl_fail  <=  1'b0 ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank0_bist_wl_fail  <=  1'b0 ;
    end
    else if(bist_scan_fsm==BANK0 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same0 && (bank0_err_wl_cnt==7'd64)) begin 
        bank0_bist_wl_fail  <=  1'b1 ;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank1_bist_wl_fail  <=  1'b0 ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank1_bist_wl_fail  <=  1'b0 ;
    end
    else if(bist_scan_fsm==BANK1 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same1 && (bank1_err_wl_cnt==7'd64)) begin 
        bank1_bist_wl_fail  <=  1'b1 ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank2_bist_wl_fail  <=  1'b0 ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank2_bist_wl_fail  <=  1'b0 ;
    end
    else if(bist_scan_fsm==BANK2 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same2 && (bank2_err_wl_cnt==7'd64)) begin 
        bank2_bist_wl_fail  <=  1'b1 ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank3_bist_wl_fail  <=  1'b0 ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank3_bist_wl_fail  <=  1'b0 ;
    end
    else if(bist_scan_fsm==BANK3 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same3 && (bank3_err_wl_cnt==7'd64)) begin 
        bank3_bist_wl_fail  <=  1'b1 ;
    end
end


assign  err_wl0       =   {bank3_err_wl0, bank2_err_wl0, bank1_err_wl0, bank0_err_wl0} ;
assign  err_wl1       =   {bank3_err_wl1, bank2_err_wl1, bank1_err_wl1, bank0_err_wl1} ;                  
assign  err_wl2       =   {bank3_err_wl2, bank2_err_wl2, bank1_err_wl2, bank0_err_wl2} ;                  
assign  err_wl3       =   {bank3_err_wl3, bank2_err_wl3, bank1_err_wl3, bank0_err_wl3} ;                  
assign  err_wl4       =   {bank3_err_wl4, bank2_err_wl4, bank1_err_wl4, bank0_err_wl4} ;                  
assign  err_wl5       =   {bank3_err_wl5, bank2_err_wl5, bank1_err_wl5, bank0_err_wl5} ;                  
assign  err_wl6       =   {bank3_err_wl6, bank2_err_wl6, bank1_err_wl6, bank0_err_wl6} ;                  
assign  err_wl7       =   {bank3_err_wl7, bank2_err_wl7, bank1_err_wl7, bank0_err_wl7} ;                  
assign  err_wl8       =   {bank3_err_wl8, bank2_err_wl8, bank1_err_wl8, bank0_err_wl8} ;                  
assign  err_wl9       =   {bank3_err_wl9, bank2_err_wl9, bank1_err_wl9, bank0_err_wl9} ;                  
assign  err_wl10      =   {bank3_err_wl10,bank2_err_wl10,bank1_err_wl10,bank0_err_wl10};                   
assign  err_wl11      =   {bank3_err_wl11,bank2_err_wl11,bank1_err_wl11,bank0_err_wl11};                   
assign  err_wl12      =   {bank3_err_wl12,bank2_err_wl12,bank1_err_wl12,bank0_err_wl12};                   
assign  err_wl13      =   {bank3_err_wl13,bank2_err_wl13,bank1_err_wl13,bank0_err_wl13};                   
assign  err_wl14      =   {bank3_err_wl14,bank2_err_wl14,bank1_err_wl14,bank0_err_wl14};                   
assign  err_wl15      =   {bank3_err_wl15,bank2_err_wl15,bank1_err_wl15,bank0_err_wl15};                   
assign  err_wl16      =   {bank3_err_wl16,bank2_err_wl16,bank1_err_wl16,bank0_err_wl16};                   
assign  err_wl17      =   {bank3_err_wl17,bank2_err_wl17,bank1_err_wl17,bank0_err_wl17};                   
assign  err_wl18      =   {bank3_err_wl18,bank2_err_wl18,bank1_err_wl18,bank0_err_wl18};                   
assign  err_wl19      =   {bank3_err_wl19,bank2_err_wl19,bank1_err_wl19,bank0_err_wl19};                   
assign  err_wl20      =   {bank3_err_wl20,bank2_err_wl20,bank1_err_wl20,bank0_err_wl20};                   
assign  err_wl21      =   {bank3_err_wl21,bank2_err_wl21,bank1_err_wl21,bank0_err_wl21};                   
assign  err_wl22      =   {bank3_err_wl22,bank2_err_wl22,bank1_err_wl22,bank0_err_wl22};                   
assign  err_wl23      =   {bank3_err_wl23,bank2_err_wl23,bank1_err_wl23,bank0_err_wl23};                   
assign  err_wl24      =   {bank3_err_wl24,bank2_err_wl24,bank1_err_wl24,bank0_err_wl24};                   
assign  err_wl25      =   {bank3_err_wl25,bank2_err_wl25,bank1_err_wl25,bank0_err_wl25};                   
assign  err_wl26      =   {bank3_err_wl26,bank2_err_wl26,bank1_err_wl26,bank0_err_wl26};                   
assign  err_wl27      =   {bank3_err_wl27,bank2_err_wl27,bank1_err_wl27,bank0_err_wl27};                   
assign  err_wl28      =   {bank3_err_wl28,bank2_err_wl28,bank1_err_wl28,bank0_err_wl28};                   
assign  err_wl29      =   {bank3_err_wl29,bank2_err_wl29,bank1_err_wl29,bank0_err_wl29};                   
assign  err_wl30      =   {bank3_err_wl30,bank2_err_wl30,bank1_err_wl30,bank0_err_wl30};                   
assign  err_wl31      =   {bank3_err_wl31,bank2_err_wl31,bank1_err_wl31,bank0_err_wl31};                   
assign  err_wl32      =   {bank3_err_wl32,bank2_err_wl32,bank1_err_wl32,bank0_err_wl32};                   
assign  err_wl33      =   {bank3_err_wl33,bank2_err_wl33,bank1_err_wl33,bank0_err_wl33};                   
assign  err_wl34      =   {bank3_err_wl34,bank2_err_wl34,bank1_err_wl34,bank0_err_wl34};                   
assign  err_wl35      =   {bank3_err_wl35,bank2_err_wl35,bank1_err_wl35,bank0_err_wl35};                   
assign  err_wl36      =   {bank3_err_wl36,bank2_err_wl36,bank1_err_wl36,bank0_err_wl36};                   
assign  err_wl37      =   {bank3_err_wl37,bank2_err_wl37,bank1_err_wl37,bank0_err_wl37};                   
assign  err_wl38      =   {bank3_err_wl38,bank2_err_wl38,bank1_err_wl38,bank0_err_wl38};                   
assign  err_wl39      =   {bank3_err_wl39,bank2_err_wl39,bank1_err_wl39,bank0_err_wl39};                   
assign  err_wl40      =   {bank3_err_wl40,bank2_err_wl40,bank1_err_wl40,bank0_err_wl40};                   
assign  err_wl41      =   {bank3_err_wl41,bank2_err_wl41,bank1_err_wl41,bank0_err_wl41};                   
assign  err_wl42      =   {bank3_err_wl42,bank2_err_wl42,bank1_err_wl42,bank0_err_wl42};                   
assign  err_wl43      =   {bank3_err_wl43,bank2_err_wl43,bank1_err_wl43,bank0_err_wl43};                   
assign  err_wl44      =   {bank3_err_wl44,bank2_err_wl44,bank1_err_wl44,bank0_err_wl44};                   
assign  err_wl45      =   {bank3_err_wl45,bank2_err_wl45,bank1_err_wl45,bank0_err_wl45};                   
assign  err_wl46      =   {bank3_err_wl46,bank2_err_wl46,bank1_err_wl46,bank0_err_wl46};                   
assign  err_wl47      =   {bank3_err_wl47,bank2_err_wl47,bank1_err_wl47,bank0_err_wl47};                   
assign  err_wl48      =   {bank3_err_wl48,bank2_err_wl48,bank1_err_wl48,bank0_err_wl48};                   
assign  err_wl49      =   {bank3_err_wl49,bank2_err_wl49,bank1_err_wl49,bank0_err_wl49};                   
assign  err_wl50      =   {bank3_err_wl50,bank2_err_wl50,bank1_err_wl50,bank0_err_wl50};                   
assign  err_wl51      =   {bank3_err_wl51,bank2_err_wl51,bank1_err_wl51,bank0_err_wl51};                   
assign  err_wl52      =   {bank3_err_wl52,bank2_err_wl52,bank1_err_wl52,bank0_err_wl52};                   
assign  err_wl53      =   {bank3_err_wl53,bank2_err_wl53,bank1_err_wl53,bank0_err_wl53};                   
assign  err_wl54      =   {bank3_err_wl54,bank2_err_wl54,bank1_err_wl54,bank0_err_wl54};                   
assign  err_wl55      =   {bank3_err_wl55,bank2_err_wl55,bank1_err_wl55,bank0_err_wl55};                   
assign  err_wl56      =   {bank3_err_wl56,bank2_err_wl56,bank1_err_wl56,bank0_err_wl56};                   
assign  err_wl57      =   {bank3_err_wl57,bank2_err_wl57,bank1_err_wl57,bank0_err_wl57};                   
assign  err_wl58      =   {bank3_err_wl58,bank2_err_wl58,bank1_err_wl58,bank0_err_wl58};                   
assign  err_wl59      =   {bank3_err_wl59,bank2_err_wl59,bank1_err_wl59,bank0_err_wl59};                   
assign  err_wl60      =   {bank3_err_wl60,bank2_err_wl60,bank1_err_wl60,bank0_err_wl60};                   
assign  err_wl61      =   {bank3_err_wl61,bank2_err_wl61,bank1_err_wl61,bank0_err_wl61};                   
assign  err_wl62      =   {bank3_err_wl62,bank2_err_wl62,bank1_err_wl62,bank0_err_wl62};                   
assign  err_wl63      =   {bank3_err_wl63,bank2_err_wl63,bank1_err_wl63,bank0_err_wl63};     

assign wl_single_pattern_done = ((!bank3_bist_wl_fail && receive_row_addr == wl_scan_row_end_addr) && (receive_col_addr == 7'h7F) && !wl_scan_rd_cnt_allow && wl_scan_rvalid && data_noback_req_cnt==5'h1 )|| wl_scan_row_status_pos;
assign bank_err_wl_cnt = {bank3_err_wl_cnt,bank2_err_wl_cnt,bank1_err_wl_cnt,bank0_err_wl_cnt};
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_err_wl_cnt_r <= 7'h0 ;
    else if(bist_scan_fsm==BANK0 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (!bank0_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0))) 
        bank0_err_wl_cnt_r <= bank0_err_wl_cnt ;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank1_err_wl_cnt_r <= 7'h0 ;
    else if(bist_scan_fsm==BANK1 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (!bank1_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0))) 
        bank1_err_wl_cnt_r <= bank1_err_wl_cnt ;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank2_err_wl_cnt_r <= 7'h0 ;
    else if(bist_scan_fsm==BANK2 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (!bank2_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0))) 
        bank2_err_wl_cnt_r <= bank2_err_wl_cnt ;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank3_err_wl_cnt_r <= 7'h0 ;
    else if(bist_scan_fsm==BANK3 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (!bank3_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0))) 
        bank3_err_wl_cnt_r <= bank3_err_wl_cnt ;
end
//20250408 add by hy
wire    s_err_wl_cnt_change_cona;
wire    bank0_s_err_wl_cnt_change_conb;
wire    bank1_s_err_wl_cnt_change_conb;
wire    bank2_s_err_wl_cnt_change_conb;
wire    bank3_s_err_wl_cnt_change_conb;

assign  s_err_wl_cnt_change_cona = (wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num));
assign  bank0_s_err_wl_cnt_change_conb = (!bank0_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0);
assign  bank1_s_err_wl_cnt_change_conb = (!bank1_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0);
assign  bank2_s_err_wl_cnt_change_conb = (!bank2_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0);
assign  bank3_s_err_wl_cnt_change_conb = (!bank3_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0);

//end by hy

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_err_wl_cnt_change_flag <= 1'b0;
    else if(global_mc_bist_start)
        bank0_err_wl_cnt_change_flag <= 1'b0;
    else if((bank0_err_wl_cnt != bank0_err_wl_cnt_r) && (s_err_wl_cnt_change_cona || bank0_s_err_wl_cnt_change_conb)) //20250408 add by hy
        bank0_err_wl_cnt_change_flag <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank1_err_wl_cnt_change_flag <= 1'b0;
    else if(global_mc_bist_start)
        bank1_err_wl_cnt_change_flag <= 1'b0;
    else if((bank1_err_wl_cnt != bank1_err_wl_cnt_r) && (s_err_wl_cnt_change_cona || bank1_s_err_wl_cnt_change_conb)) //20250408 add by hy
        bank1_err_wl_cnt_change_flag <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank2_err_wl_cnt_change_flag <= 1'b0;
    else if(global_mc_bist_start)
        bank2_err_wl_cnt_change_flag <= 1'b0;
    else if((bank2_err_wl_cnt != bank2_err_wl_cnt_r) && (s_err_wl_cnt_change_cona || bank2_s_err_wl_cnt_change_conb)) //20250408 add by hy
        bank2_err_wl_cnt_change_flag <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank3_err_wl_cnt_change_flag <= 1'b0;
    else if(global_mc_bist_start)
        bank3_err_wl_cnt_change_flag <= 1'b0;
    else if((bank3_err_wl_cnt != bank3_err_wl_cnt_r) && (s_err_wl_cnt_change_cona || bank3_s_err_wl_cnt_change_conb)) //20250408 add by hy
        bank3_err_wl_cnt_change_flag <= 1'b1;
end

end
else if(MC_SHORT_MODE==3)begin:inst1

wire   [6:0]                                     bank0_err_wl_cnt                   ; 
wire   [6:0]                                     bank1_err_wl_cnt                   ; 
wire   [6:0]                                     bank2_err_wl_cnt                   ; 
reg    [ARRAY_ROW_ADDR_WIDTH*64-1:0]             err_wl_store0                      ;
reg    [ARRAY_ROW_ADDR_WIDTH*64-1:0]             err_wl_store1                      ;
reg    [ARRAY_ROW_ADDR_WIDTH*64-1:0]             err_wl_store2                      ;

wire                                             err_wl_same0                       ;
wire                                             err_wl_same1                       ;
wire                                             err_wl_same2                       ;
    
reg                                              bank0_bist_wl_fail                 ;
reg                                              bank1_bist_wl_fail                 ;
reg                                              bank2_bist_wl_fail                 ;
wire                                             bank3_bist_wl_fail                 ;
wire                                             bank0_bist_wl_success              ; 
wire                                             bank1_bist_wl_success              ; 
wire                                             bank2_bist_wl_success              ; 


reg                                              bank0_bist_wl_finish               ;
reg                                              bank1_bist_wl_finish               ;
reg                                              bank2_bist_wl_finish               ;
reg                                              bank0_err_wl_cnt_change_flag       ; //1:diff 0: same
reg                                              bank1_err_wl_cnt_change_flag       ; 
reg                                              bank2_err_wl_cnt_change_flag       ; 
reg    [6:0]                                     bank0_err_wl_cnt_r                 ;
reg    [6:0]                                     bank1_err_wl_cnt_r                 ;
reg    [6:0]                                     bank2_err_wl_cnt_r                 ;
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl0                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl1                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl2                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl3                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl4                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl5                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl6                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl7                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl8                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl9                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl10                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl11                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl12                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl13                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl14                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl15                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl16                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl17                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl18                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl19                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl20                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl21                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl22                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl23                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl24                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl25                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl26                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl27                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl28                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl29                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl30                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl31                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl32                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl33                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl34                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl35                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl36                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl37                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl38                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl39                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl40                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl41                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl42                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl43                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl44                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl45                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl46                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl47                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl48                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl49                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl50                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl51                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl52                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl53                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl54                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl55                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl56                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl57                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl58                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl59                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl60                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl61                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl62                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl63                     ;

wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl0                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl1                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl2                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl3                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl4                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl5                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl6                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl7                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl8                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl9                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl10                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl11                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl12                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl13                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl14                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl15                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl16                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl17                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl18                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl19                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl20                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl21                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl22                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl23                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl24                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl25                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl26                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl27                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl28                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl29                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl30                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl31                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl32                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl33                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl34                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl35                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl36                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl37                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl38                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl39                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl40                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl41                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl42                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl43                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl44                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl45                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl46                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl47                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl48                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl49                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl50                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl51                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl52                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl53                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl54                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl55                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl56                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl57                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl58                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl59                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl60                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl61                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl62                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl63                     ;


wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl0                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl1                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl2                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl3                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl4                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl5                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl6                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl7                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl8                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl9                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl10                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl11                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl12                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl13                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl14                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl15                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl16                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl17                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl18                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl19                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl20                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl21                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl22                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl23                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl24                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl25                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl26                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl27                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl28                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl29                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl30                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl31                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl32                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl33                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl34                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl35                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl36                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl37                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl38                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl39                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl40                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl41                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl42                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl43                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl44                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl45                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl46                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl47                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl48                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl49                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl50                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl51                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl52                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl53                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl54                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl55                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl56                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl57                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl58                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl59                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl60                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl61                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl62                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank2_err_wl63                     ;



////--------------------bank0------------------------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_wl_store0  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(global_bist_clr) begin
        err_wl_store0  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(bist_scan_fsm==BANK0 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same0 && (bank0_err_wl_cnt<7'd64)) begin 
        err_wl_store0  <=  {err_wl_store0[63*ARRAY_ROW_ADDR_WIDTH-1:0],receive_row_addr} ;
    end
end

assign err_wl_same0 = bist_scan_fsm==BANK0 ? 
((err_wl_store0[63*13+:13]==receive_row_addr)||(err_wl_store0[62*13+:13]==receive_row_addr)||(err_wl_store0[61*13+:13]==receive_row_addr)||
(err_wl_store0[60*13+:13]==receive_row_addr)||(err_wl_store0[59*13+:13]==receive_row_addr)||(err_wl_store0[58*13+:13]==receive_row_addr)||
(err_wl_store0[57*13+:13]==receive_row_addr)||(err_wl_store0[56*13+:13]==receive_row_addr)||(err_wl_store0[55*13+:13]==receive_row_addr)||
(err_wl_store0[54*13+:13]==receive_row_addr)||(err_wl_store0[53*13+:13]==receive_row_addr)||(err_wl_store0[52*13+:13]==receive_row_addr)||
(err_wl_store0[51*13+:13]==receive_row_addr)||(err_wl_store0[50*13+:13]==receive_row_addr)||(err_wl_store0[49*13+:13]==receive_row_addr)||
(err_wl_store0[48*13+:13]==receive_row_addr)||(err_wl_store0[47*13+:13]==receive_row_addr)||(err_wl_store0[46*13+:13]==receive_row_addr)||
(err_wl_store0[45*13+:13]==receive_row_addr)||(err_wl_store0[44*13+:13]==receive_row_addr)||(err_wl_store0[43*13+:13]==receive_row_addr)||
(err_wl_store0[42*13+:13]==receive_row_addr)||(err_wl_store0[41*13+:13]==receive_row_addr)||(err_wl_store0[40*13+:13]==receive_row_addr)||
(err_wl_store0[39*13+:13]==receive_row_addr)||(err_wl_store0[38*13+:13]==receive_row_addr)||(err_wl_store0[37*13+:13]==receive_row_addr)||
(err_wl_store0[36*13+:13]==receive_row_addr)||(err_wl_store0[35*13+:13]==receive_row_addr)||(err_wl_store0[34*13+:13]==receive_row_addr)||
(err_wl_store0[33*13+:13]==receive_row_addr)||(err_wl_store0[32*13+:13]==receive_row_addr)||(err_wl_store0[31*13+:13]==receive_row_addr)||
(err_wl_store0[30*13+:13]==receive_row_addr)||(err_wl_store0[29*13+:13]==receive_row_addr)||(err_wl_store0[28*13+:13]==receive_row_addr)||
(err_wl_store0[27*13+:13]==receive_row_addr)||(err_wl_store0[26*13+:13]==receive_row_addr)||(err_wl_store0[25*13+:13]==receive_row_addr)||
(err_wl_store0[24*13+:13]==receive_row_addr)||(err_wl_store0[23*13+:13]==receive_row_addr)||(err_wl_store0[22*13+:13]==receive_row_addr)||
(err_wl_store0[21*13+:13]==receive_row_addr)||(err_wl_store0[20*13+:13]==receive_row_addr)||(err_wl_store0[19*13+:13]==receive_row_addr)||
(err_wl_store0[18*13+:13]==receive_row_addr)||(err_wl_store0[17*13+:13]==receive_row_addr)||(err_wl_store0[16*13+:13]==receive_row_addr)||
(err_wl_store0[15*13+:13]==receive_row_addr)||(err_wl_store0[14*13+:13]==receive_row_addr)||(err_wl_store0[13*13+:13]==receive_row_addr)||
(err_wl_store0[12*13+:13]==receive_row_addr)||(err_wl_store0[11*13+:13]==receive_row_addr)||(err_wl_store0[10*13+:13]==receive_row_addr)||
(err_wl_store0[9*13+:13]==receive_row_addr)||(err_wl_store0[8*13+:13]==receive_row_addr)||(err_wl_store0[7*13+:13]==receive_row_addr)||
(err_wl_store0[6*13+:13]==receive_row_addr)||(err_wl_store0[5*13+:13]==receive_row_addr)||(err_wl_store0[4*13+:13]==receive_row_addr)||
(err_wl_store0[3*13+:13]==receive_row_addr)||(err_wl_store0[2*13+:13]==receive_row_addr)||(err_wl_store0[1*13+:13]==receive_row_addr)||
(err_wl_store0[0*13+:13]==receive_row_addr)) : 1'b0;

assign bank0_err_wl_cnt = 
(err_wl_store0[63*13+:13]!=13'h1FFF)+(err_wl_store0[62*13+:13]!=13'h1FFF)+(err_wl_store0[61*13+:13]!=13'h1FFF)+(err_wl_store0[60*13+:13]!=13'h1FFF)+
(err_wl_store0[59*13+:13]!=13'h1FFF)+(err_wl_store0[58*13+:13]!=13'h1FFF)+(err_wl_store0[57*13+:13]!=13'h1FFF)+(err_wl_store0[56*13+:13]!=13'h1FFF)+
(err_wl_store0[55*13+:13]!=13'h1FFF)+(err_wl_store0[54*13+:13]!=13'h1FFF)+(err_wl_store0[53*13+:13]!=13'h1FFF)+(err_wl_store0[52*13+:13]!=13'h1FFF)+
(err_wl_store0[51*13+:13]!=13'h1FFF)+(err_wl_store0[50*13+:13]!=13'h1FFF)+(err_wl_store0[49*13+:13]!=13'h1FFF)+(err_wl_store0[48*13+:13]!=13'h1FFF)+
(err_wl_store0[47*13+:13]!=13'h1FFF)+(err_wl_store0[46*13+:13]!=13'h1FFF)+(err_wl_store0[45*13+:13]!=13'h1FFF)+(err_wl_store0[44*13+:13]!=13'h1FFF)+
(err_wl_store0[43*13+:13]!=13'h1FFF)+(err_wl_store0[42*13+:13]!=13'h1FFF)+(err_wl_store0[41*13+:13]!=13'h1FFF)+(err_wl_store0[40*13+:13]!=13'h1FFF)+
(err_wl_store0[39*13+:13]!=13'h1FFF)+(err_wl_store0[38*13+:13]!=13'h1FFF)+(err_wl_store0[37*13+:13]!=13'h1FFF)+(err_wl_store0[36*13+:13]!=13'h1FFF)+
(err_wl_store0[35*13+:13]!=13'h1FFF)+(err_wl_store0[34*13+:13]!=13'h1FFF)+(err_wl_store0[33*13+:13]!=13'h1FFF)+(err_wl_store0[32*13+:13]!=13'h1FFF)+
(err_wl_store0[31*13+:13]!=13'h1FFF)+(err_wl_store0[30*13+:13]!=13'h1FFF)+(err_wl_store0[29*13+:13]!=13'h1FFF)+(err_wl_store0[28*13+:13]!=13'h1FFF)+
(err_wl_store0[27*13+:13]!=13'h1FFF)+(err_wl_store0[26*13+:13]!=13'h1FFF)+(err_wl_store0[25*13+:13]!=13'h1FFF)+(err_wl_store0[24*13+:13]!=13'h1FFF)+
(err_wl_store0[23*13+:13]!=13'h1FFF)+(err_wl_store0[22*13+:13]!=13'h1FFF)+(err_wl_store0[21*13+:13]!=13'h1FFF)+(err_wl_store0[20*13+:13]!=13'h1FFF)+
(err_wl_store0[19*13+:13]!=13'h1FFF)+(err_wl_store0[18*13+:13]!=13'h1FFF)+(err_wl_store0[17*13+:13]!=13'h1FFF)+(err_wl_store0[16*13+:13]!=13'h1FFF)+
(err_wl_store0[15*13+:13]!=13'h1FFF)+(err_wl_store0[14*13+:13]!=13'h1FFF)+(err_wl_store0[13*13+:13]!=13'h1FFF)+(err_wl_store0[12*13+:13]!=13'h1FFF)+
(err_wl_store0[11*13+:13]!=13'h1FFF)+(err_wl_store0[10*13+:13]!=13'h1FFF)+(err_wl_store0[9*13+:13]!=13'h1FFF)+(err_wl_store0[8*13+:13]!=13'h1FFF)+
(err_wl_store0[7*13+:13]!=13'h1FFF)+(err_wl_store0[6*13+:13]!=13'h1FFF)+(err_wl_store0[5*13+:13]!=13'h1FFF)+(err_wl_store0[4*13+:13]!=13'h1FFF)+
(err_wl_store0[3*13+:13]!=13'h1FFF)+(err_wl_store0[2*13+:13]!=13'h1FFF)+(err_wl_store0[1*13+:13]!=13'h1FFF)+(err_wl_store0[0*13+:13]!=13'h1FFF) ;

assign {bank0_err_wl63,bank0_err_wl62,bank0_err_wl61,bank0_err_wl60,bank0_err_wl59,bank0_err_wl58,bank0_err_wl57,bank0_err_wl56,bank0_err_wl55,bank0_err_wl54,
        bank0_err_wl53,bank0_err_wl52,bank0_err_wl51,bank0_err_wl50,bank0_err_wl49,bank0_err_wl48,bank0_err_wl47,bank0_err_wl46,bank0_err_wl45,bank0_err_wl44,
        bank0_err_wl43,bank0_err_wl42,bank0_err_wl41,bank0_err_wl40,bank0_err_wl39,bank0_err_wl38,bank0_err_wl37,bank0_err_wl36,bank0_err_wl35,bank0_err_wl34,
        bank0_err_wl33,bank0_err_wl32,bank0_err_wl31,bank0_err_wl30,bank0_err_wl29,bank0_err_wl28,bank0_err_wl27,bank0_err_wl26,bank0_err_wl25,bank0_err_wl24,
        bank0_err_wl23,bank0_err_wl22,bank0_err_wl21,bank0_err_wl20,bank0_err_wl19,bank0_err_wl18,bank0_err_wl17,bank0_err_wl16,bank0_err_wl15,bank0_err_wl14,
        bank0_err_wl13,bank0_err_wl12,bank0_err_wl11,bank0_err_wl10,bank0_err_wl9,bank0_err_wl8,bank0_err_wl7,bank0_err_wl6,bank0_err_wl5,bank0_err_wl4,
        bank0_err_wl3,bank0_err_wl2,bank0_err_wl1,bank0_err_wl0 } = err_wl_store0 ; 


        
////--------------------bank1------------------------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_wl_store1  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(global_bist_clr) begin
        err_wl_store1  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(bist_scan_fsm==BANK1 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same1 && (bank1_err_wl_cnt < 7'd64)) begin 
        err_wl_store1  <=  {err_wl_store1[63*ARRAY_ROW_ADDR_WIDTH-1:0],receive_row_addr} ;
    end
end

assign err_wl_same1 =  bist_scan_fsm==BANK1 ?
((err_wl_store1[63*13+:13]==receive_row_addr)||(err_wl_store1[62*13+:13]==receive_row_addr)||(err_wl_store1[61*13+:13]==receive_row_addr)||
(err_wl_store1[60*13+:13]==receive_row_addr)||(err_wl_store1[59*13+:13]==receive_row_addr)||(err_wl_store1[58*13+:13]==receive_row_addr)||
(err_wl_store1[57*13+:13]==receive_row_addr)||(err_wl_store1[56*13+:13]==receive_row_addr)||(err_wl_store1[55*13+:13]==receive_row_addr)||
(err_wl_store1[54*13+:13]==receive_row_addr)||(err_wl_store1[53*13+:13]==receive_row_addr)||(err_wl_store1[52*13+:13]==receive_row_addr)||
(err_wl_store1[51*13+:13]==receive_row_addr)||(err_wl_store1[50*13+:13]==receive_row_addr)||(err_wl_store1[49*13+:13]==receive_row_addr)||
(err_wl_store1[48*13+:13]==receive_row_addr)||(err_wl_store1[47*13+:13]==receive_row_addr)||(err_wl_store1[46*13+:13]==receive_row_addr)||
(err_wl_store1[45*13+:13]==receive_row_addr)||(err_wl_store1[44*13+:13]==receive_row_addr)||(err_wl_store1[43*13+:13]==receive_row_addr)||
(err_wl_store1[42*13+:13]==receive_row_addr)||(err_wl_store1[41*13+:13]==receive_row_addr)||(err_wl_store1[40*13+:13]==receive_row_addr)||
(err_wl_store1[39*13+:13]==receive_row_addr)||(err_wl_store1[38*13+:13]==receive_row_addr)||(err_wl_store1[37*13+:13]==receive_row_addr)||
(err_wl_store1[36*13+:13]==receive_row_addr)||(err_wl_store1[35*13+:13]==receive_row_addr)||(err_wl_store1[34*13+:13]==receive_row_addr)||
(err_wl_store1[33*13+:13]==receive_row_addr)||(err_wl_store1[32*13+:13]==receive_row_addr)||(err_wl_store1[31*13+:13]==receive_row_addr)||
(err_wl_store1[30*13+:13]==receive_row_addr)||(err_wl_store1[29*13+:13]==receive_row_addr)||(err_wl_store1[28*13+:13]==receive_row_addr)||
(err_wl_store1[27*13+:13]==receive_row_addr)||(err_wl_store1[26*13+:13]==receive_row_addr)||(err_wl_store1[25*13+:13]==receive_row_addr)||
(err_wl_store1[24*13+:13]==receive_row_addr)||(err_wl_store1[23*13+:13]==receive_row_addr)||(err_wl_store1[22*13+:13]==receive_row_addr)||
(err_wl_store1[21*13+:13]==receive_row_addr)||(err_wl_store1[20*13+:13]==receive_row_addr)||(err_wl_store1[19*13+:13]==receive_row_addr)||
(err_wl_store1[18*13+:13]==receive_row_addr)||(err_wl_store1[17*13+:13]==receive_row_addr)||(err_wl_store1[16*13+:13]==receive_row_addr)||
(err_wl_store1[15*13+:13]==receive_row_addr)||(err_wl_store1[14*13+:13]==receive_row_addr)||(err_wl_store1[13*13+:13]==receive_row_addr)||
(err_wl_store1[12*13+:13]==receive_row_addr)||(err_wl_store1[11*13+:13]==receive_row_addr)||(err_wl_store1[10*13+:13]==receive_row_addr)||
(err_wl_store1[9*13+:13]==receive_row_addr)||(err_wl_store1[8*13+:13]==receive_row_addr)||(err_wl_store1[7*13+:13]==receive_row_addr)||
(err_wl_store1[6*13+:13]==receive_row_addr)||(err_wl_store1[5*13+:13]==receive_row_addr)||(err_wl_store1[4*13+:13]==receive_row_addr)||
(err_wl_store1[3*13+:13]==receive_row_addr)||(err_wl_store1[2*13+:13]==receive_row_addr)||(err_wl_store1[1*13+:13]==receive_row_addr)||
(err_wl_store1[0*13+:13]==receive_row_addr)) : 1'b0;

assign bank1_err_wl_cnt = 
(err_wl_store1[63*13+:13]!=13'h1FFF)+(err_wl_store1[62*13+:13]!=13'h1FFF)+(err_wl_store1[61*13+:13]!=13'h1FFF)+(err_wl_store1[60*13+:13]!=13'h1FFF)+
(err_wl_store1[59*13+:13]!=13'h1FFF)+(err_wl_store1[58*13+:13]!=13'h1FFF)+(err_wl_store1[57*13+:13]!=13'h1FFF)+(err_wl_store1[56*13+:13]!=13'h1FFF)+
(err_wl_store1[55*13+:13]!=13'h1FFF)+(err_wl_store1[54*13+:13]!=13'h1FFF)+(err_wl_store1[53*13+:13]!=13'h1FFF)+(err_wl_store1[52*13+:13]!=13'h1FFF)+
(err_wl_store1[51*13+:13]!=13'h1FFF)+(err_wl_store1[50*13+:13]!=13'h1FFF)+(err_wl_store1[49*13+:13]!=13'h1FFF)+(err_wl_store1[48*13+:13]!=13'h1FFF)+
(err_wl_store1[47*13+:13]!=13'h1FFF)+(err_wl_store1[46*13+:13]!=13'h1FFF)+(err_wl_store1[45*13+:13]!=13'h1FFF)+(err_wl_store1[44*13+:13]!=13'h1FFF)+
(err_wl_store1[43*13+:13]!=13'h1FFF)+(err_wl_store1[42*13+:13]!=13'h1FFF)+(err_wl_store1[41*13+:13]!=13'h1FFF)+(err_wl_store1[40*13+:13]!=13'h1FFF)+
(err_wl_store1[39*13+:13]!=13'h1FFF)+(err_wl_store1[38*13+:13]!=13'h1FFF)+(err_wl_store1[37*13+:13]!=13'h1FFF)+(err_wl_store1[36*13+:13]!=13'h1FFF)+
(err_wl_store1[35*13+:13]!=13'h1FFF)+(err_wl_store1[34*13+:13]!=13'h1FFF)+(err_wl_store1[33*13+:13]!=13'h1FFF)+(err_wl_store1[32*13+:13]!=13'h1FFF)+
(err_wl_store1[31*13+:13]!=13'h1FFF)+(err_wl_store1[30*13+:13]!=13'h1FFF)+(err_wl_store1[29*13+:13]!=13'h1FFF)+(err_wl_store1[28*13+:13]!=13'h1FFF)+
(err_wl_store1[27*13+:13]!=13'h1FFF)+(err_wl_store1[26*13+:13]!=13'h1FFF)+(err_wl_store1[25*13+:13]!=13'h1FFF)+(err_wl_store1[24*13+:13]!=13'h1FFF)+
(err_wl_store1[23*13+:13]!=13'h1FFF)+(err_wl_store1[22*13+:13]!=13'h1FFF)+(err_wl_store1[21*13+:13]!=13'h1FFF)+(err_wl_store1[20*13+:13]!=13'h1FFF)+
(err_wl_store1[19*13+:13]!=13'h1FFF)+(err_wl_store1[18*13+:13]!=13'h1FFF)+(err_wl_store1[17*13+:13]!=13'h1FFF)+(err_wl_store1[16*13+:13]!=13'h1FFF)+
(err_wl_store1[15*13+:13]!=13'h1FFF)+(err_wl_store1[14*13+:13]!=13'h1FFF)+(err_wl_store1[13*13+:13]!=13'h1FFF)+(err_wl_store1[12*13+:13]!=13'h1FFF)+
(err_wl_store1[11*13+:13]!=13'h1FFF)+(err_wl_store1[10*13+:13]!=13'h1FFF)+(err_wl_store1[9*13+:13]!=13'h1FFF)+(err_wl_store1[8*13+:13]!=13'h1FFF)+
(err_wl_store1[7*13+:13]!=13'h1FFF)+(err_wl_store1[6*13+:13]!=13'h1FFF)+(err_wl_store1[5*13+:13]!=13'h1FFF)+(err_wl_store1[4*13+:13]!=13'h1FFF)+
(err_wl_store1[3*13+:13]!=13'h1FFF)+(err_wl_store1[2*13+:13]!=13'h1FFF)+(err_wl_store1[1*13+:13]!=13'h1FFF)+(err_wl_store1[0*13+:13]!=13'h1FFF) ;

assign {bank1_err_wl63,bank1_err_wl62,bank1_err_wl61,bank1_err_wl60,bank1_err_wl59,bank1_err_wl58,bank1_err_wl57,bank1_err_wl56,bank1_err_wl55,bank1_err_wl54,
        bank1_err_wl53,bank1_err_wl52,bank1_err_wl51,bank1_err_wl50,bank1_err_wl49,bank1_err_wl48,bank1_err_wl47,bank1_err_wl46,bank1_err_wl45,bank1_err_wl44,
        bank1_err_wl43,bank1_err_wl42,bank1_err_wl41,bank1_err_wl40,bank1_err_wl39,bank1_err_wl38,bank1_err_wl37,bank1_err_wl36,bank1_err_wl35,bank1_err_wl34,
        bank1_err_wl33,bank1_err_wl32,bank1_err_wl31,bank1_err_wl30,bank1_err_wl29,bank1_err_wl28,bank1_err_wl27,bank1_err_wl26,bank1_err_wl25,bank1_err_wl24,
        bank1_err_wl23,bank1_err_wl22,bank1_err_wl21,bank1_err_wl20,bank1_err_wl19,bank1_err_wl18,bank1_err_wl17,bank1_err_wl16,bank1_err_wl15,bank1_err_wl14,
        bank1_err_wl13,bank1_err_wl12,bank1_err_wl11,bank1_err_wl10,bank1_err_wl9,bank1_err_wl8,bank1_err_wl7,bank1_err_wl6,bank1_err_wl5,bank1_err_wl4,
        bank1_err_wl3,bank1_err_wl2,bank1_err_wl1,bank1_err_wl0 } = err_wl_store1 ; 
        
////--------------------bank2------------------------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_wl_store2  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(global_bist_clr) begin
        err_wl_store2  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(bist_scan_fsm==BANK2 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same2 && (bank2_err_wl_cnt < 7'd64)) begin 
        err_wl_store2  <=  {err_wl_store2[63*ARRAY_ROW_ADDR_WIDTH-1:0],receive_row_addr} ;
    end
end

assign err_wl_same2 =  bist_scan_fsm==BANK2 ?
((err_wl_store2[63*13+:13]==receive_row_addr)||(err_wl_store2[62*13+:13]==receive_row_addr)||(err_wl_store2[61*13+:13]==receive_row_addr)||
(err_wl_store2[60*13+:13]==receive_row_addr)||(err_wl_store2[59*13+:13]==receive_row_addr)||(err_wl_store2[58*13+:13]==receive_row_addr)||
(err_wl_store2[57*13+:13]==receive_row_addr)||(err_wl_store2[56*13+:13]==receive_row_addr)||(err_wl_store2[55*13+:13]==receive_row_addr)||
(err_wl_store2[54*13+:13]==receive_row_addr)||(err_wl_store2[53*13+:13]==receive_row_addr)||(err_wl_store2[52*13+:13]==receive_row_addr)||
(err_wl_store2[51*13+:13]==receive_row_addr)||(err_wl_store2[50*13+:13]==receive_row_addr)||(err_wl_store2[49*13+:13]==receive_row_addr)||
(err_wl_store2[48*13+:13]==receive_row_addr)||(err_wl_store2[47*13+:13]==receive_row_addr)||(err_wl_store2[46*13+:13]==receive_row_addr)||
(err_wl_store2[45*13+:13]==receive_row_addr)||(err_wl_store2[44*13+:13]==receive_row_addr)||(err_wl_store2[43*13+:13]==receive_row_addr)||
(err_wl_store2[42*13+:13]==receive_row_addr)||(err_wl_store2[41*13+:13]==receive_row_addr)||(err_wl_store2[40*13+:13]==receive_row_addr)||
(err_wl_store2[39*13+:13]==receive_row_addr)||(err_wl_store2[38*13+:13]==receive_row_addr)||(err_wl_store2[37*13+:13]==receive_row_addr)||
(err_wl_store2[36*13+:13]==receive_row_addr)||(err_wl_store2[35*13+:13]==receive_row_addr)||(err_wl_store2[34*13+:13]==receive_row_addr)||
(err_wl_store2[33*13+:13]==receive_row_addr)||(err_wl_store2[32*13+:13]==receive_row_addr)||(err_wl_store2[31*13+:13]==receive_row_addr)||
(err_wl_store2[30*13+:13]==receive_row_addr)||(err_wl_store2[29*13+:13]==receive_row_addr)||(err_wl_store2[28*13+:13]==receive_row_addr)||
(err_wl_store2[27*13+:13]==receive_row_addr)||(err_wl_store2[26*13+:13]==receive_row_addr)||(err_wl_store2[25*13+:13]==receive_row_addr)||
(err_wl_store2[24*13+:13]==receive_row_addr)||(err_wl_store2[23*13+:13]==receive_row_addr)||(err_wl_store2[22*13+:13]==receive_row_addr)||
(err_wl_store2[21*13+:13]==receive_row_addr)||(err_wl_store2[20*13+:13]==receive_row_addr)||(err_wl_store2[19*13+:13]==receive_row_addr)||
(err_wl_store2[18*13+:13]==receive_row_addr)||(err_wl_store2[17*13+:13]==receive_row_addr)||(err_wl_store2[16*13+:13]==receive_row_addr)||
(err_wl_store2[15*13+:13]==receive_row_addr)||(err_wl_store2[14*13+:13]==receive_row_addr)||(err_wl_store2[13*13+:13]==receive_row_addr)||
(err_wl_store2[12*13+:13]==receive_row_addr)||(err_wl_store2[11*13+:13]==receive_row_addr)||(err_wl_store2[10*13+:13]==receive_row_addr)||
(err_wl_store2[9*13+:13]==receive_row_addr)||(err_wl_store2[8*13+:13]==receive_row_addr)||(err_wl_store2[7*13+:13]==receive_row_addr)||
(err_wl_store2[6*13+:13]==receive_row_addr)||(err_wl_store2[5*13+:13]==receive_row_addr)||(err_wl_store2[4*13+:13]==receive_row_addr)||
(err_wl_store2[3*13+:13]==receive_row_addr)||(err_wl_store2[2*13+:13]==receive_row_addr)||(err_wl_store2[1*13+:13]==receive_row_addr)||
(err_wl_store2[0*13+:13]==receive_row_addr)) : 1'b0;

assign bank2_err_wl_cnt = 
(err_wl_store2[63*13+:13]!=13'h1FFF)+(err_wl_store2[62*13+:13]!=13'h1FFF)+(err_wl_store2[61*13+:13]!=13'h1FFF)+(err_wl_store2[60*13+:13]!=13'h1FFF)+
(err_wl_store2[59*13+:13]!=13'h1FFF)+(err_wl_store2[58*13+:13]!=13'h1FFF)+(err_wl_store2[57*13+:13]!=13'h1FFF)+(err_wl_store2[56*13+:13]!=13'h1FFF)+
(err_wl_store2[55*13+:13]!=13'h1FFF)+(err_wl_store2[54*13+:13]!=13'h1FFF)+(err_wl_store2[53*13+:13]!=13'h1FFF)+(err_wl_store2[52*13+:13]!=13'h1FFF)+
(err_wl_store2[51*13+:13]!=13'h1FFF)+(err_wl_store2[50*13+:13]!=13'h1FFF)+(err_wl_store2[49*13+:13]!=13'h1FFF)+(err_wl_store2[48*13+:13]!=13'h1FFF)+
(err_wl_store2[47*13+:13]!=13'h1FFF)+(err_wl_store2[46*13+:13]!=13'h1FFF)+(err_wl_store2[45*13+:13]!=13'h1FFF)+(err_wl_store2[44*13+:13]!=13'h1FFF)+
(err_wl_store2[43*13+:13]!=13'h1FFF)+(err_wl_store2[42*13+:13]!=13'h1FFF)+(err_wl_store2[41*13+:13]!=13'h1FFF)+(err_wl_store2[40*13+:13]!=13'h1FFF)+
(err_wl_store2[39*13+:13]!=13'h1FFF)+(err_wl_store2[38*13+:13]!=13'h1FFF)+(err_wl_store2[37*13+:13]!=13'h1FFF)+(err_wl_store2[36*13+:13]!=13'h1FFF)+
(err_wl_store2[35*13+:13]!=13'h1FFF)+(err_wl_store2[34*13+:13]!=13'h1FFF)+(err_wl_store2[33*13+:13]!=13'h1FFF)+(err_wl_store2[32*13+:13]!=13'h1FFF)+
(err_wl_store2[31*13+:13]!=13'h1FFF)+(err_wl_store2[30*13+:13]!=13'h1FFF)+(err_wl_store2[29*13+:13]!=13'h1FFF)+(err_wl_store2[28*13+:13]!=13'h1FFF)+
(err_wl_store2[27*13+:13]!=13'h1FFF)+(err_wl_store2[26*13+:13]!=13'h1FFF)+(err_wl_store2[25*13+:13]!=13'h1FFF)+(err_wl_store2[24*13+:13]!=13'h1FFF)+
(err_wl_store2[23*13+:13]!=13'h1FFF)+(err_wl_store2[22*13+:13]!=13'h1FFF)+(err_wl_store2[21*13+:13]!=13'h1FFF)+(err_wl_store2[20*13+:13]!=13'h1FFF)+
(err_wl_store2[19*13+:13]!=13'h1FFF)+(err_wl_store2[18*13+:13]!=13'h1FFF)+(err_wl_store2[17*13+:13]!=13'h1FFF)+(err_wl_store2[16*13+:13]!=13'h1FFF)+
(err_wl_store2[15*13+:13]!=13'h1FFF)+(err_wl_store2[14*13+:13]!=13'h1FFF)+(err_wl_store2[13*13+:13]!=13'h1FFF)+(err_wl_store2[12*13+:13]!=13'h1FFF)+
(err_wl_store2[11*13+:13]!=13'h1FFF)+(err_wl_store2[10*13+:13]!=13'h1FFF)+(err_wl_store2[9*13+:13]!=13'h1FFF)+(err_wl_store2[8*13+:13]!=13'h1FFF)+
(err_wl_store2[7*13+:13]!=13'h1FFF)+(err_wl_store2[6*13+:13]!=13'h1FFF)+(err_wl_store2[5*13+:13]!=13'h1FFF)+(err_wl_store2[4*13+:13]!=13'h1FFF)+
(err_wl_store2[3*13+:13]!=13'h1FFF)+(err_wl_store2[2*13+:13]!=13'h1FFF)+(err_wl_store2[1*13+:13]!=13'h1FFF)+(err_wl_store2[0*13+:13]!=13'h1FFF) ;

assign {bank2_err_wl63,bank2_err_wl62,bank2_err_wl61,bank2_err_wl60,bank2_err_wl59,bank2_err_wl58,bank2_err_wl57,bank2_err_wl56,bank2_err_wl55,bank2_err_wl54,
        bank2_err_wl53,bank2_err_wl52,bank2_err_wl51,bank2_err_wl50,bank2_err_wl49,bank2_err_wl48,bank2_err_wl47,bank2_err_wl46,bank2_err_wl45,bank2_err_wl44,
        bank2_err_wl43,bank2_err_wl42,bank2_err_wl41,bank2_err_wl40,bank2_err_wl39,bank2_err_wl38,bank2_err_wl37,bank2_err_wl36,bank2_err_wl35,bank2_err_wl34,
        bank2_err_wl33,bank2_err_wl32,bank2_err_wl31,bank2_err_wl30,bank2_err_wl29,bank2_err_wl28,bank2_err_wl27,bank2_err_wl26,bank2_err_wl25,bank2_err_wl24,
        bank2_err_wl23,bank2_err_wl22,bank2_err_wl21,bank2_err_wl20,bank2_err_wl19,bank2_err_wl18,bank2_err_wl17,bank2_err_wl16,bank2_err_wl15,bank2_err_wl14,
        bank2_err_wl13,bank2_err_wl12,bank2_err_wl11,bank2_err_wl10,bank2_err_wl9,bank2_err_wl8,bank2_err_wl7,bank2_err_wl6,bank2_err_wl5,bank2_err_wl4,
        bank2_err_wl3,bank2_err_wl2,bank2_err_wl1,bank2_err_wl0 } = err_wl_store2 ; 



assign bank_bist_wl_finish = {bank2_bist_wl_finish,bank1_bist_wl_finish,bank0_bist_wl_finish};
assign bank_bist_wl_success = {bank2_bist_wl_success,bank1_bist_wl_success,bank0_bist_wl_success};
assign bank_err_wl_cnt_change_flag = {bank2_err_wl_cnt_change_flag,bank1_err_wl_cnt_change_flag,bank0_err_wl_cnt_change_flag};

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank0_bist_wl_finish   <=  1'b0   ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank0_bist_wl_finish   <=  1'b0   ;
    end
    else if(bist_scan_fsm==BANK0 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (wl_scan_row_status && data_noback_req_cnt==5'h0))) begin
        bank0_bist_wl_finish   <=  1'b1   ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank1_bist_wl_finish   <=  1'b0   ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank1_bist_wl_finish   <=  1'b0   ;
    end
    else if(bist_scan_fsm==BANK1 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (wl_scan_row_status && data_noback_req_cnt==5'h0))) begin
        bank1_bist_wl_finish   <=  1'b1   ;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank2_bist_wl_finish   <=  1'b0   ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank2_bist_wl_finish   <=  1'b0   ;
    end
    else if(bist_scan_fsm==BANK2 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (wl_scan_row_status && data_noback_req_cnt==5'h0))) begin
        bank2_bist_wl_finish   <=  1'b1   ;
    end
end

assign bank3_bist_wl_fail = 1'b0;


always @(*)begin
    if(bist_scan_fsm==BANK0)
        wl_scan_row_status = bank0_bist_wl_fail ;
    else if(bist_scan_fsm==BANK1)
        wl_scan_row_status = bank1_bist_wl_fail ;
    else if(bist_scan_fsm==BANK2)
        wl_scan_row_status = bank2_bist_wl_fail ;
    else if(bist_scan_fsm==BANK3)
        wl_scan_row_status = bank3_bist_wl_fail ;
    else
        wl_scan_row_status = 1'b0 ;
end

assign bank0_bist_wl_success = bist_scan_fsm==BANK0 && bank0_bist_wl_finish && !bank0_bist_wl_fail ;
assign bank1_bist_wl_success = bist_scan_fsm==BANK1 && bank1_bist_wl_finish && !bank1_bist_wl_fail ;
assign bank2_bist_wl_success = bist_scan_fsm==BANK2 && bank2_bist_wl_finish && !bank2_bist_wl_fail ;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank0_bist_wl_fail  <=  1'b0 ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank0_bist_wl_fail  <=  1'b0 ;
    end
    else if(bist_scan_fsm==BANK0 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same0 && (bank0_err_wl_cnt==7'd64)) begin 
        bank0_bist_wl_fail  <=  1'b1 ;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank1_bist_wl_fail  <=  1'b0 ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank1_bist_wl_fail  <=  1'b0 ;
    end
    else if(bist_scan_fsm==BANK1 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same1 && (bank1_err_wl_cnt==7'd64)) begin 
        bank1_bist_wl_fail  <=  1'b1 ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank2_bist_wl_fail  <=  1'b0 ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank2_bist_wl_fail  <=  1'b0 ;
    end
    else if(bist_scan_fsm==BANK2 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same2 && (bank2_err_wl_cnt==7'd64)) begin 
        bank2_bist_wl_fail  <=  1'b1 ;
    end
end
    
assign  err_wl0       =   {bank2_err_wl0, bank1_err_wl0, bank0_err_wl0} ;
assign  err_wl1       =   {bank2_err_wl1, bank1_err_wl1, bank0_err_wl1} ;                  
assign  err_wl2       =   {bank2_err_wl2, bank1_err_wl2, bank0_err_wl2} ;                  
assign  err_wl3       =   {bank2_err_wl3, bank1_err_wl3, bank0_err_wl3} ;                  
assign  err_wl4       =   {bank2_err_wl4, bank1_err_wl4, bank0_err_wl4} ;                  
assign  err_wl5       =   {bank2_err_wl5, bank1_err_wl5, bank0_err_wl5} ;                  
assign  err_wl6       =   {bank2_err_wl6, bank1_err_wl6, bank0_err_wl6} ;                  
assign  err_wl7       =   {bank2_err_wl7, bank1_err_wl7, bank0_err_wl7} ;                  
assign  err_wl8       =   {bank2_err_wl8, bank1_err_wl8, bank0_err_wl8} ;                  
assign  err_wl9       =   {bank2_err_wl9, bank1_err_wl9, bank0_err_wl9} ;                  
assign  err_wl10      =   {bank2_err_wl10,bank1_err_wl10,bank0_err_wl10};                   
assign  err_wl11      =   {bank2_err_wl11,bank1_err_wl11,bank0_err_wl11};                   
assign  err_wl12      =   {bank2_err_wl12,bank1_err_wl12,bank0_err_wl12};                   
assign  err_wl13      =   {bank2_err_wl13,bank1_err_wl13,bank0_err_wl13};                   
assign  err_wl14      =   {bank2_err_wl14,bank1_err_wl14,bank0_err_wl14};                   
assign  err_wl15      =   {bank2_err_wl15,bank1_err_wl15,bank0_err_wl15};                   
assign  err_wl16      =   {bank2_err_wl16,bank1_err_wl16,bank0_err_wl16};                   
assign  err_wl17      =   {bank2_err_wl17,bank1_err_wl17,bank0_err_wl17};                   
assign  err_wl18      =   {bank2_err_wl18,bank1_err_wl18,bank0_err_wl18};                   
assign  err_wl19      =   {bank2_err_wl19,bank1_err_wl19,bank0_err_wl19};                   
assign  err_wl20      =   {bank2_err_wl20,bank1_err_wl20,bank0_err_wl20};                   
assign  err_wl21      =   {bank2_err_wl21,bank1_err_wl21,bank0_err_wl21};                   
assign  err_wl22      =   {bank2_err_wl22,bank1_err_wl22,bank0_err_wl22};                   
assign  err_wl23      =   {bank2_err_wl23,bank1_err_wl23,bank0_err_wl23};                   
assign  err_wl24      =   {bank2_err_wl24,bank1_err_wl24,bank0_err_wl24};                   
assign  err_wl25      =   {bank2_err_wl25,bank1_err_wl25,bank0_err_wl25};                   
assign  err_wl26      =   {bank2_err_wl26,bank1_err_wl26,bank0_err_wl26};                   
assign  err_wl27      =   {bank2_err_wl27,bank1_err_wl27,bank0_err_wl27};                   
assign  err_wl28      =   {bank2_err_wl28,bank1_err_wl28,bank0_err_wl28};                   
assign  err_wl29      =   {bank2_err_wl29,bank1_err_wl29,bank0_err_wl29};                   
assign  err_wl30      =   {bank2_err_wl30,bank1_err_wl30,bank0_err_wl30};                   
assign  err_wl31      =   {bank2_err_wl31,bank1_err_wl31,bank0_err_wl31};                   
assign  err_wl32      =   {bank2_err_wl32,bank1_err_wl32,bank0_err_wl32};                   
assign  err_wl33      =   {bank2_err_wl33,bank1_err_wl33,bank0_err_wl33};                   
assign  err_wl34      =   {bank2_err_wl34,bank1_err_wl34,bank0_err_wl34};                   
assign  err_wl35      =   {bank2_err_wl35,bank1_err_wl35,bank0_err_wl35};                   
assign  err_wl36      =   {bank2_err_wl36,bank1_err_wl36,bank0_err_wl36};                   
assign  err_wl37      =   {bank2_err_wl37,bank1_err_wl37,bank0_err_wl37};                   
assign  err_wl38      =   {bank2_err_wl38,bank1_err_wl38,bank0_err_wl38};                   
assign  err_wl39      =   {bank2_err_wl39,bank1_err_wl39,bank0_err_wl39};                   
assign  err_wl40      =   {bank2_err_wl40,bank1_err_wl40,bank0_err_wl40};                   
assign  err_wl41      =   {bank2_err_wl41,bank1_err_wl41,bank0_err_wl41};                   
assign  err_wl42      =   {bank2_err_wl42,bank1_err_wl42,bank0_err_wl42};                   
assign  err_wl43      =   {bank2_err_wl43,bank1_err_wl43,bank0_err_wl43};                   
assign  err_wl44      =   {bank2_err_wl44,bank1_err_wl44,bank0_err_wl44};                   
assign  err_wl45      =   {bank2_err_wl45,bank1_err_wl45,bank0_err_wl45};                   
assign  err_wl46      =   {bank2_err_wl46,bank1_err_wl46,bank0_err_wl46};                   
assign  err_wl47      =   {bank2_err_wl47,bank1_err_wl47,bank0_err_wl47};                   
assign  err_wl48      =   {bank2_err_wl48,bank1_err_wl48,bank0_err_wl48};                   
assign  err_wl49      =   {bank2_err_wl49,bank1_err_wl49,bank0_err_wl49};                   
assign  err_wl50      =   {bank2_err_wl50,bank1_err_wl50,bank0_err_wl50};                   
assign  err_wl51      =   {bank2_err_wl51,bank1_err_wl51,bank0_err_wl51};                   
assign  err_wl52      =   {bank2_err_wl52,bank1_err_wl52,bank0_err_wl52};                   
assign  err_wl53      =   {bank2_err_wl53,bank1_err_wl53,bank0_err_wl53};                   
assign  err_wl54      =   {bank2_err_wl54,bank1_err_wl54,bank0_err_wl54};                   
assign  err_wl55      =   {bank2_err_wl55,bank1_err_wl55,bank0_err_wl55};                   
assign  err_wl56      =   {bank2_err_wl56,bank1_err_wl56,bank0_err_wl56};                   
assign  err_wl57      =   {bank2_err_wl57,bank1_err_wl57,bank0_err_wl57};                   
assign  err_wl58      =   {bank2_err_wl58,bank1_err_wl58,bank0_err_wl58};                   
assign  err_wl59      =   {bank2_err_wl59,bank1_err_wl59,bank0_err_wl59};                   
assign  err_wl60      =   {bank2_err_wl60,bank1_err_wl60,bank0_err_wl60};                   
assign  err_wl61      =   {bank2_err_wl61,bank1_err_wl61,bank0_err_wl61};                   
assign  err_wl62      =   {bank2_err_wl62,bank1_err_wl62,bank0_err_wl62};                   
assign  err_wl63      =   {bank2_err_wl63,bank1_err_wl63,bank0_err_wl63};  
assign wl_single_pattern_done = ((!bank2_bist_wl_fail && receive_row_addr == wl_scan_row_end_addr) && (receive_col_addr == 7'h7F) && !wl_scan_rd_cnt_allow && wl_scan_rvalid && data_noback_req_cnt==5'h1 )|| wl_scan_row_status_pos;
assign bank_err_wl_cnt = {bank2_err_wl_cnt,bank1_err_wl_cnt,bank0_err_wl_cnt};

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_err_wl_cnt_r <= 7'h0 ;
    else if(bist_scan_fsm==BANK0 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (!bank0_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0))) 
        bank0_err_wl_cnt_r <= bank0_err_wl_cnt ;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank1_err_wl_cnt_r <= 7'h0 ;
    else if(bist_scan_fsm==BANK1 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (!bank1_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0))) 
        bank1_err_wl_cnt_r <= bank1_err_wl_cnt ;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank2_err_wl_cnt_r <= 7'h0 ;
    else if(bist_scan_fsm==BANK2 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (!bank2_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0))) 
        bank2_err_wl_cnt_r <= bank2_err_wl_cnt ;
end

//20250408 add by hy
wire    s_err_wl_cnt_change_cona;
wire    bank0_s_err_wl_cnt_change_conb;
wire    bank1_s_err_wl_cnt_change_conb;
wire    bank2_s_err_wl_cnt_change_conb;

assign  s_err_wl_cnt_change_cona = (wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num));
assign  bank0_s_err_wl_cnt_change_conb = (!bank0_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0);
assign  bank1_s_err_wl_cnt_change_conb = (!bank1_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0);
assign  bank2_s_err_wl_cnt_change_conb = (!bank2_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0);

//end by hy

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_err_wl_cnt_change_flag <= 1'b0;
    else if(global_mc_bist_start)
        bank0_err_wl_cnt_change_flag <= 1'b0;
    else if((bank0_err_wl_cnt != bank0_err_wl_cnt_r) && (s_err_wl_cnt_change_cona || bank0_s_err_wl_cnt_change_conb)) //20250408 add by hy
        bank0_err_wl_cnt_change_flag <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank1_err_wl_cnt_change_flag <= 1'b0;
    else if(global_mc_bist_start)
        bank1_err_wl_cnt_change_flag <= 1'b0;
    else if((bank1_err_wl_cnt != bank1_err_wl_cnt_r) && (s_err_wl_cnt_change_cona || bank1_s_err_wl_cnt_change_conb)) //20250408 add by hy
        bank1_err_wl_cnt_change_flag <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank2_err_wl_cnt_change_flag <= 1'b0;
    else if(global_mc_bist_start)
        bank2_err_wl_cnt_change_flag <= 1'b0;
    else if((bank2_err_wl_cnt != bank2_err_wl_cnt_r) && (s_err_wl_cnt_change_cona || bank2_s_err_wl_cnt_change_conb)) //20250408 add by hy
        bank2_err_wl_cnt_change_flag <= 1'b1;
end




end
else if(MC_SHORT_MODE==2)begin:inst2

wire   [6:0]                                     bank0_err_wl_cnt                   ; 
wire   [6:0]                                     bank1_err_wl_cnt                   ; 


reg    [ARRAY_ROW_ADDR_WIDTH*64-1:0]             err_wl_store0                      ;
reg    [ARRAY_ROW_ADDR_WIDTH*64-1:0]             err_wl_store1                      ;
wire                                             err_wl_same0                       ;
wire                                             err_wl_same1                       ;
reg                                              bank0_bist_wl_fail                 ;
reg                                              bank1_bist_wl_fail                 ;
wire                                             bank2_bist_wl_fail                 ;
wire                                             bank3_bist_wl_fail                 ;

wire                                             bank0_bist_wl_success              ; 
wire                                             bank1_bist_wl_success              ; 

reg                                              bank0_bist_wl_finish               ;
reg                                              bank1_bist_wl_finish               ;
reg                                              bank0_err_wl_cnt_change_flag       ; //1:diff 0: same
reg                                              bank1_err_wl_cnt_change_flag       ; 
reg    [6:0]                                     bank0_err_wl_cnt_r                 ;
reg    [6:0]                                     bank1_err_wl_cnt_r                 ;

wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl0                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl1                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl2                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl3                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl4                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl5                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl6                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl7                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl8                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl9                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl10                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl11                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl12                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl13                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl14                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl15                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl16                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl17                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl18                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl19                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl20                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl21                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl22                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl23                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl24                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl25                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl26                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl27                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl28                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl29                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl30                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl31                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl32                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl33                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl34                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl35                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl36                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl37                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl38                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl39                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl40                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl41                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl42                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl43                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl44                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl45                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl46                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl47                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl48                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl49                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl50                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl51                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl52                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl53                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl54                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl55                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl56                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl57                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl58                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl59                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl60                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl61                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl62                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl63                     ;

wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl0                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl1                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl2                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl3                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl4                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl5                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl6                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl7                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl8                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl9                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl10                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl11                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl12                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl13                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl14                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl15                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl16                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl17                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl18                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl19                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl20                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl21                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl22                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl23                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl24                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl25                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl26                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl27                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl28                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl29                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl30                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl31                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl32                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl33                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl34                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl35                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl36                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl37                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl38                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl39                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl40                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl41                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl42                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl43                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl44                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl45                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl46                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl47                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl48                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl49                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl50                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl51                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl52                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl53                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl54                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl55                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl56                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl57                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl58                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl59                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl60                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl61                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl62                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank1_err_wl63                     ;


////--------------------bank0------------------------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_wl_store0  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(global_bist_clr) begin
        err_wl_store0  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(bist_scan_fsm==BANK0 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same0 && (bank0_err_wl_cnt<7'd64)) begin 
        err_wl_store0  <=  {err_wl_store0[63*ARRAY_ROW_ADDR_WIDTH-1:0],receive_row_addr} ;
    end
end

assign err_wl_same0 = bist_scan_fsm==BANK0 ? 
((err_wl_store0[63*13+:13]==receive_row_addr)||(err_wl_store0[62*13+:13]==receive_row_addr)||(err_wl_store0[61*13+:13]==receive_row_addr)||
(err_wl_store0[60*13+:13]==receive_row_addr)||(err_wl_store0[59*13+:13]==receive_row_addr)||(err_wl_store0[58*13+:13]==receive_row_addr)||
(err_wl_store0[57*13+:13]==receive_row_addr)||(err_wl_store0[56*13+:13]==receive_row_addr)||(err_wl_store0[55*13+:13]==receive_row_addr)||
(err_wl_store0[54*13+:13]==receive_row_addr)||(err_wl_store0[53*13+:13]==receive_row_addr)||(err_wl_store0[52*13+:13]==receive_row_addr)||
(err_wl_store0[51*13+:13]==receive_row_addr)||(err_wl_store0[50*13+:13]==receive_row_addr)||(err_wl_store0[49*13+:13]==receive_row_addr)||
(err_wl_store0[48*13+:13]==receive_row_addr)||(err_wl_store0[47*13+:13]==receive_row_addr)||(err_wl_store0[46*13+:13]==receive_row_addr)||
(err_wl_store0[45*13+:13]==receive_row_addr)||(err_wl_store0[44*13+:13]==receive_row_addr)||(err_wl_store0[43*13+:13]==receive_row_addr)||
(err_wl_store0[42*13+:13]==receive_row_addr)||(err_wl_store0[41*13+:13]==receive_row_addr)||(err_wl_store0[40*13+:13]==receive_row_addr)||
(err_wl_store0[39*13+:13]==receive_row_addr)||(err_wl_store0[38*13+:13]==receive_row_addr)||(err_wl_store0[37*13+:13]==receive_row_addr)||
(err_wl_store0[36*13+:13]==receive_row_addr)||(err_wl_store0[35*13+:13]==receive_row_addr)||(err_wl_store0[34*13+:13]==receive_row_addr)||
(err_wl_store0[33*13+:13]==receive_row_addr)||(err_wl_store0[32*13+:13]==receive_row_addr)||(err_wl_store0[31*13+:13]==receive_row_addr)||
(err_wl_store0[30*13+:13]==receive_row_addr)||(err_wl_store0[29*13+:13]==receive_row_addr)||(err_wl_store0[28*13+:13]==receive_row_addr)||
(err_wl_store0[27*13+:13]==receive_row_addr)||(err_wl_store0[26*13+:13]==receive_row_addr)||(err_wl_store0[25*13+:13]==receive_row_addr)||
(err_wl_store0[24*13+:13]==receive_row_addr)||(err_wl_store0[23*13+:13]==receive_row_addr)||(err_wl_store0[22*13+:13]==receive_row_addr)||
(err_wl_store0[21*13+:13]==receive_row_addr)||(err_wl_store0[20*13+:13]==receive_row_addr)||(err_wl_store0[19*13+:13]==receive_row_addr)||
(err_wl_store0[18*13+:13]==receive_row_addr)||(err_wl_store0[17*13+:13]==receive_row_addr)||(err_wl_store0[16*13+:13]==receive_row_addr)||
(err_wl_store0[15*13+:13]==receive_row_addr)||(err_wl_store0[14*13+:13]==receive_row_addr)||(err_wl_store0[13*13+:13]==receive_row_addr)||
(err_wl_store0[12*13+:13]==receive_row_addr)||(err_wl_store0[11*13+:13]==receive_row_addr)||(err_wl_store0[10*13+:13]==receive_row_addr)||
(err_wl_store0[9*13+:13]==receive_row_addr)||(err_wl_store0[8*13+:13]==receive_row_addr)||(err_wl_store0[7*13+:13]==receive_row_addr)||
(err_wl_store0[6*13+:13]==receive_row_addr)||(err_wl_store0[5*13+:13]==receive_row_addr)||(err_wl_store0[4*13+:13]==receive_row_addr)||
(err_wl_store0[3*13+:13]==receive_row_addr)||(err_wl_store0[2*13+:13]==receive_row_addr)||(err_wl_store0[1*13+:13]==receive_row_addr)||
(err_wl_store0[0*13+:13]==receive_row_addr)) : 1'b0;

assign bank0_err_wl_cnt = 
(err_wl_store0[63*13+:13]!=13'h1FFF)+(err_wl_store0[62*13+:13]!=13'h1FFF)+(err_wl_store0[61*13+:13]!=13'h1FFF)+(err_wl_store0[60*13+:13]!=13'h1FFF)+
(err_wl_store0[59*13+:13]!=13'h1FFF)+(err_wl_store0[58*13+:13]!=13'h1FFF)+(err_wl_store0[57*13+:13]!=13'h1FFF)+(err_wl_store0[56*13+:13]!=13'h1FFF)+
(err_wl_store0[55*13+:13]!=13'h1FFF)+(err_wl_store0[54*13+:13]!=13'h1FFF)+(err_wl_store0[53*13+:13]!=13'h1FFF)+(err_wl_store0[52*13+:13]!=13'h1FFF)+
(err_wl_store0[51*13+:13]!=13'h1FFF)+(err_wl_store0[50*13+:13]!=13'h1FFF)+(err_wl_store0[49*13+:13]!=13'h1FFF)+(err_wl_store0[48*13+:13]!=13'h1FFF)+
(err_wl_store0[47*13+:13]!=13'h1FFF)+(err_wl_store0[46*13+:13]!=13'h1FFF)+(err_wl_store0[45*13+:13]!=13'h1FFF)+(err_wl_store0[44*13+:13]!=13'h1FFF)+
(err_wl_store0[43*13+:13]!=13'h1FFF)+(err_wl_store0[42*13+:13]!=13'h1FFF)+(err_wl_store0[41*13+:13]!=13'h1FFF)+(err_wl_store0[40*13+:13]!=13'h1FFF)+
(err_wl_store0[39*13+:13]!=13'h1FFF)+(err_wl_store0[38*13+:13]!=13'h1FFF)+(err_wl_store0[37*13+:13]!=13'h1FFF)+(err_wl_store0[36*13+:13]!=13'h1FFF)+
(err_wl_store0[35*13+:13]!=13'h1FFF)+(err_wl_store0[34*13+:13]!=13'h1FFF)+(err_wl_store0[33*13+:13]!=13'h1FFF)+(err_wl_store0[32*13+:13]!=13'h1FFF)+
(err_wl_store0[31*13+:13]!=13'h1FFF)+(err_wl_store0[30*13+:13]!=13'h1FFF)+(err_wl_store0[29*13+:13]!=13'h1FFF)+(err_wl_store0[28*13+:13]!=13'h1FFF)+
(err_wl_store0[27*13+:13]!=13'h1FFF)+(err_wl_store0[26*13+:13]!=13'h1FFF)+(err_wl_store0[25*13+:13]!=13'h1FFF)+(err_wl_store0[24*13+:13]!=13'h1FFF)+
(err_wl_store0[23*13+:13]!=13'h1FFF)+(err_wl_store0[22*13+:13]!=13'h1FFF)+(err_wl_store0[21*13+:13]!=13'h1FFF)+(err_wl_store0[20*13+:13]!=13'h1FFF)+
(err_wl_store0[19*13+:13]!=13'h1FFF)+(err_wl_store0[18*13+:13]!=13'h1FFF)+(err_wl_store0[17*13+:13]!=13'h1FFF)+(err_wl_store0[16*13+:13]!=13'h1FFF)+
(err_wl_store0[15*13+:13]!=13'h1FFF)+(err_wl_store0[14*13+:13]!=13'h1FFF)+(err_wl_store0[13*13+:13]!=13'h1FFF)+(err_wl_store0[12*13+:13]!=13'h1FFF)+
(err_wl_store0[11*13+:13]!=13'h1FFF)+(err_wl_store0[10*13+:13]!=13'h1FFF)+(err_wl_store0[9*13+:13]!=13'h1FFF)+(err_wl_store0[8*13+:13]!=13'h1FFF)+
(err_wl_store0[7*13+:13]!=13'h1FFF)+(err_wl_store0[6*13+:13]!=13'h1FFF)+(err_wl_store0[5*13+:13]!=13'h1FFF)+(err_wl_store0[4*13+:13]!=13'h1FFF)+
(err_wl_store0[3*13+:13]!=13'h1FFF)+(err_wl_store0[2*13+:13]!=13'h1FFF)+(err_wl_store0[1*13+:13]!=13'h1FFF)+(err_wl_store0[0*13+:13]!=13'h1FFF) ;

assign {bank0_err_wl63,bank0_err_wl62,bank0_err_wl61,bank0_err_wl60,bank0_err_wl59,bank0_err_wl58,bank0_err_wl57,bank0_err_wl56,bank0_err_wl55,bank0_err_wl54,
        bank0_err_wl53,bank0_err_wl52,bank0_err_wl51,bank0_err_wl50,bank0_err_wl49,bank0_err_wl48,bank0_err_wl47,bank0_err_wl46,bank0_err_wl45,bank0_err_wl44,
        bank0_err_wl43,bank0_err_wl42,bank0_err_wl41,bank0_err_wl40,bank0_err_wl39,bank0_err_wl38,bank0_err_wl37,bank0_err_wl36,bank0_err_wl35,bank0_err_wl34,
        bank0_err_wl33,bank0_err_wl32,bank0_err_wl31,bank0_err_wl30,bank0_err_wl29,bank0_err_wl28,bank0_err_wl27,bank0_err_wl26,bank0_err_wl25,bank0_err_wl24,
        bank0_err_wl23,bank0_err_wl22,bank0_err_wl21,bank0_err_wl20,bank0_err_wl19,bank0_err_wl18,bank0_err_wl17,bank0_err_wl16,bank0_err_wl15,bank0_err_wl14,
        bank0_err_wl13,bank0_err_wl12,bank0_err_wl11,bank0_err_wl10,bank0_err_wl9,bank0_err_wl8,bank0_err_wl7,bank0_err_wl6,bank0_err_wl5,bank0_err_wl4,
        bank0_err_wl3,bank0_err_wl2,bank0_err_wl1,bank0_err_wl0 } = err_wl_store0 ; 


        
////--------------------bank1------------------------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_wl_store1  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(global_bist_clr) begin
        err_wl_store1  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(bist_scan_fsm==BANK1 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same1 && (bank1_err_wl_cnt < 7'd64)) begin 
        err_wl_store1  <=  {err_wl_store1[63*ARRAY_ROW_ADDR_WIDTH-1:0],receive_row_addr} ;
    end
end

assign err_wl_same1 =  bist_scan_fsm==BANK1 ?
((err_wl_store1[63*13+:13]==receive_row_addr)||(err_wl_store1[62*13+:13]==receive_row_addr)||(err_wl_store1[61*13+:13]==receive_row_addr)||
(err_wl_store1[60*13+:13]==receive_row_addr)||(err_wl_store1[59*13+:13]==receive_row_addr)||(err_wl_store1[58*13+:13]==receive_row_addr)||
(err_wl_store1[57*13+:13]==receive_row_addr)||(err_wl_store1[56*13+:13]==receive_row_addr)||(err_wl_store1[55*13+:13]==receive_row_addr)||
(err_wl_store1[54*13+:13]==receive_row_addr)||(err_wl_store1[53*13+:13]==receive_row_addr)||(err_wl_store1[52*13+:13]==receive_row_addr)||
(err_wl_store1[51*13+:13]==receive_row_addr)||(err_wl_store1[50*13+:13]==receive_row_addr)||(err_wl_store1[49*13+:13]==receive_row_addr)||
(err_wl_store1[48*13+:13]==receive_row_addr)||(err_wl_store1[47*13+:13]==receive_row_addr)||(err_wl_store1[46*13+:13]==receive_row_addr)||
(err_wl_store1[45*13+:13]==receive_row_addr)||(err_wl_store1[44*13+:13]==receive_row_addr)||(err_wl_store1[43*13+:13]==receive_row_addr)||
(err_wl_store1[42*13+:13]==receive_row_addr)||(err_wl_store1[41*13+:13]==receive_row_addr)||(err_wl_store1[40*13+:13]==receive_row_addr)||
(err_wl_store1[39*13+:13]==receive_row_addr)||(err_wl_store1[38*13+:13]==receive_row_addr)||(err_wl_store1[37*13+:13]==receive_row_addr)||
(err_wl_store1[36*13+:13]==receive_row_addr)||(err_wl_store1[35*13+:13]==receive_row_addr)||(err_wl_store1[34*13+:13]==receive_row_addr)||
(err_wl_store1[33*13+:13]==receive_row_addr)||(err_wl_store1[32*13+:13]==receive_row_addr)||(err_wl_store1[31*13+:13]==receive_row_addr)||
(err_wl_store1[30*13+:13]==receive_row_addr)||(err_wl_store1[29*13+:13]==receive_row_addr)||(err_wl_store1[28*13+:13]==receive_row_addr)||
(err_wl_store1[27*13+:13]==receive_row_addr)||(err_wl_store1[26*13+:13]==receive_row_addr)||(err_wl_store1[25*13+:13]==receive_row_addr)||
(err_wl_store1[24*13+:13]==receive_row_addr)||(err_wl_store1[23*13+:13]==receive_row_addr)||(err_wl_store1[22*13+:13]==receive_row_addr)||
(err_wl_store1[21*13+:13]==receive_row_addr)||(err_wl_store1[20*13+:13]==receive_row_addr)||(err_wl_store1[19*13+:13]==receive_row_addr)||
(err_wl_store1[18*13+:13]==receive_row_addr)||(err_wl_store1[17*13+:13]==receive_row_addr)||(err_wl_store1[16*13+:13]==receive_row_addr)||
(err_wl_store1[15*13+:13]==receive_row_addr)||(err_wl_store1[14*13+:13]==receive_row_addr)||(err_wl_store1[13*13+:13]==receive_row_addr)||
(err_wl_store1[12*13+:13]==receive_row_addr)||(err_wl_store1[11*13+:13]==receive_row_addr)||(err_wl_store1[10*13+:13]==receive_row_addr)||
(err_wl_store1[9*13+:13]==receive_row_addr)||(err_wl_store1[8*13+:13]==receive_row_addr)||(err_wl_store1[7*13+:13]==receive_row_addr)||
(err_wl_store1[6*13+:13]==receive_row_addr)||(err_wl_store1[5*13+:13]==receive_row_addr)||(err_wl_store1[4*13+:13]==receive_row_addr)||
(err_wl_store1[3*13+:13]==receive_row_addr)||(err_wl_store1[2*13+:13]==receive_row_addr)||(err_wl_store1[1*13+:13]==receive_row_addr)||
(err_wl_store1[0*13+:13]==receive_row_addr)) : 1'b0;

assign bank1_err_wl_cnt = 
(err_wl_store1[63*13+:13]!=13'h1FFF)+(err_wl_store1[62*13+:13]!=13'h1FFF)+(err_wl_store1[61*13+:13]!=13'h1FFF)+(err_wl_store1[60*13+:13]!=13'h1FFF)+
(err_wl_store1[59*13+:13]!=13'h1FFF)+(err_wl_store1[58*13+:13]!=13'h1FFF)+(err_wl_store1[57*13+:13]!=13'h1FFF)+(err_wl_store1[56*13+:13]!=13'h1FFF)+
(err_wl_store1[55*13+:13]!=13'h1FFF)+(err_wl_store1[54*13+:13]!=13'h1FFF)+(err_wl_store1[53*13+:13]!=13'h1FFF)+(err_wl_store1[52*13+:13]!=13'h1FFF)+
(err_wl_store1[51*13+:13]!=13'h1FFF)+(err_wl_store1[50*13+:13]!=13'h1FFF)+(err_wl_store1[49*13+:13]!=13'h1FFF)+(err_wl_store1[48*13+:13]!=13'h1FFF)+
(err_wl_store1[47*13+:13]!=13'h1FFF)+(err_wl_store1[46*13+:13]!=13'h1FFF)+(err_wl_store1[45*13+:13]!=13'h1FFF)+(err_wl_store1[44*13+:13]!=13'h1FFF)+
(err_wl_store1[43*13+:13]!=13'h1FFF)+(err_wl_store1[42*13+:13]!=13'h1FFF)+(err_wl_store1[41*13+:13]!=13'h1FFF)+(err_wl_store1[40*13+:13]!=13'h1FFF)+
(err_wl_store1[39*13+:13]!=13'h1FFF)+(err_wl_store1[38*13+:13]!=13'h1FFF)+(err_wl_store1[37*13+:13]!=13'h1FFF)+(err_wl_store1[36*13+:13]!=13'h1FFF)+
(err_wl_store1[35*13+:13]!=13'h1FFF)+(err_wl_store1[34*13+:13]!=13'h1FFF)+(err_wl_store1[33*13+:13]!=13'h1FFF)+(err_wl_store1[32*13+:13]!=13'h1FFF)+
(err_wl_store1[31*13+:13]!=13'h1FFF)+(err_wl_store1[30*13+:13]!=13'h1FFF)+(err_wl_store1[29*13+:13]!=13'h1FFF)+(err_wl_store1[28*13+:13]!=13'h1FFF)+
(err_wl_store1[27*13+:13]!=13'h1FFF)+(err_wl_store1[26*13+:13]!=13'h1FFF)+(err_wl_store1[25*13+:13]!=13'h1FFF)+(err_wl_store1[24*13+:13]!=13'h1FFF)+
(err_wl_store1[23*13+:13]!=13'h1FFF)+(err_wl_store1[22*13+:13]!=13'h1FFF)+(err_wl_store1[21*13+:13]!=13'h1FFF)+(err_wl_store1[20*13+:13]!=13'h1FFF)+
(err_wl_store1[19*13+:13]!=13'h1FFF)+(err_wl_store1[18*13+:13]!=13'h1FFF)+(err_wl_store1[17*13+:13]!=13'h1FFF)+(err_wl_store1[16*13+:13]!=13'h1FFF)+
(err_wl_store1[15*13+:13]!=13'h1FFF)+(err_wl_store1[14*13+:13]!=13'h1FFF)+(err_wl_store1[13*13+:13]!=13'h1FFF)+(err_wl_store1[12*13+:13]!=13'h1FFF)+
(err_wl_store1[11*13+:13]!=13'h1FFF)+(err_wl_store1[10*13+:13]!=13'h1FFF)+(err_wl_store1[9*13+:13]!=13'h1FFF)+(err_wl_store1[8*13+:13]!=13'h1FFF)+
(err_wl_store1[7*13+:13]!=13'h1FFF)+(err_wl_store1[6*13+:13]!=13'h1FFF)+(err_wl_store1[5*13+:13]!=13'h1FFF)+(err_wl_store1[4*13+:13]!=13'h1FFF)+
(err_wl_store1[3*13+:13]!=13'h1FFF)+(err_wl_store1[2*13+:13]!=13'h1FFF)+(err_wl_store1[1*13+:13]!=13'h1FFF)+(err_wl_store1[0*13+:13]!=13'h1FFF) ;

assign {bank1_err_wl63,bank1_err_wl62,bank1_err_wl61,bank1_err_wl60,bank1_err_wl59,bank1_err_wl58,bank1_err_wl57,bank1_err_wl56,bank1_err_wl55,bank1_err_wl54,
        bank1_err_wl53,bank1_err_wl52,bank1_err_wl51,bank1_err_wl50,bank1_err_wl49,bank1_err_wl48,bank1_err_wl47,bank1_err_wl46,bank1_err_wl45,bank1_err_wl44,
        bank1_err_wl43,bank1_err_wl42,bank1_err_wl41,bank1_err_wl40,bank1_err_wl39,bank1_err_wl38,bank1_err_wl37,bank1_err_wl36,bank1_err_wl35,bank1_err_wl34,
        bank1_err_wl33,bank1_err_wl32,bank1_err_wl31,bank1_err_wl30,bank1_err_wl29,bank1_err_wl28,bank1_err_wl27,bank1_err_wl26,bank1_err_wl25,bank1_err_wl24,
        bank1_err_wl23,bank1_err_wl22,bank1_err_wl21,bank1_err_wl20,bank1_err_wl19,bank1_err_wl18,bank1_err_wl17,bank1_err_wl16,bank1_err_wl15,bank1_err_wl14,
        bank1_err_wl13,bank1_err_wl12,bank1_err_wl11,bank1_err_wl10,bank1_err_wl9,bank1_err_wl8,bank1_err_wl7,bank1_err_wl6,bank1_err_wl5,bank1_err_wl4,
        bank1_err_wl3,bank1_err_wl2,bank1_err_wl1,bank1_err_wl0 } = err_wl_store1 ; 
        



assign bank_bist_wl_finish = {bank1_bist_wl_finish,bank0_bist_wl_finish};
assign bank_bist_wl_success = {bank1_bist_wl_success,bank0_bist_wl_success};
assign bank_err_wl_cnt_change_flag = {bank1_err_wl_cnt_change_flag,bank0_err_wl_cnt_change_flag};


always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank0_bist_wl_finish   <=  1'b0   ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank0_bist_wl_finish   <=  1'b0   ;
    end
    else if(bist_scan_fsm==BANK0 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (wl_scan_row_status && data_noback_req_cnt==5'h0))) begin
        bank0_bist_wl_finish   <=  1'b1   ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank1_bist_wl_finish   <=  1'b0   ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank1_bist_wl_finish   <=  1'b0   ;
    end
    else if(bist_scan_fsm==BANK1 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (wl_scan_row_status && data_noback_req_cnt==5'h0))) begin
        bank1_bist_wl_finish   <=  1'b1   ;
    end
end





assign bank2_bist_wl_fail = 1'b0;
assign bank3_bist_wl_fail = 1'b0;


always @(*)begin
    if(bist_scan_fsm==BANK0)
        wl_scan_row_status = bank0_bist_wl_fail ;
    else if(bist_scan_fsm==BANK1)
        wl_scan_row_status = bank1_bist_wl_fail ;
    else if(bist_scan_fsm==BANK2)
        wl_scan_row_status = bank2_bist_wl_fail ;
    else if(bist_scan_fsm==BANK3)
        wl_scan_row_status = bank3_bist_wl_fail ;
    else
        wl_scan_row_status = 1'b0 ;
end

assign bank0_bist_wl_success = bist_scan_fsm==BANK0 && bank0_bist_wl_finish && !bank0_bist_wl_fail ;
assign bank1_bist_wl_success = bist_scan_fsm==BANK1 && bank1_bist_wl_finish && !bank1_bist_wl_fail ;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank0_bist_wl_fail  <=  1'b0 ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank0_bist_wl_fail  <=  1'b0 ;
    end
    else if(bist_scan_fsm==BANK0 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same0 && (bank0_err_wl_cnt==7'd64)) begin 
        bank0_bist_wl_fail  <=  1'b1 ;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank1_bist_wl_fail  <=  1'b0 ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank1_bist_wl_fail  <=  1'b0 ;
    end
    else if(bist_scan_fsm==BANK1 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same1 && (bank1_err_wl_cnt==7'd64)) begin 
        bank1_bist_wl_fail  <=  1'b1 ;
    end
end

assign  err_wl0       =   {bank1_err_wl0, bank0_err_wl0} ;
assign  err_wl1       =   {bank1_err_wl1, bank0_err_wl1} ;                  
assign  err_wl2       =   {bank1_err_wl2, bank0_err_wl2} ;                  
assign  err_wl3       =   {bank1_err_wl3, bank0_err_wl3} ;                  
assign  err_wl4       =   {bank1_err_wl4, bank0_err_wl4} ;                  
assign  err_wl5       =   {bank1_err_wl5, bank0_err_wl5} ;                  
assign  err_wl6       =   {bank1_err_wl6, bank0_err_wl6} ;                  
assign  err_wl7       =   {bank1_err_wl7, bank0_err_wl7} ;                  
assign  err_wl8       =   {bank1_err_wl8, bank0_err_wl8} ;                  
assign  err_wl9       =   {bank1_err_wl9, bank0_err_wl9} ;                  
assign  err_wl10      =   {bank1_err_wl10,bank0_err_wl10};                   
assign  err_wl11      =   {bank1_err_wl11,bank0_err_wl11};                   
assign  err_wl12      =   {bank1_err_wl12,bank0_err_wl12};                   
assign  err_wl13      =   {bank1_err_wl13,bank0_err_wl13};                   
assign  err_wl14      =   {bank1_err_wl14,bank0_err_wl14};                   
assign  err_wl15      =   {bank1_err_wl15,bank0_err_wl15};                   
assign  err_wl16      =   {bank1_err_wl16,bank0_err_wl16};                   
assign  err_wl17      =   {bank1_err_wl17,bank0_err_wl17};                   
assign  err_wl18      =   {bank1_err_wl18,bank0_err_wl18};                   
assign  err_wl19      =   {bank1_err_wl19,bank0_err_wl19};                   
assign  err_wl20      =   {bank1_err_wl20,bank0_err_wl20};                   
assign  err_wl21      =   {bank1_err_wl21,bank0_err_wl21};                   
assign  err_wl22      =   {bank1_err_wl22,bank0_err_wl22};                   
assign  err_wl23      =   {bank1_err_wl23,bank0_err_wl23};                   
assign  err_wl24      =   {bank1_err_wl24,bank0_err_wl24};                   
assign  err_wl25      =   {bank1_err_wl25,bank0_err_wl25};                   
assign  err_wl26      =   {bank1_err_wl26,bank0_err_wl26};                   
assign  err_wl27      =   {bank1_err_wl27,bank0_err_wl27};                   
assign  err_wl28      =   {bank1_err_wl28,bank0_err_wl28};                   
assign  err_wl29      =   {bank1_err_wl29,bank0_err_wl29};                   
assign  err_wl30      =   {bank1_err_wl30,bank0_err_wl30};                   
assign  err_wl31      =   {bank1_err_wl31,bank0_err_wl31};                   
assign  err_wl32      =   {bank1_err_wl32,bank0_err_wl32};                   
assign  err_wl33      =   {bank1_err_wl33,bank0_err_wl33};                   
assign  err_wl34      =   {bank1_err_wl34,bank0_err_wl34};                   
assign  err_wl35      =   {bank1_err_wl35,bank0_err_wl35};                   
assign  err_wl36      =   {bank1_err_wl36,bank0_err_wl36};                   
assign  err_wl37      =   {bank1_err_wl37,bank0_err_wl37};                   
assign  err_wl38      =   {bank1_err_wl38,bank0_err_wl38};                   
assign  err_wl39      =   {bank1_err_wl39,bank0_err_wl39};                   
assign  err_wl40      =   {bank1_err_wl40,bank0_err_wl40};                   
assign  err_wl41      =   {bank1_err_wl41,bank0_err_wl41};                   
assign  err_wl42      =   {bank1_err_wl42,bank0_err_wl42};                   
assign  err_wl43      =   {bank1_err_wl43,bank0_err_wl43};                   
assign  err_wl44      =   {bank1_err_wl44,bank0_err_wl44};                   
assign  err_wl45      =   {bank1_err_wl45,bank0_err_wl45};                   
assign  err_wl46      =   {bank1_err_wl46,bank0_err_wl46};                   
assign  err_wl47      =   {bank1_err_wl47,bank0_err_wl47};                   
assign  err_wl48      =   {bank1_err_wl48,bank0_err_wl48};                   
assign  err_wl49      =   {bank1_err_wl49,bank0_err_wl49};                   
assign  err_wl50      =   {bank1_err_wl50,bank0_err_wl50};                   
assign  err_wl51      =   {bank1_err_wl51,bank0_err_wl51};                   
assign  err_wl52      =   {bank1_err_wl52,bank0_err_wl52};                   
assign  err_wl53      =   {bank1_err_wl53,bank0_err_wl53};                   
assign  err_wl54      =   {bank1_err_wl54,bank0_err_wl54};                   
assign  err_wl55      =   {bank1_err_wl55,bank0_err_wl55};                   
assign  err_wl56      =   {bank1_err_wl56,bank0_err_wl56};                   
assign  err_wl57      =   {bank1_err_wl57,bank0_err_wl57};                   
assign  err_wl58      =   {bank1_err_wl58,bank0_err_wl58};                   
assign  err_wl59      =   {bank1_err_wl59,bank0_err_wl59};                   
assign  err_wl60      =   {bank1_err_wl60,bank0_err_wl60};                   
assign  err_wl61      =   {bank1_err_wl61,bank0_err_wl61};                   
assign  err_wl62      =   {bank1_err_wl62,bank0_err_wl62};                   
assign  err_wl63      =   {bank1_err_wl63,bank0_err_wl63}; 
assign wl_single_pattern_done = ((!bank1_bist_wl_fail && receive_row_addr == wl_scan_row_end_addr) && (receive_col_addr == 7'h7F) && !wl_scan_rd_cnt_allow && wl_scan_rvalid && data_noback_req_cnt==5'h1 )|| wl_scan_row_status_pos;
assign bank_err_wl_cnt = {bank1_err_wl_cnt,bank0_err_wl_cnt};

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_err_wl_cnt_r <= 7'h0 ;
    else if(bist_scan_fsm==BANK0 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (!bank0_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0))) 
        bank0_err_wl_cnt_r <= bank0_err_wl_cnt ;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank1_err_wl_cnt_r <= 7'h0 ;
    else if(bist_scan_fsm==BANK1 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (!bank1_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0))) 
        bank1_err_wl_cnt_r <= bank1_err_wl_cnt ;
end

//20250408 add by hy
wire    s_err_wl_cnt_change_cona;
wire    bank0_s_err_wl_cnt_change_conb;
wire    bank1_s_err_wl_cnt_change_conb;

assign  s_err_wl_cnt_change_cona = (wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num));
assign  bank0_s_err_wl_cnt_change_conb = (!bank0_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0);
assign  bank1_s_err_wl_cnt_change_conb = (!bank1_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0);

//end by hy

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_err_wl_cnt_change_flag <= 1'b0;
    else if(global_mc_bist_start)
        bank0_err_wl_cnt_change_flag <= 1'b0;
    else if((bank0_err_wl_cnt != bank0_err_wl_cnt_r) && (s_err_wl_cnt_change_cona || bank0_s_err_wl_cnt_change_conb)) //20250408 add by hy
        bank0_err_wl_cnt_change_flag <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank1_err_wl_cnt_change_flag <= 1'b0;
    else if(global_mc_bist_start)
        bank1_err_wl_cnt_change_flag <= 1'b0;
    else if((bank1_err_wl_cnt != bank1_err_wl_cnt_r) && (s_err_wl_cnt_change_cona || bank1_s_err_wl_cnt_change_conb)) //20250408 add by hy
        bank1_err_wl_cnt_change_flag <= 1'b1;
end




end
////MC_SHORT_MODE==1
else begin:inst3
wire   [6:0]                                     bank0_err_wl_cnt                   ; 
reg    [ARRAY_ROW_ADDR_WIDTH*64-1:0]             err_wl_store0                      ;
wire                                             err_wl_same0                       ;
reg                                              bank0_bist_wl_fail                 ;
wire                                             bank1_bist_wl_fail                 ;
wire                                             bank2_bist_wl_fail                 ;
wire                                             bank3_bist_wl_fail                 ;

wire                                             bank0_bist_wl_success              ; 

reg                                              bank0_bist_wl_finish               ;
reg                                              bank0_err_wl_cnt_change_flag       ; //1:diff 0: same
reg    [6:0]                                     bank0_err_wl_cnt_r                 ;

wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl0                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl1                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl2                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl3                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl4                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl5                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl6                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl7                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl8                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl9                      ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl10                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl11                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl12                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl13                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl14                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl15                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl16                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl17                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl18                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl19                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl20                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl21                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl22                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl23                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl24                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl25                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl26                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl27                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl28                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl29                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl30                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl31                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl32                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl33                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl34                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl35                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl36                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl37                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl38                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl39                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl40                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl41                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl42                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl43                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl44                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl45                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl46                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl47                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl48                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl49                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl50                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl51                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl52                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl53                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl54                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl55                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl56                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl57                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl58                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl59                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl60                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl61                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl62                     ;       
wire   [ARRAY_ROW_ADDR_WIDTH-1:0]                bank0_err_wl63                     ;

////--------------------bank0------------------------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        err_wl_store0  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(global_bist_clr) begin
        err_wl_store0  <=  {64*ARRAY_ROW_ADDR_WIDTH{1'b1}} ;
    end
    else if(bist_scan_fsm==BANK0 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same0 && (bank0_err_wl_cnt<7'd64)) begin 
        err_wl_store0  <=  {err_wl_store0[63*ARRAY_ROW_ADDR_WIDTH-1:0],receive_row_addr} ;
    end
end

assign err_wl_same0 = bist_scan_fsm==BANK0 ? 
((err_wl_store0[63*13+:13]==receive_row_addr)||(err_wl_store0[62*13+:13]==receive_row_addr)||(err_wl_store0[61*13+:13]==receive_row_addr)||
(err_wl_store0[60*13+:13]==receive_row_addr)||(err_wl_store0[59*13+:13]==receive_row_addr)||(err_wl_store0[58*13+:13]==receive_row_addr)||
(err_wl_store0[57*13+:13]==receive_row_addr)||(err_wl_store0[56*13+:13]==receive_row_addr)||(err_wl_store0[55*13+:13]==receive_row_addr)||
(err_wl_store0[54*13+:13]==receive_row_addr)||(err_wl_store0[53*13+:13]==receive_row_addr)||(err_wl_store0[52*13+:13]==receive_row_addr)||
(err_wl_store0[51*13+:13]==receive_row_addr)||(err_wl_store0[50*13+:13]==receive_row_addr)||(err_wl_store0[49*13+:13]==receive_row_addr)||
(err_wl_store0[48*13+:13]==receive_row_addr)||(err_wl_store0[47*13+:13]==receive_row_addr)||(err_wl_store0[46*13+:13]==receive_row_addr)||
(err_wl_store0[45*13+:13]==receive_row_addr)||(err_wl_store0[44*13+:13]==receive_row_addr)||(err_wl_store0[43*13+:13]==receive_row_addr)||
(err_wl_store0[42*13+:13]==receive_row_addr)||(err_wl_store0[41*13+:13]==receive_row_addr)||(err_wl_store0[40*13+:13]==receive_row_addr)||
(err_wl_store0[39*13+:13]==receive_row_addr)||(err_wl_store0[38*13+:13]==receive_row_addr)||(err_wl_store0[37*13+:13]==receive_row_addr)||
(err_wl_store0[36*13+:13]==receive_row_addr)||(err_wl_store0[35*13+:13]==receive_row_addr)||(err_wl_store0[34*13+:13]==receive_row_addr)||
(err_wl_store0[33*13+:13]==receive_row_addr)||(err_wl_store0[32*13+:13]==receive_row_addr)||(err_wl_store0[31*13+:13]==receive_row_addr)||
(err_wl_store0[30*13+:13]==receive_row_addr)||(err_wl_store0[29*13+:13]==receive_row_addr)||(err_wl_store0[28*13+:13]==receive_row_addr)||
(err_wl_store0[27*13+:13]==receive_row_addr)||(err_wl_store0[26*13+:13]==receive_row_addr)||(err_wl_store0[25*13+:13]==receive_row_addr)||
(err_wl_store0[24*13+:13]==receive_row_addr)||(err_wl_store0[23*13+:13]==receive_row_addr)||(err_wl_store0[22*13+:13]==receive_row_addr)||
(err_wl_store0[21*13+:13]==receive_row_addr)||(err_wl_store0[20*13+:13]==receive_row_addr)||(err_wl_store0[19*13+:13]==receive_row_addr)||
(err_wl_store0[18*13+:13]==receive_row_addr)||(err_wl_store0[17*13+:13]==receive_row_addr)||(err_wl_store0[16*13+:13]==receive_row_addr)||
(err_wl_store0[15*13+:13]==receive_row_addr)||(err_wl_store0[14*13+:13]==receive_row_addr)||(err_wl_store0[13*13+:13]==receive_row_addr)||
(err_wl_store0[12*13+:13]==receive_row_addr)||(err_wl_store0[11*13+:13]==receive_row_addr)||(err_wl_store0[10*13+:13]==receive_row_addr)||
(err_wl_store0[9*13+:13]==receive_row_addr)||(err_wl_store0[8*13+:13]==receive_row_addr)||(err_wl_store0[7*13+:13]==receive_row_addr)||
(err_wl_store0[6*13+:13]==receive_row_addr)||(err_wl_store0[5*13+:13]==receive_row_addr)||(err_wl_store0[4*13+:13]==receive_row_addr)||
(err_wl_store0[3*13+:13]==receive_row_addr)||(err_wl_store0[2*13+:13]==receive_row_addr)||(err_wl_store0[1*13+:13]==receive_row_addr)||
(err_wl_store0[0*13+:13]==receive_row_addr)) : 1'b0;

assign bank0_err_wl_cnt = 
(err_wl_store0[63*13+:13]!=13'h1FFF)+(err_wl_store0[62*13+:13]!=13'h1FFF)+(err_wl_store0[61*13+:13]!=13'h1FFF)+(err_wl_store0[60*13+:13]!=13'h1FFF)+
(err_wl_store0[59*13+:13]!=13'h1FFF)+(err_wl_store0[58*13+:13]!=13'h1FFF)+(err_wl_store0[57*13+:13]!=13'h1FFF)+(err_wl_store0[56*13+:13]!=13'h1FFF)+
(err_wl_store0[55*13+:13]!=13'h1FFF)+(err_wl_store0[54*13+:13]!=13'h1FFF)+(err_wl_store0[53*13+:13]!=13'h1FFF)+(err_wl_store0[52*13+:13]!=13'h1FFF)+
(err_wl_store0[51*13+:13]!=13'h1FFF)+(err_wl_store0[50*13+:13]!=13'h1FFF)+(err_wl_store0[49*13+:13]!=13'h1FFF)+(err_wl_store0[48*13+:13]!=13'h1FFF)+
(err_wl_store0[47*13+:13]!=13'h1FFF)+(err_wl_store0[46*13+:13]!=13'h1FFF)+(err_wl_store0[45*13+:13]!=13'h1FFF)+(err_wl_store0[44*13+:13]!=13'h1FFF)+
(err_wl_store0[43*13+:13]!=13'h1FFF)+(err_wl_store0[42*13+:13]!=13'h1FFF)+(err_wl_store0[41*13+:13]!=13'h1FFF)+(err_wl_store0[40*13+:13]!=13'h1FFF)+
(err_wl_store0[39*13+:13]!=13'h1FFF)+(err_wl_store0[38*13+:13]!=13'h1FFF)+(err_wl_store0[37*13+:13]!=13'h1FFF)+(err_wl_store0[36*13+:13]!=13'h1FFF)+
(err_wl_store0[35*13+:13]!=13'h1FFF)+(err_wl_store0[34*13+:13]!=13'h1FFF)+(err_wl_store0[33*13+:13]!=13'h1FFF)+(err_wl_store0[32*13+:13]!=13'h1FFF)+
(err_wl_store0[31*13+:13]!=13'h1FFF)+(err_wl_store0[30*13+:13]!=13'h1FFF)+(err_wl_store0[29*13+:13]!=13'h1FFF)+(err_wl_store0[28*13+:13]!=13'h1FFF)+
(err_wl_store0[27*13+:13]!=13'h1FFF)+(err_wl_store0[26*13+:13]!=13'h1FFF)+(err_wl_store0[25*13+:13]!=13'h1FFF)+(err_wl_store0[24*13+:13]!=13'h1FFF)+
(err_wl_store0[23*13+:13]!=13'h1FFF)+(err_wl_store0[22*13+:13]!=13'h1FFF)+(err_wl_store0[21*13+:13]!=13'h1FFF)+(err_wl_store0[20*13+:13]!=13'h1FFF)+
(err_wl_store0[19*13+:13]!=13'h1FFF)+(err_wl_store0[18*13+:13]!=13'h1FFF)+(err_wl_store0[17*13+:13]!=13'h1FFF)+(err_wl_store0[16*13+:13]!=13'h1FFF)+
(err_wl_store0[15*13+:13]!=13'h1FFF)+(err_wl_store0[14*13+:13]!=13'h1FFF)+(err_wl_store0[13*13+:13]!=13'h1FFF)+(err_wl_store0[12*13+:13]!=13'h1FFF)+
(err_wl_store0[11*13+:13]!=13'h1FFF)+(err_wl_store0[10*13+:13]!=13'h1FFF)+(err_wl_store0[9*13+:13]!=13'h1FFF)+(err_wl_store0[8*13+:13]!=13'h1FFF)+
(err_wl_store0[7*13+:13]!=13'h1FFF)+(err_wl_store0[6*13+:13]!=13'h1FFF)+(err_wl_store0[5*13+:13]!=13'h1FFF)+(err_wl_store0[4*13+:13]!=13'h1FFF)+
(err_wl_store0[3*13+:13]!=13'h1FFF)+(err_wl_store0[2*13+:13]!=13'h1FFF)+(err_wl_store0[1*13+:13]!=13'h1FFF)+(err_wl_store0[0*13+:13]!=13'h1FFF) ;

assign {bank0_err_wl63,bank0_err_wl62,bank0_err_wl61,bank0_err_wl60,bank0_err_wl59,bank0_err_wl58,bank0_err_wl57,bank0_err_wl56,bank0_err_wl55,bank0_err_wl54,
        bank0_err_wl53,bank0_err_wl52,bank0_err_wl51,bank0_err_wl50,bank0_err_wl49,bank0_err_wl48,bank0_err_wl47,bank0_err_wl46,bank0_err_wl45,bank0_err_wl44,
        bank0_err_wl43,bank0_err_wl42,bank0_err_wl41,bank0_err_wl40,bank0_err_wl39,bank0_err_wl38,bank0_err_wl37,bank0_err_wl36,bank0_err_wl35,bank0_err_wl34,
        bank0_err_wl33,bank0_err_wl32,bank0_err_wl31,bank0_err_wl30,bank0_err_wl29,bank0_err_wl28,bank0_err_wl27,bank0_err_wl26,bank0_err_wl25,bank0_err_wl24,
        bank0_err_wl23,bank0_err_wl22,bank0_err_wl21,bank0_err_wl20,bank0_err_wl19,bank0_err_wl18,bank0_err_wl17,bank0_err_wl16,bank0_err_wl15,bank0_err_wl14,
        bank0_err_wl13,bank0_err_wl12,bank0_err_wl11,bank0_err_wl10,bank0_err_wl9,bank0_err_wl8,bank0_err_wl7,bank0_err_wl6,bank0_err_wl5,bank0_err_wl4,
        bank0_err_wl3,bank0_err_wl2,bank0_err_wl1,bank0_err_wl0 } = err_wl_store0 ; 


assign bank_bist_wl_finish = bank0_bist_wl_finish;
assign bank_bist_wl_success = bank0_bist_wl_success;
assign bank_err_wl_cnt_change_flag = {bank0_err_wl_cnt_change_flag};


always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank0_bist_wl_finish   <=  1'b0   ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank0_bist_wl_finish   <=  1'b0   ;
    end
    else if(bist_scan_fsm==BANK0 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (wl_scan_row_status && data_noback_req_cnt==5'h0))) begin
        bank0_bist_wl_finish   <=  1'b1   ;
    end
end


assign bank1_bist_wl_fail = 1'b0;
assign bank2_bist_wl_fail = 1'b0;
assign bank3_bist_wl_fail = 1'b0;


always @(*)begin
    if(bist_scan_fsm==BANK0)
        wl_scan_row_status = bank0_bist_wl_fail ;
    else if(bist_scan_fsm==BANK1)
        wl_scan_row_status = bank1_bist_wl_fail ;
    else if(bist_scan_fsm==BANK2)
        wl_scan_row_status = bank2_bist_wl_fail ;
    else if(bist_scan_fsm==BANK3)
        wl_scan_row_status = bank3_bist_wl_fail ;
    else
        wl_scan_row_status = 1'b0 ;
end

assign bank0_bist_wl_success = bist_scan_fsm==BANK0 && bank0_bist_wl_finish && !bank0_bist_wl_fail ;


always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank0_bist_wl_fail  <=  1'b0 ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bank0_bist_wl_fail  <=  1'b0 ;
    end
    else if(bist_scan_fsm==BANK0 && FSM_CS == RD_ADDR && wl_scan_rvalid && wl_scan_rdata!=frame_golden_data && !err_wl_same0 && (bank0_err_wl_cnt==7'd64)) begin 
        bank0_bist_wl_fail  <=  1'b1 ;
    end
end



assign  err_wl0       =   bank0_err_wl0 ;
assign  err_wl1       =   bank0_err_wl1 ;                  
assign  err_wl2       =   bank0_err_wl2 ;                  
assign  err_wl3       =   bank0_err_wl3 ;                  
assign  err_wl4       =   bank0_err_wl4 ;                  
assign  err_wl5       =   bank0_err_wl5 ;                  
assign  err_wl6       =   bank0_err_wl6 ;                  
assign  err_wl7       =   bank0_err_wl7 ;                  
assign  err_wl8       =   bank0_err_wl8 ;                  
assign  err_wl9       =   bank0_err_wl9 ;                  
assign  err_wl10      =   bank0_err_wl10;                   
assign  err_wl11      =   bank0_err_wl11;                   
assign  err_wl12      =   bank0_err_wl12;                   
assign  err_wl13      =   bank0_err_wl13;                   
assign  err_wl14      =   bank0_err_wl14;                   
assign  err_wl15      =   bank0_err_wl15;                   
assign  err_wl16      =   bank0_err_wl16;                   
assign  err_wl17      =   bank0_err_wl17;                   
assign  err_wl18      =   bank0_err_wl18;                   
assign  err_wl19      =   bank0_err_wl19;                   
assign  err_wl20      =   bank0_err_wl20;                   
assign  err_wl21      =   bank0_err_wl21;                   
assign  err_wl22      =   bank0_err_wl22;                   
assign  err_wl23      =   bank0_err_wl23;                   
assign  err_wl24      =   bank0_err_wl24;                   
assign  err_wl25      =   bank0_err_wl25;                   
assign  err_wl26      =   bank0_err_wl26;                   
assign  err_wl27      =   bank0_err_wl27;                   
assign  err_wl28      =   bank0_err_wl28;                   
assign  err_wl29      =   bank0_err_wl29;                   
assign  err_wl30      =   bank0_err_wl30;                   
assign  err_wl31      =   bank0_err_wl31;                   
assign  err_wl32      =   bank0_err_wl32;                   
assign  err_wl33      =   bank0_err_wl33;                   
assign  err_wl34      =   bank0_err_wl34;                   
assign  err_wl35      =   bank0_err_wl35;                   
assign  err_wl36      =   bank0_err_wl36;                   
assign  err_wl37      =   bank0_err_wl37;                   
assign  err_wl38      =   bank0_err_wl38;                   
assign  err_wl39      =   bank0_err_wl39;                   
assign  err_wl40      =   bank0_err_wl40;                   
assign  err_wl41      =   bank0_err_wl41;                   
assign  err_wl42      =   bank0_err_wl42;                   
assign  err_wl43      =   bank0_err_wl43;                   
assign  err_wl44      =   bank0_err_wl44;                   
assign  err_wl45      =   bank0_err_wl45;                   
assign  err_wl46      =   bank0_err_wl46;                   
assign  err_wl47      =   bank0_err_wl47;                   
assign  err_wl48      =   bank0_err_wl48;                   
assign  err_wl49      =   bank0_err_wl49;                   
assign  err_wl50      =   bank0_err_wl50;                   
assign  err_wl51      =   bank0_err_wl51;                   
assign  err_wl52      =   bank0_err_wl52;                   
assign  err_wl53      =   bank0_err_wl53;                   
assign  err_wl54      =   bank0_err_wl54;                   
assign  err_wl55      =   bank0_err_wl55;                   
assign  err_wl56      =   bank0_err_wl56;                   
assign  err_wl57      =   bank0_err_wl57;                   
assign  err_wl58      =   bank0_err_wl58;                   
assign  err_wl59      =   bank0_err_wl59;                   
assign  err_wl60      =   bank0_err_wl60;                   
assign  err_wl61      =   bank0_err_wl61;                   
assign  err_wl62      =   bank0_err_wl62;                   
assign  err_wl63      =   bank0_err_wl63; 

assign wl_single_pattern_done = ((!bank0_bist_wl_fail && receive_row_addr == wl_scan_row_end_addr) && (receive_col_addr == 7'h7F) && !wl_scan_rd_cnt_allow && wl_scan_rvalid && data_noback_req_cnt==5'h1 )|| wl_scan_row_status_pos;
assign bank_err_wl_cnt = bank0_err_wl_cnt;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_err_wl_cnt_r <= 7'h0 ;
    else if(bist_scan_fsm==BANK0 && ((wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num)) || (!bank0_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0))) 
        bank0_err_wl_cnt_r <= bank0_err_wl_cnt ;
end

//20250408 add by hy
wire    s_err_wl_cnt_change_cona;
wire    bank0_s_err_wl_cnt_change_conb;

assign  s_err_wl_cnt_change_cona = (wl_single_pattern_done && (wl_scan_num_cnt_status==bist_wl_scan_num));
assign  bank0_s_err_wl_cnt_change_conb = (!bank0_bist_wl_finish && wl_scan_row_status && data_noback_req_cnt==5'h0);

//end by hy

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        bank0_err_wl_cnt_change_flag <= 1'b0;
    else if(global_mc_bist_start)
        bank0_err_wl_cnt_change_flag <= 1'b0;
    else if((bank0_err_wl_cnt != bank0_err_wl_cnt_r) && (s_err_wl_cnt_change_cona || bank0_s_err_wl_cnt_change_conb)) //20250408 add by hy
        bank0_err_wl_cnt_change_flag <= 1'b1;
end
end
endgenerate


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
       wl_scan_row_status_r <= 1'b0;
    else 
       wl_scan_row_status_r  <= wl_scan_row_status;
end
assign  wl_scan_row_status_pos = wl_scan_row_status && !wl_scan_row_status_r ;

//assign bist_wl_success = bist_wl_finish && !bist_wl_fail ;

assign wl_scan_working = (FSM_CS==WR_ADDR || FSM_CS==RD_ADDR) ;



        
        
endmodule
