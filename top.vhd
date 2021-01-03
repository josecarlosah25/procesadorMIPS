library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_UNSIGNED.all;

entity top is
port(
	clk,reset,cs: in std_logic;
 R				: out std_logic_vector (3 downto 0);
 G			: out std_logic_vector (3 downto 0);
 B				: out std_logic_vector (3 downto 0);

 HS			: out std_logic;
 VS			: out std_logic;
 salbits: out std_logic_vector(2 downto 0)
	); --que operacion es Sum Rest, And, OR Xor
end top;

architecture behavior of top is

signal Asal7seg,Bsal7seg,Csal7seg_1,Csal7seg_0: std_logic_vector(6 downto 0);
signal op: std_logic_vector(3 downto 0);
signal numI_1,numI_0: std_logic_vector(6 downto 0);

BEGIN

Mircoprocesador: entity work.microprocesador(behavior) port map (clk,reset,cs,Asal7seg,Bsal7seg,Csal7seg_1,Csal7seg_0,op,numI_1,numI_0,salbits);
salVGA: entity work.VGA(behavioral) port map (clk,Asal7seg,Bsal7seg,op,Csal7seg_0,Csal7seg_1,numI_1,numI_0,R,G,B,HS,VS);

end architecture behavior;