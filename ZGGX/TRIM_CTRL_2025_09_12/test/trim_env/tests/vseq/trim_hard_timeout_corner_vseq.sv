`ifndef TRIM_HARD_TIMEOUT_CORNER_VSEQ_SV
`define TRIM_HARD_TIMEOUT_CORNER_VSEQ_SV

class trim_hard_timeout_corner_vseq extends trim_common_vseq;
    int                 res_value_sel;
    bit                 res_reg_cfg_sel;
    bit [`RES_WIDTH-1:0]           res_reg_value;
    bit [427:0]         tsv_tm = 'h0;
    bit                 ringo_mask_st = 0;
    bit                 hw_start_sel;
    //bit [8:0]           ringo_mode_q[$]; //0729 in interface, due to reset need delete
    bit                 trim_finish;
    bit                 dump_rdy_timeout_en = 1; //only be 1
    bit                 ringo_timeout_en = 1; //only be 1
    bit [`DRAM_LAYER-1:0]           dp_rdy_timeout_flag, ringo_timeout_flag, dp_rdy_timeout_rdy;
    int                 mode_sel;

    rand bit [27:0]     init_spine_reset_time;
    rand bit [`DRAM_LAYER-1:0]      dram_layer_sel_cfg;
    rand bit [9:0]      sp_rst_width;
    rand bit [9:0]      tm_redump_width;
    rand bit [15:0]     stopwatch_period_width_ringo;
    rand bit [15:0]     stopwatch_period_width_res;
    rand bit            hw_op_ringo_mask;
    rand bit            hw_op_tsv_load_sel;
    rand bit [23:0]     dump_rdy_timeout_time;
    rand bit [23:0]     ringo_timeout_time;
    rand bit            int_mask;
    rand bit [`DRAM_LAYER-1:0]      sp_rst_force_dp_rdy, dmp_rdy_force_flag, ringo_force_flag;
    rand bit [2:0]      dump_rdy_timeout_sel;
    //rand bit            tsv_can_use;
    //rand bit            tsv_load_sel;
    //rand bit            ringo_sel;


    `uvm_object_utils(trim_hard_timeout_corner_vseq)


    constraint time_c{
        init_spine_reset_time dist {[28'h6_1A7F:28'h7A_11FF]:/90};  //1ms~20ms
        `ifdef DRAM_6
        dram_layer_sel_cfg inside {6'b0001,6'b0011,6'b1111,6'b11_1111};
        `else
        dram_layer_sel_cfg inside {4'b0001,4'b0011,4'b1111};
        `endif
        sp_rst_width dist {'d3:/10,['d4:'d18]:/80,'d19:/10}; //10~50ns
        tm_redump_width dist {'d3:/10,['d4:'h3fe]:/80,'h3ff:/10}; //10~2560ns
        //0731//stopwatch_period_width_ringo == 'd3; //10ns /*inside {['d3:'d399],['d400:'hffff]}; //10ns~163us, 10ns:3*/
        //0731//stopwatch_period_width_res == 'd399; //1us /*inside {['d399:'hffff]}; //1us~163us, 1us:399*/
        stopwatch_period_width_ringo dist {['d3:'d399]:/99,['d400:'hffff]:/1}; //10ns~1us, /*inside {['d3:'d399],['d400:'hffff]}; //10ns~163us, 10ns:3*/
        stopwatch_period_width_res dist {'d399, 'd400, 'd401}; //1us, 1us+2.5ns, 1us+5ns, 1us:399
        dump_rdy_timeout_sel inside {3'b001, 3'b010, 3'b100}; //bit0: power_up, bit1: redump, bit2: re-active spine_reset_n

        dump_rdy_timeout_time dist {[24'hC3500:24'h1e8480]:/45, [24'h1e8481:24'h3d0900]:/45, [24'h3d0901:24'h7a1200]:/10}; //add 0825: 2ms~5ms,,5ms~10ms,10ms~20ms;
        ringo_timeout_time dist {[24'hbb8:24'h4e20]:/45, [24'h4e21:24'h9c40]:/45, [24'h9c41:24'h61a80]:/10}; //add 0825: 7.5us~50us, 50us~100us, 100us~1ms

        foreach(sp_rst_force_dp_rdy[i]){
            if(dram_layer_sel_cfg[i]==1) {sp_rst_force_dp_rdy[i] dist {0:/0,1:/90};}
            if(dram_layer_sel_cfg[i]==0) {sp_rst_force_dp_rdy[i] == 0;}            
        }

        foreach(dmp_rdy_force_flag[i]){
            if(dram_layer_sel_cfg[i]==1) {dmp_rdy_force_flag[i] dist {0:/0,1:/90};}
            if(dram_layer_sel_cfg[i]==0) {dmp_rdy_force_flag[i] == 0;}
        }

        foreach(ringo_force_flag[i]){
            if(dram_layer_sel_cfg[i]==1) {ringo_force_flag[i] dist {0:/0,1:/90};}
            if(dram_layer_sel_cfg[i]==0) {ringo_force_flag[i] == 0;}
        }

        solve dram_layer_sel_cfg before sp_rst_force_dp_rdy;
        solve dram_layer_sel_cfg before dmp_rdy_force_flag;
        solve dram_layer_sel_cfg before ringo_force_flag;
    }

    function new(string name="trim_hard_timeout_corner_vseq");
        super.new(name);
    endfunction

    virtual task body();
        super.body();
        $display("-------------Enter the trim_hard_timeout_corner_vseq body---------------");
        m_trim_if.timeout_enable = 1;
        m_trim_if.trim_op_flow = 0; //add 0815

        //cfg #2500ns time: wait new array model release, this cfg need to be delete
        //0821//p_sequencer.regmodel.DRAM_TRIM_ins.hw_ringo_period_dly.hw_ringo_period_delay.write(status,14'h400,UVM_FRONTDOOR); //#2560ns

        //cfg trim_op_flow:
        p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.trim_op_flow.write(status,0,UVM_FRONTDOOR);

        for(int i=0; i<3; i++)begin
            //cfg tsv_tm initial value:
            //0814//if(ringo_mask_st == 0)begin
            //0814//    tsv_tm[246:238] = 9'h166;
            //0814//end            
            //0814//if(i==0)begin
            //0814//    tsv_tm[246:238] = 9'h166;
            //0814//end
            tsv_tm[246:238] = 9'h166;
            
            //cfg res_value_ctrl reg(0:dram res, 1:res_cfg_value, 2:external input):
            res_value_sel = $urandom_range(0,2);
            //0725//res_value_sel = 0; //for debug
            `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("res_value_sel = %0d", res_value_sel), UVM_LOW)
            p_sequencer.regmodel.DRAM_TRIM_ins.res_value_ctrl.res_value_sel.write(status,res_value_sel,UVM_FRONTDOOR);
            case(res_value_sel)
                0: begin
                end
                1: begin
                    res_reg_cfg_sel = $urandom_range(1);
                    if(res_reg_cfg_sel)begin //4 layer res_reg_value different:
                        for(int i=0; i<`DRAM_LAYER; i++)begin
                            res_reg_value[i*2+:2] = $urandom_range(0,2'b11);
                        end
                    end
                    else begin //4 layer res_reg_value same:
                        res_reg_value[1:0]  = $urandom_range(1,2'b11);
                        res_reg_value[3:2]  = res_reg_value[1:0];
                        res_reg_value[5:4]  = res_reg_value[1:0];
                        res_reg_value[7:6]  = res_reg_value[1:0];
                        `ifdef DRAM_6
                        res_reg_value[9:8]  = res_reg_value[1:0];
                        res_reg_value[11:10]  = res_reg_value[1:0];
                        `endif
                    end
                    p_sequencer.regmodel.DRAM_TRIM_ins.res_value_ctrl.res_cfg_value.write(status,res_reg_value,UVM_FRONTDOOR);
                    m_trim_if.cfg_reg_res = res_reg_value; //0730
                end
                2: begin
                    res_reg_cfg_sel = $urandom_range(1);
                    if(res_reg_cfg_sel)begin //4 layer res_reg_value different:
                        for(int i=0; i<`DRAM_LAYER; i++)begin
                            m_trim_if.trim_res[i*2+:2] = $urandom_range(0,2'b11);
                        end
                        `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("external input res is: trim_res = %0h", m_trim_if.trim_res), UVM_LOW)
                    end
                    else begin //4 layer res_reg_value same:
                        m_trim_if.trim_res[1:0]  = $urandom_range(1,2'b11);
                        m_trim_if.trim_res[3:2]  = m_trim_if.trim_res[1:0];
                        m_trim_if.trim_res[5:4]  = m_trim_if.trim_res[1:0];
                        m_trim_if.trim_res[7:6]  = m_trim_if.trim_res[1:0];                    
                        `ifdef DRAM_6
                        m_trim_if.trim_res[9:8]  = m_trim_if.trim_res[1:0];
                        m_trim_if.trim_res[11:10]  = m_trim_if.trim_res[1:0];
                        `endif
                        `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("external input res is: trim_res = %0h", m_trim_if.trim_res), UVM_LOW)
                    end
                end
            endcase

            //cfg init_spine_reset_time, sp_rst_width, tm_redump_width, stopwatch_period_width_ringo/res, hw_op_ringo_mask, dram_layer_sel_cfg, hw_op_tsv_load_sel
            assert(randomize()); //hw_op_tsv_load_sel=0: redump load, hw_op_tsv_load_sel=1: spine_reset_n load
            //dram_layer_sel_cfg = 4'b0001; //for debug
            hw_op_tsv_load_sel = 0; //redump load
            //0725//hw_op_ringo_mask = 0; //for debug
            `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("init_spine_reset_time = %0h, sp_rst_width = %0h, tm_redump_width = %0h", init_spine_reset_time, sp_rst_width, tm_redump_width), UVM_LOW)
            `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("stopwatch_period_width_ringo = %0h, stopwatch_period_width_res = %0h", stopwatch_period_width_ringo, stopwatch_period_width_res), UVM_LOW)
            `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("i=%0d, hw_op_ringo_mask=%0h, dram_layer_sel_cfg=%0h, hw_op_tsv_load_sel=%0h", i, hw_op_ringo_mask, dram_layer_sel_cfg, hw_op_tsv_load_sel), UVM_LOW)

            //0814////read hw_op_ringo_mask last status:
            //0814//if(i>0)begin
            //0814//    p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.hw_op_ringo_mask.read(status,ringo_mask_st,UVM_FRONTDOOR);
            //0814//    `uvm_info("DEBUG", $sformatf("ringo_mask_st = %0d, i=%0d", ringo_mask_st, i), UVM_LOW)
            //0814//    if(ringo_mask_st == 0)begin
            //0814//        tsv_tm[246:238] = 9'h166;
            //0814//    end
            //0814//end
            tsv_tm[246:238] = 9'h166;

            //add 0828:
            case(i)
                0: begin
                    init_spine_reset_time = 28'h6_1A7F;
                    dump_rdy_timeout_time = 24'hc3500;
                    ringo_timeout_time = 24'hbb8;
                end
                1: begin
                    init_spine_reset_time = 28'hfff_ffff;
                    dump_rdy_timeout_time = 24'hff_ffff;
                    ringo_timeout_time = 24'hff_ffff;
                end
                2: begin
                    init_spine_reset_time = 28'h6_1A7F;
                    dump_rdy_timeout_time = 24'hc3500;
                    ringo_timeout_time = 24'hbb8; 
                end
            endcase

            dump_rdy_timeout_sel = 3'b010; //add 0828


            //cfg information:
            hw_op_cfg(init_spine_reset_time, sp_rst_width, tm_redump_width, stopwatch_period_width_ringo, stopwatch_period_width_res, hw_op_ringo_mask, dram_layer_sel_cfg, hw_op_tsv_load_sel);
            
            //cfg timeout_info:
            //dump_rdy_timeout_time = 24'hc3500;
            //ringo_timeout_time = 24'hbb8;
            m_trim_if.dump_rdy_timeout_en = dump_rdy_timeout_en;
            m_trim_if.ringo_timeout_en = ringo_timeout_en;
            p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_en.write(status,dump_rdy_timeout_en,UVM_FRONTDOOR);
            p_sequencer.regmodel.DRAM_TRIM_ins.dumpready_timeout_ctrl.dumpready_timeout_time.write(status,dump_rdy_timeout_time,UVM_FRONTDOOR);
            p_sequencer.regmodel.DRAM_TRIM_ins.ringo_timeout_ctrl.ringo_timeout_en.write(status,ringo_timeout_en,UVM_FRONTDOOR);
            p_sequencer.regmodel.DRAM_TRIM_ins.ringo_timeout_ctrl.ringo_timeout_time.write(status,ringo_timeout_time,UVM_FRONTDOOR);
            p_sequencer.regmodel.DRAM_TRIM_ins.trim_interrupt_ctrl.trim_interrupt_mask.write(status,int_mask,UVM_FRONTDOOR);
            m_trim_if.sp_rst_force_dp_rdy = sp_rst_force_dp_rdy; //sp_rst
            m_trim_if.dmp_rdy_force_flag = dmp_rdy_force_flag;
            m_trim_if.ringo_force_flag = ringo_force_flag;
            `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("dump_rdy_timeout_time=%0h, ringo_timeout_time=%0h", dump_rdy_timeout_time, ringo_timeout_time), UVM_LOW)
            `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("init_spine_reset_time=%0h,sp_rst_width=%0h, tm_redump_width=%0h",init_spine_reset_time,sp_rst_width,tm_redump_width), UVM_LOW)
            `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("dram_layer_sel_cfg=%0b, sp_rst_force_dp_rdy=%0b", dram_layer_sel_cfg, sp_rst_force_dp_rdy), UVM_LOW)
            `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("dmp_rdy_force_flag=%0b, ringo_force_flag=%0b", dmp_rdy_force_flag, ringo_force_flag), UVM_LOW)
            `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("dump_rdy_timeout_sel=%0b", dump_rdy_timeout_sel), UVM_LOW)


            fork
                begin
                    //select input trim_start or apb cfg trim_start:
                    hw_start_sel = $urandom_range(1);
                    `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("hw_start_sel = %0h, i=%0d", hw_start_sel, i), UVM_LOW)
                    if(hw_start_sel)begin
                        @(posedge m_trim_if.clk);
                        m_trim_if.trim_start = 1;
                        `uvm_info("DEBUG", $sformatf("-------------DEBUG1----------"), UVM_LOW)
                    end
                    else begin
                        p_sequencer.regmodel.DRAM_TRIM_ins.trim_op_ctrl.trim_start.write(status,1,UVM_FRONTDOOR);
                    end
                end
                begin
                    `uvm_info("DEBUG", $sformatf("---------i=%0d -----------", i), UVM_LOW)
                    if(i==0)begin //only first have power up
                        fork
                            begin
                                wait(m_trim_if.fsm_cs=='d1); //init_op
                                fork
                                    init_sp_rst_low_time_chk(init_spine_reset_time);

                                    if(i==1)begin
                                        wait(m_trim_if.hw_init_sp_rst_cnt0==28'h6_1A7F);
                                        @(negedge m_trim_if.clk);
                                        uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_spine_reset_time_cnt[27:0]", 28'hfff_fff0);
                                        m_trim_if.hw_init_sp_rst_cnt0 = 28'hfff_fff0;
                                        m_trim_if.hw_init_sp_rst_cnt1 = 28'hfff_fff0;
                                        m_trim_if.hw_init_sp_rst_cnt2 = 28'hfff_fff0;
                                        m_trim_if.hw_init_sp_rst_cnt3 = 28'hfff_fff0;
                                        `ifdef DRAM_6
                                        m_trim_if.hw_init_sp_rst_cnt4 = 28'hfff_fff0;
                                        m_trim_if.hw_init_sp_rst_cnt5 = 28'hfff_fff0;
                                        `endif
                                    end
                                join
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
                            end
                        join
                    end
                    else begin //change mode to res_smple: 
                        `uvm_info("DEBUG", $sformatf("---------i=%0d,  ringo_mask_st=%0d-----------", i, ringo_mask_st), UVM_LOW)
                        //0814//if(ringo_mask_st == 0)begin
                        if(hw_op_tsv_load_sel == 0)begin
                            `uvm_info("DEBUG", $sformatf("----------enter redump_op_chk start, i=%0d-------------", i), UVM_LOW)
                            fork
                                begin
                                    //0815//if(dump_rdy_timeout_en == 1 && dump_rdy_timeout_sel[1]==1 && dmp_rdy_force_flag!='h0)begin
                                    if(dump_rdy_timeout_en == 1 && dump_rdy_timeout_sel[1]==1)begin
                                        fork
                                            if(dram_layer_sel_cfg[0]==1)begin
                                                `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk0 start---------"), UVM_LOW)
                                                if(dmp_rdy_force_flag[0] == 0 )begin
                                                    //check spine_reset_n keep low time is cfg's tm_redump_width:
                                                    redump_op_chk(4'b0001, tm_redump_width);
                                                end
                                                else begin //timeout:
                                                    if(i!=1)begin
                                                        redump_timeout_chk(4'b0001, tm_redump_width, dump_rdy_timeout_time);
                                                    end
                                                    else begin//add 0828:
                                                        fork
                                                        begin
                                                            redump_timeout_chk(4'b0001, tm_redump_width, dump_rdy_timeout_time);
                                                        end
                                                        begin
                                                            wait(m_trim_if.dmp_rdy_timeout_cnt0==24'hC3500);
                                                            @(negedge m_trim_if.clk);
                                                            uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_cnt[0][23:0]", 24'hff_fff0);
                                                            m_trim_if.dmp_rdy_timeout_cnt0=24'hff_fff0;
                                                        end
                                                        join
                                                    end
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
                                                    if(i!=1)begin
                                                        redump_timeout_chk(4'b0010, tm_redump_width, dump_rdy_timeout_time);
                                                    end
                                                    else begin //add 0828:
                                                        fork
                                                        begin
                                                            redump_timeout_chk(4'b0010, tm_redump_width, dump_rdy_timeout_time);
                                                        end
                                                        begin
                                                            wait(m_trim_if.dmp_rdy_timeout_cnt1==24'hC3500);
                                                            @(negedge m_trim_if.clk);
                                                            uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_cnt[1][23:0]", 24'hff_fff0);
                                                            m_trim_if.dmp_rdy_timeout_cnt1=24'hff_fff0;
                                                        end
                                                        join
                                                    end
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
                                                    if(i!=1)begin
                                                        redump_timeout_chk(4'b0100, tm_redump_width, dump_rdy_timeout_time);
                                                    end
                                                    else begin //add 0828:
                                                        fork
                                                        begin
                                                            redump_timeout_chk(4'b0100, tm_redump_width, dump_rdy_timeout_time);
                                                        end
                                                        begin
                                                            wait(m_trim_if.dmp_rdy_timeout_cnt2==24'hC3500);
                                                            @(negedge m_trim_if.clk);
                                                            uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_cnt[2][23:0]", 24'hff_fff0);
                                                            m_trim_if.dmp_rdy_timeout_cnt2=24'hff_fff0;
                                                        end
                                                        join
                                                    end
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
                                                    if(i!=1)begin
                                                        redump_timeout_chk(4'b1000, tm_redump_width, dump_rdy_timeout_time);
                                                    end
                                                    else begin //add 0828:
                                                        fork
                                                        begin
                                                            redump_timeout_chk(4'b1000, tm_redump_width, dump_rdy_timeout_time);
                                                        end
                                                        begin
                                                            wait(m_trim_if.dmp_rdy_timeout_cnt3==24'hC3500);
                                                            @(negedge m_trim_if.clk);
                                                            uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_cnt[3][23:0]", 24'hff_fff0);
                                                            m_trim_if.dmp_rdy_timeout_cnt3=24'hff_fff0;
                                                        end
                                                        join
                                                    end
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
                                                    if(i!=1)begin
                                                        redump_timeout_chk(6'b01_0000, tm_redump_width, dump_rdy_timeout_time);
                                                    end
                                                    else begin //add 0828:
                                                        fork
                                                        begin
                                                            redump_timeout_chk(6'b01_0000, tm_redump_width, dump_rdy_timeout_time);
                                                        end
                                                        begin
                                                            wait(m_trim_if.dmp_rdy_timeout_cnt4==24'hC3500);
                                                            @(negedge m_trim_if.clk);
                                                            uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_cnt[4][23:0]", 24'hff_fff0);
                                                            m_trim_if.dmp_rdy_timeout_cnt4=24'hff_fff0;
                                                        end
                                                        join
                                                    end
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
                                                    if(i!=1)begin
                                                        redump_timeout_chk(6'b10_0000, tm_redump_width, dump_rdy_timeout_time);
                                                    end
                                                    else begin //add 0828:
                                                        fork
                                                        begin
                                                            redump_timeout_chk(6'b10_0000, tm_redump_width, dump_rdy_timeout_time);
                                                        end
                                                        begin
                                                            wait(m_trim_if.dmp_rdy_timeout_cnt5==24'hC3500);
                                                            @(negedge m_trim_if.clk);
                                                            uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.dumpready_timeout_cnt[5][23:0]", 24'hff_fff0);
                                                            m_trim_if.dmp_rdy_timeout_cnt5=24'hff_fff0;
                                                        end
                                                        join
                                                    end
                                                end
                                                `uvm_info("trim_soft_timeout_vseq", $sformatf("---------redump_op_chk5 finish---------"), UVM_LOW)
                                            end
                                            `endif
                                        join                                    
                                    end
                                    else begin
                                        //automatic re-load tsv_tm, need redum check:
                                        redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
                                    end
                                end
                                begin
                                    if(dump_rdy_timeout_en == 1 && dump_rdy_timeout_sel[1]==1 && dmp_rdy_force_flag!='h0)begin
                                        dp_rdy_timeout_flag = 'h0;

                                        //wait tm_redump_pos force dump_ready, then wait timeout_dump_ready:
                                        //0730//redump_timout_rdy_wait(dram_layer_sel_cfg);
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

                                        interrupt_reg_check(int_mask);                                            

                                        dump_ready_release(dmp_rdy_force_flag);
                                    end
                                end
                            join
                            `uvm_info("DEBUG", $sformatf("----------enter redump_op_chk finish, i=%0d-------------", i), UVM_LOW)
                        end
                        else begin
                            `uvm_info("DEBUG", $sformatf("----------enter re_act_sp_keep_low_chk start, i=%0d-------------", i), UVM_LOW)
                            fork
                                begin
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

                                        interrupt_reg_check(int_mask);

                                        power_up_release_dp_rdy(sp_rst_force_dp_rdy);
                                    end
                                end
                            join
                            `uvm_info("DEBUG", $sformatf("----------enter re_act_sp_keep_low_chk finish, i=%0d-------------", i), UVM_LOW)
                        end    
                    end
                end
            //0808//join

            //0808//`uvm_info("trim_hard_timeout_corner_vseq", $sformatf("-----------power up init finish, i=%0d----------", i), UVM_LOW)

            //0808//fork
                begin //res check:
                    fork//: stpwh_prd_res
                        begin
                            if(res_value_sel == 0)begin
                                `uvm_info("DEBUG", $sformatf("-----------res_sample_chk start, i=%0d-------------", i), UVM_LOW)
                                //check spine_reset_n keep low time is cfg's tm_redump_width:
                                res_sample_chk(dram_layer_sel_cfg, stopwatch_period_width_res);
                                `uvm_info("DEBUG", $sformatf("-----------res_sample_chk finish, i=%0d-------------", i), UVM_LOW)
                            end
                        end
                        begin
                            `uvm_info("DEBUG", $sformatf("-----------res_smp_value_check start, i=%0d-------------", i), UVM_LOW)
                            //polling osct_tm_res_smp_ready and check res_smp_value:
                            res_smp_value_check(dram_layer_sel_cfg, 0, res_value_sel);
                            m_trim_if.stpwh_prd_res_flag = 'h0;
                            `uvm_info("DEBUG", $sformatf("-----------res_smp_value_check finish, i=%0d-------------", i), UVM_LOW)
                        end
                        begin
                            `uvm_info("DEBUG", $sformatf("-----------dump_ready_check start, i=%0d-------------", i), UVM_LOW)
                            if(res_value_sel == 0)begin
                                case(dram_layer_sel_cfg)
                                    4'b0001:  wait(m_trim_if.stpwh_prd_res_flag == 4'h1);
                                    4'b0011:  wait(m_trim_if.stpwh_prd_res_flag == 4'h3);
                                    4'b1111:  wait(m_trim_if.stpwh_prd_res_flag == 4'hf);
                                    `ifdef DRAM_6
                                    6'b11_1111: wait(m_trim_if.stpwh_prd_res_flag == 6'h3f);
                                    `endif
                                endcase

                                fork: dp_rdy_high_chk
                                    if(hw_op_tsv_load_sel == 0)begin
                                        wait(m_trim_if.tm_redump != 'h0); //if 4layer's res are different,4 layer redump are serial,not same time
                                    end
                                    else begin
                                        `ifdef DRAM_6
                                        wait(m_trim_if.spine_reset_n != 6'h3f);
                                        `else
                                        wait(m_trim_if.spine_reset_n != 4'hf);
                                        `endif
                                    end
                                join_any
                                disable dp_rdy_high_chk;
                            end
                            `uvm_info("DEBUG", $sformatf("-----------dump_ready_check finish, i=%0d-------------", i), UVM_LOW)
                        end
                    join
                    `uvm_info("DEBUG", $sformatf("-----------res finish, i=%0d-------------", i), UVM_LOW)
                end
                begin
                    if(res_value_sel == 0)begin //0730
                        if(hw_op_tsv_load_sel == 0)begin
                            `uvm_info("DEBUG", $sformatf("----------enter redump_op_chk start, i=%0d-------------", i), UVM_LOW)
                            if(i>0)begin //add 0829
                                change_res_mode(dram_layer_sel_cfg, hw_op_tsv_load_sel);
                            end

                            //automatic re-load tsv_tm, need redum check:
                            redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
                            `uvm_info("DEBUG", $sformatf("----------enter redump_op_chk finish, i=%0d-------------", i), UVM_LOW)
                        end
                        else begin
                            `uvm_info("DEBUG", $sformatf("----------enter re_act_sp_keep_low_chk start, i=%0d-------------", i), UVM_LOW)
                            if(i>0)begin //add 0829
                                change_res_mode(dram_layer_sel_cfg, hw_op_tsv_load_sel);
                            end

                            //check spine_reset_n keep low time is cfg's sp_rst_width:
                            re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);  
                            `uvm_info("DEBUG", $sformatf("----------enter re_act_sp_keep_low_chk finish, i=%0d-------------", i), UVM_LOW)
                        end
                    end
                end 
                begin
                    `uvm_info("DEBUG", $sformatf("----------res_value_sel=%0d, i=%0d -------------", res_value_sel, i), UVM_LOW)
                    `uvm_info("DEBUG", $sformatf("dram_layer_sel_cfg=%0b, hw_op_tsv_load_sel=%0b,res_reg_value=%0b", dram_layer_sel_cfg,hw_op_tsv_load_sel,res_reg_value), UVM_LOW)
                    if(i>0)begin //add 0829
                        change_res_mode(dram_layer_sel_cfg, hw_op_tsv_load_sel);
                    end

                    case(dram_layer_sel_cfg)
                        4'b0001: begin
                            hw_res_chk(0, hw_op_tsv_load_sel, res_value_sel, res_reg_value); 
                        end
                        4'b0011: begin
                            fork
                                hw_res_chk(0, hw_op_tsv_load_sel, res_value_sel, res_reg_value);
                                hw_res_chk(1, hw_op_tsv_load_sel, res_value_sel, res_reg_value);
                            join
                        end
                        4'b1111: begin
                            fork
                                hw_res_chk(0, hw_op_tsv_load_sel, res_value_sel, res_reg_value);
                                hw_res_chk(1, hw_op_tsv_load_sel, res_value_sel, res_reg_value);
                                hw_res_chk(2, hw_op_tsv_load_sel, res_value_sel, res_reg_value);
                                hw_res_chk(3, hw_op_tsv_load_sel, res_value_sel, res_reg_value);
                            join
                        end
                        `ifdef DRAM_6
                        6'b11_1111: begin
                            fork
                                hw_res_chk(0, hw_op_tsv_load_sel, res_value_sel, res_reg_value);
                                hw_res_chk(1, hw_op_tsv_load_sel, res_value_sel, res_reg_value);
                                hw_res_chk(2, hw_op_tsv_load_sel, res_value_sel, res_reg_value);
                                hw_res_chk(3, hw_op_tsv_load_sel, res_value_sel, res_reg_value);
                                hw_res_chk(4, hw_op_tsv_load_sel, res_value_sel, res_reg_value);
                                hw_res_chk(5, hw_op_tsv_load_sel, res_value_sel, res_reg_value);
                            join
                        end
                        `endif
                    endcase
                    `uvm_info("DEBUG", $sformatf("----------hw_res_chk finish, i=%0d-------------", i), UVM_LOW)
                end
            join
            `uvm_info("DEBUG", $sformatf("-----------redump all finish, i=%0d-------------", i), UVM_LOW)
            `uvm_info("DEBUG", $sformatf("-----------hw_op_ringo_mask=%0d, i=%0d-----------------", hw_op_ringo_mask, i), UVM_LOW)


            //check tsv_tm:
            tsv_tm[246:238] = 9'h0; //add 0815
            m_trim_if.cfg_tsv_tm = tsv_tm; //0807 for debug
            if((m_trim_if.tsv_tm[257:0] != tsv_tm[257:0]) || (m_trim_if.tsv_tm[427:260] != tsv_tm[427:260]))
                `uvm_error("trim_stopwatch_res_seq", $sformatf("tsv check failed:\n\tcfg tsv_tm[257:0]=\n%0h\n\tm_trim_if.tsv_tm[257:0]\n\t=%0h;\n\tcfg tsv_tm[427:260]=\n%0h\n\tm_trim_if.tsv_tm[427:260]\n\t=%0h", tsv_tm[257:0], m_trim_if.tsv_tm[257:0], tsv_tm[427:260], m_trim_if.tsv_tm[427:260]))

            if(hw_op_ringo_mask == 0)begin
                if(ringo_force_flag == 'h0)begin
                    fork
                        begin
                            //automatic ringo 8 mode, need ringo check:
                            m_trim_if.ringo_mode_q.push_back(9'h40);
                            m_trim_if.ringo_mode_q.push_back(9'h60);
                            m_trim_if.ringo_mode_q.push_back(9'h50);
                            m_trim_if.ringo_mode_q.push_back(9'h70);
                            m_trim_if.ringo_mode_q.push_back(9'h48);
                            m_trim_if.ringo_mode_q.push_back(9'h68);
                            m_trim_if.ringo_mode_q.push_back(9'h58);
                            m_trim_if.ringo_mode_q.push_back(9'h5a);
                            for(int j=0; j<8; j++)begin
                                tsv_tm[246:238] = m_trim_if.ringo_mode_q.pop_front();
                                //`uvm_info("DEBUG",$sformatf("\n\ttsv_tm[246:238]=\n%0h\n\trim_if.tsv_tm[246:238]=\n%0h",tsv_tm[246:238],m_trim_if.tsv_tm[246:238]),UVM_LOW)
                                //`uvm_info("DEBUG", $sformatf("\n\ttsv_tm[257:0]=\n%0h\n\tm_trim_if.tsv_tm[257:0]=\n%0h", tsv_tm[257:0], m_trim_if.tsv_tm[257:0]), UVM_LOW)
                                m_trim_if.cfg_tsv_tm = tsv_tm; //0729 for debug

                                `uvm_info("FOR_DEBUG", $sformatf("---------------ringo_chk start, i=%0d, j=%0d--------------", i, j), UVM_LOW)
                                ringo_chk(dram_layer_sel_cfg, stopwatch_period_width_ringo);
                                `uvm_info("FOR_DEBUG", $sformatf("---------------ringo_chk finish, i=%0d, j=%0d--------------", i, j), UVM_LOW)

                                //check tsv_tm:
                                if((m_trim_if.tsv_tm[257:0] != tsv_tm[257:0]) || (m_trim_if.tsv_tm[427:260] != tsv_tm[427:260]))
                                    `uvm_error("trim_stopwatch_res_seq", $sformatf("tsv check failed:\n\tcfg tsv_tm[257:0]=\n\t%0h\n\tm_trim_if.tsv_tm[257:0]=\n\t%0h;\n\tcfg tsv_tm[427:260]=\n\t%0h\n\tm_trim_if.tsv_tm[427:260]=\n\t%0h", tsv_tm[257:0], m_trim_if.tsv_tm[257:0], tsv_tm[427:260], m_trim_if.tsv_tm[427:260]))


                                //0822//repeat(10)@(posedge m_trim_if.clk);
                                wait(m_trim_if.tsv_tm[246:238] == 9'h0); //add for 0820 verilog model

                                //check 4 layer ringo_period:
                                //hw save ringo_period is different from soft//ringo_reg_chk(dram_layer_sel_cfg);
                                hw_ringo_reg_chk(dram_layer_sel_cfg, tsv_tm[246:238]);
                                //push in hw_ringo_reg_chk tsk-0730//m_trim_if.ringo_period_cnt0_save_q.push_back(m_trim_if.ringo_period_cnt0);
                                //push in hw_ringo_reg_chk tsk-0730//m_trim_if.ringo_period_cnt1_save_q.push_back(m_trim_if.ringo_period_cnt1);
                                //push in hw_ringo_reg_chk tsk-0730//m_trim_if.ringo_period_cnt2_save_q.push_back(m_trim_if.ringo_period_cnt2);
                                //push in hw_ringo_reg_chk tsk-0730//m_trim_if.ringo_period_cnt3_save_q.push_back(m_trim_if.ringo_period_cnt3);
                                `uvm_info("DEBUG", $sformatf("i=%0d, j=%0d, ringo_period_cnt1=%0d", i, j, m_trim_if.ringo_period_cnt1), UVM_LOW)

                                m_trim_if.ringo_period_cnt0 = 0;
                                m_trim_if.ringo_period_cnt1 = 0;
                                m_trim_if.ringo_period_cnt2 = 0;
                                m_trim_if.ringo_period_cnt3 = 0;
                                `ifdef DRAM_6
                                m_trim_if.ringo_period_cnt4 = 0;
                                m_trim_if.ringo_period_cnt5 = 0;
                                `endif
                            end
                        end
                        begin
                            for(int j=0; j<8; j++)begin
                                if(hw_op_tsv_load_sel == 0)begin
                                    //change mode: automatic re-load tsv_tm, need redum check:
                                    redump_op_chk(dram_layer_sel_cfg, tm_redump_width);

                                    //--------------------------add 0813------------------------start
                                    fork
                                        begin
                                            //disable ringo before change next mode:
                                            redump_op_chk(dram_layer_sel_cfg, tm_redump_width);
                                        end
                                        begin
                                            //check after disable, tsv_tm[247:239]=0:
                                            for(int ii=0; ii<`DRAM_LAYER; ii++)begin
                                                fork
                                                    automatic int jj=ii;
                                                    if(m_trim_if.dram_layer_cfg[jj]==1)begin
                                                        @(posedge m_trim_if.tm_redump[jj]);
                                                        @(negedge m_trim_if.tm_redump[jj]);
                                                        //0815//repeat(5)@(posedge m_trim_if.clk);
                                                        if(m_trim_if.tsv_tm[246:238] != 9'h0)
                                                            `uvm_error("trim_hard_vseq", $sformatf("after last mode disable: m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                                                    end
                                                join_none
                                            end
                                            wait fork;
                                        end
                                    join
                                    //--------------------------add 0813-------------------------end
                                end
                                else begin
                                    //change mode: check spine_reset_n keep low time is cfg's sp_rst_width:
                                    re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);

                                    //--------------------------add 0813------------------------start
                                    fork
                                        begin
                                            //disable ringo before change next mode:
                                            re_act_sp_keep_low_chk(dram_layer_sel_cfg, sp_rst_width);
                                        end
                                        begin
                                            //check after disable, tsv_tm[247:239]=0:
                                            for(int mm=0; mm<`DRAM_LAYER; mm++)begin
                                                fork
                                                    automatic int kk=mm;
                                                    if(m_trim_if.dram_layer_cfg[kk]==1)begin
                                                        @(negedge m_trim_if.spine_reset_n[kk]);
                                                        @(posedge m_trim_if.spine_reset_n[kk]);
                                                        //0815//repeat(5)@(posedge m_trim_if.clk);
                                                        if(m_trim_if.tsv_tm[246:238] != 9'h0)
                                                            `uvm_error("trim_hard_vseq",$sformatf("after last mode disable: m_trim_if.tsv_tm[246:238]=%0h", m_trim_if.tsv_tm[246:238]))
                                                    end
                                                join_none
                                            end
                                            wait fork;
                                        end
                                    join
                                    //--------------------------add 0813-------------------------end
                                end   
                            end
                        end
                    join
                end
                else begin //ringo_force_flag != 'h0:
                    mode_sel = $urandom_range(0,'d7);
                    `uvm_info("DEBUG", $sformatf("mode_sel = %0d", mode_sel), UVM_LOW)
                    fork
                        begin
                            //------------for ringo timeout-----------
                            `uvm_info("DEBUG", $sformatf("-------------force ringo start-------------"), UVM_LOW)
                            case(mode_sel)
                                0: begin
                                    wait(m_trim_if.tsv_tm[246:238]=='h40);
                                    @(posedge m_trim_if.clk);
                                    `uvm_info("DEBUG", $sformatf("-------start force--------"), UVM_LOW)
                                    //force ringo:
                                    ringo_timeout(ringo_force_flag);
                                    `uvm_info("DEBUG", $sformatf("-------finish force--------"), UVM_LOW)
                                end
                                1: begin
                                    wait(m_trim_if.tsv_tm[246:238]=='h60);
                                    @(posedge m_trim_if.clk);
                                    //force ringo:
                                    ringo_timeout(ringo_force_flag);                                    
                                end
                                2: begin
                                    wait(m_trim_if.tsv_tm[246:238]=='h50);
                                    @(posedge m_trim_if.clk);
                                    //force ringo:
                                    ringo_timeout(ringo_force_flag);                                    
                                end
                                3: begin
                                    wait(m_trim_if.tsv_tm[246:238]=='h70);
                                    @(posedge m_trim_if.clk);
                                    //force ringo:
                                    ringo_timeout(ringo_force_flag);                                    
                                end
                                4: begin
                                    wait(m_trim_if.tsv_tm[246:238]=='h48);
                                    @(posedge m_trim_if.clk);
                                    //force ringo:
                                    ringo_timeout(ringo_force_flag);                                    
                                end
                                5: begin
                                    wait(m_trim_if.tsv_tm[246:238]=='h68);
                                    @(posedge m_trim_if.clk);
                                    //force ringo:
                                    ringo_timeout(ringo_force_flag);                                    
                                end
                                6: begin
                                    wait(m_trim_if.tsv_tm[246:238]=='h58);
                                    @(posedge m_trim_if.clk);
                                    //force ringo:
                                    ringo_timeout(ringo_force_flag);                                    
                                end
                                7: begin
                                    wait(m_trim_if.tsv_tm[246:238]=='h5a);
                                    @(posedge m_trim_if.clk);
                                    //force ringo:
                                    ringo_timeout(ringo_force_flag);                                    
                                end
                            endcase
                            `uvm_info("DEBUG", $sformatf("-------------force ringo finish-------------"), UVM_LOW)
                        end
                        begin
                            for(int m=0; m<8; m++)begin
                                `uvm_info("DEBUG",$sformatf("m=%0d start,dram_layer_sel_cfg=%0h,ringo_force_flag=%0h",m,dram_layer_sel_cfg,ringo_force_flag), UVM_LOW)
                                fork
                                    begin
                                        if(dram_layer_sel_cfg[0]==1)begin
                                            if(ringo_force_flag[0]==0)begin
                                                `uvm_info("DEBUG", $sformatf("----------enter 0 start, m=%0d---------", m), UVM_LOW)
                                                ringo_chk(4'b0001, stopwatch_period_width_ringo);
                                                `uvm_info("DEBUG", $sformatf("----------enter 0 finish, m=%0d---------", m), UVM_LOW)
                                            end
                                            else begin //timeout:
                                                if(mode_sel==m)begin
                                                    `uvm_info("DEBUG", $sformatf("----------enter timeout 0 start, m=%0d---------", m), UVM_LOW)
                                                    fork
                                                    begin
                                                        ringo_timeout_chk(4'b0001, stopwatch_period_width_ringo, ringo_timeout_time); 
                                                    end
                                                    begin //add 0828:
                                                        if(i==1)begin
                                                            wait(m_trim_if.ringo_timeout_cnt0==24'hbb8);
                                                            @(negedge m_trim_if.clk);
                                                            uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_cnt[0][23:0]", 24'hff_fff0);
                                                            m_trim_if.ringo_timeout_cnt0=(24'hff_fff0-'d3);
                                                        end
                                                    end
                                                    join
                                                    `uvm_info("DEBUG", $sformatf("----------enter timeout 0 start, m=%0d---------", m), UVM_LOW)
                                                end
                                                else begin
                                                    `uvm_info("DEBUG", $sformatf("----------enter 0 start, m=%0d---------", m), UVM_LOW)
                                                    ringo_chk(4'b0001, stopwatch_period_width_ringo);
                                                    `uvm_info("DEBUG", $sformatf("----------enter 0 start, m=%0d---------", m), UVM_LOW)
                                                end
                                            end
                                        end
                                    end
                                    begin
                                        if(dram_layer_sel_cfg[1]==1)begin
                                            if(ringo_force_flag[1]==0)begin
                                                `uvm_info("DEBUG", $sformatf("----------enter 1 start, m=%0d---------", m), UVM_LOW)
                                                ringo_chk(4'b0010, stopwatch_period_width_ringo);
                                                `uvm_info("DEBUG", $sformatf("----------enter 1 finish, m=%0d---------", m), UVM_LOW)
                                            end
                                            else begin //timeout:
                                                if(mode_sel==m)begin
                                                    `uvm_info("DEBUG", $sformatf("----------enter timeout 1 start, m=%0d---------", m), UVM_LOW)
                                                    fork
                                                    begin
                                                        ringo_timeout_chk(4'b0010, stopwatch_period_width_ringo, ringo_timeout_time);
                                                    end
                                                    begin //add 0828:
                                                        if(i==1)begin
                                                            wait(m_trim_if.ringo_timeout_cnt1==24'hbb8);
                                                            @(negedge m_trim_if.clk);
                                                            uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_cnt[1][23:0]", 24'hff_fff0);
                                                            m_trim_if.ringo_timeout_cnt1=(24'hff_fff0-'d3);
                                                        end
                                                    end
                                                    join
                                                    `uvm_info("DEBUG", $sformatf("----------enter timeout 1 finish, m=%0d---------", m), UVM_LOW)
                                                end
                                                else begin
                                                    `uvm_info("DEBUG", $sformatf("----------enter 1 start, m=%0d---------", m), UVM_LOW)
                                                    ringo_chk(4'b0010, stopwatch_period_width_ringo);
                                                    `uvm_info("DEBUG", $sformatf("----------enter 1 finish, m=%0d---------", m), UVM_LOW)
                                                end
                                            end
                                        end
                                    end
                                    begin
                                        if(dram_layer_sel_cfg[2]==1)begin
                                            if(ringo_force_flag[2]==0)begin
                                                ringo_chk(4'b0100, stopwatch_period_width_ringo);
                                            end
                                            else begin //timeout:
                                                if(mode_sel==m)begin
                                                    fork
                                                    begin
                                                        ringo_timeout_chk(4'b0100, stopwatch_period_width_ringo, ringo_timeout_time);
                                                    end
                                                    begin //add 0828:
                                                        if(i==1)begin
                                                            wait(m_trim_if.ringo_timeout_cnt2==24'hbb8);
                                                            @(negedge m_trim_if.clk);
                                                            uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_cnt[2][23:0]", 24'hff_fff0);
                                                            m_trim_if.ringo_timeout_cnt2=(24'hff_fff0-'d3);
                                                        end
                                                    end
                                                    join
                                                end
                                                else begin
                                                    ringo_chk(4'b0100, stopwatch_period_width_ringo);
                                                end
                                            end
                                        end
                                    end
                                    begin
                                        if(dram_layer_sel_cfg[3]==1)begin
                                            if(ringo_force_flag[3]==0)begin
                                                ringo_chk(4'b1000, stopwatch_period_width_ringo);
                                            end
                                            else begin //timeout:
                                                if(mode_sel==m)begin
                                                    fork
                                                    begin
                                                        ringo_timeout_chk(4'b1000, stopwatch_period_width_ringo, ringo_timeout_time);
                                                    end
                                                    begin //add 0828:
                                                        if(i==1)begin
                                                            wait(m_trim_if.ringo_timeout_cnt3==24'hbb8);
                                                            @(negedge m_trim_if.clk);
                                                            uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_cnt[3][23:0]", 24'hff_fff0);
                                                            m_trim_if.ringo_timeout_cnt3=(24'hff_fff0-'d3);
                                                        end
                                                    end
                                                    join
                                                end
                                                else begin
                                                    ringo_chk(4'b1000, stopwatch_period_width_ringo);
                                                end
                                            end
                                        end
                                    end
                                    `ifdef DRAM_6
                                    begin
                                        if(dram_layer_sel_cfg[4]==1)begin
                                            if(ringo_force_flag[4]==0)begin
                                                ringo_chk(6'b01_0000, stopwatch_period_width_ringo);
                                            end
                                            else begin //timeout:
                                                if(mode_sel==m)begin
                                                    fork
                                                    begin
                                                        ringo_timeout_chk(6'b01_0000, stopwatch_period_width_ringo, ringo_timeout_time);
                                                    end
                                                    begin //add 0828:
                                                        if(i==1)begin
                                                            wait(m_trim_if.ringo_timeout_cnt4==24'hbb8);
                                                            @(negedge m_trim_if.clk);
                                                            uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_cnt[4][23:0]", 24'hff_fff0);
                                                            m_trim_if.ringo_timeout_cnt4=(24'hff_fff0-'d3);
                                                        end
                                                    end
                                                    join
                                                end
                                                else begin
                                                    ringo_chk(6'b01_0000, stopwatch_period_width_ringo);
                                                end
                                            end
                                        end
                                    end
                                    begin
                                        if(dram_layer_sel_cfg[5]==1)begin
                                            if(ringo_force_flag[5]==0)begin
                                                ringo_chk(6'b10_0000, stopwatch_period_width_ringo);
                                            end
                                            else begin //timeout:
                                                if(mode_sel==m)begin
                                                    fork
                                                    begin
                                                        ringo_timeout_chk(6'b10_0000, stopwatch_period_width_ringo, ringo_timeout_time);
                                                    end
                                                    begin //add 0828:
                                                        if(i==1)begin
                                                            wait(m_trim_if.ringo_timeout_cnt5==24'hbb8);
                                                            @(negedge m_trim_if.clk);
                                                            uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.ringo_timeout_cnt[5][23:0]", 24'hff_fff0);
                                                            m_trim_if.ringo_timeout_cnt5=(24'hff_fff0-'d3);
                                                        end
                                                    end
                                                    join
                                                end
                                                else begin
                                                    ringo_chk(6'b10_0000, stopwatch_period_width_ringo);
                                                end
                                            end
                                        end
                                    end
                                    `endif
                                join
                                `uvm_info("DEBUG",$sformatf("m=%0d finish,dram_layer_sel_cfg=%0h,ringo_force_flag=%0h",m,dram_layer_sel_cfg,ringo_force_flag),UVM_LOW)
                            end
                        end
                        begin
                            wait(m_trim_if.ringo_timeout != 'h0);
                            `uvm_info("DEBUG", $sformatf("----------m_trim_if.ringo_timeout=%0h----------", m_trim_if.ringo_timeout), UVM_LOW)
                            repeat(5)@(posedge m_apb_if.pclk);
                            m_trim_if.ringo_period_cnt0 = 0;
                            m_trim_if.ringo_period_cnt1 = 0;
                            m_trim_if.ringo_period_cnt2 = 0;
                            m_trim_if.ringo_period_cnt3 = 0;
                            `ifdef DRAM_6
                            m_trim_if.ringo_period_cnt4 = 0;
                            m_trim_if.ringo_period_cnt5 = 0;
                            `endif

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
                                `uvm_error("trim_soft_timeout_vseq", $sformatf("ringo_timeout_flag not be cleared, ringo_timeout_flag=%0h",ringo_timeout_flag))

                            interrupt_reg_check(int_mask);     
                            m_trim_if.ringo_timeout = 'h0;
                            ringo_release(ringo_force_flag);
                            `uvm_info("DEBUG", $sformatf("-------------have release ringo-------------"), UVM_LOW)
                        end
                    join                    
                end
            end
            `uvm_info("DEBUG", $sformatf("---------hw_start_sel=%0h, i=%0d----------", hw_start_sel, i), UVM_LOW)

            //----------------clear some signals----------------
            if(hw_start_sel)begin
                @(posedge m_trim_if.clk);
                m_trim_if.trim_start = 0;
                `uvm_info("DEBUG", $sformatf("-------------DEBUG2----------"), UVM_LOW)
            end

            //check trim_finish:
            repeat(20)@(posedge m_trim_if.clk);
            `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("-----------start wait trim_finish, i=%0d------------", i), UVM_LOW)
            wait(m_trim_if.trim_finish==1);
            @(posedge m_trim_if.clk);
            p_sequencer.regmodel.DRAM_TRIM_ins.trim_global_ctrl.trim_finish.read(status,trim_finish,UVM_FRONTDOOR);
            if(trim_finish != 1)
                `uvm_error("trim_hard_timeout_corner_vseq", $sformatf("--------trim_finish check fail, i=%0d--------", i))
            else
                `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("---------trim_finish check pass, i=%0d---------", i), UVM_LOW)

            `uvm_info("trim_hard_timeout_corner_vseq", $sformatf("-----------have waited trim_finish, i=%0d------------", i), UVM_LOW)

            //check ringo_period :
            if(hw_op_ringo_mask == 0 && ringo_force_flag == 'h0)begin
                hw_save_ringo_reg_chk(dram_layer_sel_cfg);
            end
        end


        `uvm_info(get_type_name(), $sformatf("-------------trim_hard_timeout_corner_vseq finish---------------"), UVM_LOW)
        #10us;
    endtask: body
endclass


`endif //TRIM_HARD_TIMEOUT_CORNER_VSEQ_SV

