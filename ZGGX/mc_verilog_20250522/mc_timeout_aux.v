module mc_timeout_aux #(
    parameter   ARRAY_ROW_ADDR_WIDTH  = 13,
    parameter   ARRAY_COL_ADDR_WIDTH  = 8,
    parameter   CHECKBIT_WIDTH        = 10,
    parameter   ARRAY_DATA_WIDTH      = 256,
    parameter   FRAME_WIDTH           = ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+3
)(
    input                                                          clk                 ,
    input                                                          rst_n               ,
//    input                                                          ras_clr             ,
    input                                                          timeout_en          ,//initail scan use
    input                                                          timeout_clr         ,
    input        [31:0]                                            timeout_th          ,
    output                                                         timeout_status      ,//1:read req timeout flag

    output                                                         hang_timeout_intr   ,//normal func use
    input                                                          hang_timeout_clr    ,
    input                                                          hang_timeout_mask   ,
    output                                                         hang_timeout_status ,
    input                                                          hang_timeout_en     ,//normal func use
    input        [31:0]                                            hang_timeout_th     ,

    input                                                          timeout_sel_en      ,//1:initial scan 0:normal  
              
    ////connect with mc hub
    input                                                          hub_frame_vld       ,
    output                                                         hub_frame_rdy       ,
    input        [FRAME_WIDTH-1:0]                                 hub_frame_data      ,
    
    output                                                         mc_rvalid           ,
    output       [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]             mc_rdata            ,
    ////connect with frame2array
    output                                                         mc_frame_vld        ,
    input                                                          mc_frame_rdy        ,
    output       [FRAME_WIDTH-1:0]                                 mc_frame_data       ,

    input                                                          array_rvalid        ,
    input        [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]             array_rdata         
   
);

//reg                      [2:0]                        req_cnt            ;
reg                      [31:0]                       handshake_cnt      ;
//wire                     [31:0]                       handshake_cnt_tmp  ;
reg                                                   timeout_cnt_vld    ;
reg                      [31:0]                       timeout_cnt        ;         
reg                                                   timeout_flag       ;
reg                                                   timeout_flag_r0    ;
reg                                                   timeout_flag_r1    ;
wire                                                  mc_timeout_rvalid  ;

wire                                                  hang_en            ;
wire                                                  scan_en            ;

reg                                                   timeout_en_r       ;
wire                                                  timeout_en_pos     ;
wire                                                  hub_frame_wr       ;


assign hub_frame_wr = hub_frame_data[FRAME_WIDTH-2]   ;

assign hub_frame_rdy = mc_frame_rdy;

assign mc_frame_vld = hub_frame_vld;
assign mc_frame_data = hub_frame_data;


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        timeout_en_r <= 1'b0;
    else
        timeout_en_r <= timeout_en;
end
assign timeout_en_pos = timeout_en ^ timeout_en_r ;
////------------------------
////generate frame timeout flag
////------------------------
assign hang_en = hang_timeout_en && !timeout_sel_en;
assign scan_en = timeout_en && timeout_sel_en;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        timeout_cnt <= 32'd0;
    else if(timeout_clr || hang_timeout_clr || array_rvalid || (!hang_timeout_en && !timeout_sel_en) || timeout_en_pos)
        timeout_cnt <= 32'd0;
    else if(handshake_cnt != 32'd0 && (hang_en || scan_en))begin
        if((hang_en && timeout_cnt < hang_timeout_th) || (scan_en && timeout_cnt < timeout_th))
            timeout_cnt <= timeout_cnt +1'b1;
        else
            timeout_cnt <= timeout_cnt;
    end
    else
        timeout_cnt <= timeout_cnt;
    end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        timeout_flag <= 1'b0;
    else if(timeout_clr || hang_timeout_clr)
        timeout_flag <= 1'b0;
    else if(timeout_cnt==timeout_th && scan_en)
        timeout_flag <= 1'b1;
    else if(timeout_cnt==hang_timeout_th && hang_en)
        timeout_flag <= 1'b1;
    else
        timeout_flag <= timeout_flag;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        handshake_cnt <= 32'd0;
    else if(hang_timeout_clr || timeout_clr)
        handshake_cnt <= 32'd0;
    else if(timeout_flag && timeout_en && handshake_cnt >32'd7)
        handshake_cnt <= 32'd7;
    else if(array_rvalid && hub_frame_vld && hub_frame_rdy && !hub_frame_wr)
        handshake_cnt <= handshake_cnt;
    else if(array_rvalid || (mc_timeout_rvalid && handshake_cnt>32'd0))
        handshake_cnt <= handshake_cnt - 1'b1;
    else if(hub_frame_vld && hub_frame_rdy && !hub_frame_wr)
        handshake_cnt <= handshake_cnt + 1'b1;
end



assign timeout_status      = timeout_flag ;
assign hang_timeout_status = timeout_flag ;
assign hang_timeout_intr   = timeout_flag && !hang_timeout_mask && hang_en;

assign mc_timeout_rvalid = timeout_flag && handshake_cnt<=32'd7 && timeout_en  && handshake_cnt>0 ? 1'b1 : 1'b0  ;
assign mc_rdata          = timeout_flag && timeout_en && timeout_sel_en ? {266'h123456789abcdef} : array_rdata;
assign mc_rvalid         = timeout_flag && timeout_en && timeout_sel_en ? mc_timeout_rvalid : array_rvalid ;



endmodule
