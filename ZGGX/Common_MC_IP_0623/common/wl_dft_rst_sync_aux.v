/**
 * File              : wl_dft_rst_sync_aux.v
 * Author            : dongl
 * Date              : 23.06.2025
 * Last Modified Date: 23.06.2025
 * COPYRIGHT(c) 2021 - 2024, BJXX, ALL RIGHTS RESERVED.
 */



module   wl_dft_rst_sync_aux
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
wire        s_b_rst_n;

//---------------------------------------------------------------------------------------
//code start
//---------------------------------------------------------------------------------------
`ifdef RTLSIM
assign  s_f_rst_n = dft_mode_i ? dft_rst_n_i : rst_n_i;
`else
//HSBSVT20_MUX2_4 rst_f_mux_u(.D0 (rst_n_i), .D1 (dft_rst_n_i), .S (dft_mode_i), .X (s_f_rst_n));
mux mux_inst0(.i_in0(rst_n_i),.i_in1(dft_rst_n_i),.i_sel(dft_mode_i),.o_out(s_f_rst_n));
`endif

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

`ifdef RTLSIM
assign  s_b_rst_n = dft_mode_i ? dft_rst_n_i : s_syn_rst3_n;
`else
//HSBSVT20_MUX2_4 rst_b_mux_u(.D0 (s_syn_rst3_n), .D1 (dft_rst_n_i), .S (dft_mode_i), .X (s_b_rst_n));
mux mux_inst1(.i_in0(s_syn_rst3_n),.i_in1(dft_rst_n_i),.i_sel(dft_mode_i),.o_out(s_b_rst_n));
`endif

assign  rst_n_sync_o = s_b_rst_n;

//---------------------------------------------------------------------------------------
//code end
//---------------------------------------------------------------------------------------
endmodule
