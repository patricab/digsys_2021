library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity modmult_tb is
end modmult_tb;

architecture sim of modmult_tb is

   constant clk_hz : integer := 100e6;
   constant clk_period : time := 1 sec / clk_hz;

   signal clk : std_logic := '1';
   signal rst : std_logic := '0';

begin

   clk <= not clk after clk_period / 2;

   DUT : entity work.modmult(behavioral)
   port map (
      clk => clk,
      rst => reset_n,
      a   => a,
      b   => b,
      n   => n
   );

   SEQUENCER_PROC : process
   begin
      wait for clk_period * 2;

      rst <= '1';

      wait for clk_period * 10;

      assert false
         report "Replace this with your test cases"
         severity failure;

      finish;
   end process;

end architecture;
