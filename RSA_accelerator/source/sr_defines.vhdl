library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package sr_defines is
	constant REGISTER_WIDTH : natural := 16;
	type SR is array(0 to REGISTER_WIDTH-1) of std_logic_vector(255 downto 0);
end package sr_defines;
