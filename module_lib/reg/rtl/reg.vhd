-- *****************************************************************************
-- Name:     reg.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Positive edge triggered register.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
  generic (
    REGISTER_WIDTH : natural := 8);
  port (
    clk     : in  std_logic;
    d       : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);
    q       : out std_logic_vector(REGISTER_WIDTH-1 downto 0));
end reg;

architecture rtl of reg is
begin
  process(clk)
  begin
    if (clk'event and clk='1') then
      q <= d;
    end if;
  end process;
end rtl;