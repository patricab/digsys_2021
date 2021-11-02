library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity mod_mult is
	generic (
		C_block_size : integer := 256
	);
	port (
		clk, reset_n : in  std_logic;
		a, b, n      : in  std_logic_vector(C_block_size-1 downto 0);
		c            : out std_logic_vector(C_block_size-1 downto 0)
	);
end mod_mult;

architecture blakeley of mod_mult is

	signal 

begin

	
	blakeley : process( clk, reset_n )
	begin
		if(reset_n = '0') then
			
		elsif( rising_edge(clk) ) then
			loop : for i in 0 to C_block_size-1 loop
				p := 2 * p + a * unsigned(b(i));
				if p >= n then
					p = p - n;
					if p >= n then
						p = p - n;
					end if;
				end if;
			end loop; -- loop
		end if;
	end process; -- blakeley
	

end architecture;