	component low_latency_10g_1ch is
		port (
			alt_xcvr_reconfig_0_reconfig_busy_reconfig_busy : out std_logic;                                       -- reconfig_busy
			clk_50_clk                                      : in  std_logic                    := 'X';             -- clk
			clk_50_reset_reset_n                            : in  std_logic                    := 'X';             -- reset_n
			pll_0_locked_export                             : out std_logic;                                       -- export
			refclk_in_clk                                   : in  std_logic                    := 'X';             -- clk
			refclk_reset_reset_n                            : in  std_logic                    := 'X';             -- reset_n
			xcvr_custom_phy_0_pll_locked_export             : out std_logic_vector(0 downto 0);                    -- export
			xcvr_custom_phy_0_rx_ready_export               : out std_logic;                                       -- export
			xcvr_custom_phy_0_rx_serial_data_export         : in  std_logic_vector(1 downto 0) := (others => 'X'); -- export
			xcvr_custom_phy_0_tx_ready_export               : out std_logic;                                       -- export
			xcvr_custom_phy_0_tx_serial_data_export         : out std_logic_vector(1 downto 0)                     -- export
		);
	end component low_latency_10g_1ch;

	u0 : component low_latency_10g_1ch
		port map (
			alt_xcvr_reconfig_0_reconfig_busy_reconfig_busy => CONNECTED_TO_alt_xcvr_reconfig_0_reconfig_busy_reconfig_busy, -- alt_xcvr_reconfig_0_reconfig_busy.reconfig_busy
			clk_50_clk                                      => CONNECTED_TO_clk_50_clk,                                      --                            clk_50.clk
			clk_50_reset_reset_n                            => CONNECTED_TO_clk_50_reset_reset_n,                            --                      clk_50_reset.reset_n
			pll_0_locked_export                             => CONNECTED_TO_pll_0_locked_export,                             --                      pll_0_locked.export
			refclk_in_clk                                   => CONNECTED_TO_refclk_in_clk,                                   --                         refclk_in.clk
			refclk_reset_reset_n                            => CONNECTED_TO_refclk_reset_reset_n,                            --                      refclk_reset.reset_n
			xcvr_custom_phy_0_pll_locked_export             => CONNECTED_TO_xcvr_custom_phy_0_pll_locked_export,             --      xcvr_custom_phy_0_pll_locked.export
			xcvr_custom_phy_0_rx_ready_export               => CONNECTED_TO_xcvr_custom_phy_0_rx_ready_export,               --        xcvr_custom_phy_0_rx_ready.export
			xcvr_custom_phy_0_rx_serial_data_export         => CONNECTED_TO_xcvr_custom_phy_0_rx_serial_data_export,         --  xcvr_custom_phy_0_rx_serial_data.export
			xcvr_custom_phy_0_tx_ready_export               => CONNECTED_TO_xcvr_custom_phy_0_tx_ready_export,               --        xcvr_custom_phy_0_tx_ready.export
			xcvr_custom_phy_0_tx_serial_data_export         => CONNECTED_TO_xcvr_custom_phy_0_tx_serial_data_export          --  xcvr_custom_phy_0_tx_serial_data.export
		);

