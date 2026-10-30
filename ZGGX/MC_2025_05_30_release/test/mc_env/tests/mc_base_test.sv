//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_base_test.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_BASE_TEST_SV
`define MC_BASE_TEST_SV

class usr_report_server extends uvm_default_report_server;
    virtual function string compose_report_message(uvm_report_message report_message,string report_object_name="");
    
    uvm_severity severity = report_message.get_severity;
    string       name     = report_message.get_report_object().get_full_name;
    string       id       = report_message.get_id();
    string       message  = report_message.get_message();
    string       filename = report_message.get_filename();
    int          line     = report_message.get_line();
    
    $timeformat(-9, 3, " ns", 10);
    return $sformatf(">>>>>> %0s $ %0s $ %0d $ $realtime : %0t $ %0s $ %0s $ %0s <<<<<<",severity.name(),filename,line,$realtime,name,id,message);
    endfunction
endclass

class mc_base_test extends uvm_test;
    `uvm_component_utils(mc_base_test)

    mc_env           m_env;
    mc_env_config    m_env_config;
    frame_agent_config  m_frame_agent_config; 

    array_agent_config  m_array_agent_config; 

    mc_vseqr    vseqr;

    //ral_block_mc_regmodel regmodel;
    ral_sys_mc_wrapper          mc_soc_regmodel;
    
    
    extern function new(string name, uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
    extern task          reset_phase(uvm_phase phase);      

endclass : mc_base_test

function mc_base_test::new(string name, uvm_component parent=null);
    super.new(name, parent);
endfunction : new

task mc_base_test::reset_phase(uvm_phase phase);
    super.reset_phase(phase); 

    `uvm_info("mc_vseqr", "apb_sys_env_stop_sequences!!!", UVM_LOW);
endtask : reset_phase



function void mc_base_test::build_phase(uvm_phase phase);
    //usr_report_server usr_svr;
    super.build_phase(phase); 
    //usr_svr =new();
    //usr_report_server::set_server(usr_svr);

    m_env        = mc_env::type_id::create("m_env", this);
    m_env_config = mc_env_config::type_id::create("m_env_config", this);
    m_frame_agent_config = frame_agent_config::type_id::create("m_frame_agent_config", this);

    m_array_agent_config = array_agent_config::type_id::create("m_array_agent_config", this);

    void'(m_env_config.randomize());

    uvm_config_db#(mc_env_config)::set(this, "*", "m_env_config", m_env_config);

    void'(m_frame_agent_config.randomize());

    uvm_config_db#(frame_agent_config)::set(this, "m_env.*", "m_frame_agent_config", m_frame_agent_config);

    void'(m_array_agent_config.randomize());

    uvm_config_db#(array_agent_config)::set(this, "m_env.*", "m_array_agent_config", m_array_agent_config);

    vseqr = mc_vseqr::type_id::create("vseqr",this);
endfunction : build_phase

function void mc_base_test::connect_phase(uvm_phase phase);

    //add vseqr to env.agent.sequenver
    `uvm_info(get_full_name(),"connect_phase running",UVM_LOW);
    
    foreach(vseqr.p_svt_apb_master_sqr[II]) begin
        vseqr.p_svt_apb_sqr[II]         =   m_env.m_svt_apb_env[II].sequencer;
        vseqr.p_svt_apb_master_sqr[II]  =   m_env.m_svt_apb_env[II].master.sequencer;
    end
    //vseqr.p_svt_apb_master_sqr = m_env.m_svt_apb_env.master.sequencer;
    vseqr.p_frame_agent_sqr =   m_env.m_frame_agent.m_sequencer;
    vseqr.mc_soc_regmodel   =   m_env.mc_soc_regmodel   ;
    this.mc_soc_regmodel    =   m_env.mc_soc_regmodel   ;

    //this.regmodel = m_env.regmodel;
    //vseqr.regmodel = m_env.regmodel;
    
    `uvm_info(get_full_name(),"connect_phase end",UVM_LOW);
    
endfunction : connect_phase

task mc_base_test::main_phase(uvm_phase phase);

endtask : main_phase

function void mc_base_test::report_phase(uvm_phase phase);
    uvm_report_server server;
    int err_num;
    super.report_phase(phase);
    //server = get_report_server();
    server = uvm_report_server::get_server();
    err_num = server.get_severity_count(UVM_ERROR);

    if(err_num != 0)begin
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
`endif // MC_BASE_TEST_SV
