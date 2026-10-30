`ifndef MC_BIST_RESCAN_VSEQ
`define MC_BIST_RESCAN_VSEQ

class mc_bist_rescan_vseq extends mc_common_vseq;

    `uvm_object_utils(mc_bist_rescan_vseq)

    function new(string name="mc_bist_rescan_vseq");
        super.new();
    endfunction

    localparam      COL_ALL_NUM='d130;
    localparam      COL_NUM='d128;
    localparam      BIST_WL_NUM='d300;
    localparam      WR_WL_NUM='d300;

    localparam      ERR_CSL_DEFAULT_VALUE='hff;
    localparam      ERR_WL_DEFAULT_VALUE='h1fff;

    localparam      BURST_WIDTH='d128;
    //bist param
    rand bit [`PATTERN_WIDTH-1:0]   bist_pattern[64];
    rand bit [7:0]                  bist_csl_scan_num;
    rand bit [7:0]                  bist_wl_scan_num;
    rand bit [4:0]                  csl_err_threshold;
    rand bit                        bist_finish_mask;
    rand bit [3:0]                  bist_wl_scan_single_pattern_rd_num;

    //bist rescan
    rand bit [3:0]                  bist_rescan_num;        //default 3,max 8
    rand bit                        bist_rescan_mask;
    rand int                        err_rescan_bit_index;
    rand bit                        err_rescan_mode;        //1: current turn rescan has err_inject; 0: no err_inject



    rand bit [`ROW_ADDR_WIDTH-1:0]                 radd_up_down[10];

    //err_inject
    rand int                        num_csl_err_inject;
    rand bit [2:0]                  err_mode;
    rand bit                        serial_err_wl_inject_mode;
    rand bit                        case_mode;      //0:only rescan;    1:bist and then rescan
    rand int                        first_bist_err_wl_num;

    //page_mode
    rand bit            pre_precharge_en;
    rand bit            page_mode;

    rand bit            performance_test_en;

    //frame param
    rand bit                        frame_rw_flag;
    rand bit                        wrap_en;
    rand bit                        col_addr_rand_en;
    rand bit [15:0]                 one_frame_cnt;
    rand bit [`COL_ADDR_WIDTH-1:0]                 cadd;
    rand bit [`ROW_ADDR_WIDTH-1:0]                 radd;

    //array param
    rand bit [`COLUMN_ADDR_WIDTH-1:0]   cadd_array;

    constraint c_radd_up_down{
        radd_up_down[0] dist {[0:(BIST_WL_NUM/10 - 1)]:/70, 0:/15, (BIST_WL_NUM/10-1):/15};
        radd_up_down[1] dist {[(BIST_WL_NUM*1/10):(BIST_WL_NUM*2/10)-1]:/70, (BIST_WL_NUM/10):/15, (BIST_WL_NUM*2/10-1):/15};
        radd_up_down[2] dist {[(BIST_WL_NUM*2/10):(BIST_WL_NUM*3/10)-1]:/70, (BIST_WL_NUM*2/10):/15, (BIST_WL_NUM*3/10-1):/15};
        radd_up_down[3] dist {[(BIST_WL_NUM*3/10):(BIST_WL_NUM*4/10)-1]:/70, (BIST_WL_NUM*3/10):/15, (BIST_WL_NUM*4/10-1):/15};
        radd_up_down[4] dist {[(BIST_WL_NUM*4/10):(BIST_WL_NUM*5/10)-1]:/70, (BIST_WL_NUM*4/10):/15, (BIST_WL_NUM*5/10-1):/15};
        radd_up_down[5] dist {[(BIST_WL_NUM*5/10):(BIST_WL_NUM*6/10)-1]:/70, (BIST_WL_NUM*5/10):/15, (BIST_WL_NUM*6/10-1):/15};
        radd_up_down[6] dist {[(BIST_WL_NUM*6/10):(BIST_WL_NUM*7/10)-1]:/70, (BIST_WL_NUM*6/10):/15, (BIST_WL_NUM*7/10-1):/15};
        radd_up_down[7] dist {[(BIST_WL_NUM*7/10):(BIST_WL_NUM*8/10)-1]:/70, (BIST_WL_NUM*7/10):/15, (BIST_WL_NUM*8/10-1):/15};
        radd_up_down[8] dist {[(BIST_WL_NUM*8/10):(BIST_WL_NUM*9/10)-1]:/70, (BIST_WL_NUM*8/10):/15, (BIST_WL_NUM*9/10-1):/15};
        radd_up_down[9] dist {[(BIST_WL_NUM*9/10):(BIST_WL_NUM*10/10)-1]:/70, (BIST_WL_NUM*9/10):/15, (BIST_WL_NUM*10/10-1):/15};
    }

    constraint c_radd { 
        radd    inside {[0:WR_WL_NUM-65]};
    }

    constraint c_one_frame_cnt { 
        solve wrap_en before one_frame_cnt;
        if(wrap_en == 1){one_frame_cnt == BURST_WIDTH;}
        else {one_frame_cnt inside {[1:BURST_WIDTH]};}
    }

    constraint c_cadd { 
        solve wrap_en before cadd;
        solve col_addr_rand_en before cadd;
        solve one_frame_cnt before cadd;
        if(col_addr_rand_en == 0 &&  wrap_en==0){cadd inside {[0:BURST_WIDTH-one_frame_cnt]};}        
    }

    constraint c_cadd_array{
        cadd_array inside {[0:COL_ALL_NUM-1]};
    }

    constraint c_bist_csl_scan_num{
        bist_csl_scan_num inside {[1:64]};
    }

    constraint c_bist_wl_scan_num{
        bist_wl_scan_num inside {[1:64]};
    }

    constraint c_bist_wl_scan_single_pattern_rd_num{
        bist_wl_scan_single_pattern_rd_num  inside {['d0:'d15]}; 
    }
    
    constraint c_bist_rescan_num{
        ///bist_rescan_num inside {['d1:'d8]};
        bist_rescan_num dist {['d1:'d15]:/50, 'd3:/10, 'd8:/10, 'd15:/10};
    }

    constraint c_err_rescan_bit_index{
        err_rescan_bit_index inside {['d0:'d265]};
    }

    constraint c_csl_err_threshold{
        //csl_err_threshold dist {[1:31]:/50, 'd16:/50 };
        csl_err_threshold dist {[1:29]:/50, 'd16:/50 };
    }

    constraint c_first_bist_err_wl_num{
        if (err_mode == 0 || err_mode == 2) 
            first_bist_err_wl_num dist {[32:64]:/50, 64:/50};
    }

    constraint c_err_mode{
        err_mode inside {[0:4]};    //mode0: err num: csl scan < csl_err_threshold, wl scan < 64;
                                    //mode1: err num: csl scan < csl_err_threshold, wl scan > 64;
                                    //mode2: err num: csl scan > csl_err_threshold, wl scan < 64;
                                    //mode3: err num: csl scan > csl_err_threshold, wl scan > 64;
                                    //else : rand;
    }


    constraint c_num_csl_err_inject{
        solve csl_err_threshold before num_csl_err_inject;
        solve err_mode before num_csl_err_inject;
        if (err_mode == 0)
            num_csl_err_inject dist {0:/95, [1:csl_err_threshold-1]:/5 }; //mode0: err num: csl scan < csl_err_threshold, wl scan < 64;

        else if (err_mode == 1)
            num_csl_err_inject dist {0:/85, [1:csl_err_threshold-1]:/15 }; //mode1: err num: csl scan < csl_err_threshold, wl scan > 64;

        else if (err_mode == 2)
            //num_csl_err_inject dist {0:/80, [1:csl_err_threshold-1]:/10, [csl_err_threshold:32]:/10 }; //mode2: err num: csl scan > csl_err_threshold, wl scan < 64;
            num_csl_err_inject dist {0:/80, [1:csl_err_threshold-1]:/10, [csl_err_threshold:(BIST_WL_NUM/5)]:/10 }; //mode2: err num: csl scan > csl_err_threshold, wl scan < 64;

        else if (err_mode == 3)
            //num_csl_err_inject dist {0:/80, [1:csl_err_threshold-1]:/10, [csl_err_threshold:63]:/10 }; //mode3: err num: csl scan > csl_err_threshold, wl scan > 64;
            num_csl_err_inject dist {0:/80, [1:csl_err_threshold-1]:/10, [csl_err_threshold:(BIST_WL_NUM/5)]:/10 }; //mode3: err num: csl scan > csl_err_threshold, wl scan > 64;

        else
            //num_csl_err_inject dist {0:/180, [1:csl_err_threshold-1]:/10, [csl_err_threshold:63]:/10 }; //rand;
            num_csl_err_inject dist {0:/180, [1:csl_err_threshold-1]:/10, [csl_err_threshold:(BIST_WL_NUM/5)]:/10 }; //rand;

    }


    extern virtual task body();

endclass:mc_bist_rescan_vseq

task mc_bist_rescan_vseq::body();

    bit                                     bist_finish;
    bit                                     bank_success;
    int                                     mc_bist_err_wl_num_reg;
    int                                     mc_bist_err_wl_num_tmp;

    //-------------------- err_addr gen param --------------------------
    int                                     csl_err_num0_q[$];
    int                                     csl_err_num1_q[$];
    int                                     csl_err_num2_q[$];
    int                                     csl_err_num3_q[$];
    int                                     csl_err_num4_q[$];
    int                                     csl_err_num5_q[$];
    int                                     csl_err_num6_q[$];
    int                                     csl_err_num7_q[$];
    int                                     csl_err_num8_q[$];
    int                                     csl_err_num9_q[$];
    int                                     csl_err_num_tmp;

    bit                                     gap_redundant_csl;
    //int                                     max_csl_up_err_num[$];
    //int                                     max_csl_down_err_num[$];
    int                                     num_row_err_addr_vmc=0;

    bit [`ROW_ADDR_WIDTH-1:0]               row_err_addr_q[$];          //log bank err row addr 
    bit [`ROW_ADDR_WIDTH-1:0]               row_err_addr_vmc_q[$];      //log after vmc row addr
    bit [`ROW_ADDR_WIDTH-1:0]               row_err_addr_tmp_q[$];      //one col, tmp err row
    bit [`ROW_ADDR_WIDTH-1:0]               tmp_q[$];                   //tmp line
    int                                     csl_vmc_num[5];             //0:up, 1:down

    bit                                     err_addr[BIST_WL_NUM-1:0][COL_ALL_NUM-1:0];

    //-------------------- err_addr check param ------------------------

    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg0_q[$];      //csl err addr reg, up0, up1
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg1_q[$];      //csl err addr reg, down0, down1
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg2_q[$];      //csl err addr reg, down0, down1
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg3_q[$];      //csl err addr reg, down0, down1
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg4_q[$];      //csl err addr reg, down0, down1
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg5_q[$];      //csl err addr reg, down0, down1
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg6_q[$];      //csl err addr reg, down0, down1
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg7_q[$];      //csl err addr reg, down0, down1
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg8_q[$];      //csl err addr reg, down0, down1
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg9_q[$];      //csl err addr reg, down0, down1

    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg;      
    bit [`ROW_ADDR_WIDTH-1:0]               read_err_row_reg_q[$];      //row err addr reg, 0~63
    bit [`ROW_ADDR_WIDTH-1:0]               read_err_row_reg;      //row err addr reg, 0~63
    bit [265:0]                             err_wr_data;

    bit [`COLUMN_ADDR_WIDTH-1:0]            err_csl_addr;      
    bit [`ROW_ADDR_WIDTH-1:0]               err_row_addr;      


    //-------------------- bist rescan param ------------------------
    bit                                     bist_rescan_finish;
    int                                     err_rescan_total_bit_num;
    int                                     err_rescan_bit_index_q[$];
    bit [19:0]                              mc_bist_rescan_fail_num_reg;

    bit [`ROW_ADDR_WIDTH-1:0]               rescan_radd_check_vmc_add_num;
    bit [`COL_ADDR_WIDTH-1:0]               rescan_cadd_check_vmc_add_num;


    int                                     rescan_read_cnt;
    int                                     rescan_write_cnt;

    string                                  mode_name;
    int                                     loop_times;

    bit                                     clk_gating_check;
    bit                                     dram_init_finish;
    bit                                     bist_rescan_success;
    bit                                     bist_rescan_success_reg;
    bit   [15:0]                            rescan_round_result;
    bit   [15:0]                            rescan_round_result_q[$];
    bit                                     exp_bist_rescan_success;
    event                                   one_rescan_finish;

    super.body();

    //uvm_hdl_deposit("mc_tb.u_quad_group.bank0.ram_memory[0]",0);
    uvm_hdl_deposit("mc_tb.u_quad_group.XBK0.memory[0]",0);

    assert(randomize()with{
        //bist_csl_scan_num   == 1;
        //bist_wl_scan_num    == 1;
        //bist_rescan_num ==15;
        //case_mode   ==  0;
    });

    case(err_mode)
        0:  mode_name   =   "err num: csl scan < csl_err_threshold, wl scan < 64";
        1:  mode_name   =   "err num: csl scan < csl_err_threshold, wl scan > 64";
        2:  mode_name   =   "err num: csl scan > csl_err_threshold, wl scan < 64";
        3:  mode_name   =   "err num: csl scan > csl_err_threshold, wl scan > 64";
        default:    mode_name   =   "rand mode";
    endcase

    //close scb check
    m_tb_if.bist_test_en = 1'b1;

    //rand dbg_data_store_en
    @(posedge m_tb_if.clk);
    m_tb_if.dbg_data_store_en=$urandom_range(1);
    `uvm_info(get_type_name(), $sformatf("dbg_data_store_en is %0b",m_tb_if.dbg_data_store_en),UVM_LOW)

    //bist_finish_mask
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_mask.write(status,bist_finish_mask,UVM_FRONTDOOR);
    `uvm_info(get_type_name(),$sformatf("bist_finish_mask is %0b", bist_finish_mask),UVM_LOW)

    //bist_rescan_mask
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.rescan_finish_mask_reg.rescan_finish_mask.write(status,bist_rescan_mask,UVM_FRONTDOOR);
    `uvm_info(get_type_name(),$sformatf("bist_rescan_mask is %0b", bist_rescan_mask),UVM_LOW)

    //bist_wl_scan_single_pattern_rd_num
    @(posedge m_tb_if.clk);
    m_tb_if.bist_wl_scan_single_pattern_rd_num  =   bist_wl_scan_single_pattern_rd_num;

    //page mode
    `uvm_info("page mode switch", $sformatf("initial page_mode_switch to %s", page_mode? "close page": "open page"), UVM_LOW)
    @(posedge m_tb_if.pclk);
    m_tb_if.page_mode_switch = page_mode;

    //pre_precharge_en
    @(posedge m_tb_if.pclk);
    @(posedge m_tb_if.pclk);
    m_tb_if.pre_precharge = pre_precharge_en;
    `uvm_info("open page", $sformatf("pre_precharge_en is %0b",pre_precharge_en),UVM_LOW)

    //performance_test_en
    m_frame_agent_if.performance_test_en =   performance_test_en;

    //refresh start 
    @(posedge m_tb_if.clk);
    m_tb_if.mc_rf_start = 1'b1;

    //gen bist_pattern
    foreach (bist_pattern[j]) begin
        m_tb_if.bist_pattern[j] = bist_pattern[j];
        $display("bist_pattern%0d is %0h", j, m_tb_if.bist_pattern[j]);
    end

    //---------------------- bist cfg -----------------------------

    m_tb_if.bist_csl_scan_num = bist_csl_scan_num;
    m_tb_if.bist_wl_scan_num  = bist_wl_scan_num;
    m_tb_if.csl_err_threshold = csl_err_threshold;
    
    `uvm_info(get_type_name(),$sformatf("page_mode is %0d, bist_csl_scan_num is %0d, bist_wl_scan_num is %0d, csl_err_threshold is %0d",page_mode, bist_csl_scan_num, bist_wl_scan_num, csl_err_threshold),UVM_LOW)


    //open timeout
    //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_timeout_en.write(status,1'h1, UVM_FRONTDOOR);
    @(posedge m_tb_if.pclk);
    m_tb_if.mc_scan_timeout_en  =   1;

    //mc_en
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status, 1'b1,UVM_FRONTDOOR);

    //global_mc_bist_en
    @(posedge m_tb_if.pclk);
    m_tb_if.global_mc_bist_en = 1'b0;
    #1000ns;

    //when global_mc_bist_en is 0, check rescan clk gating
    for (int i=0;i<5;i++) begin
        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.U_bist_rescan_aux.clk", clk_gating_check);
        if (clk_gating_check == 1)      `uvm_error(get_type_name(),"when global_mc_bist_en is 0, rescan clk not gating")
        #0.313ns;
    end

    //global_mc_bist_en
    @(posedge m_tb_if.pclk);
    m_tb_if.global_mc_bist_en = 1'b1;


    //rescan num
    //m_tb_if.bist_rescan_num =   bist_rescan_num;
    //`uvm_info(get_type_name(),$sformatf("bist_rescan_num is 'd%0d", bist_rescan_num),UVM_LOW)

    if(!case_mode) begin
        //======================================= only bist rescan ===========================================

        //all ram addr 
        //p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_rescan_sel.write(status, 0, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_rescan_addr_range_sel.write(status, 0, UVM_FRONTDOOR);

        for (int kk=0;kk<2;kk++) begin

            //rescan num
            assert(randomize(bist_rescan_num));
            //if (kk==0)
            //    bist_rescan_num = 'd8;
            //else
            //    bist_rescan_num = 'd1;
            m_tb_if.bist_rescan_num =   bist_rescan_num;
            `uvm_info(get_type_name(),$sformatf("bist_rescan_num is 'd%0d", bist_rescan_num),UVM_LOW)

            //-------------------- global_mc_rescan_start -----------------------
            `uvm_info(get_type_name(),"bist rescan start!",UVM_LOW)

            //clear exp varible
            err_rescan_total_bit_num    =   0;
            exp_bist_rescan_success     =   0;

            @(posedge m_tb_if.pclk)
            m_tb_if.global_mc_rescan_start = 1'b1;

            @(posedge m_tb_if.pclk)
            m_tb_if.global_mc_rescan_start = 1'b0;

            `ifndef NO_INIT
            //wait dram_init_finish
            //do begin
            //    repeat (1000) @(posedge m_tb_if.clk);
            //    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_status_reg.dram_init_finish.read(status, dram_init_finish, UVM_FRONTDOOR);
            //end while(dram_init_finish != 1);
            wait(m_tb_if.mc_dram_init_wr_finish == 1);
            repeat(4) @(posedge m_tb_if.clk);
            `endif


            fork
                begin
                    fork
                        begin
                            fork
                                begin
                                    //check rescan reg clr
                                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_rescan_fail_num_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                                    if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_reg.bist_rescan_finish.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                                    if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bank_success_reg.bist_rescan_success.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                                    if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.rescan_round_result_reg.read(status, rescan_round_result, UVM_FRONTDOOR);
                                    if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                                end
                                begin
                                    bist_rescan_success = 1;        //set bist_rescan_success for check
                                    @(posedge m_array_agent_if.gcas_wr);
                                    #1ps;
                                    while(1) begin
                                        if(!($urandom_range(15000)) && err_rescan_mode) begin
                                            //not success
                                            bist_rescan_success = 0;

                                            err_wr_data = m_array_agent_if.wdl;
                                            //uvm_hdl_force("mc_tb.m_mc_wrapper.mc_top_u.frame2array_u.mc_frame_wdata", ~err_wr_data);
                                            loop_times = $urandom_range(1,266);
                                            for (int jj=0;jj< loop_times;jj++) begin
                                                assert(randomize(err_rescan_bit_index));
                                                err_rescan_bit_index_q.push_back(err_rescan_bit_index);
                                            end

                                            err_rescan_bit_index_q.sort();        //debug used


                                            err_rescan_bit_index_q = err_rescan_bit_index_q.unique();

                                            err_rescan_total_bit_num = err_rescan_total_bit_num + err_rescan_bit_index_q.size();
                                            //`uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit num is %0d",m_array_agent_if.gradd_n, m_array_agent_if.gcadd, err_rescan_bit_index_q.size()),UVM_LOW)

                                            //$display("");
                                            //foreach(err_rescan_bit_index_q[i]) begin
                                            //    $write("%0d, ",err_rescan_bit_index_q[i]);
                                            //end
                                            //$display("");

                                            foreach(err_rescan_bit_index_q[i]) begin
                                                err_wr_data[err_rescan_bit_index_q[i]] = ~err_wr_data[err_rescan_bit_index_q[i]];
                                                //`uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit index is %0d",m_array_agent_if.gradd_n, m_array_agent_if.gcadd, err_rescan_bit_index_q[i]),UVM_LOW)
                                            end

                                            uvm_hdl_force("mc_tb.m_mc_wrapper_aux.wdl", err_wr_data);
                                            //`uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h",m_array_agent_if.gradd_n, m_array_agent_if.gcadd),UVM_LOW)
                                            repeat(2) @(posedge m_tb_if.clk);
                                            #1ps;
                                            //uvm_hdl_release("mc_tb.m_mc_wrapper.mc_top_u.frame2array_u.mc_frame_wdata");
                                            uvm_hdl_release("mc_tb.m_mc_wrapper_aux.wdl");
                                            err_rescan_bit_index_q.delete();
                                        end
                                        else begin
                                            @(posedge m_array_agent_if.gcas_wr);
                                            #1ps;
                                        end
                                    end
                                end
                                begin
                                    while(1) begin
                                        @(one_rescan_finish);
                                        assert(randomize(err_rescan_mode));
                                        rescan_round_result_q.push_back(bist_rescan_success);
                                        exp_bist_rescan_success = exp_bist_rescan_success | bist_rescan_success;
                                        `uvm_info(get_type_name(),$sformatf("this turn rescan success is %0d, total success is %0d", bist_rescan_success, exp_bist_rescan_success), UVM_LOW)
                                        bist_rescan_success = 1;        //set bist_rescan_success for check
                                    end
                                end
                                begin
                                    //-------- rescan num check ----------
                                    for(int i=0; i < bist_rescan_num; i++) begin
                                        for(int j=0; j< bist_wl_scan_num ; j++) begin

                                            //write
                                            for (int II=0;II <BIST_WL_NUM;II++) begin
                                                for(int KK=0;KK < COL_ALL_NUM;KK++) begin
                                                    @(negedge m_array_agent_if.gcas_wr);
                                                    if(m_array_agent_if.gradd_n != II)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II, m_array_agent_if.gradd_n))
                                                    if(m_array_agent_if.gcadd != KK)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK, m_array_agent_if.gcadd))
                                                end
                                            end

                                            //read
                                            for (int II=0;II <BIST_WL_NUM;II++) begin
                                                for(int KK=0;KK < COL_ALL_NUM;KK++) begin
                                                    @(negedge m_array_agent_if.gcas_rd);
                                                    if(m_array_agent_if.gradd_n != II)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II, m_array_agent_if.gradd_n))
                                                    if(m_array_agent_if.gcadd != KK)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK, m_array_agent_if.gcadd))
                                                end
                                            end

                                        end

                                        repeat(4) @(posedge m_tb_if.clk);
                                        -> one_rescan_finish;
                                    end
                                end
                            join
                        end
                        do begin
                            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_reg.bist_rescan_finish.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            repeat(1000) @(posedge m_tb_if.clk);
                        end while(bist_rescan_finish != 1'b1);
                        while(1) begin
                            @(posedge m_array_agent_if.gcas_rd);
                            @(negedge m_array_agent_if.gcas_rd);
                            rescan_read_cnt = rescan_read_cnt + 1'b1;
                        end
                        while(1) begin
                            @(posedge m_array_agent_if.gcas_wr);
                            @(negedge m_array_agent_if.gcas_wr);
                            rescan_write_cnt = rescan_write_cnt + 1'b1;
                        end
                    join_any
                    disable fork;
                end
            join

            if (!m_tb_if.bist_rescan_finish)
                `uvm_error(get_type_name(),"interface bist_rescan_finish is not 1")

            //check read op num and write op num
            if (rescan_read_cnt != BIST_WL_NUM*COL_ALL_NUM*bist_rescan_num*bist_wl_scan_num)
                `uvm_error(get_type_name(),$sformatf("rescan read_cnt mismatch, exp is %0d,act is %0d",BIST_WL_NUM*COL_ALL_NUM*bist_rescan_num*bist_wl_scan_num, rescan_read_cnt))
            else 
                `uvm_info(get_type_name(),"read cnt check pass",UVM_LOW)
            
            if (rescan_write_cnt != BIST_WL_NUM*COL_ALL_NUM*bist_rescan_num*bist_wl_scan_num)
                `uvm_error(get_type_name(),$sformatf("rescan write cnt mismatch, exp is %0d,act is %0d",BIST_WL_NUM*COL_ALL_NUM*bist_rescan_num*bist_wl_scan_num, rescan_write_cnt))
            else 
                `uvm_info(get_type_name(),"write cnt check pass",UVM_LOW)

            rescan_read_cnt = 0;
            rescan_write_cnt = 0;
            //intr check
            if (bist_rescan_mask) begin
                if (m_tb_if.bist_finish_intr)   `uvm_error(get_type_name(),"mask is 1 but bist_finish_intr is 1")
            end
            else begin
                if (!m_tb_if.bist_finish_intr)   `uvm_error(get_type_name(),"mask is 0 but bist_finish_intr is 0")
            end

            //fail bit num check
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_rescan_fail_num_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
            if (err_rescan_total_bit_num > 20'hf_ffff) begin
                if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                    `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                else 
                    `uvm_info(get_type_name(), $sformatf("rescan fail num match, is 20'hf_ffff"),UVM_LOW)
            end
            else begin
                if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num)
                    `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num, mc_bist_rescan_fail_num_reg))
                else 
                    `uvm_info(get_type_name(), $sformatf("rescan fail num match, is %0d", err_rescan_total_bit_num),UVM_LOW)
            end

            //check bist_rescan_success
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bank_success_reg.bist_rescan_success.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
            if(exp_bist_rescan_success != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success, bist_rescan_success_reg))

            //check rescan_round_result
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.rescan_round_result_reg.read(status, rescan_round_result, UVM_FRONTDOOR);
            foreach(rescan_round_result_q[i]) begin
                if (rescan_round_result[i] != rescan_round_result_q[i])
                    `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q[i], rescan_round_result[i]))
                else 
                    `uvm_info(get_type_name(),$sformatf("round %0d, success compare pass, is %0b, ", i, rescan_round_result_q[i]), UVM_LOW)

            end

            rescan_round_result_q.delete();
        end
    end

    else begin
        
        //======================================= bist scan and bist rescan ===========================================
        //--------------- gen err_addr -----------------------
        for (int k=0;k<10;k++) begin //up and down
            //per col
            for (int i=0;i<COL_ALL_NUM;i++) begin
                assert(randomize(num_csl_err_inject)with {
                    //if((csl_vmc_num[k] >= 2) && (err_mode == 0 || err_mode == 2)){
                    if((err_mode == 0 || err_mode == 2)){
                        num_csl_err_inject <= first_bist_err_wl_num - row_err_addr_vmc_q.size();
                    }
                });

                csl_err_num_tmp = num_csl_err_inject;
                //if (k == 0) begin
                //    csl_err_num0_q.push_back(num_csl_err_inject);
                //    //max_csl_up_err_num=csl_err_num0_q.max();
                //end
                //else if (k==1)begin
                //    csl_err_num1_q.push_back(num_csl_err_inject);
                //    //max_csl_down_err_num=csl_err_num1_q.max();
                //end

                //else if (k==2)begin
                //    csl_err_num2_q.push_back(num_csl_err_inject);
                //    //max_csl_down_err_num=csl_err_num1_q.max();
                //end

                //else if (k==3)begin
                //    csl_err_num3_q.push_back(num_csl_err_inject);
                //    //max_csl_down_err_num=csl_err_num1_q.max();
                //end

                //else if (k==4)begin
                //    csl_err_num4_q.push_back(num_csl_err_inject);
                //    //max_csl_down_err_num=csl_err_num1_q.max();
                //end


                ////csl err
                //if (num_csl_err_inject >= csl_err_threshold)
                //    csl_vmc_num[k] = csl_vmc_num[k] + 1;

                //gen row
                if(num_csl_err_inject == 0) begin
                    if (k == 0) begin
                        csl_err_num0_q.push_back(0);
                    end
                    else if (k==1)begin
                        csl_err_num1_q.push_back(0);
                    end
                                                                     
                    else if (k==2)begin
                        csl_err_num2_q.push_back(0);
                    end
                                                                     
                    else if (k==3)begin
                        csl_err_num3_q.push_back(0);
                    end
                                                                     
                    else if (k==4)begin
                        csl_err_num4_q.push_back(0);
                    end
                 
                    else if (k==5)begin
                        csl_err_num5_q.push_back(0);
                    end
                    
                    else if (k==6)begin
                        csl_err_num6_q.push_back(0);
                    end

                    else if (k==7)begin
                        csl_err_num7_q.push_back(0);
                    end

                    else if (k==8)begin
                        csl_err_num8_q.push_back(0);
                    end

                    else if (k==9)begin
                        csl_err_num9_q.push_back(0);
                    end               
                    continue;
                end

                else begin

                    for(int j=0; j<num_csl_err_inject;j++) begin

                        if (row_err_addr_tmp_q.size() == 0) begin // the i'th col first err rowsame col 

                            if ( (row_err_addr_vmc_q.size == first_bist_err_wl_num) && (err_mode == 0 || err_mode == 2) ) begin //mode wl err has been == 63, and constraint <64
                                while (1) begin
                                    assert(randomize(radd_up_down));
                                    tmp_q = row_err_addr_vmc_q.find with (item == radd_up_down[k]);

                                    if (tmp_q.size()>0) begin
                                        row_err_addr_tmp_q.push_back(radd_up_down[k]);
                                        err_addr[radd_up_down[k]][i] = 1'b1;
                                        break;
                                    end

                                    else begin
                                        continue;
                                    end
                                end
                            end

                            else begin //mode wl err <63
                                assert(randomize(radd_up_down));

                                row_err_addr_tmp_q.push_back(radd_up_down[k]);
                                err_addr[radd_up_down[k]][i] = 1'b1;

                                //serial_err_wl_inject
                                if (serial_err_wl_inject_mode && (row_err_addr_vmc_q.size() <= first_bist_err_wl_num -2)) begin
                                    if(!$urandom_range(20)) begin                                    
                                        if (radd_up_down[k] != (BIST_WL_NUM*(k+1)/5 - 1)) begin
                                            row_err_addr_tmp_q.push_back(radd_up_down[k] + 'b1);
                                            err_addr[radd_up_down[k]+ 'b1][i] = 1'b1;
                                            `uvm_info(get_type_name(),$sformatf("now err radd is %0h, cadd is %0h, num is %0d", radd_up_down[k]+ 1'b1, i, j),UVM_LOW)
                                        end
                                        else begin
                                            row_err_addr_tmp_q.push_back(radd_up_down[k] - 'b1);
                                            err_addr[radd_up_down[k]- 'b1][i] = 1'b1;
                                            `uvm_info(get_type_name(),$sformatf("now err radd is %0h, cadd is %0h, num is %0d", radd_up_down[k]- 1'b1, i, j),UVM_LOW)
                                        end

                                        csl_err_num_tmp = csl_err_num_tmp + 1;
                                        //num_csl_err_inject = num_csl_err_inject - 1'b1;

                                        //if (num_csl_err_inject + 1'b1 >= csl_err_threshold)
                                        //    gap_redundant_csl = 1;
                                    end
                                end
                            end

                        end

                        else begin  //same col, err row addr must be different
                            while(1) begin: err_row_gen2
                                if ( (row_err_addr_vmc_q.size == first_bist_err_wl_num) && (err_mode == 0 || err_mode == 2) ) begin //mode wl err has been == 63, and constraint <64
                                    //tmp_q = row_err_addr_vmc_q.find with (item == radd_up_down[k]);
                                    //if (tmp_q.size()>0) begin
                                    //    row_err_addr_tmp_q.push_back(radd_up_down[k]);
                                    //    err_addr[radd_up_down[k]][i] = 1'b1;
                                    //    break;
                                    //end
                                    foreach(row_err_addr_vmc_q[jj]) begin
                                        if (k==0 && row_err_addr_vmc_q[jj] >(BIST_WL_NUM/5-1)) 
                                            continue;
                                        else if (k==1 && !(row_err_addr_vmc_q[jj] < (BIST_WL_NUM*2/10) && row_err_addr_vmc_q[jj] >= (BIST_WL_NUM/10)))
                                            continue;
                                        else if (k==2 && !(row_err_addr_vmc_q[jj] < (BIST_WL_NUM*3/10) && row_err_addr_vmc_q[jj] >= (BIST_WL_NUM*2/10)))
                                            continue;
                                        else if (k==3 && !(row_err_addr_vmc_q[jj] < (BIST_WL_NUM*4/10) && row_err_addr_vmc_q[jj] >= (BIST_WL_NUM*3/10)))
                                            continue;
                                        else if (k==4 && !(row_err_addr_vmc_q[jj] < (BIST_WL_NUM*5/10) && row_err_addr_vmc_q[jj] >= (BIST_WL_NUM*4/10)))
                                            continue;
                                        else if (k==5 && !(row_err_addr_vmc_q[jj] < (BIST_WL_NUM*6/10) && row_err_addr_vmc_q[jj] >= (BIST_WL_NUM*5/10)))
                                            continue;
                                        else if (k==6 && !(row_err_addr_vmc_q[jj] < (BIST_WL_NUM*7/10) && row_err_addr_vmc_q[jj] >= (BIST_WL_NUM*6/10)))
                                            continue;
                                        else if (k==7 && !(row_err_addr_vmc_q[jj] < (BIST_WL_NUM*8/10) && row_err_addr_vmc_q[jj] >= (BIST_WL_NUM*7/10)))
                                            continue;
                                        else if (k==8 && !(row_err_addr_vmc_q[jj] < (BIST_WL_NUM*9/10) && row_err_addr_vmc_q[jj] >= (BIST_WL_NUM*8/10)))
                                            continue;
                                        else if (k==9 && !(row_err_addr_vmc_q[jj] < (BIST_WL_NUM*10/10) && row_err_addr_vmc_q[jj] >= (BIST_WL_NUM*9/10)))
                                            continue;

                                        radd_up_down[k] =   row_err_addr_vmc_q[jj];
                                        tmp_q = row_err_addr_tmp_q.find with (item == radd_up_down[k]);
                                        if (tmp_q.size()>0) begin
                                            continue;
                                        end
                                        else begin
                                            break;
                                        end
                                    end

                                    tmp_q = row_err_addr_tmp_q.find with (item == radd_up_down[k]);
                                    if (tmp_q.size()>0) begin
                                        `uvm_info(get_type_name(),$sformatf("none err radd not in tmp, i is %0h, k is %0d",i, k), UVM_LOW)
                                        csl_err_num_tmp = csl_err_num_tmp - 1;
                                    end
                                    else begin
                                        row_err_addr_tmp_q.push_back(radd_up_down[k]);
                                        err_addr[radd_up_down[k]][i] = 1'b1;
                                    end
                                    break;
                                end


                                else begin
                                    while(1) begin
                                        assert(randomize(radd_up_down));
                                        tmp_q = row_err_addr_tmp_q.find with (item == radd_up_down[k]);
                                        if (tmp_q.size()>0) begin
                                            continue;
                                        end

                                        else begin
                                            row_err_addr_tmp_q.push_back(radd_up_down[k]);
                                            err_addr[radd_up_down[k]][i] = 1'b1;
                                            break;
                                        end
                                    end
                                    break;
                                end
                            end
                        end

                        row_err_addr_tmp_q.sort();

                        //if csl fail, after fail csl region should be pushed in err list
                        for (int KK=0;KK<k;KK++)begin
                            if (csl_vmc_num[KK] > 2) begin
                                //push not gap redundant csl
                                row_err_addr_vmc_q = {row_err_addr_vmc_q[0:$],row_err_addr_tmp_q};
                                row_err_addr_vmc_q = row_err_addr_vmc_q.unique;
                                row_err_addr_vmc_q.sort();
                            end
                        end

                        if((csl_err_num_tmp < csl_err_threshold) || (csl_err_num_tmp >= csl_err_threshold && csl_vmc_num[k]>=2)) begin
                            //gap vmc csl


                        //if csl success(before current csl region), caculating gap or not
                            if (csl_err_num_tmp < csl_err_threshold) begin
                                if (!((csl_vmc_num[k] == 0 && i == (COL_ALL_NUM-2)) || (csl_vmc_num[k] == 0 && i == (COL_ALL_NUM-1)) || (csl_vmc_num[k] == 1 && i ==(COL_ALL_NUM-1)))) begin
                                    //gap redundant csl
                                    row_err_addr_vmc_q = {row_err_addr_vmc_q[0:$],row_err_addr_tmp_q};
                                    row_err_addr_vmc_q = row_err_addr_vmc_q.unique;
                                    row_err_addr_vmc_q.sort();
                                end
                            end
                            else begin
                                if (!((csl_vmc_num[k] == 0 && i == (COL_ALL_NUM-1)) )) begin
                                    //push not gap redundant csl
                                    row_err_addr_vmc_q = {row_err_addr_vmc_q[0:$],row_err_addr_tmp_q};
                                    row_err_addr_vmc_q = row_err_addr_vmc_q.unique;
                                    row_err_addr_vmc_q.sort();
                                end
                            end
                        end

                        row_err_addr_q = {row_err_addr_q[0:$],row_err_addr_tmp_q};
                        row_err_addr_q = row_err_addr_q.unique();
                        row_err_addr_q.sort();
                        //$display("num of err row is %0d, vmc err row num is %0d",row_err_addr_q.size(),row_err_addr_vmc_q.size());
                    end

                    csl_vmc_num[k] = (csl_err_num_tmp >= csl_err_threshold)? (csl_vmc_num[k] + 'b1) : csl_vmc_num[k];

                    if (k == 0) begin
                        csl_err_num0_q.push_back(csl_err_num_tmp);
                    end
                    else if (k==1)begin
                        csl_err_num1_q.push_back(csl_err_num_tmp);
                    end
                                                                     
                    else if (k==2)begin
                        csl_err_num2_q.push_back(csl_err_num_tmp);
                    end
                                                                     
                    else if (k==3)begin
                        csl_err_num3_q.push_back(csl_err_num_tmp);
                    end
                                                                     
                    else if (k==4)begin
                        csl_err_num4_q.push_back(csl_err_num_tmp);
                    end

                    else if (k==5)begin
                        csl_err_num5_q.push_back(csl_err_num_tmp);
                    end

                    else if (k==6)begin
                        csl_err_num6_q.push_back(csl_err_num_tmp);
                    end

                    else if (k==7)begin
                        csl_err_num7_q.push_back(csl_err_num_tmp);
                    end

                    else if (k==8)begin
                        csl_err_num8_q.push_back(csl_err_num_tmp);
                    end

                    else if (k==9)begin
                        csl_err_num9_q.push_back(csl_err_num_tmp);
                    end
                    //gap_redundant_csl = 1'b0;
                    row_err_addr_tmp_q.delete();

                end
            end
        end

        //all err_addr
        `uvm_info(get_type_name(), "\n---------------------------------- below is error addr ---------------------------------",UVM_LOW)
        foreach(err_addr[i,j]) begin
            if (err_addr[i][j] == 1'b1)
                $write("(%0h,%0h)  ",i,j);
        end

        $display("");
        $display("------------------------------ error addr end ----------------------------------");


        `uvm_info(get_type_name(),"\n---------------------------------- below is err num of per col -----------------------",UVM_LOW)
        $display("mode is %0d, %s", err_mode, mode_name);
        $display("csl_err_threshold is %0d",csl_err_threshold);
        foreach(csl_err_num0_q[i]) begin
            $display("col %0h, 1st err num is %0d, 2nd err num is %0d, 3rd err num is %0d, 4th err num is %0d, 5th err num is %0d, 6th err num is %0d,  7th err num is %0d, 8th err num is %0d, 9th err num is %0d, 10th err num is %0d", i, csl_err_num0_q[i], csl_err_num1_q[i], csl_err_num2_q[i], csl_err_num3_q[i], csl_err_num4_q[i], csl_err_num5_q[i], csl_err_num6_q[i], csl_err_num7_q[i], csl_err_num8_q[i], csl_err_num9_q[i]);
        end

        $display("1st err csl totoal num is %0d", csl_vmc_num[0]);
        $display("2nd err csl totoal num is %0d", csl_vmc_num[1]);
        $display("3nd err csl totoal num is %0d", csl_vmc_num[2]);
        $display("4nd err csl totoal num is %0d", csl_vmc_num[3]);
        $display("5nd err csl totoal num is %0d", csl_vmc_num[4]);
        $display("6th err csl totoal num is %0d", csl_vmc_num[5]);
        $display("7th err csl totoal num is %0d", csl_vmc_num[6]);
        $display("8th err csl totoal num is %0d", csl_vmc_num[7]);
        $display("9th err csl totoal num is %0d", csl_vmc_num[8]);
        $display("10th err csl totoal num is %0d", csl_vmc_num[9]);

        row_err_addr_q.sort();
        row_err_addr_vmc_q.sort();
        //all err row addr
        $display("num of err row is %0d",row_err_addr_q.size());
        $display("all addr err addr:");
        foreach(row_err_addr_q[i])
            $write("%0h  ",row_err_addr_q[i]);

        $display("");

        //bist err row addr after vmc
        $display("num of err vmc row is %0d",row_err_addr_vmc_q.size());
        $display("all addr err addr with vmc:");
        foreach(row_err_addr_vmc_q[i])
            $write("%0h  ",row_err_addr_vmc_q[i]);
        $display("");




        //-------------------- global_mc_bist_start -----------------------
        `uvm_info(get_type_name(),"bist scan start!",UVM_LOW)
        @(posedge m_tb_if.pclk)
        m_tb_if.global_mc_bist_start = 1'b1;

        @(posedge m_tb_if.pclk)
        m_tb_if.global_mc_bist_start = 1'b0;

        //-------------------- error injection ----------------------------
        fork
            begin
                fork
                    begin
                        @(posedge m_array_agent_if.gcas_wr);
                        #1ps;
                        while(1) begin
                            if (err_addr[m_array_agent_if.gradd_n][m_array_agent_if.gcadd]) begin
                                err_wr_data = m_array_agent_if.wdl;
                                //uvm_hdl_force("mc_tb.m_mc_wrapper.mc_top_u.frame2array_u.mc_frame_wdata", ~err_wr_data);
                                uvm_hdl_force("mc_tb.m_mc_wrapper_aux.wdl", ~err_wr_data);
                                repeat(2) @(posedge m_tb_if.clk);
                                #1ps;
                                //uvm_hdl_release("mc_tb.m_mc_wrapper.mc_top_u.frame2array_u.mc_frame_wdata");
                                uvm_hdl_release("mc_tb.m_mc_wrapper_aux.wdl");
                            end
                            else begin
                                @(posedge m_array_agent_if.gcas_wr);
                                #1ps;
                            end
                        end
                    end
                    do begin
                        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish.peek(status,bist_finish);
                        repeat(1000) @(posedge m_tb_if.clk);
                    end while(bist_finish != 1'b1);
                join_any
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_err_wl_reg.read(status, mc_bist_err_wl_num_reg, UVM_FRONTDOOR);
                disable fork;
            end
        join

        `uvm_info(get_type_name(),"bist scan end!",UVM_LOW)

        //check bist_finish_intr
        if(bist_finish_mask == 1'b1) begin
            if (m_tb_if.bist_finish_intr != 1'b0) `uvm_error(get_type_name(),"bist_finish_mask is 1'b1, but bist_finish_intr is 1'b1")
            else    `uvm_info(get_type_name(),"bist_finish_intr check pass!", UVM_LOW)
        end

        else begin
            if (m_tb_if.bist_finish_intr != 1'b1) `uvm_error(get_type_name(),"bist_finish_mask is 1'b0, but bist_finish_intr is 1'b0")
            else    `uvm_info(get_type_name(),"bist_finish_intr check pass!", UVM_LOW)
        end

        //check bist success
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bank_success.peek(status, bank_success);
        if ((row_err_addr_vmc_q.size() <= 64) && csl_vmc_num[0] <= 2 && csl_vmc_num[1] <= 2 && csl_vmc_num[2] <= 2 && csl_vmc_num[3] <= 2 && csl_vmc_num[4] <= 2 && csl_vmc_num[5] <= 2 && csl_vmc_num[6] <= 2 && csl_vmc_num[7] <= 2 && csl_vmc_num[8] <= 2 && csl_vmc_num[9] <= 2) begin
            if (bank_success != 1'b1) `uvm_error(get_type_name(), "bank_success did not be 1!!")
        end
        else begin
            if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success did not be 0!!")
        end


        //clear bist_finish_intr
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_clr.write(status,1'b1,UVM_FRONTDOOR);

        repeat(10) @(posedge m_tb_if.clk);
        //check clear
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish.read(status,bist_finish, UVM_FRONTDOOR);
        if(bist_finish != 0)
            `uvm_error(get_type_name(),"bist_finish not clear!!!")   

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bank_success.peek(status, bank_success);
        if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success did not be 0!!")

        repeat(100) @(posedge m_tb_if.clk);
        //check clear
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish.read(status,bist_finish, UVM_FRONTDOOR);
        if(bist_finish != 0)
            `uvm_error(get_type_name(),"bist_finish not clear!!!")   
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bank_success.peek(status, bank_success);
        if (bank_success != 1'b0) `uvm_error(get_type_name(), "bank_success did not be 0!!")

        `uvm_info(get_type_name(),"read bist err csl!",UVM_LOW)
        //read err csl addr
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg0_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg0_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg1_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg1_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part2_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg2_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part2_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg2_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part3_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg3_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part3_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg3_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part4_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg4_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part4_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg4_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part5_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg5_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part5_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg5_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part6_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg6_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part6_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg6_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part7_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg7_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part7_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg7_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part8_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg8_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part8_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg8_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl0_part9_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg9_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_csl1_part9_reg.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_reg9_q.push_back(read_err_csl_reg);


        `uvm_info(get_type_name(),"read bist err wl!",UVM_LOW)
        //read err row addr
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl4.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl5.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl6.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl7.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl8.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl9.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl10.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl11.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl12.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl13.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl14.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl15.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl16.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl17.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl18.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl19.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl20.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl21.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl22.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl23.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl24.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl25.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl26.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl27.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl28.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl29.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl30.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl31.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl32.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl33.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl34.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl35.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl36.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl37.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl38.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl39.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl40.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl41.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl42.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl43.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl44.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl45.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl46.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl47.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl48.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl49.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl50.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl51.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl52.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl53.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl54.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl55.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl56.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl57.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl58.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl59.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl60.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl61.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl62.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.err_wl63.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);

        `uvm_info(get_type_name(),"vmc sort!",UVM_LOW)
        //--------------- vmc config -------------------
        read_err_csl_reg0_q.sort();
        read_err_csl_reg1_q.sort();
        read_err_csl_reg2_q.sort();
        read_err_csl_reg3_q.sort();
        read_err_csl_reg4_q.sort();
        read_err_csl_reg5_q.sort();
        read_err_csl_reg6_q.sort();
        read_err_csl_reg7_q.sort();
        read_err_csl_reg8_q.sort();
        read_err_csl_reg9_q.sort();
        read_err_row_reg_q.sort();

        `uvm_info(get_type_name(),"vmc compare!",UVM_LOW)
        //----------------- ref compare ------------------

        //----------------- csl up vmc reg check ---------------------
        foreach(read_err_csl_reg0_q[i]) begin
            if (read_err_csl_reg0_q[i] == ERR_CSL_DEFAULT_VALUE) begin
                if (csl_vmc_num[0] !== i) begin
                    `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch, col is %0h",read_err_csl_reg0_q[i]))
                end
                else begin
                    `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                    //check col is 7f
                    for (int ii=i;ii<2;ii++)begin
                        if (read_err_csl_reg0_q[ii] !== ERR_CSL_DEFAULT_VALUE) begin
                            `uvm_error(get_type_name(),$sformatf("err csl up get col addr not be %0h, after getten %0h , col is %0h",ERR_CSL_DEFAULT_VALUE,ERR_CSL_DEFAULT_VALUE,read_err_csl_reg0_q[ii]))
                        end
                    end
                    break;
                end
            end
            else if(csl_err_num0_q[read_err_csl_reg0_q[i]] < csl_err_threshold) begin
                `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch, col is %0h",read_err_csl_reg0_q[i]))
            end
            else begin
                `uvm_info(get_type_name(),$sformatf("err csl up compare pass, col is %0h",read_err_csl_reg0_q[i]),UVM_LOW)
            end
        end


        //----------------- csl down vmc reg check ---------------------

        if ( csl_vmc_num[0] < 3 ) begin
            foreach(read_err_csl_reg1_q[i]) begin
                if (read_err_csl_reg1_q[i] == ERR_CSL_DEFAULT_VALUE) begin
                    if (csl_vmc_num[1] !== i) begin
                        `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch, col is %0h",read_err_csl_reg1_q[i]))
                    end
                    else begin
                        `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                        //check col is 7f
                        for (int ii=i;ii<2;ii++)begin
                            if (read_err_csl_reg1_q[ii] !== ERR_CSL_DEFAULT_VALUE) begin
                                `uvm_error(get_type_name(),$sformatf("err csl down get col addr not be %0h, after getten %0h , col is %0h",ERR_CSL_DEFAULT_VALUE,ERR_CSL_DEFAULT_VALUE,read_err_csl_reg1_q[ii]))
                            end
                        end

                        break;
                    end
                end

                else if(csl_err_num1_q[read_err_csl_reg1_q[i]] < csl_err_threshold) begin
                    `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch,exp err col is %0h",read_err_csl_reg1_q[i]))
                end
                else begin
                    `uvm_info(get_type_name(),$sformatf("err csl up compare pass, col is %0h",read_err_csl_reg1_q[i]),UVM_LOW)
                end
            end
        end
        else begin
            foreach(read_err_csl_reg1_q[i]) begin
                if (read_err_csl_reg1_q[i] != ERR_CSL_DEFAULT_VALUE) begin
                    `uvm_error(get_type_name(),$sformatf("when csl up err num > 2, exp csl down err is 7f, act is %0h",read_err_csl_reg1_q[i]))
                end
                //else begin
                //    `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                //end
            end
        end

        //----------------- csl down vmc reg check ---------------------
        if ( csl_vmc_num[0] < 3 && csl_vmc_num[1] < 3) begin
            foreach(read_err_csl_reg2_q[i]) begin
                if (read_err_csl_reg2_q[i] == ERR_CSL_DEFAULT_VALUE) begin
                    if (csl_vmc_num[2] !== i) begin
                        `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch, col is %0h",read_err_csl_reg2_q[i]))
                    end
                    else begin
                        `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                        //check col is 7f
                        for (int ii=i;ii<2;ii++)begin
                            if (read_err_csl_reg2_q[ii] !== ERR_CSL_DEFAULT_VALUE) begin
                                `uvm_error(get_type_name(),$sformatf("err csl down get col addr not be %0h, after getten %0h , col is %0h",ERR_CSL_DEFAULT_VALUE,ERR_CSL_DEFAULT_VALUE,read_err_csl_reg2_q[ii]))
                            end
                        end

                        break;
                    end
                end

                else if(csl_err_num2_q[read_err_csl_reg2_q[i]] < csl_err_threshold) begin
                    `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch,exp err col is %0h",read_err_csl_reg2_q[i]))
                end
                else begin
                    `uvm_info(get_type_name(),$sformatf("err csl up compare pass, col is %0h",read_err_csl_reg2_q[i]),UVM_LOW)
                end
            end
        end
        else begin
            foreach(read_err_csl_reg2_q[i]) begin
                if (read_err_csl_reg2_q[i] != ERR_CSL_DEFAULT_VALUE) begin
                    `uvm_error(get_type_name(),$sformatf("when csl up err num > 2, exp csl down err is 7f, act is %0h",read_err_csl_reg2_q[i]))
                end
                //else begin
                //    `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                //end
            end
        end

        //----------------- csl down vmc reg check ---------------------
        if ( csl_vmc_num[0] < 3 && csl_vmc_num[1] < 3 && csl_vmc_num[2] < 3) begin
            foreach(read_err_csl_reg3_q[i]) begin
                if (read_err_csl_reg3_q[i] == ERR_CSL_DEFAULT_VALUE) begin
                    if (csl_vmc_num[3] !== i) begin
                        `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch, col is %0h",read_err_csl_reg3_q[i]))
                    end
                    else begin
                        `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                        //check col is 7f
                        for (int ii=i;ii<2;ii++)begin
                            if (read_err_csl_reg3_q[ii] !== ERR_CSL_DEFAULT_VALUE) begin
                                `uvm_error(get_type_name(),$sformatf("err csl down get col addr not be %0h, after getten %0h , col is %0h",ERR_CSL_DEFAULT_VALUE,ERR_CSL_DEFAULT_VALUE,read_err_csl_reg3_q[ii]))
                            end
                        end

                        break;
                    end
                end

                else if(csl_err_num3_q[read_err_csl_reg3_q[i]] < csl_err_threshold) begin
                    `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch,exp err col is %0h",read_err_csl_reg3_q[i]))
                end
                else begin
                    `uvm_info(get_type_name(),$sformatf("err csl up compare pass, col is %0h",read_err_csl_reg3_q[i]),UVM_LOW)
                end
            end
        end
        else begin
            foreach(read_err_csl_reg3_q[i]) begin
                if (read_err_csl_reg3_q[i] != ERR_CSL_DEFAULT_VALUE) begin
                    `uvm_error(get_type_name(),$sformatf("when csl up err num > 2, exp csl down err is 7f, act is %0h",read_err_csl_reg3_q[i]))
                end
                //else begin
                //    `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                //end
            end
        end

        //----------------- csl down vmc reg check ---------------------
        if ( csl_vmc_num[0] < 3 && csl_vmc_num[1] < 3 && csl_vmc_num[2] < 3 && csl_vmc_num[3] <3) begin
            foreach(read_err_csl_reg4_q[i]) begin
                if (read_err_csl_reg4_q[i] == ERR_CSL_DEFAULT_VALUE) begin
                    if (csl_vmc_num[4] !== i) begin
                        `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch, col is %0h",read_err_csl_reg4_q[i]))
                    end
                    else begin
                        `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                        //check col is 7f
                        for (int ii=i;ii<2;ii++)begin
                            if (read_err_csl_reg4_q[ii] !== ERR_CSL_DEFAULT_VALUE) begin
                                `uvm_error(get_type_name(),$sformatf("err csl down get col addr not be %0h, after getten %0h , col is %0h",ERR_CSL_DEFAULT_VALUE,ERR_CSL_DEFAULT_VALUE,read_err_csl_reg4_q[ii]))
                            end
                        end

                        break;
                    end
                end

                else if(csl_err_num4_q[read_err_csl_reg4_q[i]] < csl_err_threshold) begin
                    `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch,exp err col is %0h",read_err_csl_reg4_q[i]))
                end
                else begin
                    `uvm_info(get_type_name(),$sformatf("err csl up compare pass, col is %0h",read_err_csl_reg4_q[i]),UVM_LOW)
                end
            end
        end
        else begin
            foreach(read_err_csl_reg4_q[i]) begin
                if (read_err_csl_reg4_q[i] != ERR_CSL_DEFAULT_VALUE) begin
                    `uvm_error(get_type_name(),$sformatf("when csl up err num > 2, exp csl down err is 7f, act is %0h",read_err_csl_reg4_q[i]))
                end
                //else begin
                //    `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                //end
            end
        end

        //----------------- csl part5 vmc reg check ---------------------
        if ( csl_vmc_num[0] < 3 && csl_vmc_num[1] < 3 && csl_vmc_num[2] < 3 && csl_vmc_num[3] <3 && csl_vmc_num[4] <3) begin
            foreach(read_err_csl_reg5_q[i]) begin
                if (read_err_csl_reg5_q[i] == ERR_CSL_DEFAULT_VALUE) begin
                    if (csl_vmc_num[5] !== i) begin
                        `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch, col is %0h",read_err_csl_reg5_q[i]))
                    end
                    else begin
                        `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                        //check col is 7f
                        for (int ii=i;ii<2;ii++)begin
                            if (read_err_csl_reg5_q[ii] !== ERR_CSL_DEFAULT_VALUE) begin
                                `uvm_error(get_type_name(),$sformatf("err csl down get col addr not be %0h, after getten %0h , col is %0h",ERR_CSL_DEFAULT_VALUE,ERR_CSL_DEFAULT_VALUE,read_err_csl_reg5_q[ii]))
                            end
                        end

                        break;
                    end
                end

                else if(csl_err_num5_q[read_err_csl_reg5_q[i]] < csl_err_threshold) begin
                    `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch,exp err col is %0h",read_err_csl_reg5_q[i]))
                end
                else begin
                    `uvm_info(get_type_name(),$sformatf("err csl up compare pass, col is %0h",read_err_csl_reg5_q[i]),UVM_LOW)
                end
            end
        end
        else begin
            foreach(read_err_csl_reg5_q[i]) begin
                if (read_err_csl_reg5_q[i] != ERR_CSL_DEFAULT_VALUE) begin
                    `uvm_error(get_type_name(),$sformatf("when csl up err num > 2, exp csl down err is 7f, act is %0h",read_err_csl_reg5_q[i]))
                end
                //else begin
                //    `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                //end
            end
        end
        //----------------- csl part6 vmc reg check ---------------------
        if ( csl_vmc_num[0] < 3 && csl_vmc_num[1] < 3 && csl_vmc_num[2] < 3 && csl_vmc_num[3] <3 && csl_vmc_num[4] <3 && csl_vmc_num[5] <3) begin
            foreach(read_err_csl_reg6_q[i]) begin
                if (read_err_csl_reg6_q[i] == ERR_CSL_DEFAULT_VALUE) begin
                    if (csl_vmc_num[6] !== i) begin
                        `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch, col is %0h",read_err_csl_reg6_q[i]))
                    end
                    else begin
                        `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                        //check col is 7f
                        for (int ii=i;ii<2;ii++)begin
                            if (read_err_csl_reg6_q[ii] !== ERR_CSL_DEFAULT_VALUE) begin
                                `uvm_error(get_type_name(),$sformatf("err csl down get col addr not be %0h, after getten %0h , col is %0h",ERR_CSL_DEFAULT_VALUE,ERR_CSL_DEFAULT_VALUE,read_err_csl_reg6_q[ii]))
                            end
                        end

                        break;
                    end
                end

                else if(csl_err_num6_q[read_err_csl_reg6_q[i]] < csl_err_threshold) begin
                    `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch,exp err col is %0h",read_err_csl_reg6_q[i]))
                end
                else begin
                    `uvm_info(get_type_name(),$sformatf("err csl up compare pass, col is %0h",read_err_csl_reg6_q[i]),UVM_LOW)
                end
            end
        end
        else begin
            foreach(read_err_csl_reg6_q[i]) begin
                if (read_err_csl_reg6_q[i] != ERR_CSL_DEFAULT_VALUE) begin
                    `uvm_error(get_type_name(),$sformatf("when csl up err num > 2, exp csl down err is 7f, act is %0h",read_err_csl_reg6_q[i]))
                end
                //else begin
                //    `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                //end
            end
        end
        //----------------- csl part7 vmc reg check ---------------------
        if ( csl_vmc_num[0] < 3 && csl_vmc_num[1] < 3 && csl_vmc_num[2] < 3 && csl_vmc_num[3] <3 && csl_vmc_num[4] <3 && csl_vmc_num[5] <3 && csl_vmc_num[6] <3) begin
            foreach(read_err_csl_reg7_q[i]) begin
                if (read_err_csl_reg7_q[i] == ERR_CSL_DEFAULT_VALUE) begin
                    if (csl_vmc_num[7] !== i) begin
                        `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch, col is %0h",read_err_csl_reg7_q[i]))
                    end
                    else begin
                        `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                        //check col is 7f
                        for (int ii=i;ii<2;ii++)begin
                            if (read_err_csl_reg7_q[ii] !== ERR_CSL_DEFAULT_VALUE) begin
                                `uvm_error(get_type_name(),$sformatf("err csl down get col addr not be %0h, after getten %0h , col is %0h",ERR_CSL_DEFAULT_VALUE,ERR_CSL_DEFAULT_VALUE,read_err_csl_reg7_q[ii]))
                            end
                        end

                        break;
                    end
                end

                else if(csl_err_num7_q[read_err_csl_reg7_q[i]] < csl_err_threshold) begin
                    `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch,exp err col is %0h",read_err_csl_reg7_q[i]))
                end
                else begin
                    `uvm_info(get_type_name(),$sformatf("err csl up compare pass, col is %0h",read_err_csl_reg7_q[i]),UVM_LOW)
                end
            end
        end
        else begin
            foreach(read_err_csl_reg7_q[i]) begin
                if (read_err_csl_reg7_q[i] != ERR_CSL_DEFAULT_VALUE) begin
                    `uvm_error(get_type_name(),$sformatf("when csl up err num > 2, exp csl down err is 7f, act is %0h",read_err_csl_reg7_q[i]))
                end
                //else begin
                //    `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                //end
            end
        end

        //----------------- csl part8 vmc reg check ---------------------
        if ( csl_vmc_num[0] < 3 && csl_vmc_num[1] < 3 && csl_vmc_num[2] < 3 && csl_vmc_num[3] <3 && csl_vmc_num[4] <3 && csl_vmc_num[5] <3 && csl_vmc_num[6] <3 && csl_vmc_num[7] <3) begin
            foreach(read_err_csl_reg8_q[i]) begin
                if (read_err_csl_reg8_q[i] == ERR_CSL_DEFAULT_VALUE) begin
                    if (csl_vmc_num[8] !== i) begin
                        `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch, col is %0h",read_err_csl_reg8_q[i]))
                    end
                    else begin
                        `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                        //check col is 7f
                        for (int ii=i;ii<2;ii++)begin
                            if (read_err_csl_reg8_q[ii] !== ERR_CSL_DEFAULT_VALUE) begin
                                `uvm_error(get_type_name(),$sformatf("err csl down get col addr not be %0h, after getten %0h , col is %0h",ERR_CSL_DEFAULT_VALUE,ERR_CSL_DEFAULT_VALUE,read_err_csl_reg8_q[ii]))
                            end
                        end

                        break;
                    end
                end

                else if(csl_err_num8_q[read_err_csl_reg8_q[i]] < csl_err_threshold) begin
                    `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch,exp err col is %0h",read_err_csl_reg8_q[i]))
                end
                else begin
                    `uvm_info(get_type_name(),$sformatf("err csl up compare pass, col is %0h",read_err_csl_reg8_q[i]),UVM_LOW)
                end
            end
        end
        else begin
            foreach(read_err_csl_reg8_q[i]) begin
                if (read_err_csl_reg8_q[i] != ERR_CSL_DEFAULT_VALUE) begin
                    `uvm_error(get_type_name(),$sformatf("when csl up err num > 2, exp csl down err is 7f, act is %0h",read_err_csl_reg8_q[i]))
                end
                //else begin
                //    `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                //end
            end
        end
        //----------------- csl part9 vmc reg check ---------------------
        if ( csl_vmc_num[0] < 3 && csl_vmc_num[1] < 3 && csl_vmc_num[2] < 3 && csl_vmc_num[3] <3 && csl_vmc_num[4] <3 && csl_vmc_num[5] <3 && csl_vmc_num[6] <3 && csl_vmc_num[7] <3 && csl_vmc_num[8] <3) begin
            foreach(read_err_csl_reg9_q[i]) begin
                if (read_err_csl_reg9_q[i] == ERR_CSL_DEFAULT_VALUE) begin
                    if (csl_vmc_num[9] !== i) begin
                        `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch, col is %0h",read_err_csl_reg9_q[i]))
                    end
                    else begin
                        `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                        //check col is 7f
                        for (int ii=i;ii<2;ii++)begin
                            if (read_err_csl_reg9_q[ii] !== ERR_CSL_DEFAULT_VALUE) begin
                                `uvm_error(get_type_name(),$sformatf("err csl down get col addr not be %0h, after getten %0h , col is %0h",ERR_CSL_DEFAULT_VALUE,ERR_CSL_DEFAULT_VALUE,read_err_csl_reg9_q[ii]))
                            end
                        end

                        break;
                    end
                end

                else if(csl_err_num9_q[read_err_csl_reg9_q[i]] < csl_err_threshold) begin
                    `uvm_error(get_type_name(),$sformatf("err csl up compare mismatch,exp err col is %0h",read_err_csl_reg9_q[i]))
                end
                else begin
                    `uvm_info(get_type_name(),$sformatf("err csl up compare pass, col is %0h",read_err_csl_reg9_q[i]),UVM_LOW)
                end
            end
        end
        else begin
            foreach(read_err_csl_reg9_q[i]) begin
                if (read_err_csl_reg9_q[i] != ERR_CSL_DEFAULT_VALUE) begin
                    `uvm_error(get_type_name(),$sformatf("when csl up err num > 2, exp csl down err is 7f, act is %0h",read_err_csl_reg9_q[i]))
                end
                //else begin
                //    `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_CSL_DEFAULT_VALUE),UVM_LOW)
                //end
            end
        end

        //----------------- row vmc reg check ---------------------
        if ( csl_vmc_num[0] < 3 && csl_vmc_num[1] < 3 && csl_vmc_num[2] < 3 && csl_vmc_num[3] <3 && csl_vmc_num[4] <3) begin
            foreach(read_err_row_reg_q[i]) begin
                if (read_err_row_reg_q[i] == ERR_WL_DEFAULT_VALUE) begin
                    if (row_err_addr_vmc_q.size() !== i) begin
                        `uvm_error(get_type_name(),$sformatf("err row compare mismatch, exp is %0h, act is %0h",row_err_addr_vmc_q[i], read_err_row_reg_q[i]))
                    end
                    else begin
                        `uvm_info(get_type_name(),$sformatf("get %0h, break check",ERR_WL_DEFAULT_VALUE),UVM_LOW)
                        //check row is 3fff
                        for (int ii=i;ii<64;ii++)begin
                            if (read_err_row_reg_q[ii] !== ERR_WL_DEFAULT_VALUE) begin
                                `uvm_error(get_type_name(),$sformatf("err row get col addr not be %0h, after getten %0h , row is %0h",ERR_WL_DEFAULT_VALUE,ERR_WL_DEFAULT_VALUE,read_err_row_reg_q[ii]))
                            end
                        end
                        break;
                    end
                end

                else if(row_err_addr_vmc_q[i] != read_err_row_reg_q[i]) begin
                    `uvm_error(get_type_name(),$sformatf("err row compare mismatch, exp is %0h, act is %0h",row_err_addr_vmc_q[i], read_err_row_reg_q[i]))
                end
                else begin
                    `uvm_info(get_type_name(),$sformatf("err row compare pass, row is %0h",row_err_addr_vmc_q[i]),UVM_LOW) 
                end

            end
        end
        else begin
            foreach(read_err_row_reg_q[i]) begin
                if (read_err_row_reg_q[i] != ERR_WL_DEFAULT_VALUE) begin
                    `uvm_error(get_type_name(),$sformatf("when csl up err num > 2 or csl down err num >2, exp wl err is 1fff, act is %0h",read_err_row_reg_q[i]))
                end
                //else begin
                //    `uvm_info(get_type_name(),$sformatf("get %0h, break check", ERR_WL_DEFAULT_VALUE),UVM_LOW)
                //end
            end
        end

        //--------------- remap ------------------------
        `uvm_info(get_type_name(),"vmc remap!",UVM_LOW)

        foreach(read_err_csl_reg0_q[i]) begin
            if (read_err_csl_reg0_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_reg0_q[i]    =   read_err_csl_reg0_q[i] - i;
        end
        foreach(read_err_csl_reg1_q[i]) begin
            if (read_err_csl_reg1_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_reg1_q[i]    =   read_err_csl_reg1_q[i] - i;
        end
        foreach(read_err_csl_reg2_q[i]) begin
            if (read_err_csl_reg2_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_reg2_q[i]    =   read_err_csl_reg2_q[i] - i;
        end
        foreach(read_err_csl_reg3_q[i]) begin
            if (read_err_csl_reg3_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_reg3_q[i]    =   read_err_csl_reg3_q[i] - i;
        end
        foreach(read_err_csl_reg4_q[i]) begin
            if (read_err_csl_reg4_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_reg4_q[i]    =   read_err_csl_reg4_q[i] - i;
        end
        foreach(read_err_csl_reg5_q[i]) begin
            if (read_err_csl_reg5_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_reg5_q[i]    =   read_err_csl_reg5_q[i] - i;
        end
        foreach(read_err_csl_reg6_q[i]) begin
            if (read_err_csl_reg6_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_reg6_q[i]    =   read_err_csl_reg6_q[i] - i;
        end
        foreach(read_err_csl_reg7_q[i]) begin
            if (read_err_csl_reg7_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_reg7_q[i]    =   read_err_csl_reg7_q[i] - i;
        end
        foreach(read_err_csl_reg8_q[i]) begin
            if (read_err_csl_reg8_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_reg8_q[i]    =   read_err_csl_reg8_q[i] - i;
        end
        foreach(read_err_csl_reg9_q[i]) begin
            if (read_err_csl_reg9_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_reg9_q[i]    =   read_err_csl_reg9_q[i] - i;
        end

        foreach(read_err_row_reg_q[i]) begin
            if (read_err_row_reg_q[i] == ERR_WL_DEFAULT_VALUE)
                break;
            read_err_row_reg_q[i]    =   read_err_row_reg_q[i] - i;
        end

        `uvm_info(get_type_name(),"vmc write in reg!",UVM_LOW)
        //--------------- write in reg ----------------
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part0.write(status, read_err_csl_reg0_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part0.write(status, read_err_csl_reg0_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part1.write(status, read_err_csl_reg1_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part1.write(status, read_err_csl_reg1_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part2_reg.write(status, read_err_csl_reg2_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part2_reg.write(status, read_err_csl_reg2_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part3_reg.write(status, read_err_csl_reg3_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part3_reg.write(status, read_err_csl_reg3_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part4_reg.write(status, read_err_csl_reg4_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part4_reg.write(status, read_err_csl_reg4_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part5_reg.write(status, read_err_csl_reg5_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part5_reg.write(status, read_err_csl_reg5_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part6_reg.write(status, read_err_csl_reg6_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part6_reg.write(status, read_err_csl_reg6_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part7_reg.write(status, read_err_csl_reg7_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part7_reg.write(status, read_err_csl_reg7_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part8_reg.write(status, read_err_csl_reg8_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part8_reg.write(status, read_err_csl_reg8_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num0_part9_reg.write(status, read_err_csl_reg9_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_bl_num1_part9_reg.write(status, read_err_csl_reg9_q[1], UVM_FRONTDOOR);


        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num0.write(status, read_err_row_reg_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num1.write(status, read_err_row_reg_q[1], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num2.write(status, read_err_row_reg_q[2], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num3.write(status, read_err_row_reg_q[3], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num4.write(status, read_err_row_reg_q[4], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num5.write(status, read_err_row_reg_q[5], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num6.write(status, read_err_row_reg_q[6], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num7.write(status, read_err_row_reg_q[7], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num8.write(status, read_err_row_reg_q[8], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num9.write(status, read_err_row_reg_q[9], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num10.write(status, read_err_row_reg_q[10], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num11.write(status, read_err_row_reg_q[11], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num12.write(status, read_err_row_reg_q[12], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num13.write(status, read_err_row_reg_q[13], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num14.write(status, read_err_row_reg_q[14], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num15.write(status, read_err_row_reg_q[15], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num16.write(status, read_err_row_reg_q[16], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num17.write(status, read_err_row_reg_q[17], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num18.write(status, read_err_row_reg_q[18], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num19.write(status, read_err_row_reg_q[19], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num20.write(status, read_err_row_reg_q[20], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num21.write(status, read_err_row_reg_q[21], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num22.write(status, read_err_row_reg_q[22], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num23.write(status, read_err_row_reg_q[23], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num24.write(status, read_err_row_reg_q[24], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num25.write(status, read_err_row_reg_q[25], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num26.write(status, read_err_row_reg_q[26], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num27.write(status, read_err_row_reg_q[27], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num28.write(status, read_err_row_reg_q[28], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num29.write(status, read_err_row_reg_q[29], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num30.write(status, read_err_row_reg_q[30], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num31.write(status, read_err_row_reg_q[31], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num32.write(status, read_err_row_reg_q[32], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num33.write(status, read_err_row_reg_q[33], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num34.write(status, read_err_row_reg_q[34], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num35.write(status, read_err_row_reg_q[35], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num36.write(status, read_err_row_reg_q[36], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num37.write(status, read_err_row_reg_q[37], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num38.write(status, read_err_row_reg_q[38], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num39.write(status, read_err_row_reg_q[39], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num40.write(status, read_err_row_reg_q[40], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num41.write(status, read_err_row_reg_q[41], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num42.write(status, read_err_row_reg_q[42], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num43.write(status, read_err_row_reg_q[43], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num44.write(status, read_err_row_reg_q[44], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num45.write(status, read_err_row_reg_q[45], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num46.write(status, read_err_row_reg_q[46], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num47.write(status, read_err_row_reg_q[47], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num48.write(status, read_err_row_reg_q[48], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num49.write(status, read_err_row_reg_q[49], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num50.write(status, read_err_row_reg_q[50], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num51.write(status, read_err_row_reg_q[51], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num52.write(status, read_err_row_reg_q[52], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num53.write(status, read_err_row_reg_q[53], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num54.write(status, read_err_row_reg_q[54], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num55.write(status, read_err_row_reg_q[55], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num56.write(status, read_err_row_reg_q[56], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num57.write(status, read_err_row_reg_q[57], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num58.write(status, read_err_row_reg_q[58], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num59.write(status, read_err_row_reg_q[59], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num60.write(status, read_err_row_reg_q[60], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num61.write(status, read_err_row_reg_q[61], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num62.write(status, read_err_row_reg_q[62], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_vmc_wl_num63.write(status, read_err_row_reg_q[63], UVM_FRONTDOOR);


        //vmc enable
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_wl_vmc_en.write(status,1'b1, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_bl_vmc_en.write(status,1'b1, UVM_FRONTDOOR);
        repeat(10) @(posedge m_tb_if.clk);

        for (int kk=0;kk<2;kk++) begin

            //rescan num
            assert(randomize(bist_rescan_num));
            m_tb_if.bist_rescan_num =   bist_rescan_num;
            `uvm_info(get_type_name(),$sformatf("bist_rescan_num is 'd%0d", bist_rescan_num),UVM_LOW)

            //-------------------- global_mc_rescan_start -----------------------
            `uvm_info(get_type_name(),"bist rescan start!",UVM_LOW)

            //clear exp varible
            err_rescan_total_bit_num    =   0;
            exp_bist_rescan_success     =   0;

            @(posedge m_tb_if.pclk)
            m_tb_if.global_mc_rescan_start = 1'b1;

            @(posedge m_tb_if.pclk)
            m_tb_if.global_mc_rescan_start = 1'b0;


            fork
                begin
                    fork
                        begin
                            fork
                                begin   
                                    //check rescan reg clr
                                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_rescan_fail_num_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                                    if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_reg.bist_rescan_finish.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                                    if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bank_success_reg.bist_rescan_success.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                                    if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.rescan_round_result_reg.read(status, rescan_round_result, UVM_FRONTDOOR);
                                    if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                                end

                                begin
                                    bist_rescan_success = 1;        //set bist_rescan_success for check
                                    @(posedge m_array_agent_if.gcas_wr);
                                    #1ps;
                                    while(1) begin
                                        if(!($urandom_range(15000))) begin
                                            //not success
                                            bist_rescan_success = 0;

                                            err_wr_data = m_array_agent_if.wdl;
                                            //uvm_hdl_force("mc_tb.m_mc_wrapper.mc_top_u.frame2array_u.mc_frame_wdata", ~err_wr_data);
                                            loop_times = $urandom_range(1,266);
                                            for (int jj=0;jj< loop_times;jj++) begin
                                                assert(randomize(err_rescan_bit_index));
                                                err_rescan_bit_index_q.push_back(err_rescan_bit_index);
                                            end

                                            err_rescan_bit_index_q.sort();        //debug used


                                            err_rescan_bit_index_q = err_rescan_bit_index_q.unique();

                                            err_rescan_total_bit_num = err_rescan_total_bit_num + err_rescan_bit_index_q.size();
                                            //`uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit num is %0d",m_array_agent_if.gradd_n, m_array_agent_if.gcadd, err_rescan_bit_index_q.size()),UVM_LOW)

                                            //$display("");
                                            //foreach(err_rescan_bit_index_q[i]) begin
                                            //    $write("%0d, ",err_rescan_bit_index_q[i]);
                                            //end
                                            //$display("");

                                            foreach(err_rescan_bit_index_q[i]) begin
                                                err_wr_data[err_rescan_bit_index_q[i]] = ~err_wr_data[err_rescan_bit_index_q[i]];
                                                //`uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit index is %0d",m_array_agent_if.gradd_n, m_array_agent_if.gcadd, err_rescan_bit_index_q[i]),UVM_LOW)
                                            end

                                            uvm_hdl_force("mc_tb.m_mc_wrapper_aux.wdl", err_wr_data);
                                            repeat(2) @(posedge m_tb_if.clk);
                                            #1ps;
                                            //uvm_hdl_release("mc_tb.m_mc_wrapper.mc_top_u.frame2array_u.mc_frame_wdata");
                                            uvm_hdl_release("mc_tb.m_mc_wrapper_aux.wdl");
                                            err_rescan_bit_index_q.delete();
                                        end
                                        else begin
                                            @(posedge m_array_agent_if.gcas_wr);
                                            #1ps;
                                        end
                                    end
                                end
                                begin
                                    while(1) begin
                                        @(one_rescan_finish);
                                        rescan_round_result_q.push_back(bist_rescan_success);
                                        exp_bist_rescan_success = exp_bist_rescan_success | bist_rescan_success;
                                        bist_rescan_success = 1;        //set bist_rescan_success for check
                                    end
                                end
                                begin
                                    //-------- rescan num check ----------
                                    for(int i=0; i < bist_rescan_num; i++) begin
                                        for(int j=0; j< bist_wl_scan_num ; j++) begin

                                            //write
                                            for (int II=0;II <BIST_WL_NUM-64;II++) begin
                                                for(int KK=0;KK < COL_NUM;KK++) begin
                                                    @(negedge m_array_agent_if.gcas_wr);

                                                    //--------------------- wl vmc ----------------------
                                                    for (int kkk=rescan_radd_check_vmc_add_num; kkk<64;kkk++) begin
                                                        if (II >= read_err_row_reg_q[kkk]) begin
                                                            rescan_radd_check_vmc_add_num++;
                                                        end
                                                    end

                                                    if(m_array_agent_if.gradd_n != II + rescan_radd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II+rescan_radd_check_vmc_add_num, m_array_agent_if.gradd_n))

                                                    //--------------------- csl vmc ----------------------
                                                    if( (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM/10)) begin //part0 csl
                                                        if(KK >= read_err_csl_reg0_q[0] && KK < read_err_csl_reg0_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg0_q[0] && KK >= read_err_csl_reg0_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end
                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*2/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg1_q[0] && KK < read_err_csl_reg1_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg1_q[0] && KK >= read_err_csl_reg1_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end

                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*2/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*3/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg2_q[0] && KK < read_err_csl_reg2_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg2_q[0] && KK >= read_err_csl_reg2_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end

                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*3/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*4/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg3_q[0] && KK < read_err_csl_reg3_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg3_q[0] && KK >= read_err_csl_reg3_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end

                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*4/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*5/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg4_q[0] && KK < read_err_csl_reg4_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg4_q[0] && KK >= read_err_csl_reg4_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end
                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*5/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*6/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg5_q[0] && KK < read_err_csl_reg5_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg5_q[0] && KK >= read_err_csl_reg5_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end
                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*6/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*7/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg6_q[0] && KK < read_err_csl_reg6_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg6_q[0] && KK >= read_err_csl_reg6_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end
                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*7/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*8/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg7_q[0] && KK < read_err_csl_reg7_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg7_q[0] && KK >= read_err_csl_reg7_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end
                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*8/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*9/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg8_q[0] && KK < read_err_csl_reg8_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg8_q[0] && KK >= read_err_csl_reg8_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end
                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*9/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*10/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg9_q[0] && KK < read_err_csl_reg9_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg9_q[0] && KK >= read_err_csl_reg9_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end

                                                    if(m_array_agent_if.gcadd != KK + rescan_cadd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK + rescan_cadd_check_vmc_add_num, m_array_agent_if.gcadd))
                                                end
                                            end

                                            rescan_radd_check_vmc_add_num = 0;

                                            //read
                                            for (int II=0;II <BIST_WL_NUM-64;II++) begin
                                                for(int KK=0;KK < COL_NUM;KK++) begin
                                                    @(negedge m_array_agent_if.gcas_rd);

                                                    //--------------------- wl vmc ----------------------
                                                    for (int kkk=rescan_radd_check_vmc_add_num; kkk<64;kkk++) begin
                                                        if (II >= read_err_row_reg_q[kkk]) begin
                                                            rescan_radd_check_vmc_add_num++;
                                                        end
                                                    end

                                                    if(m_array_agent_if.gradd_n != II + rescan_radd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II+rescan_radd_check_vmc_add_num, m_array_agent_if.gradd_n))

                                                    //--------------------- csl vmc ----------------------
                                                    if( (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM/10)) begin //part0 csl
                                                        if(KK >= read_err_csl_reg0_q[0] && KK < read_err_csl_reg0_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg0_q[0] && KK >= read_err_csl_reg0_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end
                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*2/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg1_q[0] && KK < read_err_csl_reg1_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg1_q[0] && KK >= read_err_csl_reg1_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end

                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*2/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*3/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg2_q[0] && KK < read_err_csl_reg2_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg2_q[0] && KK >= read_err_csl_reg2_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end

                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*3/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*4/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg3_q[0] && KK < read_err_csl_reg3_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg3_q[0] && KK >= read_err_csl_reg3_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end

                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*4/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*5/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg4_q[0] && KK < read_err_csl_reg4_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg4_q[0] && KK >= read_err_csl_reg4_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end
                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*5/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*6/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg5_q[0] && KK < read_err_csl_reg5_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg5_q[0] && KK >= read_err_csl_reg5_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end
                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*6/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*7/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg6_q[0] && KK < read_err_csl_reg6_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg6_q[0] && KK >= read_err_csl_reg6_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end
                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*7/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*8/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg7_q[0] && KK < read_err_csl_reg7_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg7_q[0] && KK >= read_err_csl_reg7_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end
                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*8/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*9/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg8_q[0] && KK < read_err_csl_reg8_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg8_q[0] && KK >= read_err_csl_reg8_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end
                                                    else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*9/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*10/10)) begin //part1 csl
                                                        if(KK >= read_err_csl_reg9_q[0] && KK < read_err_csl_reg9_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd1;
                                                        end
                                                        else if (KK >= read_err_csl_reg9_q[0] && KK >= read_err_csl_reg9_q[1]) begin
                                                            rescan_cadd_check_vmc_add_num   =   'd2;
                                                        end
                                                        else begin
                                                            rescan_cadd_check_vmc_add_num   =   'd0;
                                                        end
                                                    end


                                                    if(m_array_agent_if.gcadd != KK + rescan_cadd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK + rescan_cadd_check_vmc_add_num, m_array_agent_if.gcadd))
                                                end
                                            end

                                            rescan_radd_check_vmc_add_num = 0;

                                        end

                                        repeat(4) @(posedge m_tb_if.clk);
                                        -> one_rescan_finish;
                                    end
                                end
                            join
                        end
                        do begin
                            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_reg.bist_rescan_finish.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            repeat(1000) @(posedge m_tb_if.clk);
                        end while(bist_rescan_finish != 1'b1);
                        while(1) begin
                            @(posedge m_array_agent_if.gcas_rd);
                            @(negedge m_array_agent_if.gcas_rd);
                            rescan_read_cnt = rescan_read_cnt + 1'b1;
                        end
                        while(1) begin
                            @(posedge m_array_agent_if.gcas_wr);
                            @(negedge m_array_agent_if.gcas_wr);
                            rescan_write_cnt = rescan_write_cnt + 1'b1;
                        end
                    join_any
                    disable fork;
                end
            join

            if (!m_tb_if.bist_rescan_finish)
                `uvm_error(get_type_name(),"interface bist_rescan_finish is not 1")

            //check read op num and write op num
            if (rescan_read_cnt != BIST_WL_NUM*COL_NUM*bist_rescan_num*bist_wl_scan_num)
                `uvm_error(get_type_name(),$sformatf("rescan read_cnt mismatch, exp is %0d,act is %0d",BIST_WL_NUM*COL_ALL_NUM*bist_rescan_num*bist_wl_scan_num, rescan_read_cnt))
            else 
                `uvm_info(get_type_name(),"read cnt check pass",UVM_LOW)
            if (rescan_write_cnt != BIST_WL_NUM*COL_NUM*bist_rescan_num*bist_wl_scan_num)
                `uvm_error(get_type_name(),$sformatf("rescan write cnt mismatch, exp is %0d,act is %0d",BIST_WL_NUM*COL_ALL_NUM*bist_rescan_num*bist_wl_scan_num, rescan_write_cnt))
            else 
                `uvm_info(get_type_name(),"write cnt check pass",UVM_LOW)

            rescan_read_cnt = 0;
            rescan_write_cnt = 0;

            //intr check
            if (bist_rescan_mask) begin
                if (m_tb_if.bist_finish_intr)   `uvm_error(get_type_name(),"mask is 1 but bist_finish_intr is 1")
            end
            else begin
                if (!m_tb_if.bist_finish_intr)   `uvm_error(get_type_name(),"mask is 0 but bist_finish_intr is 0")
            end

            //fail bit num check
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_rescan_fail_num_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
            if (err_rescan_total_bit_num > 20'hf_ffff) begin
                if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                    `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
            end
            else begin
                if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num)
                    `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num, mc_bist_rescan_fail_num_reg))
            end

            //check bist_rescan_success
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bank_success_reg.bist_rescan_success.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
            if(exp_bist_rescan_success != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success, bist_rescan_success_reg))


            //check rescan_round_result
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.rescan_round_result_reg.read(status, rescan_round_result, UVM_FRONTDOOR);
            foreach(rescan_round_result_q[i]) begin
                if (rescan_round_result[i] != rescan_round_result_q[i])
                    `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q[i], rescan_round_result[i]))
            end

            rescan_round_result_q.delete();

        end

    end

    //check
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.rescan_finish_clr_reg.write(status, 1'b1, UVM_FRONTDOOR);

    repeat(50) @(posedge m_tb_if.clk);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_reg.bist_rescan_finish.read(status, bist_rescan_finish, UVM_FRONTDOOR);
    if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan clr reg , bist_rescan_finish nor clear")


    //open scb check
    m_tb_if.bist_test_en = 1'b0;

    //write and read
    for(int i=0;i<WR_WL_NUM-64;i++)begin
        assert(m_frame_cfg.randomize with {
            cadd                == 0;
            radd                == i;
            frame_rw_flag       == 1;   //1:wr 0:rd
            one_frame_cnt       == BURST_WIDTH;
            col_addr_rand_en    == 0;
            wrap_en             == 0;
            strb_rand_en        == 0;
            strb                == 1;
        });
        send_one_frame(m_frame_cfg);        
    end
    for(int i=0;i<500;i++) begin
        assert(randomize(frame_rw_flag, wrap_en, col_addr_rand_en, radd, cadd, one_frame_cnt));
        assert(m_frame_cfg.randomize()with{
            m_frame_cfg.frame_rw_flag       ==  local::frame_rw_flag;
            m_frame_cfg.wrap_en             ==  local::wrap_en;
            m_frame_cfg.col_addr_rand_en    ==  local::col_addr_rand_en;
            m_frame_cfg.one_frame_cnt       ==  local::one_frame_cnt;
            m_frame_cfg.radd                ==  local::radd;
            m_frame_cfg.cadd                ==  local::cadd;
        });
        send_one_frame(m_frame_cfg);
    end

    //for toggle cov
    //bist_finish_mask
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_mask.write(status,bist_finish_mask,UVM_FRONTDOOR);
    `uvm_info(get_type_name(),$sformatf("bist_finish_mask is %0b", ~bist_finish_mask),UVM_LOW)

    //bist_rescan_mask
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.rescan_finish_mask_reg.rescan_finish_mask.write(status,bist_rescan_mask,UVM_FRONTDOOR);
    `uvm_info(get_type_name(),$sformatf("bist_rescan_mask is %0b", ~bist_rescan_mask),UVM_LOW)


    #100000ns;

endtask:body

`endif
