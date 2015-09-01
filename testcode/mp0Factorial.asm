ORIGIN 4x0000

;; Register info
; R7 = N Value
; R6 = N-1 (Current)
; R5 = N-1 (Counter)
; R4 = Tally
; R3 = Mult Value
; R2 = 
; R1 = holds -1
; R0 = holds 0 
;; 

SEGMENT  CodeSegment:

Init:
;; Initilize registers. 
	LDR R7, R0, INPUT
	ADD R6, R7, R0
	LDR R1, R0, NEGONE
	LDR R3, R0, INPUT
	LDR R0, R0, ZERO

Check:
	ADD R5, R7, R1		; Make R5 = N-1
	ADD R6, R6, R1		; same for R6
	BRz DONE			; If R6 = 0, we are done
	
Mult: 
	ADD R4, R3, R4		; Multiply by adding up mult values by counter
	ADD R5, R5, R1		; Decrement Counter
	BRnp Mult			; Check if counter is Zero
	ADD R7, R7, R1		; Decrement N
	ADD R3, R4, R0		; Set new Mult Value
	AND R4, R0, R0		; Clear Tally
	BRnzp Check			; Go back to check (Always)


DONE:	
;; When done, store in memory
;; and populate all registers with
;; answer for fun.
	STR R3, R0, RESULT
	LDR R1, R0, RESULT
	LDR R2, R0, RESULT
	LDR R3, R0, RESULT
	LDR R4, R0, RESULT
	LDR R5, R0, RESULT
	LDR R6, R0, RESULT	 
	LDR R7, R0, RESULT

HALT:                   ; Infinite loop to keep the processor
    BRnzp HALT          ; from trying to execute the data below.

;; DATA
;Variable, that you would like to factorial                       
INPUT:  DATA2 4x0005

; constants
ONE:    DATA2 4x0001
ZERO:   DATA2 4x0000
RESULT: DATA2 4x0000
NEGONE: DATA2 4xffff
