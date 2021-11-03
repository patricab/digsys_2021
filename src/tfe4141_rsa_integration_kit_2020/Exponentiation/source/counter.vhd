library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
	generic (
		bit : integer := 8
	);
	port (
		clk	: in 	std_logic;
		rst	: in 	std_logic;
		en 	: in 	std_logic;
		val	: out	unsigned(bit-1 downto 0)
	);
end counter;

architecture rtl of counter is

begin

	counter : process( clk, rst )
	begin
		if( rst = '0' ) then
			val <= (others => '0');
		elsif( rising_edge(clk) ) then
			val <= val + 1;
		end if;
	end process; -- counter


end architecture;
