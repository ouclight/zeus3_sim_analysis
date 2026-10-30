//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_env.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_ENV_SV
`define MC_ENV_SV

class mc_env extends uvm_env;

    `uvm_component_utils(mc_env)
    uvm_verbosity                            m_en_vip_verbosity=UVM_NONE;
    mc_refm m_refm;
    mc_scb  m_scb;
    mc_vseqr    vseqr;
    mc_env_config  m_env_config;
    svt_apb_system_env m_svt_apb_env[];

    frame_agent m_frame_agent;
    frame_agent_config m_frame_agent_config;

    array_agent m_array_agent;
    //array_agent_config m_array_agent_config;

    //ral_block_mc_regmodel regmodel;
    ral_sys_mc_wrapper          mc_soc_regmodel;
    uvm_tlm_analysis_fifo #(frame_agent_trans)  m_frm_scb_fifo_w;
    uvm_tlm_analysis_fifo #(frame_agent_trans)  m_frm_scb_fifo_r;
    uvm_tlm_analysis_fifo #(array_agent_trans)  m_ary_scb_fifo;
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass : mc_env 

function mc_env::new(string name, uvm_component parent);

    super.new(name, parent);
    m_svt_apb_env = new[1];
endfunction : new

function void mc_env::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "In build_phase", UVM_HIGH)

    if (!uvm_config_db #(mc_env_config)::get(this, "", "m_env_config", m_env_config)) 
      `uvm_error(get_type_name(), "Unable to get mc_env_config")


    vseqr   =  mc_vseqr::type_id::create("vseqr",this);
    

    foreach(m_svt_apb_env[II])begin
        uvm_config_db#(svt_apb_system_configuration)::set(this, $sformatf("m_svt_apb_env[%0d]",II), "cfg", m_env_config.m_svt_apb_env_cfg);        
        m_svt_apb_env[II]  = svt_apb_system_env::type_id::create($sformatf("m_svt_apb_env[%0d]",II), this);
        m_svt_apb_env[II].set_report_verbosity_level_hier(m_en_vip_verbosity);
    end

    m_frame_agent  = frame_agent::type_id::create("m_frame_agent", this);
    uvm_config_db#(frame_agent_config)::set(this, "*", "frame_agent_config", m_frame_agent_config);

    m_array_agent  = array_agent::type_id::create("m_array_agent", this);
    //uvm_config_db#(array_agent_config)::set(this, "*", "array_agent_config", m_array_agent_config);
    m_array_agent.is_active    = UVM_PASSIVE;

    m_refm = mc_refm::type_id::create("m_refm",this);
    if(m_env_config.scb_en == 1)
    begin
        m_scb = mc_scb::type_id::create("m_scb",this);
    end
    
    //*** Enable UVVM APB Ral Adapter **
    m_env_config.m_svt_apb_env_cfg.uvm_reg_enable = 1;

    //if(!uvm_config_db#(ral_block_mc_regmodel)::get(this,"","regmodel",regmodel))
    //    begin
    //        `uvm_info("GETRGM","No top-down RGM handle is assigned",UVM_LOW)
    //        `uvm_info("NEWRGM","Created RGM instance locally",UVM_LOW)
    //    end
    
    uvm_reg::include_coverage("*",UVM_CVR_ALL); 
    mc_soc_regmodel = ral_sys_mc_wrapper::type_id::create("mc_soc_regmodel",this);
    mc_soc_regmodel.configure(null,"");
    mc_soc_regmodel.build();
    mc_soc_regmodel.lock_model();
    mc_soc_regmodel.reset();
    uvm_config_db#(uvm_reg_block)::set(this,$sformatf("m_svt_apb_env[%0d].master",0),"apb_regmodel",mc_soc_regmodel);
    

    
    m_frm_scb_fifo_w = new("m_frm_scb_fifo_w",this);
    m_frm_scb_fifo_r = new("m_frm_scb_fifo_r",this);
    m_ary_scb_fifo   = new("m_ary_scb_fifo",this);
    //m_agt_ref_fifo = new("m_agt_ref_fifo",this);
    //m_agt_scb_fifo = new("m_agt_scb_fifo",this);
    //m_ref_scb_fifo = new("m_ref_scb_fifo",this);
endfunction : build_phase

function void mc_env::connect_phase(uvm_phase phase);

    `uvm_info(get_full_name(),"connect_phase running",UVM_LOW);
    m_frame_agent.ap_w.connect(m_frm_scb_fifo_w.analysis_export);
    m_frame_agent.ap_r.connect(m_frm_scb_fifo_r.analysis_export);
    m_scb.frm_act_port_w.connect(m_frm_scb_fifo_w.blocking_get_export);
    m_scb.frm_act_port_r.connect(m_frm_scb_fifo_r.blocking_get_export);

    m_array_agent.ap.connect(m_ary_scb_fifo.analysis_export);
    m_scb.array_act_port.connect(m_ary_scb_fifo.blocking_get_export);
    //m_scb.regmodel = this.regmodel;
    //m_frame_agent_agent.ap.connect(m_agt_ref_fifo.analysis_export);
    //m_refm.port.connect(m_agt_ref_fifo.blocking_get_export);
    //m_refm.ap.connect(m_ref_scb_fifo.analysis_export);
    //m_scb.exp_port.connect(m_ref_scb_fifo.blocking_get_export);
    //m_out_agent.ap.connect(m_agt_scb_fifo.analysis_export);
    //m_scb.act_port.connect(m_agt_scb_fifo.blocking_get_export);

endfunction : connect_phase

`endif // MC_ENV_SV


