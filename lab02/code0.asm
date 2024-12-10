; program to count the number of upper case, lower case, numbers, spaces and special characters in a string

data segment
    mess db 'please enter a string: ', '$'
    in_buff db 100, 100, 100 dup(0)
    upper_tot db 0
    lower_tot db 0
    number_tot db 0
    space_tot db 0
    special_tot db 0
    output_number db 0
    upper_msg db 'Upper case: $'
    lower_msg db 'Lower case: $'
    number_msg db 'Numbers: $'
    space_msg db 'Spaces: $'
    special_msg db 'Special characters: $'
data ends

stack segment
    dw 128 dup(0)
stack ends

code segment
    assume cs:code, ds:data, ss:stack

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

;description: output a number from output_number （可直接用）
output PROC
    cmp output_number, 0
    jge one_bit
    mov ah, 2
    mov dl, '-'
    int 21h

one_bit:
    cmp output_number, 10
    jge two_bits
    mov dl, output_number
    add dl, '0'
    mov ah, 2
    int 21h
    call print_crlf
    ret
two_bits:
    push ax
    push cx
    push bx

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

    call print_crlf
    ret
output ENDP

start:
    mov ax, data
    mov ds, ax
    mov dx, offset mess
    mov ah, 09h
    int 21h

    lea dx, in_buff
    mov ah, 0Ah
    int 21h
    
    xor ch, ch
    mov cl, in_buff+1
    dec cx
    lea bx, in_buff+2
    mov si, 0

display_loop:
    mov ah, 2
    mov dl, [bx][si]

upper_check:
    cmp dl, 'A'
    jl lower_check
    cmp dl, 'Z'
    jg lower_check
    inc upper_tot
    jmp next_char

lower_check:
    cmp dl, 'a'
    jl number_check
    cmp dl, 'z'
    jg number_check
    inc lower_tot
    jmp next_char

number_check:
    cmp dl, '0'
    jl space_check
    cmp dl, '9'
    jg space_check
    inc number_tot
    jmp next_char

space_check:
    cmp dl, ' '
    jne special_check
    inc space_tot
    jmp next_char

special_check:
    inc special_tot

next_char:
    inc si
    loop display_loop

    call print_crlf

    mov dx, offset upper_msg
    mov ah, 09h
    int 21h
    mov cl, upper_tot
    mov output_number, cl
    call output

    mov dx, offset lower_msg
    mov ah, 09h
    int 21h
    mov cl, lower_tot
    mov output_number, cl
    call output

    mov dx, offset number_msg
    mov ah, 09h
    int 21h
    mov cl, number_tot
    mov output_number, cl
    call output

    mov dx, offset space_msg
    mov ah, 09h
    int 21h
    mov cl, space_tot
    mov output_number, cl
    call output


    mov dx, offset special_msg
    mov ah, 09h
    int 21h
    mov cl, special_tot
    mov output_number, cl
    call output

    mov ah, 4ch
    int 21h
code ends
end start