`ifndef RAL_dram_trim
`define RAL_dram_trim

`define UVM_REG_ADDR_WIDTH 32

class ral_reg_dram_trim_top_trim_ctrl_id extends uvm_reg;
    rand uvm_reg_field trim_ctrl_id;

    function new(string name = "dram_trim_top_trim_ctrl_id");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.trim_ctrl_id = uvm_reg_field::type_id::create("trim_ctrl_id",,get_full_name());
        this.trim_ctrl_id.configure(this,32,0,"RO",0,32'h5452494D,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_trim_ctrl_id)
endclass:ral_reg_dram_trim_top_trim_ctrl_id

class ral_reg_dram_trim_top_trim_op_ctrl extends uvm_reg;
    rand uvm_reg_field spine_resetn_active;
    rand uvm_reg_field tm_redump_active;
    rand uvm_reg_field stopwatch_period_active;
    rand uvm_reg_field trim_start;
    rand uvm_reg_field init_start;

    function new(string name = "dram_trim_top_trim_op_ctrl");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.spine_resetn_active = uvm_reg_field::type_id::create("spine_resetn_active",,get_full_name());
        this.spine_resetn_active.configure(this,1,0,"W1C",0,32'h0,1,0,0);
        this.tm_redump_active = uvm_reg_field::type_id::create("tm_redump_active",,get_full_name());
        this.tm_redump_active.configure(this,1,1,"W1C",0,32'h0,1,0,0);
        this.stopwatch_period_active = uvm_reg_field::type_id::create("stopwatch_period_active",,get_full_name());
        this.stopwatch_period_active.configure(this,1,2,"W1C",0,32'h0,1,0,0);
        this.trim_start = uvm_reg_field::type_id::create("trim_start",,get_full_name());
        this.trim_start.configure(this,1,3,"W1C",0,32'h0,1,0,0);
        this.init_start = uvm_reg_field::type_id::create("init_start",,get_full_name());
        this.init_start.configure(this,1,4,"W1C",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_trim_op_ctrl)
endclass:ral_reg_dram_trim_top_trim_op_ctrl

class ral_reg_dram_trim_top_trim_global_ctrl extends uvm_reg;
    rand uvm_reg_field trim_op_flow;
    rand uvm_reg_field hw_op_ringo_mask;
    rand uvm_reg_field hw_op_tsv_load_sel;
    rand uvm_reg_field dram_layer_sel;
    rand uvm_reg_field res_or_ringo_sel;
    rand uvm_reg_field debug_en;
    rand uvm_reg_field trim_finish;

    function new(string name = "dram_trim_top_trim_global_ctrl");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.trim_op_flow = uvm_reg_field::type_id::create("trim_op_flow",,get_full_name());
        this.trim_op_flow.configure(this,1,0,"RW",0,32'h0,1,0,0);
        this.hw_op_ringo_mask = uvm_reg_field::type_id::create("hw_op_ringo_mask",,get_full_name());
        this.hw_op_ringo_mask.configure(this,1,1,"RW",0,32'h1,1,0,0);
        this.hw_op_tsv_load_sel = uvm_reg_field::type_id::create("hw_op_tsv_load_sel",,get_full_name());
        this.hw_op_tsv_load_sel.configure(this,1,2,"RW",0,32'h0,1,0,0);
        this.dram_layer_sel = uvm_reg_field::type_id::create("dram_layer_sel",,get_full_name());
        this.dram_layer_sel.configure(this,4,4,"RW",0,32'h0,1,0,0);
        this.res_or_ringo_sel = uvm_reg_field::type_id::create("res_or_ringo_sel",,get_full_name());
        this.res_or_ringo_sel.configure(this,1,8,"RW",0,32'h0,1,0,0);
        this.debug_en = uvm_reg_field::type_id::create("debug_en",,get_full_name());
        this.debug_en.configure(this,1,9,"RW",0,32'h0,1,0,0);
        this.trim_finish = uvm_reg_field::type_id::create("trim_finish",,get_full_name());
        this.trim_finish.configure(this,1,12,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_trim_global_ctrl)
endclass:ral_reg_dram_trim_top_trim_global_ctrl

class ral_reg_dram_trim_top_trim_internal_status extends uvm_reg;
    rand uvm_reg_field spine_resetn_active_ready;
    rand uvm_reg_field tm_redump_active_ready;
    rand uvm_reg_field stopwatch_period_active_ready;
    rand uvm_reg_field init_done_flag;
    rand uvm_reg_field stopwatch_ringo_period_ready;
    rand uvm_reg_field dump_ready;
    rand uvm_reg_field dumpready_timeout_ready;

    function new(string name = "dram_trim_top_trim_internal_status");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.spine_resetn_active_ready = uvm_reg_field::type_id::create("spine_resetn_active_ready",,get_full_name());
        this.spine_resetn_active_ready.configure(this,1,0,"RO",0,32'h1,1,0,0);
        this.tm_redump_active_ready = uvm_reg_field::type_id::create("tm_redump_active_ready",,get_full_name());
        this.tm_redump_active_ready.configure(this,1,1,"RO",0,32'h1,1,0,0);
        this.stopwatch_period_active_ready = uvm_reg_field::type_id::create("stopwatch_period_active_ready",,get_full_name());
        this.stopwatch_period_active_ready.configure(this,1,2,"RO",0,32'h1,1,0,0);
        this.init_done_flag = uvm_reg_field::type_id::create("init_done_flag",,get_full_name());
        this.init_done_flag.configure(this,1,3,"RO",0,32'h0,1,0,0);
        this.stopwatch_ringo_period_ready = uvm_reg_field::type_id::create("stopwatch_ringo_period_ready",,get_full_name());
        this.stopwatch_ringo_period_ready.configure(this,4,4,"RO",0,32'h0,1,0,0);
        this.dump_ready = uvm_reg_field::type_id::create("dump_ready",,get_full_name());
        this.dump_ready.configure(this,4,8,"RO",0,32'h0,1,0,0);
        this.dumpready_timeout_ready = uvm_reg_field::type_id::create("dumpready_timeout_ready",,get_full_name());
        this.dumpready_timeout_ready.configure(this,4,12,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_trim_internal_status)
endclass:ral_reg_dram_trim_top_trim_internal_status

class ral_reg_dram_trim_top_init_spine_resetn_time extends uvm_reg;
    rand uvm_reg_field init_spine_reset_time;

    function new(string name = "dram_trim_top_init_spine_resetn_time");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.init_spine_reset_time = uvm_reg_field::type_id::create("init_spine_reset_time",,get_full_name());
        this.init_spine_reset_time.configure(this,28,0,"RW",0,32'h7A11FF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_init_spine_resetn_time)
endclass:ral_reg_dram_trim_top_init_spine_resetn_time

class ral_reg_dram_trim_top_spine_resetn_width extends uvm_reg;
    rand uvm_reg_field spine_resetn_width;

    function new(string name = "dram_trim_top_spine_resetn_width");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.spine_resetn_width = uvm_reg_field::type_id::create("spine_resetn_width",,get_full_name());
        this.spine_resetn_width.configure(this,10,0,"RW",0,32'h13,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_spine_resetn_width)
endclass:ral_reg_dram_trim_top_spine_resetn_width

class ral_reg_dram_trim_top_tm_redump_width extends uvm_reg;
    rand uvm_reg_field tm_redump_width;

    function new(string name = "dram_trim_top_tm_redump_width");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.tm_redump_width = uvm_reg_field::type_id::create("tm_redump_width",,get_full_name());
        this.tm_redump_width.configure(this,10,0,"RW",0,32'h3,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_tm_redump_width)
endclass:ral_reg_dram_trim_top_tm_redump_width

class ral_reg_dram_trim_top_stopwatch_period_width extends uvm_reg;
    rand uvm_reg_field stopwatch_period_width_res;
    rand uvm_reg_field stopwatch_period_width_ringo;

    function new(string name = "dram_trim_top_stopwatch_period_width");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.stopwatch_period_width_res = uvm_reg_field::type_id::create("stopwatch_period_width_res",,get_full_name());
        this.stopwatch_period_width_res.configure(this,16,0,"RW",0,32'h18F,1,0,0);
        this.stopwatch_period_width_ringo = uvm_reg_field::type_id::create("stopwatch_period_width_ringo",,get_full_name());
        this.stopwatch_period_width_ringo.configure(this,16,16,"RW",0,32'h3,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_stopwatch_period_width)
endclass:ral_reg_dram_trim_top_stopwatch_period_width

class ral_reg_dram_trim_top_redump_tsv_tm_other_value0 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value0;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value0");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value0 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value0",,get_full_name());
        this.redump_tsv_tm_other_value0.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value0)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value0

class ral_reg_dram_trim_top_redump_tsv_tm_other_value1 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value1;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value1");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value1 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value1",,get_full_name());
        this.redump_tsv_tm_other_value1.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value1)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value1

class ral_reg_dram_trim_top_redump_tsv_tm_other_value2 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value2;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value2");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value2 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value2",,get_full_name());
        this.redump_tsv_tm_other_value2.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value2)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value2

class ral_reg_dram_trim_top_redump_tsv_tm_other_value3 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value3;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value3");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value3 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value3",,get_full_name());
        this.redump_tsv_tm_other_value3.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value3)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value3

class ral_reg_dram_trim_top_redump_tsv_tm_other_value4 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value4;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value4");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value4 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value4",,get_full_name());
        this.redump_tsv_tm_other_value4.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value4)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value4

class ral_reg_dram_trim_top_redump_tsv_tm_other_value5 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value5;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value5");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value5 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value5",,get_full_name());
        this.redump_tsv_tm_other_value5.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value5)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value5

class ral_reg_dram_trim_top_redump_tsv_tm_other_value6 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value6;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value6");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value6 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value6",,get_full_name());
        this.redump_tsv_tm_other_value6.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value6)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value6

class ral_reg_dram_trim_top_redump_tsv_tm_other_value7 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value7;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value7");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value7 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value7",,get_full_name());
        this.redump_tsv_tm_other_value7.configure(this,32,0,"RW",0,32'h598000,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value7)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value7

class ral_reg_dram_trim_top_redump_tsv_tm_other_value8 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value8;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value8");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value8 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value8",,get_full_name());
        this.redump_tsv_tm_other_value8.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value8)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value8

class ral_reg_dram_trim_top_redump_tsv_tm_other_value9 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value9;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value9");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value9 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value9",,get_full_name());
        this.redump_tsv_tm_other_value9.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value9)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value9

class ral_reg_dram_trim_top_redump_tsv_tm_other_value10 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value10;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value10");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value10 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value10",,get_full_name());
        this.redump_tsv_tm_other_value10.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value10)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value10

class ral_reg_dram_trim_top_redump_tsv_tm_other_value11 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value11;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value11");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value11 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value11",,get_full_name());
        this.redump_tsv_tm_other_value11.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value11)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value11

class ral_reg_dram_trim_top_redump_tsv_tm_other_value12 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value12;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value12");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value12 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value12",,get_full_name());
        this.redump_tsv_tm_other_value12.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value12)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value12

class ral_reg_dram_trim_top_redump_tsv_tm_other_value13 extends uvm_reg;
    rand uvm_reg_field redump_tsv_tm_other_value13;

    function new(string name = "dram_trim_top_redump_tsv_tm_other_value13");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.redump_tsv_tm_other_value13 = uvm_reg_field::type_id::create("redump_tsv_tm_other_value13",,get_full_name());
        this.redump_tsv_tm_other_value13.configure(this,12,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_redump_tsv_tm_other_value13)
endclass:ral_reg_dram_trim_top_redump_tsv_tm_other_value13

class ral_reg_dram_trim_top_osc_tm_res_smp_value extends uvm_reg;
    rand uvm_reg_field osc_tm_res_smp_value;
    rand uvm_reg_field osc_tm_res_smp_ready;

    function new(string name = "dram_trim_top_osc_tm_res_smp_value");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.osc_tm_res_smp_value = uvm_reg_field::type_id::create("osc_tm_res_smp_value",,get_full_name());
        this.osc_tm_res_smp_value.configure(this,8,0,"RO",0,32'h0,1,0,0);
        this.osc_tm_res_smp_ready = uvm_reg_field::type_id::create("osc_tm_res_smp_ready",,get_full_name());
        this.osc_tm_res_smp_ready.configure(this,4,8,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_osc_tm_res_smp_value)
endclass:ral_reg_dram_trim_top_osc_tm_res_smp_value

class ral_reg_dram_trim_top_stopwatch_ringo_period_01 extends uvm_reg;
    rand uvm_reg_field stopwatch_ringo_period0;
    rand uvm_reg_field stopwatch_ringo_period1;

    function new(string name = "dram_trim_top_stopwatch_ringo_period_01");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.stopwatch_ringo_period0 = uvm_reg_field::type_id::create("stopwatch_ringo_period0",,get_full_name());
        this.stopwatch_ringo_period0.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.stopwatch_ringo_period1 = uvm_reg_field::type_id::create("stopwatch_ringo_period1",,get_full_name());
        this.stopwatch_ringo_period1.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_stopwatch_ringo_period_01)
endclass:ral_reg_dram_trim_top_stopwatch_ringo_period_01

class ral_reg_dram_trim_top_stopwatch_ringo_period_23 extends uvm_reg;
    rand uvm_reg_field stopwatch_ringo_period2;
    rand uvm_reg_field stopwatch_ringo_period3;

    function new(string name = "dram_trim_top_stopwatch_ringo_period_23");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.stopwatch_ringo_period2 = uvm_reg_field::type_id::create("stopwatch_ringo_period2",,get_full_name());
        this.stopwatch_ringo_period2.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.stopwatch_ringo_period3 = uvm_reg_field::type_id::create("stopwatch_ringo_period3",,get_full_name());
        this.stopwatch_ringo_period3.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_stopwatch_ringo_period_23)
endclass:ral_reg_dram_trim_top_stopwatch_ringo_period_23

class ral_reg_dram_trim_top_dumpready_timeout_ctrl extends uvm_reg;
    rand uvm_reg_field dumpready_timeout_en;
    rand uvm_reg_field dumpready_timeout_clr;
    rand uvm_reg_field dumpready_timeout_flag;
    rand uvm_reg_field dumpready_timeout_time;

    function new(string name = "dram_trim_top_dumpready_timeout_ctrl");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dumpready_timeout_en = uvm_reg_field::type_id::create("dumpready_timeout_en",,get_full_name());
        this.dumpready_timeout_en.configure(this,1,0,"RW",0,32'h1,1,0,0);
        this.dumpready_timeout_clr = uvm_reg_field::type_id::create("dumpready_timeout_clr",,get_full_name());
        this.dumpready_timeout_clr.configure(this,1,1,"W1C",0,32'h0,1,0,0);
        this.dumpready_timeout_flag = uvm_reg_field::type_id::create("dumpready_timeout_flag",,get_full_name());
        this.dumpready_timeout_flag.configure(this,4,4,"RO",0,32'h0,1,0,0);
        this.dumpready_timeout_time = uvm_reg_field::type_id::create("dumpready_timeout_time",,get_full_name());
        this.dumpready_timeout_time.configure(this,24,8,"RW",0,32'hC3500,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_dumpready_timeout_ctrl)
endclass:ral_reg_dram_trim_top_dumpready_timeout_ctrl

class ral_reg_dram_trim_top_ringo_timeout_ctrl extends uvm_reg;
    rand uvm_reg_field ringo_timeout_en;
    rand uvm_reg_field ringo_timeout_clr;
    rand uvm_reg_field ringo_timeout_flag;
    rand uvm_reg_field ringo_timeout_time;

    function new(string name = "dram_trim_top_ringo_timeout_ctrl");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.ringo_timeout_en = uvm_reg_field::type_id::create("ringo_timeout_en",,get_full_name());
        this.ringo_timeout_en.configure(this,1,0,"RW",0,32'h1,1,0,0);
        this.ringo_timeout_clr = uvm_reg_field::type_id::create("ringo_timeout_clr",,get_full_name());
        this.ringo_timeout_clr.configure(this,1,1,"W1C",0,32'h0,1,0,0);
        this.ringo_timeout_flag = uvm_reg_field::type_id::create("ringo_timeout_flag",,get_full_name());
        this.ringo_timeout_flag.configure(this,4,4,"RO",0,32'h0,1,0,0);
        this.ringo_timeout_time = uvm_reg_field::type_id::create("ringo_timeout_time",,get_full_name());
        this.ringo_timeout_time.configure(this,24,8,"RW",0,32'hBB8,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_ringo_timeout_ctrl)
endclass:ral_reg_dram_trim_top_ringo_timeout_ctrl

class ral_reg_dram_trim_top_res_value_ctrl extends uvm_reg;
    rand uvm_reg_field res_value_sel;
    rand uvm_reg_field res_cfg_value;

    function new(string name = "dram_trim_top_res_value_ctrl");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.res_value_sel = uvm_reg_field::type_id::create("res_value_sel",,get_full_name());
        this.res_value_sel.configure(this,2,0,"RW",0,32'h0,1,0,0);
        this.res_cfg_value = uvm_reg_field::type_id::create("res_cfg_value",,get_full_name());
        this.res_cfg_value.configure(this,8,4,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_res_value_ctrl)
endclass:ral_reg_dram_trim_top_res_value_ctrl

class ral_reg_dram_trim_top_trim_interrupt_ctrl extends uvm_reg;
    rand uvm_reg_field trim_interrupt_clr;
    rand uvm_reg_field trim_interrupt_mask;
    rand uvm_reg_field trim_interrupt_flag;

    function new(string name = "dram_trim_top_trim_interrupt_ctrl");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.trim_interrupt_clr = uvm_reg_field::type_id::create("trim_interrupt_clr",,get_full_name());
        this.trim_interrupt_clr.configure(this,1,0,"W1C",0,32'h0,1,0,0);
        this.trim_interrupt_mask = uvm_reg_field::type_id::create("trim_interrupt_mask",,get_full_name());
        this.trim_interrupt_mask.configure(this,1,1,"RW",0,32'h0,1,0,0);
        this.trim_interrupt_flag = uvm_reg_field::type_id::create("trim_interrupt_flag",,get_full_name());
        this.trim_interrupt_flag.configure(this,1,2,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_trim_interrupt_ctrl)
endclass:ral_reg_dram_trim_top_trim_interrupt_ctrl

class ral_reg_dram_trim_top_hw_ringo_dram0_period_01 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram0_period0;
    rand uvm_reg_field hw_ringo_dram0_period1;

    function new(string name = "dram_trim_top_hw_ringo_dram0_period_01");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram0_period0 = uvm_reg_field::type_id::create("hw_ringo_dram0_period0",,get_full_name());
        this.hw_ringo_dram0_period0.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram0_period1 = uvm_reg_field::type_id::create("hw_ringo_dram0_period1",,get_full_name());
        this.hw_ringo_dram0_period1.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram0_period_01)
endclass:ral_reg_dram_trim_top_hw_ringo_dram0_period_01

class ral_reg_dram_trim_top_hw_ringo_dram0_period_23 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram0_period2;
    rand uvm_reg_field hw_ringo_dram0_period3;

    function new(string name = "dram_trim_top_hw_ringo_dram0_period_23");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram0_period2 = uvm_reg_field::type_id::create("hw_ringo_dram0_period2",,get_full_name());
        this.hw_ringo_dram0_period2.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram0_period3 = uvm_reg_field::type_id::create("hw_ringo_dram0_period3",,get_full_name());
        this.hw_ringo_dram0_period3.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram0_period_23)
endclass:ral_reg_dram_trim_top_hw_ringo_dram0_period_23

class ral_reg_dram_trim_top_hw_ringo_dram0_period_45 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram0_period4;
    rand uvm_reg_field hw_ringo_dram0_period5;

    function new(string name = "dram_trim_top_hw_ringo_dram0_period_45");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram0_period4 = uvm_reg_field::type_id::create("hw_ringo_dram0_period4",,get_full_name());
        this.hw_ringo_dram0_period4.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram0_period5 = uvm_reg_field::type_id::create("hw_ringo_dram0_period5",,get_full_name());
        this.hw_ringo_dram0_period5.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram0_period_45)
endclass:ral_reg_dram_trim_top_hw_ringo_dram0_period_45

class ral_reg_dram_trim_top_hw_ringo_dram0_period_67 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram0_period6;
    rand uvm_reg_field hw_ringo_dram0_period7;

    function new(string name = "dram_trim_top_hw_ringo_dram0_period_67");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram0_period6 = uvm_reg_field::type_id::create("hw_ringo_dram0_period6",,get_full_name());
        this.hw_ringo_dram0_period6.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram0_period7 = uvm_reg_field::type_id::create("hw_ringo_dram0_period7",,get_full_name());
        this.hw_ringo_dram0_period7.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram0_period_67)
endclass:ral_reg_dram_trim_top_hw_ringo_dram0_period_67

class ral_reg_dram_trim_top_hw_ringo_dram1_period_01 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram1_period0;
    rand uvm_reg_field hw_ringo_dram1_period1;

    function new(string name = "dram_trim_top_hw_ringo_dram1_period_01");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram1_period0 = uvm_reg_field::type_id::create("hw_ringo_dram1_period0",,get_full_name());
        this.hw_ringo_dram1_period0.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram1_period1 = uvm_reg_field::type_id::create("hw_ringo_dram1_period1",,get_full_name());
        this.hw_ringo_dram1_period1.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram1_period_01)
endclass:ral_reg_dram_trim_top_hw_ringo_dram1_period_01

class ral_reg_dram_trim_top_hw_ringo_dram1_period_23 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram1_period2;
    rand uvm_reg_field hw_ringo_dram1_period3;

    function new(string name = "dram_trim_top_hw_ringo_dram1_period_23");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram1_period2 = uvm_reg_field::type_id::create("hw_ringo_dram1_period2",,get_full_name());
        this.hw_ringo_dram1_period2.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram1_period3 = uvm_reg_field::type_id::create("hw_ringo_dram1_period3",,get_full_name());
        this.hw_ringo_dram1_period3.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram1_period_23)
endclass:ral_reg_dram_trim_top_hw_ringo_dram1_period_23

class ral_reg_dram_trim_top_hw_ringo_dram1_period_45 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram1_period4;
    rand uvm_reg_field hw_ringo_dram1_period5;

    function new(string name = "dram_trim_top_hw_ringo_dram1_period_45");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram1_period4 = uvm_reg_field::type_id::create("hw_ringo_dram1_period4",,get_full_name());
        this.hw_ringo_dram1_period4.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram1_period5 = uvm_reg_field::type_id::create("hw_ringo_dram1_period5",,get_full_name());
        this.hw_ringo_dram1_period5.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram1_period_45)
endclass:ral_reg_dram_trim_top_hw_ringo_dram1_period_45

class ral_reg_dram_trim_top_hw_ringo_dram1_period_67 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram1_period6;
    rand uvm_reg_field hw_ringo_dram1_period7;

    function new(string name = "dram_trim_top_hw_ringo_dram1_period_67");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram1_period6 = uvm_reg_field::type_id::create("hw_ringo_dram1_period6",,get_full_name());
        this.hw_ringo_dram1_period6.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram1_period7 = uvm_reg_field::type_id::create("hw_ringo_dram1_period7",,get_full_name());
        this.hw_ringo_dram1_period7.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram1_period_67)
endclass:ral_reg_dram_trim_top_hw_ringo_dram1_period_67

class ral_reg_dram_trim_top_hw_ringo_dram2_period_01 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram2_period0;
    rand uvm_reg_field hw_ringo_dram2_period1;

    function new(string name = "dram_trim_top_hw_ringo_dram2_period_01");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram2_period0 = uvm_reg_field::type_id::create("hw_ringo_dram2_period0",,get_full_name());
        this.hw_ringo_dram2_period0.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram2_period1 = uvm_reg_field::type_id::create("hw_ringo_dram2_period1",,get_full_name());
        this.hw_ringo_dram2_period1.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram2_period_01)
endclass:ral_reg_dram_trim_top_hw_ringo_dram2_period_01

class ral_reg_dram_trim_top_hw_ringo_dram2_period_23 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram2_period2;
    rand uvm_reg_field hw_ringo_dram2_period3;

    function new(string name = "dram_trim_top_hw_ringo_dram2_period_23");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram2_period2 = uvm_reg_field::type_id::create("hw_ringo_dram2_period2",,get_full_name());
        this.hw_ringo_dram2_period2.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram2_period3 = uvm_reg_field::type_id::create("hw_ringo_dram2_period3",,get_full_name());
        this.hw_ringo_dram2_period3.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram2_period_23)
endclass:ral_reg_dram_trim_top_hw_ringo_dram2_period_23

class ral_reg_dram_trim_top_hw_ringo_dram2_period_45 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram2_period4;
    rand uvm_reg_field hw_ringo_dram2_period5;

    function new(string name = "dram_trim_top_hw_ringo_dram2_period_45");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram2_period4 = uvm_reg_field::type_id::create("hw_ringo_dram2_period4",,get_full_name());
        this.hw_ringo_dram2_period4.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram2_period5 = uvm_reg_field::type_id::create("hw_ringo_dram2_period5",,get_full_name());
        this.hw_ringo_dram2_period5.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram2_period_45)
endclass:ral_reg_dram_trim_top_hw_ringo_dram2_period_45

class ral_reg_dram_trim_top_hw_ringo_dram2_period_67 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram2_period6;
    rand uvm_reg_field hw_ringo_dram2_period7;

    function new(string name = "dram_trim_top_hw_ringo_dram2_period_67");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram2_period6 = uvm_reg_field::type_id::create("hw_ringo_dram2_period6",,get_full_name());
        this.hw_ringo_dram2_period6.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram2_period7 = uvm_reg_field::type_id::create("hw_ringo_dram2_period7",,get_full_name());
        this.hw_ringo_dram2_period7.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram2_period_67)
endclass:ral_reg_dram_trim_top_hw_ringo_dram2_period_67

class ral_reg_dram_trim_top_hw_ringo_dram3_period_01 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram3_period0;
    rand uvm_reg_field hw_ringo_dram3_period1;

    function new(string name = "dram_trim_top_hw_ringo_dram3_period_01");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram3_period0 = uvm_reg_field::type_id::create("hw_ringo_dram3_period0",,get_full_name());
        this.hw_ringo_dram3_period0.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram3_period1 = uvm_reg_field::type_id::create("hw_ringo_dram3_period1",,get_full_name());
        this.hw_ringo_dram3_period1.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram3_period_01)
endclass:ral_reg_dram_trim_top_hw_ringo_dram3_period_01

class ral_reg_dram_trim_top_hw_ringo_dram3_period_23 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram3_period2;
    rand uvm_reg_field hw_ringo_dram3_period3;

    function new(string name = "dram_trim_top_hw_ringo_dram3_period_23");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram3_period2 = uvm_reg_field::type_id::create("hw_ringo_dram3_period2",,get_full_name());
        this.hw_ringo_dram3_period2.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram3_period3 = uvm_reg_field::type_id::create("hw_ringo_dram3_period3",,get_full_name());
        this.hw_ringo_dram3_period3.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram3_period_23)
endclass:ral_reg_dram_trim_top_hw_ringo_dram3_period_23

class ral_reg_dram_trim_top_hw_ringo_dram3_period_45 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram3_period4;
    rand uvm_reg_field hw_ringo_dram3_period5;

    function new(string name = "dram_trim_top_hw_ringo_dram3_period_45");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram3_period4 = uvm_reg_field::type_id::create("hw_ringo_dram3_period4",,get_full_name());
        this.hw_ringo_dram3_period4.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram3_period5 = uvm_reg_field::type_id::create("hw_ringo_dram3_period5",,get_full_name());
        this.hw_ringo_dram3_period5.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram3_period_45)
endclass:ral_reg_dram_trim_top_hw_ringo_dram3_period_45

class ral_reg_dram_trim_top_hw_ringo_dram3_period_67 extends uvm_reg;
    rand uvm_reg_field hw_ringo_dram3_period6;
    rand uvm_reg_field hw_ringo_dram3_period7;

    function new(string name = "dram_trim_top_hw_ringo_dram3_period_67");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_dram3_period6 = uvm_reg_field::type_id::create("hw_ringo_dram3_period6",,get_full_name());
        this.hw_ringo_dram3_period6.configure(this,10,0,"RO",0,32'h0,1,0,0);
        this.hw_ringo_dram3_period7 = uvm_reg_field::type_id::create("hw_ringo_dram3_period7",,get_full_name());
        this.hw_ringo_dram3_period7.configure(this,10,16,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_dram3_period_67)
endclass:ral_reg_dram_trim_top_hw_ringo_dram3_period_67

class ral_reg_dram_trim_top_trim_debug0 extends uvm_reg;
    rand uvm_reg_field sw_spine_reset_n_active_cnt_dbg;
    rand uvm_reg_field sw_tm_redump_active_cnt_dbg;
    rand uvm_reg_field sw_stopwatch_period_active_cnt_dbg;
    rand uvm_reg_field trim_start_cnt_dbg;
    rand uvm_reg_field spine_reset_n_dbg;
    rand uvm_reg_field tm_redump_edge_dbg;
    rand uvm_reg_field stopwatch_period_edge_dbg;
    rand uvm_reg_field stopwatch_ringo_edge_dbg;

    function new(string name = "dram_trim_top_trim_debug0");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.sw_spine_reset_n_active_cnt_dbg = uvm_reg_field::type_id::create("sw_spine_reset_n_active_cnt_dbg",,get_full_name());
        this.sw_spine_reset_n_active_cnt_dbg.configure(this,4,0,"RO",0,32'h0,1,0,0);
        this.sw_tm_redump_active_cnt_dbg = uvm_reg_field::type_id::create("sw_tm_redump_active_cnt_dbg",,get_full_name());
        this.sw_tm_redump_active_cnt_dbg.configure(this,4,4,"RO",0,32'h0,1,0,0);
        this.sw_stopwatch_period_active_cnt_dbg = uvm_reg_field::type_id::create("sw_stopwatch_period_active_cnt_dbg",,get_full_name());
        this.sw_stopwatch_period_active_cnt_dbg.configure(this,4,8,"RO",0,32'h0,1,0,0);
        this.trim_start_cnt_dbg = uvm_reg_field::type_id::create("trim_start_cnt_dbg",,get_full_name());
        this.trim_start_cnt_dbg.configure(this,4,12,"RO",0,32'h0,1,0,0);
        this.spine_reset_n_dbg = uvm_reg_field::type_id::create("spine_reset_n_dbg",,get_full_name());
        this.spine_reset_n_dbg.configure(this,4,16,"RO",0,32'h0,1,0,0);
        this.tm_redump_edge_dbg = uvm_reg_field::type_id::create("tm_redump_edge_dbg",,get_full_name());
        this.tm_redump_edge_dbg.configure(this,4,20,"RO",0,32'h0,1,0,0);
        this.stopwatch_period_edge_dbg = uvm_reg_field::type_id::create("stopwatch_period_edge_dbg",,get_full_name());
        this.stopwatch_period_edge_dbg.configure(this,4,24,"RO",0,32'h0,1,0,0);
        this.stopwatch_ringo_edge_dbg = uvm_reg_field::type_id::create("stopwatch_ringo_edge_dbg",,get_full_name());
        this.stopwatch_ringo_edge_dbg.configure(this,4,28,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_trim_debug0)
endclass:ral_reg_dram_trim_top_trim_debug0

class ral_reg_dram_trim_top_trim_debug1 extends uvm_reg;
    rand uvm_reg_field fsm_cs_flag_dbg0;

    function new(string name = "dram_trim_top_trim_debug1");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.fsm_cs_flag_dbg0 = uvm_reg_field::type_id::create("fsm_cs_flag_dbg0",,get_full_name());
        this.fsm_cs_flag_dbg0.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_trim_debug1)
endclass:ral_reg_dram_trim_top_trim_debug1

class ral_reg_dram_trim_top_trim_debug2 extends uvm_reg;
    rand uvm_reg_field fsm_cs_flag_dbg1;
    rand uvm_reg_field fsm_cs_dbg;

    function new(string name = "dram_trim_top_trim_debug2");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.fsm_cs_flag_dbg1 = uvm_reg_field::type_id::create("fsm_cs_flag_dbg1",,get_full_name());
        this.fsm_cs_flag_dbg1.configure(this,1,0,"RO",0,32'h0,1,0,0);
        this.fsm_cs_dbg = uvm_reg_field::type_id::create("fsm_cs_dbg",,get_full_name());
        this.fsm_cs_dbg.configure(this,6,8,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_trim_debug2)
endclass:ral_reg_dram_trim_top_trim_debug2

class ral_reg_dram_trim_top_hw_ringo_period_dly extends uvm_reg;
    rand uvm_reg_field hw_ringo_period_delay;

    function new(string name = "dram_trim_top_hw_ringo_period_dly");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_ringo_period_delay = uvm_reg_field::type_id::create("hw_ringo_period_delay",,get_full_name());
        this.hw_ringo_period_delay.configure(this,14,0,"RW",0,32'h5,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_ringo_period_dly)
endclass:ral_reg_dram_trim_top_hw_ringo_period_dly

class ral_reg_dram_trim_top_hw_period2ringo_dly extends uvm_reg;
    rand uvm_reg_field hw_period2ringo_dly;

    function new(string name = "dram_trim_top_hw_period2ringo_dly");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hw_period2ringo_dly = uvm_reg_field::type_id::create("hw_period2ringo_dly",,get_full_name());
        this.hw_period2ringo_dly.configure(this,10,0,"RW",0,32'h78,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_hw_period2ringo_dly)
endclass:ral_reg_dram_trim_top_hw_period2ringo_dly

class ral_reg_dram_trim_top_res_mode_value_reg extends uvm_reg;
    rand uvm_reg_field res_mode_value;

    function new(string name = "dram_trim_top_res_mode_value_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.res_mode_value = uvm_reg_field::type_id::create("res_mode_value",,get_full_name());
        this.res_mode_value.configure(this,9,0,"RW",0,32'h166,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_res_mode_value_reg)
endclass:ral_reg_dram_trim_top_res_mode_value_reg

class ral_reg_dram_trim_top_ringo_mode_value_reg01 extends uvm_reg;
    rand uvm_reg_field ringo_mode_value_reg0;
    rand uvm_reg_field ringo_mode_value_reg1;

    function new(string name = "dram_trim_top_ringo_mode_value_reg01");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.ringo_mode_value_reg0 = uvm_reg_field::type_id::create("ringo_mode_value_reg0",,get_full_name());
        this.ringo_mode_value_reg0.configure(this,9,0,"RW",0,32'h40,1,0,0);
        this.ringo_mode_value_reg1 = uvm_reg_field::type_id::create("ringo_mode_value_reg1",,get_full_name());
        this.ringo_mode_value_reg1.configure(this,9,16,"RW",0,32'h60,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_ringo_mode_value_reg01)
endclass:ral_reg_dram_trim_top_ringo_mode_value_reg01

class ral_reg_dram_trim_top_ringo_mode_value_reg23 extends uvm_reg;
    rand uvm_reg_field ringo_mode_value_reg2;
    rand uvm_reg_field ringo_mode_value_reg3;

    function new(string name = "dram_trim_top_ringo_mode_value_reg23");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.ringo_mode_value_reg2 = uvm_reg_field::type_id::create("ringo_mode_value_reg2",,get_full_name());
        this.ringo_mode_value_reg2.configure(this,9,0,"RW",0,32'h50,1,0,0);
        this.ringo_mode_value_reg3 = uvm_reg_field::type_id::create("ringo_mode_value_reg3",,get_full_name());
        this.ringo_mode_value_reg3.configure(this,9,16,"RW",0,32'h70,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_ringo_mode_value_reg23)
endclass:ral_reg_dram_trim_top_ringo_mode_value_reg23

class ral_reg_dram_trim_top_ringo_mode_value_reg45 extends uvm_reg;
    rand uvm_reg_field ringo_mode_value_reg4;
    rand uvm_reg_field ringo_mode_value_reg5;

    function new(string name = "dram_trim_top_ringo_mode_value_reg45");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.ringo_mode_value_reg4 = uvm_reg_field::type_id::create("ringo_mode_value_reg4",,get_full_name());
        this.ringo_mode_value_reg4.configure(this,9,0,"RW",0,32'h48,1,0,0);
        this.ringo_mode_value_reg5 = uvm_reg_field::type_id::create("ringo_mode_value_reg5",,get_full_name());
        this.ringo_mode_value_reg5.configure(this,9,16,"RW",0,32'h68,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_ringo_mode_value_reg45)
endclass:ral_reg_dram_trim_top_ringo_mode_value_reg45

class ral_reg_dram_trim_top_ringo_mode_value_reg67 extends uvm_reg;
    rand uvm_reg_field ringo_mode_value_reg6;
    rand uvm_reg_field ringo_mode_value_reg7;

    function new(string name = "dram_trim_top_ringo_mode_value_reg67");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.ringo_mode_value_reg6 = uvm_reg_field::type_id::create("ringo_mode_value_reg6",,get_full_name());
        this.ringo_mode_value_reg6.configure(this,9,0,"RW",0,32'h58,1,0,0);
        this.ringo_mode_value_reg7 = uvm_reg_field::type_id::create("ringo_mode_value_reg7",,get_full_name());
        this.ringo_mode_value_reg7.configure(this,9,16,"RW",0,32'h5A,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_dram_trim_top_ringo_mode_value_reg67)
endclass:ral_reg_dram_trim_top_ringo_mode_value_reg67


class ral_block_dram_trim_top extends uvm_reg_block;

    rand ral_reg_dram_trim_top_trim_ctrl_id trim_ctrl_id;
    rand uvm_reg_field trim_ctrl_id_trim_ctrl_id;
    rand uvm_reg_field trim_ctrl_id;
    rand ral_reg_dram_trim_top_trim_op_ctrl trim_op_ctrl;
    rand uvm_reg_field trim_op_ctrl_spine_resetn_active;
    rand uvm_reg_field spine_resetn_active;
    rand uvm_reg_field trim_op_ctrl_tm_redump_active;
    rand uvm_reg_field tm_redump_active;
    rand uvm_reg_field trim_op_ctrl_stopwatch_period_active;
    rand uvm_reg_field stopwatch_period_active;
    rand uvm_reg_field trim_op_ctrl_trim_start;
    rand uvm_reg_field trim_start;
    rand uvm_reg_field trim_op_ctrl_init_start;
    rand uvm_reg_field init_start;
    rand ral_reg_dram_trim_top_trim_global_ctrl trim_global_ctrl;
    rand uvm_reg_field trim_global_ctrl_trim_op_flow;
    rand uvm_reg_field trim_op_flow;
    rand uvm_reg_field trim_global_ctrl_hw_op_ringo_mask;
    rand uvm_reg_field hw_op_ringo_mask;
    rand uvm_reg_field trim_global_ctrl_hw_op_tsv_load_sel;
    rand uvm_reg_field hw_op_tsv_load_sel;
    rand uvm_reg_field trim_global_ctrl_dram_layer_sel;
    rand uvm_reg_field dram_layer_sel;
    rand uvm_reg_field trim_global_ctrl_res_or_ringo_sel;
    rand uvm_reg_field res_or_ringo_sel;
    rand uvm_reg_field trim_global_ctrl_debug_en;
    rand uvm_reg_field debug_en;
    rand uvm_reg_field trim_global_ctrl_trim_finish;
    rand uvm_reg_field trim_finish;
    rand ral_reg_dram_trim_top_trim_internal_status trim_internal_status;
    rand uvm_reg_field trim_internal_status_spine_resetn_active_ready;
    rand uvm_reg_field spine_resetn_active_ready;
    rand uvm_reg_field trim_internal_status_tm_redump_active_ready;
    rand uvm_reg_field tm_redump_active_ready;
    rand uvm_reg_field trim_internal_status_stopwatch_period_active_ready;
    rand uvm_reg_field stopwatch_period_active_ready;
    rand uvm_reg_field trim_internal_status_init_done_flag;
    rand uvm_reg_field init_done_flag;
    rand uvm_reg_field trim_internal_status_stopwatch_ringo_period_ready;
    rand uvm_reg_field stopwatch_ringo_period_ready;
    rand uvm_reg_field trim_internal_status_dump_ready;
    rand uvm_reg_field dump_ready;
    rand uvm_reg_field trim_internal_status_dumpready_timeout_ready;
    rand uvm_reg_field dumpready_timeout_ready;
    rand ral_reg_dram_trim_top_init_spine_resetn_time init_spine_resetn_time;
    rand uvm_reg_field init_spine_resetn_time_init_spine_reset_time;
    rand uvm_reg_field init_spine_reset_time;
    rand ral_reg_dram_trim_top_spine_resetn_width spine_resetn_width;
    rand uvm_reg_field spine_resetn_width_spine_resetn_width;
    rand uvm_reg_field spine_resetn_width;
    rand ral_reg_dram_trim_top_tm_redump_width tm_redump_width;
    rand uvm_reg_field tm_redump_width_tm_redump_width;
    rand uvm_reg_field tm_redump_width;
    rand ral_reg_dram_trim_top_stopwatch_period_width stopwatch_period_width;
    rand uvm_reg_field stopwatch_period_width_stopwatch_period_width_res;
    rand uvm_reg_field stopwatch_period_width_res;
    rand uvm_reg_field stopwatch_period_width_stopwatch_period_width_ringo;
    rand uvm_reg_field stopwatch_period_width_ringo;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value0 redump_tsv_tm_other_value0;
    rand uvm_reg_field redump_tsv_tm_other_value0_redump_tsv_tm_other_value0;
    rand uvm_reg_field redump_tsv_tm_other_value0;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value1 redump_tsv_tm_other_value1;
    rand uvm_reg_field redump_tsv_tm_other_value1_redump_tsv_tm_other_value1;
    rand uvm_reg_field redump_tsv_tm_other_value1;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value2 redump_tsv_tm_other_value2;
    rand uvm_reg_field redump_tsv_tm_other_value2_redump_tsv_tm_other_value2;
    rand uvm_reg_field redump_tsv_tm_other_value2;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value3 redump_tsv_tm_other_value3;
    rand uvm_reg_field redump_tsv_tm_other_value3_redump_tsv_tm_other_value3;
    rand uvm_reg_field redump_tsv_tm_other_value3;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value4 redump_tsv_tm_other_value4;
    rand uvm_reg_field redump_tsv_tm_other_value4_redump_tsv_tm_other_value4;
    rand uvm_reg_field redump_tsv_tm_other_value4;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value5 redump_tsv_tm_other_value5;
    rand uvm_reg_field redump_tsv_tm_other_value5_redump_tsv_tm_other_value5;
    rand uvm_reg_field redump_tsv_tm_other_value5;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value6 redump_tsv_tm_other_value6;
    rand uvm_reg_field redump_tsv_tm_other_value6_redump_tsv_tm_other_value6;
    rand uvm_reg_field redump_tsv_tm_other_value6;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value7 redump_tsv_tm_other_value7;
    rand uvm_reg_field redump_tsv_tm_other_value7_redump_tsv_tm_other_value7;
    rand uvm_reg_field redump_tsv_tm_other_value7;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value8 redump_tsv_tm_other_value8;
    rand uvm_reg_field redump_tsv_tm_other_value8_redump_tsv_tm_other_value8;
    rand uvm_reg_field redump_tsv_tm_other_value8;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value9 redump_tsv_tm_other_value9;
    rand uvm_reg_field redump_tsv_tm_other_value9_redump_tsv_tm_other_value9;
    rand uvm_reg_field redump_tsv_tm_other_value9;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value10 redump_tsv_tm_other_value10;
    rand uvm_reg_field redump_tsv_tm_other_value10_redump_tsv_tm_other_value10;
    rand uvm_reg_field redump_tsv_tm_other_value10;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value11 redump_tsv_tm_other_value11;
    rand uvm_reg_field redump_tsv_tm_other_value11_redump_tsv_tm_other_value11;
    rand uvm_reg_field redump_tsv_tm_other_value11;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value12 redump_tsv_tm_other_value12;
    rand uvm_reg_field redump_tsv_tm_other_value12_redump_tsv_tm_other_value12;
    rand uvm_reg_field redump_tsv_tm_other_value12;
    rand ral_reg_dram_trim_top_redump_tsv_tm_other_value13 redump_tsv_tm_other_value13;
    rand uvm_reg_field redump_tsv_tm_other_value13_redump_tsv_tm_other_value13;
    rand uvm_reg_field redump_tsv_tm_other_value13;
    rand ral_reg_dram_trim_top_osc_tm_res_smp_value osc_tm_res_smp_value;
    rand uvm_reg_field osc_tm_res_smp_value_osc_tm_res_smp_value;
    rand uvm_reg_field osc_tm_res_smp_value;
    rand uvm_reg_field osc_tm_res_smp_value_osc_tm_res_smp_ready;
    rand uvm_reg_field osc_tm_res_smp_ready;
    rand ral_reg_dram_trim_top_stopwatch_ringo_period_01 stopwatch_ringo_period_01;
    rand uvm_reg_field stopwatch_ringo_period_01_stopwatch_ringo_period0;
    rand uvm_reg_field stopwatch_ringo_period0;
    rand uvm_reg_field stopwatch_ringo_period_01_stopwatch_ringo_period1;
    rand uvm_reg_field stopwatch_ringo_period1;
    rand ral_reg_dram_trim_top_stopwatch_ringo_period_23 stopwatch_ringo_period_23;
    rand uvm_reg_field stopwatch_ringo_period_23_stopwatch_ringo_period2;
    rand uvm_reg_field stopwatch_ringo_period2;
    rand uvm_reg_field stopwatch_ringo_period_23_stopwatch_ringo_period3;
    rand uvm_reg_field stopwatch_ringo_period3;
    rand ral_reg_dram_trim_top_dumpready_timeout_ctrl dumpready_timeout_ctrl;
    rand uvm_reg_field dumpready_timeout_ctrl_dumpready_timeout_en;
    rand uvm_reg_field dumpready_timeout_en;
    rand uvm_reg_field dumpready_timeout_ctrl_dumpready_timeout_clr;
    rand uvm_reg_field dumpready_timeout_clr;
    rand uvm_reg_field dumpready_timeout_ctrl_dumpready_timeout_flag;
    rand uvm_reg_field dumpready_timeout_flag;
    rand uvm_reg_field dumpready_timeout_ctrl_dumpready_timeout_time;
    rand uvm_reg_field dumpready_timeout_time;
    rand ral_reg_dram_trim_top_ringo_timeout_ctrl ringo_timeout_ctrl;
    rand uvm_reg_field ringo_timeout_ctrl_ringo_timeout_en;
    rand uvm_reg_field ringo_timeout_en;
    rand uvm_reg_field ringo_timeout_ctrl_ringo_timeout_clr;
    rand uvm_reg_field ringo_timeout_clr;
    rand uvm_reg_field ringo_timeout_ctrl_ringo_timeout_flag;
    rand uvm_reg_field ringo_timeout_flag;
    rand uvm_reg_field ringo_timeout_ctrl_ringo_timeout_time;
    rand uvm_reg_field ringo_timeout_time;
    rand ral_reg_dram_trim_top_res_value_ctrl res_value_ctrl;
    rand uvm_reg_field res_value_ctrl_res_value_sel;
    rand uvm_reg_field res_value_sel;
    rand uvm_reg_field res_value_ctrl_res_cfg_value;
    rand uvm_reg_field res_cfg_value;
    rand ral_reg_dram_trim_top_trim_interrupt_ctrl trim_interrupt_ctrl;
    rand uvm_reg_field trim_interrupt_ctrl_trim_interrupt_clr;
    rand uvm_reg_field trim_interrupt_clr;
    rand uvm_reg_field trim_interrupt_ctrl_trim_interrupt_mask;
    rand uvm_reg_field trim_interrupt_mask;
    rand uvm_reg_field trim_interrupt_ctrl_trim_interrupt_flag;
    rand uvm_reg_field trim_interrupt_flag;
    rand ral_reg_dram_trim_top_hw_ringo_dram0_period_01 hw_ringo_dram0_period_01;
    rand uvm_reg_field hw_ringo_dram0_period_01_hw_ringo_dram0_period0;
    rand uvm_reg_field hw_ringo_dram0_period0;
    rand uvm_reg_field hw_ringo_dram0_period_01_hw_ringo_dram0_period1;
    rand uvm_reg_field hw_ringo_dram0_period1;
    rand ral_reg_dram_trim_top_hw_ringo_dram0_period_23 hw_ringo_dram0_period_23;
    rand uvm_reg_field hw_ringo_dram0_period_23_hw_ringo_dram0_period2;
    rand uvm_reg_field hw_ringo_dram0_period2;
    rand uvm_reg_field hw_ringo_dram0_period_23_hw_ringo_dram0_period3;
    rand uvm_reg_field hw_ringo_dram0_period3;
    rand ral_reg_dram_trim_top_hw_ringo_dram0_period_45 hw_ringo_dram0_period_45;
    rand uvm_reg_field hw_ringo_dram0_period_45_hw_ringo_dram0_period4;
    rand uvm_reg_field hw_ringo_dram0_period4;
    rand uvm_reg_field hw_ringo_dram0_period_45_hw_ringo_dram0_period5;
    rand uvm_reg_field hw_ringo_dram0_period5;
    rand ral_reg_dram_trim_top_hw_ringo_dram0_period_67 hw_ringo_dram0_period_67;
    rand uvm_reg_field hw_ringo_dram0_period_67_hw_ringo_dram0_period6;
    rand uvm_reg_field hw_ringo_dram0_period6;
    rand uvm_reg_field hw_ringo_dram0_period_67_hw_ringo_dram0_period7;
    rand uvm_reg_field hw_ringo_dram0_period7;
    rand ral_reg_dram_trim_top_hw_ringo_dram1_period_01 hw_ringo_dram1_period_01;
    rand uvm_reg_field hw_ringo_dram1_period_01_hw_ringo_dram1_period0;
    rand uvm_reg_field hw_ringo_dram1_period0;
    rand uvm_reg_field hw_ringo_dram1_period_01_hw_ringo_dram1_period1;
    rand uvm_reg_field hw_ringo_dram1_period1;
    rand ral_reg_dram_trim_top_hw_ringo_dram1_period_23 hw_ringo_dram1_period_23;
    rand uvm_reg_field hw_ringo_dram1_period_23_hw_ringo_dram1_period2;
    rand uvm_reg_field hw_ringo_dram1_period2;
    rand uvm_reg_field hw_ringo_dram1_period_23_hw_ringo_dram1_period3;
    rand uvm_reg_field hw_ringo_dram1_period3;
    rand ral_reg_dram_trim_top_hw_ringo_dram1_period_45 hw_ringo_dram1_period_45;
    rand uvm_reg_field hw_ringo_dram1_period_45_hw_ringo_dram1_period4;
    rand uvm_reg_field hw_ringo_dram1_period4;
    rand uvm_reg_field hw_ringo_dram1_period_45_hw_ringo_dram1_period5;
    rand uvm_reg_field hw_ringo_dram1_period5;
    rand ral_reg_dram_trim_top_hw_ringo_dram1_period_67 hw_ringo_dram1_period_67;
    rand uvm_reg_field hw_ringo_dram1_period_67_hw_ringo_dram1_period6;
    rand uvm_reg_field hw_ringo_dram1_period6;
    rand uvm_reg_field hw_ringo_dram1_period_67_hw_ringo_dram1_period7;
    rand uvm_reg_field hw_ringo_dram1_period7;
    rand ral_reg_dram_trim_top_hw_ringo_dram2_period_01 hw_ringo_dram2_period_01;
    rand uvm_reg_field hw_ringo_dram2_period_01_hw_ringo_dram2_period0;
    rand uvm_reg_field hw_ringo_dram2_period0;
    rand uvm_reg_field hw_ringo_dram2_period_01_hw_ringo_dram2_period1;
    rand uvm_reg_field hw_ringo_dram2_period1;
    rand ral_reg_dram_trim_top_hw_ringo_dram2_period_23 hw_ringo_dram2_period_23;
    rand uvm_reg_field hw_ringo_dram2_period_23_hw_ringo_dram2_period2;
    rand uvm_reg_field hw_ringo_dram2_period2;
    rand uvm_reg_field hw_ringo_dram2_period_23_hw_ringo_dram2_period3;
    rand uvm_reg_field hw_ringo_dram2_period3;
    rand ral_reg_dram_trim_top_hw_ringo_dram2_period_45 hw_ringo_dram2_period_45;
    rand uvm_reg_field hw_ringo_dram2_period_45_hw_ringo_dram2_period4;
    rand uvm_reg_field hw_ringo_dram2_period4;
    rand uvm_reg_field hw_ringo_dram2_period_45_hw_ringo_dram2_period5;
    rand uvm_reg_field hw_ringo_dram2_period5;
    rand ral_reg_dram_trim_top_hw_ringo_dram2_period_67 hw_ringo_dram2_period_67;
    rand uvm_reg_field hw_ringo_dram2_period_67_hw_ringo_dram2_period6;
    rand uvm_reg_field hw_ringo_dram2_period6;
    rand uvm_reg_field hw_ringo_dram2_period_67_hw_ringo_dram2_period7;
    rand uvm_reg_field hw_ringo_dram2_period7;
    rand ral_reg_dram_trim_top_hw_ringo_dram3_period_01 hw_ringo_dram3_period_01;
    rand uvm_reg_field hw_ringo_dram3_period_01_hw_ringo_dram3_period0;
    rand uvm_reg_field hw_ringo_dram3_period0;
    rand uvm_reg_field hw_ringo_dram3_period_01_hw_ringo_dram3_period1;
    rand uvm_reg_field hw_ringo_dram3_period1;
    rand ral_reg_dram_trim_top_hw_ringo_dram3_period_23 hw_ringo_dram3_period_23;
    rand uvm_reg_field hw_ringo_dram3_period_23_hw_ringo_dram3_period2;
    rand uvm_reg_field hw_ringo_dram3_period2;
    rand uvm_reg_field hw_ringo_dram3_period_23_hw_ringo_dram3_period3;
    rand uvm_reg_field hw_ringo_dram3_period3;
    rand ral_reg_dram_trim_top_hw_ringo_dram3_period_45 hw_ringo_dram3_period_45;
    rand uvm_reg_field hw_ringo_dram3_period_45_hw_ringo_dram3_period4;
    rand uvm_reg_field hw_ringo_dram3_period4;
    rand uvm_reg_field hw_ringo_dram3_period_45_hw_ringo_dram3_period5;
    rand uvm_reg_field hw_ringo_dram3_period5;
    rand ral_reg_dram_trim_top_hw_ringo_dram3_period_67 hw_ringo_dram3_period_67;
    rand uvm_reg_field hw_ringo_dram3_period_67_hw_ringo_dram3_period6;
    rand uvm_reg_field hw_ringo_dram3_period6;
    rand uvm_reg_field hw_ringo_dram3_period_67_hw_ringo_dram3_period7;
    rand uvm_reg_field hw_ringo_dram3_period7;
    rand ral_reg_dram_trim_top_trim_debug0 trim_debug0;
    rand uvm_reg_field trim_debug0_sw_spine_reset_n_active_cnt_dbg;
    rand uvm_reg_field sw_spine_reset_n_active_cnt_dbg;
    rand uvm_reg_field trim_debug0_sw_tm_redump_active_cnt_dbg;
    rand uvm_reg_field sw_tm_redump_active_cnt_dbg;
    rand uvm_reg_field trim_debug0_sw_stopwatch_period_active_cnt_dbg;
    rand uvm_reg_field sw_stopwatch_period_active_cnt_dbg;
    rand uvm_reg_field trim_debug0_trim_start_cnt_dbg;
    rand uvm_reg_field trim_start_cnt_dbg;
    rand uvm_reg_field trim_debug0_spine_reset_n_dbg;
    rand uvm_reg_field spine_reset_n_dbg;
    rand uvm_reg_field trim_debug0_tm_redump_edge_dbg;
    rand uvm_reg_field tm_redump_edge_dbg;
    rand uvm_reg_field trim_debug0_stopwatch_period_edge_dbg;
    rand uvm_reg_field stopwatch_period_edge_dbg;
    rand uvm_reg_field trim_debug0_stopwatch_ringo_edge_dbg;
    rand uvm_reg_field stopwatch_ringo_edge_dbg;
    rand ral_reg_dram_trim_top_trim_debug1 trim_debug1;
    rand uvm_reg_field trim_debug1_fsm_cs_flag_dbg0;
    rand uvm_reg_field fsm_cs_flag_dbg0;
    rand ral_reg_dram_trim_top_trim_debug2 trim_debug2;
    rand uvm_reg_field trim_debug2_fsm_cs_flag_dbg1;
    rand uvm_reg_field fsm_cs_flag_dbg1;
    rand uvm_reg_field trim_debug2_fsm_cs_dbg;
    rand uvm_reg_field fsm_cs_dbg;
    rand ral_reg_dram_trim_top_hw_ringo_period_dly hw_ringo_period_dly;
    rand uvm_reg_field hw_ringo_period_dly_hw_ringo_period_delay;
    rand uvm_reg_field hw_ringo_period_delay;
    rand ral_reg_dram_trim_top_hw_period2ringo_dly hw_period2ringo_dly;
    rand uvm_reg_field hw_period2ringo_dly_hw_period2ringo_dly;
    rand uvm_reg_field hw_period2ringo_dly;
    rand ral_reg_dram_trim_top_res_mode_value_reg res_mode_value_reg;
    rand uvm_reg_field res_mode_value_reg_res_mode_value;
    rand uvm_reg_field res_mode_value;
    rand ral_reg_dram_trim_top_ringo_mode_value_reg01 ringo_mode_value_reg01;
    rand uvm_reg_field ringo_mode_value_reg01_ringo_mode_value_reg0;
    rand uvm_reg_field ringo_mode_value_reg0;
    rand uvm_reg_field ringo_mode_value_reg01_ringo_mode_value_reg1;
    rand uvm_reg_field ringo_mode_value_reg1;
    rand ral_reg_dram_trim_top_ringo_mode_value_reg23 ringo_mode_value_reg23;
    rand uvm_reg_field ringo_mode_value_reg23_ringo_mode_value_reg2;
    rand uvm_reg_field ringo_mode_value_reg2;
    rand uvm_reg_field ringo_mode_value_reg23_ringo_mode_value_reg3;
    rand uvm_reg_field ringo_mode_value_reg3;
    rand ral_reg_dram_trim_top_ringo_mode_value_reg45 ringo_mode_value_reg45;
    rand uvm_reg_field ringo_mode_value_reg45_ringo_mode_value_reg4;
    rand uvm_reg_field ringo_mode_value_reg4;
    rand uvm_reg_field ringo_mode_value_reg45_ringo_mode_value_reg5;
    rand uvm_reg_field ringo_mode_value_reg5;
    rand ral_reg_dram_trim_top_ringo_mode_value_reg67 ringo_mode_value_reg67;
    rand uvm_reg_field ringo_mode_value_reg67_ringo_mode_value_reg6;
    rand uvm_reg_field ringo_mode_value_reg6;
    rand uvm_reg_field ringo_mode_value_reg67_ringo_mode_value_reg7;
    rand uvm_reg_field ringo_mode_value_reg7;

    function new(string name = "ral_block_dram_trim_top");
        super.new(name,build_coverage(UVM_NO_COVERAGE));
    endfunction: new


    virtual function void build();
        this.default_map = create_map("",0,4,UVM_LITTLE_ENDIAN, 0);

        this.trim_ctrl_id = ral_reg_dram_trim_top_trim_ctrl_id::type_id::create("trim_ctrl_id",,get_full_name());
        this.trim_ctrl_id.configure(this, null, "");
        this.trim_ctrl_id.build();
        this.default_map.add_reg(this.trim_ctrl_id, `UVM_REG_ADDR_WIDTH'h00000000,"RW",0);
            this.trim_ctrl_id_trim_ctrl_id = this.trim_ctrl_id.trim_ctrl_id;

        this.trim_op_ctrl = ral_reg_dram_trim_top_trim_op_ctrl::type_id::create("trim_op_ctrl",,get_full_name());
        this.trim_op_ctrl.configure(this, null, "");
        this.trim_op_ctrl.build();
        this.default_map.add_reg(this.trim_op_ctrl, `UVM_REG_ADDR_WIDTH'h00000004,"RW",0);
            this.trim_op_ctrl_spine_resetn_active = this.trim_op_ctrl.spine_resetn_active;
            this.spine_resetn_active = this.trim_op_ctrl.spine_resetn_active;

            this.trim_op_ctrl_tm_redump_active = this.trim_op_ctrl.tm_redump_active;
            this.tm_redump_active = this.trim_op_ctrl.tm_redump_active;

            this.trim_op_ctrl_stopwatch_period_active = this.trim_op_ctrl.stopwatch_period_active;
            this.stopwatch_period_active = this.trim_op_ctrl.stopwatch_period_active;

            this.trim_op_ctrl_trim_start = this.trim_op_ctrl.trim_start;
            this.trim_start = this.trim_op_ctrl.trim_start;

            this.trim_op_ctrl_init_start = this.trim_op_ctrl.init_start;
            this.init_start = this.trim_op_ctrl.init_start;

        this.trim_global_ctrl = ral_reg_dram_trim_top_trim_global_ctrl::type_id::create("trim_global_ctrl",,get_full_name());
        this.trim_global_ctrl.configure(this, null, "");
        this.trim_global_ctrl.build();
        this.default_map.add_reg(this.trim_global_ctrl, `UVM_REG_ADDR_WIDTH'h00000008,"RW",0);
            this.trim_global_ctrl_trim_op_flow = this.trim_global_ctrl.trim_op_flow;
            this.trim_op_flow = this.trim_global_ctrl.trim_op_flow;

            this.trim_global_ctrl_hw_op_ringo_mask = this.trim_global_ctrl.hw_op_ringo_mask;
            this.hw_op_ringo_mask = this.trim_global_ctrl.hw_op_ringo_mask;

            this.trim_global_ctrl_hw_op_tsv_load_sel = this.trim_global_ctrl.hw_op_tsv_load_sel;
            this.hw_op_tsv_load_sel = this.trim_global_ctrl.hw_op_tsv_load_sel;

            this.trim_global_ctrl_dram_layer_sel = this.trim_global_ctrl.dram_layer_sel;
            this.dram_layer_sel = this.trim_global_ctrl.dram_layer_sel;

            this.trim_global_ctrl_res_or_ringo_sel = this.trim_global_ctrl.res_or_ringo_sel;
            this.res_or_ringo_sel = this.trim_global_ctrl.res_or_ringo_sel;

            this.trim_global_ctrl_debug_en = this.trim_global_ctrl.debug_en;
            this.debug_en = this.trim_global_ctrl.debug_en;

            this.trim_global_ctrl_trim_finish = this.trim_global_ctrl.trim_finish;
            this.trim_finish = this.trim_global_ctrl.trim_finish;

        this.trim_internal_status = ral_reg_dram_trim_top_trim_internal_status::type_id::create("trim_internal_status",,get_full_name());
        this.trim_internal_status.configure(this, null, "");
        this.trim_internal_status.build();
        this.default_map.add_reg(this.trim_internal_status, `UVM_REG_ADDR_WIDTH'h0000000C,"RW",0);
            this.trim_internal_status_spine_resetn_active_ready = this.trim_internal_status.spine_resetn_active_ready;
            this.spine_resetn_active_ready = this.trim_internal_status.spine_resetn_active_ready;

            this.trim_internal_status_tm_redump_active_ready = this.trim_internal_status.tm_redump_active_ready;
            this.tm_redump_active_ready = this.trim_internal_status.tm_redump_active_ready;

            this.trim_internal_status_stopwatch_period_active_ready = this.trim_internal_status.stopwatch_period_active_ready;
            this.stopwatch_period_active_ready = this.trim_internal_status.stopwatch_period_active_ready;

            this.trim_internal_status_init_done_flag = this.trim_internal_status.init_done_flag;
            this.init_done_flag = this.trim_internal_status.init_done_flag;

            this.trim_internal_status_stopwatch_ringo_period_ready = this.trim_internal_status.stopwatch_ringo_period_ready;
            this.stopwatch_ringo_period_ready = this.trim_internal_status.stopwatch_ringo_period_ready;

            this.trim_internal_status_dump_ready = this.trim_internal_status.dump_ready;
            this.dump_ready = this.trim_internal_status.dump_ready;

            this.trim_internal_status_dumpready_timeout_ready = this.trim_internal_status.dumpready_timeout_ready;
            this.dumpready_timeout_ready = this.trim_internal_status.dumpready_timeout_ready;

        this.init_spine_resetn_time = ral_reg_dram_trim_top_init_spine_resetn_time::type_id::create("init_spine_resetn_time",,get_full_name());
        this.init_spine_resetn_time.configure(this, null, "");
        this.init_spine_resetn_time.build();
        this.default_map.add_reg(this.init_spine_resetn_time, `UVM_REG_ADDR_WIDTH'h00000010,"RW",0);
            this.init_spine_resetn_time_init_spine_reset_time = this.init_spine_resetn_time.init_spine_reset_time;
            this.init_spine_reset_time = this.init_spine_resetn_time.init_spine_reset_time;

        this.spine_resetn_width = ral_reg_dram_trim_top_spine_resetn_width::type_id::create("spine_resetn_width",,get_full_name());
        this.spine_resetn_width.configure(this, null, "");
        this.spine_resetn_width.build();
        this.default_map.add_reg(this.spine_resetn_width, `UVM_REG_ADDR_WIDTH'h00000014,"RW",0);
            this.spine_resetn_width_spine_resetn_width = this.spine_resetn_width.spine_resetn_width;

        this.tm_redump_width = ral_reg_dram_trim_top_tm_redump_width::type_id::create("tm_redump_width",,get_full_name());
        this.tm_redump_width.configure(this, null, "");
        this.tm_redump_width.build();
        this.default_map.add_reg(this.tm_redump_width, `UVM_REG_ADDR_WIDTH'h00000018,"RW",0);
            this.tm_redump_width_tm_redump_width = this.tm_redump_width.tm_redump_width;

        this.stopwatch_period_width = ral_reg_dram_trim_top_stopwatch_period_width::type_id::create("stopwatch_period_width",,get_full_name());
        this.stopwatch_period_width.configure(this, null, "");
        this.stopwatch_period_width.build();
        this.default_map.add_reg(this.stopwatch_period_width, `UVM_REG_ADDR_WIDTH'h0000001C,"RW",0);
            this.stopwatch_period_width_stopwatch_period_width_res = this.stopwatch_period_width.stopwatch_period_width_res;
            this.stopwatch_period_width_res = this.stopwatch_period_width.stopwatch_period_width_res;

            this.stopwatch_period_width_stopwatch_period_width_ringo = this.stopwatch_period_width.stopwatch_period_width_ringo;
            this.stopwatch_period_width_ringo = this.stopwatch_period_width.stopwatch_period_width_ringo;

        this.redump_tsv_tm_other_value0 = ral_reg_dram_trim_top_redump_tsv_tm_other_value0::type_id::create("redump_tsv_tm_other_value0",,get_full_name());
        this.redump_tsv_tm_other_value0.configure(this, null, "");
        this.redump_tsv_tm_other_value0.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value0, `UVM_REG_ADDR_WIDTH'h00000020,"RW",0);
            this.redump_tsv_tm_other_value0_redump_tsv_tm_other_value0 = this.redump_tsv_tm_other_value0.redump_tsv_tm_other_value0;

        this.redump_tsv_tm_other_value1 = ral_reg_dram_trim_top_redump_tsv_tm_other_value1::type_id::create("redump_tsv_tm_other_value1",,get_full_name());
        this.redump_tsv_tm_other_value1.configure(this, null, "");
        this.redump_tsv_tm_other_value1.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value1, `UVM_REG_ADDR_WIDTH'h00000024,"RW",0);
            this.redump_tsv_tm_other_value1_redump_tsv_tm_other_value1 = this.redump_tsv_tm_other_value1.redump_tsv_tm_other_value1;

        this.redump_tsv_tm_other_value2 = ral_reg_dram_trim_top_redump_tsv_tm_other_value2::type_id::create("redump_tsv_tm_other_value2",,get_full_name());
        this.redump_tsv_tm_other_value2.configure(this, null, "");
        this.redump_tsv_tm_other_value2.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value2, `UVM_REG_ADDR_WIDTH'h00000028,"RW",0);
            this.redump_tsv_tm_other_value2_redump_tsv_tm_other_value2 = this.redump_tsv_tm_other_value2.redump_tsv_tm_other_value2;

        this.redump_tsv_tm_other_value3 = ral_reg_dram_trim_top_redump_tsv_tm_other_value3::type_id::create("redump_tsv_tm_other_value3",,get_full_name());
        this.redump_tsv_tm_other_value3.configure(this, null, "");
        this.redump_tsv_tm_other_value3.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value3, `UVM_REG_ADDR_WIDTH'h0000002C,"RW",0);
            this.redump_tsv_tm_other_value3_redump_tsv_tm_other_value3 = this.redump_tsv_tm_other_value3.redump_tsv_tm_other_value3;

        this.redump_tsv_tm_other_value4 = ral_reg_dram_trim_top_redump_tsv_tm_other_value4::type_id::create("redump_tsv_tm_other_value4",,get_full_name());
        this.redump_tsv_tm_other_value4.configure(this, null, "");
        this.redump_tsv_tm_other_value4.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value4, `UVM_REG_ADDR_WIDTH'h00000030,"RW",0);
            this.redump_tsv_tm_other_value4_redump_tsv_tm_other_value4 = this.redump_tsv_tm_other_value4.redump_tsv_tm_other_value4;

        this.redump_tsv_tm_other_value5 = ral_reg_dram_trim_top_redump_tsv_tm_other_value5::type_id::create("redump_tsv_tm_other_value5",,get_full_name());
        this.redump_tsv_tm_other_value5.configure(this, null, "");
        this.redump_tsv_tm_other_value5.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value5, `UVM_REG_ADDR_WIDTH'h00000034,"RW",0);
            this.redump_tsv_tm_other_value5_redump_tsv_tm_other_value5 = this.redump_tsv_tm_other_value5.redump_tsv_tm_other_value5;

        this.redump_tsv_tm_other_value6 = ral_reg_dram_trim_top_redump_tsv_tm_other_value6::type_id::create("redump_tsv_tm_other_value6",,get_full_name());
        this.redump_tsv_tm_other_value6.configure(this, null, "");
        this.redump_tsv_tm_other_value6.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value6, `UVM_REG_ADDR_WIDTH'h00000038,"RW",0);
            this.redump_tsv_tm_other_value6_redump_tsv_tm_other_value6 = this.redump_tsv_tm_other_value6.redump_tsv_tm_other_value6;

        this.redump_tsv_tm_other_value7 = ral_reg_dram_trim_top_redump_tsv_tm_other_value7::type_id::create("redump_tsv_tm_other_value7",,get_full_name());
        this.redump_tsv_tm_other_value7.configure(this, null, "");
        this.redump_tsv_tm_other_value7.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value7, `UVM_REG_ADDR_WIDTH'h0000003C,"RW",0);
            this.redump_tsv_tm_other_value7_redump_tsv_tm_other_value7 = this.redump_tsv_tm_other_value7.redump_tsv_tm_other_value7;

        this.redump_tsv_tm_other_value8 = ral_reg_dram_trim_top_redump_tsv_tm_other_value8::type_id::create("redump_tsv_tm_other_value8",,get_full_name());
        this.redump_tsv_tm_other_value8.configure(this, null, "");
        this.redump_tsv_tm_other_value8.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value8, `UVM_REG_ADDR_WIDTH'h00000040,"RW",0);
            this.redump_tsv_tm_other_value8_redump_tsv_tm_other_value8 = this.redump_tsv_tm_other_value8.redump_tsv_tm_other_value8;

        this.redump_tsv_tm_other_value9 = ral_reg_dram_trim_top_redump_tsv_tm_other_value9::type_id::create("redump_tsv_tm_other_value9",,get_full_name());
        this.redump_tsv_tm_other_value9.configure(this, null, "");
        this.redump_tsv_tm_other_value9.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value9, `UVM_REG_ADDR_WIDTH'h00000044,"RW",0);
            this.redump_tsv_tm_other_value9_redump_tsv_tm_other_value9 = this.redump_tsv_tm_other_value9.redump_tsv_tm_other_value9;

        this.redump_tsv_tm_other_value10 = ral_reg_dram_trim_top_redump_tsv_tm_other_value10::type_id::create("redump_tsv_tm_other_value10",,get_full_name());
        this.redump_tsv_tm_other_value10.configure(this, null, "");
        this.redump_tsv_tm_other_value10.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value10, `UVM_REG_ADDR_WIDTH'h00000048,"RW",0);
            this.redump_tsv_tm_other_value10_redump_tsv_tm_other_value10 = this.redump_tsv_tm_other_value10.redump_tsv_tm_other_value10;

        this.redump_tsv_tm_other_value11 = ral_reg_dram_trim_top_redump_tsv_tm_other_value11::type_id::create("redump_tsv_tm_other_value11",,get_full_name());
        this.redump_tsv_tm_other_value11.configure(this, null, "");
        this.redump_tsv_tm_other_value11.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value11, `UVM_REG_ADDR_WIDTH'h0000004C,"RW",0);
            this.redump_tsv_tm_other_value11_redump_tsv_tm_other_value11 = this.redump_tsv_tm_other_value11.redump_tsv_tm_other_value11;

        this.redump_tsv_tm_other_value12 = ral_reg_dram_trim_top_redump_tsv_tm_other_value12::type_id::create("redump_tsv_tm_other_value12",,get_full_name());
        this.redump_tsv_tm_other_value12.configure(this, null, "");
        this.redump_tsv_tm_other_value12.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value12, `UVM_REG_ADDR_WIDTH'h00000050,"RW",0);
            this.redump_tsv_tm_other_value12_redump_tsv_tm_other_value12 = this.redump_tsv_tm_other_value12.redump_tsv_tm_other_value12;

        this.redump_tsv_tm_other_value13 = ral_reg_dram_trim_top_redump_tsv_tm_other_value13::type_id::create("redump_tsv_tm_other_value13",,get_full_name());
        this.redump_tsv_tm_other_value13.configure(this, null, "");
        this.redump_tsv_tm_other_value13.build();
        this.default_map.add_reg(this.redump_tsv_tm_other_value13, `UVM_REG_ADDR_WIDTH'h00000054,"RW",0);
            this.redump_tsv_tm_other_value13_redump_tsv_tm_other_value13 = this.redump_tsv_tm_other_value13.redump_tsv_tm_other_value13;

        this.osc_tm_res_smp_value = ral_reg_dram_trim_top_osc_tm_res_smp_value::type_id::create("osc_tm_res_smp_value",,get_full_name());
        this.osc_tm_res_smp_value.configure(this, null, "");
        this.osc_tm_res_smp_value.build();
        this.default_map.add_reg(this.osc_tm_res_smp_value, `UVM_REG_ADDR_WIDTH'h00000058,"RW",0);
            this.osc_tm_res_smp_value_osc_tm_res_smp_value = this.osc_tm_res_smp_value.osc_tm_res_smp_value;

            this.osc_tm_res_smp_value_osc_tm_res_smp_ready = this.osc_tm_res_smp_value.osc_tm_res_smp_ready;
            this.osc_tm_res_smp_ready = this.osc_tm_res_smp_value.osc_tm_res_smp_ready;

        this.stopwatch_ringo_period_01 = ral_reg_dram_trim_top_stopwatch_ringo_period_01::type_id::create("stopwatch_ringo_period_01",,get_full_name());
        this.stopwatch_ringo_period_01.configure(this, null, "");
        this.stopwatch_ringo_period_01.build();
        this.default_map.add_reg(this.stopwatch_ringo_period_01, `UVM_REG_ADDR_WIDTH'h0000005C,"RW",0);
            this.stopwatch_ringo_period_01_stopwatch_ringo_period0 = this.stopwatch_ringo_period_01.stopwatch_ringo_period0;
            this.stopwatch_ringo_period0 = this.stopwatch_ringo_period_01.stopwatch_ringo_period0;

            this.stopwatch_ringo_period_01_stopwatch_ringo_period1 = this.stopwatch_ringo_period_01.stopwatch_ringo_period1;
            this.stopwatch_ringo_period1 = this.stopwatch_ringo_period_01.stopwatch_ringo_period1;

        this.stopwatch_ringo_period_23 = ral_reg_dram_trim_top_stopwatch_ringo_period_23::type_id::create("stopwatch_ringo_period_23",,get_full_name());
        this.stopwatch_ringo_period_23.configure(this, null, "");
        this.stopwatch_ringo_period_23.build();
        this.default_map.add_reg(this.stopwatch_ringo_period_23, `UVM_REG_ADDR_WIDTH'h00000060,"RW",0);
            this.stopwatch_ringo_period_23_stopwatch_ringo_period2 = this.stopwatch_ringo_period_23.stopwatch_ringo_period2;
            this.stopwatch_ringo_period2 = this.stopwatch_ringo_period_23.stopwatch_ringo_period2;

            this.stopwatch_ringo_period_23_stopwatch_ringo_period3 = this.stopwatch_ringo_period_23.stopwatch_ringo_period3;
            this.stopwatch_ringo_period3 = this.stopwatch_ringo_period_23.stopwatch_ringo_period3;

        this.dumpready_timeout_ctrl = ral_reg_dram_trim_top_dumpready_timeout_ctrl::type_id::create("dumpready_timeout_ctrl",,get_full_name());
        this.dumpready_timeout_ctrl.configure(this, null, "");
        this.dumpready_timeout_ctrl.build();
        this.default_map.add_reg(this.dumpready_timeout_ctrl, `UVM_REG_ADDR_WIDTH'h00000064,"RW",0);
            this.dumpready_timeout_ctrl_dumpready_timeout_en = this.dumpready_timeout_ctrl.dumpready_timeout_en;
            this.dumpready_timeout_en = this.dumpready_timeout_ctrl.dumpready_timeout_en;

            this.dumpready_timeout_ctrl_dumpready_timeout_clr = this.dumpready_timeout_ctrl.dumpready_timeout_clr;
            this.dumpready_timeout_clr = this.dumpready_timeout_ctrl.dumpready_timeout_clr;

            this.dumpready_timeout_ctrl_dumpready_timeout_flag = this.dumpready_timeout_ctrl.dumpready_timeout_flag;
            this.dumpready_timeout_flag = this.dumpready_timeout_ctrl.dumpready_timeout_flag;

            this.dumpready_timeout_ctrl_dumpready_timeout_time = this.dumpready_timeout_ctrl.dumpready_timeout_time;
            this.dumpready_timeout_time = this.dumpready_timeout_ctrl.dumpready_timeout_time;

        this.ringo_timeout_ctrl = ral_reg_dram_trim_top_ringo_timeout_ctrl::type_id::create("ringo_timeout_ctrl",,get_full_name());
        this.ringo_timeout_ctrl.configure(this, null, "");
        this.ringo_timeout_ctrl.build();
        this.default_map.add_reg(this.ringo_timeout_ctrl, `UVM_REG_ADDR_WIDTH'h00000068,"RW",0);
            this.ringo_timeout_ctrl_ringo_timeout_en = this.ringo_timeout_ctrl.ringo_timeout_en;
            this.ringo_timeout_en = this.ringo_timeout_ctrl.ringo_timeout_en;

            this.ringo_timeout_ctrl_ringo_timeout_clr = this.ringo_timeout_ctrl.ringo_timeout_clr;
            this.ringo_timeout_clr = this.ringo_timeout_ctrl.ringo_timeout_clr;

            this.ringo_timeout_ctrl_ringo_timeout_flag = this.ringo_timeout_ctrl.ringo_timeout_flag;
            this.ringo_timeout_flag = this.ringo_timeout_ctrl.ringo_timeout_flag;

            this.ringo_timeout_ctrl_ringo_timeout_time = this.ringo_timeout_ctrl.ringo_timeout_time;
            this.ringo_timeout_time = this.ringo_timeout_ctrl.ringo_timeout_time;

        this.res_value_ctrl = ral_reg_dram_trim_top_res_value_ctrl::type_id::create("res_value_ctrl",,get_full_name());
        this.res_value_ctrl.configure(this, null, "");
        this.res_value_ctrl.build();
        this.default_map.add_reg(this.res_value_ctrl, `UVM_REG_ADDR_WIDTH'h0000006C,"RW",0);
            this.res_value_ctrl_res_value_sel = this.res_value_ctrl.res_value_sel;
            this.res_value_sel = this.res_value_ctrl.res_value_sel;

            this.res_value_ctrl_res_cfg_value = this.res_value_ctrl.res_cfg_value;
            this.res_cfg_value = this.res_value_ctrl.res_cfg_value;

        this.trim_interrupt_ctrl = ral_reg_dram_trim_top_trim_interrupt_ctrl::type_id::create("trim_interrupt_ctrl",,get_full_name());
        this.trim_interrupt_ctrl.configure(this, null, "");
        this.trim_interrupt_ctrl.build();
        this.default_map.add_reg(this.trim_interrupt_ctrl, `UVM_REG_ADDR_WIDTH'h00000070,"RW",0);
            this.trim_interrupt_ctrl_trim_interrupt_clr = this.trim_interrupt_ctrl.trim_interrupt_clr;
            this.trim_interrupt_clr = this.trim_interrupt_ctrl.trim_interrupt_clr;

            this.trim_interrupt_ctrl_trim_interrupt_mask = this.trim_interrupt_ctrl.trim_interrupt_mask;
            this.trim_interrupt_mask = this.trim_interrupt_ctrl.trim_interrupt_mask;

            this.trim_interrupt_ctrl_trim_interrupt_flag = this.trim_interrupt_ctrl.trim_interrupt_flag;
            this.trim_interrupt_flag = this.trim_interrupt_ctrl.trim_interrupt_flag;

        this.hw_ringo_dram0_period_01 = ral_reg_dram_trim_top_hw_ringo_dram0_period_01::type_id::create("hw_ringo_dram0_period_01",,get_full_name());
        this.hw_ringo_dram0_period_01.configure(this, null, "");
        this.hw_ringo_dram0_period_01.build();
        this.default_map.add_reg(this.hw_ringo_dram0_period_01, `UVM_REG_ADDR_WIDTH'h00000074,"RW",0);
            this.hw_ringo_dram0_period_01_hw_ringo_dram0_period0 = this.hw_ringo_dram0_period_01.hw_ringo_dram0_period0;
            this.hw_ringo_dram0_period0 = this.hw_ringo_dram0_period_01.hw_ringo_dram0_period0;

            this.hw_ringo_dram0_period_01_hw_ringo_dram0_period1 = this.hw_ringo_dram0_period_01.hw_ringo_dram0_period1;
            this.hw_ringo_dram0_period1 = this.hw_ringo_dram0_period_01.hw_ringo_dram0_period1;

        this.hw_ringo_dram0_period_23 = ral_reg_dram_trim_top_hw_ringo_dram0_period_23::type_id::create("hw_ringo_dram0_period_23",,get_full_name());
        this.hw_ringo_dram0_period_23.configure(this, null, "");
        this.hw_ringo_dram0_period_23.build();
        this.default_map.add_reg(this.hw_ringo_dram0_period_23, `UVM_REG_ADDR_WIDTH'h00000078,"RW",0);
            this.hw_ringo_dram0_period_23_hw_ringo_dram0_period2 = this.hw_ringo_dram0_period_23.hw_ringo_dram0_period2;
            this.hw_ringo_dram0_period2 = this.hw_ringo_dram0_period_23.hw_ringo_dram0_period2;

            this.hw_ringo_dram0_period_23_hw_ringo_dram0_period3 = this.hw_ringo_dram0_period_23.hw_ringo_dram0_period3;
            this.hw_ringo_dram0_period3 = this.hw_ringo_dram0_period_23.hw_ringo_dram0_period3;

        this.hw_ringo_dram0_period_45 = ral_reg_dram_trim_top_hw_ringo_dram0_period_45::type_id::create("hw_ringo_dram0_period_45",,get_full_name());
        this.hw_ringo_dram0_period_45.configure(this, null, "");
        this.hw_ringo_dram0_period_45.build();
        this.default_map.add_reg(this.hw_ringo_dram0_period_45, `UVM_REG_ADDR_WIDTH'h0000007C,"RW",0);
            this.hw_ringo_dram0_period_45_hw_ringo_dram0_period4 = this.hw_ringo_dram0_period_45.hw_ringo_dram0_period4;
            this.hw_ringo_dram0_period4 = this.hw_ringo_dram0_period_45.hw_ringo_dram0_period4;

            this.hw_ringo_dram0_period_45_hw_ringo_dram0_period5 = this.hw_ringo_dram0_period_45.hw_ringo_dram0_period5;
            this.hw_ringo_dram0_period5 = this.hw_ringo_dram0_period_45.hw_ringo_dram0_period5;

        this.hw_ringo_dram0_period_67 = ral_reg_dram_trim_top_hw_ringo_dram0_period_67::type_id::create("hw_ringo_dram0_period_67",,get_full_name());
        this.hw_ringo_dram0_period_67.configure(this, null, "");
        this.hw_ringo_dram0_period_67.build();
        this.default_map.add_reg(this.hw_ringo_dram0_period_67, `UVM_REG_ADDR_WIDTH'h00000080,"RW",0);
            this.hw_ringo_dram0_period_67_hw_ringo_dram0_period6 = this.hw_ringo_dram0_period_67.hw_ringo_dram0_period6;
            this.hw_ringo_dram0_period6 = this.hw_ringo_dram0_period_67.hw_ringo_dram0_period6;

            this.hw_ringo_dram0_period_67_hw_ringo_dram0_period7 = this.hw_ringo_dram0_period_67.hw_ringo_dram0_period7;
            this.hw_ringo_dram0_period7 = this.hw_ringo_dram0_period_67.hw_ringo_dram0_period7;

        this.hw_ringo_dram1_period_01 = ral_reg_dram_trim_top_hw_ringo_dram1_period_01::type_id::create("hw_ringo_dram1_period_01",,get_full_name());
        this.hw_ringo_dram1_period_01.configure(this, null, "");
        this.hw_ringo_dram1_period_01.build();
        this.default_map.add_reg(this.hw_ringo_dram1_period_01, `UVM_REG_ADDR_WIDTH'h00000084,"RW",0);
            this.hw_ringo_dram1_period_01_hw_ringo_dram1_period0 = this.hw_ringo_dram1_period_01.hw_ringo_dram1_period0;
            this.hw_ringo_dram1_period0 = this.hw_ringo_dram1_period_01.hw_ringo_dram1_period0;

            this.hw_ringo_dram1_period_01_hw_ringo_dram1_period1 = this.hw_ringo_dram1_period_01.hw_ringo_dram1_period1;
            this.hw_ringo_dram1_period1 = this.hw_ringo_dram1_period_01.hw_ringo_dram1_period1;

        this.hw_ringo_dram1_period_23 = ral_reg_dram_trim_top_hw_ringo_dram1_period_23::type_id::create("hw_ringo_dram1_period_23",,get_full_name());
        this.hw_ringo_dram1_period_23.configure(this, null, "");
        this.hw_ringo_dram1_period_23.build();
        this.default_map.add_reg(this.hw_ringo_dram1_period_23, `UVM_REG_ADDR_WIDTH'h00000088,"RW",0);
            this.hw_ringo_dram1_period_23_hw_ringo_dram1_period2 = this.hw_ringo_dram1_period_23.hw_ringo_dram1_period2;
            this.hw_ringo_dram1_period2 = this.hw_ringo_dram1_period_23.hw_ringo_dram1_period2;

            this.hw_ringo_dram1_period_23_hw_ringo_dram1_period3 = this.hw_ringo_dram1_period_23.hw_ringo_dram1_period3;
            this.hw_ringo_dram1_period3 = this.hw_ringo_dram1_period_23.hw_ringo_dram1_period3;

        this.hw_ringo_dram1_period_45 = ral_reg_dram_trim_top_hw_ringo_dram1_period_45::type_id::create("hw_ringo_dram1_period_45",,get_full_name());
        this.hw_ringo_dram1_period_45.configure(this, null, "");
        this.hw_ringo_dram1_period_45.build();
        this.default_map.add_reg(this.hw_ringo_dram1_period_45, `UVM_REG_ADDR_WIDTH'h0000008C,"RW",0);
            this.hw_ringo_dram1_period_45_hw_ringo_dram1_period4 = this.hw_ringo_dram1_period_45.hw_ringo_dram1_period4;
            this.hw_ringo_dram1_period4 = this.hw_ringo_dram1_period_45.hw_ringo_dram1_period4;

            this.hw_ringo_dram1_period_45_hw_ringo_dram1_period5 = this.hw_ringo_dram1_period_45.hw_ringo_dram1_period5;
            this.hw_ringo_dram1_period5 = this.hw_ringo_dram1_period_45.hw_ringo_dram1_period5;

        this.hw_ringo_dram1_period_67 = ral_reg_dram_trim_top_hw_ringo_dram1_period_67::type_id::create("hw_ringo_dram1_period_67",,get_full_name());
        this.hw_ringo_dram1_period_67.configure(this, null, "");
        this.hw_ringo_dram1_period_67.build();
        this.default_map.add_reg(this.hw_ringo_dram1_period_67, `UVM_REG_ADDR_WIDTH'h00000090,"RW",0);
            this.hw_ringo_dram1_period_67_hw_ringo_dram1_period6 = this.hw_ringo_dram1_period_67.hw_ringo_dram1_period6;
            this.hw_ringo_dram1_period6 = this.hw_ringo_dram1_period_67.hw_ringo_dram1_period6;

            this.hw_ringo_dram1_period_67_hw_ringo_dram1_period7 = this.hw_ringo_dram1_period_67.hw_ringo_dram1_period7;
            this.hw_ringo_dram1_period7 = this.hw_ringo_dram1_period_67.hw_ringo_dram1_period7;

        this.hw_ringo_dram2_period_01 = ral_reg_dram_trim_top_hw_ringo_dram2_period_01::type_id::create("hw_ringo_dram2_period_01",,get_full_name());
        this.hw_ringo_dram2_period_01.configure(this, null, "");
        this.hw_ringo_dram2_period_01.build();
        this.default_map.add_reg(this.hw_ringo_dram2_period_01, `UVM_REG_ADDR_WIDTH'h00000094,"RW",0);
            this.hw_ringo_dram2_period_01_hw_ringo_dram2_period0 = this.hw_ringo_dram2_period_01.hw_ringo_dram2_period0;
            this.hw_ringo_dram2_period0 = this.hw_ringo_dram2_period_01.hw_ringo_dram2_period0;

            this.hw_ringo_dram2_period_01_hw_ringo_dram2_period1 = this.hw_ringo_dram2_period_01.hw_ringo_dram2_period1;
            this.hw_ringo_dram2_period1 = this.hw_ringo_dram2_period_01.hw_ringo_dram2_period1;

        this.hw_ringo_dram2_period_23 = ral_reg_dram_trim_top_hw_ringo_dram2_period_23::type_id::create("hw_ringo_dram2_period_23",,get_full_name());
        this.hw_ringo_dram2_period_23.configure(this, null, "");
        this.hw_ringo_dram2_period_23.build();
        this.default_map.add_reg(this.hw_ringo_dram2_period_23, `UVM_REG_ADDR_WIDTH'h00000098,"RW",0);
            this.hw_ringo_dram2_period_23_hw_ringo_dram2_period2 = this.hw_ringo_dram2_period_23.hw_ringo_dram2_period2;
            this.hw_ringo_dram2_period2 = this.hw_ringo_dram2_period_23.hw_ringo_dram2_period2;

            this.hw_ringo_dram2_period_23_hw_ringo_dram2_period3 = this.hw_ringo_dram2_period_23.hw_ringo_dram2_period3;
            this.hw_ringo_dram2_period3 = this.hw_ringo_dram2_period_23.hw_ringo_dram2_period3;

        this.hw_ringo_dram2_period_45 = ral_reg_dram_trim_top_hw_ringo_dram2_period_45::type_id::create("hw_ringo_dram2_period_45",,get_full_name());
        this.hw_ringo_dram2_period_45.configure(this, null, "");
        this.hw_ringo_dram2_period_45.build();
        this.default_map.add_reg(this.hw_ringo_dram2_period_45, `UVM_REG_ADDR_WIDTH'h0000009C,"RW",0);
            this.hw_ringo_dram2_period_45_hw_ringo_dram2_period4 = this.hw_ringo_dram2_period_45.hw_ringo_dram2_period4;
            this.hw_ringo_dram2_period4 = this.hw_ringo_dram2_period_45.hw_ringo_dram2_period4;

            this.hw_ringo_dram2_period_45_hw_ringo_dram2_period5 = this.hw_ringo_dram2_period_45.hw_ringo_dram2_period5;
            this.hw_ringo_dram2_period5 = this.hw_ringo_dram2_period_45.hw_ringo_dram2_period5;

        this.hw_ringo_dram2_period_67 = ral_reg_dram_trim_top_hw_ringo_dram2_period_67::type_id::create("hw_ringo_dram2_period_67",,get_full_name());
        this.hw_ringo_dram2_period_67.configure(this, null, "");
        this.hw_ringo_dram2_period_67.build();
        this.default_map.add_reg(this.hw_ringo_dram2_period_67, `UVM_REG_ADDR_WIDTH'h000000A0,"RW",0);
            this.hw_ringo_dram2_period_67_hw_ringo_dram2_period6 = this.hw_ringo_dram2_period_67.hw_ringo_dram2_period6;
            this.hw_ringo_dram2_period6 = this.hw_ringo_dram2_period_67.hw_ringo_dram2_period6;

            this.hw_ringo_dram2_period_67_hw_ringo_dram2_period7 = this.hw_ringo_dram2_period_67.hw_ringo_dram2_period7;
            this.hw_ringo_dram2_period7 = this.hw_ringo_dram2_period_67.hw_ringo_dram2_period7;

        this.hw_ringo_dram3_period_01 = ral_reg_dram_trim_top_hw_ringo_dram3_period_01::type_id::create("hw_ringo_dram3_period_01",,get_full_name());
        this.hw_ringo_dram3_period_01.configure(this, null, "");
        this.hw_ringo_dram3_period_01.build();
        this.default_map.add_reg(this.hw_ringo_dram3_period_01, `UVM_REG_ADDR_WIDTH'h000000A4,"RW",0);
            this.hw_ringo_dram3_period_01_hw_ringo_dram3_period0 = this.hw_ringo_dram3_period_01.hw_ringo_dram3_period0;
            this.hw_ringo_dram3_period0 = this.hw_ringo_dram3_period_01.hw_ringo_dram3_period0;

            this.hw_ringo_dram3_period_01_hw_ringo_dram3_period1 = this.hw_ringo_dram3_period_01.hw_ringo_dram3_period1;
            this.hw_ringo_dram3_period1 = this.hw_ringo_dram3_period_01.hw_ringo_dram3_period1;

        this.hw_ringo_dram3_period_23 = ral_reg_dram_trim_top_hw_ringo_dram3_period_23::type_id::create("hw_ringo_dram3_period_23",,get_full_name());
        this.hw_ringo_dram3_period_23.configure(this, null, "");
        this.hw_ringo_dram3_period_23.build();
        this.default_map.add_reg(this.hw_ringo_dram3_period_23, `UVM_REG_ADDR_WIDTH'h000000A8,"RW",0);
            this.hw_ringo_dram3_period_23_hw_ringo_dram3_period2 = this.hw_ringo_dram3_period_23.hw_ringo_dram3_period2;
            this.hw_ringo_dram3_period2 = this.hw_ringo_dram3_period_23.hw_ringo_dram3_period2;

            this.hw_ringo_dram3_period_23_hw_ringo_dram3_period3 = this.hw_ringo_dram3_period_23.hw_ringo_dram3_period3;
            this.hw_ringo_dram3_period3 = this.hw_ringo_dram3_period_23.hw_ringo_dram3_period3;

        this.hw_ringo_dram3_period_45 = ral_reg_dram_trim_top_hw_ringo_dram3_period_45::type_id::create("hw_ringo_dram3_period_45",,get_full_name());
        this.hw_ringo_dram3_period_45.configure(this, null, "");
        this.hw_ringo_dram3_period_45.build();
        this.default_map.add_reg(this.hw_ringo_dram3_period_45, `UVM_REG_ADDR_WIDTH'h000000AC,"RW",0);
            this.hw_ringo_dram3_period_45_hw_ringo_dram3_period4 = this.hw_ringo_dram3_period_45.hw_ringo_dram3_period4;
            this.hw_ringo_dram3_period4 = this.hw_ringo_dram3_period_45.hw_ringo_dram3_period4;

            this.hw_ringo_dram3_period_45_hw_ringo_dram3_period5 = this.hw_ringo_dram3_period_45.hw_ringo_dram3_period5;
            this.hw_ringo_dram3_period5 = this.hw_ringo_dram3_period_45.hw_ringo_dram3_period5;

        this.hw_ringo_dram3_period_67 = ral_reg_dram_trim_top_hw_ringo_dram3_period_67::type_id::create("hw_ringo_dram3_period_67",,get_full_name());
        this.hw_ringo_dram3_period_67.configure(this, null, "");
        this.hw_ringo_dram3_period_67.build();
        this.default_map.add_reg(this.hw_ringo_dram3_period_67, `UVM_REG_ADDR_WIDTH'h000000B0,"RW",0);
            this.hw_ringo_dram3_period_67_hw_ringo_dram3_period6 = this.hw_ringo_dram3_period_67.hw_ringo_dram3_period6;
            this.hw_ringo_dram3_period6 = this.hw_ringo_dram3_period_67.hw_ringo_dram3_period6;

            this.hw_ringo_dram3_period_67_hw_ringo_dram3_period7 = this.hw_ringo_dram3_period_67.hw_ringo_dram3_period7;
            this.hw_ringo_dram3_period7 = this.hw_ringo_dram3_period_67.hw_ringo_dram3_period7;

        this.trim_debug0 = ral_reg_dram_trim_top_trim_debug0::type_id::create("trim_debug0",,get_full_name());
        this.trim_debug0.configure(this, null, "");
        this.trim_debug0.build();
        this.default_map.add_reg(this.trim_debug0, `UVM_REG_ADDR_WIDTH'h000000B4,"RW",0);
            this.trim_debug0_sw_spine_reset_n_active_cnt_dbg = this.trim_debug0.sw_spine_reset_n_active_cnt_dbg;
            this.sw_spine_reset_n_active_cnt_dbg = this.trim_debug0.sw_spine_reset_n_active_cnt_dbg;

            this.trim_debug0_sw_tm_redump_active_cnt_dbg = this.trim_debug0.sw_tm_redump_active_cnt_dbg;
            this.sw_tm_redump_active_cnt_dbg = this.trim_debug0.sw_tm_redump_active_cnt_dbg;

            this.trim_debug0_sw_stopwatch_period_active_cnt_dbg = this.trim_debug0.sw_stopwatch_period_active_cnt_dbg;
            this.sw_stopwatch_period_active_cnt_dbg = this.trim_debug0.sw_stopwatch_period_active_cnt_dbg;

            this.trim_debug0_trim_start_cnt_dbg = this.trim_debug0.trim_start_cnt_dbg;
            this.trim_start_cnt_dbg = this.trim_debug0.trim_start_cnt_dbg;

            this.trim_debug0_spine_reset_n_dbg = this.trim_debug0.spine_reset_n_dbg;
            this.spine_reset_n_dbg = this.trim_debug0.spine_reset_n_dbg;

            this.trim_debug0_tm_redump_edge_dbg = this.trim_debug0.tm_redump_edge_dbg;
            this.tm_redump_edge_dbg = this.trim_debug0.tm_redump_edge_dbg;

            this.trim_debug0_stopwatch_period_edge_dbg = this.trim_debug0.stopwatch_period_edge_dbg;
            this.stopwatch_period_edge_dbg = this.trim_debug0.stopwatch_period_edge_dbg;

            this.trim_debug0_stopwatch_ringo_edge_dbg = this.trim_debug0.stopwatch_ringo_edge_dbg;
            this.stopwatch_ringo_edge_dbg = this.trim_debug0.stopwatch_ringo_edge_dbg;

        this.trim_debug1 = ral_reg_dram_trim_top_trim_debug1::type_id::create("trim_debug1",,get_full_name());
        this.trim_debug1.configure(this, null, "");
        this.trim_debug1.build();
        this.default_map.add_reg(this.trim_debug1, `UVM_REG_ADDR_WIDTH'h000000B8,"RW",0);
            this.trim_debug1_fsm_cs_flag_dbg0 = this.trim_debug1.fsm_cs_flag_dbg0;
            this.fsm_cs_flag_dbg0 = this.trim_debug1.fsm_cs_flag_dbg0;

        this.trim_debug2 = ral_reg_dram_trim_top_trim_debug2::type_id::create("trim_debug2",,get_full_name());
        this.trim_debug2.configure(this, null, "");
        this.trim_debug2.build();
        this.default_map.add_reg(this.trim_debug2, `UVM_REG_ADDR_WIDTH'h000000BC,"RW",0);
            this.trim_debug2_fsm_cs_flag_dbg1 = this.trim_debug2.fsm_cs_flag_dbg1;
            this.fsm_cs_flag_dbg1 = this.trim_debug2.fsm_cs_flag_dbg1;

            this.trim_debug2_fsm_cs_dbg = this.trim_debug2.fsm_cs_dbg;
            this.fsm_cs_dbg = this.trim_debug2.fsm_cs_dbg;

        this.hw_ringo_period_dly = ral_reg_dram_trim_top_hw_ringo_period_dly::type_id::create("hw_ringo_period_dly",,get_full_name());
        this.hw_ringo_period_dly.configure(this, null, "");
        this.hw_ringo_period_dly.build();
        this.default_map.add_reg(this.hw_ringo_period_dly, `UVM_REG_ADDR_WIDTH'h000000C0,"RW",0);
            this.hw_ringo_period_dly_hw_ringo_period_delay = this.hw_ringo_period_dly.hw_ringo_period_delay;
            this.hw_ringo_period_delay = this.hw_ringo_period_dly.hw_ringo_period_delay;

        this.hw_period2ringo_dly = ral_reg_dram_trim_top_hw_period2ringo_dly::type_id::create("hw_period2ringo_dly",,get_full_name());
        this.hw_period2ringo_dly.configure(this, null, "");
        this.hw_period2ringo_dly.build();
        this.default_map.add_reg(this.hw_period2ringo_dly, `UVM_REG_ADDR_WIDTH'h000000C4,"RW",0);
            this.hw_period2ringo_dly_hw_period2ringo_dly = this.hw_period2ringo_dly.hw_period2ringo_dly;

        this.res_mode_value_reg = ral_reg_dram_trim_top_res_mode_value_reg::type_id::create("res_mode_value_reg",,get_full_name());
        this.res_mode_value_reg.configure(this, null, "");
        this.res_mode_value_reg.build();
        this.default_map.add_reg(this.res_mode_value_reg, `UVM_REG_ADDR_WIDTH'h000000C8,"RW",0);
            this.res_mode_value_reg_res_mode_value = this.res_mode_value_reg.res_mode_value;
            this.res_mode_value = this.res_mode_value_reg.res_mode_value;

        this.ringo_mode_value_reg01 = ral_reg_dram_trim_top_ringo_mode_value_reg01::type_id::create("ringo_mode_value_reg01",,get_full_name());
        this.ringo_mode_value_reg01.configure(this, null, "");
        this.ringo_mode_value_reg01.build();
        this.default_map.add_reg(this.ringo_mode_value_reg01, `UVM_REG_ADDR_WIDTH'h000000CC,"RW",0);
            this.ringo_mode_value_reg01_ringo_mode_value_reg0 = this.ringo_mode_value_reg01.ringo_mode_value_reg0;
            this.ringo_mode_value_reg0 = this.ringo_mode_value_reg01.ringo_mode_value_reg0;

            this.ringo_mode_value_reg01_ringo_mode_value_reg1 = this.ringo_mode_value_reg01.ringo_mode_value_reg1;
            this.ringo_mode_value_reg1 = this.ringo_mode_value_reg01.ringo_mode_value_reg1;

        this.ringo_mode_value_reg23 = ral_reg_dram_trim_top_ringo_mode_value_reg23::type_id::create("ringo_mode_value_reg23",,get_full_name());
        this.ringo_mode_value_reg23.configure(this, null, "");
        this.ringo_mode_value_reg23.build();
        this.default_map.add_reg(this.ringo_mode_value_reg23, `UVM_REG_ADDR_WIDTH'h000000D0,"RW",0);
            this.ringo_mode_value_reg23_ringo_mode_value_reg2 = this.ringo_mode_value_reg23.ringo_mode_value_reg2;
            this.ringo_mode_value_reg2 = this.ringo_mode_value_reg23.ringo_mode_value_reg2;

            this.ringo_mode_value_reg23_ringo_mode_value_reg3 = this.ringo_mode_value_reg23.ringo_mode_value_reg3;
            this.ringo_mode_value_reg3 = this.ringo_mode_value_reg23.ringo_mode_value_reg3;

        this.ringo_mode_value_reg45 = ral_reg_dram_trim_top_ringo_mode_value_reg45::type_id::create("ringo_mode_value_reg45",,get_full_name());
        this.ringo_mode_value_reg45.configure(this, null, "");
        this.ringo_mode_value_reg45.build();
        this.default_map.add_reg(this.ringo_mode_value_reg45, `UVM_REG_ADDR_WIDTH'h000000D4,"RW",0);
            this.ringo_mode_value_reg45_ringo_mode_value_reg4 = this.ringo_mode_value_reg45.ringo_mode_value_reg4;
            this.ringo_mode_value_reg4 = this.ringo_mode_value_reg45.ringo_mode_value_reg4;

            this.ringo_mode_value_reg45_ringo_mode_value_reg5 = this.ringo_mode_value_reg45.ringo_mode_value_reg5;
            this.ringo_mode_value_reg5 = this.ringo_mode_value_reg45.ringo_mode_value_reg5;

        this.ringo_mode_value_reg67 = ral_reg_dram_trim_top_ringo_mode_value_reg67::type_id::create("ringo_mode_value_reg67",,get_full_name());
        this.ringo_mode_value_reg67.configure(this, null, "");
        this.ringo_mode_value_reg67.build();
        this.default_map.add_reg(this.ringo_mode_value_reg67, `UVM_REG_ADDR_WIDTH'h000000D8,"RW",0);
            this.ringo_mode_value_reg67_ringo_mode_value_reg6 = this.ringo_mode_value_reg67.ringo_mode_value_reg6;
            this.ringo_mode_value_reg6 = this.ringo_mode_value_reg67.ringo_mode_value_reg6;

            this.ringo_mode_value_reg67_ringo_mode_value_reg7 = this.ringo_mode_value_reg67.ringo_mode_value_reg7;
            this.ringo_mode_value_reg7 = this.ringo_mode_value_reg67.ringo_mode_value_reg7;

            //add hdl path
            this.trim_ctrl_id.add_hdl_path_slice("trim_ctrl_id_i",0,32);
            this.trim_op_ctrl.add_hdl_path_slice("spine_resetn_active_o",0,1);
            this.trim_op_ctrl.add_hdl_path_slice("tm_redump_active_o",1,1);
            this.trim_op_ctrl.add_hdl_path_slice("stopwatch_period_active_o",2,1);
            this.trim_op_ctrl.add_hdl_path_slice("trim_start_o",3,1);
            this.trim_op_ctrl.add_hdl_path_slice("init_start_o",4,1);
            this.trim_global_ctrl.add_hdl_path_slice("trim_op_flow_o",0,1);
            this.trim_global_ctrl.add_hdl_path_slice("hw_op_ringo_mask_o",1,1);
            this.trim_global_ctrl.add_hdl_path_slice("hw_op_tsv_load_sel_o",2,1);
            this.trim_global_ctrl.add_hdl_path_slice("dram_layer_sel_o",4,4);
            this.trim_global_ctrl.add_hdl_path_slice("res_or_ringo_sel_o",8,1);
            this.trim_global_ctrl.add_hdl_path_slice("debug_en_o",9,1);
            this.trim_global_ctrl.add_hdl_path_slice("trim_finish_i",12,1);
            this.trim_internal_status.add_hdl_path_slice("spine_resetn_active_ready_i",0,1);
            this.trim_internal_status.add_hdl_path_slice("tm_redump_active_ready_i",1,1);
            this.trim_internal_status.add_hdl_path_slice("stopwatch_period_active_ready_i",2,1);
            this.trim_internal_status.add_hdl_path_slice("init_done_flag_i",3,1);
            this.trim_internal_status.add_hdl_path_slice("stopwatch_ringo_period_ready_i",4,4);
            this.trim_internal_status.add_hdl_path_slice("dump_ready_i",8,4);
            this.trim_internal_status.add_hdl_path_slice("dumpready_timeout_ready_i",12,4);
            this.init_spine_resetn_time.add_hdl_path_slice("init_spine_reset_time_o",0,28);
            this.spine_resetn_width.add_hdl_path_slice("spine_resetn_width_o",0,10);
            this.tm_redump_width.add_hdl_path_slice("tm_redump_width_o",0,10);
            this.stopwatch_period_width.add_hdl_path_slice("stopwatch_period_width_res_o",0,16);
            this.stopwatch_period_width.add_hdl_path_slice("stopwatch_period_width_ringo_o",16,16);
            this.redump_tsv_tm_other_value0.add_hdl_path_slice("redump_tsv_tm_other_value0_o",0,32);
            this.redump_tsv_tm_other_value1.add_hdl_path_slice("redump_tsv_tm_other_value1_o",0,32);
            this.redump_tsv_tm_other_value2.add_hdl_path_slice("redump_tsv_tm_other_value2_o",0,32);
            this.redump_tsv_tm_other_value3.add_hdl_path_slice("redump_tsv_tm_other_value3_o",0,32);
            this.redump_tsv_tm_other_value4.add_hdl_path_slice("redump_tsv_tm_other_value4_o",0,32);
            this.redump_tsv_tm_other_value5.add_hdl_path_slice("redump_tsv_tm_other_value5_o",0,32);
            this.redump_tsv_tm_other_value6.add_hdl_path_slice("redump_tsv_tm_other_value6_o",0,32);
            this.redump_tsv_tm_other_value7.add_hdl_path_slice("redump_tsv_tm_other_value7_o",0,32);
            this.redump_tsv_tm_other_value8.add_hdl_path_slice("redump_tsv_tm_other_value8_o",0,32);
            this.redump_tsv_tm_other_value9.add_hdl_path_slice("redump_tsv_tm_other_value9_o",0,32);
            this.redump_tsv_tm_other_value10.add_hdl_path_slice("redump_tsv_tm_other_value10_o",0,32);
            this.redump_tsv_tm_other_value11.add_hdl_path_slice("redump_tsv_tm_other_value11_o",0,32);
            this.redump_tsv_tm_other_value12.add_hdl_path_slice("redump_tsv_tm_other_value12_o",0,32);
            this.redump_tsv_tm_other_value13.add_hdl_path_slice("redump_tsv_tm_other_value13_o",0,12);
            this.osc_tm_res_smp_value.add_hdl_path_slice("osc_tm_res_smp_value_i",0,8);
            this.osc_tm_res_smp_value.add_hdl_path_slice("osc_tm_res_smp_ready_i",8,4);
            this.stopwatch_ringo_period_01.add_hdl_path_slice("stopwatch_ringo_period0_i",0,10);
            this.stopwatch_ringo_period_01.add_hdl_path_slice("stopwatch_ringo_period1_i",16,10);
            this.stopwatch_ringo_period_23.add_hdl_path_slice("stopwatch_ringo_period2_i",0,10);
            this.stopwatch_ringo_period_23.add_hdl_path_slice("stopwatch_ringo_period3_i",16,10);
            this.dumpready_timeout_ctrl.add_hdl_path_slice("dumpready_timeout_en_o",0,1);
            this.dumpready_timeout_ctrl.add_hdl_path_slice("dumpready_timeout_clr_o",1,1);
            this.dumpready_timeout_ctrl.add_hdl_path_slice("dumpready_timeout_flag_i",4,4);
            this.dumpready_timeout_ctrl.add_hdl_path_slice("dumpready_timeout_time_o",8,24);
            this.ringo_timeout_ctrl.add_hdl_path_slice("ringo_timeout_en_o",0,1);
            this.ringo_timeout_ctrl.add_hdl_path_slice("ringo_timeout_clr_o",1,1);
            this.ringo_timeout_ctrl.add_hdl_path_slice("ringo_timeout_flag_i",4,4);
            this.ringo_timeout_ctrl.add_hdl_path_slice("ringo_timeout_time_o",8,24);
            this.res_value_ctrl.add_hdl_path_slice("res_value_sel_o",0,2);
            this.res_value_ctrl.add_hdl_path_slice("res_cfg_value_o",4,8);
            this.trim_interrupt_ctrl.add_hdl_path_slice("trim_interrupt_clr_o",0,1);
            this.trim_interrupt_ctrl.add_hdl_path_slice("trim_interrupt_mask_o",1,1);
            this.trim_interrupt_ctrl.add_hdl_path_slice("trim_interrupt_flag_i",2,1);
            this.hw_ringo_dram0_period_01.add_hdl_path_slice("hw_ringo_dram0_period0_i",0,10);
            this.hw_ringo_dram0_period_01.add_hdl_path_slice("hw_ringo_dram0_period1_i",16,10);
            this.hw_ringo_dram0_period_23.add_hdl_path_slice("hw_ringo_dram0_period2_i",0,10);
            this.hw_ringo_dram0_period_23.add_hdl_path_slice("hw_ringo_dram0_period3_i",16,10);
            this.hw_ringo_dram0_period_45.add_hdl_path_slice("hw_ringo_dram0_period4_i",0,10);
            this.hw_ringo_dram0_period_45.add_hdl_path_slice("hw_ringo_dram0_period5_i",16,10);
            this.hw_ringo_dram0_period_67.add_hdl_path_slice("hw_ringo_dram0_period6_i",0,10);
            this.hw_ringo_dram0_period_67.add_hdl_path_slice("hw_ringo_dram0_period7_i",16,10);
            this.hw_ringo_dram1_period_01.add_hdl_path_slice("hw_ringo_dram1_period0_i",0,10);
            this.hw_ringo_dram1_period_01.add_hdl_path_slice("hw_ringo_dram1_period1_i",16,10);
            this.hw_ringo_dram1_period_23.add_hdl_path_slice("hw_ringo_dram1_period2_i",0,10);
            this.hw_ringo_dram1_period_23.add_hdl_path_slice("hw_ringo_dram1_period3_i",16,10);
            this.hw_ringo_dram1_period_45.add_hdl_path_slice("hw_ringo_dram1_period4_i",0,10);
            this.hw_ringo_dram1_period_45.add_hdl_path_slice("hw_ringo_dram1_period5_i",16,10);
            this.hw_ringo_dram1_period_67.add_hdl_path_slice("hw_ringo_dram1_period6_i",0,10);
            this.hw_ringo_dram1_period_67.add_hdl_path_slice("hw_ringo_dram1_period7_i",16,10);
            this.hw_ringo_dram2_period_01.add_hdl_path_slice("hw_ringo_dram2_period0_i",0,10);
            this.hw_ringo_dram2_period_01.add_hdl_path_slice("hw_ringo_dram2_period1_i",16,10);
            this.hw_ringo_dram2_period_23.add_hdl_path_slice("hw_ringo_dram2_period2_i",0,10);
            this.hw_ringo_dram2_period_23.add_hdl_path_slice("hw_ringo_dram2_period3_i",16,10);
            this.hw_ringo_dram2_period_45.add_hdl_path_slice("hw_ringo_dram2_period4_i",0,10);
            this.hw_ringo_dram2_period_45.add_hdl_path_slice("hw_ringo_dram2_period5_i",16,10);
            this.hw_ringo_dram2_period_67.add_hdl_path_slice("hw_ringo_dram2_period6_i",0,10);
            this.hw_ringo_dram2_period_67.add_hdl_path_slice("hw_ringo_dram2_period7_i",16,10);
            this.hw_ringo_dram3_period_01.add_hdl_path_slice("hw_ringo_dram3_period0_i",0,10);
            this.hw_ringo_dram3_period_01.add_hdl_path_slice("hw_ringo_dram3_period1_i",16,10);
            this.hw_ringo_dram3_period_23.add_hdl_path_slice("hw_ringo_dram3_period2_i",0,10);
            this.hw_ringo_dram3_period_23.add_hdl_path_slice("hw_ringo_dram3_period3_i",16,10);
            this.hw_ringo_dram3_period_45.add_hdl_path_slice("hw_ringo_dram3_period4_i",0,10);
            this.hw_ringo_dram3_period_45.add_hdl_path_slice("hw_ringo_dram3_period5_i",16,10);
            this.hw_ringo_dram3_period_67.add_hdl_path_slice("hw_ringo_dram3_period6_i",0,10);
            this.hw_ringo_dram3_period_67.add_hdl_path_slice("hw_ringo_dram3_period7_i",16,10);
            this.trim_debug0.add_hdl_path_slice("sw_spine_reset_n_active_cnt_dbg_i",0,4);
            this.trim_debug0.add_hdl_path_slice("sw_tm_redump_active_cnt_dbg_i",4,4);
            this.trim_debug0.add_hdl_path_slice("sw_stopwatch_period_active_cnt_dbg_i",8,4);
            this.trim_debug0.add_hdl_path_slice("trim_start_cnt_dbg_i",12,4);
            this.trim_debug0.add_hdl_path_slice("spine_reset_n_dbg_i",16,4);
            this.trim_debug0.add_hdl_path_slice("tm_redump_edge_dbg_i",20,4);
            this.trim_debug0.add_hdl_path_slice("stopwatch_period_edge_dbg_i",24,4);
            this.trim_debug0.add_hdl_path_slice("stopwatch_ringo_edge_dbg_i",28,4);
            this.trim_debug1.add_hdl_path_slice("fsm_cs_flag_dbg0_i",0,32);
            this.trim_debug2.add_hdl_path_slice("fsm_cs_flag_dbg1_i",0,1);
            this.trim_debug2.add_hdl_path_slice("fsm_cs_dbg_i",8,6);
            this.hw_ringo_period_dly.add_hdl_path_slice("hw_ringo_period_delay_o",0,14);
            this.hw_period2ringo_dly.add_hdl_path_slice("hw_period2ringo_dly_o",0,10);
            this.res_mode_value_reg.add_hdl_path_slice("res_mode_value_o",0,9);
            this.ringo_mode_value_reg01.add_hdl_path_slice("ringo_mode_value_reg0_o",0,9);
            this.ringo_mode_value_reg01.add_hdl_path_slice("ringo_mode_value_reg1_o",16,9);
            this.ringo_mode_value_reg23.add_hdl_path_slice("ringo_mode_value_reg2_o",0,9);
            this.ringo_mode_value_reg23.add_hdl_path_slice("ringo_mode_value_reg3_o",16,9);
            this.ringo_mode_value_reg45.add_hdl_path_slice("ringo_mode_value_reg4_o",0,9);
            this.ringo_mode_value_reg45.add_hdl_path_slice("ringo_mode_value_reg5_o",16,9);
            this.ringo_mode_value_reg67.add_hdl_path_slice("ringo_mode_value_reg6_o",0,9);
            this.ringo_mode_value_reg67.add_hdl_path_slice("ringo_mode_value_reg7_o",16,9);

    endfunction : build

    `uvm_object_utils(ral_block_dram_trim_top)

endclass : ral_block_dram_trim_top


class ral_sys_dram_trim extends uvm_reg_block;

    rand ral_block_dram_trim_top DRAM_TRIM_ins;

    function new(string name = "dram_trim");
        super.new(name);
    endfunction: new

    function void build();
        this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);

        this.DRAM_TRIM_ins = ral_block_dram_trim_top::type_id::create("DRAM_TRIM_ins",,get_full_name());
        this.DRAM_TRIM_ins.configure(this, "");
        this.DRAM_TRIM_ins.build();
        this.default_map.add_submap(this.DRAM_TRIM_ins.default_map, `UVM_REG_ADDR_WIDTH'h0);
        this.DRAM_TRIM_ins.add_hdl_path("trim_tb.u_dram_trim_top.apb2reg_dram_trim_cfg_if_u");

    endfunction : build

    `uvm_object_utils(ral_sys_dram_trim)
endclass : ral_sys_dram_trim

`endif
