module frame2array_aux #(
  parameter  ARRAY_DATA_WIDTH      = 256,
  parameter  ARRAY_ROW_ADDR_WIDTH  = 13,
  parameter  ARRAY_COL_ADDR_WIDTH  = 8,
  parameter  CHECKBIT_WIDTH        = 10,
  parameter  MC_FRAME_WIDTH        = 292,
  parameter  ARRAY_RSV_WIDTH       = 6
)(
  //-------------clock and reset-------------------------------
  input                                                             clk               ,
  input                                                             rst_n             ,
  input                                                             ras_clr           ,
  //-------------apb config-----------------------------------
  input                                                             mc_en             ,
  input                                                             mc_rf_start       ,
  input                                                             global_rf_sel_en  , 
  input                                                             global_rf_cnt_clr ,
  input                                                             global_rf_sel     , 
  input                                                             mc_rf_cfg_sel     ,

  input       [5:0]                                                 mc_trc_cfg        ,//active to active time
  input       [4:0]                                                 mc_tras_cfg       ,//rcd active to precharge time
  input       [3:0]                                                 mc_trp_cfg        ,//precharge time
  input       [4:0]                                                 mc_trcd_cfg       ,//write rcd time
  input       [0:0]                                                 mc_trtp_cfg       ,//rd cas rising edge to precharge time
  input       [3:0]                                                 mc_twr_cfg        ,//wr cas falling edge to precharge time
  input       [2:0]                                                 mc_twtr_cfg       ,//write cas To Read cas time
  input       [3:0]                                                 mc_trtw_cfg       ,//Read cas To Write cas time

  input       [31:0]                                                mc_rf_period_1    ,
  input       [31:0]                                                mc_rf_period_2    ,
  input       [31:0]                                                mc_rf_start_1     ,
  input       [31:0]                                                mc_rf_start_2     ,
  //rf range
  input                                                             rf_range_change_en,
  input       [ARRAY_ROW_ADDR_WIDTH-1:0]                            rf_start_raddr    ,
  input       [ARRAY_ROW_ADDR_WIDTH-1:0]                            rf_end_raddr      ,

  input                                                             inner_precharge   ,
  output reg                                                        rf_req            ,
  output      [4:0]                                                 array_fsm_cs      ,
  output      [4:0]                                                 array_fsm_ns      ,

  //-------------connect to frame2frame--------------------------
  input                                                             mc_frame_vld      ,
  output                                                            mc_frame_rdy      ,
  input       [MC_FRAME_WIDTH-1:0]                                  mc_frame_data     ,
  output                                                            array_rvalid      ,
  output      [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                 array_rdata       ,
  output      [ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH-1:0]       array_addr    ,

  //-------------connect to array------------------------------
  output reg  [1:0]                                                 bnksel_n          , //wy up
  output      [ARRAY_ROW_ADDR_WIDTH-1:0]                            gradd_n           ,
  output reg                                                        gcas_rd           ,
  output reg                                                        gcas_wr           ,
  output      [ARRAY_COL_ADDR_WIDTH-1:0]                            gcadd             ,
  //output                                                          wrrdy_n           ,
  output reg  [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_RSV_WIDTH-1:0] wdl               ,
  output reg                                                        wdl_oe            ,
  input                                                             rdrdy_n           ,
  input       [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_RSV_WIDTH-1:0] rdl               ,
  //------------------DFS and refresh-------------------------
  input                                                             mc_rf_start_sel   ,//0:sel input rf start,1:sel mc local cfg
  input       [31:0]                                                rf_start_time     ,//dap_aux cfg rf start time
  input       [31:0]                                                rf_period         ,
  input                                                             rf_period_up_en   ,//pulse signal
  input                                                             mc_rf_period_sel  ,//0:sel input rf period,1:sel mc local,default 0
  //------------------debug signal----------------------------
  output reg  [1:0]                                                 dbg_w_frame_cnt   ,  
  output reg  [1:0]                                                 dbg_r_frame_cnt   ,  
  output reg  [1:0]                                                 dbg_r_data_cnt    ,  
  output reg                                                        dbg_refresh_flag  ,
  output reg  [4:0]                                                 dbg_current_state ,   
  output reg  [4:0]                                                 dbg_next_state    
     
);


//----------------------------------------------------------------------------
//reg and wire declare
//----------------------------------------------------------------------------
wire                                             mc_frame_rw              ;
wire                                             mc_frame_sof             ;
wire                                             mc_frame_eof             ;
wire [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]       mc_frame_wdata           ;
wire [ARRAY_ROW_ADDR_WIDTH-1:0]                  mc_frame_raddr           ;
wire [ARRAY_COL_ADDR_WIDTH-1:0]                  mc_frame_caddr           ;
wire                                             mc_frame_wstrb           ;
reg  [7:0]                                       fsm_dec_cnt              ;
reg  [7:0]                                       ras_dec_cnt              ;
reg  [7:0]                                       twr_dec_cnt              ;
//reg                                              twr_cnt_vld              ;

reg                                              frame_eof_flag           ;
reg                                              frame_wstrb_flag         ;
wire                                             precharge_allow          ;
wire                                             precharge_allow_1        ;
reg  [31:0]                                      rf_cnt;
//reg                                              rf_req;
reg  [ARRAY_ROW_ADDR_WIDTH-1:0]                  rf_graddr_inner          ;
//reg [ARRAY_ROW_ADDR_WIDTH-1:0]                 rf_graddr_map;
wire                                             rd_empty                 ;
wire                                             rf_sel_mux_out           ;
reg  [ARRAY_ROW_ADDR_WIDTH-1:0]                  gradd_n_inner            ;
reg  [ARRAY_COL_ADDR_WIDTH-1:0]                  gcadd_inner              ;
wire                                             rdrdy_n_inner            ;
reg  [ARRAY_ROW_ADDR_WIDTH-1:0]                  rf_last_raddr            ;
reg  [31:0]                                      rf_period_reg            ;
reg                                              rf_period_up_req         ;

reg  [31:0]                                      period_th                ;
wire [31:0]                                      inside_period            ;
wire [31:0]                                      outside_period           ;
wire [31:0]                                      inside_start             ;
wire [31:0]                                      outside_start            ;

wire                                             rf_cnt_work_en           ;
reg                                              rf_cnt_work_en_dly       ;
reg                                              rf_cnt_work_en_reg       ;

//wy add
wire    [1:0]   mc_bank_sel;


reg [4:0] FSM_CS;
reg [4:0] FSM_NS;
//----------------------------------------------------------------------------
//wire defination
//----------------------------------------------------------------------------
//assign {mc_frame_wstrb, mc_frame_rw, mc_frame_sof, mc_frame_eof, mc_frame_wdata, mc_frame_raddr, mc_frame_caddr} = mc_frame_data ;
//wy up
assign {mc_frame_rw, mc_frame_sof, mc_frame_eof, mc_bank_sel,mc_frame_wdata, mc_frame_raddr, mc_frame_caddr} = mc_frame_data ;
assign mc_frame_wstrb = 1'b1;


assign precharge_allow = ras_dec_cnt == 'd0 ;
assign precharge_allow_1 = twr_dec_cnt == 'd0  ;
//always @ (posedge clk or negedge rst_n)begin
//    if(!rst_n)
//        precharge_allow_1 <= 1'b0;
//    else if(mc_frame_rw && mc_frame_vld && mc_frame_rdy && precharge_allow_1)
//        precharge_allow_1 <= 1'b0;
//    else if(twr_dec_cnt == 'd0 && twr_cnt_vld)
//        precharge_allow_1 <= 1'b1;
//end
assign array_fsm_cs = FSM_CS ;
assign array_fsm_ns = FSM_NS ;


//`ifdef RTLSIM
//assign rdrdy_n_inner = rdrdy_n || mc_rdrdy_n_en;
//`else

//`endif
assign rdrdy_n_inner = rdrdy_n;

//OR2V8_8TR40 U_rdrdy_inner(.A1(mc_rdrdy_n_en   ), .A2(rdrdy_n), .Z(rdrdy_n_inner));
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
        rf_last_raddr <= 13'h1CBF;//7359
    else if(FSM_CS==IDLE)begin
        if(rf_range_change_en)
            rf_last_raddr <= rf_end_raddr;
        else
            rf_last_raddr <= 13'h1CBF;
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
      if (rf_req && mc_en && mc_rf_start)
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
//        if (gradd_n == {ARRAY_ROW_ADDR_WIDTH{1'b1}})   //last row
        //if (gradd_n == 13'b1_0011_1111_1111)   //last row
//        if (gradd_n == 13'b1_1000_0100_1111)   //last row,6k+80
//        if (gradd_n == mc_rf_row_num)   //last row
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

      WTR_CNT_LOAD         : fsm_dec_cnt <= mc_twtr_cfg-1;
      RTW_CNT_LOAD         : fsm_dec_cnt <= mc_trtw_cfg-1;

      default              : fsm_dec_cnt <= (fsm_dec_cnt != 0) ? (fsm_dec_cnt -1) : 0;
    endcase
  end
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    ras_dec_cnt <= 'd0;
  end
  else begin
    if (FSM_CS == R_UP_RADDR || FSM_CS == W_UP_RADDR)
      ras_dec_cnt <= mc_tras_cfg -1;
    else
      ras_dec_cnt <= (ras_dec_cnt != 0) ? (ras_dec_cnt -1) : 0 ;
  end
end

//20250408 add by hy
wire    s_twr_dec_cona;
wire    s_twr_dec_conb;
//assign  s_twr_dec_cona = (FSM_CS == W_DATA && mc_frame_vld && (~gcas_wr) && mc_frame_rw && mc_frame_rdy && !mc_frame_wstrb);
assign  s_twr_dec_cona = (FSM_CS == W_DATA && mc_frame_vld && mc_frame_rw && mc_frame_rdy && !mc_frame_wstrb); //wy up
assign  s_twr_dec_conb = (FSM_CS == W_TRCD_CNT && fsm_dec_cnt == 8'd0 && !frame_wstrb_flag);
//end by hy

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    twr_dec_cnt <= 'd0;
end
  else begin
//    if (gcas_wr || FSM_NS==W_DATA_LAST || (FSM_CS == W_DATA && mc_frame_vld && (~gcas_wr) && mc_frame_rw && mc_frame_rdy && !mc_frame_wstrb) || (FSM_CS == W_TRCD_CNT && fsm_dec_cnt == 8'd0 && !frame_wstrb_flag))
    if (gcas_wr || FSM_NS==W_DATA_LAST || s_twr_dec_cona || s_twr_dec_conb) //20250408 add by hy
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
    if (rf_cnt_work_en_reg && (rf_cnt < period_th))
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
    if (mc_en && mc_rf_start && (rf_cnt ==(mc_rf_start_sel ? inside_start : outside_start)))
      rf_req <= 1'b1;
    else if (FSM_CS == IDLE)
      rf_req <= 1'b0;
  end
end

assign inside_period = rf_sel_mux_out ? mc_rf_period_2 : mc_rf_period_1 ;
assign inside_start = rf_sel_mux_out ? mc_rf_start_2 : mc_rf_start_1 ;
assign outside_start = rf_start_time;
//-------------rf period update-------------------//
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        rf_period_reg <= 32'd0;
    else if(rf_period_up_en)
        rf_period_reg <= rf_period;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        rf_period_up_req <= 1'b0;
    else if(rf_cnt == 32'd0 && rf_period_up_req && !rf_period_up_en)
        rf_period_up_req <= 1'b0;
    else if(rf_period_up_en && !mc_rf_period_sel)
        rf_period_up_req <= 1'b1;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        period_th <= 32'h30D4000;//default 64ms
    else if(!mc_rf_period_sel)begin
        if(rf_period_up_req && rf_cnt=='d0)
            period_th <= rf_period_reg;
//        else if(mc_en && mc_rf_start && !rf_period_up_req)
//            period_th <= rf_period_reg;
        else
            period_th <= period_th;
    end
    else 
        period_th <= inside_period;
    end
//assign rf_pos = mc_en && mc_rf_start && (rf_cnt == (rf_sel_mux_out ? mc_rf_start_2 : mc_rf_start_1));
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
    if (FSM_CS == IDLE && rf_range_change_en==1'b0)
        rf_graddr_inner <= 'd0;
    else if(FSM_CS == IDLE && rf_range_change_en==1'b1)
        rf_graddr_inner <= rf_start_raddr; 
    else if (FSM_CS == RF_UP_RADDR)
        rf_graddr_inner <= rf_graddr_inner +1;
    end
end
//----------------------------------------------------------------------------
//output for axi2frame
//----------------------------------------------------------------------------
assign mc_frame_rdy = (FSM_CS == IDLE   && ~rf_req ) || 
                      (FSM_CS == W_DATA && ~inner_precharge) || 
                      (FSM_CS == R_DATA && ~inner_precharge) ; //wy add
                      //(FSM_CS == W_DATA && ~gcas_wr && ~inner_precharge) ||
                      //(FSM_CS == R_DATA && ~gcas_rd && ~inner_precharge) ;
//assign mc_frame_rdy = (FSM_CS == IDLE   && ~rf_req ) || (FSM_CS == W_DATA  && send_eof_flag==0) || (FSM_CS == R_DATA ) ;

assign array_rvalid = ~rd_empty;

DW_fifo_s2_sf #(
        .width      (ARRAY_DATA_WIDTH+CHECKBIT_WIDTH) , 
        .depth      (9), 
        .push_ae_lvl(2) , 
        .push_af_lvl(2) , 
        .pop_ae_lvl (2) ,
        .pop_af_lvl (2) , 
        .err_mode   (0) , 
        .push_sync  (2) , 
        .pop_sync   (2) , 
        .rst_mode   (0)
    )U0_rdata_async_fifo(
            .clk_push     (rdrdy_n_inner                            ), 
            .clk_pop      (clk                                      ),
            .rst_n        (rst_n                                    ), 
            .push_req_n   (1'b0                                     ),
            .pop_req_n    (rd_empty                                 ), 
            .data_in      (rdl[ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0] ),
            .push_empty   (                                         ), 
            .push_ae      (                                         ),
            .push_hf      (                                         ),
            .push_af      (                                         ),
            .push_full    (                                         ), 
            .push_error   (                                         ),
            .pop_empty    (rd_empty                                 ), 
            .pop_ae       (                                         ),
            .pop_hf       (                                         ), 
            .pop_af       (                                         ),
            .pop_full     (                                         ), 
            .pop_error    (                                         ),
            .data_out     (array_rdata                              ) 
        );

//wy add
wire    [ARRAY_ROW_ADDR_WIDTH + ARRAY_COL_ADDR_WIDTH-1:0]   func_addr;
assign  func_addr = {bnksel_n[0],gradd_n,gcadd[ARRAY_COL_ADDR_WIDTH-1:0]};

DW_fifo_s1_sf
    #(

        .width      (ARRAY_ROW_ADDR_WIDTH + ARRAY_COL_ADDR_WIDTH) , 
        .depth      (9), 
        .ae_level   (2), 
        .af_level   (2), 
        .err_mode   (0), 
        .rst_mode   (0)
    )U1_rdata_sync_fifo (
        .clk            (clk                        ),
        .rst_n          (rst_n                      ),
        .push_req_n     (!gcas_rd                   ),
        .pop_req_n      (~array_rvalid              ),
        .diag_n         (1'b1                       ),
        .data_in        (func_addr                  ),
        .empty          (                           ),
        .almost_empty   (                           ),
        .half_full      (                           ),
        .almost_full    (                           ),
        .full           (                           ),
        .error          (                           ),
        .data_out       (array_addr                 )
    );



//----------------------------------------------------------------------------
//output for array
//----------------------------------------------------------------------------
//always @(posedge clk or negedge rst_n)
//begin
//  if (rst_n == 1'b0) begin
//    bnksel_n <= 1'b1;
//  end
//  else begin
//    if (FSM_CS == RF_UP_RADDR || FSM_CS == W_UP_RADDR || FSM_CS == R_UP_RADDR)
//      bnksel_n <= 1'b0;
//    else if (FSM_NS == RF_PRECHARGE || FSM_NS == W_PRECHARGE || FSM_NS == R_PRECHARGE || FSM_NS == R_DATA_LAST_WITH_PRE)
//      bnksel_n <= 1'b1;
//  end
//end

// wy up
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    bnksel_n <= 2'b11;
  end
  else begin
    if ((FSM_NS == W_UP_RADDR || FSM_NS == R_UP_RADDR) && mc_frame_vld && mc_frame_rdy) 
        bnksel_n <= ~mc_bank_sel;
    else if (FSM_CS == RF_UP_RADDR)
        bnksel_n <= 2'b00;
    else if (FSM_NS == W_PRECHARGE || FSM_NS == R_PRECHARGE || FSM_NS == R_DATA_LAST_WITH_PRE || FSM_NS == RF_PRECHARGE)
      bnksel_n <= 2'b11;
  end
end

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    gradd_n_inner <= 'd0;
  end
  else begin
    if (FSM_CS == IDLE && (FSM_NS == W_UP_RADDR || FSM_NS == R_UP_RADDR))
      gradd_n_inner <= mc_frame_raddr ;
    else if (FSM_CS == IDLE && FSM_NS == RF_UP_RADDR && rf_range_change_en==1'b0)
      gradd_n_inner <= 'd0;
    else if (FSM_CS == IDLE && FSM_NS == RF_UP_RADDR && rf_range_change_en==1'b1)
      gradd_n_inner <= rf_start_raddr;
    else if (FSM_CS == RF_TRP_CNT && FSM_NS == RF_UP_RADDR)
      gradd_n_inner <= rf_graddr_inner;
  end
end

//assign gradd_n = (gradd_n_inner > 13'b1_0011_1111_1111) ? (gradd_n_inner - 13'b1_0011_1111_1111 - 13'b1) : gradd_n_inner ;
assign gradd_n = gradd_n_inner ;
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
    else if (FSM_CS == R_DATA && mc_frame_vld && (~gcas_rd) && (~mc_frame_rw) && mc_frame_rdy)
      gcas_rd <= 1'b1 ;
    else if(FSM_CS ==  WTR_CNT && fsm_dec_cnt == 8'd0)
      gcas_rd <= 1'b1 ;
    else
      gcas_rd <= 1'b0 ;

    if (FSM_CS == W_TRCD_CNT && fsm_dec_cnt == 8'd0)
      gcas_wr <= 1'b1 ;
    else if(FSM_CS ==  RTW_CNT && fsm_dec_cnt == 8'd0)
      gcas_wr <= 1'b1 ;
    else if (FSM_CS == W_DATA && mc_frame_vld && (~gcas_wr) && mc_frame_rw && mc_frame_rdy)
      gcas_wr <= 1'b1 ;
    else
      gcas_wr <= 1'b0 ;
  end
end
*/

//wy up
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0)
    gcas_rd <= 1'b0 ;
  else begin
    if (FSM_CS == R_TRCD_CNT && fsm_dec_cnt == 8'd0)
      gcas_rd <= 1'b1 ;
    //else if (FSM_CS == R_DATA && mc_frame_vld && (~gcas_rd) && (~mc_frame_rw) && mc_frame_rdy)
    else if (FSM_CS == R_DATA && mc_frame_vld && (~mc_frame_rw) && mc_frame_rdy) //wy up
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
    //else if (FSM_CS == W_DATA && mc_frame_vld && (~gcas_wr) && mc_frame_rw && mc_frame_rdy && mc_frame_wstrb)
    else if (FSM_CS == W_DATA && mc_frame_vld && mc_frame_rw && mc_frame_rdy && mc_frame_wstrb) //wy up
        gcas_wr <= 1'b1 ;
    else
      gcas_wr <= 1'b0 ;
  end
end

//reg         gcas_rd_s;
//reg         gcas_wr_s;
//
////always @(posedge clk or negedge rst_n)
//always @(negedge clk or negedge rst_n)
//begin
//  if (rst_n == 1'b0)
//    gcas_rd_s <= 1'b0 ;
//  else begin
//    if (FSM_CS == R_TRCD_CNT && fsm_dec_cnt == 8'd0)
//      gcas_rd_s <= 1'b1;
//    //else if (FSM_CS == R_DATA && mc_frame_vld && (~gcas_rd) && (~mc_frame_rw) && mc_frame_rdy)
//    else if (FSM_CS == R_DATA && mc_frame_vld && (~mc_frame_rw) && mc_frame_rdy) //wy up
//      gcas_rd_s <= 1'b1;
//    else if(FSM_CS ==  WTR_CNT && fsm_dec_cnt == 8'd0)
//      gcas_rd_s <= 1'b1;
//    else
//      gcas_rd_s <= 1'b0 ;
//    end
//end
////always @(posedge clk or negedge rst_n)
//always @(negedge clk or negedge rst_n)
//begin
//  if (rst_n == 1'b0)
//    gcas_wr_s <= 1'b0 ;
//  else begin
//    if (FSM_CS == W_TRCD_CNT && fsm_dec_cnt == 8'd0 && frame_wstrb_flag)
//        gcas_wr_s <= 1'b1;
//    else if(FSM_CS ==  RTW_CNT && fsm_dec_cnt == 8'd0 && frame_wstrb_flag)
//        gcas_wr_s <= 1'b1;
//    //else if (FSM_CS == W_DATA && mc_frame_vld && (~gcas_wr) && mc_frame_rw && mc_frame_rdy && mc_frame_wstrb)
//    else if (FSM_CS == W_DATA && mc_frame_vld && mc_frame_rw && mc_frame_rdy && mc_frame_wstrb) //wy up
//        gcas_wr_s <= 1'b1;
//    else
//      gcas_wr_s <= 1'b0 ;
//  end
//end
//
//
//assign  gcas_wr = gcas_wr_s && clk;
//assign  gcas_rd = gcas_rd_s && clk;
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
*/
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) 
    gcadd_inner <= 'd0;
  else if (FSM_CS == IDLE && FSM_NS == R_UP_RADDR)
    gcadd_inner <= mc_frame_caddr;
  //else if (FSM_CS == R_DATA && mc_frame_vld && (~gcas_rd) && mc_frame_rdy)
  else if (FSM_CS == R_DATA && mc_frame_vld && mc_frame_rdy)
    gcadd_inner <= mc_frame_caddr;
  else if (FSM_CS == IDLE && FSM_NS == W_UP_RADDR)
    gcadd_inner <= mc_frame_caddr;
  //else if (FSM_CS == W_DATA && mc_frame_vld && (~gcas_wr) && mc_frame_rdy)
  else if (FSM_CS == W_DATA && mc_frame_vld && mc_frame_rdy) //wy up
    gcadd_inner <= mc_frame_caddr;
end
/*
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) 
    gcadd_inner <= 'd0;
  else if (FSM_CS == IDLE && FSM_NS == R_UP_RADDR)
    gcadd_inner <= mc_frame_caddr;
  else if (FSM_CS == R_DATA && mc_frame_vld && (~gcas_rd))
    gcadd_inner <= mc_frame_caddr;
  else if (FSM_CS == IDLE && FSM_NS == W_UP_RADDR)
    gcadd_inner <= mc_frame_caddr;
  else if (FSM_CS == W_DATA && mc_frame_vld && (~gcas_wr)) 
    gcadd_inner <= mc_frame_caddr;
end
*/
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
      wdl <= {{ARRAY_RSV_WIDTH{1'b0}},mc_frame_wdata};
  //else if (FSM_CS == W_DATA && mc_frame_vld && (~gcas_wr)) 
  else if (FSM_CS == W_DATA && mc_frame_vld) //wy up 
      wdl <= {{ARRAY_RSV_WIDTH{1'b0}},mc_frame_wdata};
  else if(FSM_CS == R_DATA && FSM_NS == RTW_CNT_LOAD)
      wdl <= {{ARRAY_RSV_WIDTH{1'b0}},mc_frame_wdata};
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
//    else if (FSM_CS == W_TWR_CNT && fsm_dec_cnt == mc_twr_cfg-1)
    else if ((FSM_CS == W_TWR_CNT) || FSM_CS==WTR_CNT_LOAD)
      wdl_oe <= 1'b0;
  end
end

//----------------------------------------------------------------------------
//debug
//----------------------------------------------------------------------------
always @ (posedge clk)
begin
    if(ras_clr)
        dbg_w_frame_cnt <= 2'd0;
    else if(dbg_w_frame_cnt==2'd3)
        dbg_w_frame_cnt <= dbg_w_frame_cnt;
    else if(mc_frame_rw & mc_frame_vld & mc_frame_rdy)
        dbg_w_frame_cnt <= dbg_w_frame_cnt + 1'b1;
end

always @ (posedge clk)
begin
    if(ras_clr)
        dbg_r_frame_cnt <= 2'd0;
    else if(dbg_r_frame_cnt==2'd3)
        dbg_r_frame_cnt <= dbg_r_frame_cnt;
    else if(~mc_frame_rw & mc_frame_vld & mc_frame_rdy)
        dbg_r_frame_cnt <= dbg_r_frame_cnt + 1'b1;
end

always @ (posedge clk)
begin
    if(ras_clr)
        dbg_refresh_flag <= 1'b0;
    else if(FSM_CS==RF_UP_RADDR)
        dbg_refresh_flag <= 1'b1;
end

always @ (posedge clk)
begin
    if(ras_clr)
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

