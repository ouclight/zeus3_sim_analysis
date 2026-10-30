wire                                vdd;
wire                                vdd_array;
wire                                vss;

assign      vdd         =   1'b1;
assign      vdd_array   =   1'b1;
assign      vss         =   1'b0;
//array port
wire                               bnksel_n_array_0;
wire   [`COLUMN_ADDR_WIDTH-1:0]    gcadd_array_0;   
wire                               gcas_rd_array_0; 
wire                               gcas_wr_array_0; 
wire   [`ROW_ADDR_WIDTH-1:0]       gradd_array_0;   
wire                               reset_n_array_0; 
wire   [271:0]       rwdl_array_0;    
wire   [271:0]       rdata_phy_0;    
wire                               rdrdy_n_phy_0;  

wire                               bnksel_n_array_1;
wire   [`COLUMN_ADDR_WIDTH-1:0]    gcadd_array_1;   
wire                               gcas_rd_array_1; 
wire                               gcas_wr_array_1; 
wire   [`ROW_ADDR_WIDTH-1:0]       gradd_array_1;   
wire                               reset_n_array_1; 
wire   [271:0]       rwdl_array_1;    
wire   [271:0]       rdata_phy_1;    
wire                               rdrdy_n_phy_1;  

phy_group u_phy_group( 
    .bnksel_n_array_d0_0    (bnksel_n_array_0                   ),      .bnksel_n_array_d0_1    (       ),
    .bnksel_n_array_d1_0    (bnksel_n_array_1                   ),      .bnksel_n_array_d1_1    (       ),
    .gcadd_array_0          (gcadd_array_0                      ),      .gcadd_array_1          (       ),
    .gcas_rd_array_0        (gcas_rd_array_0                    ),      .gcas_rd_array_1        (       ),
    .gcas_wr_array_0        (gcas_wr_array_0                    ),      .gcas_wr_array_1        (       ),
    .gradd_array_0          (gradd_array_0                      ),      .gradd_array_1          (       ),
    .rdata_asic_0           (m_array_agent_if.rdl               ),      .rdata_asic_1           (       ),
    .rdrdy_n_asic_0         (m_array_agent_if.rdrdy_n           ),      .rdrdy_n_asic_1         (       ),
    .reset_n_array_0        (reset_n_array_0                    ),      .reset_n_array_1        (       ),
    .rwdl_array_0           (rwdl_array_0                       ),      .rwdl_array_1           (       ),
    .vdd                    (vdd                                ),
    .vdd_array              (vdd_array                          ),
    .vss                    (vss                                ),
    .bnksel_n_asic_d0_0     (m_array_agent_if.bnksel_n[0]       ),      .bnksel_n_asic_d0_1     (       ),
    .bnksel_n_asic_d1_0     (m_array_agent_if.bnksel_n[1]       ),      .bnksel_n_asic_d1_1     (       ),
    .cfg_dly_bnksel_n_d0_0  (u_tb_if.bank_radd_set_time_o[1:0]  ),      .cfg_dly_bnksel_n_d0_1  (       ),
    .cfg_dly_bnksel_n_d1_0  (u_tb_if.bank_radd_set_time_o[3:2]  ),      .cfg_dly_bnksel_n_d1_1  (       ),
    .cfg_dly_gcadd_0        (u_tb_if.cadd_set_time_o[1:0]       ),      .cfg_dly_gcadd_1        (       ),
    .cfg_dly_gcas_rd_0      (u_tb_if.r_cas_set_time_o[1:0]      ),      .cfg_dly_gcas_rd_1      (       ),
    .cfg_dly_gcas_wr_0      (u_tb_if.w_cas_set_time_o[1:0]      ),      .cfg_dly_gcas_wr_1      (       ),
    .clk_in_asic_0          (clk_pll                            ),      .clk_in_asic_1          (       ),
    .gcadd_asic_0           (m_array_agent_if.gcadd             ),      .gcadd_asic_1           (       ),
    .gcas_rd_en_asic_0      (m_array_agent_if.gcas_rd           ),      .gcas_rd_en_asic_1      (       ),
    .gcas_wr_en_asic_0      (m_array_agent_if.gcas_wr           ),      .gcas_wr_en_asic_1      (       ),
    .gradd_asic_0           (m_array_agent_if.gradd_n           ),      .gradd_asic_1           (       ),
    .ls_en_asic_0           (u_tb_if.ls_en_asic_0               ),      .ls_en_asic_1           (       ),
    .rdrdy_n_array_d0_0     (rdrdy_n_phy_0                      ),      .rdrdy_n_array_d0_1     (       ),
    .rdrdy_n_array_d1_0     (rdrdy_n_phy_1                      ),      .rdrdy_n_array_d1_1     (       ),
    .reset_n_asic_0         (u_tb_if.mc_sys_rst_n               ),      .reset_n_asic_1         (       ),
    .wdata_asic_0           (m_array_agent_if.wdl               ),      .wdata_asic_1           (       ),
    .wdata_oe_asic_0        (m_array_agent_if.wdl_oe            ),      .wdata_oe_asic_1        (       )
);

CUBE_HC01_TOP u_quad_group(
    .bnksel_n_i_bk0     (bnksel_n_array_0       ),
    .bnksel_n_i_bk1     (bnksel_n_array_1       ),
    .g_radd_i_BK        (gradd_array_0       ),
    .g_cadd_i_BK        (gcadd_array_0       ),
    .g_cas_rd_i_BK      (gcas_rd_array_0       ),
    .g_cas_wr_i_BK      (gcas_wr_array_0       ),
    .g_rdrdy_n_o_bk0    (rdrdy_n_phy_0       ),
    .g_rdrdy_n_o_bk1    (rdrdy_n_phy_1       ),
    .g_rwdl_io_BK       (rwdl_array_0       ),
    .reset_n_BK         (reset_n_array_0   )
);

