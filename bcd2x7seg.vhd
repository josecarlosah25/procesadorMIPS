library ieee;
use ieee.std_logic_1164.all;

entity bcd2x7seg is
port(
	bcd: in std_logic_vector(3 downto 0);
	d_1,d_0: out std_logic_vector(6 downto 0)
);
end entity;

architecture arq of bcd2x7seg is

signal led: std_logic_vector(13 downto 0);

begin
with bcd select
	led <=   "11111111000000" when "0000",
				"11111111111001" when "0001",
				"11111110100100" when "0010",
				"11111110110000" when "0011",
				"11111110011001" when "0100",
				"11111110010010" when "0101",
				"11111110000010" when "0110",
				"11111111111000" when "0111",
				"11111110000000" when "1000",
				"11111110011000" when "1001",
				"11110011000000" when "1010",
				"11110011111001" when "1011",
				"11110010100100" when "1100",
				"11110010110000" when "1101",
				"11110010011001" when "1110",
				"11110010010010" when "1111",
				"11111111111111" when others;
				
	d_1 <= led(13 downto 7);
	d_0 <= led(6 downto 0);
						
end architecture;