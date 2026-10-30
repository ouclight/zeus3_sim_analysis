`ifndef TRIM_REFM_SV
`define TRIM_REFM_SV

class trim_refm extends uvm_component;
    `uvm_component_utils(trim_refm)
    //uvm_blocking_get_port #(in_trans)  port;
    //uvm_analysis_port     #(out_trans) ap;
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
endclass : trim_refm 

function trim_refm::new(string name, uvm_component parent);

    super.new(name, parent);

endfunction : new

function void trim_refm::build_phase(uvm_phase phase);
    //port = new("port",this);
    //ap   = new("ap"  ,this);
endfunction : build_phase

task trim_refm::main_phase(uvm_phase phase);

    //in_trans  tr_in;
    //out_trans tr_out;
    //while(1)begin
    //    port.get(tr_in);
    //    ap.write(tr_out);
    //end
endtask : main_phase

`endif // TRIM_REFM_SV

