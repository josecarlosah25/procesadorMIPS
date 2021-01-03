library ieee;
use ieee.std_logic_1164.all;

entity VGA is
port(
  in_clk:  in std_logic;  --for this example is 50MHz
  d7s_A : in  std_logic_vector(6 downto 0); -- A
  auxB : in  std_logic_vector(6 downto 0); -- B
  op: in std_logic_vector(3 downto 0); -- Type of Operation
  d7s_R0,d7s_R1: in std_logic_vector(6 downto 0); -- Result A & B
  numI_1,numI_0: std_logic_vector(6 downto 0);
  

 R				: out std_logic_vector (3 downto 0);
 G			: out std_logic_vector (3 downto 0);
 B				: out std_logic_vector (3 downto 0);

 HS			: out std_logic;
 VS			: out std_logic

 );
end;

architecture behavioral of VGA is
signal pix_clock: STD_LOGIC;
signal disp_ena  : STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
signal column    : INTEGER;    --horizontal pixel coordinate
signal row       : INTEGER;    --vertical pixel coordinate
--signal auxB: std_logic_vector(6 downto 0);
--signal op: std_logic_vector(3 downto 0):= "0000";
signal d7s_B,d7s_Uno: std_logic_vector(6 downto 0);
signal d_OpPrincipal, d_OpSec: std_logic_vector(5 downto 0);
signal rA,gA,bA: std_logic_vector(3 downto 0);
signal rB,gB,bB: std_logic_vector(3 downto 0);
signal rOP1,gOP1,bOP1: std_logic_vector(3 downto 0);
signal rOP2,gOP2,bOP2: std_logic_vector(3 downto 0);
signal rUno,gUno,bUno: std_logic_vector(3 downto 0);
signal rIgual,gIgual,bIgual: std_logic_vector(3 downto 0);
signal rR0,gR0,bR0: std_logic_vector(3 downto 0);
signal rR1,gR1,bR1: std_logic_vector(3 downto 0);
signal rI0,gI0,bI0: std_logic_vector(3 downto 0);
signal rI1,gI1,bI1: std_logic_vector(3 downto 0);
signal input_clk: std_logic;

begin
input_clk<=in_clk;
VGAclk: entity work.Gen25MHz(behavior)  port map(input_clk,pix_clock);
												
controllerVGA: entity work.vga_controller (behavior) port map 
( pix_clock, '1', HS, VS, disp_ena, column,row);


operador: entity work.interpreterOperador(behavior) port map(op,auxB,d7s_Uno,d7s_B, -- operador alu
	d_OpPrincipal,d_OpSec);


displayA: entity work.hw_image_generator (behavior) port map 
(disp_ena, row, column, rA, gA, bA,not d7s_A,250,40); --row,column

displayB: entity work.hw_image_generator (behavior) port map 
(disp_ena, row, column, rB, gB, bB,not d7s_B,250,180); --row,column

displayOp1: entity work.hw_image_generator_OP (behavior) port map 
(disp_ena, row, column, rOP1, gOP1, bOP1,d_OpPrincipal,250,110); --row,column

displayOp2: entity work.hw_image_generator_OP (behavior) port map 
(disp_ena, row, column, rOP2, gOP2, bOP2,d_OpSec,250,250); --row,column

displayUnoExtra: entity work.hw_image_generator (behavior) port map 
(disp_ena, row, column, rUno, gUno, bUno,d7s_Uno,250,320); --row,column

displayR1: entity work.hw_image_generator (behavior) port map 
(disp_ena, row, column, rR1, gR1, bR1,not d7s_R1,250,460); --row,column

displayR0: entity work.hw_image_generator (behavior) port map 
(disp_ena, row, column, rR0, gR0, bR0,not d7s_R0,250,530); --row,column

displayIgual: entity work.hw_image_generator_OP (behavior) port map 
(disp_ena, row, column, rIgual, gIgual, bIgual,"010000",250,390); --row,column

---
displayInstruccion0: entity work.hw_image_generator (behavior) port map 
(disp_ena, row, column, rI0, gI0, bI0,not numI_0,50,320); --row,column

displayInstruccion1: entity work.hw_image_generator (behavior) port map 
(disp_ena, row, column, rI1, gI1, bI1,not numI_1,50,250); --row,column

R<= rA or rB or rOP1 or rOP2 or rUno or rR0 or rR1 or rIgual or rI0 or rI1;
G<= gA or gB or gOP1 or gOP2 or gUno or gR0 or gR1 or gIgual or gI0 or gI1;
B<= bA or bB or bOP1 or bOP2 or bUno or bR0 or bR1 or bIgual or bI0 or bI1;

																			
end behavioral;