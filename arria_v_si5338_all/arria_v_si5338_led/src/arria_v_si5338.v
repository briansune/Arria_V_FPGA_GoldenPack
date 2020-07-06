


module arria_v_si5338(
	
	input				si5338_clk0,
	input				si5338_clk3,
	
	inout				si5338_sda,
	output				si5338_scl,
	
	input				sys_clk,
	input				sys_nrst,
	
	output	[7 : 0]		led
);
	
	localparam clk0_speed = 32'd156_250_000;
	localparam clk3_speed = 32'd250_000_000;
	
	reg		[31 : 0]	delay_cnt_a;
	reg		[31 : 0]	delay_cnt_b;
	
	reg		[7 : 0]		led_reg;
	
	reg					led0_en;
	reg					led1_en;
	
	wire				osc_done;
	
	assign led = ~{5'd0, led1_en, led0_en, osc_done};
	
	si5338_init_core si5338_init_core_inst(
		
		.CLK			(sys_clk),		// input  CLK_sig
		.RSTn			(sys_nrst),		// input  RSTn_sig
		.SCL			(si5338_scl),	// output  SCL_sig
		.SDA			(si5338_sda),	// inout  SDA_sig
		.osc_done		(osc_done) 		// output  osc_done_sig
	);
	
	always@(posedge si5338_clk0 or negedge osc_done)begin
		
		if(!osc_done)begin
			
			delay_cnt_a <= 32'd0;
			led0_en <= 1'b0;
			
		end else begin
			
			if(delay_cnt_a == (clk0_speed - 1))begin
				led0_en <= ~led0_en;
				delay_cnt_a <= 32'd0;
			end else begin
				delay_cnt_a <= delay_cnt_a + 32'd1;
			end
		end
	end
	
	always@(posedge si5338_clk3 or negedge osc_done)begin
		
		if(!osc_done)begin
			
			delay_cnt_b <= 32'd0;
			led1_en <= 1'b0;
			
		end else begin
			
			if(delay_cnt_b == (clk3_speed - 1))begin
				led1_en <= ~led1_en;
				delay_cnt_b <= 32'd0;
			end else begin
				delay_cnt_b <= delay_cnt_b + 32'd1;
			end
		end
	end
	
endmodule
