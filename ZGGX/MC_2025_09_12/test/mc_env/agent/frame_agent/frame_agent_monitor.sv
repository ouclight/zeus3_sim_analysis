`ifndef FRAME_AGENT_MONITOR_SV
`define FRAME_AGENT_MONITOR_SV

class frame_agent_monitor extends uvm_monitor;
    `uvm_component_utils(frame_agent_monitor)

    virtual interface  frame_agent_if vif;
    virtual interface  tb_if          m_tb_if;

    uvm_analysis_port #(frame_agent_trans) ap_w;
    uvm_analysis_port #(frame_agent_trans) ap_r;
    
    frame_agent_trans m_trans_w;
    frame_agent_trans m_trans_r;
    logic [21:0]    bank_array_araddr_q[$];
    bit             cmp_en = 1;
    
    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);

    extern task main_phase(uvm_phase phase);
    extern task reset_phase(uvm_phase phase);    
    extern task do_mon();

endclass : frame_agent_monitor 

function frame_agent_monitor::new(string name, uvm_component parent);

    super.new(name, parent);
    ap_w = new("ap_w", this);
    ap_r = new("ap_r", this);
endfunction : new

function void frame_agent_monitor::build_phase(uvm_phase phase);

    super.build_phase(phase);

endfunction : build_phase

function void frame_agent_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (!uvm_config_db #(virtual frame_agent_if)::get(this, "*", "frame_agent_vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})

    if(!uvm_config_db#(virtual tb_if)::get(this, "", "vif_tb", m_tb_if)) begin
        `uvm_fatal("GETINTF", {"Could not get m_tb_if at ", get_full_name()})
    end
    uvm_config_db#(bit)::get(this, "", "cmp_en", cmp_en);

endfunction : connect_phase

task frame_agent_monitor::reset_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "reset_phase", UVM_HIGH)
    super.reset_phase(phase);
    
    bank_array_araddr_q.delete();

endtask : reset_phase



task frame_agent_monitor::main_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "main_phase", UVM_HIGH)

    m_trans_w = frame_agent_trans::type_id::create("m_trans_w");
    m_trans_r = frame_agent_trans::type_id::create("m_trans_r");
    
    do_mon();

endtask : main_phase

task frame_agent_monitor::do_mon();
    //-------------------------------------------- modified by hy @20250108 (change rdata check) ------------------------------------------
    `ifdef NO_INIT
        logic [271:0]   write_data_store [bit[21:0]];
    `else
        bit [271:0]   write_data_store [bit[21:0]];
    `endif
    logic           read_rdy_flag_store [bit[21:0]];

    //logic [20:0]    bank_array_waddr_q[$];
    logic [21:0]    bank_array_addr_q[$];
    logic [21:0]    bank_array_addr;
    logic           bank_array_rw_q[$];
    bit             bank_array_rw;
    logic [271:0]   bank_array_wdata_q[$];
    //bit   [265:0]   write_data_store_tmp [bit[20:0]];

    logic [21:0]    bank_array_waddr,bank_array_araddr;
    logic [271:0]   exp_rdata,act_rdata;
    logic [21:0]    exp_bank_array_araddr;
    bit   [20:0]    index;
    bit   [31:0]    cnt1=0;
    bit   [31:0]    cnt2=0;
    fork
        while(1)begin
            wait(m_tb_if.mc_sys_rst_n===1'b1);
            @(posedge vif.clk);
            while((vif.mc_frame_vld&&vif.mc_frame_rdy)!==1'b1) @(posedge vif.clk);
            if(vif.mc_frame_data[296] === 1'b1 && m_tb_if.mc_sys_rst_n === 1'b1)begin //write
                m_trans_w.mc_frame_data = vif.mc_frame_data;
                bank_array_waddr = {vif.mc_frame_data[21:20], vif.mc_frame_data[19:0]};

                if(vif.mc_frame_data[296] === 1'b1 && vif.mc_frame_data[297] === 1'b1)begin //write
                    bank_array_addr_q.push_back(bank_array_waddr);
                    bank_array_rw_q.push_back(1);
                    bank_array_wdata_q.push_back(vif.mc_frame_data[293:22]);
                end

                if(m_tb_if.debug_test_en == 0)begin
                    ap_w.write(m_trans_w);
                    `uvm_info("frame_mon", $sformatf("send one write trans to scb"), UVM_MEDIUM);
                end
                //if(bank_array_waddr inside bank_array_araddr_q)begin
                //    //write_data_store_tmp[bank_array_waddr] = vif.mc_frame_data[275:20];
                //    if(m_tb_if.debug_test_en == 0)begin
                //        ap_w.write(m_trans_w);
                //        `uvm_info("frame_mon", $sformatf("send one_tmp write trans to scb,%0h",bank_array_waddr), UVM_MEDIUM);
                //    end
                //end
                //else begin    
                //    //write_data_store[bank_array_waddr] = vif.mc_frame_data[275:20];
                //    if(m_tb_if.debug_test_en == 0)begin
                //        ap_w.write(m_trans_w);
                //        `uvm_info("frame_mon", $sformatf("send one write trans to scb"), UVM_MEDIUM);
                //    end
                //end
            end
            //else if(vif.mc_frame_data[289:279] === 2'b10)begin //read
            else if(vif.mc_frame_data[296] === 1'b0 && m_tb_if.mc_sys_rst_n === 1'b1)begin
                m_trans_r.mc_frame_data =   vif.mc_frame_data;
                bank_array_araddr = {vif.mc_frame_data[21:20], vif.mc_frame_data[19:0]};

                if(vif.mc_frame_data[296] === 1'b0 && vif.mc_frame_data[297] === 1'b1)begin//read
                    bank_array_araddr_q.push_back(bank_array_araddr);
                    bank_array_addr_q.push_back(bank_array_araddr);
                    bank_array_rw_q.push_back(0);
                end

                if(m_tb_if.debug_test_en == 0)begin                
                    ap_r.write(m_trans_r);
                    `uvm_info("frame_mon", $sformatf("send one read trans to scb"), UVM_MEDIUM);                    
                end                
            end
        end
        while(1)begin
            if(bank_array_addr_q.size > 0) begin
                bank_array_addr  =   bank_array_addr_q.pop_front;
                bank_array_rw    =   bank_array_rw_q.pop_front;
                case (read_rdy_flag_store[bank_array_addr])
                    1'b0: begin
                        //`uvm_info("fram_mon",$sformatf("debug111,bank_array_rw is %0d", bank_array_rw),UVM_LOW)
                        wait(read_rdy_flag_store[bank_array_addr]);
                        #1ps;
                        read_rdy_flag_store[bank_array_addr]     =   1;
                        //`uvm_info("fram_mon",$sformatf("debug111,bank_array_rw is %0d", bank_array_rw),UVM_LOW)

                        if (bank_array_rw)
                            write_data_store[bank_array_addr]    =   bank_array_wdata_q.pop_front;
                        else 
                            read_rdy_flag_store[bank_array_addr]     =   0;

                    end

                    1'b1: begin
                        if (bank_array_rw) begin
                            write_data_store[bank_array_addr]    =   bank_array_wdata_q.pop_front;
                            read_rdy_flag_store[bank_array_addr]       =  1;
                            //`uvm_info("fram_mon",$sformatf("debug222,bank_array_rw is %0d", bank_array_rw),UVM_LOW)
                        end

                        else begin
                            read_rdy_flag_store[bank_array_addr]       =  0;
                            //`uvm_info("fram_mon",$sformatf("debug222,bank_array_rw is %0d", bank_array_rw),UVM_LOW)
                        end
                    end

                    1'bx: begin
                        if (bank_array_rw) begin
                            write_data_store[bank_array_addr]    =   bank_array_wdata_q.pop_front;
                            read_rdy_flag_store[bank_array_addr]       =   1;
                        end
                        else begin
                            read_rdy_flag_store[bank_array_addr]       =   0;
                        end
                    end

                    default:
                        `uvm_error("fram_mon", $sformatf("rw_flag is not right, is %0b", read_rdy_flag_store[bank_array_addr]))
                endcase
            end
            else  @(posedge vif.clk);
        end
        while(1)begin
            wait(m_tb_if.mc_sys_rst_n===1'b1);
            if(!cmp_en) begin
                @(posedge vif.clk);
                break;
            end
            @(posedge vif.clk);
            while(vif.mc_rvalid!==1'b1) @(posedge vif.clk);
            if(m_tb_if.error_inject==0)begin
                //if(bank_array_araddr_q.size > 0)begin
                //    exp_bank_array_araddr = bank_array_araddr_q.pop_front();
                //end
                //else begin
                //    `uvm_error("frame_mon", $sformatf("frame_rdata_num greater than frame_read_req"));                
                //end

                //if (bank_array_waddr_q.size()>0) begin
                //    foreach(bank_array_waddr_q[i]) begin
                //        if (bank_array_waddr_q[i] === exp_bank_array_araddr) begin
                //            exp_rdata = write_data_store[exp_bank_array_araddr];
                //            raddr_hit_waddr  =  1;
                //            break;
                //        end

                //    end

                //    if (raddr_hit_waddr == 0) begin
                //        exp_rdata = 266'hx;
                //    end

                //    raddr_hit_waddr =   0;
                //end

                //else begin
                //    exp_rdata = 266'hx;
                //end
                //
                //if(m_tb_if.debug_test_en == 1)begin //debug_test_mode                           
                //    exp_rdata[265] = 1;                
                //    exp_rdata[264:8] = 0;
                //end
                //act_rdata = vif.mc_rdata;
                //`uvm_info("frame_mon", $sformatf("frame_rdata_check \n exp_rdata=%0h \n act_rdata=%0h",exp_rdata,act_rdata), UVM_MEDIUM);
                //if(exp_rdata !== act_rdata)
                //    `uvm_error("frame_mon", $sformatf("rdata not equal wdata,exp_rdata=0x%h,act_rdata=0x%h,exp_bank_array_araddr=0x%h",exp_rdata,act_rdata,exp_bank_array_araddr))
                //if(write_data_store_tmp.size()!=0&&bank_array_araddr_q.size==0)begin
                //    foreach(write_data_store_tmp[index])begin
                //        write_data_store[index] = write_data_store_tmp[index];
                //    end
                //    write_data_store_tmp.delete();
                //end

                if(bank_array_araddr_q.size > 0)begin
                    exp_bank_array_araddr = bank_array_araddr_q.pop_front();
                end
                else begin
                    `uvm_error("frame_mon", $sformatf("frame_rdata_num greater than frame_read_req"));                
                    continue;
                end

                exp_rdata = write_data_store[exp_bank_array_araddr];

                if(m_tb_if.debug_test_en == 1)begin //debug_test_mode                           
                    exp_rdata[271:256] = 0;    //modified by hy @20250118          
                    //exp_rdata[264:8] = 0;
                    if(m_tb_if.debug_rd_without_wr) exp_rdata[255:0] = {32{8'h5a}};
                    else exp_rdata[255:0] = {32{exp_rdata[7:0]}};
                end

                if(m_tb_if.invert_en)
                    act_rdata = {16'h0, vif.mc_rdata[271:16]};
                else
                    act_rdata = vif.mc_rdata;

                `uvm_info("frame_mon", $sformatf("frame_rdata_check \n exp_rdata=%0h \n act_rdata=%0h",exp_rdata,act_rdata), UVM_MEDIUM);
                if(exp_rdata[255:0] !== act_rdata[255:0]  && m_tb_if.timeout_case == 0)
                    `uvm_error("frame_mon", $sformatf("rdata not equal wdata,exp_rdata=0x%h,act_rdata=0x%h,exp_bank_array_araddr=0x%h",exp_rdata,act_rdata,exp_bank_array_araddr))

                if(m_tb_if.invert_en || m_tb_if.chkbit) begin
                    if(exp_rdata[271:256] !== act_rdata[271:256])
                        `uvm_error("frame_mon", $sformatf("rdata not equal wdata,exp_rdata=0x%h,act_rdata=0x%h,exp_bank_array_araddr=0x%h",exp_rdata,act_rdata,exp_bank_array_araddr))
                end

                read_rdy_flag_store[exp_bank_array_araddr]  =   1;

                if(vif.mc_rresp !== 2'b00 && vif.mc_rresp !== 2'b01)
                    `uvm_error("", $sformatf("frame rresp fail! %0h", vif.mc_rresp))
            end
        end
        //while(1)begin
        //    @(posedge vif.clk);
        //    if(vif.mc_frame_vld==1&&vif.mc_frame_data[296]==0&&m_tb_if.debug_test_en == 1&&vif.performance_test_en==1)begin
        //        repeat(1)  @(posedge vif.clk);
        //        if(vif.mc_rvalid!=1)begin
        //            `uvm_error("frame_mon", "rdata not return in one cycle")
        //        end
        //    end
        //end
        while(m_tb_if.error_inject==0)begin
            wait(m_tb_if.mc_sys_rst_n===1'b1);
            @(negedge vif.clk);
            if((vif.mc_bresp_vld&&vif.mc_bresp_rdy)===1'b1)begin
                cnt1 = cnt1+1;
                //$display("cnt1 is %0d, time is %t", cnt1, $realtime);
            end
        end
        while(m_tb_if.error_inject==0)begin
            wait(m_tb_if.mc_sys_rst_n===1'b1);
            @(negedge vif.clk);
            if((vif.mc_frame_vld&&vif.mc_frame_rdy)===1'b1)begin
                if(((vif.mc_frame_data[296] === 1'b1)&&(vif.mc_frame_data[297] === 1'b1))||((vif.mc_frame_data[296] === 1'b1)&&(vif.mc_frame_data[297] === 1'b0)&&(m_tb_if.mc_fake_bresp_en==1)))begin //write
                    cnt2 = cnt2+1;
                    //$display("cnt2 is %0d, time is %t", cnt2, $realtime);
                end
            end
        end
        while(m_tb_if.error_inject==0)begin
            wait(m_tb_if.mc_sys_rst_n===1'b1);
            @(posedge vif.clk);
            while((vif.mc_frame_vld&&vif.mc_frame_rdy)!==1'b1) @(posedge vif.clk);
            if(((vif.mc_frame_data[296] === 1'b1)&&(vif.mc_frame_data[297] === 1'b1))||((vif.mc_frame_data[296] === 1'b1)&&(vif.mc_frame_data[297] === 1'b0)&&(m_tb_if.mc_fake_bresp_en==1)))begin //write
                @(posedge vif.clk);
                if(vif.mc_bresp_vld != 1 && m_tb_if.mc_sys_rst_n === 1'b1)begin
                    `uvm_error(get_full_name(), "don't recieve rsp")
                end
            end
        end
        while(m_tb_if.error_inject==0)begin
            wait(m_tb_if.mc_sys_rst_n===1'b1);
            @(negedge vif.clk);
            if((vif.mc_frame_vld&&vif.mc_frame_rdy)===1'b1)begin
                @(negedge vif.mc_bresp_vld);
                #1ps;
                if(cnt1 != cnt2 && m_tb_if.mc_sys_rst_n === 1'b1)begin
                    `uvm_error(get_full_name(), $sformatf("send num is %d, rsp num is %d",cnt2,cnt1))
                end
			    /*if(vif.mc_frame_data[296] === 1'b1)begin //write
                    @(negedge vif.clk);
                    #1ps;
                    if(cnt1 != cnt2 && m_tb_if.mc_sys_rst_n === 1'b1)begin
                        `uvm_error(get_full_name(), $sformatf("send num is %d, rsp num is %d",cnt2,cnt1))
                    end
                end*/
           end
        end
        while(1)begin
            @(negedge m_tb_if.mc_sys_rst_n); 
            #1ps;
            cnt1    =   0;
            cnt2    =   0;
            bank_array_araddr_q.delete();
            foreach(write_data_store[i]) begin
                write_data_store[i] =   'hx;
            end
            foreach(read_rdy_flag_store[i]) begin
                read_rdy_flag_store[i]  =   'hx;
            end
        end
        while(1)begin
            if(m_tb_if.mc_sys_rst_n === 0 || !m_tb_if.mc_en) begin
                cnt1    =   0;
                cnt2    =   0;
                bank_array_araddr_q.delete();
                foreach(write_data_store[i]) begin
                    write_data_store[i] =   'hx;
                end
                foreach(read_rdy_flag_store[i]) begin
                    read_rdy_flag_store[i]  =   'hx;
                end
            end
            
            #0.625ns;
        end
    join

endtask : do_mon

function void frame_agent_monitor::report_phase(uvm_phase phase);
     
    if(m_tb_if.monitor_enable) begin
        if(bank_array_araddr_q.size > 0)    `uvm_error(get_full_name(), $sformatf("bank_array_araddr_q.size=%0d > 0, is %0h",bank_array_araddr_q.size, bank_array_araddr_q[0]))
    end

endfunction



`endif // FRAME_AGENT_MONITOR_SV


