
section .data
	mensajeBienvenida: db 'Introduzca una lista', 10
	

section .bss
	
lista resb 256 					;reserva la lista
i resb 256						;iterador
cantidadCambios resb 8 			;Cantidad de cambios
PrimerDato resb 31				;guarda el primerdato
SegundoDato resb 31				;guarda el segundo dato


section	.text

global _start

Setup: 
	mov byte [i],  30h					;indice que indica el numero ACtual
	mov byte [PrimerDato], 0 					;Contiene el primerDato
	mov byte [SegundoDato],  0					;Contiene al segundoDato
	mov byte [cantidadCambios], 30h					;Cantidad de cambios hechos
	ret

 _start:
	call Setup
	mov  eax,4					;Prepara para escribir
 	mov  ebx,1		
  	mov  ecx,mensajeBienvenida		;indica el mensaje
  	mov  edx,255
  	int  80h						;llama kernel
  	xor  ecx,ecx
	mov  eax,3		;Prepara para leer
    mov  ebx,0		;desde stdin
    mov  ecx,lista	;lo guarda en el buffer.
    int    80h
    jmp PrimerosNumeros	;configura los primerso 2 numeros

NuevoCiclo:				;vuelve a recorrer la lista
	call Setup
	jmp PrimerosNumeros

PrimerosNumeros:				;configura los primeros 2 datos
	mov al, byte[ecx] 			;obtiene el caracter
	mov byte [PrimerDato] , al

	add ecx , 2					;mueve el indice ecx
	mov al, byte[ecx] 			;obtiene el caracter
	sub ecx , 2					;devuelve ecx
	mov byte [SegundoDato] , al

	mov byte [i] , 2

	cmp byte [PrimerDato] , al
	ja CompararPrimeros			;analiza si es necesario cambiarlos

	jmp Ciclo
	

CompararPrimeros:				;Cambios los primeros datos
	add ecx , 0					;mueve el indice ecx
	mov byte [ecx], al			;obtiene el caracter
	sub ecx , 0					;devuelve ecx

	mov dl , byte [PrimerDato]
	add ecx , 2					;mueve el indice ecx
	mov byte [ecx], dl 			;obtiene el caracter
	sub ecx , 2	

	inc byte [cantidadCambios]

	mov byte [SegundoDato], dl

	jmp Ciclo			;devuelve ecx

Ciclo:							;Itera entre los numeros
	xor dl, dl
	xor al , al
	add byte [i] , 2 
	add ecx , [i]				;mueve el indice ecx
	mov al, byte[ecx] 			;obtiene el caracter
	sub ecx , [i]				;devuelve ecx
  	cmp al , 0 					 ;analiza el final de la oracion
  	je IniciarCiclo
  	mov dl, byte [SegundoDato]
  	mov byte [PrimerDato], dl
  	mov byte [SegundoDato], al 					 ;guarda el dato actual en cl
  	cmp byte [PrimerDato], al					 ;compara el dato actual con el dato anterior
  	ja CambiarPosicion			 ;si el dato anterior en mayor los cambia si no sigue 
  	jmp Ciclo
 
IniciarCiclo:
	cmp byte [cantidadCambios], 30h
	je InprimirResultado
	jmp NuevoCiclo


InprimirResultado:
	mov  eax,4					;Prepara para escribir
  	mov  ebx,1	
  	;add byte [i], 30h	
  ;	mov  ecx,PrimerDato		;indica el mensaje
    mov  edx,255
    int  80h						;llama kernel
    jmp Exit

CambiarPosicion:
	inc byte [cantidadCambios]

	add ecx ,  [i]					;mueve el indice ecx
	sub ecx , 2
	mov byte [ecx], al			;obtiene el caracter
	sub ecx , [i]					;devuelve ecx
	add ecx , 2

	add ecx , [i]				;mueve el indice ecx
	mov byte [ecx], dl 			;obtiene el caracter
	sub ecx , [i]	

	mov byte [SegundoDato], dl

	jmp Ciclo					;vuelve a ciclo


 Exit:							;cierra el programa
  mov  eax,1
  mov  ebx,0 
  int  80h

