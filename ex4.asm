.8086
.model small
.stack 100h
.data
	msgPrompt db "Ingrese un texto", 0dh, 0ah, 24h
	ogtext db 255 dup('$')
	mdfiedtext db 255 dup('$')
	salto db 0dh, 0ah, 24h
	
.code
    main proc
        mov ax,@data
		mov ds, ax
		
		mov ah, 09h
		mov dx, offset msgPrompt
		int 21h
		
		mov bx, 0
	carga:
		mov ah, 01h ;Pido leer un char
		int 21h
		cmp al, 0dh
		je proceso
		mov ogtext[bx], al
		inc bx
	loop carga

mov si, 0

proceso:
	
    dec bx
    cmp bx, 0         ; Compara si ya llegamos al principio de la cadena
    jl ultimoPaso     ; Si es menor que 0, salta a ultimoPaso

    mov al, ogtext[bx]  ; Carga el carácter de ogtext usando bx como índice
    mov mdfiedtext[si], al  ; Guarda el carácter en mdfiedtext usando cx
    inc si             ; Incrementa cx para moverse en la cadena de destino
	jmp proceso        ; Repite el proceso hasta llegar al inicio de la cadena

ultimoPaso:
    mov ah, 09h
    mov dx, offset mdfiedtext
    int 21h             ; Muestra la cadena modificada

	mov ah, 09h
	mov dx, offset salto
	int 21h
	
	mov ah, 09h
	mov dx, offset ogtext
	int 21h
		
	;termino programa con codigo de retorno
	mov ax, 4c00h
	int 21h
main endp

end

;Ingrese un texto e imprima en forma de espejo.
