module CUBE_HC01_TOP #(
    parameter   ROW_BITS = 13,
    parameter   COL_BITS = 8,
    parameter   DATA_BITS = 272
)(
    input                     bnksel_n_i_bk0  ,
    input                     bnksel_n_i_bk1  ,
    input   [ROW_BITS-1:0]    g_radd_i_BK     ,
    input   [COL_BITS-1:0]    g_cadd_i_BK     ,
    input                     g_cas_rd_i_BK   ,
    input                     g_cas_wr_i_BK   ,
    output                    g_rdrdy_n_o_bk0  ,
    output                    g_rdrdy_n_o_bk1  ,
    inout   [DATA_BITS-1:0]   g_rwdl_io_BK    ,
    input                     reset_n_BK
);

//wire    [DATA_BITS-1:0] rwdl_array_0;
//wire    [DATA_BITS-1:0] rwdl_array_1;

CUBE_HC03 u_quad_group(
    .bnksel_n_i_BK00    (bnksel_n_i_bk0                                                                 ),//bnksel_n_array_0),
    .g_radd_i_BK00      (g_radd_i_BK                                                                    ),//gradd_array_0), 
    .g_cadd_i_BK00      (g_cadd_i_BK                                                                    ),//gcadd_array_0),
    .g_cas_rd_i_BK00    ((g_cas_rd_i_BK && (!bnksel_n_i_bk0)) ||  (g_cas_rd_i_BK && (bnksel_n_i_bk0))   ),//gcas_rd_array_0),
    .g_cas_wr_i_BK00    ((g_cas_wr_i_BK && (!bnksel_n_i_bk0)) ||  (g_cas_wr_i_BK && (bnksel_n_i_bk0))   ),//gcas_wr_array_0),
    .g_rdrdy_n_o_BK00   (g_rdrdy_n_o_bk0                                                                ),//rdrdy_n_phy_0),
    .g_rwdl_io_BK00     (g_rwdl_io_BK                                                                   ),
    .reset_n_BK00       (reset_n_BK                                                                     ),//reset_n_array_0),

    .bnksel_n_i_BK01    (bnksel_n_i_bk1                                                                 ),//bnksel_n_array_1),
    .g_radd_i_BK01      (g_radd_i_BK                                                                    ),//gradd_array_1), 
    .g_cadd_i_BK01      (g_cadd_i_BK                                                                    ),//gcadd_array_1),
    .g_cas_rd_i_BK01    ((g_cas_rd_i_BK && (!bnksel_n_i_bk1)) ||  (g_cas_rd_i_BK && (bnksel_n_i_bk1))   ),//gcas_rd_array_1),
    .g_cas_wr_i_BK01    ((g_cas_wr_i_BK && (!bnksel_n_i_bk1)) ||  (g_cas_wr_i_BK && (bnksel_n_i_bk1))   ),//gcas_wr_array_1),
    .g_rdrdy_n_o_BK01   (g_rdrdy_n_o_bk1                                                                ),//rdrdy_n_phy_1),
    .g_rwdl_io_BK01     (g_rwdl_io_BK                                                                   ),//rwdl_array_1),
    .reset_n_BK01       (reset_n_BK                                                                     ),//reset_n_array_1),
    .DUMP_READY         (dump_ready                                                                     )
);


endmodule
