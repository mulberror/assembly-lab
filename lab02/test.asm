data segment
    output_number db 0
    input_number db 0
    neg_flag db 1
    in_buff db 100, 100, 100 dup(0)
data ends

stack segment
    dw 128 dup(0)
stack ends

code segment
    assume cs:code, ds:data, ss:stack

;description: output a number (-127~127) from output_number （可直接用）
output PROC
    cmp output_number, 0
    jge one_bit
    mov ah, 2
    mov dl, '-'
    int 21h
    mov al, output_number
    mov bl, -1
    imul bl
    mov output_number, al
one_bit:
    cmp output_number, 10
    jge two_bits
    mov dl, output_number
    add dl, '0'
    mov ah, 2
    int 21h
    ret
two_bits:
    push ax
    push cx
    push bx
    cmp output_number, 100
    jge three_bits
    mov al, output_number
    xor ah, ah
    mov ch, 10
    div ch
    mov bx, ax
    mov ah, 2
    mov dl, bl
    add dl, '0'
    int 21h
    mov dl, bh
    add dl, '0'
    int 21h
    pop bx
    pop cx
    pop ax
    ret
three_bits:
    mov al, output_number
    xor ah, ah
    mov ch, 100
    div ch
    mov bx, ax
    mov ah, 2
    mov dl, bl
    add dl, '0'
    int 21h
    mov al, bh
    xor ah, ah
    mov ch, 10
    div ch
    mov bx, ax
    mov ah, 2
    mov dl, bl
    add dl, '0'
    int 21h
    mov dl, bh
    add dl, '0'
    int 21h
    pop bx
    pop cx
    pop ax
    ret
output ENDP


;description 输出一个回车（可直接用）
print_crlf PROC
    push ax
    push dx

    mov ah, 2
    mov dl, 0dh
    int 21h

    mov ah, 2
    mov dl, 0ah

    int 21h

    pop dx
    pop ax
    ret
print_crlf ENDP

;description 输入一个 -127 ~ +127 以内的数字到 input_number 中
in_num PROC
    push ax
    push bx
    push cx
    push dx
    
    lea dx, in_buff
    mov ah, 0ah
    int 21h
    xor ch, ch
    mov cl, in_buff+1

    ; dec cx
    lea bx, in_buff+2
    mov si, 0
    mov al, 0
    mov neg_flag, 1
input_loop:
    mov dl, [bx][si]
    cmp dl, '-'
    jne in_num_skip
    mov neg_flag, -1
    jmp in_num_next_char
in_num_skip:
    sub dl, '0'
    mov dh, 10
    mul dh
    add al, dl
in_num_next_char:
    inc si
    loop input_loop
    
    mov bl, neg_flag
    imul bl

    mov input_number, al

    pop dx
    pop cx
    pop bx
    pop ax
    ret
in_num ENDP

start:
    mov ax, data
    mov ds, ax

    call in_num
;     cmp input_number, 100
;     jne not_hundred
;     mov dl, '^'
;     mov ah, 2
;     int 21h

; not_hundred:
    call print_crlf
    mov al, input_number
    mov output_number, 100
    call output

    mov ah, 4ch
    int 21h
code ends
end start