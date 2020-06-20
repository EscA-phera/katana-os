transform:
    .ready: dq 0
    .cpu: dq 0
    .table: dq 0
    .stack_first: dq 0
    .stack_end: dq 0
    .code: dq 0

    times 512 - ($-transform) db 0

start_app:
    cli

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov sp, 0x7c00 ; stack initialize

    call 