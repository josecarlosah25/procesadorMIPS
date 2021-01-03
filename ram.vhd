library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
port (AddrWr	:	in std_logic_vector(2 downto 0); -- direccion de escritura
		AddrRd	:	in std_logic_vector(2 downto 0); -- direccion de lectura
		clkWr		:	in std_logic;
		clkRd		:	in std_logic;
		wrEn		:	in std_logic;
		dataIn	:	in std_logic_vector(2 downto 0); --registro de entrada
		dataout	:	out std_logic_vector(2 downto 0)); --registro de salida
end entity;

architecture behavior of ram is
	type matrix is array (0 to 7) of std_logic_vector(2 downto 0);
	signal memory			: matrix;
	attribute ram_init_file: string;
	attribute ram_init_file of memory : signal is "data.mif";

	signal dataInBuf		: std_logic_vector(2 downto 0);
	signal AddressWrite	: std_logic_vector(2 downto 0);
	signal AddressRead: std_logic_vector(2 downto 0);
	
begin
	
	--Acceso de escritura
	process(clkWr)
	begin
		if (clkWr'event and clkWr='1' and wrEn='1') then
			dataInBuf <= dataIn;
			AddressWrite <= AddrWr;
			memory(to_integer(unsigned(AddressWrite))) <= dataInBuf;
		end if;
	end process;
	
	--Acceso de lectura
	process(clkRd)
	begin
		if(clkRd'event and clkRd='1') then
			AddressRead <= AddrRd;
			dataout<= memory(to_integer(unsigned(AddressRead)));
		end if;
	end process;

end architecture;