`ifndef TRIM_CONNECT_VSEQ_SV
`define TRIM_CONNECT_VSEQ_SV

class trim_connect_vseq extends trim_common_vseq;
    
bit exp_value, act_value;

`uvm_object_utils(trim_connect_vseq)

function new(string name="trim_connect_vseq");
    super.new(name);
endfunction

virtual task body();
    super.body();
    $display("-------------Enter the trim_connect_vseq body---------------");

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_done_flag"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_done_flag")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period_active_sync"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period_active_sync")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump_active_sync"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump_active_sync")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_resetn_active_sync"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_resetn_active_sync")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_finish"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_finish")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_interrupt"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_interrupt")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_start_sync"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_start_sync")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_start_reg"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_start_reg")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n")

    if(!uvm_hdl_check_path("trim_tb.u_dram_trim_top.trim_monitor"))
        `uvm_fatal("PATH_CHECK", "Can not found signal definition for trim_tb.u_dram_trim_top.trim_monitor")

repeat(2)begin
    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_done_flag", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[0]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_done_flag is %0b, but trim_tb.u_dram_trim_top.trim_monitor[0] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_done_flag", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[0]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_done_flag to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[0] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_done_flag", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[0]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_done_flag to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[0] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_done_flag", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[0]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_done_flag to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[0] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period_active_sync", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[1]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period_active_sync is %0b, but trim_tb.u_dram_trim_top.trim_monitor[1] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period_active_sync", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[1]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period_active_sync to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[1] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period_active_sync", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[1]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period_active_sync to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[1] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period_active_sync", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[1]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period_active_sync to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[1] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump_active_sync", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[2]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump_active_sync is %0b, but trim_tb.u_dram_trim_top.trim_monitor[2] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump_active_sync", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[2]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump_active_sync to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[2] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump_active_sync", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[2]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump_active_sync to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[2] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump_active_sync", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[2]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump_active_sync to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[2] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_resetn_active_sync", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[3]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_resetn_active_sync is %0b, but trim_tb.u_dram_trim_top.trim_monitor[3] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_resetn_active_sync", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[3]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_resetn_active_sync to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[3] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_resetn_active_sync", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[3]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_resetn_active_sync to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[3] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_resetn_active_sync", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[3]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_resetn_active_sync to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[3] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[0]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[4]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[0] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[4] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[4]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[4] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[4]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[4] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[4]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[4] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[1]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[5]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[1] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[5] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[5]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[5] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[5]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[5] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[5]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[5] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[2]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[6]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[2] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[6] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[6]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[6] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[6]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[6] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[6]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[6] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[3]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[7]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[3] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[7] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[7]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[7] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[7]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[7] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[7]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_flag[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[7] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[0]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[8]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[0] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[8] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[8]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[8] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[8]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[8] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[8]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[8] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[1]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[9]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[1] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[9] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[9]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[9] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[9]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[9] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[9]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[9] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[2]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[10]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[2] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[10] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[10]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[10] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[10]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[10] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[10]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[10] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[3]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[11]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[3] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[11] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[11]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[11] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[11]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[11] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[11]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_flag[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[11] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_finish", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[12]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_finish is %0b, but trim_tb.u_dram_trim_top.trim_monitor[12] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_finish", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[12]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_finish to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[12] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_finish", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[12]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_finish to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[12] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_finish", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[12]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_finish to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[12] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_interrupt", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[13]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_interrupt is %0b, but trim_tb.u_dram_trim_top.trim_monitor[13] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_interrupt", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[13]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_interrupt to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[13] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_interrupt", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[13]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_interrupt to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[13] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_interrupt", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[13]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_interrupt to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[13] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_start_sync", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[14]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_start_sync is %0b, but trim_tb.u_dram_trim_top.trim_monitor[14] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_start_sync", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[14]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_start_sync to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[14] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_start_sync", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[14]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_start_sync to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[14] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_start_sync", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[14]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_start_sync to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[14] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[0]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[15]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[0] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[15] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[15]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[15] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[15]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[15] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[15]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[15] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[1]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[16]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[1] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[16] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[16]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[16] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[16]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[16] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[16]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[16] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[2]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[17]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[2] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[17] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[17]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[17] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[17]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[17] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[17]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[17] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[3]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[18]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[3] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[18] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[18]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[18] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[18]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[18] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[18]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[18] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[4]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[19]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[4] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[19] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[4]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[19]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[4] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[19] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[4]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[19]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[4] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[19] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[4]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[19]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.fsm_cs[4] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[19] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_start_reg", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[20]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_start_reg is %0b, but trim_tb.u_dram_trim_top.trim_monitor[20] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_start_reg", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[20]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_start_reg to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[20] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_start_reg", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[20]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_start_reg to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[20] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_start_reg", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[20]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.trim_start_reg to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[20] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[259]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[21]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[259] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[21] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[259]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[21]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[259] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[21] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[259]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[21]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[259] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[21] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[259]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[21]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[259] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[21] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[260]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[22]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[260] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[22] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[260]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[22]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[260] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[22] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[260]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[22]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[260] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[22] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[260]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[22]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[260] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[22] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[239]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[23]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[239] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[23] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[239]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[23]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[239] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[23] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[239]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[23]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[239] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[23] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[239]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[23]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[239] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[23] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[240]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[24]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[240] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[24] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[240]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[24]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[240] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[24] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[240]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[24]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[240] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[24] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[240]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[24]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[240] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[24] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[241]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[25]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[241] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[25] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[241]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[25]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[241] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[25] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[241]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[25]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[241] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[25] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[241]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[25]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[241] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[25] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[242]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[26]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[242] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[26] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[242]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[26]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[242] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[26] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[242]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[26]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[242] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[26] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[242]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[26]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[242] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[26] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[243]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[27]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[243] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[27] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[243]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[27]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[243] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[27] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[243]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[27]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[243] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[27] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[243]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[27]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[243] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[27] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[244]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[28]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[244] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[28] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[244]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[28]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[244] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[28] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[244]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[28]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[244] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[28] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[244]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[28]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[244] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[28] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[245]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[29]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[245] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[29] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[245]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[29]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[245] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[29] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[245]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[29]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[245] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[29] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[245]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[29]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[245] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[29] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[246]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[30]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[246] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[30] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[246]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[30]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[246] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[30] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[246]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[30]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[246] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[30] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[246]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[30]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[246] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[30] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[247]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[31]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[247] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[31] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[247]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[31]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[247] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[31] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[247]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[31]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[247] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[31] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[247]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[31]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tsv_tm[247] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[31] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[0]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[32]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[0] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[32] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[32]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[32] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[32]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[32] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[32]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[32] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[1]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[33]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[1] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[33] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[33]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[33] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[33]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[33] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[33]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[33] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[2]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[34]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[2] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[34] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[34]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[34] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[34]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[34] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[34]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[34] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[3]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[35]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[3] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[35] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[35]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[35] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[35]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[35] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[35]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[35] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[4]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[36]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[4] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[36] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[4]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[36]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[4] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[36] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[4]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[36]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[4] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[36] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[4]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[36]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[4] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[36] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[5]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[37]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[5] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[37] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[5]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[37]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[5] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[37] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[5]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[37]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[5] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[37] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[5]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[37]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[5] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[37] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[6]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[38]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[6] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[38] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[6]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[38]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[6] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[38] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[6]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[38]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[6] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[38] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[6]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[38]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[6] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[38] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[7]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[39]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[7] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[39] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[7]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[39]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[7] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[39] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[7]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[39]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[7] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[39] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[7]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[39]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.osc_tm_res[7] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[39] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[0]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[40]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[0] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[40] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[40]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[40] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[40]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[40] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[40]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[40] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[1]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[41]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[1] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[41] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[41]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[41] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[41]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[41] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[41]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[41] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[2]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[42]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[2] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[42] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[42]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[42] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[42]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[42] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[42]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[42] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[3]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[43]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[3] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[43] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[43]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[43] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[43]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[43] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[43]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_ringo[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[43] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[0]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[44]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[0] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[44] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[44]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[44] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[44]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[44] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[44]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[44] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[1]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[45]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[1] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[45] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[45]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[45] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[45]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[45] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[45]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[45] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[2]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[46]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[2] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[46] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[46]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[46] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[46]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[46] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[46]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[46] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[3]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[47]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[3] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[47] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[47]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[47] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[47]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[47] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[47]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dump_ready[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[47] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[0]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[48]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[0] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[48] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[48]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[48] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[48]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[48] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[48]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[48] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[1]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[49]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[1] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[49] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[49]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[49] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[49]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[49] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[49]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[49] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[2]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[50]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[2] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[50] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[50]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[50] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[50]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[50] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[50]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[50] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[3]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[51]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[3] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[51] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[51]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[51] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[51]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[51] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[51]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.stopwatch_period[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[51] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[0]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[52]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[0] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[52] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[52]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[52] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[52]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[52] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[52]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[52] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[1]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[53]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[1] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[53] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[53]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[53] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[53]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[53] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[53]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[53] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[2]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[54]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[2] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[54] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[54]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[54] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[54]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[54] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[54]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[54] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[3]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[55]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[3] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[55] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[55]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[55] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[55]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[55] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[55]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.tm_redump[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[55] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[0]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[56]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[0] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[56] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[56]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[56] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[56]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[56] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[0]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[56]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[0] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[56] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[1]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[57]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[1] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[57] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[57]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[57] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[57]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[57] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[1]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[57]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[1] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[57] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[2]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[58]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[2] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[58] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[58]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[58] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[58]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[58] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[2]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[58]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[2] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[58] is %0b", exp_value, act_value))
    end

    #1ps;
    uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[3]", act_value);
    uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[59]", exp_value);
    if(exp_value !== act_value)
        `uvm_error("BIT_CHECK", $sformatf("Found trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[3] is %0b, but trim_tb.u_dram_trim_top.trim_monitor[59] is %0b", act_value, exp_value))
    if((exp_value !== 1'bx)&&(exp_value !== 1'bz)) begin
        exp_value = ~act_value;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[59]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[59] is %0b", exp_value, act_value))
    end
    else begin
        exp_value = 1'b0;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[59]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[59] is %0b", exp_value, act_value))
        #1ps;
        exp_value = 1'b1;
        uvm_hdl_force("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[3]", exp_value);
        #1ps;
        uvm_hdl_read("trim_tb.u_dram_trim_top.trim_monitor[59]", act_value);
        if(exp_value != act_value)
            `uvm_error("BIT_CHECK", $sformatf("Forced trim_tb.u_dram_trim_top.dram_trim_ctrl_u.spine_reset_n[3] to %0b, but actual read value from trim_tb.u_dram_trim_top.trim_monitor[59] is %0b", exp_value, act_value))
    end
end

    #10ns;

    `uvm_info(get_type_name(), $sformatf("-------------trim_connect_vseq finish---------------"), UVM_LOW)
      
endtask: body
endclass


`endif //TRIM_CONNECT_VSEQ_SV

