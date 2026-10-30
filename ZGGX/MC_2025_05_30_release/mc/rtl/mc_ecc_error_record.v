module mc_ecc_error_record #(
    parameter   MC_CE_RECORD_NUM    = 16,
    parameter   MC_UCE_RECORD_NUM   = 4,
    parameter   MC_COL_ADDR_WIDTH   = 7,
    parameter   MC_ROW_ADDR_WIDTH   = 13,
    parameter   MC_ERR_ADDR_WIDTH   = MC_COL_ADDR_WIDTH+MC_ROW_ADDR_WIDTH+1
)(
    input                                                   clk                     ,
    input                                                   rst_n                   ,
    input                                                   mc_ecc_ce_vld           ,
    input                                                   mc_ecc_uce_vld          ,
    input       [MC_ERR_ADDR_WIDTH-1:0]                     mc_ecc_addr             ,
    input       [4:0]                                       mc_ecc_ce_th            ,
    input                                                   mc_ecc_ce_int_clr       ,
    output  reg                                             mc_ecc_ce_overflow_int  ,
    output  reg [4:0]                                       mc_ecc_ce_cnt           ,
    output  reg [MC_CE_RECORD_NUM*MC_ERR_ADDR_WIDTH-1:0]    mc_ecc_ce_addr          ,
    output  reg [MC_CE_RECORD_NUM-1:0]                      mc_ecc_ce_addr_vld      ,
    input                                                   mc_ecc_uce_int_clr      ,
    output  reg                                             mc_ecc_uce_int          ,
    output  reg [2:0]                                       mc_ecc_uce_cnt          ,
    output  reg [MC_UCE_RECORD_NUM-1:0]                     mc_ecc_uce_addr_vld     ,
    output  reg [MC_UCE_RECORD_NUM*MC_ERR_ADDR_WIDTH-1:0]   mc_ecc_uce_addr         
);

genvar  II;
integer i;

localparam  CE_INDEX_WIDTH = $clog2(MC_CE_RECORD_NUM);
localparam  UCE_INDEX_WIDTH = $clog2(MC_UCE_RECORD_NUM);
//======================================================================
//ECC CE Process
//======================================================================

wire    [MC_CE_RECORD_NUM-1:0]    mc_ecc_ce_index;
reg                             mc_ecc_ce_addr_hit;

mc_leadingone
#(
    .FIND_ONE  (0                   ),
    .DATA_W    (MC_CE_RECORD_NUM    ),
    .INDEX_W   (CE_INDEX_WIDTH      )
)mc_ce_leadingone_u
(
    .data_in        (mc_ecc_ce_addr_vld ),
    .first_one_idx  (                   ),
    .data_out       (mc_ecc_ce_index    ) 
);

always @(*) 
begin
    mc_ecc_ce_addr_hit = 1'b0;
    for(i=0;i<MC_CE_RECORD_NUM;i=i+1) begin:judge_ce_addr
        if({mc_ecc_ce_addr_vld[i],mc_ecc_ce_addr[i*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH]} == {1'b1,mc_ecc_addr})
            mc_ecc_ce_addr_hit = 1'b1;
    end
end

generate
    for(II=0;II<MC_CE_RECORD_NUM;II=II+1) begin: ce_record_status
        always @(posedge clk or negedge rst_n) begin
            if(rst_n == 1'b0) begin
                mc_ecc_ce_addr_vld[II] <= 1'b0;
                mc_ecc_ce_addr[II*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] <= {MC_ERR_ADDR_WIDTH{1'b1}};
            end
            else if(mc_ecc_ce_int_clr) begin
                mc_ecc_ce_addr_vld[II] <= 1'b0;
                mc_ecc_ce_addr[II*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] <= {MC_ERR_ADDR_WIDTH{1'b1}};
            end
            else if(!mc_ecc_ce_addr_hit && mc_ecc_ce_vld && (mc_ecc_ce_index[II])) begin
                mc_ecc_ce_addr_vld[II] <= 1'b1;
                mc_ecc_ce_addr[II*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] <= mc_ecc_addr;
            end
        end
    end
endgenerate

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mc_ecc_ce_cnt <= 'd0;
    else if(mc_ecc_ce_int_clr)
        mc_ecc_ce_cnt <= 'd0;
    else if(!mc_ecc_ce_addr_hit && mc_ecc_ce_vld && (|mc_ecc_ce_index)) begin
        if(mc_ecc_ce_cnt != 5'b11111)
            mc_ecc_ce_cnt <= mc_ecc_ce_cnt + 1'b1;
    end
end


always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mc_ecc_ce_overflow_int  <= 1'b0;
    else if(mc_ecc_ce_int_clr)
        mc_ecc_ce_overflow_int  <= 1'b0;
    else if(mc_ecc_ce_cnt >= mc_ecc_ce_th)
        mc_ecc_ce_overflow_int <= 1'b1;
end

//======================================================================
//ECC UCE Process
//======================================================================

wire    [MC_UCE_RECORD_NUM-1:0]   mc_ecc_uce_index;
reg                             mc_ecc_uce_addr_hit;

mc_leadingone
#(
    .FIND_ONE  (0                   ),
    .DATA_W    (MC_UCE_RECORD_NUM   ),
    .INDEX_W   (UCE_INDEX_WIDTH     )
)mc_uce_leadingone_u
(
    .data_in        (mc_ecc_uce_addr_vld ),
    .first_one_idx  (                   ),
    .data_out       (mc_ecc_uce_index    ) 
);

always @(*) 
begin
    mc_ecc_uce_addr_hit = 1'b0;
    for(i=0;i<MC_UCE_RECORD_NUM;i=i+1) begin:judge_uce_addr
        if({mc_ecc_uce_addr_vld[i],mc_ecc_uce_addr[i*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH]} == {1'b1,mc_ecc_addr})
            mc_ecc_uce_addr_hit = 1'b1;
    end
end

generate
    for(II=0;II<MC_UCE_RECORD_NUM;II=II+1) begin: uce_record_status
        always @(posedge clk or negedge rst_n) begin
            if(rst_n == 1'b0) begin
                mc_ecc_uce_addr_vld[II] <= 1'b0;
                mc_ecc_uce_addr[II*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] <= {MC_ERR_ADDR_WIDTH{1'b1}};
            end
            else if(mc_ecc_uce_int_clr) begin
                mc_ecc_uce_addr_vld[II] <= 1'b0;
                mc_ecc_uce_addr[II*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] <= {MC_ERR_ADDR_WIDTH{1'b1}};
            end
            else if(!mc_ecc_uce_addr_hit && mc_ecc_uce_vld && (mc_ecc_uce_index[II])) begin
                mc_ecc_uce_addr_vld[II] <= 1'b1;
                mc_ecc_uce_addr[II*MC_ERR_ADDR_WIDTH+:MC_ERR_ADDR_WIDTH] <= mc_ecc_addr;
            end
        end
    end
endgenerate


always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mc_ecc_uce_cnt <= 'd0;
    else if(mc_ecc_uce_int_clr)
        mc_ecc_uce_cnt <= 'd0;
    else if(!mc_ecc_uce_addr_hit && mc_ecc_uce_vld && (|mc_ecc_uce_index)) begin
        if(mc_ecc_uce_cnt != 3'b111)
            mc_ecc_uce_cnt <= mc_ecc_uce_cnt + 1'b1;
    end
end


always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mc_ecc_uce_int  <= 1'b0;
    else if(mc_ecc_uce_int_clr)
        mc_ecc_uce_int  <= 1'b0;
    else if(mc_ecc_uce_cnt >= 2'd1)
        mc_ecc_uce_int <= 1'b1;
end

endmodule
