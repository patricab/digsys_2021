-- *****************************************************************************
-- Name:     arraypackage.vhd   
-- Created:  13.03.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Package to allow array as an input type.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;

package arraypackage is
  type slv16_array is array (natural range <>) of std_logic_vector(15 downto 0);
end arraypackage;

package body arraypackage is
end package body arraypackage;