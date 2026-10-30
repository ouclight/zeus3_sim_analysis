//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_bist_scan_vmc_wr_rd_vseq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 29 14:33:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_BIST_SCAN_VMC_WR_RD_VSEQ
`define MC_BIST_SCAN_VMC_WR_RD_VSEQ

class mc_bist_scan_vmc_wr_rd_vseq extends mc_common_vseq;
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
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_err;
    bit   [`COLUMN_ADDR_WIDTH-1:0]   col;
    bit   [`COLUMN_ADDR_WIDTH-1:0]   col1;
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_part1[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_part2[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_part3[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_part4[$];

    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_second_0[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_second_1[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_second_2[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_second_3[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_second_4[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part1[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part2[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part3[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_q_copy_part4[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]  csl_err_second_0;
    bit         [`COLUMN_ADDR_WIDTH-1:0]  csl_err_second_1;
    bit         [`COLUMN_ADDR_WIDTH-1:0]  csl_err_second_2;
    bit         [`COLUMN_ADDR_WIDTH-1:0]  csl_err_second_3;
    bit         [`COLUMN_ADDR_WIDTH-1:0]  csl_err_second_4;
    bit                                 csl_err_addr_hit = 0;
    bit                                 wl_err_addr_hit = 0;
    bit                                 wl_total_size = 0;
    bit         [12:0]                  wl_err;
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
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num_second;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num1_second;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num2_second;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num3_second;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num4_second;
    bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num_cp;
    randc bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num_down;
    bit    [`ROW_ADDR_WIDTH-1:0]                  gradd_num_down_cp;
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q[$];
    bit    [`ROW_ADDR_WIDTH-1:0]                       gradd_num_q_data;
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
    `uvm_object_utils(mc_bist_scan_vmc_wr_rd_vseq)
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
    bit [31:0] csl_q_size_0;
    bit [31:0] csl_q_size_1;
    bit [31:0] csl_q_size_2;
    bit [31:0] csl_q_size_3;
    bit [31:0] csl_q_size_4;
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
    int                                 base_addr=0          ;
    bit         [31:0]                  offset_addr        ;
    bit [`ROW_ADDR_WIDTH-1:0]               read_err_row_reg;      //row err addr reg, 0~63
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg0_q[$];      //csl err addr reg, up0, up1
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg1_q[$];      //csl err addr reg, down0, down1
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg2_q[$];      //csl err addr reg, down0, down1
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg3_q[$];      //csl err addr reg, down0, down1
    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg4_q[$];      //csl err addr reg, down0, down1

    bit [`COLUMN_ADDR_WIDTH-1:0]            read_err_csl_reg;      
    bit [`ROW_ADDR_WIDTH-1:0]               read_err_row_reg_q[$];      //row err addr reg, 0~63
    rand bit    [6:0]                   csl_pattern_num; 
    rand bit    [6:0]                   wl_pattern_num; 
    rand bit            close_page_en;
    constraint csl_pattern_num_c {csl_pattern_num inside {[1:10]};}
    constraint wl_pattern_num_c {wl_pattern_num inside {[1:10]};}
    constraint csl_err_th_c {csl_err_th dist{[1:1]:/20,[2:15]:/20,[16:16]:/20,[17:30]:/20/*,[31:31]:/20*/};};
    constraint wl_scan_cnt_c {wl_scan_cnt inside{[0:1]};};
    constraint csl_err_num_c {csl_error_num inside {[1:3]};} 
    localparam                                              BIST_WL_NUM=150;
    localparam                                              BURST_WIDTH=128;
    localparam      ERR_CSL_DEFAULT_VALUE='hff;
    localparam      ERR_WL_DEFAULT_VALUE='h1fff;
    bit [7:0]   read_csl0;
    bit [7:0]   read_csl1;
    function new(string name="mc_bist_scan_vmc_wr_rd_vseq");
        super.new(name);
    endfunction

virtual task body();
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    super.body();
    begin
    
    for(int col=0;col<130;col++)begin
    //for(int col=0;col<3;col++)begin
        //for(int col1=0;col1<3;col1++)begin
        for(int col1=0;col1<130;col1++)begin
            if(col1>col)begin
                `uvm_info(get_type_name(),$sformatf("col =%0d, col1=%0d",col,col1),UVM_LOW);
                m_tb_if.mc_bist_csl_vmc_en=1;
                m_tb_if.bist_test_en = 1;
                m_tb_if.mc_scan_timeout_en=1;
                randomize(bist_pattern,wl_scan_cnt,csl_err_th,close_page_en,csl_pattern_num,wl_pattern_num);
                randomize(vmc_wl_cnt) with {vmc_wl_cnt dist {[0:63]:/90,[64:127]:/10};};     
                csl_err_th = 2;
                `uvm_info(get_type_name(),$sformatf("vmc_wl_cnt =%0d, vmc_csl_cnt=%0d,wl_scan_cnt=%0d,csl_err_th=%0d,csl_pattern_num=%0d,wl_pattern_num=%0d",vmc_wl_cnt,vmc_csl_cnt,wl_scan_cnt,csl_err_th,csl_pattern_num,wl_pattern_num),UVM_LOW);
                if(close_page_en == 1)begin
                    while(mc_page_status==1)begin
                        p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_page_status.read(status, mc_page_status, UVM_FRONTDOOR);
                    end
                    m_tb_if.page_mode_switch = 1'b1;
                    m_tb_if.pre_precharge = 0;
                end
                if(num==0)begin
                    
                    vmc_csl_addr_q.push_back(col);
                    vmc_csl_addr_q.push_back(col1);

                    foreach(vmc_csl_addr_q[i])begin
                        automatic bit [`COL_ADDR_WIDTH:0] temp[$] = vmc_csl_addr_q;
                        temp.sort();
                        vmc_csl_addr_q = temp;
                        //`uvm_info(get_type_name(),$sformatf("vmc_csl_addr_part0 =%0h",vmc_csl_addr_q[i]),UVM_LOW);
                    end

                    vmc_csl_addr_q_part1.push_back(col);
                    vmc_csl_addr_q_part1.push_back(col1);
                    foreach(vmc_csl_addr_q_part1[i])begin
                        automatic bit [`COL_ADDR_WIDTH:0] temp[$] = vmc_csl_addr_q_part1;
                        temp.sort();
                        vmc_csl_addr_q_part1 = temp;
                        //`uvm_info(get_type_name(),$sformatf("vmc_csl_addr_part1 =%0h",vmc_csl_addr_q_part1[i]),UVM_LOW);
                    end

                end

                //csl scan error row product
                if(num==0)begin
                    randomize(csl_error_num);
                    //`uvm_info(get_type_name(),$sformatf("csl_error_cnt0 =%0d",csl_error_num),UVM_LOW);
                    for(int kk=0;kk<csl_error_num;kk++)begin
                        randomize(gradd_num) with {gradd_num inside {[27:29]};}; 
                        gradd_num_q_part0.push_back(gradd_num);
                        //`uvm_info(get_type_name(),$sformatf("gradd_num =%0d",gradd_num),UVM_LOW);
                    end
                    gradd_num_q = gradd_num_q_part0;
                    
                    randomize(csl_error_num);
                    //`uvm_info(get_type_name(),$sformatf("csl_error_cnt1 =%0d",csl_error_num),UVM_LOW);
                    for(int kk=0;kk<csl_error_num;kk++)begin
                        randomize(gradd_num1) with {gradd_num1 inside {[30:32]};}; 
                        gradd_num_q_part1.push_back(gradd_num1);
                        //`uvm_info(get_type_name(),$sformatf("gradd_num1 =%0d",gradd_num1),UVM_LOW);
                    end
                    
                end

                uvm_hdl_deposit("mc_tb.u_quad_group.XBK0.memory[0]",0);

                //err inct
                foreach(vmc_csl_addr_q[i])begin
                    foreach(gradd_num_q_part0[j])begin
                        //`uvm_info(get_type_name(),$sformatf("row0 =%0d, csl0 =%0d",gradd_num_q_part0[j],vmc_csl_addr_q[i]),UVM_LOW);
                        uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part0[j],vmc_csl_addr_q[i]}),8'd123);
                    end
                end
                foreach(vmc_csl_addr_q_part1[i])begin
                    foreach(gradd_num_q_part1[j])begin
                        //`uvm_info(get_type_name(),$sformatf("row1 =%0d, csl1 =%0d",gradd_num_q_part1[j],vmc_csl_addr_q_part1[i]),UVM_LOW);
                        uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part1[j],vmc_csl_addr_q_part1[i]}),8'd123);
                    end
                end   
                randomize(vmc_csl_addr_err) with {foreach(vmc_csl_addr_q[i]) vmc_csl_addr_err != vmc_csl_addr_q[i];
                                                  foreach(vmc_csl_addr_q_part1[i]) vmc_csl_addr_err != vmc_csl_addr_q_part1[i];
                                                  vmc_csl_addr_err inside {[0:128]};};
                //`uvm_info(get_type_name(),$sformatf("vmc_csl_addr_err =%0d",vmc_csl_addr_err),UVM_LOW);
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{13'd29,vmc_csl_addr_err}),8'd123);
                vmc_csl_addr_err = vmc_csl_addr_err+1;
                uvm_hdl_force($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{13'd30,vmc_csl_addr_err}),8'd123);
                //err inject end
                foreach (bist_pattern[j]) begin
                    m_tb_if.bist_pattern[j] = bist_pattern[j];
                    $display("bist_pattern%0d is %0h", j, m_tb_if.bist_pattern[j]);
                end
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.bist_finish_mask.write(status,1'b0,UVM_FRONTDOOR);

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




                wait(m_tb_if.csl_scan_working == 1);
                repeat(1) @(posedge m_tb_if.clk);
                wait(m_tb_if.csl_scan_working == 0);
                `uvm_info(get_type_name(),"success wait csl_scan_working posedge",UVM_LOW);
                `uvm_info(get_type_name(),$sformatf("gradd=%0d,gradd_down=%0d,gcadd =%0d,",gradd_num,gradd_num_down,gcadd_num),UVM_LOW);
                wait(m_tb_if.wl_scan_working == 1);
                `uvm_info(get_type_name(),"success wait wl_scan_working posedge",UVM_LOW);
                repeat(10) @(posedge m_tb_if.clk);
                //wait(m_tb_if.wl_scan_working == 0);
                wait(m_tb_if.bist_finish_int == 1);
                repeat(100) @(posedge m_tb_if.clk);

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
                read_err_row_reg_q.sort();
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
                @(posedge m_tb_if.pclk);
                m_tb_if.mc_bist_csl_vmc_en=0;

                m_tb_if.bist_test_en = 0;
                #100ns;
                for(int i=0;i<BIST_WL_NUM-64;i++)begin
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
                for(int i=0;i<BIST_WL_NUM-64;i++)begin
                    assert(m_frame_cfg.randomize with {
                        cadd                == 0;
                        radd                == i;
                        frame_rw_flag       == 0;   //1:wr 0:rd
                        one_frame_cnt       == BURST_WIDTH;
                        col_addr_rand_en    == 0;
                        wrap_en             == 0;
                        strb_rand_en        == 0;
                        strb                == 1;
                    });
                    send_one_frame(m_frame_cfg);        
                end
                #100ns;
                foreach(vmc_csl_addr_q[i])begin
                    foreach(gradd_num_q_part0[j])begin
                        //`uvm_info(get_type_name(),$sformatf("row0 =%0d, csl0 =%0d",gradd_num_q_part0[j],vmc_csl_addr_q[i]),UVM_LOW);
                        uvm_hdl_release($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part0[j],vmc_csl_addr_q[i]}));
                    end
                end
                foreach(vmc_csl_addr_q_part1[i])begin
                    foreach(gradd_num_q_part1[j])begin
                        //`uvm_info(get_type_name(),$sformatf("row1 =%0d, csl1 =%0d",gradd_num_q_part1[j],vmc_csl_addr_q_part1[i]),UVM_LOW);
                        uvm_hdl_release($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{gradd_num_q_part1[j],vmc_csl_addr_q_part1[i]}));
                    end
                end   
                vmc_csl_addr_err = vmc_csl_addr_err-1;
                uvm_hdl_release($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{13'd29,vmc_csl_addr_err}));
                vmc_csl_addr_err = vmc_csl_addr_err+1;
                uvm_hdl_release($sformatf("mc_tb.u_quad_group.XBK0.memory[%0d]",{13'd30,vmc_csl_addr_err}));
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_wl_vmc_en.write(status,1'b0, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_bl_vmc_en.write(status,1'b0, UVM_FRONTDOOR);
                vmc_csl_addr_q.delete();
                vmc_csl_addr_q_part1.delete();
                read_err_csl_reg0_q.delete();
                read_err_csl_reg1_q.delete();
                read_err_csl_reg2_q.delete();
                read_err_csl_reg3_q.delete();
                read_err_csl_reg4_q.delete();
                read_err_row_reg_q.delete();

                #100ns;
            end

        end
    end
    end
    `uvm_info(get_type_name(),"body===========finish===========",UVM_LOW);
endtask

endclass


`endif
