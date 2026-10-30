//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : frame_agent.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef FRAME_AGENT_SV
`define FRAME_AGENT_SV

class frame_agent extends uvm_agent;
    frame_agent_config       m_cfg;
    frame_agent_sequencer          m_sequencer;
    frame_agent_driver             m_driver;
    frame_agent_monitor            m_monitor;

    uvm_analysis_port #(frame_agent_trans) ap_w;
    uvm_analysis_port #(frame_agent_trans) ap_r;
    `uvm_component_utils_begin(frame_agent)
         `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
         `uvm_field_object(m_cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

    extern function new(string name, uvm_component parent); 

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : frame_agent


function  frame_agent::new(string name, uvm_component parent);
    super.new(name, parent);
    ap_w = new("ap_w", this);
    ap_r = new("ap_r", this);
endfunction : new


function void frame_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(m_cfg == null) begin
        if(!uvm_config_db#(frame_agent_config)::get(this, "", "m_cfg", m_cfg))
    begin
            //`uvm_warning("NOCONFIG", "Config not set for Rx agent, using default is_active field")
            m_cfg = frame_agent_config::type_id::create("m_cfg", this);
        end
    end
    is_active = m_cfg.is_active;

    m_monitor     = frame_agent_monitor::type_id::create("m_monitor", this);
    if (is_active == UVM_ACTIVE)
    begin
        m_driver    = frame_agent_driver::type_id::create("m_driver", this);
        m_sequencer = frame_agent_sequencer::type_id::create("m_sequencer", this);
    end
endfunction : build_phase


function void frame_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    m_monitor.ap_w.connect(ap_w);
    m_monitor.ap_r.connect(ap_r);
    if (is_active == UVM_ACTIVE)
    begin
        m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
        //this.ap = m_driver.ap;
    end
    //else begin
    //    this.ap = m_monitor.ap;
    //end
endfunction : connect_phase

`endif // FRAME_AGENT_SV


