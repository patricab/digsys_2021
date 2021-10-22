--------------------------------------------------------------------------------
-- Modular Multiplier
--
-- Description:
-- - High speed modular multiplier module for RSA Cryptography based on Blakley
-- - algorithm. 
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
        BLOCK_SIZE: integer := 256
    );
    port (
        b: in std_logic_vector(BLOCK_SIZE-1 downto 0);
        a: in std_logic_vector(BLOCK_SIZE-1 downto 0);
        n: in std_logic_vector(BLOCK_SIZE-1 downto 0);

        p: out std_logic_vector(BLOCK_SIZE-1 downto 0)
        
        clk: in std_logic;
        overflow: out std_logic);

end modmult;
--------------------------------------------------------------------------------
architecture modmult_arch of modmult is
-- signal declaration:

begin
    -- modmult structure:
    p <= 


end modmult_arch;
--------------------------------------------------------------------------------