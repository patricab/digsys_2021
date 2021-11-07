--this is an instantiated file
library ieee;
use ieee.std_logic_1164.all;

entity rsa_control_tb is
end rsa_control_tb;

architecture behaviour of rsa_control_tb is
	signal x_in :std_logic_vector(47 downto 0);
	signal d_sr, q_sr, q_t :std_logic_vector(255 downto 0);
	signal d, q, en :std_logic;
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

	-- OR_n
	dut_or_n : entity work.or_n
	port map (
		x  => std_logic_vector(47 downto 0);
		y => std_logic);

	-- Set single input for OR gate, assert output
	tb1: process
	begin
		report "Testing OR_n";
		report "Test 1: Single step input";
		for n in 0 to 47 loop
			x(n) <= '1';	
			assert y = '0' report "Error: expected '1' as logical output" severity error;
			x <= (others => '0');
		end loop;

	-- Set multiple inputs for OR gate, assert output
		report "Test 2: Multiple inputs";
		for n in 0 to 47 loop
			x_in(n) <= '1';
		end loop;
		x <= x_in;
		assert y = '0' report "Error: expected '1' as logical output" severity error;
		x <= (others => '0');

		report "Test done";
	end process tb1;


	-- DFF
	dut_dff: entity work.dff
		port map(
			clk => clk,
			d => d,
			q => q);

	tb2: process
	begin
		report "Testing DFF";
		report "Test 1: High input";
		d <= '1';
		wait for 6 ns;
		assert q = '0' report "Error: expected '1' as logical output" severity error;

		report "Test 2: Low input";
		d <= '0';
		wait for 6 ns;
		assert q = '1' report "Error: expected '0' as logical output" severity error;

		report "Test done";
	end process tb2;

	-- 256 bit Shift register
	dut_sr_256: entity work.shift_register_256
		port map(
			clk => clk,
			en => en,
			d => d_sr,
			q => q_sr);
			
	tb3: process
	begin
		report "Testing 256 bit Shift register";	
		report "Test 1: Shifting output";
		d_sr <= (others => '1');
		q_t <= (others => '0');
		wait for 6 ns;
		d_sr <= (others => '0');
		wait for 282 ns; -- 47 * 6ns
		assert q_sr = q_t report "Error: expected 'std_logic_vector(1)' as logical output" severity error;

		report "Test 2: Clear output after shift";
		wait for 6 ns;
		q_t <= (others => '1');
		assert q_sr = q_t report "Error: expected 'std_logic_vector(0)' as logical output" severity error;
		report "Test done";
	end process tb3;
end behaviour;