--  n bit OR gate
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity or_n is
	generic (
		REGISTER_WIDTH : natural := 2);
    port (
		x : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);
		y : out std_logic);
end entity or_n;

architecture behavioral of or_n is
begin
	y <= or x;
end architecture behavioral;
