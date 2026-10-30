`define FRAME_DATA_WIDTH    280
`define BRESP_WIDTH         2
`define MC_RDATA_WIDTH      256
`define MC_RRESP_WIDTH      2
`define ROW_ADDR_WIDTH      13
`define COLUMN_ADDR_WIDTH   8
`define ARRAY_DATA_WIDTH    272
`define PATTERN_WIDTH       32
`define CSL_ERR_TH_WIDTH    5
`define APB_ADDR_WIDTH      11
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

