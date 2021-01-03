--sumador de 3 bits 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sum3bit is
port(a,b: in std_logic_vector(2 downto 0);
	  cin: in std_logic;
	  salsum: out std_logic_vector(2 downto 0);
	  cout: out std_logic);
end entity;

architecture arq of sum3bit is
signal mid: std_logic_vector(3 downto 0);
begin
	mid <= ('0'&a)+('0'&b)+cin;
	cout <= mid(3);
	salsum <= mid(2 downto 0);
end architecture;
