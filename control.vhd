library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control is
port(entB: in std_logic_vector(2 downto 0);
	  dirB: in std_logic_vector(2 downto 0);
	  selector: in std_logic_vector(1 downto 0);
	  inm: in std_logic;
	  opcode: in std_logic_vector(3 downto 0);
	  opALU: out std_logic_vector(3 downto 0);
	  outB: out std_logic_vector(2 downto 0);
	  wReg,wRam: out std_logic;
	  resALU,resRAM :in std_logic_vector(2 downto 0);
	  resOut:out std_logic_vector(2 downto 0));
end entity;

architecture behavior of control is


begin

with inm select
outB <= entB when '0',
	dirB when '1';

		

with selector select
opALU <= opcode when "01",
		"0001" when "10",
		(others =>'0') when others;

with selector&opcode select
wReg <= '1' when "100010", --"1" hace que no se pueda escribir
		'0' when others;
		
with selector&opcode select
wRam <= '0' when "100010", --"0" hace que sí se pueda escribir
		'1' when others;
		
with selector&opcode select
resOut <= resRAM when "100001",
		resALU when others; 
	

end architecture;