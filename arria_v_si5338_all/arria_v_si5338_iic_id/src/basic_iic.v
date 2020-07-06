//=============================================================
//	
//	Author:			Brian Sune
//	Function:		Basic IIC write read
//	How to use:		Start_Sig [ READ | WRITE ]
//								Active high
//					Done signal only generate a pulse
//	
//=============================================================

module basic_iic #(
	parameter slave_addr = 7'b111_0000,
	//250Khz
	parameter F250K = 9'd200
)(
	
	input			CLK,
	input 			RSTn,
	
	input	[1:0]	Start_Sig,	// read or write command
	input	[7:0]	Addr_Sig,	// words address
	input	[7:0]	WrData,		// write data
	output	[7:0]	RdData,		// read data
	output			Done_Sig,	// read/write finish
	
	output			SCL,
	inout			SDA
);
	
	reg		[4:0]	i;
	reg		[4:0]	Go;
	reg		[8:0]	C1;
	reg		[7:0]	rData;
	reg				rSCL;
	reg				rSDA;
	reg				isAck;
	reg				isDone;
	reg				isOut;	
	
	assign Done_Sig = isDone;
	assign RdData = rData;
	assign SCL = rSCL;
	
	//SDA data bidirectional
	assign SDA = isOut ? rSDA : 1'bz;
	
	always@(posedge CLK or negedge RSTn)begin
		
		if(!RSTn)begin
			
			i <= 5'd0;
			Go <= 5'd0;
			C1 <= 9'd0;
			rData <= 8'd0;
			rSCL <= 1'b1;
			rSDA <= 1'b1;
			isAck <= 1'b1;
			isDone <= 1'b0;
			isOut <= 1'b1;
			
		end else begin
			
			//I2C data write 
			if(Start_Sig[0])begin
				case(i)
					//send IIC start signal
					0: begin
						//SDA port output 
						isOut <= 1;
						
						if(C1 == 0)
							rSCL <= 1'b1;
						//SCL high to low 
						else if(C1 == 200)
							rSCL <= 1'b0;
						
						if(C1 == 0)
							rSDA <= 1'b1;
						//SDA first high to low 
						else if(C1 == 100)
							rSDA <= 1'b0;
						
						if(C1 == 250 -1)begin
							C1 <= 9'd0;
							i <= i + 1'b1;
						end else begin
							C1 <= C1 + 1'b1;
						end
					end
					
					// Write Device Addr
					1: begin
						rData <= {slave_addr, 1'b0};
						i <= 5'd7;
						Go <= i + 1'b1;
					end
					
					// Wirte Word Addr
					2: begin
						rData <= Addr_Sig;
						i <= 5'd7;
						Go <= i + 1'b1;
					end
					
					// Write Data
					3: begin
						rData <= WrData;
						i <= 5'd7;
						Go <= i + 1'b1;
					end
					
					//send IIC stop signal 
					4: begin
						isOut <= 1'b1;
						
						if(C1 == 0)
							rSCL <= 1'b0;
						//SCL first change from low to high 
						else if(C1 == 50)
							rSCL <= 1'b1;
						
						if(C1 == 0)
							rSDA <= 1'b0;
						//SDA low to high 
						else if(C1 == 150)
							rSDA <= 1'b1;
						
						if(C1 == 250 -1)begin
							C1 <= 9'd0;
							i <= i + 1'b1;
						end else
							C1 <= C1 + 1'b1;
					end
					
					// write I2C end 
					5: begin
						isDone <= 1'b1;
						i <= i + 1'b1;
					end
					
					6: begin
						isDone <= 1'b0;
						i <= 5'd0;
					end
					
					//send Device Addr/Word Addr/Write Data
					7,8,9,10,11,12,13,14: begin
						isOut <= 1'b1;
						rSDA <= rData[14-i];//high first send 
						
						if(C1 == 0)
							rSCL <= 1'b0;
						//SCL high for 100 clks, then low for 100 clks
						else if(C1 == 50)
							rSCL <= 1'b1;
						else if(C1 == 150)
							rSCL <= 1'b0;
						
						//250Khz SDC
						if(C1 == F250K -1)begin
							C1 <= 9'd0;
							i <= i + 1'b1;
						end else begin
							C1 <= C1 + 1'b1;
						end
					end
					
					// waiting for acknowledge
					15: begin
						//SDA port change to input 
						isOut <= 1'b0;
						// read IIC 从设备的应答信号
						if(C1 == 100)begin
							isAck <= SDA;
						end
						
						if(C1 == 0)
							rSCL <= 1'b0;
						//SCL high for 100 clks, then low for 100 clks
						else if(C1 == 50)
							rSCL <= 1'b1;
						else if(C1 == 150)
							rSCL <= 1'b0;
						
						//250Khz SDC
						if(C1 == F250K -1)begin
							C1 <= 9'd0;
							i <= i + 1'b1;
						end else begin
							C1 <= C1 + 1'b1;
						end
					end
					
					16: begin
						if(isAck != 0)
							i <= 5'd0;
						else
							i <= Go;
					end
					
				endcase
			
			//I2C data read 
			end else if(Start_Sig[1])begin
				
				case(i)
					
					// Start
					0: begin
						//SDA port output 
						isOut <= 1;
						
						if(C1 == 0)
							rSCL <= 1'b1;
						//SCL high to low 
						else if(C1 == 200)
							rSCL <= 1'b0;
						
						if(C1 == 0)
							rSDA <= 1'b1;
						//SDA first high to low 
						else if(C1 == 100)
							rSDA <= 1'b0;
						
						if(C1 == 250 -1)begin
							C1 <= 9'd0;i <= i + 1'b1;
						end else begin
							C1 <= C1 + 1'b1;
						end
					end
					
					// Write Device Addr
					1: begin
						rData <= {slave_addr, 1'b0};
						i <= 5'd9;
						Go <= i + 1'b1;
					end
					
					// Wirte Word Addr(write addr)
					2: begin
						rData <= Addr_Sig;
						i <= 5'd9;
						Go <= i + 1'b1;
					end
					
					// Start again
					3: begin
						isOut <= 1'b1;
						
						if(C1 == 0)
							rSCL <= 1'b0;
						else if(C1 == 50)
							rSCL <= 1'b1;
						else if(C1 == 250)
							rSCL <= 1'b0;
						
						if(C1 == 0)
							rSDA <= 1'b0;
						else if(C1 == 50)
							rSDA <= 1'b1;
						else if(C1 == 150)
							rSDA <= 1'b0;
						
						if(C1 == 300 -1)begin
							C1 <= 9'd0;
							i <= i + 1'b1;
						end else
							C1 <= C1 + 1'b1;
					end
					
					// Write Device Addr(Read)
					4: begin
						rData <= {slave_addr, 1'b1};
						i <= 5'd9;
						Go <= i + 1'b1;
					end
					
					// Read Data
					5: begin
						rData <= 8'd0;
						i <= 5'd19;
						Go <= i + 1'b1;
					end
					
					//send IIC stop signal 
					6: begin
						isOut <= 1'b1;
						if(C1 == 0)
							rSCL <= 1'b0;
						else if(C1 == 50)
							rSCL <= 1'b1;
						
						if(C1 == 0)
							rSDA <= 1'b0;
						else if(C1 == 150)
							rSDA <= 1'b1;
						
						if(C1 == 250 -1)begin
							C1 <= 9'd0;
							i <= i + 1'b1;
						end else
							C1 <= C1 + 1'b1;
					end
					
					// write I2C end 
					7: begin
						isDone <= 1'b1;
						i <= i + 1'b1;
					end
					
					8: 
					begin isDone <= 1'b0;i <= 5'd0;end
					
					//send Device Addr(write)/Word Addr/Device Addr(read)
					9,10,11,12,13,14,15,16: begin
						isOut <= 1'b1;
						//high first send 
						rSDA <= rData[16-i];
						
						if(C1 == 0)
							rSCL <= 1'b0;
						//SCL high for 100 clks, then low for 100 clks
						else if(C1 == 50)
							rSCL <= 1'b1;
						else if(C1 == 150)
							rSCL <= 1'b0;
						
						//250Khz SDC
						if(C1 == F250K -1)begin
							C1 <= 9'd0;
							i <= i + 1'b1;
						end else
							C1 <= C1 + 1'b1;
					end
					
					// waiting for acknowledge
					17: begin
						isOut <= 1'b0;//SDA port change to input 
						
						// read IIC receive signal
						if(C1 == 100)
							isAck <= SDA;
						
						if(C1 == 0)
							rSCL <= 1'b0;
						//SCL high for 100 clks, then low for 100 clks
						else if(C1 == 50)
							rSCL <= 1'b1;
						else if(C1 == 150)
							rSCL <= 1'b0;
						
						//250Khz SDC
						if(C1 == F250K -1)begin
							C1 <= 9'd0;i <= i + 1'b1;
						end else
							C1 <= C1 + 1'b1;
					end
					
					18: begin
						if(isAck != 0)
							i <= 5'd0;
						else
							i <= Go;
					end
					
					// Read data
					19,20,21,22,23,24,25,26: begin
						
						isOut <= 1'b0;
						
						//high first receive 
						if(C1 == 100)
							rData[26-i] <= SDA;
						
						if(C1 == 0)
							rSCL <= 1'b0;
						//SCL high for 100 clks, then low for 100 clks
						else if(C1 == 50)
							rSCL <= 1'b1;
						else if(C1 == 150)
							rSCL <= 1'b0;
						
						//250Khz SDC
						if(C1 == F250K -1)begin
							C1 <= 9'd0;i <= i + 1'b1;
						end else begin
							C1 <= C1 + 1'b1;
						end
					end
					
					// no acknowledge
					27: begin
						
						isOut <= 1'b1;
						
						if(C1 == 0)
							rSCL <= 1'b0;
						//SCL high for 100 clks, then low for 100 clks
						else if(C1 == 50)
							rSCL <= 1'b1;
						else if(C1 == 150)
							rSCL <= 1'b0;
						
						//250Khz SDC
						if(C1 == F250K -1)begin
							C1 <= 9'd0;
							i <= Go;
						end else begin
							C1 <= C1 + 1'b1;
						end
					end
					
				endcase
			end
		end
	end
	
endmodule
