//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_performance_con_wr_vseq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 26 10:33:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_PERFORMANCE_con_wr_VSEQ
`define MC_PERFORMANCE_con_wr_VSEQ




class mc_performance_con_wr_vseq extends mc_common_vseq;
    
    
    `uvm_object_utils(mc_performance_con_wr_vseq)

    bit         [31:0]  mc_page_status=0; 
    rand bit            close_page_en;
    rand bit    [15:0]  one_frame_cnt_i;
    bit                 frame_rw_flag_i;
    rand bit            performance_test_en;
    rand bit    [9:0]   round_num;
    rand bit    [15:0]  row_num;
    rand bit    [9:0]   send_num;
    rand bit    [31:0]  start_time      ;
    rand bit            wr; 
    rand bit    [31:0]  period;
    rand bit    [`ROW_ADDR_WIDTH-1:0]  s_addr;
    rand bit    [`ROW_ADDR_WIDTH-1:0]  e_addr;
    rand bit            a; 
    constraint period_c {period dist {32'h186a000:/2,32'hc35000:/2,32'h61a800:/5,32'h30d400:/50,32'hc3500:/50};};
    constraint s_addr_c {s_addr inside {[0:'h1cbe]};};
    constraint e_addr_c {e_addr inside {[0:'h1cbf]};};
    constraint addr_c {s_addr < e_addr;}
    constraint start_time_c {start_time dist {[1000:period]:/5,[0:999]:/95};}

    function new(string name="mc_performance_con_wr_vseq");
        super.new(name);
    endfunction
    constraint row_num_c{row_num inside {[0:7295]};}; 
    constraint send_num_c{send_num inside {[1:100]};}; 
virtual task body();
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    super.body();

    assert(randomize());
    m_tb_if.pre_precharge = $urandom_range(0,1);
    `uvm_info(get_type_name(),$sformatf("close_page_en=%0d,send_num=%0d",close_page_en,send_num ),UVM_LOW)
    `uvm_info(get_full_name(),$sformatf("period = %0h,start_time = %0h,s_addr = %0h,e_addr = %0h,a=1 means wr/rd before refresh now a is %d",period,start_time,s_addr,e_addr,a),UVM_LOW);
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
    fork
        begin

            for(int i=0;i<'d1001;i++)begin
                assert(m_frame_cfg.randomize with {
                    cadd                == 0;
                    radd                == i;
                    frame_rw_flag       == 1;   //1:wr 0:rd
                    one_frame_cnt       == 'd4;
                    col_addr_rand_en    == 0;
                    wrap_en             == 0;
                    strb_rand_en        == 0;
                    strb                == 1;
                });
                send_one_frame(m_frame_cfg);        
            end 
            #10us;
            for(int i=0;i<'d1001;i++)begin
                assert(m_frame_cfg.randomize with {
                    cadd                == 0;
                    radd                == i;
                    frame_rw_flag       == 0;   //1:wr 0:rd
                    one_frame_cnt       == 'd4;
                    col_addr_rand_en    == 0;
                    wrap_en             == 0;

                });
                send_one_frame(m_frame_cfg);        
            end 
            #1us;

            #10us;
            for(int j=0;j<1;j++)begin//burst 1
                assert(m_frame_cfg.randomize with {
                        cadd                == 1;
                        radd                == 1;
                        frame_rw_flag       == 0;   //1:wr 0:rd
                        one_frame_cnt       == 1;
                        col_addr_rand_en    == 0;
                        wrap_en             == 0;
                        strb_rand_en        == 0;
                        strb                == 1;
                    });
                `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
                
                send_one_frame(m_frame_cfg);
            end   
        end
        begin
            /*if(a==0)begin
                #1us;
            end
            m_tb_if.mc_rf_start_sel=0;
            m_tb_if.rf_range_change_en=1;
            m_tb_if.rf_addr={s_addr,e_addr};
            m_tb_if.rf_period=period;//64ms:32'h30d4000, 32ms:32'h186a000, 16ms:32'hc35000, 8ms:32'h61a800, 4ms:32'h30d400; 1ms:32'hc3500
            m_tb_if.rf_start_time=start_time;
            `uvm_info(get_full_name(),$sformatf("period = %0h,start_time = %0h,s_addr = %0h,e_addr = %0h,a=1 means wr/rd before refresh now a is %d",period,start_time,s_addr,e_addr,a),UVM_LOW);
            m_tb_if.mc_rf_period_sel=0;//0:interface, 1:mc_local
            @(posedge m_tb_if.clk);
            m_tb_if.mc_rf_start=1;*/
        end

    join
    #1us;



endtask




endclass


`endif
