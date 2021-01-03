--------------------------------------------------------------------------------
--
--   FileName:         hw_image_generator.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY hw_image_generator_OP IS
  GENERIC(
   pixels_y :  INTEGER := 478;   --row that first color will persist until
   pixels_x :  INTEGER := 600);  --column that first color will persist until
  PORT(
    disp_ena :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    row      :  IN   INTEGER;    --row pixel coordinate
    column   :  IN   INTEGER;    --column pixel coordinate
    red      :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
    green    :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
    blue     :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0'); 
	 opDis		: in 	std_logic_vector(5 downto 0);
	 pivR: in integer;
	 pivC: in integer);
    
	 END hw_image_generator_OP;

ARCHITECTURE behavior OF hw_image_generator_OP IS

signal opcty: std_logic_vector(3 downto 0):="0001";

BEGIN
  PROCESS(disp_ena, row, column)
   
 BEGIN


 IF(disp_ena = '1') THEN        --display time
     

	    --palo de la resta          
      if (opDis(0)='1' and ((row>pivR+30 and row<pivR+40)and(column>pivC and column<pivC+30)) ) THEN --segmento 0
			   red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		
		--palo vertical de la suma
		elsif (opDis(1)='1' and ((row>pivR+20 and row<pivR+50)and(column>pivC+10 and column<pivC+20))) THEN --segmento 1
			   red <= (others => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
      
		--and
		elsif (opDis(2)='1' and (((row>pivR and row<pivR+10)and(column>pivC and column<pivC+30)) or
					((row>pivR+10 and row<pivR+30)and((column>pivC and column<pivC+10) or (column>pivC+20 and column<pivC+30) ))))  THEN --segmento 1
			   red <= (others => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
				
		--not
		elsif (opDis(5)='1' and (((row>pivR and row<pivR+10)and(column>pivC and column<pivC+30)) or
					((row>pivR+10 and row<pivR+30)and(column>pivC+20 and column<pivC+30) )))  THEN --segmento 1
			   red <= (others => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		--or
		elsif (opDis(3)='1' and (((row>pivR+60 and row<pivR+70)and(column>pivC and column<pivC+30)) or 
					((row>pivR+40 and row<pivR+60)and((column>pivC and column<pivC+10)or(column>pivC+20 and column<pivC+30))))) THEN --segmento 1
			   red <= (others => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
      -- dos rayas del igual
		elsif (opDis(4)='1' and (((row>pivR+18 and row<pivR+28)or(row>pivR+41 and row<pivR+51))and(column>pivC and column<pivC+30))) THEN --segmento 1
			   red <= (others => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		
		--resta apagada
		elsif (opDis(0)='0' and ((row>pivR+30 and row<pivR+40)and(column>pivC and column<pivC+30))) THEN 
			   red <= opcty;
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		--palo vertical de la suma apagada
		elsif (opDis(1)='0' and ((row>pivR+20 and row<pivR+50)and(column>pivC+10 and column<pivC+20))) THEN 
			   red <= opcty;
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		--and apagada
		elsif (opDis(2)='0' and (((row>pivR and row<pivR+10)and(column>pivC and column<pivC+30)) or 
					((row>pivR+10 and row<pivR+30)and((column>pivC and column<pivC+10)or(column>pivC+20 and column<pivC+30) )) )) THEN --segmento 1
			   red <= opcty;
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		--or apagada
		elsif (opDis(3)='0' and (((row>pivR+60 and row<pivR+70)and(column>pivC and column<pivC+30)) or 
					((row>pivR+40 and row<pivR+60)and((column>pivC and column<pivC+10)or(column>pivC+20 and column<pivC+30))))) THEN 
					red <= opcty;
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		-- dos rayas del igual apagadas
      elsif (opDis(4)='0' and (((row>pivR+18 and row<pivR+28)or(row>pivR+41 and row<pivR+51))and(column>pivC and column<pivC+30))) THEN 
			   red <= opcty;
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		else		
				red <= (OTHERS => '0');  --es el fondo
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
		end if;
	

END IF;  --del enable
  
  END PROCESS;
END behavior;