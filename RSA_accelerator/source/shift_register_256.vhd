-- 256 x n bit Shift Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sr_defines.all;

entity shift_register_256 is
	generic(CORES         : natural := 16);
	port
	(
		clk, rst, en, piso : in  std_logic;
		d_valid, d_last    : in  std_logic_vector(0 to CORES);
		d                  : in  SR_17;
		q_valid, q_last    : out std_logic;
		q                  : out std_logic_vector(255 downto 0)
	);
end shift_register_256;

architecture rtl of shift_register_256 is

	signal q_i              : SR_17;
	signal Z                : std_logic_vector(255 downto 0);
	signal i_valid, i_last  : std_logic_vector(0 to CORES);

begin

	Z <= (others => 'Z');

	process (clk, en, rst, piso) is
	begin
		if (rst = '0') then
			for i in 0 to CORES loop
				q_i(i)  <= (others => '0');
			end loop;
			i_valid    <= (others => '0');
			i_last     <= (others => '0');
		elsif (rising_edge(clk)) then
			if (en = '1') then
				q_i     <= q_i    (1 to REGISTER_WIDTH) & Z;
				i_valid <= i_valid(1 to REGISTER_WIDTH) & '0';
				i_last  <= i_last (1 to REGISTER_WIDTH) & '0';

			elsif (piso = '1') then
				q_i     <= d;
				i_valid <= d_valid;
				i_last  <= d_last;
			end if;
		end if;
	end process;

	q       <= q_i(0);
	q_valid <= i_valid(0);
	q_last  <= i_last (0);

end rtl;
