arbiter_valid_one_hot_check:
    assert property(
        @(posedge u_tb_if.clk)  (u_tb_if.arb_s_valid_i == 6'b00_0000)||(u_tb_if.arb_s_valid_i == 6'b00_0001)||(u_tb_if.arb_s_valid_i == 6'b00_0010)||(u_tb_if.arb_s_valid_i == 6'b00_0100)||(u_tb_if.arb_s_valid_i == 6'b00_1000)||(u_tb_if.arb_s_valid_i == 6'b01_0000)||(u_tb_if.arb_s_valid_i == 6'b10_0000))
        else    `uvm_error("arb check", $sformatf("arbiter_valid_one_hot_check err, valid in is %6b", u_tb_if.arb_s_valid_i))

assert_wdl_271_266:
    assert property(
        @(posedge u_tb_if.clk)
        m_array_agent_if.wdl[271:266]   === 6'b0)
    else    `uvm_error("", $sformatf("wdl[271:266]: %0h !=== 6'h0", m_array_agent_if.wdl[271:266]))
