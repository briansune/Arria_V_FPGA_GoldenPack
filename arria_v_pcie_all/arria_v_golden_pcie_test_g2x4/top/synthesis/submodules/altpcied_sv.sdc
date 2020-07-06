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


# derive_pll_clock is used to calculate all clock derived from PCIe refclk
# the derive_pll_clocks and derive clock_uncertainty should only
# be applied once across all of the SDC files used in a project
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

##############################################################################
# PHY IP reconfig controller constraints
# Set reconfig_xcvr clock
# this line will likely need to be modified to match the actual clock pin name
# used for this clock, and also changed to have the correct period set for the actually used clock
create_clock -period "125 MHz" -name {clk_clk} {clk_clk}

# HIP testin pins SDC constraints
set_false_path -from [get_pins -compatibility_mode *hip_ctrl*]

