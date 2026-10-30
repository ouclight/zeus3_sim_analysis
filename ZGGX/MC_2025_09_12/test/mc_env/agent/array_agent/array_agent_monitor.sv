`ifndef ARRAY_AGENT_MONITOR_SV
`define ARRAY_AGENT_MONITOR_SV

class array_agent_monitor extends uvm_monitor;
    `uvm_component_utils(array_agent_monitor)

    virtual interface  array_agent_if vif;
    virtual interface  tb_if          m_tb_if;
    uvm_analysis_port #(array_agent_trans) ap;

    logic   [`ROW_ADDR_WIDTH-1:0]                       array_raddr_row[$];    
    logic   [`COLUMN_ADDR_WIDTH-1:0]                    array_raddr_col[$];
    logic   [`ARRAY_DATA_WIDTH-1:0]                     array_wdata[$];
    logic                                               array_rdcmd[$];
    logic   [`BANK_ADDR_WIDTH-1:0]                      array_raddr_bank_sel[$];

    //array_agent_trans m_trans;

    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);    
    extern task main_phase(uvm_phase phase);
    extern task reset_phase(uvm_phase phase);
    extern task do_mon();

endclass : array_agent_monitor 

function array_agent_monitor::new(string name, uvm_component parent);

    super.new(name, parent);
    ap = new("ap", this);

endfunction : new

function void array_agent_monitor::build_phase(uvm_phase phase);

    super.build_phase(phase);

endfunction : build_phase

task array_agent_monitor::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info("array_agent_monitor", "array_agent_monitor reset_phase_start!!!", UVM_MEDIUM);    
    phase.raise_objection(this);
    `uvm_info("array_agent_monitor", "array_agent_monitor reset_phase_end!!!", UVM_MEDIUM); 
    //@(posedge m_xocc_if.all_rstn_and)
    phase.drop_objection(this);
endtask : reset_phase

function void array_agent_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (!uvm_config_db #(virtual array_agent_if)::get(this, "*", "array_agent_vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
    
    if(!uvm_config_db#(virtual tb_if)::get(this, "", "vif_tb", m_tb_if)) begin
        `uvm_fatal("GETINTF", {"Could not get m_tb_if at ", get_full_name()})
    end
    
endfunction : connect_phase

task array_agent_monitor::main_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "main_phase", UVM_HIGH)

    //m_trans = array_agent_trans::type_id::create("m_trans");
    while(1) begin
        fork
            begin
                do_mon();
                //`uvm_info(get_type_name(), $sformatf("debug mc_en"), UVM_LOW)
                array_raddr_row.delete();
                array_raddr_col.delete();
                array_wdata.delete();
                array_rdcmd.delete();
                array_raddr_bank_sel.delete();
            end
            //while (1) begin
            //    @(negedge m_tb_if.mc_en)
            //    `uvm_info(get_type_name(), $sformatf("debug mc_en"), UVM_LOW)
            //    array_raddr_row.delete();
            //    array_raddr_col.delete();
            //    array_wdata.delete();
            //    array_rdcmd.delete();
            //end
        join
        //`uvm_info(get_type_name(), $sformatf("debug test"), UVM_LOW)
    end
    
endtask : main_phase

task array_agent_monitor::do_mon();
    
    array_agent_trans       m_trans1,m_trans0;
    bit dram_init_finish=0;
    `uvm_info(get_type_name(), $sformatf("array_do_mon start"), UVM_MEDIUM)
    `ifndef NO_INIT

    /*while(mc_dram_init_wr_finish==0 || m_tb_if.mc_en==0)begin
        uvm_hdl_read("mc_tb.m_mc_wrapper_aux.mc_top_u.dram_init_wr_aux_u.mc_dram_init_finish",dram_init_finish);
        @(posedge vif.clk);
    end*/
    wait(m_tb_if.mc_dram_init_wr_finish ==1 && m_tb_if.mc_en ==1);
    repeat(2) @(posedge vif.clk);
    //`uvm_info("init debug", $sformatf("init finsh check end" ),UVM_LOW)
    `endif

    fork :init
        while(1)begin //wdata
            wait(vif.rst_n===1);
            @(posedge vif.clk);
            #1ps;
            //while(vif.wrrdy_n!==0)begin
            while((|vif.gcas_wr)!==1)begin
                @(posedge vif.clk);
                #1ps;
            end
            array_wdata.push_back(vif.wdl);
            `uvm_info(get_type_name(), $sformatf("wdl=0x%h",vif.wdl), UVM_MEDIUM)                        
        end


        while(1)begin //waddr
            wait(vif.rst_n===1);
            @(posedge vif.clk);
            #1ps;
            while((|vif.gcas_wr)!==1)begin
                @(posedge vif.clk) ;
                #1ps;
            end
            m_trans0 = new();
            `uvm_info(get_type_name(), $sformatf("write one write_trans to scoreborad--radd=0x%h,cadd=0x%h",vif.gradd_n,vif.gcadd), UVM_MEDIUM)            
            m_trans0.bank_sel = {vif.bnksel_n};
            m_trans0.row_addr = vif.gradd_n;
            m_trans0.col_addr = vif.gcadd;
            m_trans0.wr_rd_cmd = 1'b1;
            m_trans0.wr_data = array_wdata.pop_front();
            if(!m_tb_if.xbank_en) begin
                if((vif.bnksel_n + vif.gcas_wr) !== 2'b11) `uvm_error(get_full_name(), $sformatf("bank_sel=%0h,gcas_wr=%0h",vif.bnksel_n,vif.gcas_wr));
            end

            if(vif.rst_n && (m_tb_if.bist_test_en==0))begin
                ap.write(m_trans0);
                `uvm_info(get_type_name(), $sformatf("write one write_trans to scoreborad--m_trans0.wr_data=0x%h",m_trans0.wr_data), UVM_MEDIUM)
                `uvm_info(get_type_name(), $sformatf("write one write_trans to scoreborad--row_addr=0x%h,col_addr=0x%h,data=0x%h",m_trans0.row_addr,m_trans0.col_addr,vif.wdl), UVM_MEDIUM)
            end
        end

        while(1)begin //raddr
            wait(vif.rst_n===1);    
            @(posedge vif.clk);
            #1ps;
            while((|vif.gcas_rd)!==1)begin
                @(posedge vif.clk) ;
                #1ps;
            end
            if(!m_tb_if.xbank_en) begin
                if((vif.bnksel_n + vif.gcas_rd) !== 2'b11) `uvm_error(get_full_name(), $sformatf("bank_sel=%0h,gcas_rd=%0h",vif.bnksel_n,vif.gcas_rd));
            end

            array_raddr_row.push_back(vif.gradd_n);
            array_raddr_col.push_back(vif.gcadd);
            array_raddr_bank_sel.push_back(vif.bnksel_n);
            `uvm_info(get_type_name(), $sformatf("array read information push back array_raddr,radd is 0x%h, cddr is 0x%h",vif.gradd_n,vif.gcadd), UVM_MEDIUM)
            array_rdcmd.push_back(1'b0);
        end

        while(1)begin //rdata
            wait(vif.rst_n===1);
            @(posedge vif.rdrdy_n);
            m_trans1 = new();
            m_trans1.bank_sel = array_raddr_bank_sel.pop_front;
            m_trans1.row_addr = array_raddr_row.pop_front;
            m_trans1.col_addr = array_raddr_col.pop_front;
            m_trans1.wr_rd_cmd = array_rdcmd.pop_front;
            m_trans1.rd_data = vif.rdl;
            if(vif.rst_n && (m_tb_if.bist_test_en==0))begin 
                ap.write(m_trans1);
                `uvm_info(get_type_name(), $sformatf("array write one read_trans to scoreborad--row_addr=0x%h,col_addr=0x%h,data=0x%h", m_trans1.row_addr,m_trans1.col_addr,vif.rdl), UVM_MEDIUM)
            end 
        end
        while(1)begin
            @(posedge vif.rst_n)
            array_raddr_row.delete();
            array_raddr_col.delete();
            array_wdata.delete();
            array_rdcmd.delete();
            array_raddr_bank_sel.delete();
            `uvm_info(get_type_name(), $sformatf("array rst to clean queue"), UVM_LOW)
        end
        while(1)begin
            `ifndef NO_INIT
                if (m_tb_if.mc_en==='b0) begin
                    `uvm_info(get_type_name(), $sformatf("disable"), UVM_LOW)
                    disable init;
                end
            `endif
            @(negedge m_tb_if.mc_en);
            `uvm_info(get_type_name(), $sformatf("disable"), UVM_LOW)
            disable init;
        end
    join

endtask : do_mon

function void array_agent_monitor::report_phase(uvm_phase phase);
     
    if(array_raddr_row.size > 0 || array_raddr_col.size > 0 || array_wdata.size > 0 || array_rdcmd.size >0)begin         
        `uvm_error(get_full_name(), $sformatf("array_raddr_row.size=%0d > 0 \n array_raddr_col.size=%0d > 0 \n array_wdata.size=%0d > 0 \n array_rdcmd.size=%0d > 0",array_raddr_row.size,array_raddr_col.size,array_wdata.size,array_rdcmd.size));
    end

endfunction

`endif // ARRAY_AGENT_MONITOR_SV


