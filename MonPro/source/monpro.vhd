--------------------------------------------------------------------------------
-- Modular Multiplier
--
-- Description:
-- - High speed modular multiplier module for RSA Cryptography based on the
--   Montgomery algorithm.
--
--------------------------------------------------------------------------------
-- Author(s)    : Eskild
-- Organization : Norwegian University of Science and Technology (NTNU)
--                Department of Electronic Systems
--                https://www.ntnu.edu/ies
-- Course       : TFE4141 Design of digital systems 1 (DDS1)
-- Year         : 2021
-- Project      : RSA accelerator
-- License      : None
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------------------------
entity MonPro is
	generic (
		WORD_SIZE: integer := 256
	);
	port (
		a, b, ñ, n, r           : in  unsigned(WORD_SIZE-1 downto 0);

		u                       : out unsigned(WORD_SIZE-1 downto 0);

		clk, rst                : in  std_logic
	);
end MonPro;
--------------------------------------------------------------------------------
architecture behavioral of MonPro is

begin

	process( clk, rst )
		variable t_reg, m_reg, u_reg : unsigned(WORD_SIZE-1 downto 0) := 0;
	begin
		if rst = '0' then
			u_reg := 0;
			t_reg := 0;
			m_reg := 0;
		elsif rising_edge(clk) then
			t_reg := a * b;
			m_reg := t_reg * ñ mod r;
			u_reg := (t_reg + m_reg * n) / r;
			if u_reg >= n then
				u_reg := u_reg - n;
			end if ;
		end if;
	end process;

	u <= u_reg;

end behavioral;
--------------------------------------------------------------------------------
