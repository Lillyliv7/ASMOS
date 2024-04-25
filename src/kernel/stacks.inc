; kernel/values.inc
; Made by Lilly on april 24, 2024

current_stack db 0
sp_0 dw 0x0000
sp_1 dw 0x7DFF

init_stacks:
    mov [sp_0], sp
    ret

;
; VERY UNSAFE, make sure to cli while not using the default stack
;
swap_stack:
    pop di ; save the pointer from the call instruction
    mov al, 0
    cmp [current_stack], al
    je swap_stack_1
    jne swap_stack_0

swap_stack_0: ; stack is currently 0
    mov al, 1
    mov [current_stack], al
    mov si, sp_0
    mov [si], sp
    mov si, sp_1
    mov sp, [si]
    jmp swap_stack_done
swap_stack_1: ; stack is currently 1
    mov [current_stack], al
    mov si, sp_1
    mov [si], sp
    mov si, sp_0
    mov sp, [si]
    jmp swap_stack_done
swap_stack_done:
    push di ; load the pointer from the call instruction onto our new stack
    ret