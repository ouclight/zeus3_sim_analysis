module apb2reg_dram_trim_cfg_if #(
    parameter APB_ADDR_WIDTH = 8,
    parameter APB_DATA_WIDTH = 32
    )
    (
    // common input ports 
    input                               pclk,
    input                               presetn,
    input                               psel,
    input                               penable,
    input    [APB_ADDR_WIDTH-1:0]       paddr,
    input                               pwrite,
    input    [APB_DATA_WIDTH-1:0]       pwdata,

    // special input port 
    // register name : trim_ctrl_id , address:0x0
    input  [31:0]                        trim_ctrl_id_i,// read only signal
    // register name : trim_global_ctrl , address:0x8
    input                        trim_finish_i,// read only signal
    // register name : trim_internal_status , address:0xc
    input                        spine_resetn_active_ready_i,// read only signal
    input                        tm_redump_active_ready_i,// read only signal
    input                        stopwatch_period_active_ready_i,// read only signal
    input                        init_done_flag_i,// read only signal
    input  [3:0]                        stopwatch_ringo_period_ready_i,// read only signal
    input  [3:0]                        dump_ready_i,// read only signal
    input  [3:0]                        dumpready_timeout_ready_i,// read only signal
    // register name : osc_tm_res_smp_value , address:0x58
    input  [7:0]                        osc_tm_res_smp_value_i,// read only signal
    input  [3:0]                        osc_tm_res_smp_ready_i,// read only signal
    // register name : stopwatch_ringo_period_01 , address:0x5c
    input  [9:0]                        stopwatch_ringo_period0_i,// read only signal
    input  [9:0]                        stopwatch_ringo_period1_i,// read only signal
    // register name : stopwatch_ringo_period_23 , address:0x60
    input  [9:0]                        stopwatch_ringo_period2_i,// read only signal
    input  [9:0]                        stopwatch_ringo_period3_i,// read only signal
    // register name : dumpready_timeout_ctrl , address:0x64
    input  [3:0]                        dumpready_timeout_flag_i,// read only signal
    // register name : ringo_timeout_ctrl , address:0x68
    input  [3:0]                        ringo_timeout_flag_i,// read only signal
    // register name : trim_interrupt_ctrl , address:0x70
    input                        trim_interrupt_flag_i,// read only signal
    // register name : hw_ringo_dram0_period_01 , address:0x74
    input  [9:0]                        hw_ringo_dram0_period0_i,// read only signal
    input  [9:0]                        hw_ringo_dram0_period1_i,// read only signal
    // register name : hw_ringo_dram0_period_23 , address:0x78
    input  [9:0]                        hw_ringo_dram0_period2_i,// read only signal
    input  [9:0]                        hw_ringo_dram0_period3_i,// read only signal
    // register name : hw_ringo_dram0_period_45 , address:0x7c
    input  [9:0]                        hw_ringo_dram0_period4_i,// read only signal
    input  [9:0]                        hw_ringo_dram0_period5_i,// read only signal
    // register name : hw_ringo_dram0_period_67 , address:0x80
    input  [9:0]                        hw_ringo_dram0_period6_i,// read only signal
    input  [9:0]                        hw_ringo_dram0_period7_i,// read only signal
    // register name : hw_ringo_dram1_period_01 , address:0x84
    input  [9:0]                        hw_ringo_dram1_period0_i,// read only signal
    input  [9:0]                        hw_ringo_dram1_period1_i,// read only signal
    // register name : hw_ringo_dram1_period_23 , address:0x88
    input  [9:0]                        hw_ringo_dram1_period2_i,// read only signal
    input  [9:0]                        hw_ringo_dram1_period3_i,// read only signal
    // register name : hw_ringo_dram1_period_45 , address:0x8c
    input  [9:0]                        hw_ringo_dram1_period4_i,// read only signal
    input  [9:0]                        hw_ringo_dram1_period5_i,// read only signal
    // register name : hw_ringo_dram1_period_67 , address:0x90
    input  [9:0]                        hw_ringo_dram1_period6_i,// read only signal
    input  [9:0]                        hw_ringo_dram1_period7_i,// read only signal
    // register name : hw_ringo_dram2_period_01 , address:0x94
    input  [9:0]                        hw_ringo_dram2_period0_i,// read only signal
    input  [9:0]                        hw_ringo_dram2_period1_i,// read only signal
    // register name : hw_ringo_dram2_period_23 , address:0x98
    input  [9:0]                        hw_ringo_dram2_period2_i,// read only signal
    input  [9:0]                        hw_ringo_dram2_period3_i,// read only signal
    // register name : hw_ringo_dram2_period_45 , address:0x9c
    input  [9:0]                        hw_ringo_dram2_period4_i,// read only signal
    input  [9:0]                        hw_ringo_dram2_period5_i,// read only signal
    // register name : hw_ringo_dram2_period_67 , address:0xa0
    input  [9:0]                        hw_ringo_dram2_period6_i,// read only signal
    input  [9:0]                        hw_ringo_dram2_period7_i,// read only signal
    // register name : hw_ringo_dram3_period_01 , address:0xa4
    input  [9:0]                        hw_ringo_dram3_period0_i,// read only signal
    input  [9:0]                        hw_ringo_dram3_period1_i,// read only signal
    // register name : hw_ringo_dram3_period_23 , address:0xa8
    input  [9:0]                        hw_ringo_dram3_period2_i,// read only signal
    input  [9:0]                        hw_ringo_dram3_period3_i,// read only signal
    // register name : hw_ringo_dram3_period_45 , address:0xac
    input  [9:0]                        hw_ringo_dram3_period4_i,// read only signal
    input  [9:0]                        hw_ringo_dram3_period5_i,// read only signal
    // register name : hw_ringo_dram3_period_67 , address:0xb0
    input  [9:0]                        hw_ringo_dram3_period6_i,// read only signal
    input  [9:0]                        hw_ringo_dram3_period7_i,// read only signal
    // register name : trim_debug0 , address:0xb4
    input  [3:0]                        sw_spine_reset_n_active_cnt_dbg_i,// read only signal
    input  [3:0]                        sw_tm_redump_active_cnt_dbg_i,// read only signal
    input  [3:0]                        sw_stopwatch_period_active_cnt_dbg_i,// read only signal
    input  [3:0]                        trim_start_cnt_dbg_i,// read only signal
    input  [3:0]                        spine_reset_n_dbg_i,// read only signal
    input  [3:0]                        tm_redump_edge_dbg_i,// read only signal
    input  [3:0]                        stopwatch_period_edge_dbg_i,// read only signal
    input  [3:0]                        stopwatch_ringo_edge_dbg_i,// read only signal
    // register name : trim_debug1 , address:0xb8
    input  [31:0]                        fsm_cs_flag_dbg0_i,// read only signal
    // register name : trim_debug2 , address:0xbc
    input                        fsm_cs_flag_dbg1_i,// read only signal
    input  [5:0]                        fsm_cs_dbg_i,// read only signal
 
    // W1C output ports
    // register name : trim_op_ctrl , address:0x4
    output reg spine_resetn_active_o,
    output reg tm_redump_active_o,
    output reg stopwatch_period_active_o,
    output reg trim_start_o,
    output reg init_start_o,
    // register name : dumpready_timeout_ctrl , address:0x64
    output reg dumpready_timeout_clr_o,
    // register name : ringo_timeout_ctrl , address:0x68
    output reg ringo_timeout_clr_o,
    // register name : trim_interrupt_ctrl , address:0x70
    output reg trim_interrupt_clr_o,

    // special output ports
    // register name : trim_global_ctrl , address:0x8
    output reg trim_op_flow_o,
    output reg hw_op_ringo_mask_o,
    output reg hw_op_tsv_load_sel_o,
    output reg [3:0] dram_layer_sel_o,
    output reg res_or_ringo_sel_o,
    output reg debug_en_o,
    // register name : init_spine_resetn_time , address:0x10
    output reg [27:0] init_spine_reset_time_o,
    // register name : spine_resetn_width , address:0x14
    output reg [9:0] spine_resetn_width_o,
    // register name : tm_redump_width , address:0x18
    output reg [9:0] tm_redump_width_o,
    // register name : stopwatch_period_width , address:0x1c
    output reg [15:0] stopwatch_period_width_res_o,
    output reg [15:0] stopwatch_period_width_ringo_o,
    // register name : redump_tsv_tm_other_value0 , address:0x20
    output reg [31:0] redump_tsv_tm_other_value0_o,
    // register name : redump_tsv_tm_other_value1 , address:0x24
    output reg [31:0] redump_tsv_tm_other_value1_o,
    // register name : redump_tsv_tm_other_value2 , address:0x28
    output reg [31:0] redump_tsv_tm_other_value2_o,
    // register name : redump_tsv_tm_other_value3 , address:0x2c
    output reg [31:0] redump_tsv_tm_other_value3_o,
    // register name : redump_tsv_tm_other_value4 , address:0x30
    output reg [31:0] redump_tsv_tm_other_value4_o,
    // register name : redump_tsv_tm_other_value5 , address:0x34
    output reg [31:0] redump_tsv_tm_other_value5_o,
    // register name : redump_tsv_tm_other_value6 , address:0x38
    output reg [31:0] redump_tsv_tm_other_value6_o,
    // register name : redump_tsv_tm_other_value7 , address:0x3c
    output reg [31:0] redump_tsv_tm_other_value7_o,
    // register name : redump_tsv_tm_other_value8 , address:0x40
    output reg [31:0] redump_tsv_tm_other_value8_o,
    // register name : redump_tsv_tm_other_value9 , address:0x44
    output reg [31:0] redump_tsv_tm_other_value9_o,
    // register name : redump_tsv_tm_other_value10 , address:0x48
    output reg [31:0] redump_tsv_tm_other_value10_o,
    // register name : redump_tsv_tm_other_value11 , address:0x4c
    output reg [31:0] redump_tsv_tm_other_value11_o,
    // register name : redump_tsv_tm_other_value12 , address:0x50
    output reg [31:0] redump_tsv_tm_other_value12_o,
    // register name : redump_tsv_tm_other_value13 , address:0x54
    output reg [11:0] redump_tsv_tm_other_value13_o,
    // register name : dumpready_timeout_ctrl , address:0x64
    output reg dumpready_timeout_en_o,
    output reg [23:0] dumpready_timeout_time_o,
    // register name : ringo_timeout_ctrl , address:0x68
    output reg ringo_timeout_en_o,
    output reg [23:0] ringo_timeout_time_o,
    // register name : res_value_ctrl , address:0x6c
    output reg [1:0] res_value_sel_o,
    output reg [7:0] res_cfg_value_o,
    // register name : trim_interrupt_ctrl , address:0x70
    output reg trim_interrupt_mask_o,
    // register name : hw_ringo_period_dly , address:0xc0
    output reg [13:0] hw_ringo_period_delay_o,
    // register name : hw_period2ringo_dly , address:0xc4
    output reg [9:0] hw_period2ringo_dly_o,
    // common output ports 
    output reg [APB_DATA_WIDTH-1:0]  prdata
    );

    //-------- regs --------
    reg [31:0] trim_ctrl_id_apb_dff;// read only signal
    reg trim_finish_apb_dff;// read only signal
    reg spine_resetn_active_ready_apb_dff;// read only signal
    reg tm_redump_active_ready_apb_dff;// read only signal
    reg stopwatch_period_active_ready_apb_dff;// read only signal
    reg init_done_flag_apb_dff;// read only signal
    reg [3:0] stopwatch_ringo_period_ready_apb_dff;// read only signal
    reg [3:0] dump_ready_apb_dff;// read only signal
    reg [3:0] dumpready_timeout_ready_apb_dff;// read only signal
    reg [7:0] osc_tm_res_smp_value_apb_dff;// read only signal
    reg [3:0] osc_tm_res_smp_ready_apb_dff;// read only signal
    reg [9:0] stopwatch_ringo_period0_apb_dff;// read only signal
    reg [9:0] stopwatch_ringo_period1_apb_dff;// read only signal
    reg [9:0] stopwatch_ringo_period2_apb_dff;// read only signal
    reg [9:0] stopwatch_ringo_period3_apb_dff;// read only signal
    reg [3:0] dumpready_timeout_flag_apb_dff;// read only signal
    reg [3:0] ringo_timeout_flag_apb_dff;// read only signal
    reg trim_interrupt_flag_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram0_period0_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram0_period1_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram0_period2_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram0_period3_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram0_period4_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram0_period5_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram0_period6_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram0_period7_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram1_period0_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram1_period1_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram1_period2_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram1_period3_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram1_period4_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram1_period5_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram1_period6_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram1_period7_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram2_period0_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram2_period1_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram2_period2_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram2_period3_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram2_period4_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram2_period5_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram2_period6_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram2_period7_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram3_period0_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram3_period1_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram3_period2_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram3_period3_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram3_period4_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram3_period5_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram3_period6_apb_dff;// read only signal
    reg [9:0] hw_ringo_dram3_period7_apb_dff;// read only signal
    reg [3:0] sw_spine_reset_n_active_cnt_dbg_apb_dff;// read only signal
    reg [3:0] sw_tm_redump_active_cnt_dbg_apb_dff;// read only signal
    reg [3:0] sw_stopwatch_period_active_cnt_dbg_apb_dff;// read only signal
    reg [3:0] trim_start_cnt_dbg_apb_dff;// read only signal
    reg [3:0] spine_reset_n_dbg_apb_dff;// read only signal
    reg [3:0] tm_redump_edge_dbg_apb_dff;// read only signal
    reg [3:0] stopwatch_period_edge_dbg_apb_dff;// read only signal
    reg [3:0] stopwatch_ringo_edge_dbg_apb_dff;// read only signal
    reg [31:0] fsm_cs_flag_dbg0_apb_dff;// read only signal
    reg fsm_cs_flag_dbg1_apb_dff;// read only signal
    reg [5:0] fsm_cs_dbg_apb_dff;// read only signal
    //-------  Wires ---------
    wire apb_write_sel ;
    wire apb_read_sel ;
    //read and write enable signals
    assign apb_write_sel    = psel &&  pwrite && (penable);
    assign apb_read_sel     = psel && (~pwrite) && (~penable);

    // register name : trim_global_ctrl , address:0x8
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            trim_op_flow_o <= 1'b0;
            hw_op_ringo_mask_o <= 1'b1;
            hw_op_tsv_load_sel_o <= 1'b0;
            dram_layer_sel_o <= 4'hF;
            res_or_ringo_sel_o <= 1'b0;
            debug_en_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 8'h8)) begin
            trim_op_flow_o <= pwdata[0];
            hw_op_ringo_mask_o <= pwdata[1];
            hw_op_tsv_load_sel_o <= pwdata[2];
            dram_layer_sel_o <= pwdata[7:4];
            res_or_ringo_sel_o <= pwdata[8];
            debug_en_o <= pwdata[9];
        end
    end
    // register name : init_spine_resetn_time , address:0x10
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            init_spine_reset_time_o <= 28'h7A11FF;
        end
        else if (apb_write_sel && (paddr == 8'h10)) begin
            init_spine_reset_time_o <= pwdata[27:0];
        end
    end
    // register name : spine_resetn_width , address:0x14
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            spine_resetn_width_o <= 10'h13;
        end
        else if (apb_write_sel && (paddr == 8'h14)) begin
            spine_resetn_width_o <= pwdata[9:0];
        end
    end
    // register name : tm_redump_width , address:0x18
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            tm_redump_width_o <= 10'h3;
        end
        else if (apb_write_sel && (paddr == 8'h18)) begin
            tm_redump_width_o <= pwdata[9:0];
        end
    end
    // register name : stopwatch_period_width , address:0x1c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            stopwatch_period_width_res_o <= 16'h18F;
            stopwatch_period_width_ringo_o <= 16'h3;
        end
        else if (apb_write_sel && (paddr == 8'h1c)) begin
            stopwatch_period_width_res_o <= pwdata[15:0];
            stopwatch_period_width_ringo_o <= pwdata[31:16];
        end
    end
    // register name : redump_tsv_tm_other_value0 , address:0x20
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value0_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 8'h20)) begin
            redump_tsv_tm_other_value0_o <= pwdata[31:0];
        end
    end
    // register name : redump_tsv_tm_other_value1 , address:0x24
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value1_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 8'h24)) begin
            redump_tsv_tm_other_value1_o <= pwdata[31:0];
        end
    end
    // register name : redump_tsv_tm_other_value2 , address:0x28
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value2_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 8'h28)) begin
            redump_tsv_tm_other_value2_o <= pwdata[31:0];
        end
    end
    // register name : redump_tsv_tm_other_value3 , address:0x2c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value3_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 8'h2c)) begin
            redump_tsv_tm_other_value3_o <= pwdata[31:0];
        end
    end
    // register name : redump_tsv_tm_other_value4 , address:0x30
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value4_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 8'h30)) begin
            redump_tsv_tm_other_value4_o <= pwdata[31:0];
        end
    end
    // register name : redump_tsv_tm_other_value5 , address:0x34
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value5_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 8'h34)) begin
            redump_tsv_tm_other_value5_o <= pwdata[31:0];
        end
    end
    // register name : redump_tsv_tm_other_value6 , address:0x38
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value6_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 8'h38)) begin
            redump_tsv_tm_other_value6_o <= pwdata[31:0];
        end
    end
    // register name : redump_tsv_tm_other_value7 , address:0x3c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value7_o <= 32'h598000;
        end
        else if (apb_write_sel && (paddr == 8'h3c)) begin
            redump_tsv_tm_other_value7_o <= pwdata[31:0];
        end
    end
    // register name : redump_tsv_tm_other_value8 , address:0x40
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value8_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 8'h40)) begin
            redump_tsv_tm_other_value8_o <= pwdata[31:0];
        end
    end
    // register name : redump_tsv_tm_other_value9 , address:0x44
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value9_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 8'h44)) begin
            redump_tsv_tm_other_value9_o <= pwdata[31:0];
        end
    end
    // register name : redump_tsv_tm_other_value10 , address:0x48
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value10_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 8'h48)) begin
            redump_tsv_tm_other_value10_o <= pwdata[31:0];
        end
    end
    // register name : redump_tsv_tm_other_value11 , address:0x4c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value11_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 8'h4c)) begin
            redump_tsv_tm_other_value11_o <= pwdata[31:0];
        end
    end
    // register name : redump_tsv_tm_other_value12 , address:0x50
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value12_o <= 32'h0;
        end
        else if (apb_write_sel && (paddr == 8'h50)) begin
            redump_tsv_tm_other_value12_o <= pwdata[31:0];
        end
    end
    // register name : redump_tsv_tm_other_value13 , address:0x54
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            redump_tsv_tm_other_value13_o <= 12'h0;
        end
        else if (apb_write_sel && (paddr == 8'h54)) begin
            redump_tsv_tm_other_value13_o <= pwdata[11:0];
        end
    end
    // register name : dumpready_timeout_ctrl , address:0x64
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            dumpready_timeout_en_o <= 1'b1;
            dumpready_timeout_time_o <= 24'hC3500;
        end
        else if (apb_write_sel && (paddr == 8'h64)) begin
            dumpready_timeout_en_o <= pwdata[0];
            dumpready_timeout_time_o <= pwdata[31:8];
        end
    end
    // register name : ringo_timeout_ctrl , address:0x68
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            ringo_timeout_en_o <= 1'b1;
            ringo_timeout_time_o <= 24'hBB8;
        end
        else if (apb_write_sel && (paddr == 8'h68)) begin
            ringo_timeout_en_o <= pwdata[0];
            ringo_timeout_time_o <= pwdata[31:8];
        end
    end
    // register name : res_value_ctrl , address:0x6c
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            res_value_sel_o <= 2'h0;
            res_cfg_value_o <= 8'h0;
        end
        else if (apb_write_sel && (paddr == 8'h6c)) begin
            res_value_sel_o <= pwdata[1:0];
            res_cfg_value_o <= pwdata[11:4];
        end
    end
    // register name : trim_interrupt_ctrl , address:0x70
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            trim_interrupt_mask_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 8'h70)) begin
            trim_interrupt_mask_o <= pwdata[1];
        end
    end
    // register name : hw_ringo_period_dly , address:0xc0
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hw_ringo_period_delay_o <= 14'h5;
        end
        else if (apb_write_sel && (paddr == 8'hc0)) begin
            hw_ringo_period_delay_o <= pwdata[13:0];
        end
    end
    // register name : hw_period2ringo_dly , address:0xc4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hw_period2ringo_dly_o <= 10'h78;
        end
        else if (apb_write_sel && (paddr == 8'hc4)) begin
            hw_period2ringo_dly_o <= pwdata[9:0];
        end
    end
    // read register
    //when read a WO signal, will give it 0.
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0)
            prdata <= {APB_DATA_WIDTH{1'b0}};// default value is 0
        else
            if(apb_read_sel) begin
                case(paddr)
                8'h0: //register name:trim_ctrl_id,address:0x0
                prdata <= {trim_ctrl_id_apb_dff};
                8'h4: //register name:trim_op_ctrl,address:0x4
                prdata <= {27'h0,init_start_o,trim_start_o,stopwatch_period_active_o,tm_redump_active_o,spine_resetn_active_o};
                8'h8: //register name:trim_global_ctrl,address:0x8
                prdata <= {19'h0,trim_finish_apb_dff,2'h0,debug_en_o,res_or_ringo_sel_o,dram_layer_sel_o,1'h0,hw_op_tsv_load_sel_o,hw_op_ringo_mask_o,trim_op_flow_o};
                8'hc: //register name:trim_internal_status,address:0xc
                prdata <= {16'h0,dumpready_timeout_ready_apb_dff,dump_ready_apb_dff,stopwatch_ringo_period_ready_apb_dff,init_done_flag_apb_dff,stopwatch_period_active_ready_apb_dff,tm_redump_active_ready_apb_dff,spine_resetn_active_ready_apb_dff};
                8'h10: //register name:init_spine_resetn_time,address:0x10
                prdata <= {4'h0,init_spine_reset_time_o};
                8'h14: //register name:spine_resetn_width,address:0x14
                prdata <= {22'h0,spine_resetn_width_o};
                8'h18: //register name:tm_redump_width,address:0x18
                prdata <= {22'h0,tm_redump_width_o};
                8'h1c: //register name:stopwatch_period_width,address:0x1c
                prdata <= {stopwatch_period_width_ringo_o,stopwatch_period_width_res_o};
                8'h20: //register name:redump_tsv_tm_other_value0,address:0x20
                prdata <= {redump_tsv_tm_other_value0_o};
                8'h24: //register name:redump_tsv_tm_other_value1,address:0x24
                prdata <= {redump_tsv_tm_other_value1_o};
                8'h28: //register name:redump_tsv_tm_other_value2,address:0x28
                prdata <= {redump_tsv_tm_other_value2_o};
                8'h2c: //register name:redump_tsv_tm_other_value3,address:0x2c
                prdata <= {redump_tsv_tm_other_value3_o};
                8'h30: //register name:redump_tsv_tm_other_value4,address:0x30
                prdata <= {redump_tsv_tm_other_value4_o};
                8'h34: //register name:redump_tsv_tm_other_value5,address:0x34
                prdata <= {redump_tsv_tm_other_value5_o};
                8'h38: //register name:redump_tsv_tm_other_value6,address:0x38
                prdata <= {redump_tsv_tm_other_value6_o};
                8'h3c: //register name:redump_tsv_tm_other_value7,address:0x3c
                prdata <= {redump_tsv_tm_other_value7_o};
                8'h40: //register name:redump_tsv_tm_other_value8,address:0x40
                prdata <= {redump_tsv_tm_other_value8_o};
                8'h44: //register name:redump_tsv_tm_other_value9,address:0x44
                prdata <= {redump_tsv_tm_other_value9_o};
                8'h48: //register name:redump_tsv_tm_other_value10,address:0x48
                prdata <= {redump_tsv_tm_other_value10_o};
                8'h4c: //register name:redump_tsv_tm_other_value11,address:0x4c
                prdata <= {redump_tsv_tm_other_value11_o};
                8'h50: //register name:redump_tsv_tm_other_value12,address:0x50
                prdata <= {redump_tsv_tm_other_value12_o};
                8'h54: //register name:redump_tsv_tm_other_value13,address:0x54
                prdata <= {20'h0,redump_tsv_tm_other_value13_o};
                8'h58: //register name:osc_tm_res_smp_value,address:0x58
                prdata <= {20'h0,osc_tm_res_smp_ready_apb_dff,osc_tm_res_smp_value_apb_dff};
                8'h5c: //register name:stopwatch_ringo_period_01,address:0x5c
                prdata <= {6'h0,stopwatch_ringo_period1_apb_dff,6'h0,stopwatch_ringo_period0_apb_dff};
                8'h60: //register name:stopwatch_ringo_period_23,address:0x60
                prdata <= {6'h0,stopwatch_ringo_period3_apb_dff,6'h0,stopwatch_ringo_period2_apb_dff};
                8'h64: //register name:dumpready_timeout_ctrl,address:0x64
                prdata <= {dumpready_timeout_time_o,dumpready_timeout_flag_apb_dff,2'h0,dumpready_timeout_clr_o,dumpready_timeout_en_o};
                8'h68: //register name:ringo_timeout_ctrl,address:0x68
                prdata <= {ringo_timeout_time_o,ringo_timeout_flag_apb_dff,2'h0,ringo_timeout_clr_o,ringo_timeout_en_o};
                8'h6c: //register name:res_value_ctrl,address:0x6c
                prdata <= {20'h0,res_cfg_value_o,2'h0,res_value_sel_o};
                8'h70: //register name:trim_interrupt_ctrl,address:0x70
                prdata <= {29'h0,trim_interrupt_flag_apb_dff,trim_interrupt_mask_o,trim_interrupt_clr_o};
                8'h74: //register name:hw_ringo_dram0_period_01,address:0x74
                prdata <= {6'h0,hw_ringo_dram0_period1_apb_dff,6'h0,hw_ringo_dram0_period0_apb_dff};
                8'h78: //register name:hw_ringo_dram0_period_23,address:0x78
                prdata <= {6'h0,hw_ringo_dram0_period3_apb_dff,6'h0,hw_ringo_dram0_period2_apb_dff};
                8'h7c: //register name:hw_ringo_dram0_period_45,address:0x7c
                prdata <= {6'h0,hw_ringo_dram0_period5_apb_dff,6'h0,hw_ringo_dram0_period4_apb_dff};
                8'h80: //register name:hw_ringo_dram0_period_67,address:0x80
                prdata <= {6'h0,hw_ringo_dram0_period7_apb_dff,6'h0,hw_ringo_dram0_period6_apb_dff};
                8'h84: //register name:hw_ringo_dram1_period_01,address:0x84
                prdata <= {6'h0,hw_ringo_dram1_period1_apb_dff,6'h0,hw_ringo_dram1_period0_apb_dff};
                8'h88: //register name:hw_ringo_dram1_period_23,address:0x88
                prdata <= {6'h0,hw_ringo_dram1_period3_apb_dff,6'h0,hw_ringo_dram1_period2_apb_dff};
                8'h8c: //register name:hw_ringo_dram1_period_45,address:0x8c
                prdata <= {6'h0,hw_ringo_dram1_period5_apb_dff,6'h0,hw_ringo_dram1_period4_apb_dff};
                8'h90: //register name:hw_ringo_dram1_period_67,address:0x90
                prdata <= {6'h0,hw_ringo_dram1_period7_apb_dff,6'h0,hw_ringo_dram1_period6_apb_dff};
                8'h94: //register name:hw_ringo_dram2_period_01,address:0x94
                prdata <= {6'h0,hw_ringo_dram2_period1_apb_dff,6'h0,hw_ringo_dram2_period0_apb_dff};
                8'h98: //register name:hw_ringo_dram2_period_23,address:0x98
                prdata <= {6'h0,hw_ringo_dram2_period3_apb_dff,6'h0,hw_ringo_dram2_period2_apb_dff};
                8'h9c: //register name:hw_ringo_dram2_period_45,address:0x9c
                prdata <= {6'h0,hw_ringo_dram2_period5_apb_dff,6'h0,hw_ringo_dram2_period4_apb_dff};
                8'ha0: //register name:hw_ringo_dram2_period_67,address:0xa0
                prdata <= {6'h0,hw_ringo_dram2_period7_apb_dff,6'h0,hw_ringo_dram2_period6_apb_dff};
                8'ha4: //register name:hw_ringo_dram3_period_01,address:0xa4
                prdata <= {6'h0,hw_ringo_dram3_period1_apb_dff,6'h0,hw_ringo_dram3_period0_apb_dff};
                8'ha8: //register name:hw_ringo_dram3_period_23,address:0xa8
                prdata <= {6'h0,hw_ringo_dram3_period3_apb_dff,6'h0,hw_ringo_dram3_period2_apb_dff};
                8'hac: //register name:hw_ringo_dram3_period_45,address:0xac
                prdata <= {6'h0,hw_ringo_dram3_period5_apb_dff,6'h0,hw_ringo_dram3_period4_apb_dff};
                8'hb0: //register name:hw_ringo_dram3_period_67,address:0xb0
                prdata <= {6'h0,hw_ringo_dram3_period7_apb_dff,6'h0,hw_ringo_dram3_period6_apb_dff};
                8'hb4: //register name:trim_debug0,address:0xb4
                prdata <= {stopwatch_ringo_edge_dbg_apb_dff,stopwatch_period_edge_dbg_apb_dff,tm_redump_edge_dbg_apb_dff,spine_reset_n_dbg_apb_dff,trim_start_cnt_dbg_apb_dff,sw_stopwatch_period_active_cnt_dbg_apb_dff,sw_tm_redump_active_cnt_dbg_apb_dff,sw_spine_reset_n_active_cnt_dbg_apb_dff};
                8'hb8: //register name:trim_debug1,address:0xb8
                prdata <= {fsm_cs_flag_dbg0_apb_dff};
                8'hbc: //register name:trim_debug2,address:0xbc
                prdata <= {18'h0,fsm_cs_dbg_apb_dff,7'h0,fsm_cs_flag_dbg1_apb_dff};
                8'hc0: //register name:hw_ringo_period_dly,address:0xc0
                prdata <= {18'h0,hw_ringo_period_delay_o};
                8'hc4: //register name:hw_period2ringo_dly,address:0xc4
                prdata <= {22'h0,hw_period2ringo_dly_o};
            default:
                prdata <= {APB_DATA_WIDTH{1'b1}}; //  means read a non-exist address
            endcase
        end
        else begin
            prdata <= {APB_DATA_WIDTH{1'b0}};
        end
    end
    // for read only logic.
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0)
        begin
        //read only signal.
            trim_ctrl_id_apb_dff <= 32'h5452494D;  //Register trim_ctrl_id,Address 0x0
            trim_finish_apb_dff <= 1'b0;  //Register trim_finish,Address 0x8
            spine_resetn_active_ready_apb_dff <= 1'b1;  //Register spine_resetn_active_ready,Address 0xc
            tm_redump_active_ready_apb_dff <= 1'b1;  //Register tm_redump_active_ready,Address 0xc
            stopwatch_period_active_ready_apb_dff <= 1'b1;  //Register stopwatch_period_active_ready,Address 0xc
            init_done_flag_apb_dff <= 1'b0;  //Register init_done_flag,Address 0xc
            stopwatch_ringo_period_ready_apb_dff <= 4'h0;  //Register stopwatch_ringo_period_ready,Address 0xc
            dump_ready_apb_dff <= 4'h0;  //Register dump_ready,Address 0xc
            dumpready_timeout_ready_apb_dff <= 4'h0;  //Register dumpready_timeout_ready,Address 0xc
            osc_tm_res_smp_value_apb_dff <= 8'h0;  //Register osc_tm_res_smp_value,Address 0x58
            osc_tm_res_smp_ready_apb_dff <= 4'h0;  //Register osc_tm_res_smp_ready,Address 0x58
            stopwatch_ringo_period0_apb_dff <= 10'h0;  //Register stopwatch_ringo_period0,Address 0x5c
            stopwatch_ringo_period1_apb_dff <= 10'h0;  //Register stopwatch_ringo_period1,Address 0x5c
            stopwatch_ringo_period2_apb_dff <= 10'h0;  //Register stopwatch_ringo_period2,Address 0x60
            stopwatch_ringo_period3_apb_dff <= 10'h0;  //Register stopwatch_ringo_period3,Address 0x60
            dumpready_timeout_flag_apb_dff <= 4'h0;  //Register dumpready_timeout_flag,Address 0x64
            ringo_timeout_flag_apb_dff <= 4'h0;  //Register ringo_timeout_flag,Address 0x68
            trim_interrupt_flag_apb_dff <= 1'b0;  //Register trim_interrupt_flag,Address 0x70
            hw_ringo_dram0_period0_apb_dff <= 10'h0;  //Register hw_ringo_dram0_period0,Address 0x74
            hw_ringo_dram0_period1_apb_dff <= 10'h0;  //Register hw_ringo_dram0_period1,Address 0x74
            hw_ringo_dram0_period2_apb_dff <= 10'h0;  //Register hw_ringo_dram0_period2,Address 0x78
            hw_ringo_dram0_period3_apb_dff <= 10'h0;  //Register hw_ringo_dram0_period3,Address 0x78
            hw_ringo_dram0_period4_apb_dff <= 10'h0;  //Register hw_ringo_dram0_period4,Address 0x7c
            hw_ringo_dram0_period5_apb_dff <= 10'h0;  //Register hw_ringo_dram0_period5,Address 0x7c
            hw_ringo_dram0_period6_apb_dff <= 10'h0;  //Register hw_ringo_dram0_period6,Address 0x80
            hw_ringo_dram0_period7_apb_dff <= 10'h0;  //Register hw_ringo_dram0_period7,Address 0x80
            hw_ringo_dram1_period0_apb_dff <= 10'h0;  //Register hw_ringo_dram1_period0,Address 0x84
            hw_ringo_dram1_period1_apb_dff <= 10'h0;  //Register hw_ringo_dram1_period1,Address 0x84
            hw_ringo_dram1_period2_apb_dff <= 10'h0;  //Register hw_ringo_dram1_period2,Address 0x88
            hw_ringo_dram1_period3_apb_dff <= 10'h0;  //Register hw_ringo_dram1_period3,Address 0x88
            hw_ringo_dram1_period4_apb_dff <= 10'h0;  //Register hw_ringo_dram1_period4,Address 0x8c
            hw_ringo_dram1_period5_apb_dff <= 10'h0;  //Register hw_ringo_dram1_period5,Address 0x8c
            hw_ringo_dram1_period6_apb_dff <= 10'h0;  //Register hw_ringo_dram1_period6,Address 0x90
            hw_ringo_dram1_period7_apb_dff <= 10'h0;  //Register hw_ringo_dram1_period7,Address 0x90
            hw_ringo_dram2_period0_apb_dff <= 10'h0;  //Register hw_ringo_dram2_period0,Address 0x94
            hw_ringo_dram2_period1_apb_dff <= 10'h0;  //Register hw_ringo_dram2_period1,Address 0x94
            hw_ringo_dram2_period2_apb_dff <= 10'h0;  //Register hw_ringo_dram2_period2,Address 0x98
            hw_ringo_dram2_period3_apb_dff <= 10'h0;  //Register hw_ringo_dram2_period3,Address 0x98
            hw_ringo_dram2_period4_apb_dff <= 10'h0;  //Register hw_ringo_dram2_period4,Address 0x9c
            hw_ringo_dram2_period5_apb_dff <= 10'h0;  //Register hw_ringo_dram2_period5,Address 0x9c
            hw_ringo_dram2_period6_apb_dff <= 10'h0;  //Register hw_ringo_dram2_period6,Address 0xa0
            hw_ringo_dram2_period7_apb_dff <= 10'h0;  //Register hw_ringo_dram2_period7,Address 0xa0
            hw_ringo_dram3_period0_apb_dff <= 10'h0;  //Register hw_ringo_dram3_period0,Address 0xa4
            hw_ringo_dram3_period1_apb_dff <= 10'h0;  //Register hw_ringo_dram3_period1,Address 0xa4
            hw_ringo_dram3_period2_apb_dff <= 10'h0;  //Register hw_ringo_dram3_period2,Address 0xa8
            hw_ringo_dram3_period3_apb_dff <= 10'h0;  //Register hw_ringo_dram3_period3,Address 0xa8
            hw_ringo_dram3_period4_apb_dff <= 10'h0;  //Register hw_ringo_dram3_period4,Address 0xac
            hw_ringo_dram3_period5_apb_dff <= 10'h0;  //Register hw_ringo_dram3_period5,Address 0xac
            hw_ringo_dram3_period6_apb_dff <= 10'h0;  //Register hw_ringo_dram3_period6,Address 0xb0
            hw_ringo_dram3_period7_apb_dff <= 10'h0;  //Register hw_ringo_dram3_period7,Address 0xb0
            sw_spine_reset_n_active_cnt_dbg_apb_dff <= 4'h0;  //Register sw_spine_reset_n_active_cnt_dbg,Address 0xb4
            sw_tm_redump_active_cnt_dbg_apb_dff <= 4'h0;  //Register sw_tm_redump_active_cnt_dbg,Address 0xb4
            sw_stopwatch_period_active_cnt_dbg_apb_dff <= 4'h0;  //Register sw_stopwatch_period_active_cnt_dbg,Address 0xb4
            trim_start_cnt_dbg_apb_dff <= 4'h0;  //Register trim_start_cnt_dbg,Address 0xb4
            spine_reset_n_dbg_apb_dff <= 4'h0;  //Register spine_reset_n_dbg,Address 0xb4
            tm_redump_edge_dbg_apb_dff <= 4'h0;  //Register tm_redump_edge_dbg,Address 0xb4
            stopwatch_period_edge_dbg_apb_dff <= 4'h0;  //Register stopwatch_period_edge_dbg,Address 0xb4
            stopwatch_ringo_edge_dbg_apb_dff <= 4'h0;  //Register stopwatch_ringo_edge_dbg,Address 0xb4
            fsm_cs_flag_dbg0_apb_dff <= 32'h0;  //Register fsm_cs_flag_dbg0,Address 0xb8
            fsm_cs_flag_dbg1_apb_dff <= 1'b0;  //Register fsm_cs_flag_dbg1,Address 0xbc
            fsm_cs_dbg_apb_dff <= 6'h0;  //Register fsm_cs_dbg,Address 0xbc
        end
        else
        begin
        //read only signal,input from other module
            trim_ctrl_id_apb_dff <= trim_ctrl_id_i; //Register trim_ctrl_id,Address 0x0
            trim_finish_apb_dff <= trim_finish_i; //Register trim_finish,Address 0x8
            spine_resetn_active_ready_apb_dff <= spine_resetn_active_ready_i; //Register spine_resetn_active_ready,Address 0xc
            tm_redump_active_ready_apb_dff <= tm_redump_active_ready_i; //Register tm_redump_active_ready,Address 0xc
            stopwatch_period_active_ready_apb_dff <= stopwatch_period_active_ready_i; //Register stopwatch_period_active_ready,Address 0xc
            init_done_flag_apb_dff <= init_done_flag_i; //Register init_done_flag,Address 0xc
            stopwatch_ringo_period_ready_apb_dff <= stopwatch_ringo_period_ready_i; //Register stopwatch_ringo_period_ready,Address 0xc
            dump_ready_apb_dff <= dump_ready_i; //Register dump_ready,Address 0xc
            dumpready_timeout_ready_apb_dff <= dumpready_timeout_ready_i; //Register dumpready_timeout_ready,Address 0xc
            osc_tm_res_smp_value_apb_dff <= osc_tm_res_smp_value_i; //Register osc_tm_res_smp_value,Address 0x58
            osc_tm_res_smp_ready_apb_dff <= osc_tm_res_smp_ready_i; //Register osc_tm_res_smp_ready,Address 0x58
            stopwatch_ringo_period0_apb_dff <= stopwatch_ringo_period0_i; //Register stopwatch_ringo_period0,Address 0x5c
            stopwatch_ringo_period1_apb_dff <= stopwatch_ringo_period1_i; //Register stopwatch_ringo_period1,Address 0x5c
            stopwatch_ringo_period2_apb_dff <= stopwatch_ringo_period2_i; //Register stopwatch_ringo_period2,Address 0x60
            stopwatch_ringo_period3_apb_dff <= stopwatch_ringo_period3_i; //Register stopwatch_ringo_period3,Address 0x60
            dumpready_timeout_flag_apb_dff <= dumpready_timeout_flag_i; //Register dumpready_timeout_flag,Address 0x64
            ringo_timeout_flag_apb_dff <= ringo_timeout_flag_i; //Register ringo_timeout_flag,Address 0x68
            trim_interrupt_flag_apb_dff <= trim_interrupt_flag_i; //Register trim_interrupt_flag,Address 0x70
            hw_ringo_dram0_period0_apb_dff <= hw_ringo_dram0_period0_i; //Register hw_ringo_dram0_period0,Address 0x74
            hw_ringo_dram0_period1_apb_dff <= hw_ringo_dram0_period1_i; //Register hw_ringo_dram0_period1,Address 0x74
            hw_ringo_dram0_period2_apb_dff <= hw_ringo_dram0_period2_i; //Register hw_ringo_dram0_period2,Address 0x78
            hw_ringo_dram0_period3_apb_dff <= hw_ringo_dram0_period3_i; //Register hw_ringo_dram0_period3,Address 0x78
            hw_ringo_dram0_period4_apb_dff <= hw_ringo_dram0_period4_i; //Register hw_ringo_dram0_period4,Address 0x7c
            hw_ringo_dram0_period5_apb_dff <= hw_ringo_dram0_period5_i; //Register hw_ringo_dram0_period5,Address 0x7c
            hw_ringo_dram0_period6_apb_dff <= hw_ringo_dram0_period6_i; //Register hw_ringo_dram0_period6,Address 0x80
            hw_ringo_dram0_period7_apb_dff <= hw_ringo_dram0_period7_i; //Register hw_ringo_dram0_period7,Address 0x80
            hw_ringo_dram1_period0_apb_dff <= hw_ringo_dram1_period0_i; //Register hw_ringo_dram1_period0,Address 0x84
            hw_ringo_dram1_period1_apb_dff <= hw_ringo_dram1_period1_i; //Register hw_ringo_dram1_period1,Address 0x84
            hw_ringo_dram1_period2_apb_dff <= hw_ringo_dram1_period2_i; //Register hw_ringo_dram1_period2,Address 0x88
            hw_ringo_dram1_period3_apb_dff <= hw_ringo_dram1_period3_i; //Register hw_ringo_dram1_period3,Address 0x88
            hw_ringo_dram1_period4_apb_dff <= hw_ringo_dram1_period4_i; //Register hw_ringo_dram1_period4,Address 0x8c
            hw_ringo_dram1_period5_apb_dff <= hw_ringo_dram1_period5_i; //Register hw_ringo_dram1_period5,Address 0x8c
            hw_ringo_dram1_period6_apb_dff <= hw_ringo_dram1_period6_i; //Register hw_ringo_dram1_period6,Address 0x90
            hw_ringo_dram1_period7_apb_dff <= hw_ringo_dram1_period7_i; //Register hw_ringo_dram1_period7,Address 0x90
            hw_ringo_dram2_period0_apb_dff <= hw_ringo_dram2_period0_i; //Register hw_ringo_dram2_period0,Address 0x94
            hw_ringo_dram2_period1_apb_dff <= hw_ringo_dram2_period1_i; //Register hw_ringo_dram2_period1,Address 0x94
            hw_ringo_dram2_period2_apb_dff <= hw_ringo_dram2_period2_i; //Register hw_ringo_dram2_period2,Address 0x98
            hw_ringo_dram2_period3_apb_dff <= hw_ringo_dram2_period3_i; //Register hw_ringo_dram2_period3,Address 0x98
            hw_ringo_dram2_period4_apb_dff <= hw_ringo_dram2_period4_i; //Register hw_ringo_dram2_period4,Address 0x9c
            hw_ringo_dram2_period5_apb_dff <= hw_ringo_dram2_period5_i; //Register hw_ringo_dram2_period5,Address 0x9c
            hw_ringo_dram2_period6_apb_dff <= hw_ringo_dram2_period6_i; //Register hw_ringo_dram2_period6,Address 0xa0
            hw_ringo_dram2_period7_apb_dff <= hw_ringo_dram2_period7_i; //Register hw_ringo_dram2_period7,Address 0xa0
            hw_ringo_dram3_period0_apb_dff <= hw_ringo_dram3_period0_i; //Register hw_ringo_dram3_period0,Address 0xa4
            hw_ringo_dram3_period1_apb_dff <= hw_ringo_dram3_period1_i; //Register hw_ringo_dram3_period1,Address 0xa4
            hw_ringo_dram3_period2_apb_dff <= hw_ringo_dram3_period2_i; //Register hw_ringo_dram3_period2,Address 0xa8
            hw_ringo_dram3_period3_apb_dff <= hw_ringo_dram3_period3_i; //Register hw_ringo_dram3_period3,Address 0xa8
            hw_ringo_dram3_period4_apb_dff <= hw_ringo_dram3_period4_i; //Register hw_ringo_dram3_period4,Address 0xac
            hw_ringo_dram3_period5_apb_dff <= hw_ringo_dram3_period5_i; //Register hw_ringo_dram3_period5,Address 0xac
            hw_ringo_dram3_period6_apb_dff <= hw_ringo_dram3_period6_i; //Register hw_ringo_dram3_period6,Address 0xb0
            hw_ringo_dram3_period7_apb_dff <= hw_ringo_dram3_period7_i; //Register hw_ringo_dram3_period7,Address 0xb0
            sw_spine_reset_n_active_cnt_dbg_apb_dff <= sw_spine_reset_n_active_cnt_dbg_i; //Register sw_spine_reset_n_active_cnt_dbg,Address 0xb4
            sw_tm_redump_active_cnt_dbg_apb_dff <= sw_tm_redump_active_cnt_dbg_i; //Register sw_tm_redump_active_cnt_dbg,Address 0xb4
            sw_stopwatch_period_active_cnt_dbg_apb_dff <= sw_stopwatch_period_active_cnt_dbg_i; //Register sw_stopwatch_period_active_cnt_dbg,Address 0xb4
            trim_start_cnt_dbg_apb_dff <= trim_start_cnt_dbg_i; //Register trim_start_cnt_dbg,Address 0xb4
            spine_reset_n_dbg_apb_dff <= spine_reset_n_dbg_i; //Register spine_reset_n_dbg,Address 0xb4
            tm_redump_edge_dbg_apb_dff <= tm_redump_edge_dbg_i; //Register tm_redump_edge_dbg,Address 0xb4
            stopwatch_period_edge_dbg_apb_dff <= stopwatch_period_edge_dbg_i; //Register stopwatch_period_edge_dbg,Address 0xb4
            stopwatch_ringo_edge_dbg_apb_dff <= stopwatch_ringo_edge_dbg_i; //Register stopwatch_ringo_edge_dbg,Address 0xb4
            fsm_cs_flag_dbg0_apb_dff <= fsm_cs_flag_dbg0_i; //Register fsm_cs_flag_dbg0,Address 0xb8
            fsm_cs_flag_dbg1_apb_dff <= fsm_cs_flag_dbg1_i; //Register fsm_cs_flag_dbg1,Address 0xbc
            fsm_cs_dbg_apb_dff <= fsm_cs_dbg_i; //Register fsm_cs_dbg,Address 0xbc
        end
    end
    // register name : trim_op_ctrl , address:0x4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            spine_resetn_active_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 8'h4)) begin
            spine_resetn_active_o <= pwdata[0];
        end
        else
            spine_resetn_active_o <= 1'b0;

    end
    // register name : trim_op_ctrl , address:0x4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            tm_redump_active_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 8'h4)) begin
            tm_redump_active_o <= pwdata[1];
        end
        else
            tm_redump_active_o <= 1'b0;

    end
    // register name : trim_op_ctrl , address:0x4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            stopwatch_period_active_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 8'h4)) begin
            stopwatch_period_active_o <= pwdata[2];
        end
        else
            stopwatch_period_active_o <= 1'b0;

    end
    // register name : trim_op_ctrl , address:0x4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            trim_start_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 8'h4)) begin
            trim_start_o <= pwdata[3];
        end
        else
            trim_start_o <= 1'b0;

    end
    // register name : trim_op_ctrl , address:0x4
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            init_start_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 8'h4)) begin
            init_start_o <= pwdata[4];
        end
        else
            init_start_o <= 1'b0;

    end
    // register name : dumpready_timeout_ctrl , address:0x64
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            dumpready_timeout_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 8'h64)) begin
            dumpready_timeout_clr_o <= pwdata[1];
        end
        else
            dumpready_timeout_clr_o <= 1'b0;

    end
    // register name : ringo_timeout_ctrl , address:0x68
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            ringo_timeout_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 8'h68)) begin
            ringo_timeout_clr_o <= pwdata[1];
        end
        else
            ringo_timeout_clr_o <= 1'b0;

    end
    // register name : trim_interrupt_ctrl , address:0x70
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            trim_interrupt_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 8'h70)) begin
            trim_interrupt_clr_o <= pwdata[0];
        end
        else
            trim_interrupt_clr_o <= 1'b0;

    end
endmodule
// Below is the information of "dram_trim" in register sheet, can use as a reference if have unexpected issues in this verilog file.
// 0x0___(trim_ctrl_id)___(trim_ctrl_id)___0___32___RO___0x5452494D
// 0x4___(trim_op_ctrl)___(spine_resetn_active)___0___1___W1C___0x0
// 0x4___(trim_op_ctrl)___(tm_redump_active)___1___1___W1C___0x0
// 0x4___(trim_op_ctrl)___(stopwatch_period_active)___2___1___W1C___0x0
// 0x4___(trim_op_ctrl)___(trim_start)___3___1___W1C___0x0
// 0x4___(trim_op_ctrl)___(init_start)___4___1___W1C___0x0
// 0x4___(trim_op_ctrl)___(reserved)___5___27___NA___0x0
// 0x8___(trim_global_ctrl)___(trim_op_flow)___0___1___RW___0x0
// 0x8___(trim_global_ctrl)___(hw_op_ringo_mask)___1___1___RW___0x1
// 0x8___(trim_global_ctrl)___(hw_op_tsv_load_sel)___2___1___RW___0x0
// 0x8___(trim_global_ctrl)___(reserved)___3___1___NA___0x0
// 0x8___(trim_global_ctrl)___(dram_layer_sel)___4___4___RW___0xF
// 0x8___(trim_global_ctrl)___(res_or_ringo_sel)___8___1___RW___0x0
// 0x8___(trim_global_ctrl)___(debug_en)___9___1___RW___0x0
// 0x8___(trim_global_ctrl)___(reserved)___10___2___NA___0x0
// 0x8___(trim_global_ctrl)___(trim_finish)___12___1___RO___0x0
// 0x8___(trim_global_ctrl)___(reserved)___13___19___NA___0x0
// 0xc___(trim_internal_status)___(spine_resetn_active_ready)___0___1___RO___0x1
// 0xc___(trim_internal_status)___(tm_redump_active_ready)___1___1___RO___0x1
// 0xc___(trim_internal_status)___(stopwatch_period_active_ready)___2___1___RO___0x1
// 0xc___(trim_internal_status)___(init_done_flag)___3___1___RO___0x0
// 0xc___(trim_internal_status)___(stopwatch_ringo_period_ready)___4___4___RO___0x0
// 0xc___(trim_internal_status)___(dump_ready)___8___4___RO___0x0
// 0xc___(trim_internal_status)___(dumpready_timeout_ready)___12___4___RO___0x0
// 0xc___(trim_internal_status)___(reserved)___16___16___NA___0x0
// 0x10___(init_spine_resetn_time)___(init_spine_reset_time)___0___28___RW___0x7A11FF
// 0x10___(init_spine_resetn_time)___(reserved)___28___4___NA___0x0
// 0x14___(spine_resetn_width)___(spine_resetn_width)___0___10___RW___0x13
// 0x14___(spine_resetn_width)___(reserved)___10___22___NA___0x0
// 0x18___(tm_redump_width)___(tm_redump_width)___0___10___RW___0x3
// 0x18___(tm_redump_width)___(reserved)___10___22___NA___0x0
// 0x1c___(stopwatch_period_width)___(stopwatch_period_width_res)___0___16___RW___0x18F
// 0x1c___(stopwatch_period_width)___(stopwatch_period_width_ringo)___16___16___RW___0x3
// 0x20___(redump_tsv_tm_other_value0)___(redump_tsv_tm_other_value0)___0___32___RW___0x0
// 0x24___(redump_tsv_tm_other_value1)___(redump_tsv_tm_other_value1)___0___32___RW___0x0
// 0x28___(redump_tsv_tm_other_value2)___(redump_tsv_tm_other_value2)___0___32___RW___0x0
// 0x2c___(redump_tsv_tm_other_value3)___(redump_tsv_tm_other_value3)___0___32___RW___0x0
// 0x30___(redump_tsv_tm_other_value4)___(redump_tsv_tm_other_value4)___0___32___RW___0x0
// 0x34___(redump_tsv_tm_other_value5)___(redump_tsv_tm_other_value5)___0___32___RW___0x0
// 0x38___(redump_tsv_tm_other_value6)___(redump_tsv_tm_other_value6)___0___32___RW___0x0
// 0x3c___(redump_tsv_tm_other_value7)___(redump_tsv_tm_other_value7)___0___32___RW___0x598000
// 0x40___(redump_tsv_tm_other_value8)___(redump_tsv_tm_other_value8)___0___32___RW___0x0
// 0x44___(redump_tsv_tm_other_value9)___(redump_tsv_tm_other_value9)___0___32___RW___0x0
// 0x48___(redump_tsv_tm_other_value10)___(redump_tsv_tm_other_value10)___0___32___RW___0x0
// 0x4c___(redump_tsv_tm_other_value11)___(redump_tsv_tm_other_value11)___0___32___RW___0x0
// 0x50___(redump_tsv_tm_other_value12)___(redump_tsv_tm_other_value12)___0___32___RW___0x0
// 0x54___(redump_tsv_tm_other_value13)___(redump_tsv_tm_other_value13)___0___12___RW___0x0
// 0x54___(redump_tsv_tm_other_value13)___(reserved)___12___20___NA___0x0
// 0x58___(osc_tm_res_smp_value)___(osc_tm_res_smp_value)___0___8___RO___0x0
// 0x58___(osc_tm_res_smp_value)___(osc_tm_res_smp_ready)___8___4___RO___0x0
// 0x58___(osc_tm_res_smp_value)___(reserved)___12___20___NA___0x0
// 0x5c___(stopwatch_ringo_period_01)___(stopwatch_ringo_period0)___0___10___RO___0x0
// 0x5c___(stopwatch_ringo_period_01)___(reserved)___10___6___NA___0x0
// 0x5c___(stopwatch_ringo_period_01)___(stopwatch_ringo_period1)___16___10___RO___0x0
// 0x5c___(stopwatch_ringo_period_01)___(reserved)___26___6___NA___0x0
// 0x60___(stopwatch_ringo_period_23)___(stopwatch_ringo_period2)___0___10___RO___0x0
// 0x60___(stopwatch_ringo_period_23)___(reserved)___10___6___NA___0x0
// 0x60___(stopwatch_ringo_period_23)___(stopwatch_ringo_period3)___16___10___RO___0x0
// 0x60___(stopwatch_ringo_period_23)___(reserved)___26___6___NA___0x0
// 0x64___(dumpready_timeout_ctrl)___(dumpready_timeout_en)___0___1___RW___0x1
// 0x64___(dumpready_timeout_ctrl)___(dumpready_timeout_clr)___1___1___W1C___0x0
// 0x64___(dumpready_timeout_ctrl)___(reserved)___2___2___NA___0x0
// 0x64___(dumpready_timeout_ctrl)___(dumpready_timeout_flag)___4___4___RO___0x0
// 0x64___(dumpready_timeout_ctrl)___(dumpready_timeout_time)___8___24___RW___0xC3500
// 0x68___(ringo_timeout_ctrl)___(ringo_timeout_en)___0___1___RW___0x1
// 0x68___(ringo_timeout_ctrl)___(ringo_timeout_clr)___1___1___W1C___0x0
// 0x68___(ringo_timeout_ctrl)___(reserved)___2___2___NA___0x0
// 0x68___(ringo_timeout_ctrl)___(ringo_timeout_flag)___4___4___RO___0x0
// 0x68___(ringo_timeout_ctrl)___(ringo_timeout_time)___8___24___RW___0xBB8
// 0x6c___(res_value_ctrl)___(res_value_sel)___0___2___RW___0x0
// 0x6c___(res_value_ctrl)___(reserved)___2___2___NA___0x0
// 0x6c___(res_value_ctrl)___(res_cfg_value)___4___8___RW___0x0
// 0x6c___(res_value_ctrl)___(reserved)___12___20___NA___0x0
// 0x70___(trim_interrupt_ctrl)___(trim_interrupt_clr)___0___1___W1C___0x0
// 0x70___(trim_interrupt_ctrl)___(trim_interrupt_mask)___1___1___RW___0x0
// 0x70___(trim_interrupt_ctrl)___(trim_interrupt_flag)___2___1___RO___0x0
// 0x70___(trim_interrupt_ctrl)___(reserved)___3___29___NA___0x0
// 0x74___(hw_ringo_dram0_period_01)___(hw_ringo_dram0_period0)___0___10___RO___0x0
// 0x74___(hw_ringo_dram0_period_01)___(reserved)___10___6___NA___0x0
// 0x74___(hw_ringo_dram0_period_01)___(hw_ringo_dram0_period1)___16___10___RO___0x0
// 0x74___(hw_ringo_dram0_period_01)___(reserved)___26___6___NA___0x0
// 0x78___(hw_ringo_dram0_period_23)___(hw_ringo_dram0_period2)___0___10___RO___0x0
// 0x78___(hw_ringo_dram0_period_23)___(reserved)___10___6___NA___0x0
// 0x78___(hw_ringo_dram0_period_23)___(hw_ringo_dram0_period3)___16___10___RO___0x0
// 0x78___(hw_ringo_dram0_period_23)___(reserved)___26___6___NA___0x0
// 0x7c___(hw_ringo_dram0_period_45)___(hw_ringo_dram0_period4)___0___10___RO___0x0
// 0x7c___(hw_ringo_dram0_period_45)___(reserved)___10___6___NA___0x0
// 0x7c___(hw_ringo_dram0_period_45)___(hw_ringo_dram0_period5)___16___10___RO___0x0
// 0x7c___(hw_ringo_dram0_period_45)___(reserved)___26___6___NA___0x0
// 0x80___(hw_ringo_dram0_period_67)___(hw_ringo_dram0_period6)___0___10___RO___0x0
// 0x80___(hw_ringo_dram0_period_67)___(reserved)___10___6___NA___0x0
// 0x80___(hw_ringo_dram0_period_67)___(hw_ringo_dram0_period7)___16___10___RO___0x0
// 0x80___(hw_ringo_dram0_period_67)___(reserved)___26___6___NA___0x0
// 0x84___(hw_ringo_dram1_period_01)___(hw_ringo_dram1_period0)___0___10___RO___0x0
// 0x84___(hw_ringo_dram1_period_01)___(reserved)___10___6___NA___0x0
// 0x84___(hw_ringo_dram1_period_01)___(hw_ringo_dram1_period1)___16___10___RO___0x0
// 0x84___(hw_ringo_dram1_period_01)___(reserved)___26___6___NA___0x0
// 0x88___(hw_ringo_dram1_period_23)___(hw_ringo_dram1_period2)___0___10___RO___0x0
// 0x88___(hw_ringo_dram1_period_23)___(reserved)___10___6___NA___0x0
// 0x88___(hw_ringo_dram1_period_23)___(hw_ringo_dram1_period3)___16___10___RO___0x0
// 0x88___(hw_ringo_dram1_period_23)___(reserved)___26___6___NA___0x0
// 0x8c___(hw_ringo_dram1_period_45)___(hw_ringo_dram1_period4)___0___10___RO___0x0
// 0x8c___(hw_ringo_dram1_period_45)___(reserved)___10___6___NA___0x0
// 0x8c___(hw_ringo_dram1_period_45)___(hw_ringo_dram1_period5)___16___10___RO___0x0
// 0x8c___(hw_ringo_dram1_period_45)___(reserved)___26___6___NA___0x0
// 0x90___(hw_ringo_dram1_period_67)___(hw_ringo_dram1_period6)___0___10___RO___0x0
// 0x90___(hw_ringo_dram1_period_67)___(reserved)___10___6___NA___0x0
// 0x90___(hw_ringo_dram1_period_67)___(hw_ringo_dram1_period7)___16___10___RO___0x0
// 0x90___(hw_ringo_dram1_period_67)___(reserved)___26___6___NA___0x0
// 0x94___(hw_ringo_dram2_period_01)___(hw_ringo_dram2_period0)___0___10___RO___0x0
// 0x94___(hw_ringo_dram2_period_01)___(reserved)___10___6___NA___0x0
// 0x94___(hw_ringo_dram2_period_01)___(hw_ringo_dram2_period1)___16___10___RO___0x0
// 0x94___(hw_ringo_dram2_period_01)___(reserved)___26___6___NA___0x0
// 0x98___(hw_ringo_dram2_period_23)___(hw_ringo_dram2_period2)___0___10___RO___0x0
// 0x98___(hw_ringo_dram2_period_23)___(reserved)___10___6___NA___0x0
// 0x98___(hw_ringo_dram2_period_23)___(hw_ringo_dram2_period3)___16___10___RO___0x0
// 0x98___(hw_ringo_dram2_period_23)___(reserved)___26___6___NA___0x0
// 0x9c___(hw_ringo_dram2_period_45)___(hw_ringo_dram2_period4)___0___10___RO___0x0
// 0x9c___(hw_ringo_dram2_period_45)___(reserved)___10___6___NA___0x0
// 0x9c___(hw_ringo_dram2_period_45)___(hw_ringo_dram2_period5)___16___10___RO___0x0
// 0x9c___(hw_ringo_dram2_period_45)___(reserved)___26___6___NA___0x0
// 0xa0___(hw_ringo_dram2_period_67)___(hw_ringo_dram2_period6)___0___10___RO___0x0
// 0xa0___(hw_ringo_dram2_period_67)___(reserved)___10___6___NA___0x0
// 0xa0___(hw_ringo_dram2_period_67)___(hw_ringo_dram2_period7)___16___10___RO___0x0
// 0xa0___(hw_ringo_dram2_period_67)___(reserved)___26___6___NA___0x0
// 0xa4___(hw_ringo_dram3_period_01)___(hw_ringo_dram3_period0)___0___10___RO___0x0
// 0xa4___(hw_ringo_dram3_period_01)___(reserved)___10___6___NA___0x0
// 0xa4___(hw_ringo_dram3_period_01)___(hw_ringo_dram3_period1)___16___10___RO___0x0
// 0xa4___(hw_ringo_dram3_period_01)___(reserved)___26___6___NA___0x0
// 0xa8___(hw_ringo_dram3_period_23)___(hw_ringo_dram3_period2)___0___10___RO___0x0
// 0xa8___(hw_ringo_dram3_period_23)___(reserved)___10___6___NA___0x0
// 0xa8___(hw_ringo_dram3_period_23)___(hw_ringo_dram3_period3)___16___10___RO___0x0
// 0xa8___(hw_ringo_dram3_period_23)___(reserved)___26___6___NA___0x0
// 0xac___(hw_ringo_dram3_period_45)___(hw_ringo_dram3_period4)___0___10___RO___0x0
// 0xac___(hw_ringo_dram3_period_45)___(reserved)___10___6___NA___0x0
// 0xac___(hw_ringo_dram3_period_45)___(hw_ringo_dram3_period5)___16___10___RO___0x0
// 0xac___(hw_ringo_dram3_period_45)___(reserved)___26___6___NA___0x0
// 0xb0___(hw_ringo_dram3_period_67)___(hw_ringo_dram3_period6)___0___10___RO___0x0
// 0xb0___(hw_ringo_dram3_period_67)___(reserved)___10___6___NA___0x0
// 0xb0___(hw_ringo_dram3_period_67)___(hw_ringo_dram3_period7)___16___10___RO___0x0
// 0xb0___(hw_ringo_dram3_period_67)___(reserved)___26___6___NA___0x0
// 0xb4___(trim_debug0)___(sw_spine_reset_n_active_cnt_dbg)___0___4___RO___0x0
// 0xb4___(trim_debug0)___(sw_tm_redump_active_cnt_dbg)___4___4___RO___0x0
// 0xb4___(trim_debug0)___(sw_stopwatch_period_active_cnt_dbg)___8___4___RO___0x0
// 0xb4___(trim_debug0)___(trim_start_cnt_dbg)___12___4___RO___0x0
// 0xb4___(trim_debug0)___(spine_reset_n_dbg)___16___4___RO___0x0
// 0xb4___(trim_debug0)___(tm_redump_edge_dbg)___20___4___RO___0x0
// 0xb4___(trim_debug0)___(stopwatch_period_edge_dbg)___24___4___RO___0x0
// 0xb4___(trim_debug0)___(stopwatch_ringo_edge_dbg)___28___4___RO___0x0
// 0xb8___(trim_debug1)___(fsm_cs_flag_dbg0)___0___32___RO___0x0
// 0xbc___(trim_debug2)___(fsm_cs_flag_dbg1)___0___1___RO___0x0
// 0xbc___(trim_debug2)___(reserved)___1___7___NA___0x0
// 0xbc___(trim_debug2)___(fsm_cs_dbg)___8___6___RO___0x0
// 0xbc___(trim_debug2)___(reserved)___14___18___NA___0x0
// 0xc0___(hw_ringo_period_dly)___(hw_ringo_period_delay)___0___14___RW___0x5
// 0xc0___(hw_ringo_period_dly)___(reserved)___14___18___NA___0x0
// 0xc4___(hw_period2ringo_dly)___(hw_period2ringo_dly)___0___10___RW___0x78
// 0xc4___(hw_period2ringo_dly)___(reserved)___10___22___NA___0x0
