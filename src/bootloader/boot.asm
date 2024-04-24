; bootloader/boot.asm
; made by Lilly on april 23, 2024

[ORG 0x7c00]

xor ax, ax
mov ds, ax
cld

mov si, load_bios_message
call bios_print

hang:
	jmp hang

bios_print:
	lodsb
	or al, al  ;zero=end of str
	jz done    ;get out
	mov ah, 0x0E
	mov bh, 0
	int 0x10
	jmp bios_print
done:
	ret

load_bios_message db 'Bootloader Loading...', 13, 10, 0


times 510-($-$$) db 0 ; fill rest of boot sector with 0 bytes

; boot magic 0xaa55

db 0x55
db 0xaa
