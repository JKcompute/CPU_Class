
; Need to test the following. 
; All load instructions
; make sure that hits and misses work for load and store.  
; 
;


ORIGIN 0
SEGMENT 0 CODE:
	LDR R1, R0, l1p ; R1 points to the head of segment line1
	LDR R2, R0, l2p ; R2 points to the head of segment line2
	LDR R3, R0, l3p ; R3 points to the head of segment line3
	LDR R4, R1, 0 ; cache miss, loads line1
	LDR R4, good ; This should be a hit.  I think. 
	STR r4, r1, X2
	STR r4, r1, X2+32
	LDR R5, R2, 0 ; cache miss, loads line2
	LDR R6, R1, 0 ; cache hit,  sets line2 as LRU
	LDR R7, R3, 0 ; cache miss, evicts line2, loads line3
	LDR R0, R1, 0 ; cache hit,  sets line3 as LRU
	LDR R1, R3, 0 ; cache hit,  sets line1 as LRU
	LDR R2, R2, 0 ; cache miss, evicts line1, loads line2
inf:
	BRnzp inf

l1p:	DATA2 line1
l2p:	DATA2 line2
l3p:	DATA2 line3
badd: 	DATA2 4xBADD
bad: 	DATA2 4xBAD
good: 	DATA2 4x600D
god: 	DATA2 4x060D
count	DATA2 4x1234
cool:  	DATA2 4xC001
dude: 	DATA2 4xD00D



SEGMENT 32 line1:
X0:	DATA2 4x1110
X1:	DATA2 4x1111
X2:	DATA2 4x1211
X3:	DATA2 4x3111
X4:	DATA2 4x1411
X5:	DATA2 4x1151
X6:	DATA2 4x1116
X7:	DATA2 4x1171


SEGMENT 128 line2:
Y0:	DATA2 4x2220
Y1:	DATA2 4x2212
Y2:	DATA2 4x2222
Y3:	DATA2 4x3222
Y4:	DATA2 4x2422
Y5:	DATA2 4x2252
Y6:	DATA2 4x2226
Y7:	DATA2 4x2272


SEGMENT 128 line3:
Z0:	DATA2 4x3330
Z1:	DATA2 4x3313
Z2:	DATA2 4x3233
Z3:	DATA2 4x3333
Z4:	DATA2 4x3433
Z5:	DATA2 4x3353
Z6:	DATA2 4x3336
Z7:	DATA2 4x3373


SEGMENT 256 line4:
Z0:	DATA2 4x4440
Z1:	DATA2 4x4414
Z2:	DATA2 4x4244
Z3:	DATA2 4x3444
Z4:	DATA2 4x4444
Z5:	DATA2 4x4454
Z6:	DATA2 4x4446
Z7:	DATA2 4x4474