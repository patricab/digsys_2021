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

		-- utility
		clk, reset_n	: in STD_LOGIC
	);
end exponentiation;



architecture rl_binary_rtl of exponentiation is

	type state_t is (reset, idle, start, calc, fnsh);
	signal state, nxt_state : state_t;

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
			num : natural := 32;
			bit : natural :=  1
		);
		port (
			input  : in slv_array_t(0 to num-1)(bit-1 downto 0);
			sel    : in  natural range 0 to num-1;
			output : out std_logic_vector(bit-1 downto 0)
		);
	end component;

	component mod_mult
		generic (C_block_size : integer := 256);
		port (
			clk, reset_n : in  std_logic;
			a, b, n      : in  std_logic_vector(C_block_size-1 downto 0);
			p            : out std_logic_vector(C_block_size-1 downto 0);
			enable       : in  std_logic;
			skip         : in std_logic;
			valid        : out std_logic
		);
	end component;

	-- shared variable log_size : integer := 8;
	-- log_size := to_integer(log2(real(C_block_size)));

	signal key_array : slv_array_t(0 to C_block_size-1)(0 downto 0);

	signal skip_v  : std_logic_vector(0 downto 0);
	signal skip, enable : std_logic;
	signal cnt : unsigned(7 downto 0);
	signal c, c_d, p, p_d : std_logic_vector(C_block_size-1 downto 0);
	signal c_en, p_en : std_logic;

begin

	skip <= skip_v(0);

	key_gen : for i in 0 to C_block_size-1 generate
		key_array(i) <= key(i downto i);
	end generate; -- key_gen

	main : process(all)
	begin
		if( rising_edge(clk) ) then
			case( state ) is
				when reset =>
					c <= (others => '0');
					p <= (others => '0');
					enable    <= '0';
					ready_in  <= '0';
					valid_out <= '0';

				when idle  =>
					enable    <= '0';
					ready_in  <= '1';
					valid_out <= '0';
					p <= message;
					c <= (0 => '1', others => '0');

				when calc  =>
					enable    <= '1';
					ready_in  <= '0';
					valid_out <= '0';

				when fnsh  =>
					enable    <= '0';
					ready_in  <= '1';
					valid_out <= '1';

				when others =>
					enable    <= '0';
					ready_in  <= '0';
					valid_out <= '0';
			end case ;

			if (c_en = '1') then
				c <= c_d;
			end if;
			if (p_en = '1') then
				p <= p_d;
			end if;

		end if;
	end process; -- main


	state_trans : process( clk, reset_n )
	begin
		if( reset_n = '0' ) then
			state <= reset;
			nxt_state <= idle;
		elsif( rising_edge(clk) ) then
			case( state ) is
				when reset =>
					nxt_state <= idle;

				when idle  =>
					if (valid_in = '1') then
						nxt_state <= calc;
					else
						nxt_state <= idle;
					end if ;

				-- when start =>
				-- 	nxt_state <= calc;

				when calc  =>
					if (cnt = 0) then
						nxt_state <= fnsh;
					else
						nxt_state <= calc;
					end if ;

				when fnsh  =>
					if (ready_out = '1') then
						nxt_state <= idle;
					else
						nxt_state <= fnsh;
					end if ;

				when others =>
						state <= reset;
						nxt_state <= idle;
			end case ;

			state <= nxt_state;

		end if ;
	end process ; -- state_trans



	key_sel_counter: entity work.counter(down)
		generic map (bit => 8) -- log_size
		port map (
			clk => clk and p_en,
			rst => reset_n,
			en  => enable,
			val => cnt
		);

	key_mux: mux
		generic map (
			num => C_block_size,
			bit => 1
		)
		port map (
			input  => key_array,
			sel    => to_integer(cnt),
			output => skip_v
		);

	C_mult: mod_mult
		generic map (C_block_size => C_block_size)
		port map (
			clk     => clk,
			reset_n => reset_n,
			n       => modulus,
			a       => c,
			b       => p,
			enable  => enable,
			skip    => skip,
			valid   => c_en,
			p       => c_d
		);

	P_mult: mod_mult
		generic map (C_block_size => C_block_size)
		port map (
			clk     => clk,
			reset_n => reset_n,
			n       => modulus,
			a       => p,
			b       => p,
			enable  => enable,
			skip    => '0',
			valid   => p_en,
			p       => p_d
		);

end architecture;
