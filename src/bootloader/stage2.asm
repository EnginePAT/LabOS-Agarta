org 0x1000
bits 16

%define ENDL 0x0D, 0x0A
KERNEL_LOCATION equ 0x8000

CODE_SEG equ GDT_code - GDT_start
DATA_SEG equ GDT_data - GDT_start

start:
    mov [BOOT_DRIVE], dl

    call disk_read

    ; Switch into protected mode
    cli                         ; Disable interrupts
    lgdt [GDT_descriptor]       ; Load the GDT
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE_SEG:start_p_mode   ; Jump to start protected mode label

    jmp $

;
; Puts: Prints a string to the screen
; Parameters:
;   - DS:SI point to string
;
puts:
    ; Save registers we will modify
    push si
    push ax
    push bx
.loop:
    lodsb                       ; Increment SI and load into AL
    cmp al, 0                   ; Null terminated?
    je .done                    ; If true, jump to .done label

    mov ah, 0x0e                ; BIOS print teletype
    mov bh, 0                   ; Page number = 0
    int 0x10                    ; BIOS print interrupt

    jmp .loop                   ; Loop until finished
.done:
    ; Restore modified registers and return
    pop bx
    pop ax
    pop si
    ret



;
; Disk read: Reads the disk to a specified memory address
;
disk_read:
    mov ah, 0x02                ; BIOS read sectors
    mov al, 1                   ; read 1 sector
    mov ch, 0x00                ; cylinder 0
    mov cl, 0x03                ; sector 3
    mov dh, 0x00                ; head 0
    mov dl, [BOOT_DRIVE]        ; drive
    mov bx, KERNEL_LOCATION     ; memory destination
    int 0x13
    jc disk_read_error

    ret

disk_read_error:
    ; Print the error messages
    mov si, msg_disk_read_failed
    call puts

    mov si, msg_wait_key
    call puts

    mov ah, 0
    int 0x16                    ; Wait for key
    jmp 0xFFFF:0                ; Jump to beginning of BIOS, should reboot




msg_stage2: db 'Hello world from stage 2 bootloader!!!', 0
msg_disk_read_failed:   db ENDL, 'Read from disk failed!', ENDL, 0
msg_wait_key:           db 'Press any key to continue...', 0
BOOT_DRIVE:             db 0


;
; Protected mode code. All real mode code must be above this.
;

; Define the GDT
GDT_start:
    GDT_null:
        dd 0x0
        dd 0x0
    
    GDT_code:
        dw 0xFFFF
        dw 0x0
        db 0x0
        db 0b10011010
        db 0b11001111
        db 0x0
    
    GDT_data:
        dw 0xFFFF
        dw 0x0
        db 0x0
        db 0b10010010
        db 0b11001111
        db 0x0

GDT_end:

GDT_descriptor:
    dw GDT_end - GDT_start - 1
    dd GDT_start

; Now start protected mode
[bits 32]
start_p_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000            ; 32-bit stack base pointer
    mov esp, ebp

    mov byte [0xb8000], 'A'
    mov byte [0xb8001], 0x02

    jmp KERNEL_LOCATION

    jmp $
