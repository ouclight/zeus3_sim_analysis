
wire                                vdd;
wire                                vdd_array;
wire                                vss;
wire                                vmon;

assign                              vdd         =   1'b1;
assign                              vdd_array   =   1'b1;
assign                              vss         =   1'b0;

//array port
wire    [1*`N-1:0]         spine_reset_n;
wire    [427:0]            tsv_tm;
wire    [1*`N-1:0]         dump_ready;
wire    [1*`N-1:0]         stopwatch_ringo;
wire    [2*`N-1:0]         osc_tm_res;
wire    [1*`N-1:0]         stopwatch_period;
wire    [1*`N-1:0]         tm_redump;



//input and output have no delay:
phy_spine_u m_phy_spine_u(
    //-------------0th layer-------------
    .DUMP_READY_ASIC            (m_trim_if.dump_ready[0]        ),
    .OSC_TM_RES_ASIC            (m_trim_if.osc_tm_res[1:0]      ),
    .SPINE_RESET_N              (spine_reset_n[0]               ),
    .STOPWATCH_PERIOD           (stopwatch_period[0]            ),
    .STOPWATCH_RINGO_ASIC       (m_trim_if.stopwatch_ringo[0]   ),
    .TM_REDUMP                  (tm_redump[0]                   ),

    .DUMP_READY                 (dump_ready[0]                  ), 
    .OSC_TM_RES                 (osc_tm_res[1:0]                ), 
    .SPINE_RESET_N_ASIC         (m_trim_if.spine_reset_n[0]     ), 
    .STOPWATCH_PERIOD_ASIC      (m_trim_if.stopwatch_period[0]  ), 
    .STOPWATCH_RINGO            (stopwatch_ringo[0]             ), 
    .TM_REDUMP_ASIC             (m_trim_if.tm_redump[0]         ), 

    //-------------1th layer-------------
    .D1_DUMP_READY_ASIC         (m_trim_if.dump_ready[1]        ), 
    .D1_OSC_TM_RES_ASIC         (m_trim_if.osc_tm_res[3:2]      ), 
    .D1_SPINE_RESET_N           (spine_reset_n[1]               ), 
    .D1_STOPWATCH_PERIOD        (stopwatch_period[1]            ), 
    .D1_STOPWATCH_RINGO_ASIC    (m_trim_if.stopwatch_ringo[1]   ), 
    .D1_TM_REDUMP               (tm_redump[1]                   ),
                                                                
    .D1_DUMP_READY              (dump_ready[1]                  ), 
    .D1_OSC_TM_RES              (osc_tm_res[3:2]                ), 
    .D1_SPINE_RESET_N_ASIC      (m_trim_if.spine_reset_n[1]     ), 
    .D1_STOPWATCH_PERIOD_ASIC   (m_trim_if.stopwatch_period[1]  ), 
    .D1_STOPWATCH_RINGO         (stopwatch_ringo[1]             ), 
    .D1_TM_REDUMP_ASIC          (m_trim_if.tm_redump[1]         ),

    //-------------2th layer-------------
    .D2_DUMP_READY_ASIC         (m_trim_if.dump_ready[2]        ), 
    .D2_OSC_TM_RES_ASIC         (m_trim_if.osc_tm_res[5:4]      ), 
    .D2_SPINE_RESET_N           (spine_reset_n[2]               ),
    .D2_STOPWATCH_PERIOD        (stopwatch_period[2]            ), 
    .D2_STOPWATCH_RINGO_ASIC    (m_trim_if.stopwatch_ringo[2]   ), 
    .D2_TM_REDUMP               (tm_redump[2]                   ),
                                                                
    .D2_DUMP_READY              (dump_ready[2]                  ), 
    .D2_OSC_TM_RES              (osc_tm_res[5:4]                ),
    .D2_SPINE_RESET_N_ASIC      (m_trim_if.spine_reset_n[2]     ), 
    .D2_STOPWATCH_PERIOD_ASIC   (m_trim_if.stopwatch_period[2]  ), 
    .D2_STOPWATCH_RINGO         (stopwatch_ringo[2]             ), 
    .D2_TM_REDUMP_ASIC          (m_trim_if.tm_redump[2]         ),

    //-------------3th layer-------------
    .D3_DUMP_READY_ASIC         (m_trim_if.dump_ready[3]        ), 
    .D3_OSC_TM_RES_ASIC         (m_trim_if.osc_tm_res[7:6]      ), 
    .D3_SPINE_RESET_N           (spine_reset_n[3]               ), 
    .D3_STOPWATCH_PERIOD        (stopwatch_period[3]            ), 
    .D3_STOPWATCH_RINGO_ASIC    (m_trim_if.stopwatch_ringo[3]   ), 
    .D3_TM_REDUMP               (tm_redump[3]                   ),
                                                                
    .D3_DUMP_READY              (dump_ready[3]                  ), 
    .D3_OSC_TM_RES              (osc_tm_res[7:6]                ), 
    .D3_SPINE_RESET_N_ASIC      (m_trim_if.spine_reset_n[3]     ), 
    .D3_STOPWATCH_PERIOD_ASIC   (m_trim_if.stopwatch_period[3]  ), 
    .D3_STOPWATCH_RINGO         (stopwatch_ringo[3]             ),
    .D3_TM_REDUMP_ASIC          (m_trim_if.tm_redump[3]         ),


    .TSV_TM_88_1_ASIC           (m_trim_if.tsv_tm[87:0]         ),
    .TSV_TM_332_205_ASIC        (m_trim_if.tsv_tm[331:204]      ),
    .TSV_TM_88_1                (tsv_tm[87:0]                   ),
    .TSV_TM_332_205             (tsv_tm[331:204]                ), 
    .ls_en_asic                 (m_trim_if.ls_en_asic           ),
    .vdd                        (vdd                            ), 
    .vdd_array                  (vdd_array                      ), 
    .vss                        (vss                            ), 
    .vss_array                  (vss                            ),
    .VMON                       (vmon                           )
);


phy_spine_d m_phy_spine_d(
    .vdd                        (vdd                            ), 
    .vdd_array                  (vdd_array                      ), 
    .vss                        (vss                            ), 
    .vss_array                  (vss                            ),
    .ls_en_asic                 (m_trim_if.ls_en_asic           ),

    .TSV_TM_204_89              (tsv_tm[203:88]                 ),
    .TSV_TM_428_333             (tsv_tm[427:332]                ),
    .TSV_TM_428_333_ASIC        (m_trim_if.tsv_tm[427:332]      ),
    .TSV_TM_204_89_ASIC         (m_trim_if.tsv_tm[203:88]       )
);


CUBE_HC01_TOP u_quad_group(
    .SPINE_RESET_N              (spine_reset_n                  ), 
    .TSV_TM                     (tsv_tm                         ),  
    .DUMP_READY                 (dump_ready                     ), 
    .STOPWATCH_RINGO            (stopwatch_ringo                ), 
    .OSC_TM_RES                 (osc_tm_res                     ), 
    .STOPWATCH_PERIOD           (stopwatch_period               ), 
    .TM_REDUMP                  (tm_redump                      ), 
    .VMON                       (vmon                           )
);




