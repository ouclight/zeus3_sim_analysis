
`ifndef FRAME_AGENT_DRIVER_SV
`define FRAME_AGENT_DRIVER_SV

class frame_agent_driver extends uvm_driver #(frame_agent_trans);
    `uvm_component_utils(frame_agent_driver)

    virtual interface  frame_agent_if vif;
    uvm_analysis_port #(frame_agent_trans) ap;
    bit                     rst_flag=0;
    real                    real_time;
    frame_item_config       item_cfg;
    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    extern task reset_phase(uvm_phase phase);    
    extern task do_drive(frame_agent_trans req);

    extern task initial_config();//initial all input signals and wait reset release
endclass : frame_agent_driver

function frame_agent_driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void frame_agent_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap",this);
endfunction : build_phase

function void frame_agent_driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (!uvm_config_db #(virtual frame_agent_if)::get(this, "*", "frame_agent_vif", vif))
        `uvm_error("NOVIF", {"virtual interface must be set for: ",get_full_name(),".vif"})

endfunction : connect_phase

task frame_agent_driver::initial_config(); 
    vif.mc_frame_vld    <=  0;
    //vif.mc_frame_rdy    <=  0;
    vif.mc_frame_data   <=  0;
    //vif.mc_bresp_vld    <=  0;
    vif.mc_bresp_rdy    <=  1;
    //vif.mc_bresp        <=  0;
    //vif.mc_rvalid       <=  0;
    //vif.mc_rdata        <=  0;
    //wait reset release
    @(posedge vif.rst_n);
endtask

task frame_agent_driver::reset_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "reset_phase", UVM_HIGH)
    super.reset_phase(phase);
    

endtask : reset_phase



task frame_agent_driver::main_phase(uvm_phase phase);
    //wait seq set
    if(item_cfg == null) begin
        if(!uvm_config_db#(frame_item_config)::get(this, "", "item_cfg", item_cfg))
        begin
            //`uvm_warning("NOCONFIG", "item config not set for driver, using default")
            item_cfg = frame_item_config::type_id::create("item_cfg", this);
        end
    end

    fork
        forever begin
            wait(rst_flag==0);
            seq_item_port.get_next_item(req);
            rst_flag=1;
            `uvm_info(get_type_name(), {"req item\n",req.sprint}, UVM_MEDIUM)

            do_drive(req);
            //`uvm_info(get_type_name(), $sformatf("aaaaa,rst_flag=%0d",rst_flag), UVM_MEDIUM)
            //rsp = new("rsp");
            //$cast(rsp, req.clone());
            //rsp.set_id_info(req);
            //seq_item_port.put_response(rsp);

            //if(!req.mc_frame_data[279]) begin       //read
            //    `uvm_info(get_type_name(), $sformatf("aaaaa,rst_flag=%0d",rst_flag), UVM_MEDIUM)
            //    rsp = new("rsp");
            //    @(posedge vif.mc_rvalid);
            //    req.mc_rvalid= vif.mc_rvalid;
            //    req.mc_rdata = vif.mc_rdata;
            //    $cast(rsp, req.clone());
            //    rsp.set_id_info(req);
            //    seq_item_port.put_response(rsp);
            //end
            if (1==rst_flag)
                seq_item_port.item_done();
            rst_flag=0;
        end 
        while(1)begin
            if(vif.rst_n==1)begin
                if (vif.performance_test_en==1)begin
                    #1ps;vif.mc_bresp_rdy <=1;
                    //repeat(1) @(posedge vif.clk);                    
                end
                else begin
                    //assert(item_cfg.randomize());  
                    //repeat(item_cfg.bresp_rdy_interval) @(posedge vif.clk);
                    vif.mc_bresp_rdy <= 1 ; 
                    @(posedge vif.clk);
                    //#0.001;vif.mc_bresp_rdy <= 0 ;
                end
                //////if(vif.rst_n==1)begin
                //////    assert(item_cfg.randomize());
                //////    vif.mc_bresp_rdy <=1;
                //////    @(posedge vif.clk);
                //////    while(vif.mc_bresp_vld !==1'b1)begin
                //////        if(vif.rst_n!=1) break;
                //////        @(posedge vif.clk);
                //////        `uvm_info(get_type_name(), $sformatf("aaaaa,mc_bresp_vld !=1"), UVM_HIGH)
                //////    end
                //////    #0.001;vif.mc_bresp_rdy <=0;
                //////    `uvm_info(get_type_name(), $sformatf("aaaaa,frame_vld_interval=%0d", item_cfg.bresp_rdy_interval), UVM_HIGH) 
                //////    if(vif.performance_test_en == 0)
                //////        repeat(item_cfg.bresp_rdy_interval) @(posedge vif.clk);
                //////end
            end
            else begin
                @(posedge vif.clk);
            end
        end
        while(1)begin
            if(vif.rst_n==0) begin
                if (1==rst_flag)begin
                    rst_flag=0;                        
                    seq_item_port.item_done();
                    //stop_sequences();
                end
                initial_config();
            end
            else
                @(posedge vif.clk);            
        end
    join
endtask : main_phase

task frame_agent_driver::do_drive(frame_agent_trans req);
    begin  //send addr
        if(vif.rst_n==1) begin
            assert(item_cfg.randomize());
            if(real_time!=$realtime)
                @(posedge vif.clk);
            #1ps;
            vif.mc_frame_vld   <=   1'b1;
            vif.mc_frame_data  <=   req.mc_frame_data;
            @(posedge vif.clk);            
            while(vif.mc_frame_rdy!==1'b1)begin
                if(vif.rst_n!=1) break;
                @(posedge vif.clk);
                `uvm_info(get_type_name(), $sformatf("aaaaa,mc_frame_rdy !=1"), UVM_HIGH)
            end
            #1ps;
            vif.mc_frame_vld <= 1'b0;
            real_time = $realtime;
            `uvm_info(get_type_name(), $sformatf("aaaaa,frame_vld_interval=%0d", item_cfg.frame_vld_interval), UVM_HIGH) 
            if(vif.performance_test_en == 0)
                repeat(item_cfg.frame_vld_interval) @(posedge vif.clk);
        end
        else @(posedge vif.clk);
    end     
endtask : do_drive

`endif // FRAME_AGENT_DRIVER_SV


