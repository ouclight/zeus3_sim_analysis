module dram_init_wr_aux #(
    parameter   ROW_ADDR_WIDTH  = 13                                 ,
    parameter   COL_ADDR_WIDTH  = 8                                  ,
    parameter   WL_NUM          = 7360                              ,
    parameter   FRAME_WIDTH     = ROW_ADDR_WIDTH+COL_ADDR_WIDTH+266+3
)(
  //-------------clock and reset signal--------------
  input                                               clk                    ,
  input                                               rst_n                  ,
//  input                                               ras_rst_n              ,



  //-------------control signal----------------------                        
  input                                               mc_dram_init_en        ,	
  input                                               global_dram_init_en    ,
  output reg                                          mc_dram_init_finish    ,
                    
  //-------------data signal------------------------                         
  output reg                                          dram_init_frame_vld    ,
  input                                               dram_init_frame_rdy    ,
  output     [FRAME_WIDTH-1:0]                        dram_init_frame_data   //rw_flag,sof,eof,data,row,col
);


//wire and reg
//reg                                                   mc_dram_init_en_r      ;
wire   [ROW_ADDR_WIDTH-1:0]                           row_end_addr           ;
wire   [COL_ADDR_WIDTH-1:0]                           col_end_addr           ;
reg    [ROW_ADDR_WIDTH-1:0]                           send_row_addr          ;
reg    [COL_ADDR_WIDTH-1:0]                           send_col_addr          ;
wire                                                  frame_data_rw_flag     ;
wire                                                  frame_data_sof         ;
wire                                                  frame_data_eof         ;
wire   [265:0]                                        frame_data             ;
//wire                                                  mc_dram_init_pos       ;
//--------------------------------------------------

assign  row_end_addr = 13'h1CBF-13'h40;//7359-64
assign  col_end_addr = 8'h81-8'h2;//129
////////////assign  row_end_addr = 13'd127-13'h40;//14719
////////////assign  col_end_addr = 8'd129-8'h2;


//always @(posedge clk or negedge rst_n)begin
//    if(!rst_n)
//        mc_dram_init_en_r <= 1'b0;
//    else 
//        mc_dram_init_en_r <= mc_dram_init_en;
//end

//assign mc_dram_init_pos =  mc_dram_init_en &&  !mc_dram_init_en_r ;
//----------------------------------------------------------------------------
assign dram_init_frame_data = {frame_data_rw_flag,frame_data_sof,frame_data_eof,frame_data,send_row_addr,send_col_addr} ;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        dram_init_frame_vld   <=  1'b0   ;
    else if(mc_dram_init_finish || !mc_dram_init_en || (send_row_addr==row_end_addr && send_col_addr == col_end_addr && dram_init_frame_vld && dram_init_frame_rdy))
        dram_init_frame_vld   <=  1'b0   ;
    else if(mc_dram_init_en && global_dram_init_en)
        dram_init_frame_vld   <=  1'b1   ;
 end

assign frame_data_rw_flag = dram_init_frame_vld ? 1'b1 : 1'b0;
assign frame_data_sof = send_col_addr == 8'h0 && dram_init_frame_vld ? 1'b1 : 1'b0;
assign frame_data_eof = send_col_addr == col_end_addr && dram_init_frame_vld ? 1'b1 : 1'b0;
assign frame_data     = 266'h0 ;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) 
        send_col_addr <= 8'h0 ;
    else if(!mc_dram_init_en)
        send_col_addr <= 8'h0 ;
    else if(send_col_addr == col_end_addr && dram_init_frame_vld && dram_init_frame_rdy)
        send_col_addr <= 8'h0 ;
    else if(dram_init_frame_vld && dram_init_frame_rdy)
        send_col_addr <= send_col_addr + 1'b1 ;
    end


    always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        send_row_addr  <=  13'h0 ;
    else if(!mc_dram_init_en)
        send_row_addr <= 8'h0 ;
    else if(send_row_addr==row_end_addr && send_col_addr == col_end_addr && dram_init_frame_vld && dram_init_frame_rdy)
            send_row_addr   <=  13'h0   ;
    else if(send_col_addr == col_end_addr && dram_init_frame_vld && dram_init_frame_rdy)
            send_row_addr   <= send_row_addr + 1'b1 ;
end

//----------------------------------------------------------------------------
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) 
        mc_dram_init_finish <= 1'b0 ;
    else if(!mc_dram_init_en)
        mc_dram_init_finish <= 1'b0;
    else if(send_row_addr==row_end_addr && send_col_addr == col_end_addr && dram_init_frame_vld && dram_init_frame_rdy) 
        mc_dram_init_finish <= 1'b1 ;
end

endmodule
