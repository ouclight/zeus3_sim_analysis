module bist_rescan_top_aux #(
    parameter   RESCAN_ROUND_NUM      = 15                                 ,
    parameter   ARRAY_ADDR_WIDTH      = 13+8                               ,
    parameter   MC_SHORT_MODE         = 3                                  ,
    parameter   CHECKBIT_WIDTH        = 16                                 ,
    parameter   ARRAY_ROW_ADDR_WIDTH  = 13                                 ,
    parameter   ARRAY_COL_ADDR_WIDTH  = 8                                  ,
    parameter   ARRAY_DATA_WIDTH      = 256
)(
  //-------------clock and reset signal--------------
  input                                                                      clk                                 ,
  input                                                                      rst_n                               ,
  //-------------control signal----------------------                                     
  input      [3:0]                                                           mc_bist_grant                       ,//{bank3_grt,bank2_grt,bank1_grt,bank0_grt}

  input                                                                      global_mc_bist_en                   ,
  input                                                                      global_mc_rescan_start              ,//default 0
  input                                                                      mc_bist_en                          ,
  input      [67:0]                                                          wl_bist_pattern_sel                 ,
  input      [68*32-1:0]                                                     bist_pattern_all                    ,
  													                           			                  
  input      [3:0]                                                           bist_rescan_num                     ,//default 3
  input                                                                      bist_rescan_sel                     ,//1:7360-64,0:7360,default 1
													                           					              
  output                                                                     bist_rescan_success                 ,
  output                                                                     bist_rescan_finish_intr             ,
  output                                                                     bist_rescan_finish_status           ,
  input                                                                      rescan_finish_clr                   ,
  input                                                                      rescan_finish_mask                  ,
  output                                                                     rescan_working                      ,
  //-------------data signal------------------------                                                             
  output                                                                     rescan_frame_vld                    ,
  input                                                                      rescan_frame_rdy                    ,
  output     [3+CHECKBIT_WIDTH+ARRAY_DATA_WIDTH+ARRAY_ADDR_WIDTH+2-1 :0]     rescan_frame_data                   ,//rw_flag,sof,eof,data,row,col
  input                                                                      rescan_rvalid                       ,
  input      [CHECKBIT_WIDTH+ARRAY_DATA_WIDTH-1:0]                           rescan_rdata                        ,


  output     [20*MC_SHORT_MODE-1:0]                                          bank_rescan_fail_num                ,
  output     [1*MC_SHORT_MODE-1:0]                                           bank_rescan_finish_status           ,
  output     [1*MC_SHORT_MODE-1:0]                                           bank_rescan_success_status          ,
  output     [RESCAN_ROUND_NUM*MC_SHORT_MODE-1:0]                            bank_rescan_round_result       

);

wire      [1:0]                                bist_layer_id                   ;
wire                                           rescan_serial_start             ;
reg       [2:0]                                RESCAN_CS                       ;
reg       [2:0]                                RESCAN_NS                       ;
wire      [MC_SHORT_MODE-1:0]                  all_bank_rescan_finish_status   ;
wire      [MC_SHORT_MODE-1:0]                  all_bank_rescan_success_status  ;
wire      [RESCAN_ROUND_NUM-1:0]               bank_rescan_round_result_tmp    ;
reg                                            grant_rescan_finish             ;
reg                                            grant_rescan_success            ;
wire      [19:0]                               bist_rescan_fail_num            ;
reg       [2:0]                                index                           ;
               
integer II ;
////--------------------------parameter output--------------------------////




localparam IDLE       = 3'b000,
           BANK0      = 3'b001,
           BANK1      = 3'b010,
           BANK2      = 3'b011,
           BANK3      = 3'b100 ;


always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)
        RESCAN_CS <= IDLE;
    else 
        RESCAN_CS <= RESCAN_NS;
end






assign bist_layer_id = RESCAN_CS - 1'b1;
assign rescan_serial_start = global_mc_rescan_start || (RESCAN_CS != RESCAN_NS && RESCAN_CS != IDLE && RESCAN_NS != IDLE);





bist_rescan_aux #(
                .ARRAY_ADDR_WIDTH    (ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH ),
                .CHECKBIT_WIDTH      (CHECKBIT_WIDTH                            ),
                .MC_SHORT_MODE       (MC_SHORT_MODE                             ),
                .ARRAY_ROW_ADDR_WIDTH(ARRAY_ROW_ADDR_WIDTH                      ),
                .ARRAY_COL_ADDR_WIDTH(ARRAY_COL_ADDR_WIDTH                      ),
                .ARRAY_DATA_WIDTH    (ARRAY_DATA_WIDTH                          )
            )U_bist_rescan_aux(
  //-------------clock and reset signal--------------
                .clk                      (clk                            ),
                .rst_n                    (rst_n                          ),
                .bist_rescan_sel          (bist_rescan_sel                ),
                .bist_layer_id            (bist_layer_id                  ),
                                          
                .global_mc_bist_en        (global_mc_bist_en              ),
                .global_mc_rescan_start   (rescan_serial_start            ),//default 0
                .mc_bist_en               (mc_bist_en                     ),
                			              
                .bist_rescan_num          (bist_rescan_num                ),//default 3
                .wl_bist_pattern_sel      (wl_bist_pattern_sel            ),
                .bist_pattern_all         (bist_pattern_all               ),
                .bist_rescan_fail_num     (bist_rescan_fail_num           ),
                .rescan_round_result      (bank_rescan_round_result_tmp   ),
                                															              
                .bist_rescan_success      (bank_bist_rescan_success       ),
                //.bist_rescan_finish       (bank_bist_rescan_finish        ),
                .bist_rescan_finish_status(bank_bist_rescan_finish_status ),
                .rescan_finish_clr        (rescan_finish_clr              ),
                //.rescan_finish_mask       (rescan_finish_mask             ),
                .rescan_working           (rescan_working                 ),
                                          
                .rescan_frame_vld         (rescan_frame_vld               ),
                .rescan_frame_rdy         (rescan_frame_rdy               ),
                .rescan_frame_data        (rescan_frame_data              ),//rw_flag,sof,eof,data,row,col
                .rescan_rvalid            (rescan_rvalid                  ),
                .rescan_rdata             (rescan_rdata                   )
);

////-------------------rescan_finish-----------------------------////

generate
if(MC_SHORT_MODE==4)begin:inst0
      
reg [19:0]                                                      bank0_rescan_fail_num           ;
reg                                                             bank0_rescan_finish_status      ;
reg                                                             bank0_rescan_success_status     ;
reg [RESCAN_ROUND_NUM-1:0]                                      bank0_rescan_round_result       ;

reg [19:0]                                                      bank1_rescan_fail_num           ;
reg                                                             bank1_rescan_finish_status      ;
reg                                                             bank1_rescan_success_status     ;
reg [RESCAN_ROUND_NUM-1:0]                                      bank1_rescan_round_result       ;


reg [19:0]                                                      bank2_rescan_fail_num           ;
reg                                                             bank2_rescan_finish_status      ;
reg                                                             bank2_rescan_success_status     ;
reg [RESCAN_ROUND_NUM-1:0]                                      bank2_rescan_round_result       ;

reg [19:0]                                                      bank3_rescan_fail_num           ;
reg                                                             bank3_rescan_finish_status      ;
reg                                                             bank3_rescan_success_status     ;
reg [RESCAN_ROUND_NUM-1:0]                                      bank3_rescan_round_result       ;

always @(*)begin
    case(RESCAN_CS)
    IDLE:begin
        if(global_mc_rescan_start && mc_bist_grant[0])
            RESCAN_NS = BANK0;
        else if(global_mc_rescan_start && mc_bist_grant[1:0]==2'b10)
            RESCAN_NS = BANK1;
        else if(global_mc_rescan_start && mc_bist_grant[2:0]==3'b100)
            RESCAN_NS = BANK2;
        else if(global_mc_rescan_start && mc_bist_grant[3:0]==4'b1000)
            RESCAN_NS = BANK3;        
        else
            RESCAN_NS = RESCAN_CS;
    end
    BANK0:begin
        if(bank0_rescan_finish_status && mc_bist_grant[3:1]==3'b000)
            RESCAN_NS = IDLE;
        else if(bank0_rescan_finish_status && mc_bist_grant[1])
            RESCAN_NS = BANK1;
        else if(bank0_rescan_finish_status && mc_bist_grant[2:1]==2'b10)
            RESCAN_NS = BANK2;
        else if(bank0_rescan_finish_status && mc_bist_grant[3:1]==3'b100)
            RESCAN_NS = BANK3;
        else
            RESCAN_NS = RESCAN_CS;
    end
    BANK1:begin
        if(bank1_rescan_finish_status && mc_bist_grant[3:2]==2'b00)
            RESCAN_NS = IDLE;
        else if(bank1_rescan_finish_status && mc_bist_grant[2])
            RESCAN_NS = BANK2;
        else if(bank1_rescan_finish_status && mc_bist_grant[3:2]==2'b10)
            RESCAN_NS = BANK3;
        else
            RESCAN_NS = RESCAN_CS;
    end
    BANK2:begin
        if(bank2_rescan_finish_status && mc_bist_grant[3]==1'b0)
            RESCAN_NS = IDLE;
        else if(bank2_rescan_finish_status && mc_bist_grant[3])
            RESCAN_NS = BANK3;
        else
            RESCAN_NS = RESCAN_CS;
        end
    BANK3:begin
        if(bank3_rescan_finish_status)
            RESCAN_NS = IDLE;
        else
            RESCAN_NS = RESCAN_CS;
    end
    default:RESCAN_NS = IDLE;
    endcase
end




always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank0_rescan_finish_status <= 1'b0;
        bank0_rescan_fail_num <=  20'h0;
        bank0_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(global_mc_rescan_start || rescan_finish_clr)begin
        bank0_rescan_finish_status <= 1'b0;
        bank0_rescan_fail_num <=  20'h0;
        bank0_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(RESCAN_NS == BANK0)begin
        bank0_rescan_finish_status <= bank_bist_rescan_finish_status;
        bank0_rescan_fail_num <=  bist_rescan_fail_num;
        bank0_rescan_round_result <= bank_rescan_round_result_tmp;

    end
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank1_rescan_finish_status <= 1'b0;
        bank1_rescan_fail_num <=  20'h0;
        bank1_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};
    end
    else if(global_mc_rescan_start|| rescan_finish_clr)begin
        bank1_rescan_finish_status <= 1'b0;
        bank1_rescan_fail_num <=  20'h0;
        bank1_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end

    else if(RESCAN_NS == BANK1)begin
        bank1_rescan_finish_status <= bank_bist_rescan_finish_status;
        bank1_rescan_fail_num <=  bist_rescan_fail_num;
        bank1_rescan_round_result <= bank_rescan_round_result_tmp;

    end
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank2_rescan_finish_status <= 1'b0;
        bank2_rescan_fail_num <=  20'h0;
        bank2_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(global_mc_rescan_start|| rescan_finish_clr)begin
        bank2_rescan_finish_status <= 1'b0;
        bank2_rescan_fail_num <=  20'h0;
        bank2_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(RESCAN_NS == BANK2)begin
        bank2_rescan_finish_status <= bank_bist_rescan_finish_status;
        bank2_rescan_fail_num <=  bist_rescan_fail_num;
        bank2_rescan_round_result <= bank_rescan_round_result_tmp;

    end
end


always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank3_rescan_finish_status <= 1'b0;
        bank3_rescan_fail_num <=  20'h0;
        bank3_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(global_mc_rescan_start|| rescan_finish_clr)begin
        bank3_rescan_finish_status <= 1'b0;
        bank3_rescan_fail_num <=  20'h0;        
        bank3_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(RESCAN_NS == BANK3)begin
        bank3_rescan_finish_status <= bank_bist_rescan_finish_status;
        bank3_rescan_fail_num <=  bist_rescan_fail_num;
        bank3_rescan_round_result <= bank_rescan_round_result_tmp;

    end
end
assign bank_rescan_success_status = {bank3_rescan_success_status,bank2_rescan_success_status,bank1_rescan_success_status,bank0_rescan_success_status};

assign bank_rescan_finish_status = {bank3_rescan_finish_status,bank2_rescan_finish_status,bank1_rescan_finish_status,bank0_rescan_finish_status};
assign bank_rescan_fail_num = {bank3_rescan_fail_num,bank2_rescan_fail_num,bank1_rescan_fail_num,bank0_rescan_fail_num};
assign bank_rescan_round_result = {bank3_rescan_round_result,bank2_rescan_round_result,bank1_rescan_round_result,bank0_rescan_round_result};

assign all_bank_rescan_finish_status = {bank3_rescan_finish_status,bank2_rescan_finish_status,bank1_rescan_finish_status,bank0_rescan_finish_status};
assign all_bank_rescan_success_status = {bank3_rescan_success_status,bank2_rescan_success_status,bank1_rescan_success_status,bank0_rescan_success_status};
////-------------------rescan success------------------------////
always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank0_rescan_success_status <= 1'b0;
    else if(global_mc_rescan_start)
        bank0_rescan_success_status <= 1'b0;
    else if(RESCAN_NS == BANK0)
        bank0_rescan_success_status <= bank_bist_rescan_success;
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank1_rescan_success_status <= 1'b0;
    else if(global_mc_rescan_start)
        bank1_rescan_success_status <= 1'b0;
    else if(RESCAN_NS == BANK1)
        bank1_rescan_success_status <= bank_bist_rescan_success;
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank2_rescan_success_status <= 1'b0;
    else if(global_mc_rescan_start)
        bank2_rescan_success_status <= 1'b0;
    else if(RESCAN_NS == BANK2)
        bank2_rescan_success_status <= bank_bist_rescan_success;
end


always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank3_rescan_success_status <= 1'b0;
    else if(global_mc_rescan_start)
        bank3_rescan_success_status <= 1'b0;
    else if(RESCAN_NS == BANK3)
        bank3_rescan_success_status <= bank_bist_rescan_success;
    end


end
//MC_SHORT_MODE==3
else if(MC_SHORT_MODE==3)begin:inst1

reg  [19:0]                                                      bank0_rescan_fail_num           ;
reg                                                              bank0_rescan_finish_status      ;
reg                                                              bank0_rescan_success_status     ;
reg  [RESCAN_ROUND_NUM-1:0]                                      bank0_rescan_round_result       ;

reg  [19:0]                                                      bank1_rescan_fail_num           ;
reg                                                              bank1_rescan_finish_status      ;
reg                                                              bank1_rescan_success_status     ;
reg  [RESCAN_ROUND_NUM-1:0]                                      bank1_rescan_round_result       ;


reg  [19:0]                                                      bank2_rescan_fail_num           ;
reg                                                              bank2_rescan_finish_status      ;
reg                                                              bank2_rescan_success_status     ;
reg  [RESCAN_ROUND_NUM-1:0]                                      bank2_rescan_round_result       ;

//wire [19:0]                                                      bank3_rescan_fail_num           ;
wire                                                             bank3_rescan_finish_status      ;
wire                                                             bank3_rescan_success_status     ;
//wire [RESCAN_ROUND_NUM-1:0]                                      bank3_rescan_round_result       ;

assign bank3_rescan_finish_status = 1'b0;

always @(*)begin
    case(RESCAN_CS)
    IDLE:begin
        if(global_mc_rescan_start && mc_bist_grant[0])
            RESCAN_NS = BANK0;
        else if(global_mc_rescan_start && mc_bist_grant[1:0]==2'b10)
            RESCAN_NS = BANK1;
        else if(global_mc_rescan_start && mc_bist_grant[2:0]==3'b100)
            RESCAN_NS = BANK2;
        else if(global_mc_rescan_start && mc_bist_grant[3:0]==4'b1000)
            RESCAN_NS = BANK3;        
        else
            RESCAN_NS = RESCAN_CS;
    end
    BANK0:begin
        if(bank0_rescan_finish_status && mc_bist_grant[3:1]==3'b000)
            RESCAN_NS = IDLE;
        else if(bank0_rescan_finish_status && mc_bist_grant[1])
            RESCAN_NS = BANK1;
        else if(bank0_rescan_finish_status && mc_bist_grant[2:1]==2'b10)
            RESCAN_NS = BANK2;
        else if(bank0_rescan_finish_status && mc_bist_grant[3:1]==3'b100)
            RESCAN_NS = BANK3;
        else
            RESCAN_NS = RESCAN_CS;
    end
    BANK1:begin
        if(bank1_rescan_finish_status && mc_bist_grant[3:2]==2'b00)
            RESCAN_NS = IDLE;
        else if(bank1_rescan_finish_status && mc_bist_grant[2])
            RESCAN_NS = BANK2;
        else if(bank1_rescan_finish_status && mc_bist_grant[3:2]==2'b10)
            RESCAN_NS = BANK3;
        else
            RESCAN_NS = RESCAN_CS;
    end
    BANK2:begin
        if(bank2_rescan_finish_status && mc_bist_grant[3]==1'b0)
            RESCAN_NS = IDLE;
        else if(bank2_rescan_finish_status && mc_bist_grant[3])
            RESCAN_NS = BANK3;
        else
            RESCAN_NS = RESCAN_CS;
        end
    BANK3:begin
        if(bank3_rescan_finish_status)
            RESCAN_NS = IDLE;
        else
            RESCAN_NS = RESCAN_CS;
    end
    default:RESCAN_NS = IDLE;
    endcase
end



always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank0_rescan_finish_status <= 1'b0;
        bank0_rescan_fail_num <=  20'h0;
        bank0_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(global_mc_rescan_start || rescan_finish_clr)begin
        bank0_rescan_finish_status <= 1'b0;
        bank0_rescan_fail_num <=  20'h0;
        bank0_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(RESCAN_NS == BANK0)begin
        bank0_rescan_finish_status <= bank_bist_rescan_finish_status;
        bank0_rescan_fail_num <=  bist_rescan_fail_num;
        bank0_rescan_round_result <= bank_rescan_round_result_tmp;

    end
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank1_rescan_finish_status <= 1'b0;
        bank1_rescan_fail_num <=  20'h0;
        bank1_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};
    end
    else if(global_mc_rescan_start|| rescan_finish_clr)begin
        bank1_rescan_finish_status <= 1'b0;
        bank1_rescan_fail_num <=  20'h0;
        bank1_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(RESCAN_NS == BANK1)begin
        bank1_rescan_finish_status <= bank_bist_rescan_finish_status;
        bank1_rescan_fail_num <=  bist_rescan_fail_num;
        bank1_rescan_round_result <= bank_rescan_round_result_tmp;

    end
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank2_rescan_finish_status <= 1'b0;
        bank2_rescan_fail_num <=  20'h0;
        bank2_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(global_mc_rescan_start|| rescan_finish_clr)begin
        bank2_rescan_finish_status <= 1'b0;
        bank2_rescan_fail_num <=  20'h0;
        bank2_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(RESCAN_NS == BANK2)begin
        bank2_rescan_finish_status <= bank_bist_rescan_finish_status;
        bank2_rescan_fail_num <=  bist_rescan_fail_num;
        bank2_rescan_round_result <= bank_rescan_round_result_tmp;

    end
end
assign bank_rescan_success_status = {bank2_rescan_success_status,bank1_rescan_success_status,bank0_rescan_success_status};
assign bank_rescan_finish_status = {bank2_rescan_finish_status,bank1_rescan_finish_status,bank0_rescan_finish_status};
assign bank_rescan_fail_num = {bank2_rescan_fail_num,bank1_rescan_fail_num,bank0_rescan_fail_num};
assign bank_rescan_round_result = {bank2_rescan_round_result,bank1_rescan_round_result,bank0_rescan_round_result};


////-------------------rescan success------------------------////
always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank0_rescan_success_status <= 1'b0;
    else if(global_mc_rescan_start)
        bank0_rescan_success_status <= 1'b0;
    else if(RESCAN_NS == BANK0)
        bank0_rescan_success_status <= bank_bist_rescan_success;
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank1_rescan_success_status <= 1'b0;
    else if(global_mc_rescan_start)
        bank1_rescan_success_status <= 1'b0;
    else if(RESCAN_NS == BANK1)
        bank1_rescan_success_status <= bank_bist_rescan_success;
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank2_rescan_success_status <= 1'b0;
    else if(global_mc_rescan_start)
        bank2_rescan_success_status <= 1'b0;
    else if(RESCAN_NS == BANK2)
        bank2_rescan_success_status <= bank_bist_rescan_success;
end


assign all_bank_rescan_finish_status = {bank2_rescan_finish_status,bank1_rescan_finish_status,bank0_rescan_finish_status};
assign all_bank_rescan_success_status = {bank2_rescan_success_status,bank1_rescan_success_status,bank0_rescan_success_status};

end
//MC_SHORT_MODE==2
else if(MC_SHORT_MODE==2)begin:inst2


reg   [19:0]                                                      bank0_rescan_fail_num           ;
reg                                                               bank0_rescan_finish_status      ;
reg                                                               bank0_rescan_success_status     ;
reg   [RESCAN_ROUND_NUM-1:0]                                      bank0_rescan_round_result       ;

reg   [19:0]                                                      bank1_rescan_fail_num           ;
reg                                                               bank1_rescan_finish_status      ;
reg                                                               bank1_rescan_success_status     ;
reg   [RESCAN_ROUND_NUM-1:0]                                      bank1_rescan_round_result       ;

wire                                                              bank2_rescan_finish_status      ;
wire                                                              bank2_rescan_success_status     ;

wire                                                              bank3_rescan_finish_status      ;
//wire                                                              bank3_rescan_success_status     ;
assign bank2_rescan_finish_status = 1'b0;
assign bank3_rescan_finish_status = 1'b0;

assign bank2_rescan_success_status = 1'b0;
//assign bank3_rescan_success_status = 1'b0;





always @(*)begin
    case(RESCAN_CS)
    IDLE:begin
        if(global_mc_rescan_start && mc_bist_grant[0])
            RESCAN_NS = BANK0;
        else if(global_mc_rescan_start && mc_bist_grant[1:0]==2'b10)
            RESCAN_NS = BANK1;
        else if(global_mc_rescan_start && mc_bist_grant[2:0]==3'b100)
            RESCAN_NS = BANK2;
        else if(global_mc_rescan_start && mc_bist_grant[3:0]==4'b1000)
            RESCAN_NS = BANK3;        
        else
            RESCAN_NS = RESCAN_CS;
    end
    BANK0:begin
        if(bank0_rescan_finish_status && mc_bist_grant[3:1]==3'b000)
            RESCAN_NS = IDLE;
        else if(bank0_rescan_finish_status && mc_bist_grant[1])
            RESCAN_NS = BANK1;
        else if(bank0_rescan_finish_status && mc_bist_grant[2:1]==2'b10)
            RESCAN_NS = BANK2;
        else if(bank0_rescan_finish_status && mc_bist_grant[3:1]==3'b100)
            RESCAN_NS = BANK3;
        else
            RESCAN_NS = RESCAN_CS;
    end
    BANK1:begin
        if(bank1_rescan_finish_status && mc_bist_grant[3:2]==2'b00)
            RESCAN_NS = IDLE;
        else if(bank1_rescan_finish_status && mc_bist_grant[2])
            RESCAN_NS = BANK2;
        else if(bank1_rescan_finish_status && mc_bist_grant[3:2]==2'b10)
            RESCAN_NS = BANK3;
        else
            RESCAN_NS = RESCAN_CS;
    end
    BANK2:begin
        if(bank2_rescan_finish_status && mc_bist_grant[3]==1'b0)
            RESCAN_NS = IDLE;
        else if(bank2_rescan_finish_status && mc_bist_grant[3])
            RESCAN_NS = BANK3;
        else
            RESCAN_NS = RESCAN_CS;
        end
    BANK3:begin
        if(bank3_rescan_finish_status)
            RESCAN_NS = IDLE;
        else
            RESCAN_NS = RESCAN_CS;
    end
    default:RESCAN_NS = IDLE;
    endcase
end





always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank0_rescan_finish_status <= 1'b0;
        bank0_rescan_fail_num <=  20'h0;
        bank0_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(global_mc_rescan_start || rescan_finish_clr)begin
        bank0_rescan_finish_status <= 1'b0;
        bank0_rescan_fail_num <=  20'h0;
        bank0_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(RESCAN_NS == BANK0)begin
        bank0_rescan_finish_status <= bank_bist_rescan_finish_status;
        bank0_rescan_fail_num <=  bist_rescan_fail_num;
        bank0_rescan_round_result <= bank_rescan_round_result_tmp;

    end
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank1_rescan_finish_status <= 1'b0;
        bank1_rescan_fail_num <=  20'h0;
        bank1_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};
    end
    else if(global_mc_rescan_start|| rescan_finish_clr)begin
        bank1_rescan_finish_status <= 1'b0;
        bank1_rescan_fail_num <=  20'h0;
        bank1_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(RESCAN_NS == BANK1)begin
        bank1_rescan_finish_status <= bank_bist_rescan_finish_status;
        bank1_rescan_fail_num <=  bist_rescan_fail_num;
        bank1_rescan_round_result <= bank_rescan_round_result_tmp;
    end
end

assign bank_rescan_success_status = {bank1_rescan_success_status,bank0_rescan_success_status};
assign bank_rescan_finish_status = {bank1_rescan_finish_status,bank0_rescan_finish_status};
assign bank_rescan_fail_num = {bank1_rescan_fail_num,bank0_rescan_fail_num};
assign bank_rescan_round_result = {bank1_rescan_round_result,bank0_rescan_round_result};



////-------------------rescan success------------------------////
always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank0_rescan_success_status <= 1'b0;
    else if(global_mc_rescan_start)
        bank0_rescan_success_status <= 1'b0;
    else if(RESCAN_NS == BANK0)
        bank0_rescan_success_status <= bank_bist_rescan_success;
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank1_rescan_success_status <= 1'b0;
    else if(global_mc_rescan_start)
        bank1_rescan_success_status <= 1'b0;
    else if(RESCAN_NS == BANK1)
        bank1_rescan_success_status <= bank_bist_rescan_success;
end
assign all_bank_rescan_finish_status = {bank1_rescan_finish_status,bank0_rescan_finish_status};
assign all_bank_rescan_success_status = {bank1_rescan_success_status,bank0_rescan_success_status};

end
//MC_SHORT_MODE==1
else begin:inst3

reg   [19:0]                                                      bank0_rescan_fail_num           ;
reg                                                               bank0_rescan_finish_status      ;
reg                                                               bank0_rescan_success_status     ;
reg   [RESCAN_ROUND_NUM-1:0]                                      bank0_rescan_round_result       ;


wire                                                              bank1_rescan_finish_status      ;
//wire                                                              bank1_rescan_success_status     ;


wire                                                              bank2_rescan_finish_status      ;
//wire                                                              bank2_rescan_success_status     ;

wire                                                              bank3_rescan_finish_status      ;
//wire                                                              bank3_rescan_success_status     ;


assign bank1_rescan_finish_status = 1'b0;
assign bank2_rescan_finish_status = 1'b0;
assign bank3_rescan_finish_status = 1'b0;

//assign bank1_rescan_success_status = 1'b0;
//assign bank2_rescan_success_status = 1'b0;
//assign bank3_rescan_success_status = 1'b0;

always @(*)begin
    case(RESCAN_CS)
    IDLE:begin
        if(global_mc_rescan_start && mc_bist_grant[0])
            RESCAN_NS = BANK0;
        else if(global_mc_rescan_start && mc_bist_grant[1:0]==2'b10)
            RESCAN_NS = BANK1;
        else if(global_mc_rescan_start && mc_bist_grant[2:0]==3'b100)
            RESCAN_NS = BANK2;
        else if(global_mc_rescan_start && mc_bist_grant[3:0]==4'b1000)
            RESCAN_NS = BANK3;        
        else
            RESCAN_NS = RESCAN_CS;
    end
    BANK0:begin
        if(bank0_rescan_finish_status && mc_bist_grant[3:1]==3'b000)
            RESCAN_NS = IDLE;
        else if(bank0_rescan_finish_status && mc_bist_grant[1])
            RESCAN_NS = BANK1;
        else if(bank0_rescan_finish_status && mc_bist_grant[2:1]==2'b10)
            RESCAN_NS = BANK2;
        else if(bank0_rescan_finish_status && mc_bist_grant[3:1]==3'b100)
            RESCAN_NS = BANK3;
        else
            RESCAN_NS = RESCAN_CS;
    end
    BANK1:begin
        if(bank1_rescan_finish_status && mc_bist_grant[3:2]==2'b00)
            RESCAN_NS = IDLE;
        else if(bank1_rescan_finish_status && mc_bist_grant[2])
            RESCAN_NS = BANK2;
        else if(bank1_rescan_finish_status && mc_bist_grant[3:2]==2'b10)
            RESCAN_NS = BANK3;
        else
            RESCAN_NS = RESCAN_CS;
    end
    BANK2:begin
        if(bank2_rescan_finish_status && mc_bist_grant[3]==1'b0)
            RESCAN_NS = IDLE;
        else if(bank2_rescan_finish_status && mc_bist_grant[3])
            RESCAN_NS = BANK3;
        else
            RESCAN_NS = RESCAN_CS;
        end
    BANK3:begin
        if(bank3_rescan_finish_status)
            RESCAN_NS = IDLE;
        else
            RESCAN_NS = RESCAN_CS;
    end
    default:RESCAN_NS = IDLE;
    endcase
end



always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        bank0_rescan_finish_status <= 1'b0;
        bank0_rescan_fail_num <=  20'h0;
        bank0_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(global_mc_rescan_start || rescan_finish_clr)begin
        bank0_rescan_finish_status <= 1'b0;
        bank0_rescan_fail_num <=  20'h0;
        bank0_rescan_round_result <= {RESCAN_ROUND_NUM{1'h0}};

    end
    else if(RESCAN_NS == BANK0)begin
        bank0_rescan_finish_status <= bank_bist_rescan_finish_status;
        bank0_rescan_fail_num <=  bist_rescan_fail_num;
        bank0_rescan_round_result <= bank_rescan_round_result_tmp;

    end
end
assign bank_rescan_success_status = bank0_rescan_success_status;
assign bank_rescan_finish_status = bank0_rescan_finish_status;
assign bank_rescan_fail_num = bank0_rescan_fail_num;
assign bank_rescan_round_result = bank0_rescan_round_result;



////-------------------rescan success------------------------////
always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bank0_rescan_success_status <= 1'b0;
    else if(global_mc_rescan_start)
        bank0_rescan_success_status <= 1'b0;
    else if(RESCAN_NS == BANK0)
        bank0_rescan_success_status <= bank_bist_rescan_success;
end

assign all_bank_rescan_finish_status = bank0_rescan_finish_status;
assign all_bank_rescan_success_status = bank0_rescan_success_status;
end
endgenerate


////-------------------rescan_finish_intr-----------------------------////

//generate
//begin
//    if(MC_SHORT_MODE==4)begin
//        assign all_bank_rescan_finish_status = {bank3_rescan_finish_status,bank2_rescan_finish_status,bank1_rescan_finish_status,bank0_rescan_finish_status};
//        assign all_bank_rescan_success_status = {bank3_rescan_success_status,bank2_rescan_success_status,bank1_rescan_success_status,bank0_rescan_success_status};
//    end
//    else if(MC_SHORT_MODE==3)begin
//        assign all_bank_rescan_finish_status = {bank2_rescan_finish_status,bank1_rescan_finish_status,bank0_rescan_finish_status};
//        assign all_bank_rescan_success_status = {bank2_rescan_success_status,bank1_rescan_success_status,bank0_rescan_success_status};
//    end
//    else if(MC_SHORT_MODE==2)begin
//        assign all_bank_rescan_finish_status = {bank1_rescan_finish_status,bank0_rescan_finish_status};
//        assign all_bank_rescan_success_status = {bank1_rescan_success_status,bank0_rescan_success_status};
//    end
//    else begin
//        assign all_bank_rescan_finish_status = {bank0_rescan_finish_status};
//        assign all_bank_rescan_success_status = {bank0_rescan_success_status};
//    end
//end
//endgenerate


always @(*)begin
    grant_rescan_finish = 1'b0;
    grant_rescan_success = 1'b0;
    for(II=0;II<MC_SHORT_MODE;II=II+1)begin
        if(II==0)begin
            if(mc_bist_grant[II])begin
                grant_rescan_finish = all_bank_rescan_finish_status[II];
                grant_rescan_success = all_bank_rescan_success_status[II];
            end
        end
        else begin
            if(mc_bist_grant[II])begin
                grant_rescan_finish = grant_rescan_finish && all_bank_rescan_finish_status[II];
                grant_rescan_success = grant_rescan_success && all_bank_rescan_success_status[II];
        end
        end
    end
end

assign bist_rescan_finish_status = grant_rescan_finish;
assign bist_rescan_success = grant_rescan_success ;

assign bist_rescan_finish_intr = rescan_finish_mask ? 1'b0 : & grant_rescan_finish;







endmodule
