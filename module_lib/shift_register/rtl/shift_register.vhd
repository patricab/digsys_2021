-- *****************************************************************************
-- Name:     shift_register.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Positive edge triggered shift register with asynchronous reset,
--           active low. Shift in MSB first.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_register is
  generic (
    REGISTER_WIDTH : natural := 8);
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;
    d       : in  std_logic;
    q       : out std_logic_vector(REGISTER_WIDTH-1 downto 0));
end shift_register;

architecture rtl of shift_register is
  signal q_i : std_logic_vector(REGISTER_WIDTH-1 downto 0);
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