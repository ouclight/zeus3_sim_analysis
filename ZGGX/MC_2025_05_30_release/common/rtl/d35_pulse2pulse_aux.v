//----------------------------------------------------------------------------
//  FILE      : d35_pulse2pulse_aux.v
//  LANGUAGE  : verilog-2001
//  AUTHOR    : Han Yang
//  DATE      : 2025-1-14
//  FUNCTION  : pulse in clock_1 domain -> one cycle pulse in clock_2 domain
//              NOTE: used common reset to simplify design. Or clock_2 reset
//              should release first.
//  HISTORY   :
//  
//  TEST FILE          :
//  Test stimulus file :
//  Test output file   :
//  
//  Copyright © 2019 UniIC Corp, All rights reserved
//----------------------------------------------------------------------------

module d35_pulse2pulse_aux #(
  parameter IN_RST_VALUE  = 1'b0,
  parameter SPREAD_NUM    = 6'h4,
  parameter OUT_RST_VALUE = 1'b0 )(
  //-------------clock_1 domain -------------------------------
  input clk1,
  input rst1_n,
  input in,
  //-------------clock_2 domain -------------------------------
  input clk2,
  input rst2_n,
  output reg out
);

reg  in_dl;
reg  toggle_reg;
wire toggle_reg_sync;
reg  toggle_reg_sync_dl;

reg [5:0] toggle_cnt;

wl_sync2dff_aux
    #(
     .WIDTH         (1                  )
     )
wl_sync2dff_u0
     (
     .clk           (clk2               ),
     .rst_n         (rst2_n             ),
     .din           (toggle_reg         ),
     .dout          (toggle_reg_sync    )
     );

//clock_1 domain
always @ (posedge clk1 or negedge rst1_n)
    if(!rst1_n)
        toggle_cnt <= 6'h3f;
    else if({in_dl, in} == {IN_RST_VALUE, ~IN_RST_VALUE})
        toggle_cnt <= 6'h0;
    else if(toggle_cnt == SPREAD_NUM)
        toggle_cnt <= 6'h3f;
    else if(&toggle_cnt)
        toggle_cnt <= toggle_cnt;
    else
        toggle_cnt <= toggle_cnt + 1'b1;

always @(posedge clk1 or negedge rst1_n)
begin
  if (rst1_n == 1'b0) begin
    in_dl <= IN_RST_VALUE;
  end
  else begin
    in_dl <= in;
  end
end

always @(posedge clk1 or negedge rst1_n)
begin
  if (rst1_n == 1'b0)
    toggle_reg <= 1'b0;
  else if(toggle_cnt <= SPREAD_NUM)
    toggle_reg <= 1'b1;
  else
    toggle_reg <= 1'b0;
end

//clock_2 domain
always @(posedge clk2 or negedge rst2_n)
begin
  if (rst2_n == 1'b0) begin
    toggle_reg_sync_dl <= 1'b0;
  end
  else begin
    toggle_reg_sync_dl <= toggle_reg_sync;
  end
end

always @(posedge clk2 or negedge rst2_n)
begin
  if (rst2_n == 1'b0)
    out <= OUT_RST_VALUE;
  else if({toggle_reg_sync_dl, toggle_reg_sync} == {IN_RST_VALUE, ~IN_RST_VALUE})
    out <= ~OUT_RST_VALUE;
  else
    out <= OUT_RST_VALUE;
end

endmodule
