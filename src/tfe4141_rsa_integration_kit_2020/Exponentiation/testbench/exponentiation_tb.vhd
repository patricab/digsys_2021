library ieee;
use ieee.std_logic_1164.all;


entity exponentiation_tb is
	generic (
		C_block_size : integer := 32 -- 256
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
	i_exponentiation : entity work.exponentiation(mary)
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

	-- 100MHz Clock
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

	-- Static
	key     <= x"00010001"; -- e 65537

	message <= x"0A0C0E0F";

	modulus <= x"00002010";

	valid_in  <= '1';
	ready_in  <= '1';
	ready_out <= '1';
	restart   <= '0';


	Test : process(clk, reset_n)
	begin
		if(reset_n = '0') then
		--	reset
		elsif(rising_edge(clk)) then


		end if;
	end process; -- Test

end expBehave;
