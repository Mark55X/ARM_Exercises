@Calcola il valore assoluto della differenza di due numeri

.text 			@marca l'inizio del segmento con il codice

.global main 		@definisce il punto di inizio main come global

main:	MOV R1, #16
	MOV R2, #3
	CMP R1, R2
	SUBGT R0, R1, R2
	SUBLE R0, R2, R1
	MOV PC, lr 	
