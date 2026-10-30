module dram_init_wr_top #(
    parameter   ROW_ADDR_WIDTH  = 13                                 ,
    parameter   COL_ADDR_WIDTH  = 8                                  ,
    parameter   WL_NUM          = 7360                               ,
    parameter   FRAME_WIDTH     = 292
)(
  //-------------clock and reset signal--------------
  input                                               clk                    ,
  input                                               rst_n                  ,
  //-------------control signal----------------------                        
  input                                               mc_dram_init_en        ,	
  input                                               global_dram_init_en    ,
  output                                              mc_dram_init_finish    ,
                    
  //-------------data signal------------------------                         
  output                                              dram_init_frame_vld    ,
  input                                               dram_init_frame_rdy    ,
  output     [FRAME_WIDTH-1:0]                        dram_init_frame_data   //rw_flag,sof,eof,data,row,col
);

//======================================================================
localparam      INIT_IDLE = 2'd0,
                INIT_BANK0 = 2'd1,
                INIT_BANK1 = 2'd2;

//======================================================================
wire                        mc_dram0_init_en        ;	
wire                        global_dram0_init_en    ;
wire                        mc_dram0_init_finish    ;
wire                        dram0_init_frame_vld    ;
wire                        dram0_init_frame_rdy    ;
wire    [FRAME_WIDTH-1-2:0] dram0_init_frame_data   ;//rw_flag,sof,eof,data,row,col

wire                        mc_dram1_init_en        ;	
wire                        global_dram1_init_en    ;
wire                        mc_dram1_init_finish    ;
wire                        dram1_init_frame_vld    ;
wire                        dram1_init_frame_rdy    ;
wire    [FRAME_WIDTH-1-2:0] dram1_init_frame_data   ;//rw_flag,sof,eof,data,row,col

wire    [FRAME_WIDTH-1-2:0] dram_init_frame_data_s  ;//rw_flag,sof,eof,data,row,col

dram_init_wr_aux #(
    .ROW_ADDR_WIDTH  (13                                    ),
    .COL_ADDR_WIDTH  (8                                     ),
    .WL_NUM          (7360                                  ),
    .FRAME_WIDTH     (ROW_ADDR_WIDTH+COL_ADDR_WIDTH+266+3   )
)dram_init_wr_aux_u0(
    .clk                    (clk    ),
    .rst_n                  (rst_n  ),
    .mc_dram_init_en        (mc_dram_init_en           ),	
    .global_dram_init_en    (global_dram_init_en       ),
    .mc_dram_init_finish    (mc_dram_init_finish       ),
    .dram_init_frame_vld    (dram_init_frame_vld       ),
    .dram_init_frame_rdy    (dram_init_frame_rdy       ),
    .dram_init_frame_data   (dram_init_frame_data_s    )//rw_flag,sof,eof,data,row,col
);

assign  dram_init_frame_data = {dram_init_frame_data_s[FRAME_WIDTH-3:FRAME_WIDTH-5],2'b11,dram_init_frame_data_s[286:0]};

endmodule
