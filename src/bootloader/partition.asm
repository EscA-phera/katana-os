struc partition_reference
    .sys: resb 1
    .channel_start: resb 3
    .ty: resb 1
    .channel_end: resb 3
    .lba_start: resd 1
    .sector_count: resd 1

endstruc

fs_partition:
    xor ebx, ebx    

.loop:
    mov al, byte [partitions + partition_reference + partition_reference.ty]
    cmp al, 0x83
    je .if_found
    add ebx, 1
    cmp ebx, 4
    jb .loop
    jmp .if_not_found

.if_found:
    mov eax, [partitions + partition_rec + partition_rec.lba_start]
    ret

.if_not_found:
    mov si, .no_partition
    call print
    mov eax, (fs - boot) / 512

.no_partition:
    db "NO MBR PARTITION - 0x03" 0xA, 0xD, 0