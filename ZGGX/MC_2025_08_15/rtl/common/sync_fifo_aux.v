module sync_fifo_aux #(
  parameter DEPTH       = 16,
  parameter DATA_WIDTH  = 32,
  parameter UP_THRES    = DEPTH - 1,
  parameter FWFT        = 1'b1
)(
  //--------clock and reset signal------------------------
  input clk   ,
  input rst_n ,
  //--------fifo port-------------------------------------
  input                       wr_en         ,
  input                       rd_en         ,
  input      [DATA_WIDTH-1:0] din           ,
  output reg [DATA_WIDTH-1:0] dout          ,
  output                      empty         ,
  output                      full          ,
  output                      afull
);

//localparam ADDR_WIDTH = ($clog2(DEPTH) == 0) ? 1: $clog2(DEPTH);
localparam ADDR_WIDTH = (log2(DEPTH) == 0) ? 1: log2(DEPTH);

//----------------------------------------------------------------------------
//reg declare
//----------------------------------------------------------------------------
reg [ADDR_WIDTH-1:0] rd_ptr,wr_ptr;
reg [ADDR_WIDTH:0] fifo_cnt;  // number of data pushed in to buffer  

reg [DATA_WIDTH-1:0] buf_mem [0:DEPTH-1];

//----------------------------------------------------------------------------
//reg calculation
//----------------------------------------------------------------------------
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    fifo_cnt <= 'd0;
  end
  else begin
    if((wr_en && !full) && (rd_en && !empty)) //write and read
      fifo_cnt <= fifo_cnt;
    else if(wr_en && !full)          //write only
      fifo_cnt <= fifo_cnt +1;
    else if(rd_en && !empty)         //read only
      fifo_cnt <= fifo_cnt -1;
    else 
      fifo_cnt <= fifo_cnt;
  end
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    wr_ptr <= 'd0;
    rd_ptr <= 'd0;
  end
  else begin
    if(wr_en && !full)
      wr_ptr <= (wr_ptr < DEPTH -1) ? (wr_ptr +1) : 'd0;

    if(rd_en && !empty)
      rd_ptr <= (rd_ptr < DEPTH -1) ? (rd_ptr +1) : 'd0;
  end
end

integer I;

always @(posedge clk or negedge rst_n)   //write data
begin 
  if (rst_n == 1'b0) begin
    for (I=0;I<DEPTH;I=I+1)
      buf_mem[I] <= 'd0;
  end
  else begin
    if(wr_en && !full)
      buf_mem[wr_ptr] <= din;
  end
end

generate
if (FWFT == 1'b1) begin   //FWFT mode
  always @(*)
  begin
    dout = buf_mem[rd_ptr];
  end
end
else begin                //normal mode
  always @(posedge clk or negedge rst_n)   //read data
  begin
    if (rst_n == 1'b0) begin
      dout <= 0;
    end
    else begin
      if(rd_en && !empty)
        dout <= buf_mem[rd_ptr];
    end
  end
end
endgenerate

//----------------------------------------------------------------------------
//output ctrl signal
//----------------------------------------------------------------------------
assign empty = fifo_cnt == 0;
assign full  = fifo_cnt == DEPTH;
assign afull = fifo_cnt >= UP_THRES;

function integer log2;
input integer value;
begin
    value = value - 1;
    for(log2=0;value>0;log2=log2+1)
        value = value>>1;
end 

endfunction



endmodule
