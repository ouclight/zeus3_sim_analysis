

module dram_trim_top #(
        parameter DRAM_LAYER_NUM = 4
        )(
        input                            clk                       ,
        input                            rst_n                     ,
        input    [31:0]                  trim_ctrl_id              ,
        input                            trim_start                ,
        output                           trim_finish               ,
        input    [7:0]                   trim_res                  ,
        output                           trim_interrupt            ,
        //--------------APB BUS--------------//
        input                            apb_clk                   ,
        input                            apb_rst_n                 ,
        input                            apb_sel                   ,
        input                            apb_en                    ,
        input                            apb_write                 ,
        input    [7:0]                   apb_addr                  ,
        input    [31:0]                  apb_wdata                 ,
        output   [31:0]                  apb_rdata                 ,
        //--------------DRAM SPINE--------------//
        output   [DRAM_LAYER_NUM-1:0]    spine_reset_n             ,
        output   [DRAM_LAYER_NUM-1:0]    tm_redump                 ,
        output   [DRAM_LAYER_NUM-1:0]    stopwatch_period          ,
        output   [428:1]                 tsv_tm                    ,
        input    [DRAM_LAYER_NUM-1:0]    dump_ready                ,
        input    [DRAM_LAYER_NUM-1:0]    stopwatch_ringo           ,
        input    [DRAM_LAYER_NUM*2-1:0]  osc_tm_res                ,
        //--------------monitor--------------//
        output   [59:0]                  trim_monitor              
    );






wire            spine_resetn_active_ready_i         ;
wire            tm_redump_active_ready_i            ;
wire            stopwatch_period_active_ready_i     ;
wire            init_done_flag_i                    ;
wire   [3:0]    stopwatch_ringo_period_ready_i      ;
wire   [3:0]    dump_ready_i                        ;
wire   [3:0]    dumpready_timeout_ready_i           ;
wire   [7:0]    osc_tm_res_smp_value_i              ;
wire   [3:0]    osc_tm_res_smp_ready_i              ;
wire   [9:0]    stopwatch_ringo_period0_i           ;
wire   [9:0]    stopwatch_ringo_period1_i           ;
wire   [9:0]    stopwatch_ringo_period2_i           ;
wire   [9:0]    stopwatch_ringo_period3_i           ;
wire   [3:0]    dumpready_timeout_flag_i            ;
wire   [3:0]    ringo_timeout_flag_i                ;
wire            trim_interrupt_flag_i               ;
wire   [9:0]    hw_ringo_dram0_period0_i            ;
wire   [9:0]    hw_ringo_dram0_period1_i            ;
wire   [9:0]    hw_ringo_dram0_period2_i            ;
wire   [9:0]    hw_ringo_dram0_period3_i            ;
wire   [9:0]    hw_ringo_dram0_period4_i            ;
wire   [9:0]    hw_ringo_dram0_period5_i            ;
wire   [9:0]    hw_ringo_dram0_period6_i            ;
wire   [9:0]    hw_ringo_dram0_period7_i            ;
wire   [9:0]    hw_ringo_dram1_period0_i            ;
wire   [9:0]    hw_ringo_dram1_period1_i            ;
wire   [9:0]    hw_ringo_dram1_period2_i            ;
wire   [9:0]    hw_ringo_dram1_period3_i            ;
wire   [9:0]    hw_ringo_dram1_period4_i            ;
wire   [9:0]    hw_ringo_dram1_period5_i            ;
wire   [9:0]    hw_ringo_dram1_period6_i            ;
wire   [9:0]    hw_ringo_dram1_period7_i            ;
wire   [9:0]    hw_ringo_dram2_period0_i            ;
wire   [9:0]    hw_ringo_dram2_period1_i            ;
wire   [9:0]    hw_ringo_dram2_period2_i            ;
wire   [9:0]    hw_ringo_dram2_period3_i            ;
wire   [9:0]    hw_ringo_dram2_period4_i            ;
wire   [9:0]    hw_ringo_dram2_period5_i            ;
wire   [9:0]    hw_ringo_dram2_period6_i            ;
wire   [9:0]    hw_ringo_dram2_period7_i            ;
wire   [9:0]    hw_ringo_dram3_period0_i            ;
wire   [9:0]    hw_ringo_dram3_period1_i            ;
wire   [9:0]    hw_ringo_dram3_period2_i            ;
wire   [9:0]    hw_ringo_dram3_period3_i            ;
wire   [9:0]    hw_ringo_dram3_period4_i            ;
wire   [9:0]    hw_ringo_dram3_period5_i            ;
wire   [9:0]    hw_ringo_dram3_period6_i            ;
wire   [9:0]    hw_ringo_dram3_period7_i            ;
wire            spine_resetn_active_o               ;
wire            tm_redump_active_o                  ;
wire            stopwatch_period_active_o           ;
wire            trim_start_o                        ;
wire            init_start_o                        ;
wire            dumpready_timeout_clr_o             ;
wire            ringo_timeout_clr_o                 ;
wire            trim_interrupt_clr_o                ;
wire            trim_op_flow_o                      ;
wire            hw_op_ringo_mask_o                  ;
wire            hw_op_tsv_load_sel_o                ;
wire   [3:0]    dram_layer_sel_o                    ;
wire            res_or_ringo_sel_o                  ;
wire   [27:0]   init_spine_reset_time_o             ;
wire   [9:0]    spine_resetn_width_o                ;
wire   [9:0]    tm_redump_width_o                   ;
wire   [15:0]   stopwatch_period_width_res_o        ;
wire   [15:0]   stopwatch_period_width_ringo_o      ;
wire   [31:0]   redump_tsv_tm_other_value0_o        ;
wire   [31:0]   redump_tsv_tm_other_value1_o        ;
wire   [31:0]   redump_tsv_tm_other_value2_o        ;
wire   [31:0]   redump_tsv_tm_other_value3_o        ;
wire   [31:0]   redump_tsv_tm_other_value4_o        ;
wire   [31:0]   redump_tsv_tm_other_value5_o        ;
wire   [31:0]   redump_tsv_tm_other_value6_o        ;
wire   [31:0]   redump_tsv_tm_other_value7_o        ;
wire   [31:0]   redump_tsv_tm_other_value8_o        ;
wire   [31:0]   redump_tsv_tm_other_value9_o        ;
wire   [31:0]   redump_tsv_tm_other_value10_o       ;
wire   [31:0]   redump_tsv_tm_other_value11_o       ;
wire   [31:0]   redump_tsv_tm_other_value12_o       ;
wire   [11:0]   redump_tsv_tm_other_value13_o       ;
wire            dumpready_timeout_en_o              ;
wire   [23:0]   dumpready_timeout_time_o            ;
wire            ringo_timeout_en_o                  ;
wire   [23:0]   ringo_timeout_time_o                ;
wire   [1:0]    res_value_sel_o                     ;
wire   [7:0]    res_cfg_value_o                     ;
wire            trim_interrupt_mask_o               ;
wire   [3:0]    sw_spine_reset_n_active_cnt_dbg_i   ;
wire   [3:0]    sw_tm_redump_active_cnt_dbg_i       ;
wire   [3:0]    sw_stopwatch_period_active_cnt_dbg_i;
wire   [3:0]    trim_start_cnt_dbg_i                ;
wire   [3:0]    spine_reset_n_dbg_i                 ;
wire   [3:0]    tm_redump_edge_dbg_i                ;
wire   [3:0]    stopwatch_period_edge_dbg_i         ;
wire   [3:0]    stopwatch_ringo_edge_dbg_i          ;
wire   [32:0]   fsm_cs_flag_dbg_i                   ;
wire   [5:0]    fsm_cs_dbg_i                        ;
wire            debug_en_o                          ;
wire   [13:0]   hw_ringo_period_delay_o             ;
wire   [9:0]    hw_period2ringo_dly_o               ;
wire   [8:0]    res_mode_value_o                    ;
wire   [8:0]    ringo_mode_value_reg0_o             ;
wire   [8:0]    ringo_mode_value_reg1_o             ;
wire   [8:0]    ringo_mode_value_reg2_o             ;
wire   [8:0]    ringo_mode_value_reg3_o             ;
wire   [8:0]    ringo_mode_value_reg4_o             ;
wire   [8:0]    ringo_mode_value_reg5_o             ;
wire   [8:0]    ringo_mode_value_reg6_o             ;
wire   [8:0]    ringo_mode_value_reg7_o             ;
wire   [1:0]    phy_debug_spine_reset_n_edge_dbg    ;
wire   [1:0]    phy_debug_tm_redump_edge_dbg        ;
wire   [1:0]    phy_debug_stopwatch_period_edge_dbg ;



apb2reg_dram_trim_cfg_if apb2reg_dram_trim_cfg_if_u(
        .pclk                                 (apb_clk                             ),
        .presetn                              (apb_rst_n                           ),
        .psel                                 (apb_sel                             ),
        .penable                              (apb_en                              ),
        .paddr                                (apb_addr                            ),
        .pwrite                               (apb_write                           ),
        .pwdata                               (apb_wdata                           ),
        .prdata                               (apb_rdata                           ),
        .trim_ctrl_id_i                       (trim_ctrl_id                        ),
        .spine_resetn_active_ready_i          (spine_resetn_active_ready_i         ),
        .tm_redump_active_ready_i             (tm_redump_active_ready_i            ),
        .stopwatch_period_active_ready_i      (stopwatch_period_active_ready_i     ),
        .init_done_flag_i                     (init_done_flag_i                    ),
        .stopwatch_ringo_period_ready_i       (stopwatch_ringo_period_ready_i      ),
        .trim_finish_i                        (trim_finish                         ),
        .dump_ready_i                         (dump_ready_i                        ),
        .dumpready_timeout_ready_i            (dumpready_timeout_ready_i           ),
        .osc_tm_res_smp_value_i               (osc_tm_res_smp_value_i              ),
        .osc_tm_res_smp_ready_i               (osc_tm_res_smp_ready_i              ),
        .stopwatch_ringo_period0_i            (stopwatch_ringo_period0_i           ),
        .stopwatch_ringo_period1_i            (stopwatch_ringo_period1_i           ),
        .stopwatch_ringo_period2_i            (stopwatch_ringo_period2_i           ),
        .stopwatch_ringo_period3_i            (stopwatch_ringo_period3_i           ),
        .dumpready_timeout_flag_i             (dumpready_timeout_flag_i            ),
        .ringo_timeout_flag_i                 (ringo_timeout_flag_i                ),
        .trim_interrupt_flag_i                (trim_interrupt_flag_i               ),
        .hw_ringo_dram0_period0_i             (hw_ringo_dram0_period0_i            ),
        .hw_ringo_dram0_period1_i             (hw_ringo_dram0_period1_i            ),
        .hw_ringo_dram0_period2_i             (hw_ringo_dram0_period2_i            ),
        .hw_ringo_dram0_period3_i             (hw_ringo_dram0_period3_i            ),
        .hw_ringo_dram0_period4_i             (hw_ringo_dram0_period4_i            ),
        .hw_ringo_dram0_period5_i             (hw_ringo_dram0_period5_i            ),
        .hw_ringo_dram0_period6_i             (hw_ringo_dram0_period6_i            ),
        .hw_ringo_dram0_period7_i             (hw_ringo_dram0_period7_i            ),
        .hw_ringo_dram1_period0_i             (hw_ringo_dram1_period0_i            ),
        .hw_ringo_dram1_period1_i             (hw_ringo_dram1_period1_i            ),
        .hw_ringo_dram1_period2_i             (hw_ringo_dram1_period2_i            ),
        .hw_ringo_dram1_period3_i             (hw_ringo_dram1_period3_i            ),
        .hw_ringo_dram1_period4_i             (hw_ringo_dram1_period4_i            ),
        .hw_ringo_dram1_period5_i             (hw_ringo_dram1_period5_i            ),
        .hw_ringo_dram1_period6_i             (hw_ringo_dram1_period6_i            ),
        .hw_ringo_dram1_period7_i             (hw_ringo_dram1_period7_i            ),
        .hw_ringo_dram2_period0_i             (hw_ringo_dram2_period0_i            ),
        .hw_ringo_dram2_period1_i             (hw_ringo_dram2_period1_i            ),
        .hw_ringo_dram2_period2_i             (hw_ringo_dram2_period2_i            ),
        .hw_ringo_dram2_period3_i             (hw_ringo_dram2_period3_i            ),
        .hw_ringo_dram2_period4_i             (hw_ringo_dram2_period4_i            ),
        .hw_ringo_dram2_period5_i             (hw_ringo_dram2_period5_i            ),
        .hw_ringo_dram2_period6_i             (hw_ringo_dram2_period6_i            ),
        .hw_ringo_dram2_period7_i             (hw_ringo_dram2_period7_i            ),
        .hw_ringo_dram3_period0_i             (hw_ringo_dram3_period0_i            ),
        .hw_ringo_dram3_period1_i             (hw_ringo_dram3_period1_i            ),
        .hw_ringo_dram3_period2_i             (hw_ringo_dram3_period2_i            ),
        .hw_ringo_dram3_period3_i             (hw_ringo_dram3_period3_i            ),
        .hw_ringo_dram3_period4_i             (hw_ringo_dram3_period4_i            ),
        .hw_ringo_dram3_period5_i             (hw_ringo_dram3_period5_i            ),
        .hw_ringo_dram3_period6_i             (hw_ringo_dram3_period6_i            ),
        .hw_ringo_dram3_period7_i             (hw_ringo_dram3_period7_i            ),
        .spine_resetn_active_o                (spine_resetn_active_o               ),
        .tm_redump_active_o                   (tm_redump_active_o                  ),
        .stopwatch_period_active_o            (stopwatch_period_active_o           ),
        .trim_start_o                         (trim_start_o                        ),
        .init_start_o                         (init_start_o                        ),
        .dumpready_timeout_clr_o              (dumpready_timeout_clr_o             ),
        .ringo_timeout_clr_o                  (ringo_timeout_clr_o                 ),
        .trim_interrupt_clr_o                 (trim_interrupt_clr_o                ),
        .trim_op_flow_o                       (trim_op_flow_o                      ),
        .hw_op_ringo_mask_o                   (hw_op_ringo_mask_o                  ),
        .hw_op_tsv_load_sel_o                 (hw_op_tsv_load_sel_o                ),
        .dram_layer_sel_o                     (dram_layer_sel_o                    ),
        .res_or_ringo_sel_o                   (res_or_ringo_sel_o                  ),
        .debug_en_o                           (debug_en_o                          ),
        .init_spine_reset_time_o              (init_spine_reset_time_o             ),
        .spine_resetn_width_o                 (spine_resetn_width_o                ),
        .tm_redump_width_o                    (tm_redump_width_o                   ),
        .stopwatch_period_width_res_o         (stopwatch_period_width_res_o        ),
        .stopwatch_period_width_ringo_o       (stopwatch_period_width_ringo_o      ),
        .redump_tsv_tm_other_value0_o         (redump_tsv_tm_other_value0_o        ),
        .redump_tsv_tm_other_value1_o         (redump_tsv_tm_other_value1_o        ),
        .redump_tsv_tm_other_value2_o         (redump_tsv_tm_other_value2_o        ),
        .redump_tsv_tm_other_value3_o         (redump_tsv_tm_other_value3_o        ),
        .redump_tsv_tm_other_value4_o         (redump_tsv_tm_other_value4_o        ),
        .redump_tsv_tm_other_value5_o         (redump_tsv_tm_other_value5_o        ),
        .redump_tsv_tm_other_value6_o         (redump_tsv_tm_other_value6_o        ),
        .redump_tsv_tm_other_value7_o         (redump_tsv_tm_other_value7_o        ),
        .redump_tsv_tm_other_value8_o         (redump_tsv_tm_other_value8_o        ),
        .redump_tsv_tm_other_value9_o         (redump_tsv_tm_other_value9_o        ),
        .redump_tsv_tm_other_value10_o        (redump_tsv_tm_other_value10_o       ),
        .redump_tsv_tm_other_value11_o        (redump_tsv_tm_other_value11_o       ),
        .redump_tsv_tm_other_value12_o        (redump_tsv_tm_other_value12_o       ),
        .redump_tsv_tm_other_value13_o        (redump_tsv_tm_other_value13_o       ),
        .dumpready_timeout_en_o               (dumpready_timeout_en_o              ),
        .dumpready_timeout_time_o             (dumpready_timeout_time_o            ),
        .ringo_timeout_en_o                   (ringo_timeout_en_o                  ),
        .ringo_timeout_time_o                 (ringo_timeout_time_o                ),
        .res_value_sel_o                      (res_value_sel_o                     ),
        .res_cfg_value_o                      (res_cfg_value_o                     ),
        .trim_interrupt_mask_o                (trim_interrupt_mask_o               ),
        .sw_spine_reset_n_active_cnt_dbg_i    (sw_spine_reset_n_active_cnt_dbg_i   ),
        .sw_tm_redump_active_cnt_dbg_i        (sw_tm_redump_active_cnt_dbg_i       ),
        .sw_stopwatch_period_active_cnt_dbg_i (sw_stopwatch_period_active_cnt_dbg_i),
        .trim_start_cnt_dbg_i                 (trim_start_cnt_dbg_i                ),
        .spine_reset_n_dbg_i                  (spine_reset_n_dbg_i                 ),
        .tm_redump_edge_dbg_i                 (tm_redump_edge_dbg_i                ),
        .stopwatch_period_edge_dbg_i          (stopwatch_period_edge_dbg_i         ),
        .stopwatch_ringo_edge_dbg_i           (stopwatch_ringo_edge_dbg_i          ),
        .fsm_cs_flag_dbg0_i                   (fsm_cs_flag_dbg_i[31:0]             ),
        .fsm_cs_flag_dbg1_i                   (fsm_cs_flag_dbg_i[32]               ),
        .fsm_cs_dbg_i                         (fsm_cs_dbg_i                        ),
        .hw_ringo_period_delay_o              (hw_ringo_period_delay_o             ),
        .hw_period2ringo_dly_o                (hw_period2ringo_dly_o               ),
        .res_mode_value_o                     (res_mode_value_o                    ),
        .ringo_mode_value_reg0_o              (ringo_mode_value_reg0_o             ),
        .ringo_mode_value_reg1_o              (ringo_mode_value_reg1_o             ),
        .ringo_mode_value_reg2_o              (ringo_mode_value_reg2_o             ),
        .ringo_mode_value_reg3_o              (ringo_mode_value_reg3_o             ),
        .ringo_mode_value_reg4_o              (ringo_mode_value_reg4_o             ),
        .ringo_mode_value_reg5_o              (ringo_mode_value_reg5_o             ),
        .ringo_mode_value_reg6_o              (ringo_mode_value_reg6_o             ),
        .ringo_mode_value_reg7_o              (ringo_mode_value_reg7_o             ),
        .phy_debug_tsv_tm_i                   (8'd0                                ),
        .phy_debug_spine_reset_n_edge_dbg_i   (phy_debug_spine_reset_n_edge_dbg    ),
        .phy_debug_tm_redump_edge_dbg_i       (phy_debug_tm_redump_edge_dbg        ),
        .phy_debug_stopwatch_period_edge_dbg_i(phy_debug_stopwatch_period_edge_dbg ),
        .phy_debug_dump_ready_i               (2'd0                                ),
        .phy_debug_stopwatch_ringo_i          (2'd0                                ),
        .phy_debug_osc_tm_res_i               (4'd0                                )
    );






dram_trim_ctrl #(
        .DRAM_LAYER_NUM(DRAM_LAYER_NUM)
        )dram_trim_ctrl_u(
        .clk                          (clk                            ),
        .rst_n                        (rst_n                          ),
        .apb_clk                      (apb_clk                        ),
        .apb_rst_n                    (apb_rst_n                      ),
        .trim_start_internal          (trim_start_o                   ),
        .trim_start_external          (trim_start                     ),
        .debug_en                     (debug_en_o                     ),
        .trim_op_flow                 (trim_op_flow_o                 ),
        .init_start                   (init_start_o                   ),
        .init_done_flag               (init_done_flag_i               ),
        .trim_res_ext                 (trim_res                       ),
        .trim_res_apb                 (res_cfg_value_o                ),
        .res_value_sel                (res_value_sel_o                ),
        .dram_layer_sel               (dram_layer_sel_o               ),
        .ringo_timeout_time           (ringo_timeout_time_o           ),
        .ringo_timeout_en             (ringo_timeout_en_o             ),
        .ringo_timeout_clr            (ringo_timeout_clr_o            ),
        .ringo_timeout_flag           (ringo_timeout_flag_i           ),
        .dumpready_timeout_en         (dumpready_timeout_en_o         ),
        .dumpready_timeout_clr        (dumpready_timeout_clr_o        ),
        .dumpready_timeout_flag       (dumpready_timeout_flag_i       ),
        .dumpready_timeout_ready      (dumpready_timeout_ready_i      ),
        .dumpready_timeout_time       (dumpready_timeout_time_o       ),
        .hw_op_tsv_load_sel           (hw_op_tsv_load_sel_o           ),
        .hw_op_ringo_mask             (hw_op_ringo_mask_o             ),
        .trim_interrupt_clr           (trim_interrupt_clr_o           ),
        .trim_interrupt_mask          (trim_interrupt_mask_o          ),
        .trim_interrupt_flag          (trim_interrupt_flag_i          ),
        .trim_interrupt               (trim_interrupt                 ),
        .trim_finish                  (trim_finish                    ),
        .osc_tm_res_smp_value         (osc_tm_res_smp_value_i         ),
        .osc_tm_res_smp_ready         (osc_tm_res_smp_ready_i         ),
        .stopwatch_ringo_period       ({stopwatch_ringo_period3_i,stopwatch_ringo_period2_i,stopwatch_ringo_period1_i,stopwatch_ringo_period0_i}),
        .stopwatch_ringo_ready        (stopwatch_ringo_period_ready_i ),
        .spine_resetn_active          (spine_resetn_active_o          ),
        .spine_resetn_active_ready    (spine_resetn_active_ready_i    ),
        .tm_redump_active             (tm_redump_active_o             ),
        .tm_redump_active_ready       (tm_redump_active_ready_i       ),
        .stopwatch_period_active      (stopwatch_period_active_o      ),
        .stopwatch_period_active_ready(stopwatch_period_active_ready_i),
        .dump_ready_out               (dump_ready_i                   ),
        .init_spine_reset_time        (init_spine_reset_time_o        ),
        .spine_resetn_width           (spine_resetn_width_o           ),
        .tm_redump_width              (tm_redump_width_o              ),
        .stopwatch_period_width_res   (stopwatch_period_width_res_o   ),
        .stopwatch_period_width_ringo (stopwatch_period_width_ringo_o ),
        .redump_tsv_tm_other_value0   (redump_tsv_tm_other_value0_o   ),
        .redump_tsv_tm_other_value1   (redump_tsv_tm_other_value1_o   ),
        .redump_tsv_tm_other_value2   (redump_tsv_tm_other_value2_o   ),
        .redump_tsv_tm_other_value3   (redump_tsv_tm_other_value3_o   ),
        .redump_tsv_tm_other_value4   (redump_tsv_tm_other_value4_o   ),
        .redump_tsv_tm_other_value5   (redump_tsv_tm_other_value5_o   ),
        .redump_tsv_tm_other_value6   (redump_tsv_tm_other_value6_o   ),
        .redump_tsv_tm_other_value7   (redump_tsv_tm_other_value7_o   ),
        .redump_tsv_tm_other_value8   (redump_tsv_tm_other_value8_o   ),
        .redump_tsv_tm_other_value9   (redump_tsv_tm_other_value9_o   ),
        .redump_tsv_tm_other_value10  (redump_tsv_tm_other_value10_o  ),
        .redump_tsv_tm_other_value11  (redump_tsv_tm_other_value11_o  ),
        .redump_tsv_tm_other_value12  (redump_tsv_tm_other_value12_o  ),
        .redump_tsv_tm_other_value13  (redump_tsv_tm_other_value13_o  ),
        .res_or_ringo_sel             (res_or_ringo_sel_o             ),
        .hw_ringo_period_dram0        ({hw_ringo_dram0_period7_i,hw_ringo_dram0_period6_i,hw_ringo_dram0_period5_i,hw_ringo_dram0_period4_i,
                                        hw_ringo_dram0_period3_i,hw_ringo_dram0_period2_i,hw_ringo_dram0_period1_i,hw_ringo_dram0_period0_i}),
        .hw_ringo_period_dram1        ({hw_ringo_dram1_period7_i,hw_ringo_dram1_period6_i,hw_ringo_dram1_period5_i,hw_ringo_dram1_period4_i,
                                        hw_ringo_dram1_period3_i,hw_ringo_dram1_period2_i,hw_ringo_dram1_period1_i,hw_ringo_dram1_period0_i}),
        .hw_ringo_period_dram2        ({hw_ringo_dram2_period7_i,hw_ringo_dram2_period6_i,hw_ringo_dram2_period5_i,hw_ringo_dram2_period4_i,
                                        hw_ringo_dram2_period3_i,hw_ringo_dram2_period2_i,hw_ringo_dram2_period1_i,hw_ringo_dram2_period0_i}),
        .hw_ringo_period_dram3        ({hw_ringo_dram3_period7_i,hw_ringo_dram3_period6_i,hw_ringo_dram3_period5_i,hw_ringo_dram3_period4_i,
                                        hw_ringo_dram3_period3_i,hw_ringo_dram3_period2_i,hw_ringo_dram3_period1_i,hw_ringo_dram3_period0_i}),
        .spine_reset_n                      (spine_reset_n                       ),
        .tm_redump                          (tm_redump                           ),
        .stopwatch_period                   (stopwatch_period                    ),
        .tsv_tm                             (tsv_tm                              ),
        .dump_ready                         (dump_ready                          ),
        .stopwatch_ringo                    (stopwatch_ringo                     ),
        .osc_tm_res                         (osc_tm_res                          ),
        .sw_spine_reset_n_active_cnt_dbg    (sw_spine_reset_n_active_cnt_dbg_i   ),
        .sw_tm_redump_active_cnt_dbg        (sw_tm_redump_active_cnt_dbg_i       ),
        .sw_stopwatch_period_active_cnt_dbg (sw_stopwatch_period_active_cnt_dbg_i),
        .trim_start_cnt_dbg                 (trim_start_cnt_dbg_i                ),
        .spine_reset_n_dbg                  (spine_reset_n_dbg_i                 ),
        .tm_redump_edge_dbg                 (tm_redump_edge_dbg_i                ),
        .stopwatch_period_edge_dbg          (stopwatch_period_edge_dbg_i         ),
        .stopwatch_ringo_edge_dbg           (stopwatch_ringo_edge_dbg_i          ),
        .fsm_cs_flag_dbg                    (fsm_cs_flag_dbg_i                   ),
        .fsm_cs_dbg                         (fsm_cs_dbg_i                        ),
        .trim_monitor                       (trim_monitor                        ),
        .hw_ringo_period_delay              (hw_ringo_period_delay_o             ),
        .hw_period2ringo_dly                (hw_period2ringo_dly_o               ),
        .res_mode_value                     (res_mode_value_o                    ),
        .ringo_mode_value_reg0              (ringo_mode_value_reg0_o             ),
        .ringo_mode_value_reg1              (ringo_mode_value_reg1_o             ),
        .ringo_mode_value_reg2              (ringo_mode_value_reg2_o             ),
        .ringo_mode_value_reg3              (ringo_mode_value_reg3_o             ),
        .ringo_mode_value_reg4              (ringo_mode_value_reg4_o             ),
        .ringo_mode_value_reg5              (ringo_mode_value_reg5_o             ),
        .ringo_mode_value_reg6              (ringo_mode_value_reg6_o             ),
        .ringo_mode_value_reg7              (ringo_mode_value_reg7_o             ),
        .phy_debug_spine_reset_n            (2'd0                                ),
        .phy_debug_tm_redump                (2'd0                                ),
        .phy_debug_stopwatch_period         (2'd0                                ),
        .phy_debug_spine_reset_n_edge_dbg   (phy_debug_spine_reset_n_edge_dbg    ), 
        .phy_debug_tm_redump_edge_dbg       (phy_debug_tm_redump_edge_dbg        ),
        .phy_debug_stopwatch_period_edge_dbg(phy_debug_stopwatch_period_edge_dbg )
    );






endmodule
