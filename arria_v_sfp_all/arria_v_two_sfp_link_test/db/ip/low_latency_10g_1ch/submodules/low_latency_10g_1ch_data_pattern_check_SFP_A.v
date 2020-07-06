// low_latency_10g_1ch_data_pattern_check_SFP_A.v

// This file was auto-generated from altera_avalon_data_pattern_checker_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 17.1 590

`timescale 1 ps / 1 ps
module low_latency_10g_1ch_data_pattern_check_SFP_A #(
		parameter ST_DATA_W            = 40,
		parameter NUM_CYCLES_FOR_LOCK  = 40,
		parameter BYPASS_ENABLED       = 0,
		parameter AVALON_ENABLED       = 1,
		parameter FREQ_CNTER_ENABLED   = 0,
		parameter CROSS_CLK_SYNC_DEPTH = 2
	) (
		input  wire        csr_clk_clk,          //        csr_clk.clk
		input  wire        reset_reset,          //          reset.reset
		input  wire [2:0]  csr_slave_address,    //      csr_slave.address
		input  wire        csr_slave_write,      //               .write
		input  wire        csr_slave_read,       //               .read
		input  wire [3:0]  csr_slave_byteenable, //               .byteenable
		input  wire [31:0] csr_slave_writedata,  //               .writedata
		output wire [31:0] csr_slave_readdata,   //               .readdata
		input  wire        pattern_in_clk_clk,   // pattern_in_clk.clk
		input  wire        asi_valid,            //     pattern_in.valid
		output wire        asi_ready,            //               .ready
		input  wire [39:0] asi_data              //               .data
	);

	generate
		// If any of the display statements (or deliberately broken
		// instantiations) within this generate block triggers then this module
		// has been instantiated this module with a set of parameters different
		// from those it was generated for.  This will usually result in a
		// non-functioning system.
		if (ST_DATA_W != 40)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					st_data_w_check ( .error(1'b1) );
		end
		if (NUM_CYCLES_FOR_LOCK != 40)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					num_cycles_for_lock_check ( .error(1'b1) );
		end
		if (BYPASS_ENABLED != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					bypass_enabled_check ( .error(1'b1) );
		end
		if (AVALON_ENABLED != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					avalon_enabled_check ( .error(1'b1) );
		end
		if (FREQ_CNTER_ENABLED != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					freq_cnter_enabled_check ( .error(1'b1) );
		end
		if (CROSS_CLK_SYNC_DEPTH != 2)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					cross_clk_sync_depth_check ( .error(1'b1) );
		end
	endgenerate

	altera_avalon_data_pattern_checker #(
		.ST_DATA_W           (40),
		.NUM_CYCLES_FOR_LOCK (40),
		.BYPASS_ENABLED      (0),
		.AVALON_ENABLED      (1),
		.FREQ_CNTER_ENABLED  (0)
	) data_pattern_checker (
		.avs_clk        (csr_clk_clk),          //        csr_clk.clk
		.reset          (reset_reset),          //  csr_clk_reset.reset
		.avs_address    (csr_slave_address),    //      csr_slave.address
		.avs_write      (csr_slave_write),      //               .write
		.avs_read       (csr_slave_read),       //               .read
		.avs_byteenable (csr_slave_byteenable), //               .byteenable
		.avs_writedata  (csr_slave_writedata),  //               .writedata
		.avs_readdata   (csr_slave_readdata),   //               .readdata
		.asi_clk        (pattern_in_clk_clk),   // pattern_in_clk.clk
		.asi_valid      (asi_valid),            //     pattern_in.valid
		.asi_ready      (asi_ready),            //               .ready
		.asi_data       (asi_data)              //               .data
	);

endmodule