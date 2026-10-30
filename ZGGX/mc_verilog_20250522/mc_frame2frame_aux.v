module mc_frame2frame_aux #(
    parameter   ARRAY_ROW_ADDR_WIDTH  = 13,
    parameter   ARRAY_COL_ADDR_WIDTH  = 8,
    parameter   CHECKBIT_WIDTH        = 10,
    parameter   ARRAY_DATA_WIDTH      = 256,
    parameter   WL_NUM                = 7360,
    parameter   FRAME_WIDTH           = ARRAY_DATA_WIDTH+CHECKBIT_WIDTH+ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH+3+1
)(
    input                                                         clk                 ,
    input                                                         rst_n               ,
    //input                                                         ras_clr           ,
    ////connect with apb cfg
    input                                                         vmc_wl_en           ,
    input                                                         vmc_bl_en           ,

    input                                                         pre_precharge       ,//pre precharge en
    output                                                        inner_precharge     ,
    input                                                         page_mode_switch    ,//0:open page,1:close page
    output reg                                                    mc_page_status      ,
    input                                                         rf_req              ,

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

wire [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                              hub_frame_wdata      ;
wire                                                                    hub_frame_rw         ;
wire                                                                    row_status           ;//1:diff ,0:same

reg                                                                     mc_frame_rw          ;
reg                                                                     mc_frame_sof_tmp     ;
reg                                                                     mc_frame_sof         ;
reg                                                                     mc_frame_eof         ;
reg                                                                     mc_frame_wstrb       ;
reg  [ARRAY_DATA_WIDTH+CHECKBIT_WIDTH-1:0]                              mc_frame_wdata       ;
reg  [ARRAY_ROW_ADDR_WIDTH-1:0]                                         mc_frame_row_addr    ;
reg  [ARRAY_COL_ADDR_WIDTH-1:0]                                         mc_frame_col_addr    ;
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

assign hub_frame_col = hub_frame_data[ARRAY_COL_ADDR_WIDTH-2:0];
assign hub_frame_row = hub_frame_data[ARRAY_ROW_ADDR_WIDTH+ARRAY_COL_ADDR_WIDTH-2:ARRAY_COL_ADDR_WIDTH-1];
assign hub_frame_wdata = hub_frame_data[FRAME_WIDTH-6 -: (ARRAY_DATA_WIDTH+CHECKBIT_WIDTH)];


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        row_addr <= 13'h1fff;
    else if(hub_frame_vld && hub_frame_rdy)
        row_addr <= hub_frame_row;
    end

assign row_status = (row_addr != hub_frame_row) && row_addr != 13'h1fff;
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
    else if(!hub_burst_busy && mode_switch_req && !close_page && array_fsm_cs==5'b00000 && mc_frame_vld==0)//open to close
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


reg   [1:0]   FSM_CS  ;
reg   [1:0]   FSM_NS  ;


localparam  IDLE                 = 2'b00  ,
            ACTIVE               = 2'b01  ,
            PRE                  = 2'b10  ;

always @(posedge clk or negedge rst_n)
begin
  if (rst_n == 1'b0) begin
    FSM_CS <= IDLE ;
end
  else begin
    FSM_CS <= FSM_NS ;
  end
end

always @(*)begin
    case(FSM_CS)
    IDLE: begin
        if(!close_page)begin
            if(hub_frame_rdy && hub_frame_vld && hub_frame_sof && hub_frame_eof && !hub_frame_rw && pre_precharge)
                FSM_NS = FSM_CS;
            else if(hub_frame_rdy && hub_frame_vld)
                FSM_NS = ACTIVE;
            else
                FSM_NS = FSM_CS;
            end
        else
            FSM_NS = FSM_CS;
        end
    ACTIVE: begin
        if(vmc_wl_en_pos || vmc_bl_en_pos || (close_page && !close_page_r))
            FSM_NS = IDLE;
        else if(rf_req || (mode_switch_req && !hub_burst_busy && !mc_frame_vld))begin
            FSM_NS = PRE;
        end
        else begin
            if(hub_frame_vld)begin
                if(row_status==1'b0)begin//same row
                    if(pre_precharge && hub_frame_eof && !hub_frame_rw && ((mc_frame_rdy && mc_frame_vld) || (!mc_frame_vld)))
                        FSM_NS = IDLE;
                    else
                        FSM_NS = ACTIVE;
                end
                else begin//diff row
                    if((mc_frame_rdy && mc_frame_vld) || (!mc_frame_vld))
                        FSM_NS = PRE;
                    else 
                        FSM_NS = ACTIVE;
                end
            end
            else 
                FSM_NS = ACTIVE;
        end
    end
    /*
    PRE: begin
        if(vmc_wl_en_pos || vmc_bl_en_pos || (close_page && !close_page_r))
            FSM_NS = IDLE;
        else if(mc_frame_vld && (rf_req || mode_switch_req || array_fsm_cs==5'd1 || array_fsm_cs==5'd3 || array_fsm_cs==5'd2 || array_fsm_cs==5'd6))
            FSM_NS = PRE;
        else begin
            if(hub_frame_vld)begin
                if((hub_frame_sof || (!hub_frame_sof && !row_status)) && hub_frame_eof && !hub_frame_rw && pre_precharge && hub_frame_rdy)
                    FSM_NS = IDLE;
                else if(hub_frame_rdy)
                    FSM_NS = ACTIVE;
                else 
                    FSM_NS = PRE;
            end
            else
                FSM_NS = PRE;
            end
    end
*/
        PRE: begin
        if(vmc_wl_en_pos || vmc_bl_en_pos || (close_page && !close_page_r))
            FSM_NS = IDLE;
        else if(hub_frame_vld)begin
            if(rf_req || mode_switch_req || array_fsm_cs==5'd1 || array_fsm_cs==5'd3 || array_fsm_cs==5'd2 || array_fsm_cs==5'd6)begin
                if(!mc_frame_vld)
                    FSM_NS <= IDLE;
                else 
                    FSM_NS <= PRE;
            end
            else if((hub_frame_sof || (!hub_frame_sof && !row_status)) && hub_frame_eof && !hub_frame_rw && pre_precharge && hub_frame_rdy)
                FSM_NS = IDLE;
            else if(hub_frame_rdy)
                FSM_NS = ACTIVE;
            else 
                FSM_NS = PRE;
        end
        else begin
            if((rf_req || mode_switch_req || array_fsm_cs==5'd1 || array_fsm_cs==5'd3 || array_fsm_cs==5'd2 || array_fsm_cs==5'd6) && !mc_frame_vld)
                FSM_NS <= IDLE;
            else
                FSM_NS <= PRE;
        end
    end


    default : FSM_NS = IDLE;
    endcase
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
assign hub_invalid1 = (array_fsm_cs==5'h0 && hub_frame_vld && mc_frame_vld && row_status) || rf_req || page_mode_switch_pos ;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        mc_frame_sof <= 1'b0;
    else if((FSM_CS==IDLE && FSM_NS==IDLE) || (FSM_CS==PRE && FSM_NS==IDLE) || close_page)begin
        if(hub_frame_vld && hub_frame_rdy)
            mc_frame_sof <= hub_frame_sof;
        else
            mc_frame_sof <= mc_frame_sof;
    end
    else begin
        if ((FSM_CS==IDLE || FSM_CS==PRE) && FSM_NS== ACTIVE)
            mc_frame_sof <= 1'b1;
        else if(FSM_CS==ACTIVE && FSM_NS==PRE && row_status)//diff row,last col
            mc_frame_sof <= 1'b1;
        else if(FSM_CS==ACTIVE && FSM_NS==ACTIVE && mc_frame_rdy )
            mc_frame_sof <= 1'b0;
        else if(FSM_CS==ACTIVE && FSM_NS==IDLE)
            mc_frame_sof <= 1'b0;
        else
            mc_frame_sof <= mc_frame_sof;
        end
    end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        mc_frame_eof <= 1'b0;
    else if((FSM_CS==IDLE && FSM_NS==IDLE) || (FSM_CS==PRE && FSM_NS==IDLE) || close_page)begin
        if(hub_frame_vld && hub_frame_rdy)
            mc_frame_eof <= hub_frame_eof;
        else
            mc_frame_eof <= mc_frame_eof;
    end
    else if((FSM_CS==IDLE || FSM_CS==ACTIVE) && FSM_NS==ACTIVE)//switch page,close to open
        mc_frame_eof <= 1'b0;
    else if(FSM_CS==PRE && FSM_NS==ACTIVE && !(!hub_frame_rw && hub_frame_eof && pre_precharge))
        mc_frame_eof <= 1'b0;
    else if(FSM_CS==ACTIVE && FSM_NS==IDLE)// pre_precharge
        mc_frame_eof <= 1'b1;
    else if(((FSM_CS==PRE && FSM_NS==ACTIVE) || (FSM_CS==ACTIVE && FSM_NS==PRE))&& !hub_frame_rw && hub_frame_eof && pre_precharge)//pre_precharge
        mc_frame_eof <= 1'b1;
    else
        mc_frame_eof <= mc_frame_eof;
end

////---------rf cut burst------------////
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
    else if(rf_req && inner_precharge)

        burst_split <= 1'b1;
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        burst_split1 <= 1'b0;
    else if(rf_req && inner_precharge && burst_split1)
        burst_split1 <= 1'b0;
    else if(mc_frame_vld && mc_frame_rdy && !mc_frame_sof && burst_split)
        burst_split1 <= 1'b1;
    end


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        rf_working <= 1'b1;
    else if(array_fsm_cs==5'b00110 && array_fsm_ns==5'b00000)//rf_trp_cnt 
        rf_working <= 1'b1;
    else if(array_fsm_cs==5'b00000)
        rf_working <= 1'b0;
end

////---------------inner_precharge-------------------////


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        inner_precharge_tmp <= 1'b0;
    //else if((array_fsm_cs==5'b11010||array_fsm_cs==5'b01110) && inner_precharge_tmp)
    //    inner_precharge_tmp <= 1'b0;
    else if(bist_working || dram_init_working)
        inner_precharge_tmp <= 1'b0;
    else if(array_fsm_cs==5'b0 || array_fsm_cs==5'b00110 || array_fsm_cs==5'b01110 || array_fsm_cs==5'b11010)
        inner_precharge_tmp <= 1'b0;
    else if(close_page && !(array_fsm_cs==5'b00001 || array_fsm_cs==5'b00011 || array_fsm_cs==5'b00010 || array_fsm_cs==5'b00110) && rf_req)//close page
        inner_precharge_tmp <= 1'b1;
    else begin//open page 
        if((vmc_wl_en_pos || vmc_bl_en_pos) && array_fsm_cs!=5'h0 && !close_page)
            inner_precharge_tmp <= 1'b1;
        else if(FSM_CS==PRE && FSM_NS==ACTIVE && row_status && (array_fsm_cs==5'd9||array_fsm_cs==5'd4||array_fsm_cs==5'd12||array_fsm_cs==5'd24||array_fsm_cs==5'd8 || array_fsm_cs==5'd11 || array_fsm_cs==5'd7 || array_fsm_cs==5'd10 ||array_fsm_cs==5'd5 ||(array_fsm_cs==5'd0 && mc_frame_vld)) && !close_page)
            inner_precharge_tmp <= 1'b1;
        else if (FSM_CS==ACTIVE && FSM_NS==PRE && !close_page)
            inner_precharge_tmp <= 1'b1;
        else if(FSM_CS==PRE && FSM_NS==IDLE && (row_status || rf_req) && !close_page )
            inner_precharge_tmp <= 1'b1;
        else if(mode_switch_req && !mc_frame_vld && mc_frame_rdy && !hub_burst_busy && !close_page)
            inner_precharge_tmp <= 1'b1;
        else if(FSM_CS==IDLE && FSM_NS==ACTIVE && row_status && rf_working && !close_page)
            inner_precharge_tmp <= 1'b1;
        else
            inner_precharge_tmp <= inner_precharge_tmp;
    end
end


assign inner_precharge = inner_precharge_tmp;
////-------------mc frame busy flag----------------////
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        burst_busy <= 1'b0;
    else if(array_fsm_cs==5'b01110 || array_fsm_cs==5'b11010)
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
    else if(array_fsm_cs==5'b0)//cs=rf_rtp,ns=idle 
        hub_invalid <= 1'b0;
    else if(hub_frame_vld && hub_frame_rdy && hub_frame_eof && mode_switch_req && !rf_req)//first switch,then burst_done
        hub_invalid  <= 1'b1;
    else if(page_mode_switch_pos && !hub_burst_busy && !rf_req)//first burst done ,then switch
        hub_invalid <= 1'b1;
    else if(rf_req && !hub_burst_busy && array_fsm_cs!=5'b0)
        hub_invalid <= 1'b1;
end

//produce frame
assign mc_frame_data = {mc_frame_wstrb,mc_frame_rw,mc_frame_sof_tmp,mc_frame_eof,mc_frame_wdata,mc_frame_row_addr,mc_frame_col_addr};

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
    end 
    else if(hub_frame_rdy && hub_frame_vld)begin
        mc_frame_row_addr <= hub_frame_row;
        mc_frame_col_addr <= {1'b0,hub_frame_col};

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

