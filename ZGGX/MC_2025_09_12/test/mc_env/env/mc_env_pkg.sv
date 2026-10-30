
package mc_env_pkg;


    `include "uvm_macros.svh"
    `include "define.vh"

    import uvm_pkg::*;


    import svt_uvm_pkg::*;

    import svt_apb_uvm_pkg::*;

    import frame_agent_pkg::*;

    import array_agent_pkg::*;

    `include "mc_env_config.sv"
    `include "ral_mc_top_aux.sv"
    `include "mc_refm.sv"
    `include "mc_scb.sv"
    `include "mc_vseqr.sv"
    `include "mc_env.sv"
endpackage : mc_env_pkg

