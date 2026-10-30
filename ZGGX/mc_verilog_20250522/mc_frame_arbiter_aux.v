module mc_frame_arbiter_aux #(
  parameter AXI_SLV_NUM   = 5 ,
  parameter TDATA_WIDTH   = 256+10+21+3,//256bit data,10bit checkbit
  parameter ARRAY_DATA_WIDTH = 256+10

)(
  //-------------clock and reset signal------------------------
  input                                          clk               ,
  input                                          rst_n             ,
  //-------------axi slave-------------------------------------
  input         [AXI_SLV_NUM-1:0]                s_tvalid          ,
  output        [AXI_SLV_NUM-1:0]                s_tready          ,
  input         [AXI_SLV_NUM*TDATA_WIDTH-1:0]    s_tdata           ,
  //-------------axi master------------------------------------
  output                                         m_tvalid          ,
  input                                          m_tready          ,
  output reg    [TDATA_WIDTH-1:0]                m_tdata           ,

  input                                          array_rvalid      ,
  input         [ARRAY_DATA_WIDTH-1:0]           array_rdata       ,

  output reg                                     bist_path_rvalid  ,
  output reg    [ARRAY_DATA_WIDTH-1:0]           bist_path_rdata   ,          

  output reg                                     bist_csl_rvalid   ,
  output reg    [ARRAY_DATA_WIDTH-1:0]           bist_csl_rdata    ,      
  
  output reg                                     bist_wl_rvalid    ,
  output reg    [ARRAY_DATA_WIDTH-1:0]           bist_wl_rdata     ,     
 
  output reg                                     func_rvalid       ,
  output reg    [ARRAY_DATA_WIDTH-1:0]           func_rdata        ,

  output reg                                     rescan_rvalid     ,
  output reg    [ARRAY_DATA_WIDTH-1:0]           rescan_rdata        

  
);


genvar II;
integer J;
reg         [AXI_SLV_NUM-1:0]     port_sel            ;
reg         [AXI_SLV_NUM-1:0]     port_choose_array   ;
reg         [AXI_SLV_NUM-1:0]     port_choose_array_w ;
//---------------gen port sel--------------//
always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)
        port_sel <= {AXI_SLV_NUM{1'b0}};
    else if(s_tvalid[0] && s_tready[0])
        port_sel <= 5'b00001;
    else if(s_tvalid[1] && s_tready[1])
        port_sel <= 5'b00010;
    else if(s_tvalid[2] && s_tready[2])
        port_sel <= 5'b00100;
    else if(s_tvalid[3] && s_tready[3])
        port_sel <= 5'b01000;
    else if(s_tvalid[4] && s_tready[4])
        port_sel <= 5'b10000;

    else 
        port_sel <= port_sel;
end
//----------------------------------------------------------------------------
//AXI master handshake
//----------------------------------------------------------------------------



assign m_tvalid = | (port_choose_array & s_tvalid);
assign s_tready = port_choose_array & {AXI_SLV_NUM{m_tready}};


always @(*) begin
    if (AXI_SLV_NUM == 1) begin       //cal prio, always choose SLV[0]
       port_choose_array_w[0] = 1'b1;
   end
    else begin                        //cal prio, use round-robin arbitor
       port_choose_array_w = cal_port_choose_w(port_choose_array, s_tvalid, m_tready);
   end
end

  //update port_choose
  always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0) begin
      port_choose_array <= 'd8;
    end
    else begin
      port_choose_array <= port_choose_array_w;
    end
  end

  //generate m_tdata 
  always @(*)
  begin
    //m_tdata = s_tdata[TDATA_WIDTH-1:0] & {TDATA_WIDTH{port_choose_array[0]}} ;
    m_tdata = s_tdata[0*TDATA_WIDTH +: TDATA_WIDTH] & {TDATA_WIDTH{port_choose_array[0]}} ;
    for(J=1;J<AXI_SLV_NUM;J=J+1)
      m_tdata = m_tdata | (s_tdata[TDATA_WIDTH*J +:TDATA_WIDTH] & {TDATA_WIDTH{port_choose_array[J]}}) ;
    //m_tdata = m_tdata | (s_tdata[J*TDATA_WIDTH +: TDATA_WIDTH] & {TDATA_WIDTH{port_choose_array[J]}}) ;
  end
//----------------------------------------------------------------------------
//round_robin cal port_choose
//----------------------------------------------------------------------------
function automatic [AXI_SLV_NUM-1:0] cal_port_choose_w;
  input [AXI_SLV_NUM-1:0] port_choose;
  input [AXI_SLV_NUM-1:0] valid;
  input                   ready;
  reg  [2*AXI_SLV_NUM-2:0] port_choose_inner;    //according to port_choose
  reg  [2*AXI_SLV_NUM-2:0] port_choose_raw;      //to produce port_choose_w
  integer I;
begin
  port_choose_inner = {(AXI_SLV_NUM*2-1){1'b1}};

  if (ready) begin
    for(I=0;I<AXI_SLV_NUM;I=I+1)
      if(port_choose == ({{(AXI_SLV_NUM-1){1'b0}}, 1'b1} << I))
        port_choose_inner = {(AXI_SLV_NUM*2-1){1'b1}} << ((I+1)%AXI_SLV_NUM);
  end
  else begin
    for(I=0;I<AXI_SLV_NUM;I=I+1)
      if(port_choose == ({{(AXI_SLV_NUM-1){1'b0}}, 1'b1} << I))
        port_choose_inner = {(AXI_SLV_NUM*2-1){1'b1}} << I;
  end

  port_choose_raw = port_choose_inner & {valid[AXI_SLV_NUM-2:0], valid} ;
  //port_choose_raw = port_choose_inner & {valid, valid} ;

  cal_port_choose_w = port_choose ;
  for(I=2*AXI_SLV_NUM-2;I>=0;I=I-1)
    if (port_choose_raw[I] == 1'b1)
      cal_port_choose_w = {{(AXI_SLV_NUM-1){1'b0}}, 1'b1} << (I%AXI_SLV_NUM);
end
endfunction
  
////-------------rdata demux----------------////
always @(*)begin
    if(port_sel==5'b00001)begin
        bist_path_rvalid = array_rvalid;
        bist_path_rdata = array_rdata;
        bist_csl_rvalid = 'd0;
        bist_csl_rdata = 'd0;
        bist_wl_rvalid = 'd0;
        bist_wl_rdata = 'd0;
        func_rvalid = 'd0;
        func_rdata = 'd0;
        rescan_rvalid = 'd0;
        rescan_rdata = 'd0;
    end
    else if(port_sel==5'b00010)begin
        bist_path_rvalid = 'd0;
        bist_path_rdata = 'd0;
        bist_csl_rvalid = array_rvalid;
        bist_csl_rdata = array_rdata;
        bist_wl_rvalid = 'd0;
        bist_wl_rdata = 'd0;
        func_rvalid = 'd0;
        func_rdata = 'd0;
        rescan_rvalid = 'd0;
        rescan_rdata = 'd0;
    end
    else if(port_sel==5'b00100)begin
        bist_path_rvalid = 'd0;
        bist_path_rdata = 'd0;
        bist_csl_rvalid = 'd0;
        bist_csl_rdata = 'd0;
        bist_wl_rvalid = array_rvalid;
        bist_wl_rdata = array_rdata;
        func_rvalid = 'd0;
        func_rdata = 'd0;
        rescan_rvalid = 'd0;
        rescan_rdata = 'd0;
    end
    else if(port_sel==5'b01000)begin
        bist_path_rvalid = 'd0;
        bist_path_rdata = 'd0;
        bist_csl_rvalid = 'd0;
        bist_csl_rdata = 'd0;
        bist_wl_rvalid = 'd0;
        bist_wl_rdata = 'd0;
        func_rvalid = array_rvalid;
        func_rdata = array_rdata;
        rescan_rvalid = 'd0;
        rescan_rdata = 'd0;

    end
    else if(port_sel==5'b10000)begin
        bist_path_rvalid = 'd0;
        bist_path_rdata = 'd0;
        bist_csl_rvalid = 'd0;
        bist_csl_rdata = 'd0;
        bist_wl_rvalid = 'd0;
        bist_wl_rdata = 'd0;
        func_rvalid = 'd0;
        func_rdata = 'd0;
        rescan_rvalid = array_rvalid;
        rescan_rdata = array_rdata;
    end
    else begin
        bist_path_rvalid = 'd0;
        bist_path_rdata = 'd0;
        bist_csl_rvalid = 'd0;
        bist_csl_rdata = 'd0;
        bist_wl_rvalid = 'd0;
        bist_wl_rdata = 'd0;
        func_rvalid = 'd0;
        func_rdata = 'd0;
        rescan_rvalid = 'd0;
        rescan_rdata = 'd0;


    end
end
endmodule
