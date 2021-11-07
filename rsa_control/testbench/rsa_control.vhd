--this is an instantiated file
library ieee;
use ieee.std_logic_1164.all;

entity rsa_control_tb is
	generic (
		somegeneric : integer := 256
	);
end rsa_control_tb;


architecture behaviour of rsa_control_tb is
	signal data_in : std_logic;
	signal data_out : std_logic;
begin
	i_rsa_control : entity work.rsa_control
		generic map (
			somegeneric => somegeneric
		)
		port map (
			data_in  => data_in,
			data_out => data_out
		);
end behaviour;