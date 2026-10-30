
`ifndef MC_ENV_CONFIG_SV
`define MC_ENV_CONFIG_SV
`define APB_SLAVE_NUM  1

class mc_env_config extends uvm_object;
    `uvm_object_utils(mc_env_config)

    svt_apb_system_configuration m_svt_apb_env_cfg;
    frame_agent_config m_frame_agent_config;
    array_agent_config m_array_agent_config;
    
    bit scb_en = 1;

    extern function new(string name = "mc_env_config");
    

virtual function bit is_valid(bit silent = 1, int kind = -1);
  is_valid = 1;

  if (!this.is_valid()) begin
    if (!silent) begin
      `uvm_info("is_valid", $sformatf("Invalid Master configuration. Contents:\n%s", this.sprint()), UVM_HIGH)
    end
    is_valid = 0;
 end
endfunction

endclass : mc_env_config 

function mc_env_config::new(string name = "mc_env_config");
    super.new(name);
    
    m_svt_apb_env_cfg = new("m_svt_apb_env_cfg");
    m_frame_agent_config = new("m_frame_agent_config");
    m_array_agent_config = new("m_array_agent_config");
    
    
    m_svt_apb_env_cfg.create_sub_cfgs(`APB_SLAVE_NUM);
    m_svt_apb_env_cfg.is_active = 1;
    m_svt_apb_env_cfg.apb3_enable = 1;
    m_svt_apb_env_cfg.apb4_enable = 0;
    m_svt_apb_env_cfg.paddr_width = svt_apb_system_configuration::PADDR_WIDTH_32;
    m_svt_apb_env_cfg.pdata_width = svt_apb_system_configuration::PDATA_WIDTH_32;
    m_svt_apb_env_cfg.enable_xml_gen = 0;     // Enable protocol file generation for Protocol Analyzer
    m_svt_apb_env_cfg.num_slaves = `APB_SLAVE_NUM;
    


    //--------------------------------------------------------------------------------
    //if use apb master vip://just for reference---need to change according to project
    //--------------------------------------------------------------------------------
    //m_svt_apb_env_cfg.create_sub_cfgs(`APB_SLAVE_NUM);
    //m_svt_apb_env_cfg.is_active = 1;
    //m_svt_apb_env_cfg.apb3_enable = 1;
    //m_svt_apb_env_cfg.apb4_enable = 0;
    //m_svt_apb_env_cfg.paddr_width = svt_apb_system_configuration::PADDR_WIDTH_32;
    //m_svt_apb_env_cfg.pdata_width = svt_apb_system_configuration::PDATA_WIDTH_32;
    //m_svt_apb_env_cfg.enable_xml_gen = 0;     // Enable protocol file generation for Protocol Analyzer
    //m_svt_apb_env_cfg.num_slaves = `APB_SLAVE_NUM;
    //m_svt_apb_env_cfg.slave_addr_ranges = new[`APB_SLAVE_NUM];
    //foreach(m_svt_apb_env_cfg.slave_addr_ranges[i]) begin
    //    m_svt_apb_env_cfg.slave_addr_ranges[i] = new($sformatf("%s.slave_addr_ranges['d%0d]", get_full_name, i));
    //    m_svt_apb_env_cfg.slave_addr_ranges[i].start_addr = /*addr range*/;
    //    m_svt_apb_env_cfg.slave_addr_ranges[i].slave_id  = i;
    //    m_svt_apb_env_cfg.slave_cfg[i]  = 0;
    //end

    //--------------------------------------------------------------------------------
    //if use apb slave vip://just for reference---need to change according to project
    //--------------------------------------------------------------------------------
    //m_svt_apb_env_cfg.create_sub_cfgs(`APB_NUM);
    //m_svt_apb_env_cfg.is_active = 0;
    //m_svt_apb_env_cfg.apb3_enable = 1;
    //m_svt_apb_env_cfg.apb4_enable = 0;
    //m_svt_apb_env_cfg.paddr_width = svt_apb_system_configuration::PADDR_WIDTH_32;
    //m_svt_apb_env_cfg.pdata_width = svt_apb_system_configuration::PDATA_WIDTH_32;
    //m_svt_apb_env_cfg.enable_xml_gen = 0;     // Enable protocol file generation for Protocol Analyzer
    //m_svt_apb_env_cfg.slave_addr_ranges = new[`APB_NUM];
    //foreach(m_svt_apb_env_cfg.slave_addr_ranges[i]) begin
    //    m_svt_apb_env_cfg.slave_addr_ranges[i] = new($sformatf("%s.slave_addr_ranges['d%0d]", get_full_name, i));
    //    m_svt_apb_env_cfg.slave_addr_ranges[i].start_addr = /*addr range*/;
    //    m_svt_apb_env_cfg.slave_addr_ranges[i].slave_id  = i;
    //    m_svt_apb_env_cfg.slave_cfg[i]  = 1;
    //end

endfunction : new

 

`endif // MC_ENV_CONFIG_SV

