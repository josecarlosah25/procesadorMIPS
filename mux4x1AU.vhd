library ieee;
use ieee.std_logic_1164.all;

entity mux4x1AU is
port(s: in std_logic_vector(1 downto 0);
	  b: in std_logic_vector(2 downto 0);
	  salmux4x1: out std_logic_vector(2 downto 0));
end;

architecture arq of mux4x1AU is
begin
with s select
salmux4x1 <= (others => '0') when "00",
								  b  when "01",
							  not b when "10",
			    (others => '1') when "11",
				 (others => '0') when others;
				 
end architecture;