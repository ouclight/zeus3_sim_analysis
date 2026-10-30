module   wl_clkgate
     (
     clk_i      ,
     dft_se     ,
     en         ,
     clk_o      
     );
//---------------------------------------------------------------------------------------
//defines / params
//---------------------------------------------------------------------------------------
parameter CLK_NUM     = 1;

//---------------------------------------------------------------------------------------
//port list
//---------------------------------------------------------------------------------------
input   [CLK_NUM-1:0]                clk_i       ;//clk in
input                                dft_se      ;//dft enable
input   [CLK_NUM-1:0]                en          ;//enable high active
output  [CLK_NUM-1:0]                clk_o       ;//clk out

//---------------------------------------------------------------------------------------
//process signal
//---------------------------------------------------------------------------------------
reg     [CLK_NUM-1:0]                en_latch    ;

genvar                  i;

//---------------------------------------------------------------------------------------
//code start
//---------------------------------------------------------------------------------------
`ifdef RTLSIM

generate
    for(i = 0; i < CLK_NUM; i = i + 1)
        begin:ICG_RTL
            always @ (*)
                if(~clk_i[i])
                    en_latch[i] <= en[i] | dft_se;
            
            assign  clk_o[i] = en_latch[i] && clk_i[i];//latch output and clock input
        end
endgenerate

`else

//use lib ICG replace
generate
    for(i = 0; i < CLK_NUM; i = i + 1)
        begin:ICG_CELL
            //PREICG_X1R_A10P5PP84TR_C14 latch ( .CK(clk_i), .E(en), .SE(1'b0), .ECK(clk_o));
            //PREICG_X1B_A6TR_C60 latch(.ECK(clk_o[i]), .CK(clk_i[i]), .E(en[i]), .SE(dft_se));
            //PREICG_X6B_A9TR latch(.ECK(clk_o[i]), .CK(clk_i[i]), .E(en[i]), .SE(dft_se));
            CLKLANQV8_12TR40        latch(.TE(dft_se), .E(en[i]), .CK(clk_i[i]), .Q(clk_o[i]));
        end
endgenerate

`endif

//---------------------------------------------------------------------------------------
//code end
//---------------------------------------------------------------------------------------
endmodule
