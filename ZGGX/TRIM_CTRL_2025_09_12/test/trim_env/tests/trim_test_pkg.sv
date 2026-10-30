`ifndef TRIM_TEST_PKG_SV
`define TRIM_TEST_PKG_SV

package trim_test_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import svt_uvm_pkg::*;
    import svt_apb_uvm_pkg::*;
    import trim_env_pkg::*;

    `include "iuvm_reg_rand_access_seq.svh"
    `include "iuvm_reg_access_seq.svh"
    `include "trim_base_test.sv"
    `include "trim_common_test.sv"
    `include "trim_base_vseq.sv"
    `include "trim_common_vseq.sv"
    //0716//`include "trim_base_test.sv"
    //0716//`include "trim_common_test.sv"
    `include "trim_reg_test.sv"
    `include "trim_seq_lib.sv"
    `include "trim_reset_test.sv"
endpackage : trim_test_pkg
`endif // TRIM_TEST_PKG_SV

