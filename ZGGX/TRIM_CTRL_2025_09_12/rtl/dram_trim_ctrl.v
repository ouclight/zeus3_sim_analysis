
module dram_trim_ctrl #(
        parameter DRAM_LAYER_NUM = 4
        )(
        input                                clk                               ,
        input                                rst_n                             ,
        input                                apb_clk                           ,
        input                                apb_rst_n                         ,
        input                                debug_en                          ,
        input                                trim_start_internal               ,
        input                                trim_start_external               ,
        input                                trim_op_flow                      ,
        input                                init_start                        ,
        output  reg                          init_done_flag                    ,
        input        [7:0]                   trim_res_ext                      ,
        input        [7:0]                   trim_res_apb                      ,
        input        [1:0]                   res_value_sel                     ,
        input        [3:0]                   dram_layer_sel                    ,
        input        [23:0]                  ringo_timeout_time                ,
        input                                ringo_timeout_en                  ,
        input                                ringo_timeout_clr                 ,
        output  reg  [3:0]                   ringo_timeout_flag                ,
        input                                dumpready_timeout_en              ,
        input                                dumpready_timeout_clr             ,
        output       [3:0]                   dumpready_timeout_flag            ,
        output       [3:0]                   dumpready_timeout_ready           ,
        input        [23:0]                  dumpready_timeout_time            ,
        input                                hw_op_tsv_load_sel                ,
        input                                hw_op_ringo_mask                  ,
        input                                trim_interrupt_clr                ,
        input                                trim_interrupt_mask               ,
        output  reg                          trim_interrupt_flag               ,
        output                               trim_interrupt                    ,
        output  reg                          trim_finish                       ,
        output       [7:0]                   osc_tm_res_smp_value              ,
        output  reg  [3:0]                   osc_tm_res_smp_ready              ,
        output       [39:0]                  stopwatch_ringo_period            ,
        output       [3:0]                   stopwatch_ringo_ready             ,
        input                                spine_resetn_active               ,
        output  reg                          spine_resetn_active_ready         ,
        input                                tm_redump_active                  ,
        output  reg                          tm_redump_active_ready            ,
        input                                stopwatch_period_active           ,
        output  reg                          stopwatch_period_active_ready     ,
        output       [3:0]                   dump_ready_out                    ,
        input        [27:0]                  init_spine_reset_time             ,
        input        [9:0]                   spine_resetn_width                ,
        input        [9:0]                   tm_redump_width                   ,
        input        [15:0]                  stopwatch_period_width_res        ,
        input        [15:0]                  stopwatch_period_width_ringo      ,
        input        [31:0]                  redump_tsv_tm_other_value0        ,
        input        [31:0]                  redump_tsv_tm_other_value1        ,
        input        [31:0]                  redump_tsv_tm_other_value2        ,
        input        [31:0]                  redump_tsv_tm_other_value3        ,
        input        [31:0]                  redump_tsv_tm_other_value4        ,
        input        [31:0]                  redump_tsv_tm_other_value5        ,
        input        [31:0]                  redump_tsv_tm_other_value6        ,
        input        [31:0]                  redump_tsv_tm_other_value7        ,
        input        [31:0]                  redump_tsv_tm_other_value8        ,
        input        [31:0]                  redump_tsv_tm_other_value9        ,
        input        [31:0]                  redump_tsv_tm_other_value10       ,
        input        [31:0]                  redump_tsv_tm_other_value11       ,
        input        [31:0]                  redump_tsv_tm_other_value12       ,
        input        [11:0]                  redump_tsv_tm_other_value13       ,
        input                                res_or_ringo_sel                  ,
        output       [79:0]                  hw_ringo_period_dram0             ,
        output       [79:0]                  hw_ringo_period_dram1             ,
        output       [79:0]                  hw_ringo_period_dram2             ,
        output       [79:0]                  hw_ringo_period_dram3             ,
        input        [13:0]                  hw_ringo_period_delay             ,
        input        [9:0]                   hw_period2ringo_dly               ,
        input        [8:0]                   res_mode_value                    ,
        input        [8:0]                   ringo_mode_value_reg0             ,
        input        [8:0]                   ringo_mode_value_reg1             ,
        input        [8:0]                   ringo_mode_value_reg2             ,
        input        [8:0]                   ringo_mode_value_reg3             ,
        input        [8:0]                   ringo_mode_value_reg4             ,
        input        [8:0]                   ringo_mode_value_reg5             ,
        input        [8:0]                   ringo_mode_value_reg6             ,
        input        [8:0]                   ringo_mode_value_reg7             ,
        //--------------DRAM SPINE--------------//
        output  reg  [DRAM_LAYER_NUM-1:0]    spine_reset_n                     ,
        output  reg  [DRAM_LAYER_NUM-1:0]    tm_redump                         ,
        output  reg  [DRAM_LAYER_NUM-1:0]    stopwatch_period                  ,
        output  reg  [428:1]                 tsv_tm                            ,
        input        [DRAM_LAYER_NUM-1:0]    dump_ready                        ,
        input        [DRAM_LAYER_NUM-1:0]    stopwatch_ringo                   ,
        input        [DRAM_LAYER_NUM*2-1:0]  osc_tm_res                        ,
        //--------------Debug and monitor--------------//
        output  reg  [3:0]                   sw_spine_reset_n_active_cnt_dbg   ,
        output  reg  [3:0]                   sw_tm_redump_active_cnt_dbg       ,
        output  reg  [3:0]                   sw_stopwatch_period_active_cnt_dbg,
        output  reg  [3:0]                   trim_start_cnt_dbg                ,
        output       [5:0]                   fsm_cs_dbg                        ,
        output  reg  [32:0]                  fsm_cs_flag_dbg                   ,
        output       [3:0]                   spine_reset_n_dbg                 ,
        output  reg  [3:0]                   tm_redump_edge_dbg                ,
        output  reg  [3:0]                   stopwatch_period_edge_dbg         ,
        output  reg  [3:0]                   stopwatch_ringo_edge_dbg          ,
        output       [59:0]                  trim_monitor                      ,
        input        [1:0]                   phy_debug_spine_reset_n           ,
        input        [1:0]                   phy_debug_tm_redump               ,
        input        [1:0]                   phy_debug_stopwatch_period        ,
        output  reg  [1:0]                   phy_debug_spine_reset_n_edge_dbg   ,
        output  reg  [1:0]                   phy_debug_tm_redump_edge_dbg       ,
        output  reg  [1:0]                   phy_debug_stopwatch_period_edge_dbg
    );





integer II;
integer II_FSM;



wire   [DRAM_LAYER_NUM-1:0]      dump_ready_reg              ;
wire   [DRAM_LAYER_NUM-1:0]      dump_ready_sync             ;
wire                             trim_start_internal_sync    ;
wire                             trim_start_external_sync    ;
reg                              trim_start_external_reg     ;
reg                              trim_start_reg              ;
wire                             trim_start_external_pedge   ;
wire                             init_start_sync             ;
wire                             trim_op_flow_sync           ;
reg    [7:0]                     trim_res_final              ;
reg    [7:0]                     trim_res_ext_sync           ;
reg    [7:0]                     trim_res_apb_sync           ;
reg    [1:0]                     res_value_sel_sync          ;
reg                              res_reload_mode             ;
reg    [3:0]                     dram_layer_sel_sync         ;
reg    [DRAM_LAYER_NUM-1:0]      res_ringo_done              ;
reg    [23:0]                    ringo_timeout_cnt[0:DRAM_LAYER_NUM-1];
reg    [23:0]                    ringo_timeout_time_sync     ;
reg    [DRAM_LAYER_NUM-1:0]      ringo_timeout_cnt_en        ;
wire                             ringo_timeout_clr_sync      ;
reg                              ringo_timeout_en_sync       ;
wire   [DRAM_LAYER_NUM-1:0]      res_ringo_process_done      ;
reg                              dumpready_timeout_en_sync   ;
wire                             dumpready_timeout_clr_sync  ;
reg    [23:0]                    dumpready_timeout_time_sync ;
reg    [23:0]                    dumpready_timeout_cnt[0:DRAM_LAYER_NUM-1];
reg    [DRAM_LAYER_NUM-1:0]      dumpready_timeout_cnt_flag  ;
wire   [DRAM_LAYER_NUM-1:0]      dumpready_high              ;
reg    [DRAM_LAYER_NUM-1:0]      dumpready_timeout_cnt_en ;
reg                              hw_op_tsv_load_sel_sync     ;
reg    [1:0]                     hw_res_wait_cnt             ;
reg    [1:0]                     hw_res_cfg_serial_cnt       ;
reg    [2:0]                     dram_layer_sel_num          ;
reg    [1:0]                     dram_layer_sel_num_reg      ;
reg    [DRAM_LAYER_NUM-1:0]      hw_res_cfg_serial_load      ;
reg    [DRAM_LAYER_NUM-1:0]      hw_ringo_cfg_serial_load    ;
wire                             hw_op_ringo_mask_sync       ;
reg    [1:0]                     hw_ringo_cfg_cnt            ;
reg    [2:0]                     hw_ringo_mode_cnt           ;
wire                             trim_interrupt_clr_sync     ;
wire                             trim_interrupt_mask_sync    ;
reg    [79:0]                    hw_ringo_period_record[DRAM_LAYER_NUM-1:0];

reg                              res_or_ringo_sel_reg        ;
wire   [427:0]                   redump_tsv_tm_other_value   ;
wire                             trim_cfg_update_sync        ;
wire                             spine_resetn_active_tmp     ;
wire                             tm_redump_active_tmp        ;
wire                             stopwatch_period_active_tmp ;
reg                              spine_resetn_active_sync    ;
reg                              tm_redump_active_sync       ;
reg                              stopwatch_period_active_sync;
reg    [27:0]                    init_spine_reset_time_sync  ;
reg    [27:0]                    init_spine_reset_time_cnt   ;
reg    [9:0]                     spine_resetn_width_sync     ;
reg    [9:0]                     spine_resetn_width_cnt      ;
reg    [9:0]                     tm_redump_width_sync        ;
reg    [9:0]                     tm_redump_width_cnt         ;
reg    [15:0]                    stopwatch_period_width_res_sync ;
reg    [15:0]                    stopwatch_period_width_ringo_sync ;
reg    [15:0]                    stopwatch_period_width_cnt  ;
reg    [5:0]                     stopwatch_ringo_shift[DRAM_LAYER_NUM-1:0];
reg    [DRAM_LAYER_NUM-1:0]      stopwatch_ringo_pedge       ;
reg    [DRAM_LAYER_NUM-1:0]      stopwatch_ringo_nedge       ;
reg    [DRAM_LAYER_NUM*2-1:0]    osc_tm_res_smp_reg          ;
reg    [DRAM_LAYER_NUM-1:0]      stopwatch_ringo_flag        ;
reg    [9:0]                     stopwatch_ringo_width_cnt[DRAM_LAYER_NUM-1:0];
reg    [DRAM_LAYER_NUM*10-1:0]   stopwatch_ringo_measure      ;
reg    [DRAM_LAYER_NUM-1:0]      stopwatch_ringo_measure_ready;
reg    [DRAM_LAYER_NUM-1:0]      res_or_ringo_sel_sync        ;
reg    [2:0]                     stopwatch_period_shift[DRAM_LAYER_NUM-1:0];
wire   [DRAM_LAYER_NUM-1:0]      stopwatch_period_nedge       ;
wire   [DRAM_LAYER_NUM-1:0]      stopwatch_ringo_sync         ;
reg    [1:0]                     dumpready_smp_cnt            ;
reg                              hw_op_ringo_mask_reg         ;
reg    [3:0]                     tm_redump_dly                ;
wire                             trim_debug_en                ;
reg    [13:0]                    hw_period_dly_cnt            ;
reg    [13:0]                    hw_ringo_period_delay_sync   ;
wire   [8:0]                     res_mode_cfg_value           ;
wire   [71:0]                    ringo_mode_cfg_value         ;
reg    [9:0]                     hw_period2ringo_dly_sync     ;
reg    [9:0]                     hw_period2ringo_dly_cnt      ;
reg                              ringo_clk_cnt_en             ;
reg    [9:0]                     ringo_clk_cnt                ;
reg                              ringo_clk_flag               ;
wire   [3:0]                     ringo_clk_ready              ;
reg    [3:0]                     hw_ringo_clk_flag_en         ;
reg    [3:0]                     phy_debug_spine_reset_n_shift_d0   ;
reg    [3:0]                     phy_debug_spine_reset_n_shift_d1   ;
reg    [3:0]                     phy_debug_tm_redump_shift_d0       ;
reg    [3:0]                     phy_debug_tm_redump_shift_d1       ;
reg    [3:0]                     phy_debug_stopwatch_period_shift_d0;
reg    [3:0]                     phy_debug_stopwatch_period_shift_d1;


assign res_mode_cfg_value = res_mode_value;
assign ringo_mode_cfg_value = {ringo_mode_value_reg7,ringo_mode_value_reg6,ringo_mode_value_reg5,ringo_mode_value_reg4,
                               ringo_mode_value_reg3,ringo_mode_value_reg2,ringo_mode_value_reg1,ringo_mode_value_reg0};






always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        init_spine_reset_time_sync <= 28'h7A1200;
        res_value_sel_sync         <= 2'd0;
        trim_res_ext_sync          <= 8'd0;
        trim_res_apb_sync          <= 8'd0;
        ringo_timeout_time_sync    <= 24'hBB8;
        ringo_timeout_en_sync      <= 1'b0;
        dumpready_timeout_en_sync  <= 1'b0;
        hw_op_tsv_load_sel_sync    <= 1'b0;
        dumpready_timeout_time_sync<= 24'hC3500;
        hw_ringo_period_delay_sync <= 14'h5;
        hw_period2ringo_dly_sync   <= 10'h78;
    end
    else if(init_start_sync || trim_start_reg)begin
        init_spine_reset_time_sync <= init_spine_reset_time;
        res_value_sel_sync         <= res_value_sel;
        trim_res_ext_sync          <= trim_res_ext;
        trim_res_apb_sync          <= trim_res_apb;
        ringo_timeout_time_sync    <= ringo_timeout_time;
        ringo_timeout_en_sync      <= ringo_timeout_en;
        dumpready_timeout_en_sync  <= dumpready_timeout_en;
        hw_op_tsv_load_sel_sync    <= hw_op_tsv_load_sel;
        dumpready_timeout_time_sync<= dumpready_timeout_time;
        hw_ringo_period_delay_sync <= hw_ringo_period_delay;
        hw_period2ringo_dly_sync   <= hw_period2ringo_dly;
    end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        dram_layer_sel_sync <= 4'hF;
    else if(init_start_sync || trim_start_reg || spine_resetn_active_tmp || tm_redump_active_tmp || stopwatch_period_active_tmp)
        dram_layer_sel_sync <= dram_layer_sel;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        spine_resetn_width_sync <= 10'h13;
    else if(spine_resetn_active_sync || trim_start_reg)
        spine_resetn_width_sync <= spine_resetn_width;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        tm_redump_width_sync <= 10'h3;
    else if(tm_redump_active_sync || trim_start_reg)
        tm_redump_width_sync <= tm_redump_width;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        stopwatch_period_width_res_sync   <= 16'h18F;
        stopwatch_period_width_ringo_sync <= 16'h3;
    end
    else if(stopwatch_period_active_sync || trim_start_reg)begin
        stopwatch_period_width_res_sync   <= stopwatch_period_width_res;
        stopwatch_period_width_ringo_sync <= stopwatch_period_width_ringo;
    end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        spine_resetn_active_sync     <= 1'b0;
        tm_redump_active_sync        <= 1'b0;
        stopwatch_period_active_sync <= 1'b0;
    end
    else begin
        spine_resetn_active_sync     <= spine_resetn_active_tmp;
        tm_redump_active_sync        <= tm_redump_active_tmp;
        stopwatch_period_active_sync <= stopwatch_period_active_tmp;
    end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        res_or_ringo_sel_reg <= 1'b0;
    else if(stopwatch_period_active_sync)
        res_or_ringo_sel_reg <= res_or_ringo_sel;
end


always @ (*)
begin
    dram_layer_sel_num = 3'd0;
    for(II=0;II<DRAM_LAYER_NUM;II=II+1)
        if(dram_layer_sel_sync[II])
            dram_layer_sel_num = dram_layer_sel_num + 1'b1;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        dram_layer_sel_num_reg <= 2'd0;
    else
        dram_layer_sel_num_reg <= dram_layer_sel_num-1'b1;
end





localparam  IDLE          = 6'd0,
            INIT          = 6'd1,
            WAIT_OP       = 6'd2,
            SPINE_RST     = 6'd3,
            REDUMP        = 6'd4,
            PERIOD        = 6'd5,
            HW_RES_ENWAIT = 6'd6,
            HW_RES_EN0    = 6'd7,
            HW_RES_EN1    = 6'd8,
            HW_OP_DLY0    = 6'd9,
            HW_DUMPRDY0   = 6'd10,
            HW_RES_PER    = 6'd11,
            HW_RES_SMP    = 6'd12,
            HW_RES_WAIT   = 6'd13,
            HW_RES_CFG0_P = 6'd14,
            HW_RES_CFG0_S = 6'd15,
            HW_RES_CFG1_P = 6'd16,
            HW_RES_CFG1_S = 6'd17,
            HW_OP_DLY1    = 6'd18,
            HW_DUMPRDY1   = 6'd19,
            HW_RINGO_WAIT = 6'd20,
            HW_RINGO_CFG0 = 6'd21,
            HW_RINGO_CFG1 = 6'd22,
            HW_OP_DLY2    = 6'd23,
            HW_DUMPRDY2   = 6'd24,
            HW_PER_DLY    = 6'd25,
            HW_RINGO_PER  = 6'd26,
            HW_RINGO_DLY  = 6'd27,
            HW_RINGO_CLK  = 6'd28,
            HW_RINGO_DIS0 = 6'd29,
            HW_RINGO_DIS1 = 6'd30,
            HW_OP_DLY3    = 6'd31,
            HW_DUMPRDY3   = 6'd32;

reg [5:0] fsm_cs;
reg [5:0] fsm_ns;

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        fsm_cs <= IDLE;
    else
        fsm_cs <= fsm_ns;
end


always @ (*)
begin
    case(fsm_cs)
        IDLE: fsm_ns = ((init_start_sync && trim_op_flow_sync) || (trim_start_reg && ~trim_op_flow_sync)) ? INIT : IDLE;
        INIT:
            begin
                if(init_spine_reset_time_cnt==init_spine_reset_time_sync)
                    fsm_ns = trim_op_flow_sync ? WAIT_OP : HW_DUMPRDY0;
                else
                    fsm_ns = INIT;
            end
        WAIT_OP  :
			begin
				if(spine_resetn_active_sync)
					fsm_ns = SPINE_RST;
				else if(tm_redump_active_sync)
					fsm_ns = REDUMP;
				else if(stopwatch_period_active_sync)
					fsm_ns = PERIOD;
				else if(trim_start_reg)
					//fsm_ns = hw_op_ringo_mask_reg ? HW_DUMPRDY0 : HW_RES_ENWAIT;
					fsm_ns = HW_RES_ENWAIT;
				else
					fsm_ns = WAIT_OP;
			end
        SPINE_RST    : fsm_ns = (spine_resetn_width_cnt==spine_resetn_width_sync) ? WAIT_OP : SPINE_RST;
        REDUMP       : fsm_ns = (tm_redump_width_cnt==tm_redump_width_sync) ? WAIT_OP : REDUMP;
        PERIOD       :
            begin
                if(res_or_ringo_sel_reg)
                    fsm_ns = (stopwatch_period_width_cnt==stopwatch_period_width_ringo_sync) ? WAIT_OP : PERIOD;
                else
                    fsm_ns = (stopwatch_period_width_cnt==stopwatch_period_width_res_sync) ? WAIT_OP : PERIOD;
            end
        HW_RES_ENWAIT: fsm_ns = hw_op_tsv_load_sel_sync ? HW_RES_EN1 : HW_RES_EN0;
        HW_RES_EN0   : fsm_ns = (tm_redump_width_cnt==tm_redump_width_sync) ? HW_OP_DLY0 : HW_RES_EN0;
        HW_RES_EN1   : fsm_ns = (spine_resetn_width_cnt==spine_resetn_width_sync) ? HW_OP_DLY0 : HW_RES_EN1;
        HW_OP_DLY0   : fsm_ns = (dumpready_smp_cnt==2'd3) ? HW_DUMPRDY0 : HW_OP_DLY0;
        HW_DUMPRDY0  :
			begin
				if(dumpready_high==4'hF)
					if(res_value_sel_sync==2'd0)
						fsm_ns = HW_RES_PER;
					else
						fsm_ns = HW_RES_WAIT;
				else
					fsm_ns = HW_DUMPRDY0;
			end
        HW_RES_PER   : fsm_ns = (stopwatch_period_width_cnt==stopwatch_period_width_res_sync) ? HW_RES_SMP : HW_RES_PER;
        HW_RES_SMP   : fsm_ns = (res_ringo_process_done==4'hF) ? HW_RES_WAIT : HW_RES_SMP;
        HW_RES_WAIT  :
            begin
                if(hw_res_wait_cnt==2'd3)begin
                    if(~hw_op_tsv_load_sel_sync)
                        fsm_ns = res_reload_mode ? HW_RES_CFG0_P : HW_RES_CFG0_S;
                    else
                        fsm_ns = res_reload_mode ? HW_RES_CFG1_P : HW_RES_CFG1_S;
                end
                else
                    fsm_ns = HW_RES_WAIT;
            end
        HW_RES_CFG0_P: fsm_ns = (tm_redump_width_cnt==tm_redump_width_sync) ? HW_OP_DLY1 : HW_RES_CFG0_P;
        HW_RES_CFG0_S: fsm_ns = (tm_redump_width_cnt==tm_redump_width_sync && hw_res_cfg_serial_cnt==dram_layer_sel_num_reg) ? HW_OP_DLY1 : HW_RES_CFG0_S;
        HW_RES_CFG1_P: fsm_ns = (spine_resetn_width_cnt==spine_resetn_width_sync) ? HW_OP_DLY1 : HW_RES_CFG1_P;
        HW_RES_CFG1_S: fsm_ns = (spine_resetn_width_cnt==spine_resetn_width_sync && hw_res_cfg_serial_cnt==dram_layer_sel_num_reg) ? HW_OP_DLY1 : HW_RES_CFG1_S;
        HW_OP_DLY1   : fsm_ns = (dumpready_smp_cnt==2'd3) ? HW_DUMPRDY1 : HW_OP_DLY1;
        HW_DUMPRDY1  :
            begin
                if(dumpready_high==4'hF)begin
                    if(hw_op_ringo_mask_sync)
                        fsm_ns = WAIT_OP;
                    else
                        fsm_ns = HW_RINGO_WAIT;
                end
                else
                    fsm_ns = HW_DUMPRDY1;
            end
        HW_RINGO_WAIT: fsm_ns = hw_op_tsv_load_sel_sync ? HW_RINGO_CFG1 : HW_RINGO_CFG0;
        HW_RINGO_CFG0: fsm_ns = (tm_redump_width_cnt==tm_redump_width_sync && hw_ringo_cfg_cnt==dram_layer_sel_num_reg) ? HW_OP_DLY2 : HW_RINGO_CFG0;
        HW_RINGO_CFG1: fsm_ns = (spine_resetn_width_cnt==spine_resetn_width_sync && hw_ringo_cfg_cnt==dram_layer_sel_num_reg) ? HW_OP_DLY2 : HW_RINGO_CFG1;
        HW_OP_DLY2   : fsm_ns = (dumpready_smp_cnt==2'd3) ? HW_DUMPRDY2 : HW_OP_DLY2;
        HW_DUMPRDY2  : fsm_ns = (dumpready_high==4'hF) ? HW_PER_DLY : HW_DUMPRDY2;
        HW_PER_DLY   : fsm_ns = (hw_period_dly_cnt==hw_ringo_period_delay_sync) ? HW_RINGO_PER : HW_PER_DLY;
        HW_RINGO_PER : fsm_ns = (stopwatch_period_width_cnt==stopwatch_period_width_ringo_sync) ? HW_RINGO_DLY : HW_RINGO_PER;
        HW_RINGO_DLY : fsm_ns = (hw_period2ringo_dly_cnt==hw_period2ringo_dly_sync) ? HW_RINGO_CLK : HW_RINGO_DLY;
        HW_RINGO_CLK :
            begin
                if(res_ringo_process_done==4'hF)
                    fsm_ns = hw_op_tsv_load_sel_sync ? HW_RINGO_DIS1 : HW_RINGO_DIS0;
                else
                    fsm_ns = HW_RINGO_CLK;
            end
        HW_RINGO_DIS0:
            begin
                if(tm_redump_width_cnt==tm_redump_width_sync && hw_ringo_cfg_cnt==dram_layer_sel_num_reg)
                    fsm_ns = HW_OP_DLY3;
                else
                    fsm_ns = HW_RINGO_DIS0;

            end
        HW_RINGO_DIS1:
            begin
                if(spine_resetn_width_cnt==spine_resetn_width_sync && hw_ringo_cfg_cnt==dram_layer_sel_num_reg)
                    fsm_ns = HW_OP_DLY3;
                else
                    fsm_ns = HW_RINGO_DIS1;
            end
        HW_OP_DLY3 : fsm_ns = (dumpready_smp_cnt==2'd3) ? HW_DUMPRDY3 : HW_OP_DLY3;
        HW_DUMPRDY3:
            begin
                if(dumpready_high==4'hF)
                    fsm_ns = (hw_ringo_mode_cnt==3'd7) ? WAIT_OP : HW_RINGO_WAIT;
                else
                    fsm_ns = HW_DUMPRDY3;
            end
        default: fsm_ns = IDLE;
    endcase
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        hw_period_dly_cnt <= 'd0;
    else if(fsm_cs==HW_PER_DLY)
        hw_period_dly_cnt <= hw_period_dly_cnt + 1'b1;
    else
        hw_period_dly_cnt <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        hw_period2ringo_dly_cnt <= 'd0;
    else if(fsm_cs==HW_RINGO_DLY)
        hw_period2ringo_dly_cnt <= hw_period2ringo_dly_cnt + 1'b1;
    else
        hw_period2ringo_dly_cnt <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        dumpready_smp_cnt <= 'd0;
    else if(fsm_cs==HW_OP_DLY0 || fsm_cs==HW_OP_DLY1 || fsm_cs==HW_OP_DLY2 || fsm_cs==HW_OP_DLY3)
        dumpready_smp_cnt <= dumpready_smp_cnt + 1'b1;
    else
        dumpready_smp_cnt <= 'd0;
end


always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        hw_res_wait_cnt <= 'd0;
    else if(fsm_cs==HW_RES_WAIT)
        hw_res_wait_cnt <= hw_res_wait_cnt + 1'b1;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        hw_res_cfg_serial_cnt <= 2'd0;
    else if(fsm_cs==HW_RES_CFG0_S && tm_redump_width_cnt==tm_redump_width_sync)begin
        if(hw_res_cfg_serial_cnt==dram_layer_sel_num_reg)
            hw_res_cfg_serial_cnt <= 2'd0;
        else
            hw_res_cfg_serial_cnt <= hw_res_cfg_serial_cnt + 1'b1;
    end
    else if(fsm_cs==HW_RES_CFG1_S && spine_resetn_width_cnt==spine_resetn_width_sync)begin
        if(hw_res_cfg_serial_cnt==dram_layer_sel_num_reg)
            hw_res_cfg_serial_cnt <= 2'd0;
        else
            hw_res_cfg_serial_cnt <= hw_res_cfg_serial_cnt + 1'b1;
    end
end

always @ (*)
begin
    if(fsm_cs==HW_RES_CFG0_S)
        hw_res_cfg_serial_load = (4'h1<<hw_res_cfg_serial_cnt);
    else if(fsm_cs==HW_RES_CFG1_S)
        hw_res_cfg_serial_load = ~(4'h1<<hw_res_cfg_serial_cnt);
    else
        hw_res_cfg_serial_load = 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        hw_ringo_cfg_cnt <= 'd0;
    else if((fsm_cs==HW_RINGO_CFG0 || fsm_cs==HW_RINGO_DIS0) && tm_redump_width_cnt==tm_redump_width_sync)begin
        if(hw_ringo_cfg_cnt==dram_layer_sel_num_reg)
            hw_ringo_cfg_cnt <= 'd0;
        else
            hw_ringo_cfg_cnt <= hw_ringo_cfg_cnt + 1'b1;
    end
    else if((fsm_cs==HW_RINGO_CFG1 || fsm_cs==HW_RINGO_DIS1) && spine_resetn_width_cnt==spine_resetn_width_sync)begin
        if(hw_ringo_cfg_cnt==dram_layer_sel_num_reg)
            hw_ringo_cfg_cnt <= 'd0;
        else
            hw_ringo_cfg_cnt <= hw_ringo_cfg_cnt + 1'b1;
    end
end

always @ (*)
begin
    if(fsm_cs==HW_RINGO_CFG0 || fsm_cs==HW_RINGO_DIS0)
        hw_ringo_cfg_serial_load = (4'h1<<hw_ringo_cfg_cnt);
    else if(fsm_cs==HW_RINGO_CFG1 || fsm_cs==HW_RINGO_DIS1)
        hw_ringo_cfg_serial_load = ~(4'h1<<hw_ringo_cfg_cnt);
    else
        hw_ringo_cfg_serial_load = 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        hw_ringo_mode_cnt <= 'd0;
    else if(fsm_cs==HW_DUMPRDY3 && dumpready_high==4'hF)
        hw_ringo_mode_cnt <= hw_ringo_mode_cnt + 1'b1;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        trim_start_external_reg <= 1'b0;
    else
        trim_start_external_reg <= trim_start_external_sync;
end

assign trim_start_external_pedge = ~trim_start_external_reg && trim_start_external_sync;

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        trim_start_reg <= 1'b0;
    else if(~trim_op_flow_sync)
        trim_start_reg <= (trim_start_external_pedge || trim_start_internal_sync);
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        init_done_flag <= 1'b0;
    else if(init_spine_reset_time_cnt==init_spine_reset_time_sync)
        init_done_flag <= 1'b1;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        trim_res_final <= 8'd0;
    else if(fsm_cs==HW_RES_WAIT && hw_res_wait_cnt==2'd0)begin
        case(res_value_sel_sync)
            2'd0: trim_res_final <= {osc_tm_res_smp_value[6],osc_tm_res_smp_value[7],
                                     osc_tm_res_smp_value[4],osc_tm_res_smp_value[5],
                                     osc_tm_res_smp_value[2],osc_tm_res_smp_value[3],
                                     osc_tm_res_smp_value[0],osc_tm_res_smp_value[1]};
            2'd1: trim_res_final <= {trim_res_apb_sync[6],trim_res_apb_sync[7],
                                     trim_res_apb_sync[4],trim_res_apb_sync[5],
                                     trim_res_apb_sync[2],trim_res_apb_sync[3],
                                     trim_res_apb_sync[0],trim_res_apb_sync[1]};
            2'd2: trim_res_final <= {trim_res_ext_sync[6],trim_res_ext_sync[7],
                                     trim_res_ext_sync[4],trim_res_ext_sync[5],
                                     trim_res_ext_sync[2],trim_res_ext_sync[3],
                                     trim_res_ext_sync[0],trim_res_ext_sync[1]};
            2'd3: trim_res_final <= {osc_tm_res_smp_value[6],osc_tm_res_smp_value[7],
                                     osc_tm_res_smp_value[4],osc_tm_res_smp_value[5],
                                     osc_tm_res_smp_value[2],osc_tm_res_smp_value[3],
                                     osc_tm_res_smp_value[0],osc_tm_res_smp_value[1]};
        endcase
    end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        res_reload_mode <= 1'b0;
    else if(fsm_cs==HW_RES_WAIT && hw_res_wait_cnt==2'd1)begin
        if(trim_res_final[0*2+:2]==trim_res_final[1*2+:2] && trim_res_final[1*2+:2]==trim_res_final[2*2+:2] && trim_res_final[2*2+:2]==trim_res_final[3*2+:2])
            res_reload_mode <= 1'b1;
        else
            res_reload_mode <= 1'b0;
    end
end

assign redump_tsv_tm_other_value = {redump_tsv_tm_other_value13,redump_tsv_tm_other_value12,
                                    redump_tsv_tm_other_value11,redump_tsv_tm_other_value10,
                                    redump_tsv_tm_other_value9,redump_tsv_tm_other_value8,
                                    redump_tsv_tm_other_value7,redump_tsv_tm_other_value6,
                                    redump_tsv_tm_other_value5,redump_tsv_tm_other_value4,
                                    redump_tsv_tm_other_value3,redump_tsv_tm_other_value2,
                                    redump_tsv_tm_other_value1,redump_tsv_tm_other_value0};

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        tsv_tm <= 'd0;
    else if(spine_resetn_active_sync || tm_redump_active_sync || (fsm_cs==IDLE && trim_start_reg))
        tsv_tm <= redump_tsv_tm_other_value;
    else if(fsm_cs==HW_RES_WAIT && hw_res_wait_cnt==2'd2 && res_reload_mode)
        tsv_tm <= {tsv_tm[428:261],trim_res_final[1:0],tsv_tm[258:248],9'd0,tsv_tm[238:1]};
    else if((fsm_cs==HW_RES_CFG0_S && tm_redump_width_cnt==10'd2) || (fsm_cs==HW_RES_CFG1_S && spine_resetn_width_cnt==10'd2))
        tsv_tm <= {tsv_tm[428:261],trim_res_final[hw_res_cfg_serial_cnt*2+:2],tsv_tm[258:248],9'd0,tsv_tm[238:1]};
    else if(fsm_cs==HW_RINGO_WAIT || (fsm_cs==HW_RINGO_CFG0 && tm_redump_width_cnt==10'd2) || (fsm_cs==HW_RINGO_CFG1 && spine_resetn_width_cnt==10'd2))
        tsv_tm <= {tsv_tm[428:261],trim_res_final[hw_ringo_cfg_cnt*2+:2],tsv_tm[258:248],ringo_mode_cfg_value[hw_ringo_mode_cnt*9+:9],tsv_tm[238:1]};
    else if(fsm_cs==WAIT_OP && trim_start_reg)
        tsv_tm <= {tsv_tm[428:261],2'b00,tsv_tm[258:248],res_mode_cfg_value,tsv_tm[238:1]};
    else if((fsm_cs==HW_RINGO_DIS0 && tm_redump_width_cnt==10'd2) || (fsm_cs==HW_RINGO_DIS1 && spine_resetn_width_cnt==10'd2))
        tsv_tm <= {tsv_tm[428:261],trim_res_final[hw_ringo_cfg_cnt*2+:2],tsv_tm[258:248],9'd0,tsv_tm[238:1]};
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        init_spine_reset_time_cnt <= 'd0;
    else if(fsm_cs==INIT)
        init_spine_reset_time_cnt <= init_spine_reset_time_cnt + 1'b1;
    else
        init_spine_reset_time_cnt <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        spine_resetn_width_cnt <= 'd0;
    else if(fsm_cs==SPINE_RST || fsm_cs==HW_RES_CFG1_P || fsm_cs==HW_RES_CFG1_S || fsm_cs==HW_RINGO_CFG1 || fsm_cs==HW_RES_EN1 || fsm_cs==HW_RINGO_DIS1)begin
        if(spine_resetn_width_cnt==spine_resetn_width_sync)
            spine_resetn_width_cnt <= 'd0;
        else
            spine_resetn_width_cnt <= spine_resetn_width_cnt + 1'b1;
    end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        spine_reset_n <= 1'b0;
    else if(init_spine_reset_time_cnt==init_spine_reset_time_sync)
        spine_reset_n <= {DRAM_LAYER_NUM{1'b1}};
    else if(spine_resetn_active_sync || fsm_cs==HW_RES_CFG1_P || (fsm_cs==HW_RES_ENWAIT && hw_op_tsv_load_sel_sync))begin
        for(II=0;II<DRAM_LAYER_NUM;II=II+1)
            if(dram_layer_sel_sync[II])
                spine_reset_n[II] <= 1'b0;
    end
    else if(fsm_cs==HW_RES_CFG1_S)begin
        for(II=0;II<DRAM_LAYER_NUM;II=II+1)
            spine_reset_n[II] <= hw_res_cfg_serial_load[II];
    end
    else if(fsm_cs==HW_RINGO_CFG1 || fsm_cs==HW_RINGO_DIS1)begin
        for(II=0;II<DRAM_LAYER_NUM;II=II+1)
            spine_reset_n[II] <= hw_ringo_cfg_serial_load[II];
    end
    else if(((fsm_cs==SPINE_RST || fsm_cs==HW_RES_EN1) && spine_resetn_width_cnt==spine_resetn_width_sync) || fsm_cs==HW_OP_DLY1 || fsm_cs==HW_OP_DLY2 || fsm_cs==HW_OP_DLY3)
        spine_reset_n <= {DRAM_LAYER_NUM{1'b1}};
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        spine_resetn_active_ready <= 1'b1;
    else if(spine_resetn_active_sync)
        spine_resetn_active_ready <= 1'b0;
    else if(spine_resetn_width_cnt==spine_resetn_width_sync)
        spine_resetn_active_ready <= 1'b1;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        tm_redump_width_cnt <= 10'd0;
    else if(fsm_cs==REDUMP || fsm_cs==HW_RES_CFG0_P || fsm_cs==HW_RES_CFG0_S || fsm_cs==HW_RINGO_CFG0 || fsm_cs==HW_RES_EN0 || fsm_cs==HW_RINGO_DIS0)begin
        if(tm_redump_width_cnt==tm_redump_width_sync)
            tm_redump_width_cnt <= 10'd0;
        else
            tm_redump_width_cnt <= tm_redump_width_cnt + 1'b1;
    end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        tm_redump <= 'd0;
    else if(tm_redump_active_sync || fsm_cs==HW_RES_CFG0_P || (fsm_cs==HW_RES_ENWAIT && ~hw_op_tsv_load_sel_sync))begin
        for(II=0;II<DRAM_LAYER_NUM;II=II+1)
            if(dram_layer_sel_sync[II])
                tm_redump[II] <= 1'b1;
    end
    else if(fsm_cs==HW_RES_CFG0_S)begin
        for(II=0;II<DRAM_LAYER_NUM;II=II+1)
            tm_redump[II] <= hw_res_cfg_serial_load[II];
    end
    else if(fsm_cs==HW_RINGO_CFG0 || fsm_cs==HW_RINGO_DIS0)begin
        for(II=0;II<DRAM_LAYER_NUM;II=II+1)
            tm_redump[II] <= hw_ringo_cfg_serial_load[II];
    end
    else if(((fsm_cs==REDUMP || fsm_cs==HW_RES_EN0) && tm_redump_width_cnt==tm_redump_width_sync) || fsm_cs==HW_OP_DLY1 || fsm_cs==HW_OP_DLY2 || fsm_cs==HW_OP_DLY3)
        tm_redump <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        tm_redump_active_ready <= 1'b1;
    else if(tm_redump_active_sync)
        tm_redump_active_ready <= 1'b0;
    else if(tm_redump_width_cnt==tm_redump_width_sync)
        tm_redump_active_ready <= 1'b1;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        stopwatch_period_width_cnt <= 'd0;
    else if(fsm_cs==PERIOD || fsm_cs==HW_RES_PER || fsm_cs==HW_RINGO_PER)
        stopwatch_period_width_cnt <= stopwatch_period_width_cnt + 1'b1;
    else
        stopwatch_period_width_cnt <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        stopwatch_period <= 'd0;
    else if(stopwatch_period_active_sync)begin
        for(II=0;II<DRAM_LAYER_NUM;II=II+1)
            if(dram_layer_sel_sync[II])
                stopwatch_period[II] <= 1'b1;
    end
    else if(dumpready_high==4'hF && ((fsm_cs==HW_DUMPRDY0 && fsm_ns==HW_RES_PER) || (fsm_cs==HW_PER_DLY && fsm_ns==HW_RINGO_PER)))begin
        for(II=0;II<DRAM_LAYER_NUM;II=II+1)
            if(dram_layer_sel_sync[II])
                stopwatch_period[II] <= 1'b1;
    end
    else if(stopwatch_period_width_cnt==stopwatch_period_width_res_sync && (fsm_cs==HW_RES_PER || (fsm_cs==PERIOD && ~res_or_ringo_sel_reg)))
        stopwatch_period <= 'd0;
    else if(stopwatch_period_width_cnt==stopwatch_period_width_ringo_sync && (fsm_cs==HW_RINGO_PER || (fsm_cs==PERIOD && res_or_ringo_sel_reg)))
        stopwatch_period <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        stopwatch_period_active_ready <= 1'b1;
    else if(stopwatch_period_active_sync)
        stopwatch_period_active_ready <= 1'b0;
    else if(stopwatch_period_width_cnt==stopwatch_period_width_res_sync && fsm_cs==PERIOD && ~res_or_ringo_sel_reg)
        stopwatch_period_active_ready <= 1'b1;
    else if(stopwatch_period_width_cnt==stopwatch_period_width_ringo_sync && fsm_cs==PERIOD && res_or_ringo_sel_reg)
        stopwatch_period_active_ready <= 1'b1;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        ringo_clk_cnt_en <= 1'b0;
    else if(ringo_clk_cnt==hw_period2ringo_dly_sync)
        ringo_clk_cnt_en <= 1'b0;
    else if(stopwatch_period_width_cnt==stopwatch_period_width_ringo_sync && fsm_cs==PERIOD && res_or_ringo_sel_reg)
        ringo_clk_cnt_en <= 1'b1;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        ringo_clk_cnt <= 'd0;
    else if(ringo_clk_cnt_en)
        ringo_clk_cnt <= ringo_clk_cnt + 1'b1;
    else
        ringo_clk_cnt <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        ringo_clk_flag <= 1'b0;
    else if(ringo_clk_ready==4'hF)
        ringo_clk_flag <= 1'b0;
    else if(ringo_clk_cnt==hw_period2ringo_dly_sync)
        ringo_clk_flag <= 1'b1;
end

assign ringo_clk_ready = ~dram_layer_sel_sync | stopwatch_ringo_measure_ready;



generate
genvar LAYER_I;
for(LAYER_I=0;LAYER_I<DRAM_LAYER_NUM;LAYER_I=LAYER_I+1)begin:stopwatch_loop

    assign dumpready_high[LAYER_I] = dram_layer_sel_sync[LAYER_I] ? (dumpready_timeout_cnt_flag[LAYER_I] | dump_ready_reg[LAYER_I]) : 1'b1;

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            dumpready_timeout_cnt_en[LAYER_I] <= 1'b0;
        else if(dumpready_timeout_clr_sync)
            dumpready_timeout_cnt_en[LAYER_I] <= 1'b0;
        else if(init_spine_reset_time_cnt==init_spine_reset_time_sync && dram_layer_sel_sync[LAYER_I])
            dumpready_timeout_cnt_en[LAYER_I] <= 1'b1;
        else if(spine_resetn_width_cnt==spine_resetn_width_sync && dram_layer_sel_sync[LAYER_I])
            dumpready_timeout_cnt_en[LAYER_I] <= 1'b1;
        else if(tm_redump_width_cnt==tm_redump_width_sync && dram_layer_sel_sync[LAYER_I])
            dumpready_timeout_cnt_en[LAYER_I] <= 1'b1;
        else if(dumpready_timeout_cnt[LAYER_I]==dumpready_timeout_time_sync || (dumpready_timeout_cnt[LAYER_I]>24'd10 && dumpready_high[LAYER_I] && dram_layer_sel_sync[LAYER_I]))
            dumpready_timeout_cnt_en[LAYER_I] <= 1'b0;
    end

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            dumpready_timeout_cnt[LAYER_I] <= 'd0;
        else if(dumpready_timeout_clr_sync)
            dumpready_timeout_cnt[LAYER_I] <= 'd0;
        else if(spine_resetn_width_cnt==spine_resetn_width_sync && dram_layer_sel_sync[LAYER_I])
            dumpready_timeout_cnt[LAYER_I] <= 'd0;
        else if(tm_redump_width_cnt==tm_redump_width_sync && dram_layer_sel_sync[LAYER_I])
            dumpready_timeout_cnt[LAYER_I] <= 'd0;
        else if(dumpready_timeout_en_sync && (dumpready_timeout_cnt_en[LAYER_I] || (dram_layer_sel_sync[LAYER_I] && (fsm_cs==HW_DUMPRDY0 || fsm_cs==HW_DUMPRDY1))))begin
            if(dumpready_timeout_cnt[LAYER_I]==dumpready_timeout_time_sync)
                dumpready_timeout_cnt[LAYER_I] <= dumpready_timeout_cnt[LAYER_I];
            else
                dumpready_timeout_cnt[LAYER_I] <= dumpready_timeout_cnt[LAYER_I] + 1'b1;
        end
        else
            dumpready_timeout_cnt[LAYER_I] <= 'd0;
    end

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            dumpready_timeout_cnt_flag[LAYER_I] <= 1'b0;
        else if(dumpready_timeout_clr_sync)
            dumpready_timeout_cnt_flag[LAYER_I] <= 1'b0;
        else if(spine_resetn_width_cnt==spine_resetn_width_sync && dram_layer_sel_sync[LAYER_I])
            dumpready_timeout_cnt_flag[LAYER_I] <= 1'b0;
        else if(tm_redump_width_cnt==tm_redump_width_sync && dram_layer_sel_sync[LAYER_I])
            dumpready_timeout_cnt_flag[LAYER_I] <= 1'b0;
        else if(dumpready_timeout_cnt[LAYER_I]==dumpready_timeout_time_sync)
            dumpready_timeout_cnt_flag[LAYER_I] <= 1'b1;
    end
    assign dumpready_timeout_flag[LAYER_I] = dumpready_timeout_cnt_flag[LAYER_I];
    assign dumpready_timeout_ready[LAYER_I] = dumpready_timeout_cnt_flag[LAYER_I];

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            res_or_ringo_sel_sync[LAYER_I] <= 1'b0;
        else if(stopwatch_period_active_sync && dram_layer_sel_sync[LAYER_I])
            res_or_ringo_sel_sync[LAYER_I] <= res_or_ringo_sel;
    end

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            stopwatch_period_shift[LAYER_I] <= 'd0;
        else
            stopwatch_period_shift[LAYER_I] <= {stopwatch_period_shift[LAYER_I][1:0],stopwatch_period[LAYER_I]};
    end
    
    assign stopwatch_period_nedge[LAYER_I] = stopwatch_period_shift[LAYER_I][2:1]==2'b10;
    
    
    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            stopwatch_ringo_shift[LAYER_I] <= 6'd0;
        else if(dram_layer_sel_sync[LAYER_I])
            stopwatch_ringo_shift[LAYER_I] <= {stopwatch_ringo_shift[LAYER_I][4:0],stopwatch_ringo_sync[LAYER_I]};
        else
            stopwatch_ringo_shift[LAYER_I] <= 6'd0;
    end

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            stopwatch_ringo_pedge[LAYER_I] <= 1'b0;
        else if(dram_layer_sel_sync[LAYER_I] && stopwatch_ringo_shift[LAYER_I]==6'b011111)
            stopwatch_ringo_pedge[LAYER_I] <= 1'b1;
        else
            stopwatch_ringo_pedge[LAYER_I] <= 1'b0;
    end
    
    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            stopwatch_ringo_nedge[LAYER_I] <= 1'b0;
        else if(dram_layer_sel_sync[LAYER_I] && stopwatch_ringo_shift[LAYER_I]==6'b100000)
            stopwatch_ringo_nedge[LAYER_I] <= 1'b1;
        else
            stopwatch_ringo_nedge[LAYER_I] <= 1'b0;
    end

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            osc_tm_res_smp_reg[LAYER_I*2+:2] <= 2'd0;
        else if(((spine_resetn_active_sync || tm_redump_active_sync) && dram_layer_sel_sync[LAYER_I]) || trim_start_reg)
            osc_tm_res_smp_reg[LAYER_I*2+:2] <= 2'd0;
        else if(stopwatch_ringo_pedge[LAYER_I] && ~res_or_ringo_sel_sync[LAYER_I] && trim_op_flow_sync)
            osc_tm_res_smp_reg[LAYER_I*2+:2] <= osc_tm_res[LAYER_I*2+:2];
        else if((stopwatch_ringo_pedge[LAYER_I] || ringo_timeout_cnt[LAYER_I]==ringo_timeout_time_sync) && ~trim_op_flow_sync)
            osc_tm_res_smp_reg[LAYER_I*2+:2] <= osc_tm_res[LAYER_I*2+:2];
    end

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            osc_tm_res_smp_ready[LAYER_I] <= 1'b0;
        else if(init_start_sync || trim_start_reg || stopwatch_period_nedge[LAYER_I])
            osc_tm_res_smp_ready[LAYER_I] <= 1'b0;
        else if(stopwatch_ringo_pedge[LAYER_I] && ~res_or_ringo_sel_sync[LAYER_I] && trim_op_flow_sync)
            osc_tm_res_smp_ready[LAYER_I] <= 1'b1;
        else if((stopwatch_ringo_pedge[LAYER_I] || ringo_timeout_cnt[LAYER_I]==ringo_timeout_time_sync) && ~trim_op_flow_sync)
            osc_tm_res_smp_ready[LAYER_I] <= 1'b1;
    end
    
    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            res_ringo_done[LAYER_I] <= 1'b1;
        else if((trim_start_reg || fsm_cs==HW_RINGO_PER) && dram_layer_sel_sync[LAYER_I])
            res_ringo_done[LAYER_I] <= 1'b0;
        else if((stopwatch_ringo_pedge[LAYER_I] && fsm_cs==HW_RES_SMP) || (stopwatch_ringo_flag[LAYER_I] && stopwatch_ringo_nedge[LAYER_I] && fsm_cs==HW_RINGO_CLK))
            res_ringo_done[LAYER_I] <= 1'b1;
    end

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            ringo_timeout_cnt_en[LAYER_I] <= 1'b0;
        else if(stopwatch_ringo_pedge[LAYER_I] || ringo_timeout_flag[LAYER_I] || ringo_timeout_clr_sync)
            ringo_timeout_cnt_en[LAYER_I] <= 1'b0;
        else if(stopwatch_period_nedge[LAYER_I] && ringo_timeout_en_sync)
            ringo_timeout_cnt_en[LAYER_I] <= 1'b1;
    end

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            ringo_timeout_cnt[LAYER_I] <= 'd0;
        else if(ringo_timeout_clr_sync || trim_start_reg || stopwatch_ringo_pedge[LAYER_I])
            ringo_timeout_cnt[LAYER_I] <= 'd0;
        else if(ringo_timeout_cnt_en[LAYER_I])begin
            if(ringo_timeout_cnt[LAYER_I]==ringo_timeout_time_sync)
                ringo_timeout_cnt[LAYER_I] <= ringo_timeout_cnt[LAYER_I];
            else
                ringo_timeout_cnt[LAYER_I] <= ringo_timeout_cnt[LAYER_I] + 1'b1;
        end
        else
            ringo_timeout_cnt[LAYER_I] <= 'd0;
    end

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            ringo_timeout_flag[LAYER_I] <= 1'b0;
        else if(ringo_timeout_clr_sync || trim_start_reg)
            ringo_timeout_flag[LAYER_I] <= 1'b0;
        else if(ringo_timeout_cnt[LAYER_I]==ringo_timeout_time_sync)
            ringo_timeout_flag[LAYER_I] <= 1'b1;
    end

    assign res_ringo_process_done[LAYER_I] = dram_layer_sel_sync[LAYER_I] ? (res_ringo_done[LAYER_I] || ringo_timeout_flag[LAYER_I]) : 1'b1;
    
    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            hw_ringo_clk_flag_en[LAYER_I] <= 1'b0;
        else if(fsm_cs==HW_OP_DLY3)
            hw_ringo_clk_flag_en[LAYER_I] <= 1'b0;
        else if(dram_layer_sel_sync[LAYER_I] && fsm_cs==HW_RINGO_CLK && stopwatch_ringo_flag[LAYER_I] && stopwatch_ringo_nedge[LAYER_I])
            hw_ringo_clk_flag_en[LAYER_I] <= 1'b1;
    end

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            stopwatch_ringo_flag[LAYER_I] <= 1'b0;
        else if((spine_resetn_active_sync && dram_layer_sel_sync[LAYER_I]) || (tm_redump_active_sync && dram_layer_sel_sync[LAYER_I]))
            stopwatch_ringo_flag[LAYER_I] <= 1'b0;
        else if(dram_layer_sel_sync[LAYER_I] && ((trim_op_flow_sync && res_or_ringo_sel_sync[LAYER_I] && ringo_clk_flag && ~stopwatch_ringo_measure_ready[LAYER_I]) || (~trim_op_flow_sync && fsm_cs==HW_RINGO_CLK && ~hw_ringo_clk_flag_en[LAYER_I])))begin
            if(stopwatch_ringo_pedge[LAYER_I])
                stopwatch_ringo_flag[LAYER_I] <= 1'b1;
            else if(stopwatch_ringo_nedge[LAYER_I])
                stopwatch_ringo_flag[LAYER_I] <= 1'b0;
        end
    end
    
    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            stopwatch_ringo_width_cnt[LAYER_I] <= 'd0;
        else if((spine_resetn_active_sync && dram_layer_sel_sync[LAYER_I]) || (tm_redump_active_sync && dram_layer_sel_sync[LAYER_I]))
            stopwatch_ringo_width_cnt[LAYER_I] <= 'd0;
        else if(stopwatch_ringo_flag[LAYER_I])
            stopwatch_ringo_width_cnt[LAYER_I] <= stopwatch_ringo_width_cnt[LAYER_I] + 1'b1;
        else
            stopwatch_ringo_width_cnt[LAYER_I] <= 'd0;
    end
    
    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            stopwatch_ringo_measure[LAYER_I*10+:10] <= 'd0;
        else if((spine_resetn_active_sync && dram_layer_sel_sync[LAYER_I]) || (tm_redump_active_sync && dram_layer_sel_sync[LAYER_I]) || trim_start_reg)
            stopwatch_ringo_measure[LAYER_I*10+:10] <= 'd0;
        else if(stopwatch_ringo_flag[LAYER_I] && stopwatch_ringo_nedge[LAYER_I])
            stopwatch_ringo_measure[LAYER_I*10+:10] <= stopwatch_ringo_width_cnt[LAYER_I] + 1'b1;
    end
    
    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            stopwatch_ringo_measure_ready[LAYER_I] <= 1'b0;
        else if((spine_resetn_active_sync && dram_layer_sel_sync[LAYER_I]) || (tm_redump_active_sync && dram_layer_sel_sync[LAYER_I]) || trim_start_reg)
            stopwatch_ringo_measure_ready[LAYER_I] <= 1'b0;
        else if(trim_op_flow_sync && ((~res_or_ringo_sel_sync[LAYER_I] && stopwatch_ringo_pedge[LAYER_I]) || (res_or_ringo_sel_sync[LAYER_I] && stopwatch_ringo_nedge[LAYER_I] && stopwatch_ringo_flag[LAYER_I])))
            stopwatch_ringo_measure_ready[LAYER_I] <= 1'b1;
    end

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            hw_ringo_period_record[LAYER_I] <= 80'd0;
        else if(trim_start_reg)
            hw_ringo_period_record[LAYER_I] <= 80'd0;
        else if(stopwatch_ringo_flag[LAYER_I] && stopwatch_ringo_nedge[LAYER_I])
            hw_ringo_period_record[LAYER_I][hw_ringo_mode_cnt*10+:10] <= stopwatch_ringo_width_cnt[LAYER_I] + 1'b1;
    end
end
endgenerate


always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        trim_interrupt_flag <= 1'b0;
    else if(trim_interrupt_clr_sync)
        trim_interrupt_flag <= 1'b0;
    else if(dumpready_timeout_flag!='d0 || ringo_timeout_flag!='d0)
        trim_interrupt_flag <= 1'b1;
end

assign trim_interrupt = ~trim_interrupt_mask_sync & trim_interrupt_flag;

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        trim_finish <= 1'b0;
    else if(~trim_op_flow_sync && trim_start_reg)
        trim_finish <= 1'b0;
    else if(fsm_cs==HW_DUMPRDY3 && dumpready_high==4'hF && hw_ringo_mode_cnt==3'd7)
        trim_finish <= 1'b1;
    else if(hw_op_ringo_mask_sync && fsm_cs==HW_DUMPRDY1 && dumpready_high==4'hF)
        trim_finish <= 1'b1;
end


assign hw_ringo_period_dram0 = hw_ringo_period_record[0];
assign hw_ringo_period_dram1 = hw_ringo_period_record[1];
assign hw_ringo_period_dram2 = hw_ringo_period_record[2];
assign hw_ringo_period_dram3 = hw_ringo_period_record[3];




dram_trim_pulse2pulse pulse_sync_u1(
        .clk1  (apb_clk                ),
        .rst1_n(apb_rst_n              ),
        .clk2  (clk                    ),
        .rst2_n(rst_n                  ),
        .in    (spine_resetn_active    ),
        .out   (spine_resetn_active_tmp)
    );

dram_trim_pulse2pulse pulse_sync_u2(
        .clk1  (apb_clk             ),
        .rst1_n(apb_rst_n           ),
        .clk2  (clk                 ),
        .rst2_n(rst_n               ),
        .in    (tm_redump_active    ),
        .out   (tm_redump_active_tmp)
    );

dram_trim_pulse2pulse pulse_sync_u3(
        .clk1  (apb_clk                    ),
        .rst1_n(apb_rst_n                  ),
        .clk2  (clk                        ),
        .rst2_n(rst_n                      ),
        .in    (stopwatch_period_active    ),
        .out   (stopwatch_period_active_tmp)
    );

dram_trim_pulse2pulse pulse_sync_u4(
        .clk1  (apb_clk                 ),
        .rst1_n(apb_rst_n               ),
        .clk2  (clk                     ),
        .rst2_n(rst_n                   ),
        .in    (trim_start_internal     ),
        .out   (trim_start_internal_sync)
    );


dram_trim_pulse2pulse pulse_sync_u5(
        .clk1  (apb_clk        ),
        .rst1_n(apb_rst_n      ),
        .clk2  (clk            ),
        .rst2_n(rst_n          ),
        .in    (init_start     ),
        .out   (init_start_sync)
    );

dram_trim_pulse2pulse pulse_sync_u6(
        .clk1  (apb_clk               ),
        .rst1_n(apb_rst_n             ),
        .clk2  (clk                   ),
        .rst2_n(rst_n                 ),
        .in    (ringo_timeout_clr     ),
        .out   (ringo_timeout_clr_sync)
    );

dram_trim_pulse2pulse pulse_sync_u7(
        .clk1  (apb_clk                   ),
        .rst1_n(apb_rst_n                 ),
        .clk2  (clk                       ),
        .rst2_n(rst_n                     ),
        .in    (dumpready_timeout_clr     ),
        .out   (dumpready_timeout_clr_sync)
    );

dram_trim_pulse2pulse pulse_sync_u8(
        .clk1  (apb_clk                ),
        .rst1_n(apb_rst_n              ),
        .clk2  (clk                    ),
        .rst2_n(rst_n                  ),
        .in    (trim_interrupt_clr     ),
        .out   (trim_interrupt_clr_sync)
    );


dram_trim_wl_sync2dff #(
     .WIDTH(DRAM_LAYER_NUM+9)
     )wl_sync2dff_u0(
     .clk           (clk                ),
     .rst_n         (rst_n              ),
     .din           ({trim_start_external,trim_op_flow,dump_ready,hw_op_ringo_mask,trim_interrupt_mask,stopwatch_ringo,debug_en}),
     .dout          ({trim_start_external_sync,trim_op_flow_sync,dump_ready_reg,hw_op_ringo_mask_sync,trim_interrupt_mask_sync,stopwatch_ringo_sync,trim_debug_en})
     );


assign dump_ready_out         = dump_ready_reg;
assign osc_tm_res_smp_value   = osc_tm_res_smp_reg;
assign stopwatch_ringo_ready  = stopwatch_ringo_measure_ready;
assign stopwatch_ringo_period = stopwatch_ringo_measure;






//---------------debug logic---------------//

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sw_spine_reset_n_active_cnt_dbg <= 'd0;
    else if(trim_debug_en && spine_resetn_active_sync)
        sw_spine_reset_n_active_cnt_dbg <= sw_spine_reset_n_active_cnt_dbg + 1'b1;
    else
        sw_spine_reset_n_active_cnt_dbg <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sw_tm_redump_active_cnt_dbg <= 'd0;
    else if(trim_debug_en && tm_redump_active_sync)
        sw_tm_redump_active_cnt_dbg <= sw_tm_redump_active_cnt_dbg + 1'b1;
    else
        sw_tm_redump_active_cnt_dbg <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sw_stopwatch_period_active_cnt_dbg <= 'd0;
    else if(trim_debug_en && stopwatch_period_active_sync)
        sw_stopwatch_period_active_cnt_dbg <= sw_stopwatch_period_active_cnt_dbg + 1'b1;
    else
        sw_stopwatch_period_active_cnt_dbg <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        trim_start_cnt_dbg <= 'd0;
    else if(trim_debug_en && (init_start_sync || trim_start_reg))
        trim_start_cnt_dbg <= trim_start_cnt_dbg + 1'b1;
    else
        trim_start_cnt_dbg <= 'd0;
end

assign fsm_cs_dbg = fsm_cs;

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        fsm_cs_flag_dbg <= 'd0;
    else if(trim_debug_en)begin
        for(II_FSM=0;II_FSM<33;II_FSM=II_FSM+1)
            if(fsm_cs==II_FSM)
                fsm_cs_flag_dbg[II_FSM] <= 1'b1;
    end
    else
        fsm_cs_flag_dbg <= 'd0;
end

assign spine_reset_n_dbg = spine_reset_n;

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        tm_redump_dly <= 'd0;
    else
        tm_redump_dly <= tm_redump;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        tm_redump_edge_dbg <= 'd0;
    else if(trim_debug_en)begin
        for(II=0;II<DRAM_LAYER_NUM;II=II+1)
            if({tm_redump[II],tm_redump_dly[II]}==2'b10)
                tm_redump_edge_dbg[II] <= 1'b1;
    end
    else
        tm_redump_edge_dbg <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        stopwatch_period_edge_dbg <= 'd0;
    else if(trim_debug_en)begin
        for(II=0;II<DRAM_LAYER_NUM;II=II+1)
            if(stopwatch_period_nedge[II])
                stopwatch_period_edge_dbg[II] <= 1'b1;
    end
    else
        stopwatch_period_edge_dbg <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        stopwatch_ringo_edge_dbg <= 'd0;
    else if(trim_debug_en)begin
        for(II=0;II<DRAM_LAYER_NUM;II=II+1)
            if(stopwatch_ringo_pedge[II])
                stopwatch_ringo_edge_dbg[II] <= 1'b1;
    end
    else
        stopwatch_ringo_edge_dbg <= 'd0;
end


assign trim_monitor = {spine_reset_n[3:0]          ,
                       tm_redump[3:0]              ,
                       stopwatch_period[3:0]       ,
                       dump_ready[3:0]             ,
                       stopwatch_ringo[3:0]        ,
                       osc_tm_res[7:0]             ,
                       tsv_tm[247:239]             ,
                       tsv_tm[260:259]             ,
                       trim_start_reg              ,
                       fsm_cs[4:0]                 ,
                       init_start_sync             ,
                       trim_interrupt              ,
                       trim_finish                 ,
                       ringo_timeout_flag[3:0]     ,
                       dumpready_timeout_flag[3:0] ,
                       spine_resetn_active_sync    ,
                       tm_redump_active_sync       ,
                       stopwatch_period_active_sync,
                       init_done_flag              };




always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        phy_debug_spine_reset_n_shift_d0 <= 'd0;
    else if(trim_debug_en)
        phy_debug_spine_reset_n_shift_d0 <= {phy_debug_spine_reset_n_shift_d0[2:0],phy_debug_spine_reset_n[0]};
    else
        phy_debug_spine_reset_n_shift_d0 <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        phy_debug_spine_reset_n_shift_d1 <= 'd0;
    else if(trim_debug_en)
        phy_debug_spine_reset_n_shift_d1 <= {phy_debug_spine_reset_n_shift_d1[2:0],phy_debug_spine_reset_n[1]};
    else
        phy_debug_spine_reset_n_shift_d1 <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        phy_debug_spine_reset_n_edge_dbg <= 'd0;
    else if(trim_debug_en)begin
        if(phy_debug_spine_reset_n_shift_d0==4'b0111)
            phy_debug_spine_reset_n_edge_dbg[0] <= 1'b1;
        if(phy_debug_spine_reset_n_shift_d1==4'b0111)
            phy_debug_spine_reset_n_edge_dbg[1] <= 1'b1;
    end
    else
        phy_debug_spine_reset_n_edge_dbg <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        phy_debug_tm_redump_shift_d0 <= 'd0;
    else if(trim_debug_en)
        phy_debug_tm_redump_shift_d0 <= {phy_debug_tm_redump_shift_d0[2:0],phy_debug_tm_redump[0]};
    else
        phy_debug_tm_redump_shift_d0 <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        phy_debug_tm_redump_shift_d1 <= 'd0;
    else if(trim_debug_en)
        phy_debug_tm_redump_shift_d1 <= {phy_debug_tm_redump_shift_d1[2:0],phy_debug_tm_redump[1]};
    else
        phy_debug_tm_redump_shift_d1 <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        phy_debug_tm_redump_edge_dbg <= 'd0;
    else if(trim_debug_en)begin
        if(phy_debug_tm_redump_shift_d0==4'b0111)
            phy_debug_tm_redump_edge_dbg[0] <= 1'b1;
        if(phy_debug_spine_reset_n_shift_d1==4'b0111)
            phy_debug_tm_redump_edge_dbg[1] <= 1'b1;
    end
    else
        phy_debug_tm_redump_edge_dbg <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        phy_debug_stopwatch_period_shift_d0 <= 'd0;
    else if(trim_debug_en)
        phy_debug_stopwatch_period_shift_d0 <= {phy_debug_stopwatch_period_shift_d0[2:0],phy_debug_stopwatch_period[0]};
    else
        phy_debug_stopwatch_period_shift_d0 <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        phy_debug_stopwatch_period_shift_d1 <= 'd0;
    else if(trim_debug_en)
        phy_debug_stopwatch_period_shift_d1 <= {phy_debug_stopwatch_period_shift_d1[2:0],phy_debug_stopwatch_period[1]};
    else
        phy_debug_stopwatch_period_shift_d1 <= 'd0;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        phy_debug_stopwatch_period_edge_dbg <= 'd0;
    else if(trim_debug_en)begin
        if(phy_debug_stopwatch_period_shift_d0==4'b0111)
            phy_debug_stopwatch_period_edge_dbg[0] <= 1'b1;
        if(phy_debug_stopwatch_period_shift_d1==4'b0111)
            phy_debug_stopwatch_period_edge_dbg[1] <= 1'b1;
    end
    else
        phy_debug_stopwatch_period_edge_dbg <= 'd0;
end






endmodule
