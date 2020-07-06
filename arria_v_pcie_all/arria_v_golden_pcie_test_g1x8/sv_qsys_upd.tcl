package require -exact qsys 12.1

###########################################################
# BEGIN QSYS SYSTEM INFORMATION
set NAME_OF_SV_QSYS_SYSTEM_TO_BE_REFRESHED "top.qsys"
set NAME_PCIE_HIP_INSTANCE_IN_QSYS "DUT"
# END QSYS SYSTEM INFORMATION
###########################################################

   load_system $NAME_OF_SV_QSYS_SYSTEM_TO_BE_REFRESHED
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS bypass_cdc_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS enable_rx_buffer_checking_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS disable_link_x2_support_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS wrong_device_id_hwtcl  "disable"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS data_pack_rx_hwtcl  "disable"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS ltssm_1ms_timeout_hwtcl  "disable"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS ltssm_freqlocked_check_hwtcl  "disable"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS deskew_comma_hwtcl  "com_deskw"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS device_number_hwtcl  0
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS pipex1_debug_sel_hwtcl  "disable"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS pclk_out_sel_hwtcl  "pclk"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS no_soft_reset_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS maximum_current_hwtcl  0
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS d1_support_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS d2_support_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS d0_pme_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS d1_pme_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS d2_pme_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS d3_hot_pme_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS d3_cold_pme_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS low_priority_vc_hwtcl  "single_vc"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS disable_snoop_packet_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS enable_l1_aspm_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS set_l0s_hwtcl  0
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS l1_exit_latency_sameclock_hwtcl  0
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS l1_exit_latency_diffclock_hwtcl  0
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS hot_plug_support_hwtcl  0
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS diffclock_nfts_count_hwtcl  128
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS extended_tag_reset_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS no_command_completed_hwtcl  "true"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS interrupt_pin_hwtcl  "inta"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS bridge_port_vga_enable_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS bridge_port_ssid_support_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS ssvid_hwtcl  0
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS ssid_hwtcl  0
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS eie_before_nfts_count_hwtcl  4
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS gen2_diffclock_nfts_count_hwtcl  255
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS gen2_sameclock_nfts_count_hwtcl  255
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS l0_exit_latency_sameclock_hwtcl  6
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS l0_exit_latency_diffclock_hwtcl  6
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS atomic_op_routing_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS atomic_op_completer_32bit_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS atomic_op_completer_64bit_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS cas_completer_128bit_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS ltr_mechanism_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS tph_completer_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS extended_format_field_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS atomic_malformed_hwtcl  "true"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS flr_capability_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS enable_adapter_half_rate_mode_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS vc0_clk_enable_hwtcl  "true"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS register_pipe_signals_hwtcl  "false"
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS skp_os_gen3_count_hwtcl  0
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS tx_cdc_almost_empty_hwtcl  5
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS rx_l0s_count_idl_hwtcl  0
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS cdc_dummy_insert_limit_hwtcl  11
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS ei_delay_powerdown_count_hwtcl  10
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS skp_os_schedule_count_hwtcl  0
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS fc_init_timer_hwtcl  1024
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS l01_entry_latency_hwtcl  31
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS flow_control_update_count_hwtcl  30
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS flow_control_timeout_count_hwtcl  200
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS override_rxbuffer_cred_preset  0
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS retry_buffer_last_active_address_hwtcl  2047
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS reserved_debug_hwtcl  0
   set_instance_parameter_value $NAME_PCIE_HIP_INSTANCE_IN_QSYS gen3_rxfreqlock_counter_hwtcl  0
save_system $NAME_OF_SV_QSYS_SYSTEM_TO_BE_REFRESHED
