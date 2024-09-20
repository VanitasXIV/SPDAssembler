.8086
.model small
.stack 100h
.data
	texto db 255 dup (24h)
	mayus db 255 dup (24h)
	salto db 0dh, 0ah, 24h
	largo db 0 
	cartelito1 db "Bienvenido al mi programa, este es un cartelito",0dh,0ah
			   db "ud deber  ingresar un texto finalizado con enter",0dh,0ah
			   db "el mismo ser  interpretado por nuestro sistema de computos",0dh,0ah
			   db "y el mismo nos indicar  si su texto es palindromo",0dh,0ah,24h
	salida 	   db "Su texto es: ", 24h
	no		   db "no "      
	palin 	   db "palindromo", 0dh,0ah,24h

	largoPrint db "su texto tiene: "
	largoAscii db "000 Caracteres",0dh,0ah,24h

.code

	main proc

	mov ax, @data
	mov ds, ax

	mov ah, 9
	mov dx, offset cartelito1
	int 21h


	mov bx, 0

carga:

	mov ah, 1 
	int 21h
	cmp al, 0dh
	je finCarga
	cmp al, 20h
	je carga 
	mov texto[bx],al 
	inc bx
jmp carga

finCarga:
  mov largo, bl  
  push bx
  mov bx, 0
cambiLetra:
	cmp texto[bx],24h
	je finCambiLetra
	mov dl, texto[bx]

	cmp dl, 61h
	jae casiMinusc
guarda:
	mov mayus[bx],dl

	inc bx
	jmp cambiLetra

casiMinusc:
	cmp dl, 7ah
	jbe esMinuscula
	jmp guarda

esMinuscula:
	sub dl, 20h
	jmp guarda

finCambiLetra:
  pop bx 
	dec bx
	mov si, 0

proceso:
	cmp si,bx
	ja esPalin 
	mov dl, mayus[si]
	cmp dl, mayus[bx]
	jne noEsPalin
	inc si 
	dec bx 
jmp proceso

noEsPalin:
	mov ah, 9
	mov dx, offset salida
	int 21h
	mov ah, 9
	mov dx, offset no
	int 21h
jmp fin
	
esPalin:
	mov ah, 9
	mov dx, offset salida
	int 21h
	mov ah, 9
	mov dx, offset palin
	int 21h

fin:
	
	xor ax, ax ;ES UN MOV AX,0
	mov al, largo ;TENGO LA CANTIDAD EN AL
	mov dl, 100 
	div dl 

			;EN AH tengo el RESTO
			;EN AL TENGO EL RESULTADO

	add largoAscii[0],al ;CUANDO TIENEN RAZON...... 
	mov al, ah         ;MUEVO DECENA Y UNIDAD A AL
	xor ah, ah         ;LIMPIO LA PARTE ALTA DE AX
	mov dl, 10 
	div dl 
	add largoAscii[1],al ;MUEVO DECENA
	add largoAscii[2],ah ;MUEVO UNIDAD


	mov ah, 9
	mov dx, offset largoPrint
	int 21h


	mov ax, 4c00h
	int 21h
	main endp
end
