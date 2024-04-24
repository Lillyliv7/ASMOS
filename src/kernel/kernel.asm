[ORG 0x8000]

mov si, loaded_message
call bios_print

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

loaded_message db "Kernel loaded!", 13, 10, 0