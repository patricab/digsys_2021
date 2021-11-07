--this is an instantiated file
library ieee;
use ieee.std_logic_1164.all;

entity rsa_control_tb is
end rsa_control_tb;

architecture behaviour of rsa_control_tb is
	signal x_in :std_logic_vector(47 downto 0);
begin
	clk_gen: process is
	begin
		clk <= '1';
		wait for 6 ns;
		clk <= '0';
		wait for 6 ns;
	end process;

	-- reset_n generator
	reset_gen: process is
	begin
		reset_n <= '0';
		wait for 20 ns;
		reset_n <= '1';
		wait;
	end process;

	-- DFF
	i_RSA_control : entity work.or_n
	port map (
		x  => std_logic_vector(47 downto 0);
		y => std_logic);

	-- Set single input for OR gate, assert output
	tb1: process
	begin
		report "Testing DFF";
		report "Test 1: Single step input";
		for n in 0 to 47 loop
			x(n) <= '1';	
			assert y = '0' report "Error: expected '1' as logical output" severity error;
			x <= (others => '0');
		end loop;
	end process tb1;
	
	-- Set multiple inputs for OR gate, assert output
	tb2: process
	begin
		report "Test 2: Multiple inputs";
		for n in 0 to 47 loop
			x_in(n) <= '1';
		end loop;
		x <= x_in;
		assert y = '0' report "Error: expected '1' as logical output" severity error;
		x <= (others => '0');
		report "Test done";
	end process tb2;
end behaviour;