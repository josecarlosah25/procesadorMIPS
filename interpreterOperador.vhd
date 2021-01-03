library ieee;
use ieee.std_logic_1164.all;

entity interpreterOperador is
port(
	op: in std_logic_vector(3 downto 0);
	digB: in std_logic_vector(6 downto 0);
	d7s_Uno,d7s_B: out std_logic_vector(6 downto 0);
	d_opPrincip,d_opSecund: out std_logic_vector(5 downto 0)
  );
end;

architecture behavior of interpreterOperador is
	constant suma: 	std_logic_vector(5 downto 0):="000011";
	constant resta: 	std_logic_vector(5 downto 0):="000001";
	constant opAND:	std_logic_vector(5 downto 0):="000100";
	constant opOR:    std_logic_vector(5 downto 0):="001000";
	constant opXOR:	std_logic_vector(5 downto 0):="001111";
	constant opNot:	std_logic_vector(5 downto 0):="100000";
	constant uno:		std_logic_vector(6 downto 0):="0000110";
	constant offUno:	std_logic_vector(6 downto 0):="0000000";
	constant off:		std_logic_vector(5 downto 0):="000000";

begin

with op select 
		d_opPrincip<= off when "0000",  -- signo operacion
		suma when "1000",
		suma when "0001",
		suma when "1001",
		resta when "0010",
		resta when "1010",
		suma when "0011",
		suma when "1011",
		opAND when "0100",
		opAND when "1100",
		opOR when "0101",
		opOR when "1101",
		opXOR when "0110",
		opXOR when "1110",
		opNot when "1111",
		opNot when "0111",
		off when others;
		
with op select
		d_opSecund <= suma when "1001",  -- signo secundario operacion
		resta when "0010",
		suma when "1011",
		off when others;

with op select
		d7s_Uno <= uno when "1001",  -- simbolo  1 de operacion 
		uno when "1011",
		uno when "0010",
		offUno when others;

		
with op select
		d7s_B <= "1111000" when "0011",  -- Disntitos casos de B
		"1111000" when "1011",
		not uno when "1000",
		"1111111" when "0000",
		"1111111" when "1111",
		"1111111" when "0111",
		digB when others;
																			
end behavior;