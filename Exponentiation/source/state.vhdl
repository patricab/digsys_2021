library ieee;
use ieee.std_logic_1164.all;

package state_p is
	-- type slv_array_t is array (natural range <>) of std_logic_vector;
	type state_t is (reset, idle, calc, fnsh);
   type piso_t is (input, lock, output);
end package;
