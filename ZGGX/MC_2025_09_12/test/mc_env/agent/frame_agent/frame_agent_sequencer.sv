
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


