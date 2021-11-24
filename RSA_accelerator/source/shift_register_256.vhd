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
		d_valid, d_last    : in  std_logic_vector(CORES-1 downto 0);
		d                  : in  SR;
		q_valid, q_last    : out std_logic;
		q                  : out std_logic_vector(255 downto 0)
	);
end shift_register_256;

architecture rtl of shift_register_256 is

	signal q_i              : SR;
	signal Z                : std_logic_vector(255 downto 0);
	signal i_valid, i_last  : std_logic_vector(CORES-1 downto 0);

begin

	Z <= (others => 'Z');

	process (clk, en, rst) is
	begin
		if (rst = '0') then
			for i in 0 to CORES-1 loop
				q_i(i)  <= (others => '0');
			end loop;
			i_valid    <= (others => '0');
			i_last     <= (others => '0');
		elsif (rising_edge(clk)) then
			if (en = '1') then
				q_i     <= q_i    (REGISTER_WIDTH-2 downto 0) & Z;
				i_valid <= i_valid(REGISTER_WIDTH-2 downto 0) & '0';
				i_last  <= i_last (REGISTER_WIDTH-2 downto 0) & '0';

			elsif (piso = '1') then
				q_i     <= d;
				i_valid <= d_valid;
				i_last  <= d_last;
			end if;
		end if;
	end process;

	q       <= q_i(CORES-1);
	q_valid <= i_valid(CORES-1);
	q_last  <= i_last (CORES-1);

end rtl;
