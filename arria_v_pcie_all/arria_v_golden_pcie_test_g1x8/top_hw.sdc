
create_clock -period "100 MHz" -name {refclk_clk} {*refclk_clk*}
create_clock -period "125 MHz" -name {reconfig_xcvr_clk} {*reconfig_xcvr_clk*}
create_clock -period "125 MHz" -name {hsma_clk_out_p2} {*hsma_clk_out_p2*}

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

set_input_delay  -add_delay  -clock [get_clocks {altera_reserved_tck}]  20.000 [get_ports {altera_reserved_tdi}]
set_input_delay  -add_delay  -clock [get_clocks {altera_reserved_tck}]  20.000 [get_ports {altera_reserved_tms}]
set_output_delay -add_delay  -clock [get_clocks {altera_reserved_tck}]  20.000 [get_ports {altera_reserved_tdo}]

set_false_path -from [get_ports {reconfig_xcvr_clk}] -to [get_ports {hsma_clk_out_p2}]
set_false_path -from [get_ports {perstn}]
set_false_path -from [get_ports {local_rstn}]
set_false_path -to [get_ports {L0_led}]
set_false_path -to [get_ports {alive_led}]
set_false_path -to [get_ports {comp_led}]
set_false_path -to [get_ports {gen2_led}]
set_false_path -to [get_ports {lane_active_led[0]}]
set_false_path -to [get_ports {lane_active_led[1]}]
set_false_path -to [get_ports {lane_active_led[2]}]
set_false_path -to [get_ports {lane_active_led[3]}]

set_false_path -from [get_clocks {altera_reserved_tck}] -to [get_clocks *]

set_false_path -from [get_clocks {reconfig_xcvr_clk}] -to [get_clocks {*arriav_hd_altpe2_hip_top|coreclkout}]
set_false_path -from [get_clocks {*arriav_hd_altpe2_hip_top|coreclkout}] -to [get_clocks {reconfig_xcvr_clk}]
