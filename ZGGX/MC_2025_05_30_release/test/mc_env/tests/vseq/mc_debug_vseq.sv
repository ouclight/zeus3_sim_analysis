//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_debug_vseq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 28 15:01:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_DEBUG_VSEQ
`define MC_DEBUG_VSEQ

class mc_debug_vseq extends mc_common_vseq;
    
    rand bit    [15:0]  one_frame_cnt_i ;
    rand bit    [3:0]   burst_cnt_i     ;
    bit                 frame_rw_flag_i ;
    rand bit    [`COL_ADDR_WIDTH-1:0]   cadd_i          ;
    rand bit    [`ROW_ADDR_WIDTH-1:0]  radd_i          ;
    bit         [5:0]   test_cnt        ;
    bit         [31:0]   read_data=0        ;
    rand bit            enable          ;
    mc_frame_seq_cfg    m_frame_seq_w_q[$];
    mc_frame_seq_cfg    m_frame_seq_r_q[$];
    `uvm_object_utils(mc_debug_vseq)

    function new(string name="mc_debug_vseq");
        super.new(name);
    endfunction
    

virtual task body();
    super.body();
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
     
    m_tb_if.debug_test_en = 1;
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_debug_en.write(status,1'b1, UVM_FRONTDOOR);
    #100ns;
    test_cnt = 'd1;
    randomize(enable);
    m_frame_agent_if.performance_test_en = enable;

    for(int j=0;j<test_cnt;j++)begin
        m_frame_seq_w_q.delete();
        m_frame_seq_r_q.delete();        
        randomize(burst_cnt_i) with {burst_cnt_i inside{[1:8]};};
        `uvm_info(get_full_name(),$sformatf("burst_cnt_i = %0d",burst_cnt_i),UVM_LOW);
        for(int i=0;i<burst_cnt_i;i++)begin
            randomize(cadd_i) with {cadd_i inside{[0:127]};};
            randomize(radd_i) with {radd_i inside{[0:7295]};};
            assert(m_frame_cfg.randomize with {
                cadd                == cadd_i;
                radd                == radd_i;
                frame_rw_flag       == 1;   //1:wr 0:rd
                one_frame_cnt       == 1;
            });
            `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
            m_frame_seq_w_q.push_back(m_frame_cfg);
            m_frame_cfg = mc_frame_seq_cfg::type_id::create("m_frame_cfg");

            assert(m_frame_cfg.randomize with {
                cadd                == cadd_i;
                radd                == radd_i;
                frame_rw_flag       == 0;   //1:wr 0:rd
                one_frame_cnt       == 1;
            });
            `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
            m_frame_seq_r_q.push_back(m_frame_cfg);
            m_frame_cfg = mc_frame_seq_cfg::type_id::create("m_frame_cfg");
        end
        send_multi_frame(m_frame_seq_w_q);
        send_multi_frame(m_frame_seq_r_q);
    end        
    
        

    `uvm_info(get_type_name(),"body=====apb_write======start===========",UVM_LOW);
    #1us; 
    @(posedge m_tb_if.clk);
    m_tb_if.ras_clr=1;
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_frame2array_dbg_reg.read(status, read_data, UVM_FRONTDOOR);
    #1us; 
    if(read_data!=0)begin
        `uvm_error("dbg reg check fail", $sformatf("read is %0d",read_data))
    end
    m_tb_if.debug_test_en = 0;
    #1us; 
    
endtask


endclass


`endif
