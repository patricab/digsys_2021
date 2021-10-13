library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
	port (
		clk, reset_n    : in  std_logic;
	-- modexp control I/O
		input_reg_en    : out std_logic;
		output_reg_en   : out std_logic;
		output_reg_load : out std_logic;
	-- RSA reg I/O
		rsa_status      : out std_logic_vector(31 downto 0);
	-- RSA message in
		msgin_valid     : in  std_logic;
		msgin_ready     : out std_logic;
		msgin_last      : in  std_logic;
	-- RSA message out
		msgout_valid    : out std_logic;
		msgout_ready    : in  std_logic;
		msgout_last     : out std_logic
	);
end control;

architecture rtl of control is

	signal msgin_ready_i  std_logic;
	signal input_reg_en_i std_logic;

begin

	msgin_ready_i   <= msgout_ready;
	msgin_ready     <= msgin_ready_i;
	input_reg_en_i  <= msgin_ready_i  and msgin_valid;
	input_reg_en    <= input_reg_en_i;


	output_reg_en <= msgout_ready and msgout_valid;




end architecture;