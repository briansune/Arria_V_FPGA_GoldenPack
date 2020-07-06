	component top is
		port (
			clk_clk                        : in  std_logic := 'X'; -- clk
			reset_reset_n                  : in  std_logic := 'X'; -- reset_n
			refclk_clk                     : in  std_logic := 'X'; -- clk
			reconfclk_lock_fixedclk_locked : out std_logic;        -- fixedclk_locked
			nrst_status_reset_n            : out std_logic         -- reset_n
		);
	end component top;

	u0 : component top
		port map (
			clk_clk                        => CONNECTED_TO_clk_clk,                        --            clk.clk
			reset_reset_n                  => CONNECTED_TO_reset_reset_n,                  --          reset.reset_n
			refclk_clk                     => CONNECTED_TO_refclk_clk,                     --         refclk.clk
			reconfclk_lock_fixedclk_locked => CONNECTED_TO_reconfclk_lock_fixedclk_locked, -- reconfclk_lock.fixedclk_locked
			nrst_status_reset_n            => CONNECTED_TO_nrst_status_reset_n             --    nrst_status.reset_n
		);

