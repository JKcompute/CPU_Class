ORIGIN 0
SEGMENT
CodeSegment:
; initialize registers
	AND R0, R0, 0
	AND R1, R0, 0
	AND R2, R0, 0
	AND R3, R0, 0
	AND R4, R0, 0
	AND R5, R0, 0
	AND R6, R0, 0
	AND R7, R0, 0
; Test jump , we do not want that load	
	LEA R1, loadstoretests
	JMP R1
	LDR R1, R0, BAD; not loading this is good,

; this section will test loads and stores.  
loadstoretests:
	LEA R0, DataSegment	; For addressing. 
 	ADD R1, R0, 1		; for byte offset addressing. 
 	LEA R2, TARGET3		; get address of target 3. 
 	STR R2, R0, TARGET1 ; target1 now has address of target3. 
 	LDR R3, R0, TARGET1 ; check to make sure R1 and R2 match, 
 	LDR R6, R0, COOL 	; Load R6, with C001
 	STI R6, R0, TARGET1 ; Store C001 into TARGET3 Indirectly.
 	AND R6, R6, 0 		; Clear R6
 	LDR R6, R0, TARGET3 ; make sure that STI worked, R6 should say 'cool' 
 	LDI R2, R0, TARGET1 ; test LDI, R2 should also say 'cool'.
 	LDB R4, R0, ABCD 	; R4 should have 00CD
 	LDB R5, R1, ABCD 	; R5 should have 00AB
 	;; add data to [15:8] to make sure there are no clobering issues. 
 	; next 4 instructions. 
 	LDR R6, R0, EF
 	ADD R4, R4, R6 		; R4 = EFCD
 	LDR R6, R0, CD
 	ADD R5, R5, R6 		; R5 = CDAB
 	STB R5, R0, TARGET4 ; Target4 = x00AB 	
  	LDR R6, R0, TARGET4 ; Check if that worked
  	AND R6, R6, 0		; clear it just to be thorough 
 	STB R4, R1, TARGET4 ; Target4 = xCDAB
 	LDR R6, R0, TARGET4 ; Check if that worked


 halt:
 	BRnzp halt 


SEGMENT 	DataSegment:
ZERO:	 	DATA2 0
ONETWELVE:	DATA2 112
ENT:		DATA2 10
NINER:		DATA2 9999
BAD:  		DATA2 4x0BAD
GOOD: 		DATA2 4x600D
ABCD:		DATA2 4xABCD
EF: 		DATA2 4xEF00
CD: 		DATA2 4xCD00
TARGET1: 	DATA2 0
TARGET2: 	DATA2 0
TARGET3: 	DATA2 0
TARGET4: 	DATA2 0
COOL:		DATA2 4xC001
