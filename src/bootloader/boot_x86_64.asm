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
    mov [base.address], eax
    mov [base.buffer], bx
    mov [base.count], cx
    mov [base.seg], dx

    call print_base

    mov dl, [disk]
    mov si, base
    mov ah, 0x42 ; 8 x 16 pixel buffer

    int 0x13 ; bios interrupt call : 13 -> x86 interrupt
             ; real mode handler - system call
             ; https://m.blog.naver.com/PostView.nhn?blogId=cotkdrl1&logNo=10148806030&proxyReferer=https:%2F%2Fwww.google.co.kr%2F
    jc error

    ret

print_base:
    mov al, 13
    call print_char

    mov bx, [base.address + 2]
    call hex_line

    mov bx, [base.address]
    call hex_line

    mov al, '#'
    call print_char

    mov bx, [base.count]
    call hex_line

    mov al, ' '
    call print_char

    mov bx, [base.seg]
    call hex_line

    mov al, ':'
    call print_char

    mov bx, [base.buffer]
    call hex_line

    ret

error:
    call print_line
    mov bh, 0
    mov bl, ah
    
    call hex_line
    mov al, ' '

    call print_char
    mov si, error_occured
    call print
    call print_line

.halt:
    cli
    hlt
    jmp .halt

%include "print.asm"

intro: db 'katana os loader', 0
error_occured: "Couldn't Read Disk", 0
fin: db "finished!", 0
disk: db 0
base:
    db 0x10 ; hexadecimal
    db 0

.count: dw 0 ; reset count
.buffer: dw 0 ; clear buffer
.seg: dw 0 ; clear segment
.address: dq 0 ; read lba spot
