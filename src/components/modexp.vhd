library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modexp is
  port (
		clk, reset_n : in  std_logic;
		-- reg I/O
		key_n, key_e : in std_logic_vector(255 downto 0);
		-- msg in
		msgin_ready  : in  std_logic;
		msgin_data   : in  std_logic_vector(255 downto 0);
		-- msg out
		msgout_data  : out std_logic_vector(255 downto 0);
		msgout_ready : out std_logic
		-- control
		valid        : in  std_logic;
		ready        : out std_logic;
  );
end modexp;

architecture rl_binary of modexp is

	signal

begin

	rl_binary : process(clk, reset_n, msgin_ready)
	variable : c unsigned(255 downto 0) := 1;
	variable : p unsigned(255 downto 0) := msgin_data;
	begin
		if reset_n = '0' then
		-- reset
		elsif rising_edge(clk) then
			for i in 0 to 255 loop
				if key_e(255-i) then
					c := modmult(c, p, key_n);
				end if ;
				p := modmult(p, p, key_n);
			end loop;
		end if;
	end process; -- rl_binary

end rl_binary; -- rl_binary




architecture lr_binary of modexp is


begin

	lr_binary : process( msgin_ready )
	variable : c unsigned(255 downto 0) := 1;
	begin
		if key_n(255) == '1' then
			c := msgin_data;
		end if;
		modexp : for i in 0 to 255 loop
			c := modmult(c, c, n)
			if key_e(-i) == '1' then
				c := modmult(c, msgin_data, key_n);
			end if;
		end loop; -- modexp
		done <= '1';
	end process; -- lr_binary



	-- modmult: entity work.modmult(behavioral) port map(
	--    clk => clk, reset_n => reset_n,

	-- )


end architecture; -- behavioral
