-- *****************************************************************************
-- Name:     dff.vhd   
-- Created:  13.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Single positive edge triggered flip flop.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dff is
  port (
    clk     : in  std_logic;
    d       : in  std_logic;
    q       : out std_logic);
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