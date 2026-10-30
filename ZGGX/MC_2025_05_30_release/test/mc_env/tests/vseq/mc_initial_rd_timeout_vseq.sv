`ifndef MC_INITIAL_RD_TIMEOUT_VSEQ
`define MC_INITIAL_RD_TIMEOUT_VSEQ

class mc_initial_rd_timeout_vseq extends mc_common_vseq;

    `uvm_object_utils(mc_initial_rd_timeout_vseq)

    function new(string name="mc_initial_rd_timeout_vseq");
        super.new(name);
    endfunction

    localparam                  RADDR_NUM=7360-64;
    localparam                  BURST_WIDTH=128;
    rand bit [15:0]             read_request_num;
    rand int                    err_injection_time;
    rand bit [31:0]             mc_timeout_th;
    rand bit                    hang_timeout_mask;
    rand bit [31:0]             err_release_time;
    rand bit                    release_mode;

    rand int                    force_timeout_cnt_delay;

    //frame cfg
    rand bit                    frame_rw_flag;
    rand bit                    wrap_en;
    rand bit                    col_addr_rand_en;
    rand bit [15:0]             one_frame_cnt;
    rand bit [`COL_ADDR_WIDTH-1:0]              cadd;
    rand bit [`ROW_ADDR_WIDTH-1:0]             radd;

    //refresh
    rand bit [31:0]                 period;    
    rand bit [31:0]                 rf_start_time;

    rand bit                    performance_test_en;
    constraint c_read_request_num{
        solve one_frame_cnt before read_request_num;
        read_request_num <= one_frame_cnt;
        read_request_num dist {[1:7]:=50, [8:$]:=50};
    }

    constraint c_radd { 
        radd    inside {[0:RADDR_NUM-1]};
    }

    constraint c_force_timeout_cnt_delay {
        force_timeout_cnt_delay inside {['d100:'d200]};
    }

    constraint c_one_frame_cnt { 
        solve wrap_en before one_frame_cnt;
        if(wrap_en == 1){one_frame_cnt == BURST_WIDTH;}
        else {one_frame_cnt inside {[1:BURST_WIDTH]};}
    }

    constraint c_cadd { 
        solve wrap_en before cadd;
        solve col_addr_rand_en before cadd;
        solve one_frame_cnt before cadd;
        if(col_addr_rand_en == 0 &&  wrap_en==0){cadd inside {[0:BURST_WIDTH-one_frame_cnt]};}        
    }

    constraint c_mc_timeout_th{
        //mc_timeout_th inside {['d490000:'d500000]};     // >608us (486400),refresh used time
        mc_timeout_th >= 'd490000;     // >608us (486400),refresh used time
    }


    constraint c_err_injection_time{
        err_injection_time inside {[1:20]};
    }

    constraint c_err_release_time{
        err_release_time inside {[10:100]};
    }

    //64ms:32'h30d4000, 32ms:32'h186a000, 16ms:32'hc35000, 8ms:32'h61a800, 4ms:32'h30d400; 1ms:32'hc3500
    constraint c_period{
        period dist {'h30d4000:=20, 'h186a000:=20, 'hc35000:=20, 'h61a800:=20, 'h30d400:=20, 'hc3500:=20};
    }
    
    constraint c_rf_start_time{
        solve period before rf_start_time;
        rf_start_time < period;
        rf_start_time dist {[0:'h1000]:/70, ['h1000:'hc3500]:/30};
    }

    extern virtual task body();

endclass:mc_initial_rd_timeout_vseq

task mc_initial_rd_timeout_vseq::body();

    bit                 mc_timeout_flag;
    bit                 frame_sof;
    int                 disable_check_times = $urandom_range(100,200);

    int                 num_rdata;
    int                 timeout_rdata;
    int                 exp_timeout_rdata;
    bit [31:0]          handshake_cnt;
    bit                 read_rdrdy_n;
    bit                 read_rdrdy_phy_n;
    bit [31:0]          resp_cnt;

    event               get_release;

    super.body();

    m_tb_if.error_inject = 1'b1;

    if(m_tb_if.rst_ongoing_flag == 1'b1) begin
        uvm_hdl_deposit("mc_tb.rst_n",1);
        uvm_hdl_deposit("mc_tb.apb_rst_n",1);
        repeat(10) @(posedge m_tb_if.clk);
        $display("%t: resetn rst release",$realtime);
    end

    assert(randomize()with{
        release_mode == 1;          //release
    });

    @(posedge m_tb_if.clk);
    #1ps;
    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_en.write(status,1'h1, UVM_FRONTDOOR);
    @(posedge m_tb_if.pclk);
    m_tb_if.mc_scan_timeout_en  =   1;

    //close hang_timeout_en
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.hang_timeout_en.write(status, 1'b0, UVM_FRONTDOOR);


    m_frame_agent_if.performance_test_en =   performance_test_en;

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rdrdy_n_en.mc_rdrdy_n_en.write(status,1'h0, UVM_FRONTDOOR);

    //change to initial timeout
    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_en.write(status, 1'b1, UVM_FRONTDOOR);
    @(posedge m_tb_if.pclk);
    m_tb_if.mc_scan_timeout_en  =   1;

    //set timeout threshold
    m_tb_if.mc_timeout_th = mc_timeout_th;

    @(posedge m_tb_if.clk);
    m_tb_if.mc_rf_start = 1'b1;
    //set timeout mask
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.hang_timeout_mask.write(status, hang_timeout_mask, UVM_FRONTDOOR);
    `uvm_info(get_type_name(),$sformatf("read_time_out_mask is %0d!", hang_timeout_mask), UVM_LOW)

    assert(randomize(read_request_num)with{one_frame_cnt == read_request_num;});
    `uvm_info(get_type_name(),$sformatf("read_request_num is %0d, err_release_time is %0d",read_request_num, err_release_time),UVM_LOW)

    if(m_tb_if.rst_ongoing_flag == 1'b0) begin

        //initial refresh
        @(posedge m_tb_if.pclk);
        m_tb_if.mc_rf_start_sel = 0;    //0:interface, 1:reg
        m_tb_if.mc_rf_period_sel = 0;    //0:interface, 1:reg

        //rf_addr = {rf_start_addr, rf_end_addr};

        //refresh soc sel
        m_tb_if.rf_period       =   period;
        m_tb_if.rf_start_time   =   rf_start_time;


        fork:read_err_injection
            begin
                //send one read
                assert(m_frame_cfg.randomize() with{
                    m_frame_cfg.frame_rw_flag       ==  1'b0;
                    m_frame_cfg.wrap_en             ==  local::wrap_en;
                    m_frame_cfg.one_frame_cnt       ==  local::one_frame_cnt;
                    m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
                    m_frame_cfg.radd                ==  local::radd;
                    m_frame_cfg.cadd                ==  local::cadd;
                });
                send_one_frame(m_frame_cfg);
                #10000ns;
                repeat(force_timeout_cnt_delay) @(posedge m_tb_if.clk);
                #1ps;
                uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.mc_timeout_u.timeout_cnt", mc_timeout_th-100);
            end

            begin
                //error injection
                do begin
                    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.hub_frame_data[287]",frame_sof);
                    @(posedge m_tb_if.clk);
                end while(frame_sof !== 1'b1);

                assert(randomize(err_injection_time)with{err_injection_time < one_frame_cnt*2;});
                repeat(err_injection_time) @(posedge m_tb_if.clk);

                @(posedge m_array_agent_if.gcas_rd);
                uvm_hdl_force("mc_tb.m_mc_wrapper_aux.rdrdy_n",1'b1);
                if (release_mode == 1) begin
                    repeat(err_release_time) @(posedge m_tb_if.clk);
                    if (read_rdrdy_phy_n === 0 && read_rdrdy_n === 1) begin
                        @(posedge m_tb_if.clk);
                        uvm_hdl_release("mc_tb.m_mc_wrapper_aux.rdrdy_n");
                    end
                    else begin
                        uvm_hdl_release("mc_tb.m_mc_wrapper_aux.rdrdy_n");
                    end
                end

            end

            while(1) begin
                @(posedge m_tb_if.clk);
                uvm_hdl_read("mc_tb.m_mc_wrapper_aux.rdrdy_n",read_rdrdy_n);
                uvm_hdl_read("mc_tb.rdrdy_n_phy_0",read_rdrdy_phy_n);
                if (read_rdrdy_phy_n === 0 && read_rdrdy_n === 1) begin
                    exp_timeout_rdata   =   exp_timeout_rdata   +   1;
                    `uvm_info(get_type_name(),"exp_timeout_rdata + 1",UVM_LOW)
                end
            end

            begin
                //waitting for timeout status
                repeat(err_injection_time) @(posedge m_tb_if.clk);

                `uvm_info(get_type_name(), "waitting timeout_flag",UVM_LOW)
                do begin
                    @(posedge m_tb_if.clk);
                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_flag.peek(status, mc_timeout_flag);
                end while(mc_timeout_flag != 1);

                `uvm_info(get_type_name(), "mc_timeout_flag has been 1, get mc rvalid and mc rdata",UVM_LOW)

                uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.mc_timeout_u.handshake_cnt",handshake_cnt);
                if(handshake_cnt == 0)
                    `uvm_error(get_type_name(),"when timeout_flag is 1, handshake_cnt is 0!")

                //uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.mc_timeout_u.req_cnt",req_cnt);
                //if(req_cnt == 0)
                //    `uvm_error(get_type_name(),"timeout_flag is 1, but handshake_cnt is 0")
            end

            begin
                while(1) begin
                    if (m_frame_agent_if.mc_rvalid == 1'b1) begin
                        num_rdata   =   num_rdata   +   1'b1;
                        //`uvm_info(get_type_name(),"total num_rdata + 1",UVM_LOW)
                        `uvm_info(get_type_name(),$sformatf("total num_rdata + 1, read_request_numis %0d, num_rdata is %0d, exp_timeout_rdata is %0d", read_request_num, num_rdata, exp_timeout_rdata),UVM_LOW)
                        if(m_frame_agent_if.mc_rdata === 266'h0123456789abcdef) begin
                            timeout_rdata = timeout_rdata + 1;
                            `uvm_info(get_type_name(),"timeout num_rdata + 1",UVM_LOW)
                        end
                        else begin
                            if(release_mode == 0)
                                `uvm_error(get_type_name(),"timeout_rdata is not 0123456789abcdef")
                        end
                    end
                    @(posedge m_tb_if.clk);
                    resp_cnt    =   (exp_timeout_rdata > 7)? (num_rdata + exp_timeout_rdata - 7):(num_rdata);
                    if(read_request_num ==  resp_cnt)
                        break;
                end

                disable read_err_injection;
            end
        join

        //num of timeout read data
        if (release_mode == 0) begin
            if (read_request_num > 7) begin
                if (num_rdata != 'd7) begin
                    `uvm_error(get_type_name(),$sformatf("num of rdata error, exp is 7, act is %0d",num_rdata))
                end
            end

            else begin
                if (num_rdata != read_request_num) begin
                    `uvm_error(get_type_name(),$sformatf("num of rdata error, exp is %0d, act is %0d",read_request_num, num_rdata))
                end
            end
        end

        else begin
            if (exp_timeout_rdata > 7) begin
                if (timeout_rdata != 'd7) begin
                    `uvm_error(get_type_name(),$sformatf("num of rdata error, exp is 7, act is %0d",timeout_rdata))
                end
            end

            else begin
                if (exp_timeout_rdata != timeout_rdata) begin
                    `uvm_error(get_type_name(),$sformatf("num of rdata error, exp is %0d, act is %0d",exp_timeout_rdata, timeout_rdata))
                end
            end
        end
        //************* check based on mask *************
        //if(hang_timeout_mask) begin
        //    if(m_tb_if.mc_timeout_intr)
        //        `uvm_error(get_type_name(),"when masked, mc_timeout_intr is 1")
        //    else
        //        `uvm_info(get_type_name(),"mc_timeout_intr check pass",UVM_LOW)
        //end

        //else begin
        //    if(!m_tb_if.mc_timeout_intr)
        //        `uvm_error(get_type_name(),"when masked, mc_timeout_intr is 0")
        //    else
        //        `uvm_info(get_type_name(),"mc_timeout_intr check pass",UVM_LOW)
        //end

        //clear timeout
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_clr.write(status, 1'b1, UVM_FRONTDOOR);

        repeat(10) @(posedge m_tb_if.clk);
        //check timeout_flag is cleared
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_flag.read(status, mc_timeout_flag, UVM_FRONTDOOR);
        if (mc_timeout_flag != 0)  `uvm_error(get_type_name(),$sformatf("timeout_flag is not cleared, now is %0b",mc_timeout_flag))

        uvm_hdl_release("mc_tb.m_mc_wrapper_aux.rdrdy_n");

        m_tb_if.rst_ongoing_flag = 1'b1;
        m_tb_if.error_inject = 1'b0;
        fork 
            uvm_hdl_deposit("mc_tb.rst_n",0);
            uvm_hdl_deposit("mc_tb.apb_rst_n",0);
            $display("%t: resetn rst start",$realtime);
        join
 
    end

    
    //send one write
    assert(m_frame_cfg.randomize() with{
        m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
        m_frame_cfg.wrap_en             ==  local::wrap_en;
        m_frame_cfg.one_frame_cnt       ==  local::one_frame_cnt;
        m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
        m_frame_cfg.radd                ==  local::radd;
        m_frame_cfg.cadd                ==  local::cadd;
    });
    send_one_frame(m_frame_cfg);

    //*********** check path, and not read timeout ***********
    #10000ns;


    //disable timeout
    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_en.write(status, 1'b0, UVM_FRONTDOOR);
    @(posedge m_tb_if.pclk);
    m_tb_if.mc_scan_timeout_en  =   0;
    `uvm_info(get_type_name(),"read timeout disable !", UVM_LOW)

    fork 
        begin

            //send one read
            assert(m_frame_cfg.randomize() with{
                m_frame_cfg.frame_rw_flag       ==  1'b0;
                m_frame_cfg.wrap_en             ==  1'b0;
                m_frame_cfg.one_frame_cnt       ==  1'b1;
                m_frame_cfg.col_addr_rand_en    ==  1'b0;
            });
            send_one_frame(m_frame_cfg);
            #10000ns;
            repeat(force_timeout_cnt_delay) @(posedge m_tb_if.clk);
            #1ps;
            uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.mc_timeout_u.timeout_cnt", mc_timeout_th-100);
        end

        begin
            //error injection
            @(posedge m_array_agent_if.gcas_rd);
            uvm_hdl_force("mc_tb.m_mc_wrapper_aux.rdrdy_n",1'b1);
        end
    join

    //repeat(10) @(posedge m_tb_if.clk);

    //uvm_hdl_release("mc_tb.m_mc_wrapper_aux.rdrdy_n");
 
    `uvm_info(get_type_name(),"waitting timeout disabl !", UVM_LOW)

    //for (int i=0;i<mc_timeout_th;i++) begin
    //    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_flag.peek(status, mc_timeout_flag);
    //    if (mc_timeout_flag == 1'b1)
    //        `uvm_error(get_type_name(),"disable timeout, but timeout_flag is 1")

    //    @(posedge m_tb_if.clk);
    //end

    //after mc_timeout_th, check timeout_flag for disable_check_times
    for (int i=0;i<disable_check_times;i++) begin
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_flag.peek(status, mc_timeout_flag);
        if (mc_timeout_flag == 1'b1)
            `uvm_error(get_type_name(),"during disable check times, timeout_flag is 1, but timeout is disable!")
        @(posedge m_tb_if.clk);
    end

    m_tb_if.monitor_enable=0;

    #10000ns;

endtask:body
`endif
