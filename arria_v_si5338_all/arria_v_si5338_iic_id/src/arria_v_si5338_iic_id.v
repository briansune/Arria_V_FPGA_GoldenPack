//=============================================================
//	
//	Author:			Brian Sune
//	Function:		SI5338 initialization core
//	
//=============================================================

module arria_v_si5338_iic_id(
	
	input			CLK,
	input 			RSTn,
	
	output			SCL,
	inout			SDA,
	
	output reg		osc_done
);
	
	reg		[1 : 0]		iic_wr_sig;
	reg		[7 : 0]		iic_addr_sig;
	wire	[7 : 0]		iic_wr_data;
	wire	[7 : 0]		iic_rd_data;
	wire				iic_wr_done;
	
	reg		[1 : 0]		fsm_stage;
	
	basic_iic #(
		.slave_addr	(7'b111_0000),
		.F250K		(9'd200)
	)basic_iic_inst(
		
		.CLK		(CLK),			// input  CLK_sig
		.RSTn		(RSTn),			// input  RSTn_sig
		
		.Start_Sig	(iic_wr_sig),		// input [1:0] Start_Sig_sig
		.Addr_Sig	(iic_addr_sig),		// input [7:0] Addr_Sig_sig
		.WrData		(iic_wr_data),		// input [7:0] WrData_sig
		.RdData		(iic_rd_data),		// output [7:0] RdData_sig
		.Done_Sig	(iic_wr_done),		// output  Done_Sig_sig
		
		.SCL		(SCL),			// output  SCL_sig
		.SDA		(SDA)			// inout  SDA_sig
	);
	
	assign iic_wr_data = 8'd0;
	
	always@(posedge CLK or negedge RSTn)begin
		
		if(!RSTn)begin
			
			iic_addr_sig <= 8'd0;
			iic_wr_sig <= 2'b00;
			fsm_stage <= 2'd0;
			
			osc_done <= 1'b0;
			
		end else begin
			
			case(fsm_stage)
				
				2'd0: begin
					iic_addr_sig <= 8'd0;
					iic_wr_sig <= 2'b00;
					fsm_stage <= 2'd1;
					osc_done <= 1'b0;
				end
				
				2'd1: begin
					iic_wr_sig <= 2'b10;
					fsm_stage <= 2'd2;
				end
				
				2'd2: begin
					
					if(iic_wr_done)begin
						iic_addr_sig <= iic_addr_sig + 8'd1;
						
						if(iic_addr_sig == 8'd10)begin
							fsm_stage <= 2'd3;
							iic_wr_sig <= 2'b00;
						end else begin
							fsm_stage <= 2'd1;
						end
					end
				end
				
				2'd3: begin
					osc_done <= 1'b1;
					fsm_stage <= 2'd3;
				end
				
			endcase
		end
	end
	
endmodule
