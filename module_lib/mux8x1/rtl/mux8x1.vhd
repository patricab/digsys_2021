-- *****************************************************************************
-- Name:     mux8x1.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  An eight input mux with an input bit width of 1.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux8x1 is
  port (
    a   : in  std_logic;
    b   : in  std_logic;
    c   : in  std_logic;
    d   : in  std_logic;
    e   : in  std_logic;
    f   : in  std_logic;
    g   : in  std_logic;
    h   : in  std_logic;
    sel : in  std_logic_vector(2 downto 0);
    y   : out std_logic);
end mux8x1;

architecture rtl of mux8x1 is
begin
  y <= a when sel="000" else
       b when sel="001" else
       c when sel="010" else
       d when sel="011" else
       e when sel="100" else
       f when sel="101" else
       g when sel="110" else
       h;
end rtl;