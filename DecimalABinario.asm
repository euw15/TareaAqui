; ----------------------------------------------------------------------------------------
; Compile and link it with:nasm -felf decbin.asm && gcc decbin.o -o decbin
; ----------------------------------------------------------------------------------------
section .data
	cambiarNumero: db 'Cambiar Numero' ,10, 0
	formato: db 'La cantidad de Palabras es %i' , 10, 0
	mensajeBienvenida: db 'Introduzca una lista', 0
	


section .bss
	
lista resb 256 					;reserva la lista

section	.text

global main



main:
	call Setup
	mov  eax,4					;Prepara para escribir
 	mov  ebx,1		
  	mov  ecx,mensajeBienvenida		;indica el mensaje
  	mov  edx,255
  	int  80h						;llama kernel

	mov  eax,3		;Prepara para leer
    mov  ebx,0		;desde stdin
    mov  ecx,lista	;lo guarda en el buffer.
    int    80h

Setup:
	mov r8,  0
	mov r9,  0
	mov r10, 0
	mov cl,  4
	mov dl,  5
	mov r13, 0
	ret
	
PrimerosNumeros:
	cmp r8 , 2
	jz Ciclo
	mov al, byte[ecx] 
	inc ecx 
	cmp al , byte ','
	je PrimerosNumeros
	cmp r8 , 0
	jz PrimerDato
	cmp r8 , 1 
	jz  SegundoDato

PrimerDato:
	mov dl , al
	inc r8
	jmp PrimerosNumeros

SegundoDato:
	mov cl , al
	inc r8
	jmp PrimerosNumeros

Ciclo:
	mov al, byte[ecx]            ;analiza el bit actual
  	inc ecx						 ;mueve el puntero del string
  	cmp al , 0 					 ;analiza el final de la oracion
  	je Exit 
  	cmp al , byte ','			 ;ve si es una coma
  	je Ciclo					 ;si es coma vuelve a hacer el ciclo en busca de un numero
  	mov cl, al 					 ;guarda el dato actual en cl
  	cmp dl, cl					 ;compara el dato actual con el dato anterior
  	ja CambiarPosicion			 ;si el dato anterior en mayor los cambia si no sigue 
  	mov dl, cl				     ;cambia el actual al valor anterior 
  	jmp Exit
  	


CambiarPosicion:
	inc r13
	mov  dl , cl 
  	jmp Ciclo


 Exit:
  mov  eax,1
  mov  ebx,0 
  int  80h

