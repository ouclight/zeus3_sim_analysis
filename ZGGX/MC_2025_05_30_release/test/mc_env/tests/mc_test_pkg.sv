//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_test_pkg.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_TEST_PKG_SV
`define MC_TEST_PKG_SV

package mc_test_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import svt_uvm_pkg::*;
    import svt_apb_uvm_pkg::*;
    import frame_agent_pkg::*;
    import array_agent_pkg::*;
    import mc_env_pkg::*;

    //`include "iuvm_reg_rand_access_seq.svh"
    //`include "iuvm_reg_access_seq.svh"
    //`include "mc_base_vseq.sv"
    //`include "mc_common_vseq.sv"
    `include "mc_base_test.sv"
    `include "mc_common_test.sv"
    `include "mc_reg_test.sv"
    `include "mc_vseq_lib.sv"
    
endpackage : mc_test_pkg
`endif // MC_TEST_PKG_SV

