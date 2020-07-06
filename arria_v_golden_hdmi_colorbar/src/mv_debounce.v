
module mv_debounce#(
	parameter N = 32,
	parameter FREQ = 27,
	parameter MAX_TIME = 20
)
(
	
	input			clk,
	input			rst,
	input			button_in,
	output reg		button_posedge,
	output reg		button_negedge,
	output reg		button_out
);
	
	localparam TIMER_MAX_VAL = MAX_TIME * 1000 * FREQ;
	
	reg		[N-1 : 0]	q_reg;
	reg		[N-1 : 0]	q_next;
	reg					DFF1;
	reg					DFF2;
	
	wire				q_add;
	wire				q_reset;
	
	reg					button_out_d0;
	
	assign q_reset = (DFF1 ^ DFF2);
	assign q_add = ~(q_reg == TIMER_MAX_VAL);
	
	always@(q_reset, q_add, q_reg)begin
		case({q_reset , q_add})
			2'b00:		q_next <= q_reg;
			2'b01:		q_next <= q_reg + 1;
			default:	q_next <= { N {1'b0} };
		endcase
	end
	
	always@(posedge clk)begin
		if(rst)begin
			DFF1 <= 1'b0;
			DFF2 <= 1'b0;
			q_reg <= { N {1'b0} };
		end else begin
			DFF1 <= button_in;
			DFF2 <= DFF1;
			q_reg <= q_next;
		end
	end
	
	always@(posedge clk)begin
		if(q_reg == TIMER_MAX_VAL)begin
			button_out <= DFF2;
		end else begin
			button_out <= button_out;
		end
	end

	always@(posedge clk)begin
		button_out_d0 <= button_out;
		button_posedge <= ~button_out_d0 & button_out;
		button_negedge <= button_out_d0 & ~button_out;
	end
	
endmodule
