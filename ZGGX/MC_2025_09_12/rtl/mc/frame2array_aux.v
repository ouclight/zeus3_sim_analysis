module frame2array_aux #(
  parameter  ARRAY_DATA_WIDTH      = 256,
  parameter  ARRAY_ROW_ADDR_WIDTH  = 13,
  parameter  ARRAY_COL_ADDR_WIDTH  = 8,
  parameter  CHECKBIT_WIDTH        = 16,
  parameter  MC_SHORT_MODE         = 4,
  parameter  MC_FRAME_WIDTH        = ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+3+1
)(
  //-------------clock and reset-------------------------------
  input                                                    clk                ,
  input                                                    rst_n              ,
  input                                                    ras_clr            ,
  //-------------apb config-----------------------------------
  input                                                    mc_en              ,
  input                                                    mc_rf_start        ,
  input                                                    mc_rf_en           ,//default 1,0:close rf
  input                                                    mc_all_bank_act_en ,

  input                                                    global_rf_sel_en   , 
  input                                                    global_rf_cnt_clr  ,
  input                                                    global_rf_sel      , 
  input                                                    mc_rf_cfg_sel      ,
  input                                                    mc_rdata_invert_sel,  
  input                                                    mc_rdrdy_n_en      ,

  input       [5:0]                                        mc_trc_cfg         ,//active to active time
  input       [4:0]                                        mc_tras_cfg        ,//rcd active to precharge time
  input       [3:0]                                        mc_trp_cfg         ,//precharge time
  input       [4:0]                                        mc_trcd_cfg        ,//write rcd time
  input       [1:0]                                        mc_trcb_cfg        ,//read bank change time(mlt_active)
  input       [0:0]                                        mc_trtp_cfg        ,//rd cas rising edge to precharge time
  input       [3:0]                                        mc_twr_cfg         ,//wr cas falling edge to precharge time
  input       [2:0]                                        mc_twtr_cfg        ,//write cas To Read cas time
  input       [3:0]                                        mc_trtw_cfg        ,//Read cas To Write cas time

  input       [31:0]                                       mc_rf_period_1     ,
  input       [31:0]                                       mc_rf_period_2     ,
  input       [31:0]                                       mc_rf_start_1      ,
  input       [31:0]                                       mc_rf_start_2      ,
  //rf range
  input                                                    rf_range_change_en ,
  input       [ARRAY_ROW_ADDR_WIDTH-1:0]                   rf_start_raddr     ,
  input       [ARRAY_ROW_ADDR_WIDTH-1:0]                   rf_end_raddr       ,

  input                                                    inner_precharge    ,
  output reg                                               rf_req             ,
  output      [4:0]                                        array_fsm_cs       ,
  output      [4:0]                                        array_fsm_ns       ,

  //-------------connect to frame2frame--------------------------
  input                                                    mc_frame_vld       ,
  output                                                   mc_frame_rdy       ,
  input       [MC_FRAME_WIDTH-1:0]                         mc_frame_data      ,
  output                                                   array_rvalid       ,
  output      [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]        array_rdata        ,
  //-------------connect to array------------------------------
  output reg  [MC_SHORT_MODE-1:0]                          bnksel_n           ,
  output reg  [ARRAY_ROW_ADDR_WIDTH-1:0]                   gradd_n            ,
  output reg  [MC_SHORT_MODE-1:0]                          gcas_rd            ,
  output reg  [MC_SHORT_MODE-1:0]                          gcas_wr            ,
  output      [ARRAY_COL_ADDR_WIDTH-1:0]                   gcadd              ,
  //output                                                   wrrdy_n            ,
  output reg  [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]        wdl                ,
  output reg                                               wdl_oe             ,
  input                                                    rdrdy_n            ,
  input       [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]        rdl                ,
  //------------------DFS and refresh-------------------------
  input                                                    mc_rf_start_sel    ,//0:sel input rf start,1:sel mc local cfg
  input       [31:0]                                       rf_start_time      ,//dap_aux cfg rf start time
  input                                                    mc_rf_period_sel   ,//0:sel input rf period,1:sel mc local,default 0

  input       [ARRAY_ROW_ADDR_WIDTH-1:0]                   rf_row_num         ,
  input       [31:0]                                       rf_single_interval ,
  input       [2:0]                                        rf_gear_id         ,//0:64ms,1:32ms,2:16ms,3:8ms,4:4ms
  input                                                    rf_gear_up_en      ,//pulse signal

  //`ifndef COMMON_MC
  //------------------afifo signal----------------------------
  //output                                                   rd_empty           ,
  //input                                                    afifo_push         ,
  //input                                                    afifo_pop          , 
  //`endif
  //------------------debug signal----------------------------
  output reg  [1:0]                                        dbg_w_frame_cnt    ,  
  output reg  [1:0]                                        dbg_r_frame_cnt    ,  
  output reg  [1:0]                                        dbg_r_data_cnt     ,  
  output reg                                               dbg_refresh_flag   ,
  output reg  [4:0]                                        dbg_current_state  ,   
  output reg  [4:0]                                        dbg_next_state     ,
  output                                                   rdrdy_n_monitor    
     
);


localparam  WL_NUM = 7360;
//----------------------------------------------------------------------------
//reg and wire declare
//----------------------------------------------------------------------------
wire                                             mc_frame_rw              ;
wire                                             mc_frame_sof             ;
wire                                             mc_frame_eof             ;
wire [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]       mc_frame_wdata           ;
wire [ARRAY_ROW_ADDR_WIDTH-1:0]                  mc_frame_raddr_l0        ;
wire [ARRAY_ROW_ADDR_WIDTH-1:0]                  mc_frame_raddr_l1        ;
wire [ARRAY_ROW_ADDR_WIDTH-1:0]                  mc_frame_raddr_l2        ;
wire [ARRAY_ROW_ADDR_WIDTH-1:0]                  mc_frame_raddr_l3        ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                  mc_frame_caddr           ;
wire                                             mc_frame_wstrb           ;
wire [1:0]                                       mc_frame_id              ;
reg  [7:0]                                       fsm_dec_cnt              ;
reg  [7:0]                                       ras_dec_cnt              ;
reg  [7:0]                                       twr_dec_cnt              ;
reg  [8*MC_SHORT_MODE-1:0]                       rcd_dec_cnt              ;
reg  [7:0]                                       rcb_dec_cnt              ;
reg  [8*MC_SHORT_MODE-1:0]                       rcd_layer                ;
//reg                                              twr_cnt_vld              ;

reg                                              frame_eof_flag           ;
reg  [1:0]                                       frame_id_flag            ;
reg  [MC_SHORT_MODE-1:0]                         cmd_frame_tmp            ;
reg  [MC_SHORT_MODE-1:0]                         cmd_frame                ;
reg  [MC_SHORT_MODE-1:0]                         cmd_inner_tmp            ;
reg  [MC_SHORT_MODE-1:0]                         cmd_inner                ;
reg  [1:0]                                       act_layer                ;
wire                                             layer_switch             ;
reg                                              bnksel_load              ;
reg                                              step_active              ;
reg                                              frame_rw_flag            ;
reg                                              frame_wstrb_flag         ;
wire                                             precharge_allow          ;
wire                                             precharge_allow_1        ;
wire                                             rcd_allow                ;
wire                                             rcb_allow                ;
wire                                             mc_change_bank_wr_allow  ;
reg  [31:0]                                      rf_cnt;
reg  [ARRAY_ROW_ADDR_WIDTH-1:0]                  rf_graddr_inner          ;
//`ifdef COMMON_MC
wire                                             rd_empty                 ; // wy up mc loopback
//`endif
wire                                             rf_sel_mux_out           ;
reg  [ARRAY_ROW_ADDR_WIDTH-1:0]                  gradd_n_inner_l0         ;
reg  [ARRAY_ROW_ADDR_WIDTH-1:0]                  gradd_n_inner_l1         ;
reg  [ARRAY_ROW_ADDR_WIDTH-1:0]                  gradd_n_inner_l2         ;
reg  [ARRAY_ROW_ADDR_WIDTH-1:0]                  gradd_n_inner_l3         ;
reg  [ARRAY_COL_ADDR_WIDTH-1:0]                  gcadd_inner              ;
wire                                             rdrdy_n_inner            ;
reg  [ARRAY_ROW_ADDR_WIDTH-1:0]                  rf_last_raddr            ;
reg  [31:0]                                      rf_single_interval_new_reg   ;
reg                                              rf_period_up_req         ;

reg  [31:0]                                      period_th                ;
wire [31:0]                                      inside_period            ;
wire [31:0]                                      outside_period           ;
wire [31:0]                                      inside_start             ;
wire [31:0]                                      outside_start            ;

wire                                             rf_cnt_work_en           ;
reg                                              rf_cnt_work_en_dly       ;
reg                                              rf_cnt_work_en_reg       ;
reg  [2:0]                                       rf_gear_id_reg           ;
wire [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]       array_rdata_tmp          ;

reg  [31:0]                                      rf_single_interval_new   ;
//reg                                              rf_start_reg             ;
//wire                                             rf_start_pos             ;
reg                                              rf_start_reg_dly         ;
reg                                              first_up_done            ;
reg  [MC_SHORT_MODE-1:0]                         fake_gcas_wr             ;
reg  [3:0]                                       rd_flowctrl_cnt          ;
wire                                             flowctrl_flag            ;
integer        i;
reg [4:0] FSM_CS;
reg [4:0] FSM_NS;
localparam    FLOWCTRL_TH = 8;
//----------------------------------------------------------------------------
//wire defination
//----------------------------------------------------------------------------
generate 
if(MC_SHORT_MODE==4)begin
assign {mc_frame_wstrb, mc_frame_rw, mc_frame_sof, mc_frame_eof, mc_frame_wdata, mc_frame_id,mc_frame_raddr_l3, mc_frame_raddr_l2, mc_frame_raddr_l1, mc_frame_raddr_l0, mc_frame_caddr} = mc_frame_data ;
end
else if(MC_SHORT_MODE==3)begin
assign mc_frame_raddr_l3 = 'd0;
assign {mc_frame_wstrb, mc_frame_rw, mc_frame_sof, mc_frame_eof, mc_frame_wdata, mc_frame_id,mc_frame_raddr_l2, mc_frame_raddr_l1, mc_frame_raddr_l0, mc_frame_caddr} = mc_frame_data ;
end
else if(MC_SHORT_MODE==2)begin
assign mc_frame_raddr_l2 = 'd0;
assign mc_frame_raddr_l3 = 'd0;

assign {mc_frame_wstrb, mc_frame_rw, mc_frame_sof, mc_frame_eof, mc_frame_wdata, mc_frame_id,mc_frame_raddr_l1, mc_frame_raddr_l0, mc_frame_caddr} = mc_frame_data ;
end
else begin
assign mc_frame_raddr_l1 = 'd0;
assign mc_frame_raddr_l2 = 'd0;
assign mc_frame_raddr_l3 = 'd0;
assign {mc_frame_wstrb, mc_frame_rw, mc_frame_sof, mc_frame_eof, mc_frame_wdata, mc_frame_id,mc_frame_raddr_l0, mc_frame_caddr} = mc_frame_data ;
end
endgenerate
 
//assign rf_start_pos =  rf_start_reg==1'b0 && mc_rf_start ;
//always @(posedge clk or negedge rst_n)begin
//    if(!rst_n)
//        rf_start_reg <= 1'b0;
//    else 
//        rf_start_reg <=  mc_rf_start ;
//end
assign precharge_allow = ras_dec_cnt == 'd0 ;
assign precharge_allow_1 = twr_dec_cnt == 'd0  ;
generate
if(MC_SHORT_MODE==4) begin
    assign rcd_allow = (rcd_dec_cnt[31:24]==8'b0 || mc_frame_id!=2'b11)
                        && (rcd_dec_cnt[23:16]==8'b0 || mc_frame_id!=2'b10)
                        && (rcd_dec_cnt[15:8]==8'b0 || mc_frame_id!=2'b01)
                        && (rcd_dec_cnt[7:0]==8'b0 || mc_frame_id!=2'b00);
end
else if(MC_SHORT_MODE==3) begin
    assign rcd_allow = (rcd_dec_cnt[23:16]==8'b0 || mc_frame_id!=2'b10)
                        && (rcd_dec_cnt[15:8]==8'b0 || mc_frame_id!=2'b01)
                        && (rcd_dec_cnt[7:0]==8'b0 || mc_frame_id!=2'b00);
end
else if(MC_SHORT_MODE==2) begin
    assign rcd_allow = (rcd_dec_cnt[15:8]==8'b0 || mc_frame_id!=2'b01)
                        && (rcd_dec_cnt[7:0]==8'b0 || mc_frame_id!=2'b00);
end
else begin
    assign rcd_allow = rcd_dec_cnt==8'b0 || mc_frame_id!=2'b00;
end
endgenerate
assign rcb_allow = rcb_dec_cnt == 8'd0;
assign array_fsm_cs = FSM_CS ;
assign array_fsm_ns = FSM_NS ;


`ifdef RTLSIM
    assign rdrdy_n_inner = rdrdy_n || mc_rdrdy_n_en;
`else
    wire    rdrdy_n_s;
    //========================DG MC use=====================================
    wl_clk_or rdrdy_n_u0 (.clk_i(rdrdy_n), .clk_en(mc_rdrdy_n_en), .clk_o(rdrdy_n_s));
    wl_clk_mux rdrdy_n_u1 (.clk_i0(rdrdy_n_s), .clk_i1(1'b0), .clk_sel(1'b0), .clk_o(rdrdy_n_inner));
    //========================Common MC use=================================
    //mc_clk_or mc_clk_or_u (.A(rdrdy_n),.B(mc_rdrdy_n_en),.Y(rdrdy_n_inner));
`endif
//assign rdrdy_n_inner = rdrdy_n;
assign rdrdy_n_monitor = rdrdy_n ;
//HSBSVT20_OR2_0P5 U_rdrdy_inner(.A1(mc_rdrdy_n_en   ), .A2(rdrdy_n), .X(rdrdy_n_inner));
//--------------------------------------------------------------------------
//FSM design
//----------------------------------------------------------------------------
localparam  IDLE                 = 5'b00000  ,
            RF_UP_RADDR          = 5'b00001  ,
            RF_TRAS_CNT          = 5'b00011  ,
            RF_PRECHARGE         = 5'b00010  ,
            RF_TRP_CNT           = 5'b00110  ,
            W_UP_RADDR           = 5'b00111  ,
            W_TRCD_CNT           = 5'b00101  ,
            W_DATA               = 5'b00100  ,
            W_DATA_LAST          = 5'b01100  ,
            W_TWR_CNT            = 5'b01101  ,
            W_PRECHARGE          = 5'b01111  ,
            W_TRP_CNT            = 5'b01110  ,
            R_UP_RADDR           = 5'b01010  ,
            R_TRCD_CNT           = 5'b01011  ,
            R_DATA               = 5'b01001  ,
            R_DATA_LAST_WITH_PRE = 5'b01000  ,
            R_DATA_LAST          = 5'b11000  ,
            R_TRTP_CNT           = 5'b11001  ,
            R_PRECHARGE          = 5'b10000  ,
            R_TRP_CNT            = 5'b11010  ,
            WTR_CNT_LOAD         = 5'b11011  ,
            RTW_CNT_LOAD         = 5'b11100  ,

            WTR_CNT              = 5'b11101  ,//add write to read state
            RTW_CNT              = 5'b11110  ;//add read to write state




always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        rf_last_raddr <= 13'h0;
    else if(FSM_CS==IDLE && FSM_NS==RF_UP_RADDR)begin
        if(rf_range_change_en && rf_row_num==WL_NUM)
            rf_last_raddr <= rf_end_raddr;
        else if(!rf_range_change_en && rf_row_num==WL_NUM)
            rf_last_raddr <= WL_NUM-1;
        else if(rf_last_raddr < rf_end_raddr && rf_row_num < WL_NUM)
            rf_last_raddr <= rf_graddr_inner + rf_row_num - 13'h1;
        else if(rf_last_raddr == rf_end_raddr && rf_row_num<WL_NUM) 
            rf_last_raddr <= rf_row_num + rf_start_raddr - 13'h1;
    end
    else
        rf_last_raddr <= rf_last_raddr;
end


always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    FSM_CS <= IDLE ;
  end
  else begin
    FSM_CS <= FSM_NS ;
  end
end

always @(*)
begin
  case(FSM_CS)
    IDLE: begin
      if (rf_req && mc_en && mc_rf_start && mc_rf_en)
        FSM_NS = RF_UP_RADDR;
      else if (mc_frame_vld & mc_frame_rdy & mc_frame_sof & mc_frame_rw & mc_en)
        FSM_NS = W_UP_RADDR;
      else if (mc_frame_vld & mc_frame_rdy & mc_frame_sof & ~mc_frame_rw & mc_en)
        FSM_NS = R_UP_RADDR;
      else
        FSM_NS = FSM_CS;
    end

    RF_UP_RADDR : begin
      FSM_NS = RF_TRAS_CNT;
    end
    RF_TRAS_CNT: begin
      if (fsm_dec_cnt == 8'd0)
        FSM_NS = RF_PRECHARGE;
      else
        FSM_NS = FSM_CS;
    end 
    RF_PRECHARGE : begin
      FSM_NS = RF_TRP_CNT;
    end
    RF_TRP_CNT : begin
      if (fsm_dec_cnt == 8'd0) begin
         if (gradd_n == rf_last_raddr) 
          FSM_NS = IDLE;
        else
          FSM_NS = RF_UP_RADDR;
      end
      else
        FSM_NS = FSM_CS;
    end 

    W_UP_RADDR : begin
      FSM_NS = W_TRCD_CNT;
    end 
    W_TRCD_CNT : begin
      if (fsm_dec_cnt == 8'd0) begin
        if (frame_eof_flag)
          FSM_NS = W_DATA_LAST;
        else
          FSM_NS = W_DATA;
      end 
      else
        FSM_NS = FSM_CS;
    end 
    W_DATA : begin
      if ((mc_frame_vld && mc_frame_rdy && mc_frame_eof && mc_frame_rw)||inner_precharge)//receive write frame
        FSM_NS = W_DATA_LAST;
      else if(mc_frame_vld && mc_frame_rdy && !mc_frame_rw)//receive read frame
        FSM_NS = WTR_CNT_LOAD;
      else
        FSM_NS = FSM_CS;
    end 
    WTR_CNT_LOAD :begin
        FSM_NS = WTR_CNT;
    end
    WTR_CNT : begin
        if(fsm_dec_cnt == 8'd0)begin
            if(frame_eof_flag)begin
                if(mc_trtp_cfg == 0 && precharge_allow && precharge_allow_1)
                    FSM_NS = R_DATA_LAST_WITH_PRE;
                else
                    FSM_NS = R_DATA_LAST;
            end
            else
                FSM_NS = R_DATA;
        end
        else
            FSM_NS = WTR_CNT;
    end

    W_DATA_LAST : begin
      FSM_NS = W_TWR_CNT;
    end 
    W_TWR_CNT : begin
      if (precharge_allow && precharge_allow_1)//ras,twr
        FSM_NS = W_PRECHARGE;
      else
        FSM_NS = FSM_CS;
    end 
    W_PRECHARGE : begin
      FSM_NS = W_TRP_CNT;
    end 
    W_TRP_CNT : begin
      if (fsm_dec_cnt == 8'd0)
        FSM_NS = IDLE;
      else
        FSM_NS = FSM_CS;
    end 

    R_UP_RADDR : begin
      FSM_NS = R_TRCD_CNT;
    end 
    R_TRCD_CNT : begin
      if (fsm_dec_cnt == 8'd0) begin
        if (frame_eof_flag) begin
          if (mc_trtp_cfg == 0 && precharge_allow)
            FSM_NS = R_DATA_LAST_WITH_PRE;
          else
            FSM_NS = R_DATA_LAST;
        end
        else
          FSM_NS = R_DATA;
      end 
      else
        FSM_NS = FSM_CS;
    end 
    R_DATA : begin
      if ((mc_frame_vld && mc_frame_rdy && mc_frame_eof && !mc_frame_rw)||inner_precharge) begin//read frame
        if (mc_trtp_cfg == 0 && precharge_allow && precharge_allow_1)
          FSM_NS = R_DATA_LAST_WITH_PRE;
        else
          FSM_NS = R_DATA_LAST;
      end
      else if(mc_frame_vld && mc_frame_rdy && mc_frame_rw)//write frame
          FSM_NS = RTW_CNT_LOAD;
      else
        FSM_NS = FSM_CS;
    end 
    RTW_CNT_LOAD :begin
        FSM_NS = RTW_CNT;
    end
    RTW_CNT: begin
        if(fsm_dec_cnt == 8'd0)begin
            if(frame_eof_flag)
                FSM_NS = W_DATA_LAST;
            else
                FSM_NS = W_DATA;
        end
        else
            FSM_NS = FSM_CS;
    end
    R_DATA_LAST : begin
      if (mc_trtp_cfg <= 1 && precharge_allow && precharge_allow_1)
        FSM_NS = R_PRECHARGE;
      else
        FSM_NS = R_TRTP_CNT;
    end 
    R_TRTP_CNT : begin
      if (fsm_dec_cnt == 0 && precharge_allow && precharge_allow_1)
        FSM_NS = R_PRECHARGE;
      else
        FSM_NS = FSM_CS;
    end 
    R_PRECHARGE : begin
      FSM_NS = R_TRP_CNT;
    end 
    R_DATA_LAST_WITH_PRE : begin
      FSM_NS = R_TRP_CNT;
    end 
    R_TRP_CNT : begin
      if (fsm_dec_cnt == 8'd0)
        FSM_NS = IDLE;
      else
        FSM_NS = FSM_CS;
    end 
    
    default: FSM_NS = IDLE;
  endcase 
end 

//----------------------------------------------------------------------------
//reg calculation
//----------------------------------------------------------------------------
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    fsm_dec_cnt <= 'd0;
  end
  else begin
    case (FSM_CS)
      RF_UP_RADDR          : fsm_dec_cnt <= mc_trc_cfg - mc_trp_cfg -1;
      RF_PRECHARGE         : fsm_dec_cnt <= ((mc_trp_cfg < 3) ? 3 : mc_trp_cfg) -3;

      W_UP_RADDR           : fsm_dec_cnt <= mc_trcd_cfg -1 ;
      W_DATA_LAST          : fsm_dec_cnt <= mc_twr_cfg -1;
      W_PRECHARGE          : fsm_dec_cnt <= ((mc_trp_cfg < 4) ? 4 : mc_trp_cfg) -4;//-4

      R_UP_RADDR           : fsm_dec_cnt <= mc_trcd_cfg -1;
      R_DATA_LAST          : fsm_dec_cnt <= ((mc_trtp_cfg < 2) ? 2 : mc_trtp_cfg) -2;
      R_DATA_LAST_WITH_PRE : fsm_dec_cnt <= ((mc_trp_cfg < 4) ? 4 : mc_trp_cfg) -4;//-4
      R_PRECHARGE          : fsm_dec_cnt <= ((mc_trp_cfg < 4) ? 4 : mc_trp_cfg) -4;//-2

      WTR_CNT_LOAD         : fsm_dec_cnt <= ((mc_twtr_cfg < 2) ? 2 : mc_twtr_cfg)-2;
      RTW_CNT_LOAD         : fsm_dec_cnt <= ((mc_trtw_cfg < 2) ? 2 : mc_trtw_cfg)-2;

      default              : fsm_dec_cnt <= (fsm_dec_cnt != 0) ? (fsm_dec_cnt -1) : 0;
    endcase
  end
end

generate
if(MC_SHORT_MODE==4) begin
    always @* begin
        case(frame_id_flag)
            2'b00:rcd_layer={8'd6, 8'd4, 8'd2, 8'd0};
            2'b01:rcd_layer={8'd4, 8'd2, 8'd0, 8'd6};
            2'b10:rcd_layer={8'd2, 8'd0, 8'd6, 8'd4};
            2'b11:rcd_layer={8'd0, 8'd6, 8'd4, 8'd2};
        endcase
    end
end
else if(MC_SHORT_MODE==3) begin
    always @* begin
        case(frame_id_flag)
            2'b00:  rcd_layer={8'd4, 8'd2, 8'd0};
            2'b01:  rcd_layer={8'd2, 8'd0, 8'd4};
            2'b10:  rcd_layer={8'd0, 8'd4, 8'd2};
            default:rcd_layer={8'd4, 8'd2, 8'd0};
        endcase
    end
end
else if(MC_SHORT_MODE==2) begin
    always @* begin
        case(frame_id_flag)
            2'b00:  rcd_layer={8'd2, 8'd0};
            2'b01:  rcd_layer={8'd0, 8'd2};
            default:rcd_layer={8'd2, 8'd0};
        endcase
    end
end
else begin
    always @* begin
        rcd_layer = 8'd0;
    end
end
endgenerate

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    rcd_dec_cnt <= 'd0;
  end
  else begin
    if (FSM_CS == R_UP_RADDR || FSM_CS == W_UP_RADDR)
        for(i=0; i<MC_SHORT_MODE; i=i+1)
            rcd_dec_cnt[i*8+:8] <= mc_trcd_cfg - 1 + rcd_layer[i*8+:8];
    else
        for(i=0; i<MC_SHORT_MODE; i=i+1)
            rcd_dec_cnt[i*8+:8] <= (rcd_dec_cnt[i*8+:8]!= 0) ? (rcd_dec_cnt[i*8+:8]-1) : 0 ;
  end
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    rcb_dec_cnt <= 'd0;
  end
  else begin
    if (mc_frame_vld && mc_frame_rdy && !mc_frame_rw)
      rcb_dec_cnt <= {{6'b0}, {mc_trcb_cfg}};
    else if(FSM_CS==WTR_CNT || FSM_CS==R_TRCD_CNT)
      rcb_dec_cnt <= {{6'b0}, {mc_trcb_cfg}};
    else      
      rcb_dec_cnt <= (rcb_dec_cnt != 0) ? (rcb_dec_cnt -1) : 0 ;
  end
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    ras_dec_cnt <= 'd0;
  end
  else begin
    if (FSM_CS == R_UP_RADDR || FSM_CS == W_UP_RADDR)
      ras_dec_cnt <= mc_all_bank_act_en ? mc_tras_cfg +2*(MC_SHORT_MODE-1)-1 : mc_tras_cfg-1;
    else
      ras_dec_cnt <= (ras_dec_cnt != 0) ? (ras_dec_cnt -1) : 0 ;
  end
end

//20250408 add by hy
//wire    s_twr_dec_cona;
//wire    s_twr_dec_conb;
//assign  s_twr_dec_cona = (FSM_CS == W_DATA && mc_frame_vld && mc_frame_rw && mc_frame_rdy && !mc_frame_wstrb);
//assign  s_twr_dec_conb = (FSM_CS == W_TRCD_CNT && fsm_dec_cnt == 8'd0 && !frame_wstrb_flag);
//end by hy

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    twr_dec_cnt <= 'd0;
end
  else begin
//    if (gcas_wr || FSM_NS==W_DATA_LAST || (FSM_CS == W_DATA && mc_frame_vld && (~gcas_wr) && mc_frame_rw && mc_frame_rdy && !mc_frame_wstrb) || (FSM_CS == W_TRCD_CNT && fsm_dec_cnt == 8'd0 && !frame_wstrb_flag))
//    if (|gcas_wr || FSM_NS==W_DATA_LAST || s_twr_dec_cona || s_twr_dec_conb) //20250408 add by hy
    if (|gcas_wr || |fake_gcas_wr) //20250408 add by hy

      twr_dec_cnt <= mc_twr_cfg -1;
    else
      twr_dec_cnt <= (twr_dec_cnt != 0) ? (twr_dec_cnt -1) : 0 ;
  end
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    frame_eof_flag <= 1'b0;
  end
  else begin
    if (mc_frame_vld && mc_frame_rdy)
      frame_eof_flag <= mc_frame_eof;
  end
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    frame_wstrb_flag <= 1'b0;
  end
  else begin
    if (mc_frame_vld && mc_frame_rdy)
       frame_wstrb_flag <= mc_frame_wstrb;
  end
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    frame_rw_flag <= 1'b0;
  end
  else begin
    if (mc_frame_vld && mc_frame_rdy)
       frame_rw_flag <= mc_frame_rw;
  end
end
//----------------------------------------------------------------------------
//refresh logic
//----------------------------------------------------------------------------

assign rf_sel_mux_out = global_rf_sel_en ? global_rf_sel : mc_rf_cfg_sel;

assign rf_cnt_work_en = mc_en && mc_rf_start ;
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        rf_cnt_work_en_dly <= 1'b0;
    else 
        rf_cnt_work_en_dly <= rf_cnt_work_en ;
end

always @(posedge clk)begin
    if(global_rf_cnt_clr)
        rf_cnt_work_en_reg <= 1'b0 ;
    else if({rf_cnt_work_en_dly,rf_cnt_work_en}==2'b01)
        rf_cnt_work_en_reg <= 1'b1 ;
end

always @(posedge clk)begin
  if (global_rf_cnt_clr)
    rf_cnt <= 'd0;
  else begin
    if (rf_cnt_work_en_reg && (rf_cnt < period_th-1'b1))
      rf_cnt <= rf_cnt +1 ;
    else
      rf_cnt <= 'd0;
  end
end

always @(posedge clk or negedge rst_n)
begin
    if (rst_n == 1'b0) begin
    rf_req <= 1'b0;
end
  else begin
    if (mc_en && mc_rf_start && (rf_cnt ==(mc_rf_start_sel ? inside_start : outside_start)) && mc_rf_en)
      rf_req <= 1'b1;
    else if (FSM_CS == IDLE)
      rf_req <= 1'b0;
  end
end

assign inside_period = rf_sel_mux_out ? mc_rf_period_2 : mc_rf_period_1 ;
assign inside_start = rf_sel_mux_out ? mc_rf_start_2 : mc_rf_start_1 ;
assign outside_start = rf_start_time;
//-------------rf period update-------------------//
/*
always @(*)begin
    if (mc_rf_start)begin
        if(rf_gear_id > rf_gear_id_reg && rf_gear_up_en)//new>old
            rf_single_interval_new = rf_single_interval_new_reg >> (rf_gear_id-rf_gear_id_reg) ;
        else if(rf_gear_id < rf_gear_id_reg && rf_gear_up_en)//old>new
            rf_single_interval_new = rf_single_interval_new_reg << (rf_gear_id_reg-rf_gear_id);
        else
            rf_single_interval_new = period_th ;
    end
    else begin
        rf_single_interval_new = rf_single_interval;
    end
end
*/
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        first_up_done <= 1'b0;
    else if(rf_gear_up_en)
        first_up_done <= 1'b1;
end
always @(*)begin
    if(rf_gear_up_en)
        rf_single_interval_new = rf_single_interval >> rf_gear_id ;
    else
        rf_single_interval_new = rf_single_interval ;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        rf_single_interval_new_reg <= 32'd0;
    else if(rf_gear_up_en || (first_up_done && rf_gear_up_en))
        rf_single_interval_new_reg <= rf_single_interval_new;
    else if(!first_up_done && !rf_gear_up_en)
        rf_single_interval_new_reg <= rf_single_interval;
    else
        rf_single_interval_new_reg <= rf_single_interval_new_reg;
end


//always @(posedge clk or negedge rst_n)begin
//    if(!rst_n)
//        rf_gear_id_reg <= 3'd0;
//    else if(rf_start_pos ||rf_gear_up_en)
//        rf_gear_id_reg <= rf_gear_id;
//    //else if(rf_gear_up_en)
//    //    rf_gear_id_reg <= rf_gear_id;
//end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        rf_period_up_req <= 1'b0;
    else if(rf_period_up_req && !rf_gear_up_en) begin
        if(rf_single_interval_new_reg > period_th)//small to big
            rf_period_up_req <= 1'b0;
        else if(rf_single_interval_new_reg < period_th && rf_cnt<(rf_single_interval_new_reg-5))//big to small
            rf_period_up_req <= 1'b0;
        else if(rf_single_interval_new_reg == period_th)
            rf_period_up_req <= 1'b0;  
        else 
            rf_period_up_req <= rf_period_up_req;
    end
    else if(rf_gear_up_en && !mc_rf_period_sel)
        rf_period_up_req <= 1'b1;
    end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        period_th <= 32'h0;
//    else if(rf_start_pos && !rf_gear_up_en)
//        period_th <= rf_single_interval;
    else if(!mc_rf_period_sel)begin
        if(rf_period_up_req && first_up_done)begin
            if(period_th < rf_single_interval_new_reg)
                period_th <= rf_single_interval_new_reg;
            else if(rf_single_interval_new_reg < period_th && rf_cnt<(rf_single_interval_new_reg-5))
                period_th <= rf_single_interval_new_reg;
        end
        else if(!first_up_done) 
            period_th <= rf_single_interval;
    end
    else
        period_th <= inside_period;
end
/*
always @(posedge clk or negedge rst_n)
begin
    if (rst_n == 1'b0) begin
    rf_graddr_inner <= 'd0;
  end
  else begin
    if (FSM_CS == IDLE )
      rf_graddr_inner <= 'd0;
    else if (FSM_CS == RF_UP_RADDR)
      rf_graddr_inner <= rf_graddr_inner +1;
  end
end
*/
always @(posedge clk or negedge rst_n)
begin
    if (rst_n == 1'b0) begin
    rf_graddr_inner <= 'd0;
  end
  else begin
    if (FSM_CS == IDLE && rf_range_change_en==1'b0 && rf_row_num==WL_NUM)
        rf_graddr_inner <= 'd0;
    else if(FSM_CS == IDLE && rf_range_change_en==1'b1 && rf_row_num==WL_NUM)
        rf_graddr_inner <= rf_start_raddr;
    else if(FSM_CS == IDLE && (rf_graddr_inner=='d0 || rf_graddr_inner==rf_end_raddr+1'b1) && rf_row_num < WL_NUM)
        rf_graddr_inner <= rf_start_raddr;
    else if(FSM_CS == RF_UP_RADDR && rf_graddr_inner==rf_end_raddr && rf_row_num < WL_NUM)//last row
        rf_graddr_inner <= rf_start_raddr;
    else if(FSM_CS == RF_UP_RADDR && rf_graddr_inner==rf_last_raddr && rf_row_num == WL_NUM && rf_range_change_en)//last row
        rf_graddr_inner <= rf_start_raddr;
    else if(FSM_CS == RF_UP_RADDR && rf_graddr_inner==rf_last_raddr && rf_row_num == WL_NUM && !rf_range_change_en)//last row
        rf_graddr_inner <= 'd0;
    else if (FSM_CS == RF_UP_RADDR)
        rf_graddr_inner <= rf_graddr_inner +1;
  end
end
//----------------------------------------------------------------------------
//output for axi2frame
//----------------------------------------------------------------------------

    assign mc_frame_rdy = ((FSM_CS == IDLE   && ~rf_req ) || 
                          (FSM_CS == W_DATA && ~inner_precharge) ||
                          (FSM_CS == R_DATA && ~inner_precharge)) &&
                          mc_change_bank_wr_allow;
    assign mc_change_bank_wr_allow = (~layer_switch||(layer_switch&&(rcd_allow&&(rcb_allow||frame_rw_flag))));
    //assign mc_frame_rdy = (FSM_CS == IDLE   && ~rf_req ) || (FSM_CS == W_DATA  && send_eof_flag==0) || (FSM_CS == R_DATA ) ;
    assign array_rvalid = ~rd_empty; //wy up loopback
    ////--------------rd frame flowctrl--------------------////
    DW_fifo_s2_sf #(
            .width      (ARRAY_DATA_WIDTH+CHECKBIT_WIDTH) , 
            .depth      (11), 
            .push_ae_lvl(2) , 
            .push_af_lvl(2) , 
            .pop_ae_lvl (2) ,
            .pop_af_lvl (2) , 
            .err_mode   (0) , 
            .push_sync  (2) , 
            .pop_sync   (2) , 
            .rst_mode   (0)
        )U_rdata_async_fifo(
                .clk_push     (rdrdy_n_inner), 
                .clk_pop      (clk),
                .rst_n        (rst_n), 
                .push_req_n   (1'b0), // wy up loopback
                .pop_req_n    (rd_empty), // wy up loopback
                .data_in      (rdl),
                .push_empty   (), 
                .push_ae      (),
                .push_hf      (),
                .push_af      (),
                .push_full    (), 
                .push_error   (),
                .pop_empty    (rd_empty), 
                .pop_ae       (),
                .pop_hf       (), 
                .pop_af       (),
                .pop_full     (), 
                .pop_error    (),
                .data_out     (array_rdata_tmp) 
            );

assign array_rdata = mc_rdata_invert_sel ? {array_rdata_tmp[ARRAY_DATA_WIDTH-1:0],array_rdata_tmp[ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1 -:CHECKBIT_WIDTH]} : array_rdata_tmp ;
//----------------------------------------------------------------------------
//output for array
//----------------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        bnksel_load <= 1'b1;
    end
    else if(FSM_CS==W_UP_RADDR||FSM_CS==R_UP_RADDR) begin
        bnksel_load <= 1'b0;
    end
    else if(step_active) begin
        bnksel_load <= ~bnksel_load;
    end
end

generate
if(MC_SHORT_MODE==4) begin
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            step_active <= 1'b0;
        end
        else if((FSM_CS==W_UP_RADDR||FSM_CS==R_UP_RADDR)&&mc_all_bank_act_en) begin
            step_active <= 1'b1;
        end
        else if((bnksel_n==4'b1||bnksel_n==4'd2||bnksel_n==4'd4||bnksel_n==4'd8)&&bnksel_load) begin
            step_active <= 1'b0;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            bnksel_n <= {MC_SHORT_MODE{1'b1}};
        else if (FSM_CS == RF_UP_RADDR)
            bnksel_n <= {MC_SHORT_MODE{1'b0}};
        else if (FSM_CS == W_UP_RADDR || FSM_CS == R_UP_RADDR) begin
            case(frame_id_flag)
                2'b00: bnksel_n <= {{(MC_SHORT_MODE-1){1'b1}},1'b0   };
                2'b01: bnksel_n <= {{(MC_SHORT_MODE-2){1'b1}},2'b01  };
                2'b10: bnksel_n <= {{(MC_SHORT_MODE-3){1'b1}},3'b011 };
                2'b11: bnksel_n <= 4'b0111;
            endcase
        end
        else if (step_active && bnksel_load)
            bnksel_n <= bnksel_n & {bnksel_n[MC_SHORT_MODE-2:0],bnksel_n[MC_SHORT_MODE-1]};
        else if (FSM_NS == RF_PRECHARGE || FSM_NS == W_PRECHARGE || FSM_NS == R_PRECHARGE || FSM_NS == R_DATA_LAST_WITH_PRE)
            bnksel_n <= {MC_SHORT_MODE{1'b1}};
    end
end
else if(MC_SHORT_MODE==3) begin
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            step_active <= 1'b0;
        end
        else if((FSM_CS==W_UP_RADDR||FSM_CS==R_UP_RADDR) && mc_all_bank_act_en) begin
            step_active <= 1'b1;
        end
        else if((bnksel_n==4'b1||bnksel_n==4'd2||bnksel_n==4'd4)&&bnksel_load) begin
            step_active <= 1'b0;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            bnksel_n <= {MC_SHORT_MODE{1'b1}};
        else if (FSM_CS == RF_UP_RADDR)
            bnksel_n <= {MC_SHORT_MODE{1'b0}};
        else if (FSM_CS == W_UP_RADDR || FSM_CS == R_UP_RADDR) begin
            case(frame_id_flag)
                2'b00: bnksel_n <= {{(MC_SHORT_MODE-1){1'b1}},1'b0   };
                2'b01: bnksel_n <= {{(MC_SHORT_MODE-2){1'b1}},2'b01  };
                2'b10: bnksel_n <= 3'b011 ;
                default: bnksel_n <= {MC_SHORT_MODE{1'b1}};
            endcase
        end
        else if (step_active && bnksel_load)
            bnksel_n <= bnksel_n & {bnksel_n[MC_SHORT_MODE-2:0],bnksel_n[MC_SHORT_MODE-1]};
        else if (FSM_NS == RF_PRECHARGE || FSM_NS == W_PRECHARGE || FSM_NS == R_PRECHARGE || FSM_NS == R_DATA_LAST_WITH_PRE)
            bnksel_n <= {MC_SHORT_MODE{1'b1}};
    end
end
else if(MC_SHORT_MODE==2) begin
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            step_active <= 1'b0;
        end
        else if((FSM_CS==W_UP_RADDR||FSM_CS==R_UP_RADDR)&&mc_all_bank_act_en) begin
            step_active <= 1'b1;
        end
        else if((bnksel_n==4'b1||bnksel_n==4'd2)&&bnksel_load) begin
            step_active <= 1'b0;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            bnksel_n <= {MC_SHORT_MODE{1'b1}};
        else if (FSM_CS == RF_UP_RADDR)
            bnksel_n <= {MC_SHORT_MODE{1'b0}};
        else if (FSM_CS == W_UP_RADDR || FSM_CS == R_UP_RADDR) begin
            case(frame_id_flag)
                2'b00: bnksel_n <= {{(MC_SHORT_MODE-1){1'b1}},1'b0   };
                2'b01: bnksel_n <= 2'b01  ;
                default: bnksel_n <= {MC_SHORT_MODE{1'b1}};
            endcase
        end
        else if (step_active && bnksel_load)
            bnksel_n <= bnksel_n & {bnksel_n[MC_SHORT_MODE-2:0],bnksel_n[MC_SHORT_MODE-1]};
        else if (FSM_NS == RF_PRECHARGE || FSM_NS == W_PRECHARGE || FSM_NS == R_PRECHARGE || FSM_NS == R_DATA_LAST_WITH_PRE)
            bnksel_n <= {MC_SHORT_MODE{1'b1}};
    end
end
else begin
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            step_active <= 1'b0;
        else 
            step_active <= 1'b0;
    end
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0)
            bnksel_n <= {MC_SHORT_MODE{1'b1}};
        else if (FSM_CS == RF_UP_RADDR)
            bnksel_n <= {MC_SHORT_MODE{1'b0}};
        else if (FSM_CS == W_UP_RADDR || FSM_CS == R_UP_RADDR)
            bnksel_n <= {MC_SHORT_MODE{1'b0}};
        else if (FSM_NS == RF_PRECHARGE || FSM_NS == W_PRECHARGE || FSM_NS == R_PRECHARGE || FSM_NS == R_DATA_LAST_WITH_PRE)
            bnksel_n <= {MC_SHORT_MODE{1'b1}};
    end
end
endgenerate


always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0)
        act_layer <= 2'b00;
    else if (FSM_CS == RF_UP_RADDR)
        act_layer <= 2'b00;
    else if (FSM_CS == W_UP_RADDR || FSM_CS == R_UP_RADDR) begin
        case(frame_id_flag)
            2'b00: act_layer <= 2'b00;
            2'b01: act_layer <= 2'b01;
            2'b10: act_layer <= 2'b10;
            2'b11: act_layer <= 2'b11;
        endcase
    end
    else if (step_active && bnksel_load && ((MC_SHORT_MODE==4 && act_layer==2'd3)||(MC_SHORT_MODE==3&& act_layer==2'd2)||(MC_SHORT_MODE==2 && act_layer==2'd1)||(MC_SHORT_MODE==1 && act_layer==2'd0)))
        act_layer <= 2'b00;
    else if (step_active && bnksel_load)
        act_layer <= act_layer + 1'b1;
    else if (FSM_NS == RF_PRECHARGE || FSM_NS == W_PRECHARGE || FSM_NS == R_PRECHARGE || FSM_NS == R_DATA_LAST_WITH_PRE)
        act_layer <= 2'b00;
    end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) 
    frame_id_flag <= 'd0;
  else if (FSM_CS == IDLE && FSM_NS == R_UP_RADDR)
    frame_id_flag <= mc_frame_id;
  else if (FSM_CS == R_DATA && mc_frame_vld && mc_frame_rdy)
    frame_id_flag <= mc_frame_id;
  else if (FSM_CS == IDLE && FSM_NS == W_UP_RADDR)
    frame_id_flag <= mc_frame_id;
  else if (FSM_CS == W_DATA && mc_frame_vld && mc_frame_rdy)
    frame_id_flag <= mc_frame_id;
end

assign layer_switch = mc_all_bank_act_en && (frame_id_flag!=mc_frame_id);

always @(posedge clk or negedge rst_n)
begin
    if (rst_n == 1'b0) begin
    gradd_n_inner_l0 <= 'd0;
    gradd_n_inner_l1 <= 'd0;
    gradd_n_inner_l2 <= 'd0;
    gradd_n_inner_l3 <= 'd0;
  end
  else begin
    if (FSM_CS == IDLE && (FSM_NS == W_UP_RADDR || FSM_NS == R_UP_RADDR)) begin
      gradd_n_inner_l0 <= mc_frame_raddr_l0 ;
      gradd_n_inner_l1 <= mc_frame_raddr_l1 ;
      gradd_n_inner_l2 <= mc_frame_raddr_l2 ;
      gradd_n_inner_l3 <= mc_frame_raddr_l3 ;
    end
    else if (FSM_CS == IDLE && FSM_NS == RF_UP_RADDR && rf_range_change_en==1'b0 && rf_row_num==WL_NUM) begin
      gradd_n_inner_l0 <= 'd0;
      gradd_n_inner_l1 <= 'd0;
      gradd_n_inner_l2 <= 'd0;
      gradd_n_inner_l3 <= 'd0;
//    else if (FSM_CS == IDLE && FSM_NS == RF_UP_RADDR && rf_range_change_en==1'b1 && rf_row_num==WL_NUM)
//      gradd_n_inner <= rf_graddr_inner ;
    end
    else if (FSM_CS == IDLE && FSM_NS == RF_UP_RADDR && rf_row_num<WL_NUM) begin
      gradd_n_inner_l0 <= rf_graddr_inner;
      gradd_n_inner_l1 <= rf_graddr_inner;
      gradd_n_inner_l2 <= rf_graddr_inner;
      gradd_n_inner_l3 <= rf_graddr_inner;
    end
    else if(FSM_CS == IDLE && FSM_NS == RF_UP_RADDR && rf_row_num==WL_NUM && rf_range_change_en) begin
      gradd_n_inner_l0 <= rf_start_raddr;
      gradd_n_inner_l1 <= rf_start_raddr;
      gradd_n_inner_l2 <= rf_start_raddr;
      gradd_n_inner_l3 <= rf_start_raddr;
    end
    else if (FSM_CS == RF_TRP_CNT && FSM_NS == RF_UP_RADDR) begin
      gradd_n_inner_l0 <= rf_graddr_inner;
      gradd_n_inner_l1 <= rf_graddr_inner;
      gradd_n_inner_l2 <= rf_graddr_inner;
      gradd_n_inner_l3 <= rf_graddr_inner;
    end
  end
end


//assign gradd_n = (gradd_n_inner > 13'b1_0011_1111_1111) ? (gradd_n_inner - 13'b1_0011_1111_1111 - 13'b1) : gradd_n_inner ;
always @* begin
    case(act_layer)
        2'b00: gradd_n = gradd_n_inner_l0;
        2'b01: gradd_n = gradd_n_inner_l1;
        2'b10: gradd_n = gradd_n_inner_l2;
        2'b11: gradd_n = gradd_n_inner_l3;
        default: gradd_n = 'd0;
    endcase
end
/*
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0)
    gcas_rd <= 1'b0 ;
  else begin
    if (FSM_CS == R_TRCD_CNT && fsm_dec_cnt == 8'd0)
      gcas_rd <= 1'b1 ;
    else if (FSM_CS == R_DATA && mc_frame_vld && (~gcas_rd) && (~mc_frame_rw) && mc_frame_rdy)
      gcas_rd <= 1'b1 ;
    else if(FSM_CS ==  WTR_CNT && fsm_dec_cnt == 8'd0)
      gcas_rd <= 1'b1 ;
    else
      gcas_rd <= 1'b0 ;
    end
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0)
    gcas_wr <= 1'b0 ;
  else begin
    if (FSM_CS == W_TRCD_CNT && fsm_dec_cnt == 8'd0 && frame_wstrb_flag)
        gcas_wr <= 1'b1 ;
    else if(FSM_CS ==  RTW_CNT && fsm_dec_cnt == 8'd0 && frame_wstrb_flag)
        gcas_wr <= 1'b1 ;
    else if (FSM_CS == W_DATA && mc_frame_vld && (~gcas_wr) && mc_frame_rw && mc_frame_rdy && mc_frame_wstrb)
        gcas_wr <= 1'b1 ;
    else
      gcas_wr <= 1'b0 ;
  end
end
*/

generate
if(MC_SHORT_MODE==4)begin:u0
always @(*) begin
    case(mc_frame_id)
        2'b00: cmd_frame = 4'b0001;
        2'b01: cmd_frame = 4'b0010;
        2'b10: cmd_frame = 4'b0100;
        2'b11: cmd_frame = 4'b1000;
        default:;
    endcase
end

always @(*) begin
    case(frame_id_flag)
        2'b00: cmd_inner = 4'b0001;
        2'b01: cmd_inner = 4'b0010;
        2'b10: cmd_inner = 4'b0100;
        2'b11: cmd_inner = 4'b1000;
        default:;
    endcase
end

end
else if(MC_SHORT_MODE==3)begin:u1

always @(*) begin
    case(mc_frame_id)
        2'b00: cmd_frame = 3'b001;
        2'b01: cmd_frame = 3'b010;
        2'b10: cmd_frame = 3'b100;
        default:cmd_frame = 3'b001;
    endcase
end

always @(*) begin
    case(frame_id_flag)
        2'b00: cmd_inner = 3'b001;
        2'b01: cmd_inner = 3'b010;
        2'b10: cmd_inner = 3'b100;
        default:cmd_inner = 3'b001;
    endcase
end
end
else if (MC_SHORT_MODE==2)begin:u2
always @(*) begin
    case(mc_frame_id)
        2'b00: cmd_frame = 2'b01;
        2'b01: cmd_frame = 2'b10;
        default:cmd_frame = 2'b01;
    endcase
end

always @(*) begin
    case(frame_id_flag)
        2'b00: cmd_inner = 2'b01;
        2'b01: cmd_inner = 2'b10;
        default:cmd_inner = 2'b01;
    endcase
end

end
else begin:u3
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0)begin
        cmd_frame_tmp <=  1'b1;
        cmd_inner_tmp <=  1'b1;
    end
    else begin
        cmd_frame_tmp <= cmd_frame_tmp;
        cmd_inner_tmp <= cmd_inner_tmp;
    end
end

always @(*) begin
    cmd_frame = cmd_frame_tmp;
end

always @(*) begin
    cmd_inner = cmd_inner_tmp;
end    
//always @(*) begin
//    cmd_frame = 1'b0;
//end
//
//always @(*) begin
//    cmd_inner = 1'b0;
//end
end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0)
        gcas_rd <= {MC_SHORT_MODE{1'b0}} ;
    else begin
        if (FSM_CS == R_TRCD_CNT && fsm_dec_cnt == 8'd0 && frame_wstrb_flag)
            gcas_rd <= cmd_inner ;
        else if (FSM_CS == R_DATA && mc_frame_vld && (~mc_frame_rw) && mc_frame_rdy && mc_frame_wstrb)
            gcas_rd <= cmd_frame ;
        else if (FSM_CS ==  WTR_CNT && fsm_dec_cnt == 8'd0 && frame_wstrb_flag)
            gcas_rd <= cmd_inner ;
        else
            gcas_rd <= {MC_SHORT_MODE{1'b0}};
    end
end

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0)
      gcas_wr <= {MC_SHORT_MODE{1'b0}} ;
    else begin
        if (FSM_CS == W_TRCD_CNT && fsm_dec_cnt == 8'd0 && frame_wstrb_flag)
            gcas_wr <= cmd_inner ;
        else if(FSM_CS ==  RTW_CNT && fsm_dec_cnt == 8'd0 && frame_wstrb_flag)
            gcas_wr <= cmd_inner ;
        else if (FSM_CS == W_DATA && mc_frame_vld && mc_frame_rw && mc_frame_rdy && mc_frame_wstrb)
            gcas_wr <= cmd_frame ;
        else
            gcas_wr <= {MC_SHORT_MODE{1'b0}} ;
  end
end


always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0)
      fake_gcas_wr <= {MC_SHORT_MODE{1'b0}} ;
    else begin
        if (FSM_CS == W_TRCD_CNT && fsm_dec_cnt == 8'd0 && !frame_wstrb_flag)
            fake_gcas_wr <= cmd_inner ;
        else if(FSM_CS ==  RTW_CNT && fsm_dec_cnt == 8'd0 && !frame_wstrb_flag)
            fake_gcas_wr <= cmd_inner ;
        else if (FSM_CS == W_DATA && mc_frame_vld && mc_frame_rw && mc_frame_rdy && !mc_frame_wstrb)
            fake_gcas_wr <= cmd_frame ;
        else
            fake_gcas_wr <= {MC_SHORT_MODE{1'b0}} ;
  end
end
/*
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    gcadd_rd <= 'd0;
    gcadd_wr <= 'd0;
    wdl <= 'd0;
  end
  else begin
    if (FSM_CS == IDLE && FSM_NS == R_UP_RADDR)
      gcadd_rd <= mc_frame_caddr;
    else if (FSM_CS == R_DATA && mc_frame_vld && (~gcas_rd))
      gcadd_rd <= mc_frame_caddr;

    if (FSM_CS == IDLE && FSM_NS == W_UP_RADDR) begin
      gcadd_wr <= mc_frame_caddr;
      wdl <= mc_frame_wdata;
    end
    else if (FSM_CS == W_DATA && mc_frame_vld && (~gcas_wr)) begin
      gcadd_wr <= mc_frame_caddr;
      wdl <= mc_frame_wdata;
    end
  end
end 
*/
/*
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    gcas_rd <= 1'b0 ;
    gcas_wr <= 1'b0 ;
  end
  else begin
    if (FSM_CS == R_TRCD_CNT && fsm_dec_cnt == 8'd0)
      gcas_rd <= 1'b1 ;
    else if (FSM_CS == R_DATA && mc_frame_vld)
      gcas_rd <= 1'b1 ;
    else
      gcas_rd <= 1'b0 ;

    if (FSM_CS == W_TRCD_CNT && fsm_dec_cnt == 8'd0)
      gcas_wr <= 1'b1 ;
    else if (FSM_CS == W_DATA && mc_frame_vld)
      gcas_wr <= 1'b1 ;
    else
      gcas_wr <= 1'b0 ;
  end
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) 
    gcadd_inner <= 'd0;
  else if (FSM_CS == IDLE && FSM_NS == R_UP_RADDR)
    gcadd_inner <= mc_frame_caddr;
  else if (FSM_CS == R_DATA && mc_frame_vld && (~gcas_rd) && mc_frame_rdy)
    gcadd_inner <= mc_frame_caddr;
  else if (FSM_CS == IDLE && FSM_NS == W_UP_RADDR)
    gcadd_inner <= mc_frame_caddr;
  else if (FSM_CS == W_DATA && mc_frame_vld && (~gcas_wr) && mc_frame_rdy)
    gcadd_inner <= mc_frame_caddr;
end
*/
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) 
    gcadd_inner <= 'd0;
  else if (FSM_CS == IDLE && FSM_NS == R_UP_RADDR)
    gcadd_inner <= mc_frame_caddr;
  else if (FSM_CS == R_DATA && mc_frame_vld && mc_frame_rdy)
    gcadd_inner <= mc_frame_caddr;
  else if (FSM_CS == IDLE && FSM_NS == W_UP_RADDR)
    gcadd_inner <= mc_frame_caddr;
  else if (FSM_CS == W_DATA && mc_frame_vld && mc_frame_rdy)
    gcadd_inner <= mc_frame_caddr;
end


//assign gcadd = (gcadd_inner > 7'b100_0111) ? (gcadd_inner - 7'b100_0111 - 7'b1) : gcadd_inner ;
assign gcadd = gcadd_inner ;

/*
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) 
      wdl <= 'd0;
  else if (FSM_CS == IDLE && FSM_NS == W_UP_RADDR)
      wdl <= mc_frame_wdata;
  else if (FSM_CS == W_DATA && mc_frame_vld ) 
      wdl <= mc_frame_wdata;
end 
*/
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) 
      wdl <= 'd0;
  else if (FSM_CS == IDLE && FSM_NS == W_UP_RADDR)
      wdl <= mc_frame_wdata;
  else if (FSM_CS == W_DATA && mc_frame_vld) 
      wdl <= mc_frame_wdata;
  else if(FSM_CS == R_DATA && FSM_NS == RTW_CNT_LOAD)
      wdl <= mc_frame_wdata;
end 

//assign wrrdy_n = ~gcas_wr ;
/*
always @(posedge clk or negedge rst_n)
begin
    if (rst_n == 1'b0) begin
    wdl_oe <= 1'b0;
  end
  else begin
    if (FSM_CS == W_TRCD_CNT && fsm_dec_cnt == 8'd0 && frame_wstrb_flag)
      wdl_oe <= 1'b1;
    else if((FSM_CS == W_DATA || FSM_CS == RTW_CNT_LOAD) && mc_frame_vld && mc_frame_rdy && mc_frame_wstrb)
      wdl_oe <= 1'b1;
    else if((FSM_CS == W_DATA || FSM_CS == RTW_CNT_LOAD) && mc_frame_vld && mc_frame_rdy && !mc_frame_wstrb)
      wdl_oe <= 1'b0;
//    else if (FSM_CS == W_TWR_CNT && fsm_dec_cnt == mc_twr_cfg-1)
    else if ((FSM_CS == W_TWR_CNT && fsm_dec_cnt == mc_twr_cfg-1) || FSM_CS==WTR_CNT_LOAD)
      wdl_oe <= 1'b0;
  end
end
*/
always @(posedge clk or negedge rst_n)
begin
    if (rst_n == 1'b0) begin
    wdl_oe <= 1'b0;
  end
  else begin
    if ((FSM_CS == W_TRCD_CNT && fsm_dec_cnt == 8'd0) || (FSM_CS==RTW_CNT && fsm_dec_cnt == 8'd0))
      wdl_oe <= 1'b1;
    else if ((FSM_CS == W_TWR_CNT) || FSM_CS==WTR_CNT_LOAD)
      wdl_oe <= 1'b0;
  end
end

//----------------------------------------------------------------------------
//debug
//----------------------------------------------------------------------------
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        dbg_w_frame_cnt <= 2'd0;
    else if(ras_clr)
        dbg_w_frame_cnt <= 2'd0;
    else if(dbg_w_frame_cnt==2'd3)
        dbg_w_frame_cnt <= dbg_w_frame_cnt;
    else if(mc_frame_rw & mc_frame_vld & mc_frame_rdy)
        dbg_w_frame_cnt <= dbg_w_frame_cnt + 1'b1;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        dbg_r_frame_cnt <= 2'd0;
    else if(ras_clr)
        dbg_r_frame_cnt <= 2'd0;
    else if(dbg_r_frame_cnt==2'd3)
        dbg_r_frame_cnt <= dbg_r_frame_cnt;
    else if(~mc_frame_rw & mc_frame_vld & mc_frame_rdy)
        dbg_r_frame_cnt <= dbg_r_frame_cnt + 1'b1;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        dbg_refresh_flag <= 1'b0;
    else if(ras_clr)
        dbg_refresh_flag <= 1'b0;
    else if(FSM_CS==RF_UP_RADDR)
        dbg_refresh_flag <= 1'b1;
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        dbg_r_data_cnt <= 2'd0;
    else if(ras_clr)
        dbg_r_data_cnt <= 2'd0;
    else if(dbg_r_data_cnt==2'd3)
        dbg_r_data_cnt <= dbg_r_data_cnt;
    else if(array_rvalid)
        dbg_r_data_cnt <= dbg_r_data_cnt + 1'b1;
    end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        dbg_current_state <= 5'd0;
        dbg_next_state    <= 5'd0;
    end
    else begin
        dbg_current_state <= FSM_CS;
        dbg_next_state    <= FSM_NS;
    end
end


endmodule
