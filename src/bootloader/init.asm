SECTION .text
[bits 16]
; cr0 ~ cr4 - @processor control 
; fpu - a part of CPU, logical op for calculating floating-point
; SIMD - ONe of multiple processor : To Calculate multiple values simultaneously with one command
init:
.enable_fpu
    mov eax, cr0 ; zero-counted control register => protected mode -> cpu
    and al, 11110011b ; transmission mode , reference - https://itguava.tistory.com/15
    or al, 00100010b ; components

    mov cr0, eax
    mov eax, cr4
    or eax, 0x200 ; logical shift op(right-side)
    mov cr4, eax

    fninit ; init fpu

; sse - one of X86 processor's Streaming SIMD Extensions(data movement) -> https://en.wikibooks.org/wiki/X86_Assembly/SSE
; -> to perform operations on a variety of datas and types
.sse:
    mov eax, cr4
    or ax, 0000011000000000b ; 0x0600, 32-bits TriCore TCP
    mov cr4, eax
    
    ret
