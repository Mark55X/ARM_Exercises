.text
.global find_max

@ Input:
@   * r0: indirizzo in memoria del vettore di interi con segno;
@   * r1: numero di elementi del vettore;

@ Output:
@   * r0: il valor massimo del vettore

find_max:
   @@@ istruzioni della funzione max
   mov pc, lr   @ ritorna alla funzione chiamante.
