/*********************************-Verilog-****************************************
-- All rights reserved.
-- Copyright (c) 2018 -        Xi'an UniIC
**********************************************************************************
-- Project         :   CMC100
-- Filename        :   wl_freq_scal.v
-- Language        :   Verilog
-- Author          :   Han Yang
-- Create Date     :   2022-10-25
**********************************************************************************
-- Abstract        :   (you need type related info here manually)
-- Description     :
--                                       .
--                     (you need type related info here manually)
**********************************************************************************
-- History:
-- Date (y-m-d)       Versions          Author            Description
-- 2022-10-25          1.0              hanyang           initial version
--
**********************************************************************************/
module   wl_freq_scal
     (
     clk_i      ,
     rst_n      ,
     dft_mode_i ,
     dft_rst_n_i,
     cnt_load   ,//APB,1:cfg 0;2:cfg div_cnt;3:cfg 1
     div_cnt    ,//APB min 1;max :128
     clk_o      
     );
//---------------------------------------------------------------------------------------
//defines / params
//---------------------------------------------------------------------------------------
parameter   DIV_BIT_WIDTH   = 8;//

//---------------------------------------------------------------------------------------
//port list
//---------------------------------------------------------------------------------------
input                                   clk_i       ;//clk in
input                                   rst_n       ;//rst_n
input                                   dft_mode_i  ;
input                                   dft_rst_n_i ;
input                                   cnt_load    ;//cnt_load
input   [DIV_BIT_WIDTH-1    :0]         div_cnt     ;//div para
output                                  clk_o       ;//clk out

//---------------------------------------------------------------------------------------
//process signal
//---------------------------------------------------------------------------------------
reg     [DIV_BIT_WIDTH-1:0]                 s_div_cnt           ;
wire    [DIV_BIT_WIDTH-1:0]                 s_next_div_cnt      ;
reg     [DIV_BIT_WIDTH-1:0]                 s_pre_div           ;

wire                                        s_gate_en           ;
wire                                        s_cnt_load_syn      ;
wire                                        rst_sync_n          ;

//---------------------------------------------------------------------------------------
//code start
//---------------------------------------------------------------------------------------
wl_clk_rst_sync wl_clk_rst_sync_u
     (
     .clk_i                (clk_i           ),
     .rst_n_i              (rst_n           ),
     .dft_mode_i           (dft_mode_i      ),
     .dft_rst_n_i          (dft_rst_n_i     ),
     .rst_n_sync_o         (rst_sync_n      )
     );

//syn cnt_load
wl_sync2dff
    #(
     .WIDTH                (1               )
     ) 
wl_sync2dff_u1
     (
     .clk                  (clk_i           ),
     .rst_n                (rst_sync_n      ),
     .din                  (cnt_load        ),
     .dout                 (s_cnt_load_syn  )
     );

//load pre cnt
always @ (posedge clk_i or negedge rst_sync_n)
    if(!rst_sync_n)
        s_pre_div <= {DIV_BIT_WIDTH{1'b0}};
    else if(s_cnt_load_syn && (s_div_cnt == s_pre_div))
        s_pre_div <= div_cnt-1'b1;

//gen pre div
//assign  s_pre_div = div_cnt-32'd1;

//gen next div cnt
assign  s_next_div_cnt = (s_div_cnt == s_pre_div) ? {DIV_BIT_WIDTH{1'b0}} : (s_div_cnt +1'b1);

//gen div cnt
always @ (posedge clk_i or negedge rst_sync_n)
    if(!rst_sync_n)
        s_div_cnt <= {DIV_BIT_WIDTH{1'b0}};
    else
        s_div_cnt <= s_next_div_cnt;

//gen gate en
assign  s_gate_en = (s_div_cnt == s_pre_div) ? 1'b1 : 1'b0;

//intance icg
wl_clkgate  
    #(
     .CLK_NUM       (1           )
     )
wl_clkgate_u
     (
     .clk_i         (clk_i       ),
     .dft_se        (1'b0        ),
     .en            (s_gate_en   ),
     .clk_o         (clk_o       )
     );

//---------------------------------------------------------------------------------------
//code end
//---------------------------------------------------------------------------------------
endmodule
