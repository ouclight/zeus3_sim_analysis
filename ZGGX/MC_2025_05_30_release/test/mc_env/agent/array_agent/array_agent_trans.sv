//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : array_agent_trans.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef ARRAY_AGENT_TRANS_SV
`define ARRAY_AGENT_TRANS_SV

class array_agent_trans extends uvm_sequence_item; 
    logic       [`ROW_ADDR_WIDTH-1:0]                       row_addr  ;
    logic       [`COLUMN_ADDR_WIDTH-1:0]                    col_addr  ;
    logic       [`ARRAY_DATA_WIDTH-1:0]                     wr_data   ;
    logic       [`ARRAY_DATA_WIDTH-1:0]                     rd_data   ;
    logic                                                   wr_rd_cmd;  //1:write 0:read
    
    `uvm_object_utils_begin(array_agent_trans)
        `uvm_field_int(row_addr   ,       UVM_ALL_ON)
        `uvm_field_int(col_addr   ,       UVM_ALL_ON)        
        `uvm_field_int(wr_data    ,       UVM_ALL_ON)
        `uvm_field_int(rd_data    ,       UVM_ALL_ON)
        `uvm_field_int(wr_rd_cmd  ,       UVM_ALL_ON)       
    `uvm_object_utils_end
    extern function new(string name = "array_agent_trans");

endclass : array_agent_trans 

function array_agent_trans::new(string name = "array_agent_trans");
    super.new(name);
endfunction : new

`endif // ARRAY_AGENT_TRANS_SV

