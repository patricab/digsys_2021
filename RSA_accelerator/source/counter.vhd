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

architecture up of counter is

	signal value : unsigned(bit-1 downto 0);

begin

	counter : process( clk, rst, value )
	begin
		if( rst = '0' ) then
			value <= (others => '0');
		elsif( rising_edge(clk) ) then
			value <= value + 1;
		end if;
		val <= value;
	end process; -- counter

end architecture;

architecture down of counter is

	signal value : unsigned(bit-1 downto 0);

begin

	counter : process( clk, rst, value )
	begin
		if( rst = '0' ) then
			value <= (others => '1');
		elsif( rising_edge(clk) ) then
			value <= value - 1;
		end if;
		val <= value;
	end process; -- counter

end architecture;
