-- *****************************************************************************
-- Name:     dff_reset_n.vhd   
-- Created:  13.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Single positive edge triggered flip flop with asynchronous reset,
--           active low.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dff_reset_n is
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;
    d       : in  std_logic;
    q       : out std_logic);
end dff_reset_n;

architecture rtl of dff_reset_n is
begin
  process(clk, reset_n)
  begin
    if(reset_n = '0') then
      q <= '0';
    elsif (clk'event and clk='1') then
      q <= d;
    end if;
  end process;
end rtl;