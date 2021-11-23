-- Main entity for control block
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.slv_arr_p.all;

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

		state : out state_t; -- remove after test

		key_e_d      :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		key_n        :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		rsa_status   : out std_logic_vector(31 downto 0)
	);
end entity rsa_control;

architecture structural of rsa_control is

	constant CORES     : natural := 1;
	constant LOG_CORES : natural := 1;

	signal or_y, d_i, sr_en, sr_i, rst_cnt, ready : std_logic;
	signal cnt                       : unsigned(LOG_CORES-1 downto 0);

	signal rl_data  	: std_logic_vector(C_BLOCK_SIZE-1 downto 0);
	signal rl_ready 	: std_logic_vector(CORES-1 downto 0);
	signal rl_valid 	: std_logic_vector(CORES-1 downto 0);
	signal ready_in 	: std_logic_vector(CORES-1 downto 0);
	signal ready_out	: std_logic_vector(CORES-1 downto 0);

	-- signal rl_valid_array : slv_array_t(0 to CORES-1)(0 downto 0);

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

			state : out state_t;

			clk, reset_n	: in  STD_LOGIC
		);
	end component;

	component or_n is
		generic (
			REGISTER_WIDTH : natural := 2);
		 port (
			x : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);
			y : out std_logic);
	end component;

begin

	-- last : process( msgin_ready, msgout_valid )
	-- begin
	-- 	if (reset_n = '0') then
	-- 		counter <= (others => '0');
	-- 	elsif rising_edge(msgin_ready) then
	-- 		counter <= counter + 1;
	-- 	else if rising_edge(msgout_valid) then
	-- 		counter <= counter - 1;
	-- 	end if;
	-- end process ; -- last

	msgout_last <= '0';
	--  msgin_last;
	rsa_status  <= (others => '0');

	-- sr_i <= msgin_valid and msgin_ready;

	rst_cnt <= reset_n; -- must reset at CORES!
-- only exp 2 and 8 are not idle

	-- valid_sel_counter : entity work.counter(up)
	-- 	generic map (
	-- 		bit => LOG_CORES
	-- 	)
	-- 	port map (
	-- 		clk => not clk,
	-- 		rst => rst_cnt,
	-- 		en  => msgin_valid,
	-- 		val => cnt
	-- 	);

	-- valid_sel_demux : entity work.demux(rtl)
	-- 	generic map (
	-- 		num => CORES
	-- 		-- bit => 1
	-- 	)
	-- 	port map (
	-- 		input => msgin_valid,	-- sr_i,
	-- 		sel   => to_integer(cnt(LOG_CORES-1 downto 0)),
	-- 		output => rl_valid -- _array
	-- 	);

		rl_valid(0) <= msgin_valid; -- remove later
		ready_out(0) <= msgout_ready;

		-- ready_out(0) <= msgout_ready and rl_ready(0);

	-- sr_CORES: entity work.shift_register(rtl)
	-- 	generic map (
	-- 		REGISTER_WIDTH => CORES)
	-- 	port map (
	-- 		clk => clk,
	-- 		rst => sr_i,
	-- 		d   => sr_i,
	-- 		q   => rl_valid);

	readyin_OR_n : or_n
		generic map (
			REGISTER_WIDTH => CORES)
		port map(
			x => ready_in,
			y => msgin_ready);

	-- ready_OR_n: or_n
	-- 	generic map (
	-- 		REGISTER_WIDTH => CORES)
	-- 	port map(
	-- 		x => rl_ready,
	-- 		y => or_y);

	-- d_i <= or_y and msgout_ready; -- fix valid
	-- DFF: entity work.dff_clr(rtl)
	-- 	port map (
	-- 		clk     => clk,
	-- 		reset_n => reset_n,
	-- 		d       => d_i,
	-- 		q       => msgout_valid);

	sr_en <= d_i and msgout_valid;

	msgout_data <= rl_data;

	-- sr_256: entity work.shift_register_256(rtl)
	-- 	port map (
	-- 		clk => clk,
	-- 		rst => reset_n,
	-- 		en  => sr_en,
	-- 		d   => rl_data,
	-- 		q   => msgout_data);

	exp_gen : for i in 0 to CORES-1 generate
		element: Exponentiation
			generic map (
				C_BLOCK_SIZE => C_BLOCK_SIZE
			)
			port map (
				clk       => clk,
				reset_n   => reset_n,

				message   => msgin_data,
				key       => key_e_d,
				modulus   => key_n,

				valid_in  => rl_valid(i),
				ready_in  => ready_in(i),
				ready_out => msgout_ready, -- ready_out(i),
				valid_out => msgout_valid, -- rl_ready(i),

				state     => state,

				result    => rl_data
			);
	end generate;

end architecture structural;
