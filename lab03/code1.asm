data segment
    input_msg db 'Please input a binary string: $'
    intput_buffer db 100, 100, 100 dup(?)
    error_msg db 'The input string is not binary string!', '$'
    hexa_msg db 'The hexa string of binary string is: $'
    hexa_str db 100 dup(0)
    deci_msg db 'The deci string of binary string is: $'
    len db 0
    hex_chars db '0123456789ABCDEF$'
    output_number db 0
    decimal_number db 0
    number db 0
data ends

stack segment
    dw 128 dup(?)
stack ends

code segment
    assume cs: code, ds: data, ss: stack

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
    ret
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

;description 输出十六进制
output_deci PROC
    mov ah, 9
    lea dx, deci_msg
    int 21h
    
    mov al, number
    mov output_number, al

    call output

    mov ah, 2
    mov dl, 'D'
    int 21h

    call print_crlf
    ret
output_deci ENDP


output_hexa PROC ; 输出一个十进制数的十六进制表示 decimal_number 
    push ax
    push bx
    push cx
    push dx
    mov al, decimal_number
    mov bl, 16
    div bl
    mov bx, ax
    mov ah, 2

    mov si, bx
    and si, 0fh
    mov dl, hex_chars[si]
    int 21h
    mov si, bx
    mov cl, 8
    shr si, cl
    mov dl, hex_chars[si]
    int 21h
    mov dl, 'H'
    int 21h
    pop dx
    pop cx
    pop bx
    pop ax
    ret
output_hexa ENDP

start:
    mov ax, data
    mov ds, ax

    mov ah, 9
    lea dx, input_msg
    int 21h

    lea dx, intput_buffer
    mov ah, 0ah
    int 21h
    call print_crlf
    
    xor cx, cx
    mov cl, intput_buffer+1
    mov si, 0
    lea bx, intput_buffer+2
    mov number, 0

check_loop:
    mov ah, 2
    mov dl, [bx][si]
    ; int 21h
    cmp dl, '0'
    ; call print_crlf
    je check_loop_next_char
    cmp dl, '1'
    je check_loop_next_char
    mov ah, 9
    lea dx, error_msg
    int 21h
    call print_crlf
    jmp done

check_loop_next_char:
    shl number, 1
    add number, dl
    sub number, '0'
    inc si
    loop check_loop
    
    call output_deci

    mov al, number
    mov decimal_number, al
    mov ah, 9
    lea dx, hexa_msg
    int 21h
    call output_hexa
done:
    mov ax, 4c00h
    int 21h
code ends
end start