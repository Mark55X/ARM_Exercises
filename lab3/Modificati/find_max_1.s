.text
.global find_max

@ Input:
@   * r0: indirizzo in memoria del vettore di interi con segno;
@   * r1: numero di elementi del vettore;

@ Output:
@   * r0: il valor massimo del vettore

find_max:
	PUSH {LR,R1-R3}

   	@@@ istruzioni della funzione max ind V = V + i*4	

	SUBS R1, R1, #1
	BMI fine

	LDR R2, [R0, R1, LSL #2] 
	BEQ set_max
	SUBS R1, R1, #1

loop:	LDR R3, [R0, R1, LSL #2]
		CMP R3, R2
		MOVGT R2, R3		
		SUBS R1, R1, #1
		BMI set_max
		B loop

set_max: MOV R0, R2

fine: POP {PC,R1-R3} 
	  mov pc, lr   @ ritorna alla funzione chiamante.
