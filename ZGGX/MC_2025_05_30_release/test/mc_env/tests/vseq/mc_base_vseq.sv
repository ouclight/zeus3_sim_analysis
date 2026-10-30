//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_base_vseq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_BASE_VSEQ_SV
`define MC_BASE_VSEQ_SV

class mc_base_vseq extends uvm_sequence;
    
    virtual frame_agent_if  m_frame_agent_if;
    virtual array_agent_if  m_array_agent_if;
    virtual tb_if           m_tb_if;
    virtual svt_apb_if      m_svt_apb_if[2];
    bit[31:0]               mb_data;
    
    
    `uvm_object_utils(mc_base_vseq)
    `uvm_declare_p_sequencer(mc_vseqr)

    function new(string name="mc_base_vseq");
        super.new(name);
        set_automatic_phase_objection(1);
    endfunction
virtual task body();
    if(p_sequencer.m_tb_if.rst_ongoing_flag==0)begin
        get_config();
    end 
endtask 

virtual task get_config();

    if(!uvm_config_db#(virtual tb_if)::get(null, get_full_name(), "vif_tb", m_tb_if)) begin
        `uvm_fatal("GETINTF", {"Could not get m_tb_if at ", get_full_name()})
    end
    

    if(!uvm_config_db#(virtual frame_agent_if)::get(null,get_full_name(), "frame_agent_vif",m_frame_agent_if)) begin
        `uvm_fatal("GETINTF", {"Could not get frame_agent_vif at ", get_full_name()})
    end

    if(!uvm_config_db#(virtual array_agent_if)::get(null,get_full_name(), "array_agent_vif",m_array_agent_if)) begin
        `uvm_fatal("GETINTF", {"Could not get array_agent_vif at ", get_full_name()})
    end


    foreach (m_svt_apb_if[i]) begin
        if (!uvm_config_db #(virtual svt_apb_if)::get(null,get_full_name(), $sformatf("m_svt_apb_vif[%0d]", i), m_svt_apb_if[i]))
            `uvm_error(get_full_name(), $sformatf(" virtual interface must be set for: m_svt_apb_vif[%0d]", i))
    end
    

endtask

virtual task pre_start();
    //if(starting_phase!=null)begin
    //    starting_phase.raise_objection(this);
    //    `uvm_info(get_type_name(),"pre_start() raise an objection",UVM_LOW);
    //end
endtask

virtual task post_start();
    //if(starting_phase!=null)begin
    //    starting_phase.drop_objection(this);
    //    `uvm_info(get_type_name(),"post_start() drop an objection",UVM_LOW);
    //end
endtask

endclass

`endif //MC_BASE_VSEQ_SV

