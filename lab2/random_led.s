.bss

@ Word da utilizzare per accendere i led
valueled: .skip 4
@ Word da utilizzare per salvare le 4 cifre esadecimali
hex0: .skip 4
hex1: .skip 4
hex2: .skip 4
hex3: .skip 4


.text

@ Funzione get_four_hex: Riceve in input un intero senza segno e salva in 4 word
@   in memoria le 4 cifre esadecimali meno significative del numero.
@ Input: intero senza segno, passato per valore, nel registro r0; 
@ Output: 4 word in memoria, passate per indirizzo, con la tecnica dello stack frame. 
@        L'ordine nello stack è il seguente: l'indirizzo della word
@	       dove andrà la cifra meno significativa è l'ultimo inserito nello stack;
@ 	     l'indirizzo della word dove andrà la cifra più significativa è 
@	       il primo inserito nello stack.
@ La subroutine inserice nelle 4 word di memoria, una cifra esadecimale per word.
@ La cifra meno significativa verrà inserita nel word in cui indirizzo si trova nella testa dello stack
@ (ovvero è l'ultima ad essere inserita dal programma chiamante). 
 
get_four_hex:

	PUSH {FP,LR} @ Crea framepointer 
	MOV FP, SP
	
	PUSH {R1-R2} @ Salva nello stack i registri che vengono modificati

	AND R1, R0, #0xF000  @ Estrae la quarta cifra meno significativa da r0 con un AND e LSL e la inserisce in r1
	LSR R1, R1, #12

			 @ Salva la quarta cifra, ora in r1, nel quarto word  
	LDR R2, [FP,#20]	 @  recupera tramite il framepointer l'indirizzo della word e copialo in r2;
	STR R1, [R2]	 @  poi salva r1 all'indirizzo contenuto in r2

	AND R1, R0, #0xF00 LSL #8 @ Ripetere per la terza cifra meno significativa
	LSR R1, R1, #8
	LDR R2, [FP,#16]
	STR R1, [R2]

	AND R1, R0, #0xF0 @ Ripetere per la seconda cifra meno significativa 
	LSR R1, R1, #4
	LDR R2, [FP,#12]
	STR R1, [R2]

	AND R1, R0, #0xF @ Ripetere per la prima cifra meno significativa	
	LDR R2, [FP,#8]
	STR R1, [R2]

	POP{R1-R2}	@ Ripristina registri modificati

	MOV SP, FP 	@ Rimuove framepointer
	POP {FP, PC}	@ Ritorna alla funzione chiamante	
	

@ Funzione is_four: controlla se un numero è un multiplo di 4.
@ Input: il numero nel registro r0
@ Output: scrive in r0 1 se il numero è un multiplo di 4, 0 altrimenti

is_four:
	@ Salva registri utilizzati

	AND R0, R0, #0x3	@ Controlla se il numero in r0 è multiplo di 4. Un multiplo di 4 ha sempre i 2 bit
	CMP R0, #0 @   meno significativi a 0. Usare un operazione logica e un confronto. 

	MOVEQ R0, #1 @ Se multiplo scrivi 1 in r0

	MOVNE R0, #0 @ Se non multiplo scrivi 0 in r0

	@ Ripristina registri modificati
	
	MOV PC, LR @ Ritorna alla funzione chiamante	


@ Funzione main: punto di inizio del programma.

.global main
main: 
	PUSH{LR,R0,R1} @ Salva i registri modificati
	
	BL rand_word @ Chiama la funzione rand_word

	@ Prepara input per funzione get_four_hex (R0 contiene già la word)
	LDR R1, =hex3 @ Carica in r1 l'indirizzo hex3 ed effettua push
	PUSH {R1}

	LDR R1, =hex2 @ Carica in r1 l'indirizzo hex2 ed effettua push
	PUSH {R1}

	LDR R1, =hex1 @ Carica in r1 l'indirizzo hex1 ed effettua push
	PUSH {R1}

	LDR R1, =hex0 @ Carica in r1 l'indirizzo hex0 ed effettua push
	PUSH {R1}

	BL get_four_hex @ Chiama la funzione get_four_hex

	SUB SP, SP, #16 @ Rimuovi gli indirizzi hex0,...hex3 dallo stack

	MOV R1, #0@ Imposta il registro r1 a 0: i 4 bit meno significativi conterranno il risultato
	@  della funzione is_four sulle 4 cifre esadecimali

	 @ Copia in r0 il word hex0,
	@  controlla se multiplo di 4 e salva risultato sul bit meno significativo di r1. 
	LDR R0, =hex0
	LDR R0, [R0] 
	BL is_four
	CMP R0, #0
	ORRNE R1, R1, #0x1

	@ Copia in r0 il word hex1,
	@  controlla se multiplo di 4 e salva risultato sul secondo bit meno significativo di r1. 
	LDR R0, =hex1
	LDR R0, [R0]	
	BL is_four		
	CMP R0, #0
	ORRNE R1, R1, #0x2

	@ Copia in r0 il word hex2,
	@  controlla se multiplo di 4 e salva risultato sul terzo bit meno significativo di r1. 
	LDR R0, =hex2 				
	LDR R0, [R0]	
	BL is_four	  				
	CMP R0, #0
	ORRNE R1, R1, #0x4
		
	@ Copia in r0 il word hex3,
	@  controlla se multiplo di 4 e salva risultato sul quarto bit meno significativo di r1. 
	
	LDR R0, =hex2 	
	LDR R0, [R0]	
	BL is_four	  	
	CMP R0, #0
	ORRNE R1, R1, #0x8	

	LDR R0, =valueled
	STR R1, [R0] @ Salva valore di r1 nella word puntata da valueled

	BL set_led @ Preparare input per set_led e invoca la funzione per attivare led

	POP{LR,R0,R1}@ Ripristina registri modificati
	
	MOV PC, LR@ Termina e ritorna dalla funzione main



