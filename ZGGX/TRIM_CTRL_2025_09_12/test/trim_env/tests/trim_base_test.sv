
`ifndef TRIM_BASE_TEST_SV
`define TRIM_BASE_TEST_SV


class trim_base_test extends uvm_test;
    `uvm_component_utils(trim_base_test)

    trim_env            m_env;
    trim_env_config     m_env_config;
    trim_vseqr          vseqr;

    ral_sys_dram_trim   regmodel;

    virtual trim_if     m_trim_if;
    virtual svt_apb_if  m_apb_if;

    extern function new(string name, uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
    extern task          reset_phase(uvm_phase phase);
    extern task          reset_check();
    extern task          init();

endclass : trim_base_test

function trim_base_test::new(string name, uvm_component parent=null);
    super.new(name, parent);
endfunction : new

function void trim_base_test::build_phase(uvm_phase phase);
    //usr_report_server   server;
    //super.build_phase(phase);
    //server = new();
    //usr_report_server::set_server(server);

    m_env        = trim_env::type_id::create("m_env", this);
    m_env_config = trim_env_config::type_id::create("m_env_config", this);
    void'(m_env_config.randomize());

    uvm_config_db#(trim_env_config)::set(this, "*", "m_env_config", m_env_config);

    vseqr = trim_vseqr::type_id::create("vseqr",this);

    if(!uvm_config_db#(virtual trim_if)::get(null,get_full_name(),"trim_vif",m_trim_if))
        `uvm_fatal(get_type_name(), $sformatf("virtual interface must be set for trim_vif!!!"))
        
    if(!uvm_config_db#(virtual svt_apb_if)::get(null,get_full_name(),"apb_vif",m_apb_if))
        `uvm_fatal(get_type_name(), $sformatf("virtual interface must be set for apb_vif!!!"))

endfunction : build_phase

function void trim_base_test::connect_phase(uvm_phase phase);

    //add vseqr to env.agent.sequenver
    vseqr.p_svt_apb_sqr = m_env.m_svt_apb_env.sequencer;
    vseqr.p_svt_apb_master_sqr = m_env.m_svt_apb_env.master.sequencer;
    this.regmodel = m_env.regmodel;

    vseqr.regmodel = m_env.regmodel;


endfunction : connect_phase


task trim_base_test::reset_phase(uvm_phase phase);
    phase.raise_objection(this);
        m_trim_if.trim_start        = 'h0;
        m_trim_if.trim_res          = 'h0;
        m_trim_if.dump_ready        = 'h0;
        m_trim_if.stopwatch_ringo   = 'h0;
        m_trim_if.osc_tm_res        = 'h0;

        m_trim_if.spine_reset_flag  = 'h0;
        m_trim_if.init_done_flag    = 'h0;

        m_trim_if.init_sp_rst_low_cnt_0 = 'h0;
        m_trim_if.init_sp_rst_low_cnt_1 = 'h0;
        m_trim_if.init_sp_rst_low_cnt_2 = 'h0;
        m_trim_if.init_sp_rst_low_cnt_3 = 'h0;
        m_trim_if.dp_rd_set_cnt_0       = 'h0;   //for dump_r
        m_trim_if.dp_rd_set_cnt_1       = 'h0;   //for dump_r
        m_trim_if.dp_rd_set_cnt_2       = 'h0;   //for dump_r
        m_trim_if.dp_rd_set_cnt_3       = 'h0;   //for dump_r
                                       
        m_trim_if.sp_rst_low_cnt0       = 'h0;
        m_trim_if.sp_rst_low_cnt1       = 'h0;
        m_trim_if.sp_rst_low_cnt2       = 'h0;
        m_trim_if.sp_rst_low_cnt3       = 'h0;
        m_trim_if.sp_rst_dp_rdy_cnt0    = 'h0;
        m_trim_if.sp_rst_dp_rdy_cnt1    = 'h0;
        m_trim_if.sp_rst_dp_rdy_cnt2    = 'h0;
        m_trim_if.sp_rst_dp_rdy_cnt3    = 'h0;
                                       
        m_trim_if.tm_redump_cnt0        = 'h0;
        m_trim_if.tm_redump_cnt1        = 'h0;
        m_trim_if.tm_redump_cnt2        = 'h0;
        m_trim_if.tm_redump_cnt3        = 'h0;
                                       
        m_trim_if.ringo_cnt0            = 'h0;
        m_trim_if.ringo_cnt1            = 'h0;
        m_trim_if.ringo_cnt2            = 'h0;
        m_trim_if.ringo_cnt3            = 'h0;
        m_trim_if.ringo_wait_cnt0       = 'h0;
        m_trim_if.ringo_wait_cnt1       = 'h0;
        m_trim_if.ringo_wait_cnt2       = 'h0;
        m_trim_if.ringo_wait_cnt3       = 'h0;
        m_trim_if.ringo_period_cnt0     = 'h0;
        m_trim_if.ringo_period_cnt1     = 'h0;
        m_trim_if.ringo_period_cnt2     = 'h0;
        m_trim_if.ringo_period_cnt3     = 'h0;
        m_trim_if.ringo_period_cnt0_save_q.delete();
        m_trim_if.ringo_period_cnt1_save_q.delete();
        m_trim_if.ringo_period_cnt2_save_q.delete();
        m_trim_if.ringo_period_cnt3_save_q.delete();
                                       
        m_trim_if.res_cnt0              = 'h0;
        m_trim_if.res_cnt1              = 'h0;
        m_trim_if.res_cnt2              = 'h0;
        m_trim_if.res_cnt3              = 'h0;
        m_trim_if.res_wait_cnt0         = 'h0;
        m_trim_if.res_wait_cnt1         = 'h0;
        m_trim_if.res_wait_cnt2         = 'h0;
        m_trim_if.res_wait_cnt3         = 'h0;
                                       
        m_trim_if.ringo_meas_flag       = 'h0;
        m_trim_if.re_act_sp_rst_force_dp_flag   = 'h0;
                                       
        m_trim_if.hw_init_sp_rst_cnt0   = 'h0;
        m_trim_if.hw_init_sp_rst_cnt1   = 'h0;
        m_trim_if.hw_init_sp_rst_cnt2   = 'h0;
        m_trim_if.hw_init_sp_rst_cnt3   = 'h0;
                                       
        m_trim_if.dp_rdy_cnt0           = 'h0;
        m_trim_if.dp_rdy_cnt1           = 'h0;
        m_trim_if.dp_rdy_cnt2           = 'h0;
        m_trim_if.dp_rdy_cnt3           = 'h0;
                                       
        m_trim_if.stpwh_prd_res_flag    = 'h0;

        m_trim_if.cfg_tsv_tm            = 'h0;
        m_trim_if.ringo_mode_q.delete();

        m_trim_if.dmp_rdy_timeout_cnt0  = 'h0;      
        m_trim_if.dmp_rdy_timeout_cnt1  = 'h0;
        m_trim_if.dmp_rdy_timeout_cnt2  = 'h0;
        m_trim_if.dmp_rdy_timeout_cnt3  = 'h0;
        m_trim_if.ringo_timeout_cnt0    = 'h0;
        m_trim_if.ringo_timeout_cnt1    = 'h0;
        m_trim_if.ringo_timeout_cnt2    = 'h0;
        m_trim_if.ringo_timeout_cnt3    = 'h0;

        m_trim_if.redp_dp_rdy_cnt0      = 'h0;
        m_trim_if.redp_dp_rdy_cnt1      = 'h0;
        m_trim_if.redp_dp_rdy_cnt2      = 'h0;
        m_trim_if.redp_dp_rdy_cnt3      = 'h0;

        m_trim_if.tsv_tm_setup0         = 'h0;
        m_trim_if.tsv_tm_setup1         = 'h0;
        m_trim_if.tsv_tm_setup2         = 'h0;
        m_trim_if.tsv_tm_setup3         = 'h0;
        m_trim_if.tsv_tm_current0       = 'h0;
        m_trim_if.tsv_tm_current1       = 'h0;
        m_trim_if.tsv_tm_current2       = 'h0;
        m_trim_if.tsv_tm_current3       = 'h0;
        m_trim_if.tsv_tm_hold0          = 'h0;
        m_trim_if.tsv_tm_hold1          = 'h0;
        m_trim_if.tsv_tm_hold2          = 'h0;
        m_trim_if.tsv_tm_hold3          = 'h0;
        m_trim_if.sp_rst_cnt0           = 'h0;
        m_trim_if.sp_rst_cnt1           = 'h0;
        m_trim_if.sp_rst_cnt2           = 'h0;
        m_trim_if.sp_rst_cnt3           = 'h0;
        m_trim_if.tm_redump_h_cnt0      = 'h0;
        m_trim_if.tm_redump_h_cnt1      = 'h0;
        m_trim_if.tm_redump_h_cnt2      = 'h0;
        m_trim_if.tm_redump_h_cnt3      = 'h0;
        m_trim_if.sp_rst_l_cnt0         = 'h0;
        m_trim_if.sp_rst_l_cnt1         = 'h0;
        m_trim_if.sp_rst_l_cnt2         = 'h0;
        m_trim_if.sp_rst_l_cnt3         = 'h0;

    phase.drop_objection(this);
endtask: reset_phase


task trim_base_test::main_phase(uvm_phase phase);
    super.main_phase(phase);
    phase.raise_objection(this);

    phase.drop_objection(this);
endtask : main_phase

task trim_base_test::reset_check();
    if(m_trim_if.trim_finish != 0 || m_trim_if.trim_interrupt != 0 || m_trim_if.spine_reset_n != 0 || 
       m_trim_if.tm_redump != 0 || m_trim_if.stopwatch_period != 0 || m_trim_if.tsv_tm != 0)begin
        `uvm_error("trim_base_test", $sformatf("----------sys reset signals check failed----------"))
    end
    else begin
        `uvm_info("trim_base_test", $sformatf("--------sys reset signals check successful--------"), UVM_LOW)
    end

    if(m_apb_if.prdata[0] != 'h0)begin
        `uvm_error("trim_base_test", $sformatf("----------apb reset signals check failed, prdata[0] = %0h-----------", m_apb_if.prdata[0]))
    end
    else begin
        `uvm_info("trim_base_test", $sformatf("----------apb reset signals check successful-----------"), UVM_LOW)
    end
endtask

task trim_base_test::init();
        m_trim_if.trim_start        = 'h0;
        m_trim_if.trim_res          = 'h0;
        m_trim_if.dump_ready        = 'h0;
        m_trim_if.stopwatch_ringo   = 'h0;
        m_trim_if.osc_tm_res        = 'h0;

        m_trim_if.spine_reset_flag  = 'h0;
        m_trim_if.init_done_flag    = 'h0;

        m_trim_if.init_sp_rst_low_cnt_0 = 'h0;
        m_trim_if.init_sp_rst_low_cnt_1 = 'h0;
        m_trim_if.init_sp_rst_low_cnt_2 = 'h0;
        m_trim_if.init_sp_rst_low_cnt_3 = 'h0;
        m_trim_if.dp_rd_set_cnt_0       = 'h0;   //for dump_r
        m_trim_if.dp_rd_set_cnt_1       = 'h0;   //for dump_r
        m_trim_if.dp_rd_set_cnt_2       = 'h0;   //for dump_r
        m_trim_if.dp_rd_set_cnt_3       = 'h0;   //for dump_r
                                       
        m_trim_if.sp_rst_low_cnt0       = 'h0;
        m_trim_if.sp_rst_low_cnt1       = 'h0;
        m_trim_if.sp_rst_low_cnt2       = 'h0;
        m_trim_if.sp_rst_low_cnt3       = 'h0;
        m_trim_if.sp_rst_dp_rdy_cnt0    = 'h0;
        m_trim_if.sp_rst_dp_rdy_cnt1    = 'h0;
        m_trim_if.sp_rst_dp_rdy_cnt2    = 'h0;
        m_trim_if.sp_rst_dp_rdy_cnt3    = 'h0;
                                       
        m_trim_if.tm_redump_cnt0        = 'h0;
        m_trim_if.tm_redump_cnt1        = 'h0;
        m_trim_if.tm_redump_cnt2        = 'h0;
        m_trim_if.tm_redump_cnt3        = 'h0;
                                       
        m_trim_if.ringo_cnt0            = 'h0;
        m_trim_if.ringo_cnt1            = 'h0;
        m_trim_if.ringo_cnt2            = 'h0;
        m_trim_if.ringo_cnt3            = 'h0;
        m_trim_if.ringo_wait_cnt0       = 'h0;
        m_trim_if.ringo_wait_cnt1       = 'h0;
        m_trim_if.ringo_wait_cnt2       = 'h0;
        m_trim_if.ringo_wait_cnt3       = 'h0;
        m_trim_if.ringo_period_cnt0     = 'h0;
        m_trim_if.ringo_period_cnt1     = 'h0;
        m_trim_if.ringo_period_cnt2     = 'h0;
        m_trim_if.ringo_period_cnt3     = 'h0;
        m_trim_if.ringo_period_cnt0_save_q.delete();
        m_trim_if.ringo_period_cnt1_save_q.delete();
        m_trim_if.ringo_period_cnt2_save_q.delete();
        m_trim_if.ringo_period_cnt3_save_q.delete();
                                       
        m_trim_if.res_cnt0              = 'h0;
        m_trim_if.res_cnt1              = 'h0;
        m_trim_if.res_cnt2              = 'h0;
        m_trim_if.res_cnt3              = 'h0;
        m_trim_if.res_wait_cnt0         = 'h0;
        m_trim_if.res_wait_cnt1         = 'h0;
        m_trim_if.res_wait_cnt2         = 'h0;
        m_trim_if.res_wait_cnt3         = 'h0;
                                       
        m_trim_if.ringo_meas_flag       = 'h0;
        m_trim_if.re_act_sp_rst_force_dp_flag   = 'h0;
                                       
        m_trim_if.hw_init_sp_rst_cnt0   = 'h0;
        m_trim_if.hw_init_sp_rst_cnt1   = 'h0;
        m_trim_if.hw_init_sp_rst_cnt2   = 'h0;
        m_trim_if.hw_init_sp_rst_cnt3   = 'h0;
                                       
        m_trim_if.dp_rdy_cnt0           = 'h0;
        m_trim_if.dp_rdy_cnt1           = 'h0;
        m_trim_if.dp_rdy_cnt2           = 'h0;
        m_trim_if.dp_rdy_cnt3           = 'h0;
                                       
        m_trim_if.stpwh_prd_res_flag    = 'h0;

        m_trim_if.cfg_tsv_tm            = 'h0;
        m_trim_if.ringo_mode_q.delete();

        m_trim_if.dmp_rdy_timeout_cnt0  = 'h0;      
        m_trim_if.dmp_rdy_timeout_cnt1  = 'h0;
        m_trim_if.dmp_rdy_timeout_cnt2  = 'h0;
        m_trim_if.dmp_rdy_timeout_cnt3  = 'h0;
        m_trim_if.ringo_timeout_cnt0    = 'h0;
        m_trim_if.ringo_timeout_cnt1    = 'h0;
        m_trim_if.ringo_timeout_cnt2    = 'h0;
        m_trim_if.ringo_timeout_cnt3    = 'h0;

        m_trim_if.redp_dp_rdy_cnt0      = 'h0;
        m_trim_if.redp_dp_rdy_cnt1      = 'h0;
        m_trim_if.redp_dp_rdy_cnt2      = 'h0;
        m_trim_if.redp_dp_rdy_cnt3      = 'h0;

        m_trim_if.tsv_tm_setup0         = 'h0;
        m_trim_if.tsv_tm_setup1         = 'h0;
        m_trim_if.tsv_tm_setup2         = 'h0;
        m_trim_if.tsv_tm_setup3         = 'h0;
        m_trim_if.tsv_tm_current0       = 'h0;
        m_trim_if.tsv_tm_current1       = 'h0;
        m_trim_if.tsv_tm_current2       = 'h0;
        m_trim_if.tsv_tm_current3       = 'h0;
        m_trim_if.tsv_tm_hold0          = 'h0;
        m_trim_if.tsv_tm_hold1          = 'h0;
        m_trim_if.tsv_tm_hold2          = 'h0;
        m_trim_if.tsv_tm_hold3          = 'h0;
        m_trim_if.sp_rst_cnt0           = 'h0;
        m_trim_if.sp_rst_cnt1           = 'h0;
        m_trim_if.sp_rst_cnt2           = 'h0;
        m_trim_if.sp_rst_cnt3           = 'h0;
        m_trim_if.tm_redump_h_cnt0      = 'h0;
        m_trim_if.tm_redump_h_cnt1      = 'h0;
        m_trim_if.tm_redump_h_cnt2      = 'h0;
        m_trim_if.tm_redump_h_cnt3      = 'h0;
        m_trim_if.sp_rst_l_cnt0         = 'h0;
        m_trim_if.sp_rst_l_cnt1         = 'h0;
        m_trim_if.sp_rst_l_cnt2         = 'h0;
        m_trim_if.sp_rst_l_cnt3         = 'h0;
endtask: init


function void trim_base_test::report_phase(uvm_phase phase);
    uvm_report_server server;
    int err_num;
    super.report_phase(phase);
    server = get_report_server();
    err_num = server.get_severity_count(UVM_ERROR);

    if(err_num != 0)begin
        //0716//$display("TEST CASE FAILED!");
        $display("///////////////////////");
        $display("//                   //");
        $display("// TEST CASE FAILED! //");
        $display("//                   //");
        $display("//       v   v       //");
        $display("//         ^         //");
        $display("//                   //");
        $display("///////////////////////");
    end
    else begin
        //0716//$display("TEST CASE PASSED!");
        $display("///////////////////////");
        $display("//                   //");
        $display("// TEST CASE PASSED! //");
        $display("//                   //");
        $display("//       ^   ^       //");
        $display("//         v         //");
        $display("//                   //");
        $display("///////////////////////");
    end
endfunction
`endif // TRIM_BASE_TEST_SV
