section .data


section .bss


section	.text

global main


main:

	mov ah , 0ch
	mov al, 4
	mov cx , 50
	mov dx , 100
	int 10h
