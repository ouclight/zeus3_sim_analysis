
`ifndef MC_ECC_1BIT_VSEQ
`define MC_ECC_1BIT_VSEQ
class mc_ecc_1bit_vseq extends mc_common_vseq;
    
    `uvm_object_utils(mc_ecc_1bit_vseq)

         int unsigned               mi_data_num         ;
         int unsigned               mi_inst_num         ;
    rand int unsigned               mi_repeat_num       ;
         bit [2+20-1:0]             mqb_ecc_addr[$]     ;
         bit [2+20-1:0]             mb_ecc_addr         ;
         bit [7:0]                  mqb_ecc_ce_cnt[16]  ;
         bit [7:0]                  mqb_ecc_uce_cnt[16] ;
         bit [4:0]                  mb_exist_addr       ;       //bit[4]: exist valid; bit[3:0]: queue No. if exist
    rand bit [`COL_ADDR_WIDTH-1:0]  cadd_seed           ;
    rand bit [`ROW_ADDR_WIDTH-1:0]  radd_seed           ;
    rand bit [1:0]                  bank_sel            ;
    rand bit                        mb_glb_ecc_sel      ;
    rand bit                        mb_glb_ecc_en       ;
    rand bit                        mb_reg_ecc_en       ;
    rand bit[4:0]                   mb_ecc_ce_thr       ;
    rand bit                        mb_ecc_ce_int_clr   ;
    rand bit                        mb_ecc_ce_int_mask  ;
    rand bit                        mb_ecc_uce_int_clr  ;
    rand bit                        mb_ecc_uce_int_mask ;
    rand int                        mi_ecc_1bit_pos     ;
    rand int                        mi_ecc_nbit_pos[]   ;
    rand int                        mi_ecc_nbit_num     ;

    constraint c_repeat_num {
        mi_repeat_num inside {[10:260]};
    }
    constraint c_radd {
        radd_seed inside {[0:7295]};
    }
    constraint c_ecc_en {
        `ifdef COMMON_MC
            mb_glb_ecc_sel == 0;
        `endif
        if(mb_glb_ecc_sel == 1) {
            soft mb_glb_ecc_en == 1;
        }
        else {
            soft mb_reg_ecc_en == 1;
        }
        soft mb_ecc_ce_thr  dist {[1:16]:=50, [17:]:/50};

        mi_ecc_1bit_pos     inside {[0:265]};
        mi_ecc_nbit_num     dist {2:/40, [3:5]:/30, [6:266]:/30};
        mi_ecc_nbit_pos.size    == mi_ecc_nbit_num;
        unique {mi_ecc_nbit_pos};
        foreach(mi_ecc_nbit_pos[i]){
            mi_ecc_nbit_pos[i]  inside {[0:265]};
        }
    }
    function new(string name="mc_ecc_1bit_vseq");
        super.new(name);
    endfunction
    
virtual task body();
    bit[265:0]          b_1bit_insert = 0;
    bit[265:0]          b_nbit_insert = 0;
    bit[265:0]          b_rdl_force;
    bit                 b_valid[16]     ;
    bit[31:0]           b_addr_reg[16]      ;
    bit[31:0]           b_addr_exp[16]      ;
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW)
    uvm_hdl_force("mc_tb.m_mc_subsys_top.genblk2.mc_wrapper_aux_u.mc_top_u.dram_init_wr_aux_u.row_end_addr[12:0]", 13'h001f);
    super.body();
    wait(m_tb_if.mc_dram_init_wr_finish==1);

    fork
        //====================ecc err insertion====================
        forever begin
            @(negedge m_array_agent_if.rdrdy_n);
            #0.2ns;
            assert(randomize(mi_ecc_1bit_pos));
            b_1bit_insert = 1'b1 << mi_ecc_1bit_pos;
            b_rdl_force = m_array_agent_if.rdl[265:0] ^ b_1bit_insert;
            uvm_hdl_force("mc_tb.m_mc_subsys_top.rdl", {6'h0, b_rdl_force});
            @(posedge m_array_agent_if.rdrdy_n);
            #0.2ns;
            uvm_hdl_release("mc_tb.m_mc_subsys_top.rdl");
        end
        forever begin
            @(posedge m_array_agent_if.clk);
            if(m_array_agent_if.gcas_rd) begin
                mb_ecc_addr = {m_array_agent_if.bank_sel, m_array_agent_if.gradd_n, m_array_agent_if.gcadd[6:0]};
                mb_exist_addr = func_exist_in_queue(mb_ecc_addr, mqb_ecc_addr);
                if(mb_exist_addr[4] == 0) begin
                    if(mqb_ecc_addr.size() < 16) begin
                        mqb_ecc_addr.push_back(mb_ecc_addr);
                        mqb_ecc_ce_cnt[mqb_ecc_addr.size()-1]++;
                    end
                    mi_inst_num++;
                    `uvm_info("", $sformatf("mi_inst_num: %0d", mi_inst_num), UVM_MEDIUM)
                end
                else begin
                    if(mqb_ecc_ce_cnt[mb_exist_addr[3:0]] < 8'hff) begin
                        mqb_ecc_ce_cnt[mb_exist_addr[3:0]]++;
                    end
                    `uvm_info("", $sformatf("mi_inst_num: %0d, exist_addr: %0h, ce_cnt: %0d", mi_inst_num, mb_ecc_addr, mqb_ecc_ce_cnt[mb_exist_addr[3:0]]), UVM_MEDIUM)
                end
            end
        end
        //====================intr chk====================
        forever begin
            @(posedge m_array_agent_if.rdrdy_n);
            if(mi_inst_num >= mb_ecc_ce_thr) begin
                repeat(12) @(posedge m_array_agent_if.clk);
                if(!mb_ecc_ce_int_mask) begin
                    if(!m_tb_if.ce_of_intr)
                        `uvm_error("", "ce_overflow_intr not high")
                    else
                        `uvm_info("", "ce_overflow_intr chk pass!", UVM_NONE)
                end
                else begin
                    if(m_tb_if.ce_of_intr)
                        `uvm_error("", "ce_overflow_intr set high when masked")
                    else
                        `uvm_info("", "ce_overflow_intr chk pass!", UVM_NONE)
                end
            end
        end
        //====================rresp chk====================
        forever begin
            @(posedge m_frame_agent_if.mc_rvalid);
            if(m_frame_agent_if.mc_rresp !== 2'b01)
                `uvm_error("", $sformatf("frame rresp fail! %0h", m_frame_agent_if.mc_rresp))
        end
    join_none

repeat(2) begin
    assert(randomize());
    m_frame_agent_if.performance_test_en = 0;

    //----------ecc_en----------
    m_tb_if.global_ecc_sel      = mb_glb_ecc_sel    ;
    m_tb_if.global_ecc_en       = mb_glb_ecc_en     ;
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_ecc_en.write(status, mb_reg_ecc_en, UVM_FRONTDOOR);
    mb_data = {7'b0, mb_ecc_ce_int_mask, 3'b0, 5'b0, 3'b0, mb_ecc_ce_thr, 3'b0, 1'b0, 3'b0, mb_ecc_ce_int_clr};
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_ctrl_reg.write(status, mb_data, UVM_FRONTDOOR);
    mb_data = {7'b1, mb_ecc_ce_int_mask, 3'b0, 5'b0, 3'b0, mb_ecc_ce_thr, 3'b0, 1'b0, 3'b0, mb_ecc_ce_int_clr};
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_ctrl_reg.write(status, mb_data, UVM_FRONTDOOR);

    //====================wr & rd====================
    repeat(5) begin
        assert(randomize(bank_sel, radd_seed, cadd_seed));
        //-----burst n
        for(int i=0;i<mi_repeat_num;i++)begin
            assert(m_frame_cfg.randomize with {
                    //bank_sel            == local::bank_sel; 
                    radd                == radd_seed;
                    cadd                == cadd_seed;
                    frame_rw_flag       == 1;   //1:wr 0:rd
                    //one_frame_cnt       == 9;
                    col_addr_rand_en    == 0;
                    wrap_en             == 0;
                    strb_rand_en        == 0;
                    strb                == 1;
                    rw_rand_en          == 0;
                });
            `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
            send_one_frame(m_frame_cfg);

            m_frame_cfg.frame_rw_flag = 0;
            `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
            send_one_frame(m_frame_cfg);
            mi_data_num += m_frame_cfg.one_frame_cnt;
        end            
        `uvm_info("", $sformatf("mi_data_num: %0d", mi_data_num), UVM_MEDIUM)
    end 
    #1us;
    //====================status reg chk====================
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_ctrl_reg.read(status, mb_data, UVM_FRONTDOOR);
    if(mb_data[4] != 1)
        `uvm_error("", $sformatf("ce_overflow_int fail: %0b", mb_data[0]))
    if(mb_data[20:16] != mi_inst_num && mb_data[20:16] != 5'h1f)
        `uvm_error("", $sformatf("ce_cnt fail! reg: %0d, exp: %0d", mb_data[20:16], mi_inst_num))

    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr0_reg.read(status,     b_addr_reg[0],  UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr1_reg.read(status,     b_addr_reg[1],  UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr2_reg.read(status,     b_addr_reg[2],  UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr3_reg.read(status,     b_addr_reg[3],  UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr4_reg.read(status,     b_addr_reg[4],  UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr5_reg.read(status,     b_addr_reg[5],  UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr6_reg.read(status,     b_addr_reg[6],  UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr7_reg.read(status,     b_addr_reg[7],  UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr8_reg.read(status,     b_addr_reg[8],  UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr9_reg.read(status,     b_addr_reg[9],  UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr10_reg.read(status,    b_addr_reg[10], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr11_reg.read(status,    b_addr_reg[11], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr12_reg.read(status,    b_addr_reg[12], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr13_reg.read(status,    b_addr_reg[13], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr14_reg.read(status,    b_addr_reg[14], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_addr15_reg.read(status,    b_addr_reg[15], UVM_FRONTDOOR);
    foreach(b_addr_reg[i]) begin
        if(mi_inst_num > i) begin
            b_valid[i] = 1;
            b_addr_exp[i] = {mqb_ecc_ce_cnt[i], 1'b0, b_valid[i], mqb_ecc_addr[i]};
        end
        else begin
            b_valid[i] = 0;
            b_addr_exp[i] = {mqb_ecc_ce_cnt[i], 1'b0, b_valid[i], 22'h3f_ffff};
        end
        if(b_addr_reg[i] != b_addr_exp[i])
            `uvm_error("", $sformatf("mc_ecc_ce_addr%0d fail! reg: %0h, exp: %0h", i, b_addr_reg[i], b_addr_exp[i]))
    end
    //====================intr clr chk====================
    mb_ecc_ce_int_clr = 1;
    mb_data = {7'b0, mb_ecc_ce_int_mask, 3'b0, 5'b0, 3'b0, mb_ecc_ce_thr, 3'b0, 1'b0, 3'b0, mb_ecc_ce_int_clr};
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_ecc_ce_ctrl_reg.write(status, mb_data, UVM_FRONTDOOR);
    repeat(10) @(posedge m_frame_agent_if.clk);
    if(m_tb_if.ce_of_intr)
        `uvm_error("", "ce_overflow_intr clear chk fail")
    else
        `uvm_info("", "ce_overflow_intr clear chk pass", UVM_NONE)
    mqb_ecc_addr.delete();
    mqb_ecc_ce_cnt = '{16{0}};
    mi_inst_num = 0;
    #100ns;
end

endtask
endclass
`endif
