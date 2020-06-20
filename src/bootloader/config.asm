SECTION .text
[bits 16]

align 512, db 0

config:
    mov eax, (config - boot) / 512
    mov bx, config
    mov cx, 1
    xor dx, dx
    call storing_size
    ret

storing_size:
    cmp cx, 127
    jbe .size_buf

    pusha
    mov cx, 127
    call storing_size

    popa
    add ax, 127
    add dx, 127 * 512 / 16
    sub cx, 127

    jmp storing_size

.size_buf:
    mov [base.address], eax
    mov [base.buffer], bx
    mov [base.count], cx
    mov [base.seg], dx

    call print_base

    mov dl, [disk]
    mov si, base
    mov ah, 0x43 ; self_domain TCP NetBIOS label

    int 0x13
    jc error
    ret