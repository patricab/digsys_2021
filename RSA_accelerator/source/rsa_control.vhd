-- Main entity for control block
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.state_p.all;
use work.sr_defines.all;

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

		key_e_d      : in  std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		key_n        : in  std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		rsa_status   : out std_logic_vector(31 downto 0)
	);
end entity rsa_control;

architecture structural of rsa_control is

	constant CORES     : natural := 16;
	constant LOG_CORES : natural := 4;

	signal state                        : piso_t;

	signal or_y, sr_en, sr_i, rst_cnt   : std_logic;
	signal d_valid, d_last, ready, piso : std_logic;
	signal cnt                          : unsigned(LOG_CORES-1 downto 0);
	signal piso_cnt                     : unsigned(7 downto 0);

	signal rl_data  	                  : SR;
	signal rl_valid_out, rl_valid_in    : std_logic_vector(CORES-1 downto 0);
	signal ready_in, ready_out       	: std_logic_vector(CORES-1 downto 0);
	signal rl_last	                     : std_logic_vector(CORES-1 downto 0);

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
			msgin_last     : in  STD_LOGIC;
			msgout_last    : out STD_LOGIC;
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

	rsa_status  <= (others => '0');

	rst_cnt <= reset_n;
-- only exp 2 and 8 are not idle

	valid_sel_counter : entity work.counter(up)
		generic map (
			bit => LOG_CORES
		)
		port map (
			clk => not clk,
			rst => rst_cnt,
			en  => msgin_valid,
			val => cnt
		);

	valid_sel_demux : entity work.demux(rtl)
		generic map (
			num => CORES
		)
		port map (
			input => msgin_valid,
			sel   => to_integer(cnt(LOG_CORES-1 downto 0)),
			output => rl_valid_in
		);

	readyin_OR_n : or_n
		generic map (
			REGISTER_WIDTH => CORES)
		port map(
			x => ready_in,
			y => msgin_ready);

	PISO_STATE : process ( clk, reset_n )
	begin
		if ( reset_n = '0' ) then
			state <= input;
			piso_cnt <= (others => '0');
		elsif ( rising_edge(clk) ) then
			piso_cnt <= piso_cnt + 1;
			if ( piso_cnt(7) = '1') then
				state <= output;
			else
				state <= input;
			end if;
		end if ;
	end process ; -- PISO

	PISO_PROCESS : process( state )
	begin
		if ( state = input ) then
			sr_en <= '0';
			piso  <= '0';
		elsif ( state = output ) then
			sr_en <= msgout_ready;
			piso  <= '1';
		end if;
	end process ; -- PISO


	sr_256: entity work.shift_register_256(rtl) -- parallel input?
		port map (
			-- utility
			clk     => clk,
			rst     => reset_n,
			en      => sr_en,
			piso    => piso,
			-- parallel input
			d       => rl_data,
			d_valid => rl_valid_out,
			d_last  => rl_last,
			-- serial output
			q       => msgout_data,
			q_valid => msgout_valid,
			q_last  => msgout_last
		);

	exp_gen : for i in 0 to CORES-1 generate
		element: Exponentiation
			generic map (
				C_BLOCK_SIZE => C_BLOCK_SIZE
			)
			port map (
				clk         => clk,
				reset_n     => reset_n,

				message     => msgin_data,
				key         => key_e_d,
				modulus     => key_n,

				valid_in    => rl_valid_in(i),
				ready_in    => ready_in(i),
				ready_out   => not piso,
				valid_out   => rl_valid_out(i),

				msgin_last  => msgin_last,
				msgout_last => rl_last(i),

				result      => rl_data(i)
			);
	end generate;

end architecture structural;
