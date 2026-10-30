
`ifndef ARRAY_AGENT_IF_SV
`define ARRAY_AGENT_IF_SV

interface array_agent_if(input clk,input rst_n); 
    
    logic   [`BANK_ADDR_WIDTH-1:0]      bnksel_n    ;
    logic   [`ROW_ADDR_WIDTH-1:0]       gradd_n     ;
    logic   [`BANK_ADDR_WIDTH-1:0]      gcas_wr     ;     
    logic                               gcas_wr_b0     ;     
    logic                               gcas_wr_b1     ;     
    logic   [`BANK_ADDR_WIDTH-1:0]      gcas_rd     ;
    logic                               gcas_rd_b0     ;     
    logic                               gcas_rd_b1     ;     
    logic   [`COLUMN_ADDR_WIDTH-1:0]    gcadd       ;     
    //logic                               wrrdy_n     ; 
    wire    [`ARRAY_DATA_WIDTH-1:0]     wdl         ;  
    logic                               wdl_oe      ;
    logic                               rdrdy_n     ; 
    wire                                rdrdy_b0    ; 
    wire                                rdrdy_b1    ; 
    wire    [`ARRAY_DATA_WIDTH-1:0]     rdl         ;
    wire    [`ARRAY_DATA_WIDTH-1:0]     rdl_b0         ;
    wire    [`ARRAY_DATA_WIDTH-1:0]     rdl_b1         ;
    wire    [`ARRAY_DATA_WIDTH-1:0]     rwdl        ;

    logic[1:0]                          bnksel_dly[4];
    logic[1:0]                          bank_sel    ;

`ifdef WITHOUT_PHY
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
`endif
    assign bank_sel         =   (bnksel_n == 2'b10)     ? 2'd0  :
                                (bnksel_n == 2'b01)     ? 2'd1  : 0;
endinterface : array_agent_if

`endif // ARRAY_AGENT_IF_SV
