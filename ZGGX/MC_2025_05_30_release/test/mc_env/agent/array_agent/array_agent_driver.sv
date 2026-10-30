//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : array_agent_driver.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef ARRAY_AGENT_DRIVER_SV
`define ARRAY_AGENT_DRIVER_SV

class array_agent_driver extends uvm_driver #(array_agent_trans);
    `uvm_component_utils(array_agent_driver)

    virtual interface  array_agent_if vif;
    uvm_analysis_port #(array_agent_trans) ap;

    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    extern task do_drive(array_agent_trans req);

    extern task initial_config();//initial all input signals and wait reset release
endclass : array_agent_driver

function array_agent_driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void array_agent_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap",this);
endfunction : build_phase

function void array_agent_driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (!uvm_config_db #(virtual array_agent_if)::get(this, "*", "array_agent_vif", vif))
        `uvm_error("NOVIF", {"virtual interface must be set for: ",get_full_name(),".vif"})

endfunction : connect_phase

task array_agent_driver::initial_config();
    //vif.signal0 <= 0;
    //vif.signal1 <= 1;
    //wait reset release
    //@(posedge vif.reset_n);
endtask

task array_agent_driver::main_phase(uvm_phase phase);
    initial_config();

    forever begin
        seq_item_port.get_next_item(req);

        `uvm_info(get_type_name(), {"req item\n",req.sprint}, UVM_HIGH)

        do_drive(req);

        //rsp = new("rsp");
        //$cast(rsp, req.clone());
        //rsp.set_id_info(req);
        //seq_item_port.put_response(rsp);
        seq_item_port.item_done();
    end

endtask : main_phase

task array_agent_driver::do_drive(array_agent_trans req);

endtask : do_drive

`endif // ARRAY_AGENT_DRIVER_SV


