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

end architecture;
