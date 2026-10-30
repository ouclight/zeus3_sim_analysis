//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : frame_agent_config.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef FRAME_AGENT_CONFIG_SV
`define FRAME_AGENT_CONFIG_SV

class frame_agent_config extends uvm_object;
    `uvm_object_utils(frame_agent_config)

    rand uvm_active_passive_enum is_active = UVM_ACTIVE;

    rand bit coverage_enable = 0;
    rand bit checks_enable = 0;
    extern function new(string name = "frame_agent_config");

endclass : frame_agent_config 

function frame_agent_config::new(string name = "frame_agent_config");
    super.new(name);
endfunction : new

`endif // FRAME_AGENT_CONFIG_SV

