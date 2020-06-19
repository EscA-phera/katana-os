interrupt_table:
    b . ; jmp to itself in x86 CPU - https://stackoverflow.com/questions/48084634/what-does-b-mean-in-this-assembly-code
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