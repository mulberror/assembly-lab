DATA SEGMENT
    String DB 'Hello, World!', 0DH, 0AH, '$'
    MENU DB '====================================', 0DH, 0AH
         DB '| Enter a number:                  |', 0DH, 0AH
         DB '| 1: Transfer string to lower case |', 0DH, 0AH
         DB '| 2: Transfer string to upper case |', 0DH, 0AH
         DB '| 3: Total number lower case       |', 0DH, 0AH
         DB '| 4: Total number upper case       |', 0DH, 0AH
         DB '| 5: Exit                          |', 0DH, 0AH
         DB '====================================', 0DH, 0AH, '$'
    ERROR DB 'Invalid input!', 0DH, 0AH, '$'
    EXITmsg DB 'Program exit!', 0DH, 0AH, '$'
    OUTPUTmsg DB 'Output: ', '$'
    lowNumMsg DB 'The number of lower case: ', '$'
    upNumMsg DB 'The number of upper case: ', '$'
    lowNum DB 0
    upNum DB 0
    len DB 0
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA

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

OUTPUT PROC; 输出转换后的字符串
    MOV AH, 09H
    MOV DX, OFFSET OUTPUTmsg
    INT 21H
    MOV DX, OFFSET String
    INT 21H
    RET
OUTPUT ENDP

TransferToLower PROC ; 将字符串转换为小写
    MOV BX, OFFSET String
    MOV SI, 0
LOOPL:
    MOV AL, [BX + SI]
    CMP AL, '$'
    JE DONEL
    CMP AL, 'A'
    JL SKIPL
    CMP AL, 'Z'
    JG SKIPL
    ADD AL, 20H
    MOV [BX + SI], AL
SKIPL:
    INC SI
    JMP LOOPL
DONEL:
    CALL OUTPUT
    JMP EXIT
    RET
TransferToLower ENDP

TransferToUpper PROC ; 将字符串转换为大写
    MOV BX, OFFSET String
    MOV SI, 0
LOOPU:
    MOV AL, [BX + SI]
    CMP AL, '$'
    JE DONEU
    CMP AL, 'a'
    JL SKIPU
    CMP AL, 'z'
    JG SKIPU
    SUB AL, 20H
    MOV [BX + SI], AL
SKIPU:
    INC SI
    JMP LOOPU
DONEU:
    CALL OUTPUT
    JMP EXIT
    RET
TransferToUpper ENDP

CalculateLower PROC ; 计算小写字母个数
    MOV BX, OFFSET String
    MOV SI, 0
LOOPL0:
    MOV AL, [BX + SI]
    CMP AL, '$'
    JE DONEL0
    CMP AL, 'a'
    JL SKIPL0
    CMP AL, 'z'
    JG SKIPL0
    INC lowNum
SKIPL0:
    INC SI
    JMP LOOPL0
DONEL0:
    MOV DX, OFFSET lowNumMsg
    MOV AH, 09H
    INT 21H
    MOV AH, 02H
    MOV DL, lowNum
    ADD DL, '0'
    INT 21H
    CALL PrintEnter
    JMP EXIT
    RET
CalculateLower ENDP
TransferToLowern:
    CALL TransferToLower
    RET
TransferToUppern:
    CALL TransferToUpper
    RET
CalculateLowern:
    CALL CalculateLower
    RET
CalculateUpper PROC ; 计算大写字母个数
    MOV BX, OFFSET String
    MOV SI, 0
LOOPU0:
    MOV AL, [BX + SI]
    CMP AL, '$'
    JE DONEU0
    CMP AL, 'A'
    JL SKIPU0
    CMP AL, 'Z'
    JG SKIPU0
    INC upNum
SKIPU0:
    INC SI
    JMP LOOPU0
DONEU0:
    MOV DX, OFFSET upNumMsg
    MOV AH, 09H
    INT 21H
    MOV AH, 02H
    MOV DL, upNum
    ADD DL, '0'
    INT 21H
    CALL PrintEnter
    JMP EXIT
    RET
CalculateUpper ENDP

START:
    MOV AX, DATA
    MOV DS, AX
    MOV DX, OFFSET MENU
    MOV AH, 09H
    INT 21H
INPUT: ; 输入菜单序号
    MOV AH, 01H
    INT 21H
    CALL PrintEnter
    CMP AL, '1'
    JE TransferToLowern
    CMP AL, '2'
    JE TransferToUppern
    CMP AL, '3'
    JE CalculateLowern
    CMP AL, '4'
    JE CalculateUpper
    CMP AL, '5'
    JE EXIT

    MOV DX, OFFSET ERROR; 如果输入不是1、2、3、4、5，输出错误信息
    MOV AH, 09H
    INT 21H
    JMP INPUT
EXIT:
    MOV DX, OFFSET EXITmsg
    MOV AH, 09H
    INT 21H

    MOV AH, 4CH
    INT 21H

CODE ENDS
END START