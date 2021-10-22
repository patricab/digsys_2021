-- *****************************************************************************
-- Name:     pos_edge_detector.vhd   
-- Created:  13.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  A positive edge detector. y goes high at the rising edge of x,
--           before going low at the first rising edge of the clock.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pos_edge_detector is
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;
    x       : in  std_logic;
    y       : out std_logic);
end pos_edge_detector;

architecture rtl of pos_edge_detector is
  signal x_d1 : std_logic;
begin
  process(clk, reset_n)
  begin
    if(reset_n = '0') then
      x_d1 <= '1';
    elsif (clk'event and clk='1') then
      x_d1 <= x;
    end if;
  end process;
  y <= x and (not x_d1);
end rtl;