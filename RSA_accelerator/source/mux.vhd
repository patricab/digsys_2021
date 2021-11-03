library ieee;
use ieee.std_logic_1164.all;

package slv_arr_p is
	type slv_array_t is array (natural range <>) of std_logic_vector;
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.slv_arr_p.all;

entity mux is
	generic (
		num : natural := 32;
		bit : natural :=  1
	);
	port (
		input  : in  slv_array_t(0 to num-1)(bit-1 downto 0);
		sel    : in  natural range 0 to num-1;
		output : out std_logic_vector(bit-1 downto 0)
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
use work.slv_arr_p.all;

entity demux is
	generic (
		num : natural := 32;
		bit : natural :=  1
	);
	port (
		input  : in  std_logic_vector(bit-1 downto 0);
		sel    : in  natural range 0 to num-1;
		output : out slv_array_t(0 to num-1)(bit-1 downto 0)
	);
end demux;

architecture rtl of demux is

begin

	output(sel) <= input;

end architecture;
