
/* //check in trim_interface

    localparam int DELAY_CYCLES = 400000; //1ms

    //-------------------check spine_reset_n be set 1, after 1ms, dump_ready be set 1-------------------------       
    property sp_rst_set_dump_ready_0;
        @(posedge clk) $rose(m_trim_if.spine_reset_n[0])|->##DELAY_CYCLES(m_trim_if.dump_ready[0]==1'b1);
    endproperty

    dump_ready_chk_0: 
        assert property(sp_rst_set_dump_ready_0) `uvm_info("assertion_chk", $sformatf("dump_ready_chk_0 assertion_chk passed"), UVM_LOW)
        else `uvm_error("dump_ready_0_timing_chk", $sformatf("dump_ready_0 not high 1ms after spine_reset_n[0] rose at %t", $time))


    property sp_rst_set_dump_ready_1;
        @(posedge clk) $rose(m_trim_if.spine_reset_n[1])|->##DELAY_CYCLES(m_trim_if.dump_ready[1]==1'b1);
    endproperty

    dump_ready_chk_1: 
        assert property(sp_rst_set_dump_ready_1) `uvm_info("assertion_chk", $sformatf("dump_ready_chk_1 assertion_chk passed"), UVM_LOW)
        else `uvm_error("dump_ready_0_timing_chk", $sformatf("dump_ready_1 not high 1ms after spine_reset_n[1] rose at %t", $time))


    property sp_rst_set_dump_ready_2;
        @(posedge clk) $rose(m_trim_if.spine_reset_n[2])|->##DELAY_CYCLES(m_trim_if.dump_ready[2]==1'b1);
    endproperty

    dump_ready_chk_2: 
        assert property(sp_rst_set_dump_ready_2) `uvm_info("assertion_chk", $sformatf("dump_ready_chk_2 assertion_chk passed"), UVM_LOW)
        else `uvm_error("dump_ready_0_timing_chk", $sformatf("dump_ready_2 not high 1ms after spine_reset_n[2] rose at %t", $time))


    property sp_rst_set_dump_ready_3;
        @(posedge clk) $rose(m_trim_if.spine_reset_n[3])|->##DELAY_CYCLES(m_trim_if.dump_ready[3]==1'b1);
    endproperty

    dump_ready_chk_3: 
        assert property(sp_rst_set_dump_ready_3) `uvm_info("assertion_chk", $sformatf("dump_ready_chk_3 assertion_chk passed"), UVM_LOW)
        else `uvm_error("dump_ready_0_timing_chk", $sformatf("dump_ready_3 not high 1ms after spine_reset_n[3] rose at %t", $time))
*/








