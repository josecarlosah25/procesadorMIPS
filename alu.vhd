library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu is
port(a,b: in std_logic_vector(2 downto 0);
	  cin: in std_logic;
	  sel: in std_logic_vector(2 downto 0);
	  cout: out std_logic;
	  salALU: out std_logic_vector(2 downto 0);
	  sal7seg_1,sal7seg_0: out std_logic_vector(6 downto 0));
end entity;

architecture arq of alu is
signal uamux: std_logic_vector(2 downto 0);
signal ulmux: std_logic_vector(2 downto 0);
signal salalu7seg: std_logic_vector(3 downto 0);
signal s_cout: std_logic;
signal s_salALU: std_logic_vector(2 downto 0);
begin

ua1:entity work.ua(arq) 
	 port map (a,b,sel(1 downto 0),cin,uamux,s_cout);
	 
ul1:entity work.ul(arq) 
	 port map (a,b,sel(1 downto 0),ulmux);
	 
muxalu:entity work.mux2x1ALU(arq)
	    port map(uamux,ulmux,sel(2),s_salALU);
		 
alu7seg:entity work.bcd2x7seg(arq)
		  port map(salalu7seg,sal7seg_1,sal7seg_0);

cout <= s_cout;
salALU <= s_salALU;

process(s_cout,sel)
	begin
		if ((s_cout = '1' and sel = "010") or (sel(2) = '1')) then 
			salalu7seg(3) <= '0';
			salalu7seg(2 downto 0) <= s_salALU;
		else
			salalu7seg(3) <= s_cout;
			salalu7seg(2 downto 0) <= s_salALU;
		end if;
	end process;

end architecture;