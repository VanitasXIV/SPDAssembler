.8086
.model small
.stack 100h
.data
	numeroReg db 0
	multiplicador db 100, 10, 1
	divisor db 100, 10, 1
.code

public asciiToReg
public regToAscii
public impresion
public carga
public regToBin
public stringLength

carga proc
	push bx
	
	proceso:
		mov ah,1
		int 21h
		cmp al, 0dh ;enter
		je finCarga
		mov [bx], al
		inc bx
		jmp proceso
		
		finCarga:
			pop bx
			ret
carga endp

impresion proc
	push bx

	mov ah, 9
	lea dx, [bx]
	int 21h

	pop bx
	ret
impresion endp

	asciiToReg proc					; La función recibe en bx el offset de numeroAscii para devolverlo como registro
		push ax
		push si
		push cx
		push bx

		mov ax, 0
		mov si, 0
		mov cx, 3

		proceso0:
			mov al, [bx]
			sub al, 30h
			mov dl, multiplicador[si]
			mul dl
			add numeroReg, al
			inc bx
			inc si
			mov ax, 0
			loop proceso0

		pop bx
		pop cx
		pop si
		pop ax		
		ret
	asciiToReg endp
	
	regToAscii proc					; La función recibe en bx el offset de numeroReg para devolverlo como ASCII
		push ax
		push si
		push cx
		push bx

        	mov ah, 0
        	mov al, numeroReg
		mov si, 0
		mov cx, 3

		proceso2:
			mov dl, divisor[si]
			div dl
			add al, 30h
			mov [bx], al
			mov al, ah
			mov ah, 0
			inc bx
			inc si
			loop proceso2

		pop bx
		pop cx
		pop si
		pop ax		
		ret
	regToAscii endp

regToBin proc
	; DL recibe numero que va a ser transformado
	; BX recibe el offset de la variable donde se va a almacenar el resultado

	push ax
	push cx
	push bx
	
	mov cx, 8
	add bx, 7
	processRegToBin:
		shr dl, 1 ;shift right 1 bit
		jc esUno
		mov byte ptr [bx], 30h
		jmp followUp
	esUno:
		mov byte ptr [bx], 31h
	
	followUp:
		dec bx
		loop processRegToBin
	
	pop bx
	pop cx
	pop ax
	
	ret
regToBin endp

stringLength proc
;CX guarda el resultado de cantidad de caracteres
;BX recibe offset de una variable

mov cx, 0
push bx

	lengthProcess:
		cmp byte ptr[bx], 24h ;compara con $
		je fin_lengthProcess
		inc bx ;mueve ptr
		inc cx ;suma contador ++
		jmp lengthProcess
	fin_lengthProcess
		pop bx
		ret

stringLength endp

end