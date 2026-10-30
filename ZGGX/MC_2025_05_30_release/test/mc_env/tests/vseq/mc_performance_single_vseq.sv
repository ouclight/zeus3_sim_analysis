//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_performance_single_vseq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 26 10:33:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_PERFORMANCE_SINGLE_VSEQ
`define MC_PERFORMANCE_SINGLE_VSEQ




class mc_performance_single_vseq extends mc_common_vseq;
    
    
    `uvm_object_utils(mc_performance_single_vseq)

    bit         [31:0]  mc_page_status=0; 
    rand bit            close_page_en;
    rand bit    [15:0]  one_frame_cnt_i;
    bit                 frame_rw_flag_i;
    rand bit            performance_test_en;
    rand bit            random_wr_rd;;
    rand bit    [9:0]   round_num;
    rand bit    [15:0]  row_num;
    rand bit    [9:0]   send_num;
    function new(string name="mc_performance_single_vseq");
        super.new(name);
    endfunction
    constraint row_num_c{row_num inside {[0:7295]};}; 
    constraint send_num_c{send_num inside {[100:1000]};}; 
virtual task body();
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    super.body();

    assert(randomize(close_page_en,row_num,send_num,random_wr_rd));
    `uvm_info(get_type_name(),$sformatf("close_page_en=%0d,send_num=%0d",close_page_en,send_num ),UVM_LOW)
    m_tb_if.pre_precharge = $urandom_range(0,1);
    if(close_page_en == 1)begin
        while(mc_page_status==1)begin
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
        end
        @(posedge m_tb_if.pclk);
        m_tb_if.page_mode_switch = 1'b1;
        m_tb_if.pre_precharge = 0;
    end
    #1us; 
    m_frame_agent_if.performance_test_en = 1;
    random_wr_rd=0;
    fork 
        begin
            if(random_wr_rd==1)begin
                for(int i=0;i<send_num;i++)begin
                    assert(randomize(row_num));
                    `uvm_info(get_type_name(),$sformatf("row_num=%0d",row_num ),UVM_LOW)
                    assert(m_frame_cfg.randomize with {
                        cadd                == 0;
                        radd                == row_num;
                        frame_rw_flag       == 1;   //1:wr 0:rd
                        one_frame_cnt       == 'd1;
                        col_addr_rand_en    == 1;
                        wrap_en             == 0;
                        strb_rand_en        == 0;
                        strb                == 1;
                    });
                    send_one_frame(m_frame_cfg);        
                end
            end
            else begin
                for(int i=0;i<send_num;i++)begin
                    assert(randomize(row_num));
                    assert(m_frame_cfg.randomize with {
                        cadd                == 0;
                        radd                == row_num;
                        frame_rw_flag       == 0;   //1:wr 0:rd
                        one_frame_cnt       == 'd1;
                        col_addr_rand_en    == 1;
                        wrap_en             == 0;
                    });
                    send_one_frame(m_frame_cfg);        
                end
            end
            #1us;
        end
        begin
            while(1)begin
                @(posedge m_frame_agent_if.clk);
                if(m_frame_agent_if.mc_frame_vld&&m_frame_agent_if.mc_frame_rdy&&m_frame_agent_if.mc_frame_data[288]==0)begin
                    repeat(22) @(posedge m_frame_agent_if.clk);
                    if(m_frame_agent_if.mc_rvalid!=1)begin
                        repeat(1) @(posedge m_frame_agent_if.clk);
                        if(m_frame_agent_if.mc_rvalid!=1)begin
                            `uvm_error("mc_rvalid check", "mc_rvalid not return after 23 cycle")
                        end
                    end
                    break;
                end
            end
            while(1)begin
                @(posedge m_frame_agent_if.clk);
            end
        end
        begin
            while(1)begin
                @(posedge m_frame_agent_if.clk);
                if(m_frame_agent_if.mc_frame_vld&&m_frame_agent_if.mc_frame_rdy&&m_frame_agent_if.mc_frame_data[288])begin
                    @(posedge m_frame_agent_if.clk);
                    if(m_frame_agent_if.mc_bresp_vld!=1)begin
                        `uvm_error("bresp check", "bresp not return after 1 cycle")
                    end
                end
            end
        end
    join_any


endtask




endclass


`endif
