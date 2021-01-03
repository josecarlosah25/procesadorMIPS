library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mux2x1ALU is
port(ua,ul: in std_logic_vector(2 downto 0);
	  s: in std_logic;
	  salALU: out std_logic_vector(2 downto 0));
end entity;

architecture arq of mux2x1ALU is

begin

with s select 
salALU <= ua when '0',
			 ul when others;

end architecture;