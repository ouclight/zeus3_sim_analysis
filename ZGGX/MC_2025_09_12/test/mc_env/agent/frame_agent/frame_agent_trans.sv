
`ifndef FRAME_AGENT_TRANS_SV
`define FRAME_AGENT_TRANS_SV

class frame_agent_trans extends uvm_sequence_item; 
    rand bit                               mc_frame_vld        ;      
    rand bit                               mc_frame_rdy        ;   
    rand bit   [`FRAME_DATA_WIDTH-1:0]     mc_frame_data       ; 

    rand bit                               mc_bresp_vld        ;
    rand bit                               mc_bresp_rdy        ;  
    rand bit   [`BRESP_WIDTH-1:0]          mc_bresp            ;

    rand bit                               mc_rvalid           ;
    rand bit   [`MC_RDATA_WIDTH-1:0]       mc_rdata            ;        
    
    `uvm_object_utils_begin(frame_agent_trans)
        `uvm_field_int(mc_frame_vld, UVM_ALL_ON)
        `uvm_field_int(mc_frame_rdy, UVM_ALL_ON)
        `uvm_field_int(mc_frame_data, UVM_ALL_ON)
        `uvm_field_int(mc_bresp_vld, UVM_ALL_ON)
        `uvm_field_int(mc_bresp_rdy, UVM_ALL_ON)
        `uvm_field_int(mc_bresp, UVM_ALL_ON)
        `uvm_field_int(mc_rvalid, UVM_ALL_ON)
        `uvm_field_int(mc_rdata, UVM_ALL_ON)
    `uvm_object_utils_end
    
    extern function new(string name = "frame_agent_trans");

endclass : frame_agent_trans 

function frame_agent_trans::new(string name = "frame_agent_trans");
    super.new(name);
endfunction : new

`endif // FRAME_AGENT_TRANS_SV

