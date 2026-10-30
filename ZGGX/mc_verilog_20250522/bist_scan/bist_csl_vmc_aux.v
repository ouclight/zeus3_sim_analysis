module bist_csl_vmc_aux (
  //-------------clock and reset signal--------------
  //input                                               clk                  ,
 // input                                               rst_n                ,
  //-------------control signal----------------------
  input                                               bist_csl_vmc_en      ,//default 1
  input      [7:0]                                    err_csl0_part0       ,
  input      [7:0]                                    err_csl1_part0       ,
  input      [7:0]                                    err_csl0_part1       ,
  input      [7:0]                                    err_csl1_part1       ,
  input      [7:0]                                    err_csl0_part2       ,
  input      [7:0]                                    err_csl1_part2       ,
  input      [7:0]                                    err_csl0_part3       ,
  input      [7:0]                                    err_csl1_part3       ,
  input      [7:0]                                    err_csl0_part4       ,
  input      [7:0]                                    err_csl1_part4       ,

  input      [7:0]                                    err_csl0_part5       ,
  input      [7:0]                                    err_csl1_part5       ,
  input      [7:0]                                    err_csl0_part6       ,
  input      [7:0]                                    err_csl1_part6       ,
  input      [7:0]                                    err_csl0_part7       ,
  input      [7:0]                                    err_csl1_part7       ,
  input      [7:0]                                    err_csl0_part8       ,
  input      [7:0]                                    err_csl1_part8       ,
  input      [7:0]                                    err_csl0_part9       ,
  input      [7:0]                                    err_csl1_part9       ,


  //-------------input data signal------------------------
  input                                               wl_init_frame_vld    ,
  output                                              wl_init_frame_rdy    ,
  input      [1+1+1+266+13+7-1 :0]                    wl_init_frame_data   ,//rw_flag,sof,eof,data,row,col
  output                                              wl_init_rvalid       ,
  output     [266-1:0]                                wl_init_rdata        , 
  //-------------output data signal------------------------
  output                                              wl_vmc_frame_vld     ,
  input                                               wl_vmc_frame_rdy     ,
  output reg [1+1+1+266+13+8-1 :0]                    wl_vmc_frame_data    ,//rw_flag,sof,eof,data,row,col
  input                                               wl_vmc_rvalid        ,
  input      [266-1:0]                                wl_vmc_rdata          
);

//wire and reg
wire   [7:0]                   vmc_csl0_part0                 ;  //after remap
wire   [7:0]                   vmc_csl1_part0                 ;
wire   [7:0]                   vmc_csl0_part1                 ;
wire   [7:0]                   vmc_csl1_part1                 ;
wire   [7:0]                   vmc_csl0_part2                 ;
wire   [7:0]                   vmc_csl1_part2                 ;
wire   [7:0]                   vmc_csl0_part3                 ;
wire   [7:0]                   vmc_csl1_part3                 ;
wire   [7:0]                   vmc_csl0_part4                 ;
wire   [7:0]                   vmc_csl1_part4                 ;

wire   [7:0]                   vmc_csl0_part5                 ;  
wire   [7:0]                   vmc_csl1_part5                 ;
wire   [7:0]                   vmc_csl0_part6                 ;
wire   [7:0]                   vmc_csl1_part6                 ;
wire   [7:0]                   vmc_csl0_part7                 ;
wire   [7:0]                   vmc_csl1_part7                 ;
wire   [7:0]                   vmc_csl0_part8                 ;
wire   [7:0]                   vmc_csl1_part8                 ;
wire   [7:0]                   vmc_csl0_part9                 ;
wire   [7:0]                   vmc_csl1_part9                 ;


wire   [12:0]                  csl_scan_row_part0_end_addr    ;
wire   [12:0]                  csl_scan_row_part1_start_addr  ;
wire   [12:0]                  csl_scan_row_part1_end_addr    ;
wire   [12:0]                  csl_scan_row_part2_start_addr  ;
wire   [12:0]                  csl_scan_row_part2_end_addr    ;
wire   [12:0]                  csl_scan_row_part3_start_addr  ;
wire   [12:0]                  csl_scan_row_part3_end_addr    ;
wire   [12:0]                  csl_scan_row_part4_start_addr  ;
wire   [12:0]                  csl_scan_row_part4_end_addr    ;
wire   [12:0]                  csl_scan_row_part5_start_addr  ;
wire   [12:0]                  csl_scan_row_part5_end_addr    ;
wire   [12:0]                  csl_scan_row_part6_start_addr  ;
wire   [12:0]                  csl_scan_row_part6_end_addr    ;
wire   [12:0]                  csl_scan_row_part7_start_addr  ;
wire   [12:0]                  csl_scan_row_part7_end_addr    ;
wire   [12:0]                  csl_scan_row_part8_start_addr  ;
wire   [12:0]                  csl_scan_row_part8_end_addr    ;
wire   [12:0]                  csl_scan_row_part9_start_addr  ;
wire   [12:0]                  csl_scan_row_part9_end_addr    ;


reg    [8*10-1:0]               vmc_csl0                       ;  
reg    [8*10-1:0]               vmc_csl1                       ;
wire   [8*10-1:0]               err_csl0                       ;  
wire   [8*10-1:0]               err_csl1                       ;

integer                        II                             ;

/////////assign csl_scan_row_part0_end_addr   = 13'h2df ;//735
/////////assign csl_scan_row_part1_start_addr = csl_scan_row_part0_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part1_end_addr   = csl_scan_row_part1_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part2_start_addr = csl_scan_row_part1_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part2_end_addr   = csl_scan_row_part2_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part3_start_addr = csl_scan_row_part2_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part3_end_addr   = csl_scan_row_part3_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part4_start_addr = csl_scan_row_part3_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part4_end_addr   = csl_scan_row_part4_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part5_start_addr = csl_scan_row_part4_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part5_end_addr   = csl_scan_row_part5_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part6_start_addr = csl_scan_row_part5_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part6_end_addr   = csl_scan_row_part6_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part7_start_addr = csl_scan_row_part6_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part7_end_addr   = csl_scan_row_part7_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part8_start_addr = csl_scan_row_part7_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part8_end_addr   = csl_scan_row_part8_start_addr + 13'h2df  ;
/////////assign csl_scan_row_part9_start_addr = csl_scan_row_part8_end_addr   + 13'h1    ;
/////////assign csl_scan_row_part9_end_addr   = csl_scan_row_part9_start_addr + 13'h2df  ;

assign csl_scan_row_part0_end_addr   = 13'd29 ;
assign csl_scan_row_part1_start_addr = csl_scan_row_part0_end_addr   + 13'h1    ;//test
assign csl_scan_row_part1_end_addr   = csl_scan_row_part1_start_addr + 13'd29  ;//test
assign csl_scan_row_part2_start_addr = csl_scan_row_part1_end_addr   + 13'h1    ;//test
assign csl_scan_row_part2_end_addr   = csl_scan_row_part2_start_addr + 13'd29  ;//test
assign csl_scan_row_part3_start_addr = csl_scan_row_part2_end_addr   + 13'h1    ;//test
assign csl_scan_row_part3_end_addr   = csl_scan_row_part3_start_addr + 13'd29  ;//test
assign csl_scan_row_part4_start_addr = csl_scan_row_part3_end_addr   + 13'h1    ;//test
assign csl_scan_row_part4_end_addr   = csl_scan_row_part4_start_addr + 13'd29  ;//test
assign csl_scan_row_part5_start_addr = csl_scan_row_part4_end_addr   + 13'h1    ;//test
assign csl_scan_row_part5_end_addr   = csl_scan_row_part5_start_addr + 13'd29  ;//test
assign csl_scan_row_part6_start_addr = csl_scan_row_part5_end_addr   + 13'h1    ;//test
assign csl_scan_row_part6_end_addr   = csl_scan_row_part6_start_addr + 13'd29  ;//test
assign csl_scan_row_part7_start_addr = csl_scan_row_part6_end_addr   + 13'h1    ;//test
assign csl_scan_row_part7_end_addr   = csl_scan_row_part7_start_addr + 13'd29  ;//test
assign csl_scan_row_part8_start_addr = csl_scan_row_part7_end_addr   + 13'h1    ;//test
assign csl_scan_row_part8_end_addr   = csl_scan_row_part8_start_addr + 13'd29  ;//test
assign csl_scan_row_part9_start_addr = csl_scan_row_part8_end_addr   + 13'h1    ;//test
assign csl_scan_row_part9_end_addr   = csl_scan_row_part9_start_addr + 13'd29  ;//test


assign err_csl0 = {err_csl0_part9,err_csl0_part8,err_csl0_part7,err_csl0_part6,err_csl0_part5,err_csl0_part4,err_csl0_part3,err_csl0_part2,err_csl0_part1,err_csl0_part0};
assign err_csl1 = {err_csl1_part9,err_csl1_part8,err_csl1_part7,err_csl1_part6,err_csl1_part5,err_csl1_part4,err_csl1_part3,err_csl1_part2,err_csl1_part1,err_csl1_part0};

always @(*) begin
    vmc_csl0 = 80'h0;
    for(II=0;II<10;II=II+1)begin:gen_csl_vmc0_x10
        if(err_csl0[II*8 +:8]==8'hFF && err_csl1[II*8 +:8]==8'hFF)
            vmc_csl0[II*8 +:8] = 8'hFF;
        else if(err_csl0[II*8 +:8] < err_csl1[II*8 +:8])
            vmc_csl0[II*8 +:8] = err_csl0[II*8 +:8] - 1'b0 ; 
        else if(err_csl0[II*8 +:8] > err_csl1[II*8 +:8])
            vmc_csl0[II*8 +:8] = err_csl1[II*8 +:8] - 1'b0 ;
        else
            vmc_csl0[II*8 +:8] = 8'hFF;
    end
end

always @(*) begin
    vmc_csl1 = 80'h0;
    for(II=0;II<10;II=II+1)begin:gen_csl_vmc1_x10
        if(err_csl0[II*8 +:8]==8'hFF && err_csl1[II*8 +:8]==8'hFF)
            vmc_csl1[II*8 +:8] = 8'hFF;
        else if(err_csl0[II*8 +:8] < err_csl1[II*8 +:8] && err_csl1[II*8 +:8]!=8'hFF)
            vmc_csl1[II*8 +:8] = err_csl1[II*8 +:8] - 1'b1 ; 
        else if(err_csl0[II*8 +:8] > err_csl1[II*8 +:8] && err_csl0[II*8 +:8]!=8'hFF)
//            vmc_csl1[II*8 +:8] = err_csl1[II*8 +:8] - 1'b1 ;  azy
            vmc_csl1[II*8 +:8] = err_csl0[II*8 +:8] - 1'b1 ;   //azy
        else
            vmc_csl1[II*8 +:8] = 8'hFF;
    end
end


//assign {vmc_csl0_part4,vmc_csl0_part3,vmc_csl0_part2,vmc_csl0_part1,vmc_csl0_part0} = vmc_csl0 ;
//assign {vmc_csl1_part4,vmc_csl1_part3,vmc_csl1_part2,vmc_csl1_part1,vmc_csl1_part0} = vmc_csl1 ;

assign wl_init_frame_rdy = wl_vmc_frame_rdy  ;
assign wl_vmc_frame_vld  = wl_init_frame_vld ;
assign wl_init_rvalid = wl_vmc_rvalid ;
assign wl_init_rdata  = wl_vmc_rdata  ;

always @(*)begin
    if(wl_init_frame_data[19:7]<=csl_scan_row_part0_end_addr) begin
        wl_vmc_frame_data   =  bist_csl_vmc_en ? ({wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]}+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl0[7:0])+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl1[7:0])) : {wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]};
    end    
    else if(wl_init_frame_data[19:7]<=csl_scan_row_part1_end_addr) begin
        wl_vmc_frame_data   =  bist_csl_vmc_en ? ({wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]}+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl0[15:8])+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl1[15:8])) : {wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]};
    end
    else if(wl_init_frame_data[19:7]<=csl_scan_row_part2_end_addr) begin
        wl_vmc_frame_data   =  bist_csl_vmc_en ? ({wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]}+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl0[23:16])+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl1[23:16])) : {wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]};
    end
    else if(wl_init_frame_data[19:7]<=csl_scan_row_part3_end_addr) begin
        wl_vmc_frame_data   =  bist_csl_vmc_en ? ({wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]}+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl0[31:24])+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl1[31:24])) : {wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]};
    end
    else if(wl_init_frame_data[19:7]<=csl_scan_row_part4_end_addr) begin
        wl_vmc_frame_data   =  bist_csl_vmc_en ? ({wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]}+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl0[39:32])+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl1[39:32])) : {wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]};
    end
    else if(wl_init_frame_data[19:7]<=csl_scan_row_part5_end_addr) begin
        wl_vmc_frame_data   =  bist_csl_vmc_en ? ({wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]}+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl0[47:40])+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl1[47:40])) : {wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]};
    end
    else if(wl_init_frame_data[19:7]<=csl_scan_row_part6_end_addr) begin
        wl_vmc_frame_data   =  bist_csl_vmc_en ? ({wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]}+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl0[55:48])+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl1[55:48])) : {wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]};
    end
    else if(wl_init_frame_data[19:7]<=csl_scan_row_part7_end_addr) begin
        wl_vmc_frame_data   =  bist_csl_vmc_en ? ({wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]}+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl0[63:56])+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl1[63:56])) : {wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]};
    end
    else if(wl_init_frame_data[19:7]<=csl_scan_row_part8_end_addr) begin
        wl_vmc_frame_data   =  bist_csl_vmc_en ? ({wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]}+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl0[71:64])+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl1[71:64])) : {wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]};
    end
    else if(wl_init_frame_data[19:7]<=csl_scan_row_part9_end_addr) begin
        wl_vmc_frame_data   =  bist_csl_vmc_en ? ({wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]}+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl0[79:72])+({1'b0,wl_init_frame_data[6:0]}>=vmc_csl1[79:72])) : {wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]};
    end
    else begin
        wl_vmc_frame_data   =  {wl_init_frame_data[288:7],1'b0,wl_init_frame_data[6:0]} ;
    end
end

endmodule
