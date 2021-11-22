-- Main entity for control block
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rsa_control is
	generic (
		-- Users to add parameters here
		C_BLOCK_SIZE : integer := 256
	);
	port (
		-- Tick-tock, on the clock
		clk          : in std_logic;
		reset_n      : in std_logic;

		-- Message that will be sent out is valid
		msgin_valid  : in std_logic;
		-- Slave ready to accept a new message
		msgin_ready  : out std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgin_data   : in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgin_last   : in std_logic;

		-- Message that will be sent out is valid
		msgout_valid : out std_logic;
		-- Slave ready to accept a new message
		msgout_ready : in std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgout_data  : out std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgout_last  : out std_logic;

		key_e_d      :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		key_n        :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		rsa_status   : out std_logic_vector(31 downto 0)
	);
end entity rsa_control;

architecture structural of rsa_control is

	signal sr_i, or_y, d_i, sr_en : std_logic;

	signal rl_data  	: std_logic_vector(255 downto 0);
	signal rl_ready 	: std_logic_vector( 47 downto 0);
	signal rl_valid 	: std_logic_vector( 47 downto 0);
	signal ready_in 	: std_logic_vector( 47 downto 0);
	signal ready_out	: std_logic_vector( 47 downto 0);

	component Exponentiation is
		generic (
			C_block_size : integer := 256
		);
		port (
			valid_in    	: in  STD_LOGIC;
			ready_in    	: out STD_LOGIC;
			message, key	: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0);
			ready_out   	: in  STD_LOGIC;
			valid_out   	: out STD_LOGIC;
			result      	: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);
			modulus     	: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0);
			clk, reset_n	: in STD_LOGIC
		);
	end component;

begin

	msgout_last <= msgin_last;
	rsa_status  <= (others => '0');

	sr_i <= msgin_valid and msgin_ready;
	sr_48: entity work.shift_register(rtl)
		generic map (
			REGISTER_WIDTH => 48)
		port map (
			clk => clk,
			rst => sr_i,
			d   => sr_i,
			q   => rl_valid);

	OR_n: entity work.or_n(behavioral)
		generic map (
			REGISTER_WIDTH => 48)
		port map(
			x => rl_ready,
			y => or_y);

	d_i <= or_y and msgout_ready;
	DFF: entity work.dff_clr(rtl)
		port map (
			clk     => clk,
			reset_n => reset_n,
			d       => d_i,
			q       => msgout_valid);

	sr_en <= d_i and msgout_valid;

	sr_256: entity work.shift_register_256(rtl)
		port map (
			clk => clk,
			rst => reset_n,
			en  => sr_en,
			d   => rl_data,
			q   => msgout_data);

	exp_gen : for i in 0 to 47 generate
		element: Exponentiation
			port map (
				clk       => clk,
				reset_n   => reset_n,

				message   => msgin_data,
				key       => key_e_d,
				modulus   => key_n,

				valid_in  => rl_valid(i),
				ready_in  => ready_in(i),
				ready_out => ready_out(i),
				valid_out => rl_ready(i),
				result    => rl_data
			);
	end generate;

end architecture structural;
