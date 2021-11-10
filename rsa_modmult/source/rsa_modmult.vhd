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
entity rsa_modmult is
    generic (
        C_Block_size: integer := 256
    );
    port (

        b: in std_logic_vector(C_Block_size-1 downto 0);
        a: in std_logic_vector(C_Block_size-1 downto 0);
        n: in std_logic_vector(C_Block_size-1 downto 0);

        p: out std_logic_vector(C_Block_size-1 downto 0);
        
        clk: in std_logic;
        reset_n: in std_logic;
        overflow: inout std_logic);

end rsa_modmult;
--------------------------------------------------------------------------------
architecture modmult_arch of rsa_modmult is
-- signal declaration:


signal counter: unsigned(C_Block_size-1 downto 0);


begin

-- modmult structure:
process(clk,a,n,b,reset_n) 
        variable par_temp : std_logic_vector(C_Block_size-1 downto 0);
        variable p_1: std_logic_vector(C_Block_size downto 0);
    begin   
        if(reset_n = '0') then
            par_temp := (others => '0');
            p_1 := (others => '0');
            overflow <= '0';
            counter <= (others =>'0');
        end if;
        if(overflow = '0' and rising_edge(clk)) then
            if(counter = C_Block_size + 1) then
                overflow <= '1';
            else
                ---------- Left shift ----------
                p_1 := (p_1(C_Block_size-1 downto 0) & "0");
                --------------------------------
                -- Partial product generation --
                    if(b(C_Block_size-1-to_integer(counter)) = '1')then
                        par_temp := a;
                    else
                        par_temp := (others => '0');
                    end if;            
                   
                --------------------------------
                ----------- Addition -----------
                p_1 := p_1 +("0" + par_temp);
                --------------------------------
                ---------- substaction ---------
                if(p_1 >= n) then
                    p_1 := p_1 - ("0" + n);
                end if;
                if(p_1 >= n) then
                    p_1 := p_1 - ("0" + n);
                end if;
                --------------------------------
                counter <= counter + 1;
                
        end if;
        end if;
        p <= p_1(C_Block_size-1 downto 0);
end process;
                
end modmult_arch;
--------------------------------------------------------------------------------