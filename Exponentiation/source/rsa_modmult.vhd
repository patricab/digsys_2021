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
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------------------------
entity mod_mult is
    generic (
        C_Block_size: integer := 256
    );
    port (
    -- input data
        a, b, n : in  std_logic_vector(C_Block_size-1 downto 0);
    -- output result
        p       : out std_logic_vector(C_Block_size-1 downto 0);
    -- utility
        clk     : in  std_logic;
        reset_n : in  std_logic;
    -- control
        ready   : in  std_logic;
        valid   : out std_logic
    );


end mod_mult;
--------------------------------------------------------------------------------
architecture behavioral of mod_mult is
-- signal declaration:
    signal counter: std_logic_vector(C_Block_size-1 downto 0);

begin

-- modmult structure:
process(all)
    variable par_temp, p_1 : std_logic_vector(C_Block_size-1 downto 0);
begin
    if(reset_n = '0') then
        par_temp := (others => '0');
        p_1      := (others => '0');
        valid <= '0';
    end if;
    if(ready = '1' and rising_edge(clk)) then
        if(counter >= C_Block_size) then
            valid <= '1';
        else
            for i in 0 to C_Block_size-1 loop
            ---------- Left shift ----------
            p_1 := (p_1(C_Block_size-2 downto 0) & '0');
            --------------------------------
            -- Partial product generation --

            if(b(i) = '1') then
                par_temp := a;
            else
                par_temp := (others => '0');
            end if;

            --------------------------------
            ----------- Addition -----------
            p_1 := p_1 + par_temp;
            --------------------------------
            ---------- substaction ---------
            if(p_1 >= n) then
                p_1 := p_1 - n;
            end if;
            if(p_1 >= n) then
                p_1 := p_1 - n;
            end if;
            --------------------------------
            end loop;
            counter <= counter + 1;
        end if;
    end if;
    p <= p_1(C_Block_size-1 downto 0);
end process;

end behavioral;
--------------------------------------------------------------------------------
