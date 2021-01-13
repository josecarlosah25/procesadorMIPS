library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_UNSIGNED.all;

entity decoder is
port(
	de_intruc: in std_logic_vector(15 downto 0);
	datosDIRA,datosDIRB: out std_logic_vector (2 downto 0);
	s: out std_logic_vector(1 downto 0);
	s2,cin: out std_logic;
	datosDIRC: out std_logic_vector (2 downto 0);
	selType: out std_logic_vector(1 downto 0);
	inmediato: out std_logic);
end decoder;

architecture behavior of decoder is

signal display: std_logic_vector(3 downto 0);
BEGIN

datosDIRC<= de_intruc(2 downto 0);--DIRECCCIONES DE C
datosDIRB<= de_intruc(6 downto 4);--DIRECCCIONES DE B
datosDIRA<= de_intruc(9 downto 7);--DIRECCCIONES DE A
s<= de_intruc(11 downto 10);
cin<= de_intruc(12);
s2<= de_intruc(13);
selType<=de_intruc(15 downto 14);
inmediato<=de_intruc(3);


end architecture behavior;