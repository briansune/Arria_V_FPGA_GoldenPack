

module arria_v_two_sfp_link(

	input	wire	C15625mhz,
	input	wire	C50mhz,
	
	// SFP A
	inout  wire		SFPA_MOD1_SCL,
	inout  wire		SFPA_MOD2_SDA,
	
	output wire		SFPA_TXDISABLE,
	input  wire		SFPA_RX_p,
	output wire		SFPA_TX_p,
	
	// SFP B
	inout  wire		SFPB_MOD1_SCL,
	inout  wire		SFPB_MOD2_SDA,
	
	output wire		SFPB_TXDISABLE,
	input  wire		SFPB_RX_p,
	output wire		SFPB_TX_p,
	
	input wire		button,
	
	output			xcvr_ll_pll_lock,
	output			clk100mhz_pll_lock
);
	
	wire				tx_ready;
	wire				rx_ready;
	wire				reconfig_busy;
	
	assign SFPA_TXDISABLE = 1'b0;
	assign SFPA_RATESEL = 1'b1;
	assign SFPA_MOD2_SDA = 1'bz;
	assign SFPA_MOD1_SCL = 1'bz;
	
	assign SFPB_TXDISABLE = 1'b0;
	assign SFPB_RATESEL = 1'b1;
	assign SFPB_MOD2_SDA = 1'bz;
	assign SFPB_MOD1_SCL = 1'bz;
	
	low_latency_10g_1ch low_latency_10g_1ch_inst0(
		.refclk_in_clk										(C15625mhz),
		.clk_50_clk											(C50mhz),
		.refclk_reset_reset_n								(button),
		.clk_50_reset_reset_n								(button),
		.xcvr_custom_phy_0_tx_serial_data_export			({SFPB_TX_p,SFPA_TX_p}),
		.xcvr_custom_phy_0_rx_serial_data_export			({SFPB_RX_p,SFPA_RX_p}),
		.xcvr_custom_phy_0_tx_ready_export					(tx_ready),
		.xcvr_custom_phy_0_rx_ready_export					(rx_ready),
		.xcvr_custom_phy_0_pll_locked_export				(xcvr_ll_pll_lock),
		.alt_xcvr_reconfig_0_reconfig_busy_reconfig_busy	(reconfig_busy),
		.pll_0_locked_export								(clk100mhz_pll_lock)
	);
	
endmodule
