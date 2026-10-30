`ifndef RAL_mc_1short2_top_aux
`define RAL_mc_1short2_top_aux

`define UVM_REG_ADDR_WIDTH 32

class ral_reg_mc_1short2_top_aux_top_mc_id_reg extends uvm_reg;
    rand uvm_reg_field mc_id;

    function new(string name = "mc_1short2_top_aux_top_mc_id_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_id = uvm_reg_field::type_id::create("mc_id",,get_full_name());
        this.mc_id.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_id_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_id_reg

class ral_reg_mc_1short2_top_aux_top_mc_work_ctrl_reg extends uvm_reg;
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
    rand uvm_reg_field mc_rdata_invert_sel;
    rand uvm_reg_field mc_rdrdy_n_en;
    rand uvm_reg_field mc_rf_en;
    rand uvm_reg_field mc_rf_burst_split_en;
    rand uvm_reg_field mc_fake_bresp_en;
    rand uvm_reg_field mc_ecc_en;
    rand uvm_reg_field mc_all_bank_act_en;
    rand uvm_reg_field mc2phy_dram0_mask;
    rand uvm_reg_field mc2phy_dram1_mask;
    rand uvm_reg_field mc2phy_dram2_mask;
    rand uvm_reg_field mc2phy_dram3_mask;

    function new(string name = "mc_1short2_top_aux_top_mc_work_ctrl_reg");
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
        this.mc_rdata_invert_sel = uvm_reg_field::type_id::create("mc_rdata_invert_sel",,get_full_name());
        this.mc_rdata_invert_sel.configure(this,1,10,"RW",0,32'h0,1,0,0);
        this.mc_rdrdy_n_en = uvm_reg_field::type_id::create("mc_rdrdy_n_en",,get_full_name());
        this.mc_rdrdy_n_en.configure(this,1,11,"RW",0,32'h1,1,0,0);
        this.mc_rf_en = uvm_reg_field::type_id::create("mc_rf_en",,get_full_name());
        this.mc_rf_en.configure(this,1,12,"RW",0,32'h1,1,0,0);
        this.mc_rf_burst_split_en = uvm_reg_field::type_id::create("mc_rf_burst_split_en",,get_full_name());
        this.mc_rf_burst_split_en.configure(this,1,13,"RW",0,32'h1,1,0,0);
        this.mc_fake_bresp_en = uvm_reg_field::type_id::create("mc_fake_bresp_en",,get_full_name());
        this.mc_fake_bresp_en.configure(this,1,14,"RW",0,32'h0,1,0,0);
        this.mc_ecc_en = uvm_reg_field::type_id::create("mc_ecc_en",,get_full_name());
        this.mc_ecc_en.configure(this,1,15,"RW",0,32'h0,1,0,0);
        this.mc_all_bank_act_en = uvm_reg_field::type_id::create("mc_all_bank_act_en",,get_full_name());
        this.mc_all_bank_act_en.configure(this,1,16,"RW",0,32'h0,1,0,0);
        this.mc2phy_dram0_mask = uvm_reg_field::type_id::create("mc2phy_dram0_mask",,get_full_name());
        this.mc2phy_dram0_mask.configure(this,1,17,"RW",0,32'h1,1,0,0);
        this.mc2phy_dram1_mask = uvm_reg_field::type_id::create("mc2phy_dram1_mask",,get_full_name());
        this.mc2phy_dram1_mask.configure(this,1,18,"RW",0,32'h1,1,0,0);
        this.mc2phy_dram2_mask = uvm_reg_field::type_id::create("mc2phy_dram2_mask",,get_full_name());
        this.mc2phy_dram2_mask.configure(this,1,19,"RW",0,32'h1,1,0,0);
        this.mc2phy_dram3_mask = uvm_reg_field::type_id::create("mc2phy_dram3_mask",,get_full_name());
        this.mc2phy_dram3_mask.configure(this,1,20,"RW",0,32'h1,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_work_ctrl_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_work_ctrl_reg

class ral_reg_mc_1short2_top_aux_top_phy_timing_cfg0_reg extends uvm_reg;
    rand uvm_reg_field bank_radd_set_time;
    rand uvm_reg_field cadd_set_time;
    rand uvm_reg_field r_cas_set_time;
    rand uvm_reg_field w_cas_set_time;

    function new(string name = "mc_1short2_top_aux_top_phy_timing_cfg0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bank_radd_set_time = uvm_reg_field::type_id::create("bank_radd_set_time",,get_full_name());
        this.bank_radd_set_time.configure(this,8,0,"RW",0,32'h0,1,0,0);
        this.cadd_set_time = uvm_reg_field::type_id::create("cadd_set_time",,get_full_name());
        this.cadd_set_time.configure(this,4,8,"RW",0,32'h0,1,0,0);
        this.r_cas_set_time = uvm_reg_field::type_id::create("r_cas_set_time",,get_full_name());
        this.r_cas_set_time.configure(this,8,12,"RW",0,32'h0,1,0,0);
        this.w_cas_set_time = uvm_reg_field::type_id::create("w_cas_set_time",,get_full_name());
        this.w_cas_set_time.configure(this,8,20,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_phy_timing_cfg0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_phy_timing_cfg0_reg

class ral_reg_mc_1short2_top_aux_top_mc_rf_period_cfg1_reg extends uvm_reg;
    rand uvm_reg_field mc_rf_period_1;

    function new(string name = "mc_1short2_top_aux_top_mc_rf_period_cfg1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_rf_period_1 = uvm_reg_field::type_id::create("mc_rf_period_1",,get_full_name());
        this.mc_rf_period_1.configure(this,32,0,"RW",0,32'h186A000,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_rf_period_cfg1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_rf_period_cfg1_reg

class ral_reg_mc_1short2_top_aux_top_mc_rf_start_cfg1_reg extends uvm_reg;
    rand uvm_reg_field mc_rf_start_1;

    function new(string name = "mc_1short2_top_aux_top_mc_rf_start_cfg1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_rf_start_1 = uvm_reg_field::type_id::create("mc_rf_start_1",,get_full_name());
        this.mc_rf_start_1.configure(this,32,0,"RW",0,32'hFFFFFFFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_rf_start_cfg1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_rf_start_cfg1_reg

class ral_reg_mc_1short2_top_aux_top_mc_rf_period_cfg2_reg extends uvm_reg;
    rand uvm_reg_field mc_rf_period_2;

    function new(string name = "mc_1short2_top_aux_top_mc_rf_period_cfg2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_rf_period_2 = uvm_reg_field::type_id::create("mc_rf_period_2",,get_full_name());
        this.mc_rf_period_2.configure(this,32,0,"RW",0,32'h186A000,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_rf_period_cfg2_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_rf_period_cfg2_reg

class ral_reg_mc_1short2_top_aux_top_mc_rf_start_cfg2_reg extends uvm_reg;
    rand uvm_reg_field mc_rf_start_2;

    function new(string name = "mc_1short2_top_aux_top_mc_rf_start_cfg2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_rf_start_2 = uvm_reg_field::type_id::create("mc_rf_start_2",,get_full_name());
        this.mc_rf_start_2.configure(this,32,0,"RW",0,32'hFFFFFFFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_rf_start_cfg2_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_rf_start_cfg2_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num0_1_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num0_bank0;
    rand uvm_reg_field mc_vmc_wl_num1_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num0_1_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num0_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num0_bank0",,get_full_name());
        this.mc_vmc_wl_num0_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num1_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num1_bank0",,get_full_name());
        this.mc_vmc_wl_num1_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num0_1_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num0_1_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num2_3_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num2_bank0;
    rand uvm_reg_field mc_vmc_wl_num3_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num2_3_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num2_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num2_bank0",,get_full_name());
        this.mc_vmc_wl_num2_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num3_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num3_bank0",,get_full_name());
        this.mc_vmc_wl_num3_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num2_3_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num2_3_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num4_5_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num4_bank0;
    rand uvm_reg_field mc_vmc_wl_num5_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num4_5_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num4_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num4_bank0",,get_full_name());
        this.mc_vmc_wl_num4_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num5_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num5_bank0",,get_full_name());
        this.mc_vmc_wl_num5_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num4_5_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num4_5_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num6_7_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num6_bank0;
    rand uvm_reg_field mc_vmc_wl_num7_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num6_7_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num6_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num6_bank0",,get_full_name());
        this.mc_vmc_wl_num6_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num7_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num7_bank0",,get_full_name());
        this.mc_vmc_wl_num7_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num6_7_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num6_7_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num8_9_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num8_bank0;
    rand uvm_reg_field mc_vmc_wl_num9_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num8_9_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num8_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num8_bank0",,get_full_name());
        this.mc_vmc_wl_num8_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num9_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num9_bank0",,get_full_name());
        this.mc_vmc_wl_num9_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num8_9_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num8_9_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num10_11_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num10_bank0;
    rand uvm_reg_field mc_vmc_wl_num11_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num10_11_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num10_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num10_bank0",,get_full_name());
        this.mc_vmc_wl_num10_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num11_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num11_bank0",,get_full_name());
        this.mc_vmc_wl_num11_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num10_11_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num10_11_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num12_13_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num12_bank0;
    rand uvm_reg_field mc_vmc_wl_num13_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num12_13_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num12_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num12_bank0",,get_full_name());
        this.mc_vmc_wl_num12_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num13_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num13_bank0",,get_full_name());
        this.mc_vmc_wl_num13_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num12_13_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num12_13_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num14_15_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num14_bank0;
    rand uvm_reg_field mc_vmc_wl_num15_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num14_15_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num14_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num14_bank0",,get_full_name());
        this.mc_vmc_wl_num14_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num15_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num15_bank0",,get_full_name());
        this.mc_vmc_wl_num15_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num14_15_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num14_15_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num16_17_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num16_bank0;
    rand uvm_reg_field mc_vmc_wl_num17_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num16_17_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num16_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num16_bank0",,get_full_name());
        this.mc_vmc_wl_num16_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num17_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num17_bank0",,get_full_name());
        this.mc_vmc_wl_num17_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num16_17_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num16_17_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num18_19_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num18_bank0;
    rand uvm_reg_field mc_vmc_wl_num19_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num18_19_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num18_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num18_bank0",,get_full_name());
        this.mc_vmc_wl_num18_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num19_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num19_bank0",,get_full_name());
        this.mc_vmc_wl_num19_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num18_19_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num18_19_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num20_21_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num20_bank0;
    rand uvm_reg_field mc_vmc_wl_num21_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num20_21_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num20_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num20_bank0",,get_full_name());
        this.mc_vmc_wl_num20_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num21_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num21_bank0",,get_full_name());
        this.mc_vmc_wl_num21_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num20_21_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num20_21_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num22_23_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num22_bank0;
    rand uvm_reg_field mc_vmc_wl_num23_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num22_23_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num22_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num22_bank0",,get_full_name());
        this.mc_vmc_wl_num22_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num23_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num23_bank0",,get_full_name());
        this.mc_vmc_wl_num23_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num22_23_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num22_23_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num24_25_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num24_bank0;
    rand uvm_reg_field mc_vmc_wl_num25_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num24_25_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num24_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num24_bank0",,get_full_name());
        this.mc_vmc_wl_num24_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num25_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num25_bank0",,get_full_name());
        this.mc_vmc_wl_num25_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num24_25_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num24_25_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num26_27_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num26_bank0;
    rand uvm_reg_field mc_vmc_wl_num27_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num26_27_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num26_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num26_bank0",,get_full_name());
        this.mc_vmc_wl_num26_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num27_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num27_bank0",,get_full_name());
        this.mc_vmc_wl_num27_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num26_27_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num26_27_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num28_29_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num28_bank0;
    rand uvm_reg_field mc_vmc_wl_num29_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num28_29_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num28_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num28_bank0",,get_full_name());
        this.mc_vmc_wl_num28_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num29_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num29_bank0",,get_full_name());
        this.mc_vmc_wl_num29_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num28_29_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num28_29_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num30_31_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num30_bank0;
    rand uvm_reg_field mc_vmc_wl_num31_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num30_31_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num30_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num30_bank0",,get_full_name());
        this.mc_vmc_wl_num30_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num31_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num31_bank0",,get_full_name());
        this.mc_vmc_wl_num31_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num30_31_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num30_31_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num32_33_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num32_bank0;
    rand uvm_reg_field mc_vmc_wl_num33_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num32_33_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num32_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num32_bank0",,get_full_name());
        this.mc_vmc_wl_num32_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num33_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num33_bank0",,get_full_name());
        this.mc_vmc_wl_num33_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num32_33_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num32_33_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num34_35_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num34_bank0;
    rand uvm_reg_field mc_vmc_wl_num35_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num34_35_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num34_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num34_bank0",,get_full_name());
        this.mc_vmc_wl_num34_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num35_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num35_bank0",,get_full_name());
        this.mc_vmc_wl_num35_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num34_35_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num34_35_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num36_37_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num36_bank0;
    rand uvm_reg_field mc_vmc_wl_num37_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num36_37_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num36_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num36_bank0",,get_full_name());
        this.mc_vmc_wl_num36_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num37_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num37_bank0",,get_full_name());
        this.mc_vmc_wl_num37_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num36_37_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num36_37_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num38_39_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num38_bank0;
    rand uvm_reg_field mc_vmc_wl_num39_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num38_39_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num38_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num38_bank0",,get_full_name());
        this.mc_vmc_wl_num38_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num39_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num39_bank0",,get_full_name());
        this.mc_vmc_wl_num39_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num38_39_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num38_39_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num40_41_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num40_bank0;
    rand uvm_reg_field mc_vmc_wl_num41_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num40_41_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num40_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num40_bank0",,get_full_name());
        this.mc_vmc_wl_num40_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num41_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num41_bank0",,get_full_name());
        this.mc_vmc_wl_num41_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num40_41_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num40_41_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num42_43_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num42_bank0;
    rand uvm_reg_field mc_vmc_wl_num43_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num42_43_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num42_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num42_bank0",,get_full_name());
        this.mc_vmc_wl_num42_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num43_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num43_bank0",,get_full_name());
        this.mc_vmc_wl_num43_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num42_43_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num42_43_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num44_45_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num44_bank0;
    rand uvm_reg_field mc_vmc_wl_num45_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num44_45_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num44_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num44_bank0",,get_full_name());
        this.mc_vmc_wl_num44_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num45_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num45_bank0",,get_full_name());
        this.mc_vmc_wl_num45_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num44_45_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num44_45_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num46_47_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num46_bank0;
    rand uvm_reg_field mc_vmc_wl_num47_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num46_47_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num46_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num46_bank0",,get_full_name());
        this.mc_vmc_wl_num46_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num47_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num47_bank0",,get_full_name());
        this.mc_vmc_wl_num47_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num46_47_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num46_47_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num48_49_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num48_bank0;
    rand uvm_reg_field mc_vmc_wl_num49_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num48_49_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num48_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num48_bank0",,get_full_name());
        this.mc_vmc_wl_num48_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num49_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num49_bank0",,get_full_name());
        this.mc_vmc_wl_num49_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num48_49_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num48_49_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num50_51_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num50_bank0;
    rand uvm_reg_field mc_vmc_wl_num51_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num50_51_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num50_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num50_bank0",,get_full_name());
        this.mc_vmc_wl_num50_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num51_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num51_bank0",,get_full_name());
        this.mc_vmc_wl_num51_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num50_51_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num50_51_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num52_53_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num52_bank0;
    rand uvm_reg_field mc_vmc_wl_num53_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num52_53_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num52_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num52_bank0",,get_full_name());
        this.mc_vmc_wl_num52_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num53_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num53_bank0",,get_full_name());
        this.mc_vmc_wl_num53_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num52_53_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num52_53_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num54_55_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num54_bank0;
    rand uvm_reg_field mc_vmc_wl_num55_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num54_55_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num54_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num54_bank0",,get_full_name());
        this.mc_vmc_wl_num54_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num55_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num55_bank0",,get_full_name());
        this.mc_vmc_wl_num55_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num54_55_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num54_55_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num56_57_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num56_bank0;
    rand uvm_reg_field mc_vmc_wl_num57_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num56_57_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num56_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num56_bank0",,get_full_name());
        this.mc_vmc_wl_num56_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num57_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num57_bank0",,get_full_name());
        this.mc_vmc_wl_num57_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num56_57_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num56_57_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num58_59_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num58_bank0;
    rand uvm_reg_field mc_vmc_wl_num59_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num58_59_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num58_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num58_bank0",,get_full_name());
        this.mc_vmc_wl_num58_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num59_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num59_bank0",,get_full_name());
        this.mc_vmc_wl_num59_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num58_59_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num58_59_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num60_61_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num60_bank0;
    rand uvm_reg_field mc_vmc_wl_num61_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num60_61_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num60_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num60_bank0",,get_full_name());
        this.mc_vmc_wl_num60_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num61_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num61_bank0",,get_full_name());
        this.mc_vmc_wl_num61_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num60_61_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num60_61_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num62_63_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num62_bank0;
    rand uvm_reg_field mc_vmc_wl_num63_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num62_63_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num62_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num62_bank0",,get_full_name());
        this.mc_vmc_wl_num62_bank0.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num63_bank0 = uvm_reg_field::type_id::create("mc_vmc_wl_num63_bank0",,get_full_name());
        this.mc_vmc_wl_num63_bank0.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num62_63_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num62_63_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part0_1_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part0_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part0_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part1_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part1_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_bl_num0_part0_1_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part0_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part0_bank0",,get_full_name());
        this.mc_vmc_bl_num0_part0_bank0.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part0_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part0_bank0",,get_full_name());
        this.mc_vmc_bl_num1_part0_bank0.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part1_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part1_bank0",,get_full_name());
        this.mc_vmc_bl_num0_part1_bank0.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part1_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part1_bank0",,get_full_name());
        this.mc_vmc_bl_num1_part1_bank0.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part0_1_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part0_1_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part2_3_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part2_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part2_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part3_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part3_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_bl_num0_part2_3_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part2_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part2_bank0",,get_full_name());
        this.mc_vmc_bl_num0_part2_bank0.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part2_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part2_bank0",,get_full_name());
        this.mc_vmc_bl_num1_part2_bank0.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part3_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part3_bank0",,get_full_name());
        this.mc_vmc_bl_num0_part3_bank0.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part3_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part3_bank0",,get_full_name());
        this.mc_vmc_bl_num1_part3_bank0.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part2_3_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part2_3_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part4_5_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part4_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part4_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part5_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part5_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_bl_num0_part4_5_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part4_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part4_bank0",,get_full_name());
        this.mc_vmc_bl_num0_part4_bank0.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part4_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part4_bank0",,get_full_name());
        this.mc_vmc_bl_num1_part4_bank0.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part5_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part5_bank0",,get_full_name());
        this.mc_vmc_bl_num0_part5_bank0.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part5_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part5_bank0",,get_full_name());
        this.mc_vmc_bl_num1_part5_bank0.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part4_5_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part4_5_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part6_7_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part6_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part6_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part7_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part7_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_bl_num0_part6_7_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part6_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part6_bank0",,get_full_name());
        this.mc_vmc_bl_num0_part6_bank0.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part6_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part6_bank0",,get_full_name());
        this.mc_vmc_bl_num1_part6_bank0.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part7_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part7_bank0",,get_full_name());
        this.mc_vmc_bl_num0_part7_bank0.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part7_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part7_bank0",,get_full_name());
        this.mc_vmc_bl_num1_part7_bank0.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part6_7_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part6_7_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part8_9_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part8_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part8_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part9_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part9_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_bl_num0_part8_9_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part8_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part8_bank0",,get_full_name());
        this.mc_vmc_bl_num0_part8_bank0.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part8_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part8_bank0",,get_full_name());
        this.mc_vmc_bl_num1_part8_bank0.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part9_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part9_bank0",,get_full_name());
        this.mc_vmc_bl_num0_part9_bank0.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part9_bank0 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part9_bank0",,get_full_name());
        this.mc_vmc_bl_num1_part9_bank0.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part8_9_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part8_9_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl0_1_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl0_bank0;
    rand uvm_reg_field err_wl1_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl0_1_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl0_bank0 = uvm_reg_field::type_id::create("err_wl0_bank0",,get_full_name());
        this.err_wl0_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl1_bank0 = uvm_reg_field::type_id::create("err_wl1_bank0",,get_full_name());
        this.err_wl1_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl0_1_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl0_1_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl2_3_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl2_bank0;
    rand uvm_reg_field err_wl3_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl2_3_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl2_bank0 = uvm_reg_field::type_id::create("err_wl2_bank0",,get_full_name());
        this.err_wl2_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl3_bank0 = uvm_reg_field::type_id::create("err_wl3_bank0",,get_full_name());
        this.err_wl3_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl2_3_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl2_3_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl4_5_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl4_bank0;
    rand uvm_reg_field err_wl5_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl4_5_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl4_bank0 = uvm_reg_field::type_id::create("err_wl4_bank0",,get_full_name());
        this.err_wl4_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl5_bank0 = uvm_reg_field::type_id::create("err_wl5_bank0",,get_full_name());
        this.err_wl5_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl4_5_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl4_5_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl6_7_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl6_bank0;
    rand uvm_reg_field err_wl7_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl6_7_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl6_bank0 = uvm_reg_field::type_id::create("err_wl6_bank0",,get_full_name());
        this.err_wl6_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl7_bank0 = uvm_reg_field::type_id::create("err_wl7_bank0",,get_full_name());
        this.err_wl7_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl6_7_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl6_7_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl8_9_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl8_bank0;
    rand uvm_reg_field err_wl9_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl8_9_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl8_bank0 = uvm_reg_field::type_id::create("err_wl8_bank0",,get_full_name());
        this.err_wl8_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl9_bank0 = uvm_reg_field::type_id::create("err_wl9_bank0",,get_full_name());
        this.err_wl9_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl8_9_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl8_9_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl10_11_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl10_bank0;
    rand uvm_reg_field err_wl11_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl10_11_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl10_bank0 = uvm_reg_field::type_id::create("err_wl10_bank0",,get_full_name());
        this.err_wl10_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl11_bank0 = uvm_reg_field::type_id::create("err_wl11_bank0",,get_full_name());
        this.err_wl11_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl10_11_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl10_11_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl12_13_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl12_bank0;
    rand uvm_reg_field err_wl13_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl12_13_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl12_bank0 = uvm_reg_field::type_id::create("err_wl12_bank0",,get_full_name());
        this.err_wl12_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl13_bank0 = uvm_reg_field::type_id::create("err_wl13_bank0",,get_full_name());
        this.err_wl13_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl12_13_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl12_13_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl14_15_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl14_bank0;
    rand uvm_reg_field err_wl15_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl14_15_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl14_bank0 = uvm_reg_field::type_id::create("err_wl14_bank0",,get_full_name());
        this.err_wl14_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl15_bank0 = uvm_reg_field::type_id::create("err_wl15_bank0",,get_full_name());
        this.err_wl15_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl14_15_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl14_15_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl16_17_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl16_bank0;
    rand uvm_reg_field err_wl17_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl16_17_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl16_bank0 = uvm_reg_field::type_id::create("err_wl16_bank0",,get_full_name());
        this.err_wl16_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl17_bank0 = uvm_reg_field::type_id::create("err_wl17_bank0",,get_full_name());
        this.err_wl17_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl16_17_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl16_17_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl18_19_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl18_bank0;
    rand uvm_reg_field err_wl19_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl18_19_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl18_bank0 = uvm_reg_field::type_id::create("err_wl18_bank0",,get_full_name());
        this.err_wl18_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl19_bank0 = uvm_reg_field::type_id::create("err_wl19_bank0",,get_full_name());
        this.err_wl19_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl18_19_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl18_19_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl20_21_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl20_bank0;
    rand uvm_reg_field err_wl21_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl20_21_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl20_bank0 = uvm_reg_field::type_id::create("err_wl20_bank0",,get_full_name());
        this.err_wl20_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl21_bank0 = uvm_reg_field::type_id::create("err_wl21_bank0",,get_full_name());
        this.err_wl21_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl20_21_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl20_21_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl22_23_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl22_bank0;
    rand uvm_reg_field err_wl23_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl22_23_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl22_bank0 = uvm_reg_field::type_id::create("err_wl22_bank0",,get_full_name());
        this.err_wl22_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl23_bank0 = uvm_reg_field::type_id::create("err_wl23_bank0",,get_full_name());
        this.err_wl23_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl22_23_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl22_23_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl24_25_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl24_bank0;
    rand uvm_reg_field err_wl25_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl24_25_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl24_bank0 = uvm_reg_field::type_id::create("err_wl24_bank0",,get_full_name());
        this.err_wl24_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl25_bank0 = uvm_reg_field::type_id::create("err_wl25_bank0",,get_full_name());
        this.err_wl25_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl24_25_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl24_25_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl26_27_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl26_bank0;
    rand uvm_reg_field err_wl27_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl26_27_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl26_bank0 = uvm_reg_field::type_id::create("err_wl26_bank0",,get_full_name());
        this.err_wl26_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl27_bank0 = uvm_reg_field::type_id::create("err_wl27_bank0",,get_full_name());
        this.err_wl27_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl26_27_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl26_27_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl28_29_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl28_bank0;
    rand uvm_reg_field err_wl29_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl28_29_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl28_bank0 = uvm_reg_field::type_id::create("err_wl28_bank0",,get_full_name());
        this.err_wl28_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl29_bank0 = uvm_reg_field::type_id::create("err_wl29_bank0",,get_full_name());
        this.err_wl29_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl28_29_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl28_29_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl30_31_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl30_bank0;
    rand uvm_reg_field err_wl31_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl30_31_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl30_bank0 = uvm_reg_field::type_id::create("err_wl30_bank0",,get_full_name());
        this.err_wl30_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl31_bank0 = uvm_reg_field::type_id::create("err_wl31_bank0",,get_full_name());
        this.err_wl31_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl30_31_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl30_31_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl32_33_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl32_bank0;
    rand uvm_reg_field err_wl33_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl32_33_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl32_bank0 = uvm_reg_field::type_id::create("err_wl32_bank0",,get_full_name());
        this.err_wl32_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl33_bank0 = uvm_reg_field::type_id::create("err_wl33_bank0",,get_full_name());
        this.err_wl33_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl32_33_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl32_33_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl34_35_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl34_bank0;
    rand uvm_reg_field err_wl35_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl34_35_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl34_bank0 = uvm_reg_field::type_id::create("err_wl34_bank0",,get_full_name());
        this.err_wl34_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl35_bank0 = uvm_reg_field::type_id::create("err_wl35_bank0",,get_full_name());
        this.err_wl35_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl34_35_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl34_35_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl36_37_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl36_bank0;
    rand uvm_reg_field err_wl37_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl36_37_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl36_bank0 = uvm_reg_field::type_id::create("err_wl36_bank0",,get_full_name());
        this.err_wl36_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl37_bank0 = uvm_reg_field::type_id::create("err_wl37_bank0",,get_full_name());
        this.err_wl37_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl36_37_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl36_37_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl38_39_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl38_bank0;
    rand uvm_reg_field err_wl39_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl38_39_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl38_bank0 = uvm_reg_field::type_id::create("err_wl38_bank0",,get_full_name());
        this.err_wl38_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl39_bank0 = uvm_reg_field::type_id::create("err_wl39_bank0",,get_full_name());
        this.err_wl39_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl38_39_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl38_39_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl40_41_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl40_bank0;
    rand uvm_reg_field err_wl41_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl40_41_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl40_bank0 = uvm_reg_field::type_id::create("err_wl40_bank0",,get_full_name());
        this.err_wl40_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl41_bank0 = uvm_reg_field::type_id::create("err_wl41_bank0",,get_full_name());
        this.err_wl41_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl40_41_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl40_41_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl42_43_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl42_bank0;
    rand uvm_reg_field err_wl43_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl42_43_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl42_bank0 = uvm_reg_field::type_id::create("err_wl42_bank0",,get_full_name());
        this.err_wl42_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl43_bank0 = uvm_reg_field::type_id::create("err_wl43_bank0",,get_full_name());
        this.err_wl43_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl42_43_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl42_43_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl44_45_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl44_bank0;
    rand uvm_reg_field err_wl45_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl44_45_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl44_bank0 = uvm_reg_field::type_id::create("err_wl44_bank0",,get_full_name());
        this.err_wl44_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl45_bank0 = uvm_reg_field::type_id::create("err_wl45_bank0",,get_full_name());
        this.err_wl45_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl44_45_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl44_45_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl46_47_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl46_bank0;
    rand uvm_reg_field err_wl47_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl46_47_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl46_bank0 = uvm_reg_field::type_id::create("err_wl46_bank0",,get_full_name());
        this.err_wl46_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl47_bank0 = uvm_reg_field::type_id::create("err_wl47_bank0",,get_full_name());
        this.err_wl47_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl46_47_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl46_47_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl48_49_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl48_bank0;
    rand uvm_reg_field err_wl49_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl48_49_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl48_bank0 = uvm_reg_field::type_id::create("err_wl48_bank0",,get_full_name());
        this.err_wl48_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl49_bank0 = uvm_reg_field::type_id::create("err_wl49_bank0",,get_full_name());
        this.err_wl49_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl48_49_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl48_49_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl50_51_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl50_bank0;
    rand uvm_reg_field err_wl51_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl50_51_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl50_bank0 = uvm_reg_field::type_id::create("err_wl50_bank0",,get_full_name());
        this.err_wl50_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl51_bank0 = uvm_reg_field::type_id::create("err_wl51_bank0",,get_full_name());
        this.err_wl51_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl50_51_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl50_51_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl52_53_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl52_bank0;
    rand uvm_reg_field err_wl53_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl52_53_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl52_bank0 = uvm_reg_field::type_id::create("err_wl52_bank0",,get_full_name());
        this.err_wl52_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl53_bank0 = uvm_reg_field::type_id::create("err_wl53_bank0",,get_full_name());
        this.err_wl53_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl52_53_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl52_53_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl54_55_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl54_bank0;
    rand uvm_reg_field err_wl55_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl54_55_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl54_bank0 = uvm_reg_field::type_id::create("err_wl54_bank0",,get_full_name());
        this.err_wl54_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl55_bank0 = uvm_reg_field::type_id::create("err_wl55_bank0",,get_full_name());
        this.err_wl55_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl54_55_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl54_55_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl56_57_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl56_bank0;
    rand uvm_reg_field err_wl57_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl56_57_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl56_bank0 = uvm_reg_field::type_id::create("err_wl56_bank0",,get_full_name());
        this.err_wl56_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl57_bank0 = uvm_reg_field::type_id::create("err_wl57_bank0",,get_full_name());
        this.err_wl57_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl56_57_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl56_57_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl58_59_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl58_bank0;
    rand uvm_reg_field err_wl59_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl58_59_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl58_bank0 = uvm_reg_field::type_id::create("err_wl58_bank0",,get_full_name());
        this.err_wl58_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl59_bank0 = uvm_reg_field::type_id::create("err_wl59_bank0",,get_full_name());
        this.err_wl59_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl58_59_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl58_59_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl60_61_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl60_bank0;
    rand uvm_reg_field err_wl61_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl60_61_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl60_bank0 = uvm_reg_field::type_id::create("err_wl60_bank0",,get_full_name());
        this.err_wl60_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl61_bank0 = uvm_reg_field::type_id::create("err_wl61_bank0",,get_full_name());
        this.err_wl61_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl60_61_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl60_61_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_wl62_63_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_wl62_bank0;
    rand uvm_reg_field err_wl63_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_wl62_63_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl62_bank0 = uvm_reg_field::type_id::create("err_wl62_bank0",,get_full_name());
        this.err_wl62_bank0.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl63_bank0 = uvm_reg_field::type_id::create("err_wl63_bank0",,get_full_name());
        this.err_wl63_bank0.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl62_63_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl62_63_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_csl_part0_1_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part0_bank0;
    rand uvm_reg_field err_csl1_part0_bank0;
    rand uvm_reg_field err_csl0_part1_bank0;
    rand uvm_reg_field err_csl1_part1_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_csl_part0_1_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part0_bank0 = uvm_reg_field::type_id::create("err_csl0_part0_bank0",,get_full_name());
        this.err_csl0_part0_bank0.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part0_bank0 = uvm_reg_field::type_id::create("err_csl1_part0_bank0",,get_full_name());
        this.err_csl1_part0_bank0.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part1_bank0 = uvm_reg_field::type_id::create("err_csl0_part1_bank0",,get_full_name());
        this.err_csl0_part1_bank0.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part1_bank0 = uvm_reg_field::type_id::create("err_csl1_part1_bank0",,get_full_name());
        this.err_csl1_part1_bank0.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_csl_part0_1_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_csl_part0_1_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_csl_part2_3_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part2_bank0;
    rand uvm_reg_field err_csl1_part2_bank0;
    rand uvm_reg_field err_csl0_part3_bank0;
    rand uvm_reg_field err_csl1_part3_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_csl_part2_3_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part2_bank0 = uvm_reg_field::type_id::create("err_csl0_part2_bank0",,get_full_name());
        this.err_csl0_part2_bank0.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part2_bank0 = uvm_reg_field::type_id::create("err_csl1_part2_bank0",,get_full_name());
        this.err_csl1_part2_bank0.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part3_bank0 = uvm_reg_field::type_id::create("err_csl0_part3_bank0",,get_full_name());
        this.err_csl0_part3_bank0.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part3_bank0 = uvm_reg_field::type_id::create("err_csl1_part3_bank0",,get_full_name());
        this.err_csl1_part3_bank0.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_csl_part2_3_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_csl_part2_3_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_csl_part4_5_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part4_bank0;
    rand uvm_reg_field err_csl1_part4_bank0;
    rand uvm_reg_field err_csl0_part5_bank0;
    rand uvm_reg_field err_csl1_part5_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_csl_part4_5_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part4_bank0 = uvm_reg_field::type_id::create("err_csl0_part4_bank0",,get_full_name());
        this.err_csl0_part4_bank0.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part4_bank0 = uvm_reg_field::type_id::create("err_csl1_part4_bank0",,get_full_name());
        this.err_csl1_part4_bank0.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part5_bank0 = uvm_reg_field::type_id::create("err_csl0_part5_bank0",,get_full_name());
        this.err_csl0_part5_bank0.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part5_bank0 = uvm_reg_field::type_id::create("err_csl1_part5_bank0",,get_full_name());
        this.err_csl1_part5_bank0.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_csl_part4_5_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_csl_part4_5_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_csl_part6_7_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part6_bank0;
    rand uvm_reg_field err_csl1_part6_bank0;
    rand uvm_reg_field err_csl0_part7_bank0;
    rand uvm_reg_field err_csl1_part7_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_csl_part6_7_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part6_bank0 = uvm_reg_field::type_id::create("err_csl0_part6_bank0",,get_full_name());
        this.err_csl0_part6_bank0.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part6_bank0 = uvm_reg_field::type_id::create("err_csl1_part6_bank0",,get_full_name());
        this.err_csl1_part6_bank0.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part7_bank0 = uvm_reg_field::type_id::create("err_csl0_part7_bank0",,get_full_name());
        this.err_csl0_part7_bank0.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part7_bank0 = uvm_reg_field::type_id::create("err_csl1_part7_bank0",,get_full_name());
        this.err_csl1_part7_bank0.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_csl_part6_7_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_csl_part6_7_bank0_reg

class ral_reg_mc_1short2_top_aux_top_err_csl_part8_9_bank0_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part8_bank0;
    rand uvm_reg_field err_csl1_part8_bank0;
    rand uvm_reg_field err_csl0_part9_bank0;
    rand uvm_reg_field err_csl1_part9_bank0;

    function new(string name = "mc_1short2_top_aux_top_err_csl_part8_9_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part8_bank0 = uvm_reg_field::type_id::create("err_csl0_part8_bank0",,get_full_name());
        this.err_csl0_part8_bank0.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part8_bank0 = uvm_reg_field::type_id::create("err_csl1_part8_bank0",,get_full_name());
        this.err_csl1_part8_bank0.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part9_bank0 = uvm_reg_field::type_id::create("err_csl0_part9_bank0",,get_full_name());
        this.err_csl0_part9_bank0.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part9_bank0 = uvm_reg_field::type_id::create("err_csl1_part9_bank0",,get_full_name());
        this.err_csl1_part9_bank0.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_csl_part8_9_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_csl_part8_9_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num0_1_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num0_bank1;
    rand uvm_reg_field mc_vmc_wl_num1_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num0_1_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num0_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num0_bank1",,get_full_name());
        this.mc_vmc_wl_num0_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num1_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num1_bank1",,get_full_name());
        this.mc_vmc_wl_num1_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num0_1_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num0_1_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num2_3_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num2_bank1;
    rand uvm_reg_field mc_vmc_wl_num3_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num2_3_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num2_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num2_bank1",,get_full_name());
        this.mc_vmc_wl_num2_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num3_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num3_bank1",,get_full_name());
        this.mc_vmc_wl_num3_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num2_3_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num2_3_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num4_5_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num4_bank1;
    rand uvm_reg_field mc_vmc_wl_num5_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num4_5_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num4_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num4_bank1",,get_full_name());
        this.mc_vmc_wl_num4_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num5_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num5_bank1",,get_full_name());
        this.mc_vmc_wl_num5_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num4_5_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num4_5_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num6_7_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num6_bank1;
    rand uvm_reg_field mc_vmc_wl_num7_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num6_7_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num6_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num6_bank1",,get_full_name());
        this.mc_vmc_wl_num6_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num7_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num7_bank1",,get_full_name());
        this.mc_vmc_wl_num7_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num6_7_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num6_7_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num8_9_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num8_bank1;
    rand uvm_reg_field mc_vmc_wl_num9_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num8_9_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num8_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num8_bank1",,get_full_name());
        this.mc_vmc_wl_num8_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num9_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num9_bank1",,get_full_name());
        this.mc_vmc_wl_num9_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num8_9_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num8_9_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num10_11_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num10_bank1;
    rand uvm_reg_field mc_vmc_wl_num11_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num10_11_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num10_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num10_bank1",,get_full_name());
        this.mc_vmc_wl_num10_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num11_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num11_bank1",,get_full_name());
        this.mc_vmc_wl_num11_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num10_11_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num10_11_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num12_13_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num12_bank1;
    rand uvm_reg_field mc_vmc_wl_num13_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num12_13_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num12_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num12_bank1",,get_full_name());
        this.mc_vmc_wl_num12_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num13_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num13_bank1",,get_full_name());
        this.mc_vmc_wl_num13_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num12_13_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num12_13_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num14_15_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num14_bank1;
    rand uvm_reg_field mc_vmc_wl_num15_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num14_15_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num14_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num14_bank1",,get_full_name());
        this.mc_vmc_wl_num14_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num15_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num15_bank1",,get_full_name());
        this.mc_vmc_wl_num15_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num14_15_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num14_15_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num16_17_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num16_bank1;
    rand uvm_reg_field mc_vmc_wl_num17_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num16_17_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num16_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num16_bank1",,get_full_name());
        this.mc_vmc_wl_num16_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num17_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num17_bank1",,get_full_name());
        this.mc_vmc_wl_num17_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num16_17_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num16_17_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num18_19_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num18_bank1;
    rand uvm_reg_field mc_vmc_wl_num19_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num18_19_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num18_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num18_bank1",,get_full_name());
        this.mc_vmc_wl_num18_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num19_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num19_bank1",,get_full_name());
        this.mc_vmc_wl_num19_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num18_19_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num18_19_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num20_21_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num20_bank1;
    rand uvm_reg_field mc_vmc_wl_num21_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num20_21_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num20_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num20_bank1",,get_full_name());
        this.mc_vmc_wl_num20_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num21_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num21_bank1",,get_full_name());
        this.mc_vmc_wl_num21_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num20_21_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num20_21_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num22_23_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num22_bank1;
    rand uvm_reg_field mc_vmc_wl_num23_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num22_23_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num22_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num22_bank1",,get_full_name());
        this.mc_vmc_wl_num22_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num23_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num23_bank1",,get_full_name());
        this.mc_vmc_wl_num23_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num22_23_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num22_23_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num24_25_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num24_bank1;
    rand uvm_reg_field mc_vmc_wl_num25_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num24_25_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num24_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num24_bank1",,get_full_name());
        this.mc_vmc_wl_num24_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num25_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num25_bank1",,get_full_name());
        this.mc_vmc_wl_num25_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num24_25_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num24_25_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num26_27_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num26_bank1;
    rand uvm_reg_field mc_vmc_wl_num27_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num26_27_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num26_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num26_bank1",,get_full_name());
        this.mc_vmc_wl_num26_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num27_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num27_bank1",,get_full_name());
        this.mc_vmc_wl_num27_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num26_27_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num26_27_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num28_29_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num28_bank1;
    rand uvm_reg_field mc_vmc_wl_num29_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num28_29_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num28_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num28_bank1",,get_full_name());
        this.mc_vmc_wl_num28_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num29_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num29_bank1",,get_full_name());
        this.mc_vmc_wl_num29_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num28_29_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num28_29_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num30_31_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num30_bank1;
    rand uvm_reg_field mc_vmc_wl_num31_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num30_31_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num30_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num30_bank1",,get_full_name());
        this.mc_vmc_wl_num30_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num31_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num31_bank1",,get_full_name());
        this.mc_vmc_wl_num31_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num30_31_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num30_31_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num32_33_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num32_bank1;
    rand uvm_reg_field mc_vmc_wl_num33_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num32_33_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num32_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num32_bank1",,get_full_name());
        this.mc_vmc_wl_num32_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num33_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num33_bank1",,get_full_name());
        this.mc_vmc_wl_num33_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num32_33_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num32_33_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num34_35_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num34_bank1;
    rand uvm_reg_field mc_vmc_wl_num35_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num34_35_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num34_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num34_bank1",,get_full_name());
        this.mc_vmc_wl_num34_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num35_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num35_bank1",,get_full_name());
        this.mc_vmc_wl_num35_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num34_35_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num34_35_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num36_37_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num36_bank1;
    rand uvm_reg_field mc_vmc_wl_num37_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num36_37_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num36_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num36_bank1",,get_full_name());
        this.mc_vmc_wl_num36_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num37_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num37_bank1",,get_full_name());
        this.mc_vmc_wl_num37_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num36_37_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num36_37_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num38_39_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num38_bank1;
    rand uvm_reg_field mc_vmc_wl_num39_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num38_39_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num38_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num38_bank1",,get_full_name());
        this.mc_vmc_wl_num38_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num39_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num39_bank1",,get_full_name());
        this.mc_vmc_wl_num39_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num38_39_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num38_39_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num40_41_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num40_bank1;
    rand uvm_reg_field mc_vmc_wl_num41_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num40_41_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num40_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num40_bank1",,get_full_name());
        this.mc_vmc_wl_num40_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num41_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num41_bank1",,get_full_name());
        this.mc_vmc_wl_num41_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num40_41_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num40_41_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num42_43_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num42_bank1;
    rand uvm_reg_field mc_vmc_wl_num43_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num42_43_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num42_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num42_bank1",,get_full_name());
        this.mc_vmc_wl_num42_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num43_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num43_bank1",,get_full_name());
        this.mc_vmc_wl_num43_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num42_43_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num42_43_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num44_45_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num44_bank1;
    rand uvm_reg_field mc_vmc_wl_num45_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num44_45_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num44_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num44_bank1",,get_full_name());
        this.mc_vmc_wl_num44_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num45_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num45_bank1",,get_full_name());
        this.mc_vmc_wl_num45_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num44_45_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num44_45_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num46_47_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num46_bank1;
    rand uvm_reg_field mc_vmc_wl_num47_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num46_47_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num46_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num46_bank1",,get_full_name());
        this.mc_vmc_wl_num46_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num47_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num47_bank1",,get_full_name());
        this.mc_vmc_wl_num47_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num46_47_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num46_47_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num48_49_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num48_bank1;
    rand uvm_reg_field mc_vmc_wl_num49_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num48_49_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num48_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num48_bank1",,get_full_name());
        this.mc_vmc_wl_num48_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num49_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num49_bank1",,get_full_name());
        this.mc_vmc_wl_num49_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num48_49_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num48_49_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num50_51_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num50_bank1;
    rand uvm_reg_field mc_vmc_wl_num51_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num50_51_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num50_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num50_bank1",,get_full_name());
        this.mc_vmc_wl_num50_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num51_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num51_bank1",,get_full_name());
        this.mc_vmc_wl_num51_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num50_51_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num50_51_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num52_53_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num52_bank1;
    rand uvm_reg_field mc_vmc_wl_num53_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num52_53_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num52_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num52_bank1",,get_full_name());
        this.mc_vmc_wl_num52_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num53_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num53_bank1",,get_full_name());
        this.mc_vmc_wl_num53_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num52_53_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num52_53_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num54_55_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num54_bank1;
    rand uvm_reg_field mc_vmc_wl_num55_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num54_55_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num54_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num54_bank1",,get_full_name());
        this.mc_vmc_wl_num54_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num55_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num55_bank1",,get_full_name());
        this.mc_vmc_wl_num55_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num54_55_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num54_55_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num56_57_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num56_bank1;
    rand uvm_reg_field mc_vmc_wl_num57_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num56_57_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num56_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num56_bank1",,get_full_name());
        this.mc_vmc_wl_num56_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num57_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num57_bank1",,get_full_name());
        this.mc_vmc_wl_num57_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num56_57_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num56_57_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num58_59_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num58_bank1;
    rand uvm_reg_field mc_vmc_wl_num59_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num58_59_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num58_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num58_bank1",,get_full_name());
        this.mc_vmc_wl_num58_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num59_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num59_bank1",,get_full_name());
        this.mc_vmc_wl_num59_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num58_59_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num58_59_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num60_61_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num60_bank1;
    rand uvm_reg_field mc_vmc_wl_num61_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num60_61_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num60_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num60_bank1",,get_full_name());
        this.mc_vmc_wl_num60_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num61_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num61_bank1",,get_full_name());
        this.mc_vmc_wl_num61_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num60_61_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num60_61_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num62_63_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_wl_num62_bank1;
    rand uvm_reg_field mc_vmc_wl_num63_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_wl_num62_63_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_wl_num62_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num62_bank1",,get_full_name());
        this.mc_vmc_wl_num62_bank1.configure(this,13,0,"RW",0,32'h1FFF,1,0,0);
        this.mc_vmc_wl_num63_bank1 = uvm_reg_field::type_id::create("mc_vmc_wl_num63_bank1",,get_full_name());
        this.mc_vmc_wl_num63_bank1.configure(this,13,13,"RW",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num62_63_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num62_63_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part0_1_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part0_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part0_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part1_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part1_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_bl_num0_part0_1_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part0_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part0_bank1",,get_full_name());
        this.mc_vmc_bl_num0_part0_bank1.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part0_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part0_bank1",,get_full_name());
        this.mc_vmc_bl_num1_part0_bank1.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part1_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part1_bank1",,get_full_name());
        this.mc_vmc_bl_num0_part1_bank1.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part1_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part1_bank1",,get_full_name());
        this.mc_vmc_bl_num1_part1_bank1.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part0_1_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part0_1_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part2_3_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part2_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part2_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part3_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part3_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_bl_num0_part2_3_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part2_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part2_bank1",,get_full_name());
        this.mc_vmc_bl_num0_part2_bank1.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part2_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part2_bank1",,get_full_name());
        this.mc_vmc_bl_num1_part2_bank1.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part3_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part3_bank1",,get_full_name());
        this.mc_vmc_bl_num0_part3_bank1.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part3_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part3_bank1",,get_full_name());
        this.mc_vmc_bl_num1_part3_bank1.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part2_3_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part2_3_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part4_5_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part4_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part4_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part5_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part5_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_bl_num0_part4_5_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part4_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part4_bank1",,get_full_name());
        this.mc_vmc_bl_num0_part4_bank1.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part4_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part4_bank1",,get_full_name());
        this.mc_vmc_bl_num1_part4_bank1.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part5_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part5_bank1",,get_full_name());
        this.mc_vmc_bl_num0_part5_bank1.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part5_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part5_bank1",,get_full_name());
        this.mc_vmc_bl_num1_part5_bank1.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part4_5_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part4_5_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part6_7_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part6_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part6_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part7_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part7_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_bl_num0_part6_7_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part6_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part6_bank1",,get_full_name());
        this.mc_vmc_bl_num0_part6_bank1.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part6_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part6_bank1",,get_full_name());
        this.mc_vmc_bl_num1_part6_bank1.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part7_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part7_bank1",,get_full_name());
        this.mc_vmc_bl_num0_part7_bank1.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part7_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part7_bank1",,get_full_name());
        this.mc_vmc_bl_num1_part7_bank1.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part6_7_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part6_7_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part8_9_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part8_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part8_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part9_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part9_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_vmc_bl_num0_part8_9_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_vmc_bl_num0_part8_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part8_bank1",,get_full_name());
        this.mc_vmc_bl_num0_part8_bank1.configure(this,8,0,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part8_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part8_bank1",,get_full_name());
        this.mc_vmc_bl_num1_part8_bank1.configure(this,8,8,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num0_part9_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num0_part9_bank1",,get_full_name());
        this.mc_vmc_bl_num0_part9_bank1.configure(this,8,16,"RW",0,32'hFF,1,0,0);
        this.mc_vmc_bl_num1_part9_bank1 = uvm_reg_field::type_id::create("mc_vmc_bl_num1_part9_bank1",,get_full_name());
        this.mc_vmc_bl_num1_part9_bank1.configure(this,8,24,"RW",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part8_9_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part8_9_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl0_1_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl0_bank1;
    rand uvm_reg_field err_wl1_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl0_1_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl0_bank1 = uvm_reg_field::type_id::create("err_wl0_bank1",,get_full_name());
        this.err_wl0_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl1_bank1 = uvm_reg_field::type_id::create("err_wl1_bank1",,get_full_name());
        this.err_wl1_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl0_1_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl0_1_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl2_3_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl2_bank1;
    rand uvm_reg_field err_wl3_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl2_3_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl2_bank1 = uvm_reg_field::type_id::create("err_wl2_bank1",,get_full_name());
        this.err_wl2_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl3_bank1 = uvm_reg_field::type_id::create("err_wl3_bank1",,get_full_name());
        this.err_wl3_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl2_3_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl2_3_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl4_5_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl4_bank1;
    rand uvm_reg_field err_wl5_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl4_5_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl4_bank1 = uvm_reg_field::type_id::create("err_wl4_bank1",,get_full_name());
        this.err_wl4_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl5_bank1 = uvm_reg_field::type_id::create("err_wl5_bank1",,get_full_name());
        this.err_wl5_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl4_5_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl4_5_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl6_7_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl6_bank1;
    rand uvm_reg_field err_wl7_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl6_7_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl6_bank1 = uvm_reg_field::type_id::create("err_wl6_bank1",,get_full_name());
        this.err_wl6_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl7_bank1 = uvm_reg_field::type_id::create("err_wl7_bank1",,get_full_name());
        this.err_wl7_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl6_7_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl6_7_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl8_9_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl8_bank1;
    rand uvm_reg_field err_wl9_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl8_9_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl8_bank1 = uvm_reg_field::type_id::create("err_wl8_bank1",,get_full_name());
        this.err_wl8_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl9_bank1 = uvm_reg_field::type_id::create("err_wl9_bank1",,get_full_name());
        this.err_wl9_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl8_9_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl8_9_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl10_11_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl10_bank1;
    rand uvm_reg_field err_wl11_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl10_11_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl10_bank1 = uvm_reg_field::type_id::create("err_wl10_bank1",,get_full_name());
        this.err_wl10_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl11_bank1 = uvm_reg_field::type_id::create("err_wl11_bank1",,get_full_name());
        this.err_wl11_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl10_11_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl10_11_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl12_13_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl12_bank1;
    rand uvm_reg_field err_wl13_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl12_13_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl12_bank1 = uvm_reg_field::type_id::create("err_wl12_bank1",,get_full_name());
        this.err_wl12_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl13_bank1 = uvm_reg_field::type_id::create("err_wl13_bank1",,get_full_name());
        this.err_wl13_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl12_13_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl12_13_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl14_15_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl14_bank1;
    rand uvm_reg_field err_wl15_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl14_15_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl14_bank1 = uvm_reg_field::type_id::create("err_wl14_bank1",,get_full_name());
        this.err_wl14_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl15_bank1 = uvm_reg_field::type_id::create("err_wl15_bank1",,get_full_name());
        this.err_wl15_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl14_15_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl14_15_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl16_17_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl16_bank1;
    rand uvm_reg_field err_wl17_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl16_17_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl16_bank1 = uvm_reg_field::type_id::create("err_wl16_bank1",,get_full_name());
        this.err_wl16_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl17_bank1 = uvm_reg_field::type_id::create("err_wl17_bank1",,get_full_name());
        this.err_wl17_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl16_17_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl16_17_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl18_19_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl18_bank1;
    rand uvm_reg_field err_wl19_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl18_19_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl18_bank1 = uvm_reg_field::type_id::create("err_wl18_bank1",,get_full_name());
        this.err_wl18_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl19_bank1 = uvm_reg_field::type_id::create("err_wl19_bank1",,get_full_name());
        this.err_wl19_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl18_19_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl18_19_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl20_21_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl20_bank1;
    rand uvm_reg_field err_wl21_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl20_21_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl20_bank1 = uvm_reg_field::type_id::create("err_wl20_bank1",,get_full_name());
        this.err_wl20_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl21_bank1 = uvm_reg_field::type_id::create("err_wl21_bank1",,get_full_name());
        this.err_wl21_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl20_21_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl20_21_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl22_23_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl22_bank1;
    rand uvm_reg_field err_wl23_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl22_23_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl22_bank1 = uvm_reg_field::type_id::create("err_wl22_bank1",,get_full_name());
        this.err_wl22_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl23_bank1 = uvm_reg_field::type_id::create("err_wl23_bank1",,get_full_name());
        this.err_wl23_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl22_23_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl22_23_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl24_25_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl24_bank1;
    rand uvm_reg_field err_wl25_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl24_25_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl24_bank1 = uvm_reg_field::type_id::create("err_wl24_bank1",,get_full_name());
        this.err_wl24_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl25_bank1 = uvm_reg_field::type_id::create("err_wl25_bank1",,get_full_name());
        this.err_wl25_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl24_25_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl24_25_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl26_27_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl26_bank1;
    rand uvm_reg_field err_wl27_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl26_27_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl26_bank1 = uvm_reg_field::type_id::create("err_wl26_bank1",,get_full_name());
        this.err_wl26_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl27_bank1 = uvm_reg_field::type_id::create("err_wl27_bank1",,get_full_name());
        this.err_wl27_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl26_27_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl26_27_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl28_29_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl28_bank1;
    rand uvm_reg_field err_wl29_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl28_29_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl28_bank1 = uvm_reg_field::type_id::create("err_wl28_bank1",,get_full_name());
        this.err_wl28_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl29_bank1 = uvm_reg_field::type_id::create("err_wl29_bank1",,get_full_name());
        this.err_wl29_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl28_29_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl28_29_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl30_31_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl30_bank1;
    rand uvm_reg_field err_wl31_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl30_31_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl30_bank1 = uvm_reg_field::type_id::create("err_wl30_bank1",,get_full_name());
        this.err_wl30_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl31_bank1 = uvm_reg_field::type_id::create("err_wl31_bank1",,get_full_name());
        this.err_wl31_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl30_31_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl30_31_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl32_33_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl32_bank1;
    rand uvm_reg_field err_wl33_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl32_33_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl32_bank1 = uvm_reg_field::type_id::create("err_wl32_bank1",,get_full_name());
        this.err_wl32_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl33_bank1 = uvm_reg_field::type_id::create("err_wl33_bank1",,get_full_name());
        this.err_wl33_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl32_33_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl32_33_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl34_35_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl34_bank1;
    rand uvm_reg_field err_wl35_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl34_35_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl34_bank1 = uvm_reg_field::type_id::create("err_wl34_bank1",,get_full_name());
        this.err_wl34_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl35_bank1 = uvm_reg_field::type_id::create("err_wl35_bank1",,get_full_name());
        this.err_wl35_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl34_35_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl34_35_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl36_37_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl36_bank1;
    rand uvm_reg_field err_wl37_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl36_37_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl36_bank1 = uvm_reg_field::type_id::create("err_wl36_bank1",,get_full_name());
        this.err_wl36_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl37_bank1 = uvm_reg_field::type_id::create("err_wl37_bank1",,get_full_name());
        this.err_wl37_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl36_37_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl36_37_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl38_39_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl38_bank1;
    rand uvm_reg_field err_wl39_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl38_39_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl38_bank1 = uvm_reg_field::type_id::create("err_wl38_bank1",,get_full_name());
        this.err_wl38_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl39_bank1 = uvm_reg_field::type_id::create("err_wl39_bank1",,get_full_name());
        this.err_wl39_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl38_39_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl38_39_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl40_41_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl40_bank1;
    rand uvm_reg_field err_wl41_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl40_41_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl40_bank1 = uvm_reg_field::type_id::create("err_wl40_bank1",,get_full_name());
        this.err_wl40_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl41_bank1 = uvm_reg_field::type_id::create("err_wl41_bank1",,get_full_name());
        this.err_wl41_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl40_41_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl40_41_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl42_43_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl42_bank1;
    rand uvm_reg_field err_wl43_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl42_43_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl42_bank1 = uvm_reg_field::type_id::create("err_wl42_bank1",,get_full_name());
        this.err_wl42_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl43_bank1 = uvm_reg_field::type_id::create("err_wl43_bank1",,get_full_name());
        this.err_wl43_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl42_43_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl42_43_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl44_45_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl44_bank1;
    rand uvm_reg_field err_wl45_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl44_45_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl44_bank1 = uvm_reg_field::type_id::create("err_wl44_bank1",,get_full_name());
        this.err_wl44_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl45_bank1 = uvm_reg_field::type_id::create("err_wl45_bank1",,get_full_name());
        this.err_wl45_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl44_45_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl44_45_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl46_47_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl46_bank1;
    rand uvm_reg_field err_wl47_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl46_47_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl46_bank1 = uvm_reg_field::type_id::create("err_wl46_bank1",,get_full_name());
        this.err_wl46_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl47_bank1 = uvm_reg_field::type_id::create("err_wl47_bank1",,get_full_name());
        this.err_wl47_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl46_47_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl46_47_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl48_49_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl48_bank1;
    rand uvm_reg_field err_wl49_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl48_49_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl48_bank1 = uvm_reg_field::type_id::create("err_wl48_bank1",,get_full_name());
        this.err_wl48_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl49_bank1 = uvm_reg_field::type_id::create("err_wl49_bank1",,get_full_name());
        this.err_wl49_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl48_49_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl48_49_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl50_51_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl50_bank1;
    rand uvm_reg_field err_wl51_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl50_51_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl50_bank1 = uvm_reg_field::type_id::create("err_wl50_bank1",,get_full_name());
        this.err_wl50_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl51_bank1 = uvm_reg_field::type_id::create("err_wl51_bank1",,get_full_name());
        this.err_wl51_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl50_51_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl50_51_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl52_53_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl52_bank1;
    rand uvm_reg_field err_wl53_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl52_53_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl52_bank1 = uvm_reg_field::type_id::create("err_wl52_bank1",,get_full_name());
        this.err_wl52_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl53_bank1 = uvm_reg_field::type_id::create("err_wl53_bank1",,get_full_name());
        this.err_wl53_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl52_53_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl52_53_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl54_55_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl54_bank1;
    rand uvm_reg_field err_wl55_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl54_55_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl54_bank1 = uvm_reg_field::type_id::create("err_wl54_bank1",,get_full_name());
        this.err_wl54_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl55_bank1 = uvm_reg_field::type_id::create("err_wl55_bank1",,get_full_name());
        this.err_wl55_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl54_55_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl54_55_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl56_57_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl56_bank1;
    rand uvm_reg_field err_wl57_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl56_57_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl56_bank1 = uvm_reg_field::type_id::create("err_wl56_bank1",,get_full_name());
        this.err_wl56_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl57_bank1 = uvm_reg_field::type_id::create("err_wl57_bank1",,get_full_name());
        this.err_wl57_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl56_57_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl56_57_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl58_59_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl58_bank1;
    rand uvm_reg_field err_wl59_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl58_59_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl58_bank1 = uvm_reg_field::type_id::create("err_wl58_bank1",,get_full_name());
        this.err_wl58_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl59_bank1 = uvm_reg_field::type_id::create("err_wl59_bank1",,get_full_name());
        this.err_wl59_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl58_59_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl58_59_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl60_61_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl60_bank1;
    rand uvm_reg_field err_wl61_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl60_61_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl60_bank1 = uvm_reg_field::type_id::create("err_wl60_bank1",,get_full_name());
        this.err_wl60_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl61_bank1 = uvm_reg_field::type_id::create("err_wl61_bank1",,get_full_name());
        this.err_wl61_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl60_61_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl60_61_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_wl62_63_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_wl62_bank1;
    rand uvm_reg_field err_wl63_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_wl62_63_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_wl62_bank1 = uvm_reg_field::type_id::create("err_wl62_bank1",,get_full_name());
        this.err_wl62_bank1.configure(this,13,0,"RO",0,32'h1FFF,1,0,0);
        this.err_wl63_bank1 = uvm_reg_field::type_id::create("err_wl63_bank1",,get_full_name());
        this.err_wl63_bank1.configure(this,13,13,"RO",0,32'h1FFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_wl62_63_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_wl62_63_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_csl_part0_1_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part0_bank1;
    rand uvm_reg_field err_csl1_part0_bank1;
    rand uvm_reg_field err_csl0_part1_bank1;
    rand uvm_reg_field err_csl1_part1_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_csl_part0_1_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part0_bank1 = uvm_reg_field::type_id::create("err_csl0_part0_bank1",,get_full_name());
        this.err_csl0_part0_bank1.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part0_bank1 = uvm_reg_field::type_id::create("err_csl1_part0_bank1",,get_full_name());
        this.err_csl1_part0_bank1.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part1_bank1 = uvm_reg_field::type_id::create("err_csl0_part1_bank1",,get_full_name());
        this.err_csl0_part1_bank1.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part1_bank1 = uvm_reg_field::type_id::create("err_csl1_part1_bank1",,get_full_name());
        this.err_csl1_part1_bank1.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_csl_part0_1_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_csl_part0_1_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_csl_part2_3_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part2_bank1;
    rand uvm_reg_field err_csl1_part2_bank1;
    rand uvm_reg_field err_csl0_part3_bank1;
    rand uvm_reg_field err_csl1_part3_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_csl_part2_3_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part2_bank1 = uvm_reg_field::type_id::create("err_csl0_part2_bank1",,get_full_name());
        this.err_csl0_part2_bank1.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part2_bank1 = uvm_reg_field::type_id::create("err_csl1_part2_bank1",,get_full_name());
        this.err_csl1_part2_bank1.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part3_bank1 = uvm_reg_field::type_id::create("err_csl0_part3_bank1",,get_full_name());
        this.err_csl0_part3_bank1.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part3_bank1 = uvm_reg_field::type_id::create("err_csl1_part3_bank1",,get_full_name());
        this.err_csl1_part3_bank1.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_csl_part2_3_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_csl_part2_3_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_csl_part4_5_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part4_bank1;
    rand uvm_reg_field err_csl1_part4_bank1;
    rand uvm_reg_field err_csl0_part5_bank1;
    rand uvm_reg_field err_csl1_part5_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_csl_part4_5_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part4_bank1 = uvm_reg_field::type_id::create("err_csl0_part4_bank1",,get_full_name());
        this.err_csl0_part4_bank1.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part4_bank1 = uvm_reg_field::type_id::create("err_csl1_part4_bank1",,get_full_name());
        this.err_csl1_part4_bank1.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part5_bank1 = uvm_reg_field::type_id::create("err_csl0_part5_bank1",,get_full_name());
        this.err_csl0_part5_bank1.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part5_bank1 = uvm_reg_field::type_id::create("err_csl1_part5_bank1",,get_full_name());
        this.err_csl1_part5_bank1.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_csl_part4_5_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_csl_part4_5_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_csl_part6_7_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part6_bank1;
    rand uvm_reg_field err_csl1_part6_bank1;
    rand uvm_reg_field err_csl0_part7_bank1;
    rand uvm_reg_field err_csl1_part7_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_csl_part6_7_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part6_bank1 = uvm_reg_field::type_id::create("err_csl0_part6_bank1",,get_full_name());
        this.err_csl0_part6_bank1.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part6_bank1 = uvm_reg_field::type_id::create("err_csl1_part6_bank1",,get_full_name());
        this.err_csl1_part6_bank1.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part7_bank1 = uvm_reg_field::type_id::create("err_csl0_part7_bank1",,get_full_name());
        this.err_csl0_part7_bank1.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part7_bank1 = uvm_reg_field::type_id::create("err_csl1_part7_bank1",,get_full_name());
        this.err_csl1_part7_bank1.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_csl_part6_7_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_csl_part6_7_bank1_reg

class ral_reg_mc_1short2_top_aux_top_err_csl_part8_9_bank1_reg extends uvm_reg;
    rand uvm_reg_field err_csl0_part8_bank1;
    rand uvm_reg_field err_csl1_part8_bank1;
    rand uvm_reg_field err_csl0_part9_bank1;
    rand uvm_reg_field err_csl1_part9_bank1;

    function new(string name = "mc_1short2_top_aux_top_err_csl_part8_9_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.err_csl0_part8_bank1 = uvm_reg_field::type_id::create("err_csl0_part8_bank1",,get_full_name());
        this.err_csl0_part8_bank1.configure(this,8,0,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part8_bank1 = uvm_reg_field::type_id::create("err_csl1_part8_bank1",,get_full_name());
        this.err_csl1_part8_bank1.configure(this,8,8,"RO",0,32'hFF,1,0,0);
        this.err_csl0_part9_bank1 = uvm_reg_field::type_id::create("err_csl0_part9_bank1",,get_full_name());
        this.err_csl0_part9_bank1.configure(this,8,16,"RO",0,32'hFF,1,0,0);
        this.err_csl1_part9_bank1 = uvm_reg_field::type_id::create("err_csl1_part9_bank1",,get_full_name());
        this.err_csl1_part9_bank1.configure(this,8,24,"RO",0,32'hFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_err_csl_part8_9_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_err_csl_part8_9_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_bank_cfg_reg_reg extends uvm_reg;
    rand uvm_reg_field mc_bank_map_id;
    rand uvm_reg_field mc_bist_grant;

    function new(string name = "mc_1short2_top_aux_top_mc_bank_cfg_reg_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bank_map_id = uvm_reg_field::type_id::create("mc_bank_map_id",,get_full_name());
        this.mc_bank_map_id.configure(this,8,0,"RW",0,32'hE4,1,0,0);
        this.mc_bist_grant = uvm_reg_field::type_id::create("mc_bist_grant",,get_full_name());
        this.mc_bist_grant.configure(this,4,8,"RW",0,32'h3,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_bank_cfg_reg_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_bank_cfg_reg_reg

class ral_reg_mc_1short2_top_aux_top_mc_timeout_clr_reg extends uvm_reg;
    rand uvm_reg_field mc_timeout_clr;

    function new(string name = "mc_1short2_top_aux_top_mc_timeout_clr_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_timeout_clr = uvm_reg_field::type_id::create("mc_timeout_clr",,get_full_name());
        this.mc_timeout_clr.configure(this,1,0,"W1C",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_timeout_clr_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_timeout_clr_reg

class ral_reg_mc_1short2_top_aux_top_mc_rf_start_dbg_reg extends uvm_reg;
    rand uvm_reg_field mc_rf_start_dbg;

    function new(string name = "mc_1short2_top_aux_top_mc_rf_start_dbg_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_rf_start_dbg = uvm_reg_field::type_id::create("mc_rf_start_dbg",,get_full_name());
        this.mc_rf_start_dbg.configure(this,1,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_rf_start_dbg_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_rf_start_dbg_reg

class ral_reg_mc_1short2_top_aux_top_mc_timeout_flag_reg extends uvm_reg;
    rand uvm_reg_field mc_timeout_flag;

    function new(string name = "mc_1short2_top_aux_top_mc_timeout_flag_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_timeout_flag = uvm_reg_field::type_id::create("mc_timeout_flag",,get_full_name());
        this.mc_timeout_flag.configure(this,1,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_timeout_flag_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_timeout_flag_reg

class ral_reg_mc_1short2_top_aux_top_mc_bist_status_reg extends uvm_reg;
    rand uvm_reg_field mc_bist_status;
    rand uvm_reg_field mc_bist_path_fail_bank0;
    rand uvm_reg_field mc_bist_path_fail_bank1;
    rand uvm_reg_field dram_init_finish;

    function new(string name = "mc_1short2_top_aux_top_mc_bist_status_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bist_status = uvm_reg_field::type_id::create("mc_bist_status",,get_full_name());
        this.mc_bist_status.configure(this,3,0,"RO",0,32'h0,1,0,0);
        this.mc_bist_path_fail_bank0 = uvm_reg_field::type_id::create("mc_bist_path_fail_bank0",,get_full_name());
        this.mc_bist_path_fail_bank0.configure(this,1,3,"RO",0,32'h0,1,0,0);
        this.mc_bist_path_fail_bank1 = uvm_reg_field::type_id::create("mc_bist_path_fail_bank1",,get_full_name());
        this.mc_bist_path_fail_bank1.configure(this,1,4,"RO",0,32'h0,1,0,0);
        this.dram_init_finish = uvm_reg_field::type_id::create("dram_init_finish",,get_full_name());
        this.dram_init_finish.configure(this,1,5,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_bist_status_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_bist_status_reg

class ral_reg_mc_1short2_top_aux_top_bist_finish_and_success_reg extends uvm_reg;
    rand uvm_reg_field bist_finish_bank0;
    rand uvm_reg_field bist_finish_bank1;
    rand uvm_reg_field bist_rescan_finish_bank0;
    rand uvm_reg_field bist_rescan_finish_bank1;
    rand uvm_reg_field bank_success_bank0;
    rand uvm_reg_field bank_success_bank1;
    rand uvm_reg_field bist_rescan_success_bank0;
    rand uvm_reg_field bist_rescan_success_bank1;

    function new(string name = "mc_1short2_top_aux_top_bist_finish_and_success_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_finish_bank0 = uvm_reg_field::type_id::create("bist_finish_bank0",,get_full_name());
        this.bist_finish_bank0.configure(this,1,0,"RO",0,32'h0,1,0,0);
        this.bist_finish_bank1 = uvm_reg_field::type_id::create("bist_finish_bank1",,get_full_name());
        this.bist_finish_bank1.configure(this,1,1,"RO",0,32'h0,1,0,0);
        this.bist_rescan_finish_bank0 = uvm_reg_field::type_id::create("bist_rescan_finish_bank0",,get_full_name());
        this.bist_rescan_finish_bank0.configure(this,1,2,"RO",0,32'h0,1,0,0);
        this.bist_rescan_finish_bank1 = uvm_reg_field::type_id::create("bist_rescan_finish_bank1",,get_full_name());
        this.bist_rescan_finish_bank1.configure(this,1,3,"RO",0,32'h0,1,0,0);
        this.bank_success_bank0 = uvm_reg_field::type_id::create("bank_success_bank0",,get_full_name());
        this.bank_success_bank0.configure(this,1,4,"RO",0,32'h0,1,0,0);
        this.bank_success_bank1 = uvm_reg_field::type_id::create("bank_success_bank1",,get_full_name());
        this.bank_success_bank1.configure(this,1,5,"RO",0,32'h0,1,0,0);
        this.bist_rescan_success_bank0 = uvm_reg_field::type_id::create("bist_rescan_success_bank0",,get_full_name());
        this.bist_rescan_success_bank0.configure(this,1,6,"RO",0,32'h0,1,0,0);
        this.bist_rescan_success_bank1 = uvm_reg_field::type_id::create("bist_rescan_success_bank1",,get_full_name());
        this.bist_rescan_success_bank1.configure(this,1,7,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_bist_finish_and_success_reg)
endclass:ral_reg_mc_1short2_top_aux_top_bist_finish_and_success_reg

class ral_reg_mc_1short2_top_aux_top_mc_bist_rescan_fail_num_bank0_reg extends uvm_reg;
    rand uvm_reg_field mc_bist_rescan_fail_num_bank0;

    function new(string name = "mc_1short2_top_aux_top_mc_bist_rescan_fail_num_bank0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bist_rescan_fail_num_bank0 = uvm_reg_field::type_id::create("mc_bist_rescan_fail_num_bank0",,get_full_name());
        this.mc_bist_rescan_fail_num_bank0.configure(this,20,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_bist_rescan_fail_num_bank0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_bist_rescan_fail_num_bank0_reg

class ral_reg_mc_1short2_top_aux_top_mc_bist_rescan_fail_num_bank1_reg extends uvm_reg;
    rand uvm_reg_field mc_bist_rescan_fail_num_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_bist_rescan_fail_num_bank1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bist_rescan_fail_num_bank1 = uvm_reg_field::type_id::create("mc_bist_rescan_fail_num_bank1",,get_full_name());
        this.mc_bist_rescan_fail_num_bank1.configure(this,20,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_bist_rescan_fail_num_bank1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_bist_rescan_fail_num_bank1_reg

class ral_reg_mc_1short2_top_aux_top_mc_bist_err_wl_reg extends uvm_reg;
    rand uvm_reg_field mc_bist_err_wl_num_bank0;
    rand uvm_reg_field mc_bist_err_wl_num_bank1;
    rand uvm_reg_field err_wl_num_change_flag_bank0;
    rand uvm_reg_field err_wl_num_change_flag_bank1;

    function new(string name = "mc_1short2_top_aux_top_mc_bist_err_wl_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_bist_err_wl_num_bank0 = uvm_reg_field::type_id::create("mc_bist_err_wl_num_bank0",,get_full_name());
        this.mc_bist_err_wl_num_bank0.configure(this,7,0,"RO",0,32'h0,1,0,0);
        this.mc_bist_err_wl_num_bank1 = uvm_reg_field::type_id::create("mc_bist_err_wl_num_bank1",,get_full_name());
        this.mc_bist_err_wl_num_bank1.configure(this,7,7,"RO",0,32'h0,1,0,0);
        this.err_wl_num_change_flag_bank0 = uvm_reg_field::type_id::create("err_wl_num_change_flag_bank0",,get_full_name());
        this.err_wl_num_change_flag_bank0.configure(this,1,14,"RO",0,32'h0,1,0,0);
        this.err_wl_num_change_flag_bank1 = uvm_reg_field::type_id::create("err_wl_num_change_flag_bank1",,get_full_name());
        this.err_wl_num_change_flag_bank1.configure(this,1,15,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_bist_err_wl_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_bist_err_wl_reg

class ral_reg_mc_1short2_top_aux_top_rescan_finish_clr_reg extends uvm_reg;
    rand uvm_reg_field rescan_finish_clr;

    function new(string name = "mc_1short2_top_aux_top_rescan_finish_clr_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.rescan_finish_clr = uvm_reg_field::type_id::create("rescan_finish_clr",,get_full_name());
        this.rescan_finish_clr.configure(this,1,0,"W1C",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_rescan_finish_clr_reg)
endclass:ral_reg_mc_1short2_top_aux_top_rescan_finish_clr_reg

class ral_reg_mc_1short2_top_aux_top_rescan_finish_mask_reg extends uvm_reg;
    rand uvm_reg_field rescan_finish_mask;

    function new(string name = "mc_1short2_top_aux_top_rescan_finish_mask_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.rescan_finish_mask = uvm_reg_field::type_id::create("rescan_finish_mask",,get_full_name());
        this.rescan_finish_mask.configure(this,1,0,"RW",0,32'h1,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_rescan_finish_mask_reg)
endclass:ral_reg_mc_1short2_top_aux_top_rescan_finish_mask_reg

class ral_reg_mc_1short2_top_aux_top_rescan_round_result_1_reg extends uvm_reg;
    rand uvm_reg_field rescan_round_result_bank0;
    rand uvm_reg_field rescan_round_result_bank1;

    function new(string name = "mc_1short2_top_aux_top_rescan_round_result_1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.rescan_round_result_bank0 = uvm_reg_field::type_id::create("rescan_round_result_bank0",,get_full_name());
        this.rescan_round_result_bank0.configure(this,15,0,"RO",0,32'h0,1,0,0);
        this.rescan_round_result_bank1 = uvm_reg_field::type_id::create("rescan_round_result_bank1",,get_full_name());
        this.rescan_round_result_bank1.configure(this,15,15,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_rescan_round_result_1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_rescan_round_result_1_reg

class ral_reg_mc_1short2_top_aux_top_bist_finish_clr_reg extends uvm_reg;
    rand uvm_reg_field bist_finish_clr;

    function new(string name = "mc_1short2_top_aux_top_bist_finish_clr_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_finish_clr = uvm_reg_field::type_id::create("bist_finish_clr",,get_full_name());
        this.bist_finish_clr.configure(this,1,0,"W1C",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_bist_finish_clr_reg)
endclass:ral_reg_mc_1short2_top_aux_top_bist_finish_clr_reg

class ral_reg_mc_1short2_top_aux_top_bist_finish_mask_reg extends uvm_reg;
    rand uvm_reg_field bist_finish_mask;

    function new(string name = "mc_1short2_top_aux_top_bist_finish_mask_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_finish_mask = uvm_reg_field::type_id::create("bist_finish_mask",,get_full_name());
        this.bist_finish_mask.configure(this,1,0,"RW",0,32'h1,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_bist_finish_mask_reg)
endclass:ral_reg_mc_1short2_top_aux_top_bist_finish_mask_reg

class ral_reg_mc_1short2_top_aux_top_hang_timeout_th_reg extends uvm_reg;
    rand uvm_reg_field hang_timeout_th;

    function new(string name = "mc_1short2_top_aux_top_hang_timeout_th_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hang_timeout_th = uvm_reg_field::type_id::create("hang_timeout_th",,get_full_name());
        this.hang_timeout_th.configure(this,32,0,"RW",0,32'hC3500,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_hang_timeout_th_reg)
endclass:ral_reg_mc_1short2_top_aux_top_hang_timeout_th_reg

class ral_reg_mc_1short2_top_aux_top_bist_pattern_reg0_reg extends uvm_reg;
    rand uvm_reg_field bist_pattern_reg0;

    function new(string name = "mc_1short2_top_aux_top_bist_pattern_reg0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_pattern_reg0 = uvm_reg_field::type_id::create("bist_pattern_reg0",,get_full_name());
        this.bist_pattern_reg0.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_bist_pattern_reg0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_bist_pattern_reg0_reg

class ral_reg_mc_1short2_top_aux_top_bist_pattern_reg1_reg extends uvm_reg;
    rand uvm_reg_field bist_pattern_reg1;

    function new(string name = "mc_1short2_top_aux_top_bist_pattern_reg1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_pattern_reg1 = uvm_reg_field::type_id::create("bist_pattern_reg1",,get_full_name());
        this.bist_pattern_reg1.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_bist_pattern_reg1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_bist_pattern_reg1_reg

class ral_reg_mc_1short2_top_aux_top_bist_pattern_reg2_reg extends uvm_reg;
    rand uvm_reg_field bist_pattern_reg2;

    function new(string name = "mc_1short2_top_aux_top_bist_pattern_reg2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_pattern_reg2 = uvm_reg_field::type_id::create("bist_pattern_reg2",,get_full_name());
        this.bist_pattern_reg2.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_bist_pattern_reg2_reg)
endclass:ral_reg_mc_1short2_top_aux_top_bist_pattern_reg2_reg

class ral_reg_mc_1short2_top_aux_top_bist_pattern_reg3_reg extends uvm_reg;
    rand uvm_reg_field bist_pattern_reg3;

    function new(string name = "mc_1short2_top_aux_top_bist_pattern_reg3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_pattern_reg3 = uvm_reg_field::type_id::create("bist_pattern_reg3",,get_full_name());
        this.bist_pattern_reg3.configure(this,32,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_bist_pattern_reg3_reg)
endclass:ral_reg_mc_1short2_top_aux_top_bist_pattern_reg3_reg

class ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel0_reg extends uvm_reg;
    rand uvm_reg_field csl_bist_pattern_sel0;

    function new(string name = "mc_1short2_top_aux_top_csl_bist_pattern_sel0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.csl_bist_pattern_sel0 = uvm_reg_field::type_id::create("csl_bist_pattern_sel0",,get_full_name());
        this.csl_bist_pattern_sel0.configure(this,32,0,"RW",0,32'hFFFFFFFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel0_reg

class ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel1_reg extends uvm_reg;
    rand uvm_reg_field csl_bist_pattern_sel1;

    function new(string name = "mc_1short2_top_aux_top_csl_bist_pattern_sel1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.csl_bist_pattern_sel1 = uvm_reg_field::type_id::create("csl_bist_pattern_sel1",,get_full_name());
        this.csl_bist_pattern_sel1.configure(this,32,0,"RW",0,32'hFFFFFFFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel1_reg

class ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel2_reg extends uvm_reg;
    rand uvm_reg_field csl_bist_pattern_sel2;

    function new(string name = "mc_1short2_top_aux_top_csl_bist_pattern_sel2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.csl_bist_pattern_sel2 = uvm_reg_field::type_id::create("csl_bist_pattern_sel2",,get_full_name());
        this.csl_bist_pattern_sel2.configure(this,4,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel2_reg)
endclass:ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel2_reg

class ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel0_reg extends uvm_reg;
    rand uvm_reg_field wl_bist_pattern_sel0;

    function new(string name = "mc_1short2_top_aux_top_wl_bist_pattern_sel0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.wl_bist_pattern_sel0 = uvm_reg_field::type_id::create("wl_bist_pattern_sel0",,get_full_name());
        this.wl_bist_pattern_sel0.configure(this,32,0,"RW",0,32'hFFFFFFFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel0_reg

class ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel1_reg extends uvm_reg;
    rand uvm_reg_field wl_bist_pattern_sel1;

    function new(string name = "mc_1short2_top_aux_top_wl_bist_pattern_sel1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.wl_bist_pattern_sel1 = uvm_reg_field::type_id::create("wl_bist_pattern_sel1",,get_full_name());
        this.wl_bist_pattern_sel1.configure(this,32,0,"RW",0,32'hFFFFFFFF,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel1_reg

class ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel2_reg extends uvm_reg;
    rand uvm_reg_field wl_bist_pattern_sel2;

    function new(string name = "mc_1short2_top_aux_top_wl_bist_pattern_sel2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.wl_bist_pattern_sel2 = uvm_reg_field::type_id::create("wl_bist_pattern_sel2",,get_full_name());
        this.wl_bist_pattern_sel2.configure(this,4,0,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel2_reg)
endclass:ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel2_reg

class ral_reg_mc_1short2_top_aux_top_mc_frame2array_dbg_reg extends uvm_reg;
    rand uvm_reg_field dbg_next_state_array;
    rand uvm_reg_field dbg_current_state_array;
    rand uvm_reg_field dbg_r_data_cnt;
    rand uvm_reg_field dbg_refresh_flag;
    rand uvm_reg_field dbg_r_frame_cnt;
    rand uvm_reg_field dbg_w_frame_cnt;

    function new(string name = "mc_1short2_top_aux_top_mc_frame2array_dbg_reg");
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
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_frame2array_dbg_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_frame2array_dbg_reg

class ral_reg_mc_1short2_top_aux_top_dbg_frame_store_0_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_0;

    function new(string name = "mc_1short2_top_aux_top_dbg_frame_store_0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_0 = uvm_reg_field::type_id::create("dbg_frame_store_0",,get_full_name());
        this.dbg_frame_store_0.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_frame_store_0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_frame_store_0_reg

class ral_reg_mc_1short2_top_aux_top_dbg_frame_store_1_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_1;

    function new(string name = "mc_1short2_top_aux_top_dbg_frame_store_1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_1 = uvm_reg_field::type_id::create("dbg_frame_store_1",,get_full_name());
        this.dbg_frame_store_1.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_frame_store_1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_frame_store_1_reg

class ral_reg_mc_1short2_top_aux_top_dbg_frame_store_2_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_2;

    function new(string name = "mc_1short2_top_aux_top_dbg_frame_store_2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_2 = uvm_reg_field::type_id::create("dbg_frame_store_2",,get_full_name());
        this.dbg_frame_store_2.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_frame_store_2_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_frame_store_2_reg

class ral_reg_mc_1short2_top_aux_top_dbg_frame_store_3_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_3;

    function new(string name = "mc_1short2_top_aux_top_dbg_frame_store_3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_3 = uvm_reg_field::type_id::create("dbg_frame_store_3",,get_full_name());
        this.dbg_frame_store_3.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_frame_store_3_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_frame_store_3_reg

class ral_reg_mc_1short2_top_aux_top_dbg_frame_store_4_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_4;

    function new(string name = "mc_1short2_top_aux_top_dbg_frame_store_4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_4 = uvm_reg_field::type_id::create("dbg_frame_store_4",,get_full_name());
        this.dbg_frame_store_4.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_frame_store_4_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_frame_store_4_reg

class ral_reg_mc_1short2_top_aux_top_dbg_frame_store_5_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_5;

    function new(string name = "mc_1short2_top_aux_top_dbg_frame_store_5_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_5 = uvm_reg_field::type_id::create("dbg_frame_store_5",,get_full_name());
        this.dbg_frame_store_5.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_frame_store_5_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_frame_store_5_reg

class ral_reg_mc_1short2_top_aux_top_dbg_frame_store_6_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_6;

    function new(string name = "mc_1short2_top_aux_top_dbg_frame_store_6_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_6 = uvm_reg_field::type_id::create("dbg_frame_store_6",,get_full_name());
        this.dbg_frame_store_6.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_frame_store_6_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_frame_store_6_reg

class ral_reg_mc_1short2_top_aux_top_dbg_frame_store_7_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_7;

    function new(string name = "mc_1short2_top_aux_top_dbg_frame_store_7_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_7 = uvm_reg_field::type_id::create("dbg_frame_store_7",,get_full_name());
        this.dbg_frame_store_7.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_frame_store_7_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_frame_store_7_reg

class ral_reg_mc_1short2_top_aux_top_dbg_frame_store_8_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_8;

    function new(string name = "mc_1short2_top_aux_top_dbg_frame_store_8_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_8 = uvm_reg_field::type_id::create("dbg_frame_store_8",,get_full_name());
        this.dbg_frame_store_8.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_frame_store_8_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_frame_store_8_reg

class ral_reg_mc_1short2_top_aux_top_dbg_frame_store_9_reg extends uvm_reg;
    rand uvm_reg_field dbg_frame_store_9;

    function new(string name = "mc_1short2_top_aux_top_dbg_frame_store_9_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_frame_store_9 = uvm_reg_field::type_id::create("dbg_frame_store_9",,get_full_name());
        this.dbg_frame_store_9.configure(this,2,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_frame_store_9_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_frame_store_9_reg

class ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_0_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_0;

    function new(string name = "mc_1short2_top_aux_top_dbg_rdata_store_0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_0 = uvm_reg_field::type_id::create("dbg_rdata_store_0",,get_full_name());
        this.dbg_rdata_store_0.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_0_reg

class ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_1_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_1;

    function new(string name = "mc_1short2_top_aux_top_dbg_rdata_store_1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_1 = uvm_reg_field::type_id::create("dbg_rdata_store_1",,get_full_name());
        this.dbg_rdata_store_1.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_1_reg

class ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_2_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_2;

    function new(string name = "mc_1short2_top_aux_top_dbg_rdata_store_2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_2 = uvm_reg_field::type_id::create("dbg_rdata_store_2",,get_full_name());
        this.dbg_rdata_store_2.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_2_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_2_reg

class ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_3_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_3;

    function new(string name = "mc_1short2_top_aux_top_dbg_rdata_store_3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_3 = uvm_reg_field::type_id::create("dbg_rdata_store_3",,get_full_name());
        this.dbg_rdata_store_3.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_3_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_3_reg

class ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_4_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_4;

    function new(string name = "mc_1short2_top_aux_top_dbg_rdata_store_4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_4 = uvm_reg_field::type_id::create("dbg_rdata_store_4",,get_full_name());
        this.dbg_rdata_store_4.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_4_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_4_reg

class ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_5_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_5;

    function new(string name = "mc_1short2_top_aux_top_dbg_rdata_store_5_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_5 = uvm_reg_field::type_id::create("dbg_rdata_store_5",,get_full_name());
        this.dbg_rdata_store_5.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_5_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_5_reg

class ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_6_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_6;

    function new(string name = "mc_1short2_top_aux_top_dbg_rdata_store_6_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_6 = uvm_reg_field::type_id::create("dbg_rdata_store_6",,get_full_name());
        this.dbg_rdata_store_6.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_6_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_6_reg

class ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_7_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_7;

    function new(string name = "mc_1short2_top_aux_top_dbg_rdata_store_7_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_7 = uvm_reg_field::type_id::create("dbg_rdata_store_7",,get_full_name());
        this.dbg_rdata_store_7.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_7_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_7_reg

class ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_8_reg extends uvm_reg;
    rand uvm_reg_field dbg_rdata_store_8;

    function new(string name = "mc_1short2_top_aux_top_dbg_rdata_store_8_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.dbg_rdata_store_8 = uvm_reg_field::type_id::create("dbg_rdata_store_8",,get_full_name());
        this.dbg_rdata_store_8.configure(this,10,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_8_reg)
endclass:ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_8_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_ctrl_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_int_clr;
    rand uvm_reg_field mc_ecc_ce_overflow_int;
    rand uvm_reg_field mc_ecc_ce_th;
    rand uvm_reg_field mc_ecc_ce_cnt;
    rand uvm_reg_field mc_ecc_ce_int_mask;
    rand uvm_reg_field mc_ecc_ce_int_en;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_ctrl_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_int_clr = uvm_reg_field::type_id::create("mc_ecc_ce_int_clr",,get_full_name());
        this.mc_ecc_ce_int_clr.configure(this,1,0,"W1C",0,32'h0,1,0,0);
        this.mc_ecc_ce_overflow_int = uvm_reg_field::type_id::create("mc_ecc_ce_overflow_int",,get_full_name());
        this.mc_ecc_ce_overflow_int.configure(this,1,4,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_th = uvm_reg_field::type_id::create("mc_ecc_ce_th",,get_full_name());
        this.mc_ecc_ce_th.configure(this,5,8,"RW",0,32'h5,1,0,0);
        this.mc_ecc_ce_cnt = uvm_reg_field::type_id::create("mc_ecc_ce_cnt",,get_full_name());
        this.mc_ecc_ce_cnt.configure(this,5,16,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_int_mask = uvm_reg_field::type_id::create("mc_ecc_ce_int_mask",,get_full_name());
        this.mc_ecc_ce_int_mask.configure(this,1,24,"RW",0,32'h0,1,0,0);
        this.mc_ecc_ce_int_en = uvm_reg_field::type_id::create("mc_ecc_ce_int_en",,get_full_name());
        this.mc_ecc_ce_int_en.configure(this,1,25,"RW",0,32'h1,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_ctrl_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_ctrl_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr0_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr0;
    rand uvm_reg_field mc_ecc_ce_addr_vld0;
    rand uvm_reg_field mc_ecc_ce_addr_cnt0;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr0 = uvm_reg_field::type_id::create("mc_ecc_ce_addr0",,get_full_name());
        this.mc_ecc_ce_addr0.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld0 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld0",,get_full_name());
        this.mc_ecc_ce_addr_vld0.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt0 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt0",,get_full_name());
        this.mc_ecc_ce_addr_cnt0.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr0_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr1_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr1;
    rand uvm_reg_field mc_ecc_ce_addr_vld1;
    rand uvm_reg_field mc_ecc_ce_addr_cnt1;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr1 = uvm_reg_field::type_id::create("mc_ecc_ce_addr1",,get_full_name());
        this.mc_ecc_ce_addr1.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld1 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld1",,get_full_name());
        this.mc_ecc_ce_addr_vld1.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt1 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt1",,get_full_name());
        this.mc_ecc_ce_addr_cnt1.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr1_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr2_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr2;
    rand uvm_reg_field mc_ecc_ce_addr_vld2;
    rand uvm_reg_field mc_ecc_ce_addr_cnt2;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr2 = uvm_reg_field::type_id::create("mc_ecc_ce_addr2",,get_full_name());
        this.mc_ecc_ce_addr2.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld2 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld2",,get_full_name());
        this.mc_ecc_ce_addr_vld2.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt2 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt2",,get_full_name());
        this.mc_ecc_ce_addr_cnt2.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr2_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr2_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr3_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr3;
    rand uvm_reg_field mc_ecc_ce_addr_vld3;
    rand uvm_reg_field mc_ecc_ce_addr_cnt3;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr3 = uvm_reg_field::type_id::create("mc_ecc_ce_addr3",,get_full_name());
        this.mc_ecc_ce_addr3.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld3 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld3",,get_full_name());
        this.mc_ecc_ce_addr_vld3.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt3 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt3",,get_full_name());
        this.mc_ecc_ce_addr_cnt3.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr3_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr3_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr4_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr4;
    rand uvm_reg_field mc_ecc_ce_addr_vld4;
    rand uvm_reg_field mc_ecc_ce_addr_cnt4;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr4_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr4 = uvm_reg_field::type_id::create("mc_ecc_ce_addr4",,get_full_name());
        this.mc_ecc_ce_addr4.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld4 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld4",,get_full_name());
        this.mc_ecc_ce_addr_vld4.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt4 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt4",,get_full_name());
        this.mc_ecc_ce_addr_cnt4.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr4_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr4_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr5_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr5;
    rand uvm_reg_field mc_ecc_ce_addr_vld5;
    rand uvm_reg_field mc_ecc_ce_addr_cnt5;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr5_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr5 = uvm_reg_field::type_id::create("mc_ecc_ce_addr5",,get_full_name());
        this.mc_ecc_ce_addr5.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld5 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld5",,get_full_name());
        this.mc_ecc_ce_addr_vld5.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt5 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt5",,get_full_name());
        this.mc_ecc_ce_addr_cnt5.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr5_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr5_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr6_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr6;
    rand uvm_reg_field mc_ecc_ce_addr_vld6;
    rand uvm_reg_field mc_ecc_ce_addr_cnt6;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr6_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr6 = uvm_reg_field::type_id::create("mc_ecc_ce_addr6",,get_full_name());
        this.mc_ecc_ce_addr6.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld6 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld6",,get_full_name());
        this.mc_ecc_ce_addr_vld6.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt6 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt6",,get_full_name());
        this.mc_ecc_ce_addr_cnt6.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr6_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr6_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr7_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr7;
    rand uvm_reg_field mc_ecc_ce_addr_vld7;
    rand uvm_reg_field mc_ecc_ce_addr_cnt7;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr7_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr7 = uvm_reg_field::type_id::create("mc_ecc_ce_addr7",,get_full_name());
        this.mc_ecc_ce_addr7.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld7 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld7",,get_full_name());
        this.mc_ecc_ce_addr_vld7.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt7 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt7",,get_full_name());
        this.mc_ecc_ce_addr_cnt7.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr7_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr7_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr8_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr8;
    rand uvm_reg_field mc_ecc_ce_addr_vld8;
    rand uvm_reg_field mc_ecc_ce_addr_cnt8;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr8_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr8 = uvm_reg_field::type_id::create("mc_ecc_ce_addr8",,get_full_name());
        this.mc_ecc_ce_addr8.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld8 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld8",,get_full_name());
        this.mc_ecc_ce_addr_vld8.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt8 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt8",,get_full_name());
        this.mc_ecc_ce_addr_cnt8.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr8_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr8_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr9_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr9;
    rand uvm_reg_field mc_ecc_ce_addr_vld9;
    rand uvm_reg_field mc_ecc_ce_addr_cnt9;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr9_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr9 = uvm_reg_field::type_id::create("mc_ecc_ce_addr9",,get_full_name());
        this.mc_ecc_ce_addr9.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld9 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld9",,get_full_name());
        this.mc_ecc_ce_addr_vld9.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt9 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt9",,get_full_name());
        this.mc_ecc_ce_addr_cnt9.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr9_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr9_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr10_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr10;
    rand uvm_reg_field mc_ecc_ce_addr_vld10;
    rand uvm_reg_field mc_ecc_ce_addr_cnt10;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr10_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr10 = uvm_reg_field::type_id::create("mc_ecc_ce_addr10",,get_full_name());
        this.mc_ecc_ce_addr10.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld10 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld10",,get_full_name());
        this.mc_ecc_ce_addr_vld10.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt10 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt10",,get_full_name());
        this.mc_ecc_ce_addr_cnt10.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr10_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr10_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr11_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr11;
    rand uvm_reg_field mc_ecc_ce_addr_vld11;
    rand uvm_reg_field mc_ecc_ce_addr_cnt11;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr11_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr11 = uvm_reg_field::type_id::create("mc_ecc_ce_addr11",,get_full_name());
        this.mc_ecc_ce_addr11.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld11 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld11",,get_full_name());
        this.mc_ecc_ce_addr_vld11.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt11 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt11",,get_full_name());
        this.mc_ecc_ce_addr_cnt11.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr11_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr11_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr12_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr12;
    rand uvm_reg_field mc_ecc_ce_addr_vld12;
    rand uvm_reg_field mc_ecc_ce_addr_cnt12;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr12_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr12 = uvm_reg_field::type_id::create("mc_ecc_ce_addr12",,get_full_name());
        this.mc_ecc_ce_addr12.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld12 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld12",,get_full_name());
        this.mc_ecc_ce_addr_vld12.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt12 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt12",,get_full_name());
        this.mc_ecc_ce_addr_cnt12.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr12_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr12_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr13_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr13;
    rand uvm_reg_field mc_ecc_ce_addr_vld13;
    rand uvm_reg_field mc_ecc_ce_addr_cnt13;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr13_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr13 = uvm_reg_field::type_id::create("mc_ecc_ce_addr13",,get_full_name());
        this.mc_ecc_ce_addr13.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld13 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld13",,get_full_name());
        this.mc_ecc_ce_addr_vld13.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt13 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt13",,get_full_name());
        this.mc_ecc_ce_addr_cnt13.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr13_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr13_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr14_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr14;
    rand uvm_reg_field mc_ecc_ce_addr_vld14;
    rand uvm_reg_field mc_ecc_ce_addr_cnt14;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr14_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr14 = uvm_reg_field::type_id::create("mc_ecc_ce_addr14",,get_full_name());
        this.mc_ecc_ce_addr14.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld14 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld14",,get_full_name());
        this.mc_ecc_ce_addr_vld14.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt14 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt14",,get_full_name());
        this.mc_ecc_ce_addr_cnt14.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr14_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr14_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr15_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_ce_addr15;
    rand uvm_reg_field mc_ecc_ce_addr_vld15;
    rand uvm_reg_field mc_ecc_ce_addr_cnt15;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_ce_addr15_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_ce_addr15 = uvm_reg_field::type_id::create("mc_ecc_ce_addr15",,get_full_name());
        this.mc_ecc_ce_addr15.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_ce_addr_vld15 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_vld15",,get_full_name());
        this.mc_ecc_ce_addr_vld15.configure(this,1,22,"RO",0,32'h0,1,0,0);
        this.mc_ecc_ce_addr_cnt15 = uvm_reg_field::type_id::create("mc_ecc_ce_addr_cnt15",,get_full_name());
        this.mc_ecc_ce_addr_cnt15.configure(this,8,24,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr15_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr15_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_ctrl_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_uce_int_clr;
    rand uvm_reg_field mc_ecc_uce_int;
    rand uvm_reg_field mc_ecc_uce_cnt;
    rand uvm_reg_field mc_ecc_uce_int_mask;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_uce_ctrl_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_uce_int_clr = uvm_reg_field::type_id::create("mc_ecc_uce_int_clr",,get_full_name());
        this.mc_ecc_uce_int_clr.configure(this,1,0,"W1C",0,32'h0,1,0,0);
        this.mc_ecc_uce_int = uvm_reg_field::type_id::create("mc_ecc_uce_int",,get_full_name());
        this.mc_ecc_uce_int.configure(this,1,4,"RO",0,32'h0,1,0,0);
        this.mc_ecc_uce_cnt = uvm_reg_field::type_id::create("mc_ecc_uce_cnt",,get_full_name());
        this.mc_ecc_uce_cnt.configure(this,3,8,"RO",0,32'h0,1,0,0);
        this.mc_ecc_uce_int_mask = uvm_reg_field::type_id::create("mc_ecc_uce_int_mask",,get_full_name());
        this.mc_ecc_uce_int_mask.configure(this,1,12,"RW",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_ctrl_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_ctrl_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr0_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_uce_addr0;
    rand uvm_reg_field mc_ecc_uce_addr_vld0;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_uce_addr0_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_uce_addr0 = uvm_reg_field::type_id::create("mc_ecc_uce_addr0",,get_full_name());
        this.mc_ecc_uce_addr0.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_uce_addr_vld0 = uvm_reg_field::type_id::create("mc_ecc_uce_addr_vld0",,get_full_name());
        this.mc_ecc_uce_addr_vld0.configure(this,1,22,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr0_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr0_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr1_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_uce_addr1;
    rand uvm_reg_field mc_ecc_uce_addr_vld1;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_uce_addr1_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_uce_addr1 = uvm_reg_field::type_id::create("mc_ecc_uce_addr1",,get_full_name());
        this.mc_ecc_uce_addr1.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_uce_addr_vld1 = uvm_reg_field::type_id::create("mc_ecc_uce_addr_vld1",,get_full_name());
        this.mc_ecc_uce_addr_vld1.configure(this,1,22,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr1_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr1_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr2_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_uce_addr2;
    rand uvm_reg_field mc_ecc_uce_addr_vld2;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_uce_addr2_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_uce_addr2 = uvm_reg_field::type_id::create("mc_ecc_uce_addr2",,get_full_name());
        this.mc_ecc_uce_addr2.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_uce_addr_vld2 = uvm_reg_field::type_id::create("mc_ecc_uce_addr_vld2",,get_full_name());
        this.mc_ecc_uce_addr_vld2.configure(this,1,22,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr2_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr2_reg

class ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr3_reg extends uvm_reg;
    rand uvm_reg_field mc_ecc_uce_addr3;
    rand uvm_reg_field mc_ecc_uce_addr_vld3;

    function new(string name = "mc_1short2_top_aux_top_mc_ecc_uce_addr3_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_ecc_uce_addr3 = uvm_reg_field::type_id::create("mc_ecc_uce_addr3",,get_full_name());
        this.mc_ecc_uce_addr3.configure(this,22,0,"RO",0,32'h3FFFFF,1,0,0);
        this.mc_ecc_uce_addr_vld3 = uvm_reg_field::type_id::create("mc_ecc_uce_addr_vld3",,get_full_name());
        this.mc_ecc_uce_addr_vld3.configure(this,1,22,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr3_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr3_reg

class ral_reg_mc_1short2_top_aux_top_mc_page_status_reg extends uvm_reg;
    rand uvm_reg_field mc_page_status;

    function new(string name = "mc_1short2_top_aux_top_mc_page_status_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.mc_page_status = uvm_reg_field::type_id::create("mc_page_status",,get_full_name());
        this.mc_page_status.configure(this,1,0,"RO",0,32'h1,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_mc_page_status_reg)
endclass:ral_reg_mc_1short2_top_aux_top_mc_page_status_reg

class ral_reg_mc_1short2_top_aux_top_hang_timeout_status_reg extends uvm_reg;
    rand uvm_reg_field hang_timeout_status;

    function new(string name = "mc_1short2_top_aux_top_hang_timeout_status_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hang_timeout_status = uvm_reg_field::type_id::create("hang_timeout_status",,get_full_name());
        this.hang_timeout_status.configure(this,1,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_hang_timeout_status_reg)
endclass:ral_reg_mc_1short2_top_aux_top_hang_timeout_status_reg

class ral_reg_mc_1short2_top_aux_top_hang_timeout_mask_reg extends uvm_reg;
    rand uvm_reg_field hang_timeout_mask;

    function new(string name = "mc_1short2_top_aux_top_hang_timeout_mask_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hang_timeout_mask = uvm_reg_field::type_id::create("hang_timeout_mask",,get_full_name());
        this.hang_timeout_mask.configure(this,1,0,"RW",0,32'h1,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_hang_timeout_mask_reg)
endclass:ral_reg_mc_1short2_top_aux_top_hang_timeout_mask_reg

class ral_reg_mc_1short2_top_aux_top_hang_timeout_clr_reg extends uvm_reg;
    rand uvm_reg_field hang_timeout_clr;

    function new(string name = "mc_1short2_top_aux_top_hang_timeout_clr_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hang_timeout_clr = uvm_reg_field::type_id::create("hang_timeout_clr",,get_full_name());
        this.hang_timeout_clr.configure(this,1,0,"W1C",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_hang_timeout_clr_reg)
endclass:ral_reg_mc_1short2_top_aux_top_hang_timeout_clr_reg

class ral_reg_mc_1short2_top_aux_top_hang_timeout_en_reg extends uvm_reg;
    rand uvm_reg_field hang_timeout_en;

    function new(string name = "mc_1short2_top_aux_top_hang_timeout_en_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.hang_timeout_en = uvm_reg_field::type_id::create("hang_timeout_en",,get_full_name());
        this.hang_timeout_en.configure(this,1,0,"RW",0,32'h1,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_hang_timeout_en_reg)
endclass:ral_reg_mc_1short2_top_aux_top_hang_timeout_en_reg

class ral_reg_mc_1short2_top_aux_top_bist_clk_cnt_reg extends uvm_reg;
    rand uvm_reg_field bist_clk_cnt;

    function new(string name = "mc_1short2_top_aux_top_bist_clk_cnt_reg");
        super.new(name,32,build_coverage(UVM_NO_COVERAGE));
    endfunction: new
    virtual function void build();
        this.bist_clk_cnt = uvm_reg_field::type_id::create("bist_clk_cnt",,get_full_name());
        this.bist_clk_cnt.configure(this,32,0,"RO",0,32'h0,1,0,0);
    endfunction: build

     `uvm_object_utils(ral_reg_mc_1short2_top_aux_top_bist_clk_cnt_reg)
endclass:ral_reg_mc_1short2_top_aux_top_bist_clk_cnt_reg


class ral_block_mc_1short2_top_aux_top extends uvm_reg_block;

    rand ral_reg_mc_1short2_top_aux_top_mc_id_reg mc_id_reg;
    rand uvm_reg_field mc_id_reg_mc_id;
    rand uvm_reg_field mc_id;
    rand ral_reg_mc_1short2_top_aux_top_mc_work_ctrl_reg mc_work_ctrl_reg;
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
    rand uvm_reg_field mc_work_ctrl_reg_mc_rdata_invert_sel;
    rand uvm_reg_field mc_rdata_invert_sel;
    rand uvm_reg_field mc_work_ctrl_reg_mc_rdrdy_n_en;
    rand uvm_reg_field mc_rdrdy_n_en;
    rand uvm_reg_field mc_work_ctrl_reg_mc_rf_en;
    rand uvm_reg_field mc_rf_en;
    rand uvm_reg_field mc_work_ctrl_reg_mc_rf_burst_split_en;
    rand uvm_reg_field mc_rf_burst_split_en;
    rand uvm_reg_field mc_work_ctrl_reg_mc_fake_bresp_en;
    rand uvm_reg_field mc_fake_bresp_en;
    rand uvm_reg_field mc_work_ctrl_reg_mc_ecc_en;
    rand uvm_reg_field mc_ecc_en;
    rand uvm_reg_field mc_work_ctrl_reg_mc_all_bank_act_en;
    rand uvm_reg_field mc_all_bank_act_en;
    rand uvm_reg_field mc_work_ctrl_reg_mc2phy_dram0_mask;
    rand uvm_reg_field mc2phy_dram0_mask;
    rand uvm_reg_field mc_work_ctrl_reg_mc2phy_dram1_mask;
    rand uvm_reg_field mc2phy_dram1_mask;
    rand uvm_reg_field mc_work_ctrl_reg_mc2phy_dram2_mask;
    rand uvm_reg_field mc2phy_dram2_mask;
    rand uvm_reg_field mc_work_ctrl_reg_mc2phy_dram3_mask;
    rand uvm_reg_field mc2phy_dram3_mask;
    rand ral_reg_mc_1short2_top_aux_top_phy_timing_cfg0_reg phy_timing_cfg0_reg;
    rand uvm_reg_field phy_timing_cfg0_reg_bank_radd_set_time;
    rand uvm_reg_field bank_radd_set_time;
    rand uvm_reg_field phy_timing_cfg0_reg_cadd_set_time;
    rand uvm_reg_field cadd_set_time;
    rand uvm_reg_field phy_timing_cfg0_reg_r_cas_set_time;
    rand uvm_reg_field r_cas_set_time;
    rand uvm_reg_field phy_timing_cfg0_reg_w_cas_set_time;
    rand uvm_reg_field w_cas_set_time;
    rand ral_reg_mc_1short2_top_aux_top_mc_rf_period_cfg1_reg mc_rf_period_cfg1_reg;
    rand uvm_reg_field mc_rf_period_cfg1_reg_mc_rf_period_1;
    rand uvm_reg_field mc_rf_period_1;
    rand ral_reg_mc_1short2_top_aux_top_mc_rf_start_cfg1_reg mc_rf_start_cfg1_reg;
    rand uvm_reg_field mc_rf_start_cfg1_reg_mc_rf_start_1;
    rand uvm_reg_field mc_rf_start_1;
    rand ral_reg_mc_1short2_top_aux_top_mc_rf_period_cfg2_reg mc_rf_period_cfg2_reg;
    rand uvm_reg_field mc_rf_period_cfg2_reg_mc_rf_period_2;
    rand uvm_reg_field mc_rf_period_2;
    rand ral_reg_mc_1short2_top_aux_top_mc_rf_start_cfg2_reg mc_rf_start_cfg2_reg;
    rand uvm_reg_field mc_rf_start_cfg2_reg_mc_rf_start_2;
    rand uvm_reg_field mc_rf_start_2;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num0_1_bank0_reg mc_vmc_wl_num0_1_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num0_1_bank0_reg_mc_vmc_wl_num0_bank0;
    rand uvm_reg_field mc_vmc_wl_num0_bank0;
    rand uvm_reg_field mc_vmc_wl_num0_1_bank0_reg_mc_vmc_wl_num1_bank0;
    rand uvm_reg_field mc_vmc_wl_num1_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num2_3_bank0_reg mc_vmc_wl_num2_3_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num2_3_bank0_reg_mc_vmc_wl_num2_bank0;
    rand uvm_reg_field mc_vmc_wl_num2_bank0;
    rand uvm_reg_field mc_vmc_wl_num2_3_bank0_reg_mc_vmc_wl_num3_bank0;
    rand uvm_reg_field mc_vmc_wl_num3_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num4_5_bank0_reg mc_vmc_wl_num4_5_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num4_5_bank0_reg_mc_vmc_wl_num4_bank0;
    rand uvm_reg_field mc_vmc_wl_num4_bank0;
    rand uvm_reg_field mc_vmc_wl_num4_5_bank0_reg_mc_vmc_wl_num5_bank0;
    rand uvm_reg_field mc_vmc_wl_num5_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num6_7_bank0_reg mc_vmc_wl_num6_7_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num6_7_bank0_reg_mc_vmc_wl_num6_bank0;
    rand uvm_reg_field mc_vmc_wl_num6_bank0;
    rand uvm_reg_field mc_vmc_wl_num6_7_bank0_reg_mc_vmc_wl_num7_bank0;
    rand uvm_reg_field mc_vmc_wl_num7_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num8_9_bank0_reg mc_vmc_wl_num8_9_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num8_9_bank0_reg_mc_vmc_wl_num8_bank0;
    rand uvm_reg_field mc_vmc_wl_num8_bank0;
    rand uvm_reg_field mc_vmc_wl_num8_9_bank0_reg_mc_vmc_wl_num9_bank0;
    rand uvm_reg_field mc_vmc_wl_num9_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num10_11_bank0_reg mc_vmc_wl_num10_11_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num10_11_bank0_reg_mc_vmc_wl_num10_bank0;
    rand uvm_reg_field mc_vmc_wl_num10_bank0;
    rand uvm_reg_field mc_vmc_wl_num10_11_bank0_reg_mc_vmc_wl_num11_bank0;
    rand uvm_reg_field mc_vmc_wl_num11_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num12_13_bank0_reg mc_vmc_wl_num12_13_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num12_13_bank0_reg_mc_vmc_wl_num12_bank0;
    rand uvm_reg_field mc_vmc_wl_num12_bank0;
    rand uvm_reg_field mc_vmc_wl_num12_13_bank0_reg_mc_vmc_wl_num13_bank0;
    rand uvm_reg_field mc_vmc_wl_num13_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num14_15_bank0_reg mc_vmc_wl_num14_15_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num14_15_bank0_reg_mc_vmc_wl_num14_bank0;
    rand uvm_reg_field mc_vmc_wl_num14_bank0;
    rand uvm_reg_field mc_vmc_wl_num14_15_bank0_reg_mc_vmc_wl_num15_bank0;
    rand uvm_reg_field mc_vmc_wl_num15_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num16_17_bank0_reg mc_vmc_wl_num16_17_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num16_17_bank0_reg_mc_vmc_wl_num16_bank0;
    rand uvm_reg_field mc_vmc_wl_num16_bank0;
    rand uvm_reg_field mc_vmc_wl_num16_17_bank0_reg_mc_vmc_wl_num17_bank0;
    rand uvm_reg_field mc_vmc_wl_num17_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num18_19_bank0_reg mc_vmc_wl_num18_19_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num18_19_bank0_reg_mc_vmc_wl_num18_bank0;
    rand uvm_reg_field mc_vmc_wl_num18_bank0;
    rand uvm_reg_field mc_vmc_wl_num18_19_bank0_reg_mc_vmc_wl_num19_bank0;
    rand uvm_reg_field mc_vmc_wl_num19_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num20_21_bank0_reg mc_vmc_wl_num20_21_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num20_21_bank0_reg_mc_vmc_wl_num20_bank0;
    rand uvm_reg_field mc_vmc_wl_num20_bank0;
    rand uvm_reg_field mc_vmc_wl_num20_21_bank0_reg_mc_vmc_wl_num21_bank0;
    rand uvm_reg_field mc_vmc_wl_num21_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num22_23_bank0_reg mc_vmc_wl_num22_23_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num22_23_bank0_reg_mc_vmc_wl_num22_bank0;
    rand uvm_reg_field mc_vmc_wl_num22_bank0;
    rand uvm_reg_field mc_vmc_wl_num22_23_bank0_reg_mc_vmc_wl_num23_bank0;
    rand uvm_reg_field mc_vmc_wl_num23_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num24_25_bank0_reg mc_vmc_wl_num24_25_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num24_25_bank0_reg_mc_vmc_wl_num24_bank0;
    rand uvm_reg_field mc_vmc_wl_num24_bank0;
    rand uvm_reg_field mc_vmc_wl_num24_25_bank0_reg_mc_vmc_wl_num25_bank0;
    rand uvm_reg_field mc_vmc_wl_num25_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num26_27_bank0_reg mc_vmc_wl_num26_27_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num26_27_bank0_reg_mc_vmc_wl_num26_bank0;
    rand uvm_reg_field mc_vmc_wl_num26_bank0;
    rand uvm_reg_field mc_vmc_wl_num26_27_bank0_reg_mc_vmc_wl_num27_bank0;
    rand uvm_reg_field mc_vmc_wl_num27_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num28_29_bank0_reg mc_vmc_wl_num28_29_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num28_29_bank0_reg_mc_vmc_wl_num28_bank0;
    rand uvm_reg_field mc_vmc_wl_num28_bank0;
    rand uvm_reg_field mc_vmc_wl_num28_29_bank0_reg_mc_vmc_wl_num29_bank0;
    rand uvm_reg_field mc_vmc_wl_num29_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num30_31_bank0_reg mc_vmc_wl_num30_31_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num30_31_bank0_reg_mc_vmc_wl_num30_bank0;
    rand uvm_reg_field mc_vmc_wl_num30_bank0;
    rand uvm_reg_field mc_vmc_wl_num30_31_bank0_reg_mc_vmc_wl_num31_bank0;
    rand uvm_reg_field mc_vmc_wl_num31_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num32_33_bank0_reg mc_vmc_wl_num32_33_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num32_33_bank0_reg_mc_vmc_wl_num32_bank0;
    rand uvm_reg_field mc_vmc_wl_num32_bank0;
    rand uvm_reg_field mc_vmc_wl_num32_33_bank0_reg_mc_vmc_wl_num33_bank0;
    rand uvm_reg_field mc_vmc_wl_num33_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num34_35_bank0_reg mc_vmc_wl_num34_35_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num34_35_bank0_reg_mc_vmc_wl_num34_bank0;
    rand uvm_reg_field mc_vmc_wl_num34_bank0;
    rand uvm_reg_field mc_vmc_wl_num34_35_bank0_reg_mc_vmc_wl_num35_bank0;
    rand uvm_reg_field mc_vmc_wl_num35_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num36_37_bank0_reg mc_vmc_wl_num36_37_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num36_37_bank0_reg_mc_vmc_wl_num36_bank0;
    rand uvm_reg_field mc_vmc_wl_num36_bank0;
    rand uvm_reg_field mc_vmc_wl_num36_37_bank0_reg_mc_vmc_wl_num37_bank0;
    rand uvm_reg_field mc_vmc_wl_num37_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num38_39_bank0_reg mc_vmc_wl_num38_39_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num38_39_bank0_reg_mc_vmc_wl_num38_bank0;
    rand uvm_reg_field mc_vmc_wl_num38_bank0;
    rand uvm_reg_field mc_vmc_wl_num38_39_bank0_reg_mc_vmc_wl_num39_bank0;
    rand uvm_reg_field mc_vmc_wl_num39_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num40_41_bank0_reg mc_vmc_wl_num40_41_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num40_41_bank0_reg_mc_vmc_wl_num40_bank0;
    rand uvm_reg_field mc_vmc_wl_num40_bank0;
    rand uvm_reg_field mc_vmc_wl_num40_41_bank0_reg_mc_vmc_wl_num41_bank0;
    rand uvm_reg_field mc_vmc_wl_num41_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num42_43_bank0_reg mc_vmc_wl_num42_43_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num42_43_bank0_reg_mc_vmc_wl_num42_bank0;
    rand uvm_reg_field mc_vmc_wl_num42_bank0;
    rand uvm_reg_field mc_vmc_wl_num42_43_bank0_reg_mc_vmc_wl_num43_bank0;
    rand uvm_reg_field mc_vmc_wl_num43_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num44_45_bank0_reg mc_vmc_wl_num44_45_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num44_45_bank0_reg_mc_vmc_wl_num44_bank0;
    rand uvm_reg_field mc_vmc_wl_num44_bank0;
    rand uvm_reg_field mc_vmc_wl_num44_45_bank0_reg_mc_vmc_wl_num45_bank0;
    rand uvm_reg_field mc_vmc_wl_num45_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num46_47_bank0_reg mc_vmc_wl_num46_47_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num46_47_bank0_reg_mc_vmc_wl_num46_bank0;
    rand uvm_reg_field mc_vmc_wl_num46_bank0;
    rand uvm_reg_field mc_vmc_wl_num46_47_bank0_reg_mc_vmc_wl_num47_bank0;
    rand uvm_reg_field mc_vmc_wl_num47_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num48_49_bank0_reg mc_vmc_wl_num48_49_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num48_49_bank0_reg_mc_vmc_wl_num48_bank0;
    rand uvm_reg_field mc_vmc_wl_num48_bank0;
    rand uvm_reg_field mc_vmc_wl_num48_49_bank0_reg_mc_vmc_wl_num49_bank0;
    rand uvm_reg_field mc_vmc_wl_num49_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num50_51_bank0_reg mc_vmc_wl_num50_51_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num50_51_bank0_reg_mc_vmc_wl_num50_bank0;
    rand uvm_reg_field mc_vmc_wl_num50_bank0;
    rand uvm_reg_field mc_vmc_wl_num50_51_bank0_reg_mc_vmc_wl_num51_bank0;
    rand uvm_reg_field mc_vmc_wl_num51_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num52_53_bank0_reg mc_vmc_wl_num52_53_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num52_53_bank0_reg_mc_vmc_wl_num52_bank0;
    rand uvm_reg_field mc_vmc_wl_num52_bank0;
    rand uvm_reg_field mc_vmc_wl_num52_53_bank0_reg_mc_vmc_wl_num53_bank0;
    rand uvm_reg_field mc_vmc_wl_num53_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num54_55_bank0_reg mc_vmc_wl_num54_55_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num54_55_bank0_reg_mc_vmc_wl_num54_bank0;
    rand uvm_reg_field mc_vmc_wl_num54_bank0;
    rand uvm_reg_field mc_vmc_wl_num54_55_bank0_reg_mc_vmc_wl_num55_bank0;
    rand uvm_reg_field mc_vmc_wl_num55_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num56_57_bank0_reg mc_vmc_wl_num56_57_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num56_57_bank0_reg_mc_vmc_wl_num56_bank0;
    rand uvm_reg_field mc_vmc_wl_num56_bank0;
    rand uvm_reg_field mc_vmc_wl_num56_57_bank0_reg_mc_vmc_wl_num57_bank0;
    rand uvm_reg_field mc_vmc_wl_num57_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num58_59_bank0_reg mc_vmc_wl_num58_59_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num58_59_bank0_reg_mc_vmc_wl_num58_bank0;
    rand uvm_reg_field mc_vmc_wl_num58_bank0;
    rand uvm_reg_field mc_vmc_wl_num58_59_bank0_reg_mc_vmc_wl_num59_bank0;
    rand uvm_reg_field mc_vmc_wl_num59_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num60_61_bank0_reg mc_vmc_wl_num60_61_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num60_61_bank0_reg_mc_vmc_wl_num60_bank0;
    rand uvm_reg_field mc_vmc_wl_num60_bank0;
    rand uvm_reg_field mc_vmc_wl_num60_61_bank0_reg_mc_vmc_wl_num61_bank0;
    rand uvm_reg_field mc_vmc_wl_num61_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num62_63_bank0_reg mc_vmc_wl_num62_63_bank0_reg;
    rand uvm_reg_field mc_vmc_wl_num62_63_bank0_reg_mc_vmc_wl_num62_bank0;
    rand uvm_reg_field mc_vmc_wl_num62_bank0;
    rand uvm_reg_field mc_vmc_wl_num62_63_bank0_reg_mc_vmc_wl_num63_bank0;
    rand uvm_reg_field mc_vmc_wl_num63_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part0_1_bank0_reg mc_vmc_bl_num0_part0_1_bank0_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part0_1_bank0_reg_mc_vmc_bl_num0_part0_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part0_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part0_1_bank0_reg_mc_vmc_bl_num1_part0_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part0_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part0_1_bank0_reg_mc_vmc_bl_num0_part1_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part1_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part0_1_bank0_reg_mc_vmc_bl_num1_part1_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part1_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part2_3_bank0_reg mc_vmc_bl_num0_part2_3_bank0_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part2_3_bank0_reg_mc_vmc_bl_num0_part2_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part2_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part2_3_bank0_reg_mc_vmc_bl_num1_part2_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part2_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part2_3_bank0_reg_mc_vmc_bl_num0_part3_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part3_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part2_3_bank0_reg_mc_vmc_bl_num1_part3_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part3_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part4_5_bank0_reg mc_vmc_bl_num0_part4_5_bank0_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part4_5_bank0_reg_mc_vmc_bl_num0_part4_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part4_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part4_5_bank0_reg_mc_vmc_bl_num1_part4_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part4_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part4_5_bank0_reg_mc_vmc_bl_num0_part5_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part5_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part4_5_bank0_reg_mc_vmc_bl_num1_part5_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part5_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part6_7_bank0_reg mc_vmc_bl_num0_part6_7_bank0_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part6_7_bank0_reg_mc_vmc_bl_num0_part6_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part6_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part6_7_bank0_reg_mc_vmc_bl_num1_part6_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part6_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part6_7_bank0_reg_mc_vmc_bl_num0_part7_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part7_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part6_7_bank0_reg_mc_vmc_bl_num1_part7_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part7_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part8_9_bank0_reg mc_vmc_bl_num0_part8_9_bank0_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part8_9_bank0_reg_mc_vmc_bl_num0_part8_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part8_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part8_9_bank0_reg_mc_vmc_bl_num1_part8_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part8_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part8_9_bank0_reg_mc_vmc_bl_num0_part9_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part9_bank0;
    rand uvm_reg_field mc_vmc_bl_num0_part8_9_bank0_reg_mc_vmc_bl_num1_part9_bank0;
    rand uvm_reg_field mc_vmc_bl_num1_part9_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl0_1_bank0_reg err_wl0_1_bank0_reg;
    rand uvm_reg_field err_wl0_1_bank0_reg_err_wl0_bank0;
    rand uvm_reg_field err_wl0_bank0;
    rand uvm_reg_field err_wl0_1_bank0_reg_err_wl1_bank0;
    rand uvm_reg_field err_wl1_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl2_3_bank0_reg err_wl2_3_bank0_reg;
    rand uvm_reg_field err_wl2_3_bank0_reg_err_wl2_bank0;
    rand uvm_reg_field err_wl2_bank0;
    rand uvm_reg_field err_wl2_3_bank0_reg_err_wl3_bank0;
    rand uvm_reg_field err_wl3_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl4_5_bank0_reg err_wl4_5_bank0_reg;
    rand uvm_reg_field err_wl4_5_bank0_reg_err_wl4_bank0;
    rand uvm_reg_field err_wl4_bank0;
    rand uvm_reg_field err_wl4_5_bank0_reg_err_wl5_bank0;
    rand uvm_reg_field err_wl5_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl6_7_bank0_reg err_wl6_7_bank0_reg;
    rand uvm_reg_field err_wl6_7_bank0_reg_err_wl6_bank0;
    rand uvm_reg_field err_wl6_bank0;
    rand uvm_reg_field err_wl6_7_bank0_reg_err_wl7_bank0;
    rand uvm_reg_field err_wl7_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl8_9_bank0_reg err_wl8_9_bank0_reg;
    rand uvm_reg_field err_wl8_9_bank0_reg_err_wl8_bank0;
    rand uvm_reg_field err_wl8_bank0;
    rand uvm_reg_field err_wl8_9_bank0_reg_err_wl9_bank0;
    rand uvm_reg_field err_wl9_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl10_11_bank0_reg err_wl10_11_bank0_reg;
    rand uvm_reg_field err_wl10_11_bank0_reg_err_wl10_bank0;
    rand uvm_reg_field err_wl10_bank0;
    rand uvm_reg_field err_wl10_11_bank0_reg_err_wl11_bank0;
    rand uvm_reg_field err_wl11_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl12_13_bank0_reg err_wl12_13_bank0_reg;
    rand uvm_reg_field err_wl12_13_bank0_reg_err_wl12_bank0;
    rand uvm_reg_field err_wl12_bank0;
    rand uvm_reg_field err_wl12_13_bank0_reg_err_wl13_bank0;
    rand uvm_reg_field err_wl13_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl14_15_bank0_reg err_wl14_15_bank0_reg;
    rand uvm_reg_field err_wl14_15_bank0_reg_err_wl14_bank0;
    rand uvm_reg_field err_wl14_bank0;
    rand uvm_reg_field err_wl14_15_bank0_reg_err_wl15_bank0;
    rand uvm_reg_field err_wl15_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl16_17_bank0_reg err_wl16_17_bank0_reg;
    rand uvm_reg_field err_wl16_17_bank0_reg_err_wl16_bank0;
    rand uvm_reg_field err_wl16_bank0;
    rand uvm_reg_field err_wl16_17_bank0_reg_err_wl17_bank0;
    rand uvm_reg_field err_wl17_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl18_19_bank0_reg err_wl18_19_bank0_reg;
    rand uvm_reg_field err_wl18_19_bank0_reg_err_wl18_bank0;
    rand uvm_reg_field err_wl18_bank0;
    rand uvm_reg_field err_wl18_19_bank0_reg_err_wl19_bank0;
    rand uvm_reg_field err_wl19_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl20_21_bank0_reg err_wl20_21_bank0_reg;
    rand uvm_reg_field err_wl20_21_bank0_reg_err_wl20_bank0;
    rand uvm_reg_field err_wl20_bank0;
    rand uvm_reg_field err_wl20_21_bank0_reg_err_wl21_bank0;
    rand uvm_reg_field err_wl21_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl22_23_bank0_reg err_wl22_23_bank0_reg;
    rand uvm_reg_field err_wl22_23_bank0_reg_err_wl22_bank0;
    rand uvm_reg_field err_wl22_bank0;
    rand uvm_reg_field err_wl22_23_bank0_reg_err_wl23_bank0;
    rand uvm_reg_field err_wl23_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl24_25_bank0_reg err_wl24_25_bank0_reg;
    rand uvm_reg_field err_wl24_25_bank0_reg_err_wl24_bank0;
    rand uvm_reg_field err_wl24_bank0;
    rand uvm_reg_field err_wl24_25_bank0_reg_err_wl25_bank0;
    rand uvm_reg_field err_wl25_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl26_27_bank0_reg err_wl26_27_bank0_reg;
    rand uvm_reg_field err_wl26_27_bank0_reg_err_wl26_bank0;
    rand uvm_reg_field err_wl26_bank0;
    rand uvm_reg_field err_wl26_27_bank0_reg_err_wl27_bank0;
    rand uvm_reg_field err_wl27_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl28_29_bank0_reg err_wl28_29_bank0_reg;
    rand uvm_reg_field err_wl28_29_bank0_reg_err_wl28_bank0;
    rand uvm_reg_field err_wl28_bank0;
    rand uvm_reg_field err_wl28_29_bank0_reg_err_wl29_bank0;
    rand uvm_reg_field err_wl29_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl30_31_bank0_reg err_wl30_31_bank0_reg;
    rand uvm_reg_field err_wl30_31_bank0_reg_err_wl30_bank0;
    rand uvm_reg_field err_wl30_bank0;
    rand uvm_reg_field err_wl30_31_bank0_reg_err_wl31_bank0;
    rand uvm_reg_field err_wl31_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl32_33_bank0_reg err_wl32_33_bank0_reg;
    rand uvm_reg_field err_wl32_33_bank0_reg_err_wl32_bank0;
    rand uvm_reg_field err_wl32_bank0;
    rand uvm_reg_field err_wl32_33_bank0_reg_err_wl33_bank0;
    rand uvm_reg_field err_wl33_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl34_35_bank0_reg err_wl34_35_bank0_reg;
    rand uvm_reg_field err_wl34_35_bank0_reg_err_wl34_bank0;
    rand uvm_reg_field err_wl34_bank0;
    rand uvm_reg_field err_wl34_35_bank0_reg_err_wl35_bank0;
    rand uvm_reg_field err_wl35_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl36_37_bank0_reg err_wl36_37_bank0_reg;
    rand uvm_reg_field err_wl36_37_bank0_reg_err_wl36_bank0;
    rand uvm_reg_field err_wl36_bank0;
    rand uvm_reg_field err_wl36_37_bank0_reg_err_wl37_bank0;
    rand uvm_reg_field err_wl37_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl38_39_bank0_reg err_wl38_39_bank0_reg;
    rand uvm_reg_field err_wl38_39_bank0_reg_err_wl38_bank0;
    rand uvm_reg_field err_wl38_bank0;
    rand uvm_reg_field err_wl38_39_bank0_reg_err_wl39_bank0;
    rand uvm_reg_field err_wl39_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl40_41_bank0_reg err_wl40_41_bank0_reg;
    rand uvm_reg_field err_wl40_41_bank0_reg_err_wl40_bank0;
    rand uvm_reg_field err_wl40_bank0;
    rand uvm_reg_field err_wl40_41_bank0_reg_err_wl41_bank0;
    rand uvm_reg_field err_wl41_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl42_43_bank0_reg err_wl42_43_bank0_reg;
    rand uvm_reg_field err_wl42_43_bank0_reg_err_wl42_bank0;
    rand uvm_reg_field err_wl42_bank0;
    rand uvm_reg_field err_wl42_43_bank0_reg_err_wl43_bank0;
    rand uvm_reg_field err_wl43_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl44_45_bank0_reg err_wl44_45_bank0_reg;
    rand uvm_reg_field err_wl44_45_bank0_reg_err_wl44_bank0;
    rand uvm_reg_field err_wl44_bank0;
    rand uvm_reg_field err_wl44_45_bank0_reg_err_wl45_bank0;
    rand uvm_reg_field err_wl45_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl46_47_bank0_reg err_wl46_47_bank0_reg;
    rand uvm_reg_field err_wl46_47_bank0_reg_err_wl46_bank0;
    rand uvm_reg_field err_wl46_bank0;
    rand uvm_reg_field err_wl46_47_bank0_reg_err_wl47_bank0;
    rand uvm_reg_field err_wl47_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl48_49_bank0_reg err_wl48_49_bank0_reg;
    rand uvm_reg_field err_wl48_49_bank0_reg_err_wl48_bank0;
    rand uvm_reg_field err_wl48_bank0;
    rand uvm_reg_field err_wl48_49_bank0_reg_err_wl49_bank0;
    rand uvm_reg_field err_wl49_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl50_51_bank0_reg err_wl50_51_bank0_reg;
    rand uvm_reg_field err_wl50_51_bank0_reg_err_wl50_bank0;
    rand uvm_reg_field err_wl50_bank0;
    rand uvm_reg_field err_wl50_51_bank0_reg_err_wl51_bank0;
    rand uvm_reg_field err_wl51_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl52_53_bank0_reg err_wl52_53_bank0_reg;
    rand uvm_reg_field err_wl52_53_bank0_reg_err_wl52_bank0;
    rand uvm_reg_field err_wl52_bank0;
    rand uvm_reg_field err_wl52_53_bank0_reg_err_wl53_bank0;
    rand uvm_reg_field err_wl53_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl54_55_bank0_reg err_wl54_55_bank0_reg;
    rand uvm_reg_field err_wl54_55_bank0_reg_err_wl54_bank0;
    rand uvm_reg_field err_wl54_bank0;
    rand uvm_reg_field err_wl54_55_bank0_reg_err_wl55_bank0;
    rand uvm_reg_field err_wl55_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl56_57_bank0_reg err_wl56_57_bank0_reg;
    rand uvm_reg_field err_wl56_57_bank0_reg_err_wl56_bank0;
    rand uvm_reg_field err_wl56_bank0;
    rand uvm_reg_field err_wl56_57_bank0_reg_err_wl57_bank0;
    rand uvm_reg_field err_wl57_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl58_59_bank0_reg err_wl58_59_bank0_reg;
    rand uvm_reg_field err_wl58_59_bank0_reg_err_wl58_bank0;
    rand uvm_reg_field err_wl58_bank0;
    rand uvm_reg_field err_wl58_59_bank0_reg_err_wl59_bank0;
    rand uvm_reg_field err_wl59_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl60_61_bank0_reg err_wl60_61_bank0_reg;
    rand uvm_reg_field err_wl60_61_bank0_reg_err_wl60_bank0;
    rand uvm_reg_field err_wl60_bank0;
    rand uvm_reg_field err_wl60_61_bank0_reg_err_wl61_bank0;
    rand uvm_reg_field err_wl61_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_wl62_63_bank0_reg err_wl62_63_bank0_reg;
    rand uvm_reg_field err_wl62_63_bank0_reg_err_wl62_bank0;
    rand uvm_reg_field err_wl62_bank0;
    rand uvm_reg_field err_wl62_63_bank0_reg_err_wl63_bank0;
    rand uvm_reg_field err_wl63_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_csl_part0_1_bank0_reg err_csl_part0_1_bank0_reg;
    rand uvm_reg_field err_csl_part0_1_bank0_reg_err_csl0_part0_bank0;
    rand uvm_reg_field err_csl0_part0_bank0;
    rand uvm_reg_field err_csl_part0_1_bank0_reg_err_csl1_part0_bank0;
    rand uvm_reg_field err_csl1_part0_bank0;
    rand uvm_reg_field err_csl_part0_1_bank0_reg_err_csl0_part1_bank0;
    rand uvm_reg_field err_csl0_part1_bank0;
    rand uvm_reg_field err_csl_part0_1_bank0_reg_err_csl1_part1_bank0;
    rand uvm_reg_field err_csl1_part1_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_csl_part2_3_bank0_reg err_csl_part2_3_bank0_reg;
    rand uvm_reg_field err_csl_part2_3_bank0_reg_err_csl0_part2_bank0;
    rand uvm_reg_field err_csl0_part2_bank0;
    rand uvm_reg_field err_csl_part2_3_bank0_reg_err_csl1_part2_bank0;
    rand uvm_reg_field err_csl1_part2_bank0;
    rand uvm_reg_field err_csl_part2_3_bank0_reg_err_csl0_part3_bank0;
    rand uvm_reg_field err_csl0_part3_bank0;
    rand uvm_reg_field err_csl_part2_3_bank0_reg_err_csl1_part3_bank0;
    rand uvm_reg_field err_csl1_part3_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_csl_part4_5_bank0_reg err_csl_part4_5_bank0_reg;
    rand uvm_reg_field err_csl_part4_5_bank0_reg_err_csl0_part4_bank0;
    rand uvm_reg_field err_csl0_part4_bank0;
    rand uvm_reg_field err_csl_part4_5_bank0_reg_err_csl1_part4_bank0;
    rand uvm_reg_field err_csl1_part4_bank0;
    rand uvm_reg_field err_csl_part4_5_bank0_reg_err_csl0_part5_bank0;
    rand uvm_reg_field err_csl0_part5_bank0;
    rand uvm_reg_field err_csl_part4_5_bank0_reg_err_csl1_part5_bank0;
    rand uvm_reg_field err_csl1_part5_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_csl_part6_7_bank0_reg err_csl_part6_7_bank0_reg;
    rand uvm_reg_field err_csl_part6_7_bank0_reg_err_csl0_part6_bank0;
    rand uvm_reg_field err_csl0_part6_bank0;
    rand uvm_reg_field err_csl_part6_7_bank0_reg_err_csl1_part6_bank0;
    rand uvm_reg_field err_csl1_part6_bank0;
    rand uvm_reg_field err_csl_part6_7_bank0_reg_err_csl0_part7_bank0;
    rand uvm_reg_field err_csl0_part7_bank0;
    rand uvm_reg_field err_csl_part6_7_bank0_reg_err_csl1_part7_bank0;
    rand uvm_reg_field err_csl1_part7_bank0;
    rand ral_reg_mc_1short2_top_aux_top_err_csl_part8_9_bank0_reg err_csl_part8_9_bank0_reg;
    rand uvm_reg_field err_csl_part8_9_bank0_reg_err_csl0_part8_bank0;
    rand uvm_reg_field err_csl0_part8_bank0;
    rand uvm_reg_field err_csl_part8_9_bank0_reg_err_csl1_part8_bank0;
    rand uvm_reg_field err_csl1_part8_bank0;
    rand uvm_reg_field err_csl_part8_9_bank0_reg_err_csl0_part9_bank0;
    rand uvm_reg_field err_csl0_part9_bank0;
    rand uvm_reg_field err_csl_part8_9_bank0_reg_err_csl1_part9_bank0;
    rand uvm_reg_field err_csl1_part9_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num0_1_bank1_reg mc_vmc_wl_num0_1_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num0_1_bank1_reg_mc_vmc_wl_num0_bank1;
    rand uvm_reg_field mc_vmc_wl_num0_bank1;
    rand uvm_reg_field mc_vmc_wl_num0_1_bank1_reg_mc_vmc_wl_num1_bank1;
    rand uvm_reg_field mc_vmc_wl_num1_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num2_3_bank1_reg mc_vmc_wl_num2_3_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num2_3_bank1_reg_mc_vmc_wl_num2_bank1;
    rand uvm_reg_field mc_vmc_wl_num2_bank1;
    rand uvm_reg_field mc_vmc_wl_num2_3_bank1_reg_mc_vmc_wl_num3_bank1;
    rand uvm_reg_field mc_vmc_wl_num3_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num4_5_bank1_reg mc_vmc_wl_num4_5_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num4_5_bank1_reg_mc_vmc_wl_num4_bank1;
    rand uvm_reg_field mc_vmc_wl_num4_bank1;
    rand uvm_reg_field mc_vmc_wl_num4_5_bank1_reg_mc_vmc_wl_num5_bank1;
    rand uvm_reg_field mc_vmc_wl_num5_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num6_7_bank1_reg mc_vmc_wl_num6_7_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num6_7_bank1_reg_mc_vmc_wl_num6_bank1;
    rand uvm_reg_field mc_vmc_wl_num6_bank1;
    rand uvm_reg_field mc_vmc_wl_num6_7_bank1_reg_mc_vmc_wl_num7_bank1;
    rand uvm_reg_field mc_vmc_wl_num7_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num8_9_bank1_reg mc_vmc_wl_num8_9_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num8_9_bank1_reg_mc_vmc_wl_num8_bank1;
    rand uvm_reg_field mc_vmc_wl_num8_bank1;
    rand uvm_reg_field mc_vmc_wl_num8_9_bank1_reg_mc_vmc_wl_num9_bank1;
    rand uvm_reg_field mc_vmc_wl_num9_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num10_11_bank1_reg mc_vmc_wl_num10_11_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num10_11_bank1_reg_mc_vmc_wl_num10_bank1;
    rand uvm_reg_field mc_vmc_wl_num10_bank1;
    rand uvm_reg_field mc_vmc_wl_num10_11_bank1_reg_mc_vmc_wl_num11_bank1;
    rand uvm_reg_field mc_vmc_wl_num11_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num12_13_bank1_reg mc_vmc_wl_num12_13_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num12_13_bank1_reg_mc_vmc_wl_num12_bank1;
    rand uvm_reg_field mc_vmc_wl_num12_bank1;
    rand uvm_reg_field mc_vmc_wl_num12_13_bank1_reg_mc_vmc_wl_num13_bank1;
    rand uvm_reg_field mc_vmc_wl_num13_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num14_15_bank1_reg mc_vmc_wl_num14_15_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num14_15_bank1_reg_mc_vmc_wl_num14_bank1;
    rand uvm_reg_field mc_vmc_wl_num14_bank1;
    rand uvm_reg_field mc_vmc_wl_num14_15_bank1_reg_mc_vmc_wl_num15_bank1;
    rand uvm_reg_field mc_vmc_wl_num15_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num16_17_bank1_reg mc_vmc_wl_num16_17_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num16_17_bank1_reg_mc_vmc_wl_num16_bank1;
    rand uvm_reg_field mc_vmc_wl_num16_bank1;
    rand uvm_reg_field mc_vmc_wl_num16_17_bank1_reg_mc_vmc_wl_num17_bank1;
    rand uvm_reg_field mc_vmc_wl_num17_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num18_19_bank1_reg mc_vmc_wl_num18_19_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num18_19_bank1_reg_mc_vmc_wl_num18_bank1;
    rand uvm_reg_field mc_vmc_wl_num18_bank1;
    rand uvm_reg_field mc_vmc_wl_num18_19_bank1_reg_mc_vmc_wl_num19_bank1;
    rand uvm_reg_field mc_vmc_wl_num19_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num20_21_bank1_reg mc_vmc_wl_num20_21_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num20_21_bank1_reg_mc_vmc_wl_num20_bank1;
    rand uvm_reg_field mc_vmc_wl_num20_bank1;
    rand uvm_reg_field mc_vmc_wl_num20_21_bank1_reg_mc_vmc_wl_num21_bank1;
    rand uvm_reg_field mc_vmc_wl_num21_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num22_23_bank1_reg mc_vmc_wl_num22_23_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num22_23_bank1_reg_mc_vmc_wl_num22_bank1;
    rand uvm_reg_field mc_vmc_wl_num22_bank1;
    rand uvm_reg_field mc_vmc_wl_num22_23_bank1_reg_mc_vmc_wl_num23_bank1;
    rand uvm_reg_field mc_vmc_wl_num23_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num24_25_bank1_reg mc_vmc_wl_num24_25_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num24_25_bank1_reg_mc_vmc_wl_num24_bank1;
    rand uvm_reg_field mc_vmc_wl_num24_bank1;
    rand uvm_reg_field mc_vmc_wl_num24_25_bank1_reg_mc_vmc_wl_num25_bank1;
    rand uvm_reg_field mc_vmc_wl_num25_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num26_27_bank1_reg mc_vmc_wl_num26_27_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num26_27_bank1_reg_mc_vmc_wl_num26_bank1;
    rand uvm_reg_field mc_vmc_wl_num26_bank1;
    rand uvm_reg_field mc_vmc_wl_num26_27_bank1_reg_mc_vmc_wl_num27_bank1;
    rand uvm_reg_field mc_vmc_wl_num27_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num28_29_bank1_reg mc_vmc_wl_num28_29_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num28_29_bank1_reg_mc_vmc_wl_num28_bank1;
    rand uvm_reg_field mc_vmc_wl_num28_bank1;
    rand uvm_reg_field mc_vmc_wl_num28_29_bank1_reg_mc_vmc_wl_num29_bank1;
    rand uvm_reg_field mc_vmc_wl_num29_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num30_31_bank1_reg mc_vmc_wl_num30_31_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num30_31_bank1_reg_mc_vmc_wl_num30_bank1;
    rand uvm_reg_field mc_vmc_wl_num30_bank1;
    rand uvm_reg_field mc_vmc_wl_num30_31_bank1_reg_mc_vmc_wl_num31_bank1;
    rand uvm_reg_field mc_vmc_wl_num31_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num32_33_bank1_reg mc_vmc_wl_num32_33_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num32_33_bank1_reg_mc_vmc_wl_num32_bank1;
    rand uvm_reg_field mc_vmc_wl_num32_bank1;
    rand uvm_reg_field mc_vmc_wl_num32_33_bank1_reg_mc_vmc_wl_num33_bank1;
    rand uvm_reg_field mc_vmc_wl_num33_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num34_35_bank1_reg mc_vmc_wl_num34_35_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num34_35_bank1_reg_mc_vmc_wl_num34_bank1;
    rand uvm_reg_field mc_vmc_wl_num34_bank1;
    rand uvm_reg_field mc_vmc_wl_num34_35_bank1_reg_mc_vmc_wl_num35_bank1;
    rand uvm_reg_field mc_vmc_wl_num35_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num36_37_bank1_reg mc_vmc_wl_num36_37_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num36_37_bank1_reg_mc_vmc_wl_num36_bank1;
    rand uvm_reg_field mc_vmc_wl_num36_bank1;
    rand uvm_reg_field mc_vmc_wl_num36_37_bank1_reg_mc_vmc_wl_num37_bank1;
    rand uvm_reg_field mc_vmc_wl_num37_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num38_39_bank1_reg mc_vmc_wl_num38_39_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num38_39_bank1_reg_mc_vmc_wl_num38_bank1;
    rand uvm_reg_field mc_vmc_wl_num38_bank1;
    rand uvm_reg_field mc_vmc_wl_num38_39_bank1_reg_mc_vmc_wl_num39_bank1;
    rand uvm_reg_field mc_vmc_wl_num39_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num40_41_bank1_reg mc_vmc_wl_num40_41_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num40_41_bank1_reg_mc_vmc_wl_num40_bank1;
    rand uvm_reg_field mc_vmc_wl_num40_bank1;
    rand uvm_reg_field mc_vmc_wl_num40_41_bank1_reg_mc_vmc_wl_num41_bank1;
    rand uvm_reg_field mc_vmc_wl_num41_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num42_43_bank1_reg mc_vmc_wl_num42_43_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num42_43_bank1_reg_mc_vmc_wl_num42_bank1;
    rand uvm_reg_field mc_vmc_wl_num42_bank1;
    rand uvm_reg_field mc_vmc_wl_num42_43_bank1_reg_mc_vmc_wl_num43_bank1;
    rand uvm_reg_field mc_vmc_wl_num43_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num44_45_bank1_reg mc_vmc_wl_num44_45_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num44_45_bank1_reg_mc_vmc_wl_num44_bank1;
    rand uvm_reg_field mc_vmc_wl_num44_bank1;
    rand uvm_reg_field mc_vmc_wl_num44_45_bank1_reg_mc_vmc_wl_num45_bank1;
    rand uvm_reg_field mc_vmc_wl_num45_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num46_47_bank1_reg mc_vmc_wl_num46_47_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num46_47_bank1_reg_mc_vmc_wl_num46_bank1;
    rand uvm_reg_field mc_vmc_wl_num46_bank1;
    rand uvm_reg_field mc_vmc_wl_num46_47_bank1_reg_mc_vmc_wl_num47_bank1;
    rand uvm_reg_field mc_vmc_wl_num47_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num48_49_bank1_reg mc_vmc_wl_num48_49_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num48_49_bank1_reg_mc_vmc_wl_num48_bank1;
    rand uvm_reg_field mc_vmc_wl_num48_bank1;
    rand uvm_reg_field mc_vmc_wl_num48_49_bank1_reg_mc_vmc_wl_num49_bank1;
    rand uvm_reg_field mc_vmc_wl_num49_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num50_51_bank1_reg mc_vmc_wl_num50_51_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num50_51_bank1_reg_mc_vmc_wl_num50_bank1;
    rand uvm_reg_field mc_vmc_wl_num50_bank1;
    rand uvm_reg_field mc_vmc_wl_num50_51_bank1_reg_mc_vmc_wl_num51_bank1;
    rand uvm_reg_field mc_vmc_wl_num51_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num52_53_bank1_reg mc_vmc_wl_num52_53_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num52_53_bank1_reg_mc_vmc_wl_num52_bank1;
    rand uvm_reg_field mc_vmc_wl_num52_bank1;
    rand uvm_reg_field mc_vmc_wl_num52_53_bank1_reg_mc_vmc_wl_num53_bank1;
    rand uvm_reg_field mc_vmc_wl_num53_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num54_55_bank1_reg mc_vmc_wl_num54_55_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num54_55_bank1_reg_mc_vmc_wl_num54_bank1;
    rand uvm_reg_field mc_vmc_wl_num54_bank1;
    rand uvm_reg_field mc_vmc_wl_num54_55_bank1_reg_mc_vmc_wl_num55_bank1;
    rand uvm_reg_field mc_vmc_wl_num55_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num56_57_bank1_reg mc_vmc_wl_num56_57_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num56_57_bank1_reg_mc_vmc_wl_num56_bank1;
    rand uvm_reg_field mc_vmc_wl_num56_bank1;
    rand uvm_reg_field mc_vmc_wl_num56_57_bank1_reg_mc_vmc_wl_num57_bank1;
    rand uvm_reg_field mc_vmc_wl_num57_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num58_59_bank1_reg mc_vmc_wl_num58_59_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num58_59_bank1_reg_mc_vmc_wl_num58_bank1;
    rand uvm_reg_field mc_vmc_wl_num58_bank1;
    rand uvm_reg_field mc_vmc_wl_num58_59_bank1_reg_mc_vmc_wl_num59_bank1;
    rand uvm_reg_field mc_vmc_wl_num59_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num60_61_bank1_reg mc_vmc_wl_num60_61_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num60_61_bank1_reg_mc_vmc_wl_num60_bank1;
    rand uvm_reg_field mc_vmc_wl_num60_bank1;
    rand uvm_reg_field mc_vmc_wl_num60_61_bank1_reg_mc_vmc_wl_num61_bank1;
    rand uvm_reg_field mc_vmc_wl_num61_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num62_63_bank1_reg mc_vmc_wl_num62_63_bank1_reg;
    rand uvm_reg_field mc_vmc_wl_num62_63_bank1_reg_mc_vmc_wl_num62_bank1;
    rand uvm_reg_field mc_vmc_wl_num62_bank1;
    rand uvm_reg_field mc_vmc_wl_num62_63_bank1_reg_mc_vmc_wl_num63_bank1;
    rand uvm_reg_field mc_vmc_wl_num63_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part0_1_bank1_reg mc_vmc_bl_num0_part0_1_bank1_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part0_1_bank1_reg_mc_vmc_bl_num0_part0_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part0_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part0_1_bank1_reg_mc_vmc_bl_num1_part0_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part0_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part0_1_bank1_reg_mc_vmc_bl_num0_part1_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part1_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part0_1_bank1_reg_mc_vmc_bl_num1_part1_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part1_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part2_3_bank1_reg mc_vmc_bl_num0_part2_3_bank1_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part2_3_bank1_reg_mc_vmc_bl_num0_part2_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part2_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part2_3_bank1_reg_mc_vmc_bl_num1_part2_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part2_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part2_3_bank1_reg_mc_vmc_bl_num0_part3_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part3_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part2_3_bank1_reg_mc_vmc_bl_num1_part3_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part3_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part4_5_bank1_reg mc_vmc_bl_num0_part4_5_bank1_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part4_5_bank1_reg_mc_vmc_bl_num0_part4_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part4_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part4_5_bank1_reg_mc_vmc_bl_num1_part4_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part4_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part4_5_bank1_reg_mc_vmc_bl_num0_part5_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part5_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part4_5_bank1_reg_mc_vmc_bl_num1_part5_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part5_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part6_7_bank1_reg mc_vmc_bl_num0_part6_7_bank1_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part6_7_bank1_reg_mc_vmc_bl_num0_part6_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part6_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part6_7_bank1_reg_mc_vmc_bl_num1_part6_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part6_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part6_7_bank1_reg_mc_vmc_bl_num0_part7_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part7_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part6_7_bank1_reg_mc_vmc_bl_num1_part7_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part7_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part8_9_bank1_reg mc_vmc_bl_num0_part8_9_bank1_reg;
    rand uvm_reg_field mc_vmc_bl_num0_part8_9_bank1_reg_mc_vmc_bl_num0_part8_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part8_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part8_9_bank1_reg_mc_vmc_bl_num1_part8_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part8_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part8_9_bank1_reg_mc_vmc_bl_num0_part9_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part9_bank1;
    rand uvm_reg_field mc_vmc_bl_num0_part8_9_bank1_reg_mc_vmc_bl_num1_part9_bank1;
    rand uvm_reg_field mc_vmc_bl_num1_part9_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl0_1_bank1_reg err_wl0_1_bank1_reg;
    rand uvm_reg_field err_wl0_1_bank1_reg_err_wl0_bank1;
    rand uvm_reg_field err_wl0_bank1;
    rand uvm_reg_field err_wl0_1_bank1_reg_err_wl1_bank1;
    rand uvm_reg_field err_wl1_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl2_3_bank1_reg err_wl2_3_bank1_reg;
    rand uvm_reg_field err_wl2_3_bank1_reg_err_wl2_bank1;
    rand uvm_reg_field err_wl2_bank1;
    rand uvm_reg_field err_wl2_3_bank1_reg_err_wl3_bank1;
    rand uvm_reg_field err_wl3_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl4_5_bank1_reg err_wl4_5_bank1_reg;
    rand uvm_reg_field err_wl4_5_bank1_reg_err_wl4_bank1;
    rand uvm_reg_field err_wl4_bank1;
    rand uvm_reg_field err_wl4_5_bank1_reg_err_wl5_bank1;
    rand uvm_reg_field err_wl5_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl6_7_bank1_reg err_wl6_7_bank1_reg;
    rand uvm_reg_field err_wl6_7_bank1_reg_err_wl6_bank1;
    rand uvm_reg_field err_wl6_bank1;
    rand uvm_reg_field err_wl6_7_bank1_reg_err_wl7_bank1;
    rand uvm_reg_field err_wl7_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl8_9_bank1_reg err_wl8_9_bank1_reg;
    rand uvm_reg_field err_wl8_9_bank1_reg_err_wl8_bank1;
    rand uvm_reg_field err_wl8_bank1;
    rand uvm_reg_field err_wl8_9_bank1_reg_err_wl9_bank1;
    rand uvm_reg_field err_wl9_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl10_11_bank1_reg err_wl10_11_bank1_reg;
    rand uvm_reg_field err_wl10_11_bank1_reg_err_wl10_bank1;
    rand uvm_reg_field err_wl10_bank1;
    rand uvm_reg_field err_wl10_11_bank1_reg_err_wl11_bank1;
    rand uvm_reg_field err_wl11_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl12_13_bank1_reg err_wl12_13_bank1_reg;
    rand uvm_reg_field err_wl12_13_bank1_reg_err_wl12_bank1;
    rand uvm_reg_field err_wl12_bank1;
    rand uvm_reg_field err_wl12_13_bank1_reg_err_wl13_bank1;
    rand uvm_reg_field err_wl13_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl14_15_bank1_reg err_wl14_15_bank1_reg;
    rand uvm_reg_field err_wl14_15_bank1_reg_err_wl14_bank1;
    rand uvm_reg_field err_wl14_bank1;
    rand uvm_reg_field err_wl14_15_bank1_reg_err_wl15_bank1;
    rand uvm_reg_field err_wl15_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl16_17_bank1_reg err_wl16_17_bank1_reg;
    rand uvm_reg_field err_wl16_17_bank1_reg_err_wl16_bank1;
    rand uvm_reg_field err_wl16_bank1;
    rand uvm_reg_field err_wl16_17_bank1_reg_err_wl17_bank1;
    rand uvm_reg_field err_wl17_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl18_19_bank1_reg err_wl18_19_bank1_reg;
    rand uvm_reg_field err_wl18_19_bank1_reg_err_wl18_bank1;
    rand uvm_reg_field err_wl18_bank1;
    rand uvm_reg_field err_wl18_19_bank1_reg_err_wl19_bank1;
    rand uvm_reg_field err_wl19_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl20_21_bank1_reg err_wl20_21_bank1_reg;
    rand uvm_reg_field err_wl20_21_bank1_reg_err_wl20_bank1;
    rand uvm_reg_field err_wl20_bank1;
    rand uvm_reg_field err_wl20_21_bank1_reg_err_wl21_bank1;
    rand uvm_reg_field err_wl21_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl22_23_bank1_reg err_wl22_23_bank1_reg;
    rand uvm_reg_field err_wl22_23_bank1_reg_err_wl22_bank1;
    rand uvm_reg_field err_wl22_bank1;
    rand uvm_reg_field err_wl22_23_bank1_reg_err_wl23_bank1;
    rand uvm_reg_field err_wl23_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl24_25_bank1_reg err_wl24_25_bank1_reg;
    rand uvm_reg_field err_wl24_25_bank1_reg_err_wl24_bank1;
    rand uvm_reg_field err_wl24_bank1;
    rand uvm_reg_field err_wl24_25_bank1_reg_err_wl25_bank1;
    rand uvm_reg_field err_wl25_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl26_27_bank1_reg err_wl26_27_bank1_reg;
    rand uvm_reg_field err_wl26_27_bank1_reg_err_wl26_bank1;
    rand uvm_reg_field err_wl26_bank1;
    rand uvm_reg_field err_wl26_27_bank1_reg_err_wl27_bank1;
    rand uvm_reg_field err_wl27_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl28_29_bank1_reg err_wl28_29_bank1_reg;
    rand uvm_reg_field err_wl28_29_bank1_reg_err_wl28_bank1;
    rand uvm_reg_field err_wl28_bank1;
    rand uvm_reg_field err_wl28_29_bank1_reg_err_wl29_bank1;
    rand uvm_reg_field err_wl29_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl30_31_bank1_reg err_wl30_31_bank1_reg;
    rand uvm_reg_field err_wl30_31_bank1_reg_err_wl30_bank1;
    rand uvm_reg_field err_wl30_bank1;
    rand uvm_reg_field err_wl30_31_bank1_reg_err_wl31_bank1;
    rand uvm_reg_field err_wl31_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl32_33_bank1_reg err_wl32_33_bank1_reg;
    rand uvm_reg_field err_wl32_33_bank1_reg_err_wl32_bank1;
    rand uvm_reg_field err_wl32_bank1;
    rand uvm_reg_field err_wl32_33_bank1_reg_err_wl33_bank1;
    rand uvm_reg_field err_wl33_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl34_35_bank1_reg err_wl34_35_bank1_reg;
    rand uvm_reg_field err_wl34_35_bank1_reg_err_wl34_bank1;
    rand uvm_reg_field err_wl34_bank1;
    rand uvm_reg_field err_wl34_35_bank1_reg_err_wl35_bank1;
    rand uvm_reg_field err_wl35_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl36_37_bank1_reg err_wl36_37_bank1_reg;
    rand uvm_reg_field err_wl36_37_bank1_reg_err_wl36_bank1;
    rand uvm_reg_field err_wl36_bank1;
    rand uvm_reg_field err_wl36_37_bank1_reg_err_wl37_bank1;
    rand uvm_reg_field err_wl37_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl38_39_bank1_reg err_wl38_39_bank1_reg;
    rand uvm_reg_field err_wl38_39_bank1_reg_err_wl38_bank1;
    rand uvm_reg_field err_wl38_bank1;
    rand uvm_reg_field err_wl38_39_bank1_reg_err_wl39_bank1;
    rand uvm_reg_field err_wl39_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl40_41_bank1_reg err_wl40_41_bank1_reg;
    rand uvm_reg_field err_wl40_41_bank1_reg_err_wl40_bank1;
    rand uvm_reg_field err_wl40_bank1;
    rand uvm_reg_field err_wl40_41_bank1_reg_err_wl41_bank1;
    rand uvm_reg_field err_wl41_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl42_43_bank1_reg err_wl42_43_bank1_reg;
    rand uvm_reg_field err_wl42_43_bank1_reg_err_wl42_bank1;
    rand uvm_reg_field err_wl42_bank1;
    rand uvm_reg_field err_wl42_43_bank1_reg_err_wl43_bank1;
    rand uvm_reg_field err_wl43_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl44_45_bank1_reg err_wl44_45_bank1_reg;
    rand uvm_reg_field err_wl44_45_bank1_reg_err_wl44_bank1;
    rand uvm_reg_field err_wl44_bank1;
    rand uvm_reg_field err_wl44_45_bank1_reg_err_wl45_bank1;
    rand uvm_reg_field err_wl45_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl46_47_bank1_reg err_wl46_47_bank1_reg;
    rand uvm_reg_field err_wl46_47_bank1_reg_err_wl46_bank1;
    rand uvm_reg_field err_wl46_bank1;
    rand uvm_reg_field err_wl46_47_bank1_reg_err_wl47_bank1;
    rand uvm_reg_field err_wl47_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl48_49_bank1_reg err_wl48_49_bank1_reg;
    rand uvm_reg_field err_wl48_49_bank1_reg_err_wl48_bank1;
    rand uvm_reg_field err_wl48_bank1;
    rand uvm_reg_field err_wl48_49_bank1_reg_err_wl49_bank1;
    rand uvm_reg_field err_wl49_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl50_51_bank1_reg err_wl50_51_bank1_reg;
    rand uvm_reg_field err_wl50_51_bank1_reg_err_wl50_bank1;
    rand uvm_reg_field err_wl50_bank1;
    rand uvm_reg_field err_wl50_51_bank1_reg_err_wl51_bank1;
    rand uvm_reg_field err_wl51_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl52_53_bank1_reg err_wl52_53_bank1_reg;
    rand uvm_reg_field err_wl52_53_bank1_reg_err_wl52_bank1;
    rand uvm_reg_field err_wl52_bank1;
    rand uvm_reg_field err_wl52_53_bank1_reg_err_wl53_bank1;
    rand uvm_reg_field err_wl53_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl54_55_bank1_reg err_wl54_55_bank1_reg;
    rand uvm_reg_field err_wl54_55_bank1_reg_err_wl54_bank1;
    rand uvm_reg_field err_wl54_bank1;
    rand uvm_reg_field err_wl54_55_bank1_reg_err_wl55_bank1;
    rand uvm_reg_field err_wl55_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl56_57_bank1_reg err_wl56_57_bank1_reg;
    rand uvm_reg_field err_wl56_57_bank1_reg_err_wl56_bank1;
    rand uvm_reg_field err_wl56_bank1;
    rand uvm_reg_field err_wl56_57_bank1_reg_err_wl57_bank1;
    rand uvm_reg_field err_wl57_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl58_59_bank1_reg err_wl58_59_bank1_reg;
    rand uvm_reg_field err_wl58_59_bank1_reg_err_wl58_bank1;
    rand uvm_reg_field err_wl58_bank1;
    rand uvm_reg_field err_wl58_59_bank1_reg_err_wl59_bank1;
    rand uvm_reg_field err_wl59_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl60_61_bank1_reg err_wl60_61_bank1_reg;
    rand uvm_reg_field err_wl60_61_bank1_reg_err_wl60_bank1;
    rand uvm_reg_field err_wl60_bank1;
    rand uvm_reg_field err_wl60_61_bank1_reg_err_wl61_bank1;
    rand uvm_reg_field err_wl61_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_wl62_63_bank1_reg err_wl62_63_bank1_reg;
    rand uvm_reg_field err_wl62_63_bank1_reg_err_wl62_bank1;
    rand uvm_reg_field err_wl62_bank1;
    rand uvm_reg_field err_wl62_63_bank1_reg_err_wl63_bank1;
    rand uvm_reg_field err_wl63_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_csl_part0_1_bank1_reg err_csl_part0_1_bank1_reg;
    rand uvm_reg_field err_csl_part0_1_bank1_reg_err_csl0_part0_bank1;
    rand uvm_reg_field err_csl0_part0_bank1;
    rand uvm_reg_field err_csl_part0_1_bank1_reg_err_csl1_part0_bank1;
    rand uvm_reg_field err_csl1_part0_bank1;
    rand uvm_reg_field err_csl_part0_1_bank1_reg_err_csl0_part1_bank1;
    rand uvm_reg_field err_csl0_part1_bank1;
    rand uvm_reg_field err_csl_part0_1_bank1_reg_err_csl1_part1_bank1;
    rand uvm_reg_field err_csl1_part1_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_csl_part2_3_bank1_reg err_csl_part2_3_bank1_reg;
    rand uvm_reg_field err_csl_part2_3_bank1_reg_err_csl0_part2_bank1;
    rand uvm_reg_field err_csl0_part2_bank1;
    rand uvm_reg_field err_csl_part2_3_bank1_reg_err_csl1_part2_bank1;
    rand uvm_reg_field err_csl1_part2_bank1;
    rand uvm_reg_field err_csl_part2_3_bank1_reg_err_csl0_part3_bank1;
    rand uvm_reg_field err_csl0_part3_bank1;
    rand uvm_reg_field err_csl_part2_3_bank1_reg_err_csl1_part3_bank1;
    rand uvm_reg_field err_csl1_part3_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_csl_part4_5_bank1_reg err_csl_part4_5_bank1_reg;
    rand uvm_reg_field err_csl_part4_5_bank1_reg_err_csl0_part4_bank1;
    rand uvm_reg_field err_csl0_part4_bank1;
    rand uvm_reg_field err_csl_part4_5_bank1_reg_err_csl1_part4_bank1;
    rand uvm_reg_field err_csl1_part4_bank1;
    rand uvm_reg_field err_csl_part4_5_bank1_reg_err_csl0_part5_bank1;
    rand uvm_reg_field err_csl0_part5_bank1;
    rand uvm_reg_field err_csl_part4_5_bank1_reg_err_csl1_part5_bank1;
    rand uvm_reg_field err_csl1_part5_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_csl_part6_7_bank1_reg err_csl_part6_7_bank1_reg;
    rand uvm_reg_field err_csl_part6_7_bank1_reg_err_csl0_part6_bank1;
    rand uvm_reg_field err_csl0_part6_bank1;
    rand uvm_reg_field err_csl_part6_7_bank1_reg_err_csl1_part6_bank1;
    rand uvm_reg_field err_csl1_part6_bank1;
    rand uvm_reg_field err_csl_part6_7_bank1_reg_err_csl0_part7_bank1;
    rand uvm_reg_field err_csl0_part7_bank1;
    rand uvm_reg_field err_csl_part6_7_bank1_reg_err_csl1_part7_bank1;
    rand uvm_reg_field err_csl1_part7_bank1;
    rand ral_reg_mc_1short2_top_aux_top_err_csl_part8_9_bank1_reg err_csl_part8_9_bank1_reg;
    rand uvm_reg_field err_csl_part8_9_bank1_reg_err_csl0_part8_bank1;
    rand uvm_reg_field err_csl0_part8_bank1;
    rand uvm_reg_field err_csl_part8_9_bank1_reg_err_csl1_part8_bank1;
    rand uvm_reg_field err_csl1_part8_bank1;
    rand uvm_reg_field err_csl_part8_9_bank1_reg_err_csl0_part9_bank1;
    rand uvm_reg_field err_csl0_part9_bank1;
    rand uvm_reg_field err_csl_part8_9_bank1_reg_err_csl1_part9_bank1;
    rand uvm_reg_field err_csl1_part9_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_bank_cfg_reg_reg mc_bank_cfg_reg_reg;
    rand uvm_reg_field mc_bank_cfg_reg_reg_mc_bank_map_id;
    rand uvm_reg_field mc_bank_map_id;
    rand uvm_reg_field mc_bank_cfg_reg_reg_mc_bist_grant;
    rand uvm_reg_field mc_bist_grant;
    rand ral_reg_mc_1short2_top_aux_top_mc_timeout_clr_reg mc_timeout_clr_reg;
    rand uvm_reg_field mc_timeout_clr_reg_mc_timeout_clr;
    rand uvm_reg_field mc_timeout_clr;
    rand ral_reg_mc_1short2_top_aux_top_mc_rf_start_dbg_reg mc_rf_start_dbg_reg;
    rand uvm_reg_field mc_rf_start_dbg_reg_mc_rf_start_dbg;
    rand uvm_reg_field mc_rf_start_dbg;
    rand ral_reg_mc_1short2_top_aux_top_mc_timeout_flag_reg mc_timeout_flag_reg;
    rand uvm_reg_field mc_timeout_flag_reg_mc_timeout_flag;
    rand uvm_reg_field mc_timeout_flag;
    rand ral_reg_mc_1short2_top_aux_top_mc_bist_status_reg mc_bist_status_reg;
    rand uvm_reg_field mc_bist_status_reg_mc_bist_status;
    rand uvm_reg_field mc_bist_status;
    rand uvm_reg_field mc_bist_status_reg_mc_bist_path_fail_bank0;
    rand uvm_reg_field mc_bist_path_fail_bank0;
    rand uvm_reg_field mc_bist_status_reg_mc_bist_path_fail_bank1;
    rand uvm_reg_field mc_bist_path_fail_bank1;
    rand uvm_reg_field mc_bist_status_reg_dram_init_finish;
    rand uvm_reg_field dram_init_finish;
    rand ral_reg_mc_1short2_top_aux_top_bist_finish_and_success_reg bist_finish_and_success_reg;
    rand uvm_reg_field bist_finish_and_success_reg_bist_finish_bank0;
    rand uvm_reg_field bist_finish_bank0;
    rand uvm_reg_field bist_finish_and_success_reg_bist_finish_bank1;
    rand uvm_reg_field bist_finish_bank1;
    rand uvm_reg_field bist_finish_and_success_reg_bist_rescan_finish_bank0;
    rand uvm_reg_field bist_rescan_finish_bank0;
    rand uvm_reg_field bist_finish_and_success_reg_bist_rescan_finish_bank1;
    rand uvm_reg_field bist_rescan_finish_bank1;
    rand uvm_reg_field bist_finish_and_success_reg_bank_success_bank0;
    rand uvm_reg_field bank_success_bank0;
    rand uvm_reg_field bist_finish_and_success_reg_bank_success_bank1;
    rand uvm_reg_field bank_success_bank1;
    rand uvm_reg_field bist_finish_and_success_reg_bist_rescan_success_bank0;
    rand uvm_reg_field bist_rescan_success_bank0;
    rand uvm_reg_field bist_finish_and_success_reg_bist_rescan_success_bank1;
    rand uvm_reg_field bist_rescan_success_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_bist_rescan_fail_num_bank0_reg mc_bist_rescan_fail_num_bank0_reg;
    rand uvm_reg_field mc_bist_rescan_fail_num_bank0_reg_mc_bist_rescan_fail_num_bank0;
    rand uvm_reg_field mc_bist_rescan_fail_num_bank0;
    rand ral_reg_mc_1short2_top_aux_top_mc_bist_rescan_fail_num_bank1_reg mc_bist_rescan_fail_num_bank1_reg;
    rand uvm_reg_field mc_bist_rescan_fail_num_bank1_reg_mc_bist_rescan_fail_num_bank1;
    rand uvm_reg_field mc_bist_rescan_fail_num_bank1;
    rand ral_reg_mc_1short2_top_aux_top_mc_bist_err_wl_reg mc_bist_err_wl_reg;
    rand uvm_reg_field mc_bist_err_wl_reg_mc_bist_err_wl_num_bank0;
    rand uvm_reg_field mc_bist_err_wl_num_bank0;
    rand uvm_reg_field mc_bist_err_wl_reg_mc_bist_err_wl_num_bank1;
    rand uvm_reg_field mc_bist_err_wl_num_bank1;
    rand uvm_reg_field mc_bist_err_wl_reg_err_wl_num_change_flag_bank0;
    rand uvm_reg_field err_wl_num_change_flag_bank0;
    rand uvm_reg_field mc_bist_err_wl_reg_err_wl_num_change_flag_bank1;
    rand uvm_reg_field err_wl_num_change_flag_bank1;
    rand ral_reg_mc_1short2_top_aux_top_rescan_finish_clr_reg rescan_finish_clr_reg;
    rand uvm_reg_field rescan_finish_clr_reg_rescan_finish_clr;
    rand uvm_reg_field rescan_finish_clr;
    rand ral_reg_mc_1short2_top_aux_top_rescan_finish_mask_reg rescan_finish_mask_reg;
    rand uvm_reg_field rescan_finish_mask_reg_rescan_finish_mask;
    rand uvm_reg_field rescan_finish_mask;
    rand ral_reg_mc_1short2_top_aux_top_rescan_round_result_1_reg rescan_round_result_1_reg;
    rand uvm_reg_field rescan_round_result_1_reg_rescan_round_result_bank0;
    rand uvm_reg_field rescan_round_result_bank0;
    rand uvm_reg_field rescan_round_result_1_reg_rescan_round_result_bank1;
    rand uvm_reg_field rescan_round_result_bank1;
    rand ral_reg_mc_1short2_top_aux_top_bist_finish_clr_reg bist_finish_clr_reg;
    rand uvm_reg_field bist_finish_clr_reg_bist_finish_clr;
    rand uvm_reg_field bist_finish_clr;
    rand ral_reg_mc_1short2_top_aux_top_bist_finish_mask_reg bist_finish_mask_reg;
    rand uvm_reg_field bist_finish_mask_reg_bist_finish_mask;
    rand uvm_reg_field bist_finish_mask;
    rand ral_reg_mc_1short2_top_aux_top_hang_timeout_th_reg hang_timeout_th_reg;
    rand uvm_reg_field hang_timeout_th_reg_hang_timeout_th;
    rand uvm_reg_field hang_timeout_th;
    rand ral_reg_mc_1short2_top_aux_top_bist_pattern_reg0_reg bist_pattern_reg0_reg;
    rand uvm_reg_field bist_pattern_reg0_reg_bist_pattern_reg0;
    rand uvm_reg_field bist_pattern_reg0;
    rand ral_reg_mc_1short2_top_aux_top_bist_pattern_reg1_reg bist_pattern_reg1_reg;
    rand uvm_reg_field bist_pattern_reg1_reg_bist_pattern_reg1;
    rand uvm_reg_field bist_pattern_reg1;
    rand ral_reg_mc_1short2_top_aux_top_bist_pattern_reg2_reg bist_pattern_reg2_reg;
    rand uvm_reg_field bist_pattern_reg2_reg_bist_pattern_reg2;
    rand uvm_reg_field bist_pattern_reg2;
    rand ral_reg_mc_1short2_top_aux_top_bist_pattern_reg3_reg bist_pattern_reg3_reg;
    rand uvm_reg_field bist_pattern_reg3_reg_bist_pattern_reg3;
    rand uvm_reg_field bist_pattern_reg3;
    rand ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel0_reg csl_bist_pattern_sel0_reg;
    rand uvm_reg_field csl_bist_pattern_sel0_reg_csl_bist_pattern_sel0;
    rand uvm_reg_field csl_bist_pattern_sel0;
    rand ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel1_reg csl_bist_pattern_sel1_reg;
    rand uvm_reg_field csl_bist_pattern_sel1_reg_csl_bist_pattern_sel1;
    rand uvm_reg_field csl_bist_pattern_sel1;
    rand ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel2_reg csl_bist_pattern_sel2_reg;
    rand uvm_reg_field csl_bist_pattern_sel2_reg_csl_bist_pattern_sel2;
    rand uvm_reg_field csl_bist_pattern_sel2;
    rand ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel0_reg wl_bist_pattern_sel0_reg;
    rand uvm_reg_field wl_bist_pattern_sel0_reg_wl_bist_pattern_sel0;
    rand uvm_reg_field wl_bist_pattern_sel0;
    rand ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel1_reg wl_bist_pattern_sel1_reg;
    rand uvm_reg_field wl_bist_pattern_sel1_reg_wl_bist_pattern_sel1;
    rand uvm_reg_field wl_bist_pattern_sel1;
    rand ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel2_reg wl_bist_pattern_sel2_reg;
    rand uvm_reg_field wl_bist_pattern_sel2_reg_wl_bist_pattern_sel2;
    rand uvm_reg_field wl_bist_pattern_sel2;
    rand ral_reg_mc_1short2_top_aux_top_mc_frame2array_dbg_reg mc_frame2array_dbg_reg;
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
    rand ral_reg_mc_1short2_top_aux_top_dbg_frame_store_0_reg dbg_frame_store_0_reg;
    rand uvm_reg_field dbg_frame_store_0_reg_dbg_frame_store_0;
    rand uvm_reg_field dbg_frame_store_0;
    rand ral_reg_mc_1short2_top_aux_top_dbg_frame_store_1_reg dbg_frame_store_1_reg;
    rand uvm_reg_field dbg_frame_store_1_reg_dbg_frame_store_1;
    rand uvm_reg_field dbg_frame_store_1;
    rand ral_reg_mc_1short2_top_aux_top_dbg_frame_store_2_reg dbg_frame_store_2_reg;
    rand uvm_reg_field dbg_frame_store_2_reg_dbg_frame_store_2;
    rand uvm_reg_field dbg_frame_store_2;
    rand ral_reg_mc_1short2_top_aux_top_dbg_frame_store_3_reg dbg_frame_store_3_reg;
    rand uvm_reg_field dbg_frame_store_3_reg_dbg_frame_store_3;
    rand uvm_reg_field dbg_frame_store_3;
    rand ral_reg_mc_1short2_top_aux_top_dbg_frame_store_4_reg dbg_frame_store_4_reg;
    rand uvm_reg_field dbg_frame_store_4_reg_dbg_frame_store_4;
    rand uvm_reg_field dbg_frame_store_4;
    rand ral_reg_mc_1short2_top_aux_top_dbg_frame_store_5_reg dbg_frame_store_5_reg;
    rand uvm_reg_field dbg_frame_store_5_reg_dbg_frame_store_5;
    rand uvm_reg_field dbg_frame_store_5;
    rand ral_reg_mc_1short2_top_aux_top_dbg_frame_store_6_reg dbg_frame_store_6_reg;
    rand uvm_reg_field dbg_frame_store_6_reg_dbg_frame_store_6;
    rand uvm_reg_field dbg_frame_store_6;
    rand ral_reg_mc_1short2_top_aux_top_dbg_frame_store_7_reg dbg_frame_store_7_reg;
    rand uvm_reg_field dbg_frame_store_7_reg_dbg_frame_store_7;
    rand uvm_reg_field dbg_frame_store_7;
    rand ral_reg_mc_1short2_top_aux_top_dbg_frame_store_8_reg dbg_frame_store_8_reg;
    rand uvm_reg_field dbg_frame_store_8_reg_dbg_frame_store_8;
    rand uvm_reg_field dbg_frame_store_8;
    rand ral_reg_mc_1short2_top_aux_top_dbg_frame_store_9_reg dbg_frame_store_9_reg;
    rand uvm_reg_field dbg_frame_store_9_reg_dbg_frame_store_9;
    rand uvm_reg_field dbg_frame_store_9;
    rand ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_0_reg dbg_rdata_store_0_reg;
    rand uvm_reg_field dbg_rdata_store_0_reg_dbg_rdata_store_0;
    rand uvm_reg_field dbg_rdata_store_0;
    rand ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_1_reg dbg_rdata_store_1_reg;
    rand uvm_reg_field dbg_rdata_store_1_reg_dbg_rdata_store_1;
    rand uvm_reg_field dbg_rdata_store_1;
    rand ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_2_reg dbg_rdata_store_2_reg;
    rand uvm_reg_field dbg_rdata_store_2_reg_dbg_rdata_store_2;
    rand uvm_reg_field dbg_rdata_store_2;
    rand ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_3_reg dbg_rdata_store_3_reg;
    rand uvm_reg_field dbg_rdata_store_3_reg_dbg_rdata_store_3;
    rand uvm_reg_field dbg_rdata_store_3;
    rand ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_4_reg dbg_rdata_store_4_reg;
    rand uvm_reg_field dbg_rdata_store_4_reg_dbg_rdata_store_4;
    rand uvm_reg_field dbg_rdata_store_4;
    rand ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_5_reg dbg_rdata_store_5_reg;
    rand uvm_reg_field dbg_rdata_store_5_reg_dbg_rdata_store_5;
    rand uvm_reg_field dbg_rdata_store_5;
    rand ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_6_reg dbg_rdata_store_6_reg;
    rand uvm_reg_field dbg_rdata_store_6_reg_dbg_rdata_store_6;
    rand uvm_reg_field dbg_rdata_store_6;
    rand ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_7_reg dbg_rdata_store_7_reg;
    rand uvm_reg_field dbg_rdata_store_7_reg_dbg_rdata_store_7;
    rand uvm_reg_field dbg_rdata_store_7;
    rand ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_8_reg dbg_rdata_store_8_reg;
    rand uvm_reg_field dbg_rdata_store_8_reg_dbg_rdata_store_8;
    rand uvm_reg_field dbg_rdata_store_8;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_ctrl_reg mc_ecc_ce_ctrl_reg;
    rand uvm_reg_field mc_ecc_ce_ctrl_reg_mc_ecc_ce_int_clr;
    rand uvm_reg_field mc_ecc_ce_int_clr;
    rand uvm_reg_field mc_ecc_ce_ctrl_reg_mc_ecc_ce_overflow_int;
    rand uvm_reg_field mc_ecc_ce_overflow_int;
    rand uvm_reg_field mc_ecc_ce_ctrl_reg_mc_ecc_ce_th;
    rand uvm_reg_field mc_ecc_ce_th;
    rand uvm_reg_field mc_ecc_ce_ctrl_reg_mc_ecc_ce_cnt;
    rand uvm_reg_field mc_ecc_ce_cnt;
    rand uvm_reg_field mc_ecc_ce_ctrl_reg_mc_ecc_ce_int_mask;
    rand uvm_reg_field mc_ecc_ce_int_mask;
    rand uvm_reg_field mc_ecc_ce_ctrl_reg_mc_ecc_ce_int_en;
    rand uvm_reg_field mc_ecc_ce_int_en;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr0_reg mc_ecc_ce_addr0_reg;
    rand uvm_reg_field mc_ecc_ce_addr0_reg_mc_ecc_ce_addr0;
    rand uvm_reg_field mc_ecc_ce_addr0;
    rand uvm_reg_field mc_ecc_ce_addr0_reg_mc_ecc_ce_addr_vld0;
    rand uvm_reg_field mc_ecc_ce_addr_vld0;
    rand uvm_reg_field mc_ecc_ce_addr0_reg_mc_ecc_ce_addr_cnt0;
    rand uvm_reg_field mc_ecc_ce_addr_cnt0;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr1_reg mc_ecc_ce_addr1_reg;
    rand uvm_reg_field mc_ecc_ce_addr1_reg_mc_ecc_ce_addr1;
    rand uvm_reg_field mc_ecc_ce_addr1;
    rand uvm_reg_field mc_ecc_ce_addr1_reg_mc_ecc_ce_addr_vld1;
    rand uvm_reg_field mc_ecc_ce_addr_vld1;
    rand uvm_reg_field mc_ecc_ce_addr1_reg_mc_ecc_ce_addr_cnt1;
    rand uvm_reg_field mc_ecc_ce_addr_cnt1;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr2_reg mc_ecc_ce_addr2_reg;
    rand uvm_reg_field mc_ecc_ce_addr2_reg_mc_ecc_ce_addr2;
    rand uvm_reg_field mc_ecc_ce_addr2;
    rand uvm_reg_field mc_ecc_ce_addr2_reg_mc_ecc_ce_addr_vld2;
    rand uvm_reg_field mc_ecc_ce_addr_vld2;
    rand uvm_reg_field mc_ecc_ce_addr2_reg_mc_ecc_ce_addr_cnt2;
    rand uvm_reg_field mc_ecc_ce_addr_cnt2;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr3_reg mc_ecc_ce_addr3_reg;
    rand uvm_reg_field mc_ecc_ce_addr3_reg_mc_ecc_ce_addr3;
    rand uvm_reg_field mc_ecc_ce_addr3;
    rand uvm_reg_field mc_ecc_ce_addr3_reg_mc_ecc_ce_addr_vld3;
    rand uvm_reg_field mc_ecc_ce_addr_vld3;
    rand uvm_reg_field mc_ecc_ce_addr3_reg_mc_ecc_ce_addr_cnt3;
    rand uvm_reg_field mc_ecc_ce_addr_cnt3;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr4_reg mc_ecc_ce_addr4_reg;
    rand uvm_reg_field mc_ecc_ce_addr4_reg_mc_ecc_ce_addr4;
    rand uvm_reg_field mc_ecc_ce_addr4;
    rand uvm_reg_field mc_ecc_ce_addr4_reg_mc_ecc_ce_addr_vld4;
    rand uvm_reg_field mc_ecc_ce_addr_vld4;
    rand uvm_reg_field mc_ecc_ce_addr4_reg_mc_ecc_ce_addr_cnt4;
    rand uvm_reg_field mc_ecc_ce_addr_cnt4;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr5_reg mc_ecc_ce_addr5_reg;
    rand uvm_reg_field mc_ecc_ce_addr5_reg_mc_ecc_ce_addr5;
    rand uvm_reg_field mc_ecc_ce_addr5;
    rand uvm_reg_field mc_ecc_ce_addr5_reg_mc_ecc_ce_addr_vld5;
    rand uvm_reg_field mc_ecc_ce_addr_vld5;
    rand uvm_reg_field mc_ecc_ce_addr5_reg_mc_ecc_ce_addr_cnt5;
    rand uvm_reg_field mc_ecc_ce_addr_cnt5;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr6_reg mc_ecc_ce_addr6_reg;
    rand uvm_reg_field mc_ecc_ce_addr6_reg_mc_ecc_ce_addr6;
    rand uvm_reg_field mc_ecc_ce_addr6;
    rand uvm_reg_field mc_ecc_ce_addr6_reg_mc_ecc_ce_addr_vld6;
    rand uvm_reg_field mc_ecc_ce_addr_vld6;
    rand uvm_reg_field mc_ecc_ce_addr6_reg_mc_ecc_ce_addr_cnt6;
    rand uvm_reg_field mc_ecc_ce_addr_cnt6;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr7_reg mc_ecc_ce_addr7_reg;
    rand uvm_reg_field mc_ecc_ce_addr7_reg_mc_ecc_ce_addr7;
    rand uvm_reg_field mc_ecc_ce_addr7;
    rand uvm_reg_field mc_ecc_ce_addr7_reg_mc_ecc_ce_addr_vld7;
    rand uvm_reg_field mc_ecc_ce_addr_vld7;
    rand uvm_reg_field mc_ecc_ce_addr7_reg_mc_ecc_ce_addr_cnt7;
    rand uvm_reg_field mc_ecc_ce_addr_cnt7;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr8_reg mc_ecc_ce_addr8_reg;
    rand uvm_reg_field mc_ecc_ce_addr8_reg_mc_ecc_ce_addr8;
    rand uvm_reg_field mc_ecc_ce_addr8;
    rand uvm_reg_field mc_ecc_ce_addr8_reg_mc_ecc_ce_addr_vld8;
    rand uvm_reg_field mc_ecc_ce_addr_vld8;
    rand uvm_reg_field mc_ecc_ce_addr8_reg_mc_ecc_ce_addr_cnt8;
    rand uvm_reg_field mc_ecc_ce_addr_cnt8;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr9_reg mc_ecc_ce_addr9_reg;
    rand uvm_reg_field mc_ecc_ce_addr9_reg_mc_ecc_ce_addr9;
    rand uvm_reg_field mc_ecc_ce_addr9;
    rand uvm_reg_field mc_ecc_ce_addr9_reg_mc_ecc_ce_addr_vld9;
    rand uvm_reg_field mc_ecc_ce_addr_vld9;
    rand uvm_reg_field mc_ecc_ce_addr9_reg_mc_ecc_ce_addr_cnt9;
    rand uvm_reg_field mc_ecc_ce_addr_cnt9;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr10_reg mc_ecc_ce_addr10_reg;
    rand uvm_reg_field mc_ecc_ce_addr10_reg_mc_ecc_ce_addr10;
    rand uvm_reg_field mc_ecc_ce_addr10;
    rand uvm_reg_field mc_ecc_ce_addr10_reg_mc_ecc_ce_addr_vld10;
    rand uvm_reg_field mc_ecc_ce_addr_vld10;
    rand uvm_reg_field mc_ecc_ce_addr10_reg_mc_ecc_ce_addr_cnt10;
    rand uvm_reg_field mc_ecc_ce_addr_cnt10;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr11_reg mc_ecc_ce_addr11_reg;
    rand uvm_reg_field mc_ecc_ce_addr11_reg_mc_ecc_ce_addr11;
    rand uvm_reg_field mc_ecc_ce_addr11;
    rand uvm_reg_field mc_ecc_ce_addr11_reg_mc_ecc_ce_addr_vld11;
    rand uvm_reg_field mc_ecc_ce_addr_vld11;
    rand uvm_reg_field mc_ecc_ce_addr11_reg_mc_ecc_ce_addr_cnt11;
    rand uvm_reg_field mc_ecc_ce_addr_cnt11;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr12_reg mc_ecc_ce_addr12_reg;
    rand uvm_reg_field mc_ecc_ce_addr12_reg_mc_ecc_ce_addr12;
    rand uvm_reg_field mc_ecc_ce_addr12;
    rand uvm_reg_field mc_ecc_ce_addr12_reg_mc_ecc_ce_addr_vld12;
    rand uvm_reg_field mc_ecc_ce_addr_vld12;
    rand uvm_reg_field mc_ecc_ce_addr12_reg_mc_ecc_ce_addr_cnt12;
    rand uvm_reg_field mc_ecc_ce_addr_cnt12;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr13_reg mc_ecc_ce_addr13_reg;
    rand uvm_reg_field mc_ecc_ce_addr13_reg_mc_ecc_ce_addr13;
    rand uvm_reg_field mc_ecc_ce_addr13;
    rand uvm_reg_field mc_ecc_ce_addr13_reg_mc_ecc_ce_addr_vld13;
    rand uvm_reg_field mc_ecc_ce_addr_vld13;
    rand uvm_reg_field mc_ecc_ce_addr13_reg_mc_ecc_ce_addr_cnt13;
    rand uvm_reg_field mc_ecc_ce_addr_cnt13;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr14_reg mc_ecc_ce_addr14_reg;
    rand uvm_reg_field mc_ecc_ce_addr14_reg_mc_ecc_ce_addr14;
    rand uvm_reg_field mc_ecc_ce_addr14;
    rand uvm_reg_field mc_ecc_ce_addr14_reg_mc_ecc_ce_addr_vld14;
    rand uvm_reg_field mc_ecc_ce_addr_vld14;
    rand uvm_reg_field mc_ecc_ce_addr14_reg_mc_ecc_ce_addr_cnt14;
    rand uvm_reg_field mc_ecc_ce_addr_cnt14;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr15_reg mc_ecc_ce_addr15_reg;
    rand uvm_reg_field mc_ecc_ce_addr15_reg_mc_ecc_ce_addr15;
    rand uvm_reg_field mc_ecc_ce_addr15;
    rand uvm_reg_field mc_ecc_ce_addr15_reg_mc_ecc_ce_addr_vld15;
    rand uvm_reg_field mc_ecc_ce_addr_vld15;
    rand uvm_reg_field mc_ecc_ce_addr15_reg_mc_ecc_ce_addr_cnt15;
    rand uvm_reg_field mc_ecc_ce_addr_cnt15;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_ctrl_reg mc_ecc_uce_ctrl_reg;
    rand uvm_reg_field mc_ecc_uce_ctrl_reg_mc_ecc_uce_int_clr;
    rand uvm_reg_field mc_ecc_uce_int_clr;
    rand uvm_reg_field mc_ecc_uce_ctrl_reg_mc_ecc_uce_int;
    rand uvm_reg_field mc_ecc_uce_int;
    rand uvm_reg_field mc_ecc_uce_ctrl_reg_mc_ecc_uce_cnt;
    rand uvm_reg_field mc_ecc_uce_cnt;
    rand uvm_reg_field mc_ecc_uce_ctrl_reg_mc_ecc_uce_int_mask;
    rand uvm_reg_field mc_ecc_uce_int_mask;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr0_reg mc_ecc_uce_addr0_reg;
    rand uvm_reg_field mc_ecc_uce_addr0_reg_mc_ecc_uce_addr0;
    rand uvm_reg_field mc_ecc_uce_addr0;
    rand uvm_reg_field mc_ecc_uce_addr0_reg_mc_ecc_uce_addr_vld0;
    rand uvm_reg_field mc_ecc_uce_addr_vld0;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr1_reg mc_ecc_uce_addr1_reg;
    rand uvm_reg_field mc_ecc_uce_addr1_reg_mc_ecc_uce_addr1;
    rand uvm_reg_field mc_ecc_uce_addr1;
    rand uvm_reg_field mc_ecc_uce_addr1_reg_mc_ecc_uce_addr_vld1;
    rand uvm_reg_field mc_ecc_uce_addr_vld1;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr2_reg mc_ecc_uce_addr2_reg;
    rand uvm_reg_field mc_ecc_uce_addr2_reg_mc_ecc_uce_addr2;
    rand uvm_reg_field mc_ecc_uce_addr2;
    rand uvm_reg_field mc_ecc_uce_addr2_reg_mc_ecc_uce_addr_vld2;
    rand uvm_reg_field mc_ecc_uce_addr_vld2;
    rand ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr3_reg mc_ecc_uce_addr3_reg;
    rand uvm_reg_field mc_ecc_uce_addr3_reg_mc_ecc_uce_addr3;
    rand uvm_reg_field mc_ecc_uce_addr3;
    rand uvm_reg_field mc_ecc_uce_addr3_reg_mc_ecc_uce_addr_vld3;
    rand uvm_reg_field mc_ecc_uce_addr_vld3;
    rand ral_reg_mc_1short2_top_aux_top_mc_page_status_reg mc_page_status_reg;
    rand uvm_reg_field mc_page_status_reg_mc_page_status;
    rand uvm_reg_field mc_page_status;
    rand ral_reg_mc_1short2_top_aux_top_hang_timeout_status_reg hang_timeout_status_reg;
    rand uvm_reg_field hang_timeout_status_reg_hang_timeout_status;
    rand uvm_reg_field hang_timeout_status;
    rand ral_reg_mc_1short2_top_aux_top_hang_timeout_mask_reg hang_timeout_mask_reg;
    rand uvm_reg_field hang_timeout_mask_reg_hang_timeout_mask;
    rand uvm_reg_field hang_timeout_mask;
    rand ral_reg_mc_1short2_top_aux_top_hang_timeout_clr_reg hang_timeout_clr_reg;
    rand uvm_reg_field hang_timeout_clr_reg_hang_timeout_clr;
    rand uvm_reg_field hang_timeout_clr;
    rand ral_reg_mc_1short2_top_aux_top_hang_timeout_en_reg hang_timeout_en_reg;
    rand uvm_reg_field hang_timeout_en_reg_hang_timeout_en;
    rand uvm_reg_field hang_timeout_en;
    rand ral_reg_mc_1short2_top_aux_top_bist_clk_cnt_reg bist_clk_cnt_reg;
    rand uvm_reg_field bist_clk_cnt_reg_bist_clk_cnt;
    rand uvm_reg_field bist_clk_cnt;

    function new(string name = "ral_block_mc_1short2_top_aux_top");
        super.new(name,build_coverage(UVM_NO_COVERAGE));
    endfunction: new


    virtual function void build();
        this.default_map = create_map("",0,4,UVM_LITTLE_ENDIAN, 0);

        this.mc_id_reg = ral_reg_mc_1short2_top_aux_top_mc_id_reg::type_id::create("mc_id_reg",,get_full_name());
        this.mc_id_reg.configure(this, null, "");
        this.mc_id_reg.build();
        this.default_map.add_reg(this.mc_id_reg, `UVM_REG_ADDR_WIDTH'h0,"RW",0);
            this.mc_id_reg_mc_id = this.mc_id_reg.mc_id;
            this.mc_id = this.mc_id_reg.mc_id;

        this.mc_work_ctrl_reg = ral_reg_mc_1short2_top_aux_top_mc_work_ctrl_reg::type_id::create("mc_work_ctrl_reg",,get_full_name());
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

            this.mc_work_ctrl_reg_mc_rdata_invert_sel = this.mc_work_ctrl_reg.mc_rdata_invert_sel;
            this.mc_rdata_invert_sel = this.mc_work_ctrl_reg.mc_rdata_invert_sel;

            this.mc_work_ctrl_reg_mc_rdrdy_n_en = this.mc_work_ctrl_reg.mc_rdrdy_n_en;
            this.mc_rdrdy_n_en = this.mc_work_ctrl_reg.mc_rdrdy_n_en;

            this.mc_work_ctrl_reg_mc_rf_en = this.mc_work_ctrl_reg.mc_rf_en;
            this.mc_rf_en = this.mc_work_ctrl_reg.mc_rf_en;

            this.mc_work_ctrl_reg_mc_rf_burst_split_en = this.mc_work_ctrl_reg.mc_rf_burst_split_en;
            this.mc_rf_burst_split_en = this.mc_work_ctrl_reg.mc_rf_burst_split_en;

            this.mc_work_ctrl_reg_mc_fake_bresp_en = this.mc_work_ctrl_reg.mc_fake_bresp_en;
            this.mc_fake_bresp_en = this.mc_work_ctrl_reg.mc_fake_bresp_en;

            this.mc_work_ctrl_reg_mc_ecc_en = this.mc_work_ctrl_reg.mc_ecc_en;
            this.mc_ecc_en = this.mc_work_ctrl_reg.mc_ecc_en;

            this.mc_work_ctrl_reg_mc_all_bank_act_en = this.mc_work_ctrl_reg.mc_all_bank_act_en;
            this.mc_all_bank_act_en = this.mc_work_ctrl_reg.mc_all_bank_act_en;

            this.mc_work_ctrl_reg_mc2phy_dram0_mask = this.mc_work_ctrl_reg.mc2phy_dram0_mask;
            this.mc2phy_dram0_mask = this.mc_work_ctrl_reg.mc2phy_dram0_mask;

            this.mc_work_ctrl_reg_mc2phy_dram1_mask = this.mc_work_ctrl_reg.mc2phy_dram1_mask;
            this.mc2phy_dram1_mask = this.mc_work_ctrl_reg.mc2phy_dram1_mask;

            this.mc_work_ctrl_reg_mc2phy_dram2_mask = this.mc_work_ctrl_reg.mc2phy_dram2_mask;
            this.mc2phy_dram2_mask = this.mc_work_ctrl_reg.mc2phy_dram2_mask;

            this.mc_work_ctrl_reg_mc2phy_dram3_mask = this.mc_work_ctrl_reg.mc2phy_dram3_mask;
            this.mc2phy_dram3_mask = this.mc_work_ctrl_reg.mc2phy_dram3_mask;

        this.phy_timing_cfg0_reg = ral_reg_mc_1short2_top_aux_top_phy_timing_cfg0_reg::type_id::create("phy_timing_cfg0_reg",,get_full_name());
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

        this.mc_rf_period_cfg1_reg = ral_reg_mc_1short2_top_aux_top_mc_rf_period_cfg1_reg::type_id::create("mc_rf_period_cfg1_reg",,get_full_name());
        this.mc_rf_period_cfg1_reg.configure(this, null, "");
        this.mc_rf_period_cfg1_reg.build();
        this.default_map.add_reg(this.mc_rf_period_cfg1_reg, `UVM_REG_ADDR_WIDTH'hc,"RW",0);
            this.mc_rf_period_cfg1_reg_mc_rf_period_1 = this.mc_rf_period_cfg1_reg.mc_rf_period_1;
            this.mc_rf_period_1 = this.mc_rf_period_cfg1_reg.mc_rf_period_1;

        this.mc_rf_start_cfg1_reg = ral_reg_mc_1short2_top_aux_top_mc_rf_start_cfg1_reg::type_id::create("mc_rf_start_cfg1_reg",,get_full_name());
        this.mc_rf_start_cfg1_reg.configure(this, null, "");
        this.mc_rf_start_cfg1_reg.build();
        this.default_map.add_reg(this.mc_rf_start_cfg1_reg, `UVM_REG_ADDR_WIDTH'h10,"RW",0);
            this.mc_rf_start_cfg1_reg_mc_rf_start_1 = this.mc_rf_start_cfg1_reg.mc_rf_start_1;
            this.mc_rf_start_1 = this.mc_rf_start_cfg1_reg.mc_rf_start_1;

        this.mc_rf_period_cfg2_reg = ral_reg_mc_1short2_top_aux_top_mc_rf_period_cfg2_reg::type_id::create("mc_rf_period_cfg2_reg",,get_full_name());
        this.mc_rf_period_cfg2_reg.configure(this, null, "");
        this.mc_rf_period_cfg2_reg.build();
        this.default_map.add_reg(this.mc_rf_period_cfg2_reg, `UVM_REG_ADDR_WIDTH'h14,"RW",0);
            this.mc_rf_period_cfg2_reg_mc_rf_period_2 = this.mc_rf_period_cfg2_reg.mc_rf_period_2;
            this.mc_rf_period_2 = this.mc_rf_period_cfg2_reg.mc_rf_period_2;

        this.mc_rf_start_cfg2_reg = ral_reg_mc_1short2_top_aux_top_mc_rf_start_cfg2_reg::type_id::create("mc_rf_start_cfg2_reg",,get_full_name());
        this.mc_rf_start_cfg2_reg.configure(this, null, "");
        this.mc_rf_start_cfg2_reg.build();
        this.default_map.add_reg(this.mc_rf_start_cfg2_reg, `UVM_REG_ADDR_WIDTH'h18,"RW",0);
            this.mc_rf_start_cfg2_reg_mc_rf_start_2 = this.mc_rf_start_cfg2_reg.mc_rf_start_2;
            this.mc_rf_start_2 = this.mc_rf_start_cfg2_reg.mc_rf_start_2;

        this.mc_vmc_wl_num0_1_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num0_1_bank0_reg::type_id::create("mc_vmc_wl_num0_1_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num0_1_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num0_1_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num0_1_bank0_reg, `UVM_REG_ADDR_WIDTH'h1c,"RW",0);
            this.mc_vmc_wl_num0_1_bank0_reg_mc_vmc_wl_num0_bank0 = this.mc_vmc_wl_num0_1_bank0_reg.mc_vmc_wl_num0_bank0;
            this.mc_vmc_wl_num0_bank0 = this.mc_vmc_wl_num0_1_bank0_reg.mc_vmc_wl_num0_bank0;

            this.mc_vmc_wl_num0_1_bank0_reg_mc_vmc_wl_num1_bank0 = this.mc_vmc_wl_num0_1_bank0_reg.mc_vmc_wl_num1_bank0;
            this.mc_vmc_wl_num1_bank0 = this.mc_vmc_wl_num0_1_bank0_reg.mc_vmc_wl_num1_bank0;

        this.mc_vmc_wl_num2_3_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num2_3_bank0_reg::type_id::create("mc_vmc_wl_num2_3_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num2_3_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num2_3_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num2_3_bank0_reg, `UVM_REG_ADDR_WIDTH'h20,"RW",0);
            this.mc_vmc_wl_num2_3_bank0_reg_mc_vmc_wl_num2_bank0 = this.mc_vmc_wl_num2_3_bank0_reg.mc_vmc_wl_num2_bank0;
            this.mc_vmc_wl_num2_bank0 = this.mc_vmc_wl_num2_3_bank0_reg.mc_vmc_wl_num2_bank0;

            this.mc_vmc_wl_num2_3_bank0_reg_mc_vmc_wl_num3_bank0 = this.mc_vmc_wl_num2_3_bank0_reg.mc_vmc_wl_num3_bank0;
            this.mc_vmc_wl_num3_bank0 = this.mc_vmc_wl_num2_3_bank0_reg.mc_vmc_wl_num3_bank0;

        this.mc_vmc_wl_num4_5_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num4_5_bank0_reg::type_id::create("mc_vmc_wl_num4_5_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num4_5_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num4_5_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num4_5_bank0_reg, `UVM_REG_ADDR_WIDTH'h24,"RW",0);
            this.mc_vmc_wl_num4_5_bank0_reg_mc_vmc_wl_num4_bank0 = this.mc_vmc_wl_num4_5_bank0_reg.mc_vmc_wl_num4_bank0;
            this.mc_vmc_wl_num4_bank0 = this.mc_vmc_wl_num4_5_bank0_reg.mc_vmc_wl_num4_bank0;

            this.mc_vmc_wl_num4_5_bank0_reg_mc_vmc_wl_num5_bank0 = this.mc_vmc_wl_num4_5_bank0_reg.mc_vmc_wl_num5_bank0;
            this.mc_vmc_wl_num5_bank0 = this.mc_vmc_wl_num4_5_bank0_reg.mc_vmc_wl_num5_bank0;

        this.mc_vmc_wl_num6_7_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num6_7_bank0_reg::type_id::create("mc_vmc_wl_num6_7_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num6_7_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num6_7_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num6_7_bank0_reg, `UVM_REG_ADDR_WIDTH'h28,"RW",0);
            this.mc_vmc_wl_num6_7_bank0_reg_mc_vmc_wl_num6_bank0 = this.mc_vmc_wl_num6_7_bank0_reg.mc_vmc_wl_num6_bank0;
            this.mc_vmc_wl_num6_bank0 = this.mc_vmc_wl_num6_7_bank0_reg.mc_vmc_wl_num6_bank0;

            this.mc_vmc_wl_num6_7_bank0_reg_mc_vmc_wl_num7_bank0 = this.mc_vmc_wl_num6_7_bank0_reg.mc_vmc_wl_num7_bank0;
            this.mc_vmc_wl_num7_bank0 = this.mc_vmc_wl_num6_7_bank0_reg.mc_vmc_wl_num7_bank0;

        this.mc_vmc_wl_num8_9_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num8_9_bank0_reg::type_id::create("mc_vmc_wl_num8_9_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num8_9_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num8_9_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num8_9_bank0_reg, `UVM_REG_ADDR_WIDTH'h2C,"RW",0);
            this.mc_vmc_wl_num8_9_bank0_reg_mc_vmc_wl_num8_bank0 = this.mc_vmc_wl_num8_9_bank0_reg.mc_vmc_wl_num8_bank0;
            this.mc_vmc_wl_num8_bank0 = this.mc_vmc_wl_num8_9_bank0_reg.mc_vmc_wl_num8_bank0;

            this.mc_vmc_wl_num8_9_bank0_reg_mc_vmc_wl_num9_bank0 = this.mc_vmc_wl_num8_9_bank0_reg.mc_vmc_wl_num9_bank0;
            this.mc_vmc_wl_num9_bank0 = this.mc_vmc_wl_num8_9_bank0_reg.mc_vmc_wl_num9_bank0;

        this.mc_vmc_wl_num10_11_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num10_11_bank0_reg::type_id::create("mc_vmc_wl_num10_11_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num10_11_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num10_11_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num10_11_bank0_reg, `UVM_REG_ADDR_WIDTH'h30,"RW",0);
            this.mc_vmc_wl_num10_11_bank0_reg_mc_vmc_wl_num10_bank0 = this.mc_vmc_wl_num10_11_bank0_reg.mc_vmc_wl_num10_bank0;
            this.mc_vmc_wl_num10_bank0 = this.mc_vmc_wl_num10_11_bank0_reg.mc_vmc_wl_num10_bank0;

            this.mc_vmc_wl_num10_11_bank0_reg_mc_vmc_wl_num11_bank0 = this.mc_vmc_wl_num10_11_bank0_reg.mc_vmc_wl_num11_bank0;
            this.mc_vmc_wl_num11_bank0 = this.mc_vmc_wl_num10_11_bank0_reg.mc_vmc_wl_num11_bank0;

        this.mc_vmc_wl_num12_13_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num12_13_bank0_reg::type_id::create("mc_vmc_wl_num12_13_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num12_13_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num12_13_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num12_13_bank0_reg, `UVM_REG_ADDR_WIDTH'h34,"RW",0);
            this.mc_vmc_wl_num12_13_bank0_reg_mc_vmc_wl_num12_bank0 = this.mc_vmc_wl_num12_13_bank0_reg.mc_vmc_wl_num12_bank0;
            this.mc_vmc_wl_num12_bank0 = this.mc_vmc_wl_num12_13_bank0_reg.mc_vmc_wl_num12_bank0;

            this.mc_vmc_wl_num12_13_bank0_reg_mc_vmc_wl_num13_bank0 = this.mc_vmc_wl_num12_13_bank0_reg.mc_vmc_wl_num13_bank0;
            this.mc_vmc_wl_num13_bank0 = this.mc_vmc_wl_num12_13_bank0_reg.mc_vmc_wl_num13_bank0;

        this.mc_vmc_wl_num14_15_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num14_15_bank0_reg::type_id::create("mc_vmc_wl_num14_15_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num14_15_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num14_15_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num14_15_bank0_reg, `UVM_REG_ADDR_WIDTH'h38,"RW",0);
            this.mc_vmc_wl_num14_15_bank0_reg_mc_vmc_wl_num14_bank0 = this.mc_vmc_wl_num14_15_bank0_reg.mc_vmc_wl_num14_bank0;
            this.mc_vmc_wl_num14_bank0 = this.mc_vmc_wl_num14_15_bank0_reg.mc_vmc_wl_num14_bank0;

            this.mc_vmc_wl_num14_15_bank0_reg_mc_vmc_wl_num15_bank0 = this.mc_vmc_wl_num14_15_bank0_reg.mc_vmc_wl_num15_bank0;
            this.mc_vmc_wl_num15_bank0 = this.mc_vmc_wl_num14_15_bank0_reg.mc_vmc_wl_num15_bank0;

        this.mc_vmc_wl_num16_17_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num16_17_bank0_reg::type_id::create("mc_vmc_wl_num16_17_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num16_17_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num16_17_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num16_17_bank0_reg, `UVM_REG_ADDR_WIDTH'h3C,"RW",0);
            this.mc_vmc_wl_num16_17_bank0_reg_mc_vmc_wl_num16_bank0 = this.mc_vmc_wl_num16_17_bank0_reg.mc_vmc_wl_num16_bank0;
            this.mc_vmc_wl_num16_bank0 = this.mc_vmc_wl_num16_17_bank0_reg.mc_vmc_wl_num16_bank0;

            this.mc_vmc_wl_num16_17_bank0_reg_mc_vmc_wl_num17_bank0 = this.mc_vmc_wl_num16_17_bank0_reg.mc_vmc_wl_num17_bank0;
            this.mc_vmc_wl_num17_bank0 = this.mc_vmc_wl_num16_17_bank0_reg.mc_vmc_wl_num17_bank0;

        this.mc_vmc_wl_num18_19_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num18_19_bank0_reg::type_id::create("mc_vmc_wl_num18_19_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num18_19_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num18_19_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num18_19_bank0_reg, `UVM_REG_ADDR_WIDTH'h40,"RW",0);
            this.mc_vmc_wl_num18_19_bank0_reg_mc_vmc_wl_num18_bank0 = this.mc_vmc_wl_num18_19_bank0_reg.mc_vmc_wl_num18_bank0;
            this.mc_vmc_wl_num18_bank0 = this.mc_vmc_wl_num18_19_bank0_reg.mc_vmc_wl_num18_bank0;

            this.mc_vmc_wl_num18_19_bank0_reg_mc_vmc_wl_num19_bank0 = this.mc_vmc_wl_num18_19_bank0_reg.mc_vmc_wl_num19_bank0;
            this.mc_vmc_wl_num19_bank0 = this.mc_vmc_wl_num18_19_bank0_reg.mc_vmc_wl_num19_bank0;

        this.mc_vmc_wl_num20_21_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num20_21_bank0_reg::type_id::create("mc_vmc_wl_num20_21_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num20_21_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num20_21_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num20_21_bank0_reg, `UVM_REG_ADDR_WIDTH'h44,"RW",0);
            this.mc_vmc_wl_num20_21_bank0_reg_mc_vmc_wl_num20_bank0 = this.mc_vmc_wl_num20_21_bank0_reg.mc_vmc_wl_num20_bank0;
            this.mc_vmc_wl_num20_bank0 = this.mc_vmc_wl_num20_21_bank0_reg.mc_vmc_wl_num20_bank0;

            this.mc_vmc_wl_num20_21_bank0_reg_mc_vmc_wl_num21_bank0 = this.mc_vmc_wl_num20_21_bank0_reg.mc_vmc_wl_num21_bank0;
            this.mc_vmc_wl_num21_bank0 = this.mc_vmc_wl_num20_21_bank0_reg.mc_vmc_wl_num21_bank0;

        this.mc_vmc_wl_num22_23_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num22_23_bank0_reg::type_id::create("mc_vmc_wl_num22_23_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num22_23_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num22_23_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num22_23_bank0_reg, `UVM_REG_ADDR_WIDTH'h48,"RW",0);
            this.mc_vmc_wl_num22_23_bank0_reg_mc_vmc_wl_num22_bank0 = this.mc_vmc_wl_num22_23_bank0_reg.mc_vmc_wl_num22_bank0;
            this.mc_vmc_wl_num22_bank0 = this.mc_vmc_wl_num22_23_bank0_reg.mc_vmc_wl_num22_bank0;

            this.mc_vmc_wl_num22_23_bank0_reg_mc_vmc_wl_num23_bank0 = this.mc_vmc_wl_num22_23_bank0_reg.mc_vmc_wl_num23_bank0;
            this.mc_vmc_wl_num23_bank0 = this.mc_vmc_wl_num22_23_bank0_reg.mc_vmc_wl_num23_bank0;

        this.mc_vmc_wl_num24_25_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num24_25_bank0_reg::type_id::create("mc_vmc_wl_num24_25_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num24_25_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num24_25_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num24_25_bank0_reg, `UVM_REG_ADDR_WIDTH'h4C,"RW",0);
            this.mc_vmc_wl_num24_25_bank0_reg_mc_vmc_wl_num24_bank0 = this.mc_vmc_wl_num24_25_bank0_reg.mc_vmc_wl_num24_bank0;
            this.mc_vmc_wl_num24_bank0 = this.mc_vmc_wl_num24_25_bank0_reg.mc_vmc_wl_num24_bank0;

            this.mc_vmc_wl_num24_25_bank0_reg_mc_vmc_wl_num25_bank0 = this.mc_vmc_wl_num24_25_bank0_reg.mc_vmc_wl_num25_bank0;
            this.mc_vmc_wl_num25_bank0 = this.mc_vmc_wl_num24_25_bank0_reg.mc_vmc_wl_num25_bank0;

        this.mc_vmc_wl_num26_27_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num26_27_bank0_reg::type_id::create("mc_vmc_wl_num26_27_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num26_27_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num26_27_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num26_27_bank0_reg, `UVM_REG_ADDR_WIDTH'h50,"RW",0);
            this.mc_vmc_wl_num26_27_bank0_reg_mc_vmc_wl_num26_bank0 = this.mc_vmc_wl_num26_27_bank0_reg.mc_vmc_wl_num26_bank0;
            this.mc_vmc_wl_num26_bank0 = this.mc_vmc_wl_num26_27_bank0_reg.mc_vmc_wl_num26_bank0;

            this.mc_vmc_wl_num26_27_bank0_reg_mc_vmc_wl_num27_bank0 = this.mc_vmc_wl_num26_27_bank0_reg.mc_vmc_wl_num27_bank0;
            this.mc_vmc_wl_num27_bank0 = this.mc_vmc_wl_num26_27_bank0_reg.mc_vmc_wl_num27_bank0;

        this.mc_vmc_wl_num28_29_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num28_29_bank0_reg::type_id::create("mc_vmc_wl_num28_29_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num28_29_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num28_29_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num28_29_bank0_reg, `UVM_REG_ADDR_WIDTH'h54,"RW",0);
            this.mc_vmc_wl_num28_29_bank0_reg_mc_vmc_wl_num28_bank0 = this.mc_vmc_wl_num28_29_bank0_reg.mc_vmc_wl_num28_bank0;
            this.mc_vmc_wl_num28_bank0 = this.mc_vmc_wl_num28_29_bank0_reg.mc_vmc_wl_num28_bank0;

            this.mc_vmc_wl_num28_29_bank0_reg_mc_vmc_wl_num29_bank0 = this.mc_vmc_wl_num28_29_bank0_reg.mc_vmc_wl_num29_bank0;
            this.mc_vmc_wl_num29_bank0 = this.mc_vmc_wl_num28_29_bank0_reg.mc_vmc_wl_num29_bank0;

        this.mc_vmc_wl_num30_31_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num30_31_bank0_reg::type_id::create("mc_vmc_wl_num30_31_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num30_31_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num30_31_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num30_31_bank0_reg, `UVM_REG_ADDR_WIDTH'h58,"RW",0);
            this.mc_vmc_wl_num30_31_bank0_reg_mc_vmc_wl_num30_bank0 = this.mc_vmc_wl_num30_31_bank0_reg.mc_vmc_wl_num30_bank0;
            this.mc_vmc_wl_num30_bank0 = this.mc_vmc_wl_num30_31_bank0_reg.mc_vmc_wl_num30_bank0;

            this.mc_vmc_wl_num30_31_bank0_reg_mc_vmc_wl_num31_bank0 = this.mc_vmc_wl_num30_31_bank0_reg.mc_vmc_wl_num31_bank0;
            this.mc_vmc_wl_num31_bank0 = this.mc_vmc_wl_num30_31_bank0_reg.mc_vmc_wl_num31_bank0;

        this.mc_vmc_wl_num32_33_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num32_33_bank0_reg::type_id::create("mc_vmc_wl_num32_33_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num32_33_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num32_33_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num32_33_bank0_reg, `UVM_REG_ADDR_WIDTH'h5C,"RW",0);
            this.mc_vmc_wl_num32_33_bank0_reg_mc_vmc_wl_num32_bank0 = this.mc_vmc_wl_num32_33_bank0_reg.mc_vmc_wl_num32_bank0;
            this.mc_vmc_wl_num32_bank0 = this.mc_vmc_wl_num32_33_bank0_reg.mc_vmc_wl_num32_bank0;

            this.mc_vmc_wl_num32_33_bank0_reg_mc_vmc_wl_num33_bank0 = this.mc_vmc_wl_num32_33_bank0_reg.mc_vmc_wl_num33_bank0;
            this.mc_vmc_wl_num33_bank0 = this.mc_vmc_wl_num32_33_bank0_reg.mc_vmc_wl_num33_bank0;

        this.mc_vmc_wl_num34_35_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num34_35_bank0_reg::type_id::create("mc_vmc_wl_num34_35_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num34_35_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num34_35_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num34_35_bank0_reg, `UVM_REG_ADDR_WIDTH'h60,"RW",0);
            this.mc_vmc_wl_num34_35_bank0_reg_mc_vmc_wl_num34_bank0 = this.mc_vmc_wl_num34_35_bank0_reg.mc_vmc_wl_num34_bank0;
            this.mc_vmc_wl_num34_bank0 = this.mc_vmc_wl_num34_35_bank0_reg.mc_vmc_wl_num34_bank0;

            this.mc_vmc_wl_num34_35_bank0_reg_mc_vmc_wl_num35_bank0 = this.mc_vmc_wl_num34_35_bank0_reg.mc_vmc_wl_num35_bank0;
            this.mc_vmc_wl_num35_bank0 = this.mc_vmc_wl_num34_35_bank0_reg.mc_vmc_wl_num35_bank0;

        this.mc_vmc_wl_num36_37_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num36_37_bank0_reg::type_id::create("mc_vmc_wl_num36_37_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num36_37_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num36_37_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num36_37_bank0_reg, `UVM_REG_ADDR_WIDTH'h64,"RW",0);
            this.mc_vmc_wl_num36_37_bank0_reg_mc_vmc_wl_num36_bank0 = this.mc_vmc_wl_num36_37_bank0_reg.mc_vmc_wl_num36_bank0;
            this.mc_vmc_wl_num36_bank0 = this.mc_vmc_wl_num36_37_bank0_reg.mc_vmc_wl_num36_bank0;

            this.mc_vmc_wl_num36_37_bank0_reg_mc_vmc_wl_num37_bank0 = this.mc_vmc_wl_num36_37_bank0_reg.mc_vmc_wl_num37_bank0;
            this.mc_vmc_wl_num37_bank0 = this.mc_vmc_wl_num36_37_bank0_reg.mc_vmc_wl_num37_bank0;

        this.mc_vmc_wl_num38_39_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num38_39_bank0_reg::type_id::create("mc_vmc_wl_num38_39_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num38_39_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num38_39_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num38_39_bank0_reg, `UVM_REG_ADDR_WIDTH'h68,"RW",0);
            this.mc_vmc_wl_num38_39_bank0_reg_mc_vmc_wl_num38_bank0 = this.mc_vmc_wl_num38_39_bank0_reg.mc_vmc_wl_num38_bank0;
            this.mc_vmc_wl_num38_bank0 = this.mc_vmc_wl_num38_39_bank0_reg.mc_vmc_wl_num38_bank0;

            this.mc_vmc_wl_num38_39_bank0_reg_mc_vmc_wl_num39_bank0 = this.mc_vmc_wl_num38_39_bank0_reg.mc_vmc_wl_num39_bank0;
            this.mc_vmc_wl_num39_bank0 = this.mc_vmc_wl_num38_39_bank0_reg.mc_vmc_wl_num39_bank0;

        this.mc_vmc_wl_num40_41_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num40_41_bank0_reg::type_id::create("mc_vmc_wl_num40_41_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num40_41_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num40_41_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num40_41_bank0_reg, `UVM_REG_ADDR_WIDTH'h6C,"RW",0);
            this.mc_vmc_wl_num40_41_bank0_reg_mc_vmc_wl_num40_bank0 = this.mc_vmc_wl_num40_41_bank0_reg.mc_vmc_wl_num40_bank0;
            this.mc_vmc_wl_num40_bank0 = this.mc_vmc_wl_num40_41_bank0_reg.mc_vmc_wl_num40_bank0;

            this.mc_vmc_wl_num40_41_bank0_reg_mc_vmc_wl_num41_bank0 = this.mc_vmc_wl_num40_41_bank0_reg.mc_vmc_wl_num41_bank0;
            this.mc_vmc_wl_num41_bank0 = this.mc_vmc_wl_num40_41_bank0_reg.mc_vmc_wl_num41_bank0;

        this.mc_vmc_wl_num42_43_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num42_43_bank0_reg::type_id::create("mc_vmc_wl_num42_43_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num42_43_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num42_43_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num42_43_bank0_reg, `UVM_REG_ADDR_WIDTH'h70,"RW",0);
            this.mc_vmc_wl_num42_43_bank0_reg_mc_vmc_wl_num42_bank0 = this.mc_vmc_wl_num42_43_bank0_reg.mc_vmc_wl_num42_bank0;
            this.mc_vmc_wl_num42_bank0 = this.mc_vmc_wl_num42_43_bank0_reg.mc_vmc_wl_num42_bank0;

            this.mc_vmc_wl_num42_43_bank0_reg_mc_vmc_wl_num43_bank0 = this.mc_vmc_wl_num42_43_bank0_reg.mc_vmc_wl_num43_bank0;
            this.mc_vmc_wl_num43_bank0 = this.mc_vmc_wl_num42_43_bank0_reg.mc_vmc_wl_num43_bank0;

        this.mc_vmc_wl_num44_45_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num44_45_bank0_reg::type_id::create("mc_vmc_wl_num44_45_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num44_45_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num44_45_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num44_45_bank0_reg, `UVM_REG_ADDR_WIDTH'h74,"RW",0);
            this.mc_vmc_wl_num44_45_bank0_reg_mc_vmc_wl_num44_bank0 = this.mc_vmc_wl_num44_45_bank0_reg.mc_vmc_wl_num44_bank0;
            this.mc_vmc_wl_num44_bank0 = this.mc_vmc_wl_num44_45_bank0_reg.mc_vmc_wl_num44_bank0;

            this.mc_vmc_wl_num44_45_bank0_reg_mc_vmc_wl_num45_bank0 = this.mc_vmc_wl_num44_45_bank0_reg.mc_vmc_wl_num45_bank0;
            this.mc_vmc_wl_num45_bank0 = this.mc_vmc_wl_num44_45_bank0_reg.mc_vmc_wl_num45_bank0;

        this.mc_vmc_wl_num46_47_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num46_47_bank0_reg::type_id::create("mc_vmc_wl_num46_47_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num46_47_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num46_47_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num46_47_bank0_reg, `UVM_REG_ADDR_WIDTH'h78,"RW",0);
            this.mc_vmc_wl_num46_47_bank0_reg_mc_vmc_wl_num46_bank0 = this.mc_vmc_wl_num46_47_bank0_reg.mc_vmc_wl_num46_bank0;
            this.mc_vmc_wl_num46_bank0 = this.mc_vmc_wl_num46_47_bank0_reg.mc_vmc_wl_num46_bank0;

            this.mc_vmc_wl_num46_47_bank0_reg_mc_vmc_wl_num47_bank0 = this.mc_vmc_wl_num46_47_bank0_reg.mc_vmc_wl_num47_bank0;
            this.mc_vmc_wl_num47_bank0 = this.mc_vmc_wl_num46_47_bank0_reg.mc_vmc_wl_num47_bank0;

        this.mc_vmc_wl_num48_49_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num48_49_bank0_reg::type_id::create("mc_vmc_wl_num48_49_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num48_49_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num48_49_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num48_49_bank0_reg, `UVM_REG_ADDR_WIDTH'h7C,"RW",0);
            this.mc_vmc_wl_num48_49_bank0_reg_mc_vmc_wl_num48_bank0 = this.mc_vmc_wl_num48_49_bank0_reg.mc_vmc_wl_num48_bank0;
            this.mc_vmc_wl_num48_bank0 = this.mc_vmc_wl_num48_49_bank0_reg.mc_vmc_wl_num48_bank0;

            this.mc_vmc_wl_num48_49_bank0_reg_mc_vmc_wl_num49_bank0 = this.mc_vmc_wl_num48_49_bank0_reg.mc_vmc_wl_num49_bank0;
            this.mc_vmc_wl_num49_bank0 = this.mc_vmc_wl_num48_49_bank0_reg.mc_vmc_wl_num49_bank0;

        this.mc_vmc_wl_num50_51_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num50_51_bank0_reg::type_id::create("mc_vmc_wl_num50_51_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num50_51_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num50_51_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num50_51_bank0_reg, `UVM_REG_ADDR_WIDTH'h80,"RW",0);
            this.mc_vmc_wl_num50_51_bank0_reg_mc_vmc_wl_num50_bank0 = this.mc_vmc_wl_num50_51_bank0_reg.mc_vmc_wl_num50_bank0;
            this.mc_vmc_wl_num50_bank0 = this.mc_vmc_wl_num50_51_bank0_reg.mc_vmc_wl_num50_bank0;

            this.mc_vmc_wl_num50_51_bank0_reg_mc_vmc_wl_num51_bank0 = this.mc_vmc_wl_num50_51_bank0_reg.mc_vmc_wl_num51_bank0;
            this.mc_vmc_wl_num51_bank0 = this.mc_vmc_wl_num50_51_bank0_reg.mc_vmc_wl_num51_bank0;

        this.mc_vmc_wl_num52_53_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num52_53_bank0_reg::type_id::create("mc_vmc_wl_num52_53_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num52_53_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num52_53_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num52_53_bank0_reg, `UVM_REG_ADDR_WIDTH'h84,"RW",0);
            this.mc_vmc_wl_num52_53_bank0_reg_mc_vmc_wl_num52_bank0 = this.mc_vmc_wl_num52_53_bank0_reg.mc_vmc_wl_num52_bank0;
            this.mc_vmc_wl_num52_bank0 = this.mc_vmc_wl_num52_53_bank0_reg.mc_vmc_wl_num52_bank0;

            this.mc_vmc_wl_num52_53_bank0_reg_mc_vmc_wl_num53_bank0 = this.mc_vmc_wl_num52_53_bank0_reg.mc_vmc_wl_num53_bank0;
            this.mc_vmc_wl_num53_bank0 = this.mc_vmc_wl_num52_53_bank0_reg.mc_vmc_wl_num53_bank0;

        this.mc_vmc_wl_num54_55_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num54_55_bank0_reg::type_id::create("mc_vmc_wl_num54_55_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num54_55_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num54_55_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num54_55_bank0_reg, `UVM_REG_ADDR_WIDTH'h88,"RW",0);
            this.mc_vmc_wl_num54_55_bank0_reg_mc_vmc_wl_num54_bank0 = this.mc_vmc_wl_num54_55_bank0_reg.mc_vmc_wl_num54_bank0;
            this.mc_vmc_wl_num54_bank0 = this.mc_vmc_wl_num54_55_bank0_reg.mc_vmc_wl_num54_bank0;

            this.mc_vmc_wl_num54_55_bank0_reg_mc_vmc_wl_num55_bank0 = this.mc_vmc_wl_num54_55_bank0_reg.mc_vmc_wl_num55_bank0;
            this.mc_vmc_wl_num55_bank0 = this.mc_vmc_wl_num54_55_bank0_reg.mc_vmc_wl_num55_bank0;

        this.mc_vmc_wl_num56_57_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num56_57_bank0_reg::type_id::create("mc_vmc_wl_num56_57_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num56_57_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num56_57_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num56_57_bank0_reg, `UVM_REG_ADDR_WIDTH'h8C,"RW",0);
            this.mc_vmc_wl_num56_57_bank0_reg_mc_vmc_wl_num56_bank0 = this.mc_vmc_wl_num56_57_bank0_reg.mc_vmc_wl_num56_bank0;
            this.mc_vmc_wl_num56_bank0 = this.mc_vmc_wl_num56_57_bank0_reg.mc_vmc_wl_num56_bank0;

            this.mc_vmc_wl_num56_57_bank0_reg_mc_vmc_wl_num57_bank0 = this.mc_vmc_wl_num56_57_bank0_reg.mc_vmc_wl_num57_bank0;
            this.mc_vmc_wl_num57_bank0 = this.mc_vmc_wl_num56_57_bank0_reg.mc_vmc_wl_num57_bank0;

        this.mc_vmc_wl_num58_59_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num58_59_bank0_reg::type_id::create("mc_vmc_wl_num58_59_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num58_59_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num58_59_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num58_59_bank0_reg, `UVM_REG_ADDR_WIDTH'h90,"RW",0);
            this.mc_vmc_wl_num58_59_bank0_reg_mc_vmc_wl_num58_bank0 = this.mc_vmc_wl_num58_59_bank0_reg.mc_vmc_wl_num58_bank0;
            this.mc_vmc_wl_num58_bank0 = this.mc_vmc_wl_num58_59_bank0_reg.mc_vmc_wl_num58_bank0;

            this.mc_vmc_wl_num58_59_bank0_reg_mc_vmc_wl_num59_bank0 = this.mc_vmc_wl_num58_59_bank0_reg.mc_vmc_wl_num59_bank0;
            this.mc_vmc_wl_num59_bank0 = this.mc_vmc_wl_num58_59_bank0_reg.mc_vmc_wl_num59_bank0;

        this.mc_vmc_wl_num60_61_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num60_61_bank0_reg::type_id::create("mc_vmc_wl_num60_61_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num60_61_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num60_61_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num60_61_bank0_reg, `UVM_REG_ADDR_WIDTH'h94,"RW",0);
            this.mc_vmc_wl_num60_61_bank0_reg_mc_vmc_wl_num60_bank0 = this.mc_vmc_wl_num60_61_bank0_reg.mc_vmc_wl_num60_bank0;
            this.mc_vmc_wl_num60_bank0 = this.mc_vmc_wl_num60_61_bank0_reg.mc_vmc_wl_num60_bank0;

            this.mc_vmc_wl_num60_61_bank0_reg_mc_vmc_wl_num61_bank0 = this.mc_vmc_wl_num60_61_bank0_reg.mc_vmc_wl_num61_bank0;
            this.mc_vmc_wl_num61_bank0 = this.mc_vmc_wl_num60_61_bank0_reg.mc_vmc_wl_num61_bank0;

        this.mc_vmc_wl_num62_63_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num62_63_bank0_reg::type_id::create("mc_vmc_wl_num62_63_bank0_reg",,get_full_name());
        this.mc_vmc_wl_num62_63_bank0_reg.configure(this, null, "");
        this.mc_vmc_wl_num62_63_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num62_63_bank0_reg, `UVM_REG_ADDR_WIDTH'h98,"RW",0);
            this.mc_vmc_wl_num62_63_bank0_reg_mc_vmc_wl_num62_bank0 = this.mc_vmc_wl_num62_63_bank0_reg.mc_vmc_wl_num62_bank0;
            this.mc_vmc_wl_num62_bank0 = this.mc_vmc_wl_num62_63_bank0_reg.mc_vmc_wl_num62_bank0;

            this.mc_vmc_wl_num62_63_bank0_reg_mc_vmc_wl_num63_bank0 = this.mc_vmc_wl_num62_63_bank0_reg.mc_vmc_wl_num63_bank0;
            this.mc_vmc_wl_num63_bank0 = this.mc_vmc_wl_num62_63_bank0_reg.mc_vmc_wl_num63_bank0;

        this.mc_vmc_bl_num0_part0_1_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part0_1_bank0_reg::type_id::create("mc_vmc_bl_num0_part0_1_bank0_reg",,get_full_name());
        this.mc_vmc_bl_num0_part0_1_bank0_reg.configure(this, null, "");
        this.mc_vmc_bl_num0_part0_1_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num0_part0_1_bank0_reg, `UVM_REG_ADDR_WIDTH'h9C,"RW",0);
            this.mc_vmc_bl_num0_part0_1_bank0_reg_mc_vmc_bl_num0_part0_bank0 = this.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num0_part0_bank0;
            this.mc_vmc_bl_num0_part0_bank0 = this.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num0_part0_bank0;

            this.mc_vmc_bl_num0_part0_1_bank0_reg_mc_vmc_bl_num1_part0_bank0 = this.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num1_part0_bank0;
            this.mc_vmc_bl_num1_part0_bank0 = this.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num1_part0_bank0;

            this.mc_vmc_bl_num0_part0_1_bank0_reg_mc_vmc_bl_num0_part1_bank0 = this.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num0_part1_bank0;
            this.mc_vmc_bl_num0_part1_bank0 = this.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num0_part1_bank0;

            this.mc_vmc_bl_num0_part0_1_bank0_reg_mc_vmc_bl_num1_part1_bank0 = this.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num1_part1_bank0;
            this.mc_vmc_bl_num1_part1_bank0 = this.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num1_part1_bank0;

        this.mc_vmc_bl_num0_part2_3_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part2_3_bank0_reg::type_id::create("mc_vmc_bl_num0_part2_3_bank0_reg",,get_full_name());
        this.mc_vmc_bl_num0_part2_3_bank0_reg.configure(this, null, "");
        this.mc_vmc_bl_num0_part2_3_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num0_part2_3_bank0_reg, `UVM_REG_ADDR_WIDTH'hA0,"RW",0);
            this.mc_vmc_bl_num0_part2_3_bank0_reg_mc_vmc_bl_num0_part2_bank0 = this.mc_vmc_bl_num0_part2_3_bank0_reg.mc_vmc_bl_num0_part2_bank0;
            this.mc_vmc_bl_num0_part2_bank0 = this.mc_vmc_bl_num0_part2_3_bank0_reg.mc_vmc_bl_num0_part2_bank0;

            this.mc_vmc_bl_num0_part2_3_bank0_reg_mc_vmc_bl_num1_part2_bank0 = this.mc_vmc_bl_num0_part2_3_bank0_reg.mc_vmc_bl_num1_part2_bank0;
            this.mc_vmc_bl_num1_part2_bank0 = this.mc_vmc_bl_num0_part2_3_bank0_reg.mc_vmc_bl_num1_part2_bank0;

            this.mc_vmc_bl_num0_part2_3_bank0_reg_mc_vmc_bl_num0_part3_bank0 = this.mc_vmc_bl_num0_part2_3_bank0_reg.mc_vmc_bl_num0_part3_bank0;
            this.mc_vmc_bl_num0_part3_bank0 = this.mc_vmc_bl_num0_part2_3_bank0_reg.mc_vmc_bl_num0_part3_bank0;

            this.mc_vmc_bl_num0_part2_3_bank0_reg_mc_vmc_bl_num1_part3_bank0 = this.mc_vmc_bl_num0_part2_3_bank0_reg.mc_vmc_bl_num1_part3_bank0;
            this.mc_vmc_bl_num1_part3_bank0 = this.mc_vmc_bl_num0_part2_3_bank0_reg.mc_vmc_bl_num1_part3_bank0;

        this.mc_vmc_bl_num0_part4_5_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part4_5_bank0_reg::type_id::create("mc_vmc_bl_num0_part4_5_bank0_reg",,get_full_name());
        this.mc_vmc_bl_num0_part4_5_bank0_reg.configure(this, null, "");
        this.mc_vmc_bl_num0_part4_5_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num0_part4_5_bank0_reg, `UVM_REG_ADDR_WIDTH'hA4,"RW",0);
            this.mc_vmc_bl_num0_part4_5_bank0_reg_mc_vmc_bl_num0_part4_bank0 = this.mc_vmc_bl_num0_part4_5_bank0_reg.mc_vmc_bl_num0_part4_bank0;
            this.mc_vmc_bl_num0_part4_bank0 = this.mc_vmc_bl_num0_part4_5_bank0_reg.mc_vmc_bl_num0_part4_bank0;

            this.mc_vmc_bl_num0_part4_5_bank0_reg_mc_vmc_bl_num1_part4_bank0 = this.mc_vmc_bl_num0_part4_5_bank0_reg.mc_vmc_bl_num1_part4_bank0;
            this.mc_vmc_bl_num1_part4_bank0 = this.mc_vmc_bl_num0_part4_5_bank0_reg.mc_vmc_bl_num1_part4_bank0;

            this.mc_vmc_bl_num0_part4_5_bank0_reg_mc_vmc_bl_num0_part5_bank0 = this.mc_vmc_bl_num0_part4_5_bank0_reg.mc_vmc_bl_num0_part5_bank0;
            this.mc_vmc_bl_num0_part5_bank0 = this.mc_vmc_bl_num0_part4_5_bank0_reg.mc_vmc_bl_num0_part5_bank0;

            this.mc_vmc_bl_num0_part4_5_bank0_reg_mc_vmc_bl_num1_part5_bank0 = this.mc_vmc_bl_num0_part4_5_bank0_reg.mc_vmc_bl_num1_part5_bank0;
            this.mc_vmc_bl_num1_part5_bank0 = this.mc_vmc_bl_num0_part4_5_bank0_reg.mc_vmc_bl_num1_part5_bank0;

        this.mc_vmc_bl_num0_part6_7_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part6_7_bank0_reg::type_id::create("mc_vmc_bl_num0_part6_7_bank0_reg",,get_full_name());
        this.mc_vmc_bl_num0_part6_7_bank0_reg.configure(this, null, "");
        this.mc_vmc_bl_num0_part6_7_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num0_part6_7_bank0_reg, `UVM_REG_ADDR_WIDTH'hA8,"RW",0);
            this.mc_vmc_bl_num0_part6_7_bank0_reg_mc_vmc_bl_num0_part6_bank0 = this.mc_vmc_bl_num0_part6_7_bank0_reg.mc_vmc_bl_num0_part6_bank0;
            this.mc_vmc_bl_num0_part6_bank0 = this.mc_vmc_bl_num0_part6_7_bank0_reg.mc_vmc_bl_num0_part6_bank0;

            this.mc_vmc_bl_num0_part6_7_bank0_reg_mc_vmc_bl_num1_part6_bank0 = this.mc_vmc_bl_num0_part6_7_bank0_reg.mc_vmc_bl_num1_part6_bank0;
            this.mc_vmc_bl_num1_part6_bank0 = this.mc_vmc_bl_num0_part6_7_bank0_reg.mc_vmc_bl_num1_part6_bank0;

            this.mc_vmc_bl_num0_part6_7_bank0_reg_mc_vmc_bl_num0_part7_bank0 = this.mc_vmc_bl_num0_part6_7_bank0_reg.mc_vmc_bl_num0_part7_bank0;
            this.mc_vmc_bl_num0_part7_bank0 = this.mc_vmc_bl_num0_part6_7_bank0_reg.mc_vmc_bl_num0_part7_bank0;

            this.mc_vmc_bl_num0_part6_7_bank0_reg_mc_vmc_bl_num1_part7_bank0 = this.mc_vmc_bl_num0_part6_7_bank0_reg.mc_vmc_bl_num1_part7_bank0;
            this.mc_vmc_bl_num1_part7_bank0 = this.mc_vmc_bl_num0_part6_7_bank0_reg.mc_vmc_bl_num1_part7_bank0;

        this.mc_vmc_bl_num0_part8_9_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part8_9_bank0_reg::type_id::create("mc_vmc_bl_num0_part8_9_bank0_reg",,get_full_name());
        this.mc_vmc_bl_num0_part8_9_bank0_reg.configure(this, null, "");
        this.mc_vmc_bl_num0_part8_9_bank0_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num0_part8_9_bank0_reg, `UVM_REG_ADDR_WIDTH'hAC,"RW",0);
            this.mc_vmc_bl_num0_part8_9_bank0_reg_mc_vmc_bl_num0_part8_bank0 = this.mc_vmc_bl_num0_part8_9_bank0_reg.mc_vmc_bl_num0_part8_bank0;
            this.mc_vmc_bl_num0_part8_bank0 = this.mc_vmc_bl_num0_part8_9_bank0_reg.mc_vmc_bl_num0_part8_bank0;

            this.mc_vmc_bl_num0_part8_9_bank0_reg_mc_vmc_bl_num1_part8_bank0 = this.mc_vmc_bl_num0_part8_9_bank0_reg.mc_vmc_bl_num1_part8_bank0;
            this.mc_vmc_bl_num1_part8_bank0 = this.mc_vmc_bl_num0_part8_9_bank0_reg.mc_vmc_bl_num1_part8_bank0;

            this.mc_vmc_bl_num0_part8_9_bank0_reg_mc_vmc_bl_num0_part9_bank0 = this.mc_vmc_bl_num0_part8_9_bank0_reg.mc_vmc_bl_num0_part9_bank0;
            this.mc_vmc_bl_num0_part9_bank0 = this.mc_vmc_bl_num0_part8_9_bank0_reg.mc_vmc_bl_num0_part9_bank0;

            this.mc_vmc_bl_num0_part8_9_bank0_reg_mc_vmc_bl_num1_part9_bank0 = this.mc_vmc_bl_num0_part8_9_bank0_reg.mc_vmc_bl_num1_part9_bank0;
            this.mc_vmc_bl_num1_part9_bank0 = this.mc_vmc_bl_num0_part8_9_bank0_reg.mc_vmc_bl_num1_part9_bank0;

        this.err_wl0_1_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl0_1_bank0_reg::type_id::create("err_wl0_1_bank0_reg",,get_full_name());
        this.err_wl0_1_bank0_reg.configure(this, null, "");
        this.err_wl0_1_bank0_reg.build();
        this.default_map.add_reg(this.err_wl0_1_bank0_reg, `UVM_REG_ADDR_WIDTH'hB0,"RW",0);
            this.err_wl0_1_bank0_reg_err_wl0_bank0 = this.err_wl0_1_bank0_reg.err_wl0_bank0;
            this.err_wl0_bank0 = this.err_wl0_1_bank0_reg.err_wl0_bank0;

            this.err_wl0_1_bank0_reg_err_wl1_bank0 = this.err_wl0_1_bank0_reg.err_wl1_bank0;
            this.err_wl1_bank0 = this.err_wl0_1_bank0_reg.err_wl1_bank0;

        this.err_wl2_3_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl2_3_bank0_reg::type_id::create("err_wl2_3_bank0_reg",,get_full_name());
        this.err_wl2_3_bank0_reg.configure(this, null, "");
        this.err_wl2_3_bank0_reg.build();
        this.default_map.add_reg(this.err_wl2_3_bank0_reg, `UVM_REG_ADDR_WIDTH'hB4,"RW",0);
            this.err_wl2_3_bank0_reg_err_wl2_bank0 = this.err_wl2_3_bank0_reg.err_wl2_bank0;
            this.err_wl2_bank0 = this.err_wl2_3_bank0_reg.err_wl2_bank0;

            this.err_wl2_3_bank0_reg_err_wl3_bank0 = this.err_wl2_3_bank0_reg.err_wl3_bank0;
            this.err_wl3_bank0 = this.err_wl2_3_bank0_reg.err_wl3_bank0;

        this.err_wl4_5_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl4_5_bank0_reg::type_id::create("err_wl4_5_bank0_reg",,get_full_name());
        this.err_wl4_5_bank0_reg.configure(this, null, "");
        this.err_wl4_5_bank0_reg.build();
        this.default_map.add_reg(this.err_wl4_5_bank0_reg, `UVM_REG_ADDR_WIDTH'hB8,"RW",0);
            this.err_wl4_5_bank0_reg_err_wl4_bank0 = this.err_wl4_5_bank0_reg.err_wl4_bank0;
            this.err_wl4_bank0 = this.err_wl4_5_bank0_reg.err_wl4_bank0;

            this.err_wl4_5_bank0_reg_err_wl5_bank0 = this.err_wl4_5_bank0_reg.err_wl5_bank0;
            this.err_wl5_bank0 = this.err_wl4_5_bank0_reg.err_wl5_bank0;

        this.err_wl6_7_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl6_7_bank0_reg::type_id::create("err_wl6_7_bank0_reg",,get_full_name());
        this.err_wl6_7_bank0_reg.configure(this, null, "");
        this.err_wl6_7_bank0_reg.build();
        this.default_map.add_reg(this.err_wl6_7_bank0_reg, `UVM_REG_ADDR_WIDTH'hBC,"RW",0);
            this.err_wl6_7_bank0_reg_err_wl6_bank0 = this.err_wl6_7_bank0_reg.err_wl6_bank0;
            this.err_wl6_bank0 = this.err_wl6_7_bank0_reg.err_wl6_bank0;

            this.err_wl6_7_bank0_reg_err_wl7_bank0 = this.err_wl6_7_bank0_reg.err_wl7_bank0;
            this.err_wl7_bank0 = this.err_wl6_7_bank0_reg.err_wl7_bank0;

        this.err_wl8_9_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl8_9_bank0_reg::type_id::create("err_wl8_9_bank0_reg",,get_full_name());
        this.err_wl8_9_bank0_reg.configure(this, null, "");
        this.err_wl8_9_bank0_reg.build();
        this.default_map.add_reg(this.err_wl8_9_bank0_reg, `UVM_REG_ADDR_WIDTH'hC0,"RW",0);
            this.err_wl8_9_bank0_reg_err_wl8_bank0 = this.err_wl8_9_bank0_reg.err_wl8_bank0;
            this.err_wl8_bank0 = this.err_wl8_9_bank0_reg.err_wl8_bank0;

            this.err_wl8_9_bank0_reg_err_wl9_bank0 = this.err_wl8_9_bank0_reg.err_wl9_bank0;
            this.err_wl9_bank0 = this.err_wl8_9_bank0_reg.err_wl9_bank0;

        this.err_wl10_11_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl10_11_bank0_reg::type_id::create("err_wl10_11_bank0_reg",,get_full_name());
        this.err_wl10_11_bank0_reg.configure(this, null, "");
        this.err_wl10_11_bank0_reg.build();
        this.default_map.add_reg(this.err_wl10_11_bank0_reg, `UVM_REG_ADDR_WIDTH'hC4,"RW",0);
            this.err_wl10_11_bank0_reg_err_wl10_bank0 = this.err_wl10_11_bank0_reg.err_wl10_bank0;
            this.err_wl10_bank0 = this.err_wl10_11_bank0_reg.err_wl10_bank0;

            this.err_wl10_11_bank0_reg_err_wl11_bank0 = this.err_wl10_11_bank0_reg.err_wl11_bank0;
            this.err_wl11_bank0 = this.err_wl10_11_bank0_reg.err_wl11_bank0;

        this.err_wl12_13_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl12_13_bank0_reg::type_id::create("err_wl12_13_bank0_reg",,get_full_name());
        this.err_wl12_13_bank0_reg.configure(this, null, "");
        this.err_wl12_13_bank0_reg.build();
        this.default_map.add_reg(this.err_wl12_13_bank0_reg, `UVM_REG_ADDR_WIDTH'hC8,"RW",0);
            this.err_wl12_13_bank0_reg_err_wl12_bank0 = this.err_wl12_13_bank0_reg.err_wl12_bank0;
            this.err_wl12_bank0 = this.err_wl12_13_bank0_reg.err_wl12_bank0;

            this.err_wl12_13_bank0_reg_err_wl13_bank0 = this.err_wl12_13_bank0_reg.err_wl13_bank0;
            this.err_wl13_bank0 = this.err_wl12_13_bank0_reg.err_wl13_bank0;

        this.err_wl14_15_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl14_15_bank0_reg::type_id::create("err_wl14_15_bank0_reg",,get_full_name());
        this.err_wl14_15_bank0_reg.configure(this, null, "");
        this.err_wl14_15_bank0_reg.build();
        this.default_map.add_reg(this.err_wl14_15_bank0_reg, `UVM_REG_ADDR_WIDTH'hCC,"RW",0);
            this.err_wl14_15_bank0_reg_err_wl14_bank0 = this.err_wl14_15_bank0_reg.err_wl14_bank0;
            this.err_wl14_bank0 = this.err_wl14_15_bank0_reg.err_wl14_bank0;

            this.err_wl14_15_bank0_reg_err_wl15_bank0 = this.err_wl14_15_bank0_reg.err_wl15_bank0;
            this.err_wl15_bank0 = this.err_wl14_15_bank0_reg.err_wl15_bank0;

        this.err_wl16_17_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl16_17_bank0_reg::type_id::create("err_wl16_17_bank0_reg",,get_full_name());
        this.err_wl16_17_bank0_reg.configure(this, null, "");
        this.err_wl16_17_bank0_reg.build();
        this.default_map.add_reg(this.err_wl16_17_bank0_reg, `UVM_REG_ADDR_WIDTH'hD0,"RW",0);
            this.err_wl16_17_bank0_reg_err_wl16_bank0 = this.err_wl16_17_bank0_reg.err_wl16_bank0;
            this.err_wl16_bank0 = this.err_wl16_17_bank0_reg.err_wl16_bank0;

            this.err_wl16_17_bank0_reg_err_wl17_bank0 = this.err_wl16_17_bank0_reg.err_wl17_bank0;
            this.err_wl17_bank0 = this.err_wl16_17_bank0_reg.err_wl17_bank0;

        this.err_wl18_19_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl18_19_bank0_reg::type_id::create("err_wl18_19_bank0_reg",,get_full_name());
        this.err_wl18_19_bank0_reg.configure(this, null, "");
        this.err_wl18_19_bank0_reg.build();
        this.default_map.add_reg(this.err_wl18_19_bank0_reg, `UVM_REG_ADDR_WIDTH'hD4,"RW",0);
            this.err_wl18_19_bank0_reg_err_wl18_bank0 = this.err_wl18_19_bank0_reg.err_wl18_bank0;
            this.err_wl18_bank0 = this.err_wl18_19_bank0_reg.err_wl18_bank0;

            this.err_wl18_19_bank0_reg_err_wl19_bank0 = this.err_wl18_19_bank0_reg.err_wl19_bank0;
            this.err_wl19_bank0 = this.err_wl18_19_bank0_reg.err_wl19_bank0;

        this.err_wl20_21_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl20_21_bank0_reg::type_id::create("err_wl20_21_bank0_reg",,get_full_name());
        this.err_wl20_21_bank0_reg.configure(this, null, "");
        this.err_wl20_21_bank0_reg.build();
        this.default_map.add_reg(this.err_wl20_21_bank0_reg, `UVM_REG_ADDR_WIDTH'hD8,"RW",0);
            this.err_wl20_21_bank0_reg_err_wl20_bank0 = this.err_wl20_21_bank0_reg.err_wl20_bank0;
            this.err_wl20_bank0 = this.err_wl20_21_bank0_reg.err_wl20_bank0;

            this.err_wl20_21_bank0_reg_err_wl21_bank0 = this.err_wl20_21_bank0_reg.err_wl21_bank0;
            this.err_wl21_bank0 = this.err_wl20_21_bank0_reg.err_wl21_bank0;

        this.err_wl22_23_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl22_23_bank0_reg::type_id::create("err_wl22_23_bank0_reg",,get_full_name());
        this.err_wl22_23_bank0_reg.configure(this, null, "");
        this.err_wl22_23_bank0_reg.build();
        this.default_map.add_reg(this.err_wl22_23_bank0_reg, `UVM_REG_ADDR_WIDTH'hDC,"RW",0);
            this.err_wl22_23_bank0_reg_err_wl22_bank0 = this.err_wl22_23_bank0_reg.err_wl22_bank0;
            this.err_wl22_bank0 = this.err_wl22_23_bank0_reg.err_wl22_bank0;

            this.err_wl22_23_bank0_reg_err_wl23_bank0 = this.err_wl22_23_bank0_reg.err_wl23_bank0;
            this.err_wl23_bank0 = this.err_wl22_23_bank0_reg.err_wl23_bank0;

        this.err_wl24_25_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl24_25_bank0_reg::type_id::create("err_wl24_25_bank0_reg",,get_full_name());
        this.err_wl24_25_bank0_reg.configure(this, null, "");
        this.err_wl24_25_bank0_reg.build();
        this.default_map.add_reg(this.err_wl24_25_bank0_reg, `UVM_REG_ADDR_WIDTH'hE0,"RW",0);
            this.err_wl24_25_bank0_reg_err_wl24_bank0 = this.err_wl24_25_bank0_reg.err_wl24_bank0;
            this.err_wl24_bank0 = this.err_wl24_25_bank0_reg.err_wl24_bank0;

            this.err_wl24_25_bank0_reg_err_wl25_bank0 = this.err_wl24_25_bank0_reg.err_wl25_bank0;
            this.err_wl25_bank0 = this.err_wl24_25_bank0_reg.err_wl25_bank0;

        this.err_wl26_27_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl26_27_bank0_reg::type_id::create("err_wl26_27_bank0_reg",,get_full_name());
        this.err_wl26_27_bank0_reg.configure(this, null, "");
        this.err_wl26_27_bank0_reg.build();
        this.default_map.add_reg(this.err_wl26_27_bank0_reg, `UVM_REG_ADDR_WIDTH'hE4,"RW",0);
            this.err_wl26_27_bank0_reg_err_wl26_bank0 = this.err_wl26_27_bank0_reg.err_wl26_bank0;
            this.err_wl26_bank0 = this.err_wl26_27_bank0_reg.err_wl26_bank0;

            this.err_wl26_27_bank0_reg_err_wl27_bank0 = this.err_wl26_27_bank0_reg.err_wl27_bank0;
            this.err_wl27_bank0 = this.err_wl26_27_bank0_reg.err_wl27_bank0;

        this.err_wl28_29_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl28_29_bank0_reg::type_id::create("err_wl28_29_bank0_reg",,get_full_name());
        this.err_wl28_29_bank0_reg.configure(this, null, "");
        this.err_wl28_29_bank0_reg.build();
        this.default_map.add_reg(this.err_wl28_29_bank0_reg, `UVM_REG_ADDR_WIDTH'hE8,"RW",0);
            this.err_wl28_29_bank0_reg_err_wl28_bank0 = this.err_wl28_29_bank0_reg.err_wl28_bank0;
            this.err_wl28_bank0 = this.err_wl28_29_bank0_reg.err_wl28_bank0;

            this.err_wl28_29_bank0_reg_err_wl29_bank0 = this.err_wl28_29_bank0_reg.err_wl29_bank0;
            this.err_wl29_bank0 = this.err_wl28_29_bank0_reg.err_wl29_bank0;

        this.err_wl30_31_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl30_31_bank0_reg::type_id::create("err_wl30_31_bank0_reg",,get_full_name());
        this.err_wl30_31_bank0_reg.configure(this, null, "");
        this.err_wl30_31_bank0_reg.build();
        this.default_map.add_reg(this.err_wl30_31_bank0_reg, `UVM_REG_ADDR_WIDTH'hEC,"RW",0);
            this.err_wl30_31_bank0_reg_err_wl30_bank0 = this.err_wl30_31_bank0_reg.err_wl30_bank0;
            this.err_wl30_bank0 = this.err_wl30_31_bank0_reg.err_wl30_bank0;

            this.err_wl30_31_bank0_reg_err_wl31_bank0 = this.err_wl30_31_bank0_reg.err_wl31_bank0;
            this.err_wl31_bank0 = this.err_wl30_31_bank0_reg.err_wl31_bank0;

        this.err_wl32_33_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl32_33_bank0_reg::type_id::create("err_wl32_33_bank0_reg",,get_full_name());
        this.err_wl32_33_bank0_reg.configure(this, null, "");
        this.err_wl32_33_bank0_reg.build();
        this.default_map.add_reg(this.err_wl32_33_bank0_reg, `UVM_REG_ADDR_WIDTH'hF0,"RW",0);
            this.err_wl32_33_bank0_reg_err_wl32_bank0 = this.err_wl32_33_bank0_reg.err_wl32_bank0;
            this.err_wl32_bank0 = this.err_wl32_33_bank0_reg.err_wl32_bank0;

            this.err_wl32_33_bank0_reg_err_wl33_bank0 = this.err_wl32_33_bank0_reg.err_wl33_bank0;
            this.err_wl33_bank0 = this.err_wl32_33_bank0_reg.err_wl33_bank0;

        this.err_wl34_35_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl34_35_bank0_reg::type_id::create("err_wl34_35_bank0_reg",,get_full_name());
        this.err_wl34_35_bank0_reg.configure(this, null, "");
        this.err_wl34_35_bank0_reg.build();
        this.default_map.add_reg(this.err_wl34_35_bank0_reg, `UVM_REG_ADDR_WIDTH'hF4,"RW",0);
            this.err_wl34_35_bank0_reg_err_wl34_bank0 = this.err_wl34_35_bank0_reg.err_wl34_bank0;
            this.err_wl34_bank0 = this.err_wl34_35_bank0_reg.err_wl34_bank0;

            this.err_wl34_35_bank0_reg_err_wl35_bank0 = this.err_wl34_35_bank0_reg.err_wl35_bank0;
            this.err_wl35_bank0 = this.err_wl34_35_bank0_reg.err_wl35_bank0;

        this.err_wl36_37_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl36_37_bank0_reg::type_id::create("err_wl36_37_bank0_reg",,get_full_name());
        this.err_wl36_37_bank0_reg.configure(this, null, "");
        this.err_wl36_37_bank0_reg.build();
        this.default_map.add_reg(this.err_wl36_37_bank0_reg, `UVM_REG_ADDR_WIDTH'hF8,"RW",0);
            this.err_wl36_37_bank0_reg_err_wl36_bank0 = this.err_wl36_37_bank0_reg.err_wl36_bank0;
            this.err_wl36_bank0 = this.err_wl36_37_bank0_reg.err_wl36_bank0;

            this.err_wl36_37_bank0_reg_err_wl37_bank0 = this.err_wl36_37_bank0_reg.err_wl37_bank0;
            this.err_wl37_bank0 = this.err_wl36_37_bank0_reg.err_wl37_bank0;

        this.err_wl38_39_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl38_39_bank0_reg::type_id::create("err_wl38_39_bank0_reg",,get_full_name());
        this.err_wl38_39_bank0_reg.configure(this, null, "");
        this.err_wl38_39_bank0_reg.build();
        this.default_map.add_reg(this.err_wl38_39_bank0_reg, `UVM_REG_ADDR_WIDTH'hFC,"RW",0);
            this.err_wl38_39_bank0_reg_err_wl38_bank0 = this.err_wl38_39_bank0_reg.err_wl38_bank0;
            this.err_wl38_bank0 = this.err_wl38_39_bank0_reg.err_wl38_bank0;

            this.err_wl38_39_bank0_reg_err_wl39_bank0 = this.err_wl38_39_bank0_reg.err_wl39_bank0;
            this.err_wl39_bank0 = this.err_wl38_39_bank0_reg.err_wl39_bank0;

        this.err_wl40_41_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl40_41_bank0_reg::type_id::create("err_wl40_41_bank0_reg",,get_full_name());
        this.err_wl40_41_bank0_reg.configure(this, null, "");
        this.err_wl40_41_bank0_reg.build();
        this.default_map.add_reg(this.err_wl40_41_bank0_reg, `UVM_REG_ADDR_WIDTH'h100,"RW",0);
            this.err_wl40_41_bank0_reg_err_wl40_bank0 = this.err_wl40_41_bank0_reg.err_wl40_bank0;
            this.err_wl40_bank0 = this.err_wl40_41_bank0_reg.err_wl40_bank0;

            this.err_wl40_41_bank0_reg_err_wl41_bank0 = this.err_wl40_41_bank0_reg.err_wl41_bank0;
            this.err_wl41_bank0 = this.err_wl40_41_bank0_reg.err_wl41_bank0;

        this.err_wl42_43_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl42_43_bank0_reg::type_id::create("err_wl42_43_bank0_reg",,get_full_name());
        this.err_wl42_43_bank0_reg.configure(this, null, "");
        this.err_wl42_43_bank0_reg.build();
        this.default_map.add_reg(this.err_wl42_43_bank0_reg, `UVM_REG_ADDR_WIDTH'h104,"RW",0);
            this.err_wl42_43_bank0_reg_err_wl42_bank0 = this.err_wl42_43_bank0_reg.err_wl42_bank0;
            this.err_wl42_bank0 = this.err_wl42_43_bank0_reg.err_wl42_bank0;

            this.err_wl42_43_bank0_reg_err_wl43_bank0 = this.err_wl42_43_bank0_reg.err_wl43_bank0;
            this.err_wl43_bank0 = this.err_wl42_43_bank0_reg.err_wl43_bank0;

        this.err_wl44_45_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl44_45_bank0_reg::type_id::create("err_wl44_45_bank0_reg",,get_full_name());
        this.err_wl44_45_bank0_reg.configure(this, null, "");
        this.err_wl44_45_bank0_reg.build();
        this.default_map.add_reg(this.err_wl44_45_bank0_reg, `UVM_REG_ADDR_WIDTH'h108,"RW",0);
            this.err_wl44_45_bank0_reg_err_wl44_bank0 = this.err_wl44_45_bank0_reg.err_wl44_bank0;
            this.err_wl44_bank0 = this.err_wl44_45_bank0_reg.err_wl44_bank0;

            this.err_wl44_45_bank0_reg_err_wl45_bank0 = this.err_wl44_45_bank0_reg.err_wl45_bank0;
            this.err_wl45_bank0 = this.err_wl44_45_bank0_reg.err_wl45_bank0;

        this.err_wl46_47_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl46_47_bank0_reg::type_id::create("err_wl46_47_bank0_reg",,get_full_name());
        this.err_wl46_47_bank0_reg.configure(this, null, "");
        this.err_wl46_47_bank0_reg.build();
        this.default_map.add_reg(this.err_wl46_47_bank0_reg, `UVM_REG_ADDR_WIDTH'h10C,"RW",0);
            this.err_wl46_47_bank0_reg_err_wl46_bank0 = this.err_wl46_47_bank0_reg.err_wl46_bank0;
            this.err_wl46_bank0 = this.err_wl46_47_bank0_reg.err_wl46_bank0;

            this.err_wl46_47_bank0_reg_err_wl47_bank0 = this.err_wl46_47_bank0_reg.err_wl47_bank0;
            this.err_wl47_bank0 = this.err_wl46_47_bank0_reg.err_wl47_bank0;

        this.err_wl48_49_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl48_49_bank0_reg::type_id::create("err_wl48_49_bank0_reg",,get_full_name());
        this.err_wl48_49_bank0_reg.configure(this, null, "");
        this.err_wl48_49_bank0_reg.build();
        this.default_map.add_reg(this.err_wl48_49_bank0_reg, `UVM_REG_ADDR_WIDTH'h110,"RW",0);
            this.err_wl48_49_bank0_reg_err_wl48_bank0 = this.err_wl48_49_bank0_reg.err_wl48_bank0;
            this.err_wl48_bank0 = this.err_wl48_49_bank0_reg.err_wl48_bank0;

            this.err_wl48_49_bank0_reg_err_wl49_bank0 = this.err_wl48_49_bank0_reg.err_wl49_bank0;
            this.err_wl49_bank0 = this.err_wl48_49_bank0_reg.err_wl49_bank0;

        this.err_wl50_51_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl50_51_bank0_reg::type_id::create("err_wl50_51_bank0_reg",,get_full_name());
        this.err_wl50_51_bank0_reg.configure(this, null, "");
        this.err_wl50_51_bank0_reg.build();
        this.default_map.add_reg(this.err_wl50_51_bank0_reg, `UVM_REG_ADDR_WIDTH'h114,"RW",0);
            this.err_wl50_51_bank0_reg_err_wl50_bank0 = this.err_wl50_51_bank0_reg.err_wl50_bank0;
            this.err_wl50_bank0 = this.err_wl50_51_bank0_reg.err_wl50_bank0;

            this.err_wl50_51_bank0_reg_err_wl51_bank0 = this.err_wl50_51_bank0_reg.err_wl51_bank0;
            this.err_wl51_bank0 = this.err_wl50_51_bank0_reg.err_wl51_bank0;

        this.err_wl52_53_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl52_53_bank0_reg::type_id::create("err_wl52_53_bank0_reg",,get_full_name());
        this.err_wl52_53_bank0_reg.configure(this, null, "");
        this.err_wl52_53_bank0_reg.build();
        this.default_map.add_reg(this.err_wl52_53_bank0_reg, `UVM_REG_ADDR_WIDTH'h118,"RW",0);
            this.err_wl52_53_bank0_reg_err_wl52_bank0 = this.err_wl52_53_bank0_reg.err_wl52_bank0;
            this.err_wl52_bank0 = this.err_wl52_53_bank0_reg.err_wl52_bank0;

            this.err_wl52_53_bank0_reg_err_wl53_bank0 = this.err_wl52_53_bank0_reg.err_wl53_bank0;
            this.err_wl53_bank0 = this.err_wl52_53_bank0_reg.err_wl53_bank0;

        this.err_wl54_55_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl54_55_bank0_reg::type_id::create("err_wl54_55_bank0_reg",,get_full_name());
        this.err_wl54_55_bank0_reg.configure(this, null, "");
        this.err_wl54_55_bank0_reg.build();
        this.default_map.add_reg(this.err_wl54_55_bank0_reg, `UVM_REG_ADDR_WIDTH'h11C,"RW",0);
            this.err_wl54_55_bank0_reg_err_wl54_bank0 = this.err_wl54_55_bank0_reg.err_wl54_bank0;
            this.err_wl54_bank0 = this.err_wl54_55_bank0_reg.err_wl54_bank0;

            this.err_wl54_55_bank0_reg_err_wl55_bank0 = this.err_wl54_55_bank0_reg.err_wl55_bank0;
            this.err_wl55_bank0 = this.err_wl54_55_bank0_reg.err_wl55_bank0;

        this.err_wl56_57_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl56_57_bank0_reg::type_id::create("err_wl56_57_bank0_reg",,get_full_name());
        this.err_wl56_57_bank0_reg.configure(this, null, "");
        this.err_wl56_57_bank0_reg.build();
        this.default_map.add_reg(this.err_wl56_57_bank0_reg, `UVM_REG_ADDR_WIDTH'h120,"RW",0);
            this.err_wl56_57_bank0_reg_err_wl56_bank0 = this.err_wl56_57_bank0_reg.err_wl56_bank0;
            this.err_wl56_bank0 = this.err_wl56_57_bank0_reg.err_wl56_bank0;

            this.err_wl56_57_bank0_reg_err_wl57_bank0 = this.err_wl56_57_bank0_reg.err_wl57_bank0;
            this.err_wl57_bank0 = this.err_wl56_57_bank0_reg.err_wl57_bank0;

        this.err_wl58_59_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl58_59_bank0_reg::type_id::create("err_wl58_59_bank0_reg",,get_full_name());
        this.err_wl58_59_bank0_reg.configure(this, null, "");
        this.err_wl58_59_bank0_reg.build();
        this.default_map.add_reg(this.err_wl58_59_bank0_reg, `UVM_REG_ADDR_WIDTH'h124,"RW",0);
            this.err_wl58_59_bank0_reg_err_wl58_bank0 = this.err_wl58_59_bank0_reg.err_wl58_bank0;
            this.err_wl58_bank0 = this.err_wl58_59_bank0_reg.err_wl58_bank0;

            this.err_wl58_59_bank0_reg_err_wl59_bank0 = this.err_wl58_59_bank0_reg.err_wl59_bank0;
            this.err_wl59_bank0 = this.err_wl58_59_bank0_reg.err_wl59_bank0;

        this.err_wl60_61_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl60_61_bank0_reg::type_id::create("err_wl60_61_bank0_reg",,get_full_name());
        this.err_wl60_61_bank0_reg.configure(this, null, "");
        this.err_wl60_61_bank0_reg.build();
        this.default_map.add_reg(this.err_wl60_61_bank0_reg, `UVM_REG_ADDR_WIDTH'h128,"RW",0);
            this.err_wl60_61_bank0_reg_err_wl60_bank0 = this.err_wl60_61_bank0_reg.err_wl60_bank0;
            this.err_wl60_bank0 = this.err_wl60_61_bank0_reg.err_wl60_bank0;

            this.err_wl60_61_bank0_reg_err_wl61_bank0 = this.err_wl60_61_bank0_reg.err_wl61_bank0;
            this.err_wl61_bank0 = this.err_wl60_61_bank0_reg.err_wl61_bank0;

        this.err_wl62_63_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_wl62_63_bank0_reg::type_id::create("err_wl62_63_bank0_reg",,get_full_name());
        this.err_wl62_63_bank0_reg.configure(this, null, "");
        this.err_wl62_63_bank0_reg.build();
        this.default_map.add_reg(this.err_wl62_63_bank0_reg, `UVM_REG_ADDR_WIDTH'h12C,"RW",0);
            this.err_wl62_63_bank0_reg_err_wl62_bank0 = this.err_wl62_63_bank0_reg.err_wl62_bank0;
            this.err_wl62_bank0 = this.err_wl62_63_bank0_reg.err_wl62_bank0;

            this.err_wl62_63_bank0_reg_err_wl63_bank0 = this.err_wl62_63_bank0_reg.err_wl63_bank0;
            this.err_wl63_bank0 = this.err_wl62_63_bank0_reg.err_wl63_bank0;

        this.err_csl_part0_1_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_csl_part0_1_bank0_reg::type_id::create("err_csl_part0_1_bank0_reg",,get_full_name());
        this.err_csl_part0_1_bank0_reg.configure(this, null, "");
        this.err_csl_part0_1_bank0_reg.build();
        this.default_map.add_reg(this.err_csl_part0_1_bank0_reg, `UVM_REG_ADDR_WIDTH'h130,"RW",0);
            this.err_csl_part0_1_bank0_reg_err_csl0_part0_bank0 = this.err_csl_part0_1_bank0_reg.err_csl0_part0_bank0;
            this.err_csl0_part0_bank0 = this.err_csl_part0_1_bank0_reg.err_csl0_part0_bank0;

            this.err_csl_part0_1_bank0_reg_err_csl1_part0_bank0 = this.err_csl_part0_1_bank0_reg.err_csl1_part0_bank0;
            this.err_csl1_part0_bank0 = this.err_csl_part0_1_bank0_reg.err_csl1_part0_bank0;

            this.err_csl_part0_1_bank0_reg_err_csl0_part1_bank0 = this.err_csl_part0_1_bank0_reg.err_csl0_part1_bank0;
            this.err_csl0_part1_bank0 = this.err_csl_part0_1_bank0_reg.err_csl0_part1_bank0;

            this.err_csl_part0_1_bank0_reg_err_csl1_part1_bank0 = this.err_csl_part0_1_bank0_reg.err_csl1_part1_bank0;
            this.err_csl1_part1_bank0 = this.err_csl_part0_1_bank0_reg.err_csl1_part1_bank0;

        this.err_csl_part2_3_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_csl_part2_3_bank0_reg::type_id::create("err_csl_part2_3_bank0_reg",,get_full_name());
        this.err_csl_part2_3_bank0_reg.configure(this, null, "");
        this.err_csl_part2_3_bank0_reg.build();
        this.default_map.add_reg(this.err_csl_part2_3_bank0_reg, `UVM_REG_ADDR_WIDTH'h134,"RW",0);
            this.err_csl_part2_3_bank0_reg_err_csl0_part2_bank0 = this.err_csl_part2_3_bank0_reg.err_csl0_part2_bank0;
            this.err_csl0_part2_bank0 = this.err_csl_part2_3_bank0_reg.err_csl0_part2_bank0;

            this.err_csl_part2_3_bank0_reg_err_csl1_part2_bank0 = this.err_csl_part2_3_bank0_reg.err_csl1_part2_bank0;
            this.err_csl1_part2_bank0 = this.err_csl_part2_3_bank0_reg.err_csl1_part2_bank0;

            this.err_csl_part2_3_bank0_reg_err_csl0_part3_bank0 = this.err_csl_part2_3_bank0_reg.err_csl0_part3_bank0;
            this.err_csl0_part3_bank0 = this.err_csl_part2_3_bank0_reg.err_csl0_part3_bank0;

            this.err_csl_part2_3_bank0_reg_err_csl1_part3_bank0 = this.err_csl_part2_3_bank0_reg.err_csl1_part3_bank0;
            this.err_csl1_part3_bank0 = this.err_csl_part2_3_bank0_reg.err_csl1_part3_bank0;

        this.err_csl_part4_5_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_csl_part4_5_bank0_reg::type_id::create("err_csl_part4_5_bank0_reg",,get_full_name());
        this.err_csl_part4_5_bank0_reg.configure(this, null, "");
        this.err_csl_part4_5_bank0_reg.build();
        this.default_map.add_reg(this.err_csl_part4_5_bank0_reg, `UVM_REG_ADDR_WIDTH'h138,"RW",0);
            this.err_csl_part4_5_bank0_reg_err_csl0_part4_bank0 = this.err_csl_part4_5_bank0_reg.err_csl0_part4_bank0;
            this.err_csl0_part4_bank0 = this.err_csl_part4_5_bank0_reg.err_csl0_part4_bank0;

            this.err_csl_part4_5_bank0_reg_err_csl1_part4_bank0 = this.err_csl_part4_5_bank0_reg.err_csl1_part4_bank0;
            this.err_csl1_part4_bank0 = this.err_csl_part4_5_bank0_reg.err_csl1_part4_bank0;

            this.err_csl_part4_5_bank0_reg_err_csl0_part5_bank0 = this.err_csl_part4_5_bank0_reg.err_csl0_part5_bank0;
            this.err_csl0_part5_bank0 = this.err_csl_part4_5_bank0_reg.err_csl0_part5_bank0;

            this.err_csl_part4_5_bank0_reg_err_csl1_part5_bank0 = this.err_csl_part4_5_bank0_reg.err_csl1_part5_bank0;
            this.err_csl1_part5_bank0 = this.err_csl_part4_5_bank0_reg.err_csl1_part5_bank0;

        this.err_csl_part6_7_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_csl_part6_7_bank0_reg::type_id::create("err_csl_part6_7_bank0_reg",,get_full_name());
        this.err_csl_part6_7_bank0_reg.configure(this, null, "");
        this.err_csl_part6_7_bank0_reg.build();
        this.default_map.add_reg(this.err_csl_part6_7_bank0_reg, `UVM_REG_ADDR_WIDTH'h13C,"RW",0);
            this.err_csl_part6_7_bank0_reg_err_csl0_part6_bank0 = this.err_csl_part6_7_bank0_reg.err_csl0_part6_bank0;
            this.err_csl0_part6_bank0 = this.err_csl_part6_7_bank0_reg.err_csl0_part6_bank0;

            this.err_csl_part6_7_bank0_reg_err_csl1_part6_bank0 = this.err_csl_part6_7_bank0_reg.err_csl1_part6_bank0;
            this.err_csl1_part6_bank0 = this.err_csl_part6_7_bank0_reg.err_csl1_part6_bank0;

            this.err_csl_part6_7_bank0_reg_err_csl0_part7_bank0 = this.err_csl_part6_7_bank0_reg.err_csl0_part7_bank0;
            this.err_csl0_part7_bank0 = this.err_csl_part6_7_bank0_reg.err_csl0_part7_bank0;

            this.err_csl_part6_7_bank0_reg_err_csl1_part7_bank0 = this.err_csl_part6_7_bank0_reg.err_csl1_part7_bank0;
            this.err_csl1_part7_bank0 = this.err_csl_part6_7_bank0_reg.err_csl1_part7_bank0;

        this.err_csl_part8_9_bank0_reg = ral_reg_mc_1short2_top_aux_top_err_csl_part8_9_bank0_reg::type_id::create("err_csl_part8_9_bank0_reg",,get_full_name());
        this.err_csl_part8_9_bank0_reg.configure(this, null, "");
        this.err_csl_part8_9_bank0_reg.build();
        this.default_map.add_reg(this.err_csl_part8_9_bank0_reg, `UVM_REG_ADDR_WIDTH'h140,"RW",0);
            this.err_csl_part8_9_bank0_reg_err_csl0_part8_bank0 = this.err_csl_part8_9_bank0_reg.err_csl0_part8_bank0;
            this.err_csl0_part8_bank0 = this.err_csl_part8_9_bank0_reg.err_csl0_part8_bank0;

            this.err_csl_part8_9_bank0_reg_err_csl1_part8_bank0 = this.err_csl_part8_9_bank0_reg.err_csl1_part8_bank0;
            this.err_csl1_part8_bank0 = this.err_csl_part8_9_bank0_reg.err_csl1_part8_bank0;

            this.err_csl_part8_9_bank0_reg_err_csl0_part9_bank0 = this.err_csl_part8_9_bank0_reg.err_csl0_part9_bank0;
            this.err_csl0_part9_bank0 = this.err_csl_part8_9_bank0_reg.err_csl0_part9_bank0;

            this.err_csl_part8_9_bank0_reg_err_csl1_part9_bank0 = this.err_csl_part8_9_bank0_reg.err_csl1_part9_bank0;
            this.err_csl1_part9_bank0 = this.err_csl_part8_9_bank0_reg.err_csl1_part9_bank0;

        this.mc_vmc_wl_num0_1_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num0_1_bank1_reg::type_id::create("mc_vmc_wl_num0_1_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num0_1_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num0_1_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num0_1_bank1_reg, `UVM_REG_ADDR_WIDTH'h144,"RW",0);
            this.mc_vmc_wl_num0_1_bank1_reg_mc_vmc_wl_num0_bank1 = this.mc_vmc_wl_num0_1_bank1_reg.mc_vmc_wl_num0_bank1;
            this.mc_vmc_wl_num0_bank1 = this.mc_vmc_wl_num0_1_bank1_reg.mc_vmc_wl_num0_bank1;

            this.mc_vmc_wl_num0_1_bank1_reg_mc_vmc_wl_num1_bank1 = this.mc_vmc_wl_num0_1_bank1_reg.mc_vmc_wl_num1_bank1;
            this.mc_vmc_wl_num1_bank1 = this.mc_vmc_wl_num0_1_bank1_reg.mc_vmc_wl_num1_bank1;

        this.mc_vmc_wl_num2_3_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num2_3_bank1_reg::type_id::create("mc_vmc_wl_num2_3_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num2_3_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num2_3_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num2_3_bank1_reg, `UVM_REG_ADDR_WIDTH'h148,"RW",0);
            this.mc_vmc_wl_num2_3_bank1_reg_mc_vmc_wl_num2_bank1 = this.mc_vmc_wl_num2_3_bank1_reg.mc_vmc_wl_num2_bank1;
            this.mc_vmc_wl_num2_bank1 = this.mc_vmc_wl_num2_3_bank1_reg.mc_vmc_wl_num2_bank1;

            this.mc_vmc_wl_num2_3_bank1_reg_mc_vmc_wl_num3_bank1 = this.mc_vmc_wl_num2_3_bank1_reg.mc_vmc_wl_num3_bank1;
            this.mc_vmc_wl_num3_bank1 = this.mc_vmc_wl_num2_3_bank1_reg.mc_vmc_wl_num3_bank1;

        this.mc_vmc_wl_num4_5_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num4_5_bank1_reg::type_id::create("mc_vmc_wl_num4_5_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num4_5_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num4_5_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num4_5_bank1_reg, `UVM_REG_ADDR_WIDTH'h14C,"RW",0);
            this.mc_vmc_wl_num4_5_bank1_reg_mc_vmc_wl_num4_bank1 = this.mc_vmc_wl_num4_5_bank1_reg.mc_vmc_wl_num4_bank1;
            this.mc_vmc_wl_num4_bank1 = this.mc_vmc_wl_num4_5_bank1_reg.mc_vmc_wl_num4_bank1;

            this.mc_vmc_wl_num4_5_bank1_reg_mc_vmc_wl_num5_bank1 = this.mc_vmc_wl_num4_5_bank1_reg.mc_vmc_wl_num5_bank1;
            this.mc_vmc_wl_num5_bank1 = this.mc_vmc_wl_num4_5_bank1_reg.mc_vmc_wl_num5_bank1;

        this.mc_vmc_wl_num6_7_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num6_7_bank1_reg::type_id::create("mc_vmc_wl_num6_7_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num6_7_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num6_7_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num6_7_bank1_reg, `UVM_REG_ADDR_WIDTH'h150,"RW",0);
            this.mc_vmc_wl_num6_7_bank1_reg_mc_vmc_wl_num6_bank1 = this.mc_vmc_wl_num6_7_bank1_reg.mc_vmc_wl_num6_bank1;
            this.mc_vmc_wl_num6_bank1 = this.mc_vmc_wl_num6_7_bank1_reg.mc_vmc_wl_num6_bank1;

            this.mc_vmc_wl_num6_7_bank1_reg_mc_vmc_wl_num7_bank1 = this.mc_vmc_wl_num6_7_bank1_reg.mc_vmc_wl_num7_bank1;
            this.mc_vmc_wl_num7_bank1 = this.mc_vmc_wl_num6_7_bank1_reg.mc_vmc_wl_num7_bank1;

        this.mc_vmc_wl_num8_9_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num8_9_bank1_reg::type_id::create("mc_vmc_wl_num8_9_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num8_9_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num8_9_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num8_9_bank1_reg, `UVM_REG_ADDR_WIDTH'h154,"RW",0);
            this.mc_vmc_wl_num8_9_bank1_reg_mc_vmc_wl_num8_bank1 = this.mc_vmc_wl_num8_9_bank1_reg.mc_vmc_wl_num8_bank1;
            this.mc_vmc_wl_num8_bank1 = this.mc_vmc_wl_num8_9_bank1_reg.mc_vmc_wl_num8_bank1;

            this.mc_vmc_wl_num8_9_bank1_reg_mc_vmc_wl_num9_bank1 = this.mc_vmc_wl_num8_9_bank1_reg.mc_vmc_wl_num9_bank1;
            this.mc_vmc_wl_num9_bank1 = this.mc_vmc_wl_num8_9_bank1_reg.mc_vmc_wl_num9_bank1;

        this.mc_vmc_wl_num10_11_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num10_11_bank1_reg::type_id::create("mc_vmc_wl_num10_11_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num10_11_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num10_11_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num10_11_bank1_reg, `UVM_REG_ADDR_WIDTH'h158,"RW",0);
            this.mc_vmc_wl_num10_11_bank1_reg_mc_vmc_wl_num10_bank1 = this.mc_vmc_wl_num10_11_bank1_reg.mc_vmc_wl_num10_bank1;
            this.mc_vmc_wl_num10_bank1 = this.mc_vmc_wl_num10_11_bank1_reg.mc_vmc_wl_num10_bank1;

            this.mc_vmc_wl_num10_11_bank1_reg_mc_vmc_wl_num11_bank1 = this.mc_vmc_wl_num10_11_bank1_reg.mc_vmc_wl_num11_bank1;
            this.mc_vmc_wl_num11_bank1 = this.mc_vmc_wl_num10_11_bank1_reg.mc_vmc_wl_num11_bank1;

        this.mc_vmc_wl_num12_13_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num12_13_bank1_reg::type_id::create("mc_vmc_wl_num12_13_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num12_13_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num12_13_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num12_13_bank1_reg, `UVM_REG_ADDR_WIDTH'h15C,"RW",0);
            this.mc_vmc_wl_num12_13_bank1_reg_mc_vmc_wl_num12_bank1 = this.mc_vmc_wl_num12_13_bank1_reg.mc_vmc_wl_num12_bank1;
            this.mc_vmc_wl_num12_bank1 = this.mc_vmc_wl_num12_13_bank1_reg.mc_vmc_wl_num12_bank1;

            this.mc_vmc_wl_num12_13_bank1_reg_mc_vmc_wl_num13_bank1 = this.mc_vmc_wl_num12_13_bank1_reg.mc_vmc_wl_num13_bank1;
            this.mc_vmc_wl_num13_bank1 = this.mc_vmc_wl_num12_13_bank1_reg.mc_vmc_wl_num13_bank1;

        this.mc_vmc_wl_num14_15_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num14_15_bank1_reg::type_id::create("mc_vmc_wl_num14_15_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num14_15_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num14_15_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num14_15_bank1_reg, `UVM_REG_ADDR_WIDTH'h160,"RW",0);
            this.mc_vmc_wl_num14_15_bank1_reg_mc_vmc_wl_num14_bank1 = this.mc_vmc_wl_num14_15_bank1_reg.mc_vmc_wl_num14_bank1;
            this.mc_vmc_wl_num14_bank1 = this.mc_vmc_wl_num14_15_bank1_reg.mc_vmc_wl_num14_bank1;

            this.mc_vmc_wl_num14_15_bank1_reg_mc_vmc_wl_num15_bank1 = this.mc_vmc_wl_num14_15_bank1_reg.mc_vmc_wl_num15_bank1;
            this.mc_vmc_wl_num15_bank1 = this.mc_vmc_wl_num14_15_bank1_reg.mc_vmc_wl_num15_bank1;

        this.mc_vmc_wl_num16_17_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num16_17_bank1_reg::type_id::create("mc_vmc_wl_num16_17_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num16_17_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num16_17_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num16_17_bank1_reg, `UVM_REG_ADDR_WIDTH'h164,"RW",0);
            this.mc_vmc_wl_num16_17_bank1_reg_mc_vmc_wl_num16_bank1 = this.mc_vmc_wl_num16_17_bank1_reg.mc_vmc_wl_num16_bank1;
            this.mc_vmc_wl_num16_bank1 = this.mc_vmc_wl_num16_17_bank1_reg.mc_vmc_wl_num16_bank1;

            this.mc_vmc_wl_num16_17_bank1_reg_mc_vmc_wl_num17_bank1 = this.mc_vmc_wl_num16_17_bank1_reg.mc_vmc_wl_num17_bank1;
            this.mc_vmc_wl_num17_bank1 = this.mc_vmc_wl_num16_17_bank1_reg.mc_vmc_wl_num17_bank1;

        this.mc_vmc_wl_num18_19_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num18_19_bank1_reg::type_id::create("mc_vmc_wl_num18_19_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num18_19_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num18_19_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num18_19_bank1_reg, `UVM_REG_ADDR_WIDTH'h168,"RW",0);
            this.mc_vmc_wl_num18_19_bank1_reg_mc_vmc_wl_num18_bank1 = this.mc_vmc_wl_num18_19_bank1_reg.mc_vmc_wl_num18_bank1;
            this.mc_vmc_wl_num18_bank1 = this.mc_vmc_wl_num18_19_bank1_reg.mc_vmc_wl_num18_bank1;

            this.mc_vmc_wl_num18_19_bank1_reg_mc_vmc_wl_num19_bank1 = this.mc_vmc_wl_num18_19_bank1_reg.mc_vmc_wl_num19_bank1;
            this.mc_vmc_wl_num19_bank1 = this.mc_vmc_wl_num18_19_bank1_reg.mc_vmc_wl_num19_bank1;

        this.mc_vmc_wl_num20_21_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num20_21_bank1_reg::type_id::create("mc_vmc_wl_num20_21_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num20_21_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num20_21_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num20_21_bank1_reg, `UVM_REG_ADDR_WIDTH'h16C,"RW",0);
            this.mc_vmc_wl_num20_21_bank1_reg_mc_vmc_wl_num20_bank1 = this.mc_vmc_wl_num20_21_bank1_reg.mc_vmc_wl_num20_bank1;
            this.mc_vmc_wl_num20_bank1 = this.mc_vmc_wl_num20_21_bank1_reg.mc_vmc_wl_num20_bank1;

            this.mc_vmc_wl_num20_21_bank1_reg_mc_vmc_wl_num21_bank1 = this.mc_vmc_wl_num20_21_bank1_reg.mc_vmc_wl_num21_bank1;
            this.mc_vmc_wl_num21_bank1 = this.mc_vmc_wl_num20_21_bank1_reg.mc_vmc_wl_num21_bank1;

        this.mc_vmc_wl_num22_23_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num22_23_bank1_reg::type_id::create("mc_vmc_wl_num22_23_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num22_23_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num22_23_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num22_23_bank1_reg, `UVM_REG_ADDR_WIDTH'h170,"RW",0);
            this.mc_vmc_wl_num22_23_bank1_reg_mc_vmc_wl_num22_bank1 = this.mc_vmc_wl_num22_23_bank1_reg.mc_vmc_wl_num22_bank1;
            this.mc_vmc_wl_num22_bank1 = this.mc_vmc_wl_num22_23_bank1_reg.mc_vmc_wl_num22_bank1;

            this.mc_vmc_wl_num22_23_bank1_reg_mc_vmc_wl_num23_bank1 = this.mc_vmc_wl_num22_23_bank1_reg.mc_vmc_wl_num23_bank1;
            this.mc_vmc_wl_num23_bank1 = this.mc_vmc_wl_num22_23_bank1_reg.mc_vmc_wl_num23_bank1;

        this.mc_vmc_wl_num24_25_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num24_25_bank1_reg::type_id::create("mc_vmc_wl_num24_25_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num24_25_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num24_25_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num24_25_bank1_reg, `UVM_REG_ADDR_WIDTH'h174,"RW",0);
            this.mc_vmc_wl_num24_25_bank1_reg_mc_vmc_wl_num24_bank1 = this.mc_vmc_wl_num24_25_bank1_reg.mc_vmc_wl_num24_bank1;
            this.mc_vmc_wl_num24_bank1 = this.mc_vmc_wl_num24_25_bank1_reg.mc_vmc_wl_num24_bank1;

            this.mc_vmc_wl_num24_25_bank1_reg_mc_vmc_wl_num25_bank1 = this.mc_vmc_wl_num24_25_bank1_reg.mc_vmc_wl_num25_bank1;
            this.mc_vmc_wl_num25_bank1 = this.mc_vmc_wl_num24_25_bank1_reg.mc_vmc_wl_num25_bank1;

        this.mc_vmc_wl_num26_27_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num26_27_bank1_reg::type_id::create("mc_vmc_wl_num26_27_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num26_27_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num26_27_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num26_27_bank1_reg, `UVM_REG_ADDR_WIDTH'h178,"RW",0);
            this.mc_vmc_wl_num26_27_bank1_reg_mc_vmc_wl_num26_bank1 = this.mc_vmc_wl_num26_27_bank1_reg.mc_vmc_wl_num26_bank1;
            this.mc_vmc_wl_num26_bank1 = this.mc_vmc_wl_num26_27_bank1_reg.mc_vmc_wl_num26_bank1;

            this.mc_vmc_wl_num26_27_bank1_reg_mc_vmc_wl_num27_bank1 = this.mc_vmc_wl_num26_27_bank1_reg.mc_vmc_wl_num27_bank1;
            this.mc_vmc_wl_num27_bank1 = this.mc_vmc_wl_num26_27_bank1_reg.mc_vmc_wl_num27_bank1;

        this.mc_vmc_wl_num28_29_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num28_29_bank1_reg::type_id::create("mc_vmc_wl_num28_29_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num28_29_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num28_29_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num28_29_bank1_reg, `UVM_REG_ADDR_WIDTH'h17C,"RW",0);
            this.mc_vmc_wl_num28_29_bank1_reg_mc_vmc_wl_num28_bank1 = this.mc_vmc_wl_num28_29_bank1_reg.mc_vmc_wl_num28_bank1;
            this.mc_vmc_wl_num28_bank1 = this.mc_vmc_wl_num28_29_bank1_reg.mc_vmc_wl_num28_bank1;

            this.mc_vmc_wl_num28_29_bank1_reg_mc_vmc_wl_num29_bank1 = this.mc_vmc_wl_num28_29_bank1_reg.mc_vmc_wl_num29_bank1;
            this.mc_vmc_wl_num29_bank1 = this.mc_vmc_wl_num28_29_bank1_reg.mc_vmc_wl_num29_bank1;

        this.mc_vmc_wl_num30_31_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num30_31_bank1_reg::type_id::create("mc_vmc_wl_num30_31_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num30_31_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num30_31_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num30_31_bank1_reg, `UVM_REG_ADDR_WIDTH'h180,"RW",0);
            this.mc_vmc_wl_num30_31_bank1_reg_mc_vmc_wl_num30_bank1 = this.mc_vmc_wl_num30_31_bank1_reg.mc_vmc_wl_num30_bank1;
            this.mc_vmc_wl_num30_bank1 = this.mc_vmc_wl_num30_31_bank1_reg.mc_vmc_wl_num30_bank1;

            this.mc_vmc_wl_num30_31_bank1_reg_mc_vmc_wl_num31_bank1 = this.mc_vmc_wl_num30_31_bank1_reg.mc_vmc_wl_num31_bank1;
            this.mc_vmc_wl_num31_bank1 = this.mc_vmc_wl_num30_31_bank1_reg.mc_vmc_wl_num31_bank1;

        this.mc_vmc_wl_num32_33_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num32_33_bank1_reg::type_id::create("mc_vmc_wl_num32_33_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num32_33_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num32_33_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num32_33_bank1_reg, `UVM_REG_ADDR_WIDTH'h184,"RW",0);
            this.mc_vmc_wl_num32_33_bank1_reg_mc_vmc_wl_num32_bank1 = this.mc_vmc_wl_num32_33_bank1_reg.mc_vmc_wl_num32_bank1;
            this.mc_vmc_wl_num32_bank1 = this.mc_vmc_wl_num32_33_bank1_reg.mc_vmc_wl_num32_bank1;

            this.mc_vmc_wl_num32_33_bank1_reg_mc_vmc_wl_num33_bank1 = this.mc_vmc_wl_num32_33_bank1_reg.mc_vmc_wl_num33_bank1;
            this.mc_vmc_wl_num33_bank1 = this.mc_vmc_wl_num32_33_bank1_reg.mc_vmc_wl_num33_bank1;

        this.mc_vmc_wl_num34_35_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num34_35_bank1_reg::type_id::create("mc_vmc_wl_num34_35_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num34_35_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num34_35_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num34_35_bank1_reg, `UVM_REG_ADDR_WIDTH'h188,"RW",0);
            this.mc_vmc_wl_num34_35_bank1_reg_mc_vmc_wl_num34_bank1 = this.mc_vmc_wl_num34_35_bank1_reg.mc_vmc_wl_num34_bank1;
            this.mc_vmc_wl_num34_bank1 = this.mc_vmc_wl_num34_35_bank1_reg.mc_vmc_wl_num34_bank1;

            this.mc_vmc_wl_num34_35_bank1_reg_mc_vmc_wl_num35_bank1 = this.mc_vmc_wl_num34_35_bank1_reg.mc_vmc_wl_num35_bank1;
            this.mc_vmc_wl_num35_bank1 = this.mc_vmc_wl_num34_35_bank1_reg.mc_vmc_wl_num35_bank1;

        this.mc_vmc_wl_num36_37_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num36_37_bank1_reg::type_id::create("mc_vmc_wl_num36_37_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num36_37_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num36_37_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num36_37_bank1_reg, `UVM_REG_ADDR_WIDTH'h18C,"RW",0);
            this.mc_vmc_wl_num36_37_bank1_reg_mc_vmc_wl_num36_bank1 = this.mc_vmc_wl_num36_37_bank1_reg.mc_vmc_wl_num36_bank1;
            this.mc_vmc_wl_num36_bank1 = this.mc_vmc_wl_num36_37_bank1_reg.mc_vmc_wl_num36_bank1;

            this.mc_vmc_wl_num36_37_bank1_reg_mc_vmc_wl_num37_bank1 = this.mc_vmc_wl_num36_37_bank1_reg.mc_vmc_wl_num37_bank1;
            this.mc_vmc_wl_num37_bank1 = this.mc_vmc_wl_num36_37_bank1_reg.mc_vmc_wl_num37_bank1;

        this.mc_vmc_wl_num38_39_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num38_39_bank1_reg::type_id::create("mc_vmc_wl_num38_39_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num38_39_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num38_39_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num38_39_bank1_reg, `UVM_REG_ADDR_WIDTH'h190,"RW",0);
            this.mc_vmc_wl_num38_39_bank1_reg_mc_vmc_wl_num38_bank1 = this.mc_vmc_wl_num38_39_bank1_reg.mc_vmc_wl_num38_bank1;
            this.mc_vmc_wl_num38_bank1 = this.mc_vmc_wl_num38_39_bank1_reg.mc_vmc_wl_num38_bank1;

            this.mc_vmc_wl_num38_39_bank1_reg_mc_vmc_wl_num39_bank1 = this.mc_vmc_wl_num38_39_bank1_reg.mc_vmc_wl_num39_bank1;
            this.mc_vmc_wl_num39_bank1 = this.mc_vmc_wl_num38_39_bank1_reg.mc_vmc_wl_num39_bank1;

        this.mc_vmc_wl_num40_41_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num40_41_bank1_reg::type_id::create("mc_vmc_wl_num40_41_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num40_41_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num40_41_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num40_41_bank1_reg, `UVM_REG_ADDR_WIDTH'h194,"RW",0);
            this.mc_vmc_wl_num40_41_bank1_reg_mc_vmc_wl_num40_bank1 = this.mc_vmc_wl_num40_41_bank1_reg.mc_vmc_wl_num40_bank1;
            this.mc_vmc_wl_num40_bank1 = this.mc_vmc_wl_num40_41_bank1_reg.mc_vmc_wl_num40_bank1;

            this.mc_vmc_wl_num40_41_bank1_reg_mc_vmc_wl_num41_bank1 = this.mc_vmc_wl_num40_41_bank1_reg.mc_vmc_wl_num41_bank1;
            this.mc_vmc_wl_num41_bank1 = this.mc_vmc_wl_num40_41_bank1_reg.mc_vmc_wl_num41_bank1;

        this.mc_vmc_wl_num42_43_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num42_43_bank1_reg::type_id::create("mc_vmc_wl_num42_43_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num42_43_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num42_43_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num42_43_bank1_reg, `UVM_REG_ADDR_WIDTH'h198,"RW",0);
            this.mc_vmc_wl_num42_43_bank1_reg_mc_vmc_wl_num42_bank1 = this.mc_vmc_wl_num42_43_bank1_reg.mc_vmc_wl_num42_bank1;
            this.mc_vmc_wl_num42_bank1 = this.mc_vmc_wl_num42_43_bank1_reg.mc_vmc_wl_num42_bank1;

            this.mc_vmc_wl_num42_43_bank1_reg_mc_vmc_wl_num43_bank1 = this.mc_vmc_wl_num42_43_bank1_reg.mc_vmc_wl_num43_bank1;
            this.mc_vmc_wl_num43_bank1 = this.mc_vmc_wl_num42_43_bank1_reg.mc_vmc_wl_num43_bank1;

        this.mc_vmc_wl_num44_45_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num44_45_bank1_reg::type_id::create("mc_vmc_wl_num44_45_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num44_45_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num44_45_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num44_45_bank1_reg, `UVM_REG_ADDR_WIDTH'h19C,"RW",0);
            this.mc_vmc_wl_num44_45_bank1_reg_mc_vmc_wl_num44_bank1 = this.mc_vmc_wl_num44_45_bank1_reg.mc_vmc_wl_num44_bank1;
            this.mc_vmc_wl_num44_bank1 = this.mc_vmc_wl_num44_45_bank1_reg.mc_vmc_wl_num44_bank1;

            this.mc_vmc_wl_num44_45_bank1_reg_mc_vmc_wl_num45_bank1 = this.mc_vmc_wl_num44_45_bank1_reg.mc_vmc_wl_num45_bank1;
            this.mc_vmc_wl_num45_bank1 = this.mc_vmc_wl_num44_45_bank1_reg.mc_vmc_wl_num45_bank1;

        this.mc_vmc_wl_num46_47_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num46_47_bank1_reg::type_id::create("mc_vmc_wl_num46_47_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num46_47_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num46_47_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num46_47_bank1_reg, `UVM_REG_ADDR_WIDTH'h1A0,"RW",0);
            this.mc_vmc_wl_num46_47_bank1_reg_mc_vmc_wl_num46_bank1 = this.mc_vmc_wl_num46_47_bank1_reg.mc_vmc_wl_num46_bank1;
            this.mc_vmc_wl_num46_bank1 = this.mc_vmc_wl_num46_47_bank1_reg.mc_vmc_wl_num46_bank1;

            this.mc_vmc_wl_num46_47_bank1_reg_mc_vmc_wl_num47_bank1 = this.mc_vmc_wl_num46_47_bank1_reg.mc_vmc_wl_num47_bank1;
            this.mc_vmc_wl_num47_bank1 = this.mc_vmc_wl_num46_47_bank1_reg.mc_vmc_wl_num47_bank1;

        this.mc_vmc_wl_num48_49_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num48_49_bank1_reg::type_id::create("mc_vmc_wl_num48_49_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num48_49_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num48_49_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num48_49_bank1_reg, `UVM_REG_ADDR_WIDTH'h1A4,"RW",0);
            this.mc_vmc_wl_num48_49_bank1_reg_mc_vmc_wl_num48_bank1 = this.mc_vmc_wl_num48_49_bank1_reg.mc_vmc_wl_num48_bank1;
            this.mc_vmc_wl_num48_bank1 = this.mc_vmc_wl_num48_49_bank1_reg.mc_vmc_wl_num48_bank1;

            this.mc_vmc_wl_num48_49_bank1_reg_mc_vmc_wl_num49_bank1 = this.mc_vmc_wl_num48_49_bank1_reg.mc_vmc_wl_num49_bank1;
            this.mc_vmc_wl_num49_bank1 = this.mc_vmc_wl_num48_49_bank1_reg.mc_vmc_wl_num49_bank1;

        this.mc_vmc_wl_num50_51_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num50_51_bank1_reg::type_id::create("mc_vmc_wl_num50_51_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num50_51_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num50_51_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num50_51_bank1_reg, `UVM_REG_ADDR_WIDTH'h1A8,"RW",0);
            this.mc_vmc_wl_num50_51_bank1_reg_mc_vmc_wl_num50_bank1 = this.mc_vmc_wl_num50_51_bank1_reg.mc_vmc_wl_num50_bank1;
            this.mc_vmc_wl_num50_bank1 = this.mc_vmc_wl_num50_51_bank1_reg.mc_vmc_wl_num50_bank1;

            this.mc_vmc_wl_num50_51_bank1_reg_mc_vmc_wl_num51_bank1 = this.mc_vmc_wl_num50_51_bank1_reg.mc_vmc_wl_num51_bank1;
            this.mc_vmc_wl_num51_bank1 = this.mc_vmc_wl_num50_51_bank1_reg.mc_vmc_wl_num51_bank1;

        this.mc_vmc_wl_num52_53_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num52_53_bank1_reg::type_id::create("mc_vmc_wl_num52_53_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num52_53_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num52_53_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num52_53_bank1_reg, `UVM_REG_ADDR_WIDTH'h1AC,"RW",0);
            this.mc_vmc_wl_num52_53_bank1_reg_mc_vmc_wl_num52_bank1 = this.mc_vmc_wl_num52_53_bank1_reg.mc_vmc_wl_num52_bank1;
            this.mc_vmc_wl_num52_bank1 = this.mc_vmc_wl_num52_53_bank1_reg.mc_vmc_wl_num52_bank1;

            this.mc_vmc_wl_num52_53_bank1_reg_mc_vmc_wl_num53_bank1 = this.mc_vmc_wl_num52_53_bank1_reg.mc_vmc_wl_num53_bank1;
            this.mc_vmc_wl_num53_bank1 = this.mc_vmc_wl_num52_53_bank1_reg.mc_vmc_wl_num53_bank1;

        this.mc_vmc_wl_num54_55_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num54_55_bank1_reg::type_id::create("mc_vmc_wl_num54_55_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num54_55_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num54_55_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num54_55_bank1_reg, `UVM_REG_ADDR_WIDTH'h1B0,"RW",0);
            this.mc_vmc_wl_num54_55_bank1_reg_mc_vmc_wl_num54_bank1 = this.mc_vmc_wl_num54_55_bank1_reg.mc_vmc_wl_num54_bank1;
            this.mc_vmc_wl_num54_bank1 = this.mc_vmc_wl_num54_55_bank1_reg.mc_vmc_wl_num54_bank1;

            this.mc_vmc_wl_num54_55_bank1_reg_mc_vmc_wl_num55_bank1 = this.mc_vmc_wl_num54_55_bank1_reg.mc_vmc_wl_num55_bank1;
            this.mc_vmc_wl_num55_bank1 = this.mc_vmc_wl_num54_55_bank1_reg.mc_vmc_wl_num55_bank1;

        this.mc_vmc_wl_num56_57_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num56_57_bank1_reg::type_id::create("mc_vmc_wl_num56_57_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num56_57_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num56_57_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num56_57_bank1_reg, `UVM_REG_ADDR_WIDTH'h1B4,"RW",0);
            this.mc_vmc_wl_num56_57_bank1_reg_mc_vmc_wl_num56_bank1 = this.mc_vmc_wl_num56_57_bank1_reg.mc_vmc_wl_num56_bank1;
            this.mc_vmc_wl_num56_bank1 = this.mc_vmc_wl_num56_57_bank1_reg.mc_vmc_wl_num56_bank1;

            this.mc_vmc_wl_num56_57_bank1_reg_mc_vmc_wl_num57_bank1 = this.mc_vmc_wl_num56_57_bank1_reg.mc_vmc_wl_num57_bank1;
            this.mc_vmc_wl_num57_bank1 = this.mc_vmc_wl_num56_57_bank1_reg.mc_vmc_wl_num57_bank1;

        this.mc_vmc_wl_num58_59_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num58_59_bank1_reg::type_id::create("mc_vmc_wl_num58_59_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num58_59_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num58_59_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num58_59_bank1_reg, `UVM_REG_ADDR_WIDTH'h1B8,"RW",0);
            this.mc_vmc_wl_num58_59_bank1_reg_mc_vmc_wl_num58_bank1 = this.mc_vmc_wl_num58_59_bank1_reg.mc_vmc_wl_num58_bank1;
            this.mc_vmc_wl_num58_bank1 = this.mc_vmc_wl_num58_59_bank1_reg.mc_vmc_wl_num58_bank1;

            this.mc_vmc_wl_num58_59_bank1_reg_mc_vmc_wl_num59_bank1 = this.mc_vmc_wl_num58_59_bank1_reg.mc_vmc_wl_num59_bank1;
            this.mc_vmc_wl_num59_bank1 = this.mc_vmc_wl_num58_59_bank1_reg.mc_vmc_wl_num59_bank1;

        this.mc_vmc_wl_num60_61_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num60_61_bank1_reg::type_id::create("mc_vmc_wl_num60_61_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num60_61_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num60_61_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num60_61_bank1_reg, `UVM_REG_ADDR_WIDTH'h1BC,"RW",0);
            this.mc_vmc_wl_num60_61_bank1_reg_mc_vmc_wl_num60_bank1 = this.mc_vmc_wl_num60_61_bank1_reg.mc_vmc_wl_num60_bank1;
            this.mc_vmc_wl_num60_bank1 = this.mc_vmc_wl_num60_61_bank1_reg.mc_vmc_wl_num60_bank1;

            this.mc_vmc_wl_num60_61_bank1_reg_mc_vmc_wl_num61_bank1 = this.mc_vmc_wl_num60_61_bank1_reg.mc_vmc_wl_num61_bank1;
            this.mc_vmc_wl_num61_bank1 = this.mc_vmc_wl_num60_61_bank1_reg.mc_vmc_wl_num61_bank1;

        this.mc_vmc_wl_num62_63_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_wl_num62_63_bank1_reg::type_id::create("mc_vmc_wl_num62_63_bank1_reg",,get_full_name());
        this.mc_vmc_wl_num62_63_bank1_reg.configure(this, null, "");
        this.mc_vmc_wl_num62_63_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_wl_num62_63_bank1_reg, `UVM_REG_ADDR_WIDTH'h1C0,"RW",0);
            this.mc_vmc_wl_num62_63_bank1_reg_mc_vmc_wl_num62_bank1 = this.mc_vmc_wl_num62_63_bank1_reg.mc_vmc_wl_num62_bank1;
            this.mc_vmc_wl_num62_bank1 = this.mc_vmc_wl_num62_63_bank1_reg.mc_vmc_wl_num62_bank1;

            this.mc_vmc_wl_num62_63_bank1_reg_mc_vmc_wl_num63_bank1 = this.mc_vmc_wl_num62_63_bank1_reg.mc_vmc_wl_num63_bank1;
            this.mc_vmc_wl_num63_bank1 = this.mc_vmc_wl_num62_63_bank1_reg.mc_vmc_wl_num63_bank1;

        this.mc_vmc_bl_num0_part0_1_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part0_1_bank1_reg::type_id::create("mc_vmc_bl_num0_part0_1_bank1_reg",,get_full_name());
        this.mc_vmc_bl_num0_part0_1_bank1_reg.configure(this, null, "");
        this.mc_vmc_bl_num0_part0_1_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num0_part0_1_bank1_reg, `UVM_REG_ADDR_WIDTH'h1C4,"RW",0);
            this.mc_vmc_bl_num0_part0_1_bank1_reg_mc_vmc_bl_num0_part0_bank1 = this.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num0_part0_bank1;
            this.mc_vmc_bl_num0_part0_bank1 = this.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num0_part0_bank1;

            this.mc_vmc_bl_num0_part0_1_bank1_reg_mc_vmc_bl_num1_part0_bank1 = this.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num1_part0_bank1;
            this.mc_vmc_bl_num1_part0_bank1 = this.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num1_part0_bank1;

            this.mc_vmc_bl_num0_part0_1_bank1_reg_mc_vmc_bl_num0_part1_bank1 = this.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num0_part1_bank1;
            this.mc_vmc_bl_num0_part1_bank1 = this.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num0_part1_bank1;

            this.mc_vmc_bl_num0_part0_1_bank1_reg_mc_vmc_bl_num1_part1_bank1 = this.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num1_part1_bank1;
            this.mc_vmc_bl_num1_part1_bank1 = this.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num1_part1_bank1;

        this.mc_vmc_bl_num0_part2_3_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part2_3_bank1_reg::type_id::create("mc_vmc_bl_num0_part2_3_bank1_reg",,get_full_name());
        this.mc_vmc_bl_num0_part2_3_bank1_reg.configure(this, null, "");
        this.mc_vmc_bl_num0_part2_3_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num0_part2_3_bank1_reg, `UVM_REG_ADDR_WIDTH'h1C8,"RW",0);
            this.mc_vmc_bl_num0_part2_3_bank1_reg_mc_vmc_bl_num0_part2_bank1 = this.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num0_part2_bank1;
            this.mc_vmc_bl_num0_part2_bank1 = this.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num0_part2_bank1;

            this.mc_vmc_bl_num0_part2_3_bank1_reg_mc_vmc_bl_num1_part2_bank1 = this.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num1_part2_bank1;
            this.mc_vmc_bl_num1_part2_bank1 = this.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num1_part2_bank1;

            this.mc_vmc_bl_num0_part2_3_bank1_reg_mc_vmc_bl_num0_part3_bank1 = this.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num0_part3_bank1;
            this.mc_vmc_bl_num0_part3_bank1 = this.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num0_part3_bank1;

            this.mc_vmc_bl_num0_part2_3_bank1_reg_mc_vmc_bl_num1_part3_bank1 = this.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num1_part3_bank1;
            this.mc_vmc_bl_num1_part3_bank1 = this.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num1_part3_bank1;

        this.mc_vmc_bl_num0_part4_5_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part4_5_bank1_reg::type_id::create("mc_vmc_bl_num0_part4_5_bank1_reg",,get_full_name());
        this.mc_vmc_bl_num0_part4_5_bank1_reg.configure(this, null, "");
        this.mc_vmc_bl_num0_part4_5_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num0_part4_5_bank1_reg, `UVM_REG_ADDR_WIDTH'h1CC,"RW",0);
            this.mc_vmc_bl_num0_part4_5_bank1_reg_mc_vmc_bl_num0_part4_bank1 = this.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num0_part4_bank1;
            this.mc_vmc_bl_num0_part4_bank1 = this.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num0_part4_bank1;

            this.mc_vmc_bl_num0_part4_5_bank1_reg_mc_vmc_bl_num1_part4_bank1 = this.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num1_part4_bank1;
            this.mc_vmc_bl_num1_part4_bank1 = this.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num1_part4_bank1;

            this.mc_vmc_bl_num0_part4_5_bank1_reg_mc_vmc_bl_num0_part5_bank1 = this.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num0_part5_bank1;
            this.mc_vmc_bl_num0_part5_bank1 = this.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num0_part5_bank1;

            this.mc_vmc_bl_num0_part4_5_bank1_reg_mc_vmc_bl_num1_part5_bank1 = this.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num1_part5_bank1;
            this.mc_vmc_bl_num1_part5_bank1 = this.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num1_part5_bank1;

        this.mc_vmc_bl_num0_part6_7_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part6_7_bank1_reg::type_id::create("mc_vmc_bl_num0_part6_7_bank1_reg",,get_full_name());
        this.mc_vmc_bl_num0_part6_7_bank1_reg.configure(this, null, "");
        this.mc_vmc_bl_num0_part6_7_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num0_part6_7_bank1_reg, `UVM_REG_ADDR_WIDTH'h1D0,"RW",0);
            this.mc_vmc_bl_num0_part6_7_bank1_reg_mc_vmc_bl_num0_part6_bank1 = this.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num0_part6_bank1;
            this.mc_vmc_bl_num0_part6_bank1 = this.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num0_part6_bank1;

            this.mc_vmc_bl_num0_part6_7_bank1_reg_mc_vmc_bl_num1_part6_bank1 = this.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num1_part6_bank1;
            this.mc_vmc_bl_num1_part6_bank1 = this.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num1_part6_bank1;

            this.mc_vmc_bl_num0_part6_7_bank1_reg_mc_vmc_bl_num0_part7_bank1 = this.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num0_part7_bank1;
            this.mc_vmc_bl_num0_part7_bank1 = this.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num0_part7_bank1;

            this.mc_vmc_bl_num0_part6_7_bank1_reg_mc_vmc_bl_num1_part7_bank1 = this.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num1_part7_bank1;
            this.mc_vmc_bl_num1_part7_bank1 = this.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num1_part7_bank1;

        this.mc_vmc_bl_num0_part8_9_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_vmc_bl_num0_part8_9_bank1_reg::type_id::create("mc_vmc_bl_num0_part8_9_bank1_reg",,get_full_name());
        this.mc_vmc_bl_num0_part8_9_bank1_reg.configure(this, null, "");
        this.mc_vmc_bl_num0_part8_9_bank1_reg.build();
        this.default_map.add_reg(this.mc_vmc_bl_num0_part8_9_bank1_reg, `UVM_REG_ADDR_WIDTH'h1D4,"RW",0);
            this.mc_vmc_bl_num0_part8_9_bank1_reg_mc_vmc_bl_num0_part8_bank1 = this.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num0_part8_bank1;
            this.mc_vmc_bl_num0_part8_bank1 = this.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num0_part8_bank1;

            this.mc_vmc_bl_num0_part8_9_bank1_reg_mc_vmc_bl_num1_part8_bank1 = this.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num1_part8_bank1;
            this.mc_vmc_bl_num1_part8_bank1 = this.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num1_part8_bank1;

            this.mc_vmc_bl_num0_part8_9_bank1_reg_mc_vmc_bl_num0_part9_bank1 = this.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num0_part9_bank1;
            this.mc_vmc_bl_num0_part9_bank1 = this.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num0_part9_bank1;

            this.mc_vmc_bl_num0_part8_9_bank1_reg_mc_vmc_bl_num1_part9_bank1 = this.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num1_part9_bank1;
            this.mc_vmc_bl_num1_part9_bank1 = this.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num1_part9_bank1;

        this.err_wl0_1_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl0_1_bank1_reg::type_id::create("err_wl0_1_bank1_reg",,get_full_name());
        this.err_wl0_1_bank1_reg.configure(this, null, "");
        this.err_wl0_1_bank1_reg.build();
        this.default_map.add_reg(this.err_wl0_1_bank1_reg, `UVM_REG_ADDR_WIDTH'h1D8,"RW",0);
            this.err_wl0_1_bank1_reg_err_wl0_bank1 = this.err_wl0_1_bank1_reg.err_wl0_bank1;
            this.err_wl0_bank1 = this.err_wl0_1_bank1_reg.err_wl0_bank1;

            this.err_wl0_1_bank1_reg_err_wl1_bank1 = this.err_wl0_1_bank1_reg.err_wl1_bank1;
            this.err_wl1_bank1 = this.err_wl0_1_bank1_reg.err_wl1_bank1;

        this.err_wl2_3_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl2_3_bank1_reg::type_id::create("err_wl2_3_bank1_reg",,get_full_name());
        this.err_wl2_3_bank1_reg.configure(this, null, "");
        this.err_wl2_3_bank1_reg.build();
        this.default_map.add_reg(this.err_wl2_3_bank1_reg, `UVM_REG_ADDR_WIDTH'h1DC,"RW",0);
            this.err_wl2_3_bank1_reg_err_wl2_bank1 = this.err_wl2_3_bank1_reg.err_wl2_bank1;
            this.err_wl2_bank1 = this.err_wl2_3_bank1_reg.err_wl2_bank1;

            this.err_wl2_3_bank1_reg_err_wl3_bank1 = this.err_wl2_3_bank1_reg.err_wl3_bank1;
            this.err_wl3_bank1 = this.err_wl2_3_bank1_reg.err_wl3_bank1;

        this.err_wl4_5_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl4_5_bank1_reg::type_id::create("err_wl4_5_bank1_reg",,get_full_name());
        this.err_wl4_5_bank1_reg.configure(this, null, "");
        this.err_wl4_5_bank1_reg.build();
        this.default_map.add_reg(this.err_wl4_5_bank1_reg, `UVM_REG_ADDR_WIDTH'h1E0,"RW",0);
            this.err_wl4_5_bank1_reg_err_wl4_bank1 = this.err_wl4_5_bank1_reg.err_wl4_bank1;
            this.err_wl4_bank1 = this.err_wl4_5_bank1_reg.err_wl4_bank1;

            this.err_wl4_5_bank1_reg_err_wl5_bank1 = this.err_wl4_5_bank1_reg.err_wl5_bank1;
            this.err_wl5_bank1 = this.err_wl4_5_bank1_reg.err_wl5_bank1;

        this.err_wl6_7_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl6_7_bank1_reg::type_id::create("err_wl6_7_bank1_reg",,get_full_name());
        this.err_wl6_7_bank1_reg.configure(this, null, "");
        this.err_wl6_7_bank1_reg.build();
        this.default_map.add_reg(this.err_wl6_7_bank1_reg, `UVM_REG_ADDR_WIDTH'h1E4,"RW",0);
            this.err_wl6_7_bank1_reg_err_wl6_bank1 = this.err_wl6_7_bank1_reg.err_wl6_bank1;
            this.err_wl6_bank1 = this.err_wl6_7_bank1_reg.err_wl6_bank1;

            this.err_wl6_7_bank1_reg_err_wl7_bank1 = this.err_wl6_7_bank1_reg.err_wl7_bank1;
            this.err_wl7_bank1 = this.err_wl6_7_bank1_reg.err_wl7_bank1;

        this.err_wl8_9_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl8_9_bank1_reg::type_id::create("err_wl8_9_bank1_reg",,get_full_name());
        this.err_wl8_9_bank1_reg.configure(this, null, "");
        this.err_wl8_9_bank1_reg.build();
        this.default_map.add_reg(this.err_wl8_9_bank1_reg, `UVM_REG_ADDR_WIDTH'h1E8,"RW",0);
            this.err_wl8_9_bank1_reg_err_wl8_bank1 = this.err_wl8_9_bank1_reg.err_wl8_bank1;
            this.err_wl8_bank1 = this.err_wl8_9_bank1_reg.err_wl8_bank1;

            this.err_wl8_9_bank1_reg_err_wl9_bank1 = this.err_wl8_9_bank1_reg.err_wl9_bank1;
            this.err_wl9_bank1 = this.err_wl8_9_bank1_reg.err_wl9_bank1;

        this.err_wl10_11_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl10_11_bank1_reg::type_id::create("err_wl10_11_bank1_reg",,get_full_name());
        this.err_wl10_11_bank1_reg.configure(this, null, "");
        this.err_wl10_11_bank1_reg.build();
        this.default_map.add_reg(this.err_wl10_11_bank1_reg, `UVM_REG_ADDR_WIDTH'h1EC,"RW",0);
            this.err_wl10_11_bank1_reg_err_wl10_bank1 = this.err_wl10_11_bank1_reg.err_wl10_bank1;
            this.err_wl10_bank1 = this.err_wl10_11_bank1_reg.err_wl10_bank1;

            this.err_wl10_11_bank1_reg_err_wl11_bank1 = this.err_wl10_11_bank1_reg.err_wl11_bank1;
            this.err_wl11_bank1 = this.err_wl10_11_bank1_reg.err_wl11_bank1;

        this.err_wl12_13_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl12_13_bank1_reg::type_id::create("err_wl12_13_bank1_reg",,get_full_name());
        this.err_wl12_13_bank1_reg.configure(this, null, "");
        this.err_wl12_13_bank1_reg.build();
        this.default_map.add_reg(this.err_wl12_13_bank1_reg, `UVM_REG_ADDR_WIDTH'h1F0,"RW",0);
            this.err_wl12_13_bank1_reg_err_wl12_bank1 = this.err_wl12_13_bank1_reg.err_wl12_bank1;
            this.err_wl12_bank1 = this.err_wl12_13_bank1_reg.err_wl12_bank1;

            this.err_wl12_13_bank1_reg_err_wl13_bank1 = this.err_wl12_13_bank1_reg.err_wl13_bank1;
            this.err_wl13_bank1 = this.err_wl12_13_bank1_reg.err_wl13_bank1;

        this.err_wl14_15_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl14_15_bank1_reg::type_id::create("err_wl14_15_bank1_reg",,get_full_name());
        this.err_wl14_15_bank1_reg.configure(this, null, "");
        this.err_wl14_15_bank1_reg.build();
        this.default_map.add_reg(this.err_wl14_15_bank1_reg, `UVM_REG_ADDR_WIDTH'h1F4,"RW",0);
            this.err_wl14_15_bank1_reg_err_wl14_bank1 = this.err_wl14_15_bank1_reg.err_wl14_bank1;
            this.err_wl14_bank1 = this.err_wl14_15_bank1_reg.err_wl14_bank1;

            this.err_wl14_15_bank1_reg_err_wl15_bank1 = this.err_wl14_15_bank1_reg.err_wl15_bank1;
            this.err_wl15_bank1 = this.err_wl14_15_bank1_reg.err_wl15_bank1;

        this.err_wl16_17_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl16_17_bank1_reg::type_id::create("err_wl16_17_bank1_reg",,get_full_name());
        this.err_wl16_17_bank1_reg.configure(this, null, "");
        this.err_wl16_17_bank1_reg.build();
        this.default_map.add_reg(this.err_wl16_17_bank1_reg, `UVM_REG_ADDR_WIDTH'h1F8,"RW",0);
            this.err_wl16_17_bank1_reg_err_wl16_bank1 = this.err_wl16_17_bank1_reg.err_wl16_bank1;
            this.err_wl16_bank1 = this.err_wl16_17_bank1_reg.err_wl16_bank1;

            this.err_wl16_17_bank1_reg_err_wl17_bank1 = this.err_wl16_17_bank1_reg.err_wl17_bank1;
            this.err_wl17_bank1 = this.err_wl16_17_bank1_reg.err_wl17_bank1;

        this.err_wl18_19_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl18_19_bank1_reg::type_id::create("err_wl18_19_bank1_reg",,get_full_name());
        this.err_wl18_19_bank1_reg.configure(this, null, "");
        this.err_wl18_19_bank1_reg.build();
        this.default_map.add_reg(this.err_wl18_19_bank1_reg, `UVM_REG_ADDR_WIDTH'h1FC,"RW",0);
            this.err_wl18_19_bank1_reg_err_wl18_bank1 = this.err_wl18_19_bank1_reg.err_wl18_bank1;
            this.err_wl18_bank1 = this.err_wl18_19_bank1_reg.err_wl18_bank1;

            this.err_wl18_19_bank1_reg_err_wl19_bank1 = this.err_wl18_19_bank1_reg.err_wl19_bank1;
            this.err_wl19_bank1 = this.err_wl18_19_bank1_reg.err_wl19_bank1;

        this.err_wl20_21_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl20_21_bank1_reg::type_id::create("err_wl20_21_bank1_reg",,get_full_name());
        this.err_wl20_21_bank1_reg.configure(this, null, "");
        this.err_wl20_21_bank1_reg.build();
        this.default_map.add_reg(this.err_wl20_21_bank1_reg, `UVM_REG_ADDR_WIDTH'h200,"RW",0);
            this.err_wl20_21_bank1_reg_err_wl20_bank1 = this.err_wl20_21_bank1_reg.err_wl20_bank1;
            this.err_wl20_bank1 = this.err_wl20_21_bank1_reg.err_wl20_bank1;

            this.err_wl20_21_bank1_reg_err_wl21_bank1 = this.err_wl20_21_bank1_reg.err_wl21_bank1;
            this.err_wl21_bank1 = this.err_wl20_21_bank1_reg.err_wl21_bank1;

        this.err_wl22_23_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl22_23_bank1_reg::type_id::create("err_wl22_23_bank1_reg",,get_full_name());
        this.err_wl22_23_bank1_reg.configure(this, null, "");
        this.err_wl22_23_bank1_reg.build();
        this.default_map.add_reg(this.err_wl22_23_bank1_reg, `UVM_REG_ADDR_WIDTH'h204,"RW",0);
            this.err_wl22_23_bank1_reg_err_wl22_bank1 = this.err_wl22_23_bank1_reg.err_wl22_bank1;
            this.err_wl22_bank1 = this.err_wl22_23_bank1_reg.err_wl22_bank1;

            this.err_wl22_23_bank1_reg_err_wl23_bank1 = this.err_wl22_23_bank1_reg.err_wl23_bank1;
            this.err_wl23_bank1 = this.err_wl22_23_bank1_reg.err_wl23_bank1;

        this.err_wl24_25_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl24_25_bank1_reg::type_id::create("err_wl24_25_bank1_reg",,get_full_name());
        this.err_wl24_25_bank1_reg.configure(this, null, "");
        this.err_wl24_25_bank1_reg.build();
        this.default_map.add_reg(this.err_wl24_25_bank1_reg, `UVM_REG_ADDR_WIDTH'h208,"RW",0);
            this.err_wl24_25_bank1_reg_err_wl24_bank1 = this.err_wl24_25_bank1_reg.err_wl24_bank1;
            this.err_wl24_bank1 = this.err_wl24_25_bank1_reg.err_wl24_bank1;

            this.err_wl24_25_bank1_reg_err_wl25_bank1 = this.err_wl24_25_bank1_reg.err_wl25_bank1;
            this.err_wl25_bank1 = this.err_wl24_25_bank1_reg.err_wl25_bank1;

        this.err_wl26_27_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl26_27_bank1_reg::type_id::create("err_wl26_27_bank1_reg",,get_full_name());
        this.err_wl26_27_bank1_reg.configure(this, null, "");
        this.err_wl26_27_bank1_reg.build();
        this.default_map.add_reg(this.err_wl26_27_bank1_reg, `UVM_REG_ADDR_WIDTH'h20C,"RW",0);
            this.err_wl26_27_bank1_reg_err_wl26_bank1 = this.err_wl26_27_bank1_reg.err_wl26_bank1;
            this.err_wl26_bank1 = this.err_wl26_27_bank1_reg.err_wl26_bank1;

            this.err_wl26_27_bank1_reg_err_wl27_bank1 = this.err_wl26_27_bank1_reg.err_wl27_bank1;
            this.err_wl27_bank1 = this.err_wl26_27_bank1_reg.err_wl27_bank1;

        this.err_wl28_29_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl28_29_bank1_reg::type_id::create("err_wl28_29_bank1_reg",,get_full_name());
        this.err_wl28_29_bank1_reg.configure(this, null, "");
        this.err_wl28_29_bank1_reg.build();
        this.default_map.add_reg(this.err_wl28_29_bank1_reg, `UVM_REG_ADDR_WIDTH'h210,"RW",0);
            this.err_wl28_29_bank1_reg_err_wl28_bank1 = this.err_wl28_29_bank1_reg.err_wl28_bank1;
            this.err_wl28_bank1 = this.err_wl28_29_bank1_reg.err_wl28_bank1;

            this.err_wl28_29_bank1_reg_err_wl29_bank1 = this.err_wl28_29_bank1_reg.err_wl29_bank1;
            this.err_wl29_bank1 = this.err_wl28_29_bank1_reg.err_wl29_bank1;

        this.err_wl30_31_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl30_31_bank1_reg::type_id::create("err_wl30_31_bank1_reg",,get_full_name());
        this.err_wl30_31_bank1_reg.configure(this, null, "");
        this.err_wl30_31_bank1_reg.build();
        this.default_map.add_reg(this.err_wl30_31_bank1_reg, `UVM_REG_ADDR_WIDTH'h214,"RW",0);
            this.err_wl30_31_bank1_reg_err_wl30_bank1 = this.err_wl30_31_bank1_reg.err_wl30_bank1;
            this.err_wl30_bank1 = this.err_wl30_31_bank1_reg.err_wl30_bank1;

            this.err_wl30_31_bank1_reg_err_wl31_bank1 = this.err_wl30_31_bank1_reg.err_wl31_bank1;
            this.err_wl31_bank1 = this.err_wl30_31_bank1_reg.err_wl31_bank1;

        this.err_wl32_33_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl32_33_bank1_reg::type_id::create("err_wl32_33_bank1_reg",,get_full_name());
        this.err_wl32_33_bank1_reg.configure(this, null, "");
        this.err_wl32_33_bank1_reg.build();
        this.default_map.add_reg(this.err_wl32_33_bank1_reg, `UVM_REG_ADDR_WIDTH'h218,"RW",0);
            this.err_wl32_33_bank1_reg_err_wl32_bank1 = this.err_wl32_33_bank1_reg.err_wl32_bank1;
            this.err_wl32_bank1 = this.err_wl32_33_bank1_reg.err_wl32_bank1;

            this.err_wl32_33_bank1_reg_err_wl33_bank1 = this.err_wl32_33_bank1_reg.err_wl33_bank1;
            this.err_wl33_bank1 = this.err_wl32_33_bank1_reg.err_wl33_bank1;

        this.err_wl34_35_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl34_35_bank1_reg::type_id::create("err_wl34_35_bank1_reg",,get_full_name());
        this.err_wl34_35_bank1_reg.configure(this, null, "");
        this.err_wl34_35_bank1_reg.build();
        this.default_map.add_reg(this.err_wl34_35_bank1_reg, `UVM_REG_ADDR_WIDTH'h21C,"RW",0);
            this.err_wl34_35_bank1_reg_err_wl34_bank1 = this.err_wl34_35_bank1_reg.err_wl34_bank1;
            this.err_wl34_bank1 = this.err_wl34_35_bank1_reg.err_wl34_bank1;

            this.err_wl34_35_bank1_reg_err_wl35_bank1 = this.err_wl34_35_bank1_reg.err_wl35_bank1;
            this.err_wl35_bank1 = this.err_wl34_35_bank1_reg.err_wl35_bank1;

        this.err_wl36_37_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl36_37_bank1_reg::type_id::create("err_wl36_37_bank1_reg",,get_full_name());
        this.err_wl36_37_bank1_reg.configure(this, null, "");
        this.err_wl36_37_bank1_reg.build();
        this.default_map.add_reg(this.err_wl36_37_bank1_reg, `UVM_REG_ADDR_WIDTH'h220,"RW",0);
            this.err_wl36_37_bank1_reg_err_wl36_bank1 = this.err_wl36_37_bank1_reg.err_wl36_bank1;
            this.err_wl36_bank1 = this.err_wl36_37_bank1_reg.err_wl36_bank1;

            this.err_wl36_37_bank1_reg_err_wl37_bank1 = this.err_wl36_37_bank1_reg.err_wl37_bank1;
            this.err_wl37_bank1 = this.err_wl36_37_bank1_reg.err_wl37_bank1;

        this.err_wl38_39_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl38_39_bank1_reg::type_id::create("err_wl38_39_bank1_reg",,get_full_name());
        this.err_wl38_39_bank1_reg.configure(this, null, "");
        this.err_wl38_39_bank1_reg.build();
        this.default_map.add_reg(this.err_wl38_39_bank1_reg, `UVM_REG_ADDR_WIDTH'h224,"RW",0);
            this.err_wl38_39_bank1_reg_err_wl38_bank1 = this.err_wl38_39_bank1_reg.err_wl38_bank1;
            this.err_wl38_bank1 = this.err_wl38_39_bank1_reg.err_wl38_bank1;

            this.err_wl38_39_bank1_reg_err_wl39_bank1 = this.err_wl38_39_bank1_reg.err_wl39_bank1;
            this.err_wl39_bank1 = this.err_wl38_39_bank1_reg.err_wl39_bank1;

        this.err_wl40_41_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl40_41_bank1_reg::type_id::create("err_wl40_41_bank1_reg",,get_full_name());
        this.err_wl40_41_bank1_reg.configure(this, null, "");
        this.err_wl40_41_bank1_reg.build();
        this.default_map.add_reg(this.err_wl40_41_bank1_reg, `UVM_REG_ADDR_WIDTH'h228,"RW",0);
            this.err_wl40_41_bank1_reg_err_wl40_bank1 = this.err_wl40_41_bank1_reg.err_wl40_bank1;
            this.err_wl40_bank1 = this.err_wl40_41_bank1_reg.err_wl40_bank1;

            this.err_wl40_41_bank1_reg_err_wl41_bank1 = this.err_wl40_41_bank1_reg.err_wl41_bank1;
            this.err_wl41_bank1 = this.err_wl40_41_bank1_reg.err_wl41_bank1;

        this.err_wl42_43_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl42_43_bank1_reg::type_id::create("err_wl42_43_bank1_reg",,get_full_name());
        this.err_wl42_43_bank1_reg.configure(this, null, "");
        this.err_wl42_43_bank1_reg.build();
        this.default_map.add_reg(this.err_wl42_43_bank1_reg, `UVM_REG_ADDR_WIDTH'h22C,"RW",0);
            this.err_wl42_43_bank1_reg_err_wl42_bank1 = this.err_wl42_43_bank1_reg.err_wl42_bank1;
            this.err_wl42_bank1 = this.err_wl42_43_bank1_reg.err_wl42_bank1;

            this.err_wl42_43_bank1_reg_err_wl43_bank1 = this.err_wl42_43_bank1_reg.err_wl43_bank1;
            this.err_wl43_bank1 = this.err_wl42_43_bank1_reg.err_wl43_bank1;

        this.err_wl44_45_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl44_45_bank1_reg::type_id::create("err_wl44_45_bank1_reg",,get_full_name());
        this.err_wl44_45_bank1_reg.configure(this, null, "");
        this.err_wl44_45_bank1_reg.build();
        this.default_map.add_reg(this.err_wl44_45_bank1_reg, `UVM_REG_ADDR_WIDTH'h230,"RW",0);
            this.err_wl44_45_bank1_reg_err_wl44_bank1 = this.err_wl44_45_bank1_reg.err_wl44_bank1;
            this.err_wl44_bank1 = this.err_wl44_45_bank1_reg.err_wl44_bank1;

            this.err_wl44_45_bank1_reg_err_wl45_bank1 = this.err_wl44_45_bank1_reg.err_wl45_bank1;
            this.err_wl45_bank1 = this.err_wl44_45_bank1_reg.err_wl45_bank1;

        this.err_wl46_47_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl46_47_bank1_reg::type_id::create("err_wl46_47_bank1_reg",,get_full_name());
        this.err_wl46_47_bank1_reg.configure(this, null, "");
        this.err_wl46_47_bank1_reg.build();
        this.default_map.add_reg(this.err_wl46_47_bank1_reg, `UVM_REG_ADDR_WIDTH'h234,"RW",0);
            this.err_wl46_47_bank1_reg_err_wl46_bank1 = this.err_wl46_47_bank1_reg.err_wl46_bank1;
            this.err_wl46_bank1 = this.err_wl46_47_bank1_reg.err_wl46_bank1;

            this.err_wl46_47_bank1_reg_err_wl47_bank1 = this.err_wl46_47_bank1_reg.err_wl47_bank1;
            this.err_wl47_bank1 = this.err_wl46_47_bank1_reg.err_wl47_bank1;

        this.err_wl48_49_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl48_49_bank1_reg::type_id::create("err_wl48_49_bank1_reg",,get_full_name());
        this.err_wl48_49_bank1_reg.configure(this, null, "");
        this.err_wl48_49_bank1_reg.build();
        this.default_map.add_reg(this.err_wl48_49_bank1_reg, `UVM_REG_ADDR_WIDTH'h238,"RW",0);
            this.err_wl48_49_bank1_reg_err_wl48_bank1 = this.err_wl48_49_bank1_reg.err_wl48_bank1;
            this.err_wl48_bank1 = this.err_wl48_49_bank1_reg.err_wl48_bank1;

            this.err_wl48_49_bank1_reg_err_wl49_bank1 = this.err_wl48_49_bank1_reg.err_wl49_bank1;
            this.err_wl49_bank1 = this.err_wl48_49_bank1_reg.err_wl49_bank1;

        this.err_wl50_51_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl50_51_bank1_reg::type_id::create("err_wl50_51_bank1_reg",,get_full_name());
        this.err_wl50_51_bank1_reg.configure(this, null, "");
        this.err_wl50_51_bank1_reg.build();
        this.default_map.add_reg(this.err_wl50_51_bank1_reg, `UVM_REG_ADDR_WIDTH'h23C,"RW",0);
            this.err_wl50_51_bank1_reg_err_wl50_bank1 = this.err_wl50_51_bank1_reg.err_wl50_bank1;
            this.err_wl50_bank1 = this.err_wl50_51_bank1_reg.err_wl50_bank1;

            this.err_wl50_51_bank1_reg_err_wl51_bank1 = this.err_wl50_51_bank1_reg.err_wl51_bank1;
            this.err_wl51_bank1 = this.err_wl50_51_bank1_reg.err_wl51_bank1;

        this.err_wl52_53_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl52_53_bank1_reg::type_id::create("err_wl52_53_bank1_reg",,get_full_name());
        this.err_wl52_53_bank1_reg.configure(this, null, "");
        this.err_wl52_53_bank1_reg.build();
        this.default_map.add_reg(this.err_wl52_53_bank1_reg, `UVM_REG_ADDR_WIDTH'h240,"RW",0);
            this.err_wl52_53_bank1_reg_err_wl52_bank1 = this.err_wl52_53_bank1_reg.err_wl52_bank1;
            this.err_wl52_bank1 = this.err_wl52_53_bank1_reg.err_wl52_bank1;

            this.err_wl52_53_bank1_reg_err_wl53_bank1 = this.err_wl52_53_bank1_reg.err_wl53_bank1;
            this.err_wl53_bank1 = this.err_wl52_53_bank1_reg.err_wl53_bank1;

        this.err_wl54_55_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl54_55_bank1_reg::type_id::create("err_wl54_55_bank1_reg",,get_full_name());
        this.err_wl54_55_bank1_reg.configure(this, null, "");
        this.err_wl54_55_bank1_reg.build();
        this.default_map.add_reg(this.err_wl54_55_bank1_reg, `UVM_REG_ADDR_WIDTH'h244,"RW",0);
            this.err_wl54_55_bank1_reg_err_wl54_bank1 = this.err_wl54_55_bank1_reg.err_wl54_bank1;
            this.err_wl54_bank1 = this.err_wl54_55_bank1_reg.err_wl54_bank1;

            this.err_wl54_55_bank1_reg_err_wl55_bank1 = this.err_wl54_55_bank1_reg.err_wl55_bank1;
            this.err_wl55_bank1 = this.err_wl54_55_bank1_reg.err_wl55_bank1;

        this.err_wl56_57_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl56_57_bank1_reg::type_id::create("err_wl56_57_bank1_reg",,get_full_name());
        this.err_wl56_57_bank1_reg.configure(this, null, "");
        this.err_wl56_57_bank1_reg.build();
        this.default_map.add_reg(this.err_wl56_57_bank1_reg, `UVM_REG_ADDR_WIDTH'h248,"RW",0);
            this.err_wl56_57_bank1_reg_err_wl56_bank1 = this.err_wl56_57_bank1_reg.err_wl56_bank1;
            this.err_wl56_bank1 = this.err_wl56_57_bank1_reg.err_wl56_bank1;

            this.err_wl56_57_bank1_reg_err_wl57_bank1 = this.err_wl56_57_bank1_reg.err_wl57_bank1;
            this.err_wl57_bank1 = this.err_wl56_57_bank1_reg.err_wl57_bank1;

        this.err_wl58_59_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl58_59_bank1_reg::type_id::create("err_wl58_59_bank1_reg",,get_full_name());
        this.err_wl58_59_bank1_reg.configure(this, null, "");
        this.err_wl58_59_bank1_reg.build();
        this.default_map.add_reg(this.err_wl58_59_bank1_reg, `UVM_REG_ADDR_WIDTH'h24C,"RW",0);
            this.err_wl58_59_bank1_reg_err_wl58_bank1 = this.err_wl58_59_bank1_reg.err_wl58_bank1;
            this.err_wl58_bank1 = this.err_wl58_59_bank1_reg.err_wl58_bank1;

            this.err_wl58_59_bank1_reg_err_wl59_bank1 = this.err_wl58_59_bank1_reg.err_wl59_bank1;
            this.err_wl59_bank1 = this.err_wl58_59_bank1_reg.err_wl59_bank1;

        this.err_wl60_61_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl60_61_bank1_reg::type_id::create("err_wl60_61_bank1_reg",,get_full_name());
        this.err_wl60_61_bank1_reg.configure(this, null, "");
        this.err_wl60_61_bank1_reg.build();
        this.default_map.add_reg(this.err_wl60_61_bank1_reg, `UVM_REG_ADDR_WIDTH'h250,"RW",0);
            this.err_wl60_61_bank1_reg_err_wl60_bank1 = this.err_wl60_61_bank1_reg.err_wl60_bank1;
            this.err_wl60_bank1 = this.err_wl60_61_bank1_reg.err_wl60_bank1;

            this.err_wl60_61_bank1_reg_err_wl61_bank1 = this.err_wl60_61_bank1_reg.err_wl61_bank1;
            this.err_wl61_bank1 = this.err_wl60_61_bank1_reg.err_wl61_bank1;

        this.err_wl62_63_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_wl62_63_bank1_reg::type_id::create("err_wl62_63_bank1_reg",,get_full_name());
        this.err_wl62_63_bank1_reg.configure(this, null, "");
        this.err_wl62_63_bank1_reg.build();
        this.default_map.add_reg(this.err_wl62_63_bank1_reg, `UVM_REG_ADDR_WIDTH'h254,"RW",0);
            this.err_wl62_63_bank1_reg_err_wl62_bank1 = this.err_wl62_63_bank1_reg.err_wl62_bank1;
            this.err_wl62_bank1 = this.err_wl62_63_bank1_reg.err_wl62_bank1;

            this.err_wl62_63_bank1_reg_err_wl63_bank1 = this.err_wl62_63_bank1_reg.err_wl63_bank1;
            this.err_wl63_bank1 = this.err_wl62_63_bank1_reg.err_wl63_bank1;

        this.err_csl_part0_1_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_csl_part0_1_bank1_reg::type_id::create("err_csl_part0_1_bank1_reg",,get_full_name());
        this.err_csl_part0_1_bank1_reg.configure(this, null, "");
        this.err_csl_part0_1_bank1_reg.build();
        this.default_map.add_reg(this.err_csl_part0_1_bank1_reg, `UVM_REG_ADDR_WIDTH'h258,"RW",0);
            this.err_csl_part0_1_bank1_reg_err_csl0_part0_bank1 = this.err_csl_part0_1_bank1_reg.err_csl0_part0_bank1;
            this.err_csl0_part0_bank1 = this.err_csl_part0_1_bank1_reg.err_csl0_part0_bank1;

            this.err_csl_part0_1_bank1_reg_err_csl1_part0_bank1 = this.err_csl_part0_1_bank1_reg.err_csl1_part0_bank1;
            this.err_csl1_part0_bank1 = this.err_csl_part0_1_bank1_reg.err_csl1_part0_bank1;

            this.err_csl_part0_1_bank1_reg_err_csl0_part1_bank1 = this.err_csl_part0_1_bank1_reg.err_csl0_part1_bank1;
            this.err_csl0_part1_bank1 = this.err_csl_part0_1_bank1_reg.err_csl0_part1_bank1;

            this.err_csl_part0_1_bank1_reg_err_csl1_part1_bank1 = this.err_csl_part0_1_bank1_reg.err_csl1_part1_bank1;
            this.err_csl1_part1_bank1 = this.err_csl_part0_1_bank1_reg.err_csl1_part1_bank1;

        this.err_csl_part2_3_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_csl_part2_3_bank1_reg::type_id::create("err_csl_part2_3_bank1_reg",,get_full_name());
        this.err_csl_part2_3_bank1_reg.configure(this, null, "");
        this.err_csl_part2_3_bank1_reg.build();
        this.default_map.add_reg(this.err_csl_part2_3_bank1_reg, `UVM_REG_ADDR_WIDTH'h25C,"RW",0);
            this.err_csl_part2_3_bank1_reg_err_csl0_part2_bank1 = this.err_csl_part2_3_bank1_reg.err_csl0_part2_bank1;
            this.err_csl0_part2_bank1 = this.err_csl_part2_3_bank1_reg.err_csl0_part2_bank1;

            this.err_csl_part2_3_bank1_reg_err_csl1_part2_bank1 = this.err_csl_part2_3_bank1_reg.err_csl1_part2_bank1;
            this.err_csl1_part2_bank1 = this.err_csl_part2_3_bank1_reg.err_csl1_part2_bank1;

            this.err_csl_part2_3_bank1_reg_err_csl0_part3_bank1 = this.err_csl_part2_3_bank1_reg.err_csl0_part3_bank1;
            this.err_csl0_part3_bank1 = this.err_csl_part2_3_bank1_reg.err_csl0_part3_bank1;

            this.err_csl_part2_3_bank1_reg_err_csl1_part3_bank1 = this.err_csl_part2_3_bank1_reg.err_csl1_part3_bank1;
            this.err_csl1_part3_bank1 = this.err_csl_part2_3_bank1_reg.err_csl1_part3_bank1;

        this.err_csl_part4_5_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_csl_part4_5_bank1_reg::type_id::create("err_csl_part4_5_bank1_reg",,get_full_name());
        this.err_csl_part4_5_bank1_reg.configure(this, null, "");
        this.err_csl_part4_5_bank1_reg.build();
        this.default_map.add_reg(this.err_csl_part4_5_bank1_reg, `UVM_REG_ADDR_WIDTH'h260,"RW",0);
            this.err_csl_part4_5_bank1_reg_err_csl0_part4_bank1 = this.err_csl_part4_5_bank1_reg.err_csl0_part4_bank1;
            this.err_csl0_part4_bank1 = this.err_csl_part4_5_bank1_reg.err_csl0_part4_bank1;

            this.err_csl_part4_5_bank1_reg_err_csl1_part4_bank1 = this.err_csl_part4_5_bank1_reg.err_csl1_part4_bank1;
            this.err_csl1_part4_bank1 = this.err_csl_part4_5_bank1_reg.err_csl1_part4_bank1;

            this.err_csl_part4_5_bank1_reg_err_csl0_part5_bank1 = this.err_csl_part4_5_bank1_reg.err_csl0_part5_bank1;
            this.err_csl0_part5_bank1 = this.err_csl_part4_5_bank1_reg.err_csl0_part5_bank1;

            this.err_csl_part4_5_bank1_reg_err_csl1_part5_bank1 = this.err_csl_part4_5_bank1_reg.err_csl1_part5_bank1;
            this.err_csl1_part5_bank1 = this.err_csl_part4_5_bank1_reg.err_csl1_part5_bank1;

        this.err_csl_part6_7_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_csl_part6_7_bank1_reg::type_id::create("err_csl_part6_7_bank1_reg",,get_full_name());
        this.err_csl_part6_7_bank1_reg.configure(this, null, "");
        this.err_csl_part6_7_bank1_reg.build();
        this.default_map.add_reg(this.err_csl_part6_7_bank1_reg, `UVM_REG_ADDR_WIDTH'h264,"RW",0);
            this.err_csl_part6_7_bank1_reg_err_csl0_part6_bank1 = this.err_csl_part6_7_bank1_reg.err_csl0_part6_bank1;
            this.err_csl0_part6_bank1 = this.err_csl_part6_7_bank1_reg.err_csl0_part6_bank1;

            this.err_csl_part6_7_bank1_reg_err_csl1_part6_bank1 = this.err_csl_part6_7_bank1_reg.err_csl1_part6_bank1;
            this.err_csl1_part6_bank1 = this.err_csl_part6_7_bank1_reg.err_csl1_part6_bank1;

            this.err_csl_part6_7_bank1_reg_err_csl0_part7_bank1 = this.err_csl_part6_7_bank1_reg.err_csl0_part7_bank1;
            this.err_csl0_part7_bank1 = this.err_csl_part6_7_bank1_reg.err_csl0_part7_bank1;

            this.err_csl_part6_7_bank1_reg_err_csl1_part7_bank1 = this.err_csl_part6_7_bank1_reg.err_csl1_part7_bank1;
            this.err_csl1_part7_bank1 = this.err_csl_part6_7_bank1_reg.err_csl1_part7_bank1;

        this.err_csl_part8_9_bank1_reg = ral_reg_mc_1short2_top_aux_top_err_csl_part8_9_bank1_reg::type_id::create("err_csl_part8_9_bank1_reg",,get_full_name());
        this.err_csl_part8_9_bank1_reg.configure(this, null, "");
        this.err_csl_part8_9_bank1_reg.build();
        this.default_map.add_reg(this.err_csl_part8_9_bank1_reg, `UVM_REG_ADDR_WIDTH'h268,"RW",0);
            this.err_csl_part8_9_bank1_reg_err_csl0_part8_bank1 = this.err_csl_part8_9_bank1_reg.err_csl0_part8_bank1;
            this.err_csl0_part8_bank1 = this.err_csl_part8_9_bank1_reg.err_csl0_part8_bank1;

            this.err_csl_part8_9_bank1_reg_err_csl1_part8_bank1 = this.err_csl_part8_9_bank1_reg.err_csl1_part8_bank1;
            this.err_csl1_part8_bank1 = this.err_csl_part8_9_bank1_reg.err_csl1_part8_bank1;

            this.err_csl_part8_9_bank1_reg_err_csl0_part9_bank1 = this.err_csl_part8_9_bank1_reg.err_csl0_part9_bank1;
            this.err_csl0_part9_bank1 = this.err_csl_part8_9_bank1_reg.err_csl0_part9_bank1;

            this.err_csl_part8_9_bank1_reg_err_csl1_part9_bank1 = this.err_csl_part8_9_bank1_reg.err_csl1_part9_bank1;
            this.err_csl1_part9_bank1 = this.err_csl_part8_9_bank1_reg.err_csl1_part9_bank1;

        this.mc_bank_cfg_reg_reg = ral_reg_mc_1short2_top_aux_top_mc_bank_cfg_reg_reg::type_id::create("mc_bank_cfg_reg_reg",,get_full_name());
        this.mc_bank_cfg_reg_reg.configure(this, null, "");
        this.mc_bank_cfg_reg_reg.build();
        this.default_map.add_reg(this.mc_bank_cfg_reg_reg, `UVM_REG_ADDR_WIDTH'h26C,"RW",0);
            this.mc_bank_cfg_reg_reg_mc_bank_map_id = this.mc_bank_cfg_reg_reg.mc_bank_map_id;
            this.mc_bank_map_id = this.mc_bank_cfg_reg_reg.mc_bank_map_id;

            this.mc_bank_cfg_reg_reg_mc_bist_grant = this.mc_bank_cfg_reg_reg.mc_bist_grant;
            this.mc_bist_grant = this.mc_bank_cfg_reg_reg.mc_bist_grant;

        this.mc_timeout_clr_reg = ral_reg_mc_1short2_top_aux_top_mc_timeout_clr_reg::type_id::create("mc_timeout_clr_reg",,get_full_name());
        this.mc_timeout_clr_reg.configure(this, null, "");
        this.mc_timeout_clr_reg.build();
        this.default_map.add_reg(this.mc_timeout_clr_reg, `UVM_REG_ADDR_WIDTH'h270,"RW",0);
            this.mc_timeout_clr_reg_mc_timeout_clr = this.mc_timeout_clr_reg.mc_timeout_clr;
            this.mc_timeout_clr = this.mc_timeout_clr_reg.mc_timeout_clr;

        this.mc_rf_start_dbg_reg = ral_reg_mc_1short2_top_aux_top_mc_rf_start_dbg_reg::type_id::create("mc_rf_start_dbg_reg",,get_full_name());
        this.mc_rf_start_dbg_reg.configure(this, null, "");
        this.mc_rf_start_dbg_reg.build();
        this.default_map.add_reg(this.mc_rf_start_dbg_reg, `UVM_REG_ADDR_WIDTH'h274,"RW",0);
            this.mc_rf_start_dbg_reg_mc_rf_start_dbg = this.mc_rf_start_dbg_reg.mc_rf_start_dbg;
            this.mc_rf_start_dbg = this.mc_rf_start_dbg_reg.mc_rf_start_dbg;

        this.mc_timeout_flag_reg = ral_reg_mc_1short2_top_aux_top_mc_timeout_flag_reg::type_id::create("mc_timeout_flag_reg",,get_full_name());
        this.mc_timeout_flag_reg.configure(this, null, "");
        this.mc_timeout_flag_reg.build();
        this.default_map.add_reg(this.mc_timeout_flag_reg, `UVM_REG_ADDR_WIDTH'h278,"RW",0);
            this.mc_timeout_flag_reg_mc_timeout_flag = this.mc_timeout_flag_reg.mc_timeout_flag;
            this.mc_timeout_flag = this.mc_timeout_flag_reg.mc_timeout_flag;

        this.mc_bist_status_reg = ral_reg_mc_1short2_top_aux_top_mc_bist_status_reg::type_id::create("mc_bist_status_reg",,get_full_name());
        this.mc_bist_status_reg.configure(this, null, "");
        this.mc_bist_status_reg.build();
        this.default_map.add_reg(this.mc_bist_status_reg, `UVM_REG_ADDR_WIDTH'h27C,"RW",0);
            this.mc_bist_status_reg_mc_bist_status = this.mc_bist_status_reg.mc_bist_status;
            this.mc_bist_status = this.mc_bist_status_reg.mc_bist_status;

            this.mc_bist_status_reg_mc_bist_path_fail_bank0 = this.mc_bist_status_reg.mc_bist_path_fail_bank0;
            this.mc_bist_path_fail_bank0 = this.mc_bist_status_reg.mc_bist_path_fail_bank0;

            this.mc_bist_status_reg_mc_bist_path_fail_bank1 = this.mc_bist_status_reg.mc_bist_path_fail_bank1;
            this.mc_bist_path_fail_bank1 = this.mc_bist_status_reg.mc_bist_path_fail_bank1;

            this.mc_bist_status_reg_dram_init_finish = this.mc_bist_status_reg.dram_init_finish;
            this.dram_init_finish = this.mc_bist_status_reg.dram_init_finish;

        this.bist_finish_and_success_reg = ral_reg_mc_1short2_top_aux_top_bist_finish_and_success_reg::type_id::create("bist_finish_and_success_reg",,get_full_name());
        this.bist_finish_and_success_reg.configure(this, null, "");
        this.bist_finish_and_success_reg.build();
        this.default_map.add_reg(this.bist_finish_and_success_reg, `UVM_REG_ADDR_WIDTH'h280,"RW",0);
            this.bist_finish_and_success_reg_bist_finish_bank0 = this.bist_finish_and_success_reg.bist_finish_bank0;
            this.bist_finish_bank0 = this.bist_finish_and_success_reg.bist_finish_bank0;

            this.bist_finish_and_success_reg_bist_finish_bank1 = this.bist_finish_and_success_reg.bist_finish_bank1;
            this.bist_finish_bank1 = this.bist_finish_and_success_reg.bist_finish_bank1;

            this.bist_finish_and_success_reg_bist_rescan_finish_bank0 = this.bist_finish_and_success_reg.bist_rescan_finish_bank0;
            this.bist_rescan_finish_bank0 = this.bist_finish_and_success_reg.bist_rescan_finish_bank0;

            this.bist_finish_and_success_reg_bist_rescan_finish_bank1 = this.bist_finish_and_success_reg.bist_rescan_finish_bank1;
            this.bist_rescan_finish_bank1 = this.bist_finish_and_success_reg.bist_rescan_finish_bank1;

            this.bist_finish_and_success_reg_bank_success_bank0 = this.bist_finish_and_success_reg.bank_success_bank0;
            this.bank_success_bank0 = this.bist_finish_and_success_reg.bank_success_bank0;

            this.bist_finish_and_success_reg_bank_success_bank1 = this.bist_finish_and_success_reg.bank_success_bank1;
            this.bank_success_bank1 = this.bist_finish_and_success_reg.bank_success_bank1;

            this.bist_finish_and_success_reg_bist_rescan_success_bank0 = this.bist_finish_and_success_reg.bist_rescan_success_bank0;
            this.bist_rescan_success_bank0 = this.bist_finish_and_success_reg.bist_rescan_success_bank0;

            this.bist_finish_and_success_reg_bist_rescan_success_bank1 = this.bist_finish_and_success_reg.bist_rescan_success_bank1;
            this.bist_rescan_success_bank1 = this.bist_finish_and_success_reg.bist_rescan_success_bank1;

        this.mc_bist_rescan_fail_num_bank0_reg = ral_reg_mc_1short2_top_aux_top_mc_bist_rescan_fail_num_bank0_reg::type_id::create("mc_bist_rescan_fail_num_bank0_reg",,get_full_name());
        this.mc_bist_rescan_fail_num_bank0_reg.configure(this, null, "");
        this.mc_bist_rescan_fail_num_bank0_reg.build();
        this.default_map.add_reg(this.mc_bist_rescan_fail_num_bank0_reg, `UVM_REG_ADDR_WIDTH'h284,"RW",0);
            this.mc_bist_rescan_fail_num_bank0_reg_mc_bist_rescan_fail_num_bank0 = this.mc_bist_rescan_fail_num_bank0_reg.mc_bist_rescan_fail_num_bank0;
            this.mc_bist_rescan_fail_num_bank0 = this.mc_bist_rescan_fail_num_bank0_reg.mc_bist_rescan_fail_num_bank0;

        this.mc_bist_rescan_fail_num_bank1_reg = ral_reg_mc_1short2_top_aux_top_mc_bist_rescan_fail_num_bank1_reg::type_id::create("mc_bist_rescan_fail_num_bank1_reg",,get_full_name());
        this.mc_bist_rescan_fail_num_bank1_reg.configure(this, null, "");
        this.mc_bist_rescan_fail_num_bank1_reg.build();
        this.default_map.add_reg(this.mc_bist_rescan_fail_num_bank1_reg, `UVM_REG_ADDR_WIDTH'h288,"RW",0);
            this.mc_bist_rescan_fail_num_bank1_reg_mc_bist_rescan_fail_num_bank1 = this.mc_bist_rescan_fail_num_bank1_reg.mc_bist_rescan_fail_num_bank1;
            this.mc_bist_rescan_fail_num_bank1 = this.mc_bist_rescan_fail_num_bank1_reg.mc_bist_rescan_fail_num_bank1;

        this.mc_bist_err_wl_reg = ral_reg_mc_1short2_top_aux_top_mc_bist_err_wl_reg::type_id::create("mc_bist_err_wl_reg",,get_full_name());
        this.mc_bist_err_wl_reg.configure(this, null, "");
        this.mc_bist_err_wl_reg.build();
        this.default_map.add_reg(this.mc_bist_err_wl_reg, `UVM_REG_ADDR_WIDTH'h294,"RW",0);
            this.mc_bist_err_wl_reg_mc_bist_err_wl_num_bank0 = this.mc_bist_err_wl_reg.mc_bist_err_wl_num_bank0;
            this.mc_bist_err_wl_num_bank0 = this.mc_bist_err_wl_reg.mc_bist_err_wl_num_bank0;

            this.mc_bist_err_wl_reg_mc_bist_err_wl_num_bank1 = this.mc_bist_err_wl_reg.mc_bist_err_wl_num_bank1;
            this.mc_bist_err_wl_num_bank1 = this.mc_bist_err_wl_reg.mc_bist_err_wl_num_bank1;

            this.mc_bist_err_wl_reg_err_wl_num_change_flag_bank0 = this.mc_bist_err_wl_reg.err_wl_num_change_flag_bank0;
            this.err_wl_num_change_flag_bank0 = this.mc_bist_err_wl_reg.err_wl_num_change_flag_bank0;

            this.mc_bist_err_wl_reg_err_wl_num_change_flag_bank1 = this.mc_bist_err_wl_reg.err_wl_num_change_flag_bank1;
            this.err_wl_num_change_flag_bank1 = this.mc_bist_err_wl_reg.err_wl_num_change_flag_bank1;

        this.rescan_finish_clr_reg = ral_reg_mc_1short2_top_aux_top_rescan_finish_clr_reg::type_id::create("rescan_finish_clr_reg",,get_full_name());
        this.rescan_finish_clr_reg.configure(this, null, "");
        this.rescan_finish_clr_reg.build();
        this.default_map.add_reg(this.rescan_finish_clr_reg, `UVM_REG_ADDR_WIDTH'h298,"RW",0);
            this.rescan_finish_clr_reg_rescan_finish_clr = this.rescan_finish_clr_reg.rescan_finish_clr;
            this.rescan_finish_clr = this.rescan_finish_clr_reg.rescan_finish_clr;

        this.rescan_finish_mask_reg = ral_reg_mc_1short2_top_aux_top_rescan_finish_mask_reg::type_id::create("rescan_finish_mask_reg",,get_full_name());
        this.rescan_finish_mask_reg.configure(this, null, "");
        this.rescan_finish_mask_reg.build();
        this.default_map.add_reg(this.rescan_finish_mask_reg, `UVM_REG_ADDR_WIDTH'h29C,"RW",0);
            this.rescan_finish_mask_reg_rescan_finish_mask = this.rescan_finish_mask_reg.rescan_finish_mask;
            this.rescan_finish_mask = this.rescan_finish_mask_reg.rescan_finish_mask;

        this.rescan_round_result_1_reg = ral_reg_mc_1short2_top_aux_top_rescan_round_result_1_reg::type_id::create("rescan_round_result_1_reg",,get_full_name());
        this.rescan_round_result_1_reg.configure(this, null, "");
        this.rescan_round_result_1_reg.build();
        this.default_map.add_reg(this.rescan_round_result_1_reg, `UVM_REG_ADDR_WIDTH'h2A0,"RW",0);
            this.rescan_round_result_1_reg_rescan_round_result_bank0 = this.rescan_round_result_1_reg.rescan_round_result_bank0;
            this.rescan_round_result_bank0 = this.rescan_round_result_1_reg.rescan_round_result_bank0;

            this.rescan_round_result_1_reg_rescan_round_result_bank1 = this.rescan_round_result_1_reg.rescan_round_result_bank1;
            this.rescan_round_result_bank1 = this.rescan_round_result_1_reg.rescan_round_result_bank1;

        this.bist_finish_clr_reg = ral_reg_mc_1short2_top_aux_top_bist_finish_clr_reg::type_id::create("bist_finish_clr_reg",,get_full_name());
        this.bist_finish_clr_reg.configure(this, null, "");
        this.bist_finish_clr_reg.build();
        this.default_map.add_reg(this.bist_finish_clr_reg, `UVM_REG_ADDR_WIDTH'h2A8,"RW",0);
            this.bist_finish_clr_reg_bist_finish_clr = this.bist_finish_clr_reg.bist_finish_clr;
            this.bist_finish_clr = this.bist_finish_clr_reg.bist_finish_clr;

        this.bist_finish_mask_reg = ral_reg_mc_1short2_top_aux_top_bist_finish_mask_reg::type_id::create("bist_finish_mask_reg",,get_full_name());
        this.bist_finish_mask_reg.configure(this, null, "");
        this.bist_finish_mask_reg.build();
        this.default_map.add_reg(this.bist_finish_mask_reg, `UVM_REG_ADDR_WIDTH'h2AC,"RW",0);
            this.bist_finish_mask_reg_bist_finish_mask = this.bist_finish_mask_reg.bist_finish_mask;
            this.bist_finish_mask = this.bist_finish_mask_reg.bist_finish_mask;

        this.hang_timeout_th_reg = ral_reg_mc_1short2_top_aux_top_hang_timeout_th_reg::type_id::create("hang_timeout_th_reg",,get_full_name());
        this.hang_timeout_th_reg.configure(this, null, "");
        this.hang_timeout_th_reg.build();
        this.default_map.add_reg(this.hang_timeout_th_reg, `UVM_REG_ADDR_WIDTH'h2B0,"RW",0);
            this.hang_timeout_th_reg_hang_timeout_th = this.hang_timeout_th_reg.hang_timeout_th;
            this.hang_timeout_th = this.hang_timeout_th_reg.hang_timeout_th;

        this.bist_pattern_reg0_reg = ral_reg_mc_1short2_top_aux_top_bist_pattern_reg0_reg::type_id::create("bist_pattern_reg0_reg",,get_full_name());
        this.bist_pattern_reg0_reg.configure(this, null, "");
        this.bist_pattern_reg0_reg.build();
        this.default_map.add_reg(this.bist_pattern_reg0_reg, `UVM_REG_ADDR_WIDTH'h2B4,"RW",0);
            this.bist_pattern_reg0_reg_bist_pattern_reg0 = this.bist_pattern_reg0_reg.bist_pattern_reg0;
            this.bist_pattern_reg0 = this.bist_pattern_reg0_reg.bist_pattern_reg0;

        this.bist_pattern_reg1_reg = ral_reg_mc_1short2_top_aux_top_bist_pattern_reg1_reg::type_id::create("bist_pattern_reg1_reg",,get_full_name());
        this.bist_pattern_reg1_reg.configure(this, null, "");
        this.bist_pattern_reg1_reg.build();
        this.default_map.add_reg(this.bist_pattern_reg1_reg, `UVM_REG_ADDR_WIDTH'h2B8,"RW",0);
            this.bist_pattern_reg1_reg_bist_pattern_reg1 = this.bist_pattern_reg1_reg.bist_pattern_reg1;
            this.bist_pattern_reg1 = this.bist_pattern_reg1_reg.bist_pattern_reg1;

        this.bist_pattern_reg2_reg = ral_reg_mc_1short2_top_aux_top_bist_pattern_reg2_reg::type_id::create("bist_pattern_reg2_reg",,get_full_name());
        this.bist_pattern_reg2_reg.configure(this, null, "");
        this.bist_pattern_reg2_reg.build();
        this.default_map.add_reg(this.bist_pattern_reg2_reg, `UVM_REG_ADDR_WIDTH'h2BC,"RW",0);
            this.bist_pattern_reg2_reg_bist_pattern_reg2 = this.bist_pattern_reg2_reg.bist_pattern_reg2;
            this.bist_pattern_reg2 = this.bist_pattern_reg2_reg.bist_pattern_reg2;

        this.bist_pattern_reg3_reg = ral_reg_mc_1short2_top_aux_top_bist_pattern_reg3_reg::type_id::create("bist_pattern_reg3_reg",,get_full_name());
        this.bist_pattern_reg3_reg.configure(this, null, "");
        this.bist_pattern_reg3_reg.build();
        this.default_map.add_reg(this.bist_pattern_reg3_reg, `UVM_REG_ADDR_WIDTH'h2C0,"RW",0);
            this.bist_pattern_reg3_reg_bist_pattern_reg3 = this.bist_pattern_reg3_reg.bist_pattern_reg3;
            this.bist_pattern_reg3 = this.bist_pattern_reg3_reg.bist_pattern_reg3;

        this.csl_bist_pattern_sel0_reg = ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel0_reg::type_id::create("csl_bist_pattern_sel0_reg",,get_full_name());
        this.csl_bist_pattern_sel0_reg.configure(this, null, "");
        this.csl_bist_pattern_sel0_reg.build();
        this.default_map.add_reg(this.csl_bist_pattern_sel0_reg, `UVM_REG_ADDR_WIDTH'h2C4,"RW",0);
            this.csl_bist_pattern_sel0_reg_csl_bist_pattern_sel0 = this.csl_bist_pattern_sel0_reg.csl_bist_pattern_sel0;
            this.csl_bist_pattern_sel0 = this.csl_bist_pattern_sel0_reg.csl_bist_pattern_sel0;

        this.csl_bist_pattern_sel1_reg = ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel1_reg::type_id::create("csl_bist_pattern_sel1_reg",,get_full_name());
        this.csl_bist_pattern_sel1_reg.configure(this, null, "");
        this.csl_bist_pattern_sel1_reg.build();
        this.default_map.add_reg(this.csl_bist_pattern_sel1_reg, `UVM_REG_ADDR_WIDTH'h2C8,"RW",0);
            this.csl_bist_pattern_sel1_reg_csl_bist_pattern_sel1 = this.csl_bist_pattern_sel1_reg.csl_bist_pattern_sel1;
            this.csl_bist_pattern_sel1 = this.csl_bist_pattern_sel1_reg.csl_bist_pattern_sel1;

        this.csl_bist_pattern_sel2_reg = ral_reg_mc_1short2_top_aux_top_csl_bist_pattern_sel2_reg::type_id::create("csl_bist_pattern_sel2_reg",,get_full_name());
        this.csl_bist_pattern_sel2_reg.configure(this, null, "");
        this.csl_bist_pattern_sel2_reg.build();
        this.default_map.add_reg(this.csl_bist_pattern_sel2_reg, `UVM_REG_ADDR_WIDTH'h2CC,"RW",0);
            this.csl_bist_pattern_sel2_reg_csl_bist_pattern_sel2 = this.csl_bist_pattern_sel2_reg.csl_bist_pattern_sel2;
            this.csl_bist_pattern_sel2 = this.csl_bist_pattern_sel2_reg.csl_bist_pattern_sel2;

        this.wl_bist_pattern_sel0_reg = ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel0_reg::type_id::create("wl_bist_pattern_sel0_reg",,get_full_name());
        this.wl_bist_pattern_sel0_reg.configure(this, null, "");
        this.wl_bist_pattern_sel0_reg.build();
        this.default_map.add_reg(this.wl_bist_pattern_sel0_reg, `UVM_REG_ADDR_WIDTH'h2D0,"RW",0);
            this.wl_bist_pattern_sel0_reg_wl_bist_pattern_sel0 = this.wl_bist_pattern_sel0_reg.wl_bist_pattern_sel0;
            this.wl_bist_pattern_sel0 = this.wl_bist_pattern_sel0_reg.wl_bist_pattern_sel0;

        this.wl_bist_pattern_sel1_reg = ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel1_reg::type_id::create("wl_bist_pattern_sel1_reg",,get_full_name());
        this.wl_bist_pattern_sel1_reg.configure(this, null, "");
        this.wl_bist_pattern_sel1_reg.build();
        this.default_map.add_reg(this.wl_bist_pattern_sel1_reg, `UVM_REG_ADDR_WIDTH'h2D4,"RW",0);
            this.wl_bist_pattern_sel1_reg_wl_bist_pattern_sel1 = this.wl_bist_pattern_sel1_reg.wl_bist_pattern_sel1;
            this.wl_bist_pattern_sel1 = this.wl_bist_pattern_sel1_reg.wl_bist_pattern_sel1;

        this.wl_bist_pattern_sel2_reg = ral_reg_mc_1short2_top_aux_top_wl_bist_pattern_sel2_reg::type_id::create("wl_bist_pattern_sel2_reg",,get_full_name());
        this.wl_bist_pattern_sel2_reg.configure(this, null, "");
        this.wl_bist_pattern_sel2_reg.build();
        this.default_map.add_reg(this.wl_bist_pattern_sel2_reg, `UVM_REG_ADDR_WIDTH'h2D8,"RW",0);
            this.wl_bist_pattern_sel2_reg_wl_bist_pattern_sel2 = this.wl_bist_pattern_sel2_reg.wl_bist_pattern_sel2;
            this.wl_bist_pattern_sel2 = this.wl_bist_pattern_sel2_reg.wl_bist_pattern_sel2;

        this.mc_frame2array_dbg_reg = ral_reg_mc_1short2_top_aux_top_mc_frame2array_dbg_reg::type_id::create("mc_frame2array_dbg_reg",,get_full_name());
        this.mc_frame2array_dbg_reg.configure(this, null, "");
        this.mc_frame2array_dbg_reg.build();
        this.default_map.add_reg(this.mc_frame2array_dbg_reg, `UVM_REG_ADDR_WIDTH'h2DC,"RW",0);
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

        this.dbg_frame_store_0_reg = ral_reg_mc_1short2_top_aux_top_dbg_frame_store_0_reg::type_id::create("dbg_frame_store_0_reg",,get_full_name());
        this.dbg_frame_store_0_reg.configure(this, null, "");
        this.dbg_frame_store_0_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_0_reg, `UVM_REG_ADDR_WIDTH'h2E0,"RW",0);
            this.dbg_frame_store_0_reg_dbg_frame_store_0 = this.dbg_frame_store_0_reg.dbg_frame_store_0;
            this.dbg_frame_store_0 = this.dbg_frame_store_0_reg.dbg_frame_store_0;

        this.dbg_frame_store_1_reg = ral_reg_mc_1short2_top_aux_top_dbg_frame_store_1_reg::type_id::create("dbg_frame_store_1_reg",,get_full_name());
        this.dbg_frame_store_1_reg.configure(this, null, "");
        this.dbg_frame_store_1_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_1_reg, `UVM_REG_ADDR_WIDTH'h2E4,"RW",0);
            this.dbg_frame_store_1_reg_dbg_frame_store_1 = this.dbg_frame_store_1_reg.dbg_frame_store_1;
            this.dbg_frame_store_1 = this.dbg_frame_store_1_reg.dbg_frame_store_1;

        this.dbg_frame_store_2_reg = ral_reg_mc_1short2_top_aux_top_dbg_frame_store_2_reg::type_id::create("dbg_frame_store_2_reg",,get_full_name());
        this.dbg_frame_store_2_reg.configure(this, null, "");
        this.dbg_frame_store_2_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_2_reg, `UVM_REG_ADDR_WIDTH'h2E8,"RW",0);
            this.dbg_frame_store_2_reg_dbg_frame_store_2 = this.dbg_frame_store_2_reg.dbg_frame_store_2;
            this.dbg_frame_store_2 = this.dbg_frame_store_2_reg.dbg_frame_store_2;

        this.dbg_frame_store_3_reg = ral_reg_mc_1short2_top_aux_top_dbg_frame_store_3_reg::type_id::create("dbg_frame_store_3_reg",,get_full_name());
        this.dbg_frame_store_3_reg.configure(this, null, "");
        this.dbg_frame_store_3_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_3_reg, `UVM_REG_ADDR_WIDTH'h2EC,"RW",0);
            this.dbg_frame_store_3_reg_dbg_frame_store_3 = this.dbg_frame_store_3_reg.dbg_frame_store_3;
            this.dbg_frame_store_3 = this.dbg_frame_store_3_reg.dbg_frame_store_3;

        this.dbg_frame_store_4_reg = ral_reg_mc_1short2_top_aux_top_dbg_frame_store_4_reg::type_id::create("dbg_frame_store_4_reg",,get_full_name());
        this.dbg_frame_store_4_reg.configure(this, null, "");
        this.dbg_frame_store_4_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_4_reg, `UVM_REG_ADDR_WIDTH'h2F0,"RW",0);
            this.dbg_frame_store_4_reg_dbg_frame_store_4 = this.dbg_frame_store_4_reg.dbg_frame_store_4;
            this.dbg_frame_store_4 = this.dbg_frame_store_4_reg.dbg_frame_store_4;

        this.dbg_frame_store_5_reg = ral_reg_mc_1short2_top_aux_top_dbg_frame_store_5_reg::type_id::create("dbg_frame_store_5_reg",,get_full_name());
        this.dbg_frame_store_5_reg.configure(this, null, "");
        this.dbg_frame_store_5_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_5_reg, `UVM_REG_ADDR_WIDTH'h2F4,"RW",0);
            this.dbg_frame_store_5_reg_dbg_frame_store_5 = this.dbg_frame_store_5_reg.dbg_frame_store_5;
            this.dbg_frame_store_5 = this.dbg_frame_store_5_reg.dbg_frame_store_5;

        this.dbg_frame_store_6_reg = ral_reg_mc_1short2_top_aux_top_dbg_frame_store_6_reg::type_id::create("dbg_frame_store_6_reg",,get_full_name());
        this.dbg_frame_store_6_reg.configure(this, null, "");
        this.dbg_frame_store_6_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_6_reg, `UVM_REG_ADDR_WIDTH'h2F8,"RW",0);
            this.dbg_frame_store_6_reg_dbg_frame_store_6 = this.dbg_frame_store_6_reg.dbg_frame_store_6;
            this.dbg_frame_store_6 = this.dbg_frame_store_6_reg.dbg_frame_store_6;

        this.dbg_frame_store_7_reg = ral_reg_mc_1short2_top_aux_top_dbg_frame_store_7_reg::type_id::create("dbg_frame_store_7_reg",,get_full_name());
        this.dbg_frame_store_7_reg.configure(this, null, "");
        this.dbg_frame_store_7_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_7_reg, `UVM_REG_ADDR_WIDTH'h2FC,"RW",0);
            this.dbg_frame_store_7_reg_dbg_frame_store_7 = this.dbg_frame_store_7_reg.dbg_frame_store_7;
            this.dbg_frame_store_7 = this.dbg_frame_store_7_reg.dbg_frame_store_7;

        this.dbg_frame_store_8_reg = ral_reg_mc_1short2_top_aux_top_dbg_frame_store_8_reg::type_id::create("dbg_frame_store_8_reg",,get_full_name());
        this.dbg_frame_store_8_reg.configure(this, null, "");
        this.dbg_frame_store_8_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_8_reg, `UVM_REG_ADDR_WIDTH'h300,"RW",0);
            this.dbg_frame_store_8_reg_dbg_frame_store_8 = this.dbg_frame_store_8_reg.dbg_frame_store_8;
            this.dbg_frame_store_8 = this.dbg_frame_store_8_reg.dbg_frame_store_8;

        this.dbg_frame_store_9_reg = ral_reg_mc_1short2_top_aux_top_dbg_frame_store_9_reg::type_id::create("dbg_frame_store_9_reg",,get_full_name());
        this.dbg_frame_store_9_reg.configure(this, null, "");
        this.dbg_frame_store_9_reg.build();
        this.default_map.add_reg(this.dbg_frame_store_9_reg, `UVM_REG_ADDR_WIDTH'h304,"RW",0);
            this.dbg_frame_store_9_reg_dbg_frame_store_9 = this.dbg_frame_store_9_reg.dbg_frame_store_9;
            this.dbg_frame_store_9 = this.dbg_frame_store_9_reg.dbg_frame_store_9;

        this.dbg_rdata_store_0_reg = ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_0_reg::type_id::create("dbg_rdata_store_0_reg",,get_full_name());
        this.dbg_rdata_store_0_reg.configure(this, null, "");
        this.dbg_rdata_store_0_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_0_reg, `UVM_REG_ADDR_WIDTH'h308,"RW",0);
            this.dbg_rdata_store_0_reg_dbg_rdata_store_0 = this.dbg_rdata_store_0_reg.dbg_rdata_store_0;
            this.dbg_rdata_store_0 = this.dbg_rdata_store_0_reg.dbg_rdata_store_0;

        this.dbg_rdata_store_1_reg = ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_1_reg::type_id::create("dbg_rdata_store_1_reg",,get_full_name());
        this.dbg_rdata_store_1_reg.configure(this, null, "");
        this.dbg_rdata_store_1_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_1_reg, `UVM_REG_ADDR_WIDTH'h30C,"RW",0);
            this.dbg_rdata_store_1_reg_dbg_rdata_store_1 = this.dbg_rdata_store_1_reg.dbg_rdata_store_1;
            this.dbg_rdata_store_1 = this.dbg_rdata_store_1_reg.dbg_rdata_store_1;

        this.dbg_rdata_store_2_reg = ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_2_reg::type_id::create("dbg_rdata_store_2_reg",,get_full_name());
        this.dbg_rdata_store_2_reg.configure(this, null, "");
        this.dbg_rdata_store_2_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_2_reg, `UVM_REG_ADDR_WIDTH'h310,"RW",0);
            this.dbg_rdata_store_2_reg_dbg_rdata_store_2 = this.dbg_rdata_store_2_reg.dbg_rdata_store_2;
            this.dbg_rdata_store_2 = this.dbg_rdata_store_2_reg.dbg_rdata_store_2;

        this.dbg_rdata_store_3_reg = ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_3_reg::type_id::create("dbg_rdata_store_3_reg",,get_full_name());
        this.dbg_rdata_store_3_reg.configure(this, null, "");
        this.dbg_rdata_store_3_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_3_reg, `UVM_REG_ADDR_WIDTH'h314,"RW",0);
            this.dbg_rdata_store_3_reg_dbg_rdata_store_3 = this.dbg_rdata_store_3_reg.dbg_rdata_store_3;
            this.dbg_rdata_store_3 = this.dbg_rdata_store_3_reg.dbg_rdata_store_3;

        this.dbg_rdata_store_4_reg = ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_4_reg::type_id::create("dbg_rdata_store_4_reg",,get_full_name());
        this.dbg_rdata_store_4_reg.configure(this, null, "");
        this.dbg_rdata_store_4_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_4_reg, `UVM_REG_ADDR_WIDTH'h318,"RW",0);
            this.dbg_rdata_store_4_reg_dbg_rdata_store_4 = this.dbg_rdata_store_4_reg.dbg_rdata_store_4;
            this.dbg_rdata_store_4 = this.dbg_rdata_store_4_reg.dbg_rdata_store_4;

        this.dbg_rdata_store_5_reg = ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_5_reg::type_id::create("dbg_rdata_store_5_reg",,get_full_name());
        this.dbg_rdata_store_5_reg.configure(this, null, "");
        this.dbg_rdata_store_5_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_5_reg, `UVM_REG_ADDR_WIDTH'h31C,"RW",0);
            this.dbg_rdata_store_5_reg_dbg_rdata_store_5 = this.dbg_rdata_store_5_reg.dbg_rdata_store_5;
            this.dbg_rdata_store_5 = this.dbg_rdata_store_5_reg.dbg_rdata_store_5;

        this.dbg_rdata_store_6_reg = ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_6_reg::type_id::create("dbg_rdata_store_6_reg",,get_full_name());
        this.dbg_rdata_store_6_reg.configure(this, null, "");
        this.dbg_rdata_store_6_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_6_reg, `UVM_REG_ADDR_WIDTH'h320,"RW",0);
            this.dbg_rdata_store_6_reg_dbg_rdata_store_6 = this.dbg_rdata_store_6_reg.dbg_rdata_store_6;
            this.dbg_rdata_store_6 = this.dbg_rdata_store_6_reg.dbg_rdata_store_6;

        this.dbg_rdata_store_7_reg = ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_7_reg::type_id::create("dbg_rdata_store_7_reg",,get_full_name());
        this.dbg_rdata_store_7_reg.configure(this, null, "");
        this.dbg_rdata_store_7_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_7_reg, `UVM_REG_ADDR_WIDTH'h324,"RW",0);
            this.dbg_rdata_store_7_reg_dbg_rdata_store_7 = this.dbg_rdata_store_7_reg.dbg_rdata_store_7;
            this.dbg_rdata_store_7 = this.dbg_rdata_store_7_reg.dbg_rdata_store_7;

        this.dbg_rdata_store_8_reg = ral_reg_mc_1short2_top_aux_top_dbg_rdata_store_8_reg::type_id::create("dbg_rdata_store_8_reg",,get_full_name());
        this.dbg_rdata_store_8_reg.configure(this, null, "");
        this.dbg_rdata_store_8_reg.build();
        this.default_map.add_reg(this.dbg_rdata_store_8_reg, `UVM_REG_ADDR_WIDTH'h328,"RW",0);
            this.dbg_rdata_store_8_reg_dbg_rdata_store_8 = this.dbg_rdata_store_8_reg.dbg_rdata_store_8;
            this.dbg_rdata_store_8 = this.dbg_rdata_store_8_reg.dbg_rdata_store_8;

        this.mc_ecc_ce_ctrl_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_ctrl_reg::type_id::create("mc_ecc_ce_ctrl_reg",,get_full_name());
        this.mc_ecc_ce_ctrl_reg.configure(this, null, "");
        this.mc_ecc_ce_ctrl_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_ctrl_reg, `UVM_REG_ADDR_WIDTH'h32C,"RW",0);
            this.mc_ecc_ce_ctrl_reg_mc_ecc_ce_int_clr = this.mc_ecc_ce_ctrl_reg.mc_ecc_ce_int_clr;
            this.mc_ecc_ce_int_clr = this.mc_ecc_ce_ctrl_reg.mc_ecc_ce_int_clr;

            this.mc_ecc_ce_ctrl_reg_mc_ecc_ce_overflow_int = this.mc_ecc_ce_ctrl_reg.mc_ecc_ce_overflow_int;
            this.mc_ecc_ce_overflow_int = this.mc_ecc_ce_ctrl_reg.mc_ecc_ce_overflow_int;

            this.mc_ecc_ce_ctrl_reg_mc_ecc_ce_th = this.mc_ecc_ce_ctrl_reg.mc_ecc_ce_th;
            this.mc_ecc_ce_th = this.mc_ecc_ce_ctrl_reg.mc_ecc_ce_th;

            this.mc_ecc_ce_ctrl_reg_mc_ecc_ce_cnt = this.mc_ecc_ce_ctrl_reg.mc_ecc_ce_cnt;
            this.mc_ecc_ce_cnt = this.mc_ecc_ce_ctrl_reg.mc_ecc_ce_cnt;

            this.mc_ecc_ce_ctrl_reg_mc_ecc_ce_int_mask = this.mc_ecc_ce_ctrl_reg.mc_ecc_ce_int_mask;
            this.mc_ecc_ce_int_mask = this.mc_ecc_ce_ctrl_reg.mc_ecc_ce_int_mask;

            this.mc_ecc_ce_ctrl_reg_mc_ecc_ce_int_en = this.mc_ecc_ce_ctrl_reg.mc_ecc_ce_int_en;
            this.mc_ecc_ce_int_en = this.mc_ecc_ce_ctrl_reg.mc_ecc_ce_int_en;

        this.mc_ecc_ce_addr0_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr0_reg::type_id::create("mc_ecc_ce_addr0_reg",,get_full_name());
        this.mc_ecc_ce_addr0_reg.configure(this, null, "");
        this.mc_ecc_ce_addr0_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr0_reg, `UVM_REG_ADDR_WIDTH'h330,"RW",0);
            this.mc_ecc_ce_addr0_reg_mc_ecc_ce_addr0 = this.mc_ecc_ce_addr0_reg.mc_ecc_ce_addr0;
            this.mc_ecc_ce_addr0 = this.mc_ecc_ce_addr0_reg.mc_ecc_ce_addr0;

            this.mc_ecc_ce_addr0_reg_mc_ecc_ce_addr_vld0 = this.mc_ecc_ce_addr0_reg.mc_ecc_ce_addr_vld0;
            this.mc_ecc_ce_addr_vld0 = this.mc_ecc_ce_addr0_reg.mc_ecc_ce_addr_vld0;

            this.mc_ecc_ce_addr0_reg_mc_ecc_ce_addr_cnt0 = this.mc_ecc_ce_addr0_reg.mc_ecc_ce_addr_cnt0;
            this.mc_ecc_ce_addr_cnt0 = this.mc_ecc_ce_addr0_reg.mc_ecc_ce_addr_cnt0;

        this.mc_ecc_ce_addr1_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr1_reg::type_id::create("mc_ecc_ce_addr1_reg",,get_full_name());
        this.mc_ecc_ce_addr1_reg.configure(this, null, "");
        this.mc_ecc_ce_addr1_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr1_reg, `UVM_REG_ADDR_WIDTH'h334,"RW",0);
            this.mc_ecc_ce_addr1_reg_mc_ecc_ce_addr1 = this.mc_ecc_ce_addr1_reg.mc_ecc_ce_addr1;
            this.mc_ecc_ce_addr1 = this.mc_ecc_ce_addr1_reg.mc_ecc_ce_addr1;

            this.mc_ecc_ce_addr1_reg_mc_ecc_ce_addr_vld1 = this.mc_ecc_ce_addr1_reg.mc_ecc_ce_addr_vld1;
            this.mc_ecc_ce_addr_vld1 = this.mc_ecc_ce_addr1_reg.mc_ecc_ce_addr_vld1;

            this.mc_ecc_ce_addr1_reg_mc_ecc_ce_addr_cnt1 = this.mc_ecc_ce_addr1_reg.mc_ecc_ce_addr_cnt1;
            this.mc_ecc_ce_addr_cnt1 = this.mc_ecc_ce_addr1_reg.mc_ecc_ce_addr_cnt1;

        this.mc_ecc_ce_addr2_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr2_reg::type_id::create("mc_ecc_ce_addr2_reg",,get_full_name());
        this.mc_ecc_ce_addr2_reg.configure(this, null, "");
        this.mc_ecc_ce_addr2_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr2_reg, `UVM_REG_ADDR_WIDTH'h338,"RW",0);
            this.mc_ecc_ce_addr2_reg_mc_ecc_ce_addr2 = this.mc_ecc_ce_addr2_reg.mc_ecc_ce_addr2;
            this.mc_ecc_ce_addr2 = this.mc_ecc_ce_addr2_reg.mc_ecc_ce_addr2;

            this.mc_ecc_ce_addr2_reg_mc_ecc_ce_addr_vld2 = this.mc_ecc_ce_addr2_reg.mc_ecc_ce_addr_vld2;
            this.mc_ecc_ce_addr_vld2 = this.mc_ecc_ce_addr2_reg.mc_ecc_ce_addr_vld2;

            this.mc_ecc_ce_addr2_reg_mc_ecc_ce_addr_cnt2 = this.mc_ecc_ce_addr2_reg.mc_ecc_ce_addr_cnt2;
            this.mc_ecc_ce_addr_cnt2 = this.mc_ecc_ce_addr2_reg.mc_ecc_ce_addr_cnt2;

        this.mc_ecc_ce_addr3_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr3_reg::type_id::create("mc_ecc_ce_addr3_reg",,get_full_name());
        this.mc_ecc_ce_addr3_reg.configure(this, null, "");
        this.mc_ecc_ce_addr3_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr3_reg, `UVM_REG_ADDR_WIDTH'h33C,"RW",0);
            this.mc_ecc_ce_addr3_reg_mc_ecc_ce_addr3 = this.mc_ecc_ce_addr3_reg.mc_ecc_ce_addr3;
            this.mc_ecc_ce_addr3 = this.mc_ecc_ce_addr3_reg.mc_ecc_ce_addr3;

            this.mc_ecc_ce_addr3_reg_mc_ecc_ce_addr_vld3 = this.mc_ecc_ce_addr3_reg.mc_ecc_ce_addr_vld3;
            this.mc_ecc_ce_addr_vld3 = this.mc_ecc_ce_addr3_reg.mc_ecc_ce_addr_vld3;

            this.mc_ecc_ce_addr3_reg_mc_ecc_ce_addr_cnt3 = this.mc_ecc_ce_addr3_reg.mc_ecc_ce_addr_cnt3;
            this.mc_ecc_ce_addr_cnt3 = this.mc_ecc_ce_addr3_reg.mc_ecc_ce_addr_cnt3;

        this.mc_ecc_ce_addr4_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr4_reg::type_id::create("mc_ecc_ce_addr4_reg",,get_full_name());
        this.mc_ecc_ce_addr4_reg.configure(this, null, "");
        this.mc_ecc_ce_addr4_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr4_reg, `UVM_REG_ADDR_WIDTH'h340,"RW",0);
            this.mc_ecc_ce_addr4_reg_mc_ecc_ce_addr4 = this.mc_ecc_ce_addr4_reg.mc_ecc_ce_addr4;
            this.mc_ecc_ce_addr4 = this.mc_ecc_ce_addr4_reg.mc_ecc_ce_addr4;

            this.mc_ecc_ce_addr4_reg_mc_ecc_ce_addr_vld4 = this.mc_ecc_ce_addr4_reg.mc_ecc_ce_addr_vld4;
            this.mc_ecc_ce_addr_vld4 = this.mc_ecc_ce_addr4_reg.mc_ecc_ce_addr_vld4;

            this.mc_ecc_ce_addr4_reg_mc_ecc_ce_addr_cnt4 = this.mc_ecc_ce_addr4_reg.mc_ecc_ce_addr_cnt4;
            this.mc_ecc_ce_addr_cnt4 = this.mc_ecc_ce_addr4_reg.mc_ecc_ce_addr_cnt4;

        this.mc_ecc_ce_addr5_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr5_reg::type_id::create("mc_ecc_ce_addr5_reg",,get_full_name());
        this.mc_ecc_ce_addr5_reg.configure(this, null, "");
        this.mc_ecc_ce_addr5_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr5_reg, `UVM_REG_ADDR_WIDTH'h344,"RW",0);
            this.mc_ecc_ce_addr5_reg_mc_ecc_ce_addr5 = this.mc_ecc_ce_addr5_reg.mc_ecc_ce_addr5;
            this.mc_ecc_ce_addr5 = this.mc_ecc_ce_addr5_reg.mc_ecc_ce_addr5;

            this.mc_ecc_ce_addr5_reg_mc_ecc_ce_addr_vld5 = this.mc_ecc_ce_addr5_reg.mc_ecc_ce_addr_vld5;
            this.mc_ecc_ce_addr_vld5 = this.mc_ecc_ce_addr5_reg.mc_ecc_ce_addr_vld5;

            this.mc_ecc_ce_addr5_reg_mc_ecc_ce_addr_cnt5 = this.mc_ecc_ce_addr5_reg.mc_ecc_ce_addr_cnt5;
            this.mc_ecc_ce_addr_cnt5 = this.mc_ecc_ce_addr5_reg.mc_ecc_ce_addr_cnt5;

        this.mc_ecc_ce_addr6_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr6_reg::type_id::create("mc_ecc_ce_addr6_reg",,get_full_name());
        this.mc_ecc_ce_addr6_reg.configure(this, null, "");
        this.mc_ecc_ce_addr6_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr6_reg, `UVM_REG_ADDR_WIDTH'h348,"RW",0);
            this.mc_ecc_ce_addr6_reg_mc_ecc_ce_addr6 = this.mc_ecc_ce_addr6_reg.mc_ecc_ce_addr6;
            this.mc_ecc_ce_addr6 = this.mc_ecc_ce_addr6_reg.mc_ecc_ce_addr6;

            this.mc_ecc_ce_addr6_reg_mc_ecc_ce_addr_vld6 = this.mc_ecc_ce_addr6_reg.mc_ecc_ce_addr_vld6;
            this.mc_ecc_ce_addr_vld6 = this.mc_ecc_ce_addr6_reg.mc_ecc_ce_addr_vld6;

            this.mc_ecc_ce_addr6_reg_mc_ecc_ce_addr_cnt6 = this.mc_ecc_ce_addr6_reg.mc_ecc_ce_addr_cnt6;
            this.mc_ecc_ce_addr_cnt6 = this.mc_ecc_ce_addr6_reg.mc_ecc_ce_addr_cnt6;

        this.mc_ecc_ce_addr7_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr7_reg::type_id::create("mc_ecc_ce_addr7_reg",,get_full_name());
        this.mc_ecc_ce_addr7_reg.configure(this, null, "");
        this.mc_ecc_ce_addr7_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr7_reg, `UVM_REG_ADDR_WIDTH'h34C,"RW",0);
            this.mc_ecc_ce_addr7_reg_mc_ecc_ce_addr7 = this.mc_ecc_ce_addr7_reg.mc_ecc_ce_addr7;
            this.mc_ecc_ce_addr7 = this.mc_ecc_ce_addr7_reg.mc_ecc_ce_addr7;

            this.mc_ecc_ce_addr7_reg_mc_ecc_ce_addr_vld7 = this.mc_ecc_ce_addr7_reg.mc_ecc_ce_addr_vld7;
            this.mc_ecc_ce_addr_vld7 = this.mc_ecc_ce_addr7_reg.mc_ecc_ce_addr_vld7;

            this.mc_ecc_ce_addr7_reg_mc_ecc_ce_addr_cnt7 = this.mc_ecc_ce_addr7_reg.mc_ecc_ce_addr_cnt7;
            this.mc_ecc_ce_addr_cnt7 = this.mc_ecc_ce_addr7_reg.mc_ecc_ce_addr_cnt7;

        this.mc_ecc_ce_addr8_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr8_reg::type_id::create("mc_ecc_ce_addr8_reg",,get_full_name());
        this.mc_ecc_ce_addr8_reg.configure(this, null, "");
        this.mc_ecc_ce_addr8_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr8_reg, `UVM_REG_ADDR_WIDTH'h350,"RW",0);
            this.mc_ecc_ce_addr8_reg_mc_ecc_ce_addr8 = this.mc_ecc_ce_addr8_reg.mc_ecc_ce_addr8;
            this.mc_ecc_ce_addr8 = this.mc_ecc_ce_addr8_reg.mc_ecc_ce_addr8;

            this.mc_ecc_ce_addr8_reg_mc_ecc_ce_addr_vld8 = this.mc_ecc_ce_addr8_reg.mc_ecc_ce_addr_vld8;
            this.mc_ecc_ce_addr_vld8 = this.mc_ecc_ce_addr8_reg.mc_ecc_ce_addr_vld8;

            this.mc_ecc_ce_addr8_reg_mc_ecc_ce_addr_cnt8 = this.mc_ecc_ce_addr8_reg.mc_ecc_ce_addr_cnt8;
            this.mc_ecc_ce_addr_cnt8 = this.mc_ecc_ce_addr8_reg.mc_ecc_ce_addr_cnt8;

        this.mc_ecc_ce_addr9_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr9_reg::type_id::create("mc_ecc_ce_addr9_reg",,get_full_name());
        this.mc_ecc_ce_addr9_reg.configure(this, null, "");
        this.mc_ecc_ce_addr9_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr9_reg, `UVM_REG_ADDR_WIDTH'h354,"RW",0);
            this.mc_ecc_ce_addr9_reg_mc_ecc_ce_addr9 = this.mc_ecc_ce_addr9_reg.mc_ecc_ce_addr9;
            this.mc_ecc_ce_addr9 = this.mc_ecc_ce_addr9_reg.mc_ecc_ce_addr9;

            this.mc_ecc_ce_addr9_reg_mc_ecc_ce_addr_vld9 = this.mc_ecc_ce_addr9_reg.mc_ecc_ce_addr_vld9;
            this.mc_ecc_ce_addr_vld9 = this.mc_ecc_ce_addr9_reg.mc_ecc_ce_addr_vld9;

            this.mc_ecc_ce_addr9_reg_mc_ecc_ce_addr_cnt9 = this.mc_ecc_ce_addr9_reg.mc_ecc_ce_addr_cnt9;
            this.mc_ecc_ce_addr_cnt9 = this.mc_ecc_ce_addr9_reg.mc_ecc_ce_addr_cnt9;

        this.mc_ecc_ce_addr10_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr10_reg::type_id::create("mc_ecc_ce_addr10_reg",,get_full_name());
        this.mc_ecc_ce_addr10_reg.configure(this, null, "");
        this.mc_ecc_ce_addr10_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr10_reg, `UVM_REG_ADDR_WIDTH'h358,"RW",0);
            this.mc_ecc_ce_addr10_reg_mc_ecc_ce_addr10 = this.mc_ecc_ce_addr10_reg.mc_ecc_ce_addr10;
            this.mc_ecc_ce_addr10 = this.mc_ecc_ce_addr10_reg.mc_ecc_ce_addr10;

            this.mc_ecc_ce_addr10_reg_mc_ecc_ce_addr_vld10 = this.mc_ecc_ce_addr10_reg.mc_ecc_ce_addr_vld10;
            this.mc_ecc_ce_addr_vld10 = this.mc_ecc_ce_addr10_reg.mc_ecc_ce_addr_vld10;

            this.mc_ecc_ce_addr10_reg_mc_ecc_ce_addr_cnt10 = this.mc_ecc_ce_addr10_reg.mc_ecc_ce_addr_cnt10;
            this.mc_ecc_ce_addr_cnt10 = this.mc_ecc_ce_addr10_reg.mc_ecc_ce_addr_cnt10;

        this.mc_ecc_ce_addr11_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr11_reg::type_id::create("mc_ecc_ce_addr11_reg",,get_full_name());
        this.mc_ecc_ce_addr11_reg.configure(this, null, "");
        this.mc_ecc_ce_addr11_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr11_reg, `UVM_REG_ADDR_WIDTH'h35C,"RW",0);
            this.mc_ecc_ce_addr11_reg_mc_ecc_ce_addr11 = this.mc_ecc_ce_addr11_reg.mc_ecc_ce_addr11;
            this.mc_ecc_ce_addr11 = this.mc_ecc_ce_addr11_reg.mc_ecc_ce_addr11;

            this.mc_ecc_ce_addr11_reg_mc_ecc_ce_addr_vld11 = this.mc_ecc_ce_addr11_reg.mc_ecc_ce_addr_vld11;
            this.mc_ecc_ce_addr_vld11 = this.mc_ecc_ce_addr11_reg.mc_ecc_ce_addr_vld11;

            this.mc_ecc_ce_addr11_reg_mc_ecc_ce_addr_cnt11 = this.mc_ecc_ce_addr11_reg.mc_ecc_ce_addr_cnt11;
            this.mc_ecc_ce_addr_cnt11 = this.mc_ecc_ce_addr11_reg.mc_ecc_ce_addr_cnt11;

        this.mc_ecc_ce_addr12_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr12_reg::type_id::create("mc_ecc_ce_addr12_reg",,get_full_name());
        this.mc_ecc_ce_addr12_reg.configure(this, null, "");
        this.mc_ecc_ce_addr12_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr12_reg, `UVM_REG_ADDR_WIDTH'h360,"RW",0);
            this.mc_ecc_ce_addr12_reg_mc_ecc_ce_addr12 = this.mc_ecc_ce_addr12_reg.mc_ecc_ce_addr12;
            this.mc_ecc_ce_addr12 = this.mc_ecc_ce_addr12_reg.mc_ecc_ce_addr12;

            this.mc_ecc_ce_addr12_reg_mc_ecc_ce_addr_vld12 = this.mc_ecc_ce_addr12_reg.mc_ecc_ce_addr_vld12;
            this.mc_ecc_ce_addr_vld12 = this.mc_ecc_ce_addr12_reg.mc_ecc_ce_addr_vld12;

            this.mc_ecc_ce_addr12_reg_mc_ecc_ce_addr_cnt12 = this.mc_ecc_ce_addr12_reg.mc_ecc_ce_addr_cnt12;
            this.mc_ecc_ce_addr_cnt12 = this.mc_ecc_ce_addr12_reg.mc_ecc_ce_addr_cnt12;

        this.mc_ecc_ce_addr13_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr13_reg::type_id::create("mc_ecc_ce_addr13_reg",,get_full_name());
        this.mc_ecc_ce_addr13_reg.configure(this, null, "");
        this.mc_ecc_ce_addr13_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr13_reg, `UVM_REG_ADDR_WIDTH'h364,"RW",0);
            this.mc_ecc_ce_addr13_reg_mc_ecc_ce_addr13 = this.mc_ecc_ce_addr13_reg.mc_ecc_ce_addr13;
            this.mc_ecc_ce_addr13 = this.mc_ecc_ce_addr13_reg.mc_ecc_ce_addr13;

            this.mc_ecc_ce_addr13_reg_mc_ecc_ce_addr_vld13 = this.mc_ecc_ce_addr13_reg.mc_ecc_ce_addr_vld13;
            this.mc_ecc_ce_addr_vld13 = this.mc_ecc_ce_addr13_reg.mc_ecc_ce_addr_vld13;

            this.mc_ecc_ce_addr13_reg_mc_ecc_ce_addr_cnt13 = this.mc_ecc_ce_addr13_reg.mc_ecc_ce_addr_cnt13;
            this.mc_ecc_ce_addr_cnt13 = this.mc_ecc_ce_addr13_reg.mc_ecc_ce_addr_cnt13;

        this.mc_ecc_ce_addr14_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr14_reg::type_id::create("mc_ecc_ce_addr14_reg",,get_full_name());
        this.mc_ecc_ce_addr14_reg.configure(this, null, "");
        this.mc_ecc_ce_addr14_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr14_reg, `UVM_REG_ADDR_WIDTH'h368,"RW",0);
            this.mc_ecc_ce_addr14_reg_mc_ecc_ce_addr14 = this.mc_ecc_ce_addr14_reg.mc_ecc_ce_addr14;
            this.mc_ecc_ce_addr14 = this.mc_ecc_ce_addr14_reg.mc_ecc_ce_addr14;

            this.mc_ecc_ce_addr14_reg_mc_ecc_ce_addr_vld14 = this.mc_ecc_ce_addr14_reg.mc_ecc_ce_addr_vld14;
            this.mc_ecc_ce_addr_vld14 = this.mc_ecc_ce_addr14_reg.mc_ecc_ce_addr_vld14;

            this.mc_ecc_ce_addr14_reg_mc_ecc_ce_addr_cnt14 = this.mc_ecc_ce_addr14_reg.mc_ecc_ce_addr_cnt14;
            this.mc_ecc_ce_addr_cnt14 = this.mc_ecc_ce_addr14_reg.mc_ecc_ce_addr_cnt14;

        this.mc_ecc_ce_addr15_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_ce_addr15_reg::type_id::create("mc_ecc_ce_addr15_reg",,get_full_name());
        this.mc_ecc_ce_addr15_reg.configure(this, null, "");
        this.mc_ecc_ce_addr15_reg.build();
        this.default_map.add_reg(this.mc_ecc_ce_addr15_reg, `UVM_REG_ADDR_WIDTH'h36C,"RW",0);
            this.mc_ecc_ce_addr15_reg_mc_ecc_ce_addr15 = this.mc_ecc_ce_addr15_reg.mc_ecc_ce_addr15;
            this.mc_ecc_ce_addr15 = this.mc_ecc_ce_addr15_reg.mc_ecc_ce_addr15;

            this.mc_ecc_ce_addr15_reg_mc_ecc_ce_addr_vld15 = this.mc_ecc_ce_addr15_reg.mc_ecc_ce_addr_vld15;
            this.mc_ecc_ce_addr_vld15 = this.mc_ecc_ce_addr15_reg.mc_ecc_ce_addr_vld15;

            this.mc_ecc_ce_addr15_reg_mc_ecc_ce_addr_cnt15 = this.mc_ecc_ce_addr15_reg.mc_ecc_ce_addr_cnt15;
            this.mc_ecc_ce_addr_cnt15 = this.mc_ecc_ce_addr15_reg.mc_ecc_ce_addr_cnt15;

        this.mc_ecc_uce_ctrl_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_ctrl_reg::type_id::create("mc_ecc_uce_ctrl_reg",,get_full_name());
        this.mc_ecc_uce_ctrl_reg.configure(this, null, "");
        this.mc_ecc_uce_ctrl_reg.build();
        this.default_map.add_reg(this.mc_ecc_uce_ctrl_reg, `UVM_REG_ADDR_WIDTH'h370,"RW",0);
            this.mc_ecc_uce_ctrl_reg_mc_ecc_uce_int_clr = this.mc_ecc_uce_ctrl_reg.mc_ecc_uce_int_clr;
            this.mc_ecc_uce_int_clr = this.mc_ecc_uce_ctrl_reg.mc_ecc_uce_int_clr;

            this.mc_ecc_uce_ctrl_reg_mc_ecc_uce_int = this.mc_ecc_uce_ctrl_reg.mc_ecc_uce_int;
            this.mc_ecc_uce_int = this.mc_ecc_uce_ctrl_reg.mc_ecc_uce_int;

            this.mc_ecc_uce_ctrl_reg_mc_ecc_uce_cnt = this.mc_ecc_uce_ctrl_reg.mc_ecc_uce_cnt;
            this.mc_ecc_uce_cnt = this.mc_ecc_uce_ctrl_reg.mc_ecc_uce_cnt;

            this.mc_ecc_uce_ctrl_reg_mc_ecc_uce_int_mask = this.mc_ecc_uce_ctrl_reg.mc_ecc_uce_int_mask;
            this.mc_ecc_uce_int_mask = this.mc_ecc_uce_ctrl_reg.mc_ecc_uce_int_mask;

        this.mc_ecc_uce_addr0_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr0_reg::type_id::create("mc_ecc_uce_addr0_reg",,get_full_name());
        this.mc_ecc_uce_addr0_reg.configure(this, null, "");
        this.mc_ecc_uce_addr0_reg.build();
        this.default_map.add_reg(this.mc_ecc_uce_addr0_reg, `UVM_REG_ADDR_WIDTH'h374,"RW",0);
            this.mc_ecc_uce_addr0_reg_mc_ecc_uce_addr0 = this.mc_ecc_uce_addr0_reg.mc_ecc_uce_addr0;
            this.mc_ecc_uce_addr0 = this.mc_ecc_uce_addr0_reg.mc_ecc_uce_addr0;

            this.mc_ecc_uce_addr0_reg_mc_ecc_uce_addr_vld0 = this.mc_ecc_uce_addr0_reg.mc_ecc_uce_addr_vld0;
            this.mc_ecc_uce_addr_vld0 = this.mc_ecc_uce_addr0_reg.mc_ecc_uce_addr_vld0;

        this.mc_ecc_uce_addr1_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr1_reg::type_id::create("mc_ecc_uce_addr1_reg",,get_full_name());
        this.mc_ecc_uce_addr1_reg.configure(this, null, "");
        this.mc_ecc_uce_addr1_reg.build();
        this.default_map.add_reg(this.mc_ecc_uce_addr1_reg, `UVM_REG_ADDR_WIDTH'h378,"RW",0);
            this.mc_ecc_uce_addr1_reg_mc_ecc_uce_addr1 = this.mc_ecc_uce_addr1_reg.mc_ecc_uce_addr1;
            this.mc_ecc_uce_addr1 = this.mc_ecc_uce_addr1_reg.mc_ecc_uce_addr1;

            this.mc_ecc_uce_addr1_reg_mc_ecc_uce_addr_vld1 = this.mc_ecc_uce_addr1_reg.mc_ecc_uce_addr_vld1;
            this.mc_ecc_uce_addr_vld1 = this.mc_ecc_uce_addr1_reg.mc_ecc_uce_addr_vld1;

        this.mc_ecc_uce_addr2_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr2_reg::type_id::create("mc_ecc_uce_addr2_reg",,get_full_name());
        this.mc_ecc_uce_addr2_reg.configure(this, null, "");
        this.mc_ecc_uce_addr2_reg.build();
        this.default_map.add_reg(this.mc_ecc_uce_addr2_reg, `UVM_REG_ADDR_WIDTH'h37C,"RW",0);
            this.mc_ecc_uce_addr2_reg_mc_ecc_uce_addr2 = this.mc_ecc_uce_addr2_reg.mc_ecc_uce_addr2;
            this.mc_ecc_uce_addr2 = this.mc_ecc_uce_addr2_reg.mc_ecc_uce_addr2;

            this.mc_ecc_uce_addr2_reg_mc_ecc_uce_addr_vld2 = this.mc_ecc_uce_addr2_reg.mc_ecc_uce_addr_vld2;
            this.mc_ecc_uce_addr_vld2 = this.mc_ecc_uce_addr2_reg.mc_ecc_uce_addr_vld2;

        this.mc_ecc_uce_addr3_reg = ral_reg_mc_1short2_top_aux_top_mc_ecc_uce_addr3_reg::type_id::create("mc_ecc_uce_addr3_reg",,get_full_name());
        this.mc_ecc_uce_addr3_reg.configure(this, null, "");
        this.mc_ecc_uce_addr3_reg.build();
        this.default_map.add_reg(this.mc_ecc_uce_addr3_reg, `UVM_REG_ADDR_WIDTH'h380,"RW",0);
            this.mc_ecc_uce_addr3_reg_mc_ecc_uce_addr3 = this.mc_ecc_uce_addr3_reg.mc_ecc_uce_addr3;
            this.mc_ecc_uce_addr3 = this.mc_ecc_uce_addr3_reg.mc_ecc_uce_addr3;

            this.mc_ecc_uce_addr3_reg_mc_ecc_uce_addr_vld3 = this.mc_ecc_uce_addr3_reg.mc_ecc_uce_addr_vld3;
            this.mc_ecc_uce_addr_vld3 = this.mc_ecc_uce_addr3_reg.mc_ecc_uce_addr_vld3;

        this.mc_page_status_reg = ral_reg_mc_1short2_top_aux_top_mc_page_status_reg::type_id::create("mc_page_status_reg",,get_full_name());
        this.mc_page_status_reg.configure(this, null, "");
        this.mc_page_status_reg.build();
        this.default_map.add_reg(this.mc_page_status_reg, `UVM_REG_ADDR_WIDTH'h384,"RW",0);
            this.mc_page_status_reg_mc_page_status = this.mc_page_status_reg.mc_page_status;
            this.mc_page_status = this.mc_page_status_reg.mc_page_status;

        this.hang_timeout_status_reg = ral_reg_mc_1short2_top_aux_top_hang_timeout_status_reg::type_id::create("hang_timeout_status_reg",,get_full_name());
        this.hang_timeout_status_reg.configure(this, null, "");
        this.hang_timeout_status_reg.build();
        this.default_map.add_reg(this.hang_timeout_status_reg, `UVM_REG_ADDR_WIDTH'h388,"RW",0);
            this.hang_timeout_status_reg_hang_timeout_status = this.hang_timeout_status_reg.hang_timeout_status;
            this.hang_timeout_status = this.hang_timeout_status_reg.hang_timeout_status;

        this.hang_timeout_mask_reg = ral_reg_mc_1short2_top_aux_top_hang_timeout_mask_reg::type_id::create("hang_timeout_mask_reg",,get_full_name());
        this.hang_timeout_mask_reg.configure(this, null, "");
        this.hang_timeout_mask_reg.build();
        this.default_map.add_reg(this.hang_timeout_mask_reg, `UVM_REG_ADDR_WIDTH'h38C,"RW",0);
            this.hang_timeout_mask_reg_hang_timeout_mask = this.hang_timeout_mask_reg.hang_timeout_mask;
            this.hang_timeout_mask = this.hang_timeout_mask_reg.hang_timeout_mask;

        this.hang_timeout_clr_reg = ral_reg_mc_1short2_top_aux_top_hang_timeout_clr_reg::type_id::create("hang_timeout_clr_reg",,get_full_name());
        this.hang_timeout_clr_reg.configure(this, null, "");
        this.hang_timeout_clr_reg.build();
        this.default_map.add_reg(this.hang_timeout_clr_reg, `UVM_REG_ADDR_WIDTH'h390,"RW",0);
            this.hang_timeout_clr_reg_hang_timeout_clr = this.hang_timeout_clr_reg.hang_timeout_clr;
            this.hang_timeout_clr = this.hang_timeout_clr_reg.hang_timeout_clr;

        this.hang_timeout_en_reg = ral_reg_mc_1short2_top_aux_top_hang_timeout_en_reg::type_id::create("hang_timeout_en_reg",,get_full_name());
        this.hang_timeout_en_reg.configure(this, null, "");
        this.hang_timeout_en_reg.build();
        this.default_map.add_reg(this.hang_timeout_en_reg, `UVM_REG_ADDR_WIDTH'h394,"RW",0);
            this.hang_timeout_en_reg_hang_timeout_en = this.hang_timeout_en_reg.hang_timeout_en;
            this.hang_timeout_en = this.hang_timeout_en_reg.hang_timeout_en;

        this.bist_clk_cnt_reg = ral_reg_mc_1short2_top_aux_top_bist_clk_cnt_reg::type_id::create("bist_clk_cnt_reg",,get_full_name());
        this.bist_clk_cnt_reg.configure(this, null, "");
        this.bist_clk_cnt_reg.build();
        this.default_map.add_reg(this.bist_clk_cnt_reg, `UVM_REG_ADDR_WIDTH'h398,"RW",0);
            this.bist_clk_cnt_reg_bist_clk_cnt = this.bist_clk_cnt_reg.bist_clk_cnt;
            this.bist_clk_cnt = this.bist_clk_cnt_reg.bist_clk_cnt;

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
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_rdata_invert_sel_o",10,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_rdrdy_n_en_o",11,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_rf_en_o",12,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_rf_burst_split_en_o",13,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_fake_bresp_en_o",14,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_ecc_en_o",15,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc_all_bank_act_en_o",16,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc2phy_dram0_mask_o",17,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc2phy_dram1_mask_o",18,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc2phy_dram2_mask_o",19,1);
            this.mc_work_ctrl_reg.add_hdl_path_slice("mc2phy_dram3_mask_o",20,1);
            this.phy_timing_cfg0_reg.add_hdl_path_slice("bank_radd_set_time_o",0,8);
            this.phy_timing_cfg0_reg.add_hdl_path_slice("cadd_set_time_o",8,4);
            this.phy_timing_cfg0_reg.add_hdl_path_slice("r_cas_set_time_o",12,8);
            this.phy_timing_cfg0_reg.add_hdl_path_slice("w_cas_set_time_o",20,8);
            this.mc_rf_period_cfg1_reg.add_hdl_path_slice("mc_rf_period_1_o",0,32);
            this.mc_rf_start_cfg1_reg.add_hdl_path_slice("mc_rf_start_1_o",0,32);
            this.mc_rf_period_cfg2_reg.add_hdl_path_slice("mc_rf_period_2_o",0,32);
            this.mc_rf_start_cfg2_reg.add_hdl_path_slice("mc_rf_start_2_o",0,32);
            this.mc_vmc_wl_num0_1_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num0_bank0_o",0,13);
            this.mc_vmc_wl_num0_1_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num1_bank0_o",13,13);
            this.mc_vmc_wl_num2_3_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num2_bank0_o",0,13);
            this.mc_vmc_wl_num2_3_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num3_bank0_o",13,13);
            this.mc_vmc_wl_num4_5_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num4_bank0_o",0,13);
            this.mc_vmc_wl_num4_5_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num5_bank0_o",13,13);
            this.mc_vmc_wl_num6_7_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num6_bank0_o",0,13);
            this.mc_vmc_wl_num6_7_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num7_bank0_o",13,13);
            this.mc_vmc_wl_num8_9_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num8_bank0_o",0,13);
            this.mc_vmc_wl_num8_9_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num9_bank0_o",13,13);
            this.mc_vmc_wl_num10_11_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num10_bank0_o",0,13);
            this.mc_vmc_wl_num10_11_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num11_bank0_o",13,13);
            this.mc_vmc_wl_num12_13_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num12_bank0_o",0,13);
            this.mc_vmc_wl_num12_13_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num13_bank0_o",13,13);
            this.mc_vmc_wl_num14_15_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num14_bank0_o",0,13);
            this.mc_vmc_wl_num14_15_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num15_bank0_o",13,13);
            this.mc_vmc_wl_num16_17_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num16_bank0_o",0,13);
            this.mc_vmc_wl_num16_17_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num17_bank0_o",13,13);
            this.mc_vmc_wl_num18_19_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num18_bank0_o",0,13);
            this.mc_vmc_wl_num18_19_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num19_bank0_o",13,13);
            this.mc_vmc_wl_num20_21_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num20_bank0_o",0,13);
            this.mc_vmc_wl_num20_21_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num21_bank0_o",13,13);
            this.mc_vmc_wl_num22_23_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num22_bank0_o",0,13);
            this.mc_vmc_wl_num22_23_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num23_bank0_o",13,13);
            this.mc_vmc_wl_num24_25_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num24_bank0_o",0,13);
            this.mc_vmc_wl_num24_25_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num25_bank0_o",13,13);
            this.mc_vmc_wl_num26_27_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num26_bank0_o",0,13);
            this.mc_vmc_wl_num26_27_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num27_bank0_o",13,13);
            this.mc_vmc_wl_num28_29_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num28_bank0_o",0,13);
            this.mc_vmc_wl_num28_29_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num29_bank0_o",13,13);
            this.mc_vmc_wl_num30_31_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num30_bank0_o",0,13);
            this.mc_vmc_wl_num30_31_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num31_bank0_o",13,13);
            this.mc_vmc_wl_num32_33_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num32_bank0_o",0,13);
            this.mc_vmc_wl_num32_33_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num33_bank0_o",13,13);
            this.mc_vmc_wl_num34_35_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num34_bank0_o",0,13);
            this.mc_vmc_wl_num34_35_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num35_bank0_o",13,13);
            this.mc_vmc_wl_num36_37_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num36_bank0_o",0,13);
            this.mc_vmc_wl_num36_37_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num37_bank0_o",13,13);
            this.mc_vmc_wl_num38_39_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num38_bank0_o",0,13);
            this.mc_vmc_wl_num38_39_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num39_bank0_o",13,13);
            this.mc_vmc_wl_num40_41_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num40_bank0_o",0,13);
            this.mc_vmc_wl_num40_41_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num41_bank0_o",13,13);
            this.mc_vmc_wl_num42_43_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num42_bank0_o",0,13);
            this.mc_vmc_wl_num42_43_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num43_bank0_o",13,13);
            this.mc_vmc_wl_num44_45_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num44_bank0_o",0,13);
            this.mc_vmc_wl_num44_45_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num45_bank0_o",13,13);
            this.mc_vmc_wl_num46_47_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num46_bank0_o",0,13);
            this.mc_vmc_wl_num46_47_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num47_bank0_o",13,13);
            this.mc_vmc_wl_num48_49_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num48_bank0_o",0,13);
            this.mc_vmc_wl_num48_49_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num49_bank0_o",13,13);
            this.mc_vmc_wl_num50_51_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num50_bank0_o",0,13);
            this.mc_vmc_wl_num50_51_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num51_bank0_o",13,13);
            this.mc_vmc_wl_num52_53_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num52_bank0_o",0,13);
            this.mc_vmc_wl_num52_53_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num53_bank0_o",13,13);
            this.mc_vmc_wl_num54_55_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num54_bank0_o",0,13);
            this.mc_vmc_wl_num54_55_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num55_bank0_o",13,13);
            this.mc_vmc_wl_num56_57_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num56_bank0_o",0,13);
            this.mc_vmc_wl_num56_57_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num57_bank0_o",13,13);
            this.mc_vmc_wl_num58_59_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num58_bank0_o",0,13);
            this.mc_vmc_wl_num58_59_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num59_bank0_o",13,13);
            this.mc_vmc_wl_num60_61_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num60_bank0_o",0,13);
            this.mc_vmc_wl_num60_61_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num61_bank0_o",13,13);
            this.mc_vmc_wl_num62_63_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num62_bank0_o",0,13);
            this.mc_vmc_wl_num62_63_bank0_reg.add_hdl_path_slice("mc_vmc_wl_num63_bank0_o",13,13);
            this.mc_vmc_bl_num0_part0_1_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num0_part0_bank0_o",0,8);
            this.mc_vmc_bl_num0_part0_1_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num1_part0_bank0_o",8,8);
            this.mc_vmc_bl_num0_part0_1_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num0_part1_bank0_o",16,8);
            this.mc_vmc_bl_num0_part0_1_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num1_part1_bank0_o",24,8);
            this.mc_vmc_bl_num0_part2_3_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num0_part2_bank0_o",0,8);
            this.mc_vmc_bl_num0_part2_3_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num1_part2_bank0_o",8,8);
            this.mc_vmc_bl_num0_part2_3_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num0_part3_bank0_o",16,8);
            this.mc_vmc_bl_num0_part2_3_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num1_part3_bank0_o",24,8);
            this.mc_vmc_bl_num0_part4_5_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num0_part4_bank0_o",0,8);
            this.mc_vmc_bl_num0_part4_5_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num1_part4_bank0_o",8,8);
            this.mc_vmc_bl_num0_part4_5_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num0_part5_bank0_o",16,8);
            this.mc_vmc_bl_num0_part4_5_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num1_part5_bank0_o",24,8);
            this.mc_vmc_bl_num0_part6_7_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num0_part6_bank0_o",0,8);
            this.mc_vmc_bl_num0_part6_7_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num1_part6_bank0_o",8,8);
            this.mc_vmc_bl_num0_part6_7_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num0_part7_bank0_o",16,8);
            this.mc_vmc_bl_num0_part6_7_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num1_part7_bank0_o",24,8);
            this.mc_vmc_bl_num0_part8_9_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num0_part8_bank0_o",0,8);
            this.mc_vmc_bl_num0_part8_9_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num1_part8_bank0_o",8,8);
            this.mc_vmc_bl_num0_part8_9_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num0_part9_bank0_o",16,8);
            this.mc_vmc_bl_num0_part8_9_bank0_reg.add_hdl_path_slice("mc_vmc_bl_num1_part9_bank0_o",24,8);
            this.err_wl0_1_bank0_reg.add_hdl_path_slice("err_wl0_bank0_i",0,13);
            this.err_wl0_1_bank0_reg.add_hdl_path_slice("err_wl1_bank0_i",13,13);
            this.err_wl2_3_bank0_reg.add_hdl_path_slice("err_wl2_bank0_i",0,13);
            this.err_wl2_3_bank0_reg.add_hdl_path_slice("err_wl3_bank0_i",13,13);
            this.err_wl4_5_bank0_reg.add_hdl_path_slice("err_wl4_bank0_i",0,13);
            this.err_wl4_5_bank0_reg.add_hdl_path_slice("err_wl5_bank0_i",13,13);
            this.err_wl6_7_bank0_reg.add_hdl_path_slice("err_wl6_bank0_i",0,13);
            this.err_wl6_7_bank0_reg.add_hdl_path_slice("err_wl7_bank0_i",13,13);
            this.err_wl8_9_bank0_reg.add_hdl_path_slice("err_wl8_bank0_i",0,13);
            this.err_wl8_9_bank0_reg.add_hdl_path_slice("err_wl9_bank0_i",13,13);
            this.err_wl10_11_bank0_reg.add_hdl_path_slice("err_wl10_bank0_i",0,13);
            this.err_wl10_11_bank0_reg.add_hdl_path_slice("err_wl11_bank0_i",13,13);
            this.err_wl12_13_bank0_reg.add_hdl_path_slice("err_wl12_bank0_i",0,13);
            this.err_wl12_13_bank0_reg.add_hdl_path_slice("err_wl13_bank0_i",13,13);
            this.err_wl14_15_bank0_reg.add_hdl_path_slice("err_wl14_bank0_i",0,13);
            this.err_wl14_15_bank0_reg.add_hdl_path_slice("err_wl15_bank0_i",13,13);
            this.err_wl16_17_bank0_reg.add_hdl_path_slice("err_wl16_bank0_i",0,13);
            this.err_wl16_17_bank0_reg.add_hdl_path_slice("err_wl17_bank0_i",13,13);
            this.err_wl18_19_bank0_reg.add_hdl_path_slice("err_wl18_bank0_i",0,13);
            this.err_wl18_19_bank0_reg.add_hdl_path_slice("err_wl19_bank0_i",13,13);
            this.err_wl20_21_bank0_reg.add_hdl_path_slice("err_wl20_bank0_i",0,13);
            this.err_wl20_21_bank0_reg.add_hdl_path_slice("err_wl21_bank0_i",13,13);
            this.err_wl22_23_bank0_reg.add_hdl_path_slice("err_wl22_bank0_i",0,13);
            this.err_wl22_23_bank0_reg.add_hdl_path_slice("err_wl23_bank0_i",13,13);
            this.err_wl24_25_bank0_reg.add_hdl_path_slice("err_wl24_bank0_i",0,13);
            this.err_wl24_25_bank0_reg.add_hdl_path_slice("err_wl25_bank0_i",13,13);
            this.err_wl26_27_bank0_reg.add_hdl_path_slice("err_wl26_bank0_i",0,13);
            this.err_wl26_27_bank0_reg.add_hdl_path_slice("err_wl27_bank0_i",13,13);
            this.err_wl28_29_bank0_reg.add_hdl_path_slice("err_wl28_bank0_i",0,13);
            this.err_wl28_29_bank0_reg.add_hdl_path_slice("err_wl29_bank0_i",13,13);
            this.err_wl30_31_bank0_reg.add_hdl_path_slice("err_wl30_bank0_i",0,13);
            this.err_wl30_31_bank0_reg.add_hdl_path_slice("err_wl31_bank0_i",13,13);
            this.err_wl32_33_bank0_reg.add_hdl_path_slice("err_wl32_bank0_i",0,13);
            this.err_wl32_33_bank0_reg.add_hdl_path_slice("err_wl33_bank0_i",13,13);
            this.err_wl34_35_bank0_reg.add_hdl_path_slice("err_wl34_bank0_i",0,13);
            this.err_wl34_35_bank0_reg.add_hdl_path_slice("err_wl35_bank0_i",13,13);
            this.err_wl36_37_bank0_reg.add_hdl_path_slice("err_wl36_bank0_i",0,13);
            this.err_wl36_37_bank0_reg.add_hdl_path_slice("err_wl37_bank0_i",13,13);
            this.err_wl38_39_bank0_reg.add_hdl_path_slice("err_wl38_bank0_i",0,13);
            this.err_wl38_39_bank0_reg.add_hdl_path_slice("err_wl39_bank0_i",13,13);
            this.err_wl40_41_bank0_reg.add_hdl_path_slice("err_wl40_bank0_i",0,13);
            this.err_wl40_41_bank0_reg.add_hdl_path_slice("err_wl41_bank0_i",13,13);
            this.err_wl42_43_bank0_reg.add_hdl_path_slice("err_wl42_bank0_i",0,13);
            this.err_wl42_43_bank0_reg.add_hdl_path_slice("err_wl43_bank0_i",13,13);
            this.err_wl44_45_bank0_reg.add_hdl_path_slice("err_wl44_bank0_i",0,13);
            this.err_wl44_45_bank0_reg.add_hdl_path_slice("err_wl45_bank0_i",13,13);
            this.err_wl46_47_bank0_reg.add_hdl_path_slice("err_wl46_bank0_i",0,13);
            this.err_wl46_47_bank0_reg.add_hdl_path_slice("err_wl47_bank0_i",13,13);
            this.err_wl48_49_bank0_reg.add_hdl_path_slice("err_wl48_bank0_i",0,13);
            this.err_wl48_49_bank0_reg.add_hdl_path_slice("err_wl49_bank0_i",13,13);
            this.err_wl50_51_bank0_reg.add_hdl_path_slice("err_wl50_bank0_i",0,13);
            this.err_wl50_51_bank0_reg.add_hdl_path_slice("err_wl51_bank0_i",13,13);
            this.err_wl52_53_bank0_reg.add_hdl_path_slice("err_wl52_bank0_i",0,13);
            this.err_wl52_53_bank0_reg.add_hdl_path_slice("err_wl53_bank0_i",13,13);
            this.err_wl54_55_bank0_reg.add_hdl_path_slice("err_wl54_bank0_i",0,13);
            this.err_wl54_55_bank0_reg.add_hdl_path_slice("err_wl55_bank0_i",13,13);
            this.err_wl56_57_bank0_reg.add_hdl_path_slice("err_wl56_bank0_i",0,13);
            this.err_wl56_57_bank0_reg.add_hdl_path_slice("err_wl57_bank0_i",13,13);
            this.err_wl58_59_bank0_reg.add_hdl_path_slice("err_wl58_bank0_i",0,13);
            this.err_wl58_59_bank0_reg.add_hdl_path_slice("err_wl59_bank0_i",13,13);
            this.err_wl60_61_bank0_reg.add_hdl_path_slice("err_wl60_bank0_i",0,13);
            this.err_wl60_61_bank0_reg.add_hdl_path_slice("err_wl61_bank0_i",13,13);
            this.err_wl62_63_bank0_reg.add_hdl_path_slice("err_wl62_bank0_i",0,13);
            this.err_wl62_63_bank0_reg.add_hdl_path_slice("err_wl63_bank0_i",13,13);
            this.err_csl_part0_1_bank0_reg.add_hdl_path_slice("err_csl0_part0_bank0_i",0,8);
            this.err_csl_part0_1_bank0_reg.add_hdl_path_slice("err_csl1_part0_bank0_i",8,8);
            this.err_csl_part0_1_bank0_reg.add_hdl_path_slice("err_csl0_part1_bank0_i",16,8);
            this.err_csl_part0_1_bank0_reg.add_hdl_path_slice("err_csl1_part1_bank0_i",24,8);
            this.err_csl_part2_3_bank0_reg.add_hdl_path_slice("err_csl0_part2_bank0_i",0,8);
            this.err_csl_part2_3_bank0_reg.add_hdl_path_slice("err_csl1_part2_bank0_i",8,8);
            this.err_csl_part2_3_bank0_reg.add_hdl_path_slice("err_csl0_part3_bank0_i",16,8);
            this.err_csl_part2_3_bank0_reg.add_hdl_path_slice("err_csl1_part3_bank0_i",24,8);
            this.err_csl_part4_5_bank0_reg.add_hdl_path_slice("err_csl0_part4_bank0_i",0,8);
            this.err_csl_part4_5_bank0_reg.add_hdl_path_slice("err_csl1_part4_bank0_i",8,8);
            this.err_csl_part4_5_bank0_reg.add_hdl_path_slice("err_csl0_part5_bank0_i",16,8);
            this.err_csl_part4_5_bank0_reg.add_hdl_path_slice("err_csl1_part5_bank0_i",24,8);
            this.err_csl_part6_7_bank0_reg.add_hdl_path_slice("err_csl0_part6_bank0_i",0,8);
            this.err_csl_part6_7_bank0_reg.add_hdl_path_slice("err_csl1_part6_bank0_i",8,8);
            this.err_csl_part6_7_bank0_reg.add_hdl_path_slice("err_csl0_part7_bank0_i",16,8);
            this.err_csl_part6_7_bank0_reg.add_hdl_path_slice("err_csl1_part7_bank0_i",24,8);
            this.err_csl_part8_9_bank0_reg.add_hdl_path_slice("err_csl0_part8_bank0_i",0,8);
            this.err_csl_part8_9_bank0_reg.add_hdl_path_slice("err_csl1_part8_bank0_i",8,8);
            this.err_csl_part8_9_bank0_reg.add_hdl_path_slice("err_csl0_part9_bank0_i",16,8);
            this.err_csl_part8_9_bank0_reg.add_hdl_path_slice("err_csl1_part9_bank0_i",24,8);
            this.mc_vmc_wl_num0_1_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num0_bank1_o",0,13);
            this.mc_vmc_wl_num0_1_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num1_bank1_o",13,13);
            this.mc_vmc_wl_num2_3_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num2_bank1_o",0,13);
            this.mc_vmc_wl_num2_3_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num3_bank1_o",13,13);
            this.mc_vmc_wl_num4_5_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num4_bank1_o",0,13);
            this.mc_vmc_wl_num4_5_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num5_bank1_o",13,13);
            this.mc_vmc_wl_num6_7_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num6_bank1_o",0,13);
            this.mc_vmc_wl_num6_7_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num7_bank1_o",13,13);
            this.mc_vmc_wl_num8_9_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num8_bank1_o",0,13);
            this.mc_vmc_wl_num8_9_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num9_bank1_o",13,13);
            this.mc_vmc_wl_num10_11_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num10_bank1_o",0,13);
            this.mc_vmc_wl_num10_11_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num11_bank1_o",13,13);
            this.mc_vmc_wl_num12_13_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num12_bank1_o",0,13);
            this.mc_vmc_wl_num12_13_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num13_bank1_o",13,13);
            this.mc_vmc_wl_num14_15_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num14_bank1_o",0,13);
            this.mc_vmc_wl_num14_15_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num15_bank1_o",13,13);
            this.mc_vmc_wl_num16_17_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num16_bank1_o",0,13);
            this.mc_vmc_wl_num16_17_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num17_bank1_o",13,13);
            this.mc_vmc_wl_num18_19_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num18_bank1_o",0,13);
            this.mc_vmc_wl_num18_19_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num19_bank1_o",13,13);
            this.mc_vmc_wl_num20_21_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num20_bank1_o",0,13);
            this.mc_vmc_wl_num20_21_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num21_bank1_o",13,13);
            this.mc_vmc_wl_num22_23_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num22_bank1_o",0,13);
            this.mc_vmc_wl_num22_23_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num23_bank1_o",13,13);
            this.mc_vmc_wl_num24_25_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num24_bank1_o",0,13);
            this.mc_vmc_wl_num24_25_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num25_bank1_o",13,13);
            this.mc_vmc_wl_num26_27_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num26_bank1_o",0,13);
            this.mc_vmc_wl_num26_27_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num27_bank1_o",13,13);
            this.mc_vmc_wl_num28_29_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num28_bank1_o",0,13);
            this.mc_vmc_wl_num28_29_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num29_bank1_o",13,13);
            this.mc_vmc_wl_num30_31_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num30_bank1_o",0,13);
            this.mc_vmc_wl_num30_31_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num31_bank1_o",13,13);
            this.mc_vmc_wl_num32_33_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num32_bank1_o",0,13);
            this.mc_vmc_wl_num32_33_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num33_bank1_o",13,13);
            this.mc_vmc_wl_num34_35_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num34_bank1_o",0,13);
            this.mc_vmc_wl_num34_35_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num35_bank1_o",13,13);
            this.mc_vmc_wl_num36_37_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num36_bank1_o",0,13);
            this.mc_vmc_wl_num36_37_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num37_bank1_o",13,13);
            this.mc_vmc_wl_num38_39_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num38_bank1_o",0,13);
            this.mc_vmc_wl_num38_39_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num39_bank1_o",13,13);
            this.mc_vmc_wl_num40_41_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num40_bank1_o",0,13);
            this.mc_vmc_wl_num40_41_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num41_bank1_o",13,13);
            this.mc_vmc_wl_num42_43_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num42_bank1_o",0,13);
            this.mc_vmc_wl_num42_43_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num43_bank1_o",13,13);
            this.mc_vmc_wl_num44_45_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num44_bank1_o",0,13);
            this.mc_vmc_wl_num44_45_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num45_bank1_o",13,13);
            this.mc_vmc_wl_num46_47_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num46_bank1_o",0,13);
            this.mc_vmc_wl_num46_47_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num47_bank1_o",13,13);
            this.mc_vmc_wl_num48_49_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num48_bank1_o",0,13);
            this.mc_vmc_wl_num48_49_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num49_bank1_o",13,13);
            this.mc_vmc_wl_num50_51_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num50_bank1_o",0,13);
            this.mc_vmc_wl_num50_51_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num51_bank1_o",13,13);
            this.mc_vmc_wl_num52_53_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num52_bank1_o",0,13);
            this.mc_vmc_wl_num52_53_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num53_bank1_o",13,13);
            this.mc_vmc_wl_num54_55_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num54_bank1_o",0,13);
            this.mc_vmc_wl_num54_55_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num55_bank1_o",13,13);
            this.mc_vmc_wl_num56_57_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num56_bank1_o",0,13);
            this.mc_vmc_wl_num56_57_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num57_bank1_o",13,13);
            this.mc_vmc_wl_num58_59_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num58_bank1_o",0,13);
            this.mc_vmc_wl_num58_59_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num59_bank1_o",13,13);
            this.mc_vmc_wl_num60_61_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num60_bank1_o",0,13);
            this.mc_vmc_wl_num60_61_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num61_bank1_o",13,13);
            this.mc_vmc_wl_num62_63_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num62_bank1_o",0,13);
            this.mc_vmc_wl_num62_63_bank1_reg.add_hdl_path_slice("mc_vmc_wl_num63_bank1_o",13,13);
            this.mc_vmc_bl_num0_part0_1_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num0_part0_bank1_o",0,8);
            this.mc_vmc_bl_num0_part0_1_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num1_part0_bank1_o",8,8);
            this.mc_vmc_bl_num0_part0_1_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num0_part1_bank1_o",16,8);
            this.mc_vmc_bl_num0_part0_1_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num1_part1_bank1_o",24,8);
            this.mc_vmc_bl_num0_part2_3_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num0_part2_bank1_o",0,8);
            this.mc_vmc_bl_num0_part2_3_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num1_part2_bank1_o",8,8);
            this.mc_vmc_bl_num0_part2_3_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num0_part3_bank1_o",16,8);
            this.mc_vmc_bl_num0_part2_3_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num1_part3_bank1_o",24,8);
            this.mc_vmc_bl_num0_part4_5_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num0_part4_bank1_o",0,8);
            this.mc_vmc_bl_num0_part4_5_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num1_part4_bank1_o",8,8);
            this.mc_vmc_bl_num0_part4_5_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num0_part5_bank1_o",16,8);
            this.mc_vmc_bl_num0_part4_5_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num1_part5_bank1_o",24,8);
            this.mc_vmc_bl_num0_part6_7_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num0_part6_bank1_o",0,8);
            this.mc_vmc_bl_num0_part6_7_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num1_part6_bank1_o",8,8);
            this.mc_vmc_bl_num0_part6_7_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num0_part7_bank1_o",16,8);
            this.mc_vmc_bl_num0_part6_7_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num1_part7_bank1_o",24,8);
            this.mc_vmc_bl_num0_part8_9_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num0_part8_bank1_o",0,8);
            this.mc_vmc_bl_num0_part8_9_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num1_part8_bank1_o",8,8);
            this.mc_vmc_bl_num0_part8_9_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num0_part9_bank1_o",16,8);
            this.mc_vmc_bl_num0_part8_9_bank1_reg.add_hdl_path_slice("mc_vmc_bl_num1_part9_bank1_o",24,8);
            this.err_wl0_1_bank1_reg.add_hdl_path_slice("err_wl0_bank1_i",0,13);
            this.err_wl0_1_bank1_reg.add_hdl_path_slice("err_wl1_bank1_i",13,13);
            this.err_wl2_3_bank1_reg.add_hdl_path_slice("err_wl2_bank1_i",0,13);
            this.err_wl2_3_bank1_reg.add_hdl_path_slice("err_wl3_bank1_i",13,13);
            this.err_wl4_5_bank1_reg.add_hdl_path_slice("err_wl4_bank1_i",0,13);
            this.err_wl4_5_bank1_reg.add_hdl_path_slice("err_wl5_bank1_i",13,13);
            this.err_wl6_7_bank1_reg.add_hdl_path_slice("err_wl6_bank1_i",0,13);
            this.err_wl6_7_bank1_reg.add_hdl_path_slice("err_wl7_bank1_i",13,13);
            this.err_wl8_9_bank1_reg.add_hdl_path_slice("err_wl8_bank1_i",0,13);
            this.err_wl8_9_bank1_reg.add_hdl_path_slice("err_wl9_bank1_i",13,13);
            this.err_wl10_11_bank1_reg.add_hdl_path_slice("err_wl10_bank1_i",0,13);
            this.err_wl10_11_bank1_reg.add_hdl_path_slice("err_wl11_bank1_i",13,13);
            this.err_wl12_13_bank1_reg.add_hdl_path_slice("err_wl12_bank1_i",0,13);
            this.err_wl12_13_bank1_reg.add_hdl_path_slice("err_wl13_bank1_i",13,13);
            this.err_wl14_15_bank1_reg.add_hdl_path_slice("err_wl14_bank1_i",0,13);
            this.err_wl14_15_bank1_reg.add_hdl_path_slice("err_wl15_bank1_i",13,13);
            this.err_wl16_17_bank1_reg.add_hdl_path_slice("err_wl16_bank1_i",0,13);
            this.err_wl16_17_bank1_reg.add_hdl_path_slice("err_wl17_bank1_i",13,13);
            this.err_wl18_19_bank1_reg.add_hdl_path_slice("err_wl18_bank1_i",0,13);
            this.err_wl18_19_bank1_reg.add_hdl_path_slice("err_wl19_bank1_i",13,13);
            this.err_wl20_21_bank1_reg.add_hdl_path_slice("err_wl20_bank1_i",0,13);
            this.err_wl20_21_bank1_reg.add_hdl_path_slice("err_wl21_bank1_i",13,13);
            this.err_wl22_23_bank1_reg.add_hdl_path_slice("err_wl22_bank1_i",0,13);
            this.err_wl22_23_bank1_reg.add_hdl_path_slice("err_wl23_bank1_i",13,13);
            this.err_wl24_25_bank1_reg.add_hdl_path_slice("err_wl24_bank1_i",0,13);
            this.err_wl24_25_bank1_reg.add_hdl_path_slice("err_wl25_bank1_i",13,13);
            this.err_wl26_27_bank1_reg.add_hdl_path_slice("err_wl26_bank1_i",0,13);
            this.err_wl26_27_bank1_reg.add_hdl_path_slice("err_wl27_bank1_i",13,13);
            this.err_wl28_29_bank1_reg.add_hdl_path_slice("err_wl28_bank1_i",0,13);
            this.err_wl28_29_bank1_reg.add_hdl_path_slice("err_wl29_bank1_i",13,13);
            this.err_wl30_31_bank1_reg.add_hdl_path_slice("err_wl30_bank1_i",0,13);
            this.err_wl30_31_bank1_reg.add_hdl_path_slice("err_wl31_bank1_i",13,13);
            this.err_wl32_33_bank1_reg.add_hdl_path_slice("err_wl32_bank1_i",0,13);
            this.err_wl32_33_bank1_reg.add_hdl_path_slice("err_wl33_bank1_i",13,13);
            this.err_wl34_35_bank1_reg.add_hdl_path_slice("err_wl34_bank1_i",0,13);
            this.err_wl34_35_bank1_reg.add_hdl_path_slice("err_wl35_bank1_i",13,13);
            this.err_wl36_37_bank1_reg.add_hdl_path_slice("err_wl36_bank1_i",0,13);
            this.err_wl36_37_bank1_reg.add_hdl_path_slice("err_wl37_bank1_i",13,13);
            this.err_wl38_39_bank1_reg.add_hdl_path_slice("err_wl38_bank1_i",0,13);
            this.err_wl38_39_bank1_reg.add_hdl_path_slice("err_wl39_bank1_i",13,13);
            this.err_wl40_41_bank1_reg.add_hdl_path_slice("err_wl40_bank1_i",0,13);
            this.err_wl40_41_bank1_reg.add_hdl_path_slice("err_wl41_bank1_i",13,13);
            this.err_wl42_43_bank1_reg.add_hdl_path_slice("err_wl42_bank1_i",0,13);
            this.err_wl42_43_bank1_reg.add_hdl_path_slice("err_wl43_bank1_i",13,13);
            this.err_wl44_45_bank1_reg.add_hdl_path_slice("err_wl44_bank1_i",0,13);
            this.err_wl44_45_bank1_reg.add_hdl_path_slice("err_wl45_bank1_i",13,13);
            this.err_wl46_47_bank1_reg.add_hdl_path_slice("err_wl46_bank1_i",0,13);
            this.err_wl46_47_bank1_reg.add_hdl_path_slice("err_wl47_bank1_i",13,13);
            this.err_wl48_49_bank1_reg.add_hdl_path_slice("err_wl48_bank1_i",0,13);
            this.err_wl48_49_bank1_reg.add_hdl_path_slice("err_wl49_bank1_i",13,13);
            this.err_wl50_51_bank1_reg.add_hdl_path_slice("err_wl50_bank1_i",0,13);
            this.err_wl50_51_bank1_reg.add_hdl_path_slice("err_wl51_bank1_i",13,13);
            this.err_wl52_53_bank1_reg.add_hdl_path_slice("err_wl52_bank1_i",0,13);
            this.err_wl52_53_bank1_reg.add_hdl_path_slice("err_wl53_bank1_i",13,13);
            this.err_wl54_55_bank1_reg.add_hdl_path_slice("err_wl54_bank1_i",0,13);
            this.err_wl54_55_bank1_reg.add_hdl_path_slice("err_wl55_bank1_i",13,13);
            this.err_wl56_57_bank1_reg.add_hdl_path_slice("err_wl56_bank1_i",0,13);
            this.err_wl56_57_bank1_reg.add_hdl_path_slice("err_wl57_bank1_i",13,13);
            this.err_wl58_59_bank1_reg.add_hdl_path_slice("err_wl58_bank1_i",0,13);
            this.err_wl58_59_bank1_reg.add_hdl_path_slice("err_wl59_bank1_i",13,13);
            this.err_wl60_61_bank1_reg.add_hdl_path_slice("err_wl60_bank1_i",0,13);
            this.err_wl60_61_bank1_reg.add_hdl_path_slice("err_wl61_bank1_i",13,13);
            this.err_wl62_63_bank1_reg.add_hdl_path_slice("err_wl62_bank1_i",0,13);
            this.err_wl62_63_bank1_reg.add_hdl_path_slice("err_wl63_bank1_i",13,13);
            this.err_csl_part0_1_bank1_reg.add_hdl_path_slice("err_csl0_part0_bank1_i",0,8);
            this.err_csl_part0_1_bank1_reg.add_hdl_path_slice("err_csl1_part0_bank1_i",8,8);
            this.err_csl_part0_1_bank1_reg.add_hdl_path_slice("err_csl0_part1_bank1_i",16,8);
            this.err_csl_part0_1_bank1_reg.add_hdl_path_slice("err_csl1_part1_bank1_i",24,8);
            this.err_csl_part2_3_bank1_reg.add_hdl_path_slice("err_csl0_part2_bank1_i",0,8);
            this.err_csl_part2_3_bank1_reg.add_hdl_path_slice("err_csl1_part2_bank1_i",8,8);
            this.err_csl_part2_3_bank1_reg.add_hdl_path_slice("err_csl0_part3_bank1_i",16,8);
            this.err_csl_part2_3_bank1_reg.add_hdl_path_slice("err_csl1_part3_bank1_i",24,8);
            this.err_csl_part4_5_bank1_reg.add_hdl_path_slice("err_csl0_part4_bank1_i",0,8);
            this.err_csl_part4_5_bank1_reg.add_hdl_path_slice("err_csl1_part4_bank1_i",8,8);
            this.err_csl_part4_5_bank1_reg.add_hdl_path_slice("err_csl0_part5_bank1_i",16,8);
            this.err_csl_part4_5_bank1_reg.add_hdl_path_slice("err_csl1_part5_bank1_i",24,8);
            this.err_csl_part6_7_bank1_reg.add_hdl_path_slice("err_csl0_part6_bank1_i",0,8);
            this.err_csl_part6_7_bank1_reg.add_hdl_path_slice("err_csl1_part6_bank1_i",8,8);
            this.err_csl_part6_7_bank1_reg.add_hdl_path_slice("err_csl0_part7_bank1_i",16,8);
            this.err_csl_part6_7_bank1_reg.add_hdl_path_slice("err_csl1_part7_bank1_i",24,8);
            this.err_csl_part8_9_bank1_reg.add_hdl_path_slice("err_csl0_part8_bank1_i",0,8);
            this.err_csl_part8_9_bank1_reg.add_hdl_path_slice("err_csl1_part8_bank1_i",8,8);
            this.err_csl_part8_9_bank1_reg.add_hdl_path_slice("err_csl0_part9_bank1_i",16,8);
            this.err_csl_part8_9_bank1_reg.add_hdl_path_slice("err_csl1_part9_bank1_i",24,8);
            this.mc_bank_cfg_reg_reg.add_hdl_path_slice("mc_bank_map_id_o",0,8);
            this.mc_bank_cfg_reg_reg.add_hdl_path_slice("mc_bist_grant_o",8,4);
            this.mc_timeout_clr_reg.add_hdl_path_slice("mc_timeout_clr_o",0,1);
            this.mc_rf_start_dbg_reg.add_hdl_path_slice("mc_rf_start_dbg_i",0,1);
            this.mc_timeout_flag_reg.add_hdl_path_slice("mc_timeout_flag_i",0,1);
            this.mc_bist_status_reg.add_hdl_path_slice("mc_bist_status_i",0,3);
            this.mc_bist_status_reg.add_hdl_path_slice("mc_bist_path_fail_bank0_i",3,1);
            this.mc_bist_status_reg.add_hdl_path_slice("mc_bist_path_fail_bank1_i",4,1);
            this.mc_bist_status_reg.add_hdl_path_slice("dram_init_finish_i",5,1);
            this.bist_finish_and_success_reg.add_hdl_path_slice("bist_finish_bank0_i",0,1);
            this.bist_finish_and_success_reg.add_hdl_path_slice("bist_finish_bank1_i",1,1);
            this.bist_finish_and_success_reg.add_hdl_path_slice("bist_rescan_finish_bank0_i",2,1);
            this.bist_finish_and_success_reg.add_hdl_path_slice("bist_rescan_finish_bank1_i",3,1);
            this.bist_finish_and_success_reg.add_hdl_path_slice("bank_success_bank0_i",4,1);
            this.bist_finish_and_success_reg.add_hdl_path_slice("bank_success_bank1_i",5,1);
            this.bist_finish_and_success_reg.add_hdl_path_slice("bist_rescan_success_bank0_i",6,1);
            this.bist_finish_and_success_reg.add_hdl_path_slice("bist_rescan_success_bank1_i",7,1);
            this.mc_bist_rescan_fail_num_bank0_reg.add_hdl_path_slice("mc_bist_rescan_fail_num_bank0_i",0,20);
            this.mc_bist_rescan_fail_num_bank1_reg.add_hdl_path_slice("mc_bist_rescan_fail_num_bank1_i",0,20);
            this.mc_bist_err_wl_reg.add_hdl_path_slice("mc_bist_err_wl_num_bank0_i",0,7);
            this.mc_bist_err_wl_reg.add_hdl_path_slice("mc_bist_err_wl_num_bank1_i",7,7);
            this.mc_bist_err_wl_reg.add_hdl_path_slice("err_wl_num_change_flag_bank0_i",14,1);
            this.mc_bist_err_wl_reg.add_hdl_path_slice("err_wl_num_change_flag_bank1_i",15,1);
            this.rescan_finish_clr_reg.add_hdl_path_slice("rescan_finish_clr_o",0,1);
            this.rescan_finish_mask_reg.add_hdl_path_slice("rescan_finish_mask_o",0,1);
            this.rescan_round_result_1_reg.add_hdl_path_slice("rescan_round_result_bank0_i",0,15);
            this.rescan_round_result_1_reg.add_hdl_path_slice("rescan_round_result_bank1_i",15,15);
            this.bist_finish_clr_reg.add_hdl_path_slice("bist_finish_clr_o",0,1);
            this.bist_finish_mask_reg.add_hdl_path_slice("bist_finish_mask_o",0,1);
            this.hang_timeout_th_reg.add_hdl_path_slice("hang_timeout_th_o",0,32);
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
            this.mc_frame2array_dbg_reg.add_hdl_path_slice("dbg_next_state_array_i",0,5);
            this.mc_frame2array_dbg_reg.add_hdl_path_slice("dbg_current_state_array_i",8,5);
            this.mc_frame2array_dbg_reg.add_hdl_path_slice("dbg_r_data_cnt_i",16,2);
            this.mc_frame2array_dbg_reg.add_hdl_path_slice("dbg_refresh_flag_i",20,1);
            this.mc_frame2array_dbg_reg.add_hdl_path_slice("dbg_r_frame_cnt_i",24,2);
            this.mc_frame2array_dbg_reg.add_hdl_path_slice("dbg_w_frame_cnt_i",28,2);
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
            this.mc_ecc_ce_ctrl_reg.add_hdl_path_slice("mc_ecc_ce_int_clr_o",0,1);
            this.mc_ecc_ce_ctrl_reg.add_hdl_path_slice("mc_ecc_ce_overflow_int_i",4,1);
            this.mc_ecc_ce_ctrl_reg.add_hdl_path_slice("mc_ecc_ce_th_o",8,5);
            this.mc_ecc_ce_ctrl_reg.add_hdl_path_slice("mc_ecc_ce_cnt_i",16,5);
            this.mc_ecc_ce_ctrl_reg.add_hdl_path_slice("mc_ecc_ce_int_mask_o",24,1);
            this.mc_ecc_ce_ctrl_reg.add_hdl_path_slice("mc_ecc_ce_int_en_o",25,1);
            this.mc_ecc_ce_addr0_reg.add_hdl_path_slice("mc_ecc_ce_addr0_i",0,22);
            this.mc_ecc_ce_addr0_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld0_i",22,1);
            this.mc_ecc_ce_addr0_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt0_i",24,8);
            this.mc_ecc_ce_addr1_reg.add_hdl_path_slice("mc_ecc_ce_addr1_i",0,22);
            this.mc_ecc_ce_addr1_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld1_i",22,1);
            this.mc_ecc_ce_addr1_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt1_i",24,8);
            this.mc_ecc_ce_addr2_reg.add_hdl_path_slice("mc_ecc_ce_addr2_i",0,22);
            this.mc_ecc_ce_addr2_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld2_i",22,1);
            this.mc_ecc_ce_addr2_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt2_i",24,8);
            this.mc_ecc_ce_addr3_reg.add_hdl_path_slice("mc_ecc_ce_addr3_i",0,22);
            this.mc_ecc_ce_addr3_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld3_i",22,1);
            this.mc_ecc_ce_addr3_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt3_i",24,8);
            this.mc_ecc_ce_addr4_reg.add_hdl_path_slice("mc_ecc_ce_addr4_i",0,22);
            this.mc_ecc_ce_addr4_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld4_i",22,1);
            this.mc_ecc_ce_addr4_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt4_i",24,8);
            this.mc_ecc_ce_addr5_reg.add_hdl_path_slice("mc_ecc_ce_addr5_i",0,22);
            this.mc_ecc_ce_addr5_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld5_i",22,1);
            this.mc_ecc_ce_addr5_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt5_i",24,8);
            this.mc_ecc_ce_addr6_reg.add_hdl_path_slice("mc_ecc_ce_addr6_i",0,22);
            this.mc_ecc_ce_addr6_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld6_i",22,1);
            this.mc_ecc_ce_addr6_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt6_i",24,8);
            this.mc_ecc_ce_addr7_reg.add_hdl_path_slice("mc_ecc_ce_addr7_i",0,22);
            this.mc_ecc_ce_addr7_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld7_i",22,1);
            this.mc_ecc_ce_addr7_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt7_i",24,8);
            this.mc_ecc_ce_addr8_reg.add_hdl_path_slice("mc_ecc_ce_addr8_i",0,22);
            this.mc_ecc_ce_addr8_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld8_i",22,1);
            this.mc_ecc_ce_addr8_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt8_i",24,8);
            this.mc_ecc_ce_addr9_reg.add_hdl_path_slice("mc_ecc_ce_addr9_i",0,22);
            this.mc_ecc_ce_addr9_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld9_i",22,1);
            this.mc_ecc_ce_addr9_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt9_i",24,8);
            this.mc_ecc_ce_addr10_reg.add_hdl_path_slice("mc_ecc_ce_addr10_i",0,22);
            this.mc_ecc_ce_addr10_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld10_i",22,1);
            this.mc_ecc_ce_addr10_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt10_i",24,8);
            this.mc_ecc_ce_addr11_reg.add_hdl_path_slice("mc_ecc_ce_addr11_i",0,22);
            this.mc_ecc_ce_addr11_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld11_i",22,1);
            this.mc_ecc_ce_addr11_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt11_i",24,8);
            this.mc_ecc_ce_addr12_reg.add_hdl_path_slice("mc_ecc_ce_addr12_i",0,22);
            this.mc_ecc_ce_addr12_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld12_i",22,1);
            this.mc_ecc_ce_addr12_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt12_i",24,8);
            this.mc_ecc_ce_addr13_reg.add_hdl_path_slice("mc_ecc_ce_addr13_i",0,22);
            this.mc_ecc_ce_addr13_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld13_i",22,1);
            this.mc_ecc_ce_addr13_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt13_i",24,8);
            this.mc_ecc_ce_addr14_reg.add_hdl_path_slice("mc_ecc_ce_addr14_i",0,22);
            this.mc_ecc_ce_addr14_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld14_i",22,1);
            this.mc_ecc_ce_addr14_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt14_i",24,8);
            this.mc_ecc_ce_addr15_reg.add_hdl_path_slice("mc_ecc_ce_addr15_i",0,22);
            this.mc_ecc_ce_addr15_reg.add_hdl_path_slice("mc_ecc_ce_addr_vld15_i",22,1);
            this.mc_ecc_ce_addr15_reg.add_hdl_path_slice("mc_ecc_ce_addr_cnt15_i",24,8);
            this.mc_ecc_uce_ctrl_reg.add_hdl_path_slice("mc_ecc_uce_int_clr_o",0,1);
            this.mc_ecc_uce_ctrl_reg.add_hdl_path_slice("mc_ecc_uce_int_i",4,1);
            this.mc_ecc_uce_ctrl_reg.add_hdl_path_slice("mc_ecc_uce_cnt_i",8,3);
            this.mc_ecc_uce_ctrl_reg.add_hdl_path_slice("mc_ecc_uce_int_mask_o",12,1);
            this.mc_ecc_uce_addr0_reg.add_hdl_path_slice("mc_ecc_uce_addr0_i",0,22);
            this.mc_ecc_uce_addr0_reg.add_hdl_path_slice("mc_ecc_uce_addr_vld0_i",22,1);
            this.mc_ecc_uce_addr1_reg.add_hdl_path_slice("mc_ecc_uce_addr1_i",0,22);
            this.mc_ecc_uce_addr1_reg.add_hdl_path_slice("mc_ecc_uce_addr_vld1_i",22,1);
            this.mc_ecc_uce_addr2_reg.add_hdl_path_slice("mc_ecc_uce_addr2_i",0,22);
            this.mc_ecc_uce_addr2_reg.add_hdl_path_slice("mc_ecc_uce_addr_vld2_i",22,1);
            this.mc_ecc_uce_addr3_reg.add_hdl_path_slice("mc_ecc_uce_addr3_i",0,22);
            this.mc_ecc_uce_addr3_reg.add_hdl_path_slice("mc_ecc_uce_addr_vld3_i",22,1);
            this.mc_page_status_reg.add_hdl_path_slice("mc_page_status_i",0,1);
            this.hang_timeout_status_reg.add_hdl_path_slice("hang_timeout_status_i",0,1);
            this.hang_timeout_mask_reg.add_hdl_path_slice("hang_timeout_mask_o",0,1);
            this.hang_timeout_clr_reg.add_hdl_path_slice("hang_timeout_clr_o",0,1);
            this.hang_timeout_en_reg.add_hdl_path_slice("hang_timeout_en_o",0,1);
            this.bist_clk_cnt_reg.add_hdl_path_slice("bist_clk_cnt_i",0,32);

    endfunction : build

    `uvm_object_utils(ral_block_mc_1short2_top_aux_top)

endclass : ral_block_mc_1short2_top_aux_top


class ral_sys_mc_1short2_top_aux extends uvm_reg_block;

    rand ral_block_mc_1short2_top_aux_top MC_1SHORT2_TOP_AUX_ins;

    function new(string name = "mc_1short2_top_aux");
        super.new(name);
    endfunction: new

    function void build();
        this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);

        this.MC_1SHORT2_TOP_AUX_ins = ral_block_mc_1short2_top_aux_top::type_id::create("MC_1SHORT2_TOP_AUX_ins",,get_full_name());
        this.MC_1SHORT2_TOP_AUX_ins.configure(this, "");
        this.MC_1SHORT2_TOP_AUX_ins.build();
        this.default_map.add_submap(this.MC_1SHORT2_TOP_AUX_ins.default_map, `UVM_REG_ADDR_WIDTH'h0);
        this.MC_1SHORT2_TOP_AUX_ins.add_hdl_path("mc_wrapper_U.mc_top_U.apb2reg_mc_soc_cfg_if.v");

    endfunction : build

    `uvm_object_utils(ral_sys_mc_1short2_top_aux)
endclass : ral_sys_mc_1short2_top_aux

`endif
