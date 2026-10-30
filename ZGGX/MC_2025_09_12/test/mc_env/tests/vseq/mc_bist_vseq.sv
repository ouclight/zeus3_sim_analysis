`ifndef MC_BIST_VSEQ
`define MC_BIST_VSEQ


class mc_bist_vseq extends mc_common_vseq;

    `uvm_object_utils(mc_bist_vseq)

    function new(string name="mc_bist_vseq");
        super.new(name);
    endfunction
    
    localparam      COL_NUM             = 'd128;
    localparam      WL_NUM              = 'd300;
    localparam      REFRESH_END_ADDR    = 13'h100;
    localparam      ERR_CSL_DEFAULT_VALUE='hff;
    localparam      ERR_WL_DEFAULT_VALUE= {`ROW_ADDR_WIDTH*`BANK_ADDR_WIDTH{1'b1}};//'h1fff;
    int                             mi_csl_col_num;

    rand bit [`PATTERN_WIDTH-1:0]   bist_pattern[68]    ;
    rand bit [67:0]                 mb_csl_pattern_sel  ;
    rand bit [67:0]                 mb_wl_pattern_sel   ;
    rand bit                        mb_bist_finish_mask ;
    rand bit                        page_mode           ;
    rand bit                        mb_csl_scan_addr_range_sel;

    rand bit [3:0]                  bist_wl_scan_single_pattern_rd_num;
    rand bit [3:0]                  mb_bank_sel         ;

    constraint c_bist_wl_scan_single_pattern_rd_num{
        bist_wl_scan_single_pattern_rd_num  == 2;//dist {['d0:'d15]:/50, 'd0:/50, 'd15:/50}; TODO
    }
    constraint c_bank_grant{
        `ifdef TEST_1_SHOT_1
            mb_bank_sel inside {[4'b0000:4'b0001]};
        `elsif TEST_1_SHOT_2
            mb_bank_sel inside {[4'b0000:4'b0011]};
        `elsif TEST_1_SHOT_3
            mb_bank_sel inside {[4'b0000:4'b0111]};
        `elsif TEST_1_SHOT_4
            mb_bank_sel inside {[4'b0000:4'b1111]};
        `else
            mb_bank_sel inside {[4'b0000:4'b0111]};
        `endif
        mb_bank_sel != 4'b0;
    }

    extern virtual task body();
    extern task write_pattern_check(int bank_sel, bit [`PATTERN_WIDTH-1:0] pattern, bit scan_type); //scan_type: 0:csl_scan;  1:wl_scan
    extern task read_pattern_check (int bank_sel, bit [`PATTERN_WIDTH-1:0] pattern, bit scan_type); //scan_type: 0:csl_scan;  1:wl_scan

endclass:mc_bist_vseq

task mc_bist_vseq::body();

    bit             bist_finish;
    bit             bank_success;
    bit [2:0]       bist_status;
    bit             bank_vld;
    real            bist_scan_start_time;
    real            bist_scan_end_time;

    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_addr;
    bit [`ROW_ADDR_WIDTH*4-1:0]     err_row_addr;


    super.body();
    uvm_hdl_deposit("mc_tb.u_quad_group.u_quad_group.XBK0.memory[0]", 272'h123456789abcdef);
    uvm_hdl_deposit("mc_tb.u_quad_group.u_quad_group.XBK1.memory[0]", 272'h123456789abcdef);
    uvm_hdl_deposit("mc_tb.u_quad_group.u_quad_group.XBK2.memory[0]", 272'h123456789abcdef);
    uvm_hdl_deposit("mc_tb.u_quad_group.u_quad_group.XBK3.memory[0]", 272'h123456789abcdef);
    
    for (int i=0;i<2;i++) begin
        `uvm_info(get_type_name(),$sformatf("\n========================== mc_bist_vseq start@%0d ============================",i),UVM_LOW)

        assert(randomize()with{ //page_mode           == 1'b1;
                                mb_csl_pattern_sel[63:0]    == 64'h2    ;
                                mb_csl_pattern_sel[67:64]   == 4'h0     ;
                                mb_wl_pattern_sel[63:0]     == 64'h2    ;
                                mb_wl_pattern_sel[67:64]    == 4'h0     ;
        });
        mi_csl_col_num      = mb_csl_scan_addr_range_sel ? 130       : 128   ;

        //========================== reg and signal config =================================
        //{{{
        bist_pattern[0      ] = 32'h0000_0000;
        bist_pattern[1      ] = 32'hFFFF_FFFF;
        bist_pattern[2      ] = 32'h5555_5555;
        bist_pattern[3      ] = 32'hAAAA_AAAA;
        bist_pattern[4      ] = 32'h00FF_00FF;
        bist_pattern[5      ] = 32'hFF00_FF00;
        bist_pattern[6      ] = 32'h55AA_55AA;
        bist_pattern[7      ] = 32'hAA55_AA55;
        bist_pattern[8      ] = 32'h0055_0055;
        bist_pattern[9      ] = 32'h00AA_00AA;
        bist_pattern[10     ] = 32'h5500_5500;
        bist_pattern[11     ] = 32'hAA00_AA00;
        bist_pattern[12     ] = 32'h0000_FFFF;
        bist_pattern[13     ] = 32'hFFFF_0000;
        bist_pattern[14     ] = 32'h00FF_FF00;
        bist_pattern[15     ] = 32'hFF00_00FF;
        bist_pattern[16     ] = 32'h3333_3333;
        bist_pattern[17     ] = 32'hCCCC_CCCC;
        bist_pattern[18     ] = 32'h9999_9999;
        bist_pattern[19     ] = 32'h6666_6666;
        bist_pattern[20     ] = 32'h33CC_33CC;
        bist_pattern[21     ] = 32'hCC33_CC33;
        bist_pattern[22     ] = 32'h6699_6699;
        bist_pattern[23     ] = 32'h9966_9966;
        bist_pattern[24     ] = 32'h1212_1212;
        bist_pattern[25     ] = 32'h2424_2424;
        bist_pattern[26     ] = 32'h4848_4848;
        bist_pattern[27     ] = 32'h8181_8181;
        bist_pattern[28     ] = 32'hEDED_EDED;
        bist_pattern[29     ] = 32'hDBDB_DBDB;
        bist_pattern[30     ] = 32'hB7B7_B7B7;
        bist_pattern[31     ] = 32'h7E7E_7E7E;
        bist_pattern[32     ] = 32'hED12_ED12;
        bist_pattern[33     ] = 32'hDB24_DB24;
        bist_pattern[34     ] = 32'hB748_B748;
        bist_pattern[35     ] = 32'h7E81_7E81;
        bist_pattern[36     ] = 32'h12ED_12ED;
        bist_pattern[37     ] = 32'h24DB_24DB;
        bist_pattern[38     ] = 32'h48B7_48B7;
        bist_pattern[39     ] = 32'h817E_817E;
        bist_pattern[40     ] = 32'h0012_0012;
        bist_pattern[41     ] = 32'h0024_0024;
        bist_pattern[42     ] = 32'h0048_0048;
        bist_pattern[43     ] = 32'h0081_0081;
        bist_pattern[44     ] = 32'h1200_1200;
        bist_pattern[45     ] = 32'h2400_2400;
        bist_pattern[46     ] = 32'h4800_4800;
        bist_pattern[47     ] = 32'h8100_8100;
        bist_pattern[48     ] = 32'h0101_0101;
        bist_pattern[49     ] = 32'h0202_0202;
        bist_pattern[50     ] = 32'h0404_0404;
        bist_pattern[51     ] = 32'h0808_0808;
        bist_pattern[52     ] = 32'h1010_1010;
        bist_pattern[53     ] = 32'h2020_2020;
        bist_pattern[54     ] = 32'h4040_4040;
        bist_pattern[55     ] = 32'h8080_8080;
        bist_pattern[56     ] = 32'hFEFE_FEFE;
        bist_pattern[57     ] = 32'hFDFD_FDFD;
        bist_pattern[58     ] = 32'hFBFB_FBFB;
        bist_pattern[59     ] = 32'hF7F7_F7F7;
        bist_pattern[60     ] = 32'hEFEF_EFEF;
        bist_pattern[61     ] = 32'hDFDF_DFDF;
        bist_pattern[62     ] = 32'hBFBF_BFBF;
        bist_pattern[63     ] = 32'h7F7F_7F7F;      //}}}

        foreach (bist_pattern[j]) begin
            m_tb_if.bist_pattern[j] = bist_pattern[j];
            $display("bist_pattern%0d is %0h", j, m_tb_if.bist_pattern[j]);
        end
        //close scb gradd check
        m_tb_if.bist_test_en = 1'b1;

        //timeout th
        //m_tb_if.mc_timeout_th = 32'hffff_ffff;

        //disable rdy clamp
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_rdrdy_n_en.write(status, 1'b0, UVM_FRONTDOOR);

        //open timeout
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_timeout_en.write(status,1'h1, UVM_FRONTDOOR);
        @(posedge m_tb_if.pclk);
        m_tb_if.mc_scan_timeout_en  =   1;
        //dut intf
        m_tb_if.csl_err_threshold   = 1'b1;
        m_tb_if.bist_wl_scan_single_pattern_rd_num  =   bist_wl_scan_single_pattern_rd_num;
        m_tb_if.page_mode_switch    = page_mode;

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_mask.write(status, mb_bist_finish_mask,UVM_FRONTDOOR);
        `uvm_info(get_type_name(),$sformatf("@times %0d, bist_finish_mask is %0b, bist_wl_scan_single_pattern_rd_num is %0d",i, mb_bist_finish_mask, bist_wl_scan_single_pattern_rd_num),UVM_LOW)
        `uvm_info("", $sformatf("mc_bist_grant: %4b", mb_bank_sel), UVM_MEDIUM)
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bank_cfg_reg_reg.mc_bist_grant.write(status, mb_bank_sel, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_csl_scan_addr_range_sel.write(status, mb_csl_scan_addr_range_sel, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.csl_bist_pattern_sel0_reg.write(status, mb_csl_pattern_sel[31:0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.csl_bist_pattern_sel1_reg.write(status, mb_csl_pattern_sel[63:32], UVM_FRONTDOOR);
        data        = {28'h0, mb_csl_pattern_sel[67:64]};
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.csl_bist_pattern_sel2_reg.write(status, data, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.wl_bist_pattern_sel0_reg.write(status, mb_wl_pattern_sel[31:0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.wl_bist_pattern_sel1_reg.write(status, mb_wl_pattern_sel[63:32], UVM_FRONTDOOR);
        data        = {28'h0, mb_wl_pattern_sel[67:64]};
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.wl_bist_pattern_sel2_reg.write(status, data, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg0.write(status, bist_pattern[64], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg1.write(status, bist_pattern[65], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg2.write(status, bist_pattern[66], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg3.write(status, bist_pattern[67], UVM_FRONTDOOR);

        //mc_en
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_en.write(status, 1'b1,UVM_FRONTDOOR);
        //global_mc_bist_en
        @(posedge m_tb_if.pclk);
        m_tb_if.global_mc_bist_en = 1'b1;

        //refresh start 
        `ifdef SPEEDUP
        m_tb_if.rf_range_change_en  = 1'b1;
        repeat(10) @(posedge m_tb_if.pclk);
        m_tb_if.rf_single_interval  = 32'h40_0000;
        m_tb_if.rf_gear_up_en       = 1'b1;
        @(posedge m_tb_if.clk);
        m_tb_if.rf_gear_up_en       = 1'b0;
        @(posedge m_tb_if.clk);
        m_tb_if.rf_addr             = {13'h0, REFRESH_END_ADDR};
        `endif
        @(posedge m_tb_if.clk);
        m_tb_if.mc_rf_start = 1'b1;

        if (i == 0) begin
        //first bist scan

            //--- wait refresh ---
            wait(m_tb_if.rf_request);
            @(negedge m_tb_if.rf_request);

            do begin
                @(posedge m_tb_if.clk);
            end while(m_array_agent_if.gradd_n != REFRESH_END_ADDR);
            @(posedge m_array_agent_if.bnksel_n[0]);
            //--------------------

            //mc_bist_en disable
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_bist_en.write(status,1'b0,UVM_FRONTDOOR);
            fork
                begin
                    @(posedge m_tb_if.pclk)
                    //global_mc_bist_start 
                    m_tb_if.global_mc_bist_start = 1'b1;

                    @(posedge m_tb_if.pclk)
                    m_tb_if.global_mc_bist_start = 1'b0;
                end

                begin
                    //check mc bist disable
                    @(posedge m_tb_if.clk);
                    @(posedge m_tb_if.clk);
                    `uvm_info("mc bist disable", "mc bist disable check start!",UVM_LOW)
                    repeat(100) begin
                        //if(p_sequencer.m_array_agent_if.bnksel_n == 1'b0)
                        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_bank_scan.bank_scan_frame_vld", bank_vld);
                        if(bank_vld)
                            `uvm_error("mc bist disable", "mc bist disable, but bank0 work vld is 1'b0!!")
                        @(posedge m_tb_if.clk);
                    end
                    //repeat(100) begin     TODO
                    //    //if(p_sequencer.m_array_agent_if.bnksel_n == 1'b0)
                    //    uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_bank_scan.bank_scan_frame_vld", bank_vld);
                    //    if(bank_vld)
                    //        `uvm_error("mc bist disable", "mc bist disable, but bank1 work vld is 1'b0!!")
                    //    @(posedge m_tb_if.clk);
                    //end
                end
            join

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_bist_en.write(status,1'b1,UVM_FRONTDOOR);
            //global_mc_bist_en
            @(posedge m_tb_if.pclk);
            m_tb_if.global_mc_bist_en = 1'b0;

            fork
                begin
                    @(posedge m_tb_if.pclk)
                    //global_mc_bist_start 
                    m_tb_if.global_mc_bist_start = 1'b1;

                    @(posedge m_tb_if.pclk)
                    m_tb_if.global_mc_bist_start = 1'b0;
                end

                begin
                    //check mc bist disable
                    @(posedge m_tb_if.clk);
                    @(posedge m_tb_if.clk);
                    `uvm_info("mc bist disable", "mc bist disable check start!",UVM_LOW)
                    repeat(100) begin
                        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_bank_scan.bank_scan_frame_vld", bank_vld);
                        if(bank_vld)
                            `uvm_error("mc bist disable", "mc bist disable, but bank0 work vld is 1'b0!!")
                        @(posedge m_tb_if.clk);
                    end
                end
            join
        end

        #50ns
        //global_mc_bist_en
        @(posedge m_tb_if.pclk);
        m_tb_if.global_mc_bist_en = 1'b1;
        //mc_bist_en enable
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_bist_en.write(status,1'b1,UVM_FRONTDOOR);

        fork 
            begin
                //global_mc_bist_start 
                @(posedge m_tb_if.pclk);
                m_tb_if.global_mc_bist_start = 1'b1;
                @(posedge m_tb_if.pclk)
                m_tb_if.global_mc_bist_start = 1'b0;
                //----------
                repeat(5) @(posedge m_tb_if.pclk)
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank0.peek(status, bank_success);
                if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success_bank0 did not be 0!!")
                `ifdef TEST_1_SHOT_2
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank1.peek(status, bank_success);
                if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success_bank1 did not be 0!!")
                `elsif TEST_1_SHOT_3
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank1.peek(status, bank_success);
                if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success_bank1 did not be 0!!")
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank2.peek(status, bank_success);
                if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success_bank2 did not be 0!!")
                `elsif TEST_1_SHOT_4
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank1.peek(status, bank_success);
                if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success_bank1 did not be 0!!")
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank2.peek(status, bank_success);
                if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success_bank2 did not be 0!!")
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank3.peek(status, bank_success);
                if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success_bank3 did not be 0!!")
                `elsif TEST_1_SHOT_1
                `else
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank1.peek(status, bank_success);
                if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success_bank1 did not be 0!!")
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank2.peek(status, bank_success);
                if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success_bank2 did not be 0!!")
                `endif
            end
            begin
                repeat($urandom_range(5)) @(posedge m_tb_if.clk);

                #1ps;
                if ($urandom_range(1))
                    uvm_hdl_deposit("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.frame2array_u.rf_cnt", 0);
            end
        join

        `uvm_info(get_type_name(),"\n================= bist scan start ====================",UVM_LOW)
        bist_scan_start_time = $realtime;
        `uvm_info(get_type_name(),$sformatf("bist_scan_start_time is %t", bist_scan_start_time),UVM_LOW)

        fork:bist_scan
            begin
                repeat(20) @(posedge m_tb_if.clk);
                if (i == 1) begin
                    //second bist scan, check bist status register clear
                    if(mb_bank_sel[0]) begin
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank0.peek(status, bist_finish);
                        if (bist_finish != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bist_finish did not clear!!")
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank0.peek(status, bank_success);
                        if (bank_success != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bank_success did not be 0!!")
                    end
                    `ifdef TEST_1_SHOT_2
                    if(mb_bank_sel[1]) begin
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.peek(status, bist_finish);
                        if (bist_finish != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bist_finish did not clear!!")
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank1.peek(status, bank_success);
                        if (bank_success != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bank_success did not be 0!!")
                    end
                    `elsif TEST_1_SHOT_3
                    if(mb_bank_sel[1]) begin
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.peek(status, bist_finish);
                        if (bist_finish != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bist_finish did not clear!!")
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank1.peek(status, bank_success);
                        if (bank_success != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bank_success did not be 0!!")
                    end
                    if(mb_bank_sel[2]) begin
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank2.peek(status, bist_finish);
                        if (bist_finish != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bist_finish did not clear!!")
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank2.peek(status, bank_success);
                        if (bank_success != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bank_success did not be 0!!")
                    end
                    `elsif TEST_1_SHOT_4
                    if(mb_bank_sel[1]) begin
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.peek(status, bist_finish);
                        if (bist_finish != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bist_finish did not clear!!")
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank1.peek(status, bank_success);
                        if (bank_success != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bank_success did not be 0!!")
                    end
                    if(mb_bank_sel[2]) begin
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank2.peek(status, bist_finish);
                        if (bist_finish != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bist_finish did not clear!!")
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank2.peek(status, bank_success);
                        if (bank_success != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bank_success did not be 0!!")
                    end
                    if(mb_bank_sel[3]) begin
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank3.peek(status, bist_finish);
                        if (bist_finish != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bist_finish did not clear!!")
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank3.peek(status, bank_success);
                        if (bank_success != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bank_success did not be 0!!")
                    end
                    `elsif TEST_1_SHOT_1
                    `else
                    if(mb_bank_sel[1]) begin
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.peek(status, bist_finish);
                        if (bist_finish != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bist_finish did not clear!!")
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank1.peek(status, bank_success);
                        if (bank_success != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bank_success did not be 0!!")
                    end
                    if(mb_bank_sel[2]) begin
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank2.peek(status, bist_finish);
                        if (bist_finish != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bist_finish did not clear!!")
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank2.peek(status, bank_success);
                        if (bank_success != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bank_success did not be 0!!")
                    end
                    `endif
                end
            end

            begin
                repeat(20) @(posedge m_tb_if.clk);
                do begin
                    //wait for bist_finish
                    if(mb_bank_sel[0])
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank0.peek(status, bist_finish); //need to consider read or peek
                    `ifdef TEST_1_SHOT_2
                    if(mb_bank_sel[1])
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.peek(status, bist_finish); //need to consider read or peek
                    `elsif TEST_1_SHOT_3
                    if(mb_bank_sel[1])
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.peek(status, bist_finish); //need to consider read or peek
                    if(mb_bank_sel[2])
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank2.peek(status, bist_finish); //need to consider read or peek
                    `elsif TEST_1_SHOT_4
                    if(mb_bank_sel[1])
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.peek(status, bist_finish); //need to consider read or peek
                    if(mb_bank_sel[2])
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank2.peek(status, bist_finish); //need to consider read or peek
                    if(mb_bank_sel[3])
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank3.peek(status, bist_finish); //need to consider read or peek
                    `elsif TEST_1_SHOT_1
                    `else
                    if(mb_bank_sel[1])
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.peek(status, bist_finish); //need to consider read or peek
                    if(mb_bank_sel[2])
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank2.peek(status, bist_finish); //need to consider read or peek
                    `endif
                    bist_scan_end_time =$realtime;
                    //$display("@%0d, bist scan has been running for %t !!", i, bist_scan_end_time-bist_scan_start_time);
                    @(posedge m_tb_if.clk);
                end while(bist_finish != 1);

                if(mb_bank_sel[0]) begin
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank0.peek(status, bank_success);
                    if (bank_success != 1'b1) `uvm_error("bist scan check", "bist scan finish, bank_success_bank0 did not be 1!!")
                end
                `ifdef TEST_1_SHOT_2
                if(mb_bank_sel[1]) begin
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank1.peek(status, bank_success);
                    if (bank_success != 1'b1) `uvm_error("bist scan check", "bist scan finish, bank_success_bank1 did not be 1!!")
                end
                `elsif TEST_1_SHOT_3
                if(mb_bank_sel[1]) begin
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank1.peek(status, bank_success);
                    if (bank_success != 1'b1) `uvm_error("bist scan check", "bist scan finish, bank_success_bank1 did not be 1!!")
                end
                if(mb_bank_sel[2]) begin
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank2.peek(status, bank_success);
                    if (bank_success != 1'b1) `uvm_error("bist scan check", "bist scan finish, bank_success_bank2 did not be 1!!")
                end
                `elsif TEST_1_SHOT_4
                if(mb_bank_sel[1]) begin
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank1.peek(status, bank_success);
                    if (bank_success != 1'b1) `uvm_error("bist scan check", "bist scan finish, bank_success_bank1 did not be 1!!")
                end
                if(mb_bank_sel[2]) begin
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank2.peek(status, bank_success);
                    if (bank_success != 1'b1) `uvm_error("bist scan check", "bist scan finish, bank_success_bank2 did not be 1!!")
                end
                if(mb_bank_sel[3]) begin
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank3.peek(status, bank_success);
                    if (bank_success != 1'b1) `uvm_error("bist scan check", "bist scan finish, bank_success_bank3 did not be 1!!")
                end
                `elsif TEST_1_SHOT_1
                `else
                if(mb_bank_sel[1]) begin
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank1.peek(status, bank_success);
                    if (bank_success != 1'b1) `uvm_error("bist scan check", "bist scan finish, bank_success_bank1 did not be 1!!")
                end
                if(mb_bank_sel[2]) begin
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_bank2.peek(status, bank_success);
                    if (bank_success != 1'b1) `uvm_error("bist scan check", "bist scan finish, bank_success_bank2 did not be 1!!")
                end
                `endif

                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_status.peek(status, bist_status);
                if (bist_status != 3'b000) `uvm_error("second bist status", "2nd bist scan, bist_status did not be 0!!")

                if(m_tb_if.fsm != 0) begin      //in refresh state
                    if (m_array_agent_if.gcadd != (COL_NUM-1) || m_array_agent_if.gradd_n != 0)
                        `uvm_error(get_type_name(),"bist finish is 1'b1, but addr not the last one")
                    else
                        `uvm_info(get_type_name(),"bist_scan pass!!", UVM_LOW)
                end
                else begin
                    if (m_array_agent_if.gcadd != (COL_NUM-1) || m_array_agent_if.gradd_n != (WL_NUM-1))
                        `uvm_error(get_type_name(),"bist finish is 1'b1, but addr not the last one")
                    else
                        `uvm_info(get_type_name(),"bist_scan pass!!", UVM_LOW)
                end
            end

            for(int cnt_bank = 0; cnt_bank < 4; cnt_bank++) begin
                if(mb_bank_sel[cnt_bank]) begin
                    //----------------- pattern_check ------------------
                    //path check
                    @(posedge m_array_agent_if.rdrdy_n);
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_status.peek(status, bist_status);
                    if (bist_status != 3'b001) `uvm_error("bist status", "bank path check, bist_status did not be 3'b001!!")

                    //csl_scan:
                    `uvm_info("pattern_check", "csl_scan pattern_check start",UVM_LOW)
                    for(int i=0;i<68;i++) begin
                        if(mb_csl_pattern_sel[i]) begin
                            `uvm_info("", $sformatf("csl_pattern_check @ sel: %0d, pattern: %0h", i, bist_pattern[i]), UVM_MEDIUM)
                            write_pattern_check(cnt_bank, bist_pattern[i], 1'b0);
                            read_pattern_check(cnt_bank, bist_pattern[i], 1'b0);
                        end
                    end

                    //wl_scan
                    `uvm_info("pattern_check", "wl_scan pattern_check start",UVM_LOW)
                    for(int i=0;i<68;i++) begin
                        if(mb_wl_pattern_sel[i]) begin
                            `uvm_info("", $sformatf("wl_pattern_check @ sel: %0d, pattern: %0h", i, bist_pattern[i]), UVM_MEDIUM)
                            write_pattern_check(cnt_bank, bist_pattern[i], 1'b1);
                            read_pattern_check(cnt_bank, bist_pattern[i], 1'b1);
                        end
                    end
                    `uvm_info("pattern_check", "wl_scan pattern_check done",UVM_LOW)
                end
            end
            begin: refresh_check
                fork 
                    while (1) begin
                        @(posedge m_tb_if.rf_request);
                        @(negedge m_tb_if.rf_request);

                        for (int i=0;i<REFRESH_END_ADDR;i++) begin
                            @(negedge m_array_agent_if.bnksel_n[0]);
                            #1ps;
                            if (m_array_agent_if.gradd_n != i)
                                `uvm_error("rf_addr_check", $sformatf("rf_addr_check error! exp radd is %0h, act is %0h", i, m_array_agent_if.gradd_n))

                            @(posedge m_array_agent_if.bnksel_n[0]);
                            #1ps;
                            if (m_array_agent_if.gradd_n != i)
                                `uvm_error("rf_addr_check", $sformatf("rf_addr_check error! exp radd is %0h, act is %0h", i, m_array_agent_if.gradd_n))
                        end
                    end
                    while (1) begin
                        @(posedge m_tb_if.rf_request);
                        @(negedge m_tb_if.rf_request);

                        for (int i=0;i<REFRESH_END_ADDR;i++) begin
                            @(negedge m_array_agent_if.bnksel_n[1]);
                            #1ps;
                            if (m_array_agent_if.gradd_n != i)
                                `uvm_error("rf_addr_check", $sformatf("rf_addr_check error! exp radd is %0h, act is %0h", i, m_array_agent_if.gradd_n))

                            @(posedge m_array_agent_if.bnksel_n[1]);
                            #1ps;
                            if (m_array_agent_if.gradd_n != i)
                                `uvm_error("rf_addr_check", $sformatf("rf_addr_check error! exp radd is %0h, act is %0h", i, m_array_agent_if.gradd_n))
                        end
                    end

                    while(1) begin
                        if(bist_finish) begin
                            `uvm_info("", "refresh_check finish", UVM_NONE)
                            disable refresh_check;
                            break;
                        end
                        else begin 
                            @(posedge m_tb_if.clk);
                        end
                    end
                join
            end

        join
        

        `uvm_info(get_type_name(),"\n================ bist scan end =================== ",UVM_LOW)
        if ((bist_scan_end_time - bist_scan_start_time) > 0)
            `uvm_info(get_type_name(),$sformatf("bist scan end, bist scan time is %t",bist_scan_end_time-bist_scan_start_time),UVM_LOW)
        else
            `uvm_error(get_type_name(), "bist_scan time < 0, modify checker!!!")

        //----------check err addr
        tsk_bist_err_addr_chk();

        for(int kk=0;kk<64;kk++) begin
            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bank_err_wl%0d", kk), err_row_addr);
            if(err_row_addr[`ROW_ADDR_WIDTH*`BANK_ADDR_WIDTH-1] != ERR_WL_DEFAULT_VALUE[`ROW_ADDR_WIDTH*`BANK_ADDR_WIDTH-1])
                `uvm_error(get_type_name(),$sformatf("err_wl%0d_bank0 error, exp is %0h, act is %0h", kk, ERR_WL_DEFAULT_VALUE, err_row_addr))
        end


        //check bist_finish_intr
        if(mb_bist_finish_mask == 1'b1) begin
            if (m_tb_if.bist_finish_intr != 1'b0) `uvm_error(get_type_name(),"bist_finish_mask is 1'b1, but bist_finish_intr is 1'b1")
            else    `uvm_info(get_type_name(),"bist_finish_intr check pass!", UVM_LOW)
        end

        else begin
            if (m_tb_if.bist_finish_intr != 1'b1) `uvm_error(get_type_name(),"bist_finish_mask is 1'b0, but bist_finish_intr is 1'b0")
            else    `uvm_info(get_type_name(),"bist_finish_intr check pass!", UVM_LOW)
        end


        if (i ==0) begin
            //clear bist_finish_intr
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_clr.write(status,1'b1,UVM_FRONTDOOR);

            repeat(10) @(posedge m_tb_if.clk);
            //check clear
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank0.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank0 not clear!!!")   
            `ifdef TEST_1_SHOT_2
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank1 not clear!!!")   
            `elsif TEST_1_SHOT_3
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank1 not clear!!!")   
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank2.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank2 not clear!!!")   
            `elsif TEST_1_SHOT_4
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank1 not clear!!!")   
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank2.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank2 not clear!!!")   
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank3.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank3 not clear!!!")   
            `elsif TEST_1_SHOT_1
            `else
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank1 not clear!!!")   
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank2.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank2 not clear!!!")   
            `endif

            repeat(100) @(posedge m_tb_if.clk);
            //check clear
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank0.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank0 not clear!!!")   
            `ifdef TEST_1_SHOT_2
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank1 not clear!!!")   
            `elsif TEST_1_SHOT_3
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank1 not clear!!!")   
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank2.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank2 not clear!!!")   
            `elsif TEST_1_SHOT_4
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank1 not clear!!!")   
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank2.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank2 not clear!!!")   
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank3.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank3 not clear!!!")   
            `elsif TEST_1_SHOT_1
            `else
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank1.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank1 not clear!!!")   
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_bank2.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0) `uvm_error(get_type_name(),"bist_finish_bank2 not clear!!!")   
            `endif
        end

        repeat(20) @(posedge m_tb_if.pclk);
    end

    //for toggle coverage
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_mask.write(status,1'b1,UVM_FRONTDOOR);
    #10000ns;
endtask:body

task mc_bist_vseq::read_pattern_check(int bank_sel, bit [`PATTERN_WIDTH-1:0] pattern, bit scan_type);
    bit [`ARRAY_DATA_WIDTH-1:0]     golden_data[4];

    bit [`ARRAY_DATA_WIDTH-1:0]     capture_data;
    bit [`COLUMN_ADDR_WIDTH-1:0]    capture_col_addr;
    bit [`ROW_ADDR_WIDTH-1:0]       capture_row_addr;
    bit [`BANK_ADDR_WIDTH-1:0]      capture_bank_sel;
    
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_col_addr;
    bit [`ROW_ADDR_WIDTH-1:0]       exp_row_addr;
    bit [4-1:0]                     exp_bank_sel;
    bit [`COLUMN_ADDR_WIDTH-1:0]    capture_col_addr_q[$]; 
    bit [`ROW_ADDR_WIDTH-1:0]       capture_row_addr_q[$];
    bit [`ARRAY_DATA_WIDTH-1:0]     exp_golden_data;

    bit [2:0]                       bist_status;

    exp_bank_sel = 4'hf;
    exp_bank_sel[bank_sel] = 0;
    for(int i=0;i<4;i++) begin
        golden_data[i] = {34{pattern[i*8+:8]}};
    end


    if (scan_type) begin
        //wl_scan reading: 

    repeat(bist_wl_scan_single_pattern_rd_num+1) begin
        fork
        //================== addr =====================
            begin
                for (int i=0;i<WL_NUM;i++) begin
                //row + 1
                    for (int j=0;j<COL_NUM;) begin
                        //col +1
                        @(posedge m_array_agent_if.clk);
                        if(m_array_agent_if.gcas_rd) begin
                            capture_bank_sel = m_array_agent_if.bnksel_n;
                            capture_row_addr = m_array_agent_if.gradd_n;
                            capture_col_addr = m_array_agent_if.gcadd;

                            capture_col_addr_q.push_back(capture_col_addr);
                            capture_row_addr_q.push_back(capture_row_addr);

                            if (capture_bank_sel[`BANK_ADDR_WIDTH-1:0] != exp_bank_sel[`BANK_ADDR_WIDTH-1:0])
                                `uvm_error("pattern_check error",$sformatf("pattern_check error: wl_scan, reading, bank_sel may not correct, exp: %0h, act: %0h", exp_bank_sel,capture_bank_sel))

                            //check row_addr, col_addr 
                            if (capture_row_addr != i)
                                `uvm_error("pattern_check error",$sformatf("pattern_check error: wl_scan, reading, gradd_n may not correct, exp: %0h, act: %0h", i,capture_row_addr))
                            //else
                            //    `uvm_info("pattern_check", $sformatf("pattern_check pass: wl_scan, reading, gradd_n %0h check pass", capture_row_addr),UVM_LOW)

                            if (capture_col_addr != j)
                                `uvm_error("pattern_check error",$sformatf("pattern_check error: wl_scan, reading, gcadd may not correct, exp: %0h, act: %0h",j, capture_col_addr))
                            //else
                            //    `uvm_info("pattern_check", $sformatf("pattern_check pass: wl_scan, reading, gcadd %0h check pass", capture_col_addr),UVM_LOW)

                            //check bist_status
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_status.peek(status, bist_status);
                            if (bist_status != 3'b100) `uvm_error("bist status", "wl check, bist_status did not be 3'b100!!")
                            j++;
                        end
                    end
                end
            end

            begin
                //================== data ===================
                for (int i=0;i<WL_NUM;i++) begin
                //row + 1
                    for (int j=0;j<COL_NUM;j++) begin
                        //col +1
                        @(posedge m_array_agent_if.rdrdy_n);
                        capture_data    = m_array_agent_if.rdl;
                        exp_col_addr    = capture_col_addr_q.pop_front;
                        exp_row_addr    = capture_row_addr_q.pop_front;

                        exp_golden_data = golden_data[i%4];
                        //check data 

                        if (capture_data != exp_golden_data)
                            `uvm_error("pattern_check error",$sformatf("pattern_check error: wl_scan, reading, gradd_n:%0h, gcadd:%0h, exp_golden_data:%0h, act data:%0h",capture_row_addr, capture_col_addr,exp_golden_data, capture_data))
                        //else
                        //    `uvm_info("pattern_check", $sformatf("pattern_check pass: wl_scan, reading, pattern data check pass"),UVM_LOW)
                    end
                end
            end
        join
    end
    end

    else begin
        //============================================ csl_scan reading:  ===============================================
        //---------------------- 1st region row scan -----------------------------
        for  (int part_index=0; part_index<10;part_index++) begin
            fork
            //================== addr =====================
                begin
                    for (int i=0;i<mi_csl_col_num;i++) begin
                    //col + 1
                        for (int j=(part_index*(WL_NUM/10));j<((part_index+1)*WL_NUM/10);) begin
                            //row +1
                            @(posedge m_array_agent_if.clk);
                            if(m_array_agent_if.gcas_rd) begin
                                capture_bank_sel = m_array_agent_if.bnksel_n;
                                capture_row_addr = m_array_agent_if.gradd_n;
                                capture_col_addr = m_array_agent_if.gcadd;

                                capture_col_addr_q.push_back(capture_col_addr);
                                capture_row_addr_q.push_back(capture_row_addr);

                            if (capture_bank_sel[`BANK_ADDR_WIDTH-1:0] != exp_bank_sel[`BANK_ADDR_WIDTH-1:0])
                                `uvm_error("pattern_check error",$sformatf("pattern_check error: wl_scan, reading, bank_sel may not correct, exp: %0h, act: %0h", exp_bank_sel,capture_bank_sel))
                                //check row_addr, col_addr 
                                if (capture_row_addr != j)
                                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gradd_n may not correct, exp: %0h, act: %0h", j,capture_row_addr))
                                //else
                                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, gradd_n %0h check pass", capture_row_addr),UVM_LOW)

                                if (capture_col_addr != i)
                                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gcadd may not correct, exp: %0h, act: %0h",i, capture_col_addr))
                                //else
                                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, gcadd %0h check pass", capture_col_addr),UVM_LOW)

                                //bist status check
                                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_status.peek(status, bist_status);
                                if (bist_status != 3'b010) `uvm_error("bist status", "csl check, bist_status did not be 3'b010!!")
                                j++;
                            end
                        end
                    end
                end

                begin
                    //================== data ===================
                    for (int i=0;i<mi_csl_col_num;i++) begin
                    //col + 1
                        for (int j=(part_index*(WL_NUM/10));j<((part_index+1)*WL_NUM/10);j++) begin
                            //row +1
                            @(posedge m_array_agent_if.rdrdy_n);
                            capture_data    = m_array_agent_if.rdl;
                            exp_col_addr    = capture_col_addr_q.pop_front;
                            exp_row_addr    = capture_row_addr_q.pop_front;

                            exp_golden_data = golden_data[exp_row_addr%4];
                            //check data 

                            if (capture_data != exp_golden_data)
                                `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gradd_n:%0h, gcadd:%0h, exp_golden_data:%0h, act data:%0h",exp_row_addr, exp_col_addr,exp_golden_data, capture_data))
                            //else
                            //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, pattern data check pass"),UVM_LOW)
                        end
                    end
                end
            join

            if ( (capture_row_addr_q.size()>0) || (capture_col_addr_q.size()>0) ) begin
                `uvm_error("pattern_check error", "csl_scan, reading, during up row scan, not read out all addr")
                capture_row_addr_q.delete();
                capture_col_addr_q.delete();
            end
        end
    end
endtask:read_pattern_check

task mc_bist_vseq::write_pattern_check(int bank_sel, bit [`PATTERN_WIDTH-1:0] pattern, bit scan_type);

    bit [`ARRAY_DATA_WIDTH-1:0]     golden_data[4];

    bit [`ARRAY_DATA_WIDTH-1:0]     capture_data;
    bit [`COLUMN_ADDR_WIDTH-1:0]    capture_col_addr;
    bit [`ROW_ADDR_WIDTH-1:0]       capture_row_addr;
    bit [`BANK_ADDR_WIDTH-1:0]      capture_bank_sel;

    bit [`ARRAY_DATA_WIDTH-1:0]     exp_golden_data;
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_col_addr; 
    bit [`ROW_ADDR_WIDTH-1:0]       exp_row_addr;
    bit [4-1:0]                     exp_bank_sel;

    bit [2:0]                       bist_status;
    int                             i_col_num;

    string scan_type_name;
    scan_type_name = scan_type? "wl_scan":"csl_scan";

    i_col_num   = scan_type ? 128 : mi_csl_col_num;
    `uvm_info("", $sformatf("i_col_num: %0h", i_col_num), UVM_MEDIUM)

    `uvm_info("", $sformatf("pattern_check pattern: %h", pattern), UVM_MEDIUM)
    for(int i=0;i<4;i++) begin
        golden_data[i] = {34{pattern[i*8+:8]}};
    end

    exp_bank_sel = 4'hf;
    exp_bank_sel[bank_sel] = 0;
    exp_row_addr = 'h0;
    exp_col_addr = 'h0;

    for (int i=0;i<WL_NUM;i++) begin
        //row + 1
        exp_col_addr = 'h0;
        exp_golden_data = golden_data[i%4];

        for (int cnt_col=0;cnt_col<i_col_num;)begin
            //col +1
            @(posedge m_array_agent_if.clk);
            if(m_array_agent_if.gcas_wr) begin
                capture_bank_sel = m_array_agent_if.bnksel_n;
                capture_row_addr = m_array_agent_if.gradd_n;
                capture_col_addr = m_array_agent_if.gcadd;
                capture_data     = m_array_agent_if.wdl;

                if (capture_bank_sel[`BANK_ADDR_WIDTH-1:0] != exp_bank_sel[`BANK_ADDR_WIDTH-1:0])
                    `uvm_error("pattern_check error",$sformatf("pattern_check error: %s, writing, bank_sel may not correct, exp: %0h, act: %0h",scan_type_name, exp_bank_sel,capture_bank_sel))
                if (capture_row_addr != exp_row_addr)
                    `uvm_error("pattern_check error",$sformatf("pattern_check error: %s, writing, gradd_n may not correct, exp: %0h, act: %0h",scan_type_name, exp_row_addr,capture_row_addr))
                //else
                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: %s, writing, gradd_n %0h check pass",scan_type_name, capture_row_addr),UVM_LOW)

                if (capture_col_addr != exp_col_addr)
                    `uvm_error("pattern_check error",$sformatf("pattern_check error: %s, writing, gcadd may not correct, exp: %0h, act: %0h",scan_type_name,exp_col_addr, capture_col_addr))
                //else
                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: %s, writing, gcadd %0h check pass",scan_type_name, capture_col_addr),UVM_LOW)

                if (capture_data != exp_golden_data)
                    `uvm_error("pattern_check error",$sformatf("pattern_check error: %s, writing, gradd_n:%0h, gcadd:%0h, exp_golden_data:%0h, act data:%0h",scan_type_name,capture_row_addr, capture_col_addr,exp_golden_data, capture_data))
                //else
                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: %s, writing, pattern data check pass",scan_type_name),UVM_LOW)

                //bist status check
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_status.peek(status, bist_status);
                if (scan_type) begin
                    if (bist_status != 3'b100) `uvm_error("bist status", "wl check, bist_status did not be 3'b100!!")
                end
                else begin
                    if (bist_status != 3'b010) `uvm_error("bist status", "csl check, bist_status did not be 3'b010!!")
                end

                exp_col_addr = exp_col_addr + 1'b1;
                `uvm_info("", $sformatf("exp_col_addr: %0h", exp_col_addr), UVM_MEDIUM)
                cnt_col++;
            end
        end

        exp_row_addr = exp_row_addr + 1'b1;
        `uvm_info("", $sformatf("exp_row_addr: %0h", exp_row_addr), UVM_MEDIUM)
    end
endtask:write_pattern_check
`endif
