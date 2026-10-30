`ifndef MC_OPEN_CLOSE_PAGE_VSEQ
`define MC_OPEN_CLOSE_PAGE_VSEQ

class mc_open_close_page_vseq extends mc_common_vseq;

    covergroup Cov_frame_type;
        no_pre_en_opt:coverpoint m_frame_agent_if.mc_frame_data[289:286] iff(!pre_precharge_en){
            bins    act             =   {4'b0110};
            bins    fakewr          =   {4'b0100};
            bins    pre             =   {4'b0101};
            bins    act_fakewr_pre  =   {4'b0111};
            bins    act_wr_rd       =   {4'b1110,4'b1010};
            bins    wr_rd           =   {4'b1100, 4'b1000};
            bins    wr_rd_pre       =   {4'b1101,4'b1001};
            //bins    rd_pre          =   {4'b1001};              //pre_precharge_en
            bins    act_wr_rd_pre   =   {4'b1011,4'b1111};
            //bins    act_rd_pre      =   {4'b1011};              //pre_precharge_en
            illegal_bins   illegal_opt  =   {[4'b0000:4'b0011]};
        }

        pre_en_opt:coverpoint m_frame_agent_if.mc_frame_data[289:286] iff(pre_precharge_en){
            bins    act             =   {4'b0110};
            bins    fakewr          =   {4'b0100};
            bins    pre             =   {4'b0101};
            bins    act_fakewr_pre  =   {4'b0111};
            bins    act_wr_rd       =   {4'b1110,4'b1010};
            bins    wr_rd           =   {4'b1100, 4'b1000};
            bins    wr_pre       =   {4'b1101};
            bins    rd_pre          =   {4'b1001};              //pre_precharge_en
            bins    act_wr_pre   =   {4'b1111};
            bins    act_rd_pre      =   {4'b1011};              //pre_precharge_en
            illegal_bins   illegal_opt  =   {[4'b0000:4'b0011]};
        }
    endgroup

    `uvm_object_utils(mc_open_close_page_vseq)

    function new(string name="mc_open_close_page_vseq");
        super.new(name);
        Cov_frame_type=new();
    endfunction

    localparam                  RADDR_NUM=7360-64;
    localparam                  BURST_WIDTH=128;

    rand bit [1:0]      wr_mode         ;   //0:seq write and seq read;
                                            //1:write -> read ->write ->read
                                            //2,3:randomize

    rand bit            performance_test_en;

    //frame cfg
    rand bit            frame_rw_flag   ;
    rand bit            wrap_en         ;
    rand bit            col_addr_rand_en;
    rand bit [15:0]     one_frame_cnt   ;
    rand bit [`COL_ADDR_WIDTH-1:0]      cadd            ;
    rand bit [`ROW_ADDR_WIDTH-1:0]     radd            ;
    rand bit            strb_rand_en    ;
    rand bit            strb            ;

    rand bit            row_mode        ;   //0:rand;   1:tie

    //refresh param
    rand bit [31:0]     refresh_start_time;
    rand bit [31:0]     refresh_period;
    rand bit [`ROW_ADDR_WIDTH-1:0]     refresh_start_addr;
    rand bit [`ROW_ADDR_WIDTH-1:0]     refresh_end_addr;

    //frame cnt
    rand int            num_frame_send;
    rand int            page_change_delay;

    //page param pre_precharge_en
    rand bit            pre_precharge_en;

    bit                 exp_bnksel_n[$]; //for bnksel_n check
    bit                 pre_wr_rd[$];
    real                open_rd_precharge_time;     //for read and no delay pre time
    int                 operation_timeout_num='d60  ; //operation check timeout cycle num


    constraint c_radd { 
        radd    inside {[0:RADDR_NUM-1]};
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
            cadd dist {[0:BURST_WIDTH-one_frame_cnt]:/50,(BURST_WIDTH-one_frame_cnt):/50};      //modified by HY @20241230  
    }

    constraint c_wrap_en{
        wrap_en dist {0:=60,1:=40};     //modified by HY @20241230
    }

    constraint c_col_addr_rand_en{
        col_addr_rand_en dist {0:=60,1:=40};
    }

    constraint c_num_frame_send{
        num_frame_send inside {[1:100]};
    }

    constraint c_page_change_delay{
        page_change_delay inside{[1:300]};
    }

    extern virtual task body();
    extern task check_operation(bit page_type, bit pre_precharge, bit row_status, bit [3:0] source_wrseof);
    //extern task check_operation(bit op);   //op is 0:ACT+WR/RD && WR/RD && WR/RD+PRE   op is 1: ACT+WR/RD+PRE
    extern task seof_cmd00_op_check(bit page_type, bit pre_precharge, bit row_status, bit source_rw, bit source_wstrb);
    extern task seof_cmd01_op_check(bit page_type, bit pre_precharge, bit row_status, bit source_rw, bit source_wstrb);
    extern task seof_cmd10_op_check(bit page_type, bit pre_precharge, bit row_status, bit source_rw, bit source_wstrb);
    extern task seof_cmd11_op_check(bit page_type, bit pre_precharge, bit row_status, bit source_rw, bit source_wstrb);



endclass:mc_open_close_page_vseq

task mc_open_close_page_vseq::body();
    
    bit                         frame_rw_flag_q[$]       ;

    bit                         mc_page_status           ;
    bit                         rd_wrap_en_q[$]          ;
    bit                         rd_col_addr_rand_en_q[$] ;
    bit [15:0]                  rd_one_frame_cnt_q[$]    ;
    bit [`COL_ADDR_WIDTH-1:0]   rd_cadd_q[$]             ;
    bit [`ROW_ADDR_WIDTH-1:0]   rd_radd_q[$]             ;

    bit                         rd_wrap_en          ;
    bit                         rd_col_addr_rand_en ;
    bit [15:0]                  rd_one_frame_cnt    ;
    bit [`COL_ADDR_WIDTH-1:0]   rd_cadd             ;
    bit [`ROW_ADDR_WIDTH-1:0]   rd_radd             ;

    //row mode used
    bit [`ROW_ADDR_WIDTH-1:0]   radd_tmp             ;


    //check param
    bit [19:0]                  check_addr_q[$]             ;
    bit [2:0]                   check_frame_wrse_q[$]       ;
    bit [19:0]                  check_addr                  ;
    int                         read_cnt = 0                ;
    int                         write_cnt = 0               ;
    int                         check_cnt = 0               ;
    bit                         row_status                  ;

    super.body();


    assert(randomize()with{
        //pre_precharge_en == 1'b0;
        performance_test_en == 1'b1;
    });
    m_frame_agent_if.performance_test_en =   performance_test_en;
    `uvm_info(get_type_name(),$sformatf("num_frame_send is %0d", num_frame_send),UVM_LOW)


    //rand dbg_data_store_en
    @(posedge m_tb_if.clk);
    m_tb_if.dbg_data_store_en=$urandom_range(1);
    `uvm_info("open page", $sformatf("dbg_data_store_en is %0b",m_tb_if.dbg_data_store_en),UVM_LOW)

    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
    //================================= open page, disable precharge =====================================
    //disable pre-charge
    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.pre_precharge.write(status, pre_precharge_en, UVM_FRONTDOOR);
    @(posedge m_tb_if.pclk);
    m_tb_if.pre_precharge = pre_precharge_en;
    `uvm_info("open page", $sformatf("pre_precharge_en is %0b",pre_precharge_en),UVM_LOW)

    //if (wr_mode == 1'b0) begin
    //    for (int i=0;i<num_frame_send;i++) begin
    //        frame_rw_flag_q.push_back(1'b1);
    //    end
    //    for (int i=0;i<num_frame_send;i++) begin
    //        frame_rw_flag_q.push_back(1'b0);
    //    end
    //end
    //else if (wr_mode == 1'b1) begin
    //    for (int i=0;i<num_frame_send;i++) begin
    //        frame_rw_flag_q.push_back(1'b1);
    //        frame_rw_flag_q.push_back(1'b0);
    //    end
    //end

    `uvm_info("page mode switch", "------------------------ initial page_mode_switch ------------------------", UVM_LOW)

    `uvm_info("page mode switch", "initial page_mode_switch to close page", UVM_LOW)

    //do begin
    //    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
    //end while (mc_page_status != 1'b1);

    @(posedge m_tb_if.pclk);
    @(posedge m_tb_if.pclk);
    m_tb_if.page_mode_switch = 1'b1;

    do begin
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
    end while (mc_page_status != 1'b1);

    `uvm_info("page mode switch", "initial page_mode_switch to open page", UVM_LOW)
    @(posedge m_tb_if.pclk);
    @(posedge m_tb_if.pclk);
    m_tb_if.page_mode_switch = 1'b0;

    do begin
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
    end while (mc_page_status != 1'b1);

    `uvm_info("open page", "-------------- open page, disable precharge -------------", UVM_LOW)
    fork
        begin
            while(1) begin
                //if (wr_mode != 1'b0 && wr_mode != 1'b1) begin

                if (row_mode)
                    radd_tmp    =   radd;

                assert(randomize(frame_rw_flag));
                //end
                //else begin
                    //frame_rw_flag = frame_rw_flag_q.pop_front;
                //end

                if (frame_rw_flag == 1'b1) begin
                    //write frame
                    if (write_cnt == num_frame_send) continue;

                    assert(randomize(wrap_en, col_addr_rand_en, radd, cadd, one_frame_cnt) with{
                        if(row_mode){
                            radd    ==  radd_tmp;
                        }
                    });

                    rd_wrap_en_q.push_back(wrap_en);
                    rd_col_addr_rand_en_q.push_back(col_addr_rand_en);
                    rd_one_frame_cnt_q.push_back(one_frame_cnt);
                    rd_cadd_q.push_back(cadd);
                    rd_radd_q.push_back(radd);

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

                    write_cnt = write_cnt + 1;
                    `uvm_info("send write frame", $sformatf("write_cnt is %0d", write_cnt), UVM_LOW)
                end

                else begin
                    //read frame
                    `uvm_info("send read frame", $sformatf("frame_rw_flag is %0d", frame_rw_flag), UVM_LOW)
                    if(rd_cadd_q.size() > 0) begin
                        //assert(randomize(read_delay_time));
                        //#read_delay_time;
                        rd_wrap_en = rd_wrap_en_q.pop_front;
                        rd_col_addr_rand_en = rd_col_addr_rand_en_q.pop_front;
                        rd_one_frame_cnt = rd_one_frame_cnt_q.pop_front;
                        rd_radd = rd_radd_q.pop_front;
                        rd_cadd = rd_cadd_q.pop_front;

                        assert(m_frame_cfg.randomize()with{
                            m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                            m_frame_cfg.wrap_en             ==  rd_wrap_en;
                            m_frame_cfg.col_addr_rand_en    ==  rd_col_addr_rand_en;
                            m_frame_cfg.one_frame_cnt       ==  rd_one_frame_cnt;
                            m_frame_cfg.radd                ==  rd_radd;
                            m_frame_cfg.cadd                ==  rd_cadd;
                        });
                        `uvm_info(get_full_name(),$sformatf("send read frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                        //`uvm_info("send read frame", $sformatf("frame_rw_flag is 0, wrap_en is %0b, col_addr_rand_en is %0d, one_frame_cnt is %0d, radd is %0h, cadd is %0h", rd_wrap_en, rd_col_addr_rand_en, rd_one_frame_cnt, rd_radd, rd_cadd), UVM_LOW)
                        send_one_frame(m_frame_cfg);

                        read_cnt = read_cnt + 1;
                        `uvm_info("send read frame", $sformatf("read_cnt is %0d", read_cnt), UVM_LOW)
                    end

                    if(read_cnt == num_frame_send)
                        break;
                end
            end
        end

        begin:get_row_addr
            //check get row addr
            while(1) begin
                if(m_frame_agent_if.mc_frame_vld && m_frame_agent_if.mc_frame_rdy) begin

                    //`uvm_info("get frame send", $sformatf("get frame send at frame interface, frame addr is %0h",m_frame_agent_if.mc_frame_data[19:0]),UVM_LOW)
                    check_frame_wrse_q.push_back(m_frame_agent_if.mc_frame_data[289:286]);
                    check_addr_q.push_back(m_frame_agent_if.mc_frame_data[19:0]);
                    Cov_frame_type.sample();
                end

                @(posedge m_tb_if.clk);
            end
        end

        begin
        //check array
            while(1) begin
                if(check_addr_q.size()>0) begin
                    if(check_cnt == 0) begin
                        row_status = 1'b1;
                        check_operation(1'b0, pre_precharge_en, row_status, check_frame_wrse_q.pop_front);
                        check_addr = check_addr_q.pop_front;
                        //`uvm_info("operation check", $sformatf("operation addr is %0h",check_addr),UVM_LOW)
                    end

                    else begin
                        row_status = (check_addr[19 -: `ROW_ADDR_WIDTH] != check_addr_q[0][19-:`ROW_ADDR_WIDTH]);
                        check_operation(1'b0, pre_precharge_en,row_status, check_frame_wrse_q.pop_front);
                        check_addr = check_addr_q.pop_front;
                        //`uvm_info("operation check", $sformatf("operation addr is %0h",check_addr),UVM_LOW)
                    end

                    check_cnt = check_cnt + 1;
                    `uvm_info("check array", $sformatf("check_cnt + 1, now is %0d",check_cnt),UVM_LOW)
                end
                else
                    #1ps;

                if(read_cnt == num_frame_send && check_addr_q.size() == 0) begin
                    #500ns;
                    disable get_row_addr;
                    break;
                end
            end

        end

    join


    //============================ change page mode ===========================
    //fork
    //begin
    //    fork
    //    begin
    //        do begin
    //            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
    //        end while (mc_page_status);
    //        `uvm_info(get_type_name(),"now status is 0, open_page",UVM_LOW)
    //    end

    //    begin
    //        repeat(100) @(posedge m_tb_if.clk);
    //        `uvm_error(get_type_name(),"read mc_page_status timeout, during open to close page")
    //    end
    //    join_any
    //    disable fork;
    //end
    //join

    //change to close page
    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.page_mode_switch.write(status, 1'b1, UVM_FRONTDOOR);
    @(posedge m_tb_if.pclk);
    m_tb_if.page_mode_switch = 1'b1;

    //============================ close page operation check ========================
    repeat(4) @(posedge m_tb_if.clk);

    //initial param
    rd_wrap_en_q.delete();
    rd_col_addr_rand_en_q.delete();
    rd_one_frame_cnt_q.delete();
    rd_cadd_q.delete();
    rd_radd_q.delete();
    check_frame_wrse_q.delete();
    check_addr_q.delete();
    write_cnt = 0;
    read_cnt = 0;
    check_cnt = 0;
    assert(randomize(num_frame_send));

    repeat(4) @(posedge m_tb_if.clk);

    fork
        begin
            while(1) begin
                assert(randomize(frame_rw_flag));
                if (frame_rw_flag == 1'b1) begin
                    //write frame
                    if (write_cnt == num_frame_send) continue;

                    assert(randomize(wrap_en, col_addr_rand_en, radd, cadd, one_frame_cnt));

                    rd_wrap_en_q.push_back(wrap_en);
                    rd_col_addr_rand_en_q.push_back(col_addr_rand_en);
                    rd_one_frame_cnt_q.push_back(one_frame_cnt);
                    rd_cadd_q.push_back(cadd);
                    rd_radd_q.push_back(radd);

                    assert(m_frame_cfg.randomize()with{
                        m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                        m_frame_cfg.wrap_en             ==  local::wrap_en;
                        m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                        m_frame_cfg.one_frame_cnt       ==  local::one_frame_cnt;
                        m_frame_cfg.radd                ==  local::radd;
                        m_frame_cfg.cadd                ==  local::cadd;
                    });
                    `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);

                    //`uvm_info("send write frame", $sformatf("frame_rw_flag is 1, wrap_en is %0b, col_addr_rand_en is %0d, one_frame_cnt is %0d, radd is %0h, cadd is %0h", wrap_en, col_addr_rand_en, one_frame_cnt, radd, cadd), UVM_LOW)
                    send_one_frame(m_frame_cfg);

                    write_cnt = write_cnt + 1;
                    `uvm_info("send write frame", $sformatf("write_cnt is %0d", write_cnt), UVM_LOW)
                end

                else begin
                    //read frame
                    `uvm_info("send read frame", $sformatf("frame_rw_flag is %0d", frame_rw_flag), UVM_LOW)
                    if(rd_cadd_q.size() > 0) begin
                        //assert(randomize(read_delay_time));
                        //#read_delay_time;
                        rd_wrap_en = rd_wrap_en_q.pop_front;
                        rd_col_addr_rand_en = rd_col_addr_rand_en_q.pop_front;
                        rd_one_frame_cnt = rd_one_frame_cnt_q.pop_front;
                        rd_radd = rd_radd_q.pop_front;
                        rd_cadd = rd_cadd_q.pop_front;

                        assert(m_frame_cfg.randomize()with{
                            m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                            m_frame_cfg.wrap_en             ==  rd_wrap_en;
                            m_frame_cfg.col_addr_rand_en    ==  rd_col_addr_rand_en;
                            m_frame_cfg.one_frame_cnt       ==  rd_one_frame_cnt;
                            m_frame_cfg.radd                ==  rd_radd;
                            m_frame_cfg.cadd                ==  rd_cadd;
                        });
                        `uvm_info(get_full_name(),$sformatf("send read frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                        //`uvm_info("send read frame", $sformatf("frame_rw_flag is 0, wrap_en is %0b, col_addr_rand_en is %0d, one_frame_cnt is %0d, radd is %0h, cadd is %0h", rd_wrap_en, rd_col_addr_rand_en, rd_one_frame_cnt, rd_radd, rd_cadd), UVM_LOW)
                        send_one_frame(m_frame_cfg);

                        read_cnt = read_cnt + 1;
                        `uvm_info("send read frame", $sformatf("read_cnt is %0d", read_cnt), UVM_LOW)
                    end

                    if(read_cnt == num_frame_send)
                        break;
                end
            end
        end

        begin:get_row_addr_close
            //check get row addr
            while(1) begin
                if(m_frame_agent_if.mc_frame_vld && m_frame_agent_if.mc_frame_rdy) begin

                    //`uvm_info("get frame send", $sformatf("get frame send at frame interface, frame addr is %0h",m_frame_agent_if.mc_frame_data[19:0]),UVM_LOW)
                    check_frame_wrse_q.push_back(m_frame_agent_if.mc_frame_data[289:286]);
                    check_addr_q.push_back(m_frame_agent_if.mc_frame_data[19:0]);
                end

                @(posedge m_tb_if.clk);
            end
        end

        begin
        //check array
            while(1) begin
                if(check_addr_q.size()>0) begin
                    if(check_cnt == 0) begin
                        row_status = 1'b1;
                        check_operation(1'b1, pre_precharge_en ,row_status, check_frame_wrse_q.pop_front);
                        check_addr = check_addr_q.pop_front;
                        //`uvm_info("operation check", $sformatf("operation addr is %0h",check_addr),UVM_LOW)
                    end

                    else begin
                        row_status = (check_addr[19 -: `ROW_ADDR_WIDTH] != check_addr_q[0][19-:`ROW_ADDR_WIDTH]);
                        check_operation(1'b1, pre_precharge_en,row_status, check_frame_wrse_q.pop_front);
                        check_addr = check_addr_q.pop_front;
                        //`uvm_info("operation check", $sformatf("operation addr is %0h",check_addr),UVM_LOW)
                    end

                    check_cnt = check_cnt + 1;
                    //`uvm_info("check array", $sformatf("check_cnt + 1, now is %0d",check_cnt),UVM_LOW)
                end
                else
                    #1ps;

                if(read_cnt == num_frame_send && check_addr_q.size() == 0) begin
                    #500ns;
                    disable get_row_addr_close;
                    break;
                end
            end

        end

    join

    //============================ change page mode, during write or read burst===========================

    for (int ii=0;ii<9;ii++) begin  //close2open && open2close 
        //initial param
        rd_wrap_en_q.delete();
        rd_col_addr_rand_en_q.delete();
        rd_one_frame_cnt_q.delete();
        rd_cadd_q.delete();
        rd_radd_q.delete();
        check_frame_wrse_q.delete();
        check_addr_q.delete();
        write_cnt = 0;
        read_cnt = 0;
        check_cnt = 0;
        assert(randomize(num_frame_send,page_change_delay));
        `uvm_info(get_type_name(),$sformatf("@%0d, num_frame_send is %0d,page_change_delay is %0d",ii,num_frame_send,page_change_delay),UVM_LOW)

        fork
            begin
                #page_change_delay;
                fork
                    begin
                        do begin
                            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
                        end while (mc_page_status != 1'b1);
                        `uvm_info(get_type_name(),"now status is 0, open_page",UVM_LOW)

                        //change to page mode
                        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.page_mode_switch.write(status, ii, UVM_FRONTDOOR);
                        @(posedge m_tb_if.pclk);
                        m_tb_if.page_mode_switch = ii;
                        repeat(4) @(posedge m_tb_if.clk);
                    end
        
                    //begin
                    //    repeat(100) @(posedge m_tb_if.clk);
                    //    `uvm_error(get_type_name(),"read mc_page_status timeout, during open to close page")
                    //end
                join_any

                disable fork;
            end

            begin
                while(1) begin
                    assert(randomize(frame_rw_flag));
                    if (frame_rw_flag == 1'b1) begin
                        //write frame
                        if (write_cnt == num_frame_send) continue;

                        assert(randomize(wrap_en, col_addr_rand_en, radd, cadd, one_frame_cnt));

                        rd_wrap_en_q.push_back(wrap_en);
                        rd_col_addr_rand_en_q.push_back(col_addr_rand_en);
                        rd_one_frame_cnt_q.push_back(one_frame_cnt);
                        rd_cadd_q.push_back(cadd);
                        rd_radd_q.push_back(radd);

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

                        write_cnt = write_cnt + 1;
                        `uvm_info("send write frame", $sformatf("write_cnt is %0d", write_cnt), UVM_LOW)
                    end

                    else begin
                        //read frame
                        `uvm_info("send read frame", $sformatf("frame_rw_flag is %0d", frame_rw_flag), UVM_LOW)
                        if(rd_cadd_q.size() > 0) begin
                            //assert(randomize(read_delay_time));
                            //#read_delay_time;
                            rd_wrap_en = rd_wrap_en_q.pop_front;
                            rd_col_addr_rand_en = rd_col_addr_rand_en_q.pop_front;
                            rd_one_frame_cnt = rd_one_frame_cnt_q.pop_front;
                            rd_radd = rd_radd_q.pop_front;
                            rd_cadd = rd_cadd_q.pop_front;

                            assert(m_frame_cfg.randomize()with{
                                m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
                                m_frame_cfg.wrap_en             ==  rd_wrap_en;
                                m_frame_cfg.col_addr_rand_en    ==  rd_col_addr_rand_en;
                                m_frame_cfg.one_frame_cnt       ==  rd_one_frame_cnt;
                                m_frame_cfg.radd                ==  rd_radd;
                                m_frame_cfg.cadd                ==  rd_cadd;
                            });
                            `uvm_info(get_full_name(),$sformatf("send read frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                            send_one_frame(m_frame_cfg);

                            read_cnt = read_cnt + 1;
                            `uvm_info("send read frame", $sformatf("read_cnt is %0d", read_cnt), UVM_LOW)
                        end

                        if(read_cnt == num_frame_send)
                            break;
                    end
                end
            end

        join
    end

    $display("all done!!");
    #10000ns;
    //repeat(100) @(posedge m_tb_if.clk);

endtask:body

task mc_open_close_page_vseq::check_operation(bit page_type, bit pre_precharge, bit row_status, bit [3:0] source_wrseof);


    bit                                 source_rw;
    bit                                 source_sof;
    bit                                 source_eof;
    bit                                 source_wstrb;
    //bit     [`COL_ADDR_WIDTH-1:0]       source_frame_gcadd;
    //bit     [`ROW_ADDR_WIDTH-1:0]       source_frame_gradd_n;
    //bit     [`ARRAY_DATA_WIDTH-1:0]     source_data;            //data + parity data

    //`uvm_info("check_operation", "check_operation",UVM_LOW)

    source_wstrb            =  source_wrseof[3]; 
    source_rw               =  source_wrseof[2];
    source_sof              =  source_wrseof[1]; 
    source_eof              =  source_wrseof[0]; 

    if (!m_tb_if.mc_dram_init_wr_finish || !m_tb_if.mc_en) begin
        wait(m_tb_if.mc_dram_init_wr_finish && m_tb_if.mc_en);
        repeat(23) @(posedge m_tb_if.clk);
    end

    if(source_sof && !source_eof) 
        //source CMD:  ACT+WR/RD
        seof_cmd10_op_check(page_type, pre_precharge && source_eof && !source_rw, row_status, source_rw, source_wstrb);
                                                     
    else if(!source_sof && !source_eof)              
        //source CMD:  WR/RD                         
        seof_cmd00_op_check(page_type, pre_precharge && source_eof && !source_rw, row_status, source_rw, source_wstrb);
                                                     
    else if(!source_sof && source_eof)               
        //source CMD:  WR/RD+PRE                     
        seof_cmd01_op_check(page_type, pre_precharge && source_eof && !source_rw, row_status, source_rw, source_wstrb);
                                                     
    else                                             
        //source CMD:  ACT+WR/RD+PRE                 
        seof_cmd11_op_check(page_type, pre_precharge && source_eof && !source_rw, row_status, source_rw, source_wstrb);



endtask:check_operation




task mc_open_close_page_vseq::seof_cmd10_op_check(bit page_type, bit pre_precharge, bit row_status, bit source_rw, bit source_wstrb);
    //====================================== Source_CMD: ACT+WR/RD ===================================
    string page_type_name;
    bit     pre_bnksel_n;
    real    now_time;

    now_time    =   $realtime;

    page_type_name =  (!page_type)? "open_page":"close page";
    `uvm_info("operation check",$sformatf("page is %s, pre_precharge is %0b, row_status is %0b, source_rw is %0b, source_wstrb is %0b",page_type_name, pre_precharge, row_status, source_rw, source_wstrb),UVM_LOW)

    if (exp_bnksel_n.size() == 0) begin
        pre_bnksel_n = 1;
    end
    else begin
        pre_bnksel_n = exp_bnksel_n.pop_front;
    end

    if(page_type)
        pre_bnksel_n = 1;
    else begin
        if (m_array_agent_if.bnksel_n == 1'b1 && row_status && (now_time == open_rd_precharge_time))    //pre is rd and then row_status is 1, pre_bnksel_n is 1
            pre_bnksel_n    =   1;
    end

    if (pre_bnksel_n != m_array_agent_if.bnksel_n)
        `uvm_error("operation check", $sformatf("pre_bnksel_n is not equal to now bnksel_n, pre_bnksel_n is %0b, now is %0b",pre_bnksel_n, m_array_agent_if.bnksel_n))

    if (!page_type) begin
        //======================================= open page ============================================
        if(row_status && !m_array_agent_if.bnksel_n) begin
            //PRE + ACT + WR/RD
            `uvm_info("operation check","\n============================================= Open Source_CMD: ACT+WR/RD, Des_CMD: PRE+ACT+WR/RD ==============================================",UVM_LOW)
            fork:frame_cmd10_1
                begin
                    @(posedge m_array_agent_if.bnksel_n);            //need add condition to check pos or neg bnksel_n timing!!!!!!!!!!
                    `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                    @(negedge m_array_agent_if.bnksel_n);
                    `uvm_info("operation check","ACT operation!!!",UVM_LOW)
                    if(source_rw) begin
                        if (source_wstrb) begin
                            //WR
                            @(posedge m_array_agent_if.gcas_wr);
                            @(negedge m_array_agent_if.gcas_wr);
                            `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                            `uvm_info("operation check","WR operation!!!",UVM_LOW)
                        end
                    end
                    else begin
                        //RD
                        @(posedge m_array_agent_if.gcas_rd);
                        @(negedge m_array_agent_if.gcas_rd);
                        `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                        `uvm_info("operation check","RD operation!!!",UVM_LOW)
                        open_rd_precharge_time  =   $realtime;
                    end
                    exp_bnksel_n.push_back(1'b0);
                    disable frame_cmd10_1;
                end

                begin
                    repeat(operation_timeout_num) @(posedge m_tb_if.clk);
                    `uvm_error("operation check","Timeout!!!")
                    disable frame_cmd10_1;
                end
            join 
        end

        else if(m_array_agent_if.bnksel_n)begin
            //ACT + WR/RD
            `uvm_info("operation check","\n ======================================== Open Source_CMD: ACT+WR/RD, Des_CMD: ACT+WR/RD ===============================================",UVM_LOW)
            fork:frame_cmd10_2
                begin
                    @(negedge m_array_agent_if.bnksel_n);
                    `uvm_info("operation check","ACT operation!!!",UVM_LOW)
                    if(source_rw) begin
                        if (source_wstrb) begin
                            //WR
                            @(posedge m_array_agent_if.gcas_wr);
                            @(negedge m_array_agent_if.gcas_wr);
                            `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                            `uvm_info("operation check","WR operation!!!",UVM_LOW)
                        end
                    end
                    else begin
                        //RD
                        @(posedge m_array_agent_if.gcas_rd);
                        @(negedge m_array_agent_if.gcas_rd);
                        `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                        `uvm_info("operation check","RD operation!!!",UVM_LOW)
                        open_rd_precharge_time  =   $realtime;
                    end
                    exp_bnksel_n.push_back(1'b0);
                    disable frame_cmd10_2;
                end
                begin
                    repeat(operation_timeout_num) @(posedge m_tb_if.clk);
                    `uvm_error("operation check","Timeout!!!")
                    disable frame_cmd10_2;
                end
            join 
        end

        else if(!row_status && !m_array_agent_if.bnksel_n) begin
            //WR/RD
            `uvm_info("operation check","\n ======================================== Open Source_CMD: ACT+WR/RD, Des_CMD: WR/RD ===============================================",UVM_LOW)
             fork:frame_cmd10_3
                begin
                    if(source_rw) begin
                        if (source_wstrb) begin
                            //WR
                            @(posedge m_array_agent_if.gcas_wr);
                            @(negedge m_array_agent_if.gcas_wr);
                            `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                            `uvm_info("operation check","WR operation!!!",UVM_LOW)
                        end
                    end
                    else begin
                        //RD
                        @(posedge m_array_agent_if.gcas_rd);
                        @(negedge m_array_agent_if.gcas_rd);
                        `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                        `uvm_info("operation check","RD operation!!!",UVM_LOW)
                        open_rd_precharge_time  =   $realtime;
                    end
                    exp_bnksel_n.push_back(1'b0);
                    disable frame_cmd10_3;
                end
                begin
                    repeat(operation_timeout_num) @(posedge m_tb_if.clk);
                    `uvm_error("operation check","Timeout!!!")
                    disable frame_cmd10_3;
                end
            join 
        end
        else
            `uvm_error("Source_CMD: ACT+WR/RD","no such situation, modify the checker!!!")
    end

    else begin
        //================================================= close page ================================================
        fork:frame_cmd10_4
            //ACT+WR/RD
            `uvm_info("operation check","\n =========================================== Close Source_CMD: ACT+WR/RD, Des_CMD: ACT+WR/RD =========================================",UVM_LOW)
            begin
                @(negedge m_array_agent_if.bnksel_n);
                `uvm_info("operation check","ACT operation!!!",UVM_LOW)
                if(source_rw) begin
                    if (source_wstrb) begin
                        //WR
                        @(posedge m_array_agent_if.gcas_wr);
                        @(negedge m_array_agent_if.gcas_wr);
                        `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                        `uvm_info("operation check","WR operation!!!",UVM_LOW)
                    end
                end
                else begin
                    //RD
                    @(posedge m_array_agent_if.gcas_rd);
                    @(negedge m_array_agent_if.gcas_rd);
                    `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                    `uvm_info("operation check","RD operation!!!",UVM_LOW)
                end
                exp_bnksel_n.push_back(1'b0);
                disable frame_cmd10_4;
            end
            begin
                repeat(operation_timeout_num) @(posedge m_tb_if.clk);
                `uvm_error("operation check","Timeout!!!")
                disable frame_cmd10_4;
            end
        join 
    end

endtask:seof_cmd10_op_check

task mc_open_close_page_vseq::seof_cmd00_op_check(bit page_type, bit pre_precharge, bit row_status, bit source_rw, bit source_wstrb);
    //====================================== Source_CMD: WR/RD ===================================
    string page_type_name;
    bit pre_bnksel_n;

    page_type_name =  (!page_type)? "open_page":"close page";
    `uvm_info("operation check",$sformatf("page is %s, pre_precharge is %0b, row_status is %0b, source_rw is %0b, source_wstrb is %0b",page_type_name, pre_precharge, row_status, source_rw, source_wstrb),UVM_LOW)

    if (exp_bnksel_n.size() == 0) begin
        `uvm_error("operation check", "this exp_bnksel_n.size should not be 0!!")
        pre_bnksel_n = 1;
    end
    else begin
        pre_bnksel_n = exp_bnksel_n.pop_front;
    end

    if (pre_bnksel_n != m_array_agent_if.bnksel_n)
        `uvm_error("operation check", $sformatf("pre_bnksel_n is not equal to now bnksel_n, pre_bnksel_n is %0b, now is %0b",pre_bnksel_n, m_array_agent_if.bnksel_n))

    //WR/RD
    fork:frame_cmd00_1
        `uvm_info("operation check","\n ========================================== Source_CMD: WR/RD, Des_CMD: WR/RD ==========================================",UVM_LOW)
        begin
            if(source_rw) begin
                if (source_wstrb) begin
                    //WR
                    @(posedge m_array_agent_if.gcas_wr);
                    @(negedge m_array_agent_if.gcas_wr);
                    `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                    `uvm_info("operation check","WR operation!!!",UVM_LOW)
                end
            end
            else begin
                //RD
                @(posedge m_array_agent_if.gcas_rd);
                @(negedge m_array_agent_if.gcas_rd);
                `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                `uvm_info("operation check","RD operation!!!",UVM_LOW)
                if (!page_type)
                        open_rd_precharge_time  =   $realtime;
            end
            exp_bnksel_n.push_back(0);
            disable frame_cmd00_1;
        end
        begin
            repeat(operation_timeout_num) @(posedge m_tb_if.clk);
            `uvm_error("operation check","Timeout!!!")
            disable frame_cmd00_1;
        end
    join 
 
endtask:seof_cmd00_op_check

task mc_open_close_page_vseq::seof_cmd01_op_check(bit page_type, bit pre_precharge, bit row_status, bit source_rw, bit source_wstrb);
    //====================================== Source_CMD: WR/RD+PRE ===================================
    string page_type_name;
    bit pre_bnksel_n;

    page_type_name =  (!page_type)? "open_page":"close page";
    `uvm_info("operation check",$sformatf("page is %s, pre_precharge is %0b, row_status is %0b, source_rw is %0b, source_wstrb is %0b",page_type_name, pre_precharge, row_status, source_rw, source_wstrb),UVM_LOW)

    if (exp_bnksel_n.size() == 0) begin
        `uvm_error("operation check", "this exp_bnksel_n.size should not be 0!!")
        pre_bnksel_n = 1;
    end
    else begin
        pre_bnksel_n = exp_bnksel_n.pop_front;
    end

    if (pre_bnksel_n != m_array_agent_if.bnksel_n)
        `uvm_error("operation check", $sformatf("pre_bnksel_n is not equal to now bnksel_n, pre_bnksel_n is %0b, now is %0b",pre_bnksel_n, m_array_agent_if.bnksel_n))

    if (!page_type) begin
        //======================================= open page ============================================
        if (pre_precharge) begin
            //WR/RD+PRE
            `uvm_info("operation check","\n ===================================== Open Source_CMD: WR/RD+PRE, Des_CMD: WR/RD+PRE =============================================",UVM_LOW)
            fork:frame_cmd01_1
                begin
                    if(source_rw) begin
                        if (source_wstrb) begin
                            //WR
                            @(posedge m_array_agent_if.gcas_wr);
                            @(negedge m_array_agent_if.gcas_wr);
                            `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                            `uvm_info("operation check","WR operation!!!",UVM_LOW)
                        end
                        @(posedge m_array_agent_if.bnksel_n);       //pre_precharge need to consider !!!!!!!!!!!!!!!!!!!!
                        `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                    end
                    else begin
                        fork //min tRTP=0
                            begin
                                //RD
                                @(posedge m_array_agent_if.gcas_rd);
                                @(negedge m_array_agent_if.gcas_rd);
                                `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                                `uvm_info("operation check","RD operation!!!",UVM_LOW)
                            end
                            begin
                                @(posedge m_array_agent_if.bnksel_n);       //pre_precharge need to consider !!!!!!!!!!!!!!!!!!!!
                                `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                            end
                        join
                    end
                    exp_bnksel_n.push_back(1'b1);
                    //**********************************************
                    //********************************************
                    disable frame_cmd01_1;
                end
                begin
                    repeat(operation_timeout_num) @(posedge m_tb_if.clk);
                    `uvm_error("operation check","Timeout!!!")
                    disable frame_cmd01_1;
                end
            join 
        end

        else begin
            //WR/RD
            `uvm_info("operation check","\n ============================================= Open Source_CMD: WR/RD+PRE, Des_CMD: WR/RD ========================================",UVM_LOW)
             fork:frame_cmd01_2
                begin
                    if(source_rw) begin
                        if (source_wstrb) begin
                            //WR
                            @(posedge m_array_agent_if.gcas_wr);
                            @(negedge m_array_agent_if.gcas_wr);
                            `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                            `uvm_info("operation check","WR operation!!!",UVM_LOW)
                        end
                    end
                    else begin
                        //RD
                        @(posedge m_array_agent_if.gcas_rd);
                        @(negedge m_array_agent_if.gcas_rd);
                        `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                        `uvm_info("operation check","RD operation!!!",UVM_LOW)
                        open_rd_precharge_time  =   $realtime;
                    end
                    exp_bnksel_n.push_back(1'b0);
                    disable frame_cmd01_2;
                end
                begin
                    repeat(operation_timeout_num) @(posedge m_tb_if.clk);
                    `uvm_error("operation check","Timeout!!!")
                    disable frame_cmd01_2;
                end
            join 
        end
    end

    else begin
        //======================================= close page ============================================
        //WR/RD+PRE
        fork:frame_cmd01_3
            `uvm_info("operation check","\n =================================================== Close Source_CMD: WR/RD+PRE, Des_CMD: WR/RD+PRE =========================================",UVM_LOW)
            begin
                if(source_rw) begin
                    if (source_wstrb) begin
                    //WR
                        @(posedge m_array_agent_if.gcas_wr);
                        @(negedge m_array_agent_if.gcas_wr);
                        `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                        `uvm_info("operation check","WR operation!!!",UVM_LOW)
                    end
                    @(posedge m_array_agent_if.bnksel_n);       //pre_precharge need to consider !!!!!!!!!!!!!!!!!!!!
                    `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                end
                else begin
                    //RD
                    fork //min tRTP=0
                        begin
                            //RD
                            @(posedge m_array_agent_if.gcas_rd);
                            @(negedge m_array_agent_if.gcas_rd);
                            `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                            `uvm_info("operation check","RD operation!!!",UVM_LOW)
                        end
                        begin
                            @(posedge m_array_agent_if.bnksel_n);       //pre_precharge need to consider !!!!!!!!!!!!!!!!!!!!
                            `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                        end
                    join
                end
                exp_bnksel_n.push_back(1'b1);
                disable frame_cmd01_3;
            end
            begin
                repeat(operation_timeout_num) @(posedge m_tb_if.clk);
                `uvm_error("operation check","Timeout!!!")
                disable frame_cmd01_3;
            end
        join 
    end

endtask:seof_cmd01_op_check

task mc_open_close_page_vseq::seof_cmd11_op_check(bit page_type, bit pre_precharge, bit row_status, bit source_rw, bit source_wstrb);
    //====================================== Source_CMD: ACT+WR/RD+PRE ===================================
    string page_type_name;
    bit pre_bnksel_n;
    real    now_time;
    now_time    =   $realtime;

    page_type_name =  (!page_type)? "open_page":"close page";
    `uvm_info("operation check",$sformatf("page is %s, pre_precharge is %0b, row_status is %0b, source_rw is %0b, source_wstrb is %0b",page_type_name, pre_precharge, row_status, source_rw, source_wstrb),UVM_LOW)

    if (exp_bnksel_n.size() == 0 ) begin
        pre_bnksel_n = 1;
    end
    else begin
        pre_bnksel_n = exp_bnksel_n.pop_front;
    end

    if(page_type)
        pre_bnksel_n = 1;
    else begin
        if (m_array_agent_if.bnksel_n == 1'b1 && row_status && (now_time == open_rd_precharge_time))    //pre is rd and then row_status is 1, pre_bnksel_n is 1
            pre_bnksel_n    =   1;
    end

    if (pre_bnksel_n != m_array_agent_if.bnksel_n)
        `uvm_error("operation check", $sformatf("pre_bnksel_n is not equal to now bnksel_n, pre_bnksel_n is %0b, now is %0b",pre_bnksel_n, m_array_agent_if.bnksel_n))


    if (!page_type) begin
        //======================================= open page ============================================

        if(pre_precharge) begin
            //================================== open page, pre_precharge ===========================

            if(row_status && !m_array_agent_if.bnksel_n) begin
                //PRE + ACT + WR/RD + PRE
                `uvm_info("operation check","\n =================================================== Open Source_CMD: ACT+WR/RD+PRE, Des_CMD: PRE+ACT+WR/RD+PRE ===============================================",UVM_LOW)
                fork:frame_cmd11_1
                    begin
                        @(posedge m_array_agent_if.bnksel_n);            //need add condition to check pos or neg bnksel_n timing!!!!!!!!!!
                        `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                        @(negedge m_array_agent_if.bnksel_n);
                        `uvm_info("operation check","ACT operation!!!",UVM_LOW)
                        if(source_rw) begin
                            if (source_wstrb) begin
                                //WR
                                @(posedge m_array_agent_if.gcas_wr);
                                @(negedge m_array_agent_if.gcas_wr);
                                `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                                `uvm_info("operation check","WR operation!!!",UVM_LOW)
                            end
                            @(posedge m_array_agent_if.bnksel_n);            //need add condition to check pos or neg bnksel_n timing!!!!!!!!!!
                            `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                        end
                        else begin
                            //RD
                            fork
                                begin
                                    @(posedge m_array_agent_if.gcas_rd);
                                    @(negedge m_array_agent_if.gcas_rd);
                                    `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                                    `uvm_info("operation check","RD operation!!!",UVM_LOW)
                                end
                                begin
                                    @(posedge m_array_agent_if.bnksel_n);            //need add condition to check pos or neg bnksel_n timing!!!!!!!!!!
                                    `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                                end
                            join
                        end
                        exp_bnksel_n.push_back(1'b1);
                        disable frame_cmd11_1;
                    end

                    begin
                        repeat(operation_timeout_num) @(posedge m_tb_if.clk);
                        `uvm_error("operation check","Timeout!!!")
                        disable frame_cmd11_1;
                    end
                join 
            end

            else if(m_array_agent_if.bnksel_n)begin
                //ACT + WR/RD + PRE
                `uvm_info("operation check","\n ======================================================== Open Source_CMD: ACT+WR/RD+PRE, Des_CMD: ACT+WR/RD+PRE ==================================================",UVM_LOW)
                fork:frame_cmd11_2
                    begin
                        @(negedge m_array_agent_if.bnksel_n);
                        `uvm_info("operation check","ACT operation!!!",UVM_LOW)
                        if(source_rw) begin
                            if (source_wstrb) begin
                                //WR
                                @(posedge m_array_agent_if.gcas_wr);
                                @(negedge m_array_agent_if.gcas_wr);
                                `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                                `uvm_info("operation check","WR operation!!!",UVM_LOW)
                            end
                            @(posedge m_array_agent_if.bnksel_n);            //need add condition to check pos or neg bnksel_n timing!!!!!!!!!!
                            `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                        end
                        else begin
                            //RD
                            fork
                                begin
                                    @(posedge m_array_agent_if.gcas_rd);
                                    @(negedge m_array_agent_if.gcas_rd);
                                    `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                                    `uvm_info("operation check","RD operation!!!",UVM_LOW)
                                end
                                begin
                                    @(posedge m_array_agent_if.bnksel_n);            //need add condition to check pos or neg bnksel_n timing!!!!!!!!!!
                                    `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                                end
                            join
                        end
                        exp_bnksel_n.push_back(1'b1);
                        disable frame_cmd11_2;
                    end
                    begin
                        repeat(operation_timeout_num) @(posedge m_tb_if.clk);
                        `uvm_error("operation check","Timeout!!!")
                        disable frame_cmd11_2;
                    end
                join 
            end

            else if(!row_status && !m_array_agent_if.bnksel_n) begin
                //WR/RD + PRE
                `uvm_info("operation check","\n ========================================================== Open Source_CMD: ACT+WR/RD+PRE, Des_CMD: WR/RD+PRE ====================================================",UVM_LOW)
                 fork:frame_cmd11_3
                    begin
                        if(source_rw) begin
                            if (source_wstrb) begin
                                //WR
                                @(posedge m_array_agent_if.gcas_wr);
                                @(negedge m_array_agent_if.gcas_wr);
                                `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                                `uvm_info("operation check","WR operation!!!",UVM_LOW)
                            end
                            @(posedge m_array_agent_if.bnksel_n);            //need add condition to check pos or neg bnksel_n timing!!!!!!!!!!
                            `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                        end
                        else begin
                            //RD
                            fork
                                begin
                                    @(posedge m_array_agent_if.gcas_rd);
                                    @(negedge m_array_agent_if.gcas_rd);
                                    `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                                    `uvm_info("operation check","RD operation!!!",UVM_LOW)
                                end
                                begin
                                    @(posedge m_array_agent_if.bnksel_n);            //need add condition to check pos or neg bnksel_n timing!!!!!!!!!!
                                    `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                                end
                            join
                        end
                        exp_bnksel_n.push_back(1'b1);
                        disable frame_cmd11_3;
                    end

                    begin
                        repeat(operation_timeout_num) @(posedge m_tb_if.clk);
                        `uvm_error("operation check","Timeout!!!")
                        disable frame_cmd11_3;
                    end
                join 
            end
            else
                `uvm_error("Source_CMD: ACT+WR/RD","no such situation, modify the checker!!!")
        end

        else begin 
            //=============================== open page, disable pre_precharge ==============================
            //same with ACT+WR/RD
            exp_bnksel_n.push_back(pre_bnksel_n);
            `uvm_info("Source_CMD: ACT+WR/RD+PRE", "\n====================== below is ACT+WR/RD+PRE's task ====================",UVM_LOW)
            seof_cmd10_op_check(page_type, pre_precharge, row_status, source_rw, source_wstrb);
            `uvm_info("Source_CMD: ACT+WR/RD+PRE", "\n====================== above is ACT+WR/RD+PRE's task ====================",UVM_LOW)
        end
    end

    else begin
        //================================================= close page ================================================
        fork:frame_cmd11_4
            //ACT+WR/RD+PRE
            `uvm_info("operation check","\n =================================================== Close Source_CMD: ACT+WR/RD+PRE, Des_CMD: ACT+WR/RD+PRE ====================================================",UVM_LOW)
            begin
                @(negedge m_array_agent_if.bnksel_n);
                `uvm_info("operation check","ACT operation!!!",UVM_LOW)
                if(source_rw) begin
                    if (source_wstrb) begin
                        //WR
                        @(posedge m_array_agent_if.gcas_wr);
                        @(negedge m_array_agent_if.gcas_wr);
                        `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                        `uvm_info("operation check","WR operation!!!",UVM_LOW)
                    end
                    @(posedge m_array_agent_if.bnksel_n);            //need add condition to check pos or neg bnksel_n timing!!!!!!!!!!
                    `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                end
                else begin
                    //RD
                    fork
                        begin
                            @(posedge m_array_agent_if.gcas_rd);
                            @(negedge m_array_agent_if.gcas_rd);
                            `uvm_info("operation check",$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n,m_array_agent_if.gcadd),UVM_LOW)
                            `uvm_info("operation check","RD operation!!!",UVM_LOW)
                        end
                        begin
                            @(posedge m_array_agent_if.bnksel_n);            //need add condition to check pos or neg bnksel_n timing!!!!!!!!!!
                            `uvm_info("operation check","PRE operation!!!",UVM_LOW)
                        end
                    join
                end
                exp_bnksel_n.push_back(1'b1);
                disable frame_cmd11_4;
            end
            begin
                repeat(operation_timeout_num) @(posedge m_tb_if.clk);
                `uvm_error("operation check","Timeout!!!")
                disable frame_cmd11_4;
            end
        join 
    end

endtask:seof_cmd11_op_check
`endif
