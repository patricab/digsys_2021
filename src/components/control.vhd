library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
	port (
		clk : in std_logic;
		rst : in std_logic;

		-- modexp control I/O
		start : out std_logic;
		ready : in  std_logic;

		-- RSA reg I/O
		rsa_status   : out std_logic_vector(31 downto 0);

		-- RSA message in
		msgin_valid  : in  std_logic;
		msgin_ready  : out std_logic;
		msgin_last   : in  std_logic;

		-- RSA message out
		msgout_valid  : out std_logic;
		msgout_ready  : in  std_logic;
		msgout_last   : out std_logic;
	);
end control;

architecture rtl of control is

begin



end architecture;