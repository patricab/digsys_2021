-- Generic n bit Shift Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_register is
	generic (
		REGISTER_WIDTH :natural := 8);
	port (
		clk, rst : in  std_logic;
		d        : in  std_logic;
		q        : out std_logic_vector(REGISTER_WIDTH-1 downto 0)
   );
end shift_register;

architecture rtl of shift_register is
	signal q_i :std_logic_vector(REGISTER_WIDTH-1 downto 0);
begin
	process(clk, rst)
	begin
		if(rst = '0') then
			q_i <= (others => '0');
		end if;
		if (clk'event and clk='1') then
			q_i <= q_i(REGISTER_WIDTH-2 downto 0) & d;
		end if;
	end process;
	q <= q_i;
end rtl;
