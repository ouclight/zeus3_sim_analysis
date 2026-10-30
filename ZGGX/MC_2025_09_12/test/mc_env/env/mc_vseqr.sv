
`ifndef MC_VSEQR_SV
`define MC_VSEQR_SV

class mc_vseqr extends uvm_sequencer;
   
`uvm_component_utils(mc_vseqr)
    svt_apb_system_sequencer    p_svt_apb_sqr[];
    svt_apb_master_sequencer    p_svt_apb_master_sqr[];

    frame_agent_sequencer    p_frame_agent_sqr;

    ral_sys_mc_top_aux          mc_soc_regmodel;
    //ral_block_mc_regmodel regmodel;

    virtual frame_agent_if  m_frame_agent_if;
    virtual array_agent_if  m_array_agent_if;
    virtual tb_if           m_tb_if;
    virtual svt_apb_if      m_svt_apb_if[1];

function new(string name,uvm_component parent);
    super.new(name,parent);
    p_svt_apb_sqr = new[1];
    p_svt_apb_master_sqr = new[1];

endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual tb_if)::get(this, "", "vif_tb", m_tb_if)) begin
        `uvm_fatal("GETINTF", {"Could not get m_tb_if at ", get_full_name()})
    end
    

    if(!uvm_config_db#(virtual frame_agent_if)::get(this, "", "frame_agent_vif",m_frame_agent_if)) begin
        `uvm_fatal("GETINTF", {"Could not get frame_agent_vif at ", get_full_name()})
    end

    if(!uvm_config_db#(virtual array_agent_if)::get(this, "", "array_agent_vif",m_array_agent_if)) begin
        `uvm_fatal("GETINTF", {"Could not get array_agent_vif at ", get_full_name()})
    end


    foreach (m_svt_apb_if[i]) begin
        if (!uvm_config_db #(virtual svt_apb_if)::get(this, "", $sformatf("m_svt_apb_vif[%0d]", i), m_svt_apb_if[i]))
            `uvm_error(get_full_name(), $sformatf(" virtual interface must be set for: m_svt_apb_vif[%0d]", i))
    end
    
endfunction
extern task reset_phase(uvm_phase phase);    
endclass
task mc_vseqr::reset_phase(uvm_phase phase);
    super.reset_phase(phase);  
    `uvm_info("mc_vseqr", "stop_sequences_start!!!", UVM_LOW);
    stop_sequences();
    `uvm_info("mc_vseqr", "mc_vseqr_stop_sequences!!!", UVM_LOW);
endtask : reset_phase

`endif //MC_VSEQR_SV

