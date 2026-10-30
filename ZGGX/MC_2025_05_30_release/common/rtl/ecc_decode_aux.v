/*********************************-Verilog-****************************************
-- All rights reserved.
-- Copyright (c) 2018 -        Xi'an UniIC
**********************************************************************************
-- Project         :   Common
-- Filename        :   ecc_decode.v
-- Language        :   Verilog
-- Author          :   Han Yang
-- Create Date     :   2022-10-19
**********************************************************************************
-- Abstract        :   (you need type related info here manually)
-- Description     :
--                                       .
--                     (you need type related info here manually)
**********************************************************************************
-- History:
-- Date (y-m-d)       Versions          Author            Description
-- 2022-10-19          1.0              hanyang           initial version
--
**********************************************************************************/
module  ecc_decode_aux
        (
        //input
        clk                         ,
        rst_n                       ,
        i_ecc_on                    ,
        i_data                      ,
        i_chkbit                    ,
        i_data_valid                ,
        i_ei_en                     ,//error injection enable
        i_ei_num                    ,//error injection num
        i_ei_pos1                   ,//error injection position1
        i_ei_pos2                   ,//error injection position2
        //output
        o_err_detect                ,
        o_err_multpl                ,
        o_data_valid                ,
        o_data                       
        );
//-----------------------------------------------------------------------------------------
//parameters
//-----------------------------------------------------------------------------------------
//correction of all single-bit errors
//DATA_WIDTH     CHKBITS
//4    to 11        5
//12   to 26        6
//27   to 57        7
//58   to 120       8
//121  to 247       9
//248  to 502       10
//503  to 1013      11
//1014 to 2036      12
//2037 to 4083      13
//4084 to 8178      14
parameter   DATA_WIDTH      = 128;
parameter   CHK_WIDTH       = 9;
parameter   REG_IN          = 0;

//-----------------------------------------------------------------------------------------
//port list
//-----------------------------------------------------------------------------------------
input                                           clk                         ;
input                                           rst_n                       ;
input                                           i_ecc_on                    ;
input       [DATA_WIDTH-1               :0]     i_data                      ;
input       [CHK_WIDTH-1                :0]     i_chkbit                    ;
input       [1-1                        :0]     i_data_valid                ;
input       [1-1                        :0]     i_ei_en                     ;//error injection enable
input       [2-1                        :0]     i_ei_num                    ;//error injection num
input       [4-1                        :0]     i_ei_pos1                   ;//error injection position1
input       [4-1                        :0]     i_ei_pos2                   ;//error injection position2
output      [DATA_WIDTH-1               :0]     o_data                      ;
output      [1-1                        :0]     o_data_valid                ;
output                                          o_err_detect                ;
output                                          o_err_multpl                ;

//---------------------------------------------------------------------------------------
//process signal
//---------------------------------------------------------------------------------------
wire        [DATA_WIDTH-1               :0]     s_data                      ;
wire        [CHK_WIDTH-1                :0]     s_chkbit                    ;
wire        [DATA_WIDTH-1               :0]     s_data_out                  ;

wire                                            s_err_detect                ;
wire                                            s_err_multpl                ;
reg                                             s_err_detect_dly1           ;
reg                                             s_err_multpl_dly1           ;

reg         [DATA_WIDTH-1               :0]     s_data_reg                  ;
reg         [CHK_WIDTH-1                :0]     s_chkbit_reg                ;
reg         [1-1                        :0]     s_data_valid_reg            ;
reg         [DATA_WIDTH-1               :0]     s_data_reg_dly1             ;
reg         [1-1                        :0]     s_data_valid_reg_dly1       ;

wire        [CHK_WIDTH-1                :0]     s_chkbit_tmp                ;
reg         [CHK_WIDTH-1                :0]     s_chkbit_ei                 ;
wire        [CHK_WIDTH-1                :0]     s_ei_data1                  ;
wire        [CHK_WIDTH-1                :0]     s_ei_data2                  ;

//---------------------------------------------------------------------------------------
//code start
//---------------------------------------------------------------------------------------
DW_ecc
    #(
    .width          (DATA_WIDTH         ),
    .chkbits        (CHK_WIDTH          ),
    .synd_sel       (0                  )
    )
DW_ecc_decode
    (
    .gen            (1'b0               ),
    .correct_n      (1'b0               ),
    .datain         (s_data             ),
    .chkin          (s_chkbit           ),
    .err_detect     (s_err_detect       ),
    .err_multpl     (s_err_multpl       ),
    .dataout        (s_data_out         ),
    .chkout         (                   )
    );

//Error injection
assign  s_ei_data1  = 1'b1 << i_ei_pos1;
assign  s_ei_data2  = 1'b1 << i_ei_pos2;

assign  s_chkbit_tmp= i_ei_en ? s_chkbit_ei : s_chkbit_reg;

always @ (*)
    if (i_ei_num == 2'd0)
        s_chkbit_ei = s_chkbit_reg;
    else if (i_ei_num == 2'd1)
        s_chkbit_ei = s_chkbit_reg ^ s_ei_data1;
    else
        s_chkbit_ei = s_chkbit_reg ^ (s_ei_data1 | s_ei_data2);

//REG IN
generate
    if(REG_IN == 1) 
        begin:regin
            //pipe signal
            always @ (posedge clk or negedge rst_n)
                if(!rst_n)
                    begin
                        s_data_reg            <= {DATA_WIDTH{1'b0}};
                        s_chkbit_reg          <= {CHK_WIDTH{1'b0}};
                        s_data_valid_reg      <= 1'b0;
                    end
                else
                    begin
                        s_data_reg            <= i_data;
                        s_chkbit_reg          <= i_chkbit;
                        s_data_valid_reg      <= i_data_valid;
                    end
        end
    else
        begin:regin
            always @ (*)
                    begin
                        s_data_reg            = i_data;
                        s_chkbit_reg          = i_chkbit;
                        s_data_valid_reg      = i_data_valid;
                    end
        end
endgenerate

//time align
always @ (posedge clk or negedge rst_n)
    if(!rst_n)
        begin
            s_data_reg_dly1       <= {DATA_WIDTH{1'b0}};
            s_data_valid_reg_dly1 <= 1'b0;
            s_err_detect_dly1     <= 1'b0;
            s_err_multpl_dly1     <= 1'b0;
        end
    else
        begin
            s_data_reg_dly1       <= s_data_out;
            s_data_valid_reg_dly1 <= s_data_valid_reg;
            s_err_detect_dly1     <= s_err_detect;
            s_err_multpl_dly1     <= s_err_multpl;
        end

//gen ecc in signal
assign  s_data       = s_data_valid_reg ? s_data_reg     : {DATA_WIDTH{1'b0}};
//assign  s_chkbit     = s_data_valid_reg ? s_chkbit_reg   : {CHK_WIDTH{1'b0}};
assign  s_chkbit     = s_data_valid_reg ? s_chkbit_tmp   : {CHK_WIDTH{1'b0}};

//gen out signal
assign  o_data_valid = i_ecc_on ? s_data_valid_reg_dly1 : s_data_valid_reg ;
assign  o_data       = i_ecc_on ? s_data_reg_dly1       : s_data_reg ;

assign  o_err_detect = i_ecc_on ? s_err_detect_dly1 : 1'b0;
assign  o_err_multpl = i_ecc_on ? s_err_multpl_dly1 : 1'b0;

//---------------------------------------------------------------------------------------
//code end
//---------------------------------------------------------------------------------------
endmodule
