`define FRAME_DATA_WIDTH    298
`define BRESP_WIDTH         1
`define MC_RDATA_WIDTH      272
`define MC_RRESP_WIDTH      2
`define BANK_ADDR_WIDTH     2
`define ROW_ADDR_WIDTH      13
`define COLUMN_ADDR_WIDTH   8
`define ARRAY_DATA_WIDTH    272
`define PATTERN_WIDTH       32
`define CSL_ERR_TH_WIDTH    5
`define APB_ADDR_WIDTH      12
`define APB_DATA_WIDTH      32
`define ARRAY_PHY_DATA_WIDTH    266
`define COL_ADDR_WIDTH      7


`define tb_clk_gen(clk_name, clk_period, init_val) \
logic clk_name = init_val; \
always #(clk_period/2) clk_name = ~clk_name;

`define tb_rst_gen(RST_NAME, INITIAL_VALUE, PERIOD1) \
initial begin \
	RST_NAME = INITIAL_VALUE; \
	#PERIOD1 RST_NAME = ~INITIAL_VALUE; \
end

`define MC_SUBSYS   mc_tb.m_mc_subsys_top
`define MC_WRAPPER  `MC_SUBSYS.mc_wrapper_aux_u
`define MC_TOP      `MC_WRAPPER.mc_top_u
`define MC_TOP_APB  `MC_TOP.inst2.apb2reg_mc_top_cfg_if_u2
`ifdef SIM_COV
    `define ARRAY_MODEL_TOP mc_tb.u_quad_group01.u_quad_group
`endif

`define N               4
