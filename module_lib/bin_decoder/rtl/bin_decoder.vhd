-- *****************************************************************************
-- Name:     bin_decoder.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  A parameterisable binary decoder.
-- Example:  INPUT_WIDTH of 2:
--           x1  x0  |  y3  y2  y1  y0
--           --------+----------------
--            0   0  |   0   0   0   1
--            0   1  |   0   0   1   0
--            1   0  |   0   1   0   0
--            1   1  |   1   0   0   0
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin_decoder is
  generic(
    INPUT_WIDTH : natural := 2);
  port (
    x           : in  std_logic_vector(INPUT_WIDTH-1 downto 0);
    y           : out std_logic_vector((INPUT_WIDTH**2)-1 downto 0));
end bin_decoder;

architecture rtl of bin_decoder is
begin
  gen : for i in y'range generate
    y(i) <= '1' when unsigned(x)=to_unsigned(i,x'length) else '0';
  end generate;
end rtl;