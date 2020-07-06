
module arria_v_sfp_a_si5338_udp(
	
	input  wire					sys_rst_n,
	
	input  wire					si5338_clk3,
	
	inout						si5338_sda,
	output						si5338_scl,
	
	// LEDs
	output wire		[7 : 0]		LED,
	
	// 50 MHz clock inputs
	input  wire					clk_50mhz,
	
	// 10G Ethernet
	inout  wire					SFPA_MOD1_SCL,
	inout  wire					SFPA_MOD2_SDA,
	output wire					SFPA_TXDISABLE,
	input  wire					SFPA_RX_p,
	output wire					SFPA_TX_p
);
	
	// Clock and reset
	wire rst_50mhz;
	
	wire clk_156mhz;
	wire rst_156mhz;
	
	wire phy_pll_locked;
	wire osc_done;
	
	assign LED = ~{4'd0, rst_156mhz, rst_50mhz, phy_pll_locked, osc_done};
	
	// Convert XGMII interfaces
	wire	[63 : 0]	sfp_a_txd_int;
	wire	[7 : 0]		sfp_a_txc_int;
	wire	[63 : 0]	sfp_a_rxd_int;
	wire	[7 : 0]		sfp_a_rxc_int;
	
	// 10G Ethernet PHY
	wire	[71 : 0]	sfp_a_tx_dc;
	wire	[71 : 0]	sfp_a_rx_dc;
	
	wire	[91 : 0]	phy_reconfig_from_xcvr;
	wire	[139 : 0]	phy_reconfig_to_xcvr;
	
	wire reconfig_busy_sig;
	
	assign SFPA_MOD1_SCL = 1'bz;
	assign SFPA_MOD2_SDA = 1'bz;
	assign SFPA_TXDISABLE = 1'b0;
	
	sync_reset #(
		.N(4)
	)sync_reset_50mhz_inst(
		.clk(clk_50mhz),
		.rst(~sys_rst_n),
		.sync_reset_out(rst_50mhz)
	);
	
	sync_reset #(
		.N(4)
	)sync_reset_156mhz_inst(
		.clk(clk_156mhz),
		.rst(rst_50mhz | ~phy_pll_locked | reconfig_busy_sig),
		.sync_reset_out(rst_156mhz)
	);
	
	si5338_init_core si5338_init_core_inst(
		
		.CLK			(clk_50mhz),	// input  CLK_sig
		.RSTn			(~rst_50mhz),	// input  RSTn_sig
		.SCL			(si5338_scl),	// output  SCL_sig
		.SDA			(si5338_sda),	// inout  SDA_sig
		.osc_done		(osc_done) 		// output  osc_done_sig
	);
	
	phy phy_inst(
		
		.pll_ref_clk(si5338_clk3),
		.pll_locked(phy_pll_locked),
		
		.tx_serial_data_0(SFPA_TX_p),
		.rx_serial_data_0(SFPA_RX_p),
		
		.xgmii_tx_dc_0(sfp_a_tx_dc),
		.xgmii_rx_dc_0(sfp_a_rx_dc),
		
		.xgmii_rx_clk(clk_156mhz),
		.xgmii_tx_clk(clk_156mhz),
		
		.tx_ready(),
		.rx_ready(),
		
		.rx_data_ready(),
		
		.phy_mgmt_clk(clk_50mhz),
		.phy_mgmt_clk_reset(~osc_done),
		.phy_mgmt_address(9'd0),
		.phy_mgmt_read(1'b0),
		.phy_mgmt_readdata(),
		.phy_mgmt_waitrequest(),
		.phy_mgmt_write(1'b0),
		.phy_mgmt_writedata(32'd0),
		
		.reconfig_from_xcvr(phy_reconfig_from_xcvr),
		.reconfig_to_xcvr(phy_reconfig_to_xcvr)
	);
	
	phy_reconfig phy_reconfig_inst(
		
		.reconfig_busy(reconfig_busy_sig),
		.cal_busy_in(1'b0),
		
		.mgmt_clk_clk(clk_50mhz),
		.mgmt_rst_reset(~osc_done),
		
		.reconfig_mgmt_address(7'd0),
		.reconfig_mgmt_read(1'b0),
		.reconfig_mgmt_readdata(),
		.reconfig_mgmt_waitrequest(),
		.reconfig_mgmt_write(1'b0),
		.reconfig_mgmt_writedata(32'd0),
		
		.reconfig_to_xcvr(phy_reconfig_to_xcvr),
		.reconfig_from_xcvr(phy_reconfig_from_xcvr)
	);
	
	xgmii_interleave xgmii_interleave_inst_a(
		.input_xgmii_d(sfp_a_txd_int),
		.input_xgmii_c(sfp_a_txc_int),
		.output_xgmii_dc(sfp_a_tx_dc)
	);
	
	xgmii_deinterleave xgmii_deinterleave_inst_a(
		.input_xgmii_dc(sfp_a_rx_dc),
		.output_xgmii_d(sfp_a_rxd_int),
		.output_xgmii_c(sfp_a_rxc_int)
	);
	
	network network_inst(
		
		.clk(clk_156mhz),
		.rst(rst_156mhz),
		
		.sfp_a_txd(sfp_a_txd_int),
		.sfp_a_txc(sfp_a_txc_int),
		.sfp_a_rxd(sfp_a_rxd_int),
		.sfp_a_rxc(sfp_a_rxc_int)
	);
	
endmodule
