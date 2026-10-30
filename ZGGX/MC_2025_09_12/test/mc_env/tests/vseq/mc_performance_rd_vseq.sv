
`ifndef MC_PERFORMANCE_RD_VSEQ
`define MC_PERFORMANCE_RD_VSEQ

class mc_performance_rd_vseq extends mc_common_vseq;
    
    `uvm_object_utils(mc_performance_rd_vseq)

    rand bit    [15:0]  one_frame_cnt_i;
    bit                 frame_rw_flag_i;
    rand bit            performance_test_en;
    rand bit    [9:0]   round_num;
    rand bit    [12:0]  row_num;
    rand bit            close_page_en;
    bit         [31:0]  mc_page_status=0;
    real   time_interval,time_valid,time_rvalid,time_valid_q[$],time_rvalid_q[$];
    rand bit    [7:0]   burstlength;
    bit         [7:0]   burstlength_act;
    real                exp_efficiency,act_efficiency;
    real                trcd,trp;
    real                time_bef,time_aft,cycle_record;

    function new(string name="mc_performance_rd_vseq");
        super.new(name);
    endfunction
    constraint row_num_c{row_num inside {[100:7295]};}; 
virtual task body();
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    `uvm_info(get_type_name(),$sformatf("row_num=%0d",row_num),UVM_LOW);
    super.body();
    assert(randomize());

    m_tb_if.pre_precharge = $urandom_range(0,1);
    if(close_page_en == 1)begin
        while(mc_page_status==1)begin
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
        end
        @(posedge m_tb_if.pclk);
        m_tb_if.page_mode_switch = 1'b1;
        m_tb_if.pre_precharge = 0;
    end
    m_frame_agent_if.performance_test_en = 1;
    wait(m_tb_if.mc_dram_init_wr_finish==1);
    trcd = 6;
    trp = 5;

    fork
        begin
            for(int i=0;i<row_num;i++)begin
                assert(m_frame_cfg.randomize with {
                    cadd                == 0;
                    radd                == i;
                    frame_rw_flag       == 0;   //1:wr 0:rd
                    one_frame_cnt       == 'd128;
                    col_addr_rand_en    == 0;
                    wrap_en             == 0;
                    strb_rand_en        == 0;
                    strb                == 1;
                });
                send_one_frame(m_frame_cfg);     
            end 
            while(time_rvalid_q.size!== row_num*128) @(posedge m_tb_if.clk);
        end
        while(1)begin
            @(posedge m_tb_if.clk);
            while((m_frame_agent_if.mc_frame_vld&&m_frame_agent_if.mc_frame_rdy)!==1'b1)begin
                @(posedge m_tb_if.clk);
            end
            time_valid=$realtime;
            time_valid_q.push_back(time_valid);
            //`uvm_info(get_type_name(),"time_valid===========",UVM_LOW);
        end
        while(1)begin
            @(posedge m_tb_if.clk);
            while(m_frame_agent_if.mc_rvalid!==1'b1)begin
                @(posedge m_tb_if.clk);
            end
            time_rvalid=$realtime;
            time_rvalid_q.push_back(time_rvalid);
            //`uvm_info(get_type_name(),"time_rvalid===========",UVM_LOW);
        end
        begin
            #20ns;
            while(1)begin
                burstlength_act = 128;
                while(&m_array_agent_if.bnksel_n) @(posedge m_tb_if.clk);
                time_bef=$realtime;
                while(!(&m_array_agent_if.bnksel_n)) @(posedge m_tb_if.clk);
                time_aft=$realtime;
                cycle_record=(time_aft-time_bef)/2.5;
                exp_efficiency = burstlength_act/(burstlength_act+trcd+trp);
                act_efficiency = burstlength_act/(cycle_record+trp);
                if((`ABS(act_efficiency-exp_efficiency))>0.01) `uvm_error("efficiency error", $sformatf("act_efficiency=%0f,exp_efficiency=%0f,burstlength=%0d,cycle_record=%0f,time_aft=%0t,time_bef=%0t",act_efficiency,exp_efficiency,burstlength_act,cycle_record,time_aft,time_bef))
            end
        end
    join_any
    disable fork;
    if(time_valid_q.size!==time_rvalid_q.size) `uvm_error(get_type_name(),$sformatf("size diff error,time_rvalid_q_size=%0d,time_valid_q_size=%0d",time_rvalid_q.size,time_valid_q.size));
   
    for(int i=0;i<row_num*128;i++)begin
        time_rvalid=time_rvalid_q[i];
        time_valid=time_valid_q[i];
        if((i%128)===0) `uvm_info(get_type_name(),$sformatf("dont't check %0d,time_rvalid=%0t,time_valid=%0t",i,time_rvalid_q[i],time_valid_q[i]),UVM_LOW)
        else begin
            time_interval = time_rvalid - time_valid;
            if(time_interval > 46) `uvm_error(get_type_name(),$sformatf("rvalid time error,act=%0t,time_rvalid=%0t,time_valid=%0t",time_interval,time_rvalid,time_valid));
        end
    end
endtask
endclass
`endif
