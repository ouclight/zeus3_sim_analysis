`ifndef TRIM_RESET_TEST_SV
`define TRIM_RESET_TEST_SV


class trim_reset_test extends trim_base_test;
    `uvm_component_utils(trim_reset_test)

    trim_soft_vseq      m_soft_seq;
    trim_hard_vseq      m_hard_seq;

    bit [3:0]   dump_ready_st;
    bit         last_seq_sel; //add 0818

    //bit         second_reset_flag = 0;
    rand bit    seq_sel;
    rand int    wait_time = 1;
    rand int    reset_time = 1000, reset_time_hold = 500;

    constraint c_rst_time{
        wait_time inside {[1000:20000]};
        reset_time inside {[1000:50000]};
        reset_time_hold dist {[500:1000]:/90};
    }

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        super.m_env_config.scb_en = 0;

        m_soft_seq = trim_soft_vseq::type_id::create("m_soft_seq", this);
        m_hard_seq = trim_hard_vseq::type_id::create("m_hard_seq", this);
    endfunction

    task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
            super.reset_phase(phase);
            `uvm_info("trim_reset_test", $sformatf("--------Test enter reset phase--------"), UVM_LOW)
            #1ps;
            @(posedge m_trim_if.clk);
            reset_check();
            init();
            if(m_trim_if.second_reset_flag == 1)begin
                assert(randomize(reset_time_hold));
                `uvm_info("trim_reset_test", $sformatf("reset_time_hold = %0d", reset_time_hold), UVM_LOW)
                repeat(reset_time_hold)@(posedge m_trim_if.clk);
                uvm_hdl_force("trim_tb.rst_n", 1'b1);
                uvm_hdl_force("trim_tb.prst_n", 1'b1);
                uvm_hdl_release("trim_tb.rst_n");
                uvm_hdl_release("trim_tb.prst_n");
                //0815//m_trim_if.have_reset_flag = 1;
            end
        phase.drop_objection(this);
    endtask

    task main_phase(uvm_phase phase);
        phase.raise_objection(this);
            super.main_phase(phase);
            //0728//seq.start(vseqr);
            `uvm_info("trim_reset_test", $sformatf("---------Enter trim_reset_test main_phase----------"), UVM_LOW)
            assert(randomize(seq_sel, wait_time, reset_time));
            //seq_sel = 0; //for debug
            `uvm_info("trim_reset_test", $sformatf("seq_sel = %0d, wait_time = %0d, reset_time = %0d", seq_sel, wait_time, reset_time), UVM_LOW)

            if(m_trim_if.second_reset_flag == 0)begin
                last_seq_sel = seq_sel; //add 0818
                fork
                begin
                    fork 
                        begin
                            //0813//fork
                            //0813//    begin
                                    if(seq_sel==1)begin
                                        #2ms; //wait init
                                        repeat(wait_time) #1us;
                                        repeat(reset_time)@(posedge m_trim_if.clk);
                                    end
                                    else begin
                                        `ifdef DRAM_6
                                        wait(m_trim_if.spine_reset_n == 6'h3f);
                                        `else
                                        wait(m_trim_if.spine_reset_n == 4'hf);
                                        `endif
                                        repeat(reset_time)@(posedge m_trim_if.clk);
                                    end
                            //0813//    end
                                //0811//begin
                                //0811//    wait(m_trim_if.fsm_cs=='d2);
                                //0811//end
                            //0813//    begin
                                    //wait dump_ready is high, then reset:
                                    //0819//dump_ready_st = 'h0;
                                    //0819//for(int jj=0; jj<4; jj++)begin
                                    //0819//    fork
                                    //0819//        automatic int kk=jj;
                                    //0819//        if(m_trim_if.dram_layer_cfg[kk]==1)begin
                                    //0819//            while(dump_ready_st[kk]==0)begin
                                    //0819//                @(posedge m_trim_if.clk);
                                    //0819//                uvm_hdl_read("trim_tb.u_dram_trim_top.apb2reg_dram_trim_cfg_if_u.dump_ready_apb_dff", dump_ready_st);
                                    //0819//            end
                                    //0819//        end
                                    //0819//    join_none
                                    //0819//end
                                    //0819//wait fork;
                                    dump_ready_st = 'h0;
                                    while(m_trim_if.dram_layer_cfg!=dump_ready_st)begin
                                        @(posedge m_trim_if.clk);
                                        uvm_hdl_read("trim_tb.u_dram_trim_top.apb2reg_dram_trim_cfg_if_u.dump_ready_apb_dff", dump_ready_st);
                                    end
                                    `uvm_info("trim_reset_test", $sformatf("----------have wait dump_ready is high----------"), UVM_LOW)

                                    wait(m_apb_if.psel[0]==0); //add 0818
                            //0813//    end
                            //0813//join
                        end
                        begin
                            if(seq_sel == 1)begin
                                m_soft_seq.start(vseqr);
                            end
                            else begin
                                m_hard_seq.start(vseqr);
                            end
                        end
                    join_any
                    disable fork;
                    m_trim_if.second_reset_flag = 1;
                    //`uvm_info("DEBUG", $sformatf("----------have wait dump_ready is high-----------"), UVM_LOW)

                    //0818//uvm_hdl_force("trim_tb.rst_n", 1'b0);
                    //0818//uvm_hdl_force("trim_tb.prst_n", 1'b0);
                    
                    `uvm_info("DEBUG", $sformatf("----------debug1-----------"), UVM_LOW)
                    vseqr.stop_sequences();
                    m_env.m_svt_apb_env.master.sequencer.stop_sequences();
                    regmodel.reset();
                    //0819//#100ps;
                    `uvm_info("DEBUG", $sformatf("----------debug2-----------"), UVM_LOW)

                    uvm_hdl_force("trim_tb.rst_n", 1'b0);
                    uvm_hdl_force("trim_tb.prst_n", 1'b0);

                    `uvm_info("DEBUG", $sformatf("----------debug3-----------"), UVM_LOW)
                    //0815//if(seq_sel == 1)begin
                    //0815//    m_soft_seq.kill();
                    //0815//end
                    //0815//else begin
                    //0815//    m_hard_seq.kill();
                    //0815//end

                    `uvm_info("DEBUG", $sformatf("----------debug4-----------"), UVM_LOW)
                end
                    //---------------0728---------------start
                    //0815//@(posedge m_trim_if.clk);
                    //0815//reset_check();
                    //0815//init();

                    //0815////`uvm_info("DEBUG", $sformatf("----------debug4-----------"), UVM_LOW)
                    //0815//assert(randomize(reset_time_hold));
                    //0815//`uvm_info("trim_reset_test", $sformatf("reset_time_hold = %0d", reset_time_hold), UVM_LOW)
                    //0815//repeat(reset_time_hold)@(posedge m_trim_if.clk);
                    //0815//uvm_hdl_force("trim_tb.rst_n", 1'b1);
                    //0815//uvm_hdl_force("trim_tb.prst_n", 1'b1);
                    //0815//uvm_hdl_release("trim_tb.rst_n");
                    //0815//uvm_hdl_release("trim_tb.prst_n");
                    //---------------0728---------------end
                begin
                    @(negedge m_trim_if.rst_n);
                    phase.jump(uvm_reset_phase::get());
                end
                join
            end

            `uvm_info("trim_reset_test", $sformatf("sedond start: seq_sel = %0d", seq_sel), UVM_LOW)
            seq_sel = last_seq_sel; //add 0818
            if(seq_sel == 1)begin
                fork
                    begin
                        m_soft_seq.start(vseqr);
                    end
                    begin
                        `ifdef DRAM_6
                        wait(m_trim_if.spine_reset_n == 6'h3f);
                        `else
                        wait(m_trim_if.spine_reset_n == 4'hf);
                        `endif
                        m_trim_if.have_reset_flag = 1; //0729
                        repeat(10)@(posedge m_trim_if.clk);
                        m_trim_if.second_reset_flag = 0;
                    end
                join
            end
            else begin
                fork
                    begin
                        m_hard_seq.start(vseqr);
                    end
                    begin
                        `ifdef DRAM_6
                        wait(m_trim_if.spine_reset_n == 6'h3f);
                        `else
                        wait(m_trim_if.spine_reset_n == 4'hf);
                        `endif
                        m_trim_if.have_reset_flag = 1; //0729
                        repeat(10)@(posedge m_trim_if.clk);
                        m_trim_if.second_reset_flag = 0;
                    end
                join
            end

        phase.drop_objection(this);
    endtask

endclass
`endif //TRIM_RESET_TEST_SV
