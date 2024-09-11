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
		
		;Imprime prompt en pantalla
		mov ah, 09h
		mov dx, offset msgPrompt
		int 21h
		
		mov bx,0;Inicializo un contador
	;Pido al usuario cargar el texto 
	carga:
		mov ah,01h
		int 21h
		cmp al, 0dh ;Compruebo si hay Enter/Salto de linea
		je finCarga
		mov ogtext[bx], al
		mov mdfiedtext[bx],al;Añado a la posicion bx el caracter
		inc bx;Incremento el contador
	jmp carga;Repito
	
	finCarga:
	mov bx, 0
	
	;Ahora modifico mdfiedText
	proceso:
		cmp mdfiedtext[bx], '$' ;Comprueba si terminó el texto
		je finProceso
		
		cmp mdfiedtext[bx], 20h
		je hayEspacio
	
	incrementoBx:
		inc bx
	
	jmp proceso
		
	
	hayEspacio:
		inc bx
		sub mdfiedtext[bx], 20h
		jmp IncrementoBx
		
	finProceso:
		
		mov ah, 09h
		mov dx, offset mdfiedtext
		int 21h
		
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

;3. Ingrese un texto e imprímalo con la primer letra de cada palabra en mayúscula 