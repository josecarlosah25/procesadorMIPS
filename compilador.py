# -*- coding: utf-8 -*-
##Programa usado para compilar un archivo assembler ##

#seccion de funciones

def pError(s):
	print("---------------->>>>>>>>"+s+"  En la linea: "+str(i+1))
	global success
	success=False

def isInt(x):
	try:
		r=int(x)
		return True
	except Exception as e:
		return False

def isReg(r):
	if(r[0]=="R"):
		return True
	else:
		return False

#convierte de binario a un string util para el archivo
def binToStr(x):
	cadena=str(x)
	return cadena[2:]

def hexToStr(x):
	cadena=str(x)
	return cadena[2:]

def intToHexToStr(x):
	hexa=hex(x)
	return hexToStr(hexa)

#convierte int a binario y luego a string para el archivo
def intToBinToStr(x):
	binario=bin(x)
	return binToStr(binario)

def agregaCeros(cad,tamanio):
	r=cad
	if(len(cad)<tamanio):
		dif=tamanio-len(cad)
		for i in range (0,dif):
			r="0"+r
	elif(len(cad)>tamanio):
		pError("ERROR INTERNO--- se tienen mas bits a los requeridos en el binario -"+cad+"- tengo: "+str(len(cad))+" y necesitaba: "+str(tamanio))
		return agregaCeros("",tamanio)
	return r

def esComentario(cad):
	if (cad[0]=="#"):
		return True
	else:
		return False


def codigoRegistro(cad):
	global i
	if(cad[0]=="R"):

		try:
			num=int(cad[1:])
		except ValueError as e:
			pError("Error, el nombre del registro esta mal. Se leyo: "+cad)
		

		if(num<0 or num>=8):
			pError("Error, se esperaba numero de registro entre 1 y 7, se leyó: "+str(num))
			return "000"
		else:
			return agregaCeros(intToBinToStr(num),3)
	else:
		
		try:
			num=int(cad)
		except ValueError as e:
			pError("Error, el numero esta mal. Se leyo: "+cad)

		if(num<0 or num>=8):
			pError("Error, se esperaba numero inmediato entre 0 y 7, se leyó: "+str(num))
			return "000"
		else:
			return agregaCeros(intToBinToStr(num),3)

#Funcion que detecta tres argumentos con sus posibles valores y verifica sintaxis
def op3arguments(arg):
	res=[]

	if(arg[0][0]=="R" and arg[0][1]!="0"):
		res.append(codigoRegistro(arg[0]))
	else:
		for aux in range(0,3):
			res.append("000")
		res.append("0")
		pError("Error, se esperaba numero de registro que no sea R0, se leyó: "+str(arg[0]))
		return res

	if(arg[1][0]=="R"):
		res.append(codigoRegistro(arg[1]))
	else:
		res=[]
		for aux in range(0,3):
			res.append("000")
		res.append("0")
		pError("Error, se esperaba numero de registro, se leyó: "+str(arg[1]))
		return res

	if(arg[2][0]=="R"):
		res.append(codigoRegistro(arg[2]))
		res.append("0")
	elif( isInt (arg[2])==True):
		res.append(codigoRegistro(arg[2]))
		res.append("1")
	else:
		res=[]
		for aux in range(0,3):
			res.append("000")
		res.append("0")
		pError("Error, se esperaba numero de registro o un numero del 1 al 7, se leyó: ")
		return res

	return res	
	
#Funcion que detecta dos argumentos con sus posibles valores y verifica sintaxis
def op2arguments(arg):
	res=[]
	if(arg[0][0]=="R" and arg[0][1]!="0"):
		res.append(codigoRegistro(arg[0]))
	else:
		pError("Error, no puedes guardar en la ubicacion indicada: "+str(arg[0]))
		for cont in range(0,3):
			res.append("000")
		res.append("0")
		return res

	if(isInt(arg[1])==True):
		res.append("000")
		res.append(codigoRegistro(arg[1]))
		res.append("1")
	else:
		temp=arg[1].split("(")
		if(temp[0][0]!="R"):
			pError("Error, se esperaba numero de registro, se leyó: "+str(temp[0]))
			res=[]
			for cont in range(0,3):
				res.append("000")
			res.append("0")
			return res
		else:
			res.append(codigoRegistro(temp[0]))
			if(len(temp)==1):
				res.append("000")
			else:
				res.append(codigoRegistro(temp[1][:-1]))
			res.append("1")

	return res	



fout=open ("instruc.mif","w")

#inicializamos el archivo, este tendrá 16 bloques de 16 bits de profundidad
fout.write("WIDTH=16;\nDEPTH=16;\nADDRESS_RADIX=HEX;\nDATA_RADIX=BIN;\n\nCONTENT BEGIN\n")

#obtenemos el archivo de donde vamos a extraer el assembler
origen= str(input("Dame el nombre de tu archivo con la extension incluida. Ejemplo: programa.as:\n------>"))
fIn=open(origen,"r")

progrCount=0

opcode="0000"
datoA="000"
datoB="000"
datoC="000"
inmed="0"
selector="00"

success=True

lineas=fIn.readlines()

for i in range (0,len(lineas)):
	
	if(esComentario(lineas[i])==True):
		continue

	componentes = lineas[i].split()

	if(len(componentes)>2):
		if(esComentario(componentes[2])==False):
			print("Error . Se esperaba un comentario, se leyo: "+componentes[2])
			continue
	elif(len(componentes)==0):
		continue
	elif(len(componentes)==1):
		print("Error solo se encontro un comando sin argumentos")
		continue

	if(componentes[0]=="ADD"):
		selector="01"
		opcode="0001"
		argumentos=componentes[1].split(",")

		if(len(argumentos)!=3):
			pError("Error solo se esperaban 3 argumentos, lei: "+str(len(argumentos)))
			continue
		else:
			binario=op3arguments(argumentos)
			datoC=binario[0]
			datoA=binario[1]
			datoB=binario[2]
			inmed=binario[3]


	elif(componentes[0]=="RES"):
		selector="01"
		opcode="0110"
		argumentos=componentes[1].split(",")

		if(len(argumentos)!=3):
			pError("Error solo se esperaban 3 argumentos, lei: "+str(len(argumentos)))
			continue
		else:
			binario=op3arguments(argumentos)
			datoC=binario[0]
			datoA=binario[1]
			datoB=binario[2]
			inmed=binario[3]


	elif(componentes[0]=="AND"):
		selector="01"
		opcode="1000"
		argumentos=componentes[1].split(",")

		if(len(argumentos)!=3):
			pError("Error solo se esperaban 3 argumentos, lei: "+str(len(argumentos)))
			continue
		else:
			binario=op3arguments(argumentos)
			datoC=binario[0]
			datoA=binario[1]
			datoB=binario[2]
			inmed=binario[3]


	elif(componentes[0]=="OR"):
		selector="01"
		opcode="1001"
		argumentos=componentes[1].split(",")

		if(len(argumentos)!=3):
			pError("Error solo se esperaban 3 argumentos, lei: "+str(len(argumentos)))
			continue
		else:
			binario=op3arguments(argumentos)
			datoC=binario[0]
			datoA=binario[1]
			datoB=binario[2]
			inmed=binario[3]


	elif(componentes[0]=="XOR"):
		selector="01"
		opcode="1010"
		argumentos=componentes[1].split(",")

		if(len(argumentos)!=3):
			pError("Error solo se esperaban 3 argumentos, lei: "+str(len(argumentos)))
			continue
		else:
			binario=op3arguments(argumentos)
			datoC=binario[0]
			datoA=binario[1]
			datoB=binario[2]
			inmed=binario[3]


	elif(componentes[0]=="ADD+1"):
		selector="01"
		opcode="0101"
		argumentos=componentes[1].split(",")

		if(len(argumentos)!=3):
			pError("Error solo se esperaban 3 argumentos, lei: "+str(len(argumentos)))
			continue
		else:
			binario=op3arguments(argumentos)
			datoC=binario[0]
			datoA=binario[1]
			datoB=binario[2]
			inmed=binario[3]


	elif(componentes[0]=="INC"):
		selector="01"
		opcode="0100"
		argumentos=componentes[1].split(",")

		if(len(argumentos)!=2):
			pError("Error solo se esperaban 2 argumentos, lei: "+str(len(argumentos)))
			continue
		else:
			binario=op2arguments(argumentos)
			datoC=binario[0]
			datoA=binario[1]
			datoB=binario[2]
			inmed=binario[3]


	elif(componentes[0]=="DEC"):
		selector="01"
		opcode="0110"
		argumentos=componentes[1].split(",")

		if(len(argumentos)!=2):
			pError("Error solo se esperaban 2 argumentos, lei: "+str(len(argumentos)))
			continue
		else:
			binario=op2arguments(argumentos)
			datoC=binario[0]
			datoA=binario[1]
			datoB="001"
			inmed="1"


	elif(componentes[0]=="LOAD"):
		selector="10"
		opcode="0001"
		argumentos=componentes[1].split(",")

		if(len(argumentos)!=2):
			pError("Error solo se esperaban 2 argumentos, lei: "+str(len(argumentos)))
			continue
		else:
			binario=op2arguments(argumentos)
			datoC=binario[0]
			datoA=binario[1]
			datoB=binario[2]
			inmed=binario[3]


	elif(componentes[0]=="STORE"):
		selector="10"
		opcode="0010"
		argumentos=componentes[1].split(",")

		if(len(argumentos)!=2):
			pError("Error solo se esperaban 2 argumentos, lei: "+str(len(argumentos)))
			continue
		else:
			if(isInt(argumentos[1])==False):
				pError("Error, recuerda que para el segundo argumento de STORE solo se usa un numero int, se leyó: "+str(argumentos[1]))
				continue
			if(isInt(argumentos[0])==True):
				datoB=codigoRegistro(argumentos[0])
				datoC=codigoRegistro(argumentos[1])
				inmed="1"
			else:
				binario=op2arguments(argumentos)
				datoB=binario[0]
				datoC=binario[2]
				inmed="0"
			datoA="000"
		


	elif(componentes[0]=="COPY"):
		selector="01"
		opcode="0001"
		argumentos=componentes[1].split(",")

		if(len(argumentos)!=2):
			pError("Error solo se esperaban 2 argumentos, lei: "+str(len(argumentos)))
			continue
		else:
			binario=op2arguments(argumentos)
			datoC=binario[0]
			datoA=binario[1]
			datoB=binario[2]
			inmed=binario[3]


	elif(componentes[0]=="SHOW"):
		selector="01"
		opcode="0001"
		argumentos=componentes[1].split(",")

		if(len(argumentos)!=1):
			pError("Error solo se esperaba 1 argumento, lei: "+str(len(argumentos)))
			continue
		else:
			
			datoA=codigoRegistro(argumentos[0])
			datoB="000"
			datoC=datoA
			inmed="0"
			
	else:
		pError("No se reconocio el comando "+str(componentes[0]))
		continue

	if(progrCount<16):
		numLineaMif=agregaCeros(intToHexToStr(progrCount),2).upper()
		fout.write(numLineaMif+" : "+selector+opcode+datoA+datoB+inmed+datoC+";\n")
		progrCount=progrCount+1
	else:
		pError("=========Fatal: Solo se pueden ejecutar 16 instrucciones en el procesador error presentado ")
	#print(selector+opcode+datoA+datoB+inmed+datoC)
if(progrCount<16):
	while(progrCount<16):
		numLineaMif=agregaCeros(intToHexToStr(progrCount),2).upper()
		fout.write(numLineaMif+" : 0100010000000000;\n")
		progrCount=progrCount+1
fout.write("END;")
fout.close()


if (success==False):
	fout=open("instruc.mif","w")
	print("xxxxxx Revisar archivo fuente xxxxxxx")
else:
	print("---------->Completado con exito<-----------")


