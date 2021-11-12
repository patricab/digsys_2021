--this is an instantiated file
library ieee;
use ieee.std_logic_1164.all;

entity mod_mult_tb is
	generic (
		C_Block_size : integer := 256
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
   signal skip    : std_logic;
	-- utility
	signal clk		: std_logic;
   signal reset_n	: std_logic;

begin
	i_rsa_modmult : entity work.mod_mult(behavioral)
	    generic map(
	       C_Block_size => 256
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
         skip => skip
		);

	-- init clock 50 MHz clock
	clock : process is
	begin
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
	end process; -- Clock


	-- Start by reset
	reset : process is
	begin
		reset_n <= '0';
		wait for 20 ns;
		reset_n <= '1';
		wait;
	end process; -- reset

	-- input values
	--b <= "00001010"; -- A
	--a <= "11001100"; --CC
	--n <= "01001111"; --4F

      enable <= '1';
      skip   <= '0';

	process is
	   constant period: time := 180 ns;
	begin
		a <= x"000000000a1c91ad4082efb714bd79abcd0d9f67d39110016dc67a4e92ff0a43";
		b <= x"000000000024e0941fb50201be3982911bce1c86fa532a3b50e25817ac04878f"; --1F
		n <= x"2eca389029913bab3d0b7d023b6ce5cac43ec2f450fb982c728d56f4a3bd011e";
	wait for period;
	end process;
end behaviour; --i_rsa_modmult
