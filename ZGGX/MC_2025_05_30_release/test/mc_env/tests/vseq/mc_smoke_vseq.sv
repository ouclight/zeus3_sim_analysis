`ifndef MC_SMOKE_VSEQ
`define MC_SMOKE_VSEQ

class mc_smoke_vseq extends mc_common_vseq;
    
    
    `uvm_object_utils(mc_smoke_vseq)

    int master_num         ;
    int base_addr          ;
    bit[31:0] offset_addr        ;
    bit[31:0] wdata              ;
    bit[31:0] rdata              ;
    bit[31:0] clk_num              ;
    bit[31:0] read_soc_reg=0              ;
    bit[31:0] read_pe_reg=0              ;
    bit[31:0] read_soc_reg1=0              ;
    bit[31:0] read_pe_reg1=0              ;
    rand bit [`COL_ADDR_WIDTH-1:0] cadd_seed;
    rand bit [`ROW_ADDR_WIDTH-1:0] radd_seed;
    constraint radd_c {radd_seed inside {[0:7295]};}
    //constraint radd_c {radd_seed inside {[0:127]};}
    function new(string name="mc_smoke_vseq");
        super.new(name);
    endfunction

virtual task body();
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    super.body();

    `uvm_info(get_type_name(),"body=====apb_write======start===========",UVM_LOW);
        #1us;
        @(posedge p_sequencer.m_tb_if.pclk);
        base_addr = 0 ;
        m_tb_if.dbg_data_store_en=1;
        //m_tb_if.debug_test_en = 1;
    
        /*for (int i=0 ;i<2 ;i++)begin 
                master_num      =i          ;
                //offset_addr     =$urandom_range(32'hf,32'h0);
                //wdata           =$urandom_range(32'hffffffff,32'h0);
                offset_addr     =32'h4;
                wdata           =32'h1234_5678;
                apb_write(master_num,base_addr,offset_addr,wdata);
                //apb_write(master_num,base_addr,offset_addr<<2,wdata);
             
        end */


        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
        /*p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num0.write(status,32'h0, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num1.write(status,32'h0, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num2.write(status,32'h0, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num3.write(status,32'h0, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_up.write(status,32'h3, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_up.write(status,32'h5, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_down.write(status,32'h6, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_down.write(status,32'ha, UVM_FRONTDOOR);
        

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_wl_vmc_en.write(status,1'h1, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_bl_vmc_en.write(status,1'h1, UVM_FRONTDOOR);*/
        
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.page_mode_switch.page_mode_switch.write(status,1'b1, UVM_FRONTDOOR);
        //m_tb_if.page_mode_switch = 1'b1;


    `uvm_info(get_type_name(),"body====apb_read=======================finish==========",UVM_LOW);
    #1us; 

    `uvm_info(get_type_name(),"body====frame_write=======================start==========",UVM_LOW);
    for(int i=0;i<100;i++)begin
        assert(randomize(cadd_seed,radd_seed));
        assert(m_frame_cfg.randomize with {
                cadd                == cadd_seed;
                radd                == radd_seed;
                frame_rw_flag       == 1;   //1:wr 0:rd
                one_frame_cnt       == 1;
                col_addr_rand_en    == 0;
                wrap_en             == 0;
                strb_rand_en        == 0;
                strb                == 1;
            });
        `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
        
        send_one_frame(m_frame_cfg);
    end


    for(int j=0;j<100;j++)begin
        assert(randomize(cadd_seed,radd_seed));
        assert(m_frame_cfg.randomize with {
                cadd                == cadd_seed;
                radd                == radd_seed;
                frame_rw_flag       == 0;   //1:wr 0:rd
                one_frame_cnt       == 1;
                col_addr_rand_en    == 0;
                wrap_en             == 0;
                strb_rand_en        == 0;
                strb                == 1;
            });
        `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
        
        send_one_frame(m_frame_cfg);
    end
    
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.phy_timing_cfg0_reg.write(status,32'h0, UVM_FRONTDOOR);
    #1us; 
    m_tb_if.mc_id_pe=32'hffff_ffff;
    m_tb_if.mc_id_soc=32'hffff_ffff;
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_id_reg.read(status,read_pe_reg, UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_id_reg.read(status,read_soc_reg, UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.phy_timing_cfg0_reg.read(status,read_soc_reg, UVM_FRONTDOOR);

    #1us; 
    m_tb_if.mc_id_pe=32'h0;
    m_tb_if.mc_id_soc=32'h0;
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.phy_timing_cfg0_reg.write(status,32'hffff_ffff, UVM_FRONTDOOR);
    #1us; 
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_id_reg.read(status,read_pe_reg, UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_id_reg.read(status,read_soc_reg, UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.phy_timing_cfg0_reg.read(status,read_soc_reg, UVM_FRONTDOOR);


    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.phy_timing_cfg0_reg.write(status,32'h0, UVM_FRONTDOOR);
    #1us; 
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.phy_timing_cfg0_reg.read(status,read_soc_reg, UVM_FRONTDOOR);
    #1us; 

    `uvm_info(get_type_name(),"body====frame_write=======================finish==========",UVM_LOW);

    //@(posedge p_sequencer.m_array_agent_if.);


    #1us; 

endtask

endclass


`endif
