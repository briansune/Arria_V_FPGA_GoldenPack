
module top (
	clk_clk,
	dut_hip_ctrl_test_in,
	dut_hip_ctrl_simu_mode_pipe,
	dut_hip_pipe_sim_pipe_pclk_in,
	dut_hip_pipe_sim_pipe_rate,
	dut_hip_pipe_sim_ltssmstate,
	dut_hip_pipe_eidleinfersel0,
	dut_hip_pipe_eidleinfersel1,
	dut_hip_pipe_eidleinfersel2,
	dut_hip_pipe_eidleinfersel3,
	dut_hip_pipe_powerdown0,
	dut_hip_pipe_powerdown1,
	dut_hip_pipe_powerdown2,
	dut_hip_pipe_powerdown3,
	dut_hip_pipe_rxpolarity0,
	dut_hip_pipe_rxpolarity1,
	dut_hip_pipe_rxpolarity2,
	dut_hip_pipe_rxpolarity3,
	dut_hip_pipe_txcompl0,
	dut_hip_pipe_txcompl1,
	dut_hip_pipe_txcompl2,
	dut_hip_pipe_txcompl3,
	dut_hip_pipe_txdata0,
	dut_hip_pipe_txdata1,
	dut_hip_pipe_txdata2,
	dut_hip_pipe_txdata3,
	dut_hip_pipe_txdatak0,
	dut_hip_pipe_txdatak1,
	dut_hip_pipe_txdatak2,
	dut_hip_pipe_txdatak3,
	dut_hip_pipe_txdetectrx0,
	dut_hip_pipe_txdetectrx1,
	dut_hip_pipe_txdetectrx2,
	dut_hip_pipe_txdetectrx3,
	dut_hip_pipe_txelecidle0,
	dut_hip_pipe_txelecidle1,
	dut_hip_pipe_txelecidle2,
	dut_hip_pipe_txelecidle3,
	dut_hip_pipe_txswing0,
	dut_hip_pipe_txswing1,
	dut_hip_pipe_txswing2,
	dut_hip_pipe_txswing3,
	dut_hip_pipe_txmargin0,
	dut_hip_pipe_txmargin1,
	dut_hip_pipe_txmargin2,
	dut_hip_pipe_txmargin3,
	dut_hip_pipe_txdeemph0,
	dut_hip_pipe_txdeemph1,
	dut_hip_pipe_txdeemph2,
	dut_hip_pipe_txdeemph3,
	dut_hip_pipe_phystatus0,
	dut_hip_pipe_phystatus1,
	dut_hip_pipe_phystatus2,
	dut_hip_pipe_phystatus3,
	dut_hip_pipe_rxdata0,
	dut_hip_pipe_rxdata1,
	dut_hip_pipe_rxdata2,
	dut_hip_pipe_rxdata3,
	dut_hip_pipe_rxdatak0,
	dut_hip_pipe_rxdatak1,
	dut_hip_pipe_rxdatak2,
	dut_hip_pipe_rxdatak3,
	dut_hip_pipe_rxelecidle0,
	dut_hip_pipe_rxelecidle1,
	dut_hip_pipe_rxelecidle2,
	dut_hip_pipe_rxelecidle3,
	dut_hip_pipe_rxstatus0,
	dut_hip_pipe_rxstatus1,
	dut_hip_pipe_rxstatus2,
	dut_hip_pipe_rxstatus3,
	dut_hip_pipe_rxvalid0,
	dut_hip_pipe_rxvalid1,
	dut_hip_pipe_rxvalid2,
	dut_hip_pipe_rxvalid3,
	dut_hip_serial_rx_in0,
	dut_hip_serial_rx_in1,
	dut_hip_serial_rx_in2,
	dut_hip_serial_rx_in3,
	dut_hip_serial_tx_out0,
	dut_hip_serial_tx_out1,
	dut_hip_serial_tx_out2,
	dut_hip_serial_tx_out3,
	dut_npor_npor,
	dut_npor_pin_perst,
	dut_refclk_clk,
	pld_clk_clk,
	reset_reset_n,
	status_hip_derr_cor_ext_rcv,
	status_hip_derr_cor_ext_rpl,
	status_hip_derr_rpl,
	status_hip_dlup_exit,
	status_hip_ev128ns,
	status_hip_ev1us,
	status_hip_hotrst_exit,
	status_hip_int_status,
	status_hip_l2_exit,
	status_hip_lane_act,
	status_hip_ltssmstate,
	status_hip_ko_cpl_spc_header,
	status_hip_ko_cpl_spc_data,
	tl_cfg_tl_cfg_add,
	tl_cfg_tl_cfg_ctl,
	tl_cfg_tl_cfg_sts);	

	input		clk_clk;
	input	[31:0]	dut_hip_ctrl_test_in;
	input		dut_hip_ctrl_simu_mode_pipe;
	input		dut_hip_pipe_sim_pipe_pclk_in;
	output	[1:0]	dut_hip_pipe_sim_pipe_rate;
	output	[4:0]	dut_hip_pipe_sim_ltssmstate;
	output	[2:0]	dut_hip_pipe_eidleinfersel0;
	output	[2:0]	dut_hip_pipe_eidleinfersel1;
	output	[2:0]	dut_hip_pipe_eidleinfersel2;
	output	[2:0]	dut_hip_pipe_eidleinfersel3;
	output	[1:0]	dut_hip_pipe_powerdown0;
	output	[1:0]	dut_hip_pipe_powerdown1;
	output	[1:0]	dut_hip_pipe_powerdown2;
	output	[1:0]	dut_hip_pipe_powerdown3;
	output		dut_hip_pipe_rxpolarity0;
	output		dut_hip_pipe_rxpolarity1;
	output		dut_hip_pipe_rxpolarity2;
	output		dut_hip_pipe_rxpolarity3;
	output		dut_hip_pipe_txcompl0;
	output		dut_hip_pipe_txcompl1;
	output		dut_hip_pipe_txcompl2;
	output		dut_hip_pipe_txcompl3;
	output	[7:0]	dut_hip_pipe_txdata0;
	output	[7:0]	dut_hip_pipe_txdata1;
	output	[7:0]	dut_hip_pipe_txdata2;
	output	[7:0]	dut_hip_pipe_txdata3;
	output		dut_hip_pipe_txdatak0;
	output		dut_hip_pipe_txdatak1;
	output		dut_hip_pipe_txdatak2;
	output		dut_hip_pipe_txdatak3;
	output		dut_hip_pipe_txdetectrx0;
	output		dut_hip_pipe_txdetectrx1;
	output		dut_hip_pipe_txdetectrx2;
	output		dut_hip_pipe_txdetectrx3;
	output		dut_hip_pipe_txelecidle0;
	output		dut_hip_pipe_txelecidle1;
	output		dut_hip_pipe_txelecidle2;
	output		dut_hip_pipe_txelecidle3;
	output		dut_hip_pipe_txswing0;
	output		dut_hip_pipe_txswing1;
	output		dut_hip_pipe_txswing2;
	output		dut_hip_pipe_txswing3;
	output	[2:0]	dut_hip_pipe_txmargin0;
	output	[2:0]	dut_hip_pipe_txmargin1;
	output	[2:0]	dut_hip_pipe_txmargin2;
	output	[2:0]	dut_hip_pipe_txmargin3;
	output		dut_hip_pipe_txdeemph0;
	output		dut_hip_pipe_txdeemph1;
	output		dut_hip_pipe_txdeemph2;
	output		dut_hip_pipe_txdeemph3;
	input		dut_hip_pipe_phystatus0;
	input		dut_hip_pipe_phystatus1;
	input		dut_hip_pipe_phystatus2;
	input		dut_hip_pipe_phystatus3;
	input	[7:0]	dut_hip_pipe_rxdata0;
	input	[7:0]	dut_hip_pipe_rxdata1;
	input	[7:0]	dut_hip_pipe_rxdata2;
	input	[7:0]	dut_hip_pipe_rxdata3;
	input		dut_hip_pipe_rxdatak0;
	input		dut_hip_pipe_rxdatak1;
	input		dut_hip_pipe_rxdatak2;
	input		dut_hip_pipe_rxdatak3;
	input		dut_hip_pipe_rxelecidle0;
	input		dut_hip_pipe_rxelecidle1;
	input		dut_hip_pipe_rxelecidle2;
	input		dut_hip_pipe_rxelecidle3;
	input	[2:0]	dut_hip_pipe_rxstatus0;
	input	[2:0]	dut_hip_pipe_rxstatus1;
	input	[2:0]	dut_hip_pipe_rxstatus2;
	input	[2:0]	dut_hip_pipe_rxstatus3;
	input		dut_hip_pipe_rxvalid0;
	input		dut_hip_pipe_rxvalid1;
	input		dut_hip_pipe_rxvalid2;
	input		dut_hip_pipe_rxvalid3;
	input		dut_hip_serial_rx_in0;
	input		dut_hip_serial_rx_in1;
	input		dut_hip_serial_rx_in2;
	input		dut_hip_serial_rx_in3;
	output		dut_hip_serial_tx_out0;
	output		dut_hip_serial_tx_out1;
	output		dut_hip_serial_tx_out2;
	output		dut_hip_serial_tx_out3;
	input		dut_npor_npor;
	input		dut_npor_pin_perst;
	input		dut_refclk_clk;
	output		pld_clk_clk;
	input		reset_reset_n;
	output		status_hip_derr_cor_ext_rcv;
	output		status_hip_derr_cor_ext_rpl;
	output		status_hip_derr_rpl;
	output		status_hip_dlup_exit;
	output		status_hip_ev128ns;
	output		status_hip_ev1us;
	output		status_hip_hotrst_exit;
	output	[3:0]	status_hip_int_status;
	output		status_hip_l2_exit;
	output	[3:0]	status_hip_lane_act;
	output	[4:0]	status_hip_ltssmstate;
	output	[7:0]	status_hip_ko_cpl_spc_header;
	output	[11:0]	status_hip_ko_cpl_spc_data;
	output	[3:0]	tl_cfg_tl_cfg_add;
	output	[31:0]	tl_cfg_tl_cfg_ctl;
	output	[52:0]	tl_cfg_tl_cfg_sts;
endmodule
