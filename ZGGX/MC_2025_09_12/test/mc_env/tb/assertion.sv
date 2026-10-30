arbiter_valid_one_hot_check:
    assert property(
        @(posedge u_tb_if.clk)  (u_tb_if.arb_s_valid_i == 6'b00_0000)||(u_tb_if.arb_s_valid_i == 6'b00_0001)||(u_tb_if.arb_s_valid_i == 6'b00_0010)||(u_tb_if.arb_s_valid_i == 6'b00_0100)||(u_tb_if.arb_s_valid_i == 6'b00_1000)||(u_tb_if.arb_s_valid_i == 6'b01_0000)||(u_tb_if.arb_s_valid_i == 6'b10_0000))
        else    `uvm_error("arb check", $sformatf("arbiter_valid_one_hot_check err, valid in is %6b", u_tb_if.arb_s_valid_i))

/********************kill begin******************** //{{{
assert_wdl_271_266:
    assert property(
        @(posedge u_tb_if.clk)
        m_array_agent_if.wdl[271:266]   === 6'b0)
    else    `uvm_error("", $sformatf("wdl[271:266]: %0h !== 6'h0", m_array_agent_if.wdl[271:266]))
********************kill end********************/   //}}}

logic       [49:0]          b_chk_mon;
assign  #1  b_chk_mon[33]   = u_tb_if.monitor_signals[33] ^ m_frame_agent_if.mc_frame_data[297] ;
assign  #1  b_chk_mon[32]   = u_tb_if.monitor_signals[32] ^ m_frame_agent_if.mc_frame_data[296] ;
assign  #1  b_chk_mon[31]   = u_tb_if.monitor_signals[31] ^ m_frame_agent_if.mc_frame_data[1]   ;
assign  #1  b_chk_mon[30]   = u_tb_if.monitor_signals[30] ^ m_frame_agent_if.mc_frame_data[0]   ;
assign  #1  b_chk_mon[29]   = u_tb_if.monitor_signals[29] ^ m_frame_agent_if.mc_frame_rdy       ;
assign  #1  b_chk_mon[28]   = u_tb_if.monitor_signals[28] ^ m_frame_agent_if.mc_frame_vld       ;//debug mode:mc_frame_vld(0)
assign  #1  b_chk_mon[27]   = u_tb_if.monitor_signals[27] ^ u_tb_if.mon_mc_rdata[1]             ;
assign  #1  b_chk_mon[26]   = u_tb_if.monitor_signals[26] ^ u_tb_if.mon_mc_rdata[0]             ;
assign  #1  b_chk_mon[25]   = u_tb_if.monitor_signals[25] ^ u_tb_if.mon_mc_rvalid               ;
assign  #1  b_chk_mon[24]   = u_tb_if.monitor_signals[24] ^ m_array_agent_if.bnksel_n[3]        ;
assign  #1  b_chk_mon[23]   = u_tb_if.monitor_signals[23] ^ m_array_agent_if.bnksel_n[2]        ;
assign  #1  b_chk_mon[22]   = u_tb_if.monitor_signals[22] ^ m_array_agent_if.bnksel_n[1]        ;
assign  #1  b_chk_mon[21]   = u_tb_if.monitor_signals[21] ^ m_array_agent_if.bnksel_n[0]        ;
assign  #1  b_chk_mon[20]   = u_tb_if.monitor_signals[20] ^ m_array_agent_if.gradd_n[1]         ;
assign  #1  b_chk_mon[19]   = u_tb_if.monitor_signals[19] ^ m_array_agent_if.gradd_n[0]         ;
assign  #1  b_chk_mon[18]   = u_tb_if.monitor_signals[18] ^ m_array_agent_if.gcas_wr[3]         ;
assign  #1  b_chk_mon[17]   = u_tb_if.monitor_signals[17] ^ m_array_agent_if.gcas_wr[2]         ;
assign  #1  b_chk_mon[16]   = u_tb_if.monitor_signals[16] ^ m_array_agent_if.gcas_wr[1]         ;
assign  #1  b_chk_mon[15]   = u_tb_if.monitor_signals[15] ^ m_array_agent_if.gcas_wr[0]         ;
assign  #1  b_chk_mon[14]   = u_tb_if.monitor_signals[14] ^ m_array_agent_if.gcas_rd[3]         ;
assign  #1  b_chk_mon[13]   = u_tb_if.monitor_signals[13] ^ m_array_agent_if.gcas_rd[2]         ;
assign  #1  b_chk_mon[12]   = u_tb_if.monitor_signals[12] ^ m_array_agent_if.gcas_rd[1]         ;
assign  #1  b_chk_mon[11]   = u_tb_if.monitor_signals[11] ^ m_array_agent_if.gcas_rd[0]         ;
assign  #1  b_chk_mon[10]   = u_tb_if.monitor_signals[10] ^ m_array_agent_if.gcadd[1]           ;
assign  #1  b_chk_mon[ 9]   = u_tb_if.monitor_signals[ 9] ^ m_array_agent_if.gcadd[0]           ;
assign  #1  b_chk_mon[ 8]   = u_tb_if.monitor_signals[ 8] ^ m_array_agent_if.wdl[1]             ;
assign  #1  b_chk_mon[ 7]   = u_tb_if.monitor_signals[ 7] ^ m_array_agent_if.wdl[0]             ;
assign  #1  b_chk_mon[ 6]   = u_tb_if.monitor_signals[ 6] ^ m_array_agent_if.wdl_oe             ;
assign  #1  b_chk_mon[ 5]   = u_tb_if.monitor_signals[ 5] ^ u_tb_if.mc_rf_start                 ;
assign  #1  b_chk_mon[ 4]   = u_tb_if.monitor_signals[ 4] ^ u_tb_if.global_rf_sel_en            ;
assign  #1  b_chk_mon[ 3]   = u_tb_if.monitor_signals[ 3] ^ u_tb_if.global_rf_sel               ;
assign  #1  b_chk_mon[ 2]   = u_tb_if.monitor_signals[ 2] ^ u_tb_if.mc_rf_cfg_sel_o             ;
assign  #1  b_chk_mon[ 1]   = u_tb_if.monitor_signals[ 1] ^ m_array_agent_if.rdrdy_n            ;
assign  #1  b_chk_mon[ 0]   = u_tb_if.monitor_signals[ 0] ^ u_tb_if.mc_en_o                     ;

always @(posedge b_chk_mon[33]) if(b_chk_mon[33] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[33] fail!"))
always @(posedge b_chk_mon[32]) if(b_chk_mon[32] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[32] fail!"))
always @(posedge b_chk_mon[31]) if(b_chk_mon[31] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[31] fail!"))
always @(posedge b_chk_mon[30]) if(b_chk_mon[30] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[30] fail!"))
always @(posedge b_chk_mon[29]) if(b_chk_mon[29] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[29] fail!"))
always @(posedge b_chk_mon[28]) if(b_chk_mon[28] !== 1'bx && (u_tb_if.debug_test_en === 0)) `uvm_error("", $sformatf("b_chk_mon[28] fail!"))
always @(posedge b_chk_mon[27]) if(b_chk_mon[27] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[27] fail!"))
always @(posedge b_chk_mon[26]) if(b_chk_mon[26] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[26] fail!"))
always @(posedge b_chk_mon[25]) if(b_chk_mon[25] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[25] fail!"))
always @(posedge b_chk_mon[24]) if(b_chk_mon[24] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[24] fail!"))
always @(posedge b_chk_mon[23]) if(b_chk_mon[23] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[23] fail!"))
always @(posedge b_chk_mon[22]) if(b_chk_mon[22] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[22] fail!"))
always @(posedge b_chk_mon[21]) if(b_chk_mon[21] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[21] fail!"))
always @(posedge b_chk_mon[20]) if(b_chk_mon[20] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[20] fail!"))
always @(posedge b_chk_mon[19]) if(b_chk_mon[19] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[19] fail!"))
always @(posedge b_chk_mon[18]) if(b_chk_mon[18] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[18] fail!"))
always @(posedge b_chk_mon[17]) if(b_chk_mon[17] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[17] fail!"))
always @(posedge b_chk_mon[16]) if(b_chk_mon[16] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[16] fail!"))
always @(posedge b_chk_mon[15]) if(b_chk_mon[15] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[15] fail!"))
always @(posedge b_chk_mon[14]) if(b_chk_mon[14] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[14] fail!"))
always @(posedge b_chk_mon[13]) if(b_chk_mon[13] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[13] fail!"))
always @(posedge b_chk_mon[12]) if(b_chk_mon[12] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[12] fail!"))
always @(posedge b_chk_mon[11]) if(b_chk_mon[11] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[11] fail!"))
always @(posedge b_chk_mon[10]) if(b_chk_mon[10] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[10] fail!"))
always @(posedge b_chk_mon[ 9]) if(b_chk_mon[ 9] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[ 9] fail!"))
always @(posedge b_chk_mon[ 8]) if(b_chk_mon[ 8] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[ 8] fail!"))
always @(posedge b_chk_mon[ 7]) if(b_chk_mon[ 7] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[ 7] fail!"))
always @(posedge b_chk_mon[ 6]) if(b_chk_mon[ 6] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[ 6] fail!"))
always @(posedge b_chk_mon[ 5]) if(b_chk_mon[ 5] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[ 5] fail!"))
always @(posedge b_chk_mon[ 4]) if(b_chk_mon[ 4] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[ 4] fail!"))
always @(posedge b_chk_mon[ 3]) if(b_chk_mon[ 3] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[ 3] fail!"))
always @(posedge b_chk_mon[ 2]) if(b_chk_mon[ 2] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[ 2] fail!"))
always @(posedge b_chk_mon[ 1]) if(b_chk_mon[ 1] !== 1'bx && (!u_tb_if.loopback_en)) `uvm_error("", $sformatf("b_chk_mon[ 1] fail!"))
always @(posedge b_chk_mon[ 0]) if(b_chk_mon[ 0] !== 1'bx) `uvm_error("", $sformatf("b_chk_mon[ 0] fail!"))
