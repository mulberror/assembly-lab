data segment
    msg db 'Enter a character (if enter F1 exit): $'
    decimal_msg db 'The decimal value of the character is: $'
    hexa_msg db 'The hexadecimal value of the character is: $'
    hex_chars db '0123456789ABCDEF$'
    decimal_number db ?
    char db ?
    output_number db 0
    binary_string db '00000000$'
    binary_msg db 'The binary value of the character is: $'
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

output_binary PROC ; 输出一个十进制数的二进制表示 decimal_number 
    push ax
    push bx
    push cx
    push dx
    mov si, 0
    mov dl, 8
loop_output_binary:
    dec dl
    mov al, decimal_number
    mov cl, dl
    shr al, cl
    and al, 1
    add al, '0' 
    mov binary_string[si], al
    inc si
    cmp si, 8
    jne loop_output_binary
print_binary:
    mov ah, 9
    lea dx, binary_string
    int 21h
    mov ah, 2
    mov dl, 'B'
    int 21h
    pop dx
    pop cx
    pop bx
    pop ax
    ret
output_binary ENDP

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

start:
    mov ax, data
    mov ds, ax

main_loop:
    ; 显示提示信息
    mov ah, 9
    lea dx, msg
    int 21h

    ; 读取字符
    mov ah, 1
    int 21h

    cmp al, 0
    jne char_input
    
    int 21h
    call print_crlf
    cmp al, 3bh
    jne main_loop
    jmp done
    
char_input:
    mov char, al
    call print_crlf

    ; 输出字符的十进制值
    mov ah, 9
    lea dx, decimal_msg
    int 21h
    mov al, char
    mov output_number, al
    call output
    
    mov ah, 2
    mov dl, 'D'
    int 21h
    call print_crlf

    ; 输出字符的十六进制值
    mov ah, 9
    lea dx, hexa_msg
    int 21h

    mov al, char
    mov decimal_number, al
    call output_hexa
    call print_crlf

    ; 输出字符的二进制值
    mov ah, 9
    lea dx, binary_msg
    int 21h

    mov al, char
    mov decimal_number, al
    call output_binary
    call print_crlf

done:
    mov ax, 4c00h
    int 21h
code ends
end start