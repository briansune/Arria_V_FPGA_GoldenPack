
module top (
	clk_clk,
	ddr_sfp_side_signal_export,
	dp_switch_export,
	hip_ctrl_test_in,
	hip_ctrl_simu_mode_pipe,
	hip_pipe_sim_pipe_pclk_in,
	hip_pipe_sim_pipe_rate,
	hip_pipe_sim_ltssmstate,
	hip_pipe_eidleinfersel0,
	hip_pipe_eidleinfersel1,
	hip_pipe_eidleinfersel2,
	hip_pipe_eidleinfersel3,
	hip_pipe_powerdown0,
	hip_pipe_powerdown1,
	hip_pipe_powerdown2,
	hip_pipe_powerdown3,
	hip_pipe_rxpolarity0,
	hip_pipe_rxpolarity1,
	hip_pipe_rxpolarity2,
	hip_pipe_rxpolarity3,
	hip_pipe_txcompl0,
	hip_pipe_txcompl1,
	hip_pipe_txcompl2,
	hip_pipe_txcompl3,
	hip_pipe_txdata0,
	hip_pipe_txdata1,
	hip_pipe_txdata2,
	hip_pipe_txdata3,
	hip_pipe_txdatak0,
	hip_pipe_txdatak1,
	hip_pipe_txdatak2,
	hip_pipe_txdatak3,
	hip_pipe_txdetectrx0,
	hip_pipe_txdetectrx1,
	hip_pipe_txdetectrx2,
	hip_pipe_txdetectrx3,
	hip_pipe_txelecidle0,
	hip_pipe_txelecidle1,
	hip_pipe_txelecidle2,
	hip_pipe_txelecidle3,
	hip_pipe_txdeemph0,
	hip_pipe_txdeemph1,
	hip_pipe_txdeemph2,
	hip_pipe_txdeemph3,
	hip_pipe_txmargin0,
	hip_pipe_txmargin1,
	hip_pipe_txmargin2,
	hip_pipe_txmargin3,
	hip_pipe_txswing0,
	hip_pipe_txswing1,
	hip_pipe_txswing2,
	hip_pipe_txswing3,
	hip_pipe_phystatus0,
	hip_pipe_phystatus1,
	hip_pipe_phystatus2,
	hip_pipe_phystatus3,
	hip_pipe_rxdata0,
	hip_pipe_rxdata1,
	hip_pipe_rxdata2,
	hip_pipe_rxdata3,
	hip_pipe_rxdatak0,
	hip_pipe_rxdatak1,
	hip_pipe_rxdatak2,
	hip_pipe_rxdatak3,
	hip_pipe_rxelecidle0,
	hip_pipe_rxelecidle1,
	hip_pipe_rxelecidle2,
	hip_pipe_rxelecidle3,
	hip_pipe_rxstatus0,
	hip_pipe_rxstatus1,
	hip_pipe_rxstatus2,
	hip_pipe_rxstatus3,
	hip_pipe_rxvalid0,
	hip_pipe_rxvalid1,
	hip_pipe_rxvalid2,
	hip_pipe_rxvalid3,
	hip_serial_rx_in0,
	hip_serial_rx_in1,
	hip_serial_rx_in2,
	hip_serial_rx_in3,
	hip_serial_tx_out0,
	hip_serial_tx_out1,
	hip_serial_tx_out2,
	hip_serial_tx_out3,
	led_wire_export,
	pcie_256_hip_lock_fixedclk_locked,
	pcie_nrst_npor,
	pcie_nrst_pin_perst,
	pcie_refclk_clk,
	reset_reset_n);	

	input		clk_clk;
	input	[2:0]	ddr_sfp_side_signal_export;
	input	[1:0]	dp_switch_export;
	input	[31:0]	hip_ctrl_test_in;
	input		hip_ctrl_simu_mode_pipe;
	input		hip_pipe_sim_pipe_pclk_in;
	output	[1:0]	hip_pipe_sim_pipe_rate;
	output	[4:0]	hip_pipe_sim_ltssmstate;
	output	[2:0]	hip_pipe_eidleinfersel0;
	output	[2:0]	hip_pipe_eidleinfersel1;
	output	[2:0]	hip_pipe_eidleinfersel2;
	output	[2:0]	hip_pipe_eidleinfersel3;
	output	[1:0]	hip_pipe_powerdown0;
	output	[1:0]	hip_pipe_powerdown1;
	output	[1:0]	hip_pipe_powerdown2;
	output	[1:0]	hip_pipe_powerdown3;
	output		hip_pipe_rxpolarity0;
	output		hip_pipe_rxpolarity1;
	output		hip_pipe_rxpolarity2;
	output		hip_pipe_rxpolarity3;
	output		hip_pipe_txcompl0;
	output		hip_pipe_txcompl1;
	output		hip_pipe_txcompl2;
	output		hip_pipe_txcompl3;
	output	[7:0]	hip_pipe_txdata0;
	output	[7:0]	hip_pipe_txdata1;
	output	[7:0]	hip_pipe_txdata2;
	output	[7:0]	hip_pipe_txdata3;
	output		hip_pipe_txdatak0;
	output		hip_pipe_txdatak1;
	output		hip_pipe_txdatak2;
	output		hip_pipe_txdatak3;
	output		hip_pipe_txdetectrx0;
	output		hip_pipe_txdetectrx1;
	output		hip_pipe_txdetectrx2;
	output		hip_pipe_txdetectrx3;
	output		hip_pipe_txelecidle0;
	output		hip_pipe_txelecidle1;
	output		hip_pipe_txelecidle2;
	output		hip_pipe_txelecidle3;
	output		hip_pipe_txdeemph0;
	output		hip_pipe_txdeemph1;
	output		hip_pipe_txdeemph2;
	output		hip_pipe_txdeemph3;
	output	[2:0]	hip_pipe_txmargin0;
	output	[2:0]	hip_pipe_txmargin1;
	output	[2:0]	hip_pipe_txmargin2;
	output	[2:0]	hip_pipe_txmargin3;
	output		hip_pipe_txswing0;
	output		hip_pipe_txswing1;
	output		hip_pipe_txswing2;
	output		hip_pipe_txswing3;
	input		hip_pipe_phystatus0;
	input		hip_pipe_phystatus1;
	input		hip_pipe_phystatus2;
	input		hip_pipe_phystatus3;
	input	[7:0]	hip_pipe_rxdata0;
	input	[7:0]	hip_pipe_rxdata1;
	input	[7:0]	hip_pipe_rxdata2;
	input	[7:0]	hip_pipe_rxdata3;
	input		hip_pipe_rxdatak0;
	input		hip_pipe_rxdatak1;
	input		hip_pipe_rxdatak2;
	input		hip_pipe_rxdatak3;
	input		hip_pipe_rxelecidle0;
	input		hip_pipe_rxelecidle1;
	input		hip_pipe_rxelecidle2;
	input		hip_pipe_rxelecidle3;
	input	[2:0]	hip_pipe_rxstatus0;
	input	[2:0]	hip_pipe_rxstatus1;
	input	[2:0]	hip_pipe_rxstatus2;
	input	[2:0]	hip_pipe_rxstatus3;
	input		hip_pipe_rxvalid0;
	input		hip_pipe_rxvalid1;
	input		hip_pipe_rxvalid2;
	input		hip_pipe_rxvalid3;
	input		hip_serial_rx_in0;
	input		hip_serial_rx_in1;
	input		hip_serial_rx_in2;
	input		hip_serial_rx_in3;
	output		hip_serial_tx_out0;
	output		hip_serial_tx_out1;
	output		hip_serial_tx_out2;
	output		hip_serial_tx_out3;
	output	[7:0]	led_wire_export;
	output		pcie_256_hip_lock_fixedclk_locked;
	input		pcie_nrst_npor;
	input		pcie_nrst_pin_perst;
	input		pcie_refclk_clk;
	input		reset_reset_n;
endmodule
