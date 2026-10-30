`ifndef TRIM_REG_TEST_SV
`define TRIM_REG_TEST_SV

class trim_regtest_seq extends uvm_reg_sequence;
    ral_sys_dram_trim rgm;
    //0716//virtual apb_vip_master_if vif;
    virtual svt_apb_if vif;
    `uvm_object_utils(trim_regtest_seq)
    //0716//`uvm_declare_p_sequencer(apb_vip_master_sequencer)//should add sequencer manully
    `uvm_declare_p_sequencer(trim_vseqr)//should add sequencer manully
    function new(string name="trim_regtest_seq");
        super.new(name);
    endfunction

    function ral_sys_dram_trim get_regmodel();
        $cast(rgm,p_sequencer.regmodel);
        return rgm;
    endfunction

    function void get_config();
        //0716//if(!uvm_config_db#(virtual apb_vip_master_if)::get(m_sequencer,"","apb_vip_master_vif",vif))begin
        if(!uvm_config_db#(virtual svt_apb_if)::get(m_sequencer,"","apb_vif",vif))begin
            `uvm_fatal("GETVIF","cannot get vif handle from m_sequencer")
        end
    endfunction

    virtual task dut_reset(int n=1);
        uvm_hdl_force("trim_tb.u_dram_trim_top.apb_rst_n",0);//should add right reset signal
        repeat(n)@(posedge vif.pclk);
        uvm_hdl_release("trim_tb.u_dram_trim_top.apb_rst_n");//should add right reset signal
    endtask

    //***************************************Add by lid-2025-07-16**************************************************Start
    //***********************For filter out w1c attribute and special or sticky registers***************************
    function reg_except();
        string reg_bit_bash_except_list[$];
        string reg_access_except_list[$];

        reg_bit_bash_except_list.push_back(rgm.DRAM_TRIM_ins.trim_op_ctrl.get_full_name());  //w1c 
        reg_bit_bash_except_list.push_back(rgm.DRAM_TRIM_ins.dumpready_timeout_ctrl.get_full_name());  //w1c
        reg_bit_bash_except_list.push_back(rgm.DRAM_TRIM_ins.ringo_timeout_ctrl.get_full_name());  //w1c
        reg_bit_bash_except_list.push_back(rgm.DRAM_TRIM_ins.trim_interrupt_ctrl.get_full_name());  //w1c
        foreach(reg_bit_bash_except_list[i]) begin
            uvm_resource_db#(bit)::set({"REG::",reg_bit_bash_except_list[i]},"NO_REG_BIT_BASH_TEST", 1, this);
        end

        reg_access_except_list.push_back(rgm.DRAM_TRIM_ins.trim_op_ctrl.get_full_name());       //w1c   
        reg_access_except_list.push_back(rgm.DRAM_TRIM_ins.dumpready_timeout_ctrl.get_full_name());  //w1c
        reg_access_except_list.push_back(rgm.DRAM_TRIM_ins.ringo_timeout_ctrl.get_full_name());    //w1c
        reg_access_except_list.push_back(rgm.DRAM_TRIM_ins.trim_interrupt_ctrl.get_full_name());       //sticky          
        foreach(reg_access_except_list[i]) begin
            uvm_resource_db#(bit)::set({"REG::",reg_access_except_list[i]},"NO_REG_ACCESS_TEST", 1, this);
        end

    endfunction
    //***************************************Add by lid-2025-07-16**************************************************End


    task body();
        uvm_status_e   status;
        uvm_reg_data_t data;
        uvm_reg_hw_reset_seq     reg_rst_seq    = new();
        uvm_reg_bit_bash_seq     reg_bit_seq    = new();
        iuvm_reg_access_seq      reg_access_seq = new();
        iuvm_reg_rand_access_seq reg_rand_seq   = new();

        get_config();
        rgm = get_regmodel();
        //0716//rgm.set_hdl_path_root("trim_tb.u_dram_trim_top.apb2reg_dram_trim_cfg_if_u");//should add the right hal path
        //0716//rgm.set_hdl_path_root("trim_tb.dut.trim_regfile");//should add the right hal path
        //uvm_resource_db#(bit)::set({"REG::",rgm.REG_NAME.get_full_name(),"*"},"NO_REG_ACCESS_TEST",1,this);
        reg_except(); //add by lid-0716

        @(posedge vif.presetn);
        reg_rst_seq.model = rgm;
        reg_rst_seq.start(m_sequencer);
        reg_bit_seq.model = rgm;
        reg_bit_seq.start(m_sequencer);
        reg_access_seq.model = rgm;
        reg_access_seq.start(m_sequencer);
        reg_rand_seq.model = rgm;
        reg_rand_seq.start(m_sequencer);
        dut_reset(100);
        reg_rst_seq.start(m_sequencer);

    endtask

endclass

class trim_reg_test extends trim_base_test;
    `uvm_component_utils(trim_reg_test)

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        super.m_env_config.scb_en = 0;
    endfunction

    task run_phase(uvm_phase phase);
        trim_regtest_seq seq = new();

        phase.raise_objection(this);
        super.run_phase(phase);
        //0716//seq.start(m_env.m_apb_vip_master_agent.m_sequencer);
        m_trim_if.reg_test = 1;
        seq.start(vseqr);
        phase.drop_objection(this);
    endtask

endclass
`endif //TRIM_REG_TEST_SV
