library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity rsa_core_tb is
end rsa_core_tb;

architecture sim of rsa_core_tb is
-- Clock Frequency
	constant clk_hz : integer := 100e6;
	constant clk_period : time := 1 sec / clk_hz;

-- Standard Inputs
	signal clk     : std_logic := '1';
	signal reset_n : std_logic := '0';

-- RSA reg I/O
	signal key_n, key_e : std_logic_vector(255 downto 0);
	signal rsa_status   : std_logic_vector( 31 downto 0);

-- Message
	signal msgin_data,  msgout_data  : std_logic_vector(255 downto 0);
	signal msgin_last,  msgout_last  : std_logic := '0';
	signal msgin_ready, msgout_ready : std_logic := '0';
	signal msgin_valid, msgout_valid : std_logic := '0';

begin

	clk <= not clk after clk_period / 2;

	DUT : entity work.rsa_core(rtl)
	port map (
	-- Clock Reset
		clk          => clk,
		reset_n      => reset_n,

	-- RSA message out
		msgin_data   => msgin_data,
		msgin_last   => msgin_last,
		msgin_ready  => msgin_ready,
		msgin_valid  => msgin_valid,

	-- RSA message in
		msgout_data  => msgout_data,
		msgout_last  => msgout_last,
		msgout_ready => msgout_ready,
		msgout_valid => msgout_valid,

	-- RSA reg I/O
		key_n        => key_n,
		key_e        => key_e,
		rsa_status   => rsa_status
	);

	SEQUENCER_PROC : process
	begin
		wait for clk_period * 2;

		reset_n <= '1';

		wait for clk_period * 10;
		assert false
			report "Replace this with your test cases"
			severity failure;

		finish;
	end process;

end architecture;
