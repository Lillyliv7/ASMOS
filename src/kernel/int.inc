; kernel/int.inc
; Made by Lilly on april 24, 2024

; ax=interrupt number
; bx=pointer to function
;
setInterrupt:

    mov di, bx

    xor ah, ah				; AX := interrupt number
	shl ax, 2				; each interrupt vector is 4 bytes long
	mov si, ax				; SI := byte offset of user-specified entry
	
	mov ax, INTERRUPT_VECTOR_TABLE
	mov ds, ax				; DS := IVT segment
	; DS:SI now points to 2-word interrupt vector
	
	mov word bx, [ds:si]	; BX := old handler offset
	mov word dx, [ds:si+2]	; DX := old handler segment
	; DX:BX now points to the old interrupt handler
	
	; now install new interrupt handler
	; pushf
	cli						; ensure we don't get interrupted in-between
							; the two instructions below
	mov word [ds:si], di	; offset of new interrupt handler
	mov word [ds:si+2], es	; segment of new interrupt handler

    ret

INTERRUPT_VECTOR_TABLE equ 0000h