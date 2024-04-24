; bootloader/boot.asm
; made by Lilly on april 23, 2024

hang:
	jmp hang

times 510-($-$$) db 0 ; fill rest of boot sector with 0 bytes

; boot magic 0xaa55

db 0x55
db 0xaa
