library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package sr_defines is
	constant REGISTER_WIDTH :natural := 48;
	type SR is array(REGISTER_WIDTH-1 downto 0) of std_logic_vector(255 downto 0);
end package sr_defines;
--

--  n bit OR gate
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.sr_defines.all;

entity or_n is
	generic (
		REGISTER_WIDTH :natural := 2);
    port (
		x :in std_logic_vector(REGISTER_WIDTH-1 downto 0);
		y :out std_logic);
end entity or_n;

architecture behavioral of or_n is
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

entity shift_register is
	generic (
		REGISTER_WIDTH :natural := 8);
	port (
		clk     :in  std_logic;
		rst 	:in  std_logic;
		d       :in  std_logic;
		q       :out std_logic_vector(REGISTER_WIDTH-1 downto 0));
end shift_register;

architecture rtl of shift_register is
	signal q_i :std_logic_vector(REGISTER_WIDTH-1 downto 0);
begin
	process(clk, rst)
	begin
		if(rst = '1') then
			q_i <= (others => '0');
		end if;
		if (clk'event and clk='1') then
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
		en 		:in  std_logic;
		d       :in  std_logic_vector(255 downto 0);
		q       :out std_logic_vector(255 downto 0));
end shift_register_256;

architecture rtl of shift_register_256 is
	signal q_i :SR;
begin
	process(clk, en)
	begin
		if (en = '1') and (clk'event and clk='1') then
			q_i <= q_i(REGISTER_WIDTH-2 downto 0) & d;
		end if;
	end process;
	q <= q_i(0);
end rtl;

-- Main entity for control block
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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
		msgout_last :out std_logic;
		
		rl_data :in std_logic_vector(255 downto 0);
		rl_ready :in std_logic_vector(47 downto 0);
		rl_valid :out std_logic_vector(47 downto 0));
end entity rsa_control;

architecture structural of rsa_control is
	signal sr_i, or_y, d_i, sr_en :std_logic;
begin
	
	sr_i <= msgin_valid and msgin_ready;
	sr_48: entity work.shift_register(rtl)
		generic map (
			REGISTER_WIDTH => 48)
		port map (
			clk => clk,
			rst => sr_i,
			d => sr_i,
			q => rl_valid);

	OR_n: entity work.or_n(behavioral)
		generic map (
			REGISTER_WIDTH => 48)
		port map(
			x => rl_ready,
			y => or_y);

	d_i <= or_y and msgout_ready;
	DFF: entity work.dff(rtl)
		port map (
			clk => clk,
			d => d_i,
			q => msgout_valid);
	
	sr_en <= d_i and msgout_valid;
	sr_256: entity work.shift_register_256(rtl)
		port map (
			clk => clk,
			en => sr_en,
			d => rl_data,
			q => msgout_data);
end architecture structural;
--