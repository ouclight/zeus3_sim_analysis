//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_refresh_vseq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 28 15:01:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_REFRESH_VSEQ
`define MC_REFRESH_VSEQ

class mc_refresh_vseq extends mc_common_vseq;
    
    rand bit    [3:0]   burst_cnt_i     ;
    bit                 frame_rw_flag_i ;
    rand bit    [`COL_ADDR_WIDTH-1:0]   cadd_i          ;
    rand bit    [`ROW_ADDR_WIDTH-1:0]  radd_i          ;
    bit         [5:0]   test_cnt        ;
    rand bit    [31:0]  period          ;
    rand bit    [31:0]  start_time      ;
    rand bit            rfwr_seed       ;
    rand bit            case_seed       ;
    rand bit            rw_flag         ;
    randc bit   [`ROW_ADDR_WIDTH-1:0]  row             ;
    randc bit   [`COL_ADDR_WIDTH-1:0]   col             ;
    mc_frame_seq_cfg    m_frame_seq_w_q[$];
    mc_frame_seq_cfg    m_frame_seq_r_q[$];
    `uvm_object_utils(mc_refresh_vseq)
    constraint row_c {row inside {[0:7295]};}
    function new(string name="mc_refresh_vseq");
        super.new(name);
    endfunction
    

virtual task body();
    super.body();
    randomize(period,start_time,case_seed,rfwr_seed);
    m_frame_agent_if.performance_test_en = 1;
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    //----------------------cfg refresh interface------------------------//
    if(case_seed==1)begin
        fork 
            begin
                fork
                    begin
                        if(rfwr_seed==1)begin
                            #1us;
                        end
                        @(posedge m_tb_if.pclk);
                        m_tb_if.pre_precharge = 1;
                        m_tb_if.mc_rf_start_sel=0;
                        start_time=0;
                        period=32'h30d4000;
                        `uvm_info(get_full_name(),$sformatf("period = %0h,start_time = %0h",period,start_time),UVM_LOW);
                        m_tb_if.mc_rf_period_sel=0;//0:interface, 1:mc_local
                        @(posedge m_tb_if.clk);
                        m_tb_if.mc_rf_start=1;
                    end
                    begin
                        if(rfwr_seed==0)begin
                            #1us;
                        end
                        test_cnt = 'd1;
                        for(int j=0;j<test_cnt;j++)begin
                            m_frame_seq_w_q.delete();
                            m_frame_seq_r_q.delete();        
                            randomize(burst_cnt_i);
                            `uvm_info(get_full_name(),$sformatf("burst_cnt_i = %0d",burst_cnt_i),UVM_LOW);
                            
                            for(int i=0;i<burst_cnt_i;i++)begin
                                randomize(cadd_i) with {cadd_i inside{[0:127]};};
                                randomize(radd_i) with {radd_i inside{[0:7295]};};
                                assert(m_frame_cfg.randomize with {
                                    cadd                == cadd_i;
                                    radd                == radd_i;
                                    frame_rw_flag       == 1;   //1:wr 0:rd
                                    one_frame_cnt       == 1;
                                });
                                `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                                m_frame_seq_w_q.push_back(m_frame_cfg);
                                m_frame_cfg = mc_frame_seq_cfg::type_id::create("m_frame_cfg");

                                assert(m_frame_cfg.randomize with {
                                    cadd                == cadd_i;
                                    radd                == radd_i;
                                    frame_rw_flag       == 0;   //1:wr 0:rd
                                    one_frame_cnt       == 1;
                                });
                                `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                                m_frame_seq_r_q.push_back(m_frame_cfg);
                                m_frame_cfg = mc_frame_seq_cfg::type_id::create("m_frame_cfg");
                            end
                            send_multi_frame(m_frame_seq_w_q);
                            send_multi_frame(m_frame_seq_r_q);
                        end        
                        
                        for(int i=0;i<'d1000;i++)begin
                            assert(m_frame_cfg.randomize with {
                                cadd                == 0;
                                radd                == i;
                                frame_rw_flag       == 1;   //1:wr 0:rd
                                one_frame_cnt       == 'd128;
                                col_addr_rand_en    == 0;
                                wrap_en             == 0;
                            });
                            send_one_frame(m_frame_cfg);        
                        end

                        `uvm_info(get_type_name(),"body=====apb_write======start===========",UVM_LOW);
                        #1us;
                        uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", 32'h30d4000- 32'h5);
                        #1us;
                    end
                join
            end
            begin
                while(1)begin//start_time check
                    wait(m_tb_if.mc_rf_start);
                    @(posedge m_tb_if.clk);
                    if(m_tb_if.rf_cnt==start_time)begin
                        `uvm_info(get_type_name(),"rf_cnt==start_time",UVM_LOW);
                        @(posedge m_tb_if.clk);
                        if(m_tb_if.rf_request != 1)begin
                            `uvm_error(get_full_name(), $sformatf("tf_cnt!==start_time, but rf_request is %0d",m_tb_if.rf_request))
                        end
                    end
                end
            end
            begin
                while(1)begin//rf start check
                    @(posedge m_tb_if.clk);
                    if(m_tb_if.rf_request == 1 && m_tb_if.fsm == 5'b0)begin
                        @(posedge m_tb_if.clk);
                        if(m_tb_if.fsm!= 5'b1 && m_tb_if.rf_request != 1)begin
                            `uvm_error(get_full_name(), $sformatf("rf not start, fsm is %0d, rf_request is %0d",m_tb_if.fsm,m_tb_if.rf_request))
                        end
                    end
                end
            end
            begin
                while(1)begin//period check
                    @(posedge m_tb_if.clk);
                    if(m_tb_if.rf_cnt==period)begin
                        `uvm_info(get_type_name(),"rf_cnt==period",UVM_LOW);
                        @(posedge m_tb_if.clk);
                        if(m_tb_if.rf_cnt != 0)begin
                            `uvm_error(get_full_name(), $sformatf("tf_cnt!==period, but rf_cnt is %0h",m_tb_if.rf_cnt))
                        end
                    end
                end
            end
            begin
                while(1)begin//end addr check
                    @(posedge m_tb_if.clk);
                    if(m_tb_if.fsm==5'b110)begin
                        @(posedge m_tb_if.clk);
                        if(m_tb_if.fsm == 0)begin
                            `uvm_info(get_type_name(),"last addr",UVM_LOW);
                            if(m_tb_if.gradd_n != 13'h1cbf)begin
                            //if(m_tb_if.gradd_n != 14'h3000)begin
                                `uvm_error(get_full_name(), $sformatf("end addr failed, now is %0h",m_tb_if.gradd_n))
                            end
                        end
                    end
                end
            end
            begin
                while(1)begin//start addr check
                    @(posedge m_tb_if.clk);
                    if(m_tb_if.rf_request == 1 && m_tb_if.fsm == 5'b0)begin
                        @(posedge m_tb_if.clk);
                        if(m_tb_if.gradd_n!= 14'b0)begin
                        //if(m_tb_if.gradd_n!= 14'b1)begin
                            `uvm_error(get_full_name(), $sformatf("start addr failed, now is %0h",m_tb_if.gradd_n))
                        end
                    end
                end
            end

        join_any
    end
    else begin
        m_tb_if.pre_precharge = 1;
        #1us;            
        fork 
            begin
                assert(randomize(rw_flag,row,col));
                assert(m_frame_cfg.randomize with {
                    cadd                == col;
                    radd                == row;
                    frame_rw_flag       == rw_flag;   //1:wr 0:rd
                    one_frame_cnt       == 'd1;
                    col_addr_rand_en    == 0;
                    wrap_en             == 0;

                });
                send_one_frame(m_frame_cfg);        
                #1us;            
                
                m_tb_if.mc_rf_start_sel=0;
                start_time=0;
                period=32'h30d4000;
                `uvm_info(get_full_name(),$sformatf("period = %0h,start_time = %0h",period,start_time),UVM_LOW);
                m_tb_if.mc_rf_period_sel=0;//0:interface, 1:mc_local
                @(posedge m_tb_if.clk);
                m_tb_if.mc_rf_start=1;
               
                wait(m_tb_if.gradd_n == 13'h1cbf);
                assert(randomize(rw_flag,row,col));
                assert(m_frame_cfg.randomize with {
                    cadd                == col;
                    radd                == row;
                    frame_rw_flag       == rw_flag;   //1:wr 0:rd
                    one_frame_cnt       == 'd1;
                    col_addr_rand_en    == 0;
                    wrap_en             == 0;

                });
                send_one_frame(m_frame_cfg);        
                #1us;   
            end
        join
    end
    #1us;
    //request and valid is 1
    fork
        begin
            @(posedge m_tb_if.clk);
            for(int i=0;i<1000;i++)begin
                randomize(cadd_i) with {cadd_i inside{[0:127]};};
                randomize(radd_i) with {radd_i inside{[0:7295]};};
                assert(m_frame_cfg.randomize with {
                 cadd                == cadd_i;
                 radd                == radd_i;
                 frame_rw_flag       == 0;   //1:wr 0:rd
                 one_frame_cnt       == 1;
                });
                send_one_frame(m_frame_cfg);        
            end
            repeat(1000) @(posedge m_tb_if.clk);
        end
        begin
            @(posedge m_tb_if.pclk);
            m_tb_if.mc_rf_start_sel=0;
            start_time=32'h300;
            period=32'h30d4000;
            `uvm_info(get_full_name(),$sformatf("period = %0h,start_time = %0h",period,start_time),UVM_LOW);
            m_tb_if.mc_rf_period_sel=0;//0:interface, 1:mc_local
            @(posedge m_tb_if.clk);
            m_tb_if.mc_rf_start=1;
            repeat(1000) @(posedge m_tb_if.clk);
            #1ps;
            //uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", 32'h30d4000 - 33);
            //wait(m_tb_if.rf_cnt==0);
        end
    join
endtask


endclass


`endif
