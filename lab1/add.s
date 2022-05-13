@Calcola la somma di due numeri

.text 			@marca l'inizio del segmento con il codice

.global main 		@definisce il punto di inizio main come global

main:	MOV R1, #10
	MOV R2, #15
	ADD R0, R1, R2
	MOV PC, lr 	
