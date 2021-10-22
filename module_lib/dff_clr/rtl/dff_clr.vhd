-- *****************************************************************************
-- Name:     dff_clr.vhd   
-- Created:  13.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Single positive edge triggered flip flop with synchronous reset.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dff_clr is
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;
    d       : in  std_logic;
    q       : out std_logic);
end dff_clr;

architecture rtl of dff_clr is
begin
  process(clk, reset_n)
  begin
    if (clk'event and clk='1') then
      if(reset_n = '0') then
        q <= '0';
      else
        q <= d;
      end if;
    end if;
  end process;
end rtl;