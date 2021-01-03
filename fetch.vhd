library ieee;
use ieee.std_logic_1164.all;

entity fetch is
port(clk,reset,cs: in std_logic;
	bus_datos: out std_logic_vector(15 downto 0);
	num_instruc: out std_logic_vector(3 downto 0);
	cableclk: buffer std_logic
	);
end entity;

architecture behavior of fetch is

signal cable_bus_dir: std_logic_vector(3 downto 0);
begin

u1: entity work.relojlento(behavior) port map (clk,cableclk);
u2: entity work.contador(behavior) port map (cableclk, reset,cable_bus_dir);
u3: entity work.fetchRom(behavior) port map (cable_bus_dir,cs,bus_datos);

num_instruc<=cable_bus_dir;

end behavior;