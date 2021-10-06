library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modexp is
  port (
		clk, reset_n    : in  std_logic;
		-- msg in
		msgin_ready     : in  std_logic;
		msgin_data      : in  std_logic_vector(255 downto 0);
		-- msg out
		msgout_ready    : out std_logic
		msgout_data     : out std_logic_vector(255 downto 0);
		-- control
		input_reg_en    : in  std_logic;
		output_reg_en   : in  std_logic;
		output_reg_load : in  std_logic;
  );
end modexp;

architecture behavioral of modexp is


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
