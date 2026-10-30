wire                            bnksel_n_i_BK00  ;
wire [`ROW_ADDR_WIDTH-1:0]      g_radd_i_BK00    ;
wire [`COLUMN_ADDR_WIDTH-1:0]   g_cadd_i_BK00    ;
wire                            g_cas_rd_i_BK00  ;
wire                            g_cas_wr_i_BK00  ;
wire                            g_rdrdy_n_o_BK00 ;
wire [271:0]                    g_rwdl_io_BK00   ;
wire                            reset_n_BK00     ;

wire                            bnksel_n_i_BK01  ;
wire [`ROW_ADDR_WIDTH-1:0]      g_radd_i_BK01    ;
wire [`COLUMN_ADDR_WIDTH-1:0]   g_cadd_i_BK01    ;
wire                            g_cas_rd_i_BK01  ;
wire                            g_cas_wr_i_BK01  ;
wire                            g_rdrdy_n_o_BK01 ;
wire [271:0]                    g_rwdl_io_BK01   ;
wire                            reset_n_BK01     ;

assign                  bnksel_n_i_BK00 = m_array_agent_if.bnksel_n[0] ;
assign                  g_radd_i_BK00   = m_array_agent_if.gradd_n  ;
assign                  g_cadd_i_BK00   = m_array_agent_if.gcadd    ;
assign                  g_cas_rd_i_BK00 = m_array_agent_if.gcas_rd  ;
assign                  g_cas_wr_i_BK00 = m_array_agent_if.gcas_wr  ;
assign                  m_array_agent_if.rdrdy_b0  = g_rdrdy_n_o_BK00;
assign                  g_rwdl_io_BK00  = (m_array_agent_if.wdl_oe)?  m_array_agent_if.wdl : 266'bz;
assign                  m_array_agent_if.rdl_b0  = (m_array_agent_if.wdl_oe) ? 266'bz : g_rwdl_io_BK00;
assign                  reset_n_BK00    = u_tb_if.mc_sys_rst_n      ;

assign                  bnksel_n_i_BK01 = m_array_agent_if.bnksel_n[1] ;
assign                  g_radd_i_BK01   = m_array_agent_if.gradd_n  ;
assign                  g_cadd_i_BK01   = m_array_agent_if.gcadd    ;
assign                  g_cas_rd_i_BK01 = m_array_agent_if.gcas_rd  ;
assign                  g_cas_wr_i_BK01 = m_array_agent_if.gcas_wr  ;
assign                  m_array_agent_if.rdrdy_b1  = g_rdrdy_n_o_BK01;
assign                  g_rwdl_io_BK01  = (m_array_agent_if.wdl_oe)?  m_array_agent_if.wdl : 266'bz;
assign                  m_array_agent_if.rdl_b1  = (m_array_agent_if.wdl_oe) ? 266'bz : g_rwdl_io_BK01;
assign                  reset_n_BK01    = u_tb_if.mc_sys_rst_n      ;


CUBE_HC01_TOP u_quad_group(
    .bnksel_n_i_BK00    (bnksel_n_i_BK00  ),
    .g_radd_i_BK00      (g_radd_i_BK00    ), 
    .g_cadd_i_BK00      (g_cadd_i_BK00    ),
    .g_cas_rd_i_BK00    (g_cas_rd_i_BK00  ),
    .g_cas_wr_i_BK00    (g_cas_wr_i_BK00  ),
    .g_rdrdy_n_o_BK00   (g_rdrdy_n_o_BK00 ),
    .g_rwdl_io_BK00     (g_rwdl_io_BK00   ),
    .reset_n_BK00       (reset_n_BK00     ),

    .bnksel_n_i_BK01    (bnksel_n_i_BK01  ),
    .g_radd_i_BK01      (g_radd_i_BK01    ), 
    .g_cadd_i_BK01      (g_cadd_i_BK01    ),
    .g_cas_rd_i_BK01    (g_cas_rd_i_BK01  ),
    .g_cas_wr_i_BK01    (g_cas_wr_i_BK01  ),
    .g_rdrdy_n_o_BK01   (g_rdrdy_n_o_BK01 ),
    .g_rwdl_io_BK01     (g_rwdl_io_BK01   ),
    .reset_n_BK01       (reset_n_BK01     )
);


