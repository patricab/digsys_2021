library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
	generic (
		inbit  : integer := 32;
		selbit : integer :=  4;
		outbit : integer :=  2
	);
	port (
		input  : in  std_logic_vector( inbit-1 downto 0);
		sel    : in  std_logic_vector(selbit-1 downto 0);
		output : out std_logic_vector(outbit-1 downto 0)
	);
end mux;

architecture rtl of mux is

begin

	output <= input(integer(sel)*outbit downto integer(sel)*outbit-outbit);

end architecture;

--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux is
	generic (
		inbit  : integer :=  2;
		selbit : integer :=  4;
		outbit : integer := 32
	);
	port (
		input  : in  std_logic_vector( inbit-1 downto 0);
		sel    : in  std_logic_vector(selbit-1 downto 0);
		output : out std_logic_vector(outbit-1 downto 0)
	);
end demux;

architecture rtl of demux is

begin

	output <= input(integer(sel)*inbit downto integer(sel)*inbit-inbit);

end architecture;
