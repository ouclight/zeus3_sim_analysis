/*********************************-Verilog-****************************************
-- All rights reserved.
-- Copyright (c) 2018 -        Xi'an UniIC
**********************************************************************************
-- Project         :   WORKLIBRARY
-- Filename        :   wl_clk_rst_sync.v
-- Language        :   Verilog
-- Author          :   Han Yang
-- Create Date     :   2019-07-12
**********************************************************************************
-- Abstract        :   (you need type related info here manually)
-- Description     :
--                                       .
--                     (you need type related info here manually)
**********************************************************************************
-- History:
-- Date (y-m-d)       Versions          Author            Description
-- 2019-07-12          1.0              hanyang           initial version
--
**********************************************************************************/
module   wl_clk_rst_sync
     (
     clk_i          ,
     rst_n_i        ,
     dft_mode_i     ,
     dft_rst_n_i    ,
     rst_n_sync_o   
     );
//---------------------------------------------------------------------------------------
//port list
//---------------------------------------------------------------------------------------
input                   clk_i           ;//clk in
input                   rst_n_i         ;//rst in
output                  rst_n_sync_o    ;//rst sync out
input                   dft_mode_i      ;
input                   dft_rst_n_i     ;

//---------------------------------------------------------------------------------------
//process signal
//---------------------------------------------------------------------------------------
reg         s_syn_rst1_n;
reg         s_syn_rst2_n;
reg         s_syn_rst3_n;

wire        s_f_rst_n;

//---------------------------------------------------------------------------------------
//code start
//---------------------------------------------------------------------------------------

MUX2V4_12TR40 rst_f_mux_u(.I0 (rst_n_i), .I1 (dft_rst_n_i), .S (dft_mode_i), .Z (s_f_rst_n));

always @ (posedge clk_i or negedge s_f_rst_n)
    if(!s_f_rst_n)
        begin
            s_syn_rst1_n <= 1'b0;
            s_syn_rst2_n <= 1'b0;
            s_syn_rst3_n <= 1'b0;
        end
    else
        begin
            s_syn_rst1_n <= 1'b1;
            s_syn_rst2_n <= s_syn_rst1_n;
            s_syn_rst3_n <= s_syn_rst2_n;
        end

assign  rst_n_sync_o = s_syn_rst3_n;

//---------------------------------------------------------------------------------------
//code end
//---------------------------------------------------------------------------------------
endmodule
