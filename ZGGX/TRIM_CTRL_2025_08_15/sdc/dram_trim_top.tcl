##400MHz
set clk_prd_sys         2.5
set clk_prd_apb         [expr {$clk_prd_sys*4.0}]
set clk_prd_vir         [expr {$clk_prd_sys*40.0}]
#
###########################create clk#######################################
create_clock -name clk_sys  -period $clk_prd_sys [get_ports clk]
create_clock -name clk_apb  -period $clk_prd_apb [get_ports apb_clk]
create_clock -name clk_vir  -period $clk_prd_vir -waveform {0 50}
#
if {$synopsys_program_name == "dc_shell"} {
set_ideal_network       [get_ports "clk_sys clk_apb"]
set_dont_touch_network  [get_ports "clk_sys clk_apb"]

set_ideal_network       [get_ports "rst_n apb_rst_n"]
set_dont_touch_network  [get_ports "rst_n apb_rst_n"]
}
######user donot change#######################
#set_max_fanout 32 ${DESIGN_NAME}
#
set_clock_uncertainty 0.2 -setup [all_clocks]
#
#set_max_transition 0.3 ${DESIGN_NAME}
##############################################
#
set_clock_groups -asynchronous  -group {clk_sys}   \
                                -group {clk_apb}   \
                                -group {clk_vir}
#
set_false_path -to   [get_ports "*monitor* "  -filter {@port_direction == out}]
#
set_false_path -from [get_ports "trim_ctrl_id" -filter {@port_direction == in}]
#
#
#####ports delay constraints#########################################
set INPUT_APB  [get_ports "apb_rst_n apb_sel apb_en apb_write apb_addr apb_wdata" -filter {@port_direction == in} ]

set OUTPUT_APB  [get_ports "apb_rdata" -filter {@port_direction == out} ]

set INPUT_VIR  [get_ports "dump_ready stopwatch_ringo osc_tm_res trim_start trim_res" -filter {@port_direction == in} ]

set OUTPUT_SYS  [get_ports "spine_reset_n tm_redump stopwatch_period tsv_tm trim_finish trim_interrupt" -filter {@port_direction == out} ]


#
set input_delay_percent  0.6
set output_delay_percent 0.6
#
#
set_input_delay  [expr {${clk_prd_apb}*${input_delay_percent}}]  -max -clock clk_apb [get_ports $INPUT_APB]
set_input_delay  0  -min -clock clk_apb [get_ports $INPUT_APB]
set_input_delay  [expr ${clk_prd_vir}*${input_delay_percent}]  -max -clock clk_vir [get_ports $INPUT_VIR]
set_input_delay  0  -min -clock clk_vir [get_ports $INPUT_VIR]

#
set_output_delay  [expr ${clk_prd_apb}*${output_delay_percent}]  -max -clock clk_apb [get_ports $OUTPUT_APB]
set_output_delay  0  -min -clock clk_apb [get_ports $OUTPUT_APB]
set_output_delay  [expr ${clk_prd_sys}*${output_delay_percent}]  -max -clock clk_sys [get_ports $OUTPUT_SYS]
set_output_delay  0  -min -clock clk_sys [get_ports $OUTPUT_SYS]


