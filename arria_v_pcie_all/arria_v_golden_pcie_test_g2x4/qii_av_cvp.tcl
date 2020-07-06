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
set_global_assignment -name CVP_MODE "POWER UP AND SUBSEQUENT CORE CONFIGURATION"
set_global_assignment -name ENABLE_CVP_CONFDONE ON
set_global_assignment -name CVP_CONFDONE_OPEN_DRAIN ON
set_global_assignment -name USE_CONFIGURATION_DEVICE ON
set_global_assignment -name CRC_ERROR_OPEN_DRAIN ON
#set_global_assignment -name ENABLE_CRC_ERROR_PIN ON
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
set_global_assignment -name ACTIVE_SERIAL_CLOCK FREQ_100MHZ
set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top
project_close
return 0
