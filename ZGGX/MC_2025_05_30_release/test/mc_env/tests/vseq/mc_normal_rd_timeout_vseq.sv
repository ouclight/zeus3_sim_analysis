`ifndef MC_NORMAL_RD_TIMEOUT_VSEQ
`define MC_NORMAL_RD_TIMEOUT_VSEQ

class mc_normal_rd_timeout_vseq extends mc_common_vseq;

    `uvm_object_utils(mc_normal_rd_timeout_vseq)

    function new(string name="mc_normal_rd_timeout_vseq");
        super.new(name);
    endfunction

    localparam                  RADDR_NUM=7360-64;
    localparam                  BURST_WIDTH=128;

    rand bit [2:0]              read_request_num;
    rand bit                    hang_timeout_mask;
    rand bit [31:0]             hang_timeout_th;
    rand bit [31:0]             mc_timeout_th;
    rand int                    err_injection_time;
    rand bit [31:0]             err_release_time;

    rand int                    force_timeout_cnt_delay;

    //frame cfg
    rand bit            frame_rw_flag   ;
    rand bit            wrap_en         ;
    rand bit            col_addr_rand_en;
    rand bit [15:0]     one_frame_cnt   ;
    rand bit [`COL_ADDR_WIDTH-1:0]      cadd            ;
    rand bit [`ROW_ADDR_WIDTH-1:0]      radd            ;

    rand bit            performance_test_en;

    constraint c_err_injection_time{
        err_injection_time inside {[1:100]};
    }
    constraint c_read_request_num{
        read_request_num > 1'b1;
    }

    constraint c_force_timeout_cnt_delay {
        force_timeout_cnt_delay inside {['d100:'d200]};
    }

    constraint c_read_timeout_th{
        hang_timeout_th >= 'd490000;     // >608us (486400),refresh used time
    }

    constraint c_mc_timeout_th{
        mc_timeout_th >= 'd490000;     // >608us (486400),refresh used time
    }

    constraint c_radd { 
        radd    inside {[0:RADDR_NUM-1]};
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

    constraint c_err_release_time{
        err_release_time inside {[10:100]};
    }

    extern virtual task body();
endclass

task mc_normal_rd_timeout_vseq::body();

    bit                 hang_timeout_flag;
    real                hang_timeout_start_cnt;
    real                hang_timeout_end_cnt;
    bit                 frame_sof;
    int                 disable_check_times = $urandom_range(100,200);
    int                 read_total_num;
    bit   [31:0]        hang_cnt;

    event               get_err_inject;

    super.body();

    if (m_tb_if.rst_ongoing_flag == 1'b1) begin
        uvm_hdl_deposit("mc_tb.rst_n",1);
        uvm_hdl_deposit("mc_tb.apb_rst_n",1);
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_en.write(status,1'h0, UVM_FRONTDOOR);
        @(posedge m_tb_if.pclk);
        m_tb_if.mc_scan_timeout_en  =   0;
        repeat(10) @(posedge m_tb_if.clk);
    end

    assert(randomize());
    m_tb_if.timeout_case    =   1;

    m_frame_agent_if.performance_test_en =   performance_test_en;

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rdrdy_n_en.mc_rdrdy_n_en.write(status,1'h0, UVM_FRONTDOOR);

    //change to normal timeout
    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_en.write(status, 1'b0, UVM_FRONTDOOR);
    @(posedge m_tb_if.pclk);
    m_tb_if.mc_scan_timeout_en  =   0;

    //set timeout threshold
    m_tb_if.mc_timeout_th = mc_timeout_th;

    //enable normal timeout
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.hang_timeout_en.write(status, 1'b1, UVM_FRONTDOOR);

    //set timeout threshold
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.hang_timeout_th.write(status, hang_timeout_th, UVM_FRONTDOOR);
    `uvm_info(get_type_name(),$sformatf("hang_timeout_th is %0d!", hang_timeout_th), UVM_LOW)

    //set timeout mask
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.hang_timeout_mask.write(status, hang_timeout_mask, UVM_FRONTDOOR);
    `uvm_info(get_type_name(),$sformatf("read_time_out_mask is %0d!", hang_timeout_mask), UVM_LOW)

    //send one write
    assert(m_frame_cfg.randomize() with{
        m_frame_cfg.frame_rw_flag       ==  1'b1;
        m_frame_cfg.wrap_en             ==  local::wrap_en;
        m_frame_cfg.one_frame_cnt       ==  local::one_frame_cnt;
        m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
        m_frame_cfg.radd                ==  local::radd;
        m_frame_cfg.cadd                ==  local::cadd;
    });
    `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
    send_one_frame(m_frame_cfg);
    #10000ns

    assert(randomize(err_injection_time)with{err_injection_time < one_frame_cnt*2;});
    if(m_tb_if.rst_ongoing_flag == 1'b0) begin

        fork: read_err_injection
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
                read_total_num  =   one_frame_cnt;
                `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                send_one_frame(m_frame_cfg);

                #10000ns
                repeat(force_timeout_cnt_delay) @(posedge m_tb_if.clk);
                #1ps;
                uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.mc_timeout_u.timeout_cnt", hang_timeout_th-100);

            end

            begin
                while(1) begin
                    @(posedge m_tb_if.clk);
                    #1ps;
                    if(m_frame_agent_if.mc_rvalid)
                        read_total_num  =   read_total_num - 1;
                end
            end

            begin
                //error injection
                //do begin
                //    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.hub_frame_data[287]",frame_sof);
                //    @(posedge m_tb_if.clk);
                //end while(frame_sof !== 1'b1);

                `uvm_info(get_type_name(),$sformatf("err_injection_time is %0d",err_injection_time),UVM_LOW)
                repeat(err_injection_time) @(posedge m_tb_if.clk);

                @(posedge m_array_agent_if.gcas_rd);
                uvm_hdl_force("mc_tb.m_mc_wrapper_aux.rdrdy_n",1'b1);
                -> get_err_inject;
                repeat(err_release_time) @(posedge m_tb_if.clk);
                uvm_hdl_release("mc_tb.m_mc_wrapper_aux.rdrdy_n");
            end

            begin
                //waitting for timeout status
                @(get_err_inject);
                do begin
                    @(posedge m_tb_if.clk);
                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.hang_timeout_status.peek(status, hang_timeout_flag);
                end while(hang_timeout_flag != 1);
                uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.mc_timeout_u.handshake_cnt",hang_cnt);
                if(hang_cnt == 0)
                    `uvm_error(get_type_name(),"timeout_flag is 1, but handshake_cnt is 0")
                disable read_err_injection;
            end
        join

        //************* check based on mask *************
        if(hang_timeout_mask) begin
            if(m_tb_if.mc_timeout_intr)
                `uvm_error(get_type_name(),"when masked, mc_timeout_intr is 1")
            else
                `uvm_info(get_type_name(),"mc_timeout_intr check pass",UVM_LOW)
        end

        else begin
            if(!m_tb_if.mc_timeout_intr)
                `uvm_error(get_type_name(),"when not masked, mc_timeout_intr is 0")
            else
                `uvm_info(get_type_name(),"mc_timeout_intr check pass",UVM_LOW)
        end

        //clear timeout
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.hang_timeout_clr.write(status, 1'b1, UVM_FRONTDOOR);

        repeat(30) @(posedge m_tb_if.clk);
        //check timeout_flag is cleared
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.hang_timeout_status.read(status, hang_timeout_flag, UVM_FRONTDOOR);
        if (hang_timeout_flag != 0)  `uvm_error(get_type_name(),$sformatf("timeout_flag is not cleared, now is %0b",hang_timeout_flag))

        uvm_hdl_release("mc_tb.m_mc_wrapper_aux.rdrdy_n");

        m_tb_if.rst_ongoing_flag = 1'b1;
        fork 
            uvm_hdl_deposit("mc_tb.rst_n",0);
            uvm_hdl_deposit("mc_tb.apb_rst_n",0);
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
    `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
    send_one_frame(m_frame_cfg);

    //*********** check path, and not read timeout ***********
    #10000ns;


    //disable timeout
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.hang_timeout_en.write(status, 1'b0, UVM_FRONTDOOR);
    `uvm_info(get_type_name(),"read timeout disable !", UVM_LOW)

    //send one read
    fork 
        begin
            assert(m_frame_cfg.randomize() with{
                m_frame_cfg.frame_rw_flag       ==  1'b0;
                m_frame_cfg.wrap_en             ==  1'b0;
                m_frame_cfg.one_frame_cnt       ==  1'b1;
                m_frame_cfg.col_addr_rand_en    ==  1'b0;
            });
            `uvm_info(get_full_name(),$sformatf("send write frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
            send_one_frame(m_frame_cfg);
            #10000ns;
            repeat(force_timeout_cnt_delay) @(posedge m_tb_if.clk);
            #1ps;
            uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.mc_timeout_u.timeout_cnt", hang_timeout_th-100);
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

    //for (int i=0;i<hang_timeout_th;i++) begin
    //    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.hang_timeout_status.peek(status, hang_timeout_flag);
    //    if (hang_timeout_flag == 1'b1)
    //        `uvm_error(get_type_name(),"disable timeout, but timeout_flag is 1")

    //    @(posedge m_tb_if.clk);
    //end


    //after mc_timeout_th, check timeout_flag for disable_check_times
    for (int i=0;i<disable_check_times;i++) begin
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.hang_timeout_status.read(status, hang_timeout_flag, UVM_FRONTDOOR);
        if (hang_timeout_flag == 1'b1)
            `uvm_error(get_type_name(),"during disable check times, timeout_flag is 1, but timeout is disable!")
    end

    m_tb_if.monitor_enable=0;

    #10000ns;
endtask:body

`endif
