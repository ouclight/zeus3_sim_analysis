//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_array_timing_cfg_vseq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 26 10:33:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_array_timing_cfg_VSEQ
`define MC_array_timing_cfg_VSEQ




class mc_array_timing_cfg_vseq extends mc_common_vseq;
    
    
    `uvm_object_utils(mc_array_timing_cfg_vseq)

    //cg_clk_div          clk_div_cov;
    rand bit [`COL_ADDR_WIDTH-1:0] cadd_seed;
    rand bit [`ROW_ADDR_WIDTH-1:0] radd_seed;
    rand bit            page_mode;
    rand bit            pre_precharge_en;
    rand bit    [15:0]  one_frame_cnt_i;
    bit                 frame_rw_flag_i;
    rand bit            performance_test_en;
    rand bit    [9:0]   round_num;
    rand bit            close_page_en;
    bit         [31:0]  mc_page_status=0; 

    bit [4:0]   tras;
    bit [3:0]   trp;
    bit [5:0]   trc;
    bit [4:0]   trcd;
    bit [0:0]   trtp;
    bit [3:0]   twr;
    bit [2:0]   twtr;
    bit [3:0]   trtw;
    rand bit [4:0]   rand_tras;
    rand bit [3:0]   rand_trp;
    rand bit [5:0]   rand_trc;
    rand bit [4:0]   rand_trcd;
    rand bit [0:0]   rand_trtp;
    rand bit [3:0]   rand_twr;
    rand bit [2:0]   rand_twtr;
    rand bit [3:0]   rand_trtw;
    constraint radd_c {radd_seed inside {[0:7295]};};

    function new(string name="mc_array_timing_cfg_vseq");
        super.new(name);
        //clk_div_cov = new();
    endfunction


    
virtual task body();
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    super.body();
    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_trc_cfg[5:0]",trc);
    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_tras_cfg[4:0]",tras);
    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_trp_cfg[3:0]",trp);
    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_trcd_cfg[4:0]",trcd);
    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_trtp_cfg[0:0]",trtp);
    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_twr_cfg[3:0]",twr);
    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_twtr_cfg[2:0]",twtr);
    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_trtw_cfg[3:0]",trtw);
    `ifdef CLK_500M
    if(trc!='d21 && tras!='d14 && trp!='d7 && trcd!='d8 && trtp!='d1 && twr!='d8 && twtr!='d3 && trtw !='d4)begin
        `uvm_error("array timing check", "check failed")
    end
    `elsif CLK_300M
    if(trc!='d14 && tras!='d9 && trp!='d5 && trcd!='d5 && trtp!='d1 && twr!='d5 && twtr!='d2 && trtw !='d3)begin
        `uvm_error("array timing check", "check failed")
    end
    `else
    if(trc!='d33 && tras!='d22 && trp!='d11 && trcd!='d12 && trtp!='d0 && twr!='d12 && twtr!='d4 && trtw !='d6)begin
        `uvm_error("array timing check", "check failed")
    end
    `endif
    assert(randomize());
    
    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.page_mode_switch.page_mode_switch.write(status,1'b1, UVM_FRONTDOOR);//cfg close_page
    if(close_page_en==1)begin
        while(mc_page_status==1)begin
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
        end    
        m_tb_if.page_mode_switch = 1'b1;
        m_tb_if.pre_precharge = 1'b0;
    end
    fork 
        begin
            m_frame_agent_if.performance_test_en = performance_test_en;
            `uvm_info(get_type_name(), $sformatf("performance_test_en =%0h",performance_test_en), UVM_LOW);
            for(int i=0;i<100;i++)begin//burst 1
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


            for(int j=0;j<100;j++)begin//burst 1
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
            `uvm_info(get_type_name(),"body====boundary_frame_write=======================start==========",UVM_LOW);
            assert(m_frame_cfg.randomize with {
                    cadd                == 0;
                    radd                == 0;
                    frame_rw_flag       == 1;   //1:wr 0:rd
                    one_frame_cnt       == 1;
                    col_addr_rand_en    == 0;
                    wrap_en             == 0;
                });
            `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
            send_one_frame(m_frame_cfg);

            assert(m_frame_cfg.randomize with {
                    cadd                == 0;
                    radd                == 0;
                    frame_rw_flag       == 0;   //1:wr 0:rd
                    one_frame_cnt       == 1;
                    col_addr_rand_en    == 0;
                    wrap_en             == 0;
                });
            `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);    
            send_one_frame(m_frame_cfg);

            assert(m_frame_cfg.randomize with {
                    cadd                == 7'h7f;
                    radd                == 14'd7295;
                    frame_rw_flag       == 1;   //1:wr 0:rd
                    one_frame_cnt       == 1;
                    col_addr_rand_en    == 0;
                    wrap_en             == 0;
                });
            `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
            send_one_frame(m_frame_cfg);

            assert(m_frame_cfg.randomize with {
                    cadd                == 7'h7f;
                    radd                == 14'd7295;
                    frame_rw_flag       == 0;   //1:wr 0:rd
                    one_frame_cnt       == 1;
                    col_addr_rand_en    == 0;
                    wrap_en             == 0;
                });
            `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
            send_one_frame(m_frame_cfg);

            #1us;
            `uvm_info(get_type_name(),"body====boundary_frame_write=======================finish==========",UVM_LOW);
        end
    join

    #1us;

endtask




endclass


`endif
