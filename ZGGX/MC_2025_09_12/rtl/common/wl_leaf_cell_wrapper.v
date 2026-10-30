//======================================================================
//rdrdy_n clamping
//======================================================================
module wl_clk_or (
    input       clk_i,
    input       clk_en,
    output      clk_o
);

//ISO_OR2V2_140P9T40R rdrdy_n_u0 (.I (clk_i) , .EN(clk_en), .Z(clk_o));
 CK_OR rdrdy_n_u0 (.i_clk0(clk_i),.i_clk1(clk_en),.o_clk(clk_o));

endmodule

//======================================================================
//rdrdy_n clock and dft clock mux, DFT use
//======================================================================
module wl_clk_mux (
    input           clk_i0,
    input           clk_i1,
    input           clk_sel,
    output          clk_o
);

//CLKMUX2V0_140P9T35R rdrdy_n_u1 (.I0(clk_i0), .I1(clk_i1), .S(clk_sel), .Z(clk_o));
CK_MUX2 rdrdy_n_u1
( 
    .i_clk0                                       (clk_i0                                                 ), 
    .i_clk1                                       (clk_i1                                                 ), 
    .i_sel                                        (clk_sel                                                ), 
    .test_mode                                    (1'd0                                                   ), 
    .o_clk                                        (clk_o                                                  )
); 

endmodule

//======================================================================
//  clock gate
//  positive edge triggered clock-gating latch
//======================================================================
module wl_clk_gate (
    input           clk_i,
    input           clk_en,
    input           dft_sel,
    output          clk_o
);

//CLKLANQV0_140P9T35R latch(.TE(dft_sel), .E(clk_en), .CK(clk_i), .Q(clk_o));
CK_GATE    clk_gate(.test_mode(dft_sel),.clk_en(clk_en),.i_clk(clk_i),.o_clk(clk_o));

endmodule



