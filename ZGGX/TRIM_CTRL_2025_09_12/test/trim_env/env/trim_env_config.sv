`ifndef TRIM_ENV_CONFIG_SV
`define TRIM_ENV_CONFIG_SV

class trim_env_config extends uvm_object;
    `uvm_object_utils(trim_env_config)

    svt_apb_system_configuration m_svt_apb_env_cfg;
    
    bit scb_en = 0; //0716 modified

    extern function new(string name = "trim_env_config");

endclass : trim_env_config 

function trim_env_config::new(string name = "trim_env_config");
    super.new(name);
    
    m_svt_apb_env_cfg = new("m_svt_apb_env_cfg");
    
    
    //--------------------------------------------------------------------------------
    //if use apb master vip://just for reference---need to change according to project
    //--------------------------------------------------------------------------------
    m_svt_apb_env_cfg.create_sub_cfgs(`APB_SLAVE_NUM);
    m_svt_apb_env_cfg.is_active = 1;
    m_svt_apb_env_cfg.apb3_enable = 1;
    m_svt_apb_env_cfg.apb4_enable = 0;
    m_svt_apb_env_cfg.paddr_width = svt_apb_system_configuration::PADDR_WIDTH_32;
    m_svt_apb_env_cfg.pdata_width = svt_apb_system_configuration::PDATA_WIDTH_32;
    m_svt_apb_env_cfg.enable_xml_gen = 0;     // Enable protocol file generation for Protocol Analyzer
    m_svt_apb_env_cfg.num_slaves = `APB_SLAVE_NUM;
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

`endif // TRIM_ENV_CONFIG_SV

