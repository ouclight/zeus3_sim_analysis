module mc_loopback_aux #(
    parameter  ARRAY_DATA_WIDTH      = 256,
    parameter  ARRAY_ROW_ADDR_WIDTH  = 13,
    parameter  ARRAY_COL_ADDR_WIDTH  = 8,
    parameter  CHECKBIT_WIDTH        = 16,
    parameter  MC_SHORT_MODE         = 4,
    parameter  MC_FRAME_WIDTH        = ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+3+1
)(
    //========================connect with MC ==============================
    input                                                    clk                ,
    input                                                    rst_n              ,
    input       [MC_SHORT_MODE-1:0]                          bnksel_n_mc        ,
    input       [ARRAY_ROW_ADDR_WIDTH-1:0]                   gradd_n_mc         ,
    input       [MC_SHORT_MODE-1:0]                          gcas_rd_mc         ,
    input       [MC_SHORT_MODE-1:0]                          gcas_wr_mc         ,
    input       [ARRAY_COL_ADDR_WIDTH-1:0]                   gcadd_mc           ,
    input       [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]        wdl_mc             ,
    input                                                    wdl_oe_mc          ,
    output                                                   rdrdy_n_mc         ,
    output      [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]        rdl_mc             ,
 
    input                                                    mc_loopback_en     ,   // 1 enable loopback ; 0 disable loopback
    output                                                   afifo_push         ,
    output                                                   afifo_pop          ,
    input                                                    afifo_empty        ,

    //========================output signal=================================
    output      [MC_SHORT_MODE-1:0]                          bnksel_n           ,
    output      [ARRAY_ROW_ADDR_WIDTH-1:0]                   gradd_n            ,
    output      [MC_SHORT_MODE-1:0]                          gcas_rd            ,
    output      [MC_SHORT_MODE-1:0]                          gcas_wr            ,
    output      [ARRAY_COL_ADDR_WIDTH-1:0]                   gcadd              ,
    output      [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]        wdl                ,
    output                                                   wdl_oe             ,
    input                                                    rdrdy_n            ,
    input       [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]        rdl                
);

//========================iinternal signal==============================
reg         afifo_pop_s;
//======================================================================
// array signal process
//======================================================================
assign  bnksel_n = mc_loopback_en ? {MC_SHORT_MODE{1'b1}} : bnksel_n_mc;
assign  gradd_n  = mc_loopback_en ? {ARRAY_ROW_ADDR_WIDTH{1'b1}} : gradd_n_mc;
assign  gcas_rd  = mc_loopback_en ? {MC_SHORT_MODE{1'b0}} : gcas_rd_mc;
assign  gcas_wr  = mc_loopback_en ? {MC_SHORT_MODE{1'b0}} : gcas_wr_mc;
assign  gcadd    = mc_loopback_en ? {ARRAY_COL_ADDR_WIDTH{1'b1}} : gcadd_mc;
assign  wdl      = mc_loopback_en ?  'd0 : wdl_mc;
assign  wdl_oe   = mc_loopback_en ? 1'b0 : wdl_oe_mc;

//======================================================================
//afifo signal process
//======================================================================
assign  afifo_push = mc_loopback_en ? !(|gcas_wr_mc) : 1'b0;
assign  afifo_pop  = mc_loopback_en ? !afifo_pop_s : afifo_empty;
assign  rdl_mc     = mc_loopback_en ? wdl_mc : rdl;

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        afifo_pop_s <= 1'b0;
    else
        afifo_pop_s <= (|gcas_rd_mc);
end


`ifdef RTLSIM
    assign  rdrdy_n_mc = mc_loopback_en ? clk : rdrdy_n;
`else
    wl_clk_mux afifo_push_clk_u(.clk_i0 (rdrdy_n), .clk_i1  (clk), .clk_sel (mc_loopback_en ), .clk_o(rdrdy_n_mc));
`endif

endmodule
