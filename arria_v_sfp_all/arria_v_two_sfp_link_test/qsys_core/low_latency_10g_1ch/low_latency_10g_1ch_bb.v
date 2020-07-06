
module low_latency_10g_1ch (
	alt_xcvr_reconfig_0_reconfig_busy_reconfig_busy,
	clk_50_clk,
	clk_50_reset_reset_n,
	pll_0_locked_export,
	refclk_in_clk,
	refclk_reset_reset_n,
	xcvr_custom_phy_0_pll_locked_export,
	xcvr_custom_phy_0_rx_ready_export,
	xcvr_custom_phy_0_rx_serial_data_export,
	xcvr_custom_phy_0_tx_ready_export,
	xcvr_custom_phy_0_tx_serial_data_export);	

	output		alt_xcvr_reconfig_0_reconfig_busy_reconfig_busy;
	input		clk_50_clk;
	input		clk_50_reset_reset_n;
	output		pll_0_locked_export;
	input		refclk_in_clk;
	input		refclk_reset_reset_n;
	output	[0:0]	xcvr_custom_phy_0_pll_locked_export;
	output		xcvr_custom_phy_0_rx_ready_export;
	input	[1:0]	xcvr_custom_phy_0_rx_serial_data_export;
	output		xcvr_custom_phy_0_tx_ready_export;
	output	[1:0]	xcvr_custom_phy_0_tx_serial_data_export;
endmodule
