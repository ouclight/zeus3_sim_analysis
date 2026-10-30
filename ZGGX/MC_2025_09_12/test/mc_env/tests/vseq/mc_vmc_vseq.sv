
`ifndef MC_VMC_VSEQ
`define MC_VMC_VSEQ

class mc_vmc_vseq extends mc_common_vseq;
    
    rand bit    [6:0]                   vmc_wl_cnt;
    rand bit    [1:0]                   vmc_csl_cnt;
    rand bit   [`ROW_ADDR_WIDTH-1:0]   vmc_wl_addr;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_1;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_2;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_3;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_4;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_5;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_6;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_7;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_8;
    randc bit   [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_9;
    bit         [`ROW_ADDR_WIDTH-1:0]   vmc_wl_addr_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_up_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_down_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part0_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part1_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part2_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part3_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part4_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part5_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part6_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part7_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part8_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_part9_q[$];
    bit         [`COLUMN_ADDR_WIDTH-1:0]   vmc_csl_addr_copy_q[$];
    rand bit    [15:0]                  burst_cnt_i     ;
    rand bit    [`ROW_ADDR_WIDTH-1:0]                  radd_i          ;
    rand bit    [`ROW_ADDR_WIDTH-1:0]                  radd_seed          ;
    rand bit    [31:0]                  num_seed          ;
    rand bit    [`COL_ADDR_WIDTH-1:0]                   cadd_i          ;    
    rand bit                            radd_vmc_en     ;
    rand bit                            cadd_vmc_en     ;    
    int                                 base_addr          ;
    bit         [31:0]                  offset_addr        ;
    rand bit                            csl_up_down_sel ;
    rand bit    [`ROW_ADDR_WIDTH-1:0]                   radd_i_sel      ;
    rand bit    [`COL_ADDR_WIDTH-1:0]                   cadd_i_sel      ;
    bit         [2:0]                   vmc_csl_addr_up_size,vmc_csl_addr_down_size;
    rand bit                            up_down_sel     ;
    bit         [7:0]                  apb_wdata;
    bit         [7:0]                  apb_wdata1,apb_wdata2,apb_wdata3;
    bit         [31:0]                  read_data=0;
    bit         [31:0]                  tmp_wl0=0;
    bit         [31:0]                  tmp_wl1=0;
    bit         [31:0]                  tmp_csl0=0;
    bit         [31:0]                  tmp_csl1=0;
    bit         [31:0]                  tmp_csl2=0;
    bit         [31:0]                  tmp_csl3=0;

    rand bit    [6:0]                   threshold1;
    rand bit    [6:0]                   threshold2;
    bit                                 dram_init_finish=0;
    bit   [`ROW_ADDR_WIDTH-1:0]   vmc_wl_addr_copy;
    constraint vmc_wl_cnt_c {vmc_wl_cnt inside {[1:64]};}
    constraint vmc_csl_addr_c {vmc_csl_addr inside {[0:129]};}
    constraint vmc_csl_addr_1_c {vmc_csl_addr_1 inside {[0:129]};}
    constraint vmc_csl_addr_2_c {vmc_csl_addr_2 inside {[0:129]};}
    constraint vmc_csl_addr_3_c {vmc_csl_addr_3 inside {[0:129]};}
    constraint vmc_csl_addr_4_c {vmc_csl_addr_4 inside {[0:129]};}
    constraint vmc_csl_addr_5_c {vmc_csl_addr_5 inside {[0:129]};}
    constraint vmc_csl_addr_6_c {vmc_csl_addr_6 inside {[0:129]};}
    constraint vmc_csl_addr_7_c {vmc_csl_addr_7 inside {[0:129]};}
    constraint vmc_csl_addr_8_c {vmc_csl_addr_8 inside {[0:129]};}
    constraint vmc_csl_addr_9_c {vmc_csl_addr_9 inside {[0:129]};}

    constraint threshold_c {threshold1 inside {[1:64]};}
    constraint radd_seed_c {radd_seed dist {[0:500]:/95,[501:7295]:/5};}
    constraint num_seed_c {num_seed dist {[1:1000]:/99,[1001:7360]:/1};}
    constraint threshold_c1 {threshold2 inside {[1:64]};}
    //constraint threshold_c2 {threshold1 < threshold2;threshold2 < vmc_wl_cnt;}
    constraint threshold_c2 {
        threshold1 dist {[1:63]:/80,64:/20};
        threshold1 <= vmc_wl_cnt;}
    mc_frame_seq_cfg    m_frame_seq_wr_q[$];
    
    `uvm_object_utils(mc_vmc_vseq)

    function new(string name="mc_vmc_vseq");
        super.new(name);
    endfunction

virtual task body();
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    super.body();
    repeat(10) @(posedge m_tb_if.pclk);
    m_tb_if.page_mode_switch = $urandom_range(0,1);

    #1us;
    assert(randomize(threshold1,threshold2,vmc_wl_cnt));
    base_addr = 0;
    `uvm_info(get_type_name(),$sformatf("threshold1 =%0d,threshold2 =%0d,vmc_wl_cnt =%0d",threshold1,threshold2,vmc_wl_cnt),UVM_LOW);
    //********cfg_mc_vmc_wl_num**********
    for(int j=0;j<vmc_wl_cnt;j++)begin
        //randomize(vmc_wl_addr) with {vmc_wl_addr inside {[0:14655]};};
        randomize(vmc_wl_addr) with {vmc_wl_addr inside {[0:7295]};foreach(vmc_wl_addr_q[i]) vmc_wl_addr != vmc_wl_addr_q[i];};
        //vmc_wl_addr= j;
        `uvm_info(get_type_name(),$sformatf("vmc_wl_addr =%0h ",vmc_wl_addr),UVM_LOW);
        vmc_wl_addr_q.push_back(vmc_wl_addr);
    end
    if(vmc_wl_cnt<64)begin
        for(int i=vmc_wl_cnt;i<64;i++)begin
            vmc_wl_addr_q.push_back(13'h1fff);
        end
    end
    foreach(vmc_wl_addr_q[i])begin
        automatic bit[`ROW_ADDR_WIDTH-1:0] temp[$] = vmc_wl_addr_q;
        temp.sort();
        vmc_wl_addr_q = temp;
    end
    for(int j=0;j<threshold1;j++)begin
        //if(threshold1%2==0)begin
            if(j%2==0)begin
                apb_wdata = vmc_wl_addr_q.pop_front();
                `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h ",apb_wdata),UVM_LOW);
                tmp_wl0=apb_wdata-j;
                offset_addr_send(32'h1c+j/2*32'h4,32'h144+j/2*32'h4,32'h26c+j/2*32'h4,32'h394+j/2*32'h4,({6'b0,13'h1fff,tmp_wl0[12:0]}));
            end
            else begin
                apb_wdata = vmc_wl_addr_q.pop_front();
                `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h ",apb_wdata),UVM_LOW);
                tmp_wl1=apb_wdata-j;
                offset_addr_send(32'h1c+j/2*32'h4,32'h144+j/2*32'h4,32'h26c+j/2*32'h4,32'h394+j/2*32'h4,({6'b0,tmp_wl1[12:0],tmp_wl0[12:0]}));
            end
        //end
        //else begin
        //    if(j<threshold1-1)begin
        //        if(j%2==0)begin
        //            apb_wdata = vmc_wl_addr_q.pop_front();
        //            `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h ",apb_wdata),UVM_LOW);
        //            offset_addr =  32'h1c  +  j/2*32'h4;
        //            tmp_wl0=apb_wdata-j;
        //            apb_write('b1,base_addr,offset_addr,({6'b0,13'h1fff,tmp_wl0[12:0]}));
        //        end
        //        else begin
        //            apb_wdata = vmc_wl_addr_q.pop_front();
        //            `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h ",apb_wdata),UVM_LOW);
        //            offset_addr =  32'h1c  +  (j-1)/2*32'h4;
        //            tmp_wl1=apb_wdata-j;
        //            apb_write('b1,base_addr,offset_addr,({6'b0,tmp_wl1[12:0],tmp_wl0[12:0]}));
        //        end
        //    end
        //    else begin
        //        apb_wdata = vmc_wl_addr_q.pop_front();
        //        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h ",apb_wdata),UVM_LOW);
        //        offset_addr =  32'h1c  +  j/2*32'h4;
        //        tmp_wl0=apb_wdata-j;
        //        apb_write('b1,base_addr,offset_addr,{{6'b0,13'h1fff,tmp_wl0[12:0]}});
        //    end
        //end
    end  
    randomize(vmc_csl_cnt) with {vmc_csl_cnt dist {1:/50,2:/50};};
    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
    if(vmc_csl_cnt==2)begin
        //********cfg_mc_vmc_bl_num_part0**********
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr) with {vmc_csl_addr inside {[0:129]};});
            vmc_csl_addr_part0_q.push_back(vmc_csl_addr);                
        end
        foreach(vmc_csl_addr_part0_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part0_q;
            temp.sort();
            vmc_csl_addr_part0_q = temp;
        end
        apb_wdata =vmc_csl_addr_part0_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("vmc_csl_addr =%0h,apb_wdata =%0h ",vmc_csl_addr,apb_wdata),UVM_LOW);
        apb_wdata1 =vmc_csl_addr_part0_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("vmc_csl_addr =%0h,apb_wdata1 =%0h ",vmc_csl_addr,apb_wdata1),UVM_LOW);

        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num0_part0_bank0.write(status,apb_wdata,UVM_FRONTDOOR);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_bank0_reg.mc_vmc_bl_num1_part0_bank0.write(status,apb_wdata1-1,UVM_FRONTDOOR);
        
        //********cfg_mc_vmc_bl_num_part1**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_1) with {vmc_csl_addr_1 inside {[0:129]};});
            vmc_csl_addr_part1_q.push_back(vmc_csl_addr_1);                
        end    
        foreach(vmc_csl_addr_part1_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part1_q;
            temp.sort();
            vmc_csl_addr_part1_q = temp;
        end
        apb_wdata2 =vmc_csl_addr_part1_q.pop_front();
        apb_wdata3 =vmc_csl_addr_part1_q.pop_front();
        offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{apb_wdata3-1,apb_wdata2,apb_wdata1-1,apb_wdata});

        //********cfg_mc_vmc_bl_num_part2**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_2) with {vmc_csl_addr_2 inside {[0:129]};});
            vmc_csl_addr_part2_q.push_back(vmc_csl_addr_2);                
        end    
        foreach(vmc_csl_addr_part2_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part2_q;
            temp.sort();
            vmc_csl_addr_part2_q = temp;
        end
        apb_wdata =vmc_csl_addr_part2_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_reg.mc_vmc_bl_num0_part2.write(status,apb_wdata,UVM_FRONTDOOR);
        apb_wdata1 =vmc_csl_addr_part2_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata1 =%0h",apb_wdata1),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_reg.mc_vmc_bl_num1_part2.write(status,apb_wdata1-1,UVM_FRONTDOOR);

        //********cfg_mc_vmc_bl_num_part3**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_3) with {vmc_csl_addr_3 inside {[0:129]};});
            vmc_csl_addr_part3_q.push_back(vmc_csl_addr_3);                
        end    
        foreach(vmc_csl_addr_part3_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part3_q;
            temp.sort();
            vmc_csl_addr_part3_q = temp;
        end
        apb_wdata2 =vmc_csl_addr_part3_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_reg.mc_vmc_bl_num0_part3.write(status,apb_wdata,UVM_FRONTDOOR);
        apb_wdata3 =vmc_csl_addr_part3_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata1 =%0h",apb_wdata1),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_reg.mc_vmc_bl_num1_part3.write(status,apb_wdata1-1,UVM_FRONTDOOR);
        offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{apb_wdata3-1,apb_wdata2,apb_wdata1-1,apb_wdata});

        //********cfg_mc_vmc_bl_num_part4**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_4) with {vmc_csl_addr_4 inside {[0:129]};});
            vmc_csl_addr_part4_q.push_back(vmc_csl_addr_4);                
        end    
        foreach(vmc_csl_addr_part4_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part4_q;
            temp.sort();
            vmc_csl_addr_part4_q = temp;
        end
        apb_wdata =vmc_csl_addr_part4_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_reg.mc_vmc_bl_num0_part4.write(status,apb_wdata,UVM_FRONTDOOR);
        apb_wdata1 =vmc_csl_addr_part4_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata1 =%0h",apb_wdata1),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_reg.mc_vmc_bl_num1_part4.write(status,apb_wdata1-1,UVM_FRONTDOOR);

        //********cfg_mc_vmc_bl_num_part5**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_5) with {vmc_csl_addr_5 inside {[0:129]};});
            vmc_csl_addr_part5_q.push_back(vmc_csl_addr_5);                
        end    
        foreach(vmc_csl_addr_part5_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part5_q;
            temp.sort();
            vmc_csl_addr_part5_q = temp;
        end
        apb_wdata2 =vmc_csl_addr_part5_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_reg.mc_vmc_bl_num0_part5.write(status,apb_wdata,UVM_FRONTDOOR);
        apb_wdata3 =vmc_csl_addr_part5_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata1 =%0h",apb_wdata1),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_reg.mc_vmc_bl_num1_part5.write(status,apb_wdata1-1,UVM_FRONTDOOR);
        offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{apb_wdata3-1,apb_wdata2,apb_wdata1-1,apb_wdata});

        //********cfg_mc_vmc_bl_num_part6**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_6) with {vmc_csl_addr_6 inside {[0:129]};});
            vmc_csl_addr_part6_q.push_back(vmc_csl_addr_6);                
        end    
        foreach(vmc_csl_addr_part6_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part6_q;
            temp.sort();
            vmc_csl_addr_part6_q = temp;
        end
        apb_wdata =vmc_csl_addr_part6_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_reg.mc_vmc_bl_num0_part6.write(status,apb_wdata,UVM_FRONTDOOR);
        apb_wdata1 =vmc_csl_addr_part6_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata1 =%0h",apb_wdata1),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_reg.mc_vmc_bl_num1_part6.write(status,apb_wdata1-1,UVM_FRONTDOOR);

        //********cfg_mc_vmc_bl_num_part7**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_7) with {vmc_csl_addr_7 inside {[0:129]};});
            vmc_csl_addr_part7_q.push_back(vmc_csl_addr_7);                
        end    
        foreach(vmc_csl_addr_part7_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part7_q;
            temp.sort();
            vmc_csl_addr_part7_q = temp;
        end
        apb_wdata2 =vmc_csl_addr_part7_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_reg.mc_vmc_bl_num0_part7.write(status,apb_wdata,UVM_FRONTDOOR);
        apb_wdata3 =vmc_csl_addr_part7_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata1 =%0h",apb_wdata1),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_reg.mc_vmc_bl_num1_part7.write(status,apb_wdata1-1,UVM_FRONTDOOR);
        offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{apb_wdata3-1,apb_wdata2,apb_wdata1-1,apb_wdata});

        //********cfg_mc_vmc_bl_num_part8**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_8) with {vmc_csl_addr_8 inside {[0:129]};});
            vmc_csl_addr_part8_q.push_back(vmc_csl_addr_8);                
        end    
        foreach(vmc_csl_addr_part8_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part8_q;
            temp.sort();
            vmc_csl_addr_part8_q = temp;
        end
        apb_wdata =vmc_csl_addr_part8_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_reg.mc_vmc_bl_num0_part8.write(status,apb_wdata,UVM_FRONTDOOR);
        apb_wdata1 =vmc_csl_addr_part8_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata1 =%0h",apb_wdata1),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_reg.mc_vmc_bl_num1_part8.write(status,apb_wdata1-1,UVM_FRONTDOOR);

        //********cfg_mc_vmc_bl_num_part9**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_9) with {vmc_csl_addr_9 inside {[0:129]};});
            vmc_csl_addr_part9_q.push_back(vmc_csl_addr_9);                
        end    
        foreach(vmc_csl_addr_part9_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part9_q;
            temp.sort();
            vmc_csl_addr_part9_q = temp;
        end
        apb_wdata =vmc_csl_addr_part9_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_reg.mc_vmc_bl_num0_part9.write(status,apb_wdata,UVM_FRONTDOOR);
        apb_wdata1 =vmc_csl_addr_part9_q.pop_front();
        `uvm_info(get_type_name(),$sformatf("apb_wdata1 =%0h",apb_wdata1),UVM_LOW);
        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_reg.mc_vmc_bl_num1_part9.write(status,apb_wdata1-1,UVM_FRONTDOOR);
        offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{apb_wdata3-1,apb_wdata2,apb_wdata1-1,apb_wdata});
    end
    else begin
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr) with {vmc_csl_addr inside {[0:128]};});
            vmc_csl_addr_part0_q.push_back(vmc_csl_addr);                
            vmc_csl_addr_copy_q.push_back(vmc_csl_addr);                
        end
        foreach(vmc_csl_addr_part0_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part0_q;
            temp.sort();
            vmc_csl_addr_part0_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata =vmc_csl_addr_part0_q.pop_front();
            //`uvm_info(get_type_name(),$sformatf("vmc_csl_addr =%0h,apb_wdata =%0h ",vmc_csl_addr,apb_wdata),UVM_LOW);
            //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_reg.mc_vmc_bl_num0_part0.write(status,apb_wdata,UVM_FRONTDOOR);
        end

        //********cfg_mc_vmc_bl_num_part1**********
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_1) with {vmc_csl_addr_1 inside {[0:128]};});
            vmc_csl_addr_part1_q.push_back(vmc_csl_addr_1);                
            vmc_csl_addr_copy_q.push_back(vmc_csl_addr_1);                
        end    
        foreach(vmc_csl_addr_part1_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part1_q;
            temp.sort();
            vmc_csl_addr_part1_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata2 =vmc_csl_addr_part1_q.pop_front();
            //`uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
            //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_reg.mc_vmc_bl_num0_part1.write(status,apb_wdata,UVM_FRONTDOOR);
        end
        offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{8'hff,apb_wdata2,8'hff,apb_wdata});
        //********cfg_mc_vmc_bl_num_part2**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_2) with {vmc_csl_addr_2 inside {[0:128]};});
            vmc_csl_addr_part2_q.push_back(vmc_csl_addr_2);                
            vmc_csl_addr_copy_q.push_back(vmc_csl_addr_2);                
        end    
        foreach(vmc_csl_addr_part2_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part2_q;
            temp.sort();
            vmc_csl_addr_part2_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata =vmc_csl_addr_part2_q.pop_front();
            //`uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
            //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_reg.mc_vmc_bl_num0_part2.write(status,apb_wdata,UVM_FRONTDOOR);
        end

        //********cfg_mc_vmc_bl_num_part3**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_3) with {vmc_csl_addr_3 inside {[0:128]};});
            vmc_csl_addr_part3_q.push_back(vmc_csl_addr_3);                
            vmc_csl_addr_copy_q.push_back(vmc_csl_addr_3);                
        end    
        foreach(vmc_csl_addr_part3_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part3_q;
            temp.sort();
            vmc_csl_addr_part3_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata2 =vmc_csl_addr_part3_q.pop_front();
            //`uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
            //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_reg.mc_vmc_bl_num0_part3.write(status,apb_wdata,UVM_FRONTDOOR);
        end
        offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{8'hff,apb_wdata2,8'hff,apb_wdata});

        //********cfg_mc_vmc_bl_num_part4**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_4) with {vmc_csl_addr_4 inside {[0:128]};});
            vmc_csl_addr_part4_q.push_back(vmc_csl_addr_4);                
            vmc_csl_addr_copy_q.push_back(vmc_csl_addr_4);                
        end    
        foreach(vmc_csl_addr_part4_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part4_q;
            temp.sort();
            vmc_csl_addr_part4_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata =vmc_csl_addr_part4_q.pop_front();
            //`uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
            //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_reg.mc_vmc_bl_num0_part4.write(status,apb_wdata,UVM_FRONTDOOR);
        end

        //********cfg_mc_vmc_bl_num_part5**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_5) with {vmc_csl_addr_5 inside {[0:128]};});
            vmc_csl_addr_part5_q.push_back(vmc_csl_addr_5);                
            vmc_csl_addr_copy_q.push_back(vmc_csl_addr_5);                
        end    
        foreach(vmc_csl_addr_part5_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part5_q;
            temp.sort();
            vmc_csl_addr_part5_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata2 =vmc_csl_addr_part5_q.pop_front();
            //`uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
            //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_reg.mc_vmc_bl_num0_part5.write(status,apb_wdata,UVM_FRONTDOOR);
        end
        offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{8'hff,apb_wdata2,8'hff,apb_wdata});

        //********cfg_mc_vmc_bl_num_part6**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_6) with {vmc_csl_addr_6 inside {[0:128]};});
            vmc_csl_addr_part6_q.push_back(vmc_csl_addr_6);                
            vmc_csl_addr_copy_q.push_back(vmc_csl_addr_6);                
        end    
        foreach(vmc_csl_addr_part6_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part6_q;
            temp.sort();
            vmc_csl_addr_part6_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata =vmc_csl_addr_part6_q.pop_front();
            //`uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
            //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_reg.mc_vmc_bl_num0_part6.write(status,apb_wdata,UVM_FRONTDOOR);
        end

        //********cfg_mc_vmc_bl_num_part7**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_7) with {vmc_csl_addr_7 inside {[0:128]};});
            vmc_csl_addr_part7_q.push_back(vmc_csl_addr_7);                
            vmc_csl_addr_copy_q.push_back(vmc_csl_addr_7);                
        end    
        foreach(vmc_csl_addr_part7_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part7_q;
            temp.sort();
            vmc_csl_addr_part7_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata2 =vmc_csl_addr_part7_q.pop_front();
            //`uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
            //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_reg.mc_vmc_bl_num0_part7.write(status,apb_wdata,UVM_FRONTDOOR);
        end
        offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{8'hff,apb_wdata2,8'hff,apb_wdata});

        //********cfg_mc_vmc_bl_num_part8**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_8) with {vmc_csl_addr_8 inside {[0:128]};});
            vmc_csl_addr_part8_q.push_back(vmc_csl_addr_8);                
            vmc_csl_addr_copy_q.push_back(vmc_csl_addr_8);                
        end    
        foreach(vmc_csl_addr_part8_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part8_q;
            temp.sort();
            vmc_csl_addr_part8_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata =vmc_csl_addr_part8_q.pop_front();
            //`uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
            //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_reg.mc_vmc_bl_num0_part8.write(status,apb_wdata,UVM_FRONTDOOR);
        end

        //********cfg_mc_vmc_bl_num_part9**********
        `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
        for(int k=0;k<vmc_csl_cnt;k++)begin
            assert(randomize(vmc_csl_addr_9) with {vmc_csl_addr_9 inside {[0:128]};});
            vmc_csl_addr_part9_q.push_back(vmc_csl_addr_9);                
            vmc_csl_addr_copy_q.push_back(vmc_csl_addr_9);                
        end    
        foreach(vmc_csl_addr_part9_q[i])begin
            automatic bit[`COLUMN_ADDR_WIDTH-1:0] temp[$] = vmc_csl_addr_part9_q;
            temp.sort();
            vmc_csl_addr_part9_q = temp;
        end
        for(int k=0;k<vmc_csl_cnt;k++)begin
            apb_wdata2 =vmc_csl_addr_part9_q.pop_front();
            //`uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
            //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_reg.mc_vmc_bl_num0_part9.write(status,apb_wdata,UVM_FRONTDOOR);
        end
        offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{8'hff,apb_wdata2,8'hff,apb_wdata});

    end
    //m_tb_if.wl_vmc_en=1;
    //m_tb_if.bl_vmc_en=1;
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_wl_vmc_en.write(status,1'b1, UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_bl_vmc_en.write(status,1'b1, UVM_FRONTDOOR);
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_en.write(status,1'b1, UVM_FRONTDOOR);

    repeat(20) @(posedge m_tb_if.clk);
    
    randomize(burst_cnt_i) with {burst_cnt_i inside {[1:500]};};           
    for(int i=0;i<burst_cnt_i;i++)begin
        //randomize(radd_i) with {radd_i inside{[0:14655]};};
        randomize(radd_i) with {radd_i inside{[0:7295]};};
        randomize(cadd_i) with {cadd_i inside{[0:127]};};
        assert(m_frame_cfg.randomize with {
            radd                == radd_i;
            cadd                == cadd_i; 
        });
        `uvm_info(get_full_name(),$sformatf("test cfg :  m_frame_cfg = %s\n",m_frame_cfg.sprint()),UVM_LOW);
        m_frame_seq_wr_q.push_back(m_frame_cfg);
        m_frame_cfg = mc_frame_seq_cfg::type_id::create("m_frame_cfg");
    end
    
    send_multi_frame(m_frame_seq_wr_q);
    assert(m_frame_cfg.randomize with {
        cadd                == 0;
        radd                == 0;
        frame_rw_flag       == 1;   //1:wr 0:rd
        one_frame_cnt       == 'd128;
        col_addr_rand_en    == 0;
        wrap_en             == 0;
        strb_rand_en        == 0;
        strb                == 1;
    });
    send_one_frame(m_frame_cfg);   
    assert(m_frame_cfg.randomize with {
        cadd                == 0;
        radd                == 0;
        frame_rw_flag       == 0;   //1:wr 0:rd
        one_frame_cnt       == 'd128;
        col_addr_rand_en    == 0;
        wrap_en             == 0;
        strb_rand_en        == 0;
        strb                == 1;
    });
    send_one_frame(m_frame_cfg);  
    #1us;
    if(threshold1 !== 64)begin
        fork
            begin
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_wl_vmc_en.write(status,1'b0, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_bl_vmc_en.write(status,1'b0, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_en.write(status,1'b0, UVM_FRONTDOOR);

                repeat(10) @(posedge m_tb_if.clk);
                for(int j=threshold1;j<64;j++)begin
                    //if(threshold1%2==0)begin
                        if(j%2==0)begin
                            apb_wdata = vmc_wl_addr_q.pop_front();
                            `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h ",apb_wdata),UVM_LOW);
                            offset_addr =  32'h1c  +  j/2*32'h4;
                            tmp_wl0=apb_wdata-j;
                            apb_write('b1,base_addr,offset_addr,{6'b0,13'h1fff,tmp_wl0[12:0]});
                        end
                        else begin
                            apb_wdata = vmc_wl_addr_q.pop_front();
                            `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h ",apb_wdata),UVM_LOW);
                            offset_addr =  32'h1c  +  (j-1)/2*32'h4;
                            tmp_wl1=apb_wdata-j;
                            apb_write('b1,base_addr,offset_addr,({6'b0,tmp_wl1[12:0],tmp_wl0[12:0]}));
                        end
                    //end
                    //else begin
                    //    if(j==threshold1)begin
                    //        apb_wdata = vmc_wl_addr_q.pop_front();
                    //        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h ",apb_wdata),UVM_LOW);
                    //        offset_addr =  32'h1c  +  (j-1)/2*32'h4;
                    //        tmp_wl1=apb_wdata-j;
                    //        apb_write('b1,base_addr,offset_addr,({6'b0,tmp_wl1[12:0],tmp_wl0[12:0]}));
                    //    end
                    //    else begin
                    //        if(j%2==0)begin
                    //            apb_wdata = vmc_wl_addr_q.pop_front();
                    //            `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h ",apb_wdata),UVM_LOW);
                    //            offset_addr =  32'h1c  +  j/2*32'h4;
                    //            tmp_wl0=apb_wdata-j;
                    //            apb_write('b1,base_addr,offset_addr,{6'b0,13'h1fff,tmp_wl0[12:0]});
                    //        end
                    //        else begin
                    //            apb_wdata = vmc_wl_addr_q.pop_front();
                    //            `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h ",apb_wdata),UVM_LOW);
                    //            offset_addr =  32'h1c  +  (j-1)/2*32'h4;
                    //            tmp_wl1=apb_wdata-j;
                    //            apb_write('b1,base_addr,offset_addr,({6'b0,tmp_wl1[12:0],tmp_wl0[12:0]}));
                    //        end
                    //    end
                    //end
                end
                if(vmc_csl_cnt==1)begin
                    for(int k=0;k<vmc_csl_cnt;k++)begin
                        randomize(vmc_csl_addr) with {vmc_csl_addr>vmc_csl_addr_copy_q[0];};
                        apb_wdata =vmc_csl_addr;
                        `uvm_info(get_type_name(),$sformatf("vmc_csl_addr =%0h,apb_wdata =%0h ",vmc_csl_addr,apb_wdata),UVM_LOW);
                        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_reg.mc_vmc_bl_num0_part0.write(status,apb_wdata,UVM_FRONTDOOR);
                    end
                    //********cfg_mc_vmc_bl_num_part1**********
                    for(int k=0;k<vmc_csl_cnt;k++)begin
                        randomize(vmc_csl_addr_1) with {vmc_csl_addr_1>vmc_csl_addr_copy_q[1];};
                        apb_wdata2 =vmc_csl_addr_1;
                        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
                        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part0_1_reg.mc_vmc_bl_num0_part1.write(status,apb_wdata,UVM_FRONTDOOR);
                    end
                    offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{8'hff,apb_wdata2,8'hff,apb_wdata});

                    //********cfg_mc_vmc_bl_num_part2**********
                    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
                    for(int k=0;k<vmc_csl_cnt;k++)begin
                        randomize(vmc_csl_addr_2) with {vmc_csl_addr_2>vmc_csl_addr_copy_q[2];};
                        apb_wdata =vmc_csl_addr_2;
                        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
                        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_reg.mc_vmc_bl_num0_part2.write(status,apb_wdata,UVM_FRONTDOOR);
                    end
                    //********cfg_mc_vmc_bl_num_part3**********
                    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
                    for(int k=0;k<vmc_csl_cnt;k++)begin
                        randomize(vmc_csl_addr_3) with {vmc_csl_addr_3>vmc_csl_addr_copy_q[3];};
                        apb_wdata2 =vmc_csl_addr_3;
                        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
                        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part2_3_reg.mc_vmc_bl_num0_part3.write(status,apb_wdata,UVM_FRONTDOOR);
                    end
                    offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{8'hff,apb_wdata2,8'hff,apb_wdata});

                    //********cfg_mc_vmc_bl_num_part4**********
                    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
                    for(int k=0;k<vmc_csl_cnt;k++)begin
                        randomize(vmc_csl_addr_4) with {vmc_csl_addr_4>vmc_csl_addr_copy_q[4];};
                        apb_wdata =vmc_csl_addr_4;
                        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
                        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_reg.mc_vmc_bl_num0_part4.write(status,apb_wdata,UVM_FRONTDOOR);
                    end

                    //********cfg_mc_vmc_bl_num_part5**********
                    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
                    for(int k=0;k<vmc_csl_cnt;k++)begin
                        randomize(vmc_csl_addr_5) with {vmc_csl_addr_5>vmc_csl_addr_copy_q[5];};
                        apb_wdata2 =vmc_csl_addr_5;
                        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
                        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part4_5_reg.mc_vmc_bl_num0_part5.write(status,apb_wdata,UVM_FRONTDOOR);
                    end
                    offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{8'hff,apb_wdata2,8'hff,apb_wdata});

                    //********cfg_mc_vmc_bl_num_part6**********
                    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
                    for(int k=0;k<vmc_csl_cnt;k++)begin
                        randomize(vmc_csl_addr_6) with {vmc_csl_addr_6>vmc_csl_addr_copy_q[6];};
                        apb_wdata =vmc_csl_addr_6;
                        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
                        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_reg.mc_vmc_bl_num0_part6.write(status,apb_wdata,UVM_FRONTDOOR);
                    end

                    //********cfg_mc_vmc_bl_num_part7**********
                    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
                    for(int k=0;k<vmc_csl_cnt;k++)begin
                        randomize(vmc_csl_addr_7) with {vmc_csl_addr_7>vmc_csl_addr_copy_q[7];};
                        apb_wdata2 =vmc_csl_addr_7;
                        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
                        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part6_7_reg.mc_vmc_bl_num0_part7.write(status,apb_wdata,UVM_FRONTDOOR);
                    end
                    offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{8'hff,apb_wdata2,8'hff,apb_wdata});

                    //********cfg_mc_vmc_bl_num_part8**********
                    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
                    for(int k=0;k<vmc_csl_cnt;k++)begin
                        randomize(vmc_csl_addr_8) with {vmc_csl_addr_8>vmc_csl_addr_copy_q[8];};
                        apb_wdata =vmc_csl_addr_8;
                        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
                        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_reg.mc_vmc_bl_num0_part8.write(status,apb_wdata,UVM_FRONTDOOR);
                    end

                    //********cfg_mc_vmc_bl_num_part9**********
                    `uvm_info(get_type_name(),$sformatf("vmc_csl_cnt=%0d",vmc_csl_cnt),UVM_LOW);
                    for(int k=0;k<vmc_csl_cnt;k++)begin
                        randomize(vmc_csl_addr_9) with {vmc_csl_addr_9>vmc_csl_addr_copy_q[9];};
                        apb_wdata2 =vmc_csl_addr_9;
                        `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
                        //p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_vmc_bl_num0_part8_9_reg.mc_vmc_bl_num0_part9.write(status,apb_wdata,UVM_FRONTDOOR);
                    end
                    offset_addr_send(32'h9c,32'h1c4,32'h2ec,32'h414,{8'hff,apb_wdata2,8'hff,apb_wdata});
                end

                //if(vmc_csl_cnt==1)begin
                //    assert(randomize(vmc_csl_addr_second)with{vmc_csl_addr_second>vmc_csl_addr;});
                //    apb_wdata = vmc_csl_addr_second;
                //    `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
                //    offset_addr = 32'h11c + 'h4;
                //    apb_write('b1,base_addr,offset_addr,apb_wdata);
                //    assert(randomize(vmc_csl_addr_1_second)with{vmc_csl_addr_1_second>vmc_csl_addr_1;});
                //    apb_wdata = vmc_csl_addr_1_second;
                //    `uvm_info(get_type_name(),$sformatf("apb_wdata =%0h",apb_wdata),UVM_LOW);
                //    offset_addr = 32'h124 + 'h4;
                //    apb_write('b1,base_addr,offset_addr,apb_wdata);
                //end

                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_wl_vmc_en.write(status,1'b1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_bl_vmc_en.write(status,1'b1, UVM_FRONTDOOR);
                p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_en.write(status,1'b1, UVM_FRONTDOOR);
                wait(m_tb_if.mc_dram_init_wr_finish==1);

                repeat(10) @(posedge m_tb_if.clk);
            end
            begin
                read_data=0;
                while(read_data==0)begin
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_wl_vmc_en.read(status,read_data, UVM_FRONTDOOR);
                end
                read_data=0;
                while(read_data==0)begin
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_bl_vmc_en.read(status,read_data, UVM_FRONTDOOR);
                end
                read_data=0;
                while(read_data==0)begin
                    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.mc_work_ctrl_reg.mc_en.read(status,read_data, UVM_FRONTDOOR);
                end
                assert(randomize(num_seed));
                `uvm_info(get_type_name(),$sformatf("num_seed =%0d ",num_seed),UVM_LOW);
                for(int i=0;i<num_seed;i++)begin
                    `uvm_info(get_type_name(),$sformatf("i =%0d ",i),UVM_LOW);
                    assert(randomize(radd_seed));
                    assert(m_frame_cfg.randomize with {
                        cadd                == 0;
                        radd                == radd_seed;
                        frame_rw_flag       == 1;   //1:wr 0:rd
                        one_frame_cnt       == 'd128;
                        col_addr_rand_en    == 0;
                        wrap_en             == 0;
                        strb_rand_en        == 0;
                        strb                == 1;
                    });
                    send_one_frame(m_frame_cfg);        
                    assert(randomize(radd_seed));
                    assert(m_frame_cfg.randomize with {
                        cadd                == 0;
                        radd                == radd_seed;
                        frame_rw_flag       == 0;   //1:wr 0:rd
                        one_frame_cnt       == 'd128;
                        col_addr_rand_en    == 0;
                        wrap_en             == 0;

                    });
                    send_one_frame(m_frame_cfg);        
                end
                #1us;
            end
        join
    end
endtask

virtual task offset_addr_send(input bit [31:0] offset_addr0,input bit [31:0] offset_addr1,input bit [31:0] offset_addr2,input bit [31:0] offset_addr3,input bit [31:0] wdata);
    
    `ifdef TEST_1_SHOT_1
        offset_addr = offset_addr0;
        apb_write('b1,base_addr,offset_addr,wdata);
    `elsif TEST_1_SHOT_2
        offset_addr = offset_addr0;
        apb_write('b1,base_addr,offset_addr,wdata);
        offset_addr =  offset_addr1;
        apb_write('b1,base_addr,offset_addr,wdata);
    `elsif TEST_1_SHOT_3
        offset_addr = offset_addr0;
        apb_write('b1,base_addr,offset_addr,wdata);
        offset_addr = offset_addr1;
        apb_write('b1,base_addr,offset_addr,wdata);
        offset_addr = offset_addr2;
        apb_write('b1,base_addr,offset_addr,wdata);
    `elsif TEST_1_SHOT_4
        offset_addr = offset_addr0 ;
        apb_write('b1,base_addr,offset_addr,wdata);
        offset_addr = offset_addr1 ;
        apb_write('b1,base_addr,offset_addr,wdata);
        offset_addr = offset_addr2 ;
        apb_write('b1,base_addr,offset_addr,wdata);
        offset_addr = offset_addr3 ;
        apb_write('b1,base_addr,offset_addr,wdata);
    `else
        offset_addr = offset_addr0 ;
        apb_write('b1,base_addr,offset_addr,wdata);
        offset_addr = offset_addr1 ;
        apb_write('b1,base_addr,offset_addr,wdata);
        offset_addr = offset_addr2 ;
        apb_write('b1,base_addr,offset_addr,wdata);
    `endif
endtask

endclass
`endif
