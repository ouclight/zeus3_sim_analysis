##400MHz
set DESIGN_NAME     "mc_subsys_top"
set clk_prd_sys         2.5
set clk_prd_apb         [expr {$clk_prd_sys*40.0}]
set clk_prd_rdrdy       [expr $clk_prd_sys*1 ]
#
###########################create clk#######################################
create_clock -name clk_sys  -period $clk_prd_sys [get_ports clk]
create_clock -name clk_apb  -period $clk_prd_apb [get_ports apb_clk]
create_clock -name clk_rdrdy -period $clk_prd_rdrdy [get_ports rdrdy_n]
#
############################################################################
# when you release to be constraint,you should delete set_ideal_network and set_dont_touch_network
############################################################################
if {$synopsys_program_name == "dc_shell"} {
set_ideal_network       [get_ports "clk_sys clk_apb"]
set_dont_touch_network  [get_ports "clk_sys clk_apb"]

set_ideal_network       [get_ports "rst_n apb_rst_n"]
set_dont_touch_network  [get_ports "rst_n apb_rst_n"]
}
#
######user donot change#######################
set_max_fanout 32 ${DESIGN_NAME}
#
set_clock_uncertainty 0.2 -setup [all_clocks]
#
set_max_transition 0.3 ${DESIGN_NAME}
##############################################
#
set_clock_groups -asynchronous  -group {clk_sys}   \
                                -group {clk_apb}   \
                                -group {clk_rdrdy}
#
set_false_path -to   [get_ports "*monitor* "  -filter {@port_direction == out}]
#
set_false_path -from [get_ports "mc_id " -filter {@port_direction == in}]
#
#
#####ports delay constraints#########################################
set INPUT_APB  [get_ports "global_rf_sel_en       \ 
                           global_rf_sel          \ 
                           global_mc_bist_start   \ 
                           global_mc_bist_en      \ 
                           global_mc_rescan_start \ 
                           global_dram_init_en    \ 
                           global_bist_clr        \ 
                           bist_rescan_num        \ 
                           mc_scan_timeout_en     \ 
                           mc_bist_csl_vmc_en     \ 
                           rf_range_change_en     \ 
                           pre_precharge          \ 
                           page_mode_switch       \ 
                           rf_addr                \
                           apb_rst_n              \
                           apb_sel                \
                           apb_enable             \
                           apb_write              \
                           apb_addr               \
                           apb_wdata              \
                           apb_rdata              \
                           apb_pslverr            \
                           bank_radd_set_time_o   \
                           cadd_set_time_o        \
                           r_cas_set_time_o       \
                           w_cas_set_time_o       \
                           mc_trc_cfg             \
                           mc_tras_cfg            \
                           mc_trp_cfg             \
                           mc_trcd_cfg            \
                           mc_trtp_cfg            \
                           mc_twr_cfg             \
                           mc_twtr_cfg            \
                           mc_trtw_cfg            \
                           mc_trcb_cfg            \
                           csl_err_threshold                  \
                           bist_wl_scan_single_pattern_rd_num \
                           mc_timeout_th          \
                           mc_rf_start_sel        \
                           rf_start_time          \
                           mc_rf_period_sel       \
                           rf_row_num             \
                           rf_single_interval     \
                           mc_apb_rst_ok          \
                           mc2phy_dram_mask         " -filter {@port_direction == in} ]


set OUTPUT_APB  [get_ports "global_rf_sel_en       \ 
                            global_rf_sel          \ 
                            global_mc_bist_start   \ 
                            global_mc_bist_en      \ 
                            global_mc_rescan_start \ 
                            global_dram_init_en    \ 
                            global_bist_clr        \ 
                            bist_rescan_num        \ 
                            mc_scan_timeout_en     \ 
                            mc_bist_csl_vmc_en     \ 
                            rf_range_change_en     \ 
                            pre_precharge          \ 
                            page_mode_switch       \ 
                            rf_addr                \
                            apb_rst_n              \
                            apb_sel                \
                            apb_enable             \
                            apb_write              \
                            apb_addr               \
                            apb_wdata              \
                            apb_rdata              \
                            apb_pslverr            \
                            bank_radd_set_time_o   \
                            cadd_set_time_o        \
                            r_cas_set_time_o       \
                            w_cas_set_time_o       \
                            mc_trc_cfg             \
                            mc_tras_cfg            \
                            mc_trp_cfg             \
                            mc_trcd_cfg            \
                            mc_trtp_cfg            \
                            mc_twr_cfg             \
                            mc_twtr_cfg            \
                            mc_trtw_cfg            \
                            mc_trcb_cfg            \
                            csl_err_threshold                  \
                            bist_wl_scan_single_pattern_rd_num \
                            mc_timeout_th          \
                            mc_rf_start_sel        \
                            rf_start_time          \
                            mc_rf_period_sel       \
                            rf_row_num             \
                            rf_single_interval     \
                            mc_apb_rst_ok          \
                            mc2phy_dram_mask         " -filter {@port_direction == out} ]

set INPUT_SYS  [get_ports "rst_n                  \
                           ras_clr                \
                           dbg_data_store_en      \
                           bnksel_n               \
                           gradd_n                \
                           gcas_wr                \
                           gcas_rd                \
                           gcadd                  \
                           wdl                    \
                           wdl_oe                 \
                           hub_frame_vld          \
                           hub_frame_rdy          \
                           hub_frame_data         \
                           mc_bresp_vld           \
                           mc_rvalid              \
                           mc_rdata               \
                           mc_rresp               \
                           bist_rescan_success    \
                           bist_rescan_finish     \
                           rf_gear_id             \
                           rf_gear_up_en          \
                           mc_sys_rst_ok          \
                           bist_finish_intr       \
                           mc_timeout_intr        \
                           mc_bank_success        \
                           mc_ce_overflow_intr    \
                           mc_uce_intr            \
                           mc_rf_start_en            " -filter {@port_direction == in} ]

set OUTPUT_SYS  [get_ports "rst_n                  \
                            ras_clr                \
                            dbg_data_store_en      \
                            bnksel_n               \
                            gradd_n                \
                            gcas_wr                \
                            gcas_rd                \
                            gcadd                  \
                            wdl                    \
                            wdl_oe                 \
                            hub_frame_vld          \
                            hub_frame_rdy          \
                            hub_frame_data         \
                            mc_bresp_vld           \
                            mc_rvalid              \
                            mc_rdata               \
                            mc_rresp               \
                            bist_rescan_success    \
                            bist_rescan_finish     \
                            rf_gear_id             \
                            rf_gear_up_en          \
                            mc_sys_rst_ok          \
                            bist_finish_intr       \
                            mc_timeout_intr        \
                            mc_bank_success        \
                            mc_ce_overflow_intr    \
                            mc_uce_intr            \
                            mc_rf_start_en             " -filter {@port_direction == out} ]

set RDRDY_DOMAIN_IN    [get_ports "rdl"] 

#
set input_delay_percent  0.6
set output_delay_percent 0.6
#
# for setup check
set_input_delay  [expr {${clk_prd_apb}*${input_delay_percent}}]  -max -clock clk_apb [get_ports $INPUT_APB]
set_input_delay  0  -min -clock clk_apb [get_ports $INPUT_APB]
set_input_delay  [expr ${clk_prd_sys}*${input_delay_percent}]  -max -clock clk_sys [get_ports $INPUT_SYS]
set_input_delay  0  -min -clock clk_sys [get_ports $INPUT_SYS]
set_input_delay  [expr ${clk_prd_rdrdy}*${input_delay_percent}]  -max -clock clk_rdrdy [list $RDRDY_DOMAIN_IN]  
set_input_delay  0  -min -clock clk_rdrdy [list $RDRDY_DOMAIN_IN] 

# for setup check
set_output_delay  [expr ${clk_prd_apb}*${output_delay_percent}]  -max -clock clk_apb [get_ports $OUTPUT_APB]
set_output_delay  0  -min -clock clk_apb [get_ports $OUTPUT_APB]
set_output_delay  [expr ${clk_prd_sys}*${output_delay_percent}]  -max -clock clk_sys [get_ports $OUTPUT_SYS]
set_output_delay  0  -min -clock clk_sys [get_ports $OUTPUT_SYS]


