module bl_vmc_top_aux #(
    parameter   AR_DST_ID_WIDTH  = 8                   
) (

//  input                                         clk_main       ,
//  input                                         rst_main_n     ,

  input         [AR_DST_ID_WIDTH-1-1:0]         i_org_id       ,
  output        [AR_DST_ID_WIDTH-1:0]           o_remap_id     ,
  input                                         s_vmc_en       ,
  input         [AR_DST_ID_WIDTH*2-1:0]         remap_addr     ,
  output        [2*AR_DST_ID_WIDTH-2:0]         o_vmc_mon_all               

);

wire   [AR_DST_ID_WIDTH-1-1:0  ]        i_org_id_tmp; 
//wire   [AR_DST_ID_WIDTH-1:0  ]        o_remap_id_tmp;
//wire                                  vmc_en_main;  

assign  i_org_id_tmp  = i_org_id;
assign  o_vmc_mon_all = {o_remap_id,i_org_id_tmp};

/*
wl_sync2dff_aux                                                  
u_wl_sync2dff(                                               
    .clk(clk_main                  ),                        
    .rst_n(rst_main_n              ),                        
    .din(s_vmc_en                  ),                        
    .dout(vmc_en_main              )       
);
*/
assign o_remap_id = remap_ID(i_org_id,s_vmc_en,remap_addr);

//----------------------------------------------------------------------------
//remap MSB 9bit of araddr
//----------------------------------------------------------------------------

function automatic [AR_DST_ID_WIDTH-1:0] remap_ID;
  input [AR_DST_ID_WIDTH-1-1:0] org_id    ;
  input                         s_vmc_en  ;
  input [AR_DST_ID_WIDTH*2-1:0] remap_addr;
  integer I;
begin
  remap_ID = {1'b0,org_id};
  if (s_vmc_en) begin
    for(I=0;I<2;I=I+1) begin
      remap_ID = remap_ID + (({1'b0,org_id} >= remap_addr[I*AR_DST_ID_WIDTH +: AR_DST_ID_WIDTH]) ? 1'b1: 1'b0);
  end
end
end
endfunction



endmodule
