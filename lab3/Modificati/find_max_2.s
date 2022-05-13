.text
.global find_max

@ Input:
@   DALLO STACK

@ Output:
@   * r0: il valor massimo del vettore

find_max:
		PUSH {FP,LR}
		MOV FP, SP

		@@@ istruzioni della funzione max ind V = V + i*4	

		PUSH {R1-R3}
		LDR R1, [FP, #8]
		LDR R0, [FP, #12]

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

fine: 	POP {R1-R3} 
		MOV SP, FP
		POP {FP,LR}
        MOV pc, lr   
		
