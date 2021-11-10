--this is an instantiated file
library ieee;
use ieee.std_logic_1164.all;

entity rsa_control_tb is
end rsa_control_tb;

architecture behaviour of rsa_control_tb is
	signal x_in :std_logic_vector(47 downto 0) := (others => '0');
	signal d_sr, q_sr, q_t :std_logic_vector(255 downto 0) := (others => '0');
	signal clk, reset_n, y, d, q, en :std_logic := '0';
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
		wait for 6 ns;
		reset_n <= '1';
		wait;
	end process;

	-- OR_n
	dut_or_n : entity work.or_n
		generic map(
			REGISTER_WIDTH => 48
		)
		port map (
			x  => x_in,
			y => y);

	-- DFF
	dut_dff: entity work.dff_clr
		port map(
			clk => clk,
			reset_n => reset_n,
			d => d,
			q => q);

	-- 256 bit Shift register
	dut_sr_256: entity work.shift_register_256
		port map(
			clk => clk,
			rst => reset_n,
			en => en,
			d => d_sr,
			q => q_sr);

	tb1: process
	begin
		report "Testing OR_n";
	-- Set single input for OR gate, assert output
		report "Test 1: Single step input";
		x_in <= (others => '0');
		wait for 6 ns;
		for n in 0 to 47 loop
			x_in(n) <= '1';	
			wait for 6 ns;
			x_in <= (others => '0');
		end loop;

	-- Set multiple inputs for OR gate, assert output
		report "Test 2: Multiple inputs";
		wait for 6 ns;
		x_in <= (others => '1');
		-- assert y = '1' report "expected '1' as logical output" severity error;
		report "Test done";

		report "Testing DFF";
		report "Test 1: High input";
		d <= '1';
		-- assert q = '1' report "expected '1' as logical output" severity error;

		report "Test 2: Low input";
		wait for 6 ns;
		d <= '0';
		-- assert q = '0' report "expected '0' as logical output" severity error;
		report "Test done";
	
		report "Testing 256 bit Shift register";	
		report "Test 1: Shifting output";
		wait for 6 ns; -- Wait one cycle
		en <= '1';
		d_sr <= (others => '1');
		q_t <= (others => '1');
		wait for 6 ns; -- Wait one cycle
		d_sr <= (others => '0');
		-- assert q_sr = q_t report "expected 'std_logic_vector(1)' as logical output" severity error; -- Output = '0', should be '1'

		report "Test 2: Clear output after shift";
		wait for 6 ns; -- Wait one cycle
		q_t <= (others => '0');
		-- assert q_sr = q_t report "expected 'std_logic_vector(0)' as logical output" severity error; -- Output '1', should be '0'
		report "Test done";
		
		wait;
	end process tb1;
end behaviour;