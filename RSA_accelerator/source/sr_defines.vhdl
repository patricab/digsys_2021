library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package sr_defines is
	constant REGISTER_WIDTH : natural := 16;
	type SR is array(REGISTER_WIDTH-1 downto 0) of std_logic_vector(255 downto 0);
end package sr_defines;
