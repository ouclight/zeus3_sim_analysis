module mc_frame2frame_aux #(
    parameter   ARRAY_ROW_ADDR_WIDTH  = 13,
    parameter   ARRAY_COL_ADDR_WIDTH  = 8,
    parameter   CHECKBIT_WIDTH        = 16,
    parameter   ARRAY_DATA_WIDTH      = 256,
    parameter   WL_NUM                = 7360,
    parameter   FRAME_WIDTH           = ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+3+1+2
)(
    input                                                         clk                 ,
    input                                                         rst_n               ,
    ////connect with apb cfg
    input                                                         vmc_wl_en           ,
    input                                                         vmc_bl_en           ,

    input                                                         pre_precharge       ,//pre precharge en
    input                                                         rf_burst_split_en   ,//default 1,1:split,0:not split
    output                                                        inner_precharge     ,
    input                                                         page_mode_switch    ,//0:open page,1:close page
    input                                                         mc_all_bank_act_en  ,
    output reg                                                    mc_page_status      ,
    input                                                         rf_req              ,
    input       [7:0]                                             bank_map_id         ,

    ////connect with mc hub
    input                                                         hub_frame_vld       ,
    output                                                        hub_frame_rdy       ,
    input       [FRAME_WIDTH-2:0]                                 hub_frame_data      ,
    
    output                                                        mc_rvalid           ,
    output      [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]             mc_rdata            ,

    ////connect with frame2array
    output reg                                                    mc_frame_vld        ,
    input                                                         mc_frame_rdy        ,
    output      [FRAME_WIDTH-1:0]                                 mc_frame_data       ,
    input       [4:0]                                             array_fsm_cs        ,
    input       [4:0]                                             array_fsm_ns        ,
    input                                                         bist_working        ,
    input                                                         dram_init_working   ,

    input                                                         array_rvalid        ,
    input       [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]             array_rdata         
   
);



//-----------------------------
//wire and reg declare
//-----------------------------    
wire                                                                    hub_frame_sof        ;
wire                                                                    hub_frame_eof        ;
wire [ARRAY_ROW_ADDR_WIDTH-1:0]                                         hub_frame_row        ;
wire [ARRAY_COL_ADDR_WIDTH-2:0]                                         hub_frame_col        ;
wire [1:0]                                                              hub_frame_layer_id   ;

wire [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                              hub_frame_wdata      ;
wire                                                                    hub_frame_rw         ;
wire                                                                    row_id_status        ;//1:diff ,0:same
reg  [1:0]                                                              layerid              ;

reg                                                                     mc_frame_rw          ;
reg                                                                     mc_frame_sof_tmp     ;
reg                                                                     mc_frame_sof         ;
reg                                                                     mc_frame_eof         ;
reg                                                                     mc_frame_wstrb       ;
reg  [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                              mc_frame_wdata       ;
reg  [ARRAY_ROW_ADDR_WIDTH-1:0]                                         mc_frame_row_addr    ;
reg  [ARRAY_COL_ADDR_WIDTH-1:0]                                         mc_frame_col_addr    ;
reg  [1:0]                                                              mc_frame_layer_id    ;
reg  [ARRAY_ROW_ADDR_WIDTH-1:0]                                         row_addr             ;


reg                                                                     page_mode_switch_r   ;
reg                                                                     close_page           ;
reg                                                                     close_page_r         ;
reg                                                                     mode_switch_req      ;
//reg                                                                     burst_done           ;
wire                                                                    page_mode_switch_pos ;
wire [ARRAY_ROW_ADDR_WIDTH-1:0]                                         up_last_raddr        ; 
wire                                                                    hub_frame_wstrb      ;
reg                                                                     burst_split          ;
reg                                                                     burst_split1         ;
reg                                                                     inner_precharge_tmp  ;
reg                                                                     burst_busy           ;
reg                                                                     hub_burst_busy       ;
reg                                                                     hub_invalid          ;
wire                                                                    hub_invalid1         ;
reg                                                                     vmc_wl_en_r          ;
reg                                                                     vmc_bl_en_r          ;
wire                                                                    vmc_wl_en_pos        ;
wire                                                                    vmc_bl_en_pos        ;
reg                                                                     rf_working           ;
assign hub_frame_sof = hub_frame_data[FRAME_WIDTH-4];
assign hub_frame_eof = hub_frame_data[FRAME_WIDTH-5];
assign hub_frame_rw  = hub_frame_data[FRAME_WIDTH-3];
assign hub_frame_wstrb  = hub_frame_data[FRAME_WIDTH-2];
assign hub_frame_layer_id = hub_frame_data[ARRAY_COL_ADDR_WIDTH-1+ARRAY_ROW_ADDR_WIDTH+2-1 -:2];

assign hub_frame_col = hub_frame_data[ARRAY_COL_ADDR_WIDTH-2:0];
assign hub_frame_row = hub_frame_data[ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH-2:ARRAY_COL_ADDR_WIDTH-1];
assign hub_frame_wdata = hub_frame_data[FRAME_WIDTH-6 -: (ARRAY_DATA_WIDTH+CHECKBIT_WIDTH)];


localparam  IDLE                 = 5'b00000  ,
            RF_UP_RADDR          = 5'b00001  ,
            RF_TRAS_CNT          = 5'b00011  ,
            RF_PRECHARGE         = 5'b00010  ,//RF_PRECHARGE RF_TRP_CNT W_DATA_LAST W_PRECHARGE R_DATA_LAST_WITH_PRE R_DATA_LAST R_TRTP_CNT R_PRECHARGE R_TRP_CNT
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


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        row_addr <= 13'h1fff;
        layerid  <= 2'b0;

    end
    else if(hub_frame_vld && hub_frame_rdy)begin
        row_addr <= hub_frame_row;
        layerid  <= hub_frame_layer_id;
    end
end

assign row_id_status = (row_addr != hub_frame_row) || (!mc_all_bank_act_en && layerid != hub_frame_layer_id);
////---------page switch-----------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        page_mode_switch_r <= 1'b0;
    else 
        page_mode_switch_r <= page_mode_switch;
end

assign page_mode_switch_pos = page_mode_switch ^ page_mode_switch_r;


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        close_page <= 1'b0;
    else if(!hub_burst_busy && mode_switch_req && !close_page && array_fsm_cs==IDLE && mc_frame_vld==0)//open to close
        close_page <= page_mode_switch;
    else if(!hub_burst_busy && mode_switch_req && !burst_busy && close_page)//close to open
        close_page <= page_mode_switch;
    else
        close_page <= close_page;
    end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        close_page_r <= 1'b0;
    else
        close_page_r <= close_page;
    end


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        mode_switch_req <= 1'b0;
    else if(close_page ^ close_page_r)
        mode_switch_req <= 1'b0;
    else if(page_mode_switch_pos)
        mode_switch_req <= 1'b1;
    end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        mc_page_status <= 1'b1;
    else if(close_page ^ close_page_r)
        mc_page_status <= 1'b1;
    else if(page_mode_switch_pos)
        mc_page_status <= 1'b0;
end


//------------------------
//output for frame2array
//------------------------

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        mc_frame_vld <= 1'b0;
    else if(hub_frame_rdy && hub_frame_vld)
        mc_frame_vld <= 1'b1;
    else if(mc_frame_rdy)
        mc_frame_vld <= 1'b0;
    else
        mc_frame_vld <= mc_frame_vld;

end
        
assign hub_frame_rdy = (!mc_frame_vld  || mc_frame_rdy) && !inner_precharge_tmp && !hub_invalid && !(!hub_burst_busy && mode_switch_req) && !hub_invalid1;
assign hub_invalid1 = array_fsm_cs==W_UP_RADDR || array_fsm_cs==R_UP_RADDR || array_fsm_cs==W_TRCD_CNT || array_fsm_cs==R_TRCD_CNT || array_fsm_ns==WTR_CNT_LOAD || array_fsm_ns==WTR_CNT || rf_req || page_mode_switch_pos ;
////-------------------------------------gen sof------------------------------------///
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        mc_frame_sof <= 1'b0;
    else if(close_page)begin
        if(hub_frame_vld && hub_frame_rdy)
            mc_frame_sof <= hub_frame_sof;
        else if(mc_frame_rdy && mc_frame_sof)
            mc_frame_sof <= 1'b0;
        else
            mc_frame_sof <= mc_frame_sof;
    end
    else begin
        if (hub_frame_vld && hub_frame_rdy && hub_frame_sof && row_id_status)
            mc_frame_sof <= 1'b1;
        else if((array_fsm_ns==W_UP_RADDR || array_fsm_ns==R_UP_RADDR) && hub_frame_vld && hub_frame_rdy && pre_precharge && mc_frame_eof && !mc_frame_rw)
            mc_frame_sof <= 1'b1;
        else if(hub_frame_vld && hub_frame_rdy && hub_frame_sof && !row_id_status && (array_fsm_ns==IDLE||array_fsm_ns==RF_PRECHARGE||array_fsm_ns==RF_TRP_CNT||array_fsm_ns==W_TWR_CNT||array_fsm_ns==W_PRECHARGE||array_fsm_ns==R_TRTP_CNT||array_fsm_ns==R_PRECHARGE||array_fsm_ns==R_TRP_CNT))
            mc_frame_sof <= 1'b1;
        else if(hub_frame_vld && hub_frame_rdy && hub_frame_sof && !row_id_status && (array_fsm_cs==R_DATA_LAST_WITH_PRE||array_fsm_cs==R_DATA_LAST||array_fsm_ns==R_DATA_LAST_WITH_PRE||array_fsm_ns==R_DATA_LAST))
            mc_frame_sof <= 1'b1;
        else if(hub_frame_vld && hub_frame_rdy && (array_fsm_ns==RF_UP_RADDR || array_fsm_cs==RF_TRAS_CNT || array_fsm_cs==RF_PRECHARGE || array_fsm_cs==RF_TRP_CNT))
            mc_frame_sof <= 1'b1;

        //else if(hub_frame_vld && hub_frame_rdy && hub_frame_sof && mc_frame_eof && !row_id_status && array_fsm_ns==WTR_CNT_LOAD)
        //    mc_frame_sof <= 1'b1;
        else if(mc_frame_vld && mc_frame_rdy && mc_frame_sof)
            mc_frame_sof <= 1'b0;
        else
            mc_frame_sof <= mc_frame_sof;
        end
    end

////--------------------------------gen eof------------------------------------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        mc_frame_eof <= 1'b0;
    else if(close_page)begin
        if(hub_frame_vld && hub_frame_rdy)
            mc_frame_eof <= hub_frame_eof;
        else if(mc_frame_rdy)
            mc_frame_eof <= 1'b0;
        else
            mc_frame_eof <= mc_frame_eof;
    end
    else if(hub_frame_vld && hub_frame_rdy && !hub_frame_rw && hub_frame_eof && pre_precharge)//pre_precharge
        mc_frame_eof <= 1'b1;
    else if(mc_frame_vld && mc_frame_rdy && mc_frame_eof)
        mc_frame_eof <= 1'b0;
    else
        mc_frame_eof <= mc_frame_eof;
end

////-----------------------------rf cut burst---------------------------------////
always @(*)begin
    if(mc_frame_vld && mc_frame_rdy && !mc_frame_sof && ((burst_split && !burst_split1) || rf_working))
        mc_frame_sof_tmp = 1'b1;
    else
        mc_frame_sof_tmp = mc_frame_sof;
end


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        burst_split <= 1'b0;
    else if(mc_frame_vld && mc_frame_rdy && mc_frame_sof_tmp && burst_split)
        burst_split <= 1'b0;
    else if(rf_req && rf_burst_split_en && inner_precharge)

        burst_split <= 1'b1;
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        burst_split1 <= 1'b0;
    else if(rf_req && rf_burst_split_en && inner_precharge && burst_split1)
        burst_split1 <= 1'b0;
    else if(mc_frame_vld && mc_frame_rdy && !mc_frame_sof && burst_split)
        burst_split1 <= 1'b1;
    end


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        rf_working <= 1'b1;
    else if(array_fsm_cs==RF_TRP_CNT && array_fsm_ns==IDLE)//rf_trp_cnt 
        rf_working <= 1'b1;
    else if(array_fsm_cs==IDLE)
        rf_working <= 1'b0;
end

////---------------inner_precharge-------------------////


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        inner_precharge_tmp <= 1'b0;
    else if(bist_working || dram_init_working)
        inner_precharge_tmp <= 1'b0;
    else if(array_fsm_ns==IDLE || array_fsm_cs==RF_TRP_CNT || array_fsm_cs==W_TRP_CNT || array_fsm_cs==R_TRP_CNT)
        inner_precharge_tmp <= 1'b0;
    else if(close_page && !(array_fsm_cs==RF_UP_RADDR || array_fsm_cs==RF_TRAS_CNT || array_fsm_cs==RF_PRECHARGE || array_fsm_cs==RF_TRP_CNT) && rf_req && rf_burst_split_en)//close page
        inner_precharge_tmp <= 1'b1;
    else if((vmc_wl_en_pos || vmc_bl_en_pos) && array_fsm_cs!=IDLE && !close_page)
        inner_precharge_tmp <= 1'b1;
    else if(!close_page && hub_frame_vld && hub_frame_rdy && row_id_status)//row diff
        inner_precharge_tmp <= 1'b1;
    else if(mode_switch_req && !mc_frame_vld && mc_frame_rdy && !hub_burst_busy && !close_page)//open to close
            inner_precharge_tmp <= 1'b1;
    else if(rf_req && rf_burst_split_en && !mc_frame_vld && mc_frame_rdy && !close_page)
        inner_precharge_tmp <= 1'b1;
    else
        inner_precharge_tmp <= inner_precharge_tmp;
end

assign inner_precharge = inner_precharge_tmp;
////-------------mc frame busy flag----------------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        burst_busy <= 1'b0;
    else if(array_fsm_cs==W_TRP_CNT || array_fsm_cs==R_TRP_CNT)
            burst_busy <= 1'b0;
    else if(mc_frame_vld && mc_frame_rdy && mc_frame_sof && !mc_frame_eof)
            burst_busy <= 1'b1;
    else 
        burst_busy <= burst_busy;
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        hub_burst_busy <= 1'b0;
    else if(hub_frame_vld && hub_frame_rdy && hub_frame_eof)
            hub_burst_busy <= 1'b0;
    else if(hub_frame_vld && hub_frame_rdy && hub_frame_sof && !hub_frame_eof)
            hub_burst_busy <= 1'b1;
    else 
        hub_burst_busy <= hub_burst_busy;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        hub_invalid <= 1'b0;
    else if(array_fsm_cs==IDLE)//cs=rf_rtp,ns=idle 
        hub_invalid <= 1'b0;
    else if(hub_frame_vld && hub_frame_rdy && hub_frame_eof && mode_switch_req && !rf_req)//first switch,then burst_done
        hub_invalid  <= 1'b1;
    else if(page_mode_switch_pos && !hub_burst_busy && !rf_req)//first burst done ,then switch
        hub_invalid <= 1'b1;
    else if(rf_req && !hub_burst_busy && array_fsm_cs!=IDLE && rf_burst_split_en)
        hub_invalid <= 1'b1;
end

//produce frame
assign mc_frame_data = {mc_frame_wstrb,mc_frame_rw,mc_frame_sof_tmp,mc_frame_eof,mc_frame_wdata,mc_frame_layer_id,mc_frame_row_addr,mc_frame_col_addr};

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        mc_frame_rw <= 1'b1;
    else if(hub_frame_vld && hub_frame_rdy)
        mc_frame_rw <= hub_frame_rw;
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        mc_frame_wstrb <= 1'b1;
    else if(hub_frame_vld && hub_frame_rdy)
        mc_frame_wstrb <= hub_frame_wstrb;
end


always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        mc_frame_wdata <= {(ARRAY_DATA_WIDTH+CHECKBIT_WIDTH){1'b0}};
    else if(hub_frame_rdy && hub_frame_vld && hub_frame_rw)
        mc_frame_wdata <= hub_frame_wdata; 
    end 

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        mc_frame_row_addr <= {ARRAY_ROW_ADDR_WIDTH{1'b0}};
        mc_frame_col_addr <= {ARRAY_COL_ADDR_WIDTH{1'b0}};
        mc_frame_layer_id <= 2'b00;
    end 
    else if(hub_frame_rdy && hub_frame_vld)begin
        mc_frame_row_addr <= hub_frame_row;
        mc_frame_col_addr <= {1'b0,hub_frame_col};
        case(hub_frame_layer_id)
            2'b00: mc_frame_layer_id <= bank_map_id[1:0];
            2'b01: mc_frame_layer_id <= bank_map_id[3:2];
            2'b10: mc_frame_layer_id <= bank_map_id[5:4];
            2'b11: mc_frame_layer_id <= bank_map_id[7:6];
        endcase
    end 
end

assign mc_rvalid = array_rvalid;
assign mc_rdata = array_rdata;

////------------------------
////generate vmc logic
////------------------------
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        vmc_wl_en_r <= 1'b0;
        vmc_bl_en_r <= 1'b0;
    end
    else begin
        vmc_wl_en_r <= vmc_wl_en;
        vmc_bl_en_r <= vmc_bl_en;
    end
end

assign vmc_wl_en_pos = !vmc_wl_en_r && vmc_wl_en ;
assign vmc_bl_en_pos = !vmc_bl_en_r && vmc_bl_en ;




endmodule

