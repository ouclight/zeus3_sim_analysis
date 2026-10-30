module CUBE_HC01_TOP #(
    parameter   ROW_BITS = 13,
    parameter   COL_BITS = 8,
    parameter   DATA_BITS = 272,
    `ifdef DRAM_6
    parameter   DRAM_LAYER_NUM = 6
    `else
    parameter   DRAM_LAYER_NUM = 4
    `endif
)(
    input                     bnksel_n_i_bk0  ,
    input                     bnksel_n_i_bk1  ,
    input                     bnksel_n_i_bk2  ,
    input                     bnksel_n_i_bk3  ,
    input   [ROW_BITS-1:0]    g_radd_i_BK     ,
    input   [COL_BITS-1:0]    g_cadd_i_BK     ,
    input                     g_cas_rd_i_BK0  ,
    input                     g_cas_rd_i_BK1  ,
    input                     g_cas_rd_i_BK2  ,
    input                     g_cas_rd_i_BK3  ,
    input                     g_cas_wr_i_BK0  ,
    input                     g_cas_wr_i_BK1  ,
    input                     g_cas_wr_i_BK2  ,
    input                     g_cas_wr_i_BK3  ,
    output                    g_rdrdy_n_o_bk0  ,
    output                    g_rdrdy_n_o_bk1  ,
    output                    g_rdrdy_n_o_bk2  ,
    output                    g_rdrdy_n_o_bk3  ,
    inout   [DATA_BITS-1:0]   g_rwdl_io_BK    ,
    input                     reset_n_BK      ,
    input [1*DRAM_LAYER_NUM-1:0]   SPINE_RESET_N     , 
    input [428:1]                   TSV_TM            , 
    output                          VMON              , 
    output [1*DRAM_LAYER_NUM-1:0]  DUMP_READY        , 
    output [1*DRAM_LAYER_NUM-1:0]  STOPWATCH_RINGO   , 
    output [2*DRAM_LAYER_NUM-1:0]  OSC_TM_RES        , 
    input  [1*DRAM_LAYER_NUM-1:0]  STOPWATCH_PERIOD  , 
    input  [1*DRAM_LAYER_NUM-1:0]  TM_REDUMP       
);

//wire    [DATA_BITS-1:0] rwdl_array_0;
//wire    [DATA_BITS-1:0] rwdl_array_1;


integer          trim_o_delay_time0;
integer          trim_o_delay_time1;
integer          trim_o_delay_time2;
integer          trim_o_delay_time3;
`ifdef DRAM_6
integer          trim_o_delay_time4;
integer          trim_o_delay_time5;
`endif

//lid
wire    [1*`N-1:0]      spine_reset_n_delay;
wire    [1*`N-1:0]      tm_redump_delay;
wire    [1*`N-1:0]      stopwatch_period_delay;
wire    [428:1]         tsv_tm_delay_0;
wire    [428:1]         tsv_tm_delay_1;
wire    [428:1]         tsv_tm_delay_2;
wire    [428:1]         tsv_tm_delay_3;
`ifdef DRAM_6
wire    [428:1]         tsv_tm_delay_4;
wire    [428:1]         tsv_tm_delay_5;
`endif
//lid

wire    [1*`N-1:0]      spine_reset_n_delay_o;
wire    [1*`N-1:0]      tm_redump_delay_o;
wire    [1*`N-1:0]      stopwatch_period_delay_o;
wire    [428:1]         tsv_tm_delay_0_o;
wire    [428:1]         tsv_tm_delay_1_o;
wire    [428:1]         tsv_tm_delay_2_o;
wire    [428:1]         tsv_tm_delay_3_o;           
`ifdef DRAM_6
wire    [428:1]         tsv_tm_delay_4_o;
wire    [428:1]         tsv_tm_delay_5_o;
`endif

integer          trim_i_delay_time0;
integer          trim_i_delay_time1;
integer          trim_i_delay_time2;
integer          trim_i_delay_time3;
`ifdef DRAM_6
integer          trim_i_delay_time4;
integer          trim_i_delay_time5;
`endif

//lid
wire    [1*`N-1:0]      dump_ready_delay;
wire    [1*`N-1:0]      stopwatch_ringo_delay;
wire    [2*`N-1:0]      osc_tm_res_delay;
//lid

wire    [1*`N-1:0]      dump_ready        ;
wire    [1*`N-1:0]      stopwatch_ringo   ;
wire    [2*`N-1:0]      osc_tm_res        ;

always@(SPINE_RESET_N[0])begin
    trim_o_delay_time0 = $urandom_range(100,200);
end
assign #(trim_o_delay_time0*1ps) spine_reset_n_delay[0]      = SPINE_RESET_N[0];
assign #(trim_o_delay_time0*1ps) tm_redump_delay[0]          = TM_REDUMP[0];
assign #(trim_o_delay_time0*1ps) stopwatch_period_delay[0]   = STOPWATCH_PERIOD[0];
assign #(trim_o_delay_time0*1ps) tsv_tm_delay_0              = TSV_TM;

always@(SPINE_RESET_N[1])begin
    trim_o_delay_time1 = $urandom_range(100,200);
end
assign #(trim_o_delay_time1*1ps) spine_reset_n_delay[1]      = SPINE_RESET_N[1];
assign #(trim_o_delay_time1*1ps) tm_redump_delay[1]          = TM_REDUMP[1];
assign #(trim_o_delay_time1*1ps) stopwatch_period_delay[1]   = STOPWATCH_PERIOD[1];
assign #(trim_o_delay_time1*1ps) tsv_tm_delay_1              = TSV_TM;

always@(SPINE_RESET_N[2])begin
    trim_o_delay_time2 = $urandom_range(100,200);
end
assign #(trim_o_delay_time2*1ps) spine_reset_n_delay[2]      =  SPINE_RESET_N[2];
assign #(trim_o_delay_time2*1ps) tm_redump_delay[2]          =  TM_REDUMP[2];
assign #(trim_o_delay_time2*1ps) stopwatch_period_delay[2]   =  STOPWATCH_PERIOD[2];
assign #(trim_o_delay_time2*1ps) tsv_tm_delay_2              =  TSV_TM;

always@(SPINE_RESET_N[3])begin
    trim_o_delay_time3 = $urandom_range(100,200);
end
assign #(trim_o_delay_time3*1ps) spine_reset_n_delay[3]      = SPINE_RESET_N[3];
assign #(trim_o_delay_time3*1ps) tm_redump_delay[3]          = TM_REDUMP[3];
assign #(trim_o_delay_time3*1ps) stopwatch_period_delay[3]   = STOPWATCH_PERIOD[3];
assign #(trim_o_delay_time3*1ps) tsv_tm_delay_3              = TSV_TM;

`ifdef DRAM_6
always@(SPINE_RESET_N[4])begin
    trim_o_delay_time4 = $urandom_range(100,200);
end
assign #(trim_o_delay_time4*1ps) spine_reset_n_delay[4]      = SPINE_RESET_N[4];
assign #(trim_o_delay_time4*1ps) tm_redump_delay[4]          = TM_REDUMP[4];
assign #(trim_o_delay_time4*1ps) stopwatch_period_delay[4]   = STOPWATCH_PERIOD[4];
assign #(trim_o_delay_time4*1ps) tsv_tm_delay_4              = TSV_TM;

always@(SPINE_RESET_N[5])begin
    trim_o_delay_time5 = $urandom_range(100,200);
end
assign #(trim_o_delay_time5*1ps) spine_reset_n_delay[5]      = SPINE_RESET_N[5];
assign #(trim_o_delay_time5*1ps) tm_redump_delay[5]          = TM_REDUMP[5];
assign #(trim_o_delay_time5*1ps) stopwatch_period_delay[5]   = STOPWATCH_PERIOD[5];
assign #(trim_o_delay_time5*1ps) tsv_tm_delay_5              = TSV_TM;
`endif

  
// trim output:
assign spine_reset_n_delay_o     =  spine_reset_n_delay       ;
assign tm_redump_delay_o         =  tm_redump_delay           ;
assign stopwatch_period_delay_o  =  stopwatch_period_delay    ;
assign tsv_tm_delay_0_o          =  tsv_tm_delay_0            ;
assign tsv_tm_delay_1_o          =  tsv_tm_delay_1            ;
assign tsv_tm_delay_2_o          =  tsv_tm_delay_2            ;
assign tsv_tm_delay_3_o          =  tsv_tm_delay_3            ;        
`ifdef DRAM_6
assign tsv_tm_delay_4_o          =  tsv_tm_delay_4            ;
assign tsv_tm_delay_5_o          =  tsv_tm_delay_5            ;
`endif


always@(dump_ready[0])begin
    trim_i_delay_time0 = $urandom_range(100,5000); //100ps~2clk
end
assign  #(trim_i_delay_time0*1ps) dump_ready_delay[0]         = dump_ready[0];
assign  #(trim_i_delay_time0*1ps) stopwatch_ringo_delay[0]    = stopwatch_ringo[0];
assign  #(trim_i_delay_time0*1ps) osc_tm_res_delay[1:0]       = osc_tm_res[1:0];

always@(dump_ready[1])begin
    trim_i_delay_time1 = $urandom_range(100,5000); //100ps~2clk
end
assign  #(trim_i_delay_time1*1ps)  dump_ready_delay[1]         = dump_ready[1];
assign  #(trim_i_delay_time1*1ps)  stopwatch_ringo_delay[1]    = stopwatch_ringo[1];
assign  #(trim_i_delay_time1*1ps)  osc_tm_res_delay[3:2]       = osc_tm_res[3:2];

always@(dump_ready[2])begin
    trim_i_delay_time2 = $urandom_range(100,5000); //100ps~2clk
end
assign  #(trim_i_delay_time2*1ps)  dump_ready_delay[2]         = dump_ready[2];
assign  #(trim_i_delay_time2*1ps)  stopwatch_ringo_delay[2]    = stopwatch_ringo[2];
assign  #(trim_i_delay_time2*1ps)  osc_tm_res_delay[5:4]       = osc_tm_res[5:4];

always@(dump_ready[3])begin
    trim_i_delay_time3 = $urandom_range(100,5000); //100ps~2clk
end
assign  #(trim_i_delay_time3*1ps)  dump_ready_delay[3]         = dump_ready[3];
assign  #(trim_i_delay_time3*1ps)  stopwatch_ringo_delay[3]    = stopwatch_ringo[3];
assign  #(trim_i_delay_time3*1ps)  osc_tm_res_delay[7:6]       = osc_tm_res[7:6];

`ifdef DRAM_6
always@(dump_ready[4])begin
    trim_i_delay_time4 = $urandom_range(100,5000); //100ps~2clk
end
assign  #(trim_i_delay_time4*1ps)  dump_ready_delay[4]         = dump_ready[4];
assign  #(trim_i_delay_time4*1ps)  stopwatch_ringo_delay[4]    = stopwatch_ringo[4];
assign  #(trim_i_delay_time4*1ps)  osc_tm_res_delay[9:8]       = osc_tm_res[9:8];

always@(dump_ready[5])begin
    trim_i_delay_time5 = $urandom_range(100,5000); //100ps~2clk
end
assign  #(trim_i_delay_time5*1ps)  dump_ready_delay[5]         = dump_ready[5];
assign  #(trim_i_delay_time5*1ps)  stopwatch_ringo_delay[5]    = stopwatch_ringo[5];
assign  #(trim_i_delay_time5*1ps)  osc_tm_res_delay[11:10]       = osc_tm_res[11:10];
`endif


//dram to trim input:
assign  DUMP_READY         = dump_ready_delay         ; 
assign  STOPWATCH_RINGO    = stopwatch_ringo_delay    ; 
assign  OSC_TM_RES         = osc_tm_res_delay         ;
//-----------------------add by lid-0717--------------------------end


LVS_FULL u_quad_group(
    .bnksel_n_i_BK00    (bnksel_n_i_bk0                                                                 ),//bnksel_n_array_0),
    .g_radd_i_BK00      (g_radd_i_BK                                                                    ),//gradd_array_0), 
    .g_cadd_i_BK00      (g_cadd_i_BK                                                                    ),//gcadd_array_0),
    .g_cas_rd_i_BK00    (g_cas_rd_i_BK0                                           ),//gcas_rd_array_0),
    .g_cas_wr_i_BK00    (g_cas_wr_i_BK0                                           ),//gcas_wr_array_0),
    .g_rdrdy_n_o_BK00   (g_rdrdy_n_o_bk0                                                                ),//rdrdy_n_phy_0),
    .g_rwdl_io_BK00     (g_rwdl_io_BK                                                                   ),
    .reset_n_BK00       (reset_n_BK                                                                     ),//reset_n_array_0),

    .bnksel_n_i_BK01    (bnksel_n_i_bk1                                                                 ),//bnksel_n_array_1),
    .g_radd_i_BK01      (g_radd_i_BK                                                                    ),//gradd_array_1), 
    .g_cadd_i_BK01      (g_cadd_i_BK                                                                    ),//gcadd_array_1),
    .g_cas_rd_i_BK01    (g_cas_rd_i_BK1                                           ),//gcas_rd_array_1),
    .g_cas_wr_i_BK01    (g_cas_wr_i_BK1                                           ),//gcas_wr_array_1),
    .g_rdrdy_n_o_BK01   (g_rdrdy_n_o_bk1                                                                ),//rdrdy_n_phy_1),
    .g_rwdl_io_BK01     (g_rwdl_io_BK                                                                   ),//rwdl_array_1),
    .reset_n_BK01       (reset_n_BK                                                                     ),//reset_n_array_1),

    .bnksel_n_i_BK02    (bnksel_n_i_bk2                                                                 ),//bnksel_n_array_2),
    .g_radd_i_BK02      (g_radd_i_BK                                                                    ),//gradd_array_2), 
    .g_cadd_i_BK02      (g_cadd_i_BK                                                                    ),//gcadd_array_2),
    .g_cas_rd_i_BK02    (g_cas_rd_i_BK2                                                                ),//gcas_rd_array_2),
    .g_cas_wr_i_BK02    (g_cas_wr_i_BK2                                                                ),//gcas_wr_array_2),
    .g_rdrdy_n_o_BK02   (g_rdrdy_n_o_bk2                                                                ),//rdrdy_n_phy_2),
    .g_rwdl_io_BK02     (g_rwdl_io_BK                                                                   ),//rwdl_array_2),
    .reset_n_BK02       (reset_n_BK                                                                     ),
    
   	.bnksel_n_i_BK03    (bnksel_n_i_bk3                                                                 ),
    .g_radd_i_BK03      (g_radd_i_BK                                                                    ),     
    .g_cadd_i_BK03      (g_cadd_i_BK                                                                    ),
    .g_cas_rd_i_BK03    (g_cas_rd_i_BK3                                                                 ),
    .g_cas_wr_i_BK03    (g_cas_wr_i_BK3                                                                 ),
    .g_rdrdy_n_o_BK03   (g_rdrdy_n_o_bk3                                                                ),
    .g_rwdl_io_BK03     (g_rwdl_io_BK                                                                   ),
    .reset_n_BK03       (reset_n_BK                                                                     )   
);

LVS_FULL u_quad_group_0(
    .SPINE_RESET_N      (spine_reset_n_delay_o[0]       ), 
	.TSV_TM             (tsv_tm_delay_0_o               ), //TSV_TM-0717
    .VMON               (VMON                   ), 
    .DUMP_READY         (dump_ready[0]          ),     
    .STOPWATCH_RINGO    (stopwatch_ringo[0]     ),     
    .OSC_TM_RES         (osc_tm_res[1:0]        ),     
    .STOPWATCH_PERIOD   (stopwatch_period_delay_o[0]    ),         
    .TM_REDUMP          (tm_redump_delay_o[0]           )         
);


LVS_FULL u_quad_group_1(
    .SPINE_RESET_N      (spine_reset_n_delay_o[1]       ), 
	.TSV_TM             (tsv_tm_delay_1_o               ),  //TSV_TM-0717
    .VMON               (VMON                   ), 
    .DUMP_READY         (dump_ready[1]          ),     
    .STOPWATCH_RINGO    (stopwatch_ringo[1]     ),     
    .OSC_TM_RES         (osc_tm_res[3:2]        ),     
    .STOPWATCH_PERIOD   (stopwatch_period_delay_o[1]    ),         
    .TM_REDUMP          (tm_redump_delay_o[1]           )         
);


LVS_FULL u_quad_group_2(
    .SPINE_RESET_N      (spine_reset_n_delay_o[2]       ), 
	.TSV_TM             (tsv_tm_delay_2_o               ),  //TSV_TM-0717
    .VMON               (VMON                   ), 
    .DUMP_READY         (dump_ready[2]          ),     
    .STOPWATCH_RINGO    (stopwatch_ringo[2]     ),     
    .OSC_TM_RES         (osc_tm_res[5:4]        ),     
    .STOPWATCH_PERIOD   (stopwatch_period_delay_o[2]    ),         
    .TM_REDUMP          (tm_redump_delay_o[2]           )         
);


LVS_FULL u_quad_group_3(
    .SPINE_RESET_N      (spine_reset_n_delay_o[3]       ), 
	.TSV_TM             (tsv_tm_delay_3_o               ),  //TSV_TM-0717
    .VMON               (VMON                   ), 
    .DUMP_READY         (dump_ready[3]          ),     
    .STOPWATCH_RINGO    (stopwatch_ringo[3]     ),     
    .OSC_TM_RES         (osc_tm_res[7:6]        ),     
    .STOPWATCH_PERIOD   (stopwatch_period_delay_o[3]    ),         
    .TM_REDUMP          (tm_redump_delay_o[3]           )         
);

`ifdef DRAM_6
LVS_FULL u_quad_group_4(
    .SPINE_RESET_N      (spine_reset_n_delay_o[4]       ), 
	.TSV_TM             (tsv_tm_delay_4_o               ),  //TSV_TM-0717
    .VMON               (VMON                   ), 
    .DUMP_READY         (dump_ready[4]          ),     
    .STOPWATCH_RINGO    (stopwatch_ringo[4]     ),     
    .OSC_TM_RES         (osc_tm_res[9:8]        ),     
    .STOPWATCH_PERIOD   (stopwatch_period_delay_o[4]    ),         
    .TM_REDUMP          (tm_redump_delay_o[4]           )         
);


LVS_FULL u_quad_group_5(
    .SPINE_RESET_N      (spine_reset_n_delay_o[5]       ), 
	.TSV_TM             (tsv_tm_delay_5_o               ),  //TSV_TM-0717
    .VMON               (VMON                   ), 
    .DUMP_READY         (dump_ready[5]          ),     
    .STOPWATCH_RINGO    (stopwatch_ringo[5]     ),     
    .OSC_TM_RES         (osc_tm_res[11:10]        ),     
    .STOPWATCH_PERIOD   (stopwatch_period_delay_o[5]    ),         
    .TM_REDUMP          (tm_redump_delay_o[5]           )         
);
`endif

endmodule

