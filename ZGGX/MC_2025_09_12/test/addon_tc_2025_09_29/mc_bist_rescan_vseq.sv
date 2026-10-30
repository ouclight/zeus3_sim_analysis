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
    localparam      PART_NUM=10;

    localparam      ERR_CSL_DEFAULT_VALUE='hff;
    localparam      ERR_WL_DEFAULT_VALUE='h1fff;

    localparam      BURST_WIDTH='d128;
    //bist param
    rand bit [`PATTERN_WIDTH-1:0]   bist_pattern[4];
    rand int                        bist_csl_scan_num;
    rand int                        bist_wl_scan_num;
    rand bit [4:0]                  csl_err_threshold;
    rand bit                        bist_finish_mask;
    rand bit [3:0]                  bist_wl_scan_single_pattern_rd_num;
    rand bit [67:0]                 bist_csl_scan_sel;
    rand bit [67:0]                 bist_wl_scan_sel;
    rand bit                        mc_csl_scan_check_sel;
    rand bit                        mc_csl_scan_mode_sel;
    rand int                        err_csl_num_rand[10];               //num of err csl
    rand bit                        wl_success_mode;                //to limit err row num, 1:wl success, <=64;0: wl err_num rand
    rand int                        wl_success_num;
    //bist rescan
    rand bit [3:0]                  bist_rescan_num;        //default 3,max 8
    rand bit                        bist_rescan_mask;
    rand int                        err_rescan_bit_index;
    rand bit                        err_rescan_mode;        //1: current turn rescan has err_inject; 0: no err_inject



    rand bit [`ROW_ADDR_WIDTH-1:0]                 radd_up_down[10];

    //err_inject
    rand int                        num_csl_err_inject;
    rand bit                        case_mode;      //0:only rescan;    1:bist and then rescan
    rand int                        first_bist_err_wl_num;


    bit                             err_addr[BIST_WL_NUM-1:0][COL_ALL_NUM-1:0];

    bit [1:0]                       scan_redundant_csl[10];          //0: this part do not scan_redundant_csl; 1:scan 1 redundant csl; 2:scan 2 redundant csl
    bit [`ROW_ADDR_WIDTH-1:0]       err_wl_addr_q[$];                  //exclude csl vmc err row, err wl which can be scaned in wl scan
    bit [PART_NUM-1:0]              exp_csl_fail;                   //each part csl fail
    bit                             exp_wl_fail;


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
    rand bit [2:0] rand_num;//1~4

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
        bist_csl_scan_num inside {[1:68]};
    }

    constraint c_bist_wl_scan_num{
        bist_wl_scan_num inside {[1:68]};
    }

    constraint c_bist_csl_scan_sel{
        bist_csl_scan_sel != 'b0;
        $countones(bist_csl_scan_sel) < 3;
    }

    constraint c_bist_wl_scan_sel{
        bist_wl_scan_sel != 'b0;
        $countones(bist_wl_scan_sel) < 3;
    }

    constraint c_bist_wl_scan_single_pattern_rd_num{
        bist_wl_scan_single_pattern_rd_num  inside {['d0:'d15]}; 
    }

    constraint c_err_csl_num_rand {
        foreach(err_csl_num_rand[i]) 
            err_csl_num_rand[i] inside {[0:3]};
    }

    constraint c_wl_success_mode {
        wl_success_mode dist {0:=20, 1:=80};
    }

    constraint c_wl_success_num{
        wl_success_num inside {[40:64]};
    
    }

    constraint c_bist_rescan_num{
        ///bist_rescan_num inside {['d1:'d8]};
        bist_rescan_num dist {['d1:'d15]:/50, 'd3:/10, 'd8:/10, 'd15:/10};
    }

    constraint c_err_rescan_bit_index{
        err_rescan_bit_index inside {['d0:'d271]};
    }

    constraint c_csl_err_threshold{
        //csl_err_threshold dist {[1:31]:/50, 'd16:/50 };
        csl_err_threshold dist {[1:29]:/50, 'd16:/50 };
    }
    constraint rand_num_c {rand_num inside {[0:`BANK_ADDR_WIDTH-1]};}

    extern virtual task body();

    extern task gen_pattern_using(input bit [67:0] sel_param, output bit [`PATTERN_WIDTH-1:0] using_pattern_q[$]);

    extern task gen_err_csl(input bit [3:0] part, output bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$]);

    extern task gen_err_row(input bit[3:0] part, input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$]);

    extern task gen_bist_error(input bit [`PATTERN_WIDTH-1:0] using_csl_pattern_q[$], input bit [`PATTERN_WIDTH-1:0] using_wl_pattern_q[$], output bit [1:0]  hard_error_record[bit [`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]], output bit [1:0] soft_error_record[bit[1+7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]]);

    extern task gen_exp_csl(input bit [3:0] part, input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$], output bit [`COLUMN_ADDR_WIDTH-1:0] exp_err_csl_partx[68][6], input bit [`PATTERN_WIDTH-1:0] using_pattern_q[$],output bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0] csl_break_store_addr_q[$],input bit [1:0]  hard_error_record[bit [`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]],input bit [1:0] soft_error_record[bit[1+7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]]);

    extern task sort_err_csl(int num_csl_scan, bit [`COLUMN_ADDR_WIDTH-1:0] exp_err_csl_partx[68][6], output bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$], output bit [7+`COLUMN_ADDR_WIDTH-1:0] exp_check_csl_partx_q[$], output bit csl_part_fail);

    extern task gen_csl_fail_point(input bit [3:0] part, input bit [7+`COLUMN_ADDR_WIDTH-1:0] exp_check_csl_partx_q[$], ref bit [31:0] csl_fail_point_q[$], input bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0] csl_break_store_addr_q[$]);

    extern task gen_exp_err_row(input bit [3:0] part, input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$], ref bit [`ROW_ADDR_WIDTH+7-1:0] exp_err_row_q[$],input bit [1:0]  hard_error_record[bit [`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]],input bit [1:0] soft_error_record[bit[1+7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]], input  bit [`PATTERN_WIDTH-1:0] using_pattern_q[$]);

    extern task sort_err_row(input int num_wl_scan, ref bit [`ROW_ADDR_WIDTH+7-1:0] exp_err_row_q[$]);

    extern task exp_err_csl_check(input bit [3:0] part, input bit [7+`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$], input bit [`COLUMN_ADDR_WIDTH-1:0] read_err_csl_partx_q[$],input bit [7+4+`COLUMN_ADDR_WIDTH+`ROW_ADDR_WIDTH-1:0] csl_fail_point);

    extern task exp_err_wl_check(input bit [`ROW_ADDR_WIDTH+7-1:0] exp_err_row_q[$], input bit [`ROW_ADDR_WIDTH-1:0] read_err_row_reg_q[$]);

    extern task soft_error_process(input bit process_mode, input bit csl_wl_mode, input bit [6:0] pattern_index, input bit [1:0] soft_error_record[bit[1+7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]]);

    extern task hard_fail_release(input bit [1:0]  hard_error_record[bit [`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]], input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part0_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part1_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part2_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part3_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part4_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part5_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part6_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part7_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part8_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part9_q[$],input bit [`ROW_ADDR_WIDTH-1:0]     exp_err_row_q[$] );

    extern function int caculate_vmc_cnt(input bit [`ROW_ADDR_WIDTH-1:0] row_in, input bit [`COLUMN_ADDR_WIDTH-1:0] cadd_in);

    extern function bit [3:0] caculate_row_part(input bit [`ROW_ADDR_WIDTH-1:0] row_in);

    extern function bit [`ARRAY_DATA_WIDTH-1:0] caculate_gold_pattern_data(input bit [`PATTERN_WIDTH-1:0] pattern_using, input bit [`ROW_ADDR_WIDTH-1:0] row_in);
endclass:mc_bist_rescan_vseq

task mc_bist_rescan_vseq::body();

    bit    [3:0]                            bist_finish;
    int                                     mc_bist_err_wl_num_reg;
    int                                     mc_bist_err_wl_num_tmp;

    //-------------------- err_addr gen param --------------------------
    bit [`PATTERN_WIDTH-1:0]        bist_csl_pattern_using_q[$];
    bit [`PATTERN_WIDTH-1:0]        bist_wl_pattern_using_q[$];

    //storage which csl err >= th
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part0_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part1_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part2_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part3_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part4_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part5_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part6_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part7_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part8_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part9_q[$];

    bit [1:0]  hard_error_record[bit [`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]];
    bit [1:0]  soft_error_record[bit [1+7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]];

    bit                                     gap_check;                    //1:gap_check
    bit                                     gap_redundant_csl;
    //int                                     max_csl_up_err_num[$];
    //int                                     max_csl_down_err_num[$];
    int                                     num_row_err_addr_vmc=0;

    bit [`ROW_ADDR_WIDTH-1:0]               row_err_addr_q[$];          //log bank err row addr 
    bit [`ROW_ADDR_WIDTH-1:0]               row_err_addr_vmc_q[$];      //log after vmc row addr
    bit [`ROW_ADDR_WIDTH-1:0]               row_err_addr_tmp_q[$];      //one col, tmp err row
    bit [`ROW_ADDR_WIDTH-1:0]               tmp_q[$];                   //tmp line
    int                                     csl_vmc_num[10];             //0:up, 1:down

    //check
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part0[68][6];    //[68]  pattern index, [6]   err csl 
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part1[68][6];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part2[68][6];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part3[68][6];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part4[68][6];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part5[68][6];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part6[68][6];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part7[68][6];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part8[68][6];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part9[68][6];

    bit [7+`COLUMN_ADDR_WIDTH-1:0]  exp_check_csl_part0_q[$];
    bit [7+`COLUMN_ADDR_WIDTH-1:0]  exp_check_csl_part1_q[$];
    bit [7+`COLUMN_ADDR_WIDTH-1:0]  exp_check_csl_part2_q[$];
    bit [7+`COLUMN_ADDR_WIDTH-1:0]  exp_check_csl_part3_q[$];
    bit [7+`COLUMN_ADDR_WIDTH-1:0]  exp_check_csl_part4_q[$];
    bit [7+`COLUMN_ADDR_WIDTH-1:0]  exp_check_csl_part5_q[$];
    bit [7+`COLUMN_ADDR_WIDTH-1:0]  exp_check_csl_part6_q[$];
    bit [7+`COLUMN_ADDR_WIDTH-1:0]  exp_check_csl_part7_q[$];
    bit [7+`COLUMN_ADDR_WIDTH-1:0]  exp_check_csl_part8_q[$];
    bit [7+`COLUMN_ADDR_WIDTH-1:0]  exp_check_csl_part9_q[$];

    bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0]  csl_break_store_addr0_q[$];
    bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0]  csl_break_store_addr1_q[$];
    bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0]  csl_break_store_addr2_q[$];
    bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0]  csl_break_store_addr3_q[$];
    bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0]  csl_break_store_addr4_q[$];
    bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0]  csl_break_store_addr5_q[$];
    bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0]  csl_break_store_addr6_q[$];
    bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0]  csl_break_store_addr7_q[$];
    bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0]  csl_break_store_addr8_q[$];
    bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0]  csl_break_store_addr9_q[$];

    bit [7+4+`COLUMN_ADDR_WIDTH+`ROW_ADDR_WIDTH-1:0]    csl_fail_point='hffff_ffff;     //7bits indicate which pattern fail, 4bits which part fail, 8bits fail col addr
    bit [7+4+`COLUMN_ADDR_WIDTH+`ROW_ADDR_WIDTH-1:0]    csl_fail_point_q[$];     

    bit [`ROW_ADDR_WIDTH+7-1:0]     exp_err_row_q[$];        //{7bits 68 pattern index check info, row addr width}
    //-------------------- err_addr check param ------------------------
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_part0_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_part1_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_part2_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_part3_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_part4_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_part5_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_part6_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_part7_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_part8_q[$];
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_part9_q[$];

    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg;      
    bit [`ROW_ADDR_WIDTH-1:0]               read_err_row_reg_q[$];      //row err addr reg, 0~63
    bit [`ROW_ADDR_WIDTH-1:0]               read_err_row_reg;      //row err addr reg, 0~63
    bit [`ARRAY_DATA_WIDTH-1:0]                             err_wr_data;

    bit [`COLUMN_ADDR_WIDTH-1:0]            err_csl_addr;      
    bit [`ROW_ADDR_WIDTH-1:0]               err_row_addr;      

    bit                             csl_fail;
    bit                             wl_fail;
    bit                             bank_success;

    int                             vmc_cnt;                        //used to check wl scan addr after csl vmc
    int                             m;
    //-------------------- bist rescan param ------------------------
    bit                                     bist_rescan_finish;
    int                                     err_rescan_total_bit_num0,err_rescan_total_bit_num1,err_rescan_total_bit_num2,err_rescan_total_bit_num3;
    int                                     err_rescan_bit_index_q[$];
    bit [19:0]                              mc_bist_rescan_fail_num_reg;

    bit                                     exp_bist_rescan_finish;

    int                                     pattern_using_index;
    bit [`ROW_ADDR_WIDTH-1:0]               row_using_index;

    bit [`ROW_ADDR_WIDTH-1:0]               rescan_radd_check_vmc_add_num;
    bit [`COL_ADDR_WIDTH-1:0]               rescan_cadd_check_vmc_add_num;

    int                                     rescan_read_cnt;
    int                                     rescan_write_cnt;

    int                                     loop_times;
    int                                     bist_finish_and_success;

    bit                                     clk_gating_check;
    bit                                     dram_init_finish;
    bit                                     bist_rescan_success;
    bit                                     bist_rescan_success_reg;
    bit   [15:0]                            rescan_round_result;
    bit   [15:0]                            rescan_round_result_q0[$],rescan_round_result_q1[$],rescan_round_result_q2[$],rescan_round_result_q3[$];
    bit                                     exp_bist_rescan_success0,exp_bist_rescan_success1,exp_bist_rescan_success2,exp_bist_rescan_success3;
    event                                   one_rescan_finish0,one_rescan_finish1,one_rescan_finish2,one_rescan_finish3;
    bit   [31:0]                            exp_data;
    bit   [31:0]                            r_data; 

    super.body();

    uvm_hdl_deposit("mc_tb.u_quad_group.u_quad_group.XBK0.memory[0]",0);
    `ifdef TEST_1_SHOT_1
    `elsif TEST_1_SHOT_2
    uvm_hdl_deposit("mc_tb.u_quad_group.u_quad_group.XBK1.memory[0]",0);
    `elsif TEST_1_SHOT_3
    uvm_hdl_deposit("mc_tb.u_quad_group.u_quad_group.XBK1.memory[0]",0);
    uvm_hdl_deposit("mc_tb.u_quad_group.u_quad_group.XBK2.memory[0]",0);
    `elsif TEST_1_SHOT_4
    uvm_hdl_deposit("mc_tb.u_quad_group.u_quad_group.XBK1.memory[0]",0);
    uvm_hdl_deposit("mc_tb.u_quad_group.u_quad_group.XBK2.memory[0]",0);
    uvm_hdl_deposit("mc_tb.u_quad_group.u_quad_group.XBK3.memory[0]",0);
    `else
    uvm_hdl_deposit("mc_tb.u_quad_group.u_quad_group.XBK1.memory[0]",0);
    uvm_hdl_deposit("mc_tb.u_quad_group.u_quad_group.XBK2.memory[0]",0);
    `endif

    //close scb check
    m_tb_if.bist_test_en = 1'b1;

    //rand dbg_data_store_en
    @(posedge m_tb_if.clk);
    m_tb_if.dbg_data_store_en=$urandom_range(1);
    `uvm_info(get_type_name(), $sformatf("dbg_data_store_en is %0b",m_tb_if.dbg_data_store_en),UVM_LOW)

    //bist_finish_mask
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_mask.write(status,bist_finish_mask,UVM_FRONTDOOR);
    `uvm_info(get_type_name(),$sformatf("bist_finish_mask is %0b", bist_finish_mask),UVM_LOW)

    //bist_rescan_mask
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_finish_mask_reg.rescan_finish_mask.write(status,bist_rescan_mask,UVM_FRONTDOOR);
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

    //check parity data or not
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_csl_scan_check_sel.write(status, mc_csl_scan_check_sel, UVM_FRONTDOOR);

    //csl fail mode
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_csl_scan_mode_sel.write(status, mc_csl_scan_mode_sel, UVM_FRONTDOOR);

    //refresh start 
    @(posedge m_tb_if.clk);
    m_tb_if.mc_rf_start = 1'b1;

    //gen bist_pattern
    foreach (bist_pattern[j]) begin
        $display("bist_pattern%0d is %0h", j,bist_pattern[j]);
    end
    `uvm_info(get_type_name(),$sformatf("bist_csl_scan_sel=%b,bist_wl_scan_sel=%b",bist_csl_scan_sel,bist_wl_scan_sel),UVM_LOW);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg0_reg.write(status,bist_pattern[0],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg1_reg.write(status,bist_pattern[1],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg2_reg.write(status,bist_pattern[2],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg3_reg.write(status,bist_pattern[3],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.csl_bist_pattern_sel0_reg.write(status,bist_csl_scan_sel[31:0],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.csl_bist_pattern_sel1_reg.write(status,bist_csl_scan_sel[63:32],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.csl_bist_pattern_sel2_reg.write(status,bist_csl_scan_sel[67:64],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.wl_bist_pattern_sel0_reg.write(status,bist_wl_scan_sel[31:0],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.wl_bist_pattern_sel1_reg.write(status,bist_wl_scan_sel[63:32],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.wl_bist_pattern_sel2_reg.write(status,bist_wl_scan_sel[67:64],UVM_FRONTDOOR);
    
    repeat(5) @(posedge m_tb_if.pclk);
    bist_csl_scan_num = $countones(bist_csl_scan_sel);
    bist_wl_scan_num = $countones(bist_wl_scan_sel);

    //gen bist_pattern
    gen_pattern_using(bist_csl_scan_sel, bist_csl_pattern_using_q);
    gen_pattern_using(bist_wl_scan_sel, bist_wl_pattern_using_q);
    //---------------------- bist cfg -----------------------------

    m_tb_if.csl_err_threshold = csl_err_threshold;
    `uvm_info(get_type_name(),$sformatf("page_mode is %0d, bist_csl_scan_num is %0d, bist_wl_scan_num is %0d, csl_err_threshold is %0d",page_mode, bist_csl_scan_num, bist_wl_scan_num, csl_err_threshold),UVM_LOW)

    //open timeout
    //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_timeout_en.write(status,1'h1, UVM_FRONTDOOR);
    @(posedge m_tb_if.pclk);
    m_tb_if.mc_scan_timeout_en  =   1;

    //mc_en
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_en.write(status, 1'b1,UVM_FRONTDOOR);

    //global_mc_bist_en
    @(posedge m_tb_if.pclk);
    m_tb_if.global_mc_bist_en = 1'b0;
    #1000ns;

    //when global_mc_bist_en is 0, check rescan clk gating
    for (int i=0;i<5;i++) begin
        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.U_bist_rescan_top_aux.clk", clk_gating_check);
        if (clk_gating_check == 1)      `uvm_error(get_type_name(),"when global_mc_bist_en is 0, rescan clk not gating")
        #0.313ns;
    end

    //global_mc_bist_en
    @(posedge m_tb_if.pclk);
    m_tb_if.global_mc_bist_en = 1'b1;

    //rescan num
    if(!case_mode) begin
        //======================================= only bist rescan ===========================================

        //all ram addr 
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_rescan_addr_range_sel.write(status, 0, UVM_FRONTDOOR);

        for (int kk=0;kk<2;kk++) begin

            //rescan num
            assert(randomize(bist_rescan_num));
            m_tb_if.bist_rescan_num =   bist_rescan_num;
            `uvm_info(get_type_name(),$sformatf("bist_rescan_num is 'd%0d", bist_rescan_num),UVM_LOW)

            //-------------------- global_mc_rescan_start -----------------------
            `uvm_info(get_type_name(),"bist rescan start!",UVM_LOW)
            //clear exp varible
            err_rescan_total_bit_num0   =   0;
            err_rescan_total_bit_num1   =   0;
            err_rescan_total_bit_num2   =   0;
            err_rescan_total_bit_num3   =   0;
            exp_bist_rescan_success0    =   0;
            exp_bist_rescan_success1    =   0;
            exp_bist_rescan_success2    =   0;
            exp_bist_rescan_success3    =   0;

            @(posedge m_tb_if.pclk)
            m_tb_if.global_mc_rescan_start = 1'b1;

            @(posedge m_tb_if.pclk)
            m_tb_if.global_mc_rescan_start = 1'b0;

            `ifndef NO_INIT
            //wait dram_init_finish
            wait(m_tb_if.mc_dram_init_wr_finish == 1);
            repeat(4) @(posedge m_tb_if.clk);
            `endif

            fork
                begin
                    fork
                        begin
                            repeat(4) @(posedge m_tb_if.pclk);
                            //check rescan reg clr
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank0_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank0.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank0.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank0.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            `ifdef TEST_1_SHOT_1
                            `elsif TEST_1_SHOT_2
                            //{{{
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank1.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //}}}
                            `elsif TEST_1_SHOT_3
                            //{{{
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank1.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //bank2
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank2_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank2.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank2.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank2.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //}}}
                            `elsif TEST_1_SHOT_4
                             //{{{
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank1.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //bank2
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank2_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank2.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank2.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank2.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //bank3
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank3_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank3.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank3.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank3.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //}}}
                            `else
                             //{{{
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank1.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //bank2
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank2_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank2.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank2.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank2.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //}}}
                            `endif
                        end
                        //{{{
                        begin
                            bist_rescan_success = 1;        //set bist_rescan_success for check
                            @(posedge m_array_agent_if.gcas_wr[0]);
                            #1ps;
                            `uvm_info(get_type_name(),$sformatf("pattern check and force enter"),UVM_LOW)
                            err_wr_data = m_array_agent_if.wdl;
            
                            if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                            end
                            else begin
                                if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                    `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                end
                            end
                            while(1) begin
                                if(!($urandom_range(15000)) && err_rescan_mode) begin
                                    `uvm_info(get_type_name(),$sformatf("force enter"),UVM_LOW)
                                    bist_rescan_success = 0;
                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin
                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end
                                            
                                    loop_times = $urandom_range(1,272);
                                    for (int jj=0;jj< loop_times;jj++) begin
                                        assert(randomize(err_rescan_bit_index));
                                        err_rescan_bit_index_q.push_back(err_rescan_bit_index);
                                    end

                                    err_rescan_bit_index_q.sort();        //debug used

                                    err_rescan_bit_index_q = err_rescan_bit_index_q.unique();

                                    err_rescan_total_bit_num0 = err_rescan_total_bit_num0 + err_rescan_bit_index_q.size();
                                    `uvm_info(get_type_name(),$sformatf("err_rescan_total_bit_num is %0d",err_rescan_total_bit_num0),UVM_LOW)

                                    foreach(err_rescan_bit_index_q[i]) begin
                                        err_wr_data[err_rescan_bit_index_q[i]] = ~err_wr_data[err_rescan_bit_index_q[i]];
                                        `uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit index is %0d",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0, err_rescan_bit_index_q[i]),UVM_LOW)
                                    end

                                    uvm_hdl_force("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl", err_wr_data);
                                    `uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0),UVM_LOW)
                                    @(posedge m_tb_if.clk);
                                    #1ps;
                                    uvm_hdl_release("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl");
                                    err_rescan_bit_index_q.delete();
                                end
                                else begin
                                    @(posedge m_array_agent_if.gcas_wr);
                                    #1ps;
                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin

                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end

                                end
                            end
                        end
                        //}}}
                        //{{{
                        begin
                            bist_rescan_success = 1;        //set bist_rescan_success for check
                            @(posedge m_array_agent_if.gcas_wr[1]);
                            #1ps;
                            `uvm_info(get_type_name(),$sformatf("pattern check and force enter"),UVM_LOW)
                            err_wr_data = m_array_agent_if.wdl;
            
                            if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                            end
                            else begin
                                if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                    `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                end
                            end
                            while(1) begin
                                if(!($urandom_range(15000)) && err_rescan_mode) begin
                                    `uvm_info(get_type_name(),$sformatf("force enter"),UVM_LOW)
                                    bist_rescan_success = 0;
                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin
                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end
                                            
                                    loop_times = $urandom_range(1,272);
                                    for (int jj=0;jj< loop_times;jj++) begin
                                        assert(randomize(err_rescan_bit_index));
                                        err_rescan_bit_index_q.push_back(err_rescan_bit_index);
                                    end

                                    err_rescan_bit_index_q.sort();        //debug used

                                    err_rescan_bit_index_q = err_rescan_bit_index_q.unique();

                                    err_rescan_total_bit_num1 = err_rescan_total_bit_num1 + err_rescan_bit_index_q.size();
                                    `uvm_info(get_type_name(),$sformatf("err_rescan_total_bit_num is %0d",err_rescan_total_bit_num0),UVM_LOW)

                                    foreach(err_rescan_bit_index_q[i]) begin
                                        err_wr_data[err_rescan_bit_index_q[i]] = ~err_wr_data[err_rescan_bit_index_q[i]];
                                        `uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit index is %0d",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0, err_rescan_bit_index_q[i]),UVM_LOW)
                                    end

                                    uvm_hdl_force("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl", err_wr_data);
                                    `uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0),UVM_LOW)
                                    @(posedge m_tb_if.clk);
                                    #1ps;
                                    uvm_hdl_release("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl");
                                    err_rescan_bit_index_q.delete();
                                end
                                else begin
                                    @(posedge m_array_agent_if.gcas_wr);
                                    #1ps;
                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin

                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end

                                end
                            end
                        end
                        //}}}
                        //{{{
                        begin
                            bist_rescan_success = 1;        //set bist_rescan_success for check
                            @(posedge m_array_agent_if.gcas_wr[2]);
                            #1ps;
                            `uvm_info(get_type_name(),$sformatf("pattern check and force enter"),UVM_LOW)
                            err_wr_data = m_array_agent_if.wdl;
            
                            if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                            end
                            else begin
                                if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                    `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                end
                            end
                            while(1) begin
                                if(!($urandom_range(15000)) && err_rescan_mode) begin
                                    `uvm_info(get_type_name(),$sformatf("force enter"),UVM_LOW)
                                    bist_rescan_success = 0;
                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin
                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end
                                            
                                    loop_times = $urandom_range(1,272);
                                    for (int jj=0;jj< loop_times;jj++) begin
                                        assert(randomize(err_rescan_bit_index));
                                        err_rescan_bit_index_q.push_back(err_rescan_bit_index);
                                    end

                                    err_rescan_bit_index_q.sort();        //debug used

                                    err_rescan_bit_index_q = err_rescan_bit_index_q.unique();

                                    err_rescan_total_bit_num2 = err_rescan_total_bit_num2 + err_rescan_bit_index_q.size();
                                    `uvm_info(get_type_name(),$sformatf("err_rescan_total_bit_num is %0d",err_rescan_total_bit_num2),UVM_LOW)

                                    foreach(err_rescan_bit_index_q[i]) begin
                                        err_wr_data[err_rescan_bit_index_q[i]] = ~err_wr_data[err_rescan_bit_index_q[i]];
                                        `uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit index is %0d",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0, err_rescan_bit_index_q[i]),UVM_LOW)
                                    end

                                    uvm_hdl_force("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl", err_wr_data);
                                    `uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0),UVM_LOW)
                                    @(posedge m_tb_if.clk);
                                    #1ps;
                                    uvm_hdl_release("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl");
                                    err_rescan_bit_index_q.delete();
                                end
                                else begin
                                    @(posedge m_array_agent_if.gcas_wr);
                                    #1ps;
                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin

                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end

                                end
                            end
                        end
                        //}}}
                        //{{{
                        begin
                            bist_rescan_success = 1;        //set bist_rescan_success for check
                            @(posedge m_array_agent_if.gcas_wr[3]);
                            #1ps;
                            `uvm_info(get_type_name(),$sformatf("pattern check and force enter"),UVM_LOW)
                            err_wr_data = m_array_agent_if.wdl;
            
                            if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                            end
                            else begin
                                if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                    `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                end
                            end
                            while(1) begin
                                if(!($urandom_range(15000)) && err_rescan_mode) begin
                                    `uvm_info(get_type_name(),$sformatf("force enter"),UVM_LOW)
                                    bist_rescan_success = 0;
                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin
                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end
                                            
                                    loop_times = $urandom_range(1,272);
                                    for (int jj=0;jj< loop_times;jj++) begin
                                        assert(randomize(err_rescan_bit_index));
                                        err_rescan_bit_index_q.push_back(err_rescan_bit_index);
                                    end

                                    err_rescan_bit_index_q.sort();        //debug used

                                    err_rescan_bit_index_q = err_rescan_bit_index_q.unique();

                                    err_rescan_total_bit_num3 = err_rescan_total_bit_num3 + err_rescan_bit_index_q.size();
                                    `uvm_info(get_type_name(),$sformatf("err_rescan_total_bit_num is %0d",err_rescan_total_bit_num3),UVM_LOW)

                                    foreach(err_rescan_bit_index_q[i]) begin
                                        err_wr_data[err_rescan_bit_index_q[i]] = ~err_wr_data[err_rescan_bit_index_q[i]];
                                        `uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit index is %0d",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0, err_rescan_bit_index_q[i]),UVM_LOW)
                                    end

                                    uvm_hdl_force("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl", err_wr_data);
                                    `uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0),UVM_LOW)
                                    @(posedge m_tb_if.clk);
                                    #1ps;
                                    uvm_hdl_release("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl");
                                    err_rescan_bit_index_q.delete();
                                end
                                else begin
                                    @(posedge m_array_agent_if.gcas_wr);
                                    #1ps;
                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin

                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end

                                end
                            end
                        end
                        //}}}
                        begin
                            while(1) begin
                                @(one_rescan_finish0);
                                assert(randomize(err_rescan_mode));
                                rescan_round_result_q0.push_back(bist_rescan_success);
                                exp_bist_rescan_success0 = exp_bist_rescan_success0 | bist_rescan_success;
                                `uvm_info(get_type_name(),$sformatf("this turn rescan success is %0d, total success is %0d", bist_rescan_success, exp_bist_rescan_success0), UVM_LOW)
                                bist_rescan_success = 1;        //set bist_rescan_success for check
                            end
                        end
                        begin
                            while(1) begin
                                @(one_rescan_finish1);
                                assert(randomize(err_rescan_mode));
                                rescan_round_result_q1.push_back(bist_rescan_success);
                                exp_bist_rescan_success1 = exp_bist_rescan_success1 | bist_rescan_success;
                                `uvm_info(get_type_name(),$sformatf("this turn rescan success is %0d, total success is %0d", bist_rescan_success, exp_bist_rescan_success1), UVM_LOW)
                                bist_rescan_success = 1;        //set bist_rescan_success for check
                            end
                        end
                        begin
                            while(1) begin
                                @(one_rescan_finish2);
                                assert(randomize(err_rescan_mode));
                                rescan_round_result_q2.push_back(bist_rescan_success);
                                exp_bist_rescan_success2 = exp_bist_rescan_success2 | bist_rescan_success;
                                `uvm_info(get_type_name(),$sformatf("this turn rescan success is %0d, total success is %0d", bist_rescan_success, exp_bist_rescan_success2), UVM_LOW)
                                bist_rescan_success = 1;        //set bist_rescan_success for check
                            end
                        end
                        begin
                            while(1) begin
                                @(one_rescan_finish3);
                                assert(randomize(err_rescan_mode));
                                rescan_round_result_q3.push_back(bist_rescan_success);
                                exp_bist_rescan_success3 = exp_bist_rescan_success3 | bist_rescan_success;
                                `uvm_info(get_type_name(),$sformatf("this turn rescan success is %0d, total success is %0d", bist_rescan_success, exp_bist_rescan_success3), UVM_LOW)
                                bist_rescan_success = 1;        //set bist_rescan_success for check
                            end
                        end
                        begin
                            //-------- rescan num check ----------
                            m = 0;
                            repeat(`BANK_ADDR_WIDTH)begin
                            if(m==0)begin
                                for(int i=0; i < bist_rescan_num; i++) begin
                                    for(int j=0; j< bist_wl_scan_num ; j++) begin
                                        pattern_using_index = j;
                                        //write
                                        for (int II=0;II <BIST_WL_NUM;II++) begin
                                            row_using_index = II;
                                            for(int KK=0;KK < COL_ALL_NUM;KK++) begin
                                                @(negedge m_tb_if.gcas_wr_array_d0_0);
                                                if(m_tb_if.gradd_array_0 != II)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II, m_tb_if.gradd_array_0))
                                                if(m_tb_if.gcadd_array_0 != KK)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK, m_tb_if.gcadd_array_0))
                                            end
                                        end
                                        //read
                                        for (int II=0;II <BIST_WL_NUM;II++) begin
                                            for(int KK=0;KK < COL_ALL_NUM;KK++) begin
                                                @(negedge m_tb_if.gcas_rd_array_d0_0);
                                                if(m_tb_if.gradd_array_0 != II)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II, m_tb_if.gradd_array_0))
                                                if(m_tb_if.gcadd_array_0 != KK)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK, m_tb_if.gcadd_array_0))
                                            end
                                        end
                                    end
                                    repeat(4) @(posedge m_tb_if.clk);
                                    -> one_rescan_finish0;
                                end
                            end 
                            if(m==1)begin
                                //{{{
                                for(int i=0; i < bist_rescan_num; i++) begin
                                    for(int j=0; j< bist_wl_scan_num ; j++) begin
                                        pattern_using_index = j;
                                        //write
                                        for (int II=0;II <BIST_WL_NUM;II++) begin
                                            row_using_index = II;
                                            for(int KK=0;KK < COL_ALL_NUM;KK++) begin
                                                @(negedge m_tb_if.gcas_wr_array_d1_0);
                                                if(m_tb_if.gradd_array_0 != II)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II, m_tb_if.gradd_array_0))
                                                if(m_tb_if.gcadd_array_0 != KK)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK, m_tb_if.gcadd_array_0))
                                            end
                                        end
                                        //read
                                        for (int II=0;II <BIST_WL_NUM;II++) begin
                                            for(int KK=0;KK < COL_ALL_NUM;KK++) begin
                                                @(negedge m_tb_if.gcas_rd_array_d1_0);
                                                if(m_tb_if.gradd_array_0 != II)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II, m_tb_if.gradd_array_0))
                                                if(m_tb_if.gcadd_array_0 != KK)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK, m_tb_if.gcadd_array_0))
                                            end
                                        end
                                    end
                                    repeat(4) @(posedge m_tb_if.clk);
                                    -> one_rescan_finish1;
                                end
                                //}}}
                            end
                            if(m==2)begin
                                //{{{
                                for(int i=0; i < bist_rescan_num; i++) begin
                                    for(int j=0; j< bist_wl_scan_num ; j++) begin
                                        pattern_using_index = j;
                                        //write
                                        for (int II=0;II <BIST_WL_NUM;II++) begin
                                            row_using_index = II;
                                            for(int KK=0;KK < COL_ALL_NUM;KK++) begin
                                                @(negedge m_tb_if.gcas_wr_array_d2_0);
                                                if(m_tb_if.gradd_array_0 != II)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II, m_tb_if.gradd_array_0))
                                                if(m_tb_if.gcadd_array_0 != KK)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK, m_tb_if.gcadd_array_0))
                                            end
                                        end
                                        //read
                                        for (int II=0;II <BIST_WL_NUM;II++) begin
                                            for(int KK=0;KK < COL_ALL_NUM;KK++) begin
                                                @(negedge m_tb_if.gcas_rd_array_d2_0);
                                                if(m_tb_if.gradd_array_0 != II)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II, m_tb_if.gradd_array_0))
                                                if(m_tb_if.gcadd_array_0 != KK)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK, m_tb_if.gcadd_array_0))
                                            end
                                        end
                                    end
                                    repeat(4) @(posedge m_tb_if.clk);
                                    -> one_rescan_finish2;
                                end
                                //}}}
                            end
                            if(m==3)begin
                                //{{{
                                for(int i=0; i < bist_rescan_num; i++) begin
                                    for(int j=0; j< bist_wl_scan_num ; j++) begin
                                        pattern_using_index = j;
                                        //write
                                        for (int II=0;II <BIST_WL_NUM;II++) begin
                                            row_using_index = II;
                                            for(int KK=0;KK < COL_ALL_NUM;KK++) begin
                                                @(negedge m_tb_if.gcas_wr_array_d3_0);
                                                if(m_tb_if.gradd_array_0 != II)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II, m_tb_if.gradd_array_0))
                                                if(m_tb_if.gcadd_array_0 != KK)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK, m_tb_if.gcadd_array_0))
                                            end
                                        end
                                        //read
                                        for (int II=0;II <BIST_WL_NUM;II++) begin
                                            for(int KK=0;KK < COL_ALL_NUM;KK++) begin
                                                @(negedge m_tb_if.gcas_rd_array_d3_0);
                                                if(m_tb_if.gradd_array_0 != II)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II, m_tb_if.gradd_array_0))
                                                if(m_tb_if.gcadd_array_0 != KK)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK, m_tb_if.gcadd_array_0))
                                            end
                                        end
                                    end
                                    repeat(4) @(posedge m_tb_if.clk);
                                    -> one_rescan_finish3;
                                end
                                //}}}
                            end
                            m++;
                            `uvm_info(get_type_name(),$sformatf("m++,m=%0d!",m),UVM_LOW)
                            end
                        end
                    join
                end
                `ifdef TEST_1_SHOT_1
                do begin
                    exp_data = 'b1;
                    repeat(400) @(posedge m_tb_if.clk);
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.read(status, bist_finish_and_success, UVM_FRONTDOOR);
                end while(bist_finish_and_success[1] != exp_data);
                 `elsif TEST_1_SHOT_2
                do begin
                    exp_data = 'b11;
                    repeat(400) @(posedge m_tb_if.clk);
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.read(status, bist_finish_and_success, UVM_FRONTDOOR);
                end while(bist_finish_and_success[3:2] != exp_data);
                 `elsif TEST_1_SHOT_3
                do begin
                    exp_data = 'b111;
                    repeat(400) @(posedge m_tb_if.clk);
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.read(status, bist_finish_and_success, UVM_FRONTDOOR);
                end while(bist_finish_and_success[5:3] != exp_data);
                 `elsif TEST_1_SHOT_4
                do begin
                    exp_data = 'b1111;
                    repeat(400) @(posedge m_tb_if.clk);
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.read(status, bist_finish_and_success, UVM_FRONTDOOR);
                end while(bist_finish_and_success[7:4] != exp_data);
                 `else
                do begin
                    exp_data = 'b111;
                    repeat(400) @(posedge m_tb_if.clk);
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.read(status, bist_finish_and_success, UVM_FRONTDOOR);
                end while(bist_finish_and_success[5:3] != exp_data);
                 `endif
                while(1) begin
                    `ifdef TEST_1_SHOT_1
                        @(posedge m_tb_if.gcas_rd_array_d0_0);
                        @(negedge m_tb_if.gcas_rd_array_d0_0);
                    `elsif TEST_1_SHOT_2
                        @(posedge m_tb_if.gcas_rd_array_d1_0);
                        @(negedge m_tb_if.gcas_rd_array_d1_0);
                    `elsif TEST_1_SHOT_3
                        @(posedge m_tb_if.gcas_rd_array_d2_0);
                        @(negedge m_tb_if.gcas_rd_array_d2_0);
                    `elsif TEST_1_SHOT_4
                        @(posedge m_tb_if.gcas_rd_array_d3_0);
                        @(negedge m_tb_if.gcas_rd_array_d3_0);
                    `else
                        @(posedge m_tb_if.gcas_rd_array_d2_0);
                        @(negedge m_tb_if.gcas_rd_array_d2_0);
                    `endif
                    rescan_read_cnt = rescan_read_cnt + 1'b1;
                end
                while(1) begin
                    `ifdef TEST_1_SHOT_1
                        @(posedge m_tb_if.gcas_wr_array_d0_0);
                        @(negedge m_tb_if.gcas_wr_array_d0_0);
                    `elsif TEST_1_SHOT_2
                        @(posedge m_tb_if.gcas_wr_array_d1_0);
                        @(negedge m_tb_if.gcas_wr_array_d1_0);
                    `elsif TEST_1_SHOT_3
                        @(posedge m_tb_if.gcas_wr_array_d2_0);
                        @(negedge m_tb_if.gcas_wr_array_d2_0);
                    `elsif TEST_1_SHOT_4
                        @(posedge m_tb_if.gcas_wr_array_d3_0);
                        @(negedge m_tb_if.gcas_wr_array_d3_0);
                    `else
                        @(posedge m_tb_if.gcas_wr_array_d2_0);
                        @(negedge m_tb_if.gcas_wr_array_d2_0);
                    `endif
                    rescan_write_cnt = rescan_write_cnt + 1'b1;
                end
            join_any
            disable fork;
            
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

            //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank0_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);//fail bit num check
                if (err_rescan_total_bit_num0 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is 20'hf_ffff"),UVM_LOW)
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num0)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num0, mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is %0d", err_rescan_total_bit_num0),UVM_LOW)
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank0.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success0 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success0, bist_rescan_success_reg))
                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank0.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q0[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q0[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q0[i], rescan_round_result[i]))
                    else 
                        `uvm_info(get_type_name(),$sformatf("round %0d, success compare pass, is %0b, ", i, rescan_round_result_q0[i]), UVM_LOW)
                end
                //}}}
            `ifdef TEST_1_SHOT_1
            `elsif TEST_1_SHOT_2
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num1 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is 20'hf_ffff"),UVM_LOW)
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num1)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num1, mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is %0d", err_rescan_total_bit_num1),UVM_LOW)
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success1 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success1, bist_rescan_success_reg))
                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q1[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q1[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q1[i], rescan_round_result[i]))
                    else 
                        `uvm_info(get_type_name(),$sformatf("round %0d, success compare pass, is %0b, ", i, rescan_round_result_q1[i]), UVM_LOW)
                end
                //}}}
            `elsif TEST_1_SHOT_3
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num1 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is 20'hf_ffff"),UVM_LOW)
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num1)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num1, mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is %0d", err_rescan_total_bit_num1),UVM_LOW)
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success1 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success1, bist_rescan_success_reg))
                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q1[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q1[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q1[i], rescan_round_result[i]))
                    else 
                        `uvm_info(get_type_name(),$sformatf("round %0d, success compare pass, is %0b, ", i, rescan_round_result_q1[i]), UVM_LOW)
                end
                //}}}
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank2_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num2 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is 20'hf_ffff"),UVM_LOW)
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num2)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num2, mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is %0d", err_rescan_total_bit_num2),UVM_LOW)
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank2.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success2 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success2, bist_rescan_success_reg))
                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank2.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q1[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q1[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q1[i], rescan_round_result[i]))
                    else 
                        `uvm_info(get_type_name(),$sformatf("round %0d, success compare pass, is %0b, ", i, rescan_round_result_q1[i]), UVM_LOW)
                end
                //}}}
            `elsif TEST_1_SHOT_4
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num1 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is 20'hf_ffff"),UVM_LOW)
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num1)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num1, mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is %0d", err_rescan_total_bit_num1),UVM_LOW)
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success1 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success1, bist_rescan_success_reg))
                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q1[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q1[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q1[i], rescan_round_result[i]))
                    else 
                        `uvm_info(get_type_name(),$sformatf("round %0d, success compare pass, is %0b, ", i, rescan_round_result_q1[i]), UVM_LOW)
                end
                //}}}
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank2_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num2 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is 20'hf_ffff"),UVM_LOW)
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num2)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num2, mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is %0d", err_rescan_total_bit_num2),UVM_LOW)
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank2.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success2 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success2, bist_rescan_success_reg))
                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank2.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q2[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q2[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q2[i], rescan_round_result[i]))
                    else 
                        `uvm_info(get_type_name(),$sformatf("round %0d, success compare pass, is %0b, ", i, rescan_round_result_q2[i]), UVM_LOW)
                end
                //}}}
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank3_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num3 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is 20'hf_ffff"),UVM_LOW)
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num3)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num3, mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is %0d", err_rescan_total_bit_num3),UVM_LOW)
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank3.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success3 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success3, bist_rescan_success_reg))
                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank3.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q3[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q3[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q3[i], rescan_round_result[i]))
                    else 
                        `uvm_info(get_type_name(),$sformatf("round %0d, success compare pass, is %0b, ", i, rescan_round_result_q3[i]), UVM_LOW)
                end
                //}}}
            `else
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num1 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is 20'hf_ffff"),UVM_LOW)
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num1)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num1, mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is %0d", err_rescan_total_bit_num1),UVM_LOW)
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success1 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success1, bist_rescan_success_reg))
                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q1[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q1[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q1[i], rescan_round_result[i]))
                    else 
                        `uvm_info(get_type_name(),$sformatf("round %0d, success compare pass, is %0b, ", i, rescan_round_result_q1[i]), UVM_LOW)
                end
                //}}}
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank2_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num2 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is 20'hf_ffff"),UVM_LOW)
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num2)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num2, mc_bist_rescan_fail_num_reg))
                    else 
                        `uvm_info(get_type_name(), $sformatf("rescan fail num match, is %0d", err_rescan_total_bit_num2),UVM_LOW)
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank2.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success2 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success2, bist_rescan_success_reg))
                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank2.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q2[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q2[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q2[i], rescan_round_result[i]))
                    else 
                        `uvm_info(get_type_name(),$sformatf("round %0d, success compare pass, is %0b, ", i, rescan_round_result_q2[i]), UVM_LOW)
                end
                //}}}
            `endif
            rescan_round_result_q0.delete();
            rescan_round_result_q1.delete();
            rescan_round_result_q2.delete();
            rescan_round_result_q3.delete();
        end
        m_tb_if.bist_rescan_num =   0;
    end

    else begin
        
        //======================================= bist scan and bist rescan ===========================================
        //--------------- gen err_addr -----------------------

        //--------------------------------------------------------------------

        //gen original err csl
        gen_err_csl(4'd0, err_csl_part0_q);
        gen_err_csl(4'd1, err_csl_part1_q);
        gen_err_csl(4'd2, err_csl_part2_q);
        gen_err_csl(4'd3, err_csl_part3_q);
        gen_err_csl(4'd4, err_csl_part4_q);
        gen_err_csl(4'd5, err_csl_part5_q);
        gen_err_csl(4'd6, err_csl_part6_q);
        gen_err_csl(4'd7, err_csl_part7_q);
        gen_err_csl(4'd8, err_csl_part8_q);
        gen_err_csl(4'd9, err_csl_part9_q);

        //gen original err wl
        gen_err_row(4'd0, err_csl_part0_q);
        gen_err_row(4'd1, err_csl_part1_q);
        gen_err_row(4'd2, err_csl_part2_q);
        gen_err_row(4'd3, err_csl_part3_q);
        gen_err_row(4'd4, err_csl_part4_q);
        gen_err_row(4'd5, err_csl_part5_q);
        gen_err_row(4'd6, err_csl_part6_q);
        gen_err_row(4'd7, err_csl_part7_q);
        gen_err_row(4'd8, err_csl_part8_q);
        gen_err_row(4'd9, err_csl_part9_q);

        //all err_addr
        `uvm_info(get_type_name(), "\n---------------------------------- below is error addr ---------------------------------",UVM_LOW)
        foreach(err_addr[i,j]) begin
            if (err_addr[i][j] == 1'b1)
                $write("(%0h,%0h)  ",i,j);
        end

        //err csl addr
        $display("");
        for(int j=0;j<4;j++)begin
            $display("err_csl_part0_q is %0h", err_csl_part0_q[j]);
        end
        $display("");
        for(int j=0;j<4;j++)begin
            $display("err_csl_part1_q is %0h", err_csl_part1_q[j]);
        end
        $display("");
        for(int j=0;j<4;j++)begin
            $display("err_csl_part2_q is %0h", err_csl_part2_q[j]);
        end
        $display("");
        for(int j=0;j<4;j++)begin
            $display("err_csl_part3_q is %0h", err_csl_part3_q[j]);
        end
        $display("");
        for(int j=0;j<4;j++)begin
            $display("err_csl_part4_q is %0h", err_csl_part4_q[j]);
        end
        $display("");
        for(int j=0;j<4;j++)begin
            $display("err_csl_part5_q is %0h", err_csl_part5_q[j]);
        end
        $display("");
        for(int j=0;j<4;j++)begin
            $display("err_csl_part6_q is %0h", err_csl_part6_q[j]);
        end
        $display("");
        for(int j=0;j<4;j++)begin
            $display("err_csl_part7_q is %0h", err_csl_part7_q[j]);
        end
        $display("");
        for(int j=0;j<4;j++)begin
            $display("err_csl_part8_q is %0h", err_csl_part8_q[j]);
        end
        $display("");
        for(int j=0;j<4;j++)begin
            $display("err_csl_part9_q is %0h", err_csl_part9_q[j]);
        end
        $display("");

        //err row addr
        if (err_wl_addr_q.size()>0) begin
            err_wl_addr_q.sort();
        end
        $display("err row is :");
        foreach (err_wl_addr_q[i]) begin
            $write("%0h  ",err_wl_addr_q[i]);
        end
        $display("err row num is %0d", err_wl_addr_q.size());
        $display("");


        //----------------- err inject ---------------------
        gen_bist_error(bist_csl_pattern_using_q, bist_wl_pattern_using_q, hard_error_record, soft_error_record);
        //foreach(hard_error_record[i])
        //    $display("i is %0h, hard_error_record is %0d", i, hard_error_record[i]);

        //---- exp err csl gen based on using pattern ----

        //gen
        gen_exp_csl('d0, err_csl_part0_q, exp_err_csl_part0, bist_csl_pattern_using_q, csl_break_store_addr0_q, hard_error_record, soft_error_record);
        gen_exp_csl('d1, err_csl_part1_q, exp_err_csl_part1, bist_csl_pattern_using_q, csl_break_store_addr1_q, hard_error_record, soft_error_record);
        gen_exp_csl('d2, err_csl_part2_q, exp_err_csl_part2, bist_csl_pattern_using_q, csl_break_store_addr2_q, hard_error_record, soft_error_record);
        gen_exp_csl('d3, err_csl_part3_q, exp_err_csl_part3, bist_csl_pattern_using_q, csl_break_store_addr3_q, hard_error_record, soft_error_record);
        gen_exp_csl('d4, err_csl_part4_q, exp_err_csl_part4, bist_csl_pattern_using_q, csl_break_store_addr4_q, hard_error_record, soft_error_record);
        gen_exp_csl('d5, err_csl_part5_q, exp_err_csl_part5, bist_csl_pattern_using_q, csl_break_store_addr5_q, hard_error_record, soft_error_record);
        gen_exp_csl('d6, err_csl_part6_q, exp_err_csl_part6, bist_csl_pattern_using_q, csl_break_store_addr6_q, hard_error_record, soft_error_record);
        gen_exp_csl('d7, err_csl_part7_q, exp_err_csl_part7, bist_csl_pattern_using_q, csl_break_store_addr7_q, hard_error_record, soft_error_record);
        gen_exp_csl('d8, err_csl_part8_q, exp_err_csl_part8, bist_csl_pattern_using_q, csl_break_store_addr8_q, hard_error_record, soft_error_record);
        gen_exp_csl('d9, err_csl_part9_q, exp_err_csl_part9, bist_csl_pattern_using_q, csl_break_store_addr9_q, hard_error_record, soft_error_record);


        //---------- gen exp err csl addr ----------
        sort_err_csl(bist_csl_scan_num, exp_err_csl_part0, err_csl_part0_q, exp_check_csl_part0_q, exp_csl_fail[0]);
        sort_err_csl(bist_csl_scan_num, exp_err_csl_part1, err_csl_part1_q, exp_check_csl_part1_q, exp_csl_fail[1]);
        sort_err_csl(bist_csl_scan_num, exp_err_csl_part2, err_csl_part2_q, exp_check_csl_part2_q, exp_csl_fail[2]);
        sort_err_csl(bist_csl_scan_num, exp_err_csl_part3, err_csl_part3_q, exp_check_csl_part3_q, exp_csl_fail[3]);
        sort_err_csl(bist_csl_scan_num, exp_err_csl_part4, err_csl_part4_q, exp_check_csl_part4_q, exp_csl_fail[4]);
        sort_err_csl(bist_csl_scan_num, exp_err_csl_part5, err_csl_part5_q, exp_check_csl_part5_q, exp_csl_fail[5]);
        sort_err_csl(bist_csl_scan_num, exp_err_csl_part6, err_csl_part6_q, exp_check_csl_part6_q, exp_csl_fail[6]);
        sort_err_csl(bist_csl_scan_num, exp_err_csl_part7, err_csl_part7_q, exp_check_csl_part7_q, exp_csl_fail[7]);
        sort_err_csl(bist_csl_scan_num, exp_err_csl_part8, err_csl_part8_q, exp_check_csl_part8_q, exp_csl_fail[8]);
        sort_err_csl(bist_csl_scan_num, exp_err_csl_part9, err_csl_part9_q, exp_check_csl_part9_q, exp_csl_fail[9]);

        //err csl addr
        $display("");
        foreach(err_csl_part0_q[j]) begin
            $display("err_csl_part0_q is %0h", err_csl_part0_q[j]);
        end
        foreach(err_csl_part1_q[j]) begin
            $display("err_csl_part1_q is %0h", err_csl_part1_q[j]);
        end
        foreach(err_csl_part2_q[j]) begin
            $display("err_csl_part2_q is %0h", err_csl_part2_q[j]);
        end
        foreach(err_csl_part3_q[j]) begin
            $display("err_csl_part3_q is %0h", err_csl_part3_q[j]);
        end
        foreach(err_csl_part4_q[j]) begin
            $display("err_csl_part4_q is %0h", err_csl_part4_q[j]);
        end
        foreach(err_csl_part5_q[j]) begin
            $display("err_csl_part5_q is %0h", err_csl_part5_q[j]);
        end
        foreach(err_csl_part6_q[j]) begin
            $display("err_csl_part6_q is %0h", err_csl_part6_q[j]);
        end
        foreach(err_csl_part7_q[j]) begin
            $display("err_csl_part7_q is %0h", err_csl_part7_q[j]);
        end
        foreach(err_csl_part8_q[j]) begin
            $display("err_csl_part8_q is %0h", err_csl_part8_q[j]);
        end
        foreach(err_csl_part9_q[j]) begin
            $display("err_csl_part9_q is %0h", err_csl_part9_q[j]);
        end
        $display("");

        //err csl addr
        $display("");
        foreach(exp_check_csl_part0_q[j]) begin
            $display("exp_check_csl_part0_q is %0h", exp_check_csl_part0_q[j]);
        end
        foreach(exp_check_csl_part1_q[j]) begin
            $display("exp_check_csl_part1_q is %0h", exp_check_csl_part1_q[j]);
        end
        foreach(exp_check_csl_part2_q[j]) begin
            $display("exp_check_csl_part2_q is %0h", exp_check_csl_part2_q[j]);
        end
        foreach(exp_check_csl_part3_q[j]) begin
            $display("exp_check_csl_part3_q is %0h", exp_check_csl_part3_q[j]);
        end
        foreach(exp_check_csl_part4_q[j]) begin
            $display("exp_check_csl_part4_q is %0h", exp_check_csl_part4_q[j]);
        end
        foreach(exp_check_csl_part5_q[j]) begin
            $display("exp_check_csl_part5_q is %0h", exp_check_csl_part5_q[j]);
        end
        foreach(exp_check_csl_part6_q[j]) begin
            $display("exp_check_csl_part6_q is %0h", exp_check_csl_part6_q[j]);
        end
        foreach(exp_check_csl_part7_q[j]) begin
            $display("exp_check_csl_part7_q is %0h", exp_check_csl_part7_q[j]);
        end
        foreach(exp_check_csl_part8_q[j]) begin
            $display("exp_check_csl_part8_q is %0h", exp_check_csl_part8_q[j]);
        end
        foreach(exp_check_csl_part9_q[j]) begin
            $display("exp_check_csl_part9_q is %0h", exp_check_csl_part9_q[j]);
        end
        $display("");


        gen_csl_fail_point('d0, exp_check_csl_part0_q, csl_fail_point_q, csl_break_store_addr0_q);
        gen_csl_fail_point('d1, exp_check_csl_part1_q, csl_fail_point_q, csl_break_store_addr1_q);
        gen_csl_fail_point('d2, exp_check_csl_part2_q, csl_fail_point_q, csl_break_store_addr2_q);
        gen_csl_fail_point('d3, exp_check_csl_part3_q, csl_fail_point_q, csl_break_store_addr3_q);
        gen_csl_fail_point('d4, exp_check_csl_part4_q, csl_fail_point_q, csl_break_store_addr4_q);
        gen_csl_fail_point('d5, exp_check_csl_part5_q, csl_fail_point_q, csl_break_store_addr5_q);
        gen_csl_fail_point('d6, exp_check_csl_part6_q, csl_fail_point_q, csl_break_store_addr6_q);
        gen_csl_fail_point('d7, exp_check_csl_part7_q, csl_fail_point_q, csl_break_store_addr7_q);
        gen_csl_fail_point('d8, exp_check_csl_part8_q, csl_fail_point_q, csl_break_store_addr8_q);
        gen_csl_fail_point('d9, exp_check_csl_part9_q, csl_fail_point_q, csl_break_store_addr9_q);

        //find csl fail point 
        if (csl_fail_point_q.size()>0) begin
            csl_fail_point_q.sort();
            csl_fail_point = csl_fail_point_q[0];
            `uvm_info("csl_fail_point", $sformatf("csl_fail_point is %0h, pattern is %0d, part is %0d, cadd is %0h, radd is %0h", csl_fail_point, csl_fail_point[4+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+:7], csl_fail_point[`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+:4],csl_fail_point[`ROW_ADDR_WIDTH+:`COLUMN_ADDR_WIDTH], csl_fail_point[0+:`ROW_ADDR_WIDTH]),UVM_LOW)
        end
        //-------------------------

        //---------- gen exp err wl addr ----------
        gen_exp_err_row('d0, err_csl_part0_q, exp_err_row_q, hard_error_record, soft_error_record, bist_wl_pattern_using_q);
        gen_exp_err_row('d1, err_csl_part1_q, exp_err_row_q, hard_error_record, soft_error_record, bist_wl_pattern_using_q);
        gen_exp_err_row('d2, err_csl_part2_q, exp_err_row_q, hard_error_record, soft_error_record, bist_wl_pattern_using_q);
        gen_exp_err_row('d3, err_csl_part3_q, exp_err_row_q, hard_error_record, soft_error_record, bist_wl_pattern_using_q);
        gen_exp_err_row('d4, err_csl_part4_q, exp_err_row_q, hard_error_record, soft_error_record, bist_wl_pattern_using_q);
        gen_exp_err_row('d5, err_csl_part5_q, exp_err_row_q, hard_error_record, soft_error_record, bist_wl_pattern_using_q);
        gen_exp_err_row('d6, err_csl_part6_q, exp_err_row_q, hard_error_record, soft_error_record, bist_wl_pattern_using_q);
        gen_exp_err_row('d7, err_csl_part7_q, exp_err_row_q, hard_error_record, soft_error_record, bist_wl_pattern_using_q);
        gen_exp_err_row('d8, err_csl_part8_q, exp_err_row_q, hard_error_record, soft_error_record, bist_wl_pattern_using_q);
        gen_exp_err_row('d9, err_csl_part9_q, exp_err_row_q, hard_error_record, soft_error_record, bist_wl_pattern_using_q);
        //-------------------------

        //exp err row gen
        sort_err_row(bist_wl_scan_num, exp_err_row_q);
        $display("exp_err_row_q is");
        foreach(exp_err_row_q[j]) begin
            $write(" %0d pattern, %0h, ", exp_err_row_q[j][`ROW_ADDR_WIDTH+7-1-:7], exp_err_row_q[j][0+:`ROW_ADDR_WIDTH]);
        end
        $display("");
        //--------------------------------------------------

        //-------------------- global_mc_bist_start -----------------------
        `uvm_info(get_type_name(),"bist config!",UVM_LOW)
        //mc_en
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_en.write(status, 'b1,UVM_FRONTDOOR);
        //global_mc_bist_en
        @(posedge m_tb_if.pclk);
        m_tb_if.global_mc_bist_en = 1'b1;

        `ifndef NO_INIT
        //wait dram_init_finish
        `uvm_info(get_type_name(),"waitting initial!",UVM_LOW)
        wait(m_tb_if.mc_dram_init_wr_finish == 1);
        repeat(4) @(posedge m_tb_if.clk);
        `endif

        `uvm_info(get_type_name(),"bist scan start!",UVM_LOW)
        @(posedge m_tb_if.pclk)
        m_tb_if.global_mc_bist_start = 1'b1;
        @(posedge m_tb_if.pclk)
        m_tb_if.global_mc_bist_start = 1'b0;

        repeat(`BANK_ADDR_WIDTH)begin
            gap_check = 0;
            if(m==0)begin
        //{{{
            fork
                begin
                    //------------ csl checker --------------
                    for (int II=0;II<bist_csl_scan_num;II++) begin
                        //soft error inject
                        soft_error_process(1'b1, 1'b0, II, soft_error_record);
                        //write
                        for (int j=0;j<BIST_WL_NUM;j++)begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                @(negedge m_tb_if.gcas_wr_array_d0_0);
                                if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                            end
                        end
                        //--------- read part0 -------
                        `uvm_info("get_type_name", "---------------------- read part0 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=0;j<(BIST_WL_NUM/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d0_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 0 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 0 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part0 check end ---------------", UVM_LOW)
                        //--------- part0 done -------

                        //--------- read part1 -------
                        `uvm_info("get_type_name", "---------------------- read part1 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM/10);j<(BIST_WL_NUM*2/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d0_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 1 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[31:25] && 1 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part1 check end ---------------", UVM_LOW)
                        //--------- part1 done -------

                        //--------- read part2 -------
                        `uvm_info("get_type_name", "---------------------- read part2 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*2/10);j<(BIST_WL_NUM*3/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d0_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 2 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 2 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part2 check end ---------------", UVM_LOW)
                        //--------- part2 done -------

                        //--------- read part3 -------
                        `uvm_info("get_type_name", "---------------------- read part3 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*3/10);j<(BIST_WL_NUM*4/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d0_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 3 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 3 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part3 check end ---------------", UVM_LOW)
                        //--------- part3 done -------

                        //--------- read part4 -------
                        `uvm_info("get_type_name", "---------------------- read part4 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*4/10);j<(BIST_WL_NUM*5/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d0_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 4 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 4 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part4 check end ---------------", UVM_LOW)
                        //--------- part4 done -------

                        //--------- read part5 -------
                        `uvm_info("get_type_name", "---------------------- read part5 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*5/10);j<(BIST_WL_NUM*6/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d0_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 5 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 5 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part5 check end ---------------", UVM_LOW)
                        //--------- part5 done -------

                        //--------- read part6 -------
                        `uvm_info("get_type_name", "---------------------- read part6 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*6/10);j<(BIST_WL_NUM*7/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d0_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 6 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 6 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part6 check end ---------------", UVM_LOW)
                        //--------- part6 done -------

                        //--------- read part7 -------
                        `uvm_info("get_type_name", "---------------------- read part7 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*7/10);j<(BIST_WL_NUM*8/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d0_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 7 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 7 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part7 check end ---------------", UVM_LOW)
                        //--------- part7 done -------

                        //--------- read part8 -------
                        `uvm_info("get_type_name", "---------------------- read part8 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*8/10);j<(BIST_WL_NUM*9/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d0_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 8 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 8 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part8 check end ---------------", UVM_LOW)
                        //--------- part8 done -------

                        //--------- read part9 -------
                        `uvm_info("get_type_name", "---------------------- read part9 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*9/10);j<(BIST_WL_NUM*10/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d0_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 9 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 9 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part9 check end ---------------", UVM_LOW)
                        //--------- part9 done -------
                        //soft error inject
                        soft_error_process(1'b0, 1'b0, II, soft_error_record);

                        if (II == csl_fail_point[31:25]) begin
                            if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                break   ;
                            end
                        end
                    end
                    //------------ csl checker done --------------
                    `uvm_info(get_type_name(), $sformatf("exp_csl_fail is %0b",exp_csl_fail),UVM_LOW)
                    if (!exp_csl_fail || mc_csl_scan_mode_sel) begin
                    //------------ wl checker --------------
                        `uvm_info(get_type_name(), $sformatf("wl checker start!!"),UVM_LOW)
                        for (int II=0;II<bist_wl_scan_num;II++) begin
                            //soft error inject
                            soft_error_process(1'b1, 1'b1, II, soft_error_record);

                            //write
                            for (int j=0;j<BIST_WL_NUM;j++)begin
                                for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                    @(negedge m_tb_if.gcas_wr_array_d0_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf(" addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    vmc_cnt = caculate_vmc_cnt(j,i);

                                    if(m_tb_if.gcadd_array_0 != i+vmc_cnt)  `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_tb_if.gcadd_array_0))
                                end
                            end
                            for (int k=0;k<(bist_wl_scan_single_pattern_rd_num+'b1);k++) begin
                                //read
                                for (int j=0;j<BIST_WL_NUM;j++)begin
                                    for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                        @(negedge m_tb_if.gcas_rd_array_d0_0);
                                        if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                        vmc_cnt = caculate_vmc_cnt(j,i);
                                        if(m_tb_if.gcadd_array_0 != i+vmc_cnt)  `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_tb_if.gcadd_array_0))
                                    end
                                    if (exp_err_row_q.size()>64) begin
                                        if (exp_err_row_q[64] == {II[6:0], m_tb_if.gradd_array_0}) begin
                                            break;
                                        end
                                    end
                                end
                                if (exp_err_row_q.size()>64) begin
                                    if (exp_err_row_q[64] == {II[6:0], m_tb_if.gradd_array_0}) begin
                                        break;
                                    end
                                end
                            end
                            `uvm_info(get_type_name(), $sformatf("wl one pattern done!!"),UVM_LOW)
                            //soft error release
                            soft_error_process(1'b0, 1'b1, II, soft_error_record);

                            if (exp_err_row_q.size()>64) begin
                                if (exp_err_row_q[64] == {II[6:0], m_tb_if.gradd_array_0}) begin
                                    break;
                                end
                            end
                        end
                        `uvm_info(get_type_name(), $sformatf("wl checker done!!"),UVM_LOW)
                    end
                end
                begin
                    do begin
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.peek(status,bist_finish);
                        @(posedge m_tb_if.clk);
                    end while(bist_finish[0] != 1'b1);
                    //disable bist_check;
                end
            join
            //}}}
            end
            if(m==1)begin
        //{{{
            fork
                begin
                    //------------ csl checker --------------
                    for (int II=0;II<bist_csl_scan_num;II++) begin
                        //soft error inject
                        soft_error_process(1'b1, 1'b0, II, soft_error_record);
                        //write
                        for (int j=0;j<BIST_WL_NUM;j++)begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                @(negedge m_tb_if.gcas_wr_array_d1_0);
                                if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                            end
                        end
                        //--------- read part0 -------
                        `uvm_info("get_type_name", "---------------------- read part0 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=0;j<(BIST_WL_NUM/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d1_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 0 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 0 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part0 check end ---------------", UVM_LOW)
                        //--------- part0 done -------

                        //--------- read part1 -------
                        `uvm_info("get_type_name", "---------------------- read part1 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM/10);j<(BIST_WL_NUM*2/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d1_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 1 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[31:25] && 1 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part1 check end ---------------", UVM_LOW)
                        //--------- part1 done -------

                        //--------- read part2 -------
                        `uvm_info("get_type_name", "---------------------- read part2 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*2/10);j<(BIST_WL_NUM*3/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d1_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 2 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 2 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part2 check end ---------------", UVM_LOW)
                        //--------- part2 done -------

                        //--------- read part3 -------
                        `uvm_info("get_type_name", "---------------------- read part3 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*3/10);j<(BIST_WL_NUM*4/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d1_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 3 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 3 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part3 check end ---------------", UVM_LOW)
                        //--------- part3 done -------

                        //--------- read part4 -------
                        `uvm_info("get_type_name", "---------------------- read part4 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*4/10);j<(BIST_WL_NUM*5/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d1_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 4 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 4 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part4 check end ---------------", UVM_LOW)
                        //--------- part4 done -------

                        //--------- read part5 -------
                        `uvm_info("get_type_name", "---------------------- read part5 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*5/10);j<(BIST_WL_NUM*6/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d1_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 5 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 5 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part5 check end ---------------", UVM_LOW)
                        //--------- part5 done -------

                        //--------- read part6 -------
                        `uvm_info("get_type_name", "---------------------- read part6 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*6/10);j<(BIST_WL_NUM*7/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d1_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 6 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 6 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part6 check end ---------------", UVM_LOW)
                        //--------- part6 done -------

                        //--------- read part7 -------
                        `uvm_info("get_type_name", "---------------------- read part7 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*7/10);j<(BIST_WL_NUM*8/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d1_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 7 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 7 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part7 check end ---------------", UVM_LOW)
                        //--------- part7 done -------

                        //--------- read part8 -------
                        `uvm_info("get_type_name", "---------------------- read part8 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*8/10);j<(BIST_WL_NUM*9/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d1_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 8 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 8 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part8 check end ---------------", UVM_LOW)
                        //--------- part8 done -------

                        //--------- read part9 -------
                        `uvm_info("get_type_name", "---------------------- read part9 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*9/10);j<(BIST_WL_NUM*10/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d1_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 9 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 9 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part9 check end ---------------", UVM_LOW)
                        //--------- part9 done -------
                        //soft error inject
                        soft_error_process(1'b0, 1'b0, II, soft_error_record);

                        if (II == csl_fail_point[31:25]) begin
                            if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                break   ;
                            end
                        end
                    end
                    //------------ csl checker done --------------
                    `uvm_info(get_type_name(), $sformatf("exp_csl_fail is %0b",exp_csl_fail),UVM_LOW)
                    if (!exp_csl_fail || mc_csl_scan_mode_sel) begin
                    //------------ wl checker --------------
                        `uvm_info(get_type_name(), $sformatf("wl checker start!!"),UVM_LOW)
                        for (int II=0;II<bist_wl_scan_num;II++) begin
                            //soft error inject
                            soft_error_process(1'b1, 1'b1, II, soft_error_record);

                            //write
                            for (int j=0;j<BIST_WL_NUM;j++)begin
                                for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                    @(negedge m_tb_if.gcas_wr_array_d1_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf(" addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    vmc_cnt = caculate_vmc_cnt(j,i);

                                    if(m_tb_if.gcadd_array_0 != i+vmc_cnt)  `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_tb_if.gcadd_array_0))
                                end
                            end
                            for (int k=0;k<(bist_wl_scan_single_pattern_rd_num+'b1);k++) begin
                                //read
                                for (int j=0;j<BIST_WL_NUM;j++)begin
                                    for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                        @(negedge m_tb_if.gcas_rd_array_d1_0);
                                        if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                        vmc_cnt = caculate_vmc_cnt(j,i);
                                        if(m_tb_if.gcadd_array_0 != i+vmc_cnt)  `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_tb_if.gcadd_array_0))
                                    end
                                    if (exp_err_row_q.size()>64) begin
                                        if (exp_err_row_q[64] == {II[6:0], m_tb_if.gradd_array_0}) begin
                                            break;
                                        end
                                    end
                                end
                                if (exp_err_row_q.size()>64) begin
                                    if (exp_err_row_q[64] == {II[6:0], m_tb_if.gradd_array_0}) begin
                                        break;
                                    end
                                end
                            end
                            `uvm_info(get_type_name(), $sformatf("wl one pattern done!!"),UVM_LOW)
                            //soft error release
                            soft_error_process(1'b0, 1'b1, II, soft_error_record);

                            if (exp_err_row_q.size()>64) begin
                                if (exp_err_row_q[64] == {II[6:0], m_tb_if.gradd_array_0}) begin
                                    break;
                                end
                            end
                        end
                        `uvm_info(get_type_name(), $sformatf("wl checker done!!"),UVM_LOW)
                    end
                end
                begin
                    do begin
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.peek(status,bist_finish);
                        @(posedge m_tb_if.clk);
                    end while(bist_finish[1] != 1'b1);
                    //disable bist_check;
                end
            join
            //}}}
            end
            if(m==2)begin
        //{{{
            fork
                begin
                    //------------ csl checker --------------
                    for (int II=0;II<bist_csl_scan_num;II++) begin
                        //soft error inject
                        soft_error_process(1'b1, 1'b0, II, soft_error_record);
                        //write
                        for (int j=0;j<BIST_WL_NUM;j++)begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                @(negedge m_tb_if.gcas_wr_array_d2_0);
                                if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                            end
                        end
                        //--------- read part0 -------
                        `uvm_info("get_type_name", "---------------------- read part0 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=0;j<(BIST_WL_NUM/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d2_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 0 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 0 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part0 check end ---------------", UVM_LOW)
                        //--------- part0 done -------

                        //--------- read part1 -------
                        `uvm_info("get_type_name", "---------------------- read part1 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM/10);j<(BIST_WL_NUM*2/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d2_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 1 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[31:25] && 1 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part1 check end ---------------", UVM_LOW)
                        //--------- part1 done -------

                        //--------- read part2 -------
                        `uvm_info("get_type_name", "---------------------- read part2 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*2/10);j<(BIST_WL_NUM*3/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d2_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 2 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 2 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part2 check end ---------------", UVM_LOW)
                        //--------- part2 done -------

                        //--------- read part3 -------
                        `uvm_info("get_type_name", "---------------------- read part3 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*3/10);j<(BIST_WL_NUM*4/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d2_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 3 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 3 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part3 check end ---------------", UVM_LOW)
                        //--------- part3 done -------

                        //--------- read part4 -------
                        `uvm_info("get_type_name", "---------------------- read part4 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*4/10);j<(BIST_WL_NUM*5/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d2_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 4 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 4 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part4 check end ---------------", UVM_LOW)
                        //--------- part4 done -------

                        //--------- read part5 -------
                        `uvm_info("get_type_name", "---------------------- read part5 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*5/10);j<(BIST_WL_NUM*6/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d2_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 5 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 5 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part5 check end ---------------", UVM_LOW)
                        //--------- part5 done -------

                        //--------- read part6 -------
                        `uvm_info("get_type_name", "---------------------- read part6 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*6/10);j<(BIST_WL_NUM*7/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d2_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 6 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 6 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part6 check end ---------------", UVM_LOW)
                        //--------- part6 done -------

                        //--------- read part7 -------
                        `uvm_info("get_type_name", "---------------------- read part7 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*7/10);j<(BIST_WL_NUM*8/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d2_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 7 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 7 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part7 check end ---------------", UVM_LOW)
                        //--------- part7 done -------

                        //--------- read part8 -------
                        `uvm_info("get_type_name", "---------------------- read part8 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*8/10);j<(BIST_WL_NUM*9/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d2_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 8 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 8 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part8 check end ---------------", UVM_LOW)
                        //--------- part8 done -------

                        //--------- read part9 -------
                        `uvm_info("get_type_name", "---------------------- read part9 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*9/10);j<(BIST_WL_NUM*10/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d2_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 9 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 9 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part9 check end ---------------", UVM_LOW)
                        //--------- part9 done -------
                        //soft error inject
                        soft_error_process(1'b0, 1'b0, II, soft_error_record);

                        if (II == csl_fail_point[31:25]) begin
                            if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                break   ;
                            end
                        end
                    end
                    //------------ csl checker done --------------
                    `uvm_info(get_type_name(), $sformatf("exp_csl_fail is %0b",exp_csl_fail),UVM_LOW)
                    if (!exp_csl_fail || mc_csl_scan_mode_sel) begin
                    //------------ wl checker --------------
                        `uvm_info(get_type_name(), $sformatf("wl checker start!!"),UVM_LOW)
                        for (int II=0;II<bist_wl_scan_num;II++) begin
                            //soft error inject
                            soft_error_process(1'b1, 1'b1, II, soft_error_record);

                            //write
                            for (int j=0;j<BIST_WL_NUM;j++)begin
                                for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                    @(negedge m_tb_if.gcas_wr_array_d2_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf(" addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    vmc_cnt = caculate_vmc_cnt(j,i);

                                    if(m_tb_if.gcadd_array_0 != i+vmc_cnt)  `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_tb_if.gcadd_array_0))
                                end
                            end
                            for (int k=0;k<(bist_wl_scan_single_pattern_rd_num+'b1);k++) begin
                                //read
                                for (int j=0;j<BIST_WL_NUM;j++)begin
                                    for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                        @(negedge m_tb_if.gcas_rd_array_d2_0);
                                        if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                        vmc_cnt = caculate_vmc_cnt(j,i);
                                        if(m_tb_if.gcadd_array_0 != i+vmc_cnt)  `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_tb_if.gcadd_array_0))
                                    end
                                    if (exp_err_row_q.size()>64) begin
                                        if (exp_err_row_q[64] == {II[6:0], m_tb_if.gradd_array_0}) begin
                                            break;
                                        end
                                    end
                                end
                                if (exp_err_row_q.size()>64) begin
                                    if (exp_err_row_q[64] == {II[6:0], m_tb_if.gradd_array_0}) begin
                                        break;
                                    end
                                end
                            end
                            `uvm_info(get_type_name(), $sformatf("wl one pattern done!!"),UVM_LOW)
                            //soft error release
                            soft_error_process(1'b0, 1'b1, II, soft_error_record);

                            if (exp_err_row_q.size()>64) begin
                                if (exp_err_row_q[64] == {II[6:0], m_tb_if.gradd_array_0}) begin
                                    break;
                                end
                            end
                        end
                        `uvm_info(get_type_name(), $sformatf("wl checker done!!"),UVM_LOW)
                    end
                end
                begin
                    do begin
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.peek(status,bist_finish);
                        @(posedge m_tb_if.clk);
                    end while(bist_finish[2] != 1'b1);
                    //disable bist_check;
                end
            join
            //}}}
            end
            if(m==3)begin
        //{{{
            fork
                begin
                    //------------ csl checker --------------
                    for (int II=0;II<bist_csl_scan_num;II++) begin
                        //soft error inject
                        soft_error_process(1'b1, 1'b0, II, soft_error_record);
                        //write
                        for (int j=0;j<BIST_WL_NUM;j++)begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                @(negedge m_tb_if.gcas_wr_array_d3_0);
                                if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                            end
                        end
                        //--------- read part0 -------
                        `uvm_info("get_type_name", "---------------------- read part0 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=0;j<(BIST_WL_NUM/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d3_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 0 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 0 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part0 check end ---------------", UVM_LOW)
                        //--------- part0 done -------

                        //--------- read part1 -------
                        `uvm_info("get_type_name", "---------------------- read part1 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM/10);j<(BIST_WL_NUM*2/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d3_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 1 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[31:25] && 1 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part1 check end ---------------", UVM_LOW)
                        //--------- part1 done -------

                        //--------- read part2 -------
                        `uvm_info("get_type_name", "---------------------- read part2 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*2/10);j<(BIST_WL_NUM*3/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d3_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 2 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 2 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part2 check end ---------------", UVM_LOW)
                        //--------- part2 done -------

                        //--------- read part3 -------
                        `uvm_info("get_type_name", "---------------------- read part3 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*3/10);j<(BIST_WL_NUM*4/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d3_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 3 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 3 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part3 check end ---------------", UVM_LOW)
                        //--------- part3 done -------

                        //--------- read part4 -------
                        `uvm_info("get_type_name", "---------------------- read part4 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*4/10);j<(BIST_WL_NUM*5/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d3_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 4 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 4 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part4 check end ---------------", UVM_LOW)
                        //--------- part4 done -------

                        //--------- read part5 -------
                        `uvm_info("get_type_name", "---------------------- read part5 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*5/10);j<(BIST_WL_NUM*6/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d3_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 5 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 5 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part5 check end ---------------", UVM_LOW)
                        //--------- part5 done -------

                        //--------- read part6 -------
                        `uvm_info("get_type_name", "---------------------- read part6 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*6/10);j<(BIST_WL_NUM*7/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d3_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 6 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 6 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part6 check end ---------------", UVM_LOW)
                        //--------- part6 done -------

                        //--------- read part7 -------
                        `uvm_info("get_type_name", "---------------------- read part7 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*7/10);j<(BIST_WL_NUM*8/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d3_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 7 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 7 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part7 check end ---------------", UVM_LOW)
                        //--------- part7 done -------

                        //--------- read part8 -------
                        `uvm_info("get_type_name", "---------------------- read part8 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*8/10);j<(BIST_WL_NUM*9/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d3_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 8 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 8 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part8 check end ---------------", UVM_LOW)
                        //--------- part8 done -------

                        //--------- read part9 -------
                        `uvm_info("get_type_name", "---------------------- read part9 check start ---------------", UVM_LOW)
                        if(!gap_check || mc_csl_scan_mode_sel) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*9/10);j<(BIST_WL_NUM*10/10);j++)begin
                                    @(negedge m_tb_if.gcas_rd_array_d3_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    if(m_tb_if.gcadd_array_0 != i)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp cadd is %0h, act is %0h", i, m_tb_if.gcadd_array_0))
                                    if (II == csl_fail_point[31:25] && 9 == csl_fail_point[24:21] && i == csl_fail_point[20:13] && j == csl_fail_point[0+:13]) begin
                                        gap_check = 1'b1;
                                        if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                            break;
                                        end
                                    end
                                end
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 
                                if (II == csl_fail_point[31:25] && 9 == csl_fail_point[24:21] && i == csl_fail_point[20:13]) begin
                                    gap_check = 1'b1;
                                    if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                        break;
                                    end
                                end
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part9 check end ---------------", UVM_LOW)
                        //--------- part9 done -------
                        //soft error inject
                        soft_error_process(1'b0, 1'b0, II, soft_error_record);

                        if (II == csl_fail_point[31:25]) begin
                            if(!(!gap_check || mc_csl_scan_mode_sel)) begin
                                break   ;
                            end
                        end
                    end
                    //------------ csl checker done --------------
                    `uvm_info(get_type_name(), $sformatf("exp_csl_fail is %0b",exp_csl_fail),UVM_LOW)
                    if (!exp_csl_fail || mc_csl_scan_mode_sel) begin
                    //------------ wl checker --------------
                        `uvm_info(get_type_name(), $sformatf("wl checker start!!"),UVM_LOW)
                        for (int II=0;II<bist_wl_scan_num;II++) begin
                            //soft error inject
                            soft_error_process(1'b1, 1'b1, II, soft_error_record);

                            //write
                            for (int j=0;j<BIST_WL_NUM;j++)begin
                                for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                    @(negedge m_tb_if.gcas_wr_array_d3_0);
                                    if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf(" addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    vmc_cnt = caculate_vmc_cnt(j,i);

                                    if(m_tb_if.gcadd_array_0 != i+vmc_cnt)  `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_tb_if.gcadd_array_0))
                                end
                            end
                            for (int k=0;k<(bist_wl_scan_single_pattern_rd_num+'b1);k++) begin
                                //read
                                for (int j=0;j<BIST_WL_NUM;j++)begin
                                    for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                        @(negedge m_tb_if.gcas_rd_array_d3_0);
                                        if(m_tb_if.gradd_array_0 != j)  `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                        vmc_cnt = caculate_vmc_cnt(j,i);
                                        if(m_tb_if.gcadd_array_0 != i+vmc_cnt)  `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_tb_if.gcadd_array_0))
                                    end
                                    if (exp_err_row_q.size()>64) begin
                                        if (exp_err_row_q[64] == {II[6:0], m_tb_if.gradd_array_0}) begin
                                            break;
                                        end
                                    end
                                end
                                if (exp_err_row_q.size()>64) begin
                                    if (exp_err_row_q[64] == {II[6:0], m_tb_if.gradd_array_0}) begin
                                        break;
                                    end
                                end
                            end
                            `uvm_info(get_type_name(), $sformatf("wl one pattern done!!"),UVM_LOW)
                            //soft error release
                            soft_error_process(1'b0, 1'b1, II, soft_error_record);

                            if (exp_err_row_q.size()>64) begin
                                if (exp_err_row_q[64] == {II[6:0], m_tb_if.gradd_array_0}) begin
                                    break;
                                end
                            end
                        end
                        `uvm_info(get_type_name(), $sformatf("wl checker done!!"),UVM_LOW)
                    end
                end
                begin
                    do begin
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.peek(status,bist_finish);
                        @(posedge m_tb_if.clk);
                    end while(bist_finish[3] != 1'b1);
                    //disable bist_check;
                end
            join
            //}}}
            end
            m++;
        end
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

        repeat(10) @(posedge m_tb_if.clk);

        //--------------------------------------------------
        //read err csl addr
        //-----bank0
        //{{{
        read_err_csl_part0_q.delete;
        read_err_csl_part1_q.delete;
        read_err_csl_part2_q.delete;
        read_err_csl_part3_q.delete;
        read_err_csl_part4_q.delete;
        read_err_csl_part5_q.delete;
        read_err_csl_part6_q.delete;
        read_err_csl_part7_q.delete;
        read_err_csl_part8_q.delete;
        read_err_csl_part9_q.delete;
        read_err_row_reg_q.delete;

        //read err csl addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank0_reg.err_csl0_part0_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank0_reg.err_csl1_part0_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank0_reg.err_csl0_part1_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank0_reg.err_csl1_part1_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank0_reg.err_csl0_part2_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank0_reg.err_csl1_part2_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank0_reg.err_csl0_part3_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank0_reg.err_csl1_part3_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank0_reg.err_csl0_part4_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank0_reg.err_csl1_part4_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank0_reg.err_csl0_part5_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank0_reg.err_csl1_part5_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank0_reg.err_csl0_part6_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank0_reg.err_csl1_part6_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank0_reg.err_csl0_part7_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank0_reg.err_csl1_part7_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank0_reg.err_csl0_part8_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank0_reg.err_csl1_part8_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank0_reg.err_csl0_part9_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank0_reg.err_csl1_part9_bank0.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);

        `uvm_info(get_type_name(),"read bist err wl!",UVM_LOW)
        //read err row addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank0_reg.err_wl0_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank0_reg.err_wl1_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank0_reg.err_wl2_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank0_reg.err_wl3_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank0_reg.err_wl4_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank0_reg.err_wl5_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank0_reg.err_wl6_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank0_reg.err_wl7_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank0_reg.err_wl8_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank0_reg.err_wl9_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank0_reg.err_wl10_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank0_reg.err_wl11_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank0_reg.err_wl12_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank0_reg.err_wl13_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank0_reg.err_wl14_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank0_reg.err_wl15_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank0_reg.err_wl16_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank0_reg.err_wl17_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank0_reg.err_wl18_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank0_reg.err_wl19_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank0_reg.err_wl20_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank0_reg.err_wl21_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank0_reg.err_wl22_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank0_reg.err_wl23_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank0_reg.err_wl24_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank0_reg.err_wl25_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank0_reg.err_wl26_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank0_reg.err_wl27_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank0_reg.err_wl28_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank0_reg.err_wl29_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank0_reg.err_wl30_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank0_reg.err_wl31_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank0_reg.err_wl32_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank0_reg.err_wl33_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank0_reg.err_wl34_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank0_reg.err_wl35_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank0_reg.err_wl36_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank0_reg.err_wl37_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank0_reg.err_wl38_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank0_reg.err_wl39_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank0_reg.err_wl40_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank0_reg.err_wl41_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank0_reg.err_wl42_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank0_reg.err_wl43_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank0_reg.err_wl44_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank0_reg.err_wl45_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank0_reg.err_wl46_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank0_reg.err_wl47_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank0_reg.err_wl48_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank0_reg.err_wl49_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank0_reg.err_wl50_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank0_reg.err_wl51_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank0_reg.err_wl52_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank0_reg.err_wl53_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank0_reg.err_wl54_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank0_reg.err_wl55_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank0_reg.err_wl56_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank0_reg.err_wl57_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank0_reg.err_wl58_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank0_reg.err_wl59_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank0_reg.err_wl60_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank0_reg.err_wl61_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank0_reg.err_wl62_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank0_reg.err_wl63_bank0.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);

        //check err csl
        exp_err_csl_check('d0, exp_check_csl_part0_q,read_err_csl_part0_q, csl_fail_point);
        exp_err_csl_check('d1, exp_check_csl_part1_q,read_err_csl_part1_q, csl_fail_point);
        exp_err_csl_check('d2, exp_check_csl_part2_q,read_err_csl_part2_q, csl_fail_point);
        exp_err_csl_check('d3, exp_check_csl_part3_q,read_err_csl_part3_q, csl_fail_point);
        exp_err_csl_check('d4, exp_check_csl_part4_q,read_err_csl_part4_q, csl_fail_point);
        exp_err_csl_check('d5, exp_check_csl_part5_q,read_err_csl_part5_q, csl_fail_point);
        exp_err_csl_check('d6, exp_check_csl_part6_q,read_err_csl_part6_q, csl_fail_point);
        exp_err_csl_check('d7, exp_check_csl_part7_q,read_err_csl_part7_q, csl_fail_point);
        exp_err_csl_check('d8, exp_check_csl_part8_q,read_err_csl_part8_q, csl_fail_point);
        exp_err_csl_check('d9, exp_check_csl_part9_q,read_err_csl_part9_q, csl_fail_point);

        //check err row
        exp_err_wl_check(exp_err_row_q, read_err_row_reg_q);

        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_fail", csl_fail);
        if (!mc_csl_scan_mode_sel) begin
            if ((|exp_csl_fail) != csl_fail)   
                `uvm_error(get_type_name(),$sformatf("csl fail check err, exp %0b, act %0b",(|exp_csl_fail), csl_fail))
        end

        //check bist success
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bank_success_bank0.read(status, bank_success);
        if (bank_success !== (mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail))) begin
            `uvm_error(get_type_name(),$sformatf("bank_success check err, exp %0b, act %0b",mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail), bank_success))
        end
        //}}}
        `ifdef TEST_1_SHOT_1
        if (!exp_csl_fail || mc_csl_scan_mode_sel) begin
            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_wl_scan_top.inst%0d.bank0_bist_wl_fail",4-`BANK_ADDR_WIDTH),wl_fail);
            if ((exp_wl_fail) != wl_fail)   `uvm_error(get_type_name(),$sformatf("wl fail check err, exp %0b, act %0b",exp_wl_fail, wl_fail))
        end
        `elsif TEST_1_SHOT_2
        //{{{
        read_err_csl_part0_q.delete;
        read_err_csl_part1_q.delete;
        read_err_csl_part2_q.delete;
        read_err_csl_part3_q.delete;
        read_err_csl_part4_q.delete;
        read_err_csl_part5_q.delete;
        read_err_csl_part6_q.delete;
        read_err_csl_part7_q.delete;
        read_err_csl_part8_q.delete;
        read_err_csl_part9_q.delete;
        read_err_row_reg_q.delete;

        //read err csl addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl0_part0_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl1_part0_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl0_part1_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl1_part1_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl0_part2_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl1_part2_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl0_part3_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl1_part3_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl0_part4_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl1_part4_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl0_part5_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl1_part5_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl0_part6_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl1_part6_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl0_part7_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl1_part7_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl0_part8_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl1_part8_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl0_part9_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl1_part9_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);

        `uvm_info(get_type_name(),"read bist err wl!",UVM_LOW)
        //read err row addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank1_reg.err_wl0_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank1_reg.err_wl1_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank1_reg.err_wl2_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank1_reg.err_wl3_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank1_reg.err_wl4_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank1_reg.err_wl5_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank1_reg.err_wl6_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank1_reg.err_wl7_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank1_reg.err_wl8_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank1_reg.err_wl9_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank1_reg.err_wl10_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank1_reg.err_wl11_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank1_reg.err_wl12_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank1_reg.err_wl13_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank1_reg.err_wl14_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank1_reg.err_wl15_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank1_reg.err_wl16_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank1_reg.err_wl17_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank1_reg.err_wl18_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank1_reg.err_wl19_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank1_reg.err_wl20_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank1_reg.err_wl21_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank1_reg.err_wl22_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank1_reg.err_wl23_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank1_reg.err_wl24_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank1_reg.err_wl25_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank1_reg.err_wl26_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank1_reg.err_wl27_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank1_reg.err_wl28_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank1_reg.err_wl29_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank1_reg.err_wl30_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank1_reg.err_wl31_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank1_reg.err_wl32_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank1_reg.err_wl33_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank1_reg.err_wl34_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank1_reg.err_wl35_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank1_reg.err_wl36_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank1_reg.err_wl37_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank1_reg.err_wl38_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank1_reg.err_wl39_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank1_reg.err_wl40_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank1_reg.err_wl41_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank1_reg.err_wl42_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank1_reg.err_wl43_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank1_reg.err_wl44_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank1_reg.err_wl45_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank1_reg.err_wl46_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank1_reg.err_wl47_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank1_reg.err_wl48_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank1_reg.err_wl49_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank1_reg.err_wl50_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank1_reg.err_wl51_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank1_reg.err_wl52_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank1_reg.err_wl53_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank1_reg.err_wl54_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank1_reg.err_wl55_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank1_reg.err_wl56_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank1_reg.err_wl57_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank1_reg.err_wl58_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank1_reg.err_wl59_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank1_reg.err_wl60_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank1_reg.err_wl61_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank1_reg.err_wl62_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank1_reg.err_wl63_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);

        //check err csl
        exp_err_csl_check('d0, exp_check_csl_part0_q,read_err_csl_part0_q, csl_fail_point);
        exp_err_csl_check('d1, exp_check_csl_part1_q,read_err_csl_part1_q, csl_fail_point);
        exp_err_csl_check('d2, exp_check_csl_part2_q,read_err_csl_part2_q, csl_fail_point);
        exp_err_csl_check('d3, exp_check_csl_part3_q,read_err_csl_part3_q, csl_fail_point);
        exp_err_csl_check('d4, exp_check_csl_part4_q,read_err_csl_part4_q, csl_fail_point);
        exp_err_csl_check('d5, exp_check_csl_part5_q,read_err_csl_part5_q, csl_fail_point);
        exp_err_csl_check('d6, exp_check_csl_part6_q,read_err_csl_part6_q, csl_fail_point);
        exp_err_csl_check('d7, exp_check_csl_part7_q,read_err_csl_part7_q, csl_fail_point);
        exp_err_csl_check('d8, exp_check_csl_part8_q,read_err_csl_part8_q, csl_fail_point);
        exp_err_csl_check('d9, exp_check_csl_part9_q,read_err_csl_part9_q, csl_fail_point);

        //check err row
        exp_err_wl_check(exp_err_row_q, read_err_row_reg_q);

        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_fail", csl_fail);
        if (!mc_csl_scan_mode_sel) begin
            if ((|exp_csl_fail) != csl_fail)   
                `uvm_error(get_type_name(),$sformatf("csl fail check err, exp %0b, act %0b",(|exp_csl_fail), csl_fail))
        end

        if (!exp_csl_fail || mc_csl_scan_mode_sel) begin
            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_wl_scan_top.inst%0d.bank1_bist_wl_fail",4-`BANK_ADDR_WIDTH),wl_fail);;
            if ((exp_wl_fail) != wl_fail)   `uvm_error(get_type_name(),$sformatf("wl fail check err, exp %0b, act %0b",exp_wl_fail, wl_fail))
        end

        //check bist success
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bank_success_bank1.read(status, bank_success);
        if (bank_success !== (mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail))) begin
            `uvm_error(get_type_name(),$sformatf("bank_success check err, exp %0b, act %0b",mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail), bank_success))
        end
        //}}}
        `elsif TEST_1_SHOT_3
        //{{{
        read_err_csl_part0_q.delete;
        read_err_csl_part1_q.delete;
        read_err_csl_part2_q.delete;
        read_err_csl_part3_q.delete;
        read_err_csl_part4_q.delete;
        read_err_csl_part5_q.delete;
        read_err_csl_part6_q.delete;
        read_err_csl_part7_q.delete;
        read_err_csl_part8_q.delete;
        read_err_csl_part9_q.delete;
        read_err_row_reg_q.delete;

        //read err csl addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl0_part0_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl1_part0_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl0_part1_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl1_part1_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl0_part2_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl1_part2_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl0_part3_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl1_part3_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl0_part4_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl1_part4_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl0_part5_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl1_part5_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl0_part6_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl1_part6_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl0_part7_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl1_part7_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl0_part8_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl1_part8_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl0_part9_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl1_part9_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);

        `uvm_info(get_type_name(),"read bist err wl!",UVM_LOW)
        //read err row addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank1_reg.err_wl0_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank1_reg.err_wl1_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank1_reg.err_wl2_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank1_reg.err_wl3_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank1_reg.err_wl4_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank1_reg.err_wl5_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank1_reg.err_wl6_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank1_reg.err_wl7_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank1_reg.err_wl8_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank1_reg.err_wl9_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank1_reg.err_wl10_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank1_reg.err_wl11_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank1_reg.err_wl12_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank1_reg.err_wl13_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank1_reg.err_wl14_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank1_reg.err_wl15_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank1_reg.err_wl16_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank1_reg.err_wl17_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank1_reg.err_wl18_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank1_reg.err_wl19_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank1_reg.err_wl20_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank1_reg.err_wl21_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank1_reg.err_wl22_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank1_reg.err_wl23_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank1_reg.err_wl24_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank1_reg.err_wl25_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank1_reg.err_wl26_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank1_reg.err_wl27_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank1_reg.err_wl28_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank1_reg.err_wl29_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank1_reg.err_wl30_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank1_reg.err_wl31_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank1_reg.err_wl32_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank1_reg.err_wl33_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank1_reg.err_wl34_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank1_reg.err_wl35_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank1_reg.err_wl36_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank1_reg.err_wl37_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank1_reg.err_wl38_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank1_reg.err_wl39_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank1_reg.err_wl40_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank1_reg.err_wl41_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank1_reg.err_wl42_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank1_reg.err_wl43_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank1_reg.err_wl44_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank1_reg.err_wl45_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank1_reg.err_wl46_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank1_reg.err_wl47_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank1_reg.err_wl48_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank1_reg.err_wl49_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank1_reg.err_wl50_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank1_reg.err_wl51_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank1_reg.err_wl52_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank1_reg.err_wl53_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank1_reg.err_wl54_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank1_reg.err_wl55_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank1_reg.err_wl56_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank1_reg.err_wl57_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank1_reg.err_wl58_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank1_reg.err_wl59_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank1_reg.err_wl60_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank1_reg.err_wl61_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank1_reg.err_wl62_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank1_reg.err_wl63_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);

        //check err csl
        exp_err_csl_check('d0, exp_check_csl_part0_q,read_err_csl_part0_q, csl_fail_point);
        exp_err_csl_check('d1, exp_check_csl_part1_q,read_err_csl_part1_q, csl_fail_point);
        exp_err_csl_check('d2, exp_check_csl_part2_q,read_err_csl_part2_q, csl_fail_point);
        exp_err_csl_check('d3, exp_check_csl_part3_q,read_err_csl_part3_q, csl_fail_point);
        exp_err_csl_check('d4, exp_check_csl_part4_q,read_err_csl_part4_q, csl_fail_point);
        exp_err_csl_check('d5, exp_check_csl_part5_q,read_err_csl_part5_q, csl_fail_point);
        exp_err_csl_check('d6, exp_check_csl_part6_q,read_err_csl_part6_q, csl_fail_point);
        exp_err_csl_check('d7, exp_check_csl_part7_q,read_err_csl_part7_q, csl_fail_point);
        exp_err_csl_check('d8, exp_check_csl_part8_q,read_err_csl_part8_q, csl_fail_point);
        exp_err_csl_check('d9, exp_check_csl_part9_q,read_err_csl_part9_q, csl_fail_point);

        //check err row
        exp_err_wl_check(exp_err_row_q, read_err_row_reg_q);

        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_fail", csl_fail);
        if (!mc_csl_scan_mode_sel) begin
            if ((|exp_csl_fail) != csl_fail)   
                `uvm_error(get_type_name(),$sformatf("csl fail check err, exp %0b, act %0b",(|exp_csl_fail), csl_fail))
        end

        //check bist success
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bank_success_bank1.read(status, bank_success);
        if (bank_success !== (mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail))) begin
            `uvm_error(get_type_name(),$sformatf("bank_success check err, exp %0b, act %0b",mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail), bank_success))
        end
        //}}}
        //{{{
        read_err_csl_part0_q.delete;
        read_err_csl_part1_q.delete;
        read_err_csl_part2_q.delete;
        read_err_csl_part3_q.delete;
        read_err_csl_part4_q.delete;
        read_err_csl_part5_q.delete;
        read_err_csl_part6_q.delete;
        read_err_csl_part7_q.delete;
        read_err_csl_part8_q.delete;
        read_err_csl_part9_q.delete;
        read_err_row_reg_q.delete;

        //read err csl addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank2_reg.err_csl0_part0_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank2_reg.err_csl1_part0_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank2_reg.err_csl0_part1_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank2_reg.err_csl1_part1_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank2_reg.err_csl0_part2_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank2_reg.err_csl1_part2_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank2_reg.err_csl0_part3_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank2_reg.err_csl1_part3_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank2_reg.err_csl0_part4_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank2_reg.err_csl1_part4_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank2_reg.err_csl0_part5_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank2_reg.err_csl1_part5_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank2_reg.err_csl0_part6_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank2_reg.err_csl1_part6_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank2_reg.err_csl0_part7_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank2_reg.err_csl1_part7_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank2_reg.err_csl0_part8_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank2_reg.err_csl1_part8_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank2_reg.err_csl0_part9_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank2_reg.err_csl1_part9_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);

        `uvm_info(get_type_name(),"read bist err wl!",UVM_LOW)
        //read err row addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank2_reg.err_wl0_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank2_reg.err_wl1_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank2_reg.err_wl2_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank2_reg.err_wl3_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank2_reg.err_wl4_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank2_reg.err_wl5_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank2_reg.err_wl6_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank2_reg.err_wl7_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank2_reg.err_wl8_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank2_reg.err_wl9_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank2_reg.err_wl10_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank2_reg.err_wl11_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank2_reg.err_wl12_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank2_reg.err_wl13_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank2_reg.err_wl14_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank2_reg.err_wl15_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank2_reg.err_wl16_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank2_reg.err_wl17_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank2_reg.err_wl18_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank2_reg.err_wl19_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank2_reg.err_wl20_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank2_reg.err_wl21_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank2_reg.err_wl22_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank2_reg.err_wl23_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank2_reg.err_wl24_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank2_reg.err_wl25_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank2_reg.err_wl26_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank2_reg.err_wl27_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank2_reg.err_wl28_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank2_reg.err_wl29_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank2_reg.err_wl30_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank2_reg.err_wl31_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank2_reg.err_wl32_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank2_reg.err_wl33_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank2_reg.err_wl34_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank2_reg.err_wl35_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank2_reg.err_wl36_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank2_reg.err_wl37_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank2_reg.err_wl38_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank2_reg.err_wl39_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank2_reg.err_wl40_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank2_reg.err_wl41_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank2_reg.err_wl42_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank2_reg.err_wl43_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank2_reg.err_wl44_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank2_reg.err_wl45_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank2_reg.err_wl46_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank2_reg.err_wl47_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank2_reg.err_wl48_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank2_reg.err_wl49_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank2_reg.err_wl50_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank2_reg.err_wl51_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank2_reg.err_wl52_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank2_reg.err_wl53_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank2_reg.err_wl54_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank2_reg.err_wl55_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank2_reg.err_wl56_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank2_reg.err_wl57_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank2_reg.err_wl58_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank2_reg.err_wl59_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank2_reg.err_wl60_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank2_reg.err_wl61_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank2_reg.err_wl62_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank2_reg.err_wl63_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);

        //check err csl
        exp_err_csl_check('d0, exp_check_csl_part0_q,read_err_csl_part0_q, csl_fail_point);
        exp_err_csl_check('d1, exp_check_csl_part1_q,read_err_csl_part1_q, csl_fail_point);
        exp_err_csl_check('d2, exp_check_csl_part2_q,read_err_csl_part2_q, csl_fail_point);
        exp_err_csl_check('d3, exp_check_csl_part3_q,read_err_csl_part3_q, csl_fail_point);
        exp_err_csl_check('d4, exp_check_csl_part4_q,read_err_csl_part4_q, csl_fail_point);
        exp_err_csl_check('d5, exp_check_csl_part5_q,read_err_csl_part5_q, csl_fail_point);
        exp_err_csl_check('d6, exp_check_csl_part6_q,read_err_csl_part6_q, csl_fail_point);
        exp_err_csl_check('d7, exp_check_csl_part7_q,read_err_csl_part7_q, csl_fail_point);
        exp_err_csl_check('d8, exp_check_csl_part8_q,read_err_csl_part8_q, csl_fail_point);
        exp_err_csl_check('d9, exp_check_csl_part9_q,read_err_csl_part9_q, csl_fail_point);

        //check err row
        exp_err_wl_check(exp_err_row_q, read_err_row_reg_q);

        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_fail", csl_fail);
        if (!mc_csl_scan_mode_sel) begin
            if ((|exp_csl_fail) != csl_fail)   
                `uvm_error(get_type_name(),$sformatf("csl fail check err, exp %0b, act %0b",(|exp_csl_fail), csl_fail))
        end

        if (!exp_csl_fail || mc_csl_scan_mode_sel) begin
            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_wl_scan_top.inst%0d.bank2_bist_wl_fail",4-`BANK_ADDR_WIDTH),wl_fail);;
            if ((exp_wl_fail) != wl_fail)   `uvm_error(get_type_name(),$sformatf("wl fail check err, exp %0b, act %0b",exp_wl_fail, wl_fail))
        end

        //check bist success
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bank_success_bank2.read(status, bank_success);
        if (bank_success !== (mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail))) begin
            `uvm_error(get_type_name(),$sformatf("bank_success check err, exp %0b, act %0b",mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail), bank_success))
        end
        //}}}    
        `elsif TEST_1_SHOT_4
        //{{{
        read_err_csl_part0_q.delete;
        read_err_csl_part1_q.delete;
        read_err_csl_part2_q.delete;
        read_err_csl_part3_q.delete;
        read_err_csl_part4_q.delete;
        read_err_csl_part5_q.delete;
        read_err_csl_part6_q.delete;
        read_err_csl_part7_q.delete;
        read_err_csl_part8_q.delete;
        read_err_csl_part9_q.delete;
        read_err_row_reg_q.delete;

        //read err csl addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl0_part0_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl1_part0_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl0_part1_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl1_part1_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl0_part2_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl1_part2_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl0_part3_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl1_part3_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl0_part4_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl1_part4_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl0_part5_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl1_part5_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl0_part6_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl1_part6_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl0_part7_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl1_part7_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl0_part8_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl1_part8_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl0_part9_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl1_part9_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);

        `uvm_info(get_type_name(),"read bist err wl!",UVM_LOW)
        //read err row addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank1_reg.err_wl0_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank1_reg.err_wl1_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank1_reg.err_wl2_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank1_reg.err_wl3_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank1_reg.err_wl4_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank1_reg.err_wl5_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank1_reg.err_wl6_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank1_reg.err_wl7_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank1_reg.err_wl8_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank1_reg.err_wl9_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank1_reg.err_wl10_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank1_reg.err_wl11_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank1_reg.err_wl12_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank1_reg.err_wl13_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank1_reg.err_wl14_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank1_reg.err_wl15_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank1_reg.err_wl16_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank1_reg.err_wl17_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank1_reg.err_wl18_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank1_reg.err_wl19_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank1_reg.err_wl20_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank1_reg.err_wl21_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank1_reg.err_wl22_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank1_reg.err_wl23_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank1_reg.err_wl24_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank1_reg.err_wl25_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank1_reg.err_wl26_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank1_reg.err_wl27_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank1_reg.err_wl28_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank1_reg.err_wl29_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank1_reg.err_wl30_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank1_reg.err_wl31_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank1_reg.err_wl32_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank1_reg.err_wl33_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank1_reg.err_wl34_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank1_reg.err_wl35_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank1_reg.err_wl36_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank1_reg.err_wl37_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank1_reg.err_wl38_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank1_reg.err_wl39_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank1_reg.err_wl40_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank1_reg.err_wl41_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank1_reg.err_wl42_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank1_reg.err_wl43_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank1_reg.err_wl44_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank1_reg.err_wl45_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank1_reg.err_wl46_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank1_reg.err_wl47_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank1_reg.err_wl48_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank1_reg.err_wl49_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank1_reg.err_wl50_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank1_reg.err_wl51_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank1_reg.err_wl52_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank1_reg.err_wl53_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank1_reg.err_wl54_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank1_reg.err_wl55_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank1_reg.err_wl56_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank1_reg.err_wl57_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank1_reg.err_wl58_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank1_reg.err_wl59_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank1_reg.err_wl60_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank1_reg.err_wl61_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank1_reg.err_wl62_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank1_reg.err_wl63_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);

        //check err csl
        exp_err_csl_check('d0, exp_check_csl_part0_q,read_err_csl_part0_q, csl_fail_point);
        exp_err_csl_check('d1, exp_check_csl_part1_q,read_err_csl_part1_q, csl_fail_point);
        exp_err_csl_check('d2, exp_check_csl_part2_q,read_err_csl_part2_q, csl_fail_point);
        exp_err_csl_check('d3, exp_check_csl_part3_q,read_err_csl_part3_q, csl_fail_point);
        exp_err_csl_check('d4, exp_check_csl_part4_q,read_err_csl_part4_q, csl_fail_point);
        exp_err_csl_check('d5, exp_check_csl_part5_q,read_err_csl_part5_q, csl_fail_point);
        exp_err_csl_check('d6, exp_check_csl_part6_q,read_err_csl_part6_q, csl_fail_point);
        exp_err_csl_check('d7, exp_check_csl_part7_q,read_err_csl_part7_q, csl_fail_point);
        exp_err_csl_check('d8, exp_check_csl_part8_q,read_err_csl_part8_q, csl_fail_point);
        exp_err_csl_check('d9, exp_check_csl_part9_q,read_err_csl_part9_q, csl_fail_point);

        //check err row
        exp_err_wl_check(exp_err_row_q, read_err_row_reg_q);

        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_fail", csl_fail);
        if (!mc_csl_scan_mode_sel) begin
            if ((|exp_csl_fail) != csl_fail)   
                `uvm_error(get_type_name(),$sformatf("csl fail check err, exp %0b, act %0b",(|exp_csl_fail), csl_fail))
        end

        //check bist success
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bank_success_bank1.read(status, bank_success);
        if (bank_success !== (mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail))) begin
            `uvm_error(get_type_name(),$sformatf("bank_success check err, exp %0b, act %0b",mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail), bank_success))
        end
        //}}}
        //{{{
        read_err_csl_part0_q.delete;
        read_err_csl_part1_q.delete;
        read_err_csl_part2_q.delete;
        read_err_csl_part3_q.delete;
        read_err_csl_part4_q.delete;
        read_err_csl_part5_q.delete;
        read_err_csl_part6_q.delete;
        read_err_csl_part7_q.delete;
        read_err_csl_part8_q.delete;
        read_err_csl_part9_q.delete;
        read_err_row_reg_q.delete;

        //read err csl addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank2_reg.err_csl0_part0_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank2_reg.err_csl1_part0_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank2_reg.err_csl0_part1_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank2_reg.err_csl1_part1_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank2_reg.err_csl0_part2_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank2_reg.err_csl1_part2_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank2_reg.err_csl0_part3_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank2_reg.err_csl1_part3_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank2_reg.err_csl0_part4_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank2_reg.err_csl1_part4_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank2_reg.err_csl0_part5_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank2_reg.err_csl1_part5_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank2_reg.err_csl0_part6_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank2_reg.err_csl1_part6_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank2_reg.err_csl0_part7_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank2_reg.err_csl1_part7_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank2_reg.err_csl0_part8_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank2_reg.err_csl1_part8_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank2_reg.err_csl0_part9_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank2_reg.err_csl1_part9_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);

        `uvm_info(get_type_name(),"read bist err wl!",UVM_LOW)
        //read err row addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank2_reg.err_wl0_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank2_reg.err_wl1_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank2_reg.err_wl2_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank2_reg.err_wl3_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank2_reg.err_wl4_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank2_reg.err_wl5_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank2_reg.err_wl6_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank2_reg.err_wl7_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank2_reg.err_wl8_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank2_reg.err_wl9_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank2_reg.err_wl10_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank2_reg.err_wl11_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank2_reg.err_wl12_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank2_reg.err_wl13_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank2_reg.err_wl14_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank2_reg.err_wl15_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank2_reg.err_wl16_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank2_reg.err_wl17_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank2_reg.err_wl18_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank2_reg.err_wl19_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank2_reg.err_wl20_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank2_reg.err_wl21_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank2_reg.err_wl22_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank2_reg.err_wl23_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank2_reg.err_wl24_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank2_reg.err_wl25_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank2_reg.err_wl26_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank2_reg.err_wl27_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank2_reg.err_wl28_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank2_reg.err_wl29_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank2_reg.err_wl30_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank2_reg.err_wl31_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank2_reg.err_wl32_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank2_reg.err_wl33_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank2_reg.err_wl34_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank2_reg.err_wl35_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank2_reg.err_wl36_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank2_reg.err_wl37_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank2_reg.err_wl38_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank2_reg.err_wl39_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank2_reg.err_wl40_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank2_reg.err_wl41_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank2_reg.err_wl42_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank2_reg.err_wl43_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank2_reg.err_wl44_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank2_reg.err_wl45_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank2_reg.err_wl46_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank2_reg.err_wl47_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank2_reg.err_wl48_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank2_reg.err_wl49_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank2_reg.err_wl50_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank2_reg.err_wl51_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank2_reg.err_wl52_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank2_reg.err_wl53_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank2_reg.err_wl54_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank2_reg.err_wl55_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank2_reg.err_wl56_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank2_reg.err_wl57_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank2_reg.err_wl58_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank2_reg.err_wl59_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank2_reg.err_wl60_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank2_reg.err_wl61_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank2_reg.err_wl62_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank2_reg.err_wl63_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);

        //check err csl
        exp_err_csl_check('d0, exp_check_csl_part0_q,read_err_csl_part0_q, csl_fail_point);
        exp_err_csl_check('d1, exp_check_csl_part1_q,read_err_csl_part1_q, csl_fail_point);
        exp_err_csl_check('d2, exp_check_csl_part2_q,read_err_csl_part2_q, csl_fail_point);
        exp_err_csl_check('d3, exp_check_csl_part3_q,read_err_csl_part3_q, csl_fail_point);
        exp_err_csl_check('d4, exp_check_csl_part4_q,read_err_csl_part4_q, csl_fail_point);
        exp_err_csl_check('d5, exp_check_csl_part5_q,read_err_csl_part5_q, csl_fail_point);
        exp_err_csl_check('d6, exp_check_csl_part6_q,read_err_csl_part6_q, csl_fail_point);
        exp_err_csl_check('d7, exp_check_csl_part7_q,read_err_csl_part7_q, csl_fail_point);
        exp_err_csl_check('d8, exp_check_csl_part8_q,read_err_csl_part8_q, csl_fail_point);
        exp_err_csl_check('d9, exp_check_csl_part9_q,read_err_csl_part9_q, csl_fail_point);

        //check err row
        exp_err_wl_check(exp_err_row_q, read_err_row_reg_q);

        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_fail", csl_fail);
        if (!mc_csl_scan_mode_sel) begin
            if ((|exp_csl_fail) != csl_fail)   
                `uvm_error(get_type_name(),$sformatf("csl fail check err, exp %0b, act %0b",(|exp_csl_fail), csl_fail))
        end

        //check bist success
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bank_success_bank2.read(status, bank_success);
        if (bank_success !== (mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail))) begin
            `uvm_error(get_type_name(),$sformatf("bank_success check err, exp %0b, act %0b",mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail), bank_success))
        end
        //}}}    
        //{{{
        read_err_csl_part0_q.delete;
        read_err_csl_part1_q.delete;
        read_err_csl_part2_q.delete;
        read_err_csl_part3_q.delete;
        read_err_csl_part4_q.delete;
        read_err_csl_part5_q.delete;
        read_err_csl_part6_q.delete;
        read_err_csl_part7_q.delete;
        read_err_csl_part8_q.delete;
        read_err_csl_part9_q.delete;
        read_err_row_reg_q.delete;

        //read err csl addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank3_reg.err_csl0_part0_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank3_reg.err_csl1_part0_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank3_reg.err_csl0_part1_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank3_reg.err_csl1_part1_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank3_reg.err_csl0_part2_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank3_reg.err_csl1_part2_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank3_reg.err_csl0_part3_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank3_reg.err_csl1_part3_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank3_reg.err_csl0_part4_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank3_reg.err_csl1_part4_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank3_reg.err_csl0_part5_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank3_reg.err_csl1_part5_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank3_reg.err_csl0_part6_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank3_reg.err_csl1_part6_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank3_reg.err_csl0_part7_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank3_reg.err_csl1_part7_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank3_reg.err_csl0_part8_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank3_reg.err_csl1_part8_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank3_reg.err_csl0_part9_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank3_reg.err_csl1_part9_bank3.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);

        `uvm_info(get_type_name(),"read bist err wl!",UVM_LOW)
        //read err row addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank3_reg.err_wl0_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank3_reg.err_wl1_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank3_reg.err_wl2_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank3_reg.err_wl3_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank3_reg.err_wl4_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank3_reg.err_wl5_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank3_reg.err_wl6_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank3_reg.err_wl7_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank3_reg.err_wl8_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank3_reg.err_wl9_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank3_reg.err_wl10_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank3_reg.err_wl11_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank3_reg.err_wl12_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank3_reg.err_wl13_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank3_reg.err_wl14_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank3_reg.err_wl15_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank3_reg.err_wl16_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank3_reg.err_wl17_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank3_reg.err_wl18_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank3_reg.err_wl19_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank3_reg.err_wl20_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank3_reg.err_wl21_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank3_reg.err_wl22_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank3_reg.err_wl23_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank3_reg.err_wl24_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank3_reg.err_wl25_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank3_reg.err_wl26_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank3_reg.err_wl27_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank3_reg.err_wl28_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank3_reg.err_wl29_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank3_reg.err_wl30_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank3_reg.err_wl31_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank3_reg.err_wl32_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank3_reg.err_wl33_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank3_reg.err_wl34_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank3_reg.err_wl35_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank3_reg.err_wl36_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank3_reg.err_wl37_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank3_reg.err_wl38_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank3_reg.err_wl39_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank3_reg.err_wl40_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank3_reg.err_wl41_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank3_reg.err_wl42_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank3_reg.err_wl43_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank3_reg.err_wl44_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank3_reg.err_wl45_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank3_reg.err_wl46_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank3_reg.err_wl47_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank3_reg.err_wl48_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank3_reg.err_wl49_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank3_reg.err_wl50_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank3_reg.err_wl51_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank3_reg.err_wl52_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank3_reg.err_wl53_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank3_reg.err_wl54_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank3_reg.err_wl55_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank3_reg.err_wl56_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank3_reg.err_wl57_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank3_reg.err_wl58_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank3_reg.err_wl59_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank3_reg.err_wl60_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank3_reg.err_wl61_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank3_reg.err_wl62_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank3_reg.err_wl63_bank3.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);

        //check err csl
        exp_err_csl_check('d0, exp_check_csl_part0_q,read_err_csl_part0_q, csl_fail_point);
        exp_err_csl_check('d1, exp_check_csl_part1_q,read_err_csl_part1_q, csl_fail_point);
        exp_err_csl_check('d2, exp_check_csl_part2_q,read_err_csl_part2_q, csl_fail_point);
        exp_err_csl_check('d3, exp_check_csl_part3_q,read_err_csl_part3_q, csl_fail_point);
        exp_err_csl_check('d4, exp_check_csl_part4_q,read_err_csl_part4_q, csl_fail_point);
        exp_err_csl_check('d5, exp_check_csl_part5_q,read_err_csl_part5_q, csl_fail_point);
        exp_err_csl_check('d6, exp_check_csl_part6_q,read_err_csl_part6_q, csl_fail_point);
        exp_err_csl_check('d7, exp_check_csl_part7_q,read_err_csl_part7_q, csl_fail_point);
        exp_err_csl_check('d8, exp_check_csl_part8_q,read_err_csl_part8_q, csl_fail_point);
        exp_err_csl_check('d9, exp_check_csl_part9_q,read_err_csl_part9_q, csl_fail_point);


        //check err row
        exp_err_wl_check(exp_err_row_q, read_err_row_reg_q);

        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_fail", csl_fail);
        if (!mc_csl_scan_mode_sel) begin
            if ((|exp_csl_fail) != csl_fail)   
                `uvm_error(get_type_name(),$sformatf("csl fail check err, exp %0b, act %0b",(|exp_csl_fail), csl_fail))
        end

        if (!exp_csl_fail || mc_csl_scan_mode_sel) begin
            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_wl_scan_top.inst%0d.bank3_bist_wl_fail",4-`BANK_ADDR_WIDTH),wl_fail);;
            if ((exp_wl_fail) != wl_fail)   `uvm_error(get_type_name(),$sformatf("wl fail check err, exp %0b, act %0b",exp_wl_fail, wl_fail))
        end

        //check bist success
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bank_success_bank3.read(status, bank_success);
        if (bank_success !== (mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail))) begin
            `uvm_error(get_type_name(),$sformatf("bank_success check err, exp %0b, act %0b",mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail), bank_success))
        end
        //}}} 
        `else
        //{{{
        read_err_csl_part0_q.delete;
        read_err_csl_part1_q.delete;
        read_err_csl_part2_q.delete;
        read_err_csl_part3_q.delete;
        read_err_csl_part4_q.delete;
        read_err_csl_part5_q.delete;
        read_err_csl_part6_q.delete;
        read_err_csl_part7_q.delete;
        read_err_csl_part8_q.delete;
        read_err_csl_part9_q.delete;
        read_err_row_reg_q.delete;

        //read err csl addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl0_part0_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl1_part0_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl0_part1_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank1_reg.err_csl1_part1_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl0_part2_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl1_part2_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl0_part3_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank1_reg.err_csl1_part3_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl0_part4_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl1_part4_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl0_part5_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank1_reg.err_csl1_part5_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl0_part6_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl1_part6_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl0_part7_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank1_reg.err_csl1_part7_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl0_part8_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl1_part8_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl0_part9_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank1_reg.err_csl1_part9_bank1.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);

        `uvm_info(get_type_name(),"read bist err wl!",UVM_LOW)
        //read err row addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank1_reg.err_wl0_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank1_reg.err_wl1_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank1_reg.err_wl2_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank1_reg.err_wl3_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank1_reg.err_wl4_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank1_reg.err_wl5_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank1_reg.err_wl6_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank1_reg.err_wl7_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank1_reg.err_wl8_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank1_reg.err_wl9_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank1_reg.err_wl10_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank1_reg.err_wl11_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank1_reg.err_wl12_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank1_reg.err_wl13_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank1_reg.err_wl14_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank1_reg.err_wl15_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank1_reg.err_wl16_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank1_reg.err_wl17_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank1_reg.err_wl18_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank1_reg.err_wl19_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank1_reg.err_wl20_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank1_reg.err_wl21_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank1_reg.err_wl22_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank1_reg.err_wl23_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank1_reg.err_wl24_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank1_reg.err_wl25_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank1_reg.err_wl26_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank1_reg.err_wl27_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank1_reg.err_wl28_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank1_reg.err_wl29_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank1_reg.err_wl30_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank1_reg.err_wl31_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank1_reg.err_wl32_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank1_reg.err_wl33_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank1_reg.err_wl34_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank1_reg.err_wl35_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank1_reg.err_wl36_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank1_reg.err_wl37_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank1_reg.err_wl38_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank1_reg.err_wl39_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank1_reg.err_wl40_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank1_reg.err_wl41_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank1_reg.err_wl42_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank1_reg.err_wl43_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank1_reg.err_wl44_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank1_reg.err_wl45_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank1_reg.err_wl46_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank1_reg.err_wl47_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank1_reg.err_wl48_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank1_reg.err_wl49_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank1_reg.err_wl50_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank1_reg.err_wl51_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank1_reg.err_wl52_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank1_reg.err_wl53_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank1_reg.err_wl54_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank1_reg.err_wl55_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank1_reg.err_wl56_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank1_reg.err_wl57_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank1_reg.err_wl58_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank1_reg.err_wl59_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank1_reg.err_wl60_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank1_reg.err_wl61_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank1_reg.err_wl62_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank1_reg.err_wl63_bank1.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);

        //check err csl
        exp_err_csl_check('d0, exp_check_csl_part0_q,read_err_csl_part0_q, csl_fail_point);
        exp_err_csl_check('d1, exp_check_csl_part1_q,read_err_csl_part1_q, csl_fail_point);
        exp_err_csl_check('d2, exp_check_csl_part2_q,read_err_csl_part2_q, csl_fail_point);
        exp_err_csl_check('d3, exp_check_csl_part3_q,read_err_csl_part3_q, csl_fail_point);
        exp_err_csl_check('d4, exp_check_csl_part4_q,read_err_csl_part4_q, csl_fail_point);
        exp_err_csl_check('d5, exp_check_csl_part5_q,read_err_csl_part5_q, csl_fail_point);
        exp_err_csl_check('d6, exp_check_csl_part6_q,read_err_csl_part6_q, csl_fail_point);
        exp_err_csl_check('d7, exp_check_csl_part7_q,read_err_csl_part7_q, csl_fail_point);
        exp_err_csl_check('d8, exp_check_csl_part8_q,read_err_csl_part8_q, csl_fail_point);
        exp_err_csl_check('d9, exp_check_csl_part9_q,read_err_csl_part9_q, csl_fail_point);

        //check err row
        exp_err_wl_check(exp_err_row_q, read_err_row_reg_q);

        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_fail", csl_fail);
        if (!mc_csl_scan_mode_sel) begin
            if ((|exp_csl_fail) != csl_fail)   
                `uvm_error(get_type_name(),$sformatf("csl fail check err, exp %0b, act %0b",(|exp_csl_fail), csl_fail))
        end

        //check bist success
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bank_success_bank1.read(status, bank_success);
        if (bank_success !== (mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail))) begin
            `uvm_error(get_type_name(),$sformatf("bank_success check err, exp %0b, act %0b",mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail), bank_success))
        end
        //}}}
        //{{{
        read_err_csl_part0_q.delete;
        read_err_csl_part1_q.delete;
        read_err_csl_part2_q.delete;
        read_err_csl_part3_q.delete;
        read_err_csl_part4_q.delete;
        read_err_csl_part5_q.delete;
        read_err_csl_part6_q.delete;
        read_err_csl_part7_q.delete;
        read_err_csl_part8_q.delete;
        read_err_csl_part9_q.delete;
        read_err_row_reg_q.delete;

        //read err csl addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank2_reg.err_csl0_part0_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank2_reg.err_csl1_part0_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part0_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank2_reg.err_csl0_part1_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part0_1_bank2_reg.err_csl1_part1_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part1_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank2_reg.err_csl0_part2_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank2_reg.err_csl1_part2_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part2_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank2_reg.err_csl0_part3_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part2_3_bank2_reg.err_csl1_part3_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part3_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank2_reg.err_csl0_part4_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank2_reg.err_csl1_part4_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part4_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank2_reg.err_csl0_part5_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part4_5_bank2_reg.err_csl1_part5_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part5_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank2_reg.err_csl0_part6_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank2_reg.err_csl1_part6_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part6_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank2_reg.err_csl0_part7_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part6_7_bank2_reg.err_csl1_part7_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part7_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank2_reg.err_csl0_part8_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank2_reg.err_csl1_part8_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part8_q.push_back(read_err_csl_reg);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank2_reg.err_csl0_part9_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl_part8_9_bank2_reg.err_csl1_part9_bank2.read(status, read_err_csl_reg, UVM_FRONTDOOR);
        read_err_csl_part9_q.push_back(read_err_csl_reg);

        `uvm_info(get_type_name(),"read bist err wl!",UVM_LOW)
        //read err row addr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank2_reg.err_wl0_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl0_1_bank2_reg.err_wl1_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank2_reg.err_wl2_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl2_3_bank2_reg.err_wl3_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank2_reg.err_wl4_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl4_5_bank2_reg.err_wl5_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank2_reg.err_wl6_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl6_7_bank2_reg.err_wl7_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank2_reg.err_wl8_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl8_9_bank2_reg.err_wl9_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank2_reg.err_wl10_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl10_11_bank2_reg.err_wl11_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank2_reg.err_wl12_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl12_13_bank2_reg.err_wl13_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank2_reg.err_wl14_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl14_15_bank2_reg.err_wl15_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank2_reg.err_wl16_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl16_17_bank2_reg.err_wl17_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank2_reg.err_wl18_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl18_19_bank2_reg.err_wl19_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank2_reg.err_wl20_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl20_21_bank2_reg.err_wl21_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank2_reg.err_wl22_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl22_23_bank2_reg.err_wl23_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank2_reg.err_wl24_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl24_25_bank2_reg.err_wl25_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank2_reg.err_wl26_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl26_27_bank2_reg.err_wl27_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank2_reg.err_wl28_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl28_29_bank2_reg.err_wl29_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank2_reg.err_wl30_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl30_31_bank2_reg.err_wl31_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank2_reg.err_wl32_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl32_33_bank2_reg.err_wl33_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank2_reg.err_wl34_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl34_35_bank2_reg.err_wl35_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank2_reg.err_wl36_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl36_37_bank2_reg.err_wl37_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank2_reg.err_wl38_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl38_39_bank2_reg.err_wl39_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank2_reg.err_wl40_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl40_41_bank2_reg.err_wl41_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank2_reg.err_wl42_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl42_43_bank2_reg.err_wl43_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank2_reg.err_wl44_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl44_45_bank2_reg.err_wl45_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank2_reg.err_wl46_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl46_47_bank2_reg.err_wl47_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank2_reg.err_wl48_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl48_49_bank2_reg.err_wl49_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank2_reg.err_wl50_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl50_51_bank2_reg.err_wl51_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank2_reg.err_wl52_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl52_53_bank2_reg.err_wl53_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank2_reg.err_wl54_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl54_55_bank2_reg.err_wl55_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank2_reg.err_wl56_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl56_57_bank2_reg.err_wl57_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank2_reg.err_wl58_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl58_59_bank2_reg.err_wl59_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank2_reg.err_wl60_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl60_61_bank2_reg.err_wl61_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank2_reg.err_wl62_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_wl62_63_bank2_reg.err_wl63_bank2.read(status, read_err_row_reg, UVM_FRONTDOOR);
        read_err_row_reg_q.push_back(read_err_row_reg);

        //check err csl
        exp_err_csl_check('d0, exp_check_csl_part0_q,read_err_csl_part0_q, csl_fail_point);
        exp_err_csl_check('d1, exp_check_csl_part1_q,read_err_csl_part1_q, csl_fail_point);
        exp_err_csl_check('d2, exp_check_csl_part2_q,read_err_csl_part2_q, csl_fail_point);
        exp_err_csl_check('d3, exp_check_csl_part3_q,read_err_csl_part3_q, csl_fail_point);
        exp_err_csl_check('d4, exp_check_csl_part4_q,read_err_csl_part4_q, csl_fail_point);
        exp_err_csl_check('d5, exp_check_csl_part5_q,read_err_csl_part5_q, csl_fail_point);
        exp_err_csl_check('d6, exp_check_csl_part6_q,read_err_csl_part6_q, csl_fail_point);
        exp_err_csl_check('d7, exp_check_csl_part7_q,read_err_csl_part7_q, csl_fail_point);
        exp_err_csl_check('d8, exp_check_csl_part8_q,read_err_csl_part8_q, csl_fail_point);
        exp_err_csl_check('d9, exp_check_csl_part9_q,read_err_csl_part9_q, csl_fail_point);

        //check err row
        exp_err_wl_check(exp_err_row_q, read_err_row_reg_q);

        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_csl_scan.csl_scan_fail", csl_fail);
        if (!mc_csl_scan_mode_sel) begin
            if ((|exp_csl_fail) != csl_fail)   
                `uvm_error(get_type_name(),$sformatf("csl fail check err, exp %0b, act %0b",(|exp_csl_fail), csl_fail))
        end

        if (!exp_csl_fail || mc_csl_scan_mode_sel) begin
            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_wl_scan_top.inst%0d.bank2_bist_wl_fail",4-`BANK_ADDR_WIDTH),wl_fail);;
            if ((exp_wl_fail) != wl_fail)   `uvm_error(get_type_name(),$sformatf("wl fail check err, exp %0b, act %0b",exp_wl_fail, wl_fail))
        end

        //check bist success
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bank_success_bank2.read(status, bank_success);
        if (bank_success !== (mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail))) begin
            `uvm_error(get_type_name(),$sformatf("bank_success check err, exp %0b, act %0b",mc_csl_scan_mode_sel? (!exp_wl_fail):(!exp_wl_fail && !exp_csl_fail), bank_success))
        end
        //}}}    
        `endif    
        //clear bist_finish_intr
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_clr_reg.write(status,1'b1,UVM_FRONTDOOR);

        `uvm_info(get_type_name(),"vmc sort!",UVM_LOW)
        //--------------- vmc config -------------------
        read_err_csl_part0_q.sort();
        read_err_csl_part1_q.sort();
        read_err_csl_part2_q.sort();
        read_err_csl_part3_q.sort();
        read_err_csl_part4_q.sort();
        read_err_csl_part5_q.sort();
        read_err_csl_part6_q.sort();
        read_err_csl_part7_q.sort();
        read_err_csl_part8_q.sort();
        read_err_csl_part9_q.sort();
        read_err_row_reg_q.sort();

        `uvm_info(get_type_name(),"vmc compare!",UVM_LOW)

        //----------------- hard_fail_release ------------------
        //if((!mc_csl_scan_mode_sel && exp_csl_fail) || exp_wl_fail) begin
            hard_fail_release(hard_error_record, read_err_csl_part0_q,read_err_csl_part1_q,read_err_csl_part2_q,read_err_csl_part3_q,read_err_csl_part4_q,read_err_csl_part5_q,read_err_csl_part6_q,read_err_csl_part7_q,read_err_csl_part8_q,read_err_csl_part9_q,read_err_row_reg_q);
        //end


        //--------------- remap ------------------------
        `uvm_info(get_type_name(),"vmc remap!",UVM_LOW)

        foreach(read_err_csl_part0_q[i]) begin
            if (read_err_csl_part0_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_part0_q[i]    =   read_err_csl_part0_q[i] - i;
        end
        foreach(read_err_csl_part1_q[i]) begin
            if (read_err_csl_part1_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_part1_q[i]    =   read_err_csl_part1_q[i] - i;
        end
        foreach(read_err_csl_part2_q[i]) begin
            if (read_err_csl_part2_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_part2_q[i]    =   read_err_csl_part2_q[i] - i;
        end
        foreach(read_err_csl_part3_q[i]) begin
            if (read_err_csl_part3_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_part3_q[i]    =   read_err_csl_part3_q[i] - i;
        end
        foreach(read_err_csl_part4_q[i]) begin
            if (read_err_csl_part4_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_part4_q[i]    =   read_err_csl_part4_q[i] - i;
        end
        foreach(read_err_csl_part5_q[i]) begin
            if (read_err_csl_part5_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_part5_q[i]    =   read_err_csl_part5_q[i] - i;
        end
        foreach(read_err_csl_part6_q[i]) begin
            if (read_err_csl_part6_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_part6_q[i]    =   read_err_csl_part6_q[i] - i;
        end
        foreach(read_err_csl_part7_q[i]) begin
            if (read_err_csl_part7_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_part7_q[i]    =   read_err_csl_part7_q[i] - i;
        end
        foreach(read_err_csl_part8_q[i]) begin
            if (read_err_csl_part8_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_part8_q[i]    =   read_err_csl_part8_q[i] - i;
        end
        foreach(read_err_csl_part9_q[i]) begin
            if (read_err_csl_part9_q[i] == ERR_CSL_DEFAULT_VALUE)
                break;
            read_err_csl_part9_q[i]    =   read_err_csl_part9_q[i] - i;
        end

        foreach(read_err_row_reg_q[i]) begin
            if (read_err_row_reg_q[i] == ERR_WL_DEFAULT_VALUE)
                break;
            read_err_row_reg_q[i]    =   read_err_row_reg_q[i] - i;
        end

        `uvm_info(get_type_name(),"vmc write in reg!",UVM_LOW)

        //--------------- write in reg ----------------
            //{{{
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num0_part0_bank0.write(status, read_err_csl_part0_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num1_part0_bank0.write(status, read_err_csl_part0_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num0_part1_bank0.write(status, read_err_csl_part1_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num1_part1_bank0.write(status, read_err_csl_part1_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank0_reg.mc_vmc_bl_num0_part2_bank0.write(status, read_err_csl_part2_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank0_reg.mc_vmc_bl_num1_part2_bank0.write(status, read_err_csl_part2_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank0_reg.mc_vmc_bl_num0_part3_bank0.write(status, read_err_csl_part3_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank0_reg.mc_vmc_bl_num1_part3_bank0.write(status, read_err_csl_part3_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank0_reg.mc_vmc_bl_num0_part4_bank0.write(status, read_err_csl_part4_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank0_reg.mc_vmc_bl_num1_part4_bank0.write(status, read_err_csl_part4_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank0_reg.mc_vmc_bl_num0_part5_bank0.write(status, read_err_csl_part5_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank0_reg.mc_vmc_bl_num1_part5_bank0.write(status, read_err_csl_part5_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank0_reg.mc_vmc_bl_num0_part6_bank0.write(status, read_err_csl_part6_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank0_reg.mc_vmc_bl_num1_part6_bank0.write(status, read_err_csl_part6_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank0_reg.mc_vmc_bl_num0_part7_bank0.write(status, read_err_csl_part7_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank0_reg.mc_vmc_bl_num1_part7_bank0.write(status, read_err_csl_part7_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank0_reg.mc_vmc_bl_num0_part8_bank0.write(status, read_err_csl_part8_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank0_reg.mc_vmc_bl_num1_part8_bank0.write(status, read_err_csl_part8_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank0_reg.mc_vmc_bl_num0_part9_bank0.write(status, read_err_csl_part9_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank0_reg.mc_vmc_bl_num1_part9_bank0.write(status, read_err_csl_part9_q[1], UVM_FRONTDOOR);

        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank0_reg.mc_vmc_wl_num0_bank0.write(status, read_err_row_reg_q[0], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank0_reg.mc_vmc_wl_num1_bank0.write(status, read_err_row_reg_q[1], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank0_reg.mc_vmc_wl_num2_bank0.write(status, read_err_row_reg_q[2], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank0_reg.mc_vmc_wl_num3_bank0.write(status, read_err_row_reg_q[3], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank0_reg.mc_vmc_wl_num4_bank0.write(status, read_err_row_reg_q[4], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank0_reg.mc_vmc_wl_num5_bank0.write(status, read_err_row_reg_q[5], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank0_reg.mc_vmc_wl_num6_bank0.write(status, read_err_row_reg_q[6], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank0_reg.mc_vmc_wl_num7_bank0.write(status, read_err_row_reg_q[7], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank0_reg.mc_vmc_wl_num8_bank0.write(status, read_err_row_reg_q[8], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank0_reg.mc_vmc_wl_num9_bank0.write(status, read_err_row_reg_q[9], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank0_reg.mc_vmc_wl_num10_bank0.write(status, read_err_row_reg_q[10], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank0_reg.mc_vmc_wl_num11_bank0.write(status, read_err_row_reg_q[11], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank0_reg.mc_vmc_wl_num12_bank0.write(status, read_err_row_reg_q[12], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank0_reg.mc_vmc_wl_num13_bank0.write(status, read_err_row_reg_q[13], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank0_reg.mc_vmc_wl_num14_bank0.write(status, read_err_row_reg_q[14], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank0_reg.mc_vmc_wl_num15_bank0.write(status, read_err_row_reg_q[15], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank0_reg.mc_vmc_wl_num16_bank0.write(status, read_err_row_reg_q[16], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank0_reg.mc_vmc_wl_num17_bank0.write(status, read_err_row_reg_q[17], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank0_reg.mc_vmc_wl_num18_bank0.write(status, read_err_row_reg_q[18], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank0_reg.mc_vmc_wl_num19_bank0.write(status, read_err_row_reg_q[19], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank0_reg.mc_vmc_wl_num20_bank0.write(status, read_err_row_reg_q[20], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank0_reg.mc_vmc_wl_num21_bank0.write(status, read_err_row_reg_q[21], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank0_reg.mc_vmc_wl_num22_bank0.write(status, read_err_row_reg_q[22], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank0_reg.mc_vmc_wl_num23_bank0.write(status, read_err_row_reg_q[23], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank0_reg.mc_vmc_wl_num24_bank0.write(status, read_err_row_reg_q[24], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank0_reg.mc_vmc_wl_num25_bank0.write(status, read_err_row_reg_q[25], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank0_reg.mc_vmc_wl_num26_bank0.write(status, read_err_row_reg_q[26], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank0_reg.mc_vmc_wl_num27_bank0.write(status, read_err_row_reg_q[27], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank0_reg.mc_vmc_wl_num28_bank0.write(status, read_err_row_reg_q[28], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank0_reg.mc_vmc_wl_num29_bank0.write(status, read_err_row_reg_q[29], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank0_reg.mc_vmc_wl_num30_bank0.write(status, read_err_row_reg_q[30], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank0_reg.mc_vmc_wl_num31_bank0.write(status, read_err_row_reg_q[31], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank0_reg.mc_vmc_wl_num32_bank0.write(status, read_err_row_reg_q[32], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank0_reg.mc_vmc_wl_num33_bank0.write(status, read_err_row_reg_q[33], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank0_reg.mc_vmc_wl_num34_bank0.write(status, read_err_row_reg_q[34], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank0_reg.mc_vmc_wl_num35_bank0.write(status, read_err_row_reg_q[35], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank0_reg.mc_vmc_wl_num36_bank0.write(status, read_err_row_reg_q[36], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank0_reg.mc_vmc_wl_num37_bank0.write(status, read_err_row_reg_q[37], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank0_reg.mc_vmc_wl_num38_bank0.write(status, read_err_row_reg_q[38], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank0_reg.mc_vmc_wl_num39_bank0.write(status, read_err_row_reg_q[39], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank0_reg.mc_vmc_wl_num40_bank0.write(status, read_err_row_reg_q[40], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank0_reg.mc_vmc_wl_num41_bank0.write(status, read_err_row_reg_q[41], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank0_reg.mc_vmc_wl_num42_bank0.write(status, read_err_row_reg_q[42], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank0_reg.mc_vmc_wl_num43_bank0.write(status, read_err_row_reg_q[43], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank0_reg.mc_vmc_wl_num44_bank0.write(status, read_err_row_reg_q[44], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank0_reg.mc_vmc_wl_num45_bank0.write(status, read_err_row_reg_q[45], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank0_reg.mc_vmc_wl_num46_bank0.write(status, read_err_row_reg_q[46], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank0_reg.mc_vmc_wl_num47_bank0.write(status, read_err_row_reg_q[47], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank0_reg.mc_vmc_wl_num48_bank0.write(status, read_err_row_reg_q[48], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank0_reg.mc_vmc_wl_num49_bank0.write(status, read_err_row_reg_q[49], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank0_reg.mc_vmc_wl_num50_bank0.write(status, read_err_row_reg_q[50], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank0_reg.mc_vmc_wl_num51_bank0.write(status, read_err_row_reg_q[51], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank0_reg.mc_vmc_wl_num52_bank0.write(status, read_err_row_reg_q[52], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank0_reg.mc_vmc_wl_num53_bank0.write(status, read_err_row_reg_q[53], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank0_reg.mc_vmc_wl_num54_bank0.write(status, read_err_row_reg_q[54], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank0_reg.mc_vmc_wl_num55_bank0.write(status, read_err_row_reg_q[55], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank0_reg.mc_vmc_wl_num56_bank0.write(status, read_err_row_reg_q[56], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank0_reg.mc_vmc_wl_num57_bank0.write(status, read_err_row_reg_q[57], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank0_reg.mc_vmc_wl_num58_bank0.write(status, read_err_row_reg_q[58], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank0_reg.mc_vmc_wl_num59_bank0.write(status, read_err_row_reg_q[59], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank0_reg.mc_vmc_wl_num60_bank0.write(status, read_err_row_reg_q[60], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank0_reg.mc_vmc_wl_num61_bank0.write(status, read_err_row_reg_q[61], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank0_reg.mc_vmc_wl_num62_bank0.write(status, read_err_row_reg_q[62], UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank0_reg.mc_vmc_wl_num63_bank0.write(status, read_err_row_reg_q[63], UVM_FRONTDOOR);
    //}}}
        `ifdef TEST_1_SHOT_1
        `elsif TEST_1_SHOT_2
            //{{{
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num0_part0_bank1.write(status, read_err_csl_part0_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num1_part0_bank1.write(status, read_err_csl_part0_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num0_part1_bank1.write(status, read_err_csl_part1_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num1_part1_bank1.write(status, read_err_csl_part1_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num0_part2_bank1.write(status, read_err_csl_part2_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num1_part2_bank1.write(status, read_err_csl_part2_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num0_part3_bank1.write(status, read_err_csl_part3_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num1_part3_bank1.write(status, read_err_csl_part3_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num0_part4_bank1.write(status, read_err_csl_part4_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num1_part4_bank1.write(status, read_err_csl_part4_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num0_part5_bank1.write(status, read_err_csl_part5_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num1_part5_bank1.write(status, read_err_csl_part5_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num0_part6_bank1.write(status, read_err_csl_part6_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num1_part6_bank1.write(status, read_err_csl_part6_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num0_part7_bank1.write(status, read_err_csl_part7_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num1_part7_bank1.write(status, read_err_csl_part7_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num0_part8_bank1.write(status, read_err_csl_part8_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num1_part8_bank1.write(status, read_err_csl_part8_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num0_part9_bank1.write(status, read_err_csl_part9_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num1_part9_bank1.write(status, read_err_csl_part9_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank1_reg.mc_vmc_wl_num0_bank1.write(status, read_err_row_reg_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank1_reg.mc_vmc_wl_num1_bank1.write(status, read_err_row_reg_q[1], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank1_reg.mc_vmc_wl_num2_bank1.write(status, read_err_row_reg_q[2], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank1_reg.mc_vmc_wl_num3_bank1.write(status, read_err_row_reg_q[3], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank1_reg.mc_vmc_wl_num4_bank1.write(status, read_err_row_reg_q[4], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank1_reg.mc_vmc_wl_num5_bank1.write(status, read_err_row_reg_q[5], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank1_reg.mc_vmc_wl_num6_bank1.write(status, read_err_row_reg_q[6], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank1_reg.mc_vmc_wl_num7_bank1.write(status, read_err_row_reg_q[7], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank1_reg.mc_vmc_wl_num8_bank1.write(status, read_err_row_reg_q[8], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank1_reg.mc_vmc_wl_num9_bank1.write(status, read_err_row_reg_q[9], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank1_reg.mc_vmc_wl_num10_bank1.write(status, read_err_row_reg_q[10], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank1_reg.mc_vmc_wl_num11_bank1.write(status, read_err_row_reg_q[11], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank1_reg.mc_vmc_wl_num12_bank1.write(status, read_err_row_reg_q[12], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank1_reg.mc_vmc_wl_num13_bank1.write(status, read_err_row_reg_q[13], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank1_reg.mc_vmc_wl_num14_bank1.write(status, read_err_row_reg_q[14], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank1_reg.mc_vmc_wl_num15_bank1.write(status, read_err_row_reg_q[15], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank1_reg.mc_vmc_wl_num16_bank1.write(status, read_err_row_reg_q[16], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank1_reg.mc_vmc_wl_num17_bank1.write(status, read_err_row_reg_q[17], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank1_reg.mc_vmc_wl_num18_bank1.write(status, read_err_row_reg_q[18], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank1_reg.mc_vmc_wl_num19_bank1.write(status, read_err_row_reg_q[19], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank1_reg.mc_vmc_wl_num20_bank1.write(status, read_err_row_reg_q[20], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank1_reg.mc_vmc_wl_num21_bank1.write(status, read_err_row_reg_q[21], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank1_reg.mc_vmc_wl_num22_bank1.write(status, read_err_row_reg_q[22], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank1_reg.mc_vmc_wl_num23_bank1.write(status, read_err_row_reg_q[23], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank1_reg.mc_vmc_wl_num24_bank1.write(status, read_err_row_reg_q[24], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank1_reg.mc_vmc_wl_num25_bank1.write(status, read_err_row_reg_q[25], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank1_reg.mc_vmc_wl_num26_bank1.write(status, read_err_row_reg_q[26], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank1_reg.mc_vmc_wl_num27_bank1.write(status, read_err_row_reg_q[27], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank1_reg.mc_vmc_wl_num28_bank1.write(status, read_err_row_reg_q[28], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank1_reg.mc_vmc_wl_num29_bank1.write(status, read_err_row_reg_q[29], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank1_reg.mc_vmc_wl_num30_bank1.write(status, read_err_row_reg_q[30], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank1_reg.mc_vmc_wl_num31_bank1.write(status, read_err_row_reg_q[31], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank1_reg.mc_vmc_wl_num32_bank1.write(status, read_err_row_reg_q[32], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank1_reg.mc_vmc_wl_num33_bank1.write(status, read_err_row_reg_q[33], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank1_reg.mc_vmc_wl_num34_bank1.write(status, read_err_row_reg_q[34], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank1_reg.mc_vmc_wl_num35_bank1.write(status, read_err_row_reg_q[35], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank1_reg.mc_vmc_wl_num36_bank1.write(status, read_err_row_reg_q[36], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank1_reg.mc_vmc_wl_num37_bank1.write(status, read_err_row_reg_q[37], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank1_reg.mc_vmc_wl_num38_bank1.write(status, read_err_row_reg_q[38], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank1_reg.mc_vmc_wl_num39_bank1.write(status, read_err_row_reg_q[39], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank1_reg.mc_vmc_wl_num40_bank1.write(status, read_err_row_reg_q[40], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank1_reg.mc_vmc_wl_num41_bank1.write(status, read_err_row_reg_q[41], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank1_reg.mc_vmc_wl_num42_bank1.write(status, read_err_row_reg_q[42], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank1_reg.mc_vmc_wl_num43_bank1.write(status, read_err_row_reg_q[43], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank1_reg.mc_vmc_wl_num44_bank1.write(status, read_err_row_reg_q[44], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank1_reg.mc_vmc_wl_num45_bank1.write(status, read_err_row_reg_q[45], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank1_reg.mc_vmc_wl_num46_bank1.write(status, read_err_row_reg_q[46], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank1_reg.mc_vmc_wl_num47_bank1.write(status, read_err_row_reg_q[47], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank1_reg.mc_vmc_wl_num48_bank1.write(status, read_err_row_reg_q[48], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank1_reg.mc_vmc_wl_num49_bank1.write(status, read_err_row_reg_q[49], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank1_reg.mc_vmc_wl_num50_bank1.write(status, read_err_row_reg_q[50], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank1_reg.mc_vmc_wl_num51_bank1.write(status, read_err_row_reg_q[51], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank1_reg.mc_vmc_wl_num52_bank1.write(status, read_err_row_reg_q[52], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank1_reg.mc_vmc_wl_num53_bank1.write(status, read_err_row_reg_q[53], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank1_reg.mc_vmc_wl_num54_bank1.write(status, read_err_row_reg_q[54], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank1_reg.mc_vmc_wl_num55_bank1.write(status, read_err_row_reg_q[55], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank1_reg.mc_vmc_wl_num56_bank1.write(status, read_err_row_reg_q[56], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank1_reg.mc_vmc_wl_num57_bank1.write(status, read_err_row_reg_q[57], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank1_reg.mc_vmc_wl_num58_bank1.write(status, read_err_row_reg_q[58], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank1_reg.mc_vmc_wl_num59_bank1.write(status, read_err_row_reg_q[59], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank1_reg.mc_vmc_wl_num60_bank1.write(status, read_err_row_reg_q[60], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank1_reg.mc_vmc_wl_num61_bank1.write(status, read_err_row_reg_q[61], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank1_reg.mc_vmc_wl_num62_bank1.write(status, read_err_row_reg_q[62], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank1_reg.mc_vmc_wl_num63_bank1.write(status, read_err_row_reg_q[63], UVM_FRONTDOOR);
        //}}}
        `elsif TEST_1_SHOT_3
                //{{{
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num0_part0_bank1.write(status, read_err_csl_part0_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num1_part0_bank1.write(status, read_err_csl_part0_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num0_part1_bank1.write(status, read_err_csl_part1_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num1_part1_bank1.write(status, read_err_csl_part1_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num0_part2_bank1.write(status, read_err_csl_part2_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num1_part2_bank1.write(status, read_err_csl_part2_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num0_part3_bank1.write(status, read_err_csl_part3_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num1_part3_bank1.write(status, read_err_csl_part3_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num0_part4_bank1.write(status, read_err_csl_part4_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num1_part4_bank1.write(status, read_err_csl_part4_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num0_part5_bank1.write(status, read_err_csl_part5_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num1_part5_bank1.write(status, read_err_csl_part5_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num0_part6_bank1.write(status, read_err_csl_part6_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num1_part6_bank1.write(status, read_err_csl_part6_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num0_part7_bank1.write(status, read_err_csl_part7_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num1_part7_bank1.write(status, read_err_csl_part7_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num0_part8_bank1.write(status, read_err_csl_part8_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num1_part8_bank1.write(status, read_err_csl_part8_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num0_part9_bank1.write(status, read_err_csl_part9_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num1_part9_bank1.write(status, read_err_csl_part9_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank1_reg.mc_vmc_wl_num0_bank1.write(status, read_err_row_reg_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank1_reg.mc_vmc_wl_num1_bank1.write(status, read_err_row_reg_q[1], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank1_reg.mc_vmc_wl_num2_bank1.write(status, read_err_row_reg_q[2], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank1_reg.mc_vmc_wl_num3_bank1.write(status, read_err_row_reg_q[3], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank1_reg.mc_vmc_wl_num4_bank1.write(status, read_err_row_reg_q[4], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank1_reg.mc_vmc_wl_num5_bank1.write(status, read_err_row_reg_q[5], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank1_reg.mc_vmc_wl_num6_bank1.write(status, read_err_row_reg_q[6], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank1_reg.mc_vmc_wl_num7_bank1.write(status, read_err_row_reg_q[7], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank1_reg.mc_vmc_wl_num8_bank1.write(status, read_err_row_reg_q[8], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank1_reg.mc_vmc_wl_num9_bank1.write(status, read_err_row_reg_q[9], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank1_reg.mc_vmc_wl_num10_bank1.write(status, read_err_row_reg_q[10], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank1_reg.mc_vmc_wl_num11_bank1.write(status, read_err_row_reg_q[11], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank1_reg.mc_vmc_wl_num12_bank1.write(status, read_err_row_reg_q[12], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank1_reg.mc_vmc_wl_num13_bank1.write(status, read_err_row_reg_q[13], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank1_reg.mc_vmc_wl_num14_bank1.write(status, read_err_row_reg_q[14], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank1_reg.mc_vmc_wl_num15_bank1.write(status, read_err_row_reg_q[15], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank1_reg.mc_vmc_wl_num16_bank1.write(status, read_err_row_reg_q[16], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank1_reg.mc_vmc_wl_num17_bank1.write(status, read_err_row_reg_q[17], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank1_reg.mc_vmc_wl_num18_bank1.write(status, read_err_row_reg_q[18], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank1_reg.mc_vmc_wl_num19_bank1.write(status, read_err_row_reg_q[19], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank1_reg.mc_vmc_wl_num20_bank1.write(status, read_err_row_reg_q[20], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank1_reg.mc_vmc_wl_num21_bank1.write(status, read_err_row_reg_q[21], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank1_reg.mc_vmc_wl_num22_bank1.write(status, read_err_row_reg_q[22], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank1_reg.mc_vmc_wl_num23_bank1.write(status, read_err_row_reg_q[23], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank1_reg.mc_vmc_wl_num24_bank1.write(status, read_err_row_reg_q[24], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank1_reg.mc_vmc_wl_num25_bank1.write(status, read_err_row_reg_q[25], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank1_reg.mc_vmc_wl_num26_bank1.write(status, read_err_row_reg_q[26], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank1_reg.mc_vmc_wl_num27_bank1.write(status, read_err_row_reg_q[27], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank1_reg.mc_vmc_wl_num28_bank1.write(status, read_err_row_reg_q[28], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank1_reg.mc_vmc_wl_num29_bank1.write(status, read_err_row_reg_q[29], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank1_reg.mc_vmc_wl_num30_bank1.write(status, read_err_row_reg_q[30], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank1_reg.mc_vmc_wl_num31_bank1.write(status, read_err_row_reg_q[31], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank1_reg.mc_vmc_wl_num32_bank1.write(status, read_err_row_reg_q[32], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank1_reg.mc_vmc_wl_num33_bank1.write(status, read_err_row_reg_q[33], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank1_reg.mc_vmc_wl_num34_bank1.write(status, read_err_row_reg_q[34], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank1_reg.mc_vmc_wl_num35_bank1.write(status, read_err_row_reg_q[35], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank1_reg.mc_vmc_wl_num36_bank1.write(status, read_err_row_reg_q[36], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank1_reg.mc_vmc_wl_num37_bank1.write(status, read_err_row_reg_q[37], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank1_reg.mc_vmc_wl_num38_bank1.write(status, read_err_row_reg_q[38], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank1_reg.mc_vmc_wl_num39_bank1.write(status, read_err_row_reg_q[39], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank1_reg.mc_vmc_wl_num40_bank1.write(status, read_err_row_reg_q[40], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank1_reg.mc_vmc_wl_num41_bank1.write(status, read_err_row_reg_q[41], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank1_reg.mc_vmc_wl_num42_bank1.write(status, read_err_row_reg_q[42], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank1_reg.mc_vmc_wl_num43_bank1.write(status, read_err_row_reg_q[43], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank1_reg.mc_vmc_wl_num44_bank1.write(status, read_err_row_reg_q[44], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank1_reg.mc_vmc_wl_num45_bank1.write(status, read_err_row_reg_q[45], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank1_reg.mc_vmc_wl_num46_bank1.write(status, read_err_row_reg_q[46], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank1_reg.mc_vmc_wl_num47_bank1.write(status, read_err_row_reg_q[47], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank1_reg.mc_vmc_wl_num48_bank1.write(status, read_err_row_reg_q[48], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank1_reg.mc_vmc_wl_num49_bank1.write(status, read_err_row_reg_q[49], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank1_reg.mc_vmc_wl_num50_bank1.write(status, read_err_row_reg_q[50], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank1_reg.mc_vmc_wl_num51_bank1.write(status, read_err_row_reg_q[51], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank1_reg.mc_vmc_wl_num52_bank1.write(status, read_err_row_reg_q[52], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank1_reg.mc_vmc_wl_num53_bank1.write(status, read_err_row_reg_q[53], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank1_reg.mc_vmc_wl_num54_bank1.write(status, read_err_row_reg_q[54], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank1_reg.mc_vmc_wl_num55_bank1.write(status, read_err_row_reg_q[55], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank1_reg.mc_vmc_wl_num56_bank1.write(status, read_err_row_reg_q[56], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank1_reg.mc_vmc_wl_num57_bank1.write(status, read_err_row_reg_q[57], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank1_reg.mc_vmc_wl_num58_bank1.write(status, read_err_row_reg_q[58], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank1_reg.mc_vmc_wl_num59_bank1.write(status, read_err_row_reg_q[59], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank1_reg.mc_vmc_wl_num60_bank1.write(status, read_err_row_reg_q[60], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank1_reg.mc_vmc_wl_num61_bank1.write(status, read_err_row_reg_q[61], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank1_reg.mc_vmc_wl_num62_bank1.write(status, read_err_row_reg_q[62], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank1_reg.mc_vmc_wl_num63_bank1.write(status, read_err_row_reg_q[63], UVM_FRONTDOOR);
        //}}}
            //{{{
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank2_reg.mc_vmc_bl_num0_part0_bank2.write(status, read_err_csl_part0_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank2_reg.mc_vmc_bl_num1_part0_bank2.write(status, read_err_csl_part0_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank2_reg.mc_vmc_bl_num0_part1_bank2.write(status, read_err_csl_part1_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank2_reg.mc_vmc_bl_num1_part1_bank2.write(status, read_err_csl_part1_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank2_reg.mc_vmc_bl_num0_part2_bank2.write(status, read_err_csl_part2_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank2_reg.mc_vmc_bl_num1_part2_bank2.write(status, read_err_csl_part2_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank2_reg.mc_vmc_bl_num0_part3_bank2.write(status, read_err_csl_part3_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank2_reg.mc_vmc_bl_num1_part3_bank2.write(status, read_err_csl_part3_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank2_reg.mc_vmc_bl_num0_part4_bank2.write(status, read_err_csl_part4_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank2_reg.mc_vmc_bl_num1_part4_bank2.write(status, read_err_csl_part4_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank2_reg.mc_vmc_bl_num0_part5_bank2.write(status, read_err_csl_part5_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank2_reg.mc_vmc_bl_num1_part5_bank2.write(status, read_err_csl_part5_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank2_reg.mc_vmc_bl_num0_part6_bank2.write(status, read_err_csl_part6_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank2_reg.mc_vmc_bl_num1_part6_bank2.write(status, read_err_csl_part6_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank2_reg.mc_vmc_bl_num0_part7_bank2.write(status, read_err_csl_part7_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank2_reg.mc_vmc_bl_num1_part7_bank2.write(status, read_err_csl_part7_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank2_reg.mc_vmc_bl_num0_part8_bank2.write(status, read_err_csl_part8_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank2_reg.mc_vmc_bl_num1_part8_bank2.write(status, read_err_csl_part8_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank2_reg.mc_vmc_bl_num0_part9_bank2.write(status, read_err_csl_part9_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank2_reg.mc_vmc_bl_num1_part9_bank2.write(status, read_err_csl_part9_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank2_reg.mc_vmc_wl_num0_bank2.write(status, read_err_row_reg_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank2_reg.mc_vmc_wl_num1_bank2.write(status, read_err_row_reg_q[1], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank2_reg.mc_vmc_wl_num2_bank2.write(status, read_err_row_reg_q[2], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank2_reg.mc_vmc_wl_num3_bank2.write(status, read_err_row_reg_q[3], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank2_reg.mc_vmc_wl_num4_bank2.write(status, read_err_row_reg_q[4], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank2_reg.mc_vmc_wl_num5_bank2.write(status, read_err_row_reg_q[5], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank2_reg.mc_vmc_wl_num6_bank2.write(status, read_err_row_reg_q[6], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank2_reg.mc_vmc_wl_num7_bank2.write(status, read_err_row_reg_q[7], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank2_reg.mc_vmc_wl_num8_bank2.write(status, read_err_row_reg_q[8], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank2_reg.mc_vmc_wl_num9_bank2.write(status, read_err_row_reg_q[9], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank2_reg.mc_vmc_wl_num10_bank2.write(status, read_err_row_reg_q[10], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank2_reg.mc_vmc_wl_num11_bank2.write(status, read_err_row_reg_q[11], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank2_reg.mc_vmc_wl_num12_bank2.write(status, read_err_row_reg_q[12], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank2_reg.mc_vmc_wl_num13_bank2.write(status, read_err_row_reg_q[13], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank2_reg.mc_vmc_wl_num14_bank2.write(status, read_err_row_reg_q[14], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank2_reg.mc_vmc_wl_num15_bank2.write(status, read_err_row_reg_q[15], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank2_reg.mc_vmc_wl_num16_bank2.write(status, read_err_row_reg_q[16], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank2_reg.mc_vmc_wl_num17_bank2.write(status, read_err_row_reg_q[17], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank2_reg.mc_vmc_wl_num18_bank2.write(status, read_err_row_reg_q[18], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank2_reg.mc_vmc_wl_num19_bank2.write(status, read_err_row_reg_q[19], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank2_reg.mc_vmc_wl_num20_bank2.write(status, read_err_row_reg_q[20], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank2_reg.mc_vmc_wl_num21_bank2.write(status, read_err_row_reg_q[21], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank2_reg.mc_vmc_wl_num22_bank2.write(status, read_err_row_reg_q[22], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank2_reg.mc_vmc_wl_num23_bank2.write(status, read_err_row_reg_q[23], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank2_reg.mc_vmc_wl_num24_bank2.write(status, read_err_row_reg_q[24], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank2_reg.mc_vmc_wl_num25_bank2.write(status, read_err_row_reg_q[25], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank2_reg.mc_vmc_wl_num26_bank2.write(status, read_err_row_reg_q[26], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank2_reg.mc_vmc_wl_num27_bank2.write(status, read_err_row_reg_q[27], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank2_reg.mc_vmc_wl_num28_bank2.write(status, read_err_row_reg_q[28], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank2_reg.mc_vmc_wl_num29_bank2.write(status, read_err_row_reg_q[29], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank2_reg.mc_vmc_wl_num30_bank2.write(status, read_err_row_reg_q[30], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank2_reg.mc_vmc_wl_num31_bank2.write(status, read_err_row_reg_q[31], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank2_reg.mc_vmc_wl_num32_bank2.write(status, read_err_row_reg_q[32], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank2_reg.mc_vmc_wl_num33_bank2.write(status, read_err_row_reg_q[33], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank2_reg.mc_vmc_wl_num34_bank2.write(status, read_err_row_reg_q[34], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank2_reg.mc_vmc_wl_num35_bank2.write(status, read_err_row_reg_q[35], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank2_reg.mc_vmc_wl_num36_bank2.write(status, read_err_row_reg_q[36], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank2_reg.mc_vmc_wl_num37_bank2.write(status, read_err_row_reg_q[37], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank2_reg.mc_vmc_wl_num38_bank2.write(status, read_err_row_reg_q[38], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank2_reg.mc_vmc_wl_num39_bank2.write(status, read_err_row_reg_q[39], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank2_reg.mc_vmc_wl_num40_bank2.write(status, read_err_row_reg_q[40], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank2_reg.mc_vmc_wl_num41_bank2.write(status, read_err_row_reg_q[41], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank2_reg.mc_vmc_wl_num42_bank2.write(status, read_err_row_reg_q[42], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank2_reg.mc_vmc_wl_num43_bank2.write(status, read_err_row_reg_q[43], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank2_reg.mc_vmc_wl_num44_bank2.write(status, read_err_row_reg_q[44], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank2_reg.mc_vmc_wl_num45_bank2.write(status, read_err_row_reg_q[45], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank2_reg.mc_vmc_wl_num46_bank2.write(status, read_err_row_reg_q[46], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank2_reg.mc_vmc_wl_num47_bank2.write(status, read_err_row_reg_q[47], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank2_reg.mc_vmc_wl_num48_bank2.write(status, read_err_row_reg_q[48], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank2_reg.mc_vmc_wl_num49_bank2.write(status, read_err_row_reg_q[49], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank2_reg.mc_vmc_wl_num50_bank2.write(status, read_err_row_reg_q[50], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank2_reg.mc_vmc_wl_num51_bank2.write(status, read_err_row_reg_q[51], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank2_reg.mc_vmc_wl_num52_bank2.write(status, read_err_row_reg_q[52], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank2_reg.mc_vmc_wl_num53_bank2.write(status, read_err_row_reg_q[53], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank2_reg.mc_vmc_wl_num54_bank2.write(status, read_err_row_reg_q[54], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank2_reg.mc_vmc_wl_num55_bank2.write(status, read_err_row_reg_q[55], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank2_reg.mc_vmc_wl_num56_bank2.write(status, read_err_row_reg_q[56], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank2_reg.mc_vmc_wl_num57_bank2.write(status, read_err_row_reg_q[57], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank2_reg.mc_vmc_wl_num58_bank2.write(status, read_err_row_reg_q[58], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank2_reg.mc_vmc_wl_num59_bank2.write(status, read_err_row_reg_q[59], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank2_reg.mc_vmc_wl_num60_bank2.write(status, read_err_row_reg_q[60], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank2_reg.mc_vmc_wl_num61_bank2.write(status, read_err_row_reg_q[61], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank2_reg.mc_vmc_wl_num62_bank2.write(status, read_err_row_reg_q[62], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank2_reg.mc_vmc_wl_num63_bank2.write(status, read_err_row_reg_q[63], UVM_FRONTDOOR);
        //}}}
        `elsif TEST_1_SHOT_4
                //{{{
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num0_part0_bank1.write(status, read_err_csl_part0_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num1_part0_bank1.write(status, read_err_csl_part0_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num0_part1_bank1.write(status, read_err_csl_part1_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num1_part1_bank1.write(status, read_err_csl_part1_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num0_part2_bank1.write(status, read_err_csl_part2_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num1_part2_bank1.write(status, read_err_csl_part2_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num0_part3_bank1.write(status, read_err_csl_part3_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num1_part3_bank1.write(status, read_err_csl_part3_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num0_part4_bank1.write(status, read_err_csl_part4_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num1_part4_bank1.write(status, read_err_csl_part4_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num0_part5_bank1.write(status, read_err_csl_part5_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num1_part5_bank1.write(status, read_err_csl_part5_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num0_part6_bank1.write(status, read_err_csl_part6_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num1_part6_bank1.write(status, read_err_csl_part6_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num0_part7_bank1.write(status, read_err_csl_part7_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num1_part7_bank1.write(status, read_err_csl_part7_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num0_part8_bank1.write(status, read_err_csl_part8_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num1_part8_bank1.write(status, read_err_csl_part8_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num0_part9_bank1.write(status, read_err_csl_part9_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num1_part9_bank1.write(status, read_err_csl_part9_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank1_reg.mc_vmc_wl_num0_bank1.write(status, read_err_row_reg_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank1_reg.mc_vmc_wl_num1_bank1.write(status, read_err_row_reg_q[1], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank1_reg.mc_vmc_wl_num2_bank1.write(status, read_err_row_reg_q[2], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank1_reg.mc_vmc_wl_num3_bank1.write(status, read_err_row_reg_q[3], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank1_reg.mc_vmc_wl_num4_bank1.write(status, read_err_row_reg_q[4], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank1_reg.mc_vmc_wl_num5_bank1.write(status, read_err_row_reg_q[5], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank1_reg.mc_vmc_wl_num6_bank1.write(status, read_err_row_reg_q[6], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank1_reg.mc_vmc_wl_num7_bank1.write(status, read_err_row_reg_q[7], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank1_reg.mc_vmc_wl_num8_bank1.write(status, read_err_row_reg_q[8], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank1_reg.mc_vmc_wl_num9_bank1.write(status, read_err_row_reg_q[9], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank1_reg.mc_vmc_wl_num10_bank1.write(status, read_err_row_reg_q[10], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank1_reg.mc_vmc_wl_num11_bank1.write(status, read_err_row_reg_q[11], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank1_reg.mc_vmc_wl_num12_bank1.write(status, read_err_row_reg_q[12], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank1_reg.mc_vmc_wl_num13_bank1.write(status, read_err_row_reg_q[13], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank1_reg.mc_vmc_wl_num14_bank1.write(status, read_err_row_reg_q[14], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank1_reg.mc_vmc_wl_num15_bank1.write(status, read_err_row_reg_q[15], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank1_reg.mc_vmc_wl_num16_bank1.write(status, read_err_row_reg_q[16], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank1_reg.mc_vmc_wl_num17_bank1.write(status, read_err_row_reg_q[17], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank1_reg.mc_vmc_wl_num18_bank1.write(status, read_err_row_reg_q[18], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank1_reg.mc_vmc_wl_num19_bank1.write(status, read_err_row_reg_q[19], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank1_reg.mc_vmc_wl_num20_bank1.write(status, read_err_row_reg_q[20], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank1_reg.mc_vmc_wl_num21_bank1.write(status, read_err_row_reg_q[21], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank1_reg.mc_vmc_wl_num22_bank1.write(status, read_err_row_reg_q[22], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank1_reg.mc_vmc_wl_num23_bank1.write(status, read_err_row_reg_q[23], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank1_reg.mc_vmc_wl_num24_bank1.write(status, read_err_row_reg_q[24], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank1_reg.mc_vmc_wl_num25_bank1.write(status, read_err_row_reg_q[25], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank1_reg.mc_vmc_wl_num26_bank1.write(status, read_err_row_reg_q[26], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank1_reg.mc_vmc_wl_num27_bank1.write(status, read_err_row_reg_q[27], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank1_reg.mc_vmc_wl_num28_bank1.write(status, read_err_row_reg_q[28], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank1_reg.mc_vmc_wl_num29_bank1.write(status, read_err_row_reg_q[29], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank1_reg.mc_vmc_wl_num30_bank1.write(status, read_err_row_reg_q[30], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank1_reg.mc_vmc_wl_num31_bank1.write(status, read_err_row_reg_q[31], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank1_reg.mc_vmc_wl_num32_bank1.write(status, read_err_row_reg_q[32], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank1_reg.mc_vmc_wl_num33_bank1.write(status, read_err_row_reg_q[33], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank1_reg.mc_vmc_wl_num34_bank1.write(status, read_err_row_reg_q[34], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank1_reg.mc_vmc_wl_num35_bank1.write(status, read_err_row_reg_q[35], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank1_reg.mc_vmc_wl_num36_bank1.write(status, read_err_row_reg_q[36], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank1_reg.mc_vmc_wl_num37_bank1.write(status, read_err_row_reg_q[37], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank1_reg.mc_vmc_wl_num38_bank1.write(status, read_err_row_reg_q[38], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank1_reg.mc_vmc_wl_num39_bank1.write(status, read_err_row_reg_q[39], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank1_reg.mc_vmc_wl_num40_bank1.write(status, read_err_row_reg_q[40], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank1_reg.mc_vmc_wl_num41_bank1.write(status, read_err_row_reg_q[41], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank1_reg.mc_vmc_wl_num42_bank1.write(status, read_err_row_reg_q[42], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank1_reg.mc_vmc_wl_num43_bank1.write(status, read_err_row_reg_q[43], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank1_reg.mc_vmc_wl_num44_bank1.write(status, read_err_row_reg_q[44], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank1_reg.mc_vmc_wl_num45_bank1.write(status, read_err_row_reg_q[45], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank1_reg.mc_vmc_wl_num46_bank1.write(status, read_err_row_reg_q[46], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank1_reg.mc_vmc_wl_num47_bank1.write(status, read_err_row_reg_q[47], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank1_reg.mc_vmc_wl_num48_bank1.write(status, read_err_row_reg_q[48], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank1_reg.mc_vmc_wl_num49_bank1.write(status, read_err_row_reg_q[49], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank1_reg.mc_vmc_wl_num50_bank1.write(status, read_err_row_reg_q[50], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank1_reg.mc_vmc_wl_num51_bank1.write(status, read_err_row_reg_q[51], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank1_reg.mc_vmc_wl_num52_bank1.write(status, read_err_row_reg_q[52], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank1_reg.mc_vmc_wl_num53_bank1.write(status, read_err_row_reg_q[53], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank1_reg.mc_vmc_wl_num54_bank1.write(status, read_err_row_reg_q[54], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank1_reg.mc_vmc_wl_num55_bank1.write(status, read_err_row_reg_q[55], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank1_reg.mc_vmc_wl_num56_bank1.write(status, read_err_row_reg_q[56], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank1_reg.mc_vmc_wl_num57_bank1.write(status, read_err_row_reg_q[57], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank1_reg.mc_vmc_wl_num58_bank1.write(status, read_err_row_reg_q[58], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank1_reg.mc_vmc_wl_num59_bank1.write(status, read_err_row_reg_q[59], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank1_reg.mc_vmc_wl_num60_bank1.write(status, read_err_row_reg_q[60], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank1_reg.mc_vmc_wl_num61_bank1.write(status, read_err_row_reg_q[61], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank1_reg.mc_vmc_wl_num62_bank1.write(status, read_err_row_reg_q[62], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank1_reg.mc_vmc_wl_num63_bank1.write(status, read_err_row_reg_q[63], UVM_FRONTDOOR);
        //}}}
            //{{{
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank2_reg.mc_vmc_bl_num0_part0_bank2.write(status, read_err_csl_part0_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank2_reg.mc_vmc_bl_num1_part0_bank2.write(status, read_err_csl_part0_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank2_reg.mc_vmc_bl_num0_part1_bank2.write(status, read_err_csl_part1_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank2_reg.mc_vmc_bl_num1_part1_bank2.write(status, read_err_csl_part1_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank2_reg.mc_vmc_bl_num0_part2_bank2.write(status, read_err_csl_part2_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank2_reg.mc_vmc_bl_num1_part2_bank2.write(status, read_err_csl_part2_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank2_reg.mc_vmc_bl_num0_part3_bank2.write(status, read_err_csl_part3_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank2_reg.mc_vmc_bl_num1_part3_bank2.write(status, read_err_csl_part3_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank2_reg.mc_vmc_bl_num0_part4_bank2.write(status, read_err_csl_part4_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank2_reg.mc_vmc_bl_num1_part4_bank2.write(status, read_err_csl_part4_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank2_reg.mc_vmc_bl_num0_part5_bank2.write(status, read_err_csl_part5_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank2_reg.mc_vmc_bl_num1_part5_bank2.write(status, read_err_csl_part5_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank2_reg.mc_vmc_bl_num0_part6_bank2.write(status, read_err_csl_part6_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank2_reg.mc_vmc_bl_num1_part6_bank2.write(status, read_err_csl_part6_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank2_reg.mc_vmc_bl_num0_part7_bank2.write(status, read_err_csl_part7_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank2_reg.mc_vmc_bl_num1_part7_bank2.write(status, read_err_csl_part7_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank2_reg.mc_vmc_bl_num0_part8_bank2.write(status, read_err_csl_part8_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank2_reg.mc_vmc_bl_num1_part8_bank2.write(status, read_err_csl_part8_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank2_reg.mc_vmc_bl_num0_part9_bank2.write(status, read_err_csl_part9_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank2_reg.mc_vmc_bl_num1_part9_bank2.write(status, read_err_csl_part9_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank2_reg.mc_vmc_wl_num0_bank2.write(status, read_err_row_reg_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank2_reg.mc_vmc_wl_num1_bank2.write(status, read_err_row_reg_q[1], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank2_reg.mc_vmc_wl_num2_bank2.write(status, read_err_row_reg_q[2], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank2_reg.mc_vmc_wl_num3_bank2.write(status, read_err_row_reg_q[3], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank2_reg.mc_vmc_wl_num4_bank2.write(status, read_err_row_reg_q[4], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank2_reg.mc_vmc_wl_num5_bank2.write(status, read_err_row_reg_q[5], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank2_reg.mc_vmc_wl_num6_bank2.write(status, read_err_row_reg_q[6], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank2_reg.mc_vmc_wl_num7_bank2.write(status, read_err_row_reg_q[7], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank2_reg.mc_vmc_wl_num8_bank2.write(status, read_err_row_reg_q[8], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank2_reg.mc_vmc_wl_num9_bank2.write(status, read_err_row_reg_q[9], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank2_reg.mc_vmc_wl_num10_bank2.write(status, read_err_row_reg_q[10], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank2_reg.mc_vmc_wl_num11_bank2.write(status, read_err_row_reg_q[11], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank2_reg.mc_vmc_wl_num12_bank2.write(status, read_err_row_reg_q[12], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank2_reg.mc_vmc_wl_num13_bank2.write(status, read_err_row_reg_q[13], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank2_reg.mc_vmc_wl_num14_bank2.write(status, read_err_row_reg_q[14], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank2_reg.mc_vmc_wl_num15_bank2.write(status, read_err_row_reg_q[15], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank2_reg.mc_vmc_wl_num16_bank2.write(status, read_err_row_reg_q[16], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank2_reg.mc_vmc_wl_num17_bank2.write(status, read_err_row_reg_q[17], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank2_reg.mc_vmc_wl_num18_bank2.write(status, read_err_row_reg_q[18], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank2_reg.mc_vmc_wl_num19_bank2.write(status, read_err_row_reg_q[19], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank2_reg.mc_vmc_wl_num20_bank2.write(status, read_err_row_reg_q[20], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank2_reg.mc_vmc_wl_num21_bank2.write(status, read_err_row_reg_q[21], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank2_reg.mc_vmc_wl_num22_bank2.write(status, read_err_row_reg_q[22], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank2_reg.mc_vmc_wl_num23_bank2.write(status, read_err_row_reg_q[23], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank2_reg.mc_vmc_wl_num24_bank2.write(status, read_err_row_reg_q[24], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank2_reg.mc_vmc_wl_num25_bank2.write(status, read_err_row_reg_q[25], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank2_reg.mc_vmc_wl_num26_bank2.write(status, read_err_row_reg_q[26], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank2_reg.mc_vmc_wl_num27_bank2.write(status, read_err_row_reg_q[27], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank2_reg.mc_vmc_wl_num28_bank2.write(status, read_err_row_reg_q[28], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank2_reg.mc_vmc_wl_num29_bank2.write(status, read_err_row_reg_q[29], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank2_reg.mc_vmc_wl_num30_bank2.write(status, read_err_row_reg_q[30], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank2_reg.mc_vmc_wl_num31_bank2.write(status, read_err_row_reg_q[31], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank2_reg.mc_vmc_wl_num32_bank2.write(status, read_err_row_reg_q[32], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank2_reg.mc_vmc_wl_num33_bank2.write(status, read_err_row_reg_q[33], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank2_reg.mc_vmc_wl_num34_bank2.write(status, read_err_row_reg_q[34], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank2_reg.mc_vmc_wl_num35_bank2.write(status, read_err_row_reg_q[35], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank2_reg.mc_vmc_wl_num36_bank2.write(status, read_err_row_reg_q[36], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank2_reg.mc_vmc_wl_num37_bank2.write(status, read_err_row_reg_q[37], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank2_reg.mc_vmc_wl_num38_bank2.write(status, read_err_row_reg_q[38], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank2_reg.mc_vmc_wl_num39_bank2.write(status, read_err_row_reg_q[39], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank2_reg.mc_vmc_wl_num40_bank2.write(status, read_err_row_reg_q[40], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank2_reg.mc_vmc_wl_num41_bank2.write(status, read_err_row_reg_q[41], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank2_reg.mc_vmc_wl_num42_bank2.write(status, read_err_row_reg_q[42], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank2_reg.mc_vmc_wl_num43_bank2.write(status, read_err_row_reg_q[43], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank2_reg.mc_vmc_wl_num44_bank2.write(status, read_err_row_reg_q[44], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank2_reg.mc_vmc_wl_num45_bank2.write(status, read_err_row_reg_q[45], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank2_reg.mc_vmc_wl_num46_bank2.write(status, read_err_row_reg_q[46], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank2_reg.mc_vmc_wl_num47_bank2.write(status, read_err_row_reg_q[47], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank2_reg.mc_vmc_wl_num48_bank2.write(status, read_err_row_reg_q[48], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank2_reg.mc_vmc_wl_num49_bank2.write(status, read_err_row_reg_q[49], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank2_reg.mc_vmc_wl_num50_bank2.write(status, read_err_row_reg_q[50], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank2_reg.mc_vmc_wl_num51_bank2.write(status, read_err_row_reg_q[51], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank2_reg.mc_vmc_wl_num52_bank2.write(status, read_err_row_reg_q[52], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank2_reg.mc_vmc_wl_num53_bank2.write(status, read_err_row_reg_q[53], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank2_reg.mc_vmc_wl_num54_bank2.write(status, read_err_row_reg_q[54], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank2_reg.mc_vmc_wl_num55_bank2.write(status, read_err_row_reg_q[55], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank2_reg.mc_vmc_wl_num56_bank2.write(status, read_err_row_reg_q[56], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank2_reg.mc_vmc_wl_num57_bank2.write(status, read_err_row_reg_q[57], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank2_reg.mc_vmc_wl_num58_bank2.write(status, read_err_row_reg_q[58], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank2_reg.mc_vmc_wl_num59_bank2.write(status, read_err_row_reg_q[59], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank2_reg.mc_vmc_wl_num60_bank2.write(status, read_err_row_reg_q[60], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank2_reg.mc_vmc_wl_num61_bank2.write(status, read_err_row_reg_q[61], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank2_reg.mc_vmc_wl_num62_bank2.write(status, read_err_row_reg_q[62], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank2_reg.mc_vmc_wl_num63_bank2.write(status, read_err_row_reg_q[63], UVM_FRONTDOOR);
        //}}}
            //{{{
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank3_reg.mc_vmc_bl_num0_part0_bank3.write(status, read_err_csl_part0_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank3_reg.mc_vmc_bl_num1_part0_bank3.write(status, read_err_csl_part0_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank3_reg.mc_vmc_bl_num0_part1_bank3.write(status, read_err_csl_part1_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank3_reg.mc_vmc_bl_num1_part1_bank3.write(status, read_err_csl_part1_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank3_reg.mc_vmc_bl_num0_part2_bank3.write(status, read_err_csl_part2_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank3_reg.mc_vmc_bl_num1_part2_bank3.write(status, read_err_csl_part2_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank3_reg.mc_vmc_bl_num0_part3_bank3.write(status, read_err_csl_part3_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank3_reg.mc_vmc_bl_num1_part3_bank3.write(status, read_err_csl_part3_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank3_reg.mc_vmc_bl_num0_part4_bank3.write(status, read_err_csl_part4_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank3_reg.mc_vmc_bl_num1_part4_bank3.write(status, read_err_csl_part4_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank3_reg.mc_vmc_bl_num0_part5_bank3.write(status, read_err_csl_part5_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank3_reg.mc_vmc_bl_num1_part5_bank3.write(status, read_err_csl_part5_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank3_reg.mc_vmc_bl_num0_part6_bank3.write(status, read_err_csl_part6_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank3_reg.mc_vmc_bl_num1_part6_bank3.write(status, read_err_csl_part6_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank3_reg.mc_vmc_bl_num0_part7_bank3.write(status, read_err_csl_part7_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank3_reg.mc_vmc_bl_num1_part7_bank3.write(status, read_err_csl_part7_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank3_reg.mc_vmc_bl_num0_part8_bank3.write(status, read_err_csl_part8_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank3_reg.mc_vmc_bl_num1_part8_bank3.write(status, read_err_csl_part8_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank3_reg.mc_vmc_bl_num0_part9_bank3.write(status, read_err_csl_part9_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank3_reg.mc_vmc_bl_num1_part9_bank3.write(status, read_err_csl_part9_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank3_reg.mc_vmc_wl_num0_bank3.write(status, read_err_row_reg_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank3_reg.mc_vmc_wl_num1_bank3.write(status, read_err_row_reg_q[1], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank3_reg.mc_vmc_wl_num2_bank3.write(status, read_err_row_reg_q[2], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank3_reg.mc_vmc_wl_num3_bank3.write(status, read_err_row_reg_q[3], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank3_reg.mc_vmc_wl_num4_bank3.write(status, read_err_row_reg_q[4], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank3_reg.mc_vmc_wl_num5_bank3.write(status, read_err_row_reg_q[5], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank3_reg.mc_vmc_wl_num6_bank3.write(status, read_err_row_reg_q[6], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank3_reg.mc_vmc_wl_num7_bank3.write(status, read_err_row_reg_q[7], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank3_reg.mc_vmc_wl_num8_bank3.write(status, read_err_row_reg_q[8], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank3_reg.mc_vmc_wl_num9_bank3.write(status, read_err_row_reg_q[9], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank3_reg.mc_vmc_wl_num10_bank3.write(status, read_err_row_reg_q[10], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank3_reg.mc_vmc_wl_num11_bank3.write(status, read_err_row_reg_q[11], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank3_reg.mc_vmc_wl_num12_bank3.write(status, read_err_row_reg_q[12], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank3_reg.mc_vmc_wl_num13_bank3.write(status, read_err_row_reg_q[13], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank3_reg.mc_vmc_wl_num14_bank3.write(status, read_err_row_reg_q[14], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank3_reg.mc_vmc_wl_num15_bank3.write(status, read_err_row_reg_q[15], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank3_reg.mc_vmc_wl_num16_bank3.write(status, read_err_row_reg_q[16], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank3_reg.mc_vmc_wl_num17_bank3.write(status, read_err_row_reg_q[17], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank3_reg.mc_vmc_wl_num18_bank3.write(status, read_err_row_reg_q[18], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank3_reg.mc_vmc_wl_num19_bank3.write(status, read_err_row_reg_q[19], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank3_reg.mc_vmc_wl_num20_bank3.write(status, read_err_row_reg_q[20], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank3_reg.mc_vmc_wl_num21_bank3.write(status, read_err_row_reg_q[21], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank3_reg.mc_vmc_wl_num22_bank3.write(status, read_err_row_reg_q[22], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank3_reg.mc_vmc_wl_num23_bank3.write(status, read_err_row_reg_q[23], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank3_reg.mc_vmc_wl_num24_bank3.write(status, read_err_row_reg_q[24], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank3_reg.mc_vmc_wl_num25_bank3.write(status, read_err_row_reg_q[25], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank3_reg.mc_vmc_wl_num26_bank3.write(status, read_err_row_reg_q[26], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank3_reg.mc_vmc_wl_num27_bank3.write(status, read_err_row_reg_q[27], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank3_reg.mc_vmc_wl_num28_bank3.write(status, read_err_row_reg_q[28], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank3_reg.mc_vmc_wl_num29_bank3.write(status, read_err_row_reg_q[29], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank3_reg.mc_vmc_wl_num30_bank3.write(status, read_err_row_reg_q[30], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank3_reg.mc_vmc_wl_num31_bank3.write(status, read_err_row_reg_q[31], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank3_reg.mc_vmc_wl_num32_bank3.write(status, read_err_row_reg_q[32], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank3_reg.mc_vmc_wl_num33_bank3.write(status, read_err_row_reg_q[33], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank3_reg.mc_vmc_wl_num34_bank3.write(status, read_err_row_reg_q[34], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank3_reg.mc_vmc_wl_num35_bank3.write(status, read_err_row_reg_q[35], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank3_reg.mc_vmc_wl_num36_bank3.write(status, read_err_row_reg_q[36], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank3_reg.mc_vmc_wl_num37_bank3.write(status, read_err_row_reg_q[37], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank3_reg.mc_vmc_wl_num38_bank3.write(status, read_err_row_reg_q[38], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank3_reg.mc_vmc_wl_num39_bank3.write(status, read_err_row_reg_q[39], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank3_reg.mc_vmc_wl_num40_bank3.write(status, read_err_row_reg_q[40], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank3_reg.mc_vmc_wl_num41_bank3.write(status, read_err_row_reg_q[41], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank3_reg.mc_vmc_wl_num42_bank3.write(status, read_err_row_reg_q[42], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank3_reg.mc_vmc_wl_num43_bank3.write(status, read_err_row_reg_q[43], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank3_reg.mc_vmc_wl_num44_bank3.write(status, read_err_row_reg_q[44], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank3_reg.mc_vmc_wl_num45_bank3.write(status, read_err_row_reg_q[45], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank3_reg.mc_vmc_wl_num46_bank3.write(status, read_err_row_reg_q[46], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank3_reg.mc_vmc_wl_num47_bank3.write(status, read_err_row_reg_q[47], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank3_reg.mc_vmc_wl_num48_bank3.write(status, read_err_row_reg_q[48], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank3_reg.mc_vmc_wl_num49_bank3.write(status, read_err_row_reg_q[49], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank3_reg.mc_vmc_wl_num50_bank3.write(status, read_err_row_reg_q[50], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank3_reg.mc_vmc_wl_num51_bank3.write(status, read_err_row_reg_q[51], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank3_reg.mc_vmc_wl_num52_bank3.write(status, read_err_row_reg_q[52], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank3_reg.mc_vmc_wl_num53_bank3.write(status, read_err_row_reg_q[53], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank3_reg.mc_vmc_wl_num54_bank3.write(status, read_err_row_reg_q[54], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank3_reg.mc_vmc_wl_num55_bank3.write(status, read_err_row_reg_q[55], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank3_reg.mc_vmc_wl_num56_bank3.write(status, read_err_row_reg_q[56], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank3_reg.mc_vmc_wl_num57_bank3.write(status, read_err_row_reg_q[57], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank3_reg.mc_vmc_wl_num58_bank3.write(status, read_err_row_reg_q[58], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank3_reg.mc_vmc_wl_num59_bank3.write(status, read_err_row_reg_q[59], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank3_reg.mc_vmc_wl_num60_bank3.write(status, read_err_row_reg_q[60], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank3_reg.mc_vmc_wl_num61_bank3.write(status, read_err_row_reg_q[61], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank3_reg.mc_vmc_wl_num62_bank3.write(status, read_err_row_reg_q[62], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank3_reg.mc_vmc_wl_num63_bank3.write(status, read_err_row_reg_q[63], UVM_FRONTDOOR);
        //}}}
        `else
                //{{{
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num0_part0_bank1.write(status, read_err_csl_part0_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num1_part0_bank1.write(status, read_err_csl_part0_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num0_part1_bank1.write(status, read_err_csl_part1_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank1_reg.mc_vmc_bl_num1_part1_bank1.write(status, read_err_csl_part1_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num0_part2_bank1.write(status, read_err_csl_part2_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num1_part2_bank1.write(status, read_err_csl_part2_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num0_part3_bank1.write(status, read_err_csl_part3_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank1_reg.mc_vmc_bl_num1_part3_bank1.write(status, read_err_csl_part3_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num0_part4_bank1.write(status, read_err_csl_part4_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num1_part4_bank1.write(status, read_err_csl_part4_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num0_part5_bank1.write(status, read_err_csl_part5_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank1_reg.mc_vmc_bl_num1_part5_bank1.write(status, read_err_csl_part5_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num0_part6_bank1.write(status, read_err_csl_part6_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num1_part6_bank1.write(status, read_err_csl_part6_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num0_part7_bank1.write(status, read_err_csl_part7_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank1_reg.mc_vmc_bl_num1_part7_bank1.write(status, read_err_csl_part7_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num0_part8_bank1.write(status, read_err_csl_part8_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num1_part8_bank1.write(status, read_err_csl_part8_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num0_part9_bank1.write(status, read_err_csl_part9_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank1_reg.mc_vmc_bl_num1_part9_bank1.write(status, read_err_csl_part9_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank1_reg.mc_vmc_wl_num0_bank1.write(status, read_err_row_reg_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank1_reg.mc_vmc_wl_num1_bank1.write(status, read_err_row_reg_q[1], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank1_reg.mc_vmc_wl_num2_bank1.write(status, read_err_row_reg_q[2], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank1_reg.mc_vmc_wl_num3_bank1.write(status, read_err_row_reg_q[3], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank1_reg.mc_vmc_wl_num4_bank1.write(status, read_err_row_reg_q[4], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank1_reg.mc_vmc_wl_num5_bank1.write(status, read_err_row_reg_q[5], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank1_reg.mc_vmc_wl_num6_bank1.write(status, read_err_row_reg_q[6], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank1_reg.mc_vmc_wl_num7_bank1.write(status, read_err_row_reg_q[7], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank1_reg.mc_vmc_wl_num8_bank1.write(status, read_err_row_reg_q[8], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank1_reg.mc_vmc_wl_num9_bank1.write(status, read_err_row_reg_q[9], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank1_reg.mc_vmc_wl_num10_bank1.write(status, read_err_row_reg_q[10], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank1_reg.mc_vmc_wl_num11_bank1.write(status, read_err_row_reg_q[11], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank1_reg.mc_vmc_wl_num12_bank1.write(status, read_err_row_reg_q[12], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank1_reg.mc_vmc_wl_num13_bank1.write(status, read_err_row_reg_q[13], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank1_reg.mc_vmc_wl_num14_bank1.write(status, read_err_row_reg_q[14], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank1_reg.mc_vmc_wl_num15_bank1.write(status, read_err_row_reg_q[15], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank1_reg.mc_vmc_wl_num16_bank1.write(status, read_err_row_reg_q[16], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank1_reg.mc_vmc_wl_num17_bank1.write(status, read_err_row_reg_q[17], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank1_reg.mc_vmc_wl_num18_bank1.write(status, read_err_row_reg_q[18], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank1_reg.mc_vmc_wl_num19_bank1.write(status, read_err_row_reg_q[19], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank1_reg.mc_vmc_wl_num20_bank1.write(status, read_err_row_reg_q[20], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank1_reg.mc_vmc_wl_num21_bank1.write(status, read_err_row_reg_q[21], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank1_reg.mc_vmc_wl_num22_bank1.write(status, read_err_row_reg_q[22], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank1_reg.mc_vmc_wl_num23_bank1.write(status, read_err_row_reg_q[23], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank1_reg.mc_vmc_wl_num24_bank1.write(status, read_err_row_reg_q[24], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank1_reg.mc_vmc_wl_num25_bank1.write(status, read_err_row_reg_q[25], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank1_reg.mc_vmc_wl_num26_bank1.write(status, read_err_row_reg_q[26], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank1_reg.mc_vmc_wl_num27_bank1.write(status, read_err_row_reg_q[27], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank1_reg.mc_vmc_wl_num28_bank1.write(status, read_err_row_reg_q[28], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank1_reg.mc_vmc_wl_num29_bank1.write(status, read_err_row_reg_q[29], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank1_reg.mc_vmc_wl_num30_bank1.write(status, read_err_row_reg_q[30], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank1_reg.mc_vmc_wl_num31_bank1.write(status, read_err_row_reg_q[31], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank1_reg.mc_vmc_wl_num32_bank1.write(status, read_err_row_reg_q[32], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank1_reg.mc_vmc_wl_num33_bank1.write(status, read_err_row_reg_q[33], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank1_reg.mc_vmc_wl_num34_bank1.write(status, read_err_row_reg_q[34], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank1_reg.mc_vmc_wl_num35_bank1.write(status, read_err_row_reg_q[35], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank1_reg.mc_vmc_wl_num36_bank1.write(status, read_err_row_reg_q[36], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank1_reg.mc_vmc_wl_num37_bank1.write(status, read_err_row_reg_q[37], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank1_reg.mc_vmc_wl_num38_bank1.write(status, read_err_row_reg_q[38], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank1_reg.mc_vmc_wl_num39_bank1.write(status, read_err_row_reg_q[39], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank1_reg.mc_vmc_wl_num40_bank1.write(status, read_err_row_reg_q[40], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank1_reg.mc_vmc_wl_num41_bank1.write(status, read_err_row_reg_q[41], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank1_reg.mc_vmc_wl_num42_bank1.write(status, read_err_row_reg_q[42], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank1_reg.mc_vmc_wl_num43_bank1.write(status, read_err_row_reg_q[43], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank1_reg.mc_vmc_wl_num44_bank1.write(status, read_err_row_reg_q[44], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank1_reg.mc_vmc_wl_num45_bank1.write(status, read_err_row_reg_q[45], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank1_reg.mc_vmc_wl_num46_bank1.write(status, read_err_row_reg_q[46], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank1_reg.mc_vmc_wl_num47_bank1.write(status, read_err_row_reg_q[47], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank1_reg.mc_vmc_wl_num48_bank1.write(status, read_err_row_reg_q[48], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank1_reg.mc_vmc_wl_num49_bank1.write(status, read_err_row_reg_q[49], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank1_reg.mc_vmc_wl_num50_bank1.write(status, read_err_row_reg_q[50], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank1_reg.mc_vmc_wl_num51_bank1.write(status, read_err_row_reg_q[51], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank1_reg.mc_vmc_wl_num52_bank1.write(status, read_err_row_reg_q[52], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank1_reg.mc_vmc_wl_num53_bank1.write(status, read_err_row_reg_q[53], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank1_reg.mc_vmc_wl_num54_bank1.write(status, read_err_row_reg_q[54], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank1_reg.mc_vmc_wl_num55_bank1.write(status, read_err_row_reg_q[55], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank1_reg.mc_vmc_wl_num56_bank1.write(status, read_err_row_reg_q[56], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank1_reg.mc_vmc_wl_num57_bank1.write(status, read_err_row_reg_q[57], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank1_reg.mc_vmc_wl_num58_bank1.write(status, read_err_row_reg_q[58], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank1_reg.mc_vmc_wl_num59_bank1.write(status, read_err_row_reg_q[59], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank1_reg.mc_vmc_wl_num60_bank1.write(status, read_err_row_reg_q[60], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank1_reg.mc_vmc_wl_num61_bank1.write(status, read_err_row_reg_q[61], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank1_reg.mc_vmc_wl_num62_bank1.write(status, read_err_row_reg_q[62], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank1_reg.mc_vmc_wl_num63_bank1.write(status, read_err_row_reg_q[63], UVM_FRONTDOOR);
        //}}}
            //{{{
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank2_reg.mc_vmc_bl_num0_part0_bank2.write(status, read_err_csl_part0_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank2_reg.mc_vmc_bl_num1_part0_bank2.write(status, read_err_csl_part0_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank2_reg.mc_vmc_bl_num0_part1_bank2.write(status, read_err_csl_part1_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank2_reg.mc_vmc_bl_num1_part1_bank2.write(status, read_err_csl_part1_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank2_reg.mc_vmc_bl_num0_part2_bank2.write(status, read_err_csl_part2_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank2_reg.mc_vmc_bl_num1_part2_bank2.write(status, read_err_csl_part2_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank2_reg.mc_vmc_bl_num0_part3_bank2.write(status, read_err_csl_part3_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_bank2_reg.mc_vmc_bl_num1_part3_bank2.write(status, read_err_csl_part3_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank2_reg.mc_vmc_bl_num0_part4_bank2.write(status, read_err_csl_part4_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank2_reg.mc_vmc_bl_num1_part4_bank2.write(status, read_err_csl_part4_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank2_reg.mc_vmc_bl_num0_part5_bank2.write(status, read_err_csl_part5_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_bank2_reg.mc_vmc_bl_num1_part5_bank2.write(status, read_err_csl_part5_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank2_reg.mc_vmc_bl_num0_part6_bank2.write(status, read_err_csl_part6_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank2_reg.mc_vmc_bl_num1_part6_bank2.write(status, read_err_csl_part6_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank2_reg.mc_vmc_bl_num0_part7_bank2.write(status, read_err_csl_part7_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_bank2_reg.mc_vmc_bl_num1_part7_bank2.write(status, read_err_csl_part7_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank2_reg.mc_vmc_bl_num0_part8_bank2.write(status, read_err_csl_part8_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank2_reg.mc_vmc_bl_num1_part8_bank2.write(status, read_err_csl_part8_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank2_reg.mc_vmc_bl_num0_part9_bank2.write(status, read_err_csl_part9_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_bank2_reg.mc_vmc_bl_num1_part9_bank2.write(status, read_err_csl_part9_q[1], UVM_FRONTDOOR);

            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank2_reg.mc_vmc_wl_num0_bank2.write(status, read_err_row_reg_q[0], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num0_1_bank2_reg.mc_vmc_wl_num1_bank2.write(status, read_err_row_reg_q[1], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank2_reg.mc_vmc_wl_num2_bank2.write(status, read_err_row_reg_q[2], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num2_3_bank2_reg.mc_vmc_wl_num3_bank2.write(status, read_err_row_reg_q[3], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank2_reg.mc_vmc_wl_num4_bank2.write(status, read_err_row_reg_q[4], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num4_5_bank2_reg.mc_vmc_wl_num5_bank2.write(status, read_err_row_reg_q[5], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank2_reg.mc_vmc_wl_num6_bank2.write(status, read_err_row_reg_q[6], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num6_7_bank2_reg.mc_vmc_wl_num7_bank2.write(status, read_err_row_reg_q[7], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank2_reg.mc_vmc_wl_num8_bank2.write(status, read_err_row_reg_q[8], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num8_9_bank2_reg.mc_vmc_wl_num9_bank2.write(status, read_err_row_reg_q[9], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank2_reg.mc_vmc_wl_num10_bank2.write(status, read_err_row_reg_q[10], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num10_11_bank2_reg.mc_vmc_wl_num11_bank2.write(status, read_err_row_reg_q[11], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank2_reg.mc_vmc_wl_num12_bank2.write(status, read_err_row_reg_q[12], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num12_13_bank2_reg.mc_vmc_wl_num13_bank2.write(status, read_err_row_reg_q[13], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank2_reg.mc_vmc_wl_num14_bank2.write(status, read_err_row_reg_q[14], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num14_15_bank2_reg.mc_vmc_wl_num15_bank2.write(status, read_err_row_reg_q[15], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank2_reg.mc_vmc_wl_num16_bank2.write(status, read_err_row_reg_q[16], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num16_17_bank2_reg.mc_vmc_wl_num17_bank2.write(status, read_err_row_reg_q[17], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank2_reg.mc_vmc_wl_num18_bank2.write(status, read_err_row_reg_q[18], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num18_19_bank2_reg.mc_vmc_wl_num19_bank2.write(status, read_err_row_reg_q[19], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank2_reg.mc_vmc_wl_num20_bank2.write(status, read_err_row_reg_q[20], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num20_21_bank2_reg.mc_vmc_wl_num21_bank2.write(status, read_err_row_reg_q[21], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank2_reg.mc_vmc_wl_num22_bank2.write(status, read_err_row_reg_q[22], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num22_23_bank2_reg.mc_vmc_wl_num23_bank2.write(status, read_err_row_reg_q[23], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank2_reg.mc_vmc_wl_num24_bank2.write(status, read_err_row_reg_q[24], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num24_25_bank2_reg.mc_vmc_wl_num25_bank2.write(status, read_err_row_reg_q[25], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank2_reg.mc_vmc_wl_num26_bank2.write(status, read_err_row_reg_q[26], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num26_27_bank2_reg.mc_vmc_wl_num27_bank2.write(status, read_err_row_reg_q[27], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank2_reg.mc_vmc_wl_num28_bank2.write(status, read_err_row_reg_q[28], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num28_29_bank2_reg.mc_vmc_wl_num29_bank2.write(status, read_err_row_reg_q[29], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank2_reg.mc_vmc_wl_num30_bank2.write(status, read_err_row_reg_q[30], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num30_31_bank2_reg.mc_vmc_wl_num31_bank2.write(status, read_err_row_reg_q[31], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank2_reg.mc_vmc_wl_num32_bank2.write(status, read_err_row_reg_q[32], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num32_33_bank2_reg.mc_vmc_wl_num33_bank2.write(status, read_err_row_reg_q[33], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank2_reg.mc_vmc_wl_num34_bank2.write(status, read_err_row_reg_q[34], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num34_35_bank2_reg.mc_vmc_wl_num35_bank2.write(status, read_err_row_reg_q[35], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank2_reg.mc_vmc_wl_num36_bank2.write(status, read_err_row_reg_q[36], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num36_37_bank2_reg.mc_vmc_wl_num37_bank2.write(status, read_err_row_reg_q[37], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank2_reg.mc_vmc_wl_num38_bank2.write(status, read_err_row_reg_q[38], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num38_39_bank2_reg.mc_vmc_wl_num39_bank2.write(status, read_err_row_reg_q[39], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank2_reg.mc_vmc_wl_num40_bank2.write(status, read_err_row_reg_q[40], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num40_41_bank2_reg.mc_vmc_wl_num41_bank2.write(status, read_err_row_reg_q[41], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank2_reg.mc_vmc_wl_num42_bank2.write(status, read_err_row_reg_q[42], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num42_43_bank2_reg.mc_vmc_wl_num43_bank2.write(status, read_err_row_reg_q[43], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank2_reg.mc_vmc_wl_num44_bank2.write(status, read_err_row_reg_q[44], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num44_45_bank2_reg.mc_vmc_wl_num45_bank2.write(status, read_err_row_reg_q[45], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank2_reg.mc_vmc_wl_num46_bank2.write(status, read_err_row_reg_q[46], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num46_47_bank2_reg.mc_vmc_wl_num47_bank2.write(status, read_err_row_reg_q[47], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank2_reg.mc_vmc_wl_num48_bank2.write(status, read_err_row_reg_q[48], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num48_49_bank2_reg.mc_vmc_wl_num49_bank2.write(status, read_err_row_reg_q[49], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank2_reg.mc_vmc_wl_num50_bank2.write(status, read_err_row_reg_q[50], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num50_51_bank2_reg.mc_vmc_wl_num51_bank2.write(status, read_err_row_reg_q[51], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank2_reg.mc_vmc_wl_num52_bank2.write(status, read_err_row_reg_q[52], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num52_53_bank2_reg.mc_vmc_wl_num53_bank2.write(status, read_err_row_reg_q[53], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank2_reg.mc_vmc_wl_num54_bank2.write(status, read_err_row_reg_q[54], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num54_55_bank2_reg.mc_vmc_wl_num55_bank2.write(status, read_err_row_reg_q[55], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank2_reg.mc_vmc_wl_num56_bank2.write(status, read_err_row_reg_q[56], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num56_57_bank2_reg.mc_vmc_wl_num57_bank2.write(status, read_err_row_reg_q[57], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank2_reg.mc_vmc_wl_num58_bank2.write(status, read_err_row_reg_q[58], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num58_59_bank2_reg.mc_vmc_wl_num59_bank2.write(status, read_err_row_reg_q[59], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank2_reg.mc_vmc_wl_num60_bank2.write(status, read_err_row_reg_q[60], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num60_61_bank2_reg.mc_vmc_wl_num61_bank2.write(status, read_err_row_reg_q[61], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank2_reg.mc_vmc_wl_num62_bank2.write(status, read_err_row_reg_q[62], UVM_FRONTDOOR);
            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_wl_num62_63_bank2_reg.mc_vmc_wl_num63_bank2.write(status, read_err_row_reg_q[63], UVM_FRONTDOOR);
        //}}}
        `endif
      
        //vmc enable
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_wl_vmc_en.write(status,1'b1, UVM_FRONTDOOR);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_bl_vmc_en.write(status,1'b1, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.read(status,r_data, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.write(status,r_data | 'b11000, UVM_FRONTDOOR);

        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_rescan_addr_range_sel.write(status, 1, UVM_FRONTDOOR);
        repeat(10) @(posedge m_tb_if.clk);


        for (int kk=0;kk<2;kk++) begin

            //rescan num
            assert(randomize(bist_rescan_num));
            m_tb_if.bist_rescan_num =   bist_rescan_num;
            `uvm_info(get_type_name(),$sformatf("bist_rescan_num is 'd%0d", bist_rescan_num),UVM_LOW)

            //-------------------- global_mc_rescan_start -----------------------
            `uvm_info(get_type_name(),"bist rescan start!",UVM_LOW)

            //clear exp varible
            err_rescan_total_bit_num0    =   0;
            err_rescan_total_bit_num1    =   0;
            err_rescan_total_bit_num2    =   0;
            err_rescan_total_bit_num3    =   0;
            exp_bist_rescan_success0     =   0;
            exp_bist_rescan_success1     =   0;
            exp_bist_rescan_success2     =   0;
            exp_bist_rescan_success3     =   0;

            @(posedge m_tb_if.pclk)
            m_tb_if.global_mc_rescan_start = 1'b1;

            @(posedge m_tb_if.pclk)
            m_tb_if.global_mc_rescan_start = 1'b0;

            fork:rescan_check
                begin
                    fork
                        begin   
                            repeat(4) @(posedge m_tb_if.pclk);
                            //check rescan reg clr
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank0_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank0.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank0.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank0.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            `ifdef TEST_1_SHOT_1
                            `elsif TEST_1_SHOT_2
                            //{{{
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank1.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //}}}
                            `elsif TEST_1_SHOT_3
                            //{{{
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank1.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //bank2
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank2_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank2.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank2.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank2.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //}}}
                            `elsif TEST_1_SHOT_4
                             //{{{
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank1.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //bank2
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank2_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank2.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank2.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank2.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //bank3
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank3_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank3.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank3.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank3.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //}}}
                            `else
                             //{{{
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank1.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //bank2
                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank2_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                            if (mc_bist_rescan_fail_num_reg!= 0)    `uvm_error(get_type_name(),"rescan start, fail num reg not clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank2.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                            if (bist_rescan_finish != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_finish nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank2.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                            if (bist_rescan_success_reg != 0)    `uvm_error(get_type_name(), "rescan start, bist_rescan_success_reg nor clear")

                            p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank2.read(status, rescan_round_result, UVM_FRONTDOOR);
                            if (rescan_round_result != 0)    `uvm_error(get_type_name(), "rescan start, rescan_round_result nor clear")
                            //}}}
                            `endif
                        end
                        //{{{
                        begin
                            bist_rescan_success = 1;        //set bist_rescan_success for check
                            @(posedge m_array_agent_if.gcas_wr[0]);
                            #1ps;
                            err_wr_data = m_array_agent_if.wdl;

                            if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                            end
                            else begin
                                if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                    `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                end
                            end
                            `uvm_info(get_type_name(),"force0 wait!",UVM_LOW)
                            while(1) begin
                                if(!($urandom_range(15000))) begin
                                    //not success
                                    bist_rescan_success = 0;

                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin
                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end
                                    loop_times = $urandom_range(1,272);
                                    for (int jj=0;jj< loop_times;jj++) begin
                                        assert(randomize(err_rescan_bit_index));
                                        err_rescan_bit_index_q.push_back(err_rescan_bit_index);
                                    end

                                    err_rescan_bit_index_q.sort();        //debug used
                                    err_rescan_bit_index_q = err_rescan_bit_index_q.unique();

                                    err_rescan_total_bit_num0 = err_rescan_total_bit_num0 + err_rescan_bit_index_q.size();
                                    `uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit num is %0d",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0, err_rescan_bit_index_q.size()),UVM_LOW)

                                    foreach(err_rescan_bit_index_q[i]) begin
                                        err_wr_data[err_rescan_bit_index_q[i]] = ~err_wr_data[err_rescan_bit_index_q[i]];
                                        //`uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit index is %0d",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0, err_rescan_bit_index_q[i]),UVM_LOW)
                                    end

                                    uvm_hdl_force("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl", err_wr_data);
                                    @(posedge m_tb_if.clk);
                                    #1ps;
                                    uvm_hdl_release("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl");
                                    err_rescan_bit_index_q.delete();
                                end
                                else begin
                                    @(posedge m_array_agent_if.gcas_wr);
                                    #1ps;
                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin
                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end
                                end
                            end
                        end
                        //}}}
                        //{{{
                        begin
                            bist_rescan_success = 1;        //set bist_rescan_success for check
                            @(posedge m_array_agent_if.gcas_wr[1]);
                            #1ps;
                            err_wr_data = m_array_agent_if.wdl;

                            if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                            end
                            else begin
                                if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                    `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                end
                            end
                            `uvm_info(get_type_name(),"force1 wait!",UVM_LOW)
                            while(1) begin
                                if(!($urandom_range(15000))) begin
                                    //not success
                                    bist_rescan_success = 0;

                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin
                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end
                                    loop_times = $urandom_range(1,272);
                                    for (int jj=0;jj< loop_times;jj++) begin
                                        assert(randomize(err_rescan_bit_index));
                                        err_rescan_bit_index_q.push_back(err_rescan_bit_index);
                                    end

                                    err_rescan_bit_index_q.sort();        //debug used
                                    err_rescan_bit_index_q = err_rescan_bit_index_q.unique();

                                    err_rescan_total_bit_num1 = err_rescan_total_bit_num1 + err_rescan_bit_index_q.size();
                                    `uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit num is %0d",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0, err_rescan_bit_index_q.size()),UVM_LOW)

                                    foreach(err_rescan_bit_index_q[i]) begin
                                        err_wr_data[err_rescan_bit_index_q[i]] = ~err_wr_data[err_rescan_bit_index_q[i]];
                                        //`uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit index is %0d",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0, err_rescan_bit_index_q[i]),UVM_LOW)
                                    end

                                    uvm_hdl_force("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl", err_wr_data);
                                    @(posedge m_tb_if.clk);
                                    #1ps;
                                    uvm_hdl_release("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl");
                                    err_rescan_bit_index_q.delete();
                                end
                                else begin
                                    @(posedge m_array_agent_if.gcas_wr);
                                    #1ps;
                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin
                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end
                                end
                            end
                        end
                        //}}}
                        //{{{
                        begin
                            bist_rescan_success = 1;        //set bist_rescan_success for check
                            @(posedge m_array_agent_if.gcas_wr[2]);
                            #1ps;
                            err_wr_data = m_array_agent_if.wdl;

                            if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                            end
                            else begin
                                if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                    `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                end
                            end
                            `uvm_info(get_type_name(),"force2 wait!",UVM_LOW)
                            while(1) begin
                                if(!($urandom_range(15000))) begin
                                    //not success
                                    bist_rescan_success = 0;

                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin
                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end
                                    loop_times = $urandom_range(1,272);
                                    for (int jj=0;jj< loop_times;jj++) begin
                                        assert(randomize(err_rescan_bit_index));
                                        err_rescan_bit_index_q.push_back(err_rescan_bit_index);
                                    end

                                    err_rescan_bit_index_q.sort();        //debug used
                                    err_rescan_bit_index_q = err_rescan_bit_index_q.unique();

                                    err_rescan_total_bit_num2 = err_rescan_total_bit_num2 + err_rescan_bit_index_q.size();
                                    `uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit num is %0d",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0, err_rescan_bit_index_q.size()),UVM_LOW)

                                    foreach(err_rescan_bit_index_q[i]) begin
                                        err_wr_data[err_rescan_bit_index_q[i]] = ~err_wr_data[err_rescan_bit_index_q[i]];
                                        //`uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit index is %0d",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0, err_rescan_bit_index_q[i]),UVM_LOW)
                                    end

                                    uvm_hdl_force("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl", err_wr_data);
                                    @(posedge m_tb_if.clk);
                                    #1ps;
                                    uvm_hdl_release("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl");
                                    err_rescan_bit_index_q.delete();
                                end
                                else begin
                                    @(posedge m_array_agent_if.gcas_wr);
                                    #1ps;
                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin
                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end
                                end
                            end
                        end
                        //}}}
                        //{{{
                        begin
                            bist_rescan_success = 1;        //set bist_rescan_success for check
                            @(posedge m_array_agent_if.gcas_wr[3]);
                            #1ps;
                            err_wr_data = m_array_agent_if.wdl;

                            if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                            end
                            else begin
                                if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                    `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                end
                            end
                            `uvm_info(get_type_name(),"force3 wait!",UVM_LOW)
                            while(1) begin
                                if(!($urandom_range(15000))) begin
                                    //not success
                                    bist_rescan_success = 0;

                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin
                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end
                                    loop_times = $urandom_range(1,272);
                                    for (int jj=0;jj< loop_times;jj++) begin
                                        assert(randomize(err_rescan_bit_index));
                                        err_rescan_bit_index_q.push_back(err_rescan_bit_index);
                                    end

                                    err_rescan_bit_index_q.sort();        //debug used
                                    err_rescan_bit_index_q = err_rescan_bit_index_q.unique();

                                    err_rescan_total_bit_num3 = err_rescan_total_bit_num3 + err_rescan_bit_index_q.size();
                                    `uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit num is %0d",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0, err_rescan_bit_index_q.size()),UVM_LOW)

                                    foreach(err_rescan_bit_index_q[i]) begin
                                        err_wr_data[err_rescan_bit_index_q[i]] = ~err_wr_data[err_rescan_bit_index_q[i]];
                                        //`uvm_info(get_type_name(),$sformatf("radd is %0h, cadd is %0h, err bit index is %0d",m_tb_if.gradd_array_0, m_tb_if.gcadd_array_0, err_rescan_bit_index_q[i]),UVM_LOW)
                                    end

                                    uvm_hdl_force("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl", err_wr_data);
                                    @(posedge m_tb_if.clk);
                                    #1ps;
                                    uvm_hdl_release("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.wdl");
                                    err_rescan_bit_index_q.delete();
                                end
                                else begin
                                    @(posedge m_array_agent_if.gcas_wr);
                                    #1ps;
                                    err_wr_data = m_array_agent_if.wdl;

                                    if(bist_wl_pattern_using_q.size()<pattern_using_index) begin
                                        `uvm_error(get_type_name(),$sformatf("pattern using index %0d >= wl pattern using %0d",pattern_using_index,bist_wl_pattern_using_q.size()))
                                    end
                                    else begin
                                        if(err_wr_data !== caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index)) begin
                                            `uvm_error(get_type_name(),$sformatf("wdl error, exp is %0h, act is %0h, pattern_using_index is %0h, row_using_index is %0h",caculate_gold_pattern_data(bist_wl_pattern_using_q[pattern_using_index],row_using_index),err_wr_data,pattern_using_index, row_using_index))
                                        end
                                    end
                                end
                            end
                        end
                        //}}}
                        begin
                            while(1) begin
                                @(one_rescan_finish0);
                                assert(randomize(err_rescan_mode));
                                rescan_round_result_q0.push_back(bist_rescan_success);
                                exp_bist_rescan_success0 = exp_bist_rescan_success0 | bist_rescan_success;
                                `uvm_info(get_type_name(),$sformatf("this turn rescan success is %0d, total success is %0d", bist_rescan_success, exp_bist_rescan_success0), UVM_LOW)
                                bist_rescan_success = 1;        //set bist_rescan_success for check
                            end
                        end
                        begin
                            while(1) begin
                                @(one_rescan_finish1);
                                assert(randomize(err_rescan_mode));
                                rescan_round_result_q1.push_back(bist_rescan_success);
                                exp_bist_rescan_success1 = exp_bist_rescan_success1 | bist_rescan_success;
                                `uvm_info(get_type_name(),$sformatf("this turn rescan success is %0d, total success is %0d", bist_rescan_success, exp_bist_rescan_success1), UVM_LOW)
                                bist_rescan_success = 1;        //set bist_rescan_success for check
                            end
                        end
                        begin
                            while(1) begin
                                @(one_rescan_finish2);
                                assert(randomize(err_rescan_mode));
                                rescan_round_result_q2.push_back(bist_rescan_success);
                                exp_bist_rescan_success2 = exp_bist_rescan_success2 | bist_rescan_success;
                                `uvm_info(get_type_name(),$sformatf("this turn rescan success is %0d, total success is %0d", bist_rescan_success, exp_bist_rescan_success2), UVM_LOW)
                                bist_rescan_success = 1;        //set bist_rescan_success for check
                            end
                        end
                        begin
                            while(1) begin
                                @(one_rescan_finish3);
                                assert(randomize(err_rescan_mode));
                                rescan_round_result_q3.push_back(bist_rescan_success);
                                exp_bist_rescan_success3 = exp_bist_rescan_success3 | bist_rescan_success;
                                `uvm_info(get_type_name(),$sformatf("this turn rescan success is %0d, total success is %0d", bist_rescan_success, exp_bist_rescan_success3), UVM_LOW)
                                bist_rescan_success = 1;        //set bist_rescan_success for check
                            end
                        end
                        begin
                            //-------- rescan num check ----------
                            m = 0;
                            repeat(`BANK_ADDR_WIDTH)begin
                            if(m==0)begin
                            //{{{
                            for(int i=0; i < bist_rescan_num; i++) begin
                                for(int j=0; j< bist_wl_scan_num ; j++) begin

                                    pattern_using_index = j;
                                    //write
                                    for (int II=0;II <BIST_WL_NUM-64;II++) begin
                                        row_using_index=II;
                                        for(int KK=0;KK < COL_NUM;KK++) begin
                                            @(negedge m_tb_if.gcas_wr_array_d0_0);

                                            //--------------------- wl vmc ----------------------
                                            for (int kkk=rescan_radd_check_vmc_add_num; kkk<64;kkk++) begin
                                                if (II >= read_err_row_reg_q[kkk]) begin
                                                    rescan_radd_check_vmc_add_num++;
                                                end
                                            end
                                            if(m_tb_if.gradd_array_0 != II + rescan_radd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II+rescan_radd_check_vmc_add_num, m_tb_if.gradd_array_0))

                                            //--------------------- csl vmc ----------------------
                                            if( (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM/10)) begin //part0 csl
                                                if(KK >= read_err_csl_part0_q[0] && KK < read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part0_q[0] && KK >= read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*2/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part1_q[0] && KK < read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part1_q[0] && KK >= read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*2/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*3/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part2_q[0] && KK < read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part2_q[0] && KK >= read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*3/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*4/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part3_q[0] && KK < read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part3_q[0] && KK >= read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*4/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*5/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part4_q[0] && KK < read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part4_q[0] && KK >= read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*5/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*6/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part5_q[0] && KK < read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part5_q[0] && KK >= read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*6/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*7/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part6_q[0] && KK < read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part6_q[0] && KK >= read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*7/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*8/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part7_q[0] && KK < read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part7_q[0] && KK >= read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*8/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*9/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part8_q[0] && KK < read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part8_q[0] && KK >= read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*9/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*10/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part9_q[0] && KK < read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part9_q[0] && KK >= read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end

                                            if(m_tb_if.gcadd_array_0 != KK + rescan_cadd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK + rescan_cadd_check_vmc_add_num, m_tb_if.gcadd_array_0))
                                        end
                                    end

                                    rescan_radd_check_vmc_add_num = 0;
                                    //read
                                    for (int II=0;II <BIST_WL_NUM-64;II++) begin
                                        for(int KK=0;KK < COL_NUM;KK++) begin
                                            @(negedge m_tb_if.gcas_rd_array_d0_0);

                                            //--------------------- wl vmc ----------------------
                                            for (int kkk=rescan_radd_check_vmc_add_num; kkk<64;kkk++) begin
                                                if (II >= read_err_row_reg_q[kkk]) begin
                                                    rescan_radd_check_vmc_add_num++;
                                                end
                                            end

                                            if(m_tb_if.gradd_array_0 != II + rescan_radd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II+rescan_radd_check_vmc_add_num, m_tb_if.gradd_array_0))
                                            //--------------------- csl vmc ----------------------
                                            if( (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM/10)) begin //part0 csl
                                                if(KK >= read_err_csl_part0_q[0] && KK < read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part0_q[0] && KK >= read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*2/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part1_q[0] && KK < read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part1_q[0] && KK >= read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*2/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*3/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part2_q[0] && KK < read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part2_q[0] && KK >= read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*3/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*4/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part3_q[0] && KK < read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part3_q[0] && KK >= read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*4/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*5/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part4_q[0] && KK < read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part4_q[0] && KK >= read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*5/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*6/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part5_q[0] && KK < read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part5_q[0] && KK >= read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*6/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*7/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part6_q[0] && KK < read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part6_q[0] && KK >= read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*7/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*8/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part7_q[0] && KK < read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part7_q[0] && KK >= read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*8/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*9/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part8_q[0] && KK < read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part8_q[0] && KK >= read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*9/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*10/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part9_q[0] && KK < read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part9_q[0] && KK >= read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end

                                            if(m_tb_if.gcadd_array_0 != KK + rescan_cadd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK + rescan_cadd_check_vmc_add_num, m_tb_if.gcadd_array_0))
                                        end
                                    end

                                    rescan_radd_check_vmc_add_num = 0;
                                end
                                repeat(4) @(posedge m_tb_if.clk);
                                -> one_rescan_finish0;
                            end
                            //}}}
                            end
                            if(m==1)begin
                            //{{{
                            for(int i=0; i < bist_rescan_num; i++) begin
                                for(int j=0; j< bist_wl_scan_num ; j++) begin

                                    pattern_using_index = j;
                                    //write
                                    for (int II=0;II <BIST_WL_NUM-64;II++) begin
                                        row_using_index=II;
                                        for(int KK=0;KK < COL_NUM;KK++) begin
                                            @(negedge m_tb_if.gcas_wr_array_d1_0);

                                            //--------------------- wl vmc ----------------------
                                            for (int kkk=rescan_radd_check_vmc_add_num; kkk<64;kkk++) begin
                                                if (II >= read_err_row_reg_q[kkk]) begin
                                                    rescan_radd_check_vmc_add_num++;
                                                end
                                            end
                                            if(m_tb_if.gradd_array_0 != II + rescan_radd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II+rescan_radd_check_vmc_add_num, m_tb_if.gradd_array_0))

                                            //--------------------- csl vmc ----------------------
                                            if( (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM/10)) begin //part0 csl
                                                if(KK >= read_err_csl_part0_q[0] && KK < read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part0_q[0] && KK >= read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*2/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part1_q[0] && KK < read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part1_q[0] && KK >= read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*2/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*3/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part2_q[0] && KK < read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part2_q[0] && KK >= read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*3/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*4/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part3_q[0] && KK < read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part3_q[0] && KK >= read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*4/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*5/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part4_q[0] && KK < read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part4_q[0] && KK >= read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*5/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*6/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part5_q[0] && KK < read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part5_q[0] && KK >= read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*6/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*7/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part6_q[0] && KK < read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part6_q[0] && KK >= read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*7/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*8/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part7_q[0] && KK < read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part7_q[0] && KK >= read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*8/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*9/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part8_q[0] && KK < read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part8_q[0] && KK >= read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*9/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*10/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part9_q[0] && KK < read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part9_q[0] && KK >= read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end

                                            if(m_tb_if.gcadd_array_0 != KK + rescan_cadd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK + rescan_cadd_check_vmc_add_num, m_tb_if.gcadd_array_0))
                                        end
                                    end

                                    rescan_radd_check_vmc_add_num = 0;
                                    //read
                                    for (int II=0;II <BIST_WL_NUM-64;II++) begin
                                        for(int KK=0;KK < COL_NUM;KK++) begin
                                            @(negedge m_tb_if.gcas_rd_array_d1_0);

                                            //--------------------- wl vmc ----------------------
                                            for (int kkk=rescan_radd_check_vmc_add_num; kkk<64;kkk++) begin
                                                if (II >= read_err_row_reg_q[kkk]) begin
                                                    rescan_radd_check_vmc_add_num++;
                                                end
                                            end

                                            if(m_tb_if.gradd_array_0 != II + rescan_radd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II+rescan_radd_check_vmc_add_num, m_tb_if.gradd_array_0))
                                            //--------------------- csl vmc ----------------------
                                            if( (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM/10)) begin //part0 csl
                                                if(KK >= read_err_csl_part0_q[0] && KK < read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part0_q[0] && KK >= read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*2/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part1_q[0] && KK < read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part1_q[0] && KK >= read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*2/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*3/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part2_q[0] && KK < read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part2_q[0] && KK >= read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*3/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*4/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part3_q[0] && KK < read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part3_q[0] && KK >= read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*4/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*5/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part4_q[0] && KK < read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part4_q[0] && KK >= read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*5/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*6/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part5_q[0] && KK < read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part5_q[0] && KK >= read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*6/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*7/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part6_q[0] && KK < read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part6_q[0] && KK >= read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*7/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*8/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part7_q[0] && KK < read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part7_q[0] && KK >= read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*8/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*9/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part8_q[0] && KK < read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part8_q[0] && KK >= read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*9/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*10/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part9_q[0] && KK < read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part9_q[0] && KK >= read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end

                                            if(m_tb_if.gcadd_array_0 != KK + rescan_cadd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK + rescan_cadd_check_vmc_add_num, m_tb_if.gcadd_array_0))
                                        end
                                    end

                                    rescan_radd_check_vmc_add_num = 0;
                                end
                                repeat(4) @(posedge m_tb_if.clk);
                                -> one_rescan_finish1;
                            end
                            //}}}
                            end
                            if(m==2)begin
                            //{{{
                            for(int i=0; i < bist_rescan_num; i++) begin
                                for(int j=0; j< bist_wl_scan_num ; j++) begin

                                    pattern_using_index = j;
                                    //write
                                    for (int II=0;II <BIST_WL_NUM-64;II++) begin
                                        row_using_index=II;
                                        for(int KK=0;KK < COL_NUM;KK++) begin
                                            @(negedge m_tb_if.gcas_wr_array_d2_0);

                                            //--------------------- wl vmc ----------------------
                                            for (int kkk=rescan_radd_check_vmc_add_num; kkk<64;kkk++) begin
                                                if (II >= read_err_row_reg_q[kkk]) begin
                                                    rescan_radd_check_vmc_add_num++;
                                                end
                                            end
                                            if(m_tb_if.gradd_array_0 != II + rescan_radd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II+rescan_radd_check_vmc_add_num, m_tb_if.gradd_array_0))

                                            //--------------------- csl vmc ----------------------
                                            if( (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM/10)) begin //part0 csl
                                                if(KK >= read_err_csl_part0_q[0] && KK < read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part0_q[0] && KK >= read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*2/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part1_q[0] && KK < read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part1_q[0] && KK >= read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*2/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*3/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part2_q[0] && KK < read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part2_q[0] && KK >= read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*3/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*4/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part3_q[0] && KK < read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part3_q[0] && KK >= read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*4/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*5/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part4_q[0] && KK < read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part4_q[0] && KK >= read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*5/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*6/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part5_q[0] && KK < read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part5_q[0] && KK >= read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*6/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*7/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part6_q[0] && KK < read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part6_q[0] && KK >= read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*7/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*8/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part7_q[0] && KK < read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part7_q[0] && KK >= read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*8/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*9/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part8_q[0] && KK < read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part8_q[0] && KK >= read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*9/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*10/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part9_q[0] && KK < read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part9_q[0] && KK >= read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end

                                            if(m_tb_if.gcadd_array_0 != KK + rescan_cadd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK + rescan_cadd_check_vmc_add_num, m_tb_if.gcadd_array_0))
                                        end
                                    end

                                    rescan_radd_check_vmc_add_num = 0;
                                    //read
                                    for (int II=0;II <BIST_WL_NUM-64;II++) begin
                                        for(int KK=0;KK < COL_NUM;KK++) begin
                                            @(negedge m_tb_if.gcas_rd_array_d2_0);

                                            //--------------------- wl vmc ----------------------
                                            for (int kkk=rescan_radd_check_vmc_add_num; kkk<64;kkk++) begin
                                                if (II >= read_err_row_reg_q[kkk]) begin
                                                    rescan_radd_check_vmc_add_num++;
                                                end
                                            end

                                            if(m_tb_if.gradd_array_0 != II + rescan_radd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II+rescan_radd_check_vmc_add_num, m_tb_if.gradd_array_0))
                                            //--------------------- csl vmc ----------------------
                                            if( (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM/10)) begin //part0 csl
                                                if(KK >= read_err_csl_part0_q[0] && KK < read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part0_q[0] && KK >= read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*2/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part1_q[0] && KK < read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part1_q[0] && KK >= read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*2/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*3/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part2_q[0] && KK < read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part2_q[0] && KK >= read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*3/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*4/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part3_q[0] && KK < read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part3_q[0] && KK >= read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*4/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*5/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part4_q[0] && KK < read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part4_q[0] && KK >= read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*5/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*6/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part5_q[0] && KK < read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part5_q[0] && KK >= read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*6/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*7/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part6_q[0] && KK < read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part6_q[0] && KK >= read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*7/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*8/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part7_q[0] && KK < read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part7_q[0] && KK >= read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*8/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*9/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part8_q[0] && KK < read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part8_q[0] && KK >= read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*9/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*10/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part9_q[0] && KK < read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part9_q[0] && KK >= read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end

                                            if(m_tb_if.gcadd_array_0 != KK + rescan_cadd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK + rescan_cadd_check_vmc_add_num, m_tb_if.gcadd_array_0))
                                        end
                                    end

                                    rescan_radd_check_vmc_add_num = 0;
                                end
                                repeat(4) @(posedge m_tb_if.clk);
                                -> one_rescan_finish2;
                            end
                            //}}}
                            end
                            if(m==3)begin
                            //{{{
                            for(int i=0; i < bist_rescan_num; i++) begin
                                for(int j=0; j< bist_wl_scan_num ; j++) begin

                                    pattern_using_index = j;
                                    //write
                                    for (int II=0;II <BIST_WL_NUM-64;II++) begin
                                        row_using_index=II;
                                        for(int KK=0;KK < COL_NUM;KK++) begin
                                            @(negedge m_tb_if.gcas_wr_array_d3_0);

                                            //--------------------- wl vmc ----------------------
                                            for (int kkk=rescan_radd_check_vmc_add_num; kkk<64;kkk++) begin
                                                if (II >= read_err_row_reg_q[kkk]) begin
                                                    rescan_radd_check_vmc_add_num++;
                                                end
                                            end
                                            if(m_tb_if.gradd_array_0 != II + rescan_radd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II+rescan_radd_check_vmc_add_num, m_tb_if.gradd_array_0))

                                            //--------------------- csl vmc ----------------------
                                            if( (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM/10)) begin //part0 csl
                                                if(KK >= read_err_csl_part0_q[0] && KK < read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part0_q[0] && KK >= read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*2/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part1_q[0] && KK < read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part1_q[0] && KK >= read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*2/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*3/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part2_q[0] && KK < read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part2_q[0] && KK >= read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*3/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*4/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part3_q[0] && KK < read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part3_q[0] && KK >= read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*4/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*5/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part4_q[0] && KK < read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part4_q[0] && KK >= read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*5/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*6/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part5_q[0] && KK < read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part5_q[0] && KK >= read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*6/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*7/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part6_q[0] && KK < read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part6_q[0] && KK >= read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*7/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*8/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part7_q[0] && KK < read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part7_q[0] && KK >= read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*8/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*9/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part8_q[0] && KK < read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part8_q[0] && KK >= read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*9/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*10/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part9_q[0] && KK < read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part9_q[0] && KK >= read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end

                                            if(m_tb_if.gcadd_array_0 != KK + rescan_cadd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK + rescan_cadd_check_vmc_add_num, m_tb_if.gcadd_array_0))
                                        end
                                    end

                                    rescan_radd_check_vmc_add_num = 0;
                                    //read
                                    for (int II=0;II <BIST_WL_NUM-64;II++) begin
                                        for(int KK=0;KK < COL_NUM;KK++) begin
                                            @(negedge m_tb_if.gcas_rd_array_d3_0);

                                            //--------------------- wl vmc ----------------------
                                            for (int kkk=rescan_radd_check_vmc_add_num; kkk<64;kkk++) begin
                                                if (II >= read_err_row_reg_q[kkk]) begin
                                                    rescan_radd_check_vmc_add_num++;
                                                end
                                            end

                                            if(m_tb_if.gradd_array_0 != II + rescan_radd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", II+rescan_radd_check_vmc_add_num, m_tb_if.gradd_array_0))
                                            //--------------------- csl vmc ----------------------
                                            if( (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM/10)) begin //part0 csl
                                                if(KK >= read_err_csl_part0_q[0] && KK < read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part0_q[0] && KK >= read_err_csl_part0_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*2/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part1_q[0] && KK < read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part1_q[0] && KK >= read_err_csl_part1_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*2/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*3/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part2_q[0] && KK < read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part2_q[0] && KK >= read_err_csl_part2_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*3/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*4/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part3_q[0] && KK < read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part3_q[0] && KK >= read_err_csl_part3_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*4/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*5/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part4_q[0] && KK < read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part4_q[0] && KK >= read_err_csl_part4_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*5/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*6/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part5_q[0] && KK < read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part5_q[0] && KK >= read_err_csl_part5_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*6/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*7/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part6_q[0] && KK < read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part6_q[0] && KK >= read_err_csl_part6_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*7/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*8/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part7_q[0] && KK < read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part7_q[0] && KK >= read_err_csl_part7_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*8/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*9/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part8_q[0] && KK < read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part8_q[0] && KK >= read_err_csl_part8_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end
                                            else if( (II + rescan_radd_check_vmc_add_num) >= (BIST_WL_NUM*9/10) && (II + rescan_radd_check_vmc_add_num) < (BIST_WL_NUM*10/10)) begin //part1 csl
                                                if(KK >= read_err_csl_part9_q[0] && KK < read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd1;
                                                end
                                                else if (KK >= read_err_csl_part9_q[0] && KK >= read_err_csl_part9_q[1]) begin
                                                    rescan_cadd_check_vmc_add_num   =   'd2;
                                                end
                                                else begin
                                                    rescan_cadd_check_vmc_add_num   =   'd0;
                                                end
                                            end

                                            if(m_tb_if.gcadd_array_0 != KK + rescan_cadd_check_vmc_add_num)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", KK + rescan_cadd_check_vmc_add_num, m_tb_if.gcadd_array_0))
                                        end
                                    end

                                    rescan_radd_check_vmc_add_num = 0;
                                end
                                repeat(4) @(posedge m_tb_if.clk);
                                -> one_rescan_finish3;
                            end
                            //}}}
                            end
                            m++;
                            end
                            repeat(3) @(posedge m_tb_if.clk);
                            exp_bist_rescan_finish = 1;
                        end
                    join
                end
                do begin
                    repeat(1000) @(posedge m_tb_if.clk);
                    `ifdef TEST_1_SHOT_1
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank0.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                    `elsif TEST_1_SHOT_2
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank1.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                    `elsif TEST_1_SHOT_3
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank2.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                    `elsif TEST_1_SHOT_4
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank3.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                    `else
                        p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank2.read(status, bist_rescan_finish, UVM_FRONTDOOR);
                    `endif
                    if(bist_rescan_finish !== exp_bist_rescan_finish) begin
                        `uvm_error("rescan check", $sformatf("exp rescan finish not match, exp is %0b, act is %0b",exp_bist_rescan_finish,bist_rescan_finish))
                    end
                    if(exp_bist_rescan_finish) begin 
                        repeat(100) @(posedge m_tb_if.clk);
                        disable rescan_check;
                    end
                end while(1); 
                while(1) begin
                    `ifdef TEST_1_SHOT_1
                        @(posedge m_tb_if.gcas_rd_array_d0_0);
                        @(negedge m_tb_if.gcas_rd_array_d0_0);
                    `elsif TEST_1_SHOT_2
                        @(posedge m_tb_if.gcas_rd_array_d1_0);
                        @(negedge m_tb_if.gcas_rd_array_d1_0);
                    `elsif TEST_1_SHOT_3
                        @(posedge m_tb_if.gcas_rd_array_d2_0);
                        @(negedge m_tb_if.gcas_rd_array_d2_0);
                    `elsif TEST_1_SHOT_4
                        @(posedge m_tb_if.gcas_rd_array_d3_0);
                        @(negedge m_tb_if.gcas_rd_array_d3_0);
                    `else
                        @(posedge m_tb_if.gcas_rd_array_d2_0);
                        @(negedge m_tb_if.gcas_rd_array_d2_0);
                    `endif
                    rescan_read_cnt = rescan_read_cnt + 1'b1;
                end
                while(1) begin
                    `ifdef TEST_1_SHOT_1
                        @(posedge m_tb_if.gcas_wr_array_d0_0);
                        @(negedge m_tb_if.gcas_wr_array_d0_0);
                    `elsif TEST_1_SHOT_2
                        @(posedge m_tb_if.gcas_wr_array_d1_0);
                        @(negedge m_tb_if.gcas_wr_array_d1_0);
                    `elsif TEST_1_SHOT_3
                        @(posedge m_tb_if.gcas_wr_array_d2_0);
                        @(negedge m_tb_if.gcas_wr_array_d2_0);
                    `elsif TEST_1_SHOT_4
                        @(posedge m_tb_if.gcas_wr_array_d3_0);
                        @(negedge m_tb_if.gcas_wr_array_d3_0);
                    `else
                        @(posedge m_tb_if.gcas_wr_array_d2_0);
                        @(negedge m_tb_if.gcas_wr_array_d2_0);
                    `endif
                    rescan_write_cnt = rescan_write_cnt + 1'b1;
                end
            join

            if (!m_tb_if.bist_rescan_finish)
                `uvm_error(get_type_name(),"interface bist_rescan_finish is not 1")

            //check read op num and write op num
            if (rescan_read_cnt != (BIST_WL_NUM-64)*COL_NUM*bist_rescan_num*bist_wl_scan_num)
                `uvm_error(get_type_name(),$sformatf("rescan read_cnt mismatch, exp is %0d,act is %0d",BIST_WL_NUM*COL_ALL_NUM*bist_rescan_num*bist_wl_scan_num, rescan_read_cnt))
            else 
                `uvm_info(get_type_name(),"read cnt check pass",UVM_LOW)
            if (rescan_write_cnt != (BIST_WL_NUM-64)*COL_NUM*bist_rescan_num*bist_wl_scan_num)
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

                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank0_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num0 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num0)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num0, mc_bist_rescan_fail_num_reg))
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank0.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success0 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success0, bist_rescan_success_reg))

                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank0.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q0[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q0[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q0[i], rescan_round_result[i]))
                end
                //}}}
            `ifdef TEST_1_SHOT_1            
            `elsif TEST_1_SHOT_2
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num1 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num1)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num1, mc_bist_rescan_fail_num_reg))
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success1 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success1, bist_rescan_success_reg))

                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q1[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q1[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q1[i], rescan_round_result[i]))
                end
                //}}}
            `elsif TEST_1_SHOT_3 
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num1 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num1)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num1, mc_bist_rescan_fail_num_reg))
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success1 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success1, bist_rescan_success_reg))

                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q1[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q1[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q1[i], rescan_round_result[i]))
                end
                //}}}
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank2_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num2 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num2)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num2, mc_bist_rescan_fail_num_reg))
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank2.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success2 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success2, bist_rescan_success_reg))

                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank2.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q2[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q2[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q2[i], rescan_round_result[i]))
                end
                //}}}
            `elsif TEST_1_SHOT_4    
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num1 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num1)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num1, mc_bist_rescan_fail_num_reg))
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success1 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success1, bist_rescan_success_reg))

                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q1[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q1[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q1[i], rescan_round_result[i]))
                end
                //}}}
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank2_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num2 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num2)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num2, mc_bist_rescan_fail_num_reg))
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank2.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success2 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success2, bist_rescan_success_reg))

                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank2.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q2[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q2[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q2[i], rescan_round_result[i]))
                end
                //}}}
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank3_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num3 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num3)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num3, mc_bist_rescan_fail_num_reg))
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank3.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success3 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success3, bist_rescan_success_reg))

                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank3.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q3[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q3[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q3[i], rescan_round_result[i]))
                end
                //}}}
            `else
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank1_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num1 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num1)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num1, mc_bist_rescan_fail_num_reg))
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank1.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success1 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success1, bist_rescan_success_reg))

                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_1_reg.rescan_round_result_bank1.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q1[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q1[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q1[i], rescan_round_result[i]))
                end
                //}}}
                //{{{
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_rescan_fail_num_bank2_reg.read(status, mc_bist_rescan_fail_num_reg, UVM_FRONTDOOR);
                if (err_rescan_total_bit_num2 > 20'hf_ffff) begin
                    if(mc_bist_rescan_fail_num_reg != 20'hf_ffff)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is 20'hf_ffff, act is %0d", mc_bist_rescan_fail_num_reg))
                end
                else begin
                    if (mc_bist_rescan_fail_num_reg != err_rescan_total_bit_num2)
                        `uvm_error(get_type_name(), $sformatf("rescan fail num mismatch, exp is %0d, act is %0d", err_rescan_total_bit_num2, mc_bist_rescan_fail_num_reg))
                end
                //check bist_rescan_success
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_success_bank2.read(status, bist_rescan_success_reg, UVM_FRONTDOOR);
                if(exp_bist_rescan_success2 != bist_rescan_success_reg)  `uvm_error(get_type_name(), $sformatf("bist_rescan_success_reg mismatch, exp is %0d, act is %0d", exp_bist_rescan_success2, bist_rescan_success_reg))

                //check rescan_round_result
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_round_result_2_reg.rescan_round_result_bank2.read(status, rescan_round_result, UVM_FRONTDOOR);
                foreach(rescan_round_result_q2[i]) begin
                    if (rescan_round_result[i] != rescan_round_result_q2[i])
                        `uvm_error(get_type_name(),$sformatf("round %0d, success compare error, exp is %0b, act is %0b", i, rescan_round_result_q2[i], rescan_round_result[i]))
                end
                //}}}
            `endif
            rescan_round_result_q0.delete();
            rescan_round_result_q1.delete();
            rescan_round_result_q2.delete();
            rescan_round_result_q3.delete();
            exp_bist_rescan_finish = 0;
        end
        m_tb_if.bist_rescan_num =   0;
    end

    //check
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_finish_clr_reg.write(status, 1'b1, UVM_FRONTDOOR);
    repeat(50) @(posedge m_tb_if.clk);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.bist_rescan_finish_bank0.read(status, bist_rescan_finish, UVM_FRONTDOOR);
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
            bank_sel            == rand_num;
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
            m_frame_cfg.bank_sel            ==  rand_num;
            m_frame_cfg.rw_rand_en          ==  1;
        });
        send_one_frame(m_frame_cfg);
    end

    //for toggle cov
    //bist_finish_mask
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_mask.write(status,bist_finish_mask,UVM_FRONTDOOR);
    `uvm_info(get_type_name(),$sformatf("bist_finish_mask is %0b", ~bist_finish_mask),UVM_LOW)

    //bist_rescan_mask
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.rescan_finish_mask_reg.rescan_finish_mask.write(status,bist_rescan_mask,UVM_FRONTDOOR);
    `uvm_info(get_type_name(),$sformatf("bist_rescan_mask is %0b", ~bist_rescan_mask),UVM_LOW)


    #100000ns;

endtask:body

task mc_bist_rescan_vseq::gen_pattern_using(input bit [67:0] sel_param, output bit [`PATTERN_WIDTH-1:0] using_pattern_q[$]);

    bit [`PATTERN_WIDTH-1:0]   bist_pattern_local[68];

    bist_pattern_local[0]  = 32'h0000_0000;
    bist_pattern_local[1]  = 32'hFFFF_FFFF;
    bist_pattern_local[2]  = 32'h5555_5555;
    bist_pattern_local[3]  = 32'hAAAA_AAAA;
    bist_pattern_local[4]  = 32'h00FF_00FF;
    bist_pattern_local[5]  = 32'hFF00_FF00;
    bist_pattern_local[6]  = 32'h55AA_55AA;
    bist_pattern_local[7]  = 32'hAA55_AA55;
    bist_pattern_local[8]  = 32'h0055_0055;
    bist_pattern_local[9]  = 32'h00AA_00AA;
    bist_pattern_local[10]  = 32'h5500_5500;
    bist_pattern_local[11]  = 32'hAA00_AA00;
    bist_pattern_local[12]  = 32'h0000_FFFF;
    bist_pattern_local[13]  = 32'hFFFF_0000;
    bist_pattern_local[14]  = 32'h00FF_FF00;
    bist_pattern_local[15]  = 32'hFF00_00FF;
    bist_pattern_local[16]  = 32'h3333_3333;
    bist_pattern_local[17]  = 32'hCCCC_CCCC;
    bist_pattern_local[18]  = 32'h9999_9999;
    bist_pattern_local[19]  = 32'h6666_6666;
    bist_pattern_local[20]  = 32'h33CC_33CC;
    bist_pattern_local[21]  = 32'hCC33_CC33;
    bist_pattern_local[22]  = 32'h6699_6699;
    bist_pattern_local[23]  = 32'h9966_9966;
    bist_pattern_local[24]  = 32'h1212_1212;
    bist_pattern_local[25]  = 32'h2424_2424;
    bist_pattern_local[26]  = 32'h4848_4848;
    bist_pattern_local[27]  = 32'h8181_8181;
    bist_pattern_local[28]  = 32'hEDED_EDED;
    bist_pattern_local[29]  = 32'hDBDB_DBDB;
    bist_pattern_local[30]  = 32'hB7B7_B7B7;
    bist_pattern_local[31]  = 32'h7E7E_7E7E;
    bist_pattern_local[32]  = 32'hED12_ED12;
    bist_pattern_local[33]  = 32'hDB24_DB24;
    bist_pattern_local[34]  = 32'hB748_B748;
    bist_pattern_local[35]  = 32'h7E81_7E81;
    bist_pattern_local[36]  = 32'h12ED_12ED;
    bist_pattern_local[37]  = 32'h24DB_24DB;
    bist_pattern_local[38]  = 32'h48B7_48B7;
    bist_pattern_local[39]  = 32'h817E_817E;
    bist_pattern_local[40]  = 32'h0012_0012;
    bist_pattern_local[41]  = 32'h0024_0024;
    bist_pattern_local[42]  = 32'h0048_0048;
    bist_pattern_local[43]  = 32'h0081_0081;
    bist_pattern_local[44]  = 32'h1200_1200;
    bist_pattern_local[45]  = 32'h2400_2400;
    bist_pattern_local[46]  = 32'h4800_4800;
    bist_pattern_local[47]  = 32'h8100_8100;
    bist_pattern_local[48]  = 32'h0101_0101;
    bist_pattern_local[49]  = 32'h0202_0202;
    bist_pattern_local[50]  = 32'h0404_0404;
    bist_pattern_local[51]  = 32'h0808_0808;
    bist_pattern_local[52]  = 32'h1010_1010;
    bist_pattern_local[53]  = 32'h2020_2020;
    bist_pattern_local[54]  = 32'h4040_4040;
    bist_pattern_local[55]  = 32'h8080_8080;
    bist_pattern_local[56]  = 32'hFEFE_FEFE;
    bist_pattern_local[57]  = 32'hFDFD_FDFD;
    bist_pattern_local[58]  = 32'hFBFB_FBFB;
    bist_pattern_local[59]  = 32'hF7F7_F7F7;
    bist_pattern_local[60]  = 32'hEFEF_EFEF;
    bist_pattern_local[61]  = 32'hDFDF_DFDF;
    bist_pattern_local[62]  = 32'hBFBF_BFBF;
    bist_pattern_local[63]  = 32'h7F7F_7F7F;
    bist_pattern_local[64]  = bist_pattern[0];
    bist_pattern_local[65]  = bist_pattern[1];
    bist_pattern_local[66]  = bist_pattern[2];
    bist_pattern_local[67]  = bist_pattern[3];

    for(int i=0;i<68;i++) begin
        if(sel_param[i]) begin
            using_pattern_q.push_back(bist_pattern_local[i]);
        end
    end

    if (using_pattern_q.size() != $countones(sel_param)) begin
        `uvm_error("gen using_pattern_q", $sformatf("exp size of pattern is %0d, but gen size is %0d", $countones(sel_param), using_pattern_q.size()))
    end


endtask:gen_pattern_using

task mc_bist_rescan_vseq::gen_err_csl(input bit [3:0] part, output bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$]);

    bit [`ROW_ADDR_WIDTH-1:0]   err_row_in_err_csl_q[$];

    assert(randomize(err_csl_num_rand));

    //gen this part err csl
    case(err_csl_num_rand[part])
        0: begin    //this part no csl >= th
            for(int i=0;i<COL_ALL_NUM;i++)begin
                err_csl_partx_q.push_back(ERR_CSL_DEFAULT_VALUE);
            end
        end
        1: begin    //1 csl >= th
            assert(randomize(cadd_array) with {
                cadd_array dist {0:/20,(COL_ALL_NUM-1):/20, [0:COL_ALL_NUM-1]:/60};
            });
            err_csl_partx_q.push_back(cadd_array);
            for(int i=0;i<COL_ALL_NUM-1;i++)begin
                err_csl_partx_q.push_back(ERR_CSL_DEFAULT_VALUE);
            end
        end
        2: begin    //2 csl >= th
            assert(randomize(cadd_array) with {
                cadd_array dist {0:/20,(COL_ALL_NUM-1):/20, [0:COL_ALL_NUM-1]:/60};
            });
            err_csl_partx_q.push_back(cadd_array);
            assert(randomize(cadd_array) with {
                cadd_array dist {0:/20,(COL_ALL_NUM-1):/20, [0:COL_ALL_NUM-1]:/60};
                cadd_array != err_csl_partx_q[0];
            });
            err_csl_partx_q.push_back(cadd_array);
            for(int i=0;i<COL_ALL_NUM-2;i++)begin
                err_csl_partx_q.push_back(ERR_CSL_DEFAULT_VALUE);
            end
        end
        3: begin    //3 csl >= th
            exp_csl_fail[part] = 1;
            assert(randomize(cadd_array) with {
                cadd_array dist {0:/20,(COL_ALL_NUM-1):/20, [0:COL_ALL_NUM-1]:/60};
            });
            err_csl_partx_q.push_back(cadd_array);
            assert(randomize(cadd_array) with {
                cadd_array dist {0:/20,(COL_ALL_NUM-1):/20, [0:COL_ALL_NUM-1]:/60};
                cadd_array != err_csl_partx_q[0];
            });
            err_csl_partx_q.push_back(cadd_array);
            assert(randomize(cadd_array) with {
                cadd_array dist {0:/20,(COL_ALL_NUM-1):/20, [0:COL_ALL_NUM-1]:/60};
                cadd_array != err_csl_partx_q[0];
                cadd_array != err_csl_partx_q[1];
            });
            err_csl_partx_q.push_back(cadd_array);
            for(int i=0;i<COL_ALL_NUM-3;i++)begin
                err_csl_partx_q.push_back(ERR_CSL_DEFAULT_VALUE);
            end
        end

        default: begin
            `uvm_error(get_type_name(), $sformatf("gen csl err, num of err csl not in options! is %0d", err_csl_num_rand[part]))
        end
    endcase
    err_csl_partx_q.sort();

    //gen err row in err csl 
    for (int i=0;i<COL_ALL_NUM;i++) begin
        if(err_csl_partx_q[i] == ERR_CSL_DEFAULT_VALUE) begin
            break;
        end

        else begin
            
            assert(randomize(num_csl_err_inject) with {
                //num_csl_err_inject >= csl_err_threshold;
                //num_csl_err_inject == csl_err_threshold;
                num_csl_err_inject dist {csl_err_threshold:/50, [csl_err_threshold:'d30]:/50};
            });
            //`uvm_info("gen_err_csl", $sformatf("part is %0d, col %0h, csl err num is %0d",part, err_csl_partx_q[i], num_csl_err_inject),UVM_LOW)
            do begin    //to ensure each part can generate enough err row addr
                assert(randomize(radd_up_down));
                err_row_in_err_csl_q.push_back(radd_up_down[part]);
                err_row_in_err_csl_q = err_row_in_err_csl_q.unique();
            end while(err_row_in_err_csl_q.size() < num_csl_err_inject);

        end

        //record err addr
        foreach(err_row_in_err_csl_q[k]) begin  
            err_addr[err_row_in_err_csl_q[k]][err_csl_partx_q[i]] = 'b1;
        end

        //clear i col list
        err_row_in_err_csl_q.delete();
    end



endtask:gen_err_csl

task mc_bist_rescan_vseq::gen_err_row(input bit[3:0] part, input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$]);

    //bit [1:0]   scan_redundant_csl;         //0: this part do not scan_redundant_csl; 1:scan 1 redundant csl; 2:scan 2 redundant csl
    bit [`ROW_ADDR_WIDTH-1:0]   err_row_partx_q[$];

    if (err_csl_partx_q[0] >= COL_ALL_NUM-2) begin
        scan_redundant_csl[part] = 'd0;
    end
    else if (err_csl_partx_q[1] >= COL_ALL_NUM-1) begin
        scan_redundant_csl[part] = 'd1;
    end
    else begin
        scan_redundant_csl[part] = 'd2;
    end

    case(scan_redundant_csl[part])
        'd0: begin
            for (int i=0;i<COL_ALL_NUM-2;i++) begin
                assert(randomize(num_csl_err_inject) with {
                    num_csl_err_inject < csl_err_threshold;
                    num_csl_err_inject dist {0:/70, [1:csl_err_threshold]:/30};
                });
                //to ensure each part can generate enough err row addr
                //`uvm_info("gen_err_row", $sformatf("part is %0d, col %0h, csl err num is %0d",part,i, num_csl_err_inject),UVM_LOW)
                while(err_row_partx_q.size() < num_csl_err_inject) begin
                    if(wl_success_mode && (err_wl_addr_q.size() >=wl_success_num)) begin
                        break;
                    end

                    assert(randomize(radd_up_down));

                    //this part
                    err_row_partx_q.push_back(radd_up_down[part]);
                    err_row_partx_q = err_row_partx_q.unique();

                    //all wl
                    err_wl_addr_q.push_back(radd_up_down[part]);
                    err_wl_addr_q = err_wl_addr_q.unique();
                end

                //record err addr
                foreach(err_row_partx_q[k]) begin  
                    err_addr[err_row_partx_q[k]][i] = 'b1;
                end

                //clear i col list
                err_row_partx_q.delete();
            end
        end
        'd1: begin
            for (int i=0;i<COL_ALL_NUM-1;i++) begin
                if (i == err_csl_partx_q[0]) begin
                    continue;
                end

                assert(randomize(num_csl_err_inject) with {
                    num_csl_err_inject < csl_err_threshold;
                    num_csl_err_inject dist {0:/70, [1:csl_err_threshold]:/30};
                });
                //to ensure each part can generate enough err row addr
                //`uvm_info("gen_err_row", $sformatf("part is %0d, col %0h, csl err num is %0d",part,i, num_csl_err_inject),UVM_LOW)
                while(err_row_partx_q.size() < num_csl_err_inject) begin
                    if(wl_success_mode && (err_wl_addr_q.size() >=wl_success_num)) begin
                        break;
                    end

                    assert(randomize(radd_up_down));

                    //this part
                    err_row_partx_q.push_back(radd_up_down[part]);
                    err_row_partx_q = err_row_partx_q.unique();

                    //all wl
                    err_wl_addr_q.push_back(radd_up_down[part]);
                    err_wl_addr_q = err_wl_addr_q.unique();
                end

                //record err addr
                foreach(err_row_partx_q[k]) begin  
                    err_addr[err_row_partx_q[k]][i] = 'b1;
                end

                //clear i col list
                err_row_partx_q.delete();
            end
        end
        'd2: begin
            for (int i=0;i<COL_ALL_NUM;i++) begin
                if (i == err_csl_partx_q[0] || i == err_csl_partx_q[1]) begin
                    continue;
                end
                assert(randomize(num_csl_err_inject) with {
                    num_csl_err_inject < csl_err_threshold;
                    num_csl_err_inject dist {0:/70, [1:csl_err_threshold]:/30};
                });
                //to ensure each part can generate enough err row addr
                //`uvm_info("gen_err_row", $sformatf("part is %0d, col %0h, csl err num is %0d",part,i, num_csl_err_inject),UVM_LOW)
                while(err_row_partx_q.size() < num_csl_err_inject) begin
                    if(wl_success_mode && (err_wl_addr_q.size() >=wl_success_num)) begin
                        break;
                    end

                    assert(randomize(radd_up_down));

                    //this part
                    err_row_partx_q.push_back(radd_up_down[part]);
                    err_row_partx_q = err_row_partx_q.unique();

                    //all wl
                    err_wl_addr_q.push_back(radd_up_down[part]);
                    err_wl_addr_q = err_wl_addr_q.unique();
                end

                //record err addr
                foreach(err_row_partx_q[k]) begin  
                    err_addr[err_row_partx_q[k]][i] = 'b1;
                end

                //clear i col list
                err_row_partx_q.delete();
            end
        end
        default: begin
            `uvm_error(get_type_name(), $sformatf("gen row err, scan_redundant_csl not in options! is %0d", scan_redundant_csl[part]))
        end
    endcase

endtask:gen_err_row

task mc_bist_rescan_vseq::gen_bist_error(input bit [`PATTERN_WIDTH-1:0] using_csl_pattern_q[$], input bit [`PATTERN_WIDTH-1:0] using_wl_pattern_q[$], output bit [1:0]  hard_error_record[bit [`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]], output bit [1:0] soft_error_record[bit[1+7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]]);

    bit                             force_mode; //1:force 0; 2:force 1
    bit [`ROW_ADDR_WIDTH-1:0]       err_radd_inject;
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_cadd_inject;
    bit [8:0]                       rand_err_index;
    bit [8:0]                       data_index;

    int                             err_bit_num;
    bit [8:0]                       data_index_q[$];
    bit [8:0]                       data_index_tmp_q[$];


    //soft fail
    bit [6:0]       soft_fail_pattern;
    bit             soft_fail_mode;     //0: csl fail; 1:wl fail

    foreach(err_addr[i,j]) begin
        if (err_addr[i][j] == 1) begin  //err addr 

            err_radd_inject = i;
            err_cadd_inject = j;

            if ($urandom_range(1)) begin    //hard fail
                randcase
                    60: err_bit_num = 1;
                    20: err_bit_num = 2;
                    10: err_bit_num = 3;
                    5:  err_bit_num = 4;
                    5:  err_bit_num = $urandom_range(1,272);
                endcase

                `uvm_info("gen_hard_error", $sformatf("radd is %0h, cadd is %0h, err_bit_num is %0d", err_radd_inject, err_cadd_inject, err_bit_num),UVM_MEDIUM)
                for(int k=0;k<err_bit_num;k++) begin
                    while(1) begin
                        data_index = $urandom_range(271);
                        data_index_tmp_q = data_index_q.find with(item == data_index);
                        if(data_index_tmp_q.size()==0) begin
                            break;
                        end
                    end
                    data_index_q.push_back(data_index);
                        
                    force_mode=$urandom_range(1);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),force_mode);
                    `ifdef TEST_1_SHOT_1
                    `elsif TEST_1_SHOT_2
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),force_mode);
                    `elsif TEST_1_SHOT_3
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),force_mode);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),force_mode);
                    `elsif TEST_1_SHOT_4
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),force_mode);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),force_mode);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),force_mode);
                    `else
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),force_mode);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),force_mode);
                    `endif

                    `uvm_info("gen_hard_error", $sformatf("radd is %0h, cadd is %0h, err_bit_num is %0d, force value is %0d", err_radd_inject, err_cadd_inject, data_index, force_mode+1),UVM_MEDIUM)
                    hard_error_record[{err_radd_inject,err_cadd_inject,data_index}] = force_mode+1;
                end
            end
            else begin      //soft fail
                randcase
                    60: err_bit_num = 1;
                    20: err_bit_num = 2;
                    10: err_bit_num = 3;
                    5:  err_bit_num = 4;
                    5:  err_bit_num = $urandom_range(1,272);
                endcase
            
                soft_fail_mode=$urandom_range(1);
                soft_fail_pattern=soft_fail_mode? $urandom_range(using_wl_pattern_q.size()-1):$urandom_range(using_csl_pattern_q.size()-1);

                `uvm_info("gen_soft_error", $sformatf("fail mode is %0d, pattern_index is %0d, radd is %0h, cadd is %0h, err_bit_num is %0d",soft_fail_mode, soft_fail_pattern, err_radd_inject, err_cadd_inject, err_bit_num),UVM_MEDIUM)
                for(int k=0;k<err_bit_num;k++) begin
                    while(1) begin
                        data_index = $urandom_range(271);
                        data_index_tmp_q = data_index_q.find with(item == data_index);
                        if(data_index_tmp_q.size()==0) begin
                            break;
                        end
                    end
                    data_index_q.push_back(data_index);
                        
                    force_mode=$urandom_range(1);
                    //uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),force_mode);
                    soft_error_record[{soft_fail_mode, soft_fail_pattern, err_radd_inject,err_cadd_inject,data_index}] = force_mode+1;
                end

            end

            data_index_tmp_q.delete();
            data_index_q.delete();
        end
    end
endtask: gen_bist_error

task mc_bist_rescan_vseq::gen_exp_csl(input bit [3:0] part, input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$], output bit [`COLUMN_ADDR_WIDTH-1:0] exp_err_csl_partx[68][6], input bit [`PATTERN_WIDTH-1:0] using_pattern_q[$], output bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0] csl_break_store_addr_q[$], input bit [1:0]  hard_error_record[bit [`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]],input bit [1:0] soft_error_record[bit[1+7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]]);

    bit [`ARRAY_DATA_WIDTH-1:0]        golden_pattern[4];
    bit [`ROW_ADDR_WIDTH-1:0]       row_start_addr;
    bit [`ROW_ADDR_WIDTH-1:0]       row_end_addr;
    bit [`COLUMN_ADDR_WIDTH-1:0]    col_tmp_q[$];

    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_store_tmp_q[$];
    bit [7+`COLUMN_ADDR_WIDTH+`ROW_ADDR_WIDTH-1:0]       err_addr_store_tmp_q[$];

    bit [`ROW_ADDR_WIDTH-1:0]       err_radd_inject;
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_cadd_inject;
    bit [7-1:0]                     err_pattern_index;
    bit [8:0]                       data_index;

    int                             err_cnt[bit [`COLUMN_ADDR_WIDTH-1:0]];
    bit                             err_flag;
    int                             data_index_range;

    data_index_range = mc_csl_scan_check_sel? `ARRAY_DATA_WIDTH:`ARRAY_DATA_WIDTH-16;

    //initial exp
    for(int i=0;i<68;i++) begin
        for(int j=0;j<6;j++) begin
            exp_err_csl_partx[i][j] = ERR_CSL_DEFAULT_VALUE;
        end
    end

    //get row range
    row_start_addr = part*BIST_WL_NUM/PART_NUM;
    row_end_addr = (part+1)*BIST_WL_NUM/PART_NUM;

    `uvm_info("gen_exp_csl", $sformatf("pattern num is %0d, start addr is %0h, end addr is %0h",using_pattern_q.size(), row_start_addr, row_end_addr),UVM_LOW)
    for(int i=0;i<using_pattern_q.size();i++) begin //per using_pattern_q
        for(int ii=0;ii<4;ii++) begin
            golden_pattern[ii] = {{34{using_pattern_q[i][ii*8+:8]}}};
        end
        
        err_pattern_index = i;

        foreach(err_addr[j,k]) begin
            if (err_addr[j][k]==1 && (row_start_addr<=j && row_end_addr > j)) begin
                err_radd_inject = j;
                err_cadd_inject = k;

                col_tmp_q = err_csl_partx_q.find with(item==k);
                //`uvm_info("gen_exp_csl", $sformatf("col_tmp_q size is %0d",col_tmp_q.size()),UVM_LOW)
                //foreach(col_tmp_q[iii])
                //    $display("col_tmp_q %0d is %0h",iii,col_tmp_q[iii]);


                if (col_tmp_q.size()>0) begin   //original err csl

                    for(int kk=0;kk<data_index_range;kk++) begin
                        data_index = kk;
                        case(hard_error_record[{err_radd_inject, err_cadd_inject, data_index}])
                            1:begin
                                if (golden_pattern[err_radd_inject%4][data_index] != 0) begin
                                    err_flag=1;
                                end
                            end

                            2:begin
                                if (golden_pattern[err_radd_inject%4][data_index] != 1) begin
                                    err_flag=1;
                                end
                            end
                            0:begin //soft fail

                                case(soft_error_record[{1'b0,err_pattern_index, err_radd_inject, err_cadd_inject, data_index}])
                                    1:begin
                                        if (golden_pattern[err_radd_inject%4][data_index] != 0) begin
                                            err_flag=1;
                                        end
                                    end

                                    2:begin
                                        if (golden_pattern[err_radd_inject%4][data_index] != 1) begin
                                            err_flag=1;
                                        end
                                    end
                                    0:begin
                                    end
                                endcase

                            end

                            default: `uvm_info("gen_exp_csl", $sformatf("hard_error_record value is %0d",hard_error_record[{err_radd_inject, err_cadd_inject, data_index}]),UVM_LOW)
                        endcase
                    end

                    if (err_flag) begin
                        err_cnt[err_cadd_inject] = err_cnt[err_cadd_inject] + 1;
                        err_addr_store_tmp_q.push_back({err_pattern_index, err_cadd_inject, err_radd_inject});
                        $display("pattern %0d, radd is %0h, cadd is %0h, err_cnt is %0d",err_pattern_index, err_radd_inject, err_cadd_inject, err_cnt[err_cadd_inject]);
                        err_flag=0;
                    end

                    if (err_cnt[err_cadd_inject] >= csl_err_threshold) begin
                        err_csl_store_tmp_q.push_back(err_cadd_inject);
                        //`uvm_info("gen_exp_csl", $sformatf("part %0d, push err csl %0h",part, err_cadd_inject),UVM_LOW)
                    end

                end
                col_tmp_q.delete();
            end

        end

        if(err_csl_store_tmp_q.size()>0) begin
            err_csl_store_tmp_q = err_csl_store_tmp_q.unique();
            err_csl_store_tmp_q.sort();
        end

        for(int j=0;j<6;j++) begin
            if(err_csl_store_tmp_q.size()>0) begin
                exp_err_csl_partx[i][j] = err_csl_store_tmp_q.pop_front;
            end
            else begin
                break;
            end
        end

        foreach(err_addr_store_tmp_q[ii]) begin
            //`uvm_info("csl_fail_point", $sformatf("cadd is %0h, radd is %0h", err_addr_store_tmp_q[ii][`ROW_ADDR_WIDTH+:`COLUMN_ADDR_WIDTH], err_addr_store_tmp_q[ii][0+:`ROW_ADDR_WIDTH]),UVM_LOW)
            if (err_cnt[err_addr_store_tmp_q[ii][`ROW_ADDR_WIDTH+:`COLUMN_ADDR_WIDTH]] < csl_err_threshold) begin
                if (err_addr_store_tmp_q[ii][`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+:7] == err_pattern_index) begin
                    err_addr_store_tmp_q.delete(ii);
                end
            end
        end

        err_csl_store_tmp_q.delete();
        foreach(err_cnt[ii]) begin
            //$display("cadd is %0h, err_cnt is %0d",ii, err_cnt[ii]);
            err_cnt[ii]=0;
        end
        
    end

    if (err_addr_store_tmp_q.size()>0) begin
        err_addr_store_tmp_q = err_addr_store_tmp_q.unique();
        err_addr_store_tmp_q.sort();
    end

    csl_break_store_addr_q = err_addr_store_tmp_q;

endtask:gen_exp_csl

task mc_bist_rescan_vseq::sort_err_csl(int num_csl_scan, bit [`COLUMN_ADDR_WIDTH-1:0] exp_err_csl_partx[68][6], output bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$], output bit [7+`COLUMN_ADDR_WIDTH-1:0] exp_check_csl_partx_q[$], output bit csl_part_fail);

    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_tmp_q[$];
    bit [7+`COLUMN_ADDR_WIDTH-1:0]    err_csl_tmp_q2[$];


    for(int i=0;i<num_csl_scan;i++) begin   //pattern

        for (int j=0;j<6;j++) begin 

            if (exp_err_csl_partx[i][j] != ERR_CSL_DEFAULT_VALUE) begin
                err_csl_tmp_q.push_back(exp_err_csl_partx[i][j]);
                err_csl_tmp_q2.push_back({i[6:0],exp_err_csl_partx[i][j]});
            end
            else begin
                break;
            end
        end
    end

    err_csl_tmp_q = err_csl_tmp_q.unique();

    foreach(err_csl_tmp_q[i]) begin
        while(1) begin
            if (err_csl_tmp_q2[i][0+:`COLUMN_ADDR_WIDTH] != err_csl_tmp_q[i]) begin
                err_csl_tmp_q2.delete(i);
            end
            else begin
                break;
            end
        end
    end

    err_csl_tmp_q2 = err_csl_tmp_q2[0:err_csl_tmp_q.size()-1];

    if(err_csl_tmp_q.size() != err_csl_tmp_q2.size()) begin
        `uvm_error("sort_err_csl", "sort_err_csl error, size not same")
    end


    if (err_csl_tmp_q.size()>2) begin
        csl_part_fail = 1;
    end

    err_csl_partx_q = err_csl_tmp_q;
    exp_check_csl_partx_q = err_csl_tmp_q2;

endtask:sort_err_csl

task mc_bist_rescan_vseq::gen_csl_fail_point(input bit [3:0] part, input bit [7+`COLUMN_ADDR_WIDTH-1:0] exp_check_csl_partx_q[$], ref bit [31:0] csl_fail_point_q[$], input bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0] csl_break_store_addr_q[$]);

    int         err_cnt;
    bit [6:0]   pattern_index;
    bit [`ROW_ADDR_WIDTH-1:0]   err_radd_inject;
    bit [7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-1:0]  csl_break_store_addr_tmp_q[$];

    if(exp_check_csl_partx_q.size()>2) begin
        pattern_index = exp_check_csl_partx_q[2][`COLUMN_ADDR_WIDTH+:7];
        csl_break_store_addr_tmp_q = csl_break_store_addr_q.find with (item[`ROW_ADDR_WIDTH+:(7+`COLUMN_ADDR_WIDTH)] == {pattern_index, exp_check_csl_partx_q[2][0+:`COLUMN_ADDR_WIDTH]});
        if(csl_break_store_addr_tmp_q.size() <csl_err_threshold ) begin
            `uvm_error("csl_fail_point gen err", $sformatf("part %0d, csl %0h, size != 1, %0d",part, exp_check_csl_partx_q[2][0+:`COLUMN_ADDR_WIDTH], csl_break_store_addr_tmp_q.size()))
        end
        csl_fail_point_q.push_back({pattern_index, part, exp_check_csl_partx_q[2][0+:`COLUMN_ADDR_WIDTH], csl_break_store_addr_tmp_q[csl_err_threshold-1][0+:`ROW_ADDR_WIDTH]});
        `uvm_info("csl_fail_point gen", $sformatf("pattern_index %0d, part %0d, csl exp_err_csl_partx %0h, row %0h", pattern_index, part,exp_check_csl_partx_q[2][0+:`COLUMN_ADDR_WIDTH] , csl_break_store_addr_tmp_q[csl_err_threshold-1][0+:`ROW_ADDR_WIDTH]),UVM_LOW)
    end


    //for (int i=0;i<68;i++) begin
    //    pattern_index=i;

    //    for(int j=0;j<6;j++)begin
    //        if (exp_err_csl_partx[i][j] !== ERR_CSL_DEFAULT_VALUE) begin
    //            err_cnt = err_cnt + 1;
    //            `uvm_info("csl_fail_point gen", $sformatf("pattern %0d, part %0d, err_cnt %0d, exp_err_csl_partx %0h", pattern_index,part,err_cnt,exp_err_csl_partx[i][j]),UVM_LOW)
    //        end
    //        if (err_cnt > 2) begin
    //            csl_break_store_addr_tmp_q = csl_break_store_addr_q.find with (item[`ROW_ADDR_WIDTH+:(7+`COLUMN_ADDR_WIDTH)] == {pattern_index, exp_err_csl_partx[i][j]});
    //            if(csl_break_store_addr_tmp_q.size() <csl_err_threshold ) begin
    //                `uvm_error("csl_fail_point gen err", $sformatf("part %0d, csl %0h, size != 1, %0d",part, exp_err_csl_partx[i][j], csl_break_store_addr_tmp_q.size()))
    //            end

    //            csl_fail_point_q.push_back({pattern_index, part, exp_err_csl_partx[i][j], csl_break_store_addr_tmp_q[csl_err_threshold-1][0+:`ROW_ADDR_WIDTH]});
    //            //`uvm_info("csl_fail_point gen", $sformatf("pattern_index %0d, part %0d, csl exp_err_csl_partx%0h, row %0h", pattern_index, part, , csl_break_store_addr_tmp_q[csl_err_threshold-1][0+:`ROW_ADDR_WIDTH]),UVM_LOW)
    //            break;
    //        end
    //    end
    //    err_cnt=0;
    //end

endtask:gen_csl_fail_point

task mc_bist_rescan_vseq::gen_exp_err_row(input bit [3:0] part, input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$], ref bit [`ROW_ADDR_WIDTH+7-1:0] exp_err_row_q[$],input bit [1:0]  hard_error_record[bit [`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]],input bit [1:0] soft_error_record[bit[1+7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]], input  bit [`PATTERN_WIDTH-1:0] using_pattern_q[$]);


    bit [`ARRAY_DATA_WIDTH-1:0]        golden_pattern[4];
    bit [`ROW_ADDR_WIDTH-1:0]       row_start_addr;
    bit [`ROW_ADDR_WIDTH-1:0]       row_end_addr;
    bit [`COLUMN_ADDR_WIDTH-1:0]    col_tmp_q[$];
    bit [`ROW_ADDR_WIDTH-1:0]       err_radd_inject;
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_cadd_inject;

    bit [6:0]                       pattern_index;
    bit [8:0]                       data_index;
    bit                             err_flag;
    int                             data_index_range;

    int csl_gap_cnt;

    //get row range
    row_start_addr = part*BIST_WL_NUM/PART_NUM;
    row_end_addr = (part+1)*BIST_WL_NUM/PART_NUM;

    data_index_range = `ARRAY_DATA_WIDTH;

    col_tmp_q = err_csl_partx_q;

    if (col_tmp_q.size()==0) begin//no err
        csl_gap_cnt = 0;
    end
    else if (col_tmp_q.size()==1) begin
        if (col_tmp_q[0] <= 'd127)
            csl_gap_cnt=csl_gap_cnt + 1;
    end
    else begin
        col_tmp_q = err_csl_partx_q[0:1];
        col_tmp_q.sort();
        if (col_tmp_q[0] <= 'd127) begin
            csl_gap_cnt=csl_gap_cnt + 1;
        end

        if (col_tmp_q[1] <= ('d127+csl_gap_cnt)) begin
            csl_gap_cnt=csl_gap_cnt + 1;
        end
    end

    `uvm_info("gen_exp_wl", $sformatf("part %0d, csl_gap_cnt is %0d, err csl size is %0d", part, csl_gap_cnt, col_tmp_q.size()),UVM_MEDIUM)

    for(int i=0;i<using_pattern_q.size();i++) begin //per using_pattern_q

        pattern_index = i;

        for(int ii=0;ii<4;ii++) begin
            golden_pattern[ii] = {{34{using_pattern_q[i][ii*8+:8]}}};
        end
        
        foreach(err_addr[j,k]) begin
            if (err_addr[j][k]==1 && (row_start_addr<=j && row_end_addr > j) && (k<='d127+csl_gap_cnt)) begin
                err_radd_inject = j;
                err_cadd_inject = k;

                case(col_tmp_q.size())
                    0:begin

                        for(int kk=0;kk<data_index_range;kk++) begin
                            data_index = kk;
                            case(hard_error_record[{err_radd_inject, err_cadd_inject, data_index}])
                                1:begin
                                    if (golden_pattern[err_radd_inject%4][data_index] != 0) begin
                                        err_flag=1;
                                    end
                                end

                                2:begin
                                    if (golden_pattern[err_radd_inject%4][data_index] != 1) begin
                                        err_flag=1;
                                    end
                                end
                                0:begin
                                    case(soft_error_record[{1'b1,pattern_index, err_radd_inject, err_cadd_inject, data_index}])
                                        1:begin
                                            if (golden_pattern[err_radd_inject%4][data_index] != 0) begin
                                                err_flag=1;
                                            end
                                        end

                                        2:begin
                                            if (golden_pattern[err_radd_inject%4][data_index] != 1) begin
                                                err_flag=1;
                                            end
                                        end
                                        0:begin
                                        end
                                    endcase
                                end

                                default: `uvm_info("gen_exp_csl", $sformatf("hard_error_record value is %0d",hard_error_record[{err_radd_inject, err_cadd_inject, data_index}]),UVM_MEDIUM)
                            endcase
                        end
                    end
                    1:begin
                        if (k!=col_tmp_q[0]) begin
                            for(int kk=0;kk<data_index_range;kk++) begin
                                data_index = kk;
                                case(hard_error_record[{err_radd_inject, err_cadd_inject, data_index}])
                                    1:begin
                                        if (golden_pattern[err_radd_inject%4][data_index] != 0) begin
                                            err_flag=1;
                                        end
                                    end

                                    2:begin
                                        if (golden_pattern[err_radd_inject%4][data_index] != 1) begin
                                            err_flag=1;
                                        end
                                    end
                                    0:begin
                                        case(soft_error_record[{1'b1,pattern_index, err_radd_inject, err_cadd_inject, data_index}])
                                            1:begin
                                                if (golden_pattern[err_radd_inject%4][data_index] != 0) begin
                                                    err_flag=1;
                                                end
                                            end
    
                                            2:begin
                                                if (golden_pattern[err_radd_inject%4][data_index] != 1) begin
                                                    err_flag=1;
                                                end
                                            end
                                            0:begin
                                            end
                                        endcase
                                    end

                                    default: `uvm_info("gen_exp_csl", $sformatf("hard_error_record value is %0d",hard_error_record[{err_radd_inject, err_cadd_inject, data_index}]),UVM_MEDIUM)
                                endcase
                            end
                        end
                    end
                    default:begin
                        if (k!=col_tmp_q[0] && k!=col_tmp_q[1]) begin
                            for(int kk=0;kk<data_index_range;kk++) begin
                                data_index = kk;
                                case(hard_error_record[{err_radd_inject, err_cadd_inject, data_index}])
                                    1:begin
                                        if (golden_pattern[err_radd_inject%4][data_index] != 0) begin
                                            err_flag=1;
                                        end
                                    end

                                    2:begin
                                        if (golden_pattern[err_radd_inject%4][data_index] != 1) begin
                                            err_flag=1;
                                        end
                                    end
                                    0:begin
                                        case(soft_error_record[{1'b1,pattern_index, err_radd_inject, err_cadd_inject, data_index}])
                                            1:begin
                                                if (golden_pattern[err_radd_inject%4][data_index] != 0) begin
                                                    err_flag=1;
                                                end
                                            end

                                            2:begin
                                                if (golden_pattern[err_radd_inject%4][data_index] != 1) begin
                                                    err_flag=1;
                                                end
                                            end
                                            0:begin
                                            end
                                        endcase
                                    end

                                    default: `uvm_info("gen_exp_csl", $sformatf("hard_error_record value is %0d",hard_error_record[{err_radd_inject, err_cadd_inject, data_index}]),UVM_MEDIUM)
                                endcase
                            end
                        end
                    end
                endcase
                if (err_flag) begin
                    exp_err_row_q.push_back({pattern_index, err_radd_inject});
                    err_flag=0;
                end
            end
        end
    end

    exp_err_row_q=exp_err_row_q.unique();

endtask:gen_exp_err_row

task mc_bist_rescan_vseq::sort_err_row(input int num_wl_scan, ref bit [`ROW_ADDR_WIDTH+7-1:0] exp_err_row_q[$]);

    bit [`ROW_ADDR_WIDTH+7-1:0] exp_err_row_tmp_q[$];
    bit [`ROW_ADDR_WIDTH+7-1:0] exp_err_row_tmp_q2[$];

    bit [`ROW_ADDR_WIDTH+7-1:0] exp_err_row_tmp_q3[$];
    bit [`ROW_ADDR_WIDTH+7-1:0] exp_err_row_tmp_q4[$];

    for(int i=0;i<num_wl_scan;i++) begin

        foreach(exp_err_row_q[ii]) begin
            if (exp_err_row_q[ii][`ROW_ADDR_WIDTH+7-1-:7] == i) begin
                exp_err_row_tmp_q.push_back({exp_err_row_q[ii][`ROW_ADDR_WIDTH+7-1-:7], exp_err_row_q[ii][0+:`ROW_ADDR_WIDTH]});
                exp_err_row_tmp_q3.push_back(exp_err_row_q[ii][0+:`ROW_ADDR_WIDTH]);
            end
        end
        if(exp_err_row_tmp_q.size()>0) begin
            exp_err_row_tmp_q.sort();
        end
        if(exp_err_row_tmp_q3.size()>0) begin
            exp_err_row_tmp_q3.sort();
        end

        exp_err_row_tmp_q2={exp_err_row_tmp_q2, exp_err_row_tmp_q};
        exp_err_row_tmp_q4={exp_err_row_tmp_q4, exp_err_row_tmp_q3};

        exp_err_row_tmp_q.delete();
        exp_err_row_tmp_q3.delete();
    end

    exp_err_row_tmp_q2 = exp_err_row_tmp_q2.unique();
    exp_err_row_tmp_q4 = exp_err_row_tmp_q4.unique();

    foreach(exp_err_row_tmp_q4[i]) begin
        while(1) begin
            if (exp_err_row_tmp_q2[i][0+:`ROW_ADDR_WIDTH] != exp_err_row_tmp_q4[i]) begin
                exp_err_row_tmp_q2.delete(i);
            end
            else begin
                break;
            end
        end
    end

    exp_err_row_tmp_q2 = exp_err_row_tmp_q2[0:exp_err_row_tmp_q4.size()-1];

    if(exp_err_row_tmp_q2.size() != exp_err_row_tmp_q4.size()) begin
        `uvm_error("sort_err_row", "sort_err_row error, size not same")
    end


    if (exp_err_row_tmp_q2.size()>64) begin
        exp_wl_fail=1;
        `uvm_info("exp_wl_fail=1",$sformatf("exp_err_row_tmp_q2_size is %0d",exp_err_row_tmp_q2.size),UVM_LOW)
    end

    exp_err_row_q = exp_err_row_tmp_q2;


endtask:sort_err_row

task mc_bist_rescan_vseq::exp_err_csl_check(input bit [3:0] part, input bit [7+`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$], input bit [`COLUMN_ADDR_WIDTH-1:0] read_err_csl_partx_q[$],input bit [7+4+`COLUMN_ADDR_WIDTH+`ROW_ADDR_WIDTH-1:0] csl_fail_point);

    //bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_part0_q[$];
    bit [6:0]   fail_pattern;
    bit [3:0]   fail_part;
    bit [`COLUMN_ADDR_WIDTH-1:0] fail_col;
    bit [`ROW_ADDR_WIDTH-1:0] fail_row;

    {fail_pattern, fail_part, fail_col,fail_row}=csl_fail_point;

    if (!mc_csl_scan_mode_sel) begin    //abort
        case(err_csl_partx_q.size())
            0:begin
                for(int i=0;i<2;i++) begin
                    if(read_err_csl_partx_q[i]!==ERR_CSL_DEFAULT_VALUE) begin
                        `uvm_error("err csl check", $sformatf("at part%0d, err csl check err, exp is %0h, act is %0h",part, ERR_CSL_DEFAULT_VALUE, read_err_csl_partx_q[i]))
                    end
                end
            end
            1:begin
                if({err_csl_partx_q[0][7+`COLUMN_ADDR_WIDTH-1-:7],part,err_csl_partx_q[0][0+:`COLUMN_ADDR_WIDTH]}<=csl_fail_point[`ROW_ADDR_WIDTH+:7+4+`COLUMN_ADDR_WIDTH]) begin
                    if(read_err_csl_partx_q[0]!==err_csl_partx_q[0][0+:`COLUMN_ADDR_WIDTH]) begin
                        `uvm_error("err csl check", $sformatf("at part%0d, err csl check err, exp is %0h, act is %0h",part, err_csl_partx_q[0][0+:`COLUMN_ADDR_WIDTH], read_err_csl_partx_q[0]))
                    end
                end
                else begin
                    if(read_err_csl_partx_q[0]!==ERR_CSL_DEFAULT_VALUE) begin
                        `uvm_error("err csl check", $sformatf("at part%0d, err csl check err, exp is %0h, act is %0h",part, ERR_CSL_DEFAULT_VALUE, read_err_csl_partx_q[0]))
                    end
                end
                if(read_err_csl_partx_q[1]!==ERR_CSL_DEFAULT_VALUE) begin
                    `uvm_error("err csl check", $sformatf("at part%0d, err csl check err, exp is %0h, act is %0h",part, ERR_CSL_DEFAULT_VALUE, read_err_csl_partx_q[1]))
                end
            end
            default:begin
                for(int i=0;i<2;i++) begin
                    if({err_csl_partx_q[i][7+`COLUMN_ADDR_WIDTH-1-:7],part,err_csl_partx_q[i][0+:`COLUMN_ADDR_WIDTH]}<=csl_fail_point[`ROW_ADDR_WIDTH+:7+4+`COLUMN_ADDR_WIDTH]) begin
                        if(read_err_csl_partx_q[i]!==err_csl_partx_q[i][0+:`COLUMN_ADDR_WIDTH]) begin
                            `uvm_error("err csl check", $sformatf("at part%0d, err csl check err, exp is %0h, act is %0h",part, err_csl_partx_q[i][0+:`COLUMN_ADDR_WIDTH], read_err_csl_partx_q[i]))
                        end
                    end
                    else begin
                        if(read_err_csl_partx_q[i]!==ERR_CSL_DEFAULT_VALUE) begin
                            `uvm_error("err csl check", $sformatf("at part%0d, err csl check err, exp is %0h, act is %0h",part, ERR_CSL_DEFAULT_VALUE, read_err_csl_partx_q[i]))
                        end
                    end
                end
            end
        endcase
    end


    else begin
        for(int i=0;i<2;i++) begin

            if(err_csl_partx_q.size()<=i) begin
                if(read_err_csl_partx_q[i]!==ERR_CSL_DEFAULT_VALUE) begin
                    `uvm_error("err csl check", $sformatf("at part%0d, err csl check err, exp is %0h, act is %0h",part, ERR_CSL_DEFAULT_VALUE, read_err_csl_partx_q[i]))
                end
            end
            else begin
                if(read_err_csl_partx_q[i]!==err_csl_partx_q[i][0+:`COLUMN_ADDR_WIDTH]) begin
                    `uvm_error("err csl check", $sformatf("at part%0d, err csl check err, exp is %0h, act is %0h",part, err_csl_partx_q[i][0+:`COLUMN_ADDR_WIDTH], read_err_csl_partx_q[i]))
                end
            end
        end
    end
endtask:exp_err_csl_check

task mc_bist_rescan_vseq::exp_err_wl_check(input bit [`ROW_ADDR_WIDTH+7-1:0] exp_err_row_q[$], input bit [`ROW_ADDR_WIDTH-1:0] read_err_row_reg_q[$]);
    bit [`ROW_ADDR_WIDTH+7-1:0] exp_err_row_tmp_q[$];

    exp_err_row_tmp_q = exp_err_row_q[0:63];

    `uvm_info("exp_err_wl_check", $sformatf("exp_err_row_tmp_q size is %0d", exp_err_row_tmp_q.size()),UVM_LOW)

    exp_err_row_tmp_q.rsort();

    if (!mc_csl_scan_mode_sel && exp_csl_fail) begin
        for(int i=0;i<64;i++) begin
            if(read_err_row_reg_q[i]!==ERR_WL_DEFAULT_VALUE) begin
                `uvm_error("err wl check", $sformatf(" err wl check err, exp is %0h, act is %0h", ERR_WL_DEFAULT_VALUE, read_err_row_reg_q[i]))
            end
        end
    end

    else begin
        for(int i=0;i<64;i++) begin
            if(exp_err_row_tmp_q.size()<=i) begin
                if(read_err_row_reg_q[i]!==ERR_WL_DEFAULT_VALUE) begin
                    `uvm_error("err wl check", $sformatf(" err wl check err, exp is %0h, act is %0h", ERR_WL_DEFAULT_VALUE, read_err_row_reg_q[i]))
                end
            end
            else begin
                if(read_err_row_reg_q[i]!==exp_err_row_tmp_q[i][0+:13]) begin
                    `uvm_error("err wl check", $sformatf("i=%0d,err wl check err, exp is %0h, act is %0h",i, exp_err_row_tmp_q[i][0+:13], read_err_row_reg_q[i]))
                end
            end
        end
    end

endtask:exp_err_wl_check

task mc_bist_rescan_vseq::soft_error_process(input bit process_mode, input bit csl_wl_mode, input bit [6:0] pattern_index, input bit [1:0] soft_error_record[bit[1+7+`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]]);

    bit [`ROW_ADDR_WIDTH-1:0]       err_radd_inject;
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_cadd_inject;
    bit [8:0]                       data_index;

    int                             data_index_range;

    data_index_range = `ARRAY_DATA_WIDTH;

    foreach(err_addr[j,k]) begin
        if (err_addr[j][k]==1) begin
            err_radd_inject = j;
            err_cadd_inject = k;

            if (process_mode) begin //err inject
                for(int kk=0;kk<data_index_range;kk++) begin
                    data_index = kk;
                    case(soft_error_record[{csl_wl_mode, pattern_index, err_radd_inject, err_cadd_inject, data_index}])
                        1:begin
                            `uvm_info("gen_soft_error", $sformatf("fail mode is %0d, pattern_index is %0d, radd is %0h, cadd is %0h, err_bit_num is %0d",csl_wl_mode, pattern_index, err_radd_inject, err_cadd_inject, data_index),UVM_LOW)
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),0);
                            `ifdef TEST_1_SHOT_1
                            `elsif TEST_1_SHOT_2
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),0);
                            `elsif TEST_1_SHOT_3
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),0);
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),0);
                            `elsif TEST_1_SHOT_4
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),0);
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),0);
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),0);
                            `else
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),0);
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),0);
                            `endif
                        end

                        2:begin
                            `uvm_info("gen_soft_error", $sformatf("fail mode is %0d, pattern_index is %0d, radd is %0h, cadd is %0h, err_bit_num is %0d",csl_wl_mode, pattern_index, err_radd_inject, err_cadd_inject, data_index),UVM_LOW)
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),1);
                            `ifdef TEST_1_SHOT_1
                            `elsif TEST_1_SHOT_2
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),1);
                            `elsif TEST_1_SHOT_3
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),1);
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),1);
                            `elsif TEST_1_SHOT_4
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),1);
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),1);
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),1);
                            `else
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),1);
                            uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index),1);
                            `endif
                        end
                        0:begin
                        end

                    endcase
                end
            end
            else begin  //err release
                for(int kk=0;kk<data_index_range;kk++) begin
                    data_index = kk;
                    case(soft_error_record[{csl_wl_mode, pattern_index, err_radd_inject, err_cadd_inject, data_index}])
                        1:begin
                            `uvm_info("gen_soft_error", $sformatf("fail mode is %0d, pattern_index is %0d, radd is %0h, cadd is %0h, err_bit_num is %0d",csl_wl_mode, pattern_index, err_radd_inject, err_cadd_inject, data_index),UVM_LOW)
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `ifdef TEST_1_SHOT_1
                            `elsif TEST_1_SHOT_2
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `elsif TEST_1_SHOT_3
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `elsif TEST_1_SHOT_4
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `else
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `endif
                        end

                        2:begin
                            `uvm_info("gen_soft_error", $sformatf("fail mode is %0d, pattern_index is %0d, radd is %0h, cadd is %0h, err_bit_num is %0d",csl_wl_mode, pattern_index, err_radd_inject, err_cadd_inject, data_index),UVM_LOW)
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `ifdef TEST_1_SHOT_1
                            `elsif TEST_1_SHOT_2
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `elsif TEST_1_SHOT_3
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `elsif TEST_1_SHOT_4
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `else
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `endif
                        end
                        0:begin
                        end

                    endcase
                end

            end
        end
    end

endtask:soft_error_process

task mc_bist_rescan_vseq::hard_fail_release(input bit [1:0]  hard_error_record[bit [`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]], input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part0_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part1_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part2_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part3_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part4_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part5_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part6_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part7_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part8_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part9_q[$],input bit [`ROW_ADDR_WIDTH-1:0]     exp_err_row_q[$] );

    bit [`ROW_ADDR_WIDTH-1:0]       err_radd_inject;
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_cadd_inject;
    bit [8:0]                       data_index;

    bit                             gap_release;
    int                             data_index_range;

    bit [`ROW_ADDR_WIDTH-1:0]       exp_err_row_tmp_q[$];
    bit [`ROW_ADDR_WIDTH-1:0]       exp_err_row_tmp_q2[$];

    data_index_range = 272;

    //foreach(exp_err_row_q[ii]) begin
    //    exp_err_row_tmp_q.push_back(exp_err_row_q[ii][0+:13]);
    //end

    if(exp_err_row_tmp_q.size()>=64) begin
        exp_err_row_tmp_q = exp_err_row_tmp_q[0:63];
    end
    else begin
        exp_err_row_tmp_q = exp_err_row_tmp_q[0:$];
    end

    //foreach(exp_err_row_tmp_q[i]) begin
    //    `uvm_info("hard_fail_release", $sformatf("exp_err_row_tmp_q is %0h", exp_err_row_tmp_q[i]),UVM_LOW)
    //end

    foreach(err_addr[j,k]) begin
        if (err_addr[j][k]==1) begin
            err_radd_inject = j;
            err_cadd_inject = k;

            case(caculate_row_part(err_radd_inject))
                0:begin
                    if(err_csl_part0_q.size()==0) begin
                    end
                    else if (err_csl_part0_q.size()==1) begin
                        if (err_cadd_inject === err_csl_part0_q[0]) begin
                            gap_release=1;
                        end
                    end
                    else begin
                        if (err_cadd_inject === err_csl_part0_q[0] || err_cadd_inject === err_csl_part0_q[1]) begin
                            gap_release=1;
                        end
                    end
                end
                1:begin
                    if(err_csl_part1_q.size()==0) begin
                    end
                    else if (err_csl_part1_q.size()==1) begin
                        if (err_cadd_inject === err_csl_part1_q[0]) begin
                            gap_release=1;
                        end
                    end
                    else begin
                        if (err_cadd_inject === err_csl_part1_q[0] || err_cadd_inject === err_csl_part1_q[1]) begin
                            gap_release=1;
                        end
                    end
                end
                2:begin
                    if(err_csl_part2_q.size()==0) begin
                    end
                    else if (err_csl_part2_q.size()==1) begin
                        if (err_cadd_inject === err_csl_part2_q[0]) begin
                            gap_release=1;
                        end
                    end
                    else begin
                        if (err_cadd_inject === err_csl_part2_q[0] || err_cadd_inject === err_csl_part2_q[1]) begin
                            gap_release=1;
                        end
                    end
                end
                3:begin
                    if(err_csl_part3_q.size()==0) begin
                    end
                    else if (err_csl_part3_q.size()==1) begin
                        if (err_cadd_inject === err_csl_part3_q[0]) begin
                            gap_release=1;
                        end
                    end
                    else begin
                        if (err_cadd_inject === err_csl_part3_q[0] || err_cadd_inject === err_csl_part3_q[1]) begin
                            gap_release=1;
                        end
                    end
                end
                4:begin
                    if(err_csl_part4_q.size()==0) begin
                    end
                    else if (err_csl_part4_q.size()==1) begin
                        if (err_cadd_inject === err_csl_part4_q[0]) begin
                            gap_release=1;
                        end
                    end
                    else begin
                        if (err_cadd_inject === err_csl_part4_q[0] || err_cadd_inject === err_csl_part4_q[1]) begin
                            gap_release=1;
                        end
                    end
                end
                5:begin
                    if(err_csl_part5_q.size()==0) begin
                    end
                    else if (err_csl_part5_q.size()==1) begin
                        if (err_cadd_inject === err_csl_part5_q[0]) begin
                            gap_release=1;
                        end
                    end
                    else begin
                        if (err_cadd_inject === err_csl_part5_q[0] || err_cadd_inject === err_csl_part5_q[1]) begin
                            gap_release=1;
                        end
                    end
                end
                6:begin
                    if(err_csl_part6_q.size()==0) begin
                    end
                    else if (err_csl_part6_q.size()==1) begin
                        if (err_cadd_inject === err_csl_part6_q[0]) begin
                            gap_release=1;
                        end
                    end
                    else begin
                        if (err_cadd_inject === err_csl_part6_q[0] || err_cadd_inject === err_csl_part6_q[1]) begin
                            gap_release=1;
                        end
                    end
                end
                7:begin
                    if(err_csl_part7_q.size()==0) begin
                    end
                    else if (err_csl_part7_q.size()==1) begin
                        if (err_cadd_inject === err_csl_part7_q[0]) begin
                            gap_release=1;
                        end
                    end
                    else begin
                        if (err_cadd_inject === err_csl_part7_q[0] || err_cadd_inject === err_csl_part7_q[1]) begin
                            gap_release=1;
                        end
                    end
                end
                8:begin
                    if(err_csl_part8_q.size()==0) begin
                    end
                    else if (err_csl_part8_q.size()==1) begin
                        if (err_cadd_inject === err_csl_part8_q[0]) begin
                            gap_release=1;
                        end
                    end
                    else begin
                        if (err_cadd_inject === err_csl_part8_q[0] || err_cadd_inject === err_csl_part8_q[1]) begin
                            gap_release=1;
                        end
                    end
                end
                9:begin
                    if(err_csl_part9_q.size()==0) begin
                    end
                    else if (err_csl_part9_q.size()==1) begin
                        if (err_cadd_inject === err_csl_part9_q[0]) begin
                            gap_release=1;
                        end
                    end
                    else begin
                        if (err_cadd_inject === err_csl_part9_q[0] || err_cadd_inject === err_csl_part9_q[1]) begin
                            gap_release=1;
                        end
                    end
                end
            endcase

            exp_err_row_tmp_q2 = exp_err_row_tmp_q.find with (item == err_radd_inject);
            if(exp_err_row_tmp_q2.size()>0) begin
                gap_release=1;
            end

            //err release
            if(!gap_release) begin
                //`uvm_info("hard_fail_release",$sformatf("release addr is radd %0h, cadd %0h", err_radd_inject, err_cadd_inject),UVM_LOW)
                for(int kk=0;kk<data_index_range;kk++) begin
                    data_index = kk;
                    case(hard_error_record[{err_radd_inject, err_cadd_inject, data_index}])
                        1:begin
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `ifdef TEST_1_SHOT_1
                            `elsif TEST_1_SHOT_2
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `elsif TEST_1_SHOT_3
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `elsif TEST_1_SHOT_4
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `else
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `endif
                            `uvm_info("hard_fail_release",$sformatf("release addr is radd %0h, cadd %0h", err_radd_inject, err_cadd_inject),UVM_MEDIUM)
                        end

                        2:begin
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `ifdef TEST_1_SHOT_1
                            `elsif TEST_1_SHOT_2
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `elsif TEST_1_SHOT_3
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `elsif TEST_1_SHOT_4
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `else
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
                            `endif
                            `uvm_info("hard_fail_release",$sformatf("release addr is radd %0h, cadd %0h", err_radd_inject, err_cadd_inject),UVM_MEDIUM)
                        end
                        0:begin
                        end

                    endcase
                end
            end
            gap_release=0;
        end
    end

endtask:hard_fail_release


//task mc_bist_rescan_vseq::hard_fail_release(input bit [1:0]  hard_error_record[bit [`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH+9-1:0]], input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part0_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part1_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part2_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part3_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part4_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part5_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part6_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part7_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part8_q[$],input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_part9_q[$],input bit [`ROW_ADDR_WIDTH+7-1:0]     exp_err_row_q[$] );
//
//    bit [`ROW_ADDR_WIDTH-1:0]       err_radd_inject;
//    bit [`COLUMN_ADDR_WIDTH-1:0]    err_cadd_inject;
//    bit [8:0]                       data_index;
//
//    bit                             gap_release;
//    int                             data_index_range;
//
//    bit [`ROW_ADDR_WIDTH-1:0]       exp_err_row_tmp_q[$];
//    bit [`ROW_ADDR_WIDTH-1:0]       exp_err_row_tmp_q2[$];
//
//    data_index_range = 272;
//
//    foreach(exp_err_row_q[ii]) begin
//        exp_err_row_tmp_q.push_back(exp_err_row_q[ii][0+:13]);
//    end
//
//    if(exp_err_row_tmp_q.size()>=64) begin
//        exp_err_row_tmp_q = exp_err_row_tmp_q[0:63];
//    end
//    else begin
//        exp_err_row_tmp_q = exp_err_row_tmp_q[0:$];
//    end
//
//    //foreach(exp_err_row_tmp_q[i]) begin
//    //    `uvm_info("hard_fail_release", $sformatf("exp_err_row_tmp_q is %0h", exp_err_row_tmp_q[i]),UVM_LOW)
//    //end
//
//    foreach(err_addr[j,k]) begin
//        if (err_addr[j][k]==1) begin
//            err_radd_inject = j;
//            err_cadd_inject = k;
//
//            case(caculate_row_part(err_radd_inject))
//                0:begin
//                    if(err_csl_part0_q.size()==0) begin
//                    end
//                    else if (err_csl_part0_q.size()==1) begin
//                        if (err_cadd_inject === err_csl_part0_q[0]) begin
//                            gap_release=1;
//                        end
//                    end
//                    else begin
//                        if (err_cadd_inject === err_csl_part0_q[0] || err_cadd_inject === err_csl_part0_q[1]) begin
//                            gap_release=1;
//                        end
//                    end
//                end
//                1:begin
//                    if(err_csl_part1_q.size()==0) begin
//                    end
//                    else if (err_csl_part1_q.size()==1) begin
//                        if (err_cadd_inject === err_csl_part1_q[0]) begin
//                            gap_release=1;
//                        end
//                    end
//                    else begin
//                        if (err_cadd_inject === err_csl_part1_q[0] || err_cadd_inject === err_csl_part1_q[1]) begin
//                            gap_release=1;
//                        end
//                    end
//                end
//                2:begin
//                    if(err_csl_part2_q.size()==0) begin
//                    end
//                    else if (err_csl_part2_q.size()==1) begin
//                        if (err_cadd_inject === err_csl_part2_q[0]) begin
//                            gap_release=1;
//                        end
//                    end
//                    else begin
//                        if (err_cadd_inject === err_csl_part2_q[0] || err_cadd_inject === err_csl_part2_q[1]) begin
//                            gap_release=1;
//                        end
//                    end
//                end
//                3:begin
//                    if(err_csl_part3_q.size()==0) begin
//                    end
//                    else if (err_csl_part3_q.size()==1) begin
//                        if (err_cadd_inject === err_csl_part3_q[0]) begin
//                            gap_release=1;
//                        end
//                    end
//                    else begin
//                        if (err_cadd_inject === err_csl_part3_q[0] || err_cadd_inject === err_csl_part3_q[1]) begin
//                            gap_release=1;
//                        end
//                    end
//                end
//                4:begin
//                    if(err_csl_part4_q.size()==0) begin
//                    end
//                    else if (err_csl_part4_q.size()==1) begin
//                        if (err_cadd_inject === err_csl_part4_q[0]) begin
//                            gap_release=1;
//                        end
//                    end
//                    else begin
//                        if (err_cadd_inject === err_csl_part4_q[0] || err_cadd_inject === err_csl_part4_q[1]) begin
//                            gap_release=1;
//                        end
//                    end
//                end
//                5:begin
//                    if(err_csl_part5_q.size()==0) begin
//                    end
//                    else if (err_csl_part5_q.size()==1) begin
//                        if (err_cadd_inject === err_csl_part5_q[0]) begin
//                            gap_release=1;
//                        end
//                    end
//                    else begin
//                        if (err_cadd_inject === err_csl_part5_q[0] || err_cadd_inject === err_csl_part5_q[1]) begin
//                            gap_release=1;
//                        end
//                    end
//                end
//                6:begin
//                    if(err_csl_part6_q.size()==0) begin
//                    end
//                    else if (err_csl_part6_q.size()==1) begin
//                        if (err_cadd_inject === err_csl_part6_q[0]) begin
//                            gap_release=1;
//                        end
//                    end
//                    else begin
//                        if (err_cadd_inject === err_csl_part6_q[0] || err_cadd_inject === err_csl_part6_q[1]) begin
//                            gap_release=1;
//                        end
//                    end
//                end
//                7:begin
//                    if(err_csl_part7_q.size()==0) begin
//                    end
//                    else if (err_csl_part7_q.size()==1) begin
//                        if (err_cadd_inject === err_csl_part7_q[0]) begin
//                            gap_release=1;
//                        end
//                    end
//                    else begin
//                        if (err_cadd_inject === err_csl_part7_q[0] || err_cadd_inject === err_csl_part7_q[1]) begin
//                            gap_release=1;
//                        end
//                    end
//                end
//                8:begin
//                    if(err_csl_part8_q.size()==0) begin
//                    end
//                    else if (err_csl_part8_q.size()==1) begin
//                        if (err_cadd_inject === err_csl_part8_q[0]) begin
//                            gap_release=1;
//                        end
//                    end
//                    else begin
//                        if (err_cadd_inject === err_csl_part8_q[0] || err_cadd_inject === err_csl_part8_q[1]) begin
//                            gap_release=1;
//                        end
//                    end
//                end
//                9:begin
//                    if(err_csl_part9_q.size()==0) begin
//                    end
//                    else if (err_csl_part9_q.size()==1) begin
//                        if (err_cadd_inject === err_csl_part9_q[0]) begin
//                            gap_release=1;
//                        end
//                    end
//                    else begin
//                        if (err_cadd_inject === err_csl_part9_q[0] || err_cadd_inject === err_csl_part9_q[1]) begin
//                            gap_release=1;
//                        end
//                    end
//                end
//            endcase
//
//            exp_err_row_tmp_q2 = exp_err_row_tmp_q.find with (item == err_radd_inject);
//            if(exp_err_row_tmp_q2.size()>0) begin
//                gap_release=1;
//            end
//
//            //err release
//            if(!gap_release) begin
//                //`uvm_info("hard_fail_release",$sformatf("release addr is radd %0h, cadd %0h", err_radd_inject, err_cadd_inject),UVM_LOW)
//                for(int kk=0;kk<data_index_range;kk++) begin
//                    data_index = kk;
//                    case(hard_error_record[{err_radd_inject, err_cadd_inject, data_index}])
//                        1:begin
//                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
//                            `uvm_info("hard_fail_release",$sformatf("release addr is radd %0h, cadd %0h", err_radd_inject, err_cadd_inject),UVM_MEDIUM)
//                        end
//
//                        2:begin
//                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d][%0d]", {err_radd_inject,err_cadd_inject},data_index));
//                            `uvm_info("hard_fail_release",$sformatf("release addr is radd %0h, cadd %0h", err_radd_inject, err_cadd_inject),UVM_MEDIUM)
//                        end
//                        0:begin
//                        end
//
//                    endcase
//                end
//            end
//            gap_release=0;
//        end
//    end
//
//endtask:hard_fail_release

function int mc_bist_rescan_vseq::caculate_vmc_cnt(input bit [`ROW_ADDR_WIDTH-1:0] row_in, input bit [`COLUMN_ADDR_WIDTH-1:0] cadd_in);

    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_reg;
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_reg_q[$];

    //caculate vmc cnt
    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", caculate_row_part(row_in)), read_err_csl_reg);
    read_err_csl_reg_q.push_back(read_err_csl_reg);
    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", caculate_row_part(row_in)), read_err_csl_reg);
    read_err_csl_reg_q.push_back(read_err_csl_reg);

    read_err_csl_reg_q.sort();
    //`uvm_info(get_type_name(),$sformatf("part is %0d, cadd_in is %0h, read_err_csl_reg is %0h", caculate_row_part(row_in), cadd_in, read_err_csl_reg),UVM_LOW)
    if (cadd_in >= read_err_csl_reg_q[0])    begin
        caculate_vmc_cnt = caculate_vmc_cnt + 'b1;
    end

    if ((cadd_in + caculate_vmc_cnt) >= read_err_csl_reg_q[1])     begin
        //`uvm_info(get_type_name(),$sformatf("part is %0d, cadd_in is %0h, read_err_csl_reg is %0h", caculate_row_part(row_in), cadd_in+ caculate_vmc_cnt, read_err_csl_reg),UVM_LOW)
        caculate_vmc_cnt = caculate_vmc_cnt + 'b1;
    end

endfunction:caculate_vmc_cnt

function bit [3:0] mc_bist_rescan_vseq::caculate_row_part(input bit [`ROW_ADDR_WIDTH-1:0] row_in);

    int part_tmp;
    int row_num_per_part;

    row_num_per_part = BIST_WL_NUM / PART_NUM;

    part_tmp = row_in/row_num_per_part;

    if (part_tmp >= PART_NUM) begin
        `uvm_error(get_type_name(), $sformatf("err row input %0h", row_in))
    end

    caculate_row_part = part_tmp;

endfunction:caculate_row_part

function bit [`ARRAY_DATA_WIDTH-1:0] mc_bist_rescan_vseq::caculate_gold_pattern_data(input bit [`PATTERN_WIDTH-1:0] pattern_using, input bit [`ROW_ADDR_WIDTH-1:0] row_in);

    bit [`ARRAY_DATA_WIDTH-1:0]     golden_data[4];

    for(int i=0;i<4;i++) begin
        golden_data[i] = {{34{pattern_using[i*8+:8]}}};
    end

    caculate_gold_pattern_data = golden_data[row_in%4];

endfunction:caculate_gold_pattern_data
`endif
