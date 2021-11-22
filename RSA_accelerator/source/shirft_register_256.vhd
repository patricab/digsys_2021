-- 256 x n bit Shift Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sr_defines.all;

entity shift_register_256 is port
   (
		clk, rst, en   : in  std_logic;
		d       	      : in  std_logic_vector(255 downto 0);
		q       	      : out std_logic_vector(255 downto 0)
   );
end shift_register_256;

architecture rtl of shift_register_256 is

	signal q_i :SR;

begin
	process(clk, en, rst)
	begin
		if (rst = '0') then
			for i in 0 to 47 loop
				q_i(i) <= (others => '0');
			end loop;
		end if;
		if (en = '1') and (clk'event and clk='1') then
			q_i <= q_i(REGISTER_WIDTH-2 downto 0) & d;
		end if;
	end process;
	q <= q_i(47);
end rtl;
