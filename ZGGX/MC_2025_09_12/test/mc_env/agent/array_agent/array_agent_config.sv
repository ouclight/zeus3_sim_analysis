
`ifndef ARRAY_AGENT_CONFIG_SV
`define ARRAY_AGENT_CONFIG_SV

class array_agent_config extends uvm_object;
    `uvm_object_utils(array_agent_config)

    rand uvm_active_passive_enum is_active = UVM_PASSIVE;

    rand bit coverage_enable = 0;
    rand bit checks_enable = 0;
    extern function new(string name = "array_agent_config");

endclass : array_agent_config 

function array_agent_config::new(string name = "array_agent_config");
    super.new(name);
endfunction : new

`endif // ARRAY_AGENT_CONFIG_SV

