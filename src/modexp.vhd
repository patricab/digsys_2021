entity modexp is
  port (
      clk, reset_n : in  std_logic;
      msgin_ready  : in  std_logic;
      msgin_data   : in  std_logic_vector(255 downto 0) ;;
      msgout_data  : out std_logic_vector(255 downto 0) ;;
      msgout_ready : out std_logic
  );
end modexp;

architecture behavioral of modexp is



begin

   lr_binary : process( msgin_ready )
   variable c := 0;
   variable p := msgin_data;
   begin
      modexp : for i in 0 to 255 loop
         if key_e(-i) then
            c := modmult
         end if ;
      end loop ; -- modexp
   end process ; -- lr_binary




end architecture; -- behavioral