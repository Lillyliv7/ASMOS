; kernel/display.inc
; Made by Lilly on april 23, 2024

[org 0x8000]

bios_print:
	pusha
bios_print_loop:
	lodsb
	or al, al  ;zero=end of str
	jz done    ;get out
	mov ah, 0x0E
	mov bh, 0
	int 0x10
	jmp bios_print_loop
done:
	popa
	ret

clear_screen:
	pusha
	mov ah, 0x00
	mov al, 0x03  ; text mode 80x25 16 colours
	int 0x10
	popa
	ret