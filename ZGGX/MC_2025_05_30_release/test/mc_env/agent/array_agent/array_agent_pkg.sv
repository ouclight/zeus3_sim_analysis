//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : array_agent_pkg.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef ARRAY_AGENT_PKG_SV
`define ARRAY_AGENT_PKG_SV

package array_agent_pkg;

    import uvm_pkg::*;
    
    `include "define.vh"
    `include "uvm_macros.svh"
    `include "array_agent_trans.sv"
    `include "array_agent_config.sv"
    `include "array_agent_monitor.sv"
    `include "array_agent_driver.sv"

    `include "array_agent_sequencer.sv"
    `include "array_agent_seq.sv"

    `include "array_agent.sv"

endpackage : array_agent_pkg
    `include "array_agent_if.sv"
`endif // ARRAY_AGENT_PKG_SV

