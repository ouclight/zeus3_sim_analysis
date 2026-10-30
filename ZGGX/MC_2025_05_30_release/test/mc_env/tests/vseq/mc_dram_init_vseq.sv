`ifndef MC_DRAM_INIT_VSEQ
`define MC_DRAM_INIT_VSEQ

class mc_dram_init_vseq extends mc_common_vseq;
    
    
    `uvm_object_utils(mc_dram_init_vseq)

    int master_num         ;
    int base_addr          ;
    bit[31:0] offset_addr        ;
    bit[31:0] wdata              ;
    bit[31:0] rdata              ;
    bit[31:0] clk_num              ;
    bit [`COL_ADDR_WIDTH:0] c_addr=0;
    bit [`ROW_ADDR_WIDTH-1:0] r_addr=0;
    rand bit [`COL_ADDR_WIDTH-1:0] cadd_seed;
    rand bit [`ROW_ADDR_WIDTH-1:0] radd_seed;
    rand bit [9:0] num_seed;
    int delay=0;
    rand bit    [6:0]                   wl_pattern_num; 
    rand bit    [4:0]               csl_err_th;
    rand bit    [3:0]               wl_scan_cnt;
    rand bit [`PATTERN_WIDTH-1:0]   bist_pattern[64];
    rand bit    [6:0]                   csl_pattern_num; 
    bit [31:0] read_data=0;
    bit [31:0] read_data1=0;
    bit finish_check=0;
    bit start_time_check=0;
    bit start_addr_check=0;
    bit end_addr_check=0;
    constraint wl_pattern_num_c {wl_pattern_num dist {[1:10]:/90,[11:31]:/9,[32:64]:/1};}
    constraint csl_pattern_num_c {csl_pattern_num dist {[1:10]:/90,[11:31]:/9,[32:64]:/1};}
    constraint csl_err_th_c {csl_err_th dist{[1:1]:/20,[2:15]:/20,[16:16]:/20,[17:30]:/20,[31:31]:/20};};
    constraint radd_c {radd_seed inside {[0:7295]};}
    //constraint radd_c {radd_seed inside {[0:127]};}
    function new(string name="mc_dram_init_vseq");
        super.new(name);
    endfunction

virtual task body();
    super.body();
    assert(randomize());
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);

    fork
        begin
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
        end
        begin
            while(m_tb_if.mc_dram_init_wr_finish!=1)begin
                @(negedge m_array_agent_if.clk);
                if(m_array_agent_if.gcas_wr == 1)begin
                    if(m_array_agent_if.gradd_n != r_addr)begin
                        if(m_array_agent_if.gcadd != c_addr)begin
                            `uvm_error("init fail", $sformatf("r_addr act is %0d,exp is %0d,c_addr act is %0d,exp is %0d",m_array_agent_if.gradd_n,r_addr,m_array_agent_if.gcadd,c_addr ))
                        end
                    end
                    if(c_addr < 128)begin
                        c_addr++;
                        //`uvm_info(get_type_name(),$sformatf("c_addr =%0d",c_addr),UVM_LOW);
                    end
                    if(c_addr==128)begin
                        r_addr++;
                        c_addr=0;
                    end
                end
            end
        end
        begin
            while(finish_check==0)begin
                @(posedge m_array_agent_if.clk);
                if(m_array_agent_if.gcas_wr == 1)begin
                    if(m_array_agent_if.gradd_n == 7295&&m_array_agent_if.gcadd==127)begin
                        if(m_tb_if.mc_dram_init_wr_finish!=1)begin
                            `uvm_error("init fail", $sformatf("r_addr act is %0d,exp is %0d,c_addr act is %0d,exp is %0d",m_array_agent_if.gradd_n,r_addr,m_array_agent_if.gcadd,c_addr ))
                        end
                        finish_check=1;
                    end
                    else begin
                        if(m_tb_if.mc_dram_init_wr_finish==1)begin
                            `uvm_error("init fail", $sformatf("r_addr act is %0d,exp is %0d,c_addr act is %0d,exp is %0d",m_array_agent_if.gradd_n,r_addr,m_array_agent_if.gcadd,c_addr ))
                        end
                    end
                end
            end
        end
        begin
            randcase
                1:begin
                    `uvm_info(get_type_name(),"dram_init_wr_rd",UVM_LOW);
                    delay = $urandom_range(100,1000);
                    repeat(delay) @(posedge m_tb_if.clk);
                    for(int j=0;j<7296;j++)begin//burst 128
                        assert(m_frame_cfg.randomize with {
                                cadd                == 0;
                                radd                == j;
                                frame_rw_flag       == 0;   //1:wr 0:rd
                                one_frame_cnt       == 'd128;
                                col_addr_rand_en    == 0;
                                wrap_en             == 0;
                                strb_rand_en        == 0;
                                strb                == 1;
                            });
                        //`uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                        
                        send_one_frame(m_frame_cfg);
                    end   
                    #1us;
                end
                1:begin
                    `uvm_info(get_type_name(),"dram_init_wr_rd",UVM_LOW);
                    delay = $urandom_range(100,1000);
                    repeat(delay) @(posedge m_tb_if.clk);
                    for(int j=0;j<7296;j++)begin//burst 128
                        assert(m_frame_cfg.randomize with {
                                cadd                == 0;
                                radd                == j;
                                frame_rw_flag       == 1;   //1:wr 0:rd
                                one_frame_cnt       == 'd128;
                                col_addr_rand_en    == 0;
                                wrap_en             == 0;
                                strb_rand_en        == 0;
                                strb                == 1;
                            });
                        //`uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                        
                        send_one_frame(m_frame_cfg);
                    end   
                    #1us;
                end
                1:begin
                    `uvm_info(get_type_name(),"dram_init_bist_scan",UVM_LOW);
                    delay = $urandom_range(100,1000);
                    foreach (bist_pattern[j]) begin
                        m_tb_if.bist_pattern[j] = bist_pattern[j];
                        $display("bist_pattern%0d is %0h", j, m_tb_if.bist_pattern[j]);
                    end
                    repeat(delay) @(posedge m_tb_if.clk);
                    m_tb_if.bist_test_en = 1;
                    m_tb_if.mc_scan_timeout_en=1;
                    m_tb_if.bist_csl_scan_num   =   csl_pattern_num;
                    m_tb_if.bist_wl_scan_num    =   wl_pattern_num;
                    m_tb_if.csl_err_threshold   =   csl_err_th;
                    m_tb_if.global_mc_bist_en   =   1;
                    //m_tb_if.bist_wl_scan_single_pattern_rd_num=wl_scan_cnt;
                    m_tb_if.bist_wl_scan_single_pattern_rd_num=0;
                    @(posedge m_tb_if.pclk);
                    m_tb_if.global_mc_bist_start=   1;
                    @(posedge m_tb_if.pclk);
                    m_tb_if.global_mc_bist_start=   0;
                    while(read_data==0)begin
                        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_reg.read(status, read_data, UVM_FRONTDOOR);
                    end
                    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_bank_success",read_data1);
                    if(read_data1!=1)begin
                        `uvm_error("bist_csl_wl", "bist scan fail")
                    end
                    #1us;                    
                    /*assert(randomize(num_seed));
                    `uvm_info(get_type_name(),$sformatf("num_seed =%0d ",num_seed),UVM_LOW);
                    for(int i=0;i<num_seed;i++)begin
                        `uvm_info(get_type_name(),$sformatf("i =%0d ",i),UVM_LOW);
                        assert(randomize(radd_seed));
                        assert(m_frame_cfg.randomize with {
                            cadd                == 0;
                            radd                == radd_seed;
                            frame_rw_flag       == 1;   //1:wr 0:rd
                            one_frame_cnt       == 'd128;
                            col_addr_rand_en    == 0;
                            wrap_en             == 0;
                            strb_rand_en        == 0;
                            strb                == 1;
                        });
                        send_one_frame(m_frame_cfg);        
                        assert(m_frame_cfg.randomize with {
                            cadd                == 0;
                            radd                == radd_seed;
                            frame_rw_flag       == 0;   //1:wr 0:rd
                            one_frame_cnt       == 'd128;
                            col_addr_rand_en    == 0;
                            wrap_en             == 0;

                        });
                        send_one_frame(m_frame_cfg);        
                    end
                    #1us;*/                    
                end
                1:begin
                    `uvm_info(get_type_name(),"dram_init_refresh",UVM_LOW);
                    delay = $urandom_range(100,1000);
                    repeat(delay) @(posedge m_tb_if.pclk);
                    m_tb_if.mc_rf_period_sel=0;//0:interface, 1:mc_local
                    @(posedge m_tb_if.clk);
                    m_tb_if.mc_rf_start=1;
                    fork
                        begin
                        while(end_addr_check==0)begin//end addr check
                                @(posedge m_tb_if.clk);
                                if(m_tb_if.fsm==5'b110)begin
                                    @(posedge m_tb_if.clk);
                                    if(m_tb_if.fsm == 0)begin
                                        `uvm_info(get_type_name(),"last addr",UVM_LOW);
                                        if(m_tb_if.gradd_n != 13'h1cbf)begin
                                            `uvm_error(get_full_name(), $sformatf("end addr failed, now is %0h",m_tb_if.gradd_n))
                                        end
                                        end_addr_check=1;
                                    end
                                end
                            end
                        end
                        begin
                            while(start_time_check==0)begin//start_time check
                                wait(m_tb_if.mc_rf_start);
                                @(posedge m_tb_if.clk);
                                if(m_tb_if.rf_cnt==0)begin
                                    `uvm_info(get_type_name(),"rf_cnt==start_time",UVM_LOW);
                                    @(posedge m_tb_if.clk);
                                    if(m_tb_if.rf_request != 1)begin
                                        `uvm_error(get_full_name(), $sformatf("tf_cnt!==start_time, but rf_request is %0d",m_tb_if.rf_request))
                                    end
                                    start_time_check=1;
                                end
                            end
                        end
                        begin
                            while(start_addr_check==0)begin//start addr check
                                @(posedge m_tb_if.clk);
                                if(m_tb_if.rf_request == 1 && m_tb_if.fsm == 5'b0)begin
                                    @(posedge m_tb_if.clk);
                                    if(m_tb_if.gradd_n!= 14'b0)begin
                                        `uvm_error(get_full_name(), $sformatf("start addr failed, now is %0h",m_tb_if.gradd_n))
                                    end
                                    start_addr_check=1;
                                end
                            end
                        end
                    join
                    wait(m_tb_if.mc_dram_init_wr_finish==1);
                    assert(randomize(num_seed));
                    `uvm_info(get_type_name(),$sformatf("num_seed =%0d ",num_seed),UVM_LOW);
                    for(int i=0;i<num_seed;i++)begin
                        `uvm_info(get_type_name(),$sformatf("i =%0d ",i),UVM_LOW);
                        assert(randomize(radd_seed));
                        assert(m_frame_cfg.randomize with {
                            cadd                == 0;
                            radd                == radd_seed;
                            frame_rw_flag       == 1;   //1:wr 0:rd
                            one_frame_cnt       == 'd128;
                            col_addr_rand_en    == 0;
                            wrap_en             == 0;
                            strb_rand_en        == 0;
                            strb                == 1;
                        });
                        send_one_frame(m_frame_cfg);        
                        assert(randomize(radd_seed));
                        assert(m_frame_cfg.randomize with {
                            cadd                == 0;
                            radd                == radd_seed;
                            frame_rw_flag       == 0;   //1:wr 0:rd
                            one_frame_cnt       == 'd128;
                            col_addr_rand_en    == 0;
                            wrap_en             == 0;

                        });
                        send_one_frame(m_frame_cfg);        
                    end
                    #1us;                
                end
            endcase
        end
    join
endtask

endclass


`endif
