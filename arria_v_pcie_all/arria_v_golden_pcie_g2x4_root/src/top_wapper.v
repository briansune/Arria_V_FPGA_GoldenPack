//=======================================================
//	
//	Author:		Brian SUNE
//	
//	Purpose:	Altera Arria V Golden Top
//	
//	Language:	Verilog
//	
//	Tab Size:	4 spaces = 1 Tab
//	
//=======================================================



module top_wapper(
	
	//============== CPU_RESET_n ==============
	input					CPU_RESET_n,
	
	//============== CLOCK ==============
	input					OSC_50,
	
	//============== PCIe ==============
	input 		          		PCIE_PERST_n,
	input 		          		PCIE_REFCLK_p,
	input 		     [3:0]		PCIE_RX_p,
	output		     [3:0]		PCIE_TX_p,
	
	//============== LED ==============
	output			[7 : 0]		LED,
	
	//============== LED ==============
	output			[0 : 0]		PUSH_BUT
);
	
	wire	[7 : 0]		led_sig;
	
	//reset Synchronizer
	wire	any_rstn;
	reg		any_rstn_r  /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R102"  */;
	reg		any_rstn_rr /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R102"  */;
	
	wire				ddr_sfp_cal_success;
	wire				ddr_sfp_cal_fail;
	wire				ddr_sfp_init_done;
	wire	[2 : 0]		ddr_sfp_status;
	
	wire	[31 : 0]	pcie_hip_ctrl_test_in;
	
	wire				global_nrst;
	
	// LED indicators
	assign LED[3 : 0] = ~led_sig;
	
	assign 	any_rstn = PCIE_PERST_n & CPU_RESET_n;
	
	assign pcie_hip_ctrl_test_in[4:0]	= 5'b01000;
	assign pcie_hip_ctrl_test_in[5]		= 1'b1;
	assign pcie_hip_ctrl_test_in[31:6]	= 26'h2;
	
	assign ddr_sfp_status = {ddr_sfp_cal_success,ddr_sfp_cal_fail,ddr_sfp_init_done};
	
	assign global_nrst = (CPU_RESET_n == 1'b0) ? 1'b0 : (PCIE_PERST_n == 1'b0) ? 1'b0 : 1'b1;
	
	always@(posedge OSC_50 or negedge any_rstn)begin
		
		if(any_rstn == 0)begin
			any_rstn_r <= 0;
			any_rstn_rr <= 0;
		end else begin
			any_rstn_r <= 1;
			any_rstn_rr <= any_rstn_r;
		end
	end
	
	top top_inst(
		
		.clk_clk								(OSC_50),			// input  clk_clk_sig
		.reset_reset_n							(global_nrst),		// input  reset_reset_n_sig
		
		//===================================================
		//	Basic parallel IOs
		//===================================================
		.led_wire_export						(led_sig),			// output [3:0] led_wire_export_sig
		.dp_switch_export						({2{PUSH_BUT}}),	// input [3:0] dp_switch_export_sig
		
		//===================================================
		//	PCIe
		//===================================================
		.hip_ctrl_test_in						(pcie_hip_ctrl_test_in),			// input [31:0] hip_ctrl_test_in_sig
		
		.hip_ctrl_simu_mode_pipe				(1'b0),					// input  hip_ctrl_simu_mode_pipe_sig
		.hip_pipe_sim_pipe_pclk_in				(1'b0),					// input  hip_pipe_sim_pipe_pclk_in_sig
		
		.hip_serial_rx_in0						(PCIE_RX_p[0]),			// input  hip_serial_rx_in0_sig
		.hip_serial_rx_in1						(PCIE_RX_p[1]),			// input  hip_serial_rx_in1_sig
		.hip_serial_rx_in2						(PCIE_RX_p[2]),			// input  hip_serial_rx_in2_sig
		.hip_serial_rx_in3						(PCIE_RX_p[3]),			// input  hip_serial_rx_in3_sig
		
		.hip_serial_tx_out0						(PCIE_TX_p[0]),			// output  hip_serial_tx_out0_sig
		.hip_serial_tx_out1						(PCIE_TX_p[1]),			// output  hip_serial_tx_out1_sig
		.hip_serial_tx_out2						(PCIE_TX_p[2]),			// output  hip_serial_tx_out2_sig
		.hip_serial_tx_out3						(PCIE_TX_p[3]),			// output  hip_serial_tx_out3_sig
		
		.pcie_nrst_pin_perst					(PCIE_PERST_n),			// input  pcie_nrst_pin_perst_sig
		.pcie_nrst_npor							(any_rstn_rr),			// input  pcie_nrst_npor_sig
		.pcie_refclk_clk						(PCIE_REFCLK_p)			// input  refclk_clk_sig
	);
	
endmodule
