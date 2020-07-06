#-----------------------------------------------------------------------------
#Copyright (C) 1991-2008 Altera Corporation
#Your use of Altera Corporation's design tools, logic functions
#and other software and tools, and its AMPP partner logic
#functions, and any output files from any of the foregoing
#(including device programming or simulation files), and any
#associated documentation or information are expressly subject
#to the terms and conditions of the Altera Program License
#Subscription Agreement, Altera MegaCore Function License
#Agreement, or other applicable license agreement, including,
#without limitation, that your use is for the sole purpose of
#programming logic devices manufactured by Altera and sold by
#Altera or its authorized distributors.  Please refer to the
#applicable agreement for further details.


#--------------------------------------------------------------#
#
# Load TCL package
#
load_package report
load_package flow

##############################################################
#
set ArcTestRpt "qii_seed_sweep.txt"
set fileId [ open $ArcTestRpt "w" ]
#--------------------------------------------------------------#
#
# qii_seed_sweep.tcl is a Quartus II tcl script used by the
# PCI Express IP advisor.
#
# This script performs the following  :
#
#   1. Open the Quartus II <project>
#   2. Increment the Quartus II seed value
#   3. Compile the Quartus II <project>
#   4. Retrieve fmax value for <clock_name>.
#   5. If TimeQuest timings are not met go to to step 2. else end.
#

# Input project name
puts "Info: *******************************************************************"
puts "   Info: Running qii_seed_sweep.tcl "

set project_name  [lindex $quartus(args) 0]
if { [ string eq "" $project_name] } {
   puts "Error: ********************************************************************************"
   puts "        Invalid first argument                                                         "
   puts "                                                                                       "
   puts "  quartus_sh -t qii_seed_sweep.tcl <project>  <revision> <QtEffort> <MaxSeed> <SkipSta>"
   puts "                                                                                       "
   puts "     <project>      : Quartus II project name  - required                              "
   puts "     <revision>     : Quartus II revision name - optional                              "
   puts "     <QtEffort>     : Compilation effort       - optional                              "
   puts "     <MaxSeed>      : Maximum number of seed   - optional                              "
   puts "     <SkipSta>      : Skip sta analysis        - optional                              "
   puts "                      1 : Skip error on Sta                                            "
   puts "                      2 : Skip Sta hold analysis                                       "
   puts "                      3 : Skip Sta removal analysis                                    "
   puts "                      4 : Skip Sta recovery analysis                                   "
   puts "                      5 : Skip Sta hold or removal analysis                            "
   puts "                      6 : Skip Sta removal or recovery analysis                        "
   puts "                      7 : Skip Sta hold or removal or recovery analysis                "
   puts "                                                                                       "
   puts "Error: ********************************************************************************"
   puts $fileId "   Error: Invalid argument                                                     "
   close $fileId
   return 1
}
puts "Info: *******************************************************************"
puts "   Info: Quartus project                 : $project_name"


#--------------------------------------------------------------#
#
# Global variables section
#
# $QtEffort
#     0 : Fast compilation
#     1 : Medium compilation
#     2 : Long compilation
#     10 : Keep current QSF setting and don't iterate
set QtEffort  [lindex $quartus(args) 2]
if { [ string eq "" $QtEffort] } {
   set QtEffort 1
}

puts "Info: *******************************************************************"
if { $QtEffort < 3 } {
   puts "   Info: Quartus II maximum compilation effort   : $QtEffort"
} else {
   puts "   Info: Quartus II Compilation using existing QSF, no seed sweep"
}

# $MaxSeed set the maximum number of seed to run
# when $MaxSeed = -1; infinite loop keep running sweep
set MaxSeed  [lindex $quartus(args) 3]
if { [ string eq "" $MaxSeed] } {
   set MaxSeed 1
}
if { $QtEffort < 3 } {
   puts "Info: *******************************************************************"
   puts "   Info: Maximum number of seeds         : $MaxSeed"
}

#
# Test skip STA error when SkipSta is set
# which is needed when using OCP or SignalTap or ES silicon
set SkipSta  [lindex $quartus(args) 4]
if { [ string eq "" $SkipSta] } {
   set SkipSta 0
}
puts "Info: *******************************************************************"
if       { $SkipSta ==0   } {
   puts "   will return error if STA timings are not met"
} elseif { $SkipSta ==  1 } {
   puts "   will not return error if STA timings are not met"
} elseif { $SkipSta ==  2 } {
   puts "   will not iterate if STA hold timing failures"
} elseif { $SkipSta ==  3 } {
   puts "   will not iterate if STA removal timing failures"
} elseif { $SkipSta ==  4 } {
   puts "   will not iterate if STA recovery timing failures"
} elseif { $SkipSta ==  5 } {
   puts "   will not iterate if STA hold or removal timing failures"
} elseif { $SkipSta ==  6 } {
   puts "   will not iterate if STA removal or recovery timing failures"
} elseif { $SkipSta ==  7 } {
   puts "   will not iterate if STA hold or removal or recovery timing failures"
} else   {
   puts "   Incorrect value ; reset to 0; will return error if STA timings are not met"
   $SkipSta=0;
}

#--------------------------------------------------------------#
#
# Error string matching in qii.rpt
# match only the error line which starts with Error:
#
set err_rpt_str_match "Error:*"

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
set QtSeed 0
set QtLoop 1
if {$MaxSeed == -1 } {
   set QtEffort 2
}

set passed_timequest 0

# First compilation cycle uses original QSF
set start_ori_qsf 1

#--------------------------------------------------------------#
#
# Quartus II compilation seed sweeping
#
while { $QtLoop > 0 } {
   #--------------------------------------------------------------#
   #
   # Update project assignments
   #
   set_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER ON
   set_global_assignment -name PROJECT_OUTPUT_DIRECTORY pcie_quartus_files
   if { $start_ori_qsf == 0 } {
   # After first compilation using original QSF, update QSF settings
      set SEEDQSF [ expr { int ( rand() * 101) } ]
      puts "Info: *******************************************************************"
      puts "   Info: Current Seed                    : $SEEDQSF"
      puts " "
      set_global_assignment -name SEED $SEEDQSF
      set_global_assignment -name SMART_RECOMPILE ON
      set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
      set_global_assignment -name TIMEQUEST_MULTICORNER_ANALYSIS ON
      set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON
      set_global_assignment -name OPTIMIZATION_TECHNIQUE SPEED

      if { $QtEffort == 1 } {
         set_global_assignment -name FITTER_EFFORT "AUTO FIT"
         set_global_assignment -name PHYSICAL_SYNTHESIS_EFFORT NORMAL
         set_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
         set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
         set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
         set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS"
      } elseif { $QtEffort == 2 } {
         set_global_assignment -name FITTER_EFFORT "STANDARD FIT"
         set_global_assignment -name PHYSICAL_SYNTHESIS_EFFORT EXTRA
         set_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
         set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
         set_global_assignment -name PHYSICAL_SYNTHESIS_ASYNCHRONOUS_SIGNAL_PIPELINING ON
         set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
         set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS"
      } else {
         set_global_assignment -name FITTER_EFFORT "FAST FIT"
         set_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC OFF
         set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
         set_global_assignment -name PHYSICAL_SYNTHESIS_ASYNCHRONOUS_SIGNAL_PIPELINING OFF
         set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
         set_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC_FOR_AREA OFF
         set_global_assignment -name PHYSICAL_SYNTHESIS_MAP_LOGIC_TO_MEMORY_FOR_AREA OFF
      }
   }

   set FITTER_EFFORT               [ get_global_assignment -name FITTER_EFFORT ]
   set PHYSICAL_SYNTHESIS_EFFORT   [ get_global_assignment -name PHYSICAL_SYNTHESIS_EFFORT ]
   set CURRENT_SEED                [ get_global_assignment -name SEED ]

   #--------------------------------------------------------------#
   #
   # Run Quartus II full compilation
   #
   if { [ catch { execute_module -tool map } result ] } {
      set fp [ open "$project_name.map.rpt" r]
      set tool_error ""
      set get_error 0
      while {[gets $fp line] >=0} {
         if { [ string match $err_rpt_str_match $line ] } {
           if { $get_error == 0 } {
            set tool_error $line
           }
           set get_error 1
         }
      }
      close $fp
      puts "Error: *******************************************************************"
      puts "   Error: Compiling project $project_name"
      puts "   $tool_error"
      puts $fileId "Error: quartus_map fails $tool_error"
      close $fileId
      return 1
   }

   set INCREMENTAL_COMPILATION  [get_global_assignment -name INCREMENTAL_COMPILATION ]
   if { [ string match *ON* $INCREMENTAL_COMPILATION ] } {
      if { [ catch { execute_module -tool cdb -args --merge=on } result ] } {
         set fp [ open "$project_name.merge.rpt" r]
         set tool_error ""
         set get_error 0
         while {[gets $fp line] >=0} {
            if { [ string match $err_rpt_str_match $line ] } {
              if { $get_error == 0 } {
               set tool_error $line
              }
              set get_error 1
            }
         }
         close $fp
         puts "Error: *******************************************************************"
         puts "   Error: Compiling project $project_name"
         puts "   $tool_error"
         puts $fileId "Error: quartus_cdb fails $tool_error"
         close $fileId
         return 1
      }
   }


   if { [ catch { execute_module -tool fit } result ] } {
      set fp [ open "$project_name.fit.rpt" r]
      set tool_error ""
      set get_error 0
      while {[gets $fp line] >=0} {
         if { [ string match $err_rpt_str_match $line ] } {
           if { $get_error == 0 } {
            set tool_error $line
           }
           set get_error 1
         }
      }
      close $fp
      puts "Error: *******************************************************************"
      puts "   Error: Compiling project $project_name"
      puts "   $tool_error"
      puts $fileId "Error: quartus_fit fails $tool_error"
      close $fileId
      return 1
   }

   if { [ catch { execute_module -tool sta } result ] } {
      set fp [ open "$project_name.sta.rpt" r]
      set tool_error ""
      set get_error 0
      while {[gets $fp line] >=0} {
         if { [ string match $err_rpt_str_match $line ] } {
           if { $get_error == 0 } {
            set tool_error $line
           }
           set get_error 1
         }
      }
      close $fp
      puts "Error: *******************************************************************"
      puts "   Error: Compiling project $project_name"
      puts "   $tool_error"
      puts $fileId "Error: quartus_sta fails $tool_error"
      close $fileId
      return 1
   }

   set passed_timequest 1
   #--------------------------------------------------------------#
   #
   # Check negative Slack in TimeQuest Report panel
   #
   load_report $project_name
   set TIMING_FAILURE ""
   foreach panel [get_report_panel_names] {
      set id      [get_report_panel_id $panel]
      set row_cnt [get_number_of_rows -id $id]
      if {[string match "*Setup Summary" $panel] == 1 && $passed_timequest ==1} {
         for { set r 1 } {$r<$row_cnt} {incr r} {
            set c0 [get_report_panel_data -id $id -row $r -col 0]
            set c1 [get_report_panel_data -id $id -row $r -col 1]
            if { $c1<0 } {
               puts "   Info: Negative slack"
               puts "   Info: Setup Summary panel : clock $c0 --> $c1"
               set TIMING_FAILURE "Setup Summary panel : clock $c0 --> $c1"
               set passed_timequest 0
            }
         }
      }
      if {[string match "*Hold Summary" $panel] == 1 && $passed_timequest==1} {
         for { set r 1 } {$r<$row_cnt} {incr r} {
            set c0 [get_report_panel_data -id $id -row $r -col 0]
            set c1 [get_report_panel_data -id $id -row $r -col 1]
            if { $c1<0 } {
               puts "   Info: Negative slack"
               puts "   Info: Hold Summary panel : clock $c0 --> $c1"
               puts "   Info: Recovery Summary panel : clock $c0 --> $c1"
               if { $SkipSta == 2 || $SkipSta==5 || $SkipSta==7 } {
                  puts "   Info: Hold Summary panel : clock $c0 --> $c1"
                  puts "   Info: Recovery Summary panel : clock $c0 --> $c1"
               } else {
                  set TIMING_FAILURE "Hold Summary panel : clock $c0 --> $c1"
                  set passed_timequest 0
               }
            }
         }
      }
      if {[string match "*Recovery Summary" $panel] == 1 && $passed_timequest==1} {
         for { set r 1 } {$r<$row_cnt} {incr r} {
            set c0 [get_report_panel_data -id $id -row $r -col 0]
            set c1 [get_report_panel_data -id $id -row $r -col 1]
            if { $c1<0 } {
               puts "   Info: Negative slack"
               puts "   Info: Recovery Summary panel : clock $c0 --> $c1"
               if { $SkipSta == 7 || $SkipSta==6 || $SkipSta==5 || $SkipSta==4 } {
                  puts "   Info: Negative slack"
                  puts "   Info: Recovery Summary panel : clock $c0 --> $c1"
               } else {
                  set TIMING_FAILURE "Recovery Summary panel : clock $c0 --> $c1"
                  set passed_timequest 0
               }
            }
         }
      }
      if {[string match "*Removal Summary" $panel] == 1 && $passed_timequest==1} {
         for { set r 1 } {$r<$row_cnt} {incr r} {
            set c0 [get_report_panel_data -id $id -row $r -col 0]
            set c1 [get_report_panel_data -id $id -row $r -col 1]
            if { $c1<0 } {
               puts "   Info: Negative slack"
               puts "   Info: Removal Summary panel : clock $c0 --> $c1"
               if { $SkipSta == 7 || $SkipSta==6 || $SkipSta==3} {
                  puts "   Info: Negative slack"
                  puts "   Info: Removal Summary panel : clock $c0 --> $c1"
               } else {
                  set TIMING_FAILURE "Removal Summary panel : clock $c0 --> $c1"
                  set passed_timequest 0
               }
            }
         }
      }
   }

   unload_report $project_name

   puts "Info: *******************************************************************"
   puts "   Info: SEED                        : $CURRENT_SEED"
   puts "   Info: FITTER_EFFORT               : $FITTER_EFFORT"
   puts "   Info: PHYSICAL_SYNTHESIS_EFFORT   : $PHYSICAL_SYNTHESIS_EFFORT"
   if {  $passed_timequest==0 } {
      puts "   Info: Negative slack"
      puts "   Info: $TIMING_FAILURE"
   }
   #--------------------------------------------------------------#
   #
   # Check if achieved required Fmax
   #
   if { $passed_timequest==1 } {
      # return the seed sweeping loop
      set QtLoop 0
   } else {
      if { $start_ori_qsf == 0 } {
         set MaxSeedEffort $MaxSeed
         #if { $QtEffort==0 } {
         #   set MaxSeedEffort 1
         #}
         puts "   Info: TimeQuest timings are not met "
         set QtSeed [expr $QtSeed + 1]
         if { $MaxSeed==-1 || $MaxSeedEffort>$QtSeed  }  {
            puts "   Info: starting next iteration "
         } elseif { $QtEffort ==0 } {
            set QtEffort 1
            set QtSeed 0
         } elseif { $QtEffort==1 } {
            set QtEffort 2
            set QtSeed 0
         } else {
            # tried all seeds, all qt effort, return the seed sweeping loop
            set QtLoop 0
         }
      } elseif { $MaxSeed==0 } {
         # only runs original CSF
         set QtLoop 0
      } else {
         set start_ori_qsf 0
      }
   }
}

# Run DRC at the end TODO Analyze DRC report
if { [ catch { execute_module -tool asm } result ] } {
   set fp [ open "$project_name.asm.rpt" r]
   set tool_error ""
   set get_error 0
   while {[gets $fp line] >=0} {
      if { [ string match $err_rpt_str_match $line ] } {
        if { $get_error == 0 } {
         set tool_error $line
        }
        set get_error 1
      }
   }
   close $fp
   puts "Error: *******************************************************************"
   puts "   Error: Compiling project $project_name"
   puts "   $tool_error"
   puts $fileId "Error: quartus_asm fails $tool_error"
   close $fileId
   return 1
}
if { [ catch { execute_module -tool drc } result ] } {
   set fp [ open "$project_name.drc.rpt" r]
   set tool_error ""
   set get_error 0
   while {[gets $fp line] >=0} {
      if { [ string match $err_rpt_str_match $line ] } {
        if { $get_error == 0 } {
         set tool_error $line
        }
        set get_error 1
      }
   }
   close $fp
   puts "Error: *******************************************************************"
   puts "   Error: Compiling project $project_name"
   puts "   $tool_error"
   puts $fileId "Error: quartus_drc fails $tool_error"
   close $fileId
   return 1
}

project_close

if {$passed_timequest==1} {
   puts "   Info: TimeQuest timings are met "
   puts "   Info: see file : $project_name.sta.rpt"
   puts  ""
   puts  $fileId "PASS"
   close $fileId
   return 0
} else {
   puts "Error: *******************************************************************"
   puts "   Error: TimeQuest timings are not met accross all seeds and quartus compilation effort "
   puts "   Error: see file : $project_name.sta.rpt"
   puts ""
   if {$SkipSta==1} {
      puts  $fileId "PASS"
   } else {
      # Skip timing failure reporting
      puts $fileId "Error: $TIMING_FAILURE "
   }
   close $fileId
   return 6
}

