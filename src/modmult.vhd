library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity modmult is
  port (
	clk, reset_n : in std_logic;

  );
end modmult ;

architecture behavioral of modmult is



begin

	modmult : process(clk, reset_n)
	variable p := 0;
	begin
		if( reset_n = '0' ) then
			p := 0;
		elsif( rising_edge(clk) ) then
			mult : for i in 0 to 255 loop
				p := 2 * p + a * b[i];
				if p >= n then
					p := p - n;
				end if;
				if p >= n then
					p := p - n;
				end if;
			end loop; -- mult
	  end if;
	end process; -- modmult

end architecture; -- behavioral