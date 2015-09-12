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
LoadStoreTests:
	LEA R0, DataSegment	; For addressing. 
 	ADD R1, R0, 1		; for byte offset addressing. 
 	LEA R2, TARGET3		; get address of target 3. 
 	STR R2, R0, TARGET1 ; target1 now has address of target3. 
 	LDR R3, R0, TARGET1 ; check to make sure R2 and R3 match, 
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

 ShiftTests:
 	LDR R6, R0, ABCD 	; Start with ABCD in R6
 	RSHFA R6, R6, 4 	; Should now be FABC
 	RSHFL R6, R6, 4		; SHould now be 0FAB
 	LSHF R6, R6, 3 		; Should now be 7D58
 	RSHFA R6, R6, 4 	; Should now be 07D5
 	RSHFA R6, R6, 12 	; Should now be 0000
;; test trap by going to Condition code tests.
	TRAP CCTrap
	LDR R6, R0, BAC 	; You're BACk!

 halt:
 	BRnzp halt 


SEGMENT 	DataSegment:
ZERO:	 	DATA2 0
BAC:		DATA2 4xBAC
ENT:		DATA2 10
NINER:		DATA2 9999
BAD:  		DATA2 4x0BAD
GOOD: 		DATA2 4x600D
ABCD:		DATA2 4xABCD
TBCD:		DATA2 4x7BCD
EF: 		DATA2 4xEF00
CD: 		DATA2 4xCD00
TARGET1: 	DATA2 0
TARGET2: 	DATA2 0
TARGET3: 	DATA2 0
TARGET4: 	DATA2 0
COOL:		DATA2 4xC001
CCTrap: 	DATA2 CCtests 
; condition code tests, we will make sure that a 
; CC works for each instruction that uses them.
;ADD, AND, LDB, LDI, LDR, LEA, NOT, SHF
CCtests: 
	ADD R6, R6, 0 		; start with ADD to check zero condition
	BRz OK1				; Branch if Ok 
	LDR R7, R0, BAD 	; This is the check.  we dont want to mess up R7!
 OK1:
 	ADD R6, R6, R7		
 	BRp OK2
	LDR R7, R0, BAD 	; This is the check.  we dont want to mess up R7!
 OK2:
 	AND R6, R6, R6 		; 
	BRp OK3
	LDR R7, R0, BAD 	; This is the check.  we dont want to mess up R7!
OK3:
	AND R6, R6, 0 		; 
	BRz OK4
	LDR R7, R0, BAD 	; This is the check.  we dont want to mess up R7!
OK4:
	LDB R6, R0, ABCD 	
	BRp OK5
	LDR R7, R0, BAD 	; This is the check.  we dont want to mess up R7!
OK5:
	LDI R6, R0, TARGET1 	
	BRn OK6
	LDR R7, R0, BAD 	; This is the check.  we dont want to mess up R7!
OK6:
	LDR R6, R0, TBCD 	
	BRp OK7
	LDR R7, R0, BAD 	; This is the check.  we dont want to mess up R7!
OK7:
	LEA R6, COOL      	
	BRp OK8
	LDR R7, R0, BAD 	; This is the check.  we dont want to mess up R7!
OK8:
	NOT R6, R6      	
	BRn OK9
	LDR R7, R0, BAD 	; This is the check.  we dont want to mess up R7!
OK9:
	RSHFL R6, R6, 4      	
	BRp OK10
	LDR R7, R0, BAD 	; This is the check.  we dont want to mess up R7!
OK10:
	RET