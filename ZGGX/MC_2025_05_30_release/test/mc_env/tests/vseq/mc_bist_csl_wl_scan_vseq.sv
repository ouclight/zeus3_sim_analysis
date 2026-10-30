//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_bist_csl_wl_scan_vseq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 29 14:33:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_BIST_CSL_WL_SCAN_VSEQ
`define MC_BIST_CSL_WL_SCAN_VSEQ

class mc_bist_csl_wl_scan_vseq extends mc_common_vseq;
    rand bit    [7:0]                   vmc_wl_cnt;
    rand bit    [1:0]                   vmc_csl_cnt;
    rand bit    [1:0]                   vmc_csl_cnt_part1;
    rand bit    [1:0]                   vmc_csl_cnt_part2;
    rand bit    [1:0]                   vmc_csl_cnt_part3;
    rand bit    [1:0]                   vmc_csl_cnt_part4;
    randc bit   [`ROW_ADDR_WIDTH-1:0]   vmc_wl_addr;
    bit         [`ROW_ADDR_WIDTH-1:0]   vmc_wl_addr_q[$];
    bit         [`ROW_ADDR_WIDTH-1:0]   vmc_wl_addr_q_copy[$];
    bit         [`ROW_ADDR_WIDTH-1:0]   vmc_wl_addr_q_copy1[$];
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr;
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_part1[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_part2[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_part3[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_part4[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part1[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part2[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part3[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part4[$];
    bit         [8:0]                       wl_total_size = 0;
    bit         [12:0]                  wl_err;

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
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_total[$];

    bit     [`COLUMN_ADDR_WIDTH-1:0]                       vmc_gcadd=127;
    rand bit    [`ROW_ADDR_WIDTH-1:0]                   csl_error_num;
    rand bit [`PATTERN_WIDTH-1:0]   bist_pattern[64];
    rand bit    [3:0]               wl_scan_cnt;
    bit    [3:0]               wl_time=1;
    rand bit    [4:0]               csl_err_th;
    bit    [4:0]               index=0;
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
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part0_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part1_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part2_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part3_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               col_part4_check_i=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part0=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part1=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part2=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part3=0;
    bit     [`COLUMN_ADDR_WIDTH-1:0]               cnt_part4=0;
    bit     [3:0]               start_num=0;
    bit                         first_enter=0;
    `uvm_object_utils(mc_bist_csl_wl_scan_vseq)
    bit [31:0] csl_q_size=0;
    bit [31:0] csl_q_size_part1=0;
    bit [31:0] csl_q_size_part2=0;
    bit [31:0] csl_q_size_part3=0;
    bit [31:0] csl_q_size_part4=0;
    bit [31:0] wl_q_size=0;
    bit [31:0] read_data=0;
    bit [31:0] read_data1=0;
    bit [31:0] read_data2=0;
    bit [31:0] read_data_csl=0;
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
    localparam                                              BIST_WL_NUM=150;

    function new(string name="mc_bist_csl_wl_scan_vseq");
        super.new(name);
    endfunction

virtual task body();
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    super.body();
    repeat(2)begin

    m_tb_if.bist_test_en = 1;
    m_tb_if.mc_scan_timeout_en=1;
    randomize(bist_pattern,wl_scan_cnt,csl_err_th,close_page_en,csl_pattern_num,wl_pattern_num);
    randomize(vmc_wl_cnt) with {vmc_wl_cnt dist {[0:63]:/90,[64:127]:/10};}; 
    //product csl error position
    randomize(parity_en) with {parity_en dist {1:/80,0:/20};};
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_csl_scan_check_sel.write(status,parity_en, UVM_FRONTDOOR);
    repeat(20) @(posedge m_tb_if.clk);
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_csl_scan_check_sel.read(status,read_parity, UVM_FRONTDOOR);
    if(read_parity==1)begin
        randomize(csl_err_position_num) with {csl_err_position_num inside {[1:266]};};
        for(int i=0;i<csl_err_position_num;i++)begin
            randomize(csl_err_position) with {csl_err_position inside {[0:265]};};
            parity_seed_q.push_back(csl_err_position);
        end
    end
    else begin
        randomize(csl_err_position_num) with {csl_err_position_num inside {[1:256]};};
        for(int i=0;i<csl_err_position_num;i++)begin
            randomize(csl_err_position) with {csl_err_position inside {[0:255]};};
            parity_seed_q.push_back(csl_err_position);
        end
    end
    //
    `uvm_info(get_type_name(),$sformatf("vmc_wl_cnt =%0d, vmc_csl_cnt=%0d,wl_scan_cnt=%0d,csl_err_th=%0d,csl_pattern_num=%0d,wl_pattern_num=%0d",vmc_wl_cnt,vmc_csl_cnt,wl_scan_cnt,csl_err_th,csl_pattern_num,wl_pattern_num),UVM_LOW);
    if(close_page_en == 1)begin
        while(mc_page_status==1)begin
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
        end
        m_tb_if.page_mode_switch = 1'b1;
        m_tb_if.pre_precharge = 0;
    end
    randomize(vmc_csl_cnt) with {vmc_csl_cnt dist {[0:2]:/90,3:/10};};//part0 
    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
    for(int k=0;k<vmc_csl_cnt;k++)begin
        randomize(vmc_csl_addr) with {vmc_csl_addr inside {[0:129]};};
        `uvm_info(get_type_name(),$sformatf("vmc_csl_addr_part0 =%0h",vmc_csl_addr),UVM_LOW);
        vmc_csl_addr_q.push_back(vmc_csl_addr);
    end
    foreach(vmc_csl_addr_q[i])begin
        automatic bit [`COL_ADDR_WIDTH:0] temp[$] = vmc_csl_addr_q;
        temp.sort();
        vmc_csl_addr_q = temp;
        `uvm_info(get_type_name(),$sformatf("vmc_csl_addr_part0 =%0h",vmc_csl_addr_q[i]),UVM_LOW);
    end

    randomize(vmc_csl_cnt_part1) with {vmc_csl_cnt_part1 dist {[0:2]:/90,[3:3]:/10};};//part1 
    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt_part1=%0d",vmc_csl_cnt_part1),UVM_LOW);
    for(int k=0;k<vmc_csl_cnt_part1;k++)begin
        randomize(vmc_csl_addr) with {vmc_csl_addr inside {[0:129]};};
        `uvm_info(get_type_name(),$sformatf("vmc_csl_addr_part1 =%0h",vmc_csl_addr),UVM_LOW);
        vmc_csl_addr_q_part1.push_back(vmc_csl_addr);
    end
    foreach(vmc_csl_addr_q_part1[i])begin
        automatic bit [`COL_ADDR_WIDTH:0] temp[$] = vmc_csl_addr_q_part1;
        temp.sort();
        vmc_csl_addr_q_part1 = temp;
        `uvm_info(get_type_name(),$sformatf("vmc_csl_addr_part1 =%0h",vmc_csl_addr_q_part1[i]),UVM_LOW);
    end

    randomize(vmc_csl_cnt_part2) with {vmc_csl_cnt_part2 dist {[0:2]:/90,[3:3]:/10};};//part2 
    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt_part2=%0d",vmc_csl_cnt_part2),UVM_LOW);
    for(int k=0;k<vmc_csl_cnt_part2;k++)begin
        randomize(vmc_csl_addr) with {vmc_csl_addr inside {[0:129]};};
        `uvm_info(get_type_name(),$sformatf("vmc_csl_addr_part2 =%0h",vmc_csl_addr),UVM_LOW);
        vmc_csl_addr_q_part2.push_back(vmc_csl_addr);
    end
    foreach(vmc_csl_addr_q_part2[i])begin
        automatic bit [`COL_ADDR_WIDTH:0] temp[$] = vmc_csl_addr_q_part2;
        temp.sort();
        vmc_csl_addr_q_part2 = temp;
        `uvm_info(get_type_name(),$sformatf("vmc_csl_addr_part2 =%0h",vmc_csl_addr_q_part2[i]),UVM_LOW);
    end

    randomize(vmc_csl_cnt_part3) with {vmc_csl_cnt_part3 dist {[0:2]:/90,[3:3]:/10};};//part3 
    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt_part3=%0d",vmc_csl_cnt_part3),UVM_LOW);
    for(int k=0;k<vmc_csl_cnt_part3;k++)begin
        randomize(vmc_csl_addr) with {vmc_csl_addr inside {[0:129]};};
        `uvm_info(get_type_name(),$sformatf("vmc_csl_addr_part3 =%0h",vmc_csl_addr),UVM_LOW);
        vmc_csl_addr_q_part3.push_back(vmc_csl_addr);
    end
    foreach(vmc_csl_addr_q_part3[i])begin
        automatic bit [`COL_ADDR_WIDTH:0] temp[$] = vmc_csl_addr_q_part3;
        temp.sort();
        vmc_csl_addr_q_part3 = temp;
        `uvm_info(get_type_name(),$sformatf("vmc_csl_addr_part3 =%0h",vmc_csl_addr_q_part3[i]),UVM_LOW);
    end

    randomize(vmc_csl_cnt_part4) with {vmc_csl_cnt_part4 dist {[0:2]:/90,[3:3]:/10};};//part4 
    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt_part4=%0d",vmc_csl_cnt_part4),UVM_LOW);
    for(int k=0;k<vmc_csl_cnt_part4;k++)begin
        randomize(vmc_csl_addr) with {vmc_csl_addr inside {[0:129]};};
        `uvm_info(get_type_name(),$sformatf("vmc_csl_addr_part4 =%0h",vmc_csl_addr),UVM_LOW);
        vmc_csl_addr_q_part4.push_back(vmc_csl_addr);
    end
    foreach(vmc_csl_addr_q_part4[i])begin
        automatic bit [`COL_ADDR_WIDTH:0] temp[$] = vmc_csl_addr_q_part4;
        temp.sort();
        vmc_csl_addr_q_part4 = temp;
        `uvm_info(get_type_name(),$sformatf("vmc_csl_addr_q_part4 =%0h",vmc_csl_addr_q_part4[i]),UVM_LOW);
    end
    vmc_csl_addr_q_copy = vmc_csl_addr_q;
    vmc_csl_addr_q_copy_part1 = vmc_csl_addr_q_part1;
    vmc_csl_addr_q_copy_part2 = vmc_csl_addr_q_part2;
    vmc_csl_addr_q_copy_part3 = vmc_csl_addr_q_part3;
    vmc_csl_addr_q_copy_part4 = vmc_csl_addr_q_part4;

    //csl scan error row product
    randomize(csl_error_num);
    `uvm_info(get_type_name(),$sformatf("csl_error_cnt0 =%0d",csl_error_num),UVM_LOW);
    for(int kk=0;kk<csl_error_num;kk++)begin
        randomize(gradd_num) with {gradd_num inside {[0:(BIST_WL_NUM/5-1)]};}; 
        gradd_num_q_part0.push_back(gradd_num);
        if(vmc_csl_addr_q.size()!=0)begin
            gradd_num_q_total.push_back(gradd_num);
        end
        `uvm_info(get_type_name(),$sformatf("gradd_num =%0d",gradd_num),UVM_LOW);
    end
    gradd_num_q = gradd_num_q_part0;
    
    randomize(csl_error_num);
    `uvm_info(get_type_name(),$sformatf("csl_error_cnt1 =%0d",csl_error_num),UVM_LOW);
    for(int kk=0;kk<csl_error_num;kk++)begin
        randomize(gradd_num1) with {gradd_num1 inside {[(BIST_WL_NUM/5):(BIST_WL_NUM*2/5-1)]};}; 
        gradd_num_q_part1.push_back(gradd_num1);
        if(vmc_csl_addr_q_part1.size()!=0)begin
            gradd_num_q_total.push_back(gradd_num1);
        end
        `uvm_info(get_type_name(),$sformatf("gradd_num1 =%0d",gradd_num1),UVM_LOW);
    end
    
    randomize(csl_error_num);
    `uvm_info(get_type_name(),$sformatf("csl_error_cnt2 =%0d",csl_error_num),UVM_LOW);
    for(int kk=0;kk<csl_error_num;kk++)begin
        randomize(gradd_num2) with {gradd_num2 inside {[(BIST_WL_NUM*2/5):(BIST_WL_NUM*3/5-1)]};}; 
        gradd_num_q_part2.push_back(gradd_num2);
        if(vmc_csl_addr_q_part2.size()!=0)begin
            gradd_num_q_total.push_back(gradd_num2);
        end
        `uvm_info(get_type_name(),$sformatf("gradd_num2 =%0d",gradd_num2),UVM_LOW);
    end
    
    randomize(csl_error_num);
    `uvm_info(get_type_name(),$sformatf("csl_error_cnt3 =%0d",csl_error_num),UVM_LOW);
    for(int kk=0;kk<csl_error_num;kk++)begin
        randomize(gradd_num3) with {gradd_num3 inside {[(BIST_WL_NUM*3/5):(BIST_WL_NUM*4/5-1)]};}; 
        gradd_num_q_part3.push_back(gradd_num3);
        if(vmc_csl_addr_q_part3.size()!=0)begin
            gradd_num_q_total.push_back(gradd_num3);
        end
        `uvm_info(get_type_name(),$sformatf("gradd_num3 =%0d",gradd_num3),UVM_LOW);
    end
    
    randomize(csl_error_num);
    `uvm_info(get_type_name(),$sformatf("csl_error_cnt4 =%0d",csl_error_num),UVM_LOW);
    for(int kk=0;kk<csl_error_num;kk++)begin
        randomize(gradd_num4) with {gradd_num4 inside {[(BIST_WL_NUM*4/5):(BIST_WL_NUM*5/5-1)]};}; 
        gradd_num_q_part4.push_back(gradd_num4);
        if(vmc_csl_addr_q_part4.size()!=0)begin
            gradd_num_q_total.push_back(gradd_num4);
        end
        `uvm_info(get_type_name(),$sformatf("gradd_num4 =%0d",gradd_num4),UVM_LOW);
    end


    randomize(gcadd_num) with {
            foreach(vmc_csl_addr_q[i]) gcadd_num!=vmc_csl_addr_q[i];
            foreach(vmc_csl_addr_q_part1[i]) gcadd_num!=vmc_csl_addr_q_part1[i];
            foreach(vmc_csl_addr_q_part2[i]) gcadd_num!=vmc_csl_addr_q_part2[i];
            foreach(vmc_csl_addr_q_part3[i]) gcadd_num!=vmc_csl_addr_q_part3[i];
            foreach(vmc_csl_addr_q_part4[i]) gcadd_num!=vmc_csl_addr_q_part4[i];
        };

    `uvm_info(get_type_name(),$sformatf("vmc_wl_cnt =%0d",vmc_wl_cnt),UVM_LOW);
    for(int k=0;k<vmc_wl_cnt;k++)begin
        //randomize(vmc_wl_addr) with {vmc_wl_addr inside {[0:7359]};};         
        randomize(vmc_wl_addr) with {vmc_wl_addr inside {[0:127]};};         
        `uvm_info(get_type_name(),$sformatf("vmc_wl_addr =%0h",vmc_wl_addr),UVM_LOW);
        vmc_wl_addr_q.push_back(vmc_wl_addr);
        wl_cnt = wl_cnt + 1;
    end
    vmc_wl_addr_q_copy = vmc_wl_addr_q;
    foreach(vmc_wl_addr_q_copy[i])begin
        automatic bit [`ROW_ADDR_WIDTH-1:0] temp[$] = vmc_wl_addr_q_copy;
        temp.sort();
        vmc_wl_addr_q_copy = temp;
        `uvm_info(get_type_name(),$sformatf("vmc_wl_addr =%0d",vmc_wl_addr_q_copy[i]),UVM_LOW);
    end
    uvm_hdl_deposit("mc_tb.u_quad_group.XBK0.memory[0]",0);
    //uvm_hdl_deposit("mc_tb.u_quad_group.bank0.ram_memory[0]",0);
    //err inject
    if(num==0)begin
        if(parity_en==1)begin
            foreach(vmc_csl_addr_q[i])begin
                foreach(gradd_num_q_part0[j])begin
                    `uvm_info(get_type_name(),$sformatf("row0 =%0d, csl0 =%0d",gradd_num_q_part0[j],vmc_csl_addr_q[i]),UVM_LOW);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part0[j],vmc_csl_addr_q[i]}),{8'd123,256'd0});
                end
            end
            foreach(vmc_csl_addr_q_part1[i])begin
                foreach(gradd_num_q_part1[j])begin
                    `uvm_info(get_type_name(),$sformatf("row1 =%0d, csl1 =%0d",gradd_num_q_part1[j],vmc_csl_addr_q_part1[i]),UVM_LOW);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part1[j],vmc_csl_addr_q_part1[i]}),{8'd123,256'd0});
                end
            end    
            foreach(vmc_csl_addr_q_part2[i])begin
                foreach(gradd_num_q_part2[j])begin
                    `uvm_info(get_type_name(),$sformatf("row2 =%0d, csl2 =%0d",gradd_num_q_part2[j],vmc_csl_addr_q_part2[i]),UVM_LOW);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part2[j],vmc_csl_addr_q_part2[i]}),{8'd123,256'd0});
                end
            end
            foreach(vmc_csl_addr_q_part3[i])begin
                foreach(gradd_num_q_part3[j])begin
                    `uvm_info(get_type_name(),$sformatf("row3 =%0d, csl3 =%0d",gradd_num_q_part3[j],vmc_csl_addr_q_part3[i]),UVM_LOW);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part3[j],vmc_csl_addr_q_part3[i]}),{8'd123,256'd0});
                end
            end
            foreach(vmc_csl_addr_q_part4[i])begin
                foreach(gradd_num_q_part4[j])begin
                    `uvm_info(get_type_name(),$sformatf("row4 =%0d, csl4 =%0d",gradd_num_q_part4[j],vmc_csl_addr_q_part4[i]),UVM_LOW);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part4[j],vmc_csl_addr_q_part4[i]}),{8'd123,256'd0});
                end
            end
        end
        else begin
            foreach(vmc_csl_addr_q[i])begin
                foreach(gradd_num_q_part0[j])begin
                    `uvm_info(get_type_name(),$sformatf("row0 =%0d, csl0 =%0d",gradd_num_q_part0[j],vmc_csl_addr_q[i]),UVM_LOW);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part0[j],vmc_csl_addr_q[i]}),8'd123);
                end
            end
            foreach(vmc_csl_addr_q_part1[i])begin
                foreach(gradd_num_q_part1[j])begin
                    `uvm_info(get_type_name(),$sformatf("row1 =%0d, csl1 =%0d",gradd_num_q_part1[j],vmc_csl_addr_q_part1[i]),UVM_LOW);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part1[j],vmc_csl_addr_q_part1[i]}),8'd123);
                end
            end    
            foreach(vmc_csl_addr_q_part2[i])begin
                foreach(gradd_num_q_part2[j])begin
                    `uvm_info(get_type_name(),$sformatf("row2 =%0d, csl2 =%0d",gradd_num_q_part2[j],vmc_csl_addr_q_part2[i]),UVM_LOW);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part2[j],vmc_csl_addr_q_part2[i]}),8'd123);
                end
            end
            foreach(vmc_csl_addr_q_part3[i])begin
                foreach(gradd_num_q_part3[j])begin
                    `uvm_info(get_type_name(),$sformatf("row3 =%0d, csl3 =%0d",gradd_num_q_part3[j],vmc_csl_addr_q_part3[i]),UVM_LOW);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part3[j],vmc_csl_addr_q_part3[i]}),8'd123);
                end
            end
            foreach(vmc_csl_addr_q_part4[i])begin
                foreach(gradd_num_q_part4[j])begin
                    `uvm_info(get_type_name(),$sformatf("row4 =%0d, csl4 =%0d",gradd_num_q_part4[j],vmc_csl_addr_q_part4[i]),UVM_LOW);
                    uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part4[j],vmc_csl_addr_q_part4[i]}),8'd123);
                end
            end
        end
    end
    //err inject end
    foreach (bist_pattern[j]) begin
        m_tb_if.bist_pattern[j] = bist_pattern[j];
        $display("bist_pattern%0d is %0h", j, m_tb_if.bist_pattern[j]);
    end
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_mask.write(status,bist_finish_mask,UVM_FRONTDOOR);

    m_tb_if.bist_csl_scan_num   =   csl_pattern_num;
    m_tb_if.bist_wl_scan_num    =   wl_pattern_num;
    //m_tb_if.bist_csl_scan_num   =   1;
    //m_tb_if.bist_wl_scan_num    =   1;
    m_tb_if.csl_err_threshold   =   csl_err_th;
    m_tb_if.global_mc_bist_en   =   1;
    m_tb_if.bist_wl_scan_single_pattern_rd_num=wl_scan_cnt;
    @(posedge m_tb_if.pclk);
    m_tb_if.global_mc_bist_start=   1;
    @(posedge m_tb_if.pclk);
    m_tb_if.global_mc_bist_start=   0;
    if(num==1)begin
        @(posedge m_tb_if.pclk);
        m_tb_if.mc_bist_csl_vmc_en=0;
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_csl_scan_addr_range_sel.write(status,1'b1, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_reg.read(status, read_data1, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bank_success_reg.read(status, read_data2, UVM_FRONTDOOR);
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_err_wl_reg.err_wl_num_change_flag.read(status, read_data, UVM_FRONTDOOR);
        repeat(20) @(posedge m_tb_if.clk);
        if({read_data,read_data1,read_data2}!=0)begin
            `uvm_error("bist_csl_wl", "bist scan status check fail")
        end
    end
    if(num==0)begin
        wait(m_tb_if.csl_scan_working == 1);
        repeat(1) @(posedge m_tb_if.clk);
        wait(m_tb_if.csl_scan_working == 0);
    end
    `uvm_info(get_type_name(),"success wait csl_scan_working posedge",UVM_LOW);
    `uvm_info(get_type_name(),$sformatf("gradd=%0d,gradd_down=%0d,gcadd =%0d,",gradd_num,gradd_num_down,gcadd_num),UVM_LOW);
    /*if(num==0)begin
        fork
            while(m_tb_if.csl_scan_working == 1)begin
                @(negedge m_array_agent_if.clk);
                if(m_tb_if.csl_part0_done)begin
                    gradd_num_q.delete();
                    gradd_num_q = gradd_num_q_part1;
                    vmc_csl_addr_q.delete();
                    vmc_csl_addr_q = vmc_csl_addr_q_part1;
                    `uvm_info(get_type_name(),"debug111",UVM_LOW);
                end
                if(m_tb_if.csl_part1_done)begin
                    gradd_num_q.delete();
                    gradd_num_q = gradd_num_q_part2;
                    vmc_csl_addr_q.delete();
                    vmc_csl_addr_q = vmc_csl_addr_q_part2;
                    `uvm_info(get_type_name(),"debug222",UVM_LOW);
                end
                if(m_tb_if.csl_part2_done)begin
                    gradd_num_q.delete();
                    gradd_num_q = gradd_num_q_part3;
                    vmc_csl_addr_q.delete();
                    vmc_csl_addr_q = vmc_csl_addr_q_part3;
                    `uvm_info(get_type_name(),"debug333",UVM_LOW);
                end
                if(m_tb_if.csl_part3_done)begin
                    gradd_num_q.delete();
                    gradd_num_q = gradd_num_q_part4;
                    vmc_csl_addr_q.delete();
                    vmc_csl_addr_q = vmc_csl_addr_q_part4;
                    `uvm_info(get_type_name(),"debug444",UVM_LOW);
                    break;
                end
            end
            while(m_tb_if.csl_scan_working == 1)begin
                @(negedge m_array_agent_if.clk);
                if(m_array_agent_if.gcas_rd == 1)begin
                    gcas_rd_cnt++;
                    //if(m_tb_if.gradd_n<BIST_WL_NUM/5)begin//part0
                    foreach(vmc_csl_addr_q[i])begin 
                        if(m_array_agent_if.gcadd == vmc_csl_addr_q[i])begin
                            foreach(gradd_num_q[i])begin
                                if(m_array_agent_if.gradd_n == gradd_num_q[i])begin
                                    gcas_rd_cnt_q.push_back(gcas_rd_cnt);
                                    `uvm_info(get_type_name(),$sformatf("inject_err_gcadd=%0d,inject_err_gradd=%0d",m_array_agent_if.gcadd,gradd_num_q[i]),UVM_LOW);
                                end
                            end
                            //`uvm_info(get_type_name(),$sformatf("inject_err_gcadd=%0d",m_array_agent_if.gcadd),UVM_LOW);
                        end
                    end
                end

                if(m_tb_if.bist_finish_int==1)break;
            end
            while(m_tb_if.csl_scan_working == 1)begin   
                @(negedge m_array_agent_if.clk);
                if(m_array_agent_if.rdrdy_n == 0)begin
                    rdrdy_n_cnt++;
                    if(gcas_rd_cnt_q.size != 0 && gcas_rd_cnt_q[0] == rdrdy_n_cnt)begin
                        gcas_rd_cnt_q.pop_front();
                        `uvm_info(get_type_name(),$sformatf("gcas_rd_cnt_q.size =%0d",gcas_rd_cnt_q.size),UVM_LOW);                    
                        csl_err_addr_hit = 1;
                    end
                    if(csl_err_addr_hit == 1)begin
                        act_rdl = m_array_agent_if.rdl;
                        for(int i=0;i<csl_err_position_num;i++)begin
                            parity_seed = parity_seed_q.pop_front();
                            err_rdl = act_rdl^(1<<parity_seed);
                        end
                        //err_rdl = ~act_rdl;
                        `uvm_info(get_type_name(),$sformatf("inject_err_rdl_csl=%0h",err_rdl),UVM_LOW);
                        uvm_hdl_force("mc_tb.m_mc_wrapper_aux.rdl",err_rdl);
                    end
                end
                else if(m_array_agent_if.rdrdy_n == 1 && csl_err_addr_hit==1)begin
                    uvm_hdl_release("mc_tb.m_mc_wrapper_aux.rdl");
                    csl_err_addr_hit = 0;
                end
                if(bist_finish_mask==1)begin
                    if(m_tb_if.bist_finish_int==1)begin
                        `uvm_error("bist_csl_wl", "bist finish mask fail")
                        break;
                    end
                    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.bist_finish_i",bist_finish_status_reg);
                    if(bist_finish_status_reg==1)begin
                        break;
                    end
                end
                if(bist_finish_mask==0)begin
                    if(m_tb_if.bist_finish_int==1)begin
                        break;
                    end
                end
            end
        join
    end*/
    //if((vmc_csl_cnt<3&&vmc_csl_cnt_part1<3&&vmc_csl_cnt_part2<3&&vmc_csl_cnt_part3<3&&vmc_csl_cnt_part4<3)||num==1||(vmc_csl_cnt==3&&(gradd_num_q_part0.size()<csl_err_th)||(vmc_csl_cnt_part1==3&&gradd_num_q_part1.size()<csl_err_th)||(vmc_csl_cnt_part2==3&&gradd_num_q_part2.size()<csl_err_th)||(vmc_csl_cnt_part3==3&&gradd_num_q_part3.size()<csl_err_th)||(vmc_csl_cnt_part4==3&&gradd_num_q_part4.size()<csl_err_th)))begin
    if(!((vmc_csl_cnt==3&&gradd_num_q_part0.size()>=csl_err_th)||(vmc_csl_cnt_part1==3&&gradd_num_q_part1.size()>=csl_err_th)||(vmc_csl_cnt_part2==3&&gradd_num_q_part2.size()>=csl_err_th)||(vmc_csl_cnt_part3==3&&gradd_num_q_part3.size()>=csl_err_th)||(vmc_csl_cnt_part4==3&&gradd_num_q_part4.size()>=csl_err_th)))begin
        wait(m_tb_if.wl_scan_working == 1);
        `uvm_info(get_type_name(),"success wait wl_scan_working posedge",UVM_LOW);
    end
    if(num==1)begin
        if(bist_finish_mask==0)begin
            wait(m_tb_if.bist_finish_int==1); 
        end
        read_data=0;
        while(read_data==0)begin
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_reg.read(status, read_data, UVM_FRONTDOOR);
        end
        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_bank_success",read_data1);
        if(read_data1 == 0)begin
            `uvm_error("bist_csl_wl", "bist scan fail")
        end
    end
    if(num==0)begin
        fork
            while(m_tb_if.wl_scan_working == 1)begin//wr
                @(negedge m_array_agent_if.clk);
                if(m_array_agent_if.gcas_wr == 1 && m_tb_if.gradd_n<BIST_WL_NUM/5)begin//part0
                    foreach(mc_vmc_bl_num_part0_q[j])begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_bist_csl_vmc.err_csl%0d_part0",j),mc_vmc_bl_num_part0_q[j]); 
                        //`uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part0_q[%0d] = %0h",j,mc_vmc_bl_num_part0_q[j]), UVM_LOW);
                    end 
                    for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                        if(col_part0_check >= mc_vmc_bl_num_part0_q[bl_cnt]) begin
                            col_part0_check_i++;
                        end
                    end
                    if(col_part0_check_i==mc_vmc_bl_num_part0_q[1])begin
                        col_part0_check_i++;
                    end


                    if(m_tb_if.gcadd!=col_part0_check_i)begin
                        `uvm_error("csl vmc failed", $sformatf("exp cadd is %0d, actual cadd is %0d",col_part0_check,m_tb_if.gcadd))
                    end
                    if(cnt_part0==127)begin
                        col_part0_check=0;
                        col_part0_check_i=0;
                        cnt_part0=0;
                    end
                    else begin
                        col_part0_check=col_part0_check+1;
                        col_part0_check_i=col_part0_check;
                        cnt_part0=cnt_part0+1;
                        `uvm_info(get_type_name(),$sformatf("cnt=%0h",cnt_part0),UVM_LOW);
                    end
                end
                else if(m_array_agent_if.gcas_wr == 1 && (BIST_WL_NUM/5-1)<m_tb_if.gradd_n&&m_tb_if.gradd_n<BIST_WL_NUM*2/5)begin//part1
                    foreach(mc_vmc_bl_num_part1_q[j])begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_bist_csl_vmc.err_csl%0d_part1",j),mc_vmc_bl_num_part1_q[j]); 
                        //`uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part1_q[%0d] = %0h",j,mc_vmc_bl_num_part1_q[j]), UVM_LOW);
                    end 
                    for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                        if(col_part1_check >= mc_vmc_bl_num_part1_q[bl_cnt]) begin
                            col_part1_check_i++;
                        end
                    end
                    if(col_part1_check_i==mc_vmc_bl_num_part1_q[1])begin
                        col_part1_check_i++;
                    end


                    if(m_tb_if.gcadd!=col_part1_check_i)begin
                        `uvm_error("csl vmc failed", $sformatf("exp cadd is %0d, actual cadd is %0d",col_part1_check,m_tb_if.gcadd))
                    end
                    if(cnt_part1==127)begin
                        col_part1_check=0;
                        col_part1_check_i=0;
                        cnt_part1=0;
                    end
                    else begin
                        col_part1_check=col_part1_check+1;
                        col_part1_check_i=col_part1_check;
                        cnt_part1=cnt_part1+1;
                        `uvm_info(get_type_name(),$sformatf("cnt=%0h",cnt_part1),UVM_LOW);
                    end
                end
                else if(m_array_agent_if.gcas_wr == 1 && (BIST_WL_NUM*2/5-1)<m_tb_if.gradd_n&&m_tb_if.gradd_n<BIST_WL_NUM*3/5)begin//part2
                    foreach(mc_vmc_bl_num_part2_q[j])begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_bist_csl_vmc.err_csl%0d_part2",j),mc_vmc_bl_num_part2_q[j]); 
                        //`uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part2_q[%0d] = %0h",j,mc_vmc_bl_num_part2_q[j]), UVM_LOW);
                    end 
                    for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                        if(col_part2_check >= mc_vmc_bl_num_part2_q[bl_cnt]) begin
                            col_part2_check_i++;
                        end
                    end
                    if(col_part2_check_i==mc_vmc_bl_num_part2_q[1])begin
                        col_part2_check_i++;
                    end


                    if(m_tb_if.gcadd!=col_part2_check_i)begin
                        `uvm_error("csl vmc failed", $sformatf("exp cadd is %0d, actual cadd is %0d",col_part2_check,m_tb_if.gcadd))
                    end
                    if(cnt_part2==127)begin
                        col_part2_check=0;
                        col_part2_check_i=0;
                        cnt_part2=0;
                    end
                    else begin
                        col_part2_check=col_part2_check+1;
                        col_part2_check_i=col_part2_check;
                        cnt_part2=cnt_part2+1;
                        `uvm_info(get_type_name(),$sformatf("cnt=%0h",cnt_part2),UVM_LOW);
                    end
                end
                else if(m_array_agent_if.gcas_wr == 1 && (BIST_WL_NUM*3/5-1)<m_tb_if.gradd_n&&m_tb_if.gradd_n<BIST_WL_NUM*4/5)begin//part3
                    foreach(mc_vmc_bl_num_part3_q[j])begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_bist_csl_vmc.err_csl%0d_part3",j),mc_vmc_bl_num_part3_q[j]); 
                        //`uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part3_q[%0d] = %0h",j,mc_vmc_bl_num_part3_q[j]), UVM_LOW);
                    end 
                    for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                        if(col_part3_check >= mc_vmc_bl_num_part3_q[bl_cnt]) begin
                            col_part3_check_i++;
                        end
                    end
                    if(col_part3_check_i==mc_vmc_bl_num_part3_q[1])begin
                        col_part3_check_i++;
                    end


                    if(m_tb_if.gcadd!=col_part3_check_i)begin
                        `uvm_error("csl vmc failed", $sformatf("exp cadd is %0d, actual cadd is %0d",col_part3_check,m_tb_if.gcadd))
                    end
                    if(cnt_part3==127)begin
                        col_part3_check=0;
                        col_part3_check_i=0;
                        cnt_part3=0;
                    end
                    else begin
                        col_part3_check=col_part3_check+1;
                        col_part3_check_i=col_part3_check;
                        cnt_part3=cnt_part3+1;
                        `uvm_info(get_type_name(),$sformatf("cnt=%0h",cnt_part3),UVM_LOW);
                    end
                end
                else if(m_array_agent_if.gcas_wr == 1 && (BIST_WL_NUM*4/5-1)<m_tb_if.gradd_n)begin//part4
                    foreach(mc_vmc_bl_num_part4_q[j])begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_bist_csl_vmc.err_csl%0d_part4",j),mc_vmc_bl_num_part4_q[j]); 
                        //`uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part4_q[%0d] = %0h",j,mc_vmc_bl_num_part4_q[j]), UVM_LOW);
                    end 
                    for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                        if(col_part4_check >= mc_vmc_bl_num_part4_q[bl_cnt]) begin
                            col_part4_check_i++;
                        end
                    end
                    if(col_part4_check_i==mc_vmc_bl_num_part4_q[1])begin
                        col_part4_check_i++;
                    end


                    if(m_tb_if.gcadd!=col_part4_check_i)begin
                        `uvm_error("csl vmc failed", $sformatf("exp cadd is %0d, actual cadd is %0d",col_part4_check,m_tb_if.gcadd))
                    end
                    if(cnt_part4==127)begin
                        col_part4_check=0;
                        col_part4_check_i=0;
                        cnt_part4=0;
                    end
                    else begin
                        col_part4_check=col_part4_check+1;
                        col_part4_check_i=col_part4_check;
                        cnt_part4=cnt_part4+1;
                        `uvm_info(get_type_name(),$sformatf("cnt=%0h",cnt_part4),UVM_LOW);
                    end
                end
            end
            while(m_tb_if.wl_scan_working == 1)begin//rd
                @(negedge m_array_agent_if.clk);
                if(m_array_agent_if.gcas_rd == 1 && m_tb_if.gradd_n<BIST_WL_NUM/5)begin//part0
                    if(first_enter==0)begin
                        col_part0_check=0;
                        col_part0_check_i=0;
                        col_part1_check=0;
                        col_part1_check_i=0;
                        col_part2_check=0;
                        col_part2_check_i=0;
                        col_part3_check=0;
                        col_part3_check_i=0;
                        col_part4_check=0;
                        col_part4_check_i=0;
                        cnt_part0=0;
                        cnt_part1=0;
                        cnt_part2=0;
                        cnt_part3=0;
                        cnt_part4=0;
                    end
                    first_enter=1;
                    foreach(mc_vmc_bl_num_part0_q[j])begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_bist_csl_vmc.err_csl%0d_part0",j),mc_vmc_bl_num_part0_q[j]); 
                        //`uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part0_q[%0d] = %0h",j,mc_vmc_bl_num_part0_q[j]), UVM_LOW);
                    end 
                    for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                        if(col_part0_check >= mc_vmc_bl_num_part0_q[bl_cnt]) begin
                            col_part0_check_i++;
                        end
                    end
                    if(col_part0_check_i==mc_vmc_bl_num_part0_q[1])begin
                        col_part0_check_i++;
                    end
                    if(m_tb_if.gcadd!=col_part0_check_i)begin
                        `uvm_error("csl vmc failed", $sformatf("exp cadd is %0d, actual cadd is %0d",col_part0_check_i,m_tb_if.gcadd))
                    end
                    if(cnt_part0==127)begin
                        col_part0_check=0;
                        col_part0_check_i=0;
                        cnt_part0=0;
                        `uvm_info(get_type_name(),"enter clr",UVM_LOW);
                    end
                    else begin
                        col_part0_check=col_part0_check+1;
                        col_part0_check_i=col_part0_check;
                        cnt_part0=cnt_part0+1;
                        `uvm_info(get_type_name(),$sformatf("cnt_up=%0h",cnt_part0),UVM_LOW);
                    end
                end
                else if(m_array_agent_if.gcas_rd == 1 && (BIST_WL_NUM/5-1)<m_tb_if.gradd_n&&m_tb_if.gradd_n<BIST_WL_NUM*2/5)begin//part1
                    foreach(mc_vmc_bl_num_part1_q[j])begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_bist_csl_vmc.err_csl%0d_part1",j),mc_vmc_bl_num_part1_q[j]); 
                        //`uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part1_q[%0d] = %0h",j,mc_vmc_bl_num_part1_q[j]), UVM_LOW);
                    end 
                    for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                        if(col_part1_check >= mc_vmc_bl_num_part1_q[bl_cnt])begin 
                            col_part1_check_i++;
                        end
                    end              
                    if(col_part1_check_i==mc_vmc_bl_num_part1_q[1])begin
                        col_part1_check_i++;
                    end
                    if(m_tb_if.gcadd!=col_part1_check_i)begin
                        `uvm_error("csl vmc failed", $sformatf("exp cadd is %0d, actual cadd is %0d",col_part1_check,m_tb_if.gcadd))
                    end

                    if(cnt_part1==127)begin
                        col_part1_check=0;
                        col_part1_check_i=0;
                        cnt_part1=0;
                    end
                    else begin
                        col_part1_check=col_part1_check+1;
                        col_part1_check_i=col_part1_check;
                        cnt_part1=cnt_part1+1;
                    end
                end
                else if(m_array_agent_if.gcas_rd == 1 && (BIST_WL_NUM*2/5-1)<m_tb_if.gradd_n&&m_tb_if.gradd_n<BIST_WL_NUM*3/5)begin//part2
                    foreach(mc_vmc_bl_num_part2_q[j])begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_bist_csl_vmc.err_csl%0d_part2",j),mc_vmc_bl_num_part2_q[j]); 
                        //`uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part2_q[%0d] = %0h",j,mc_vmc_bl_num_part2_q[j]), UVM_LOW);
                    end 
                    for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                        if(col_part2_check >= mc_vmc_bl_num_part2_q[bl_cnt])begin 
                            col_part2_check_i++;
                        end
                    end              
                    if(col_part2_check_i==mc_vmc_bl_num_part2_q[1])begin
                        col_part2_check_i++;
                    end
                    if(m_tb_if.gcadd!=col_part2_check_i)begin
                        `uvm_error("csl vmc failed", $sformatf("exp cadd is %0d, actual cadd is %0d",col_part2_check,m_tb_if.gcadd))
                    end

                    if(cnt_part2==127)begin
                        col_part2_check=0;
                        col_part2_check_i=0;
                        cnt_part2=0;
                    end
                    else begin
                        col_part2_check=col_part2_check+1;
                        col_part2_check_i=col_part2_check;
                        cnt_part2=cnt_part2+1;
                    end
                end
                else if(m_array_agent_if.gcas_rd == 1 && (BIST_WL_NUM*3/5-1)<m_tb_if.gradd_n&&m_tb_if.gradd_n<BIST_WL_NUM*4/5)begin//part3
                    foreach(mc_vmc_bl_num_part3_q[j])begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_bist_csl_vmc.err_csl%0d_part3",j),mc_vmc_bl_num_part3_q[j]); 
                        //`uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part3_q[%0d] = %0h",j,mc_vmc_bl_num_part3_q[j]), UVM_LOW);
                    end 
                    for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                        if(col_part3_check >= mc_vmc_bl_num_part3_q[bl_cnt])begin 
                            col_part3_check_i++;
                        end
                    end              
                    if(col_part3_check_i==mc_vmc_bl_num_part3_q[1])begin
                        col_part3_check_i++;
                    end
                    if(m_tb_if.gcadd!=col_part3_check_i)begin
                        `uvm_error("csl vmc failed", $sformatf("exp cadd is %0d, actual cadd is %0d",col_part3_check,m_tb_if.gcadd))
                    end

                    if(cnt_part3==127)begin
                        col_part3_check=0;
                        col_part3_check_i=0;
                        cnt_part3=0;
                    end
                    else begin
                        col_part3_check=col_part3_check+1;
                        col_part3_check_i=col_part3_check;
                        cnt_part3=cnt_part3+1;
                    end
                end
                else if(m_array_agent_if.gcas_rd == 1 && (BIST_WL_NUM*4/5-1)<m_tb_if.gradd_n)begin//part4
                    foreach(mc_vmc_bl_num_part4_q[j])begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.bist_scan_u.U_bist_csl_vmc.err_csl%0d_part4",j),mc_vmc_bl_num_part4_q[j]); 
                        //`uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part4_q[%0d] = %0h",j,mc_vmc_bl_num_part4_q[j]), UVM_LOW);
                    end 
                    for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                        if(col_part4_check >= mc_vmc_bl_num_part4_q[bl_cnt])begin 
                            col_part4_check_i++;
                        end
                    end              
                    if(col_part4_check_i==mc_vmc_bl_num_part4_q[1])begin
                        col_part4_check_i++;
                    end
                    if(m_tb_if.gcadd!=col_part4_check_i)begin
                        `uvm_error("csl vmc failed", $sformatf("exp cadd is %0d, actual cadd is %0d",col_part4_check,m_tb_if.gcadd))
                    end

                    if(cnt_part4==127)begin
                        col_part4_check=0;
                        col_part4_check_i=0;
                        cnt_part4=0;
                    end
                    else begin
                        col_part4_check=col_part4_check+1;
                        col_part4_check_i=col_part4_check;
                        cnt_part4=cnt_part4+1;
                    end
                end
                if(m_tb_if.wl_rd_num!=start_num&&!m_tb_if.wl_scan_row_status)begin
                    start_num = m_tb_if.wl_rd_num;
                        col_part0_check=0;
                        col_part0_check_i=0;
                        col_part1_check=0;
                        col_part1_check_i=0;
                        col_part2_check=0;
                        col_part2_check_i=0;
                        col_part3_check=0;
                        col_part3_check_i=0;
                        col_part4_check=0;
                        col_part4_check_i=0;
                        cnt_part0=0;
                        cnt_part1=0;
                        cnt_part2=0;
                        cnt_part3=0;
                        cnt_part4=0;
                end
            end            
            while(m_tb_if.wl_scan_working == 1)begin   
                @(negedge m_array_agent_if.clk);
                if(bist_finish_mask==1)begin
                    if(m_tb_if.bist_finish_int==1)begin
                        `uvm_error("bist_csl_wl", "bist finish mask fail")
                        break;
                    end
                    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.bist_finish_i",bist_finish_status_reg);
                    if(bist_finish_status_reg==1)begin
                        break;
                    end
                end
                if(bist_finish_mask==0)begin
                    if(m_tb_if.bist_finish_int==1)begin
                        break;
                    end
                end
            end
            /*while(m_tb_if.wl_scan_working == 1)begin
                @(negedge m_array_agent_if.clk);
                //@(posedge m_array_agent_if.gcas_rd);
                if(m_array_agent_if.gcas_rd == 1)begin
                    gcas_rd_wl_cnt++;
                    gcas_rd_wl_cnt_old = gcas_rd_wl_cnt;
                    foreach(vmc_wl_addr_q[i])begin 
                        if((m_array_agent_if.gradd_n == vmc_wl_addr_q[i])&&m_array_agent_if.gcadd == gcadd_num)begin
                            if(gcas_rd_wl_cnt_old==gcas_rd_wl_cnt)begin
                                gcas_rd_cnt_wl_q.push_back(gcas_rd_wl_cnt);
                                `uvm_info(get_type_name(),$sformatf("inject_err_gradd=%0d,vmc_wl_addr_q_debug =%0d",m_array_agent_if.gradd_n,vmc_wl_addr_q[i]),UVM_LOW);
                                gcas_rd_wl_cnt_old++;
                            end
                        end
                    end
                    gcas_rd_wl_cnt_old=0;
                end
                if(m_tb_if.wl_single_rd_done==1&&wl_time<wl_scan_cnt)begin
                    vmc_wl_addr_q.delete();
                    randomize(vmc_wl_cnt) with {vmc_wl_cnt dist {[0:63]:/90,[64:127]:/10};};     
                    `uvm_info(get_type_name(),$sformatf("vmc_wl_cnt =%0d",vmc_wl_cnt),UVM_LOW);
                    for(int k=0;k<vmc_wl_cnt;k++)begin
                        //randomize(vmc_wl_addr) with {vmc_wl_addr inside {[0:7359]};};
                        randomize(vmc_wl_addr) with {vmc_wl_addr inside {[0:127]};};
                        `uvm_info(get_type_name(),$sformatf("vmc_wl_addr =%0d",vmc_wl_addr),UVM_LOW);
                        vmc_wl_addr_q.push_back(vmc_wl_addr);
                    end
                    foreach(vmc_wl_addr_q[i])begin
                        automatic bit [`ROW_ADDR_WIDTH-1:0] temp[$] = vmc_wl_addr_q;
                        temp.sort();
                        vmc_wl_addr_q = temp;
                        `uvm_info(get_type_name(),$sformatf("vmc_wl_addr =%0d",vmc_wl_addr_q[i]),UVM_LOW);
                    end

                    foreach(vmc_wl_addr_q[i])begin
                        vmc_wl_addr_q_copy.push_back(vmc_wl_addr_q[i]);
                        `uvm_info(get_type_name(),$sformatf("vmc_wl_addr_q =%0d",vmc_wl_addr_q[i]),UVM_LOW);

                    end
                    wl_time++;
                end
                if(m_tb_if.bist_finish_int==1)break;
            end
            while(m_tb_if.wl_scan_working == 1)begin   
                @(negedge m_array_agent_if.clk);
                if(m_array_agent_if.rdrdy_n == 0)begin
                    rdrdy_n_wl_cnt++;
                    if(gcas_rd_cnt_wl_q.size != 0 && gcas_rd_cnt_wl_q[0] == rdrdy_n_wl_cnt)begin
                        gcas_rd_cnt_wl_q.pop_front();
                        `uvm_info(get_type_name(),$sformatf("gcas_rd_cnt_q.size =%0d",gcas_rd_cnt_wl_q.size),UVM_LOW);                    
                        wl_err_addr_hit = 1;
                    end
                    if(wl_err_addr_hit == 1)begin
                        act_rdl = m_array_agent_if.rdl;
                        err_rdl = ~act_rdl;  
                        `uvm_info(get_type_name(),$sformatf("inject_err_rdl=%0h",err_rdl),UVM_LOW);
                        uvm_hdl_force("mc_tb.m_mc_wrapper_aux.rdl",err_rdl);
                    end
                end
                else if(m_array_agent_if.rdrdy_n == 1 && wl_err_addr_hit==1)begin
                    uvm_hdl_release("mc_tb.m_mc_wrapper_aux.rdl");
                    wl_err_addr_hit = 0;
                end
                if(bist_finish_mask==1)begin
                    if(m_tb_if.bist_finish_int==1)begin
                        `uvm_error("bist_csl_wl", "bist finish mask fail")
                        break;
                    end
                    uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.bist_finish_i",bist_finish_status_reg);
                    if(bist_finish_status_reg==1)begin
                        break;
                    end
                end
                if(bist_finish_mask==0)begin
                    if(m_tb_if.bist_finish_int==1)begin
                        break;
                    end
                end
            end*/
        join
        if(bist_finish_mask==1)begin
            if(m_tb_if.bist_finish_int==1)begin
                `uvm_error("bist_csl_wl", "bist finish mask fail")
            end
            while(read_data==0)begin
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_reg.read(status, read_data, UVM_FRONTDOOR);
            end
        end
        else begin
            wait(m_tb_if.bist_finish_int==1); 

            while(read_data==0)begin
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_reg.read(status, read_data, UVM_FRONTDOOR);
            end
        end
        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_bank_success",read_data1);
        `uvm_info(get_type_name(),$sformatf("wl_cnt=%0d",wl_cnt),UVM_LOW);



        if((vmc_csl_cnt==3&&gradd_num_q_part0.size()>=csl_err_th)||(vmc_csl_cnt_part1==3&&gradd_num_q_part1.size()>=csl_err_th)||(vmc_csl_cnt_part2==3&&gradd_num_q_part2.size()>=csl_err_th)||(vmc_csl_cnt_part3==3&&gradd_num_q_part3.size()>=csl_err_th)||(vmc_csl_cnt_part4==3&&gradd_num_q_part4.size()>=csl_err_th))begin
            if(read_data1 == 1)begin
                `uvm_error("bist_csl_wl", "bist scan fail")
            end
        end

        csl_q_size = vmc_csl_addr_q_copy.size();
        csl_q_size_part1 = vmc_csl_addr_q_copy_part1.size();
        csl_q_size_part2 = vmc_csl_addr_q_copy_part2.size();
        csl_q_size_part3 = vmc_csl_addr_q_copy_part3.size();
        csl_q_size_part4 = vmc_csl_addr_q_copy_part4.size();
        if(num==0)begin
            //part0
            if(gradd_num_q_part0.size()<csl_err_th)begin
                for(int i =0;i<2;i++)begin
                    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part0_i",i),read_data_csl);
                    if(read_data_csl != 8'hff)begin
                        `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                    end
                end
            end
            else begin
                for(int i =0;i<csl_q_size;i++)begin
                    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part0_i",i),read_data_csl);
                    data_csl = vmc_csl_addr_q_copy.pop_front();
                    if(read_data_csl != data_csl)begin
                        `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,data_csl))
                    end
                    if(i==1)begin
                        break;
                    end
                end
            end
            //part1
            if((gradd_num_q_part0.size()>csl_err_th||gradd_num_q_part0.size()==csl_err_th)&&vmc_csl_cnt>2) begin
                for(int i =0;i<2;i++)begin
                    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part1_i",i),read_data_csl);
                    if(read_data_csl != 8'hff)begin
                        `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                    end
                end
            end
            else begin
                if(gradd_num_q_part1.size()<csl_err_th)begin
                    for(int i =0;i<2;i++)begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part1_i",i),read_data_csl);
                        if(read_data_csl != 8'hff)begin
                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                        end
                    end
                end
                else begin
                    for(int i =0;i<csl_q_size_part1;i++)begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part1_i",i),read_data_csl);
                        data_csl = vmc_csl_addr_q_copy_part1.pop_front();
                        if(read_data_csl != data_csl)begin
                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,data_csl))
                        end
                        if(i==1)begin
                            break;
                        end
                    end
                end
            end
            //part2
            if(((gradd_num_q_part1.size()>csl_err_th||gradd_num_q_part1.size()==csl_err_th)&&vmc_csl_cnt_part1>2)||((gradd_num_q_part0.size()>csl_err_th||gradd_num_q_part0.size()==csl_err_th)&&vmc_csl_cnt>2)) begin
                for(int i =0;i<2;i++)begin
                    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part2_i",i),read_data_csl);
                    if(read_data_csl != 8'hff)begin
                        `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                    end
                end
            end
            else begin
                if(gradd_num_q_part2.size()<csl_err_th)begin
                    for(int i =0;i<2;i++)begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part2_i",i),read_data_csl);
                        if(read_data_csl != 8'hff)begin
                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                        end
                    end
                end
                else begin
                    for(int i =0;i<csl_q_size_part2;i++)begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part2_i",i),read_data_csl);
                        data_csl = vmc_csl_addr_q_copy_part2.pop_front();
                        if(read_data_csl != data_csl)begin
                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,data_csl))
                        end
                        if(i==1)begin
                            break;
                        end
                    end
                end
            end
            //part3
            if(((gradd_num_q_part2.size()>csl_err_th||gradd_num_q_part2.size()==csl_err_th)&&vmc_csl_cnt_part2>2)||((gradd_num_q_part1.size()>csl_err_th||gradd_num_q_part1.size()==csl_err_th)&&vmc_csl_cnt_part1>2)||((gradd_num_q_part0.size()>csl_err_th||gradd_num_q_part0.size()==csl_err_th)&&vmc_csl_cnt>2))begin
                for(int i =0;i<2;i++)begin
                    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part3_i",i),read_data_csl);
                    if(read_data_csl != 8'hff)begin
                        `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                    end
                end
            end
            else begin
                if(gradd_num_q_part3.size()<csl_err_th)begin
                    for(int i =0;i<2;i++)begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part3_i",i),read_data_csl);
                        if(read_data_csl != 8'hff)begin
                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                        end
                    end
                end
                else begin
                    for(int i =0;i<csl_q_size_part3;i++)begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part3_i",i),read_data_csl);
                        data_csl = vmc_csl_addr_q_copy_part3.pop_front();
                        if(read_data_csl != data_csl)begin
                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,data_csl))
                        end
                        if(i==1)begin
                            break;
                        end
                    end
                end
            end
            //part4
            if(((gradd_num_q_part3.size()>csl_err_th||gradd_num_q_part3.size()==csl_err_th)&&vmc_csl_cnt_part3>2)||((gradd_num_q_part2.size()>csl_err_th||gradd_num_q_part2.size()==csl_err_th)&&vmc_csl_cnt_part2>2)||((gradd_num_q_part1.size()>csl_err_th||gradd_num_q_part1.size()==csl_err_th)&&vmc_csl_cnt_part1>2)||((gradd_num_q_part0.size()>csl_err_th||gradd_num_q_part0.size()==csl_err_th)&&vmc_csl_cnt>2)) begin
                for(int i =0;i<2;i++)begin
                    uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part4_i",i),read_data_csl);
                    if(read_data_csl != 8'hff)begin
                        `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                    end
                end
            end
            else begin
                if(gradd_num_q_part4.size()<csl_err_th)begin
                    for(int i =0;i<2;i++)begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part4_i",i),read_data_csl);
                        if(read_data_csl != 8'hff)begin
                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                        end
                    end
                end
                else begin
                    for(int i =0;i<csl_q_size_part4;i++)begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part4_i",i),read_data_csl);
                        data_csl = vmc_csl_addr_q_copy_part4.pop_front();
                        if(read_data_csl != data_csl)begin
                            `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,data_csl))
                        end
                        if(i==1)begin
                            break;
                        end
                    end
                end
            end
            //wl check
            if(!((vmc_csl_cnt==3&&gradd_num_q_part0.size()>=csl_err_th)||(vmc_csl_cnt_part1==3&&gradd_num_q_part1.size()>=csl_err_th)||(vmc_csl_cnt_part2==3&&gradd_num_q_part2.size()>=csl_err_th)||(vmc_csl_cnt_part3==3&&gradd_num_q_part3.size()>=csl_err_th)||(vmc_csl_cnt_part4==3&&gradd_num_q_part4.size()>=csl_err_th)))begin
                uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part0_i",0),read_data_csl);
                if(read_data_csl!=8'hff||(vmc_csl_addr_q.size()==1&&vmc_csl_addr_q[0]>127)||(vmc_csl_addr_q.size()==2&&vmc_csl_addr_q[0]>127&&vmc_csl_addr_q[1]>127))begin
                    for(int i=gradd_num_q_total.size()-1;i>=0;i--)begin
                        if(gradd_num_q_total[i]>=0&&gradd_num_q_total[i]<30)begin
                            gradd_num_q_total.delete(i);
                        end
                    end
                end
                uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part1_i",0),read_data_csl);
                if(read_data_csl!=8'hff||(vmc_csl_addr_q_part1.size()==1&&vmc_csl_addr_q_part1[0]>127)||(vmc_csl_addr_q_part1.size()==2&&vmc_csl_addr_q_part1[0]>127&&vmc_csl_addr_q_part1[1]>127))begin
                    for(int i=gradd_num_q_total.size()-1;i>=0;i--)begin
                        if(gradd_num_q_total[i]>=30&&gradd_num_q_total[i]<60)begin
                            gradd_num_q_total.delete(i);
                        end
                    end
                end
                uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part2_i",0),read_data_csl);
                if(read_data_csl!=8'hff||(vmc_csl_addr_q_part2.size()==1&&vmc_csl_addr_q_part2[0]>127)||(vmc_csl_addr_q_part2.size()==2&&vmc_csl_addr_q_part2[0]>127&&vmc_csl_addr_q_part2[1]>127))begin
                    for(int i=gradd_num_q_total.size()-1;i>=0;i--)begin
                        if(gradd_num_q_total[i]>=60&&gradd_num_q_total[i]<90)begin
                            gradd_num_q_total.delete(i);
                        end
                    end
                end
                uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part3_i",0),read_data_csl);
                if(read_data_csl!=8'hff||(vmc_csl_addr_q_part3.size()==1&&vmc_csl_addr_q_part3[0]>127)||(vmc_csl_addr_q_part3.size()==2&&vmc_csl_addr_q_part3[0]>127&&vmc_csl_addr_q_part3[1]>127))begin
                    for(int i=gradd_num_q_total.size()-1;i>=0;i--)begin
                        if(gradd_num_q_total[i]>=90&&gradd_num_q_total[i]<120)begin
                            gradd_num_q_total.delete(i);
                        end
                    end
                end
                uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part4_i",0),read_data_csl);
                if(read_data_csl!=8'hff||(vmc_csl_addr_q_part4.size()==1&&vmc_csl_addr_q_part4[0]>127)||(vmc_csl_addr_q_part4.size()==2&&vmc_csl_addr_q_part4[0]>127&&vmc_csl_addr_q_part4[1]>127))begin
                    for(int i=gradd_num_q_total.size()-1;i>=0;i--)begin
                        if(gradd_num_q_total[i]>=120&&gradd_num_q_total[i]<150)begin
                            gradd_num_q_total.delete(i);
                        end
                    end
                end


                foreach(gradd_num_q_total[i])begin
                    automatic bit [`ROW_ADDR_WIDTH-1:0] temp[$] = gradd_num_q_total;
                    temp.sort();
                    gradd_num_q_total = temp;
                    `uvm_info(get_type_name(),$sformatf("gradd_num_q_total =%0d",gradd_num_q_total[i]),UVM_LOW);
                end
                wl_total_size = gradd_num_q_total.size();
                `uvm_info(get_type_name(), $sformatf("wl_total_size is %0d",wl_total_size), UVM_LOW);
                if(wl_total_size>64)begin
                    for(int k = 0;k<64;k++)begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_wl%0d_i",63-k),read_data_wl);
                        wl_err = gradd_num_q_total.pop_front();
                        if(read_data_wl != wl_err)begin
                            `uvm_error("wl vmc reg check failed", $sformatf("reg wl radd is %0d, actual radd is %0d",read_data_wl,wl_err))
                        end
                    end
                end
                else begin
                    for(int k = 0;k<wl_total_size;k++)begin
                        uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_wl%0d_i",wl_total_size-k-1),read_data_wl);
                        wl_err = gradd_num_q_total.pop_front();
                        `uvm_info(get_type_name(), $sformatf("wl_err is %0d",wl_err), UVM_LOW);
                        if(read_data_wl != wl_err)begin
                            `uvm_error("wl vmc reg check failed", $sformatf("reg wl radd is %0d, actual radd is %0d",read_data_wl,wl_err))
                        end
                    end
                end
                if((gradd_num_q_part0.size()<csl_err_th&&vmc_csl_cnt!=0&&gradd_num_q_part0.size()>0)||(gradd_num_q_part1.size()<csl_err_th&&vmc_csl_cnt_part1!=0&&gradd_num_q_part1.size()>0)||(gradd_num_q_part2.size()<csl_err_th&&vmc_csl_cnt_part2!=0&&gradd_num_q_part2.size()>0)||(gradd_num_q_part3.size()<csl_err_th&&vmc_csl_cnt_part3!=0&&gradd_num_q_part3.size()>0)||(gradd_num_q_part4.size()<csl_err_th&&vmc_csl_cnt_part4!=0&&gradd_num_q_part4.size()>0))begin
                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_err_wl_reg.mc_bist_err_wl_num.read(status, read_data, UVM_FRONTDOOR);
                    if(read_data==0)begin
                        `uvm_error("wl vmc reg check failed", $sformatf("clr bist_err_wl_cnt is %0d",read_data))
                    end
                    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_err_wl_reg.err_wl_num_change_flag.read(status, read_data, UVM_FRONTDOOR);
                    #20ns;
                    if(read_data!=1)begin
                        `uvm_error("bist_csl_wl", "err_wl_cnt_change check fail")
                    end
                end
            end
        end
        if(num==1)begin
            for(int i =0;i<2;i++)begin
                uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part0_i",i),read_data_csl);
                if(read_data_csl != 8'hff)begin
                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                end
            end
            read_data_csl=0;
            for(int i =0;i<2;i++)begin
                uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part1_i",i),read_data_csl);
                if(read_data_csl != 8'hff)begin
                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                end
            end
            read_data_csl=0;
            for(int i =0;i<2;i++)begin
                uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part2_i",i),read_data_csl);
                if(read_data_csl != 8'hff)begin
                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                end
            end
            read_data_csl=0;
            for(int i =0;i<2;i++)begin
                uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part3_i",i),read_data_csl);
                if(read_data_csl != 8'hff)begin
                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                end
            end
            read_data_csl=0;
            for(int i =0;i<2;i++)begin
                uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_csl%0d_part4_i",i),read_data_csl);
                if(read_data_csl != 8'hff)begin
                    `uvm_error("csl vmc reg check failed", $sformatf("reg csl cadd is %0d, actual cadd is %0d",read_data_csl,8'hff))
                end
            end
            m_tb_if.global_bist_clr=1;
            #30ns;
            for(int k = 0;k<64;k++)begin
                uvm_hdl_read($sformatf("mc_tb.m_mc_wrapper_aux.mc_top_u.apb2reg_mc_soc_top_cfg_if_u.err_wl%0d_i",63-k),read_data_wl);
                if(read_data_wl != 13'h1fff)begin
                    `uvm_error("wl vmc reg check failed", $sformatf("reg wl radd is %0d, actual radd is %0d",read_data_wl,data_wl))
                end
            end
            p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_bist_err_wl_reg.read(status, read_data, UVM_FRONTDOOR);
            if(read_data!=0)begin
                `uvm_error("wl vmc reg check failed", $sformatf("clr bist_err_wl_cnt is %0d",read_data))
            end

        end

    end
    if(num==1)begin
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_clr.write(status,1'b1,UVM_FRONTDOOR);
        repeat(30) @(posedge m_tb_if.clk); 
        if(m_tb_if.bist_finish_int!=0)begin
            `uvm_error("bist_csl_wl_finish", "bist finish fail")
        end
        read_data=0;
        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_reg.bist_finish.read(status,read_data,UVM_FRONTDOOR);
        repeat(30) @(posedge m_tb_if.clk); 
        if(read_data!=0)begin
            `uvm_error("bist_csl_wl_finish", "bist finish fail")
        end
    end
    if(num==0)begin
        foreach(vmc_csl_addr_q[i])begin
            foreach(gradd_num_q_part0[j])begin
                `uvm_info(get_type_name(),$sformatf("row0 =%0d, csl0 =%0d",gradd_num_q_part0[j],vmc_csl_addr_q[i]),UVM_LOW);
                uvm_hdl_release($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part0[j],vmc_csl_addr_q[i]}));
            end
        end
        foreach(vmc_csl_addr_q_part1[i])begin
            foreach(gradd_num_q_part1[j])begin
                `uvm_info(get_type_name(),$sformatf("row1 =%0d, csl1 =%0d",gradd_num_q_part1[j],vmc_csl_addr_q_part1[i]),UVM_LOW);
                uvm_hdl_release($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part1[j],vmc_csl_addr_q_part1[i]}));
            end
        end    
        foreach(vmc_csl_addr_q_part2[i])begin
            foreach(gradd_num_q_part2[j])begin
                `uvm_info(get_type_name(),$sformatf("row2 =%0d, csl2 =%0d",gradd_num_q_part2[j],vmc_csl_addr_q_part2[i]),UVM_LOW);
                uvm_hdl_release($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part2[j],vmc_csl_addr_q_part2[i]}));
            end
        end
        foreach(vmc_csl_addr_q_part3[i])begin
            foreach(gradd_num_q_part3[j])begin
                `uvm_info(get_type_name(),$sformatf("row3 =%0d, csl3 =%0d",gradd_num_q_part3[j],vmc_csl_addr_q_part3[i]),UVM_LOW);
                uvm_hdl_release($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part3[j],vmc_csl_addr_q_part3[i]}));
            end
        end
        foreach(vmc_csl_addr_q_part4[i])begin
            foreach(gradd_num_q_part4[j])begin
                `uvm_info(get_type_name(),$sformatf("row4 =%0d, csl4 =%0d",gradd_num_q_part4[j],vmc_csl_addr_q_part4[i]),UVM_LOW);
                uvm_hdl_release($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part4[j],vmc_csl_addr_q_part4[i]}));
            end
        end
    end
    #1us;
    num=num+1;
    vmc_wl_addr_q.delete();
    vmc_wl_addr_q_copy.delete();
    vmc_wl_addr_q_copy1.delete();

    vmc_csl_addr_q.delete();
    vmc_csl_addr_q_copy.delete();
    vmc_csl_addr_q_copy_part1.delete();
    vmc_csl_addr_q_copy_part2.delete();
    vmc_csl_addr_q_copy_part3.delete();
    vmc_csl_addr_q_copy_part4.delete();
    vmc_csl_addr_q.delete();
    vmc_csl_addr_q_part1.delete();
    vmc_csl_addr_q_part2.delete();
    vmc_csl_addr_q_part3.delete();
    vmc_csl_addr_q_part4.delete();
    gcas_rd_cnt_q.delete();
    gcas_rd_cnt_wl_q.delete();

    gradd_num_q.delete();
    gradd_num_q_up.delete();
    gradd_num_q_down.delete();
    gradd_num_q_part0.delete();
    gradd_num_q_part1.delete();
    gradd_num_q_part2.delete();
    gradd_num_q_part3.delete();
    gradd_num_q_part4.delete();
    gcas_rd_cnt=0;
    gcas_rd_wl_cnt=0;
    wl_rd_num_start=0;
    index=0;
    rdrdy_n_wl_cnt=0;
    rdrdy_n_cnt=0;
    end
    `uvm_info(get_type_name(),"body===========finish===========",UVM_LOW);
endtask

endclass


`endif
