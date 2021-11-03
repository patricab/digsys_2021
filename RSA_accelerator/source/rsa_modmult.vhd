--------------------------------------------------------------------------------
-- Modular Multiplier
--
-- Description:
-- - High speed modular multiplier module for RSA Cryptography based on Blakley
--   algorithm. 
--
--------------------------------------------------------------------------------
-- Author(s)    : Jacob Kristiansen
-- Organization : Norwegian University of Science and Technology (NTNU)
--                Department of Electronic Systems
--                https://www.ntnu.edu/ies
-- Course       : TFE4141 Design of digital systems 1 (DDS1)
-- Year         : 2021-2022
-- Project      : RSA accelerator
-- License      : This is free and unencumbered software released into the
--                public domain (UNLICENSE)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------------------
entity modmult is
    generic (
        C_Block_size: integer := 256
    );
    port (

        b: in std_logic_vector(C_Block_size-1 downto 0);
        a: in std_logic_vector(C_Block_size-1 downto 0);
        n: in std_logic_vector(C_Block_size-1 downto 0);

        p: out std_logic_vector(C_Block_size-1 downto 0)
        
        clk: in std_logic;
        reset_n: in std_logic;
        overflow: out std_logic);

end modmult;
--------------------------------------------------------------------------------
architecture modmult_arch of modmult is
-- signal declaration:
signal p_1: std_logic_vector(C_Block_size-1 downto 0);

signal counter: std_logic_vector(C_Block_size-1 downto 0);

begin

-- modmult structure:
modmult: process(clk,p,a,n,b,overflow,reset_n) is
    if(reset_n = '0') then
        p_1 <= (others => '0');
        overflow <= '0';
    end if;
    if(overflow = '0' and rising_edge(clk)) then
        if(counter = C_Block_size + 1) then
            overflow <= '1';
        else
            p_1 <= (p_1(C_Block_size-2 downto 0) & '0') + a * b; -- 2*p + a * b

            if(p_1 >= n) then
                p_1 <= p_1 - n;
            end if;
            if(p_1 >= n) then
                p_1 <= p_1 - n;
            end if;
            counter <= counter + 1;
    end if;
    p <= p_1(C_Block_size-1 downto 0);
end process modmult;
                
end modmult_arch;
--------------------------------------------------------------------------------