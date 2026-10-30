//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : frame_agent_sequencer.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef FRAME_AGENT_SEQUENCER_SV
`define FRAME_AGENT_SEQUENCER_SV

class frame_agent_sequencer extends uvm_sequencer #(frame_agent_trans);
    `uvm_component_utils(frame_agent_sequencer)

    extern function new(string name, uvm_component parent);

endclass : frame_agent_sequencer 

function frame_agent_sequencer::new(string name, uvm_component parent);

    super.new(name, parent);

endfunction : new

`endif // FRAME_AGENT_SEQUENCER_SV


