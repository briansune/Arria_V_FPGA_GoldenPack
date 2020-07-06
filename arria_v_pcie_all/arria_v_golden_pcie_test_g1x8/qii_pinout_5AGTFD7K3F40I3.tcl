#--------------------------------------------------------------#
#
# Set Board pinout
#
load_package report
load_package flow
# Input project name
puts "Info: *******************************************************************"
puts "   Info: Running qii_seed_sweep.tcl "

set project_name  [lindex $quartus(args) 0]
if { [ string eq "" $project_name] } {
   puts "Error: *******************************************************"
   puts "        Invalid first argument                                "
   puts "                                                              "
   puts "  quartus_sh -t qii_seed_sweep.tcl <project>  <revision>      "
   puts "                                                              "
   puts "     <project>      : Quartus II project name  - required     "
   puts "     <revision>     : Quartus II revision name - optional     "
   puts "Error: *******************************************************"
   puts $fileId "   Error: Invalid argument                            "
   close $fileId
   return 1
}
puts "Info: *******************************************************************"
puts "   Info: Quartus project                 : $project_name"


#--------------------------------------------------------------#
#
# Open Quartus II project
#
if { [ project_exists $project_name ]  } {
   project_open $project_name -force
} else {
   puts "Error: *******************************************************************"
   puts "   Error:  Unable to open Quartus II project $project_name"
   puts $fileId "   Error:  Unable to open Quartus II project $project_name"
   close $fileId
   return 1
}

#--------------------------------------------------------------#
#
# Quartus II compilation seed sweeping
#
set_global_assignment -name FAMILY "Arria V"
set_global_assignment -name DEVICE 5AGTFD7K3F40I3
set_location_assignment PIN_AD34 -to "refclk1_ql0_p(n)"
set_location_assignment PIN_AD33 -to refclk1_ql0_p
set_location_assignment PIN_V35 -to "refclk4_ql2_p(n)"
set_location_assignment PIN_V34 -to refclk4_ql2_p
set_location_assignment PIN_T34 -to "refclk5_ql2_p(n)"
set_location_assignment PIN_T33 -to refclk5_ql2_p
set_location_assignment PIN_AF5 -to "refclk0_qr0_p(n)"
set_location_assignment PIN_AF6 -to refclk0_qr0_p
set_location_assignment PIN_AD6 -to "refclk1_qr0_p(n)"
set_location_assignment PIN_AD7 -to refclk1_qr0_p
set_location_assignment PIN_AB5 -to "refclk2_qr1_p(n)"
set_location_assignment PIN_AB6 -to refclk2_qr1_p
set_location_assignment PIN_V5 -to "refclk4_qr2_p(n)"
set_location_assignment PIN_V6 -to refclk4_qr2_p
set_location_assignment PIN_T6 -to "refclk5_qr2_p(n)"
set_location_assignment PIN_T7 -to refclk5_qr2_p
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to refclk1_ql0_p
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to refclk4_ql2_p
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to refclk5_ql2_p
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to refclk0_qr0_p
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to refclk1_qr0_p
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to refclk2_qr1_p
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to refclk4_qr2_p
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to refclk5_qr2_p
set_location_assignment PIN_AG32 -to refclk_clk
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to refclk_clk
set_location_assignment PIN_AF21 -to reconfig_xcvr_clk
set_instance_assignment -name IO_STANDARD LVDS -to reconfig_xcvr_clk
set_location_assignment PIN_R19 -to local_rstn
set_instance_assignment -name IO_STANDARD "2.5 V" -to local_rstn
set_location_assignment PIN_T19 -to req_compliance_pb
set_instance_assignment -name IO_STANDARD "2.5 V" -to req_compliance_pb
set_location_assignment PIN_N18 -to set_compliance_mode
set_instance_assignment -name IO_STANDARD "2.5 V" -to set_compliance_mode
set_location_assignment PIN_AT38 -to "hip_serial_rx_in1(n)"
set_location_assignment PIN_AT39 -to hip_serial_rx_in1
set_location_assignment PIN_AP38 -to "hip_serial_rx_in2(n)"
set_location_assignment PIN_AP39 -to hip_serial_rx_in2
set_location_assignment PIN_AM38 -to "hip_serial_rx_in3(n)"
set_location_assignment PIN_AM39 -to hip_serial_rx_in3
set_location_assignment PIN_AU36 -to "hip_serial_tx_out0(n)"
set_location_assignment PIN_AU37 -to hip_serial_tx_out0
set_location_assignment PIN_AR36 -to "hip_serial_tx_out1(n)"
set_location_assignment PIN_AR37 -to hip_serial_tx_out1
set_location_assignment PIN_AN36 -to "hip_serial_tx_out2(n)"
set_location_assignment PIN_AN37 -to hip_serial_tx_out2
set_location_assignment PIN_AL36 -to "hip_serial_tx_out3(n)"
set_location_assignment PIN_AL37 -to hip_serial_tx_out3
set_location_assignment PIN_G9 -to hsma_clk_out_p2
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_rx_in0
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_rx_in1
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_rx_in2
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_rx_in3
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_tx_out0
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_tx_out1
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_tx_out2
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_tx_out3
set_location_assignment PIN_C15 -to alive_led
set_instance_assignment -name IO_STANDARD "2.5 V" -to alive_led
set_location_assignment PIN_R18 -to L0_led
set_instance_assignment -name IO_STANDARD "2.5 V" -to L0_led
set_location_assignment PIN_F11 -to comp_led
set_instance_assignment -name IO_STANDARD "2.5 V" -to comp_led
set_location_assignment PIN_AP11 -to gen2_led
set_instance_assignment -name IO_STANDARD "2.5 V" -to gen2_led
set_location_assignment PIN_AU14 -to lane_active_led[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lane_active_led[0]
set_location_assignment PIN_AE16 -to lane_active_led[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lane_active_led[1]
set_location_assignment PIN_AF15 -to lane_active_led[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lane_active_led[2]
set_location_assignment PIN_AK15 -to lane_active_led[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lane_active_led[3]



#PCIE_PERSTn <-- Needs to be correctly connected to N9 <- Fix will be deployed in Rev B Devkit
set_location_assignment PIN_N9 -to perstn
set_instance_assignment -name IO_STANDARD "2.5 V" -to perstn

project_close
return 0
