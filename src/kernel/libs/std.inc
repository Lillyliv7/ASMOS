; kernel/libs/std.inc
; Made by Lilly on april 24, 2024

uint_16_to_string:
    ; pop dx
    mov cx,4          ; Start the counter: we want to print 4 characters
                        ; 4 bits per char, so we're printing a total of 16 bits

uint_16_to_string_loop:
    dec cx            ; Decrement the counter

    mov ax,dx         ; copy bx into ax so we can mask it for the last chars
    shr dx,4          ; shift bx 4 bits to the right
    and ax,0xf        ; mask ah to get the last 4 bits

    mov bx, uint_16_to_string_out   ; set bx to the memory address of our string
    add bx, 2         ; skip the '0x'
    add bx, cx        ; add the current counter to the address

    cmp ax,0xa        ; Check to see if it's a letter or number
    jl uint_16_to_string_set_letter     ; If it's a number, go straight to setting the value
    add byte [bx],7   ; If it's a letter, add 7
                        ; Why this magic number? ASCII letters start 17
                        ; characters after decimal numbers. We need to cover that
                        ; distance. If our value is a 'letter' it's already
                        ; over 10, so we need to add 7 more.
    jl uint_16_to_string_set_letter

uint_16_to_string_set_letter:
    add byte [bx],al  ; Add the value of the byte to the char at bx

    cmp cx,0          ; check the counter, compare with 0
    je uint_16_to_string_done ; if the counter is 0, finish
    jmp uint_16_to_string_loop     ; otherwise, loop again

uint_16_to_string_done:
    ret

uint_16_to_string_out: db '0x0000',0
