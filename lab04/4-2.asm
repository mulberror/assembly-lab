DATA SEGMENT
    STRA DB 100, 0, 100 DUP(0)
    STRB DB 100, 0, 100 DUP(0)
    TIPS1 DB 'Please enter array A:$'
    TIPS2 DB 'Please enter array B:$'
    TIPS3 DB 0DH, 0AH, '$'
    TIPS4 DB 'The intersection of A and B:$'
    TIPS5 DB 'The Union of A and B:$'
    TIPS6 DB 'The difference set of A and B:$'
    ANS DB 100 DUP(0)
DATA ENDS

STACK SEGMENT
    DW 100 DUP(0)
STACK ENDS

CODE SEGMENT
;description ���һ���ո񣨿�ֱ���ã�
print_space PROC
    push ax
    push dx
    mov ah, 2
    mov dl, ' '
    int 21h
    pop dx
    pop ax
    ret
print_space ENDP

start:
    ASSUME CS:CODE, DS:DATA, SS:STACK
    MOV AX, DATA
    MOV DS, AX
    MOV ES, AX
    MOV AX, STACK
    MOV SS, AX  
    
    
    LEA DX, TIPS1 ;��ʾ�û���������A
    MOV AH, 09H
    INT 21H    
    
    LEA DX, STRA ;��ʾ�û������ַ���1
    MOV AH, 0AH
    INT 21H
    
    LEA DX, TIPS3 ;����س����з�
    MOV AH, 09H
    INT 21H 
    
    
    LEA DX, TIPS2 ;��ʾ�û���������A
    MOV AH, 09H
    INT 21H    
    
    LEA DX, STRB ;��ʾ�û������ַ���1
    MOV AH, 0AH
    INT 21H
    
    LEA DX, TIPS3 ;����س����з�
    MOV AH, 09H                                                                  
    INT 21H
    
op1: ;���㽻��
    MOV SI, 0
    MOV DI, 0 ;
    LEA BX, ANS ;�õ�����ַ������׵�ַ
   
op1_2:
    MOV AL, [STRA+SI+2] ;ȡ���ַ���StrA�е�һ���ַ�
    MOV AH, [STRB+DI+2] ;ȡ���ַ���StrB�е�һ���ַ�
    INC DI
    CMP AL, AH ;�ж������ַ��Ƿ����
    JE op1_4
    MOV CL, STRB+1 ;�ж��ַ���StrB�Ƿ��Ѿ�������
    MOV CH, 0
    CMP CX, DI
    JE op1_3               
    JMP op1_2
    
op1_3: ;�����ַ���StrA�е���һ���ַ�
    INC SI
    MOV DI, 0
    MOV CL, STRA+1 ;�ж��ַ���StrA�Ƿ��Ѿ�������
    MOV CH, 0
    CMP CX, SI
    JNE op1_2
    JMP op1_last 

op1_4:
    LEA DI, ANS
    
    
op1_5:
    CMP DI, BX
    JE op1_6
    MOV AL, [DI]
    MOV AH, [STRA+SI+2]
    CMP AL, AH
    JE op1_3
    INC DI
    JMP op1_5  
             
op1_6:
    MOV AL, [STRA+SI+2]
    MOV [BX], AL
    INC BX
    JMP op1_3
    
op1_last:
    MOV CX, BX
    LEA BX, ANS
    SUB CX, BX
    
    LEA DX, TIPS4 ;��ʾ�û���Ҫ���A��B�Ľ���
    MOV AH, 09H
    INT 21H     
    
op1_last1:
    CMP CX, 0
    JE op2
    MOV DL, [BX]
    INC BX
    MOV AH, 02H
    INT 21H
    DEC CX
    JMP op1_last1
    
    
op2:
    LEA DX, TIPS3 ;����س����з�
    MOV AH, 09H                                                                  
    INT 21H
    
    MOV SI, 0 ;�������ַ�����λ��
    MOV DI, 0 ;����A��λ��
 
    MOV CL, STRA+1
    MOV CH, 0
    
op2_1:
    CMP CX, 0 ;�ж�A�Ƿ��Ѿ�������
    JE op2_5 
    LEA BX, ANS
    MOV DX, BX
    ADD DX, SI 
    
op2_2:  
    CMP BX, DX ;ѭ�������жϸ��ַ��Ƿ��Ѿ������ڽ����
    JE op2_3 
    MOV AL, [BX]
    INC BX
    MOV AH, [STRA+2+DI]
    CMP AH, AL
    JE op2_4
    JNE op2_2
    
op2_3: ;û���ڽ���б�������ͬ���ַ����Ѹ��ַ����뵽�����
    MOV AL, [STRA+2+DI]
    MOV [ANS+SI], AL
    INC SI
    INC DI
    DEC CX
    JMP op2_1

op2_4: ;�ڽ���б�������ͬ���ַ����Ѹ��ַ����뵽�����
    INC DI
    DEC CX
    JMP op2_1
    
op2_5:
    MOV CL, STRB+1 ;��B�е����ݼ�������
    MOV CH, 0
    MOV DI, 0
    
op2_6:
    CMP CX, 0 ;�ж�B�е������Ƿ��Ѿ�������
    JE op2_last
    LEA BX, ANS
    MOV DX, BX
    ADD DX, SI
    
op2_7:
    CMP BX, DX ;ѭ���Ƚϸ��ַ��Ƿ��Ѿ������ڽ����
    JE op2_8 
    MOV AL, [BX]
    INC BX
    MOV AH, [STRB+2+DI]
    CMP AH, AL
    JE op2_9
    JNE op2_7
    
op2_8:
    MOV AL, [STRB+2+DI] ;�����ַ����뵽�����
    MOV [ANS+SI], AL
    INC SI
    INC DI
    DEC CX
    JMP op2_6


op2_9:
    INC DI
    DEC CX
    JMP op2_6
    
op2_last:
    LEA DX, TIPS5 ;��ʾ�û���Ҫ���A��B�Ľ���
    MOV AH, 09H
    INT 21H
    
    MOV CX, SI
    MOV SI, 0     
    
op2_last1: ;������յĲ���
    CMP SI, CX
    JE op3
    MOV DL, [ANS+SI]
    MOV AH, 02H
    INT 21H
    call print_space
    INC SI
    JMP op2_last1


op3: ;���A-B
    MOV SI, 0 ;��¼����A���ַ�λ��
    LEA BX, ANS ;�õ�����ַ������׵�ַ
    
op3_1:
    MOV DI, 0
    MOV AL, STRA+1
    MOV AH, 0
    CMP AX, SI
    JE op3_last
     
op3_2: ;������B�в����Ƿ��������A��Ӧ���ַ�
    MOV AL, STRB+1
    MOV AH, 0
    CMP AX, DI
    JE op3_3
    MOV AL, [STRB+DI+2]
    INC DI
    MOV AH, [STRA+SI+2]
    CMP AH, AL
    JE op3_6
    JMP op3_2


op3_3: ;������B��û���ҵ�����A��Ӧ���ַ�����ʱӦ�ü�������Ƿ��Ѿ����ֹ�
    MOV AX, BX
    LEA DX, ANS
    SUB AX, DX
    MOV DI, 0

op3_4:
    CMP AX, 0 ;�ڽ���б����Ƿ��Ѿ����ֹ����ַ�
    JE op3_5
    DEC AX
    MOV CL, [ANS+DI]
    INC DI
    MOV CH, [STRA+2+SI]
    CMP CH, CL
    JE  op3_6 
    JMP op3_4
    
op3_5:
    MOV AL, [STRA+2+SI] ;�ڽ���м���A�е��ַ�
    MOV [BX], AL 
    INC BX

op3_6:
    INC SI
    JMP op3_1
    
op3_last:
    LEA DX, TIPS3 ;��ʾ�û���������A
    MOV AH, 09H
    INT 21H
    
    LEA DX, TIPS6 ;��ʾ�û���������A
    MOV AH, 09H
    INT 21H
    
    MOV CX, BX
    LEA BX, ANS

op3_last1: ;ѭ���������е���������
    CMP BX, CX
    JE LAST
    MOV DL, [BX]
    MOV AH, 02H
    INT 21H
    call print_space
    INC BX
    JMP op3_last1
       
    
LAST:
    LEA DX, TIPS3 ;����س����з�
    MOV AH, 09H
    INT 21H      

exit:   
    MOV AH, 4CH
    INT 21H
             
CODE ENDS

end start