module apb2reg_mc_pe_top_aux_cfg_if #(
    parameter APB_ADDR_WIDTH = 11,
    parameter APB_DATA_WIDTH = 32
    )
    (
    // common input ports 
    input                               pclk,
    input                               presetn,
    input                               psel,
    input                               penable,
    input    [APB_ADDR_WIDTH-1:0]       paddr,
    input                               pwrite,
    input    [APB_DATA_WIDTH-1:0]       pwdata,

    // special input port 
    // register name : mc_id_reg , address:0x0
    input  [31:0]                        mc_id_i,// read only signal
    // register name : mc_page_status_reg , address:0x4
    input                        mc_page_status_i,// read only signal
    // register name : hang_timeout_status_reg , address:0x8
    input                        hang_timeout_status_i,// read only signal
 
    // W1C output ports
    // register name : hang_timeout_clr_reg , address:0x10
    output reg hang_timeout_clr_o,

    // special output ports
    // register name : hang_timeout_mask_reg , address:0xc
    output reg hang_timeout_mask_o,
    // register name : hang_timeout_en_reg , address:0x14
    output reg hang_timeout_en_o,
    // common output ports 
    output reg pslverr,
    output reg [APB_DATA_WIDTH-1:0]  prdata
    );

    //-------- regs --------
    //-------  Wires ---------
    wire apb_write_sel ;
    wire apb_sel ;
    wire apb_read_sel ;
    //read and write enable signals
    assign apb_write_sel   = psel &&  pwrite && (penable);
    assign apb_read_sel    = psel && (~pwrite) && (~penable);
    assign apb_sel         = psel && (~penable);

    //pslverr 
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h0)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h4)) begin
            pslverr <= 1'h0;
        end
        else if (apb_read_sel && (paddr == 11'h8)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'hc)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h10)) begin
            pslverr <= 1'h0;
        end
        else if (apb_sel && (paddr == 11'h14)) begin
            pslverr <= 1'h0;
        end
        else begin
            pslverr <= 1'h1;
        end
    end
    // register name : hang_timeout_mask_reg , address:0xc
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_mask_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 11'hc)) begin
            hang_timeout_mask_o <= pwdata[0];
        end
    end
    // register name : hang_timeout_en_reg , address:0x14
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_en_o <= 1'b1;
        end
        else if (apb_write_sel && (paddr == 11'h14)) begin
            hang_timeout_en_o <= pwdata[0];
        end
    end
    // read register
    //when read a WO signal, will give it 0.
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0)
            prdata <= {APB_DATA_WIDTH{1'b0}};// default value is 0
        else
            if(apb_read_sel) begin
                case(paddr)
                11'h0: //register name:mc_id_reg,address:0x0
                prdata <= {mc_id_i};
                11'h4: //register name:mc_page_status_reg,address:0x4
                prdata <= {31'h0,mc_page_status_i};
                11'h8: //register name:hang_timeout_status_reg,address:0x8
                prdata <= {31'h0,hang_timeout_status_i};
                11'hc: //register name:hang_timeout_mask_reg,address:0xc
                prdata <= {31'h0,hang_timeout_mask_o};
                11'h10: //register name:hang_timeout_clr_reg,address:0x10
                prdata <= {31'h0,hang_timeout_clr_o};
                11'h14: //register name:hang_timeout_en_reg,address:0x14
                prdata <= {31'h0,hang_timeout_en_o};
            default:
                prdata <= {APB_DATA_WIDTH{1'b1}}; //  means read a non-exist address
            endcase
        end
        else begin
            prdata <= {APB_DATA_WIDTH{1'b0}};
        end
    end
    // register name : hang_timeout_clr_reg , address:0x10
    always @(posedge pclk or negedge presetn)
    begin
        if(presetn == 1'b0) begin
            hang_timeout_clr_o <= 1'b0;
        end
        else if (apb_write_sel && (paddr == 11'h10)) begin
            hang_timeout_clr_o <= pwdata[0];
        end
        else
            hang_timeout_clr_o <= 1'b0;

    end
endmodule
// Below is the information of "mc_pe_top_aux" in register sheet, can use as a reference if have unexpected issues in this verilog file.
// 0x0___(mc_id_reg)___(mc_id)___0___32___RO___0x0
// 0x4___(mc_page_status_reg)___(mc_page_status)___0___1___RO___0x1
// 0x4___(mc_page_status_reg)___(reserved)___1___31___NA___reserved
// 0x8___(hang_timeout_status_reg)___(hang_timeout_status)___0___1___RO___0x0
// 0x8___(hang_timeout_status_reg)___(reserved)___1___31___NA___NA
// 0xc___(hang_timeout_mask_reg)___(hang_timeout_mask)___0___1___RW___0x1
// 0xc___(hang_timeout_mask_reg)___(reserved)___1___31___NA___NA
// 0x10___(hang_timeout_clr_reg)___(hang_timeout_clr)___0___1___W1C___0x0
// 0x10___(hang_timeout_clr_reg)___(reserved)___1___31___NA___NA
// 0x14___(hang_timeout_en_reg)___(hang_timeout_en)___0___1___RW___0x1
// 0x14___(hang_timeout_en_reg)___(reserved)___1___31___NA___NA
