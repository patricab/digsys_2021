--this is an instantiated file
library ieee;
use ieee.std_logic_1164.all;

entity mod_mult_tb is
	generic (
		C_block_size : integer := 8
	);

end mod_mult_tb;


architecture behaviour of mod_mult_tb is

	-- input
	signal a, b, n : std_logic_vector(C_Block_size-1 downto 0);
	-- output
	signal p 		: std_logic_vector(C_Block_size-1 downto 0);
	-- control
	signal valid   : std_logic;
   signal enable  : std_logic;
   signal run    : std_logic;
	-- utility
	signal clk		: std_logic;
   signal reset_n	: std_logic;

	constant CLK_PERIOD    : time := 10 ns;

begin
	i_rsa_modmult : entity work.mod_mult(behavioral)
	    generic map(
	       C_Block_size => C_block_size
	    )
		port map(
			clk => clk,
			reset_n => reset_n,
			a => a,
			b => b,
			n => n,
			p => p,
			valid  => valid,
         enable => enable,
         run    => run
		);

	-- init clock 50 MHz clock
	clock : process is
	begin
		clk <= '1';
		wait for CLK_PERIOD;
		clk <= '0';
		wait for CLK_PERIOD;
	end process; -- Clock


	-- Start by reset
	reset : process is
	begin
		reset_n <= '0';
		wait for 2*CLK_PERIOD;
		reset_n <= '1';
		wait;
	end process; -- reset

	-- input values
	--b <= "00001010"; -- A
	--a <= "11001100"; --CC
	--n <= "01001111"; --4F


	process is
	   -- constant period: time := 8*2*CLK_PERIOD;
	begin
		enable <= '1';
		run    <= '1';
		a <= x"03";
		b <= x"07";
		n <= x"21";
		wait for 2*CLK_PERIOD;
		-- a <= x"000000000a1c91ad4082efb714bd79abcd0d9f67d39110016dc67a4e92ff0a43";
		-- b <= x"000000000024e0941fb50201be3982911bce1c86fa532a3b50e25817ac04878f"; --1F
		-- n <= x"2eca389029913bab3d0b7d023b6ce5cac43ec2f450fb982c728d56f4a3bd011e";

		wait until (valid = '1');
		enable <= '0';
		wait;

	end process;
end behaviour; --i_rsa_modmult
