module mc_ecc_top #(
    parameter   MC_DATA_WIDTH       = 256,
    parameter   MC_ECC_CHK_WIDTH    = 10,   
    parameter   MC_FRAME_DATA_WIDTH = MC_DATA_WIDTH+MC_ECC_CHK_WIDTH,
    parameter   MC_CE_RECORD_NUM    = 16,
    parameter   MC_UCE_RECORD_NUM   = 4,
    parameter   MC_COL_ADDR_WIDTH   = 7,
    parameter   MC_ROW_ADDR_WIDTH   = 13,
    parameter   MC_ERR_ADDR_WIDTH   = MC_COL_ADDR_WIDTH+MC_ROW_ADDR_WIDTH+1
)(
    input                                                   clk                     ,
    input                                                   rst_n                   ,
    input                                                   mc_ecc_en               ,   // 1 enable ecc 
    input       [MC_DATA_WIDTH-1:0]                         axi2mc_data             ,
    output      [MC_FRAME_DATA_WIDTH-1:0]                   frame2array_data        ,
    input                                                   array2frame_data_vld    ,
    input       [MC_FRAME_DATA_WIDTH-1:0]                   array2frame_data        ,
    input       [MC_ERR_ADDR_WIDTH-1:0]                     array2frame_addr        ,
    output      [MC_DATA_WIDTH-1:0]                         mc2axi_data             ,
    output                                                  mc2axi_data_vld         ,
    output      [1:0]                                       mc2axi_rrsp             ,   // 10 ECC UCE ; 00 OK ; Reserved
    input       [4:0]                                       mc_ecc_ce_th            ,
    input                                                   mc_ecc_ce_int_clr       ,
    output                                                  mc_ecc_ce_overflow_int  ,
    output      [4:0]                                       mc_ecc_ce_cnt           ,
    output      [MC_CE_RECORD_NUM*MC_ERR_ADDR_WIDTH-1:0]    mc_ecc_ce_addr          ,
    output      [MC_CE_RECORD_NUM-1:0]                      mc_ecc_ce_addr_vld      ,
    input                                                   mc_ecc_uce_int_clr      ,
    output                                                  mc_ecc_uce_int          ,
    output      [2:0]                                       mc_ecc_uce_cnt          ,
    output      [MC_UCE_RECORD_NUM-1:0]                     mc_ecc_uce_addr_vld     ,
    output      [MC_UCE_RECORD_NUM*MC_ERR_ADDR_WIDTH-1:0]   mc_ecc_uce_addr         
);

//========================internal signal===============================
wire        o_err_detect;
wire        o_err_multpl;

wire       [MC_ERR_ADDR_WIDTH-1:0]          array2frame_addr_s;

ecc_encode #(
    .DATA_WIDTH (MC_DATA_WIDTH      ),
    .CHK_WIDTH  (MC_ECC_CHK_WIDTH   )
)ecc_encode_256bit_u(
    .i_data     (axi2mc_data        ),
    .i_ecc_on   (mc_ecc_en          ),
    .o_data     (frame2array_data   ) // {ecc bit ,data}                    
);

ecc_decode #(
    .DATA_WIDTH (MC_DATA_WIDTH      ),
    .CHK_WIDTH  (MC_ECC_CHK_WIDTH   ),
    .PIPE_IN_EN (0                  ),
    .PIPE_OUT_EN(0                  )
)ecc_decode_256bit_u(
    .clk          (clk                                                  ),
    .rst_n        (rst_n                                                ),
    .i_ecc_on     (mc_ecc_en                                            ),
    .i_data       (array2frame_data[MC_DATA_WIDTH-1:0]                  ),
    .i_chkbit     (array2frame_data[MC_FRAME_DATA_WIDTH-1:MC_DATA_WIDTH]),
    .i_data_valid (array2frame_data_vld                                 ),
    .o_err_detect (o_err_detect                                         ),//error detected,correct
    .o_err_multpl (o_err_multpl                                         ),//modify errors detected
    .o_data_valid (mc2axi_data_vld                                      ),
    .o_data       (mc2axi_data                                          )
);

assign  mc2axi_rrsp = {o_err_multpl,1'b0};

DW_fifo_s1_sf
    #(

        .width      (MC_ERR_ADDR_WIDTH              ) , 
        .depth      (4                              ), 
        .ae_level   (2                              ), 
        .af_level   (2                              ), 
        .err_mode   (0                              ), 
        .rst_mode   (0                              )
    )U0_recc_addr_sync_fifo (
        .clk            (clk                        ),
        .rst_n          (rst_n                      ),
        .push_req_n     (!array2frame_data_vld      ),
        .pop_req_n      (~mc2axi_data_vld           ),
        .diag_n         (1'b1                       ),
        .data_in        (array2frame_addr           ),
        .empty          (                           ),
        .almost_empty   (                           ),
        .half_full      (                           ),
        .almost_full    (                           ),
        .full           (                           ),
        .error          (                           ),
        .data_out       (array2frame_addr_s         )
    );


mc_ecc_error_record #(
    .MC_CE_RECORD_NUM   (MC_CE_RECORD_NUM   ),   
    .MC_UCE_RECORD_NUM  (MC_UCE_RECORD_NUM  ), 
    .MC_COL_ADDR_WIDTH  (MC_COL_ADDR_WIDTH  ), 
    .MC_ROW_ADDR_WIDTH  (MC_ROW_ADDR_WIDTH  ), 
    .MC_ERR_ADDR_WIDTH  (MC_ERR_ADDR_WIDTH  ) 
)mc_ecc_error_record_u(
    .clk                     (clk                                           ),
    .rst_n                   (rst_n                                         ),
    .mc_ecc_ce_vld           (mc_ecc_en && mc2axi_data_vld && o_err_detect  ),
    .mc_ecc_uce_vld          (mc_ecc_en && mc2axi_data_vld && o_err_multpl  ),
    .mc_ecc_addr             (array2frame_addr_s                            ),
    .mc_ecc_ce_th            (mc_ecc_ce_th                                  ),
    .mc_ecc_ce_int_clr       (mc_ecc_ce_int_clr                             ),
    .mc_ecc_ce_overflow_int  (mc_ecc_ce_overflow_int                        ),
    .mc_ecc_ce_cnt           (mc_ecc_ce_cnt                                 ),
    .mc_ecc_ce_addr          (mc_ecc_ce_addr                                ),
    .mc_ecc_ce_addr_vld      (mc_ecc_ce_addr_vld                            ),
    .mc_ecc_uce_int_clr      (mc_ecc_uce_int_clr                            ),
    .mc_ecc_uce_int          (mc_ecc_uce_int                                ),
    .mc_ecc_uce_cnt          (mc_ecc_uce_cnt                                ),
    .mc_ecc_uce_addr_vld     (mc_ecc_uce_addr_vld                           ),
    .mc_ecc_uce_addr         (mc_ecc_uce_addr                               )
);

endmodule
