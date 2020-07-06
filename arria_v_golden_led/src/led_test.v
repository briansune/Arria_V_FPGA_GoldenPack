module led_test(
	
	input				sys_clk,
	input				sys_nrst,
	
	output	[7 : 0]		led
);
	
	reg		[31 : 0]	delay_cnt;
	reg		[7 : 0]		led_reg;
	reg					led_en;
	
	assign led = led_reg;
	
	always@(posedge sys_clk or negedge sys_nrst)begin
		if(!sys_nrst)begin
			delay_cnt <= 32'd0;
			led_en <= 1'b0;
		end else begin
			if(delay_cnt == 32'd49_999_999)begin
				led_en <= 1'b1;
				delay_cnt <= 32'd0;
			end else begin
				delay_cnt <= delay_cnt + 32'd1;
				led_en <= 1'b0;
			end
		end
	end
	
	always@(posedge sys_clk or negedge sys_nrst)begin
		if(!sys_nrst)begin
			led_reg <= 8'd1;
		end else begin
			if(led_en)begin
				led_reg <= {led_reg[0+:7], led_reg[7]};
			end
		end
	end
	
endmodule
