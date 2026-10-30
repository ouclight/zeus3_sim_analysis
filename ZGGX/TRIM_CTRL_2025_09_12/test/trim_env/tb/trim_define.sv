/******************************************************************************
 * File Name : trim_define.sv
 * Created on 2025-07-15 10:18:33
 *******************************************************************************/

`ifndef TRIM_DEFINE_SV
`define TRIM_DEFINE_SV

    `define clk_gen(CLK_NAME, HALF_PERIOD,DELAY_TIME) \
    	initial begin \
    		CLK_NAME = 1'b0; \
            #(DELAY_TIME *10ps); \
    		forever begin \
    		#HALF_PERIOD; \
    		CLK_NAME = ~CLK_NAME; \
    		end \
    	end
    
    `define rst_gen(RST_NAME, INITIAL_VALUE, PERIOD1) \
    	initial begin \
    		RST_NAME = INITIAL_VALUE; \
    		#PERIOD1 RST_NAME = ~INITIAL_VALUE; \
    		//#PERIOD2 RST_NAME = INITIAL_VALUE; \
        end

    
    `define APB_ADDR_WIDTH  8
    `define APB_DATA_WIDTH  32

        `define N           4
        `define DRAM_LAYER  4
        `define RES_WIDTH   8

`endif // TRIM_DEFINE_SV

