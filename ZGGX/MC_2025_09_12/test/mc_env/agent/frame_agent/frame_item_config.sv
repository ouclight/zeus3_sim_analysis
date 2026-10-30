`ifndef FRAME_ITEM_CONFIG_SV
`define FRAME_ITEM_CONFIG_SV

class frame_item_config extends uvm_object;

    rand int frame_vld_interval;
    rand int bresp_rdy_interval;
    
    extern function new(string name = "frame_item_config");

    `uvm_object_utils_begin(frame_item_config)
        `uvm_field_int(frame_vld_interval, UVM_ALL_ON)
        `uvm_field_int(bresp_rdy_interval, UVM_ALL_ON)
    `uvm_object_utils_end
    constraint c_delay{
        frame_vld_interval      dist {0:=30,[1:99]:=50,100:=2};
        bresp_rdy_interval      dist {0:=20,[1:9]:=50,10:=2};
    }
    
endclass : frame_item_config 

function frame_item_config::new(string name = "frame_item_config");
    super.new(name);
endfunction : new

`endif // FRAME_ITEM_CONFIG_SV

