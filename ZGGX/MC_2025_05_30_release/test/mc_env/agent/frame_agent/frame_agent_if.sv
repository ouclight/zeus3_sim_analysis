//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : frame_agent_if.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef FRAME_AGENT_IF_SV
`define FRAME_AGENT_IF_SV

interface frame_agent_if(input clk,input rst_n); 

    // You could add properties and assertions, for example
    // property name 
    // ...
    // endproperty : name
    // label: assert property(name) 
    logic                               mc_frame_vld        ;   
    logic                               mc_frame_rdy        ;   
    logic   [`FRAME_DATA_WIDTH-1:0]     mc_frame_data       ; 

    logic                               mc_bresp_vld        ;
    logic                               mc_bresp_rdy        ;  
    logic   [`BRESP_WIDTH-1:0]          mc_bresp            ;

    logic                               mc_rvalid           ;
    logic   [`MC_RDATA_WIDTH-1:0]       mc_rdata            ;
    logic   [`MC_RRESP_WIDTH-1:0]       mc_rresp            ;
    bit                                 performance_test_en = 0 ;

endinterface : frame_agent_if

`endif // FRAME_AGENT_IF_SV
