
`ifndef MC_REFRESH_VSEQ
`define MC_REFRESH_VSEQ

class mc_refresh_vseq extends mc_common_vseq;
    
    rand bit    [3:0]   burst_cnt_i     ;
    bit                 frame_rw_flag_i ;
    rand bit    [`COL_ADDR_WIDTH-1:0]   cadd_i          ;
    rand bit    [`ROW_ADDR_WIDTH-1:0]   radd_i          ;
    bit         [5:0]   test_cnt        ;
    rand bit    [31:0]  period          ;
    rand bit    [31:0]  start_time      ;
    rand bit            case_seed       ;
    rand bit            rw_flag         ;
    randc bit   [`ROW_ADDR_WIDTH-1:0]   row             ;
    randc bit   [`COL_ADDR_WIDTH-1:0]   col             ;
    bit         [12:0]  end_addr = 13'h1cbf     ;
    rand bit [2:0]                  mb_gear_id      ;
    rand bit [31:0]                 delay_time;
    mc_frame_seq_cfg    m_frame_seq_w_q[$];
    mc_frame_seq_cfg    m_frame_seq_r_q[$];
    `uvm_object_utils(mc_refresh_vseq)
    constraint row_c {row inside {[0:7295]};}
    constraint c_gear_id{
        mb_gear_id dist {0:/10, 1:/10, 2:/10, 3:/10, 4:/60};
    }
    constraint c_delay_time{
        delay_time inside {[3:65535]};
    }
    function new(string name="mc_refresh_vseq");
        super.new(name);
    endfunction
    

virtual task body();
    super.body();
    `ifndef NO_INIT
        wait(m_tb_if.mc_dram_init_wr_finish==1);
    `endif
    randomize(period,start_time,case_seed,mb_gear_id);
    m_frame_agent_if.performance_test_en = 1;
    wait(m_tb_if.fsm == 0);
    `ifdef SPEEDUP
        m_tb_if.rf_start_time       = 100;
        m_tb_if.rf_single_interval  =   32'h1_4000;
        m_tb_if.rf_gear_id          = mb_gear_id;
        m_tb_if.rf_gear_up_en       = 1'b1;
        @(posedge m_tb_if.clk);
        m_tb_if.rf_gear_up_en       = 1'b0;
        @(posedge m_tb_if.clk);
        m_tb_if.rf_range_change_en  = 1'b1;
        end_addr                = 13'h100;
        m_tb_if.rf_addr         = {13'h0, end_addr};
        uvm_hdl_force("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.dram_init_wr_aux_u.row_end_addr[12:0]", 13'h001f);
    `endif
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    //----------------------cfg refresh interface------------------------//
    if(case_seed==1)begin
        fork 
            begin
                fork
                    begin
                        #1us;
                        repeat(delay_time) @(posedge m_tb_if.clk);
                        @(posedge m_tb_if.pclk);
                        m_tb_if.pre_precharge = 1;
                        m_tb_if.mc_rf_start_sel=0;
                        period=32'h30d4000;
                        `ifdef SPEEDUP
                            period=32'h4_0000;
                        `endif
                        `uvm_info(get_full_name(),$sformatf("period = %0h,start_time = %0h",period,start_time),UVM_LOW);
                        m_tb_if.mc_rf_period_sel=0;//0:interface, 1:mc_local
                        @(posedge m_tb_if.clk);
                        m_tb_if.rf_single_interval  = period;
                        m_tb_if.rf_gear_id          = mb_gear_id;
                        m_tb_if.rf_gear_up_en       = 1'b1;
                        @(posedge m_tb_if.clk);
                        m_tb_if.rf_gear_up_en       = 1'b0;
                        @(posedge m_tb_if.clk);
                    end
                    begin
                        #1us;
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
                        
                        for(int i=0;i<100;i++)begin
                            assert(m_frame_cfg.randomize with {
                                cadd                == 0;
                                radd                == i;
                                frame_rw_flag       == 1;   //1:wr 0:rd
                                one_frame_cnt       == 'd128;
                                col_addr_rand_en    == 0;
                                wrap_en             == 0;
                                rw_rand_en          == 0;
                            });
                            send_one_frame(m_frame_cfg);        
                        end

                        `uvm_info(get_type_name(),"body=====apb_write======start===========",UVM_LOW);
                        #1us;
                        `ifdef SPEEDUP
                        uvm_hdl_deposit("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.frame2array_u.rf_cnt", 32'h4_0000- 32'h5);
                        `else
                        uvm_hdl_deposit("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.frame2array_u.rf_cnt", 32'h30d4000- 32'h5);
                        `endif
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
                            if(m_tb_if.gradd_n != end_addr)begin
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
                    rw_rand_en          == 0;
                });
                send_one_frame(m_frame_cfg);        
                #1us;            
                
                m_tb_if.mc_rf_start_sel=0;
                start_time=10;
                period=32'h30d4000;
                `ifdef SPEEDUP
                    period=32'h4_0000;
                `endif
                `uvm_info(get_full_name(),$sformatf("period = %0h,start_time = %0h",period,start_time),UVM_LOW);
                m_tb_if.mc_rf_period_sel=0;//0:interface, 1:mc_local
                @(posedge m_tb_if.clk);
                m_tb_if.mc_rf_start=1;
               
                wait(m_tb_if.gradd_n == end_addr);
                assert(randomize(rw_flag,row,col));
                assert(m_frame_cfg.randomize with {
                    cadd                == col;
                    radd                == row;
                    frame_rw_flag       == rw_flag;   //1:wr 0:rd
                    one_frame_cnt       == 'd1;
                    col_addr_rand_en    == 0;
                    wrap_en             == 0;
                    rw_rand_en          == 0;
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
            for(int i=0;i<100;i++)begin
                randomize(cadd_i) with {cadd_i inside{[0:127]};};
                randomize(radd_i) with {radd_i inside{[0:7295]};};
                assert(m_frame_cfg.randomize with {
                 cadd                == cadd_i;
                 radd                == radd_i;
                 frame_rw_flag       == 0;   //1:wr 0:rd
                 one_frame_cnt       == 1;
                rw_rand_en          == 0;
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
            `ifdef SPEEDUP
                period=32'h4_0000;
            `endif
            `uvm_info(get_full_name(),$sformatf("period = %0h,start_time = %0h",period,start_time),UVM_LOW);
            m_tb_if.mc_rf_period_sel=0;//0:interface, 1:mc_local
                    @(posedge m_tb_if.clk);
                    m_tb_if.rf_single_interval  = period;
                    m_tb_if.rf_gear_id          = mb_gear_id;
                    m_tb_if.rf_gear_up_en       = 1'b1;
                    @(posedge m_tb_if.clk);
                    m_tb_if.rf_gear_up_en       = 1'b0;
                    @(posedge m_tb_if.clk);
            repeat(1000) @(posedge m_tb_if.clk);
            #1ps;
            //uvm_hdl_deposit("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.frame2array_u.rf_cnt", 32'h30d4000 - 33);
            //wait(m_tb_if.rf_cnt==0);
        end
    join
endtask


endclass


`endif
