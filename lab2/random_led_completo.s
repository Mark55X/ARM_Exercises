.bss

@ Word da utilizzare per accendere i led
valueled: .space 4
@ Word da utilizzare per salvare le 4 cifre esadecimali
hex0: .space 4
hex1: .space 4
hex2: .space 4
hex3: .space 4


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

	@ Crea framepointer 
	push {fp, lr}
	mov fp, sp

	@ Salva nello stack i registri che vengono modificati
	push {r1, r2}

	@ Estrae la quarta cifra meno significativa da r0 con un AND e LSL e la inserisce in r1
	and r1, r0, #0xF000
	lsr r1, r1, #12	

	@ Salva la quarta cifra, ora in r1, nel quarto word  
	@  recupera tramite il framepointer l'indirizzo della word e copialo in r2;
	@  poi salva r1 all'indirizzo contenuto in r2
 	ldr r2, [fp, #20]
	str r1, [r2] 

	@ Ripetere per la terza cifra meno significativa
	and r1, r0, #0xF00
	lsr r1, r1, #8
 	ldr r2, [fp, #16]
	str r1, [r2] 
	
	@ Ripetere per la seconda cifra meno significativa 
	and r1, r0, #0xF0
	lsr r1, r1, #4
 	ldr r2, [fp, #12]
	str r1, [r2] 

	@ Ripetere per la prima cifra meno significativa	
	and r1, r0, #0xF
 	ldr r2, [fp, #8]
	str r1, [r2] 

	@ Ripristina registri modificati
	pop {r1, r2}

	@ Rimuove framepointer
	pop {fp, lr}

	@ Ritorna alla funzione chiamante	
	mov pc, lr


@ Funzione is_four: controlla se un numero è un multiplo di 4.
@ Input: il numero nel registro r0
@ Output: scrive in r0 1 se il numero è un multiplo di 4, 0 altrimenti

is_four:
	@ Salva registri utilizzati
	push {r1}

	@ Controlla se il numero in r0 è multiplo di 4. Un multiplo di 4 ha sempre i 2 bit
	@   meno significativi a 0. Usare un operazione logica e un confronto. 
	and r1, r0, #0x3
	cmp r1, #0

	@ Se multiplo scrivi 1 in r0
	moveq r0, #1	

	@ Se non multiplo scrivi 0 in r0
	movne r0, #0

	@ Ripristina registri modificati
	pop {r1}
	
	@ Ritorna alla funzione chiamante	
	mov pc, lr


@ Funzione main: punto di inizio del programma.

.global main
main: 
	@ Salva i registri modificati
	push {r0,r1,lr}
	
	@ Chiama la funzione rand_word
	bl rand_word

	@ Prepara input per funzione get_four_hex (R0 contiene già la word)
	@ Carica in r1 l'indirizzo hex3 ed effettua push
	ldr r1, =hex3	
	push {r1}
	@ Carica in r1 l'indirizzo hex2 ed effettua push
	ldr r1, =hex2	
	push {r1}
	@ Carica in r1 l'indirizzo hex1 ed effettua push
	ldr r1, =hex1	
	push {r1}
	@ Carica in r1 l'indirizzo hex0 ed effettua push
	ldr r1, =hex0	
	push {r1}
	@ Chiama la funzione get_four_hex
	bl get_four_hex
	@ Rimuovi gli indirizzi hex0,...hex3 dallo stack
	add sp, sp, #16

	@ Imposta il registro r1 a 0: i 4 bit meno significativi conterranno il risultato
	@  della funzione is_four sulle 4 cifre esadecimali
	mov r1, #0

	@ Copia in r0 il word hex0,
	@  controlla se multiplo di 4 e salva risultato sul bit meno significativo di r1. 
	ldr r0, =hex0
	ldr r0, [r0]
	bl is_four
	orr r1, r1, r0

	@ Copia in r0 il word hex1,
	@  controlla se multiplo di 4 e salva risultato sul secondo bit meno significativo di r1. 
	ldr r0, =hex1
	ldr r0, [r0]
	bl is_four
	orr r1, r1, r0, lsl #1

	@ Copia in r0 il word hex2,
	@  controlla se multiplo di 4 e salva risultato sul terzo bit meno significativo di r1. 
	ldr r0, =hex2
	ldr r0, [r0]
	bl is_four
	orr r1, r1, r0, lsl #2

	@ Copia in r0 il word hex3,
	@  controlla se multiplo di 4 e salva risultato sul quarto bit meno significativo di r1. 
	ldr r0, =hex3
	ldr r0, [r0]
	bl is_four
	orr r1, r1, r0, lsl #3

	@ Salva valore di r1 nella word puntata da valueled
	ldr r0, =valueled

	@ Preparare input per set_led e invoca la funzione per attivare led
	str r1, [r0]
	bl set_led

	@ Ripristina registri modificati
	pop {r0,r1,lr}

	@ Termina e ritorna dalla funzione main
	mov pc, lr



