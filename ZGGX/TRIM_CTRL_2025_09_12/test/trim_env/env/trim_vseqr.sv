`ifndef TRIM_VSEQR_SV
`define TRIM_VSEQR_SV

class trim_vseqr extends uvm_sequencer;
    svt_apb_system_sequencer    p_svt_apb_sqr;
    svt_apb_master_sequencer    p_svt_apb_master_sqr;
    //lid-0716//ral_block_trim_regmodel regmodel;
    ral_sys_dram_trim regmodel; //0716

    virtual trim_if     m_trim_if;

    `uvm_component_utils_begin(trim_vseqr)
        `uvm_field_object(regmodel, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
         
    if (!uvm_config_db #(virtual trim_if)::get(this, "", "trim_vif", m_trim_if))
        `uvm_error(get_full_name(), $sformatf(" virtual interface must be set for: trim_vif"))

endfunction

task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    if(m_trim_if.reg_test == 0)begin
        `uvm_info(get_type_name(), $sformatf("-------------Enter in reset_phase-------------"), UVM_LOW)
        stop_sequences();
        `uvm_info(get_type_name(), $sformatf("-------------Stop sequences-------------"), UVM_LOW)
    end
    phase.drop_objection(this);
endtask

endclass

`endif //TRIM_VSEQR_SV

