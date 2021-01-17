#programa de prueba
ADD R1,R2,2 #00: 0+2=2, R1=2
STORE R1,5 #01: No hacer caso, mem(5)=R1...2
LOAD R2,5	#02: hacer caso, R2= mem(5)...R2=2
ADD R1,R5,R2 #03: 0+2=2, R1=2
COPY R5,R1 #04: no hacer caso , R5=R1...R5=2
INC R6,R5 #05: 2+1=3 , R6=3
STORE R6,7 #06: no hacer caso, mem(7)=R6...3
LOAD R7,7 #07: no hacer caso, R7=mem(7)....R7=3
SHOW R7 #08: 3+0=3
