; bootloader/boot.asm
; Made by Lilly on april 23, 2024

; Bootloader for ASMOS, just loads machine code from
; CHS sector 2, head/platter 0 to sector 64, head/platter 0
; Doesn't have any checks or safety features so good luck

[ORG 0x7c00]

xor ax, ax
mov ds, ax
cld

cli
mov ds, ax             ; DS=0
mov ss, ax             ; stack starts at seg 0
mov sp, 0x4000         ; stack at 0x4000
sti

mov si, load_bios_message
call bios_print
call load_kernel
jmp 0x8000 ; kernel is loaded at 0x8000

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

; Read kernel from hard drive/floppy
load_kernel:
	mov dl,0x80		; Drive number
	mov dh,0 		; This is head number/platter number
	mov ch,0  		; This is cylinder number
	mov cl,2 		; Sector number
	mov ah,0x02 	; interrupt function
	mov al,64 		; Number of sectors to be read
	xor bx,bx
	mov es,bx 		; Making es=0
	mov bx,0x8000	; Load kernel to 0x8000
	int 0x13
	ret

load_bios_message db 'Bootloader Loading...', 13, 10, 0

times 510-($-$$) db 0 ; fill rest of boot sector with 0 bytes

; boot magic 0xaa55

db 0x55
db 0xaa
