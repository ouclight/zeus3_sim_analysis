    wire                                vdd;
    wire                                vdd_array;
    wire                                vss;
    
    assign      vdd         =   1'b1;
    assign      vdd_array   =   1'b1;
    assign      vss         =   1'b0;
    //array port
    wire   [`ROW_ADDR_WIDTH-1:0]       gradd_array;   
    wire   [`COLUMN_ADDR_WIDTH-1:0]    gcadd_array;   
    wire                               reset_n_array; 
    wire   [271:0]                     rwdl_array;   
    
    wire                               bnksel_n_array_0;
    wire                               gcas_rd_array_0; 
    wire                               gcas_wr_array_0; 
    wire                               rdrdy_n_phy_0;  
    
    wire                               bnksel_n_array_1;
    wire                               gcas_rd_array_1; 
    wire                               gcas_wr_array_1; 
    wire                               rdrdy_n_phy_1; 
    
    hb_macro_bnk_230m_4s_sample u_phy_group(
        .bnksel_n_array_0   (bnksel_n_array_0                   ),// 
        .bnksel_n_array_1   (bnksel_n_array_1                   ),// 
        .gcadd_array        (gcadd_array                        ),// 
        .gcas_rd_array_0    (gcas_rd_array_0                    ),// 
        .gcas_rd_array_1    (gcas_rd_array_1                    ),// 
        .gcas_wr_array_0    (gcas_wr_array_0                    ),// 
        .gcas_wr_array_1    (gcas_wr_array_1                    ),//    
        .gradd_array        (gradd_array                        ),// 
        .rdata_asic         (m_array_agent_if.rdl               ),// 
        .rdrdy_n_asic       (m_array_agent_if.rdrdy_n           ),//
        .reset_n_array      (reset_n_array                      ),// 
        .rwdl_array         (rwdl_array                         ),// 
        .vdd                (vdd                                ),// 
        .vdd_array          (vdd_array                          ),// 
        .vss                (vss                                ),// 
        .bnksel_n_asic_0    (m_array_agent_if.bnksel_n[0]       ),// 
        .bnksel_n_asic_1    (m_array_agent_if.bnksel_n[1]       ),// 
        .cfg_dly_bnksel_n_0 (u_tb_if.bank_radd_set_time_o[1:0]  ),// 
        .cfg_dly_bnksel_n_1 (u_tb_if.bank_radd_set_time_o[3:2]  ),// 
        .cfg_dly_gcadd      (u_tb_if.cadd_set_time_o[1:0]       ),// 
        .cfg_dly_gcas_rd_0  (u_tb_if.r_cas_set_time_o[1:0]      ),// 
        .cfg_dly_gcas_rd_1  (u_tb_if.r_cas_set_time_o[3:2]      ),// 
        .cfg_dly_gcas_wr_0  (u_tb_if.w_cas_set_time_o[1:0]      ),//
        .cfg_dly_gcas_wr_1  (u_tb_if.w_cas_set_time_o[3:2]      ),// 
        .clk_in_asic        (clk_pll                            ),// 
        .gcadd_asic         (m_array_agent_if.gcadd             ),// 
        .gcas_rd_en_asic_0  (m_array_agent_if.gcas_rd[0]        ),// 
        .gcas_rd_en_asic_1  (m_array_agent_if.gcas_rd[1]        ),// 
        .gcas_wr_en_asic_0  (m_array_agent_if.gcas_wr[0]        ),// 
        .gcas_wr_en_asic_1  (m_array_agent_if.gcas_wr[1]        ),// 
        .gradd_asic         (m_array_agent_if.gradd_n           ),// 
        .ls_en_asic         (u_tb_if.ls_en_asic_0               ),// 
        .rdrdy_n_array_0    (rdrdy_n_phy_0                      ),// 
        .rdrdy_n_array_1    (rdrdy_n_phy_1                      ),// 
        .reset_n_asic       (u_tb_if.mc_sys_rst_n               ),//
        .wdata_asic         (m_array_agent_if.wdl               ),// 
        .wdata_oe_asic      (m_array_agent_if.wdl_oe            ) //
    );    
    LVS_FULL u_quad_group (
        .bnksel_n_i_BK00 (bnksel_n_array_0),
        .g_radd_i_BK00   (gradd_array     ),
        .g_cadd_i_BK00   (gcadd_array     ),
        .g_cas_rd_i_BK00 (gcas_rd_array_0 ),
        .g_cas_wr_i_BK00 (gcas_wr_array_0 ),
        .g_rdrdy_n_o_BK00(rdrdy_n_phy_0   ),
        .g_rwdl_io_BK00  (rwdl_array      ),
        .reset_n_BK00    (reset_n_array   ),
    
    	.bnksel_n_i_BK01 (bnksel_n_array_1),
        .g_radd_i_BK01   (gradd_array     ),
        .g_cadd_i_BK01   (gcadd_array     ),
        .g_cas_rd_i_BK01 (gcas_rd_array_1 ),
        .g_cas_wr_i_BK01 (gcas_wr_array_1 ),
        .g_rdrdy_n_o_BK01(rdrdy_n_phy_1   ),
        .g_rwdl_io_BK01  (rwdl_array      ),
        .reset_n_BK01    (reset_n_array   )
    );
