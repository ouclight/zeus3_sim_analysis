
`ifndef MC_REG_TEST_SV
`define MC_REG_TEST_SV

class mc_regtest_seq extends uvm_reg_sequence;

    ral_sys_mc_top_aux          mc_soc_regmodel;

    //ral_block_mc_regmodel rgm;
    //virtual apb_vip_master_if vif;
    `uvm_object_utils(mc_regtest_seq)
    `uvm_declare_p_sequencer(mc_vseqr)//should add sequencer manully
    function new(string name="mc_regtest_seq");
        super.new(name);
    endfunction

    function ral_sys_mc_top_aux get_mc_soc_regmodel();
        $cast(mc_soc_regmodel,p_sequencer.mc_soc_regmodel);
        return mc_soc_regmodel;
    endfunction

    //function void get_config();
    //    if(!uvm_config_db#(virtual apb_vip_master_if)::get(m_sequencer,"","apb_vip_master_vif",vif))begin
    //        `uvm_fatal("GETVIF","cannot get vif handle from m_sequencer")
    //    end
    //endfunction

    virtual task dut_reset(int n=1);
        uvm_hdl_force("mc_tb.apb_rst_n",0);//should add right reset signal
        repeat(n)@(posedge p_sequencer.m_svt_apb_if[0].pclk);
        uvm_hdl_release("mc_tb.apb_rst_n");//should add right reset signal
    endtask

    task body();
        uvm_status_e   status;
        uvm_reg_data_t data;
        uvm_reg_hw_reset_seq     reg_rst_seq    = new();
        uvm_reg_bit_bash_seq     reg_bit_seq    = new();
        uvm_reg_access_seq       reg_access_seq = new();
        //iuvm_reg_rand_access_seq reg_rand_seq   = new();

        //get_config();
        mc_soc_regmodel   =   get_mc_soc_regmodel();   
        mc_soc_regmodel  =   get_mc_soc_regmodel();
        //rgm = get_regmodel();
        //rgm.set_hdl_path_root("mc_tb.dut.mc_regfile");//should add the right hal path
        //uvm_resource_db#(bit)::set({"REG::",rgm.REG_NAME.get_full_name(),"*"},"NO_REG_ACCESS_TEST",1,this);

        @(posedge p_sequencer.m_svt_apb_if[0].presetn);

        //reset seq
        reg_rst_seq.model = mc_soc_regmodel;
        reg_rst_seq.start(p_sequencer.p_svt_apb_master_sqr[0]);
        reg_rst_seq.model = mc_soc_regmodel;
        reg_rst_seq.start(p_sequencer.p_svt_apb_master_sqr[1]);
        `uvm_info(get_type_name(),"reg_rst_seq done",UVM_LOW);
        
        
        //bit seq
        #100ns;
        reg_bit_seq.model = mc_soc_regmodel;
        reg_bit_seq.start(p_sequencer.p_svt_apb_master_sqr[0]);
        reg_bit_seq.model = mc_soc_regmodel;
        reg_bit_seq.start(p_sequencer.p_svt_apb_master_sqr[1]);
        `uvm_info(get_type_name(),"reg_bit_seq done",UVM_LOW);


        //access seq
        #100ns;
        reg_access_seq.model = mc_soc_regmodel;
        reg_access_seq.start(p_sequencer.p_svt_apb_master_sqr[0]);
        reg_access_seq.model = mc_soc_regmodel;
        reg_access_seq.start(p_sequencer.p_svt_apb_master_sqr[1]);
        `uvm_info(get_type_name(),"reg_access_seq done",UVM_LOW);

        dut_reset(100);

        
        //reset seq
        reg_rst_seq.model = mc_soc_regmodel;
        reg_rst_seq.start(p_sequencer.p_svt_apb_master_sqr[0]);
        reg_rst_seq.model = mc_soc_regmodel;
        reg_rst_seq.start(p_sequencer.p_svt_apb_master_sqr[1]);
        `uvm_info(get_type_name(),"reg_rst_seq done",UVM_LOW);
        
        
        //bit seq
        #100ns;
        reg_bit_seq.model = mc_soc_regmodel;
        reg_bit_seq.start(p_sequencer.p_svt_apb_master_sqr[0]);
        reg_bit_seq.model = mc_soc_regmodel;
        reg_bit_seq.start(p_sequencer.p_svt_apb_master_sqr[1]);
        `uvm_info(get_type_name(),"reg_bit_seq done",UVM_LOW);


        //access seq
        #100ns;
        reg_access_seq.model = mc_soc_regmodel;
        reg_access_seq.start(p_sequencer.p_svt_apb_master_sqr[0]);
        reg_access_seq.model = mc_soc_regmodel;
        reg_access_seq.start(p_sequencer.p_svt_apb_master_sqr[1]);
        `uvm_info(get_type_name(),"reg_access_seq done",UVM_LOW);

        //reg_rst_seq.model = rgm;
        //reg_rst_seq.start(m_sequencer);
        //reg_bit_seq.model = rgm;
        //reg_bit_seq.start(m_sequencer);
        //reg_access_seq.model = rgm;
        //reg_access_seq.start(m_sequencer);
        //reg_rand_seq.model = rgm;
        //reg_rand_seq.start(m_sequencer);
        //dut_reset();
        //reg_rst_seq.start(m_sequencer);

    endtask

endclass

class mc_reg_test extends mc_base_test;
    `uvm_component_utils(mc_reg_test)

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //super.m_env_config.scb_en = 0;
    endfunction

    task run_phase(uvm_phase phase);
        mc_regtest_seq seq = new();
        `uvm_info(get_type_name(),"mc_base_test begin",UVM_LOW);
        
        phase.raise_objection(this);
        super.run_phase(phase);
        seq.start(m_env.vseqr);

        `uvm_info(get_type_name(),"mc_base_test done",UVM_LOW);        

        phase.drop_objection(this);
    endtask

endclass
`endif //MC_REG_TEST_SV
