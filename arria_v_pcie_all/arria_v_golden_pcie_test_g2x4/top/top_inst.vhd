	component top is
		port (
			clk_clk                       : in  std_logic                     := 'X';             -- clk
			dut_hip_ctrl_test_in          : in  std_logic_vector(31 downto 0) := (others => 'X'); -- test_in
			dut_hip_ctrl_simu_mode_pipe   : in  std_logic                     := 'X';             -- simu_mode_pipe
			dut_hip_pipe_sim_pipe_pclk_in : in  std_logic                     := 'X';             -- sim_pipe_pclk_in
			dut_hip_pipe_sim_pipe_rate    : out std_logic_vector(1 downto 0);                     -- sim_pipe_rate
			dut_hip_pipe_sim_ltssmstate   : out std_logic_vector(4 downto 0);                     -- sim_ltssmstate
			dut_hip_pipe_eidleinfersel0   : out std_logic_vector(2 downto 0);                     -- eidleinfersel0
			dut_hip_pipe_eidleinfersel1   : out std_logic_vector(2 downto 0);                     -- eidleinfersel1
			dut_hip_pipe_eidleinfersel2   : out std_logic_vector(2 downto 0);                     -- eidleinfersel2
			dut_hip_pipe_eidleinfersel3   : out std_logic_vector(2 downto 0);                     -- eidleinfersel3
			dut_hip_pipe_powerdown0       : out std_logic_vector(1 downto 0);                     -- powerdown0
			dut_hip_pipe_powerdown1       : out std_logic_vector(1 downto 0);                     -- powerdown1
			dut_hip_pipe_powerdown2       : out std_logic_vector(1 downto 0);                     -- powerdown2
			dut_hip_pipe_powerdown3       : out std_logic_vector(1 downto 0);                     -- powerdown3
			dut_hip_pipe_rxpolarity0      : out std_logic;                                        -- rxpolarity0
			dut_hip_pipe_rxpolarity1      : out std_logic;                                        -- rxpolarity1
			dut_hip_pipe_rxpolarity2      : out std_logic;                                        -- rxpolarity2
			dut_hip_pipe_rxpolarity3      : out std_logic;                                        -- rxpolarity3
			dut_hip_pipe_txcompl0         : out std_logic;                                        -- txcompl0
			dut_hip_pipe_txcompl1         : out std_logic;                                        -- txcompl1
			dut_hip_pipe_txcompl2         : out std_logic;                                        -- txcompl2
			dut_hip_pipe_txcompl3         : out std_logic;                                        -- txcompl3
			dut_hip_pipe_txdata0          : out std_logic_vector(7 downto 0);                     -- txdata0
			dut_hip_pipe_txdata1          : out std_logic_vector(7 downto 0);                     -- txdata1
			dut_hip_pipe_txdata2          : out std_logic_vector(7 downto 0);                     -- txdata2
			dut_hip_pipe_txdata3          : out std_logic_vector(7 downto 0);                     -- txdata3
			dut_hip_pipe_txdatak0         : out std_logic;                                        -- txdatak0
			dut_hip_pipe_txdatak1         : out std_logic;                                        -- txdatak1
			dut_hip_pipe_txdatak2         : out std_logic;                                        -- txdatak2
			dut_hip_pipe_txdatak3         : out std_logic;                                        -- txdatak3
			dut_hip_pipe_txdetectrx0      : out std_logic;                                        -- txdetectrx0
			dut_hip_pipe_txdetectrx1      : out std_logic;                                        -- txdetectrx1
			dut_hip_pipe_txdetectrx2      : out std_logic;                                        -- txdetectrx2
			dut_hip_pipe_txdetectrx3      : out std_logic;                                        -- txdetectrx3
			dut_hip_pipe_txelecidle0      : out std_logic;                                        -- txelecidle0
			dut_hip_pipe_txelecidle1      : out std_logic;                                        -- txelecidle1
			dut_hip_pipe_txelecidle2      : out std_logic;                                        -- txelecidle2
			dut_hip_pipe_txelecidle3      : out std_logic;                                        -- txelecidle3
			dut_hip_pipe_txswing0         : out std_logic;                                        -- txswing0
			dut_hip_pipe_txswing1         : out std_logic;                                        -- txswing1
			dut_hip_pipe_txswing2         : out std_logic;                                        -- txswing2
			dut_hip_pipe_txswing3         : out std_logic;                                        -- txswing3
			dut_hip_pipe_txmargin0        : out std_logic_vector(2 downto 0);                     -- txmargin0
			dut_hip_pipe_txmargin1        : out std_logic_vector(2 downto 0);                     -- txmargin1
			dut_hip_pipe_txmargin2        : out std_logic_vector(2 downto 0);                     -- txmargin2
			dut_hip_pipe_txmargin3        : out std_logic_vector(2 downto 0);                     -- txmargin3
			dut_hip_pipe_txdeemph0        : out std_logic;                                        -- txdeemph0
			dut_hip_pipe_txdeemph1        : out std_logic;                                        -- txdeemph1
			dut_hip_pipe_txdeemph2        : out std_logic;                                        -- txdeemph2
			dut_hip_pipe_txdeemph3        : out std_logic;                                        -- txdeemph3
			dut_hip_pipe_phystatus0       : in  std_logic                     := 'X';             -- phystatus0
			dut_hip_pipe_phystatus1       : in  std_logic                     := 'X';             -- phystatus1
			dut_hip_pipe_phystatus2       : in  std_logic                     := 'X';             -- phystatus2
			dut_hip_pipe_phystatus3       : in  std_logic                     := 'X';             -- phystatus3
			dut_hip_pipe_rxdata0          : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- rxdata0
			dut_hip_pipe_rxdata1          : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- rxdata1
			dut_hip_pipe_rxdata2          : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- rxdata2
			dut_hip_pipe_rxdata3          : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- rxdata3
			dut_hip_pipe_rxdatak0         : in  std_logic                     := 'X';             -- rxdatak0
			dut_hip_pipe_rxdatak1         : in  std_logic                     := 'X';             -- rxdatak1
			dut_hip_pipe_rxdatak2         : in  std_logic                     := 'X';             -- rxdatak2
			dut_hip_pipe_rxdatak3         : in  std_logic                     := 'X';             -- rxdatak3
			dut_hip_pipe_rxelecidle0      : in  std_logic                     := 'X';             -- rxelecidle0
			dut_hip_pipe_rxelecidle1      : in  std_logic                     := 'X';             -- rxelecidle1
			dut_hip_pipe_rxelecidle2      : in  std_logic                     := 'X';             -- rxelecidle2
			dut_hip_pipe_rxelecidle3      : in  std_logic                     := 'X';             -- rxelecidle3
			dut_hip_pipe_rxstatus0        : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- rxstatus0
			dut_hip_pipe_rxstatus1        : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- rxstatus1
			dut_hip_pipe_rxstatus2        : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- rxstatus2
			dut_hip_pipe_rxstatus3        : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- rxstatus3
			dut_hip_pipe_rxvalid0         : in  std_logic                     := 'X';             -- rxvalid0
			dut_hip_pipe_rxvalid1         : in  std_logic                     := 'X';             -- rxvalid1
			dut_hip_pipe_rxvalid2         : in  std_logic                     := 'X';             -- rxvalid2
			dut_hip_pipe_rxvalid3         : in  std_logic                     := 'X';             -- rxvalid3
			dut_hip_serial_rx_in0         : in  std_logic                     := 'X';             -- rx_in0
			dut_hip_serial_rx_in1         : in  std_logic                     := 'X';             -- rx_in1
			dut_hip_serial_rx_in2         : in  std_logic                     := 'X';             -- rx_in2
			dut_hip_serial_rx_in3         : in  std_logic                     := 'X';             -- rx_in3
			dut_hip_serial_tx_out0        : out std_logic;                                        -- tx_out0
			dut_hip_serial_tx_out1        : out std_logic;                                        -- tx_out1
			dut_hip_serial_tx_out2        : out std_logic;                                        -- tx_out2
			dut_hip_serial_tx_out3        : out std_logic;                                        -- tx_out3
			dut_npor_npor                 : in  std_logic                     := 'X';             -- npor
			dut_npor_pin_perst            : in  std_logic                     := 'X';             -- pin_perst
			dut_refclk_clk                : in  std_logic                     := 'X';             -- clk
			pld_clk_clk                   : out std_logic;                                        -- clk
			reset_reset_n                 : in  std_logic                     := 'X';             -- reset_n
			status_hip_derr_cor_ext_rcv   : out std_logic;                                        -- derr_cor_ext_rcv
			status_hip_derr_cor_ext_rpl   : out std_logic;                                        -- derr_cor_ext_rpl
			status_hip_derr_rpl           : out std_logic;                                        -- derr_rpl
			status_hip_dlup_exit          : out std_logic;                                        -- dlup_exit
			status_hip_ev128ns            : out std_logic;                                        -- ev128ns
			status_hip_ev1us              : out std_logic;                                        -- ev1us
			status_hip_hotrst_exit        : out std_logic;                                        -- hotrst_exit
			status_hip_int_status         : out std_logic_vector(3 downto 0);                     -- int_status
			status_hip_l2_exit            : out std_logic;                                        -- l2_exit
			status_hip_lane_act           : out std_logic_vector(3 downto 0);                     -- lane_act
			status_hip_ltssmstate         : out std_logic_vector(4 downto 0);                     -- ltssmstate
			status_hip_ko_cpl_spc_header  : out std_logic_vector(7 downto 0);                     -- ko_cpl_spc_header
			status_hip_ko_cpl_spc_data    : out std_logic_vector(11 downto 0);                    -- ko_cpl_spc_data
			tl_cfg_tl_cfg_add             : out std_logic_vector(3 downto 0);                     -- tl_cfg_add
			tl_cfg_tl_cfg_ctl             : out std_logic_vector(31 downto 0);                    -- tl_cfg_ctl
			tl_cfg_tl_cfg_sts             : out std_logic_vector(52 downto 0)                     -- tl_cfg_sts
		);
	end component top;

	u0 : component top
		port map (
			clk_clk                       => CONNECTED_TO_clk_clk,                       --            clk.clk
			dut_hip_ctrl_test_in          => CONNECTED_TO_dut_hip_ctrl_test_in,          --   dut_hip_ctrl.test_in
			dut_hip_ctrl_simu_mode_pipe   => CONNECTED_TO_dut_hip_ctrl_simu_mode_pipe,   --               .simu_mode_pipe
			dut_hip_pipe_sim_pipe_pclk_in => CONNECTED_TO_dut_hip_pipe_sim_pipe_pclk_in, --   dut_hip_pipe.sim_pipe_pclk_in
			dut_hip_pipe_sim_pipe_rate    => CONNECTED_TO_dut_hip_pipe_sim_pipe_rate,    --               .sim_pipe_rate
			dut_hip_pipe_sim_ltssmstate   => CONNECTED_TO_dut_hip_pipe_sim_ltssmstate,   --               .sim_ltssmstate
			dut_hip_pipe_eidleinfersel0   => CONNECTED_TO_dut_hip_pipe_eidleinfersel0,   --               .eidleinfersel0
			dut_hip_pipe_eidleinfersel1   => CONNECTED_TO_dut_hip_pipe_eidleinfersel1,   --               .eidleinfersel1
			dut_hip_pipe_eidleinfersel2   => CONNECTED_TO_dut_hip_pipe_eidleinfersel2,   --               .eidleinfersel2
			dut_hip_pipe_eidleinfersel3   => CONNECTED_TO_dut_hip_pipe_eidleinfersel3,   --               .eidleinfersel3
			dut_hip_pipe_powerdown0       => CONNECTED_TO_dut_hip_pipe_powerdown0,       --               .powerdown0
			dut_hip_pipe_powerdown1       => CONNECTED_TO_dut_hip_pipe_powerdown1,       --               .powerdown1
			dut_hip_pipe_powerdown2       => CONNECTED_TO_dut_hip_pipe_powerdown2,       --               .powerdown2
			dut_hip_pipe_powerdown3       => CONNECTED_TO_dut_hip_pipe_powerdown3,       --               .powerdown3
			dut_hip_pipe_rxpolarity0      => CONNECTED_TO_dut_hip_pipe_rxpolarity0,      --               .rxpolarity0
			dut_hip_pipe_rxpolarity1      => CONNECTED_TO_dut_hip_pipe_rxpolarity1,      --               .rxpolarity1
			dut_hip_pipe_rxpolarity2      => CONNECTED_TO_dut_hip_pipe_rxpolarity2,      --               .rxpolarity2
			dut_hip_pipe_rxpolarity3      => CONNECTED_TO_dut_hip_pipe_rxpolarity3,      --               .rxpolarity3
			dut_hip_pipe_txcompl0         => CONNECTED_TO_dut_hip_pipe_txcompl0,         --               .txcompl0
			dut_hip_pipe_txcompl1         => CONNECTED_TO_dut_hip_pipe_txcompl1,         --               .txcompl1
			dut_hip_pipe_txcompl2         => CONNECTED_TO_dut_hip_pipe_txcompl2,         --               .txcompl2
			dut_hip_pipe_txcompl3         => CONNECTED_TO_dut_hip_pipe_txcompl3,         --               .txcompl3
			dut_hip_pipe_txdata0          => CONNECTED_TO_dut_hip_pipe_txdata0,          --               .txdata0
			dut_hip_pipe_txdata1          => CONNECTED_TO_dut_hip_pipe_txdata1,          --               .txdata1
			dut_hip_pipe_txdata2          => CONNECTED_TO_dut_hip_pipe_txdata2,          --               .txdata2
			dut_hip_pipe_txdata3          => CONNECTED_TO_dut_hip_pipe_txdata3,          --               .txdata3
			dut_hip_pipe_txdatak0         => CONNECTED_TO_dut_hip_pipe_txdatak0,         --               .txdatak0
			dut_hip_pipe_txdatak1         => CONNECTED_TO_dut_hip_pipe_txdatak1,         --               .txdatak1
			dut_hip_pipe_txdatak2         => CONNECTED_TO_dut_hip_pipe_txdatak2,         --               .txdatak2
			dut_hip_pipe_txdatak3         => CONNECTED_TO_dut_hip_pipe_txdatak3,         --               .txdatak3
			dut_hip_pipe_txdetectrx0      => CONNECTED_TO_dut_hip_pipe_txdetectrx0,      --               .txdetectrx0
			dut_hip_pipe_txdetectrx1      => CONNECTED_TO_dut_hip_pipe_txdetectrx1,      --               .txdetectrx1
			dut_hip_pipe_txdetectrx2      => CONNECTED_TO_dut_hip_pipe_txdetectrx2,      --               .txdetectrx2
			dut_hip_pipe_txdetectrx3      => CONNECTED_TO_dut_hip_pipe_txdetectrx3,      --               .txdetectrx3
			dut_hip_pipe_txelecidle0      => CONNECTED_TO_dut_hip_pipe_txelecidle0,      --               .txelecidle0
			dut_hip_pipe_txelecidle1      => CONNECTED_TO_dut_hip_pipe_txelecidle1,      --               .txelecidle1
			dut_hip_pipe_txelecidle2      => CONNECTED_TO_dut_hip_pipe_txelecidle2,      --               .txelecidle2
			dut_hip_pipe_txelecidle3      => CONNECTED_TO_dut_hip_pipe_txelecidle3,      --               .txelecidle3
			dut_hip_pipe_txswing0         => CONNECTED_TO_dut_hip_pipe_txswing0,         --               .txswing0
			dut_hip_pipe_txswing1         => CONNECTED_TO_dut_hip_pipe_txswing1,         --               .txswing1
			dut_hip_pipe_txswing2         => CONNECTED_TO_dut_hip_pipe_txswing2,         --               .txswing2
			dut_hip_pipe_txswing3         => CONNECTED_TO_dut_hip_pipe_txswing3,         --               .txswing3
			dut_hip_pipe_txmargin0        => CONNECTED_TO_dut_hip_pipe_txmargin0,        --               .txmargin0
			dut_hip_pipe_txmargin1        => CONNECTED_TO_dut_hip_pipe_txmargin1,        --               .txmargin1
			dut_hip_pipe_txmargin2        => CONNECTED_TO_dut_hip_pipe_txmargin2,        --               .txmargin2
			dut_hip_pipe_txmargin3        => CONNECTED_TO_dut_hip_pipe_txmargin3,        --               .txmargin3
			dut_hip_pipe_txdeemph0        => CONNECTED_TO_dut_hip_pipe_txdeemph0,        --               .txdeemph0
			dut_hip_pipe_txdeemph1        => CONNECTED_TO_dut_hip_pipe_txdeemph1,        --               .txdeemph1
			dut_hip_pipe_txdeemph2        => CONNECTED_TO_dut_hip_pipe_txdeemph2,        --               .txdeemph2
			dut_hip_pipe_txdeemph3        => CONNECTED_TO_dut_hip_pipe_txdeemph3,        --               .txdeemph3
			dut_hip_pipe_phystatus0       => CONNECTED_TO_dut_hip_pipe_phystatus0,       --               .phystatus0
			dut_hip_pipe_phystatus1       => CONNECTED_TO_dut_hip_pipe_phystatus1,       --               .phystatus1
			dut_hip_pipe_phystatus2       => CONNECTED_TO_dut_hip_pipe_phystatus2,       --               .phystatus2
			dut_hip_pipe_phystatus3       => CONNECTED_TO_dut_hip_pipe_phystatus3,       --               .phystatus3
			dut_hip_pipe_rxdata0          => CONNECTED_TO_dut_hip_pipe_rxdata0,          --               .rxdata0
			dut_hip_pipe_rxdata1          => CONNECTED_TO_dut_hip_pipe_rxdata1,          --               .rxdata1
			dut_hip_pipe_rxdata2          => CONNECTED_TO_dut_hip_pipe_rxdata2,          --               .rxdata2
			dut_hip_pipe_rxdata3          => CONNECTED_TO_dut_hip_pipe_rxdata3,          --               .rxdata3
			dut_hip_pipe_rxdatak0         => CONNECTED_TO_dut_hip_pipe_rxdatak0,         --               .rxdatak0
			dut_hip_pipe_rxdatak1         => CONNECTED_TO_dut_hip_pipe_rxdatak1,         --               .rxdatak1
			dut_hip_pipe_rxdatak2         => CONNECTED_TO_dut_hip_pipe_rxdatak2,         --               .rxdatak2
			dut_hip_pipe_rxdatak3         => CONNECTED_TO_dut_hip_pipe_rxdatak3,         --               .rxdatak3
			dut_hip_pipe_rxelecidle0      => CONNECTED_TO_dut_hip_pipe_rxelecidle0,      --               .rxelecidle0
			dut_hip_pipe_rxelecidle1      => CONNECTED_TO_dut_hip_pipe_rxelecidle1,      --               .rxelecidle1
			dut_hip_pipe_rxelecidle2      => CONNECTED_TO_dut_hip_pipe_rxelecidle2,      --               .rxelecidle2
			dut_hip_pipe_rxelecidle3      => CONNECTED_TO_dut_hip_pipe_rxelecidle3,      --               .rxelecidle3
			dut_hip_pipe_rxstatus0        => CONNECTED_TO_dut_hip_pipe_rxstatus0,        --               .rxstatus0
			dut_hip_pipe_rxstatus1        => CONNECTED_TO_dut_hip_pipe_rxstatus1,        --               .rxstatus1
			dut_hip_pipe_rxstatus2        => CONNECTED_TO_dut_hip_pipe_rxstatus2,        --               .rxstatus2
			dut_hip_pipe_rxstatus3        => CONNECTED_TO_dut_hip_pipe_rxstatus3,        --               .rxstatus3
			dut_hip_pipe_rxvalid0         => CONNECTED_TO_dut_hip_pipe_rxvalid0,         --               .rxvalid0
			dut_hip_pipe_rxvalid1         => CONNECTED_TO_dut_hip_pipe_rxvalid1,         --               .rxvalid1
			dut_hip_pipe_rxvalid2         => CONNECTED_TO_dut_hip_pipe_rxvalid2,         --               .rxvalid2
			dut_hip_pipe_rxvalid3         => CONNECTED_TO_dut_hip_pipe_rxvalid3,         --               .rxvalid3
			dut_hip_serial_rx_in0         => CONNECTED_TO_dut_hip_serial_rx_in0,         -- dut_hip_serial.rx_in0
			dut_hip_serial_rx_in1         => CONNECTED_TO_dut_hip_serial_rx_in1,         --               .rx_in1
			dut_hip_serial_rx_in2         => CONNECTED_TO_dut_hip_serial_rx_in2,         --               .rx_in2
			dut_hip_serial_rx_in3         => CONNECTED_TO_dut_hip_serial_rx_in3,         --               .rx_in3
			dut_hip_serial_tx_out0        => CONNECTED_TO_dut_hip_serial_tx_out0,        --               .tx_out0
			dut_hip_serial_tx_out1        => CONNECTED_TO_dut_hip_serial_tx_out1,        --               .tx_out1
			dut_hip_serial_tx_out2        => CONNECTED_TO_dut_hip_serial_tx_out2,        --               .tx_out2
			dut_hip_serial_tx_out3        => CONNECTED_TO_dut_hip_serial_tx_out3,        --               .tx_out3
			dut_npor_npor                 => CONNECTED_TO_dut_npor_npor,                 --       dut_npor.npor
			dut_npor_pin_perst            => CONNECTED_TO_dut_npor_pin_perst,            --               .pin_perst
			dut_refclk_clk                => CONNECTED_TO_dut_refclk_clk,                --     dut_refclk.clk
			pld_clk_clk                   => CONNECTED_TO_pld_clk_clk,                   --        pld_clk.clk
			reset_reset_n                 => CONNECTED_TO_reset_reset_n,                 --          reset.reset_n
			status_hip_derr_cor_ext_rcv   => CONNECTED_TO_status_hip_derr_cor_ext_rcv,   --     status_hip.derr_cor_ext_rcv
			status_hip_derr_cor_ext_rpl   => CONNECTED_TO_status_hip_derr_cor_ext_rpl,   --               .derr_cor_ext_rpl
			status_hip_derr_rpl           => CONNECTED_TO_status_hip_derr_rpl,           --               .derr_rpl
			status_hip_dlup_exit          => CONNECTED_TO_status_hip_dlup_exit,          --               .dlup_exit
			status_hip_ev128ns            => CONNECTED_TO_status_hip_ev128ns,            --               .ev128ns
			status_hip_ev1us              => CONNECTED_TO_status_hip_ev1us,              --               .ev1us
			status_hip_hotrst_exit        => CONNECTED_TO_status_hip_hotrst_exit,        --               .hotrst_exit
			status_hip_int_status         => CONNECTED_TO_status_hip_int_status,         --               .int_status
			status_hip_l2_exit            => CONNECTED_TO_status_hip_l2_exit,            --               .l2_exit
			status_hip_lane_act           => CONNECTED_TO_status_hip_lane_act,           --               .lane_act
			status_hip_ltssmstate         => CONNECTED_TO_status_hip_ltssmstate,         --               .ltssmstate
			status_hip_ko_cpl_spc_header  => CONNECTED_TO_status_hip_ko_cpl_spc_header,  --               .ko_cpl_spc_header
			status_hip_ko_cpl_spc_data    => CONNECTED_TO_status_hip_ko_cpl_spc_data,    --               .ko_cpl_spc_data
			tl_cfg_tl_cfg_add             => CONNECTED_TO_tl_cfg_tl_cfg_add,             --         tl_cfg.tl_cfg_add
			tl_cfg_tl_cfg_ctl             => CONNECTED_TO_tl_cfg_tl_cfg_ctl,             --               .tl_cfg_ctl
			tl_cfg_tl_cfg_sts             => CONNECTED_TO_tl_cfg_tl_cfg_sts              --               .tl_cfg_sts
		);

