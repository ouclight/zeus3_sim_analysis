`ifndef TRIM_COMMON_TEST_SV
`define TRIM_COMMON_TEST_SV

class trim_common_test extends trim_base_test;
    `uvm_component_utils(trim_common_test)

    extern function new(string name,uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
endclass

function trim_common_test::new(string name, uvm_component parent=null);
    super.new(name, parent);
endfunction : new

function void trim_common_test::build_phase(uvm_phase phase);
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

function void trim_common_test::connect_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"connect_phase running",UVM_LOW);
    super.connect_phase(phase);
endfunction

`endif //TRIM_COMMON_TEST_SV
