

module rgmii_a(
	
	input				reset_n,
	input				g_clk,
	
	output				e_reset,
	output				e_mdc,
	inout				e_mdio,
	
	//125Mhz Ethernet GMII Rx clock
	input				e_rxc,
	input				e_rxdv,	
	input				e_rxer,
	input	[7 : 0]		e_rxd,
	
	//125Mhz Ethernet GMII TX clock
	input				e_txc,
	output				e_gtxc,
	output				e_txen, 
	output				e_txer,
	output	[7 : 0]		e_txd
);
	
	wire	[31 : 0]	ram_wr_data;
	wire	[31 : 0]	ram_rd_data;
	wire	[8 : 0]		ram_wr_addr;
	wire	[8 : 0]		ram_rd_addr;
	
	wire	[31 : 0]	datain_reg;
	
	wire	[3 : 0]		tx_state;
	wire	[3 : 0]		rx_state;
	wire	[15 : 0]	rx_total_length;
	wire	[15 : 0]	tx_total_length;
	wire	[15 : 0]	rx_data_length;
	wire	[15 : 0]	tx_data_length;
	
	wire				data_receive;
	reg					ram_wr_finish;
	
	reg					ram_wren_i;
	reg		[8 : 0]		ram_addr_i;
	reg		[31 : 0]	ram_data_i;
	reg		[4 : 0]		i;
	
	wire				data_o_valid;
	wire				wea;
	wire	[8 : 0]		addra;
	wire	[31 : 0]	dina;
	
	reg		[31 : 0]	udp_data [4 : 0];
	
	assign e_gtxc = g_clk;
	
	assign e_reset = reset_n;
	assign e_mdc = 1'b1;
	assign e_mdio = 1'b1;
	
	assign wea = ram_wr_finish?data_o_valid : ram_wren_i;
	assign addra = ram_wr_finish?ram_wr_addr : ram_addr_i;
	assign dina = ram_wr_finish?ram_wr_data : ram_data_i;
	
	assign tx_data_length = data_receive?rx_data_length : 16'd28;
	assign tx_total_length = data_receive?rx_total_length : 16'd48;
	
	udp udp_inst(
		
		.reset_n			(reset_n),
		.g_clk				(g_clk),

		.e_rxc				(e_rxc),
		.e_rxd				(e_rxd),
		.e_rxdv				(e_rxdv),
		.e_txen				(e_txen),
		.e_txd				(e_txd),
		.e_txer				(e_txer),

		.data_o_valid		(data_o_valid),
		.ram_wr_data		(ram_wr_data),
		.rx_total_length	(rx_total_length),
		.rx_state			(rx_state),
		.rx_data_length		(rx_data_length),
		.ram_wr_addr		(ram_wr_addr),
		.data_receive		(data_receive),
		.ram_rd_data		(ram_rd_data),
		
		// debug use
		.tx_state			(tx_state),

		.tx_data_length		(tx_data_length),
		.tx_total_length	(tx_total_length),
		.ram_rd_addr		(ram_rd_addr)
	);
	
	ram ram_inst(
		
		.wrclock	(e_rxc),			// input  wrclock_sig
		.wren		(wea),				// input  wren_sig
		.wraddress	(addra),			// input [8:0] wraddress_sig
		.data		(dina),				// input [31:0] data_sig
		
		.rdclock	(e_rxc),			// input  rdclock_sig
		.rdaddress	(ram_rd_addr),		// input [8:0] rdaddress_sig
		.q			(ram_rd_data) 		// output [31:0] q_sig
	);

	
	always@(*)begin
		
		udp_data[0] <= {"A","r","r","i"};
		udp_data[1] <= {"a"," ","V"," "};
		udp_data[2] <= {"U","D","P"," "};
		udp_data[3] <= {"T","e","s","t"};
		udp_data[4] <= {" ","!","\r","\n"};
	end
	
	always@(posedge e_rxc)begin
		
		if(reset_n == 1'b0)begin
			ram_wr_finish <= 1'b0;
			ram_addr_i <= 0;
			ram_data_i <= 0;
			i <= 0;
		end else begin
			if(i == 5)begin
				ram_wr_finish <= 1'b1;
				ram_wren_i <= 1'b0;
			end else begin
				ram_wren_i <= 1'b1;
				ram_addr_i <= ram_addr_i+1'b1;
				ram_data_i <= udp_data[i];
				i <= i+1'b1;
			end
		end
	end
	
endmodule
