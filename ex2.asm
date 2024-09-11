.8086
.model small
.stack 100h
.data
    ogtext db 255 dup('$')  ; Buffer para el texto original
    modtext db 255 dup('$') ; Buffer para el texto modificado
    msgPrompt db 'Ingrese un texto y marque su fin con "$": $', '$'
    msjMod db 'Texto modificado: $', '$'
    msjOrig db 'Texto original: $', '$'

.code
main proc
    ; Inicializar segmento de datos
    mov ax, @data
    mov ds, ax

    ; Imprimir el mensaje de solicitud
    mov ah, 09h
    lea dx, msgPrompt
    int 21h

    ; Leer el texto carácter por carácter usando 01h
    lea di, ogtext         ; Cargar el buffer de texto original en DI
read_loop:
    mov ah, 01h            ; Función 01h para leer carácter
    int 21h                ; Llamada a la interrupción 21h
    cmp al, '$'            ; Si el carácter es '$', terminar
    je end_read
    stosb                  ; Almacenar el carácter en el buffer
    jmp read_loop          ; Continuar leyendo

end_read:
    ; Texto está en ogtext, ahora vamos a convertir las vocales minúsculas a mayúsculas
    lea si, ogtext         ; Cargar el texto original en SI
    lea di, modtext        ; Cargar el buffer para el texto modificado en DI
convert_loop:
    lodsb                  ; Cargar el siguiente byte de SI en AL
    cmp al, '$'            ; Si llegamos al final del texto, terminar
    je end_convert

    ; Convertir vocales minúsculas a mayúsculas
    cmp al, 'a'
    je convert_a
    cmp al, 'e'
    je convert_e
    cmp al, 'i'
    je convert_i
    cmp al, 'o'
    je convert_o
    cmp al, 'u'
    je convert_u
    jmp store_char         ; Si no es una vocal minúscula, almacenar el carácter y continuar

convert_a:
    sub al, 20h            ; Restar 20h a 'a' para convertir a 'A'
    jmp store_char
convert_e:
    sub al, 20h            ; Restar 20h a 'e' para convertir a 'E'
    jmp store_char
convert_i:
    sub al, 20h            ; Restar 20h a 'i' para convertir a 'I'
    jmp store_char
convert_o:
    sub al, 20h            ; Restar 20h a 'o' para convertir a 'O'
    jmp store_char
convert_u:
    sub al, 20h            ; Restar 20h a 'u' para convertir a 'U'
    jmp store_char

store_char:
    stosb                  ; Almacenar el carácter (modificado o no) en modtext
    jmp convert_loop       ; Continuar con el siguiente carácter

end_convert:
    ; Imprimir el mensaje de texto modificado
    mov ah, 09h
    lea dx, msjMod
    int 21h

    ; Imprimir el texto modificado
    lea dx, modtext
    mov ah, 09h
    int 21h

    ; Imprimir el mensaje de texto original
    mov ah, 09h
    lea dx, msjOrig
    int 21h

    ; Imprimir el texto original
    lea dx, ogtext
    mov ah, 09h
    int 21h

    ; Terminar el programa
    mov ah, 4Ch
    int 21h

main endp
end main
