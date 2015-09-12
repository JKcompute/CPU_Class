ORIGIN 0
SEGMENT
CodeSegment:	; Version 0.12  7/21/2014
	AND R0, R0, 0
	AND R1, R0, 0
	AND R2, R0, 0
	AND R3, R0, 0
	AND R4, R0, 0
	AND R5, R0, 0
	AND R6, R0, 0
	AND R7, R0, 0
	JMP Safe
	LDR R1, R0, 4x0BAD; not loading this is good,



Safe:
	LEA R0, DataSegment	; For addressing. 
 	ADD R1, R0, 1		; for byte offset addressing. 
 	LEA R2, TARGET3		; get address of target 3. 
 	STR R2, R0, TARGET1 ; target1 now has address of target3. 
 	LDR R3, R0, TARGET1 ; check to make sure R1 and R2 match, 
 	LDI R3, R0, TARGET1 ; R2 should say Good.
 	LDB R4, R0, GOOD
 	LDB R5, R1, GOOD `


SEGMENT        DataSegment:
ZERO:	 DATA2 0
ONETWELVE:	 DATA2 112
ENT:	DATA2 10
NINER:	DATA2 9999
TARGETr
BAD:  DATA2 4x0BAD
GOOD: DATA2 4x600D
TARGET1: DATA 0
TARGET2: DATA 0
TARGET3: DATA 4xC001
TARGET4: DATA 0
