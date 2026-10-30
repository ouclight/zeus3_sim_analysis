`ifndef MC_REFRESH_LOCAL_VSEQ
`define MC_REFRESH_LOCAL_VSEQ

class mc_refresh_local_vseq extends mc_common_vseq;

    `uvm_object_utils(mc_refresh_local_vseq)

    function new(string name = "mc_refresh_local_vseq");
        super.new(name);
    endfunction

    localparam                  RADDR_NUM=7360;
    localparam                  BURST_WIDTH=128;

    //refresh param
    rand bit                        global_rf_sel_en;       //0:interface, 1:reg
    rand bit                        global_rf_sel;          //0:cfg1; 1:cfg2
    rand bit                        mc_rf_cfg_sel;          //0:cfg1; 1:cfg2

    rand bit [`ROW_ADDR_WIDTH-1:0]  rf_start_addr;
    rand bit [`ROW_ADDR_WIDTH-1:0]  rf_end_addr;

    rand bit [31:0]                 period;    
    rand bit [31:0]                 rf_start_time;
    rand bit [31:0]                 delay_time;
    
    //frame cfg
    rand bit            frame_rw_flag   ;
    rand bit            wrap_en         ;
    rand bit            col_addr_rand_en;
    rand bit [15:0]     one_frame_cnt   ;
    rand bit [`COL_ADDR_WIDTH-1:0]      cadd            ;
    rand bit [`ROW_ADDR_WIDTH-1:0]      radd            ;

    rand bit            wr_rd_mode;

    //page param
    rand bit            pre_precharge_en;
    rand bit            page_mode;

    //check param
    rand bit [1:0]      change_rf_param_during_rf ;   // flag for during rf, change refresh param; [0]:period; [1]:rf_start_time
    rand bit            refresh_during_wr;   //mc refresh during wr_rd
    rand bit            wait_rf_cnt;        //wait rf_cnt
    rand int            loop_times;
    rand int            case_index;
    rand bit            performance_test_en;

    rand bit            period_start_time_check;

    //------------- constraint frame cfg -----------------
    constraint c_radd { 
        radd    inside {[0:RADDR_NUM-64-1]};
    }

    constraint c_one_frame_cnt { 
        solve wrap_en before one_frame_cnt;
        if(wrap_en == 1){one_frame_cnt inside {[BURST_WIDTH:BURST_WIDTH]};}
        else 
            one_frame_cnt dist {[1:BURST_WIDTH]:/50,1:/50};
    }

    constraint c_cadd { 
        solve wrap_en before cadd;
        solve col_addr_rand_en before cadd;
        solve one_frame_cnt before cadd;
        if(col_addr_rand_en == 0 &&  wrap_en==0)
            cadd inside {[0:BURST_WIDTH-one_frame_cnt]};        
    }

    //constraint c_wrap_en{
    //    wrap_en dist {0:=60,1:=40};     
    //}

    //constraint c_col_addr_rand_en{
    //    col_addr_rand_en dist {0:=60,1:=40};
    //}

    //constraint c_num_frame_send{
    //    num_frame_send inside {[1:100]};
    //}

    //------------- constraint refresh param -------------
    constraint c_rf_statr_addr{
        rf_start_addr inside {[0:RADDR_NUM-2]};
    }

    constraint c_rf_end_addr{
        solve rf_start_addr before rf_end_addr;
        rf_end_addr inside {[1:RADDR_NUM-1]};
        rf_end_addr > rf_start_addr;
    }

    constraint c_delay_time{
        delay_time inside {[3:20]};
    }

    //64ms:32'h30d4000, 32ms:32'h186a000, 16ms:32'hc35000, 8ms:32'h61a800, 4ms:32'h30d400; 1ms:32'hc3500
    constraint c_period{
        period dist {'h30d4000:=20, 'h186a000:=20, 'hc35000:=20, 'h61a800:=20, 'h30d400:=20, 'hc3500:=20};
    }
    
    constraint c_rf_start_time{
        solve period before rf_start_time;
        rf_start_time < period;
    }

    //------------- constraint check param ---------------

    constraint c_wait_rf_cnt{
        wait_rf_cnt dist {0:=80, 1:=20};
    }

    constraint c_loop_times{
        loop_times inside {[2:5]};
    }

    constraint c_case_index{
        case_index inside {[1:4]};
    }

    extern virtual task body();
    extern task rf_addr_check(bit [`ROW_ADDR_WIDTH-1:0] start_addr, bit [`ROW_ADDR_WIDTH-1:0] end_addr);
    extern task rf_period_start_time_set(input bit [31:0] now_period, input bit [31:0] now_start_time);
    extern task period_check(input bit [31:0] rf_period_inner);
    extern task rf_start_time_check(input bit [31:0] rf_start_time_inner);
    extern task modify_rf_cnt(bit [31:0] rf_cnt_inner, bit [31:0] current_period_inner, bit [31:0] current_start_time_inner);

endclass:mc_refresh_local_vseq

task mc_refresh_local_vseq::body();

    bit [31:0]                  current_period;
    bit [31:0]                  current_start_time;
    bit [31:0]                  current_rf_cnt;
    bit [`ROW_ADDR_WIDTH-1:0]   current_start_addr;
    bit [`ROW_ADDR_WIDTH-1:0]   current_end_addr;

    bit [1:0]                   refresh_mode_after_change;  //00: period >= current_period   &&  rf_start_time >= current_rf_cnt
                                                            //01: period < current_period    &&  rf_start_time >= current_rf_cnt
                                                            //10: period >= current_period   &&  rf_start_time <  current_rf_cnt
                                                            //11: period < current_period    &&  rf_start_time <  current_rf_cnt
    event                       addr_2nd_check;
    event                       get_refresh;

    super.body();

    assert(randomize()with{
        wait_rf_cnt == 0;
        //case_index  ==  3;
        //performance_test_en == 1;
    });

    `uvm_info(get_type_name(),$sformatf("wait_rf_cnt is %0b, loop_times is %0d",wait_rf_cnt, loop_times),UVM_LOW)
    @(posedge m_tb_if.clk);
    //param display
    `uvm_info(get_type_name(),$sformatf("global_rf_sel_en is %0d, global_rf_sel is %0d, mc_rf_start_sel is %0d, period is %0h, rf_start_time is %0h", global_rf_sel_en, global_rf_sel, mc_rf_cfg_sel, period, rf_start_time),UVM_LOW)
    #1ps;

    //rand dbg_data_store_en
    @(posedge m_tb_if.clk);
    m_tb_if.dbg_data_store_en=$urandom_range(1);
    `uvm_info(get_type_name(), $sformatf("dbg_data_store_en is %0b",m_tb_if.dbg_data_store_en),UVM_LOW)

    //page mode
    `uvm_info("page mode switch", $sformatf("initial page_mode_switch to %s", page_mode? "close page": "open page"), UVM_LOW)
    @(posedge m_tb_if.pclk);
    m_tb_if.page_mode_switch = page_mode;

    //pre_precharge_en
    @(posedge m_tb_if.pclk);
    @(posedge m_tb_if.pclk);
    m_tb_if.pre_precharge = pre_precharge_en;
    `uvm_info("open page", $sformatf("pre_precharge_en is %0b",pre_precharge_en),UVM_LOW)


    //param cfg
    m_frame_agent_if.performance_test_en =   performance_test_en;
    @(posedge m_tb_if.pclk);
    m_tb_if.mc_rf_start_sel = 1;    //0:interface, 1:reg
    m_tb_if.mc_rf_period_sel = 1;    //0:interface, 1:reg

    //rf_addr = {rf_start_addr, rf_end_addr};

    //-------------------------- global_rf_sel && mc_local_rf_sel -----------------------------------------
    @(posedge m_tb_if.pclk);
    m_tb_if.global_rf_sel_en = global_rf_sel_en;
    @(posedge m_tb_if.clk);
    m_tb_if.global_rf_sel    = global_rf_sel;

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_rf_cfg_sel.write(status, mc_rf_cfg_sel, UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_period_cfg1_reg.write(status, period, UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_start_cfg1_reg.write(status, rf_start_time, UVM_FRONTDOOR);

    if (global_rf_sel_en) begin
        if (!global_rf_sel) begin
            current_period      =   period;
            current_start_time  =   rf_start_time;
        end
    end
    else begin
        if (!mc_rf_cfg_sel) begin
            current_period      =   period;
            current_start_time  =   rf_start_time;
        end
    end

    assert(randomize(period, rf_start_time));
    `uvm_info(get_type_name(),$sformatf("for cfg2, period is %0h, rf_start_time is %0h",period, rf_start_time),UVM_LOW)
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_period_cfg2_reg.write(status, period, UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_start_cfg2_reg.write(status, rf_start_time, UVM_FRONTDOOR);

    if (global_rf_sel_en) begin
        if (global_rf_sel) begin
            current_period      =   period;
            current_start_time  =   rf_start_time;
        end
    end
    else begin
        if (mc_rf_cfg_sel) begin
            current_period      =   period;
            current_start_time  =   rf_start_time;
        end
    end


    #100ns;

    //start refresh
    @(posedge m_tb_if.clk);
    m_tb_if.mc_rf_start = 1'b1;

    case (case_index)
        1:  $display("---------------------------------------- case is wr_rd and refresh --------------------------");
        2:  $display("---------------------------------------- case is change addr and refresh ----------------------");
        3:  $display("---------------------------------------- case is change period and start time --------------------");
        4:  $display("---------------------------------------- case is change page -------------------------------");
        default:    `uvm_error(get_type_name(),"no case for this case_index!")
    endcase
 
    //------------------------ normal refresh && wr_rd during refresh -------------------------
    if (case_index == 1) begin
        for (int i=0;i<loop_times;i++) begin
            `uvm_info(get_type_name(),$sformatf("\n------------------------- below is @%0d------------------------",i),UVM_LOW)

            //-------------- wr_rd -------------
            `uvm_info(get_type_name(),"\n------------------------- below is wr_rd, refresh, wr_rd ------------------------",UVM_LOW)
            assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd, one_frame_cnt, wr_rd_mode));
            if (wr_rd_mode) begin
                for (int jj=0;jj<one_frame_cnt;jj++) begin
                    assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd));
                    assert(m_frame_cfg.randomize()with{
                        m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                        m_frame_cfg.wrap_en             ==  0;
                        m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                        m_frame_cfg.one_frame_cnt       ==  1;
                        m_frame_cfg.radd                ==  local::radd;
                        m_frame_cfg.cadd                ==  local::cadd;
                    });
                    `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);

                    send_one_frame(m_frame_cfg);
                end
            end
            else begin
    
                assert(m_frame_cfg.randomize()with{
                    m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                    m_frame_cfg.wrap_en             ==  local::wrap_en;
                    m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                    m_frame_cfg.one_frame_cnt       ==  local::one_frame_cnt;
                    m_frame_cfg.radd                ==  local::radd;
                    m_frame_cfg.cadd                ==  local::cadd;
                });
                `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
    
                send_one_frame(m_frame_cfg);
            end

            repeat(1000) @(posedge m_tb_if.clk);

            //------------- refresh ----------------
            #1ps;
            `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
            uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_start_time - $urandom_range(10));
            rf_start_time_check(current_start_time);

            `uvm_info(get_type_name(),"wait refresh !!!!", UVM_LOW)
            while(1)begin
                if(m_tb_if.fsm == 0)
                    break;
                @(posedge m_tb_if.clk);
            end
            `uvm_info(get_type_name(),"refresh done!!!!", UVM_LOW)

            //------------ wr_rd ----------------
            assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd, one_frame_cnt, wr_rd_mode));
            if (wr_rd_mode) begin
                for (int jj=0;jj<one_frame_cnt;jj++) begin
                    assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd));
                    assert(m_frame_cfg.randomize()with{
                        m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                        m_frame_cfg.wrap_en             ==  0;
                        m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                        m_frame_cfg.one_frame_cnt       ==  1;
                        m_frame_cfg.radd                ==  local::radd;
                        m_frame_cfg.cadd                ==  local::cadd;
                    });
                    `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);

                    send_one_frame(m_frame_cfg);
                end
            end
            else begin
    
                assert(m_frame_cfg.randomize()with{
                    m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                    m_frame_cfg.wrap_en             ==  local::wrap_en;
                    m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                    m_frame_cfg.one_frame_cnt       ==  local::one_frame_cnt;
                    m_frame_cfg.radd                ==  local::radd;
                    m_frame_cfg.cadd                ==  local::cadd;
                });
                `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
    
                send_one_frame(m_frame_cfg);
            end

            `uvm_info(get_type_name(),"\n------------------------- below is wr_rd during refresh ------------------------",UVM_LOW)
            fork
                begin
                    //refresh
                    //if (!wait_rf_cnt) begin
                    //    if (current_start_time > 1000000) begin
                            repeat($urandom_range(10)) @(posedge m_tb_if.clk);
                            #1ps;
                            `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
                            uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_start_time - $urandom_range(10));
                    //    end
                    //end
                end

                begin
                    //rf_addr_check
                    rf_addr_check('h0,RADDR_NUM-1);
                end

                begin
                    //during refresh, wr_rd
                    do begin
                        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt);
                        @(posedge m_tb_if.clk);
                    end while(current_rf_cnt < current_start_time);
                    repeat ($urandom_range(10)) @(posedge m_tb_if.clk);

                    assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd, one_frame_cnt, wr_rd_mode));
                    if (wr_rd_mode) begin
                        for (int jj=0;jj<one_frame_cnt;jj++) begin
                            assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd));
                            assert(m_frame_cfg.randomize()with{
                                m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                                m_frame_cfg.wrap_en             ==  0;
                                m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                                m_frame_cfg.one_frame_cnt       ==  1;
                                m_frame_cfg.radd                ==  local::radd;
                                m_frame_cfg.cadd                ==  local::cadd;
                            });
                            `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);

                            send_one_frame(m_frame_cfg);
                        end
                    end
                    else begin
    
                        assert(m_frame_cfg.randomize()with{
                            m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                            m_frame_cfg.wrap_en             ==  local::wrap_en;
                            m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                            m_frame_cfg.one_frame_cnt       ==  local::one_frame_cnt;
                            m_frame_cfg.radd                ==  local::radd;
                            m_frame_cfg.cadd                ==  local::cadd;
                        });
                        `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
    
                        send_one_frame(m_frame_cfg);
                    end

                end

            join


            //------------------------ normal refresh && refresh during wr_rd -------------------------
            `uvm_info(get_type_name(),"\n------------------------- below is refresh during wr_rd ------------------------",UVM_LOW)
            assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd, one_frame_cnt, wr_rd_mode )with{one_frame_cnt > 10;});
            fork
                begin
                    //refresh
                    //for (int i=0;i<(one_frame_cnt/2);i++) begin
                        wait(m_frame_agent_if.mc_frame_vld && m_frame_agent_if.mc_frame_rdy);
                        //@(posedge m_tb_if.clk);
                    //end

                    //if (!wait_rf_cnt) begin
                    //    if (current_start_time > 1000000) begin
                            //repeat($urandom_range(20,30)) @(posedge m_tb_if.clk);
                            repeat($urandom_range(0,30)) @(posedge m_tb_if.clk);
                            #1ps;
                            `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
                            uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_start_time - $urandom_range(5));
                    //    end
                    //end
 
                end

                begin
                    //rf_addr_check
                    rf_addr_check('h0,RADDR_NUM-1);
                end

                begin
                    if (wr_rd_mode) begin
                        for (int jj=0;jj<one_frame_cnt;jj++) begin
                            assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd));
                            assert(m_frame_cfg.randomize()with{
                                m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                                m_frame_cfg.wrap_en             ==  0;
                                m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                                m_frame_cfg.one_frame_cnt       ==  1;
                                m_frame_cfg.radd                ==  local::radd;
                                m_frame_cfg.cadd                ==  local::cadd;
                            });
                            `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);

                            send_one_frame(m_frame_cfg);
                        end
                    end
                    else begin
    
                        assert(m_frame_cfg.randomize()with{
                            m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                            m_frame_cfg.wrap_en             ==  local::wrap_en;
                            m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                            m_frame_cfg.one_frame_cnt       ==  local::one_frame_cnt;
                            m_frame_cfg.radd                ==  local::radd;
                            m_frame_cfg.cadd                ==  local::cadd;
                        });
                        `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
    
                        send_one_frame(m_frame_cfg);
                    end
                end

            join

        end
    end
    //--------------------------------- change addr during refresh or not refresh -------------------------------

    if (case_index == 2) begin
        `uvm_info(get_type_name(),"\n------------------------- below is change addr && refresh ------------------------",UVM_LOW)
        @(posedge m_tb_if.pclk);
        m_tb_if.rf_range_change_en = 1;

        for (int i=0;i<loop_times;i++) begin
            `uvm_info(get_type_name(),$sformatf("\n------------------------- below is @%0d------------------------",i),UVM_LOW)
            assert(randomize(rf_start_addr,rf_end_addr));
            `uvm_info(get_type_name(),$sformatf("rf_start_addr is %0h, rf_end_addr is %0h",rf_start_addr,rf_end_addr),UVM_LOW)
            current_start_addr  =   rf_start_addr;
            current_end_addr    =   rf_end_addr;
            m_tb_if.rf_addr =  {rf_start_addr,rf_end_addr}; 

            assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd, one_frame_cnt, wr_rd_mode )with{one_frame_cnt > 10;});
            fork
                begin
                    if (refresh_during_wr) begin
                        //refresh
                        for (int i=0;i<(one_frame_cnt/2);i++) begin
                            wait(m_frame_agent_if.mc_frame_vld && m_frame_agent_if.mc_frame_rdy);
                            @(posedge m_tb_if.clk);
                        end
                    end

                    if (!wait_rf_cnt) begin
                            repeat(10) @(posedge m_tb_if.clk);
                            #1ps;
                            `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
                            uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_start_time - $urandom_range(10));
                    end
 
                end

                begin
                    //rf_addr_check
                    rf_addr_check(current_start_addr,current_end_addr);
                    `uvm_info(get_type_name(),"first check done",UVM_LOW)
                    -> addr_2nd_check;
                    if (!wait_rf_cnt) begin
                            repeat(10) @(posedge m_tb_if.clk);
                            #1ps;
                            `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
                            uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_start_time - $urandom_range(10));
                    end
 
                end

                begin

                    if(!refresh_during_wr) begin
                        //during refresh, wr_rd
                        do begin
                            uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt);
                            @(posedge m_tb_if.clk);
                        end while(current_rf_cnt !== current_start_time);
                        repeat (50) @(posedge m_tb_if.clk);
                    end
                    if (wr_rd_mode) begin
                        for (int jj=0;jj<one_frame_cnt;jj++) begin
                            assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd));
                            assert(m_frame_cfg.randomize()with{
                                m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                                m_frame_cfg.wrap_en             ==  0;
                                m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                                m_frame_cfg.one_frame_cnt       ==  1;
                                m_frame_cfg.radd                ==  local::radd;
                                m_frame_cfg.cadd                ==  local::cadd;
                            });
                            `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);

                            send_one_frame(m_frame_cfg);
                        end
                    end
                    else begin
    
                        assert(m_frame_cfg.randomize()with{
                            m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                            m_frame_cfg.wrap_en             ==  local::wrap_en;
                            m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                            m_frame_cfg.one_frame_cnt       ==  local::one_frame_cnt;
                            m_frame_cfg.radd                ==  local::radd;
                            m_frame_cfg.cadd                ==  local::cadd;
                        });
                        `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
    
                        send_one_frame(m_frame_cfg);
                    end

                end

                begin
                    //during refresh, change addr
                    do begin
                        @(posedge m_tb_if.clk);
                        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt);
                    end while(current_rf_cnt !== current_start_time );
                    @(negedge m_tb_if.rf_request);
 
                    repeat($urandom_range(10)) @(posedge m_tb_if.clk);
                    assert(randomize(rf_start_addr,rf_end_addr));
                    `uvm_info(get_type_name(),$sformatf("rf_start_addr is %0h, rf_end_addr is %0h",rf_start_addr,rf_end_addr),UVM_LOW)
                    m_tb_if.rf_addr =  {rf_start_addr,rf_end_addr}; 
                    current_start_addr  =   rf_start_addr;
                    current_end_addr    =   rf_end_addr;
                    @(addr_2nd_check);
                    rf_addr_check(current_start_addr,current_end_addr);
                end
 

            join

        end
    end

    //------------------------------------ change period and start time ----------------------------------

    if (case_index == 3) begin
        //m_tb_if.rf_range_change_en = 1;
        `uvm_info(get_type_name(),"\n------------------------- below is change period and start time && refresh ------------------------",UVM_LOW)
        for(int i=0;i<loop_times;i++) begin

            assert(randomize(period_start_time_check, change_rf_param_during_rf));
            `uvm_info(get_type_name(),$sformatf("\n------------------------- below is @%0d------------------------",i),UVM_LOW)
            //assert(randomize(period,rf_start_time));
            //`uvm_info(get_type_name(),$sformatf("period is %0h, rf_start_time is %0h",period,rf_start_time),UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("current_period is %0h, current_start_time is %0h",current_period,current_start_time),UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("change_rf_param_during_rf is %0b, refresh_during_wr is %0b, wait_rf_cnt is %0b",change_rf_param_during_rf, refresh_during_wr, wait_rf_cnt),UVM_LOW)

            assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd, one_frame_cnt, wr_rd_mode )with{one_frame_cnt > 10;});
            fork
                begin
                    if (refresh_during_wr) begin
                        //refresh
                        for (int i=0;i<(one_frame_cnt/2);i++) begin
                            wait(m_frame_agent_if.mc_frame_vld && m_frame_agent_if.mc_frame_rdy);
                            @(posedge m_tb_if.clk);
                        end
                    end

                    //if (!wait_rf_cnt) begin
                    //    repeat(10) @(posedge m_tb_if.clk);
                    //    #1ps;
                    //    `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
                    //    uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_start_time - 10);
                    //    //modify_rf_cnt(current_rf_cnt, current_period, current_start_time);
                    //end

                    //if (i != 0 && change_rf_param_during_rf == 0) begin   //change rf param when not in rf fsm
                    //    repeat(240000) @(posedge m_tb_if.clk);
                    //    repeat(10) @(posedge m_tb_if.clk);
                    //    #1ps;
                    //end

                    @(posedge m_tb_if.clk);
                    #1ps;
                    if (period_start_time_check) begin
                        `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
                        modify_rf_cnt(current_rf_cnt, current_period, current_start_time);
                        rf_start_time_check(current_start_time);
                        
                        repeat(100) @(posedge m_tb_if.clk);
                        #1ps;
                        `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
                        modify_rf_cnt(current_rf_cnt, current_period, current_start_time);
                        period_check(current_period);
                    end

                    if(change_rf_param_during_rf == 0) begin
                        //change param immediately
                        rf_period_start_time_set(current_period,current_start_time);
                        @(posedge m_tb_if.clk);
                        `uvm_info(get_type_name(),"get new period and rf_start_time !!!!", UVM_LOW)
                        current_period      =   period;
                        current_start_time  =   rf_start_time;
                        `uvm_info(get_type_name(),$sformatf("current_period is %0h, current_start_time is %0h",current_period,current_start_time),UVM_LOW)
                    end

                    repeat(100) @(posedge m_tb_if.clk);
                    #1ps;
                    `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
                    modify_rf_cnt(current_rf_cnt, current_period, current_start_time);

                    rf_start_time_check(current_start_time);

                    repeat(100) @(posedge m_tb_if.clk);
                    if (change_rf_param_during_rf > 0) begin
                        rf_period_start_time_set(current_period,current_start_time);
                        @(posedge m_tb_if.clk);
                        `uvm_info(get_type_name(),"get new period and rf_start_time !!!!", UVM_LOW)
                        current_period      =   period;
                        current_start_time  =   rf_start_time;
                        `uvm_info(get_type_name(),$sformatf("current_period is %0h, current_start_time is %0h",current_period,current_start_time),UVM_LOW)
                        if (current_rf_cnt >= current_start_time) begin
                            #1ps;
                            `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
                            modify_rf_cnt(current_rf_cnt, current_period, current_start_time);
                            period_check(current_period);
                        end
                        else begin
                            #1ps;
                            `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
                            modify_rf_cnt(current_rf_cnt, current_period, current_start_time);
                            rf_start_time_check(current_start_time);
                        end

                    end

                    `uvm_info(get_type_name(),"wait refresh !!!!", UVM_LOW)
                    while(1)begin
                        if(m_tb_if.fsm == 0)
                            break;
                        @(posedge m_tb_if.clk);
                    end
                    `uvm_info(get_type_name(),"refresh done!!!!", UVM_LOW)
                    -> addr_2nd_check;
                    `uvm_info(get_type_name(),"wait 2nd refresh !!!!", UVM_LOW)
                    while(1)begin
                        if(m_tb_if.fsm == 0)
                            break;
                        @(posedge m_tb_if.clk);
                    end
                    `uvm_info(get_type_name(),"refresh done!!!!", UVM_LOW)

                end

                begin

                    if(!refresh_during_wr) begin
                        //during refresh, wr_rd
                        do begin
                            uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt);
                            @(posedge m_tb_if.clk);
                        end while(current_rf_cnt !== current_start_time);
                        repeat (50) @(posedge m_tb_if.clk);
                    end
                    if (wr_rd_mode) begin
                        for (int jj=0;jj<one_frame_cnt;jj++) begin
                            assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd));
                            assert(m_frame_cfg.randomize()with{
                                m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                                m_frame_cfg.wrap_en             ==  0;
                                m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                                m_frame_cfg.one_frame_cnt       ==  1;
                                m_frame_cfg.radd                ==  local::radd;
                                m_frame_cfg.cadd                ==  local::cadd;
                            });
                            `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);

                            send_one_frame(m_frame_cfg);
                        end
                    end
                    else begin
    
                        assert(m_frame_cfg.randomize()with{
                            m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                            m_frame_cfg.wrap_en             ==  local::wrap_en;
                            m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                            m_frame_cfg.one_frame_cnt       ==  local::one_frame_cnt;
                            m_frame_cfg.radd                ==  local::radd;
                            m_frame_cfg.cadd                ==  local::cadd;
                        });
                        `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
    
                        send_one_frame(m_frame_cfg);
                    end

                end

                begin
                    fork
                        while(1) begin
                            uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt);
                            @(posedge m_tb_if.clk);
                            //#1ps;
                        end 
                        begin
                            @(addr_2nd_check);
                            `uvm_info(get_type_name(),"double check !!", UVM_LOW)
                        end
                    join_any
                    disable fork;
                end

            join

            #1ps;
            `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
            uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", 0);
            //repeat(1000) @(posedge m_tb_if.clk);
        end
    end

    //------------------------------------ open close page siwtch and refresh ----------------------------
    if (case_index == 4) begin
        `uvm_info(get_type_name(),"\n------------------------- below is open close page siwtch and refresh ------------------------",UVM_LOW)
        for (int i=0;i<loop_times;i++) begin
            `uvm_info(get_type_name(),$sformatf("\n------------------------- below is @%0d------------------------",i),UVM_LOW)
            @(posedge m_tb_if.pclk);
            m_tb_if.page_mode_switch = 1'b0;
            @(posedge m_tb_if.pclk);
            @(posedge m_tb_if.pclk);
            m_tb_if.pre_precharge = pre_precharge_en;

            assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd, one_frame_cnt, wr_rd_mode )with{one_frame_cnt > 10;});
            fork
                begin
                    // wait wr_rd
                    for (int i=0;i<(one_frame_cnt/2);i++) begin
                        wait(m_frame_agent_if.mc_frame_vld && m_frame_agent_if.mc_frame_rdy);
                        @(posedge m_tb_if.clk);
                    end

                    //refresh
                    repeat($urandom_range(10)) @(posedge m_tb_if.clk);
                    #1ps;
                    `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
                    uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_start_time - $urandom_range(10));

                    repeat($urandom_range(5,20)) @(posedge m_tb_if.clk);
                    -> get_refresh;
                end

                begin
                     if (wr_rd_mode) begin
                        for (int jj=0;jj<one_frame_cnt;jj++) begin
                            assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd));
                            assert(m_frame_cfg.randomize()with{
                                m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                                m_frame_cfg.wrap_en             ==  0;
                                m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                                m_frame_cfg.one_frame_cnt       ==  1;
                                m_frame_cfg.radd                ==  local::radd;
                                m_frame_cfg.cadd                ==  local::cadd;
                            });
                            `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);

                            send_one_frame(m_frame_cfg);
                        end
                    end
                    else begin
    
                        assert(m_frame_cfg.randomize()with{
                            m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                            m_frame_cfg.wrap_en             ==  local::wrap_en;
                            m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                            m_frame_cfg.one_frame_cnt       ==  local::one_frame_cnt;
                            m_frame_cfg.radd                ==  local::radd;
                            m_frame_cfg.cadd                ==  local::cadd;
                        });
                        `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
    
                        send_one_frame(m_frame_cfg);
                    end                   

                end

                begin
                    @(get_refresh);
                    @(posedge m_tb_if.pclk);
                    m_tb_if.page_mode_switch = 1'b1;
                end

            join

            assert(m_frame_cfg.randomize());
            send_one_frame(m_frame_cfg);
            assert(m_frame_cfg.randomize());
            send_one_frame(m_frame_cfg);
            assert(m_frame_cfg.randomize());
            send_one_frame(m_frame_cfg);

            //repeat(1000) @(posedge m_tb_if.clk);
        end
    end


    #1000000ns;



endtask:body

task mc_refresh_local_vseq::rf_addr_check(bit [`ROW_ADDR_WIDTH-1:0] start_addr, bit [`ROW_ADDR_WIDTH-1:0] end_addr);


    int num_addr;
    num_addr = end_addr - start_addr + 1;
    if (num_addr <= 0) begin
        `uvm_error("rf_addr_check", $sformatf("num_addr <= 0!! start_addr is %0h, end_addr is %0h",start_addr,end_addr))
        return;
    end

    @(posedge m_tb_if.rf_request);
    @(negedge m_tb_if.rf_request);

    for (int i=0;i<num_addr;i++) begin
        @(negedge m_array_agent_if.bnksel_n);
        #1ps;
        if (m_array_agent_if.gradd_n != i + start_addr)
            `uvm_error("rf_addr_check", $sformatf("rf_addr_check error! exp radd is %0h, act is %0h", i + start_addr, m_array_agent_if.gradd_n))

        @(posedge m_array_agent_if.bnksel_n);
        #1ps;
        if (m_array_agent_if.gradd_n != i + start_addr)
            `uvm_error("rf_addr_check", $sformatf("rf_addr_check error! exp radd is %0h, act is %0h", i + start_addr, m_array_agent_if.gradd_n))
        //`uvm_info("rf_addr_check", $sformatf("i is %0h, addr is %0h",i,m_array_agent_if.gradd_n),UVM_LOW)
    end
    repeat(10) @(posedge m_tb_if.clk);
    #1ps;
    if (m_tb_if.fsm !== 0)
        `uvm_error("rf_addr_check", "after last addr, fsm not back to IDLE")

endtask:rf_addr_check

task mc_refresh_local_vseq::rf_period_start_time_set(input bit [31:0] now_period, input bit [31:0] now_start_time);


    rf_start_time   =   0;      //solve constraint problem
    assert(randomize(period) with {
        if (change_rf_param_during_rf == 2'b00) {
            period  >=   now_start_time;
        }

        else if (change_rf_param_during_rf == 2'b01) {
            period  >=   now_start_time;
        }
        else if (change_rf_param_during_rf == 2'b10) {
            period          ==  now_period; 
        }
        else if (change_rf_param_during_rf == 2'b11) {
            period  >=   now_start_time;
        }
    });

    assert(randomize(rf_start_time) with {
        if (change_rf_param_during_rf == 2'b00) {
            rf_start_time   !=  now_start_time; 
            rf_start_time   <   period;
        }

        else if (change_rf_param_during_rf == 2'b01) {
            if (now_start_time < period) {
                rf_start_time   ==  now_start_time; 
            }
        }
        else if (change_rf_param_during_rf == 2'b10) {
            rf_start_time   !=  now_start_time; 
            rf_start_time   <   period;
        }
        else if (change_rf_param_during_rf == 2'b11) {
            rf_start_time   !=  now_start_time; 
            rf_start_time   <   period;
        }
    });
    

    `uvm_info(get_type_name(),$sformatf("current_period is %0h, current_start_time is %0h",period,rf_start_time),UVM_LOW)
    //every time, global_rf_sel_en is tied and global_rf_sel rand

    if (global_rf_sel_en) begin
        global_rf_sel           =   ~global_rf_sel;

        if (!global_rf_sel) begin
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_period_cfg1_reg.write(status, period, UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_start_cfg1_reg.write(status, rf_start_time, UVM_FRONTDOOR);
        end

        else begin
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_period_cfg2_reg.write(status, period, UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_start_cfg2_reg.write(status, rf_start_time, UVM_FRONTDOOR);
        end
    end

    else begin
        mc_rf_cfg_sel   =   ~mc_rf_cfg_sel;

        if(!mc_rf_cfg_sel) begin
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_period_cfg1_reg.write(status, period, UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_start_cfg1_reg.write(status, rf_start_time, UVM_FRONTDOOR);
        end

        else begin
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_period_cfg2_reg.write(status, period, UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_start_cfg2_reg.write(status, rf_start_time, UVM_FRONTDOOR);
        end
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_rf_cfg_sel.write(status, mc_rf_cfg_sel, UVM_FRONTDOOR);
    end

    repeat(4) @(posedge m_tb_if.clk);
    m_tb_if.global_rf_sel   =   global_rf_sel;

endtask:rf_period_start_time_set

task mc_refresh_local_vseq::period_check(input bit [31:0] rf_period_inner);

    int current_rf_cnt_inner;
    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt_inner);
                    
    //if (!refresh_mode_after_change[0]) begin    //period >= current_period
    if(current_rf_cnt_inner <= rf_period_inner) begin   //period >= rf_cnt
        while(current_rf_cnt_inner != rf_period_inner) begin
            @(posedge m_tb_if.clk);
            #1ps;
            uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt_inner);
        end
        @(posedge m_tb_if.clk);
        #1ps;
        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt_inner);
        if (current_rf_cnt_inner != 0) 
            `uvm_error("period_check",$sformatf("period_check error, exp rf_cnt is 0, act is %0h", current_rf_cnt_inner))
        else
            `uvm_info("period_check", $sformatf("period_check pass, exp period is %0h ",rf_period_inner),UVM_LOW)

    end
    else begin  //period < current_period, rf_cnt clear
        @(posedge m_tb_if.clk);
        #1ps;
        if (current_rf_cnt_inner != 0) 
            `uvm_error("period_check",$sformatf("period_check error, exp rf_cnt is 0, act is %0h", current_rf_cnt_inner))
        else
            `uvm_info("period_check", $sformatf("period_check pass, exp period is %0h ",rf_period_inner),UVM_LOW)

    end


endtask:period_check

task mc_refresh_local_vseq::rf_start_time_check(input bit [31:0] rf_start_time_inner);
    int current_rf_cnt_inner;
    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt_inner);

    //if(!refresh_mode_after_change[1]) begin //rf_start_time >= current_rf_cnt, effect immediately
    while(current_rf_cnt_inner != rf_start_time_inner) begin
        @(posedge m_tb_if.clk);
        #1ps;
        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt_inner);
    end
    @(posedge m_tb_if.clk);
    #1ps;
    if (m_tb_if.rf_request !== 'b1)
        `uvm_error("rf_start_time_check", $sformatf("rf_start_time_check error, rf_start_time is %0h, rf_cnt is %0h, but rf_request is %0h",rf_start_time_inner, current_rf_cnt_inner, m_tb_if.rf_request))
    else 
        `uvm_info("rf_start_time_check", $sformatf("rf_start_time_check pass, rf_start_time is %0h",rf_start_time_inner),UVM_LOW)

endtask:rf_start_time_check

task mc_refresh_local_vseq::modify_rf_cnt(bit [31:0] rf_cnt_inner, bit [31:0] current_period_inner, bit [31:0] current_start_time_inner);
    bit [1:0]   modify_type;
    modify_type =   {(rf_cnt_inner >= current_period_inner), (rf_cnt_inner >= current_start_time_inner)};
    case(modify_type)
        2'b00: begin    //rf_cnt < current_start_time < current_period
            `uvm_info(get_type_name(),"modify rf cnt < current_start_time_inner !!!!", UVM_LOW)
            uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_start_time_inner - $urandom_range(10));
        end
        2'b01: begin    //current_start_time < rf_cnt < current_period
            `uvm_info(get_type_name(),"modify rf cnt < current_period_inner !!!!", UVM_LOW)
            uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_period_inner - $urandom_range(10));
        end
        default: begin    //not exist
            `uvm_error(get_type_name(),"current_period < current_start_time")
        end
    endcase
endtask:modify_rf_cnt

            
`endif
