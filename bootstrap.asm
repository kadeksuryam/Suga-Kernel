; BIOS interrupts reference: http://www.ctyme.com/intr/int-10.htm

start:
    mov ax, 07C0h
	mov ds, ax

    call print_startup_msg
    call load_kernel

    jmp 09C0h:0h

load_kernel:
    mov ax, 09C0h
    mov es, ax

    ; read second sector (the kernel) to address 09C0h:0h
    mov ah, 02h ; service number
    mov al, 01h ; number sector to read
    mov ch, 0h ; track number
    mov cl, 02h ; sector number
    mov dh, 0h ; head numberr
    mov dl, 80h ; 80h for drive 0
    mov bx, 0h ; offset where the data will stored (09C0h:BX)
    int 13h

    jc load_kernel_error

    ret

load_kernel_error:
    mov si, load_kernel_err_str
    call print_string

    jmp $

print_startup_msg:
    mov si, bootloader_msg_str
    call print_string

    mov si, loading_kernel_msg_str
    call print_string

    ret

; precondition: 
; si initialized
; ah = 0Eh
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

bootloader_msg_str db "The Bootloader of Suga's Kernel", 0
loading_kernel_msg_str db "Loading the kernel...", 0
load_kernel_err_str db "Failed to load kernel!", 0

times 510-($-$$) db 0
dw 0xAA55 ; bootloader magic number
