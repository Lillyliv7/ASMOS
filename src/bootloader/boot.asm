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
	; call delay_before_start

	jmp 0x8000 ; kernel is loaded at 0x8000

hang:
	jmp hang

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

	mov si, kernel_read_message
	call bios_print

	ret


; Start of kernel should be

; jmp $+14
; BOOT_MAGIC db 'asmos_kernel'

; This function compares byte 0x8002 to byte 0x8002+boot_magic_length
; to boot_magic to check if kernel.bin is a bootable file similar to
; how the BIOS verifies bootloaders by checking for 0xaa55 at the end
; of the first sector.

; in psuedocode
; verify_kernel() {
; 	for (uint_16 bx = 0; bx < boot_magic_length; bx++) {
; 		if (!(uint_8 *)0x8002+bx == boot_magic[bx]) {
; 			kernel_error();
; 		}
; 	}
; }
;

verify_kernel:
	pusha
	xor bx, bx
verify_kernel_loop:

	cmp bx, [boot_magic_length]
	je verify_kernel_done

	mov cx, [0x8002+bx]
	mov dx, [boot_magic+bx]
	cmp cl, dl
	jne kernel_error

	inc bx

	jmp verify_kernel_loop

verify_kernel_done:
	popa
	ret

kernel_error:
	mov si, kernel_error_message
	call bios_print
	jmp hang


; Delays the startup by delay_before_start seconds and sends a message
; once a second before loading the kernel

; psuedocode
; delay_before_start() {
; 	for(uint_8 al = delay_before_start_seconds; al != 0; al--) {
; 		uint8 bl = '0';
; 		uint8 dl = al + bl;
;
; 		*(*delay_before_start_message + 11) = dl;
; 		print(delay_before_start_message);
; 		sleep(10);
; 	}
; }

delay_before_start:
	pusha
	mov al, [delay_before_start_seconds]
delay_before_start_loop:
	cmp al, 0
	je delay_before_start_done

	mov bl, '0'
	mov dl, al
	add dl, bl

	mov bx, delay_before_start_message
	add bx, 11
	mov [bx], dl

	mov si, delay_before_start_message
	call bios_print

	pusha
	mov ah, 0x86
	xor dx, dx
	mov cx, 10
	int 0x15
	popa

	dec al

	jmp delay_before_start_loop

delay_before_start_done:
	popa
	ret

load_bios_message db 'ASMOS BOOTLOADER', 13, 10, 0
reading_kernel_message db 'READ KERNEL.BIN FROM HDA SECTOR 2, CYLINDER 0, HEAD 0 TO SECTOR 64, CYLINDER 0, HEAD 0. 31.5 KIBIBYTES IN TOTAL', 13, 10, 0
kernel_error_message db 'NOT A BOOTABLE FILE', 13, 10, 0
delay_before_start_message db 'BOOTING IN 0', 13, 10, 0
delay_before_start_seconds db 5
delay_before_start_number_position db 11, 0
kernel_read_message db 'KERNEL.BIN READ!', 13, 10, 0

boot_magic db 'asmos_kernel'
boot_magic_length db 12

times 510-($-$$) db 0 ; fill rest of boot sector with 0 bytes

; boot magic 0xaa55

db 0x55
db 0xaa
