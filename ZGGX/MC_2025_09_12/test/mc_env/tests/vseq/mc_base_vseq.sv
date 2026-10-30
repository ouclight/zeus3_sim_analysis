
`ifndef MC_BASE_VSEQ_SV
`define MC_BASE_VSEQ_SV

class mc_base_vseq extends uvm_sequence;
    
    virtual frame_agent_if  m_frame_agent_if;
    virtual array_agent_if  m_array_agent_if;
    virtual tb_if           m_tb_if;
    virtual svt_apb_if      m_svt_apb_if[2];
    bit[31:0]               mb_data;

    bit[271:0]              mb_wr_data_store [bit[21:0]];
    
    `uvm_object_utils(mc_base_vseq)
    `uvm_declare_p_sequencer(mc_vseqr)

    function new(string name="mc_base_vseq");
        super.new(name);
        set_automatic_phase_objection(1);
    endfunction
    extern function bit[4:0] func_exist_in_queue(bit[2+20-1:0] b_in_addr, bit[2+20-1:0] qb_addr[$]);
    extern task tsk_bist_err_addr_chk();
    extern task modify_rf_cnt(bit [31:0] rf_cnt_inner, bit [31:0] current_period_inner, bit [31:0] current_start_time_inner);
    extern task tsk_rd_frm_arr_chk();
    extern task tsk_wr_rd_arr_chk();

virtual task body();
    if(p_sequencer.m_tb_if.rst_ongoing_flag==0)begin
        get_config();
    end 
    fork
        begin
            @(posedge m_tb_if.push_full);
            #1000ns;
            `uvm_info("", "fifo push_full", UVM_NONE)
        end
    join_none
endtask 

virtual task get_config();

    if(!uvm_config_db#(virtual tb_if)::get(null, get_full_name(), "vif_tb", m_tb_if)) begin
        `uvm_fatal("GETINTF", {"Could not get m_tb_if at ", get_full_name()})
    end
    

    if(!uvm_config_db#(virtual frame_agent_if)::get(null,get_full_name(), "frame_agent_vif",m_frame_agent_if)) begin
        `uvm_fatal("GETINTF", {"Could not get frame_agent_vif at ", get_full_name()})
    end

    if(!uvm_config_db#(virtual array_agent_if)::get(null,get_full_name(), "array_agent_vif",m_array_agent_if)) begin
        `uvm_fatal("GETINTF", {"Could not get array_agent_vif at ", get_full_name()})
    end


    foreach (m_svt_apb_if[i]) begin
        if (!uvm_config_db #(virtual svt_apb_if)::get(null,get_full_name(), $sformatf("m_svt_apb_vif[%0d]", i), m_svt_apb_if[i]))
            `uvm_error(get_full_name(), $sformatf(" virtual interface must be set for: m_svt_apb_vif[%0d]", i))
    end
    

endtask

virtual task pre_start();
    //if(starting_phase!=null)begin
    //    starting_phase.raise_objection(this);
    //    `uvm_info(get_type_name(),"pre_start() raise an objection",UVM_LOW);
    //end
endtask

virtual task post_start();
    //if(starting_phase!=null)begin
    //    starting_phase.drop_objection(this);
    //    `uvm_info(get_type_name(),"post_start() drop an objection",UVM_LOW);
    //end
endtask

endclass

function bit[4:0] mc_base_vseq::func_exist_in_queue(bit[2+20-1:0] b_in_addr, bit[2+20-1:0] qb_addr[$]);
    int         i_size;
    bit[4:0]    result;
    i_size = qb_addr.size();
    foreach(qb_addr[i]) begin
        if(b_in_addr == qb_addr[i]) begin
            result[3:0] = i;
            result[4]   = 1;
            return(result);
        end
    end
    return(0);
endfunction : func_exist_in_queue

task mc_base_vseq::tsk_bist_err_addr_chk();
    bit [`COLUMN_ADDR_WIDTH-1:0]    csl_default_value = '1;
    bit [`COLUMN_ADDR_WIDTH-1:0]    err_csl_addr;
    uvm_status_e                    status                  ;

    //-----bank0
    //{{{
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part0_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_up error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part0_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_up error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part1_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part1_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part2_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part2_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part3_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part3_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part4_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part4_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part5_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part5_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part6_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part6_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part7_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part7_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part8_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part8_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part9_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part9_bank0.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    //}}}
    //-----bank1
    //{{{
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part0_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_up error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part0_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_up error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part1_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part1_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part2_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part2_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part3_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part3_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part4_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part4_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part5_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part5_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part6_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part6_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part7_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part7_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part8_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part8_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl0_part9_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl0_down error, exp is 7f, act is %0h",err_csl_addr))
    p_sequencer.mc_soc_regmodel.MC_TOP_AUX_ins.err_csl1_part9_bank1.read(status, err_csl_addr, UVM_FRONTDOOR);
    if(err_csl_addr != csl_default_value)
        `uvm_error(get_type_name(),$sformatf("err_csl1_down error, exp is 7f, act is %0h",err_csl_addr))
    //}}}
endtask : tsk_bist_err_addr_chk

task mc_base_vseq::modify_rf_cnt(bit [31:0] rf_cnt_inner, bit [31:0] current_period_inner, bit [31:0] current_start_time_inner);
    bit [1:0]       modify_type;
    bit [7:0]       delay_time;
    delay_time = $urandom_range(3, 20);
    modify_type =   {(rf_cnt_inner >= current_period_inner), (rf_cnt_inner >= current_start_time_inner)};
    `uvm_info("", $sformatf("rf_cnt_inner: %0h, current_period_inner: %0h, current_start_time_inner: %0h", rf_cnt_inner, current_period_inner, current_start_time_inner), UVM_MEDIUM)
    case(modify_type)
        2'b00: begin    //rf_cnt < current_start_time < current_period
            `uvm_info(get_type_name(),"modify rf cnt < current_start_time_inner !!!!", UVM_LOW)
            uvm_hdl_deposit("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.frame2array_u.rf_cnt", current_start_time_inner - delay_time);
        end
        2'b01: begin    //current_start_time < rf_cnt < current_period
            `uvm_info(get_type_name(),"modify rf cnt < current_period_inner !!!!", UVM_LOW)
            uvm_hdl_deposit("mc_tb.m_mc_subsys_top.mc_wrapper_aux_u.mc_top_u.frame2array_u.rf_cnt", current_period_inner - delay_time);
        end
        default: begin    //not exist
            `uvm_error(get_type_name(),"current_period < current_start_time")
        end
    endcase
endtask : modify_rf_cnt

task mc_base_vseq::tsk_rd_frm_arr_chk();
    bit[`MC_RDATA_WIDTH-1:0]        b_frm_rdata;
    bit[`MC_RDATA_WIDTH-1:0]        b_frm_rdata_tmp;
    bit[`ARRAY_DATA_WIDTH-1:0]      b_ary_read_data;
    bit[`ARRAY_DATA_WIDTH-1:0]      b_ary_rdata;
    bit[`ARRAY_DATA_WIDTH-1:0]      qb_ary_rdata[$];
    fork
        forever begin       //array rd data
            @(posedge m_array_agent_if.rdrdy_n);
            b_ary_rdata = m_array_agent_if.rdl;
            qb_ary_rdata.push_back(b_ary_rdata);
        end
        forever begin       //frame rd data
            @(posedge m_frame_agent_if.clk);
            if(m_frame_agent_if.mc_rvalid) begin
                b_frm_rdata_tmp = m_frame_agent_if.mc_rdata;
                if(m_tb_if.invert_en)
                     b_frm_rdata = {b_frm_rdata_tmp[15:0], b_frm_rdata_tmp[271:16]};
                else
                    b_frm_rdata = b_frm_rdata_tmp;

                b_ary_read_data = qb_ary_rdata.pop_front();
                if(b_ary_read_data != b_frm_rdata)
                    `uvm_error("", $sformatf("frame2array rdata fail. frm: %68h, ary: %68h", b_frm_rdata, b_ary_read_data))
                else
                    `uvm_info("", $sformatf("frame2array rdata pass. %68h", b_frm_rdata), UVM_MEDIUM)
            end
        end
    join_none
endtask : tsk_rd_frm_arr_chk

task mc_base_vseq::tsk_wr_rd_arr_chk();
    bit[21:0]           b_wr_addr;
    bit[21:0]           b_rd_addr_cmd;
    bit[21:0]           b_rd_addr;
    bit[21:0]           qb_rd_addr[$];
    bit[271:0]          b_rd_data;
    fork
        forever begin       //wr
            @(posedge m_array_agent_if.clk);
            if((|m_array_agent_if.gcas_wr) == 1 && m_array_agent_if.bnksel_n != 0) begin
                b_wr_addr = {m_array_agent_if.bnksel_n, m_array_agent_if.gradd_n, m_array_agent_if.gcadd};
                mb_wr_data_store[b_wr_addr] = m_array_agent_if.wdl;
                //`uvm_info("", $sformatf("array write. addr: %0h, wdata: %68h", b_wr_addr, mb_wr_data_store[b_wr_addr]), UVM_MEDIUM)
            end
        end
        forever begin       //rd addr
            @(posedge m_array_agent_if.clk);
            if((|m_array_agent_if.gcas_rd) == 1) begin
                b_rd_addr_cmd = {m_array_agent_if.bnksel_n, m_array_agent_if.gradd_n, m_array_agent_if.gcadd};
                qb_rd_addr.push_back(b_rd_addr_cmd);
            end
        end
        forever begin       //rd data
            @(posedge m_array_agent_if.rdrdy_n);
            b_rd_data = m_array_agent_if.rdl;
            b_rd_addr = qb_rd_addr.pop_front();

            if(mb_wr_data_store[b_rd_addr] != b_rd_data)
                `uvm_error("", $sformatf("array rdata fail. addr: %0h, wr: %0h, rd: %0h", b_rd_addr, mb_wr_data_store[b_rd_addr], b_rd_data))
            else
                `uvm_info("", $sformatf("array rdata pass. addr: %0h, data: %68h", b_rd_addr, b_rd_data), UVM_MEDIUM)
        end
    join_none
endtask : tsk_wr_rd_arr_chk
`endif //MC_BASE_VSEQ_SV
