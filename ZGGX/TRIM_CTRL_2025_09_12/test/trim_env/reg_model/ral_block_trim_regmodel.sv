`ifndef RAL_BLOCK_TRIM_REGMODEL_SV
`define RAL_BLOCK_TRIM_REGMODEL_SV

class ral_block_trim_regmodel extends uvm_reg_block;
    `uvm_object_utils(ral_block_trim_regmodel)
    function new(string name="ral_block_trim_regmodel");
    endfunction

    virtual function void build();
    endfunction

endclass

`endif
