/******************************************************************************
 * File Name : trim_interface.sv
 * Created on 2025-07-15 10:18:33
 *******************************************************************************/

`ifndef TRIM_IF_SV
`define TRIM_IF_SV

//------------------------------------------------------------------------------
//
// INTERFACE: trim_if
//
//------------------------------------------------------------------------------

// Just in case you need it
`include "uvm_macros.svh"

interface trim_if(clk,rst_n);

	// Just in case you need it
	import uvm_pkg::*;

	// Clock and reset signals
	input clk;
	input rst_n;

	// Flags to enable/disable assertions and coverage
	bit checks_enable=1;
	bit coverage_enable=1;

	// TODO: Declare interface signals here
    //lid//logic [31      :0] trim_ctrl_id     ;
    logic              trim_start = 0   ;
    logic              trim_finish      ;
    logic [(2*`N-1):0] trim_res   = 'h0 ;
    logic              trim_interrupt   ;
    logic [(1*`N-1):0] spine_reset_n    ;
    logic [(1*`N-1):0] tm_redump        ;
    logic [(1*`N-1):0] stopwatch_period ;
    logic [427     :0] tsv_tm           ;
    logic [(1*`N-1):0] dump_ready       ;
    logic [(1*`N-1):0] stopwatch_ringo  ;
    logic [(2*`N-1):0] osc_tm_res       ;


    //----------------phy cfg---------------Start
    logic           ls_en_asic        = 'h1;
    //----------------phy cfg---------------End

    //----------------for verfi---------------Start
    bit                 clk_dv;
    bit [(1*`N-1):0]    spine_reset_flag;
    bit [(1*`N-1):0]    init_done_flag;
    bit [(1*`N-1):0]    fsm_cs;
    bit [(1*`N-1):0]    dumpready_timeout_ready;
    bit                 timeout_enable = 0;
    bit                 ringo_timeout_enable = 0;

    int                 init_sp_rst_low_cnt_0;
    int                 init_sp_rst_low_cnt_1;
    int                 init_sp_rst_low_cnt_2;
    int                 init_sp_rst_low_cnt_3;
    int                 dp_rd_set_cnt_0;   //for dump_ready be set 1 jitter cfg 
    int                 dp_rd_set_cnt_1;   //for dump_ready be set 1 jitter cfg 
    int                 dp_rd_set_cnt_2;   //for dump_ready be set 1 jitter cfg 
    int                 dp_rd_set_cnt_3;   //for dump_ready be set 1 jitter cfg 
    int                 sp_rst_low_cnt0;
    int                 sp_rst_low_cnt1;
    int                 sp_rst_low_cnt2;
    int                 sp_rst_low_cnt3;
    int                 sp_rst_dp_rdy_cnt0;
    int                 sp_rst_dp_rdy_cnt1;
    int                 sp_rst_dp_rdy_cnt2;
    int                 sp_rst_dp_rdy_cnt3;

    int                 tm_redump_cnt0;
    int                 tm_redump_cnt1;
    int                 tm_redump_cnt2;
    int                 tm_redump_cnt3;

    int                 ringo_cnt0;
    int                 ringo_cnt1;
    int                 ringo_cnt2;
    int                 ringo_cnt3;
    int                 ringo_wait_cnt0;
    int                 ringo_wait_cnt1;
    int                 ringo_wait_cnt2;
    int                 ringo_wait_cnt3;
    int                 ringo_period_cnt0;
    int                 ringo_period_cnt1;
    int                 ringo_period_cnt2;
    int                 ringo_period_cnt3;
    int                 ringo_period_cnt0_save_q[$];
    int                 ringo_period_cnt1_save_q[$];
    int                 ringo_period_cnt2_save_q[$];
    int                 ringo_period_cnt3_save_q[$];

    int                 res_cnt0;
    int                 res_cnt1;
    int                 res_cnt2;
    int                 res_cnt3;
    int                 res_wait_cnt0;
    int                 res_wait_cnt1;
    int                 res_wait_cnt2;
    int                 res_wait_cnt3;

    bit                 ringo_meas_flag;
    bit [`DRAM_LAYER-1:0]           re_act_sp_rst_force_dp_flag;

    int                 hw_init_sp_rst_cnt0;
    int                 hw_init_sp_rst_cnt1;
    int                 hw_init_sp_rst_cnt2;
    int                 hw_init_sp_rst_cnt3;
    int                 dp_rdy_cnt0;
    int                 dp_rdy_cnt1;
    int                 dp_rdy_cnt2;
    int                 dp_rdy_cnt3;
    int                 redp_dp_rdy_cnt0;
    int                 redp_dp_rdy_cnt1;
    int                 redp_dp_rdy_cnt2;
    int                 redp_dp_rdy_cnt3;
    
    bit [`DRAM_LAYER-1:0]           stpwh_prd_res_flag;

    //bit [3:0]           stopwatch_ringo_dv;
    bit                 second_reset_flag;
    bit                 have_reset_flag = 0; //for reset hard_vseq, add-0729
    bit                 reg_test = 0;
    bit [`DRAM_LAYER-1:0]           dram_layer_cfg;//for reset case
    
    bit                 dump_rdy_timeout_en;
    bit                 ringo_timeout_en;

    bit [427:0]         cfg_tsv_tm;      //0729
    bit [8:0]           ringo_mode_q[$]; //0729

    int                 dmp_rdy_timeout_cnt0;
    int                 dmp_rdy_timeout_cnt1;
    int                 dmp_rdy_timeout_cnt2;
    int                 dmp_rdy_timeout_cnt3;
    int                 ringo_timeout_cnt0;
    int                 ringo_timeout_cnt1;
    int                 ringo_timeout_cnt2;
    int                 ringo_timeout_cnt3;

    bit [`RES_WIDTH-1:0]           cfg_reg_res;

    bit [`DRAM_LAYER-1:0]           sp_rst_force_dp_rdy;
    bit [`DRAM_LAYER-1:0]           dmp_rdy_force_flag;
    bit [`DRAM_LAYER-1:0]           ringo_force_flag;
    bit [`DRAM_LAYER-1:0]           ringo_timeout = 'h0;    

    int                 power_up_wait_dp_rdy_cnt0;  //for dump_ready timeout 
    int                 power_up_wait_dp_rdy_cnt1;  //for dump_ready timeout 
    int                 power_up_wait_dp_rdy_cnt2;  //for dump_ready timeout 
    int                 power_up_wait_dp_rdy_cnt3;  //for dump_ready timeout 


    //------------for tsv_tm timing check-------------
    bit [`DRAM_LAYER-1:0]           dram_sp_rst_n;
    bit [`DRAM_LAYER-1:0]           dram_tm_redump;


    bit [27:0]          init_spine_reset_time; 
    bit [9:0]           spine_reset_width;
    bit [9:0]           tm_redump_width;
    bit                 trim_start_reg;
    bit                 init_start_sync;
    bit [427:0]         dram_tsv_tm0;
    bit [427:0]         dram_tsv_tm1;
    bit [427:0]         dram_tsv_tm2;
    bit [427:0]         dram_tsv_tm3;
    bit [427:0]         tsv_tm_setup0;
    bit [427:0]         tsv_tm_setup1;
    bit [427:0]         tsv_tm_setup2;
    bit [427:0]         tsv_tm_setup3;
    bit [427:0]         tsv_tm_current0;
    bit [427:0]         tsv_tm_current1;
    bit [427:0]         tsv_tm_current2;
    bit [427:0]         tsv_tm_current3;
    bit [427:0]         tsv_tm_hold0;
    bit [427:0]         tsv_tm_hold1;
    bit [427:0]         tsv_tm_hold2;
    bit [427:0]         tsv_tm_hold3;
    int                 sp_rst_cnt0;
    int                 sp_rst_cnt1;
    int                 sp_rst_cnt2;
    int                 sp_rst_cnt3;
    int                 tm_redump_h_cnt0;
    int                 tm_redump_h_cnt1;
    int                 tm_redump_h_cnt2;
    int                 tm_redump_h_cnt3;
    int                 sp_rst_l_cnt0;
    int                 sp_rst_l_cnt1;
    int                 sp_rst_l_cnt2;
    int                 sp_rst_l_cnt3;

    bit                 trim_op_flow;
    //----------------for verfi---------------End



    clocking drv @(posedge clk);
        default input #1ps output #1ps;
        input rst_n;
        //input	trim_ctrl_id;
        input	trim_start;
        input	trim_res;
        input	dump_ready;
        input	stopwatch_ringo;
        input	osc_tm_res;

        output	trim_finish;
        output	trim_interrupt;
        output	spine_reset_n;
        output	tm_redump;
        output	stopwatch_period;
        output	tsv_tm;
    endclocking

    clocking mon @(posedge clk);
        default input #1ps;
        input rst_n;
        //input	trim_ctrl_id;
        input	trim_start;
        input	trim_finish;
        input	trim_res;
        input	trim_interrupt;
        input	spine_reset_n;
        input	tm_redump;
        input	stopwatch_period;
        input	tsv_tm;
        input	dump_ready;
        input	stopwatch_ringo;
        input	osc_tm_res;
    endclocking

	// TODO: You can add covergroups in interfaces
	//covergroup signal_coverage@(posedge clk);
	// TODO: add coverpoints here
	//endgroup

	// TODO: You can instantiate the covergroup to collect coverage
	//signal_coverage sc=new();

    property chk_x_after_rst(signal);
		@(posedge clk) rst_n |=> !$isunknown(signal);
	endproperty

    //lid//chk_rst_trim_ctrl_id: assert property (chk_x_after_rst(trim_ctrl_id))
    //lid//else
    //lid//    `uvm_error("ASSERTION_ERR", "Found 'x after rst asserted for trim_ctrl_id.")

    
    chk_rst_trim_start: assert property (chk_x_after_rst(trim_start))
    else
        `uvm_error("ASSERTION_ERR", "Found 'x after rst asserted for trim_start.")

    chk_rst_trim_res: assert property (chk_x_after_rst(trim_res))
    else
        `uvm_error("ASSERTION_ERR", "Found 'x after rst asserted for trim_res.")

    chk_rst_dump_ready: assert property (chk_x_after_rst(dump_ready))
    else
        `uvm_error("ASSERTION_ERR", "Found 'x after rst asserted for dump_ready.")

    chk_rst_stopwatch_ringo: assert property (chk_x_after_rst(stopwatch_ringo))
    else
        `uvm_error("ASSERTION_ERR", "Found 'x after rst asserted for stopwatch_ringo.")

    chk_rst_osc_tm_res: assert property (chk_x_after_rst(osc_tm_res))
    else
        `uvm_error("ASSERTION_ERR", "Found 'x after rst asserted for osc_tm_res.")
   


	// TODO: You can add assertions in interfaces
	//my_assertion:assert property (
	//		@(posedge clk) disable iff (rst_n === 1'b0 || !checks_enable)
	//		valid |-> (data!==8'bXXXX_XXXX)
	//	)
	//else
	//	`uvm_error("ERR_TAG","Error")

    //0805//@(posedge spine_reset_n[0]);

    //check re-active spine_reset_n, spine_reset_n is low, dump_ready should be low:
    always@(posedge clk)begin
        if(re_act_sp_rst_force_dp_flag[0]==1)begin
            if(dump_ready[0] != 0)
                `uvm_error("trim_interface_chk", $sformatf("re-active spine_reset_n, dump_ready should be 0"))
        end
    end
    always@(posedge clk)begin
        if(re_act_sp_rst_force_dp_flag[1]==1)begin
            if(dump_ready[1] != 0)
                `uvm_error("trim_interface_chk", $sformatf("re-active spine_reset_n, dump_ready should be 0"))
        end
    end
    always@(posedge clk)begin
        if(re_act_sp_rst_force_dp_flag[2]==1)begin
            if(dump_ready[2] != 0)
                `uvm_error("trim_interface_chk", $sformatf("re-active spine_reset_n, dump_ready should be 0"))
        end
    end
    always@(posedge clk)begin
        if(re_act_sp_rst_force_dp_flag[3]==1)begin
            if(dump_ready[3] != 0)
                `uvm_error("trim_interface_chk", $sformatf("re-active spine_reset_n, dump_ready should be 0"))
        end
    end

    //check after spine_reset_n be 1, wait time <= 1ms, dump_ready be high
    initial begin
        fork
            forever begin
                @(posedge spine_reset_n[0]);
                if(second_reset_flag==0 && sp_rst_force_dp_rdy[0]==0)begin
                    fork: dp_rdy_chk0
                        begin
                            @(posedge dump_ready[0]);
                            if(dp_rdy_cnt0 > 'd400000) //1ms
                                `uvm_error("trim_interface_chk", $sformatf("spine_reset_n posedge but wait 1ms dump_ready not be high"))
                        end
                        while(1)begin
                            @(posedge clk);
                            if(rst_n==1)begin
                                dp_rdy_cnt0++;
                            end
                            else 
                                break;
                        end
                    join_any
                    disable dp_rdy_chk0;
                    dp_rdy_cnt0 = 0;
                end
                //@(posedge spine_reset_n[0]);
                //#1ms;
                //if(dump_ready[0] != 1)
                //    `uvm_error("trim_interface_chk", $sformatf("spine_reset_n posedge but wait 1ms dump_ready not be high"))
            end
            forever begin
                @(posedge spine_reset_n[1]);
                if(second_reset_flag==0 && sp_rst_force_dp_rdy[1]==0)begin
                    fork: dp_rdy_chk1
                        begin
                            @(posedge dump_ready[1]);
                            if(dp_rdy_cnt1 > 'd400000) //1ms
                                `uvm_error("trim_interface_chk", $sformatf("spine_reset_n posedge but wait 1ms dump_ready not be high"))
                        end
                        while(1)begin
                            @(posedge clk);
                            if(rst_n==1)begin
                                dp_rdy_cnt1++;
                            end
                            else 
                                break;
                        end
                    join_any
                    disable dp_rdy_chk1;
                    dp_rdy_cnt1 = 0;
                end

                //@(posedge spine_reset_n[1]);
                //#1ms;
                //if(dump_ready[1] != 1)
                //    `uvm_error("trim_interface_chk", $sformatf("spine_reset_n posedge but wait 1ms dump_ready not be high"))
            end
            forever begin
                @(posedge spine_reset_n[2]);
                if(second_reset_flag==0 && sp_rst_force_dp_rdy[2]==0)begin
                    fork: dp_rdy_chk2
                        begin
                            @(posedge dump_ready[2]);
                            if(dp_rdy_cnt2 > 'd400000) //1ms
                                `uvm_error("trim_interface_chk", $sformatf("spine_reset_n posedge but wait 1ms dump_ready not be high"))
                        end
                        while(1)begin
                            @(posedge clk);
                            if(rst_n==1)begin
                                dp_rdy_cnt2++;
                            end
                            else 
                                break;
                        end
                    join_any
                    disable dp_rdy_chk2;
                    dp_rdy_cnt2 = 0;
                end

                //@(posedge spine_reset_n[2]);
                //#1ms;
                //if(dump_ready[2] != 1)
                //    `uvm_error("trim_interface_chk", $sformatf("spine_reset_n posedge but wait 1ms dump_ready not be high"))
            end
            forever begin
                @(posedge spine_reset_n[3]);
                if(second_reset_flag==0 && sp_rst_force_dp_rdy[3]==0)begin
                    fork: dp_rdy_chk3
                        begin
                            @(posedge dump_ready[3]);
                            if(dp_rdy_cnt3 > 'd400000) //1ms
                                `uvm_error("trim_interface_chk", $sformatf("spine_reset_n posedge but wait 1ms dump_ready not be high"))
                        end
                        while(1)begin
                            @(posedge clk);
                            if(rst_n==1)begin
                                dp_rdy_cnt3++;
                            end
                            else
                                break;
                        end
                    join_any
                    disable dp_rdy_chk3;
                    dp_rdy_cnt3 = 0;
                end

                //@(posedge spine_reset_n[3]);
                //#1ms;
                //if(dump_ready[3] != 1)
                //    `uvm_error("trim_interface_chk", $sformatf("spine_reset_n posedge but wait 1ms dump_ready not be high"))
            end

            //--------------------------check tm_redump be 1to0-> after 1ms dump_ready should be 1--------------------
            forever begin
                @(posedge tm_redump[0]);
                @(negedge tm_redump[0]);
                if(second_reset_flag==0 && dmp_rdy_force_flag[0]==0 && spine_reset_n[0]==1)begin
                    fork: redp_dp_rdy_chk0
                        begin
                            @(posedge dump_ready[0]);
                            if(redp_dp_rdy_cnt0 > 'd400000) //1ms
                                `uvm_error("trim_interface_chk", $sformatf("tm_redump negedge but wait 1ms dump_ready not be high"))
                        end
                        while(1)begin
                            @(posedge clk);
                            redp_dp_rdy_cnt0++;
                        end
                        begin
                            @(negedge rst_n);
                        end
                    join_any
                    disable redp_dp_rdy_chk0;
                    redp_dp_rdy_cnt0 = 0;
                end
            end
            forever begin
                @(posedge tm_redump[1]);
                @(negedge tm_redump[1]);
                if(second_reset_flag==0 && dmp_rdy_force_flag[1]==0 && spine_reset_n[1]==1)begin
                    fork: redp_dp_rdy_chk1
                        begin
                            @(posedge dump_ready[1]);
                            if(redp_dp_rdy_cnt1 > 'd400000) //1ms
                                `uvm_error("trim_interface_chk", $sformatf("tm_redump negedge but wait 1ms dump_ready not be high"))
                        end
                        while(1)begin
                            @(posedge clk);
                            redp_dp_rdy_cnt1++;
                        end
                        begin
                            @(negedge rst_n);
                        end
                    join_any
                    disable redp_dp_rdy_chk1;
                    redp_dp_rdy_cnt1 = 0;
                end
            end
            forever begin
                @(posedge tm_redump[2]);
                @(negedge tm_redump[2]);
                if(second_reset_flag==0 && dmp_rdy_force_flag[2]==0 && spine_reset_n[2]==1)begin
                    fork: redp_dp_rdy_chk2
                        begin
                            @(posedge dump_ready[2]);
                            if(redp_dp_rdy_cnt2 > 'd400000) //1ms
                                `uvm_error("trim_interface_chk", $sformatf("tm_redump negedge but wait 1ms dump_ready not be high"))
                        end
                        while(1)begin
                            @(posedge clk);
                            redp_dp_rdy_cnt2++;
                        end
                        begin
                            @(negedge rst_n);
                        end
                    join_any
                    disable redp_dp_rdy_chk2;
                    redp_dp_rdy_cnt2 = 0;
                end
            end
            forever begin
                @(posedge tm_redump[3]);
                @(negedge tm_redump[3]);
                if(second_reset_flag==0 && dmp_rdy_force_flag[3]==0 && spine_reset_n[3]==1)begin
                    fork: redp_dp_rdy_chk3
                        begin
                            @(posedge dump_ready[3]);
                            if(redp_dp_rdy_cnt3 > 'd400000) //1ms
                                `uvm_error("trim_interface_chk", $sformatf("tm_redump negedge but wait 1ms dump_ready not be high"))
                        end
                        while(1)begin
                            @(posedge clk);
                            redp_dp_rdy_cnt3++;
                        end
                        begin
                            @(negedge rst_n);
                        end
                    join_any
                    disable redp_dp_rdy_chk3;
                    redp_dp_rdy_cnt3 = 0;
                end
            end
        join
    end

    initial begin
        forever begin
            @(posedge have_reset_flag);
            #100us;
            have_reset_flag = 0;
        end
    end

    //-----------------check tsv_tm timing------------------
    initial begin
        forever begin
            @(posedge init_start_sync);
            repeat(1)@(posedge clk);
            while(1)begin
                @(posedge clk);
                if(sp_rst_cnt0 == init_spine_reset_time-1)begin
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    #1500ps;
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    tsv_tm_setup0 = dram_tsv_tm0;
                    @(posedge dram_sp_rst_n[0]);
                    tsv_tm_current0 = dram_tsv_tm0;
                    #3ns;
                    tsv_tm_hold0 = dram_tsv_tm0;
                    break;
                end
                sp_rst_cnt0++;
            end
            sp_rst_cnt0 = 0;
            if((tsv_tm_setup0 != tsv_tm_current0) || (tsv_tm_hold0 != tsv_tm_current0))
                `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
        end
        forever begin
            @(posedge trim_start_reg);
            repeat(1)@(posedge clk);
            while(1)begin
                @(posedge clk);
                if(sp_rst_cnt0 == init_spine_reset_time-1)begin
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    #1500ps;
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    tsv_tm_setup0 = dram_tsv_tm0;
                    @(posedge dram_sp_rst_n[0]);
                    tsv_tm_current0 = dram_tsv_tm0;
                    #3ns;
                    tsv_tm_hold0 = dram_tsv_tm0;
                    break;
                end
                sp_rst_cnt0++;
            end
            sp_rst_cnt0 = 0;
            if((tsv_tm_setup0 != tsv_tm_current0) || (tsv_tm_hold0 != tsv_tm_current0))
                `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
        end

        forever begin
            @(posedge init_start_sync);
            repeat(1)@(posedge clk);
            while(1)begin
                @(posedge clk);
                if(sp_rst_cnt1 == init_spine_reset_time-1)begin
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    #1500ps;
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    tsv_tm_setup1 = dram_tsv_tm1;
                    @(posedge dram_sp_rst_n[1]);
                    tsv_tm_current1 = dram_tsv_tm1;
                    #3ns;
                    tsv_tm_hold1 = dram_tsv_tm1;
                    break;
                end
                sp_rst_cnt1++;
            end
            sp_rst_cnt1 = 0;
            if((tsv_tm_setup1 != tsv_tm_current1) || (tsv_tm_hold1 != tsv_tm_current1))
                `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
        end
        forever begin
            @(posedge trim_start_reg);
            repeat(1)@(posedge clk);
            while(1)begin
                @(posedge clk);
                if(sp_rst_cnt1 == init_spine_reset_time-1)begin
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    #1500ps;
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    tsv_tm_setup1 = dram_tsv_tm1;
                    @(posedge dram_sp_rst_n[1]);
                    tsv_tm_current1 = dram_tsv_tm1;
                    #3ns;
                    tsv_tm_hold1 = dram_tsv_tm1;
                    break;
                end
                sp_rst_cnt1++;
            end
            sp_rst_cnt1 = 0;
            if((tsv_tm_setup1 != tsv_tm_current1) || (tsv_tm_hold1 != tsv_tm_current1))
                `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
        end


        forever begin
            @(posedge init_start_sync);
            repeat(1)@(posedge clk);
            while(1)begin
                @(posedge clk);
                if(sp_rst_cnt2 == init_spine_reset_time-1)begin
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    #1500ps;
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    tsv_tm_setup2 = dram_tsv_tm2;
                    @(posedge dram_sp_rst_n[2]);
                    tsv_tm_current2 = dram_tsv_tm2;
                    #3ns;
                    tsv_tm_hold2 = dram_tsv_tm2;
                    break;
                end
                sp_rst_cnt2++;
            end
            sp_rst_cnt2 = 0;
            if((tsv_tm_setup2 != tsv_tm_current2) || (tsv_tm_hold2 != tsv_tm_current2))
                `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
        end
        forever begin
            @(posedge trim_start_reg);
            repeat(1)@(posedge clk);
            while(1)begin
                @(posedge clk);
                if(sp_rst_cnt2 == init_spine_reset_time-1)begin
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    #1500ps;
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    tsv_tm_setup2 = dram_tsv_tm2;
                    @(posedge dram_sp_rst_n[2]);
                    tsv_tm_current2 = dram_tsv_tm2;
                    #3ns;
                    tsv_tm_hold2 = dram_tsv_tm2;
                    break;
                end
                sp_rst_cnt2++;
            end
            sp_rst_cnt2 = 0;
            if((tsv_tm_setup2 != tsv_tm_current2) || (tsv_tm_hold2 != tsv_tm_current2))
                `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
        end


        forever begin
            @(posedge init_start_sync);
            repeat(1)@(posedge clk);
            while(1)begin
                @(posedge clk);
                if(sp_rst_cnt3 == init_spine_reset_time-1)begin
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    #1500ps;
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    tsv_tm_setup3 = dram_tsv_tm3;
                    @(posedge dram_sp_rst_n[3]);
                    tsv_tm_current3 = dram_tsv_tm3;
                    #3ns;
                    tsv_tm_hold3 = dram_tsv_tm3;
                    break;
                end
                sp_rst_cnt3++;
            end
            sp_rst_cnt3 = 0;
            if((tsv_tm_setup3 != tsv_tm_current3) || (tsv_tm_hold3 != tsv_tm_current3))
                `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
        end
        forever begin
            @(posedge trim_start_reg);
            repeat(1)@(posedge clk);
            while(1)begin
                @(posedge clk);
                if(sp_rst_cnt3 == init_spine_reset_time-1)begin
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    #1500ps;
                    `uvm_info("tsv_tm_chk", $sformatf("----------sp_rst_cnt == init_spine_reset_time-1---------"), UVM_LOW)
                    tsv_tm_setup3 = dram_tsv_tm3;
                    @(posedge dram_sp_rst_n[3]);
                    tsv_tm_current3 = dram_tsv_tm3;
                    #3ns;
                    tsv_tm_hold3 = dram_tsv_tm3;
                    break;
                end
                sp_rst_cnt3++;
            end
            sp_rst_cnt3 = 0;
            if((tsv_tm_setup3 != tsv_tm_current3) || (tsv_tm_hold3 != tsv_tm_current3))
                `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
        end
    end

    initial begin
        forever begin
            @(posedge dram_tm_redump[0]);
            //0811//if(rst_n==1)begin
            fork: dram_tm_rdp_0
                begin
                    while(1)begin
                        @(posedge clk);
                        if(tm_redump_h_cnt0 == tm_redump_width-1)begin
                            `uvm_info("tsv_tm_chk", $sformatf("---------tm_redump_h_cnt == tm_redump_width-1----------"), UVM_LOW)
                            #1500ps;
                            `uvm_info("tsv_tm_chk", $sformatf("---------tm_redump_h_cnt == tm_redump_width-1----------"), UVM_LOW)
                            tsv_tm_setup0 = dram_tsv_tm0;
                            @(negedge dram_tm_redump[0]);
                            tsv_tm_current0 = dram_tsv_tm0;
                            #3ns;
                            tsv_tm_hold0 = dram_tsv_tm0;
                            break;
                        end
                        tm_redump_h_cnt0++;
                    end
                    tm_redump_h_cnt0 = 0;
                    if((tsv_tm_setup0 != tsv_tm_current0) || (tsv_tm_hold0 != tsv_tm_current0))
                        `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
                end
                begin
                    //0811//@(negedge rst_n);
                    wait(rst_n==0); //have random delay
                end
            join_any
            disable dram_tm_rdp_0;
            //0811//end
        end
        forever begin
            @(posedge dram_tm_redump[1]);
            //0811//if(rst_n==1)begin
            fork: dram_tm_rdp_1
                begin
                    while(1)begin
                        @(posedge clk);
                        if(tm_redump_h_cnt1 == tm_redump_width-1)begin
                            `uvm_info("tsv_tm_chk", $sformatf("---------tm_redump_h_cnt == tm_redump_width-1----------"), UVM_LOW)
                            #1500ps;
                            `uvm_info("tsv_tm_chk", $sformatf("---------tm_redump_h_cnt == tm_redump_width-1----------"), UVM_LOW)
                            tsv_tm_setup1 = dram_tsv_tm1;
                            @(negedge dram_tm_redump[1]);
                            tsv_tm_current1 = dram_tsv_tm1;
                            #3ns;
                            tsv_tm_hold1 = dram_tsv_tm1;
                            break;
                        end
                        tm_redump_h_cnt1++;
                    end
                    tm_redump_h_cnt1 = 0;
                    if((tsv_tm_setup1 != tsv_tm_current1) || (tsv_tm_hold1 != tsv_tm_current1))
                        `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
                end
                begin
                    //0811//@(negedge rst_n);
                    wait(rst_n==0); //have random delay
                end
            join_any
            disable dram_tm_rdp_1;
            //0811//end
        end
        forever begin
            @(posedge dram_tm_redump[2]);
            //0811//if(rst_n==1)begin
            fork: dram_tm_rdp_2
                begin
                    while(1)begin
                        @(posedge clk);
                        if(tm_redump_h_cnt2 == tm_redump_width-1)begin
                            `uvm_info("tsv_tm_chk", $sformatf("---------tm_redump_h_cnt == tm_redump_width-1----------"), UVM_LOW)
                            #1500ps;
                            `uvm_info("tsv_tm_chk", $sformatf("---------tm_redump_h_cnt == tm_redump_width-1----------"), UVM_LOW)
                            tsv_tm_setup2 = dram_tsv_tm2;
                            @(negedge dram_tm_redump[2]);
                            tsv_tm_current2 = dram_tsv_tm2;
                            #3ns;
                            tsv_tm_hold2 = dram_tsv_tm2;
                            break;
                        end
                        tm_redump_h_cnt2++;
                    end
                    tm_redump_h_cnt2 = 0;
                    if((tsv_tm_setup2 != tsv_tm_current2) || (tsv_tm_hold2 != tsv_tm_current2))
                        `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
                end
                begin
                    //0811//@(negedge rst_n);
                    wait(rst_n==0); //have random delay
                end
            join_any
            disable dram_tm_rdp_2;
            //0811//end
        end
        forever begin
            @(posedge dram_tm_redump[3]);
            //0811//if(rst_n==1)begin
            fork: dram_tm_rdp_3
                begin
                    while(1)begin
                        @(posedge clk);
                        if(tm_redump_h_cnt3 == tm_redump_width-1)begin
                            `uvm_info("tsv_tm_chk", $sformatf("---------tm_redump_h_cnt == tm_redump_width-1----------"), UVM_LOW)
                            #1500ps;
                            `uvm_info("tsv_tm_chk", $sformatf("---------tm_redump_h_cnt == tm_redump_width-1----------"), UVM_LOW)
                            tsv_tm_setup3 = dram_tsv_tm3;
                            @(negedge dram_tm_redump[3]);
                            tsv_tm_current3 = dram_tsv_tm3;
                            #3ns;
                            tsv_tm_hold3 = dram_tsv_tm3;
                            break;
                        end
                        tm_redump_h_cnt3++;
                    end
                    tm_redump_h_cnt3 = 0;
                    if((tsv_tm_setup3 != tsv_tm_current3) || (tsv_tm_hold3 != tsv_tm_current3))
                        `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
                end
                begin
                    //0811//@(negedge rst_n);
                    wait(rst_n==0); //have random delay
                end
            join_any
            disable dram_tm_rdp_3;
            //0811//end
        end
    end

    initial begin
        forever begin
            @(negedge dram_sp_rst_n[0]);
            //0811//if(rst_n==1)begin
            fork: dram_sp_rst_0
                begin
                    while(1)begin
                        @(posedge clk);
                        if(sp_rst_l_cnt0 == spine_reset_width-1)begin
                            `uvm_info("tsv_tm_chk", $sformatf("-----------sp_rst_l_cnt == spine_reset_width-1------------"), UVM_LOW)
                            #1500ps;
                            tsv_tm_setup0 = dram_tsv_tm0;
                            @(posedge dram_sp_rst_n[0]);
                            tsv_tm_current0 = dram_tsv_tm0;
                            #3ns;
                            tsv_tm_hold0 = dram_tsv_tm0;
                            break;
                        end
                        sp_rst_l_cnt0++;
                    end
                    sp_rst_l_cnt0 = 0;
                    if((tsv_tm_setup0 != tsv_tm_current0) || (tsv_tm_hold0 != tsv_tm_current0))
                        `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed:\n\ttsv_tm_setup0=%0h\n\ttsv_tm_current0=%0h\n\ttsv_tm_hold0=%0h", tsv_tm_setup0,tsv_tm_current0,tsv_tm_hold0))
                end
                begin
                    //0811//@(negedge rst_n);
                    wait(rst_n==0); //have random delay
                end
            join_any
            disable dram_sp_rst_0;
            //081//end
        end
        forever begin
            @(negedge dram_sp_rst_n[1]);
            //0811//if(rst_n==1)begin
            fork: dram_sp_rst_1
                begin
                    while(1)begin
                        @(posedge clk);
                        if(sp_rst_l_cnt1 == spine_reset_width-1)begin
                            `uvm_info("tsv_tm_chk", $sformatf("-----------sp_rst_l_cnt == spine_reset_width-1------------"), UVM_LOW)
                            #1500ps;
                            tsv_tm_setup1 = dram_tsv_tm1;
                            @(posedge dram_sp_rst_n[1]);
                            tsv_tm_current1 = dram_tsv_tm1;
                            #3ns;
                            tsv_tm_hold1 = dram_tsv_tm1;
                            break;
                        end
                        sp_rst_l_cnt1++;
                    end
                    sp_rst_l_cnt1 = 0;
                    if((tsv_tm_setup1 != tsv_tm_current1) || (tsv_tm_hold1 != tsv_tm_current1))
                        `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
                end
                begin
                    //0811//@(negedge rst_n);
                    wait(rst_n==0); //have random delay
                end
            join_any
            disable dram_sp_rst_1;
            //0811//end
        end
        forever begin
            @(negedge dram_sp_rst_n[2]);
            //0811//if(rst_n==1)begin
            fork: dram_sp_rst_2
                begin
                    while(1)begin
                        @(posedge clk);
                        if(sp_rst_l_cnt2 == spine_reset_width-1)begin
                            `uvm_info("tsv_tm_chk", $sformatf("-----------sp_rst_l_cnt == spine_reset_width-1------------"), UVM_LOW)
                            #1500ps;
                            tsv_tm_setup2 = dram_tsv_tm2;
                            @(posedge dram_sp_rst_n[2]);
                            tsv_tm_current2 = dram_tsv_tm2;
                            #3ns;
                            tsv_tm_hold2 = dram_tsv_tm2;
                            break;
                        end
                        sp_rst_l_cnt2++;
                    end
                    sp_rst_l_cnt2 = 0;
                    if((tsv_tm_setup2 != tsv_tm_current2) || (tsv_tm_hold2 != tsv_tm_current2))
                        `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
                end
                begin
                    //0811//@(negedge rst_n);
                    wait(rst_n==0); //have random delay
                end
            join_any
            disable dram_sp_rst_2;
            //0811//end
        end
        forever begin
            @(negedge dram_sp_rst_n[3]);
            //0811//if(rst_n==1)begin
            fork: dram_sp_rst_3
                begin
                    while(1)begin
                        @(posedge clk);
                        if(sp_rst_l_cnt3 == spine_reset_width-1)begin
                            `uvm_info("tsv_tm_chk", $sformatf("-----------sp_rst_l_cnt == spine_reset_width-1------------"), UVM_LOW)
                            #1500ps;
                            tsv_tm_setup3 = dram_tsv_tm3;
                            @(posedge dram_sp_rst_n[3]);
                            tsv_tm_current3 = dram_tsv_tm3;
                            #3ns;
                            tsv_tm_hold3 = dram_tsv_tm3;
                            break;
                        end
                        sp_rst_l_cnt3++;
                    end
                    sp_rst_l_cnt3 = 0;
                    if((tsv_tm_setup3 != tsv_tm_current3) || (tsv_tm_hold3 != tsv_tm_current3))
                        `uvm_error("tsv_tm_chk", $sformatf("tsv_tm timing check failed"))
                end
                begin
                    //0811//@(negedge rst_n);
                    wait(rst_n==0); //have random delay
                end
            join_any
            disable dram_sp_rst_3;
            //0811//end
        end

    end


    //----------------------add dump_ready jitter------------------------
    initial begin
        fork
            forever begin
                wait(dump_ready[0]==0);
                wait(dump_ready[0]==1);
                if(timeout_enable==0)begin
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[0]", 0); //trim_tb.u_dram_trim_top.dump_ready
                    #($urandom_range(100,2000)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[0]", 1);
                    uvm_hdl_release("trim_tb.u_dram_trim_top.dump_ready[0]");
                    #($urandom_range(50,200)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[0]", 0);
                    @(posedge clk);
                    #($urandom_range(100,2000)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[0]", 1);
                    uvm_hdl_release("trim_tb.u_dram_trim_top.dump_ready[0]");
                    #($urandom_range(50,200)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[0]", 0);
                    @(posedge clk);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[0]", 1);
                    uvm_hdl_release("trim_tb.u_dram_trim_top.dump_ready[0]");
                end
            end
            forever begin
                wait(dump_ready[1]==0);
                wait(dump_ready[1]==1);
                if(timeout_enable==0)begin
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[1]",0);
                    #($urandom_range(100,2000)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[1]",1);
                    uvm_hdl_release("trim_tb.u_dram_trim_top.dump_ready[1]");
                    #($urandom_range(50,200)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[1]",0);
                    @(posedge clk);
                    #($urandom_range(100,2000)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[1]",1);
                    uvm_hdl_release("trim_tb.u_dram_trim_top.dump_ready[1]");
                    #($urandom_range(50,200)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[1]",0);            
                    @(posedge clk);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[1]",1);
                    uvm_hdl_release("trim_tb.u_dram_trim_top.dump_ready[1]");
                end
            end
            forever begin
                wait(dump_ready[2]==0);
                wait(dump_ready[2]==1);
                if(timeout_enable==0)begin
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[2]",0);
                    #($urandom_range(100,2000)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[2]",1);
                    uvm_hdl_release("trim_tb.u_dram_trim_top.dump_ready[2]");
                    #($urandom_range(50,200)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[2]",0);
                    @(posedge clk);
                    #($urandom_range(100,2000)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[2]",1);
                    uvm_hdl_release("trim_tb.u_dram_trim_top.dump_ready[2]");
                    #($urandom_range(50,200)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[2]",0);
                    @(posedge clk);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[2]",1);
                    uvm_hdl_release("trim_tb.u_dram_trim_top.dump_ready[2]");
                end
            end
            forever begin
                wait(dump_ready[3]==0);
                wait(dump_ready[3]==1);
                if(timeout_enable==0)begin
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[3]",0);
                    #($urandom_range(100,2000)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[3]",1);
                    uvm_hdl_release("trim_tb.u_dram_trim_top.dump_ready[3]");
                    #($urandom_range(50,200)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[3]",0);
                    @(posedge clk);
                    #($urandom_range(100,2000)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[3]",1);
                    uvm_hdl_release("trim_tb.u_dram_trim_top.dump_ready[3]");
                    #($urandom_range(50,200)*1ps);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[3]",0);
                    @(posedge clk);
                    uvm_hdl_force("trim_tb.u_dram_trim_top.dump_ready[3]",1);
                    uvm_hdl_release("trim_tb.u_dram_trim_top.dump_ready[3]");
                end
            end

        join
    end
    

endinterface : trim_if

`endif // TRIM_IF_SV

