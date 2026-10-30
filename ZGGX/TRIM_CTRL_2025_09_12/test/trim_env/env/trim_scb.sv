`ifndef TRIM_SCB_SV
`define TRIM_SCB_SV

class trim_scb extends uvm_component;
    `uvm_component_utils(trim_scb)
    int cmp_t;
    //uvm_blocking_get_port #(out_trans) exp_port;
    //uvm_blocking_get_port #(out_trans) act_port;

    extern function new(string name, uvm_component parent);
    extern task main_phase(uvm_phase phase);
    extern function void build_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
endclass : trim_scb 

function trim_scb::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void trim_scb::build_phase(uvm_phase phase);
    cmp_t = 0;
    //exp_port = new("exp_port",this);
    //act_port = new("act_port",this);
endfunction

task trim_scb::main_phase(uvm_phase phase);

endtask : main_phase

function void trim_scb::report_phase(uvm_phase phase);
    if(cmp_t==0)begin
        `uvm_error(get_full_name,"Scoreboard did not finsh one comparation!")
    end
endfunction

`endif // TRIM_SCB_SV

