//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : frame_agent_seq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef FRAME_AGENT_SEQ_SV
`define FRAME_AGENT_SEQ_SV

class frame_agent_base_seq extends uvm_sequence #(frame_agent_trans);
    frame_agent_trans   tr;

    bit [`FRAME_DATA_WIDTH-1:0]     mc_frame_data   ;
    
    rand bit    [6:0]   cadd;
    rand bit    [12:0]  radd;
    rand bit    [255:0] f_data;
    rand bit    [9:0]   parity_data;       
    rand bit            bank_sel;         
    rand bit            frame_eof;
    rand bit            frame_sof;
    rand bit            frame_rw_flag;
    rand bit            strb;
         bit    [255:0] rdata;
    
    constraint  cadd_rand_c{
            cadd inside {[0:127]};
    }
    
    constraint f_data_ct{
        if(frame_rw_flag == 0){
            f_data == 0;
            parity_data == 0;
        } 
    }


    `uvm_object_utils(frame_agent_base_seq)
    
    extern function new(string name = "frame_agent_base_seq");

    extern task body();
    
endclass : frame_agent_base_seq
function frame_agent_base_seq::new(string name = "frame_agent_base_seq");
    super.new(name);
endfunction : new

task frame_agent_base_seq::body();
    mc_frame_data = {strb, frame_rw_flag,frame_sof,frame_eof,bank_sel,f_data,radd,cadd};
    `uvm_info("", $sformatf("frame_rw_flag: %0b", frame_rw_flag), UVM_MEDIUM)
    `uvm_info("", $sformatf("mc_frame_data[279]: %0b", mc_frame_data[279]), UVM_MEDIUM)

    tr = new();
    tr.mc_frame_data = mc_frame_data;
    `uvm_send(tr);
    //if(frame_rw_flag == 0) begin        //read
    //    get_response(rsp);
    //    `uvm_info("", $sformatf("seq_done: %s", rsp.sprint()), UVM_MEDIUM)
    //end

endtask : body


//-------------------------------------------------------------------------

class frame_agent_seq extends frame_agent_base_seq;
    `uvm_object_utils(frame_agent_seq)

    extern function new(string name = "frame_agent_seq");

    extern task body();

endclass : frame_agent_seq

function frame_agent_seq::new(string name = "frame_agent_seq");
    super.new(name);
endfunction : new

task frame_agent_seq::body();

    `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)

    `uvm_do(req)
    #10us;

    `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)

endtask : body

`endif // FRAME_AGENT_SEQ_LIB_SV

