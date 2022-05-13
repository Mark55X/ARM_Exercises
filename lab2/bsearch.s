    .text

    @La funzione bsearch riceve i 4 parametri di input tramite stack nel seguente ordine:

    @ Indirizzo del vettore V
    @ Valore di i
    @ Valore di j
    @ Valore di key
    @ L'output viene restituito in r0.
    .global bsearch
    start_bsearch :     PUSH {FP, LR}
                        MOV FP, SP
                   
                        @ Dati in ingresso
                        LDR R2, [FP,#4]     @ V
                        LDR R3, [FP,#8]     @ i
                        LDR R4, [FP,#12]    @ j
                        LDR R5, [FP,#16]    @ key

                        @ Caso elemento non trovato 
                        CMP R3,R4
                        MOVGT R0, #-1
                        BGT end_bsearch

                        @ Calcolo tmp
                        ADD R1, R3, R4
                        LSR R1, R1, #2
                        
                        @ Calcolo di v[temp]
                        ADD R2, R2, R1, LSL #2
                        LDR R2, [R2]

                        CMP R2, R5
                        MOVEQ R0, R1
                        BEQ end_bsearch

                        PUSH{R5}
                        BLGT bsearch_sx

                        ADD R1, R1, #1
                        PUSH{R2, R1, R4} 
                        BL start_bsearch
                        B end_bsearch

    bsearch_sx :        SUB R1, R1, #1
                        PUSH{R2,R3, R1} 
                        BL start_bsearch

    end_bsearch:        MOV SP, FP
                        POP {FP, PC}
                 
   


