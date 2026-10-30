`ifndef TRIM_SOFT_SINGLE_STEP_VSEQ_SV
`define TRIM_SOFT_SINGLE_STEP_VSEQ_SV

/*
**1. trim_power_up_init_vseq
**2. trim_re_active_spine_rst_vseq
**3. trim_redump_vseq
**4. trim_stopwatch_ringo_vseq
**5. trim_stopwatch_res_vseq
*/


class trim_power_up_init_vseq extends trim_common_vseq;

    rand bit [27:0]     init_spine_reset_time;
    rand bit [427:0]    tsv_tm;

    `uvm_object_utils(trim_power_up_init_vseq)


    constraint time_c{
        init_spine_reset_time dist {[28'h6_1A7F:28'h7A_11FF]:/90};  //1ms~20ms
    }

    function new(string name="trim_power_up_init_vseq");
        super.new(name);
    endfunction

    virtual task body();
        super.body();
        $display("-------------Enter the trim_power_up_init_vseq body---------------");
        m_trim_if.trim_op_flow = 1; //add 0815

        assert(randomize());
        //init_spine_reset_time = 28'h6_1A7F; //28'h6_1A80: 1ms for debug
        //init_spine_reset_time = 28'hc_34ff; //28'hc_3500: 2ms for debug
        `uvm_info("trim_power_up_init_vseq", $sformatf("init_spine_reset_time=%0h, tsv_tm=%0h", init_spine_reset_time, tsv_tm), UVM_LOW)
        power_up_init(init_spine_reset_time, tsv_tm);
        #1ms; //wait dump_ready
    
        `uvm_info(get_type_name(), $sformatf("-------------trim_power_up_init_vseq finish---------------"), UVM_LOW)
        #10us;
    endtask: body
endclass


class trim_re_active_spine_rst_vseq extends trim_common_vseq;

    rand bit [27:0]     init_spine_reset_time;
    rand bit [427:0]    tsv_tm;
    rand bit [`DRAM_LAYER-1:0]      dram_layer_sel_cfg;
    rand bit [9:0]      sp_rst_width;

    `uvm_object_utils(trim_re_active_spine_rst_vseq)


    constraint time_c{
        init_spine_reset_time dist {[28'h6_1A7F:28'h7A_11FF]:/90};  //1ms~20ms

        `ifdef DRAM_6
        dram_layer_sel_cfg inside {6'b0001,6'b0010,6'b0100,6'b1000,6'b0011,6'b1111,6'b01_0000,6'b10_0000,6'b11_1111};
        `else
        dram_layer_sel_cfg inside {4'b0001,4'b0010,4'b0100,4'b1000,4'b0011,4'b1111};
        `endif

        sp_rst_width inside {['d3:'d19]}; //10~50ns
    }

    function new(string name="trim_re_active_spine_rst_vseq");
        super.new(name);
    endfunction

    virtual task body();
        super.body();
        $display("-------------Enter the trim_re_active_spine_rst_vseq body---------------");
        m_trim_if.trim_op_flow = 1; //add 0815

        assert(randomize());
        init_spine_reset_time = 28'h6_1A7F; //28'h6_1A80: 1ms for debug
        //init_spine_reset_time = 28'hc_34ff; //28'hc_3500: 2ms for debug
        `uvm_info("trim_re_active_spine_rst_vseq", $sformatf("init_spine_reset_time=%0h, tsv_tm=%0h", init_spine_reset_time, tsv_tm), UVM_LOW)
        power_up_init(init_spine_reset_time, tsv_tm);

        repeat(5)begin
            assert(randomize());
            //dram_layer_sel_cfg = 4'b0001; //for debug
            `uvm_info("trim_re_active_spine_rst_vseq", $sformatf("cfg tsv_tm = %0h", tsv_tm), UVM_LOW)
            `uvm_info("trim_re_active_spine_rst_vseq", $sformatf("cfg dram_layer_sel_cfg = %b, sp_rst_width = %0d", dram_layer_sel_cfg, sp_rst_width), UVM_LOW)
            #1ms;
        
            fork
                begin
                    re_active_spine_reset_n(tsv_tm, dram_layer_sel_cfg, sp_rst_width);
                end
                begin
                    //check spine_reset_n keep low time is cfg's sp_rst_width:
                    re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);
                end
            join

            //check tsv_tm:
            if(m_trim_if.tsv_tm != tsv_tm)
                `uvm_error("re_active_spine_reset_n", $sformatf("tsv check failed, cfg tsv_tm=%0h, m_trim_if.tsv_tm=%0h", tsv_tm, m_trim_if.tsv_tm))        

            #10us;
        end

        `uvm_info(get_type_name(), $sformatf("-------------trim_re_active_spine_rst_vseq finish---------------"), UVM_LOW)
        #10us;
    endtask: body
endclass


class trim_redump_vseq extends trim_common_vseq;

    rand bit [27:0]     init_spine_reset_time;
    rand bit[427:0]     tsv_tm;
    rand bit [`DRAM_LAYER-1:0]      dram_layer_sel_cfg;
    rand bit [9:0]      tm_redump_width;

    `uvm_object_utils(trim_redump_vseq)


    constraint time_c{
        init_spine_reset_time dist {[28'h6_1A7F:28'h7A_11FF]:/90};  //1ms~20ms
        `ifdef DRAM_6
        dram_layer_sel_cfg inside {6'b0001,6'b0010,6'b0100,6'b1000,6'b0011,6'b1111,6'b01_0000,6'b10_0000,6'b11_1111};
        `else
        dram_layer_sel_cfg inside {4'b0001,4'b0010,4'b0100,4'b1000,4'b0011,4'b1111};
        `endif
        tm_redump_width inside {['d3:'h3ff]}; //10~2560ns
    }

    function new(string name="trim_redump_vseq");
        super.new(name);
    endfunction

    virtual task body();
        super.body();
        $display("-------------Enter the trim_redump_vseq body---------------");
        m_trim_if.trim_op_flow = 1; //add 0815

        assert(randomize());
        init_spine_reset_time = 28'h6_1A7F; //28'h6_1A80: 1ms for debug
        //init_spine_reset_time = 28'hc_34ff; //28'hc_3500: 2ms for debug
        `uvm_info("trim_redump_vseq", $sformatf("init_spine_reset_time=%0h, tsv_tm=%0h", init_spine_reset_time, tsv_tm), UVM_LOW)
        power_up_init(init_spine_reset_time, tsv_tm);

        repeat(5)begin
            assert(randomize());
            //dram_layer_sel_cfg = 4'b0001; //for debug
            `uvm_info("trim_redump_vseq", $sformatf("cfg tsv_tm = %0h", tsv_tm), UVM_LOW)
            `uvm_info("trim_redump_vseq", $sformatf("cfg dram_layer_sel_cfg = %b, tm_redump_width = %0d", dram_layer_sel_cfg, tm_redump_width), UVM_LOW)
            #1ms;
            
            fork
                begin
                    redump(tsv_tm, dram_layer_sel_cfg, tm_redump_width);
                end
                begin
                    //check spine_reset_n keep low time is cfg's tm_redump_width:
                    redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
                end
            join

            //check tsv_tm:
            if(m_trim_if.tsv_tm != tsv_tm)
                `uvm_error("trim_redump_vseq", $sformatf("tsv check failed, cfg tsv_tm=%0h, m_trim_if.tsv_tm=%0h", tsv_tm, m_trim_if.tsv_tm))        

            #10us;
        end

        `uvm_info(get_type_name(), $sformatf("-------------trim_redump_vseq finish---------------"), UVM_LOW)
        #10us;
    endtask: body
endclass


class trim_stopwatch_ringo_vseq extends trim_common_vseq;

    rand bit [27:0]     init_spine_reset_time;
    rand bit [427:0]    tsv_tm;
    rand bit [`DRAM_LAYER-1:0]      dram_layer_sel_cfg;
    rand bit [15:0]     stopwatch_period_width;
    rand bit [9:0]      tm_redump_width;
    rand bit [9:0]      sp_rst_width;
    rand bit [8:0]      ringo_mode;
    rand bit            tsv_load_sel;

    //0723//bit [9:0]           ringo_period0, ringo_period1, ringo_period2, ringo_period3;

    `uvm_object_utils(trim_stopwatch_ringo_vseq)


    constraint time_c{
        init_spine_reset_time dist {[28'h6_1A7F:28'h7A_11FF]:/90};  //1ms~20ms
        `ifdef DRAM_6
        dram_layer_sel_cfg inside {6'b0001,6'b0010,6'b0100,6'b1000,6'b0011,6'b1111,6'b01_0000,6'b10_0000,6'b11_1111};
        `else
        dram_layer_sel_cfg inside {4'b0001,4'b0010,4'b0100,4'b1000,4'b0011,4'b1111};
        `endif
        stopwatch_period_width dist {['d3:'d399]:/90,['d400:'hffff]:/10}; //10ns~163us, 400=1us;
        //0728//stopwatch_period_width == 'd3; //test ringo only 10ns
        tm_redump_width inside {['d3:'h3ff]}; //10~2560ns
        sp_rst_width inside {['d3:'d19]}; //10~50ns
        ringo_mode inside {9'h5a,9'h58,9'h68,9'h48,9'h70,9'h50,9'h60,9'h40};
    }

    function new(string name="trim_stopwatch_ringo_vseq");
        super.new(name);
    endfunction

    virtual task body();
        super.body();
        $display("-------------Enter the trim_stopwatch_ringo_vseq body---------------");
        m_trim_if.trim_op_flow = 1; //add 0815

        assert(randomize());
        init_spine_reset_time = 28'h6_1A7F; //28'h6_1A80: 1ms for debug
        //init_spine_reset_time = 28'hc_34ff; //28'hc_3500: 2ms for debug
        `uvm_info("trim_stopwatch_ringo_vseq", $sformatf("init_spine_reset_time=%0h, tsv_tm=%0h", init_spine_reset_time, tsv_tm), UVM_LOW)
        power_up_init(init_spine_reset_time, tsv_tm);
        #1ms;

        repeat(5)begin
            assert(randomize());
            tsv_load_sel = 0; //1: redump op, 0: re-active
            //dram_layer_sel_cfg = 4'b1111; //for debug 
            `uvm_info("trim_stopwatch_ringo_vseq", $sformatf("cfg tsv_tm = %0h", tsv_tm), UVM_LOW)
            `uvm_info("trim_stopwatch_ringo_vseq", $sformatf("cfg dram_layer_sel_cfg = %b, tm_redump_width = %0d, sp_rst_width=%0d", dram_layer_sel_cfg, tm_redump_width, sp_rst_width), UVM_LOW)
            `uvm_info("trim_stopwatch_ringo_vseq", $sformatf("cfg ringo_mode = %0h, stopwatch_period_width=%0d", ringo_mode, stopwatch_period_width), UVM_LOW)
            #10us;
            
            fork
                begin
                    //tsv_tm = 'h0;
                    tsv_tm[246:238] = ringo_mode;
                    stopwatch_ringo_measurement(tsv_tm, dram_layer_sel_cfg, stopwatch_period_width, tm_redump_width, sp_rst_width, tsv_load_sel);
                    //0723//stopwatch_ringo_measurement(tsv_tm, dram_layer_sel_cfg, stopwatch_period_width, tm_redump_width, sp_rst_width, tsv_load_sel, ringo_period0, ringo_period1, ringo_period2, ringo_period3);
                end
                begin
                    //check spine_reset_n keep low time is cfg's tm_redump_width:
                    ringo_chk(dram_layer_sel_cfg, stopwatch_period_width); 
                end
            join
            repeat(10)@(posedge m_trim_if.clk);

            //check 4 layer ringo_period:
            ringo_reg_chk(dram_layer_sel_cfg);
            m_trim_if.ringo_period_cnt0 = 0;
            m_trim_if.ringo_period_cnt1 = 0;
            m_trim_if.ringo_period_cnt2 = 0;
            m_trim_if.ringo_period_cnt3 = 0;
            `ifdef DRAM_6
            m_trim_if.ringo_period_cnt4 = 0;
            m_trim_if.ringo_period_cnt5 = 0;
            `endif

            //check tsv_tm:
            if(m_trim_if.tsv_tm != tsv_tm)
                `uvm_error("trim_stopwatch_ringo_vseq", $sformatf("tsv check failed, cfg tsv_tm=%0h, m_trim_if.tsv_tm=%0h", tsv_tm, m_trim_if.tsv_tm))        

            #1ms;
            @(posedge m_trim_if.clk);
            m_trim_if.ringo_meas_flag = 0;
            //redump to stop ringo:
            `ifdef DRAM_6
            redump(tsv_tm, 6'h3f, tm_redump_width);
            `else
            redump(tsv_tm, 4'hf, tm_redump_width);
            `endif
            #1ms;
        end

        `uvm_info(get_type_name(), $sformatf("-------------trim_stopwatch_ringo_vseq finish---------------"), UVM_LOW)
        #10us;
    endtask: body
endclass


class trim_stopwatch_res_vseq extends trim_common_vseq;

    rand bit [27:0]     init_spine_reset_time;
    rand bit [427:0]    tsv_tm;
    rand bit [`DRAM_LAYER-1:0]      dram_layer_sel_cfg;
    rand bit [15:0]     stopwatch_period_width;
    rand bit [9:0]      tm_redump_width;
    rand bit [9:0]      sp_rst_width;
    rand bit            tsv_load_sel;

    bit [7:0]           osc_tm_res_smp_value;

    `uvm_object_utils(trim_stopwatch_res_vseq)


    constraint time_c{
        init_spine_reset_time dist {[28'h6_1A7F:28'h7A_11FF]:/90};  //1ms~20ms
        `ifdef DRAM_6
        dram_layer_sel_cfg inside {6'b0001,6'b0010,6'b0100,6'b1000,6'b0011,6'b1111,6'b01_0000,6'b10_0000,6'b11_1111};
        `else
        dram_layer_sel_cfg inside {4'b0001,4'b0010,4'b0100,4'b1000,4'b0011,4'b1111};
        `endif
        //stopwatch_period_width inside {['d399:'hffff]}; //1us~163us;
        stopwatch_period_width inside {'d399, 'd400, 'd401}; //1us, 1us+2.5ns, 1us+5ns;
        tm_redump_width inside {['d3:'h3ff]}; //10~2560ns
        sp_rst_width inside {['d3:'d19]}; //10~50ns 
    }

    function new(string name="trim_stopwatch_res_vseq");
        super.new(name);
    endfunction

    virtual task body();
        super.body();
        $display("-------------Enter the trim_stopwatch_res_vseq body---------------");
        m_trim_if.trim_op_flow = 1; //add 0815

        assert(randomize());
        init_spine_reset_time = 28'h6_1A7F; //28'h6_1A80: 1ms for debug
        //init_spine_reset_time = 28'hc_34ff; //28'hc_3500: 2ms for debug
        `uvm_info("trim_stopwatch_res_vseq", $sformatf("init_spine_reset_time=%0h, tsv_tm=%0h", init_spine_reset_time, tsv_tm), UVM_LOW)
        power_up_init(init_spine_reset_time, tsv_tm);
        #1ms;

        repeat(5)begin
            assert(randomize());
            tsv_load_sel = 0; //1: redump op, 0: re-active
            //stopwatch_period_width = 'd399; //1us for debug
            //dram_layer_sel_cfg = 4'b1111; //for debug
            `uvm_info("trim_stopwatch_res_vseq", $sformatf("cfg tsv_tm = %0h", tsv_tm), UVM_LOW)
            `uvm_info("trim_stopwatch_res_vseq", $sformatf("cfg dram_layer_sel_cfg = %b, tm_redump_width = %0d, sp_rst_width=%0d", dram_layer_sel_cfg, tm_redump_width, sp_rst_width), UVM_LOW)
            `uvm_info("trim_stopwatch_res_vseq", $sformatf("cfg stopwatch_period_width = %0d", stopwatch_period_width), UVM_LOW)
            #10us;
            
            fork
                begin
                    //tsv_tm = 'h0;
                    tsv_tm[246:238] = 9'h166;
                    osc_tm_res_sample(tsv_tm, dram_layer_sel_cfg, stopwatch_period_width, tm_redump_width, sp_rst_width, tsv_load_sel);
                end
                begin
                    //check spine_reset_n keep low time is cfg's tm_redump_width:
                    res_sample_chk(dram_layer_sel_cfg, stopwatch_period_width); 
                end
            join

            //check tsv_tm:
            //tsv_tm[246:238] = 'h0; //add 0815
            if((m_trim_if.tsv_tm[257:0] != tsv_tm[257:0]) || (m_trim_if.tsv_tm[427:260] != tsv_tm[427:260]))
            //0818//if((m_trim_if.tsv_tm[237:0] != tsv_tm[237:0] || m_trim_if.tsv_tm[257:247] != tsv_tm[257:247]) || (m_trim_if.tsv_tm[427:260] != tsv_tm[427:260]))
                `uvm_error("trim_stopwatch_res_vseq", $sformatf("tsv check failed:\n\tcfg tsv_tm[257:0]=\n%0h\n\tm_trim_if.tsv_tm[257:0]\n\t=%0h;\n\tcfg tsv_tm[427:260]=\n%0h\n\tm_trim_if.tsv_tm[427:260]\n\t=%0h", tsv_tm[257:0], m_trim_if.tsv_tm[257:0], tsv_tm[427:260], m_trim_if.tsv_tm[427:260]))        

            #1ms; 
        end

        `uvm_info(get_type_name(), $sformatf("-------------trim_stopwatch_res_vseq finish---------------"), UVM_LOW)
        #10us;
    endtask: body
endclass


`endif //TRIM_SOFT_SINGLE_STEP_VSEQ_SV

