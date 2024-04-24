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

mov si, loaded_message
call bios_print

jmp $

%include "src/kernel/display.inc"
%include "src/kernel/strings.inc"