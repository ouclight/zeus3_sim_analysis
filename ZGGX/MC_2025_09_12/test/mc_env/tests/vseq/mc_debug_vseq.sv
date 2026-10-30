
`ifndef MC_DEBUG_VSEQ
`define MC_DEBUG_VSEQ

class mc_debug_vseq extends mc_common_vseq;
    
    rand bit    [15:0]  one_frame_cnt_i ;
    rand bit    [3:0]   burst_cnt_i     ;
    bit                 frame_rw_flag_i ;
    rand bit    [`COL_ADDR_WIDTH-1:0]   cadd_i          ;
    rand bit    [`ROW_ADDR_WIDTH-1:0]  radd_i          ;
    bit         [5:0]   test_cnt        ;
    bit         [31:0]   read_data=0        ;
    rand bit            enable          ;
    mc_frame_seq_cfg    m_frame_seq_w_q[$];
    mc_frame_seq_cfg    m_frame_seq_r_q[$];
    `uvm_object_utils(mc_debug_vseq)

    function new(string name="mc_debug_vseq");
        super.new(name);
    endfunction

virtual task body();
    super.body();
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
     
    m_tb_if.debug_test_en = 1;
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_debug_en.write(status,1'b1, UVM_FRONTDOOR);
    #100ns;
    test_cnt = 'd1;
    randomize(enable);
    m_frame_agent_if.performance_test_en = enable;

    fork : debug_wrrd
        begin
            for(int j=0;j<test_cnt;j++)begin
                m_frame_seq_w_q.delete();
                m_frame_seq_r_q.delete();        
                randomize(burst_cnt_i) with {burst_cnt_i dist {[0:7]:/20,[8:8]:/80};};
                `uvm_info(get_full_name(),$sformatf("burst_cnt_i = %0d",burst_cnt_i),UVM_LOW);
                m_tb_if.debug_rd_without_wr=1;
                for(int i=0;i<8;i++)begin
                    randomize(cadd_i) with {cadd_i inside{[0:127]};};
                    randomize(radd_i) with {radd_i inside{[0:7295]};};
                    assert(m_frame_cfg.randomize with {
                        cadd                == cadd_i;
                        radd                == radd_i;
                        frame_rw_flag       == 0;   //1:wr 0:rd
                        one_frame_cnt       == 1;
                        strb                == 1;
                    });
                    `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                    send_one_frame(m_frame_cfg);
                end

                #20ns;
                m_tb_if.debug_rd_without_wr=0;
                for(int i=0;i<burst_cnt_i;i++)begin
                    randomize(cadd_i) with {cadd_i inside{[0:127]};};
                    randomize(radd_i) with {radd_i inside{[0:7295]};};
                    assert(m_frame_cfg.randomize with {
                        cadd                == cadd_i;
                        radd                == radd_i;
                        frame_rw_flag       == 1;   //1:wr 0:rd
                        one_frame_cnt       == 1;
                        strb                == 1;
                    });
                    `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                    m_frame_seq_w_q.push_back(m_frame_cfg);
                    send_one_frame(m_frame_cfg);
                    m_frame_cfg = mc_frame_seq_cfg::type_id::create("m_frame_cfg");

                    m_frame_cfg.frame_rw_flag = 0;
                    `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                    m_frame_seq_r_q.push_back(m_frame_cfg);
                    send_one_frame(m_frame_cfg);
                    m_frame_cfg = mc_frame_seq_cfg::type_id::create("m_frame_cfg");
                end
                send_multi_frame(m_frame_seq_w_q);
                send_multi_frame(m_frame_seq_r_q);
            end 
        end
        begin
            while(1)begin
                @(negedge m_array_agent_if.clk);
                if(((|m_array_agent_if.gcas_wr) === 1)||((|m_array_agent_if.gcas_rd) === 1))begin 
                    `uvm_error(get_type_name(),"debug mode,array wr/rd,fail")
                end
            end
        end
    join_any
    disable debug_wrrd;
    
    #1us; 
    `uvm_info(get_type_name(),"body=====apb_write======start===========",UVM_LOW);
    @(posedge m_tb_if.clk);
    m_tb_if.ras_clr=1;
    #20ns; 
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_frame2array_dbg_reg.read(status, read_data, UVM_FRONTDOOR);
    if(read_data[31:16]!=0)begin
        `uvm_error("dbg reg check fail", $sformatf("read is %0d",read_data))
    end
    //function mode
    m_tb_if.debug_test_en = 0;
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_debug_en.write(status,1'b0, UVM_FRONTDOOR);
    #20ns;
    for(int i=0;i<2;i++)begin
        randomize(radd_i) with {radd_i inside{[0:7295]};};
        assert(m_frame_cfg.randomize with {
           cadd                == 0;
           radd                == radd_i;
           frame_rw_flag       == 1;   //1:wr 0:rd
           one_frame_cnt       == 128;
           col_addr_rand_en    == 0;
           wrap_en             == 0;
           strb_rand_en        == 0;
           strb                == 1;
        });
        send_one_frame(m_frame_cfg);
        m_frame_cfg.frame_rw_flag = 0;
        send_one_frame(m_frame_cfg);
    end
    #1us; 
    
endtask
endclass

`endif
