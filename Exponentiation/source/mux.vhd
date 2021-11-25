library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
	generic (
		num    : natural := 16
	);
	port (
		input  : in  std_logic_vector(num-1 downto 0);
		sel    : in  natural range 0 to num-1;
		output : out std_logic
	);
end mux;

architecture rtl of mux is

begin

	output <= input(sel);

end architecture;

--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux is
	generic (
		num    : natural := 16
	);
	port (
		input  : in  std_logic;
		sel    : in  natural range 0 to num-1;
		output : out std_logic_vector(num-1 downto 0)
	);
end demux;

architecture rtl of demux is

begin

	output <= (sel => input, others => '0');

	-- demux_pro : process( sel )
	-- begin
	-- 	case( sel ) is
	-- 		-- when  0 => output <= ( 0 => input, others => '0');
	-- 		when  1 => output <= (16 => input, others => '0');
	-- 		when  2 => output <= (15 => input, others => '0');
	-- 		when  3 => output <= (14 => input, others => '0');
	-- 		when  4 => output <= (13 => input, others => '0');
	-- 		when  5 => output <= (12 => input, others => '0');
	-- 		when  6 => output <= (11 => input, others => '0');
	-- 		when  7 => output <= (10 => input, others => '0');
	-- 		when  8 => output <= ( 9 => input, others => '0');
	-- 		when  9 => output <= ( 8 => input, others => '0');
	-- 		when 10 => output <= ( 7 => input, others => '0');
	-- 		when 11 => output <= ( 6 => input, others => '0');
	-- 		when 12 => output <= ( 5 => input, others => '0');
	-- 		when 13 => output <= ( 4 => input, others => '0');
	-- 		when 14 => output <= ( 3 => input, others => '0');
	-- 		when 15 => output <= ( 2 => input, others => '0');
	-- 		when 16 => output <= ( 1 => input, others => '0');

	-- 		when others => output <= (others => '0');
	-- 	end case ;
	-- end process ; -- demux_pro

end architecture;
