section .data

formato: db 'La cantidad de Palabras es %i' , 10, 0
mensajeInicio: db 'Ingrese la oracion '
mensajePrueba: db 'Prueba'
mensajeInicioLen: equ $-mensajeInicio


section .bss

oracion resb 256

section .text

global main
extern printf

main: 
   mov r9 , 0                 ;Cantidad de Palabras Encontradas
  

leerTexto:
  mov  eax,4					;Prepara para escribir
  mov  ebx,1		
  mov  ecx,mensajeInicio		;indica el mensaje
  mov  edx,255
  int  80h						;llama kernel

  mov  eax,3		;Prepara para leer
  mov  ebx,0		;desde stdin
  mov  ecx,oracion	;lo guarda en el buffer.
  int    80h
  inc r9

LoopOracion:
  mov al, byte[ecx]
  inc ecx
  jmp AnalizarOracion 

AnalizarOracion:
  cmp al, byte ' '					;compara el caracter actual con espacio
  je AumentarPalabra							;si son iguales va a aumentaPalabra
  cmp al, byte '.'
  je ImprimirRaro		                ;si es el final imprimie
  cmp al , 0
  je ImprimirRaro
  jmp LoopOracion				;si no es el final vuelve a loop oracion

AumentarPalabra:
  inc r9 				;aumenta la cantidad de palabras
  jmp LoopOracion

Prueba:
  mov  eax,4					;Prepara para escribir
  mov  ebx,1		
  mov  ecx,mensajePrueba		;indica el mensaje
  mov  edx,255
  int  80h						;llama kernel
  jmp Exit

ImprimirRaro:
	push r9 ; 32-bit stack operands are not encodable
	push rcx ; in 64-bit mode, so we use the "r" names
	mov rdi, formato ; arg 1 is a pointer
	mov rsi, r9 ; arg 2 is the current number
	xor eax, eax ; no vector registers in use
	call printf
	pop rcx
	pop r9
	mov eax, ebx ; next number is now current
	add ebx, edx ; get the new next number
	dec ecx ; count down
	pop rbx ; restore ebx before returning
	jmp Exit

 Exit:
  mov  eax,1
  mov  ebx,0 
  int  80h
