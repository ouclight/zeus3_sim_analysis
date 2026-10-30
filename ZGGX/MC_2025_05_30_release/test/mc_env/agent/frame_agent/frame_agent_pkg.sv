//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : frame_agent_pkg.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef FRAME_AGENT_PKG_SV
`define FRAME_AGENT_PKG_SV

package frame_agent_pkg;

    import uvm_pkg::*;
    
    `include "define.vh"
    `include "uvm_macros.svh"
    `include "frame_agent_trans.sv"
    `include "frame_agent_config.sv"
    `include "frame_item_config.sv"    
    `include "frame_agent_monitor.sv"
    `include "frame_agent_driver.sv"

    `include "frame_agent_sequencer.sv"
    `include "frame_agent_seq.sv"

    `include "frame_agent.sv"

endpackage : frame_agent_pkg
    `include "frame_agent_if.sv"
`endif // FRAME_AGENT_PKG_SV

