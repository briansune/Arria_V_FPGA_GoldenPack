# (C) 2001-2017 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


set_false_path -from [get_keepers *altera_avalon_data_pattern_checker:*|pattern_select*]
set_false_path -from [get_keepers *altera_avalon_data_pattern_checker:*|clock_sensor*] -to [get_keepers *altera_avalon_data_pattern_checker:*|avs_readdata[1]*]
set_false_path -from [get_keepers *altera_avalon_data_pattern_checker:*|snap_handshake_clock_crosser:*|din*] -to [get_keepers *altera_avalon_data_pattern_checker:*|snap_handshake_clock_crosser:*|dout*]
set_false_path -from [get_keepers *altera_avalon_data_pattern_checker:*|snap_handshake_clock_crosser:*|dout*]

#set_false_path -from {reset} -to {altera_avalon_data_pattern_checker:data_pattern_checker_inst|*}; 
#set_false_path -from {altera_avalon_data_pattern_checker:data_pattern_checker_inst|snap_handshake_clock_crosser:snapper|clr_reg} -to {altera_avalon_data_pattern_checker:data_pattern_checker_inst|snap_handshake_clock_crosser:snapper|altera_reset_controller:reset_controller|altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}; 
#set_false_path -from {altera_avalon_data_pattern_checker:data_pattern_checker_inst|snap_handshake_clock_crosser:snapper|clr_reg} -to {altera_avalon_data_pattern_checker:data_pattern_checker_inst|snap_handshake_clock_crosser:snapper|altera_reset_controller:reset_controller|altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[0]}; 
#set_false_path -from {altera_avalon_data_pattern_checker:data_pattern_checker_inst|snap_handshake_clock_crosser:snapper|clr_reg} -to {altera_avalon_data_pattern_checker:data_pattern_checker_inst|snap_handshake_clock_crosser:snapper|altera_reset_controller:reset_controller|altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out}; 
#set_false_path -from {altera_avalon_data_pattern_checker:data_pattern_checker_inst|reset_counter_reg} -to {altera_avalon_data_pattern_checker:data_pattern_checker_inst|altera_reset_controller:counter_reset_controller|altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}; 
#set_false_path -from {altera_avalon_data_pattern_checker:data_pattern_checker_inst|reset_counter_reg} -to {altera_avalon_data_pattern_checker:data_pattern_checker_inst|altera_reset_controller:counter_reset_controller|altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[0]}; 
#set_false_path -from {altera_avalon_data_pattern_checker:data_pattern_checker_inst|reset_counter_reg} -to {altera_avalon_data_pattern_checker:data_pattern_checker_inst|altera_reset_controller:counter_reset_controller|altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out}; 
#set_false_path -from {altera_avalon_data_pattern_checker:data_pattern_checker_inst|reset_clock_sensor_reg} -to {altera_avalon_data_pattern_checker:data_pattern_checker_inst|altera_reset_controller:clock_sensor_reset_controller|altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}; 
#set_false_path -from {altera_avalon_data_pattern_checker:data_pattern_checker_inst|reset_clock_sensor_reg} -to {altera_avalon_data_pattern_checker:data_pattern_checker_inst|altera_reset_controller:clock_sensor_reset_controller|altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[0]}; 
#set_false_path -from {altera_avalon_data_pattern_checker:data_pattern_checker_inst|reset_clock_sensor_reg} -to {altera_avalon_data_pattern_checker:data_pattern_checker_inst|altera_reset_controller:clock_sensor_reset_controller|altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out}
