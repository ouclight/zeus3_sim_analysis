
parameter   DRAM_LAYER_NUM = 4;

dram_trim_top#(
    .DRAM_LAYER_NUM(DRAM_LAYER_NUM) 
    )u_dram_trim_top(
    .clk               (clk                             ), 
    .rst_n             (rst_n                           ), 
    //----------------extern interface----------------
    .trim_ctrl_id      (32'h5452494D                    ),  
    .trim_start        (m_trim_if.trim_start            ),  
    .trim_finish       (m_trim_if.trim_finish           ), 
    .trim_res          (m_trim_if.trim_res              ), 
    .trim_interrupt    (m_trim_if.trim_interrupt        ), 
    //-------------------apb bus----------------------
    .apb_clk           (m_apb_if.pclk                   ), 
    .apb_rst_n         (m_apb_if.presetn                ), 
    .apb_sel           (m_apb_if.psel[0]                ), 
    .apb_en            (m_apb_if.penable                ), 
    .apb_write         (m_apb_if.pwrite                 ), 
    .apb_addr          (m_apb_if.paddr                  ), 
    .apb_wdata         (m_apb_if.pwdata                 ), 
    .apb_rdata         (m_apb_if.prdata[0]              ), 
    //--------------connect with dram----------------
    .spine_reset_n     (m_trim_if.spine_reset_n         ),     
    .tm_redump         (m_trim_if.tm_redump             ),     
    .stopwatch_period  (m_trim_if.stopwatch_period      ),     
    .tsv_tm            (m_trim_if.tsv_tm                ),     
    .dump_ready        (m_trim_if.dump_ready            ),     
    .stopwatch_ringo   (m_trim_if.stopwatch_ringo       ),     
    .osc_tm_res        (m_trim_if.osc_tm_res            ),
    .trim_monitor      (                                )
);      


