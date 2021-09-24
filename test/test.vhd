library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real;
use ieee.std_logic_unsigned.all;

entity top is
    port(
        a, b :in std_logic_vector(1 downto 0) := "00";
        y1, y2, y3, y4 :out std_logic_vector(3 downto 0) := "0000"
    );
end entity top;

architecture arch of top is
begin
    y1 <= a + b;
    y2 <= a * b;
    y3 <= a ** b;
    y4 <= a mod b;
end architecture arch;

