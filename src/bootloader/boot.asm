; bootloader/boot.asm
; Made by Lilly on april 23, 2024

; Bootloader for ASMOS, just loads machine code from
; CHS sector 2, cylinder 0, head/platter 0 to sector 64, cylinder 0, head/platter 0
; and checks if it has the boot magic

[ORG 0x7c00]

setup_ds:
	xor ax, ax
	mov ds, ax
	cld

setup_stack:
	cli
	mov ds, ax             ; DS=0
	mov ss, ax             ; stack starts at seg 0
	mov sp, 0x4000         ; stack at 0x4000
	sti

clear_screen:
	mov ah, 0x00
	mov al, 0x03  ; text mode 80x25 16 colours
	int 0x10

load_kernel:
	mov si, load_bios_message
	call bios_print

	call read_kernel
	call verify_kernel

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
read_kernel:
	mov si, reading_kernel_message
	call bios_print

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


; Start of kernel should be

; jmp $+4
; BOOT_MAGIC db "as"

; This function checks to make sure the bytes "a" and "s"
; are in 0x8002 and 0x8003, similar to how the bootloader
; is verified by the bios with 0xaa55 at the end of the
; first sector

verify_kernel:
	pusha
	mov al, [0x8002]
	mov ah, 0x61
	cmp al, ah
	jne kernel_error

	mov al, [0x8003]
	mov ah, 0x73
	cmp al, ah
	jne kernel_error
	popa
	ret

kernel_error:
	mov si, kernel_error_message
	call bios_print
	jmp hang


load_bios_message db 'ASMOS BOOTLOADER', 13, 10, 0
reading_kernel_message db 'READ KERNEL.BIN FROM HDA SECTOR 2, CYLINDER 0, HEAD 0 TO SECTOR 64, CYLINDER 0, HEAD 0. 31.5 KIBIBYTES IN TOTAL', 13, 10, 0
kernel_error_message db 'Not a bootable file', 13, 10, 0

times 510-($-$$) db 0 ; fill rest of boot sector with 0 bytes

; boot magic 0xaa55

db 0x55
db 0xaa
