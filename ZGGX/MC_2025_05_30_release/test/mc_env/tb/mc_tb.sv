//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_tb.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================


`timescale 1ns/1ps
`include "define.vh"
`include "tb_if.sv"
//`include "rtl/PLLFRAC.v"
module mc_tb;

//  timeunit $timeunit;

//  timeprecision $timeprecision;

    real period_clk  = 2.5;//400MHz
    real period_pclk = 5;   //200MHz
    real period_pll_clk = 20;   //pll clock 50Mhz
    bit  INITIAL_VALUE = 0;
	real PERIOD0 = 5ns;    
	real PERIOD1 = 20ns;
	real PERIOD2 = 60ns;
	real PERIOD3 = 70ns;
	real PERIOD4 = 80ns;
	real PERIOD5 = 80ns;
	real PERIOD6 = 90ns;
    logic rst_n;
    logic ras_rst_n;
    logic apb_rst_n;
    logic pll_rst_n;
    logic freq_rst_n;
    logic clk_pll;
    logic pll_lkdt;
    logic clk;
    logic clk_pll_rdy=0;
    `include "uvm_macros.svh"
    
    import uvm_pkg::*;
    import svt_uvm_pkg::*;
    //import clk_rst_pkg::*;

    import svt_apb_uvm_pkg::*;

    import frame_agent_pkg::*;
    import array_agent_pkg::*;
    import mc_test_pkg::*;
    import mc_env_pkg::*;
    
    `tb_clk_gen(clk_osc,period_pll_clk,0);
    `tb_clk_gen(pclk,period_pclk,0);

    `tb_rst_gen(rst_n, INITIAL_VALUE, PERIOD1);
    `tb_rst_gen(ras_rst_n, INITIAL_VALUE, PERIOD0);
    `tb_rst_gen(apb_rst_n, INITIAL_VALUE, PERIOD6);
    `tb_rst_gen(pll_rst_n, INITIAL_VALUE, PERIOD1);
    `tb_rst_gen(freq_rst_n, INITIAL_VALUE, PERIOD0);
    

    genvar T;
    generate
        for (T=0;T<2;T=T+1) begin :apb_if_gen
            svt_apb_if      m_svt_apb_if();
        end
    endgenerate


    frame_agent_if      m_frame_agent_if(clk,rst_n);
    array_agent_if      m_array_agent_if(clk,rst_n);
    tb_if               u_tb_if(clk,rst_n);



    //-----------------------
    //env freq and array_model 
    //-----------------------
    //wl_freq_erase   m_wl_freq_erase(
    //    .clk_i                      (clk_i                      ),
    //    .rst_n                      (freq_rst_n                 ),
    //    .dft_mode_i                 (1'b0                       ),
    //    .dft_rst_n_i                (1'b1                       ),
    //    .cnt_load                   (u_tb_if.cnt_load           ),
    //    .div_cnt                    (u_tb_if.div_cnt            ),
    //    .clk_o                      (clk                        )
    //);

/*    wl_freq_scal    m_wl_freq_scal(
        .clk_i                      (clk_i                      ),
        .rst_n                      (freq_rst_n                 ),
        .dft_mode_i                 (1'b0                       ),
        .dft_rst_n_i                (1'b1                       ),
        .cnt_load                   (u_tb_if.cnt_load           ),
        .div_cnt                    (u_tb_if.div_cnt            ),
        .clk_o                      (clk                        )
    );*/
    
    `include "model_inst.sv"
    //-----------------------
    //dut inst 
    //-----------------------
    `include "dut_inst.sv"
    `include "assertion.sv"

    `ifdef CLK_500M
    PLLFRAC PLL_500
        (
        .FREF                   (clk_osc                       ),//100Mhz osc
        .REFDIV                 (6'd2                        ),//6'd2
        .FBDIV                  (12'd20                         ),//12'd32
        .FRAC                   (24'h0                           ),//24'h0
        .POSTDIV1               (3'd2                           ),//3'd2
        .POSTDIV2               (3'd1                           ),//3'd1
        .PD                     (!pll_rst_n                        ),
        .BYPASS                 (1'h0                           ),//1'h0
        .DSMPD                  (1'h1                           ),//1'h1
        .DACPD                  (1'h0                           ),//1'h0
        .FOUT4PHASEPD           (1'h1                           ),//1'h1
        .FOUTPOSTDIVPD          (1'h0                           ),//1'h0
        .FOUTVCOPD              (1'h1                           ),//1'h1
        .CLKSSCG                (                               ),
        .FOUT1PH0               (                               ),
        .FOUT1PH180             (                               ),
        .FOUT1PH270             (                               ),
        .FOUT1PH90              (                               ),
        .FOUT2                  (                               ),
        .FOUT3                  (                               ),
        .FOUT4                  (                               ),
        .FOUTPOSTDIV            (clk_pll                        ),//800Mhz
        .FOUTVCO                (                               ),
        .LOCK                   (pll_lkdt                       )//PLL lock
        );
    `elsif CLK_300M
    PLLFRAC PLL_300
        (
        .FREF                   (clk_osc                       ),//100Mhz osc
        .REFDIV                 (6'd2                        ),//6'd2
        .FBDIV                  (12'd12                         ),//12'd32
        .FRAC                   (24'h0                           ),//24'h0
        .POSTDIV1               (3'd2                           ),//3'd2
        .POSTDIV2               (3'd1                           ),//3'd1
        .PD                     (!pll_rst_n                        ),
        .BYPASS                 (1'h0                           ),//1'h0
        .DSMPD                  (1'h1                           ),//1'h1
        .DACPD                  (1'h0                           ),//1'h0
        .FOUT4PHASEPD           (1'h1                           ),//1'h1
        .FOUTPOSTDIVPD          (1'h0                           ),//1'h0
        .FOUTVCOPD              (1'h1                           ),//1'h1
        .CLKSSCG                (                               ),
        .FOUT1PH0               (                               ),
        .FOUT1PH180             (                               ),
        .FOUT1PH270             (                               ),
        .FOUT1PH90              (                               ),
        .FOUT2                  (                               ),
        .FOUT3                  (                               ),
        .FOUT4                  (                               ),
        .FOUTPOSTDIV            (clk_pll                        ),//800Mhz
        .FOUTVCO                (                               ),
        .LOCK                   (pll_lkdt                       )//PLL lock
        );
    `else
    //PLL_800
    PLLFRAC PLL_800
        (
        .FREF                   (clk_osc                       ),//100Mhz osc
        .REFDIV                 (6'd2                        ),//6'd2
        .FBDIV                  (12'd32                         ),//12'd32
        .FRAC                   (24'h0                           ),//24'h0
        .POSTDIV1               (3'd2                           ),//3'd2
        .POSTDIV2               (3'd1                           ),//3'd1
        .PD                     (!pll_rst_n                        ),
        .BYPASS                 (1'h0                           ),//1'h0
        .DSMPD                  (1'h1                           ),//1'h1
        .DACPD                  (1'h0                           ),//1'h0
        .FOUT4PHASEPD           (1'h1                           ),//1'h1
        .FOUTPOSTDIVPD          (1'h0                           ),//1'h0
        .FOUTVCOPD              (1'h1                           ),//1'h1
        .CLKSSCG                (                               ),
        .FOUT1PH0               (                               ),
        .FOUT1PH180             (                               ),
        .FOUT1PH270             (                               ),
        .FOUT1PH90              (                               ),
        .FOUT2                  (                               ),
        .FOUT3                  (                               ),
        .FOUT4                  (                               ),
        .FOUTPOSTDIV            (clk_pll                        ),//800Mhz
        .FOUTVCO                (                               ),
        .LOCK                   (pll_lkdt                       )//PLL lock
        );
    `endif

    always @(posedge clk_pll)   clk_pll_rdy = pll_lkdt;
    assign  clk    =    clk_pll_rdy &  clk_pll;

    genvar m;
    generate    
        for(m=0; m<2; m++) begin:set_apb_if
            initial
                begin
                    uvm_config_db #(virtual svt_apb_if)::set(null,$sformatf("uvm_test_top.m_env.m_svt_apb_env[%0d]",m), "vif",apb_if_gen[m].m_svt_apb_if);
                    uvm_config_db #(virtual svt_apb_if)::set(null,"*",$sformatf("m_svt_apb_vif[%0d]",m),apb_if_gen[m].m_svt_apb_if);
                end
        end
    endgenerate
    
    initial
    begin
		uvm_config_db #(virtual frame_agent_if)::set(null, "*", "frame_agent_vif", m_frame_agent_if);
		uvm_config_db #(virtual array_agent_if)::set(null, "*", "array_agent_vif", m_array_agent_if);
        uvm_config_db #(virtual tb_if)::set(null, "*", "vif_tb", u_tb_if);

  	end

    initial begin
        run_test();
    end

    initial begin
        $timeformat(-9, 3, " ns", 10);
    end

    string      s_dump_mode;
    int         dump_fsdb = 0;
    initial begin
        $value$plusargs("dump_mode=%s", s_dump_mode);
        if(s_dump_mode == "fsdb") begin
            $display("==========dumping fsdb by run_vcs.ucli==========");
            dump_fsdb = 1;
        end
    end

endmodule
