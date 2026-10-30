`ifndef TRIM_COMMON_VSEQ_SV
`define TRIM_COMMON_VSEQ_SV

class trim_common_vseq extends trim_base_vseq;

    uvm_status_e        status;

    bit [31:0]          rd_data;
    //0718//int                 data[14];

    //0717//rand bit [27:0]     init_spine_reset_time;
    rand bit [3:0]  dram_layer_sel_rand;

    `uvm_object_utils(trim_common_vseq)
    function new(string name="trim_common_vseq");
        super.new(name);
    endfunction

    virtual task body();
        $display("Please complete the sequence as follow ...");
        `uvm_info("trim_common_vseq", $sformatf("--------Enter the trim_common_vseq-------"), UVM_LOW)
        //apb_seq    m_apb_seq;
        //`uvm_do_on(m_apb_seq,p_sequencer.p_apb_sqr);
        //0716//#10us;
    
        if(m_trim_if.second_reset_flag == 0)begin
            wait_reset_release();
        end

        @(posedge m_apb_if.pclk);
        // check trim_ctrl_id:
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_ctrl_id.read(status,rd_data,UVM_FRONTDOOR);
        if(rd_data != 32'h5452494D)
            `uvm_error("trim_common_vseq", $sformatf("trim_ctrl_id check failed, rd_data = %0h", rd_data))
        else
            `uvm_info("trim_common_vseq", $sformatf("trim_ctrl_id check passed"), UVM_LOW)

    endtask


    task wait_reset_release();
        @(posedge m_trim_if.rst_n);
        @(posedge m_apb_if.presetn);
    endtask: wait_reset_release


    task tsv_tm_cfg(input bit[427:0] tsv_tm);
        int     data[14];


        //for(int i=0; i<13; i++)begin
        //    data[i] = tsv_tm[i*32+:i];
        //end
        data[0]     = tsv_tm[31:0];
        data[1]     = tsv_tm[63:32];
        data[2]     = tsv_tm[95:64];
        data[3]     = tsv_tm[127:96];
        data[4]     = tsv_tm[159:128];
        data[5]     = tsv_tm[191:160];
        data[6]     = tsv_tm[223:192];
        data[7]     = tsv_tm[255:224];
        data[8]     = tsv_tm[287:256];
        data[9]     = tsv_tm[319:288];
        data[10]    = tsv_tm[351:320];
        data[11]    = tsv_tm[383:352];
        data[12]    = tsv_tm[415:384];
        data[13][11:0] = tsv_tm[427:416];

        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value0.write(status,data[0],UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value1.write(status,data[1],UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value2.write(status,data[2],UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value3.write(status,data[3],UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value4.write(status,data[4],UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value5.write(status,data[5],UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value6.write(status,data[6],UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value7.write(status,data[7],UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value8.write(status,data[8],UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value9.write(status,data[9],UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value10.write(status,data[10],UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value11.write(status,data[11],UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value12.write(status,data[12],UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.redump_tsv_tm_other_value13.write(status,data[13][11:0],UVM_FRONTDOOR);
    endtask: tsv_tm_cfg


    task power_up_init(input bit [27:0] init_spine_reset_time = 28'h6_1A7F, input bit[427:0] tsv_tm);
        //input bit [27:0]    init_spine_reset_time_in = 28'h6_1A7F; //1ms
        //input bit           init_spine_reset_time_flag = 0;
    
        bit                 init_start;
        int                 data[14];


        //cfg trim_op_flow:
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.trim_op_flow.write(status,1,UVM_FRONTDOOR);
        
        //cfg tsv_tm: 
        tsv_tm_cfg(tsv_tm);

        //cfg dram_layer-add 0825:
        `ifdef DRAM_6
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.dram_layer_sel.write(status,6'h3f,UVM_FRONTDOOR);
        `else
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.dram_layer_sel.write(status,4'hf,UVM_FRONTDOOR);
        `endif

        //cfg init_spine_reset_time = 1ms:
        p_sequencer.regmodel.DRAM_TRIM_ins.init_spine_resetn_time.init_spine_reset_time.write(status,init_spine_reset_time,UVM_FRONTDOOR);

        //TODO: need to check spine_reset_n keep low time is 1ms;
        //cfg init_start:
        fork
            p_sequencer.regmodel.DRAM_TRIM_ins.trim_op_ctrl.init_start.write(status,1,UVM_FRONTDOOR);
            while(init_start == 0)begin
                @(posedge m_trim_if.clk);
                uvm_hdl_read("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_start_sync", init_start);
                if(init_start)
                    break;
            end
        join

        //check spine_reset_n keep low time is init_spine_reset_time;
        //m_trim_if.init_done_flag = 'h0;
        wait(m_trim_if.fsm_cs=='d1); //init_op
        fork
        begin
            fork
                begin
                    fork: dump_ready_0
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            m_trim_if.init_sp_rst_low_cnt_0++;
                        end
                        begin
                            @(posedge m_trim_if.spine_reset_n[0]);
                            if(m_trim_if.init_sp_rst_low_cnt_0 != init_spine_reset_time+'d1)
                                `uvm_error("power_up_init_task", $sformatf("spine_reset_n[0] is high, but cnt not match, init_sp_rst_low_cnt_0=%0d, init_spine_reset_time=%0d", m_trim_if.init_sp_rst_low_cnt_0, init_spine_reset_time))
                        end
                    join_any
                    disable dump_ready_0;
                    @(posedge m_trim_if.clk);
                    m_trim_if.init_sp_rst_low_cnt_0 = 0;
                    `uvm_info("power_up_init_task", $sformatf("init_spine_reset_n[0] keep init_spine_reset_time low successful."), UVM_LOW)
                end
                begin
                    fork: dump_ready_1
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            m_trim_if.init_sp_rst_low_cnt_1++;
                        end
                        begin
                            @(posedge m_trim_if.spine_reset_n[1]);
                            if(m_trim_if.init_sp_rst_low_cnt_1 != init_spine_reset_time+'d1)
                                `uvm_error("power_up_init_task", $sformatf("spine_reset_n[1] is high, but cnt not match, init_sp_rst_low_cnt_1=%0d, init_spine_reset_time=%0d", m_trim_if.init_sp_rst_low_cnt_1, init_spine_reset_time))
                        end
                    join_any
                    disable dump_ready_1;
                    @(posedge m_trim_if.clk);
                    m_trim_if.init_sp_rst_low_cnt_1 = 0;
                    `uvm_info("power_up_init_task", $sformatf("init_spine_reset_n[1] keep init_spine_reset_time low successful."), UVM_LOW)
                end
                begin
                    fork: dump_ready_2
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            m_trim_if.init_sp_rst_low_cnt_2++;
                        end
                        begin
                            @(posedge m_trim_if.spine_reset_n[2]);
                            if(m_trim_if.init_sp_rst_low_cnt_2 != init_spine_reset_time+'d1)
                                `uvm_error("power_up_init_task", $sformatf("spine_reset_n[2] is high, but cnt not match, init_sp_rst_low_cnt_2=%0d, init_spine_reset_time=%0d", m_trim_if.init_sp_rst_low_cnt_2, init_spine_reset_time))
                        end
                    join_any
                    disable dump_ready_2;
                    @(posedge m_trim_if.clk);
                    m_trim_if.init_sp_rst_low_cnt_2 = 0;
                    `uvm_info("power_up_init_task", $sformatf("init_spine_reset_n[2] keep init_spine_reset_time low successful."), UVM_LOW)
                end
                begin
                    fork: dump_ready_3
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            m_trim_if.init_sp_rst_low_cnt_3++;
                        end
                        begin
                            @(posedge m_trim_if.spine_reset_n[3]);
                            if(m_trim_if.init_sp_rst_low_cnt_3 != init_spine_reset_time+'d1)
                                `uvm_error("power_up_init_task", $sformatf("spine_reset_n[3] is high, but cnt not match, init_sp_rst_low_cnt_3=%0d, init_spine_reset_time=%0d", m_trim_if.init_sp_rst_low_cnt_3, init_spine_reset_time))
                        end
                    join_any
                    disable dump_ready_3;
                    @(posedge m_trim_if.clk);
                    m_trim_if.init_sp_rst_low_cnt_3 = 0;
                    `uvm_info("power_up_init_task", $sformatf("init_spine_reset_n[3] keep init_spine_reset_time low successful."), UVM_LOW)
                    
                end
                `ifdef DRAM_6
                begin
                    fork: dump_ready_4
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            m_trim_if.init_sp_rst_low_cnt_4++;
                        end
                        begin
                            @(posedge m_trim_if.spine_reset_n[4]);
                            if(m_trim_if.init_sp_rst_low_cnt_4 != init_spine_reset_time+'d1)
                                `uvm_error("power_up_init_task", $sformatf("spine_reset_n[4] is high, but cnt not match, init_sp_rst_low_cnt_4=%0d, init_spine_reset_time=%0d", m_trim_if.init_sp_rst_low_cnt_4, init_spine_reset_time))
                        end
                    join_any
                    disable dump_ready_4;
                    @(posedge m_trim_if.clk);
                    m_trim_if.init_sp_rst_low_cnt_4 = 0;
                    `uvm_info("power_up_init_task", $sformatf("init_spine_reset_n[4] keep init_spine_reset_time low successful."), UVM_LOW)
                end
                begin
                    fork: dump_ready_5
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            m_trim_if.init_sp_rst_low_cnt_5++;
                        end
                        begin
                            @(posedge m_trim_if.spine_reset_n[5]);
                            if(m_trim_if.init_sp_rst_low_cnt_5 != init_spine_reset_time+'d1)
                                `uvm_error("power_up_init_task", $sformatf("spine_reset_n[5] is high, but cnt not match, init_sp_rst_low_cnt_5=%0d, init_spine_reset_time=%0d", m_trim_if.init_sp_rst_low_cnt_5, init_spine_reset_time))
                        end
                    join_any
                    disable dump_ready_5;
                    @(posedge m_trim_if.clk);
                    m_trim_if.init_sp_rst_low_cnt_5 = 0;
                    `uvm_info("power_up_init_task", $sformatf("init_spine_reset_n[5] keep init_spine_reset_time low successful."), UVM_LOW)
                end
                `endif
            join
            `uvm_info("power_up_init_task", $sformatf("------have wait spine_reset_n all 1------"), UVM_LOW)

            //read init_done_flag:
            p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.init_done_flag.read(status,rd_data,UVM_FRONTDOOR);
            if(rd_data != 1)
                `uvm_error("power_up_init_task", $sformatf("spine_reset_n been 1, but init_done_flag failed, rd_data=%0h", rd_data))
        end
        join

    endtask: power_up_init

    task sp_rst_force_dump_ready(input bit[`DRAM_LAYER-1:0] sp_rst_force_dp_rdy, input bit[23:0] dump_rdy_timeout_time);
        fork
            if(sp_rst_force_dp_rdy[0]==1)begin
                @(posedge m_trim_if.spine_reset_n[0]);
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[0]", 0);
                fork: pw_up_wait_dp_rdy0
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.power_up_wait_dp_rdy_cnt0 == dump_rdy_timeout_time+'d1)begin
                            if(m_trim_if.dumpready_timeout_ready[0] != 1)
                                `uvm_error("power_up_dp_rdy_timeout_chk", $sformatf("-------dumpready_timeout_ready check failed--------"))

                            break;
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        #1ps;
                        m_trim_if.power_up_wait_dp_rdy_cnt0++;
                    end
                join_any
                disable pw_up_wait_dp_rdy0;
                m_trim_if.power_up_wait_dp_rdy_cnt0 = 0;
            end
            if(sp_rst_force_dp_rdy[1]==1)begin
                @(posedge m_trim_if.spine_reset_n[1]);
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[1]", 0);
                fork: pw_up_wait_dp_rdy1
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.power_up_wait_dp_rdy_cnt1 == dump_rdy_timeout_time+'d1)begin
                            if(m_trim_if.dumpready_timeout_ready[1] != 1)
                                `uvm_error("power_up_dp_rdy_timeout_chk", $sformatf("-------dumpready_timeout_ready check failed--------"))

                            break;
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        #1ps;
                        m_trim_if.power_up_wait_dp_rdy_cnt1++;
                    end
                join_any
                disable pw_up_wait_dp_rdy1;
                m_trim_if.power_up_wait_dp_rdy_cnt1 = 0;
            end
            if(sp_rst_force_dp_rdy[2]==1)begin
                @(posedge m_trim_if.spine_reset_n[2]);
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[2]", 0);
                fork: pw_up_wait_dp_rdy2
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.power_up_wait_dp_rdy_cnt2 == dump_rdy_timeout_time+'d1)begin
                            if(m_trim_if.dumpready_timeout_ready[2] != 1)
                                `uvm_error("power_up_dp_rdy_timeout_chk", $sformatf("-------dumpready_timeout_ready check failed--------"))

                            break;
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        #1ps;
                        m_trim_if.power_up_wait_dp_rdy_cnt2++;
                    end
                join_any
                disable pw_up_wait_dp_rdy2;
                m_trim_if.power_up_wait_dp_rdy_cnt2 = 0;
            end
            if(sp_rst_force_dp_rdy[3]==1)begin
                @(posedge m_trim_if.spine_reset_n[3]);
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[3]", 0);
                fork: pw_up_wait_dp_rdy3
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.power_up_wait_dp_rdy_cnt3 == dump_rdy_timeout_time+'d1)begin
                            if(m_trim_if.dumpready_timeout_ready[3] != 1)
                                `uvm_error("power_up_dp_rdy_timeout_chk", $sformatf("-------dumpready_timeout_ready check failed--------"))

                            break;
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        #1ps;
                        m_trim_if.power_up_wait_dp_rdy_cnt3++;
                    end
                join_any
                disable pw_up_wait_dp_rdy3;
                m_trim_if.power_up_wait_dp_rdy_cnt3 = 0;
            end
            `ifdef DRAM_6
            if(sp_rst_force_dp_rdy[4]==1)begin
                @(posedge m_trim_if.spine_reset_n[4]);
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[4]", 0);
                fork: pw_up_wait_dp_rdy4
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.power_up_wait_dp_rdy_cnt4 == dump_rdy_timeout_time+'d1)begin
                            if(m_trim_if.dumpready_timeout_ready[4] != 1)
                                `uvm_error("power_up_dp_rdy_timeout_chk", $sformatf("-------dumpready_timeout_ready check failed--------"))

                            break;
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        #1ps;
                        m_trim_if.power_up_wait_dp_rdy_cnt4++;
                    end
                join_any
                disable pw_up_wait_dp_rdy4;
                m_trim_if.power_up_wait_dp_rdy_cnt4 = 0;
            end            
            if(sp_rst_force_dp_rdy[5]==1)begin
                @(posedge m_trim_if.spine_reset_n[5]);
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[5]", 0);
                fork: pw_up_wait_dp_rdy5
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.power_up_wait_dp_rdy_cnt5 == dump_rdy_timeout_time+'d1)begin
                            if(m_trim_if.dumpready_timeout_ready[5] != 1)
                                `uvm_error("power_up_dp_rdy_timeout_chk", $sformatf("-------dumpready_timeout_ready check failed--------"))

                            break;
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        #1ps;
                        m_trim_if.power_up_wait_dp_rdy_cnt5++;
                    end
                join_any
                disable pw_up_wait_dp_rdy5;
                m_trim_if.power_up_wait_dp_rdy_cnt5 = 0;
            end
            `endif
        join
    endtask: sp_rst_force_dump_ready

    task power_up_release_dp_rdy(input bit[`DRAM_LAYER-1:0] sp_rst_force_dp_rdy);
        fork
            if(sp_rst_force_dp_rdy[0]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[0]", 1);
                uvm_hdl_release("trim_tb.u_quad_group.dump_ready[0]");
            end
            if(sp_rst_force_dp_rdy[1]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[1]", 1);
                uvm_hdl_release("trim_tb.u_quad_group.dump_ready[1]");
            end
            if(sp_rst_force_dp_rdy[2]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[2]", 1);
                uvm_hdl_release("trim_tb.u_quad_group.dump_ready[2]");
            end
            if(sp_rst_force_dp_rdy[3]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[3]", 1);
                uvm_hdl_release("trim_tb.u_quad_group.dump_ready[3]");
            end
            `ifdef DRAM_6
            if(sp_rst_force_dp_rdy[4]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[4]", 1);
                uvm_hdl_release("trim_tb.u_quad_group.dump_ready[4]");
            end
            if(sp_rst_force_dp_rdy[5]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[5]", 1);
                uvm_hdl_release("trim_tb.u_quad_group.dump_ready[5]");
            end
            `endif
        join
    endtask: power_up_release_dp_rdy


    task re_active_spine_reset_n(input bit[427:0] tsv_tm, input bit[`DRAM_LAYER-1:0] dram_layer_sel_cfg, input bit[9:0] sp_rst_width);
        int             data[14];
        bit             sp_rst_active_rdy;

        `uvm_info("DEBUG", $sformatf("-------DEBUG---111-------"), UVM_LOW)
        //0805//wait(m_trim_if.dump_ready == 4'hf); //add dump_ready jitter
        `ifdef DRAM_6
            do @(posedge m_trim_if.clk);
            while(m_trim_if.dump_ready != 6'h3f);
        `else
            do @(posedge m_trim_if.clk);
            while(m_trim_if.dump_ready != 4'hf);
        `endif

        `uvm_info("DEBUG", $sformatf("-------DEBUG---222-------"), UVM_LOW)
        //wait spine_resetn_active_ready=1
        sp_rst_active_rdy = 0;
        while(sp_rst_active_rdy==0)begin
            p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.spine_resetn_active_ready.read(status,sp_rst_active_rdy,UVM_FRONTDOOR);
        end
        `uvm_info("DEBUG", $sformatf("-------DEBUG---333-------"), UVM_LOW)

        //cfg tsv_tm: 
        tsv_tm_cfg(tsv_tm);        

        //cfg spine_resetn_width(10ns~50ns):
        p_sequencer.regmodel.DRAM_TRIM_ins.spine_resetn_width.spine_resetn_width.write(status,sp_rst_width,UVM_FRONTDOOR);

        //cfg dram_layer_sel:
        //std::randomize(dram_layer_sel_rand) with {dram_layer_sel_rand inside {4'b0001,4'b0010,4'b0100,4'b1000,4'b0011,4'b1111};};
        //dram_layer_sel_rand = 4'b0001; //for debug
        //dram_layer_sel_cfg = dram_layer_sel_rand;
        //`uvm_info("re_active_spine_reset_n_task", $sformatf("cfg dram_layer_sel_cfg = %b", dram_layer_sel_cfg), UVM_LOW)
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.dram_layer_sel.write(status,dram_layer_sel_cfg,UVM_FRONTDOOR);

        //cfg spine_resetn_active:
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_op_ctrl.spine_resetn_active.write(status,1,UVM_FRONTDOOR);

        //chk in case//check spine_reset_n keep low time is cfg's sp_rst_width:
        //chk in case//re_act_sp_keep_low_chk(dram_layer_sel_cfg);

        //chk in case////check tsv_tm:
        //chk in case//if(tsv_tm != m_trim_if.tsv_tm)
        //chk in case//    `uvm_error("re_active_spine_reset_n", $sformatf("tsv check failed, cfg tsv_tm=%0h, m_trim_if.tsv_tm=%0h", tsv_tm, m_trim_if.tsv_tm))

    endtask: re_active_spine_reset_n
    
    task re_act_sp_keep_low_chk(input bit [`DRAM_LAYER-1:0] dram_layer_sel, input bit[9:0]sp_rst_width);
        case(dram_layer_sel)
            'b0001: begin
                re_act_sp_rst_low_time_chk(0, dram_layer_sel, sp_rst_width);
            end
            'b0010: begin
                re_act_sp_rst_low_time_chk(1, dram_layer_sel, sp_rst_width);
            end
            'b0100: begin
                re_act_sp_rst_low_time_chk(2, dram_layer_sel, sp_rst_width);
            end
            'b1000: begin
                re_act_sp_rst_low_time_chk(3, dram_layer_sel, sp_rst_width);
            end
            'b0011: begin
                fork
                    re_act_sp_rst_low_time_chk(0, dram_layer_sel, sp_rst_width);
                    re_act_sp_rst_low_time_chk(1, dram_layer_sel, sp_rst_width);           
                join
            end
            'b1111: begin
                fork
                    re_act_sp_rst_low_time_chk(0, dram_layer_sel, sp_rst_width);
                    re_act_sp_rst_low_time_chk(1, dram_layer_sel, sp_rst_width);
                    re_act_sp_rst_low_time_chk(2, dram_layer_sel, sp_rst_width);
                    re_act_sp_rst_low_time_chk(3, dram_layer_sel, sp_rst_width);
                join    
            end
            `ifdef DRAM_6
            6'b1_0000: begin
                re_act_sp_rst_low_time_chk(4, dram_layer_sel, sp_rst_width);
            end
            6'b10_0000: begin
                re_act_sp_rst_low_time_chk(5, dram_layer_sel, sp_rst_width);
            end
            6'b11_1111: begin
                fork
                    re_act_sp_rst_low_time_chk(0, dram_layer_sel, sp_rst_width);
                    re_act_sp_rst_low_time_chk(1, dram_layer_sel, sp_rst_width);
                    re_act_sp_rst_low_time_chk(2, dram_layer_sel, sp_rst_width);
                    re_act_sp_rst_low_time_chk(3, dram_layer_sel, sp_rst_width);
                    re_act_sp_rst_low_time_chk(4, dram_layer_sel, sp_rst_width);
                    re_act_sp_rst_low_time_chk(5, dram_layer_sel, sp_rst_width);
                join                
            end
            `endif
            default: begin
            end
        endcase        
    endtask: re_act_sp_keep_low_chk
    

    task re_act_sp_rst_low_time_chk(input int layer_sel, input bit[`DRAM_LAYER-1:0] dram_layer_sel, input bit[9:0] sp_rst_width);

        wait(m_trim_if.spine_reset_n!='h0); //add-0808 for hard timeout
        case(layer_sel)
            0: begin
                wait(m_trim_if.spine_reset_n[0]==0);
                fork: sp_rst_low0
                    begin
                        wait(m_trim_if.spine_reset_n[0]==1);
                        if(m_trim_if.sp_rst_low_cnt0 != sp_rst_width+1)
                            `uvm_error("re_act_sp_rst_low_time_chk", $sformatf("sp_rst_low_cnt0 = %0d, sp_rst_width = %0d",m_trim_if.sp_rst_low_cnt0, sp_rst_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.sp_rst_low_cnt0++;
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.fsm_cs != 0 && m_trim_if.fsm_cs != 1)begin //fsm_cs=1: init op
                            sp_rst_chk(dram_layer_sel);
                        end
                    end
                    begin
                        repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            //0725//if(m_trim_if.spine_reset_n[0]==0)begin
                                if(m_trim_if.dump_ready[0] != 0)begin
                                    `uvm_error("re_act_sp_rst_low_time_chk", $sformatf("spine_reset_n be set low, but dump_ready not set 0"))
                                end
                            //0725//end
                        end
                    end
                join_any
                disable sp_rst_low0;    
                m_trim_if.sp_rst_low_cnt0 = 0;   

                fork: sp_rst_dp_rdy0
                    begin
                        wait(m_trim_if.dump_ready[0] == 1);
                        if(m_trim_if.sp_rst_dp_rdy_cnt0 > 'd400_000) //1ms
                            `uvm_error("re_act_sp_rst_low_time_chk", $sformatf("spine_reset_n be 1, after 1ms, dump_ready should be 1"))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.sp_rst_dp_rdy_cnt0++;
                    end
                join_any
                disable sp_rst_dp_rdy0;
                m_trim_if.sp_rst_dp_rdy_cnt0 = 0;

                //0728-hw_op_4 layer re-active not same time, they are serial//repeat(3)@(posedge m_trim_if.clk);
                //0728-hw_op_4 layer re-active not same time, they are serial//if(m_trim_if.dump_ready != 'hf)
                //0728-hw_op_4 layer re-active not same time, they are serial//    `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 1"))
            end
            1: begin
                wait(m_trim_if.spine_reset_n[1]==0);
                fork: sp_rst_low1
                    begin
                        wait(m_trim_if.spine_reset_n[1]==1);
                        if(m_trim_if.sp_rst_low_cnt1 != sp_rst_width+1)
                            `uvm_error("re_active_spine_reset_n_task", $sformatf("sp_rst_low_cnt1 = %0d, sp_rst_width = %0d",m_trim_if.sp_rst_low_cnt1, sp_rst_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.sp_rst_low_cnt1++;
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.fsm_cs != 0 && m_trim_if.fsm_cs != 1)begin //fsm_cs=1: init op
                            sp_rst_chk(dram_layer_sel);
                        end
                    end
                    begin
                        repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            //0725//if(m_trim_if.spine_reset_n[1]==0)begin
                                if(m_trim_if.dump_ready[1] != 0)begin
                                    `uvm_error("re_act_sp_rst_low_time_chk", $sformatf("spine_reset_n be set low, but dump_ready not set 0"))
                                end
                            //0725//end
                        end
                    end
                join_any
                disable sp_rst_low1;
                m_trim_if.sp_rst_low_cnt1 = 0;        

                fork: sp_rst_dp_rdy1
                    begin
                        wait(m_trim_if.dump_ready[1] == 1);
                        if(m_trim_if.sp_rst_dp_rdy_cnt1 > 'd400_000) //1ms
                            `uvm_error("re_act_sp_rst_low_time_chk", $sformatf("spine_reset_n be 1, after 1ms, dump_ready should be 1"))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.sp_rst_dp_rdy_cnt1++;
                    end
                join_any
                disable sp_rst_dp_rdy1;
                m_trim_if.sp_rst_dp_rdy_cnt1 = 0;

                //0728-hw_op_4 layer re-active not same time, they are serial//repeat(3)@(posedge m_trim_if.clk);
                //0728-hw_op_4 layer re-active not same time, they are serial//if(m_trim_if.dump_ready != 'hf)
                //0728-hw_op_4 layer re-active not same time, they are serial//    `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 1"))
            end
            2: begin
                wait(m_trim_if.spine_reset_n[2]==0);
                fork: sp_rst_low2
                    begin
                        wait(m_trim_if.spine_reset_n[2]==1);
                        if(m_trim_if.sp_rst_low_cnt2 != sp_rst_width+1)
                            `uvm_error("re_active_spine_reset_n_task", $sformatf("sp_rst_low_cnt2 = %0d, sp_rst_width = %0d",m_trim_if.sp_rst_low_cnt2, sp_rst_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.sp_rst_low_cnt2++;
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.fsm_cs != 0 && m_trim_if.fsm_cs != 1)begin //fsm_cs=1: init op
                            sp_rst_chk(dram_layer_sel);
                        end
                    end
                    begin
                        repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            //if(m_trim_if.spine_reset_n[2]==0)begin
                                if(m_trim_if.dump_ready[2] != 0)begin
                                    `uvm_error("re_act_sp_rst_low_time_chk", $sformatf("spine_reset_n be set low, but dump_ready not set 0"))
                                end
                            //end
                        end
                    end
                join_any
                disable sp_rst_low2;                
                m_trim_if.sp_rst_low_cnt2 = 0;

                fork: sp_rst_dp_rdy2
                    begin
                        wait(m_trim_if.dump_ready[2] == 1);
                        if(m_trim_if.sp_rst_dp_rdy_cnt2 > 'd400_000) //1ms
                            `uvm_error("re_act_sp_rst_low_time_chk", $sformatf("spine_reset_n be 1, after 1ms, dump_ready should be 1"))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.sp_rst_dp_rdy_cnt2++;
                    end
                join_any
                disable sp_rst_dp_rdy2;
                m_trim_if.sp_rst_dp_rdy_cnt2 = 0;

                //0728-hw_op_4 layer re-active not same time, they are serial//repeat(3)@(posedge m_trim_if.clk);
                //0728-hw_op_4 layer re-active not same time, they are serial//if(m_trim_if.dump_ready != 'hf)
                //0728-hw_op_4 layer re-active not same time, they are serial//    `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 1"))
            end
            3: begin
                wait(m_trim_if.spine_reset_n[3]==0);
                fork: sp_rst_low3
                    begin
                        wait(m_trim_if.spine_reset_n[3]==1);
                        if(m_trim_if.sp_rst_low_cnt3 != sp_rst_width+1)
                            `uvm_error("re_active_spine_reset_n_task", $sformatf("sp_rst_low_cnt3 = %0d, sp_rst_width = %0d",m_trim_if.sp_rst_low_cnt3, sp_rst_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.sp_rst_low_cnt3++;
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.fsm_cs != 0 && m_trim_if.fsm_cs != 1)begin //fsm_cs=1: init op
                            sp_rst_chk(dram_layer_sel);
                        end
                    end
                    begin
                        repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            //0725//if(m_trim_if.spine_reset_n[3]==0)begin
                                if(m_trim_if.dump_ready[3] != 0)begin
                                    `uvm_error("re_act_sp_rst_low_time_chk", $sformatf("spine_reset_n be set low, but dump_ready not set 0"))
                                end
                            //0725//end
                        end
                    end
                join_any
                disable sp_rst_low3;            
                m_trim_if.sp_rst_low_cnt3 = 0;                

                fork: sp_rst_dp_rdy3
                    begin
                        wait(m_trim_if.dump_ready[3] == 1);
                        if(m_trim_if.sp_rst_dp_rdy_cnt3 > 'd400_000) //1ms
                            `uvm_error("re_act_sp_rst_low_time_chk", $sformatf("spine_reset_n be 1, after 1ms, dump_ready should be 1"))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.sp_rst_dp_rdy_cnt3++;
                    end
                join_any
                disable sp_rst_dp_rdy3;
                m_trim_if.sp_rst_dp_rdy_cnt3 = 0;

                //0728-hw_op_4 layer re-active not same time, they are serial//repeat(3)@(posedge m_trim_if.clk);
                //0728-hw_op_4 layer re-active not same time, they are serial//if(m_trim_if.dump_ready != 'hf)
                //0728-hw_op_4 layer re-active not same time, they are serial//    `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 1"))
            end

            `ifdef DRAM_6
             4: begin
                wait(m_trim_if.spine_reset_n[4]==0);
                fork: sp_rst_low4
                    begin
                        wait(m_trim_if.spine_reset_n[4]==1);
                        if(m_trim_if.sp_rst_low_cnt4 != sp_rst_width+1)
                            `uvm_error("re_active_spine_reset_n_task", $sformatf("sp_rst_low_cnt4 = %0d, sp_rst_width = %0d",m_trim_if.sp_rst_low_cnt4, sp_rst_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.sp_rst_low_cnt4++;
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.fsm_cs != 0 && m_trim_if.fsm_cs != 1)begin //fsm_cs=1: init op
                            sp_rst_chk(dram_layer_sel);
                        end
                    end
                    begin
                        repeat(4)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            //0725//if(m_trim_if.spine_reset_n[4]==0)begin
                                if(m_trim_if.dump_ready[4] != 0)begin
                                    `uvm_error("re_act_sp_rst_low_time_chk", $sformatf("spine_reset_n be set low, but dump_ready not set 0"))
                                end
                            //0725//end
                        end
                    end
                join_any
                disable sp_rst_low4;            
                m_trim_if.sp_rst_low_cnt4 = 0;                

                fork: sp_rst_dp_rdy4
                    begin
                        wait(m_trim_if.dump_ready[4] == 1);
                        if(m_trim_if.sp_rst_dp_rdy_cnt4 > 'd400_000) //1ms
                            `uvm_error("re_act_sp_rst_low_time_chk", $sformatf("spine_reset_n be 1, after 1ms, dump_ready should be 1"))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.sp_rst_dp_rdy_cnt4++;
                    end
                join_any
                disable sp_rst_dp_rdy4;
                m_trim_if.sp_rst_dp_rdy_cnt4 = 0;
            end           
            5: begin
                wait(m_trim_if.spine_reset_n[5]==0);
                fork: sp_rst_low5
                    begin
                        wait(m_trim_if.spine_reset_n[5]==1);
                        if(m_trim_if.sp_rst_low_cnt5 != sp_rst_width+1)
                            `uvm_error("re_active_spine_reset_n_task", $sformatf("sp_rst_low_cnt5 = %0d, sp_rst_width = %0d",m_trim_if.sp_rst_low_cnt5, sp_rst_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.sp_rst_low_cnt5++;
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.fsm_cs != 0 && m_trim_if.fsm_cs != 1)begin //fsm_cs=1: init op
                            sp_rst_chk(dram_layer_sel);
                        end
                    end
                    begin
                        repeat(5)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            //0725//if(m_trim_if.spine_reset_n[5]==0)begin
                                if(m_trim_if.dump_ready[5] != 0)begin
                                    `uvm_error("re_act_sp_rst_low_time_chk", $sformatf("spine_reset_n be set low, but dump_ready not set 0"))
                                end
                            //0725//end
                        end
                    end
                join_any
                disable sp_rst_low5;            
                m_trim_if.sp_rst_low_cnt5 = 0;                

                fork: sp_rst_dp_rdy5
                    begin
                        wait(m_trim_if.dump_ready[5] == 1);
                        if(m_trim_if.sp_rst_dp_rdy_cnt5 > 'd400_000) //1ms
                            `uvm_error("re_act_sp_rst_low_time_chk", $sformatf("spine_reset_n be 1, after 1ms, dump_ready should be 1"))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.sp_rst_dp_rdy_cnt5++;
                    end
                join_any
                disable sp_rst_dp_rdy5;
                m_trim_if.sp_rst_dp_rdy_cnt5 = 0;
            end
            `endif
        endcase
    endtask: re_act_sp_rst_low_time_chk

    task sp_rst_chk(input bit[`DRAM_LAYER-1:0] dram_layer_sel);
        case(dram_layer_sel)
            'b0001: begin
                if(m_trim_if.timeout_enable==0)begin
                    `ifdef DRAM_6
                    if(m_trim_if.spine_reset_n != 'b11_1110)
                    `else
                    if(m_trim_if.spine_reset_n != 'b1110)
                    `endif
                        `uvm_error("re_active_spine_reset_n_task", $sformatf("spine_reset_n = %0b", m_trim_if.spine_reset_n))                
                end
            end
            'b0010: begin
                if(m_trim_if.timeout_enable==0)begin
                    `ifdef DRAM_6
                    if(m_trim_if.spine_reset_n != 'b11_1101)
                    `else
                    if(m_trim_if.spine_reset_n != 'b1101)
                    `endif
                        `uvm_error("re_active_spine_reset_n_task", $sformatf("spine_reset_n = %0b", m_trim_if.spine_reset_n))   
                end
            end
            'b0100: begin
                if(m_trim_if.timeout_enable==0)begin
                    `ifdef DRAM_6
                    if(m_trim_if.spine_reset_n != 'b11_1011)
                    `else
                    if(m_trim_if.spine_reset_n != 'b1011)
                    `endif
                        `uvm_error("re_active_spine_reset_n_task", $sformatf("spine_reset_n = %0b", m_trim_if.spine_reset_n))
                end
            end
            'b1000: begin
                if(m_trim_if.timeout_enable==0)begin
                    `ifdef DRAM_6
                    if(m_trim_if.spine_reset_n != 'b11_0111)
                    `else
                    if(m_trim_if.spine_reset_n != 'b0111)
                    `endif
                        `uvm_error("re_active_spine_reset_n_task", $sformatf("spine_reset_n = %0b", m_trim_if.spine_reset_n))
                end
            end
            'b0011: begin
                if(m_trim_if.timeout_enable==0)begin
                    `ifdef DRAM_6
                    if(m_trim_if.spine_reset_n[5:2] != 4'hf)
                    `else
                    if(m_trim_if.spine_reset_n[3:2] != 2'b11)
                    `endif
                        `uvm_error("re_active_spine_reset_n_task", $sformatf("spine_reset_n[3:2] = %0b", m_trim_if.spine_reset_n[3:2]))
                end
            end
            `ifdef DRAM_6
            'b1_0000: begin
                if(m_trim_if.timeout_enable==0)begin
                    if(m_trim_if.spine_reset_n != 'b10_1111)
                        `uvm_error("re_active_spine_reset_n_task", $sformatf("spine_reset_n = %0b", m_trim_if.spine_reset_n))
                end
            end
            'b10_0000: begin
                if(m_trim_if.timeout_enable==0)begin
                    if(m_trim_if.spine_reset_n != 'b01_1111)
                        `uvm_error("re_active_spine_reset_n_task", $sformatf("spine_reset_n = %0b", m_trim_if.spine_reset_n))
                end
            end
            `endif
            default: begin
            end
        endcase
    endtask
    
    //TODO: need to delete this cfg after verilog's dump_ready can be low in re-active spine_reset_n:
    //0725//task re_act_sp_rst_force_dp_rdy(input bit[3:0] dram_layer_sel_cfg);
    //0725//    for(int i=0; i<4; i++)begin
    //0725//        fork
    //0725//            automatic int k=i;
    //0725//            if(dram_layer_sel_cfg[k]==1)begin
    //0725//                wait(m_trim_if.spine_reset_n[k] == 0);
    //0725//                //uvm_hdl_force("trim_tb.m_trim_if.dump_ready[k]", 0);
    //0725//                m_trim_if.dump_ready[k] = 0;
    //0725//                m_trim_if.re_act_sp_rst_force_dp_flag[k] = 1;
    //0725//                wait(m_trim_if.spine_reset_n[k] == 1);
    //0725//                #90us;
    //0725//                m_trim_if.re_act_sp_rst_force_dp_flag[k] = 0;
    //0725//                //uvm_hdl_force("trim_tb.m_trim_if.dump_ready[k]", 1);
    //0725//                //uvm_hdl_release("trim_tb.m_trim_if.dump_ready[k]");         
    //0725//                m_trim_if.dump_ready[k] = 1;
    //0725//            end
    //0725//        join_none
    //0725//    end
    //0725//    wait fork;
    //0725//endtask: re_act_sp_rst_force_dp_rdy

    task redump(input bit[427:0] tsv_tm, input bit[`DRAM_LAYER-1:0] dram_layer_sel_cfg, input bit[9:0] tm_redump_width);
        bit     tm_redump_active_rdy;

        //0805//wait(m_trim_if.dump_ready == 4'hf); //add dump_ready jitter
        `ifdef DRAM_6
            do @(posedge m_trim_if.clk);
            while(m_trim_if.dump_ready != 'h3f);
        `else
            do @(posedge m_trim_if.clk);
            while(m_trim_if.dump_ready != 'hf);
        `endif

        //wait tm_redump_active_ready=1:
        tm_redump_active_rdy = 0;
        while(tm_redump_active_rdy==0)begin
            p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.tm_redump_active_ready.read(status,tm_redump_active_rdy,UVM_FRONTDOOR);
        end

        //cfg tsv_tm
        tsv_tm_cfg(tsv_tm);

        //cfg tm_redump_width(10ns~2560ns):
        p_sequencer.regmodel.DRAM_TRIM_ins.tm_redump_width.tm_redump_width.write(status,tm_redump_width,UVM_FRONTDOOR);

        //cfg dram_layer_sel:
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.dram_layer_sel.write(status,dram_layer_sel_cfg,UVM_FRONTDOOR);

        //cfg tm_redump_active:
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_op_ctrl.tm_redump_active.write(status,1,UVM_FRONTDOOR);

    endtask: redump

    //task redump_chk(input bit[3:0] dram_layer_sel, input bit[9:0] tm_redump_width);
    //    case(dram_layer_sel)
    //        4'b0001: redump_width_chk(0, dram_layer_sel, tm_redump_width);
    //        4'b0010: redump_width_chk(1, dram_layer_sel, tm_redump_width);
    //        4'b0100: redump_width_chk(2, dram_layer_sel, tm_redump_width);
    //        4'b1000: redump_width_chk(3, dram_layer_sel, tm_redump_width);
    //        4'b0011: begin
    //            fork
    //                redump_width_chk(0, dram_layer_sel, tm_redump_width);
    //                redump_width_chk(1, dram_layer_sel, tm_redump_width);
    //            join
    //        end
    //        4'b1111: begin
    //            fork
    //                redump_width_chk(0, dram_layer_sel, tm_redump_width);
    //                redump_width_chk(1, dram_layer_sel, tm_redump_width);
    //                redump_width_chk(2, dram_layer_sel, tm_redump_width);
    //                redump_width_chk(3, dram_layer_sel, tm_redump_width);
    //            join
    //        end
    //    endcase
    //endtask: redump_chk

    task redump_op_chk(input bit[`DRAM_LAYER-1:0] dram_layer_sel, input bit[9:0] tm_redump_width);
        case(dram_layer_sel)
            'b0001: redump_width_chk(0, dram_layer_sel, tm_redump_width);
            'b0010: redump_width_chk(1, dram_layer_sel, tm_redump_width);
            'b0100: redump_width_chk(2, dram_layer_sel, tm_redump_width);
            'b1000: redump_width_chk(3, dram_layer_sel, tm_redump_width);
            'b0011: begin
                fork
                    redump_width_chk(0, dram_layer_sel, tm_redump_width);
                    redump_width_chk(1, dram_layer_sel, tm_redump_width);
                join
            end
            'b1111: begin
                fork
                    redump_width_chk(0, dram_layer_sel, tm_redump_width);
                    redump_width_chk(1, dram_layer_sel, tm_redump_width);
                    redump_width_chk(2, dram_layer_sel, tm_redump_width);
                    redump_width_chk(3, dram_layer_sel, tm_redump_width);
                join
            end
            `ifdef DRAM_6
            'b1_0000:  redump_width_chk(4, dram_layer_sel, tm_redump_width);
            'b10_0000: redump_width_chk(5, dram_layer_sel, tm_redump_width);
            'b11_1111: begin
                fork
                    redump_width_chk(0, dram_layer_sel, tm_redump_width);
                    redump_width_chk(1, dram_layer_sel, tm_redump_width);
                    redump_width_chk(2, dram_layer_sel, tm_redump_width);
                    redump_width_chk(3, dram_layer_sel, tm_redump_width);
                    redump_width_chk(4, dram_layer_sel, tm_redump_width);
                    redump_width_chk(5, dram_layer_sel, tm_redump_width);
                join
            end
            `endif
        endcase
    endtask

    task redump_width_chk(input int layer_sel, input bit[`DRAM_LAYER-1:0] dram_layer_sel, input bit[9:0] tm_redump_width);
        case(layer_sel)
            0: begin
                wait(m_trim_if.tm_redump[0]==1);
                fork: tm_redump0
                    begin
                        wait(m_trim_if.tm_redump[0]==0);
                        if(m_trim_if.tm_redump_cnt0 != tm_redump_width+1)
                            `uvm_error("redump_width_chk", $sformatf("tm_redump keep 1 width check faile, tm_redump_cnt0=%0h, tm_redump_width=%0h", m_trim_if.tm_redump_cnt0, tm_redump_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.tm_redump_cnt0++;
                    end
                    begin
                        //different layer have different delay
                        repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.timeout_enable == 0) dump_ready_other_bit_chk(dram_layer_sel);
                        end
                    end
                join_any
                disable tm_redump0;
                m_trim_if.tm_redump_cnt0 = 0;
                
                fork: dump_ready0
                    #15us; //model actual only wait 15us dump_ready be set 1 after tm_redump negedge
                    //0812//@(posedge m_trim_if.dump_ready[0]);
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.have_reset_flag == 0)begin
                            if(m_trim_if.dump_ready[0] != 0)
                                `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 0"))
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.timeout_enable == 0) dump_ready_other_bit_chk(dram_layer_sel);
                    end
                join_any
                disable dump_ready0;
                @(posedge m_trim_if.dump_ready[0]);
                
                //0725-hw_op_4 layer redump not same time, they are serial////different layer have different delay
                //0725-hw_op_4 layer redump not same time, they are serial//repeat(3)@(posedge m_trim_if.clk);
                //0725-hw_op_4 layer redump not same time, they are serial//if(m_trim_if.dump_ready != 'hf)
                //0725-hw_op_4 layer redump not same time, they are serial//    `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 1"))
            end
            1: begin
                wait(m_trim_if.tm_redump[1]==1);
                fork: tm_redump1
                    begin
                        wait(m_trim_if.tm_redump[1]==0);
                        if(m_trim_if.tm_redump_cnt1 != tm_redump_width+1)
                            `uvm_error("redump_width_chk", $sformatf("tm_redump keep 1 width check faile, tm_redump_cnt1=%0h, tm_redump_width=%0h", m_trim_if.tm_redump_cnt1, tm_redump_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.tm_redump_cnt1++;
                    end
                    begin
                        //different layer have different delay
                        repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.timeout_enable == 0) dump_ready_other_bit_chk(dram_layer_sel);
                        end
                    end
                join_any
                disable tm_redump1;
                m_trim_if.tm_redump_cnt1 = 0;
                
                fork: dump_ready1
                    #15us; //model actual only wait 15us dump_ready be set 1 after tm_redump negedge
                    //0812//@(posedge m_trim_if.dump_ready[1]);
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.have_reset_flag == 0)begin
                            if(m_trim_if.dump_ready[1] != 0)
                                `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 0"))
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.timeout_enable == 0) dump_ready_other_bit_chk(dram_layer_sel);
                    end
                join_any
                disable dump_ready1;
                @(posedge m_trim_if.dump_ready[1]);
                
                //0725-hw_op_4 layer redump not same time, they are serial////different layer have different delay
                //0725-hw_op_4 layer redump not same time, they are serial//repeat(3)@(posedge m_trim_if.clk);
                //0725-hw_op_4 layer redump not same time, they are serial//if(m_trim_if.dump_ready != 'hf)
                //0725-hw_op_4 layer redump not same time, they are serial//    `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 1"))
            end
            2: begin
                wait(m_trim_if.tm_redump[2]==1);
                fork: tm_redump2
                    begin
                        wait(m_trim_if.tm_redump[2]==0);
                        if(m_trim_if.tm_redump_cnt2 != tm_redump_width+1)
                            `uvm_error("redump_width_chk", $sformatf("tm_redump keep 1 width check faile, tm_redump_cnt2=%0h, tm_redump_width=%0h", m_trim_if.tm_redump_cnt2, tm_redump_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.tm_redump_cnt2++;
                    end
                    begin
                        //different layer have different delay
                        repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.timeout_enable == 0) dump_ready_other_bit_chk(dram_layer_sel);
                        end
                    end
                join_any
                disable tm_redump2;
                m_trim_if.tm_redump_cnt2 = 0;
                
                fork: dump_ready2
                    #15us; //model actual only wait 15us dump_ready be set 1 after tm_redump negedge
                    //0812//@(posedge m_trim_if.dump_ready[2]);
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.have_reset_flag == 0)begin
                            if(m_trim_if.dump_ready[2] != 0)
                                `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 0"))
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.timeout_enable == 0) dump_ready_other_bit_chk(dram_layer_sel);
                    end
                join_any
                disable dump_ready2;
                @(posedge m_trim_if.dump_ready[2]);
                
                //0725-hw_op_4 layer redump not same time, they are serial////different layer have different delay
                //0725-hw_op_4 layer redump not same time, they are serial//repeat(3)@(posedge m_trim_if.clk);
                //0725-hw_op_4 layer redump not same time, they are serial//if(m_trim_if.dump_ready != 'hf)
                //0725-hw_op_4 layer redump not same time, they are serial//    `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 1"))
            end
            3: begin
                wait(m_trim_if.tm_redump[3]==1);
                fork: tm_redump3
                    begin
                        wait(m_trim_if.tm_redump[3]==0);
                        if(m_trim_if.tm_redump_cnt3 != tm_redump_width+1)
                            `uvm_error("redump_width_chk", $sformatf("tm_redump keep 1 width check faile, tm_redump_cnt3=%0h, tm_redump_width=%0h", m_trim_if.tm_redump_cnt3, tm_redump_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.tm_redump_cnt3++;
                    end
                    begin
                        //different layer have different delay
                        repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.timeout_enable == 0) dump_ready_other_bit_chk(dram_layer_sel);
                        end
                    end
                join_any
                disable tm_redump3;
                m_trim_if.tm_redump_cnt3 = 0;
                
                fork: dump_ready3
                    #15us; //model actual only wait 15us dump_ready be set 1 after tm_redump negedge
                    //0812//@(posedge m_trim_if.dump_ready[3]);
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.have_reset_flag == 0)begin
                            if(m_trim_if.dump_ready[3] != 0)
                                `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 0"))
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.timeout_enable == 0) dump_ready_other_bit_chk(dram_layer_sel);
                    end
                join_any
                disable dump_ready3;
                @(posedge m_trim_if.dump_ready[3]);
                
                //0725-hw_op_4 layer redump not same time, they are serial////different layer have different delay
                //0725-hw_op_4 layer redump not same time, they are serial//repeat(3)@(posedge m_trim_if.clk);
                //0725-hw_op_4 layer redump not same time, they are serial//if(m_trim_if.dump_ready != 'hf)
                //0725-hw_op_4 layer redump not same time, they are serial//    `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 1"))
            end            
            `ifdef DRAM_6
            4: begin
                wait(m_trim_if.tm_redump[4]==1);
                fork: tm_redump4
                    begin
                        wait(m_trim_if.tm_redump[4]==0);
                        if(m_trim_if.tm_redump_cnt4 != tm_redump_width+1)
                            `uvm_error("redump_width_chk", $sformatf("tm_redump keep 1 width check faile, tm_redump_cnt4=%0h, tm_redump_width=%0h", m_trim_if.tm_redump_cnt4, tm_redump_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.tm_redump_cnt4++;
                    end
                    begin
                        //different layer have different delay
                        repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.timeout_enable == 0) dump_ready_other_bit_chk(dram_layer_sel);
                        end
                    end
                join_any
                disable tm_redump4;
                m_trim_if.tm_redump_cnt4 = 0;
                
                fork: dump_ready4
                    #15us; //model actual only wait 15us dump_ready be set 1 after tm_redump negedge
                    //0812//@(posedge m_trim_if.dump_ready[4]);
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.have_reset_flag == 0)begin
                            if(m_trim_if.dump_ready[4] != 0)
                                `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 0"))
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.timeout_enable == 0) dump_ready_other_bit_chk(dram_layer_sel);
                    end
                join_any
                disable dump_ready4;
                @(posedge m_trim_if.dump_ready[4]);
            end
            5: begin
                wait(m_trim_if.tm_redump[5]==1);
                fork: tm_redump5
                    begin
                        wait(m_trim_if.tm_redump[5]==0);
                        if(m_trim_if.tm_redump_cnt5 != tm_redump_width+1)
                            `uvm_error("redump_width_chk", $sformatf("tm_redump keep 1 width check faile, tm_redump_cnt5=%0h, tm_redump_width=%0h", m_trim_if.tm_redump_cnt5, tm_redump_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.tm_redump_cnt5++;
                    end
                    begin
                        //different layer have different delay
                        repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.timeout_enable == 0) dump_ready_other_bit_chk(dram_layer_sel);
                        end
                    end
                join_any
                disable tm_redump5;
                m_trim_if.tm_redump_cnt5 = 0;
                
                fork: dump_ready5
                    #15us; //model actual only wait 15us dump_ready be set 1 after tm_redump negedge
                    //0812//@(posedge m_trim_if.dump_ready[5]);
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.have_reset_flag == 0)begin
                            if(m_trim_if.dump_ready[5] != 0)
                                `uvm_error("trim_common_vseq", $sformatf("dump_ready check failed, dump_ready should be 0"))
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.timeout_enable == 0) dump_ready_other_bit_chk(dram_layer_sel);
                    end
                join_any
                disable dump_ready5;
                @(posedge m_trim_if.dump_ready[5]);
            end
            `endif
        endcase
    endtask: redump_width_chk


    task dump_ready_other_bit_chk(input bit[`DRAM_LAYER-1:0] dram_layer_sel);
        case(dram_layer_sel)
            'b0001:begin
                if(m_trim_if.have_reset_flag == 0 && m_trim_if.dmp_rdy_force_flag==0)begin
                    `ifdef DRAM_6
                    if(m_trim_if.dump_ready != 'b11_1110)
                    `else
                    if(m_trim_if.dump_ready != 'b1110)
                    `endif
                        `uvm_error("trim_common_vseq",$sformatf("dump_ready other bit chk failed, dump_ready=%0b",m_trim_if.dump_ready))
                end
            end
            'b0010: begin
                if(m_trim_if.have_reset_flag == 0 && m_trim_if.dmp_rdy_force_flag==0)begin
                    `ifdef DRAM_6
                    if(m_trim_if.dump_ready != 'b11_1101)
                    `else
                    if(m_trim_if.dump_ready != 'b1101)
                    `endif
                        `uvm_error("trim_common_vseq",$sformatf("but dump_ready other bit chk failed, dump_ready=%0b",m_trim_if.dump_ready))
                end 
            end
            'b0100: begin
                if(m_trim_if.have_reset_flag == 0 && m_trim_if.dmp_rdy_force_flag==0)begin
                    `ifdef DRAM_6
                    if(m_trim_if.dump_ready != 'b11_1011)
                    `else
                    if(m_trim_if.dump_ready != 'b1011)
                    `endif
                        `uvm_error("trim_common_vseq",$sformatf("but dump_ready other bit chk failed, dump_ready=%0b",m_trim_if.dump_ready))
                end
            end
            'b1000: begin
                if(m_trim_if.have_reset_flag == 0 && m_trim_if.dmp_rdy_force_flag==0)begin
                    `ifdef DRAM_6
                    if(m_trim_if.dump_ready != 'b11_0111)
                    `else
                    if(m_trim_if.dump_ready != 'b0111)
                    `endif
                        `uvm_error("trim_common_vseq",$sformatf("but dump_ready other bit chk failed, dump_ready=%0b",m_trim_if.dump_ready))
                end
            end
            //diff layer have diff delay-0721//'b0011:begin
            //diff layer have diff delay-0721//    if(m_trim_if.dump_ready != 'b1100)
            //diff layer have diff delay-0721//        `uvm_error("trim_common_vseq",$sformatf("but dump_ready other bit chk failed, dump_ready=%0b",m_trim_if.dump_ready))
            //diff layer have diff delay-0721//end
            `ifdef DRAM_6
            'b01_0000: begin
                if(m_trim_if.have_reset_flag == 0 && m_trim_if.dmp_rdy_force_flag==0)begin
                    if(m_trim_if.dump_ready != 'b10_1111)
                        `uvm_error("trim_common_vseq",$sformatf("but dump_ready other bit chk failed, dump_ready=%0b",m_trim_if.dump_ready))
                end
            end
            'b10_0000: begin
                if(m_trim_if.have_reset_flag == 0 && m_trim_if.dmp_rdy_force_flag==0)begin
                    if(m_trim_if.dump_ready != 'b01_1111)
                        `uvm_error("trim_common_vseq",$sformatf("but dump_ready other bit chk failed, dump_ready=%0b",m_trim_if.dump_ready))
                end
            end
            `endif
        endcase
    endtask: dump_ready_other_bit_chk


    task stopwatch_ringo_measurement();
        input bit[427:0]    tsv_tm; 
        input bit[`DRAM_LAYER-1:0]      dram_layer_sel_cfg; 
        input bit[15:0]     stopwatch_period_width;
        input bit[9:0]      tm_redump_width;
        input bit[9:0]      sp_rst_width; 
        input bit           tsv_load_sel;
        
        
        bit                 stopwatch_period_active_ready;
        bit [`DRAM_LAYER-1:0]           stopwatch_ringo_period_ready;

        //reload tsv_tm:
        if(tsv_load_sel)begin
            fork
                redump(tsv_tm, dram_layer_sel_cfg, tm_redump_width);
                redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
            join
        end
        else begin
            fork
                re_active_spine_reset_n(tsv_tm, dram_layer_sel_cfg, sp_rst_width);
                re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);
                //0725//re_act_sp_rst_force_dp_rdy(dram_layer_sel_cfg);
            join
        end

        //check tsv_tm:
        if(m_trim_if.tsv_tm != tsv_tm)
            `uvm_error("trim_redump_vseq", $sformatf("tsv check failed, cfg tsv_tm=%0h, m_trim_if.tsv_tm=%0h", tsv_tm, m_trim_if.tsv_tm))

        #1ms;
        
        //0805//wait(m_trim_if.dump_ready == 4'hf); //add dump_ready jitter
        `ifdef DRAM_6
            do @(posedge m_trim_if.clk);
            while(m_trim_if.dump_ready != 'h3f);
        `else
            do @(posedge m_trim_if.clk);
            while(m_trim_if.dump_ready != 'hf);
        `endif

        m_trim_if.ringo_meas_flag = 1;

        fork: dump_rdy_chk
            begin
                //wait stopwatch_period_active_ready=1:
                stopwatch_period_active_ready = 0;
                while(stopwatch_period_active_ready==0)begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.stopwatch_period_active_ready.read(status,stopwatch_period_active_ready,UVM_FRONTDOOR);
                end

                //cfg stopwatch_period_width(1us~163us):
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_period_width.stopwatch_period_width_ringo.write(status,stopwatch_period_width,UVM_FRONTDOOR);

                //cfg dram_layer_sel:
                p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.dram_layer_sel.write(status,dram_layer_sel_cfg,UVM_FRONTDOOR);
                
                //cfg res_or_ringo_sel=1(ringo clk active):
                p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.res_or_ringo_sel.write(status,1,UVM_FRONTDOOR);

                //cfg stopwatch_period_active=1:
                p_sequencer.regmodel.DRAM_TRIM_ins.trim_op_ctrl.stopwatch_period_active.write(status,1,UVM_FRONTDOOR);

                `uvm_info("DEBUG", $sformatf("---------start read stopwatch_ringo_period_ready-----------"), UVM_LOW)
                //wait stopwatch_ringo_period_ready=1:
                if(m_trim_if.ringo_timeout_en == 0)begin
                    stopwatch_ringo_period_ready = 'h0;
                    case(dram_layer_sel_cfg)
                        'b0001: begin
                            while(stopwatch_ringo_period_ready[0]!=1)begin
                                p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.stopwatch_ringo_period_ready.read(status,stopwatch_ringo_period_ready,UVM_FRONTDOOR);
                            end
                        end
                        'b0010: begin
                            while(stopwatch_ringo_period_ready[1]!=1)begin
                                p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.stopwatch_ringo_period_ready.read(status,stopwatch_ringo_period_ready,UVM_FRONTDOOR);
                            end
                        end
                        'b0100: begin
                            while(stopwatch_ringo_period_ready[2]!=1)begin
                                p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.stopwatch_ringo_period_ready.read(status,stopwatch_ringo_period_ready,UVM_FRONTDOOR);
                            end
                        end
                        'b1000: begin
                            while(stopwatch_ringo_period_ready[3]!=1)begin
                                p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.stopwatch_ringo_period_ready.read(status,stopwatch_ringo_period_ready,UVM_FRONTDOOR);
                            end
                        end
                        'b0011: begin
                            while(stopwatch_ringo_period_ready[1:0]!=2'b11)begin
                                p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.stopwatch_ringo_period_ready.read(status,stopwatch_ringo_period_ready,UVM_FRONTDOOR);
                            end
                        end
                        'b1111: begin
                            while(stopwatch_ringo_period_ready[3:0]!='hf)begin
                                p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.stopwatch_ringo_period_ready.read(status,stopwatch_ringo_period_ready,UVM_FRONTDOOR);
                            end
                        end
                        `ifdef DRAM_6
                        'b01_0000: begin
                            while(stopwatch_ringo_period_ready[4]!=1)begin
                                p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.stopwatch_ringo_period_ready.read(status,stopwatch_ringo_period_ready,UVM_FRONTDOOR);
                            end
                        end
                        'b10_0000: begin
                            while(stopwatch_ringo_period_ready[5]!=1)begin
                                p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.stopwatch_ringo_period_ready.read(status,stopwatch_ringo_period_ready,UVM_FRONTDOOR);
                            end
                        end
                        'b11_1111: begin
                            while(stopwatch_ringo_period_ready!='h3f)begin
                                p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.stopwatch_ringo_period_ready.read(status,stopwatch_ringo_period_ready,UVM_FRONTDOOR);
                            end
                        end
                        `endif
                    endcase
                end
                `uvm_info("DEBUG", $sformatf("---------finish read stopwatch_ringo_period_ready-----------"), UVM_LOW)
            end
            while(1)begin
                @(posedge m_trim_if.clk);
                `ifdef DRAM_6
                if(m_trim_if.dump_ready != 'h3f)begin
                `else
                if(m_trim_if.dump_ready != 4'hf)begin
                `endif
                    `uvm_error("stopwatch_ringo_measurement_task", $sformatf("dump_ready check error, dump_ready=%b", m_trim_if.dump_ready))
                end
            end
        join_any
        disable dump_rdy_chk;

        ////read stopwatch_ringo_period:
        //case(dram_layer_sel_cfg)
        //    4'b0001: p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period0.read(status,ringo_period0,UVM_FRONTDOOR);
        //    4'b0010: p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period1.read(status,ringo_period1,UVM_FRONTDOOR);
        //    4'b0100: p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_23.stopwatch_ringo_period2.read(status,ringo_period2,UVM_FRONTDOOR);
        //    4'b1000: p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_23.stopwatch_ringo_period3.read(status,ringo_period3,UVM_FRONTDOOR);
        //    4'b0011: begin
        //        p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period0.read(status,ringo_period0,UVM_FRONTDOOR);
        //        p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period1.read(status,ringo_period1,UVM_FRONTDOOR);
        //    end
        //    4'b1111: begin
        //        p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period0.read(status,ringo_period0,UVM_FRONTDOOR);
        //        p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period1.read(status,ringo_period1,UVM_FRONTDOOR);
        //        p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_23.stopwatch_ringo_period2.read(status,ringo_period2,UVM_FRONTDOOR);
        //        p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_23.stopwatch_ringo_period3.read(status,ringo_period3,UVM_FRONTDOOR);
        //    end
        //endcase
        
    endtask: stopwatch_ringo_measurement

    task ringo_chk(input bit[`DRAM_LAYER-1:0] dram_layer_sel, input bit[15:0] stopwatch_period_width);
        case(dram_layer_sel)
            'b0001: ringo_period_width_chk(0, dram_layer_sel, stopwatch_period_width);
            'b0010: ringo_period_width_chk(1, dram_layer_sel, stopwatch_period_width);
            'b0100: ringo_period_width_chk(2, dram_layer_sel, stopwatch_period_width);
            'b1000: ringo_period_width_chk(3, dram_layer_sel, stopwatch_period_width);
            'b0011: begin
                fork
                    ringo_period_width_chk(0, dram_layer_sel, stopwatch_period_width);
                    ringo_period_width_chk(1, dram_layer_sel, stopwatch_period_width);
                join
            end
            'b1111: begin
                fork
                    ringo_period_width_chk(0, dram_layer_sel, stopwatch_period_width);
                    ringo_period_width_chk(1, dram_layer_sel, stopwatch_period_width);
                    ringo_period_width_chk(2, dram_layer_sel, stopwatch_period_width);
                    ringo_period_width_chk(3, dram_layer_sel, stopwatch_period_width);
                join
            end
            `ifdef DRAM_6
            'b01_0000: ringo_period_width_chk(4, dram_layer_sel, stopwatch_period_width);
            'b10_0000: ringo_period_width_chk(5, dram_layer_sel, stopwatch_period_width);
            'b11_1111: begin
                fork
                    ringo_period_width_chk(0, dram_layer_sel, stopwatch_period_width);
                    ringo_period_width_chk(1, dram_layer_sel, stopwatch_period_width);
                    ringo_period_width_chk(2, dram_layer_sel, stopwatch_period_width);
                    ringo_period_width_chk(3, dram_layer_sel, stopwatch_period_width);
                    ringo_period_width_chk(4, dram_layer_sel, stopwatch_period_width);
                    ringo_period_width_chk(5, dram_layer_sel, stopwatch_period_width);
                join                
            end
            `endif
        endcase
    endtask: ringo_chk

    task ringo_period_width_chk(input int layer_sel, input bit[`DRAM_LAYER-1:0] dram_layer_sel, input bit[15:0] stopwatch_period_width);
        case(layer_sel)
            0: begin
                wait(m_trim_if.stopwatch_period[0]==1);
                fork: ringo_0
                    begin
                        wait(m_trim_if.stopwatch_period[0]==0);
                        if(m_trim_if.ringo_cnt0 != stopwatch_period_width+1)
                            `uvm_error("ringo_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, ringo_cnt0=%0d, stopwatch_period_width=%0d", m_trim_if.ringo_cnt0, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_cnt0++;
                    end
                    begin
                        //repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.timeout_enable==0)begin
                                stopwatch_period_other_bit_chk(dram_layer_sel);
                            end
                        end
                    end
                join_any
                disable ringo_0;
                m_trim_if.ringo_cnt0 = 0;

                fork: ringo_wait_time_0
                    begin
                        //0813//wait(m_trim_if.stopwatch_ringo[0]==1);
                        //0813//if(m_trim_if.ringo_wait_cnt0 > 'd124) //300ns='d120 clk, 310ns='d124 clk, have delay
                        //0813//    `uvm_error("ringo_period_width_chk", $sformatf("ringo keep 0 width check faile, ringo_wait_cnt0=%0d", m_trim_if.ringo_wait_cnt0))
                        //add 0813:
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.ringo_wait_cnt0=='d110)begin //120 clk = 300ns, dut have 7~8clk delay
                                break;
                            end
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_wait_cnt0++;
                    end
                join_any
                disable ringo_wait_time_0;
                m_trim_if.ringo_wait_cnt0 = 0;

                @(posedge m_trim_if.stopwatch_ringo[0]); //add 0813:
                m_trim_if.ringo_period_cnt0 = 0; //add 0811, hard timeout
                fork: ringo_period_0
                    begin
                        wait(m_trim_if.stopwatch_ringo[0]==0); 
                        #1ps;
                        if(m_trim_if.ringo_period_cnt0 <'d30 || m_trim_if.ringo_period_cnt0>'d500) //0.075us~1.25us
                            `uvm_error("ringo_period_width_chk", $sformatf("ringo_period error, ringo_period_cnt0=%0d", m_trim_if.ringo_period_cnt0))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_period_cnt0++;
                    end
                join_any
                disable ringo_period_0;
                //ringo_period_cnt0 clear in case
            end
            1: begin
                wait(m_trim_if.stopwatch_period[1]==1);
                fork: ringo_1
                    begin
                        wait(m_trim_if.stopwatch_period[1]==0);
                        if(m_trim_if.ringo_cnt1 != stopwatch_period_width+1)
                            `uvm_error("ringo_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, ringo_cnt1=%0d, stopwatch_period_width=%0d", m_trim_if.ringo_cnt1, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_cnt1++;
                    end
                    begin
                        //repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.timeout_enable==0)begin
                                stopwatch_period_other_bit_chk(dram_layer_sel);
                            end
                        end
                    end
                join_any
                disable ringo_1;
                m_trim_if.ringo_cnt1 = 0;

                fork: ringo_wait_time_1
                    begin
                        //0813//wait(m_trim_if.stopwatch_ringo[1]==1);
                        //0813//if(m_trim_if.ringo_wait_cnt1 > 'd124) //300ns='d120 clk, 310ns='d124 clk, have delay
                        //0813//    `uvm_error("ringo_period_width_chk", $sformatf("ringo keep 0 width check faile, ringo_wait_cnt1=%0d", m_trim_if.ringo_wait_cnt1))
                        //add 0813:
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.ringo_wait_cnt1=='d110)begin //300ns, dut have 7~8clk delay
                                break;
                            end
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_wait_cnt1++;
                    end
                join_any
                disable ringo_wait_time_1;
                m_trim_if.ringo_wait_cnt1 = 0;

                @(posedge m_trim_if.stopwatch_ringo[1]); //add 0813
                m_trim_if.ringo_period_cnt1 = 0; //add 0811, hard timeout
                fork: ringo_period_1
                    begin
                        wait(m_trim_if.stopwatch_ringo[1]==0);
                        #1ps;
                        if(m_trim_if.ringo_period_cnt1 <'d30 || m_trim_if.ringo_period_cnt1>'d500) //0.075us~1.25us
                            `uvm_error("ringo_period_width_chk", $sformatf("ringo_period error, ringo_period_cnt1=%0d", m_trim_if.ringo_period_cnt1))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_period_cnt1++;
                    end
                join_any
                disable ringo_period_1;
                //ringo_period_cnt1 clear in case
            end
            2: begin
                wait(m_trim_if.stopwatch_period[2]==1);
                fork: ringo_2
                    begin
                        wait(m_trim_if.stopwatch_period[2]==0);
                        if(m_trim_if.ringo_cnt2 != stopwatch_period_width+1)
                            `uvm_error("ringo_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, ringo_cnt2=%0d, stopwatch_period_width=%0d", m_trim_if.ringo_cnt2, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_cnt2++;
                    end
                    begin
                        //repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.timeout_enable==0)begin
                                stopwatch_period_other_bit_chk(dram_layer_sel);
                            end
                        end
                    end
                join_any
                disable ringo_2;
                m_trim_if.ringo_cnt2 = 0;

                fork: ringo_wait_time_2
                    begin
                        //0813//wait(m_trim_if.stopwatch_ringo[2]==1);
                        //0813//if(m_trim_if.ringo_wait_cnt2 > 'd124) //300ns='d120 clk, 310ns='d124 clk, have delay
                        //0813//    `uvm_error("ringo_period_width_chk", $sformatf("ringo keep 0 width check faile, ringo_wait_cnt2=%0d", m_trim_if.ringo_wait_cnt2))
                        //add 0813:
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.ringo_wait_cnt2=='d110)begin //300ns, dut have 7~8clk delay
                                break;
                            end
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_wait_cnt2++;
                    end
                join_any
                disable ringo_wait_time_2;
                m_trim_if.ringo_wait_cnt2 = 0;

                @(posedge m_trim_if.stopwatch_ringo[2]); //add 0813
                m_trim_if.ringo_period_cnt2 = 0; //add 0811, hard timeout
                fork: ringo_period_2
                    begin
                        wait(m_trim_if.stopwatch_ringo[2]==0);
                        #1ps;
                        if(m_trim_if.ringo_period_cnt2 <'d30 || m_trim_if.ringo_period_cnt2>'d500) //0.075us~1.25us
                            `uvm_error("ringo_period_width_chk", $sformatf("ringo_period error, ringo_period_cnt2=%0d", m_trim_if.ringo_period_cnt2))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_period_cnt2++;
                    end
                join_any
                disable ringo_period_2;
                //ringo_period_cnt1 clear in case
            end

            3: begin
                wait(m_trim_if.stopwatch_period[3]==1);
                fork: ringo_3
                    begin
                        wait(m_trim_if.stopwatch_period[3]==0);
                        if(m_trim_if.ringo_cnt3 != stopwatch_period_width+1)
                            `uvm_error("ringo_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, ringo_cnt3=%0d, stopwatch_period_width=%0d", m_trim_if.ringo_cnt3, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_cnt3++;
                    end
                    begin
                        //repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.timeout_enable==0)begin
                                stopwatch_period_other_bit_chk(dram_layer_sel);
                            end
                        end
                    end
                join_any
                disable ringo_3;
                m_trim_if.ringo_cnt3 = 0;

                fork: ringo_wait_time_3
                    begin
                        //0813//wait(m_trim_if.stopwatch_ringo[3]==1);
                        //0813//if(m_trim_if.ringo_wait_cnt3 > 'd124) //300ns='d120 clk, 310ns='d124 clk, have delay
                        //0813//    `uvm_error("ringo_period_width_chk", $sformatf("ringo keep 0 width check faile, ringo_wait_cnt3=%0d", m_trim_if.ringo_wait_cnt3))
                        //add 0813:
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.ringo_wait_cnt3=='d110)begin //300ns, dut have 7~8clk delay
                                break;
                            end
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_wait_cnt3++;
                    end
                join_any
                disable ringo_wait_time_3;
                m_trim_if.ringo_wait_cnt3 = 0;

                @(posedge m_trim_if.stopwatch_ringo[3]); //add 0813
                m_trim_if.ringo_period_cnt3 = 0; //add 0811, hard timeout
                fork: ringo_period_3
                    begin
                        wait(m_trim_if.stopwatch_ringo[3]==0);
                        #1ps;
                        if(m_trim_if.ringo_period_cnt3 <'d30 || m_trim_if.ringo_period_cnt3>'d500) //0.075us~1.25us
                            `uvm_error("ringo_period_width_chk", $sformatf("ringo_period error, ringo_period_cnt3=%0d", m_trim_if.ringo_period_cnt3))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_period_cnt3++;
                    end
                join_any
                disable ringo_period_3;
                //ringo_period_cnt1 clear in case
            end

            `ifdef DRAM_6
            4: begin
                wait(m_trim_if.stopwatch_period[4]==1);
                fork: ringo_4
                    begin
                        wait(m_trim_if.stopwatch_period[4]==0);
                        if(m_trim_if.ringo_cnt4 != stopwatch_period_width+1)
                            `uvm_error("ringo_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, ringo_cnt4=%0d, stopwatch_period_width=%0d", m_trim_if.ringo_cnt4, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_cnt4++;
                    end
                    begin
                        //repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.timeout_enable==0)begin
                                stopwatch_period_other_bit_chk(dram_layer_sel);
                            end
                        end
                    end
                join_any
                disable ringo_4;
                m_trim_if.ringo_cnt4 = 0;

                fork: ringo_wait_time_4
                    begin
                        //0813//wait(m_trim_if.stopwatch_ringo[4]==1);
                        //0813//if(m_trim_if.ringo_wait_cnt4 > 'd124) //300ns='d120 clk, 310ns='d124 clk, have delay
                        //0813//    `uvm_error("ringo_period_width_chk", $sformatf("ringo keep 0 width check faile, ringo_wait_cnt4=%0d", m_trim_if.ringo_wait_cnt4))
                        //add 0813:
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.ringo_wait_cnt4=='d110)begin //300ns. dut have 7~8 clk delay
                                break;
                            end
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_wait_cnt4++;
                    end
                join_any
                disable ringo_wait_time_4;
                m_trim_if.ringo_wait_cnt4 = 0;

                @(posedge m_trim_if.stopwatch_ringo[4]); //add 0814
                m_trim_if.ringo_period_cnt4 = 0; //add 0811, hard timeout
                fork: ringo_period_4
                    begin
                        wait(m_trim_if.stopwatch_ringo[4]==0);
                        #1ps;
                        if(m_trim_if.ringo_period_cnt4 <'d30 || m_trim_if.ringo_period_cnt4>'d500) //0.075us~1.25us
                            `uvm_error("ringo_period_width_chk", $sformatf("ringo_period error, ringo_period_cnt4=%0d", m_trim_if.ringo_period_cnt4))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_period_cnt4++;
                    end
                join_any
                disable ringo_period_4;
                //ringo_period_cnt1 clear in case
            end
            5: begin
                wait(m_trim_if.stopwatch_period[5]==1);
                fork: ringo_5
                    begin
                        wait(m_trim_if.stopwatch_period[5]==0);
                        if(m_trim_if.ringo_cnt5 != stopwatch_period_width+1)
                            `uvm_error("ringo_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, ringo_cnt5=%0d, stopwatch_period_width=%0d", m_trim_if.ringo_cnt5, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_cnt5++;
                    end
                    begin
                        //repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.timeout_enable==0)begin
                                stopwatch_period_other_bit_chk(dram_layer_sel);
                            end
                        end
                    end
                join_any
                disable ringo_5;
                m_trim_if.ringo_cnt5 = 0;

                fork: ringo_wait_time_5
                    begin
                        //0813//wait(m_trim_if.stopwatch_ringo[5]==1);
                        //0813//if(m_trim_if.ringo_wait_cnt5 > 'd124) //300ns='d120 clk, 310ns='d124 clk, have delay
                        //0813//    `uvm_error("ringo_period_width_chk", $sformatf("ringo keep 0 width check faile, ringo_wait_cnt5=%0d", m_trim_if.ringo_wait_cnt5))
                        //add 0813:
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            if(m_trim_if.ringo_wait_cnt5=='d110)begin //300ns, dut have 7~8 clk delay
                                break;
                            end
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_wait_cnt5++;
                    end
                join_any
                disable ringo_wait_time_5;
                m_trim_if.ringo_wait_cnt5 = 0;

                @(posedge m_trim_if.stopwatch_ringo[5]); //add 0814
                m_trim_if.ringo_period_cnt5 = 0; //add 0811, hard timeout
                fork: ringo_period_5
                    begin
                        wait(m_trim_if.stopwatch_ringo[5]==0);
                        #1ps;
                        if(m_trim_if.ringo_period_cnt5 <'d30 || m_trim_if.ringo_period_cnt5>'d500) //0.075us~1.25us
                            `uvm_error("ringo_period_width_chk", $sformatf("ringo_period error, ringo_period_cnt5=%0d", m_trim_if.ringo_period_cnt5))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_period_cnt5++;
                    end
                join_any
                disable ringo_period_5;
                //ringo_period_cnt1 clear in case
            end
            `endif
        endcase
    endtask: ringo_period_width_chk

    task stopwatch_period_other_bit_chk(input bit[`DRAM_LAYER-1:0] dram_layer_sel);
        case(dram_layer_sel)
            'b0001: begin
                if(m_trim_if.stopwatch_period != 'b0001)
                    `uvm_error("stopwatch_period_other_bit_chk", $sformatf("stopwatch_period other bit check error, stopwatch_period=%b", m_trim_if.stopwatch_period))
            end
            'b0010: begin
                if(m_trim_if.stopwatch_period != 'b0010)
                    `uvm_error("stopwatch_period_other_bit_chk", $sformatf("stopwatch_period other bit check error, stopwatch_period=%b", m_trim_if.stopwatch_period))
            end
            'b0100: begin
                if(m_trim_if.stopwatch_period != 'b0100)
                    `uvm_error("stopwatch_period_other_bit_chk", $sformatf("stopwatch_period other bit check error, stopwatch_period=%b", m_trim_if.stopwatch_period))
            end
            'b1000: begin
                if(m_trim_if.stopwatch_period != 'b1000)
                    `uvm_error("stopwatch_period_other_bit_chk", $sformatf("stopwatch_period other bit check error, stopwatch_period=%b", m_trim_if.stopwatch_period))
            end
            'b0011: begin
                if(m_trim_if.stopwatch_period != 'b0011)
                    `uvm_error("stopwatch_period_other_bit_chk", $sformatf("stopwatch_period other bit check error, stopwatch_period=%b", m_trim_if.stopwatch_period))
            end
            'b1111: begin
                if(m_trim_if.stopwatch_period != 'b1111)
                    `uvm_error("stopwatch_period_other_bit_chk", $sformatf("stopwatch_period other bit check error, stopwatch_period=%b", m_trim_if.stopwatch_period))
            end

            `ifdef DRAM_6
            'b01_0000: begin
                if(m_trim_if.stopwatch_period != 'b01_0000)
                    `uvm_error("stopwatch_period_other_bit_chk", $sformatf("stopwatch_period other bit check error, stopwatch_period=%b", m_trim_if.stopwatch_period))
            end
            'b10_0000: begin
                if(m_trim_if.stopwatch_period != 'b10_0000)
                    `uvm_error("stopwatch_period_other_bit_chk", $sformatf("stopwatch_period other bit check error, stopwatch_period=%b", m_trim_if.stopwatch_period))
            end
            'b11_1111: begin
                if(m_trim_if.stopwatch_period != 'b11_1111)
                    `uvm_error("stopwatch_period_other_bit_chk", $sformatf("stopwatch_period other bit check error, stopwatch_period=%b", m_trim_if.stopwatch_period))
            end
            `endif
        endcase
    endtask: stopwatch_period_other_bit_chk

    task ringo_reg_chk(input bit[`DRAM_LAYER-1:0] dram_layer_sel);
        bit [9:0]    ringo_period0;
        bit [9:0]    ringo_period1;
        bit [9:0]    ringo_period2;
        bit [9:0]    ringo_period3;
        bit [9:0]    ringo_period4;
        bit [9:0]    ringo_period5;

        case(dram_layer_sel)
            'b0001: begin 
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period0.read(status,ringo_period0,UVM_FRONTDOOR);
                //0725//if(ringo_period0 != m_trim_if.ringo_period_cnt0)
                if(((ringo_period0>m_trim_if.ringo_period_cnt0) && ((ringo_period0-m_trim_if.ringo_period_cnt0)>'d2)) ||
                   ((ringo_period0<m_trim_if.ringo_period_cnt0) && ((m_trim_if.ringo_period_cnt0-ringo_period0)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period0 check error, reg:ringo_period0=%0d, input:ringo_period_cnt0=%0d", ringo_period0, m_trim_if.ringo_period_cnt0))
            end
            'b0010: begin
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period1.read(status,ringo_period1,UVM_FRONTDOOR);
                //0725//if(ringo_period1 != m_trim_if.ringo_period_cnt1)
                if(((ringo_period1>m_trim_if.ringo_period_cnt1) && ((ringo_period1-m_trim_if.ringo_period_cnt1)>'d2)) ||
                   ((ringo_period1<m_trim_if.ringo_period_cnt1) && ((m_trim_if.ringo_period_cnt1-ringo_period1)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period1 check error, reg:ringo_period1=%0d, input:ringo_period_cnt1=%0d", ringo_period1, m_trim_if.ringo_period_cnt1))
            end
            'b0100: begin 
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_23.stopwatch_ringo_period2.read(status,ringo_period2,UVM_FRONTDOOR);
                if(((ringo_period2>m_trim_if.ringo_period_cnt2) && ((ringo_period2-m_trim_if.ringo_period_cnt2)>'d2)) ||
                   ((ringo_period2<m_trim_if.ringo_period_cnt2) && ((m_trim_if.ringo_period_cnt2-ringo_period2)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period2 check error, reg:ringo_period2=%0d, input:ringo_period_cnt2=%0d", ringo_period2, m_trim_if.ringo_period_cnt2))
                end
            'b1000: begin
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_23.stopwatch_ringo_period3.read(status,ringo_period3,UVM_FRONTDOOR);
                //0725//if(ringo_period3 != m_trim_if.ringo_period_cnt3)
                if(((ringo_period3>m_trim_if.ringo_period_cnt3) && ((ringo_period3-m_trim_if.ringo_period_cnt3)>'d2)) ||
                   ((ringo_period3<m_trim_if.ringo_period_cnt3) && ((m_trim_if.ringo_period_cnt3-ringo_period3)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period2 check error, reg:ringo_period3=%0d, input:ringo_period_cnt3=%0d", ringo_period3, m_trim_if.ringo_period_cnt3))
            end
            'b0011: begin
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period0.read(status,ringo_period0,UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period1.read(status,ringo_period1,UVM_FRONTDOOR);
                //0725//if(ringo_period0 != m_trim_if.ringo_period_cnt0)
                if(((ringo_period0>m_trim_if.ringo_period_cnt0) && ((ringo_period0-m_trim_if.ringo_period_cnt0)>'d2)) ||
                   ((ringo_period0<m_trim_if.ringo_period_cnt0) && ((m_trim_if.ringo_period_cnt0-ringo_period0)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period0 check error, reg:ringo_period0=%0d, input:ringo_period_cnt0=%0d", ringo_period0, m_trim_if.ringo_period_cnt0))
                //0725//if(ringo_period1 != m_trim_if.ringo_period_cnt1)
                if(((ringo_period1>m_trim_if.ringo_period_cnt1) && ((ringo_period1-m_trim_if.ringo_period_cnt1)>'d2)) ||
                   ((ringo_period1<m_trim_if.ringo_period_cnt1) && ((m_trim_if.ringo_period_cnt1-ringo_period1)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period1 check error, reg:ringo_period1=%0d, input:ringo_period_cnt1=%0d", ringo_period1, m_trim_if.ringo_period_cnt1))
            end
            'b1111: begin
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period0.read(status,ringo_period0,UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period1.read(status,ringo_period1,UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_23.stopwatch_ringo_period2.read(status,ringo_period2,UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_23.stopwatch_ringo_period3.read(status,ringo_period3,UVM_FRONTDOOR);

                if(((ringo_period0>m_trim_if.ringo_period_cnt0) && ((ringo_period0-m_trim_if.ringo_period_cnt0)>'d2)) ||
                   ((ringo_period0<m_trim_if.ringo_period_cnt0) && ((m_trim_if.ringo_period_cnt0-ringo_period0)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period0 check error, reg:ringo_period0=%0d, input:ringo_period_cnt0=%0d", ringo_period0, m_trim_if.ringo_period_cnt0))
                if(((ringo_period1>m_trim_if.ringo_period_cnt1) && ((ringo_period1-m_trim_if.ringo_period_cnt1)>'d2)) ||
                   ((ringo_period1<m_trim_if.ringo_period_cnt1) && ((m_trim_if.ringo_period_cnt1-ringo_period1)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period1 check error, reg:ringo_period1=%0d, input:ringo_period_cnt1=%0d", ringo_period1, m_trim_if.ringo_period_cnt1))
                if(((ringo_period2>m_trim_if.ringo_period_cnt2) && ((ringo_period2-m_trim_if.ringo_period_cnt2)>'d2)) ||
                   ((ringo_period2<m_trim_if.ringo_period_cnt2) && ((m_trim_if.ringo_period_cnt2-ringo_period2)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period2 check error, reg:ringo_period2=%0d, input:ringo_period_cnt2=%0d", ringo_period2, m_trim_if.ringo_period_cnt2))
                if(((ringo_period3>m_trim_if.ringo_period_cnt3) && ((ringo_period3-m_trim_if.ringo_period_cnt3)>'d2)) ||
                   ((ringo_period3<m_trim_if.ringo_period_cnt3) && ((m_trim_if.ringo_period_cnt3-ringo_period3)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period2 check error, reg:ringo_period3=%0d, input:ringo_period_cnt3=%0d", ringo_period3, m_trim_if.ringo_period_cnt3))
            end

            `ifdef DRAM_6
            'b01_0000: begin
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_45.stopwatch_ringo_period4.read(status,ringo_period4,UVM_FRONTDOOR);
                //0725//if(ringo_period4 != m_trim_if.ringo_period_cnt4)
                if(((ringo_period4>m_trim_if.ringo_period_cnt4) && ((ringo_period4-m_trim_if.ringo_period_cnt4)>'d2)) ||
                   ((ringo_period4<m_trim_if.ringo_period_cnt4) && ((m_trim_if.ringo_period_cnt4-ringo_period4)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period4 check error, reg:ringo_period4=%0d, input:ringo_period_cnt4=%0d", ringo_period4, m_trim_if.ringo_period_cnt4))
            end
            'b10_0000: begin
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_45.stopwatch_ringo_period5.read(status,ringo_period5,UVM_FRONTDOOR);
                //0725//if(ringo_period5 != m_trim_if.ringo_period_cnt5)
                if(((ringo_period5>m_trim_if.ringo_period_cnt5) && ((ringo_period5-m_trim_if.ringo_period_cnt5)>'d2)) ||
                   ((ringo_period5<m_trim_if.ringo_period_cnt5) && ((m_trim_if.ringo_period_cnt5-ringo_period5)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period5 check error, reg:ringo_period5=%0d, input:ringo_period_cnt5=%0d", ringo_period5, m_trim_if.ringo_period_cnt5))
            end
            'b11_1111: begin
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period0.read(status,ringo_period0,UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_01.stopwatch_ringo_period1.read(status,ringo_period1,UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_23.stopwatch_ringo_period2.read(status,ringo_period2,UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_23.stopwatch_ringo_period3.read(status,ringo_period3,UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_45.stopwatch_ringo_period4.read(status,ringo_period4,UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_ringo_period_45.stopwatch_ringo_period5.read(status,ringo_period5,UVM_FRONTDOOR);

                if(((ringo_period0>m_trim_if.ringo_period_cnt0) && ((ringo_period0-m_trim_if.ringo_period_cnt0)>'d2)) ||
                   ((ringo_period0<m_trim_if.ringo_period_cnt0) && ((m_trim_if.ringo_period_cnt0-ringo_period0)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period0 check error, reg:ringo_period0=%0d, input:ringo_period_cnt0=%0d", ringo_period0, m_trim_if.ringo_period_cnt0))
                if(((ringo_period1>m_trim_if.ringo_period_cnt1) && ((ringo_period1-m_trim_if.ringo_period_cnt1)>'d2)) ||
                   ((ringo_period1<m_trim_if.ringo_period_cnt1) && ((m_trim_if.ringo_period_cnt1-ringo_period1)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period1 check error, reg:ringo_period1=%0d, input:ringo_period_cnt1=%0d", ringo_period1, m_trim_if.ringo_period_cnt1))
                if(((ringo_period2>m_trim_if.ringo_period_cnt2) && ((ringo_period2-m_trim_if.ringo_period_cnt2)>'d2)) ||
                   ((ringo_period2<m_trim_if.ringo_period_cnt2) && ((m_trim_if.ringo_period_cnt2-ringo_period2)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period2 check error, reg:ringo_period2=%0d, input:ringo_period_cnt2=%0d", ringo_period2, m_trim_if.ringo_period_cnt2))
                if(((ringo_period3>m_trim_if.ringo_period_cnt3) && ((ringo_period3-m_trim_if.ringo_period_cnt3)>'d2)) ||
                   ((ringo_period3<m_trim_if.ringo_period_cnt3) && ((m_trim_if.ringo_period_cnt3-ringo_period3)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period3 check error, reg:ringo_period3=%0d, input:ringo_period_cnt3=%0d", ringo_period3, m_trim_if.ringo_period_cnt3))
                if(((ringo_period4>m_trim_if.ringo_period_cnt4) && ((ringo_period4-m_trim_if.ringo_period_cnt4)>'d2)) ||
                   ((ringo_period4<m_trim_if.ringo_period_cnt4) && ((m_trim_if.ringo_period_cnt4-ringo_period4)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period4 check error, reg:ringo_period4=%0d, input:ringo_period_cnt4=%0d", ringo_period4, m_trim_if.ringo_period_cnt4))
                if(((ringo_period5>m_trim_if.ringo_period_cnt5) && ((ringo_period5-m_trim_if.ringo_period_cnt5)>'d2)) ||
                   ((ringo_period5<m_trim_if.ringo_period_cnt5) && ((m_trim_if.ringo_period_cnt5-ringo_period5)>'d2)))
                    `uvm_error("ringo_reg_chk", $sformatf("ringo_period5 check error, reg:ringo_period5=%0d, input:ringo_period_cnt5=%0d", ringo_period5, m_trim_if.ringo_period_cnt5))
            end
            `endif
        endcase
    endtask: ringo_reg_chk


    task osc_tm_res_sample();
        input bit[427:0]    tsv_tm; 
        input bit[`DRAM_LAYER-1:0]      dram_layer_sel_cfg; 
        input bit[15:0]     stopwatch_period_width;
        input bit[9:0]      tm_redump_width;
        input bit[9:0]      sp_rst_width; 
        input bit           tsv_load_sel;
        
        
        bit                 stopwatch_period_active_ready;
        bit [`DRAM_LAYER-1:0]           osc_tm_res_smp_ready;
        bit [`RES_WIDTH-1:0]           osc_tm_res_smp_value;
        //0722//bit                 tsv_up_sel;
        bit [`DRAM_LAYER-1:0]           dram_layer_sel;

        //reload tsv_tm:
        if(tsv_load_sel)begin
            fork
                redump(tsv_tm, dram_layer_sel_cfg, tm_redump_width);
                redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
            join
        end
        else begin
            fork
                re_active_spine_reset_n(tsv_tm, dram_layer_sel_cfg, sp_rst_width);
                re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);
            join
        end

        //check tsv_tm:
        if(m_trim_if.tsv_tm != tsv_tm)
            `uvm_error("trim_redump_vseq", $sformatf("tsv check failed, cfg tsv_tm=%0h, m_trim_if.tsv_tm=%0h", tsv_tm, m_trim_if.tsv_tm))

        #1ms;
        `ifdef DRAM_6
            wait(m_trim_if.dump_ready == 6'h3f);
        `else
            wait(m_trim_if.dump_ready == 4'hf);
        `endif
        //TODO: check 1,2

        fork: res_dump_rdy_chk
            begin
                //wait stopwatch_period_active_ready=1:
                stopwatch_period_active_ready = 0;
                while(stopwatch_period_active_ready==0)begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.stopwatch_period_active_ready.read(status,stopwatch_period_active_ready,UVM_FRONTDOOR);
                end
                
                //cfg stopwatch_period_width(1us~163us):
                p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_period_width.stopwatch_period_width_res.write(status,stopwatch_period_width,UVM_FRONTDOOR);

                //cfg dram_layer_sel:
                p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.dram_layer_sel.write(status,dram_layer_sel_cfg,UVM_FRONTDOOR);
                
                //cfg res_or_ringo_sel=0(res active):
                p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.res_or_ringo_sel.write(status,0,UVM_FRONTDOOR);

                //cfg stopwatch_period_active=1:
                p_sequencer.regmodel.DRAM_TRIM_ins.trim_op_ctrl.stopwatch_period_active.write(status,1,UVM_FRONTDOOR);

                `uvm_info("DEBUG", $sformatf("-------------start read osc_tm_res_smp_ready---------------"), UVM_LOW)
                //wait osc_tm_res_smp_ready=1:
                osc_tm_res_smp_ready = 'h0;
                case(dram_layer_sel_cfg)
                    'b0001: begin
                        wait(m_trim_if.stopwatch_ringo[0]==1);
                        while(osc_tm_res_smp_ready[0]!=1)begin
                            p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                        end
                    end
                    'b0010: begin
                        wait(m_trim_if.stopwatch_ringo[1]==1);
                        while(osc_tm_res_smp_ready[1]!=1)begin
                            p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                        end
                    end
                    'b0100: begin
                        wait(m_trim_if.stopwatch_ringo[2]==1);
                        while(osc_tm_res_smp_ready[2]!=1)begin
                            p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                        end
                    end
                    'b1000: begin
                        wait(m_trim_if.stopwatch_ringo[3]==1);
                        while(osc_tm_res_smp_ready[3]!=1)begin
                            p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                        end
                    end
                    'b0011: begin
                        wait(m_trim_if.stopwatch_ringo[1:0]==2'b11);
                        while(osc_tm_res_smp_ready[1:0]!=2'b11)begin
                            p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                        end
                    end
                    'b1111: begin
                        wait(m_trim_if.stopwatch_ringo[3:0]=='hf);
                        while(osc_tm_res_smp_ready[3:0]!='hf)begin
                            p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                        end
                    end

                    `ifdef DRAM_6
                    'b01_0000: begin
                        wait(m_trim_if.stopwatch_ringo[4]==1);
                        while(osc_tm_res_smp_ready[4]!=1)begin
                            p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                        end
                    end
                    'b10_0000: begin
                        wait(m_trim_if.stopwatch_ringo[5]==1);
                        while(osc_tm_res_smp_ready[5]!=1)begin
                            p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                        end
                    end
                    'b11_1111: begin
                        wait(m_trim_if.stopwatch_ringo==6'h3f);
                        while(osc_tm_res_smp_ready!=6'h3f)begin
                            p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                        end
                    end
                    `endif
                endcase
                `uvm_info("DEBUG", $sformatf("-------------finish read osc_tm_res_smp_ready---------------"), UVM_LOW)
 
                //read osc_tm_res_smp_value:
                case(dram_layer_sel_cfg)
                    'b0001: wait(m_trim_if.stopwatch_ringo[0] == 1);
                    'b0010: wait(m_trim_if.stopwatch_ringo[1] == 1);
                    'b0100: wait(m_trim_if.stopwatch_ringo[2] == 1);
                    'b1000: wait(m_trim_if.stopwatch_ringo[3] == 1);
                    'b0011: wait(m_trim_if.stopwatch_ringo[1:0] == 2'b11);
                    'b1111: wait(m_trim_if.stopwatch_ringo[3:0] == 4'hf);

                    `ifdef DRAM_6
                    6'b01_0000: wait(m_trim_if.stopwatch_ringo[4] == 1);
                    6'b10_0000: wait(m_trim_if.stopwatch_ringo[5] == 1);
                    6'b11_1111: wait(m_trim_if.stopwatch_ringo == 6'h3f);
                    `endif
                endcase
                repeat(1)@(posedge m_trim_if.clk);
                p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_value.read(status,osc_tm_res_smp_value,UVM_FRONTDOOR);

                //check 4 layer osc_tm_res_value, reg res = dram input res:
                case(dram_layer_sel_cfg)
                    'b0001: begin
                        if(osc_tm_res_smp_value[1:0] != m_trim_if.osc_tm_res[1:0])
                            `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[1:0]=%0h, dram input res: osc_tm_res[1:0]=%0h", osc_tm_res_smp_value[1:0], m_trim_if.osc_tm_res[1:0]))
                        if(m_trim_if.trim_op_flow==0)begin
                            if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                        end
                    end
                    'b0010: begin
                        if(osc_tm_res_smp_value[3:2] != m_trim_if.osc_tm_res[3:2])
                            `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[3:2]=%0h, dram input res: osc_tm_res[3:2]=%0h", osc_tm_res_smp_value[3:2], m_trim_if.osc_tm_res[3:2]))
                        if(m_trim_if.trim_op_flow==0)begin
                            if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                        end
                    end
                    'b0100: begin
                        if(osc_tm_res_smp_value[5:4] != m_trim_if.osc_tm_res[5:4])
                            `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[5:4]=%0h, dram input res: osc_tm_res[5:4]=%0h", osc_tm_res_smp_value[5:4], m_trim_if.osc_tm_res[5:4]))
                        if(m_trim_if.trim_op_flow==0)begin
                            if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                        end
                    end
                    'b1000: begin
                        if(osc_tm_res_smp_value[7:6] != m_trim_if.osc_tm_res[7:6])
                            `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[7:6]=%0h, dram input res: osc_tm_res[7:6]=%0h", osc_tm_res_smp_value[7:6], m_trim_if.osc_tm_res[7:6]))
                        if(m_trim_if.trim_op_flow==0)begin
                            if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                        end
                    end
                    'b0011: begin
                        if(osc_tm_res_smp_value[3:0] != m_trim_if.osc_tm_res[3:0])
                            `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[3:0]=%0h, dram input res: osc_tm_res[3:0]=%0h", osc_tm_res_smp_value[3:0], m_trim_if.osc_tm_res[3:0]))
                        if(m_trim_if.trim_op_flow==0)begin
                            if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                        end
                    end
                    'b1111: begin
                        if(osc_tm_res_smp_value[3:0] != m_trim_if.osc_tm_res[3:0])
                            `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[3:0]=%0h, dram input res: osc_tm_res[3:0]=%0h", osc_tm_res_smp_value[3:0], m_trim_if.osc_tm_res[3:0]))
                        if(m_trim_if.trim_op_flow==0)begin
                            if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                        end
                    end

                    `ifdef DRAM_6
                    6'b01_0000: begin
                        if(osc_tm_res_smp_value[9:8] != m_trim_if.osc_tm_res[9:8])
                            `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[9:8]=%0h, dram input res: osc_tm_res[9:8]=%0h", osc_tm_res_smp_value[9:8], m_trim_if.osc_tm_res[9:8]))
                        if(m_trim_if.trim_op_flow==0)begin
                            if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                        end
                    end
                    6'b10_0000: begin
                        if(osc_tm_res_smp_value[11:10] != m_trim_if.osc_tm_res[11:10])
                            `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[11:10]=%0h, dram input res: osc_tm_res[11:10]=%0h", osc_tm_res_smp_value[11:10], m_trim_if.osc_tm_res[11:10]))
                        if(m_trim_if.trim_op_flow==0)begin
                            if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                        end
                    end
                    6'b11_1111: begin
                        if(osc_tm_res_smp_value != m_trim_if.osc_tm_res)
                            `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value=%0h, dram input res: osc_tm_res=%0h", osc_tm_res_smp_value, m_trim_if.osc_tm_res))
                        if(m_trim_if.trim_op_flow==0)begin
                            if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                        end
                    end
                    `endif
                endcase
            end
            begin
                while(1)begin
                    @(posedge m_trim_if.clk);
                    `ifdef DRAM_6
                    if(m_trim_if.dump_ready != 'h3f)
                    `else
                    if(m_trim_if.dump_ready != 'hf)
                    `endif
                        `uvm_error("osc_tm_res_sample", $sformatf("dump_ready should be all 1 but not, dump_ready = %0h", m_trim_if.dump_ready))
                end
            end
        join_any
        disable res_dump_rdy_chk;        

        #50us;
        m_trim_if.stpwh_prd_res_flag = 'h0;

        //reload tsv_tm:
        case(dram_layer_sel_cfg)
            4'b0001: begin
                tsv_tm[258] = osc_tm_res_smp_value[1];
                tsv_tm[259] = osc_tm_res_smp_value[0];                
                if(tsv_load_sel)begin
                    fork
                        //tsv_tm, dram_layer_sel_cfg, tm_redump_width 
                        redump(tsv_tm, dram_layer_sel_cfg, tm_redump_width);
                        redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
                    join
                end
                else begin
                    fork
                        //tsv_tm, dram_layer_sel_cfg, sp_rst_width
                        re_active_spine_reset_n(tsv_tm, dram_layer_sel_cfg, sp_rst_width);
                        re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);
                        //0725//re_act_sp_rst_force_dp_rdy(dram_layer_sel_cfg);
                    join
                end
            end
            4'b0010: begin
                tsv_tm[258] = osc_tm_res_smp_value[3];
                tsv_tm[259] = osc_tm_res_smp_value[2];                
                if(tsv_load_sel)begin
                    fork
                        //tsv_tm, dram_layer_sel_cfg, tm_redump_width 
                        redump(tsv_tm, dram_layer_sel_cfg, tm_redump_width);
                        redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
                    join
                end
                else begin
                    fork
                        //tsv_tm, dram_layer_sel_cfg, sp_rst_width
                        re_active_spine_reset_n(tsv_tm, dram_layer_sel_cfg, sp_rst_width);
                        re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);
                        //0725//re_act_sp_rst_force_dp_rdy(dram_layer_sel_cfg);
                    join
                end
            end
            4'b0100: begin
                tsv_tm[258] = osc_tm_res_smp_value[5];
                tsv_tm[259] = osc_tm_res_smp_value[4];                
                if(tsv_load_sel)begin
                    fork
                        //tsv_tm, dram_layer_sel_cfg, tm_redump_width 
                        redump(tsv_tm, dram_layer_sel_cfg, tm_redump_width);
                        redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
                    join
                end
                else begin
                    fork
                        //tsv_tm, dram_layer_sel_cfg, sp_rst_width
                        re_active_spine_reset_n(tsv_tm, dram_layer_sel_cfg, sp_rst_width);
                        re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);
                        //0725//re_act_sp_rst_force_dp_rdy(dram_layer_sel_cfg);
                    join
                end
            end
            4'b1000: begin
                tsv_tm[258] = osc_tm_res_smp_value[7];
                tsv_tm[259] = osc_tm_res_smp_value[6];                
                if(tsv_load_sel)begin
                    fork
                        //tsv_tm, dram_layer_sel_cfg, tm_redump_width 
                        redump(tsv_tm, dram_layer_sel_cfg, tm_redump_width);
                        redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
                    join
                end
                else begin
                    fork
                        //tsv_tm, dram_layer_sel_cfg, sp_rst_width
                        re_active_spine_reset_n(tsv_tm, dram_layer_sel_cfg, sp_rst_width);
                        re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);
                        //0725//re_act_sp_rst_force_dp_rdy(dram_layer_sel_cfg);
                    join
                end
            end
            4'b0011: begin
                //2 layer res value are same:
                if(osc_tm_res_smp_value[1:0]==osc_tm_res_smp_value[3:2])begin
                    tsv_tm[258] = osc_tm_res_smp_value[1];
                    tsv_tm[259] = osc_tm_res_smp_value[0];                    
                    randcase
                        1: begin //one time up tsv_tm:
                            `uvm_info("osc_tm_res_sample_task", $sformatf("--------enter one time up tsv_tm--------"), UVM_LOW)
                            if(tsv_load_sel)begin
                                fork
                                    //tsv_tm, dram_layer_sel_cfg, tm_redump_width 
                                    redump(tsv_tm, 4'b0011, tm_redump_width);
                                    redump_op_chk(4'b0011, tm_redump_width);
                                join
                            end
                            else begin
                                fork
                                    //tsv_tm, dram_layer_sel_cfg, sp_rst_width
                                    re_active_spine_reset_n(tsv_tm, 4'b0011, sp_rst_width);
                                    re_act_sp_keep_low_chk(4'b0011, sp_rst_width);
                                    //0725//re_act_sp_rst_force_dp_rdy(4'b0011);
                                join
                            end
                        end
                        1: begin //multi time up tsv_tm:
                            `uvm_info("osc_tm_res_sample_task", $sformatf("--------enter multi time up tsv_tm--------"), UVM_LOW)
                            res_value_load(2, tsv_tm, tm_redump_width, sp_rst_width, osc_tm_res_smp_value, tsv_load_sel);
                        end
                    endcase
                end

                //2 layer res value are different:
                if(osc_tm_res_smp_value[1:0]!=osc_tm_res_smp_value[3:2])begin
                    res_value_load(2, tsv_tm, tm_redump_width, sp_rst_width, osc_tm_res_smp_value, tsv_load_sel);
                end                  
            end
            4'b1111: begin
                //4 layer res value are same:
                if((osc_tm_res_smp_value[1:0]==osc_tm_res_smp_value[3:2]) && 
                   (osc_tm_res_smp_value[1:0]==osc_tm_res_smp_value[5:4]) && 
                   (osc_tm_res_smp_value[1:0]==osc_tm_res_smp_value[7:6])) begin
                    tsv_tm[258] = osc_tm_res_smp_value[1];
                    tsv_tm[259] = osc_tm_res_smp_value[0];
                    randcase
                        1: begin //one time up tsv_tm:
                            `uvm_info("osc_tm_res_sample_task", $sformatf("--------enter one time up tsv_tm--------"), UVM_LOW)
                            if(tsv_load_sel)begin
                                fork
                                    //tsv_tm, dram_layer_sel_cfg, tm_redump_width 
                                    redump(tsv_tm, 4'hf, tm_redump_width);
                                    redump_op_chk(4'hf, tm_redump_width);
                                join
                            end
                            else begin
                                fork
                                    //tsv_tm, dram_layer_sel_cfg, sp_rst_width
                                    re_active_spine_reset_n(tsv_tm, 4'hf, sp_rst_width);
                                    re_act_sp_keep_low_chk(4'hf, sp_rst_width);
                                    //0725//re_act_sp_rst_force_dp_rdy(4'hf);
                                join
                            end
                        end
                        1: begin //multi time up tsv_tm:
                            `uvm_info("osc_tm_res_sample_task", $sformatf("--------enter multi time up tsv_tm--------"), UVM_LOW)
                            res_value_load(4, tsv_tm, tm_redump_width, sp_rst_width, osc_tm_res_smp_value, tsv_load_sel);
                        end
                    endcase
                end

                //4 layer res value are different:
                if((osc_tm_res_smp_value[1:0]!=osc_tm_res_smp_value[3:2]) || 
                   (osc_tm_res_smp_value[1:0]!=osc_tm_res_smp_value[5:4]) || 
                   (osc_tm_res_smp_value[1:0]!=osc_tm_res_smp_value[7:6]) ||
                   (osc_tm_res_smp_value[3:2]!=osc_tm_res_smp_value[5:4]) ||
                   (osc_tm_res_smp_value[3:2]!=osc_tm_res_smp_value[7:6]) ||
                   (osc_tm_res_smp_value[5:4]!=osc_tm_res_smp_value[7:6]))begin

                    `uvm_info("DEBUG", $sformatf("-----------enter different res-----------"), UVM_LOW)
                    res_value_load(4, tsv_tm, tm_redump_width, sp_rst_width, osc_tm_res_smp_value, tsv_load_sel); 
                end
            end
            
            `ifdef DRAM_6
            6'b01_0000: begin
                tsv_tm[258] = osc_tm_res_smp_value[9];
                tsv_tm[259] = osc_tm_res_smp_value[8];                
                if(tsv_load_sel)begin
                    fork
                        //tsv_tm, dram_layer_sel_cfg, tm_redump_width 
                        redump(tsv_tm, dram_layer_sel_cfg, tm_redump_width);
                        redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
                    join
                end
                else begin
                    fork
                        //tsv_tm, dram_layer_sel_cfg, sp_rst_width
                        re_active_spine_reset_n(tsv_tm, dram_layer_sel_cfg, sp_rst_width);
                        re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);
                        //0725//re_act_sp_rst_force_dp_rdy(dram_layer_sel_cfg);
                    join
                end
            end
            6'b10_0000: begin
                tsv_tm[258] = osc_tm_res_smp_value[11];
                tsv_tm[259] = osc_tm_res_smp_value[10];                
                if(tsv_load_sel)begin
                    fork
                        //tsv_tm, dram_layer_sel_cfg, tm_redump_width 
                        redump(tsv_tm, dram_layer_sel_cfg, tm_redump_width);
                        redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
                    join
                end
                else begin
                    fork
                        //tsv_tm, dram_layer_sel_cfg, sp_rst_width
                        re_active_spine_reset_n(tsv_tm, dram_layer_sel_cfg, sp_rst_width);
                        re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);
                        //0725//re_act_sp_rst_force_dp_rdy(dram_layer_sel_cfg);
                    join
                end
            end            
            6'b11_1111: begin
                //4 layer res value are same:
                if((osc_tm_res_smp_value[1:0]==osc_tm_res_smp_value[3:2]) && 
                   (osc_tm_res_smp_value[1:0]==osc_tm_res_smp_value[5:4]) && 
                   (osc_tm_res_smp_value[1:0]==osc_tm_res_smp_value[7:6]) &&
                   (osc_tm_res_smp_value[1:0]==osc_tm_res_smp_value[9:8]) && 
                   (osc_tm_res_smp_value[1:0]==osc_tm_res_smp_value[11:10])) begin
                    tsv_tm[258] = osc_tm_res_smp_value[1];
                    tsv_tm[259] = osc_tm_res_smp_value[0];
                    randcase
                        1: begin //one time up tsv_tm:
                            `uvm_info("osc_tm_res_sample_task", $sformatf("--------enter one time up tsv_tm--------"), UVM_LOW)
                            if(tsv_load_sel)begin
                                fork
                                    //tsv_tm, dram_layer_sel_cfg, tm_redump_width 
                                    redump(tsv_tm, 6'h3f, tm_redump_width);
                                    redump_op_chk(6'h3f, tm_redump_width);
                                join
                            end
                            else begin
                                fork
                                    //tsv_tm, dram_layer_sel_cfg, sp_rst_width
                                    re_active_spine_reset_n(tsv_tm, 6'h3f, sp_rst_width);
                                    re_act_sp_keep_low_chk(6'h3f, sp_rst_width);
                                    //0725//re_act_sp_rst_force_dp_rdy(4'hf);
                                join
                            end
                        end
                        1: begin //multi time up tsv_tm:
                            `uvm_info("osc_tm_res_sample_task", $sformatf("--------enter multi time up tsv_tm--------"), UVM_LOW)
                            res_value_load(6, tsv_tm, tm_redump_width, sp_rst_width, osc_tm_res_smp_value, tsv_load_sel);
                        end
                    endcase
                end

                //6 layer res value are different:
                if((osc_tm_res_smp_value[1:0]!=osc_tm_res_smp_value[3:2]) || 
                   (osc_tm_res_smp_value[1:0]!=osc_tm_res_smp_value[5:4]) || 
                   (osc_tm_res_smp_value[1:0]!=osc_tm_res_smp_value[7:6]) ||
                   (osc_tm_res_smp_value[1:0]!=osc_tm_res_smp_value[9:8]) ||
                   (osc_tm_res_smp_value[1:0]!=osc_tm_res_smp_value[11:10]) ||
                   (osc_tm_res_smp_value[3:2]!=osc_tm_res_smp_value[5:4]) ||
                   (osc_tm_res_smp_value[3:2]!=osc_tm_res_smp_value[7:6]) ||
                   (osc_tm_res_smp_value[3:2]!=osc_tm_res_smp_value[9:8]) ||
                   (osc_tm_res_smp_value[3:2]!=osc_tm_res_smp_value[11:10]) ||
                   (osc_tm_res_smp_value[5:4]!=osc_tm_res_smp_value[7:6]) ||
                   (osc_tm_res_smp_value[5:4]!=osc_tm_res_smp_value[9:8]) ||
                   (osc_tm_res_smp_value[5:4]!=osc_tm_res_smp_value[11:10]) ||
                   (osc_tm_res_smp_value[7:6]!=osc_tm_res_smp_value[9:8]) ||
                   (osc_tm_res_smp_value[7:6]!=osc_tm_res_smp_value[11:10]) ||
                   (osc_tm_res_smp_value[9:8]!=osc_tm_res_smp_value[11:10]))begin

                    `uvm_info("DEBUG", $sformatf("-----------enter different res-----------"), UVM_LOW)
                    res_value_load(6, tsv_tm, tm_redump_width, sp_rst_width, osc_tm_res_smp_value, tsv_load_sel); 
                end
            end
            `endif
        endcase
    endtask: osc_tm_res_sample

    task res_value_load();
        input int           layer_num;
        input bit[427:0]    tsv_tm;
        input bit[9:0]      tm_redump_width;
        input bit[9:0]      sp_rst_width;
        input bit[`RES_WIDTH-1:0]      osc_tm_res_smp_value;
        input bit           tsv_load_sel;

        bit [`DRAM_LAYER-1:0]   dram_layer_select = 'h0;

        for(int i=0; i<layer_num; i++)begin
            tsv_tm[258] = osc_tm_res_smp_value[i*2+1];
            tsv_tm[259] = osc_tm_res_smp_value[i*2];                
            dram_layer_select[i] = 1;
            if(tsv_load_sel)begin
                fork
                    //tsv_tm, dram_layer_sel_cfg, tm_redump_width 
                    redump(tsv_tm, dram_layer_select, tm_redump_width);
                    redump_op_chk(dram_layer_select, tm_redump_width);
                join
            end
            else begin
                fork
                    //tsv_tm, dram_layer_sel_cfg, sp_rst_width
                    re_active_spine_reset_n(tsv_tm, dram_layer_select, sp_rst_width);
                    re_act_sp_keep_low_chk(dram_layer_select, sp_rst_width);
                    //0725//re_act_sp_rst_force_dp_rdy(dram_layer_select);
                join
            end
            dram_layer_select[i] = 0; 
        end
    endtask: res_value_load

    task res_sample_chk(input bit[`DRAM_LAYER-1:0] dram_layer_sel, input bit[15:0] stopwatch_period_width);
        case(dram_layer_sel)
            4'b0001: res_period_width_chk(0, dram_layer_sel, stopwatch_period_width);
            4'b0010: res_period_width_chk(1, dram_layer_sel, stopwatch_period_width);
            4'b0100: res_period_width_chk(2, dram_layer_sel, stopwatch_period_width);
            4'b1000: res_period_width_chk(3, dram_layer_sel, stopwatch_period_width);
            4'b0011: begin
                fork
                    res_period_width_chk(0, dram_layer_sel, stopwatch_period_width);
                    res_period_width_chk(1, dram_layer_sel, stopwatch_period_width);
                join
            end
            4'b1111: begin
                fork
                    res_period_width_chk(0, dram_layer_sel, stopwatch_period_width);
                    res_period_width_chk(1, dram_layer_sel, stopwatch_period_width);
                    res_period_width_chk(2, dram_layer_sel, stopwatch_period_width);
                    res_period_width_chk(3, dram_layer_sel, stopwatch_period_width);
                join
            end

            `ifdef DRAM_6
            6'b01_0000: res_period_width_chk(4, dram_layer_sel, stopwatch_period_width);
            6'b10_0000: res_period_width_chk(5, dram_layer_sel, stopwatch_period_width);
            6'b11_1111: begin
                fork
                    res_period_width_chk(0, dram_layer_sel, stopwatch_period_width);
                    res_period_width_chk(1, dram_layer_sel, stopwatch_period_width);
                    res_period_width_chk(2, dram_layer_sel, stopwatch_period_width);
                    res_period_width_chk(3, dram_layer_sel, stopwatch_period_width);
                    res_period_width_chk(4, dram_layer_sel, stopwatch_period_width);
                    res_period_width_chk(5, dram_layer_sel, stopwatch_period_width);
                join
            end
            `endif
        endcase
    endtask: res_sample_chk

    task res_period_width_chk(input int layer_sel, input bit[`DRAM_LAYER-1:0] dram_layer_sel, input bit[15:0] stopwatch_period_width);
        case(layer_sel)
            0: begin
                //0731//wait(m_trim_if.stopwatch_period[0]==1);
                @(posedge m_trim_if.stopwatch_period[0]);
                m_trim_if.stpwh_prd_res_flag[0] = 1;
                fork: res_0
                    begin
                        //0731//wait(m_trim_if.stopwatch_period[0]==0);
                        @(negedge m_trim_if.stopwatch_period[0]);
                        if(m_trim_if.res_cnt0 != stopwatch_period_width+1)
                            `uvm_error("res_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, res_cnt0=%0d, stopwatch_period_width=%0d", m_trim_if.res_cnt0, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.res_cnt0++;
                    end
                    begin
                        //repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            stopwatch_period_other_bit_chk(dram_layer_sel);
                        end
                    end
                join_any
                disable res_0;
                m_trim_if.res_cnt0 = 0;

                fork: res_wait_time_0
                    begin
                        //0731//wait(m_trim_if.stopwatch_ringo[0]==1);
                        @(posedge m_trim_if.stopwatch_ringo[0]);
                        //res not sure the time of stopwatch_period=0 to stopwatch_ringo=1:
                        //0731//if(m_trim_if.res_wait_cnt0 < 'd120) //300ns='d120 clk, 310ns='d124 clk, have delay
                        //0731//    `uvm_error("res_period_width_chk", $sformatf("ringo keep 0 width check faile, res_wait_cnt0=%0d", m_trim_if.res_wait_cnt0))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.res_wait_cnt0++;
                    end
                join_any
                disable res_wait_time_0;
                m_trim_if.res_wait_cnt0 = 0;
            end

            1: begin
                //0731//wait(m_trim_if.stopwatch_period[1]==1);
                @(posedge m_trim_if.stopwatch_period[1]);
                m_trim_if.stpwh_prd_res_flag[1] = 1;
                fork: res_1
                    begin
                        //0731//wait(m_trim_if.stopwatch_period[1]==0);
                        @(negedge m_trim_if.stopwatch_period[1]);
                        if(m_trim_if.res_cnt1 != stopwatch_period_width+1)
                            `uvm_error("res_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, res_cnt1=%0d, stopwatch_period_width=%0d", m_trim_if.res_cnt1, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.res_cnt1++;
                    end
                    begin
                        //repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            stopwatch_period_other_bit_chk(dram_layer_sel);
                        end
                    end
                join_any
                disable res_1;
                m_trim_if.res_cnt1 = 0;

                fork: res_wait_time_1
                    begin
                        //0731//wait(m_trim_if.stopwatch_ringo[1]==1);
                        @(posedge m_trim_if.stopwatch_ringo[1]);
                        //res not sure the time of stopwatch_period=0 to stopwatch_ringo=1:
                        //0731//if(m_trim_if.res_wait_cnt1 < 'd120) //300ns='d120 clk, 310ns='d124 clk, have delay
                        //0731//    `uvm_error("res_period_width_chk", $sformatf("ringo keep 0 width check faile, res_wait_cnt1=%0d", m_trim_if.res_wait_cnt1))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.res_wait_cnt1++;
                    end
                join_any
                disable res_wait_time_1;
                m_trim_if.res_wait_cnt1 = 0;
            end

            2: begin
                //0731//wait(m_trim_if.stopwatch_period[2]==1);
                @(posedge m_trim_if.stopwatch_period[2]);
                m_trim_if.stpwh_prd_res_flag[2] = 1;
                fork: res_2
                    begin
                        //0731//wait(m_trim_if.stopwatch_period[2]==0);
                        @(negedge m_trim_if.stopwatch_period[2]);
                        if(m_trim_if.res_cnt2 != stopwatch_period_width+1)
                            `uvm_error("res_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, res_cnt2=%0d, stopwatch_period_width=%0d", m_trim_if.res_cnt2, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.res_cnt2++;
                    end
                    begin
                        //repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            stopwatch_period_other_bit_chk(dram_layer_sel);
                        end
                    end
                join_any
                disable res_2;
                m_trim_if.res_cnt2 = 0;

                fork: res_wait_time_2
                    begin
                        //0731//wait(m_trim_if.stopwatch_ringo[2]==1);
                        @(posedge m_trim_if.stopwatch_ringo[2]);
                        //res not sure the time of stopwatch_period=0 to stopwatch_ringo=1:
                        //0731//if(m_trim_if.res_wait_cnt2 < 'd120) //300ns='d120 clk, 310ns='d124 clk, have delay
                        //0731//    `uvm_error("res_period_width_chk", $sformatf("ringo keep 0 width check faile, res_wait_cnt2=%0d", m_trim_if.res_wait_cnt2))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.res_wait_cnt2++;
                    end
                join_any
                disable res_wait_time_2;
                m_trim_if.res_wait_cnt2 = 0;
            end

            3: begin
                //0731//wait(m_trim_if.stopwatch_period[3]==1);
                @(posedge m_trim_if.stopwatch_period[3]);
                m_trim_if.stpwh_prd_res_flag[3] = 1;
                fork: res_3
                    begin
                        //0731//wait(m_trim_if.stopwatch_period[3]==0);
                        @(negedge m_trim_if.stopwatch_period[3]);
                        if(m_trim_if.res_cnt3 != stopwatch_period_width+1)
                            `uvm_error("res_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, res_cnt3=%0d, stopwatch_period_width=%0d", m_trim_if.res_cnt3, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.res_cnt3++;
                    end
                    begin
                        //repeat(3)@(posedge m_trim_if.clk);
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            stopwatch_period_other_bit_chk(dram_layer_sel);
                        end
                    end
                join_any
                disable res_3;
                m_trim_if.res_cnt3 = 0;

                fork: res_wait_time_3
                    begin
                        //0731//wait(m_trim_if.stopwatch_ringo[3]==1);
                        @(posedge m_trim_if.stopwatch_ringo[3]);
                        //res not sure the time of stopwatch_period=0 to stopwatch_ringo=1:
                        //0731//if(m_trim_if.res_wait_cnt3 < 'd120) //300ns='d120 clk, 310ns='d124 clk, have delay
                        //0731//    `uvm_error("res_period_width_chk", $sformatf("ringo keep 0 width check faile, res_wait_cnt3=%0d", m_trim_if.res_wait_cnt3))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.res_wait_cnt3++;
                    end
                join_any
                disable res_wait_time_3;
                m_trim_if.res_wait_cnt3 = 0;
            end

            `ifdef DRAM_6
            4: begin
                @(posedge m_trim_if.stopwatch_period[4]);
                m_trim_if.stpwh_prd_res_flag[4] = 1;
                fork: res_4
                    begin
                        @(negedge m_trim_if.stopwatch_period[4]);
                        if(m_trim_if.res_cnt4 != stopwatch_period_width+1)
                            `uvm_error("res_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, res_cnt4=%0d, stopwatch_period_width=%0d", m_trim_if.res_cnt4, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.res_cnt4++;
                    end
                    begin
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            stopwatch_period_other_bit_chk(dram_layer_sel);
                        end
                    end
                join_any
                disable res_4;
                m_trim_if.res_cnt4 = 0;

                fork: res_wait_time_4
                    begin
                        @(posedge m_trim_if.stopwatch_ringo[4]);
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.res_wait_cnt4++;
                    end
                join_any
                disable res_wait_time_4;
                m_trim_if.res_wait_cnt4 = 0;
            end            

            5: begin
                @(posedge m_trim_if.stopwatch_period[5]);
                m_trim_if.stpwh_prd_res_flag[5] = 1;
                fork: res_5
                    begin
                        @(negedge m_trim_if.stopwatch_period[5]);
                        if(m_trim_if.res_cnt5 != stopwatch_period_width+1)
                            `uvm_error("res_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, res_cnt5=%0d, stopwatch_period_width=%0d", m_trim_if.res_cnt5, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.res_cnt5++;
                    end
                    begin
                        while(1)begin
                            @(posedge m_trim_if.clk);
                            stopwatch_period_other_bit_chk(dram_layer_sel);
                        end
                    end
                join_any
                disable res_5;
                m_trim_if.res_cnt5 = 0;

                fork: res_wait_time_5
                    begin
                        @(posedge m_trim_if.stopwatch_ringo[5]);
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.res_wait_cnt5++;
                    end
                join_any
                disable res_wait_time_5;
                m_trim_if.res_wait_cnt5 = 0;
            end
            `endif
        endcase
    endtask: res_period_width_chk


    task hw_op_cfg();
        input bit [27:0]     init_spine_reset_time;
        input bit [9:0]      sp_rst_width;
        input bit [9:0]      tm_redump_width;
        input bit [15:0]     stopwatch_period_width_ringo;
        input bit [15:0]     stopwatch_period_width_res;
        input bit            hw_op_ringo_mask;
        input bit [`DRAM_LAYER-1:0]      dram_layer_sel_cfg;
        input bit            hw_op_tsv_load_sel; //0:redump load, 1: spine_reset_n load


        p_sequencer.regmodel.DRAM_TRIM_ins.init_spine_resetn_time.init_spine_reset_time.write(status,init_spine_reset_time,UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.spine_resetn_width.spine_resetn_width.write(status,sp_rst_width,UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.tm_redump_width.tm_redump_width.write(status,tm_redump_width,UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_period_width.stopwatch_period_width_ringo.write(status,stopwatch_period_width_ringo,UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.stopwatch_period_width.stopwatch_period_width_res.write(status,stopwatch_period_width_res,UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.hw_op_ringo_mask.write(status,hw_op_ringo_mask,UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.dram_layer_sel.write(status,dram_layer_sel_cfg,UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.hw_op_tsv_load_sel.write(status,hw_op_tsv_load_sel,UVM_FRONTDOOR);

    endtask: hw_op_cfg

    task init_sp_rst_low_time_chk(input bit[27:0] init_spine_reset_time);
        fork
            begin
                fork: hw_init_sp_rst0
                    begin
                        @(posedge m_trim_if.spine_reset_n[0]);
                        if(m_trim_if.hw_init_sp_rst_cnt0 != init_spine_reset_time+1)
                            `uvm_error("trim_hard_vseq", $sformatf("hw_init_sp_rst_cnt0=%0d, init_spine_reset_time+1=%0d", m_trim_if.hw_init_sp_rst_cnt0, init_spine_reset_time+1))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.hw_init_sp_rst_cnt0++;
                    end
                join_any
                disable hw_init_sp_rst0;
                m_trim_if.hw_init_sp_rst_cnt0 = 0;
            end
            begin
                fork: hw_init_sp_rst1
                    begin
                        @(posedge m_trim_if.spine_reset_n[1]);
                        if(m_trim_if.hw_init_sp_rst_cnt1 != init_spine_reset_time+1)
                            `uvm_error("trim_hard_vseq", $sformatf("hw_init_sp_rst_cnt1=%0d, init_spine_reset_time+1=%0d", m_trim_if.hw_init_sp_rst_cnt1, init_spine_reset_time+1))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.hw_init_sp_rst_cnt1++;
                    end
                join_any
                disable hw_init_sp_rst1;                        
                m_trim_if.hw_init_sp_rst_cnt1 = 0;
            end
            begin
                fork: hw_init_sp_rst2
                    begin
                        @(posedge m_trim_if.spine_reset_n[2]);
                        if(m_trim_if.hw_init_sp_rst_cnt2 != init_spine_reset_time+1)
                            `uvm_error("trim_hard_vseq", $sformatf("hw_init_sp_rst_cnt2=%0d, init_spine_reset_time+1=%0d", m_trim_if.hw_init_sp_rst_cnt2, init_spine_reset_time+1))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.hw_init_sp_rst_cnt2++;
                    end
                join_any
                disable hw_init_sp_rst2;                        
                m_trim_if.hw_init_sp_rst_cnt2 = 0;
            end
            begin
                fork: hw_init_sp_rst3
                    begin
                        @(posedge m_trim_if.spine_reset_n[3]);
                        if(m_trim_if.hw_init_sp_rst_cnt3 != init_spine_reset_time+1)
                            `uvm_error("trim_hard_vseq", $sformatf("hw_init_sp_rst_cnt3=%0d, init_spine_reset_time+1=%0d", m_trim_if.hw_init_sp_rst_cnt3, init_spine_reset_time+1))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.hw_init_sp_rst_cnt3++;
                    end
                join_any
                disable hw_init_sp_rst3;   
                m_trim_if.hw_init_sp_rst_cnt3 = 0;
            end
            `ifdef DRAM_6
            begin
                fork: hw_init_sp_rst4
                    begin
                        @(posedge m_trim_if.spine_reset_n[4]);
                        if(m_trim_if.hw_init_sp_rst_cnt4 != init_spine_reset_time+1)
                            `uvm_error("trim_hard_vseq", $sformatf("hw_init_sp_rst_cnt4=%0d, init_spine_reset_time+1=%0d", m_trim_if.hw_init_sp_rst_cnt4, init_spine_reset_time+1))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.hw_init_sp_rst_cnt4++;
                    end
                join_any
                disable hw_init_sp_rst4;   
                m_trim_if.hw_init_sp_rst_cnt4 = 0;
            end
            begin
                fork: hw_init_sp_rst5
                    begin
                        @(posedge m_trim_if.spine_reset_n[5]);
                        if(m_trim_if.hw_init_sp_rst_cnt5 != init_spine_reset_time+1)
                            `uvm_error("trim_hard_vseq", $sformatf("hw_init_sp_rst_cnt5=%0d, init_spine_reset_time+1=%0d", m_trim_if.hw_init_sp_rst_cnt5, init_spine_reset_time+1))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.hw_init_sp_rst_cnt5++;
                    end
                join_any
                disable hw_init_sp_rst5;   
                m_trim_if.hw_init_sp_rst_cnt5 = 0;
            end
            `endif
        join        
    endtask: init_sp_rst_low_time_chk

    task res_smp_value_check(input bit[`DRAM_LAYER-1:0] dram_layer_sel_cfg, input bit is_software = 1, input int res_value_sel = 0);
        //input bit[3:0] dram_layer_sel_cfg;
        //input bit is_software = 1;   //add 0728
        //input int res_value_sel = 0; //(0:dram res, 1:res_cfg_value, 2:external input)add 0728
    

        bit [`DRAM_LAYER-1:0]      osc_tm_res_smp_ready;
        bit [`RES_WIDTH-1:0]       osc_tm_res_smp_value;
        bit [`RES_WIDTH-1:0]       cfg_res;


        //wait osc_tm_res_smp_ready=1:
        if(res_value_sel == 0)begin
            osc_tm_res_smp_ready = 'h0;
            case(dram_layer_sel_cfg)
                4'b0001: begin
                    wait(m_trim_if.stopwatch_ringo[0]==1);
                    while(osc_tm_res_smp_ready[0]!=1)begin
                        p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                    end
                end
                4'b0010: begin
                    wait(m_trim_if.stopwatch_ringo[1]==1);
                    while(osc_tm_res_smp_ready[1]!=1)begin
                        p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                    end
                end
                4'b0100: begin
                    wait(m_trim_if.stopwatch_ringo[2]==1);
                    while(osc_tm_res_smp_ready[2]!=1)begin
                        p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                    end
                end
                4'b1000: begin
                    wait(m_trim_if.stopwatch_ringo[3]==1);
                    while(osc_tm_res_smp_ready[3]!=1)begin
                        p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                    end
                end
                4'b0011: begin
                    //0731//wait(m_trim_if.stopwatch_ringo[1:0]==2'b11);
                    fork
                        wait(m_trim_if.stopwatch_ringo[0] == 1);
                        wait(m_trim_if.stopwatch_ringo[1] == 1);
                    join
                    while(osc_tm_res_smp_ready[1:0]!=2'b11)begin
                        p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                    end
                end
                4'b1111: begin
                    //0731//wait(m_trim_if.stopwatch_ringo==4'hf);
                    fork
                        wait(m_trim_if.stopwatch_ringo[0] == 1);
                        wait(m_trim_if.stopwatch_ringo[1] == 1);
                        wait(m_trim_if.stopwatch_ringo[2] == 1);
                        wait(m_trim_if.stopwatch_ringo[3] == 1);
                    join
                    while(osc_tm_res_smp_ready[3:0]!=4'hf)begin
                        p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                    end
                end

                `ifdef DRAM_6
                6'b01_0000: begin
                    wait(m_trim_if.stopwatch_ringo[4]==1);
                    while(osc_tm_res_smp_ready[4]!=1)begin
                        p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                    end
                end
                6'b10_0000: begin
                    wait(m_trim_if.stopwatch_ringo[5]==1);
                    while(osc_tm_res_smp_ready[5]!=1)begin
                        p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                    end
                end
                6'b11_1111: begin
                    //0731//wait(m_trim_if.stopwatch_ringo==4'hf);
                    fork
                        wait(m_trim_if.stopwatch_ringo[0] == 1);
                        wait(m_trim_if.stopwatch_ringo[1] == 1);
                        wait(m_trim_if.stopwatch_ringo[2] == 1);
                        wait(m_trim_if.stopwatch_ringo[3] == 1);
                        wait(m_trim_if.stopwatch_ringo[4] == 1);
                        wait(m_trim_if.stopwatch_ringo[5] == 1);
                    join
                    while(osc_tm_res_smp_ready!=6'h3f)begin
                        p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_ready.read(status,osc_tm_res_smp_ready,UVM_FRONTDOOR);
                    end
                end
                `endif
            endcase
        end
        `uvm_info("DEBUG", $sformatf("-------------finish read osc_tm_res_smp_ready---------------"), UVM_LOW)
 
        //0728////read osc_tm_res_smp_value:
        //0728//case(dram_layer_sel_cfg)
        //0728//    4'b0001: wait(m_trim_if.stopwatch_ringo[0] == 1);
        //0728//    4'b0010: wait(m_trim_if.stopwatch_ringo[1] == 1);
        //0728//    4'b0100: wait(m_trim_if.stopwatch_ringo[2] == 1);
        //0728//    4'b1000: wait(m_trim_if.stopwatch_ringo[3] == 1);
        //0728//    4'b0011: wait(m_trim_if.stopwatch_ringo[1:0] == 2'b11);
        //0728//    4'b1111: wait(m_trim_if.stopwatch_ringo == 4'hf);
        //0728//endcase

        //0819//repeat(1)@(posedge m_trim_if.clk);
        repeat(20)@(posedge m_apb_if.pclk); //0819:reg's value need wait ringo posedge the delay 6 clk:
        if(is_software)begin
            p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_value.read(status,osc_tm_res_smp_value,UVM_FRONTDOOR);
        end
        else begin
            if(res_value_sel == 0)
                p_sequencer.regmodel.DRAM_TRIM_ins.osc_tm_res_smp_value.osc_tm_res_smp_value.read(status,osc_tm_res_smp_value,UVM_FRONTDOOR);
            //p_sequencer.regmodel.DRAM_TRIM_ins.res_value_ctrl.res_cfg_value.read(status,cfg_res,UVM_FRONTDOOR);
            //osc_tm_res_smp_value = m_trim_if.trim_res;
        end
        `uvm_info("osc_tm_res_sample", $sformatf("----------have read res_value register----------"), UVM_LOW)

        //check 4 layer osc_tm_res_value, reg res = dram input res:
        if(res_value_sel == 0)begin
            case(dram_layer_sel_cfg)
                'b0001: begin
                    case(res_value_sel)
                        0: begin
                            if(osc_tm_res_smp_value[1:0] != m_trim_if.osc_tm_res[1:0])
                                `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[1:0]=%0h, dram input res: osc_tm_res[1:0]=%0h", osc_tm_res_smp_value[1:0], m_trim_if.osc_tm_res[1:0]))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        //1: begin
                        //    if(osc_tm_res_smp_value[1:0] != cfg_res[1:0])
                        //        `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[1:0]=%0h, cfg res: cfg_res[1:0]=%0h", osc_tm_res_smp_value[1:0], cfg_res[1:0]))
                        //end
                        //2: begin
                        //    if(osc_tm_res_smp_value[1:0] != m_trim_if.trim_res[1:0])
                        //        `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[1:0]=%0h, input res: trim_res[1:0]=%0h", osc_tm_res_smp_value[1:0], m_trim_if.trim_res[1:0]))
                        //end
                    endcase
                end
                'b0010: begin
                    case(res_value_sel)
                        0: begin
                            if(osc_tm_res_smp_value[3:2] != m_trim_if.osc_tm_res[3:2])
                                `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[3:2]=%0h, dram input res: osc_tm_res[3:2]=%0h", osc_tm_res_smp_value[3:2], m_trim_if.osc_tm_res[3:2]))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        //1: begin
                        //    if(osc_tm_res_smp_value[3:2] != cfg_res[3:2])
                        //        `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[3:2]=%0h, cfg res: cfg_res[3:2]=%0h", osc_tm_res_smp_value[3:2], cfg_res[3:2]))
                        //end
                        //2: begin
                        //    if(osc_tm_res_smp_value[3:2] != m_trim_if.trim_res[3:2])
                        //        `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[3:2]=%0h, input res: trim_res[3:2]=%0h", osc_tm_res_smp_value[3:2], m_trim_if.trim_res[3:2]))
                        //end
                    endcase
                end
                'b0100: begin
                    case(res_value_sel)
                        0: begin
                            if(osc_tm_res_smp_value[5:4] != m_trim_if.osc_tm_res[5:4])
                                `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[5:4]=%0h, dram input res: osc_tm_res[5:4]=%0h", osc_tm_res_smp_value[5:4], m_trim_if.osc_tm_res[5:4]))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        //1: begin
                        //    if(osc_tm_res_smp_value[5:4] != cfg_res[5:4])
                        //        `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[5:4]=%0h, cfg res: cfg_res[5:4]=%0h", osc_tm_res_smp_value[5:4], cfg_res[5:4]))
                        //end
                        //2: begin
                        //    if(osc_tm_res_smp_value[5:4] != m_trim_if.trim_res[5:4])
                        //        `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[5:4]=%0h, input res: trim_res[5:4]=%0h", osc_tm_res_smp_value[5:4], m_trim_if.trim_res[5:4]))
                        //end                        
                    endcase
                end
                'b1000: begin
                    case(res_value_sel)
                        0: begin
                            if(osc_tm_res_smp_value[7:6] != m_trim_if.osc_tm_res[7:6])
                                `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[7:6]=%0h, dram input res: osc_tm_res[7:6]=%0h", osc_tm_res_smp_value[7:6], m_trim_if.osc_tm_res[7:6]))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        //1: begin
                        //    if(osc_tm_res_smp_value[7:6] != cfg_res[7:6])
                        //        `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[7:6]=%0h, cfg res: cfg_res[7:6]=%0h", osc_tm_res_smp_value[7:6], cfg_res[7:6]))
                        //end
                        //2: begin
                        //    if(osc_tm_res_smp_value[7:6] != m_trim_if.trim_res[7:6])
                        //        `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[7:6]=%0h, input res: trim_res[7:6]=%0h", osc_tm_res_smp_value[7:6], m_trim_if.trim_res[7:6]))
                        //end                        
                    endcase
                end
                'b0011: begin
                    case(res_value_sel)
                        0: begin
                            if(osc_tm_res_smp_value[3:0] != m_trim_if.osc_tm_res[3:0])
                                `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[3:0]=%0h, dram input res: osc_tm_res[3:0]=%0h", osc_tm_res_smp_value[3:0], m_trim_if.osc_tm_res[3:0]))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        //1: begin
                        //    if(osc_tm_res_smp_value[3:0] != cfg_res[3:0])
                        //        `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[3:0]=%0h, cfg res: cfg_res[3:0]=%0h", osc_tm_res_smp_value[3:0], cfg_res[3:0]))
                        //end
                        //2: begin
                        //    if(osc_tm_res_smp_value[3:0] != m_trim_if.trim_res[3:0])
                        //        `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[3:0]=%0h, input res: trim_res[3:0]=%0h", osc_tm_res_smp_value[3:0], m_trim_if.trim_res[3:0]))
                        //end
                    endcase
                end
                'b1111: begin
                    case(res_value_sel)
                        0: begin
                            if(osc_tm_res_smp_value[7:0] != m_trim_if.osc_tm_res[7:0])
                                `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[3:0]=%0h, dram input res: osc_tm_res[3:0]=%0h", osc_tm_res_smp_value[3:0], m_trim_if.osc_tm_res[3:0]))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        //1: begin
                        //    if(osc_tm_res_smp_value != cfg_res)
                        //        `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value=%0h, cfg res: cfg_res=%0h", osc_tm_res_smp_value, cfg_res))
                        //end
                        //2: begin
                        //    if(osc_tm_res_smp_value != m_trim_if.trim_res)
                        //        `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value=%0h, input res: trim_res=%0h", osc_tm_res_smp_value, m_trim_if.trim_res))
                        //end
                    endcase
                end

                `ifdef DRAM_6
                6'b01_0000: begin
                    case(res_value_sel)
                        0: begin
                            if(osc_tm_res_smp_value[9:8] != m_trim_if.osc_tm_res[9:8])
                                `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[9:8]=%0h, dram input res: osc_tm_res[9:8]=%0h", osc_tm_res_smp_value[9:8], m_trim_if.osc_tm_res[9:8]))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                    endcase
                end
                6'b10_0000: begin
                    case(res_value_sel)
                        0: begin
                            if(osc_tm_res_smp_value[11:10] != m_trim_if.osc_tm_res[11:10])
                                `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value[11:10]=%0h, dram input res: osc_tm_res[11:10]=%0h", osc_tm_res_smp_value[11:10], m_trim_if.osc_tm_res[11:10]))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                    endcase
                end
                6'b11_1111: begin
                    case(res_value_sel)
                        0: begin
                            if(osc_tm_res_smp_value != m_trim_if.osc_tm_res)
                                `uvm_error("osc_tm_res_sample", $sformatf("reg read: osc_tm_res_smp_value=%0h, dram input res: osc_tm_res=%0h", osc_tm_res_smp_value, m_trim_if.osc_tm_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("osc_tm_res_sample", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                    endcase
                end
                `endif
            endcase
        end
    endtask: res_smp_value_check


    task hw_ringo_reg_chk(input bit[`DRAM_LAYER-1:0] dram_layer_sel, input bit[8:0] ringo_mode);
        case(dram_layer_sel)
            'b0001: begin
                hw_ringo_reg(0, ringo_mode);
                m_trim_if.ringo_period_cnt0_save_q.push_back(m_trim_if.ringo_period_cnt0); //0730
            end
            'b0011: begin
                hw_ringo_reg(0, ringo_mode);
                hw_ringo_reg(1, ringo_mode);
                m_trim_if.ringo_period_cnt0_save_q.push_back(m_trim_if.ringo_period_cnt0); //0730
                m_trim_if.ringo_period_cnt1_save_q.push_back(m_trim_if.ringo_period_cnt1); //0730
            end
            'b1111: begin
                hw_ringo_reg(0, ringo_mode);
                hw_ringo_reg(1, ringo_mode);
                hw_ringo_reg(2, ringo_mode);
                hw_ringo_reg(3, ringo_mode);
                m_trim_if.ringo_period_cnt0_save_q.push_back(m_trim_if.ringo_period_cnt0); //0730
                m_trim_if.ringo_period_cnt1_save_q.push_back(m_trim_if.ringo_period_cnt1); //0730
                m_trim_if.ringo_period_cnt2_save_q.push_back(m_trim_if.ringo_period_cnt2); //0730
                m_trim_if.ringo_period_cnt3_save_q.push_back(m_trim_if.ringo_period_cnt3); //0730                
            end

            `ifdef DRAM_6
            6'b11_1111: begin
                hw_ringo_reg(0, ringo_mode);
                hw_ringo_reg(1, ringo_mode);
                hw_ringo_reg(2, ringo_mode);
                hw_ringo_reg(3, ringo_mode);
                hw_ringo_reg(4, ringo_mode);
                hw_ringo_reg(5, ringo_mode);
                m_trim_if.ringo_period_cnt0_save_q.push_back(m_trim_if.ringo_period_cnt0); //0730
                m_trim_if.ringo_period_cnt1_save_q.push_back(m_trim_if.ringo_period_cnt1); //0730
                m_trim_if.ringo_period_cnt2_save_q.push_back(m_trim_if.ringo_period_cnt2); //0730
                m_trim_if.ringo_period_cnt3_save_q.push_back(m_trim_if.ringo_period_cnt3); //0730
                m_trim_if.ringo_period_cnt4_save_q.push_back(m_trim_if.ringo_period_cnt4); //0730
                m_trim_if.ringo_period_cnt5_save_q.push_back(m_trim_if.ringo_period_cnt5); //0730
            end
            `endif
        endcase
    endtask: hw_ringo_reg_chk

    task hw_ringo_reg(input int layer_sel, input bit[8:0] ringo_mode);
        bit [9:0]   hw_ringo_period_00, hw_ringo_period_10, hw_ringo_period_20, hw_ringo_period_30 , hw_ringo_period_40, hw_ringo_period_50 ;
        bit [9:0]   hw_ringo_period_01, hw_ringo_period_11, hw_ringo_period_21, hw_ringo_period_31 , hw_ringo_period_41, hw_ringo_period_51 ;
        bit [9:0]   hw_ringo_period_02, hw_ringo_period_12, hw_ringo_period_22, hw_ringo_period_32 , hw_ringo_period_42, hw_ringo_period_52 ;
        bit [9:0]   hw_ringo_period_03, hw_ringo_period_13, hw_ringo_period_23, hw_ringo_period_33 , hw_ringo_period_43, hw_ringo_period_53 ;
        bit [9:0]   hw_ringo_period_04, hw_ringo_period_14, hw_ringo_period_24, hw_ringo_period_34 , hw_ringo_period_44, hw_ringo_period_54 ;
        bit [9:0]   hw_ringo_period_05, hw_ringo_period_15, hw_ringo_period_25, hw_ringo_period_35 , hw_ringo_period_45, hw_ringo_period_55 ;
        bit [9:0]   hw_ringo_period_06, hw_ringo_period_16, hw_ringo_period_26, hw_ringo_period_36 , hw_ringo_period_46, hw_ringo_period_56 ;
        bit [9:0]   hw_ringo_period_07, hw_ringo_period_17, hw_ringo_period_27, hw_ringo_period_37 , hw_ringo_period_47, hw_ringo_period_57 ;

        int         result00, result01, result02, result03, result04, result05, result06, result07;
        int         result10, result11, result12, result13, result14, result15, result16, result17;
        int         result20, result21, result22, result23, result24, result25, result26, result27;
        int         result30, result31, result32, result33, result34, result35, result36, result37;
        int         result40, result41, result42, result43, result44, result45, result46, result47; //for dram_6
        int         result50, result51, result52, result53, result54, result55, result56, result57; //for dram_6

        case(layer_sel)
        0: begin
            case(ringo_mode)
                9'h40: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_01.hw_ringo_dram0_period0.read(status,hw_ringo_period_00,UVM_FRONTDOOR);
                    //0725//if(hw_ringo_period_00 != m_trim_if.ringo_period_cnt0)
                    ringo_compare(hw_ringo_period_00, m_trim_if.ringo_period_cnt0, result00);
                    if(result00 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_00=%0d, m_trim_if.ringo_period_cnt0=%0d",hw_ringo_period_00,m_trim_if.ringo_period_cnt0))
                end
                9'h60: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_01.hw_ringo_dram0_period1.read(status,hw_ringo_period_01,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_01, m_trim_if.ringo_period_cnt0, result01);
                    if(result01 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_01=%0d, m_trim_if.ringo_period_cnt0=%0d",hw_ringo_period_01,m_trim_if.ringo_period_cnt0))
                end
                9'h50: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_23.hw_ringo_dram0_period2.read(status,hw_ringo_period_02,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_02, m_trim_if.ringo_period_cnt0, result02);
                    if(result02 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_02=%0d, m_trim_if.ringo_period_cnt0=%0d",hw_ringo_period_02,m_trim_if.ringo_period_cnt0))
                end
                9'h70: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_23.hw_ringo_dram0_period3.read(status,hw_ringo_period_03,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_03, m_trim_if.ringo_period_cnt0, result03);
                    //if(hw_ringo_period_03 != m_trim_if.ringo_period_cnt0)
                    if(result03 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_03=%0d, m_trim_if.ringo_period_cnt0=%0d",hw_ringo_period_03,m_trim_if.ringo_period_cnt0))
                end
                9'h48: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_45.hw_ringo_dram0_period4.read(status,hw_ringo_period_04,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_04, m_trim_if.ringo_period_cnt0, result04);
                    //if(hw_ringo_period_04 != m_trim_if.ringo_period_cnt0)
                    if(result04 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_04=%0d, m_trim_if.ringo_period_cnt0=%0d",hw_ringo_period_04,m_trim_if.ringo_period_cnt0))
                end
                9'h68: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_45.hw_ringo_dram0_period5.read(status,hw_ringo_period_05,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_05, m_trim_if.ringo_period_cnt0, result05);
                    //if(hw_ringo_period_05 != m_trim_if.ringo_period_cnt0)
                    if(result05 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_05=%0d, m_trim_if.ringo_period_cnt0=%0d",hw_ringo_period_05,m_trim_if.ringo_period_cnt0))
                end
                9'h58: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_67.hw_ringo_dram0_period6.read(status,hw_ringo_period_06,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_06, m_trim_if.ringo_period_cnt0, result06);
                    //if(hw_ringo_period_06 != m_trim_if.ringo_period_cnt0)
                    if(result06 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_06=%0d, m_trim_if.ringo_period_cnt0=%0d",hw_ringo_period_06,m_trim_if.ringo_period_cnt0))
                end
                9'h5a: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_67.hw_ringo_dram0_period7.read(status,hw_ringo_period_07,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_07, m_trim_if.ringo_period_cnt0, result07);
                    //if(hw_ringo_period_07 != m_trim_if.ringo_period_cnt0)
                    if(result07 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_07=%0d, m_trim_if.ringo_period_cnt0=%0d",hw_ringo_period_07,m_trim_if.ringo_period_cnt0))
                end
            endcase
        end
        1: begin
            case(ringo_mode)
                9'h40: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_01.hw_ringo_dram1_period0.read(status,hw_ringo_period_10,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_10, m_trim_if.ringo_period_cnt1, result10);
                    //if(hw_ringo_period_10 != m_trim_if.ringo_period_cnt1)
                    if(result10 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_10=%0d, m_trim_if.ringo_period_cnt1=%0d",hw_ringo_period_10,m_trim_if.ringo_period_cnt1))
                end
                9'h60: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_01.hw_ringo_dram1_period1.read(status,hw_ringo_period_11,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_11, m_trim_if.ringo_period_cnt1, result11);
                    //if(hw_ringo_period_11 != m_trim_if.ringo_period_cnt1)
                    if(result11 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_11=%0d, m_trim_if.ringo_period_cnt1=%0d",hw_ringo_period_11,m_trim_if.ringo_period_cnt1))
                end
                9'h50: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_23.hw_ringo_dram1_period2.read(status,hw_ringo_period_12,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_12, m_trim_if.ringo_period_cnt1, result12);
                    //if(hw_ringo_period_12 != m_trim_if.ringo_period_cnt1)
                    if(result12 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_12=%0d, m_trim_if.ringo_period_cnt1=%0d",hw_ringo_period_12,m_trim_if.ringo_period_cnt1))
                end
                9'h70: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_23.hw_ringo_dram1_period3.read(status,hw_ringo_period_13,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_13, m_trim_if.ringo_period_cnt1, result13);
                    //if(hw_ringo_period_13 != m_trim_if.ringo_period_cnt1)
                    if(result13 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_13=%0d, m_trim_if.ringo_period_cnt1=%0d",hw_ringo_period_13,m_trim_if.ringo_period_cnt1))
                end
                9'h48: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_45.hw_ringo_dram1_period4.read(status,hw_ringo_period_14,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_14, m_trim_if.ringo_period_cnt1, result14);
                    //if(hw_ringo_period_14 != m_trim_if.ringo_period_cnt1)
                    if(result14 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_14=%0d, m_trim_if.ringo_period_cnt1=%0d",hw_ringo_period_14,m_trim_if.ringo_period_cnt1))
                end
                9'h68: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_45.hw_ringo_dram1_period5.read(status,hw_ringo_period_15,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_15, m_trim_if.ringo_period_cnt1, result15);
                    //if(hw_ringo_period_15 != m_trim_if.ringo_period_cnt1)
                    if(result15 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_15=%0d, m_trim_if.ringo_period_cnt1=%0d",hw_ringo_period_15,m_trim_if.ringo_period_cnt1))
                end
                9'h58: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_67.hw_ringo_dram1_period6.read(status,hw_ringo_period_16,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_16, m_trim_if.ringo_period_cnt1, result16);
                    //if(hw_ringo_period_16 != m_trim_if.ringo_period_cnt1)
                    if(result16 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_16=%0d, m_trim_if.ringo_period_cnt1=%0d",hw_ringo_period_16,m_trim_if.ringo_period_cnt1))
                end
                9'h5a: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_67.hw_ringo_dram1_period7.read(status,hw_ringo_period_17,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_17, m_trim_if.ringo_period_cnt1, result17);
                    //if(hw_ringo_period_17 != m_trim_if.ringo_period_cnt1)
                    if(result17 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_17=%0d, m_trim_if.ringo_period_cnt1=%0d",hw_ringo_period_17,m_trim_if.ringo_period_cnt1))
                end
            endcase
        end
        2: begin
            case(ringo_mode)
                9'h40: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_01.hw_ringo_dram2_period0.read(status,hw_ringo_period_20,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_20, m_trim_if.ringo_period_cnt2, result20);
                    //if(hw_ringo_period_20 != m_trim_if.ringo_period_cnt2)
                    if(result20 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_20=%0d, m_trim_if.ringo_period_cnt2=%0d",hw_ringo_period_20,m_trim_if.ringo_period_cnt2))
                end
                9'h60: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_01.hw_ringo_dram2_period1.read(status,hw_ringo_period_21,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_21, m_trim_if.ringo_period_cnt2, result21);
                    //if(hw_ringo_period_21 != m_trim_if.ringo_period_cnt2)
                    if(result21 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_21=%0d, m_trim_if.ringo_period_cnt2=%0d",hw_ringo_period_21,m_trim_if.ringo_period_cnt2))
                end
                9'h50: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_23.hw_ringo_dram2_period2.read(status,hw_ringo_period_22,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_22, m_trim_if.ringo_period_cnt2, result22);
                    //if(hw_ringo_period_22 != m_trim_if.ringo_period_cnt2)
                    if(result22 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_22=%0d, m_trim_if.ringo_period_cnt2=%0d",hw_ringo_period_22,m_trim_if.ringo_period_cnt2))
                end
                9'h70: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_23.hw_ringo_dram2_period3.read(status,hw_ringo_period_23,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_23, m_trim_if.ringo_period_cnt2, result23);
                    //if(hw_ringo_period_23 != m_trim_if.ringo_period_cnt2)
                    if(result23 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_23=%0d, m_trim_if.ringo_period_cnt2=%0d",hw_ringo_period_23,m_trim_if.ringo_period_cnt2))
                end
                9'h48: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_45.hw_ringo_dram2_period4.read(status,hw_ringo_period_24,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_24, m_trim_if.ringo_period_cnt2, result24);
                    //if(hw_ringo_period_24 != m_trim_if.ringo_period_cnt2)
                    if(result24 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_24=%0d, m_trim_if.ringo_period_cnt2=%0d",hw_ringo_period_24,m_trim_if.ringo_period_cnt2))
                end
                9'h68: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_45.hw_ringo_dram2_period5.read(status,hw_ringo_period_25,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_25, m_trim_if.ringo_period_cnt2, result25);
                    //if(hw_ringo_period_25 != m_trim_if.ringo_period_cnt2)
                    if(result25 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_25=%0d, m_trim_if.ringo_period_cnt2=%0d",hw_ringo_period_25,m_trim_if.ringo_period_cnt2))
                end
                9'h58: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_67.hw_ringo_dram2_period6.read(status,hw_ringo_period_26,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_26, m_trim_if.ringo_period_cnt2, result26);
                    //if(hw_ringo_period_26 != m_trim_if.ringo_period_cnt2)
                    if(result26 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_26=%0d, m_trim_if.ringo_period_cnt2=%0d",hw_ringo_period_26,m_trim_if.ringo_period_cnt2))
                end
                9'h5a: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_67.hw_ringo_dram2_period7.read(status,hw_ringo_period_27,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_27, m_trim_if.ringo_period_cnt2, result27);
                    //if(hw_ringo_period_27 != m_trim_if.ringo_period_cnt2)
                    if(result27 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_27=%0d, m_trim_if.ringo_period_cnt2=%0d",hw_ringo_period_27,m_trim_if.ringo_period_cnt2))
                end
            endcase
        end
        3: begin
            case(ringo_mode)
                9'h40: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_01.hw_ringo_dram3_period0.read(status,hw_ringo_period_30,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_30, m_trim_if.ringo_period_cnt3, result30);
                    //if(hw_ringo_period_30 != m_trim_if.ringo_period_cnt3)
                    if(result30 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_30=%0d, m_trim_if.ringo_period_cnt3=%0d",hw_ringo_period_30,m_trim_if.ringo_period_cnt3))
                end
                9'h60: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_01.hw_ringo_dram3_period1.read(status,hw_ringo_period_31,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_31, m_trim_if.ringo_period_cnt3, result31);
                    //if(hw_ringo_period_31 != m_trim_if.ringo_period_cnt3)
                    if(result31 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_31=%0d, m_trim_if.ringo_period_cnt3=%0d",hw_ringo_period_31,m_trim_if.ringo_period_cnt3))
                end
                9'h50: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_23.hw_ringo_dram3_period2.read(status,hw_ringo_period_32,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_32, m_trim_if.ringo_period_cnt3, result32);
                    //if(hw_ringo_period_32 != m_trim_if.ringo_period_cnt3)
                    if(result32 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_32=%0d, m_trim_if.ringo_period_cnt3=%0d",hw_ringo_period_32,m_trim_if.ringo_period_cnt3))
                end
                9'h70: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_23.hw_ringo_dram3_period3.read(status,hw_ringo_period_33,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_33, m_trim_if.ringo_period_cnt3, result33);
                    //if(hw_ringo_period_33 != m_trim_if.ringo_period_cnt3)
                    if(result33 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_33=%0d, m_trim_if.ringo_period_cnt3=%0d",hw_ringo_period_33,m_trim_if.ringo_period_cnt3))
                end
                9'h48: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_45.hw_ringo_dram3_period4.read(status,hw_ringo_period_34,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_34, m_trim_if.ringo_period_cnt3, result34);
                    //if(hw_ringo_period_34 != m_trim_if.ringo_period_cnt3)
                    if(result34 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_34=%0d, m_trim_if.ringo_period_cnt3=%0d",hw_ringo_period_34,m_trim_if.ringo_period_cnt3))
                end
                9'h68: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_45.hw_ringo_dram3_period5.read(status,hw_ringo_period_35,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_35, m_trim_if.ringo_period_cnt3, result35);
                    //if(hw_ringo_period_35 != m_trim_if.ringo_period_cnt3)
                    if(result35 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_35=%0d, m_trim_if.ringo_period_cnt3=%0d",hw_ringo_period_35,m_trim_if.ringo_period_cnt3))
                end
                9'h58: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_67.hw_ringo_dram3_period6.read(status,hw_ringo_period_36,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_36, m_trim_if.ringo_period_cnt3, result36);
                    //if(hw_ringo_period_36 != m_trim_if.ringo_period_cnt3)
                    if(result36 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_36=%0d, m_trim_if.ringo_period_cnt3=%0d",hw_ringo_period_36,m_trim_if.ringo_period_cnt3))
                end
                9'h5a: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_67.hw_ringo_dram3_period7.read(status,hw_ringo_period_37,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_37, m_trim_if.ringo_period_cnt3, result37);
                    //if(hw_ringo_period_37 != m_trim_if.ringo_period_cnt3)
                    if(result37 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_37=%0d, m_trim_if.ringo_period_cnt3=%0d",hw_ringo_period_37,m_trim_if.ringo_period_cnt3))
                end
            endcase
        end

        `ifdef DRAM_6
        4: begin
            case(ringo_mode)
                9'h40: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_01.hw_ringo_dram4_period0.read(status,hw_ringo_period_40,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_40, m_trim_if.ringo_period_cnt4, result40);
                    //if(hw_ringo_period_40 != m_trim_if.ringo_period_cnt4)
                    if(result40 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_40=%0d, m_trim_if.ringo_period_cnt4=%0d",hw_ringo_period_40,m_trim_if.ringo_period_cnt4))
                end
                9'h60: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_01.hw_ringo_dram4_period1.read(status,hw_ringo_period_41,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_41, m_trim_if.ringo_period_cnt4, result41);
                    //if(hw_ringo_period_41 != m_trim_if.ringo_period_cnt4)
                    if(result41 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_41=%0d, m_trim_if.ringo_period_cnt4=%0d",hw_ringo_period_41,m_trim_if.ringo_period_cnt4))
                end
                9'h50: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_23.hw_ringo_dram4_period2.read(status,hw_ringo_period_42,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_42, m_trim_if.ringo_period_cnt4, result42);
                    //if(hw_ringo_period_42 != m_trim_if.ringo_period_cnt4)
                    if(result42 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_42=%0d, m_trim_if.ringo_period_cnt4=%0d",hw_ringo_period_42,m_trim_if.ringo_period_cnt4))
                end
                9'h70: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_23.hw_ringo_dram4_period3.read(status,hw_ringo_period_43,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_43, m_trim_if.ringo_period_cnt4, result43);
                    //if(hw_ringo_period_43 != m_trim_if.ringo_period_cnt4)
                    if(result43 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_43=%0d, m_trim_if.ringo_period_cnt4=%0d",hw_ringo_period_43,m_trim_if.ringo_period_cnt4))
                end
                9'h48: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_45.hw_ringo_dram4_period4.read(status,hw_ringo_period_44,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_44, m_trim_if.ringo_period_cnt4, result44);
                    //if(hw_ringo_period_44 != m_trim_if.ringo_period_cnt4)
                    if(result44 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_44=%0d, m_trim_if.ringo_period_cnt4=%0d",hw_ringo_period_44,m_trim_if.ringo_period_cnt4))
                end
                9'h68: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_45.hw_ringo_dram4_period5.read(status,hw_ringo_period_45,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_45, m_trim_if.ringo_period_cnt4, result45);
                    //if(hw_ringo_period_45 != m_trim_if.ringo_period_cnt4)
                    if(result45 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_45=%0d, m_trim_if.ringo_period_cnt4=%0d",hw_ringo_period_45,m_trim_if.ringo_period_cnt4))
                end
                9'h58: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_67.hw_ringo_dram4_period6.read(status,hw_ringo_period_46,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_46, m_trim_if.ringo_period_cnt4, result46);
                    //if(hw_ringo_period_46 != m_trim_if.ringo_period_cnt4)
                    if(result46 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_46=%0d, m_trim_if.ringo_period_cnt4=%0d",hw_ringo_period_46,m_trim_if.ringo_period_cnt4))
                end
                9'h5a: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_67.hw_ringo_dram4_period7.read(status,hw_ringo_period_47,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_47, m_trim_if.ringo_period_cnt4, result47);
                    //if(hw_ringo_period_47 != m_trim_if.ringo_period_cnt4)
                    if(result47 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_47=%0d, m_trim_if.ringo_period_cnt4=%0d",hw_ringo_period_47,m_trim_if.ringo_period_cnt4))
                end
            endcase
        end
        5: begin
            case(ringo_mode)
                9'h40: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_01.hw_ringo_dram5_period0.read(status,hw_ringo_period_50,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_50, m_trim_if.ringo_period_cnt5, result50);
                    //if(hw_ringo_period_50 != m_trim_if.ringo_period_cnt5)
                    if(result50 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_50=%0d, m_trim_if.ringo_period_cnt5=%0d",hw_ringo_period_50,m_trim_if.ringo_period_cnt5))
                end
                9'h60: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_01.hw_ringo_dram5_period1.read(status,hw_ringo_period_51,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_51, m_trim_if.ringo_period_cnt5, result51);
                    //if(hw_ringo_period_51 != m_trim_if.ringo_period_cnt5)
                    if(result51 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_51=%0d, m_trim_if.ringo_period_cnt5=%0d",hw_ringo_period_51,m_trim_if.ringo_period_cnt5))
                end
                9'h50: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_23.hw_ringo_dram5_period2.read(status,hw_ringo_period_52,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_52, m_trim_if.ringo_period_cnt5, result52);
                    //if(hw_ringo_period_52 != m_trim_if.ringo_period_cnt5)
                    if(result52 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_52=%0d, m_trim_if.ringo_period_cnt5=%0d",hw_ringo_period_52,m_trim_if.ringo_period_cnt5))
                end
                9'h70: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_23.hw_ringo_dram5_period3.read(status,hw_ringo_period_53,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_53, m_trim_if.ringo_period_cnt5, result53);
                    //if(hw_ringo_period_53 != m_trim_if.ringo_period_cnt5)
                    if(result53 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_53=%0d, m_trim_if.ringo_period_cnt5=%0d",hw_ringo_period_53,m_trim_if.ringo_period_cnt5))
                end
                9'h48: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_45.hw_ringo_dram5_period4.read(status,hw_ringo_period_54,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_54, m_trim_if.ringo_period_cnt5, result54);
                    //if(hw_ringo_period_54 != m_trim_if.ringo_period_cnt5)
                    if(result54 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_54=%0d, m_trim_if.ringo_period_cnt5=%0d",hw_ringo_period_54,m_trim_if.ringo_period_cnt5))
                end
                9'h68: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_45.hw_ringo_dram5_period5.read(status,hw_ringo_period_55,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_55, m_trim_if.ringo_period_cnt5, result55);
                    //if(hw_ringo_period_55 != m_trim_if.ringo_period_cnt5)
                    if(result55 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_55=%0d, m_trim_if.ringo_period_cnt5=%0d",hw_ringo_period_55,m_trim_if.ringo_period_cnt5))
                end
                9'h58: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_67.hw_ringo_dram5_period6.read(status,hw_ringo_period_56,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_56, m_trim_if.ringo_period_cnt5, result56);
                    //if(hw_ringo_period_56 != m_trim_if.ringo_period_cnt5)
                    if(result56 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_56=%0d, m_trim_if.ringo_period_cnt5=%0d",hw_ringo_period_56,m_trim_if.ringo_period_cnt5))
                end
                9'h5a: begin
                    p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_67.hw_ringo_dram5_period7.read(status,hw_ringo_period_57,UVM_FRONTDOOR);
                    ringo_compare(hw_ringo_period_57, m_trim_if.ringo_period_cnt5, result57);
                    //if(hw_ringo_period_57 != m_trim_if.ringo_period_cnt5)
                    if(result57 > 'd2)
                        `uvm_error("hw_ringo_reg",$sformatf("hw_ringo_period_57=%0d, m_trim_if.ringo_period_cnt5=%0d",hw_ringo_period_57,m_trim_if.ringo_period_cnt5))
                end
            endcase
        end
        `endif
        endcase
    endtask: hw_ringo_reg

    task ringo_compare(input int cnt1, input int cnt2, output int result);
        result = (cnt1 > cnt2)? (cnt1 - cnt2):(cnt2 - cnt1);
    endtask: ringo_compare

    task hw_save_ringo_reg_chk(input bit[`DRAM_LAYER-1:0] dram_layer_sel);
        bit [9:0]   hw_ringo_period0[8], hw_ringo_period1[8], hw_ringo_period2[8], hw_ringo_period3[8], hw_ringo_period4[8], hw_ringo_period5[8];
        int         exp_ringo_period0, exp_ringo_period1, exp_ringo_period2, exp_ringo_period3, exp_ringo_period4, exp_ringo_period5;
        int         result0, result1, result2, result3, result4, result5;


        case(dram_layer_sel)
        4'b0001: begin
            read_ringo_period_reg(0, hw_ringo_period0);

            for(int i=0; i<8; i++)begin
                exp_ringo_period0 = m_trim_if.ringo_period_cnt0_save_q.pop_front();
                ringo_compare(exp_ringo_period0, hw_ringo_period0[i], result0);
                if(result0 > 'd2)
                    `uvm_error("save_ringo_period_chk",$sformatf("i=%0d, exp_ringo_period0=%0d, hw_ringo_period0[%0d]=%0d",i,exp_ringo_period0,i,hw_ringo_period0[i]))
            end
        end
        4'b0011: begin
            read_ringo_period_reg(0, hw_ringo_period0);            
            read_ringo_period_reg(1, hw_ringo_period1);            

            for(int i=0; i<8; i++)begin
                exp_ringo_period0 = m_trim_if.ringo_period_cnt0_save_q.pop_front();
                ringo_compare(exp_ringo_period0, hw_ringo_period0[i], result0);
                //if(exp_ringo_period0 != hw_ringo_period0[i])
                if(result0 > 'd2)
                    `uvm_error("save_ringo_period_chk",$sformatf("i=%0d, exp_ringo_period0=%0d, hw_ringo_period0[%0d]=%0d",i,exp_ringo_period0,i,hw_ringo_period0[i]))

                exp_ringo_period1 = m_trim_if.ringo_period_cnt1_save_q.pop_front();
                ringo_compare(exp_ringo_period1, hw_ringo_period1[i], result1);
                //if(exp_ringo_period1 != hw_ringo_period1[i])
                if(result1 > 'd2)
                    `uvm_error("save_ringo_period_chk",$sformatf("i=%0d, exp_ringo_period1=%1d, hw_ringo_period1[%0d]=%0d",i,exp_ringo_period1,i,hw_ringo_period1[i]))
            end
        end
        4'b1111: begin
            read_ringo_period_reg(0, hw_ringo_period0);            
            read_ringo_period_reg(1, hw_ringo_period1);            
            read_ringo_period_reg(2, hw_ringo_period2);            
            read_ringo_period_reg(3, hw_ringo_period3);            

            for(int i=0; i<8; i++)begin
                exp_ringo_period0 = m_trim_if.ringo_period_cnt0_save_q.pop_front();
                ringo_compare(exp_ringo_period0, hw_ringo_period0[i], result0);
                //if(exp_ringo_period0 != hw_ringo_period0[i])
                if(result0 > 'd2)
                    `uvm_error("save_ringo_period_chk",$sformatf("i=%0d, exp_ringo_period0=%0d, hw_ringo_period0[%0d]=%0d",i,exp_ringo_period0,i,hw_ringo_period0[i]))

                exp_ringo_period1 = m_trim_if.ringo_period_cnt1_save_q.pop_front();
                ringo_compare(exp_ringo_period1, hw_ringo_period1[i], result1);
                //if(exp_ringo_period1 != hw_ringo_period1[i])
                if(result1 > 'd2)
                    `uvm_error("save_ringo_period_chk",$sformatf("i=%0d, exp_ringo_period1=%1d, hw_ringo_period1[%0d]=%0d",i,exp_ringo_period1,i,hw_ringo_period1[i]))

                exp_ringo_period2 = m_trim_if.ringo_period_cnt2_save_q.pop_front();
                ringo_compare(exp_ringo_period2, hw_ringo_period2[i], result2);
                //if(exp_ringo_period2 != hw_ringo_period2[i])
                if(result2 > 'd2)
                    `uvm_error("save_ringo_period_chk",$sformatf("i=%0d, exp_ringo_period2=%0d, hw_ringo_period2[%0d]=%0d",i,exp_ringo_period2,i,hw_ringo_period2[i]))

                exp_ringo_period3 = m_trim_if.ringo_period_cnt3_save_q.pop_front();
                ringo_compare(exp_ringo_period3, hw_ringo_period3[i], result3);
                //if(exp_ringo_period3 != hw_ringo_period3[i])
                if(result3 > 'd2)
                    `uvm_error("save_ringo_period_chk",$sformatf("i=%0d, exp_ringo_period3=%1d, hw_ringo_period3[%0d]=%0d",i,exp_ringo_period3,i,hw_ringo_period3[i]))
            end
        end

        `ifdef DRAM_6
        6'b11_1111: begin
            read_ringo_period_reg(0, hw_ringo_period0);            
            read_ringo_period_reg(1, hw_ringo_period1);            
            read_ringo_period_reg(2, hw_ringo_period2);            
            read_ringo_period_reg(3, hw_ringo_period3);            
            read_ringo_period_reg(4, hw_ringo_period4);            
            read_ringo_period_reg(5, hw_ringo_period5);            

            for(int i=0; i<8; i++)begin
                exp_ringo_period0 = m_trim_if.ringo_period_cnt0_save_q.pop_front();
                ringo_compare(exp_ringo_period0, hw_ringo_period0[i], result0);
                //if(exp_ringo_period0 != hw_ringo_period0[i])
                if(result0 > 'd2)
                    `uvm_error("save_ringo_period_chk",$sformatf("i=%0d, exp_ringo_period0=%0d, hw_ringo_period0[%0d]=%0d",i,exp_ringo_period0,i,hw_ringo_period0[i]))

                exp_ringo_period1 = m_trim_if.ringo_period_cnt1_save_q.pop_front();
                ringo_compare(exp_ringo_period1, hw_ringo_period1[i], result1);
                //if(exp_ringo_period1 != hw_ringo_period1[i])
                if(result1 > 'd2)
                    `uvm_error("save_ringo_period_chk",$sformatf("i=%0d, exp_ringo_period1=%1d, hw_ringo_period1[%0d]=%0d",i,exp_ringo_period1,i,hw_ringo_period1[i]))

                exp_ringo_period2 = m_trim_if.ringo_period_cnt2_save_q.pop_front();
                ringo_compare(exp_ringo_period2, hw_ringo_period2[i], result2);
                //if(exp_ringo_period2 != hw_ringo_period2[i])
                if(result2 > 'd2)
                    `uvm_error("save_ringo_period_chk",$sformatf("i=%0d, exp_ringo_period2=%0d, hw_ringo_period2[%0d]=%0d",i,exp_ringo_period2,i,hw_ringo_period2[i]))

                exp_ringo_period3 = m_trim_if.ringo_period_cnt3_save_q.pop_front();
                ringo_compare(exp_ringo_period3, hw_ringo_period3[i], result3);
                //if(exp_ringo_period3 != hw_ringo_period3[i])
                if(result3 > 'd2)
                    `uvm_error("save_ringo_period_chk",$sformatf("i=%0d, exp_ringo_period3=%1d, hw_ringo_period3[%0d]=%0d",i,exp_ringo_period3,i,hw_ringo_period3[i]))

                exp_ringo_period4 = m_trim_if.ringo_period_cnt4_save_q.pop_front();
                ringo_compare(exp_ringo_period4, hw_ringo_period4[i], result4);
                //if(exp_ringo_period4 != hw_ringo_period4[i])
                if(result4 > 'd2)
                    `uvm_error("save_ringo_period_chk",$sformatf("i=%0d, exp_ringo_period4=%1d, hw_ringo_period4[%0d]=%0d",i,exp_ringo_period4,i,hw_ringo_period4[i]))

                exp_ringo_period5 = m_trim_if.ringo_period_cnt5_save_q.pop_front();
                ringo_compare(exp_ringo_period5, hw_ringo_period5[i], result5);
                //if(exp_ringo_period5 != hw_ringo_period5[i])
                if(result5 > 'd2)
                    `uvm_error("save_ringo_period_chk",$sformatf("i=%0d, exp_ringo_period5=%1d, hw_ringo_period5[%0d]=%0d",i,exp_ringo_period5,i,hw_ringo_period5[i]))
            end
        end
        `endif
        endcase
    endtask: hw_save_ringo_reg_chk

    task read_ringo_period_reg();
        input int layer_sel;
        output bit [9:0]   hw_ringo_period[8]/*, hw_ringo_period_10, hw_ringo_period_20, hw_ringo_period_30*/ ;
        //output bit [9:0]   hw_ringo_period_1/*, hw_ringo_period_11, hw_ringo_period_21, hw_ringo_period_31*/ ;
        //output bit [9:0]   hw_ringo_period_2/*, hw_ringo_period_12, hw_ringo_period_22, hw_ringo_period_32*/ ;
        //output bit [9:0]   hw_ringo_period_3/*, hw_ringo_period_13, hw_ringo_period_23, hw_ringo_period_33*/ ;
        //output bit [9:0]   hw_ringo_period_4/*, hw_ringo_period_14, hw_ringo_period_24, hw_ringo_period_34*/ ;
        //output bit [9:0]   hw_ringo_period_5/*, hw_ringo_period_15, hw_ringo_period_25, hw_ringo_period_35*/ ;
        //output bit [9:0]   hw_ringo_period_6/*, hw_ringo_period_16, hw_ringo_period_26, hw_ringo_period_36*/ ;
        //output bit [9:0]   hw_ringo_period_7/*, hw_ringo_period_17, hw_ringo_period_27, hw_ringo_period_37*/ ;

        case(layer_sel)
            0: begin
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_01.hw_ringo_dram0_period0.read(status,hw_ringo_period[0],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_01.hw_ringo_dram0_period1.read(status,hw_ringo_period[1],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_23.hw_ringo_dram0_period2.read(status,hw_ringo_period[2],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_23.hw_ringo_dram0_period3.read(status,hw_ringo_period[3],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_45.hw_ringo_dram0_period4.read(status,hw_ringo_period[4],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_45.hw_ringo_dram0_period5.read(status,hw_ringo_period[5],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_67.hw_ringo_dram0_period6.read(status,hw_ringo_period[6],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram0_period_67.hw_ringo_dram0_period7.read(status,hw_ringo_period[7],UVM_FRONTDOOR);                
            end
            1: begin
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_01.hw_ringo_dram1_period0.read(status,hw_ringo_period[0],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_01.hw_ringo_dram1_period1.read(status,hw_ringo_period[1],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_23.hw_ringo_dram1_period2.read(status,hw_ringo_period[2],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_23.hw_ringo_dram1_period3.read(status,hw_ringo_period[3],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_45.hw_ringo_dram1_period4.read(status,hw_ringo_period[4],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_45.hw_ringo_dram1_period5.read(status,hw_ringo_period[5],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_67.hw_ringo_dram1_period6.read(status,hw_ringo_period[6],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram1_period_67.hw_ringo_dram1_period7.read(status,hw_ringo_period[7],UVM_FRONTDOOR);                
            end
            2: begin
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_01.hw_ringo_dram2_period0.read(status,hw_ringo_period[0],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_01.hw_ringo_dram2_period1.read(status,hw_ringo_period[1],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_23.hw_ringo_dram2_period2.read(status,hw_ringo_period[2],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_23.hw_ringo_dram2_period3.read(status,hw_ringo_period[3],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_45.hw_ringo_dram2_period4.read(status,hw_ringo_period[4],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_45.hw_ringo_dram2_period5.read(status,hw_ringo_period[5],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_67.hw_ringo_dram2_period6.read(status,hw_ringo_period[6],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram2_period_67.hw_ringo_dram2_period7.read(status,hw_ringo_period[7],UVM_FRONTDOOR);                
            end
            3: begin
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_01.hw_ringo_dram3_period0.read(status,hw_ringo_period[0],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_01.hw_ringo_dram3_period1.read(status,hw_ringo_period[1],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_23.hw_ringo_dram3_period2.read(status,hw_ringo_period[2],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_23.hw_ringo_dram3_period3.read(status,hw_ringo_period[3],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_45.hw_ringo_dram3_period4.read(status,hw_ringo_period[4],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_45.hw_ringo_dram3_period5.read(status,hw_ringo_period[5],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_67.hw_ringo_dram3_period6.read(status,hw_ringo_period[6],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram3_period_67.hw_ringo_dram3_period7.read(status,hw_ringo_period[7],UVM_FRONTDOOR);                
            end

            `ifdef DRAM_6
            4: begin
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_01.hw_ringo_dram4_period0.read(status,hw_ringo_period[0],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_01.hw_ringo_dram4_period1.read(status,hw_ringo_period[1],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_23.hw_ringo_dram4_period2.read(status,hw_ringo_period[2],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_23.hw_ringo_dram4_period3.read(status,hw_ringo_period[3],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_45.hw_ringo_dram4_period4.read(status,hw_ringo_period[4],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_45.hw_ringo_dram4_period5.read(status,hw_ringo_period[5],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_67.hw_ringo_dram4_period6.read(status,hw_ringo_period[6],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram4_period_67.hw_ringo_dram4_period7.read(status,hw_ringo_period[7],UVM_FRONTDOOR);                
            end
            5: begin
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_01.hw_ringo_dram5_period0.read(status,hw_ringo_period[0],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_01.hw_ringo_dram5_period1.read(status,hw_ringo_period[1],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_23.hw_ringo_dram5_period2.read(status,hw_ringo_period[2],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_23.hw_ringo_dram5_period3.read(status,hw_ringo_period[3],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_45.hw_ringo_dram5_period4.read(status,hw_ringo_period[4],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_45.hw_ringo_dram5_period5.read(status,hw_ringo_period[5],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_67.hw_ringo_dram5_period6.read(status,hw_ringo_period[6],UVM_FRONTDOOR);
                p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_dram5_period_67.hw_ringo_dram5_period7.read(status,hw_ringo_period[7],UVM_FRONTDOOR);                
            end
            `endif
        endcase
    endtask: read_ringo_period_reg

    task hw_res_chk(input int layer_sel, input bit hw_op_tsv_load_sel, input int res_value_sel, input bit[`RES_WIDTH-1:0] cfg_res);
        case(layer_sel)
            0: begin
                case(res_value_sel)
                    1: begin
                        if(hw_op_tsv_load_sel == 0)begin
                            `uvm_info("DEBUG", $sformatf("------------enter re-dump----------"), UVM_LOW)
                            @(negedge m_trim_if.tm_redump[0]);
                            `uvm_info("DEBUG", $sformatf("------------enter re-dump----------"), UVM_LOW)
                            if(m_trim_if.tsv_tm[258] != cfg_res[1] || m_trim_if.tsv_tm[259] != cfg_res[0])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[259:258]=%0b, cfg_res[1:0]=%0b", m_trim_if.tsv_tm[259:258], cfg_res[1:0]))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        else begin
                            `uvm_info("DEBUG", $sformatf("------------enter re-active spine_reset_n----------"), UVM_LOW)
                            @(negedge m_trim_if.spine_reset_n[0]);
                            @(posedge m_trim_if.spine_reset_n[0]);
                            if(m_trim_if.tsv_tm[258] != cfg_res[1] || m_trim_if.tsv_tm[259] != cfg_res[0])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, cfg_res=%0b", m_trim_if.tsv_tm, cfg_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                    end
                    2: begin
                        if(hw_op_tsv_load_sel == 0)begin
                            @(negedge m_trim_if.tm_redump[0]);
                            if(m_trim_if.tsv_tm[258] != m_trim_if.trim_res[1] || m_trim_if.tsv_tm[259] != m_trim_if.trim_res[0])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, trim_res=%0b", m_trim_if.tsv_tm, m_trim_if.trim_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        else begin
                            @(negedge m_trim_if.spine_reset_n[0]);
                            @(posedge m_trim_if.spine_reset_n[0]);
                            if(m_trim_if.tsv_tm[258] != m_trim_if.trim_res[1] || m_trim_if.tsv_tm[259] != m_trim_if.trim_res[0])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, trim_res=%0b", m_trim_if.tsv_tm, m_trim_if.trim_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end                        
                    end
                endcase
            end
            1: begin
                case(res_value_sel)
                    1: begin
                        if(hw_op_tsv_load_sel == 0)begin
                            @(negedge m_trim_if.tm_redump[1]);
                            if(m_trim_if.tsv_tm[258] != cfg_res[3] || m_trim_if.tsv_tm[259] != cfg_res[2])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, cfg_res=%0b", m_trim_if.tsv_tm, cfg_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        else begin
                            @(negedge m_trim_if.spine_reset_n[1]);
                            @(posedge m_trim_if.spine_reset_n[1]);
                            if(m_trim_if.tsv_tm[258] != cfg_res[3] || m_trim_if.tsv_tm[259] != cfg_res[2])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, cfg_res=%0b", m_trim_if.tsv_tm, cfg_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                    end
                    2: begin
                        if(hw_op_tsv_load_sel == 0)begin
                            @(negedge m_trim_if.tm_redump[1]);
                            if(m_trim_if.tsv_tm[258] != m_trim_if.trim_res[3] || m_trim_if.tsv_tm[259] != m_trim_if.trim_res[2])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, trim_res=%0b", m_trim_if.tsv_tm, m_trim_if.trim_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        else begin
                            @(negedge m_trim_if.spine_reset_n[1]);
                            @(posedge m_trim_if.spine_reset_n[1]);
                            if(m_trim_if.tsv_tm[258] != m_trim_if.trim_res[3] || m_trim_if.tsv_tm[259] != m_trim_if.trim_res[2])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, trim_res=%0b", m_trim_if.tsv_tm, m_trim_if.trim_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end                        
                    end
                endcase                
            end
            2: begin
                case(res_value_sel)
                    1: begin
                        if(hw_op_tsv_load_sel == 0)begin
                            @(negedge m_trim_if.tm_redump[2]);
                            if(m_trim_if.tsv_tm[258] != cfg_res[5] || m_trim_if.tsv_tm[259] != cfg_res[4])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, cfg_res=%0b", m_trim_if.tsv_tm, cfg_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        else begin
                            @(negedge m_trim_if.spine_reset_n[2]);
                            @(posedge m_trim_if.spine_reset_n[2]);
                            if(m_trim_if.tsv_tm[258] != cfg_res[5] || m_trim_if.tsv_tm[259] != cfg_res[4])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, cfg_res=%0b", m_trim_if.tsv_tm, cfg_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                    end
                    2: begin
                        if(hw_op_tsv_load_sel == 0)begin
                            @(negedge m_trim_if.tm_redump[2]);
                            if(m_trim_if.tsv_tm[258] != m_trim_if.trim_res[5] || m_trim_if.tsv_tm[259] != m_trim_if.trim_res[4])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, trim_res=%0b", m_trim_if.tsv_tm, m_trim_if.trim_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        else begin
                            @(negedge m_trim_if.spine_reset_n[2]);
                            @(posedge m_trim_if.spine_reset_n[2]);
                            if(m_trim_if.tsv_tm[258] != m_trim_if.trim_res[5] || m_trim_if.tsv_tm[259] != m_trim_if.trim_res[4])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, trim_res=%0b", m_trim_if.tsv_tm, m_trim_if.trim_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end                        
                    end
                endcase
            end
            3: begin
                case(res_value_sel)
                    1: begin
                        if(hw_op_tsv_load_sel == 0)begin
                            @(negedge m_trim_if.tm_redump[3]);
                            if(m_trim_if.tsv_tm[258] != cfg_res[7] || m_trim_if.tsv_tm[259] != cfg_res[6])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, cfg_res=%0b", m_trim_if.tsv_tm, cfg_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        else begin
                            @(negedge m_trim_if.spine_reset_n[3]);
                            @(posedge m_trim_if.spine_reset_n[3]);
                            if(m_trim_if.tsv_tm[258] != cfg_res[7] || m_trim_if.tsv_tm[259] != cfg_res[6])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, cfg_res=%0b", m_trim_if.tsv_tm, cfg_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                    end
                    2: begin
                        if(hw_op_tsv_load_sel == 0)begin
                            @(negedge m_trim_if.tm_redump[3]);
                            if(m_trim_if.tsv_tm[258] != m_trim_if.trim_res[7] || m_trim_if.tsv_tm[259] != m_trim_if.trim_res[6])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, trim_res=%0b", m_trim_if.tsv_tm, m_trim_if.trim_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        else begin
                            @(negedge m_trim_if.spine_reset_n[3]);
                            @(posedge m_trim_if.spine_reset_n[3]);
                            if(m_trim_if.tsv_tm[258] != m_trim_if.trim_res[7] || m_trim_if.tsv_tm[259] != m_trim_if.trim_res[6])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, trim_res=%0b", m_trim_if.tsv_tm, m_trim_if.trim_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end                        
                    end
                endcase                
            end

            `ifdef DRAM_6
            4: begin
                case(res_value_sel)
                    1: begin
                        if(hw_op_tsv_load_sel == 0)begin
                            @(negedge m_trim_if.tm_redump[4]);
                            if(m_trim_if.tsv_tm[258] != cfg_res[9] || m_trim_if.tsv_tm[259] != cfg_res[8])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, cfg_res=%0b", m_trim_if.tsv_tm, cfg_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        else begin
                            @(negedge m_trim_if.spine_reset_n[4]);
                            @(posedge m_trim_if.spine_reset_n[4]);
                            if(m_trim_if.tsv_tm[258] != cfg_res[9] || m_trim_if.tsv_tm[259] != cfg_res[8])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, cfg_res=%0b", m_trim_if.tsv_tm, cfg_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                    end
                    2: begin
                        if(hw_op_tsv_load_sel == 0)begin
                            @(negedge m_trim_if.tm_redump[4]);
                            if(m_trim_if.tsv_tm[258] != m_trim_if.trim_res[9] || m_trim_if.tsv_tm[259] != m_trim_if.trim_res[8])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, trim_res=%0b", m_trim_if.tsv_tm, m_trim_if.trim_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        else begin
                            @(negedge m_trim_if.spine_reset_n[4]);
                            @(posedge m_trim_if.spine_reset_n[4]);
                            if(m_trim_if.tsv_tm[258] != m_trim_if.trim_res[9] || m_trim_if.tsv_tm[259] != m_trim_if.trim_res[8])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, trim_res=%0b", m_trim_if.tsv_tm, m_trim_if.trim_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end                        
                    end
                endcase                
            end            
            5: begin
                case(res_value_sel)
                    1: begin
                        if(hw_op_tsv_load_sel == 0)begin
                            @(negedge m_trim_if.tm_redump[5]);
                            if(m_trim_if.tsv_tm[258] != cfg_res[11] || m_trim_if.tsv_tm[259] != cfg_res[10])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, cfg_res=%0b", m_trim_if.tsv_tm, cfg_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        else begin
                            @(negedge m_trim_if.spine_reset_n[5]);
                            @(posedge m_trim_if.spine_reset_n[5]);
                            if(m_trim_if.tsv_tm[258] != cfg_res[11] || m_trim_if.tsv_tm[259] != cfg_res[10])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, cfg_res=%0b", m_trim_if.tsv_tm, cfg_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                    end
                    2: begin
                        if(hw_op_tsv_load_sel == 0)begin
                            @(negedge m_trim_if.tm_redump[5]);
                            if(m_trim_if.tsv_tm[258] != m_trim_if.trim_res[11] || m_trim_if.tsv_tm[259] != m_trim_if.trim_res[10])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, trim_res=%0b", m_trim_if.tsv_tm, m_trim_if.trim_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end
                        else begin
                            @(negedge m_trim_if.spine_reset_n[5]);
                            @(posedge m_trim_if.spine_reset_n[5]);
                            if(m_trim_if.tsv_tm[258] != m_trim_if.trim_res[11] || m_trim_if.tsv_tm[259] != m_trim_if.trim_res[10])
                                `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm=%0b, trim_res=%0b", m_trim_if.tsv_tm, m_trim_if.trim_res))
                            if(m_trim_if.trim_op_flow==0)begin
                                if(m_trim_if.tsv_tm[246:238] != 'h0) //add 0815
                                    `uvm_error("hw_res_chk", $sformatf("m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                            end
                        end                        
                    end
                endcase                
            end
            `endif
        endcase
    endtask: hw_res_chk


    //--------------------------------------timeout check---------------------------------------Start
    task redump_timout_rdy_wait(input bit[`DRAM_LAYER-1:0] dmp_rdy_force_flag);
        bit [`DRAM_LAYER-1:0]   dp_rdy_timeout_rdy = 'h0;

        fork
            if(dmp_rdy_force_flag[0] == 1)begin
                redump_timout_rdy(0);
            end
            if(dmp_rdy_force_flag[1] == 1)begin
                redump_timout_rdy(1);
            end
            if(dmp_rdy_force_flag[2] == 1)begin
                redump_timout_rdy(2);
            end
            if(dmp_rdy_force_flag[3] == 1)begin
                redump_timout_rdy(3);
            end

            `ifdef DRAM_6
            if(dmp_rdy_force_flag[4] == 1)begin
                redump_timout_rdy(4);
            end
            if(dmp_rdy_force_flag[5] == 1)begin
                redump_timout_rdy(5);
            end
            `endif
        join

        p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.dumpready_timeout_ready.read(status,dp_rdy_timeout_rdy,UVM_FRONTDOOR);
        `ifdef DRAM_6
        for(int i=0; i<6; i++)begin
        `else
        for(int i=0; i<4; i++)begin
        `endif
            if(dmp_rdy_force_flag[i] == 1)begin
                if(dp_rdy_timeout_rdy[i] != 'h1)
                    `uvm_error("dp_rdy_timeout_rdy", $sformatf("redump_timout_ready check failed, dp_rdy_timeout_rdy[%0d]=%0h", i, dp_rdy_timeout_rdy[0]))
            end
        end
        
    endtask: redump_timout_rdy_wait

    task redump_timout_rdy(input int layer_sel);
        case(layer_sel)
            0: begin
                @(posedge m_trim_if.tm_redump[0]);
                @(negedge m_trim_if.tm_redump[0]);
                //0731//uvm_hdl_force("trim_tb.u_quad_group.u_quad_group_0.XDFT1.DUMP_READY", 0);
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[0]", 0);

                //wait dumpready_timeout_ready:
                @(posedge m_trim_if.dumpready_timeout_ready[0]);
            end
            1: begin
                @(posedge m_trim_if.tm_redump[1]);
                @(negedge m_trim_if.tm_redump[1]);
                //0731//uvm_hdl_force("trim_tb.u_quad_group.u_quad_group_1.XDFT1.DUMP_READY", 0);        
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[1]", 0); //due to protect

                //wait dumpready_timeout_ready:
                @(posedge m_trim_if.dumpready_timeout_ready[1]);
            end
            2: begin
                @(posedge m_trim_if.tm_redump[2]);
                @(negedge m_trim_if.tm_redump[2]);
                //0731//uvm_hdl_force("trim_tb.u_quad_group.u_quad_group_2.XDFT1.DUMP_READY", 0);        
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[2]", 0);        

                //wait dumpready_timeout_ready:
                @(posedge m_trim_if.dumpready_timeout_ready[2]); 
            end
            3: begin
                @(posedge m_trim_if.tm_redump[3]);
                @(negedge m_trim_if.tm_redump[3]);
                //0731//uvm_hdl_force("trim_tb.u_quad_group.u_quad_group_3.XDFT1.DUMP_READY", 0);        
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[3]", 0);

                //wait dumpready_timeout_ready:
                @(posedge m_trim_if.dumpready_timeout_ready[3]); 
            end

            `ifdef DRAM_6
            4: begin
                @(posedge m_trim_if.tm_redump[4]);
                @(negedge m_trim_if.tm_redump[4]);
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[4]", 0);

                //wait dumpready_timeout_ready:
                @(posedge m_trim_if.dumpready_timeout_ready[4]); 
            end
            5: begin
                @(posedge m_trim_if.tm_redump[5]);
                @(negedge m_trim_if.tm_redump[5]);
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[5]", 0);

                //wait dumpready_timeout_ready:
                @(posedge m_trim_if.dumpready_timeout_ready[5]); 
            end
            `endif
        endcase
    endtask: redump_timout_rdy

    task dump_ready_release(input bit[`DRAM_LAYER-1:0] dmp_rdy_force_flag);
        fork
            if(dmp_rdy_force_flag[0]==1)begin
                //0731//uvm_hdl_force("trim_tb.u_quad_group.u_quad_group_0.XDFT1.DUMP_READY", 1);
                //0731//uvm_hdl_release("trim_tb.u_quad_group.u_quad_group_0.XDFT1.DUMP_READY");
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[0]", 1);
                uvm_hdl_release("trim_tb.u_quad_group.dump_ready[0]");
            end
            if(dmp_rdy_force_flag[1]==1)begin
                //0731//uvm_hdl_force("trim_tb.u_quad_group.u_quad_group_1.XDFT1.DUMP_READY", 1);
                //0731//uvm_hdl_release("trim_tb.u_quad_group.u_quad_group_1.XDFT1.DUMP_READY");                
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[1]", 1);
                uvm_hdl_release("trim_tb.u_quad_group.dump_ready[1]");
            end
            if(dmp_rdy_force_flag[2]==1)begin
                //0731//uvm_hdl_force("trim_tb.u_quad_group.u_quad_group_2.XDFT1.DUMP_READY", 1);
                //0731//uvm_hdl_release("trim_tb.u_quad_group.u_quad_group_2.XDFT1.DUMP_READY");                
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[2]", 1);
                uvm_hdl_release("trim_tb.u_quad_group.dump_ready[2]");
            end
            if(dmp_rdy_force_flag[3]==1)begin
                //0731//uvm_hdl_force("trim_tb.u_quad_group.u_quad_group_3.XDFT1.DUMP_READY", 1);
                //0731//uvm_hdl_release("trim_tb.u_quad_group.u_quad_group_3.XDFT1.DUMP_READY");                
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[3]", 1);
                uvm_hdl_release("trim_tb.u_quad_group.dump_ready[3]");
            end

            `ifdef DRAM_6
            if(dmp_rdy_force_flag[4]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[4]", 1);
                uvm_hdl_release("trim_tb.u_quad_group.dump_ready[4]");
            end
            if(dmp_rdy_force_flag[5]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.dump_ready[5]", 1);
                uvm_hdl_release("trim_tb.u_quad_group.dump_ready[5]");
            end
            `endif
        join
        
    endtask: dump_ready_release


    task redump_timeout_chk(input bit[`DRAM_LAYER-1:0] dram_layer_sel, input bit[9:0] tm_redump_width, input bit[23:0] dumpready_timeout_time);
        case(dram_layer_sel)
            4'b0001: redump_timeout_width_chk(0, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
            4'b0010: redump_timeout_width_chk(1, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
            4'b0100: redump_timeout_width_chk(2, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
            4'b1000: redump_timeout_width_chk(3, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
            4'b0011: begin
                fork
                    redump_timeout_width_chk(0, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
                    redump_timeout_width_chk(1, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
                join
            end
            4'b1111: begin
                fork
                    redump_timeout_width_chk(0, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
                    redump_timeout_width_chk(1, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
                    redump_timeout_width_chk(2, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
                    redump_timeout_width_chk(3, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
                join
            end

            `ifdef DRAM_6
            6'b01_0000: redump_timeout_width_chk(4, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
            6'b10_0000: redump_timeout_width_chk(5, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
            6'b11_1111: begin
                fork
                    redump_timeout_width_chk(0, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
                    redump_timeout_width_chk(1, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
                    redump_timeout_width_chk(2, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
                    redump_timeout_width_chk(3, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
                    redump_timeout_width_chk(4, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
                    redump_timeout_width_chk(5, dram_layer_sel, tm_redump_width,dumpready_timeout_time);
                join
            end
            `endif
        endcase
    endtask: redump_timeout_chk

    task redump_timeout_width_chk(input int layer_sel, input bit[`DRAM_LAYER-1:0] dram_layer_sel, input bit[9:0] tm_redump_width, input bit[23:0] dumpready_timeout_time);
        bit [`DRAM_LAYER-1:0]  dmp_rdy_timeout_rdy = 'h0;

        case(layer_sel)
            0: begin
                wait(m_trim_if.tm_redump[0]==1);
                fork: tm_redump0
                    begin
                        wait(m_trim_if.tm_redump[0]==0);
                        if(m_trim_if.tm_redump_cnt0 != tm_redump_width+1)
                            `uvm_error("redump_timeout_width_chk", $sformatf("tm_redump keep 1 width check faile, tm_redump_cnt0=%0h, tm_redump_width=%0h", m_trim_if.tm_redump_cnt0, tm_redump_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.tm_redump_cnt0++;
                    end
                    //begin
                    //    //different layer have different delay
                    //    repeat(3)@(posedge m_trim_if.clk);
                    //    while(1)begin
                    //        @(posedge m_trim_if.clk);
                    //        dump_ready_other_bit_chk(dram_layer_sel);
                    //    end
                    //end
                join_any
                disable tm_redump0;
                m_trim_if.tm_redump_cnt0 = 0;
                
                
                fork: dump_ready0
                    begin
                        @(posedge m_trim_if.dumpready_timeout_ready[0]);
                        if(m_trim_if.dmp_rdy_timeout_cnt0 != dumpready_timeout_time+1)
                            `uvm_error("dump_rdy_timeout_chk", $sformatf("dmp_rdy_timeout_cnt0=%0d, dumpready_timeout_time=%0d", m_trim_if.dmp_rdy_timeout_cnt0,dumpready_timeout_time))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.dmp_rdy_timeout_cnt0++;
                    end
                join_any
                disable dump_ready0;
                m_trim_if.dmp_rdy_timeout_cnt0 = 0;
                
            end
            1: begin
                wait(m_trim_if.tm_redump[1]==1);
                fork: tm_redump1
                    begin
                        wait(m_trim_if.tm_redump[1]==0);
                        if(m_trim_if.tm_redump_cnt1 != tm_redump_width+1)
                            `uvm_error("redump_timeout_width_chk", $sformatf("tm_redump keep 1 width check faile, tm_redump_cnt1=%0h, tm_redump_width=%0h", m_trim_if.tm_redump_cnt1, tm_redump_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.tm_redump_cnt1++;
                    end
                    //begin
                    //    //different layer have different delay
                    //    repeat(3)@(posedge m_trim_if.clk);
                    //    while(1)begin
                    //        @(posedge m_trim_if.clk);
                    //        dump_ready_other_bit_chk(dram_layer_sel);
                    //    end
                    //end
                join_any
                disable tm_redump1;
                m_trim_if.tm_redump_cnt1 = 0;
                
                
                fork: dump_ready1
                    begin
                        @(posedge m_trim_if.dumpready_timeout_ready[1]);
                        if(m_trim_if.dmp_rdy_timeout_cnt1 != dumpready_timeout_time+1)
                            `uvm_error("dump_rdy_timeout_chk", $sformatf("dmp_rdy_timeout_cnt1=%0d, dumpready_timeout_time=%0d", m_trim_if.dmp_rdy_timeout_cnt1,dumpready_timeout_time))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.dmp_rdy_timeout_cnt1++;
                    end 
                join_any
                disable dump_ready1;
                m_trim_if.dmp_rdy_timeout_cnt1 = 0;
                
            end
            2: begin
                wait(m_trim_if.tm_redump[2]==1);
                fork: tm_redump2
                    begin
                        wait(m_trim_if.tm_redump[2]==0);
                        if(m_trim_if.tm_redump_cnt2 != tm_redump_width+1)
                            `uvm_error("redump_timeout_width_chk", $sformatf("tm_redump keep 1 width check faile, tm_redump_cnt2=%0h, tm_redump_width=%0h", m_trim_if.tm_redump_cnt2, tm_redump_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.tm_redump_cnt2++;
                    end
                    //begin
                    //    //different layer have different delay
                    //    repeat(3)@(posedge m_trim_if.clk);
                    //    while(1)begin
                    //        @(posedge m_trim_if.clk);
                    //        dump_ready_other_bit_chk(dram_layer_sel);
                    //    end
                    //end
                join_any
                disable tm_redump2;
                m_trim_if.tm_redump_cnt2 = 0;
                
                
                fork: dump_ready2
                    begin
                        @(posedge m_trim_if.dumpready_timeout_ready[2]);
                        if(m_trim_if.dmp_rdy_timeout_cnt2 != dumpready_timeout_time+1)
                            `uvm_error("dump_rdy_timeout_chk", $sformatf("dmp_rdy_timeout_cnt2=%0d, dumpready_timeout_time=%0d", m_trim_if.dmp_rdy_timeout_cnt2,dumpready_timeout_time))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.dmp_rdy_timeout_cnt2++;
                    end 
                join_any
                disable dump_ready2;
                m_trim_if.dmp_rdy_timeout_cnt2 = 0;
            end
            3: begin
                wait(m_trim_if.tm_redump[3]==1);
                fork: tm_redump3
                    begin
                        wait(m_trim_if.tm_redump[3]==0);
                        if(m_trim_if.tm_redump_cnt3 != tm_redump_width+1)
                            `uvm_error("redump_timeout_width_chk", $sformatf("tm_redump keep 1 width check faile, tm_redump_cnt3=%0h, tm_redump_width=%0h", m_trim_if.tm_redump_cnt3, tm_redump_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.tm_redump_cnt3++;
                    end
                    //begin
                    //    //different layer have different delay
                    //    repeat(3)@(posedge m_trim_if.clk);
                    //    while(1)begin
                    //        @(posedge m_trim_if.clk);
                    //        dump_ready_other_bit_chk(dram_layer_sel);
                    //    end
                    //end
                join_any
                disable tm_redump3;
                m_trim_if.tm_redump_cnt3 = 0;
                
                
                fork: dump_ready3
                    begin
                        @(posedge m_trim_if.dumpready_timeout_ready[3]);
                        if(m_trim_if.dmp_rdy_timeout_cnt3 != dumpready_timeout_time+1)
                            `uvm_error("dump_rdy_timeout_chk", $sformatf("dmp_rdy_timeout_cnt3=%0d, dumpready_timeout_time=%0d", m_trim_if.dmp_rdy_timeout_cnt3,dumpready_timeout_time))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.dmp_rdy_timeout_cnt3++;
                    end 
                join_any
                disable dump_ready3;
                m_trim_if.dmp_rdy_timeout_cnt3 = 0;
            end            

            `ifdef DRAM_6
            4: begin
                wait(m_trim_if.tm_redump[4]==1);
                fork: tm_redump4
                    begin
                        wait(m_trim_if.tm_redump[4]==0);
                        if(m_trim_if.tm_redump_cnt4 != tm_redump_width+1)
                            `uvm_error("redump_timeout_width_chk", $sformatf("tm_redump keep 1 width check faile, tm_redump_cnt4=%0h, tm_redump_width=%0h", m_trim_if.tm_redump_cnt4, tm_redump_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.tm_redump_cnt4++;
                    end
                join_any
                disable tm_redump4;
                m_trim_if.tm_redump_cnt4 = 0;
                
                fork: dump_ready4
                    begin
                        @(posedge m_trim_if.dumpready_timeout_ready[4]);
                        if(m_trim_if.dmp_rdy_timeout_cnt4 != dumpready_timeout_time+1)
                            `uvm_error("dump_rdy_timeout_chk", $sformatf("dmp_rdy_timeout_cnt4=%0d, dumpready_timeout_time=%0d", m_trim_if.dmp_rdy_timeout_cnt4,dumpready_timeout_time))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.dmp_rdy_timeout_cnt4++;
                    end 
                join_any
                disable dump_ready4;
                m_trim_if.dmp_rdy_timeout_cnt4 = 0;
            end
            5: begin
                wait(m_trim_if.tm_redump[5]==1);
                fork: tm_redump5
                    begin
                        wait(m_trim_if.tm_redump[5]==0);
                        if(m_trim_if.tm_redump_cnt5 != tm_redump_width+1)
                            `uvm_error("redump_timeout_width_chk", $sformatf("tm_redump keep 1 width check faile, tm_redump_cnt5=%0h, tm_redump_width=%0h", m_trim_if.tm_redump_cnt5, tm_redump_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.tm_redump_cnt5++;
                    end
                join_any
                disable tm_redump5;
                m_trim_if.tm_redump_cnt5 = 0;
                
                fork: dump_ready5
                    begin
                        @(posedge m_trim_if.dumpready_timeout_ready[5]);
                        if(m_trim_if.dmp_rdy_timeout_cnt5 != dumpready_timeout_time+1)
                            `uvm_error("dump_rdy_timeout_chk", $sformatf("dmp_rdy_timeout_cnt5=%0d, dumpready_timeout_time=%0d", m_trim_if.dmp_rdy_timeout_cnt5,dumpready_timeout_time))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.dmp_rdy_timeout_cnt5++;
                    end 
                join_any
                disable dump_ready5;
                m_trim_if.dmp_rdy_timeout_cnt5 = 0;
            end
            `endif
        endcase
    endtask: redump_timeout_width_chk


    //-----------------------ringo timeout----------------------start
    task ringo_timeout(input bit[`DRAM_LAYER-1:0] ringo_force_flag);
        fork
            if(ringo_force_flag[0]==1)begin
                ringo_force(0);
            end
            if(ringo_force_flag[1]==1)begin
                ringo_force(1);
            end
            if(ringo_force_flag[2]==1)begin
                ringo_force(2);
            end
            if(ringo_force_flag[3]==1)begin
                ringo_force(3);
            end

            `ifdef DRAM_6
            if(ringo_force_flag[4]==1)begin
                ringo_force(4);
            end
            if(ringo_force_flag[5]==1)begin
                ringo_force(5);
            end
            `endif
        join
        
    endtask: ringo_timeout

    task ringo_force(input int layer_sel);
        case(layer_sel)
            0: begin
                @(posedge m_trim_if.stopwatch_period[0]);
                //0731//uvm_hdl_force("trim_tb.u_quad_group.u_quad_group_0.XDFT1.STOPWATCH_RINGO", 0);
                uvm_hdl_force("trim_tb.u_quad_group.stopwatch_ringo[0]", 0); //due to protect
            end
            1: begin
                @(posedge m_trim_if.stopwatch_period[1]);
                //0731//uvm_hdl_force("trim_tb.u_quad_group.u_quad_group_1.XDFT1.STOPWATCH_RINGO", 0);
                uvm_hdl_force("trim_tb.u_quad_group.stopwatch_ringo[1]", 0); //due to protect
            end
            2: begin
                @(posedge m_trim_if.stopwatch_period[2]);
                //0731//uvm_hdl_force("trim_tb.u_quad_group.u_quad_group_2.XDFT1.STOPWATCH_RINGO", 0);
                uvm_hdl_force("trim_tb.u_quad_group.stopwatch_ringo[2]", 0); //due to protect
            end
            3: begin
                @(posedge m_trim_if.stopwatch_period[3]);
                //0731//uvm_hdl_force("trim_tb.u_quad_group.u_quad_group_3.XDFT1.STOPWATCH_RINGO", 0);
                uvm_hdl_force("trim_tb.u_quad_group.stopwatch_ringo[3]", 0); //due to protect
            end

            `ifdef DRAM_6
            4: begin
                @(posedge m_trim_if.stopwatch_period[4]);
                uvm_hdl_force("trim_tb.u_quad_group.stopwatch_ringo[4]", 0); //due to protect
            end            
            5: begin
                @(posedge m_trim_if.stopwatch_period[5]);
                uvm_hdl_force("trim_tb.u_quad_group.stopwatch_ringo[5]", 0); //due to protect
            end
            `endif
        endcase
    endtask: ringo_force

    task ringo_release(input bit[`DRAM_LAYER-1:0] ringo_force_flag);
        fork
            if(ringo_force_flag[0]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.stopwatch_ringo[0]", 1); //due to protect
                uvm_hdl_release("trim_tb.u_quad_group.stopwatch_ringo[0]"); //due to protect
            end
            if(ringo_force_flag[1]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.stopwatch_ringo[1]", 1); //due to protect
                uvm_hdl_release("trim_tb.u_quad_group.stopwatch_ringo[1]"); //due to protect
            end
            if(ringo_force_flag[2]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.stopwatch_ringo[2]", 1); //due to protect
                uvm_hdl_release("trim_tb.u_quad_group.stopwatch_ringo[2]"); //due to protect
            end
            if(ringo_force_flag[3]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.stopwatch_ringo[3]", 1); //due to protect
                uvm_hdl_release("trim_tb.u_quad_group.stopwatch_ringo[3]"); //due to protect
            end

            `ifdef DRAM_6
            if(ringo_force_flag[4]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.stopwatch_ringo[4]", 1); //due to protect
                uvm_hdl_release("trim_tb.u_quad_group.stopwatch_ringo[4]"); //due to protect
            end
            if(ringo_force_flag[5]==1)begin
                uvm_hdl_force("trim_tb.u_quad_group.stopwatch_ringo[5]", 1); //due to protect
                uvm_hdl_release("trim_tb.u_quad_group.stopwatch_ringo[5]"); //due to protect
            end
            `endif
        join
        
    endtask: ringo_release


    task ringo_timeout_chk(input bit[`DRAM_LAYER-1:0] dram_layer_sel, input bit[15:0] stopwatch_period_width, input bit[23:0] ringo_timeout_time);
        case(dram_layer_sel)
            4'b0001: ringo_timeout_period_width_chk(0, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
            4'b0010: ringo_timeout_period_width_chk(1, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
            4'b0100: ringo_timeout_period_width_chk(2, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
            4'b1000: ringo_timeout_period_width_chk(3, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
            4'b0011: begin
                fork
                    ringo_timeout_period_width_chk(0, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
                    ringo_timeout_period_width_chk(1, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
                join
            end
            4'b1111: begin
                fork
                    ringo_timeout_period_width_chk(0, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
                    ringo_timeout_period_width_chk(1, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
                    ringo_timeout_period_width_chk(2, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
                    ringo_timeout_period_width_chk(3, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
                join
            end

            `ifdef DRAM_6
            6'b01_0000: ringo_timeout_period_width_chk(4, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
            6'b10_0000: ringo_timeout_period_width_chk(5, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
            6'b11_1111: begin
                fork
                    ringo_timeout_period_width_chk(0, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
                    ringo_timeout_period_width_chk(1, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
                    ringo_timeout_period_width_chk(2, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
                    ringo_timeout_period_width_chk(3, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
                    ringo_timeout_period_width_chk(4, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
                    ringo_timeout_period_width_chk(5, dram_layer_sel, stopwatch_period_width, ringo_timeout_time);
                join
            end
            `endif
        endcase
    endtask: ringo_timeout_chk

    task ringo_timeout_period_width_chk(input int layer_sel,input bit[`DRAM_LAYER-1:0] dram_layer_sel,input bit[15:0] stopwatch_period_width,input bit[23:0] ringo_timeout_time);
        case(layer_sel)
            0: begin
                wait(m_trim_if.stopwatch_period[0]==1);
                fork: ringo_0
                    begin
                        wait(m_trim_if.stopwatch_period[0]==0);
                        if(m_trim_if.ringo_cnt0 != stopwatch_period_width+1)
                            `uvm_error("ringo_timeout_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, ringo_cnt0=%0d, stopwatch_period_width=%0d", m_trim_if.ringo_cnt0, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_cnt0++;
                    end
                    //0806-timeout//begin
                    //0806-timeout//    //repeat(3)@(posedge m_trim_if.clk);
                    //0806-timeout//    while(1)begin
                    //0806-timeout//        @(posedge m_trim_if.clk);
                    //0806-timeout//        stopwatch_period_other_bit_chk(dram_layer_sel);
                    //0806-timeout//    end
                    //0806-timeout//end
                join_any
                disable ringo_0;
                m_trim_if.ringo_cnt0 = 0;

                fork: ringo_period_0
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.ringo_timeout_cnt0 == ringo_timeout_time)begin
                            if(m_trim_if.stopwatch_ringo[0] != 0)
                                `uvm_error("ringo_timeout_period_width_chk", $sformatf("ringo timeout check failed"))

                            m_trim_if.ringo_timeout[0] = 1;
                            break;
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_timeout_cnt0++;
                    end
                join_any
                disable ringo_period_0;
                //ringo_period_cnt0 clear in case
                m_trim_if.ringo_timeout_cnt0 = 0;
            end
            1: begin
                wait(m_trim_if.stopwatch_period[1]==1);
                fork: ringo_1
                    begin
                        wait(m_trim_if.stopwatch_period[1]==0);
                        if(m_trim_if.ringo_cnt1 != stopwatch_period_width+1)
                            `uvm_error("ringo_timeout_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, ringo_cnt1=%0d, stopwatch_period_width=%0d", m_trim_if.ringo_cnt1, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_cnt1++;
                    end
                    //0806-timeout//begin
                    //0806-timeout//    //repeat(3)@(posedge m_trim_if.clk);
                    //0806-timeout//    while(1)begin
                    //0806-timeout//        @(posedge m_trim_if.clk);
                    //0806-timeout//        stopwatch_period_other_bit_chk(dram_layer_sel);
                    //0806-timeout//    end
                    //0806-timeout//end
                join_any
                disable ringo_1;
                m_trim_if.ringo_cnt1 = 0;

                fork: ringo_period_1
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.ringo_timeout_cnt1 == ringo_timeout_time)begin
                            if(m_trim_if.stopwatch_ringo[1] != 0)
                                `uvm_error("ringo_timeout_period_width_chk", $sformatf("ringo timeout check failed"))

                            m_trim_if.ringo_timeout[1] = 1;
                            break;
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_timeout_cnt1++;
                    end
                join_any
                disable ringo_period_1;
                //ringo_period_cnt1 clear in case
                m_trim_if.ringo_timeout_cnt1 = 0;
            end
            2: begin
                wait(m_trim_if.stopwatch_period[2]==1);
                fork: ringo_2
                    begin
                        wait(m_trim_if.stopwatch_period[2]==0);
                        if(m_trim_if.ringo_cnt2 != stopwatch_period_width+1)
                            `uvm_error("ringo_timeout_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, ringo_cnt2=%0d, stopwatch_period_width=%0d", m_trim_if.ringo_cnt2, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_cnt2++;
                    end
                    //0806-timeout//begin
                    //0806-timeout//    //repeat(3)@(posedge m_trim_if.clk);
                    //0806-timeout//    while(1)begin
                    //0806-timeout//        @(posedge m_trim_if.clk);
                    //0806-timeout//        stopwatch_period_other_bit_chk(dram_layer_sel);
                    //0806-timeout//    end
                    //0806-timeout//end
                join_any
                disable ringo_2;
                m_trim_if.ringo_cnt2 = 0;

                fork: ringo_period_2
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.ringo_timeout_cnt2 == ringo_timeout_time)begin
                            if(m_trim_if.stopwatch_ringo[2] != 0)
                                `uvm_error("ringo_timeout_period_width_chk", $sformatf("ringo timeout check failed"))

                            m_trim_if.ringo_timeout[2] = 1;
                            break;
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_timeout_cnt2++;
                    end
                join_any
                disable ringo_period_2;
                //ringo_period_cnt1 clear in case
                m_trim_if.ringo_timeout_cnt2 = 0;
            end

            3: begin
                wait(m_trim_if.stopwatch_period[3]==1);
                fork: ringo_3
                    begin
                        wait(m_trim_if.stopwatch_period[3]==0);
                        if(m_trim_if.ringo_cnt3 != stopwatch_period_width+1)
                            `uvm_error("ringo_timeout_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, ringo_cnt3=%0d, stopwatch_period_width=%0d", m_trim_if.ringo_cnt3, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_cnt3++;
                    end
                    //0806-timeout//begin
                    //0806-timeout//    //repeat(3)@(posedge m_trim_if.clk);
                    //0806-timeout//    while(1)begin
                    //0806-timeout//        @(posedge m_trim_if.clk);
                    //0806-timeout//        stopwatch_period_other_bit_chk(dram_layer_sel);
                    //0806-timeout//    end
                    //0806-timeout//end
                join_any
                disable ringo_3;
                m_trim_if.ringo_cnt3 = 0;

                fork: ringo_period_3
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.ringo_timeout_cnt3 == ringo_timeout_time)begin
                            if(m_trim_if.stopwatch_ringo[3] != 0)
                                `uvm_error("ringo_timeout_period_width_chk", $sformatf("ringo timeout check failed"))

                            m_trim_if.ringo_timeout[3] = 1;
                            break;
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_timeout_cnt3++;
                    end
                join_any
                disable ringo_period_3;
                //ringo_period_cnt1 clear in case
                m_trim_if.ringo_timeout_cnt3 = 0;
            end

            `ifdef DRAM_6
            4: begin
                wait(m_trim_if.stopwatch_period[4]==1);
                fork: ringo_4
                    begin
                        wait(m_trim_if.stopwatch_period[4]==0);
                        if(m_trim_if.ringo_cnt4 != stopwatch_period_width+1)
                            `uvm_error("ringo_timeout_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, ringo_cnt4=%0d, stopwatch_period_width=%0d", m_trim_if.ringo_cnt4, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_cnt4++;
                    end
                join_any
                disable ringo_4;
                m_trim_if.ringo_cnt4 = 0;

                fork: ringo_period_4
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.ringo_timeout_cnt4 == ringo_timeout_time)begin
                            if(m_trim_if.stopwatch_ringo[4] != 0)
                                `uvm_error("ringo_timeout_period_width_chk", $sformatf("ringo timeout check failed"))

                            m_trim_if.ringo_timeout[4] = 1;
                            break;
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_timeout_cnt4++;
                    end
                join_any
                disable ringo_period_4;
                //ringo_period_cnt1 clear in case
                m_trim_if.ringo_timeout_cnt4 = 0;
            end
            5: begin
                wait(m_trim_if.stopwatch_period[5]==1);
                fork: ringo_5
                    begin
                        wait(m_trim_if.stopwatch_period[5]==0);
                        if(m_trim_if.ringo_cnt5 != stopwatch_period_width+1)
                            `uvm_error("ringo_timeout_period_width_chk", $sformatf("stopwatch_period keep 1 width check faile, ringo_cnt5=%0d, stopwatch_period_width=%0d", m_trim_if.ringo_cnt5, stopwatch_period_width))
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_cnt5++;
                    end
                join_any
                disable ringo_5;
                m_trim_if.ringo_cnt5 = 0;

                fork: ringo_period_5
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        if(m_trim_if.ringo_timeout_cnt5 == ringo_timeout_time)begin
                            if(m_trim_if.stopwatch_ringo[5] != 0)
                                `uvm_error("ringo_timeout_period_width_chk", $sformatf("ringo timeout check failed"))

                            m_trim_if.ringo_timeout[5] = 1;
                            break;
                        end
                    end
                    while(1)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.ringo_timeout_cnt5++;
                    end
                join_any
                disable ringo_period_5;
                //ringo_period_cnt1 clear in case
                m_trim_if.ringo_timeout_cnt5 = 0;
            end
            `endif
        endcase
    endtask: ringo_timeout_period_width_chk

    task interrupt_reg_check(input bit int_mask);
        bit         int_flag=0;

        //check interrupt:
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_interrupt_ctrl.trim_interrupt_flag.read(status,int_flag,UVM_FRONTDOOR);
        if(int_flag != 1)
            `uvm_error("trim_soft_timeout_vseq", $sformatf("int_flag check failed"))

        if(int_mask==0)begin
            if(m_trim_if.trim_interrupt != 1)
                `uvm_error("trim_soft_timeout_vseq", $sformatf("trim_interrupt check failed"))
        end
        else begin
            if(m_trim_if.trim_interrupt != 0)
                `uvm_error("trim_soft_timeout_vseq", $sformatf("trim_interrupt check failed"))
        end

        //clr int:
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_interrupt_ctrl.trim_interrupt_clr.write(status,1,UVM_FRONTDOOR);

        repeat(10)@(m_apb_if.pclk);
        //check interrupt:
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_interrupt_ctrl.trim_interrupt_flag.read(status,int_flag,UVM_FRONTDOOR);
        if(int_flag != 0)
            `uvm_error("trim_soft_timeout_vseq", $sformatf("int_flag check failed"))
        
        if(m_trim_if.trim_interrupt != 0)
            `uvm_error("trim_soft_timeout_vseq", $sformatf("trim_interrupt check failed"))        
    endtask: interrupt_reg_check

    
    //add for timeout case-0829:
    task change_res_mode(input bit[`DRAM_LAYER-1:0] dram_layer_sel_cfg, input bit hw_op_tsv_load_sel);
        if(hw_op_tsv_load_sel == 0)begin //redump op:
            case(dram_layer_sel_cfg)
                'b0001: @(negedge m_trim_if.tm_redump[0]);
                'b0011: begin
                    fork
                        @(negedge m_trim_if.tm_redump[0]);
                        @(negedge m_trim_if.tm_redump[1]);
                    join
                end
                'b1111: begin
                    fork
                        @(negedge m_trim_if.tm_redump[0]);
                        @(negedge m_trim_if.tm_redump[1]);
                        @(negedge m_trim_if.tm_redump[2]);
                        @(negedge m_trim_if.tm_redump[3]);
                    join
                end
                `ifdef DRAM_6
                6'b11_1111: begin
                    fork
                        @(negedge m_trim_if.tm_redump[0]);
                        @(negedge m_trim_if.tm_redump[1]);
                        @(negedge m_trim_if.tm_redump[2]);
                        @(negedge m_trim_if.tm_redump[3]);
                        @(negedge m_trim_if.tm_redump[4]);
                        @(negedge m_trim_if.tm_redump[5]);
                    join
                end
                `endif
            endcase
        end
        else begin //spine_reset_n op:
            case(dram_layer_sel_cfg)
                'b0001: begin
                    @(negedge m_trim_if.spine_reset_n[0]);
                    @(posedge m_trim_if.spine_reset_n[0]);
                end
                'b0011: begin
                    fork
                        begin
                            @(negedge m_trim_if.spine_reset_n[0]);
                            @(posedge m_trim_if.spine_reset_n[0]);
                        end
                        begin
                            @(negedge m_trim_if.spine_reset_n[1]);
                            @(posedge m_trim_if.spine_reset_n[1]);
                        end
                    join
                end
                'b1111: begin
                    fork
                        begin
                            @(negedge m_trim_if.spine_reset_n[0]);
                            @(posedge m_trim_if.spine_reset_n[0]);
                        end
                        begin
                            @(negedge m_trim_if.spine_reset_n[1]);
                            @(posedge m_trim_if.spine_reset_n[1]);
                        end
                        begin
                            @(negedge m_trim_if.spine_reset_n[2]);
                            @(posedge m_trim_if.spine_reset_n[2]);
                        end
                        begin
                            @(negedge m_trim_if.spine_reset_n[3]);
                            @(posedge m_trim_if.spine_reset_n[3]);
                        end
                    join
                end
                `ifdef DRAM_6
                6'b11_1111: begin
                    fork
                        begin
                            @(negedge m_trim_if.spine_reset_n[0]);
                            @(posedge m_trim_if.spine_reset_n[0]);
                        end
                        begin
                            @(negedge m_trim_if.spine_reset_n[1]);
                            @(posedge m_trim_if.spine_reset_n[1]);
                        end
                        begin
                            @(negedge m_trim_if.spine_reset_n[2]);
                            @(posedge m_trim_if.spine_reset_n[2]);
                        end
                        begin
                            @(negedge m_trim_if.spine_reset_n[3]);
                            @(posedge m_trim_if.spine_reset_n[3]);
                        end
                        begin
                            @(negedge m_trim_if.spine_reset_n[4]);
                            @(posedge m_trim_if.spine_reset_n[4]);
                        end
                        begin
                            @(negedge m_trim_if.spine_reset_n[5]);
                            @(posedge m_trim_if.spine_reset_n[5]);
                        end
                    join
                end
                `endif
            endcase
        end
    endtask: change_res_mode

    //--------------------------------------timeout check---------------------------------------End


endclass

`endif //TRIM_COMMON_VSEQ_SV

