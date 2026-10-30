module mc_leadingone
#(
parameter FIND_ONE=0,
parameter DATA_W = 32,
parameter INDEX_W= 5
)
(
input      [DATA_W-1   :0] data_in,
output     [INDEX_W-1  :0] first_one_idx,
output     [DATA_W-1   :0] data_out 
);

//wire   [DATA_W-1   :0] data_in_m;
//wire   [DATA_W-1   :0] first_one_onehot_n;
//integer x;
//
//assign data_in_m = {(data_in[DATA_W-1:1]|data_in_m[DATA_W-2:0]),data_in[0]};
//assign first_one_onehot_n = ~data_in_m;
//
//always@(*) begin
//    first_one_idx = {INDEX_W{1'b0}};
//    for(x=0;x<DATA_W;x=x+1)
//        first_one_idx = first_one_idx + first_one_onehot_n[x];
//end
wire   [DATA_W-1   :0] data_in_m;
wire   [DATA_W-1   :0] data_out_m;
wire [INDEX_W :0] enc;
genvar i;

generate
for(i=0;i<DATA_W;i=i+1) begin: reverse
    assign data_in_m[i] = data_in[DATA_W-1-i];
    assign data_out[i]  = data_out_m[DATA_W-1-i];
end
endgenerate

generate
if(FIND_ONE==0) begin: leading_zero
DW_lod
#(
    .a_width    ( DATA_W    ) 
)
DW_lod_u
(
    .a          ( data_in_m ),
    .enc        ( enc       ),
    .dec        ( data_out_m) 
);
end
else begin: leading_one
DW_lzd
#(
    .a_width    ( DATA_W    ) 
)
DW_lzd_u
(
    .a          ( data_in_m ),
    .enc        ( enc       ),
    .dec        ( data_out_m) 
);
end
endgenerate

assign first_one_idx = enc[INDEX_W-1 :0];

endmodule

