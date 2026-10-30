`ifndef MC_clk_VSEQ
`define MC_clk_VSEQ

`define ABS(x) ((x) >= 0 ? (x) : -(x))
class mc_clk_vseq extends mc_common_vseq;
    
    `uvm_object_utils(mc_clk_vseq)

    function new(string name="mc_clk_vseq");
        super.new(name);
    endfunction

    ////clk period
    //rand int            clk_period_switch;

    //constraint c_clk_period_switch {
    //    clk_period_switch dist {12500:=20, 5000:=20, 2500:=20,  1250:=20}; //80MHz, 200MHz, 400MHz, /*640MHz delete*/, 800MHz
    //}

    extern virtual task body();
    extern task clk_period_chk(string clk_name, real period_p, real period_n, real period);
    extern task value_check(string clk_name, bit exp_value);

endclass: mc_clk_vseq



task mc_clk_vseq::body();

    //used to check clk period
    real        time_pos0;
    real        time_neg0;
    real        time_pos1;

    //exp_clk_period
    real        period_apb = 5;
    real        period_sys = 1.25;


    real exp_clk_period;
    real gating_start_time; //delay gating_start_time, and then start gating

    super.body();
    `uvm_info(get_type_name(),"\n =================mc_clk_vseq body start==============", UVM_LOW);

    //clk period check
    `uvm_info("clk period check","\n============================clk period and gating check start!========================", UVM_LOW);

    #100ps
    //apb clk frequency check
    exp_clk_period = 5;         //apb clk is 200MHz


   `uvm_info("clk period check","apb clk check start!",UVM_LOW);

    @(posedge m_tb_if.pclk); time_pos0 = $realtime;
    @(negedge m_tb_if.pclk); time_neg0 = $realtime;
    @(posedge m_tb_if.pclk); time_pos1 = $realtime;
    clk_period_chk("m_tb_if.pclk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.wrapper_apb_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.wrapper_apb_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.wrapper_apb_clk); time_pos1 = $realtime;
    clk_period_chk("m_tb_if.wrapper_apb_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.mc_top_apb_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.mc_top_apb_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.mc_top_apb_clk); time_pos1 = $realtime;
    clk_period_chk("mc_top_apb_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.apb2reg_mc_soc_top_cfg_if_apb_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.apb2reg_mc_soc_top_cfg_if_apb_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.apb2reg_mc_soc_top_cfg_if_apb_clk); time_pos1 = $realtime;
    clk_period_chk("mc_soc_top_cfg_if_apb_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u0_apb_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.ipdb_pulse2pulse_inst_u0_apb_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u0_apb_clk); time_pos1 = $realtime;
    clk_period_chk("ipdb_pulse2pulse_inst_u0_apb_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u1_apb_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.ipdb_pulse2pulse_inst_u1_apb_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u1_apb_clk); time_pos1 = $realtime;
    clk_period_chk("ipdb_pulse2pulse_inst_u1_apb_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u2_apb_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.ipdb_pulse2pulse_inst_u2_apb_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u2_apb_clk); time_pos1 = $realtime;
    clk_period_chk("ipdb_pulse2pulse_inst_u2_apb_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u3_apb_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.ipdb_pulse2pulse_inst_u3_apb_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u3_apb_clk); time_pos1 = $realtime;
    clk_period_chk("ipdb_pulse2pulse_inst_u3_apb_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.global_bist_clr_sync_apb_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.global_bist_clr_sync_apb_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.global_bist_clr_sync_apb_clk); time_pos1 = $realtime;
    clk_period_chk("global_bist_clr_sync_apb_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.global_mc_bist_start_sync_apb_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.global_mc_bist_start_sync_apb_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.global_mc_bist_start_sync_apb_clk); time_pos1 = $realtime;
    clk_period_chk("global_mc_bist_start_sync_apb_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.global_mc_rescan_start_sync_apb_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.global_mc_rescan_start_sync_apb_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.global_mc_rescan_start_sync_apb_clk); time_pos1 = $realtime;
    clk_period_chk("global_mc_rescan_start_sync_apb_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.rst_apb_n_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.rst_apb_n_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.rst_apb_n_clk); time_pos1 = $realtime;
    clk_period_chk("rst_apb_n_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    `uvm_info(get_type_name(),"apb clk force0",UVM_LOW)
    uvm_hdl_force("mc_tb.pclk",1'b0);
    #(period_apb/2)
    value_check("mc_tb.u_tb_if.pclk", 1'b0);
    value_check("mc_tb.u_tb_if.wrapper_apb_clk", 1'b0);
    value_check("mc_tb.u_tb_if.mc_top_apb_clk", 1'b0);
    value_check("mc_tb.u_tb_if.apb2reg_mc_soc_top_cfg_if_apb_clk", 1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u0_apb_clk", 1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u1_apb_clk", 1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u2_apb_clk", 1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u3_apb_clk", 1'b0);

    #(period_apb/2)
    value_check("mc_tb.u_tb_if.pclk", 1'b0);
    value_check("mc_tb.u_tb_if.wrapper_apb_clk", 1'b0);
    value_check("mc_tb.u_tb_if.mc_top_apb_clk", 1'b0);
    value_check("mc_tb.u_tb_if.apb2reg_mc_soc_top_cfg_if_apb_clk", 1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u0_apb_clk", 1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u1_apb_clk", 1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u2_apb_clk", 1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u3_apb_clk", 1'b0);

    `uvm_info(get_type_name(),"apb clk force1",UVM_LOW)
    #(period_apb/2)
    uvm_hdl_force("mc_tb.pclk",1'b1);
    value_check("mc_tb.u_tb_if.pclk", 1'b1);
    value_check("mc_tb.u_tb_if.wrapper_apb_clk", 1'b1);
    value_check("mc_tb.u_tb_if.mc_top_apb_clk", 1'b1);
    value_check("mc_tb.u_tb_if.apb2reg_mc_soc_top_cfg_if_apb_clk", 1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u0_apb_clk", 1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u1_apb_clk", 1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u2_apb_clk", 1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u3_apb_clk", 1'b1);

    #(period_apb/2)
    value_check("mc_tb.u_tb_if.pclk", 1'b1);
    value_check("mc_tb.u_tb_if.wrapper_apb_clk", 1'b1);
    value_check("mc_tb.u_tb_if.mc_top_apb_clk", 1'b1);
    value_check("mc_tb.u_tb_if.apb2reg_mc_soc_top_cfg_if_apb_clk", 1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u0_apb_clk", 1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u1_apb_clk", 1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u2_apb_clk", 1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u3_apb_clk", 1'b1);

    uvm_hdl_release("mc_tb.pclk");
    `uvm_info(get_type_name(),"apb clk release",UVM_LOW)


    `uvm_info("clk period check","mc clk check start!",UVM_LOW);
    //mc clk check
    exp_clk_period = 2.5;      //mc default clk is 800MHz
    @(posedge m_tb_if.clk); time_pos0 = $realtime;
    @(negedge m_tb_if.clk); time_neg0 = $realtime;
    @(posedge m_tb_if.clk); time_pos1 = $realtime;
    clk_period_chk("mc_tb_if.clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    exp_clk_period = 2.5;      
    @(posedge m_tb_if.wrapper_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.wrapper_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.wrapper_clk); time_pos1 = $realtime;
    clk_period_chk("mc_tb_if.wrapper_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    exp_clk_period = 2.5;      
    @(posedge m_tb_if.ecc_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.ecc_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.ecc_clk); time_pos1 = $realtime;
    clk_period_chk("mc_tb_if.ecc_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    exp_clk_period = 2.5;      
    @(posedge m_tb_if.ecc_top_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.ecc_top_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.ecc_top_clk); time_pos1 = $realtime;
    clk_period_chk("mc_tb_if.ecc_top_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.mc_fram_debug_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.mc_fram_debug_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.mc_fram_debug_clk); time_pos1 = $realtime;
    clk_period_chk("mc_fram_debug_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.mc_top_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.mc_top_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.mc_top_clk); time_pos1 = $realtime;
    clk_period_chk("mc_top_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.mc_frame2frame_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.mc_frame2frame_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.mc_frame2frame_clk); time_pos1 = $realtime;
    clk_period_chk("mc_frame2frame_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.frame_arbiter_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.frame_arbiter_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.frame_arbiter_clk); time_pos1 = $realtime;
    clk_period_chk("frame_arbiter_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.mc_timeout_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.mc_timeout_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.mc_timeout_clk); time_pos1 = $realtime;
    clk_period_chk("mc_timeout_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.frame2array_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.frame2array_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.frame2array_clk); time_pos1 = $realtime;
    clk_period_chk("frame2array_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.U0_mc_ctrl_DW_sync_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.U0_mc_ctrl_DW_sync_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.U0_mc_ctrl_DW_sync_clk); time_pos1 = $realtime;
    clk_period_chk("U0_mc_ctrl_DW_sync_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.U1_mc_ctrl_DW_sync_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.U1_mc_ctrl_DW_sync_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.U1_mc_ctrl_DW_sync_clk); time_pos1 = $realtime;
    clk_period_chk("U1_mc_ctrl_DW_sync_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.U2_mc_ctrl_DW_sync_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.U2_mc_ctrl_DW_sync_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.U2_mc_ctrl_DW_sync_clk); time_pos1 = $realtime;
    clk_period_chk("U2_mc_ctrl_DW_sync_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u0_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.ipdb_pulse2pulse_inst_u0_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u0_clk); time_pos1 = $realtime;
    clk_period_chk("ipdb_pulse2pulse_inst_u0_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u1_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.ipdb_pulse2pulse_inst_u1_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u1_clk); time_pos1 = $realtime;
    clk_period_chk("ipdb_pulse2pulse_inst_u1_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u2_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.ipdb_pulse2pulse_inst_u2_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u2_clk); time_pos1 = $realtime;
    clk_period_chk("ipdb_pulse2pulse_inst_u2_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u3_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.ipdb_pulse2pulse_inst_u3_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.ipdb_pulse2pulse_inst_u3_clk); time_pos1 = $realtime;
    clk_period_chk("ipdb_pulse2pulse_inst_u3_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.bist_scan_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.bist_scan_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.bist_scan_clk); time_pos1 = $realtime;
    clk_period_chk("bist_scan_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.dram_init_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.dram_init_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.dram_init_clk); time_pos1 = $realtime;
    clk_period_chk("dram_init_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.bist_rescan_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.bist_rescan_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.bist_rescan_clk); time_pos1 = $realtime;
    clk_period_chk("bist_rescan_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.wl_clkgate_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.wl_clkgate_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.wl_clkgate_clk); time_pos1 = $realtime;
    clk_period_chk("wl_clkgate_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.global_bist_clr_sync_mc_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.global_bist_clr_sync_mc_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.global_bist_clr_sync_mc_clk); time_pos1 = $realtime;
    clk_period_chk("global_bist_clr_sync_mc_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.global_mc_bist_start_sync_mc_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.global_mc_bist_start_sync_mc_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.global_mc_bist_start_sync_mc_clk); time_pos1 = $realtime;
    clk_period_chk("global_mc_bist_start_sync_mc_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.global_mc_rescan_start_sync_mc_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.global_mc_rescan_start_sync_mc_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.global_mc_rescan_start_sync_mc_clk); time_pos1 = $realtime;
    clk_period_chk("global_mc_rescan_start_sync_mc_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    @(posedge m_tb_if.rst_mc_n_clk); time_pos0 = $realtime;
    @(negedge m_tb_if.rst_mc_n_clk); time_neg0 = $realtime;
    @(posedge m_tb_if.rst_mc_n_clk); time_pos1 = $realtime;
    clk_period_chk("rst_mc_n_clk", time_neg0- time_pos0, time_pos1 - time_neg0, exp_clk_period);

    `uvm_info(get_type_name(),"mc clk force0",UVM_LOW)
    uvm_hdl_force("mc_tb.clk",1'b0);
    #(period_sys/2)
    value_check("mc_tb.u_tb_if.clk",1'b0);
    value_check("mc_tb.u_tb_if.wrapper_clk",1'b0);
    value_check("mc_tb.u_tb_if.ecc_clk",1'b0);
    value_check("mc_tb.u_tb_if.ecc_top_clk",1'b0);
    value_check("mc_tb.u_tb_if.mc_fram_debug_clk",1'b0);
    value_check("mc_tb.u_tb_if.mc_top_clk",1'b0);
    value_check("mc_tb.u_tb_if.mc_frame2frame_clk",1'b0);
    value_check("mc_tb.u_tb_if.frame_arbiter_clk",1'b0);
    value_check("mc_tb.u_tb_if.mc_timeout_clk",1'b0);
    value_check("mc_tb.u_tb_if.frame2array_clk",1'b0);
    value_check("mc_tb.u_tb_if.U0_mc_ctrl_DW_sync_clk",1'b0);
    value_check("mc_tb.u_tb_if.U1_mc_ctrl_DW_sync_clk",1'b0);
    value_check("mc_tb.u_tb_if.U2_mc_ctrl_DW_sync_clk",1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u0_clk",1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u1_clk",1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u2_clk",1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u3_clk",1'b0);

    #(period_sys/2)
    value_check("mc_tb.u_tb_if.clk",1'b0);
    value_check("mc_tb.u_tb_if.wrapper_clk",1'b0);
    value_check("mc_tb.u_tb_if.ecc_clk",1'b0);
    value_check("mc_tb.u_tb_if.ecc_top_clk",1'b0);
    value_check("mc_tb.u_tb_if.mc_fram_debug_clk",1'b0);
    value_check("mc_tb.u_tb_if.mc_top_clk",1'b0);
    value_check("mc_tb.u_tb_if.mc_frame2frame_clk",1'b0);
    value_check("mc_tb.u_tb_if.frame_arbiter_clk",1'b0);
    value_check("mc_tb.u_tb_if.mc_timeout_clk",1'b0);
    value_check("mc_tb.u_tb_if.frame2array_clk",1'b0);
    value_check("mc_tb.u_tb_if.U0_mc_ctrl_DW_sync_clk",1'b0);
    value_check("mc_tb.u_tb_if.U1_mc_ctrl_DW_sync_clk",1'b0);
    value_check("mc_tb.u_tb_if.U2_mc_ctrl_DW_sync_clk",1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u0_clk",1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u1_clk",1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u2_clk",1'b0);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u3_clk",1'b0);

    `uvm_info(get_type_name(),"mc clk force1",UVM_LOW)
    uvm_hdl_force("mc_tb.clk",1'b1);
    #(period_sys/2)
    value_check("mc_tb.u_tb_if.clk",1'b1);
    value_check("mc_tb.u_tb_if.wrapper_clk",1'b1);
    value_check("mc_tb.u_tb_if.ecc_clk",1'b1);
    value_check("mc_tb.u_tb_if.ecc_top_clk",1'b1);
    value_check("mc_tb.u_tb_if.mc_fram_debug_clk",1'b1);
    value_check("mc_tb.u_tb_if.mc_top_clk",1'b1);
    value_check("mc_tb.u_tb_if.mc_frame2frame_clk",1'b1);
    value_check("mc_tb.u_tb_if.frame_arbiter_clk",1'b1);
    value_check("mc_tb.u_tb_if.mc_timeout_clk",1'b1);
    value_check("mc_tb.u_tb_if.frame2array_clk",1'b1);
    value_check("mc_tb.u_tb_if.U0_mc_ctrl_DW_sync_clk",1'b1);
    value_check("mc_tb.u_tb_if.U1_mc_ctrl_DW_sync_clk",1'b1);
    value_check("mc_tb.u_tb_if.U2_mc_ctrl_DW_sync_clk",1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u0_clk",1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u1_clk",1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u2_clk",1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u3_clk",1'b1);
 
    #(period_sys/2)
    value_check("mc_tb.u_tb_if.clk",1'b1);
    value_check("mc_tb.u_tb_if.wrapper_clk",1'b1);
    value_check("mc_tb.u_tb_if.ecc_clk",1'b1);
    value_check("mc_tb.u_tb_if.ecc_top_clk",1'b1);
    value_check("mc_tb.u_tb_if.mc_fram_debug_clk",1'b1);
    value_check("mc_tb.u_tb_if.mc_top_clk",1'b1);
    value_check("mc_tb.u_tb_if.mc_frame2frame_clk",1'b1);
    value_check("mc_tb.u_tb_if.frame_arbiter_clk",1'b1);
    value_check("mc_tb.u_tb_if.mc_timeout_clk",1'b1);
    value_check("mc_tb.u_tb_if.frame2array_clk",1'b1);
    value_check("mc_tb.u_tb_if.U0_mc_ctrl_DW_sync_clk",1'b1);
    value_check("mc_tb.u_tb_if.U1_mc_ctrl_DW_sync_clk",1'b1);
    value_check("mc_tb.u_tb_if.U2_mc_ctrl_DW_sync_clk",1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u0_clk",1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u1_clk",1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u2_clk",1'b1);
    value_check("mc_tb.u_tb_if.ipdb_pulse2pulse_inst_u3_clk",1'b1);
 
    uvm_hdl_release("mc_tb.clk");
    `uvm_info(get_type_name(),"mc clk release",UVM_LOW)

    `uvm_info(get_type_name(),"\n =================mc_clk_vseq body end==============", UVM_LOW)
    
endtask:body

task mc_clk_vseq::clk_period_chk(string clk_name, real period_p, real period_n, real period);

    if (`ABS(period - (period_p + period_n)) >= 2ps) 
        `uvm_error("clk period check", $sformatf("%s period is not correct, exp is %0t, act is %0t", clk_name, period, (period_p + period_n)))

    else begin
        if(`ABS(period_p - period_n)  >= 2ps)
            `uvm_error("clk period check", $sformatf("%s period duty is not 0.5, pos is %.3f, neg is %.3f",clk_name, (period_p)/period, (period_n)/period))
        else
            `uvm_info("clk period check", $sformatf("%s period check pass!",clk_name),UVM_LOW)
    end

endtask:clk_period_chk

task mc_clk_vseq::value_check(string clk_name, bit exp_value);

    bit value_read;
    uvm_hdl_read($sformatf("%s",clk_name), value_read);
    if (value_read !== exp_value)
        `uvm_error("value_check", $sformatf("%s value_check is nor correct",clk_name))

endtask:value_check
`endif

