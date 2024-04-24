; kernel/display.inc
; Made by Lilly on april 23, 2024

[org 0x8000]

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
