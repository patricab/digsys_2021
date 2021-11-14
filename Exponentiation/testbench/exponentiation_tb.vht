library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exponentiation_tb is
	generic (
		C_block_size : integer := 256
	);
end exponentiation_tb;


architecture expBehave of exponentiation_tb is
	-- Input
	signal message  	: STD_LOGIC_VECTOR(C_block_size-1 downto 0);
	signal key      	: STD_LOGIC_VECTOR(C_block_size-1 downto 0);
	signal modulus  	: STD_LOGIC_VECTOR(C_block_size-1 downto 0);
	-- Output
	signal result     : STD_LOGIC_VECTOR(C_block_size-1 downto 0);
	-- Control
	signal valid_in 	: STD_LOGIC;
	signal ready_in 	: STD_LOGIC;
	signal ready_out	: STD_LOGIC;
	signal valid_out	: STD_LOGIC;
	-- Utility
	signal clk      	: STD_LOGIC;
	signal restart  	: STD_LOGIC;
	signal reset_n  	: STD_LOGIC;

	constant CLK_PERIOD : time := 20 ns;

begin
	i_exponentiation : entity work.exponentiation(rl_binary_rtl)
		generic map (C_block_size => C_block_size)
		port map (
			message   => message  ,
			key       => key      ,
			valid_in  => valid_in ,
			ready_in  => ready_in ,
			ready_out => ready_out,
			valid_out => valid_out,
			result    => result   ,
			modulus   => modulus  ,
			clk       => clk      ,
			reset_n   => reset_n
		);

	-- 50MHz Clock
	Clock : process is
	begin
		clk <= '1';
		wait for CLK_PERIOD/2;
		clk <= '0';
		wait for CLK_PERIOD/2;
	end process ; -- Clock

	-- Start by reseting
	Reset : process is
	begin
		reset_n <= '0';
		wait for CLK_PERIOD;
		reset_n <= '1';
		wait;
	end process ; -- Reset


	Test : process
	constant period : time := 8*8*CLK_PERIOD;
	begin
		-- static
		valid_in  <= '1';
		ready_out <= '0';
		restart   <= '0';
		wait for CLK_PERIOD;

		message <= x"00000000" & x"00000000" & x"00000000" & x"00000000"
		         & x"00000000" & x"00000000" & x"00000000" & x"02348762";
		key     <= (0 => '1', 4 => '1', others => '0'); -- e 65537
		modulus <= x"00000000" & x"00000000" & x"00000000" & x"00000000"
		         & x"00000000" & x"00000000" & x"07374837" & x"28274817";

		wait until (valid_out = '1');
		assert (result = x"00000000" & x"00000000" & x"00000000" & x"00000000"
		               & x"00000000" & x"00000000" & x"050f2bc2" & x"15aabc56") -- if false
			report "wrong result";

		wait for period;

		ready_out <= '1';

		wait for 5*CLK_PERIOD;

		message <= (0 => '1', 1 => '1', 2 => '1', others => '0'); -- & x"00000007"; -- m  7
		key     <= (0 => '1', 1 => '1', others => '0'); -- x"00000003"; -- e  3
		modulus <= (0 => '1', 5 => '1', others => '0'); -- & x"00000021"; -- n 33

		wait until (valid_out = '1');
		assert (result = x"00000000" & x"00000000" & x"00000000" & x"00000000"
		               & x"00000000" & x"00000000" & x"00000000" & x"000000" &
							x"0D") -- if false
			report "wrong result";

		wait for period;

		ready_out <= '1';

		wait for 5*CLK_PERIOD;

		ready_out <= '0';

		key     <= (0 => '1', 1 => '1', 2 => '1', others => '0'); -- & x"00000007"; -- d  7
		message <= (3 => '1', 2 => '1', 0 => '1', others => '0'); -- & x"0000000D") -- m 13

		wait until (valid_out = '1');
		assert (result = x"00000000" & x"00000000" & x"00000000" & x"00000000"
		               & x"00000000" & x"00000000" & x"00000000" & x"000000" &
							x"07")
			report "wrong result";

		wait for period;

		ready_out <= '1';

		wait;
	end process; -- Test
end expBehave;
