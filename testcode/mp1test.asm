ORIGIN 4x0000


SEGMENT  CodeSegment:


    AND R0, R0, 0 
    ADD R0, R0, 1
    ADD R1, R1, R0
    ADD R2, R1, R1
    ADD R3, R1, 2
    ADD R4, R3, 1
    ADD R5, R2, R3
    ADD R6, R3, 3
    ADD R7, R2, R5

    AND R1, R0, 0
    ADD R1, R1, -1
    AND R1, R1, -1
    AND R1, R1, -2
    AND R1, R1, 13
    AND R1, R1, 7
    AND R1, R1, 2




;    LDR R1, R0, ONE    ; R1 <= 1
;    LDR R2, R0, TWO    ; R2 <= 2
;    LDR R3, R0, EIGHT  ; R3 <= 8
;    ADD R4, R3, R2      ; R4 <= R3 + R2

;    ADD R4, R4, 8
;    ADD R4, R3, 7

;    AND R4, R4, 0
;    ADD R4, R4, 7
;    AND R4, R4, 4x0003
;    AND R3, R4, 4x0003

;LOOP1:
;    ADD R3, R3, R3      ; R3 <= R3 + R3
;    NOT R5, R2          ; R5 <= not(R2)
;    ADD R5, R5, R1      ; R5 <= R5 + R1
;    ADD R4, R4, R5      ; R4 <= R4 + R5
;    BRzp LOOP1          ; Branch if last result was zero or positive.

;    AND R7, R3, R4
;    STR R7, R0, RESULT
;    LDR R1, R0, RESULT
;    NOT R0, R7
;    AND R0, R1, R0
;    STR R0, R0, RESULT

;    LDR R1, R0, GOOD
HALT:                   ; Infinite loop to keep the processor
    BRnzp HALT          ; from trying to execute the data below.
                        ; Your own programs should also make use
                        ; of an infinite loop at the end.
;ZERO:   DATA2 4x0000
;ONE:    DATA2 4x0001
;TWO:    DATA2 4x0002
;EIGHT:  DATA2 4x0008
;RESULT: DATA2 4x0000
;GOOD:   DATA2 4x600D