DATA SEGMENT
    STR1 DB 100, 0, 100 DUP(0)
    STR2 DB 100, 0, 100 DUP(0)
    CHOSE DB 0
    ANS DB 100 DUP(0)
    TIPS1 DB 0DH, 0AH, '$'
    TIPS2 DB 'string a: $'
    TIPS3 DB 'string b: $'
    TIPS4 DB '===================================', 0DH, 0AH, '$'
    TIPS5 DB '1: Search string b in string a.', 0DH, 0AH, '$'
    TIPS5_1 DB 'string b matches the position in string a:$'
    TIPS6 DB '2: Insert string b in string a.', 0DH, 0AH, '$'
    TIPS6_1 DB 'Please indicate where you want to insert:$'
    TIPS6_2 DB 'The given position exceeds the length limit of the string string a$'
    TIPS6_3 DB 'The resulting string after insertion:$'
    TIPS7 DB '3: Delete string b from string a.', 0DH, 0AH, '$'
    TIPS7_1 DB 'Delete all string b contents from the string string a:$'
    TIPS8 DB 'Please enter the option: $'
    TIPS9 DB '4:Flip string', 0DH, 0AH, '$'
    TIPS9_1 DB 'Flip of the string string a:$'
    TIPS9_2 DB 'Flip of the string string b:$'
    TIPS10 DB '5:exit', 0DH, 0AH, '$'
DATA ENDS

STACK SEGMENT
STACK ENDS

CODE SEGMENT
start:
   ASSUME CS:CODE,DS:DATA,SS:STACK
    MOV AX, DATA
    MOV DS, AX
    MOV ES, AX
    MOV AX, STACK
    MOV SS, AX
    
    LEA DX, TIPS2     
    MOV AH, 09H
    INT 21H
    
    LEA DX, STR1    
    MOV AH, 0AH
    INT 21H
    
    LEA DX, TIPS1    
    MOV AH, 09H
    INT 21H
    
    LEA DX, TIPS3     
    MOV AH, 09H
    INT 21H
    
    LEA DX, STR2   
    MOV AH, 0AH
    INT 21H     
    
    LEA DX, TIPS1   
    MOV AH, 09H
    INT 21H
    
    LEA DX, TIPS4    
    MOV AH, 09H
    INT 21H
    
    LEA DX, TIPS5    
    MOV AH, 09H
    INT 21H
    
    LEA DX, TIPS6    
    MOV AH, 09H
    INT 21H
    
    LEA DX, TIPS7   
    MOV AH, 09H
    INT 21H
    
    LEA DX, TIPS9    
    MOV AH, 09H
    INT 21H
    
    LEA DX, TIPS10   
    MOV AH, 09H
    INT 21H
    
    LEA DX, TIPS4    
    MOV AH, 09H
    INT 21H  
    
S_1:
    LEA DX, TIPS8   
    MOV AH, 09H
    INT 21H
    
    MOV AH, 01H
    INT 21H
    
    MOV CHOSE, AL
    
    CMP AL, 31H
    JE op1      
    CMP AL, 32H
    JE op2          
    CMP AL, 33H
    JE op3          
    CMP AL, 34H
    JE op4
    CMP AL, 35H
    JE exit 
    
op1: 
    LEA DX, TIPS1    
    MOV AH, 09H
    INT 21H

    LEA DX, TIPS5_1     
    MOV AH, 09H
    INT 21H
    
    MOV CL, STR2+1
    MOV CH, 0
    PUSH CX
    
    MOV SI, 2
    MOV DI, 0           
    LEA BX, STR1+2   
    
    MOV AL, STR1+1   
    
op1_1:
    MOV AH, [BX+DI]
    CMP AH, [STR2 + SI]
    JNE op1_2
    INC DI
    INC SI
    DEC CX
    CMP CX, 0
    JE op1_3
    JMP op1_1
    
op1_2:
    INC BX   
    DEC AL
    CMP AL, 0
    JE last  
    CMP AL, STR2+1 
    JB last
    MOV SI, 2
    MOV DI, 0
    POP CX
    PUSH CX
    JMP op1_1
    
op1_3:
    MOV CX, BX        
    LEA AX, STR1+2
    SUB CX, AX
    INC CX
    
    CMP CX, 09H      
    JBE op1_6
  
    MOV DL, 0
    
op1_4:
    CMP CX, 09H  
    JBE op1_5
    INC DL        
    SUB CX, 0AH
      
    JMP op1_4
    
op1_5:
    ADD DL, 30H   
    MOV AH, 02H
    INT 21H  
    
op1_6:
    MOV DL, CL     
    ADD DL, 30H
    MOV AH, 02H
    INT 21H
    
    MOV DL, 20H  
    MOV AH, 02H
    INT 21H
    
    JMP op1_2
    
op2:
    LEA DX, TIPS1    
    MOV AH, 09H
    INT 21H
    
    LEA DX, TIPS6_1    
    MOV AH, 09H
    INT 21H
    
    MOV AH, 01H      
    INT 21H
    MOV DL, AL
    SUB DL, 30H
    
    MOV BL, STR1+1   
    INC BL
    CMP DL, BL
    JA op2_error
    
    MOV SI, 2
    MOV DI, 0
    
op2_1:
    DEC DL             
    CMP DL, 0
    JE op2_2
    MOV AL, [STR1+SI]
    MOV [ANS+DI], AL
    INC DI
    INC SI
    JMP op2_1
    
op2_2:
    PUSH SI
    MOV SI, 2
    MOV CL, STR2+1
    MOV CH, 0

op2_3:                      
    MOV AL, [STR2+SI ]
    MOV [ANS+DI], AL
    INC SI
    INC DI
    LOOP op2_3
    
    POP SI

op2_4:                    
    MOV BL, STR1+1
    ADD BL, 2
    MOV BH, 0
 
    CMP SI, BX
    JAE op2_5
    
    MOV AL, [STR1+SI]
    MOV [ANS+DI], AL
    INC SI
    INC DI
    JMP op2_4
    
    
op2_5:
    MOV SI, 0
    
    LEA DX, TIPS1  
    MOV AH, 09H
    INT 21H  
    
    LEA DX, TIPS6_3    
    MOV AH, 09H
    INT 21H  
    
    
op2_6:
    MOV DL, [ANS+SI]  
    MOV AH, 02H
    INT 21H
    INC SI
    
    CMP SI, DI
    JNE op2_6   
  
    JMP last 
    
op2_error: 
    LEA DX, TIPS6_2  
    MOV AH, 09H
    INT 21H
             
             
op3: 
    LEA DX, TIPS1    
    MOV AH, 09H
    INT 21H

    LEA DX, TIPS7_1    
    MOV AH, 09H
    INT 21H
    
    LEA BX, STR1+1    
    MOV CX, 0
    
op3_1:
    MOV SI, 2
    MOV DI, 0
    INC BX
    PUSH BX
    MOV AL, STR2+1      
    MOV AH, 0
    
    LEA DX, STR1+2
    MOV BL, STR1+1
    MOV BH, 0
    ADD DX, BX
    POP BX
    SUB DX, BX
    CMP DX, AX
    JB op3_4 
    
    
op3_2:
    MOV AL, [BX+DI]         
    MOV AH, [STR2+SI]
    INC DI
    INC SI
    CMP AH, AL 
    JNE op3_3
    MOV AL, STR2+1      
    MOV AH, 0
    CMP DI, AX
    JNE op3_2
    
    MOV AL, STR2+1
    DEC AL
    MOV AH, 0
    ADD BX, AX
    JMP op3_1
    
    
op3_3:
    MOV AL, [BX]
    MOV SI, CX
    MOV [ANS+SI], AL
    INC CX
    
    JMP op3_1
    
op3_4:
    LEA AX, STR1+2
    MOV DL, STR1+1
    MOV DH, 0
    ADD DX, AX
    
op3_5:
    CMP BX, DX
    JE op3_print
    MOV AL, [BX]
    MOV SI, CX
    MOV [ANS+SI], AL
    INC CX
    INC BX
    JMP op3_5
         
op3_print:
    MOV SI, 0
    
op3_6:
    MOV DL, [ANS+SI]
    MOV AH, 02H
    INT 21H
    INC SI
    CMP SI, CX
    JE last
    JNE op3_6
    

op4:
    LEA DX, TIPS1    
    MOV AH, 09H
    INT 21H

    LEA DX, TIPS9_1    
    MOV AH, 09H
    INT 21H
    
    LEA BX, STR1+2
    MOV AL, STR1+1
    MOV CL, AL
    MOV AH, 0
    ADD BX, AX
    DEC BX
    MOV CH, 0

op4_1:
    MOV DL, [BX]
    MOV AH, 02H
    INT 21H
    
    DEC BX
    LOOP op4_1
    
    LEA DX, TIPS1    
    MOV AH, 09H
    INT 21H
    
    LEA DX, TIPS9_2    
    MOV AH, 09H
    INT 21H
    
    
op4_2:
    LEA BX, STR2+2
    MOV AL, STR2+1
    MOV CL, AL
    MOV AH, 0
    ADD BX, AX
    DEC BX
    MOV CH, 0
    
op4_3:
    MOV DL, [BX]
    MOV AH, 02H
    INT 21H
    
    DEC BX
    LOOP op4_3
    JMP last

last:
    LEA DX, TIPS1 
    MOV AH, 09H
    INT 21H
    JMP S_1

exit:   
    MOV AH, 4CH
    INT 21H
  
CODE ENDS

end start 
