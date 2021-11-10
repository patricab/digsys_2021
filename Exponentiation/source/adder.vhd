library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
	generic (
		bits : natural := 256
	);
	port (
		a, b : in  std_logic_vector(bits-1 downto 0);
		y    : out std_logic_vector(bits-1 downto 0)
	);
end adder;

architecture rtl of adder is

begin

	y <= std_logic_vector(unsigned(a) + unsigned(b));

end architecture;
