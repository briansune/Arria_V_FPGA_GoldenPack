#--------------------------------------------------------------#
#
# Set Board pinout
#
load_package report
load_package flow
# Input project name
puts "Info: *******************************************************************"
puts "   Info: Running qii_seed_sweep.tcl "

#----- more assignments for design that includes BUP --------------
set is_bup ""
foreach argument $quartus(args) {
  if { [ string eq "bup" $argument ] } {
    set is_bup "true"
    puts "   Info: Design included BUP"
    break
  }
}

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

# starter kit device according to doc and examples
if { [ string eq "true" $is_bup ] } {   
  set_global_assignment -name DEVICE 5AGXFB3H4F35C4
} else {
  set_global_assignment -name DEVICE 5AGTFC7H3F35I3 
}

#PCIE_REFCLK
set_location_assignment PIN_AA28 -to "refclk_clk(n)"
set_location_assignment PIN_AA27 -to refclk_clk
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to refclk_clk

#clkina_50MHz
set_location_assignment PIN_A19 -to reconfig_xcvr_clk
set_instance_assignment -name IO_STANDARD LVDS -to reconfig_xcvr_clk

#PCIE_PERSTn <-- Needs to be correctly connected to N9 <- Fix will be deployed in Rev B Devkit
set_location_assignment PIN_B2 -to perstn
set_instance_assignment -name IO_STANDARD "2.5 V" -to perstn

#USER_PB0
set_location_assignment PIN_A14 -to local_rstn
set_instance_assignment -name IO_STANDARD "2.5 V" -to local_rstn

#USER_PB1 
set_location_assignment PIN_B15 -to req_compliance_pb
set_instance_assignment -name IO_STANDARD "2.5 V" -to req_compliance_pb

#USER_PB2
set_location_assignment PIN_B14 -to set_compliance_mode
set_instance_assignment -name IO_STANDARD "2.5 V" -to set_compliance_mode

set_location_assignment PIN_AK33 -to "hip_serial_rx_in0(n)"
set_location_assignment PIN_AK34 -to hip_serial_rx_in0
set_location_assignment PIN_AH33 -to "hip_serial_rx_in1(n)"
set_location_assignment PIN_AH34 -to hip_serial_rx_in1
set_location_assignment PIN_AF33 -to "hip_serial_rx_in2(n)"
set_location_assignment PIN_AF34 -to hip_serial_rx_in2
set_location_assignment PIN_AD33 -to "hip_serial_rx_in3(n)"
set_location_assignment PIN_AD34 -to hip_serial_rx_in3
set_location_assignment PIN_Y33 -to "hip_serial_rx_in4(n)"
set_location_assignment PIN_Y34 -to hip_serial_rx_in4
set_location_assignment PIN_V33 -to "hip_serial_rx_in5(n)"
set_location_assignment PIN_V34 -to hip_serial_rx_in5
set_location_assignment PIN_T33 -to "hip_serial_rx_in6(n)"
set_location_assignment PIN_T34 -to hip_serial_rx_in6
set_location_assignment PIN_P33 -to "hip_serial_rx_in7(n)"
set_location_assignment PIN_P34 -to hip_serial_rx_in7

set_location_assignment PIN_AJ31 -to "hip_serial_tx_out0(n)"
set_location_assignment PIN_AJ32 -to hip_serial_tx_out0
set_location_assignment PIN_AG31 -to "hip_serial_tx_out1(n)"
set_location_assignment PIN_AG32 -to hip_serial_tx_out1
set_location_assignment PIN_AE31 -to "hip_serial_tx_out2(n)"
set_location_assignment PIN_AE32 -to hip_serial_tx_out2
set_location_assignment PIN_AC31 -to "hip_serial_tx_out3(n)"
set_location_assignment PIN_AC32 -to hip_serial_tx_out3
set_location_assignment PIN_W31 -to "hip_serial_tx_out4(n)"
set_location_assignment PIN_W32 -to hip_serial_tx_out4
set_location_assignment PIN_U31 -to "hip_serial_tx_out5(n)"
set_location_assignment PIN_U32 -to hip_serial_tx_out5
set_location_assignment PIN_R31 -to "hip_serial_tx_out6(n)"
set_location_assignment PIN_R32 -to hip_serial_tx_out6
set_location_assignment PIN_N31 -to "hip_serial_tx_out7(n)"
set_location_assignment PIN_N32 -to hip_serial_tx_out7

set_location_assignment PIN_G9 -to hsma_clk_out_p2


set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_rx_in0
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_rx_in1
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_rx_in2
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_rx_in3
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_rx_in4
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_rx_in5
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_rx_in6
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_rx_in7
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_tx_out0
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_tx_out1
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_tx_out2
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_tx_out3
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_tx_out4
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_tx_out5
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_tx_out6
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hip_serial_tx_out7

#USER1_LED[0]
set_location_assignment PIN_C16 -to alive_led
set_instance_assignment -name IO_STANDARD "2.5 V" -to alive_led
#USER1_LED[1]
set_location_assignment PIN_C14 -to L0_led
set_instance_assignment -name IO_STANDARD "2.5 V" -to L0_led
#USER1_LED[2] 
set_location_assignment PIN_C13 -to comp_led
set_instance_assignment -name IO_STANDARD "2.5 V" -to comp_led
#USER1_LED[3]
set_location_assignment PIN_D16 -to gen2_led
set_instance_assignment -name IO_STANDARD "2.5 V" -to gen2_led
#PCIE_LED_X1
set_location_assignment PIN_G17 -to lane_active_led[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lane_active_led[0]
#PCIE_LED_x2
set_location_assignment PIN_F17 -to lane_active_led[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lane_active_led[1]
#PCIE_LED_x4
set_location_assignment PIN_G16 -to lane_active_led[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lane_active_led[2]
#PCIE_LED_x8
set_location_assignment PIN_G15 -to lane_active_led[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lane_active_led[3]


set_global_assignment -name FITTER_EFFORT "FAST FIT"

if { [ string eq "true" $is_bup ] } { 

# -------------- BUP Pin & Location Assignments ------------------

set_location_assignment PIN_AP29 -to clkin_50
set_location_assignment PIN_D5 -to cpu_resetn
set_location_assignment PIN_AP19 -to sram_begintransfer_n
set_location_assignment PIN_AM17 -to sram_byteenable_n[0]
set_location_assignment PIN_AM19 -to sram_byteenable_n[1]
set_location_assignment PIN_AN17 -to sram_byteenable_n[2]
set_location_assignment PIN_AN18 -to sram_byteenable_n[3]
set_location_assignment PIN_AL19 -to sram_chipselect_n
set_location_assignment PIN_AL17 -to sram_outputenable_n
set_location_assignment PIN_AP17 -to sram_write_n
set_location_assignment PIN_AL18 -to sram_clk
set_location_assignment PIN_AF22 -to sram_gw_n
set_location_assignment PIN_AG21 -to sram_mode
set_location_assignment PIN_AE19 -to sram_adv_n
set_location_assignment PIN_AF19 -to sram_adsp_n
set_location_assignment PIN_AD21 -to sram_zz
set_location_assignment PIN_AD27 -to fm_d[0]
set_location_assignment PIN_AD26 -to fm_d[1]
set_location_assignment PIN_AE26 -to fm_d[2]
set_location_assignment PIN_AE28 -to fm_d[3]
set_location_assignment PIN_AF29 -to fm_d[4]
set_location_assignment PIN_AF28 -to fm_d[5]
set_location_assignment PIN_AF26 -to fm_d[6]
set_location_assignment PIN_AG29 -to fm_d[7]
set_location_assignment PIN_AG26 -to fm_d[8]
set_location_assignment PIN_AH29 -to fm_d[9]
set_location_assignment PIN_AG27 -to fm_d[10]
set_location_assignment PIN_AH27 -to fm_d[11]
set_location_assignment PIN_AH26 -to fm_d[12]
set_location_assignment PIN_AJ26 -to fm_d[13]
set_location_assignment PIN_AK27 -to fm_d[14]
set_location_assignment PIN_AK26 -to fm_d[15]
set_location_assignment PIN_AL27 -to fm_d[16]
set_location_assignment PIN_AL28 -to fm_d[17]
set_location_assignment PIN_AL29 -to fm_d[18]
set_location_assignment PIN_AE29 -to fm_d[19]
set_location_assignment PIN_AM31 -to fm_d[20]
set_location_assignment PIN_AM29 -to fm_d[21]
set_location_assignment PIN_AM28 -to fm_d[22]
set_location_assignment PIN_AL26 -to fm_d[23]
set_location_assignment PIN_AL25 -to fm_d[24]
set_location_assignment PIN_AM26 -to fm_d[25]
set_location_assignment PIN_AM25 -to fm_d[26]
set_location_assignment PIN_AN26 -to fm_d[27]
set_location_assignment PIN_AP28 -to fm_d[28]
set_location_assignment PIN_AP27 -to fm_d[29]
set_location_assignment PIN_AP26 -to fm_d[30]
set_location_assignment PIN_AP25 -to fm_d[31]
set_location_assignment PIN_AP22 -to fm_a[0] -disable
set_instance_assignment -name VIRTUAL_PIN ON -to fm_a[0]
set_location_assignment PIN_AP23 -to fm_a[1]
set_location_assignment PIN_AN23 -to fm_a[2]
set_location_assignment PIN_AN24 -to fm_a[3]
set_location_assignment PIN_AM23 -to fm_a[4]
set_location_assignment PIN_AL23 -to fm_a[5]
set_location_assignment PIN_AL24 -to fm_a[6]
set_location_assignment PIN_AK24 -to fm_a[7]
set_location_assignment PIN_AK23 -to fm_a[8]
set_location_assignment PIN_AJ23 -to fm_a[9]
set_location_assignment PIN_AJ25 -to fm_a[10]
set_location_assignment PIN_AH23 -to fm_a[11]
set_location_assignment PIN_AH24 -to fm_a[12]
set_location_assignment PIN_AH25 -to fm_a[13]
set_location_assignment PIN_AG23 -to fm_a[14]
set_location_assignment PIN_AG24 -to fm_a[15]
set_location_assignment PIN_AF23 -to fm_a[16]
set_location_assignment PIN_AF25 -to fm_a[17]
set_location_assignment PIN_AE25 -to fm_a[18]
set_location_assignment PIN_AE24 -to fm_a[19]
set_location_assignment PIN_AE23 -to fm_a[20]
set_location_assignment PIN_AP20 -to fm_a[21]
set_location_assignment PIN_AN21 -to fm_a[22]
set_location_assignment PIN_AN20 -to fm_a[23]
set_location_assignment PIN_AM20 -to fm_a[24]
set_location_assignment PIN_AM22 -to fm_a[25]
set_location_assignment PIN_AL20 -to fm_a[26]
set_location_assignment PIN_AK21 -to flash_cen[0]
set_location_assignment PIN_AK20 -to flash_cen[1]
set_location_assignment PIN_AL22 -to flash_oen
set_location_assignment PIN_AH21 -to flash_wen
set_location_assignment PIN_AJ20 -to flash_advn
set_location_assignment PIN_AJ22 -to flash_clk
set_location_assignment PIN_AH22 -to flash_resetn
set_location_assignment PIN_AH20 -to flash_rdybsyn[0]
set_location_assignment PIN_AG20 -to flash_rdybsyn[1]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to flash_advn
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to flash_cen[0]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to flash_cen[1]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to flash_clk
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to flash_oen
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to flash_rdybsyn[0]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to flash_rdybsyn[1]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to flash_resetn
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to flash_wen
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[0]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[1]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[2]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[10]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[11]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[12]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[13]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[14]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[15]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[16]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[17]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[18]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[19]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[20]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[21]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[22]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[23]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[24]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[25]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[26]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[3]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[4]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[5]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[6]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[7]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[8]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_a[9]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[0]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[1]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[10]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[11]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[12]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[13]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[14]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[15]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[2]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[3]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[4]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[5]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[6]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[7]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[8]
set_instance_assignment -name IO_MAXIMUM_TOGGLE_RATE "10 MHz" -to fm_d[9]
set_location_assignment PIN_AH17 -to clkin_125
set_location_assignment PIN_AG17 -to "clkin_125(n)"

set_location_assignment PIN_AP13 -to enet_tx_p
set_location_assignment PIN_AP14 -to enet_rx_p
set_location_assignment PIN_AJ11 -to enet_mdc
set_location_assignment PIN_AH11 -to enet_mdio
set_location_assignment PIN_AL11 -to enet_resetn
set_location_assignment PIN_AN12 -to "enet_tx_p(n)"
set_location_assignment PIN_AN14 -to "enet_rx_p(n)"
set_location_assignment PIN_AC11 -to enet_tx_d[0]
set_location_assignment PIN_AC12 -to enet_tx_d[1]
set_location_assignment PIN_AC13 -to enet_tx_d[2]
set_location_assignment PIN_AB11 -to enet_tx_d[3]
set_location_assignment PIN_AF11 -to enet_rx_d[0]
set_location_assignment PIN_AF13 -to enet_rx_d[1]
set_location_assignment PIN_AE12 -to enet_rx_d[2]
set_location_assignment PIN_AE13 -to enet_rx_d[3]
set_location_assignment PIN_AB12 -to enet_tx_en
set_location_assignment PIN_AB13 -to enet_rx_dv
set_location_assignment PIN_AL4 -to enet_rx_clk
set_location_assignment PIN_AD12 -to enet_gtx_clk
set_location_assignment PIN_C19 -to lcd_data[0]
set_location_assignment PIN_D19 -to lcd_data[1]
set_location_assignment PIN_D18 -to lcd_data[2]
set_location_assignment PIN_D17 -to lcd_data[3]
set_location_assignment PIN_E17 -to lcd_data[4]
set_location_assignment PIN_G19 -to lcd_data[5]
set_location_assignment PIN_E18 -to lcd_data[6]
set_location_assignment PIN_F19 -to lcd_data[7]
set_location_assignment PIN_B18 -to lcd_d_cn
set_location_assignment PIN_C17 -to lcd_wen
set_location_assignment PIN_B17 -to lcd_en
set_location_assignment PIN_D15 -to user_dipsw[0]
set_location_assignment PIN_D14 -to user_dipsw[1]
set_location_assignment PIN_D13 -to user_dipsw[2]
set_location_assignment PIN_E15 -to user_dipsw[3]

# -------------- BUP disabled I/O pin placement used for PCIe --------------
set_location_assignment PIN_C16 -to user_led[0] -disable
set_location_assignment PIN_C14 -to user_led[1] -disable
set_location_assignment PIN_C13 -to user_led[2] -disable
set_location_assignment PIN_D16 -to user_led[3] -disable
set_location_assignment PIN_A14 -to user_pb[0] -disable
set_location_assignment PIN_B15 -to user_pb[1] -disable
set_location_assignment PIN_B14 -to user_pb[2] -disable

# -------------- BUP I/O standards ------------------
set_instance_assignment -name IO_STANDARD LVDS -to clkin_125
set_instance_assignment -name IO_STANDARD LVDS -to enet_rx_p
set_instance_assignment -name IO_STANDARD LVDS -to enet_tx_p

# -------------- BUP Fitter Assignments ------------------

set_instance_assignment -name GLOBAL_SIGNAL "GLOBAL CLOCK" -to clkin_50
set_instance_assignment -name GLOBAL_SIGNAL "GLOBAL CLOCK" -to enet_rx_clk

# -------------- BUP Misc -------------------------------
set_global_assignment -name DEVICE_FILTER_SPEED_GRADE 4_H4

set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top 

}

project_close
return 0
