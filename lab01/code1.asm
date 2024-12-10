; 先输出数字 然后输出后面的符号(如果是10的倍数输出换行，否则输出逗号)

DATA SEGMENT
    msg2 DB 'Input the step: $'
    step DB 1
    cnt DB 0
DATA ENDS

STACK SEGMENT
    DW 128 DUP(0)
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE, SS:STACK, DS:DATA

PrintSpace PROC ; 输出空格
    PUSH AX
    PUSH DX
    MOV AH, 02H
    MOV DL, 20H
    INT 21H
    POP DX
    POP AX
    RET
PrintSpace ENDP

PrintDou PROC ; 输出逗号
    PUSH AX
    PUSH DX
    MOV AH, 02H
    MOV DL, ','
    INT 21H
    POP DX
    POP AX
    RET
PrintDou ENDP

PrintEnter PROC ; 输出回车
    PUSH AX
    PUSH DX
    MOV AH, 02H
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H
    POP DX
    POP AX
    RET
PrintEnter ENDP

OUTPUT0 PROC ; 输出1位数
    CALL PrintSpace
    CALL PrintSpace
    MOV AH, 02
    MOV DL, CL
    ADD DL, '0'
    INT 21H
    RET
OUTPUT0 ENDP   

OUTPUT1 PROC ; 输出2位数
    CALL PrintSpace
    MOV AL, CL
    MOV AH, 0
    MOV CH, 10
    DIV CH
    MOV BX, AX

    MOV AH, 02
    MOV DL, BL
    ADD DL, '0'
    INT 21H
    MOV DL, BH
    ADD DL, '0'
    INT 21H
    RET
OUTPUT1 ENDP

OUTPUT2 PROC ; 输出100
    MOV AH, 02
    MOV DL, '1'
    INT 21H
    MOV DL, '0'
    INT 21H
    MOV DL, '0'
    INT 21H
    RET
OUTPUT2 ENDP

START:
    MOV AX, DATA
    MOV DS, AX
    MOV DX, OFFSET msg2
    MOV AH, 09H
    INT 21H
    
    MOV AH, 01H
    INT 21H
    SUB AL, '0'
    MOV step, AL
    CALL PrintEnter

    MOV CL, 1
LOOP0:
    CMP CL, 100
    JG DONE
    CMP CL, 10
    JGE BIT2
BIT1:
    CALL OUTPUT0
    JMP SYMBOL
BIT2:
    CMP CL, 100
    JE OUTPUT20
    CALL OUTPUT1
    JMP SYMBOL

OUTPUT20:
    CALL OUTPUT2
    JMP SYMBOL

SYMBOL:
    INC cnt
    CMP cnt, 10
    JE PrintEnter0
    CALL PrintDou
    JMP NEXT

PrintEnter0:
    CALL PrintEnter
    MOV cnt, 0
    JMP NEXT

NEXT:
    ADD CL, step
    JMP LOOP0

DONE:
    MOV AH, 4CH
    INT 21H

CODE ENDS

END START