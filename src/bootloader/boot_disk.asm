sectalign off

%include "boot_x86_64.asm"

s_end:
    %ifdef KERNEL
    kernel_file:
        %defstr KERNEL_STR %[KERNEL]
        incbin KERNEL_STR

    .end:
        align 512, db 0
    
    %else
        align BLOCK_SIZE, db 0
        %ifdef FILESYSTEM
            filesystem:
                %defstr FILESYSTEM_STR %[FILESYSTEM]
                incbin FILESYSTEM_STR
            
            .end:
                align BLOCK_SIZE, db 0
            
            %else
                filesystem:
            %endif