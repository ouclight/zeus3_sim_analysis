//----------------------------------------------------------------------------
//  FILE      : mc_frame_debug.v
//  LANGUAGE  : verilog-2001
//  AUTHOR    : dangz
//  DATE      : 2021-06-23
//  FUNCTION  :
//  HISTORY   :
//  
//  TEST FILE          :
//  Test stimulus file :
//  Test output file   :
//  
//  Copyright ?2021 UniIC Corp, All rights reserved
//----------------------------------------------------------------------------



module mc_frame_debug_aux #(
    parameter   HUB_FRAME_WIDTH  = 256+10+13+8-1+3,
    parameter   ARRAY_DATA_WIDTH = 256+10 
    )(
    input                               clk           ,
    input                               rst_n         ,
    input                               mc_debug_en   ,
    //receive hub frame
    input                               hub_frame_vld ,
    output                              hub_frame_rdy ,
    input      [HUB_FRAME_WIDTH-1:0]    hub_frame_data,
    //debug output frame connect to mc
    output                              mc_frame_vld  ,
    input                               mc_frame_rdy  ,
    output     [HUB_FRAME_WIDTH-1:0]    mc_frame_data ,
    input                               mc_back_rvalid,
    input      [ARRAY_DATA_WIDTH-1:0]   mc_back_rdata ,
    input      [1:0]                    mc_back_rresp ,
    //output to hub rdata
    output                              mc_rvalid     ,
    output     [ARRAY_DATA_WIDTH-1:0]   mc_rdata      ,
    output     [1:0]                    mc_rresp      
    );


wire                               mc_dbg_en      ;
reg  [7:0]                         buf_mem[0:7]   ;
wire                               hub_frame_sof  ;
//wire                               hub_frame_eof  ;
wire                               hub_frame_wr   ;
wire [7:0]                         hub_frame_wdata;
reg  [2:0]                         buf_index_wr   ;
reg  [2:0]                         buf_index_rd   ;
wire                               debug_frame_rdy;
wire                               debug_rvalid   ;
wire [ARRAY_DATA_WIDTH-1:0]        debug_rdata    ;

reg                                data_vld       ;
integer II;



//assign hub_frame_sof   = hub_frame_data[HUB_FRAME_WIDTH-3];
assign hub_frame_sof   = hub_frame_data[HUB_FRAME_WIDTH-2]; // wy up
//assign hub_frame_eof   = hub_frame_data[HUB_FRAME_WIDTH-3];
assign hub_frame_wdata = hub_frame_data[27:20];//only save data [7:0]bit
//assign hub_frame_wr    = hub_frame_data[HUB_FRAME_WIDTH-2];
assign hub_frame_wr    = hub_frame_data[HUB_FRAME_WIDTH-1]; // wy up

DW_sync 
        #(
         .width         (1          ),
         .f_sync_type   (2          ),
         .tst_mode      (0          ),
         .verif_en      (1          )
         )U_debug_en_DW_sync 
        ( 
        .clk_d          (clk        ),
        .rst_d_n        (rst_n      ),
        .init_d_n       (1'b1       ),
        .data_s         (mc_debug_en),
        .test           (1'b0       ),
        .data_d         (mc_dbg_en  )
        );


assign mc_frame_vld  = ~mc_dbg_en & hub_frame_vld;

assign hub_frame_rdy = mc_dbg_en ? debug_frame_rdy : mc_frame_rdy;

assign mc_frame_data = hub_frame_data;

assign mc_rvalid     = mc_dbg_en ? debug_rvalid : mc_back_rvalid;

assign mc_rdata      = mc_dbg_en ? debug_rdata  : mc_back_rdata ;
assign mc_rresp      = mc_dbg_en ? 2'b00 : mc_back_rresp; //wy add

localparam  IDLE     = 2'b00,
            RX_WDATA = 2'b01,
            TX_RDATA = 2'b11;

reg [1:0] fsm_cs;
reg [1:0] fsm_ns;


always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        fsm_cs <= IDLE;
    else
        fsm_cs <= fsm_ns;
end   

always @ (*)
begin
    case(fsm_cs)
        IDLE:
            begin
                if(mc_dbg_en)begin
                    if(hub_frame_vld && hub_frame_sof)
                        fsm_ns = hub_frame_wr ? RX_WDATA : TX_RDATA;
                    else
                        fsm_ns = IDLE;
                end
                else
                    fsm_ns = IDLE;
            end
        RX_WDATA:
            begin
                if(buf_index_wr==3'd7)
                    fsm_ns = IDLE;
                else
                    fsm_ns = RX_WDATA;
            end
        TX_RDATA:
            begin
                if(buf_index_rd==3'd7)
                    fsm_ns = IDLE;
                else
                    fsm_ns = TX_RDATA;
            end
        default: fsm_ns = IDLE;
    endcase
end 

assign debug_frame_rdy = fsm_cs==IDLE || fsm_cs==RX_WDATA || (fsm_cs==TX_RDATA && !data_vld);


always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        buf_index_wr <= 3'd0;
    else if(hub_frame_wr && hub_frame_vld)
        buf_index_wr <= buf_index_wr + 1'b1;
end 

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        for(II=0;II<8;II=II+1)
            buf_mem[II] <= 8'h5a;
    else if(hub_frame_wr && hub_frame_vld)
        buf_mem[buf_index_wr] <= hub_frame_wdata;
end 

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        buf_index_rd <= 3'd0;
//    else if(~hub_frame_wr && hub_frame_vld)
    else if(data_vld)
        buf_index_rd <= buf_index_rd + 1'b1;
end 

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        data_vld <= 1'b0;
    else if(~hub_frame_wr && hub_frame_vld && !data_vld)
        data_vld <= 1'b1;
    else
        data_vld <= 1'b0;
end
//assign debug_rvalid = (~hub_frame_wr && hub_frame_vld); 
assign debug_rvalid = data_vld; 


//assign debug_rdata  = {258'd0,buf_mem[buf_index_rd]};
assign debug_rdata  = {{32{buf_mem[buf_index_rd]}}}; //wy up





endmodule
