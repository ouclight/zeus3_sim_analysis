`ifndef TRIM_SOFT_SINGLE_STEP_CORNER_VSEQ_SV
`define TRIM_SOFT_SINGLE_STEP_CORNER_VSEQ_SV

/*
**1. trim_power_up_init_corner_vseq
*/


class trim_power_up_init_corner_vseq extends trim_common_vseq;

    rand bit [27:0]     init_spine_reset_time;
    rand bit [427:0]    tsv_tm;

    `uvm_object_utils(trim_power_up_init_corner_vseq)


    constraint time_c{
        init_spine_reset_time dist {[28'h6_1A7F:28'h7A_11FF]:/90};  //1ms~20ms
    }

    function new(string name="trim_power_up_init_corner_vseq");
        super.new(name);
    endfunction

    virtual task body();
        super.body();
        $display("-------------Enter the trim_power_up_init_corner_vseq body---------------");
        m_trim_if.trim_op_flow = 1; //add 0815

        assert(randomize());
        init_spine_reset_time = 28'hfff_ffff;
        fork
            `uvm_info("trim_power_up_init_corner_vseq", $sformatf("init_spine_reset_time=%0h, tsv_tm=%0h", init_spine_reset_time, tsv_tm), UVM_LOW)
            begin
                power_up_init(init_spine_reset_time, tsv_tm);
            end
            begin
                wait(m_trim_if.fsm_cs=='d1);
                wait(m_trim_if.init_sp_rst_low_cnt_0==28'h7A_11FF);
                @(negedge m_trim_if.clk);
                uvm_hdl_deposit("trim_tb.u_dram_trim_top.dram_trim_ctrl_u.init_spine_reset_time_cnt[27:0]", 28'hfff_fff0);
                m_trim_if.init_sp_rst_low_cnt_0 = 28'hfff_fff0;
                m_trim_if.init_sp_rst_low_cnt_1 = 28'hfff_fff0;
                m_trim_if.init_sp_rst_low_cnt_2 = 28'hfff_fff0;
                m_trim_if.init_sp_rst_low_cnt_3 = 28'hfff_fff0;
                `ifdef DRAM_6
                m_trim_if.init_sp_rst_low_cnt_4 = 28'hfff_fff0;
                m_trim_if.init_sp_rst_low_cnt_5 = 28'hfff_fff0;
                `endif
            end
        join
        #1ms; //wait dump_ready
    
        `uvm_info(get_type_name(), $sformatf("-------------trim_power_up_init_corner_vseq finish---------------"), UVM_LOW)
        #10us;
    endtask: body
endclass


`endif //TRIM_SOFT_SINGLE_STEP_CORNER_VSEQ_SV

