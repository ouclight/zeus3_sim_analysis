`ifndef MC_BIST_VSEQ
`define MC_BIST_VSEQ


class mc_bist_vseq extends mc_common_vseq;

    `uvm_object_utils(mc_bist_vseq)

    function new(string name="mc_bist_vseq");
        super.new(name);
    endfunction
    
    localparam      COL_ALL_NUM='d130;
    localparam      COL_NUM='d128;
    localparam      WL_NUM='d300;
    localparam      REFRESH_END_ADDR='d7359;
    localparam      ERR_CSL_DEFAULT_VALUE='hff;
    localparam      ERR_WL_DEFAULT_VALUE='h1fff;

    rand bit [`PATTERN_WIDTH-1:0]   bist_pattern[64];
    rand bit [7:0]                  bist_csl_scan_num   ;
    rand bit [7:0]                  bist_wl_scan_num   ;
    rand bit                        bist_finish_mask;
    rand bit                        page_mode;

    rand bit [3:0]                  bist_wl_scan_single_pattern_rd_num;

    rand bit [31:0]                 period;    
    rand bit [31:0]                 rf_start_time;

    //64ms:32'h30d4000, 32ms:32'h186a000, 16ms:32'hc35000, 8ms:32'h61a800, 4ms:32'h30d400; 1ms:32'hc3500
    constraint c_period{
        period dist {'h30d4000:=20, 'h186a000:=20, 'hc35000:=20, 'h61a800:=20, 'h30d400:=20, 'hc3500:=20};
    }
    
    constraint c_rf_start_time{
        solve period before rf_start_time;
        rf_start_time < period;
    }


    constraint c_bist_csl_scan_num{
        bist_csl_scan_num dist {[1:64]:/70, 2:/25, 64:/25};
    }

    constraint c_bist_wl_scan_single_pattern_rd_num{
        bist_wl_scan_single_pattern_rd_num  dist {['d0:'d15]:/50, 'd0:/50, 'd15:/50}; 
    }

    constraint c_bist_wl_scan_num{
        solve bist_csl_scan_num before bist_wl_scan_num;
        if(bist_csl_scan_num == 2)
            bist_wl_scan_num dist {[1:64]:/40, 64:/60};
        else if (bist_csl_scan_num == 64)
            bist_wl_scan_num dist {[1:64]:/70, 64:/30};
        else
            bist_wl_scan_num inside {[1:64]};
    }
    
    extern virtual task body();
    extern task write_pattern_check(bit [`PATTERN_WIDTH-1:0] pattern, bit scan_type); //scan_type: 0:csl_scan;  1:wl_scan
    extern task read_pattern_check (bit [`PATTERN_WIDTH-1:0] pattern, bit scan_type); //scan_type: 0:csl_scan;  1:wl_scan

endclass:mc_bist_vseq

task mc_bist_vseq::body();

    bit             bist_finish;
    bit             bank_success;
    bit [2:0]       bist_status;
    bit             bank_vld;
    real            bist_scan_start_time;
    real            bist_scan_end_time;

    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_addr;
    bit [`ROW_ADDR_WIDTH-1:0]       err_row_addr;


    super.body();
    //uvm_hdl_deposit("mc_tb.u_quad_group.bank0.ram_memory[0]",0);
    uvm_hdl_deposit("mc_tb.u_quad_group.XBK0.memory[0]",0);
    
    for (int i=0;i<2;i++) begin
        `uvm_info(get_type_name(),$sformatf("\n========================== mc_bist_vseq start@%0d ============================",i),UVM_LOW)

        //wait for solving open page problem
        assert(randomize()with{ //page_mode           == 1'b1;
                                //bist_csl_scan_num   == 'd2;
                                //bist_wl_scan_num    == 'd2;
        });

        //========================== reg and signal config =================================

        foreach (bist_pattern[j]) begin
            m_tb_if.bist_pattern[j] = bist_pattern[j];
            $display("bist_pattern%0d is %0h", j, m_tb_if.bist_pattern[j]);
        end

        //close scb gradd check
        m_tb_if.bist_test_en = 1'b1;

        //timeout th
        //m_tb_if.mc_timeout_th = 32'hffff_ffff;

        //disable rdy clamp
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rdrdy_n_en.write(status, 1'b0, UVM_FRONTDOOR);

        //open timeout
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_en.write(status,1'h1, UVM_FRONTDOOR);
        @(posedge m_tb_if.pclk);
        m_tb_if.mc_scan_timeout_en  =   1;
        //bist_scan_num
        m_tb_if.bist_wl_scan_num = bist_wl_scan_num;
        m_tb_if.bist_csl_scan_num = bist_csl_scan_num;

        //csl_err_threshold
        m_tb_if.csl_err_threshold = 1'b1;

        //bist_wl_scan_single_pattern_rd_num
        m_tb_if.bist_wl_scan_single_pattern_rd_num  =   bist_wl_scan_single_pattern_rd_num;

        //close page
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.page_mode_switch.write(status, page_mode, UVM_FRONTDOOR);
        @(posedge m_tb_if.pclk);
        m_tb_if.page_mode_switch = page_mode;

        //bist_finish_mask
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_mask.write(status,bist_finish_mask,UVM_FRONTDOOR);
        `uvm_info(get_type_name(),$sformatf("@times %0d, bist_wl_scan_num is %0d, bist_csl_scan_num is %0d, bist_finish_mask is %0b, bist_wl_scan_single_pattern_rd_num is %0d",i, bist_wl_scan_num, bist_csl_scan_num, bist_finish_mask, bist_wl_scan_single_pattern_rd_num),UVM_LOW)

        //mc_en
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status, 1'b1,UVM_FRONTDOOR);
        //global_mc_bist_en
        @(posedge m_tb_if.pclk);
        m_tb_if.global_mc_bist_en = 1'b1;

        //refresh start 
        @(posedge m_tb_if.clk);
        m_tb_if.mc_rf_start = 1'b1;

        if (i == 0) begin
        //first bist scan

            //--- wait refresh ---
            @(posedge m_tb_if.rf_request);
            @(negedge m_tb_if.rf_request);

            do begin
                @(posedge m_tb_if.clk);
            end while(m_array_agent_if.gradd_n != REFRESH_END_ADDR);
            @(posedge m_array_agent_if.bnksel_n);
            //--------------------

            //mc_bist_en disable
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_bist_en.write(status,1'b0,UVM_FRONTDOOR);
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
                        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_bank_scan.bank_scan_frame_vld", bank_vld);
                        if(bank_vld)
                            `uvm_error("mc bist disable", "mc bist disable, but bank work vld is 1'b0!!")
                        @(posedge m_tb_if.clk);
                    end

                end
            join

            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_bist_en.write(status,1'b1,UVM_FRONTDOOR);
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
                        //if(p_sequencer.m_array_agent_if.bnksel_n == 1'b0)
                        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_bank_scan.bank_scan_frame_vld", bank_vld);
                        if(bank_vld)
                            `uvm_error("mc bist disable", "mc bist disable, but bank work vld is 1'b0!!")
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
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_bist_en.write(status,1'b1,UVM_FRONTDOOR);

        fork 
            begin
                //global_mc_bist_start 
                @(posedge m_tb_if.pclk);
                m_tb_if.global_mc_bist_start = 1'b1;
                @(posedge m_tb_if.pclk)
                m_tb_if.global_mc_bist_start = 1'b0;
            end
            begin
                repeat($urandom_range(5)) @(posedge m_tb_if.clk);

                #1ps;
                if ($urandom_range(1))
                    uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", 0);
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
                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish.peek(status, bist_finish);
                    if (bist_finish != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bist_finish did not clear!!")

                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bank_success.peek(status, bank_success);
                    if (bank_success != 1'b0) `uvm_error("second bist scan check", "2nd bist scan, bank_success did not be 0!!")

                end
            end

            begin
                repeat(20) @(posedge m_tb_if.clk);
                do begin
                    //wait for bist_finish

                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish.peek(status, bist_finish); //need to consider read or peek
                    bist_scan_end_time =$realtime;
                    //$display("@%0d, bist scan has been running for %t !!", i, bist_scan_end_time-bist_scan_start_time);
                    @(posedge m_tb_if.clk);
                end while(bist_finish != 1);

                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bank_success.peek(status, bank_success);
                if (bank_success != 1'b1) `uvm_error("bist scan check", "bist scan finish, bank_success did not be 1!!")

                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_status.peek(status, bist_status);
                if (bist_status != 3'b000) `uvm_error("second bist status", "2nd bist scan, bist_status did not be 0!!")

                if (m_array_agent_if.gcadd != (COL_NUM-1) || m_array_agent_if.gradd_n != (WL_NUM-1))
                    `uvm_error(get_type_name(),"bist finish is 1'b1, but addr not the last one")
                else
                    `uvm_info(get_type_name(),"bist_scan pass!!", UVM_LOW)

            end
            begin
                //----------------- pattern_check ------------------
                //path check
                @(posedge m_array_agent_if.rdrdy_n);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_status.peek(status, bist_status);
                if (bist_status != 3'b001) `uvm_error("bist status", "bank path check, bist_status did not be 3'b001!!")

                //csl_scan:
                `uvm_info("pattern_check", "csl_scan pattern_check start",UVM_LOW)
                for (int i=0;i<bist_csl_scan_num;i++) begin
                    write_pattern_check(bist_pattern[i], 1'b0);
                    read_pattern_check(bist_pattern[i], 1'b0);
                end

                //wl_scan
                `uvm_info("pattern_check", "wl_scan pattern_check start",UVM_LOW)
                for (int i=0;i<bist_wl_scan_num;i++) begin
                    write_pattern_check(bist_pattern[i], 1'b1);
                    for (int ii=0;ii<bist_wl_scan_single_pattern_rd_num+1;ii++) begin
                        read_pattern_check(bist_pattern[i], 1'b1);
                    end
                end
            end
            begin: refresh_check
                //refresh check
                fork 
                    while (1) begin
                        @(posedge m_tb_if.rf_request);
                        @(negedge m_tb_if.rf_request);

                        for (int i=0;i<REFRESH_END_ADDR;i++) begin
                            @(negedge m_array_agent_if.bnksel_n);
                            #1ps;
                            if (m_array_agent_if.gradd_n != i)
                                `uvm_error("rf_addr_check", $sformatf("rf_addr_check error! exp radd is %0h, act is %0h", i, m_array_agent_if.gradd_n))

                            @(posedge m_array_agent_if.bnksel_n);
                            #1ps;
                            if (m_array_agent_if.gradd_n != i)
                                `uvm_error("rf_addr_check", $sformatf("rf_addr_check error! exp radd is %0h, act is %0h", i, m_array_agent_if.gradd_n))
                        end
                    end

                    while(1) begin
                        if(bist_finish) begin
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

        //check err addr
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part0.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl0_up error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part0.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl1_up error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part1.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part1.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part2.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part2.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part3.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part3.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part4.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part4.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part5.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part5.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part6.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part6.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part7.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part7.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part8.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part8.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part9.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part9.read(status, err_csl_addr, UVM_FRONTDOOR);
        if(err_csl_addr != ERR_CSL_DEFAULT_VALUE)
            `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))

        for(int kk=0;kk<64;kk++) begin
            uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.err_wl%0d",kk),err_row_addr);
            if(err_row_addr != ERR_WL_DEFAULT_VALUE)
                `uvm_error(get_type_name(),$sformatf("err_wl%0d error, exp is 3fff, act is %0h",kk, err_row_addr))
        end


        //check bist_finish_intr
        if(bist_finish_mask == 1'b1) begin
            if (m_tb_if.bist_finish_intr != 1'b0) `uvm_error(get_type_name(),"bist_finish_mask is 1'b1, but bist_finish_intr is 1'b1")
            else    `uvm_info(get_type_name(),"bist_finish_intr check pass!", UVM_LOW)
        end

        else begin
            if (m_tb_if.bist_finish_intr != 1'b1) `uvm_error(get_type_name(),"bist_finish_mask is 1'b0, but bist_finish_intr is 1'b0")
            else    `uvm_info(get_type_name(),"bist_finish_intr check pass!", UVM_LOW)
        end


        if (i ==1) begin
            //clear bist_finish_intr
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_clr.write(status,1'b1,UVM_FRONTDOOR);

            repeat(10) @(posedge m_tb_if.clk);
            //check clear
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0)
                `uvm_error(get_type_name(),"bist_finish not clear!!!")   

            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bank_success.peek(status, bank_success);
            if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success did not be 0!!")

            repeat(100) @(posedge m_tb_if.clk);
            //check clear
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish.read(status,bist_finish, UVM_FRONTDOOR);
            if(bist_finish != 0)
                `uvm_error(get_type_name(),"bist_finish not clear!!!")   
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bank_success.peek(status, bank_success);
            if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success did not be 0!!")
        end

    end

    //for toggle coverage
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_mask.write(status,1'b1,UVM_FRONTDOOR);
    #10000ns;
endtask:body

task mc_bist_vseq::read_pattern_check(bit [`PATTERN_WIDTH-1:0]       pattern, 
                                 bit                            scan_type);

    bit [`ARRAY_DATA_WIDTH-1:0]     golden_data[4];

    bit [`ARRAY_DATA_WIDTH-1:0]     capture_data;
    bit [`COLUMN_ADDR_WIDTH-1:0]    capture_col_addr;
    bit [`ROW_ADDR_WIDTH-1:0]       capture_row_addr;
    
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_col_addr;
    bit [`ROW_ADDR_WIDTH-1:0]       exp_row_addr;
    bit [`COLUMN_ADDR_WIDTH-1:0]    capture_col_addr_q[$]; 
    bit [`ROW_ADDR_WIDTH-1:0]       capture_row_addr_q[$];
    bit [`ARRAY_DATA_WIDTH-1:0]     exp_golden_data;

    bit [2:0]                       bist_status;

    for(int i=0;i<4;i++) begin
        golden_data[i] = {pattern[i*8+:2], {33{pattern[i*8+:8]}}};
    end


    if (scan_type) begin
        //wl_scan reading: 

        fork
        //================== addr =====================
            begin
                for (int i=0;i<WL_NUM;i++) begin
                //row + 1
                    for (int j=0;j<COL_NUM;j++) begin
                        //col +1
                        @(negedge m_array_agent_if.gcas_rd);
                        capture_row_addr = m_array_agent_if.gradd_n;
                        capture_col_addr = m_array_agent_if.gcadd;

                        capture_col_addr_q.push_back(capture_col_addr);
                        capture_row_addr_q.push_back(capture_row_addr);

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
                        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_status.peek(status, bist_status);
                        if (bist_status != 3'b100) `uvm_error("bist status", "wl check, bist_status did not be 3'b100!!")
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

                        exp_golden_data = golden_data[exp_row_addr%4];
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

    else begin
        //============================================ csl_scan reading:  ===============================================
        //---------------------- 1st region row scan -----------------------------
        for  (int part_index=0; part_index<10;part_index++) begin
            fork
            //================== addr =====================
                begin
                    for (int i=0;i<COL_ALL_NUM;i++) begin
                    //col + 1
                        for (int j=(part_index*(WL_NUM/10));j<((part_index+1)*WL_NUM/10);j++) begin
                            //row +1
                            @(negedge m_array_agent_if.gcas_rd);
                            capture_row_addr = m_array_agent_if.gradd_n;
                            capture_col_addr = m_array_agent_if.gcadd;

                            capture_col_addr_q.push_back(capture_col_addr);
                            capture_row_addr_q.push_back(capture_row_addr);

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
                            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_status.peek(status, bist_status);
                            if (bist_status != 3'b010) `uvm_error("bist status", "csl check, bist_status did not be 3'b010!!")
                        end
                    end
                end

                begin
                    //================== data ===================
                    for (int i=0;i<COL_ALL_NUM;i++) begin
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

        //------------------------------------ 2nd  row scan ---------------------------------------------------
        //fork
        ////================== addr =====================
        //    begin
        //        for (int i=0;i<COL_ALL_NUM;i++) begin
        //        //col + 1
        //            for (int j=(WL_NUM/5);j<(WL_NUM*2/5);j++) begin
        //                //row +1
        //                @(negedge m_array_agent_if.gcas_rd);
        //                capture_row_addr = m_array_agent_if.gradd_n;
        //                capture_col_addr = m_array_agent_if.gcadd;

        //                capture_col_addr_q.push_back(capture_col_addr);
        //                capture_row_addr_q.push_back(capture_row_addr);

        //                //check row_addr, col_addr 
        //                if (capture_row_addr != j)
        //                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gradd_n may not correct, exp: %0h, act: %0h", j,capture_row_addr))
        //                //else
        //                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, gradd_n %0h check pass", capture_row_addr),UVM_LOW)

        //                if (capture_col_addr != i)
        //                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gcadd may not correct, exp: %0h, act: %0h",i, capture_col_addr))
        //                //else
        //                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, gcadd %0h check pass", capture_col_addr),UVM_LOW)

        //                //bist status check
        //                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_status.peek(status, bist_status);
        //                if (bist_status != 3'b010) `uvm_error("bist status", "csl check, bist_status did not be 3'b010!!")

        //            end
        //        end
        //    end

        //    begin
        //        //================== data ===================
        //        for (int i=0;i<COL_ALL_NUM;i++) begin
        //        //col + 1
        //            for (int j=(WL_NUM/5);j<(WL_NUM*2/5);j++) begin
        //                //row +1
        //                @(posedge m_array_agent_if.rdrdy_n);
        //                capture_data    = m_array_agent_if.rdl;
        //                exp_col_addr    = capture_col_addr_q.pop_front;
        //                exp_row_addr    = capture_row_addr_q.pop_front;

        //                exp_golden_data = golden_data[exp_row_addr%4];
        //                //check data 

        //                if (capture_data != exp_golden_data)
        //                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gradd_n:%0h, gcadd:%0h, exp_golden_data:%0h, act data:%0h",exp_row_addr, exp_col_addr,exp_golden_data, capture_data))
        //                //else
        //                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, pattern data check pass"),UVM_LOW)
        //            end
        //        end
        //    end
        //join
 
        //if ( (capture_row_addr_q.size()>0) || (capture_col_addr_q.size()>0) ) begin
        //    `uvm_error("pattern_check error", "csl_scan, reading, during up row scan, not read out all addr")
        //    capture_row_addr_q.delete();
        //    capture_col_addr_q.delete();
        //end

        ////------------------------------------ 3rd  row scan ---------------------------------------------------
        //fork
        ////================== addr =====================
        //    begin
        //        for (int i=0;i<COL_ALL_NUM;i++) begin
        //        //col + 1
        //            for (int j=(WL_NUM*2/5);j<(WL_NUM*3/5);j++) begin
        //                //row +1
        //                @(negedge m_array_agent_if.gcas_rd);
        //                capture_row_addr = m_array_agent_if.gradd_n;
        //                capture_col_addr = m_array_agent_if.gcadd;

        //                capture_col_addr_q.push_back(capture_col_addr);
        //                capture_row_addr_q.push_back(capture_row_addr);

        //                //check row_addr, col_addr 
        //                if (capture_row_addr != j)
        //                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gradd_n may not correct, exp: %0h, act: %0h", j,capture_row_addr))
        //                //else
        //                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, gradd_n %0h check pass", capture_row_addr),UVM_LOW)

        //                if (capture_col_addr != i)
        //                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gcadd may not correct, exp: %0h, act: %0h",i, capture_col_addr))
        //                //else
        //                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, gcadd %0h check pass", capture_col_addr),UVM_LOW)

        //                //bist status check
        //                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_status.peek(status, bist_status);
        //                if (bist_status != 3'b010) `uvm_error("bist status", "csl check, bist_status did not be 3'b010!!")

        //            end
        //        end
        //    end

        //    begin
        //        //================== data ===================
        //        for (int i=0;i<COL_ALL_NUM;i++) begin
        //        //col + 1
        //            for (int j=(WL_NUM*2/5);j<(WL_NUM*3/5);j++) begin
        //                //row +1
        //                @(posedge m_array_agent_if.rdrdy_n);
        //                capture_data    = m_array_agent_if.rdl;
        //                exp_col_addr    = capture_col_addr_q.pop_front;
        //                exp_row_addr    = capture_row_addr_q.pop_front;

        //                exp_golden_data = golden_data[exp_row_addr%4];
        //                //check data 

        //                if (capture_data != exp_golden_data)
        //                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gradd_n:%0h, gcadd:%0h, exp_golden_data:%0h, act data:%0h",exp_row_addr, exp_col_addr,exp_golden_data, capture_data))
        //                //else
        //                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, pattern data check pass"),UVM_LOW)
        //            end
        //        end
        //    end
        //join

        //if ( (capture_row_addr_q.size()>0) || (capture_col_addr_q.size()>0) ) begin
        //    `uvm_error("pattern_check error", "csl_scan, reading, during up row scan, not read out all addr")
        //    capture_row_addr_q.delete();
        //    capture_col_addr_q.delete();
        //end

        ////------------------------------------ 4th  row scan ---------------------------------------------------
        //fork
        ////================== addr =====================
        //    begin
        //        for (int i=0;i<COL_ALL_NUM;i++) begin
        //        //col + 1
        //            for (int j=(WL_NUM*3/5);j<(WL_NUM*4/5);j++) begin
        //                //row +1
        //                @(negedge m_array_agent_if.gcas_rd);
        //                capture_row_addr = m_array_agent_if.gradd_n;
        //                capture_col_addr = m_array_agent_if.gcadd;

        //                capture_col_addr_q.push_back(capture_col_addr);
        //                capture_row_addr_q.push_back(capture_row_addr);

        //                //check row_addr, col_addr 
        //                if (capture_row_addr != j)
        //                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gradd_n may not correct, exp: %0h, act: %0h", j,capture_row_addr))
        //                //else
        //                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, gradd_n %0h check pass", capture_row_addr),UVM_LOW)

        //                if (capture_col_addr != i)
        //                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gcadd may not correct, exp: %0h, act: %0h",i, capture_col_addr))
        //                //else
        //                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, gcadd %0h check pass", capture_col_addr),UVM_LOW)

        //                //bist status check
        //                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_status.peek(status, bist_status);
        //                if (bist_status != 3'b010) `uvm_error("bist status", "csl check, bist_status did not be 3'b010!!")

        //            end
        //        end
        //    end

        //    begin
        //        //================== data ===================
        //        for (int i=0;i<COL_ALL_NUM;i++) begin
        //        //col + 1
        //            for (int j=(WL_NUM*3/5);j<(WL_NUM*4/5);j++) begin
        //                //row +1
        //                @(posedge m_array_agent_if.rdrdy_n);
        //                capture_data    = m_array_agent_if.rdl;
        //                exp_col_addr    = capture_col_addr_q.pop_front;
        //                exp_row_addr    = capture_row_addr_q.pop_front;

        //                exp_golden_data = golden_data[exp_row_addr%4];
        //                //check data 

        //                if (capture_data != exp_golden_data)
        //                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gradd_n:%0h, gcadd:%0h, exp_golden_data:%0h, act data:%0h",exp_row_addr, exp_col_addr,exp_golden_data, capture_data))
        //                //else
        //                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, pattern data check pass"),UVM_LOW)
        //            end
        //        end
        //    end
        //join

        //if ( (capture_row_addr_q.size()>0) || (capture_col_addr_q.size()>0) ) begin
        //    `uvm_error("pattern_check error", "csl_scan, reading, during up row scan, not read out all addr")
        //    capture_row_addr_q.delete();
        //    capture_col_addr_q.delete();
        //end

        ////------------------------------------ 5th row scan ---------------------------------------------------
        //fork
        ////================== addr =====================
        //    begin
        //        for (int i=0;i<COL_ALL_NUM;i++) begin
        //        //col + 1
        //            for (int j=(WL_NUM*4/5);j<WL_NUM;j++) begin
        //                //row +1
        //                @(negedge m_array_agent_if.gcas_rd);
        //                capture_row_addr = m_array_agent_if.gradd_n;
        //                capture_col_addr = m_array_agent_if.gcadd;

        //                capture_col_addr_q.push_back(capture_col_addr);
        //                capture_row_addr_q.push_back(capture_row_addr);

        //                //check row_addr, col_addr 
        //                if (capture_row_addr != j)
        //                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gradd_n may not correct, exp: %0h, act: %0h", j,capture_row_addr))
        //                //else
        //                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, gradd_n %0h check pass", capture_row_addr),UVM_LOW)

        //                if (capture_col_addr != i)
        //                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gcadd may not correct, exp: %0h, act: %0h",i, capture_col_addr))
        //                //else
        //                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, gcadd %0h check pass", capture_col_addr),UVM_LOW)

        //                //bist status check
        //                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_status.peek(status, bist_status);
        //                if (bist_status != 3'b010) `uvm_error("bist status", "csl check, bist_status did not be 3'b010!!")

        //            end
        //        end
        //    end

        //    begin
        //        //================== data ===================
        //        for (int i=0;i<COL_ALL_NUM;i++) begin
        //        //col + 1
        //            for (int j=(WL_NUM*4/5);j<WL_NUM;j++) begin
        //                //row +1
        //                @(posedge m_array_agent_if.rdrdy_n);
        //                capture_data    = m_array_agent_if.rdl;
        //                exp_col_addr    = capture_col_addr_q.pop_front;
        //                exp_row_addr    = capture_row_addr_q.pop_front;

        //                exp_golden_data = golden_data[exp_row_addr%4];
        //                //check data 

        //                if (capture_data != exp_golden_data)
        //                    `uvm_error("pattern_check error",$sformatf("pattern_check error: csl_scan, reading, gradd_n:%0h, gcadd:%0h, exp_golden_data:%0h, act data:%0h",exp_row_addr, exp_col_addr,exp_golden_data, capture_data))
        //                //else
        //                //    `uvm_info("pattern_check", $sformatf("pattern_check pass: csl_scan, reading, pattern data check pass"),UVM_LOW)
        //            end
        //        end
        //    end
        //join

        //if ( (capture_row_addr_q.size()>0) || (capture_col_addr_q.size()>0) )
        //    `uvm_error("pattern_check error", "csl_scan, reading, during down row scan, not read out all addr")
    end

endtask:read_pattern_check

task mc_bist_vseq::write_pattern_check(bit [`PATTERN_WIDTH-1:0] pattern, bit scan_type);

    bit [`ARRAY_DATA_WIDTH-1:0]     golden_data[4];

    bit [`ARRAY_DATA_WIDTH-1:0]     capture_data;
    bit [`COLUMN_ADDR_WIDTH-1:0]    capture_col_addr;
    bit [`ROW_ADDR_WIDTH-1:0]       capture_row_addr;

    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_col_addr; 
    bit [`ROW_ADDR_WIDTH-1:0]       exp_row_addr;
    bit [`ARRAY_DATA_WIDTH-1:0]     exp_golden_data;

    bit [2:0]                       bist_status;

    int                             col_num;

    string scan_type_name;
    scan_type_name = scan_type? "wl_scan":"csl_scan";
    col_num        = scan_type? COL_NUM : COL_ALL_NUM;

    for(int i=0;i<4;i++) begin
        golden_data[i] = {pattern[i*8+:2], {33{pattern[i*8+:8]}}};
    end

    exp_row_addr = 'h0;
    exp_col_addr = 'h0;

    for (int i=0;i<WL_NUM;i++) begin
        //row + 1
        exp_col_addr = 'h0;
        exp_golden_data = golden_data[i%4];

        for (int j=0;j<col_num;j++) begin
            //col +1
            @(negedge m_array_agent_if.gcas_wr);
            capture_row_addr = m_array_agent_if.gradd_n;
            capture_col_addr = m_array_agent_if.gcadd;
            capture_data     = m_array_agent_if.wdl;

            //check row_addr, col_addr, data 
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
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_status.peek(status, bist_status);
            if (scan_type) begin
                if (bist_status != 3'b100) `uvm_error("bist status", "wl check, bist_status did not be 3'b100!!")
            end
            else begin
                if (bist_status != 3'b010) `uvm_error("bist status", "csl check, bist_status did not be 3'b010!!")
            end

            exp_col_addr = exp_col_addr + 1'b1;
        end

        exp_row_addr = exp_row_addr + 1'b1;
    end

endtask:write_pattern_check


`endif
