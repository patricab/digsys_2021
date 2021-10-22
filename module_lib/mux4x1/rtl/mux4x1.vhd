-- *****************************************************************************
-- Name:     mux4x1.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  A four input mux with an input bit width of 1.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4x1 is
  port (
    a       : in  std_logic;
    b       : in  std_logic;
    c       : in  std_logic;
    d       : in  std_logic;
    sel     : in  std_logic_vector(1 downto 0);
    y       : out std_logic);
end mux4x1;

architecture rtl of mux4x1 is
begin
  y <= a when sel="00" else
       b when sel="01" else
       c when sel="10" else
       d;
end rtl;