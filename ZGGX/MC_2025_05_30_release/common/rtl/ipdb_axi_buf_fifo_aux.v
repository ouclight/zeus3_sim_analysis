//----------------------------------------------------------------------------
//  FILE      : ipdb_axi_buf_fifo_aux.v
//  LANGUAGE  : verilog-2001
//  AUTHOR    : Liu Qi
//  DATE      : 2019-11-20
//  FUNCTION  : 
//    axi stream buf
//
//                    ________
//                   |        |
//    s_valid   ---->|        |---->   m_valid
//    s_ready   <----|   BUF  |<----   m_ready
//                   |  ____  |
//    s_data    ---->| |FIFO| |---->   m_data
//                   | |____| |
//                   |________|
//
//  HISTORY   :
//  
//  TEST FILE          :
//  Test stimulus file :
//  Test output file   :
//  
//  Copyright © 2019 UniIC Corp, All rights reserved
//----------------------------------------------------------------------------
module ipdb_axi_buf_fifo_aux #(
  parameter DATA_WIDTH  = 32,
  parameter DEPTH       = 2
) (
  //--------clk and rst_n signal--------------------------
  input                   clk     ,
  input                   rst_n   ,
  //--------soft reset signal-----------------------------
  input                   abort   ,
  //--------axi slave port--------------------------------
  input                   s_valid ,
  output                  s_ready ,
  input  [DATA_WIDTH-1:0] s_data  ,
  //--------axi master port-------------------------------
  output                  m_valid ,
  input                   m_ready ,
  output [DATA_WIDTH-1:0] m_data
    );
    
//----------------------------------------------------------------------------
//reg and wire declare
//----------------------------------------------------------------------------
wire  wr_en;
wire  rd_en;
wire  full ;
wire  empty;

//----------------------------------------------------------------------------
//s_axi -> FIFO
//----------------------------------------------------------------------------
assign wr_en   = s_valid && s_ready;
assign rd_en   = ~empty && m_ready;
assign s_ready = ~full ;
assign m_valid = ~empty;

//----------------------------------------------------------------------------
//Instance fifo
//----------------------------------------------------------------------------
sync_fifo_aux 
    #(
    .DEPTH     (DEPTH       ),
    .DATA_WIDTH(DATA_WIDTH  )
    )
sync_fifo_aux_u
    (
    .clk        (clk        ),
    .rst_n      (rst_n      ),
    .wr_en      (wr_en      ),
    .rd_en      (rd_en      ),
    .din        (s_data     ),
    .dout       (m_data     ),
    .empty      (empty      ),
    .full       (full       ),
    .afull      (           )
    );

//----------------------------------------------------------------------------
//end code
//----------------------------------------------------------------------------
endmodule

