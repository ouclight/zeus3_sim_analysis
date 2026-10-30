//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : mc_reg_vseq.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 27 16:55:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef MC_REG_VSEQ
`define MC_REG_VSEQ

class mc_reg_vseq extends mc_common_vseq;
    
    ral_sys_mc_wrapper          mc_soc_regmodel;
    
    bit     [31:0]                  rdata;
    bit     [`APB_ADDR_WIDTH-1:0]                  offset_addr        ;
    rand bit    [19:0]              rand_offset_cnt ;
    `uvm_object_utils(mc_reg_vseq)
    rand bit    [31:0]              soc_ro_reg_addr;
    function new(string name="mc_reg_vseq");
        super.new(name);
    endfunction
    constraint soc_ro_reg_addr_c {soc_ro_reg_addr inside{0,32'h12c,[32'h134:32'h254],32'h264,32'h268,32'h274,[32'h290:32'h2f0]};soc_ro_reg_addr%4==0;} 
    function ral_sys_mc_wrapper get_mc_soc_regmodel();
        $cast(mc_soc_regmodel,p_sequencer.mc_soc_regmodel);
        return mc_soc_regmodel;
    endfunction

virtual task body();
        
    uvm_reg_hw_reset_seq          reg_reset_seq;
    uvm_reg_bit_bash_seq          reg_bit_seq;
    uvm_reg_access_seq            reg_access_seq;
        
    reg_reset_seq = uvm_reg_hw_reset_seq::type_id::create("reg_reset_seq");
    reg_bit_seq = uvm_reg_bit_bash_seq::type_id::create("reg_bit_seq");
    reg_access_seq = uvm_reg_access_seq::type_id::create("reg_access_seq");
    mc_soc_regmodel  =   get_mc_soc_regmodel();
    super.body();
    assert(randomize());

    p_sequencer.m_tb_if.reset_vseq=1'b1; 
    p_sequencer.mc_soc_regmodel.MC_WRAPPER_ins.mc_work_ctrl_reg.mc_en.write(status,1'h0, UVM_FRONTDOOR);
    `uvm_info(get_type_name(),"body===========start===========",UVM_LOW);
    if(p_sequencer.m_tb_if.rst_ongoing_flag == 0)begin
        //reset seq
        reg_reset_seq.model = mc_soc_regmodel;
        reg_reset_seq.start(p_sequencer.p_svt_apb_master_sqr[0]);
        reg_reset_seq.model = mc_soc_regmodel;
        reg_reset_seq.start(p_sequencer.p_svt_apb_master_sqr[1]);
        `uvm_info(get_type_name(),"reg_reset_seq done",UVM_LOW);
        
        //bit seq
        #100ns;
        reg_bit_seq.model = mc_soc_regmodel;
        reg_bit_seq.start(p_sequencer.p_svt_apb_master_sqr[0]);
        reg_bit_seq.model = mc_soc_regmodel;
        reg_bit_seq.start(p_sequencer.p_svt_apb_master_sqr[1]);
        `uvm_info(get_type_name(),"reg_bit_seq done",UVM_LOW);
        
        //access seq
        #100ns;
        reg_access_seq.model = mc_soc_regmodel;
        reg_access_seq.start(p_sequencer.p_svt_apb_master_sqr[0]);
        reg_access_seq.model = mc_soc_regmodel;
        reg_access_seq.start(p_sequencer.p_svt_apb_master_sqr[1]);
        `uvm_info(get_type_name(),"reg_access_seq done",UVM_LOW);
        
        
        reg_reset_seq.model = mc_soc_regmodel;
        reg_reset_seq.start(p_sequencer.p_svt_apb_master_sqr[0]);
        reg_reset_seq.model = mc_soc_regmodel;
        reg_reset_seq.start(p_sequencer.p_svt_apb_master_sqr[1]);
        `uvm_info(get_type_name(),"reg_reset_seq done",UVM_LOW);
        uvm_hdl_deposit("mc_tb.apb_rst_n",0);//should add right reset signal
        #100ns;
        uvm_hdl_deposit("mc_tb.apb_rst_n",1);//should add right reset signal
        //reset seq
        reg_reset_seq.model = mc_soc_regmodel;
        reg_reset_seq.start(p_sequencer.p_svt_apb_master_sqr[0]);
        reg_reset_seq.model = mc_soc_regmodel;
        reg_reset_seq.start(p_sequencer.p_svt_apb_master_sqr[1]);
        `uvm_info(get_type_name(),"reg_reset_seq done",UVM_LOW);
        
        
    end
    `uvm_info(get_type_name(),"body=====apb_write======start===========",UVM_LOW);
    #1us; 
    ////******SOC_APB*******
    fork
        begin
            randomize(rand_offset_cnt) with {rand_offset_cnt inside {[1:354]};}; 
            offset_addr = 32'h274+rand_offset_cnt*'h4;
            `uvm_info(get_type_name(),$sformatf("rand_offset_cnt =%0d,offset_addr =%0h",rand_offset_cnt,offset_addr),UVM_LOW);

            apb_write('b1,0,offset_addr,32'h1234_5678);
            apb_read('b1,0,offset_addr,rdata);
        end
        forever begin
            @(posedge p_sequencer.m_tb_if.pclk);
            if(p_sequencer.m_tb_if.soc_penable === 1'b1 && p_sequencer.m_tb_if.soc_psel[0] === 1'b1)begin
                if(p_sequencer.m_tb_if.soc_slverr[0] === 1'b1)begin
                    `uvm_info(get_type_name(),"soc slave_error is expect",UVM_LOW)
                end
                else begin
                    `uvm_error(get_type_name(),"soc slave_error is not expect")
                end
            end
        end
    join_any
    disable fork;
    fork
        begin
            offset_addr = soc_ro_reg_addr;
            `uvm_info(get_type_name(),$sformatf("soc_ro_reg_addr =%0h",soc_ro_reg_addr),UVM_LOW);
            apb_write('b1,0,offset_addr,32'h1234_5678);
        end
        forever begin
            @(posedge p_sequencer.m_tb_if.pclk);
            if(p_sequencer.m_tb_if.soc_penable === 1'b1 && p_sequencer.m_tb_if.soc_psel[0] === 1'b1)begin
                if(p_sequencer.m_tb_if.soc_slverr[0] === 1'b1)begin
                    `uvm_info(get_type_name(),"soc slave_error is expect",UVM_LOW)
                end
                else begin
                    `uvm_error(get_type_name(),"soc slave_error is not expect")
                end
            end
        end
    join_any
    disable fork;
    //`uvm_info(get_type_name(),$sformatf("rdata =%0h",rdata),UVM_LOW);
    //if(rdata != 32'h44454144)begin
    //    `uvm_error(get_type_name(), $sformatf("apb access illegal addr,rdata not equal exp,rdata=0x%0h",rdata))
    //end

endtask

virtual task dut_reset(int n=1);

    uvm_hdl_force("mc_tb.apb_rst_n",0);//should add right reset signal
    repeat(n)@(posedge p_sequencer.m_svt_apb_if[0].pclk);
    uvm_hdl_release("mc_tb.apb_rst_n");//should add right reset signal
    uvm_hdl_force("mc_tb.apb_rst_n",1);//should add right reset signal
endtask

endclass


`endif
