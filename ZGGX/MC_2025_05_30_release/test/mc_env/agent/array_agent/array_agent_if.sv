//=============================================================================
// iuvm_tb_gen copyright (c) by UNIIC Inc.
//=============================================================================
// Module   : mc
// Filename : array_agent_if.sv
// Author   : kenan
// Email    : kenan@uniic.com
// Date     : Mon Nov 11 10:46:28 2024
//=============================================================================
// Description:
//=============================================================================

`ifndef ARRAY_AGENT_IF_SV
`define ARRAY_AGENT_IF_SV

interface array_agent_if(input clk,input rst_n); 
    
    logic[1:0]                          bnksel_n    ;
    logic   [`ROW_ADDR_WIDTH-1:0]       gradd_n     ;
    logic                               gcas_wr     ;     
    logic                               gcas_wr_b0     ;     
    logic                               gcas_wr_b1     ;     
    logic                               gcas_rd     ;
    logic                               gcas_rd_b0     ;     
    logic                               gcas_rd_b1     ;     
    logic   [`COLUMN_ADDR_WIDTH-1:0]    gcadd       ;     
    //logic                               wrrdy_n     ; 
    wire    [`ARRAY_DATA_WIDTH-1:0]     wdl         ;  
    logic                               wdl_oe      ;
    wire                                rdrdy_n     ; 
    wire                                rdrdy_b0    ; 
    wire                                rdrdy_b1    ; 
    wire    [`ARRAY_DATA_WIDTH-1:0]     rdl         ;
    wire    [`ARRAY_DATA_WIDTH-1:0]     rdl_b0         ;
    wire    [`ARRAY_DATA_WIDTH-1:0]     rdl_b1         ;
    wire    [`ARRAY_DATA_WIDTH-1:0]     rwdl        ;

    logic[1:0]                          bnksel_dly[4];

    always@(posedge clk or rst_n) begin
        if(!rst_n) begin
            bnksel_dly[0]      <= 2'b00;
            bnksel_dly[1]      <= 2'b00;
            bnksel_dly[2]      <= 2'b00;
            bnksel_dly[3]      <= 2'b00;
        end
        else begin
            bnksel_dly[0]   <= bnksel_n;
            bnksel_dly[1]   <= bnksel_dly[0];
            bnksel_dly[2]   <= bnksel_dly[1];
            bnksel_dly[3]   <= bnksel_dly[2];
        end
    end
assign rdrdy_n          =   bnksel_dly[3] == 2'b00  ?   'b1        :
                            bnksel_dly[3] == 2'b10  ?   rdrdy_b0   :
                            bnksel_dly[3] == 2'b01  ?   rdrdy_b1   :
                            'b1;
assign  rdl             =   bnksel_dly[3] == 2'b00  ?   'b0        :
                            bnksel_dly[3] == 2'b10  ?   rdl_b0     :
                            bnksel_dly[3] == 2'b01  ?   rdl_b1     :
                            'bz;
assign  #0ps gcas_wr_b0      =   bnksel_n[0] == 1'b0  ? gcas_wr : 1'b0;
assign  #0ps gcas_wr_b1      =   bnksel_n[1] == 1'b0  ? gcas_wr : 1'b0;
assign  #0ps gcas_rd_b0      =   bnksel_dly[0] == 2'b10  ? gcas_rd : 1'b0;
assign  #0ps gcas_rd_b1      =   bnksel_dly[0] == 2'b01  ? gcas_rd : 1'b0;
endinterface : array_agent_if

`endif // ARRAY_AGENT_IF_SV
