-- *****************************************************************************
-- Name:     priority_encoder.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  A parameterisable priority encoder.
-- Example:  OUTPUT_WIDTH of 2:
--           x3  x2  x1  x0  |  y1  y0  valid
--           ----------------+---------------
--            0   0   0   0  |   x   x      0
--            0   0   0   1  |   0   0      1
--            0   0   1   x  |   0   1      1
--            0   1   x   x  |   1   0      1
--            1   x   x   x  |   1   1      1
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity priority_encoder is
  generic(
    OUTPUT_WIDTH : natural := 2);
  port (
    x            : in  std_logic_vector(OUTPUT_WIDTH**2-1 downto 0);
    y            : out std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    valid        : out std_logic);
end priority_encoder;

architecture rtl of priority_encoder is
  function pri_encode (x: std_logic_vector) return std_logic_vector is
    variable dontcare: std_logic_vector(OUTPUT_WIDTH-1 downto 0) := (others => '-');
  begin
    for i in x'range loop
      if (x(i)='1') then
        return std_logic_vector(to_unsigned(i,OUTPUT_WIDTH));
      end if;
    end loop;
    return dontcare;
  end function;
begin
  y     <= pri_encode(x);
  valid <= or_reduce(x);
end rtl;