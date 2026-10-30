
`ifndef MC_COMMON_TEST_SV
`define MC_COMMON_TEST_SV

class mc_common_test extends mc_base_test;
    `uvm_component_utils(mc_common_test)

    extern function new(string name,uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);
    extern virtual task  reset_phase(uvm_phase phase);

endclass

function mc_common_test::new(string name, uvm_component parent=null);
    super.new(name, parent);
endfunction : new


function void mc_common_test::build_phase(uvm_phase phase);
    string default_sequence_name = "";
    uvm_sequence_base default_sequence;
    super.build_phase(phase);

    if(uvm_cmdline_proc.get_arg_value("+UVM_SEQ_NAME=",default_sequence_name))begin
        `uvm_info(get_type_name(),$sformatf("Get default sequence :%s from plusargs",default_sequence_name),UVM_LOW);
        $cast(default_sequence,this.create_object(default_sequence_name));
        if(default_sequence==null)begin
            `uvm_fatal(get_type_name(),"Input invalid sequence name");
        end
        uvm_config_db#(uvm_sequence_base)::set(this,"vseqr.main_phase","default_sequence",default_sequence);
        `uvm_info(get_full_name(),"common test build phase done!",UVM_LOW)
    end
    else begin
        `uvm_warning(get_type_name(),"Do not specify default_sequence for test")
    end
endfunction

function void mc_common_test::connect_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"connect_phase running",UVM_LOW);
    super.connect_phase(phase);
endfunction

task mc_common_test::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    phase.raise_objection(this);
    `uvm_info(get_full_name(),"reset_phase raise_objection",UVM_LOW);



    `uvm_info(get_full_name(),"reset_phase drop_objection",UVM_LOW);
    phase.drop_objection(this);

endtask : reset_phase

task mc_common_test::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(get_full_name(),"dram_logic_top_common_test_main_phase",UVM_LOW);


endtask : main_phase

`endif //MC_COMMON_TEST_SV
