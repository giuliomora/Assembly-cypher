.data
mycypher: 			.string 	"ABCDE"
					.zero		10
myplaintext:      	.string     "AMO AssEMbLY"
					.zero		10
cypthertext:		.zero		1000
					.zero		10
occctext:			.zero		1000
					.zero		10
filteredtext:		.zero		100
					.zero		10
ntotbuff:			.zero		10
					.zero		10
blocKey:      		.string     "OLE"
					.zero		10
k:					.word   	1
newline:  			.byte		10

.text
functionCall:
	la a0, cypthertext
	sw a0, -12(sp)
	la a0, myplaintext
	sw a0, -8(sp)
	li a0, 0
	sw a0, -4(sp)			#i = 0
mstrcpy:
	lw a5, -4(sp)
	lw a4, -8(sp)
	add a5, a4, a5
	lb a6, 0(a5)			#a6 = myplaintext[i]

	lw a5, -4(sp)
	lw a4, -12(sp)
	add a5, a4, a5
	sb a6, 0(a5)			#cypthertext[i] = a6

	blez a6, exitmstrcpy	#se temp <= 0 jump

	lw a0, -4(sp)
	addi a0, a0, 1
	sw a0, -4(sp)			#i = i+1
	j mstrcpy

exitmstrcpy:
	la a0, myplaintext # Carico l'indirizzo della stringa
    li a7, 4   #L'argomento '4' per l'ecall indica ad ecall di stampare su console
    ecall
	jal printNewline	#stampa una nuova riga per differenziare gli algoritmi

encryption_call:
	addi sp, sp, -4
	li a0, 0
	sw a0, 0(sp)			#i = 0
encryption_loop:
	la a5, mycypher
	lw a4, 0(sp)
	add a5, a4, a5
	lb a6, 0(a5)			#a6 = mycypher[i]
	blez a6, exit_en_loop
	addi a3, a6, -65
	beqz a3, caseA
	addi a3, a6, -66
	beqz a3, caseB
	addi a3, a6, -67
	beqz a3, caseC
	addi a3, a6, -68
	beqz a3, caseD
	addi a3, a6, -69
	beqz a3, caseE
	j exit_en_loop			#se viene assegnata alla chiave un carattere errato, uscire dal processo di crittografia
caseA:
	la a0, cypthertext
	la a1, cypthertext
	lw a2, k
	jal AlgoritmoA
	la a0, cypthertext # Carica l'indirizzo della stringa
    li a7, 4   # L'argomento '4' per l'ecall indica ad ecall di stampare su console
    ecall
	jal printNewline	#stampa una nuova riga
	j en_loop_inc
caseB:
	la a0, cypthertext
	la a1, blocKey
	la a2, cypthertext
	jal AlgoritmoB
	la a0, cypthertext # Carica l'indirizzo della stringa
    li a7, 4   # L'argomento 4 per l'ecall indica ad ecall di stampare su console
    ecall
	jal printNewline	#stampa una nuova riga
	j en_loop_inc
caseC:
	la a0, cypthertext
	la a1, occctext
	la a2, filteredtext
	la a3, ntotbuff
	jal AlgoritmoC
	la a0, cypthertext # Carica l'indirizzo della stringa
    li a7, 4   # L'argomento 4 per l'ecall indica ad ecall di stampare su console
    ecall
	jal printNewline	#stampa una nuova riga
	j en_loop_inc
caseD:
	la a0, cypthertext
	la a1, cypthertext
	jal AlgoritmoD
	la a0, cypthertext # Carica l'indirizzo della stringa
    li a7, 4   # L'argomento 4 per l'ecall indica ad ecall di stampare su console
    ecall
	jal printNewline	#stampa una nuova riga
	j en_loop_inc
caseE:
	la a0, cypthertext
	la a1, cypthertext
	jal AlgoritmoE
	la a0, cypthertext # Carica l'indirizzo della stringa
    li a7, 4   # L'argomento 4 per l'ecall indica ad ecall di stampare su console
    ecall
	jal printNewline	#stampa una nuova riga
	j en_loop_inc

en_loop_inc:
	lw a0, 0(sp)
	addi a0, a0, 1
	sw a0, 0(sp)			#i = i+1
	j encryption_loop		#salto ad encryption_loop

exit_en_loop:

#####################################################
decryption_call:
	lw a0, 0(sp)
	addi a0, a0, -1
	sw a0, 0(sp)			#i = i-1
decryption_loop:
	la a5, mycypher
	lw a4, 0(sp)
	add a5, a4, a5
	lb a6, 0(a5)			#a6 = mycypher[i]
	blez a6, exit_de_loop
	addi a3, a6, -65
	beqz a3, DeCaseA
	addi a3, a6, -66
	beqz a3, DeCaseB
	addi a3, a6, -67
	beqz a3, DeCaseC
	addi a3, a6, -68
	beqz a3, DeCaseD
	addi a3, a6, -69
	beqz a3, DeCaseE
	j exit_de_loop			#se il carattere non va bene, uscire dal processo di decrittografia
DeCaseA:
	la a0, cypthertext
	la a1, cypthertext
	lw a2, k
	jal AlgoritmoA_inverso
	la a0, cypthertext # Carica l'indirizzo della stringa
    li a7, 4   # L'argomento '4' per l'ecall indica ad ecall di stampare su console
    ecall
	jal printNewline	#stampa una nuova riga
	j de_loop_dec
DeCaseB:
	la a0, cypthertext
	la a1, blocKey
	la a2, cypthertext
	jal AlgoritmoB_inverso
	la a0, cypthertext # Carica l'indirizzo della stringa
    li a7, 4   # L'argomento '4' per l'ecall indica ad ecall di stampare su console
    ecall
	jal printNewline	#stampa una nuova riga
	j de_loop_dec
DeCaseC:
	la a0, cypthertext
	la a1, occctext
	jal  AlgoritmoC_inverso
	la a0, cypthertext # Carica l'indirizzo della stringa
    li a7, 4   # L'argomento 4 per l'ecall indica ad ecall di stampare su console
    ecall
	jal printNewline	#stampa una nuova riga
	j de_loop_dec
DeCaseD:
	la a0, cypthertext
	la a1, cypthertext
	jal AlgoritmoD_inverso
	la a0, cypthertext # Carica l'indirizzo della stringa
    li a7, 4   # L'argomento 4 per l'ecall indica ad ecall di stampare su console
    ecall
	jal printNewline	#stampa una nuova riga
	j de_loop_dec
DeCaseE:
	la a0, cypthertext
	la a1, cypthertext
	jal AlgoritmoE_inverso
	la a0, cypthertext # Carica l'indirizzo della stringa
    li a7, 4   # L'argomento 4 per l'ecall indica ad ecall di stampare su console
    ecall
	jal printNewline	#stampa una nuova riga
	j de_loop_dec

de_loop_dec:
	lw a0, 0(sp)
	addi a0, a0, -1
	sw a0, 0(sp)			#i = i-1
	j decryption_loop		#salto a decryption_loop

exit_de_loop:
	addi sp, sp, 4
	j exit

#######################################################
AlgoritmoA:
	addi sp, sp, -16
    sw ra, 12(sp) # indirizzo di ritorno
	#la a0, myplaintext
    sw a0, 8(sp)  # indirizzo di myplaintext
	#la a1, cypthertext
    sw a1, 4(sp)  # indirizzo di cypthertext
	lw a2, k
    sw a2, 0(sp)  #sostk

	li a6, 0 #i = si scorre di 1 ogni volta, tutti i byte vanno criptati
subc_while:
	lw a0, 8(sp)	# carica l'indirizzo di myplaintext
	add a2, a0, a6	# myplaintext_address + i
	lb a7, 0(a2)	# carica il carattere in a7
	beqz a7, subc_exit #controlla se la stringa termina

	#if(temp >= 65 && temp <= 90) #verifica se la lettera è maiuscola
    li a5, 64
    ble a7, a5, subc_L1
    li a5, 90
    bgt a7, a5, subc_L1

#result = char(int(text[i]+s-65)%26 +65)
	lw a2, 0(sp)  #sostk
    add a7, a7, a2			#temp = temp + k, temp = carattere letto su cui viene eseguita la crittografia
    addi a7, a7, -65		#temp = temp - 65

	bgez a7, subc_LC1		#se temp è positivo allora rem
	addi a7, a7, 26			#se è negativo aggiungo 26
	j subc_LC2
subc_LC1:
    li a5, 26
    rem a7, a7, a5			#temp = temp % 26
subc_LC2:
    addi a7, a7, 65			#temp = temp + 65
	j subc_L2

subc_L1:
	#if(temp >= 97 && temp <= 122) #stesso procedimento ma con lettere minuscole
    li a5, 96
	ble a7, a5, subc_L2
	li a5, 122
	bgt a7, a5, subc_L2

#result = char(int(text[i]+s-97)%26 +97)
	lw a2, 0(sp)  #k
    add a7, a7, a2		#temp = temp + k
    addi a7, a7, -97	#temp = temp - 97

	bgez a7, subc_LS1	#se temp è positivo allora rem
	addi a7, a7, 26		#se è negativo aggiungo 26
	j subc_LS2
subc_LS1:
    li a5, 26
    rem a7, a7, a5		#temp = temp % 26
subc_LS2:
    addi a7, a7, 97		#temp = temp + 97

subc_L2:
	lw a0, 4(sp)	# carico l'indirizzo di cypthertext
	add a2, a0, a6	# cypthertext_address + i
	sb a7, 0(a2)	# scrive il carattere cifrato in a7
	addi a6, a6, 1	#i = i+1
	j subc_while
subc_exit:
	lw   ra, 12(sp) #ricarica l'indirizzo di ritorno dallo stack
    addi sp, sp, 16 #ripristina lo sp
    ret


############################################
AlgoritmoA_inverso:
	addi sp, sp, -16
    sw ra, 12(sp) # indirizzo di ritorno
	#la a0, myplaintext
    sw a0, 8(sp)  # indirizzo di myplaintext
	#la a1, cypthertext
    sw a1, 4(sp)  # indirizzo di cypthertext
	#lw a2, k
	neg a2, a2
    sw a2, 0(sp)  #sostk

	li a6, 0 #i
subdec_while:
	lw a0, 8(sp)	# carica l'indirizzo di myplaintext
	add a2, a0, a6	# myplaintext_address + i
	lb a7, 0(a2)	# carica il carattere in a7
	beqz a7, subdec_exit

	#if(temp >= 65 && temp <= 90)
    li a5, 64
    ble a7, a5, subdec_L1
    li a5, 90
    bgt a7, a5, subdec_L1

	#result = char(int(text[i]+s-65)%26 +65)
	lw a2, 0(sp)  # k
    add a7, a7, a2		#temp = temp + k
    addi a7, a7, -65	#temp = temp - 65

	bgez a7, subdec_LC1		#se temp è positivo allora rem
	addi a7, a7, 26			#se è negativo aggiungo 26
	j subdec_LC2
subdec_LC1:
    li a5, 26
    rem a7, a7, a5			#temp = temp % 26
subdec_LC2:
    addi a7, a7, 65			#temp = temp + 65
	j subdec_L2

subdec_L1:
	#if(temp >= 97 && temp <= 122)
    li a5, 96
	ble a7, a5, subdec_L2
	li a5, 122
	bgt a7, a5, subdec_L2

#result = char(int(text[i]+s-97)%26 +97)
	lw a2, 0(sp)  # k
    add a7, a7, a2		#temp = temp + k
    addi a7, a7, -97	#temp = temp - 97

	bgez a7, subdec_LS1	#se temp è positivo allora rem
	addi a7, a7, 26		#se negativo aggiungo 26
	j subdec_LS2
subdec_LS1:
    li a5, 26
    rem a7, a7, a5		#temp = temp % 26
subdec_LS2:
    li a5, 26
    rem a7, a7, a5		#temp = temp % 26
    addi a7, a7, 97		#temp = temp + 97

subdec_L2:
	lw a0, 4(sp)	# carica l'indirizzo di cypthertext
	add a2, a0, a6	# cypthertext_address + i
	sb a7, 0(a2)	# scrivo il carattere in a7
	addi a6, a6, 1	#i = i+1, scorre la stringa
	j subdec_while
subdec_exit:
	lw   ra, 12(sp) # ricarica l'indirizzo di ritorno dallo stack
    addi sp, sp, 16 #ripristina lo sp
    ret



############################################
AlgoritmoB:
	addi sp, sp, -16
    sw ra, 12(sp) # indirizzo di ritorno
	#la a0, myplaintext
    sw a0, 8(sp)  # indirizzo di myplaintext
	#la a1, blocKey
    sw a1, 4(sp)  # indirizzo della chiave
	#la a2, cypthertext
    sw a2, 0(sp)  # indirizzo di cypthertext

	li a7, 0 		#i
	li a6, 0 		#kptr
blkc_while:
	lw a0, 8(sp)	# carica l'indirizzo di myplaintext
	add a2, a0, a7	# myplaintext_address + i
	lb a5, 0(a2)	# carica il carattere in a5
	beqz a5, blkc_exit #verifica se la stringa termina
	lw a0, 4(sp)	# carica l'indirizzo della chiave
	add a2, a0, a6	# key_address + kptr
	lb a4, 0(a2)	# carica il carattere in a4
	bnez a4, blkc_L
	li a6, 0
blkc_L: #effettua l'operazione {[(cod(bij)–32)+(cod(keyj)–32)]%96}+32
	lw a0, 4(sp)	#carica l'indirizzo della chiave
	add a2, a0, a6	# key_address + kptr
	lb a4, 0(a2)	# carica il carattere in a4

	addi a5, a5, -32
	addi a4, a4, -32
	add a5, a5, a4
	li a2, 96
	rem a5, a5, a2
	addi a5, a5, 32
	lw a0, 0(sp)	# carica l'indirizzo di cypthertext
	add a2, a0, a7	# cypthertext_address + i
	sb a5, 0(a2)	# scrive il carattere in a5

	addi a6, a6, 1
	addi a7, a7, 1
	j blkc_while
blkc_exit:
	lw   ra, 12(sp) # ricarica l'indirizzo di ritorno dallo stack
    addi sp, sp, 16 # riprista lo sp
    ret

############################################
AlgoritmoB_inverso:
	addi sp, sp, -16
    sw ra, 12(sp) # indirizzo di ritorno
	#la a0, cypthertext
    sw a0, 8(sp)  # indirizzo di cypthertext
	#la a1, blocKey
    sw a1, 4(sp)  # indirizzo della chiave
	#la a2, cypthertext
    sw a2, 0(sp)  # indirizzo di cypthertext

	li a7, 0 		#i
	li a6, 0 		#kptr
blkdec_while:
	lw a0, 8(sp)	# carica l'indirizzo di cypthertext
	add a2, a0, a7	# cypthertext_address + i
	lb a5, 0(a2)	# carica il carattere in a5
	beqz a5, blkdec_exit
	lw a0, 4(sp)	# carica l'indirizzo della chiave
	add a2, a0, a6	# key_address + kptr
	lb a4, 0(a2)	# carica il carattere in a4
	bnez a4, blkdec_L
	li a6, 0
blkdec_L:
	lw a0, 4(sp)	# carica l'indirizzo della chiave
	add a2, a0, a6	# key_address + kptr
	lb a4, 0(a2)	# carica il carattere in a4
	addi a5, a5, 32
	neg a4, a4
	add a5, a5, a4
	li a2, 31
	bgt a5, a2, blkdec_L1
	addi a5, a5, 96
blkdec_L1:
    lw	a0, 0(sp)  # indirizzo di cypthertext
	add a2, a0, a7
	sb a5, 0(a2)	# scrive il carattere in a5
	addi a6, a6, 1
	addi a7, a7, 1
	j blkdec_while
blkdec_exit:
	lw   ra, 12(sp) # ricarica l'indirizzo di ritorno dallo stack
    addi sp, sp, 16 #ripristina lo sp
    ret


############################################
AlgoritmoD:
	addi sp, sp, -12
    sw ra, 8(sp) # indirizzo di ritorno
	#la a0, myplaintext
    sw a0, 4(sp)  # indirizzo di myplaintext
	#la a1, cypthertext
    sw a1, 0(sp)  # indirizzo di cypthertext

	li a7, 0 		#i
dicc_while:
	lw a0, 4(sp)	# carica l'indirizzo di myplaintext
	add a2, a0, a7	# myplaintext_address + i
	lb a5, 0(a2)	# carica il carattere in a5
	beqz a5, dicc_exit	#verifica se la stringa termina
dicc_L1: #verifica se il carattere è una lettera maiuscola, se non lo è salta a dicc_L2
	li a4, 64
	ble a5, a4, dicc_L2  #salto se il char di input presente in itemp(a5)<=64
	li a4, 90
	bgt a5, a4, dicc_L2	 #salto se il char di input presente in itemp(a5)>90

	mv a6, a5
	addi a6, a6, -65	 #temp(a6) = temp - 65, 65 corrisponde al valore ASCII della prima lettera minuscola dell'alfabeto
	neg a6, a6
	addi a6, a6, 25		 #temp  = 25 - temp, ottengo cosi l'inverso
	addi a6, a6, 97		 #temp = temp + 97, sommo 97 per avere l'equivalente minuscolo
	j dicc_L5			 #salto a dicc_L5 per scrivere il carattere

dicc_L2:
	li a4, 96
	ble a5, a4, dicc_L3		#salto se il char di input presente in itemp(a5) <= 96
	li a4, 122
	bgt a5, a4, dicc_L3		#salto se il char di input presente in itemp(a5)>122

	mv a6, a5
	addi a6, a6, -97	#temp(a6) = temp - 97
	neg a6, a6
	addi a6, a6, 25		#temp  = 25 - temp
	addi a6, a6, 65		#temp = temp + 65 #sommo 65 per ottenere l'equivalente maiuscolo
	j dicc_L5			#salto a dicc_L5 per scrivere il carattere

dicc_L3:
	li a4, 47
	ble a5, a4, dicc_L4		#salto se il char di input presente in itemp(a5) <= 47
	li a4, 57
	bgt a5, a4, dicc_L4		#salto se il char di input presente in itemp(a5)>57

	mv a6, a5
	addi a6, a6, -48	#temp(a6) = temp - 48
	neg a6, a6
	addi a6, a6, 9		#temp  = 9 - temp, eseguo la funzione (cod(9)-num)
	addi a6, a6, 48		#temp = temp + 48
	j dicc_L5			#salta a dicc_L5 per scrivere il carattre

dicc_L4:
	mv a6, a5 #copia a5 in a6, i simboli rimangono invariati
dicc_L5:
	lw a0, 0(sp)	# carica l'indirizzo cypthertext
	add a2, a0, a7	# cypthertext_address + i
	sb a6, 0(a2)	# scrive il carattere  codificato in a6
	addi a7, a7, 1	#i = i+1
	j dicc_while
dicc_exit:
	lw   ra, 8(sp) # ricarica l'indirizzo di ritorno dallo stack
    addi sp, sp, 12 # ripristina lo sp
    ret

############################################
AlgoritmoD_inverso:
	addi sp, sp, -12
    sw ra, 8(sp) # indirizzo di ritorno
	#la a0, cypthertext
    sw a0, 4(sp)  # indirizzo di cypthertext
	#la a1, cypthertext
    sw a1, 0(sp)  # indirizzo di cypthertext

	li a7, 0 		#i
dicdec_while:
	lw a0, 4(sp)	# carica l'indirizzo di myplaintext
	add a2, a0, a7	# myplaintext_address + i
	lb a5, 0(a2)	# carica il carattere in a5
	beqz a5, dicdec_exit	#if(itemp == 0) vai a dicc_exit
dicdec_L1:
	li a4, 64
	ble a5, a4, dicdec_L2	#salta se il char di input presente in itemp(a5) <= 64
	li a4, 90
	bgt a5, a4, dicdec_L2	#salta se il char di input presente in itemp(a5)>90

	mv a6, a5
	addi a6, a6, -65		#temp(a6) = temp - 65
	neg a6, a6
	addi a6, a6, 25			#temp  = 25 - temp
	addi a6, a6, 97			#temp = temp + 97
	j dicdec_L5				#salta dicdec_L5 per scrivere il carattere

dicdec_L2:
	li a4, 96
	ble a5, a4, dicdec_L3	#salta se il char di input presente in itemp(a5) <= 96
	li a4, 122
	bgt a5, a4, dicdec_L3	#salta se il char di input presente in itemp(a5) >122

	mv a6, a5
	addi a6, a6, -97		#temp(a6) = temp - 97
	neg a6, a6
	addi a6, a6, 25			#temp  = 25 - temp
	addi a6, a6, 65			#temp = temp + 65
	j dicdec_L5				#salta a dicdec_L5 per scrivere il carattere

dicdec_L3:
	li a4, 47
	ble a5, a4, dicdec_L4	#salta se il char di input presente in itemp(a5) <= 47
	li a4, 57
	bgt a5, a4, dicdec_L4	#salta se il char di input presente in itemp(a5) >57

	mv a6, a5
	addi a6, a6, -48		#temp(a6) = temp - 48
	neg a6, a6
	addi a6, a6, 9			#temp  = 9 - temp
	addi a6, a6, 48			#temp = temp + 48
	j dicdec_L5				#salta a dicdec_L5 per scrivere il carattere

dicdec_L4:
	mv a6, a5
dicdec_L5:
	lw a0, 0(sp)	# carica l'indirizzo di cypthertext
	add a2, a0, a7	# cypthertext_address + i
	sb a6, 0(a2)	# scrive il carattere decodificato in a6
	addi a7, a7, 1	#i = i+1
	j dicdec_while
dicdec_exit:
	lw   ra, 8(sp) # ricarica l'indirizzo di ritorno dallo stack
    addi sp, sp, 12 # ripristina lo sp
    ret


############################################
AlgoritmoE:
	addi sp, sp, -12
    sw ra, 8(sp) # indirizzo di ritorno
	#la a0, myplaintext
    sw a0, 4(sp)  # indirizzo di myplaintext
	#la a1, cypthertext
    sw a1, 0(sp)  # indirizzo di cypthertext

	li a7, 0 #i
invc_while:
	lw a0, 4(sp)	# carica l'indirizzo di myplaintext
	add a2, a0, a7	# myplaintext_address + i
	lb a5, 0(a2)	# carica il carattere in a5
	beqz a5, invc_L0
	addi a7, a7, 1	# i = i + 1
	j invc_while
invc_L0:
	mv a6, a7 #vengono scambiati 2 caratteri nella stringa di testo
	mv a5, a7
	srli a4, a5, 31
    add a5, a4, a5
    srai a5, a5, 1	#a5 = a5 / 2 sposto di 1 bit a destra ed effettua la divisione della stringa in 2 parti
	li a7, 0
invc_L1while: #questo ciclo incrementa il puntatore che punta al primo carattere della stringa, e decrementa il puntantore che punta alla fine della stringa
	bgt a7, a5, invc_exit

	lw a0, 4(sp)	# carica l'indirizzo di myplaintext
	add a2, a0, a7	# myplaintext_address + i
	lb a4, 0(a2)	# carica il carattere in a4

	addi a3, a6, -1
	lw a0, 4(sp)	# carica l'indirizzo di myplaintext
	add a2, a0, a3	#myplaintext_address + i
	lb a3, 0(a2)	# carica il carattere in a3

	lw a0, 0(sp)	# carica l'indirizzo di ciphertext
	add a2, a0, a7	# ciphertext_address + i
	sb a3, 0(a2)	# scrive il carattere in a3

	addi a3, a6, -1
	lw a0, 0(sp)	# carica l'indirizzo di ciphertext
	add a2, a0, a3	# ciphertext_address + i
	sb a4, 0(a2)	# scrive il carattere in a4

	addi a7, a7, 1	#i++
	addi a6, a6, -1	#n--
	j invc_L1while #effettuo questo ciclo fino a quando i puntatori non raggiungono il centro della stringa
invc_exit:
	lw   ra, 8(sp) # ricarica l'indirizzo di ritorno dallo stack
    addi sp, sp, 12 #ripristina lo sp
    ret

############################################
AlgoritmoE_inverso:
	addi sp, sp, -12
    sw ra, 8(sp) # indirizzo di ritorno
	#la a0, myplaintext
    sw a0, 4(sp)  # indirizzo di myplaintext
	#la a1, cypthertext
    sw a1, 0(sp)  # indirizzo di cypthertext

	li a7, 0 #i
invdec_while:
	lw a0, 4(sp)	# carica l'indirizzo di myplaintext
	add a2, a0, a7	# myplaintext_address + i
	lb a5, 0(a2)	# carico il carattere in a5
	beqz a5, invdec_L0
	addi a7, a7, 1	# i = i + 1
	j invdec_while
invdec_L0:
	mv a6, a7
	mv a5, a7
	srli a4, a5, 31
    add a5, a4, a5
    srai a5, a5, 1	#a5 = a5 / 2
	li a7, 0
invdec_L1while:
	bgt a7, a5, invdec_exit

	lw a0, 4(sp)	# carico l'indirizzo di myplaintext
	add a2, a0, a7	# myplaintext_address + i
	lb a4, 0(a2)	# carico il carattere in a4

	addi a3, a6, -1
	lw a0, 4(sp)	# carico l'indirizzo di myplaintext
	add a2, a0, a3	# myplaintext_address + i
	lb a3, 0(a2)	# carico il carattere in a3

	lw a0, 0(sp)	# carico l'indirizzo di ciphertext
	add a2, a0, a7	# ciphertext_address + i
	sb a3, 0(a2)	# scrivo il carattere in a3

	addi a3, a6, -1
	lw a0, 0(sp)	# carico l'indirizzo di ciphertext
	add a2, a0, a3	# ciphertext_address + i
	sb a4, 0(a2)	#scrivo il carattere in a4

	addi a7, a7, 1	#i++
	addi a6, a6, -1	#n--
	j invdec_L1while
invdec_exit:
	lw   ra, 8(sp) #ricarica l'indirizzo di ritorno dallo stack
    addi sp, sp, 12 #ripristina lo sp
    ret


############################################
AlgoritmoC:
	addi sp, sp, -20
    sw ra, 16(sp) # indirizzo di ritorno
	#la a3, ntotbuff
    sw a3, 12(sp)  # indirizzo di ntotbuff
	#la a2, filteredtext
    sw a2, 8(sp)  # indirizzo di filteredtext
	#la a1, occctext
    sw a1, 4(sp)  # indirizzo di occctext
	#la a0, cypthertext
    sw a0, 0(sp)  # indirizzo di cypthertext

		sw      zero,-4(sp)		#i = i + 0
occc_wl_citooc:					#ottiene la lunghezza della stringa
        lw     	a5,0(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-20(sp)		#temp = ciphertext[i]
        lb      a5,-20(sp)
        beqz    a5,occc_add_z_oct	#salta a occc_add_z_oct se temp=0, stringa termina
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a4,-20(sp)
        sb      a4,0(a5)		#occtext[i] = temp
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)		#i = i + 1
        j       occc_wl_citooc
occc_add_z_oct:					#aggiunge zero alla fine di occctext (null byte)
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        sb      zero,0(a5)		#occtext[i] = 0
        sw      zero,-4(sp)		#i = i + 0
occc_wl_ftb_z:
        lw      a4,-4(sp)
        li      a5,100 #dimensione massima di 100 caratteri
        bgt     a4,a5,occc_wl_ftb_z_b		#interruzione del ciclo se i > 100, i è più grande della memoria allocata
        lw      a5,8(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        sb      zero,0(a5)		#filter_text[i] = 0
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)		#i = i + 0
        j       occc_wl_ftb_z
occc_wl_ftb_z_b:
        sw      zero,-4(sp)		#i = 0
occc_wl_ftc:
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-20(sp)		#temp = occtext[i]
        lb      a5,-20(sp)
        beqz    a5,occc_wl_ftc_ex			#salta a occc_wl_ftc_ex se temp=0, esco dal ciclo, stringa terminata
        sw      zero,-8(sp)		#j = 0 aggiunge contatore che punta alla stringa criptata
        sb      zero,-16(sp)	#flag = 0
occc_wl_ftc_l1:
        lw      a5,8(sp)
        lw      a4,-8(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-24(sp)		#itemp = filter_text[j] analizza carattere da inserire nella stringa criptata
        lb      a5,-24(sp)
        bnez    a5,occc_wl_ftc_l2	#salto a occc_wl_ftc_l2 se itemp ≠ 0, salta se non termina
        li      a5,1
        sb      a5,-16(sp)		#imposta il flag
        j       occc_wl_ftc_l4
occc_wl_ftc_l2:
        lb      a4,-24(sp)
        lb      a5,-20(sp)
        bne     a4,a5,occc_wl_ftc_l3		#se itemp ≠ temp salta se i caratteri sono diversi
        sb      zero,-16(sp)	#flag = 0, operandi uguali
        j       occc_wl_ftc_l4
occc_wl_ftc_l3:
        lw      a5,-8(sp)
        addi    a5,a5,1
        sw      a5,-8(sp)		#j = j + 1
        j       occc_wl_ftc_l1
occc_wl_ftc_l4:
        lb      a5,-16(sp)
        beqz    a5,occc_wl_ftc_l5			#salto se il flag = 0
        lw      a5,8(sp)
        lw      a4,-8(sp)
        add     a5,a4,a5
        lb      a4,-20(sp)
        sb      a4,0(a5)		#filter_text[j] = temp, scrive il carattere
occc_wl_ftc_l5: #ciclo while se carattere già presente nella stringa criptata
        lw      a5,-4(sp)
        addi   	a5,a5,1
        sw      a5,-4(sp)		#i = i + 1
        j       occc_wl_ftc
occc_wl_ftc_ex:
        sw      zero,-4(sp)		#i = 0
        sw      zero,-28(sp)	#posizione = 0
occc_wl_cipher:					#converte integer in ASCII
        lw      a5,8(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-20(sp)		#temp = filter_text[i]
        lb      a5,-20(sp)
        beqz    a5,occc_wl_c_ex			#esco dal ciclo se termina la stringa
        lw      a5,0(sp)
        lw      a4,-28(sp)
        add     a5,a4,a5
        lb      a4,-20(sp)
        sb      a4,0(a5)		#mettere temp in ciphertext[posizione]
        lw      a5,-28(sp)
        addi    a5,a5,1
        sw      a5,-28(sp)		#posizione = posizione + 1
        sw      zero,-8(sp)		#j = 0
occc_wl_c_L1:
        lw      a5,4(sp)
        lw      a4,-8(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-24(sp)		#itemp = occtext[j]
        lb      a5,-24(sp)
        beqz    a5,occc_wl_c_L6	#occorrenze carattere terminate
        lb      a4,-24(sp)
        lb      a5,-20(sp)
        bne     a4,a5,occc_wl_c_L5		#se itemp ≠ temp il carattere non è presente nella stringa e viene eseguito il salto
        lw      a5,0(sp)
        lw      a4,-28(sp)
        add     a5,a4,a5
        li      a4,45
        sb      a4,0(a5)		#mettere '-' a ciphertext[posizione] = 45
        lw      a5,-28(sp)
        addi    a5,a5,1
        sw      a5,-28(sp)		#posizione = posizione + 1
        lw      a5,-8(sp)
        addi    a5,a5,1
        sw      a5,-32(sp)		#num = j + 1
        sw      zero,-12(sp)	#k = 0 posizione carattere
occc_wl_c_L2:					#converte il numero nel corrispondente ASCII
        lw      a4,-32(sp)
        li      a5,9
        bgt     a4,a5,occc_wl_c_L3		#salta se num > 9, cifra composta da più di un byte
        lw      a5,-32(sp)
        addi    a4,a5,48
        lw      a5,12(sp)
        lw      a3,-12(sp)
        add     a5,a3,a5
        sb      a4,0(a5)		#ntotbuff[k] = num + 48
        j       occc_wl_c_L4
occc_wl_c_L3:							#calcolo per cifre composte da più byte, num > 9
        lw      a4,-32(sp)
        li      a5,10
        rem     a5,a4,a5
        sw      a5,-36(sp)		#resto = num MOD 10
        lw      a5,-36(sp)
        addi    a4,a5,48
        lw      a5,12(sp)
        lw      a3,-12(sp)
        add     a5,a3,a5
        sb      a4,0(a5)		#ntotbuff[k] = resto + 48
        lw      a4,-32(sp)
        li      a5,10
        div     a5,a4,a5
        sw      a5,-32(sp)		#num = num / 10, scompongo la posizione
        lw      a5,-12(sp)
        addi    a5,a5,1
        sw      a5,-12(sp)		# k = k + 1
        j       occc_wl_c_L2
occc_wl_c_L4:	#posizionare la stringa numerica in ciphertext
        lw      a5,-12(sp)
        bltz    a5,occc_wl_c_L5			# salto se k < 0
        lw      a5,12(sp)
        lw      a4,-12(sp)
        add     a5,a4,a5
        lb      a4,0(a5)
        lw      a5,0(sp)
        lw      a3,-28(sp)
        add     a5,a3,a5
        sb      a4,0(a5)		#ciphertext[posizione] = ntotbuff[k]
        lw      a5,-28(sp)
        addi    a5,a5,1
        sw      a5,-28(sp)		#posizione = posizione + 1
        lw      a5,-12(sp)
        addi    a5,a5,-1
        sw      a5,-12(sp)		# k = k - 1
        j       occc_wl_c_L4

occc_wl_c_L5:
        lw      a5,-8(sp)
        addi    a5,a5,1
        sw      a5,-8(sp)		#j = j+1
        j       occc_wl_c_L1
occc_wl_c_L6: #aggiunge lo spazio
        lw      a5,0(sp)
        lw      a4,-28(sp)
        add     a5,a4,a5
        li      a4,32
        sb      a4,0(a5)		#aggiungo lo spazio, ciphertext[posizione] = 32
        lw      a5,-28(sp)
        addi    a5,a5,1
        sw      a5,-28(sp)		#posizione = posizione + 1
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)		#i	= i + 1
        j       occc_wl_cipher
occc_wl_c_ex:		#assicurati di cancellare l'ultimo spazio aggiungendo zero
        lw      a5,-28(sp)
        addi    a4,a5,-1
        lw      a5,0(sp)
        add     a5,a4,a5
        sb      zero,0(a5)		#ciphertext[posizione-1] = 0

occc_ret:
		lw   ra, 16(sp) # ricarica l'indirizzo di ritorno dallo stack
		addi sp, sp, 20 # ripristina lo sp
		ret

############################################
AlgoritmoC_inverso:
	addi sp, sp, -12
    sw ra, 8(sp) # indirizzo di ritorno
	#la a0, cypthertext
    sw a0, 4(sp)  # indirizzo di cypthertext
	#la a1, occctext
    sw a1, 0(sp)  # indirizzo di occctext


		sw      zero,-8(sp)			#j = 0
		sw      zero,-4(sp)			# i = 0
occdec_while:						#loop eseguito sui caratteri criptati
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-16(sp)			#ctemp = ciphertext[i]
        lb      a5,-16(sp)
        beqz    a5,occdec_L7		#se ctemp==0 salto a occdec_L7 (occorenze carattere terminate)
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)			#i = i +1
occdec_L1:							#loop eseguito sulla lettura della posizione dei caratteri
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-20(sp)			#ttemp = ciphertext[i]
        lb      a5,-20(sp)
        sw      a5,-12(sp)			#temp = int(ttemp)
        lw      a4,-12(sp)
        li      a5,32
        bne     a4,a5,occdec_L2		#salta se la posizione non corrisponde ad uno spazio
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)			#i = i+1
        j       occdec_L6			# if(temp == 32) {i++; break;}
occdec_L2:
        lw      a5,-12(sp) 		  #legge la posizione del byte successivo
        beqz    a5,occdec_L6		# if(temp == 0) { break;}
        lw      a4,-12(sp)
        li      a5,45
        beq     a4,a5,occdec_L5		# se temp corrisponde al "-" salta
        lw      a5,-12(sp)
        addi    a5,a5,-48
        sw      a5,-12(sp)			#converti il ​​carattere da ASCII a integer
occdec_L3:								#loop per calcolare la posizione
        lw      a5,-4(sp)
        addi    a4,a5,1
        lw      a5,4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-24(sp)			#char temp_n = ciphertext[i+1]
        lb      a4,-24(sp)
        li      a5,47
        ble     a4,a5,occdec_L4			#salta se più piccolo o uguale a 47
        lb      a4,-24(sp)
        li      a5,57
        bgt     a4,a5,occdec_L4			#salta se maggiore di 57
        lb      a5,-24(sp)
        addi    a5,a5,-48
        sb      a5,-24(sp)
        lw      a5,-12(sp)
		    li		a4, 10
	    	mul		a4, a5, a4
        lb      a5,-24(sp)
        add     a5,a4,a5
        sw      a5,-12(sp)			#temp = (temp * 10) + temp_n
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)			#contatore posizione +1
        j       occdec_L3			#ritorno all'interno del loop
occdec_L4: #loop eseguito quando la cifra della posizone è di un solo byte
        lw      a5,-12(sp)
        addi    a5,a5,-1			#ottengo la posizione corretta sottraendo 1 non c'è un altro numero dopo e quindi sottraggo 1 aggiunto prima e ho la posizione corretta
        sw      a5,-12(sp)		#scrivo la posizione corretta
        lw      a5,0(sp)
        lw      a4,-12(sp)
        add     a5,a4,a5
        lb      a4,-16(sp)
        sb      a4,0(a5)
        lw      a5,-8(sp)
        addi    a5,a5,1
        sw      a5,-8(sp)			#j = j + 1
occdec_L5:
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)			#i = i + 1
        j       occdec_L1

occdec_L6:
        j       occdec_while
occdec_L7:
        lw      a5,0(sp)
        lw      a4,-8(sp)
        add     a5,a4,a5
        sb      zero,0(a5)			#controllare se abbiamo aggiunto zero

        sw      zero,-4(sp)			#i = i + 1
occdec_L8:								#loop while per copiare la stringa occctext in cypthertext (inverso dell'algoritmo C)
        lw      a5,0(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a5,0(a5)
        sb      a5,-16(sp)
        lb      a5,-16(sp)
        beqz    a5,occdec_exit				#stringa terminata
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        lb      a4,-16(sp)
        sb      a4,0(a5)
        lw      a5,-4(sp)
        addi    a5,a5,1
        sw      a5,-4(sp)			#contatore i = i + 1
        j       occdec_L8			#loop again
occdec_exit:
        lw      a5,4(sp)
        lw      a4,-4(sp)
        add     a5,a4,a5
        sb      zero,0(a5)			#controllare di aver aggiunto zero alla fine

occdec_ret:
	lw   ra, 8(sp) # ricarica l'indirizzo di ritorno dallo stack
    addi sp, sp, 12 # ripristina lo sp
    ret


########################################################################
printNewline:
    la a0, newline
    li a7, 4
    ecall
    ret

exit:
    li a7, 10
    ecall
