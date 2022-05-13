@Calcola la differenza di due numeri

.text 			@marca l'inizio del segmento con il codice

.global main 		@definisce il punto di inizio main come global

main:	MOV R3, #16
	MOV R4, #3
	SUB R1, R3, R4
	MOV PC, lr 	
