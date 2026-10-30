//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_dg0_smoke_vseq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 26 10:33:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_DG0_SMOKE_VSEQ
`define MC_DG0_SMOKE_VSEQ
class mc_dg0_smoke_vseq extends mc_common_vseq;
    
    `uvm_object_utils(mc_dg0_smoke_vseq)

    rand bit [`COL_ADDR_WIDTH-1:0] cadd_seed;
    rand bit [`ROW_ADDR_WIDTH-1:0] radd_seed;
    rand bit                        bank_sel;
    rand bit            page_mode;
    rand bit            pre_precharge_en;
    rand bit    [15:0]  one_frame_cnt_i;
    bit                 frame_rw_flag_i;
    rand bit            performance_test_en;
    rand bit    [9:0]   round_num;
    bit         [31:0]  mc_page_status=0; 
    bit         [31:0]  read_soc_reg1=0; 
    rand bit [9:0] num_seed;
    rand bit            close_page_en;
    rand bit [1:0] burst_seed;
    constraint radd_c {radd_seed inside {[0:7295]};}
    constraint burst_seed_c {burst_seed inside {[1:3]};}
    
    function new(string name="mc_dg0_smoke_vseq");
        super.new(name);
    endfunction
    
virtual task body();
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    uvm_hdl_force("mc_tb.m_mc_wrapper_aux.mc_top_u.dram_init_wr_aux_u.dram_init_wr_aux_u0.row_end_addr[12:0]", 13'h010f);
    super.body();
    `ifndef NO_INIT
        wait(m_tb_if.mc_dram_init_wr_finish==1);
    `endif
    assert(randomize());
    `uvm_info("", $sformatf("close_page_en: %0h", close_page_en), UVM_MEDIUM)
    m_tb_if.dbg_data_store_en=1;
    
    if(close_page_en == 1)begin
        while(mc_page_status==1)begin
            `uvm_info("", $sformatf("mc_page_status: %0h", mc_page_status), UVM_MEDIUM)
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
        end
        @(posedge m_tb_if.pclk);
        m_tb_if.page_mode_switch = 1'b1;
        m_tb_if.pre_precharge = 0;
    end    
    #10;//00;

    burst_seed = 1;
    fork 
        begin
            m_frame_agent_if.performance_test_en = performance_test_en;
            `uvm_info(get_type_name(), $sformatf("performance_test_en =%0h",performance_test_en), UVM_LOW);
            if(burst_seed==1)begin
                for(int i=0;i<100;i++)begin//burst 1
                    assert(randomize(cadd_seed,radd_seed,bank_sel));
                    assert(m_frame_cfg.randomize with {
                            bank_sel            == local::bank_sel; 
                            radd                == radd_seed;
                            cadd                == cadd_seed;
                            frame_rw_flag       == 1;   //1:wr 0:rd
                            one_frame_cnt       == 1;
                            col_addr_rand_en    == 0;
                            wrap_en             == 0;
                            strb_rand_en        == 0;
                            strb                == 1;
                        });
                    `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                    send_one_frame(m_frame_cfg);

                    assert(m_frame_cfg.randomize with {
                            bank_sel            == local::bank_sel; 
                            radd                == radd_seed;
                            cadd                == cadd_seed;
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

                assert(randomize(cadd_seed,radd_seed));
                assert(m_frame_cfg.randomize with {
                        bank_sel            == 0;
                        radd                == radd_seed;
                        cadd                == cadd_seed;
                        frame_rw_flag       == 1;   //1:wr 0:rd
                        one_frame_cnt       == 1;
                        col_addr_rand_en    == 0;
                        wrap_en             == 0;
                    });
                `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                send_one_frame(m_frame_cfg);
                assert(m_frame_cfg.randomize with {
                        bank_sel            == 0;
                        radd                == radd_seed;
                        cadd                == cadd_seed;
                        frame_rw_flag       == 0;   //1:wr 0:rd
                        one_frame_cnt       == 1;
                        col_addr_rand_en    == 0;
                        wrap_en             == 0;
                    });
                `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                send_one_frame(m_frame_cfg);
                assert(m_frame_cfg.randomize with {
                        bank_sel            == 1;
                        radd                == radd_seed;
                        cadd                == cadd_seed;
                        frame_rw_flag       == 1;   //1:wr 0:rd
                        one_frame_cnt       == 1;
                        col_addr_rand_en    == 0;
                        wrap_en             == 0;
                    });
                `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                send_one_frame(m_frame_cfg);
                assert(m_frame_cfg.randomize with {
                        bank_sel            == 1;
                        radd                == radd_seed;
                        cadd                == cadd_seed;
                        frame_rw_flag       == 0;   //1:wr 0:rd
                        one_frame_cnt       == 1;
                        col_addr_rand_en    == 0;
                        wrap_en             == 0;
                    });
                `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                send_one_frame(m_frame_cfg);

                `uvm_info(get_type_name(),"body====boundary_frame_write=======================start==========",UVM_LOW);
                for(int cnt_bank = 0; cnt_bank < 2; cnt_bank++) begin
                    assert(m_frame_cfg.randomize with {
                            bank_sel            == cnt_bank;
                            radd                == 0;
                            cadd                == 0;
                            frame_rw_flag       == 1;   //1:wr 0:rd
                            one_frame_cnt       == 1;
                            col_addr_rand_en    == 0;
                            wrap_en             == 0;
                        });
                    `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                    send_one_frame(m_frame_cfg);

                    assert(m_frame_cfg.randomize with {
                            bank_sel            == cnt_bank;
                            radd                == 0;
                            cadd                == 0;
                            frame_rw_flag       == 0;   //1:wr 0:rd
                            one_frame_cnt       == 1;
                            col_addr_rand_en    == 0;
                            wrap_en             == 0;
                        });
                    `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);    
                    send_one_frame(m_frame_cfg);

                    assert(m_frame_cfg.randomize with {
                            bank_sel            == cnt_bank;
                            radd                == 13'd7295;
                            cadd                == 7'h7f;
                            frame_rw_flag       == 1;   //1:wr 0:rd
                            one_frame_cnt       == 1;
                            col_addr_rand_en    == 0;
                            wrap_en             == 0;
                        });
                    `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                    send_one_frame(m_frame_cfg);

                    assert(m_frame_cfg.randomize with {
                            bank_sel            == cnt_bank;
                            radd                == 14'd7295;
                            cadd                == 7'h7f;
                            frame_rw_flag       == 0;   //1:wr 0:rd
                            one_frame_cnt       == 1;
                            col_addr_rand_en    == 0;
                            wrap_en             == 0;
                        });
                    `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                    send_one_frame(m_frame_cfg);
                end

                #1us;
                `uvm_info(get_type_name(),"body====boundary_frame_write=======================finish==========",UVM_LOW);
            end
            if(burst_seed==2)begin
                randomize(round_num) with {round_num inside{[1:20]};};
                `uvm_info(get_full_name(),$sformatf("round_num = %0d",round_num),UVM_LOW);
                
                for(int h=0;h<round_num;h++)begin
                    assert(randomize(performance_test_en));
                    `uvm_info(get_full_name(),$sformatf("performance_test_en = %0d",performance_test_en),UVM_LOW);
                    m_frame_agent_if.performance_test_en = performance_test_en;
                
                    //wr_rd_wr_rd_addr_rand
                    for(int i=0;i<4;i++)begin
                        randomize(one_frame_cnt_i) with {one_frame_cnt_i inside{[1:64]};};
                        if(i%2 == 1)frame_rw_flag_i = 0;
                        else    frame_rw_flag_i = 1;
                        
                        assert(m_frame_cfg.randomize with {
                            frame_rw_flag       == frame_rw_flag_i;   //1:wr 0:rd
                            one_frame_cnt       == one_frame_cnt_i;
                            col_addr_rand_en    == 1;                                    
                        });
                        `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                        send_one_frame(m_frame_cfg);
                
                    end
                
                    //wr_rd_wr_rd_addr_continu
                    for(int i=0;i<4;i++)begin
                        randomize(one_frame_cnt_i) with {one_frame_cnt_i inside{[1:128]};};
                        if(i%2 == 1)frame_rw_flag_i = 0;
                        else    frame_rw_flag_i = 1;
                        
                        assert(m_frame_cfg.randomize with {
                            frame_rw_flag       == frame_rw_flag_i;   //1:wr 0:rd
                            one_frame_cnt       == one_frame_cnt_i;
                            col_addr_rand_en    == 0;            
                        });
                        `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                        send_one_frame(m_frame_cfg);
                    end
                    
                
                    //wr_wr_rd_rd_addr_rand
                
                    for(int i=0;i<4;i++)begin
                        randomize(one_frame_cnt_i) with {one_frame_cnt_i inside{[1:128]};};
                        if(i<=1)frame_rw_flag_i = 1;
                        else    frame_rw_flag_i = 0;
                
                        assert(m_frame_cfg.randomize with {
                            frame_rw_flag       == frame_rw_flag_i;   //1:wr 0:rd
                            one_frame_cnt       == one_frame_cnt_i;
                            col_addr_rand_en    == 1;            
                        });
                        `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                        send_one_frame(m_frame_cfg);
                    end
                    
                    //wr_wr_rd_rd_addr_contiun
                
                    for(int i=0;i<4;i++)begin
                        randomize(one_frame_cnt_i) with {one_frame_cnt_i inside{[1:128]};};
                        
                        if(i<=1)frame_rw_flag_i = 1;
                        else    frame_rw_flag_i = 0;
                
                        assert(m_frame_cfg.randomize with {
                            frame_rw_flag       == frame_rw_flag_i;   //1:wr 0:rd
                            one_frame_cnt       == one_frame_cnt_i;
                            col_addr_rand_en    == 0;            
                        });
                        `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                        send_one_frame(m_frame_cfg);
                    end
                end 
            end
            if(burst_seed==3)begin
                for(int i=0;i<num_seed;i++)begin
                    `uvm_info(get_type_name(),$sformatf("i =%0d ",i),UVM_LOW);
                    assert(randomize(radd_seed));
                    assert(m_frame_cfg.randomize with {
                        radd                == radd_seed;
                        cadd                == 0;
                        frame_rw_flag       == 1;   //1:wr 0:rd
                        one_frame_cnt       == 'd128;
                        col_addr_rand_en    == 0;
                        wrap_en             == 0;
                        strb_rand_en        == 0;
                        strb                == 1;
                    });
                    send_one_frame(m_frame_cfg);        
                    assert(m_frame_cfg.randomize with {
                        radd                == radd_seed;
                        cadd                == 0;
                        frame_rw_flag       == 0;   //1:wr 0:rd
                        one_frame_cnt       == 'd128;
                        col_addr_rand_en    == 0;
                        wrap_en             == 0;

                    });
                    send_one_frame(m_frame_cfg);        
                end
            end
            //m_tb_if.case_finish_flag = 1;
            `uvm_info(get_type_name(),"wr_rd_finish",UVM_LOW);
        end 
        begin
            while(1)begin
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_frame_store_0_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_frame_store_1_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_frame_store_2_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_frame_store_3_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_frame_store_4_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_frame_store_5_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_frame_store_6_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_frame_store_7_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_frame_store_8_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_frame_store_9_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);

                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_rdata_store_0_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_rdata_store_1_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_rdata_store_2_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_rdata_store_3_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_rdata_store_4_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_rdata_store_5_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_rdata_store_6_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_rdata_store_7_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.dbg_rdata_store_8_reg.read(status,read_soc_reg1, UVM_FRONTDOOR);
            end
        end
    join_any
    disable fork;
    #1us;
    m_tb_if.dbg_data_store_en=0;

    //====================refresh====================
    m_tb_if.rf_range_change_en      = 1'b1;
    repeat(10) @(posedge m_tb_if.pclk);
    m_tb_if.rf_addr         = {13'h0, 13'h100};
    m_tb_if.rf_period       = 32'h4000;
    m_tb_if.rf_period_up_en = 1;
    m_tb_if.mc_rf_start     = 1;
    @(posedge m_tb_if.pclk);
    repeat(100) begin
        assert(randomize(cadd_seed,radd_seed,bank_sel));
        assert(m_frame_cfg.randomize with {
                bank_sel            == local::bank_sel;
                radd                == radd_seed;
                cadd                == cadd_seed;
                frame_rw_flag       == 1;   //1:wr 0:rd
                one_frame_cnt       == 1;
                col_addr_rand_en    == 0;
                wrap_en             == 0;
            });
        send_one_frame(m_frame_cfg);
        assert(m_frame_cfg.randomize with {
                bank_sel            == local::bank_sel;
                radd                == radd_seed;
                cadd                == cadd_seed;
                frame_rw_flag       == 0;   //1:wr 0:rd
                one_frame_cnt       == 1;
                col_addr_rand_en    == 0;
                wrap_en             == 0;
            });
        send_one_frame(m_frame_cfg);
    end
    #1us;

endtask
endclass
`endif
