;Trabalho de Organizacao de Computadores Digitais
;----------------------------------------------------
;Desenvolvedores:
;Pedro Lucas Castro de Andrade
;Luigi Quaglio
;Alexandre Lopes Ferreira Dias dos Santos
;Fernando Calaza
;----------------------------------------------------
; ------- TABELA DE CORES -------
; adicione ao caracter para Selecionar a cor correspondente

; 0 branco						0000 0000
; 256 marrom						0001 0000
; 512 verde						0010 0000
; 768 oliva						0011 0000
; 1024 azul marinho					0100 0000
; 1280 roxo						0101 0000
; 1536 teal						0110 0000
; 1792 prata						0111 0000
; 2048 cinza						1000 0000
; 2304 vermelho						1001 0000
; 2560 lima						1010 0000
; 2816 amarelo						1011 0000
; 3072 azul						1100 0000
; 3328 rosa						1101 0000
; 3584 aqua						1110 0000
; 3840 branco						1111 0000

;----------------------------------------------------

jmp main
MsnTop: string "               Snipper                "
Msn0: string "     G A M E  O V E R !!!     "
Msn1: string "    WANNA PLAY AGAIN? <Y/N>   "
Msn2: string "                              "

Letra: var #1			; Salva a letra que foi digitada

posChef: var #1			; Contem a posicao atual do Chef
posAntChef: var #1		; Contem a posicao anterior do Chef

posLimao: var #1		; Contem a posicao atual do Limao
posAntLimao: var #1		; Contem a posicao anterior do Limao

posFaca: var #1			; Contem a posicao atual do Faca
posAntFaca: var #1		; Contem a posicao anterior do Faca
FlagFaca: var #1		; Flag para ver se disparou ou nao (Barra de Espaco)
score: var #1
remains: var #1

;--------------- Codigo principal ---------------
main:
	
	call ApagaTela
	loadn R1, #telaInicialLinha0	; Endereco onde comeca a primeira linha do cenario
	loadn R2, #3584  				; Cor aqua
	call ImprimeTela2   			; Rotina de Impresao de Cenario na Tela Inteira  
	
	call Intro
	call ApagaTela
	
	loadn R1, #tela1Linha0	    	; Endereco onde comeca a primeira linha do cenario
	loadn R2, #3584  				; Cor aqua
	call ImprimeTela2   			; Rotina de Impresao de Cenario na Tela Inteira

	loadn R1, #56					; Posicao das facas restantes
	loadn R2, #'2'					; Chef comeca com 10 facas
	call ImprimeRemains

	loadn R1, #74					; Posicao do score
	loadn R2, #'0'					; Score inicia zerado
	;call ImprimeScore

	loadn R0, #180					; Posicao do Chef
	store posChef, R0				; Zera Posicao Atual do Chef
	store posAntChef, R0			; Zera Posicao Anterior do Chef
	call MoveChef_Desenha
	
	loadn R1, #0
	store FlagFaca, R1				; Zera o Flag para marcar que ainda nao disparou
	store posFaca, R0				; Zera Posicao Atual da Faca
	store posAntFaca, R0			; Zera Posicao Anterior da Faca
	
	loadn R0, #1117					; Posicao inicial do Limao
	store posLimao, R0				; Seta a Posicao Atual do Limao
	store posAntLimao, R0			; Seta a Posicao Anterior do Limao
	
	loadn R0, #0					; Contador para os Mods	= 0
	loadn R2, #0					; Para verificar se (mod(c/10)==0

	Loop:
	
		loadn R1, #10
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/10)==0
		ceq MoveChef	; Chama Rotina de movimentacao do Chef
	
		loadn R1, #30
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/30)==0
		ceq MoveLimao	; Chama Rotina de movimentacao do Limao
	
		loadn R1, #2
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/2)==0
		ceq MoveFaca	; Chama Rotina de movimentacao da Faca
	
		call Delay
		inc R0 	;c++
		jmp Loop
	rts

;--------------------------	
;Funcoes
;--------------------------

ImprimeRemains:
	outchar R2, R1
	dec R2
	store remains,R2
	rts


ImprimeScore:
	store score,R2
	outchar R2, R1 
	
MoveChef:
	push r0
	push r1
	
	call MoveChef_RecalculaPos		; Recalcula Posicao da Chef

; So' Apaga e Redesenha se (pos != posAnt)
;	If (posChef != posAntChef)	{	
	load r0, posChef
	load r1, posAntChef
	cmp r0, r1
	jeq MoveChef_Skip
		call MoveChef_Apaga
		call MoveChef_Desenha		;}
  MoveChef_Skip:
	
	pop r1
	pop r0
	rts

;--------------------------------
	
MoveChef_Apaga:		; Apaga a Chef preservando o Cenario!
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5	

	load R0, posAntChef	; R0 = posAnt
	
	; As linhas a seguir consideram a existencia de um cenario
	loadn R1, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	add R2, R1, r0	; R2 = Tela1Linha0 + posAnt
	loadn R4, #40
	div R3, R0, R4	; R3 = posAnt/40
	add R2, R2, R3	; R2 = Tela1Linha0 + posAnt + posAnt/40
	
	loadn R5, #' '	; R5 = Char (Tela(posAnt))
	
	outchar R5, R0	; Apaga arco 3
	dec R0
	outchar R5, R0	; Apaga pes Chef
	inc R0
	sub R0, R0, R4	; Subtrai 40 da posicao para apagar o arco 2
	outchar R5, R0	; Apaga o arco 2
	dec R0
	outchar R5, R0	; Apaga o tronco do Chef
	inc R0
	sub R0, R0, R4	; Subtrai 40 da posicao para apagar o arco 1
	outchar R5, R0	; Apaga o arco 1
	dec R0
	outchar R5, R0	; Apaga a cabeca do Chef	
	
	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts
;----------------------------------	
	
MoveChef_RecalculaPos:		; Recalcula posicao da Chef em funcao das Teclas pressionadas
	push R0
	push R1
	push R2
	push R3

	load R0, posChef
	
	inchar R1				; Le Teclado para controlar a Chef
		
	loadn R2, #'w'
	cmp R1, R2
	jeq MoveChef_RecalculaPos_W
		
	loadn R2, #'s'
	cmp R1, R2
	jeq MoveChef_RecalculaPos_S
	
	loadn R2, #' '
	cmp R1, R2
	jeq MoveChef_RecalculaPos_Faca
	
  MoveChef_RecalculaPos_Fim:	; Se nao for nenhuma tecla valida, vai embora
	store posChef, R0
	pop R3
	pop R2
	pop R1
	pop R0
	rts  
	
  FazNada:
  	nop
  	jmp MoveChef_RecalculaPos_Fim
  	
  MoveChef_RecalculaPos_W:	; Move Chef para Cima	
	
	; Evitar que o arqueiro se mova para o header
	loadn R1, #80
	cmp R0, R1
	jeq FazNada
	
	loadn R1, #40
	
	cmp R0, R1		; Testa condicoes de Contorno
	jle MoveChef_RecalculaPos_Fim
	sub R0, R0, R1	; pos = pos - 40
	jmp MoveChef_RecalculaPos_Fim

  MoveChef_RecalculaPos_S:	; Move Chef para Baixo
  
  ; Evitar que o arqueiro se mova para o footer
	loadn R1, #1080
	cmp R0, R1
	jeq FazNada
  
	;loadn R1, #1159
	;cmp R0, R1		; Testa condicoes de Contorno 
	;jgr MoveChef_RecalculaPos_Fim
	loadn R1, #40
	add R0, R0, R1	; pos = pos + 40
	jmp MoveChef_RecalculaPos_Fim	
	
  MoveChef_RecalculaPos_Faca:	
	loadn R1, #1			; Se a Faca:
	store FlagFaca, R1		; FlagFaca = 1
	store posFaca, R0		; posFaca = posChef
	
	load R2, remains
	loadn R3, #'0'
	cmp R2, R3
	jle GameOver
	
	loadn R1, #56
	call ImprimeRemains
		
	jmp MoveChef_RecalculaPos_Fim
	call ApagaTela	
;----------------------------------
MoveChef_Desenha:	; Desenha caractere da Chef
	push R0
	push R1
	push R2
	push R3
	
	Loadn R1, #'"'	; Cabeca Chef
	load R0, posChef
	outchar R1, R0
	
	Loadn R1, #'#'	; Arco 1		
	inc R0
	outchar R1, R0
	
	loadn R3, #2816	;cor amarela
	
	Loadn R1, #'$'	; Corpo Chef
	add R1, R1, R3	
	dec R0
	Loadn R2, #40
	add R0, R0, R2
	outchar R1, R0
			
	inc R0
	
	loadn R3, #1024	;cor azul
	
	Loadn R1, #'&'	; Corpo Chef	
	add R1, R1, R3
	dec R0
	Loadn R2, #40
	add R0, R0, R2
	outchar R1, R0
	
	Loadn R1, #'|'	; Arco 2		
	inc R0
	outchar R1, R0
	
	store posAntChef, R0	; Atualiza Posicao Anterior da Chef = Posicao Atual	 
	
	pop R3
	pop R2
	pop R1
	pop R0
	rts

;----------------------------------
;----------------------------------
;----------------------------------

MoveLimao:
	push r0
	push r1
	
	call MoveLimao_RecalculaPos
	
; So' Apaga e Redesenha se (pos != posAnt)
;	If (pos != posAnt)	{	
	load r0, posLimao
	load r1, posAntLimao
	cmp r0, r1
	jeq MoveLimao_Skip
		call MoveLimao_Apaga
		call MoveLimao_Desenha		;}
  MoveLimao_Skip:
  
	pop r1
	pop r0
	rts
		
; ----------------------------
		
MoveLimao_Apaga:
	push R0
	push R4
	push R5

	load R0, posAntLimao	; R0 == posAnt
		loadn r5, #' '		; Se a Faca passa sobre o Chef, apaga com o cenario 
  
  ;MoveLimao_Apaga_Fim:	
  	loadn R4, #40
	outchar R5, R0	; Apaga Limao 4
	dec R0
	outchar R5, R0	; Apaga Limao 3
	inc R0
	sub R0, R0, R4
	outchar R5, R0	; Apaga Limao 2
	dec R0
	outchar R5, R0	; Apaga Limao 1	
	
	pop R5
	pop R4
	pop R0
	rts

MoveLimao_RecalculaPos:
	push R0
	push R1
	push R2
	push R3
	
	load R0, posLimao
	
 ; Case 1 : posLimao = posLimao - 1
   MoveLimao_RecalculaPos_Case1:
	loadn r1, #1
	loadn r2, #1081
	sub r0, r0, r1
	cmp r0,r2
		jel RetomaPos
		
  	jmp MoveLimao_RecalculaPos_FimSwitch	; Break do Switch

   RetomaPos:
	loadn R0, #1118
	jmp MoveLimao_RecalculaPos_Case1


 ; Fim Switch:
  MoveLimao_RecalculaPos_FimSwitch:	
	store posLimao, R0	; Grava a posicao alterada na memoria
	pop R3
	pop R2
	pop R1
	pop R0
	rts

;----------------------------------
MoveLimao_Desenha:
	push R0
	push R1
	push R2
	push R3
	
	loadn R3, #2560	;Cor lima
	
	loadn R1, #'{'	; Limao 1
	add R1, R1, R3
	load R0, posLimao
	outchar R1, R0	
	
	loadn R1, #'z'	; Limao 2
	add R1, R1, R3
	inc R0
	outchar R1, R0
	
	loadn R1, #'}' ; Limao 3
	add R1, R1, R3	
	loadn R2, #40
	dec R0
	add R0, R0, R2
	outchar R1, R0
	
	loadn R1, #'~'	; Limao 2
	add R1, R1, R3
	inc R0
	outchar R1, R0
	
	store posAntLimao, R0	
	
	pop R3
	pop R2
	pop R1
	pop R0
	rts

;----------------------------------
;----------------------------------
;--------------------------

MoveFaca:
	push r0
	push r1
	
	call MoveFaca_RecalculaPos

; So' Apaga e Redesenha se (pos != posAnt)
;	If (pos != posAnt)	{	
	load r0, posFaca
	load r1, posAntFaca
	cmp r0, r1
	jeq MoveFaca_Skip
		call MoveFaca_Apaga
		call MoveFaca_Desenha		;}
  MoveFaca_Skip:
	
	pop r1
	pop r0
	rts

;-----------------------------
	
MoveFaca_Apaga:
	push R0
	push R1
	push R2
	push R3
	push R4
	push R5	

	load R0, posAntFaca	; R0 = posAnt
	loadn R5, #' '		; Se o Faca passa sobre o Chef, apaga com um X, senao apaga com o cenario 		

  ;MoveFaca_Apaga_Fim:	
	outchar R5, R0	; Apaga o Obj na tela com o Char correspondente na memoria do cenario
	loadn R1, #40
	sub R0, R0, R1  ; Decrementa a posicao do Obj
	outchar R5, R0	; Apaga o segundo elemento que compoe o Obj
	
	pop R5
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts
;----------------------------------	
	
	
; if FacaFlag = 1
;	posFaca++
	
MoveFaca_RecalculaPos:
	push R0
	push R1
	push R2
	push R3
	push R4
	
	load R1, FlagFaca	; Se disparou, movimenta a Faca!
	loadn R2, #1
	cmp R1, R2			; If FlagFaca == 1  Movimenta o Faca
	jne MoveFaca_RecalculaPos_Fim2	; Se nao vai embora!
	
	load R0, posFaca	; Testa se o Faca Pegou no Limao
	load R1, posLimao
	loadn R2, #1
	sub R1, R1, R2
	cmp R0, R1			; IF posFaca == posLimao  BOOM!!	
		jeq MoveFaca_RecalculaPos_Boom
		
	load R1, posAntLimao
	loadn R2, #1
	sub R1, R1, R2
	cmp R0, R1			; IF posFaca == posLimao  BOOM!!	
		jeq MoveFaca_RecalculaPos_Boom
	
	loadn R1, #40		; Testa condicoes de Contorno 
	loadn R2, #100
	mod R1, R0, R1	
	call MoveFaca_Apaga	
	cmp R1, R2			; Se Faca chegou na ultima linha
	jel MoveFaca_RecalculaPos_Fim
	
	loadn R0, #0
	store FlagFaca, R0	; Zera FlagFaca
	store posFaca, R0	; Zera e iguala posFaca e posAntFaca
	store posAntFaca, R0
	
	loadn R2, #1180
	cmp R0, R2
	call MoveFaca_Apaga
	jne MoveFaca_RecalculaPos_Fim
	loadn R0, #0
	store FlagFaca, R0	; Zera FlagFaca
	store posFaca, R0	; Zera e iguala posFaca e posAntFaca
	store posAntFaca, R0
	
	jmp MoveFaca_RecalculaPos_Fim2
	
  MoveFaca_RecalculaPos_Fim:
  ; Movimenta p/ baixo 
	loadn R4, #40
	add R0, R0, R4
	store posFaca, R0
	
  MoveFaca_RecalculaPos_Fim2:
  	pop R4
  	pop R3	
	pop R2
	pop R1
	pop R0
	rts

  MoveFaca_RecalculaPos_Boom:	
  	loadn R3, #'*'
	outchar R3, R1
	call delay2
	call delay2
	call delay2
	loadn R3, #' '
	outchar R3, R1
	
	;Muda o score quando atinge o Limao
	loadn R1, #74
  	load R2, score
  	inc R2
  	;call ImprimeScore
  	
	jmp RetomaPos ; apos fazer efeito de atingir o Limao, volta pro inicio
	   		
	GameOver:
	loadn R0, #160	
	store posChef, R0		; Zera Posicao Atual da Chef
	store posAntChef, R0	; Zera Posicao Anterior da Chef
	call ApagaTela
	loadn r0, #40
	loadn r1, #MsnTop
	loadn r2, #0
	call ImprimeStr
	
  	loadn r0, #526
	loadn r1, #Msn0
	loadn r2, #0
	call ImprimeStr
	
	;imprime quer jogar novamente	
	loadn r0, #605
	loadn r1, #Msn1
	loadn r2, #0
	call ImprimeStr
	
	loadn r0, #758
	loadn r1, #Msn2
	loadn r2, #0
	call ImprimeStr
	
	loadn R1, #783
	load R2, score
	;call ImprimeScore
	
	call DigLetra
	loadn r0, #'y'
	load r1, Letra
	cmp r0, r1				; tecla == 'y' ?
	jne MoveFaca_RecalculaPos_FimJogo	; tecla nao e' 'y'
	
	; Se quiser jogar novamente...
	call ApagaTela
	
	pop r2
	pop r1
	pop r0

	pop r0	; Da um Pop a mais para acertar o ponteiro da pilha, pois nao vai dar o RTS
	jmp main

  MoveFaca_RecalculaPos_FimJogo:
	call ApagaTela
	halt



delay2:
	loadn R3,#120000000000000
wait:
	dec R3
	jnz wait
	
	
;----------------------------------
MoveFaca_Desenha:
	push R0
	push R1
	push R2	
	
	Loadn R2, #'|'	; Faca ponta
	inc R0
	outchar R2, R0	
	
	store posAntFaca, R0
	
	pop R2
	pop R1
	pop R0
	rts

;----------------------------------

; ---------- Intro ---------------
Intro:
	push r1
	push r2

	loadn r1, #0
	loadn r2, #13 ; numero do enter

intro_volta:
	inchar r1
	cmp r1, r2
	jeq intro_fim	; se for o enter
	jmp intro_volta


intro_fim:
	pop r2
	pop r1
	rts

;********************************************************
;                       DELAY
;********************************************************		


Delay:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	Push R0
	Push R1
	
	Loadn R1, #5  ; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	Loadn R0, #10000	; b - atrasa a Faca
   Delay_volta: 
	Dec R0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	JNZ Delay_volta	
	Dec R1
	JNZ Delay_volta2
	
	Pop R1
	Pop R0
	
	RTS							;return

;-------------------------------


;********************************************************
;                       IMPRIME TELA
;********************************************************	

ImprimeTela: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r4 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200

	pop r5	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;---------------------

;---------------------------	
;********************************************************
;                   IMPRIME STRING
;********************************************************
	
ImprimeStr:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

   ImprimeStr_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;********************************************************
;                       IMPRIME TELA2
;********************************************************	

ImprimeTela2: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0			; protege o r3 na pilha para ser usado na subrotina
	push r1			; protege o r1 na pilha para preservar seu valor
	push r2			; protege o r1 na pilha para preservar seu valor
	push r3			; protege o r3 na pilha para ser usado na subrotina
	push r4			; protege o r4 na pilha para ser usado na subrotina
	push r5			; protege o r5 na pilha para ser usado na subrotina
	push r6			; protege o r6 na pilha para ser usado na subrotina
	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	loadn R6, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	
   ImprimeTela2_Loop:
		call ImprimeStr2
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		add r6, r6, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela2_Loop	; Enquanto r0 < 1200

	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;********************************************************
;                   IMPRIME STRING2
;********************************************************
	
ImprimeStr2:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina
	
	
	loadn r3, #'\0'	; Criterio de parada
	loadn r5, #' '	; Espaco em Branco

   ImprimeStr2_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr2_Sai
		cmp r4, r5		; If (Char == ' ')  vai Pula outchar do espaco para na apagar outros caracteres
		jeq ImprimeStr2_Skip
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		storei r6, r4
   ImprimeStr2_Skip:
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		inc r6			; Incrementa o ponteiro da String da Tela 0
		jmp ImprimeStr2_Loop
	
   ImprimeStr2_Sai:	
	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	

;********************************************************
;                   DIGITE UMA LETRA
;********************************************************

DigLetra:					; Espera que uma tecla seja digitada e salva na variavel global "Letra"
	push r0
	push r1
	loadn r1, #255			; Se nao digitar nada vem 255

   DigLetra_Loop:
		inchar r0			; Le o teclado, se nada for digitado = 255
		cmp r0, r1			; Compara r0 com 255
		jeq DigLetra_Loop	; Fica lendo ate' que digite uma tecla valida

	store Letra, r0			; Salva a tecla na variavel global "Letra"

	pop r1
	pop r0
	rts



;----------------
	
;********************************************************
;                       APAGA TELA
;********************************************************
ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts	

	
;------------------------	
; Declara uma tela vazia para ser preenchida em tempo de execucao:
tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                                        "
tela0Linha8  : string "                                        "
tela0Linha9  : string "                                        "
tela0Linha10 : string "                                        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                                        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "

; Declara e preenche tela linha por linha (40 caracteres):
tela1Linha0  : string "|======================================|"
tela1Linha1  : string "| SHOTS REMAINS:                       |"
tela1Linha2  : string "|                                      |"
tela1Linha3  : string "|                                      |"
tela1Linha4  : string "|                                      |"
tela1Linha5  : string "|                                      |"
tela1Linha6  : string "|                                      |"
tela1Linha7  : string "|                                      |"
tela1Linha8  : string "|                                      |"
tela1Linha9  : string "|                                      |"
tela1Linha10 : string "|                                      |"
tela1Linha11 : string "|                                      |"
tela1Linha12 : string "|                                      |"
tela1Linha13 : string "|                                      |"
tela1Linha14 : string "|                                      |"
tela1Linha15 : string "|                                      |"
tela1Linha16 : string "|                                      |"
tela1Linha17 : string "|                                      |"
tela1Linha18 : string "|                                      |"
tela1Linha19 : string "|                                      |"
tela1Linha20 : string "|                                      |"
tela1Linha21 : string "|                                      |"
tela1Linha22 : string "|                                      |"
tela1Linha23 : string "|                                      |"
tela1Linha24 : string "|                                      |"
tela1Linha25 : string "|                                      |"
tela1Linha26 : string "|                                      |"
tela1Linha27 : string "|                                      |"
tela1Linha28 : string "|                                      |"
tela1Linha29 : string "|======================================|"


; Declara e preenche tela linha por linha (40 caracteres):					                  
;---------------------------------------------------------					
telaInicialLinha0  : string "|======================================|"
telaInicialLinha1  : string "|                                      |"
telaInicialLinha2  : string "|                                      |"
telaInicialLinha3  : string "|                                      |"
telaInicialLinha4  : string "|                                      |"
telaInicialLinha5  : string "|                                      |"
telaInicialLinha6  : string "|                                      |"
telaInicialLinha7  : string "|                                      |"
telaInicialLinha8  : string "|                                      |"
telaInicialLinha9  : string "|                          @           |"
telaInicialLinha10 : string "|             CHEFF SNIPER $           |"
telaInicialLinha11 : string "|                                      |"
telaInicialLinha12 : string "|                                      |"
telaInicialLinha13 : string "|                   {z                 |"
telaInicialLinha14 : string "|                   }~                 |"
telaInicialLinha15 : string "|                                      |"
telaInicialLinha16 : string "|                                      |"
telaInicialLinha17 : string "|          PRESS SPACE TO FIRE         |"
telaInicialLinha18 : string "|                                      |"
telaInicialLinha19 : string "|                                      |"
telaInicialLinha20 : string "|                                      |"
telaInicialLinha21 : string "|                                      |"
telaInicialLinha22 : string "|                                      |"
telaInicialLinha23 : string "|                                      |"
telaInicialLinha24 : string "|                                      |"
telaInicialLinha25 : string "|                                      |"
telaInicialLinha26 : string "|                                      |"
telaInicialLinha27 : string "|         PRESS ENTER TO START         |"
telaInicialLinha28 : string "|                                      |"
telaInicialLinha29 : string "|======================================|"