module bank_scan_aux #(
    parameter   ARRAY_ADDR_WIDTH      = 13+8                               ,
    parameter   CHECKBIT_WIDTH        = 16                                 ,
    parameter   ARRAY_DATA_WIDTH      = 256  

)
(
  //-------------clock and reset signal--------------
  input                                                                       clk                  ,
  input                                                                       rst_n                ,
  //input                                                                       ras_clr              ,
  //-------------control signal----------------------                        
  input                                                                       global_mc_bist_start ,
  input                                                                       global_mc_bist_en    ,
  input                                                                       mc_bist_en           ,
  output reg                                                                  bist_bank_success    ,
  output reg                                                                  bist_bank_finish     ,
  input                                                                       bist_finish_clr      ,

  input                                                                       mc_timeout_flag      ,
  output reg                                                                  bank_scan_finish     ,
  output reg                                                                  bank_scan_working    ,
  //-------------data signal------------------------
  output reg                                                                  bank_scan_frame_vld  ,
  input                                                                       bank_scan_frame_rdy  ,
  output reg [3+CHECKBIT_WIDTH+ARRAY_DATA_WIDTH+ARRAY_ADDR_WIDTH-1 :0]        bank_scan_frame_data ,//rw_flag,sof,eof,data,row,col
  input                                                                       bank_scan_rvalid     ,
  input      [CHECKBIT_WIDTH+ARRAY_DATA_WIDTH-1:0]                            bank_scan_rdata       
);

//wire and reg
//reg                                              bank_scan_working_status ;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank_scan_frame_vld   <=  1'b0   ;
        bank_scan_frame_data  <=  'h0    ;
    end
    else if(global_mc_bist_start && global_mc_bist_en && mc_bist_en) begin
        bank_scan_frame_vld   <=  1'b1   ;
        bank_scan_frame_data  <=  {1'b0,1'b1,1'b1,{CHECKBIT_WIDTH+ARRAY_DATA_WIDTH{1'h0}},13'h0,8'h0} ;
    end
    else if(bank_scan_frame_vld && bank_scan_frame_rdy) begin
        bank_scan_frame_vld   <=  1'b0   ;
        bank_scan_frame_data  <= bank_scan_frame_data ;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bist_bank_success   <=  1'b0   ;
    end
    else if(global_mc_bist_start) begin
        bist_bank_success   <=  1'b0   ;
    end
    else if(bank_scan_rvalid && !mc_timeout_flag) begin
        bist_bank_success   <=  1'b1   ;
    end
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bist_bank_finish   <=  1'b0   ;
    end
    else if(global_mc_bist_start || bist_finish_clr) begin
        bist_bank_finish   <=  1'b0   ;
    end
    else if(bank_scan_rvalid && mc_timeout_flag && (bank_scan_rdata == 'h123456789abcdef)) begin
        bist_bank_finish   <=  1'b1   ;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        bank_scan_finish   <=  1'b0   ;
    end
    else if(bank_scan_rvalid && ((!mc_timeout_flag && (bank_scan_rdata == 'h123456789abcdef)) ||
            (bank_scan_rdata != 'h123456789abcdef) )) begin
        bank_scan_finish   <=  1'b1   ;
    end
    else begin
        bank_scan_finish   <= 1'b0    ;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        bank_scan_working   <=  1'b0   ;
    end
    else if(global_mc_bist_start && global_mc_bist_en && mc_bist_en)
        bank_scan_working   <= 1'b1 ;
    else if(bank_scan_rvalid)
        bank_scan_working   <= 1'b0 ;
end

endmodule
