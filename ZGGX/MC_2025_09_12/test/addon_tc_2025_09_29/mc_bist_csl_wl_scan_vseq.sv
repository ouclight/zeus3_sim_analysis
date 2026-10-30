
`ifndef MC_BIST_CSL_WL_SCAN_VSEQ
`define MC_BIST_CSL_WL_SCAN_VSEQ

class mc_bist_csl_wl_scan_vseq extends mc_common_vseq;
    rand bit    [1:0]                   vmc_csl_cnt;
    rand bit    [1:0]                   vmc_csl_cnt_part1;
    rand bit    [1:0]                   vmc_csl_cnt_part2;
    rand bit    [1:0]                   vmc_csl_cnt_part3;
    rand bit    [1:0]                   vmc_csl_cnt_part4;
    rand bit    [1:0]                   vmc_csl_cnt_part5;
    rand bit    [1:0]                   vmc_csl_cnt_part6;
    rand bit    [1:0]                   vmc_csl_cnt_part7;
    rand bit    [1:0]                   vmc_csl_cnt_part8;
    rand bit    [1:0]                   vmc_csl_cnt_part9;
    randc bit   [`ROW_ADDR_WIDTH-1:0]   vmc_wl_addr;
    bit         [`ROW_ADDR_WIDTH-1:0]   vmc_wl_addr_q[$];
    bit         [`ROW_ADDR_WIDTH-1:0]   vmc_wl_addr_q_copy[$];
    bit         [`ROW_ADDR_WIDTH-1:0]   vmc_wl_addr_q_copy1[$];
    rand bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr;
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q0[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q1[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q2[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q3[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q4[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q5[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q6[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q7[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q8[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q9[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part1[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part2[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part3[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part4[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part5[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part6[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part7[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part8[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part9[$];
    bit         [8:0]                       wl_total_size = 0;
    bit         [12:0]                  wl_err;
    bit                           bist_finish_int;
    bit         [4:0]               csl_part_num;
    bit                                 csl_err_addr_hit = 0;
    bit                                 wl_err_addr_hit = 0;
    bit         [`ARRAY_DATA_WIDTH-1:0] act_rdl,err_rdl;
    bit         [3:0]                   wl_rd_num_start=0;
    rand bit                            csl_inject_err_en;
    rand bit                            wl_inject_err_en;
    longint                             gcas_rd_cnt=0;
    longint                             gcas_rd_wl_cnt=0;
    longint                             gcas_rd_wl_cnt_old=0;
    longint                             rdrdy_n_cnt=0;
    longint                             rdrdy_n_wl_cnt=0;
    longint                             gcas_rd_cnt_q[$];
    longint                             gcas_rd_cnt_wl_q[$];
    bit         [8:0]                   inject_err_cnt;
    bit         [8:0]                   inject_err_wl_cnt;
    bit                                 bist_finish_status_reg=0;
    rand    bit                         bist_finish_mask;
    bit         [`ROW_ADDR_WIDTH:0]                   wl_cnt=0;
    randc bit    [`COL_ADDR_WIDTH-1:0]                  gcadd_num;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num1;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num2;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num3;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num4;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num5;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num6;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num7;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num8;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num9;
    bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num_cp;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num_down;
    bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num_down_cp;
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_up[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_down[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_part0[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_part1[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_part2[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_part3[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_part4[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_part5[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_part6[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_part7[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_part8[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_part9[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_total[$];

    bit     [`COLUMN_ADDR_WIDTH-1:0]                       vmc_gcadd=127;
    rand bit    [`ROW_ADDR_WIDTH-1:0]                   csl_error_num;
    rand bit [`PATTERN_WIDTH-1:0]   bist_pattern[4];
    rand bit    [3:0]               wl_scan_cnt;
    bit    [3:0]               wl_time=1;
    rand bit    [4:0]               csl_err_th;
    bit    [4:0]               num=0;
    bit    [`ROW_ADDR_WIDTH-1:0]                     array_q[][];
    int                         array_index=1;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_wr=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_rd=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part0_check=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part1_check=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part2_check=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part3_check=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part4_check=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part5_check=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part6_check=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part7_check=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part8_check=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part9_check=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part0_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part1_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part2_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part3_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part4_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part5_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part6_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part7_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part8_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part9_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part0=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part1=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part2=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part3=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part4=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part5=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part6=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part7=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part8=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part9=0;
    bit     [3:0]               start_num=0;
    bit                         first_enter=0;
    `uvm_object_utils(mc_bist_csl_wl_scan_vseq)
    bit [31:0] csl_q_size=0;
    bit [31:0] csl_q_size_part1=0;
    bit [31:0] csl_q_size_part2=0;
    bit [31:0] csl_q_size_part3=0;
    bit [31:0] csl_q_size_part4=0;
    bit [31:0] csl_q_size_part5=0;
    bit [31:0] csl_q_size_part6=0;
    bit [31:0] csl_q_size_part7=0;
    bit [31:0] csl_q_size_part8=0;
    bit [31:0] csl_q_size_part9=0;
    bit [31:0] wl_q_size=0;
    bit [31:0] read_data=0;
    bit [31:0] read_data1=0;
    bit [3:0] exp_data=0;
    bit [31:0] read_data_csl=0;
    bit [31:0] read_data_csl1=0;
    bit [31:0] read_data_csl2=0;
    bit [31:0] read_data_csl3=0;
    bit [31:0] read_data_csl4=0;
    bit [31:0] read_data_csl5=0;
    bit [31:0] read_data_csl6=0;
    bit [31:0] read_data_csl7=0;
    bit [31:0] read_data_csl8=0;
    bit [31:0] read_data_wl=0;
    bit         [`COL_ADDR_WIDTH:0]   data_csl;
    bit         [`ROW_ADDR_WIDTH-1:0]   data_wl;
    bit    [31:0]                            mc_vmc_bl_num_up_q[2];
    bit    [31:0]                            mc_vmc_bl_num_down_q[2];
    bit    [31:0]                            mc_vmc_bl_num_part0_q[2];
    bit    [31:0]                            mc_vmc_bl_num_part1_q[2];
    bit    [31:0]                            mc_vmc_bl_num_part2_q[2];
    bit    [31:0]                            mc_vmc_bl_num_part3_q[2];
    bit    [31:0]                            mc_vmc_bl_num_part4_q[2];
    bit    [31:0]                            mc_vmc_bl_num_part5_q[2];
    bit    [31:0]                            mc_vmc_bl_num_part6_q[2];
    bit    [31:0]                            mc_vmc_bl_num_part7_q[2];
    bit    [31:0]                            mc_vmc_bl_num_part8_q[2];
    bit    [31:0]                            mc_vmc_bl_num_part9_q[2];
    bit         [31:0]  mc_page_status=0;
    rand bit    [6:0]                   csl_pattern_num; 
    rand bit    [6:0]                   wl_pattern_num; 
    rand bit            close_page_en;
    bit    [7:0]        parity_seed_q[$];
    bit    [7:0]        parity_seed;
    bit    [31:0]        read_parity;
    rand bit parity_en;
    randc bit    [7:0]        csl_err_position;
    rand bit    [7:0]        csl_err_position_num;
    constraint csl_pattern_num_c {csl_pattern_num dist {[1:10]:/90,[11:31]:/9,[32:64]:/1};}
    constraint wl_pattern_num_c {wl_pattern_num dist {[1:10]:/90,[11:31]:/9,[32:64]:/1};}
    constraint csl_err_th_c {csl_err_th dist{[1:1]:/20,[2:15]:/20,[16:16]:/20,[17:30]:/20/*,[31:31]:/20*/};};
    constraint wl_scan_cnt_c {wl_scan_cnt dist{[0:0]:/10,[1:14]:/10,[15:15]:/10};};
    constraint csl_err_num_c {csl_error_num inside {[0:30]};} 
    localparam                                              BIST_WL_NUM=300;
    localparam                                              COL_ALL_NUM='d130;
    localparam      PART_NUM=10;
    int vmc_cnt;
    int m;

    bit [10:0] err_position_q0[$];
    bit [10:0] err_position_q1[$];
    bit [10:0] err_position_q2[$];
    bit [10:0] err_position_q3[$];
    bit [10:0] err_position_q4[$];
    bit [10:0] err_position_q5[$];
    bit [10:0] err_position_q6[$];
    bit [10:0] err_position_q7[$];
    bit [10:0] err_position_q8[$];
    bit [10:0] err_position_q9[$];
    bit [10:0] soft_err_position0;
    bit [10:0] soft_err_position1;
    bit [10:0] soft_err_position2;
    bit [10:0] soft_err_position3;
    bit [10:0] soft_err_position4;
    bit [10:0] soft_err_position5;
    bit [10:0] soft_err_position6;
    bit [10:0] soft_err_position7;
    bit [10:0] soft_err_position8;
    bit [10:0] soft_err_position9;
    rand bit [10:0] soft_err_rand;
    bit [`ROW_ADDR_WIDTH-1:0] soft_err_gradd0;
    bit [`ROW_ADDR_WIDTH-1:0] soft_err_gradd1;
    bit [`ROW_ADDR_WIDTH-1:0] soft_err_gradd2;
    bit [`ROW_ADDR_WIDTH-1:0] soft_err_gradd3;
    bit [`ROW_ADDR_WIDTH-1:0] soft_err_gradd4;
    bit [`ROW_ADDR_WIDTH-1:0] soft_err_gradd5;
    bit [`ROW_ADDR_WIDTH-1:0] soft_err_gradd6;
    bit [`ROW_ADDR_WIDTH-1:0] soft_err_gradd7;
    bit [`ROW_ADDR_WIDTH-1:0] soft_err_gradd8;
    bit [`ROW_ADDR_WIDTH-1:0] soft_err_gradd9;
    rand bit [`ROW_ADDR_WIDTH-1:0] soft_err_wl;
    rand bit         err_0_1;
    rand bit[6:0] pattern_cnt;
    rand bit[6:0] wl_pattern_cnt;
    randc bit[6:0] pattern_seed;
    bit[6:0] pattern_seed_pop;
    bit [6:0] pattern_num_q[$];
    bit [6:0] wl_pattern_num_q[$];
    bit [6:0] pattern_num_q_size;
    bit [6:0] wl_pattern_num_q_size;
    bit [6:0] pattern_num_q_copy[$];
    bit [6:0] wl_pattern_num_q_copy[$];
    rand bit [6:0] soft_pattern_num;
    rand bit [6:0] wl_soft_pattern_num;
    bit [6:0] pattern_index;
    rand bit [5:0] err_gradd_num;
    bit [`ROW_ADDR_WIDTH-1:0] wl_err_q[$];
    bit [`ROW_ADDR_WIDTH-1:0] wl_err_q_filtered[$];
    bit [9:0] wl_err_q_filtered_size;
    bit [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q_total[$];
    bit [`ROW_ADDR_WIDTH-1:0] err_gradd_q0[$];
    bit [`ROW_ADDR_WIDTH-1:0] err_gradd_q1[$];
    bit [`ROW_ADDR_WIDTH-1:0] err_gradd_q2[$];
    bit [`ROW_ADDR_WIDTH-1:0] err_gradd_q3[$];
    bit [`ROW_ADDR_WIDTH-1:0] err_gradd_q4[$];
    bit [`ROW_ADDR_WIDTH-1:0] err_gradd_q5[$];
    bit [`ROW_ADDR_WIDTH-1:0] err_gradd_q6[$];
    bit [`ROW_ADDR_WIDTH-1:0] err_gradd_q7[$];
    bit [`ROW_ADDR_WIDTH-1:0] err_gradd_q8[$];
    bit [`ROW_ADDR_WIDTH-1:0] err_gradd_q9[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q0_select[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q1_select[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q2_select[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q3_select[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q4_select[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q5_select[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q6_select[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q7_select[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q8_select[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q9_select[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q0_size[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q1_size[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q2_size[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q3_size[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q4_size[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q5_size[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q6_size[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q7_size[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q8_size[$];
    bit [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q9_size[$];
    rand bit [`ROW_ADDR_WIDTH-1:0] err_gradd;
    rand bit [`ROW_ADDR_WIDTH-1:0] soft_err_gradd;
    rand bit [`COLUMN_ADDR_WIDTH-1:0] soft_err_wl_col;
    bit [271:0] compare_data;
    bit index=0;
    bit index1=0;
    bit index0_0=0;
    bit index0_1=0;
    bit index1_0=0;
    bit index1_1=0;
    bit index2_0=0;
    bit index2_1=0;
    bit index3_0=0;
    bit index3_1=0;
    bit index4_0=0;
    bit index4_1=0;
    bit index5_0=0;
    bit index5_1=0;
    bit index6_0=0;
    bit index6_1=0;
    bit index7_0=0;
    bit index7_1=0;
    bit index8_0=0;
    bit index8_1=0;
    bit index9_0=0;
    bit index9_1=0;
    bit compare_csl_result_q0[$],compare_csl_result_q0_tmp[$];
    bit compare_csl_result_q1[$],compare_csl_result_q1_tmp[$];
    bit compare_csl_result_q2[$],compare_csl_result_q2_tmp[$];
    bit compare_csl_result_q3[$],compare_csl_result_q3_tmp[$];
    bit compare_csl_result_q4[$],compare_csl_result_q4_tmp[$];
    bit compare_csl_result_q5[$],compare_csl_result_q5_tmp[$];
    bit compare_csl_result_q6[$],compare_csl_result_q6_tmp[$];
    bit compare_csl_result_q7[$],compare_csl_result_q7_tmp[$];
    bit compare_csl_result_q8[$],compare_csl_result_q8_tmp[$];
    bit compare_csl_result_q9[$],compare_csl_result_q9_tmp[$];
    bit compare_csl_result_q0_pop;
    bit compare_csl_result_q1_pop;
    bit compare_csl_result_q2_pop;
    bit compare_csl_result_q3_pop;
    bit compare_csl_result_q4_pop;
    bit compare_csl_result_q5_pop;
    bit compare_csl_result_q6_pop;
    bit compare_csl_result_q7_pop;
    bit compare_csl_result_q8_pop;
    bit compare_csl_result_q9_pop;
    bit [67:0] scan_num;
    bit [67:0] wl_scan_num;
    rand bit scan_mode;
    bit [7:0] soft_num=0;
    bit [3:0] mc_bist_grant,bist_num,mc_bist_grant_q[$],enter_num;
    rand bit [9:0] err_position;
    rand bit [9:0] err_num;
    logic [31:0] bist_pattern_org [68];

    rand bit [31:0] bist_pattern64,bist_pattern65,bist_pattern66,bist_pattern67;
    logic [271:0] bist_pattern_all [68][4];
    logic [271:0] bist_pattern_select [][];
    logic [271:0] wl_bist_pattern_select [][];
    function new(string name="mc_bist_csl_wl_scan_vseq");
        super.new(name);
    endfunction

virtual task body();
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    super.body();
    //repeat(1)begin
    randomize(bist_pattern64,bist_pattern65,bist_pattern66,bist_pattern67,scan_mode,bist_finish_mask);
    m_tb_if.bist_test_en = 1;
    bist_pattern_org[0] = 32'h0000_0000;
    bist_pattern_org[1] = 32'hFFFF_FFFF;
    bist_pattern_org[2] = 32'h5555_5555;
    bist_pattern_org[3] = 32'hAAAA_AAAA;
    bist_pattern_org[4] = 32'h00FF_00FF;
    bist_pattern_org[5] = 32'hFF00_FF00;
    bist_pattern_org[6] = 32'h55AA_55AA;
    bist_pattern_org[7] = 32'hAA55_AA55;
    bist_pattern_org[8] = 32'h0055_0055;
    bist_pattern_org[9] = 32'h00AA_00AA;
    bist_pattern_org[10] = 32'h5500_5500;
    bist_pattern_org[11] = 32'hAA00_AA00;
    bist_pattern_org[12] = 32'h0000_FFFF;
    bist_pattern_org[13] = 32'hFFFF_0000;
    bist_pattern_org[14] = 32'h00FF_FF00;
    bist_pattern_org[15] = 32'hFF00_00FF;
    bist_pattern_org[16] = 32'h3333_3333;
    bist_pattern_org[17] = 32'hCCCC_CCCC;
    bist_pattern_org[18] = 32'h9999_9999;
    bist_pattern_org[19] = 32'h6666_6666;
    bist_pattern_org[20] = 32'h33CC_33CC;
    bist_pattern_org[21] = 32'hCC33_CC33;
    bist_pattern_org[22] = 32'h6699_6699;
    bist_pattern_org[23] = 32'h9966_9966;
    bist_pattern_org[24] = 32'h1212_1212;
    bist_pattern_org[25] = 32'h2424_2424;
    bist_pattern_org[26] = 32'h4848_4848;
    bist_pattern_org[27] = 32'h8181_8181;
    bist_pattern_org[28] = 32'hEDED_EDED;
    bist_pattern_org[29] = 32'hDBDB_DBDB;
    bist_pattern_org[30] = 32'hB7B7_B7B7;
    bist_pattern_org[31] = 32'h7E7E_7E7E;
    bist_pattern_org[32] = 32'hED12_ED12;
    bist_pattern_org[33] = 32'hDB24_DB24;
    bist_pattern_org[34] = 32'hB748_B748;
    bist_pattern_org[35] = 32'h7E81_7E81;
    bist_pattern_org[36] = 32'h12ED_12ED;
    bist_pattern_org[37] = 32'h24DB_24DB;
    bist_pattern_org[38] = 32'h48B7_48B7;
    bist_pattern_org[39] = 32'h817E_817E;
    bist_pattern_org[40] = 32'h0012_0012;
    bist_pattern_org[41] = 32'h0024_0024;
    bist_pattern_org[42] = 32'h0048_0048;
    bist_pattern_org[43] = 32'h0081_0081;
    bist_pattern_org[44] = 32'h1200_1200;
    bist_pattern_org[45] = 32'h2400_2400;
    bist_pattern_org[46] = 32'h4800_4800;
    bist_pattern_org[47] = 32'h8100_8100;
    bist_pattern_org[48] = 32'h0101_0101;
    bist_pattern_org[49] = 32'h0202_0202;
    bist_pattern_org[50] = 32'h0404_0404;
    bist_pattern_org[51] = 32'h0808_0808;
    bist_pattern_org[52] = 32'h1010_1010;
    bist_pattern_org[53] = 32'h2020_2020;
    bist_pattern_org[54] = 32'h4040_4040;
    bist_pattern_org[55] = 32'h8080_8080;
    bist_pattern_org[56] = 32'hFEFE_FEFE;
    bist_pattern_org[57] = 32'hFDFD_FDFD;
    bist_pattern_org[58] = 32'hFBFB_FBFB;
    bist_pattern_org[59] = 32'hF7F7_F7F7;
    bist_pattern_org[60] = 32'hEFEF_EFEF;
    bist_pattern_org[61] = 32'hDFDF_DFDF;
    bist_pattern_org[62] = 32'hBFBF_BFBF;
    bist_pattern_org[63] = 32'h7F7F_7F7F;
    bist_pattern_org[64] = bist_pattern64;
    bist_pattern_org[65] = bist_pattern65;
    bist_pattern_org[66] = bist_pattern66;
    bist_pattern_org[67] = bist_pattern67;
    for(int i=0;i<68;i++)begin
        for(int j=0;j<4;j++)begin
            bist_pattern_all[i][j] = {34{bist_pattern_org[i][8*j+:8]}}; 
        end
    end
    randomize(bist_pattern,wl_scan_cnt,csl_err_th,close_page_en,csl_pattern_num,wl_pattern_num);
    `uvm_info(get_type_name(),$sformatf("csl_err_th=%d",csl_err_th),UVM_LOW);
    `uvm_info(get_type_name(),$sformatf("scan_mode=%d",scan_mode),UVM_LOW);

    //product error position
    randomize(err_0_1);
    `uvm_info(get_type_name(),$sformatf("err_0_1 =%b",err_0_1),UVM_LOW);
    randomize(parity_en) with {parity_en dist {1:/80,0:/20};};
    `uvm_info(get_type_name(),$sformatf("parity_en =%d",parity_en),UVM_LOW);
    err_position_product(parity_en,err_position_q0,soft_err_position0);
    err_position_product(parity_en,err_position_q1,soft_err_position1);
    err_position_product(parity_en,err_position_q2,soft_err_position2);
    err_position_product(parity_en,err_position_q3,soft_err_position3);
    err_position_product(parity_en,err_position_q4,soft_err_position4);
    err_position_product(parity_en,err_position_q5,soft_err_position5);
    err_position_product(parity_en,err_position_q6,soft_err_position6);
    err_position_product(parity_en,err_position_q7,soft_err_position7);
    err_position_product(parity_en,err_position_q8,soft_err_position8);
    err_position_product(parity_en,err_position_q9,soft_err_position9);

    //pattern_num
    randomize(pattern_cnt) with {pattern_cnt dist {[1:8]:/99,[9:68]:/1};};
    `uvm_info(get_type_name(),$sformatf("pattern_cnt =%d",pattern_cnt),UVM_LOW);
    for(int i=0;i<pattern_cnt;i++)begin
        randomize(pattern_seed) with {pattern_seed inside {[0:67]};};
        //`uvm_info(get_type_name(),$sformatf("pattern_seed =%d",pattern_seed),UVM_LOW);
        pattern_num_q.push_back(pattern_seed);
    end
    pattern_num_q_copy = pattern_num_q;
    bist_pattern_select = new[pattern_num_q.size()];
    foreach(bist_pattern_select[i])begin
        bist_pattern_select[i] = new[4];
    end
    foreach(pattern_num_q[i])begin
        automatic bit [6:0] temp[$] = pattern_num_q;
        temp.sort();
        pattern_num_q = temp;
        //`uvm_info(get_type_name(),$sformatf("pattern_num_q =%d",pattern_num_q[i]),UVM_LOW);
    end
    pattern_num_q_size = pattern_num_q.size();
    for(int i=0;i<pattern_num_q_size;i++)begin
        pattern_seed_pop = pattern_num_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("pattern_num_q =%d",pattern_seed_pop),UVM_LOW);
        bist_pattern_select[i] = bist_pattern_all[pattern_seed_pop];
    end
    randomize(soft_pattern_num) with {soft_pattern_num inside{[0:$size(bist_pattern_select)-1]};};
    `uvm_info(get_type_name(),$sformatf("soft_pattern_num =%d",soft_pattern_num),UVM_LOW);
    //wl_pattern_num
    randomize(wl_pattern_cnt) with {wl_pattern_cnt dist {[1:8]:/99,[9:68]:/1};};
    `uvm_info(get_type_name(),$sformatf("wl_pattern_cnt =%d",wl_pattern_cnt),UVM_LOW);
    for(int i=0;i<wl_pattern_cnt;i++)begin
        randomize(pattern_seed) with {pattern_seed inside {[0:67]};};
        //`uvm_info(get_type_name(),$sformatf("pattern_seed =%d",pattern_seed),UVM_LOW);
        wl_pattern_num_q.push_back(pattern_seed);
    end
    wl_pattern_num_q_copy = wl_pattern_num_q;
    wl_bist_pattern_select = new[wl_pattern_num_q.size()];
    foreach(wl_bist_pattern_select[i])begin
        wl_bist_pattern_select[i] = new[4];
    end
    foreach(wl_pattern_num_q[i])begin
        automatic bit [6:0] temp[$] = wl_pattern_num_q;
        temp.sort();
        wl_pattern_num_q = temp;
        //`uvm_info(get_type_name(),$sformatf("pattern_num_q =%d",pattern_num_q[i]),UVM_LOW);
    end
    wl_pattern_num_q_size = wl_pattern_num_q.size();
    for(int i=0;i<wl_pattern_num_q_size;i++)begin
        pattern_seed_pop = wl_pattern_num_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("wl_pattern_num_q =%d",pattern_seed_pop),UVM_LOW);
        wl_bist_pattern_select[i] = bist_pattern_all[pattern_seed_pop];
    end
    randomize(wl_soft_pattern_num) with {wl_soft_pattern_num inside{[0:$size(wl_bist_pattern_select)-1]};};
    `uvm_info(get_type_name(),$sformatf("wl_soft_pattern_num =%d",wl_soft_pattern_num),UVM_LOW);
    //err_gradd
    err_gradd_product(0,err_gradd_q0,soft_err_gradd0);
    err_gradd_product(1,err_gradd_q1,soft_err_gradd1);
    err_gradd_product(2,err_gradd_q2,soft_err_gradd2);
    err_gradd_product(3,err_gradd_q3,soft_err_gradd3);
    err_gradd_product(4,err_gradd_q4,soft_err_gradd4);
    err_gradd_product(5,err_gradd_q5,soft_err_gradd5);
    err_gradd_product(6,err_gradd_q6,soft_err_gradd6);
    err_gradd_product(7,err_gradd_q7,soft_err_gradd7);
    err_gradd_product(8,err_gradd_q8,soft_err_gradd8);
    err_gradd_product(9,err_gradd_q9,soft_err_gradd9);


    //product csl_err
    err_csl_product(vmc_csl_addr_q0,vmc_csl_addr_q_total);
    err_csl_product(vmc_csl_addr_q1,vmc_csl_addr_q_total);
    err_csl_product(vmc_csl_addr_q2,vmc_csl_addr_q_total);
    err_csl_product(vmc_csl_addr_q3,vmc_csl_addr_q_total);
    err_csl_product(vmc_csl_addr_q4,vmc_csl_addr_q_total);
    err_csl_product(vmc_csl_addr_q5,vmc_csl_addr_q_total);
    err_csl_product(vmc_csl_addr_q6,vmc_csl_addr_q_total);
    err_csl_product(vmc_csl_addr_q7,vmc_csl_addr_q_total);
    err_csl_product(vmc_csl_addr_q8,vmc_csl_addr_q_total);
    err_csl_product(vmc_csl_addr_q9,vmc_csl_addr_q_total);

    //product err_model
    err_model_product(vmc_csl_addr_q0,err_gradd_q0,soft_err_gradd0,err_position_q0,soft_err_position0,compare_csl_result_q0,filtered_err_gradd_q0_select,filtered_err_gradd_q0_size);
    err_model_product(vmc_csl_addr_q1,err_gradd_q1,soft_err_gradd1,err_position_q1,soft_err_position1,compare_csl_result_q1,filtered_err_gradd_q1_select,filtered_err_gradd_q1_size);
    err_model_product(vmc_csl_addr_q2,err_gradd_q2,soft_err_gradd2,err_position_q2,soft_err_position2,compare_csl_result_q2,filtered_err_gradd_q2_select,filtered_err_gradd_q2_size);
    err_model_product(vmc_csl_addr_q3,err_gradd_q3,soft_err_gradd3,err_position_q3,soft_err_position3,compare_csl_result_q3,filtered_err_gradd_q3_select,filtered_err_gradd_q3_size);
    err_model_product(vmc_csl_addr_q4,err_gradd_q4,soft_err_gradd4,err_position_q4,soft_err_position4,compare_csl_result_q4,filtered_err_gradd_q4_select,filtered_err_gradd_q4_size);
    err_model_product(vmc_csl_addr_q5,err_gradd_q5,soft_err_gradd5,err_position_q5,soft_err_position5,compare_csl_result_q5,filtered_err_gradd_q5_select,filtered_err_gradd_q5_size);
    err_model_product(vmc_csl_addr_q6,err_gradd_q6,soft_err_gradd6,err_position_q6,soft_err_position6,compare_csl_result_q6,filtered_err_gradd_q6_select,filtered_err_gradd_q6_size);
    err_model_product(vmc_csl_addr_q7,err_gradd_q7,soft_err_gradd7,err_position_q7,soft_err_position7,compare_csl_result_q7,filtered_err_gradd_q7_select,filtered_err_gradd_q7_size);
    err_model_product(vmc_csl_addr_q8,err_gradd_q8,soft_err_gradd8,err_position_q8,soft_err_position8,compare_csl_result_q8,filtered_err_gradd_q8_select,filtered_err_gradd_q8_size);
    err_model_product(vmc_csl_addr_q9,err_gradd_q9,soft_err_gradd9,err_position_q9,soft_err_position9,compare_csl_result_q9,filtered_err_gradd_q9_select,filtered_err_gradd_q9_size);
    //scan_num
    foreach(pattern_num_q_copy[i])begin
        scan_num = scan_num^(1<<pattern_num_q_copy[i]);
    end
    `uvm_info(get_type_name(),$sformatf("scan_num=%b",scan_num),UVM_LOW);
    foreach(wl_pattern_num_q_copy[i])begin
        wl_scan_num = wl_scan_num^(1<<wl_pattern_num_q_copy[i]);
    end
    `uvm_info(get_type_name(),$sformatf("wl_scan_num=%b",wl_scan_num),UVM_LOW);

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
   
    //inject error
    foreach(vmc_csl_addr_q0[i])begin//part0
        foreach(err_gradd_q0[j])begin
            foreach(err_position_q0[k])begin
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{err_gradd_q0[j],vmc_csl_addr_q0[i]},err_position_q0[k]),err_0_1);
                `ifdef TEST_1_SHOT_1
                `elsif TEST_1_SHOT_2
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q0[j],vmc_csl_addr_q0[i]},err_position_q0[k]),err_0_1);
                `elsif TEST_1_SHOT_3
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q0[j],vmc_csl_addr_q0[i]},err_position_q0[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q0[j],vmc_csl_addr_q0[i]},err_position_q0[k]),err_0_1);
                `elsif TEST_1_SHOT_4
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q0[j],vmc_csl_addr_q0[i]},err_position_q0[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q0[j],vmc_csl_addr_q0[i]},err_position_q0[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{err_gradd_q0[j],vmc_csl_addr_q0[i]},err_position_q0[k]),err_0_1);
                `else
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q0[j],vmc_csl_addr_q0[i]},err_position_q0[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q0[j],vmc_csl_addr_q0[i]},err_position_q0[k]),err_0_1);
                `endif
                `uvm_info(get_type_name(),$sformatf("row0 =%0d, csl0 =%0d, err_pos =%0d",err_gradd_q0[j],vmc_csl_addr_q0[i],err_position_q0[k]),UVM_LOW);
            end
        end
    end
    foreach(vmc_csl_addr_q1[i])begin//part1
        foreach(err_gradd_q1[j])begin
            foreach(err_position_q1[k])begin
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{err_gradd_q1[j],vmc_csl_addr_q1[i]},err_position_q1[k]),err_0_1);
                `ifdef TEST_1_SHOT_1
                `elsif TEST_1_SHOT_2
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q1[j],vmc_csl_addr_q1[i]},err_position_q1[k]),err_0_1);
                `elsif TEST_1_SHOT_3
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q1[j],vmc_csl_addr_q1[i]},err_position_q1[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q1[j],vmc_csl_addr_q1[i]},err_position_q1[k]),err_0_1);
                `elsif TEST_1_SHOT_4
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q1[j],vmc_csl_addr_q1[i]},err_position_q1[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q1[j],vmc_csl_addr_q1[i]},err_position_q1[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{err_gradd_q1[j],vmc_csl_addr_q1[i]},err_position_q1[k]),err_0_1);
                `else
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q1[j],vmc_csl_addr_q1[i]},err_position_q1[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q1[j],vmc_csl_addr_q1[i]},err_position_q1[k]),err_0_1);
                `endif
                `uvm_info(get_type_name(),$sformatf("row1 =%0d, csl1 =%0d, err_pos =%0d",err_gradd_q1[j],vmc_csl_addr_q1[i],err_position_q1[k]),UVM_LOW);
            end
        end
    end
    foreach(vmc_csl_addr_q2[i])begin//part2
        foreach(err_gradd_q2[j])begin
            foreach(err_position_q2[k])begin
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{err_gradd_q2[j],vmc_csl_addr_q2[i]},err_position_q2[k]),err_0_1);
                `ifdef TEST_1_SHOT_1
                `elsif TEST_1_SHOT_2
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q2[j],vmc_csl_addr_q2[i]},err_position_q2[k]),err_0_1);
                `elsif TEST_1_SHOT_3
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q2[j],vmc_csl_addr_q2[i]},err_position_q2[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q2[j],vmc_csl_addr_q2[i]},err_position_q2[k]),err_0_1);
                `elsif TEST_1_SHOT_4
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q2[j],vmc_csl_addr_q2[i]},err_position_q2[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q2[j],vmc_csl_addr_q2[i]},err_position_q2[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{err_gradd_q2[j],vmc_csl_addr_q2[i]},err_position_q2[k]),err_0_1);
                `else
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q2[j],vmc_csl_addr_q2[i]},err_position_q2[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q2[j],vmc_csl_addr_q2[i]},err_position_q2[k]),err_0_1);
                `endif
                `uvm_info(get_type_name(),$sformatf("row2 =%0d, csl2 =%0d, err_pos =%0d",err_gradd_q2[j],vmc_csl_addr_q2[i],err_position_q2[k]),UVM_LOW);
            end
        end
    end
    foreach(vmc_csl_addr_q3[i])begin//part3
        foreach(err_gradd_q3[j])begin
            foreach(err_position_q3[k])begin
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{err_gradd_q3[j],vmc_csl_addr_q3[i]},err_position_q3[k]),err_0_1);
                `ifdef TEST_1_SHOT_1
                `elsif TEST_1_SHOT_2
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q3[j],vmc_csl_addr_q3[i]},err_position_q3[k]),err_0_1);
                `elsif TEST_1_SHOT_3
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q3[j],vmc_csl_addr_q3[i]},err_position_q3[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q3[j],vmc_csl_addr_q3[i]},err_position_q3[k]),err_0_1);
                `elsif TEST_1_SHOT_4
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q3[j],vmc_csl_addr_q3[i]},err_position_q3[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q3[j],vmc_csl_addr_q3[i]},err_position_q3[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{err_gradd_q3[j],vmc_csl_addr_q3[i]},err_position_q3[k]),err_0_1);
                `else
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q3[j],vmc_csl_addr_q3[i]},err_position_q3[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q3[j],vmc_csl_addr_q3[i]},err_position_q3[k]),err_0_1);
                `endif
                `uvm_info(get_type_name(),$sformatf("row3 =%0d, csl3 =%0d, err_pos =%0d",err_gradd_q3[j],vmc_csl_addr_q3[i],err_position_q3[k]),UVM_LOW);
            end
        end
    end
    foreach(vmc_csl_addr_q4[i])begin//part4
        foreach(err_gradd_q4[j])begin
            foreach(err_position_q4[k])begin
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{err_gradd_q4[j],vmc_csl_addr_q4[i]},err_position_q4[k]),err_0_1);
                `ifdef TEST_1_SHOT_1
                `elsif TEST_1_SHOT_2
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q4[j],vmc_csl_addr_q4[i]},err_position_q4[k]),err_0_1);
                `elsif TEST_1_SHOT_3
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q4[j],vmc_csl_addr_q4[i]},err_position_q4[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q4[j],vmc_csl_addr_q4[i]},err_position_q4[k]),err_0_1);
                `elsif TEST_1_SHOT_4
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q4[j],vmc_csl_addr_q4[i]},err_position_q4[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q4[j],vmc_csl_addr_q4[i]},err_position_q4[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{err_gradd_q4[j],vmc_csl_addr_q4[i]},err_position_q4[k]),err_0_1);
                `else
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q4[j],vmc_csl_addr_q4[i]},err_position_q4[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q4[j],vmc_csl_addr_q4[i]},err_position_q4[k]),err_0_1);
                `endif
                `uvm_info(get_type_name(),$sformatf("row4 =%0d, csl4 =%0d, err_pos =%0d",err_gradd_q4[j],vmc_csl_addr_q4[i],err_position_q4[k]),UVM_LOW);
            end
        end
    end
    foreach(vmc_csl_addr_q5[i])begin//part5
        foreach(err_gradd_q5[j])begin
            foreach(err_position_q5[k])begin
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{err_gradd_q5[j],vmc_csl_addr_q5[i]},err_position_q5[k]),err_0_1);
                `ifdef TEST_1_SHOT_1
                `elsif TEST_1_SHOT_2
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q5[j],vmc_csl_addr_q5[i]},err_position_q5[k]),err_0_1);
                `elsif TEST_1_SHOT_3
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q5[j],vmc_csl_addr_q5[i]},err_position_q5[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q5[j],vmc_csl_addr_q5[i]},err_position_q5[k]),err_0_1);
                `elsif TEST_1_SHOT_4
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q5[j],vmc_csl_addr_q5[i]},err_position_q5[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q5[j],vmc_csl_addr_q5[i]},err_position_q5[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{err_gradd_q5[j],vmc_csl_addr_q5[i]},err_position_q5[k]),err_0_1);
                `else
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q5[j],vmc_csl_addr_q5[i]},err_position_q5[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q5[j],vmc_csl_addr_q5[i]},err_position_q5[k]),err_0_1);
                `endif
                `uvm_info(get_type_name(),$sformatf("row5 =%0d, csl5 =%0d, err_pos =%0d",err_gradd_q5[j],vmc_csl_addr_q5[i],err_position_q5[k]),UVM_LOW);
            end
        end
    end
    foreach(vmc_csl_addr_q6[i])begin//part6
        foreach(err_gradd_q6[j])begin
            foreach(err_position_q6[k])begin
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{err_gradd_q6[j],vmc_csl_addr_q6[i]},err_position_q6[k]),err_0_1);
                `ifdef TEST_1_SHOT_1
                `elsif TEST_1_SHOT_2
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q6[j],vmc_csl_addr_q6[i]},err_position_q6[k]),err_0_1);
                `elsif TEST_1_SHOT_3
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q6[j],vmc_csl_addr_q6[i]},err_position_q6[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q6[j],vmc_csl_addr_q6[i]},err_position_q6[k]),err_0_1);
                `elsif TEST_1_SHOT_4
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q6[j],vmc_csl_addr_q6[i]},err_position_q6[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q6[j],vmc_csl_addr_q6[i]},err_position_q6[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{err_gradd_q6[j],vmc_csl_addr_q6[i]},err_position_q6[k]),err_0_1);
                `else
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q6[j],vmc_csl_addr_q6[i]},err_position_q6[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q6[j],vmc_csl_addr_q6[i]},err_position_q6[k]),err_0_1);
                `endif
                `uvm_info(get_type_name(),$sformatf("row6 =%0d, csl6 =%0d, err_pos =%0d",err_gradd_q6[j],vmc_csl_addr_q6[i],err_position_q6[k]),UVM_LOW);
            end
        end
    end
    foreach(vmc_csl_addr_q7[i])begin//part7
        foreach(err_gradd_q7[j])begin
            foreach(err_position_q7[k])begin
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{err_gradd_q7[j],vmc_csl_addr_q7[i]},err_position_q7[k]),err_0_1);
                `ifdef TEST_1_SHOT_1
                `elsif TEST_1_SHOT_2
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q7[j],vmc_csl_addr_q7[i]},err_position_q7[k]),err_0_1);
                `elsif TEST_1_SHOT_3
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q7[j],vmc_csl_addr_q7[i]},err_position_q7[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q7[j],vmc_csl_addr_q7[i]},err_position_q7[k]),err_0_1);
                `elsif TEST_1_SHOT_4
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q7[j],vmc_csl_addr_q7[i]},err_position_q7[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q7[j],vmc_csl_addr_q7[i]},err_position_q7[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{err_gradd_q7[j],vmc_csl_addr_q7[i]},err_position_q7[k]),err_0_1);
                `else
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q7[j],vmc_csl_addr_q7[i]},err_position_q7[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q7[j],vmc_csl_addr_q7[i]},err_position_q7[k]),err_0_1);
                `endif
                `uvm_info(get_type_name(),$sformatf("row7 =%0d, csl7 =%0d, err_pos =%0d",err_gradd_q7[j],vmc_csl_addr_q7[i],err_position_q7[k]),UVM_LOW);
            end
        end
    end
    foreach(vmc_csl_addr_q8[i])begin//part8
        foreach(err_gradd_q8[j])begin
            foreach(err_position_q8[k])begin
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{err_gradd_q8[j],vmc_csl_addr_q8[i]},err_position_q8[k]),err_0_1);
                `ifdef TEST_1_SHOT_1
                `elsif TEST_1_SHOT_2
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q8[j],vmc_csl_addr_q8[i]},err_position_q8[k]),err_0_1);
                `elsif TEST_1_SHOT_3
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q8[j],vmc_csl_addr_q8[i]},err_position_q8[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q8[j],vmc_csl_addr_q8[i]},err_position_q8[k]),err_0_1);
                `elsif TEST_1_SHOT_4
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q8[j],vmc_csl_addr_q8[i]},err_position_q8[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q8[j],vmc_csl_addr_q8[i]},err_position_q8[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{err_gradd_q8[j],vmc_csl_addr_q8[i]},err_position_q8[k]),err_0_1);
                `else
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q8[j],vmc_csl_addr_q8[i]},err_position_q8[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q8[j],vmc_csl_addr_q8[i]},err_position_q8[k]),err_0_1);
                `endif
                `uvm_info(get_type_name(),$sformatf("row8 =%0d, csl8 =%0d, err_pos =%0d",err_gradd_q8[j],vmc_csl_addr_q8[i],err_position_q8[k]),UVM_LOW);
            end
        end
    end
    foreach(vmc_csl_addr_q9[i])begin//part9
        foreach(err_gradd_q9[j])begin
            foreach(err_position_q9[k])begin
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{err_gradd_q9[j],vmc_csl_addr_q9[i]},err_position_q9[k]),err_0_1);
                `ifdef TEST_1_SHOT_1
                `elsif TEST_1_SHOT_2
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q9[j],vmc_csl_addr_q9[i]},err_position_q9[k]),err_0_1);
                `elsif TEST_1_SHOT_3
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q9[j],vmc_csl_addr_q9[i]},err_position_q9[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q9[j],vmc_csl_addr_q9[i]},err_position_q9[k]),err_0_1);
                `elsif TEST_1_SHOT_4
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q9[j],vmc_csl_addr_q9[i]},err_position_q9[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q9[j],vmc_csl_addr_q9[i]},err_position_q9[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{err_gradd_q9[j],vmc_csl_addr_q9[i]},err_position_q9[k]),err_0_1);
                `else
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{err_gradd_q9[j],vmc_csl_addr_q9[i]},err_position_q9[k]),err_0_1);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{err_gradd_q9[j],vmc_csl_addr_q9[i]},err_position_q9[k]),err_0_1);
                `endif
                `uvm_info(get_type_name(),$sformatf("row9 =%0d, csl9 =%0d, err_pos =%0d",err_gradd_q9[j],vmc_csl_addr_q9[i],err_position_q9[k]),UVM_LOW);
            end
        end
    end
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_csl_scan_check_sel.write(status,parity_en, UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_csl_scan_mode_sel.write(status,scan_mode, UVM_FRONTDOOR);

    bist_finish_mask = 0;
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg0_reg.write(status,bist_pattern64,UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg1_reg.write(status,bist_pattern65,UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg2_reg.write(status,bist_pattern66,UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg3_reg.write(status,bist_pattern67,UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.csl_bist_pattern_sel0_reg.write(status,scan_num[31:0],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.csl_bist_pattern_sel1_reg.write(status,scan_num[63:32],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.csl_bist_pattern_sel2_reg.write(status,scan_num[67:64],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.wl_bist_pattern_sel0_reg.write(status,wl_scan_num[31:0],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.wl_bist_pattern_sel1_reg.write(status,wl_scan_num[63:32],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.wl_bist_pattern_sel2_reg.write(status,wl_scan_num[67:64],UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_mask.write(status,bist_finish_mask,UVM_FRONTDOOR);
    `ifdef TEST_1_SHOT_1
        mc_bist_grant = 'h1;
    `elsif TEST_1_SHOT_2
        mc_bist_grant = $urandom_range('h3,'h1);
    `elsif TEST_1_SHOT_3
        mc_bist_grant = $urandom_range('h7,'h1);
    `elsif TEST_1_SHOT_4
        mc_bist_grant = $urandom_range('hf,'h1);
    `else
        mc_bist_grant = $urandom_range('h7,'h1);
    `endif
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bank_cfg_reg_reg.mc_bist_grant.write(status,mc_bist_grant,UVM_FRONTDOOR);

    repeat(5) @(posedge m_tb_if.pclk);
    m_tb_if.mc_scan_timeout_en=1;
    m_tb_if.csl_err_threshold   =   csl_err_th;
    m_tb_if.global_mc_bist_en   =   1;
    m_tb_if.bist_wl_scan_single_pattern_rd_num=wl_scan_cnt;
    @(posedge m_tb_if.pclk);
    m_tb_if.global_mc_bist_start=   1;
    @(posedge m_tb_if.pclk);
    m_tb_if.global_mc_bist_start=   0;

    for(int i=0;i<4;i++)begin
        if(((mc_bist_grant>>i)&4'h1)===4'h1) mc_bist_grant_q.push_back(i);
    end
    bist_num = $countones(mc_bist_grant);
    `uvm_info(get_type_name(),$sformatf("mc_bist_grant=%h,bist_num=%0d,mc_bist_grant_q_size=%0d",mc_bist_grant,bist_num,mc_bist_grant_q.size),UVM_LOW);
repeat(bist_num)begin
    m=mc_bist_grant_q.pop_front;
    `uvm_info(get_type_name(),$sformatf("enter,m =%d",m),UVM_LOW);
    index0_0=0;
    index0_1=0;
    index1_0=0;
    index1_1=0;
    index2_0=0;
    index2_1=0;
    index3_0=0;
    index3_1=0;
    index4_0=0;
    index4_1=0;
    index5_0=0;
    index5_1=0;
    index6_0=0;
    index6_1=0;
    index7_0=0;
    index7_1=0;
    index8_0=0;
    index8_1=0;
    index9_0=0;
    index9_1=0;

    fork
        begin
            wait(m_tb_if.csl_scan_working == 1);
            repeat(1) @(posedge m_tb_if.clk);
            while(m_tb_if.csl_scan_working == 1)begin
                @(posedge m_tb_if.clk);
            end
            wait(m_tb_if.csl_scan_working == 0);
            #1ps;
            csl_stop_wl_csl(filtered_err_gradd_q0_size,vmc_csl_addr_q0,filtered_err_gradd_q1_size,vmc_csl_addr_q1,filtered_err_gradd_q2_size,vmc_csl_addr_q2,filtered_err_gradd_q3_size,vmc_csl_addr_q3,filtered_err_gradd_q4_size,vmc_csl_addr_q4,filtered_err_gradd_q5_size,vmc_csl_addr_q5,filtered_err_gradd_q6_size,vmc_csl_addr_q6,filtered_err_gradd_q7_size,vmc_csl_addr_q7,filtered_err_gradd_q8_size,vmc_csl_addr_q8,filtered_err_gradd_q9_size,vmc_csl_addr_q9,csl_part_num);
            if(scan_mode==0)begin
                if(csl_part_num==10)begin
                    if(m_tb_if.gradd_n!=299&&m_tb_if.gcadd!=129)begin
                        `uvm_error("bist_csl_wl", "bist scan mode check fail")
                    end
                end
                if(csl_part_num==0)begin
                    if(m_tb_if.gcadd!=vmc_csl_addr_q0[2]&&(m_tb_if.gradd_n!=filtered_err_gradd_q0_select[csl_err_th-1]||m_tb_if.gradd_n!=soft_err_gradd0))begin
                        `uvm_error("bist_csl_wl", "bist scan mode check fail")
                    end
                end            
                if(csl_part_num==1)begin
                    if(m_tb_if.gcadd!=vmc_csl_addr_q1[2]&&(m_tb_if.gradd_n!=filtered_err_gradd_q1_select[csl_err_th-1]||m_tb_if.gradd_n!=soft_err_gradd1))begin
                        `uvm_error("bist_csl_wl", "bist scan mode check fail")
                    end
                end
                if(csl_part_num==2)begin
                    if(m_tb_if.gcadd!=vmc_csl_addr_q2[2]&&(m_tb_if.gradd_n!=filtered_err_gradd_q2_select[csl_err_th-1]||m_tb_if.gradd_n!=soft_err_gradd2))begin
                        `uvm_error("bist_csl_wl", "bist scan mode check fail")
                    end
                end
                if(csl_part_num==3)begin
                    if(m_tb_if.gcadd!=vmc_csl_addr_q3[2]&&(m_tb_if.gradd_n!=filtered_err_gradd_q3_select[csl_err_th-1]||m_tb_if.gradd_n!=soft_err_gradd3))begin
                        `uvm_error("bist_csl_wl", "bist scan mode check fail")
                    end
                end
                if(csl_part_num==4)begin
                    if(m_tb_if.gcadd!=vmc_csl_addr_q4[2]&&(m_tb_if.gradd_n!=filtered_err_gradd_q4_select[csl_err_th-1]||m_tb_if.gradd_n!=soft_err_gradd4))begin
                        `uvm_error("bist_csl_wl", "bist scan mode check fail")
                    end
                end
                if(csl_part_num==5)begin
                    if(m_tb_if.gcadd!=vmc_csl_addr_q5[2]&&(m_tb_if.gradd_n!=filtered_err_gradd_q5_select[csl_err_th-1]||m_tb_if.gradd_n!=soft_err_gradd5))begin
                        `uvm_error("bist_csl_wl", "bist scan mode check fail")
                    end
                end
                if(csl_part_num==6)begin
                    if(m_tb_if.gcadd!=vmc_csl_addr_q6[2]&&(m_tb_if.gradd_n!=filtered_err_gradd_q6_select[csl_err_th-1]||m_tb_if.gradd_n!=soft_err_gradd6))begin
                        `uvm_error("bist_csl_wl", "bist scan mode check fail")
                    end
                end
                if(csl_part_num==7)begin
                    if(m_tb_if.gcadd!=vmc_csl_addr_q7[2]&&(m_tb_if.gradd_n!=filtered_err_gradd_q7_select[csl_err_th-1]||m_tb_if.gradd_n!=soft_err_gradd7))begin
                        `uvm_error("bist_csl_wl", "bist scan mode check fail")
                    end
                end
                if(csl_part_num==8)begin
                    if(m_tb_if.gcadd!=vmc_csl_addr_q8[2]&&(m_tb_if.gradd_n!=filtered_err_gradd_q8_select[csl_err_th-1]||m_tb_if.gradd_n!=soft_err_gradd8))begin
                        `uvm_error("bist_csl_wl", "bist scan mode check fail")
                    end
                end
                if(csl_part_num==9)begin
                    if(m_tb_if.gcadd!=vmc_csl_addr_q9[2]&&(m_tb_if.gradd_n!=filtered_err_gradd_q9_select[csl_err_th-1]||m_tb_if.gradd_n!=soft_err_gradd9))begin
                        `uvm_error("bist_csl_wl", "bist scan mode check fail")
                    end
                end
            end
            else begin
                if(m_tb_if.gradd_n!=299&&m_tb_if.gcadd!=129)begin
                    `uvm_error("bist_csl_wl", "bist scan mode check fail")
                end
            end
        end
        begin
            wait(m_tb_if.csl_scan_working == 1);
            soft_num = 0;
            fork : csl_result_check
                begin
                    while(m_tb_if.csl_scan_working == 1)begin
                        @(negedge m_tb_if.clk);
                        if(soft_pattern_num==soft_num)begin
                            foreach(vmc_csl_addr_q0[i])begin//part0
                                if(m===0) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd0,vmc_csl_addr_q0[i]},soft_err_position0),err_0_1);
                                if(m===1) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd0,vmc_csl_addr_q0[i]},soft_err_position0),err_0_1);
                                if(m===2) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd0,vmc_csl_addr_q0[i]},soft_err_position0),err_0_1);
                                if(m===3) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd0,vmc_csl_addr_q0[i]},soft_err_position0),err_0_1);
                                `uvm_info(get_type_name(),$sformatf("soft row0 =%0d, csl0 =%0d, err_pos =%0d",soft_err_gradd0,vmc_csl_addr_q0[i],soft_err_position0),UVM_LOW);
                            end
                            foreach(vmc_csl_addr_q1[i])begin//part1
                                if(m===0) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd1,vmc_csl_addr_q1[i]},soft_err_position1),err_0_1);
                                if(m===1) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd1,vmc_csl_addr_q1[i]},soft_err_position1),err_0_1);
                                if(m===2) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd1,vmc_csl_addr_q1[i]},soft_err_position1),err_0_1);
                                if(m===3) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd1,vmc_csl_addr_q1[i]},soft_err_position1),err_0_1);
                                `uvm_info(get_type_name(),$sformatf("soft row1 =%0d, csl1 =%0d, err_pos =%0d",soft_err_gradd1,vmc_csl_addr_q1[i],soft_err_position1),UVM_LOW);
                            end
                            foreach(vmc_csl_addr_q2[i])begin//part2
                                if(m===0) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd2,vmc_csl_addr_q2[i]},soft_err_position2),err_0_1);
                                if(m===1) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd2,vmc_csl_addr_q2[i]},soft_err_position2),err_0_1);
                                if(m===2) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd2,vmc_csl_addr_q2[i]},soft_err_position2),err_0_1);
                                if(m===3) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd2,vmc_csl_addr_q2[i]},soft_err_position2),err_0_1);
                                `uvm_info(get_type_name(),$sformatf("soft row2 =%0d, csl2 =%0d, err_pos =%0d",soft_err_gradd2,vmc_csl_addr_q2[i],soft_err_position2),UVM_LOW);
                            end
                            foreach(vmc_csl_addr_q3[i])begin//part3
                                if(m===0) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd3,vmc_csl_addr_q3[i]},soft_err_position3),err_0_1);
                                if(m===1) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd3,vmc_csl_addr_q3[i]},soft_err_position3),err_0_1);
                                if(m===2) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd3,vmc_csl_addr_q3[i]},soft_err_position3),err_0_1);
                                if(m===3) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd3,vmc_csl_addr_q3[i]},soft_err_position3),err_0_1);
                                `uvm_info(get_type_name(),$sformatf("soft row3 =%0d, csl3 =%0d, err_pos =%0d",soft_err_gradd3,vmc_csl_addr_q3[i],soft_err_position3),UVM_LOW);
                            end
                            foreach(vmc_csl_addr_q4[i])begin//part4
                                if(m===0) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd4,vmc_csl_addr_q4[i]},soft_err_position4),err_0_1);
                                if(m===1) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd4,vmc_csl_addr_q4[i]},soft_err_position4),err_0_1);
                                if(m===2) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd4,vmc_csl_addr_q4[i]},soft_err_position4),err_0_1);
                                if(m===3) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd4,vmc_csl_addr_q4[i]},soft_err_position4),err_0_1);
                                `uvm_info(get_type_name(),$sformatf("soft row4 =%0d, csl4 =%0d, err_pos =%0d",soft_err_gradd4,vmc_csl_addr_q4[i],soft_err_position4),UVM_LOW);
                            end
                            foreach(vmc_csl_addr_q5[i])begin//part5
                                if(m===0) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd5,vmc_csl_addr_q5[i]},soft_err_position5),err_0_1);
                                if(m===1) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd5,vmc_csl_addr_q5[i]},soft_err_position5),err_0_1);
                                if(m===2) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd5,vmc_csl_addr_q5[i]},soft_err_position5),err_0_1);
                                if(m===3) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd5,vmc_csl_addr_q5[i]},soft_err_position5),err_0_1);
                                `uvm_info(get_type_name(),$sformatf("soft row5 =%0d, csl5 =%0d, err_pos =%0d",soft_err_gradd5,vmc_csl_addr_q5[i],soft_err_position5),UVM_LOW);
                            end
                            foreach(vmc_csl_addr_q6[i])begin//part6
                                if(m===0) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd6,vmc_csl_addr_q6[i]},soft_err_position6),err_0_1);
                                if(m===1) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd6,vmc_csl_addr_q6[i]},soft_err_position6),err_0_1);
                                if(m===2) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd6,vmc_csl_addr_q6[i]},soft_err_position6),err_0_1);
                                if(m===3) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd6,vmc_csl_addr_q6[i]},soft_err_position6),err_0_1);
                                `uvm_info(get_type_name(),$sformatf("soft row6 =%0d, csl6 =%0d, err_pos =%0d",soft_err_gradd6,vmc_csl_addr_q6[i],soft_err_position6),UVM_LOW);
                            end
                            foreach(vmc_csl_addr_q7[i])begin//part7
                                if(m===0) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd7,vmc_csl_addr_q7[i]},soft_err_position7),err_0_1);
                                if(m===1) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd7,vmc_csl_addr_q7[i]},soft_err_position7),err_0_1);
                                if(m===2) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd7,vmc_csl_addr_q7[i]},soft_err_position7),err_0_1);
                                if(m===3) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd7,vmc_csl_addr_q7[i]},soft_err_position7),err_0_1);
                                `uvm_info(get_type_name(),$sformatf("soft row7 =%0d, csl7 =%0d, err_pos =%0d",soft_err_gradd7,vmc_csl_addr_q7[i],soft_err_position7),UVM_LOW);
                            end
                            foreach(vmc_csl_addr_q8[i])begin//part8
                                if(m===0) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd8,vmc_csl_addr_q8[i]},soft_err_position8),err_0_1);
                                if(m===1) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd8,vmc_csl_addr_q8[i]},soft_err_position8),err_0_1);
                                if(m===2) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd8,vmc_csl_addr_q8[i]},soft_err_position8),err_0_1);
                                if(m===3) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd8,vmc_csl_addr_q8[i]},soft_err_position8),err_0_1);
                                `uvm_info(get_type_name(),$sformatf("soft row8 =%0d, csl8 =%0d, err_pos =%0d",soft_err_gradd8,vmc_csl_addr_q8[i],soft_err_position8),UVM_LOW);
                            end
                            foreach(vmc_csl_addr_q9[i])begin//part9
                                if(m===0) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd9,vmc_csl_addr_q9[i]},soft_err_position9),err_0_1);
                                if(m===1) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd9,vmc_csl_addr_q9[i]},soft_err_position9),err_0_1);
                                if(m===2) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd9,vmc_csl_addr_q9[i]},soft_err_position9),err_0_1);
                                if(m===3) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd9,vmc_csl_addr_q9[i]},soft_err_position9),err_0_1);
                                `uvm_info(get_type_name(),$sformatf("soft row9 =%0d, csl9 =%0d, err_pos =%0d",soft_err_gradd9,vmc_csl_addr_q9[i],soft_err_position9),UVM_LOW);
                            end
                        end
                        while(m_tb_if.csl_single_pattern_done==0)begin
                            @(posedge m_tb_if.clk);
                        end
                        foreach(vmc_csl_addr_q0[i])begin//part0
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd0,vmc_csl_addr_q0[i]},soft_err_position0));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd0,vmc_csl_addr_q0[i]},soft_err_position0));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd0,vmc_csl_addr_q0[i]},soft_err_position0));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd0,vmc_csl_addr_q0[i]},soft_err_position0));
                            `uvm_info(get_type_name(),$sformatf("soft row0 =%0d, csl0 =%0d, err_pos =%0d",soft_err_gradd0,vmc_csl_addr_q0[i],soft_err_position0),UVM_LOW);
                        end
                        foreach(vmc_csl_addr_q1[i])begin//part1
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd1,vmc_csl_addr_q1[i]},soft_err_position1));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd1,vmc_csl_addr_q1[i]},soft_err_position1));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd1,vmc_csl_addr_q1[i]},soft_err_position1));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd1,vmc_csl_addr_q1[i]},soft_err_position1));
                            `uvm_info(get_type_name(),$sformatf("soft row1 =%0d, csl1 =%0d, err_pos =%0d",soft_err_gradd1,vmc_csl_addr_q1[i],soft_err_position1),UVM_LOW);
                        end
                        foreach(vmc_csl_addr_q2[i])begin//part2
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd2,vmc_csl_addr_q2[i]},soft_err_position2));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd2,vmc_csl_addr_q2[i]},soft_err_position2));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd2,vmc_csl_addr_q2[i]},soft_err_position2));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd2,vmc_csl_addr_q2[i]},soft_err_position2));
                            `uvm_info(get_type_name(),$sformatf("soft row2 =%0d, csl2 =%0d, err_pos =%0d",soft_err_gradd2,vmc_csl_addr_q2[i],soft_err_position2),UVM_LOW);
                        end
                        foreach(vmc_csl_addr_q3[i])begin//part3
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd3,vmc_csl_addr_q3[i]},soft_err_position3));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd3,vmc_csl_addr_q3[i]},soft_err_position3));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd3,vmc_csl_addr_q3[i]},soft_err_position3));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd3,vmc_csl_addr_q3[i]},soft_err_position3));
                            `uvm_info(get_type_name(),$sformatf("soft row3 =%0d, csl3 =%0d, err_pos =%0d",soft_err_gradd3,vmc_csl_addr_q3[i],soft_err_position3),UVM_LOW);
                        end
                        foreach(vmc_csl_addr_q4[i])begin//part4
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd4,vmc_csl_addr_q4[i]},soft_err_position4));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd4,vmc_csl_addr_q4[i]},soft_err_position4));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd4,vmc_csl_addr_q4[i]},soft_err_position4));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd4,vmc_csl_addr_q4[i]},soft_err_position4));
                            `uvm_info(get_type_name(),$sformatf("soft row4 =%0d, csl4 =%0d, err_pos =%0d",soft_err_gradd4,vmc_csl_addr_q4[i],soft_err_position4),UVM_LOW);
                        end
                        foreach(vmc_csl_addr_q5[i])begin//part5
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd5,vmc_csl_addr_q5[i]},soft_err_position5));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd5,vmc_csl_addr_q5[i]},soft_err_position5));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd5,vmc_csl_addr_q5[i]},soft_err_position5));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd5,vmc_csl_addr_q5[i]},soft_err_position5));
                            `uvm_info(get_type_name(),$sformatf("soft row5 =%0d, csl5 =%0d, err_pos =%0d",soft_err_gradd5,vmc_csl_addr_q5[i],soft_err_position5),UVM_LOW);
                        end
                        foreach(vmc_csl_addr_q6[i])begin//part6
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd6,vmc_csl_addr_q6[i]},soft_err_position6));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd6,vmc_csl_addr_q6[i]},soft_err_position6));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd6,vmc_csl_addr_q6[i]},soft_err_position6));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd6,vmc_csl_addr_q6[i]},soft_err_position6));
                            `uvm_info(get_type_name(),$sformatf("soft row6 =%0d, csl6 =%0d, err_pos =%0d",soft_err_gradd6,vmc_csl_addr_q6[i],soft_err_position6),UVM_LOW);
                        end
                        foreach(vmc_csl_addr_q7[i])begin//part7
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd7,vmc_csl_addr_q7[i]},soft_err_position7));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd7,vmc_csl_addr_q7[i]},soft_err_position7));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd7,vmc_csl_addr_q7[i]},soft_err_position7));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd7,vmc_csl_addr_q7[i]},soft_err_position7));
                            `uvm_info(get_type_name(),$sformatf("soft row7 =%0d, csl7 =%0d, err_pos =%0d",soft_err_gradd7,vmc_csl_addr_q7[i],soft_err_position7),UVM_LOW);
                        end
                        foreach(vmc_csl_addr_q8[i])begin//part8
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd8,vmc_csl_addr_q8[i]},soft_err_position8));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd8,vmc_csl_addr_q8[i]},soft_err_position8));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd8,vmc_csl_addr_q8[i]},soft_err_position8));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd8,vmc_csl_addr_q8[i]},soft_err_position8));
                            `uvm_info(get_type_name(),$sformatf("soft row8 =%0d, csl8 =%0d, err_pos =%0d",soft_err_gradd8,vmc_csl_addr_q8[i],soft_err_position8),UVM_LOW);
                        end
                        foreach(vmc_csl_addr_q9[i])begin//part9
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd9,vmc_csl_addr_q9[i]},soft_err_position9));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd9,vmc_csl_addr_q9[i]},soft_err_position9));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd9,vmc_csl_addr_q9[i]},soft_err_position9));
                            uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd9,vmc_csl_addr_q9[i]},soft_err_position9));
                            `uvm_info(get_type_name(),$sformatf("soft row9 =%0d, csl9 =%0d, err_pos =%0d",soft_err_gradd9,vmc_csl_addr_q9[i],soft_err_position9),UVM_LOW);
                        end
                        soft_num=soft_num+1;
                        `uvm_info(get_type_name(),$sformatf("m=%0d,soft_num=%0d,soft_pattern_num=%0d",m,soft_num,soft_pattern_num),UVM_LOW);
                        #10ns; 
                        //{{{
                        begin
                            if(vmc_csl_addr_q0.size()>0)begin
                                if(enter_num==0) compare_csl_result_q0_pop=compare_csl_result_q0.pop_front();
                                else compare_csl_result_q0_pop=compare_csl_result_q0_tmp.pop_front();
                                compare_csl_result_q0_tmp.push_back(compare_csl_result_q0_pop);
                                `uvm_info(get_type_name(),$sformatf("compare_csl_result=%d,compare_csl_result_q0_size=%0d",compare_csl_result_q0_pop,compare_csl_result_q0.size),UVM_LOW);
                                if(compare_csl_result_q0_pop!=0)begin
                                    if(vmc_csl_addr_q0.size==0)begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                    else if(vmc_csl_addr_q0.size==1)begin
                                        for(int i=0;i<vmc_csl_addr_q0.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q0[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q0[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                        index0_0=1;
                                    end
                                    else begin
                                        for(int i=0;i<vmc_csl_addr_q0.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q0[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d,i=%0d,m=%0d",read_data_csl,vmc_csl_addr_q0[i],i,m))
                                                end
                                            end
                                        end
                                        index0_1=1;
                                    end
                                end
                                else begin
                                    if(index0_0==1)begin
                                        for(int i=0;i<vmc_csl_addr_q0.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q0[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q0[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                    end
                                    else if(index0_1==1)begin
                                        for(int i=0;i<vmc_csl_addr_q0.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q0[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q0[i]))
                                                end
                                            end
                                        end
                                    end
                                    else begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                end
                            end
                        //end
                        end
                        begin
                        //for(int m=0;m<`BANK_ADDR_WIDTH;m++)begin
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl);
                            if(vmc_csl_addr_q1.size()>0&&((vmc_csl_addr_q0.size()<3||(vmc_csl_addr_q0.size()>2&&read_data_csl==8'hff))||scan_mode==1))begin
                                if(enter_num==0) compare_csl_result_q1_pop=compare_csl_result_q1.pop_front();
                                else compare_csl_result_q1_pop=compare_csl_result_q1_tmp.pop_front();
                                compare_csl_result_q1_tmp.push_back(compare_csl_result_q1_pop);
                                `uvm_info(get_type_name(),$sformatf("compare_csl_result=%d",compare_csl_result_q1_pop),UVM_LOW);
                                if(compare_csl_result_q1_pop!=0)begin
                                    if(vmc_csl_addr_q1.size==0)begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                    else if(vmc_csl_addr_q1.size==1)begin
                                        for(int i=0;i<vmc_csl_addr_q1.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q1[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q1[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                        index1_0=1;
                                    end
                                    else begin
                                        for(int i=0;i<vmc_csl_addr_q1.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q1[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q1[i]))
                                                end
                                            end
                                        end
                                        index1_1=1;
                                    end
                                end
                                else begin
                                    if(index1_0==1)begin
                                        for(int i=0;i<vmc_csl_addr_q1.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q1[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q1[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                    end
                                    else if(index1_1==1)begin
                                        for(int i=0;i<vmc_csl_addr_q1.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q1[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q1[i]))
                                                end
                                            end
                                        end
                                    end
                                    else begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                end
                            end
                        //end
                        end
                        begin
                        //for(int m=0;m<`BANK_ADDR_WIDTH;m++)begin
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl1);
                            if(vmc_csl_addr_q2.size()>0&&(((vmc_csl_addr_q0.size()<3||(vmc_csl_addr_q0.size()>2&&read_data_csl==8'hff))&&(vmc_csl_addr_q1.size()<3||(vmc_csl_addr_q1.size()>2&&read_data_csl1==8'hff)))||scan_mode==1))begin
                                if(enter_num==0) compare_csl_result_q2_pop=compare_csl_result_q2.pop_front();
                                else compare_csl_result_q2_pop=compare_csl_result_q2_tmp.pop_front();
                                compare_csl_result_q2_tmp.push_back(compare_csl_result_q2_pop);
                                `uvm_info(get_type_name(),$sformatf("compare_csl_result=%d",compare_csl_result_q2_pop),UVM_LOW);
                                if(compare_csl_result_q2_pop!=0)begin
                                    if(vmc_csl_addr_q2.size==0)begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                    else if(vmc_csl_addr_q2.size==1)begin
                                        for(int i=0;i<vmc_csl_addr_q2.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q2[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q2[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                        index2_0=1;
                                    end
                                    else begin
                                        for(int i=0;i<vmc_csl_addr_q2.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q2[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q2[i]))
                                                end
                                            end
                                        end
                                        index2_1=1;
                                    end
                                end
                                else begin
                                    if(index2_0==1)begin
                                        for(int i=0;i<vmc_csl_addr_q2.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q2[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q2[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                    end
                                    else if(index2_1==1)begin
                                        for(int i=0;i<vmc_csl_addr_q2.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q2[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q2[i]))
                                                end
                                            end
                                        end
                                    end
                                    else begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                end
                            end
                        //end
                        end
                        begin
                        //for(int m=0;m<`BANK_ADDR_WIDTH;m++)begin
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl1);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl2);
                            if(vmc_csl_addr_q3.size()>0&&(((vmc_csl_addr_q0.size()<3||(vmc_csl_addr_q0.size()>2&&read_data_csl==8'hff))&&(vmc_csl_addr_q1.size()<3||(vmc_csl_addr_q1.size()>2&&read_data_csl1==8'hff))&&(vmc_csl_addr_q2.size()<3||(vmc_csl_addr_q2.size()>2&&read_data_csl2==8'hff)))||scan_mode==1))begin
                                if(enter_num==0) compare_csl_result_q3_pop=compare_csl_result_q3.pop_front();
                                else compare_csl_result_q3_pop=compare_csl_result_q3_tmp.pop_front();
                                compare_csl_result_q3_tmp.push_back(compare_csl_result_q3_pop);
                                `uvm_info(get_type_name(),$sformatf("compare_csl_result=%d",compare_csl_result_q3_pop),UVM_LOW);
                                if(compare_csl_result_q3_pop!=0)begin
                                    if(vmc_csl_addr_q3.size==0)begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                    else if(vmc_csl_addr_q3.size==1)begin
                                        for(int i=0;i<vmc_csl_addr_q3.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q3[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q3[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                        index3_0=1;
                                    end
                                    else begin
                                        for(int i=0;i<vmc_csl_addr_q3.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q3[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q3[i]))
                                                end
                                            end
                                        end
                                        index3_1=1;
                                    end
                                end
                                else begin
                                    if(index3_0==1)begin
                                        for(int i=0;i<vmc_csl_addr_q3.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q3[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q3[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                    end
                                    else if(index3_1==1)begin
                                        for(int i=0;i<vmc_csl_addr_q3.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q3[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q3[i]))
                                                end
                                            end
                                        end
                                    end
                                    else begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                end
                            end
                        //end
                        end
                        begin
                        //for(int m=0;m<`BANK_ADDR_WIDTH;m++)begin
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl1);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl2);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl3);
                            if(vmc_csl_addr_q4.size()>0&&(((vmc_csl_addr_q0.size()<3||(vmc_csl_addr_q0.size()>2&&read_data_csl==8'hff))&&(vmc_csl_addr_q1.size()<3||(vmc_csl_addr_q1.size()>2&&read_data_csl1==8'hff))&&(vmc_csl_addr_q2.size()<3||(vmc_csl_addr_q2.size()>2&&read_data_csl2==8'hff))&&(vmc_csl_addr_q3.size()<3||(vmc_csl_addr_q3.size()>2&&read_data_csl3==8'hff)))||scan_mode==1))begin
                                `uvm_info(get_type_name(),$sformatf("compare_csl_result_q4_size=%d",compare_csl_result_q4.size),UVM_LOW);
                                if(enter_num==0) compare_csl_result_q4_pop=compare_csl_result_q4.pop_front();
                                else compare_csl_result_q4_pop=compare_csl_result_q4_tmp.pop_front();
                                compare_csl_result_q4_tmp.push_back(compare_csl_result_q4_pop);
                                `uvm_info(get_type_name(),$sformatf("compare_csl_result=%d",compare_csl_result_q4_pop),UVM_LOW);
                                if(compare_csl_result_q4_pop!=0)begin
                                    if(vmc_csl_addr_q4.size==0)begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part4_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                    else if(vmc_csl_addr_q4.size==1)begin
                                        for(int i=0;i<vmc_csl_addr_q4.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part4_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q4[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q4[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part4_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                        index4_0=1;
                                    end
                                    else begin
                                        for(int i=0;i<vmc_csl_addr_q4.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part4_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q4[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q4[i]))
                                                end
                                            end
                                        end
                                        index4_1=1;
                                    end
                                end
                                else begin
                                    if(index4_0==1)begin
                                        for(int i=0;i<vmc_csl_addr_q4.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part4_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q4[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q4[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part4_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                    end
                                    else if(index4_1==1)begin
                                        for(int i=0;i<vmc_csl_addr_q4.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part4_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q4[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q4[i]))
                                                end
                                            end
                                        end
                                    end
                                    else begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part4_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                end
                            end
                        //end
                        end
                        begin
                        //for(int m=0;m<`BANK_ADDR_WIDTH;m++)begin
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl1);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl2);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl3);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part4_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl4);
                            if(vmc_csl_addr_q5.size()>0&&(((vmc_csl_addr_q0.size()<3||(vmc_csl_addr_q0.size()>2&&8'hff==read_data_csl))&&(vmc_csl_addr_q1.size()<3||(vmc_csl_addr_q1.size()>2&&8'hff==read_data_csl1))&&(vmc_csl_addr_q2.size()<3||(vmc_csl_addr_q2.size()>2&&8'hff==read_data_csl2))&&(vmc_csl_addr_q3.size()<3||(vmc_csl_addr_q3.size()>2&&8'hff==read_data_csl3))&&(vmc_csl_addr_q4.size()<3||(vmc_csl_addr_q4.size()>2&&8'hff==read_data_csl4)))||scan_mode==1))begin
                                if(enter_num==0) compare_csl_result_q5_pop=compare_csl_result_q5.pop_front();
                                else compare_csl_result_q5_pop=compare_csl_result_q5_tmp.pop_front();
                                compare_csl_result_q5_tmp.push_back(compare_csl_result_q5_pop);
                                `uvm_info(get_type_name(),$sformatf("compare_csl_result=%d",compare_csl_result_q5_pop),UVM_LOW);
                                if(compare_csl_result_q5_pop!=0)begin
                                    if(vmc_csl_addr_q5.size==0)begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part5_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                    else if(vmc_csl_addr_q5.size==1)begin
                                        for(int i=0;i<vmc_csl_addr_q5.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part5_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q5[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q5[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part5_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                        index5_0=1;
                                    end
                                    else begin
                                        for(int i=0;i<vmc_csl_addr_q5.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part5_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q5[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q5[i]))
                                                end
                                            end
                                        end
                                        index5_1=1;
                                    end
                                end
                                else begin
                                    if(index5_0==1)begin
                                        for(int i=0;i<vmc_csl_addr_q5.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part5_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q5[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q5[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part5_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                    end
                                    else if(index5_1==1)begin
                                        for(int i=0;i<vmc_csl_addr_q5.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part5_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q5[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q5[i]))
                                                end
                                            end
                                        end
                                    end
                                    else begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part5_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                end
                            end
                        //end
                        end
                        begin
                        //for(int m=0;m<`BANK_ADDR_WIDTH;m++)begin
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl1);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl2);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl3);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part4_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl4);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part5_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl5);
                            if(vmc_csl_addr_q6.size()>0&&(((vmc_csl_addr_q0.size()<3||(vmc_csl_addr_q0.size()>2&&8'hff==read_data_csl))&&(vmc_csl_addr_q1.size()<3||(vmc_csl_addr_q1.size()>2&&8'hff==read_data_csl1))&&(vmc_csl_addr_q2.size()<3||(vmc_csl_addr_q2.size()>2&&8'hff==read_data_csl2))&&(vmc_csl_addr_q3.size()<3||(vmc_csl_addr_q3.size()>2&&8'hff==read_data_csl3))&&(vmc_csl_addr_q4.size()<3||(vmc_csl_addr_q4.size()>2&&read_data_csl4==8'hff))&&(vmc_csl_addr_q5.size()<3||(vmc_csl_addr_q5.size()>2&&read_data_csl5==8'hff)))||scan_mode==1))begin  
                                if(enter_num==0) compare_csl_result_q6_pop=compare_csl_result_q6.pop_front();
                                else compare_csl_result_q6_pop=compare_csl_result_q6_tmp.pop_front();
                                compare_csl_result_q6_tmp.push_back(compare_csl_result_q6_pop);
                                `uvm_info(get_type_name(),$sformatf("compare_csl_result=%d",compare_csl_result_q6_pop),UVM_LOW);
                                if(compare_csl_result_q6_pop!=0)begin
                                    if(vmc_csl_addr_q6.size==0)begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part6_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                    else if(vmc_csl_addr_q6.size==1)begin
                                        for(int i=0;i<vmc_csl_addr_q6.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part6_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q6[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q6[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part6_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                        index6_0=1;
                                    end
                                    else begin
                                        for(int i=0;i<vmc_csl_addr_q6.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part6_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q6[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q6[i]))
                                                end
                                            end
                                        end
                                        index6_1=1;
                                    end
                                end
                                else begin
                                    if(index6_0==1)begin
                                        for(int i=0;i<vmc_csl_addr_q6.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part6_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q6[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q6[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part6_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                    end
                                    else if(index6_1==1)begin
                                        for(int i=0;i<vmc_csl_addr_q6.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part6_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q6[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q6[i]))
                                                end
                                            end
                                        end
                                    end
                                    else begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part6_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                end
                            end
                        //end
                        end
                        begin
                        //for(int m=0;m<`BANK_ADDR_WIDTH;m++)begin
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl1);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl2);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl3);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part4_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl4);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part5_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl5);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part6_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl6);
                            if(vmc_csl_addr_q7.size()>0&&(((vmc_csl_addr_q0.size()<3||(vmc_csl_addr_q0.size()>2&&read_data_csl==8'hff))&&(vmc_csl_addr_q1.size()<3||(vmc_csl_addr_q1.size()>2&&read_data_csl1==8'hff))&&(vmc_csl_addr_q2.size()<3||(vmc_csl_addr_q2.size()>2&&read_data_csl2==8'hff))&&(vmc_csl_addr_q3.size()<3||(vmc_csl_addr_q3.size()>2&&read_data_csl3==8'hff))&&(vmc_csl_addr_q4.size()<3||(vmc_csl_addr_q4.size()>2&&read_data_csl4==8'hff))&&(vmc_csl_addr_q5.size()<3||(vmc_csl_addr_q5.size()>2&&read_data_csl5==8'hff))&&(vmc_csl_addr_q6.size()<3||(vmc_csl_addr_q6.size()>2&&read_data_csl6==8'hff)))||scan_mode==1))begin
                                if(enter_num==0) compare_csl_result_q7_pop=compare_csl_result_q7.pop_front();
                                else compare_csl_result_q7_pop=compare_csl_result_q7_tmp.pop_front();
                                compare_csl_result_q7_tmp.push_back(compare_csl_result_q7_pop);
                                `uvm_info(get_type_name(),$sformatf("compare_csl_result=%d",compare_csl_result_q7_pop),UVM_LOW);
                                if(compare_csl_result_q7_pop!=0)begin
                                    if(vmc_csl_addr_q7.size==0)begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part7_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                    else if(vmc_csl_addr_q7.size==1)begin
                                        for(int i=0;i<vmc_csl_addr_q7.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part7_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q7[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q7[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part7_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                        index7_0=1;
                                    end
                                    else begin
                                        for(int i=0;i<vmc_csl_addr_q7.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part7_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q7[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q7[i]))
                                                end
                                            end
                                        end
                                        index7_1=1;
                                    end
                                end
                                else begin
                                    if(index7_0==1)begin
                                        for(int i=0;i<vmc_csl_addr_q7.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part7_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q7[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q7[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part7_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                    end
                                    else if(index7_1==1)begin
                                        for(int i=0;i<vmc_csl_addr_q7.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part7_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q7[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q7[i]))
                                                end
                                            end
                                        end
                                    end
                                    else begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part7_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                end
                            end
                        //end
                        end
                        begin
                        //for(int m=0;m<`BANK_ADDR_WIDTH;m++)begin
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl1);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl2);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl3);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part4_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl4);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part5_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl5);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part6_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl6);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part7_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl7);
                            if(vmc_csl_addr_q8.size()>0&&(((vmc_csl_addr_q0.size()<3||(vmc_csl_addr_q0.size()>3&&read_data_csl==8'hff))&&(vmc_csl_addr_q1.size()<3||(vmc_csl_addr_q1.size()>2&&read_data_csl1==8'hff))&&(vmc_csl_addr_q2.size()<3||(vmc_csl_addr_q2.size()>2&&read_data_csl2==8'hff))&&(vmc_csl_addr_q3.size()<3||(vmc_csl_addr_q3.size()>2&&read_data_csl3==8'hff))&&(vmc_csl_addr_q4.size()<3||(vmc_csl_addr_q4.size()>2&&read_data_csl4==8'hff))&&(vmc_csl_addr_q5.size()<3||(vmc_csl_addr_q5.size()>2&&read_data_csl5==8'hff))&&(vmc_csl_addr_q6.size()<3||(vmc_csl_addr_q6.size()>2&&read_data_csl6==8'hff))&&(vmc_csl_addr_q7.size()<3||(vmc_csl_addr_q7.size()>2&&read_data_csl7==8'hff)))||scan_mode==1))begin
                                if(enter_num==0) compare_csl_result_q8_pop=compare_csl_result_q8.pop_front();
                                else compare_csl_result_q8_pop=compare_csl_result_q8_tmp.pop_front();
                                compare_csl_result_q8_tmp.push_back(compare_csl_result_q8_pop);
                                `uvm_info(get_type_name(),$sformatf("compare_csl_result=%d",compare_csl_result_q8_pop),UVM_LOW);
                                if(compare_csl_result_q8_pop!=0)begin
                                    if(vmc_csl_addr_q8.size==0)begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part8_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                    else if(vmc_csl_addr_q8.size==1)begin
                                        for(int i=0;i<vmc_csl_addr_q8.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part8_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q8[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q8[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part8_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                        index8_0=1;
                                    end
                                    else begin
                                        for(int i=0;i<vmc_csl_addr_q8.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part8_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q8[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q8[i]))
                                                end
                                            end
                                        end
                                        index8_1=1;
                                    end
                                end
                                else begin
                                    if(index8_0==1)begin
                                        for(int i=0;i<vmc_csl_addr_q8.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part8_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q8[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q8[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part8_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                    end
                                    else if(index8_1==1)begin
                                        for(int i=0;i<vmc_csl_addr_q8.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part8_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q8[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q8[i]))
                                                end
                                            end
                                        end
                                    end
                                    else begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part8_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                end
                            end
                        //end
                        end
                        begin
                        //for(int m=0;m<`BANK_ADDR_WIDTH;m++)begin
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part0_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part1_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl1);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part2_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl2);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part3_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl3);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part4_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl4);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part5_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl5);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part6_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl6);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part7_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl7);
                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl0_part8_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,m),read_data_csl8);
                            if(vmc_csl_addr_q9.size()>0&&(((vmc_csl_addr_q0.size()<3||(vmc_csl_addr_q0.size()>2&&read_data_csl==8'hff))&&(vmc_csl_addr_q1.size()<3||(vmc_csl_addr_q1.size()>2&&read_data_csl1==8'hff))&&(vmc_csl_addr_q2.size()<3||(vmc_csl_addr_q2.size()>2&&read_data_csl2==8'hff))&&(vmc_csl_addr_q3.size()<3||(vmc_csl_addr_q3.size()>2&&read_data_csl3==8'hff))&&(vmc_csl_addr_q4.size()<3||(vmc_csl_addr_q4.size()>2&&read_data_csl4==8'hff))&&(vmc_csl_addr_q5.size()<3||(vmc_csl_addr_q5.size()>2&&read_data_csl5==8'hff))&&(vmc_csl_addr_q6.size()<3||(vmc_csl_addr_q6.size()>2&&read_data_csl6==8'hff))&&(vmc_csl_addr_q7.size()<3||(vmc_csl_addr_q7.size()>2&&read_data_csl7==8'hff))&&(vmc_csl_addr_q8.size()<3||(vmc_csl_addr_q8.size()>2&&read_data_csl8==8'hff)))||scan_mode==1))begin
                                if(enter_num==0) compare_csl_result_q9_pop=compare_csl_result_q9.pop_front();
                                else compare_csl_result_q9_pop=compare_csl_result_q9_tmp.pop_front();
                                compare_csl_result_q9_tmp.push_back(compare_csl_result_q9_pop);
                                `uvm_info(get_type_name(),$sformatf("compare_csl_result=%d",compare_csl_result_q9_pop),UVM_LOW);
                                if(compare_csl_result_q9_pop!=0)begin
                                    if(vmc_csl_addr_q9.size==0)begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part9_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                    else if(vmc_csl_addr_q9.size==1)begin
                                        for(int i=0;i<vmc_csl_addr_q9.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part9_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q9[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q9[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part9_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                        index9_0=1;
                                    end
                                    else begin
                                        for(int i=0;i<vmc_csl_addr_q9.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part9_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q9[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q9[i]))
                                                end
                                            end
                                        end
                                        index9_1=1;
                                    end
                                end
                                else begin
                                    if(index9_0==1)begin
                                        for(int i=0;i<vmc_csl_addr_q9.size();i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part9_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(vmc_csl_addr_q9[i]!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("i=%0d,m=%0d,reg csl cadd is %0d, actual cadd is %0d",i,m,read_data_csl,vmc_csl_addr_q9[i]))
                                            end
                                        end
                                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part9_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,1,m),read_data_csl);
                                        `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                        if(8'hff!=read_data_csl)begin
                                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                        end
                                    end
                                    else if(index9_1==1)begin
                                        for(int i=0;i<vmc_csl_addr_q9.size();i++)begin
                                            if(i<2)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part9_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                                `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                                if(vmc_csl_addr_q9[i]!=read_data_csl)begin
                                                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,vmc_csl_addr_q9[i]))
                                                end
                                            end
                                        end
                                    end
                                    else begin
                                        for(int i=0;i<2;i++)begin
                                            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part9_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_csl);
                                            `uvm_info(get_type_name(),$sformatf("err_csl=%d",read_data_csl),UVM_LOW);
                                            if(8'hff!=read_data_csl)begin
                                                `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        //}}}
                    end
                end
                begin
                    while(1)begin
                        @(posedge m_tb_if.clk)
                        if(m_tb_if.csl_scan_working==0)begin
                            break;
                        end
                    end
                end
            join_any
            disable csl_result_check;
        end
    join
    `uvm_info(get_type_name(),"CSL FINISH",UVM_LOW);

    wl_err_gradd(0,vmc_csl_addr_q0,scan_mode,err_gradd_q0);
    wl_err_gradd(1,vmc_csl_addr_q1,scan_mode,err_gradd_q1);
    wl_err_gradd(2,vmc_csl_addr_q2,scan_mode,err_gradd_q2);
    wl_err_gradd(3,vmc_csl_addr_q3,scan_mode,err_gradd_q3);
    wl_err_gradd(4,vmc_csl_addr_q4,scan_mode,err_gradd_q4);
    wl_err_gradd(5,vmc_csl_addr_q5,scan_mode,err_gradd_q5);
    wl_err_gradd(6,vmc_csl_addr_q6,scan_mode,err_gradd_q6);
    wl_err_gradd(7,vmc_csl_addr_q7,scan_mode,err_gradd_q7);
    wl_err_gradd(8,vmc_csl_addr_q8,scan_mode,err_gradd_q8);
    wl_err_gradd(9,vmc_csl_addr_q9,scan_mode,err_gradd_q9);
    foreach(wl_err_q[i])begin
        `uvm_info(get_type_name(),$sformatf("wl_err_gradd =%d",wl_err_q[i]),UVM_LOW);
    end
    wl_err_model(err_0_1,wl_err_q,err_position_q0,err_position_q1,err_position_q2,err_position_q3,err_position_q4,err_position_q5,err_position_q6,err_position_q7,err_position_q8,err_position_q9,wl_err_q_filtered);
    foreach(wl_err_q_filtered[i])begin
        `uvm_info(get_type_name(),$sformatf("wl_err_gradd_filtered =%d",wl_err_q_filtered[i]),UVM_LOW);
    end
    randomize(soft_err_wl) with{soft_err_wl inside{soft_err_gradd0,soft_err_gradd0,soft_err_gradd0,soft_err_gradd0,soft_err_gradd0,soft_err_gradd0,soft_err_gradd0,soft_err_gradd0,soft_err_gradd0,soft_err_gradd0};};
    randomize(soft_err_wl_col) with {soft_err_wl_col inside {[0:127]};foreach(vmc_csl_addr_q_total[i]) soft_err_wl_col!=vmc_csl_addr_q_total[i];};
    wl_err_q_filtered.push_back(soft_err_wl);
    wl_err_q_filtered_size = wl_err_q_filtered.size(); 
    #10ns;
    if(m==0) uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.bist_finish_bank0_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH),bist_finish_int);
    if(m==1) uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.bist_finish_bank1_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH),bist_finish_int);
    if(m==2) uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.bist_finish_bank2_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH),bist_finish_int);
    if(m==3) uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.bist_finish_bank3_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH),bist_finish_int);
    //uvm_hdl_read("mc_tb.m_mc_subsys_top.bist_finish_intr",bist_finish_int);
    `uvm_info(get_type_name(),$sformatf("check,m =%d",m),UVM_LOW);
    if(bist_finish_int==0||scan_mode==1)begin
        `uvm_info(get_type_name(),$sformatf("check,bist_finish_int=%d,scan_mode=%0d",bist_finish_int,scan_mode),UVM_LOW);
        soft_num=0;
        wait(m_tb_if.wl_scan_working == 1);
        fork
            begin//check wl wr/rd addr after csl vmc
                while(m_tb_if.wl_scan_working == 1)begin
                    @(negedge m_tb_if.clk);
                    for(int II=0;II<wl_pattern_cnt;II++) begin
                        `uvm_info(get_type_name(),$sformatf("gcadd check,n=%0d",II),UVM_LOW);
                        if(m===0)begin
                            `uvm_info(get_type_name(),$sformatf("m=0,gcadd check,n=%0d",II),UVM_LOW);
                            //write
                            for (int j=0;j<BIST_WL_NUM;j++)begin
                                for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                    @(negedge m_tb_if.gcas_wr_array_d0_0);
                                    if(m_tb_if.gradd_array_0 != j)begin
                                        `uvm_error(get_type_name(), $sformatf(" addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    end
                                    vmc_cnt = caculate_vmc_cnt(j,i);
                                    if(m_tb_if.gcadd_array_0 != i+vmc_cnt)begin
                                        `uvm_error(get_type_name(), $sformatf(" i=%0d,vmc_cnt=%0d,addr error, exp cadd is %0h, act is %0h,",i,vmc_cnt,(i+vmc_cnt), m_tb_if.gcadd_array_0))
                                    end
                                    if(m_tb_if.wl_scan_working == 0)begin
                                        break;
                                    end
                                end
                            end
                            //read
                            for (int k=0;k<(wl_scan_cnt+'b1);k++) begin
                                for (int j=0;j<BIST_WL_NUM;j++)begin
                                    for(int i=0;i<(COL_ALL_NUM-2);i++)begin
                                        @(negedge m_tb_if.gcas_rd_array_d0_0);
                                        if(m_tb_if.gradd_array_0 != j)begin
                                            `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                        end
                                        vmc_cnt = caculate_vmc_cnt(j,i);
                                        if(m_tb_if.gcadd_array_0 != i+vmc_cnt)begin
                                            `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_tb_if.gcadd_array_0))
                                        end
                                        if(m_tb_if.wl_scan_working == 0)begin
                                            break;
                                        end
                                    end
                                end
                            end
                        end
                        if(m===1)begin
                            `uvm_info(get_type_name(),$sformatf("m=1,gcadd check,n=%0d",II),UVM_LOW);
                            //write
                            for (int j=0;j<BIST_WL_NUM;j++)begin
                                for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                    @(negedge m_tb_if.gcas_wr_array_d1_0);
                                    if(m_tb_if.gradd_array_0 != j)begin
                                        `uvm_error(get_type_name(), $sformatf(" addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    end
                                    vmc_cnt = caculate_vmc_cnt(j,i);
                                    if(m_tb_if.gcadd_array_0 != i+vmc_cnt)begin
                                        `uvm_error(get_type_name(), $sformatf(" i=%0d,vmc_cnt=%0d,addr error, exp cadd is %0h, act is %0h,",i,vmc_cnt,(i+vmc_cnt), m_tb_if.gcadd_array_0))
                                    end
                                    if(m_tb_if.wl_scan_working == 0)begin
                                        break;
                                    end
                                end
                            end
                            //read
                            for (int k=0;k<(wl_scan_cnt+'b1);k++) begin
                                for (int j=0;j<BIST_WL_NUM;j++)begin
                                    for(int i=0;i<(COL_ALL_NUM-2);i++)begin
                                        @(negedge m_tb_if.gcas_rd_array_d1_0);
                                        if(m_tb_if.gradd_array_0 != j)begin
                                            `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                        end
                                        vmc_cnt = caculate_vmc_cnt(j,i);
                                        if(m_tb_if.gcadd_array_0 != i+vmc_cnt)begin
                                            `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_tb_if.gcadd_array_0))
                                        end
                                        if(m_tb_if.wl_scan_working == 0)begin
                                            break;
                                        end
                                    end
                                end
                            end
                        end
                        if(m===2)begin
                            `uvm_info(get_type_name(),$sformatf("m=2,gcadd check,n=%0d",II),UVM_LOW);
                            //write
                            for (int j=0;j<BIST_WL_NUM;j++)begin
                                for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                    @(negedge m_tb_if.gcas_wr_array_d2_0);
                                    if(m_tb_if.gradd_array_0 != j)begin
                                        `uvm_error(get_type_name(), $sformatf(" addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    end
                                    vmc_cnt = caculate_vmc_cnt(j,i);
                                    if(m_tb_if.gcadd_array_0 != i+vmc_cnt)begin
                                        `uvm_error(get_type_name(), $sformatf(" i=%0d,vmc_cnt=%0d,addr error, exp cadd is %0h, act is %0h,",i,vmc_cnt,(i+vmc_cnt), m_tb_if.gcadd_array_0))
                                    end
                                    if(m_tb_if.wl_scan_working == 0)begin
                                        break;
                                    end
                                end
                            end
                            //read
                            for (int k=0;k<(wl_scan_cnt+'b1);k++) begin
                                for (int j=0;j<BIST_WL_NUM;j++)begin
                                    for(int i=0;i<(COL_ALL_NUM-2);i++)begin
                                        @(negedge m_tb_if.gcas_rd_array_d2_0);
                                        if(m_tb_if.gradd_array_0 != j)begin
                                            `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                        end
                                        vmc_cnt = caculate_vmc_cnt(j,i);
                                        if(m_tb_if.gcadd_array_0 != i+vmc_cnt)begin
                                            `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_tb_if.gcadd_array_0))
                                        end
                                        if(m_tb_if.wl_scan_working == 0)begin
                                            break;
                                        end
                                    end
                                end
                            end
                        end
                        if(m===3)begin
                            `uvm_info(get_type_name(),$sformatf("m=3,gcadd check,n=%0d",II),UVM_LOW);
                            //write
                            for (int j=0;j<BIST_WL_NUM;j++)begin
                                for (int i=0;i<(COL_ALL_NUM-2);i++) begin
                                    @(negedge m_tb_if.gcas_wr_array_d3_0);
                                    if(m_tb_if.gradd_array_0 != j)begin
                                        `uvm_error(get_type_name(), $sformatf(" addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                    end
                                    vmc_cnt = caculate_vmc_cnt(j,i);
                                    if(m_tb_if.gcadd_array_0 != i+vmc_cnt)begin
                                        `uvm_error(get_type_name(), $sformatf(" i=%0d,vmc_cnt=%0d,addr error, exp cadd is %0h, act is %0h,",i,vmc_cnt,(i+vmc_cnt), m_tb_if.gcadd_array_0))
                                    end
                                    if(m_tb_if.wl_scan_working == 0)begin
                                        break;
                                    end
                                end
                            end
                            //read
                            for (int k=0;k<(wl_scan_cnt+'b1);k++) begin
                                for (int j=0;j<BIST_WL_NUM;j++)begin
                                    for(int i=0;i<(COL_ALL_NUM-2);i++)begin
                                        @(negedge m_tb_if.gcas_rd_array_d3_0);
                                        if(m_tb_if.gradd_array_0 != j)begin
                                            `uvm_error(get_type_name(), $sformatf("bist addr error, exp radd is %0h, act is %0h", j, m_tb_if.gradd_array_0))
                                        end
                                        vmc_cnt = caculate_vmc_cnt(j,i);
                                        if(m_tb_if.gcadd_array_0 != i+vmc_cnt)begin
                                            `uvm_error(get_type_name(), $sformatf(" addr error, exp cadd is %0h, act is %0h", (i+vmc_cnt), m_tb_if.gcadd_array_0))
                                        end
                                        if(m_tb_if.wl_scan_working == 0)begin
                                            break;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            begin
                while(m_tb_if.wl_scan_working == 1)begin
                    @(negedge m_tb_if.clk);
                    if(wl_soft_pattern_num==soft_num)begin
                        if(m===0) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d]",{soft_err_wl,soft_err_wl_col}),8'd123);
                        if(m===1) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d]",{soft_err_wl,soft_err_wl_col}),8'd123);
                        if(m===2) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d]",{soft_err_wl,soft_err_wl_col}),8'd123);
                        if(m===3) uvm_hdl_force($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d]",{soft_err_wl,soft_err_wl_col}),8'd123);
                        `uvm_info(get_type_name(),$sformatf("soft wl row0 =%0d, csl0 =%0d",soft_err_wl,soft_err_wl_col),UVM_LOW);
                    end
                    while(m_tb_if.wl_single_pattern_done==0)begin
                        @(posedge m_tb_if.clk);
                    end
                    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d]",{soft_err_wl,soft_err_wl_col}));
                    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d]",{soft_err_wl,soft_err_wl_col}));
                    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d]",{soft_err_wl,soft_err_wl_col}));
                    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d]",{soft_err_wl,soft_err_wl_col}));
                    `uvm_info(get_type_name(),$sformatf("soft wl row0 =%0d, csl0 =%0d",soft_err_wl,soft_err_wl_col),UVM_LOW);
                    soft_num=soft_num+1;
                end
            end
            begin
                while(m_tb_if.wl_scan_working == 1)begin
                    @(posedge m_tb_if.clk);
                end
                if(wl_err_q_filtered_size>64)begin
                    for(int i =0;i<64;i++)begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_wl%0d_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,i,m),read_data_wl);
                        if(read_data_wl!=13'h1fff)begin
                            if(find_element(wl_err_q_filtered,read_data_wl))begin
                            end
                            else begin
                                `uvm_error("wl reg check failed", $sformatf("reg wl is %0d",read_data_wl))
                            end
                        end
                    end
                    //bist_success check
                    uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_bank_success",read_data1);
                    if(read_data1 == 1)begin
                        `uvm_error("bist_csl_wl", "bist scan fail")
                    end
                end
                else begin
                    for(int i =0;i<wl_err_q_filtered_size;i++)begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_wl%0d_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,wl_err_q_filtered_size-i-1,m),read_data_wl);
                        if(read_data_wl!=13'h1fff)begin
                            if(find_element(wl_err_q_filtered,read_data_wl))begin
                            end
                            else begin
                                `uvm_error("wl reg check failed", $sformatf("reg wl is %0d",read_data_wl))
                            end
                        end
                    end
                    if(m==(`BANK_ADDR_WIDTH-1))begin
                        //bist_success check
                        @(posedge m_tb_if.clk);
                        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_bank_success",read_data1);
                        if(scan_mode==0)begin
                            if(read_data1 == 0)begin
                                `uvm_error("bist_csl_wl", "bist scan fail")
                            end
                        end
                        else begin
                            if(bist_finish_int==1)begin
                                if(read_data1 == 1)begin
                                    `uvm_error("bist_csl_wl", "bist scan fail")
                                end
                            end
                            else begin
                                if(read_data1 == 0)begin
                                    `uvm_error("bist_csl_wl", "bist scan fail")
                                end
                            end
                        end
                    end
                end
            end
        join_any
        disable fork;
    end
    #10ns;
    enter_num++;
    `uvm_info(get_type_name(),$sformatf("add,m =%d",m),UVM_LOW);
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d]",{soft_err_wl,soft_err_wl_col}));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d]",{soft_err_wl,soft_err_wl_col}));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d]",{soft_err_wl,soft_err_wl_col}));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d]",{soft_err_wl,soft_err_wl_col}));
    `uvm_info(get_type_name(),$sformatf("soft wl row0 =%0d, csl0 =%0d",soft_err_wl,soft_err_wl_col),UVM_LOW);
end
`uvm_info(get_type_name(),"body===========first bist finish===========",UVM_LOW);
//err release
foreach(vmc_csl_addr_q0[i])begin//part0
    foreach(err_gradd_q0[j])begin
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d]",{err_gradd_q0[j],vmc_csl_addr_q0[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d]",{err_gradd_q0[j],vmc_csl_addr_q0[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d]",{err_gradd_q0[j],vmc_csl_addr_q0[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d]",{err_gradd_q0[j],vmc_csl_addr_q0[i]}));
        `uvm_info(get_type_name(),$sformatf("row0 =%0d, csl0 =%0d",err_gradd_q0[j],vmc_csl_addr_q0[i]),UVM_LOW);
    end
end
foreach(vmc_csl_addr_q1[i])begin//part1
    foreach(err_gradd_q1[j])begin
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d]",{err_gradd_q1[j],vmc_csl_addr_q1[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d]",{err_gradd_q1[j],vmc_csl_addr_q1[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d]",{err_gradd_q1[j],vmc_csl_addr_q1[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d]",{err_gradd_q1[j],vmc_csl_addr_q1[i]}));
        `uvm_info(get_type_name(),$sformatf("row1 =%0d, csl1 =%0d",err_gradd_q1[j],vmc_csl_addr_q1[i]),UVM_LOW);
    end
end
foreach(vmc_csl_addr_q2[i])begin//part2
    foreach(err_gradd_q2[j])begin
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d]",{err_gradd_q2[j],vmc_csl_addr_q2[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d]",{err_gradd_q2[j],vmc_csl_addr_q2[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d]",{err_gradd_q2[j],vmc_csl_addr_q2[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d]",{err_gradd_q2[j],vmc_csl_addr_q2[i]}));
        `uvm_info(get_type_name(),$sformatf("row2 =%0d, csl2 =%0d",err_gradd_q2[j],vmc_csl_addr_q2[i]),UVM_LOW);
    end
end
foreach(vmc_csl_addr_q3[i])begin//part3
    foreach(err_gradd_q3[j])begin
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d]",{err_gradd_q3[j],vmc_csl_addr_q3[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d]",{err_gradd_q3[j],vmc_csl_addr_q3[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d]",{err_gradd_q3[j],vmc_csl_addr_q3[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d]",{err_gradd_q3[j],vmc_csl_addr_q3[i]}));
        `uvm_info(get_type_name(),$sformatf("row3 =%0d, csl3 =%0d",err_gradd_q3[j],vmc_csl_addr_q3[i]),UVM_LOW);
    end
end
foreach(vmc_csl_addr_q4[i])begin//part4
    foreach(err_gradd_q4[j])begin
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d]",{err_gradd_q4[j],vmc_csl_addr_q4[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d]",{err_gradd_q4[j],vmc_csl_addr_q4[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d]",{err_gradd_q4[j],vmc_csl_addr_q4[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d]",{err_gradd_q4[j],vmc_csl_addr_q4[i]}));
        `uvm_info(get_type_name(),$sformatf("row4 =%0d, csl4 =%0d",err_gradd_q4[j],vmc_csl_addr_q4[i]),UVM_LOW);
    end
end
foreach(vmc_csl_addr_q5[i])begin//part5
    foreach(err_gradd_q5[j])begin
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d]",{err_gradd_q5[j],vmc_csl_addr_q5[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d]",{err_gradd_q5[j],vmc_csl_addr_q5[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d]",{err_gradd_q5[j],vmc_csl_addr_q5[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d]",{err_gradd_q5[j],vmc_csl_addr_q5[i]}));
        `uvm_info(get_type_name(),$sformatf("row5 =%0d, csl5 =%0d",err_gradd_q5[j],vmc_csl_addr_q5[i]),UVM_LOW);
    end
end
foreach(vmc_csl_addr_q6[i])begin//part6
    foreach(err_gradd_q6[j])begin
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d]",{err_gradd_q6[j],vmc_csl_addr_q6[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d]",{err_gradd_q6[j],vmc_csl_addr_q6[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d]",{err_gradd_q6[j],vmc_csl_addr_q6[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d]",{err_gradd_q6[j],vmc_csl_addr_q6[i]}));
        `uvm_info(get_type_name(),$sformatf("row6 =%0d, csl6 =%0d",err_gradd_q6[j],vmc_csl_addr_q6[i]),UVM_LOW);
    end
end
foreach(vmc_csl_addr_q7[i])begin//part7
    foreach(err_gradd_q7[j])begin
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d]",{err_gradd_q7[j],vmc_csl_addr_q7[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d]",{err_gradd_q7[j],vmc_csl_addr_q7[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d]",{err_gradd_q7[j],vmc_csl_addr_q7[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d]",{err_gradd_q7[j],vmc_csl_addr_q7[i]}));
        `uvm_info(get_type_name(),$sformatf("row7 =%0d, csl7 =%0d",err_gradd_q7[j],vmc_csl_addr_q7[i]),UVM_LOW);
    end
end
foreach(vmc_csl_addr_q8[i])begin//part8
    foreach(err_gradd_q8[j])begin
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d]",{err_gradd_q8[j],vmc_csl_addr_q8[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d]",{err_gradd_q8[j],vmc_csl_addr_q8[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d]",{err_gradd_q8[j],vmc_csl_addr_q8[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d]",{err_gradd_q8[j],vmc_csl_addr_q8[i]}));
        `uvm_info(get_type_name(),$sformatf("row8 =%0d, csl8 =%0d",err_gradd_q8[j],vmc_csl_addr_q8[i]),UVM_LOW);
    end
end
foreach(vmc_csl_addr_q9[i])begin//part9
    foreach(err_gradd_q9[j])begin
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d]",{err_gradd_q9[j],vmc_csl_addr_q9[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d]",{err_gradd_q9[j],vmc_csl_addr_q9[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d]",{err_gradd_q9[j],vmc_csl_addr_q9[i]}));
        uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d]",{err_gradd_q9[j],vmc_csl_addr_q9[i]}));
        `uvm_info(get_type_name(),$sformatf("row9 =%0d, csl9 =%0d",err_gradd_q9[j],vmc_csl_addr_q9[i]),UVM_LOW);
    end
end
//soft err release
foreach(vmc_csl_addr_q0[i])begin//part0
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd0,vmc_csl_addr_q0[i]},soft_err_position0));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd0,vmc_csl_addr_q0[i]},soft_err_position0));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd0,vmc_csl_addr_q0[i]},soft_err_position0));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd0,vmc_csl_addr_q0[i]},soft_err_position0));
    `uvm_info(get_type_name(),$sformatf("soft row0 =%0d, csl0 =%0d, err_pos =%0d",soft_err_gradd0,vmc_csl_addr_q0[i],soft_err_position0),UVM_LOW);
end
foreach(vmc_csl_addr_q1[i])begin//part1
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd1,vmc_csl_addr_q1[i]},soft_err_position1));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd1,vmc_csl_addr_q1[i]},soft_err_position1));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd1,vmc_csl_addr_q1[i]},soft_err_position1));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd1,vmc_csl_addr_q1[i]},soft_err_position1));
    `uvm_info(get_type_name(),$sformatf("soft row1 =%0d, csl1 =%0d, err_pos =%0d",soft_err_gradd1,vmc_csl_addr_q1[i],soft_err_position1),UVM_LOW);
end
foreach(vmc_csl_addr_q2[i])begin//part2
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd2,vmc_csl_addr_q2[i]},soft_err_position2));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd2,vmc_csl_addr_q2[i]},soft_err_position2));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd2,vmc_csl_addr_q2[i]},soft_err_position2));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd2,vmc_csl_addr_q2[i]},soft_err_position2));
    `uvm_info(get_type_name(),$sformatf("soft row2 =%0d, csl2 =%0d, err_pos =%0d",soft_err_gradd2,vmc_csl_addr_q2[i],soft_err_position2),UVM_LOW);
end
foreach(vmc_csl_addr_q3[i])begin//part3
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd3,vmc_csl_addr_q3[i]},soft_err_position3));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd3,vmc_csl_addr_q3[i]},soft_err_position3));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd3,vmc_csl_addr_q3[i]},soft_err_position3));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd3,vmc_csl_addr_q3[i]},soft_err_position3));
    `uvm_info(get_type_name(),$sformatf("soft row3 =%0d, csl3 =%0d, err_pos =%0d",soft_err_gradd3,vmc_csl_addr_q3[i],soft_err_position3),UVM_LOW);
end
foreach(vmc_csl_addr_q4[i])begin//part4
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd4,vmc_csl_addr_q4[i]},soft_err_position4));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd4,vmc_csl_addr_q4[i]},soft_err_position4));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd4,vmc_csl_addr_q4[i]},soft_err_position4));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd4,vmc_csl_addr_q4[i]},soft_err_position4));
    `uvm_info(get_type_name(),$sformatf("soft row4 =%0d, csl4 =%0d, err_pos =%0d",soft_err_gradd4,vmc_csl_addr_q4[i],soft_err_position4),UVM_LOW);
end
foreach(vmc_csl_addr_q5[i])begin//part5
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd5,vmc_csl_addr_q5[i]},soft_err_position5));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd5,vmc_csl_addr_q5[i]},soft_err_position5));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd5,vmc_csl_addr_q5[i]},soft_err_position5));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd5,vmc_csl_addr_q5[i]},soft_err_position5));
    `uvm_info(get_type_name(),$sformatf("soft row5 =%0d, csl5 =%0d, err_pos =%0d",soft_err_gradd5,vmc_csl_addr_q5[i],soft_err_position5),UVM_LOW);
end
foreach(vmc_csl_addr_q6[i])begin//part6
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd6,vmc_csl_addr_q6[i]},soft_err_position6));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd6,vmc_csl_addr_q6[i]},soft_err_position6));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd6,vmc_csl_addr_q6[i]},soft_err_position6));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd6,vmc_csl_addr_q6[i]},soft_err_position6));
    `uvm_info(get_type_name(),$sformatf("soft row6 =%0d, csl6 =%0d, err_pos =%0d",soft_err_gradd6,vmc_csl_addr_q6[i],soft_err_position6),UVM_LOW);
end
foreach(vmc_csl_addr_q7[i])begin//part7
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd7,vmc_csl_addr_q7[i]},soft_err_position7));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd7,vmc_csl_addr_q7[i]},soft_err_position7));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd7,vmc_csl_addr_q7[i]},soft_err_position7));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd7,vmc_csl_addr_q7[i]},soft_err_position7));
    `uvm_info(get_type_name(),$sformatf("soft row7 =%0d, csl7 =%0d, err_pos =%0d",soft_err_gradd7,vmc_csl_addr_q7[i],soft_err_position7),UVM_LOW);
end
foreach(vmc_csl_addr_q8[i])begin//part8
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd8,vmc_csl_addr_q8[i]},soft_err_position8));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd8,vmc_csl_addr_q8[i]},soft_err_position8));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd8,vmc_csl_addr_q8[i]},soft_err_position8));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd8,vmc_csl_addr_q8[i]},soft_err_position8));
    `uvm_info(get_type_name(),$sformatf("soft row8 =%0d, csl8 =%0d, err_pos =%0d",soft_err_gradd8,vmc_csl_addr_q8[i],soft_err_position8),UVM_LOW);
end
foreach(vmc_csl_addr_q9[i])begin//part9
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK0.memory[%0d][%0d]",{soft_err_gradd9,vmc_csl_addr_q9[i]},soft_err_position9));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK1.memory[%0d][%0d]",{soft_err_gradd9,vmc_csl_addr_q9[i]},soft_err_position9));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK2.memory[%0d][%0d]",{soft_err_gradd9,vmc_csl_addr_q9[i]},soft_err_position9));
    uvm_hdl_release($sformatf("mc_tb.u_quad_group.u_quad_group.XBK3.memory[%0d][%0d]",{soft_err_gradd9,vmc_csl_addr_q9[i]},soft_err_position9));
    `uvm_info(get_type_name(),$sformatf("soft row9 =%0d, csl9 =%0d, err_pos =%0d",soft_err_gradd9,vmc_csl_addr_q9[i],soft_err_position9),UVM_LOW);
end

//second bist_scan
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg0_reg.write(status,bist_pattern64,UVM_FRONTDOOR);
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg1_reg.write(status,bist_pattern65,UVM_FRONTDOOR);
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg2_reg.write(status,bist_pattern66,UVM_FRONTDOOR);
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_pattern_reg3_reg.write(status,bist_pattern67,UVM_FRONTDOOR);
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.csl_bist_pattern_sel0_reg.write(status,scan_num[31:0],UVM_FRONTDOOR);
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.csl_bist_pattern_sel1_reg.write(status,scan_num[63:32],UVM_FRONTDOOR);
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.csl_bist_pattern_sel2_reg.write(status,scan_num[67:64],UVM_FRONTDOOR);
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.wl_bist_pattern_sel0_reg.write(status,wl_scan_num[31:0],UVM_FRONTDOOR);
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.wl_bist_pattern_sel1_reg.write(status,wl_scan_num[63:32],UVM_FRONTDOOR);
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.wl_bist_pattern_sel2_reg.write(status,wl_scan_num[67:64],UVM_FRONTDOOR);
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_mask.write(status,bist_finish_mask,UVM_FRONTDOOR);
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_csl_scan_addr_range_sel.write(status,1'b0, UVM_FRONTDOOR);
//check err csl err wl clr
m_tb_if.global_bist_clr=1;
#30ns;
repeat(5) @(posedge m_tb_if.pclk);
m_tb_if.mc_scan_timeout_en=1;
m_tb_if.csl_err_threshold   =   1;
m_tb_if.global_mc_bist_en   =   1;
m_tb_if.bist_wl_scan_single_pattern_rd_num=wl_scan_cnt;
@(posedge m_tb_if.pclk);
m_tb_if.global_mc_bist_start=   1;
@(posedge m_tb_if.pclk);
m_tb_if.global_mc_bist_start=   0;
#20ns;
//check second bist start clr status reg
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.read(status,read_data1, UVM_FRONTDOOR);
repeat(5) @(posedge m_tb_if.pclk);
if(read_data1[3:0]!=0)begin
    `uvm_error("bist finish check failed", $sformatf("reg is %0d",read_data1))
end
//p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_reg.bank_success.read(status,read_data1, UVM_FRONTDOOR);
//repeat(5) @(posedge m_tb_if.pclk);
if(read_data1[11:8]!=0)begin
    `uvm_error("bist success check failed", $sformatf("reg is %0d",read_data1))
end
//wait bist scan finish
//while(m_tb_if.bist_finish_int_no_mask==0)begin
//    @(posedge m_tb_if.clk);
//end
bist_finish_int = 0;
while(bist_finish_int==0)begin
    uvm_hdl_read("mc_tb.m_mc_subsys_top.bist_finish_intr",bist_finish_int);
    @(posedge m_tb_if.clk);
end
`uvm_info(get_type_name(),$sformatf("bist_finish_int wait finish"),UVM_LOW);
//check bist status 
p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bist_finish_and_success_reg.read(status,read_data1, UVM_FRONTDOOR);
//repeat(5) @(posedge m_tb_if.pclk);
//`ifdef TEST_1_SHOT_1
//    exp_data = 1'b1;
//`elsif TEST_1_SHOT_2
//    exp_data = 2'b11;
//`elsif TEST_1_SHOT_3
//    exp_data = 3'b111;
//`elsif TEST_1_SHOT_4
//    exp_data = 4'b1111;
//`else
//    exp_data = 3'b111;
//`endif
exp_data = mc_bist_grant;
if(read_data1[`BANK_ADDR_WIDTH-1:0]!=exp_data)begin
    `uvm_error("bist status check failed", $sformatf("reg is %0d,exp is %0d",read_data1[`BANK_ADDR_WIDTH-1:0],exp_data))
end
//p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.bank_success_reg.bank_success.read(status,read_data1, UVM_FRONTDOOR);
//repeat(5) @(posedge m_tb_if.pclk);
if(read_data1[`BANK_ADDR_WIDTH*3-1:`BANK_ADDR_WIDTH*2]!=exp_data)begin
    `uvm_error("bist status check failed", $sformatf("reg is %0d,exp is %0d",read_data1[`BANK_ADDR_WIDTH*3-1:`BANK_ADDR_WIDTH*2],exp_data))
end
for(int m=0;m<`BANK_ADDR_WIDTH;m++)begin
    for(int k = 0;k<64;k++)begin
        uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_wl%0d_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,63-k,m),read_data_wl);
        if(read_data_wl != 13'h1fff)begin
            `uvm_error("wl reg check failed", $sformatf("m=%0d,k=%0d,reg wl radd is %0d, actual radd is %0d",m,k,read_data_wl,13'h1fff))
        end
    end
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_bist_err_wl_reg.read(status, read_data, UVM_FRONTDOOR);
    if(m==0) read_data1 = read_data[6:0];
    if(m==1) read_data1 = read_data[13:7];
    if(m==2) read_data1 = read_data[20:14];
    if(m==3) read_data1 = read_data[27:21];
    if(read_data1!=0)begin
        `uvm_error("wl vmc reg check failed", $sformatf("clr bist_err_wl_cnt is %0d",read_data1))
    end
    for(int i=0;i<10;i++)begin
        for(int j=0;j<2;j++)begin
            uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst%0d.apb2reg_mc_top_cfg_if_u%0d.err_csl%0d_part%0d_bank%0d_i",4-`BANK_ADDR_WIDTH,4-`BANK_ADDR_WIDTH,j,i,m),read_data_csl);
            if(read_data_csl != 8'hff)begin
                `uvm_error("csl reg check failed", $sformatf("m=%0d,i=%0d,reg csl radd is %0d, actual radd is %0d",m,i,read_data_csl,8'hff))
            end
        end
    end
end
`uvm_info(get_type_name(),"body===========second bist finish===========",UVM_LOW);
endtask

//////////////////////////////////////////////////////////////////////////////////function and task\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

function bit find_element(bit [`ROW_ADDR_WIDTH-1:0] q[$],bit [32-1:0] element);
    foreach(q[i])begin
        if(q[i]==element)begin
            return 1;
        end
    end
    return 0;
endfunction
task automatic err_position_product(input bit parity_en, output bit [10:0] err_position_q[$], output bit [10:0] soft_err_position);
    if(parity_en==1)begin
            randomize(err_num) with {err_num dist {[1:1]:/99,[2:2]:/9,[3:271]:/1};}; 
            //randomize(err_num) with {err_num dist {[1:1]:/0,[2:9]:/999,[10:265]:/1};}; 
            `uvm_info(get_type_name(),$sformatf("err_num =%d",err_num),UVM_LOW);
            for(int j=0;j<err_num;j++)begin
                randomize(err_position) with {err_position inside {[0:271]};foreach(err_position_q[i]) err_position!=err_position_q[i];}; 
                //`uvm_info(get_type_name(),$sformatf("err_position =%d",err_position),UVM_LOW);
                err_position_q.push_back(err_position);
            end
            randomize(soft_err_rand) with {soft_err_rand inside {[0:271]};foreach(err_position_q[i]) soft_err_rand!=err_position_q[i];};
            soft_err_position=soft_err_rand;
            `uvm_info(get_type_name(),$sformatf("soft_err_position =%d",soft_err_rand),UVM_LOW);
        end
        else begin
            randomize(err_num) with {err_num dist {[1:1]:/99,[2:2]:/9,[3:255]:/1};}; 
            //randomize(err_num) with {err_num dist {[1:1]:/0,[2:9]:/999,[10:255]:/1};}; 
            `uvm_info(get_type_name(),$sformatf("err_num =%d",err_num),UVM_LOW);
            for(int j=0;j<err_num;j++)begin
                randomize(err_position) with {err_position inside {[0:255]};foreach(err_position_q[i]) err_position!=err_position_q[i];}; 
                //`uvm_info(get_type_name(),$sformatf("err_position =%d",err_position),UVM_LOW);
                err_position_q.push_back(err_position);
            end
            randomize(soft_err_rand) with {soft_err_rand inside {[0:255]};foreach(err_position_q[i]) soft_err_rand!=err_position_q[i];};
            soft_err_position=soft_err_rand;
            `uvm_info(get_type_name(),$sformatf("soft_err_position =%d",soft_err_rand),UVM_LOW);
        end
endtask
task automatic err_gradd_product(input bit [3:0] k, output bit [`ROW_ADDR_WIDTH-1:0] err_gradd_q[$], output bit [`ROW_ADDR_WIDTH-1:0] softerr_gradd);
    randomize(err_gradd_num) with {err_gradd_num inside{[0:29]};};
    `uvm_info(get_type_name(),$sformatf("err_gradd_num=%d",err_gradd_num),UVM_LOW);
    if(k==0)begin
        for(int i=0;i<err_gradd_num;i++)begin
            randomize(err_gradd) with {err_gradd inside{[0:29]};foreach(err_gradd_q[i]) err_gradd!=err_gradd_q[i];};
            //`uvm_info(get_type_name(),$sformatf("err_gradd=%d",err_gradd),UVM_LOW);
            err_gradd_q.push_back(err_gradd);
        end
        randomize(soft_err_gradd) with {soft_err_gradd inside{[0:29]};foreach(err_gradd_q[i]) soft_err_gradd!=err_gradd_q[i];};
        softerr_gradd=soft_err_gradd;
        `uvm_info(get_type_name(),$sformatf("soft_err_gradd=%d",soft_err_gradd),UVM_LOW);
    end
    else if(k==1)begin
        for(int i=0;i<err_gradd_num;i++)begin
            randomize(err_gradd) with {err_gradd inside{[30:59]};foreach(err_gradd_q[i]) err_gradd!=err_gradd_q[i];};
            //`uvm_info(get_type_name(),$sformatf("err_gradd=%d",err_gradd),UVM_LOW);
            err_gradd_q.push_back(err_gradd);
        end
        randomize(soft_err_gradd) with {soft_err_gradd inside{[30:59]};foreach(err_gradd_q[i]) soft_err_gradd!=err_gradd_q[i];};
        softerr_gradd=soft_err_gradd;
        `uvm_info(get_type_name(),$sformatf("soft_err_gradd=%d",soft_err_gradd),UVM_LOW);
    end
    else if(k==2)begin
        for(int i=0;i<err_gradd_num;i++)begin
            randomize(err_gradd) with {err_gradd inside{[60:89]};foreach(err_gradd_q[i]) err_gradd!=err_gradd_q[i];};
            //`uvm_info(get_type_name(),$sformatf("err_gradd=%d",err_gradd),UVM_LOW);
            err_gradd_q.push_back(err_gradd);
        end
        randomize(soft_err_gradd) with {soft_err_gradd inside{[60:89]};foreach(err_gradd_q[i]) soft_err_gradd!=err_gradd_q[i];};
        softerr_gradd=soft_err_gradd;
        `uvm_info(get_type_name(),$sformatf("soft_err_gradd=%d",soft_err_gradd),UVM_LOW);
    end
    else if(k==3)begin
        for(int i=0;i<err_gradd_num;i++)begin
            randomize(err_gradd) with {err_gradd inside{[90:119]};foreach(err_gradd_q[i]) err_gradd!=err_gradd_q[i];};
            //`uvm_info(get_type_name(),$sformatf("err_gradd=%d",err_gradd),UVM_LOW);
            err_gradd_q.push_back(err_gradd);
        end
        randomize(soft_err_gradd) with {soft_err_gradd inside{[90:119]};foreach(err_gradd_q[i]) soft_err_gradd!=err_gradd_q[i];};
        softerr_gradd=soft_err_gradd;
        `uvm_info(get_type_name(),$sformatf("soft_err_gradd=%d",soft_err_gradd),UVM_LOW);
    end
    else if(k==4)begin
        for(int i=0;i<err_gradd_num;i++)begin
            randomize(err_gradd) with {err_gradd inside{[120:149]};foreach(err_gradd_q[i]) err_gradd!=err_gradd_q[i];};
            //`uvm_info(get_type_name(),$sformatf("err_gradd=%d",err_gradd),UVM_LOW);
            err_gradd_q.push_back(err_gradd);
        end
        randomize(soft_err_gradd) with {soft_err_gradd inside{[120:149]};foreach(err_gradd_q[i]) soft_err_gradd!=err_gradd_q[i];};
        softerr_gradd=soft_err_gradd;
        `uvm_info(get_type_name(),$sformatf("soft_err_gradd=%d",soft_err_gradd),UVM_LOW);
    end
    else if(k==5)begin
        for(int i=0;i<err_gradd_num;i++)begin
            randomize(err_gradd) with {err_gradd inside{[150:179]};foreach(err_gradd_q[i]) err_gradd!=err_gradd_q[i];};
            //`uvm_info(get_type_name(),$sformatf("err_gradd=%d",err_gradd),UVM_LOW);
            err_gradd_q.push_back(err_gradd);
        end
        randomize(soft_err_gradd) with {soft_err_gradd inside{[150:179]};foreach(err_gradd_q[i]) soft_err_gradd!=err_gradd_q[i];};
        softerr_gradd=soft_err_gradd;
        `uvm_info(get_type_name(),$sformatf("soft_err_gradd=%d",soft_err_gradd),UVM_LOW);
    end
    else if(k==6)begin
        for(int i=0;i<err_gradd_num;i++)begin
            randomize(err_gradd) with {err_gradd inside{[180:209]};foreach(err_gradd_q[i]) err_gradd!=err_gradd_q[i];};
            //`uvm_info(get_type_name(),$sformatf("err_gradd=%d",err_gradd),UVM_LOW);
            err_gradd_q.push_back(err_gradd);
        end
        randomize(soft_err_gradd) with {soft_err_gradd inside{[180:209]};foreach(err_gradd_q[i]) soft_err_gradd!=err_gradd_q[i];};
        softerr_gradd=soft_err_gradd;
        `uvm_info(get_type_name(),$sformatf("soft_err_gradd=%d",soft_err_gradd),UVM_LOW);
    end
    else if(k==7)begin
        for(int i=0;i<err_gradd_num;i++)begin
            randomize(err_gradd) with {err_gradd inside{[210:239]};foreach(err_gradd_q[i]) err_gradd!=err_gradd_q[i];};
            //`uvm_info(get_type_name(),$sformatf("err_gradd=%d",err_gradd),UVM_LOW);
            err_gradd_q.push_back(err_gradd);
        end
        randomize(soft_err_gradd) with {soft_err_gradd inside{[210:239]};foreach(err_gradd_q[i]) soft_err_gradd!=err_gradd_q[i];};
        softerr_gradd=soft_err_gradd;
        `uvm_info(get_type_name(),$sformatf("soft_err_gradd=%d",soft_err_gradd),UVM_LOW);
    end
    else if(k==8)begin
        for(int i=0;i<err_gradd_num;i++)begin
            randomize(err_gradd) with {err_gradd inside{[240:269]};foreach(err_gradd_q[i]) err_gradd!=err_gradd_q[i];};
            //`uvm_info(get_type_name(),$sformatf("err_gradd=%d",err_gradd),UVM_LOW);
            err_gradd_q.push_back(err_gradd);
        end
        randomize(soft_err_gradd) with {soft_err_gradd inside{[240:269]};foreach(err_gradd_q[i]) soft_err_gradd!=err_gradd_q[i];};
        softerr_gradd=soft_err_gradd;
        `uvm_info(get_type_name(),$sformatf("soft_err_gradd=%d",soft_err_gradd),UVM_LOW);
    end
    else if(k==9)begin
        for(int i=0;i<err_gradd_num;i++)begin
            randomize(err_gradd) with {err_gradd inside{[270:299]};foreach(err_gradd_q[i]) err_gradd!=err_gradd_q[i];};
            //`uvm_info(get_type_name(),$sformatf("err_gradd=%d",err_gradd),UVM_LOW);
            err_gradd_q.push_back(err_gradd);
        end
        randomize(soft_err_gradd) with {soft_err_gradd inside{[270:299]};foreach(err_gradd_q[i]) soft_err_gradd!=err_gradd_q[i];};
        softerr_gradd=soft_err_gradd;
        `uvm_info(get_type_name(),$sformatf("soft_err_gradd=%d",soft_err_gradd),UVM_LOW);
    end
endtask
task automatic err_csl_product(output bit [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q[$],output bit [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_total[$]);
    randomize(vmc_csl_cnt) with {vmc_csl_cnt dist {0:/20,1:/30,2:/30,3:/20};};
    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
    for(int k=0;k<vmc_csl_cnt;k++)begin
        randomize(vmc_csl_addr) with {vmc_csl_addr dist {[0:0]:/1,[1:127]:/1,[128:129]:/1};foreach(vmc_csl_addr_q[i]) vmc_csl_addr!=vmc_csl_addr_q[i];};
        //`uvm_info(get_type_name(),$sformatf("vmc_csl_addr_part =%0d",vmc_csl_addr),UVM_LOW);
        vmc_csl_addr_q.push_back(vmc_csl_addr);
        vmc_csl_addr_total.push_back(vmc_csl_addr);
    end
    foreach(vmc_csl_addr_q[i])begin
        automatic bit [`COL_ADDR_WIDTH:0] temp[$] = vmc_csl_addr_q;
        temp.sort();
        vmc_csl_addr_q = temp;
        //`uvm_info(get_type_name(),$sformatf("vmc_csl_addr_part0 =%0d",vmc_csl_addr_q[i]),UVM_LOW);
    end
endtask
task automatic err_model_product(input bit [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q[$],input bit [`ROW_ADDR_WIDTH-1:0] err_gradd_q[$],input bit [`ROW_ADDR_WIDTH-1:0]soft_err_gradd,input bit [10:0] err_position_q[$],input bit [10:0] soft_err_position, output bit compare_csl_result_q[$], output [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q_select[$], output [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q_size[$]);
    for(int i=0;i<$size(bist_pattern_select);i++)begin
        //$display(bist_pattern_select[i]);
        foreach(err_gradd_q[j])begin
            compare_data = bist_pattern_select[i][err_gradd_q[j]%4];
            foreach(err_position_q[k])begin
                //`uvm_info(get_type_name(),$sformatf("err_gradd=%d,data=%d",err_gradd_q[j],compare_data[err_position_q[k]]),UVM_LOW);
                if(compare_data[err_position_q[k]] == err_0_1)begin
                    index=1;
                end
                else begin
                    index=0;
                    break;
                end
            end
            if(index==0)begin
                filtered_err_gradd_q.push_back(err_gradd_q[j]);
            end
        end
        if(i==soft_pattern_num)begin
            compare_data = bist_pattern_select[i][soft_err_gradd%4];
            //`uvm_info(get_type_name(),$sformatf("soft_pattern=%d,err_gradd=%d,data=%d",i,soft_err_gradd,compare_data[soft_err_position]),UVM_LOW);
            if(compare_data[soft_err_position]!=err_0_1)begin
                foreach(filtered_err_gradd_q[i])begin
                    if(soft_err_gradd==filtered_err_gradd_q[i])begin
                        index1=1;
                        break;
                    end
                    else begin
                        index1=0;
                    end
                end
                if(index1==0)begin
                    filtered_err_gradd_q.push_back(soft_err_gradd);
                end
            end
        end
        if(filtered_err_gradd_q.size()>csl_err_th||filtered_err_gradd_q.size()==csl_err_th)begin
            compare_csl_result_q.push_back(1);
            `uvm_info(get_type_name(),$sformatf("filtered_err_gradd_q_size=%d",filtered_err_gradd_q.size()),UVM_LOW);
            filtered_err_gradd_q_size.push_back(filtered_err_gradd_q.size());
            if(scan_mode==0&&vmc_csl_addr_q.size==3)begin
                filtered_err_gradd_q_select=filtered_err_gradd_q;
            end
            filtered_err_gradd_q.delete();
        end
        else begin
            compare_csl_result_q.push_back(0);
            filtered_err_gradd_q_size.push_back(filtered_err_gradd_q.size());
            `uvm_info(get_type_name(),$sformatf("filtered_err_gradd_q_size=%d",filtered_err_gradd_q.size()),UVM_LOW);
            filtered_err_gradd_q.delete();
        end
    end
    index=0;
    index1=0;
endtask
task wl_err_gradd(input bit [3:0] k, input [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q[$], input bit scanmode, input bit [`ROW_ADDR_WIDTH-1:0] err_gradd_q[$]);
    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.bist_scan_top_u.bist_scan_u.U_bist_csl_vmc.err_csl0_part%0d",k),read_data_csl);
    if(read_data_csl!=8'hff)begin
        if(vmc_csl_addr_q.size()>2)begin
            foreach(err_gradd_q[i])begin
                wl_err_q.push_back(err_gradd_q[i]);
                `uvm_info(get_type_name(),$sformatf("err_gradd=%d",err_gradd_q[i]),UVM_LOW);
            end
        end
    end
    else begin
        if(vmc_csl_addr_q.size()>0&&vmc_csl_addr_q[0]<128)begin
            foreach(err_gradd_q[i])begin
                wl_err_q.push_back(err_gradd_q[i]);
                `uvm_info(get_type_name(),$sformatf("err_gradd=%d",err_gradd_q[i]),UVM_LOW);
            end
        end
    end
endtask
task wl_err_model(input bit err_inject, input  bit [`ROW_ADDR_WIDTH-1:0] wl_err_q[$], input bit [10:0] err_position_0[$],input bit [10:0] err_position_1[$],input bit [10:0] err_position_2[$],input bit [10:0] err_position_3[$],input bit [10:0] err_position_4[$], input bit [10:0] err_position_5[$], input bit [10:0] err_position_6[$], input bit [10:0] err_position_7[$], input bit [10:0] err_position_8[$], input bit [10:0] err_position_9[$], output bit [`ROW_ADDR_WIDTH-1:0] wl_err_q_out[$]);
    bit index_wl=0;
    foreach(wl_err_q[i])begin
        if(wl_err_q[i]<30)begin
            foreach(err_position_0[j])begin
                for(int k=0;k<$size(wl_bist_pattern_select);k++)begin
                    if(wl_bist_pattern_select[k][wl_err_q[i]%4][err_position_0[j]]==err_inject)begin
                    end
                    else begin
                        index_wl=1;
                    end
                end
            end
            if(index_wl==1)begin
                wl_err_q_out.push_back(wl_err_q[i]);
                index_wl=0;
            end
        end
        else if(29<wl_err_q[i]&&wl_err_q[i]<60)begin
            foreach(err_position_1[j])begin
                for(int k=0;k<$size(wl_bist_pattern_select);k++)begin
                    if(wl_bist_pattern_select[k][wl_err_q[i]%4][err_position_1[j]]==err_inject)begin
                    end
                    else begin
                        index_wl=1;
                    end
                end
            end
            if(index_wl==1)begin
                wl_err_q_out.push_back(wl_err_q[i]);
                index_wl=0;
            end
        end
        else if(59<wl_err_q[i]&&wl_err_q[i]<90)begin
            foreach(err_position_2[j])begin
                for(int k=0;k<$size(wl_bist_pattern_select);k++)begin
                    if(wl_bist_pattern_select[k][wl_err_q[i]%4][err_position_2[j]]==err_inject)begin
                    end
                    else begin
                        index_wl=1;
                    end
                end
            end
            if(index_wl==1)begin
                wl_err_q_out.push_back(wl_err_q[i]);
                index_wl=0;
            end
        end
        else if(89<wl_err_q[i]&&wl_err_q[i]<120)begin
            foreach(err_position_3[j])begin
                for(int k=0;k<$size(wl_bist_pattern_select);k++)begin
                    if(wl_bist_pattern_select[k][wl_err_q[i]%4][err_position_3[j]]==err_inject)begin
                    end
                    else begin
                        index_wl=1;
                    end
                end
            end
            if(index_wl==1)begin
                wl_err_q_out.push_back(wl_err_q[i]);
                index_wl=0;
            end
        end
        else if(119<wl_err_q[i]&&wl_err_q[i]<150)begin
            foreach(err_position_4[j])begin
                for(int k=0;k<$size(wl_bist_pattern_select);k++)begin
                    if(wl_bist_pattern_select[k][wl_err_q[i]%4][err_position_4[j]]==err_inject)begin
                    end
                    else begin
                        index_wl=1;
                    end
                end
            end
            if(index_wl==1)begin
                wl_err_q_out.push_back(wl_err_q[i]);
                index_wl=0;
            end
        end
        else if(149<wl_err_q[i]&&wl_err_q[i]<180)begin
            foreach(err_position_5[j])begin
                for(int k=0;k<$size(wl_bist_pattern_select);k++)begin
                    if(wl_bist_pattern_select[k][wl_err_q[i]%4][err_position_5[j]]==err_inject)begin
                    end
                    else begin
                        index_wl=1;
                    end
                end
            end
            if(index_wl==1)begin
                wl_err_q_out.push_back(wl_err_q[i]);
                index_wl=0;
            end
        end
        else if(179<wl_err_q[i]&&wl_err_q[i]<210)begin
            foreach(err_position_6[j])begin
                for(int k=0;k<$size(wl_bist_pattern_select);k++)begin
                    if(wl_bist_pattern_select[k][wl_err_q[i]%4][err_position_6[j]]==err_inject)begin
                    end
                    else begin
                        index_wl=1;
                    end
                end
            end
            if(index_wl==1)begin
                wl_err_q_out.push_back(wl_err_q[i]);
                index_wl=0;
            end
        end
        else if(209<wl_err_q[i]&&wl_err_q[i]<240)begin
            foreach(err_position_7[j])begin
                for(int k=0;k<$size(wl_bist_pattern_select);k++)begin
                    if(wl_bist_pattern_select[k][wl_err_q[i]%4][err_position_7[j]]==err_inject)begin
                    end
                    else begin
                        index_wl=1;
                    end
                end
            end
            if(index_wl==1)begin
                wl_err_q_out.push_back(wl_err_q[i]);
                index_wl=0;
            end
        end
        else if(239<wl_err_q[i]&&wl_err_q[i]<270)begin
            foreach(err_position_8[j])begin
                for(int k=0;k<$size(wl_bist_pattern_select);k++)begin
                    if(wl_bist_pattern_select[k][wl_err_q[i]%4][err_position_8[j]]==err_inject)begin
                    end
                    else begin
                        index_wl=1;
                    end
                end
            end
            if(index_wl==1)begin
                wl_err_q_out.push_back(wl_err_q[i]);
                index_wl=0;
            end
        end
        else if(269<wl_err_q[i]&&wl_err_q[i]<300)begin
            foreach(err_position_9[j])begin
                for(int k=0;k<$size(wl_bist_pattern_select);k++)begin
                    if(wl_bist_pattern_select[k][wl_err_q[i]%4][err_position_9[j]]==err_inject)begin
                    end
                    else begin
                        index_wl=1;
                    end
                end
            end
            if(index_wl==1)begin
                wl_err_q_out.push_back(wl_err_q[i]);
                index_wl=0;
            end
        end
    end
endtask
task csl_stop_wl_csl(input [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q[$], input [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q[$], input [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q1[$], input [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q1[$],input [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q2[$], input [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q2[$],input [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q3[$], input [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q3[$],input [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q4[$], input [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q4[$],input [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q5[$], input [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q5[$],input [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q6[$], input [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q6[$],input [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q7[$], input [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q7[$],input [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q8[$], input [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q8[$],input [`ROW_ADDR_WIDTH-1:0] filtered_err_gradd_q9[$], input [`COLUMN_ADDR_WIDTH-1:0] vmc_csl_addr_q9[$], output bit [4:0] csl_part_num);
    for(int i=0;i<pattern_cnt;i++)begin
        `uvm_info(get_type_name(),$sformatf("csl_part_0num=%d",vmc_csl_addr_q.size()),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("csl_part_1num=%d",vmc_csl_addr_q1.size()),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("csl_part_2num=%d",vmc_csl_addr_q2.size()),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("csl_part_3num=%d",vmc_csl_addr_q3.size()),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("csl_part_4num=%d",vmc_csl_addr_q4.size()),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("csl_part_5num=%d",vmc_csl_addr_q5.size()),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("csl_part_6num=%d",vmc_csl_addr_q6.size()),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("csl_part_7num=%d",vmc_csl_addr_q7.size()),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("csl_part_8num=%d",vmc_csl_addr_q8.size()),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("csl_part_9num=%d",vmc_csl_addr_q9.size()),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("wl_size_0num=%d",filtered_err_gradd_q[i]),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("wl_size_1num=%d",filtered_err_gradd_q1[i]),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("wl_size_2num=%d",filtered_err_gradd_q2[i]),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("wl_size_3num=%d",filtered_err_gradd_q3[i]),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("wl_size_4num=%d",filtered_err_gradd_q4[i]),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("wl_size_5num=%d",filtered_err_gradd_q5[i]),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("wl_size_6num=%d",filtered_err_gradd_q6[i]),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("wl_size_7num=%d",filtered_err_gradd_q7[i]),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("wl_size_8num=%d",filtered_err_gradd_q8[i]),UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("wl_size_9num=%d",filtered_err_gradd_q9[i]),UVM_LOW);
        if(filtered_err_gradd_q[i]>=csl_err_th&&vmc_csl_addr_q.size()==3)begin
            csl_part_num=0;
            `uvm_info(get_type_name(),$sformatf("csl_part_num=%d",csl_part_num),UVM_LOW);
            break;
        end
        else if(filtered_err_gradd_q1[i]>=csl_err_th&&vmc_csl_addr_q1.size()==3)begin
            csl_part_num=1;
            `uvm_info(get_type_name(),$sformatf("csl_part_num=%d",csl_part_num),UVM_LOW);
            break;
        end
        else if(filtered_err_gradd_q2[i]>=csl_err_th&&vmc_csl_addr_q2.size()==3)begin
            csl_part_num=2;
            `uvm_info(get_type_name(),$sformatf("csl_part_num=%d",csl_part_num),UVM_LOW);
            break;
        end
        else if(filtered_err_gradd_q3[i]>=csl_err_th&&vmc_csl_addr_q3.size()==3)begin
            csl_part_num=3;
            `uvm_info(get_type_name(),$sformatf("csl_part_num=%d",csl_part_num),UVM_LOW);
            break;
        end
        else if(filtered_err_gradd_q4[i]>=csl_err_th&&vmc_csl_addr_q4.size()==3)begin
            csl_part_num=4;
            `uvm_info(get_type_name(),$sformatf("csl_part_num=%d",csl_part_num),UVM_LOW);
            break;
        end
        else if(filtered_err_gradd_q5[i]>=csl_err_th&&vmc_csl_addr_q5.size()==3)begin
            csl_part_num=5;
            `uvm_info(get_type_name(),$sformatf("csl_part_num=%d",csl_part_num),UVM_LOW);
            break;
        end
        else if(filtered_err_gradd_q6[i]>=csl_err_th&&vmc_csl_addr_q6.size()==3)begin
            csl_part_num=6;
            `uvm_info(get_type_name(),$sformatf("csl_part_num=%d",csl_part_num),UVM_LOW);
            break;
        end
        else if(filtered_err_gradd_q7[i]>=csl_err_th&&vmc_csl_addr_q7.size()==3)begin
            csl_part_num=7;
            `uvm_info(get_type_name(),$sformatf("csl_part_num=%d",csl_part_num),UVM_LOW);
            break;
        end
        else if(filtered_err_gradd_q8[i]>=csl_err_th&&vmc_csl_addr_q8.size()==3)begin
            csl_part_num=8;
            `uvm_info(get_type_name(),$sformatf("csl_part_num=%d",csl_part_num),UVM_LOW);
            break;
        end
        else if(filtered_err_gradd_q9[i]>=csl_err_th&&vmc_csl_addr_q9.size()==3)begin
            csl_part_num=9;
            `uvm_info(get_type_name(),$sformatf("csl_part_num=%d",csl_part_num),UVM_LOW);
            break;
        end
        else begin
            csl_part_num=10;
            `uvm_info(get_type_name(),$sformatf("csl_part_num=%d",csl_part_num),UVM_LOW);
        end
        `uvm_info(get_type_name(),$sformatf("csl_part_num=%d",csl_part_num),UVM_LOW);
    end
endtask
function bit [3:0] caculate_row_part(input bit [`ROW_ADDR_WIDTH-1:0] row_in);

    int part_tmp;
    int row_num_per_part;

    row_num_per_part = BIST_WL_NUM / PART_NUM;

    part_tmp = row_in/row_num_per_part;

    if (part_tmp >= PART_NUM) begin
        `uvm_error(get_type_name(), $sformatf("err row input %0h", row_in))
    end

    caculate_row_part = part_tmp;

endfunction:caculate_row_part
function int caculate_vmc_cnt(input bit [`ROW_ADDR_WIDTH-1:0] row_in, input bit [`COLUMN_ADDR_WIDTH-1:0] cadd_in);

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
endclass


`endif

