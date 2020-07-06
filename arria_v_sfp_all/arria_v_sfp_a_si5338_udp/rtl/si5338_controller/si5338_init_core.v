//=============================================================
//	
//	Author:			Brian Sune
//	Function:		SI5338 initialization core
//	
//=============================================================

module si5338_init_core(
	
	input			CLK,
	input 			RSTn,
	
	output			SCL,
	inout			SDA,
	
	output reg		osc_done
);
	
	localparam iic_nop_cmd = 2'b00;
	localparam iic_write_cmd = 2'b01;
	localparam iic_read_cmd = 2'b10;
	
	reg		[7 : 0]		brom_addr;
	wire	[23 : 0]	brom_data;
	
	reg		[4 : 0]		fsm_stage;
	reg		[7 : 0]		iic_data_read;
	reg		[1 : 0]		iic_wr_ctrl;
	
	reg		[7 : 0]		iic_addr_reg;
	reg		[7 : 0]		iic_wr_data_reg;
	
	wire	[7 : 0]		iic_rd_data;
	wire				iic_done;
	
	basic_iic #(
		.slave_addr	(7'b111_0000),
		.F250K		(9'd200)
	)basic_iic_inst(
		
		.CLK		(CLK),			// input  CLK_sig
		.RSTn		(RSTn),			// input  RSTn_sig
		
		.Start_Sig	(iic_wr_ctrl),			// input [1:0] Start_Sig_sig
		.Addr_Sig	(iic_addr_reg),			// input [7:0] Addr_Sig_sig
		.WrData		(iic_wr_data_reg),		// input [7:0] WrData_sig
		.RdData		(iic_rd_data),			// output [7:0] RdData_sig
		.Done_Sig	(iic_done),				// output  Done_Sig_sig
		
		.SCL		(SCL),			// output  SCL_sig
		.SDA		(SDA)			// inout  SDA_sig
	);
	
	si5338_init_rom si5338_init_rom_inst(
		
		.aclr		(~RSTn),		// input  aclr_sig
		.address	(brom_addr),	// input [7:0] address_sig
		.clock		(CLK),			// input  clock_sig
		.q			(brom_data)		// output [23:0] q_sig
	);
	
	reg [23 : 0] wait_cng;
	
	always@(posedge CLK or negedge RSTn)begin
		
		if(!RSTn)begin
			
			brom_addr <= 8'd0;
			
			iic_addr_reg <= 8'd0;
			iic_wr_data_reg <= 8'd0;
			iic_data_read <= 8'd0;
			
			iic_wr_ctrl <= iic_nop_cmd;
			fsm_stage <= 5'd0;
			
			osc_done <= 1'b0;
			
			wait_cng <= 24'd0;
			
		end else begin
			
			case(fsm_stage)
				
				5'd0: begin
					brom_addr <= 8'd0;
					iic_addr_reg <= 8'd0;
					iic_wr_data_reg <= 8'd0;
					iic_data_read <= 8'd0;
					iic_wr_ctrl <= iic_nop_cmd;
					fsm_stage <= 5'd1;
					osc_done <= 1'b0;
					wait_cng <= 24'd0;
				end
				
				5'd1: begin
					iic_wr_ctrl <= iic_write_cmd;
					iic_addr_reg <= 8'd230;
					iic_wr_data_reg <= 8'h10;
					fsm_stage <= 5'd2;
				end
				
				5'd2: begin
					
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						fsm_stage <= 5'd3;
						iic_wr_ctrl <= iic_write_cmd;
						iic_addr_reg <= 8'd241;
						iic_wr_data_reg <= 8'h80;
					end
				end
				
				5'd3: begin
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						fsm_stage <= 5'd4;
					end
				end
				
				////////////////////////////////////
				// clock builder
				////////////////////////////////////
				5'd4: begin
					iic_wr_ctrl <= iic_read_cmd;
					
					iic_addr_reg <= brom_data[16 +: 8];
					
					fsm_stage <= 5'd5;
				end
				
				5'd5: begin
					
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						iic_data_read <= iic_rd_data;
						fsm_stage <= 5'd6;
					end
				end
				
				5'd6: begin
					iic_wr_ctrl <= iic_write_cmd;
					
					iic_wr_data_reg <= (iic_data_read & (~brom_data[0 +: 8])) | (brom_data[8 +: 8] & brom_data[0 +: 8]);
					
					fsm_stage <= 5'd7;
					brom_addr <= brom_addr + 8'd1;
				end
				
				5'd7: begin
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						
						if(brom_addr == 8'hED)begin
							fsm_stage <= 5'd8;
						end else begin
							fsm_stage <= 5'd4;
						end
					end
				end
				
				5'd8: begin
					iic_wr_ctrl <= iic_nop_cmd;
					fsm_stage <= 5'd9;
				end
				
				////////////////////////////////////
				// read input clock OK
				////////////////////////////////////
				5'd9: begin
					iic_wr_ctrl <= iic_read_cmd;
					
					iic_addr_reg <= 8'd218;
					
					fsm_stage <= 5'd10;
				end
				
				5'd10: begin
					
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						if(!iic_rd_data[2])begin
							fsm_stage <= 5'd11;
						end else begin
							fsm_stage <= 5'd9;
						end
					end
				end
				
				////////////////////////////////////
				// configure PLL lock
				////////////////////////////////////
				5'd11: begin
					iic_wr_ctrl <= iic_write_cmd;
					iic_addr_reg <= 8'd49;
					iic_wr_data_reg <= 8'h00;
					fsm_stage <= 5'd12;
				end
				
				5'd12: begin
					
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						fsm_stage <= 5'd13;
						iic_wr_ctrl <= iic_write_cmd;
						iic_addr_reg <= 8'd246;
						iic_wr_data_reg <= 8'h02;
					end
				end
				
				5'd13: begin
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						fsm_stage <= 5'd14;
					end
				end
				
				////////////////////////////////////
				// wait 25ms
				////////////////////////////////////
				5'd14: begin
					wait_cng <= wait_cng + 24'd1;
					
					if(wait_cng == 24'd1249999)begin
						fsm_stage <= 5'd15;
					end
				end
				
				5'd15: begin
					iic_wr_ctrl <= iic_write_cmd;
					iic_addr_reg <= 8'd241;
					iic_wr_data_reg <= 8'h65;
					fsm_stage <= 5'd16;
				end
				
				5'd16: begin
					
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						fsm_stage <= 5'd17;
					end
				end
				
				////////////////////////////////////
				// read PLL lock OK
				////////////////////////////////////
				5'd17: begin
					iic_wr_ctrl <= iic_read_cmd;
					
					iic_addr_reg <= 8'd218;
					
					fsm_stage <= 5'd18;
				end
				
				5'd18: begin
					
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						if(!iic_rd_data[4] & !iic_rd_data[2] & !iic_rd_data[0])begin
							fsm_stage <= 5'd19;
						end else begin
							fsm_stage <= 5'd17;
						end
					end
				end
				
				////////////////////////////////////
				// copy data from reg to reg
				////////////////////////////////////
				5'd19: begin
					iic_wr_ctrl <= iic_read_cmd;
					iic_addr_reg <= 8'd237;
					
					fsm_stage <= 5'd20;
				end
				
				5'd20: begin
					
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						iic_data_read <= iic_rd_data;
						fsm_stage <= 5'd21;
					end
				end
				
				5'd21: begin
					iic_wr_ctrl <= iic_write_cmd;
					iic_addr_reg <= 8'd47;
					iic_wr_data_reg <= {6'b000101, iic_data_read[1 : 0]};
					
					fsm_stage <= 5'd22;
				end
				
				5'd22: begin
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						iic_wr_ctrl <= iic_read_cmd;
						iic_addr_reg <= 8'd236;
						fsm_stage <= 5'd23;
					end
				end
				
				5'd23: begin
					
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						iic_data_read <= iic_rd_data;
						fsm_stage <= 5'd24;
					end
				end
				
				5'd24: begin
					iic_wr_ctrl <= iic_write_cmd;
					iic_addr_reg <= 8'd46;
					iic_wr_data_reg <= iic_data_read;
					
					fsm_stage <= 5'd25;
				end
				
				5'd25: begin
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						iic_wr_ctrl <= iic_read_cmd;
						iic_addr_reg <= 8'd235;
						fsm_stage <= 5'd26;
					end
				end
				
				5'd26: begin
					
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						iic_data_read <= iic_rd_data;
						fsm_stage <= 5'd27;
					end
				end
				
				5'd27: begin
					iic_wr_ctrl <= iic_write_cmd;
					iic_addr_reg <= 8'd45;
					iic_wr_data_reg <= iic_data_read;
					
					fsm_stage <= 5'd28;
				end
				
				5'd28: begin
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						fsm_stage <= 5'd29;
						iic_wr_ctrl <= iic_write_cmd;
						iic_addr_reg <= 8'd49;
						iic_wr_data_reg <= 8'h80;
					end
				end
				
				////////////////////////////////////////
				// set pll fcal
				////////////////////////////////////////
				5'd29: begin
					
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						fsm_stage <= 5'd30;
						iic_wr_ctrl <= iic_write_cmd;
						iic_addr_reg <= 8'd230;
						iic_wr_data_reg <= 8'h00;
					end
				end
				
				5'd30: begin
					
					iic_wr_ctrl <= iic_nop_cmd;
					
					if(iic_done)begin
						osc_done <= 1'b1;
					end
				end
				
				default: begin
					brom_addr <= 8'd0;
					iic_addr_reg <= 8'd0;
					iic_wr_data_reg <= 8'd0;
					iic_data_read <= 8'd0;
					iic_wr_ctrl <= iic_nop_cmd;
					fsm_stage <= 5'd0;
					osc_done <= 1'b0;
					wait_cng <= 24'd0;
				end
				
			endcase
		end
	end
	
endmodule
