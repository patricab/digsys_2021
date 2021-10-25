library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package sr_defines is
	constant REGISTER_WIDTH :natural := 48;
	type SR is array(0 to REGISTER_WIDTH) of std_logic_vector(255 downto 0);
end package sr_defines;
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Main entity for control block
entity rsa_control is
	generic (
		-- Users to add parameters here
		C_BLOCK_SIZE :integer := 256
	);
	port (
		-- Tick-tock, on the clock
		clk :in std_logic;

		-- Message that will be sent out is valid
		msgin_valid :in std_logic;
		-- Slave ready to accept a new message
		msgin_ready :out std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgin_data :in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgin_last :in std_logic;

		-- Message that will be sent out is valid
		msgout_valid :out std_logic;
		-- Slave ready to accept a new message
		msgout_ready :in std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgout_data :out std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgout_last :out std_logic);
end entity rsa_control;

architecture structural of rsa_control is
begin
--    
end architecture structural;
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.sr_defines.all;

--  n bit OR gate
entity OR_n is
    port (
		x :in std_logic_vector(REGISTER_WIDTH-1 downto 0);
		y :out std_logic);
end entity OR_n;

architecture behavioral of OR_n is
begin
	y <= or x; 
end architecture behavioral;
--

-- DFF, no enable
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dff is
	port (
		clk     :in  std_logic;
		d       :in  std_logic;
		q       :out std_logic);
end dff;

architecture rtl of dff is
begin
	process(clk)
	begin
		if (clk'event and clk='1') then
			q <= d;
		end if;
	end process;
end rtl;
--

-- Generic n bit Shift Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sr_defines.all;

entity shift_register is
	generic (
		REGISTER_WIDTH :natural := 8);
	port (
		clk     :in  std_logic;
		reset_n :in  std_logic;
		d       :in  std_logic;
		q       :out std_logic_vector(REGISTER_WIDTH-1 downto 0));
end shift_register;

architecture rtl of shift_register is
  signal q_i :std_logic_vector(REGISTER_WIDTH-1 downto 0);
begin
	process(clk, reset_n)
	begin
		if(reset_n = '0') then
			q_i <= (others => '0');
		elsif (clk'event and clk='1') then
			q_i <= q_i(REGISTER_WIDTH-2 downto 0) & d;
		end if;
	end process;
	q <= q_i;
end rtl;
--

-- 256 x n bit Shift Register
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sr_defines.all;

entity shift_register_256 is
	port (
		clk     :in  std_logic;
		reset_n :in  std_logic;
		d       :in  std_logic_vector(255 downto 0);
		q       :out SR);
end shift_register_256;

architecture rtl of shift_register_256 is
	signal q_i :SR;
begin
	process(clk, reset_n)
	begin
		if(reset_n = '0') then
			q_i <= (others => (others => '0'));
		elsif (clk'event and clk='1') then
			q_i <= q_i(REGISTER_WIDTH-2 downto 0) & d;
		end if;
	end process;
	q <= q_i;
end rtl;