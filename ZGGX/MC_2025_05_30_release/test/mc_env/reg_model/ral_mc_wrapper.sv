`ifndef RAL_mc_wrapper
`define RAL_mc_wrapper

`define UVM_REG_ADDR_WIDTH 32

class ral_reg_mc_wrapper_top_mc_id_reg extends uvm_reg;
    rand uvm_reg_field mc_id;

    function new(string name = "mc_wrapper_top_mc_id_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_id = uvm_reg_field::type_id::create("mc_id",,get_full_name());
        this.mc_id.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_id_reg)
endclass:ral_reg_mc_wrapper_top_mc_id_reg

class ral_reg_mc_wrapper_top_mc_work_ctrl_reg extends uvm_reg;
    rand uvm_reg_field mc_en;
    rand uvm_reg_field mc_rf_cfg_sel;
    rand uvm_reg_field mc_debug_en;
    rand uvm_reg_field mc_wl_vmc_en;
    rand uvm_reg_field mc_bl_vmc_en;
    rand uvm_reg_field mc_bist_en;
    rand uvm_reg_field mc_rescan_addr_range_sel;
    rand uvm_reg_field mc_csl_scan_addr_range_sel;
    rand uvm_reg_field mc_csl_scan_check_sel;
    rand uvm_reg_field mc_csl_scan_mode_sel;

    function new(string name = "mc_wrapper_top_mc_work_ctrl_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_en = uvm_reg_field::type_id::create("mc_en",,get_full_name());
        this.mc_en.configure(this,1,0,"RW",0,32'h0,1,0,0);
        this.mc_rf_cfg_sel = uvm_reg_field::type_id::create("mc_rf_cfg_sel",,get_full_name());
        this.mc_rf_cfg_sel.configure(this,1,1,"RW",0,32'h0,1,0,0);
        this.mc_debug_en = uvm_reg_field::type_id::create("mc_debug_en",,get_full_name());
        this.mc_debug_en.configure(this,1,2,"RW",0,32'h0,1,0,0);
        this.mc_wl_vmc_en = uvm_reg_field::type_id::create("mc_wl_vmc_en",,get_full_name());
        this.mc_wl_vmc_en.configure(this,1,3,"RW",0,32'h0,1,0,0);
        this.mc_bl_vmc_en = uvm_reg_field::type_id::create("mc_bl_vmc_en",,get_full_name());
        this.mc_bl_vmc_en.configure(this,1,4,"RW",0,32'h0,1,0,0);
        this.mc_bist_en = uvm_reg_field::type_id::create("mc_bist_en",,get_full_name());
        this.mc_bist_en.configure(this,1,5,"RW",0,32'h1,1,0,0);
        this.mc_rescan_addr_range_sel = uvm_reg_field::type_id::create("mc_rescan_addr_range_sel",,get_full_name());
        this.mc_rescan_addr_range_sel.configure(this,1,6,"RW",0,32'h1,1,0,0);
        this.mc_csl_scan_addr_range_sel = uvm_reg_field::type_id::create("mc_csl_scan_addr_range_sel",,get_full_name());
        this.mc_csl_scan_addr_range_sel.configure(this,1,7,"RW",0,32'h1,1,0,0);
        this.mc_csl_scan_check_sel = uvm_reg_field::type_id::create("mc_csl_scan_check_sel",,get_full_name());
        this.mc_csl_scan_check_sel.configure(this,1,8,"RW",0,32'h1,1,0,0);
        this.mc_csl_scan_mode_sel = uvm_reg_field::type_id::create("mc_csl_scan_mode_sel",,get_full_name());
        this.mc_csl_scan_mode_sel.configure(this,1,9,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_work_ctrl_reg)
endclass:ral_reg_mc_wrapper_top_mc_work_ctrl_reg

class ral_reg_mc_wrapper_top_phy_timing_cfg0_reg extends uvm_reg;
    rand uvm_reg_field bank_radd_set_time;
    rand uvm_reg_field cadd_set_time;
    rand uvm_reg_field r_cas_set_time;
    rand uvm_reg_field w_cas_set_time;
    rand uvm_reg_field cas_wrrdy_time;

    function new(string name = "mc_wrapper_top_phy_timing_cfg0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank_radd_set_time = uvm_reg_field::type_id::create("bank_radd_set_time",,get_full_name());
        this.bank_radd_set_time.configure(this,4,0,"RW",0,32'h0,1,0,0);
        this.cadd_set_time = uvm_reg_field::type_id::create("cadd_set_time",,get_full_name());
        this.cadd_set_time.configure(this,4,4,"RW",0,32'h0,1,0,0);
        this.r_cas_set_time = uvm_reg_field::type_id::create("r_cas_set_time",,get_full_name());
        this.r_cas_set_time.configure(this,8,8,"RW",0,32'h0,1,0,0);
        this.w_cas_set_time = uvm_reg_field::type_id::create("w_cas_set_time",,get_full_name());
        this.w_cas_set_time.configure(this,8,16,"RW",0,32'h0,1,0,0);
        this.cas_wrrdy_time = uvm_reg_field::type_id::create("cas_wrrdy_time",,get_full_name());
        this.cas_wrrdy_time.configure(this,8,24,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_phy_timing_cfg0_reg)
endclass:ral_reg_mc_wrapper_top_phy_timing_cfg0_reg

class ral_reg_mc_wrapper_top_mc_rf_period_cfg1_reg extends uvm_reg;
    rand uvm_reg_field mc_rf_period_1;

    function new(string name = "mc_wrapper_top_mc_rf_period_cfg1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_rf_period_1 = uvm_reg_field::type_id::create("mc_rf_period_1",,get_full_name());
        this.mc_rf_period_1.configure(this,32,0,"RW",0,32'h186A000,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_rf_period_cfg1_reg)
endclass:ral_reg_mc_wrapper_top_mc_rf_period_cfg1_reg

class ral_reg_mc_wrapper_top_mc_rf_start_cfg1_reg extends uvm_reg;
    rand uvm_reg_field mc_rf_start_1;

    function new(string name = "mc_wrapper_top_mc_rf_start_cfg1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_rf_start_1 = uvm_reg_field::type_id::create("mc_rf_start_1",,get_full_name());
        this.mc_rf_start_1.configure(this,32,0,"RW",0,32'hFFFFFFFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_rf_start_cfg1_reg)
endclass:ral_reg_mc_wrapper_top_mc_rf_start_cfg1_reg

class ral_reg_mc_wrapper_top_mc_rf_period_cfg2_reg extends uvm_reg;
    rand uvm_reg_field mc_rf_period_2;

    function new(string name = "mc_wrapper_top_mc_rf_period_cfg2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_rf_period_2 = uvm_reg_field::type_id::create("mc_rf_period_2",,get_full_name());
        this.mc_rf_period_2.configure(this,32,0,"RW",0,32'h186A000,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_rf_period_cfg2_reg)
endclass:ral_reg_mc_wrapper_top_mc_rf_period_cfg2_reg

class ral_reg_mc_wrapper_top_mc_rf_start_cfg2_reg extends uvm_reg;
    rand uvm_reg_field mc_rf_start_2;

    function new(string name = "mc_wrapper_top_mc_rf_start_cfg2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_rf_start_2 = uvm_reg_field::type_id::create("mc_rf_start_2",,get_full_name());
        this.mc_rf_start_2.configure(this,32,0,"RW",0,32'hFFFFFFFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_rf_start_cfg2_reg)
endclass:ral_reg_mc_wrapper_top_mc_rf_start_cfg2_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num0;
    rand uvm_reg_field mc_vmc_wl_num1;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num0 = uvm_reg_field::type_id::create("mc_vmc_wl_num0",,get_full_name());
        this.mc_vmc_wl_num0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num1 = uvm_reg_field::type_id::create("mc_vmc_wl_num1",,get_full_name());
        this.mc_vmc_wl_num1.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num0_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num0_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num2;
    rand uvm_reg_field mc_vmc_wl_num3;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num2 = uvm_reg_field::type_id::create("mc_vmc_wl_num2",,get_full_name());
        this.mc_vmc_wl_num2.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num3 = uvm_reg_field::type_id::create("mc_vmc_wl_num3",,get_full_name());
        this.mc_vmc_wl_num3.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num1_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num1_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num2_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num4;
    rand uvm_reg_field mc_vmc_wl_num5;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num4 = uvm_reg_field::type_id::create("mc_vmc_wl_num4",,get_full_name());
        this.mc_vmc_wl_num4.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num5 = uvm_reg_field::type_id::create("mc_vmc_wl_num5",,get_full_name());
        this.mc_vmc_wl_num5.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num2_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num2_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num3_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num6;
    rand uvm_reg_field mc_vmc_wl_num7;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num6 = uvm_reg_field::type_id::create("mc_vmc_wl_num6",,get_full_name());
        this.mc_vmc_wl_num6.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num7 = uvm_reg_field::type_id::create("mc_vmc_wl_num7",,get_full_name());
        this.mc_vmc_wl_num7.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num3_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num3_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num4_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num8;
    rand uvm_reg_field mc_vmc_wl_num9;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num8 = uvm_reg_field::type_id::create("mc_vmc_wl_num8",,get_full_name());
        this.mc_vmc_wl_num8.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num9 = uvm_reg_field::type_id::create("mc_vmc_wl_num9",,get_full_name());
        this.mc_vmc_wl_num9.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num4_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num4_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num5_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num10;
    rand uvm_reg_field mc_vmc_wl_num11;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num5_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num10 = uvm_reg_field::type_id::create("mc_vmc_wl_num10",,get_full_name());
        this.mc_vmc_wl_num10.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num11 = uvm_reg_field::type_id::create("mc_vmc_wl_num11",,get_full_name());
        this.mc_vmc_wl_num11.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num5_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num5_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num6_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num12;
    rand uvm_reg_field mc_vmc_wl_num13;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num6_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num12 = uvm_reg_field::type_id::create("mc_vmc_wl_num12",,get_full_name());
        this.mc_vmc_wl_num12.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num13 = uvm_reg_field::type_id::create("mc_vmc_wl_num13",,get_full_name());
        this.mc_vmc_wl_num13.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num6_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num6_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num7_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num14;
    rand uvm_reg_field mc_vmc_wl_num15;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num7_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num14 = uvm_reg_field::type_id::create("mc_vmc_wl_num14",,get_full_name());
        this.mc_vmc_wl_num14.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num15 = uvm_reg_field::type_id::create("mc_vmc_wl_num15",,get_full_name());
        this.mc_vmc_wl_num15.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num7_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num7_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num8_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num16;
    rand uvm_reg_field mc_vmc_wl_num17;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num8_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num16 = uvm_reg_field::type_id::create("mc_vmc_wl_num16",,get_full_name());
        this.mc_vmc_wl_num16.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num17 = uvm_reg_field::type_id::create("mc_vmc_wl_num17",,get_full_name());
        this.mc_vmc_wl_num17.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num8_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num8_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num9_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num18;
    rand uvm_reg_field mc_vmc_wl_num19;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num9_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num18 = uvm_reg_field::type_id::create("mc_vmc_wl_num18",,get_full_name());
        this.mc_vmc_wl_num18.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num19 = uvm_reg_field::type_id::create("mc_vmc_wl_num19",,get_full_name());
        this.mc_vmc_wl_num19.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num9_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num9_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num10_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num20;
    rand uvm_reg_field mc_vmc_wl_num21;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num10_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num20 = uvm_reg_field::type_id::create("mc_vmc_wl_num20",,get_full_name());
        this.mc_vmc_wl_num20.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num21 = uvm_reg_field::type_id::create("mc_vmc_wl_num21",,get_full_name());
        this.mc_vmc_wl_num21.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num10_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num10_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num11_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num22;
    rand uvm_reg_field mc_vmc_wl_num23;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num11_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num22 = uvm_reg_field::type_id::create("mc_vmc_wl_num22",,get_full_name());
        this.mc_vmc_wl_num22.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num23 = uvm_reg_field::type_id::create("mc_vmc_wl_num23",,get_full_name());
        this.mc_vmc_wl_num23.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num11_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num11_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num12_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num24;
    rand uvm_reg_field mc_vmc_wl_num25;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num12_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num24 = uvm_reg_field::type_id::create("mc_vmc_wl_num24",,get_full_name());
        this.mc_vmc_wl_num24.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num25 = uvm_reg_field::type_id::create("mc_vmc_wl_num25",,get_full_name());
        this.mc_vmc_wl_num25.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num12_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num12_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num13_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num26;
    rand uvm_reg_field mc_vmc_wl_num27;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num13_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num26 = uvm_reg_field::type_id::create("mc_vmc_wl_num26",,get_full_name());
        this.mc_vmc_wl_num26.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num27 = uvm_reg_field::type_id::create("mc_vmc_wl_num27",,get_full_name());
        this.mc_vmc_wl_num27.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num13_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num13_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num14_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num28;
    rand uvm_reg_field mc_vmc_wl_num29;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num14_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num28 = uvm_reg_field::type_id::create("mc_vmc_wl_num28",,get_full_name());
        this.mc_vmc_wl_num28.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num29 = uvm_reg_field::type_id::create("mc_vmc_wl_num29",,get_full_name());
        this.mc_vmc_wl_num29.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num14_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num14_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num15_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num30;
    rand uvm_reg_field mc_vmc_wl_num31;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num15_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num30 = uvm_reg_field::type_id::create("mc_vmc_wl_num30",,get_full_name());
        this.mc_vmc_wl_num30.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num31 = uvm_reg_field::type_id::create("mc_vmc_wl_num31",,get_full_name());
        this.mc_vmc_wl_num31.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num15_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num15_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num16_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num32;
    rand uvm_reg_field mc_vmc_wl_num33;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num16_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num32 = uvm_reg_field::type_id::create("mc_vmc_wl_num32",,get_full_name());
        this.mc_vmc_wl_num32.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num33 = uvm_reg_field::type_id::create("mc_vmc_wl_num33",,get_full_name());
        this.mc_vmc_wl_num33.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num16_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num16_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num17_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num34;
    rand uvm_reg_field mc_vmc_wl_num35;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num17_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num34 = uvm_reg_field::type_id::create("mc_vmc_wl_num34",,get_full_name());
        this.mc_vmc_wl_num34.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num35 = uvm_reg_field::type_id::create("mc_vmc_wl_num35",,get_full_name());
        this.mc_vmc_wl_num35.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num17_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num17_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num18_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num36;
    rand uvm_reg_field mc_vmc_wl_num37;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num18_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num36 = uvm_reg_field::type_id::create("mc_vmc_wl_num36",,get_full_name());
        this.mc_vmc_wl_num36.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num37 = uvm_reg_field::type_id::create("mc_vmc_wl_num37",,get_full_name());
        this.mc_vmc_wl_num37.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num18_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num18_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num19_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num38;
    rand uvm_reg_field mc_vmc_wl_num39;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num19_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num38 = uvm_reg_field::type_id::create("mc_vmc_wl_num38",,get_full_name());
        this.mc_vmc_wl_num38.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num39 = uvm_reg_field::type_id::create("mc_vmc_wl_num39",,get_full_name());
        this.mc_vmc_wl_num39.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num19_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num19_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num20_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num40;
    rand uvm_reg_field mc_vmc_wl_num41;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num20_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num40 = uvm_reg_field::type_id::create("mc_vmc_wl_num40",,get_full_name());
        this.mc_vmc_wl_num40.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num41 = uvm_reg_field::type_id::create("mc_vmc_wl_num41",,get_full_name());
        this.mc_vmc_wl_num41.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num20_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num20_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num21_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num42;
    rand uvm_reg_field mc_vmc_wl_num43;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num21_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num42 = uvm_reg_field::type_id::create("mc_vmc_wl_num42",,get_full_name());
        this.mc_vmc_wl_num42.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num43 = uvm_reg_field::type_id::create("mc_vmc_wl_num43",,get_full_name());
        this.mc_vmc_wl_num43.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num21_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num21_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num22_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num44;
    rand uvm_reg_field mc_vmc_wl_num45;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num22_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num44 = uvm_reg_field::type_id::create("mc_vmc_wl_num44",,get_full_name());
        this.mc_vmc_wl_num44.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num45 = uvm_reg_field::type_id::create("mc_vmc_wl_num45",,get_full_name());
        this.mc_vmc_wl_num45.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num22_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num22_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num23_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num46;
    rand uvm_reg_field mc_vmc_wl_num47;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num23_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num46 = uvm_reg_field::type_id::create("mc_vmc_wl_num46",,get_full_name());
        this.mc_vmc_wl_num46.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num47 = uvm_reg_field::type_id::create("mc_vmc_wl_num47",,get_full_name());
        this.mc_vmc_wl_num47.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num23_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num23_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num24_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num48;
    rand uvm_reg_field mc_vmc_wl_num49;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num24_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num48 = uvm_reg_field::type_id::create("mc_vmc_wl_num48",,get_full_name());
        this.mc_vmc_wl_num48.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num49 = uvm_reg_field::type_id::create("mc_vmc_wl_num49",,get_full_name());
        this.mc_vmc_wl_num49.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num24_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num24_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num25_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num50;
    rand uvm_reg_field mc_vmc_wl_num51;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num25_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num50 = uvm_reg_field::type_id::create("mc_vmc_wl_num50",,get_full_name());
        this.mc_vmc_wl_num50.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num51 = uvm_reg_field::type_id::create("mc_vmc_wl_num51",,get_full_name());
        this.mc_vmc_wl_num51.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num25_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num25_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num26_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num52;
    rand uvm_reg_field mc_vmc_wl_num53;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num26_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num52 = uvm_reg_field::type_id::create("mc_vmc_wl_num52",,get_full_name());
        this.mc_vmc_wl_num52.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num53 = uvm_reg_field::type_id::create("mc_vmc_wl_num53",,get_full_name());
        this.mc_vmc_wl_num53.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num26_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num26_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num27_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num54;
    rand uvm_reg_field mc_vmc_wl_num55;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num27_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num54 = uvm_reg_field::type_id::create("mc_vmc_wl_num54",,get_full_name());
        this.mc_vmc_wl_num54.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num55 = uvm_reg_field::type_id::create("mc_vmc_wl_num55",,get_full_name());
        this.mc_vmc_wl_num55.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num27_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num27_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num28_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num56;
    rand uvm_reg_field mc_vmc_wl_num57;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num28_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num56 = uvm_reg_field::type_id::create("mc_vmc_wl_num56",,get_full_name());
        this.mc_vmc_wl_num56.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num57 = uvm_reg_field::type_id::create("mc_vmc_wl_num57",,get_full_name());
        this.mc_vmc_wl_num57.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num28_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num28_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num29_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num58;
    rand uvm_reg_field mc_vmc_wl_num59;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num29_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num58 = uvm_reg_field::type_id::create("mc_vmc_wl_num58",,get_full_name());
        this.mc_vmc_wl_num58.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num59 = uvm_reg_field::type_id::create("mc_vmc_wl_num59",,get_full_name());
        this.mc_vmc_wl_num59.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num29_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num29_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num30_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num60;
    rand uvm_reg_field mc_vmc_wl_num61;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num30_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num60 = uvm_reg_field::type_id::create("mc_vmc_wl_num60",,get_full_name());
        this.mc_vmc_wl_num60.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num61 = uvm_reg_field::type_id::create("mc_vmc_wl_num61",,get_full_name());
        this.mc_vmc_wl_num61.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num30_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num30_reg

class ral_reg_mc_wrapper_top_mc_vmc_wl_num31_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num62;
    rand uvm_reg_field mc_vmc_wl_num63;

    function new(string name = "mc_wrapper_top_mc_vmc_wl_num31_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num62 = uvm_reg_field::type_id::create("mc_vmc_wl_num62",,get_full_name());
        this.mc_vmc_wl_num62.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num63 = uvm_reg_field::type_id::create("mc_vmc_wl_num63",,get_full_name());
        this.mc_vmc_wl_num63.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_wl_num31_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_wl_num31_reg

class ral_reg_mc_wrapper_top_mc_vmc_bl_num0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part0;
    rand uvm_reg_field mc_vmc_bl_num1_part0;
    rand uvm_reg_field mc_vmc_bl_num0_part1;
    rand uvm_reg_field mc_vmc_bl_num1_part1;

    function new(string name = "mc_wrapper_top_mc_vmc_bl_num0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part0 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part0",,get_full_name());
        this.mc_vmc_bl_num0_part0.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part0 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part0",,get_full_name());
        this.mc_vmc_bl_num1_part0.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part1 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part1",,get_full_name());
        this.mc_vmc_bl_num0_part1.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part1 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part1",,get_full_name());
        this.mc_vmc_bl_num1_part1.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_bl_num0_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_bl_num0_reg

class ral_reg_mc_wrapper_top_mc_vmc_bl_num1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part2;
    rand uvm_reg_field mc_vmc_bl_num1_part2;
    rand uvm_reg_field mc_vmc_bl_num0_part3;
    rand uvm_reg_field mc_vmc_bl_num1_part3;

    function new(string name = "mc_wrapper_top_mc_vmc_bl_num1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part2 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part2",,get_full_name());
        this.mc_vmc_bl_num0_part2.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part2 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part2",,get_full_name());
        this.mc_vmc_bl_num1_part2.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part3 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part3",,get_full_name());
        this.mc_vmc_bl_num0_part3.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part3 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part3",,get_full_name());
        this.mc_vmc_bl_num1_part3.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_bl_num1_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_bl_num1_reg

class ral_reg_mc_wrapper_top_mc_vmc_bl_num2_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part4;
    rand uvm_reg_field mc_vmc_bl_num1_part4;
    rand uvm_reg_field mc_vmc_bl_num0_part5;
    rand uvm_reg_field mc_vmc_bl_num1_part5;

    function new(string name = "mc_wrapper_top_mc_vmc_bl_num2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part4 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part4",,get_full_name());
        this.mc_vmc_bl_num0_part4.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part4 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part4",,get_full_name());
        this.mc_vmc_bl_num1_part4.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part5 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part5",,get_full_name());
        this.mc_vmc_bl_num0_part5.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part5 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part5",,get_full_name());
        this.mc_vmc_bl_num1_part5.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_bl_num2_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_bl_num2_reg

class ral_reg_mc_wrapper_top_mc_vmc_bl_num3_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part6;
    rand uvm_reg_field mc_vmc_bl_num1_part6;
    rand uvm_reg_field mc_vmc_bl_num0_part7;
    rand uvm_reg_field mc_vmc_bl_num1_part7;

    function new(string name = "mc_wrapper_top_mc_vmc_bl_num3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part6 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part6",,get_full_name());
        this.mc_vmc_bl_num0_part6.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part6 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part6",,get_full_name());
        this.mc_vmc_bl_num1_part6.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part7 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part7",,get_full_name());
        this.mc_vmc_bl_num0_part7.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part7 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part7",,get_full_name());
        this.mc_vmc_bl_num1_part7.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_bl_num3_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_bl_num3_reg

class ral_reg_mc_wrapper_top_mc_vmc_bl_num4_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part8;
    rand uvm_reg_field mc_vmc_bl_num1_part8;
    rand uvm_reg_field mc_vmc_bl_num0_part9;
    rand uvm_reg_field mc_vmc_bl_num1_part9;

    function new(string name = "mc_wrapper_top_mc_vmc_bl_num4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part8 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part8",,get_full_name());
        this.mc_vmc_bl_num0_part8.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part8 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part8",,get_full_name());
        this.mc_vmc_bl_num1_part8.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part9 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part9",,get_full_name());
        this.mc_vmc_bl_num0_part9.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part9 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part9",,get_full_name());
        this.mc_vmc_bl_num1_part9.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_vmc_bl_num4_reg)
endclass:ral_reg_mc_wrapper_top_mc_vmc_bl_num4_reg

class ral_reg_mc_wrapper_top_mc_frame2array_dbg_reg extends uvm_reg;
    rand uvm_reg_field dbg_next_state_array;
    rand uvm_reg_field dbg_current_state_array;
    rand uvm_reg_field dbg_r_data_cnt;
    rand uvm_reg_field dbg_refresh_flag;
    rand uvm_reg_field dbg_r_frame_cnt;
    rand uvm_reg_field dbg_w_frame_cnt;
    rand uvm_reg_field ras_clr;

    function new(string name = "mc_wrapper_top_mc_frame2array_dbg_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_next_state_array = uvm_reg_field::type_id::create("dbg_next_state_array",,get_full_name());
        this.dbg_next_state_array.configure(this,5,0,"RO",0,32'h0,1,0,0);
        this.dbg_current_state_array = uvm_reg_field::type_id::create("dbg_current_state_array",,get_full_name());
        this.dbg_current_state_array.configure(this,5,8,"RO",0,32'h0,1,0,0);
        this.dbg_r_data_cnt = uvm_reg_field::type_id::create("dbg_r_data_cnt",,get_full_name());
        this.dbg_r_data_cnt.configure(this,2,16,"RO",0,32'h0,1,0,0);
        this.dbg_refresh_flag = uvm_reg_field::type_id::create("dbg_refresh_flag",,get_full_name());
        this.dbg_refresh_flag.configure(this,1,20,"RO",0,32'h0,1,0,0);
        this.dbg_r_frame_cnt = uvm_reg_field::type_id::create("dbg_r_frame_cnt",,get_full_name());
        this.dbg_r_frame_cnt.configure(this,2,24,"RO",0,32'h0,1,0,0);
        this.dbg_w_frame_cnt = uvm_reg_field::type_id::create("dbg_w_frame_cnt",,get_full_name());
        this.dbg_w_frame_cnt.configure(this,2,28,"RO",0,32'h0,1,0,0);
        this.ras_clr = uvm_reg_field::type_id::create("ras_clr",,get_full_name());
        this.ras_clr.configure(this,1,31,"W1C",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_frame2array_dbg_reg)
endclass:ral_reg_mc_wrapper_top_mc_frame2array_dbg_reg

class ral_reg_mc_wrapper_top_mc_timeout_clr_reg extends uvm_reg;
    rand uvm_reg_field mc_timeout_clr;

    function new(string name = "mc_wrapper_top_mc_timeout_clr_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_timeout_clr = uvm_reg_field::type_id::create("mc_timeout_clr",,get_full_name());
        this.mc_timeout_clr.configure(this,1,0,"W1C",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_timeout_clr_reg)
endclass:ral_reg_mc_wrapper_top_mc_timeout_clr_reg

class ral_reg_mc_wrapper_top_mc_rf_start_dbg_reg extends uvm_reg;
    rand uvm_reg_field mc_rf_start_dbg;

    function new(string name = "mc_wrapper_top_mc_rf_start_dbg_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_rf_start_dbg = uvm_reg_field::type_id::create("mc_rf_start_dbg",,get_full_name());
        this.mc_rf_start_dbg.configure(this,1,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_rf_start_dbg_reg)
endclass:ral_reg_mc_wrapper_top_mc_rf_start_dbg_reg

class ral_reg_mc_wrapper_top_mc_timeout_flag_reg extends uvm_reg;
    rand uvm_reg_field mc_timeout_flag;

    function new(string name = "mc_wrapper_top_mc_timeout_flag_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_timeout_flag = uvm_reg_field::type_id::create("mc_timeout_flag",,get_full_name());
        this.mc_timeout_flag.configure(this,1,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_timeout_flag_reg)
endclass:ral_reg_mc_wrapper_top_mc_timeout_flag_reg

class ral_reg_mc_wrapper_top_mc_bist_status_reg extends uvm_reg;
    rand uvm_reg_field mc_bist_status;
    rand uvm_reg_field mc_bist_path_fail;
    rand uvm_reg_field dram_init_finish;

    function new(string name = "mc_wrapper_top_mc_bist_status_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bist_status = uvm_reg_field::type_id::create("mc_bist_status",,get_full_name());
        this.mc_bist_status.configure(this,3,0,"RO",0,32'h0,1,0,0);
        this.mc_bist_path_fail = uvm_reg_field::type_id::create("mc_bist_path_fail",,get_full_name());
        this.mc_bist_path_fail.configure(this,1,3,"RO",0,32'h0,1,0,0);
        this.dram_init_finish = uvm_reg_field::type_id::create("dram_init_finish",,get_full_name());
        this.dram_init_finish.configure(this,1,4,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bist_status_reg)
endclass:ral_reg_mc_wrapper_top_mc_bist_status_reg

class ral_reg_mc_wrapper_top_bist_finish_reg extends uvm_reg;
    rand uvm_reg_field bist_finish;
    rand uvm_reg_field bist_rescan_finish;

    function new(string name = "mc_wrapper_top_bist_finish_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_finish = uvm_reg_field::type_id::create("bist_finish",,get_full_name());
        this.bist_finish.configure(this,1,0,"RO",0,32'h0,1,0,0);
        this.bist_rescan_finish = uvm_reg_field::type_id::create("bist_rescan_finish",,get_full_name());
        this.bist_rescan_finish.configure(this,1,1,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bist_finish_reg)
endclass:ral_reg_mc_wrapper_top_bist_finish_reg

class ral_reg_mc_wrapper_top_bank_success_reg extends uvm_reg;
    rand uvm_reg_field bank_success;
    rand uvm_reg_field bist_rescan_success;

    function new(string name = "mc_wrapper_top_bank_success_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank_success = uvm_reg_field::type_id::create("bank_success",,get_full_name());
        this.bank_success.configure(this,1,0,"RO",0,32'h0,1,0,0);
        this.bist_rescan_success = uvm_reg_field::type_id::create("bist_rescan_success",,get_full_name());
        this.bist_rescan_success.configure(this,1,1,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank_success_reg)
endclass:ral_reg_mc_wrapper_top_bank_success_reg

class ral_reg_mc_wrapper_top_err_csl0_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part0;
    rand uvm_reg_field err_csl1_part0;
    rand uvm_reg_field err_csl0_part1;
    rand uvm_reg_field err_csl1_part1;

    function new(string name = "mc_wrapper_top_err_csl0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part0 = uvm_reg_field::type_id::create("err_csl0_part0",,get_full_name());
        this.err_csl0_part0.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part0 = uvm_reg_field::type_id::create("err_csl1_part0",,get_full_name());
        this.err_csl1_part0.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part1 = uvm_reg_field::type_id::create("err_csl0_part1",,get_full_name());
        this.err_csl0_part1.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part1 = uvm_reg_field::type_id::create("err_csl1_part1",,get_full_name());
        this.err_csl1_part1.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_csl0_reg)
endclass:ral_reg_mc_wrapper_top_err_csl0_reg

class ral_reg_mc_wrapper_top_err_csl1_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part2;
    rand uvm_reg_field err_csl1_part2;
    rand uvm_reg_field err_csl0_part3;
    rand uvm_reg_field err_csl1_part3;

    function new(string name = "mc_wrapper_top_err_csl1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part2 = uvm_reg_field::type_id::create("err_csl0_part2",,get_full_name());
        this.err_csl0_part2.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part2 = uvm_reg_field::type_id::create("err_csl1_part2",,get_full_name());
        this.err_csl1_part2.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part3 = uvm_reg_field::type_id::create("err_csl0_part3",,get_full_name());
        this.err_csl0_part3.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part3 = uvm_reg_field::type_id::create("err_csl1_part3",,get_full_name());
        this.err_csl1_part3.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_csl1_reg)
endclass:ral_reg_mc_wrapper_top_err_csl1_reg

class ral_reg_mc_wrapper_top_err_csl2_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part4;
    rand uvm_reg_field err_csl1_part4;
    rand uvm_reg_field err_csl0_part5;
    rand uvm_reg_field err_csl1_part5;

    function new(string name = "mc_wrapper_top_err_csl2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part4 = uvm_reg_field::type_id::create("err_csl0_part4",,get_full_name());
        this.err_csl0_part4.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part4 = uvm_reg_field::type_id::create("err_csl1_part4",,get_full_name());
        this.err_csl1_part4.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part5 = uvm_reg_field::type_id::create("err_csl0_part5",,get_full_name());
        this.err_csl0_part5.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part5 = uvm_reg_field::type_id::create("err_csl1_part5",,get_full_name());
        this.err_csl1_part5.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_csl2_reg)
endclass:ral_reg_mc_wrapper_top_err_csl2_reg

class ral_reg_mc_wrapper_top_err_csl3_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part6;
    rand uvm_reg_field err_csl1_part6;
    rand uvm_reg_field err_csl0_part7;
    rand uvm_reg_field err_csl1_part7;

    function new(string name = "mc_wrapper_top_err_csl3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part6 = uvm_reg_field::type_id::create("err_csl0_part6",,get_full_name());
        this.err_csl0_part6.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part6 = uvm_reg_field::type_id::create("err_csl1_part6",,get_full_name());
        this.err_csl1_part6.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part7 = uvm_reg_field::type_id::create("err_csl0_part7",,get_full_name());
        this.err_csl0_part7.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part7 = uvm_reg_field::type_id::create("err_csl1_part7",,get_full_name());
        this.err_csl1_part7.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_csl3_reg)
endclass:ral_reg_mc_wrapper_top_err_csl3_reg

class ral_reg_mc_wrapper_top_err_csl4_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part8;
    rand uvm_reg_field err_csl1_part8;
    rand uvm_reg_field err_csl0_part9;
    rand uvm_reg_field err_csl1_part9;

    function new(string name = "mc_wrapper_top_err_csl4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part8 = uvm_reg_field::type_id::create("err_csl0_part8",,get_full_name());
        this.err_csl0_part8.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part8 = uvm_reg_field::type_id::create("err_csl1_part8",,get_full_name());
        this.err_csl1_part8.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part9 = uvm_reg_field::type_id::create("err_csl0_part9",,get_full_name());
        this.err_csl0_part9.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part9 = uvm_reg_field::type_id::create("err_csl1_part9",,get_full_name());
        this.err_csl1_part9.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_csl4_reg)
endclass:ral_reg_mc_wrapper_top_err_csl4_reg

class ral_reg_mc_wrapper_top_err_wl0_reg extends uvm_reg;
    rand uvm_reg_field err_wl0;
    rand uvm_reg_field err_wl1;

    function new(string name = "mc_wrapper_top_err_wl0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl0 = uvm_reg_field::type_id::create("err_wl0",,get_full_name());
        this.err_wl0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl1 = uvm_reg_field::type_id::create("err_wl1",,get_full_name());
        this.err_wl1.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl0_reg)
endclass:ral_reg_mc_wrapper_top_err_wl0_reg

class ral_reg_mc_wrapper_top_err_wl1_reg extends uvm_reg;
    rand uvm_reg_field err_wl2;
    rand uvm_reg_field err_wl3;

    function new(string name = "mc_wrapper_top_err_wl1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl2 = uvm_reg_field::type_id::create("err_wl2",,get_full_name());
        this.err_wl2.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl3 = uvm_reg_field::type_id::create("err_wl3",,get_full_name());
        this.err_wl3.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl1_reg)
endclass:ral_reg_mc_wrapper_top_err_wl1_reg

class ral_reg_mc_wrapper_top_err_wl2_reg extends uvm_reg;
    rand uvm_reg_field err_wl4;
    rand uvm_reg_field err_wl5;

    function new(string name = "mc_wrapper_top_err_wl2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl4 = uvm_reg_field::type_id::create("err_wl4",,get_full_name());
        this.err_wl4.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl5 = uvm_reg_field::type_id::create("err_wl5",,get_full_name());
        this.err_wl5.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl2_reg)
endclass:ral_reg_mc_wrapper_top_err_wl2_reg

class ral_reg_mc_wrapper_top_err_wl3_reg extends uvm_reg;
    rand uvm_reg_field err_wl6;
    rand uvm_reg_field err_wl7;

    function new(string name = "mc_wrapper_top_err_wl3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl6 = uvm_reg_field::type_id::create("err_wl6",,get_full_name());
        this.err_wl6.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl7 = uvm_reg_field::type_id::create("err_wl7",,get_full_name());
        this.err_wl7.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl3_reg)
endclass:ral_reg_mc_wrapper_top_err_wl3_reg

class ral_reg_mc_wrapper_top_err_wl4_reg extends uvm_reg;
    rand uvm_reg_field err_wl8;
    rand uvm_reg_field err_wl9;

    function new(string name = "mc_wrapper_top_err_wl4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl8 = uvm_reg_field::type_id::create("err_wl8",,get_full_name());
        this.err_wl8.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl9 = uvm_reg_field::type_id::create("err_wl9",,get_full_name());
        this.err_wl9.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl4_reg)
endclass:ral_reg_mc_wrapper_top_err_wl4_reg

class ral_reg_mc_wrapper_top_err_wl5_reg extends uvm_reg;
    rand uvm_reg_field err_wl10;
    rand uvm_reg_field err_wl11;

    function new(string name = "mc_wrapper_top_err_wl5_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl10 = uvm_reg_field::type_id::create("err_wl10",,get_full_name());
        this.err_wl10.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl11 = uvm_reg_field::type_id::create("err_wl11",,get_full_name());
        this.err_wl11.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl5_reg)
endclass:ral_reg_mc_wrapper_top_err_wl5_reg

class ral_reg_mc_wrapper_top_err_wl6_reg extends uvm_reg;
    rand uvm_reg_field err_wl12;
    rand uvm_reg_field err_wl13;

    function new(string name = "mc_wrapper_top_err_wl6_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl12 = uvm_reg_field::type_id::create("err_wl12",,get_full_name());
        this.err_wl12.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl13 = uvm_reg_field::type_id::create("err_wl13",,get_full_name());
        this.err_wl13.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl6_reg)
endclass:ral_reg_mc_wrapper_top_err_wl6_reg

class ral_reg_mc_wrapper_top_err_wl7_reg extends uvm_reg;
    rand uvm_reg_field err_wl14;
    rand uvm_reg_field err_wl15;

    function new(string name = "mc_wrapper_top_err_wl7_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl14 = uvm_reg_field::type_id::create("err_wl14",,get_full_name());
        this.err_wl14.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl15 = uvm_reg_field::type_id::create("err_wl15",,get_full_name());
        this.err_wl15.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl7_reg)
endclass:ral_reg_mc_wrapper_top_err_wl7_reg

class ral_reg_mc_wrapper_top_err_wl8_reg extends uvm_reg;
    rand uvm_reg_field err_wl16;
    rand uvm_reg_field err_wl17;

    function new(string name = "mc_wrapper_top_err_wl8_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl16 = uvm_reg_field::type_id::create("err_wl16",,get_full_name());
        this.err_wl16.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl17 = uvm_reg_field::type_id::create("err_wl17",,get_full_name());
        this.err_wl17.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl8_reg)
endclass:ral_reg_mc_wrapper_top_err_wl8_reg

class ral_reg_mc_wrapper_top_err_wl9_reg extends uvm_reg;
    rand uvm_reg_field err_wl18;
    rand uvm_reg_field err_wl19;

    function new(string name = "mc_wrapper_top_err_wl9_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl18 = uvm_reg_field::type_id::create("err_wl18",,get_full_name());
        this.err_wl18.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl19 = uvm_reg_field::type_id::create("err_wl19",,get_full_name());
        this.err_wl19.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl9_reg)
endclass:ral_reg_mc_wrapper_top_err_wl9_reg

class ral_reg_mc_wrapper_top_err_wl10_reg extends uvm_reg;
    rand uvm_reg_field err_wl20;
    rand uvm_reg_field err_wl21;

    function new(string name = "mc_wrapper_top_err_wl10_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl20 = uvm_reg_field::type_id::create("err_wl20",,get_full_name());
        this.err_wl20.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl21 = uvm_reg_field::type_id::create("err_wl21",,get_full_name());
        this.err_wl21.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl10_reg)
endclass:ral_reg_mc_wrapper_top_err_wl10_reg

class ral_reg_mc_wrapper_top_err_wl11_reg extends uvm_reg;
    rand uvm_reg_field err_wl22;
    rand uvm_reg_field err_wl23;

    function new(string name = "mc_wrapper_top_err_wl11_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl22 = uvm_reg_field::type_id::create("err_wl22",,get_full_name());
        this.err_wl22.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl23 = uvm_reg_field::type_id::create("err_wl23",,get_full_name());
        this.err_wl23.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl11_reg)
endclass:ral_reg_mc_wrapper_top_err_wl11_reg

class ral_reg_mc_wrapper_top_err_wl12_reg extends uvm_reg;
    rand uvm_reg_field err_wl24;
    rand uvm_reg_field err_wl25;

    function new(string name = "mc_wrapper_top_err_wl12_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl24 = uvm_reg_field::type_id::create("err_wl24",,get_full_name());
        this.err_wl24.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl25 = uvm_reg_field::type_id::create("err_wl25",,get_full_name());
        this.err_wl25.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl12_reg)
endclass:ral_reg_mc_wrapper_top_err_wl12_reg

class ral_reg_mc_wrapper_top_err_wl13_reg extends uvm_reg;
    rand uvm_reg_field err_wl26;
    rand uvm_reg_field err_wl27;

    function new(string name = "mc_wrapper_top_err_wl13_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl26 = uvm_reg_field::type_id::create("err_wl26",,get_full_name());
        this.err_wl26.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl27 = uvm_reg_field::type_id::create("err_wl27",,get_full_name());
        this.err_wl27.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl13_reg)
endclass:ral_reg_mc_wrapper_top_err_wl13_reg

class ral_reg_mc_wrapper_top_err_wl14_reg extends uvm_reg;
    rand uvm_reg_field err_wl28;
    rand uvm_reg_field err_wl29;

    function new(string name = "mc_wrapper_top_err_wl14_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl28 = uvm_reg_field::type_id::create("err_wl28",,get_full_name());
        this.err_wl28.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl29 = uvm_reg_field::type_id::create("err_wl29",,get_full_name());
        this.err_wl29.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl14_reg)
endclass:ral_reg_mc_wrapper_top_err_wl14_reg

class ral_reg_mc_wrapper_top_err_wl15_reg extends uvm_reg;
    rand uvm_reg_field err_wl30;
    rand uvm_reg_field err_wl31;

    function new(string name = "mc_wrapper_top_err_wl15_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl30 = uvm_reg_field::type_id::create("err_wl30",,get_full_name());
        this.err_wl30.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl31 = uvm_reg_field::type_id::create("err_wl31",,get_full_name());
        this.err_wl31.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl15_reg)
endclass:ral_reg_mc_wrapper_top_err_wl15_reg

class ral_reg_mc_wrapper_top_err_wl16_reg extends uvm_reg;
    rand uvm_reg_field err_wl32;
    rand uvm_reg_field err_wl33;

    function new(string name = "mc_wrapper_top_err_wl16_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl32 = uvm_reg_field::type_id::create("err_wl32",,get_full_name());
        this.err_wl32.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl33 = uvm_reg_field::type_id::create("err_wl33",,get_full_name());
        this.err_wl33.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl16_reg)
endclass:ral_reg_mc_wrapper_top_err_wl16_reg

class ral_reg_mc_wrapper_top_err_wl17_reg extends uvm_reg;
    rand uvm_reg_field err_wl34;
    rand uvm_reg_field err_wl35;

    function new(string name = "mc_wrapper_top_err_wl17_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl34 = uvm_reg_field::type_id::create("err_wl34",,get_full_name());
        this.err_wl34.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl35 = uvm_reg_field::type_id::create("err_wl35",,get_full_name());
        this.err_wl35.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl17_reg)
endclass:ral_reg_mc_wrapper_top_err_wl17_reg

class ral_reg_mc_wrapper_top_err_wl18_reg extends uvm_reg;
    rand uvm_reg_field err_wl36;
    rand uvm_reg_field err_wl37;

    function new(string name = "mc_wrapper_top_err_wl18_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl36 = uvm_reg_field::type_id::create("err_wl36",,get_full_name());
        this.err_wl36.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl37 = uvm_reg_field::type_id::create("err_wl37",,get_full_name());
        this.err_wl37.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl18_reg)
endclass:ral_reg_mc_wrapper_top_err_wl18_reg

class ral_reg_mc_wrapper_top_err_wl19_reg extends uvm_reg;
    rand uvm_reg_field err_wl38;
    rand uvm_reg_field err_wl39;

    function new(string name = "mc_wrapper_top_err_wl19_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl38 = uvm_reg_field::type_id::create("err_wl38",,get_full_name());
        this.err_wl38.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl39 = uvm_reg_field::type_id::create("err_wl39",,get_full_name());
        this.err_wl39.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl19_reg)
endclass:ral_reg_mc_wrapper_top_err_wl19_reg

class ral_reg_mc_wrapper_top_err_wl20_reg extends uvm_reg;
    rand uvm_reg_field err_wl40;
    rand uvm_reg_field err_wl41;

    function new(string name = "mc_wrapper_top_err_wl20_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl40 = uvm_reg_field::type_id::create("err_wl40",,get_full_name());
        this.err_wl40.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl41 = uvm_reg_field::type_id::create("err_wl41",,get_full_name());
        this.err_wl41.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl20_reg)
endclass:ral_reg_mc_wrapper_top_err_wl20_reg

class ral_reg_mc_wrapper_top_err_wl21_reg extends uvm_reg;
    rand uvm_reg_field err_wl42;
    rand uvm_reg_field err_wl43;

    function new(string name = "mc_wrapper_top_err_wl21_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl42 = uvm_reg_field::type_id::create("err_wl42",,get_full_name());
        this.err_wl42.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl43 = uvm_reg_field::type_id::create("err_wl43",,get_full_name());
        this.err_wl43.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl21_reg)
endclass:ral_reg_mc_wrapper_top_err_wl21_reg

class ral_reg_mc_wrapper_top_err_wl22_reg extends uvm_reg;
    rand uvm_reg_field err_wl44;
    rand uvm_reg_field err_wl45;

    function new(string name = "mc_wrapper_top_err_wl22_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl44 = uvm_reg_field::type_id::create("err_wl44",,get_full_name());
        this.err_wl44.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl45 = uvm_reg_field::type_id::create("err_wl45",,get_full_name());
        this.err_wl45.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl22_reg)
endclass:ral_reg_mc_wrapper_top_err_wl22_reg

class ral_reg_mc_wrapper_top_err_wl23_reg extends uvm_reg;
    rand uvm_reg_field err_wl46;
    rand uvm_reg_field err_wl47;

    function new(string name = "mc_wrapper_top_err_wl23_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl46 = uvm_reg_field::type_id::create("err_wl46",,get_full_name());
        this.err_wl46.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl47 = uvm_reg_field::type_id::create("err_wl47",,get_full_name());
        this.err_wl47.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl23_reg)
endclass:ral_reg_mc_wrapper_top_err_wl23_reg

class ral_reg_mc_wrapper_top_err_wl24_reg extends uvm_reg;
    rand uvm_reg_field err_wl48;
    rand uvm_reg_field err_wl49;

    function new(string name = "mc_wrapper_top_err_wl24_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl48 = uvm_reg_field::type_id::create("err_wl48",,get_full_name());
        this.err_wl48.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl49 = uvm_reg_field::type_id::create("err_wl49",,get_full_name());
        this.err_wl49.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl24_reg)
endclass:ral_reg_mc_wrapper_top_err_wl24_reg

class ral_reg_mc_wrapper_top_err_wl25_reg extends uvm_reg;
    rand uvm_reg_field err_wl50;
    rand uvm_reg_field err_wl51;

    function new(string name = "mc_wrapper_top_err_wl25_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl50 = uvm_reg_field::type_id::create("err_wl50",,get_full_name());
        this.err_wl50.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl51 = uvm_reg_field::type_id::create("err_wl51",,get_full_name());
        this.err_wl51.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl25_reg)
endclass:ral_reg_mc_wrapper_top_err_wl25_reg

class ral_reg_mc_wrapper_top_err_wl26_reg extends uvm_reg;
    rand uvm_reg_field err_wl52;
    rand uvm_reg_field err_wl53;

    function new(string name = "mc_wrapper_top_err_wl26_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl52 = uvm_reg_field::type_id::create("err_wl52",,get_full_name());
        this.err_wl52.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl53 = uvm_reg_field::type_id::create("err_wl53",,get_full_name());
        this.err_wl53.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl26_reg)
endclass:ral_reg_mc_wrapper_top_err_wl26_reg

class ral_reg_mc_wrapper_top_err_wl27_reg extends uvm_reg;
    rand uvm_reg_field err_wl54;
    rand uvm_reg_field err_wl55;

    function new(string name = "mc_wrapper_top_err_wl27_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl54 = uvm_reg_field::type_id::create("err_wl54",,get_full_name());
        this.err_wl54.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl55 = uvm_reg_field::type_id::create("err_wl55",,get_full_name());
        this.err_wl55.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl27_reg)
endclass:ral_reg_mc_wrapper_top_err_wl27_reg

class ral_reg_mc_wrapper_top_err_wl28_reg extends uvm_reg;
    rand uvm_reg_field err_wl56;
    rand uvm_reg_field err_wl57;

    function new(string name = "mc_wrapper_top_err_wl28_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl56 = uvm_reg_field::type_id::create("err_wl56",,get_full_name());
        this.err_wl56.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl57 = uvm_reg_field::type_id::create("err_wl57",,get_full_name());
        this.err_wl57.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl28_reg)
endclass:ral_reg_mc_wrapper_top_err_wl28_reg

class ral_reg_mc_wrapper_top_err_wl29_reg extends uvm_reg;
    rand uvm_reg_field err_wl58;
    rand uvm_reg_field err_wl59;

    function new(string name = "mc_wrapper_top_err_wl29_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl58 = uvm_reg_field::type_id::create("err_wl58",,get_full_name());
        this.err_wl58.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl59 = uvm_reg_field::type_id::create("err_wl59",,get_full_name());
        this.err_wl59.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl29_reg)
endclass:ral_reg_mc_wrapper_top_err_wl29_reg

class ral_reg_mc_wrapper_top_err_wl30_reg extends uvm_reg;
    rand uvm_reg_field err_wl60;
    rand uvm_reg_field err_wl61;

    function new(string name = "mc_wrapper_top_err_wl30_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl60 = uvm_reg_field::type_id::create("err_wl60",,get_full_name());
        this.err_wl60.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl61 = uvm_reg_field::type_id::create("err_wl61",,get_full_name());
        this.err_wl61.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl30_reg)
endclass:ral_reg_mc_wrapper_top_err_wl30_reg

class ral_reg_mc_wrapper_top_err_wl31_reg extends uvm_reg;
    rand uvm_reg_field err_wl62;
    rand uvm_reg_field err_wl63;

    function new(string name = "mc_wrapper_top_err_wl31_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl62 = uvm_reg_field::type_id::create("err_wl62",,get_full_name());
        this.err_wl62.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl63 = uvm_reg_field::type_id::create("err_wl63",,get_full_name());
        this.err_wl63.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_err_wl31_reg)
endclass:ral_reg_mc_wrapper_top_err_wl31_reg

class ral_reg_mc_wrapper_top_bist_finish_clr_reg extends uvm_reg;
    rand uvm_reg_field bist_finish_clr;

    function new(string name = "mc_wrapper_top_bist_finish_clr_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_finish_clr = uvm_reg_field::type_id::create("bist_finish_clr",,get_full_name());
        this.bist_finish_clr.configure(this,1,0,"W1C",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bist_finish_clr_reg)
endclass:ral_reg_mc_wrapper_top_bist_finish_clr_reg

class ral_reg_mc_wrapper_top_bist_finish_mask_reg extends uvm_reg;
    rand uvm_reg_field bist_finish_mask;

    function new(string name = "mc_wrapper_top_bist_finish_mask_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_finish_mask = uvm_reg_field::type_id::create("bist_finish_mask",,get_full_name());
        this.bist_finish_mask.configure(this,1,0,"RW",0,32'h1,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bist_finish_mask_reg)
endclass:ral_reg_mc_wrapper_top_bist_finish_mask_reg

class ral_reg_mc_wrapper_top_hang_timeout_th_reg extends uvm_reg;
    rand uvm_reg_field hang_timeout_th;

    function new(string name = "mc_wrapper_top_hang_timeout_th_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hang_timeout_th = uvm_reg_field::type_id::create("hang_timeout_th",,get_full_name());
        this.hang_timeout_th.configure(this,32,0,"RW",0,32'h186a00,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_hang_timeout_th_reg)
endclass:ral_reg_mc_wrapper_top_hang_timeout_th_reg

class ral_reg_mc_wrapper_top_mc_bist_rescan_fail_num_reg extends uvm_reg;
    rand uvm_reg_field mc_bist_rescan_fail_num;

    function new(string name = "mc_wrapper_top_mc_bist_rescan_fail_num_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bist_rescan_fail_num = uvm_reg_field::type_id::create("mc_bist_rescan_fail_num",,get_full_name());
        this.mc_bist_rescan_fail_num.configure(this,20,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bist_rescan_fail_num_reg)
endclass:ral_reg_mc_wrapper_top_mc_bist_rescan_fail_num_reg

class ral_reg_mc_wrapper_top_mc_bist_err_wl_reg extends uvm_reg;
    rand uvm_reg_field mc_bist_err_wl_num;
    rand uvm_reg_field err_wl_num_change_flag;

    function new(string name = "mc_wrapper_top_mc_bist_err_wl_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bist_err_wl_num = uvm_reg_field::type_id::create("mc_bist_err_wl_num",,get_full_name());
        this.mc_bist_err_wl_num.configure(this,7,0,"RO",0,32'h0,1,0,0);
        this.err_wl_num_change_flag = uvm_reg_field::type_id::create("err_wl_num_change_flag",,get_full_name());
        this.err_wl_num_change_flag.configure(this,1,7,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bist_err_wl_reg)
endclass:ral_reg_mc_wrapper_top_mc_bist_err_wl_reg

class ral_reg_mc_wrapper_top_rescan_finish_clr_reg extends uvm_reg;
    rand uvm_reg_field rescan_finish_clr;

    function new(string name = "mc_wrapper_top_rescan_finish_clr_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.rescan_finish_clr = uvm_reg_field::type_id::create("rescan_finish_clr",,get_full_name());
        this.rescan_finish_clr.configure(this,1,0,"W1C",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_rescan_finish_clr_reg)
endclass:ral_reg_mc_wrapper_top_rescan_finish_clr_reg

class ral_reg_mc_wrapper_top_rescan_finish_mask_reg extends uvm_reg;
    rand uvm_reg_field rescan_finish_mask;

    function new(string name = "mc_wrapper_top_rescan_finish_mask_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.rescan_finish_mask = uvm_reg_field::type_id::create("rescan_finish_mask",,get_full_name());
        this.rescan_finish_mask.configure(this,1,0,"RW",0,32'h1,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_rescan_finish_mask_reg)
endclass:ral_reg_mc_wrapper_top_rescan_finish_mask_reg

class ral_reg_mc_wrapper_top_rescan_round_result_reg extends uvm_reg;
    rand uvm_reg_field rescan_round_result;

    function new(string name = "mc_wrapper_top_rescan_round_result_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.rescan_round_result = uvm_reg_field::type_id::create("rescan_round_result",,get_full_name());
        this.rescan_round_result.configure(this,15,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_rescan_round_result_reg)
endclass:ral_reg_mc_wrapper_top_rescan_round_result_reg

class ral_reg_mc_wrapper_top_dbg_frame_store_0_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_0;

    function new(string name = "mc_wrapper_top_dbg_frame_store_0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_0 = uvm_reg_field::type_id::create("dbg_frame_store_0",,get_full_name());
        this.dbg_frame_store_0.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_frame_store_0_reg)
endclass:ral_reg_mc_wrapper_top_dbg_frame_store_0_reg

class ral_reg_mc_wrapper_top_dbg_frame_store_1_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_1;

    function new(string name = "mc_wrapper_top_dbg_frame_store_1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_1 = uvm_reg_field::type_id::create("dbg_frame_store_1",,get_full_name());
        this.dbg_frame_store_1.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_frame_store_1_reg)
endclass:ral_reg_mc_wrapper_top_dbg_frame_store_1_reg

class ral_reg_mc_wrapper_top_dbg_frame_store_2_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_2;

    function new(string name = "mc_wrapper_top_dbg_frame_store_2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_2 = uvm_reg_field::type_id::create("dbg_frame_store_2",,get_full_name());
        this.dbg_frame_store_2.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_frame_store_2_reg)
endclass:ral_reg_mc_wrapper_top_dbg_frame_store_2_reg

class ral_reg_mc_wrapper_top_dbg_frame_store_3_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_3;

    function new(string name = "mc_wrapper_top_dbg_frame_store_3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_3 = uvm_reg_field::type_id::create("dbg_frame_store_3",,get_full_name());
        this.dbg_frame_store_3.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_frame_store_3_reg)
endclass:ral_reg_mc_wrapper_top_dbg_frame_store_3_reg

class ral_reg_mc_wrapper_top_dbg_frame_store_4_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_4;

    function new(string name = "mc_wrapper_top_dbg_frame_store_4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_4 = uvm_reg_field::type_id::create("dbg_frame_store_4",,get_full_name());
        this.dbg_frame_store_4.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_frame_store_4_reg)
endclass:ral_reg_mc_wrapper_top_dbg_frame_store_4_reg

class ral_reg_mc_wrapper_top_dbg_frame_store_5_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_5;

    function new(string name = "mc_wrapper_top_dbg_frame_store_5_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_5 = uvm_reg_field::type_id::create("dbg_frame_store_5",,get_full_name());
        this.dbg_frame_store_5.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_frame_store_5_reg)
endclass:ral_reg_mc_wrapper_top_dbg_frame_store_5_reg

class ral_reg_mc_wrapper_top_dbg_frame_store_6_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_6;

    function new(string name = "mc_wrapper_top_dbg_frame_store_6_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_6 = uvm_reg_field::type_id::create("dbg_frame_store_6",,get_full_name());
        this.dbg_frame_store_6.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_frame_store_6_reg)
endclass:ral_reg_mc_wrapper_top_dbg_frame_store_6_reg

class ral_reg_mc_wrapper_top_dbg_frame_store_7_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_7;

    function new(string name = "mc_wrapper_top_dbg_frame_store_7_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_7 = uvm_reg_field::type_id::create("dbg_frame_store_7",,get_full_name());
        this.dbg_frame_store_7.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_frame_store_7_reg)
endclass:ral_reg_mc_wrapper_top_dbg_frame_store_7_reg

class ral_reg_mc_wrapper_top_dbg_frame_store_8_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_8;

    function new(string name = "mc_wrapper_top_dbg_frame_store_8_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_8 = uvm_reg_field::type_id::create("dbg_frame_store_8",,get_full_name());
        this.dbg_frame_store_8.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_frame_store_8_reg)
endclass:ral_reg_mc_wrapper_top_dbg_frame_store_8_reg

class ral_reg_mc_wrapper_top_dbg_frame_store_9_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_9;

    function new(string name = "mc_wrapper_top_dbg_frame_store_9_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_9 = uvm_reg_field::type_id::create("dbg_frame_store_9",,get_full_name());
        this.dbg_frame_store_9.configure(this,2,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_frame_store_9_reg)
endclass:ral_reg_mc_wrapper_top_dbg_frame_store_9_reg

class ral_reg_mc_wrapper_top_dbg_rdata_store_0_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_0;

    function new(string name = "mc_wrapper_top_dbg_rdata_store_0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_0 = uvm_reg_field::type_id::create("dbg_rdata_store_0",,get_full_name());
        this.dbg_rdata_store_0.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_rdata_store_0_reg)
endclass:ral_reg_mc_wrapper_top_dbg_rdata_store_0_reg

class ral_reg_mc_wrapper_top_dbg_rdata_store_1_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_1;

    function new(string name = "mc_wrapper_top_dbg_rdata_store_1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_1 = uvm_reg_field::type_id::create("dbg_rdata_store_1",,get_full_name());
        this.dbg_rdata_store_1.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_rdata_store_1_reg)
endclass:ral_reg_mc_wrapper_top_dbg_rdata_store_1_reg

class ral_reg_mc_wrapper_top_dbg_rdata_store_2_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_2;

    function new(string name = "mc_wrapper_top_dbg_rdata_store_2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_2 = uvm_reg_field::type_id::create("dbg_rdata_store_2",,get_full_name());
        this.dbg_rdata_store_2.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_rdata_store_2_reg)
endclass:ral_reg_mc_wrapper_top_dbg_rdata_store_2_reg

class ral_reg_mc_wrapper_top_dbg_rdata_store_3_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_3;

    function new(string name = "mc_wrapper_top_dbg_rdata_store_3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_3 = uvm_reg_field::type_id::create("dbg_rdata_store_3",,get_full_name());
        this.dbg_rdata_store_3.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_rdata_store_3_reg)
endclass:ral_reg_mc_wrapper_top_dbg_rdata_store_3_reg

class ral_reg_mc_wrapper_top_dbg_rdata_store_4_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_4;

    function new(string name = "mc_wrapper_top_dbg_rdata_store_4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_4 = uvm_reg_field::type_id::create("dbg_rdata_store_4",,get_full_name());
        this.dbg_rdata_store_4.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_rdata_store_4_reg)
endclass:ral_reg_mc_wrapper_top_dbg_rdata_store_4_reg

class ral_reg_mc_wrapper_top_dbg_rdata_store_5_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_5;

    function new(string name = "mc_wrapper_top_dbg_rdata_store_5_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_5 = uvm_reg_field::type_id::create("dbg_rdata_store_5",,get_full_name());
        this.dbg_rdata_store_5.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_rdata_store_5_reg)
endclass:ral_reg_mc_wrapper_top_dbg_rdata_store_5_reg

class ral_reg_mc_wrapper_top_dbg_rdata_store_6_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_6;

    function new(string name = "mc_wrapper_top_dbg_rdata_store_6_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_6 = uvm_reg_field::type_id::create("dbg_rdata_store_6",,get_full_name());
        this.dbg_rdata_store_6.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_rdata_store_6_reg)
endclass:ral_reg_mc_wrapper_top_dbg_rdata_store_6_reg

class ral_reg_mc_wrapper_top_dbg_rdata_store_7_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_7;

    function new(string name = "mc_wrapper_top_dbg_rdata_store_7_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_7 = uvm_reg_field::type_id::create("dbg_rdata_store_7",,get_full_name());
        this.dbg_rdata_store_7.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_rdata_store_7_reg)
endclass:ral_reg_mc_wrapper_top_dbg_rdata_store_7_reg

class ral_reg_mc_wrapper_top_dbg_rdata_store_8_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_8;

    function new(string name = "mc_wrapper_top_dbg_rdata_store_8_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_8 = uvm_reg_field::type_id::create("dbg_rdata_store_8",,get_full_name());
        this.dbg_rdata_store_8.configure(this,10,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_dbg_rdata_store_8_reg)
endclass:ral_reg_mc_wrapper_top_dbg_rdata_store_8_reg

class ral_reg_mc_wrapper_top_bist_pattern_reg0_reg extends uvm_reg;
    rand uvm_reg_field bist_pattern_reg0;

    function new(string name = "mc_wrapper_top_bist_pattern_reg0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_pattern_reg0 = uvm_reg_field::type_id::create("bist_pattern_reg0",,get_full_name());
        this.bist_pattern_reg0.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bist_pattern_reg0_reg)
endclass:ral_reg_mc_wrapper_top_bist_pattern_reg0_reg

class ral_reg_mc_wrapper_top_bist_pattern_reg1_reg extends uvm_reg;
    rand uvm_reg_field bist_pattern_reg1;

    function new(string name = "mc_wrapper_top_bist_pattern_reg1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_pattern_reg1 = uvm_reg_field::type_id::create("bist_pattern_reg1",,get_full_name());
        this.bist_pattern_reg1.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bist_pattern_reg1_reg)
endclass:ral_reg_mc_wrapper_top_bist_pattern_reg1_reg

class ral_reg_mc_wrapper_top_bist_pattern_reg2_reg extends uvm_reg;
    rand uvm_reg_field bist_pattern_reg2;

    function new(string name = "mc_wrapper_top_bist_pattern_reg2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_pattern_reg2 = uvm_reg_field::type_id::create("bist_pattern_reg2",,get_full_name());
        this.bist_pattern_reg2.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bist_pattern_reg2_reg)
endclass:ral_reg_mc_wrapper_top_bist_pattern_reg2_reg

class ral_reg_mc_wrapper_top_bist_pattern_reg3_reg extends uvm_reg;
    rand uvm_reg_field bist_pattern_reg3;

    function new(string name = "mc_wrapper_top_bist_pattern_reg3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_pattern_reg3 = uvm_reg_field::type_id::create("bist_pattern_reg3",,get_full_name());
        this.bist_pattern_reg3.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bist_pattern_reg3_reg)
endclass:ral_reg_mc_wrapper_top_bist_pattern_reg3_reg

class ral_reg_mc_wrapper_top_csl_bist_pattern_sel0_reg extends uvm_reg;
    rand uvm_reg_field csl_bist_pattern_sel0;

    function new(string name = "mc_wrapper_top_csl_bist_pattern_sel0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.csl_bist_pattern_sel0 = uvm_reg_field::type_id::create("csl_bist_pattern_sel0",,get_full_name());
        this.csl_bist_pattern_sel0.configure(this,32,0,"RW",0,32'hFFFFFFFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_csl_bist_pattern_sel0_reg)
endclass:ral_reg_mc_wrapper_top_csl_bist_pattern_sel0_reg

class ral_reg_mc_wrapper_top_csl_bist_pattern_sel1_reg extends uvm_reg;
    rand uvm_reg_field csl_bist_pattern_sel1;

    function new(string name = "mc_wrapper_top_csl_bist_pattern_sel1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.csl_bist_pattern_sel1 = uvm_reg_field::type_id::create("csl_bist_pattern_sel1",,get_full_name());
        this.csl_bist_pattern_sel1.configure(this,32,0,"RW",0,32'hFFFFFFFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_csl_bist_pattern_sel1_reg)
endclass:ral_reg_mc_wrapper_top_csl_bist_pattern_sel1_reg

class ral_reg_mc_wrapper_top_csl_bist_pattern_sel2_reg extends uvm_reg;
    rand uvm_reg_field csl_bist_pattern_sel2;

    function new(string name = "mc_wrapper_top_csl_bist_pattern_sel2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.csl_bist_pattern_sel2 = uvm_reg_field::type_id::create("csl_bist_pattern_sel2",,get_full_name());
        this.csl_bist_pattern_sel2.configure(this,4,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_csl_bist_pattern_sel2_reg)
endclass:ral_reg_mc_wrapper_top_csl_bist_pattern_sel2_reg

class ral_reg_mc_wrapper_top_wl_bist_pattern_sel0_reg extends uvm_reg;
    rand uvm_reg_field wl_bist_pattern_sel0;

    function new(string name = "mc_wrapper_top_wl_bist_pattern_sel0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.wl_bist_pattern_sel0 = uvm_reg_field::type_id::create("wl_bist_pattern_sel0",,get_full_name());
        this.wl_bist_pattern_sel0.configure(this,32,0,"RW",0,32'hFFFFFFFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_wl_bist_pattern_sel0_reg)
endclass:ral_reg_mc_wrapper_top_wl_bist_pattern_sel0_reg

class ral_reg_mc_wrapper_top_wl_bist_pattern_sel1_reg extends uvm_reg;
    rand uvm_reg_field wl_bist_pattern_sel1;

    function new(string name = "mc_wrapper_top_wl_bist_pattern_sel1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.wl_bist_pattern_sel1 = uvm_reg_field::type_id::create("wl_bist_pattern_sel1",,get_full_name());
        this.wl_bist_pattern_sel1.configure(this,32,0,"RW",0,32'hFFFFFFFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_wl_bist_pattern_sel1_reg)
endclass:ral_reg_mc_wrapper_top_wl_bist_pattern_sel1_reg

class ral_reg_mc_wrapper_top_wl_bist_pattern_sel2_reg extends uvm_reg;
    rand uvm_reg_field wl_bist_pattern_sel2;

    function new(string name = "mc_wrapper_top_wl_bist_pattern_sel2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.wl_bist_pattern_sel2 = uvm_reg_field::type_id::create("wl_bist_pattern_sel2",,get_full_name());
        this.wl_bist_pattern_sel2.configure(this,4,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_wl_bist_pattern_sel2_reg)
endclass:ral_reg_mc_wrapper_top_wl_bist_pattern_sel2_reg

class ral_reg_mc_wrapper_top_mc_ecc_ctrl_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_en;
    rand uvm_reg_field mc_ecc_ce_th;
    rand uvm_reg_field mc_ecc_ce_int_clr;
    rand uvm_reg_field mc_ecc_ce_int_mask;
    rand uvm_reg_field mc_ecc_uce_int_clr;
    rand uvm_reg_field mc_ecc_uce_int_mask;

    function new(string name = "mc_wrapper_top_mc_ecc_ctrl_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_en = uvm_reg_field::type_id::create("mc_ecc_en",,get_full_name());
        this.mc_ecc_en.configure(this,1,0,"RW",0,32'h0,1,0,0);
        this.mc_ecc_ce_th = uvm_reg_field::type_id::create("mc_ecc_ce_th",,get_full_name());
        this.mc_ecc_ce_th.configure(this,5,4,"RW",0,32'h10,1,0,0);
        this.mc_ecc_ce_int_clr = uvm_reg_field::type_id::create("mc_ecc_ce_int_clr",,get_full_name());
        this.mc_ecc_ce_int_clr.configure(this,1,16,"W1C",0,32'h0,1,0,0);
        this.mc_ecc_ce_int_mask = uvm_reg_field::type_id::create("mc_ecc_ce_int_mask",,get_full_name());
        this.mc_ecc_ce_int_mask.configure(this,1,20,"RW",0,32'h0,1,0,0);
        this.mc_ecc_uce_int_clr = uvm_reg_field::type_id::create("mc_ecc_uce_int_clr",,get_full_name());
        this.mc_ecc_uce_int_clr.configure(this,1,24,"W1C",0,32'h0,1,0,0);
        this.mc_ecc_uce_int_mask = uvm_reg_field::type_id::create("mc_ecc_uce_int_mask",,get_full_name());
        this.mc_ecc_uce_int_mask.configure(this,1,28,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ctrl_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ctrl_reg

class ral_reg_mc_wrapper_top_mc_ecc_int_status_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_int_status;
    rand uvm_reg_field mc_ecc_uce_int_status;
    rand uvm_reg_field mc_ecc_ce_cnt;

    function new(string name = "mc_wrapper_top_mc_ecc_int_status_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_int_status = uvm_reg_field::type_id::create("mc_ecc_ce_int_status",,get_full_name());
        this.mc_ecc_ce_int_status.configure(this,1,0,"RO",0,32'h0,1,0,0);
        this.mc_ecc_uce_int_status = uvm_reg_field::type_id::create("mc_ecc_uce_int_status",,get_full_name());
        this.mc_ecc_uce_int_status.configure(this,1,4,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_cnt = uvm_reg_field::type_id::create("mc_ecc_ce_cnt",,get_full_name());
        this.mc_ecc_ce_cnt.configure(this,5,8,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_int_status_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_int_status_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr0_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr0;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr0 = uvm_reg_field::type_id::create("mc_ecc_ce_addr0",,get_full_name());
        this.mc_ecc_ce_addr0.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr0_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr0_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr1_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr1;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr1 = uvm_reg_field::type_id::create("mc_ecc_ce_addr1",,get_full_name());
        this.mc_ecc_ce_addr1.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr1_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr1_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr2_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr2;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr2 = uvm_reg_field::type_id::create("mc_ecc_ce_addr2",,get_full_name());
        this.mc_ecc_ce_addr2.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr2_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr2_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr3_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr3;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr3 = uvm_reg_field::type_id::create("mc_ecc_ce_addr3",,get_full_name());
        this.mc_ecc_ce_addr3.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr3_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr3_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr4_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr4;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr4 = uvm_reg_field::type_id::create("mc_ecc_ce_addr4",,get_full_name());
        this.mc_ecc_ce_addr4.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr4_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr4_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr5_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr5;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr5_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr5 = uvm_reg_field::type_id::create("mc_ecc_ce_addr5",,get_full_name());
        this.mc_ecc_ce_addr5.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr5_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr5_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr6_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr6;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr6_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr6 = uvm_reg_field::type_id::create("mc_ecc_ce_addr6",,get_full_name());
        this.mc_ecc_ce_addr6.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr6_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr6_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr7_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr7;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr7_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr7 = uvm_reg_field::type_id::create("mc_ecc_ce_addr7",,get_full_name());
        this.mc_ecc_ce_addr7.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr7_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr7_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr8_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr8;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr8_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr8 = uvm_reg_field::type_id::create("mc_ecc_ce_addr8",,get_full_name());
        this.mc_ecc_ce_addr8.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr8_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr8_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr9_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr9;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr9_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr9 = uvm_reg_field::type_id::create("mc_ecc_ce_addr9",,get_full_name());
        this.mc_ecc_ce_addr9.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr9_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr9_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr10_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr10;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr10_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr10 = uvm_reg_field::type_id::create("mc_ecc_ce_addr10",,get_full_name());
        this.mc_ecc_ce_addr10.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr10_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr10_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr11_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr11;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr11_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr11 = uvm_reg_field::type_id::create("mc_ecc_ce_addr11",,get_full_name());
        this.mc_ecc_ce_addr11.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr11_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr11_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr12_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr12;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr12_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr12 = uvm_reg_field::type_id::create("mc_ecc_ce_addr12",,get_full_name());
        this.mc_ecc_ce_addr12.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr12_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr12_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr13_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr13;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr13_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr13 = uvm_reg_field::type_id::create("mc_ecc_ce_addr13",,get_full_name());
        this.mc_ecc_ce_addr13.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr13_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr13_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr14_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr14;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr14_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr14 = uvm_reg_field::type_id::create("mc_ecc_ce_addr14",,get_full_name());
        this.mc_ecc_ce_addr14.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr14_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr14_reg

class ral_reg_mc_wrapper_top_mc_ecc_ce_addr15_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr15;

    function new(string name = "mc_wrapper_top_mc_ecc_ce_addr15_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr15 = uvm_reg_field::type_id::create("mc_ecc_ce_addr15",,get_full_name());
        this.mc_ecc_ce_addr15.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_ce_addr15_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_ce_addr15_reg

class ral_reg_mc_wrapper_top_mc_ecc_uce_addr0_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_uce_addr0;

    function new(string name = "mc_wrapper_top_mc_ecc_uce_addr0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_uce_addr0 = uvm_reg_field::type_id::create("mc_ecc_uce_addr0",,get_full_name());
        this.mc_ecc_uce_addr0.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_uce_addr0_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_uce_addr0_reg

class ral_reg_mc_wrapper_top_mc_ecc_uce_addr1_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_uce_addr1;

    function new(string name = "mc_wrapper_top_mc_ecc_uce_addr1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_uce_addr1 = uvm_reg_field::type_id::create("mc_ecc_uce_addr1",,get_full_name());
        this.mc_ecc_uce_addr1.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_uce_addr1_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_uce_addr1_reg

class ral_reg_mc_wrapper_top_mc_ecc_uce_addr2_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_uce_addr2;

    function new(string name = "mc_wrapper_top_mc_ecc_uce_addr2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_uce_addr2 = uvm_reg_field::type_id::create("mc_ecc_uce_addr2",,get_full_name());
        this.mc_ecc_uce_addr2.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_uce_addr2_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_uce_addr2_reg

class ral_reg_mc_wrapper_top_mc_ecc_uce_addr3_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_uce_addr3;

    function new(string name = "mc_wrapper_top_mc_ecc_uce_addr3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_uce_addr3 = uvm_reg_field::type_id::create("mc_ecc_uce_addr3",,get_full_name());
        this.mc_ecc_uce_addr3.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_ecc_uce_addr3_reg)
endclass:ral_reg_mc_wrapper_top_mc_ecc_uce_addr3_reg

class ral_reg_mc_wrapper_top_bist_scan_ctrl_reg extends uvm_reg;
    rand uvm_reg_field bist_scan_start_bank;
    rand uvm_reg_field bist_scan_end_bank;

    function new(string name = "mc_wrapper_top_bist_scan_ctrl_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_scan_start_bank = uvm_reg_field::type_id::create("bist_scan_start_bank",,get_full_name());
        this.bist_scan_start_bank.configure(this,1,0,"RW",0,32'h0,1,0,0);
        this.bist_scan_end_bank = uvm_reg_field::type_id::create("bist_scan_end_bank",,get_full_name());
        this.bist_scan_end_bank.configure(this,1,4,"RW",0,32'h1,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bist_scan_ctrl_reg)
endclass:ral_reg_mc_wrapper_top_bist_scan_ctrl_reg

class ral_reg_mc_wrapper_top_axi2frame_dbg0_reg extends uvm_reg;
    rand uvm_reg_field a2f_dbg_ar_cnt;

    function new(string name = "mc_wrapper_top_axi2frame_dbg0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.a2f_dbg_ar_cnt = uvm_reg_field::type_id::create("a2f_dbg_ar_cnt",,get_full_name());
        this.a2f_dbg_ar_cnt.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_axi2frame_dbg0_reg)
endclass:ral_reg_mc_wrapper_top_axi2frame_dbg0_reg

class ral_reg_mc_wrapper_top_axi2frame_dbg1_reg extends uvm_reg;
    rand uvm_reg_field a2f_dbg_r_cnt;

    function new(string name = "mc_wrapper_top_axi2frame_dbg1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.a2f_dbg_r_cnt = uvm_reg_field::type_id::create("a2f_dbg_r_cnt",,get_full_name());
        this.a2f_dbg_r_cnt.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_axi2frame_dbg1_reg)
endclass:ral_reg_mc_wrapper_top_axi2frame_dbg1_reg

class ral_reg_mc_wrapper_top_axi2frame_dbg2_reg extends uvm_reg;
    rand uvm_reg_field a2f_dbg_aw_cnt;

    function new(string name = "mc_wrapper_top_axi2frame_dbg2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.a2f_dbg_aw_cnt = uvm_reg_field::type_id::create("a2f_dbg_aw_cnt",,get_full_name());
        this.a2f_dbg_aw_cnt.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_axi2frame_dbg2_reg)
endclass:ral_reg_mc_wrapper_top_axi2frame_dbg2_reg

class ral_reg_mc_wrapper_top_axi2frame_dbg3_reg extends uvm_reg;
    rand uvm_reg_field a2f_dbg_w_cnt;

    function new(string name = "mc_wrapper_top_axi2frame_dbg3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.a2f_dbg_w_cnt = uvm_reg_field::type_id::create("a2f_dbg_w_cnt",,get_full_name());
        this.a2f_dbg_w_cnt.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_axi2frame_dbg3_reg)
endclass:ral_reg_mc_wrapper_top_axi2frame_dbg3_reg

class ral_reg_mc_wrapper_top_axi2frame_dbg4_reg extends uvm_reg;
    rand uvm_reg_field a2f_dbg_b_cnt;

    function new(string name = "mc_wrapper_top_axi2frame_dbg4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.a2f_dbg_b_cnt = uvm_reg_field::type_id::create("a2f_dbg_b_cnt",,get_full_name());
        this.a2f_dbg_b_cnt.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_axi2frame_dbg4_reg)
endclass:ral_reg_mc_wrapper_top_axi2frame_dbg4_reg

class ral_reg_mc_wrapper_top_axi2frame_dbg5_reg extends uvm_reg;
    rand uvm_reg_field a2f_dbg_axi_len_err_addr;

    function new(string name = "mc_wrapper_top_axi2frame_dbg5_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.a2f_dbg_axi_len_err_addr = uvm_reg_field::type_id::create("a2f_dbg_axi_len_err_addr",,get_full_name());
        this.a2f_dbg_axi_len_err_addr.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_axi2frame_dbg5_reg)
endclass:ral_reg_mc_wrapper_top_axi2frame_dbg5_reg

class ral_reg_mc_wrapper_top_axi2frame_dbg6_reg extends uvm_reg;
    rand uvm_reg_field a2f_dbg_axi_len_err;

    function new(string name = "mc_wrapper_top_axi2frame_dbg6_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.a2f_dbg_axi_len_err = uvm_reg_field::type_id::create("a2f_dbg_axi_len_err",,get_full_name());
        this.a2f_dbg_axi_len_err.configure(this,1,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_axi2frame_dbg6_reg)
endclass:ral_reg_mc_wrapper_top_axi2frame_dbg6_reg

class ral_reg_mc_wrapper_top_axi2frame_dbg7_reg extends uvm_reg;
    rand uvm_reg_field a2f_dbg_reserve_in;

    function new(string name = "mc_wrapper_top_axi2frame_dbg7_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.a2f_dbg_reserve_in = uvm_reg_field::type_id::create("a2f_dbg_reserve_in",,get_full_name());
        this.a2f_dbg_reserve_in.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_axi2frame_dbg7_reg)
endclass:ral_reg_mc_wrapper_top_axi2frame_dbg7_reg

class ral_reg_mc_wrapper_top_axi2frame_dbg8_reg extends uvm_reg;
    rand uvm_reg_field a2f_dbg_reserve_out;

    function new(string name = "mc_wrapper_top_axi2frame_dbg8_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.a2f_dbg_reserve_out = uvm_reg_field::type_id::create("a2f_dbg_reserve_out",,get_full_name());
        this.a2f_dbg_reserve_out.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_axi2frame_dbg8_reg)
endclass:ral_reg_mc_wrapper_top_axi2frame_dbg8_reg

class ral_reg_mc_wrapper_top_mc_page_status_reg extends uvm_reg;
    rand uvm_reg_field mc_page_status;

    function new(string name = "mc_wrapper_top_mc_page_status_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_page_status = uvm_reg_field::type_id::create("mc_page_status",,get_full_name());
        this.mc_page_status.configure(this,1,0,"RO",0,32'h1,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_page_status_reg)
endclass:ral_reg_mc_wrapper_top_mc_page_status_reg

class ral_reg_mc_wrapper_top_hang_timeout_status_reg extends uvm_reg;
    rand uvm_reg_field hang_timeout_status;

    function new(string name = "mc_wrapper_top_hang_timeout_status_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hang_timeout_status = uvm_reg_field::type_id::create("hang_timeout_status",,get_full_name());
        this.hang_timeout_status.configure(this,1,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_hang_timeout_status_reg)
endclass:ral_reg_mc_wrapper_top_hang_timeout_status_reg

class ral_reg_mc_wrapper_top_hang_timeout_mask_reg extends uvm_reg;
    rand uvm_reg_field hang_timeout_mask;

    function new(string name = "mc_wrapper_top_hang_timeout_mask_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hang_timeout_mask = uvm_reg_field::type_id::create("hang_timeout_mask",,get_full_name());
        this.hang_timeout_mask.configure(this,1,0,"RW",0,32'h1,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_hang_timeout_mask_reg)
endclass:ral_reg_mc_wrapper_top_hang_timeout_mask_reg

class ral_reg_mc_wrapper_top_hang_timeout_clr_reg extends uvm_reg;
    rand uvm_reg_field hang_timeout_clr;

    function new(string name = "mc_wrapper_top_hang_timeout_clr_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hang_timeout_clr = uvm_reg_field::type_id::create("hang_timeout_clr",,get_full_name());
        this.hang_timeout_clr.configure(this,1,0,"W1C",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_hang_timeout_clr_reg)
endclass:ral_reg_mc_wrapper_top_hang_timeout_clr_reg

class ral_reg_mc_wrapper_top_hang_timeout_en_reg extends uvm_reg;
    rand uvm_reg_field hang_timeout_en;

    function new(string name = "mc_wrapper_top_hang_timeout_en_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hang_timeout_en = uvm_reg_field::type_id::create("hang_timeout_en",,get_full_name());
        this.hang_timeout_en.configure(this,1,0,"RW",0,32'h1,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_hang_timeout_en_reg)
endclass:ral_reg_mc_wrapper_top_hang_timeout_en_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num0_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num0;
    rand uvm_reg_field mc_bank1_vmc_wl_num1;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num0 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num0",,get_full_name());
        this.mc_bank1_vmc_wl_num0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num1 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num1",,get_full_name());
        this.mc_bank1_vmc_wl_num1.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num0_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num0_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num1_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num2;
    rand uvm_reg_field mc_bank1_vmc_wl_num3;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num2 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num2",,get_full_name());
        this.mc_bank1_vmc_wl_num2.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num3 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num3",,get_full_name());
        this.mc_bank1_vmc_wl_num3.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num1_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num1_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num2_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num4;
    rand uvm_reg_field mc_bank1_vmc_wl_num5;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num4 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num4",,get_full_name());
        this.mc_bank1_vmc_wl_num4.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num5 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num5",,get_full_name());
        this.mc_bank1_vmc_wl_num5.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num2_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num2_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num3_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num6;
    rand uvm_reg_field mc_bank1_vmc_wl_num7;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num6 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num6",,get_full_name());
        this.mc_bank1_vmc_wl_num6.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num7 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num7",,get_full_name());
        this.mc_bank1_vmc_wl_num7.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num3_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num3_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num4_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num8;
    rand uvm_reg_field mc_bank1_vmc_wl_num9;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num8 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num8",,get_full_name());
        this.mc_bank1_vmc_wl_num8.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num9 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num9",,get_full_name());
        this.mc_bank1_vmc_wl_num9.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num4_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num4_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num5_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num10;
    rand uvm_reg_field mc_bank1_vmc_wl_num11;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num5_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num10 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num10",,get_full_name());
        this.mc_bank1_vmc_wl_num10.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num11 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num11",,get_full_name());
        this.mc_bank1_vmc_wl_num11.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num5_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num5_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num6_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num12;
    rand uvm_reg_field mc_bank1_vmc_wl_num13;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num6_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num12 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num12",,get_full_name());
        this.mc_bank1_vmc_wl_num12.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num13 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num13",,get_full_name());
        this.mc_bank1_vmc_wl_num13.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num6_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num6_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num7_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num14;
    rand uvm_reg_field mc_bank1_vmc_wl_num15;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num7_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num14 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num14",,get_full_name());
        this.mc_bank1_vmc_wl_num14.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num15 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num15",,get_full_name());
        this.mc_bank1_vmc_wl_num15.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num7_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num7_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num8_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num16;
    rand uvm_reg_field mc_bank1_vmc_wl_num17;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num8_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num16 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num16",,get_full_name());
        this.mc_bank1_vmc_wl_num16.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num17 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num17",,get_full_name());
        this.mc_bank1_vmc_wl_num17.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num8_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num8_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num9_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num18;
    rand uvm_reg_field mc_bank1_vmc_wl_num19;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num9_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num18 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num18",,get_full_name());
        this.mc_bank1_vmc_wl_num18.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num19 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num19",,get_full_name());
        this.mc_bank1_vmc_wl_num19.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num9_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num9_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num10_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num20;
    rand uvm_reg_field mc_bank1_vmc_wl_num21;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num10_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num20 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num20",,get_full_name());
        this.mc_bank1_vmc_wl_num20.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num21 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num21",,get_full_name());
        this.mc_bank1_vmc_wl_num21.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num10_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num10_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num11_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num22;
    rand uvm_reg_field mc_bank1_vmc_wl_num23;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num11_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num22 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num22",,get_full_name());
        this.mc_bank1_vmc_wl_num22.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num23 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num23",,get_full_name());
        this.mc_bank1_vmc_wl_num23.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num11_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num11_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num12_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num24;
    rand uvm_reg_field mc_bank1_vmc_wl_num25;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num12_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num24 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num24",,get_full_name());
        this.mc_bank1_vmc_wl_num24.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num25 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num25",,get_full_name());
        this.mc_bank1_vmc_wl_num25.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num12_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num12_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num13_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num26;
    rand uvm_reg_field mc_bank1_vmc_wl_num27;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num13_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num26 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num26",,get_full_name());
        this.mc_bank1_vmc_wl_num26.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num27 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num27",,get_full_name());
        this.mc_bank1_vmc_wl_num27.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num13_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num13_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num14_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num28;
    rand uvm_reg_field mc_bank1_vmc_wl_num29;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num14_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num28 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num28",,get_full_name());
        this.mc_bank1_vmc_wl_num28.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num29 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num29",,get_full_name());
        this.mc_bank1_vmc_wl_num29.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num14_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num14_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num15_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num30;
    rand uvm_reg_field mc_bank1_vmc_wl_num31;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num15_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num30 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num30",,get_full_name());
        this.mc_bank1_vmc_wl_num30.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num31 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num31",,get_full_name());
        this.mc_bank1_vmc_wl_num31.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num15_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num15_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num16_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num32;
    rand uvm_reg_field mc_bank1_vmc_wl_num33;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num16_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num32 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num32",,get_full_name());
        this.mc_bank1_vmc_wl_num32.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num33 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num33",,get_full_name());
        this.mc_bank1_vmc_wl_num33.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num16_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num16_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num17_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num34;
    rand uvm_reg_field mc_bank1_vmc_wl_num35;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num17_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num34 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num34",,get_full_name());
        this.mc_bank1_vmc_wl_num34.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num35 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num35",,get_full_name());
        this.mc_bank1_vmc_wl_num35.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num17_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num17_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num18_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num36;
    rand uvm_reg_field mc_bank1_vmc_wl_num37;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num18_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num36 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num36",,get_full_name());
        this.mc_bank1_vmc_wl_num36.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num37 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num37",,get_full_name());
        this.mc_bank1_vmc_wl_num37.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num18_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num18_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num19_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num38;
    rand uvm_reg_field mc_bank1_vmc_wl_num39;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num19_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num38 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num38",,get_full_name());
        this.mc_bank1_vmc_wl_num38.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num39 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num39",,get_full_name());
        this.mc_bank1_vmc_wl_num39.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num19_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num19_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num20_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num40;
    rand uvm_reg_field mc_bank1_vmc_wl_num41;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num20_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num40 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num40",,get_full_name());
        this.mc_bank1_vmc_wl_num40.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num41 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num41",,get_full_name());
        this.mc_bank1_vmc_wl_num41.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num20_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num20_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num21_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num42;
    rand uvm_reg_field mc_bank1_vmc_wl_num43;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num21_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num42 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num42",,get_full_name());
        this.mc_bank1_vmc_wl_num42.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num43 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num43",,get_full_name());
        this.mc_bank1_vmc_wl_num43.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num21_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num21_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num22_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num44;
    rand uvm_reg_field mc_bank1_vmc_wl_num45;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num22_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num44 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num44",,get_full_name());
        this.mc_bank1_vmc_wl_num44.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num45 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num45",,get_full_name());
        this.mc_bank1_vmc_wl_num45.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num22_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num22_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num23_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num46;
    rand uvm_reg_field mc_bank1_vmc_wl_num47;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num23_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num46 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num46",,get_full_name());
        this.mc_bank1_vmc_wl_num46.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num47 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num47",,get_full_name());
        this.mc_bank1_vmc_wl_num47.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num23_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num23_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num24_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num48;
    rand uvm_reg_field mc_bank1_vmc_wl_num49;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num24_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num48 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num48",,get_full_name());
        this.mc_bank1_vmc_wl_num48.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num49 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num49",,get_full_name());
        this.mc_bank1_vmc_wl_num49.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num24_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num24_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num25_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num50;
    rand uvm_reg_field mc_bank1_vmc_wl_num51;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num25_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num50 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num50",,get_full_name());
        this.mc_bank1_vmc_wl_num50.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num51 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num51",,get_full_name());
        this.mc_bank1_vmc_wl_num51.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num25_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num25_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num26_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num52;
    rand uvm_reg_field mc_bank1_vmc_wl_num53;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num26_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num52 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num52",,get_full_name());
        this.mc_bank1_vmc_wl_num52.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num53 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num53",,get_full_name());
        this.mc_bank1_vmc_wl_num53.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num26_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num26_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num27_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num54;
    rand uvm_reg_field mc_bank1_vmc_wl_num55;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num27_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num54 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num54",,get_full_name());
        this.mc_bank1_vmc_wl_num54.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num55 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num55",,get_full_name());
        this.mc_bank1_vmc_wl_num55.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num27_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num27_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num28_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num56;
    rand uvm_reg_field mc_bank1_vmc_wl_num57;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num28_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num56 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num56",,get_full_name());
        this.mc_bank1_vmc_wl_num56.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num57 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num57",,get_full_name());
        this.mc_bank1_vmc_wl_num57.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num28_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num28_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num29_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num58;
    rand uvm_reg_field mc_bank1_vmc_wl_num59;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num29_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num58 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num58",,get_full_name());
        this.mc_bank1_vmc_wl_num58.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num59 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num59",,get_full_name());
        this.mc_bank1_vmc_wl_num59.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num29_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num29_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num30_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num60;
    rand uvm_reg_field mc_bank1_vmc_wl_num61;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num30_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num60 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num60",,get_full_name());
        this.mc_bank1_vmc_wl_num60.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num61 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num61",,get_full_name());
        this.mc_bank1_vmc_wl_num61.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num30_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num30_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num31_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num62;
    rand uvm_reg_field mc_bank1_vmc_wl_num63;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_wl_num31_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_wl_num62 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num62",,get_full_name());
        this.mc_bank1_vmc_wl_num62.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_bank1_vmc_wl_num63 = uvm_reg_field::type_id::create("mc_bank1_vmc_wl_num63",,get_full_name());
        this.mc_bank1_vmc_wl_num63.configure(this,13,16,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num31_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num31_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num0_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part0;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part0;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part1;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part1;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_bl_num0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_bl_num0_part0 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num0_part0",,get_full_name());
        this.mc_bank1_vmc_bl_num0_part0.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num1_part0 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num1_part0",,get_full_name());
        this.mc_bank1_vmc_bl_num1_part0.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num0_part1 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num0_part1",,get_full_name());
        this.mc_bank1_vmc_bl_num0_part1.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num1_part1 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num1_part1",,get_full_name());
        this.mc_bank1_vmc_bl_num1_part1.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num0_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num0_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num1_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part2;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part2;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part3;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part3;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_bl_num1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_bl_num0_part2 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num0_part2",,get_full_name());
        this.mc_bank1_vmc_bl_num0_part2.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num1_part2 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num1_part2",,get_full_name());
        this.mc_bank1_vmc_bl_num1_part2.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num0_part3 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num0_part3",,get_full_name());
        this.mc_bank1_vmc_bl_num0_part3.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num1_part3 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num1_part3",,get_full_name());
        this.mc_bank1_vmc_bl_num1_part3.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num1_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num1_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num2_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part4;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part4;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part5;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part5;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_bl_num2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_bl_num0_part4 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num0_part4",,get_full_name());
        this.mc_bank1_vmc_bl_num0_part4.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num1_part4 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num1_part4",,get_full_name());
        this.mc_bank1_vmc_bl_num1_part4.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num0_part5 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num0_part5",,get_full_name());
        this.mc_bank1_vmc_bl_num0_part5.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num1_part5 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num1_part5",,get_full_name());
        this.mc_bank1_vmc_bl_num1_part5.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num2_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num2_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num3_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part6;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part6;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part7;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part7;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_bl_num3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_bl_num0_part6 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num0_part6",,get_full_name());
        this.mc_bank1_vmc_bl_num0_part6.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num1_part6 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num1_part6",,get_full_name());
        this.mc_bank1_vmc_bl_num1_part6.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num0_part7 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num0_part7",,get_full_name());
        this.mc_bank1_vmc_bl_num0_part7.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num1_part7 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num1_part7",,get_full_name());
        this.mc_bank1_vmc_bl_num1_part7.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num3_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num3_reg

class ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num4_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part8;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part8;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part9;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part9;

    function new(string name = "mc_wrapper_top_mc_bank1_vmc_bl_num4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_vmc_bl_num0_part8 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num0_part8",,get_full_name());
        this.mc_bank1_vmc_bl_num0_part8.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num1_part8 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num1_part8",,get_full_name());
        this.mc_bank1_vmc_bl_num1_part8.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num0_part9 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num0_part9",,get_full_name());
        this.mc_bank1_vmc_bl_num0_part9.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_bank1_vmc_bl_num1_part9 = uvm_reg_field::type_id::create("mc_bank1_vmc_bl_num1_part9",,get_full_name());
        this.mc_bank1_vmc_bl_num1_part9.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num4_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num4_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num0_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl0;
    rand uvm_reg_field bank1_err_wl1;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl0 = uvm_reg_field::type_id::create("bank1_err_wl0",,get_full_name());
        this.bank1_err_wl0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl1 = uvm_reg_field::type_id::create("bank1_err_wl1",,get_full_name());
        this.bank1_err_wl1.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num0_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num0_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num1_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl2;
    rand uvm_reg_field bank1_err_wl3;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl2 = uvm_reg_field::type_id::create("bank1_err_wl2",,get_full_name());
        this.bank1_err_wl2.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl3 = uvm_reg_field::type_id::create("bank1_err_wl3",,get_full_name());
        this.bank1_err_wl3.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num1_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num1_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num2_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl4;
    rand uvm_reg_field bank1_err_wl5;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl4 = uvm_reg_field::type_id::create("bank1_err_wl4",,get_full_name());
        this.bank1_err_wl4.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl5 = uvm_reg_field::type_id::create("bank1_err_wl5",,get_full_name());
        this.bank1_err_wl5.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num2_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num2_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num3_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl6;
    rand uvm_reg_field bank1_err_wl7;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl6 = uvm_reg_field::type_id::create("bank1_err_wl6",,get_full_name());
        this.bank1_err_wl6.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl7 = uvm_reg_field::type_id::create("bank1_err_wl7",,get_full_name());
        this.bank1_err_wl7.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num3_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num3_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num4_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl8;
    rand uvm_reg_field bank1_err_wl9;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl8 = uvm_reg_field::type_id::create("bank1_err_wl8",,get_full_name());
        this.bank1_err_wl8.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl9 = uvm_reg_field::type_id::create("bank1_err_wl9",,get_full_name());
        this.bank1_err_wl9.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num4_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num4_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num5_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl10;
    rand uvm_reg_field bank1_err_wl11;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num5_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl10 = uvm_reg_field::type_id::create("bank1_err_wl10",,get_full_name());
        this.bank1_err_wl10.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl11 = uvm_reg_field::type_id::create("bank1_err_wl11",,get_full_name());
        this.bank1_err_wl11.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num5_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num5_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num6_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl12;
    rand uvm_reg_field bank1_err_wl13;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num6_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl12 = uvm_reg_field::type_id::create("bank1_err_wl12",,get_full_name());
        this.bank1_err_wl12.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl13 = uvm_reg_field::type_id::create("bank1_err_wl13",,get_full_name());
        this.bank1_err_wl13.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num6_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num6_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num7_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl14;
    rand uvm_reg_field bank1_err_wl15;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num7_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl14 = uvm_reg_field::type_id::create("bank1_err_wl14",,get_full_name());
        this.bank1_err_wl14.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl15 = uvm_reg_field::type_id::create("bank1_err_wl15",,get_full_name());
        this.bank1_err_wl15.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num7_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num7_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num8_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl16;
    rand uvm_reg_field bank1_err_wl17;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num8_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl16 = uvm_reg_field::type_id::create("bank1_err_wl16",,get_full_name());
        this.bank1_err_wl16.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl17 = uvm_reg_field::type_id::create("bank1_err_wl17",,get_full_name());
        this.bank1_err_wl17.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num8_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num8_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num9_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl18;
    rand uvm_reg_field bank1_err_wl19;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num9_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl18 = uvm_reg_field::type_id::create("bank1_err_wl18",,get_full_name());
        this.bank1_err_wl18.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl19 = uvm_reg_field::type_id::create("bank1_err_wl19",,get_full_name());
        this.bank1_err_wl19.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num9_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num9_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num10_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl20;
    rand uvm_reg_field bank1_err_wl21;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num10_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl20 = uvm_reg_field::type_id::create("bank1_err_wl20",,get_full_name());
        this.bank1_err_wl20.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl21 = uvm_reg_field::type_id::create("bank1_err_wl21",,get_full_name());
        this.bank1_err_wl21.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num10_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num10_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num11_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl22;
    rand uvm_reg_field bank1_err_wl23;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num11_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl22 = uvm_reg_field::type_id::create("bank1_err_wl22",,get_full_name());
        this.bank1_err_wl22.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl23 = uvm_reg_field::type_id::create("bank1_err_wl23",,get_full_name());
        this.bank1_err_wl23.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num11_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num11_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num12_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl24;
    rand uvm_reg_field bank1_err_wl25;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num12_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl24 = uvm_reg_field::type_id::create("bank1_err_wl24",,get_full_name());
        this.bank1_err_wl24.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl25 = uvm_reg_field::type_id::create("bank1_err_wl25",,get_full_name());
        this.bank1_err_wl25.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num12_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num12_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num13_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl26;
    rand uvm_reg_field bank1_err_wl27;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num13_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl26 = uvm_reg_field::type_id::create("bank1_err_wl26",,get_full_name());
        this.bank1_err_wl26.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl27 = uvm_reg_field::type_id::create("bank1_err_wl27",,get_full_name());
        this.bank1_err_wl27.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num13_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num13_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num14_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl28;
    rand uvm_reg_field bank1_err_wl29;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num14_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl28 = uvm_reg_field::type_id::create("bank1_err_wl28",,get_full_name());
        this.bank1_err_wl28.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl29 = uvm_reg_field::type_id::create("bank1_err_wl29",,get_full_name());
        this.bank1_err_wl29.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num14_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num14_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num15_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl30;
    rand uvm_reg_field bank1_err_wl31;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num15_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl30 = uvm_reg_field::type_id::create("bank1_err_wl30",,get_full_name());
        this.bank1_err_wl30.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl31 = uvm_reg_field::type_id::create("bank1_err_wl31",,get_full_name());
        this.bank1_err_wl31.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num15_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num15_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num16_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl32;
    rand uvm_reg_field bank1_err_wl33;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num16_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl32 = uvm_reg_field::type_id::create("bank1_err_wl32",,get_full_name());
        this.bank1_err_wl32.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl33 = uvm_reg_field::type_id::create("bank1_err_wl33",,get_full_name());
        this.bank1_err_wl33.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num16_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num16_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num17_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl34;
    rand uvm_reg_field bank1_err_wl35;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num17_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl34 = uvm_reg_field::type_id::create("bank1_err_wl34",,get_full_name());
        this.bank1_err_wl34.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl35 = uvm_reg_field::type_id::create("bank1_err_wl35",,get_full_name());
        this.bank1_err_wl35.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num17_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num17_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num18_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl36;
    rand uvm_reg_field bank1_err_wl37;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num18_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl36 = uvm_reg_field::type_id::create("bank1_err_wl36",,get_full_name());
        this.bank1_err_wl36.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl37 = uvm_reg_field::type_id::create("bank1_err_wl37",,get_full_name());
        this.bank1_err_wl37.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num18_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num18_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num19_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl38;
    rand uvm_reg_field bank1_err_wl39;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num19_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl38 = uvm_reg_field::type_id::create("bank1_err_wl38",,get_full_name());
        this.bank1_err_wl38.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl39 = uvm_reg_field::type_id::create("bank1_err_wl39",,get_full_name());
        this.bank1_err_wl39.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num19_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num19_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num20_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl40;
    rand uvm_reg_field bank1_err_wl41;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num20_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl40 = uvm_reg_field::type_id::create("bank1_err_wl40",,get_full_name());
        this.bank1_err_wl40.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl41 = uvm_reg_field::type_id::create("bank1_err_wl41",,get_full_name());
        this.bank1_err_wl41.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num20_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num20_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num21_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl42;
    rand uvm_reg_field bank1_err_wl43;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num21_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl42 = uvm_reg_field::type_id::create("bank1_err_wl42",,get_full_name());
        this.bank1_err_wl42.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl43 = uvm_reg_field::type_id::create("bank1_err_wl43",,get_full_name());
        this.bank1_err_wl43.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num21_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num21_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num22_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl44;
    rand uvm_reg_field bank1_err_wl45;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num22_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl44 = uvm_reg_field::type_id::create("bank1_err_wl44",,get_full_name());
        this.bank1_err_wl44.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl45 = uvm_reg_field::type_id::create("bank1_err_wl45",,get_full_name());
        this.bank1_err_wl45.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num22_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num22_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num23_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl46;
    rand uvm_reg_field bank1_err_wl47;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num23_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl46 = uvm_reg_field::type_id::create("bank1_err_wl46",,get_full_name());
        this.bank1_err_wl46.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl47 = uvm_reg_field::type_id::create("bank1_err_wl47",,get_full_name());
        this.bank1_err_wl47.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num23_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num23_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num24_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl48;
    rand uvm_reg_field bank1_err_wl49;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num24_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl48 = uvm_reg_field::type_id::create("bank1_err_wl48",,get_full_name());
        this.bank1_err_wl48.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl49 = uvm_reg_field::type_id::create("bank1_err_wl49",,get_full_name());
        this.bank1_err_wl49.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num24_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num24_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num25_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl50;
    rand uvm_reg_field bank1_err_wl51;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num25_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl50 = uvm_reg_field::type_id::create("bank1_err_wl50",,get_full_name());
        this.bank1_err_wl50.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl51 = uvm_reg_field::type_id::create("bank1_err_wl51",,get_full_name());
        this.bank1_err_wl51.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num25_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num25_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num26_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl52;
    rand uvm_reg_field bank1_err_wl53;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num26_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl52 = uvm_reg_field::type_id::create("bank1_err_wl52",,get_full_name());
        this.bank1_err_wl52.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl53 = uvm_reg_field::type_id::create("bank1_err_wl53",,get_full_name());
        this.bank1_err_wl53.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num26_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num26_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num27_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl54;
    rand uvm_reg_field bank1_err_wl55;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num27_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl54 = uvm_reg_field::type_id::create("bank1_err_wl54",,get_full_name());
        this.bank1_err_wl54.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl55 = uvm_reg_field::type_id::create("bank1_err_wl55",,get_full_name());
        this.bank1_err_wl55.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num27_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num27_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num28_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl56;
    rand uvm_reg_field bank1_err_wl57;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num28_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl56 = uvm_reg_field::type_id::create("bank1_err_wl56",,get_full_name());
        this.bank1_err_wl56.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl57 = uvm_reg_field::type_id::create("bank1_err_wl57",,get_full_name());
        this.bank1_err_wl57.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num28_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num28_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num29_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl58;
    rand uvm_reg_field bank1_err_wl59;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num29_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl58 = uvm_reg_field::type_id::create("bank1_err_wl58",,get_full_name());
        this.bank1_err_wl58.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl59 = uvm_reg_field::type_id::create("bank1_err_wl59",,get_full_name());
        this.bank1_err_wl59.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num29_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num29_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num30_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl60;
    rand uvm_reg_field bank1_err_wl61;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num30_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl60 = uvm_reg_field::type_id::create("bank1_err_wl60",,get_full_name());
        this.bank1_err_wl60.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl61 = uvm_reg_field::type_id::create("bank1_err_wl61",,get_full_name());
        this.bank1_err_wl61.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num30_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num30_reg

class ral_reg_mc_wrapper_top_bank1_err_wl_num31_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_wl62;
    rand uvm_reg_field bank1_err_wl63;

    function new(string name = "mc_wrapper_top_bank1_err_wl_num31_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_wl62 = uvm_reg_field::type_id::create("bank1_err_wl62",,get_full_name());
        this.bank1_err_wl62.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.bank1_err_wl63 = uvm_reg_field::type_id::create("bank1_err_wl63",,get_full_name());
        this.bank1_err_wl63.configure(this,13,16,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_wl_num31_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_wl_num31_reg

class ral_reg_mc_wrapper_top_bank1_err_csl0_part0_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl0_part0;

    function new(string name = "mc_wrapper_top_bank1_err_csl0_part0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl0_part0 = uvm_reg_field::type_id::create("bank1_err_csl0_part0",,get_full_name());
        this.bank1_err_csl0_part0.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl0_part0_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl0_part0_reg

class ral_reg_mc_wrapper_top_bank1_err_csl1_part0_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl1_part0;

    function new(string name = "mc_wrapper_top_bank1_err_csl1_part0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl1_part0 = uvm_reg_field::type_id::create("bank1_err_csl1_part0",,get_full_name());
        this.bank1_err_csl1_part0.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl1_part0_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl1_part0_reg

class ral_reg_mc_wrapper_top_bank1_err_csl0_part1_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl0_part1;

    function new(string name = "mc_wrapper_top_bank1_err_csl0_part1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl0_part1 = uvm_reg_field::type_id::create("bank1_err_csl0_part1",,get_full_name());
        this.bank1_err_csl0_part1.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl0_part1_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl0_part1_reg

class ral_reg_mc_wrapper_top_bank1_err_csl1_part1_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl1_part1;

    function new(string name = "mc_wrapper_top_bank1_err_csl1_part1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl1_part1 = uvm_reg_field::type_id::create("bank1_err_csl1_part1",,get_full_name());
        this.bank1_err_csl1_part1.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl1_part1_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl1_part1_reg

class ral_reg_mc_wrapper_top_bank1_err_csl0_part2_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl0_part2;

    function new(string name = "mc_wrapper_top_bank1_err_csl0_part2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl0_part2 = uvm_reg_field::type_id::create("bank1_err_csl0_part2",,get_full_name());
        this.bank1_err_csl0_part2.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl0_part2_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl0_part2_reg

class ral_reg_mc_wrapper_top_bank1_err_csl1_part2_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl1_part2;

    function new(string name = "mc_wrapper_top_bank1_err_csl1_part2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl1_part2 = uvm_reg_field::type_id::create("bank1_err_csl1_part2",,get_full_name());
        this.bank1_err_csl1_part2.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl1_part2_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl1_part2_reg

class ral_reg_mc_wrapper_top_bank1_err_csl0_part3_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl0_part3;

    function new(string name = "mc_wrapper_top_bank1_err_csl0_part3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl0_part3 = uvm_reg_field::type_id::create("bank1_err_csl0_part3",,get_full_name());
        this.bank1_err_csl0_part3.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl0_part3_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl0_part3_reg

class ral_reg_mc_wrapper_top_bank1_err_csl1_part3_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl1_part3;

    function new(string name = "mc_wrapper_top_bank1_err_csl1_part3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl1_part3 = uvm_reg_field::type_id::create("bank1_err_csl1_part3",,get_full_name());
        this.bank1_err_csl1_part3.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl1_part3_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl1_part3_reg

class ral_reg_mc_wrapper_top_bank1_err_csl0_part4_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl0_part4;

    function new(string name = "mc_wrapper_top_bank1_err_csl0_part4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl0_part4 = uvm_reg_field::type_id::create("bank1_err_csl0_part4",,get_full_name());
        this.bank1_err_csl0_part4.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl0_part4_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl0_part4_reg

class ral_reg_mc_wrapper_top_bank1_err_csl1_part4_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl1_part4;

    function new(string name = "mc_wrapper_top_bank1_err_csl1_part4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl1_part4 = uvm_reg_field::type_id::create("bank1_err_csl1_part4",,get_full_name());
        this.bank1_err_csl1_part4.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl1_part4_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl1_part4_reg

class ral_reg_mc_wrapper_top_bank1_err_csl0_part5_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl0_part5;

    function new(string name = "mc_wrapper_top_bank1_err_csl0_part5_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl0_part5 = uvm_reg_field::type_id::create("bank1_err_csl0_part5",,get_full_name());
        this.bank1_err_csl0_part5.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl0_part5_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl0_part5_reg

class ral_reg_mc_wrapper_top_bank1_err_csl1_part5_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl1_part5;

    function new(string name = "mc_wrapper_top_bank1_err_csl1_part5_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl1_part5 = uvm_reg_field::type_id::create("bank1_err_csl1_part5",,get_full_name());
        this.bank1_err_csl1_part5.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl1_part5_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl1_part5_reg

class ral_reg_mc_wrapper_top_bank1_err_csl0_part6_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl0_part6;

    function new(string name = "mc_wrapper_top_bank1_err_csl0_part6_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl0_part6 = uvm_reg_field::type_id::create("bank1_err_csl0_part6",,get_full_name());
        this.bank1_err_csl0_part6.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl0_part6_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl0_part6_reg

class ral_reg_mc_wrapper_top_bank1_err_csl1_part6_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl1_part6;

    function new(string name = "mc_wrapper_top_bank1_err_csl1_part6_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl1_part6 = uvm_reg_field::type_id::create("bank1_err_csl1_part6",,get_full_name());
        this.bank1_err_csl1_part6.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl1_part6_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl1_part6_reg

class ral_reg_mc_wrapper_top_bank1_err_csl0_part7_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl0_part7;

    function new(string name = "mc_wrapper_top_bank1_err_csl0_part7_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl0_part7 = uvm_reg_field::type_id::create("bank1_err_csl0_part7",,get_full_name());
        this.bank1_err_csl0_part7.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl0_part7_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl0_part7_reg

class ral_reg_mc_wrapper_top_bank1_err_csl1_part7_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl1_part7;

    function new(string name = "mc_wrapper_top_bank1_err_csl1_part7_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl1_part7 = uvm_reg_field::type_id::create("bank1_err_csl1_part7",,get_full_name());
        this.bank1_err_csl1_part7.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl1_part7_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl1_part7_reg

class ral_reg_mc_wrapper_top_bank1_err_csl0_part8_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl0_part8;

    function new(string name = "mc_wrapper_top_bank1_err_csl0_part8_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl0_part8 = uvm_reg_field::type_id::create("bank1_err_csl0_part8",,get_full_name());
        this.bank1_err_csl0_part8.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl0_part8_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl0_part8_reg

class ral_reg_mc_wrapper_top_bank1_err_csl1_part8_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl1_part8;

    function new(string name = "mc_wrapper_top_bank1_err_csl1_part8_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl1_part8 = uvm_reg_field::type_id::create("bank1_err_csl1_part8",,get_full_name());
        this.bank1_err_csl1_part8.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl1_part8_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl1_part8_reg

class ral_reg_mc_wrapper_top_bank1_err_csl0_part9_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl0_part9;

    function new(string name = "mc_wrapper_top_bank1_err_csl0_part9_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl0_part9 = uvm_reg_field::type_id::create("bank1_err_csl0_part9",,get_full_name());
        this.bank1_err_csl0_part9.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl0_part9_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl0_part9_reg

class ral_reg_mc_wrapper_top_bank1_err_csl1_part9_reg extends uvm_reg;
    rand uvm_reg_field bank1_err_csl1_part9;

    function new(string name = "mc_wrapper_top_bank1_err_csl1_part9_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_err_csl1_part9 = uvm_reg_field::type_id::create("bank1_err_csl1_part9",,get_full_name());
        this.bank1_err_csl1_part9.configure(this,8,0,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_err_csl1_part9_reg)
endclass:ral_reg_mc_wrapper_top_bank1_err_csl1_part9_reg

class ral_reg_mc_wrapper_top_mc_bank1_bist_rescan_fail_num_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_bist_rescan_fail_num;

    function new(string name = "mc_wrapper_top_mc_bank1_bist_rescan_fail_num_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_bist_rescan_fail_num = uvm_reg_field::type_id::create("mc_bank1_bist_rescan_fail_num",,get_full_name());
        this.mc_bank1_bist_rescan_fail_num.configure(this,20,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_bist_rescan_fail_num_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_bist_rescan_fail_num_reg

class ral_reg_mc_wrapper_top_mc_bank1_bist_err_wl_reg extends uvm_reg;
    rand uvm_reg_field mc_bank1_bist_err_wl_num;
    rand uvm_reg_field err_bank1_wl_num_change_flag;

    function new(string name = "mc_wrapper_top_mc_bank1_bist_err_wl_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank1_bist_err_wl_num = uvm_reg_field::type_id::create("mc_bank1_bist_err_wl_num",,get_full_name());
        this.mc_bank1_bist_err_wl_num.configure(this,7,0,"RO",0,32'h0,1,0,0);
        this.err_bank1_wl_num_change_flag = uvm_reg_field::type_id::create("err_bank1_wl_num_change_flag",,get_full_name());
        this.err_bank1_wl_num_change_flag.configure(this,1,7,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_mc_bank1_bist_err_wl_reg)
endclass:ral_reg_mc_wrapper_top_mc_bank1_bist_err_wl_reg

class ral_reg_mc_wrapper_top_bank1_rescan_round_result_reg extends uvm_reg;
    rand uvm_reg_field bank1_rescan_round_result;

    function new(string name = "mc_wrapper_top_bank1_rescan_round_result_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank1_rescan_round_result = uvm_reg_field::type_id::create("bank1_rescan_round_result",,get_full_name());
        this.bank1_rescan_round_result.configure(this,15,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_wrapper_top_bank1_rescan_round_result_reg)
endclass:ral_reg_mc_wrapper_top_bank1_rescan_round_result_reg


class ral_block_mc_wrapper_top extends uvm_reg_block;

    rand ral_reg_mc_wrapper_top_mc_id_reg mc_id_reg;
    rand uvm_reg_field mc_id_reg_mc_id;
    rand uvm_reg_field mc_id;
    rand ral_reg_mc_wrapper_top_mc_work_ctrl_reg mc_work_ctrl_reg;
    rand uvm_reg_field mc_work_ctrl_reg_mc_en;
    rand uvm_reg_field mc_en;
    rand uvm_reg_field mc_work_ctrl_reg_mc_rf_cfg_sel;
    rand uvm_reg_field mc_rf_cfg_sel;
    rand uvm_reg_field mc_work_ctrl_reg_mc_debug_en;
    rand uvm_reg_field mc_debug_en;
    rand uvm_reg_field mc_work_ctrl_reg_mc_wl_vmc_en;
    rand uvm_reg_field mc_wl_vmc_en;
    rand uvm_reg_field mc_work_ctrl_reg_mc_bl_vmc_en;
    rand uvm_reg_field mc_bl_vmc_en;
    rand uvm_reg_field mc_work_ctrl_reg_mc_bist_en;
    rand uvm_reg_field mc_bist_en;
    rand uvm_reg_field mc_work_ctrl_reg_mc_rescan_addr_range_sel;
    rand uvm_reg_field mc_rescan_addr_range_sel;
    rand uvm_reg_field mc_work_ctrl_reg_mc_csl_scan_addr_range_sel;
    rand uvm_reg_field mc_csl_scan_addr_range_sel;
    rand uvm_reg_field mc_work_ctrl_reg_mc_csl_scan_check_sel;
    rand uvm_reg_field mc_csl_scan_check_sel;
    rand uvm_reg_field mc_work_ctrl_reg_mc_csl_scan_mode_sel;
    rand uvm_reg_field mc_csl_scan_mode_sel;
    rand ral_reg_mc_wrapper_top_phy_timing_cfg0_reg phy_timing_cfg0_reg;
    rand uvm_reg_field phy_timing_cfg0_reg_bank_radd_set_time;
    rand uvm_reg_field bank_radd_set_time;
    rand uvm_reg_field phy_timing_cfg0_reg_cadd_set_time;
    rand uvm_reg_field cadd_set_time;
    rand uvm_reg_field phy_timing_cfg0_reg_r_cas_set_time;
    rand uvm_reg_field r_cas_set_time;
    rand uvm_reg_field phy_timing_cfg0_reg_w_cas_set_time;
    rand uvm_reg_field w_cas_set_time;
    rand uvm_reg_field phy_timing_cfg0_reg_cas_wrrdy_time;
    rand uvm_reg_field cas_wrrdy_time;
    rand ral_reg_mc_wrapper_top_mc_rf_period_cfg1_reg mc_rf_period_cfg1_reg;
    rand uvm_reg_field mc_rf_period_cfg1_reg_mc_rf_period_1;
    rand uvm_reg_field mc_rf_period_1;
    rand ral_reg_mc_wrapper_top_mc_rf_start_cfg1_reg mc_rf_start_cfg1_reg;
    rand uvm_reg_field mc_rf_start_cfg1_reg_mc_rf_start_1;
    rand uvm_reg_field mc_rf_start_1;
    rand ral_reg_mc_wrapper_top_mc_rf_period_cfg2_reg mc_rf_period_cfg2_reg;
    rand uvm_reg_field mc_rf_period_cfg2_reg_mc_rf_period_2;
    rand uvm_reg_field mc_rf_period_2;
    rand ral_reg_mc_wrapper_top_mc_rf_start_cfg2_reg mc_rf_start_cfg2_reg;
    rand uvm_reg_field mc_rf_start_cfg2_reg_mc_rf_start_2;
    rand uvm_reg_field mc_rf_start_2;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num0_reg mc_vmc_wl_num0_reg;
    rand uvm_reg_field mc_vmc_wl_num0_reg_mc_vmc_wl_num0;
    rand uvm_reg_field mc_vmc_wl_num0;
    rand uvm_reg_field mc_vmc_wl_num0_reg_mc_vmc_wl_num1;
    rand uvm_reg_field mc_vmc_wl_num1;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num1_reg mc_vmc_wl_num1_reg;
    rand uvm_reg_field mc_vmc_wl_num1_reg_mc_vmc_wl_num2;
    rand uvm_reg_field mc_vmc_wl_num2;
    rand uvm_reg_field mc_vmc_wl_num1_reg_mc_vmc_wl_num3;
    rand uvm_reg_field mc_vmc_wl_num3;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num2_reg mc_vmc_wl_num2_reg;
    rand uvm_reg_field mc_vmc_wl_num2_reg_mc_vmc_wl_num4;
    rand uvm_reg_field mc_vmc_wl_num4;
    rand uvm_reg_field mc_vmc_wl_num2_reg_mc_vmc_wl_num5;
    rand uvm_reg_field mc_vmc_wl_num5;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num3_reg mc_vmc_wl_num3_reg;
    rand uvm_reg_field mc_vmc_wl_num3_reg_mc_vmc_wl_num6;
    rand uvm_reg_field mc_vmc_wl_num6;
    rand uvm_reg_field mc_vmc_wl_num3_reg_mc_vmc_wl_num7;
    rand uvm_reg_field mc_vmc_wl_num7;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num4_reg mc_vmc_wl_num4_reg;
    rand uvm_reg_field mc_vmc_wl_num4_reg_mc_vmc_wl_num8;
    rand uvm_reg_field mc_vmc_wl_num8;
    rand uvm_reg_field mc_vmc_wl_num4_reg_mc_vmc_wl_num9;
    rand uvm_reg_field mc_vmc_wl_num9;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num5_reg mc_vmc_wl_num5_reg;
    rand uvm_reg_field mc_vmc_wl_num5_reg_mc_vmc_wl_num10;
    rand uvm_reg_field mc_vmc_wl_num10;
    rand uvm_reg_field mc_vmc_wl_num5_reg_mc_vmc_wl_num11;
    rand uvm_reg_field mc_vmc_wl_num11;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num6_reg mc_vmc_wl_num6_reg;
    rand uvm_reg_field mc_vmc_wl_num6_reg_mc_vmc_wl_num12;
    rand uvm_reg_field mc_vmc_wl_num12;
    rand uvm_reg_field mc_vmc_wl_num6_reg_mc_vmc_wl_num13;
    rand uvm_reg_field mc_vmc_wl_num13;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num7_reg mc_vmc_wl_num7_reg;
    rand uvm_reg_field mc_vmc_wl_num7_reg_mc_vmc_wl_num14;
    rand uvm_reg_field mc_vmc_wl_num14;
    rand uvm_reg_field mc_vmc_wl_num7_reg_mc_vmc_wl_num15;
    rand uvm_reg_field mc_vmc_wl_num15;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num8_reg mc_vmc_wl_num8_reg;
    rand uvm_reg_field mc_vmc_wl_num8_reg_mc_vmc_wl_num16;
    rand uvm_reg_field mc_vmc_wl_num16;
    rand uvm_reg_field mc_vmc_wl_num8_reg_mc_vmc_wl_num17;
    rand uvm_reg_field mc_vmc_wl_num17;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num9_reg mc_vmc_wl_num9_reg;
    rand uvm_reg_field mc_vmc_wl_num9_reg_mc_vmc_wl_num18;
    rand uvm_reg_field mc_vmc_wl_num18;
    rand uvm_reg_field mc_vmc_wl_num9_reg_mc_vmc_wl_num19;
    rand uvm_reg_field mc_vmc_wl_num19;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num10_reg mc_vmc_wl_num10_reg;
    rand uvm_reg_field mc_vmc_wl_num10_reg_mc_vmc_wl_num20;
    rand uvm_reg_field mc_vmc_wl_num20;
    rand uvm_reg_field mc_vmc_wl_num10_reg_mc_vmc_wl_num21;
    rand uvm_reg_field mc_vmc_wl_num21;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num11_reg mc_vmc_wl_num11_reg;
    rand uvm_reg_field mc_vmc_wl_num11_reg_mc_vmc_wl_num22;
    rand uvm_reg_field mc_vmc_wl_num22;
    rand uvm_reg_field mc_vmc_wl_num11_reg_mc_vmc_wl_num23;
    rand uvm_reg_field mc_vmc_wl_num23;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num12_reg mc_vmc_wl_num12_reg;
    rand uvm_reg_field mc_vmc_wl_num12_reg_mc_vmc_wl_num24;
    rand uvm_reg_field mc_vmc_wl_num24;
    rand uvm_reg_field mc_vmc_wl_num12_reg_mc_vmc_wl_num25;
    rand uvm_reg_field mc_vmc_wl_num25;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num13_reg mc_vmc_wl_num13_reg;
    rand uvm_reg_field mc_vmc_wl_num13_reg_mc_vmc_wl_num26;
    rand uvm_reg_field mc_vmc_wl_num26;
    rand uvm_reg_field mc_vmc_wl_num13_reg_mc_vmc_wl_num27;
    rand uvm_reg_field mc_vmc_wl_num27;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num14_reg mc_vmc_wl_num14_reg;
    rand uvm_reg_field mc_vmc_wl_num14_reg_mc_vmc_wl_num28;
    rand uvm_reg_field mc_vmc_wl_num28;
    rand uvm_reg_field mc_vmc_wl_num14_reg_mc_vmc_wl_num29;
    rand uvm_reg_field mc_vmc_wl_num29;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num15_reg mc_vmc_wl_num15_reg;
    rand uvm_reg_field mc_vmc_wl_num15_reg_mc_vmc_wl_num30;
    rand uvm_reg_field mc_vmc_wl_num30;
    rand uvm_reg_field mc_vmc_wl_num15_reg_mc_vmc_wl_num31;
    rand uvm_reg_field mc_vmc_wl_num31;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num16_reg mc_vmc_wl_num16_reg;
    rand uvm_reg_field mc_vmc_wl_num16_reg_mc_vmc_wl_num32;
    rand uvm_reg_field mc_vmc_wl_num32;
    rand uvm_reg_field mc_vmc_wl_num16_reg_mc_vmc_wl_num33;
    rand uvm_reg_field mc_vmc_wl_num33;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num17_reg mc_vmc_wl_num17_reg;
    rand uvm_reg_field mc_vmc_wl_num17_reg_mc_vmc_wl_num34;
    rand uvm_reg_field mc_vmc_wl_num34;
    rand uvm_reg_field mc_vmc_wl_num17_reg_mc_vmc_wl_num35;
    rand uvm_reg_field mc_vmc_wl_num35;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num18_reg mc_vmc_wl_num18_reg;
    rand uvm_reg_field mc_vmc_wl_num18_reg_mc_vmc_wl_num36;
    rand uvm_reg_field mc_vmc_wl_num36;
    rand uvm_reg_field mc_vmc_wl_num18_reg_mc_vmc_wl_num37;
    rand uvm_reg_field mc_vmc_wl_num37;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num19_reg mc_vmc_wl_num19_reg;
    rand uvm_reg_field mc_vmc_wl_num19_reg_mc_vmc_wl_num38;
    rand uvm_reg_field mc_vmc_wl_num38;
    rand uvm_reg_field mc_vmc_wl_num19_reg_mc_vmc_wl_num39;
    rand uvm_reg_field mc_vmc_wl_num39;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num20_reg mc_vmc_wl_num20_reg;
    rand uvm_reg_field mc_vmc_wl_num20_reg_mc_vmc_wl_num40;
    rand uvm_reg_field mc_vmc_wl_num40;
    rand uvm_reg_field mc_vmc_wl_num20_reg_mc_vmc_wl_num41;
    rand uvm_reg_field mc_vmc_wl_num41;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num21_reg mc_vmc_wl_num21_reg;
    rand uvm_reg_field mc_vmc_wl_num21_reg_mc_vmc_wl_num42;
    rand uvm_reg_field mc_vmc_wl_num42;
    rand uvm_reg_field mc_vmc_wl_num21_reg_mc_vmc_wl_num43;
    rand uvm_reg_field mc_vmc_wl_num43;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num22_reg mc_vmc_wl_num22_reg;
    rand uvm_reg_field mc_vmc_wl_num22_reg_mc_vmc_wl_num44;
    rand uvm_reg_field mc_vmc_wl_num44;
    rand uvm_reg_field mc_vmc_wl_num22_reg_mc_vmc_wl_num45;
    rand uvm_reg_field mc_vmc_wl_num45;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num23_reg mc_vmc_wl_num23_reg;
    rand uvm_reg_field mc_vmc_wl_num23_reg_mc_vmc_wl_num46;
    rand uvm_reg_field mc_vmc_wl_num46;
    rand uvm_reg_field mc_vmc_wl_num23_reg_mc_vmc_wl_num47;
    rand uvm_reg_field mc_vmc_wl_num47;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num24_reg mc_vmc_wl_num24_reg;
    rand uvm_reg_field mc_vmc_wl_num24_reg_mc_vmc_wl_num48;
    rand uvm_reg_field mc_vmc_wl_num48;
    rand uvm_reg_field mc_vmc_wl_num24_reg_mc_vmc_wl_num49;
    rand uvm_reg_field mc_vmc_wl_num49;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num25_reg mc_vmc_wl_num25_reg;
    rand uvm_reg_field mc_vmc_wl_num25_reg_mc_vmc_wl_num50;
    rand uvm_reg_field mc_vmc_wl_num50;
    rand uvm_reg_field mc_vmc_wl_num25_reg_mc_vmc_wl_num51;
    rand uvm_reg_field mc_vmc_wl_num51;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num26_reg mc_vmc_wl_num26_reg;
    rand uvm_reg_field mc_vmc_wl_num26_reg_mc_vmc_wl_num52;
    rand uvm_reg_field mc_vmc_wl_num52;
    rand uvm_reg_field mc_vmc_wl_num26_reg_mc_vmc_wl_num53;
    rand uvm_reg_field mc_vmc_wl_num53;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num27_reg mc_vmc_wl_num27_reg;
    rand uvm_reg_field mc_vmc_wl_num27_reg_mc_vmc_wl_num54;
    rand uvm_reg_field mc_vmc_wl_num54;
    rand uvm_reg_field mc_vmc_wl_num27_reg_mc_vmc_wl_num55;
    rand uvm_reg_field mc_vmc_wl_num55;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num28_reg mc_vmc_wl_num28_reg;
    rand uvm_reg_field mc_vmc_wl_num28_reg_mc_vmc_wl_num56;
    rand uvm_reg_field mc_vmc_wl_num56;
    rand uvm_reg_field mc_vmc_wl_num28_reg_mc_vmc_wl_num57;
    rand uvm_reg_field mc_vmc_wl_num57;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num29_reg mc_vmc_wl_num29_reg;
    rand uvm_reg_field mc_vmc_wl_num29_reg_mc_vmc_wl_num58;
    rand uvm_reg_field mc_vmc_wl_num58;
    rand uvm_reg_field mc_vmc_wl_num29_reg_mc_vmc_wl_num59;
    rand uvm_reg_field mc_vmc_wl_num59;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num30_reg mc_vmc_wl_num30_reg;
    rand uvm_reg_field mc_vmc_wl_num30_reg_mc_vmc_wl_num60;
    rand uvm_reg_field mc_vmc_wl_num60;
    rand uvm_reg_field mc_vmc_wl_num30_reg_mc_vmc_wl_num61;
    rand uvm_reg_field mc_vmc_wl_num61;
    rand ral_reg_mc_wrapper_top_mc_vmc_wl_num31_reg mc_vmc_wl_num31_reg;
    rand uvm_reg_field mc_vmc_wl_num31_reg_mc_vmc_wl_num62;
    rand uvm_reg_field mc_vmc_wl_num62;
    rand uvm_reg_field mc_vmc_wl_num31_reg_mc_vmc_wl_num63;
    rand uvm_reg_field mc_vmc_wl_num63;
    rand ral_reg_mc_wrapper_top_mc_vmc_bl_num0_reg mc_vmc_bl_num0_reg;
    rand uvm_reg_field mc_vmc_bl_num0_reg_mc_vmc_bl_num0_part0;
    rand uvm_reg_field mc_vmc_bl_num0_part0;
    rand uvm_reg_field mc_vmc_bl_num0_reg_mc_vmc_bl_num1_part0;
    rand uvm_reg_field mc_vmc_bl_num1_part0;
    rand uvm_reg_field mc_vmc_bl_num0_reg_mc_vmc_bl_num0_part1;
    rand uvm_reg_field mc_vmc_bl_num0_part1;
    rand uvm_reg_field mc_vmc_bl_num0_reg_mc_vmc_bl_num1_part1;
    rand uvm_reg_field mc_vmc_bl_num1_part1;
    rand ral_reg_mc_wrapper_top_mc_vmc_bl_num1_reg mc_vmc_bl_num1_reg;
    rand uvm_reg_field mc_vmc_bl_num1_reg_mc_vmc_bl_num0_part2;
    rand uvm_reg_field mc_vmc_bl_num0_part2;
    rand uvm_reg_field mc_vmc_bl_num1_reg_mc_vmc_bl_num1_part2;
    rand uvm_reg_field mc_vmc_bl_num1_part2;
    rand uvm_reg_field mc_vmc_bl_num1_reg_mc_vmc_bl_num0_part3;
    rand uvm_reg_field mc_vmc_bl_num0_part3;
    rand uvm_reg_field mc_vmc_bl_num1_reg_mc_vmc_bl_num1_part3;
    rand uvm_reg_field mc_vmc_bl_num1_part3;
    rand ral_reg_mc_wrapper_top_mc_vmc_bl_num2_reg mc_vmc_bl_num2_reg;
    rand uvm_reg_field mc_vmc_bl_num2_reg_mc_vmc_bl_num0_part4;
    rand uvm_reg_field mc_vmc_bl_num0_part4;
    rand uvm_reg_field mc_vmc_bl_num2_reg_mc_vmc_bl_num1_part4;
    rand uvm_reg_field mc_vmc_bl_num1_part4;
    rand uvm_reg_field mc_vmc_bl_num2_reg_mc_vmc_bl_num0_part5;
    rand uvm_reg_field mc_vmc_bl_num0_part5;
    rand uvm_reg_field mc_vmc_bl_num2_reg_mc_vmc_bl_num1_part5;
    rand uvm_reg_field mc_vmc_bl_num1_part5;
    rand ral_reg_mc_wrapper_top_mc_vmc_bl_num3_reg mc_vmc_bl_num3_reg;
    rand uvm_reg_field mc_vmc_bl_num3_reg_mc_vmc_bl_num0_part6;
    rand uvm_reg_field mc_vmc_bl_num0_part6;
    rand uvm_reg_field mc_vmc_bl_num3_reg_mc_vmc_bl_num1_part6;
    rand uvm_reg_field mc_vmc_bl_num1_part6;
    rand uvm_reg_field mc_vmc_bl_num3_reg_mc_vmc_bl_num0_part7;
    rand uvm_reg_field mc_vmc_bl_num0_part7;
    rand uvm_reg_field mc_vmc_bl_num3_reg_mc_vmc_bl_num1_part7;
    rand uvm_reg_field mc_vmc_bl_num1_part7;
    rand ral_reg_mc_wrapper_top_mc_vmc_bl_num4_reg mc_vmc_bl_num4_reg;
    rand uvm_reg_field mc_vmc_bl_num4_reg_mc_vmc_bl_num0_part8;
    rand uvm_reg_field mc_vmc_bl_num0_part8;
    rand uvm_reg_field mc_vmc_bl_num4_reg_mc_vmc_bl_num1_part8;
    rand uvm_reg_field mc_vmc_bl_num1_part8;
    rand uvm_reg_field mc_vmc_bl_num4_reg_mc_vmc_bl_num0_part9;
    rand uvm_reg_field mc_vmc_bl_num0_part9;
    rand uvm_reg_field mc_vmc_bl_num4_reg_mc_vmc_bl_num1_part9;
    rand uvm_reg_field mc_vmc_bl_num1_part9;
    rand ral_reg_mc_wrapper_top_mc_frame2array_dbg_reg mc_frame2array_dbg_reg;
    rand uvm_reg_field mc_frame2array_dbg_reg_dbg_next_state_array;
    rand uvm_reg_field dbg_next_state_array;
    rand uvm_reg_field mc_frame2array_dbg_reg_dbg_current_state_array;
    rand uvm_reg_field dbg_current_state_array;
    rand uvm_reg_field mc_frame2array_dbg_reg_dbg_r_data_cnt;
    rand uvm_reg_field dbg_r_data_cnt;
    rand uvm_reg_field mc_frame2array_dbg_reg_dbg_refresh_flag;
    rand uvm_reg_field dbg_refresh_flag;
    rand uvm_reg_field mc_frame2array_dbg_reg_dbg_r_frame_cnt;
    rand uvm_reg_field dbg_r_frame_cnt;
    rand uvm_reg_field mc_frame2array_dbg_reg_dbg_w_frame_cnt;
    rand uvm_reg_field dbg_w_frame_cnt;
    rand uvm_reg_field mc_frame2array_dbg_reg_ras_clr;
    rand uvm_reg_field ras_clr;
    rand ral_reg_mc_wrapper_top_mc_timeout_clr_reg mc_timeout_clr_reg;
    rand uvm_reg_field mc_timeout_clr_reg_mc_timeout_clr;
    rand uvm_reg_field mc_timeout_clr;
    rand ral_reg_mc_wrapper_top_mc_rf_start_dbg_reg mc_rf_start_dbg_reg;
    rand uvm_reg_field mc_rf_start_dbg_reg_mc_rf_start_dbg;
    rand uvm_reg_field mc_rf_start_dbg;
    rand ral_reg_mc_wrapper_top_mc_timeout_flag_reg mc_timeout_flag_reg;
    rand uvm_reg_field mc_timeout_flag_reg_mc_timeout_flag;
    rand uvm_reg_field mc_timeout_flag;
    rand ral_reg_mc_wrapper_top_mc_bist_status_reg mc_bist_status_reg;
    rand uvm_reg_field mc_bist_status_reg_mc_bist_status;
    rand uvm_reg_field mc_bist_status;
    rand uvm_reg_field mc_bist_status_reg_mc_bist_path_fail;
    rand uvm_reg_field mc_bist_path_fail;
    rand uvm_reg_field mc_bist_status_reg_dram_init_finish;
    rand uvm_reg_field dram_init_finish;
    rand ral_reg_mc_wrapper_top_bist_finish_reg bist_finish_reg;
    rand uvm_reg_field bist_finish_reg_bist_finish;
    rand uvm_reg_field bist_finish;
    rand uvm_reg_field bist_finish_reg_bist_rescan_finish;
    rand uvm_reg_field bist_rescan_finish;
    rand ral_reg_mc_wrapper_top_bank_success_reg bank_success_reg;
    rand uvm_reg_field bank_success_reg_bank_success;
    rand uvm_reg_field bank_success;
    rand uvm_reg_field bank_success_reg_bist_rescan_success;
    rand uvm_reg_field bist_rescan_success;
    rand ral_reg_mc_wrapper_top_err_csl0_reg err_csl0_reg;
    rand uvm_reg_field err_csl0_reg_err_csl0_part0;
    rand uvm_reg_field err_csl0_part0;
    rand uvm_reg_field err_csl0_reg_err_csl1_part0;
    rand uvm_reg_field err_csl1_part0;
    rand uvm_reg_field err_csl0_reg_err_csl0_part1;
    rand uvm_reg_field err_csl0_part1;
    rand uvm_reg_field err_csl0_reg_err_csl1_part1;
    rand uvm_reg_field err_csl1_part1;
    rand ral_reg_mc_wrapper_top_err_csl1_reg err_csl1_reg;
    rand uvm_reg_field err_csl1_reg_err_csl0_part2;
    rand uvm_reg_field err_csl0_part2;
    rand uvm_reg_field err_csl1_reg_err_csl1_part2;
    rand uvm_reg_field err_csl1_part2;
    rand uvm_reg_field err_csl1_reg_err_csl0_part3;
    rand uvm_reg_field err_csl0_part3;
    rand uvm_reg_field err_csl1_reg_err_csl1_part3;
    rand uvm_reg_field err_csl1_part3;
    rand ral_reg_mc_wrapper_top_err_csl2_reg err_csl2_reg;
    rand uvm_reg_field err_csl2_reg_err_csl0_part4;
    rand uvm_reg_field err_csl0_part4;
    rand uvm_reg_field err_csl2_reg_err_csl1_part4;
    rand uvm_reg_field err_csl1_part4;
    rand uvm_reg_field err_csl2_reg_err_csl0_part5;
    rand uvm_reg_field err_csl0_part5;
    rand uvm_reg_field err_csl2_reg_err_csl1_part5;
    rand uvm_reg_field err_csl1_part5;
    rand ral_reg_mc_wrapper_top_err_csl3_reg err_csl3_reg;
    rand uvm_reg_field err_csl3_reg_err_csl0_part6;
    rand uvm_reg_field err_csl0_part6;
    rand uvm_reg_field err_csl3_reg_err_csl1_part6;
    rand uvm_reg_field err_csl1_part6;
    rand uvm_reg_field err_csl3_reg_err_csl0_part7;
    rand uvm_reg_field err_csl0_part7;
    rand uvm_reg_field err_csl3_reg_err_csl1_part7;
    rand uvm_reg_field err_csl1_part7;
    rand ral_reg_mc_wrapper_top_err_csl4_reg err_csl4_reg;
    rand uvm_reg_field err_csl4_reg_err_csl0_part8;
    rand uvm_reg_field err_csl0_part8;
    rand uvm_reg_field err_csl4_reg_err_csl1_part8;
    rand uvm_reg_field err_csl1_part8;
    rand uvm_reg_field err_csl4_reg_err_csl0_part9;
    rand uvm_reg_field err_csl0_part9;
    rand uvm_reg_field err_csl4_reg_err_csl1_part9;
    rand uvm_reg_field err_csl1_part9;
    rand ral_reg_mc_wrapper_top_err_wl0_reg err_wl0_reg;
    rand uvm_reg_field err_wl0_reg_err_wl0;
    rand uvm_reg_field err_wl0;
    rand uvm_reg_field err_wl0_reg_err_wl1;
    rand uvm_reg_field err_wl1;
    rand ral_reg_mc_wrapper_top_err_wl1_reg err_wl1_reg;
    rand uvm_reg_field err_wl1_reg_err_wl2;
    rand uvm_reg_field err_wl2;
    rand uvm_reg_field err_wl1_reg_err_wl3;
    rand uvm_reg_field err_wl3;
    rand ral_reg_mc_wrapper_top_err_wl2_reg err_wl2_reg;
    rand uvm_reg_field err_wl2_reg_err_wl4;
    rand uvm_reg_field err_wl4;
    rand uvm_reg_field err_wl2_reg_err_wl5;
    rand uvm_reg_field err_wl5;
    rand ral_reg_mc_wrapper_top_err_wl3_reg err_wl3_reg;
    rand uvm_reg_field err_wl3_reg_err_wl6;
    rand uvm_reg_field err_wl6;
    rand uvm_reg_field err_wl3_reg_err_wl7;
    rand uvm_reg_field err_wl7;
    rand ral_reg_mc_wrapper_top_err_wl4_reg err_wl4_reg;
    rand uvm_reg_field err_wl4_reg_err_wl8;
    rand uvm_reg_field err_wl8;
    rand uvm_reg_field err_wl4_reg_err_wl9;
    rand uvm_reg_field err_wl9;
    rand ral_reg_mc_wrapper_top_err_wl5_reg err_wl5_reg;
    rand uvm_reg_field err_wl5_reg_err_wl10;
    rand uvm_reg_field err_wl10;
    rand uvm_reg_field err_wl5_reg_err_wl11;
    rand uvm_reg_field err_wl11;
    rand ral_reg_mc_wrapper_top_err_wl6_reg err_wl6_reg;
    rand uvm_reg_field err_wl6_reg_err_wl12;
    rand uvm_reg_field err_wl12;
    rand uvm_reg_field err_wl6_reg_err_wl13;
    rand uvm_reg_field err_wl13;
    rand ral_reg_mc_wrapper_top_err_wl7_reg err_wl7_reg;
    rand uvm_reg_field err_wl7_reg_err_wl14;
    rand uvm_reg_field err_wl14;
    rand uvm_reg_field err_wl7_reg_err_wl15;
    rand uvm_reg_field err_wl15;
    rand ral_reg_mc_wrapper_top_err_wl8_reg err_wl8_reg;
    rand uvm_reg_field err_wl8_reg_err_wl16;
    rand uvm_reg_field err_wl16;
    rand uvm_reg_field err_wl8_reg_err_wl17;
    rand uvm_reg_field err_wl17;
    rand ral_reg_mc_wrapper_top_err_wl9_reg err_wl9_reg;
    rand uvm_reg_field err_wl9_reg_err_wl18;
    rand uvm_reg_field err_wl18;
    rand uvm_reg_field err_wl9_reg_err_wl19;
    rand uvm_reg_field err_wl19;
    rand ral_reg_mc_wrapper_top_err_wl10_reg err_wl10_reg;
    rand uvm_reg_field err_wl10_reg_err_wl20;
    rand uvm_reg_field err_wl20;
    rand uvm_reg_field err_wl10_reg_err_wl21;
    rand uvm_reg_field err_wl21;
    rand ral_reg_mc_wrapper_top_err_wl11_reg err_wl11_reg;
    rand uvm_reg_field err_wl11_reg_err_wl22;
    rand uvm_reg_field err_wl22;
    rand uvm_reg_field err_wl11_reg_err_wl23;
    rand uvm_reg_field err_wl23;
    rand ral_reg_mc_wrapper_top_err_wl12_reg err_wl12_reg;
    rand uvm_reg_field err_wl12_reg_err_wl24;
    rand uvm_reg_field err_wl24;
    rand uvm_reg_field err_wl12_reg_err_wl25;
    rand uvm_reg_field err_wl25;
    rand ral_reg_mc_wrapper_top_err_wl13_reg err_wl13_reg;
    rand uvm_reg_field err_wl13_reg_err_wl26;
    rand uvm_reg_field err_wl26;
    rand uvm_reg_field err_wl13_reg_err_wl27;
    rand uvm_reg_field err_wl27;
    rand ral_reg_mc_wrapper_top_err_wl14_reg err_wl14_reg;
    rand uvm_reg_field err_wl14_reg_err_wl28;
    rand uvm_reg_field err_wl28;
    rand uvm_reg_field err_wl14_reg_err_wl29;
    rand uvm_reg_field err_wl29;
    rand ral_reg_mc_wrapper_top_err_wl15_reg err_wl15_reg;
    rand uvm_reg_field err_wl15_reg_err_wl30;
    rand uvm_reg_field err_wl30;
    rand uvm_reg_field err_wl15_reg_err_wl31;
    rand uvm_reg_field err_wl31;
    rand ral_reg_mc_wrapper_top_err_wl16_reg err_wl16_reg;
    rand uvm_reg_field err_wl16_reg_err_wl32;
    rand uvm_reg_field err_wl32;
    rand uvm_reg_field err_wl16_reg_err_wl33;
    rand uvm_reg_field err_wl33;
    rand ral_reg_mc_wrapper_top_err_wl17_reg err_wl17_reg;
    rand uvm_reg_field err_wl17_reg_err_wl34;
    rand uvm_reg_field err_wl34;
    rand uvm_reg_field err_wl17_reg_err_wl35;
    rand uvm_reg_field err_wl35;
    rand ral_reg_mc_wrapper_top_err_wl18_reg err_wl18_reg;
    rand uvm_reg_field err_wl18_reg_err_wl36;
    rand uvm_reg_field err_wl36;
    rand uvm_reg_field err_wl18_reg_err_wl37;
    rand uvm_reg_field err_wl37;
    rand ral_reg_mc_wrapper_top_err_wl19_reg err_wl19_reg;
    rand uvm_reg_field err_wl19_reg_err_wl38;
    rand uvm_reg_field err_wl38;
    rand uvm_reg_field err_wl19_reg_err_wl39;
    rand uvm_reg_field err_wl39;
    rand ral_reg_mc_wrapper_top_err_wl20_reg err_wl20_reg;
    rand uvm_reg_field err_wl20_reg_err_wl40;
    rand uvm_reg_field err_wl40;
    rand uvm_reg_field err_wl20_reg_err_wl41;
    rand uvm_reg_field err_wl41;
    rand ral_reg_mc_wrapper_top_err_wl21_reg err_wl21_reg;
    rand uvm_reg_field err_wl21_reg_err_wl42;
    rand uvm_reg_field err_wl42;
    rand uvm_reg_field err_wl21_reg_err_wl43;
    rand uvm_reg_field err_wl43;
    rand ral_reg_mc_wrapper_top_err_wl22_reg err_wl22_reg;
    rand uvm_reg_field err_wl22_reg_err_wl44;
    rand uvm_reg_field err_wl44;
    rand uvm_reg_field err_wl22_reg_err_wl45;
    rand uvm_reg_field err_wl45;
    rand ral_reg_mc_wrapper_top_err_wl23_reg err_wl23_reg;
    rand uvm_reg_field err_wl23_reg_err_wl46;
    rand uvm_reg_field err_wl46;
    rand uvm_reg_field err_wl23_reg_err_wl47;
    rand uvm_reg_field err_wl47;
    rand ral_reg_mc_wrapper_top_err_wl24_reg err_wl24_reg;
    rand uvm_reg_field err_wl24_reg_err_wl48;
    rand uvm_reg_field err_wl48;
    rand uvm_reg_field err_wl24_reg_err_wl49;
    rand uvm_reg_field err_wl49;
    rand ral_reg_mc_wrapper_top_err_wl25_reg err_wl25_reg;
    rand uvm_reg_field err_wl25_reg_err_wl50;
    rand uvm_reg_field err_wl50;
    rand uvm_reg_field err_wl25_reg_err_wl51;
    rand uvm_reg_field err_wl51;
    rand ral_reg_mc_wrapper_top_err_wl26_reg err_wl26_reg;
    rand uvm_reg_field err_wl26_reg_err_wl52;
    rand uvm_reg_field err_wl52;
    rand uvm_reg_field err_wl26_reg_err_wl53;
    rand uvm_reg_field err_wl53;
    rand ral_reg_mc_wrapper_top_err_wl27_reg err_wl27_reg;
    rand uvm_reg_field err_wl27_reg_err_wl54;
    rand uvm_reg_field err_wl54;
    rand uvm_reg_field err_wl27_reg_err_wl55;
    rand uvm_reg_field err_wl55;
    rand ral_reg_mc_wrapper_top_err_wl28_reg err_wl28_reg;
    rand uvm_reg_field err_wl28_reg_err_wl56;
    rand uvm_reg_field err_wl56;
    rand uvm_reg_field err_wl28_reg_err_wl57;
    rand uvm_reg_field err_wl57;
    rand ral_reg_mc_wrapper_top_err_wl29_reg err_wl29_reg;
    rand uvm_reg_field err_wl29_reg_err_wl58;
    rand uvm_reg_field err_wl58;
    rand uvm_reg_field err_wl29_reg_err_wl59;
    rand uvm_reg_field err_wl59;
    rand ral_reg_mc_wrapper_top_err_wl30_reg err_wl30_reg;
    rand uvm_reg_field err_wl30_reg_err_wl60;
    rand uvm_reg_field err_wl60;
    rand uvm_reg_field err_wl30_reg_err_wl61;
    rand uvm_reg_field err_wl61;
    rand ral_reg_mc_wrapper_top_err_wl31_reg err_wl31_reg;
    rand uvm_reg_field err_wl31_reg_err_wl62;
    rand uvm_reg_field err_wl62;
    rand uvm_reg_field err_wl31_reg_err_wl63;
    rand uvm_reg_field err_wl63;
    rand ral_reg_mc_wrapper_top_bist_finish_clr_reg bist_finish_clr_reg;
    rand uvm_reg_field bist_finish_clr_reg_bist_finish_clr;
    rand uvm_reg_field bist_finish_clr;
    rand ral_reg_mc_wrapper_top_bist_finish_mask_reg bist_finish_mask_reg;
    rand uvm_reg_field bist_finish_mask_reg_bist_finish_mask;
    rand uvm_reg_field bist_finish_mask;
    rand ral_reg_mc_wrapper_top_hang_timeout_th_reg hang_timeout_th_reg;
    rand uvm_reg_field hang_timeout_th_reg_hang_timeout_th;
    rand uvm_reg_field hang_timeout_th;
    rand ral_reg_mc_wrapper_top_mc_bist_rescan_fail_num_reg mc_bist_rescan_fail_num_reg;
    rand uvm_reg_field mc_bist_rescan_fail_num_reg_mc_bist_rescan_fail_num;
    rand uvm_reg_field mc_bist_rescan_fail_num;
    rand ral_reg_mc_wrapper_top_mc_bist_err_wl_reg mc_bist_err_wl_reg;
    rand uvm_reg_field mc_bist_err_wl_reg_mc_bist_err_wl_num;
    rand uvm_reg_field mc_bist_err_wl_num;
    rand uvm_reg_field mc_bist_err_wl_reg_err_wl_num_change_flag;
    rand uvm_reg_field err_wl_num_change_flag;
    rand ral_reg_mc_wrapper_top_rescan_finish_clr_reg rescan_finish_clr_reg;
    rand uvm_reg_field rescan_finish_clr_reg_rescan_finish_clr;
    rand uvm_reg_field rescan_finish_clr;
    rand ral_reg_mc_wrapper_top_rescan_finish_mask_reg rescan_finish_mask_reg;
    rand uvm_reg_field rescan_finish_mask_reg_rescan_finish_mask;
    rand uvm_reg_field rescan_finish_mask;
    rand ral_reg_mc_wrapper_top_rescan_round_result_reg rescan_round_result_reg;
    rand uvm_reg_field rescan_round_result_reg_rescan_round_result;
    rand uvm_reg_field rescan_round_result;
    rand ral_reg_mc_wrapper_top_dbg_frame_store_0_reg dbg_frame_store_0_reg;
    rand uvm_reg_field dbg_frame_store_0_reg_dbg_frame_store_0;
    rand uvm_reg_field dbg_frame_store_0;
    rand ral_reg_mc_wrapper_top_dbg_frame_store_1_reg dbg_frame_store_1_reg;
    rand uvm_reg_field dbg_frame_store_1_reg_dbg_frame_store_1;
    rand uvm_reg_field dbg_frame_store_1;
    rand ral_reg_mc_wrapper_top_dbg_frame_store_2_reg dbg_frame_store_2_reg;
    rand uvm_reg_field dbg_frame_store_2_reg_dbg_frame_store_2;
    rand uvm_reg_field dbg_frame_store_2;
    rand ral_reg_mc_wrapper_top_dbg_frame_store_3_reg dbg_frame_store_3_reg;
    rand uvm_reg_field dbg_frame_store_3_reg_dbg_frame_store_3;
    rand uvm_reg_field dbg_frame_store_3;
    rand ral_reg_mc_wrapper_top_dbg_frame_store_4_reg dbg_frame_store_4_reg;
    rand uvm_reg_field dbg_frame_store_4_reg_dbg_frame_store_4;
    rand uvm_reg_field dbg_frame_store_4;
    rand ral_reg_mc_wrapper_top_dbg_frame_store_5_reg dbg_frame_store_5_reg;
    rand uvm_reg_field dbg_frame_store_5_reg_dbg_frame_store_5;
    rand uvm_reg_field dbg_frame_store_5;
    rand ral_reg_mc_wrapper_top_dbg_frame_store_6_reg dbg_frame_store_6_reg;
    rand uvm_reg_field dbg_frame_store_6_reg_dbg_frame_store_6;
    rand uvm_reg_field dbg_frame_store_6;
    rand ral_reg_mc_wrapper_top_dbg_frame_store_7_reg dbg_frame_store_7_reg;
    rand uvm_reg_field dbg_frame_store_7_reg_dbg_frame_store_7;
    rand uvm_reg_field dbg_frame_store_7;
    rand ral_reg_mc_wrapper_top_dbg_frame_store_8_reg dbg_frame_store_8_reg;
    rand uvm_reg_field dbg_frame_store_8_reg_dbg_frame_store_8;
    rand uvm_reg_field dbg_frame_store_8;
    rand ral_reg_mc_wrapper_top_dbg_frame_store_9_reg dbg_frame_store_9_reg;
    rand uvm_reg_field dbg_frame_store_9_reg_dbg_frame_store_9;
    rand uvm_reg_field dbg_frame_store_9;
    rand ral_reg_mc_wrapper_top_dbg_rdata_store_0_reg dbg_rdata_store_0_reg;
    rand uvm_reg_field dbg_rdata_store_0_reg_dbg_rdata_store_0;
    rand uvm_reg_field dbg_rdata_store_0;
    rand ral_reg_mc_wrapper_top_dbg_rdata_store_1_reg dbg_rdata_store_1_reg;
    rand uvm_reg_field dbg_rdata_store_1_reg_dbg_rdata_store_1;
    rand uvm_reg_field dbg_rdata_store_1;
    rand ral_reg_mc_wrapper_top_dbg_rdata_store_2_reg dbg_rdata_store_2_reg;
    rand uvm_reg_field dbg_rdata_store_2_reg_dbg_rdata_store_2;
    rand uvm_reg_field dbg_rdata_store_2;
    rand ral_reg_mc_wrapper_top_dbg_rdata_store_3_reg dbg_rdata_store_3_reg;
    rand uvm_reg_field dbg_rdata_store_3_reg_dbg_rdata_store_3;
    rand uvm_reg_field dbg_rdata_store_3;
    rand ral_reg_mc_wrapper_top_dbg_rdata_store_4_reg dbg_rdata_store_4_reg;
    rand uvm_reg_field dbg_rdata_store_4_reg_dbg_rdata_store_4;
    rand uvm_reg_field dbg_rdata_store_4;
    rand ral_reg_mc_wrapper_top_dbg_rdata_store_5_reg dbg_rdata_store_5_reg;
    rand uvm_reg_field dbg_rdata_store_5_reg_dbg_rdata_store_5;
    rand uvm_reg_field dbg_rdata_store_5;
    rand ral_reg_mc_wrapper_top_dbg_rdata_store_6_reg dbg_rdata_store_6_reg;
    rand uvm_reg_field dbg_rdata_store_6_reg_dbg_rdata_store_6;
    rand uvm_reg_field dbg_rdata_store_6;
    rand ral_reg_mc_wrapper_top_dbg_rdata_store_7_reg dbg_rdata_store_7_reg;
    rand uvm_reg_field dbg_rdata_store_7_reg_dbg_rdata_store_7;
    rand uvm_reg_field dbg_rdata_store_7;
    rand ral_reg_mc_wrapper_top_dbg_rdata_store_8_reg dbg_rdata_store_8_reg;
    rand uvm_reg_field dbg_rdata_store_8_reg_dbg_rdata_store_8;
    rand uvm_reg_field dbg_rdata_store_8;
    rand ral_reg_mc_wrapper_top_bist_pattern_reg0_reg bist_pattern_reg0_reg;
    rand uvm_reg_field bist_pattern_reg0_reg_bist_pattern_reg0;
    rand uvm_reg_field bist_pattern_reg0;
    rand ral_reg_mc_wrapper_top_bist_pattern_reg1_reg bist_pattern_reg1_reg;
    rand uvm_reg_field bist_pattern_reg1_reg_bist_pattern_reg1;
    rand uvm_reg_field bist_pattern_reg1;
    rand ral_reg_mc_wrapper_top_bist_pattern_reg2_reg bist_pattern_reg2_reg;
    rand uvm_reg_field bist_pattern_reg2_reg_bist_pattern_reg2;
    rand uvm_reg_field bist_pattern_reg2;
    rand ral_reg_mc_wrapper_top_bist_pattern_reg3_reg bist_pattern_reg3_reg;
    rand uvm_reg_field bist_pattern_reg3_reg_bist_pattern_reg3;
    rand uvm_reg_field bist_pattern_reg3;
    rand ral_reg_mc_wrapper_top_csl_bist_pattern_sel0_reg csl_bist_pattern_sel0_reg;
    rand uvm_reg_field csl_bist_pattern_sel0_reg_csl_bist_pattern_sel0;
    rand uvm_reg_field csl_bist_pattern_sel0;
    rand ral_reg_mc_wrapper_top_csl_bist_pattern_sel1_reg csl_bist_pattern_sel1_reg;
    rand uvm_reg_field csl_bist_pattern_sel1_reg_csl_bist_pattern_sel1;
    rand uvm_reg_field csl_bist_pattern_sel1;
    rand ral_reg_mc_wrapper_top_csl_bist_pattern_sel2_reg csl_bist_pattern_sel2_reg;
    rand uvm_reg_field csl_bist_pattern_sel2_reg_csl_bist_pattern_sel2;
    rand uvm_reg_field csl_bist_pattern_sel2;
    rand ral_reg_mc_wrapper_top_wl_bist_pattern_sel0_reg wl_bist_pattern_sel0_reg;
    rand uvm_reg_field wl_bist_pattern_sel0_reg_wl_bist_pattern_sel0;
    rand uvm_reg_field wl_bist_pattern_sel0;
    rand ral_reg_mc_wrapper_top_wl_bist_pattern_sel1_reg wl_bist_pattern_sel1_reg;
    rand uvm_reg_field wl_bist_pattern_sel1_reg_wl_bist_pattern_sel1;
    rand uvm_reg_field wl_bist_pattern_sel1;
    rand ral_reg_mc_wrapper_top_wl_bist_pattern_sel2_reg wl_bist_pattern_sel2_reg;
    rand uvm_reg_field wl_bist_pattern_sel2_reg_wl_bist_pattern_sel2;
    rand uvm_reg_field wl_bist_pattern_sel2;
    rand ral_reg_mc_wrapper_top_mc_ecc_ctrl_reg mc_ecc_ctrl_reg;
    rand uvm_reg_field mc_ecc_ctrl_reg_mc_ecc_en;
    rand uvm_reg_field mc_ecc_en;
    rand uvm_reg_field mc_ecc_ctrl_reg_mc_ecc_ce_th;
    rand uvm_reg_field mc_ecc_ce_th;
    rand uvm_reg_field mc_ecc_ctrl_reg_mc_ecc_ce_int_clr;
    rand uvm_reg_field mc_ecc_ce_int_clr;
    rand uvm_reg_field mc_ecc_ctrl_reg_mc_ecc_ce_int_mask;
    rand uvm_reg_field mc_ecc_ce_int_mask;
    rand uvm_reg_field mc_ecc_ctrl_reg_mc_ecc_uce_int_clr;
    rand uvm_reg_field mc_ecc_uce_int_clr;
    rand uvm_reg_field mc_ecc_ctrl_reg_mc_ecc_uce_int_mask;
    rand uvm_reg_field mc_ecc_uce_int_mask;
    rand ral_reg_mc_wrapper_top_mc_ecc_int_status_reg mc_ecc_int_status_reg;
    rand uvm_reg_field mc_ecc_int_status_reg_mc_ecc_ce_int_status;
    rand uvm_reg_field mc_ecc_ce_int_status;
    rand uvm_reg_field mc_ecc_int_status_reg_mc_ecc_uce_int_status;
    rand uvm_reg_field mc_ecc_uce_int_status;
    rand uvm_reg_field mc_ecc_int_status_reg_mc_ecc_ce_cnt;
    rand uvm_reg_field mc_ecc_ce_cnt;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr0_reg mc_ecc_ce_addr0_reg;
    rand uvm_reg_field mc_ecc_ce_addr0_reg_mc_ecc_ce_addr0;
    rand uvm_reg_field mc_ecc_ce_addr0;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr1_reg mc_ecc_ce_addr1_reg;
    rand uvm_reg_field mc_ecc_ce_addr1_reg_mc_ecc_ce_addr1;
    rand uvm_reg_field mc_ecc_ce_addr1;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr2_reg mc_ecc_ce_addr2_reg;
    rand uvm_reg_field mc_ecc_ce_addr2_reg_mc_ecc_ce_addr2;
    rand uvm_reg_field mc_ecc_ce_addr2;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr3_reg mc_ecc_ce_addr3_reg;
    rand uvm_reg_field mc_ecc_ce_addr3_reg_mc_ecc_ce_addr3;
    rand uvm_reg_field mc_ecc_ce_addr3;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr4_reg mc_ecc_ce_addr4_reg;
    rand uvm_reg_field mc_ecc_ce_addr4_reg_mc_ecc_ce_addr4;
    rand uvm_reg_field mc_ecc_ce_addr4;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr5_reg mc_ecc_ce_addr5_reg;
    rand uvm_reg_field mc_ecc_ce_addr5_reg_mc_ecc_ce_addr5;
    rand uvm_reg_field mc_ecc_ce_addr5;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr6_reg mc_ecc_ce_addr6_reg;
    rand uvm_reg_field mc_ecc_ce_addr6_reg_mc_ecc_ce_addr6;
    rand uvm_reg_field mc_ecc_ce_addr6;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr7_reg mc_ecc_ce_addr7_reg;
    rand uvm_reg_field mc_ecc_ce_addr7_reg_mc_ecc_ce_addr7;
    rand uvm_reg_field mc_ecc_ce_addr7;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr8_reg mc_ecc_ce_addr8_reg;
    rand uvm_reg_field mc_ecc_ce_addr8_reg_mc_ecc_ce_addr8;
    rand uvm_reg_field mc_ecc_ce_addr8;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr9_reg mc_ecc_ce_addr9_reg;
    rand uvm_reg_field mc_ecc_ce_addr9_reg_mc_ecc_ce_addr9;
    rand uvm_reg_field mc_ecc_ce_addr9;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr10_reg mc_ecc_ce_addr10_reg;
    rand uvm_reg_field mc_ecc_ce_addr10_reg_mc_ecc_ce_addr10;
    rand uvm_reg_field mc_ecc_ce_addr10;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr11_reg mc_ecc_ce_addr11_reg;
    rand uvm_reg_field mc_ecc_ce_addr11_reg_mc_ecc_ce_addr11;
    rand uvm_reg_field mc_ecc_ce_addr11;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr12_reg mc_ecc_ce_addr12_reg;
    rand uvm_reg_field mc_ecc_ce_addr12_reg_mc_ecc_ce_addr12;
    rand uvm_reg_field mc_ecc_ce_addr12;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr13_reg mc_ecc_ce_addr13_reg;
    rand uvm_reg_field mc_ecc_ce_addr13_reg_mc_ecc_ce_addr13;
    rand uvm_reg_field mc_ecc_ce_addr13;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr14_reg mc_ecc_ce_addr14_reg;
    rand uvm_reg_field mc_ecc_ce_addr14_reg_mc_ecc_ce_addr14;
    rand uvm_reg_field mc_ecc_ce_addr14;
    rand ral_reg_mc_wrapper_top_mc_ecc_ce_addr15_reg mc_ecc_ce_addr15_reg;
    rand uvm_reg_field mc_ecc_ce_addr15_reg_mc_ecc_ce_addr15;
    rand uvm_reg_field mc_ecc_ce_addr15;
    rand ral_reg_mc_wrapper_top_mc_ecc_uce_addr0_reg mc_ecc_uce_addr0_reg;
    rand uvm_reg_field mc_ecc_uce_addr0_reg_mc_ecc_uce_addr0;
    rand uvm_reg_field mc_ecc_uce_addr0;
    rand ral_reg_mc_wrapper_top_mc_ecc_uce_addr1_reg mc_ecc_uce_addr1_reg;
    rand uvm_reg_field mc_ecc_uce_addr1_reg_mc_ecc_uce_addr1;
    rand uvm_reg_field mc_ecc_uce_addr1;
    rand ral_reg_mc_wrapper_top_mc_ecc_uce_addr2_reg mc_ecc_uce_addr2_reg;
    rand uvm_reg_field mc_ecc_uce_addr2_reg_mc_ecc_uce_addr2;
    rand uvm_reg_field mc_ecc_uce_addr2;
    rand ral_reg_mc_wrapper_top_mc_ecc_uce_addr3_reg mc_ecc_uce_addr3_reg;
    rand uvm_reg_field mc_ecc_uce_addr3_reg_mc_ecc_uce_addr3;
    rand uvm_reg_field mc_ecc_uce_addr3;
    rand ral_reg_mc_wrapper_top_bist_scan_ctrl_reg bist_scan_ctrl_reg;
    rand uvm_reg_field bist_scan_ctrl_reg_bist_scan_start_bank;
    rand uvm_reg_field bist_scan_start_bank;
    rand uvm_reg_field bist_scan_ctrl_reg_bist_scan_end_bank;
    rand uvm_reg_field bist_scan_end_bank;
    rand ral_reg_mc_wrapper_top_axi2frame_dbg0_reg axi2frame_dbg0_reg;
    rand uvm_reg_field axi2frame_dbg0_reg_a2f_dbg_ar_cnt;
    rand uvm_reg_field a2f_dbg_ar_cnt;
    rand ral_reg_mc_wrapper_top_axi2frame_dbg1_reg axi2frame_dbg1_reg;
    rand uvm_reg_field axi2frame_dbg1_reg_a2f_dbg_r_cnt;
    rand uvm_reg_field a2f_dbg_r_cnt;
    rand ral_reg_mc_wrapper_top_axi2frame_dbg2_reg axi2frame_dbg2_reg;
    rand uvm_reg_field axi2frame_dbg2_reg_a2f_dbg_aw_cnt;
    rand uvm_reg_field a2f_dbg_aw_cnt;
    rand ral_reg_mc_wrapper_top_axi2frame_dbg3_reg axi2frame_dbg3_reg;
    rand uvm_reg_field axi2frame_dbg3_reg_a2f_dbg_w_cnt;
    rand uvm_reg_field a2f_dbg_w_cnt;
    rand ral_reg_mc_wrapper_top_axi2frame_dbg4_reg axi2frame_dbg4_reg;
    rand uvm_reg_field axi2frame_dbg4_reg_a2f_dbg_b_cnt;
    rand uvm_reg_field a2f_dbg_b_cnt;
    rand ral_reg_mc_wrapper_top_axi2frame_dbg5_reg axi2frame_dbg5_reg;
    rand uvm_reg_field axi2frame_dbg5_reg_a2f_dbg_axi_len_err_addr;
    rand uvm_reg_field a2f_dbg_axi_len_err_addr;
    rand ral_reg_mc_wrapper_top_axi2frame_dbg6_reg axi2frame_dbg6_reg;
    rand uvm_reg_field axi2frame_dbg6_reg_a2f_dbg_axi_len_err;
    rand uvm_reg_field a2f_dbg_axi_len_err;
    rand ral_reg_mc_wrapper_top_axi2frame_dbg7_reg axi2frame_dbg7_reg;
    rand uvm_reg_field axi2frame_dbg7_reg_a2f_dbg_reserve_in;
    rand uvm_reg_field a2f_dbg_reserve_in;
    rand ral_reg_mc_wrapper_top_axi2frame_dbg8_reg axi2frame_dbg8_reg;
    rand uvm_reg_field axi2frame_dbg8_reg_a2f_dbg_reserve_out;
    rand uvm_reg_field a2f_dbg_reserve_out;
    rand ral_reg_mc_wrapper_top_mc_page_status_reg mc_page_status_reg;
    rand uvm_reg_field mc_page_status_reg_mc_page_status;
    rand uvm_reg_field mc_page_status;
    rand ral_reg_mc_wrapper_top_hang_timeout_status_reg hang_timeout_status_reg;
    rand uvm_reg_field hang_timeout_status_reg_hang_timeout_status;
    rand uvm_reg_field hang_timeout_status;
    rand ral_reg_mc_wrapper_top_hang_timeout_mask_reg hang_timeout_mask_reg;
    rand uvm_reg_field hang_timeout_mask_reg_hang_timeout_mask;
    rand uvm_reg_field hang_timeout_mask;
    rand ral_reg_mc_wrapper_top_hang_timeout_clr_reg hang_timeout_clr_reg;
    rand uvm_reg_field hang_timeout_clr_reg_hang_timeout_clr;
    rand uvm_reg_field hang_timeout_clr;
    rand ral_reg_mc_wrapper_top_hang_timeout_en_reg hang_timeout_en_reg;
    rand uvm_reg_field hang_timeout_en_reg_hang_timeout_en;
    rand uvm_reg_field hang_timeout_en;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num0_reg mc_bank1_vmc_wl_num0_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num0_reg_mc_bank1_vmc_wl_num0;
    rand uvm_reg_field mc_bank1_vmc_wl_num0;
    rand uvm_reg_field mc_bank1_vmc_wl_num0_reg_mc_bank1_vmc_wl_num1;
    rand uvm_reg_field mc_bank1_vmc_wl_num1;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num1_reg mc_bank1_vmc_wl_num1_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num1_reg_mc_bank1_vmc_wl_num2;
    rand uvm_reg_field mc_bank1_vmc_wl_num2;
    rand uvm_reg_field mc_bank1_vmc_wl_num1_reg_mc_bank1_vmc_wl_num3;
    rand uvm_reg_field mc_bank1_vmc_wl_num3;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num2_reg mc_bank1_vmc_wl_num2_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num2_reg_mc_bank1_vmc_wl_num4;
    rand uvm_reg_field mc_bank1_vmc_wl_num4;
    rand uvm_reg_field mc_bank1_vmc_wl_num2_reg_mc_bank1_vmc_wl_num5;
    rand uvm_reg_field mc_bank1_vmc_wl_num5;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num3_reg mc_bank1_vmc_wl_num3_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num3_reg_mc_bank1_vmc_wl_num6;
    rand uvm_reg_field mc_bank1_vmc_wl_num6;
    rand uvm_reg_field mc_bank1_vmc_wl_num3_reg_mc_bank1_vmc_wl_num7;
    rand uvm_reg_field mc_bank1_vmc_wl_num7;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num4_reg mc_bank1_vmc_wl_num4_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num4_reg_mc_bank1_vmc_wl_num8;
    rand uvm_reg_field mc_bank1_vmc_wl_num8;
    rand uvm_reg_field mc_bank1_vmc_wl_num4_reg_mc_bank1_vmc_wl_num9;
    rand uvm_reg_field mc_bank1_vmc_wl_num9;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num5_reg mc_bank1_vmc_wl_num5_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num5_reg_mc_bank1_vmc_wl_num10;
    rand uvm_reg_field mc_bank1_vmc_wl_num10;
    rand uvm_reg_field mc_bank1_vmc_wl_num5_reg_mc_bank1_vmc_wl_num11;
    rand uvm_reg_field mc_bank1_vmc_wl_num11;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num6_reg mc_bank1_vmc_wl_num6_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num6_reg_mc_bank1_vmc_wl_num12;
    rand uvm_reg_field mc_bank1_vmc_wl_num12;
    rand uvm_reg_field mc_bank1_vmc_wl_num6_reg_mc_bank1_vmc_wl_num13;
    rand uvm_reg_field mc_bank1_vmc_wl_num13;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num7_reg mc_bank1_vmc_wl_num7_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num7_reg_mc_bank1_vmc_wl_num14;
    rand uvm_reg_field mc_bank1_vmc_wl_num14;
    rand uvm_reg_field mc_bank1_vmc_wl_num7_reg_mc_bank1_vmc_wl_num15;
    rand uvm_reg_field mc_bank1_vmc_wl_num15;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num8_reg mc_bank1_vmc_wl_num8_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num8_reg_mc_bank1_vmc_wl_num16;
    rand uvm_reg_field mc_bank1_vmc_wl_num16;
    rand uvm_reg_field mc_bank1_vmc_wl_num8_reg_mc_bank1_vmc_wl_num17;
    rand uvm_reg_field mc_bank1_vmc_wl_num17;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num9_reg mc_bank1_vmc_wl_num9_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num9_reg_mc_bank1_vmc_wl_num18;
    rand uvm_reg_field mc_bank1_vmc_wl_num18;
    rand uvm_reg_field mc_bank1_vmc_wl_num9_reg_mc_bank1_vmc_wl_num19;
    rand uvm_reg_field mc_bank1_vmc_wl_num19;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num10_reg mc_bank1_vmc_wl_num10_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num10_reg_mc_bank1_vmc_wl_num20;
    rand uvm_reg_field mc_bank1_vmc_wl_num20;
    rand uvm_reg_field mc_bank1_vmc_wl_num10_reg_mc_bank1_vmc_wl_num21;
    rand uvm_reg_field mc_bank1_vmc_wl_num21;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num11_reg mc_bank1_vmc_wl_num11_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num11_reg_mc_bank1_vmc_wl_num22;
    rand uvm_reg_field mc_bank1_vmc_wl_num22;
    rand uvm_reg_field mc_bank1_vmc_wl_num11_reg_mc_bank1_vmc_wl_num23;
    rand uvm_reg_field mc_bank1_vmc_wl_num23;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num12_reg mc_bank1_vmc_wl_num12_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num12_reg_mc_bank1_vmc_wl_num24;
    rand uvm_reg_field mc_bank1_vmc_wl_num24;
    rand uvm_reg_field mc_bank1_vmc_wl_num12_reg_mc_bank1_vmc_wl_num25;
    rand uvm_reg_field mc_bank1_vmc_wl_num25;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num13_reg mc_bank1_vmc_wl_num13_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num13_reg_mc_bank1_vmc_wl_num26;
    rand uvm_reg_field mc_bank1_vmc_wl_num26;
    rand uvm_reg_field mc_bank1_vmc_wl_num13_reg_mc_bank1_vmc_wl_num27;
    rand uvm_reg_field mc_bank1_vmc_wl_num27;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num14_reg mc_bank1_vmc_wl_num14_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num14_reg_mc_bank1_vmc_wl_num28;
    rand uvm_reg_field mc_bank1_vmc_wl_num28;
    rand uvm_reg_field mc_bank1_vmc_wl_num14_reg_mc_bank1_vmc_wl_num29;
    rand uvm_reg_field mc_bank1_vmc_wl_num29;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num15_reg mc_bank1_vmc_wl_num15_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num15_reg_mc_bank1_vmc_wl_num30;
    rand uvm_reg_field mc_bank1_vmc_wl_num30;
    rand uvm_reg_field mc_bank1_vmc_wl_num15_reg_mc_bank1_vmc_wl_num31;
    rand uvm_reg_field mc_bank1_vmc_wl_num31;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num16_reg mc_bank1_vmc_wl_num16_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num16_reg_mc_bank1_vmc_wl_num32;
    rand uvm_reg_field mc_bank1_vmc_wl_num32;
    rand uvm_reg_field mc_bank1_vmc_wl_num16_reg_mc_bank1_vmc_wl_num33;
    rand uvm_reg_field mc_bank1_vmc_wl_num33;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num17_reg mc_bank1_vmc_wl_num17_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num17_reg_mc_bank1_vmc_wl_num34;
    rand uvm_reg_field mc_bank1_vmc_wl_num34;
    rand uvm_reg_field mc_bank1_vmc_wl_num17_reg_mc_bank1_vmc_wl_num35;
    rand uvm_reg_field mc_bank1_vmc_wl_num35;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num18_reg mc_bank1_vmc_wl_num18_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num18_reg_mc_bank1_vmc_wl_num36;
    rand uvm_reg_field mc_bank1_vmc_wl_num36;
    rand uvm_reg_field mc_bank1_vmc_wl_num18_reg_mc_bank1_vmc_wl_num37;
    rand uvm_reg_field mc_bank1_vmc_wl_num37;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num19_reg mc_bank1_vmc_wl_num19_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num19_reg_mc_bank1_vmc_wl_num38;
    rand uvm_reg_field mc_bank1_vmc_wl_num38;
    rand uvm_reg_field mc_bank1_vmc_wl_num19_reg_mc_bank1_vmc_wl_num39;
    rand uvm_reg_field mc_bank1_vmc_wl_num39;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num20_reg mc_bank1_vmc_wl_num20_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num20_reg_mc_bank1_vmc_wl_num40;
    rand uvm_reg_field mc_bank1_vmc_wl_num40;
    rand uvm_reg_field mc_bank1_vmc_wl_num20_reg_mc_bank1_vmc_wl_num41;
    rand uvm_reg_field mc_bank1_vmc_wl_num41;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num21_reg mc_bank1_vmc_wl_num21_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num21_reg_mc_bank1_vmc_wl_num42;
    rand uvm_reg_field mc_bank1_vmc_wl_num42;
    rand uvm_reg_field mc_bank1_vmc_wl_num21_reg_mc_bank1_vmc_wl_num43;
    rand uvm_reg_field mc_bank1_vmc_wl_num43;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num22_reg mc_bank1_vmc_wl_num22_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num22_reg_mc_bank1_vmc_wl_num44;
    rand uvm_reg_field mc_bank1_vmc_wl_num44;
    rand uvm_reg_field mc_bank1_vmc_wl_num22_reg_mc_bank1_vmc_wl_num45;
    rand uvm_reg_field mc_bank1_vmc_wl_num45;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num23_reg mc_bank1_vmc_wl_num23_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num23_reg_mc_bank1_vmc_wl_num46;
    rand uvm_reg_field mc_bank1_vmc_wl_num46;
    rand uvm_reg_field mc_bank1_vmc_wl_num23_reg_mc_bank1_vmc_wl_num47;
    rand uvm_reg_field mc_bank1_vmc_wl_num47;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num24_reg mc_bank1_vmc_wl_num24_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num24_reg_mc_bank1_vmc_wl_num48;
    rand uvm_reg_field mc_bank1_vmc_wl_num48;
    rand uvm_reg_field mc_bank1_vmc_wl_num24_reg_mc_bank1_vmc_wl_num49;
    rand uvm_reg_field mc_bank1_vmc_wl_num49;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num25_reg mc_bank1_vmc_wl_num25_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num25_reg_mc_bank1_vmc_wl_num50;
    rand uvm_reg_field mc_bank1_vmc_wl_num50;
    rand uvm_reg_field mc_bank1_vmc_wl_num25_reg_mc_bank1_vmc_wl_num51;
    rand uvm_reg_field mc_bank1_vmc_wl_num51;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num26_reg mc_bank1_vmc_wl_num26_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num26_reg_mc_bank1_vmc_wl_num52;
    rand uvm_reg_field mc_bank1_vmc_wl_num52;
    rand uvm_reg_field mc_bank1_vmc_wl_num26_reg_mc_bank1_vmc_wl_num53;
    rand uvm_reg_field mc_bank1_vmc_wl_num53;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num27_reg mc_bank1_vmc_wl_num27_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num27_reg_mc_bank1_vmc_wl_num54;
    rand uvm_reg_field mc_bank1_vmc_wl_num54;
    rand uvm_reg_field mc_bank1_vmc_wl_num27_reg_mc_bank1_vmc_wl_num55;
    rand uvm_reg_field mc_bank1_vmc_wl_num55;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num28_reg mc_bank1_vmc_wl_num28_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num28_reg_mc_bank1_vmc_wl_num56;
    rand uvm_reg_field mc_bank1_vmc_wl_num56;
    rand uvm_reg_field mc_bank1_vmc_wl_num28_reg_mc_bank1_vmc_wl_num57;
    rand uvm_reg_field mc_bank1_vmc_wl_num57;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num29_reg mc_bank1_vmc_wl_num29_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num29_reg_mc_bank1_vmc_wl_num58;
    rand uvm_reg_field mc_bank1_vmc_wl_num58;
    rand uvm_reg_field mc_bank1_vmc_wl_num29_reg_mc_bank1_vmc_wl_num59;
    rand uvm_reg_field mc_bank1_vmc_wl_num59;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num30_reg mc_bank1_vmc_wl_num30_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num30_reg_mc_bank1_vmc_wl_num60;
    rand uvm_reg_field mc_bank1_vmc_wl_num60;
    rand uvm_reg_field mc_bank1_vmc_wl_num30_reg_mc_bank1_vmc_wl_num61;
    rand uvm_reg_field mc_bank1_vmc_wl_num61;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num31_reg mc_bank1_vmc_wl_num31_reg;
    rand uvm_reg_field mc_bank1_vmc_wl_num31_reg_mc_bank1_vmc_wl_num62;
    rand uvm_reg_field mc_bank1_vmc_wl_num62;
    rand uvm_reg_field mc_bank1_vmc_wl_num31_reg_mc_bank1_vmc_wl_num63;
    rand uvm_reg_field mc_bank1_vmc_wl_num63;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num0_reg mc_bank1_vmc_bl_num0_reg;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_reg_mc_bank1_vmc_bl_num0_part0;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part0;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_reg_mc_bank1_vmc_bl_num1_part0;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part0;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_reg_mc_bank1_vmc_bl_num0_part1;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part1;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_reg_mc_bank1_vmc_bl_num1_part1;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part1;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num1_reg mc_bank1_vmc_bl_num1_reg;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_reg_mc_bank1_vmc_bl_num0_part2;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part2;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_reg_mc_bank1_vmc_bl_num1_part2;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part2;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_reg_mc_bank1_vmc_bl_num0_part3;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part3;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_reg_mc_bank1_vmc_bl_num1_part3;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part3;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num2_reg mc_bank1_vmc_bl_num2_reg;
    rand uvm_reg_field mc_bank1_vmc_bl_num2_reg_mc_bank1_vmc_bl_num0_part4;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part4;
    rand uvm_reg_field mc_bank1_vmc_bl_num2_reg_mc_bank1_vmc_bl_num1_part4;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part4;
    rand uvm_reg_field mc_bank1_vmc_bl_num2_reg_mc_bank1_vmc_bl_num0_part5;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part5;
    rand uvm_reg_field mc_bank1_vmc_bl_num2_reg_mc_bank1_vmc_bl_num1_part5;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part5;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num3_reg mc_bank1_vmc_bl_num3_reg;
    rand uvm_reg_field mc_bank1_vmc_bl_num3_reg_mc_bank1_vmc_bl_num0_part6;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part6;
    rand uvm_reg_field mc_bank1_vmc_bl_num3_reg_mc_bank1_vmc_bl_num1_part6;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part6;
    rand uvm_reg_field mc_bank1_vmc_bl_num3_reg_mc_bank1_vmc_bl_num0_part7;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part7;
    rand uvm_reg_field mc_bank1_vmc_bl_num3_reg_mc_bank1_vmc_bl_num1_part7;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part7;
    rand ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num4_reg mc_bank1_vmc_bl_num4_reg;
    rand uvm_reg_field mc_bank1_vmc_bl_num4_reg_mc_bank1_vmc_bl_num0_part8;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part8;
    rand uvm_reg_field mc_bank1_vmc_bl_num4_reg_mc_bank1_vmc_bl_num1_part8;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part8;
    rand uvm_reg_field mc_bank1_vmc_bl_num4_reg_mc_bank1_vmc_bl_num0_part9;
    rand uvm_reg_field mc_bank1_vmc_bl_num0_part9;
    rand uvm_reg_field mc_bank1_vmc_bl_num4_reg_mc_bank1_vmc_bl_num1_part9;
    rand uvm_reg_field mc_bank1_vmc_bl_num1_part9;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num0_reg bank1_err_wl_num0_reg;
    rand uvm_reg_field bank1_err_wl_num0_reg_bank1_err_wl0;
    rand uvm_reg_field bank1_err_wl0;
    rand uvm_reg_field bank1_err_wl_num0_reg_bank1_err_wl1;
    rand uvm_reg_field bank1_err_wl1;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num1_reg bank1_err_wl_num1_reg;
    rand uvm_reg_field bank1_err_wl_num1_reg_bank1_err_wl2;
    rand uvm_reg_field bank1_err_wl2;
    rand uvm_reg_field bank1_err_wl_num1_reg_bank1_err_wl3;
    rand uvm_reg_field bank1_err_wl3;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num2_reg bank1_err_wl_num2_reg;
    rand uvm_reg_field bank1_err_wl_num2_reg_bank1_err_wl4;
    rand uvm_reg_field bank1_err_wl4;
    rand uvm_reg_field bank1_err_wl_num2_reg_bank1_err_wl5;
    rand uvm_reg_field bank1_err_wl5;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num3_reg bank1_err_wl_num3_reg;
    rand uvm_reg_field bank1_err_wl_num3_reg_bank1_err_wl6;
    rand uvm_reg_field bank1_err_wl6;
    rand uvm_reg_field bank1_err_wl_num3_reg_bank1_err_wl7;
    rand uvm_reg_field bank1_err_wl7;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num4_reg bank1_err_wl_num4_reg;
    rand uvm_reg_field bank1_err_wl_num4_reg_bank1_err_wl8;
    rand uvm_reg_field bank1_err_wl8;
    rand uvm_reg_field bank1_err_wl_num4_reg_bank1_err_wl9;
    rand uvm_reg_field bank1_err_wl9;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num5_reg bank1_err_wl_num5_reg;
    rand uvm_reg_field bank1_err_wl_num5_reg_bank1_err_wl10;
    rand uvm_reg_field bank1_err_wl10;
    rand uvm_reg_field bank1_err_wl_num5_reg_bank1_err_wl11;
    rand uvm_reg_field bank1_err_wl11;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num6_reg bank1_err_wl_num6_reg;
    rand uvm_reg_field bank1_err_wl_num6_reg_bank1_err_wl12;
    rand uvm_reg_field bank1_err_wl12;
    rand uvm_reg_field bank1_err_wl_num6_reg_bank1_err_wl13;
    rand uvm_reg_field bank1_err_wl13;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num7_reg bank1_err_wl_num7_reg;
    rand uvm_reg_field bank1_err_wl_num7_reg_bank1_err_wl14;
    rand uvm_reg_field bank1_err_wl14;
    rand uvm_reg_field bank1_err_wl_num7_reg_bank1_err_wl15;
    rand uvm_reg_field bank1_err_wl15;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num8_reg bank1_err_wl_num8_reg;
    rand uvm_reg_field bank1_err_wl_num8_reg_bank1_err_wl16;
    rand uvm_reg_field bank1_err_wl16;
    rand uvm_reg_field bank1_err_wl_num8_reg_bank1_err_wl17;
    rand uvm_reg_field bank1_err_wl17;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num9_reg bank1_err_wl_num9_reg;
    rand uvm_reg_field bank1_err_wl_num9_reg_bank1_err_wl18;
    rand uvm_reg_field bank1_err_wl18;
    rand uvm_reg_field bank1_err_wl_num9_reg_bank1_err_wl19;
    rand uvm_reg_field bank1_err_wl19;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num10_reg bank1_err_wl_num10_reg;
    rand uvm_reg_field bank1_err_wl_num10_reg_bank1_err_wl20;
    rand uvm_reg_field bank1_err_wl20;
    rand uvm_reg_field bank1_err_wl_num10_reg_bank1_err_wl21;
    rand uvm_reg_field bank1_err_wl21;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num11_reg bank1_err_wl_num11_reg;
    rand uvm_reg_field bank1_err_wl_num11_reg_bank1_err_wl22;
    rand uvm_reg_field bank1_err_wl22;
    rand uvm_reg_field bank1_err_wl_num11_reg_bank1_err_wl23;
    rand uvm_reg_field bank1_err_wl23;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num12_reg bank1_err_wl_num12_reg;
    rand uvm_reg_field bank1_err_wl_num12_reg_bank1_err_wl24;
    rand uvm_reg_field bank1_err_wl24;
    rand uvm_reg_field bank1_err_wl_num12_reg_bank1_err_wl25;
    rand uvm_reg_field bank1_err_wl25;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num13_reg bank1_err_wl_num13_reg;
    rand uvm_reg_field bank1_err_wl_num13_reg_bank1_err_wl26;
    rand uvm_reg_field bank1_err_wl26;
    rand uvm_reg_field bank1_err_wl_num13_reg_bank1_err_wl27;
    rand uvm_reg_field bank1_err_wl27;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num14_reg bank1_err_wl_num14_reg;
    rand uvm_reg_field bank1_err_wl_num14_reg_bank1_err_wl28;
    rand uvm_reg_field bank1_err_wl28;
    rand uvm_reg_field bank1_err_wl_num14_reg_bank1_err_wl29;
    rand uvm_reg_field bank1_err_wl29;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num15_reg bank1_err_wl_num15_reg;
    rand uvm_reg_field bank1_err_wl_num15_reg_bank1_err_wl30;
    rand uvm_reg_field bank1_err_wl30;
    rand uvm_reg_field bank1_err_wl_num15_reg_bank1_err_wl31;
    rand uvm_reg_field bank1_err_wl31;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num16_reg bank1_err_wl_num16_reg;
    rand uvm_reg_field bank1_err_wl_num16_reg_bank1_err_wl32;
    rand uvm_reg_field bank1_err_wl32;
    rand uvm_reg_field bank1_err_wl_num16_reg_bank1_err_wl33;
    rand uvm_reg_field bank1_err_wl33;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num17_reg bank1_err_wl_num17_reg;
    rand uvm_reg_field bank1_err_wl_num17_reg_bank1_err_wl34;
    rand uvm_reg_field bank1_err_wl34;
    rand uvm_reg_field bank1_err_wl_num17_reg_bank1_err_wl35;
    rand uvm_reg_field bank1_err_wl35;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num18_reg bank1_err_wl_num18_reg;
    rand uvm_reg_field bank1_err_wl_num18_reg_bank1_err_wl36;
    rand uvm_reg_field bank1_err_wl36;
    rand uvm_reg_field bank1_err_wl_num18_reg_bank1_err_wl37;
    rand uvm_reg_field bank1_err_wl37;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num19_reg bank1_err_wl_num19_reg;
    rand uvm_reg_field bank1_err_wl_num19_reg_bank1_err_wl38;
    rand uvm_reg_field bank1_err_wl38;
    rand uvm_reg_field bank1_err_wl_num19_reg_bank1_err_wl39;
    rand uvm_reg_field bank1_err_wl39;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num20_reg bank1_err_wl_num20_reg;
    rand uvm_reg_field bank1_err_wl_num20_reg_bank1_err_wl40;
    rand uvm_reg_field bank1_err_wl40;
    rand uvm_reg_field bank1_err_wl_num20_reg_bank1_err_wl41;
    rand uvm_reg_field bank1_err_wl41;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num21_reg bank1_err_wl_num21_reg;
    rand uvm_reg_field bank1_err_wl_num21_reg_bank1_err_wl42;
    rand uvm_reg_field bank1_err_wl42;
    rand uvm_reg_field bank1_err_wl_num21_reg_bank1_err_wl43;
    rand uvm_reg_field bank1_err_wl43;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num22_reg bank1_err_wl_num22_reg;
    rand uvm_reg_field bank1_err_wl_num22_reg_bank1_err_wl44;
    rand uvm_reg_field bank1_err_wl44;
    rand uvm_reg_field bank1_err_wl_num22_reg_bank1_err_wl45;
    rand uvm_reg_field bank1_err_wl45;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num23_reg bank1_err_wl_num23_reg;
    rand uvm_reg_field bank1_err_wl_num23_reg_bank1_err_wl46;
    rand uvm_reg_field bank1_err_wl46;
    rand uvm_reg_field bank1_err_wl_num23_reg_bank1_err_wl47;
    rand uvm_reg_field bank1_err_wl47;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num24_reg bank1_err_wl_num24_reg;
    rand uvm_reg_field bank1_err_wl_num24_reg_bank1_err_wl48;
    rand uvm_reg_field bank1_err_wl48;
    rand uvm_reg_field bank1_err_wl_num24_reg_bank1_err_wl49;
    rand uvm_reg_field bank1_err_wl49;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num25_reg bank1_err_wl_num25_reg;
    rand uvm_reg_field bank1_err_wl_num25_reg_bank1_err_wl50;
    rand uvm_reg_field bank1_err_wl50;
    rand uvm_reg_field bank1_err_wl_num25_reg_bank1_err_wl51;
    rand uvm_reg_field bank1_err_wl51;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num26_reg bank1_err_wl_num26_reg;
    rand uvm_reg_field bank1_err_wl_num26_reg_bank1_err_wl52;
    rand uvm_reg_field bank1_err_wl52;
    rand uvm_reg_field bank1_err_wl_num26_reg_bank1_err_wl53;
    rand uvm_reg_field bank1_err_wl53;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num27_reg bank1_err_wl_num27_reg;
    rand uvm_reg_field bank1_err_wl_num27_reg_bank1_err_wl54;
    rand uvm_reg_field bank1_err_wl54;
    rand uvm_reg_field bank1_err_wl_num27_reg_bank1_err_wl55;
    rand uvm_reg_field bank1_err_wl55;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num28_reg bank1_err_wl_num28_reg;
    rand uvm_reg_field bank1_err_wl_num28_reg_bank1_err_wl56;
    rand uvm_reg_field bank1_err_wl56;
    rand uvm_reg_field bank1_err_wl_num28_reg_bank1_err_wl57;
    rand uvm_reg_field bank1_err_wl57;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num29_reg bank1_err_wl_num29_reg;
    rand uvm_reg_field bank1_err_wl_num29_reg_bank1_err_wl58;
    rand uvm_reg_field bank1_err_wl58;
    rand uvm_reg_field bank1_err_wl_num29_reg_bank1_err_wl59;
    rand uvm_reg_field bank1_err_wl59;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num30_reg bank1_err_wl_num30_reg;
    rand uvm_reg_field bank1_err_wl_num30_reg_bank1_err_wl60;
    rand uvm_reg_field bank1_err_wl60;
    rand uvm_reg_field bank1_err_wl_num30_reg_bank1_err_wl61;
    rand uvm_reg_field bank1_err_wl61;
    rand ral_reg_mc_wrapper_top_bank1_err_wl_num31_reg bank1_err_wl_num31_reg;
    rand uvm_reg_field bank1_err_wl_num31_reg_bank1_err_wl62;
    rand uvm_reg_field bank1_err_wl62;
    rand uvm_reg_field bank1_err_wl_num31_reg_bank1_err_wl63;
    rand uvm_reg_field bank1_err_wl63;
    rand ral_reg_mc_wrapper_top_bank1_err_csl0_part0_reg bank1_err_csl0_part0_reg;
    rand uvm_reg_field bank1_err_csl0_part0_reg_bank1_err_csl0_part0;
    rand uvm_reg_field bank1_err_csl0_part0;
    rand ral_reg_mc_wrapper_top_bank1_err_csl1_part0_reg bank1_err_csl1_part0_reg;
    rand uvm_reg_field bank1_err_csl1_part0_reg_bank1_err_csl1_part0;
    rand uvm_reg_field bank1_err_csl1_part0;
    rand ral_reg_mc_wrapper_top_bank1_err_csl0_part1_reg bank1_err_csl0_part1_reg;
    rand uvm_reg_field bank1_err_csl0_part1_reg_bank1_err_csl0_part1;
    rand uvm_reg_field bank1_err_csl0_part1;
    rand ral_reg_mc_wrapper_top_bank1_err_csl1_part1_reg bank1_err_csl1_part1_reg;
    rand uvm_reg_field bank1_err_csl1_part1_reg_bank1_err_csl1_part1;
    rand uvm_reg_field bank1_err_csl1_part1;
    rand ral_reg_mc_wrapper_top_bank1_err_csl0_part2_reg bank1_err_csl0_part2_reg;
    rand uvm_reg_field bank1_err_csl0_part2_reg_bank1_err_csl0_part2;
    rand uvm_reg_field bank1_err_csl0_part2;
    rand ral_reg_mc_wrapper_top_bank1_err_csl1_part2_reg bank1_err_csl1_part2_reg;
    rand uvm_reg_field bank1_err_csl1_part2_reg_bank1_err_csl1_part2;
    rand uvm_reg_field bank1_err_csl1_part2;
    rand ral_reg_mc_wrapper_top_bank1_err_csl0_part3_reg bank1_err_csl0_part3_reg;
    rand uvm_reg_field bank1_err_csl0_part3_reg_bank1_err_csl0_part3;
    rand uvm_reg_field bank1_err_csl0_part3;
    rand ral_reg_mc_wrapper_top_bank1_err_csl1_part3_reg bank1_err_csl1_part3_reg;
    rand uvm_reg_field bank1_err_csl1_part3_reg_bank1_err_csl1_part3;
    rand uvm_reg_field bank1_err_csl1_part3;
    rand ral_reg_mc_wrapper_top_bank1_err_csl0_part4_reg bank1_err_csl0_part4_reg;
    rand uvm_reg_field bank1_err_csl0_part4_reg_bank1_err_csl0_part4;
    rand uvm_reg_field bank1_err_csl0_part4;
    rand ral_reg_mc_wrapper_top_bank1_err_csl1_part4_reg bank1_err_csl1_part4_reg;
    rand uvm_reg_field bank1_err_csl1_part4_reg_bank1_err_csl1_part4;
    rand uvm_reg_field bank1_err_csl1_part4;
    rand ral_reg_mc_wrapper_top_bank1_err_csl0_part5_reg bank1_err_csl0_part5_reg;
    rand uvm_reg_field bank1_err_csl0_part5_reg_bank1_err_csl0_part5;
    rand uvm_reg_field bank1_err_csl0_part5;
    rand ral_reg_mc_wrapper_top_bank1_err_csl1_part5_reg bank1_err_csl1_part5_reg;
    rand uvm_reg_field bank1_err_csl1_part5_reg_bank1_err_csl1_part5;
    rand uvm_reg_field bank1_err_csl1_part5;
    rand ral_reg_mc_wrapper_top_bank1_err_csl0_part6_reg bank1_err_csl0_part6_reg;
    rand uvm_reg_field bank1_err_csl0_part6_reg_bank1_err_csl0_part6;
    rand uvm_reg_field bank1_err_csl0_part6;
    rand ral_reg_mc_wrapper_top_bank1_err_csl1_part6_reg bank1_err_csl1_part6_reg;
    rand uvm_reg_field bank1_err_csl1_part6_reg_bank1_err_csl1_part6;
    rand uvm_reg_field bank1_err_csl1_part6;
    rand ral_reg_mc_wrapper_top_bank1_err_csl0_part7_reg bank1_err_csl0_part7_reg;
    rand uvm_reg_field bank1_err_csl0_part7_reg_bank1_err_csl0_part7;
    rand uvm_reg_field bank1_err_csl0_part7;
    rand ral_reg_mc_wrapper_top_bank1_err_csl1_part7_reg bank1_err_csl1_part7_reg;
    rand uvm_reg_field bank1_err_csl1_part7_reg_bank1_err_csl1_part7;
    rand uvm_reg_field bank1_err_csl1_part7;
    rand ral_reg_mc_wrapper_top_bank1_err_csl0_part8_reg bank1_err_csl0_part8_reg;
    rand uvm_reg_field bank1_err_csl0_part8_reg_bank1_err_csl0_part8;
    rand uvm_reg_field bank1_err_csl0_part8;
    rand ral_reg_mc_wrapper_top_bank1_err_csl1_part8_reg bank1_err_csl1_part8_reg;
    rand uvm_reg_field bank1_err_csl1_part8_reg_bank1_err_csl1_part8;
    rand uvm_reg_field bank1_err_csl1_part8;
    rand ral_reg_mc_wrapper_top_bank1_err_csl0_part9_reg bank1_err_csl0_part9_reg;
    rand uvm_reg_field bank1_err_csl0_part9_reg_bank1_err_csl0_part9;
    rand uvm_reg_field bank1_err_csl0_part9;
    rand ral_reg_mc_wrapper_top_bank1_err_csl1_part9_reg bank1_err_csl1_part9_reg;
    rand uvm_reg_field bank1_err_csl1_part9_reg_bank1_err_csl1_part9;
    rand uvm_reg_field bank1_err_csl1_part9;
    rand ral_reg_mc_wrapper_top_mc_bank1_bist_rescan_fail_num_reg mc_bank1_bist_rescan_fail_num_reg;
    rand uvm_reg_field mc_bank1_bist_rescan_fail_num_reg_mc_bank1_bist_rescan_fail_num;
    rand uvm_reg_field mc_bank1_bist_rescan_fail_num;
    rand ral_reg_mc_wrapper_top_mc_bank1_bist_err_wl_reg mc_bank1_bist_err_wl_reg;
    rand uvm_reg_field mc_bank1_bist_err_wl_reg_mc_bank1_bist_err_wl_num;
    rand uvm_reg_field mc_bank1_bist_err_wl_num;
    rand uvm_reg_field mc_bank1_bist_err_wl_reg_err_bank1_wl_num_change_flag;
    rand uvm_reg_field err_bank1_wl_num_change_flag;
    rand ral_reg_mc_wrapper_top_bank1_rescan_round_result_reg bank1_rescan_round_result_reg;
    rand uvm_reg_field bank1_rescan_round_result_reg_bank1_rescan_round_result;
    rand uvm_reg_field bank1_rescan_round_result;

    function new(string name = "ral_block_mc_wrapper_top");
        super.new(name,build_coverage(UVM_NO_COVERAGE));
    endfunction: new


    virtual function void build();
        this.default_map = create_map("",0,4,UVM_LITTLE_ENDIAN, 0);

        this.mc_id_reg = ral_reg_mc_wrapper_top_mc_id_reg::type_id::create("mc_id_reg",,get_full_name());
        this.mc_id_reg.configure(this, null, "");
        this.mc_id_reg.build();
        this.default_map.add_reg(this.mc_id_reg, `UVM_REG_ADDR_WIDTH'h0,"RW",0);
            this.mc_id_reg_mc_id = this.mc_id_reg.mc_id;
            this.mc_id = this.mc_id_reg.mc_id;

        this.mc_work_ctrl_reg = ral_reg_mc_wrapper_top_mc_work_ctrl_reg::type_id::create("mc_work_ctrl_reg",,get_full_name());
        this.mc_work_ctrl_reg.configure(this, null, "");
        this.mc_work_ctrl_reg.build();
        this.default_map.add_reg(this.mc_work_ctrl_reg, `UVM_REG_ADDR_WIDTH'h4,"RW",0);
            this.mc_work_ctrl_reg_mc_en = this.mc_work_ctrl_reg.mc_en;
            this.mc_en = this.mc_work_ctrl_reg.mc_en;

            this.mc_work_ctrl_reg_mc_rf_cfg_sel = this.mc_work_ctrl_reg.mc_rf_cfg_sel;
            this.mc_rf_cfg_sel = this.mc_work_ctrl_reg.mc_rf_cfg_sel;

            this.mc_work_ctrl_reg_mc_debug_en = this.mc_work_ctrl_reg.mc_debug_en;
            this.mc_debug_en = this.mc_work_ctrl_reg.mc_debug_en;

            this.mc_work_ctrl_reg_mc_wl_vmc_en = this.mc_work_ctrl_reg.mc_wl_vmc_en;
            this.mc_wl_vmc_en = this.mc_work_ctrl_reg.mc_wl_vmc_en;

            this.mc_work_ctrl_reg_mc_bl_vmc_en = this.mc_work_ctrl_reg.mc_bl_vmc_en;
            this.mc_bl_vmc_en = this.mc_work_ctrl_reg.mc_bl_vmc_en;

            this.mc_work_ctrl_reg_mc_bist_en = this.mc_work_ctrl_reg.mc_bist_en;
            this.mc_bist_en = this.mc_work_ctrl_reg.mc_bist_en;

            this.mc_work_ctrl_reg_mc_rescan_addr_range_sel = this.mc_work_ctrl_reg.mc_rescan_addr_range_sel;
            this.mc_rescan_addr_range_sel = this.mc_work_ctrl_reg.mc_rescan_addr_range_sel;

            this.mc_work_ctrl_reg_mc_csl_scan_addr_range_sel = this.mc_work_ctrl_reg.mc_csl_scan_addr_range_sel;
            this.mc_csl_scan_addr_range_sel = this.mc_work_ctrl_reg.mc_csl_scan_addr_range_sel;

            this.mc_work_ctrl_reg_mc_csl_scan_check_sel = this.mc_work_ctrl_reg.mc_csl_scan_check_sel;
            this.mc_csl_scan_check_sel = this.mc_work_ctrl_reg.mc_csl_scan_check_sel;

            this.mc_work_ctrl_reg_mc_csl_scan_mode_sel = this.mc_work_ctrl_reg.mc_csl_scan_mode_sel;
            this.mc_csl_scan_mode_sel = this.mc_work_ctrl_reg.mc_csl_scan_mode_sel;

        this.phy_timing_cfg0_reg = ral_reg_mc_wrapper_top_phy_timing_cfg0_reg::type_id::create("phy_timing_cfg0_reg",,get_full_name());
        this.phy_timing_cfg0_reg.configure(this, null, "");
        this.phy_timing_cfg0_reg.build();
        this.default_map.add_reg(this.phy_timing_cfg0_reg, `UVM_REG_ADDR_WIDTH'h8,"RW",0);
            this.phy_timing_cfg0_reg_bank_radd_set_time = this.phy_timing_cfg0_reg.bank_radd_set_time;
            this.bank_radd_set_time = this.phy_timing_cfg0_reg.bank_radd_set_time;

            this.phy_timing_cfg0_reg_cadd_set_time = this.phy_timing_cfg0_reg.cadd_set_time;
            this.cadd_set_time = this.phy_timing_cfg0_reg.cadd_set_time;

            this.phy_timing_cfg0_reg_r_cas_set_time = this.phy_timing_cfg0_reg.r_cas_set_time;
            this.r_cas_set_time = this.phy_timing_cfg0_reg.r_cas_set_time;

            this.phy_timing_cfg0_reg_w_cas_set_time = this.phy_timing_cfg0_reg.w_cas_set_time;
            this.w_cas_set_time = this.phy_timing_cfg0_reg.w_cas_set_time;

            this.phy_timing_cfg0_reg_cas_wrrdy_time = this.phy_timing_cfg0_reg.cas_wrrdy_time;
            this.cas_wrrdy_time = this.phy_timing_cfg0_reg.cas_wrrdy_time;

        this.mc_rf_period_cfg1_reg = ral_reg_mc_wrapper_top_mc_rf_period_cfg1_reg::type_id::create("mc_rf_period_cfg1_reg",,get_full_name());
        this.mc_rf_period_cfg1_reg.configure(this, null, "");
        this.mc_rf_period_cfg1_reg.build();
        this.default_map.add_reg(this.mc_rf_period_cfg1_reg, `UVM_REG_ADDR_WIDTH'hc,"RW",0);
            this.mc_rf_period_cfg1_reg_mc_rf_period_1 = this.mc_rf_period_cfg1_reg.mc_rf_period_1;
            this.mc_rf_period_1 = this.mc_rf_period_cfg1_reg.mc_rf_period_1;

        this.mc_rf_start_cfg1_reg = ral_reg_mc_wrapper_top_mc_rf_start_cfg1_reg::type_id::create("mc_rf_start_cfg1_reg",,get_full_name());
        this.mc_rf_start_cfg1_reg.configure(this, null, "");
        this.mc_rf_start_cfg1_reg.build();
        this.default_map.add_reg(this.mc_rf_start_cfg1_reg, `UVM_REG_ADDR_WIDTH'h10,"RW",0);
            this.mc_rf_start_cfg1_reg_mc_rf_start_1 = this.mc_rf_start_cfg1_reg.mc_rf_start_1;
            this.mc_rf_start_1 = this.mc_rf_start_cfg1_reg.mc_rf_start_1;

        this.mc_rf_period_cfg2_reg = ral_reg_mc_wrapper_top_mc_rf_period_cfg2_reg::type_id::create("mc_rf_period_cfg2_reg",,get_full_name());
        this.mc_rf_period_cfg2_reg.configure(this, null, "");
        this.mc_rf_period_cfg2_reg.build();
        this.default_map.add_reg(this.mc_rf_period_cfg2_reg, `UVM_REG_ADDR_WIDTH'h14,"RW",0);
            this.mc_rf_period_cfg2_reg_mc_rf_period_2 = this.mc_rf_period_cfg2_reg.mc_rf_period_2;
            this.mc_rf_period_2 = this.mc_rf_period_cfg2_reg.mc_rf_period_2;

        this.mc_rf_start_cfg2_reg = ral_reg_mc_wrapper_top_mc_rf_start_cfg2_reg::type_id::create("mc_rf_start_cfg2_reg",,get_full_name());
        this.mc_rf_start_cfg2_reg.configure(this, null, "");
        this.mc_rf_start_cfg2_reg.build();
        this.default_map.add_reg(this.mc_rf_start_cfg2_reg, `UVM_REG_ADDR_WIDTH'h18,"RW",0);
            this.mc_rf_start_cfg2_reg_mc_rf_start_2 = this.mc_rf_start_cfg2_reg.mc_rf_start_2;
            this.mc_rf_start_2 = this.mc_rf_start_cfg2_reg.mc_rf_start_2;

        this.mc_vmc_wl_num0_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num0_reg::type_id::create("mc_vmc_wl_num0_reg",,get_full_name());
        this.mc_vmc_wl_num0_reg.configure(this, null, "");
        this.mc_vmc_wl_num0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num0_reg, `UVM_REG_ADDR_WIDTH'h1c,"RW",0);
            this.mc_vmc_wl_num0_reg_mc_vmc_wl_num0 = this.mc_vmc_wl_num0_reg.mc_vmc_wl_num0;
            this.mc_vmc_wl_num0 = this.mc_vmc_wl_num0_reg.mc_vmc_wl_num0;

            this.mc_vmc_wl_num0_reg_mc_vmc_wl_num1 = this.mc_vmc_wl_num0_reg.mc_vmc_wl_num1;
            this.mc_vmc_wl_num1 = this.mc_vmc_wl_num0_reg.mc_vmc_wl_num1;

        this.mc_vmc_wl_num1_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num1_reg::type_id::create("mc_vmc_wl_num1_reg",,get_full_name());
        this.mc_vmc_wl_num1_reg.configure(this, null, "");
        this.mc_vmc_wl_num1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num1_reg, `UVM_REG_ADDR_WIDTH'h20,"RW",0);
            this.mc_vmc_wl_num1_reg_mc_vmc_wl_num2 = this.mc_vmc_wl_num1_reg.mc_vmc_wl_num2;
            this.mc_vmc_wl_num2 = this.mc_vmc_wl_num1_reg.mc_vmc_wl_num2;

            this.mc_vmc_wl_num1_reg_mc_vmc_wl_num3 = this.mc_vmc_wl_num1_reg.mc_vmc_wl_num3;
            this.mc_vmc_wl_num3 = this.mc_vmc_wl_num1_reg.mc_vmc_wl_num3;

        this.mc_vmc_wl_num2_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num2_reg::type_id::create("mc_vmc_wl_num2_reg",,get_full_name());
        this.mc_vmc_wl_num2_reg.configure(this, null, "");
        this.mc_vmc_wl_num2_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num2_reg, `UVM_REG_ADDR_WIDTH'h24,"RW",0);
            this.mc_vmc_wl_num2_reg_mc_vmc_wl_num4 = this.mc_vmc_wl_num2_reg.mc_vmc_wl_num4;
            this.mc_vmc_wl_num4 = this.mc_vmc_wl_num2_reg.mc_vmc_wl_num4;

            this.mc_vmc_wl_num2_reg_mc_vmc_wl_num5 = this.mc_vmc_wl_num2_reg.mc_vmc_wl_num5;
            this.mc_vmc_wl_num5 = this.mc_vmc_wl_num2_reg.mc_vmc_wl_num5;

        this.mc_vmc_wl_num3_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num3_reg::type_id::create("mc_vmc_wl_num3_reg",,get_full_name());
        this.mc_vmc_wl_num3_reg.configure(this, null, "");
        this.mc_vmc_wl_num3_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num3_reg, `UVM_REG_ADDR_WIDTH'h28,"RW",0);
            this.mc_vmc_wl_num3_reg_mc_vmc_wl_num6 = this.mc_vmc_wl_num3_reg.mc_vmc_wl_num6;
            this.mc_vmc_wl_num6 = this.mc_vmc_wl_num3_reg.mc_vmc_wl_num6;

            this.mc_vmc_wl_num3_reg_mc_vmc_wl_num7 = this.mc_vmc_wl_num3_reg.mc_vmc_wl_num7;
            this.mc_vmc_wl_num7 = this.mc_vmc_wl_num3_reg.mc_vmc_wl_num7;

        this.mc_vmc_wl_num4_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num4_reg::type_id::create("mc_vmc_wl_num4_reg",,get_full_name());
        this.mc_vmc_wl_num4_reg.configure(this, null, "");
        this.mc_vmc_wl_num4_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num4_reg, `UVM_REG_ADDR_WIDTH'h2C,"RW",0);
            this.mc_vmc_wl_num4_reg_mc_vmc_wl_num8 = this.mc_vmc_wl_num4_reg.mc_vmc_wl_num8;
            this.mc_vmc_wl_num8 = this.mc_vmc_wl_num4_reg.mc_vmc_wl_num8;

            this.mc_vmc_wl_num4_reg_mc_vmc_wl_num9 = this.mc_vmc_wl_num4_reg.mc_vmc_wl_num9;
            this.mc_vmc_wl_num9 = this.mc_vmc_wl_num4_reg.mc_vmc_wl_num9;

        this.mc_vmc_wl_num5_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num5_reg::type_id::create("mc_vmc_wl_num5_reg",,get_full_name());
        this.mc_vmc_wl_num5_reg.configure(this, null, "");
        this.mc_vmc_wl_num5_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num5_reg, `UVM_REG_ADDR_WIDTH'h30,"RW",0);
            this.mc_vmc_wl_num5_reg_mc_vmc_wl_num10 = this.mc_vmc_wl_num5_reg.mc_vmc_wl_num10;
            this.mc_vmc_wl_num10 = this.mc_vmc_wl_num5_reg.mc_vmc_wl_num10;

            this.mc_vmc_wl_num5_reg_mc_vmc_wl_num11 = this.mc_vmc_wl_num5_reg.mc_vmc_wl_num11;
            this.mc_vmc_wl_num11 = this.mc_vmc_wl_num5_reg.mc_vmc_wl_num11;

        this.mc_vmc_wl_num6_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num6_reg::type_id::create("mc_vmc_wl_num6_reg",,get_full_name());
        this.mc_vmc_wl_num6_reg.configure(this, null, "");
        this.mc_vmc_wl_num6_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num6_reg, `UVM_REG_ADDR_WIDTH'h34,"RW",0);
            this.mc_vmc_wl_num6_reg_mc_vmc_wl_num12 = this.mc_vmc_wl_num6_reg.mc_vmc_wl_num12;
            this.mc_vmc_wl_num12 = this.mc_vmc_wl_num6_reg.mc_vmc_wl_num12;

            this.mc_vmc_wl_num6_reg_mc_vmc_wl_num13 = this.mc_vmc_wl_num6_reg.mc_vmc_wl_num13;
            this.mc_vmc_wl_num13 = this.mc_vmc_wl_num6_reg.mc_vmc_wl_num13;

        this.mc_vmc_wl_num7_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num7_reg::type_id::create("mc_vmc_wl_num7_reg",,get_full_name());
        this.mc_vmc_wl_num7_reg.configure(this, null, "");
        this.mc_vmc_wl_num7_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num7_reg, `UVM_REG_ADDR_WIDTH'h38,"RW",0);
            this.mc_vmc_wl_num7_reg_mc_vmc_wl_num14 = this.mc_vmc_wl_num7_reg.mc_vmc_wl_num14;
            this.mc_vmc_wl_num14 = this.mc_vmc_wl_num7_reg.mc_vmc_wl_num14;

            this.mc_vmc_wl_num7_reg_mc_vmc_wl_num15 = this.mc_vmc_wl_num7_reg.mc_vmc_wl_num15;
            this.mc_vmc_wl_num15 = this.mc_vmc_wl_num7_reg.mc_vmc_wl_num15;

        this.mc_vmc_wl_num8_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num8_reg::type_id::create("mc_vmc_wl_num8_reg",,get_full_name());
        this.mc_vmc_wl_num8_reg.configure(this, null, "");
        this.mc_vmc_wl_num8_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num8_reg, `UVM_REG_ADDR_WIDTH'h3C,"RW",0);
            this.mc_vmc_wl_num8_reg_mc_vmc_wl_num16 = this.mc_vmc_wl_num8_reg.mc_vmc_wl_num16;
            this.mc_vmc_wl_num16 = this.mc_vmc_wl_num8_reg.mc_vmc_wl_num16;

            this.mc_vmc_wl_num8_reg_mc_vmc_wl_num17 = this.mc_vmc_wl_num8_reg.mc_vmc_wl_num17;
            this.mc_vmc_wl_num17 = this.mc_vmc_wl_num8_reg.mc_vmc_wl_num17;

        this.mc_vmc_wl_num9_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num9_reg::type_id::create("mc_vmc_wl_num9_reg",,get_full_name());
        this.mc_vmc_wl_num9_reg.configure(this, null, "");
        this.mc_vmc_wl_num9_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num9_reg, `UVM_REG_ADDR_WIDTH'h40,"RW",0);
            this.mc_vmc_wl_num9_reg_mc_vmc_wl_num18 = this.mc_vmc_wl_num9_reg.mc_vmc_wl_num18;
            this.mc_vmc_wl_num18 = this.mc_vmc_wl_num9_reg.mc_vmc_wl_num18;

            this.mc_vmc_wl_num9_reg_mc_vmc_wl_num19 = this.mc_vmc_wl_num9_reg.mc_vmc_wl_num19;
            this.mc_vmc_wl_num19 = this.mc_vmc_wl_num9_reg.mc_vmc_wl_num19;

        this.mc_vmc_wl_num10_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num10_reg::type_id::create("mc_vmc_wl_num10_reg",,get_full_name());
        this.mc_vmc_wl_num10_reg.configure(this, null, "");
        this.mc_vmc_wl_num10_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num10_reg, `UVM_REG_ADDR_WIDTH'h44,"RW",0);
            this.mc_vmc_wl_num10_reg_mc_vmc_wl_num20 = this.mc_vmc_wl_num10_reg.mc_vmc_wl_num20;
            this.mc_vmc_wl_num20 = this.mc_vmc_wl_num10_reg.mc_vmc_wl_num20;

            this.mc_vmc_wl_num10_reg_mc_vmc_wl_num21 = this.mc_vmc_wl_num10_reg.mc_vmc_wl_num21;
            this.mc_vmc_wl_num21 = this.mc_vmc_wl_num10_reg.mc_vmc_wl_num21;

        this.mc_vmc_wl_num11_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num11_reg::type_id::create("mc_vmc_wl_num11_reg",,get_full_name());
        this.mc_vmc_wl_num11_reg.configure(this, null, "");
        this.mc_vmc_wl_num11_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num11_reg, `UVM_REG_ADDR_WIDTH'h48,"RW",0);
            this.mc_vmc_wl_num11_reg_mc_vmc_wl_num22 = this.mc_vmc_wl_num11_reg.mc_vmc_wl_num22;
            this.mc_vmc_wl_num22 = this.mc_vmc_wl_num11_reg.mc_vmc_wl_num22;

            this.mc_vmc_wl_num11_reg_mc_vmc_wl_num23 = this.mc_vmc_wl_num11_reg.mc_vmc_wl_num23;
            this.mc_vmc_wl_num23 = this.mc_vmc_wl_num11_reg.mc_vmc_wl_num23;

        this.mc_vmc_wl_num12_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num12_reg::type_id::create("mc_vmc_wl_num12_reg",,get_full_name());
        this.mc_vmc_wl_num12_reg.configure(this, null, "");
        this.mc_vmc_wl_num12_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num12_reg, `UVM_REG_ADDR_WIDTH'h4C,"RW",0);
            this.mc_vmc_wl_num12_reg_mc_vmc_wl_num24 = this.mc_vmc_wl_num12_reg.mc_vmc_wl_num24;
            this.mc_vmc_wl_num24 = this.mc_vmc_wl_num12_reg.mc_vmc_wl_num24;

            this.mc_vmc_wl_num12_reg_mc_vmc_wl_num25 = this.mc_vmc_wl_num12_reg.mc_vmc_wl_num25;
            this.mc_vmc_wl_num25 = this.mc_vmc_wl_num12_reg.mc_vmc_wl_num25;

        this.mc_vmc_wl_num13_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num13_reg::type_id::create("mc_vmc_wl_num13_reg",,get_full_name());
        this.mc_vmc_wl_num13_reg.configure(this, null, "");
        this.mc_vmc_wl_num13_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num13_reg, `UVM_REG_ADDR_WIDTH'h50,"RW",0);
            this.mc_vmc_wl_num13_reg_mc_vmc_wl_num26 = this.mc_vmc_wl_num13_reg.mc_vmc_wl_num26;
            this.mc_vmc_wl_num26 = this.mc_vmc_wl_num13_reg.mc_vmc_wl_num26;

            this.mc_vmc_wl_num13_reg_mc_vmc_wl_num27 = this.mc_vmc_wl_num13_reg.mc_vmc_wl_num27;
            this.mc_vmc_wl_num27 = this.mc_vmc_wl_num13_reg.mc_vmc_wl_num27;

        this.mc_vmc_wl_num14_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num14_reg::type_id::create("mc_vmc_wl_num14_reg",,get_full_name());
        this.mc_vmc_wl_num14_reg.configure(this, null, "");
        this.mc_vmc_wl_num14_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num14_reg, `UVM_REG_ADDR_WIDTH'h54,"RW",0);
            this.mc_vmc_wl_num14_reg_mc_vmc_wl_num28 = this.mc_vmc_wl_num14_reg.mc_vmc_wl_num28;
            this.mc_vmc_wl_num28 = this.mc_vmc_wl_num14_reg.mc_vmc_wl_num28;

            this.mc_vmc_wl_num14_reg_mc_vmc_wl_num29 = this.mc_vmc_wl_num14_reg.mc_vmc_wl_num29;
            this.mc_vmc_wl_num29 = this.mc_vmc_wl_num14_reg.mc_vmc_wl_num29;

        this.mc_vmc_wl_num15_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num15_reg::type_id::create("mc_vmc_wl_num15_reg",,get_full_name());
        this.mc_vmc_wl_num15_reg.configure(this, null, "");
        this.mc_vmc_wl_num15_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num15_reg, `UVM_REG_ADDR_WIDTH'h58,"RW",0);
            this.mc_vmc_wl_num15_reg_mc_vmc_wl_num30 = this.mc_vmc_wl_num15_reg.mc_vmc_wl_num30;
            this.mc_vmc_wl_num30 = this.mc_vmc_wl_num15_reg.mc_vmc_wl_num30;

            this.mc_vmc_wl_num15_reg_mc_vmc_wl_num31 = this.mc_vmc_wl_num15_reg.mc_vmc_wl_num31;
            this.mc_vmc_wl_num31 = this.mc_vmc_wl_num15_reg.mc_vmc_wl_num31;

        this.mc_vmc_wl_num16_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num16_reg::type_id::create("mc_vmc_wl_num16_reg",,get_full_name());
        this.mc_vmc_wl_num16_reg.configure(this, null, "");
        this.mc_vmc_wl_num16_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num16_reg, `UVM_REG_ADDR_WIDTH'h5C,"RW",0);
            this.mc_vmc_wl_num16_reg_mc_vmc_wl_num32 = this.mc_vmc_wl_num16_reg.mc_vmc_wl_num32;
            this.mc_vmc_wl_num32 = this.mc_vmc_wl_num16_reg.mc_vmc_wl_num32;

            this.mc_vmc_wl_num16_reg_mc_vmc_wl_num33 = this.mc_vmc_wl_num16_reg.mc_vmc_wl_num33;
            this.mc_vmc_wl_num33 = this.mc_vmc_wl_num16_reg.mc_vmc_wl_num33;

        this.mc_vmc_wl_num17_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num17_reg::type_id::create("mc_vmc_wl_num17_reg",,get_full_name());
        this.mc_vmc_wl_num17_reg.configure(this, null, "");
        this.mc_vmc_wl_num17_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num17_reg, `UVM_REG_ADDR_WIDTH'h60,"RW",0);
            this.mc_vmc_wl_num17_reg_mc_vmc_wl_num34 = this.mc_vmc_wl_num17_reg.mc_vmc_wl_num34;
            this.mc_vmc_wl_num34 = this.mc_vmc_wl_num17_reg.mc_vmc_wl_num34;

            this.mc_vmc_wl_num17_reg_mc_vmc_wl_num35 = this.mc_vmc_wl_num17_reg.mc_vmc_wl_num35;
            this.mc_vmc_wl_num35 = this.mc_vmc_wl_num17_reg.mc_vmc_wl_num35;

        this.mc_vmc_wl_num18_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num18_reg::type_id::create("mc_vmc_wl_num18_reg",,get_full_name());
        this.mc_vmc_wl_num18_reg.configure(this, null, "");
        this.mc_vmc_wl_num18_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num18_reg, `UVM_REG_ADDR_WIDTH'h64,"RW",0);
            this.mc_vmc_wl_num18_reg_mc_vmc_wl_num36 = this.mc_vmc_wl_num18_reg.mc_vmc_wl_num36;
            this.mc_vmc_wl_num36 = this.mc_vmc_wl_num18_reg.mc_vmc_wl_num36;

            this.mc_vmc_wl_num18_reg_mc_vmc_wl_num37 = this.mc_vmc_wl_num18_reg.mc_vmc_wl_num37;
            this.mc_vmc_wl_num37 = this.mc_vmc_wl_num18_reg.mc_vmc_wl_num37;

        this.mc_vmc_wl_num19_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num19_reg::type_id::create("mc_vmc_wl_num19_reg",,get_full_name());
        this.mc_vmc_wl_num19_reg.configure(this, null, "");
        this.mc_vmc_wl_num19_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num19_reg, `UVM_REG_ADDR_WIDTH'h68,"RW",0);
            this.mc_vmc_wl_num19_reg_mc_vmc_wl_num38 = this.mc_vmc_wl_num19_reg.mc_vmc_wl_num38;
            this.mc_vmc_wl_num38 = this.mc_vmc_wl_num19_reg.mc_vmc_wl_num38;

            this.mc_vmc_wl_num19_reg_mc_vmc_wl_num39 = this.mc_vmc_wl_num19_reg.mc_vmc_wl_num39;
            this.mc_vmc_wl_num39 = this.mc_vmc_wl_num19_reg.mc_vmc_wl_num39;

        this.mc_vmc_wl_num20_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num20_reg::type_id::create("mc_vmc_wl_num20_reg",,get_full_name());
        this.mc_vmc_wl_num20_reg.configure(this, null, "");
        this.mc_vmc_wl_num20_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num20_reg, `UVM_REG_ADDR_WIDTH'h6C,"RW",0);
            this.mc_vmc_wl_num20_reg_mc_vmc_wl_num40 = this.mc_vmc_wl_num20_reg.mc_vmc_wl_num40;
            this.mc_vmc_wl_num40 = this.mc_vmc_wl_num20_reg.mc_vmc_wl_num40;

            this.mc_vmc_wl_num20_reg_mc_vmc_wl_num41 = this.mc_vmc_wl_num20_reg.mc_vmc_wl_num41;
            this.mc_vmc_wl_num41 = this.mc_vmc_wl_num20_reg.mc_vmc_wl_num41;

        this.mc_vmc_wl_num21_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num21_reg::type_id::create("mc_vmc_wl_num21_reg",,get_full_name());
        this.mc_vmc_wl_num21_reg.configure(this, null, "");
        this.mc_vmc_wl_num21_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num21_reg, `UVM_REG_ADDR_WIDTH'h70,"RW",0);
            this.mc_vmc_wl_num21_reg_mc_vmc_wl_num42 = this.mc_vmc_wl_num21_reg.mc_vmc_wl_num42;
            this.mc_vmc_wl_num42 = this.mc_vmc_wl_num21_reg.mc_vmc_wl_num42;

            this.mc_vmc_wl_num21_reg_mc_vmc_wl_num43 = this.mc_vmc_wl_num21_reg.mc_vmc_wl_num43;
            this.mc_vmc_wl_num43 = this.mc_vmc_wl_num21_reg.mc_vmc_wl_num43;

        this.mc_vmc_wl_num22_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num22_reg::type_id::create("mc_vmc_wl_num22_reg",,get_full_name());
        this.mc_vmc_wl_num22_reg.configure(this, null, "");
        this.mc_vmc_wl_num22_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num22_reg, `UVM_REG_ADDR_WIDTH'h74,"RW",0);
            this.mc_vmc_wl_num22_reg_mc_vmc_wl_num44 = this.mc_vmc_wl_num22_reg.mc_vmc_wl_num44;
            this.mc_vmc_wl_num44 = this.mc_vmc_wl_num22_reg.mc_vmc_wl_num44;

            this.mc_vmc_wl_num22_reg_mc_vmc_wl_num45 = this.mc_vmc_wl_num22_reg.mc_vmc_wl_num45;
            this.mc_vmc_wl_num45 = this.mc_vmc_wl_num22_reg.mc_vmc_wl_num45;

        this.mc_vmc_wl_num23_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num23_reg::type_id::create("mc_vmc_wl_num23_reg",,get_full_name());
        this.mc_vmc_wl_num23_reg.configure(this, null, "");
        this.mc_vmc_wl_num23_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num23_reg, `UVM_REG_ADDR_WIDTH'h78,"RW",0);
            this.mc_vmc_wl_num23_reg_mc_vmc_wl_num46 = this.mc_vmc_wl_num23_reg.mc_vmc_wl_num46;
            this.mc_vmc_wl_num46 = this.mc_vmc_wl_num23_reg.mc_vmc_wl_num46;

            this.mc_vmc_wl_num23_reg_mc_vmc_wl_num47 = this.mc_vmc_wl_num23_reg.mc_vmc_wl_num47;
            this.mc_vmc_wl_num47 = this.mc_vmc_wl_num23_reg.mc_vmc_wl_num47;

        this.mc_vmc_wl_num24_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num24_reg::type_id::create("mc_vmc_wl_num24_reg",,get_full_name());
        this.mc_vmc_wl_num24_reg.configure(this, null, "");
        this.mc_vmc_wl_num24_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num24_reg, `UVM_REG_ADDR_WIDTH'h7C,"RW",0);
            this.mc_vmc_wl_num24_reg_mc_vmc_wl_num48 = this.mc_vmc_wl_num24_reg.mc_vmc_wl_num48;
            this.mc_vmc_wl_num48 = this.mc_vmc_wl_num24_reg.mc_vmc_wl_num48;

            this.mc_vmc_wl_num24_reg_mc_vmc_wl_num49 = this.mc_vmc_wl_num24_reg.mc_vmc_wl_num49;
            this.mc_vmc_wl_num49 = this.mc_vmc_wl_num24_reg.mc_vmc_wl_num49;

        this.mc_vmc_wl_num25_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num25_reg::type_id::create("mc_vmc_wl_num25_reg",,get_full_name());
        this.mc_vmc_wl_num25_reg.configure(this, null, "");
        this.mc_vmc_wl_num25_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num25_reg, `UVM_REG_ADDR_WIDTH'h80,"RW",0);
            this.mc_vmc_wl_num25_reg_mc_vmc_wl_num50 = this.mc_vmc_wl_num25_reg.mc_vmc_wl_num50;
            this.mc_vmc_wl_num50 = this.mc_vmc_wl_num25_reg.mc_vmc_wl_num50;

            this.mc_vmc_wl_num25_reg_mc_vmc_wl_num51 = this.mc_vmc_wl_num25_reg.mc_vmc_wl_num51;
            this.mc_vmc_wl_num51 = this.mc_vmc_wl_num25_reg.mc_vmc_wl_num51;

        this.mc_vmc_wl_num26_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num26_reg::type_id::create("mc_vmc_wl_num26_reg",,get_full_name());
        this.mc_vmc_wl_num26_reg.configure(this, null, "");
        this.mc_vmc_wl_num26_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num26_reg, `UVM_REG_ADDR_WIDTH'h84,"RW",0);
            this.mc_vmc_wl_num26_reg_mc_vmc_wl_num52 = this.mc_vmc_wl_num26_reg.mc_vmc_wl_num52;
            this.mc_vmc_wl_num52 = this.mc_vmc_wl_num26_reg.mc_vmc_wl_num52;

            this.mc_vmc_wl_num26_reg_mc_vmc_wl_num53 = this.mc_vmc_wl_num26_reg.mc_vmc_wl_num53;
            this.mc_vmc_wl_num53 = this.mc_vmc_wl_num26_reg.mc_vmc_wl_num53;

        this.mc_vmc_wl_num27_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num27_reg::type_id::create("mc_vmc_wl_num27_reg",,get_full_name());
        this.mc_vmc_wl_num27_reg.configure(this, null, "");
        this.mc_vmc_wl_num27_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num27_reg, `UVM_REG_ADDR_WIDTH'h88,"RW",0);
            this.mc_vmc_wl_num27_reg_mc_vmc_wl_num54 = this.mc_vmc_wl_num27_reg.mc_vmc_wl_num54;
            this.mc_vmc_wl_num54 = this.mc_vmc_wl_num27_reg.mc_vmc_wl_num54;

            this.mc_vmc_wl_num27_reg_mc_vmc_wl_num55 = this.mc_vmc_wl_num27_reg.mc_vmc_wl_num55;
            this.mc_vmc_wl_num55 = this.mc_vmc_wl_num27_reg.mc_vmc_wl_num55;

        this.mc_vmc_wl_num28_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num28_reg::type_id::create("mc_vmc_wl_num28_reg",,get_full_name());
        this.mc_vmc_wl_num28_reg.configure(this, null, "");
        this.mc_vmc_wl_num28_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num28_reg, `UVM_REG_ADDR_WIDTH'h8C,"RW",0);
            this.mc_vmc_wl_num28_reg_mc_vmc_wl_num56 = this.mc_vmc_wl_num28_reg.mc_vmc_wl_num56;
            this.mc_vmc_wl_num56 = this.mc_vmc_wl_num28_reg.mc_vmc_wl_num56;

            this.mc_vmc_wl_num28_reg_mc_vmc_wl_num57 = this.mc_vmc_wl_num28_reg.mc_vmc_wl_num57;
            this.mc_vmc_wl_num57 = this.mc_vmc_wl_num28_reg.mc_vmc_wl_num57;

        this.mc_vmc_wl_num29_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num29_reg::type_id::create("mc_vmc_wl_num29_reg",,get_full_name());
        this.mc_vmc_wl_num29_reg.configure(this, null, "");
        this.mc_vmc_wl_num29_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num29_reg, `UVM_REG_ADDR_WIDTH'h90,"RW",0);
            this.mc_vmc_wl_num29_reg_mc_vmc_wl_num58 = this.mc_vmc_wl_num29_reg.mc_vmc_wl_num58;
            this.mc_vmc_wl_num58 = this.mc_vmc_wl_num29_reg.mc_vmc_wl_num58;

            this.mc_vmc_wl_num29_reg_mc_vmc_wl_num59 = this.mc_vmc_wl_num29_reg.mc_vmc_wl_num59;
            this.mc_vmc_wl_num59 = this.mc_vmc_wl_num29_reg.mc_vmc_wl_num59;

        this.mc_vmc_wl_num30_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num30_reg::type_id::create("mc_vmc_wl_num30_reg",,get_full_name());
        this.mc_vmc_wl_num30_reg.configure(this, null, "");
        this.mc_vmc_wl_num30_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num30_reg, `UVM_REG_ADDR_WIDTH'h94,"RW",0);
            this.mc_vmc_wl_num30_reg_mc_vmc_wl_num60 = this.mc_vmc_wl_num30_reg.mc_vmc_wl_num60;
            this.mc_vmc_wl_num60 = this.mc_vmc_wl_num30_reg.mc_vmc_wl_num60;

            this.mc_vmc_wl_num30_reg_mc_vmc_wl_num61 = this.mc_vmc_wl_num30_reg.mc_vmc_wl_num61;
            this.mc_vmc_wl_num61 = this.mc_vmc_wl_num30_reg.mc_vmc_wl_num61;

        this.mc_vmc_wl_num31_reg = ral_reg_mc_wrapper_top_mc_vmc_wl_num31_reg::type_id::create("mc_vmc_wl_num31_reg",,get_full_name());
        this.mc_vmc_wl_num31_reg.configure(this, null, "");
        this.mc_vmc_wl_num31_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num31_reg, `UVM_REG_ADDR_WIDTH'h98,"RW",0);
            this.mc_vmc_wl_num31_reg_mc_vmc_wl_num62 = this.mc_vmc_wl_num31_reg.mc_vmc_wl_num62;
            this.mc_vmc_wl_num62 = this.mc_vmc_wl_num31_reg.mc_vmc_wl_num62;

            this.mc_vmc_wl_num31_reg_mc_vmc_wl_num63 = this.mc_vmc_wl_num31_reg.mc_vmc_wl_num63;
            this.mc_vmc_wl_num63 = this.mc_vmc_wl_num31_reg.mc_vmc_wl_num63;

        this.mc_vmc_bl_num0_reg = ral_reg_mc_wrapper_top_mc_vmc_bl_num0_reg::type_id::create("mc_vmc_bl_num0_reg",,get_full_name());
        this.mc_vmc_bl_num0_reg.configure(this, null, "");
        this.mc_vmc_bl_num0_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num0_reg, `UVM_REG_ADDR_WIDTH'h9C,"RW",0);
            this.mc_vmc_bl_num0_reg_mc_vmc_bl_num0_part0 = this.mc_vmc_bl_num0_reg.mc_vmc_bl_num0_part0;
            this.mc_vmc_bl_num0_part0 = this.mc_vmc_bl_num0_reg.mc_vmc_bl_num0_part0;

            this.mc_vmc_bl_num0_reg_mc_vmc_bl_num1_part0 = this.mc_vmc_bl_num0_reg.mc_vmc_bl_num1_part0;
            this.mc_vmc_bl_num1_part0 = this.mc_vmc_bl_num0_reg.mc_vmc_bl_num1_part0;

            this.mc_vmc_bl_num0_reg_mc_vmc_bl_num0_part1 = this.mc_vmc_bl_num0_reg.mc_vmc_bl_num0_part1;
            this.mc_vmc_bl_num0_part1 = this.mc_vmc_bl_num0_reg.mc_vmc_bl_num0_part1;

            this.mc_vmc_bl_num0_reg_mc_vmc_bl_num1_part1 = this.mc_vmc_bl_num0_reg.mc_vmc_bl_num1_part1;
            this.mc_vmc_bl_num1_part1 = this.mc_vmc_bl_num0_reg.mc_vmc_bl_num1_part1;

        this.mc_vmc_bl_num1_reg = ral_reg_mc_wrapper_top_mc_vmc_bl_num1_reg::type_id::create("mc_vmc_bl_num1_reg",,get_full_name());
        this.mc_vmc_bl_num1_reg.configure(this, null, "");
        this.mc_vmc_bl_num1_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num1_reg, `UVM_REG_ADDR_WIDTH'hA0,"RW",0);
            this.mc_vmc_bl_num1_reg_mc_vmc_bl_num0_part2 = this.mc_vmc_bl_num1_reg.mc_vmc_bl_num0_part2;
            this.mc_vmc_bl_num0_part2 = this.mc_vmc_bl_num1_reg.mc_vmc_bl_num0_part2;

            this.mc_vmc_bl_num1_reg_mc_vmc_bl_num1_part2 = this.mc_vmc_bl_num1_reg.mc_vmc_bl_num1_part2;
            this.mc_vmc_bl_num1_part2 = this.mc_vmc_bl_num1_reg.mc_vmc_bl_num1_part2;

            this.mc_vmc_bl_num1_reg_mc_vmc_bl_num0_part3 = this.mc_vmc_bl_num1_reg.mc_vmc_bl_num0_part3;
            this.mc_vmc_bl_num0_part3 = this.mc_vmc_bl_num1_reg.mc_vmc_bl_num0_part3;

            this.mc_vmc_bl_num1_reg_mc_vmc_bl_num1_part3 = this.mc_vmc_bl_num1_reg.mc_vmc_bl_num1_part3;
            this.mc_vmc_bl_num1_part3 = this.mc_vmc_bl_num1_reg.mc_vmc_bl_num1_part3;

        this.mc_vmc_bl_num2_reg = ral_reg_mc_wrapper_top_mc_vmc_bl_num2_reg::type_id::create("mc_vmc_bl_num2_reg",,get_full_name());
        this.mc_vmc_bl_num2_reg.configure(this, null, "");
        this.mc_vmc_bl_num2_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num2_reg, `UVM_REG_ADDR_WIDTH'hA4,"RW",0);
            this.mc_vmc_bl_num2_reg_mc_vmc_bl_num0_part4 = this.mc_vmc_bl_num2_reg.mc_vmc_bl_num0_part4;
            this.mc_vmc_bl_num0_part4 = this.mc_vmc_bl_num2_reg.mc_vmc_bl_num0_part4;

            this.mc_vmc_bl_num2_reg_mc_vmc_bl_num1_part4 = this.mc_vmc_bl_num2_reg.mc_vmc_bl_num1_part4;
            this.mc_vmc_bl_num1_part4 = this.mc_vmc_bl_num2_reg.mc_vmc_bl_num1_part4;

            this.mc_vmc_bl_num2_reg_mc_vmc_bl_num0_part5 = this.mc_vmc_bl_num2_reg.mc_vmc_bl_num0_part5;
            this.mc_vmc_bl_num0_part5 = this.mc_vmc_bl_num2_reg.mc_vmc_bl_num0_part5;

            this.mc_vmc_bl_num2_reg_mc_vmc_bl_num1_part5 = this.mc_vmc_bl_num2_reg.mc_vmc_bl_num1_part5;
            this.mc_vmc_bl_num1_part5 = this.mc_vmc_bl_num2_reg.mc_vmc_bl_num1_part5;

        this.mc_vmc_bl_num3_reg = ral_reg_mc_wrapper_top_mc_vmc_bl_num3_reg::type_id::create("mc_vmc_bl_num3_reg",,get_full_name());
        this.mc_vmc_bl_num3_reg.configure(this, null, "");
        this.mc_vmc_bl_num3_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num3_reg, `UVM_REG_ADDR_WIDTH'hA8,"RW",0);
            this.mc_vmc_bl_num3_reg_mc_vmc_bl_num0_part6 = this.mc_vmc_bl_num3_reg.mc_vmc_bl_num0_part6;
            this.mc_vmc_bl_num0_part6 = this.mc_vmc_bl_num3_reg.mc_vmc_bl_num0_part6;

            this.mc_vmc_bl_num3_reg_mc_vmc_bl_num1_part6 = this.mc_vmc_bl_num3_reg.mc_vmc_bl_num1_part6;
            this.mc_vmc_bl_num1_part6 = this.mc_vmc_bl_num3_reg.mc_vmc_bl_num1_part6;

            this.mc_vmc_bl_num3_reg_mc_vmc_bl_num0_part7 = this.mc_vmc_bl_num3_reg.mc_vmc_bl_num0_part7;
            this.mc_vmc_bl_num0_part7 = this.mc_vmc_bl_num3_reg.mc_vmc_bl_num0_part7;

            this.mc_vmc_bl_num3_reg_mc_vmc_bl_num1_part7 = this.mc_vmc_bl_num3_reg.mc_vmc_bl_num1_part7;
            this.mc_vmc_bl_num1_part7 = this.mc_vmc_bl_num3_reg.mc_vmc_bl_num1_part7;

        this.mc_vmc_bl_num4_reg = ral_reg_mc_wrapper_top_mc_vmc_bl_num4_reg::type_id::create("mc_vmc_bl_num4_reg",,get_full_name());
        this.mc_vmc_bl_num4_reg.configure(this, null, "");
        this.mc_vmc_bl_num4_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num4_reg, `UVM_REG_ADDR_WIDTH'hAC,"RW",0);
            this.mc_vmc_bl_num4_reg_mc_vmc_bl_num0_part8 = this.mc_vmc_bl_num4_reg.mc_vmc_bl_num0_part8;
            this.mc_vmc_bl_num0_part8 = this.mc_vmc_bl_num4_reg.mc_vmc_bl_num0_part8;

            this.mc_vmc_bl_num4_reg_mc_vmc_bl_num1_part8 = this.mc_vmc_bl_num4_reg.mc_vmc_bl_num1_part8;
            this.mc_vmc_bl_num1_part8 = this.mc_vmc_bl_num4_reg.mc_vmc_bl_num1_part8;

            this.mc_vmc_bl_num4_reg_mc_vmc_bl_num0_part9 = this.mc_vmc_bl_num4_reg.mc_vmc_bl_num0_part9;
            this.mc_vmc_bl_num0_part9 = this.mc_vmc_bl_num4_reg.mc_vmc_bl_num0_part9;

            this.mc_vmc_bl_num4_reg_mc_vmc_bl_num1_part9 = this.mc_vmc_bl_num4_reg.mc_vmc_bl_num1_part9;
            this.mc_vmc_bl_num1_part9 = this.mc_vmc_bl_num4_reg.mc_vmc_bl_num1_part9;

        this.mc_frame2array_dbg_reg = ral_reg_mc_wrapper_top_mc_frame2array_dbg_reg::type_id::create("mc_frame2array_dbg_reg",,get_full_name());
        this.mc_frame2array_dbg_reg.configure(this, null, "");
        this.mc_frame2array_dbg_reg.build();
        this.default_map.add_reg(this.mc_frame2array_dbg_reg, `UVM_REG_ADDR_WIDTH'hB0,"RW",0);
            this.mc_frame2array_dbg_reg_dbg_next_state_array = this.mc_frame2array_dbg_reg.dbg_next_state_array;
            this.dbg_next_state_array = this.mc_frame2array_dbg_reg.dbg_next_state_array;

            this.mc_frame2array_dbg_reg_dbg_current_state_array = this.mc_frame2array_dbg_reg.dbg_current_state_array;
            this.dbg_current_state_array = this.mc_frame2array_dbg_reg.dbg_current_state_array;

            this.mc_frame2array_dbg_reg_dbg_r_data_cnt = this.mc_frame2array_dbg_reg.dbg_r_data_cnt;
            this.dbg_r_data_cnt = this.mc_frame2array_dbg_reg.dbg_r_data_cnt;

            this.mc_frame2array_dbg_reg_dbg_refresh_flag = this.mc_frame2array_dbg_reg.dbg_refresh_flag;
            this.dbg_refresh_flag = this.mc_frame2array_dbg_reg.dbg_refresh_flag;

            this.mc_frame2array_dbg_reg_dbg_r_frame_cnt = this.mc_frame2array_dbg_reg.dbg_r_frame_cnt;
            this.dbg_r_frame_cnt = this.mc_frame2array_dbg_reg.dbg_r_frame_cnt;

            this.mc_frame2array_dbg_reg_dbg_w_frame_cnt = this.mc_frame2array_dbg_reg.dbg_w_frame_cnt;
            this.dbg_w_frame_cnt = this.mc_frame2array_dbg_reg.dbg_w_frame_cnt;

            this.mc_frame2array_dbg_reg_ras_clr = this.mc_frame2array_dbg_reg.ras_clr;
            this.ras_clr = this.mc_frame2array_dbg_reg.ras_clr;

        this.mc_timeout_clr_reg = ral_reg_mc_wrapper_top_mc_timeout_clr_reg::type_id::create("mc_timeout_clr_reg",,get_full_name());
        this.mc_timeout_clr_reg.configure(this, null, "");
        this.mc_timeout_clr_reg.build();
        this.default_map.add_reg(this.mc_timeout_clr_reg, `UVM_REG_ADDR_WIDTH'hB4,"RW",0);
            this.mc_timeout_clr_reg_mc_timeout_clr = this.mc_timeout_clr_reg.mc_timeout_clr;
            this.mc_timeout_clr = this.mc_timeout_clr_reg.mc_timeout_clr;

        this.mc_rf_start_dbg_reg = ral_reg_mc_wrapper_top_mc_rf_start_dbg_reg::type_id::create("mc_rf_start_dbg_reg",,get_full_name());
        this.mc_rf_start_dbg_reg.configure(this, null, "");
        this.mc_rf_start_dbg_reg.build();
        this.default_map.add_reg(this.mc_rf_start_dbg_reg, `UVM_REG_ADDR_WIDTH'hB8,"RW",0);
            this.mc_rf_start_dbg_reg_mc_rf_start_dbg = this.mc_rf_start_dbg_reg.mc_rf_start_dbg;
            this.mc_rf_start_dbg = this.mc_rf_start_dbg_reg.mc_rf_start_dbg;

        this.mc_timeout_flag_reg = ral_reg_mc_wrapper_top_mc_timeout_flag_reg::type_id::create("mc_timeout_flag_reg",,get_full_name());
        this.mc_timeout_flag_reg.configure(this, null, "");
        this.mc_timeout_flag_reg.build();
        this.default_map.add_reg(this.mc_timeout_flag_reg, `UVM_REG_ADDR_WIDTH'hBC,"RW",0);
            this.mc_timeout_flag_reg_mc_timeout_flag = this.mc_timeout_flag_reg.mc_timeout_flag;
            this.mc_timeout_flag = this.mc_timeout_flag_reg.mc_timeout_flag;

        this.mc_bist_status_reg = ral_reg_mc_wrapper_top_mc_bist_status_reg::type_id::create("mc_bist_status_reg",,get_full_name());
        this.mc_bist_status_reg.configure(this, null, "");
        this.mc_bist_status_reg.build();
        this.default_map.add_reg(this.mc_bist_status_reg, `UVM_REG_ADDR_WIDTH'hC0,"RW",0);
            this.mc_bist_status_reg_mc_bist_status = this.mc_bist_status_reg.mc_bist_status;
            this.mc_bist_status = this.mc_bist_status_reg.mc_bist_status;

            this.mc_bist_status_reg_mc_bist_path_fail = this.mc_bist_status_reg.mc_bist_path_fail;
            this.mc_bist_path_fail = this.mc_bist_status_reg.mc_bist_path_fail;

            this.mc_bist_status_reg_dram_init_finish = this.mc_bist_status_reg.dram_init_finish;
            this.dram_init_finish = this.mc_bist_status_reg.dram_init_finish;

        this.bist_finish_reg = ral_reg_mc_wrapper_top_bist_finish_reg::type_id::create("bist_finish_reg",,get_full_name());
        this.bist_finish_reg.configure(this, null, "");
        this.bist_finish_reg.build();
        this.default_map.add_reg(this.bist_finish_reg, `UVM_REG_ADDR_WIDTH'hC4,"RW",0);
            this.bist_finish_reg_bist_finish = this.bist_finish_reg.bist_finish;
            this.bist_finish = this.bist_finish_reg.bist_finish;

            this.bist_finish_reg_bist_rescan_finish = this.bist_finish_reg.bist_rescan_finish;
            this.bist_rescan_finish = this.bist_finish_reg.bist_rescan_finish;

        this.bank_success_reg = ral_reg_mc_wrapper_top_bank_success_reg::type_id::create("bank_success_reg",,get_full_name());
        this.bank_success_reg.configure(this, null, "");
        this.bank_success_reg.build();
        this.default_map.add_reg(this.bank_success_reg, `UVM_REG_ADDR_WIDTH'hC8,"RW",0);
            this.bank_success_reg_bank_success = this.bank_success_reg.bank_success;
            this.bank_success = this.bank_success_reg.bank_success;

            this.bank_success_reg_bist_rescan_success = this.bank_success_reg.bist_rescan_success;
            this.bist_rescan_success = this.bank_success_reg.bist_rescan_success;

        this.err_csl0_reg = ral_reg_mc_wrapper_top_err_csl0_reg::type_id::create("err_csl0_reg",,get_full_name());
        this.err_csl0_reg.configure(this, null, "");
        this.err_csl0_reg.build();
        this.default_map.add_reg(this.err_csl0_reg, `UVM_REG_ADDR_WIDTH'hCC,"RW",0);
            this.err_csl0_reg_err_csl0_part0 = this.err_csl0_reg.err_csl0_part0;
            this.err_csl0_part0 = this.err_csl0_reg.err_csl0_part0;

            this.err_csl0_reg_err_csl1_part0 = this.err_csl0_reg.err_csl1_part0;
            this.err_csl1_part0 = this.err_csl0_reg.err_csl1_part0;

            this.err_csl0_reg_err_csl0_part1 = this.err_csl0_reg.err_csl0_part1;
            this.err_csl0_part1 = this.err_csl0_reg.err_csl0_part1;

            this.err_csl0_reg_err_csl1_part1 = this.err_csl0_reg.err_csl1_part1;
            this.err_csl1_part1 = this.err_csl0_reg.err_csl1_part1;

        this.err_csl1_reg = ral_reg_mc_wrapper_top_err_csl1_reg::type_id::create("err_csl1_reg",,get_full_name());
        this.err_csl1_reg.configure(this, null, "");
        this.err_csl1_reg.build();
        this.default_map.add_reg(this.err_csl1_reg, `UVM_REG_ADDR_WIDTH'hD0,"RW",0);
            this.err_csl1_reg_err_csl0_part2 = this.err_csl1_reg.err_csl0_part2;
            this.err_csl0_part2 = this.err_csl1_reg.err_csl0_part2;

            this.err_csl1_reg_err_csl1_part2 = this.err_csl1_reg.err_csl1_part2;
            this.err_csl1_part2 = this.err_csl1_reg.err_csl1_part2;

            this.err_csl1_reg_err_csl0_part3 = this.err_csl1_reg.err_csl0_part3;
            this.err_csl0_part3 = this.err_csl1_reg.err_csl0_part3;

            this.err_csl1_reg_err_csl1_part3 = this.err_csl1_reg.err_csl1_part3;
            this.err_csl1_part3 = this.err_csl1_reg.err_csl1_part3;

        this.err_csl2_reg = ral_reg_mc_wrapper_top_err_csl2_reg::type_id::create("err_csl2_reg",,get_full_name());
        this.err_csl2_reg.configure(this, null, "");
        this.err_csl2_reg.build();
        this.default_map.add_reg(this.err_csl2_reg, `UVM_REG_ADDR_WIDTH'hD4,"RW",0);
            this.err_csl2_reg_err_csl0_part4 = this.err_csl2_reg.err_csl0_part4;
            this.err_csl0_part4 = this.err_csl2_reg.err_csl0_part4;

            this.err_csl2_reg_err_csl1_part4 = this.err_csl2_reg.err_csl1_part4;
            this.err_csl1_part4 = this.err_csl2_reg.err_csl1_part4;

            this.err_csl2_reg_err_csl0_part5 = this.err_csl2_reg.err_csl0_part5;
            this.err_csl0_part5 = this.err_csl2_reg.err_csl0_part5;

            this.err_csl2_reg_err_csl1_part5 = this.err_csl2_reg.err_csl1_part5;
            this.err_csl1_part5 = this.err_csl2_reg.err_csl1_part5;

        this.err_csl3_reg = ral_reg_mc_wrapper_top_err_csl3_reg::type_id::create("err_csl3_reg",,get_full_name());
        this.err_csl3_reg.configure(this, null, "");
        this.err_csl3_reg.build();
        this.default_map.add_reg(this.err_csl3_reg, `UVM_REG_ADDR_WIDTH'hD8,"RW",0);
            this.err_csl3_reg_err_csl0_part6 = this.err_csl3_reg.err_csl0_part6;
            this.err_csl0_part6 = this.err_csl3_reg.err_csl0_part6;

            this.err_csl3_reg_err_csl1_part6 = this.err_csl3_reg.err_csl1_part6;
            this.err_csl1_part6 = this.err_csl3_reg.err_csl1_part6;

            this.err_csl3_reg_err_csl0_part7 = this.err_csl3_reg.err_csl0_part7;
            this.err_csl0_part7 = this.err_csl3_reg.err_csl0_part7;

            this.err_csl3_reg_err_csl1_part7 = this.err_csl3_reg.err_csl1_part7;
            this.err_csl1_part7 = this.err_csl3_reg.err_csl1_part7;

        this.err_csl4_reg = ral_reg_mc_wrapper_top_err_csl4_reg::type_id::create("err_csl4_reg",,get_full_name());
        this.err_csl4_reg.configure(this, null, "");
        this.err_csl4_reg.build();
        this.default_map.add_reg(this.err_csl4_reg, `UVM_REG_ADDR_WIDTH'hDC,"RW",0);
            this.err_csl4_reg_err_csl0_part8 = this.err_csl4_reg.err_csl0_part8;
            this.err_csl0_part8 = this.err_csl4_reg.err_csl0_part8;

            this.err_csl4_reg_err_csl1_part8 = this.err_csl4_reg.err_csl1_part8;
            this.err_csl1_part8 = this.err_csl4_reg.err_csl1_part8;

            this.err_csl4_reg_err_csl0_part9 = this.err_csl4_reg.err_csl0_part9;
            this.err_csl0_part9 = this.err_csl4_reg.err_csl0_part9;

            this.err_csl4_reg_err_csl1_part9 = this.err_csl4_reg.err_csl1_part9;
            this.err_csl1_part9 = this.err_csl4_reg.err_csl1_part9;

        this.err_wl0_reg = ral_reg_mc_wrapper_top_err_wl0_reg::type_id::create("err_wl0_reg",,get_full_name());
        this.err_wl0_reg.configure(this, null, "");
        this.err_wl0_reg.build();
        this.default_map.add_reg(this.err_wl0_reg, `UVM_REG_ADDR_WIDTH'hE0,"RW",0);
            this.err_wl0_reg_err_wl0 = this.err_wl0_reg.err_wl0;
            this.err_wl0 = this.err_wl0_reg.err_wl0;

            this.err_wl0_reg_err_wl1 = this.err_wl0_reg.err_wl1;
            this.err_wl1 = this.err_wl0_reg.err_wl1;

        this.err_wl1_reg = ral_reg_mc_wrapper_top_err_wl1_reg::type_id::create("err_wl1_reg",,get_full_name());
        this.err_wl1_reg.configure(this, null, "");
        this.err_wl1_reg.build();
        this.default_map.add_reg(this.err_wl1_reg, `UVM_REG_ADDR_WIDTH'hE4,"RW",0);
            this.err_wl1_reg_err_wl2 = this.err_wl1_reg.err_wl2;
            this.err_wl2 = this.err_wl1_reg.err_wl2;

            this.err_wl1_reg_err_wl3 = this.err_wl1_reg.err_wl3;
            this.err_wl3 = this.err_wl1_reg.err_wl3;

        this.err_wl2_reg = ral_reg_mc_wrapper_top_err_wl2_reg::type_id::create("err_wl2_reg",,get_full_name());
        this.err_wl2_reg.configure(this, null, "");
        this.err_wl2_reg.build();
        this.default_map.add_reg(this.err_wl2_reg, `UVM_REG_ADDR_WIDTH'hE8,"RW",0);
            this.err_wl2_reg_err_wl4 = this.err_wl2_reg.err_wl4;
            this.err_wl4 = this.err_wl2_reg.err_wl4;

            this.err_wl2_reg_err_wl5 = this.err_wl2_reg.err_wl5;
            this.err_wl5 = this.err_wl2_reg.err_wl5;

        this.err_wl3_reg = ral_reg_mc_wrapper_top_err_wl3_reg::type_id::create("err_wl3_reg",,get_full_name());
        this.err_wl3_reg.configure(this, null, "");
        this.err_wl3_reg.build();
        this.default_map.add_reg(this.err_wl3_reg, `UVM_REG_ADDR_WIDTH'hEC,"RW",0);
            this.err_wl3_reg_err_wl6 = this.err_wl3_reg.err_wl6;
            this.err_wl6 = this.err_wl3_reg.err_wl6;

            this.err_wl3_reg_err_wl7 = this.err_wl3_reg.err_wl7;
            this.err_wl7 = this.err_wl3_reg.err_wl7;

        this.err_wl4_reg = ral_reg_mc_wrapper_top_err_wl4_reg::type_id::create("err_wl4_reg",,get_full_name());
        this.err_wl4_reg.configure(this, null, "");
        this.err_wl4_reg.build();
        this.default_map.add_reg(this.err_wl4_reg, `UVM_REG_ADDR_WIDTH'hF0,"RW",0);
            this.err_wl4_reg_err_wl8 = this.err_wl4_reg.err_wl8;
            this.err_wl8 = this.err_wl4_reg.err_wl8;

            this.err_wl4_reg_err_wl9 = this.err_wl4_reg.err_wl9;
            this.err_wl9 = this.err_wl4_reg.err_wl9;

        this.err_wl5_reg = ral_reg_mc_wrapper_top_err_wl5_reg::type_id::create("err_wl5_reg",,get_full_name());
        this.err_wl5_reg.configure(this, null, "");
        this.err_wl5_reg.build();
        this.default_map.add_reg(this.err_wl5_reg, `UVM_REG_ADDR_WIDTH'hF4,"RW",0);
            this.err_wl5_reg_err_wl10 = this.err_wl5_reg.err_wl10;
            this.err_wl10 = this.err_wl5_reg.err_wl10;

            this.err_wl5_reg_err_wl11 = this.err_wl5_reg.err_wl11;
            this.err_wl11 = this.err_wl5_reg.err_wl11;

        this.err_wl6_reg = ral_reg_mc_wrapper_top_err_wl6_reg::type_id::create("err_wl6_reg",,get_full_name());
        this.err_wl6_reg.configure(this, null, "");
        this.err_wl6_reg.build();
        this.default_map.add_reg(this.err_wl6_reg, `UVM_REG_ADDR_WIDTH'hF8,"RW",0);
            this.err_wl6_reg_err_wl12 = this.err_wl6_reg.err_wl12;
            this.err_wl12 = this.err_wl6_reg.err_wl12;

            this.err_wl6_reg_err_wl13 = this.err_wl6_reg.err_wl13;
            this.err_wl13 = this.err_wl6_reg.err_wl13;

        this.err_wl7_reg = ral_reg_mc_wrapper_top_err_wl7_reg::type_id::create("err_wl7_reg",,get_full_name());
        this.err_wl7_reg.configure(this, null, "");
        this.err_wl7_reg.build();
        this.default_map.add_reg(this.err_wl7_reg, `UVM_REG_ADDR_WIDTH'hFC,"RW",0);
            this.err_wl7_reg_err_wl14 = this.err_wl7_reg.err_wl14;
            this.err_wl14 = this.err_wl7_reg.err_wl14;

            this.err_wl7_reg_err_wl15 = this.err_wl7_reg.err_wl15;
            this.err_wl15 = this.err_wl7_reg.err_wl15;

        this.err_wl8_reg = ral_reg_mc_wrapper_top_err_wl8_reg::type_id::create("err_wl8_reg",,get_full_name());
        this.err_wl8_reg.configure(this, null, "");
        this.err_wl8_reg.build();
        this.default_map.add_reg(this.err_wl8_reg, `UVM_REG_ADDR_WIDTH'h100,"RW",0);
            this.err_wl8_reg_err_wl16 = this.err_wl8_reg.err_wl16;
            this.err_wl16 = this.err_wl8_reg.err_wl16;

            this.err_wl8_reg_err_wl17 = this.err_wl8_reg.err_wl17;
            this.err_wl17 = this.err_wl8_reg.err_wl17;

        this.err_wl9_reg = ral_reg_mc_wrapper_top_err_wl9_reg::type_id::create("err_wl9_reg",,get_full_name());
        this.err_wl9_reg.configure(this, null, "");
        this.err_wl9_reg.build();
        this.default_map.add_reg(this.err_wl9_reg, `UVM_REG_ADDR_WIDTH'h104,"RW",0);
            this.err_wl9_reg_err_wl18 = this.err_wl9_reg.err_wl18;
            this.err_wl18 = this.err_wl9_reg.err_wl18;

            this.err_wl9_reg_err_wl19 = this.err_wl9_reg.err_wl19;
            this.err_wl19 = this.err_wl9_reg.err_wl19;

        this.err_wl10_reg = ral_reg_mc_wrapper_top_err_wl10_reg::type_id::create("err_wl10_reg",,get_full_name());
        this.err_wl10_reg.configure(this, null, "");
        this.err_wl10_reg.build();
        this.default_map.add_reg(this.err_wl10_reg, `UVM_REG_ADDR_WIDTH'h108,"RW",0);
            this.err_wl10_reg_err_wl20 = this.err_wl10_reg.err_wl20;
            this.err_wl20 = this.err_wl10_reg.err_wl20;

            this.err_wl10_reg_err_wl21 = this.err_wl10_reg.err_wl21;
            this.err_wl21 = this.err_wl10_reg.err_wl21;

        this.err_wl11_reg = ral_reg_mc_wrapper_top_err_wl11_reg::type_id::create("err_wl11_reg",,get_full_name());
        this.err_wl11_reg.configure(this, null, "");
        this.err_wl11_reg.build();
        this.default_map.add_reg(this.err_wl11_reg, `UVM_REG_ADDR_WIDTH'h10C,"RW",0);
            this.err_wl11_reg_err_wl22 = this.err_wl11_reg.err_wl22;
            this.err_wl22 = this.err_wl11_reg.err_wl22;

            this.err_wl11_reg_err_wl23 = this.err_wl11_reg.err_wl23;
            this.err_wl23 = this.err_wl11_reg.err_wl23;

        this.err_wl12_reg = ral_reg_mc_wrapper_top_err_wl12_reg::type_id::create("err_wl12_reg",,get_full_name());
        this.err_wl12_reg.configure(this, null, "");
        this.err_wl12_reg.build();
        this.default_map.add_reg(this.err_wl12_reg, `UVM_REG_ADDR_WIDTH'h110,"RW",0);
            this.err_wl12_reg_err_wl24 = this.err_wl12_reg.err_wl24;
            this.err_wl24 = this.err_wl12_reg.err_wl24;

            this.err_wl12_reg_err_wl25 = this.err_wl12_reg.err_wl25;
            this.err_wl25 = this.err_wl12_reg.err_wl25;

        this.err_wl13_reg = ral_reg_mc_wrapper_top_err_wl13_reg::type_id::create("err_wl13_reg",,get_full_name());
        this.err_wl13_reg.configure(this, null, "");
        this.err_wl13_reg.build();
        this.default_map.add_reg(this.err_wl13_reg, `UVM_REG_ADDR_WIDTH'h114,"RW",0);
            this.err_wl13_reg_err_wl26 = this.err_wl13_reg.err_wl26;
            this.err_wl26 = this.err_wl13_reg.err_wl26;

            this.err_wl13_reg_err_wl27 = this.err_wl13_reg.err_wl27;
            this.err_wl27 = this.err_wl13_reg.err_wl27;

        this.err_wl14_reg = ral_reg_mc_wrapper_top_err_wl14_reg::type_id::create("err_wl14_reg",,get_full_name());
        this.err_wl14_reg.configure(this, null, "");
        this.err_wl14_reg.build();
        this.default_map.add_reg(this.err_wl14_reg, `UVM_REG_ADDR_WIDTH'h118,"RW",0);
            this.err_wl14_reg_err_wl28 = this.err_wl14_reg.err_wl28;
            this.err_wl28 = this.err_wl14_reg.err_wl28;

            this.err_wl14_reg_err_wl29 = this.err_wl14_reg.err_wl29;
            this.err_wl29 = this.err_wl14_reg.err_wl29;

        this.err_wl15_reg = ral_reg_mc_wrapper_top_err_wl15_reg::type_id::create("err_wl15_reg",,get_full_name());
        this.err_wl15_reg.configure(this, null, "");
        this.err_wl15_reg.build();
        this.default_map.add_reg(this.err_wl15_reg, `UVM_REG_ADDR_WIDTH'h11C,"RW",0);
            this.err_wl15_reg_err_wl30 = this.err_wl15_reg.err_wl30;
            this.err_wl30 = this.err_wl15_reg.err_wl30;

            this.err_wl15_reg_err_wl31 = this.err_wl15_reg.err_wl31;
            this.err_wl31 = this.err_wl15_reg.err_wl31;

        this.err_wl16_reg = ral_reg_mc_wrapper_top_err_wl16_reg::type_id::create("err_wl16_reg",,get_full_name());
        this.err_wl16_reg.configure(this, null, "");
        this.err_wl16_reg.build();
        this.default_map.add_reg(this.err_wl16_reg, `UVM_REG_ADDR_WIDTH'h120,"RW",0);
            this.err_wl16_reg_err_wl32 = this.err_wl16_reg.err_wl32;
            this.err_wl32 = this.err_wl16_reg.err_wl32;

            this.err_wl16_reg_err_wl33 = this.err_wl16_reg.err_wl33;
            this.err_wl33 = this.err_wl16_reg.err_wl33;

        this.err_wl17_reg = ral_reg_mc_wrapper_top_err_wl17_reg::type_id::create("err_wl17_reg",,get_full_name());
        this.err_wl17_reg.configure(this, null, "");
        this.err_wl17_reg.build();
        this.default_map.add_reg(this.err_wl17_reg, `UVM_REG_ADDR_WIDTH'h124,"RW",0);
            this.err_wl17_reg_err_wl34 = this.err_wl17_reg.err_wl34;
            this.err_wl34 = this.err_wl17_reg.err_wl34;

            this.err_wl17_reg_err_wl35 = this.err_wl17_reg.err_wl35;
            this.err_wl35 = this.err_wl17_reg.err_wl35;

        this.err_wl18_reg = ral_reg_mc_wrapper_top_err_wl18_reg::type_id::create("err_wl18_reg",,get_full_name());
        this.err_wl18_reg.configure(this, null, "");
        this.err_wl18_reg.build();
        this.default_map.add_reg(this.err_wl18_reg, `UVM_REG_ADDR_WIDTH'h128,"RW",0);
            this.err_wl18_reg_err_wl36 = this.err_wl18_reg.err_wl36;
            this.err_wl36 = this.err_wl18_reg.err_wl36;

            this.err_wl18_reg_err_wl37 = this.err_wl18_reg.err_wl37;
            this.err_wl37 = this.err_wl18_reg.err_wl37;

        this.err_wl19_reg = ral_reg_mc_wrapper_top_err_wl19_reg::type_id::create("err_wl19_reg",,get_full_name());
        this.err_wl19_reg.configure(this, null, "");
        this.err_wl19_reg.build();
        this.default_map.add_reg(this.err_wl19_reg, `UVM_REG_ADDR_WIDTH'h12C,"RW",0);
            this.err_wl19_reg_err_wl38 = this.err_wl19_reg.err_wl38;
            this.err_wl38 = this.err_wl19_reg.err_wl38;

            this.err_wl19_reg_err_wl39 = this.err_wl19_reg.err_wl39;
            this.err_wl39 = this.err_wl19_reg.err_wl39;

        this.err_wl20_reg = ral_reg_mc_wrapper_top_err_wl20_reg::type_id::create("err_wl20_reg",,get_full_name());
        this.err_wl20_reg.configure(this, null, "");
        this.err_wl20_reg.build();
        this.default_map.add_reg(this.err_wl20_reg, `UVM_REG_ADDR_WIDTH'h130,"RW",0);
            this.err_wl20_reg_err_wl40 = this.err_wl20_reg.err_wl40;
            this.err_wl40 = this.err_wl20_reg.err_wl40;

            this.err_wl20_reg_err_wl41 = this.err_wl20_reg.err_wl41;
            this.err_wl41 = this.err_wl20_reg.err_wl41;

        this.err_wl21_reg = ral_reg_mc_wrapper_top_err_wl21_reg::type_id::create("err_wl21_reg",,get_full_name());
        this.err_wl21_reg.configure(this, null, "");
        this.err_wl21_reg.build();
        this.default_map.add_reg(this.err_wl21_reg, `UVM_REG_ADDR_WIDTH'h134,"RW",0);
            this.err_wl21_reg_err_wl42 = this.err_wl21_reg.err_wl42;
            this.err_wl42 = this.err_wl21_reg.err_wl42;

            this.err_wl21_reg_err_wl43 = this.err_wl21_reg.err_wl43;
            this.err_wl43 = this.err_wl21_reg.err_wl43;

        this.err_wl22_reg = ral_reg_mc_wrapper_top_err_wl22_reg::type_id::create("err_wl22_reg",,get_full_name());
        this.err_wl22_reg.configure(this, null, "");
        this.err_wl22_reg.build();
        this.default_map.add_reg(this.err_wl22_reg, `UVM_REG_ADDR_WIDTH'h138,"RW",0);
            this.err_wl22_reg_err_wl44 = this.err_wl22_reg.err_wl44;
            this.err_wl44 = this.err_wl22_reg.err_wl44;

            this.err_wl22_reg_err_wl45 = this.err_wl22_reg.err_wl45;
            this.err_wl45 = this.err_wl22_reg.err_wl45;

        this.err_wl23_reg = ral_reg_mc_wrapper_top_err_wl23_reg::type_id::create("err_wl23_reg",,get_full_name());
        this.err_wl23_reg.configure(this, null, "");
        this.err_wl23_reg.build();
        this.default_map.add_reg(this.err_wl23_reg, `UVM_REG_ADDR_WIDTH'h13C,"RW",0);
            this.err_wl23_reg_err_wl46 = this.err_wl23_reg.err_wl46;
            this.err_wl46 = this.err_wl23_reg.err_wl46;

            this.err_wl23_reg_err_wl47 = this.err_wl23_reg.err_wl47;
            this.err_wl47 = this.err_wl23_reg.err_wl47;

        this.err_wl24_reg = ral_reg_mc_wrapper_top_err_wl24_reg::type_id::create("err_wl24_reg",,get_full_name());
        this.err_wl24_reg.configure(this, null, "");
        this.err_wl24_reg.build();
        this.default_map.add_reg(this.err_wl24_reg, `UVM_REG_ADDR_WIDTH'h140,"RW",0);
            this.err_wl24_reg_err_wl48 = this.err_wl24_reg.err_wl48;
            this.err_wl48 = this.err_wl24_reg.err_wl48;

            this.err_wl24_reg_err_wl49 = this.err_wl24_reg.err_wl49;
            this.err_wl49 = this.err_wl24_reg.err_wl49;

        this.err_wl25_reg = ral_reg_mc_wrapper_top_err_wl25_reg::type_id::create("err_wl25_reg",,get_full_name());
        this.err_wl25_reg.configure(this, null, "");
        this.err_wl25_reg.build();
        this.default_map.add_reg(this.err_wl25_reg, `UVM_REG_ADDR_WIDTH'h144,"RW",0);
            this.err_wl25_reg_err_wl50 = this.err_wl25_reg.err_wl50;
            this.err_wl50 = this.err_wl25_reg.err_wl50;

            this.err_wl25_reg_err_wl51 = this.err_wl25_reg.err_wl51;
            this.err_wl51 = this.err_wl25_reg.err_wl51;

        this.err_wl26_reg = ral_reg_mc_wrapper_top_err_wl26_reg::type_id::create("err_wl26_reg",,get_full_name());
        this.err_wl26_reg.configure(this, null, "");
        this.err_wl26_reg.build();
        this.default_map.add_reg(this.err_wl26_reg, `UVM_REG_ADDR_WIDTH'h148,"RW",0);
            this.err_wl26_reg_err_wl52 = this.err_wl26_reg.err_wl52;
            this.err_wl52 = this.err_wl26_reg.err_wl52;

            this.err_wl26_reg_err_wl53 = this.err_wl26_reg.err_wl53;
            this.err_wl53 = this.err_wl26_reg.err_wl53;

        this.err_wl27_reg = ral_reg_mc_wrapper_top_err_wl27_reg::type_id::create("err_wl27_reg",,get_full_name());
        this.err_wl27_reg.configure(this, null, "");
        this.err_wl27_reg.build();
        this.default_map.add_reg(this.err_wl27_reg, `UVM_REG_ADDR_WIDTH'h14C,"RW",0);
            this.err_wl27_reg_err_wl54 = this.err_wl27_reg.err_wl54;
            this.err_wl54 = this.err_wl27_reg.err_wl54;

            this.err_wl27_reg_err_wl55 = this.err_wl27_reg.err_wl55;
            this.err_wl55 = this.err_wl27_reg.err_wl55;

        this.err_wl28_reg = ral_reg_mc_wrapper_top_err_wl28_reg::type_id::create("err_wl28_reg",,get_full_name());
        this.err_wl28_reg.configure(this, null, "");
        this.err_wl28_reg.build();
        this.default_map.add_reg(this.err_wl28_reg, `UVM_REG_ADDR_WIDTH'h150,"RW",0);
            this.err_wl28_reg_err_wl56 = this.err_wl28_reg.err_wl56;
            this.err_wl56 = this.err_wl28_reg.err_wl56;

            this.err_wl28_reg_err_wl57 = this.err_wl28_reg.err_wl57;
            this.err_wl57 = this.err_wl28_reg.err_wl57;

        this.err_wl29_reg = ral_reg_mc_wrapper_top_err_wl29_reg::type_id::create("err_wl29_reg",,get_full_name());
        this.err_wl29_reg.configure(this, null, "");
        this.err_wl29_reg.build();
        this.default_map.add_reg(this.err_wl29_reg, `UVM_REG_ADDR_WIDTH'h154,"RW",0);
            this.err_wl29_reg_err_wl58 = this.err_wl29_reg.err_wl58;
            this.err_wl58 = this.err_wl29_reg.err_wl58;

            this.err_wl29_reg_err_wl59 = this.err_wl29_reg.err_wl59;
            this.err_wl59 = this.err_wl29_reg.err_wl59;

        this.err_wl30_reg = ral_reg_mc_wrapper_top_err_wl30_reg::type_id::create("err_wl30_reg",,get_full_name());
        this.err_wl30_reg.configure(this, null, "");
        this.err_wl30_reg.build();
        this.default_map.add_reg(this.err_wl30_reg, `UVM_REG_ADDR_WIDTH'h158,"RW",0);
            this.err_wl30_reg_err_wl60 = this.err_wl30_reg.err_wl60;
            this.err_wl60 = this.err_wl30_reg.err_wl60;

            this.err_wl30_reg_err_wl61 = this.err_wl30_reg.err_wl61;
            this.err_wl61 = this.err_wl30_reg.err_wl61;

        this.err_wl31_reg = ral_reg_mc_wrapper_top_err_wl31_reg::type_id::create("err_wl31_reg",,get_full_name());
        this.err_wl31_reg.configure(this, null, "");
        this.err_wl31_reg.build();
        this.default_map.add_reg(this.err_wl31_reg, `UVM_REG_ADDR_WIDTH'h15C,"RW",0);
            this.err_wl31_reg_err_wl62 = this.err_wl31_reg.err_wl62;
            this.err_wl62 = this.err_wl31_reg.err_wl62;

            this.err_wl31_reg_err_wl63 = this.err_wl31_reg.err_wl63;
            this.err_wl63 = this.err_wl31_reg.err_wl63;

        this.bist_finish_clr_reg = ral_reg_mc_wrapper_top_bist_finish_clr_reg::type_id::create("bist_finish_clr_reg",,get_full_name());
        this.bist_finish_clr_reg.configure(this, null, "");
        this.bist_finish_clr_reg.build();
        this.default_map.add_reg(this.bist_finish_clr_reg, `UVM_REG_ADDR_WIDTH'h160,"RW",0);
            this.bist_finish_clr_reg_bist_finish_clr = this.bist_finish_clr_reg.bist_finish_clr;
            this.bist_finish_clr = this.bist_finish_clr_reg.bist_finish_clr;

        this.bist_finish_mask_reg = ral_reg_mc_wrapper_top_bist_finish_mask_reg::type_id::create("bist_finish_mask_reg",,get_full_name());
        this.bist_finish_mask_reg.configure(this, null, "");
        this.bist_finish_mask_reg.build();
        this.default_map.add_reg(this.bist_finish_mask_reg, `UVM_REG_ADDR_WIDTH'h164,"RW",0);
            this.bist_finish_mask_reg_bist_finish_mask = this.bist_finish_mask_reg.bist_finish_mask;
            this.bist_finish_mask = this.bist_finish_mask_reg.bist_finish_mask;

        this.hang_timeout_th_reg = ral_reg_mc_wrapper_top_hang_timeout_th_reg::type_id::create("hang_timeout_th_reg",,get_full_name());
        this.hang_timeout_th_reg.configure(this, null, "");
        this.hang_timeout_th_reg.build();
        this.default_map.add_reg(this.hang_timeout_th_reg, `UVM_REG_ADDR_WIDTH'h168,"RW",0);
            this.hang_timeout_th_reg_hang_timeout_th = this.hang_timeout_th_reg.hang_timeout_th;
            this.hang_timeout_th = this.hang_timeout_th_reg.hang_timeout_th;

        this.mc_bist_rescan_fail_num_reg = ral_reg_mc_wrapper_top_mc_bist_rescan_fail_num_reg::type_id::create("mc_bist_rescan_fail_num_reg",,get_full_name());
        this.mc_bist_rescan_fail_num_reg.configure(this, null, "");
        this.mc_bist_rescan_fail_num_reg.build();
        this.default_map.add_reg(this.mc_bist_rescan_fail_num_reg, `UVM_REG_ADDR_WIDTH'h16C,"RW",0);
            this.mc_bist_rescan_fail_num_reg_mc_bist_rescan_fail_num = this.mc_bist_rescan_fail_num_reg.mc_bist_rescan_fail_num;
            this.mc_bist_rescan_fail_num = this.mc_bist_rescan_fail_num_reg.mc_bist_rescan_fail_num;

        this.mc_bist_err_wl_reg = ral_reg_mc_wrapper_top_mc_bist_err_wl_reg::type_id::create("mc_bist_err_wl_reg",,get_full_name());
        this.mc_bist_err_wl_reg.configure(this, null, "");
        this.mc_bist_err_wl_reg.build();
        this.default_map.add_reg(this.mc_bist_err_wl_reg, `UVM_REG_ADDR_WIDTH'h170,"RW",0);
            this.mc_bist_err_wl_reg_mc_bist_err_wl_num = this.mc_bist_err_wl_reg.mc_bist_err_wl_num;
            this.mc_bist_err_wl_num = this.mc_bist_err_wl_reg.mc_bist_err_wl_num;

            this.mc_bist_err_wl_reg_err_wl_num_change_flag = this.mc_bist_err_wl_reg.err_wl_num_change_flag;
            this.err_wl_num_change_flag = this.mc_bist_err_wl_reg.err_wl_num_change_flag;

        this.rescan_finish_clr_reg = ral_reg_mc_wrapper_top_rescan_finish_clr_reg::type_id::create("rescan_finish_clr_reg",,get_full_name());
        this.rescan_finish_clr_reg.configure(this, null, "");
        this.rescan_finish_clr_reg.build();
        this.default_map.add_reg(this.rescan_finish_clr_reg, `UVM_REG_ADDR_WIDTH'h174,"RW",0);
            this.rescan_finish_clr_reg_rescan_finish_clr = this.rescan_finish_clr_reg.rescan_finish_clr;
            this.rescan_finish_clr = this.rescan_finish_clr_reg.rescan_finish_clr;

        this.rescan_finish_mask_reg = ral_reg_mc_wrapper_top_rescan_finish_mask_reg::type_id::create("rescan_finish_mask_reg",,get_full_name());
        this.rescan_finish_mask_reg.configure(this, null, "");
        this.rescan_finish_mask_reg.build();
        this.default_map.add_reg(this.rescan_finish_mask_reg, `UVM_REG_ADDR_WIDTH'h178,"RW",0);
            this.rescan_finish_mask_reg_rescan_finish_mask = this.rescan_finish_mask_reg.rescan_finish_mask;
            this.rescan_finish_mask = this.rescan_finish_mask_reg.rescan_finish_mask;

        this.rescan_round_result_reg = ral_reg_mc_wrapper_top_rescan_round_result_reg::type_id::create("rescan_round_result_reg",,get_full_name());
        this.rescan_round_result_reg.configure(this, null, "");
        this.rescan_round_result_reg.build();
        this.default_map.add_reg(this.rescan_round_result_reg, `UVM_REG_ADDR_WIDTH'h17C,"RW",0);
            this.rescan_round_result_reg_rescan_round_result = this.rescan_round_result_reg.rescan_round_result;
            this.rescan_round_result = this.rescan_round_result_reg.rescan_round_result;

        this.dbg_frame_store_0_reg = ral_reg_mc_wrapper_top_dbg_frame_store_0_reg::type_id::create("dbg_frame_store_0_reg",,get_full_name());
        this.dbg_frame_store_0_reg.configure(this, null, "");
        this.dbg_frame_store_0_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_0_reg, `UVM_REG_ADDR_WIDTH'h180,"RW",0);
            this.dbg_frame_store_0_reg_dbg_frame_store_0 = this.dbg_frame_store_0_reg.dbg_frame_store_0;
            this.dbg_frame_store_0 = this.dbg_frame_store_0_reg.dbg_frame_store_0;

        this.dbg_frame_store_1_reg = ral_reg_mc_wrapper_top_dbg_frame_store_1_reg::type_id::create("dbg_frame_store_1_reg",,get_full_name());
        this.dbg_frame_store_1_reg.configure(this, null, "");
        this.dbg_frame_store_1_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_1_reg, `UVM_REG_ADDR_WIDTH'h184,"RW",0);
            this.dbg_frame_store_1_reg_dbg_frame_store_1 = this.dbg_frame_store_1_reg.dbg_frame_store_1;
            this.dbg_frame_store_1 = this.dbg_frame_store_1_reg.dbg_frame_store_1;

        this.dbg_frame_store_2_reg = ral_reg_mc_wrapper_top_dbg_frame_store_2_reg::type_id::create("dbg_frame_store_2_reg",,get_full_name());
        this.dbg_frame_store_2_reg.configure(this, null, "");
        this.dbg_frame_store_2_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_2_reg, `UVM_REG_ADDR_WIDTH'h188,"RW",0);
            this.dbg_frame_store_2_reg_dbg_frame_store_2 = this.dbg_frame_store_2_reg.dbg_frame_store_2;
            this.dbg_frame_store_2 = this.dbg_frame_store_2_reg.dbg_frame_store_2;

        this.dbg_frame_store_3_reg = ral_reg_mc_wrapper_top_dbg_frame_store_3_reg::type_id::create("dbg_frame_store_3_reg",,get_full_name());
        this.dbg_frame_store_3_reg.configure(this, null, "");
        this.dbg_frame_store_3_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_3_reg, `UVM_REG_ADDR_WIDTH'h18C,"RW",0);
            this.dbg_frame_store_3_reg_dbg_frame_store_3 = this.dbg_frame_store_3_reg.dbg_frame_store_3;
            this.dbg_frame_store_3 = this.dbg_frame_store_3_reg.dbg_frame_store_3;

        this.dbg_frame_store_4_reg = ral_reg_mc_wrapper_top_dbg_frame_store_4_reg::type_id::create("dbg_frame_store_4_reg",,get_full_name());
        this.dbg_frame_store_4_reg.configure(this, null, "");
        this.dbg_frame_store_4_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_4_reg, `UVM_REG_ADDR_WIDTH'h190,"RW",0);
            this.dbg_frame_store_4_reg_dbg_frame_store_4 = this.dbg_frame_store_4_reg.dbg_frame_store_4;
            this.dbg_frame_store_4 = this.dbg_frame_store_4_reg.dbg_frame_store_4;

        this.dbg_frame_store_5_reg = ral_reg_mc_wrapper_top_dbg_frame_store_5_reg::type_id::create("dbg_frame_store_5_reg",,get_full_name());
        this.dbg_frame_store_5_reg.configure(this, null, "");
        this.dbg_frame_store_5_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_5_reg, `UVM_REG_ADDR_WIDTH'h194,"RW",0);
            this.dbg_frame_store_5_reg_dbg_frame_store_5 = this.dbg_frame_store_5_reg.dbg_frame_store_5;
            this.dbg_frame_store_5 = this.dbg_frame_store_5_reg.dbg_frame_store_5;

        this.dbg_frame_store_6_reg = ral_reg_mc_wrapper_top_dbg_frame_store_6_reg::type_id::create("dbg_frame_store_6_reg",,get_full_name());
        this.dbg_frame_store_6_reg.configure(this, null, "");
        this.dbg_frame_store_6_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_6_reg, `UVM_REG_ADDR_WIDTH'h198,"RW",0);
            this.dbg_frame_store_6_reg_dbg_frame_store_6 = this.dbg_frame_store_6_reg.dbg_frame_store_6;
            this.dbg_frame_store_6 = this.dbg_frame_store_6_reg.dbg_frame_store_6;

        this.dbg_frame_store_7_reg = ral_reg_mc_wrapper_top_dbg_frame_store_7_reg::type_id::create("dbg_frame_store_7_reg",,get_full_name());
        this.dbg_frame_store_7_reg.configure(this, null, "");
        this.dbg_frame_store_7_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_7_reg, `UVM_REG_ADDR_WIDTH'h19C,"RW",0);
            this.dbg_frame_store_7_reg_dbg_frame_store_7 = this.dbg_frame_store_7_reg.dbg_frame_store_7;
            this.dbg_frame_store_7 = this.dbg_frame_store_7_reg.dbg_frame_store_7;

        this.dbg_frame_store_8_reg = ral_reg_mc_wrapper_top_dbg_frame_store_8_reg::type_id::create("dbg_frame_store_8_reg",,get_full_name());
        this.dbg_frame_store_8_reg.configure(this, null, "");
        this.dbg_frame_store_8_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_8_reg, `UVM_REG_ADDR_WIDTH'h1A0,"RW",0);
            this.dbg_frame_store_8_reg_dbg_frame_store_8 = this.dbg_frame_store_8_reg.dbg_frame_store_8;
            this.dbg_frame_store_8 = this.dbg_frame_store_8_reg.dbg_frame_store_8;

        this.dbg_frame_store_9_reg = ral_reg_mc_wrapper_top_dbg_frame_store_9_reg::type_id::create("dbg_frame_store_9_reg",,get_full_name());
        this.dbg_frame_store_9_reg.configure(this, null, "");
        this.dbg_frame_store_9_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_9_reg, `UVM_REG_ADDR_WIDTH'h1A4,"RW",0);
            this.dbg_frame_store_9_reg_dbg_frame_store_9 = this.dbg_frame_store_9_reg.dbg_frame_store_9;
            this.dbg_frame_store_9 = this.dbg_frame_store_9_reg.dbg_frame_store_9;

        this.dbg_rdata_store_0_reg = ral_reg_mc_wrapper_top_dbg_rdata_store_0_reg::type_id::create("dbg_rdata_store_0_reg",,get_full_name());
        this.dbg_rdata_store_0_reg.configure(this, null, "");
        this.dbg_rdata_store_0_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_0_reg, `UVM_REG_ADDR_WIDTH'h1A8,"RW",0);
            this.dbg_rdata_store_0_reg_dbg_rdata_store_0 = this.dbg_rdata_store_0_reg.dbg_rdata_store_0;
            this.dbg_rdata_store_0 = this.dbg_rdata_store_0_reg.dbg_rdata_store_0;

        this.dbg_rdata_store_1_reg = ral_reg_mc_wrapper_top_dbg_rdata_store_1_reg::type_id::create("dbg_rdata_store_1_reg",,get_full_name());
        this.dbg_rdata_store_1_reg.configure(this, null, "");
        this.dbg_rdata_store_1_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_1_reg, `UVM_REG_ADDR_WIDTH'h1AC,"RW",0);
            this.dbg_rdata_store_1_reg_dbg_rdata_store_1 = this.dbg_rdata_store_1_reg.dbg_rdata_store_1;
            this.dbg_rdata_store_1 = this.dbg_rdata_store_1_reg.dbg_rdata_store_1;

        this.dbg_rdata_store_2_reg = ral_reg_mc_wrapper_top_dbg_rdata_store_2_reg::type_id::create("dbg_rdata_store_2_reg",,get_full_name());
        this.dbg_rdata_store_2_reg.configure(this, null, "");
        this.dbg_rdata_store_2_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_2_reg, `UVM_REG_ADDR_WIDTH'h1B0,"RW",0);
            this.dbg_rdata_store_2_reg_dbg_rdata_store_2 = this.dbg_rdata_store_2_reg.dbg_rdata_store_2;
            this.dbg_rdata_store_2 = this.dbg_rdata_store_2_reg.dbg_rdata_store_2;

        this.dbg_rdata_store_3_reg = ral_reg_mc_wrapper_top_dbg_rdata_store_3_reg::type_id::create("dbg_rdata_store_3_reg",,get_full_name());
        this.dbg_rdata_store_3_reg.configure(this, null, "");
        this.dbg_rdata_store_3_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_3_reg, `UVM_REG_ADDR_WIDTH'h1B4,"RW",0);
            this.dbg_rdata_store_3_reg_dbg_rdata_store_3 = this.dbg_rdata_store_3_reg.dbg_rdata_store_3;
            this.dbg_rdata_store_3 = this.dbg_rdata_store_3_reg.dbg_rdata_store_3;

        this.dbg_rdata_store_4_reg = ral_reg_mc_wrapper_top_dbg_rdata_store_4_reg::type_id::create("dbg_rdata_store_4_reg",,get_full_name());
        this.dbg_rdata_store_4_reg.configure(this, null, "");
        this.dbg_rdata_store_4_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_4_reg, `UVM_REG_ADDR_WIDTH'h1B8,"RW",0);
            this.dbg_rdata_store_4_reg_dbg_rdata_store_4 = this.dbg_rdata_store_4_reg.dbg_rdata_store_4;
            this.dbg_rdata_store_4 = this.dbg_rdata_store_4_reg.dbg_rdata_store_4;

        this.dbg_rdata_store_5_reg = ral_reg_mc_wrapper_top_dbg_rdata_store_5_reg::type_id::create("dbg_rdata_store_5_reg",,get_full_name());
        this.dbg_rdata_store_5_reg.configure(this, null, "");
        this.dbg_rdata_store_5_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_5_reg, `UVM_REG_ADDR_WIDTH'h1BC,"RW",0);
            this.dbg_rdata_store_5_reg_dbg_rdata_store_5 = this.dbg_rdata_store_5_reg.dbg_rdata_store_5;
            this.dbg_rdata_store_5 = this.dbg_rdata_store_5_reg.dbg_rdata_store_5;

        this.dbg_rdata_store_6_reg = ral_reg_mc_wrapper_top_dbg_rdata_store_6_reg::type_id::create("dbg_rdata_store_6_reg",,get_full_name());
        this.dbg_rdata_store_6_reg.configure(this, null, "");
        this.dbg_rdata_store_6_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_6_reg, `UVM_REG_ADDR_WIDTH'h1C0,"RW",0);
            this.dbg_rdata_store_6_reg_dbg_rdata_store_6 = this.dbg_rdata_store_6_reg.dbg_rdata_store_6;
            this.dbg_rdata_store_6 = this.dbg_rdata_store_6_reg.dbg_rdata_store_6;

        this.dbg_rdata_store_7_reg = ral_reg_mc_wrapper_top_dbg_rdata_store_7_reg::type_id::create("dbg_rdata_store_7_reg",,get_full_name());
        this.dbg_rdata_store_7_reg.configure(this, null, "");
        this.dbg_rdata_store_7_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_7_reg, `UVM_REG_ADDR_WIDTH'h1C4,"RW",0);
            this.dbg_rdata_store_7_reg_dbg_rdata_store_7 = this.dbg_rdata_store_7_reg.dbg_rdata_store_7;
            this.dbg_rdata_store_7 = this.dbg_rdata_store_7_reg.dbg_rdata_store_7;

        this.dbg_rdata_store_8_reg = ral_reg_mc_wrapper_top_dbg_rdata_store_8_reg::type_id::create("dbg_rdata_store_8_reg",,get_full_name());
        this.dbg_rdata_store_8_reg.configure(this, null, "");
        this.dbg_rdata_store_8_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_8_reg, `UVM_REG_ADDR_WIDTH'h1C8,"RW",0);
            this.dbg_rdata_store_8_reg_dbg_rdata_store_8 = this.dbg_rdata_store_8_reg.dbg_rdata_store_8;
            this.dbg_rdata_store_8 = this.dbg_rdata_store_8_reg.dbg_rdata_store_8;

        this.bist_pattern_reg0_reg = ral_reg_mc_wrapper_top_bist_pattern_reg0_reg::type_id::create("bist_pattern_reg0_reg",,get_full_name());
        this.bist_pattern_reg0_reg.configure(this, null, "");
        this.bist_pattern_reg0_reg.build();
        this.default_map.add_reg(this.bist_pattern_reg0_reg, `UVM_REG_ADDR_WIDTH'h1CC,"RW",0);
            this.bist_pattern_reg0_reg_bist_pattern_reg0 = this.bist_pattern_reg0_reg.bist_pattern_reg0;
            this.bist_pattern_reg0 = this.bist_pattern_reg0_reg.bist_pattern_reg0;

        this.bist_pattern_reg1_reg = ral_reg_mc_wrapper_top_bist_pattern_reg1_reg::type_id::create("bist_pattern_reg1_reg",,get_full_name());
        this.bist_pattern_reg1_reg.configure(this, null, "");
        this.bist_pattern_reg1_reg.build();
        this.default_map.add_reg(this.bist_pattern_reg1_reg, `UVM_REG_ADDR_WIDTH'h1D0,"RW",0);
            this.bist_pattern_reg1_reg_bist_pattern_reg1 = this.bist_pattern_reg1_reg.bist_pattern_reg1;
            this.bist_pattern_reg1 = this.bist_pattern_reg1_reg.bist_pattern_reg1;

        this.bist_pattern_reg2_reg = ral_reg_mc_wrapper_top_bist_pattern_reg2_reg::type_id::create("bist_pattern_reg2_reg",,get_full_name());
        this.bist_pattern_reg2_reg.configure(this, null, "");
        this.bist_pattern_reg2_reg.build();
        this.default_map.add_reg(this.bist_pattern_reg2_reg, `UVM_REG_ADDR_WIDTH'h1D4,"RW",0);
            this.bist_pattern_reg2_reg_bist_pattern_reg2 = this.bist_pattern_reg2_reg.bist_pattern_reg2;
            this.bist_pattern_reg2 = this.bist_pattern_reg2_reg.bist_pattern_reg2;

        this.bist_pattern_reg3_reg = ral_reg_mc_wrapper_top_bist_pattern_reg3_reg::type_id::create("bist_pattern_reg3_reg",,get_full_name());
        this.bist_pattern_reg3_reg.configure(this, null, "");
        this.bist_pattern_reg3_reg.build();
        this.default_map.add_reg(this.bist_pattern_reg3_reg, `UVM_REG_ADDR_WIDTH'h1D8,"RW",0);
            this.bist_pattern_reg3_reg_bist_pattern_reg3 = this.bist_pattern_reg3_reg.bist_pattern_reg3;
            this.bist_pattern_reg3 = this.bist_pattern_reg3_reg.bist_pattern_reg3;

        this.csl_bist_pattern_sel0_reg = ral_reg_mc_wrapper_top_csl_bist_pattern_sel0_reg::type_id::create("csl_bist_pattern_sel0_reg",,get_full_name());
        this.csl_bist_pattern_sel0_reg.configure(this, null, "");
        this.csl_bist_pattern_sel0_reg.build();
        this.default_map.add_reg(this.csl_bist_pattern_sel0_reg, `UVM_REG_ADDR_WIDTH'h1DC,"RW",0);
            this.csl_bist_pattern_sel0_reg_csl_bist_pattern_sel0 = this.csl_bist_pattern_sel0_reg.csl_bist_pattern_sel0;
            this.csl_bist_pattern_sel0 = this.csl_bist_pattern_sel0_reg.csl_bist_pattern_sel0;

        this.csl_bist_pattern_sel1_reg = ral_reg_mc_wrapper_top_csl_bist_pattern_sel1_reg::type_id::create("csl_bist_pattern_sel1_reg",,get_full_name());
        this.csl_bist_pattern_sel1_reg.configure(this, null, "");
        this.csl_bist_pattern_sel1_reg.build();
        this.default_map.add_reg(this.csl_bist_pattern_sel1_reg, `UVM_REG_ADDR_WIDTH'h1E0,"RW",0);
            this.csl_bist_pattern_sel1_reg_csl_bist_pattern_sel1 = this.csl_bist_pattern_sel1_reg.csl_bist_pattern_sel1;
            this.csl_bist_pattern_sel1 = this.csl_bist_pattern_sel1_reg.csl_bist_pattern_sel1;

        this.csl_bist_pattern_sel2_reg = ral_reg_mc_wrapper_top_csl_bist_pattern_sel2_reg::type_id::create("csl_bist_pattern_sel2_reg",,get_full_name());
        this.csl_bist_pattern_sel2_reg.configure(this, null, "");
        this.csl_bist_pattern_sel2_reg.build();
        this.default_map.add_reg(this.csl_bist_pattern_sel2_reg, `UVM_REG_ADDR_WIDTH'h1E4,"RW",0);
            this.csl_bist_pattern_sel2_reg_csl_bist_pattern_sel2 = this.csl_bist_pattern_sel2_reg.csl_bist_pattern_sel2;
            this.csl_bist_pattern_sel2 = this.csl_bist_pattern_sel2_reg.csl_bist_pattern_sel2;

        this.wl_bist_pattern_sel0_reg = ral_reg_mc_wrapper_top_wl_bist_pattern_sel0_reg::type_id::create("wl_bist_pattern_sel0_reg",,get_full_name());
        this.wl_bist_pattern_sel0_reg.configure(this, null, "");
        this.wl_bist_pattern_sel0_reg.build();
        this.default_map.add_reg(this.wl_bist_pattern_sel0_reg, `UVM_REG_ADDR_WIDTH'h1E8,"RW",0);
            this.wl_bist_pattern_sel0_reg_wl_bist_pattern_sel0 = this.wl_bist_pattern_sel0_reg.wl_bist_pattern_sel0;
            this.wl_bist_pattern_sel0 = this.wl_bist_pattern_sel0_reg.wl_bist_pattern_sel0;

        this.wl_bist_pattern_sel1_reg = ral_reg_mc_wrapper_top_wl_bist_pattern_sel1_reg::type_id::create("wl_bist_pattern_sel1_reg",,get_full_name());
        this.wl_bist_pattern_sel1_reg.configure(this, null, "");
        this.wl_bist_pattern_sel1_reg.build();
        this.default_map.add_reg(this.wl_bist_pattern_sel1_reg, `UVM_REG_ADDR_WIDTH'h1EC,"RW",0);
            this.wl_bist_pattern_sel1_reg_wl_bist_pattern_sel1 = this.wl_bist_pattern_sel1_reg.wl_bist_pattern_sel1;
            this.wl_bist_pattern_sel1 = this.wl_bist_pattern_sel1_reg.wl_bist_pattern_sel1;

        this.wl_bist_pattern_sel2_reg = ral_reg_mc_wrapper_top_wl_bist_pattern_sel2_reg::type_id::create("wl_bist_pattern_sel2_reg",,get_full_name());
        this.wl_bist_pattern_sel2_reg.configure(this, null, "");
        this.wl_bist_pattern_sel2_reg.build();
        this.default_map.add_reg(this.wl_bist_pattern_sel2_reg, `UVM_REG_ADDR_WIDTH'h1F0,"RW",0);
            this.wl_bist_pattern_sel2_reg_wl_bist_pattern_sel2 = this.wl_bist_pattern_sel2_reg.wl_bist_pattern_sel2;
            this.wl_bist_pattern_sel2 = this.wl_bist_pattern_sel2_reg.wl_bist_pattern_sel2;

        this.mc_ecc_ctrl_reg = ral_reg_mc_wrapper_top_mc_ecc_ctrl_reg::type_id::create("mc_ecc_ctrl_reg",,get_full_name());
        this.mc_ecc_ctrl_reg.configure(this, null, "");
        this.mc_ecc_ctrl_reg.build();
        this.default_map.add_reg(this.mc_ecc_ctrl_reg, `UVM_REG_ADDR_WIDTH'h1F4,"RW",0);
            this.mc_ecc_ctrl_reg_mc_ecc_en = this.mc_ecc_ctrl_reg.mc_ecc_en;
            this.mc_ecc_en = this.mc_ecc_ctrl_reg.mc_ecc_en;

            this.mc_ecc_ctrl_reg_mc_ecc_ce_th = this.mc_ecc_ctrl_reg.mc_ecc_ce_th;
            this.mc_ecc_ce_th = this.mc_ecc_ctrl_reg.mc_ecc_ce_th;

            this.mc_ecc_ctrl_reg_mc_ecc_ce_int_clr = this.mc_ecc_ctrl_reg.mc_ecc_ce_int_clr;
            this.mc_ecc_ce_int_clr = this.mc_ecc_ctrl_reg.mc_ecc_ce_int_clr;

            this.mc_ecc_ctrl_reg_mc_ecc_ce_int_mask = this.mc_ecc_ctrl_reg.mc_ecc_ce_int_mask;
            this.mc_ecc_ce_int_mask = this.mc_ecc_ctrl_reg.mc_ecc_ce_int_mask;

            this.mc_ecc_ctrl_reg_mc_ecc_uce_int_clr = this.mc_ecc_ctrl_reg.mc_ecc_uce_int_clr;
            this.mc_ecc_uce_int_clr = this.mc_ecc_ctrl_reg.mc_ecc_uce_int_clr;

            this.mc_ecc_ctrl_reg_mc_ecc_uce_int_mask = this.mc_ecc_ctrl_reg.mc_ecc_uce_int_mask;
            this.mc_ecc_uce_int_mask = this.mc_ecc_ctrl_reg.mc_ecc_uce_int_mask;

        this.mc_ecc_int_status_reg = ral_reg_mc_wrapper_top_mc_ecc_int_status_reg::type_id::create("mc_ecc_int_status_reg",,get_full_name());
        this.mc_ecc_int_status_reg.configure(this, null, "");
        this.mc_ecc_int_status_reg.build();
        this.default_map.add_reg(this.mc_ecc_int_status_reg, `UVM_REG_ADDR_WIDTH'h1F8,"RW",0);
            this.mc_ecc_int_status_reg_mc_ecc_ce_int_status = this.mc_ecc_int_status_reg.mc_ecc_ce_int_status;
            this.mc_ecc_ce_int_status = this.mc_ecc_int_status_reg.mc_ecc_ce_int_status;

            this.mc_ecc_int_status_reg_mc_ecc_uce_int_status = this.mc_ecc_int_status_reg.mc_ecc_uce_int_status;
            this.mc_ecc_uce_int_status = this.mc_ecc_int_status_reg.mc_ecc_uce_int_status;

            this.mc_ecc_int_status_reg_mc_ecc_ce_cnt = this.mc_ecc_int_status_reg.mc_ecc_ce_cnt;
            this.mc_ecc_ce_cnt = this.mc_ecc_int_status_reg.mc_ecc_ce_cnt;

        this.mc_ecc_ce_addr0_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr0_reg::type_id::create("mc_ecc_ce_addr0_reg",,get_full_name());
        this.mc_ecc_ce_addr0_reg.configure(this, null, "");
        this.mc_ecc_ce_addr0_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr0_reg, `UVM_REG_ADDR_WIDTH'h1FC,"RW",0);
            this.mc_ecc_ce_addr0_reg_mc_ecc_ce_addr0 = this.mc_ecc_ce_addr0_reg.mc_ecc_ce_addr0;
            this.mc_ecc_ce_addr0 = this.mc_ecc_ce_addr0_reg.mc_ecc_ce_addr0;

        this.mc_ecc_ce_addr1_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr1_reg::type_id::create("mc_ecc_ce_addr1_reg",,get_full_name());
        this.mc_ecc_ce_addr1_reg.configure(this, null, "");
        this.mc_ecc_ce_addr1_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr1_reg, `UVM_REG_ADDR_WIDTH'h200,"RW",0);
            this.mc_ecc_ce_addr1_reg_mc_ecc_ce_addr1 = this.mc_ecc_ce_addr1_reg.mc_ecc_ce_addr1;
            this.mc_ecc_ce_addr1 = this.mc_ecc_ce_addr1_reg.mc_ecc_ce_addr1;

        this.mc_ecc_ce_addr2_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr2_reg::type_id::create("mc_ecc_ce_addr2_reg",,get_full_name());
        this.mc_ecc_ce_addr2_reg.configure(this, null, "");
        this.mc_ecc_ce_addr2_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr2_reg, `UVM_REG_ADDR_WIDTH'h204,"RW",0);
            this.mc_ecc_ce_addr2_reg_mc_ecc_ce_addr2 = this.mc_ecc_ce_addr2_reg.mc_ecc_ce_addr2;
            this.mc_ecc_ce_addr2 = this.mc_ecc_ce_addr2_reg.mc_ecc_ce_addr2;

        this.mc_ecc_ce_addr3_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr3_reg::type_id::create("mc_ecc_ce_addr3_reg",,get_full_name());
        this.mc_ecc_ce_addr3_reg.configure(this, null, "");
        this.mc_ecc_ce_addr3_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr3_reg, `UVM_REG_ADDR_WIDTH'h208,"RW",0);
            this.mc_ecc_ce_addr3_reg_mc_ecc_ce_addr3 = this.mc_ecc_ce_addr3_reg.mc_ecc_ce_addr3;
            this.mc_ecc_ce_addr3 = this.mc_ecc_ce_addr3_reg.mc_ecc_ce_addr3;

        this.mc_ecc_ce_addr4_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr4_reg::type_id::create("mc_ecc_ce_addr4_reg",,get_full_name());
        this.mc_ecc_ce_addr4_reg.configure(this, null, "");
        this.mc_ecc_ce_addr4_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr4_reg, `UVM_REG_ADDR_WIDTH'h20C,"RW",0);
            this.mc_ecc_ce_addr4_reg_mc_ecc_ce_addr4 = this.mc_ecc_ce_addr4_reg.mc_ecc_ce_addr4;
            this.mc_ecc_ce_addr4 = this.mc_ecc_ce_addr4_reg.mc_ecc_ce_addr4;

        this.mc_ecc_ce_addr5_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr5_reg::type_id::create("mc_ecc_ce_addr5_reg",,get_full_name());
        this.mc_ecc_ce_addr5_reg.configure(this, null, "");
        this.mc_ecc_ce_addr5_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr5_reg, `UVM_REG_ADDR_WIDTH'h210,"RW",0);
            this.mc_ecc_ce_addr5_reg_mc_ecc_ce_addr5 = this.mc_ecc_ce_addr5_reg.mc_ecc_ce_addr5;
            this.mc_ecc_ce_addr5 = this.mc_ecc_ce_addr5_reg.mc_ecc_ce_addr5;

        this.mc_ecc_ce_addr6_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr6_reg::type_id::create("mc_ecc_ce_addr6_reg",,get_full_name());
        this.mc_ecc_ce_addr6_reg.configure(this, null, "");
        this.mc_ecc_ce_addr6_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr6_reg, `UVM_REG_ADDR_WIDTH'h214,"RW",0);
            this.mc_ecc_ce_addr6_reg_mc_ecc_ce_addr6 = this.mc_ecc_ce_addr6_reg.mc_ecc_ce_addr6;
            this.mc_ecc_ce_addr6 = this.mc_ecc_ce_addr6_reg.mc_ecc_ce_addr6;

        this.mc_ecc_ce_addr7_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr7_reg::type_id::create("mc_ecc_ce_addr7_reg",,get_full_name());
        this.mc_ecc_ce_addr7_reg.configure(this, null, "");
        this.mc_ecc_ce_addr7_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr7_reg, `UVM_REG_ADDR_WIDTH'h218,"RW",0);
            this.mc_ecc_ce_addr7_reg_mc_ecc_ce_addr7 = this.mc_ecc_ce_addr7_reg.mc_ecc_ce_addr7;
            this.mc_ecc_ce_addr7 = this.mc_ecc_ce_addr7_reg.mc_ecc_ce_addr7;

        this.mc_ecc_ce_addr8_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr8_reg::type_id::create("mc_ecc_ce_addr8_reg",,get_full_name());
        this.mc_ecc_ce_addr8_reg.configure(this, null, "");
        this.mc_ecc_ce_addr8_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr8_reg, `UVM_REG_ADDR_WIDTH'h21C,"RW",0);
            this.mc_ecc_ce_addr8_reg_mc_ecc_ce_addr8 = this.mc_ecc_ce_addr8_reg.mc_ecc_ce_addr8;
            this.mc_ecc_ce_addr8 = this.mc_ecc_ce_addr8_reg.mc_ecc_ce_addr8;

        this.mc_ecc_ce_addr9_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr9_reg::type_id::create("mc_ecc_ce_addr9_reg",,get_full_name());
        this.mc_ecc_ce_addr9_reg.configure(this, null, "");
        this.mc_ecc_ce_addr9_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr9_reg, `UVM_REG_ADDR_WIDTH'h220,"RW",0);
            this.mc_ecc_ce_addr9_reg_mc_ecc_ce_addr9 = this.mc_ecc_ce_addr9_reg.mc_ecc_ce_addr9;
            this.mc_ecc_ce_addr9 = this.mc_ecc_ce_addr9_reg.mc_ecc_ce_addr9;

        this.mc_ecc_ce_addr10_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr10_reg::type_id::create("mc_ecc_ce_addr10_reg",,get_full_name());
        this.mc_ecc_ce_addr10_reg.configure(this, null, "");
        this.mc_ecc_ce_addr10_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr10_reg, `UVM_REG_ADDR_WIDTH'h224,"RW",0);
            this.mc_ecc_ce_addr10_reg_mc_ecc_ce_addr10 = this.mc_ecc_ce_addr10_reg.mc_ecc_ce_addr10;
            this.mc_ecc_ce_addr10 = this.mc_ecc_ce_addr10_reg.mc_ecc_ce_addr10;

        this.mc_ecc_ce_addr11_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr11_reg::type_id::create("mc_ecc_ce_addr11_reg",,get_full_name());
        this.mc_ecc_ce_addr11_reg.configure(this, null, "");
        this.mc_ecc_ce_addr11_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr11_reg, `UVM_REG_ADDR_WIDTH'h228,"RW",0);
            this.mc_ecc_ce_addr11_reg_mc_ecc_ce_addr11 = this.mc_ecc_ce_addr11_reg.mc_ecc_ce_addr11;
            this.mc_ecc_ce_addr11 = this.mc_ecc_ce_addr11_reg.mc_ecc_ce_addr11;

        this.mc_ecc_ce_addr12_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr12_reg::type_id::create("mc_ecc_ce_addr12_reg",,get_full_name());
        this.mc_ecc_ce_addr12_reg.configure(this, null, "");
        this.mc_ecc_ce_addr12_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr12_reg, `UVM_REG_ADDR_WIDTH'h22C,"RW",0);
            this.mc_ecc_ce_addr12_reg_mc_ecc_ce_addr12 = this.mc_ecc_ce_addr12_reg.mc_ecc_ce_addr12;
            this.mc_ecc_ce_addr12 = this.mc_ecc_ce_addr12_reg.mc_ecc_ce_addr12;

        this.mc_ecc_ce_addr13_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr13_reg::type_id::create("mc_ecc_ce_addr13_reg",,get_full_name());
        this.mc_ecc_ce_addr13_reg.configure(this, null, "");
        this.mc_ecc_ce_addr13_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr13_reg, `UVM_REG_ADDR_WIDTH'h230,"RW",0);
            this.mc_ecc_ce_addr13_reg_mc_ecc_ce_addr13 = this.mc_ecc_ce_addr13_reg.mc_ecc_ce_addr13;
            this.mc_ecc_ce_addr13 = this.mc_ecc_ce_addr13_reg.mc_ecc_ce_addr13;

        this.mc_ecc_ce_addr14_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr14_reg::type_id::create("mc_ecc_ce_addr14_reg",,get_full_name());
        this.mc_ecc_ce_addr14_reg.configure(this, null, "");
        this.mc_ecc_ce_addr14_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr14_reg, `UVM_REG_ADDR_WIDTH'h234,"RW",0);
            this.mc_ecc_ce_addr14_reg_mc_ecc_ce_addr14 = this.mc_ecc_ce_addr14_reg.mc_ecc_ce_addr14;
            this.mc_ecc_ce_addr14 = this.mc_ecc_ce_addr14_reg.mc_ecc_ce_addr14;

        this.mc_ecc_ce_addr15_reg = ral_reg_mc_wrapper_top_mc_ecc_ce_addr15_reg::type_id::create("mc_ecc_ce_addr15_reg",,get_full_name());
        this.mc_ecc_ce_addr15_reg.configure(this, null, "");
        this.mc_ecc_ce_addr15_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr15_reg, `UVM_REG_ADDR_WIDTH'h238,"RW",0);
            this.mc_ecc_ce_addr15_reg_mc_ecc_ce_addr15 = this.mc_ecc_ce_addr15_reg.mc_ecc_ce_addr15;
            this.mc_ecc_ce_addr15 = this.mc_ecc_ce_addr15_reg.mc_ecc_ce_addr15;

        this.mc_ecc_uce_addr0_reg = ral_reg_mc_wrapper_top_mc_ecc_uce_addr0_reg::type_id::create("mc_ecc_uce_addr0_reg",,get_full_name());
        this.mc_ecc_uce_addr0_reg.configure(this, null, "");
        this.mc_ecc_uce_addr0_reg.build();
        this.default_map.add_reg(this.mc_ecc_uce_addr0_reg, `UVM_REG_ADDR_WIDTH'h23C,"RW",0);
            this.mc_ecc_uce_addr0_reg_mc_ecc_uce_addr0 = this.mc_ecc_uce_addr0_reg.mc_ecc_uce_addr0;
            this.mc_ecc_uce_addr0 = this.mc_ecc_uce_addr0_reg.mc_ecc_uce_addr0;

        this.mc_ecc_uce_addr1_reg = ral_reg_mc_wrapper_top_mc_ecc_uce_addr1_reg::type_id::create("mc_ecc_uce_addr1_reg",,get_full_name());
        this.mc_ecc_uce_addr1_reg.configure(this, null, "");
        this.mc_ecc_uce_addr1_reg.build();
        this.default_map.add_reg(this.mc_ecc_uce_addr1_reg, `UVM_REG_ADDR_WIDTH'h240,"RW",0);
            this.mc_ecc_uce_addr1_reg_mc_ecc_uce_addr1 = this.mc_ecc_uce_addr1_reg.mc_ecc_uce_addr1;
            this.mc_ecc_uce_addr1 = this.mc_ecc_uce_addr1_reg.mc_ecc_uce_addr1;

        this.mc_ecc_uce_addr2_reg = ral_reg_mc_wrapper_top_mc_ecc_uce_addr2_reg::type_id::create("mc_ecc_uce_addr2_reg",,get_full_name());
        this.mc_ecc_uce_addr2_reg.configure(this, null, "");
        this.mc_ecc_uce_addr2_reg.build();
        this.default_map.add_reg(this.mc_ecc_uce_addr2_reg, `UVM_REG_ADDR_WIDTH'h244,"RW",0);
            this.mc_ecc_uce_addr2_reg_mc_ecc_uce_addr2 = this.mc_ecc_uce_addr2_reg.mc_ecc_uce_addr2;
            this.mc_ecc_uce_addr2 = this.mc_ecc_uce_addr2_reg.mc_ecc_uce_addr2;

        this.mc_ecc_uce_addr3_reg = ral_reg_mc_wrapper_top_mc_ecc_uce_addr3_reg::type_id::create("mc_ecc_uce_addr3_reg",,get_full_name());
        this.mc_ecc_uce_addr3_reg.configure(this, null, "");
        this.mc_ecc_uce_addr3_reg.build();
        this.default_map.add_reg(this.mc_ecc_uce_addr3_reg, `UVM_REG_ADDR_WIDTH'h248,"RW",0);
            this.mc_ecc_uce_addr3_reg_mc_ecc_uce_addr3 = this.mc_ecc_uce_addr3_reg.mc_ecc_uce_addr3;
            this.mc_ecc_uce_addr3 = this.mc_ecc_uce_addr3_reg.mc_ecc_uce_addr3;

        this.bist_scan_ctrl_reg = ral_reg_mc_wrapper_top_bist_scan_ctrl_reg::type_id::create("bist_scan_ctrl_reg",,get_full_name());
        this.bist_scan_ctrl_reg.configure(this, null, "");
        this.bist_scan_ctrl_reg.build();
        this.default_map.add_reg(this.bist_scan_ctrl_reg, `UVM_REG_ADDR_WIDTH'h24C,"RW",0);
            this.bist_scan_ctrl_reg_bist_scan_start_bank = this.bist_scan_ctrl_reg.bist_scan_start_bank;
            this.bist_scan_start_bank = this.bist_scan_ctrl_reg.bist_scan_start_bank;

            this.bist_scan_ctrl_reg_bist_scan_end_bank = this.bist_scan_ctrl_reg.bist_scan_end_bank;
            this.bist_scan_end_bank = this.bist_scan_ctrl_reg.bist_scan_end_bank;

        this.axi2frame_dbg0_reg = ral_reg_mc_wrapper_top_axi2frame_dbg0_reg::type_id::create("axi2frame_dbg0_reg",,get_full_name());
        this.axi2frame_dbg0_reg.configure(this, null, "");
        this.axi2frame_dbg0_reg.build();
        this.default_map.add_reg(this.axi2frame_dbg0_reg, `UVM_REG_ADDR_WIDTH'h250,"RW",0);
            this.axi2frame_dbg0_reg_a2f_dbg_ar_cnt = this.axi2frame_dbg0_reg.a2f_dbg_ar_cnt;
            this.a2f_dbg_ar_cnt = this.axi2frame_dbg0_reg.a2f_dbg_ar_cnt;

        this.axi2frame_dbg1_reg = ral_reg_mc_wrapper_top_axi2frame_dbg1_reg::type_id::create("axi2frame_dbg1_reg",,get_full_name());
        this.axi2frame_dbg1_reg.configure(this, null, "");
        this.axi2frame_dbg1_reg.build();
        this.default_map.add_reg(this.axi2frame_dbg1_reg, `UVM_REG_ADDR_WIDTH'h254,"RW",0);
            this.axi2frame_dbg1_reg_a2f_dbg_r_cnt = this.axi2frame_dbg1_reg.a2f_dbg_r_cnt;
            this.a2f_dbg_r_cnt = this.axi2frame_dbg1_reg.a2f_dbg_r_cnt;

        this.axi2frame_dbg2_reg = ral_reg_mc_wrapper_top_axi2frame_dbg2_reg::type_id::create("axi2frame_dbg2_reg",,get_full_name());
        this.axi2frame_dbg2_reg.configure(this, null, "");
        this.axi2frame_dbg2_reg.build();
        this.default_map.add_reg(this.axi2frame_dbg2_reg, `UVM_REG_ADDR_WIDTH'h258,"RW",0);
            this.axi2frame_dbg2_reg_a2f_dbg_aw_cnt = this.axi2frame_dbg2_reg.a2f_dbg_aw_cnt;
            this.a2f_dbg_aw_cnt = this.axi2frame_dbg2_reg.a2f_dbg_aw_cnt;

        this.axi2frame_dbg3_reg = ral_reg_mc_wrapper_top_axi2frame_dbg3_reg::type_id::create("axi2frame_dbg3_reg",,get_full_name());
        this.axi2frame_dbg3_reg.configure(this, null, "");
        this.axi2frame_dbg3_reg.build();
        this.default_map.add_reg(this.axi2frame_dbg3_reg, `UVM_REG_ADDR_WIDTH'h25C,"RW",0);
            this.axi2frame_dbg3_reg_a2f_dbg_w_cnt = this.axi2frame_dbg3_reg.a2f_dbg_w_cnt;
            this.a2f_dbg_w_cnt = this.axi2frame_dbg3_reg.a2f_dbg_w_cnt;

        this.axi2frame_dbg4_reg = ral_reg_mc_wrapper_top_axi2frame_dbg4_reg::type_id::create("axi2frame_dbg4_reg",,get_full_name());
        this.axi2frame_dbg4_reg.configure(this, null, "");
        this.axi2frame_dbg4_reg.build();
        this.default_map.add_reg(this.axi2frame_dbg4_reg, `UVM_REG_ADDR_WIDTH'h260,"RW",0);
            this.axi2frame_dbg4_reg_a2f_dbg_b_cnt = this.axi2frame_dbg4_reg.a2f_dbg_b_cnt;
            this.a2f_dbg_b_cnt = this.axi2frame_dbg4_reg.a2f_dbg_b_cnt;

        this.axi2frame_dbg5_reg = ral_reg_mc_wrapper_top_axi2frame_dbg5_reg::type_id::create("axi2frame_dbg5_reg",,get_full_name());
        this.axi2frame_dbg5_reg.configure(this, null, "");
        this.axi2frame_dbg5_reg.build();
        this.default_map.add_reg(this.axi2frame_dbg5_reg, `UVM_REG_ADDR_WIDTH'h264,"RW",0);
            this.axi2frame_dbg5_reg_a2f_dbg_axi_len_err_addr = this.axi2frame_dbg5_reg.a2f_dbg_axi_len_err_addr;
            this.a2f_dbg_axi_len_err_addr = this.axi2frame_dbg5_reg.a2f_dbg_axi_len_err_addr;

        this.axi2frame_dbg6_reg = ral_reg_mc_wrapper_top_axi2frame_dbg6_reg::type_id::create("axi2frame_dbg6_reg",,get_full_name());
        this.axi2frame_dbg6_reg.configure(this, null, "");
        this.axi2frame_dbg6_reg.build();
        this.default_map.add_reg(this.axi2frame_dbg6_reg, `UVM_REG_ADDR_WIDTH'h268,"RW",0);
            this.axi2frame_dbg6_reg_a2f_dbg_axi_len_err = this.axi2frame_dbg6_reg.a2f_dbg_axi_len_err;
            this.a2f_dbg_axi_len_err = this.axi2frame_dbg6_reg.a2f_dbg_axi_len_err;

        this.axi2frame_dbg7_reg = ral_reg_mc_wrapper_top_axi2frame_dbg7_reg::type_id::create("axi2frame_dbg7_reg",,get_full_name());
        this.axi2frame_dbg7_reg.configure(this, null, "");
        this.axi2frame_dbg7_reg.build();
        this.default_map.add_reg(this.axi2frame_dbg7_reg, `UVM_REG_ADDR_WIDTH'h26C,"RW",0);
            this.axi2frame_dbg7_reg_a2f_dbg_reserve_in = this.axi2frame_dbg7_reg.a2f_dbg_reserve_in;
            this.a2f_dbg_reserve_in = this.axi2frame_dbg7_reg.a2f_dbg_reserve_in;

        this.axi2frame_dbg8_reg = ral_reg_mc_wrapper_top_axi2frame_dbg8_reg::type_id::create("axi2frame_dbg8_reg",,get_full_name());
        this.axi2frame_dbg8_reg.configure(this, null, "");
        this.axi2frame_dbg8_reg.build();
        this.default_map.add_reg(this.axi2frame_dbg8_reg, `UVM_REG_ADDR_WIDTH'h270,"RW",0);
            this.axi2frame_dbg8_reg_a2f_dbg_reserve_out = this.axi2frame_dbg8_reg.a2f_dbg_reserve_out;
            this.a2f_dbg_reserve_out = this.axi2frame_dbg8_reg.a2f_dbg_reserve_out;

        this.mc_page_status_reg = ral_reg_mc_wrapper_top_mc_page_status_reg::type_id::create("mc_page_status_reg",,get_full_name());
        this.mc_page_status_reg.configure(this, null, "");
        this.mc_page_status_reg.build();
        this.default_map.add_reg(this.mc_page_status_reg, `UVM_REG_ADDR_WIDTH'h274,"RW",0);
            this.mc_page_status_reg_mc_page_status = this.mc_page_status_reg.mc_page_status;
            this.mc_page_status = this.mc_page_status_reg.mc_page_status;

        this.hang_timeout_status_reg = ral_reg_mc_wrapper_top_hang_timeout_status_reg::type_id::create("hang_timeout_status_reg",,get_full_name());
        this.hang_timeout_status_reg.configure(this, null, "");
        this.hang_timeout_status_reg.build();
        this.default_map.add_reg(this.hang_timeout_status_reg, `UVM_REG_ADDR_WIDTH'h278,"RW",0);
            this.hang_timeout_status_reg_hang_timeout_status = this.hang_timeout_status_reg.hang_timeout_status;
            this.hang_timeout_status = this.hang_timeout_status_reg.hang_timeout_status;

        this.hang_timeout_mask_reg = ral_reg_mc_wrapper_top_hang_timeout_mask_reg::type_id::create("hang_timeout_mask_reg",,get_full_name());
        this.hang_timeout_mask_reg.configure(this, null, "");
        this.hang_timeout_mask_reg.build();
        this.default_map.add_reg(this.hang_timeout_mask_reg, `UVM_REG_ADDR_WIDTH'h27C,"RW",0);
            this.hang_timeout_mask_reg_hang_timeout_mask = this.hang_timeout_mask_reg.hang_timeout_mask;
            this.hang_timeout_mask = this.hang_timeout_mask_reg.hang_timeout_mask;

        this.hang_timeout_clr_reg = ral_reg_mc_wrapper_top_hang_timeout_clr_reg::type_id::create("hang_timeout_clr_reg",,get_full_name());
        this.hang_timeout_clr_reg.configure(this, null, "");
        this.hang_timeout_clr_reg.build();
        this.default_map.add_reg(this.hang_timeout_clr_reg, `UVM_REG_ADDR_WIDTH'h280,"RW",0);
            this.hang_timeout_clr_reg_hang_timeout_clr = this.hang_timeout_clr_reg.hang_timeout_clr;
            this.hang_timeout_clr = this.hang_timeout_clr_reg.hang_timeout_clr;

        this.hang_timeout_en_reg = ral_reg_mc_wrapper_top_hang_timeout_en_reg::type_id::create("hang_timeout_en_reg",,get_full_name());
        this.hang_timeout_en_reg.configure(this, null, "");
        this.hang_timeout_en_reg.build();
        this.default_map.add_reg(this.hang_timeout_en_reg, `UVM_REG_ADDR_WIDTH'h284,"RW",0);
            this.hang_timeout_en_reg_hang_timeout_en = this.hang_timeout_en_reg.hang_timeout_en;
            this.hang_timeout_en = this.hang_timeout_en_reg.hang_timeout_en;

        this.mc_bank1_vmc_wl_num0_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num0_reg::type_id::create("mc_bank1_vmc_wl_num0_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num0_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num0_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num0_reg, `UVM_REG_ADDR_WIDTH'h288,"RW",0);
            this.mc_bank1_vmc_wl_num0_reg_mc_bank1_vmc_wl_num0 = this.mc_bank1_vmc_wl_num0_reg.mc_bank1_vmc_wl_num0;
            this.mc_bank1_vmc_wl_num0 = this.mc_bank1_vmc_wl_num0_reg.mc_bank1_vmc_wl_num0;

            this.mc_bank1_vmc_wl_num0_reg_mc_bank1_vmc_wl_num1 = this.mc_bank1_vmc_wl_num0_reg.mc_bank1_vmc_wl_num1;
            this.mc_bank1_vmc_wl_num1 = this.mc_bank1_vmc_wl_num0_reg.mc_bank1_vmc_wl_num1;

        this.mc_bank1_vmc_wl_num1_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num1_reg::type_id::create("mc_bank1_vmc_wl_num1_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num1_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num1_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num1_reg, `UVM_REG_ADDR_WIDTH'h28C,"RW",0);
            this.mc_bank1_vmc_wl_num1_reg_mc_bank1_vmc_wl_num2 = this.mc_bank1_vmc_wl_num1_reg.mc_bank1_vmc_wl_num2;
            this.mc_bank1_vmc_wl_num2 = this.mc_bank1_vmc_wl_num1_reg.mc_bank1_vmc_wl_num2;

            this.mc_bank1_vmc_wl_num1_reg_mc_bank1_vmc_wl_num3 = this.mc_bank1_vmc_wl_num1_reg.mc_bank1_vmc_wl_num3;
            this.mc_bank1_vmc_wl_num3 = this.mc_bank1_vmc_wl_num1_reg.mc_bank1_vmc_wl_num3;

        this.mc_bank1_vmc_wl_num2_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num2_reg::type_id::create("mc_bank1_vmc_wl_num2_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num2_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num2_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num2_reg, `UVM_REG_ADDR_WIDTH'h290,"RW",0);
            this.mc_bank1_vmc_wl_num2_reg_mc_bank1_vmc_wl_num4 = this.mc_bank1_vmc_wl_num2_reg.mc_bank1_vmc_wl_num4;
            this.mc_bank1_vmc_wl_num4 = this.mc_bank1_vmc_wl_num2_reg.mc_bank1_vmc_wl_num4;

            this.mc_bank1_vmc_wl_num2_reg_mc_bank1_vmc_wl_num5 = this.mc_bank1_vmc_wl_num2_reg.mc_bank1_vmc_wl_num5;
            this.mc_bank1_vmc_wl_num5 = this.mc_bank1_vmc_wl_num2_reg.mc_bank1_vmc_wl_num5;

        this.mc_bank1_vmc_wl_num3_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num3_reg::type_id::create("mc_bank1_vmc_wl_num3_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num3_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num3_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num3_reg, `UVM_REG_ADDR_WIDTH'h294,"RW",0);
            this.mc_bank1_vmc_wl_num3_reg_mc_bank1_vmc_wl_num6 = this.mc_bank1_vmc_wl_num3_reg.mc_bank1_vmc_wl_num6;
            this.mc_bank1_vmc_wl_num6 = this.mc_bank1_vmc_wl_num3_reg.mc_bank1_vmc_wl_num6;

            this.mc_bank1_vmc_wl_num3_reg_mc_bank1_vmc_wl_num7 = this.mc_bank1_vmc_wl_num3_reg.mc_bank1_vmc_wl_num7;
            this.mc_bank1_vmc_wl_num7 = this.mc_bank1_vmc_wl_num3_reg.mc_bank1_vmc_wl_num7;

        this.mc_bank1_vmc_wl_num4_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num4_reg::type_id::create("mc_bank1_vmc_wl_num4_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num4_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num4_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num4_reg, `UVM_REG_ADDR_WIDTH'h298,"RW",0);
            this.mc_bank1_vmc_wl_num4_reg_mc_bank1_vmc_wl_num8 = this.mc_bank1_vmc_wl_num4_reg.mc_bank1_vmc_wl_num8;
            this.mc_bank1_vmc_wl_num8 = this.mc_bank1_vmc_wl_num4_reg.mc_bank1_vmc_wl_num8;

            this.mc_bank1_vmc_wl_num4_reg_mc_bank1_vmc_wl_num9 = this.mc_bank1_vmc_wl_num4_reg.mc_bank1_vmc_wl_num9;
            this.mc_bank1_vmc_wl_num9 = this.mc_bank1_vmc_wl_num4_reg.mc_bank1_vmc_wl_num9;

        this.mc_bank1_vmc_wl_num5_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num5_reg::type_id::create("mc_bank1_vmc_wl_num5_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num5_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num5_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num5_reg, `UVM_REG_ADDR_WIDTH'h29C,"RW",0);
            this.mc_bank1_vmc_wl_num5_reg_mc_bank1_vmc_wl_num10 = this.mc_bank1_vmc_wl_num5_reg.mc_bank1_vmc_wl_num10;
            this.mc_bank1_vmc_wl_num10 = this.mc_bank1_vmc_wl_num5_reg.mc_bank1_vmc_wl_num10;

            this.mc_bank1_vmc_wl_num5_reg_mc_bank1_vmc_wl_num11 = this.mc_bank1_vmc_wl_num5_reg.mc_bank1_vmc_wl_num11;
            this.mc_bank1_vmc_wl_num11 = this.mc_bank1_vmc_wl_num5_reg.mc_bank1_vmc_wl_num11;

        this.mc_bank1_vmc_wl_num6_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num6_reg::type_id::create("mc_bank1_vmc_wl_num6_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num6_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num6_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num6_reg, `UVM_REG_ADDR_WIDTH'h2A0,"RW",0);
            this.mc_bank1_vmc_wl_num6_reg_mc_bank1_vmc_wl_num12 = this.mc_bank1_vmc_wl_num6_reg.mc_bank1_vmc_wl_num12;
            this.mc_bank1_vmc_wl_num12 = this.mc_bank1_vmc_wl_num6_reg.mc_bank1_vmc_wl_num12;

            this.mc_bank1_vmc_wl_num6_reg_mc_bank1_vmc_wl_num13 = this.mc_bank1_vmc_wl_num6_reg.mc_bank1_vmc_wl_num13;
            this.mc_bank1_vmc_wl_num13 = this.mc_bank1_vmc_wl_num6_reg.mc_bank1_vmc_wl_num13;

        this.mc_bank1_vmc_wl_num7_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num7_reg::type_id::create("mc_bank1_vmc_wl_num7_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num7_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num7_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num7_reg, `UVM_REG_ADDR_WIDTH'h2A4,"RW",0);
            this.mc_bank1_vmc_wl_num7_reg_mc_bank1_vmc_wl_num14 = this.mc_bank1_vmc_wl_num7_reg.mc_bank1_vmc_wl_num14;
            this.mc_bank1_vmc_wl_num14 = this.mc_bank1_vmc_wl_num7_reg.mc_bank1_vmc_wl_num14;

            this.mc_bank1_vmc_wl_num7_reg_mc_bank1_vmc_wl_num15 = this.mc_bank1_vmc_wl_num7_reg.mc_bank1_vmc_wl_num15;
            this.mc_bank1_vmc_wl_num15 = this.mc_bank1_vmc_wl_num7_reg.mc_bank1_vmc_wl_num15;

        this.mc_bank1_vmc_wl_num8_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num8_reg::type_id::create("mc_bank1_vmc_wl_num8_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num8_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num8_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num8_reg, `UVM_REG_ADDR_WIDTH'h2A8,"RW",0);
            this.mc_bank1_vmc_wl_num8_reg_mc_bank1_vmc_wl_num16 = this.mc_bank1_vmc_wl_num8_reg.mc_bank1_vmc_wl_num16;
            this.mc_bank1_vmc_wl_num16 = this.mc_bank1_vmc_wl_num8_reg.mc_bank1_vmc_wl_num16;

            this.mc_bank1_vmc_wl_num8_reg_mc_bank1_vmc_wl_num17 = this.mc_bank1_vmc_wl_num8_reg.mc_bank1_vmc_wl_num17;
            this.mc_bank1_vmc_wl_num17 = this.mc_bank1_vmc_wl_num8_reg.mc_bank1_vmc_wl_num17;

        this.mc_bank1_vmc_wl_num9_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num9_reg::type_id::create("mc_bank1_vmc_wl_num9_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num9_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num9_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num9_reg, `UVM_REG_ADDR_WIDTH'h2AC,"RW",0);
            this.mc_bank1_vmc_wl_num9_reg_mc_bank1_vmc_wl_num18 = this.mc_bank1_vmc_wl_num9_reg.mc_bank1_vmc_wl_num18;
            this.mc_bank1_vmc_wl_num18 = this.mc_bank1_vmc_wl_num9_reg.mc_bank1_vmc_wl_num18;

            this.mc_bank1_vmc_wl_num9_reg_mc_bank1_vmc_wl_num19 = this.mc_bank1_vmc_wl_num9_reg.mc_bank1_vmc_wl_num19;
            this.mc_bank1_vmc_wl_num19 = this.mc_bank1_vmc_wl_num9_reg.mc_bank1_vmc_wl_num19;

        this.mc_bank1_vmc_wl_num10_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num10_reg::type_id::create("mc_bank1_vmc_wl_num10_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num10_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num10_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num10_reg, `UVM_REG_ADDR_WIDTH'h2B0,"RW",0);
            this.mc_bank1_vmc_wl_num10_reg_mc_bank1_vmc_wl_num20 = this.mc_bank1_vmc_wl_num10_reg.mc_bank1_vmc_wl_num20;
            this.mc_bank1_vmc_wl_num20 = this.mc_bank1_vmc_wl_num10_reg.mc_bank1_vmc_wl_num20;

            this.mc_bank1_vmc_wl_num10_reg_mc_bank1_vmc_wl_num21 = this.mc_bank1_vmc_wl_num10_reg.mc_bank1_vmc_wl_num21;
            this.mc_bank1_vmc_wl_num21 = this.mc_bank1_vmc_wl_num10_reg.mc_bank1_vmc_wl_num21;

        this.mc_bank1_vmc_wl_num11_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num11_reg::type_id::create("mc_bank1_vmc_wl_num11_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num11_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num11_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num11_reg, `UVM_REG_ADDR_WIDTH'h2B4,"RW",0);
            this.mc_bank1_vmc_wl_num11_reg_mc_bank1_vmc_wl_num22 = this.mc_bank1_vmc_wl_num11_reg.mc_bank1_vmc_wl_num22;
            this.mc_bank1_vmc_wl_num22 = this.mc_bank1_vmc_wl_num11_reg.mc_bank1_vmc_wl_num22;

            this.mc_bank1_vmc_wl_num11_reg_mc_bank1_vmc_wl_num23 = this.mc_bank1_vmc_wl_num11_reg.mc_bank1_vmc_wl_num23;
            this.mc_bank1_vmc_wl_num23 = this.mc_bank1_vmc_wl_num11_reg.mc_bank1_vmc_wl_num23;

        this.mc_bank1_vmc_wl_num12_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num12_reg::type_id::create("mc_bank1_vmc_wl_num12_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num12_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num12_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num12_reg, `UVM_REG_ADDR_WIDTH'h2B8,"RW",0);
            this.mc_bank1_vmc_wl_num12_reg_mc_bank1_vmc_wl_num24 = this.mc_bank1_vmc_wl_num12_reg.mc_bank1_vmc_wl_num24;
            this.mc_bank1_vmc_wl_num24 = this.mc_bank1_vmc_wl_num12_reg.mc_bank1_vmc_wl_num24;

            this.mc_bank1_vmc_wl_num12_reg_mc_bank1_vmc_wl_num25 = this.mc_bank1_vmc_wl_num12_reg.mc_bank1_vmc_wl_num25;
            this.mc_bank1_vmc_wl_num25 = this.mc_bank1_vmc_wl_num12_reg.mc_bank1_vmc_wl_num25;

        this.mc_bank1_vmc_wl_num13_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num13_reg::type_id::create("mc_bank1_vmc_wl_num13_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num13_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num13_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num13_reg, `UVM_REG_ADDR_WIDTH'h2BC,"RW",0);
            this.mc_bank1_vmc_wl_num13_reg_mc_bank1_vmc_wl_num26 = this.mc_bank1_vmc_wl_num13_reg.mc_bank1_vmc_wl_num26;
            this.mc_bank1_vmc_wl_num26 = this.mc_bank1_vmc_wl_num13_reg.mc_bank1_vmc_wl_num26;

            this.mc_bank1_vmc_wl_num13_reg_mc_bank1_vmc_wl_num27 = this.mc_bank1_vmc_wl_num13_reg.mc_bank1_vmc_wl_num27;
            this.mc_bank1_vmc_wl_num27 = this.mc_bank1_vmc_wl_num13_reg.mc_bank1_vmc_wl_num27;

        this.mc_bank1_vmc_wl_num14_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num14_reg::type_id::create("mc_bank1_vmc_wl_num14_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num14_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num14_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num14_reg, `UVM_REG_ADDR_WIDTH'h2C0,"RW",0);
            this.mc_bank1_vmc_wl_num14_reg_mc_bank1_vmc_wl_num28 = this.mc_bank1_vmc_wl_num14_reg.mc_bank1_vmc_wl_num28;
            this.mc_bank1_vmc_wl_num28 = this.mc_bank1_vmc_wl_num14_reg.mc_bank1_vmc_wl_num28;

            this.mc_bank1_vmc_wl_num14_reg_mc_bank1_vmc_wl_num29 = this.mc_bank1_vmc_wl_num14_reg.mc_bank1_vmc_wl_num29;
            this.mc_bank1_vmc_wl_num29 = this.mc_bank1_vmc_wl_num14_reg.mc_bank1_vmc_wl_num29;

        this.mc_bank1_vmc_wl_num15_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num15_reg::type_id::create("mc_bank1_vmc_wl_num15_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num15_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num15_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num15_reg, `UVM_REG_ADDR_WIDTH'h2C4,"RW",0);
            this.mc_bank1_vmc_wl_num15_reg_mc_bank1_vmc_wl_num30 = this.mc_bank1_vmc_wl_num15_reg.mc_bank1_vmc_wl_num30;
            this.mc_bank1_vmc_wl_num30 = this.mc_bank1_vmc_wl_num15_reg.mc_bank1_vmc_wl_num30;

            this.mc_bank1_vmc_wl_num15_reg_mc_bank1_vmc_wl_num31 = this.mc_bank1_vmc_wl_num15_reg.mc_bank1_vmc_wl_num31;
            this.mc_bank1_vmc_wl_num31 = this.mc_bank1_vmc_wl_num15_reg.mc_bank1_vmc_wl_num31;

        this.mc_bank1_vmc_wl_num16_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num16_reg::type_id::create("mc_bank1_vmc_wl_num16_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num16_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num16_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num16_reg, `UVM_REG_ADDR_WIDTH'h2C8,"RW",0);
            this.mc_bank1_vmc_wl_num16_reg_mc_bank1_vmc_wl_num32 = this.mc_bank1_vmc_wl_num16_reg.mc_bank1_vmc_wl_num32;
            this.mc_bank1_vmc_wl_num32 = this.mc_bank1_vmc_wl_num16_reg.mc_bank1_vmc_wl_num32;

            this.mc_bank1_vmc_wl_num16_reg_mc_bank1_vmc_wl_num33 = this.mc_bank1_vmc_wl_num16_reg.mc_bank1_vmc_wl_num33;
            this.mc_bank1_vmc_wl_num33 = this.mc_bank1_vmc_wl_num16_reg.mc_bank1_vmc_wl_num33;

        this.mc_bank1_vmc_wl_num17_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num17_reg::type_id::create("mc_bank1_vmc_wl_num17_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num17_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num17_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num17_reg, `UVM_REG_ADDR_WIDTH'h2CC,"RW",0);
            this.mc_bank1_vmc_wl_num17_reg_mc_bank1_vmc_wl_num34 = this.mc_bank1_vmc_wl_num17_reg.mc_bank1_vmc_wl_num34;
            this.mc_bank1_vmc_wl_num34 = this.mc_bank1_vmc_wl_num17_reg.mc_bank1_vmc_wl_num34;

            this.mc_bank1_vmc_wl_num17_reg_mc_bank1_vmc_wl_num35 = this.mc_bank1_vmc_wl_num17_reg.mc_bank1_vmc_wl_num35;
            this.mc_bank1_vmc_wl_num35 = this.mc_bank1_vmc_wl_num17_reg.mc_bank1_vmc_wl_num35;

        this.mc_bank1_vmc_wl_num18_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num18_reg::type_id::create("mc_bank1_vmc_wl_num18_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num18_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num18_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num18_reg, `UVM_REG_ADDR_WIDTH'h2D0,"RW",0);
            this.mc_bank1_vmc_wl_num18_reg_mc_bank1_vmc_wl_num36 = this.mc_bank1_vmc_wl_num18_reg.mc_bank1_vmc_wl_num36;
            this.mc_bank1_vmc_wl_num36 = this.mc_bank1_vmc_wl_num18_reg.mc_bank1_vmc_wl_num36;

            this.mc_bank1_vmc_wl_num18_reg_mc_bank1_vmc_wl_num37 = this.mc_bank1_vmc_wl_num18_reg.mc_bank1_vmc_wl_num37;
            this.mc_bank1_vmc_wl_num37 = this.mc_bank1_vmc_wl_num18_reg.mc_bank1_vmc_wl_num37;

        this.mc_bank1_vmc_wl_num19_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num19_reg::type_id::create("mc_bank1_vmc_wl_num19_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num19_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num19_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num19_reg, `UVM_REG_ADDR_WIDTH'h2D4,"RW",0);
            this.mc_bank1_vmc_wl_num19_reg_mc_bank1_vmc_wl_num38 = this.mc_bank1_vmc_wl_num19_reg.mc_bank1_vmc_wl_num38;
            this.mc_bank1_vmc_wl_num38 = this.mc_bank1_vmc_wl_num19_reg.mc_bank1_vmc_wl_num38;

            this.mc_bank1_vmc_wl_num19_reg_mc_bank1_vmc_wl_num39 = this.mc_bank1_vmc_wl_num19_reg.mc_bank1_vmc_wl_num39;
            this.mc_bank1_vmc_wl_num39 = this.mc_bank1_vmc_wl_num19_reg.mc_bank1_vmc_wl_num39;

        this.mc_bank1_vmc_wl_num20_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num20_reg::type_id::create("mc_bank1_vmc_wl_num20_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num20_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num20_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num20_reg, `UVM_REG_ADDR_WIDTH'h2D8,"RW",0);
            this.mc_bank1_vmc_wl_num20_reg_mc_bank1_vmc_wl_num40 = this.mc_bank1_vmc_wl_num20_reg.mc_bank1_vmc_wl_num40;
            this.mc_bank1_vmc_wl_num40 = this.mc_bank1_vmc_wl_num20_reg.mc_bank1_vmc_wl_num40;

            this.mc_bank1_vmc_wl_num20_reg_mc_bank1_vmc_wl_num41 = this.mc_bank1_vmc_wl_num20_reg.mc_bank1_vmc_wl_num41;
            this.mc_bank1_vmc_wl_num41 = this.mc_bank1_vmc_wl_num20_reg.mc_bank1_vmc_wl_num41;

        this.mc_bank1_vmc_wl_num21_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num21_reg::type_id::create("mc_bank1_vmc_wl_num21_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num21_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num21_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num21_reg, `UVM_REG_ADDR_WIDTH'h2DC,"RW",0);
            this.mc_bank1_vmc_wl_num21_reg_mc_bank1_vmc_wl_num42 = this.mc_bank1_vmc_wl_num21_reg.mc_bank1_vmc_wl_num42;
            this.mc_bank1_vmc_wl_num42 = this.mc_bank1_vmc_wl_num21_reg.mc_bank1_vmc_wl_num42;

            this.mc_bank1_vmc_wl_num21_reg_mc_bank1_vmc_wl_num43 = this.mc_bank1_vmc_wl_num21_reg.mc_bank1_vmc_wl_num43;
            this.mc_bank1_vmc_wl_num43 = this.mc_bank1_vmc_wl_num21_reg.mc_bank1_vmc_wl_num43;

        this.mc_bank1_vmc_wl_num22_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num22_reg::type_id::create("mc_bank1_vmc_wl_num22_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num22_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num22_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num22_reg, `UVM_REG_ADDR_WIDTH'h2E0,"RW",0);
            this.mc_bank1_vmc_wl_num22_reg_mc_bank1_vmc_wl_num44 = this.mc_bank1_vmc_wl_num22_reg.mc_bank1_vmc_wl_num44;
            this.mc_bank1_vmc_wl_num44 = this.mc_bank1_vmc_wl_num22_reg.mc_bank1_vmc_wl_num44;

            this.mc_bank1_vmc_wl_num22_reg_mc_bank1_vmc_wl_num45 = this.mc_bank1_vmc_wl_num22_reg.mc_bank1_vmc_wl_num45;
            this.mc_bank1_vmc_wl_num45 = this.mc_bank1_vmc_wl_num22_reg.mc_bank1_vmc_wl_num45;

        this.mc_bank1_vmc_wl_num23_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num23_reg::type_id::create("mc_bank1_vmc_wl_num23_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num23_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num23_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num23_reg, `UVM_REG_ADDR_WIDTH'h2E4,"RW",0);
            this.mc_bank1_vmc_wl_num23_reg_mc_bank1_vmc_wl_num46 = this.mc_bank1_vmc_wl_num23_reg.mc_bank1_vmc_wl_num46;
            this.mc_bank1_vmc_wl_num46 = this.mc_bank1_vmc_wl_num23_reg.mc_bank1_vmc_wl_num46;

            this.mc_bank1_vmc_wl_num23_reg_mc_bank1_vmc_wl_num47 = this.mc_bank1_vmc_wl_num23_reg.mc_bank1_vmc_wl_num47;
            this.mc_bank1_vmc_wl_num47 = this.mc_bank1_vmc_wl_num23_reg.mc_bank1_vmc_wl_num47;

        this.mc_bank1_vmc_wl_num24_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num24_reg::type_id::create("mc_bank1_vmc_wl_num24_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num24_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num24_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num24_reg, `UVM_REG_ADDR_WIDTH'h2E8,"RW",0);
            this.mc_bank1_vmc_wl_num24_reg_mc_bank1_vmc_wl_num48 = this.mc_bank1_vmc_wl_num24_reg.mc_bank1_vmc_wl_num48;
            this.mc_bank1_vmc_wl_num48 = this.mc_bank1_vmc_wl_num24_reg.mc_bank1_vmc_wl_num48;

            this.mc_bank1_vmc_wl_num24_reg_mc_bank1_vmc_wl_num49 = this.mc_bank1_vmc_wl_num24_reg.mc_bank1_vmc_wl_num49;
            this.mc_bank1_vmc_wl_num49 = this.mc_bank1_vmc_wl_num24_reg.mc_bank1_vmc_wl_num49;

        this.mc_bank1_vmc_wl_num25_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num25_reg::type_id::create("mc_bank1_vmc_wl_num25_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num25_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num25_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num25_reg, `UVM_REG_ADDR_WIDTH'h2EC,"RW",0);
            this.mc_bank1_vmc_wl_num25_reg_mc_bank1_vmc_wl_num50 = this.mc_bank1_vmc_wl_num25_reg.mc_bank1_vmc_wl_num50;
            this.mc_bank1_vmc_wl_num50 = this.mc_bank1_vmc_wl_num25_reg.mc_bank1_vmc_wl_num50;

            this.mc_bank1_vmc_wl_num25_reg_mc_bank1_vmc_wl_num51 = this.mc_bank1_vmc_wl_num25_reg.mc_bank1_vmc_wl_num51;
            this.mc_bank1_vmc_wl_num51 = this.mc_bank1_vmc_wl_num25_reg.mc_bank1_vmc_wl_num51;

        this.mc_bank1_vmc_wl_num26_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num26_reg::type_id::create("mc_bank1_vmc_wl_num26_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num26_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num26_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num26_reg, `UVM_REG_ADDR_WIDTH'h2F0,"RW",0);
            this.mc_bank1_vmc_wl_num26_reg_mc_bank1_vmc_wl_num52 = this.mc_bank1_vmc_wl_num26_reg.mc_bank1_vmc_wl_num52;
            this.mc_bank1_vmc_wl_num52 = this.mc_bank1_vmc_wl_num26_reg.mc_bank1_vmc_wl_num52;

            this.mc_bank1_vmc_wl_num26_reg_mc_bank1_vmc_wl_num53 = this.mc_bank1_vmc_wl_num26_reg.mc_bank1_vmc_wl_num53;
            this.mc_bank1_vmc_wl_num53 = this.mc_bank1_vmc_wl_num26_reg.mc_bank1_vmc_wl_num53;

        this.mc_bank1_vmc_wl_num27_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num27_reg::type_id::create("mc_bank1_vmc_wl_num27_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num27_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num27_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num27_reg, `UVM_REG_ADDR_WIDTH'h2F4,"RW",0);
            this.mc_bank1_vmc_wl_num27_reg_mc_bank1_vmc_wl_num54 = this.mc_bank1_vmc_wl_num27_reg.mc_bank1_vmc_wl_num54;
            this.mc_bank1_vmc_wl_num54 = this.mc_bank1_vmc_wl_num27_reg.mc_bank1_vmc_wl_num54;

            this.mc_bank1_vmc_wl_num27_reg_mc_bank1_vmc_wl_num55 = this.mc_bank1_vmc_wl_num27_reg.mc_bank1_vmc_wl_num55;
            this.mc_bank1_vmc_wl_num55 = this.mc_bank1_vmc_wl_num27_reg.mc_bank1_vmc_wl_num55;

        this.mc_bank1_vmc_wl_num28_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num28_reg::type_id::create("mc_bank1_vmc_wl_num28_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num28_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num28_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num28_reg, `UVM_REG_ADDR_WIDTH'h2F8,"RW",0);
            this.mc_bank1_vmc_wl_num28_reg_mc_bank1_vmc_wl_num56 = this.mc_bank1_vmc_wl_num28_reg.mc_bank1_vmc_wl_num56;
            this.mc_bank1_vmc_wl_num56 = this.mc_bank1_vmc_wl_num28_reg.mc_bank1_vmc_wl_num56;

            this.mc_bank1_vmc_wl_num28_reg_mc_bank1_vmc_wl_num57 = this.mc_bank1_vmc_wl_num28_reg.mc_bank1_vmc_wl_num57;
            this.mc_bank1_vmc_wl_num57 = this.mc_bank1_vmc_wl_num28_reg.mc_bank1_vmc_wl_num57;

        this.mc_bank1_vmc_wl_num29_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num29_reg::type_id::create("mc_bank1_vmc_wl_num29_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num29_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num29_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num29_reg, `UVM_REG_ADDR_WIDTH'h2FC,"RW",0);
            this.mc_bank1_vmc_wl_num29_reg_mc_bank1_vmc_wl_num58 = this.mc_bank1_vmc_wl_num29_reg.mc_bank1_vmc_wl_num58;
            this.mc_bank1_vmc_wl_num58 = this.mc_bank1_vmc_wl_num29_reg.mc_bank1_vmc_wl_num58;

            this.mc_bank1_vmc_wl_num29_reg_mc_bank1_vmc_wl_num59 = this.mc_bank1_vmc_wl_num29_reg.mc_bank1_vmc_wl_num59;
            this.mc_bank1_vmc_wl_num59 = this.mc_bank1_vmc_wl_num29_reg.mc_bank1_vmc_wl_num59;

        this.mc_bank1_vmc_wl_num30_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num30_reg::type_id::create("mc_bank1_vmc_wl_num30_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num30_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num30_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num30_reg, `UVM_REG_ADDR_WIDTH'h300,"RW",0);
            this.mc_bank1_vmc_wl_num30_reg_mc_bank1_vmc_wl_num60 = this.mc_bank1_vmc_wl_num30_reg.mc_bank1_vmc_wl_num60;
            this.mc_bank1_vmc_wl_num60 = this.mc_bank1_vmc_wl_num30_reg.mc_bank1_vmc_wl_num60;

            this.mc_bank1_vmc_wl_num30_reg_mc_bank1_vmc_wl_num61 = this.mc_bank1_vmc_wl_num30_reg.mc_bank1_vmc_wl_num61;
            this.mc_bank1_vmc_wl_num61 = this.mc_bank1_vmc_wl_num30_reg.mc_bank1_vmc_wl_num61;

        this.mc_bank1_vmc_wl_num31_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_wl_num31_reg::type_id::create("mc_bank1_vmc_wl_num31_reg",,get_full_name());
        this.mc_bank1_vmc_wl_num31_reg.configure(this, null, "");
        this.mc_bank1_vmc_wl_num31_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_wl_num31_reg, `UVM_REG_ADDR_WIDTH'h304,"RW",0);
            this.mc_bank1_vmc_wl_num31_reg_mc_bank1_vmc_wl_num62 = this.mc_bank1_vmc_wl_num31_reg.mc_bank1_vmc_wl_num62;
            this.mc_bank1_vmc_wl_num62 = this.mc_bank1_vmc_wl_num31_reg.mc_bank1_vmc_wl_num62;

            this.mc_bank1_vmc_wl_num31_reg_mc_bank1_vmc_wl_num63 = this.mc_bank1_vmc_wl_num31_reg.mc_bank1_vmc_wl_num63;
            this.mc_bank1_vmc_wl_num63 = this.mc_bank1_vmc_wl_num31_reg.mc_bank1_vmc_wl_num63;

        this.mc_bank1_vmc_bl_num0_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num0_reg::type_id::create("mc_bank1_vmc_bl_num0_reg",,get_full_name());
        this.mc_bank1_vmc_bl_num0_reg.configure(this, null, "");
        this.mc_bank1_vmc_bl_num0_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_bl_num0_reg, `UVM_REG_ADDR_WIDTH'h308,"RW",0);
            this.mc_bank1_vmc_bl_num0_reg_mc_bank1_vmc_bl_num0_part0 = this.mc_bank1_vmc_bl_num0_reg.mc_bank1_vmc_bl_num0_part0;
            this.mc_bank1_vmc_bl_num0_part0 = this.mc_bank1_vmc_bl_num0_reg.mc_bank1_vmc_bl_num0_part0;

            this.mc_bank1_vmc_bl_num0_reg_mc_bank1_vmc_bl_num1_part0 = this.mc_bank1_vmc_bl_num0_reg.mc_bank1_vmc_bl_num1_part0;
            this.mc_bank1_vmc_bl_num1_part0 = this.mc_bank1_vmc_bl_num0_reg.mc_bank1_vmc_bl_num1_part0;

            this.mc_bank1_vmc_bl_num0_reg_mc_bank1_vmc_bl_num0_part1 = this.mc_bank1_vmc_bl_num0_reg.mc_bank1_vmc_bl_num0_part1;
            this.mc_bank1_vmc_bl_num0_part1 = this.mc_bank1_vmc_bl_num0_reg.mc_bank1_vmc_bl_num0_part1;

            this.mc_bank1_vmc_bl_num0_reg_mc_bank1_vmc_bl_num1_part1 = this.mc_bank1_vmc_bl_num0_reg.mc_bank1_vmc_bl_num1_part1;
            this.mc_bank1_vmc_bl_num1_part1 = this.mc_bank1_vmc_bl_num0_reg.mc_bank1_vmc_bl_num1_part1;

        this.mc_bank1_vmc_bl_num1_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num1_reg::type_id::create("mc_bank1_vmc_bl_num1_reg",,get_full_name());
        this.mc_bank1_vmc_bl_num1_reg.configure(this, null, "");
        this.mc_bank1_vmc_bl_num1_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_bl_num1_reg, `UVM_REG_ADDR_WIDTH'h30C,"RW",0);
            this.mc_bank1_vmc_bl_num1_reg_mc_bank1_vmc_bl_num0_part2 = this.mc_bank1_vmc_bl_num1_reg.mc_bank1_vmc_bl_num0_part2;
            this.mc_bank1_vmc_bl_num0_part2 = this.mc_bank1_vmc_bl_num1_reg.mc_bank1_vmc_bl_num0_part2;

            this.mc_bank1_vmc_bl_num1_reg_mc_bank1_vmc_bl_num1_part2 = this.mc_bank1_vmc_bl_num1_reg.mc_bank1_vmc_bl_num1_part2;
            this.mc_bank1_vmc_bl_num1_part2 = this.mc_bank1_vmc_bl_num1_reg.mc_bank1_vmc_bl_num1_part2;

            this.mc_bank1_vmc_bl_num1_reg_mc_bank1_vmc_bl_num0_part3 = this.mc_bank1_vmc_bl_num1_reg.mc_bank1_vmc_bl_num0_part3;
            this.mc_bank1_vmc_bl_num0_part3 = this.mc_bank1_vmc_bl_num1_reg.mc_bank1_vmc_bl_num0_part3;

            this.mc_bank1_vmc_bl_num1_reg_mc_bank1_vmc_bl_num1_part3 = this.mc_bank1_vmc_bl_num1_reg.mc_bank1_vmc_bl_num1_part3;
            this.mc_bank1_vmc_bl_num1_part3 = this.mc_bank1_vmc_bl_num1_reg.mc_bank1_vmc_bl_num1_part3;

        this.mc_bank1_vmc_bl_num2_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num2_reg::type_id::create("mc_bank1_vmc_bl_num2_reg",,get_full_name());
        this.mc_bank1_vmc_bl_num2_reg.configure(this, null, "");
        this.mc_bank1_vmc_bl_num2_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_bl_num2_reg, `UVM_REG_ADDR_WIDTH'h310,"RW",0);
            this.mc_bank1_vmc_bl_num2_reg_mc_bank1_vmc_bl_num0_part4 = this.mc_bank1_vmc_bl_num2_reg.mc_bank1_vmc_bl_num0_part4;
            this.mc_bank1_vmc_bl_num0_part4 = this.mc_bank1_vmc_bl_num2_reg.mc_bank1_vmc_bl_num0_part4;

            this.mc_bank1_vmc_bl_num2_reg_mc_bank1_vmc_bl_num1_part4 = this.mc_bank1_vmc_bl_num2_reg.mc_bank1_vmc_bl_num1_part4;
            this.mc_bank1_vmc_bl_num1_part4 = this.mc_bank1_vmc_bl_num2_reg.mc_bank1_vmc_bl_num1_part4;

            this.mc_bank1_vmc_bl_num2_reg_mc_bank1_vmc_bl_num0_part5 = this.mc_bank1_vmc_bl_num2_reg.mc_bank1_vmc_bl_num0_part5;
            this.mc_bank1_vmc_bl_num0_part5 = this.mc_bank1_vmc_bl_num2_reg.mc_bank1_vmc_bl_num0_part5;

            this.mc_bank1_vmc_bl_num2_reg_mc_bank1_vmc_bl_num1_part5 = this.mc_bank1_vmc_bl_num2_reg.mc_bank1_vmc_bl_num1_part5;
            this.mc_bank1_vmc_bl_num1_part5 = this.mc_bank1_vmc_bl_num2_reg.mc_bank1_vmc_bl_num1_part5;

        this.mc_bank1_vmc_bl_num3_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num3_reg::type_id::create("mc_bank1_vmc_bl_num3_reg",,get_full_name());
        this.mc_bank1_vmc_bl_num3_reg.configure(this, null, "");
        this.mc_bank1_vmc_bl_num3_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_bl_num3_reg, `UVM_REG_ADDR_WIDTH'h314,"RW",0);
            this.mc_bank1_vmc_bl_num3_reg_mc_bank1_vmc_bl_num0_part6 = this.mc_bank1_vmc_bl_num3_reg.mc_bank1_vmc_bl_num0_part6;
            this.mc_bank1_vmc_bl_num0_part6 = this.mc_bank1_vmc_bl_num3_reg.mc_bank1_vmc_bl_num0_part6;

            this.mc_bank1_vmc_bl_num3_reg_mc_bank1_vmc_bl_num1_part6 = this.mc_bank1_vmc_bl_num3_reg.mc_bank1_vmc_bl_num1_part6;
            this.mc_bank1_vmc_bl_num1_part6 = this.mc_bank1_vmc_bl_num3_reg.mc_bank1_vmc_bl_num1_part6;

            this.mc_bank1_vmc_bl_num3_reg_mc_bank1_vmc_bl_num0_part7 = this.mc_bank1_vmc_bl_num3_reg.mc_bank1_vmc_bl_num0_part7;
            this.mc_bank1_vmc_bl_num0_part7 = this.mc_bank1_vmc_bl_num3_reg.mc_bank1_vmc_bl_num0_part7;

            this.mc_bank1_vmc_bl_num3_reg_mc_bank1_vmc_bl_num1_part7 = this.mc_bank1_vmc_bl_num3_reg.mc_bank1_vmc_bl_num1_part7;
            this.mc_bank1_vmc_bl_num1_part7 = this.mc_bank1_vmc_bl_num3_reg.mc_bank1_vmc_bl_num1_part7;

        this.mc_bank1_vmc_bl_num4_reg = ral_reg_mc_wrapper_top_mc_bank1_vmc_bl_num4_reg::type_id::create("mc_bank1_vmc_bl_num4_reg",,get_full_name());
        this.mc_bank1_vmc_bl_num4_reg.configure(this, null, "");
        this.mc_bank1_vmc_bl_num4_reg.build();
        this.default_map.add_reg(this.mc_bank1_vmc_bl_num4_reg, `UVM_REG_ADDR_WIDTH'h318,"RW",0);
            this.mc_bank1_vmc_bl_num4_reg_mc_bank1_vmc_bl_num0_part8 = this.mc_bank1_vmc_bl_num4_reg.mc_bank1_vmc_bl_num0_part8;
            this.mc_bank1_vmc_bl_num0_part8 = this.mc_bank1_vmc_bl_num4_reg.mc_bank1_vmc_bl_num0_part8;

            this.mc_bank1_vmc_bl_num4_reg_mc_bank1_vmc_bl_num1_part8 = this.mc_bank1_vmc_bl_num4_reg.mc_bank1_vmc_bl_num1_part8;
            this.mc_bank1_vmc_bl_num1_part8 = this.mc_bank1_vmc_bl_num4_reg.mc_bank1_vmc_bl_num1_part8;

            this.mc_bank1_vmc_bl_num4_reg_mc_bank1_vmc_bl_num0_part9 = this.mc_bank1_vmc_bl_num4_reg.mc_bank1_vmc_bl_num0_part9;
            this.mc_bank1_vmc_bl_num0_part9 = this.mc_bank1_vmc_bl_num4_reg.mc_bank1_vmc_bl_num0_part9;

            this.mc_bank1_vmc_bl_num4_reg_mc_bank1_vmc_bl_num1_part9 = this.mc_bank1_vmc_bl_num4_reg.mc_bank1_vmc_bl_num1_part9;
            this.mc_bank1_vmc_bl_num1_part9 = this.mc_bank1_vmc_bl_num4_reg.mc_bank1_vmc_bl_num1_part9;

        this.bank1_err_wl_num0_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num0_reg::type_id::create("bank1_err_wl_num0_reg",,get_full_name());
        this.bank1_err_wl_num0_reg.configure(this, null, "");
        this.bank1_err_wl_num0_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num0_reg, `UVM_REG_ADDR_WIDTH'h31C,"RW",0);
            this.bank1_err_wl_num0_reg_bank1_err_wl0 = this.bank1_err_wl_num0_reg.bank1_err_wl0;
            this.bank1_err_wl0 = this.bank1_err_wl_num0_reg.bank1_err_wl0;

            this.bank1_err_wl_num0_reg_bank1_err_wl1 = this.bank1_err_wl_num0_reg.bank1_err_wl1;
            this.bank1_err_wl1 = this.bank1_err_wl_num0_reg.bank1_err_wl1;

        this.bank1_err_wl_num1_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num1_reg::type_id::create("bank1_err_wl_num1_reg",,get_full_name());
        this.bank1_err_wl_num1_reg.configure(this, null, "");
        this.bank1_err_wl_num1_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num1_reg, `UVM_REG_ADDR_WIDTH'h320,"RW",0);
            this.bank1_err_wl_num1_reg_bank1_err_wl2 = this.bank1_err_wl_num1_reg.bank1_err_wl2;
            this.bank1_err_wl2 = this.bank1_err_wl_num1_reg.bank1_err_wl2;

            this.bank1_err_wl_num1_reg_bank1_err_wl3 = this.bank1_err_wl_num1_reg.bank1_err_wl3;
            this.bank1_err_wl3 = this.bank1_err_wl_num1_reg.bank1_err_wl3;

        this.bank1_err_wl_num2_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num2_reg::type_id::create("bank1_err_wl_num2_reg",,get_full_name());
        this.bank1_err_wl_num2_reg.configure(this, null, "");
        this.bank1_err_wl_num2_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num2_reg, `UVM_REG_ADDR_WIDTH'h324,"RW",0);
            this.bank1_err_wl_num2_reg_bank1_err_wl4 = this.bank1_err_wl_num2_reg.bank1_err_wl4;
            this.bank1_err_wl4 = this.bank1_err_wl_num2_reg.bank1_err_wl4;

            this.bank1_err_wl_num2_reg_bank1_err_wl5 = this.bank1_err_wl_num2_reg.bank1_err_wl5;
            this.bank1_err_wl5 = this.bank1_err_wl_num2_reg.bank1_err_wl5;

        this.bank1_err_wl_num3_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num3_reg::type_id::create("bank1_err_wl_num3_reg",,get_full_name());
        this.bank1_err_wl_num3_reg.configure(this, null, "");
        this.bank1_err_wl_num3_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num3_reg, `UVM_REG_ADDR_WIDTH'h328,"RW",0);
            this.bank1_err_wl_num3_reg_bank1_err_wl6 = this.bank1_err_wl_num3_reg.bank1_err_wl6;
            this.bank1_err_wl6 = this.bank1_err_wl_num3_reg.bank1_err_wl6;

            this.bank1_err_wl_num3_reg_bank1_err_wl7 = this.bank1_err_wl_num3_reg.bank1_err_wl7;
            this.bank1_err_wl7 = this.bank1_err_wl_num3_reg.bank1_err_wl7;

        this.bank1_err_wl_num4_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num4_reg::type_id::create("bank1_err_wl_num4_reg",,get_full_name());
        this.bank1_err_wl_num4_reg.configure(this, null, "");
        this.bank1_err_wl_num4_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num4_reg, `UVM_REG_ADDR_WIDTH'h32C,"RW",0);
            this.bank1_err_wl_num4_reg_bank1_err_wl8 = this.bank1_err_wl_num4_reg.bank1_err_wl8;
            this.bank1_err_wl8 = this.bank1_err_wl_num4_reg.bank1_err_wl8;

            this.bank1_err_wl_num4_reg_bank1_err_wl9 = this.bank1_err_wl_num4_reg.bank1_err_wl9;
            this.bank1_err_wl9 = this.bank1_err_wl_num4_reg.bank1_err_wl9;

        this.bank1_err_wl_num5_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num5_reg::type_id::create("bank1_err_wl_num5_reg",,get_full_name());
        this.bank1_err_wl_num5_reg.configure(this, null, "");
        this.bank1_err_wl_num5_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num5_reg, `UVM_REG_ADDR_WIDTH'h330,"RW",0);
            this.bank1_err_wl_num5_reg_bank1_err_wl10 = this.bank1_err_wl_num5_reg.bank1_err_wl10;
            this.bank1_err_wl10 = this.bank1_err_wl_num5_reg.bank1_err_wl10;

            this.bank1_err_wl_num5_reg_bank1_err_wl11 = this.bank1_err_wl_num5_reg.bank1_err_wl11;
            this.bank1_err_wl11 = this.bank1_err_wl_num5_reg.bank1_err_wl11;

        this.bank1_err_wl_num6_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num6_reg::type_id::create("bank1_err_wl_num6_reg",,get_full_name());
        this.bank1_err_wl_num6_reg.configure(this, null, "");
        this.bank1_err_wl_num6_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num6_reg, `UVM_REG_ADDR_WIDTH'h334,"RW",0);
            this.bank1_err_wl_num6_reg_bank1_err_wl12 = this.bank1_err_wl_num6_reg.bank1_err_wl12;
            this.bank1_err_wl12 = this.bank1_err_wl_num6_reg.bank1_err_wl12;

            this.bank1_err_wl_num6_reg_bank1_err_wl13 = this.bank1_err_wl_num6_reg.bank1_err_wl13;
            this.bank1_err_wl13 = this.bank1_err_wl_num6_reg.bank1_err_wl13;

        this.bank1_err_wl_num7_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num7_reg::type_id::create("bank1_err_wl_num7_reg",,get_full_name());
        this.bank1_err_wl_num7_reg.configure(this, null, "");
        this.bank1_err_wl_num7_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num7_reg, `UVM_REG_ADDR_WIDTH'h338,"RW",0);
            this.bank1_err_wl_num7_reg_bank1_err_wl14 = this.bank1_err_wl_num7_reg.bank1_err_wl14;
            this.bank1_err_wl14 = this.bank1_err_wl_num7_reg.bank1_err_wl14;

            this.bank1_err_wl_num7_reg_bank1_err_wl15 = this.bank1_err_wl_num7_reg.bank1_err_wl15;
            this.bank1_err_wl15 = this.bank1_err_wl_num7_reg.bank1_err_wl15;

        this.bank1_err_wl_num8_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num8_reg::type_id::create("bank1_err_wl_num8_reg",,get_full_name());
        this.bank1_err_wl_num8_reg.configure(this, null, "");
        this.bank1_err_wl_num8_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num8_reg, `UVM_REG_ADDR_WIDTH'h33C,"RW",0);
            this.bank1_err_wl_num8_reg_bank1_err_wl16 = this.bank1_err_wl_num8_reg.bank1_err_wl16;
            this.bank1_err_wl16 = this.bank1_err_wl_num8_reg.bank1_err_wl16;

            this.bank1_err_wl_num8_reg_bank1_err_wl17 = this.bank1_err_wl_num8_reg.bank1_err_wl17;
            this.bank1_err_wl17 = this.bank1_err_wl_num8_reg.bank1_err_wl17;

        this.bank1_err_wl_num9_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num9_reg::type_id::create("bank1_err_wl_num9_reg",,get_full_name());
        this.bank1_err_wl_num9_reg.configure(this, null, "");
        this.bank1_err_wl_num9_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num9_reg, `UVM_REG_ADDR_WIDTH'h340,"RW",0);
            this.bank1_err_wl_num9_reg_bank1_err_wl18 = this.bank1_err_wl_num9_reg.bank1_err_wl18;
            this.bank1_err_wl18 = this.bank1_err_wl_num9_reg.bank1_err_wl18;

            this.bank1_err_wl_num9_reg_bank1_err_wl19 = this.bank1_err_wl_num9_reg.bank1_err_wl19;
            this.bank1_err_wl19 = this.bank1_err_wl_num9_reg.bank1_err_wl19;

        this.bank1_err_wl_num10_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num10_reg::type_id::create("bank1_err_wl_num10_reg",,get_full_name());
        this.bank1_err_wl_num10_reg.configure(this, null, "");
        this.bank1_err_wl_num10_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num10_reg, `UVM_REG_ADDR_WIDTH'h344,"RW",0);
            this.bank1_err_wl_num10_reg_bank1_err_wl20 = this.bank1_err_wl_num10_reg.bank1_err_wl20;
            this.bank1_err_wl20 = this.bank1_err_wl_num10_reg.bank1_err_wl20;

            this.bank1_err_wl_num10_reg_bank1_err_wl21 = this.bank1_err_wl_num10_reg.bank1_err_wl21;
            this.bank1_err_wl21 = this.bank1_err_wl_num10_reg.bank1_err_wl21;

        this.bank1_err_wl_num11_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num11_reg::type_id::create("bank1_err_wl_num11_reg",,get_full_name());
        this.bank1_err_wl_num11_reg.configure(this, null, "");
        this.bank1_err_wl_num11_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num11_reg, `UVM_REG_ADDR_WIDTH'h348,"RW",0);
            this.bank1_err_wl_num11_reg_bank1_err_wl22 = this.bank1_err_wl_num11_reg.bank1_err_wl22;
            this.bank1_err_wl22 = this.bank1_err_wl_num11_reg.bank1_err_wl22;

            this.bank1_err_wl_num11_reg_bank1_err_wl23 = this.bank1_err_wl_num11_reg.bank1_err_wl23;
            this.bank1_err_wl23 = this.bank1_err_wl_num11_reg.bank1_err_wl23;

        this.bank1_err_wl_num12_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num12_reg::type_id::create("bank1_err_wl_num12_reg",,get_full_name());
        this.bank1_err_wl_num12_reg.configure(this, null, "");
        this.bank1_err_wl_num12_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num12_reg, `UVM_REG_ADDR_WIDTH'h34C,"RW",0);
            this.bank1_err_wl_num12_reg_bank1_err_wl24 = this.bank1_err_wl_num12_reg.bank1_err_wl24;
            this.bank1_err_wl24 = this.bank1_err_wl_num12_reg.bank1_err_wl24;

            this.bank1_err_wl_num12_reg_bank1_err_wl25 = this.bank1_err_wl_num12_reg.bank1_err_wl25;
            this.bank1_err_wl25 = this.bank1_err_wl_num12_reg.bank1_err_wl25;

        this.bank1_err_wl_num13_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num13_reg::type_id::create("bank1_err_wl_num13_reg",,get_full_name());
        this.bank1_err_wl_num13_reg.configure(this, null, "");
        this.bank1_err_wl_num13_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num13_reg, `UVM_REG_ADDR_WIDTH'h350,"RW",0);
            this.bank1_err_wl_num13_reg_bank1_err_wl26 = this.bank1_err_wl_num13_reg.bank1_err_wl26;
            this.bank1_err_wl26 = this.bank1_err_wl_num13_reg.bank1_err_wl26;

            this.bank1_err_wl_num13_reg_bank1_err_wl27 = this.bank1_err_wl_num13_reg.bank1_err_wl27;
            this.bank1_err_wl27 = this.bank1_err_wl_num13_reg.bank1_err_wl27;

        this.bank1_err_wl_num14_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num14_reg::type_id::create("bank1_err_wl_num14_reg",,get_full_name());
        this.bank1_err_wl_num14_reg.configure(this, null, "");
        this.bank1_err_wl_num14_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num14_reg, `UVM_REG_ADDR_WIDTH'h354,"RW",0);
            this.bank1_err_wl_num14_reg_bank1_err_wl28 = this.bank1_err_wl_num14_reg.bank1_err_wl28;
            this.bank1_err_wl28 = this.bank1_err_wl_num14_reg.bank1_err_wl28;

            this.bank1_err_wl_num14_reg_bank1_err_wl29 = this.bank1_err_wl_num14_reg.bank1_err_wl29;
            this.bank1_err_wl29 = this.bank1_err_wl_num14_reg.bank1_err_wl29;

        this.bank1_err_wl_num15_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num15_reg::type_id::create("bank1_err_wl_num15_reg",,get_full_name());
        this.bank1_err_wl_num15_reg.configure(this, null, "");
        this.bank1_err_wl_num15_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num15_reg, `UVM_REG_ADDR_WIDTH'h358,"RW",0);
            this.bank1_err_wl_num15_reg_bank1_err_wl30 = this.bank1_err_wl_num15_reg.bank1_err_wl30;
            this.bank1_err_wl30 = this.bank1_err_wl_num15_reg.bank1_err_wl30;

            this.bank1_err_wl_num15_reg_bank1_err_wl31 = this.bank1_err_wl_num15_reg.bank1_err_wl31;
            this.bank1_err_wl31 = this.bank1_err_wl_num15_reg.bank1_err_wl31;

        this.bank1_err_wl_num16_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num16_reg::type_id::create("bank1_err_wl_num16_reg",,get_full_name());
        this.bank1_err_wl_num16_reg.configure(this, null, "");
        this.bank1_err_wl_num16_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num16_reg, `UVM_REG_ADDR_WIDTH'h35C,"RW",0);
            this.bank1_err_wl_num16_reg_bank1_err_wl32 = this.bank1_err_wl_num16_reg.bank1_err_wl32;
            this.bank1_err_wl32 = this.bank1_err_wl_num16_reg.bank1_err_wl32;

            this.bank1_err_wl_num16_reg_bank1_err_wl33 = this.bank1_err_wl_num16_reg.bank1_err_wl33;
            this.bank1_err_wl33 = this.bank1_err_wl_num16_reg.bank1_err_wl33;

        this.bank1_err_wl_num17_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num17_reg::type_id::create("bank1_err_wl_num17_reg",,get_full_name());
        this.bank1_err_wl_num17_reg.configure(this, null, "");
        this.bank1_err_wl_num17_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num17_reg, `UVM_REG_ADDR_WIDTH'h360,"RW",0);
            this.bank1_err_wl_num17_reg_bank1_err_wl34 = this.bank1_err_wl_num17_reg.bank1_err_wl34;
            this.bank1_err_wl34 = this.bank1_err_wl_num17_reg.bank1_err_wl34;

            this.bank1_err_wl_num17_reg_bank1_err_wl35 = this.bank1_err_wl_num17_reg.bank1_err_wl35;
            this.bank1_err_wl35 = this.bank1_err_wl_num17_reg.bank1_err_wl35;

        this.bank1_err_wl_num18_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num18_reg::type_id::create("bank1_err_wl_num18_reg",,get_full_name());
        this.bank1_err_wl_num18_reg.configure(this, null, "");
        this.bank1_err_wl_num18_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num18_reg, `UVM_REG_ADDR_WIDTH'h364,"RW",0);
            this.bank1_err_wl_num18_reg_bank1_err_wl36 = this.bank1_err_wl_num18_reg.bank1_err_wl36;
            this.bank1_err_wl36 = this.bank1_err_wl_num18_reg.bank1_err_wl36;

            this.bank1_err_wl_num18_reg_bank1_err_wl37 = this.bank1_err_wl_num18_reg.bank1_err_wl37;
            this.bank1_err_wl37 = this.bank1_err_wl_num18_reg.bank1_err_wl37;

        this.bank1_err_wl_num19_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num19_reg::type_id::create("bank1_err_wl_num19_reg",,get_full_name());
        this.bank1_err_wl_num19_reg.configure(this, null, "");
        this.bank1_err_wl_num19_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num19_reg, `UVM_REG_ADDR_WIDTH'h368,"RW",0);
            this.bank1_err_wl_num19_reg_bank1_err_wl38 = this.bank1_err_wl_num19_reg.bank1_err_wl38;
            this.bank1_err_wl38 = this.bank1_err_wl_num19_reg.bank1_err_wl38;

            this.bank1_err_wl_num19_reg_bank1_err_wl39 = this.bank1_err_wl_num19_reg.bank1_err_wl39;
            this.bank1_err_wl39 = this.bank1_err_wl_num19_reg.bank1_err_wl39;

        this.bank1_err_wl_num20_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num20_reg::type_id::create("bank1_err_wl_num20_reg",,get_full_name());
        this.bank1_err_wl_num20_reg.configure(this, null, "");
        this.bank1_err_wl_num20_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num20_reg, `UVM_REG_ADDR_WIDTH'h36C,"RW",0);
            this.bank1_err_wl_num20_reg_bank1_err_wl40 = this.bank1_err_wl_num20_reg.bank1_err_wl40;
            this.bank1_err_wl40 = this.bank1_err_wl_num20_reg.bank1_err_wl40;

            this.bank1_err_wl_num20_reg_bank1_err_wl41 = this.bank1_err_wl_num20_reg.bank1_err_wl41;
            this.bank1_err_wl41 = this.bank1_err_wl_num20_reg.bank1_err_wl41;

        this.bank1_err_wl_num21_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num21_reg::type_id::create("bank1_err_wl_num21_reg",,get_full_name());
        this.bank1_err_wl_num21_reg.configure(this, null, "");
        this.bank1_err_wl_num21_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num21_reg, `UVM_REG_ADDR_WIDTH'h370,"RW",0);
            this.bank1_err_wl_num21_reg_bank1_err_wl42 = this.bank1_err_wl_num21_reg.bank1_err_wl42;
            this.bank1_err_wl42 = this.bank1_err_wl_num21_reg.bank1_err_wl42;

            this.bank1_err_wl_num21_reg_bank1_err_wl43 = this.bank1_err_wl_num21_reg.bank1_err_wl43;
            this.bank1_err_wl43 = this.bank1_err_wl_num21_reg.bank1_err_wl43;

        this.bank1_err_wl_num22_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num22_reg::type_id::create("bank1_err_wl_num22_reg",,get_full_name());
        this.bank1_err_wl_num22_reg.configure(this, null, "");
        this.bank1_err_wl_num22_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num22_reg, `UVM_REG_ADDR_WIDTH'h374,"RW",0);
            this.bank1_err_wl_num22_reg_bank1_err_wl44 = this.bank1_err_wl_num22_reg.bank1_err_wl44;
            this.bank1_err_wl44 = this.bank1_err_wl_num22_reg.bank1_err_wl44;

            this.bank1_err_wl_num22_reg_bank1_err_wl45 = this.bank1_err_wl_num22_reg.bank1_err_wl45;
            this.bank1_err_wl45 = this.bank1_err_wl_num22_reg.bank1_err_wl45;

        this.bank1_err_wl_num23_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num23_reg::type_id::create("bank1_err_wl_num23_reg",,get_full_name());
        this.bank1_err_wl_num23_reg.configure(this, null, "");
        this.bank1_err_wl_num23_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num23_reg, `UVM_REG_ADDR_WIDTH'h378,"RW",0);
            this.bank1_err_wl_num23_reg_bank1_err_wl46 = this.bank1_err_wl_num23_reg.bank1_err_wl46;
            this.bank1_err_wl46 = this.bank1_err_wl_num23_reg.bank1_err_wl46;

            this.bank1_err_wl_num23_reg_bank1_err_wl47 = this.bank1_err_wl_num23_reg.bank1_err_wl47;
            this.bank1_err_wl47 = this.bank1_err_wl_num23_reg.bank1_err_wl47;

        this.bank1_err_wl_num24_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num24_reg::type_id::create("bank1_err_wl_num24_reg",,get_full_name());
        this.bank1_err_wl_num24_reg.configure(this, null, "");
        this.bank1_err_wl_num24_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num24_reg, `UVM_REG_ADDR_WIDTH'h37C,"RW",0);
            this.bank1_err_wl_num24_reg_bank1_err_wl48 = this.bank1_err_wl_num24_reg.bank1_err_wl48;
            this.bank1_err_wl48 = this.bank1_err_wl_num24_reg.bank1_err_wl48;

            this.bank1_err_wl_num24_reg_bank1_err_wl49 = this.bank1_err_wl_num24_reg.bank1_err_wl49;
            this.bank1_err_wl49 = this.bank1_err_wl_num24_reg.bank1_err_wl49;

        this.bank1_err_wl_num25_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num25_reg::type_id::create("bank1_err_wl_num25_reg",,get_full_name());
        this.bank1_err_wl_num25_reg.configure(this, null, "");
        this.bank1_err_wl_num25_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num25_reg, `UVM_REG_ADDR_WIDTH'h380,"RW",0);
            this.bank1_err_wl_num25_reg_bank1_err_wl50 = this.bank1_err_wl_num25_reg.bank1_err_wl50;
            this.bank1_err_wl50 = this.bank1_err_wl_num25_reg.bank1_err_wl50;

            this.bank1_err_wl_num25_reg_bank1_err_wl51 = this.bank1_err_wl_num25_reg.bank1_err_wl51;
            this.bank1_err_wl51 = this.bank1_err_wl_num25_reg.bank1_err_wl51;

        this.bank1_err_wl_num26_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num26_reg::type_id::create("bank1_err_wl_num26_reg",,get_full_name());
        this.bank1_err_wl_num26_reg.configure(this, null, "");
        this.bank1_err_wl_num26_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num26_reg, `UVM_REG_ADDR_WIDTH'h384,"RW",0);
            this.bank1_err_wl_num26_reg_bank1_err_wl52 = this.bank1_err_wl_num26_reg.bank1_err_wl52;
            this.bank1_err_wl52 = this.bank1_err_wl_num26_reg.bank1_err_wl52;

            this.bank1_err_wl_num26_reg_bank1_err_wl53 = this.bank1_err_wl_num26_reg.bank1_err_wl53;
            this.bank1_err_wl53 = this.bank1_err_wl_num26_reg.bank1_err_wl53;

        this.bank1_err_wl_num27_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num27_reg::type_id::create("bank1_err_wl_num27_reg",,get_full_name());
        this.bank1_err_wl_num27_reg.configure(this, null, "");
        this.bank1_err_wl_num27_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num27_reg, `UVM_REG_ADDR_WIDTH'h388,"RW",0);
            this.bank1_err_wl_num27_reg_bank1_err_wl54 = this.bank1_err_wl_num27_reg.bank1_err_wl54;
            this.bank1_err_wl54 = this.bank1_err_wl_num27_reg.bank1_err_wl54;

            this.bank1_err_wl_num27_reg_bank1_err_wl55 = this.bank1_err_wl_num27_reg.bank1_err_wl55;
            this.bank1_err_wl55 = this.bank1_err_wl_num27_reg.bank1_err_wl55;

        this.bank1_err_wl_num28_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num28_reg::type_id::create("bank1_err_wl_num28_reg",,get_full_name());
        this.bank1_err_wl_num28_reg.configure(this, null, "");
        this.bank1_err_wl_num28_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num28_reg, `UVM_REG_ADDR_WIDTH'h38C,"RW",0);
            this.bank1_err_wl_num28_reg_bank1_err_wl56 = this.bank1_err_wl_num28_reg.bank1_err_wl56;
            this.bank1_err_wl56 = this.bank1_err_wl_num28_reg.bank1_err_wl56;

            this.bank1_err_wl_num28_reg_bank1_err_wl57 = this.bank1_err_wl_num28_reg.bank1_err_wl57;
            this.bank1_err_wl57 = this.bank1_err_wl_num28_reg.bank1_err_wl57;

        this.bank1_err_wl_num29_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num29_reg::type_id::create("bank1_err_wl_num29_reg",,get_full_name());
        this.bank1_err_wl_num29_reg.configure(this, null, "");
        this.bank1_err_wl_num29_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num29_reg, `UVM_REG_ADDR_WIDTH'h390,"RW",0);
            this.bank1_err_wl_num29_reg_bank1_err_wl58 = this.bank1_err_wl_num29_reg.bank1_err_wl58;
            this.bank1_err_wl58 = this.bank1_err_wl_num29_reg.bank1_err_wl58;

            this.bank1_err_wl_num29_reg_bank1_err_wl59 = this.bank1_err_wl_num29_reg.bank1_err_wl59;
            this.bank1_err_wl59 = this.bank1_err_wl_num29_reg.bank1_err_wl59;

        this.bank1_err_wl_num30_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num30_reg::type_id::create("bank1_err_wl_num30_reg",,get_full_name());
        this.bank1_err_wl_num30_reg.configure(this, null, "");
        this.bank1_err_wl_num30_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num30_reg, `UVM_REG_ADDR_WIDTH'h394,"RW",0);
            this.bank1_err_wl_num30_reg_bank1_err_wl60 = this.bank1_err_wl_num30_reg.bank1_err_wl60;
            this.bank1_err_wl60 = this.bank1_err_wl_num30_reg.bank1_err_wl60;

            this.bank1_err_wl_num30_reg_bank1_err_wl61 = this.bank1_err_wl_num30_reg.bank1_err_wl61;
            this.bank1_err_wl61 = this.bank1_err_wl_num30_reg.bank1_err_wl61;

        this.bank1_err_wl_num31_reg = ral_reg_mc_wrapper_top_bank1_err_wl_num31_reg::type_id::create("bank1_err_wl_num31_reg",,get_full_name());
        this.bank1_err_wl_num31_reg.configure(this, null, "");
        this.bank1_err_wl_num31_reg.build();
        this.default_map.add_reg(this.bank1_err_wl_num31_reg, `UVM_REG_ADDR_WIDTH'h398,"RW",0);
            this.bank1_err_wl_num31_reg_bank1_err_wl62 = this.bank1_err_wl_num31_reg.bank1_err_wl62;
            this.bank1_err_wl62 = this.bank1_err_wl_num31_reg.bank1_err_wl62;

            this.bank1_err_wl_num31_reg_bank1_err_wl63 = this.bank1_err_wl_num31_reg.bank1_err_wl63;
            this.bank1_err_wl63 = this.bank1_err_wl_num31_reg.bank1_err_wl63;

        this.bank1_err_csl0_part0_reg = ral_reg_mc_wrapper_top_bank1_err_csl0_part0_reg::type_id::create("bank1_err_csl0_part0_reg",,get_full_name());
        this.bank1_err_csl0_part0_reg.configure(this, null, "");
        this.bank1_err_csl0_part0_reg.build();
        this.default_map.add_reg(this.bank1_err_csl0_part0_reg, `UVM_REG_ADDR_WIDTH'h39C,"RW",0);
            this.bank1_err_csl0_part0_reg_bank1_err_csl0_part0 = this.bank1_err_csl0_part0_reg.bank1_err_csl0_part0;
            this.bank1_err_csl0_part0 = this.bank1_err_csl0_part0_reg.bank1_err_csl0_part0;

        this.bank1_err_csl1_part0_reg = ral_reg_mc_wrapper_top_bank1_err_csl1_part0_reg::type_id::create("bank1_err_csl1_part0_reg",,get_full_name());
        this.bank1_err_csl1_part0_reg.configure(this, null, "");
        this.bank1_err_csl1_part0_reg.build();
        this.default_map.add_reg(this.bank1_err_csl1_part0_reg, `UVM_REG_ADDR_WIDTH'h3A0,"RW",0);
            this.bank1_err_csl1_part0_reg_bank1_err_csl1_part0 = this.bank1_err_csl1_part0_reg.bank1_err_csl1_part0;
            this.bank1_err_csl1_part0 = this.bank1_err_csl1_part0_reg.bank1_err_csl1_part0;

        this.bank1_err_csl0_part1_reg = ral_reg_mc_wrapper_top_bank1_err_csl0_part1_reg::type_id::create("bank1_err_csl0_part1_reg",,get_full_name());
        this.bank1_err_csl0_part1_reg.configure(this, null, "");
        this.bank1_err_csl0_part1_reg.build();
        this.default_map.add_reg(this.bank1_err_csl0_part1_reg, `UVM_REG_ADDR_WIDTH'h3A4,"RW",0);
            this.bank1_err_csl0_part1_reg_bank1_err_csl0_part1 = this.bank1_err_csl0_part1_reg.bank1_err_csl0_part1;
            this.bank1_err_csl0_part1 = this.bank1_err_csl0_part1_reg.bank1_err_csl0_part1;

        this.bank1_err_csl1_part1_reg = ral_reg_mc_wrapper_top_bank1_err_csl1_part1_reg::type_id::create("bank1_err_csl1_part1_reg",,get_full_name());
        this.bank1_err_csl1_part1_reg.configure(this, null, "");
        this.bank1_err_csl1_part1_reg.build();
        this.default_map.add_reg(this.bank1_err_csl1_part1_reg, `UVM_REG_ADDR_WIDTH'h3A8,"RW",0);
            this.bank1_err_csl1_part1_reg_bank1_err_csl1_part1 = this.bank1_err_csl1_part1_reg.bank1_err_csl1_part1;
            this.bank1_err_csl1_part1 = this.bank1_err_csl1_part1_reg.bank1_err_csl1_part1;

        this.bank1_err_csl0_part2_reg = ral_reg_mc_wrapper_top_bank1_err_csl0_part2_reg::type_id::create("bank1_err_csl0_part2_reg",,get_full_name());
        this.bank1_err_csl0_part2_reg.configure(this, null, "");
        this.bank1_err_csl0_part2_reg.build();
        this.default_map.add_reg(this.bank1_err_csl0_part2_reg, `UVM_REG_ADDR_WIDTH'h3AC,"RW",0);
            this.bank1_err_csl0_part2_reg_bank1_err_csl0_part2 = this.bank1_err_csl0_part2_reg.bank1_err_csl0_part2;
            this.bank1_err_csl0_part2 = this.bank1_err_csl0_part2_reg.bank1_err_csl0_part2;

        this.bank1_err_csl1_part2_reg = ral_reg_mc_wrapper_top_bank1_err_csl1_part2_reg::type_id::create("bank1_err_csl1_part2_reg",,get_full_name());
        this.bank1_err_csl1_part2_reg.configure(this, null, "");
        this.bank1_err_csl1_part2_reg.build();
        this.default_map.add_reg(this.bank1_err_csl1_part2_reg, `UVM_REG_ADDR_WIDTH'h3B0,"RW",0);
            this.bank1_err_csl1_part2_reg_bank1_err_csl1_part2 = this.bank1_err_csl1_part2_reg.bank1_err_csl1_part2;
            this.bank1_err_csl1_part2 = this.bank1_err_csl1_part2_reg.bank1_err_csl1_part2;

        this.bank1_err_csl0_part3_reg = ral_reg_mc_wrapper_top_bank1_err_csl0_part3_reg::type_id::create("bank1_err_csl0_part3_reg",,get_full_name());
        this.bank1_err_csl0_part3_reg.configure(this, null, "");
        this.bank1_err_csl0_part3_reg.build();
        this.default_map.add_reg(this.bank1_err_csl0_part3_reg, `UVM_REG_ADDR_WIDTH'h3B4,"RW",0);
            this.bank1_err_csl0_part3_reg_bank1_err_csl0_part3 = this.bank1_err_csl0_part3_reg.bank1_err_csl0_part3;
            this.bank1_err_csl0_part3 = this.bank1_err_csl0_part3_reg.bank1_err_csl0_part3;

        this.bank1_err_csl1_part3_reg = ral_reg_mc_wrapper_top_bank1_err_csl1_part3_reg::type_id::create("bank1_err_csl1_part3_reg",,get_full_name());
        this.bank1_err_csl1_part3_reg.configure(this, null, "");
        this.bank1_err_csl1_part3_reg.build();
        this.default_map.add_reg(this.bank1_err_csl1_part3_reg, `UVM_REG_ADDR_WIDTH'h3B8,"RW",0);
            this.bank1_err_csl1_part3_reg_bank1_err_csl1_part3 = this.bank1_err_csl1_part3_reg.bank1_err_csl1_part3;
            this.bank1_err_csl1_part3 = this.bank1_err_csl1_part3_reg.bank1_err_csl1_part3;

        this.bank1_err_csl0_part4_reg = ral_reg_mc_wrapper_top_bank1_err_csl0_part4_reg::type_id::create("bank1_err_csl0_part4_reg",,get_full_name());
        this.bank1_err_csl0_part4_reg.configure(this, null, "");
        this.bank1_err_csl0_part4_reg.build();
        this.default_map.add_reg(this.bank1_err_csl0_part4_reg, `UVM_REG_ADDR_WIDTH'h3BC,"RW",0);
            this.bank1_err_csl0_part4_reg_bank1_err_csl0_part4 = this.bank1_err_csl0_part4_reg.bank1_err_csl0_part4;
            this.bank1_err_csl0_part4 = this.bank1_err_csl0_part4_reg.bank1_err_csl0_part4;

        this.bank1_err_csl1_part4_reg = ral_reg_mc_wrapper_top_bank1_err_csl1_part4_reg::type_id::create("bank1_err_csl1_part4_reg",,get_full_name());
        this.bank1_err_csl1_part4_reg.configure(this, null, "");
        this.bank1_err_csl1_part4_reg.build();
        this.default_map.add_reg(this.bank1_err_csl1_part4_reg, `UVM_REG_ADDR_WIDTH'h3C0,"RW",0);
            this.bank1_err_csl1_part4_reg_bank1_err_csl1_part4 = this.bank1_err_csl1_part4_reg.bank1_err_csl1_part4;
            this.bank1_err_csl1_part4 = this.bank1_err_csl1_part4_reg.bank1_err_csl1_part4;

        this.bank1_err_csl0_part5_reg = ral_reg_mc_wrapper_top_bank1_err_csl0_part5_reg::type_id::create("bank1_err_csl0_part5_reg",,get_full_name());
        this.bank1_err_csl0_part5_reg.configure(this, null, "");
        this.bank1_err_csl0_part5_reg.build();
        this.default_map.add_reg(this.bank1_err_csl0_part5_reg, `UVM_REG_ADDR_WIDTH'h3C4,"RW",0);
            this.bank1_err_csl0_part5_reg_bank1_err_csl0_part5 = this.bank1_err_csl0_part5_reg.bank1_err_csl0_part5;
            this.bank1_err_csl0_part5 = this.bank1_err_csl0_part5_reg.bank1_err_csl0_part5;

        this.bank1_err_csl1_part5_reg = ral_reg_mc_wrapper_top_bank1_err_csl1_part5_reg::type_id::create("bank1_err_csl1_part5_reg",,get_full_name());
        this.bank1_err_csl1_part5_reg.configure(this, null, "");
        this.bank1_err_csl1_part5_reg.build();
        this.default_map.add_reg(this.bank1_err_csl1_part5_reg, `UVM_REG_ADDR_WIDTH'h3C8,"RW",0);
            this.bank1_err_csl1_part5_reg_bank1_err_csl1_part5 = this.bank1_err_csl1_part5_reg.bank1_err_csl1_part5;
            this.bank1_err_csl1_part5 = this.bank1_err_csl1_part5_reg.bank1_err_csl1_part5;

        this.bank1_err_csl0_part6_reg = ral_reg_mc_wrapper_top_bank1_err_csl0_part6_reg::type_id::create("bank1_err_csl0_part6_reg",,get_full_name());
        this.bank1_err_csl0_part6_reg.configure(this, null, "");
        this.bank1_err_csl0_part6_reg.build();
        this.default_map.add_reg(this.bank1_err_csl0_part6_reg, `UVM_REG_ADDR_WIDTH'h3CC,"RW",0);
            this.bank1_err_csl0_part6_reg_bank1_err_csl0_part6 = this.bank1_err_csl0_part6_reg.bank1_err_csl0_part6;
            this.bank1_err_csl0_part6 = this.bank1_err_csl0_part6_reg.bank1_err_csl0_part6;

        this.bank1_err_csl1_part6_reg = ral_reg_mc_wrapper_top_bank1_err_csl1_part6_reg::type_id::create("bank1_err_csl1_part6_reg",,get_full_name());
        this.bank1_err_csl1_part6_reg.configure(this, null, "");
        this.bank1_err_csl1_part6_reg.build();
        this.default_map.add_reg(this.bank1_err_csl1_part6_reg, `UVM_REG_ADDR_WIDTH'h3D0,"RW",0);
            this.bank1_err_csl1_part6_reg_bank1_err_csl1_part6 = this.bank1_err_csl1_part6_reg.bank1_err_csl1_part6;
            this.bank1_err_csl1_part6 = this.bank1_err_csl1_part6_reg.bank1_err_csl1_part6;

        this.bank1_err_csl0_part7_reg = ral_reg_mc_wrapper_top_bank1_err_csl0_part7_reg::type_id::create("bank1_err_csl0_part7_reg",,get_full_name());
        this.bank1_err_csl0_part7_reg.configure(this, null, "");
        this.bank1_err_csl0_part7_reg.build();
        this.default_map.add_reg(this.bank1_err_csl0_part7_reg, `UVM_REG_ADDR_WIDTH'h3D4,"RW",0);
            this.bank1_err_csl0_part7_reg_bank1_err_csl0_part7 = this.bank1_err_csl0_part7_reg.bank1_err_csl0_part7;
            this.bank1_err_csl0_part7 = this.bank1_err_csl0_part7_reg.bank1_err_csl0_part7;

        this.bank1_err_csl1_part7_reg = ral_reg_mc_wrapper_top_bank1_err_csl1_part7_reg::type_id::create("bank1_err_csl1_part7_reg",,get_full_name());
        this.bank1_err_csl1_part7_reg.configure(this, null, "");
        this.bank1_err_csl1_part7_reg.build();
        this.default_map.add_reg(this.bank1_err_csl1_part7_reg, `UVM_REG_ADDR_WIDTH'h3D8,"RW",0);
            this.bank1_err_csl1_part7_reg_bank1_err_csl1_part7 = this.bank1_err_csl1_part7_reg.bank1_err_csl1_part7;
            this.bank1_err_csl1_part7 = this.bank1_err_csl1_part7_reg.bank1_err_csl1_part7;

        this.bank1_err_csl0_part8_reg = ral_reg_mc_wrapper_top_bank1_err_csl0_part8_reg::type_id::create("bank1_err_csl0_part8_reg",,get_full_name());
        this.bank1_err_csl0_part8_reg.configure(this, null, "");
        this.bank1_err_csl0_part8_reg.build();
        this.default_map.add_reg(this.bank1_err_csl0_part8_reg, `UVM_REG_ADDR_WIDTH'h3DC,"RW",0);
            this.bank1_err_csl0_part8_reg_bank1_err_csl0_part8 = this.bank1_err_csl0_part8_reg.bank1_err_csl0_part8;
            this.bank1_err_csl0_part8 = this.bank1_err_csl0_part8_reg.bank1_err_csl0_part8;

        this.bank1_err_csl1_part8_reg = ral_reg_mc_wrapper_top_bank1_err_csl1_part8_reg::type_id::create("bank1_err_csl1_part8_reg",,get_full_name());
        this.bank1_err_csl1_part8_reg.configure(this, null, "");
        this.bank1_err_csl1_part8_reg.build();
        this.default_map.add_reg(this.bank1_err_csl1_part8_reg, `UVM_REG_ADDR_WIDTH'h3E0,"RW",0);
            this.bank1_err_csl1_part8_reg_bank1_err_csl1_part8 = this.bank1_err_csl1_part8_reg.bank1_err_csl1_part8;
            this.bank1_err_csl1_part8 = this.bank1_err_csl1_part8_reg.bank1_err_csl1_part8;

        this.bank1_err_csl0_part9_reg = ral_reg_mc_wrapper_top_bank1_err_csl0_part9_reg::type_id::create("bank1_err_csl0_part9_reg",,get_full_name());
        this.bank1_err_csl0_part9_reg.configure(this, null, "");
        this.bank1_err_csl0_part9_reg.build();
        this.default_map.add_reg(this.bank1_err_csl0_part9_reg, `UVM_REG_ADDR_WIDTH'h3E4,"RW",0);
            this.bank1_err_csl0_part9_reg_bank1_err_csl0_part9 = this.bank1_err_csl0_part9_reg.bank1_err_csl0_part9;
            this.bank1_err_csl0_part9 = this.bank1_err_csl0_part9_reg.bank1_err_csl0_part9;

        this.bank1_err_csl1_part9_reg = ral_reg_mc_wrapper_top_bank1_err_csl1_part9_reg::type_id::create("bank1_err_csl1_part9_reg",,get_full_name());
        this.bank1_err_csl1_part9_reg.configure(this, null, "");
        this.bank1_err_csl1_part9_reg.build();
        this.default_map.add_reg(this.bank1_err_csl1_part9_reg, `UVM_REG_ADDR_WIDTH'h3E8,"RW",0);
            this.bank1_err_csl1_part9_reg_bank1_err_csl1_part9 = this.bank1_err_csl1_part9_reg.bank1_err_csl1_part9;
            this.bank1_err_csl1_part9 = this.bank1_err_csl1_part9_reg.bank1_err_csl1_part9;

        this.mc_bank1_bist_rescan_fail_num_reg = ral_reg_mc_wrapper_top_mc_bank1_bist_rescan_fail_num_reg::type_id::create("mc_bank1_bist_rescan_fail_num_reg",,get_full_name());
        this.mc_bank1_bist_rescan_fail_num_reg.configure(this, null, "");
        this.mc_bank1_bist_rescan_fail_num_reg.build();
        this.default_map.add_reg(this.mc_bank1_bist_rescan_fail_num_reg, `UVM_REG_ADDR_WIDTH'h3EC,"RW",0);
            this.mc_bank1_bist_rescan_fail_num_reg_mc_bank1_bist_rescan_fail_num = this.mc_bank1_bist_rescan_fail_num_reg.mc_bank1_bist_rescan_fail_num;
            this.mc_bank1_bist_rescan_fail_num = this.mc_bank1_bist_rescan_fail_num_reg.mc_bank1_bist_rescan_fail_num;

        this.mc_bank1_bist_err_wl_reg = ral_reg_mc_wrapper_top_mc_bank1_bist_err_wl_reg::type_id::create("mc_bank1_bist_err_wl_reg",,get_full_name());
        this.mc_bank1_bist_err_wl_reg.configure(this, null, "");
        this.mc_bank1_bist_err_wl_reg.build();
        this.default_map.add_reg(this.mc_bank1_bist_err_wl_reg, `UVM_REG_ADDR_WIDTH'h3F0,"RW",0);
            this.mc_bank1_bist_err_wl_reg_mc_bank1_bist_err_wl_num = this.mc_bank1_bist_err_wl_reg.mc_bank1_bist_err_wl_num;
            this.mc_bank1_bist_err_wl_num = this.mc_bank1_bist_err_wl_reg.mc_bank1_bist_err_wl_num;

            this.mc_bank1_bist_err_wl_reg_err_bank1_wl_num_change_flag = this.mc_bank1_bist_err_wl_reg.err_bank1_wl_num_change_flag;
            this.err_bank1_wl_num_change_flag = this.mc_bank1_bist_err_wl_reg.err_bank1_wl_num_change_flag;

        this.bank1_rescan_round_result_reg = ral_reg_mc_wrapper_top_bank1_rescan_round_result_reg::type_id::create("bank1_rescan_round_result_reg",,get_full_name());
        this.bank1_rescan_round_result_reg.configure(this, null, "");
        this.bank1_rescan_round_result_reg.build();
        this.default_map.add_reg(this.bank1_rescan_round_result_reg, `UVM_REG_ADDR_WIDTH'h3F4,"RW",0);
            this.bank1_rescan_round_result_reg_bank1_rescan_round_result = this.bank1_rescan_round_result_reg.bank1_rescan_round_result;
            this.bank1_rescan_round_result = this.bank1_rescan_round_result_reg.bank1_rescan_round_result;

            //add hdl path
            this.mc_id_reg.add_hdl_path_slice("mc_id_i",0,32);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_en_o",0,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_rf_cfg_sel_o",1,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_debug_en_o",2,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_wl_vmc_en_o",3,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_bl_vmc_en_o",4,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_bist_en_o",5,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_rescan_addr_range_sel_o",6,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_csl_scan_addr_range_sel_o",7,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_csl_scan_check_sel_o",8,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_csl_scan_mode_sel_o",9,1);
            this.phy_timing_cfg0_reg.add_hdl_path_slice("bank_radd_set_time_o",0,4);
            this.phy_timing_cfg0_reg.add_hdl_path_slice("cadd_set_time_o",4,4);
            this.phy_timing_cfg0_reg.add_hdl_path_slice("r_cas_set_time_o",8,8);
            this.phy_timing_cfg0_reg.add_hdl_path_slice("w_cas_set_time_o",16,8);
            this.phy_timing_cfg0_reg.add_hdl_path_slice("cas_wrrdy_time_o",24,8);
            this.mc_rf_period_cfg1_reg.add_hdl_path_slice("mc_rf_period_1_o",0,32);
            this.mc_rf_start_cfg1_reg.add_hdl_path_slice("mc_rf_start_1_o",0,32);
            this.mc_rf_period_cfg2_reg.add_hdl_path_slice("mc_rf_period_2_o",0,32);
            this.mc_rf_start_cfg2_reg.add_hdl_path_slice("mc_rf_start_2_o",0,32);
            this.mc_vmc_wl_num0_reg.add_hdl_path_slice("mc_vmc_wl_num0_o",0,13);
            this.mc_vmc_wl_num0_reg.add_hdl_path_slice("mc_vmc_wl_num1_o",16,13);
            this.mc_vmc_wl_num1_reg.add_hdl_path_slice("mc_vmc_wl_num2_o",0,13);
            this.mc_vmc_wl_num1_reg.add_hdl_path_slice("mc_vmc_wl_num3_o",16,13);
            this.mc_vmc_wl_num2_reg.add_hdl_path_slice("mc_vmc_wl_num4_o",0,13);
            this.mc_vmc_wl_num2_reg.add_hdl_path_slice("mc_vmc_wl_num5_o",16,13);
            this.mc_vmc_wl_num3_reg.add_hdl_path_slice("mc_vmc_wl_num6_o",0,13);
            this.mc_vmc_wl_num3_reg.add_hdl_path_slice("mc_vmc_wl_num7_o",16,13);
            this.mc_vmc_wl_num4_reg.add_hdl_path_slice("mc_vmc_wl_num8_o",0,13);
            this.mc_vmc_wl_num4_reg.add_hdl_path_slice("mc_vmc_wl_num9_o",16,13);
            this.mc_vmc_wl_num5_reg.add_hdl_path_slice("mc_vmc_wl_num10_o",0,13);
            this.mc_vmc_wl_num5_reg.add_hdl_path_slice("mc_vmc_wl_num11_o",16,13);
            this.mc_vmc_wl_num6_reg.add_hdl_path_slice("mc_vmc_wl_num12_o",0,13);
            this.mc_vmc_wl_num6_reg.add_hdl_path_slice("mc_vmc_wl_num13_o",16,13);
            this.mc_vmc_wl_num7_reg.add_hdl_path_slice("mc_vmc_wl_num14_o",0,13);
            this.mc_vmc_wl_num7_reg.add_hdl_path_slice("mc_vmc_wl_num15_o",16,13);
            this.mc_vmc_wl_num8_reg.add_hdl_path_slice("mc_vmc_wl_num16_o",0,13);
            this.mc_vmc_wl_num8_reg.add_hdl_path_slice("mc_vmc_wl_num17_o",16,13);
            this.mc_vmc_wl_num9_reg.add_hdl_path_slice("mc_vmc_wl_num18_o",0,13);
            this.mc_vmc_wl_num9_reg.add_hdl_path_slice("mc_vmc_wl_num19_o",16,13);
            this.mc_vmc_wl_num10_reg.add_hdl_path_slice("mc_vmc_wl_num20_o",0,13);
            this.mc_vmc_wl_num10_reg.add_hdl_path_slice("mc_vmc_wl_num21_o",16,13);
            this.mc_vmc_wl_num11_reg.add_hdl_path_slice("mc_vmc_wl_num22_o",0,13);
            this.mc_vmc_wl_num11_reg.add_hdl_path_slice("mc_vmc_wl_num23_o",16,13);
            this.mc_vmc_wl_num12_reg.add_hdl_path_slice("mc_vmc_wl_num24_o",0,13);
            this.mc_vmc_wl_num12_reg.add_hdl_path_slice("mc_vmc_wl_num25_o",16,13);
            this.mc_vmc_wl_num13_reg.add_hdl_path_slice("mc_vmc_wl_num26_o",0,13);
            this.mc_vmc_wl_num13_reg.add_hdl_path_slice("mc_vmc_wl_num27_o",16,13);
            this.mc_vmc_wl_num14_reg.add_hdl_path_slice("mc_vmc_wl_num28_o",0,13);
            this.mc_vmc_wl_num14_reg.add_hdl_path_slice("mc_vmc_wl_num29_o",16,13);
            this.mc_vmc_wl_num15_reg.add_hdl_path_slice("mc_vmc_wl_num30_o",0,13);
            this.mc_vmc_wl_num15_reg.add_hdl_path_slice("mc_vmc_wl_num31_o",16,13);
            this.mc_vmc_wl_num16_reg.add_hdl_path_slice("mc_vmc_wl_num32_o",0,13);
            this.mc_vmc_wl_num16_reg.add_hdl_path_slice("mc_vmc_wl_num33_o",16,13);
            this.mc_vmc_wl_num17_reg.add_hdl_path_slice("mc_vmc_wl_num34_o",0,13);
            this.mc_vmc_wl_num17_reg.add_hdl_path_slice("mc_vmc_wl_num35_o",16,13);
            this.mc_vmc_wl_num18_reg.add_hdl_path_slice("mc_vmc_wl_num36_o",0,13);
            this.mc_vmc_wl_num18_reg.add_hdl_path_slice("mc_vmc_wl_num37_o",16,13);
            this.mc_vmc_wl_num19_reg.add_hdl_path_slice("mc_vmc_wl_num38_o",0,13);
            this.mc_vmc_wl_num19_reg.add_hdl_path_slice("mc_vmc_wl_num39_o",16,13);
            this.mc_vmc_wl_num20_reg.add_hdl_path_slice("mc_vmc_wl_num40_o",0,13);
            this.mc_vmc_wl_num20_reg.add_hdl_path_slice("mc_vmc_wl_num41_o",16,13);
            this.mc_vmc_wl_num21_reg.add_hdl_path_slice("mc_vmc_wl_num42_o",0,13);
            this.mc_vmc_wl_num21_reg.add_hdl_path_slice("mc_vmc_wl_num43_o",16,13);
            this.mc_vmc_wl_num22_reg.add_hdl_path_slice("mc_vmc_wl_num44_o",0,13);
            this.mc_vmc_wl_num22_reg.add_hdl_path_slice("mc_vmc_wl_num45_o",16,13);
            this.mc_vmc_wl_num23_reg.add_hdl_path_slice("mc_vmc_wl_num46_o",0,13);
            this.mc_vmc_wl_num23_reg.add_hdl_path_slice("mc_vmc_wl_num47_o",16,13);
            this.mc_vmc_wl_num24_reg.add_hdl_path_slice("mc_vmc_wl_num48_o",0,13);
            this.mc_vmc_wl_num24_reg.add_hdl_path_slice("mc_vmc_wl_num49_o",16,13);
            this.mc_vmc_wl_num25_reg.add_hdl_path_slice("mc_vmc_wl_num50_o",0,13);
            this.mc_vmc_wl_num25_reg.add_hdl_path_slice("mc_vmc_wl_num51_o",16,13);
            this.mc_vmc_wl_num26_reg.add_hdl_path_slice("mc_vmc_wl_num52_o",0,13);
            this.mc_vmc_wl_num26_reg.add_hdl_path_slice("mc_vmc_wl_num53_o",16,13);
            this.mc_vmc_wl_num27_reg.add_hdl_path_slice("mc_vmc_wl_num54_o",0,13);
            this.mc_vmc_wl_num27_reg.add_hdl_path_slice("mc_vmc_wl_num55_o",16,13);
            this.mc_vmc_wl_num28_reg.add_hdl_path_slice("mc_vmc_wl_num56_o",0,13);
            this.mc_vmc_wl_num28_reg.add_hdl_path_slice("mc_vmc_wl_num57_o",16,13);
            this.mc_vmc_wl_num29_reg.add_hdl_path_slice("mc_vmc_wl_num58_o",0,13);
            this.mc_vmc_wl_num29_reg.add_hdl_path_slice("mc_vmc_wl_num59_o",16,13);
            this.mc_vmc_wl_num30_reg.add_hdl_path_slice("mc_vmc_wl_num60_o",0,13);
            this.mc_vmc_wl_num30_reg.add_hdl_path_slice("mc_vmc_wl_num61_o",16,13);
            this.mc_vmc_wl_num31_reg.add_hdl_path_slice("mc_vmc_wl_num62_o",0,13);
            this.mc_vmc_wl_num31_reg.add_hdl_path_slice("mc_vmc_wl_num63_o",16,13);
            this.mc_vmc_bl_num0_reg.add_hdl_path_slice("mc_vmc_bl_num0_part0_o",0,8);
            this.mc_vmc_bl_num0_reg.add_hdl_path_slice("mc_vmc_bl_num1_part0_o",8,8);
            this.mc_vmc_bl_num0_reg.add_hdl_path_slice("mc_vmc_bl_num0_part1_o",16,8);
            this.mc_vmc_bl_num0_reg.add_hdl_path_slice("mc_vmc_bl_num1_part1_o",24,8);
            this.mc_vmc_bl_num1_reg.add_hdl_path_slice("mc_vmc_bl_num0_part2_o",0,8);
            this.mc_vmc_bl_num1_reg.add_hdl_path_slice("mc_vmc_bl_num1_part2_o",8,8);
            this.mc_vmc_bl_num1_reg.add_hdl_path_slice("mc_vmc_bl_num0_part3_o",16,8);
            this.mc_vmc_bl_num1_reg.add_hdl_path_slice("mc_vmc_bl_num1_part3_o",24,8);
            this.mc_vmc_bl_num2_reg.add_hdl_path_slice("mc_vmc_bl_num0_part4_o",0,8);
            this.mc_vmc_bl_num2_reg.add_hdl_path_slice("mc_vmc_bl_num1_part4_o",8,8);
            this.mc_vmc_bl_num2_reg.add_hdl_path_slice("mc_vmc_bl_num0_part5_o",16,8);
            this.mc_vmc_bl_num2_reg.add_hdl_path_slice("mc_vmc_bl_num1_part5_o",24,8);
            this.mc_vmc_bl_num3_reg.add_hdl_path_slice("mc_vmc_bl_num0_part6_o",0,8);
            this.mc_vmc_bl_num3_reg.add_hdl_path_slice("mc_vmc_bl_num1_part6_o",8,8);
            this.mc_vmc_bl_num3_reg.add_hdl_path_slice("mc_vmc_bl_num0_part7_o",16,8);
            this.mc_vmc_bl_num3_reg.add_hdl_path_slice("mc_vmc_bl_num1_part7_o",24,8);
            this.mc_vmc_bl_num4_reg.add_hdl_path_slice("mc_vmc_bl_num0_part8_o",0,8);
            this.mc_vmc_bl_num4_reg.add_hdl_path_slice("mc_vmc_bl_num1_part8_o",8,8);
            this.mc_vmc_bl_num4_reg.add_hdl_path_slice("mc_vmc_bl_num0_part9_o",16,8);
            this.mc_vmc_bl_num4_reg.add_hdl_path_slice("mc_vmc_bl_num1_part9_o",24,8);
            this.mc_frame2array_dbg_reg.add_hdl_path_slice("dbg_next_state_array_i",0,5);
            this.mc_frame2array_dbg_reg.add_hdl_path_slice("dbg_current_state_array_i",8,5);
            this.mc_frame2array_dbg_reg.add_hdl_path_slice("dbg_r_data_cnt_i",16,2);
            this.mc_frame2array_dbg_reg.add_hdl_path_slice("dbg_refresh_flag_i",20,1);
            this.mc_frame2array_dbg_reg.add_hdl_path_slice("dbg_r_frame_cnt_i",24,2);
            this.mc_frame2array_dbg_reg.add_hdl_path_slice("dbg_w_frame_cnt_i",28,2);
            this.mc_frame2array_dbg_reg.add_hdl_path_slice("ras_clr_o",31,1);
            this.mc_timeout_clr_reg.add_hdl_path_slice("mc_timeout_clr_o",0,1);
            this.mc_rf_start_dbg_reg.add_hdl_path_slice("mc_rf_start_dbg_i",0,1);
            this.mc_timeout_flag_reg.add_hdl_path_slice("mc_timeout_flag_i",0,1);
            this.mc_bist_status_reg.add_hdl_path_slice("mc_bist_status_i",0,3);
            this.mc_bist_status_reg.add_hdl_path_slice("mc_bist_path_fail_i",3,1);
            this.mc_bist_status_reg.add_hdl_path_slice("dram_init_finish_i",4,1);
            this.bist_finish_reg.add_hdl_path_slice("bist_finish_i",0,1);
            this.bist_finish_reg.add_hdl_path_slice("bist_rescan_finish_i",1,1);
            this.bank_success_reg.add_hdl_path_slice("bank_success_i",0,1);
            this.bank_success_reg.add_hdl_path_slice("bist_rescan_success_i",1,1);
            this.err_csl0_reg.add_hdl_path_slice("err_csl0_part0_i",0,8);
            this.err_csl0_reg.add_hdl_path_slice("err_csl1_part0_i",8,8);
            this.err_csl0_reg.add_hdl_path_slice("err_csl0_part1_i",16,8);
            this.err_csl0_reg.add_hdl_path_slice("err_csl1_part1_i",24,8);
            this.err_csl1_reg.add_hdl_path_slice("err_csl0_part2_i",0,8);
            this.err_csl1_reg.add_hdl_path_slice("err_csl1_part2_i",8,8);
            this.err_csl1_reg.add_hdl_path_slice("err_csl0_part3_i",16,8);
            this.err_csl1_reg.add_hdl_path_slice("err_csl1_part3_i",24,8);
            this.err_csl2_reg.add_hdl_path_slice("err_csl0_part4_i",0,8);
            this.err_csl2_reg.add_hdl_path_slice("err_csl1_part4_i",8,8);
            this.err_csl2_reg.add_hdl_path_slice("err_csl0_part5_i",16,8);
            this.err_csl2_reg.add_hdl_path_slice("err_csl1_part5_i",24,8);
            this.err_csl3_reg.add_hdl_path_slice("err_csl0_part6_i",0,8);
            this.err_csl3_reg.add_hdl_path_slice("err_csl1_part6_i",8,8);
            this.err_csl3_reg.add_hdl_path_slice("err_csl0_part7_i",16,8);
            this.err_csl3_reg.add_hdl_path_slice("err_csl1_part7_i",24,8);
            this.err_csl4_reg.add_hdl_path_slice("err_csl0_part8_i",0,8);
            this.err_csl4_reg.add_hdl_path_slice("err_csl1_part8_i",8,8);
            this.err_csl4_reg.add_hdl_path_slice("err_csl0_part9_i",16,8);
            this.err_csl4_reg.add_hdl_path_slice("err_csl1_part9_i",24,8);
            this.err_wl0_reg.add_hdl_path_slice("err_wl0_i",0,13);
            this.err_wl0_reg.add_hdl_path_slice("err_wl1_i",16,13);
            this.err_wl1_reg.add_hdl_path_slice("err_wl2_i",0,13);
            this.err_wl1_reg.add_hdl_path_slice("err_wl3_i",16,13);
            this.err_wl2_reg.add_hdl_path_slice("err_wl4_i",0,13);
            this.err_wl2_reg.add_hdl_path_slice("err_wl5_i",16,13);
            this.err_wl3_reg.add_hdl_path_slice("err_wl6_i",0,13);
            this.err_wl3_reg.add_hdl_path_slice("err_wl7_i",16,13);
            this.err_wl4_reg.add_hdl_path_slice("err_wl8_i",0,13);
            this.err_wl4_reg.add_hdl_path_slice("err_wl9_i",16,13);
            this.err_wl5_reg.add_hdl_path_slice("err_wl10_i",0,13);
            this.err_wl5_reg.add_hdl_path_slice("err_wl11_i",16,13);
            this.err_wl6_reg.add_hdl_path_slice("err_wl12_i",0,13);
            this.err_wl6_reg.add_hdl_path_slice("err_wl13_i",16,13);
            this.err_wl7_reg.add_hdl_path_slice("err_wl14_i",0,13);
            this.err_wl7_reg.add_hdl_path_slice("err_wl15_i",16,13);
            this.err_wl8_reg.add_hdl_path_slice("err_wl16_i",0,13);
            this.err_wl8_reg.add_hdl_path_slice("err_wl17_i",16,13);
            this.err_wl9_reg.add_hdl_path_slice("err_wl18_i",0,13);
            this.err_wl9_reg.add_hdl_path_slice("err_wl19_i",16,13);
            this.err_wl10_reg.add_hdl_path_slice("err_wl20_i",0,13);
            this.err_wl10_reg.add_hdl_path_slice("err_wl21_i",16,13);
            this.err_wl11_reg.add_hdl_path_slice("err_wl22_i",0,13);
            this.err_wl11_reg.add_hdl_path_slice("err_wl23_i",16,13);
            this.err_wl12_reg.add_hdl_path_slice("err_wl24_i",0,13);
            this.err_wl12_reg.add_hdl_path_slice("err_wl25_i",16,13);
            this.err_wl13_reg.add_hdl_path_slice("err_wl26_i",0,13);
            this.err_wl13_reg.add_hdl_path_slice("err_wl27_i",16,13);
            this.err_wl14_reg.add_hdl_path_slice("err_wl28_i",0,13);
            this.err_wl14_reg.add_hdl_path_slice("err_wl29_i",16,13);
            this.err_wl15_reg.add_hdl_path_slice("err_wl30_i",0,13);
            this.err_wl15_reg.add_hdl_path_slice("err_wl31_i",16,13);
            this.err_wl16_reg.add_hdl_path_slice("err_wl32_i",0,13);
            this.err_wl16_reg.add_hdl_path_slice("err_wl33_i",16,13);
            this.err_wl17_reg.add_hdl_path_slice("err_wl34_i",0,13);
            this.err_wl17_reg.add_hdl_path_slice("err_wl35_i",16,13);
            this.err_wl18_reg.add_hdl_path_slice("err_wl36_i",0,13);
            this.err_wl18_reg.add_hdl_path_slice("err_wl37_i",16,13);
            this.err_wl19_reg.add_hdl_path_slice("err_wl38_i",0,13);
            this.err_wl19_reg.add_hdl_path_slice("err_wl39_i",16,13);
            this.err_wl20_reg.add_hdl_path_slice("err_wl40_i",0,13);
            this.err_wl20_reg.add_hdl_path_slice("err_wl41_i",16,13);
            this.err_wl21_reg.add_hdl_path_slice("err_wl42_i",0,13);
            this.err_wl21_reg.add_hdl_path_slice("err_wl43_i",16,13);
            this.err_wl22_reg.add_hdl_path_slice("err_wl44_i",0,13);
            this.err_wl22_reg.add_hdl_path_slice("err_wl45_i",16,13);
            this.err_wl23_reg.add_hdl_path_slice("err_wl46_i",0,13);
            this.err_wl23_reg.add_hdl_path_slice("err_wl47_i",16,13);
            this.err_wl24_reg.add_hdl_path_slice("err_wl48_i",0,13);
            this.err_wl24_reg.add_hdl_path_slice("err_wl49_i",16,13);
            this.err_wl25_reg.add_hdl_path_slice("err_wl50_i",0,13);
            this.err_wl25_reg.add_hdl_path_slice("err_wl51_i",16,13);
            this.err_wl26_reg.add_hdl_path_slice("err_wl52_i",0,13);
            this.err_wl26_reg.add_hdl_path_slice("err_wl53_i",16,13);
            this.err_wl27_reg.add_hdl_path_slice("err_wl54_i",0,13);
            this.err_wl27_reg.add_hdl_path_slice("err_wl55_i",16,13);
            this.err_wl28_reg.add_hdl_path_slice("err_wl56_i",0,13);
            this.err_wl28_reg.add_hdl_path_slice("err_wl57_i",16,13);
            this.err_wl29_reg.add_hdl_path_slice("err_wl58_i",0,13);
            this.err_wl29_reg.add_hdl_path_slice("err_wl59_i",16,13);
            this.err_wl30_reg.add_hdl_path_slice("err_wl60_i",0,13);
            this.err_wl30_reg.add_hdl_path_slice("err_wl61_i",16,13);
            this.err_wl31_reg.add_hdl_path_slice("err_wl62_i",0,13);
            this.err_wl31_reg.add_hdl_path_slice("err_wl63_i",16,13);
            this.bist_finish_clr_reg.add_hdl_path_slice("bist_finish_clr_o",0,1);
            this.bist_finish_mask_reg.add_hdl_path_slice("bist_finish_mask_o",0,1);
            this.hang_timeout_th_reg.add_hdl_path_slice("hang_timeout_th_o",0,32);
            this.mc_bist_rescan_fail_num_reg.add_hdl_path_slice("mc_bist_rescan_fail_num_i",0,20);
            this.mc_bist_err_wl_reg.add_hdl_path_slice("mc_bist_err_wl_num_i",0,7);
            this.mc_bist_err_wl_reg.add_hdl_path_slice("err_wl_num_change_flag_i",7,1);
            this.rescan_finish_clr_reg.add_hdl_path_slice("rescan_finish_clr_o",0,1);
            this.rescan_finish_mask_reg.add_hdl_path_slice("rescan_finish_mask_o",0,1);
            this.rescan_round_result_reg.add_hdl_path_slice("rescan_round_result_i",0,15);
            this.dbg_frame_store_0_reg.add_hdl_path_slice("dbg_frame_store_0_i",0,32);
            this.dbg_frame_store_1_reg.add_hdl_path_slice("dbg_frame_store_1_i",0,32);
            this.dbg_frame_store_2_reg.add_hdl_path_slice("dbg_frame_store_2_i",0,32);
            this.dbg_frame_store_3_reg.add_hdl_path_slice("dbg_frame_store_3_i",0,32);
            this.dbg_frame_store_4_reg.add_hdl_path_slice("dbg_frame_store_4_i",0,32);
            this.dbg_frame_store_5_reg.add_hdl_path_slice("dbg_frame_store_5_i",0,32);
            this.dbg_frame_store_6_reg.add_hdl_path_slice("dbg_frame_store_6_i",0,32);
            this.dbg_frame_store_7_reg.add_hdl_path_slice("dbg_frame_store_7_i",0,32);
            this.dbg_frame_store_8_reg.add_hdl_path_slice("dbg_frame_store_8_i",0,32);
            this.dbg_frame_store_9_reg.add_hdl_path_slice("dbg_frame_store_9_i",0,2);
            this.dbg_rdata_store_0_reg.add_hdl_path_slice("dbg_rdata_store_0_i",0,32);
            this.dbg_rdata_store_1_reg.add_hdl_path_slice("dbg_rdata_store_1_i",0,32);
            this.dbg_rdata_store_2_reg.add_hdl_path_slice("dbg_rdata_store_2_i",0,32);
            this.dbg_rdata_store_3_reg.add_hdl_path_slice("dbg_rdata_store_3_i",0,32);
            this.dbg_rdata_store_4_reg.add_hdl_path_slice("dbg_rdata_store_4_i",0,32);
            this.dbg_rdata_store_5_reg.add_hdl_path_slice("dbg_rdata_store_5_i",0,32);
            this.dbg_rdata_store_6_reg.add_hdl_path_slice("dbg_rdata_store_6_i",0,32);
            this.dbg_rdata_store_7_reg.add_hdl_path_slice("dbg_rdata_store_7_i",0,32);
            this.dbg_rdata_store_8_reg.add_hdl_path_slice("dbg_rdata_store_8_i",0,10);
            this.bist_pattern_reg0_reg.add_hdl_path_slice("bist_pattern_reg0_o",0,32);
            this.bist_pattern_reg1_reg.add_hdl_path_slice("bist_pattern_reg1_o",0,32);
            this.bist_pattern_reg2_reg.add_hdl_path_slice("bist_pattern_reg2_o",0,32);
            this.bist_pattern_reg3_reg.add_hdl_path_slice("bist_pattern_reg3_o",0,32);
            this.csl_bist_pattern_sel0_reg.add_hdl_path_slice("csl_bist_pattern_sel0_o",0,32);
            this.csl_bist_pattern_sel1_reg.add_hdl_path_slice("csl_bist_pattern_sel1_o",0,32);
            this.csl_bist_pattern_sel2_reg.add_hdl_path_slice("csl_bist_pattern_sel2_o",0,4);
            this.wl_bist_pattern_sel0_reg.add_hdl_path_slice("wl_bist_pattern_sel0_o",0,32);
            this.wl_bist_pattern_sel1_reg.add_hdl_path_slice("wl_bist_pattern_sel1_o",0,32);
            this.wl_bist_pattern_sel2_reg.add_hdl_path_slice("wl_bist_pattern_sel2_o",0,4);
            this.mc_ecc_ctrl_reg.add_hdl_path_slice("mc_ecc_en_o",0,1);
            this.mc_ecc_ctrl_reg.add_hdl_path_slice("mc_ecc_ce_th_o",4,5);
            this.mc_ecc_ctrl_reg.add_hdl_path_slice("mc_ecc_ce_int_clr_o",16,1);
            this.mc_ecc_ctrl_reg.add_hdl_path_slice("mc_ecc_ce_int_mask_o",20,1);
            this.mc_ecc_ctrl_reg.add_hdl_path_slice("mc_ecc_uce_int_clr_o",24,1);
            this.mc_ecc_ctrl_reg.add_hdl_path_slice("mc_ecc_uce_int_mask_o",28,1);
            this.mc_ecc_int_status_reg.add_hdl_path_slice("mc_ecc_ce_int_status_i",0,1);
            this.mc_ecc_int_status_reg.add_hdl_path_slice("mc_ecc_uce_int_status_i",4,1);
            this.mc_ecc_int_status_reg.add_hdl_path_slice("mc_ecc_ce_cnt_i",8,5);
            this.mc_ecc_ce_addr0_reg.add_hdl_path_slice("mc_ecc_ce_addr0_i",0,32);
            this.mc_ecc_ce_addr1_reg.add_hdl_path_slice("mc_ecc_ce_addr1_i",0,32);
            this.mc_ecc_ce_addr2_reg.add_hdl_path_slice("mc_ecc_ce_addr2_i",0,32);
            this.mc_ecc_ce_addr3_reg.add_hdl_path_slice("mc_ecc_ce_addr3_i",0,32);
            this.mc_ecc_ce_addr4_reg.add_hdl_path_slice("mc_ecc_ce_addr4_i",0,32);
            this.mc_ecc_ce_addr5_reg.add_hdl_path_slice("mc_ecc_ce_addr5_i",0,32);
            this.mc_ecc_ce_addr6_reg.add_hdl_path_slice("mc_ecc_ce_addr6_i",0,32);
            this.mc_ecc_ce_addr7_reg.add_hdl_path_slice("mc_ecc_ce_addr7_i",0,32);
            this.mc_ecc_ce_addr8_reg.add_hdl_path_slice("mc_ecc_ce_addr8_i",0,32);
            this.mc_ecc_ce_addr9_reg.add_hdl_path_slice("mc_ecc_ce_addr9_i",0,32);
            this.mc_ecc_ce_addr10_reg.add_hdl_path_slice("mc_ecc_ce_addr10_i",0,32);
            this.mc_ecc_ce_addr11_reg.add_hdl_path_slice("mc_ecc_ce_addr11_i",0,32);
            this.mc_ecc_ce_addr12_reg.add_hdl_path_slice("mc_ecc_ce_addr12_i",0,32);
            this.mc_ecc_ce_addr13_reg.add_hdl_path_slice("mc_ecc_ce_addr13_i",0,32);
            this.mc_ecc_ce_addr14_reg.add_hdl_path_slice("mc_ecc_ce_addr14_i",0,32);
            this.mc_ecc_ce_addr15_reg.add_hdl_path_slice("mc_ecc_ce_addr15_i",0,32);
            this.mc_ecc_uce_addr0_reg.add_hdl_path_slice("mc_ecc_uce_addr0_i",0,32);
            this.mc_ecc_uce_addr1_reg.add_hdl_path_slice("mc_ecc_uce_addr1_i",0,32);
            this.mc_ecc_uce_addr2_reg.add_hdl_path_slice("mc_ecc_uce_addr2_i",0,32);
            this.mc_ecc_uce_addr3_reg.add_hdl_path_slice("mc_ecc_uce_addr3_i",0,32);
            this.bist_scan_ctrl_reg.add_hdl_path_slice("bist_scan_start_bank_o",0,1);
            this.bist_scan_ctrl_reg.add_hdl_path_slice("bist_scan_end_bank_o",4,1);
            this.axi2frame_dbg0_reg.add_hdl_path_slice("a2f_dbg_ar_cnt_i",0,32);
            this.axi2frame_dbg1_reg.add_hdl_path_slice("a2f_dbg_r_cnt_i",0,32);
            this.axi2frame_dbg2_reg.add_hdl_path_slice("a2f_dbg_aw_cnt_i",0,32);
            this.axi2frame_dbg3_reg.add_hdl_path_slice("a2f_dbg_w_cnt_i",0,32);
            this.axi2frame_dbg4_reg.add_hdl_path_slice("a2f_dbg_b_cnt_i",0,32);
            this.axi2frame_dbg5_reg.add_hdl_path_slice("a2f_dbg_axi_len_err_addr_i",0,32);
            this.axi2frame_dbg6_reg.add_hdl_path_slice("a2f_dbg_axi_len_err_i",0,1);
            this.axi2frame_dbg7_reg.add_hdl_path_slice("a2f_dbg_reserve_in_o",0,32);
            this.axi2frame_dbg8_reg.add_hdl_path_slice("a2f_dbg_reserve_out_i",0,32);
            this.mc_page_status_reg.add_hdl_path_slice("mc_page_status_i",0,1);
            this.hang_timeout_status_reg.add_hdl_path_slice("hang_timeout_status_i",0,1);
            this.hang_timeout_mask_reg.add_hdl_path_slice("hang_timeout_mask_o",0,1);
            this.hang_timeout_clr_reg.add_hdl_path_slice("hang_timeout_clr_o",0,1);
            this.hang_timeout_en_reg.add_hdl_path_slice("hang_timeout_en_o",0,1);
            this.mc_bank1_vmc_wl_num0_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num0_o",0,13);
            this.mc_bank1_vmc_wl_num0_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num1_o",16,13);
            this.mc_bank1_vmc_wl_num1_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num2_o",0,13);
            this.mc_bank1_vmc_wl_num1_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num3_o",16,13);
            this.mc_bank1_vmc_wl_num2_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num4_o",0,13);
            this.mc_bank1_vmc_wl_num2_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num5_o",16,13);
            this.mc_bank1_vmc_wl_num3_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num6_o",0,13);
            this.mc_bank1_vmc_wl_num3_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num7_o",16,13);
            this.mc_bank1_vmc_wl_num4_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num8_o",0,13);
            this.mc_bank1_vmc_wl_num4_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num9_o",16,13);
            this.mc_bank1_vmc_wl_num5_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num10_o",0,13);
            this.mc_bank1_vmc_wl_num5_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num11_o",16,13);
            this.mc_bank1_vmc_wl_num6_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num12_o",0,13);
            this.mc_bank1_vmc_wl_num6_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num13_o",16,13);
            this.mc_bank1_vmc_wl_num7_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num14_o",0,13);
            this.mc_bank1_vmc_wl_num7_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num15_o",16,13);
            this.mc_bank1_vmc_wl_num8_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num16_o",0,13);
            this.mc_bank1_vmc_wl_num8_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num17_o",16,13);
            this.mc_bank1_vmc_wl_num9_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num18_o",0,13);
            this.mc_bank1_vmc_wl_num9_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num19_o",16,13);
            this.mc_bank1_vmc_wl_num10_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num20_o",0,13);
            this.mc_bank1_vmc_wl_num10_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num21_o",16,13);
            this.mc_bank1_vmc_wl_num11_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num22_o",0,13);
            this.mc_bank1_vmc_wl_num11_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num23_o",16,13);
            this.mc_bank1_vmc_wl_num12_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num24_o",0,13);
            this.mc_bank1_vmc_wl_num12_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num25_o",16,13);
            this.mc_bank1_vmc_wl_num13_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num26_o",0,13);
            this.mc_bank1_vmc_wl_num13_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num27_o",16,13);
            this.mc_bank1_vmc_wl_num14_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num28_o",0,13);
            this.mc_bank1_vmc_wl_num14_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num29_o",16,13);
            this.mc_bank1_vmc_wl_num15_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num30_o",0,13);
            this.mc_bank1_vmc_wl_num15_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num31_o",16,13);
            this.mc_bank1_vmc_wl_num16_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num32_o",0,13);
            this.mc_bank1_vmc_wl_num16_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num33_o",16,13);
            this.mc_bank1_vmc_wl_num17_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num34_o",0,13);
            this.mc_bank1_vmc_wl_num17_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num35_o",16,13);
            this.mc_bank1_vmc_wl_num18_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num36_o",0,13);
            this.mc_bank1_vmc_wl_num18_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num37_o",16,13);
            this.mc_bank1_vmc_wl_num19_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num38_o",0,13);
            this.mc_bank1_vmc_wl_num19_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num39_o",16,13);
            this.mc_bank1_vmc_wl_num20_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num40_o",0,13);
            this.mc_bank1_vmc_wl_num20_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num41_o",16,13);
            this.mc_bank1_vmc_wl_num21_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num42_o",0,13);
            this.mc_bank1_vmc_wl_num21_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num43_o",16,13);
            this.mc_bank1_vmc_wl_num22_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num44_o",0,13);
            this.mc_bank1_vmc_wl_num22_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num45_o",16,13);
            this.mc_bank1_vmc_wl_num23_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num46_o",0,13);
            this.mc_bank1_vmc_wl_num23_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num47_o",16,13);
            this.mc_bank1_vmc_wl_num24_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num48_o",0,13);
            this.mc_bank1_vmc_wl_num24_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num49_o",16,13);
            this.mc_bank1_vmc_wl_num25_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num50_o",0,13);
            this.mc_bank1_vmc_wl_num25_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num51_o",16,13);
            this.mc_bank1_vmc_wl_num26_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num52_o",0,13);
            this.mc_bank1_vmc_wl_num26_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num53_o",16,13);
            this.mc_bank1_vmc_wl_num27_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num54_o",0,13);
            this.mc_bank1_vmc_wl_num27_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num55_o",16,13);
            this.mc_bank1_vmc_wl_num28_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num56_o",0,13);
            this.mc_bank1_vmc_wl_num28_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num57_o",16,13);
            this.mc_bank1_vmc_wl_num29_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num58_o",0,13);
            this.mc_bank1_vmc_wl_num29_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num59_o",16,13);
            this.mc_bank1_vmc_wl_num30_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num60_o",0,13);
            this.mc_bank1_vmc_wl_num30_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num61_o",16,13);
            this.mc_bank1_vmc_wl_num31_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num62_o",0,13);
            this.mc_bank1_vmc_wl_num31_reg.add_hdl_path_slice("mc_bank1_vmc_wl_num63_o",16,13);
            this.mc_bank1_vmc_bl_num0_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num0_part0_o",0,8);
            this.mc_bank1_vmc_bl_num0_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num1_part0_o",8,8);
            this.mc_bank1_vmc_bl_num0_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num0_part1_o",16,8);
            this.mc_bank1_vmc_bl_num0_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num1_part1_o",24,8);
            this.mc_bank1_vmc_bl_num1_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num0_part2_o",0,8);
            this.mc_bank1_vmc_bl_num1_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num1_part2_o",8,8);
            this.mc_bank1_vmc_bl_num1_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num0_part3_o",16,8);
            this.mc_bank1_vmc_bl_num1_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num1_part3_o",24,8);
            this.mc_bank1_vmc_bl_num2_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num0_part4_o",0,8);
            this.mc_bank1_vmc_bl_num2_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num1_part4_o",8,8);
            this.mc_bank1_vmc_bl_num2_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num0_part5_o",16,8);
            this.mc_bank1_vmc_bl_num2_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num1_part5_o",24,8);
            this.mc_bank1_vmc_bl_num3_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num0_part6_o",0,8);
            this.mc_bank1_vmc_bl_num3_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num1_part6_o",8,8);
            this.mc_bank1_vmc_bl_num3_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num0_part7_o",16,8);
            this.mc_bank1_vmc_bl_num3_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num1_part7_o",24,8);
            this.mc_bank1_vmc_bl_num4_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num0_part8_o",0,8);
            this.mc_bank1_vmc_bl_num4_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num1_part8_o",8,8);
            this.mc_bank1_vmc_bl_num4_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num0_part9_o",16,8);
            this.mc_bank1_vmc_bl_num4_reg.add_hdl_path_slice("mc_bank1_vmc_bl_num1_part9_o",24,8);
            this.bank1_err_wl_num0_reg.add_hdl_path_slice("bank1_err_wl0_i",0,13);
            this.bank1_err_wl_num0_reg.add_hdl_path_slice("bank1_err_wl1_i",16,13);
            this.bank1_err_wl_num1_reg.add_hdl_path_slice("bank1_err_wl2_i",0,13);
            this.bank1_err_wl_num1_reg.add_hdl_path_slice("bank1_err_wl3_i",16,13);
            this.bank1_err_wl_num2_reg.add_hdl_path_slice("bank1_err_wl4_i",0,13);
            this.bank1_err_wl_num2_reg.add_hdl_path_slice("bank1_err_wl5_i",16,13);
            this.bank1_err_wl_num3_reg.add_hdl_path_slice("bank1_err_wl6_i",0,13);
            this.bank1_err_wl_num3_reg.add_hdl_path_slice("bank1_err_wl7_i",16,13);
            this.bank1_err_wl_num4_reg.add_hdl_path_slice("bank1_err_wl8_i",0,13);
            this.bank1_err_wl_num4_reg.add_hdl_path_slice("bank1_err_wl9_i",16,13);
            this.bank1_err_wl_num5_reg.add_hdl_path_slice("bank1_err_wl10_i",0,13);
            this.bank1_err_wl_num5_reg.add_hdl_path_slice("bank1_err_wl11_i",16,13);
            this.bank1_err_wl_num6_reg.add_hdl_path_slice("bank1_err_wl12_i",0,13);
            this.bank1_err_wl_num6_reg.add_hdl_path_slice("bank1_err_wl13_i",16,13);
            this.bank1_err_wl_num7_reg.add_hdl_path_slice("bank1_err_wl14_i",0,13);
            this.bank1_err_wl_num7_reg.add_hdl_path_slice("bank1_err_wl15_i",16,13);
            this.bank1_err_wl_num8_reg.add_hdl_path_slice("bank1_err_wl16_i",0,13);
            this.bank1_err_wl_num8_reg.add_hdl_path_slice("bank1_err_wl17_i",16,13);
            this.bank1_err_wl_num9_reg.add_hdl_path_slice("bank1_err_wl18_i",0,13);
            this.bank1_err_wl_num9_reg.add_hdl_path_slice("bank1_err_wl19_i",16,13);
            this.bank1_err_wl_num10_reg.add_hdl_path_slice("bank1_err_wl20_i",0,13);
            this.bank1_err_wl_num10_reg.add_hdl_path_slice("bank1_err_wl21_i",16,13);
            this.bank1_err_wl_num11_reg.add_hdl_path_slice("bank1_err_wl22_i",0,13);
            this.bank1_err_wl_num11_reg.add_hdl_path_slice("bank1_err_wl23_i",16,13);
            this.bank1_err_wl_num12_reg.add_hdl_path_slice("bank1_err_wl24_i",0,13);
            this.bank1_err_wl_num12_reg.add_hdl_path_slice("bank1_err_wl25_i",16,13);
            this.bank1_err_wl_num13_reg.add_hdl_path_slice("bank1_err_wl26_i",0,13);
            this.bank1_err_wl_num13_reg.add_hdl_path_slice("bank1_err_wl27_i",16,13);
            this.bank1_err_wl_num14_reg.add_hdl_path_slice("bank1_err_wl28_i",0,13);
            this.bank1_err_wl_num14_reg.add_hdl_path_slice("bank1_err_wl29_i",16,13);
            this.bank1_err_wl_num15_reg.add_hdl_path_slice("bank1_err_wl30_i",0,13);
            this.bank1_err_wl_num15_reg.add_hdl_path_slice("bank1_err_wl31_i",16,13);
            this.bank1_err_wl_num16_reg.add_hdl_path_slice("bank1_err_wl32_i",0,13);
            this.bank1_err_wl_num16_reg.add_hdl_path_slice("bank1_err_wl33_i",16,13);
            this.bank1_err_wl_num17_reg.add_hdl_path_slice("bank1_err_wl34_i",0,13);
            this.bank1_err_wl_num17_reg.add_hdl_path_slice("bank1_err_wl35_i",16,13);
            this.bank1_err_wl_num18_reg.add_hdl_path_slice("bank1_err_wl36_i",0,13);
            this.bank1_err_wl_num18_reg.add_hdl_path_slice("bank1_err_wl37_i",16,13);
            this.bank1_err_wl_num19_reg.add_hdl_path_slice("bank1_err_wl38_i",0,13);
            this.bank1_err_wl_num19_reg.add_hdl_path_slice("bank1_err_wl39_i",16,13);
            this.bank1_err_wl_num20_reg.add_hdl_path_slice("bank1_err_wl40_i",0,13);
            this.bank1_err_wl_num20_reg.add_hdl_path_slice("bank1_err_wl41_i",16,13);
            this.bank1_err_wl_num21_reg.add_hdl_path_slice("bank1_err_wl42_i",0,13);
            this.bank1_err_wl_num21_reg.add_hdl_path_slice("bank1_err_wl43_i",16,13);
            this.bank1_err_wl_num22_reg.add_hdl_path_slice("bank1_err_wl44_i",0,13);
            this.bank1_err_wl_num22_reg.add_hdl_path_slice("bank1_err_wl45_i",16,13);
            this.bank1_err_wl_num23_reg.add_hdl_path_slice("bank1_err_wl46_i",0,13);
            this.bank1_err_wl_num23_reg.add_hdl_path_slice("bank1_err_wl47_i",16,13);
            this.bank1_err_wl_num24_reg.add_hdl_path_slice("bank1_err_wl48_i",0,13);
            this.bank1_err_wl_num24_reg.add_hdl_path_slice("bank1_err_wl49_i",16,13);
            this.bank1_err_wl_num25_reg.add_hdl_path_slice("bank1_err_wl50_i",0,13);
            this.bank1_err_wl_num25_reg.add_hdl_path_slice("bank1_err_wl51_i",16,13);
            this.bank1_err_wl_num26_reg.add_hdl_path_slice("bank1_err_wl52_i",0,13);
            this.bank1_err_wl_num26_reg.add_hdl_path_slice("bank1_err_wl53_i",16,13);
            this.bank1_err_wl_num27_reg.add_hdl_path_slice("bank1_err_wl54_i",0,13);
            this.bank1_err_wl_num27_reg.add_hdl_path_slice("bank1_err_wl55_i",16,13);
            this.bank1_err_wl_num28_reg.add_hdl_path_slice("bank1_err_wl56_i",0,13);
            this.bank1_err_wl_num28_reg.add_hdl_path_slice("bank1_err_wl57_i",16,13);
            this.bank1_err_wl_num29_reg.add_hdl_path_slice("bank1_err_wl58_i",0,13);
            this.bank1_err_wl_num29_reg.add_hdl_path_slice("bank1_err_wl59_i",16,13);
            this.bank1_err_wl_num30_reg.add_hdl_path_slice("bank1_err_wl60_i",0,13);
            this.bank1_err_wl_num30_reg.add_hdl_path_slice("bank1_err_wl61_i",16,13);
            this.bank1_err_wl_num31_reg.add_hdl_path_slice("bank1_err_wl62_i",0,13);
            this.bank1_err_wl_num31_reg.add_hdl_path_slice("bank1_err_wl63_i",16,13);
            this.bank1_err_csl0_part0_reg.add_hdl_path_slice("bank1_err_csl0_part0_i",0,8);
            this.bank1_err_csl1_part0_reg.add_hdl_path_slice("bank1_err_csl1_part0_i",0,8);
            this.bank1_err_csl0_part1_reg.add_hdl_path_slice("bank1_err_csl0_part1_i",0,8);
            this.bank1_err_csl1_part1_reg.add_hdl_path_slice("bank1_err_csl1_part1_i",0,8);
            this.bank1_err_csl0_part2_reg.add_hdl_path_slice("bank1_err_csl0_part2_i",0,8);
            this.bank1_err_csl1_part2_reg.add_hdl_path_slice("bank1_err_csl1_part2_i",0,8);
            this.bank1_err_csl0_part3_reg.add_hdl_path_slice("bank1_err_csl0_part3_i",0,8);
            this.bank1_err_csl1_part3_reg.add_hdl_path_slice("bank1_err_csl1_part3_i",0,8);
            this.bank1_err_csl0_part4_reg.add_hdl_path_slice("bank1_err_csl0_part4_i",0,8);
            this.bank1_err_csl1_part4_reg.add_hdl_path_slice("bank1_err_csl1_part4_i",0,8);
            this.bank1_err_csl0_part5_reg.add_hdl_path_slice("bank1_err_csl0_part5_i",0,8);
            this.bank1_err_csl1_part5_reg.add_hdl_path_slice("bank1_err_csl1_part5_i",0,8);
            this.bank1_err_csl0_part6_reg.add_hdl_path_slice("bank1_err_csl0_part6_i",0,8);
            this.bank1_err_csl1_part6_reg.add_hdl_path_slice("bank1_err_csl1_part6_i",0,8);
            this.bank1_err_csl0_part7_reg.add_hdl_path_slice("bank1_err_csl0_part7_i",0,8);
            this.bank1_err_csl1_part7_reg.add_hdl_path_slice("bank1_err_csl1_part7_i",0,8);
            this.bank1_err_csl0_part8_reg.add_hdl_path_slice("bank1_err_csl0_part8_i",0,8);
            this.bank1_err_csl1_part8_reg.add_hdl_path_slice("bank1_err_csl1_part8_i",0,8);
            this.bank1_err_csl0_part9_reg.add_hdl_path_slice("bank1_err_csl0_part9_i",0,8);
            this.bank1_err_csl1_part9_reg.add_hdl_path_slice("bank1_err_csl1_part9_i",0,8);
            this.mc_bank1_bist_rescan_fail_num_reg.add_hdl_path_slice("mc_bank1_bist_rescan_fail_num_i",0,20);
            this.mc_bank1_bist_err_wl_reg.add_hdl_path_slice("mc_bank1_bist_err_wl_num_i",0,7);
            this.mc_bank1_bist_err_wl_reg.add_hdl_path_slice("err_bank1_wl_num_change_flag_i",7,1);
            this.bank1_rescan_round_result_reg.add_hdl_path_slice("bank1_rescan_round_result_i",0,15);

    endfunction : build

    `uvm_object_utils(ral_block_mc_wrapper_top)

endclass : ral_block_mc_wrapper_top


class ral_sys_mc_wrapper extends uvm_reg_block;

    rand ral_block_mc_wrapper_top MC_WRAPPER_ins;

    function new(string name = "mc_wrapper");
        super.new(name);
    endfunction: new

    function void build();
        this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);

        this.MC_WRAPPER_ins = ral_block_mc_wrapper_top::type_id::create("MC_WRAPPER_ins",,get_full_name());
        this.MC_WRAPPER_ins.configure(this, "");
        this.MC_WRAPPER_ins.build();
        this.default_map.add_submap(this.MC_WRAPPER_ins.default_map, `UVM_REG_ADDR_WIDTH'h0);
        this.MC_WRAPPER_ins.add_hdl_path("mc_wrapper_U.mc_top_U.apb2reg_mc_soc_cfg_if.v");

    endfunction : build

    `uvm_object_utils(ral_sys_mc_wrapper)
endclass : ral_sys_mc_wrapper

`endif
