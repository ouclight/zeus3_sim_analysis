//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : array_agent_seq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef ARRAY_AGENT_SEQ_SV
`define ARRAY_AGENT_SEQ_SV

class array_agent_base_seq extends uvm_sequence #(array_agent_trans);
    `uvm_object_utils(array_agent_base_seq)

    function new(string name = "array_agent_base_seq");
        super.new(name);
    endfunction

endclass : array_agent_base_seq

//-------------------------------------------------------------------------

class array_agent_seq extends array_agent_base_seq;
    `uvm_object_utils(array_agent_seq)

    extern function new(string name = "array_agent_seq");

    extern task body();

endclass : array_agent_seq

function array_agent_seq::new(string name = "array_agent_seq");
    super.new(name);
endfunction : new

task array_agent_seq::body();

    `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)

    `uvm_do(req)
    #10us;

    `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)

endtask : body

`endif // ARRAY_AGENT_SEQ_LIB_SV

