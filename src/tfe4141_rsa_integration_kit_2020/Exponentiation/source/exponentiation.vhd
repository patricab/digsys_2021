library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity exponentiation is
	generic (
		C_block_size : integer := 256
	);
	port (
		-- input control
		valid_in		: in  STD_LOGIC;
		ready_in		: out STD_LOGIC;

		-- input data
		message 		: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0 );
		key 			: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0 );

		-- ouput control
		ready_out	: in  STD_LOGIC;
		valid_out	: out STD_LOGIC;

		-- output data
		result		: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		-- modulus
		modulus 		: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		-- utility
		clk 			: in STD_LOGIC;
		reset_n 		: in STD_LOGIC
	);
end exponentiation;


architecture expBehave of exponentiation is
begin
	result <= message xor modulus;
	ready_in <= ready_out;
	valid_out <= valid_in;
end expBehave;



architecture rl_binary_rtl of exponentiation is

	variable log_size : integer := log2(C_block_size);

	signal start, en : std_logic;

	signal cnt : std_logic_vector(8 downto 0);
	signal c, c_d, c_q, p, p_d, p_q : std_logic_vector(C_block_size-1 downto 0);
	signal c_en, p_en : std_logic;

begin

	ready_in <= cnt(log_size);
	start <= ready_in and valid_in;

	main : process( clk, reset_n )
	begin
		if( reset_n = '0' ) then
			c <= 0;
			p <= 0;
		elsif( rising_edge(clk) ) then
			if c_en then
				c <= c_d;
			end if;
			if p_en then
				p <= p_d;
			end if;
		end if; then
	end process; -- main

	key_sel_counter: entity work.counter(rtl)
	generic map (bit => log_size + 1);
	port map(
		clk  => clk,
		!rst => reset_n,
		en   => start,
		val  => cnt;
	);

	key_mux: entity work.mux(rtl)
	generic map (C_block_size => bit);
	port map (
		input  => key,
		sel    => cnt,
		output => en
	);

	mod_mult: entity work.mod_mult(blakeley)
	generic map (C_block_size => C_block_size);
	port map (
		clk     => clk,
		reset_n => reset_n,
		n       => modulus,
		a       => c_q,
		b       => p_q,
		valid   => c_en,
		c       => c_d
	);

	mod_mult: entity work.mod_mult(blakeley)
	generic map (C_block_size => C_block_size);
	port map (
		clk     => clk,
		reset_n => reset_n,
		n       => modulus,
		a       => p_q,
		b       => p_q,
		valid   => p_en,
		c       => p_d
	);

end architecture;



architecture mary_rtl of exponentiation is

	constant r : integer := 4;
	constant s : integer := C_block_size / r;
	constant log_size : integer := log2(s);

	signal start, en : std_logic;

	signal m is array of std_logic_vector(C_block_size-1 downto 0);

	signal f : std_logic_vector(r-1 downto 0);

	signal mf : std_logic_vector(C_BLOCK_SIZE-1 downto 0);

	signal cnt : std_logic_vector(log_size downto 0);
	signal c, c_d, c_q : std_logic_vector(C_block_size-1 downto 0);
	signal c_en : std_logic;

begin

	ready_in <= cnt(log_size);
	start <= ready_in and valid_in;

	main : process( clk, reset_n )
	begin
		if( reset_n = '0' ) then
			c <= 0;
		elsif( rising_edge(clk) ) then
			if c_en then
				c <= c_d;
			end if;
		end if;
	end process; -- main

	m_reg_demux : entity work.demux(rtl)
	generic map (
		inbit  => C_block_size,
		selbit => (1 sll r),
		outbit => C_block_size * (1 sll r)
	);
	port map (
		input  => c,
		sel    => ,
		output => m
	);

	c_sel_mux: entity work.mux(rtl)
	generic map (
		inbit  => C_block_size * 2,
		selbit => 1,
		outbit => C_block_size
	);
	port map (
		input  => (mf, c),
		sel    => ,
		output => c_d
	);

	key_sel_counter: entity work.counter(rtl)
	generic map (
		bit => log_size -- 64 => 6bit
	);
	port map(
		clk  => clk,
		!rst => reset_n,
		en   => start,
		val  => cnt;
	);

	mod_mult_inp_sel_Counter: entity work.counter(rtl)
	generic map (
		bit => log2(r) + 1 -- 4 => 2bit +1
	);
	port map(
		clk  => clk,
		!rst => reset_n,
		en   => start,
		val  => cnt;
	);

	key_mux: entity work.mux(rtl)
	generic map (
		inbit  => C_block_size,
		selbit => s,
		outbit => r
	);
	port map (
		input  => key,
		sel    => cnt,
		output => f
	);

	key_mux2: entity work.mux(rtl)
	generic map (
		inbit => C_block_size * (1 sll r),
		selbit => r,
		outbit => C_block_size
	);
	port map (
		input => m,
		sel   => f,
		output => mf
	)

	mod_mult: entity work.mod_mult(blakeley)
	generic map (
		C_block_size => C_block_size
	);
	port map (
		clk     => clk,
		reset_n => reset_n,
		n       => modulus,
		a       => c_q,
		b       => mux_out,
		valid   => c_en,
		c       => c
	);

end architecture;



architecture mary_behave of exponentiation is

	-- signal
	function modmult(a, b, n : in unsigned(C_block_size-1 downto 0))
	return unsigned(C_block_size-1 downto 0) is
		variable p : unsigned(C_block_size-1 downto 0) := (others => '0');
	begin
		loop : for i in 0 to C_block_size-1 loop
			p := 2 * p + a * unsigned(b(i));
			if p >= n then
				p = p - n;
				if p >= n then
					p = p - n;
				end if;
			end if;
		end loop; -- loop
		return p;
	end function;

begin


	mary : process(clk, reset_n, ready_in, ready_out) is
	variable C : unsigned(C_block_size-1 downto 0);
	constant R : integer := 2; -- group size
	constant S : integer := C_block_size / R; -- number of groups

	type exps is array (0 to R**2)
	of unsigned(C_block_size-1 downto 0);

	variable M : exps := (unsigned(1), unsigned(message));

	type key_groups is array (0 to S-1)
	of unsigned(R-1 downto 0);

	variable F : key_groups;

	begin
		if (reset_n = '0') then
			-- reset
		elsif risingedge(clk) then
			-- Calculate all M^w
			precalc : for w in 2 to R**2-1 loop
				M(w) := modmult(M(w-1), message, modulus);
				end loop; -- precalc

			-- Split key into R sized chunks
			keytoF : for k in 0 to S-1 loop
				F(k) := (unsigned(key(R*k to R*k+R-1)));
			end loop; -- keytoF

			C := M(F(S-1));
			-- Do modular exponentiation
			main : for i in S-2 downto 0 loop
				for j in 0 to R loop
					C := modmult(C, C, modulus);
				end loop; -- 4a
				if (F(i) /= 0) then
					C := modmult(C, M(F(i)), modulus);
				end if; -- 4b
			end loop; -- main
		end if;
	end process; -- mary

end architecture;


-- State machine

-- state machine : process( clock )
-- begin
-- 	if( rising_edge(clock) ) then

-- 	end if ;
-- end process ; -- state machine

-- cur_state := IDLE;
-- nxt_state <= RESET;

-- IDLE -- wait for ready valid reset signal
-- RESET -- reset
-- PRECALC -- find M[w]
-- CALC	-- calculate
