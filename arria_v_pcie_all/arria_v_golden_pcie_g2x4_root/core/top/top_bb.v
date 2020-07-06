
module top (
	clk_clk,
	reset_reset_n,
	refclk_clk,
	reconfclk_lock_fixedclk_locked,
	nrst_status_reset_n);	

	input		clk_clk;
	input		reset_reset_n;
	input		refclk_clk;
	output		reconfclk_lock_fixedclk_locked;
	output		nrst_status_reset_n;
endmodule
