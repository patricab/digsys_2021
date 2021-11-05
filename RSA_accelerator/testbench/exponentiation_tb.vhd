library ieee;
use ieee.std_logic_1164.all;


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
	i_exponentiation : entity work.exponentiation(mary_rtl)
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


	Test : process(clk, reset_n)
	constant period : time := 2560 ns;
	begin
		-- static
		valid_in  <= '1';
		ready_in  <= '1';
		ready_out <= '1';
		restart   <= '0';

		key     <= x"00000011"; -- e 65537
		modulus <= x"00000021";
		message <= x"00000007";

		wait for period;
		assert (result = x"0000000D") -- if false
			report "wrong result";

		message <= x"0000000D";

		wait for period;
		assert (result = x"000000007")
			report "wrong result";

		wait;
	end process; -- Test

end expBehave;
