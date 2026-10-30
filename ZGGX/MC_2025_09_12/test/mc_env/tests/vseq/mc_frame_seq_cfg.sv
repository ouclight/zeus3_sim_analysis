/******************************************************************************
 * File Name : mc_frame_seq_cfg.sv
 * Created by kenan on 2024-11-12 18:50
 *******************************************************************************/
`ifndef MC_FRAME_SEQ_CFG_SV 
`define MC_FRAME_SEQ_CFG_SV
class mc_frame_seq_cfg extends uvm_object;

    `ifdef TEST_1_SHOT_1
        localparam      BANK_NUM='d0;
    `elsif TEST_1_SHOT_2
        localparam      BANK_NUM='d1;
    `elsif TEST_1_SHOT_3
        localparam      BANK_NUM='d2;
    `elsif TEST_1_SHOT_4
        localparam      BANK_NUM='d3;
    `else
        localparam      BANK_NUM='d2;
    `endif
    
    rand bit    [`COL_ADDR_WIDTH-1:0]   cadd                 ;
    rand bit    [`ROW_ADDR_WIDTH-1:0]  radd                 ;
    rand bit    [255:0] f_data               ;
    rand bit    [9:0]   parity_data          ;
    rand bit            frame_eof            ;
    rand bit            frame_sof            ;
    rand bit            frame_rw_flag        ;
    rand bit    [1:0]   bank_sel             ;
    rand bit    [15:0]  one_frame_cnt        ;
    rand bit            col_addr_rand_en     ;
    rand bit            wrap_en              ;
    rand bit            strb_rand_en         ;
    rand bit            strb                 ;
         bit    [15:0]  ecc_data             ;
         bit            fixed_cadd      = 0  ;
         bit            xbank_en             ;
    rand bit            rw_rand_en           ;

    constraint radd_ct { 
        radd    inside {[0:7295]};
    }

    constraint  bank_sel_rand_c{
        bank_sel inside {[0:BANK_NUM]};
    }

    constraint one_frame_cnt_ct { 
        if(wrap_en == 1){soft one_frame_cnt inside {[128:128]};}
        else {soft one_frame_cnt inside {[1:128]};}
    }

    constraint cadd_ct { 
        if(col_addr_rand_en == 0 &&  wrap_en==0){cadd inside {[0:'d128-one_frame_cnt]};}        
    }
    
	function new (string name = "mc_frame_seq_cfg");
		super.new();
	endfunction : new

	`uvm_object_utils_begin(mc_frame_seq_cfg)
        `uvm_field_int(cadd          , UVM_ALL_ON)
        `uvm_field_int(radd          , UVM_ALL_ON)
        `uvm_field_int(f_data        , UVM_ALL_ON)
        `uvm_field_int(parity_data   , UVM_ALL_ON)
        `uvm_field_int(frame_eof     , UVM_ALL_ON)
        `uvm_field_int(frame_sof     , UVM_ALL_ON)
        `uvm_field_int(frame_rw_flag , UVM_ALL_ON)
        `uvm_field_int(bank_sel      , UVM_ALL_ON)
        `uvm_field_int(one_frame_cnt , UVM_ALL_ON)
        `uvm_field_int(col_addr_rand_en,UVM_ALL_ON)
        `uvm_field_int(wrap_en       , UVM_ALL_ON)
        `uvm_field_int(strb       , UVM_ALL_ON)
        `uvm_field_int(ecc_data   , UVM_ALL_ON)
        `uvm_field_int(fixed_cadd , UVM_ALL_ON)
        `uvm_field_int(xbank_en   , UVM_ALL_ON)
		`uvm_field_int(rw_rand_en ,	UVM_ALL_ON)
	`uvm_object_utils_end

endclass :  mc_frame_seq_cfg
`endif //MC_FRAME_SEQ_CFG_SV
