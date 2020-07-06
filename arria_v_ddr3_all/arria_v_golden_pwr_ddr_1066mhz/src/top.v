//=======================================================
//	
//	Author:		Brian SUNE
//	
//	Purpose:	Altera Arria V Golden Top
//	
//	Language:	Verilog
//	
//	Tab Size:	4 spaces = 1 Tab
//	
//=======================================================



module top(
	
	//============== BUTTON ==============
	input					BUTTON,
	
	//============== CLOCK ==============
	input					OSC_50,
	
	//============== RZQ ==============
	input					DDR3_PWR_RZQ,
	
	input					DDR3_PWR_refclk,
	
	output		[13 : 0]	DDR3_PWR_SIDE_A,
	output		[2 : 0]		DDR3_PWR_SIDE_BA,
	output		[0 : 0]		DDR3_PWR_SIDE_CAS_n,
	output		[0 : 0]		DDR3_PWR_SIDE_CK,
	output		[0 : 0]		DDR3_PWR_SIDE_CK_n,
	
	output		[0 : 0]		DDR3_PWR_SIDE_CKE,
	
	output		[0 : 0]		DDR3_PWR_SIDE_CS_n,
	
	output		[7 : 0]		DDR3_PWR_SIDE_DM,
	inout		[63 : 0]	DDR3_PWR_SIDE_DQ,
	inout		[7 : 0]		DDR3_PWR_SIDE_DQS,
	inout		[7 : 0]		DDR3_PWR_SIDE_DQS_n,
	output		[0 : 0]		DDR3_PWR_SIDE_ODT,
	output		[0 : 0]		DDR3_PWR_SIDE_RAS_n,
	output					DDR3_PWR_SIDE_RESET_n,
	output		[0 : 0]		DDR3_PWR_SIDE_WE_n,
	
	//============== LED ==============
	output		[7 : 0]		LED
);
	
	reg		[31:0]		cont;
	reg		[4:0]		sample;
	
	wire				DDR3_PWR_afi_clk;
	
	wire	[7:0]		test_result;
	wire				test_software_reset_n;
	wire				test_global_reset_n;
	wire				test_start_n;
	
	//============== DDR3 SFP SIDE TEST ==============
	wire DDR3_PWR_SIDE_test_pass;
	wire DDR3_PWR_SIDE_test_fail;
	wire DDR3_PWR_SIDE_test_complete;
	wire DDR3_PWR_SIDE_local_init_done;
	wire DDR3_PWR_SIDE_local_cal_success;
	wire DDR3_PWR_SIDE_local_cal_fail;
	
	//============== DDR3 SFP SIDE TEST ==============
	wire				DDR3_PWR_SIDE_avl_ready;			// avl.waitrequest_n
	wire				DDR3_PWR_SIDE_avl_burstbegin;		//    .beginbursttransfer
	wire	[23:0]		DDR3_PWR_SIDE_avl_addr;				//    .address
	wire				DDR3_PWR_SIDE_avl_rdata_valid;		//    .readdatavalid
	wire	[511:0]		DDR3_PWR_SIDE_avl_rdata;			//    .readdata
	wire	[511:0]		DDR3_PWR_SIDE_avl_wdata;			//    .writedata
	wire				DDR3_PWR_SIDE_avl_read_req;			//    .read
	wire				DDR3_PWR_SIDE_avl_write_req;		//    .write
	wire	[2:0]		DDR3_PWR_SIDE_avl_size;				//    .burstcount
	
	wire				pll_lock;
	
	assign DDR3_PWR_SIDE_avl_size = 3'b001;
	
	always@(posedge OSC_50)begin
		cont<=(cont==32'd4_000_001)?32'd0:cont+1'b1;
	end
	
	always@(posedge OSC_50)begin
		if(cont==32'd4_000_000)
			sample[4:0]={sample[3:0],BUTTON};
		else 
			sample[4:0]=sample[4:0];
	end
	
	// LED indicators
	assign LED[7:0] = BUTTON ? ~test_result : 8'b0000_0000;
	
	assign test_result[0] = ~BUTTON;
	assign test_result[1] = pll_lock;
	assign test_result[2] = DDR3_PWR_SIDE_local_init_done;
	assign test_result[3] = DDR3_PWR_SIDE_local_cal_success;
	assign test_result[4] = DDR3_PWR_SIDE_local_cal_fail;
	assign test_result[5] = DDR3_PWR_SIDE_test_complete;
	assign test_result[6] = DDR3_PWR_SIDE_test_pass;
	assign test_result[7] = DDR3_PWR_SIDE_test_fail;
	
	assign test_software_reset_n = (sample[1:0]==2'b10) ? 1'b0:1'b1;
	assign test_global_reset_n   = (sample[3:2]==2'b10) ? 1'b0:1'b1;
	assign test_start_n          = (sample[4:3]==2'b01) ? 1'b0:1'b1;
	
	ddr3_pwr_side ddr3_pwr_side_inst(
		
		.pll_ref_clk					(DDR3_PWR_refclk),			// input  pll_ref_clk_sig
		.global_reset_n					(test_global_reset_n),		// input  global_reset_n_sig
		.soft_reset_n					(test_software_reset_n),	// input  soft_reset_n_sig
		
		.afi_clk						(DDR3_PWR_afi_clk),		// output  afi_clk_sig
		.afi_half_clk					(),		// output  afi_half_clk_sig
		.afi_reset_n					(),		// output  afi_reset_n_sig
		.afi_reset_export_n				(),		// output  afi_reset_export_n_sig
		
		.oct_rzqin						(DDR3_PWR_RZQ),				// input  oct_rzqin_sig
		
		.mem_a							(DDR3_PWR_SIDE_A),			// output [13:0] mem_a_sig
		.mem_ba							(DDR3_PWR_SIDE_BA),			// output [2:0] mem_ba_sig
		.mem_ck							(DDR3_PWR_SIDE_CK),			// output [0:0] mem_ck_sig
		.mem_ck_n						(DDR3_PWR_SIDE_CK_n),		// output [0:0] mem_ck_n_sig
		.mem_cke						(DDR3_PWR_SIDE_CKE),		// output [0:0] mem_cke_sig
		.mem_cs_n						(DDR3_PWR_SIDE_CS_n),		// output [0:0] mem_cs_n_sig
		.mem_dm							(DDR3_PWR_SIDE_DM),			// output [7:0] mem_dm_sig
		.mem_ras_n						(DDR3_PWR_SIDE_RAS_n),		// output [0:0] mem_ras_n_sig
		.mem_cas_n						(DDR3_PWR_SIDE_CAS_n),		// output [0:0] mem_cas_n_sig
		.mem_we_n						(DDR3_PWR_SIDE_WE_n),		// output [0:0] mem_we_n_sig
		.mem_reset_n					(DDR3_PWR_SIDE_RESET_n),	// output  mem_reset_n_sig
		.mem_dq							(DDR3_PWR_SIDE_DQ),			// inout [63:0] mem_dq_sig
		.mem_dqs						(DDR3_PWR_SIDE_DQS),		// inout [7:0] mem_dqs_sig
		.mem_dqs_n						(DDR3_PWR_SIDE_DQS_n),		// inout [7:0] mem_dqs_n_sig
		.mem_odt						(DDR3_PWR_SIDE_ODT),		// output [0:0] mem_odt_sig
		
		.avl_ready						(DDR3_PWR_SIDE_avl_ready),			// output  avl_ready_sig
		.avl_burstbegin					(DDR3_PWR_SIDE_avl_burstbegin),		// input  avl_burstbegin_sig
		.avl_addr						(DDR3_PWR_SIDE_avl_addr),			// input [23:0] avl_addr_sig
		.avl_rdata_valid				(DDR3_PWR_SIDE_avl_rdata_valid),	// output  avl_rdata_valid_sig
		.avl_rdata						(DDR3_PWR_SIDE_avl_rdata),			// output [511:0] avl_rdata_sig
		.avl_wdata						(DDR3_PWR_SIDE_avl_wdata),			// input [511:0] avl_wdata_sig
		.avl_be							(64'hFFFF_FFFF_FFFF_FFFF),			// input [63:0] avl_be_sig
		.avl_read_req					(DDR3_PWR_SIDE_avl_read_req),		// input  avl_read_req_sig
		.avl_write_req					(DDR3_PWR_SIDE_avl_write_req),		// input  avl_write_req_sig
		.avl_size						(DDR3_PWR_SIDE_avl_size),			// input [2:0] avl_size_sig
		
		.local_init_done				(DDR3_PWR_SIDE_local_init_done),	// output  local_init_done_sig
		.local_cal_success				(DDR3_PWR_SIDE_local_cal_success),	// output  local_cal_success_sig
		.local_cal_fail					(DDR3_PWR_SIDE_local_cal_fail),		// output  local_cal_fail_sig
		
		.pll_locked						(pll_lock),		// output  pll_locked_sig
		
		.pll_mem_clk					(),		// output  pll_mem_clk_sig
		.pll_write_clk					(),		// output  pll_write_clk_sig
		.pll_write_clk_pre_phy_clk		(),		// output  pll_write_clk_pre_phy_clk_sig
		.pll_addr_cmd_clk				(),		// output  pll_addr_cmd_clk_sig
		.pll_avl_clk					(),		// output  pll_avl_clk_sig
		.pll_config_clk					(),		// output  pll_config_clk_sig
		.pll_hr_clk						(),		// output  pll_hr_clk_sig
		.pll_mem_phy_clk				(),		// output  pll_mem_phy_clk_sig
		.afi_phy_clk					(),		// output  afi_phy_clk_sig
		.pll_avl_phy_clk				()		// output  pll_avl_phy_clk_sig
	);
	
	Avalon_bus_RW_Test #(
		.ADDR_W(24),
		.DATA_W(513)
	)DDR3_PWR_SIDE_Verify(
		
		.iCLK						(DDR3_PWR_afi_clk),
		.iRST_n						(test_software_reset_n),
		.iBUTTON					(test_start_n),
		
		.local_init_done			(DDR3_PWR_SIDE_local_init_done),
		.avl_waitrequest_n			(DDR3_PWR_SIDE_avl_ready),
		.avl_address				(DDR3_PWR_SIDE_avl_addr),
		.avl_readdatavalid			(DDR3_PWR_SIDE_avl_rdata_valid),
		.avl_readdata				(DDR3_PWR_SIDE_avl_rdata),
		.avl_writedata				(DDR3_PWR_SIDE_avl_wdata),
		.avl_read					(DDR3_PWR_SIDE_avl_read_req),
		.avl_write					(DDR3_PWR_SIDE_avl_write_req),
		.avl_burstbegin				(DDR3_PWR_SIDE_avl_burstbegin),
		
		.drv_status_pass			(DDR3_PWR_SIDE_test_pass),
		.drv_status_fail			(DDR3_PWR_SIDE_test_fail),
		.drv_status_test_complete	(DDR3_PWR_SIDE_test_complete)
	);
	
endmodule
