`ifndef TRIM_BASE_VSEQ_SV
`define TRIM_BASE_VSEQ_SV

class trim_base_vseq extends uvm_sequence;

    virtual svt_apb_if      m_apb_if;
    virtual trim_if         m_trim_if;


    `uvm_object_utils(trim_base_vseq)
    `uvm_declare_p_sequencer(trim_vseqr)

    function new(string name="trim_base_vseq");
        super.new(name);
        //set_automatic_phase_objection(1); //add 0716
    endfunction

virtual task get_config();
    if(!uvm_config_db#(virtual svt_apb_if)::get(null,get_full_name(),"apb_vif", m_apb_if))
        `uvm_fatal(get_full_name(), $sformatf("virtual interface must be set for: apb_vif!!!"))

    if(!uvm_config_db#(virtual trim_if)::get(null,get_full_name(),"trim_vif", m_trim_if))
        `uvm_fatal(get_full_name(), $sformatf("virtual interface must be set for: trim_vif!!!"))

endtask

virtual task pre_start();
    if(starting_phase!=null)begin
        starting_phase.raise_objection(this);
        `uvm_info(get_type_name(),"pre_start() raise an objection",UVM_LOW);
    end
    get_config();
endtask

virtual task post_start();
    if(starting_phase!=null)begin
        starting_phase.drop_objection(this);
        `uvm_info(get_type_name(),"post_start() drop an objection",UVM_LOW);
    end
endtask

endclass

`endif //TRIM_BASE_VSEQ_SV

