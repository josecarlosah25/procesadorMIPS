library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_UNSIGNED.all;

entity microprocesador is
port(
	clk,reset,cs: in std_logic;
	Asal7seg,Bsal7seg,Csal7seg_1,Csal7seg_0: out std_logic_vector(6 downto 0);
	op: out std_logic_vector(3 downto 0);
	numI_1,numI_0: out std_logic_vector(6 downto 0);
	sbits: out std_logic_vector(2 downto 0)
	); --que operacion es Sum Rest, And, OR Xor
end microprocesador;

architecture behavior of microprocesador is

signal bus_instruc: std_logic_vector(15 downto 0);
signal bus_dirA,bus_dirB: std_logic_vector (2 downto 0);
signal bus_datosA,bus_datosB: std_logic_vector (2 downto 0);
signal s:  std_logic_vector(1 downto 0);
signal s2,cin:  std_logic;
signal cout: std_logic;
signal numC :std_logic_vector(2 downto 0);
signal numIns: std_logic_vector(3 downto 0);

signal AddrWr : std_logic_vector(2 downto 0); -- direccion de escritura
signal clkWr	: std_logic;
signal clkRd	: std_logic;
signal wrEn		: std_logic;
signal dataIn	: std_logic_vector(2 downto 0); --registro de entrada

signal slowClk		: std_logic;

signal help:  std_logic_vector(2 downto 0);

BEGIN

sbits<=help;
Fetch: entity work.fetch(behavior) port map (clk,reset,'1',bus_instruc,numIns,slowClk);
Decoder: entity work.decoder(behavior) port map (bus_instruc,bus_dirA,bus_dirB,s,s2,cin,AddrWr,cs);

Alu: entity work.alu(arq) port map(bus_datosA,bus_datosB,cin,s2 & s,cout,numC,Csal7seg_1,Csal7seg_0);
op<=cin&s2&s; 

--memoriaA: entity work.ram(behavior) port map(AddrWr, bus_dirA,not clk,clk,reset nor not clk,numC,bus_datosA);
--memoriaB: entity work.ram(behavior) port map(AddrWr, bus_dirB,not clk,clk,reset nor not clk,numC,bus_datosB);

registers: entity work.REGs(behavior) port map(AddrWr, bus_dirA,bus_dirB,not clk,clk,reset nor not clk,numC,bus_datosA,bus_datosB);

numA: entity work.bcd7seg(arq) port map('0'&bus_datosA,Asal7seg);
numB: entity work.bcd7seg(arq) port map('0'&bus_datosB,Bsal7seg);
numIntruccion: entity work.bcd2x7seg(arq) port map(numIns,numI_1,numI_0);



end architecture behavior;