library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod_sub is
	generic (
		bits : natural := 256
	);
	port (
		input   : in  unsigned(bits-1 downto 0);
		modular : in  unsigned(bits-1 downto 0);
		output  : out unsigned(bits-1 downto 0)
	);
end mod_sub;

architecture rtl of mod_sub is

begin

	mod_sub : process(input, modular)
	begin
		if (input >= modular) then
			output <= input - modular;
		else
			output <= input;
		end if;
	end process ; -- mod_sub

end architecture;
