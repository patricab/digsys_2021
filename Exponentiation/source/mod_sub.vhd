library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod_sub is
	generic (
		bits : natural := 256
	);
	port (
		input   : in  std_logic_vector(bits-1 downto 0);
		modular : in  std_logic_vector(bits-1 downto 0);
		output  : out std_logic_vector(bits-1 downto 0)
	);
end mod_sub;

architecture rtl of mod_sub is

begin

	mod_sub : process(input, modular)
	begin
		if (input >= modular) then
			output <= std_logic_vector(unsigned(input) - unsigned(modular));
		else
			output <= std_logic_vector(unsigned(input));
		end if;
	end process ; -- mod_sub

end architecture;
