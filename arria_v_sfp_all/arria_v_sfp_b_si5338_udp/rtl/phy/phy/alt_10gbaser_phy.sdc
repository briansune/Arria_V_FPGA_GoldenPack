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


#**************************************************************
# Time Information
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************

#**************************************************************
# Create Generated Clock
#**************************************************************

#**************************************************************
# Set Clock Latency
#**************************************************************

#**************************************************************
# Set Clock Uncertainty
#**************************************************************

#**************************************************************
# Set Input Delay
#**************************************************************

# Function to constraint non-std_synchronizer path
proc altera_10gbaser_phy_constraint_net_delay {from_reg to_reg max_net_delay {check_exist 0}} {
    
    # Check for instances
    set inst [get_registers -nowarn ${to_reg}]
    
    # Check number of instances
    set inst_num [llength [query_collection -report -all $inst]]
    if {$inst_num > 0} {
        # Uncomment line below for debug purpose
        #puts "${inst_num} ${to_reg} instance(s) found"
    } else {
        # Uncomment line below for debug purpose
        #puts "No ${to_reg} instance found"
    }
    
    if {($check_exist == 0) || ($inst_num > 0)} {
        if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
            set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 100ns
            set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -100ns
        } else {
            set_net_delay -from [get_pins -compatibility_mode ${from_reg}|q] -to [get_registers ${to_reg}] -max $max_net_delay
            
            # Relax the fitter effort
            set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 100ns
            set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -100ns
        }
    }
}

# 1588
altera_10gbaser_phy_constraint_net_delay *altera_10gbaser_phy_rx_fifo*octet_del_en_start_wrclk *altera_10gbaser_phy_rx_fifo*sync_del_en_rdclk*sync_regs[0] 6ns 1
altera_10gbaser_phy_constraint_net_delay *stratixv_10gbaser_1588_ppm_counter*sample_cntr_a *bitsync2_1588*sync_regs[0] 5ns 1
altera_10gbaser_phy_constraint_net_delay *stratixv_10gbaser_1588_ppm_counter*run_cntr_a *bitsync2_1588*sync_regs[1] 5ns 1

# Sync register (externalized from embedded SDC)
altera_10gbaser_phy_constraint_net_delay * *av_xcvr_10gbaser_nr*sync_block_lock[2]* 6ns 1
altera_10gbaser_phy_constraint_net_delay * *av_xcvr_10gbaser_nr*sync_hi_ber[2]* 6ns 1
altera_10gbaser_phy_constraint_net_delay * *av_xcvr_10gbaser_nr*sync_rx_data_ready[2]* 6ns 1

altera_10gbaser_phy_constraint_net_delay *altera_10gbaser_phy_clockcomp*phcomp_wren_reg *altera_10gbaser_phy_clockcomp*bitsync2_phcomp_wren*sync_regs[0] 6ns
altera_10gbaser_phy_constraint_net_delay *altera_10gbaser_phy_rx_fifo*cur_data_in* *altera_10gbaser_phy_rx_fifo*bitsync2_block_lock*sync_regs[0] 6ns

# Async reset constraint
set_false_path -to [get_pins -compatibility_mode *altera_10gbaser_phy_clk_ctrl*tx_pma_rstn*|clrn]
set_false_path -to [get_pins -compatibility_mode *altera_10gbaser_phy_clk_ctrl*rx_pma_rstn*|clrn]
set_false_path -to [get_pins -compatibility_mode *altera_10gbaser_phy_clk_ctrl*rx_usr_rstn*|clrn]
set_false_path -to [get_pins -compatibility_mode *altera_10gbaser_phy_clk_ctrl*tx_usr_rstn*|clrn]

# DCFIFO async reset constraint
set_false_path -to [get_pins -compatibility_mode *altera_10gbaser_phy_async_fifo_fpga*dffpipe*rdaclr*|clrn]
set_false_path -to [get_pins -compatibility_mode *altera_10gbaser_phy_async_fifo_fpga*dffpipe*wraclr*|clrn]

set regs [get_pins -compatibility_mode -nowarn *stratixv_10gbaser_1588_ppm_counter*sync_rst_b_n*|clrn]
if {[llength [query_collection -report -all $regs]] > 0} {
    set_false_path -to $regs
}


# Clock crosser constraint
set inst [get_registers -nowarn *altera_10gbaser_phy_clock_crosser*]
set inst_num [llength [query_collection -report -all $inst]]
if {$inst_num > 0} {
    # -----------------------------------------------------------------------------
    # Altera timing constraints for Avalon clock domain crossing (CDC) paths.
    # The purpose of these constraints is to remove the false paths and replace with timing bounded 
    # requirements for compilation.
    #
    # ***Important note *** 
    #
    # The clocks involved in this transfer must be kept synchronous and no false path
    # should be set on these paths for these constraints to apply correctly.
    # -----------------------------------------------------------------------------

    set temp_inst "altera_10gbaser_phy_clock_crosser:"
    set_net_delay -from [get_registers *${temp_inst}*|in_data_buffer* ] -to [get_registers *${temp_inst}*|out_data_buffer* ] -max 5ns
    set_max_delay -from [get_registers *${temp_inst}*|in_data_buffer* ] -to [get_registers *${temp_inst}*|out_data_buffer* ] 100
    set_min_delay -from [get_registers *${temp_inst}*|in_data_buffer* ] -to [get_registers *${temp_inst}*|out_data_buffer* ] -100

    set temp_inst "altera_10gbaser_phy_clock_crosser:*|altera_std_synchronizer_nocut:"
    set_net_delay -from [get_registers * ] -to [get_registers *${temp_inst}*|din_s1 ] -max 5ns
    set_max_delay -from [get_registers * ] -to [get_registers *${temp_inst}*|din_s1 ] 100
    set_min_delay -from [get_registers * ] -to [get_registers *${temp_inst}*|din_s1 ] -100

    # -----------------------------------------------------------------------------
    # This procedure constrains the skew between the token and data bits, and should
    # be called from the top level SDC, once per instance of the clock crosser.
    #
    # The hierarchy path to the handshake clock crosser instance is required as an 
    # argument.
    #
    # In practice, the token and data bits tend to be placed close together, making
    # excessive skew less of an issue.
    # -----------------------------------------------------------------------------
    proc altera_10gbaser_phy_constrain_clock_crosser_skew { path } {

        set in_regs  [ get_registers $path|*altera_10gbaser_phy_clock_crosser*|in_data_buffer* ] 
        set out_regs [ get_registers $path|*altera_10gbaser_phy_clock_crosser*|out_data_buffer* ] 

        set in_regs [ add_to_collection $in_regs  [ get_registers $path|*altera_10gbaser_phy_clock_crosser*|in_data_toggle ] ]
        set out_regs [ add_to_collection $out_regs [ get_registers $path|*altera_10gbaser_phy_clock_crosser:*|altera_std_synchronizer_nocut:in_to_out_synchronizer|din_s1 ] ]

        set_max_skew -from $in_regs -to $out_regs 6 
    }
}

# Function to constraint pointers
proc altera_10gbaser_phy_constraint_ptr {from_path from_reg to_path to_reg max_skew max_net_delay} {
    
    if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
        # Check for instances
        set inst [get_registers -nowarn *${from_path}|${from_reg}*]
        
        # Check number of instances
        set inst_num [llength [query_collection -report -all $inst]]
        if {$inst_num > 0} {
            # Uncomment line below for debug purpose
            #puts "${inst_num} ${from_path}|${from_reg} instance(s) found"
        } else {
            # Uncomment line below for debug purpose
            #puts "No ${from_path}|${from_reg} instance found"
        }
        
        # Constraint one instance at a time to avoid set_max_skew apply to all instances
        foreach_in_collection each_inst_tmp $inst {
            set each_inst [get_node_info -name $each_inst_tmp]
            # Get the path to instance
            regexp "(.*${from_path})(.*|)(${from_reg})" $each_inst reg_path inst_path inst_name reg_name
            
            set_max_skew -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] $max_skew
            
            set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] 100ns
            set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] -100ns
        }
        
    } else {
        set_net_delay -from [get_pins -compatibility_mode *${from_path}|${from_reg}*|q] -to [get_registers *${to_path}|${to_reg}*] -max $max_net_delay
        
        # Relax the fitter effort
        set_max_delay -from [get_registers *${from_path}|${from_reg}*] -to [get_registers *${to_path}|${to_reg}*] 100ns
        set_min_delay -from [get_registers *${from_path}|${from_reg}*] -to [get_registers *${to_path}|${to_reg}*] -100ns
        
    }
    
}

# DCFIFO pointer constraint
altera_10gbaser_phy_constraint_ptr  altera_10gbaser_phy_clockcomp:tx_altera_10gbaser_phy_clockcomp|altera_10gbaser_phy_async_fifo_fpga:altera_10gbaser_phy_async_fifo_fpga|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  delayed_wrptr_g  altera_10gbaser_phy_clockcomp:tx_altera_10gbaser_phy_clockcomp|altera_10gbaser_phy_async_fifo_fpga:altera_10gbaser_phy_async_fifo_fpga|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:rs_dgwp*|*  *dffe*  6ns  5ns
altera_10gbaser_phy_constraint_ptr  altera_10gbaser_phy_clockcomp:tx_altera_10gbaser_phy_clockcomp|altera_10gbaser_phy_async_fifo_fpga:altera_10gbaser_phy_async_fifo_fpga|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  rdptr_g          altera_10gbaser_phy_clockcomp:tx_altera_10gbaser_phy_clockcomp|altera_10gbaser_phy_async_fifo_fpga:altera_10gbaser_phy_async_fifo_fpga|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:ws_dgrp*|*  *dffe*  6ns  5ns
altera_10gbaser_phy_constraint_ptr  altera_10gbaser_phy_rx_fifo:av_rx_fifo|altera_10gbaser_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  delayed_wrptr_g    altera_10gbaser_phy_rx_fifo:av_rx_fifo|altera_10gbaser_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:rs_dgwp*|*  *dffe*  6ns  5ns
altera_10gbaser_phy_constraint_ptr  altera_10gbaser_phy_rx_fifo:av_rx_fifo|altera_10gbaser_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  rdptr_g            altera_10gbaser_phy_rx_fifo:av_rx_fifo|altera_10gbaser_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:ws_dgrp*|*  *dffe*  6ns  5ns

