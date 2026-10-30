


module mc_ecc_wrapper #(
        parameter   MC_DATA_WIDTH       = 256,
        parameter   MC_ECC_CHK_WIDTH    = 16,   
        parameter   MC_FRAME_DATA_WIDTH = MC_DATA_WIDTH+MC_ECC_CHK_WIDTH,
        parameter   MC_CE_RECORD_NUM    = 16,
        parameter   MC_UCE_RECORD_NUM   = 4,
        parameter   MC_COL_ADDR_WIDTH   = 7,
        parameter   MC_ROW_ADDR_WIDTH   = 13,
        parameter   MC_ERR_ADDR_WIDTH   = MC_COL_ADDR_WIDTH+MC_ROW_ADDR_WIDTH+2,
        parameter   HUB_FRAME_WIDTH     = MC_ECC_CHK_WIDTH+MC_DATA_WIDTH+MC_ROW_ADDR_WIDTH+MC_COL_ADDR_WIDTH+6
        )(
        input                                                   clk                     ,
        input                                                   rst_n                   ,
        input                                                   mc_ecc_en               ,
        //-------------------Input mc frame-------------------//
        input                                                   s_hub_frame_vld         ,
        output                                                  s_hub_frame_rdy         ,
        input       [HUB_FRAME_WIDTH-1:0]                       s_hub_frame_data        ,
        //-------------------output mc frame-------------------//
        output                                                  m_hub_frame_vld         ,
        input                                                   m_hub_frame_rdy         ,
        output      [HUB_FRAME_WIDTH-1:0]                       m_hub_frame_data        ,
        //-------------------read data from MC-------------------//
        input                                                   mc_rvalid               ,
        input       [MC_DATA_WIDTH+MC_ECC_CHK_WIDTH-1:0]        mc_rdata                ,
        //-------------------read data after ECC decode-------------------//
        output                                                  ecc_decode_rvalid       ,
        output      [MC_DATA_WIDTH+MC_ECC_CHK_WIDTH-1:0]        ecc_decode_rdata        ,
        output      [1:0]                                       ecc_decode_rresp        ,
        //-------------------ECC info record-------------------//
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


wire   [MC_COL_ADDR_WIDTH-1:0]  col_addr ;
wire   [MC_ROW_ADDR_WIDTH-1:0]  row_addr ;
wire   [1:0]                    bank_addr;
wire   [MC_DATA_WIDTH-1:0]      wdata    ;
wire   [MC_ECC_CHK_WIDTH-1:0]   checkbit ;
wire                            sof      ;
wire                            eof      ;
wire                            rw_flag  ;
wire                            strobe   ;


assign {strobe,rw_flag,sof,eof,checkbit,wdata,bank_addr,row_addr,col_addr} = s_hub_frame_data;


wire   [MC_DATA_WIDTH+MC_ECC_CHK_WIDTH-7:0]  ecc_encode_data ;
wire   [MC_ERR_ADDR_WIDTH-1:0]               frame_raddr     ;
wire                                         raddr_fifo_empty;
reg    [MC_ECC_CHK_WIDTH-1:0]                check_bit_reg0  ;
reg    [MC_ECC_CHK_WIDTH-1:0]                check_bit_reg1  ;


assign m_hub_frame_data = {strobe,rw_flag,sof,eof,6'd0,ecc_encode_data,bank_addr,row_addr,col_addr};
assign m_hub_frame_vld  = s_hub_frame_vld;
assign s_hub_frame_rdy  = m_hub_frame_rdy;



mc_ecc_top #(
        .MC_DATA_WIDTH    (MC_DATA_WIDTH     ),
        .MC_ECC_CHK_WIDTH (MC_ECC_CHK_WIDTH-6),
        .MC_CE_RECORD_NUM (MC_CE_RECORD_NUM  ),
        .MC_UCE_RECORD_NUM(MC_UCE_RECORD_NUM ),
        .MC_COL_ADDR_WIDTH(MC_COL_ADDR_WIDTH ),
        .MC_ROW_ADDR_WIDTH(MC_ROW_ADDR_WIDTH )
        )mc_ecc_top_u(
        .clk                   (clk                   ),
        .rst_n                 (rst_n                 ),
        .mc_ecc_en             (mc_ecc_en             ),
        .axi2mc_data           (wdata                 ),
        .frame2array_data      (ecc_encode_data       ),
        .array2frame_data_vld  (mc_rvalid             ),
        .array2frame_data      (mc_rdata[0+:MC_DATA_WIDTH+MC_ECC_CHK_WIDTH-6]),
        .array2frame_addr      (frame_raddr           ),
        .mc2axi_data           (ecc_decode_rdata[MC_DATA_WIDTH-1:0]),
        .mc2axi_data_vld       (ecc_decode_rvalid     ),
        .mc2axi_rrsp           (ecc_decode_rresp      ),
        .mc_ecc_ce_th          (mc_ecc_ce_th          ),
        .mc_ecc_ce_int_clr     (mc_ecc_ce_int_clr     ),
        .mc_ecc_ce_overflow_int(mc_ecc_ce_overflow_int),
        .mc_ecc_ce_cnt         (mc_ecc_ce_cnt         ),
        .mc_ecc_ce_addr        (mc_ecc_ce_addr        ),
        .mc_ecc_ce_addr_vld    (mc_ecc_ce_addr_vld    ),
        .mc_ecc_uce_int_clr    (mc_ecc_uce_int_clr    ),
        .mc_ecc_uce_int        (mc_ecc_uce_int        ),
        .mc_ecc_uce_cnt        (mc_ecc_uce_cnt        ),
        .mc_ecc_uce_addr_vld   (mc_ecc_uce_addr_vld   ),
        .mc_ecc_uce_addr       (mc_ecc_uce_addr       )
    );

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        check_bit_reg0 <= 'd0;
        check_bit_reg1 <= 'd0;
    end
    else begin
        check_bit_reg0 <= mc_rdata[MC_DATA_WIDTH+:MC_ECC_CHK_WIDTH];
        check_bit_reg1 <= check_bit_reg0;
    end
end

assign ecc_decode_rdata[MC_DATA_WIDTH+:MC_ECC_CHK_WIDTH] = mc_ecc_en ? check_bit_reg1 : check_bit_reg0;

sync_fifo_aux #(
        .DEPTH     (16               ),
        .DATA_WIDTH(MC_ERR_ADDR_WIDTH),
        .FWFT      (1                )
    )raddr_fifo(
        .clk  (clk             ),
        .rst_n(rst_n           ),
        .wr_en(m_hub_frame_vld && m_hub_frame_rdy && ~rw_flag),
        .rd_en(mc_rvalid && ~raddr_fifo_empty),
        .din  ({bank_addr,row_addr,col_addr}),
        .dout (frame_raddr     ),
        .empty(raddr_fifo_empty),
        .full (),
        .afull()
    );














endmodule
