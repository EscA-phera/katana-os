; ax - starting sector
; bx - buffer offset
; cx - sectors number
; dx - buffer segment

[bits 16]
[org 0x7c00] ; reference - https://www.youtube.com/watch?v=l2wZf45ZcAg
SECTION .text


boot: ; reference - http://createyourownos.blogspot.com/
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov sp, 0x7c00
    
    push ax
    push string .set_string

    ret

.set_string:
    mov [disk], dl
    mov si, intro

    call print
    call print_line

    mov bx, (s_start - boot) / 512
    call hex_line
    call print_line

    mov bx, s_start
    call hex_line
    call print_line

    mov eax, (s_start - boot) / 512
    mov bx, s_start
    mov cx, (s_end - s_start) / 512

    xor dx, dx
    call load

    call print_line
    mov si, fin

    call print
    call print_line
    
    jmp s

load:
    cmp cx, 127
    jbe .size_buf

    pusha
    mov cx, 127

    popa
    
    add eax, 127
    add dx, 127 * 512 / 16
    sub cx, 127

    jmp load

.size_buf:
    mov 