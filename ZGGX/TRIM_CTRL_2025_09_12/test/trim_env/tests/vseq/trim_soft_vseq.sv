`ifndef TRIM_SOFT_VSEQ_SV
`define TRIM_SOFT_VSEQ_SV

class trim_soft_vseq extends trim_common_vseq;
    
    bit                 dbg_en;

    //0728//bit [427:0]     tsv_tm = 'h0;
    rand bit [427:0]    tsv_tm;

    rand bit [27:0]     init_spine_reset_time;
    rand bit [`DRAM_LAYER-1:0]      dram_layer_sel_cfg;
    rand bit [9:0]      sp_rst_width;
    rand bit [9:0]      tm_redump_width;
    rand bit [15:0]     stopwatch_period_width_ringo;
    rand bit [15:0]     stopwatch_period_width_res;
    rand bit [8:0]      ringo_mode;

    rand bit            tsv_can_use;
    rand bit            tsv_load_sel;
    //rand bit [1:0]      ringo_sel;

    `uvm_object_utils(trim_soft_vseq)


    constraint time_c{
        init_spine_reset_time dist {[28'h6_1A7F:28'h7A_11FF]:/90};  //1ms~20ms
        `ifdef DRAM_6
        dram_layer_sel_cfg inside {6'b0001,6'b0010,6'b0100,6'b1000,6'b0011,6'b1111,6'b01_0000,6'b10_0000,6'b11_1111};
        `else
        dram_layer_sel_cfg inside {4'b0001,4'b0010,4'b0100,4'b1000,4'b0011,4'b1111};
        `endif
        sp_rst_width inside {['d3:'d19]}; //10~50ns
        tm_redump_width inside {['d3:'h3ff]}; //10~2560ns
        //0728//stopwatch_period_width_ringo == 'd3; //10ns /*inside {['d3:'d399],['d400:'hffff]}; //10ns~163us, 10ns:3*/
        //0728//stopwatch_period_width_res == 'd399; //1us /*inside {['d399:'hffff]}; //1us~163us, 1us:399*/
        stopwatch_period_width_ringo dist {['d3:'d399]:/99,['d400:'hffff]:/1}; //10ns~1us, /*inside {['d3:'d399],['d400:'hffff]}; //10ns~163us, 10ns:3*/
        stopwatch_period_width_res dist {'d399, 'd400, 'd401}; //1us, 1us+2.5ns, 1us+5ns, 1us:399
        ringo_mode inside {9'h5a,9'h58,9'h68,9'h48,9'h70,9'h50,9'h60,9'h40};
        //ringo_sel inside {2'b01, 2'b10, 2'b11};
    }

    function new(string name="trim_soft_vseq");
        super.new(name);
    endfunction

    virtual task body();
        super.body();
        $display("-------------Enter the trim_soft_vseq body---------------");

        m_trim_if.trim_op_flow = 1; //add 0815

        assert(randomize());
        //0724//tsv_can_use = 0; //for debug
        //0725//tsv_load_sel = 0; //redump op
        tsv_tm[246:238] = 9'h166;
        //init_spine_reset_time = 28'h6_1A7F; //28'h6_1A80: 1ms for debug
        //init_spine_reset_time = 28'hc_34ff; //28'hc_3500: 2ms for debug
        `uvm_info("trim_soft_vseq", $sformatf("init_spine_reset_time=%0h",init_spine_reset_time), UVM_LOW)

        dbg_en = $urandom_range(1);
        `uvm_info("trim_soft_vseq", $sformatf("dbg_en = %0h", dbg_en), UVM_LOW)
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.debug_en.write(status,dbg_en,UVM_FRONTDOOR);

        power_up_init(init_spine_reset_time, tsv_tm);
        #1ms; //wait dump_ready
        
        repeat(5)begin
            assert(randomize());
            `uvm_info("trim_soft_vseq", $sformatf("sp_rst_width=%0h, tm_redump_width=%0h, tsv_can_use=%0h",sp_rst_width,tm_redump_width, tsv_can_use), UVM_LOW)
            `uvm_info("trim_soft_vseq", $sformatf("dram_layer_sel_cfg=%0b, ringo_mode=%0h, tsv_load_sel=%0h", dram_layer_sel_cfg, ringo_mode, tsv_load_sel), UVM_LOW)
            //0725//tsv_load_sel = 0; //1: redump op, 0: re-active op

            if(tsv_can_use == 0)begin
                tsv_tm[246:238] = 9'h166;
                if(tsv_load_sel == 1)begin
                    fork
                        redump(tsv_tm, dram_layer_sel_cfg, tm_redump_width);

                        //check spine_reset_n keep low time is cfg's tm_redump_width:
                        redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
                    join
                end
                else begin
                    fork
                        re_active_spine_reset_n(tsv_tm, dram_layer_sel_cfg, sp_rst_width);

                        //check spine_reset_n keep low time is cfg's sp_rst_width:
                        re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);
                    join
                end

                //check tsv_tm:
                if(m_trim_if.tsv_tm != tsv_tm)
                    `uvm_error("re_active_spine_reset_n", $sformatf("tsv check failed, cfg tsv_tm=%0h, m_trim_if.tsv_tm=%0h", tsv_tm, m_trim_if.tsv_tm))

                #1ms;
            end

            //0724//if(ringo_sel[0])begin //ringo_op:
            fork
                begin
                    tsv_tm[246:238] = ringo_mode;
                    stopwatch_ringo_measurement(tsv_tm, dram_layer_sel_cfg, stopwatch_period_width_ringo, tm_redump_width, sp_rst_width, tsv_load_sel); 
                end
                begin
                    //check spine_reset_n keep low time is cfg's tm_redump_width:
                    ringo_chk(dram_layer_sel_cfg, stopwatch_period_width_ringo);                    
                end
            join    
            //0825//repeat(200)@(posedge m_trim_if.clk);
            #2us; //0825

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
                `uvm_error("trim_stopwatch_ringo_seq", $sformatf("tsv check failed, cfg tsv_tm=%0h, m_trim_if.tsv_tm=%0h", tsv_tm, m_trim_if.tsv_tm))

            #50us;
            @(posedge m_trim_if.clk);
            m_trim_if.ringo_meas_flag = 0;
            #50us;
            //0724//end
            //0724//if(ringo_sel[1]) begin//res_smp_op:
            fork
                begin
                    //tsv_tm = 'h0;
                    tsv_tm[246:238] = 9'h166;
                    osc_tm_res_sample(tsv_tm, dram_layer_sel_cfg, stopwatch_period_width_res, tm_redump_width, sp_rst_width, tsv_load_sel);
                end
                begin
                    //check spine_reset_n keep low time is cfg's tm_redump_width:
                    res_sample_chk(dram_layer_sel_cfg, stopwatch_period_width_res); 
                end
            join

            //check tsv_tm:
            if(m_trim_if.tsv_tm[257:0] != tsv_tm[257:0] || (m_trim_if.tsv_tm[427:260] != tsv_tm[427:260]))
                `uvm_error("trim_stopwatch_res_seq", $sformatf("tsv check failed:\n\tcfg tsv_tm[257:0]=\n%0h\n\tm_trim_if.tsv_tm[257:0]\n\t=%0h;\n\tcfg tsv_tm[427:260]=\n%0h\n\tm_trim_if.tsv_tm[427:260]\n\t=%0h", tsv_tm[257:0], m_trim_if.tsv_tm[257:0], tsv_tm[427:260], m_trim_if.tsv_tm[427:260]))        
            

            #1ms;            
            //0724//end
        end


        `uvm_info(get_type_name(), $sformatf("-------------trim_soft_vseq finish---------------"), UVM_LOW)
        #10us;
    endtask: body
endclass


`endif //TRIM_SOFT_VSEQ_SV

