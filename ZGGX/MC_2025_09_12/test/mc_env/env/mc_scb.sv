
`ifndef MC_SCB_SV
`define MC_SCB_SV

class mc_scb extends uvm_component;
    virtual tb_if vif_tb;
    virtual frame_agent_if  m_frame_agent_if;
    virtual array_agent_if  m_array_agent_if;
    `uvm_component_utils(mc_scb)
    int cmp_t;
    uvm_blocking_get_port #(frame_agent_trans)  frm_act_port_w;
    uvm_blocking_get_port #(frame_agent_trans)  frm_act_port_r;
    uvm_blocking_get_port #(array_agent_trans)  array_act_port;
    
    logic   [2:0]                                           frame_wr_banksel_q[$], frame_rd_banksel_q[$];
    logic   [`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-2:0]        frame_wr_addr_q[$],frame_rd_addr_q[$];
    logic   [`ARRAY_DATA_WIDTH-1:0]                         frame_wr_data_q[$];
    logic   [5:0]                                           arb_check_port_choose_q[$];
    //logic   [`ARRAY_DATA_WIDTH-1:0]                         arb_check_rdata_q[$];
    

    extern function new(string name, uvm_component parent);
    extern task main_phase(uvm_phase phase);
    extern task reset_phase(uvm_phase phase);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);

    extern function bit [5:0] cal_round_robin(bit [5:0] now_grant, bit [5:0] now_valid_in);
    extern task arb_pointer_check();
    extern task arb_handshake_check();
    //extern task arb_wr_check(bit [5:0] port_choose);
    //extern task arb_rd_check(bit [5:0] port_choose);
    extern task arb_rdata_check();
    extern task fake_wr_refresh_addr_chk();
endclass : mc_scb 

function mc_scb::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

task mc_scb::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info("mc_scb", "mc_scb_reset_phase_start!!!", UVM_LOW);    
    phase.raise_objection(this);
    frame_wr_banksel_q.delete();
    frame_rd_banksel_q.delete();
    frame_wr_addr_q.delete();
    frame_wr_data_q.delete();
    frame_rd_addr_q.delete();
    arb_check_port_choose_q.delete();
    `uvm_info("mc_scb", "mc_scb_reset_phase_end!!!", UVM_LOW); 
    //@(posedge m_xocc_if.all_rstn_and)
    phase.drop_objection(this);
endtask : reset_phase
    


function void mc_scb::build_phase(uvm_phase phase);
    cmp_t = 0;
    frm_act_port_w = new("frm_act_port_w",this);
    frm_act_port_r = new("frm_act_port_r",this);
    array_act_port = new("array_act_port",this);
endfunction

function void mc_scb::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

   //if (!uvm_config_db #(virtual noc_frame_if)::get(this, "*", "vif_noc", vif_noc))
      //`uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),"uvm_test_top.m_env.m_scb.vif_noc"})
    if(!uvm_config_db#(virtual tb_if)::get(this, "", "vif_tb", vif_tb))
        `uvm_error("NOVIF", {"virtual interface must be set for:", get_full_name(), ".vif_tb"})
    if(!uvm_config_db#(virtual frame_agent_if)::get(this, "", "frame_agent_vif", m_frame_agent_if))
        `uvm_error("NOVIF", {"virtual interface must be set for:", get_full_name(), ".m_frame_agent_if"})
    if(!uvm_config_db#(virtual array_agent_if)::get(this, "", "array_agent_vif", m_array_agent_if))
        `uvm_error("NOVIF", {"virtual interface must be set for:", get_full_name(), ".m_array_agent_if"})

endfunction : connect_phase

task mc_scb::main_phase(uvm_phase phase);
//    array_agent_trans                                       wr_array_tran[$];
//    array_agent_trans                                       rd_array_tran[$];
    frame_agent_trans                                       frame_wr_tran;
    frame_agent_trans                                       frame_rd_tran;
    `ifndef BIST_SIM
        localparam                                              BIST_WL_NUM=7360;
    `else
        localparam                                              BIST_WL_NUM=300;
    `endif

    bit     [1:0]                                           frame_bank_sel, exp_wr_banksel, exp_rd_banksel, wr_bank_ori, rd_bank_ori;
    bit    [`ROW_ADDR_WIDTH+`COLUMN_ADDR_WIDTH-2:0]         frame_wr_addr,frame_rd_addr,exp_array_wr_addr,exp_array_rd_addr;
    bit    [`ARRAY_DATA_WIDTH-1:0]                          frame_wr_data;
    bit                                                     wr_state=0,rd_state=0;
    bit     [1:0]                                           act_bank_sel;
    bit    [`ROW_ADDR_WIDTH-1:0]                            act_wr_gradd,act_rd_gradd,exp_wr_gradd,exp_rd_gradd;
    bit    [`COLUMN_ADDR_WIDTH-1:0]                         act_wr_gcadd,act_rd_gcadd,exp_wr_gcadd,exp_rd_gcadd;
    bit    [`ARRAY_DATA_WIDTH-1:0]                          act_array_wr_data,exp_array_wr_data,array_rdata,array_rdata_q[$];
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_wl_num_q[64];
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_wl_num,mc_vmc_bl_num_up,mc_vmc_bl_num_down;
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_bl_num_up_q[2];
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_bl_num_down_q[2];
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_bl_num_part0_q[2];
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_bl_num_part1_q[2];
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_bl_num_part2_q[2];
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_bl_num_part3_q[2];
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_bl_num_part4_q[2];
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_bl_num_part5_q[2];
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_bl_num_part6_q[2];
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_bl_num_part7_q[2];
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_bl_num_part8_q[2];
    bit    [`APB_DATA_WIDTH-1:0]                            mc_vmc_bl_num_part9_q[2];
    bit    [`ROW_ADDR_WIDTH-1:0]                            exp_vmc_wr_gradd,exp_vmc_wr_gcadd,exp_vmc_rd_gradd,exp_vmc_rd_gcadd;
    bit                                                     dram_init_finish=0;
    fork 
        begin
            while(1)begin

                //`uvm_info("nou_scb","debug4444",UVM_LOW)
                if((!vif_tb.mc_sys_rst_n || !vif_tb.mc_apb_rst_n )&&(vif_tb.reset_vseq)||!vif_tb.mc_en) begin //add by HY @20241218, add condition for reset check
                    //`uvm_info("nou_scb","debug11111",UVM_LOW)
                    frame_wr_banksel_q.delete();
                    frame_rd_banksel_q.delete();
                    frame_wr_addr_q.delete();
                    frame_wr_data_q.delete();
                    frame_rd_addr_q.delete();
                    arb_check_port_choose_q.delete();
                    #1ps;
                end
                else begin  //add by HY @20241218, add condition for reset check
                    fork 
                        begin
                            @(negedge vif_tb.rst_n);
                            `uvm_info("nou_scb", "rst_n_negedge!!!", UVM_LOW);
                        end
                        begin 
                            @(negedge vif_tb.apb_rst_n);
                            `uvm_info("nou_scb", "prst_n_negedge!!!", UVM_LOW);
                        end
                    join_any
                    `uvm_info("nou_scb", "all_rst_n_end!!!", UVM_LOW);

                    //`uvm_info("nou_scb","debug22222",UVM_LOW)
                    frame_wr_banksel_q.delete();
                    frame_rd_banksel_q.delete();
                    frame_wr_addr_q.delete();
                    frame_wr_data_q.delete();
                    frame_rd_addr_q.delete();
                    arb_check_port_choose_q.delete();
                    if(vif_tb.reset_vseq == 0) begin  //add by HY @20241218, add condition for reset check
                        phase.jump(uvm_reset_phase::get());
                    end
                    #1ps;
                end
                //`uvm_info("nou_scb","debug3333",UVM_LOW)

            end
        end
        begin
            while(1) begin
                @(posedge vif_tb.clk);
                if(vif_tb.timeout_case == 0)
                    if(vif_tb.mc_timeout_intr)
                        `uvm_error("nou_scb", "timeout_intr is 1!!")
            end
        end
                
        fork
            forever begin
                if(vif_tb.global_dram_init_en==1)begin
                    while(dram_init_finish==0)begin
                        uvm_hdl_read("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.dram_init_wr_aux_u.mc_dram_init_finish",dram_init_finish);
                        @(posedge vif_tb.clk);  
                    end
                end
                if((vif_tb.bist_test_en != 1'b1) && (vif_tb.error_inject != 1'b1) && vif_tb.mc_en)begin                
                    array_agent_trans                           array_act_trans;
                    array_act_trans = new();
                    if(vif_tb.mc_sys_rst_n!=1'b0)begin
                        array_act_port.get(array_act_trans);
                        if(array_act_trans.wr_rd_cmd && vif_tb.mc_sys_rst_n)begin // wr_trans
                            //wr_array_tran.push_back(array_act_trans);
                                act_bank_sel =  (array_act_trans.bank_sel == 2'b10) ? 0 : 1;
                            act_wr_gradd =  array_act_trans.row_addr;                        
                            act_wr_gcadd =  array_act_trans.col_addr;
                            act_array_wr_data = array_act_trans.wr_data;
                            if (frame_wr_addr_q.size() == 0)    
                                `uvm_error(get_type_name(),"frame_wr_addr_q.size is 0, but get array trans")
                            exp_array_wr_addr=frame_wr_addr_q.pop_front;
                            `uvm_info(get_type_name(),$sformatf("exp addr is %0h", exp_array_wr_addr),UVM_MEDIUM)
                            wr_bank_ori = frame_wr_banksel_q.pop_front;
                            exp_wr_banksel = vif_tb.bankmap[wr_bank_ori*2 +: 2];

                            exp_wr_gradd = exp_array_wr_addr[19:7];
                            exp_wr_gcadd = exp_array_wr_addr[6:0];
                            if (frame_wr_data_q.size() == 0)    
                                `uvm_error(get_type_name(),"frame_wr_data_q.size is 0, but get array trans")
                            exp_array_wr_data = frame_wr_data_q.pop_front;
                            if(vif_tb.wl_vmc_en || vif_tb.bl_vmc_en)begin//**************************************//
                                exp_vmc_wr_gradd = exp_wr_gradd;
                                exp_vmc_wr_gcadd = exp_wr_gcadd;
                                `uvm_info(get_type_name(), $sformatf("exp_vmc_wr_gcadd = %0h,exp_vmc_wr_gradd = %0h",exp_vmc_wr_gcadd,exp_vmc_wr_gradd), UVM_MEDIUM);
                                if(vif_tb.wl_vmc_en)begin
                                    foreach(mc_vmc_wl_num_q[j])begin
                                            if(act_bank_sel===0)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_wl_num%0d_bank0_o",j),mc_vmc_wl_num_q[j]);
                                            end else begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_wl_num%0d_bank1_o",j),mc_vmc_wl_num_q[j]);
                                            end

                                        `uvm_info(get_type_name(), $sformatf("mc_vmc_wl_num[%0d] = %0h",j,mc_vmc_wl_num_q[j]), UVM_MEDIUM);
                                        //mc_vmc_wl_num_q[j] = mc_vmc_wl_num;
                                    end
                                    for(int wl_cnt=0;wl_cnt<64;wl_cnt++)begin
                                        if(exp_vmc_wr_gradd >= mc_vmc_wl_num_q[wl_cnt]) exp_wr_gradd++;
                                    end  
                                    `uvm_info(get_type_name(), $sformatf("exp_wr_gradd = %0h",exp_wr_gradd), UVM_MEDIUM);
                                end 
                                if(vif_tb.bl_vmc_en)begin 
                                    if(exp_wr_gradd < BIST_WL_NUM/10)begin
                                        foreach(mc_vmc_bl_num_part0_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part0_bank0_o",j),mc_vmc_bl_num_part0_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part0_bank1_o",j),mc_vmc_bl_num_part0_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part0_q[%0d] = %0h",j,mc_vmc_bl_num_part0_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_wr_gcadd >= mc_vmc_bl_num_part0_q[bl_cnt]) exp_wr_gcadd++;
                                        end    
                                    end 
                                    else if((BIST_WL_NUM/10-1)<exp_wr_gradd&&exp_wr_gradd<BIST_WL_NUM*2/10) begin
                                        foreach(mc_vmc_bl_num_part1_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part1_bank0_o",j),mc_vmc_bl_num_part1_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part1_bank1_o",j),mc_vmc_bl_num_part1_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part1_q[%0d] = %0h",j,mc_vmc_bl_num_part1_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_wr_gcadd >= mc_vmc_bl_num_part1_q[bl_cnt]) exp_wr_gcadd++;
                                        end    
                                    end
                                    else if((BIST_WL_NUM*2/10-1)<exp_wr_gradd&&exp_wr_gradd<BIST_WL_NUM*3/10)begin
                                        foreach(mc_vmc_bl_num_part2_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part2_bank0_o",j),mc_vmc_bl_num_part2_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part2_bank1_o",j),mc_vmc_bl_num_part2_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part2_q[%0d] = %0h",j,mc_vmc_bl_num_part2_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_wr_gcadd >= mc_vmc_bl_num_part2_q[bl_cnt]) exp_wr_gcadd++;
                                        end    
                                    end                                    
                                    else if((BIST_WL_NUM*3/10-1)<exp_wr_gradd&&exp_wr_gradd<BIST_WL_NUM*4/10)begin
                                        foreach(mc_vmc_bl_num_part3_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part3_bank0_o",j),mc_vmc_bl_num_part3_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part3_bank1_o",j),mc_vmc_bl_num_part3_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part3_q[%0d] = %0h",j,mc_vmc_bl_num_part3_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_wr_gcadd >= mc_vmc_bl_num_part3_q[bl_cnt]) exp_wr_gcadd++;
                                        end    
                                    end 
                                    else if((BIST_WL_NUM*4/10-1)<exp_wr_gradd&&exp_wr_gradd<BIST_WL_NUM*5/10)begin
                                        foreach(mc_vmc_bl_num_part4_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part4_bank0_o",j),mc_vmc_bl_num_part4_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part4_bank1_o",j),mc_vmc_bl_num_part4_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part4_q[%0d] = %0h",j,mc_vmc_bl_num_part4_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_wr_gcadd >= mc_vmc_bl_num_part4_q[bl_cnt]) exp_wr_gcadd++;
                                        end    
                                    end 
                                    else if((BIST_WL_NUM*5/10-1)<exp_wr_gradd&&exp_wr_gradd<BIST_WL_NUM*6/10)begin
                                        foreach(mc_vmc_bl_num_part5_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part5_bank0_o",j),mc_vmc_bl_num_part5_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part5_bank1_o",j),mc_vmc_bl_num_part5_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part4_q[%0d] = %0h",j,mc_vmc_bl_num_part5_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_wr_gcadd >= mc_vmc_bl_num_part5_q[bl_cnt]) exp_wr_gcadd++;
                                        end    
                                    end 
                                    else if((BIST_WL_NUM*6/10-1)<exp_wr_gradd&&exp_wr_gradd<BIST_WL_NUM*7/10)begin
                                        foreach(mc_vmc_bl_num_part6_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part6_bank0_o",j),mc_vmc_bl_num_part6_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part6_bank1_o",j),mc_vmc_bl_num_part6_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part6_q[%0d] = %0h",j,mc_vmc_bl_num_part6_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_wr_gcadd >= mc_vmc_bl_num_part6_q[bl_cnt]) exp_wr_gcadd++;
                                        end    
                                    end 
                                    else if((BIST_WL_NUM*7/10-1)<exp_wr_gradd&&exp_wr_gradd<BIST_WL_NUM*8/10)begin
                                        foreach(mc_vmc_bl_num_part7_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part7_bank0_o",j),mc_vmc_bl_num_part7_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part7_bank1_o",j),mc_vmc_bl_num_part7_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part7_q[%0d] = %0h",j,mc_vmc_bl_num_part7_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_wr_gcadd >= mc_vmc_bl_num_part7_q[bl_cnt]) exp_wr_gcadd++;
                                        end    
                                    end 
                                    else if((BIST_WL_NUM*8/10-1)<exp_wr_gradd&&exp_wr_gradd<BIST_WL_NUM*9/10)begin
                                        foreach(mc_vmc_bl_num_part8_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part8_bank0_o",j),mc_vmc_bl_num_part8_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part8_bank1_o",j),mc_vmc_bl_num_part8_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part8_q[%0d] = %0h",j,mc_vmc_bl_num_part8_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_wr_gcadd >= mc_vmc_bl_num_part8_q[bl_cnt]) exp_wr_gcadd++;
                                        end    
                                    end 
                                    else if((BIST_WL_NUM*9/10-1)<exp_wr_gradd&&exp_wr_gradd<BIST_WL_NUM)begin
                                        foreach(mc_vmc_bl_num_part9_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part9_bank0_o",j),mc_vmc_bl_num_part9_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part9_bank1_o",j),mc_vmc_bl_num_part9_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part9_q[%0d] = %0h",j,mc_vmc_bl_num_part9_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_wr_gcadd >= mc_vmc_bl_num_part9_q[bl_cnt]) exp_wr_gcadd++;
                                        end    
                                    end 
                                    `uvm_info(get_type_name(), $sformatf("exp_wr_gcadd = %0h",exp_wr_gcadd), UVM_MEDIUM);
                                end
                            end
                            if(exp_array_wr_data !== act_array_wr_data[255:0])`uvm_error(get_type_name(), $sformatf("array accept one write_data not match frame_wr:exp_array_wr_data=0x%0h,act_array_wr_data=0x%0h,exp_wr_gradd=0x%0h,act_wr_gradd=0x%0h,exp_wr_gcadd=0x%0h,act_wr_gcadd=0x%0h",exp_array_wr_data,act_array_wr_data,exp_wr_gradd,act_wr_gradd,exp_wr_gcadd,act_wr_gcadd))
                            if(exp_wr_banksel !== act_bank_sel) begin
                                if(!vif_tb.xbank_en)`uvm_error("", $sformatf("array accept bank_sel not match! exp: %0h, act: %0h", exp_wr_banksel, act_bank_sel))
                            end
                            if(exp_wr_gradd !== act_wr_gradd)`uvm_error(get_type_name(), $sformatf("array accept one write_row_addr not match frame_wr:exp_wr_gradd=0x%0h,act_wr_gradd=0x%0h",exp_wr_gradd,act_wr_gradd))
                            if(exp_wr_gcadd !== act_wr_gcadd)`uvm_error(get_type_name(), $sformatf("array accept one write_col_addr not match frame_wr:exp_wr_gcadd=0x%0h,act_wr_gcadd=0x%0h",exp_wr_gcadd,act_wr_gcadd))
                        end 
                        else if(!array_act_trans.wr_rd_cmd && vif_tb.mc_sys_rst_n)begin // rd_trans
                            act_rd_gradd =  array_act_trans.row_addr;                        
                            act_rd_gcadd =  array_act_trans.col_addr;
                                act_bank_sel =  (array_act_trans.bank_sel == 2'b10) ? 0 : 1;

                            if (frame_rd_addr_q.size() == 0)    
                                `uvm_error(get_type_name(),"frame_rd_addr_q.size is 0, but get array trans")
                            rd_bank_ori = frame_rd_banksel_q.pop_front;
                            exp_rd_banksel = vif_tb.bankmap[rd_bank_ori*2 +: 2];
                            exp_array_rd_addr=frame_rd_addr_q.pop_front;
                            exp_rd_gradd = exp_array_rd_addr[19:7];
                            exp_rd_gcadd = exp_array_rd_addr[6:0];
                            `uvm_info(get_type_name(), $sformatf("exp_rd_gcadd = %0h,exp_rd_gradd = %0h",exp_rd_gcadd,exp_rd_gradd), UVM_MEDIUM);
                            if(vif_tb.wl_vmc_en || vif_tb.bl_vmc_en)begin//**************************************//
                                exp_vmc_rd_gradd = exp_rd_gradd;
                                exp_vmc_rd_gcadd = exp_rd_gcadd;
                            `uvm_info(get_type_name(), $sformatf("exp_vmc_rd_gcadd = %0h,exp_vmc_rd_gradd = %0h",exp_vmc_rd_gcadd,exp_vmc_rd_gradd), UVM_MEDIUM);
                                if(vif_tb.wl_vmc_en)begin
                                    foreach(mc_vmc_wl_num_q[j])begin
                                            if(act_bank_sel===0)begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_wl_num%0d_bank0_o",j),mc_vmc_wl_num_q[j]);
                                            end else begin
                                                uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_wl_num%0d_bank1_o",j),mc_vmc_wl_num_q[j]);
                                            end
                                        `uvm_info(get_type_name(), $sformatf("mc_vmc_wl_num[%0d] = %0h",j,mc_vmc_wl_num_q[j]), UVM_MEDIUM);
                                        //mc_vmc_wl_num_q[j] = mc_vmc_wl_num;
                                    end
                                    for(int wl_cnt=0;wl_cnt<64;wl_cnt++)begin
                                        if(exp_vmc_rd_gradd >= mc_vmc_wl_num_q[wl_cnt]) exp_rd_gradd++;
                                    end  
                                    `uvm_info(get_type_name(), $sformatf("exp_rd_gradd = %0h",exp_rd_gradd), UVM_MEDIUM);
                                end 
                                if(vif_tb.bl_vmc_en)begin 
                                    if(exp_rd_gradd < BIST_WL_NUM/10)begin
                                        foreach(mc_vmc_bl_num_part0_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part0_bank0_o",j),mc_vmc_bl_num_part0_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part0_bank1_o",j),mc_vmc_bl_num_part0_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part0_q[%0d] = %0h",j,mc_vmc_bl_num_part0_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_rd_gcadd >= mc_vmc_bl_num_part0_q[bl_cnt]) exp_rd_gcadd++;
                                        end    
                                    end 
                                    else if((BIST_WL_NUM/10-1)<exp_rd_gradd&&exp_rd_gradd<BIST_WL_NUM*2/10) begin
                                        foreach(mc_vmc_bl_num_part1_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part1_bank0_o",j),mc_vmc_bl_num_part1_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part1_bank1_o",j),mc_vmc_bl_num_part1_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part1_q[%0d] = %0h",j,mc_vmc_bl_num_part1_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_rd_gcadd >= mc_vmc_bl_num_part1_q[bl_cnt]) exp_rd_gcadd++;
                                        end    
                                    end
                                    else if((BIST_WL_NUM*2/10-1)<exp_rd_gradd&&exp_rd_gradd<BIST_WL_NUM*3/10)begin
                                        foreach(mc_vmc_bl_num_part2_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part2_bank0_o",j),mc_vmc_bl_num_part2_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part2_bank1_o",j),mc_vmc_bl_num_part2_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part2_q[%0d] = %0h",j,mc_vmc_bl_num_part2_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_rd_gcadd >= mc_vmc_bl_num_part2_q[bl_cnt]) exp_rd_gcadd++;
                                        end    
                                    end                                    
                                    else if((BIST_WL_NUM*3/10-1)<exp_rd_gradd&&exp_rd_gradd<BIST_WL_NUM*4/10)begin
                                        foreach(mc_vmc_bl_num_part3_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part3_bank0_o",j),mc_vmc_bl_num_part3_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part3_bank1_o",j),mc_vmc_bl_num_part3_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part3_q[%0d] = %0h",j,mc_vmc_bl_num_part3_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_rd_gcadd >= mc_vmc_bl_num_part3_q[bl_cnt]) exp_rd_gcadd++;
                                        end    
                                    end 
                                    else if((BIST_WL_NUM*4/10-1)<exp_rd_gradd&&exp_rd_gradd<BIST_WL_NUM*5/10)begin
                                        foreach(mc_vmc_bl_num_part4_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part4_bank0_o",j),mc_vmc_bl_num_part4_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part4_bank1_o",j),mc_vmc_bl_num_part4_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part4_q[%0d] = %0h",j,mc_vmc_bl_num_part4_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_rd_gcadd >= mc_vmc_bl_num_part4_q[bl_cnt]) exp_rd_gcadd++;
                                        end    
                                    end  
                                    else if((BIST_WL_NUM*5/10-1)<exp_rd_gradd&&exp_rd_gradd<BIST_WL_NUM*6/10)begin
                                        foreach(mc_vmc_bl_num_part5_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part5_bank0_o",j),mc_vmc_bl_num_part5_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part5_bank1_o",j),mc_vmc_bl_num_part5_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part5_q[%0d] = %0h",j,mc_vmc_bl_num_part5_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_rd_gcadd >= mc_vmc_bl_num_part5_q[bl_cnt]) exp_rd_gcadd++;
                                        end    
                                    end 
 
                                    else if((BIST_WL_NUM*6/10-1)<exp_rd_gradd&&exp_rd_gradd<BIST_WL_NUM*7/10)begin
                                        foreach(mc_vmc_bl_num_part6_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part6_bank0_o",j),mc_vmc_bl_num_part6_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part6_bank1_o",j),mc_vmc_bl_num_part6_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part6_q[%0d] = %0h",j,mc_vmc_bl_num_part6_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_rd_gcadd >= mc_vmc_bl_num_part6_q[bl_cnt]) exp_rd_gcadd++;
                                        end    
                                    end 
 
                                    else if((BIST_WL_NUM*7/10-1)<exp_rd_gradd&&exp_rd_gradd<BIST_WL_NUM*8/10)begin
                                        foreach(mc_vmc_bl_num_part7_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part7_bank0_o",j),mc_vmc_bl_num_part7_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part7_bank1_o",j),mc_vmc_bl_num_part7_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part7_q[%0d] = %0h",j,mc_vmc_bl_num_part7_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_rd_gcadd >= mc_vmc_bl_num_part7_q[bl_cnt]) exp_rd_gcadd++;
                                        end    
                                    end 
 
                                    else if((BIST_WL_NUM*8/10-1)<exp_rd_gradd&&exp_rd_gradd<BIST_WL_NUM*9/10)begin
                                        foreach(mc_vmc_bl_num_part8_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part8_bank0_o",j),mc_vmc_bl_num_part8_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part8_bank1_o",j),mc_vmc_bl_num_part8_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part8_q[%0d] = %0h",j,mc_vmc_bl_num_part8_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_rd_gcadd >= mc_vmc_bl_num_part8_q[bl_cnt]) exp_rd_gcadd++;
                                        end    
                                    end 
 
                                    else if((BIST_WL_NUM*9/10-1)<exp_rd_gradd&&exp_rd_gradd<BIST_WL_NUM)begin
                                        foreach(mc_vmc_bl_num_part9_q[j])begin
                                                if(act_bank_sel===0)begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part9_bank0_o",j),mc_vmc_bl_num_part9_q[j]);
                                                end else begin
                                                    uvm_hdl_read($sformatf("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.inst2.apb2reg_mc_top_cfg_if_u2.mc_vmc_bl_num%0d_part9_bank1_o",j),mc_vmc_bl_num_part9_q[j]);
                                                end
                                            `uvm_info(get_type_name(), $sformatf("mc_vmc_bl_num_part9_q[%0d] = %0h",j,mc_vmc_bl_num_part9_q[j]), UVM_MEDIUM);
                                        end 
                                        for(int bl_cnt=0;bl_cnt<2;bl_cnt++)begin
                                            if(exp_vmc_rd_gcadd >= mc_vmc_bl_num_part9_q[bl_cnt]) exp_rd_gcadd++;
                                        end    
                                    end 

                                    `uvm_info(get_type_name(), $sformatf("exp_rd_gcadd = %0h",exp_rd_gcadd), UVM_MEDIUM);
                                end
                            end
                            if(exp_rd_banksel !== act_bank_sel) begin
                                if(!vif_tb.xbank_en) `uvm_error("", $sformatf("array accept bank_sel not match! exp: %0h, act: %0h", exp_rd_banksel, act_bank_sel))
                            end

                            if(exp_rd_gradd !== act_rd_gradd)`uvm_error(get_type_name(), $sformatf("array accept one write_row_addr not match frame_wr:exp_rd_gradd=0x%0h,act_rd_gradd=0x%0h",exp_rd_gradd,act_rd_gradd))
                            if(exp_rd_gcadd !== act_rd_gcadd)`uvm_error(get_type_name(), $sformatf("array accept one write_col_addr not match frame_wr:exp_rd_gcadd=0x%0h,act_rd_gcadd=0x%0h",exp_rd_gcadd,act_rd_gcadd))
                        end
                    end 
                    else begin
                        wait(vif_tb.mc_sys_rst_n==1);
                    end
                end
                else begin
                    @(posedge vif_tb.clk);  
                end
            end 
            while(1)begin
                @(negedge vif_tb.rst_n);
                `uvm_info(get_type_name(), $sformatf("rst1111111111"), UVM_MEDIUM)
                //wr_array_tran.delete();
                frame_wr_addr_q.delete();
                frame_wr_data_q.delete();
                frame_rd_addr_q.delete();
                arb_check_port_choose_q.delete();
            end
            while(1)begin//bist clk gating check
                wait(vif_tb.rst_n);
                @(posedge vif_tb.clk);
                if(vif_tb.bist_inner_global_mc_bist_en==0)begin
                    #10ps;
                    if(vif_tb.bist_clk!=0)begin
                        `uvm_error(get_full_name(), "bist clk gating fail")
                    end
                end
            end
            while(1) begin  //arb2array check
                wait (vif_tb.arb_s_valid_i != 0);
                arb_pointer_check();        //time waste in task
            end
            while(1) begin  //arb2array check
                @(posedge vif_tb.clk);
                #1ps;
                if(vif_tb.arb_m_vld_o && vif_tb.arb_m_ready_i)
                    arb_handshake_check();        //time waste in task
            end
            while(1) begin  //arb array rdata check
                @(posedge vif_tb.clk);
                #1ps;
                if(vif_tb.arb_m_rdata_vld_i === 'b1)
                    arb_rdata_check();
            end
            while(1)begin
                @(posedge vif_tb.close_page)begin
                    if((wr_state!==0)&&(rd_state!==0)) `uvm_error(get_full_name(), $sformatf("posedge close page check,wr_state=%0d,rd_state=%0d",wr_state,rd_state))
                end
            end
            while(1)begin
                @(negedge vif_tb.close_page)begin
                    if((wr_state!==0)&&(rd_state!==0)) `uvm_error(get_full_name(), $sformatf("negedge close page check,wr_state=%0d,rd_state=%0d",wr_state,rd_state))
                end
            end

        join_none 

        fork
            while(1)begin  //get write frame
                if (vif_tb.mc_sys_rst_n!=1'b0 && vif_tb.mc_apb_rst_n != 1'b0) begin
                    frm_act_port_w.get(frame_wr_tran);
                    frame_bank_sel = frame_wr_tran.mc_frame_data[21:20]   ;
                    frame_wr_addr = frame_wr_tran.mc_frame_data[19:0]   ;
                    frame_wr_data = frame_wr_tran.mc_frame_data[277:22] ;
                    `uvm_info(get_type_name(),$sformatf("get frame_wr_tran addr is %0h",frame_wr_addr),UVM_MEDIUM)
                    `uvm_info(get_type_name(),$sformatf("get frame_wr_tran data is %0h",frame_wr_data),UVM_MEDIUM)
                    if (frame_wr_tran.mc_frame_data[`FRAME_DATA_WIDTH-2]&&(frame_wr_tran.mc_frame_data[`FRAME_DATA_WIDTH-1]===1'b1)) begin
                        frame_wr_banksel_q.push_back(frame_bank_sel);
                        frame_wr_addr_q.push_back(frame_wr_addr);
                        frame_wr_data_q.push_back(frame_wr_data);
                    end
                    #1ps;
                    if (vif_tb.mc_sys_rst_n != 1'b0 && vif_tb.mc_apb_rst_n!=1'b0) begin //add by HY @20241218,add condition for reset check
                        case(frame_wr_tran.mc_frame_data[`FRAME_DATA_WIDTH-3 -:2])
                            2'b10:begin // sof
                                `uvm_info(get_type_name(), $sformatf("sof=2'b10"), UVM_MEDIUM)
                                wr_state = 1;
                            end
                            2'b00:begin //between
                                `uvm_info(get_type_name(), $sformatf("sof=2'b00"), UVM_MEDIUM)
                                if(wr_state != 1 && rd_state != 1)   `uvm_error(get_type_name(), $sformatf("when sof=0,eof=0,wr_state!=1, {sof,eof}=0x%h,wr_state=0x%h",frame_wr_tran.mc_frame_data[`FRAME_DATA_WIDTH-3 -:2],wr_state))
                            end
                            2'b01:begin // eof
                                `uvm_info(get_type_name(), $sformatf("sof=2'b01"), UVM_MEDIUM)
                                if(wr_state != 1 && rd_state != 1)   `uvm_error(get_type_name(), $sformatf("when sof=0,eof=1,wr_state!=1, {sof,eof}=0x%h,wr_state=0x%h",frame_wr_tran.mc_frame_data[`FRAME_DATA_WIDTH-3 -:2],wr_state))
                                wr_state = 0;
                            end
                            2'b11:begin
                                `uvm_info(get_type_name(), $sformatf("sof=2'b11"), UVM_MEDIUM)
                                if(wr_state != 0 && rd_state != 0)   `uvm_error(get_type_name(), $sformatf("when sof=1,eof=1,wr_state!=0, {sof,eof}=0x%h,wr_state=0x%h",frame_wr_tran.mc_frame_data[`FRAME_DATA_WIDTH-3 -:2],wr_state))
                                wr_state = 0;
                            end 
                        endcase
                    end
                end 
                else begin
                    `uvm_info(get_type_name(), $sformatf("wait rst_n equal 1"), UVM_MEDIUM)
                    wait(vif_tb.mc_sys_rst_n==1);    
                    wait(vif_tb.mc_apb_rst_n==1);    
                end
            end 
            while(1)begin
                @(negedge vif_tb.rst_n);
                wr_state = 0;
            end
        join_none
        wait fork;

        fork    
            while(1)begin   // get read frame
                if (vif_tb.mc_sys_rst_n!=1'b0 && vif_tb.mc_apb_rst_n != 1'b0) begin
                    frm_act_port_r.get(frame_rd_tran);
                    frame_rd_addr = frame_rd_tran.mc_frame_data[19:0] ;
                    if(frame_rd_tran.mc_frame_data[297]===1'b1)begin
                        frame_rd_addr_q.push_back(frame_rd_addr);
						frame_rd_banksel_q.push_back(frame_rd_tran.mc_frame_data[21:20]);
                    end
                    #1ps;
                    if (vif_tb.mc_sys_rst_n != 1'b0 && vif_tb.mc_apb_rst_n!=1'b0) begin //add by HY @20241218,add condition for reset check
                        case(frame_rd_tran.mc_frame_data[`FRAME_DATA_WIDTH-3 -:2])
                            2'b10:begin // sof
                                `uvm_info(get_type_name(), $sformatf("sof=2'b10"), UVM_MEDIUM)
                                rd_state = 1;
                            end
                            2'b00:begin
                                `uvm_info(get_type_name(), $sformatf("sof=2'b00"), UVM_MEDIUM)
                                if(rd_state != 1 && wr_state != 1)   `uvm_error(get_type_name(), $sformatf("when sof=0,eof=0,rd_state!=1, {sof,eof}=0x%h,rd_state=0x%h",frame_wr_tran.mc_frame_data[`FRAME_DATA_WIDTH-3 -:2],rd_state))
                            end
                            2'b01:begin // eof
                                `uvm_info(get_type_name(), $sformatf("sof=2'b01"), UVM_MEDIUM)
                                if(rd_state != 1 && wr_state != 1)   `uvm_error(get_type_name(), $sformatf("when sof=0,eof=1,rd_state!=1, {sof,eof}=0x%h,rd_state=0x%h",frame_wr_tran.mc_frame_data[`FRAME_DATA_WIDTH-3 -:2],rd_state))
                                rd_state = 0;
                            end
                            2'b11:begin
                                `uvm_info(get_type_name(), $sformatf("sof=2'b11"), UVM_MEDIUM)
                                if(rd_state != 0 && wr_state != 0)   `uvm_error(get_type_name(), $sformatf("when sof=1,eof=1,rd_state!=0, {sof,eof}=0x%h,rd_state=0x%h",frame_wr_tran.mc_frame_data[`FRAME_DATA_WIDTH-3 -:2],rd_state))
                                rd_state = 0;
                            end 
                        endcase
                    end
                end
                else begin
                    `uvm_info(get_type_name(), $sformatf("wait rst_n equal 1"), UVM_MEDIUM)
                    wait(vif_tb.mc_sys_rst_n==1);    
                    wait(vif_tb.mc_apb_rst_n==1);    
                end
            end 
            while(1)begin
                @(negedge vif_tb.rst_n);
                rd_state = 0;
            end
        join_none 
        wait fork;
    join
endtask : main_phase

function void mc_scb::report_phase(uvm_phase phase);
    //if(cmp_t==0)begin
    //    `uvm_error(get_full_name,"Scoreboard did not finsh one comparation!")
    //end 
    if((vif_tb.bist_test_en == 1'b0) && (vif_tb.error_inject == 1'b0) && (vif_tb.loopback_en == 1'b0))begin                
        if(frame_wr_addr_q.size > 0)    `uvm_error(get_full_name(), $sformatf("frame_wr_addr_q.size=%0d > 0",frame_wr_addr_q.size))
        if(frame_wr_data_q.size > 0)    `uvm_error(get_full_name(), $sformatf("frame_wr_data_q.size=%0d > 0",frame_wr_data_q.size))
        if(frame_rd_addr_q.size > 0)    `uvm_error(get_full_name(), $sformatf("frame_rd_addr_q.size=%0d > 0",frame_rd_addr_q.size))
    end
endfunction

task mc_scb::arb_pointer_check();
    localparam  SLV_NUM = 6;

    bit [SLV_NUM-1:0]   port_choose;
    bit [299-1:0]       choose_data;
    int                 pointer; 

    port_choose = cal_round_robin(vif_tb.arb_port_choose, vif_tb.arb_s_valid_i);
    //`uvm_info("arb pointer check", $sformatf("now_grant is %0d, cal_round_robin is %0d",vif_tb.arb_port_choose, port_choose), UVM_MEDIUM)

    pointer =   $clog2(port_choose);



    fork 
        begin
            @(posedge vif_tb.clk);
            #1ps;
            if (vif_tb.mc_sys_rst_n && vif_tb.mc_apb_rst_n) begin
                if (port_choose != vif_tb.arb_port_choose)
                    `uvm_error("arb pointer check", $sformatf("port_choose check err, exp is %0d, act is %0d", port_choose, vif_tb.arb_port_choose))
                else 
                    `uvm_info("arb pointer check", $sformatf("port_choose check pass, is %0d", port_choose), UVM_HIGH)//MEDIUM)
            end
        end
        begin

            if (port_choose !== vif_tb.arb_port_choose) begin
                @(posedge vif_tb.clk);
            end
            #1ps;

            choose_data = vif_tb.arb_s_data_i[299*pointer +: 299];

            if (vif_tb.mc_sys_rst_n && vif_tb.mc_apb_rst_n) begin
                if (vif_tb.arb_m_vld_o != 1)
                    `uvm_error("arb pointer check", $sformatf("m vld check err, exp is 1, act is %0d", vif_tb.arb_m_vld_o))

                if (vif_tb.arb_m_data_o != choose_data)
                    `uvm_error("arb pointer check", $sformatf("choose data check err, exp is %0h, act is %0h", choose_data, vif_tb.arb_m_data_o))
            end

    
            @(posedge vif_tb.clk);
            #1ps;
        end
    join_any

endtask:arb_pointer_check

task mc_scb::arb_handshake_check();
    localparam  SLV_NUM = 6;

    bit [SLV_NUM-1:0]   port_choose;
    bit [299-1:0]       choose_data;
    int                 pointer; 


    //handshake

    @(negedge vif_tb.clk);

    pointer =   $clog2(vif_tb.arb_port_choose);

    //`uvm_info("arb check", $sformatf("now_grant is %0d",vif_tb.arb_port_choose), UVM_MEDIUM)

    choose_data = vif_tb.arb_s_data_i[299*pointer +: 299];
    //`uvm_info("", $sformatf("choose_data: %0h", choose_data), UVM_MEDIUM)
    //`uvm_info("", $sformatf("choose_data[291]: %0h", choose_data[291]), UVM_MEDIUM)

    if (choose_data[297]) begin  //write
    end
    else begin                   //read
        arb_check_port_choose_q.push_back(vif_tb.arb_port_choose);
        `uvm_info("arb handshake check", $sformatf("push back port_choose is %0d", vif_tb.arb_port_choose), UVM_MEDIUM)
    end

    if (vif_tb.mc_sys_rst_n && vif_tb.mc_apb_rst_n && vif_tb.arb_m_vld_o && vif_tb.arb_m_ready_i) begin
        if (vif_tb.arb_m_vld_o != 1)
            `uvm_error("arb handshake check", $sformatf("m vld check err, exp is 1, act is %0d", vif_tb.arb_m_vld_o))
        if (vif_tb.arb_m_data_o != choose_data)
            `uvm_error("arb handshake check", $sformatf("choose data check err, exp is %0h, act is %0h", choose_data, vif_tb.arb_m_data_o))
        if (vif_tb.arb_s_ready_o != vif_tb.arb_port_choose)
            `uvm_error("arb handshake check", $sformatf("s ready check err, exp is %0d, act is %0d", vif_tb.arb_port_choose, vif_tb.arb_s_ready_o))
    end
endtask:arb_handshake_check

task mc_scb::arb_rdata_check();

    bit [5:0]   port_choose;
    int         pointer;

    //#1ps;
    `uvm_info("arb rdata check", $sformatf("rdata check start "), UVM_MEDIUM)
    if (arb_check_port_choose_q.size() == 0) begin
        `uvm_error("arb_rdata_check", $sformatf("arb received no read op, but get rdata from array"))
        @(posedge vif_tb.clk);
        return ;
    end
    else begin
        #1ps;
        port_choose = arb_check_port_choose_q.pop_front;
        pointer = $clog2(port_choose);

        if(vif_tb.mc_sys_rst_n===1)begin
            if (port_choose[5] == 'b1)
                `uvm_error("arb_rdata_check", $sformatf("dram_init has no read op, port_choose is %0h", port_choose))

            if (vif_tb.arb_s_rvld_o != port_choose[4:0]) 
                `uvm_error("arb_rdata_check", $sformatf("arbiter s rvld check err, exp is %0h, act is %0h", port_choose[4:0], vif_tb.arb_s_rvld_o))
            if (vif_tb.arb_s_rdata_o[272*pointer+:272] !== vif_tb.arb_m_rdata_i)
                `uvm_error("arb_rdata_check", $sformatf("arbiter s rdata check err, exp is %0h, act is %0h", vif_tb.arb_m_rdata_i, vif_tb.arb_s_rdata_o[272*pointer+:272]))
        end
    end
endtask:arb_rdata_check


function bit [5:0] mc_scb::cal_round_robin(bit [5:0] now_grant, bit [5:0] now_valid_in);
    
    localparam SLV_NUM = 6;
    int          pointer;
    bit  [SLV_NUM-1:0]   valid;

    pointer = $clog2(now_grant);

    for (int i=0;i<SLV_NUM;i++) begin


        if (pointer == SLV_NUM) begin
            pointer = 0;
        end

        if (now_valid_in[pointer] == 1'b1) begin
            valid = 'b1;
            break;
        end

        pointer = pointer + 1;
    end

    //cal_round_robin = valid << pointer;
    cal_round_robin = 6'b1 << pointer;

endfunction:cal_round_robin

`endif // MC_SCB_SV

