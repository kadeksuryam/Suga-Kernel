start:
    mov ax, cs
	mov ds, ax

    mov si, kernel_msg_str
    call print_string

    jmp $
    
; precondition: 
; si initialized
print_string:
    mov ah, 0Eh
    lodsb ; copy si value to al, then increment si

    cmp al, 0
    je print_string_finished
    
    int 10h
    jmp print_string

; newline + set cursor to the beginning
print_string_finished:
    ; print new line
    mov al, 10d
    int 10h

    ; get cursor pos and size
    mov ah, 03h
    int 10h

    ; set cursor to the beginning
    mov ah, 02h
    mov dl, 0h
    int 10h

    ret


kernel_msg_str db "Hello from Suga's Kernel", 0
