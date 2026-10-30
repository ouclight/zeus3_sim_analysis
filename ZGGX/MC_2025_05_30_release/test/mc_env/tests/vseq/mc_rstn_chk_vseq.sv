`ifndef MC_RSTN_CHK_VSEQ
`define MC_RSTN_CHK_VSEQ

class mc_rstn_chk_vseq extends mc_common_vseq;

    `uvm_object_utils(mc_rstn_chk_vseq)
        
    function new(string name="mc_rstn_chk_vseq");
        super.new(name);
    endfunction

    localparam                  RADDR_NUM=7360;
    localparam                  CADDR_NUM=130;
    localparam                  BURST_WIDTH=128;

   //frame cfg
    rand bit            frame_rw_flag   ;
    rand bit            wrap_en         ;
    rand bit            col_addr_rand_en;
    rand bit [15:0]     one_frame_cnt   ;
    rand bit [`COL_ADDR_WIDTH-1:0]      cadd            ;
    rand bit [`ROW_ADDR_WIDTH-1:0]     radd            ;

    rand int            rst_delay_time  ;
    rand int            rst_wr_delay_time;


    //vmc config
    randc bit [`COLUMN_ADDR_WIDTH-1:0]            err_csl_reg_gen;     
    randc bit [`ROW_ADDR_WIDTH-1:0]               err_row_reg_gen;      //row err addr reg, 0~63

    //page param
    rand bit            pre_precharge_en;
    rand bit            page_mode;

    //refresh cfg
    rand bit            refresh_type    ;   //0:soc refresh;    1:mc local refresh
    rand bit            global_rf_sel_en;
    rand bit            global_rf_sel   ;
    rand bit            mc_rf_cfg_sel   ;
    rand bit            wait_rf_cnt;        //wait rf_cnt

    rand bit [`ROW_ADDR_WIDTH-1:0]  rf_start_addr;
    rand bit [`ROW_ADDR_WIDTH-1:0]  rf_end_addr;
    rand bit [31:0]                 period;
    rand bit [31:0]                 rf_start_time;

    rand bit                        performance_test_en;
    rand bit                        rst_mode;   //0:sys rst; 1:sys && apb rst


    extern virtual task body();
    extern task reset_connective_check(string reset_name,bit exp_value);   //reset_name:  "apb_reset" or "mc_reset"
    extern task reset_release_check(string release_name);       //release_name: "apb_release" or "mc_release"
    extern task reset_vmc_config();


    constraint c_rst_delay_time{
        rst_delay_time inside {[1:100]};
    }

    constraint c_rst_wr_delay_time{
        rst_wr_delay_time inside {[100:10000]};
    }

    constraint c_radd { 
        radd    inside {[0:RADDR_NUM-65]};
    }

    constraint c_err_row_reg_gen { 
        err_row_reg_gen    inside {[0:RADDR_NUM-1]};
    }

    constraint c_err_csl_reg_gen { 
        err_csl_reg_gen    inside {[0:CADDR_NUM-1]};
    }

    constraint c_one_frame_cnt { 
        solve wrap_en before one_frame_cnt;
        if(wrap_en == 1){one_frame_cnt inside {[BURST_WIDTH:BURST_WIDTH]};}
        else {one_frame_cnt inside {[1:BURST_WIDTH]};}
    }

    constraint c_cadd { 
        solve wrap_en before cadd;
        solve col_addr_rand_en before cadd;
        solve one_frame_cnt before cadd;
        if(col_addr_rand_en == 0 &&  wrap_en==0){cadd inside {[0:BURST_WIDTH-one_frame_cnt]};}        
    }

    //------------- constraint refresh param -------------
    constraint c_rf_statr_addr{
        rf_start_addr inside {[0:RADDR_NUM-2]};
    }

    constraint c_rf_end_addr{
        solve rf_start_addr before rf_end_addr;
        rf_end_addr inside {[1:RADDR_NUM-1]};
        rf_end_addr > rf_start_addr;
    }

    //64ms:32'h30d4000, 32ms:32'h186a000, 16ms:32'hc35000, 8ms:32'h61a800, 4ms:32'h30d400; 1ms:32'hc3500
    constraint c_period{
        period dist {'h30d4000:=20, 'h186a000:=20, 'hc35000:=20, 'h61a800:=20, 'h30d400:=20, 'hc3500:=20};
    }
    
    constraint c_rf_start_time{
        solve period before rf_start_time;
        rf_start_time < period;
    }



endclass:mc_rstn_chk_vseq

task mc_rstn_chk_vseq::body();
    bit [2:0]   reset_chk_times;
    bit         rst_ongoing_flag;
    bit [31:0]  current_period;
    bit [31:0]  current_start_time;

    event       get_refresh;
    bit [31:0]  current_rf_cnt;
    super.body();

    uvm_hdl_read("mc_tb.u_tb_if.reset_chk_times",reset_chk_times);
    uvm_hdl_read("mc_tb.u_tb_if.rst_ongoing_flag",rst_ongoing_flag);

    //m_tb_if.error_inject=1'b1;
    m_tb_if.reset_vseq=1'b1;

    //page mode
    `uvm_info("page mode switch", $sformatf("initial page_mode_switch to %s", page_mode? "close page": "open page"), UVM_LOW)
    @(posedge m_tb_if.pclk);
    m_tb_if.page_mode_switch = page_mode;

    //pre_precharge_en
    @(posedge m_tb_if.pclk);
    @(posedge m_tb_if.pclk);
    m_tb_if.pre_precharge = pre_precharge_en;
    `uvm_info("open page", $sformatf("pre_precharge_en is %0b",pre_precharge_en),UVM_LOW)

    m_frame_agent_if.performance_test_en =   performance_test_en;
    assert(randomize() with{
        //wait_rf_cnt == 0;
    });

    `uvm_info(get_type_name(),$sformatf("reset mode is %0d",rst_mode),UVM_LOW)

    //reset for 4 times: 1.reset connective check; 2.reset during writing; 3.reset during reading; 4.reset during refreshing
    `uvm_info(get_type_name(),$sformatf("\n ===========================mc_rstn_chk_vseq body %0d times start=============================",reset_chk_times[2:0]), UVM_LOW);

    //======================================== 1. reset connective check ==============================================

    `uvm_info("reset_connective_check", "\n----------------------- below is reset_connective_check! --------------------",UVM_LOW)
    `uvm_info("reset_connective_check", "reset_connective_check begin reset",UVM_LOW)
    //first reset 

    #1us
    uvm_hdl_deposit("mc_tb.apb_rst_n",0);
    #1ps            
    reset_connective_check("apb_reset",0);
    //reset_connective_check("mc_reset",1);

    #10ns
    uvm_hdl_deposit("mc_tb.rst_n",0);
    #1ps
    reset_connective_check("mc_reset",0);

    //uvm_hdl_deposit("mc_tb.u_tb_if.rst_ongoing_flag",1'b1);

    `uvm_info("reset_connective_check", "reset_connective_check begin release",UVM_LOW)
    //first reset release check
    #10ns 
    fork
        #1ns uvm_hdl_deposit("mc_tb.apb_rst_n",1);
        reset_release_check("apb_release");
    join

    #10ns
    fork
        #1ns uvm_hdl_deposit("mc_tb.rst_n",1);
        reset_release_check("mc_release");
    join

    //uvm_hdl_deposit("mc_tb.u_tb_if.reset_chk_times",3'b001);
    //uvm_hdl_deposit("mc_tb.u_tb_if.rst_ongoing_flag",1'b0);



    //================================================ 2. writing reset========================================================
    `uvm_info("reset during writing", "\n----------------------- below is reset during writing! --------------------",UVM_LOW)

    //randomize m_frame_cfg
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
    repeat(4) @(posedge m_tb_if.clk);

    //================================================ dram initial check ===================================================
    `ifndef NO_INIT
    fork 
        begin
            fork 
                begin
                    for(int ii=0;ii<RADDR_NUM-64;ii++)begin
                        for (int jj=0; jj<CADDR_NUM-2; jj++) begin
                            @(negedge m_array_agent_if.gcas_wr);
                            if(ii != m_array_agent_if.gradd_n)  `uvm_error(get_type_name(),$sformatf("error gradd, exp is %0h, act is %0h", ii, m_array_agent_if.gradd_n))
                            if(jj != m_array_agent_if.gcadd)  `uvm_error(get_type_name(),$sformatf("error gcadd, exp is %0h, act is %0h", jj, m_array_agent_if.gcadd))
                        end
                    end
                end
                begin
                    repeat($urandom_range(2000)) @(posedge m_tb_if.clk);
                    #rst_delay_time;
                    uvm_hdl_deposit("mc_tb.rst_n",0);
                    if(rst_mode)    uvm_hdl_deposit("mc_tb.apb_rst_n",0);
                end
            join_any
            disable fork;
        end
    join

    `uvm_info("reset during initial", "begin reset release!",UVM_LOW)
    fork 
        #1ns uvm_hdl_deposit("mc_tb.apb_rst_n",1);
        #1ns uvm_hdl_deposit("mc_tb.rst_n",1);
        if (rst_mode) reset_release_check("apb_release");
        reset_release_check("mc_release");
    join

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
    repeat(4) @(posedge m_tb_if.clk);

    for(int ii=0;ii<RADDR_NUM-64;ii++)begin
        for (int jj=0; jj<CADDR_NUM-2; jj++) begin
            @(negedge m_array_agent_if.gcas_wr);
            if(ii != m_array_agent_if.gradd_n)  `uvm_error(get_type_name(),$sformatf("error gradd, exp is %0h, act is %0h", ii, m_array_agent_if.gradd_n))
            if(jj != m_array_agent_if.gcadd)  `uvm_error(get_type_name(),$sformatf("error gcadd, exp is %0h, act is %0h", jj, m_array_agent_if.gcadd))
        end
    end
    `endif

    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rdrdy_n_en.mc_rdrdy_n_en.write(status,1'h0, UVM_FRONTDOOR);
    assert(m_frame_cfg.randomize() with{
        m_frame_cfg.frame_rw_flag       == 1'b1;
        //m_frame_cfg.col_addr_rand_en    == local::col_addr_rand_en;
        //m_frame_cfg.wrap_en             == local::wrap_en;
        //m_frame_cfg.cadd                == local::cadd;
        //m_frame_cfg.radd                == local::radd;
        //m_frame_cfg.one_frame_cnt       == local::one_frame_cnt;
    });

    `uvm_info(get_full_name(),$sformatf("send read frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);

    //-------------------------------- reset when writing ----------------------------
    `uvm_info("reset during writing", "begin send frame and reset!",UVM_LOW)
    fork 
        send_one_frame(m_frame_cfg);
        begin
            #rst_delay_time;
            uvm_hdl_deposit("mc_tb.rst_n",0);
            if(rst_mode)    uvm_hdl_deposit("mc_tb.apb_rst_n",0);
        end
    join
    //uvm_hdl_deposit("mc_tb.u_tb_if.rst_ongoing_flag",1'b1);
    //-------------------------------- release --------------------------------------
    `uvm_info("reset during writing", "begin reset release!",UVM_LOW)
    fork 
        #1ns uvm_hdl_deposit("mc_tb.apb_rst_n",1);
        #1ns uvm_hdl_deposit("mc_tb.rst_n",1);
        if (rst_mode) reset_release_check("apb_release");
        reset_release_check("mc_release");
    join

    //-------------------------------- send normally writing ------------------------
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
    wait(m_tb_if.mc_dram_init_wr_finish == 1);
    repeat(20) @(posedge m_tb_if.clk)

    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rdrdy_n_en.mc_rdrdy_n_en.write(status,1'h0, UVM_FRONTDOOR);
    `uvm_info("reset during writing", "begin send frame after release!",UVM_LOW)
    send_one_frame(m_frame_cfg);
    assert(m_frame_cfg.randomize()); 
    send_one_frame(m_frame_cfg);
    assert(m_frame_cfg.randomize()); 
    send_one_frame(m_frame_cfg);
    assert(m_frame_cfg.randomize()); 
    send_one_frame(m_frame_cfg);

    #10000ns
    

    //uvm_hdl_deposit("mc_tb.u_tb_if.reset_chk_times",3'b010);
    //uvm_hdl_deposit("mc_tb.u_tb_if.rst_ongoing_flag",1'b0);

    //================================================ 3. reading reset========================================================
    `uvm_info("reset during reading", "\n----------------------- below is reset during reading! --------------------",UVM_LOW)
    //randomize m_frame_cfg
    assert(m_frame_cfg.randomize() with{
        m_frame_cfg.frame_rw_flag       == 1'b0;
        //m_frame_cfg.col_addr_rand_en    == local::col_addr_rand_en;
        //m_frame_cfg.wrap_en             == local::wrap_en;
        //m_frame_cfg.cadd                == local::cadd;
        //m_frame_cfg.radd                == local::radd;
        //m_frame_cfg.one_frame_cnt       == local::one_frame_cnt;
    });


    `uvm_info(get_full_name(),$sformatf("send read frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);

    //---------------------------- reset when send reading ---------------------------
    `uvm_info("reset during reading", "begin send frame and reset", UVM_LOW)
    fork 
        send_one_frame(m_frame_cfg);
        begin
            #rst_delay_time;
            uvm_hdl_deposit("mc_tb.rst_n",0);
            if(rst_mode)    uvm_hdl_deposit("mc_tb.apb_rst_n",0);

        end
    join
    //uvm_hdl_deposit("mc_tb.u_tb_if.rst_ongoing_flag",1'b1);

    //---------------------------- release -------------------------------------
    `uvm_info("reset during reading", "begin release", UVM_LOW)
    fork 
        #1ns uvm_hdl_deposit("mc_tb.apb_rst_n",1);
        #1ns uvm_hdl_deposit("mc_tb.rst_n",1);
        if (rst_mode) reset_release_check("apb_release");
        reset_release_check("mc_release");
    join

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
    wait(m_tb_if.mc_dram_init_wr_finish == 1);
    repeat(20) @(posedge m_tb_if.clk)

    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rdrdy_n_en.mc_rdrdy_n_en.write(status,1'h0, UVM_FRONTDOOR);
    //---------------------------- send normally reading -----------------------
    `uvm_info("reset during reading", "begin send frame after release", UVM_LOW)
    send_one_frame(m_frame_cfg);
    assert(m_frame_cfg.randomize()); 
    send_one_frame(m_frame_cfg);
    assert(m_frame_cfg.randomize()); 
    send_one_frame(m_frame_cfg);
    assert(m_frame_cfg.randomize()); 
    send_one_frame(m_frame_cfg);

    #10000ns

    //uvm_hdl_deposit("mc_tb.u_tb_if.reset_chk_times",3'b011);
    //uvm_hdl_deposit("mc_tb.u_tb_if.rst_ongoing_flag",1'b0);

    `uvm_info("reset during reading", "\n----------------------- below is reset during rand wr or rd! --------------------",UVM_LOW)
    //randomize m_frame_cfg
    assert(m_frame_cfg.randomize() with{
        //m_frame_cfg.frame_rw_flag       == 1'b0;
        //m_frame_cfg.col_addr_rand_en    == local::col_addr_rand_en;
        //m_frame_cfg.wrap_en             == local::wrap_en;
        //m_frame_cfg.cadd                == local::cadd;
        //m_frame_cfg.radd                == local::radd;
        //m_frame_cfg.one_frame_cnt       == local::one_frame_cnt;
    });


    `uvm_info(get_full_name(),$sformatf("send read frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);

    //---------------------------- reset when send wr or rd ---------------------------
    `uvm_info("reset during reading", "begin send frame and reset", UVM_LOW)
    //if ($urandom_range(1)) begin
    if ($urandom_range(1)) begin
        //config vmc
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h0, UVM_FRONTDOOR);
        reset_vmc_config();
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
        repeat(50) @(posedge m_tb_if.clk);
    end

    fork:reset_wr_rd 
        while(1) begin
            assert(m_frame_cfg.randomize()); 
            send_one_frame(m_frame_cfg);
        end
        begin
            #rst_wr_delay_time;
            uvm_hdl_deposit("mc_tb.rst_n",0);
            if(rst_mode)    uvm_hdl_deposit("mc_tb.apb_rst_n",0);

        end
    join_any
    disable reset_wr_rd;

    //uvm_hdl_deposit("mc_tb.u_tb_if.rst_ongoing_flag",1'b1);

    //---------------------------- release -------------------------------------
    `uvm_info("reset during reading", "begin release", UVM_LOW)
    fork 
        #1ns uvm_hdl_deposit("mc_tb.apb_rst_n",1);
        #1ns uvm_hdl_deposit("mc_tb.rst_n",1);
        if (rst_mode) reset_release_check("apb_release");
        reset_release_check("mc_release");
    join

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
    wait(m_tb_if.mc_dram_init_wr_finish == 1);
    repeat(4) @(posedge m_tb_if.clk)

    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rdrdy_n_en.mc_rdrdy_n_en.write(status,1'h0, UVM_FRONTDOOR);
    //---------------------------- send normally wr or rd -----------------------
    `uvm_info("reset during reading", "begin send frame after release", UVM_LOW)
    send_one_frame(m_frame_cfg);
    assert(m_frame_cfg.randomize()); 
    send_one_frame(m_frame_cfg);
    assert(m_frame_cfg.randomize()); 
    send_one_frame(m_frame_cfg);
    assert(m_frame_cfg.randomize()); 
    send_one_frame(m_frame_cfg);

    #10000ns


    //================================================ 4. refresh reset========================================================
    `uvm_info("reset during refreshing", "\n----------------------- below is reset during refreshing! --------------------",UVM_LOW)

    @(posedge m_tb_if.pclk);
    m_tb_if.mc_rf_start_sel = refresh_type;    //0:interface, 1:reg
    m_tb_if.mc_rf_period_sel = refresh_type;    //0:interface, 1:reg
    m_tb_if.rf_range_change_en = 1;

    m_tb_if.global_rf_sel_en = global_rf_sel_en;
    @(posedge m_tb_if.clk);
    m_tb_if.global_rf_sel    = global_rf_sel;
    assert(randomize(rf_start_addr,rf_end_addr));
    `uvm_info(get_type_name(),$sformatf("rf_start_addr is %0h, rf_end_addr is %0h",rf_start_addr,rf_end_addr),UVM_LOW)
    m_tb_if.rf_addr =  {rf_start_addr,rf_end_addr}; 

    if (refresh_type) begin
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_rf_cfg_sel.write(status, mc_rf_cfg_sel, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_period_cfg1_reg.write(status, period, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_start_cfg1_reg.write(status, rf_start_time, UVM_FRONTDOOR);

        if (global_rf_sel_en) begin
            if (!global_rf_sel) begin
                current_period      =   period;
                current_start_time  =   rf_start_time;
            end
        end
        else begin
            if (!mc_rf_cfg_sel) begin
                current_period      =   period;
                current_start_time  =   rf_start_time;
            end
        end

        assert(randomize(period, rf_start_time));
        `uvm_info(get_type_name(),$sformatf("for cfg2, period is %0h, rf_start_time is %0h",period, rf_start_time),UVM_LOW)
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_period_cfg2_reg.write(status, period, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rf_start_cfg2_reg.write(status, rf_start_time, UVM_FRONTDOOR);

        if (global_rf_sel_en) begin
            if (global_rf_sel) begin
                current_period      =   period;
                current_start_time  =   rf_start_time;
            end
        end
        else begin
            if (mc_rf_cfg_sel) begin
                current_period      =   period;
                current_start_time  =   rf_start_time;
            end
        end
    end

    else begin
        m_tb_if.rf_period       =   period;
        m_tb_if.rf_start_time   =   rf_start_time;
        current_period      =   period;
        current_start_time  =   rf_start_time;
    end


    #100ns;

    //start refresh
    @(posedge m_tb_if.clk);
    m_tb_if.mc_rf_start = 1'b1;

    //randomize m_frame_cfg
    assert(m_frame_cfg.randomize());

    `uvm_info(get_full_name(),$sformatf("send read frame: m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);

    `uvm_info("reset during refreshing", "begin refresh and reset", UVM_LOW)

    fork
        begin
            if (wait_rf_cnt) begin
                do begin
                    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt);
                    @(posedge m_tb_if.clk);
                end while(current_rf_cnt != current_start_time);
            end
            else begin
                if (current_start_time > 1000000) begin
                    repeat(10) @(posedge m_tb_if.clk);
                    #1ps;
                    `uvm_info(get_type_name(),"modify rf cnt !!!!", UVM_LOW)
                    uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_start_time - 10);
                end
                else begin
                    do begin
                        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt);
                        @(posedge m_tb_if.clk);
                    end while(current_rf_cnt != current_start_time);
                end
            end
            repeat(20) @(posedge m_tb_if.clk);
            -> get_refresh;
        end

        begin
            @(get_refresh)    
            #rst_delay_time;
            @(posedge m_tb_if.clk);
            #1ps;
            uvm_hdl_deposit("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", 32'h0010);
            uvm_hdl_deposit("mc_tb.rst_n",0);
            if(rst_mode)    uvm_hdl_deposit("mc_tb.apb_rst_n",0);
        end
    join
    //uvm_hdl_deposit("mc_tb.u_tb_if.rst_ongoing_flag",1'b1);

    `uvm_info("reset during refreshing", "begin release", UVM_LOW)
    fork 
        #1ns uvm_hdl_deposit("mc_tb.apb_rst_n",1);
        #1ns uvm_hdl_deposit("mc_tb.rst_n",1);
        if (rst_mode) reset_release_check("apb_release");
        reset_release_check("mc_release");
    join
    @(posedge m_tb_if.clk);
    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt);
    if(current_rf_cnt==0)begin
        `uvm_error("rf_cnt_check",$sformatf("current_rf_cnt is %0d", current_rf_cnt))
    end
    @(posedge m_tb_if.pclk);
    m_tb_if.global_dram_init_en[1]=1'b1;
    repeat(10) @(posedge m_tb_if.clk);
    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rf_cnt", current_rf_cnt);
    @(posedge m_tb_if.pclk);
    m_tb_if.global_dram_init_en[1]=1'b0;
    if(current_rf_cnt!=0)begin
        `uvm_error("rf_cnt_check",$sformatf("current_rf_cnt is %0d", current_rf_cnt))
    end
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h1, UVM_FRONTDOOR);
    wait(m_tb_if.mc_dram_init_wr_finish == 1);
    repeat(4) @(posedge m_tb_if.clk)

    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_rdrdy_n_en.mc_rdrdy_n_en.write(status,1'h0, UVM_FRONTDOOR);
    `uvm_info("reset during refreshing", "begin send frame after release", UVM_LOW)
    send_one_frame(m_frame_cfg);
    assert(m_frame_cfg.randomize()); 
    send_one_frame(m_frame_cfg);
    assert(m_frame_cfg.randomize()); 
    send_one_frame(m_frame_cfg);
    assert(m_frame_cfg.randomize()); 
    send_one_frame(m_frame_cfg);

    //uvm_hdl_deposit("mc_tb.u_tb_if.reset_chk_times",3'b111);
    //uvm_hdl_deposit("mc_tb.u_tb_if.rst_ongoing_flag",1'b0);
        

    #10000ns
    `uvm_info(get_type_name(),"\n===========================mc_rstn_chk_vseq body done=============================",UVM_LOW)
endtask:body

task mc_rstn_chk_vseq::reset_connective_check(string reset_name, bit exp_value);

    bit read_value;

    //--------------------- apb_reset -------------------------
    if(reset_name == "apb_reset") begin
        `uvm_info("apb reset connective check", "\n---------------- apb reset connective check start! -----------------", UVM_LOW)
        
        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.apb_rst_n",read_value);
        if (read_value !== exp_value)
            `uvm_error("reset_check",$sformatf("mc_tb.apb_rst_n check failed, exp_value is %0b, act_value is %0d", exp_value, read_value))


        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.apb_rst_n",read_value);
        if (read_value !== exp_value)
            `uvm_error("reset_check",$sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb_rst_n check failed, exp_value is %0b, act_value is %0d", exp_value, read_value))

        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.presetn",read_value);
        if (read_value !== exp_value)
            `uvm_error("reset_check",$sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.presetn check failed, exp_value is %0b, act_value is %0d", exp_value, read_value))

        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_pe_top_cfg_if_u.presetn",read_value);
        if (read_value !== exp_value)
            `uvm_error("reset_check",$sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_pe_top_cfg_if_u.presetn check failed, exp_value is %0b, act_value is %0d", exp_value, read_value))

        for (int i=0;i<3;i++) begin
            uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.ipdb_pulse2pulse_inst_u%0d.rst1_n", i), read_value);
            if (read_value !== exp_value)
                `uvm_error("reset_check",$sformatf("m_mc_wrapper_aux.mc_top_u.ipdb_pulse2pulse_inst_u%0d.rst1_n check failed, exp_value is %0b, act_value is %0d", i, exp_value, read_value))
        end

        `uvm_info("apb reset connective check", "\n---------------- apb reset connective check end! -----------------", UVM_LOW)

    end //apb_reset

    //------------------------- mc_reset -----------------------
    else if (reset_name == "mc_reset") begin

        `uvm_info("mc reset connective check", "\n---------------- mc reset connective check start! -----------------", UVM_LOW)
        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.rst_n", read_value);
        if (read_value !== exp_value)
            `uvm_error("reset_check",$sformatf("m_mc_wrapper_aux.rst_n check failed, exp_value is %0b, act_value is %0d", exp_value, read_value))

        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_frame_debug_u.rst_n",read_value);
        if (read_value !== exp_value)
            `uvm_error("reset_check",$sformatf("mc_tb.mc_frame_debug_u.rst_n check failed, exp_value is %0b, act_value is %0d", exp_value, read_value))

        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.rst_n", read_value);
        if (read_value !== exp_value)
            `uvm_error("reset_check",$sformatf("m_mc_wrapper_aux.mc_top_u.rst_n check failed, exp_value is %0b, act_value is %0d", exp_value, read_value))

        for (int i=0;i<3;i++) begin
            uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.U%0d_mc_ctrl_DW_sync.rst_d_n", i), read_value);
            if (read_value !== exp_value)
                `uvm_error("reset_check",$sformatf("m_mc_wrapper_aux.mc_top_u.U%0d_mc_ctrl_DW_sync.rst_d_n check failed, exp_value is %0b, act_value is %0d", i, exp_value, read_value))
        end

        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.rst_n", read_value);
        if (read_value !== exp_value)
            `uvm_error("reset_check",$sformatf("m_mc_wrapper_aux.mc_top_u.bist_scan_u.rst_n check failed, exp_value is %0b, act_value is %0d", exp_value, read_value))

        for (int i=0;i<3;i++) begin
            uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.ipdb_pulse2pulse_inst_u%0d.rst2_n", i), read_value);
            if (read_value !== exp_value)
                `uvm_error("reset_check",$sformatf("m_mc_wrapper_aux.mc_top_u.ipdb_pulse2pulse_inst_u%0d.rst2_n check failed, exp_value is %0b, act_value is %0d", i, exp_value, read_value))
        end

        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.mc_frame2frame_u.rst_n", read_value);
        if (read_value !== exp_value)
            `uvm_error("reset_check",$sformatf("m_mc_wrapper_aux.mc_top_u.mc_frame2frame_u.rst_n check failed, exp_value is %0b, act_value is %0d", exp_value, read_value))

        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.rst_n", read_value);
        if (read_value !== exp_value)
            `uvm_error("reset_check",$sformatf("m_mc_wrapper_aux.mc_top_u.frame_arbiter_u.rst_n check failed, exp_value is %0b, act_value is %0d", exp_value, read_value))

        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.mc_timeout_u.rst_n", read_value);
        if (read_value !== exp_value)
            `uvm_error("reset_check",$sformatf("m_mc_wrapper_aux.mc_top_u.mc_timeout_u.rst_n check failed, exp_value is %0b, act_value is %0d", exp_value, read_value))

        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.frame2array_u.rst_n", read_value);
        if (read_value !== exp_value)
            `uvm_error("reset_check",$sformatf("m_mc_wrapper_aux.mc_top_u.frame2array_u.rst_n check failed, exp_value is %0b, act_value is %0d", exp_value, read_value))

        `uvm_info("mc reset connective check", "\n---------------- mc reset connective check end! -----------------", UVM_LOW)
    end //mc_reset

    else begin
        $display("ERROR:reset_name is not match, input is %s, expected name is \"apb_reset\" or \"mc_reset\"! ", reset_name);
        return;
    end

endtask:reset_connective_check

task mc_rstn_chk_vseq::reset_release_check(string release_name);

    real clk_pos_time;
    real reset_recover_time;
    event get_release;

    //apb_release
    if (release_name == "apb_release") begin
        fork
            begin
                fork:wait_apb_release
                    while(1) begin
                        @(posedge p_sequencer.m_tb_if.pclk)         clk_pos_time = $realtime;
                        //$display("clk_pos_time is %t", clk_pos_time);
                    end

                    begin
                        @(get_release);
                        $display("clk_pos_time is %t", clk_pos_time);
                    end
                join_any
                disable fork;
            end

            begin
                @(posedge p_sequencer.m_tb_if.mc_apb_rst_n)    reset_recover_time = $realtime;
                $display("reset_recover_time is %t", reset_recover_time);
                -> get_release;
            end
        join
    end //apb_release

    //mc_release
    else if (release_name == "mc_release") begin
        fork
            begin
                fork:wait_mc_release
                    while(1) begin
                        @(posedge m_tb_if.clk)         clk_pos_time = $realtime;
                    end

                    begin
                        @(get_release);
                        $display("clk_pos_time is %t", clk_pos_time);
                    end
                join_any
                disable fork;
            end

            begin
                @(posedge p_sequencer.m_tb_if.mc_sys_rst_n)    reset_recover_time = $realtime;
                $display("reset_recover_time is %t", reset_recover_time);
                -> get_release;
            end
        join
 
    end //mc_release

    else begin
        $display("ERROR:release_name is not match, input is %s, expected name is \"apb_release\" or \"mc_release\"! ", release_name);
        return;
    end

    //check
    if (clk_pos_time != reset_recover_time)
        `uvm_error("reset_release_check",$sformatf("%s check error, clk posedge time is %t, reset_recover_time is %t", release_name, clk_pos_time, reset_recover_time))
    else
        `uvm_info("reset_release_check",$sformatf("one %s check pass",release_name),UVM_LOW)

endtask:reset_release_check

task mc_rstn_chk_vseq::reset_vmc_config();
    //for coverage

    bit [`ROW_ADDR_WIDTH-1:0]       err_row_reg_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_reg0_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_reg1_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_reg2_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_reg3_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_reg4_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_reg5_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_reg6_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_reg7_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_reg8_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_reg9_q[$];

    for (int i=0;i<2;i++) begin
        assert(randomize(err_csl_reg_gen));
        err_csl_reg0_q.push_back(err_csl_reg_gen);
    end
    err_csl_reg0_q.sort();

    for (int i=0;i<2;i++) begin
        assert(randomize(err_csl_reg_gen));
        err_csl_reg1_q.push_back(err_csl_reg_gen);
    end
    err_csl_reg1_q.sort();

    for (int i=0;i<2;i++) begin
        assert(randomize(err_csl_reg_gen));
        err_csl_reg2_q.push_back(err_csl_reg_gen);
    end
    err_csl_reg2_q.sort();

    for (int i=0;i<2;i++) begin
        assert(randomize(err_csl_reg_gen));
        err_csl_reg3_q.push_back(err_csl_reg_gen);
    end
    err_csl_reg3_q.sort();

    for (int i=0;i<2;i++) begin
        assert(randomize(err_csl_reg_gen));
        err_csl_reg4_q.push_back(err_csl_reg_gen);
    end
    err_csl_reg4_q.sort();

    for (int i=0;i<2;i++) begin
        assert(randomize(err_csl_reg_gen));
        err_csl_reg5_q.push_back(err_csl_reg_gen);
    end
    err_csl_reg5_q.sort();

    for (int i=0;i<2;i++) begin
        assert(randomize(err_csl_reg_gen));
        err_csl_reg6_q.push_back(err_csl_reg_gen);
    end
    err_csl_reg6_q.sort();

    for (int i=0;i<2;i++) begin
        assert(randomize(err_csl_reg_gen));
        err_csl_reg7_q.push_back(err_csl_reg_gen);
    end
    err_csl_reg7_q.sort();

    for (int i=0;i<2;i++) begin
        assert(randomize(err_csl_reg_gen));
        err_csl_reg8_q.push_back(err_csl_reg_gen);
    end
    err_csl_reg8_q.sort();

    for (int i=0;i<2;i++) begin
        assert(randomize(err_csl_reg_gen));
        err_csl_reg9_q.push_back(err_csl_reg_gen);
    end
    err_csl_reg9_q.sort();

    for (int i=0;i<64;i++) begin
        assert(randomize(err_row_reg_gen));
        err_row_reg_q.push_back(err_row_reg_gen);
    end
    err_row_reg_q.sort();

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part0.write(status, err_csl_reg0_q[0], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part0.write(status, err_csl_reg0_q[1], UVM_FRONTDOOR);

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part1.write(status, err_csl_reg1_q[0], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part1.write(status, err_csl_reg1_q[1], UVM_FRONTDOOR);

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part2_reg.write(status, err_csl_reg2_q[0], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part2_reg.write(status, err_csl_reg2_q[1], UVM_FRONTDOOR);

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part3_reg.write(status, err_csl_reg3_q[0], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part3_reg.write(status, err_csl_reg3_q[1], UVM_FRONTDOOR);

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part4_reg.write(status, err_csl_reg4_q[0], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part4_reg.write(status, err_csl_reg4_q[1], UVM_FRONTDOOR);

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part5_reg.write(status, err_csl_reg5_q[0], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part5_reg.write(status, err_csl_reg5_q[1], UVM_FRONTDOOR);

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part6_reg.write(status, err_csl_reg6_q[0], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part6_reg.write(status, err_csl_reg6_q[1], UVM_FRONTDOOR);

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part7_reg.write(status, err_csl_reg7_q[0], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part7_reg.write(status, err_csl_reg7_q[1], UVM_FRONTDOOR);

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part8_reg.write(status, err_csl_reg8_q[0], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part8_reg.write(status, err_csl_reg8_q[1], UVM_FRONTDOOR);

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part9_reg.write(status, err_csl_reg9_q[0], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part9_reg.write(status, err_csl_reg9_q[1], UVM_FRONTDOOR);

    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num0.write(status, err_row_reg_q[0], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num1.write(status, err_row_reg_q[1], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num2.write(status, err_row_reg_q[2], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num3.write(status, err_row_reg_q[3], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num4.write(status, err_row_reg_q[4], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num5.write(status, err_row_reg_q[5], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num6.write(status, err_row_reg_q[6], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num7.write(status, err_row_reg_q[7], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num8.write(status, err_row_reg_q[8], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num9.write(status, err_row_reg_q[9], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num10.write(status, err_row_reg_q[10], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num11.write(status, err_row_reg_q[11], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num12.write(status, err_row_reg_q[12], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num13.write(status, err_row_reg_q[13], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num14.write(status, err_row_reg_q[14], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num15.write(status, err_row_reg_q[15], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num16.write(status, err_row_reg_q[16], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num17.write(status, err_row_reg_q[17], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num18.write(status, err_row_reg_q[18], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num19.write(status, err_row_reg_q[19], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num20.write(status, err_row_reg_q[20], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num21.write(status, err_row_reg_q[21], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num22.write(status, err_row_reg_q[22], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num23.write(status, err_row_reg_q[23], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num24.write(status, err_row_reg_q[24], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num25.write(status, err_row_reg_q[25], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num26.write(status, err_row_reg_q[26], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num27.write(status, err_row_reg_q[27], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num28.write(status, err_row_reg_q[28], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num29.write(status, err_row_reg_q[29], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num30.write(status, err_row_reg_q[30], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num31.write(status, err_row_reg_q[31], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num32.write(status, err_row_reg_q[32], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num33.write(status, err_row_reg_q[33], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num34.write(status, err_row_reg_q[34], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num35.write(status, err_row_reg_q[35], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num36.write(status, err_row_reg_q[36], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num37.write(status, err_row_reg_q[37], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num38.write(status, err_row_reg_q[38], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num39.write(status, err_row_reg_q[39], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num40.write(status, err_row_reg_q[40], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num41.write(status, err_row_reg_q[41], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num42.write(status, err_row_reg_q[42], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num43.write(status, err_row_reg_q[43], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num44.write(status, err_row_reg_q[44], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num45.write(status, err_row_reg_q[45], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num46.write(status, err_row_reg_q[46], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num47.write(status, err_row_reg_q[47], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num48.write(status, err_row_reg_q[48], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num49.write(status, err_row_reg_q[49], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num50.write(status, err_row_reg_q[50], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num51.write(status, err_row_reg_q[51], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num52.write(status, err_row_reg_q[52], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num53.write(status, err_row_reg_q[53], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num54.write(status, err_row_reg_q[54], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num55.write(status, err_row_reg_q[55], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num56.write(status, err_row_reg_q[56], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num57.write(status, err_row_reg_q[57], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num58.write(status, err_row_reg_q[58], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num59.write(status, err_row_reg_q[59], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num60.write(status, err_row_reg_q[60], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num61.write(status, err_row_reg_q[61], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num62.write(status, err_row_reg_q[62], UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num63.write(status, err_row_reg_q[63], UVM_FRONTDOOR);


    //vmc enable
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_wl_vmc_en.write(status,1'b1, UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_bl_vmc_en.write(status,1'b1, UVM_FRONTDOOR);


        
endtask:reset_vmc_config
`endif
