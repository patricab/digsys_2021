library ieee;
use ieee.std_logic_1164.all;
use work.rsa.all;

entity Montgomery is
	generic (
		WORD_SIZE : integer := 256
	);
	port (
		--input control
		valid_in                : in  std_logic;
		ready_in                : out std_logic;

		--input data
		message, key, modulus, r: in  std_logic_vector(WORD_SIZE-1 downto 0);

		--ouput control
		ready_out               : in  std_logic;
		valid_out               : out std_logic;

		--output data
		result                  : out std_logic_vector(WORD_SIZE-1 downto 0);

		--utility
		clk, reset_n            : in  std_logic
	);
end Montgomery;



architecture expBehave of Montgomery is
begin
	result <= message xor modulus;
	ready_in <= ready_out;
	valid_out <= valid_in;
end expBehave;



architecture behavioral of Montgomery is

	signal M, x : unsigned(WORD_SIZE-1 downto 0);

	function MonPro(a, b) return unsigned(WORD_SIZE-1 downto 0) is
		variable t_reg, m_reg, u_reg : unsigned(WORD_SIZE-1 downto 0) := 0;
	begin
		t_reg := a * b;
		m_reg := t_reg * ñ mod r;
		u_reg := (t_reg + m_reg * n) / r;
		if u_reg >= n then
			u_reg := u_reg - n;
		end if ;
		return u_reg;
	end function;

begin



	exponentiation : process( clk, reset_n )
	begin
		if( reset_n = '0' ) then
			reset;
		elsif( rising_edge(clk) ) then
			M = message * r mod n;
			x = 1 * r mod n;
			exp : for i in 0 to WORD_SIZE-1 loop
				x = MonPro(x, x);
				if (e(i) == '1') then
					x = MonPro(M, x);
			end loop ; -- exp
			x = MonPro(x, 1);
		end if;
	end process; -- exponentiation



end architecture;



architecture Montgomery_rtl of Montgomery is

	component MonPro is
		generic (
			WORD_SIZE: integer := 256
		);
		port (
			a, b, ñ, n, r           : in  unsigned(WORD_SIZE-1 downto 0);

			u                       : out unsigned(WORD_SIZE-1 downto 0);

			clk, reset_n            : in  std_logic
		);
	end component;

	signal state : states;

	signal test_reg : type := '0'; -- initialize if self clearing.

	signal m_reg, x_reg    : unsigned(WORD_SIZE-1 downto 0) := 0;

begin

	FSM_FF : process(clk)
	begin
		if rst = '0' then
			state <= RESET;
		elsif rising_edge(clk) then

			case state is

				when RSET => if rst = '1' then state <= IDLE; end if;

				when IDLE =>

				when PREP =>

				when CALC =>

				when FLIP =>

				when FNSH =>

				when others =>

			end case;
		end if;
	end process;

	FSM_COMB : process(all)
	begin
		case state is

			when RSET =>

			when IDLE =>

			when PREP =>
				m_reg := message * r mod modulus;
				x_reg :=       1 * r mod modulus;

			when CALC =>

			when FLIP =>

			when FNSH =>

			when others =>

		end case;

	end process;

	MonPro_in_mux: mux
		port map (
			input => x, m_reg, 1,
			sel
			output => a
		)
	;


	Mult: MonPro
			port map (
				a   => a,
				b   => x,

				ñ   => ,
				n   => modulus,
				r   => ,

				u   => x,

				clk => clk,
				rst => reset_n
			)

end architecture;
