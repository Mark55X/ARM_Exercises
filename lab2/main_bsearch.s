@@@ Questo file implementa un main per cercare con la funzione bsearch un 
@@@ elemento in un vettore di interi senza segno con n elementi.


.data

key: .word -935
n: .word 300 @ dimensione array

@ Alloca e inizializza un vettore di 200 word 
V: .word -1964, -1952, -1950, -1934, -1931, -1928, -1925, -1918, -1909, -1900, -1892, -1880, -1872, -1852, -1839, -1835, -1808, -1805, -1784, -1768, -1742, -1734, -1732, -1716, -1712, -1711, -1701, -1689, -1687, -1686, -1664, -1655, -1653, -1651, -1622, -1620, -1616, -1606, -1605, -1601, -1570, -1563, -1504, -1499, -1492, -1475, -1469, -1465, -1462, -1447, -1415, -1406, -1401, -1399, -1397, -1352, -1315, -1308, -1293, -1269, -1257, -1248, -1247, -1229, -1218, -1209, -1177, -1174, -1172, -1169, -1141, -1130, -1127, -1118, -1112, -1111, -1079, -1071, -1064, -1055, -1009, -975, -963, -935, -933, -896, -865, -862, -857, -839, -806, -805, -776, -742, -734, -724, -712, -711, -675, -647, -638, -637, -619, -615, -614, -563, -549, -540, -535, -534, -520, -493, -468, -447, -443, -436, -417, -415, -411, -390, -387, -371, -362, -351, -342, -329, -316, -291, -286, -274, -273, -243, -240, -235, -188, -165, -155, -143, -140, -121, -103, -96, -91, -70, -67, -50, -33, -30, -27, -10, -6, 1, 7, 55, 65, 83, 120, 133, 146, 151, 170, 221, 227, 235, 236, 259, 263, 266, 280, 292, 293, 322, 324, 344, 371, 385, 403, 421, 423, 443, 446, 452, 469, 477, 485, 499, 551, 569, 574, 581, 590, 606, 626, 635, 643, 670, 696, 697, 733, 739, 757, 790, 814, 821, 825, 857, 861, 863, 864, 889, 904, 912, 916, 921, 926, 928, 935, 945, 951, 969, 974, 981, 987, 999, 1033, 1062, 1064, 1070, 1082, 1086, 1089, 1108, 1110, 1145, 1155, 1185, 1196, 1200, 1202, 1209, 1235, 1246, 1256, 1294, 1322, 1329, 1354, 1363, 1379, 1389, 1402, 1420, 1461, 1465, 1468, 1469, 1473, 1487, 1496, 1511, 1515, 1516, 1521, 1530, 1532, 1569, 1587, 1616, 1617, 1631, 1634, 1661, 1670, 1678, 1685, 1686, 1687, 1699, 1713, 1727, 1734, 1739, 1740, 1780, 1802, 1804, 1809, 1825, 1838, 1848, 1855, 1879, 1901, 1908, 1911, 1915, 1957, 1968, 1971, 1979

.text
.global main

main:	push {r0, lr}	@ salva registri nello stack	
	ldr r0, =V	@ indirizzo del vettore in r0
	push {r0}	@ primo parametro per bsearch
	mov r0, #0	@ estremo sinistro dell'intervallo dove cercare
	push {r0}	@ secondo parametro per bsearch
	ldr r0, =n	@ carica indirizzo n
	ldr r0, [r0]	@ numero di elementi in r0
	sub r0, r0, #1	@ estremo destro dell'intervallo dove cercare
	push {r0}	@ terzo parametro per bsearch
	ldr r0, =key	@ indirizzo contenente il valore da cercare
	ldr r0, [r0]	@ carica in r0 il valore da cercare
	push {r0}	@ quarto parametro per bsearch
	bl bsearch	@ cerca elemento
	add sp, sp, #16	@ rimuovo parametri input per bsearch nello stack
	bl print_int	@ stampa il risultato 
	pop {r0, lr}	@ ripristina registri
	mov pc, lr	@ esci
