`ifndef MC_CLK_FREQ_VSEQ
`define MC_CLK_FREQ_VSEQ

class mc_clk_freq_vseq extends mc_common_vseq;
    
    rand bit [31:0]     freq_clk_delay_1;
    real                clk_time_pos0;
    real                clk_time_neg0;
    real                clk_time_pos1;
    real                clk_period0,clk_period1,clk_period;
    longint             clk_cycle_num = 0;
    bit      [5:0]      cur_div_cnt;
    real                broaden_cycle;
    real                exp_broaden_cycle0,exp_broaden_cycle1; 
    rand bit [5:0]      div_cnt_i;
    real                exp_cycle_ns;
    real                clk_o_time_pos0;
    real                clk_o_time_neg0;
    real                clk_o_time_pos1;
    longint             clk_o_cycle_num = 0;
    real                clk_o_cycle_num1    ;
    real                clk_o_period0,clk_o_period1,clk_o_period,clk_o_period2;
    
    
    `uvm_object_utils(mc_clk_freq_vseq)
    constraint clk_freq_1_c {
        freq_clk_delay_1  inside {[10000:20000]};
    }
    

    function new(string name="mc_clk_freq_vseq");
        super.new(name);
    endfunction

virtual task body();
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    super.body();

    `uvm_info(get_type_name(),"body=====apb_write======start===========",UVM_LOW);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.page_mode_switch.page_mode_switch.write(status,1'b1, UVM_FRONTDOOR);//cfg close_page
    m_frame_agent_if.performance_test_en = 1;
    
    #1us;
    fork 
        begin
            for(int i=0;i<'d2000;i++)begin
                assert(m_frame_cfg.randomize with {
                    cadd                == 0;
                    radd                == i;
                    frame_rw_flag       == 1;   //1:wr 0:rd
                    one_frame_cnt       == 'd64;
                    col_addr_rand_en    == 0;
                    wrap_en             == 0;
                });
                send_one_frame(m_frame_cfg);        
            end 
            m_tb_if.case_finish_flag = 1;
            `uvm_info(get_type_name(),"wr_rd_finish",UVM_LOW);            
        end
        begin
            for(int j=0;j<'d52;j++)begin
                assert(randomize(freq_clk_delay_1));
                randomize(div_cnt_i) with {div_cnt_i inside{[0:51]};};              
                `uvm_info(get_type_name(),$sformatf("Clk freq :freq_clk_delay_1=%d,div_cnt_i=%d",freq_clk_delay_1,div_cnt_i),UVM_LOW);
                repeat(freq_clk_delay_1)@(posedge m_tb_if.clk);
                m_tb_if.cnt_load = 0;  
                #10ns;
                m_tb_if.div_cnt = div_cnt_i; 
                #10ns;
                m_tb_if.cnt_load = 1;
            end
            wait(m_tb_if.case_finish_flag == 1);
        end
        while(1)begin
            @(posedge m_tb_if.clk);
            if(m_tb_if.cnt_load == 0)begin 
                m_tb_if.cycle_640_check_en = 0;
                @(posedge m_tb_if.s_cnt_load_syn);
                repeat(1)@(posedge m_tb_if.clk);
                //@(posedge m_tb_if.cnt_load);
                //repeat(2)@(posedge m_tb_if.clk);
                while(1)begin
                    @(posedge m_tb_if.clk);
                    if(m_tb_if.s_div_cnt == 0 )begin
                        m_tb_if.cycle_640_check_en = 1;
                        `uvm_info(get_type_name(),"cycle_640_check_en_=_1",UVM_LOW);
                        break;
                    end
                end
                cur_div_cnt = m_tb_if.div_cnt;
            end 
            @(negedge m_tb_if.clk);
            case(cur_div_cnt)
                'd0      :      exp_cycle_ns =  1.25      ;
                'd1      :      exp_cycle_ns =  1.269     ;   
                'd2      :      exp_cycle_ns =  1.290     ; //{{{
                'd3      :      exp_cycle_ns =  1.311     ;
                'd4      :      exp_cycle_ns =  1.333     ;
                'd5      :      exp_cycle_ns =  1.355     ;
                'd6      :      exp_cycle_ns =  1.379     ;
                'd7      :      exp_cycle_ns =  1.403     ;
                'd8      :      exp_cycle_ns =  1.428     ;
                'd9      :      exp_cycle_ns =  1.454     ;
                'd10     :      exp_cycle_ns =  1.481     ;
                'd11     :      exp_cycle_ns =  1.509     ;
                'd12     :      exp_cycle_ns =  1.538     ;
                'd13     :      exp_cycle_ns =  1.568     ;
                'd14     :      exp_cycle_ns =  1.6       ;
                'd15     :      exp_cycle_ns =  1.632     ;
                'd16     :      exp_cycle_ns =  1.666     ;
                'd17     :      exp_cycle_ns =  1.702     ;
                'd18     :      exp_cycle_ns =  1.739     ;
                'd19     :      exp_cycle_ns =  1.777     ;
                'd20     :      exp_cycle_ns =  1.818     ;
                'd21     :      exp_cycle_ns =  1.860     ;
                'd22     :      exp_cycle_ns =  1.904     ;
                'd23     :      exp_cycle_ns =  1.951     ;
                'd24     :      exp_cycle_ns =  2         ;
                'd25     :      exp_cycle_ns =  2.051     ;
                'd26     :      exp_cycle_ns =  2.105     ;
                'd27     :      exp_cycle_ns =  2.162     ;
                'd28     :      exp_cycle_ns =  2.222     ;
                'd29     :      exp_cycle_ns =  2.285     ;
                'd30     :      exp_cycle_ns =  2.352     ;
                'd31     :      exp_cycle_ns =  2.424     ;
                'd32     :      exp_cycle_ns =  2.5       ;
                'd33     :      exp_cycle_ns =  2.580     ;
                'd34     :      exp_cycle_ns =  2.666     ;
                'd35     :      exp_cycle_ns =  2.758     ;
                'd36     :      exp_cycle_ns =  2.857     ;
                'd37     :      exp_cycle_ns =  2.962     ;
                'd38     :      exp_cycle_ns =  3.076     ;
                'd39     :      exp_cycle_ns =  3.2       ;
                'd40     :      exp_cycle_ns =  3.333     ;
                'd41     :      exp_cycle_ns =  3.478     ;
                'd42     :      exp_cycle_ns =  3.636     ;
                'd43     :      exp_cycle_ns =  3.809     ;
                'd44     :      exp_cycle_ns =  4         ;
                'd45     :      exp_cycle_ns =  4.210     ;
                'd46     :      exp_cycle_ns =  4.444     ;
                'd47     :      exp_cycle_ns =  4.705     ;
                'd48     :      exp_cycle_ns =  5         ;
                'd49     :      exp_cycle_ns =  7.272       ;
                'd50     :      exp_cycle_ns =  10          ;
                'd51     :      exp_cycle_ns =  16          ;
            endcase     //}}}

            if(cur_div_cnt == 0)begin
                exp_broaden_cycle0 = 1.25;
            end
            else if((cur_div_cnt>='d1) && (cur_div_cnt<='d32))begin
                exp_broaden_cycle0 = 2.5;
            end
            else if((cur_div_cnt>='d33) && (cur_div_cnt<='d42))begin
                exp_broaden_cycle0 = 2.5;
                exp_broaden_cycle1 = 3.75;
            end
            else if((cur_div_cnt>='d43) && (cur_div_cnt<='d47))begin
                exp_broaden_cycle0 = 3.75;
                exp_broaden_cycle1 = 5;
            end
            else if((cur_div_cnt>='d43) && (cur_div_cnt<='d47))begin
                exp_broaden_cycle0 = 3.75;
                exp_broaden_cycle1 = 5;
            end
            else if(cur_div_cnt == 48)begin
                exp_broaden_cycle0 = 5;
            end
            else if(cur_div_cnt == 49)begin
                exp_broaden_cycle0 = 6.25;
                exp_broaden_cycle1 = 7.5;
            end
            else if(cur_div_cnt == 50)begin
                exp_broaden_cycle0 = 10;
            end
            else if(cur_div_cnt == 51)begin
                exp_broaden_cycle0 = 15;
                exp_broaden_cycle1 = 16.25;
            end 
        end 
        while(1)begin
            if(m_tb_if.cycle_640_check_en == 1)begin
                if(clk_o_cycle_num == 0)begin
                    @(posedge m_array_agent_if.clk);
                    clk_o_time_pos0 = $realtime;
                    //@(negedge m_array_agent_if.clk);
                    //clk_o_time_neg0 = $realtime;            
                    //@(posedge m_array_agent_if.clk);
                    //clk_o_time_pos1 = $realtime;
                    clk_o_cycle_num ++;
                end 
                else begin
                    //clk_o_time_pos0 = clk_o_time_pos1;
                    //@(negedge m_tb_if.clk);
                    //clk_o_time_neg0 = $realtime;            
                    @(posedge m_array_agent_if.clk);
                    clk_o_time_pos1 = $realtime;
                    clk_o_cycle_num ++;
                end 
                clk_o_period = clk_o_time_pos1 - clk_o_time_pos0 ;
                if(clk_o_period == 800)begin
                    clk_o_cycle_num1 = clk_o_cycle_num -1;
                    clk_o_period0 = 800/clk_o_cycle_num1;
                    if(clk_o_period0 > exp_cycle_ns)begin
                        clk_o_period1 = clk_o_period0 - exp_cycle_ns;
                    end
                    else begin
                        clk_o_period1 = exp_cycle_ns - clk_o_period0;                        
                    end
                    clk_o_period2 = clk_o_period1*1000;
                    if(clk_o_period2  > 10)begin
                        `uvm_error(get_type_name(), $sformatf("clk_period*640 not is exp:clk_o_time_pos0=%0f,clk_o_time_pos1=%0f,clk_o_period0=%0f,exp_cycle_ns=%0f,clk_o_period2=%0f,clk_o_cycle_num1=%0d",clk_o_time_pos0,clk_o_time_pos1,clk_o_period0,exp_cycle_ns,clk_o_period2,clk_o_cycle_num1));
                    end 
                    else begin
                        `uvm_info(get_type_name(), $sformatf("clk_period*640 not is exp:clk_o_time_pos0=%0f,clk_o_time_pos1=%0f,clk_o_period0=%0f,exp_cycle_ns=%0f,clk_o_period2=%0f,clk_o_cycle_num1=%0d",clk_o_time_pos0,clk_o_time_pos1,clk_o_period0,exp_cycle_ns,clk_o_period2,clk_o_cycle_num1),UVM_LOW);
                    end
                    clk_o_cycle_num = 0;
                end
            end           
            else begin
                @(negedge m_tb_if.clk); 
                clk_o_cycle_num = 0;
            end
        end
        while(1)begin
            if(clk_cycle_num == 0)begin
                @(posedge m_array_agent_if.clk);
                clk_time_pos0 = $realtime;
                @(negedge m_array_agent_if.clk);
                clk_time_neg0 = $realtime;            
                @(posedge m_array_agent_if.clk);
                clk_time_pos1 = $realtime;
                clk_cycle_num ++;
            end 
            else begin
                clk_time_pos0 = clk_time_pos1;
                @(negedge m_array_agent_if.clk);
                clk_time_neg0 = $realtime;            
                @(posedge m_array_agent_if.clk);
                clk_time_pos1 = $realtime;
                clk_cycle_num ++;
            end
            clk_period0 = clk_time_neg0 - clk_time_pos0;
            clk_period1 = clk_time_pos1 - clk_time_neg0;
            clk_period = clk_period0 + clk_period1;
            if(clk_period != 1.25)begin
                if(clk_period > 1.25)begin
                    if(clk_period == exp_broaden_cycle0 || clk_period == exp_broaden_cycle1)begin    
                        `uvm_info(get_type_name(),$sformatf("clk_period=%d",clk_period),UVM_LOW);  
                    end 
                    else begin
                        `uvm_error(get_type_name(), $sformatf("clk_period not is exp:clk_period=%0f,exp_broaden_cycle0=%0f,exp_broaden_cycle1=%0f",clk_period,exp_broaden_cycle0,exp_broaden_cycle1));
                    end
                end
                else begin
                    `uvm_error(get_type_name(), $sformatf("clk_period not is exp:clk_period=%0f",clk_period));
                end
            end
        end
    join_any

    `uvm_info(get_type_name(),"body====frame_write=======================finish==========",UVM_LOW);
    #1us; 

endtask

endclass


`endif

