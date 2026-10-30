module dram_trim_pulse2pulse #(
  parameter IN_RST_VALUE  = 1'b0 ,
  parameter OUT_RST_VALUE = 1'b0 )(
  //-------------clock_1 domain -------------------------------
  input clk1,
  input rst1_n ,
  input in,
  //-------------clock_2 domain -------------------------------
  input clk2,
  input rst2_n ,
  output reg out
);

reg in_dl;
reg toggle_reg;
//reg [2:0] toggle_reg_dl;
wire toggle_reg_sync;
reg  toggle_reg_sync_dl;

dram_trim_wl_sync2dff  
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
always @(posedge clk1 or negedge rst1_n)
begin
  if (rst1_n == 1'b0) begin
    in_dl <= IN_RST_VALUE;
    toggle_reg <= 1'b0;
  end
  else begin
    in_dl <= in;
    if ({in_dl, in} == {IN_RST_VALUE, ~IN_RST_VALUE})
      toggle_reg <= ~toggle_reg;
  end
end

//clock_2 domain
always @(posedge clk2 or negedge rst2_n)
begin
  if (rst2_n == 1'b0) begin
    out <= OUT_RST_VALUE;
    toggle_reg_sync_dl <= 1'b0;
  end
  else begin
    toggle_reg_sync_dl <= toggle_reg_sync;
    //out <= (toggle_reg_dl[2] ^ toggle_reg_dl[1]) ^ OUT_RST_VALUE;
    out <= (toggle_reg_sync_dl ^ toggle_reg_sync) ^ OUT_RST_VALUE;
  end
end

endmodule
