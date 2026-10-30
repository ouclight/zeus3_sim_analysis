`ifndef MC_BIST_RD_TIMEOUT_VSEQ
`define MC_BIST_RD_TIMEOUT_VSEQ

class mc_bist_rd_timeout_vseq extends mc_common_vseq;

    `uvm_object_utils(mc_bist_rd_timeout_vseq)

    function new(string name="mc_bist_rd_timeout_vseq");
        super.new(name);
    endfunction

    rand bit [`PATTERN_WIDTH-1:0]   bist_pattern[64];
    rand bit [6:0]                  bist_wl_scan_num   ;
    rand bit [6:0]                  bist_csl_scan_num   ;
    rand bit [31:0]                 bist_timeout_th;
    rand bit                        page_mode;

    constraint c_bist_wl_scan_num{
        bist_wl_scan_num inside {[1:64]};
    }

    constraint c_bist_csl_scan_num{
        bist_csl_scan_num inside {[1:64]};
    }

    constraint c_bist_timeout_th{
        bist_timeout_th inside {['d490000:'d500000]};     // >608us (486400),refresh used time

    }

    extern virtual task body();

endclass:mc_bist_rd_timeout_vseq

task mc_bist_rd_timeout_vseq::body();

    bit             mc_timeout_flag;
    bit             bist_finish;
    bit             bank_success;
    bit             mc_bist_path_fail;
    uvm_reg_data_t  timeout_data;

    super.body();

    //uvm_hdl_deposit("mc_tb.u_quad_group.bank0.ram_memory[0]",0);
    uvm_hdl_deposit("mc_tb.u_quad_group.XBK0.memory[0]",0);
    //------------------------------------- config --------------------------------------
    foreach (bist_pattern[j]) begin
        m_tb_if.bist_pattern[j] = bist_pattern[j];
        $display("bist_pattern%0d is %0h", j, m_tb_if.bist_pattern[j]);
    end

    assert(randomize()with{
        //bist_wl_scan_num    == 1;
        //bist_csl_scan_num   == 1;
        //bist_timeout_th     == 'd600_000;
    });

    `uvm_info(get_type_name(),$sformatf("bist_timeout_th is 0x%0h",bist_timeout_th),UVM_LOW)


    //close scb gradd check
    m_tb_if.bist_test_en = 1'b1;

    //timeout threshold
    m_tb_if.mc_timeout_th = bist_timeout_th;

    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_en.write(status,1'h1, UVM_FRONTDOOR);
    @(posedge m_tb_if.pclk);
    m_tb_if.mc_scan_timeout_en  =   1;

    //bist_scan_num
    m_tb_if.bist_wl_scan_num = bist_wl_scan_num;
    m_tb_if.bist_csl_scan_num = bist_csl_scan_num;
    `uvm_info(get_type_name(),$sformatf("bist_wl_scan_num is %0d",bist_wl_scan_num),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("bist_csl_scan_num is %0d",bist_csl_scan_num),UVM_LOW)
 
    //close page
    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.page_mode_switch.write(status, page_mode, UVM_FRONTDOOR);
    @(posedge m_tb_if.pclk);
    m_tb_if.page_mode_switch = page_mode;

    //mc_en
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status, 1'b1,UVM_FRONTDOOR);
    //global_mc_bist_en
    @(posedge m_tb_if.pclk);
    m_tb_if.global_mc_bist_en = 1'b1;

    `uvm_info(get_type_name(), "\n--------------- mc_bist_rd_timeout_vseq start! ----------------", UVM_LOW)
    //global_mc_bist_start
    @(posedge m_tb_if.pclk);
    m_tb_if.global_mc_bist_start = 1'b1;
    @(posedge m_tb_if.pclk);
    m_tb_if.global_mc_bist_start = 1'b0;

    //----------- error injection ----------------
    fork
        begin
            @(posedge m_array_agent_if.gcas_rd);
            `uvm_info(get_type_name(),"start error injection",UVM_LOW)
        end

        begin
            while (1) begin
                `uvm_info(get_type_name(),"waitting for error injection...",UVM_LOW)
                repeat(10)@(posedge m_tb_if.clk);
            end
        end
    join_any
    disable fork;

    //stop rdrdy_n
    uvm_hdl_force("mc_tb.m_mc_wrapper_aux.rdrdy_n",1'b1);
    repeat(10)@(posedge m_tb_if.clk);
    //uvm_hdl_release("mc_tb.m_mc_wrapper_aux.rdrdy_n");
    //--------------------------------------------
    
    //waitting for timeout_flag
    fork
        begin
        fork
            begin
                do begin
                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_flag.read(status, mc_timeout_flag, UVM_FRONTDOOR);  //read or peek
                end while(mc_timeout_flag != 1'b1);
                `uvm_info(get_type_name(),"bist timeout_flag has be 1'b1!", UVM_LOW)
            end

            begin
                #(bist_timeout_th*1.25);
                repeat(10) @(posedge m_tb_if.pclk);
                `uvm_error(get_type_name(),"Timeout!!!! waitting for timeout_flag")
            end
        join_any
        disable fork;

        end
    join

    //check bist_finish, bank_success, timeout data
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish.read(status, bist_finish, UVM_FRONTDOOR);
    if(bist_finish != 1'b1)
        `uvm_error(get_type_name(),$sformatf("when timeout_flag is %0d, bist_finish is %0d",mc_timeout_flag,bist_finish))

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_status_reg.mc_bist_path_fail.read(status, mc_bist_path_fail, UVM_FRONTDOOR);
    if(mc_bist_path_fail != 1'b1)
        `uvm_error(get_type_name(),$sformatf("when timeout_flag is %0d, bist_path_fail is %0d",mc_timeout_flag,mc_bist_path_fail))

    //check success
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bank_success.read(status, bank_success,UVM_FRONTDOOR);
    if(bank_success != 1'b0)
        `uvm_error(get_type_name(),$sformatf("when timeout_flag is %0d, bank_success is %0d",mc_timeout_flag,bank_success))


    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_bank_scan.bank_scan_rdata",timeout_data);    
    if(timeout_data != 'h0123456789abcdef)
        `uvm_error(get_type_name(),$sformatf("when timeout_flag is %0d, timeout_data is %0h",mc_timeout_flag,timeout_data))

    //check clear
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_clr.write(status, 1'b1, UVM_FRONTDOOR);
    repeat(10) @(posedge m_tb_if.pclk);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_flag.read(status, mc_timeout_flag, UVM_FRONTDOOR);
    if (mc_timeout_flag != 1'b0)
        `uvm_error(get_type_name(),"timeout_flag is not cleared!")

    ////----------- start a bist scan with no injection --------------

    ////global_mc_bist_start
    //@(posedge m_tb_if.pclk);
    //m_tb_if.global_mc_bist_start = 1'b1;
    //@(posedge m_tb_if.pclk);
    //m_tb_if.global_mc_bist_start = 1'b0;


    ////waitting for bist finish
    //do begin
    //    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish.read(status, bist_finish, UVM_FRONTDOOR);  //read or peek
    //end while(bist_finish != 1'b1);

endtask:body
`endif 
