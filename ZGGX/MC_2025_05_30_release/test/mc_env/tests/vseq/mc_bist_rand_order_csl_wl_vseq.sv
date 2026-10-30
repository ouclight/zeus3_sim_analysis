`ifndef MC_BIST_RAND_ORDER_CSL_WL_VSEQ
`define MC_BIST_RAND_ORDER_CSL_WL_VSEQ

class mc_bist_rand_order_csl_wl_vseq extends mc_common_vseq;
    `uvm_object_utils(mc_bist_rand_order_csl_wl_vseq)

    function new(string name="mc_bist_rand_order_csl_wl_vseq");
        super.new();
    endfunction

    localparam      COL_ALL_NUM='d130;
    localparam      COL_NUM='d128;
    localparam      BIST_WL_NUM='d300;

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

    rand bit [`ROW_ADDR_WIDTH-1:0]                 radd_up_down[10];

    //err_inject
    rand int                        num_csl_err_inject;
    rand int                        err_csl_num_rand[10];               //num of err csl
    rand bit                        err_force_mode;                 //0: 1st pattern right, 2nd pattern error; 1: 1st pattern error, 2nd pattern right
    rand bit                        wl_success_mode;                //to limit err row num, 1:wl success, <=64;0: wl err_num rand

    bit                             err_addr[BIST_WL_NUM-1:0][COL_ALL_NUM-1:0];
    bit [1:0]                       scan_redundant_csl[10];          //0: this part do not scan_redundant_csl; 1:scan 1 redundant csl; 2:scan 2 redundant csl
    bit [`ROW_ADDR_WIDTH-1:0]       err_wl_addr_q[$];                  //exclude csl vmc err row, err wl which can be scaned in wl scan
    bit [4:0]                       exp_csl_fail;
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

    //array param
    rand bit [`COLUMN_ADDR_WIDTH-1:0]   cadd_array;
    rand bit [`ROW_ADDR_WIDTH-1:0]      radd_array;

    constraint c_radd_up_down{

        radd_up_down[0] dist {[0:(BIST_WL_NUM/10 - 1)]:/50, 0:/25, (BIST_WL_NUM/10-1):/25};
        radd_up_down[1] dist {[(BIST_WL_NUM*1/10):(BIST_WL_NUM*2/10)-1]:/50, (BIST_WL_NUM/10):/25, (BIST_WL_NUM*2/10-1):/25};
        radd_up_down[2] dist {[(BIST_WL_NUM*2/10):(BIST_WL_NUM*3/10)-1]:/50, (BIST_WL_NUM*2/10):/25, (BIST_WL_NUM*3/10-1):/25};
        radd_up_down[3] dist {[(BIST_WL_NUM*3/10):(BIST_WL_NUM*4/10)-1]:/50, (BIST_WL_NUM*3/10):/25, (BIST_WL_NUM*4/10-1):/25};
        radd_up_down[4] dist {[(BIST_WL_NUM*4/10):(BIST_WL_NUM*5/10)-1]:/50, (BIST_WL_NUM*4/10):/25, (BIST_WL_NUM*5/10-1):/25};
        radd_up_down[5] dist {[(BIST_WL_NUM*5/10):(BIST_WL_NUM*6/10)-1]:/50, (BIST_WL_NUM*5/10):/25, (BIST_WL_NUM*6/10-1):/25};
        radd_up_down[6] dist {[(BIST_WL_NUM*6/10):(BIST_WL_NUM*7/10)-1]:/50, (BIST_WL_NUM*6/10):/25, (BIST_WL_NUM*7/10-1):/25};
        radd_up_down[7] dist {[(BIST_WL_NUM*7/10):(BIST_WL_NUM*8/10)-1]:/50, (BIST_WL_NUM*7/10):/25, (BIST_WL_NUM*8/10-1):/25};
        radd_up_down[8] dist {[(BIST_WL_NUM*8/10):(BIST_WL_NUM*9/10)-1]:/50, (BIST_WL_NUM*8/10):/25, (BIST_WL_NUM*9/10-1):/25};
        radd_up_down[9] dist {[(BIST_WL_NUM*9/10):(BIST_WL_NUM*10/10)-1]:/50, (BIST_WL_NUM*9/10):/25, (BIST_WL_NUM-1):/25};
    }

    constraint c_cadd_array{
        cadd_array inside {[0:COL_ALL_NUM-1]};
    }    
    constraint c_radd_array { 
        radd_array inside {[0:BIST_WL_NUM-1]};
    }

    constraint c_bist_csl_scan_num{
        bist_csl_scan_num inside {[2:4]};
    }

    constraint c_bist_wl_scan_num{
        bist_wl_scan_num inside {[2:4]};
    }

    constraint c_bist_wl_scan_single_pattern_rd_num{
        bist_wl_scan_single_pattern_rd_num  inside {['d0:'d15]}; 
    }

    constraint c_csl_err_threshold{
        //csl_err_threshold dist {[1:31]:/40, 31:/20, 16:/20, 1:/20};
        csl_err_threshold dist {[1:29]:/40, 30:/20, 16:/20};
    }

    constraint c_num_csl_err_inject {
        num_csl_err_inject inside {['d0:'d30]};     //per part col err row num
    }

    constraint c_err_csl_num_rand {
        foreach(err_csl_num_rand[i]) 
            err_csl_num_rand[i] inside {[0:3]};
    }


    extern virtual task body();
    extern task gen_err_csl(input bit [3:0] part, output bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$]);
    extern task gen_err_row(input bit[3:0] part, input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$]);
    extern task gen_exp_csl(input bit [3:0] part, input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$], output bit [`COLUMN_ADDR_WIDTH-1:0] exp_err_csl_partx[2:0][2:0]);
    extern task exp_csl_check(input bit [3:0] part, input int pattern_index, input bit [`COLUMN_ADDR_WIDTH-1:0] now_cadd, input bit [`COLUMN_ADDR_WIDTH-1:0] exp_err_csl_partx[2:0][2:0], input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$], ref bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_finial_check[1:0]);

    extern function bit [3:0] caculate_row_part(input bit [`ROW_ADDR_WIDTH-1:0] row_in);
    extern function int caculate_vmc_cnt(input bit [`ROW_ADDR_WIDTH-1:0] row_in, input bit [`COLUMN_ADDR_WIDTH-1:0] cadd_in);

endclass:mc_bist_rand_order_csl_wl_vseq

task mc_bist_rand_order_csl_wl_vseq::body();

    bit                                     bist_finish;

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

    //err row 
    bit [`ROW_ADDR_WIDTH-1:0]    err_row_pattern0_q[$];
    bit [`ROW_ADDR_WIDTH-1:0]    err_row_pattern1_q[$];
    bit [`ROW_ADDR_WIDTH-1:0]    err_row_pattern2_q[$];
    bit [`ROW_ADDR_WIDTH-1:0]    err_row_pattern3_q[$];
    bit [`ROW_ADDR_WIDTH-1:0]    err_row_pattern4_q[$];
    bit [`ROW_ADDR_WIDTH-1:0]    err_row_pattern5_q[$];
    bit [`ROW_ADDR_WIDTH-1:0]    err_row_pattern6_q[$];
    bit [`ROW_ADDR_WIDTH-1:0]    err_row_pattern7_q[$];
    bit [`ROW_ADDR_WIDTH-1:0]    err_row_pattern8_q[$];
    bit [`ROW_ADDR_WIDTH-1:0]    err_row_pattern9_q[$];

    //err_inject
    bit [`ROW_ADDR_WIDTH-1:0]       radd_tmp;
    bit [`COLUMN_ADDR_WIDTH-1:0]    cadd_tmp;

    //check
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part0[2:0][2:0];    //[2:0]  pattern index, [2:0]   csl 
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part1[2:0][2:0];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part2[2:0][2:0];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part3[2:0][2:0];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part4[2:0][2:0];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part5[2:0][2:0];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part6[2:0][2:0];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part7[2:0][2:0];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part8[2:0][2:0];
    bit [`COLUMN_ADDR_WIDTH-1:0]    exp_err_csl_part9[2:0][2:0];

    bit [`ROW_ADDR_WIDTH-1:0]       read_err_row_reg;
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_reg;

    bit [`ROW_ADDR_WIDTH+2-1:0]       exp_err_row_reg_q[$];        //{2bits 4 pattern index check info, row addr width}
    bit [`ROW_ADDR_WIDTH-1:0]         read_err_row_reg_q[$];        //{2bits 4 pattern index check info, row addr width}

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

    //csl final check
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part0_finial_check[1:0] = '{'hff, 'hff};
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part1_finial_check[1:0] = '{'hff, 'hff};
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part2_finial_check[1:0] = '{'hff, 'hff};
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part3_finial_check[1:0] = '{'hff, 'hff};
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part4_finial_check[1:0] = '{'hff, 'hff};
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part5_finial_check[1:0] = '{'hff, 'hff};
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part6_finial_check[1:0] = '{'hff, 'hff};
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part7_finial_check[1:0] = '{'hff, 'hff};
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part8_finial_check[1:0] = '{'hff, 'hff};
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_part9_finial_check[1:0] = '{'hff, 'hff};

   
    bit                             csl_fail;
    bit                             wl_fail;


    bit [`COLUMN_ADDR_WIDTH-1:0]    csl_fail_col_addr='hff;
    bit [`ROW_ADDR_WIDTH-1:0]       csl_fail_row_addr='h1fff;
    bit [6:0]                       csl_fail_point='b111_1111;     //[5:3] which pattern fail, [2:0] which part fail
    bit                             gap_check;                    //1:gap_check

    //int                             now_pattern_cnt;                //to indicate which pattern is being used during bist 
    //bit                             csl_pattern_cnt_clr;
    //bit                             wl_pattern_cnt_clr;
    int                             tmp_cnt;
    int                             vmc_cnt;                        //used to check wl scan addr after csl vmc
    //event                           one_pattern_done;

    super.body();

    assert(randomize() with{
        //bist_csl_scan_num == 2;
        //bist_wl_scan_num == 2;
        //wl_success_mode == 0;
        
    });


    uvm_hdl_deposit($sformatf("mc_tb.u_quad_group.XBK0.memory[0]"),'b0);

    //close scb check
    m_tb_if.bist_test_en = 1'b1;

    //bist_finish_mask
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_mask.write(status,bist_finish_mask,UVM_FRONTDOOR);
    `uvm_info(get_type_name(),$sformatf("bist_finish_mask is %0b", bist_finish_mask),UVM_LOW)

    //bist_wl_scan_single_pattern_rd_num
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
    m_tb_if.bist_pattern[0] = 'h0000_0000;
    m_tb_if.bist_pattern[1] = 'hffff_ffff;
    m_tb_if.bist_pattern[2] = $urandom_range(1)? 'h5a5a_5a5a:'ha5a5_a5a5;
    m_tb_if.bist_pattern[3] = ~m_tb_if.bist_pattern[2];

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
    err_wl_addr_q.sort();
    $display("err row is :");
    foreach (err_wl_addr_q[i]) begin
        $write("%0h  ",err_wl_addr_q[i]);
    end
    $display("err row num is %0d", err_wl_addr_q.size());
    $display("");


    //----------------- err inject ---------------------

    //bound
    assert(randomize(radd_array, cadd_array) with{
        radd_array == BIST_WL_NUM/2;
        cadd_array == COL_ALL_NUM/2;
    });

    //err injetc
    foreach (err_addr[i,j]) begin
        if (err_addr[i][j] == 'b1) begin
            radd_tmp = i;
            cadd_tmp = j;
            if ((!err_force_mode && (cadd_tmp < cadd_array)) || (err_force_mode &&  (cadd_tmp >= cadd_array))) begin
            //divided by cadd, left is 0, right is 1
                //`uvm_info("force mem", $sformatf("force mem addr is %0h, %0h", i, j), UVM_LOW)
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d][0]", {radd_tmp,cadd_tmp}),'b0);
                //`uvm_info("force mem", $sformatf("mc_tb.u_quad_group.XBK0.memory[%0d][0]", {radd_tmp,cadd_tmp}), UVM_LOW)
            end
            else begin
                //`uvm_info("force mem", $sformatf("force mem addr is %0h, %0h", i, j), UVM_LOW)
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d][0]", {radd_tmp,cadd_tmp}),'b1);
                //`uvm_info("force mem", $sformatf("mc_tb.u_quad_group.XBK0.memory[%0d][0]", {radd_tmp,cadd_tmp}), UVM_LOW)
            end
        end
    end

    //---- exp err csl gen ----

    //gen
    gen_exp_csl('d0, err_csl_part0_q, exp_err_csl_part0);
    gen_exp_csl('d1, err_csl_part1_q, exp_err_csl_part1);
    gen_exp_csl('d2, err_csl_part2_q, exp_err_csl_part2);
    gen_exp_csl('d3, err_csl_part3_q, exp_err_csl_part3);
    gen_exp_csl('d4, err_csl_part4_q, exp_err_csl_part4);
    gen_exp_csl('d5, err_csl_part5_q, exp_err_csl_part5);
    gen_exp_csl('d6, err_csl_part6_q, exp_err_csl_part6);
    gen_exp_csl('d7, err_csl_part7_q, exp_err_csl_part7);
    gen_exp_csl('d8, err_csl_part8_q, exp_err_csl_part8);
    gen_exp_csl('d9, err_csl_part9_q, exp_err_csl_part9);

    for(int i=0;i<3;i++) begin
        for(int j=0;j<3;j++) begin
            $display("exp_err_csl_part0[%0d][%0d], %0h",i,j,exp_err_csl_part0[i][j]);
            $display("exp_err_csl_part1[%0d][%0d], %0h",i,j,exp_err_csl_part1[i][j]);
            $display("exp_err_csl_part2[%0d][%0d], %0h",i,j,exp_err_csl_part2[i][j]);
            $display("exp_err_csl_part3[%0d][%0d], %0h",i,j,exp_err_csl_part3[i][j]);
            $display("exp_err_csl_part4[%0d][%0d], %0h",i,j,exp_err_csl_part4[i][j]);
            $display("exp_err_csl_part5[%0d][%0d], %0h",i,j,exp_err_csl_part5[i][j]);
            $display("exp_err_csl_part6[%0d][%0d], %0h",i,j,exp_err_csl_part6[i][j]);
            $display("exp_err_csl_part7[%0d][%0d], %0h",i,j,exp_err_csl_part7[i][j]);
            $display("exp_err_csl_part8[%0d][%0d], %0h",i,j,exp_err_csl_part8[i][j]);
            $display("exp_err_csl_part9[%0d][%0d], %0h",i,j,exp_err_csl_part9[i][j]);
        end
    end

    //gen csl fail point
    if (exp_csl_fail) begin
        for (int i=0;i<3;i++) begin
            if (exp_err_csl_part0[i][2] != ERR_CSL_DEFAULT_VALUE) begin
                csl_fail_col_addr = exp_err_csl_part0[i][2];
                csl_fail_point = {i[2:0], 4'b0};
                break;
            end
            else if (exp_err_csl_part1[i][2] != ERR_CSL_DEFAULT_VALUE) begin
                csl_fail_col_addr = exp_err_csl_part1[i][2];
                csl_fail_point = {i[2:0], 4'b1};
                break;
            end
            else if (exp_err_csl_part2[i][2] != ERR_CSL_DEFAULT_VALUE) begin
                csl_fail_col_addr = exp_err_csl_part2[i][2];
                csl_fail_point = {i[2:0], 4'd2};
                break;
            end
            else if (exp_err_csl_part3[i][2] != ERR_CSL_DEFAULT_VALUE) begin
                csl_fail_col_addr = exp_err_csl_part3[i][2];
                csl_fail_point = {i[2:0], 4'd3};
                break;
            end
            else if (exp_err_csl_part4[i][2] != ERR_CSL_DEFAULT_VALUE) begin
                csl_fail_col_addr = exp_err_csl_part4[i][2];
                csl_fail_point = {i[2:0], 4'd4};
                break;
            end
            else if (exp_err_csl_part5[i][2] != ERR_CSL_DEFAULT_VALUE) begin
                csl_fail_col_addr = exp_err_csl_part5[i][2];
                csl_fail_point = {i[2:0], 4'd5};
                break;
            end
            else if (exp_err_csl_part6[i][2] != ERR_CSL_DEFAULT_VALUE) begin
                csl_fail_col_addr = exp_err_csl_part6[i][2];
                csl_fail_point = {i[2:0], 4'd6};
                break;
            end
            else if (exp_err_csl_part7[i][2] != ERR_CSL_DEFAULT_VALUE) begin
                csl_fail_col_addr = exp_err_csl_part7[i][2];
                csl_fail_point = {i[2:0], 4'd7};
                break;
            end
            else if (exp_err_csl_part8[i][2] != ERR_CSL_DEFAULT_VALUE) begin
                csl_fail_col_addr = exp_err_csl_part8[i][2];
                csl_fail_point = {i[2:0], 4'd8};
                break;
            end
            else if (exp_err_csl_part9[i][2] != ERR_CSL_DEFAULT_VALUE) begin
                csl_fail_col_addr = exp_err_csl_part9[i][2];
                csl_fail_point = {i[2:0], 4'd9};
                break;
            end
        end
    end
    `uvm_info("csl fail exp param", $sformatf("csl_fail_col_addr is %0h, csl fail pattern is %0d, csl fail part is %0d", csl_fail_col_addr, csl_fail_point[6:4], csl_fail_point[3:0]),UVM_LOW)

    //-------------------------

    //exp err row gen
    if (!exp_csl_fail) begin
        `uvm_info("exp row addr gen", "exp row addr gen start !!", UVM_LOW)
        foreach(err_wl_addr_q[i]) begin
            //$display("case mode is %0b", {!err_force_mode, caculate_row_part(err_wl_addr_q[i])});
            case({!err_force_mode, caculate_row_part(err_wl_addr_q[i])})
                //left0
                5'b10000: begin    //part0
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part0_q[0] || j== err_csl_part0_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part0_q[0] || j== err_csl_part0_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                end
                5'b10001: begin    //part1
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part1_q[0] || j== err_csl_part1_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part1_q[0] || j== err_csl_part1_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b10010: begin    //part2
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part2_q[0] || j== err_csl_part2_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part2_q[0] || j== err_csl_part2_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b10011: begin    //part3
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part3_q[0] || j== err_csl_part3_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part3_q[0] || j== err_csl_part3_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b10100: begin    //part4
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part4_q[0] || j== err_csl_part4_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part4_q[0] || j== err_csl_part4_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b10101: begin    //part5
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part5_q[0] || j== err_csl_part5_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part5_q[0] || j== err_csl_part5_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b10110: begin    //part6
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part6_q[0] || j== err_csl_part6_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part6_q[0] || j== err_csl_part6_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b10111: begin    //part7
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part7_q[0] || j== err_csl_part7_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part7_q[0] || j== err_csl_part7_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b11000: begin    //part8
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part8_q[0] || j== err_csl_part8_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part8_q[0] || j== err_csl_part8_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b11001: begin    //part9
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part9_q[0] || j== err_csl_part9_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part9_q[0] || j== err_csl_part9_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                end

                //left 1
                5'b00000: begin    //part0
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part0_q[0] || j== err_csl_part0_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part0_q[0] || j== err_csl_part0_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                end
                5'b00001: begin    //part1
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part1_q[0] || j== err_csl_part1_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part1_q[0] || j== err_csl_part1_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b00010: begin    //part2
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part2_q[0] || j== err_csl_part2_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part2_q[0] || j== err_csl_part2_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b00011: begin    //part3
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part3_q[0] || j== err_csl_part3_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part3_q[0] || j== err_csl_part3_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b00100: begin    //part4
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part4_q[0] || j== err_csl_part4_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part4_q[0] || j== err_csl_part4_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b00101: begin    //part5
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part5_q[0] || j== err_csl_part5_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part5_q[0] || j== err_csl_part5_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b00110: begin    //part6
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part6_q[0] || j== err_csl_part6_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part6_q[0] || j== err_csl_part6_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b00111: begin    //part7
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part7_q[0] || j== err_csl_part7_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part7_q[0] || j== err_csl_part7_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b01000: begin    //part8
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part8_q[0] || j== err_csl_part8_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part8_q[0] || j== err_csl_part8_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                end

                5'b01001: begin    //part9
                    for (int j=0;j<cadd_array;j++) begin    //force 0
                        if(j == err_csl_part9_q[0] || j== err_csl_part9_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 1 check
                            exp_err_row_reg_q.push_back({2'b0,err_wl_addr_q[i]});
                        end
                    end
                    for (int j=cadd_array;j<COL_ALL_NUM;j++) begin    //force 1
                        if(j == err_csl_part9_q[0] || j== err_csl_part9_q[1]) begin
                            continue;
                        end
                        if (err_addr[err_wl_addr_q[i]][j]) begin //err row using 0 check
                            exp_err_row_reg_q.push_back({2'b1,err_wl_addr_q[i]});
                        end
                    end
                end
                default:
                    `uvm_error("exp row gen", "err case variable")
            endcase
        end
        exp_err_row_reg_q.sort();
        exp_err_row_reg_q = exp_err_row_reg_q.unique();
    end


    //foreach(exp_err_row_reg_q[i]) begin
    //    $display("exp err row  pattern%0d, %0h",exp_err_row_reg_q[i][`ROW_ADDR_WIDTH+2-1-:2], exp_err_row_reg_q[i][`ROW_ADDR_WIDTH-1:0]);
    //end

    //each pattern exp err row
    foreach(exp_err_row_reg_q[i]) begin
        case (exp_err_row_reg_q[i][`ROW_ADDR_WIDTH+2-1-:2])
            2'b00: begin    //pattern 0 check
                err_row_pattern0_q.push_back(exp_err_row_reg_q[i][`ROW_ADDR_WIDTH-1:0]);
            end
            2'b01: begin    //pattern 1 check
                err_row_pattern1_q.push_back(exp_err_row_reg_q[i][`ROW_ADDR_WIDTH-1:0]);
            end
            default:    
                `uvm_error("exp row gen", "err case variable")
        endcase
    end

    err_row_pattern1_q = {err_row_pattern0_q, err_row_pattern1_q};
        
    if (err_row_pattern0_q.size()<64) begin
        tmp_cnt = 64-err_row_pattern0_q.size();
        for(int i=0;i<tmp_cnt;i++) begin
            err_row_pattern0_q.push_front(ERR_WL_DEFAULT_VALUE);
        end
    end

    err_row_pattern1_q = err_row_pattern1_q.unique();
    if (err_row_pattern1_q.size()<64) begin
        tmp_cnt = 64-err_row_pattern1_q.size();
        for(int i=0;i<tmp_cnt;i++) begin
            err_row_pattern1_q.push_front(ERR_WL_DEFAULT_VALUE);
        end
    end

    //foreach(err_row_pattern0_q[i]) begin
    //    $display("err row pattern0 %0d, %0h",i, err_row_pattern0_q[i]);
    //end
    //foreach(err_row_pattern1_q[i]) begin
    //    $display("err row pattern1 %0d, %0h",i, err_row_pattern1_q[i]);
    //end

    if (err_wl_addr_q.size()>64)    exp_wl_fail = 1'b1;

    //--------------------------------------------------


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
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status, 'b1,UVM_FRONTDOOR);
    //global_mc_bist_en
    @(posedge m_tb_if.pclk);
    m_tb_if.global_mc_bist_en = 1'b1;

    `ifndef NO_INIT
    //wait dram_init_finish
    //do begin
    //    repeat (1000) @(posedge m_tb_if.clk);
    //    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_status_reg.dram_init_finish.read(status, dram_init_finish, UVM_FRONTDOOR);
    //end while(dram_init_finish != 1);
    wait(m_tb_if.mc_dram_init_wr_finish == 1);
    repeat(4) @(posedge m_tb_if.clk);
    `endif

    //-------------------- global_mc_bist_start -----------------------
    `uvm_info(get_type_name(),"bist scan start!",UVM_LOW)
    @(posedge m_tb_if.pclk)
    m_tb_if.global_mc_bist_start = 1'b1;
    @(posedge m_tb_if.pclk)
    m_tb_if.global_mc_bist_start = 1'b0;


    fork :bist_check
        begin
            fork
                begin
                    //------------ csl checker --------------
                    for (int II=0;II<bist_csl_scan_num;II++) begin
                        //write
                        for (int j=0;j<BIST_WL_NUM;j++)begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                @(negedge m_array_agent_if.gcas_wr);
                                if(m_array_agent_if.gradd_n != j)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", j, m_array_agent_if.gradd_n))
                                if(m_array_agent_if.gcadd != i)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", i, m_array_agent_if.gcadd))
                            end
                        end

                        //--------- read part0 -------
                        `uvm_info("get_type_name", "---------------------- read part0 check start ---------------", UVM_LOW)
                        if(!gap_check) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=0;j<(BIST_WL_NUM/10);j++)begin
                                    @(negedge m_array_agent_if.gcas_rd);
                                    if(m_array_agent_if.gradd_n != j)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", j, m_array_agent_if.gradd_n))
                                    if(m_array_agent_if.gcadd != i)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", i, m_array_agent_if.gcadd))
                                end
                                
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[6:4] && 0 == csl_fail_point[3:0] && i == csl_fail_col_addr) begin
                                    gap_check = 1'b1;
                                    break;
                                end
                                //part, pattern, cadd, exp list
                                exp_csl_check('d0, II, i, exp_err_csl_part0, err_csl_part0_q,err_csl_part0_finial_check);
                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part0 check end ---------------", UVM_LOW)
                        //--------- part0 done -------

                        //--------- read part1 -------
                        `uvm_info("get_type_name", "---------------------- read part1 check start ---------------", UVM_LOW)
                        if (!gap_check) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM/10);j<(BIST_WL_NUM*2/10);j++)begin
                                    @(negedge m_array_agent_if.gcas_rd);
                                    if(m_array_agent_if.gradd_n != j)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", j, m_array_agent_if.gradd_n))
                                    if(m_array_agent_if.gcadd != i)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", i, m_array_agent_if.gcadd))
                                end
                                
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[6:4] && 0 == csl_fail_point[3:0] && i == csl_fail_col_addr) begin
                                    gap_check = 1'b1;
                                    break;
                                end
                                //part, pattern, cadd, exp list
                                exp_csl_check('d1, II, i, exp_err_csl_part1, err_csl_part1_q, err_csl_part1_finial_check);

                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part1 check end ---------------", UVM_LOW)
                        //--------- part1 done -------

                        //--------- read part2 -------
                        `uvm_info("get_type_name", "---------------------- read part2 check start ---------------", UVM_LOW)
                        if (!gap_check) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*2/10);j<(BIST_WL_NUM*3/10);j++)begin
                                    @(negedge m_array_agent_if.gcas_rd);
                                    if(m_array_agent_if.gradd_n != j)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", j, m_array_agent_if.gradd_n))
                                    if(m_array_agent_if.gcadd != i)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", i, m_array_agent_if.gcadd))
                                end
                                
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[6:4] && 0 == csl_fail_point[3:0] && i == csl_fail_col_addr) begin
                                    gap_check = 1'b1;
                                    break;
                                end
                                //part, pattern, cadd, exp list
                                exp_csl_check('d2, II, i, exp_err_csl_part2, err_csl_part2_q, err_csl_part2_finial_check);

                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part2 check end ---------------", UVM_LOW)
                        //--------- part2 done -------

                        //--------- read part3 -------
                        `uvm_info("get_type_name", "---------------------- read part3 check start ---------------", UVM_LOW)
                        if (!gap_check) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*3/10);j<(BIST_WL_NUM*4/10);j++)begin
                                    @(negedge m_array_agent_if.gcas_rd);
                                    if(m_array_agent_if.gradd_n != j)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", j, m_array_agent_if.gradd_n))
                                    if(m_array_agent_if.gcadd != i)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", i, m_array_agent_if.gcadd))
                                end
                                
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[6:4] && 0 == csl_fail_point[3:0] && i == csl_fail_col_addr) begin
                                    gap_check = 1'b1;
                                    break;
                                end
                                //part, pattern, cadd, exp list
                                exp_csl_check('d3, II, i, exp_err_csl_part3, err_csl_part3_q, err_csl_part3_finial_check);

                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part3 check end ---------------", UVM_LOW)
                        //--------- part3 done -------

                        //--------- read part4 -------
                        `uvm_info("get_type_name", "---------------------- read part4 check start ---------------", UVM_LOW)
                        if (!gap_check) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*4/10);j<(BIST_WL_NUM*5/10);j++)begin
                                    @(negedge m_array_agent_if.gcas_rd);
                                    if(m_array_agent_if.gradd_n != j)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", j, m_array_agent_if.gradd_n))
                                    if(m_array_agent_if.gcadd != i)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", i, m_array_agent_if.gcadd))
                                end
                                
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[6:4] && 0 == csl_fail_point[3:0] && i == csl_fail_col_addr) begin
                                    gap_check = 1'b1;
                                    break;
                                end
                                //part, pattern, cadd, exp list
                                exp_csl_check('d4, II, i, exp_err_csl_part4, err_csl_part4_q, err_csl_part4_finial_check);

                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part4 check end ---------------", UVM_LOW)
                        //--------- part4 done -------

                        //--------- read part5 -------
                        `uvm_info("get_type_name", "---------------------- read part5 check start ---------------", UVM_LOW)
                        if (!gap_check) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*5/10);j<(BIST_WL_NUM*6/10);j++)begin
                                    @(negedge m_array_agent_if.gcas_rd);
                                    if(m_array_agent_if.gradd_n != j)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", j, m_array_agent_if.gradd_n))
                                    if(m_array_agent_if.gcadd != i)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", i, m_array_agent_if.gcadd))
                                end
                                
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[6:4] && 0 == csl_fail_point[3:0] && i == csl_fail_col_addr) begin
                                    gap_check = 1'b1;
                                    break;
                                end
                                //part, pattern, cadd, exp list
                                exp_csl_check('d5, II, i, exp_err_csl_part5, err_csl_part5_q, err_csl_part5_finial_check);

                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part5 check end ---------------", UVM_LOW)
                        //--------- part5 done -------

                        //--------- read part6 -------
                        `uvm_info("get_type_name", "---------------------- read part6 check start ---------------", UVM_LOW)
                        if (!gap_check) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*6/10);j<(BIST_WL_NUM*7/10);j++)begin
                                    @(negedge m_array_agent_if.gcas_rd);
                                    if(m_array_agent_if.gradd_n != j)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", j, m_array_agent_if.gradd_n))
                                    if(m_array_agent_if.gcadd != i)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", i, m_array_agent_if.gcadd))
                                end
                                
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[6:4] && 0 == csl_fail_point[3:0] && i == csl_fail_col_addr) begin
                                    gap_check = 1'b1;
                                    break;
                                end
                                //part, pattern, cadd, exp list
                                exp_csl_check('d6, II, i, exp_err_csl_part6, err_csl_part6_q, err_csl_part6_finial_check);

                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part6 check end ---------------", UVM_LOW)
                        //--------- part6 done -------

                        //--------- read part7 -------
                        `uvm_info("get_type_name", "---------------------- read part7 check start ---------------", UVM_LOW)
                        if (!gap_check) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*7/10);j<(BIST_WL_NUM*8/10);j++)begin
                                    @(negedge m_array_agent_if.gcas_rd);
                                    if(m_array_agent_if.gradd_n != j)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", j, m_array_agent_if.gradd_n))
                                    if(m_array_agent_if.gcadd != i)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", i, m_array_agent_if.gcadd))
                                end
                                
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[6:4] && 0 == csl_fail_point[3:0] && i == csl_fail_col_addr) begin
                                    gap_check = 1'b1;
                                    break;
                                end
                                //part, pattern, cadd, exp list
                                exp_csl_check('d7, II, i, exp_err_csl_part7, err_csl_part7_q, err_csl_part7_finial_check);

                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part7 check end ---------------", UVM_LOW)
                        //--------- part7 done -------

                        //--------- read part8 -------
                        `uvm_info("get_type_name", "---------------------- read part8 check start ---------------", UVM_LOW)
                        if (!gap_check) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*8/10);j<(BIST_WL_NUM*9/10);j++)begin
                                    @(negedge m_array_agent_if.gcas_rd);
                                    if(m_array_agent_if.gradd_n != j)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", j, m_array_agent_if.gradd_n))
                                    if(m_array_agent_if.gcadd != i)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", i, m_array_agent_if.gcadd))
                                end
                                
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[6:4] && 0 == csl_fail_point[3:0] && i == csl_fail_col_addr) begin
                                    gap_check = 1'b1;
                                    break;
                                end
                                //part, pattern, cadd, exp list
                                exp_csl_check('d8, II, i, exp_err_csl_part8, err_csl_part8_q, err_csl_part8_finial_check);

                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part8 check end ---------------", UVM_LOW)
                        //--------- part8 done -------

                        //--------- read part9 -------
                        `uvm_info("get_type_name", "---------------------- read part9 check start ---------------", UVM_LOW)
                        if (!gap_check) begin
                            for (int i=0;i<COL_ALL_NUM;i++) begin
                                for (int j=(BIST_WL_NUM*9/10);j<(BIST_WL_NUM*10/10);j++)begin
                                    @(negedge m_array_agent_if.gcas_rd);
                                    if(m_array_agent_if.gradd_n != j)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", j, m_array_agent_if.gradd_n))
                                    if(m_array_agent_if.gcadd != i)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp cadd is %0h, act is %0h", i, m_array_agent_if.gcadd))
                                end
                                
                                //per col check
                                //waitting for rvalid back to bist module
                                repeat(15) @(posedge m_tb_if.clk); 

                                if (II == csl_fail_point[6:4] && 0 == csl_fail_point[3:0] && i == csl_fail_col_addr) begin
                                    gap_check = 1'b1;
                                    break;
                                end
                                //part, pattern, cadd, exp list
                                exp_csl_check('d9, II, i, exp_err_csl_part9, err_csl_part9_q, err_csl_part9_finial_check);

                            end
                        end
                        `uvm_info("get_type_name", "---------------------- read part9 check end ---------------", UVM_LOW)
                        //--------- part9 done -------


                        //now_pattern_cnt = now_pattern_cnt + 'b1;
                        //if (now_pattern_cnt >= bist_csl_scan_num) begin
                        //    now_pattern_cnt = 'b0;
                        //end
                        if (II == csl_fail_point[6:4])
                            break;
                    end


                    //------------ csl checker done --------------

                    `uvm_info(get_type_name(), $sformatf("exp_csl_fail is %0b",exp_csl_fail),UVM_LOW)
                    if (!exp_csl_fail) begin
                    //------------ wl checker --------------
                        `uvm_info(get_type_name(), $sformatf("wl checker start!!"),UVM_LOW)
                        for (int II=0;II<bist_wl_scan_num;II++) begin
                            //write
                            for (int j=0;j<BIST_WL_NUM;j++)begin
                                for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                    @(negedge m_array_agent_if.gcas_wr);
                                    if(m_array_agent_if.gradd_n != j)  `uvm_error(get_type_name(), $sformatf(" addr error, exp radd is %0h, act is %0h", j, m_array_agent_if.gradd_n))

                                    vmc_cnt = caculate_vmc_cnt(j,i);

                                    if(m_array_agent_if.gcadd != i+vmc_cnt)  `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_array_agent_if.gcadd))
                                end
                            end

                            for (int k=0;k<(bist_wl_scan_single_pattern_rd_num+'b1);k++) begin
                                //read
                                for (int j=0;j<BIST_WL_NUM;j++)begin
                                    for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                        @(negedge m_array_agent_if.gcas_rd);
                                        if(m_array_agent_if.gradd_n != j)  `uvm_error(get_type_name(), $sformatf("rescan addr error, exp radd is %0h, act is %0h", j, m_array_agent_if.gradd_n))
                                        vmc_cnt = caculate_vmc_cnt(j,i);

                                        if(m_array_agent_if.gcadd != i+vmc_cnt)  `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_array_agent_if.gcadd))
                                    end

                                end
                            end

                            //exp row check
                            for(int kk=0;kk<64;kk++) begin
                                uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.err_wl%0d", kk), read_err_row_reg);
                                read_err_row_reg_q.push_front(read_err_row_reg);
                            end

                            `uvm_info(get_type_name(), $sformatf("read_err_row_reg_q size is %0d", read_err_row_reg_q.size()),UVM_LOW)
                            foreach(read_err_row_reg_q[ii]) begin
                                case(II)
                                    0: begin
                                        if(read_err_row_reg_q[ii] != err_row_pattern0_q[ii]) begin
                                            `uvm_error("err row check", $sformatf("num %0d, exp is %0h, act is %0h", ii, err_row_pattern0_q[ii], read_err_row_reg_q[ii]))
                                        end
                                        else begin
                                            `uvm_info("err row check", $sformatf("num %0d, check pass is %0h", ii, err_row_pattern0_q[ii]),UVM_LOW)
                                        end

                                    end
                                    1:begin
                                        if(read_err_row_reg_q[ii] != err_row_pattern1_q[ii]) begin
                                            `uvm_error("err row check", $sformatf("num %0d, exp is %0h, act is %0h", ii, err_row_pattern1_q[ii], read_err_row_reg_q[ii]))
                                        end
                                        else begin
                                            `uvm_info("err row check", $sformatf("num %0d, check pass is %0h", ii, err_row_pattern1_q[ii]),UVM_LOW)
                                        end
                                    end
                                    2:begin
                                        if(read_err_row_reg_q[ii] != err_row_pattern1_q[ii]) begin
                                            `uvm_error("err row check", $sformatf("num %0d, exp is %0h, act is %0h", ii, err_row_pattern1_q[ii], read_err_row_reg_q[ii]))
                                        end
                                        else begin
                                            `uvm_info("err row check", $sformatf("num %0d, check pass is %0h", ii, err_row_pattern1_q[ii]),UVM_LOW)
                                        end
                                    end
                                    3:begin
                                        if(read_err_row_reg_q[ii] != err_row_pattern1_q[ii]) begin
                                            `uvm_error("err row check", $sformatf("num %0d, exp is %0h, act is %0h", ii, err_row_pattern1_q[ii], read_err_row_reg_q[ii]))
                                        end
                                        else begin
                                            `uvm_info("err row check", $sformatf("num %0d, check pass is %0h", ii, err_row_pattern1_q[ii]),UVM_LOW)
                                        end
                                    end

                                    default:
                                        `uvm_error("exp row gen", "err case variable")
                                endcase
                            end

                            read_err_row_reg_q.delete();
                        
                        end
                    end

                end
                begin
                    //while(1) begin
                    //end
                end

                begin
                    do begin
                        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish.peek(status,bist_finish);
                        repeat(1000) @(posedge m_tb_if.clk);
                    end while(bist_finish != 1'b1);
                    disable bist_check;
                end
            join
        end
    join

    //all csl pattern done, check

    //foreach(err_csl_part0_finial_check[m]) begin
    //    $display("err_csl_part0_finial_check[%0d] is %0h", m, err_csl_part0_finial_check[m]);
    //    $display("err_csl_part1_finial_check[%0d] is %0h", m, err_csl_part1_finial_check[m]);
    //    $display("err_csl_part2_finial_check[%0d] is %0h", m, err_csl_part2_finial_check[m]);
    //    $display("err_csl_part3_finial_check[%0d] is %0h", m, err_csl_part3_finial_check[m]);
    //    $display("err_csl_part4_finial_check[%0d] is %0h", m, err_csl_part4_finial_check[m]);
    //end

    //------- part0 check ----------
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", 0), read_err_csl_reg);
    read_err_csl_part0_q.push_back(read_err_csl_reg);
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", 0), read_err_csl_reg);
    read_err_csl_part0_q.push_back(read_err_csl_reg);
    foreach(read_err_csl_part0_q[i]) begin
        if(read_err_csl_part0_q[i] != err_csl_part0_finial_check[i])   
            `uvm_error("csl check error", $sformatf("exp is %0h, act is %0h", err_csl_part0_finial_check[i], read_err_csl_part0_q[i]))
        else 
            `uvm_info("csl check", $sformatf("err csl check pass is %0h", err_csl_part0_finial_check[i]), UVM_LOW)
    end

    //------- part1 check ----------
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", 1), read_err_csl_reg);
    read_err_csl_part1_q.push_back(read_err_csl_reg);
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", 1), read_err_csl_reg);
    read_err_csl_part1_q.push_back(read_err_csl_reg);
    foreach(read_err_csl_part1_q[i]) begin
        $display("i is %0d", i);
        if(read_err_csl_part1_q[i] != err_csl_part1_finial_check[i])   
            `uvm_error("csl check error", $sformatf("exp is %0h, act is %0h", err_csl_part1_finial_check[i], read_err_csl_part1_q[i]))
        else 
            `uvm_info("csl check", $sformatf("err csl check pass is %0h", err_csl_part1_finial_check[i]), UVM_LOW)
    end

    //------- part2 check ----------
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", 2), read_err_csl_reg);
    read_err_csl_part2_q.push_back(read_err_csl_reg);
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", 2), read_err_csl_reg);
    read_err_csl_part2_q.push_back(read_err_csl_reg);
    foreach(read_err_csl_part2_q[i]) begin
        $display("i is %0d", i);
        if(read_err_csl_part2_q[i] != err_csl_part2_finial_check[i])   
            `uvm_error("csl check error", $sformatf("exp is %0h, act is %0h", err_csl_part2_finial_check[i], read_err_csl_part2_q[i]))
        else 
            `uvm_info("csl check", $sformatf("err csl check pass is %0h", err_csl_part2_finial_check[i]), UVM_LOW)
    end

    //------- part3 check ----------
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", 3), read_err_csl_reg);
    read_err_csl_part3_q.push_back(read_err_csl_reg);
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", 3), read_err_csl_reg);
    read_err_csl_part3_q.push_back(read_err_csl_reg);
    foreach(read_err_csl_part3_q[i]) begin
        if(read_err_csl_part3_q[i] != err_csl_part3_finial_check[i])   
            `uvm_error("csl check error", $sformatf("exp is %0h, act is %0h", err_csl_part3_finial_check[i], read_err_csl_part3_q[i]))
        else 
            `uvm_info("csl check", $sformatf("err csl check pass is %0h", err_csl_part3_finial_check[i]), UVM_LOW)
    end

    //------- part4 check ----------
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", 4), read_err_csl_reg);
    read_err_csl_part4_q.push_back(read_err_csl_reg);
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", 4), read_err_csl_reg);
    read_err_csl_part4_q.push_back(read_err_csl_reg);
    foreach(read_err_csl_part4_q[i]) begin
        if(read_err_csl_part4_q[i] != err_csl_part4_finial_check[i])   
            `uvm_error("csl check error", $sformatf("exp is %0h, act is %0h", err_csl_part4_finial_check[i], read_err_csl_part4_q[i]))
        else 
            `uvm_info("csl check", $sformatf("err csl check pass is %0h", err_csl_part4_finial_check[i]), UVM_LOW)
    end
    
    //------- part5 check ----------
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", 5), read_err_csl_reg);
    read_err_csl_part5_q.push_back(read_err_csl_reg);
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", 5), read_err_csl_reg);
    read_err_csl_part5_q.push_back(read_err_csl_reg);
    foreach(read_err_csl_part5_q[i]) begin
        if(read_err_csl_part5_q[i] != err_csl_part5_finial_check[i])   
            `uvm_error("csl check error", $sformatf("exp is %0h, act is %0h", err_csl_part5_finial_check[i], read_err_csl_part5_q[i]))
        else 
            `uvm_info("csl check", $sformatf("err csl check pass is %0h", err_csl_part5_finial_check[i]), UVM_LOW)
    end
    
    //------- part6 check ----------
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", 6), read_err_csl_reg);
    read_err_csl_part6_q.push_back(read_err_csl_reg);
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", 6), read_err_csl_reg);
    read_err_csl_part6_q.push_back(read_err_csl_reg);
    foreach(read_err_csl_part6_q[i]) begin
        if(read_err_csl_part6_q[i] != err_csl_part6_finial_check[i])   
            `uvm_error("csl check error", $sformatf("exp is %0h, act is %0h", err_csl_part6_finial_check[i], read_err_csl_part6_q[i]))
        else 
            `uvm_info("csl check", $sformatf("err csl check pass is %0h", err_csl_part6_finial_check[i]), UVM_LOW)
    end

    //------- part7 check ----------
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", 7), read_err_csl_reg);
    read_err_csl_part7_q.push_back(read_err_csl_reg);
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", 7), read_err_csl_reg);
    read_err_csl_part7_q.push_back(read_err_csl_reg);
    foreach(read_err_csl_part7_q[i]) begin
        if(read_err_csl_part7_q[i] != err_csl_part7_finial_check[i])   
            `uvm_error("csl check error", $sformatf("exp is %0h, act is %0h", err_csl_part7_finial_check[i], read_err_csl_part7_q[i]))
        else 
            `uvm_info("csl check", $sformatf("err csl check pass is %0h", err_csl_part7_finial_check[i]), UVM_LOW)
    end

    //------- part8 check ----------
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", 8), read_err_csl_reg);
    read_err_csl_part8_q.push_back(read_err_csl_reg);
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", 8), read_err_csl_reg);
    read_err_csl_part8_q.push_back(read_err_csl_reg);
    foreach(read_err_csl_part8_q[i]) begin
        if(read_err_csl_part8_q[i] != err_csl_part8_finial_check[i])   
            `uvm_error("csl check error", $sformatf("exp is %0h, act is %0h", err_csl_part8_finial_check[i], read_err_csl_part8_q[i]))
        else 
            `uvm_info("csl check", $sformatf("err csl check pass is %0h", err_csl_part8_finial_check[i]), UVM_LOW)
    end

    //------- part9 check ----------
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", 9), read_err_csl_reg);
    read_err_csl_part9_q.push_back(read_err_csl_reg);
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", 9), read_err_csl_reg);
    read_err_csl_part9_q.push_back(read_err_csl_reg);
    foreach(read_err_csl_part9_q[i]) begin
        if(read_err_csl_part9_q[i] != err_csl_part9_finial_check[i])   
            `uvm_error("csl check error", $sformatf("exp is %0h, act is %0h", err_csl_part9_finial_check[i], read_err_csl_part9_q[i]))
        else 
            `uvm_info("csl check", $sformatf("err csl check pass is %0h", err_csl_part9_finial_check[i]), UVM_LOW)
    end

    //exp row check
    for(int kk=0;kk<64;kk++) begin
        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.err_wl%0d", kk), read_err_row_reg);
        read_err_row_reg_q.push_front(read_err_row_reg);
    end

    if (!exp_csl_fail) begin
        foreach(read_err_row_reg_q[ii]) begin
            if(read_err_row_reg_q[ii] != err_row_pattern1_q[ii]) begin
                `uvm_error("err row check", $sformatf("num %0d, exp is %0h, act is %0h", ii, err_row_pattern1_q[ii], read_err_row_reg_q[ii]))
            end
            else begin
                `uvm_info("err row check", $sformatf("num %0d, check pass is %0h", ii, err_row_pattern1_q[ii]),UVM_LOW)
            end
        end
    end
    else begin
        foreach(read_err_row_reg_q[ii]) begin
            if(read_err_row_reg_q[ii] != 'h1fff) begin
                `uvm_error("err row check", $sformatf("num %0d, exp is %0h, act is %0h", ii, 'h1fff, read_err_row_reg_q[ii]))
            end
            else begin
                `uvm_info("err row check", $sformatf("num %0d, check pass is %0h", ii, err_row_pattern1_q[ii]),UVM_LOW)
            end
        end
    end


    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.csl_scan_fail", csl_fail);
    if ((|exp_csl_fail) != csl_fail)   `uvm_error(get_type_name(),$sformatf("csl fail check err, exp %0b, act %0b",(|exp_csl_fail), csl_fail))

    if (!exp_csl_fail) begin
        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_wl_scan.bist_wl_fail", wl_fail);
        if ((exp_wl_fail) != wl_fail)   `uvm_error(get_type_name(),$sformatf("wl fail check err, exp %0b, act %0b",exp_wl_fail, wl_fail))
    end

    //--------------------------------------------------


#10000ns;

endtask:body

task mc_bist_rand_order_csl_wl_vseq::gen_err_csl(input bit [3:0] part, output bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$]);

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
            assert(randomize(cadd_array));
            err_csl_partx_q.push_back(cadd_array);
            for(int i=0;i<COL_ALL_NUM-1;i++)begin
                err_csl_partx_q.push_back(ERR_CSL_DEFAULT_VALUE);
            end
        end
        2: begin    //2 csl >= th
            assert(randomize(cadd_array));
            err_csl_partx_q.push_back(cadd_array);
            assert(randomize(cadd_array) with {cadd_array != err_csl_partx_q[0];});
            err_csl_partx_q.push_back(cadd_array);
            for(int i=0;i<COL_ALL_NUM-2;i++)begin
                err_csl_partx_q.push_back(ERR_CSL_DEFAULT_VALUE);
            end
        end
        3: begin    //3 csl >= th
            exp_csl_fail[part] = 1;
            assert(randomize(cadd_array));
            err_csl_partx_q.push_back(cadd_array);
            assert(randomize(cadd_array) with {cadd_array != err_csl_partx_q[0];});
            err_csl_partx_q.push_back(cadd_array);
            assert(randomize(cadd_array) with {cadd_array != err_csl_partx_q[0]; cadd_array!= err_csl_partx_q[1];});
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

task mc_bist_rand_order_csl_wl_vseq::gen_err_row(input bit[3:0] part, input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$]);

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
                    if(wl_success_mode && (err_wl_addr_q.size() >='d64)) begin
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
                    if(wl_success_mode && (err_wl_addr_q.size() >='d64)) begin
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
                    if(wl_success_mode && (err_wl_addr_q.size() >='d64)) begin
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

task mc_bist_rand_order_csl_wl_vseq::gen_exp_csl(input bit [3:0] part, input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$], output bit [`COLUMN_ADDR_WIDTH-1:0] exp_err_csl_partx[2:0][2:0]);

    //initial exp
    for(int i=0;i<5;i++) begin
        for(int j=0;j<3;j++) begin
            exp_err_csl_partx[i][j] = ERR_CSL_DEFAULT_VALUE;
        end
    end
    if (!exp_csl_fail[part]) begin
        $display("err_force_mode is %0d, part is %0d, err_csl_partx_q[0] is %0h, err_csl_partx_q[1] is %0h, case mode is %3b", err_force_mode, part, err_csl_partx_q[0], err_csl_partx_q[1],{!err_force_mode, (err_csl_partx_q[0] < cadd_array), (err_csl_partx_q[1] < cadd_array)} );
        case({!err_force_mode, (err_csl_partx_q[0] < cadd_array), (err_csl_partx_q[1] < cadd_array)})
            //left is 0
            3'b100:begin    //err 0 force 0, use pattern 1 check err; err 1 force 1, use pattern 0 check
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[0][1]     =   err_csl_partx_q[1];
            end
            3'b101:begin
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[1];
            end
            3'b110:begin
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[0];
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[1];
            end
            3'b111:begin
                exp_err_csl_partx[1][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[1];
            end

            //left is 1
            3'b000:begin
                exp_err_csl_partx[1][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[1];
            end
            3'b001:begin
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[0];
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[1];
            end
            3'b010:begin
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[1];
            end
            3'b011:begin
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[0][1]     =   err_csl_partx_q[1];
            end
        endcase
    end
    else begin
        $display("err_force_mode is %0d, part is %0d, err_csl_partx_q[0] is %0h, err_csl_partx_q[1] is %0h, err_csl_partx_q[2] is %0h, case mode is %4b", err_force_mode, part, err_csl_partx_q[0], err_csl_partx_q[1],err_csl_partx_q[2],{!err_force_mode, (err_csl_partx_q[0] < cadd_array), (err_csl_partx_q[1] < cadd_array), (err_csl_partx_q[2] < cadd_array)} );
        case({!err_force_mode, (err_csl_partx_q[0] < cadd_array), (err_csl_partx_q[1] < cadd_array), err_csl_partx_q[2] < cadd_array})
            //left is 0
            4'b1000:begin    //err 0 force 1, use pattern 0 check err; err 1 force 1, use pattern 0 check
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[0][1]     =   err_csl_partx_q[1];
                exp_err_csl_partx[0][2]     =   err_csl_partx_q[2];
            end
            4'b1001:begin
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[0][1]     =   err_csl_partx_q[1];
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[2];
            end
            4'b1010:begin
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[1];
                exp_err_csl_partx[0][1]     =   err_csl_partx_q[2];
            end
            4'b1011:begin
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[1];
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[2];
            end
            4'b1100:begin
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[0];
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[1];
                exp_err_csl_partx[0][1]     =   err_csl_partx_q[2];
            end
            4'b1101:begin
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[0];
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[1];
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[2];
            end
            4'b1110:begin
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[0];
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[1];
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[2];
            end
            4'b1111:begin
                exp_err_csl_partx[1][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[1];
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[2];
            end

            //left is 1
            4'b0000:begin    //err 0 force 0, use pattern 1 check err; err 1 force 0, use pattern 1 check
                exp_err_csl_partx[1][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[1];
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[2];
            end
            4'b0001:begin
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[0];
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[1];
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[2];
            end
            4'b0010:begin
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[0];
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[1];
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[2];
            end
            4'b0011:begin
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[0];
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[1];
                exp_err_csl_partx[0][1]     =   err_csl_partx_q[2];
            end
            4'b0100:begin
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[1][1]     =   err_csl_partx_q[1];
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[2];
            end
            4'b0101:begin
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[1];
                exp_err_csl_partx[0][1]     =   err_csl_partx_q[2];
            end
            4'b0110:begin
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[0][1]     =   err_csl_partx_q[1];
                exp_err_csl_partx[1][2]     =   err_csl_partx_q[2];
            end
            4'b0111:begin
                exp_err_csl_partx[0][0]     =   err_csl_partx_q[0];
                exp_err_csl_partx[0][1]     =   err_csl_partx_q[1];
                exp_err_csl_partx[0][2]     =   err_csl_partx_q[2];
            end
        endcase
    end

endtask:gen_exp_csl

task mc_bist_rand_order_csl_wl_vseq::exp_csl_check(input bit [3:0] part, input int pattern_index, input bit [`COLUMN_ADDR_WIDTH-1:0] now_cadd, input bit [`COLUMN_ADDR_WIDTH-1:0] exp_err_csl_partx[2:0][2:0], input bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_q[$], ref bit [`COLUMN_ADDR_WIDTH-1:0] err_csl_partx_finial_check[1:0]);

    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_reg;
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_partx_q[$];
    bit                             index;

    if (pattern_index <2) begin
        if (now_cadd == exp_err_csl_partx[pattern_index][0])  begin
            uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", part), read_err_csl_reg);

            if (read_err_csl_reg != now_cadd) begin
                `uvm_error("err csl check", $sformatf("part is %0d, pattern_index is %0d, err csl check fail, exp is %0h, act is %0h",part, pattern_index, now_cadd, read_err_csl_reg))
            end
            else begin
                `uvm_info("err csl check", $sformatf("err csl check pass, is %0h", now_cadd), UVM_LOW)
                err_csl_partx_finial_check[0] = now_cadd;
                //`uvm_info("err csl check", $sformatf("err csl partx final check[0], is %0h", err_csl_partx_finial_check[0]), UVM_LOW)
            end
        end
        else if (now_cadd == exp_err_csl_partx[pattern_index][1]) begin
            uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", part), read_err_csl_reg);
            for (int i=0;i<(pattern_index+1);i++) begin
                if(exp_err_csl_partx[i][0] != ERR_CSL_DEFAULT_VALUE) begin
                    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", part), read_err_csl_reg);
                    index = 1;
                    break;
                end
            end
            if (read_err_csl_reg != now_cadd) begin
                `uvm_error("err csl check", $sformatf("part is %0d, pattern_index is %0d, err csl check fail, exp is %0h, act is %0h",part, pattern_index, now_cadd, read_err_csl_reg))
            end
            else begin
                `uvm_info("err csl check", $sformatf("err csl check pass, is %0h", now_cadd), UVM_LOW)
                err_csl_partx_finial_check[index] = now_cadd;
                //`uvm_info("err csl check", $sformatf("err csl partx final check[%0d], is %0h",index, err_csl_partx_finial_check[index]), UVM_LOW)
            end
        end
    end
    else begin
        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", part), read_err_csl_reg);
        read_err_csl_partx_q.push_back(read_err_csl_reg);
        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", part), read_err_csl_reg);
        read_err_csl_partx_q.push_back(read_err_csl_reg);
        read_err_csl_partx_q.sort();
        foreach(read_err_csl_partx_q[i]) begin
            if(read_err_csl_partx_q[i] != err_csl_partx_q[i])   
                `uvm_error("csl check error", $sformatf("part %0d, exp is %0h, act is %0h",part, err_csl_partx_q[i], read_err_csl_partx_q[i]))
            //else 
            //    `uvm_info("csl check", $sformatf("part %0d, err csl check pass is %0h",part, err_csl_partx_q[i]), UVM_LOW)
        end
    end


endtask:exp_csl_check

function bit [3:0] mc_bist_rand_order_csl_wl_vseq::caculate_row_part(input bit [`ROW_ADDR_WIDTH-1:0] row_in);

    if (row_in<(BIST_WL_NUM/10)) begin
        caculate_row_part = 0;
    end
    else if (row_in>=(BIST_WL_NUM/10) && row_in<(BIST_WL_NUM*2/10)) begin
        caculate_row_part = 1;
    end
    else if (row_in>=(BIST_WL_NUM*2/10) && row_in<(BIST_WL_NUM*3/10)) begin
        caculate_row_part = 2;
    end
    else if (row_in>=(BIST_WL_NUM*3/10) && row_in<(BIST_WL_NUM*4/10)) begin
        caculate_row_part = 3;
    end
    else if (row_in>=(BIST_WL_NUM*4/10) && row_in<(BIST_WL_NUM*5/10)) begin
        caculate_row_part = 4;
    end
    else if (row_in>=(BIST_WL_NUM*5/10) && row_in<(BIST_WL_NUM*6/10)) begin
        caculate_row_part = 5;
    end
    else if (row_in>=(BIST_WL_NUM*6/10) && row_in<(BIST_WL_NUM*7/10)) begin
        caculate_row_part = 6;
    end
    else if (row_in>=(BIST_WL_NUM*7/10) && row_in<(BIST_WL_NUM*8/10)) begin
        caculate_row_part = 7;
    end
    else if (row_in>=(BIST_WL_NUM*8/10) && row_in<(BIST_WL_NUM*9/10)) begin
        caculate_row_part = 8;
    end
    else if (row_in>=(BIST_WL_NUM*9/10) && row_in<(BIST_WL_NUM*10/10)) begin
        caculate_row_part = 9;
    end
    else begin
        `uvm_error(get_type_name(), $sformatf("err row input %0h", row_in))
    end

endfunction:caculate_row_part

function int mc_bist_rand_order_csl_wl_vseq::caculate_vmc_cnt(input bit [`ROW_ADDR_WIDTH-1:0] row_in, input bit [`COLUMN_ADDR_WIDTH-1:0] cadd_in);

    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_reg;
    bit [`COLUMN_ADDR_WIDTH-1:0]    read_err_csl_reg_q[$];

    //caculate vmc cnt
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl0_part%0d", caculate_row_part(row_in)), read_err_csl_reg);
    read_err_csl_reg_q.push_back(read_err_csl_reg);
    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_csl_scan.err_csl1_part%0d", caculate_row_part(row_in)), read_err_csl_reg);
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
 
`endif 
