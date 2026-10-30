`ifndef TRIM_SOFT_TIMEOUT_VSEQ_SV
`define TRIM_SOFT_TIMEOUT_VSEQ_SV

class trim_soft_timeout_vseq extends trim_common_vseq;
    
    bit [427:0]         tsv_tm = 'h0;
    //bit [3:0]           dp_rdy_timeout_rdy;
    bit [`DRAM_LAYER-1:0]           dp_rdy_timeout_flag, ringo_timeout_flag, dp_rdy_timeout_rdy;
    bit                 int_flag;
    bit [`DRAM_LAYER-1:0]           dram_layer_sel, dram_layer_sel_timeout, dram_layer_ringo_cfg;
    bit [2:0]           dump_rdy_timeout_sel;
    bit [23:0]          dump_rdy_timeout_time_first;
    bit [23:0]          ringo_timeout_time_first;
    bit                 dump_rdy_timeout_en;
    bit                 ringo_timeout_en;

    rand bit [27:0]     init_spine_reset_time;
    rand bit [`DRAM_LAYER-1:0]      dram_layer_sel_cfg;
    rand bit [9:0]      sp_rst_width;
    rand bit [9:0]      tm_redump_width;
    rand bit [15:0]     stopwatch_period_width_ringo;
    rand bit [15:0]     stopwatch_period_width_res;
    rand bit [8:0]      ringo_mode;

    rand bit            tsv_can_use;
    rand bit            tsv_load_sel;
    //0724//rand bit            ringo_sel;

    rand bit            int_mask;
    rand bit [23:0]     dump_rdy_timeout_time;
    rand bit [23:0]     ringo_timeout_time;

    rand bit [`DRAM_LAYER-1:0]      sp_rst_force_dp_rdy, dmp_rdy_force_flag, ringo_force_flag;
    rand bit [2:0]      dump_rdy_timeout_sel_rand;

    `uvm_object_utils(trim_soft_timeout_vseq)


    constraint time_c{
        init_spine_reset_time dist {[28'h6_1A7F:28'h7A_11FF]:/90};  //1ms~20ms
        `ifdef DRAM_6
        dram_layer_sel_cfg inside {6'b0001,6'b0010,6'b0100,6'b1000,6'b0011,6'b1111,6'b01_0000,6'b10_0000,6'b11_1111};
        `else
        dram_layer_sel_cfg inside {4'b0001,4'b0010,4'b0100,4'b1000,4'b0011,4'b1111};
        `endif
        sp_rst_width inside {['d3:'d19]}; //10~50ns
        tm_redump_width inside {['d3:'h3ff]}; //10~2560ns
        //0731//stopwatch_period_width_ringo == 'd3; //10ns /*inside {['d3:'d399],['d400:'hffff]}; //10ns~163us, 10ns:3*/
        //0731//stopwatch_period_width_res == 'd399; //1us /*inside {['d399:'hffff]}; //1us~163us, 1us:399*/
        stopwatch_period_width_ringo dist {['d3:'d399]:/99,['d400:'hffff]:/1}; //10ns~1us, /*inside {['d3:'d399],['d400:'hffff]}; //10ns~163us, 10ns:3*/
        stopwatch_period_width_res dist {'d399, 'd400, 'd401}; //1us, 1us+2.5ns, 1us+5ns, 1us:399
        ringo_mode inside {9'h5a,9'h58,9'h68,9'h48,9'h70,9'h50,9'h60,9'h40};
        dump_rdy_timeout_time dist {[24'hC3500:24'h1e8480]:/45, [24'h1e8481:24'h3d0900]:/45, [24'h3d0901:24'h7a1200]:/10}; //2ms~5ms,,5ms~10ms,10ms~20ms;
        ringo_timeout_time dist {[24'hbb8:24'h4e20]:/45, [24'h4e21:24'h9c40]:/45, [24'h9c41:24'h61a80]:/10}; //7.5us~50us, 50us~100us, 100us~1ms
        //0812//ringo_timeout_time dist {[24'hbb8:24'h61a80]:/90}; //7.5us~1ms

        //0806//if(tsv_load_sel==1){
        //0806//    //dump_rdy_timeout_sel inside {3'b001, 3'b010, 3'b100}; //bit0: power_up, bit1: redump, bit2: re-active spine_reset_n
        //0806//    dump_rdy_timeout_sel inside {3'b001, 3'b010}; //bit0: power_up, bit1: redump, bit2: re-active spine_reset_n
        //0806//}
        //0806//if(tsv_load_sel==0){
        //0806//    dump_rdy_timeout_sel inside {3'b001, 3'b100}; //bit0: power_up, bit1: redump, bit2: re-active spine_reset_n
        //0806//}
        //0806//solve tsv_load_sel before dump_rdy_timeout_sel;

        //if(dram_layer_sel_cfg == 4'b0001){
        //    dmp_rdy_force_flag inside {4'b0,4'b0001};
        //}
        //if(dram_layer_sel_cfg == 4'b0010){
        //    dmp_rdy_force_flag inside {4'b0,4'b0010};
        //}
        //if(dram_layer_sel_cfg == 4'b0100){
        //    dmp_rdy_force_flag inside {4'b0,4'b0100};
        //}
        //if(dram_layer_sel_cfg == 4'b1000){
        //    dmp_rdy_force_flag inside {4'b0,4'b1000};
        //}
        //if(dram_layer_sel_cfg == 4'b0011){
        //    dmp_rdy_force_flag inside {4'b0,4'b0001,4'b0010,4'b0011};
        //}
        //if(dram_layer_sel_cfg == 4'b1111){
        //    dmp_rdy_force_flag inside {[4'b0:4'b1111]};
        //}
        foreach(sp_rst_force_dp_rdy[i]){
            if(dram_layer_sel_cfg[i]==1) {sp_rst_force_dp_rdy[i] dist {0:/10,1:/90};}
            if(dram_layer_sel_cfg[i]==0) {sp_rst_force_dp_rdy[i] == 0;}            
        }

        foreach(dmp_rdy_force_flag[i]){
            if(dram_layer_sel_cfg[i]==1) {dmp_rdy_force_flag[i] dist {0:/10,1:/90};}
            if(dram_layer_sel_cfg[i]==0) {dmp_rdy_force_flag[i] == 0;}
        }

        foreach(ringo_force_flag[i]){
            if(dram_layer_sel_cfg[i]==1) {ringo_force_flag[i] dist {0:/10,1:/90};}
            if(dram_layer_sel_cfg[i]==0) {ringo_force_flag[i] == 0;}
        }

        solve dram_layer_sel_cfg before sp_rst_force_dp_rdy;
        solve dram_layer_sel_cfg before dmp_rdy_force_flag;
        solve dram_layer_sel_cfg before ringo_force_flag;
    }

    function new(string name="trim_soft_timeout_vseq");
        super.new(name);
    endfunction

    virtual task body();
        super.body();
        $display("-------------Enter the trim_soft_timeout_vseq body---------------");
        m_trim_if.trim_op_flow = 1; //add 0815
        
        m_trim_if.timeout_enable = 1;

        assert(randomize());
        if(tsv_load_sel==1)begin
            std::randomize(dump_rdy_timeout_sel_rand)with{dump_rdy_timeout_sel_rand inside {3'b001, 3'b010};};//bit0:power_up, bit1:redump, bit2:re-spine_reset_n
        end
        else begin
            std::randomize(dump_rdy_timeout_sel_rand)with{dump_rdy_timeout_sel_rand inside {3'b001, 3'b100};};//bit0:power_up, bit1:redump, bit2:re-spine_reset_n
        end
        dump_rdy_timeout_sel = dump_rdy_timeout_sel_rand;

        dump_rdy_timeout_en = $urandom_range(1);
        ringo_timeout_en = $urandom_range(1);

        tsv_tm[246:238] = 9'h166;
        init_spine_reset_time = 28'h6_1A7F; //28'h6_1A80: 1ms for debug
        //init_spine_reset_time = 28'hc_34ff; //28'hc_3500: 2ms for debug
        //dump_rdy_timeout_sel = 2; //bit0: power_up, bit1: redump, bit2: re-active spine_reset_n, for debug-0801
        //0812//dump_rdy_timeout_en = 1; //only be 1
        //0812//dump_rdy_timeout_time = 24'hC3500; //2ms for debug
        m_trim_if.dump_rdy_timeout_en = dump_rdy_timeout_en;
        m_trim_if.ringo_timeout_en = ringo_timeout_en;
        p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_en.write(status,dump_rdy_timeout_en,UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_time.write(status,dump_rdy_timeout_time,UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.ringo_timeout_ctrl.ringo_timeout_en.write(status,ringo_timeout_en,UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.ringo_timeout_ctrl.ringo_timeout_time.write(status,ringo_timeout_time,UVM_FRONTDOOR);
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_interrupt_ctrl.trim_interrupt_mask.write(status,int_mask,UVM_FRONTDOOR);
        m_trim_if.sp_rst_force_dp_rdy = sp_rst_force_dp_rdy;
        dump_rdy_timeout_time_first = dump_rdy_timeout_time;
        ringo_timeout_time_first = ringo_timeout_time;
        
        `uvm_info("trim_soft_timeout_vseq", $sformatf("init_spine_reset_time=%0h",init_spine_reset_time), UVM_LOW)
        `uvm_info("trim_soft_timeout_vseq", $sformatf("dump_rdy_timeout_sel = %0b", dump_rdy_timeout_sel), UVM_LOW)
        `uvm_info("trim_soft_timeout_vseq", $sformatf("dump_rdy_timeout_time=%0h, ringo_timeout_time=%0h", dump_rdy_timeout_time, ringo_timeout_time), UVM_LOW)

        fork
            begin
                power_up_init(init_spine_reset_time, tsv_tm);
            end
            begin
                if(dump_rdy_timeout_en == 1 && dump_rdy_timeout_sel[0]==1 & sp_rst_force_dp_rdy != 'h0)begin
                    //force dump_ready and check timeout_dump_ready:
                    sp_rst_force_dump_ready(sp_rst_force_dp_rdy, dump_rdy_timeout_time);

                    //check timeout_dump_ready & flag & interrupt:
                    dp_rdy_timeout_flag = 'h0;

                    //read reg's dumpready_timeout_flag:
                    p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_flag.read(status,dp_rdy_timeout_flag,UVM_FRONTDOOR);
                    for(int i=0; i<`DRAM_LAYER; i++)begin
                        if(sp_rst_force_dp_rdy[i]==1)begin
                            if(dp_rdy_timeout_flag[i] != 1)
                                `uvm_error("trim_soft_timeout_vseq", $sformatf("dp_rdy_timeout_flag[%0d] = %0h", i, dp_rdy_timeout_flag[i]))
                        end
                    end

                    //cfg flag clr:
                    p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_clr.write(status,1,UVM_FRONTDOOR);

                    repeat(10)@(m_apb_if.pclk);
                    //read reg's dumpready_timeout_flag:
                    p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_flag.read(status,dp_rdy_timeout_flag,UVM_FRONTDOOR);
                    if(dp_rdy_timeout_flag != 0)
                        `uvm_error("trim_soft_timeout_vseq", $sformatf("have cfg clr, but dp_rdy_timeout_flag not be 0"))

                    interrupt_reg_check(int_mask);

                    power_up_release_dp_rdy(sp_rst_force_dp_rdy);
                end
                else begin
                    `ifdef DRAM_6
                        wait(m_trim_if.dump_ready == 6'h3f);; //wait dump_ready
                    `else
                        wait(m_trim_if.dump_ready == 4'hf);; //wait dump_ready
                    `endif
                end
            end
        join
        #10us; //have waited dump_ready
        
        for(int ii=0; ii<3; ii++)begin
            if(ii>0)begin
                assert(randomize());
                if(tsv_load_sel==1)begin
                    dump_rdy_timeout_sel = 3'b010;//bit0:power_up, bit1:redump, bit2:re-spine_reset_n
                end
                else begin
                    dump_rdy_timeout_sel = 3'b100;//bit0:power_up, bit1:redump, bit2:re-spine_reset_n
                end
            end
            tsv_can_use = 0; //for timeout case
            //tsv_load_sel = 1; //1: redump op, 0: re-active op, //for debug

            //0812//dump_rdy_timeout_en = 1; //only be 1
            //0812//dump_rdy_timeout_time = 24'hC3500; //2ms for debug
            //0812//ringo_timeout_en = 1; //only be 1
            //0812//ringo_timeout_time = 24'hbb8; //7.5us for debug
            dump_rdy_timeout_time = dump_rdy_timeout_time_first;
            ringo_timeout_time = ringo_timeout_time_first;
            //-------must cfg before init_start: ---------
            //0812//m_trim_if.dump_rdy_timeout_en = dump_rdy_timeout_en;
            //0812//m_trim_if.ringo_timeout_en = ringo_timeout_en;
            //0812//p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_en.write(status,dump_rdy_timeout_en,UVM_FRONTDOOR);
            //0812//p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_time.write(status,dump_rdy_timeout_time,UVM_FRONTDOOR);
            //0812//p_sequencer.regmodel.DRAM_TRIM_ins.ringo_timeout_ctrl.ringo_timeout_en.write(status,ringo_timeout_en,UVM_FRONTDOOR);
            //0812//p_sequencer.regmodel.DRAM_TRIM_ins.ringo_timeout_ctrl.ringo_timeout_time.write(status,ringo_timeout_time,UVM_FRONTDOOR);
            p_sequencer.regmodel.DRAM_TRIM_ins.trim_interrupt_ctrl.trim_interrupt_mask.write(status,int_mask,UVM_FRONTDOOR);
            m_trim_if.sp_rst_force_dp_rdy = sp_rst_force_dp_rdy; //sp_rst
            m_trim_if.dmp_rdy_force_flag = dmp_rdy_force_flag;
            m_trim_if.ringo_force_flag = ringo_force_flag;
            `uvm_info("trim_soft_timeout_vseq", $sformatf("tsv_can_use=%0b, tsv_load_sel=%0h", tsv_can_use, tsv_load_sel), UVM_LOW)
            `uvm_info("trim_soft_timeout_vseq", $sformatf("sp_rst_width=%0h, tm_redump_width=%0h",sp_rst_width,tm_redump_width), UVM_LOW)
            `uvm_info("trim_soft_timeout_vseq", $sformatf("dram_layer_sel_cfg=%0b, ringo_mode=%0h", dram_layer_sel_cfg, ringo_mode), UVM_LOW)
            `uvm_info("trim_soft_timeout_vseq", $sformatf("dmp_rdy_force_flag=%0b, ringo_force_flag=%0b", dmp_rdy_force_flag, ringo_force_flag), UVM_LOW)
            `uvm_info("trim_soft_timeout_vseq", $sformatf("dump_rdy_timeout_sel = %0b", dump_rdy_timeout_sel), UVM_LOW)
            `uvm_info("trim_soft_timeout_vseq", $sformatf("dump_rdy_timeout_en=%0h, ringo_timeout_en=%0h", dump_rdy_timeout_en, ringo_timeout_en), UVM_LOW)
            `uvm_info("trim_soft_timeout_vseq", $sformatf("dump_rdy_timeout_time=%0h, ringo_timeout_time=%0h", dump_rdy_timeout_time, ringo_timeout_time), UVM_LOW)

            if(tsv_can_use == 0)begin
                tsv_tm[246:238] = 9'h166;
                if(tsv_load_sel == 1)begin
                    fork
                        begin
                            `uvm_info("trim_soft_timeout_vseq", $sformatf("----------redump op start-----------"), UVM_LOW)
                            redump(tsv_tm, dram_layer_sel_cfg, tm_redump_width);
                            `uvm_info("trim_soft_timeout_vseq", $sformatf("----------redump op finish-----------"), UVM_LOW)
                        end
                        begin
                            if(dump_rdy_timeout_en==1 && dump_rdy_timeout_sel[1]==1 && dmp_rdy_force_flag!='h0)begin
                                fork
                                    if(dram_layer_sel_cfg[0]==1)begin
                                        `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk0 start---------"), UVM_LOW)
                                        if(dmp_rdy_force_flag[0] == 0 )begin
                                            //check spine_reset_n keep low time is cfg's tm_redump_width:
                                            redump_op_chk(4'b0001, tm_redump_width);
                                        end
                                        else begin //timeout:
                                            redump_timeout_chk(4'b0001, tm_redump_width, dump_rdy_timeout_time);
                                        end
                                        `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk0 finish---------"), UVM_LOW)
                                    end
                                    if(dram_layer_sel_cfg[1]==1)begin
                                        `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk1 start---------"), UVM_LOW)
                                        if(dmp_rdy_force_flag[1] == 0 )begin
                                            //check spine_reset_n keep low time is cfg's tm_redump_width:
                                            redump_op_chk(4'b0010, tm_redump_width);
                                        end
                                        else begin //timeout:
                                            redump_timeout_chk(4'b0010, tm_redump_width, dump_rdy_timeout_time);
                                        end
                                        `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk1 finish---------"), UVM_LOW)
                                    end
                                    if(dram_layer_sel_cfg[2]==1)begin
                                        `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk2 start---------"), UVM_LOW)
                                        if(dmp_rdy_force_flag[2] == 0 )begin
                                            //check spine_reset_n keep low time is cfg's tm_redump_width:
                                            redump_op_chk(4'b0100, tm_redump_width);
                                        end
                                        else begin //timeout:
                                            redump_timeout_chk(4'b0100, tm_redump_width, dump_rdy_timeout_time);
                                        end
                                        `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk2 finish---------"), UVM_LOW)
                                    end
                                    if(dram_layer_sel_cfg[3]==1)begin
                                        `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk3 start---------"), UVM_LOW)
                                        if(dmp_rdy_force_flag[3] == 0 )begin
                                            //check spine_reset_n keep low time is cfg's tm_redump_width:
                                            redump_op_chk(4'b1000, tm_redump_width);
                                        end
                                        else begin //timeout:
                                            redump_timeout_chk(4'b1000, tm_redump_width, dump_rdy_timeout_time);
                                        end
                                        `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk3 finish---------"), UVM_LOW)
                                    end

                                    `ifdef DRAM_6
                                    if(dram_layer_sel_cfg[4]==1)begin
                                        `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk4 start---------"), UVM_LOW)
                                        if(dmp_rdy_force_flag[4] == 0 )begin
                                            //check spine_reset_n keep low time is cfg's tm_redump_width:
                                            redump_op_chk(6'b01_0000, tm_redump_width);
                                        end
                                        else begin //timeout:
                                            redump_timeout_chk(6'b01_0000, tm_redump_width, dump_rdy_timeout_time);
                                        end
                                        `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk4 finish---------"), UVM_LOW)
                                    end
                                    if(dram_layer_sel_cfg[5]==1)begin
                                        `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk5 start---------"), UVM_LOW)
                                        if(dmp_rdy_force_flag[5] == 0 )begin
                                            //check spine_reset_n keep low time is cfg's tm_redump_width:
                                            redump_op_chk(6'b10_0000, tm_redump_width);
                                        end
                                        else begin //timeout:
                                            redump_timeout_chk(6'b10_0000, tm_redump_width, dump_rdy_timeout_time);
                                        end
                                        `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk5 finish---------"), UVM_LOW)
                                    end
                                    `endif
                                join
                            end
                            else begin
                                redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
                            end
                        end
                        begin
                            `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op flag check start---------"), UVM_LOW)
                            `uvm_info("trim_soft_timeout_vseq", $sformatf("dump_rdy_timeout_en=%0d, dmp_rdy_force_flag=%0h, dump_rdy_timeout_sel[1]=%0b", dump_rdy_timeout_en, dmp_rdy_force_flag, dump_rdy_timeout_sel[1]), UVM_LOW)
                            if(dump_rdy_timeout_en == 1 && dmp_rdy_force_flag != 'h0 && dump_rdy_timeout_sel[1] == 1)begin
                                dp_rdy_timeout_flag = 'h0;

                                //wait tm_redump_pos force dump_ready, then wait timeout_dump_ready:
                                redump_timout_rdy_wait(dmp_rdy_force_flag);

                                //read reg's dumpready_timeout_flag:
                                p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_flag.read(status,dp_rdy_timeout_flag,UVM_FRONTDOOR);

                                for(int i=0; i<`DRAM_LAYER; i++)begin
                                    if(dmp_rdy_force_flag[i]==1)begin
                                        if(dp_rdy_timeout_flag[i] != 1)
                                            `uvm_error("trim_soft_timeout_vseq", $sformatf("dp_rdy_timeout_flag[%0d] = %0h", i, dp_rdy_timeout_flag[i]))
                                    end
                                end

                                //cfg flag clr:
                                p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_clr.write(status,1,UVM_FRONTDOOR);

                                repeat(10)@(m_apb_if.pclk);
                                //read reg's dumpready_timeout_flag:
                                p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_flag.read(status,dp_rdy_timeout_flag,UVM_FRONTDOOR);
                                if(dp_rdy_timeout_flag != 0)
                                    `uvm_error("trim_soft_timeout_vseq", $sformatf("have cfg clr, but dp_rdy_timeout_flag not be 0"))

                                //check interrupt:
                                interrupt_reg_check(int_mask);

                                dump_ready_release(dmp_rdy_force_flag);
                            end
                            `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op flag check finish---------"), UVM_LOW)
                        end
                    join
                end
                else begin
                    fork
                        begin
                            re_active_spine_reset_n(tsv_tm, dram_layer_sel_cfg, sp_rst_width);
                        end
                        begin
                            `uvm_info("DEBUG", $sformatf("dump_rdy_timeout_en=%0h, dump_rdy_timeout_sel=%0h", dump_rdy_timeout_en,dump_rdy_timeout_sel), UVM_LOW)
                            if(dump_rdy_timeout_en == 1 && dump_rdy_timeout_sel[2]==1)begin
                                fork
                                    if(dram_layer_sel_cfg[0]==1 && sp_rst_force_dp_rdy[0]==0)begin
                                        re_act_sp_keep_low_chk(4'b0001, sp_rst_width);
                                    end
                                    if(dram_layer_sel_cfg[1]==1 && sp_rst_force_dp_rdy[1]==0)begin
                                        re_act_sp_keep_low_chk(4'b0010, sp_rst_width);
                                    end
                                    if(dram_layer_sel_cfg[2]==1 && sp_rst_force_dp_rdy[2]==0)begin
                                        re_act_sp_keep_low_chk(4'b0100, sp_rst_width);
                                    end
                                    if(dram_layer_sel_cfg[3]==1 && sp_rst_force_dp_rdy[3]==0)begin
                                        re_act_sp_keep_low_chk(4'b1000, sp_rst_width);
                                    end
                                    `ifdef DRAM_6
                                    if(dram_layer_sel_cfg[4]==1 && sp_rst_force_dp_rdy[4]==0)begin
                                        re_act_sp_keep_low_chk(6'b01_0000, sp_rst_width);
                                    end
                                    if(dram_layer_sel_cfg[5]==1 && sp_rst_force_dp_rdy[5]==0)begin
                                        re_act_sp_keep_low_chk(6'b10_0000, sp_rst_width);
                                    end
                                    `endif
                                join
                            end
                            else begin
                                //check spine_reset_n keep low time is cfg's sp_rst_width:
                                re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);
                            end
                        end
                        begin
                            if(dump_rdy_timeout_en == 1 && sp_rst_force_dp_rdy != 'h0 && dump_rdy_timeout_sel[2]==1)begin
                                //force dump_ready and check timeout_dump_ready:
                                sp_rst_force_dump_ready(sp_rst_force_dp_rdy, dump_rdy_timeout_time);

                                //check timeout_dump_ready & flag & interrupt:
                                dp_rdy_timeout_flag = 'h0;
                                dp_rdy_timeout_rdy  = 'h0;

                                //read dumpready_timeout_ready reg:
                                p_sequencer.regmodel.DRAM_TRIM_ins.trim_internal_status.dumpready_timeout_ready.read(status,dp_rdy_timeout_rdy,UVM_FRONTDOOR);
                                for(int i=0; i<`DRAM_LAYER; i++)begin
                                    if(sp_rst_force_dp_rdy[i]==1)begin
                                        if(dp_rdy_timeout_rdy[i] != 1)
                                            `uvm_error("trim_soft_timeout_vseq", $sformatf("dp_rdy_timeout_rdy[%0d] = %0h", i, dp_rdy_timeout_rdy[i]))
                                    end
                                end

                                //read reg's dumpready_timeout_flag:
                                p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_flag.read(status,dp_rdy_timeout_flag,UVM_FRONTDOOR);
                                for(int i=0; i<`DRAM_LAYER; i++)begin
                                    if(sp_rst_force_dp_rdy[i]==1)begin
                                        if(dp_rdy_timeout_flag[i] != 1)
                                            `uvm_error("trim_soft_timeout_vseq", $sformatf("dp_rdy_timeout_flag[%0d] = %0h", i, dp_rdy_timeout_flag[i]))
                                    end
                                end

                                //cfg flag clr:
                                p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_clr.write(status,1,UVM_FRONTDOOR);

                                repeat(10)@(m_apb_if.pclk);
                                //read reg's dumpready_timeout_flag:
                                p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_flag.read(status,dp_rdy_timeout_flag,UVM_FRONTDOOR);
                                if(dp_rdy_timeout_flag != 0)
                                    `uvm_error("trim_soft_timeout_vseq", $sformatf("have cfg clr, but dp_rdy_timeout_flag not be 0"))

                                //check interrupt:
                                interrupt_reg_check(int_mask);

                                power_up_release_dp_rdy(sp_rst_force_dp_rdy);
                            end
                        end
                    join
                end

                //check tsv_tm:
                if(m_trim_if.tsv_tm != tsv_tm)
                    `uvm_error("re_active_spine_reset_n", $sformatf("tsv check failed, cfg tsv_tm=%0h, m_trim_if.tsv_tm=%0h", tsv_tm, m_trim_if.tsv_tm))

                #1ms;
            end

            `uvm_info("trim_soft_timeout_vseq", $sformatf("------------re-active or redump finish-------------"), UVM_LOW)

            //ringo_op:
            fork
                begin
                    tsv_tm[246:238] = ringo_mode;
                    stopwatch_ringo_measurement(tsv_tm, dram_layer_sel_cfg, stopwatch_period_width_ringo, tm_redump_width, sp_rst_width, tsv_load_sel); 
                end
                begin
                    if(ringo_timeout_en==1)begin
                        fork
                            if(dram_layer_sel_cfg[0]==1)begin
                                if(ringo_force_flag[0]==0)begin
                                    ringo_chk(4'b0001, stopwatch_period_width_ringo);
                                end
                                else begin //timeout:
                                    ringo_timeout_chk(4'b0001, stopwatch_period_width_ringo, ringo_timeout_time);
                                end
                            end
                            if(dram_layer_sel_cfg[1]==1)begin
                                if(ringo_force_flag[1]==0)begin
                                    ringo_chk(4'b0010, stopwatch_period_width_ringo);
                                end
                                else begin //timeout:
                                    ringo_timeout_chk(4'b0010, stopwatch_period_width_ringo, ringo_timeout_time);
                                end
                            end
                            if(dram_layer_sel_cfg[2]==1)begin
                                if(ringo_force_flag[2]==0)begin
                                    ringo_chk(4'b0100, stopwatch_period_width_ringo);
                                end
                                else begin //timeout:
                                    ringo_timeout_chk(4'b0100, stopwatch_period_width_ringo, ringo_timeout_time);
                                end
                            end
                            if(dram_layer_sel_cfg[3]==1)begin
                                if(ringo_force_flag[3]==0)begin
                                    ringo_chk(4'b1000, stopwatch_period_width_ringo);
                                end
                                else begin //timeout:
                                    ringo_timeout_chk(4'b1000, stopwatch_period_width_ringo, ringo_timeout_time);
                                end
                            end
                            `ifdef DRAM_6
                            if(dram_layer_sel_cfg[4]==1)begin
                                if(ringo_force_flag[4]==0)begin
                                    ringo_chk(6'b01_0000, stopwatch_period_width_ringo);
                                end
                                else begin //timeout:
                                    ringo_timeout_chk(6'b01_0000, stopwatch_period_width_ringo, ringo_timeout_time);
                                end
                            end
                            if(dram_layer_sel_cfg[5]==1)begin
                                if(ringo_force_flag[5]==0)begin
                                    ringo_chk(6'b10_0000, stopwatch_period_width_ringo);
                                end
                                else begin //timeout:
                                    ringo_timeout_chk(6'b10_0000, stopwatch_period_width_ringo, ringo_timeout_time);
                                end
                            end
                            `endif
                        join
                    end
                    else begin //no timeout:
                        ringo_chk(dram_layer_sel_cfg, stopwatch_period_width_ringo);
                    end
                end
                begin
                    if(ringo_timeout_en==1 && ringo_force_flag != 'h0)begin
                        wait(m_trim_if.ringo_timeout != 'h0);
                        repeat(5)@(posedge m_apb_if.pclk);

                        //ringo timeout have reach, check timeout flag:
                        ringo_timeout_flag = 'h0;
                        p_sequencer.regmodel.DRAM_TRIM_ins.ringo_timeout_ctrl.ringo_timeout_flag.read(status,ringo_timeout_flag,UVM_FRONTDOOR);

                        for(int i=0; i<`DRAM_LAYER; i++)begin
                            if(ringo_force_flag[i]==1)begin
                                if(ringo_timeout_flag[i] != 1)
                                    `uvm_error("trim_soft_timeout_vseq", $sformatf("ringo_timeout_flag[%0d]=%0h", i, ringo_timeout_flag[i]))
                            end
                        end

                        //cfg flag clr:
                        p_sequencer.regmodel.DRAM_TRIM_ins.ringo_timeout_ctrl.ringo_timeout_clr.write(status,1,UVM_FRONTDOOR);

                        repeat(10)@(m_apb_if.pclk);
                        //read ringo_timeout_reg:
                        p_sequencer.regmodel.DRAM_TRIM_ins.ringo_timeout_ctrl.ringo_timeout_flag.read(status,ringo_timeout_flag,UVM_FRONTDOOR);
                        if(ringo_timeout_flag != 'h0)
                            `uvm_error("trim_soft_timeout_vseq", $sformatf("ringo_timeout_flag not be cleared, ringo_timeout_flag=%0h", ringo_timeout_flag))

                        //check interrupt:
                        interrupt_reg_check(int_mask);
                    end
                    m_trim_if.ringo_timeout = 'h0;
                end
                begin
                    //------------for ringo timeout-----------
                    if(ringo_timeout_en)begin
                        //force ringo:
                        ringo_timeout(ringo_force_flag);
                    end
                end
            join    
            //0825//repeat(200)@(posedge m_trim_if.clk);
            #2us; //0825

            //check 4 layer ringo_period:
            if(ringo_timeout_en == 1)begin
                dram_layer_ringo_cfg = ((~ringo_force_flag) & dram_layer_sel_cfg);
                `uvm_info("trim_soft_timeout_vseq", $sformatf("dram_layer_sel_cfg=%0b, ringo_force_flag=%0b, dram_layer_ringo_cfg=%0b", dram_layer_sel_cfg, ringo_force_flag, dram_layer_ringo_cfg), UVM_LOW)
                ringo_reg_chk(dram_layer_ringo_cfg);
                m_trim_if.ringo_period_cnt0 = 0;
                m_trim_if.ringo_period_cnt1 = 0;
                m_trim_if.ringo_period_cnt2 = 0;
                m_trim_if.ringo_period_cnt3 = 0;
                `ifdef DRAM_6
                m_trim_if.ringo_period_cnt4 = 0;
                m_trim_if.ringo_period_cnt5 = 0;
                `endif
            end

            //check tsv_tm:
            if(m_trim_if.tsv_tm != tsv_tm)
                `uvm_error("trim_stopwatch_ringo_seq", $sformatf("tsv check failed, cfg tsv_tm=%0h, m_trim_if.tsv_tm=%0h", tsv_tm, m_trim_if.tsv_tm))

            if(ringo_timeout_en && (ringo_force_flag!='h0))begin
                ringo_release(ringo_force_flag);
            end

            #50us;
            @(posedge m_trim_if.clk);
            m_trim_if.ringo_meas_flag = 0;
            #50us;
            `uvm_info("trim_soft_timeout_vseq", $sformatf("---------ringo finish-------------"), UVM_LOW)
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
            if((m_trim_if.tsv_tm[257:0] != tsv_tm[257:0]) || (m_trim_if.tsv_tm[427:260] != tsv_tm[427:260]))
                `uvm_error("trim_stopwatch_res_seq", $sformatf("tsv check failed:\n\tcfg tsv_tm[257:0]=\n%0h\n\tm_trim_if.tsv_tm[257:0]\n\t=%0h;\n\tcfg tsv_tm[427:260]=\n%0h\n\tm_trim_if.tsv_tm[427:260]\n\t=%0h", tsv_tm[257:0], m_trim_if.tsv_tm[257:0], tsv_tm[427:260], m_trim_if.tsv_tm[427:260]))        

            #1ms;            
        end


        `uvm_info(get_type_name(), $sformatf("-------------trim_soft_timeout_vseq finish---------------"), UVM_LOW)
        #10us;
    endtask: body
endclass


`endif //TRIM_SOFT_TIMEOUT_VSEQ_SV

