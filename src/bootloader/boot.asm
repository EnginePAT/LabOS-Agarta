[org 0x7c00]
[bits 16]


%define ENDL 0x0D, 0x0A

KERNEL_LOCATION equ 0x1000


start:
    mov [BOOT_DRIVE], dl        ; Save the BIOS provided boot driver number

    ; Setup data segments
    xor ax, ax                  ; Can't set DS/ES directly
    mov ds, ax
    mov es, ax

    ; Setup stack
    mov ss, ax
    mov bp, 0x8000
    mov sp, bp

    ; Clear the screen
    call clear_screen

    ; Print hello world message
    mov si, msg_hello
    call puts

    call disk_read

    jmp KERNEL_LOCATION

    jmp $                       ; Halt the system


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
; Clear screen: Clears the screen
; Parameters:
;   - AH = 0x0 for clear
;   - AL = 0x03 for VGA text mode
;
clear_screen:
    pusha
    mov ah, 0x0
    mov al, 0x03
    int 0x10
    popa
    ret



;
; Disk read: Reads the disk to a specified memory address
;
disk_read:
    mov bx, KERNEL_LOCATION
    mov dh, 2

    mov ah, 0x02
    mov al, dh
    mov ch, 0x00
    mov dh, 0x00
    mov cl, 0x02
    mov dl, [BOOT_DRIVE]

    int 0x13                    ; BIOS disk read interrupt
    jc disk_read_error          ; If carry flag set, jump to error

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


;
; Messages
;
msg_hello:              db 'Hello, world!', ENDL, 0
msg_disk_read_failed:   db 'Read from disk failed!', ENDL, 0
msg_wait_key:           db 'Press any key to continue...', 0
BOOT_DRIVE:             db 0


times 510-($-$$) db 0
dw 0xaa55
