SECTION .text
[bits 16]

print_line:
    mov al, 13
    call print_char

    mov al, 10
    jmp print_char

print:
    pushf
    cld

.loop:
    lodsb
    test al, al

    jz .done
    call print_char

    jmp .loop

.done:
    popf
    ret

print_char:
    pusha
    mov bx, 7
    mov ah, 0x0e
    int 0x10

    popa
    ret

hex_line:
    mov cx, 4

.lp:
    mov al, bh
    shr al, 4

    cmp al, 0xA ; '\n'
    jb .zero

    add al, 'A' - 0xA - '0' ; '\r\n'

.zero:
    add al, '0'

    call print_char