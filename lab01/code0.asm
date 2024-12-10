CODE SEGMENT
    ASSUME CS:CODE

PrintDou PROC
    MOV AH, 02H
    MOV DL, ','
    INT 21H
    RET
PrintDou ENDP

START:
    MOV CL, 1
LOOP0:
    MOV AH, 02H
    MOV DL, CL
    ADD DL, '0'
    INT 21H

    CMP CL, 9; 如果到9了，就不用再加逗号
    JE DONE
    CALL PrintDou

    INC CL
    JMP LOOP0

DONE:
    MOV AH, 4CH
    INT 21H

CODE ENDS

END START