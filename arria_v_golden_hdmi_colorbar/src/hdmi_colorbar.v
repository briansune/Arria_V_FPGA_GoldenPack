
module hdmi_colorbar(
	
	input				sys_clk,
	input	[1 : 0]		key,
	
	output	[1 : 0]		led,

	inout				hdmi_scl,
	inout				hdmi_sda,
	output				hdmi_nreset,

	output				vout_clk,
	output				vout_hs,
	output				vout_vs,
	output				vout_de,
	output	[23 : 0]	vout_data
);
	
	localparam H_ACTIVE	= 16'd1920;
	localparam H_FP		= 16'd88;
	localparam H_SYNC	= 16'd44;
	localparam H_BP		= 16'd148; 
	localparam V_ACTIVE	= 16'd1080;
	localparam V_FP		= 16'd4;
	localparam V_SYNC	= 16'd5;
	localparam V_BP		= 16'd36;
	
	localparam H_TOTAL	= H_ACTIVE + H_FP + H_SYNC + H_BP;
	localparam V_TOTAL	= V_ACTIVE + V_FP + V_SYNC + V_BP;
	
	wire				video_clk;
	wire				pattern_hs;
	wire				pattern_vs;
	wire				pattern_de;
	
	wire	[7 : 0]		pattern_rgb_r;
	wire	[7 : 0]		pattern_rgb_g;
	wire	[7 : 0]		pattern_rgb_b;
	
	reg		[3 : 0]		mode;
	
	wire	button0_negedge;
	wire	clk_27m;
	wire	rst_n;
	wire	locked;
	
	assign vout_clk = video_clk;
	assign vout_hs = pattern_hs;
	assign vout_vs = pattern_vs;
	assign vout_de = pattern_de;
	
	assign vout_data = {pattern_rgb_r,pattern_rgb_g,pattern_rgb_b};
	assign rst_n = locked;
	assign hdmi_nreset = locked;
	
	
	pll pll_inst0(
		.refclk		(sys_clk),
		.rst		(1'b0),
		.outclk_0	(video_clk),
		.outclk_1	(clk_27m),
		.locked		(locked)
	);
	
	i2c_config i2c_config_inst0(
		
		.rst(!rst_n),
		.clk(clk_27m),
		.error(led[1]),
		.done(led[0]),
		.i2c_scl(hdmi_scl),
		.i2c_sda(hdmi_sda)
	);
	
	mv_debounce #(
		.FREQ(50)
	)mv_debounce_inst0(
		
		.clk(clk_27m), 
		.rst(1'b0), 
		.button_in(key[0]),
		.button_posedge(),
		.button_negedge(button0_negedge),
		.button_out()
	);
	
	always@(posedge clk_27m)begin
		if(button0_negedge)begin
			mode <= (mode >= 4'd6) ? 4'd0 : mode + 4'd1;
		end
	end
	
	mv_pattern mv_pattern_inst0(
		
		.clk				(video_clk),
		.rst				(1'b0),
		.mode				(mode),
		.positive_hsync		(1'b1),
		.positive_vsync		(1'b1),
		.htotal_size		(H_TOTAL - 16'd1),
		.hactive_start		(H_BP - 1),
		.hactive_end		(H_BP + H_ACTIVE - 16'd1),
		.hsync_start		(H_BP + H_ACTIVE + H_FP - 16'd1),
		.hsync_end			(H_BP + H_ACTIVE + H_FP + H_SYNC  - 16'd1),
		.vtotal_size		(V_TOTAL - 16'd1),
		.vactive_start		(V_BP - 16'd1),
		.vactive_end		(V_BP + V_ACTIVE - 16'd1),
		.vsync_start		(V_BP + V_ACTIVE + V_FP - 16'd1),
		.vsync_end			(V_BP + V_ACTIVE + V_FP + V_SYNC  - 16'd1),
		.hs					(pattern_hs), 
		.vs					(pattern_vs), 
		.de					(pattern_de), 
		.rgb_r				(pattern_rgb_r), 
		.rgb_g				(pattern_rgb_g), 
		.rgb_b				(pattern_rgb_b)
	);
	
endmodule
