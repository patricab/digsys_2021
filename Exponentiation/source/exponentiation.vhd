library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.slv_arr_p.all;

entity exponentiation is
	generic (
		C_block_size : integer := 256
	);
	port (
		-- input control
		valid_in    	: in  STD_LOGIC;
		ready_in    	: out STD_LOGIC;

		-- input data
		message, key	: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		-- ouput control
		ready_out   	: in  STD_LOGIC;
		valid_out   	: out STD_LOGIC;

		-- output data
		result      	: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		-- modulus
		modulus     	: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		state : out state_t;

		-- utility
		clk, reset_n	: in STD_LOGIC
	);
end exponentiation;



architecture rl_binary_rtl of exponentiation is

	constant log_size : integer := 8;

	component counter
		generic (bit : integer := 8);
		port (
			clk	: in 	std_logic;
			rst	: in 	std_logic;
			en 	: in 	std_logic;
			val	: out	unsigned(bit-1 downto 0)
		);
	end component;

	component mux
		generic (
			num : natural := 32
		);
		port (
			input  : in  std_logic_vector(num-1 downto 0);
			sel    : in  natural range 0 to num-1;
			output : out std_logic
		);
	end component;

	component mod_mult
		generic (C_block_size : integer := 256);
		port (
			clk, reset_n : in  std_logic;
			a, b, n      : in  std_logic_vector(C_block_size-1 downto 0);
			p            : out std_logic_vector(C_block_size-1 downto 0);
			enable       : in  std_logic;
			run          : in  std_logic;
			valid        : out std_logic
		);
	end component;

	-- signal state : state_t;

	signal run_v, first           : std_logic;
	signal cnt                 	: unsigned(log_size downto 0);
	signal run, enable, rst_cnt	: std_logic;
	signal c_en, p_en          	: std_logic;
	signal c, p, p_d, c_d      	: std_logic_vector(C_block_size-1 downto 0);

begin

	main : process(all)
	begin
		case( state ) is
			when reset =>
				c         <= (others => '0');
				p         <= (others => '0');
				result    <= (others => 'Z');
				enable    <= '0';
				ready_in  <= '0';
				valid_out <= '0';
				rst_cnt   <= '0';
				first     <= '1';

			when idle  =>
				if (valid_in = '1' and first = '1') then
					p      <= message;
					c      <= (0 => '1', others => '0');
				end if;
				ready_in  <= '1';
				result    <= (others => 'Z');
				enable    <= '0';
				valid_out <= '0';
				rst_cnt   <= '1';

			when calc  =>
				result    <= (others => 'Z');
				enable    <= '1';
				ready_in  <= '0';
				valid_out <= '0';
				rst_cnt   <= '1';

				if (cnt(log_size) = '0') then
					run <= run_v;
				else
					run <= '0';
				end if;

				if (c_en = '1') then
					c <= c_d;
				end if;
				if (p_en = '1') then
					p <= p_d;
				end if;

			when fnsh  =>
				result    <= c_d;
				enable    <= '0';
				ready_in  <= '0';
				valid_out <= '1';
				rst_cnt   <= '1';

			when others =>
				result    <= (others => 'Z');
				enable    <= '0';
				ready_in  <= '0';
				valid_out <= '0';
				rst_cnt   <= '1';
		end case ;
	end process; -- main


	state_trans : process( clk, reset_n )
	begin
		if( reset_n = '0' ) then
			state <= reset;
		elsif( rising_edge(clk) ) then
			case( state ) is
				when reset =>
					state <= idle;

				when idle  =>
					if (valid_in = '1') then
						state <= calc;
					end if;

				when calc  =>
					if (cnt(log_size) = '1') then
						state <= fnsh;
					end if;

				when fnsh  =>
					if (ready_out = '1') then
						state <= reset;
					end if;

				when others =>
					state <= reset;
			end case ;
		end if ;
	end process ; -- state_trans



	key_sel_counter: entity work.counter(up)
		generic map (bit => log_size+1) -- log_size
		port map (
			clk => p_en,
			rst => rst_cnt,
			en  => enable,
			val => cnt
		);

	key_mux: mux
		generic map (
			num => C_block_size
			-- bit => 1
		)
		port map (
			input  => key, --_array,
			sel    => to_integer(cnt(log_size-1 downto 0)),
			output => run_v
		);

	C_mult: mod_mult
		generic map (C_block_size => C_block_size)
		port map (
			clk     => clk,
			reset_n => rst_cnt,
			n       => modulus,
			a       => c,
			b       => p,
			enable  => enable,
			run     => run,
			valid   => c_en,
			p       => c_d
		);

	P_mult: mod_mult
		generic map (C_block_size => C_block_size)
		port map (
			clk     => clk,
			reset_n => rst_cnt,
			n       => modulus,
			a       => p,
			b       => p,
			enable  => enable,
			run     => '1',
			valid   => p_en,
			p       => p_d
		);

end architecture;
