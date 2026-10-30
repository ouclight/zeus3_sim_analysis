//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_refresh_soc_dynamic_change_vseq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 28 15:01:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_REFRESH_SOC_DYNAMIC_CHANGE_VSEQ
`define MC_REFRESH_SOC_DYNAMIC_CHANGE_VSEQ

class mc_refresh_soc_dynamic_change_vseq extends mc_common_vseq;
    
    rand bit    [3:0]   burst_cnt_i     ;
    bit                 frame_rw_flag_i ;
    rand bit    [`COL_ADDR_WIDTH-1:0]   cadd_i          ;
    rand bit    [`ROW_ADDR_WIDTH-1:0]  radd_i          ;
    rand bit            change_period   ;
    bit         [5:0]   test_cnt        ;
    rand bit    [31:0]  period          ;
    rand bit    [31:0]  period1         ;
    rand bit    [31:0]  start_time      ;
    rand bit            a               ;
    bit         [31:0]  delay_cnt       ;
    bit         [31:0]  delay_cnt1      ;
    bit         [31:0]  delay_cnt2      ;
    bit         [31:0]  delay           ;
    bit         [31:0]  rf_cnt_num      ;
    logic       [31:0]  rf_cnt_num_q[$] ;
    logic       [289:0] data_q[$]       ;
    bit         [289:0] data            ;
    rand bit    [12:0]  start_addr      ;
    rand bit    [12:0]  end_addr        ;
    logic       [12:0]  start_addr_q[$] ;
    logic       [12:0]  end_addr_q[$]   ;
    bit         [31:0]  s_addr          ;
    bit         [31:0]  e_addr          ;
    rand bit            pre_precharge_en;
    bit         [31:0]  mc_page_status=0; 
    bit         [31:0]                  apb_wdata;
    rand bit                                 vmc_en;
    int                                 base_addr          ;
    bit         [31:0]                  offset_addr        ;
    rand bit    [6:0]                   vmc_wl_cnt;
    rand bit    [1:0]                   vmc_csl_cnt;
    randc bit   [`ROW_ADDR_WIDTH-1:0]   vmc_wl_addr;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_1;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_2;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_3;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_4;
    bit         [`ROW_ADDR_WIDTH-1:0]   vmc_wl_addr_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_up_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_down_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part0_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part1_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part2_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part3_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part4_q[$];
    bit                                 refresh_start=0;
    constraint vmc_wl_cnt_c {vmc_wl_cnt inside {[1:64]};}

    constraint period_c {period dist {32'h30d4000,32'h186a000:/2,32'hc35000:/2,32'h61a800:/5,32'h30d400:/50};}
    constraint period_c1 {period1 dist {32'h30d4000:/2,32'h186a000:/2,32'hc35000:/2,32'h61a800:/5,32'h30d400:/50};}
    constraint start_time_c {start_time dist {[1000:period]:/5,[0:999]:/95};}
    constraint start_addr_c {start_addr inside {[0:7358]};}
    constraint end_addr_c {end_addr inside {[0:7359]};end_addr > start_addr;}
    mc_frame_seq_cfg    m_frame_seq_w_q[$];
    mc_frame_seq_cfg    m_frame_seq_r_q[$];
    `uvm_object_utils(mc_refresh_soc_dynamic_change_vseq)

    function new(string name="mc_refresh_soc_dynamic_change_vseq");
        super.new(name);
    endfunction
    

virtual task body();
    super.body();
    assert(randomize());
    rf_cnt_num=32'h30d4000;
    s_addr=0;
    e_addr=13'h1cbf;
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    if(vmc_en)begin
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_wl_vmc_en.write(status,1'b0, UVM_FRONTDOOR);
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_bl_vmc_en.write(status,1'b0, UVM_FRONTDOOR);
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'b0, UVM_FRONTDOOR);

        repeat(10) @(posedge m_tb_if.clk);
        base_addr = 0;
        `uvm_info(get_type_name(),$sformatf("vmc_wl_cnt =%0d",vmc_wl_cnt),UVM_LOW);
        //********cfg_mc_vmc_wl_num**********
        for(int j=0;j<vmc_wl_cnt;j++)begin
            //randomize(vmc_wl_addr) with {vmc_wl_addr inside {[0:14655]};}; 
            randomize(vmc_wl_addr) with {vmc_wl_addr inside {[0:7359]};}; 
            vmc_wl_addr_q.push_back(vmc_wl_addr);
        end
        foreach(vmc_wl_addr_q[i])begin
            automatic bit[`ROW_ADDR_WIDTH-1:0] temp[$] = vmc_wl_addr_q;
            temp.sort();
            vmc_wl_addr_q = temp;
        end
        for(int j=0;j<vmc_wl_cnt;j++)begin
            apb_wdata = vmc_wl_addr_q.pop_front();
            `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h ",apb_wdata),UVM_LOW);
            offset_addr =  32'h1c  +  j*32'h4;
            apb_write('b1,base_addr,offset_addr,apb_wdata-j);
        end 

        randomize(vmc_csl_cnt) with {vmc_csl_cnt dist {1:/50,2:/50};};
        //********cfg_mc_vmc_bl_num_part0**********
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr));
            vmc_csl_addr_part0_q.push_back(vmc_csl_addr);                
        end
        foreach(vmc_csl_addr_part0_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part0_q;
            temp.sort();
            vmc_csl_addr_part0_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata =vmc_csl_addr_part0_q.pop_front();
            `uvm_info(get_type_name(),$sformatf("vmc_csl_addr =%0h,apb_wdata =%0h ",vmc_csl_addr,apb_wdata),UVM_LOW);
            offset_addr = 32'h11c + k*'h4;
            apb_write('b1,base_addr,offset_addr,apb_wdata-k);
        end

        //********cfg_mc_vmc_bl_num_part1**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_1));
            vmc_csl_addr_part1_q.push_back(vmc_csl_addr_1);                
        end    
        foreach(vmc_csl_addr_part1_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part1_q;
            temp.sort();
            vmc_csl_addr_part1_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata =vmc_csl_addr_part1_q.pop_front();
            `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
            offset_addr = 32'h124 + k*'h4;
            apb_write('b1,base_addr,offset_addr,apb_wdata);
        end
        //********cfg_mc_vmc_bl_num_part2**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_2));
            vmc_csl_addr_part2_q.push_back(vmc_csl_addr_2);                
        end    
        foreach(vmc_csl_addr_part2_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part2_q;
            temp.sort();
            vmc_csl_addr_part2_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata =vmc_csl_addr_part2_q.pop_front();
            `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
            offset_addr = 32'h278 + k*'h4;
            apb_write('b1,base_addr,offset_addr,apb_wdata);
        end

        //********cfg_mc_vmc_bl_num_part3**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_3));
            vmc_csl_addr_part3_q.push_back(vmc_csl_addr_3);                
        end    
        foreach(vmc_csl_addr_part3_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part3_q;
            temp.sort();
            vmc_csl_addr_part3_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata =vmc_csl_addr_part3_q.pop_front();
            `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
            offset_addr = 32'h280 + k*'h4;
            apb_write('b1,base_addr,offset_addr,apb_wdata);
        end

        //********cfg_mc_vmc_bl_num_part4**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_4));
            vmc_csl_addr_part4_q.push_back(vmc_csl_addr_4);                
        end    
        foreach(vmc_csl_addr_part4_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part4_q;
            temp.sort();
            vmc_csl_addr_part4_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata =vmc_csl_addr_part4_q.pop_front();
            `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
            offset_addr = 32'h288 + k*'h4;
            apb_write('b1,base_addr,offset_addr,apb_wdata);
        end


        m_tb_if.wl_vmc_en=1;
        m_tb_if.bl_vmc_en=1;
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_wl_vmc_en.write(status,1'b1, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_bl_vmc_en.write(status,1'b1, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'b1, UVM_FRONTDOOR);
        repeat(30) @(posedge m_tb_if.clk);
    end
    else begin
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'b1, UVM_FRONTDOOR);
        repeat(30) @(posedge m_tb_if.clk);
    end
    //----------------------cfg refresh interface------------------------//
    fork 
        begin
            fork
                begin
                    if(a==1)begin
                        delay =  $urandom_range(32'h50,32'h1000);
                        repeat(delay) @(posedge m_tb_if.clk);
                    end
                    @(posedge m_tb_if.pclk);
                    m_tb_if.mc_rf_start_sel=0;
                    m_tb_if.rf_range_change_en=1;
                    //m_tb_if.rf_addr={14'h1,14'h3000};
                    //m_tb_if.rf_period=period;//64ms:32'h30d4000, 32ms:32'h186a000, 16ms:32'hc35000, 8ms:32'h61a800, 4ms:32'h30d400; 1ms:32'hc3500
                    m_tb_if.rf_start_time=start_time;
                    //`uvm_info(get_full_name(),$sformatf("period = %0h,start_time = %0h,a=1 means wr/rd before refresh now a is %d",period,start_time,a),UVM_LOW);
                    m_tb_if.mc_rf_period_sel=0;//0:interface, 1:mc_local
                    @(posedge m_tb_if.clk);
                    m_tb_if.mc_rf_start=1;
                    refresh_start=1;
                end
                begin
                    if(a==0)begin
                        delay =  $urandom_range(32'h50,32'h1000);
                        repeat(delay) @(posedge m_tb_if.clk);
                    end
                    for(int ii=0;ii<'d1465;ii++)begin
                        assert(m_frame_cfg.randomize with {
                            cadd                == 0;
                            radd                == ii;
                            frame_rw_flag       == 1;   //1:wr 0:rd
                            one_frame_cnt       == 'd128;
                            col_addr_rand_en    == 0;
                            wrap_en             == 0;
                        });
                        send_one_frame(m_frame_cfg);        
                    end

                    for(int ii=0;ii<'d1465;ii++)begin
                        assert(m_frame_cfg.randomize with {
                            cadd                == 0;
                            radd                == ii;
                            frame_rw_flag       == 0;   //1:wr 0:rd
                            one_frame_cnt       == 'd128;
                            col_addr_rand_en    == 0;
                            wrap_en             == 0;
                        });
                        send_one_frame(m_frame_cfg);        
                    end
                    wait(m_tb_if.rf_cnt==0);
                    test_cnt = 'd1;
                    for(int j=0;j<test_cnt;j++)begin
                        m_frame_seq_w_q.delete();
                        m_frame_seq_r_q.delete();        
                        randomize(burst_cnt_i);
                        `uvm_info(get_full_name(),$sformatf("burst_cnt_i = %0d",burst_cnt_i),UVM_LOW);
                        
                        for(int ii=0;ii<burst_cnt_i;ii++)begin
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
                    //for(int i=0;i<'d14656;i++)begin
                    for(int ii=0;ii<'d1465;ii++)begin
                        assert(m_frame_cfg.randomize with {
                            cadd                == 0;
                            radd                == ii;
                            frame_rw_flag       == 1;   //1:wr 0:rd
                            one_frame_cnt       == 'd128;
                            col_addr_rand_en    == 0;
                            wrap_en             == 0;
                        });
                        send_one_frame(m_frame_cfg);        
                    end

                    for(int ii=0;ii<'d1465;ii++)begin
                        assert(m_frame_cfg.randomize with {
                            cadd                == 0;
                            radd                == ii;
                            frame_rw_flag       == 0;   //1:wr 0:rd
                            one_frame_cnt       == 'd128;
                            col_addr_rand_en    == 0;
                            wrap_en             == 0;
                        });
                        send_one_frame(m_frame_cfg);        
                    end
                    `uvm_info(get_type_name(),"body=====apb_write======start===========",UVM_LOW);
                    #1us;
                end
        //----------------------------------chagne rf_period START---------------------------------------
                begin
                    if(a==1)begin
                        #1us;
                    end
                    wait(refresh_start==1);
                    if(change_period==1)begin
                        assert(randomize(period) with {period<32'h30d4000;});
                    end
                    else begin
                        assert(randomize(period));
                    end
                    delay_cnt = $urandom_range(32'h0,32'h30d4000);
                    `uvm_info(get_full_name(),$sformatf("period = %0h,delay_cnt = %0h",period,delay_cnt),UVM_LOW);
                    repeat(delay_cnt) @(posedge m_tb_if.clk);
                    m_tb_if.rf_period=period;
                    m_tb_if.rf_period_up_en =   1'b1;
                    @(posedge m_tb_if.clk);
                    m_tb_if.rf_period_up_en =   1'b0;
                    rf_cnt_num_q.push_back(period);
                    //wait(m_tb_if.rf_cnt==0);
                    `uvm_info(get_full_name(),"period1 start",UVM_LOW);
                    delay_cnt = $urandom_range(32'h0,32'h30d400);
                    if(change_period==1)begin
                        assert(randomize(period1) with {period1>period;});
                    end
                    else begin
                        assert(randomize(period1));
                    end
                    `uvm_info(get_full_name(),$sformatf("period1 = %0h,delay_cnt = %0h",period1,delay_cnt),UVM_LOW);
                    if((delay_cnt+m_tb_if.rf_cnt)<32'h30d4000)begin
                        rf_cnt_num_q.pop_front();
                    end
                    repeat(delay_cnt) @(posedge m_tb_if.clk);
                    m_tb_if.rf_period=period1;
                    m_tb_if.rf_period_up_en =   1'b1;
                    @(posedge m_tb_if.clk);
                    m_tb_if.rf_period_up_en =   1'b0;
                    repeat(50)begin
                        rf_cnt_num_q.push_back(period1);
                    end
                    wait(m_tb_if.rf_cnt==0);
                    #1us;
                end
        //----------------------------------chagne rf_period END---------------------------------------
        //----------------------------------chagne rf_addr START---------------------------------------
                begin
                    if(a==1)begin
                        delay =  $urandom_range(32'h50,32'h1000);
                        repeat(delay) @(posedge m_tb_if.clk);
                    end
                    delay_cnt1 = $urandom_range(32'h0,32'h30d4000);
                    `uvm_info(get_full_name(),$sformatf("delay_cnt1 = %0h",delay_cnt1),UVM_LOW);
                    assert(randomize(start_addr,end_addr));
                    if(delay_cnt1<start_time)begin
                        s_addr = start_addr;
                        e_addr = end_addr;
                        repeat(delay_cnt1) @(posedge m_tb_if.clk);
                        m_tb_if.rf_addr={start_addr,end_addr};
                        start_addr_q.push_back(start_addr);
                        end_addr_q.push_back(end_addr);
                        `uvm_info(get_full_name(),$sformatf("start_addr = %0h,end_addr = %0h",start_addr,end_addr),UVM_LOW);
                    end
                    else begin
                        repeat(delay_cnt1) @(posedge m_tb_if.clk);
                        m_tb_if.rf_addr={start_addr,end_addr};
                        start_addr_q.push_back(start_addr);
                        end_addr_q.push_back(end_addr);
                        `uvm_info(get_full_name(),$sformatf("start_addr = %0h,end_addr = %0h",start_addr,end_addr),UVM_LOW);
                    end
                    wait(m_tb_if.rf_cnt==0);
                    delay_cnt1 = $urandom_range(32'h0,32'hc3500);
                    `uvm_info(get_full_name(),$sformatf("delay_cnt1 = %0h",delay_cnt1),UVM_LOW);

                    repeat(delay_cnt1) @(posedge m_tb_if.clk);
                    assert(randomize(start_addr,end_addr));
                    m_tb_if.rf_addr={start_addr,end_addr};
                    `uvm_info(get_full_name(),$sformatf("start_addr = %0h,end_addr = %0h",start_addr,end_addr),UVM_LOW);

                    for(int i=0;i<50;i++)begin
                        start_addr_q.push_back(start_addr);
                        end_addr_q.push_back(end_addr);
                    end
                    wait(m_tb_if.rf_cnt==0);
                    #1us;
                end
        //----------------------------------chagne rf_addr END---------------------------------------
        //----------------------------------chagne open/close page START---------------------------------------
                begin
                    if(a==1)begin
                        #1us;
                    end
                    delay_cnt2 = $urandom_range(32'h0,32'h30d4000);
                    assert(randomize(pre_precharge_en));
                    `uvm_info(get_full_name(),$sformatf("delay_cnt2 = %0h,pre_precharge_en=%d",delay_cnt2,pre_precharge_en),UVM_LOW);
                    repeat(delay_cnt2) @(posedge m_tb_if.clk);
                    while(mc_page_status==1)begin
                        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
                    end
                    @(posedge m_tb_if.pclk);
                    m_tb_if.page_mode_switch = 1'b1;
                    delay_cnt2 = $urandom_range(32'h0,32'h30d4000);
                    mc_page_status=0;
                    `uvm_info(get_full_name(),$sformatf("delay_cnt2 = %0h,pre_precharge_en=%d",delay_cnt2,pre_precharge_en),UVM_LOW);
                    repeat(delay_cnt2) @(posedge m_tb_if.clk);
                    while(mc_page_status==1)begin
                        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
                    end
                    @(posedge m_tb_if.pclk);
                    m_tb_if.page_mode_switch = 1'b0;
                    m_tb_if.pre_precharge = pre_precharge_en;                     
                    delay_cnt2 = $urandom_range(32'h0,32'h30d4000);
                    mc_page_status=0;
                    //wait(m_tb_if.rf_cnt==0);
                    assert(randomize(pre_precharge_en));
                    `uvm_info(get_full_name(),$sformatf("delay_cnt2 = %0h,pre_precharge_en=%d",delay_cnt2,pre_precharge_en),UVM_LOW);
                    repeat(delay_cnt2) @(posedge m_tb_if.clk);
                    while(mc_page_status==1)begin
                        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
                    end
                    @(posedge m_tb_if.pclk);
                    m_tb_if.page_mode_switch = 1'b1;
                    //m_tb_if.pre_precharge = 1;                     
                    #1us;
                end
        //----------------------------------chagne open/close page END---------------------------------------
            join
        end
        begin
            while(1)begin//start_time check
                wait(m_tb_if.mc_rf_start==1);
                @(posedge m_tb_if.clk);
                if(m_tb_if.rf_cnt==start_time)begin
                    `uvm_info(get_type_name(),"rf_cnt==0",UVM_LOW);
                    @(posedge m_tb_if.clk);
                    if(m_tb_if.rf_request != 1)begin
                        `uvm_error(get_full_name(), $sformatf("tf_cnt!==0, but rf_request is %0d",m_tb_if.rf_request))
                    end
                end
            end
        end
        begin
            while(1)begin//rf start check
                @(posedge m_tb_if.clk);
                if(m_tb_if.rf_request == 1 && m_tb_if.fsm == 5'b0)begin
                    @(posedge m_tb_if.clk);
                    if(m_tb_if.fsm!= 5'b1 && m_tb_if.rf_request != 1)begin
                        `uvm_error(get_full_name(), $sformatf("rf not start, fsm is %0d, rf_request is %0d",m_tb_if.fsm,m_tb_if.rf_request))
                    end
                end
            end
        end
        begin
            while(1)begin//period check
                @(posedge m_tb_if.clk);
                if(m_tb_if.rf_cnt==rf_cnt_num)begin
                    `uvm_info(get_type_name(),"rf_cnt==period",UVM_LOW);
                    rf_cnt_num=rf_cnt_num_q.pop_front();
                    @(posedge m_tb_if.clk);
                    if(m_tb_if.rf_cnt != 0)begin
                        `uvm_error(get_full_name(), $sformatf("tf_cnt!==period, but rf_cnt is %0h",m_tb_if.rf_cnt))
                    end
                end
            end
        end
        begin
            while(1)begin//end addr check
                @(posedge m_tb_if.clk);
                if(m_tb_if.fsm==5'b110)begin
                    @(posedge m_tb_if.clk);
                    if(m_tb_if.fsm == 0)begin
                        `uvm_info(get_type_name(),"last addr",UVM_LOW);
                        if(m_tb_if.gradd_n != e_addr)begin
                            `uvm_error(get_full_name(), $sformatf("end addr failed, now is %0h,act is %0d",m_tb_if.gradd_n,e_addr))
                        end
                        wait(m_tb_if.rf_cnt==0);
                        @(posedge m_tb_if.clk);
                        if(delay_cnt1<start_time)begin
                            end_addr_q.delete();
                        end
                        wait(end_addr_q.size()>0);
                        e_addr=end_addr_q.pop_front();
                        `uvm_info(get_full_name(),$sformatf("e_addr = %0h",e_addr),UVM_LOW);
                    end
                end
            end
        end
        begin
            while(1)begin//start addr check
                @(posedge m_tb_if.clk);
                if(m_tb_if.rf_request == 1 && m_tb_if.fsm == 5'b0)begin
                    @(posedge m_tb_if.clk);
                    if(m_tb_if.gradd_n!= s_addr)begin
                        `uvm_error(get_full_name(), $sformatf("start addr failed, now is %0h,act is %0h",m_tb_if.gradd_n,s_addr))
                    end
                    wait(m_tb_if.rf_cnt==0);
                    @(posedge m_tb_if.clk);
                    if(delay_cnt1<start_time)begin
                        start_addr_q.delete();
                    end
                    wait(start_addr_q.size()>0);
                    s_addr=start_addr_q.pop_front();
                    `uvm_info(get_full_name(),$sformatf("s_addr = %0h",s_addr),UVM_LOW);
                end

            end
        end
        begin
            while(1) begin
                if(m_frame_agent_if.mc_frame_vld && m_frame_agent_if.mc_frame_rdy && m_frame_agent_if.mc_frame_data[288]==0) begin
                    data_q.push_back(m_frame_agent_if.mc_frame_data);
                end
                @(posedge m_tb_if.clk);
            end
        end
        begin
            while(1)begin
                @(posedge m_tb_if.clk);
                //if(m_tb_if.page_mode_switch==0&&m_tb_if.pre_precharge ==1)begin
                @(posedge m_array_agent_if.gcas_rd);
                data = data_q.pop_front;
                if(data[288]==0&&data[286]==1&&m_tb_if.page_mode_switch==0&&m_tb_if.pre_precharge ==1)begin
                    fork
                        begin
                            wait(m_array_agent_if.bnksel_n==1);
                            //`uvm_info(get_full_name(),"bnksel_n successful",UVM_LOW);
                        end
                        begin
                            repeat(20)@(posedge m_tb_if.clk);
                            `uvm_error(get_full_name(),"Timeout")
                        end
                    join_any
                    disable fork;
                end
            end
        end

    join_any

endtask


endclass


`endif
