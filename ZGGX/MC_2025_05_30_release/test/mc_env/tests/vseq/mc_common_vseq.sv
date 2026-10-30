//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_common_vseq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_COMMON_VSEQ_SV
`define MC_COMMON_VSEQ_SV

class mc_common_vseq extends mc_base_vseq;
   
    frame_agent_base_seq        m_frame_agent_base_seq  ;
    apb_master_wr_vseq          p_apb_wr                ;
    apb_master_rd_vseq          p_apb_rd                ;
    
    mc_frame_seq_cfg            m_frame_cfg             ;
    uvm_status_e                status                  ;
    uvm_reg_data_t              data                    ;
    
    rand bit [7:0]              div_cnt_i               ;
    rand bit [7:0]              clk_freq_cnt            ;
    rand bit [31:0]             freq_clk_delay          ;
    constraint clk_freq_c {
            div_cnt_i       inside {[0:51]};//640MHz?
            clk_freq_cnt    dist {[10:50]:/40,[60:100]:/20};
            freq_clk_delay  dist {[20000:100000]:/60,[100000:200000]:/20,[400000:500000]:/20};
    }
    
    `uvm_object_utils(mc_common_vseq)

    function new(string name="mc_common_vseq");
        super.new(name);
    endfunction

virtual task body();
    super.body();
    $display("Please complete the sequence as follow ...");
    m_frame_cfg = mc_frame_seq_cfg::type_id::create("m_frame_cfg");


    //fork:clk_freq_and_reset
    //begin
    //    wait_reset_release();
    //end
    //begin
    //    //clk_freq(); 
    //end
    //join_any
    `ifdef DRAM_INIT
    if((p_sequencer.m_tb_if.reset_vseq == 0) && (p_sequencer.m_tb_if.rst_ongoing_flag == 1'b0))begin //add condition for reset check       
        wait_reset_release();
        `ifdef CLK_500M
            m_tb_if.mc_tras_cfg =    'd14 ;      
            m_tb_if.mc_trp_cfg  =    'd7  ;      
            m_tb_if.mc_trc_cfg  =    'd21 ;      
            m_tb_if.mc_trcd_cfg =    'd8  ;      
            m_tb_if.mc_trtp_cfg =    'd1  ;      
            m_tb_if.mc_twr_cfg  =    'd8  ;      
            m_tb_if.mc_twtr_cfg =    'd3  ;      
            m_tb_if.mc_trtw_cfg =    'd4  ;      
        `elsif CLK_300M
            m_tb_if.mc_tras_cfg =  'd9    ;      
            m_tb_if.mc_trp_cfg  =  'd5    ;      
            m_tb_if.mc_trc_cfg  =  'd14   ;      
            m_tb_if.mc_trcd_cfg =  'd5    ;      
            m_tb_if.mc_trtp_cfg =  'd1    ;      
            m_tb_if.mc_twr_cfg  =  'd5    ;      
            m_tb_if.mc_twtr_cfg =  'd2    ;      
            m_tb_if.mc_trtw_cfg =  'd3    ;                  
        `else
            m_tb_if.mc_tras_cfg =  'd22   ;      
            m_tb_if.mc_trp_cfg  =  'd11   ;      
            m_tb_if.mc_trc_cfg  =  'd20   ;      
            m_tb_if.mc_trcd_cfg =  'd6    ;      
            m_tb_if.mc_trtp_cfg =  'd0    ;      
            m_tb_if.mc_twr_cfg  =  'd12   ;      
            m_tb_if.mc_twtr_cfg =  'd4    ;      
            m_tb_if.mc_trtw_cfg =  'd6    ;     
        `endif
        @(posedge m_tb_if.pclk);
        m_tb_if.global_dram_init_en[1]=1'b0;
        wait (m_tb_if.clk);
        m_tb_if.ras_clr=0;
        #20ns;
        m_tb_if.ras_clr=1;
        #20ns;
        m_tb_if.ras_clr=0;

        //when used reset condition, please add below 2 lines
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
        //wait(m_tb_if.mc_dram_init_wr_finish==1);
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_en.write(status,1'h0, UVM_FRONTDOOR);
        m_tb_if.mc_scan_timeout_en  =   0;
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rdrdy_n_en.mc_rdrdy_n_en.write(status,1'h0, UVM_FRONTDOOR);
    end
    `else
    if((p_sequencer.m_tb_if.reset_vseq == 0) && (p_sequencer.m_tb_if.rst_ongoing_flag == 1'b0))begin //add condition for reset check       
        wait_reset_release();
        `ifdef CLK_500M
            m_tb_if.mc_tras_cfg =    'd14 ;      
            m_tb_if.mc_trp_cfg  =    'd7  ;      
            m_tb_if.mc_trc_cfg  =    'd21 ;      
            m_tb_if.mc_trcd_cfg =    'd8  ;      
            m_tb_if.mc_trtp_cfg =    'd1  ;      
            m_tb_if.mc_twr_cfg  =    'd8  ;      
            m_tb_if.mc_twtr_cfg =    'd3  ;      
            m_tb_if.mc_trtw_cfg =    'd4  ;      
        `elsif CLK_300M
            m_tb_if.mc_tras_cfg =  'd9    ;      
            m_tb_if.mc_trp_cfg  =  'd5    ;      
            m_tb_if.mc_trc_cfg  =  'd14   ;      
            m_tb_if.mc_trcd_cfg =  'd5    ;      
            m_tb_if.mc_trtp_cfg =  'd1    ;      
            m_tb_if.mc_twr_cfg  =  'd5    ;      
            m_tb_if.mc_twtr_cfg =  'd2    ;      
            m_tb_if.mc_trtw_cfg =  'd3    ;                  
        `else
            m_tb_if.mc_tras_cfg =  'd22   ;      
            m_tb_if.mc_trp_cfg  =  'd11   ;      
            m_tb_if.mc_trc_cfg  =  'd30   ;      
            m_tb_if.mc_trcd_cfg =  'd6    ;      
            m_tb_if.mc_trtp_cfg =  'd1    ;      
            m_tb_if.mc_twr_cfg  =  'd12   ;      
            m_tb_if.mc_twtr_cfg =  'd4    ;      
            m_tb_if.mc_trtw_cfg =  'd6    ;     
        `endif
        @(posedge m_tb_if.pclk);
        m_tb_if.global_dram_init_en[1]=1'b0;
        wait (m_tb_if.clk);
        m_tb_if.ras_clr=0;
        #20ns;
        m_tb_if.ras_clr=1;
        #20ns;
        m_tb_if.ras_clr=0;

        //when used reset condition, please add below 2 lines
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
        //wait(m_tb_if.mc_dram_init_wr_finish==1);
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_en.write(status,1'h0, UVM_FRONTDOOR);
        m_tb_if.mc_scan_timeout_en  =   0;
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rdrdy_n_en.mc_rdrdy_n_en.write(status,1'h0, UVM_FRONTDOOR);
    end
    `endif

    //apb_seq    m_apb_seq;
    //frame_agent_seq    m_frame_agent_seq;
    //`uvm_do_on(m_apb_seq,p_sequencer.p_apb_sqr);
    //`uvm_do_on(m_frame_agent_seq,p_sequencer.p_frame_agent_sqr);
    $display("done ...");
    #1us;
    $display("done ...");
endtask
//------------------------------------------------------------------------------
// wait_reset_release
//------------------------------------------------------------------------------
task wait_reset_release();
    //fork
    //begin
    //    @(posedge m_svt_apb_if[0].presetn);
    //    @(posedge m_svt_apb_if[0].pclk);
    //end
    //begin
    //    @(posedge m_svt_apb_if[1].presetn);
    //    @(posedge m_svt_apb_if[1].pclk);
    //end
    //begin
    //    @(posedge m_frame_agent_if.rst_n);
    //    @(posedge m_frame_agent_if.clk);
    //end
    //join
    fork
    begin
        @(posedge m_tb_if.mc_sys_rst_n);
        @(posedge m_tb_if.clk);
    end
    begin
        @(posedge m_tb_if.mc_apb_rst_n);
        @(posedge m_tb_if.pclk);
    end
    join
endtask

//------------------------------------------------------------------------------
// send_one_frame
//------------------------------------------------------------------------------

task send_one_frame(mc_frame_seq_cfg  m_frame_seq_cfg);
    
    bit    [`COL_ADDR_WIDTH-1:0]    cadd,cadd_i             ;    
    bit    [`ROW_ADDR_WIDTH-1:0]   radd                    ;
    bit             frame_eof               ;
    bit             frame_sof               ;
    bit             bank_sel                ;   
    bit             frame_rw_flag           ;    //1:wr 0:rd
    bit    [15:0]   one_frame_cnt           ;  
    bit             col_addr_rand_en        ;
    bit             wrap_en                 ;
    bit    [`COLUMN_ADDR_WIDTH-1:0]    cadd_max                ;
    bit             strb_rand_en            ;
    bit             strb;

    cadd                    =   m_frame_seq_cfg.cadd                    ;
    radd                    =   m_frame_seq_cfg.radd                    ;
    one_frame_cnt           =   m_frame_seq_cfg.one_frame_cnt           ;
    col_addr_rand_en        =   m_frame_seq_cfg.col_addr_rand_en        ;
    wrap_en                 =   m_frame_seq_cfg.wrap_en                 ;
    strb_rand_en            =   m_frame_seq_cfg.strb_rand_en            ;
    
    bank_sel                =   m_frame_seq_cfg.bank_sel;
    frame_rw_flag           =   m_frame_seq_cfg.frame_rw_flag;

    if(m_tb_if.debug_test_en == 1'b1) begin
        strb            =   1'b1;
    end
    else begin
        if(!strb_rand_en)
            strb            =   m_frame_seq_cfg.frame_rw_flag? m_frame_seq_cfg.strb : 1'b1;
    end
        
    cadd_max='d128;         

    for(int i=0;i<one_frame_cnt;i++)begin
        if(strb_rand_en && m_tb_if.debug_test_en == 1'b0)
            strb            =   frame_rw_flag? $urandom() : 1'b1;

        if(i==0 && one_frame_cnt>1)begin
            frame_eof       =   0                               ;
            frame_sof       =   1                               ;
        end
        else if(i==0 && one_frame_cnt==1 )begin
            frame_eof       =   1                               ;
            frame_sof       =   1                               ;              
        end
        else if( i>0 && (i<(one_frame_cnt-1)) )begin
            frame_eof       =   0                               ;
            frame_sof       =   0                               ;
        end
        else if( i>0 && i==(one_frame_cnt-1))begin
            frame_eof       =   1                               ;
            frame_sof       =   0                               ;
        end 
        if((col_addr_rand_en == 1) && (one_frame_cnt == 1))begin
            `uvm_do_on_with(m_frame_agent_base_seq, p_sequencer.p_frame_agent_sqr,
                            {
                             m_frame_agent_base_seq.cadd            == local::cadd         ;
                             m_frame_agent_base_seq.radd            == local::radd         ;
                             m_frame_agent_base_seq.frame_eof       == local::frame_eof    ;
                             m_frame_agent_base_seq.frame_sof       == local::frame_sof    ;
                             m_frame_agent_base_seq.frame_rw_flag   == local::frame_rw_flag;
                             m_frame_agent_base_seq.bank_sel        == local::bank_sel     ;
                             m_frame_agent_base_seq.strb            == local::strb;
                            })                  
        end
        else if((col_addr_rand_en == 1) && (one_frame_cnt >= 2))begin
            `uvm_do_on_with(m_frame_agent_base_seq, p_sequencer.p_frame_agent_sqr,
                            {
                             if(i==0){m_frame_agent_base_seq.cadd   == local::cadd         ;}
                             m_frame_agent_base_seq.radd            == local::radd         ;
                             m_frame_agent_base_seq.frame_eof       == local::frame_eof    ;
                             m_frame_agent_base_seq.frame_sof       == local::frame_sof    ;
                             m_frame_agent_base_seq.frame_rw_flag   == local::frame_rw_flag;
                             m_frame_agent_base_seq.bank_sel        == local::bank_sel     ;
                             m_frame_agent_base_seq.strb            == local::strb;
                            })      
        end 
        else begin
            if(wrap_en == 1)begin
                cadd_i = cadd + i ;
                if(cadd_i >= cadd_max)  cadd_i = cadd_i - cadd_max; 
                `uvm_do_on_with(m_frame_agent_base_seq, p_sequencer.p_frame_agent_sqr,
                                {
                                 m_frame_agent_base_seq.cadd            == local::cadd_i       ;
                                 m_frame_agent_base_seq.radd            == local::radd         ;
                                 m_frame_agent_base_seq.frame_eof       == local::frame_eof    ;
                                 m_frame_agent_base_seq.frame_sof       == local::frame_sof    ;
                                 m_frame_agent_base_seq.frame_rw_flag   == local::frame_rw_flag;
                                 m_frame_agent_base_seq.bank_sel        == local::bank_sel     ;
                                 m_frame_agent_base_seq.strb            == local::strb;
                                })
            end
            else begin
                cadd_i = cadd + i ;
                `uvm_do_on_with(m_frame_agent_base_seq, p_sequencer.p_frame_agent_sqr,
                                {
                                 m_frame_agent_base_seq.cadd            == local::cadd_i       ;
                                 m_frame_agent_base_seq.radd            == local::radd         ;
                                 m_frame_agent_base_seq.frame_eof       == local::frame_eof    ;
                                 m_frame_agent_base_seq.frame_sof       == local::frame_sof    ;
                                 m_frame_agent_base_seq.frame_rw_flag   == local::frame_rw_flag;
                                 m_frame_agent_base_seq.bank_sel        == local::bank_sel     ;
                                 m_frame_agent_base_seq.strb            == local::strb;
                                })
            end 
        end
    end
endtask

//------------------------------------------------------------------------------
// send_multi_frame
//------------------------------------------------------------------------------
task send_multi_frame(mc_frame_seq_cfg  m_frame_seq_cfg_q[$]);
    int frame_num=0;
    mc_frame_seq_cfg    m_cfg;

    frame_num = m_frame_seq_cfg_q.size;
    m_cfg = mc_frame_seq_cfg::type_id::create("m_cfg");
    
    for(int j=0;j<frame_num;j++)begin
        m_cfg =  m_frame_seq_cfg_q.pop_front();
        send_one_frame(m_cfg);
    end

endtask

//------------------------------------------------------------------------------
// apb_read
//------------------------------------------------------------------------------
task apb_read (input bit[31:0]master_num ,input bit[31:0]base_addr,input bit[31:0] offset_addr,output bit[31:0] rdata);
        `uvm_info(get_type_name(), "reg read task start ......!", UVM_LOW)
        `uvm_do_on_with(p_apb_rd,p_sequencer.p_svt_apb_master_sqr[0],{p_apb_rd.address==(base_addr*32'h400+offset_addr);p_apb_rd.pstrb==4'hf;});
        rdata=p_apb_rd.data;
        `uvm_info(get_type_name(), "reg read task end   ......!", UVM_LOW)
endtask:apb_read

//------------------------------------------------------------------------------
// apb_write
//------------------------------------------------------------------------------
task apb_write(input bit[31:0]master_num ,input bit[31:0]base_addr,input bit[31:0] offset_addr,input bit[31:0] wdata);
    `uvm_info(get_type_name(), "reg write task start ......!", UVM_LOW)
    `uvm_do_on_with(p_apb_wr,p_sequencer.p_svt_apb_master_sqr[0],{p_apb_wr.address==(base_addr*32'h400+offset_addr);p_apb_wr.data==wdata;p_apb_wr.pstrb==4'hf;});
    `uvm_info(get_type_name(), "reg write task end   ......!", UVM_LOW)
endtask : apb_write

//------------------------------------------------------------------------------
// clk_freq
//------------------------------------------------------------------------------
task clk_freq();
    if(m_tb_if.clk_freq_en == 1)begin
        assert(randomize(clk_freq_cnt));
        `uvm_info(get_type_name(),$sformatf("Clk freq :clk_freq_cnt =%d",clk_freq_cnt),UVM_LOW);
        for(int cnt_c=0;cnt_c<clk_freq_cnt;cnt_c++)begin
            assert(randomize(div_cnt_i));
            assert(randomize(freq_clk_delay));
            `uvm_info(get_type_name(),$sformatf("Clk freq :div_cnt_i =%d,freq_clk_delay=%d",div_cnt_i,freq_clk_delay),UVM_LOW);
            repeat(freq_clk_delay)@(posedge m_tb_if.clk);
            m_tb_if.cnt_load = 0;  
            #10ns;
            m_tb_if.div_cnt = div_cnt_i; 
            #10ns;
            m_tb_if.cnt_load = 1;
        end
    end
endtask : clk_freq

endclass

`endif //MC_COMMON_VSEQ_SV

