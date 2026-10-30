module wl_vmc_top_aux #(
    parameter   AR_DST_ID_WIDTH  = 13                   
) (

//  input                                         clk_main       ,
//  input                                         rst_main_n     ,

  input         [AR_DST_ID_WIDTH-1:0]           i_org_id       ,
  output        [AR_DST_ID_WIDTH-1:0]           o_remap_id     ,
  input                                         s_vmc_en       ,
  input         [AR_DST_ID_WIDTH*64-1:0]        remap_addr     ,                 
  output        [2*AR_DST_ID_WIDTH-1:0]         o_vmc_mon_all          
);

wire   [AR_DST_ID_WIDTH-1:0  ]        i_org_id_tmp; 
wire   [AR_DST_ID_WIDTH-1:0  ]        o_remap_id_tmp1;
wire   [AR_DST_ID_WIDTH-1:0  ]        o_remap_id_tmp2;
wire   [AR_DST_ID_WIDTH-1:0  ]        o_remap_id_tmp3;
wire   [AR_DST_ID_WIDTH-1:0  ]        o_remap_id_tmp4;
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
assign o_remap_id_tmp1 = remap_ID1(i_org_id,s_vmc_en,remap_addr);
assign o_remap_id_tmp2 = remap_ID2(i_org_id,s_vmc_en,remap_addr)-i_org_id;
assign o_remap_id_tmp3 = remap_ID3(i_org_id,s_vmc_en,remap_addr)-i_org_id;
assign o_remap_id_tmp4 = remap_ID4(i_org_id,s_vmc_en,remap_addr)-i_org_id;
assign o_remap_id      = o_remap_id_tmp4+o_remap_id_tmp3+o_remap_id_tmp2+o_remap_id_tmp1;

//----------------------------------------------------------------------------
//remap MSB 9bit of araddr
//----------------------------------------------------------------------------

function automatic [AR_DST_ID_WIDTH-1:0] remap_ID1;
  input [AR_DST_ID_WIDTH-1:0]           org_id     ;
  input                                 s_vmc_en   ;
  input [AR_DST_ID_WIDTH*64-1:0]        remap_addr ; 
  integer I;
begin
  remap_ID1 = org_id;
  if (s_vmc_en) begin
    for(I=0;I<20;I=I+1) begin
      remap_ID1 = remap_ID1 + ((org_id >= remap_addr[I*AR_DST_ID_WIDTH +: AR_DST_ID_WIDTH]) ? 1'b1: 1'b0);
    end
  end
end
endfunction

function automatic [AR_DST_ID_WIDTH-1:0] remap_ID2;
  input [AR_DST_ID_WIDTH-1:0]           org_id     ;
  input                                 s_vmc_en   ; 
  input [AR_DST_ID_WIDTH*64-1:0]        remap_addr ; 

  integer k;
begin
  remap_ID2 = org_id;
  if (s_vmc_en) begin
    for(k=20;k<40;k=k+1) begin
      remap_ID2 = remap_ID2 + ((org_id >= remap_addr[k*AR_DST_ID_WIDTH +: AR_DST_ID_WIDTH]) ? 1'b1: 1'b0);
    end
  end
end
endfunction

function automatic [AR_DST_ID_WIDTH-1:0] remap_ID3;
  input [AR_DST_ID_WIDTH-1:0]           org_id     ;
  input                                 s_vmc_en   ;  
  input [AR_DST_ID_WIDTH*64-1:0]        remap_addr ; 

  integer j;
begin
  remap_ID3 = org_id;
  if (s_vmc_en) begin
    for(j=40;j<60;j=j+1) begin
      remap_ID3 = remap_ID3 + ((org_id >= remap_addr[j*AR_DST_ID_WIDTH +: AR_DST_ID_WIDTH]) ? 1'b1: 1'b0);
    end
  end
end
endfunction

function automatic [AR_DST_ID_WIDTH-1:0] remap_ID4;
  input [AR_DST_ID_WIDTH-1:0]           org_id     ;
  input                                 s_vmc_en   ;  
  input [AR_DST_ID_WIDTH*64-1:0]        remap_addr ; 
  

  integer j;
begin
  remap_ID4 = org_id;
  if (s_vmc_en) begin
    for(j=60;j<64;j=j+1) begin
      remap_ID4 = remap_ID4 + ((org_id >= remap_addr[j*AR_DST_ID_WIDTH +: AR_DST_ID_WIDTH]) ? 1'b1: 1'b0);
  end
  end
end
endfunction

endmodule
