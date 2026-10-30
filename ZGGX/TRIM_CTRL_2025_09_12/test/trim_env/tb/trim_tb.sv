`timescale 1ns/1ps

module trim_tb;

//  timeunit $timeunit;

//  timeprecision $timeprecision;


    `include "uvm_macros.svh"

    import uvm_pkg::*;

    //lid//import clk_rst_pkg::*;

    import svt_uvm_pkg::*;
    import svt_apb_uvm_pkg::*;
    import trim_test_pkg::*;
    import trim_env_pkg::*;


	logic   clk; //400M
	logic   rst_n;
    logic   pclk;
    logic   prst_n;
    logic   clk_dv; //2G
	real    HALF_PERIOD = 1.25ns; //400M,2.5ns
	real    HALF_PERIOD_APB = 2.5ns; //200M,5ns
    real    HALF_PERIOD_DV = 0.25ns; //2G, 0.5ns
	bit     INITIAL_VALUE = 1'b0;
	real    PERIOD1 = 50ns;
	real    PERIOD2 = 100;

	// Generate clock and reset
	`clk_gen(clk, HALF_PERIOD, 100)
    `rst_gen(rst_n, INITIAL_VALUE, PERIOD1)
	`clk_gen(pclk, HALF_PERIOD_APB, 100)
    `rst_gen(prst_n, INITIAL_VALUE, PERIOD2)
    //0804//`clk_gen(clk_dv, HALF_PERIOD_DV, 100) //add 0804


    //lid//clk_rst_if  m_clk_if();
    //lid//clk_rst_gen m_clk_gen;
    svt_apb_if    m_apb_if();
    //assign m_apb_if.clk = m_clk_if.clk;
    //assign m_apb_if.rst_n = m_clk_if.rst_n;


    trim_if m_trim_if(clk,rst_n);

    /*
     * apb clk and reset
     */
    assign m_apb_if.pclk    = pclk;
    assign m_apb_if.presetn = prst_n;
    assign m_apb_if.pslverr[0] = 'h0;
    assign m_apb_if.pready[0] = 'h1;


    //lid//initial
    //lid//begin
    //lid//    m_clk_gen = new("trim_clk_rst");
    //lid//    m_clk_gen.clk_config(192/*KHz*/,200/*ns*/,m_clk_if);
    //lid//    m_clk_gen.gen();
    //lid//end

    `include "model_inst.sv"
    /////////////////////////
    //dut u_dut(*) 
    /////////////////////////
    `include "dut_inst.sv"
    //0805//`include "trim_sva_check.sv"

    assign m_trim_if.fsm_cs = trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs;
    assign m_trim_if.dumpready_timeout_ready = trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_ready;
                                               //trim_tb.u_dram_trim_top.apb2reg_dram_trim_cfg_if_u.dumpready_timeout_ready_apb_dff;
    //assign m_trim_if.stopwatch_ringo_dv   = trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo_flag;
    assign m_trim_if.dram_layer_cfg = trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dram_layer_sel;

    //for tsv_tm timing check:
    assign m_trim_if.init_spine_reset_time = trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_spine_reset_time_sync;
    assign m_trim_if.tm_redump_width = trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump_width_sync;
    assign m_trim_if.spine_reset_width = trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_resetn_width_sync;
    assign m_trim_if.trim_start_reg = trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_start_reg;
    assign m_trim_if.init_start_sync = trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_start_sync;
    assign m_trim_if.dram_tsv_tm0 = trim_tb.u_quad_group.tsv_tm_delay_0_o;
    assign m_trim_if.dram_tsv_tm1 = trim_tb.u_quad_group.tsv_tm_delay_1_o;
    assign m_trim_if.dram_tsv_tm2 = trim_tb.u_quad_group.tsv_tm_delay_2_o;
    assign m_trim_if.dram_tsv_tm3 = trim_tb.u_quad_group.tsv_tm_delay_3_o;
    assign m_trim_if.dram_sp_rst_n = trim_tb.u_quad_group.spine_reset_n_delay_o;
    assign m_trim_if.dram_tm_redump = trim_tb.u_quad_group.tm_redump_delay_o;


    initial begin
		uvm_config_db #(virtual svt_apb_if)::set(null, "*m_svt_apb_env", "vif", m_apb_if);
		uvm_config_db #(virtual svt_apb_if)::set(null, "*", "apb_vif", m_apb_if);
		uvm_config_db #(virtual trim_if)::set(null, "*", "trim_vif", m_trim_if);
  	end

    initial begin
        run_test();
    end

    initial begin
        $timeformat(-9, 6, " ns", 15);
    end

    string  dump_mode_str;
    int     dump_vpd = 0;
    int     dump_fsdb = 0;
    initial begin
        $value$plusargs("dump_mode=%s",dump_mode_str);
        $display("dump_mode is %s",dump_mode_str);
        if(dump_mode_str == "" || dump_mode_str == "fsdb") begin
            $display("dump_mode is %s, dump fsdb file by dump_fsdb.do",dump_mode_str);
            dump_fsdb = 1;
        end
        else if(dump_mode_str == "off") begin
            $display("dump_mode is %s, not dump waveform",dump_mode_str);
        end
    end

endmodule

