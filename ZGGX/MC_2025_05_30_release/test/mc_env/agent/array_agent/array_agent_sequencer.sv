//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : array_agent_sequencer.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef ARRAY_AGENT_SEQUENCER_SV
`define ARRAY_AGENT_SEQUENCER_SV

class array_agent_sequencer extends uvm_sequencer #(array_agent_trans);
    `uvm_component_utils(array_agent_sequencer)

    extern function new(string name, uvm_component parent);

endclass : array_agent_sequencer 

function array_agent_sequencer::new(string name, uvm_component parent);

    super.new(name, parent);

endfunction : new

`endif // ARRAY_AGENT_SEQUENCER_SV


