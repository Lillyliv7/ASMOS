; kernel/kernel.asm
; Made by Lilly on april 23, 2024

; Kernel.bin gets loaded at 0x8000
; (0x201 bytes after the end of the bootloader)

; os.bin file structure
; |> boot.bin
; | 0x0 to 0x200
; | 0x7c00 to 0x7dff in memory (1 sector)
;    |> boot.asm
; |> kernel.bin
; | 0x201 to 0x8001
; | 0x8000 to 0xfe00 in memory (63 sectors)
;    |> boot magic (12 bytes)
;    |> kernel.asm
;       |> display.inc
;       |> strings.inc

; Entire operating system fits into 32 kibibytes :3c
[ORG 0x8000]

; For the bootloader to verify our kernel
jmp $+14
BOOT_MAGIC db 'asmos_kernel'

kernel:
    call init_stacks

    call clear_screen

    ; mov si, loaded_message
    ; call bios_print

    mov ax, 0x70
    mov bx, bios_print
    call setInterrupt

    ; mov si, uint_16_to_string_in
    ; mov word [uint_16_to_string_in], 0xfafa
    ; mov dx, 0xfafa

    ; call uint_16_to_string
    ; mov si, uint_16_to_string_out

    ; pusha
    ; int 0x70
    ; popa

    mov si, swap_stack_text_1
    ; push si
    int 0x70

    cli
    call swap_stack
    mov si, swap_stack_text
    ; mov sp, si
    ; pop si
    call bios_print
    call swap_stack
    sti
    
    mov si, loaded_message
    int 0x70

    jmp $

%include "src/kernel/display.inc"
%include "src/kernel/strings.inc"
%include "src/kernel/libs/std.inc"
%include "src/kernel/int.inc"
%include "src/kernel/stacks.inc"

swap_stack_text db "this is in our second stack", 13, 10, 0
swap_stack_text_1 db "this is our first stack", 13, 10, 0