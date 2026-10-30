`ifndef TRIM_ENV_SV
`define TRIM_ENV_SV

class trim_env extends uvm_env;

    `uvm_component_utils(trim_env)
    uvm_verbosity                            m_en_vip_verbosity=UVM_NONE;

    trim_refm m_refm;
    trim_scb  m_scb;
    trim_env_config  m_env_config;
    svt_apb_system_env m_svt_apb_env;

    ral_sys_dram_trim regmodel;
    //uvm_tlm_analysis_fifo #(in_trans)   m_agt_ref_fifo;
    //uvm_tlm_analysis_fifo #(out_trans)  m_agt_scb_fifo;
    //uvm_tlm_analysis_fifo #(out_trans)  m_ref_scb_fifo;
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass : trim_env 

function trim_env::new(string name, uvm_component parent);

    super.new(name, parent);

endfunction : new

function void trim_env::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "In build_phase", UVM_HIGH)

    if (!uvm_config_db #(trim_env_config)::get(this, "", "m_env_config", m_env_config)) 
      `uvm_error(get_type_name(), "Unable to get trim_env_config")

    uvm_config_db#(svt_apb_system_configuration)::set(this, "m_svt_apb_env", "cfg", m_env_config.m_svt_apb_env_cfg);
    m_svt_apb_env  = svt_apb_system_env::type_id::create("m_svt_apb_env", this);
    m_svt_apb_env.set_report_verbosity_level_hier(m_en_vip_verbosity);


    m_refm = trim_refm::type_id::create("m_refm",this);
    if(m_env_config.scb_en == 1)
    begin
        m_scb = trim_scb::type_id::create("m_scb",this);
    end

    m_env_config.m_svt_apb_env_cfg.uvm_reg_enable = 1;
    if(!uvm_config_db#(ral_sys_dram_trim)::get(this,"","regmodel",regmodel))
        begin
            `uvm_info("GETRGM","No top-down RGM handle is assigned",UVM_LOW)
            regmodel = ral_sys_dram_trim::type_id::create("regmodel",this);
            //0716//uvm_config_db#(ral_sys_dram_trim)::set(this,"*","regmodel",regmodel);
            uvm_config_db#(uvm_reg_block)::set(this,"m_svt_apb_env.master","apb_regmodel",regmodel);
            `uvm_info("NEWRGM","Created RGM instance locally",UVM_LOW)
        end
    regmodel.configure(null,"");
    regmodel.build();
    regmodel.lock_model();
    regmodel.reset();
    //m_agt_ref_fifo = new("m_agt_ref_fifo",this);
    //m_agt_scb_fifo = new("m_agt_scb_fifo",this);
    //m_ref_scb_fifo = new("m_ref_scb_fifo",this);
endfunction : build_phase

function void trim_env::connect_phase(uvm_phase phase);

    `uvm_info(get_type_name(), "In connect_phase", UVM_HIGH)

    //m_scb.regmodel = this.regmodel;
    //m_refm.port.connect(m_agt_ref_fifo.blocking_get_export);
    //m_refm.ap.connect(m_ref_scb_fifo.analysis_export);
    //m_scb.exp_port.connect(m_ref_scb_fifo.blocking_get_export);
    //m_scb.act_port.connect(m_agt_scb_fifo.blocking_get_export);
endfunction : connect_phase

`endif // TRIM_ENV_SV


