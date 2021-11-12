library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.slv_arr_p.all;

entity exponentiation_tb is
	generic (
		C_block_size : integer := 256 -- 256
	);
end exponentiation_tb;


architecture expBehave of exponentiation_tb is
	-- Input
	signal message  	: STD_LOGIC_VECTOR(C_block_size-1 downto 0);
	signal key      	: STD_LOGIC_VECTOR(C_block_size-1 downto 0);
	signal modulus  	: STD_LOGIC_VECTOR(C_block_size-1 downto 0);
	-- Output
	signal result   	: STD_LOGIC_VECTOR(C_block_size-1 downto 0);
	signal cnt        : unsigned(8 downto 0);
	signal p_en       : std_logic;
	signal state, nxt_state : state_t;
	-- Control
	signal valid_in 	: STD_LOGIC;
	signal ready_in 	: STD_LOGIC;
	signal ready_out	: STD_LOGIC;
	signal valid_out	: STD_LOGIC;
	-- Utility
	signal clk      	: STD_LOGIC;
	signal restart  	: STD_LOGIC;
	signal reset_n  	: STD_LOGIC;

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
			cnt       => cnt      , -- test
			p_en      => p_en     , -- test
			state     => state    ,
			nxt_state => nxt_state,
			modulus   => modulus  ,
			clk       => clk      ,
			reset_n   => reset_n
		);

	-- 50MHz Clock
	Clock : process is
	begin
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
	end process ; -- Clock

	-- Start by reseting
	Reset : process is
	begin
		reset_n <= '0';
		wait for 20 ns;
		reset_n <= '1';
		wait;
	end process ; -- Reset


	Test : process
	constant period : time := 256*256*20 ns;
	begin
		-- static
		valid_in  <= '1';
		ready_out <= '0';
		restart   <= '0';
		wait for 20 ns;

		key     <= (0 => '1', 1 => '1', others => '0'); -- x"00000003"; -- e  3 -- e 65537
		modulus <= (0 => '1', 5 => '1', others => '0'); -- & x"00000021"; -- n 33
		message <= (0 => '1', 1 => '1', 2 => '1', others => '0'); -- & x"00000007"; -- m  7

		wait for period;
		assert (result = x"00000000" & x"00000000" & x"00000000" & x"00000000"
		               & x"00000000" & x"00000000" & x"00000000" & x"0000000D") -- if false
			report "wrong result";

		ready_out <= '1';

		wait for 100 ns;

		ready_out <= '0';

		key     <= (0 => '1', 1 => '1', 2 => '1', others => '0'); -- & x"00000007"; -- d  7
		message <= (3 => '1', 2 => '1', 0 => '1', others => '0'); -- & x"0000000D") -- m 13

		wait for period;
		assert (result = x"00000000" & x"00000000" & x"00000000" & x"00000000"
		               & x"00000000" & x"00000000" & x"00000000" & x"00000007")
			report "wrong result";

		ready_out <= '1';

		wait;
	end process; -- Test

end expBehave;
