-- *****************************************************************************
-- Name:     bit_scanner.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  A combinational bit scanner. LSB has highest priority.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bit_scanner is
  generic(
    N         : natural := 4);
  port (
    req       : in  std_logic_vector(N-1 downto 0);
    gnt       : out std_logic_vector(N-1 downto 0));
end bit_scanner;

architecture rtl_signed of bit_scanner is
begin
  gnt <= std_logic_vector(signed(req) and -signed(req));
end rtl_signed;

architecture rtl_twos_comp of bit_scanner is
begin
  gnt <= std_logic_vector(unsigned(req) and ((not unsigned(req)) + 1));
end rtl_twos_comp;

architecture rtl_sub of bit_scanner is
begin
  gnt <= std_logic_vector(unsigned(req) and not (unsigned(req) - 1));
end rtl_sub;