interrupt_table:
    b .
    b .
    b .
    b .
    b .
    b .
    b .
    b .

.comm stack, 0x10000

_start:
    .globl _start
    ldr sp, =stack+0x10000
    bl main_fuction

    b 1b