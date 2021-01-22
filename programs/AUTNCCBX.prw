#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

#Define lxTeste .T.
#Define lxTrace .T.

/*
    AUTNCCBX
    Função de Baixa Automática de Títulos NCC feita por Job
    Victor Santos Henrique
    03/11/2020
*/
User Function AUTNCCBX()
	Local oProgresso 
	Local aAreaSE1 := {} 

	Private axLog      := {}

	Private bLastError

	Private lRet       := .T.
	Private lJob       := .T.

	Private cxAliNF    := GetNextAlias()
	Private cxAliNCC   := GetNextAlias()

	Private oError

	If FWGetRunSchedule()
		RunProcBar(oProgresso)
	Else
		lJob := .F.
		aAreaSE1   := SE1->(GetArea())
		oProgresso := MsNewProcess():New( { || RunProcBar(oProgresso) }, "Compensação Automática de títulos NCC", "" )
		oProgresso:Activate()
		RestArea(aAreaSE1)
	EndIf
Return lRet

Static Function RunProcBar(oProgresso)
	If lJob 
		aadd(axLog, 'Job AUTNCCBX iniciando: ' + DTOC(Date()) + ' - ' + Time() + CRLF)
	Else
		aadd(axLog, 'Chamada direta AUTNCCBX iniciando: ' + DTOC(Date()) + ' - ' + Time() + CRLF)
	EndIf

	bLastError := ErrorBlock({|e| oError := e})
	BEGIN SEQUENCE
		GetTitNCC(oProgresso)

		ProcDados(oProgresso)
    RECOVER
		aadd(axLog, 'Erro durante o processamento do título! O processo foi abortado.')
		aadd(axLog, 'Erro: ' + oError:Description)
	END SEQUENCE
	ErrorBlock( bLastError )

	U_ShowLogArray( axLog, "Log de Compensação Automática de títulos NCC", "M", 10, .T., '\Log\CompensaNCC\CompensaNCC-' + dtos(date()) + '-' + StrTran(Time(),':','') + '.log', .T. )
Return 

/*
    Busca Todos os títulos tipo NCC a partir da data fixada.
*/
Static Function GetTitNCC(oProgresso)
	Local dDataComp := Date() - 2

	BEGINSQL Alias cxAliNCC
        SELECT
			E1_VALOR
			,E1_SALDO
			,E1_FILIAL
			,E1_CLIENTE
			,E1_LOJA
			,E1_PREFIXO
			,E1_NUM
			,E1_PARCELA
			,E1_TIPO
			,R_E_C_N_O_ AS RECNCC 
		FROM %table:SE1% 
		WHERE  
				%NotDel% 
			AND E1_FILIAL   = %exp:xFilial("SE1")% 
			AND E1_TIPO     = 'NCC' 
			AND E1_PREFIXO NOT IN ('PNE', 'VRB')
			AND E1_SALDO    = E1_VALOR
			AND E1_X_DTLIB <> ''
			AND E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA+E1_FILORIG IN (
				SELECT INDICE 
				FROM (
					SELECT 
						D1_SERIE+D1_DOC+D1_FORNECE+D1_LOJA+D1_FILIAL AS INDICE
						,AVG(F2_VALBRUT) AS F2_VALBRUT
						,AVG(F1_VALBRUT) AS F1_VALBRUT
					FROM %table:SD1% AS SD1  
						INNER JOIN %table:SF1% AS SF1
							ON  F1_FILIAL  = D1_FILIAL
							AND F1_DOC     = D1_DOC
							AND F1_SERIE   = D1_SERIE
							AND F1_FORNECE = D1_FORNECE
							AND F1_LOJA    = D1_LOJA
							AND F1_TIPO    = D1_TIPO
							AND SF1.%NotDel%
						INNER JOIN %table:SD2% AS SD2  
							ON  D2_FILIAL  = D1_FILIAL 
							AND D2_DOC     = D1_NFORI 
							AND D2_SERIE   = D1_SERIORI 
							AND D2_ITEM    = D1_ITEMORI 
							AND D2_CLIENTE = D1_FORNECE 
							AND D2_LOJA    = D1_LOJA 
							AND SD2.%NotDel%
						INNER JOIN %table:SF2% AS SF2
							ON  F2_FILIAL  = D2_FILIAL  
							AND F2_DOC     = D2_DOC     
							AND F2_SERIE   = D2_SERIE   
							AND F2_CLIENTE = D2_CLIENTE 
							AND F2_LOJA    = D2_LOJA    
							AND F2_TIPO    = D2_TIPO 
							AND SF2.%NotDel%
					WHERE  
						SD1.%NotDel% 
						AND D1_TIPO     = 'D' 
						AND D1_FORMUL   = 'S'
						AND D1_DTDIGIT  <= %exp:dDataComp%
					GROUP BY D1_SERIE+D1_DOC+D1_FORNECE+D1_LOJA+D1_FILIAL
				)  AS AUX 
				WHERE  F2_VALBRUT = F1_VALBRUT 
			)
		ORDER BY E1_PREFIXO, E1_NUM
	ENDSQL
Return

/*
    Busca os títulos NF referentes aos NCCs localizados anteriormente
*/
Static Function GetTitNF(oProgresso)
	BEGINSQL Alias cxAliNF
        SELECT 
             E1_FILIAL
            ,E1_CLIENTE
            ,E1_LOJA
            ,E1_PREFIXO
            ,E1_NUM
            ,E1_PARCELA
            ,E1_TIPO
            ,E1_NATUREZ
            ,E1_TXMOEDA
            ,R_E_C_N_O_ AS RECNF
        FROM %table:SE1%
        WHERE 
            %NotDel%
            AND E1_FILIAL = %xFilial:SE1%
            AND E1_TIPO  IN ('NF ', 'AB-')
			AND E1_SALDO > 0
            AND E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA IN (
                SELECT DISTINCT D1_SERIORI+D1_NFORI+D1_FORNECE+D1_LOJA
                FROM %table:SD1%
                WHERE
                    %NotDel%
                    AND D1_TIPO   = 'D'
                    AND D1_FORMUL = 'S'
                    AND D1_DOC    = %exp:(cxAliNCC)->E1_NUM%
                    AND D1_SERIE  = %exp:(cxAliNCC)->E1_PREFIXO%
            )
        ORDER BY E1_PREFIXO, E1_NUM
	ENDSQL
Return

Static Function ProcDados(oProgresso)
	Local cIdentNCC  := ""

	Local nContNF    := 0
	Local nContNCC   := 0
	Local nTotalReg1 := 0
	Local nTotalReg2 := 0

	(cxAliNCC)->(dbEval({|| nTotalReg1++}, , {|| !EOF()}))
	(cxAliNCC)->(dbGoTop())

	If nTotalReg1 > 0
		oProgresso:SetRegua1(nTotalReg1)
		aadd(axLog, "Início do processo!" + CRLF)
		While !(cxAliNCC)->( EOF() )
			nContNCC++
			SE1->(dbGoTo((cxAliNCC)->RECNCC))
			cIdentNCC := 'PREFIXO: '  + SE1->E1_PREFIXO 
			cIdentNCC += ' NUMERO: '  + SE1->E1_NUM 
			cIdentNCC += ' PARCELA: ' + SE1->E1_PARCELA 
			cIdentNCC += ' TIPO: '    + SE1->E1_TIPO 
			cIdentNCC += ' CLIENTE: ' + SE1->E1_CLIENTE 
			cIdentNCC += ' LOJA: '    + SE1->E1_LOJA
			cIdentNCC += ' SALDO: '   + Transform(SE1->E1_SALDO, "@E 9,999,999.99")
			cIdentNCC += ' RECNO: '   + cValToChar((cxAliNCC)->RECNCC)
			aadd(axLog, 'Título NCC Identificação => ' + cIdentNCC + CRLF)

			oProgresso:IncRegua1("Processando Título NCC " + SE1->E1_NUM + " (" + cValToChar(nContNCC) + "/" + cValToChar(nTotalReg1) + ")")

			GetTitNF(oProgresso)

			nTotalReg2 := 0
			(cxAliNF)->(dbEval({|| nTotalReg2++}, , {|| !EOF()}))
			(cxAliNF)->(dbGoTop())

			If nTotalReg2 > 0
				aadd(axLog, '    Processando os títulos NF:' + CRLF)

				nContNF := 0
				oProgresso:SetRegua2(nTotalReg2)
				While !(cxAliNF)->( EOF() )
					nContNF++
					oProgresso:IncRegua2("Processando Título NF  " + SE1->E1_NUM + " (" + cValToChar(nContNF) + "/" + cValToChar(nTotalReg2) + ")")

					lRet := ProcTits()

					(cxAliNF)->(dbSkip())
				End
				aadd(axLog, 'Processamento finalizado!' + CRLF)
			Else
				aadd(axLog, '    Não foram encontrados títulos NF para compensar a NCC!' + CRLF + CRLF)
				aadd('------------------------------------------------------------------------------------------' + CRLF + CRLF)
			EndIf
			(cxAliNF)->(dbCloseArea())

			(cxAliNCC)->(dbSkip())
		End
	Else
		aadd(axLog, '    Não foram encontrados títulos NCC para compensar!' + CRLF + CRLF)
		aadd('------------------------------------------------------------------------------------------' + CRLF + CRLF)
	EndIf
	(cxAliNCC)->(dbCloseArea())
Return lRet

/*
    Processa a baixa dos títulos NCC e dos descontos AB- referentes aos mesmos
*/
Static Function ProcTits()
	Local aRecNF       := {}
	Local aBaixa       := {}
	Local aRecNCC      := {}

	Local cIdentNF
	Local cIdentAB

	Local lJuros       := .F. // 5
	Local lDigita      := .F. // 3
	Local lAglutina    := .F. // 2
	Local lComisNCC    := .T. // 6
	Local lDesconto    := .F. // 4
	Local lContabiliza := .T. // 1
	Local lMsErroAuto  := .F.

	Local nSaldoComp   := 0 // Valor a ser compensado

	Private aItemsFI2  := {}

	// SX1 - FIN330
	MV_PAR01 := 2        // Considera Loja  Sim/Nao
	MV_PAR02 := 1        // Considera Cliente     Original/Outros
	MV_PAR03 := ''       // Do Cliente
	MV_PAR04 := 'ZZZZZZ' // Ate Cliente
	MV_PAR05 := 1        // Compensa Titulos Transferidos S/[N]
	MV_PAR06 := 2        // Calcula Comissao sobre valores de NCC
	MV_PAR07 := 1        // Mostra Lancto Contabil
	MV_PAR08 := 1        // Considera abatimentos para compensar
	MV_PAR09 := 2        // Contabiliza On-Line
	MV_PAR10 := 1        // Considera Filiais abaixo
	MV_PAR11 := '01'     // Filial De
	MV_PAR12 := 'ZZ'     // Filial Ate
	MV_PAR13 := 1        // Calcula Comissao sobre valores de RA
	MV_PAR14 := 2        // Reutiliza taxas informadas
	MV_PAR15 := 2        // Cons.Juros Comissão ?

	aRecNCC := { (cxAliNCC)->RECNCC }
	aRecNF  := { (cxAliNF )->RECNF  }

	SE1->(dbGoTo((cxAliNF)->RECNF))

    /*
        SaldoTit()
        cPrefixo   [ 1] Numero do Prefixo
        cNumero    [ 2] Numero do Titulo
        cParcela   [ 3] Parcela
        cTipo      [ 4] Tipo
        cNatureza  [ 5] Natureza
        cCart      [ 6] Carteira  (R/P)
        cCliFor    [ 7] Fornecedor(se cCart = 'R')
        nMoeda     [ 8] Moeda
        dData      [ 9] Data para conversao
        dDataBaixa [10] Data data baixa a ser considerada (retroativa)
        cLOja      [11] Loja do titulo
        cFilTit    [12] Filial do titulo
        nTxMoeda   [13] Taxa da Moeda
        nTipoData  [14] Tipo de data para compor saldo (baixa/dispo/digit)
    */
	//                           [ 1]           [ 2]           [ 3]            [ 4]           [ 5]       [ 6]      [ 7]       [ 8]   [ 9]   [10]    [11]    [12]     [13]      [14]
	nSaldoComp := SaldoTit( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_NATUREZ, "R", SE1->E1_CLIENTE, 1, dDataBase, , SE1->E1_LOJA, , SE1->E1_TXMOEDA, 1)

	If SE1->E1_TIPO == 'AB-'
		cIdentAB := 'PREFIXO: '  + SE1->E1_PREFIXO 
		cIdentAB += ' NUMERO: '  + SE1->E1_NUM 
		cIdentAB += ' PARCELA: ' + SE1->E1_PARCELA 
		cIdentAB += ' TIPO: '    + SE1->E1_TIPO 
		cIdentAB += ' CLIENTE: ' + SE1->E1_CLIENTE 
		cIdentAB += ' LOJA: '    + SE1->E1_LOJA
		cIdentAB += ' SALDO: '   + Transform(SE1->E1_SALDO, "@E 9,999,999.99")
		cIdentAB += ' RECNO: '   + cValtoChar(aRecNCC[1])
		aadd(axLog, '    FINA070, recuperação do AB- Identificação -> ' + cIdentAB + CRLF)

		aadd(aBaixa, {"E1_PREFIXO"  ,(cxAliNCC)->E1_PREFIXO,Nil} )
		aadd(aBaixa, {"E1_NUM"      ,(cxAliNCC)->E1_NUM    ,Nil} )
		aadd(aBaixa, {"E1_PARCELA"  ,(cxAliNCC)->E1_PARCELA,Nil} )
		aadd(aBaixa, {"E1_TIPO"     ,(cxAliNCC)->E1_TIPO   ,Nil} )
		aadd(aBaixa, {"AUTMOTBX"    ,"RNC"                 ,Nil} )
		aadd(aBaixa, {"AUTDTBAIXA"  ,dDataBase             ,Nil} )
		aadd(aBaixa, {"AUTDTCREDITO",dDataBase             ,Nil} )
		aadd(aBaixa, {"AUTHIST"     ,"COMP AUT NCC"        ,Nil} )
		aadd(aBaixa, {"AUTVALREC"   ,nSaldoComp            ,Nil} )

		MSExecAuto ( {|x,y| FINA070(x,y)}, aBaixa )

		If lMsErroAuto
			If !lJob
				MostraErro()
				aadd(axLog, '    Erro na recuperação do título AB- Identificação -> ' + cIdentAB + CRLF)
			Else
				conout(MostraErro())
				aadd(axLog, '    Erro na recuperação do título AB- Identificação -> ' + cIdentAB + CRLF)
			EndIf
		Else
			aadd(axLog, '    Recuperação realizada com sucesso!' + CRLF)
		EndIf
	ElseIf SE1->E1_TIPO == 'NF '
		cIdentNF := 'PREFIXO: '  + SE1->E1_PREFIXO 
		cIdentNF += ' NUMERO: '  + SE1->E1_NUM 
		cIdentNF += ' PARCELA: ' + SE1->E1_PARCELA 
		cIdentNF += ' TIPO: '    + SE1->E1_TIPO 
		cIdentNF += ' CLIENTE: ' + SE1->E1_CLIENTE 
		cIdentNF += ' LOJA: '    + SE1->E1_LOJA
		cIdentNF += ' SALDO: '   + Transform(SE1->E1_SALDO, "@E 9,999,999.99")
		cIdentNF += ' RECNO: '   + cValtoChar(aRecNF[1])
		aadd(axLog, '    Título NF  Identificação -> ' + cIdentNF + CRLF)
		
        /*
            MaIntBxCR()
            nCaso       [ 1] -> TIPO DA OPERAÇÃO (3 PARA COMPENSAÇÃO DE MESMA CARTEIRA RA/NCC)
            aSE1        [ 2] 
            aBaixa      [ 3] 
            aNCC_RA     [ 4] 
            aLiquidacao [ 5] 
            aParam      [ 6] 
            bBlock      [ 7] 
            aEstorno    [ 8] 
            aSE1Dados   [ 9] 
            aNewSE1     [10] 
            nSaldoComp  [11] 
            aCpoUser    [12] 
            aNCC_RAvlr  [13] 
            nSomaCheq   [14] 
            nTaxaCM     [15] 
            aTxMoeda    [16] 
            lConsdAbat  [17] 
            lRetLoja    [18] 
            cProcComp   [19]
        */ 
		//           [1]  [2]  [3]   [4]  [5]                              [6]                                  [7][8][9][10]    [11]   [12][13][14][15][16][17]
		If !MaIntBxCR(3, aRecNF, , aRecNCC, , { lContabiliza, lAglutina, lDigita, lDesconto, lJuros, lComisNCC },  ,  ,  ,  , nSaldoComp,   ,   ,   ,   ,   , MV_PAR08)
			aadd(axLog, '    Erro na FUNÇÃO MaIntBxCR')
			lRet := .F.
		Else
			SE1->(dbGoTo((cxAliNF)->RECNF))
			If !Empty(SE1->E1_IDCNAB) .And. !Empty(SE1->E1_PORTADO)
				aItemsFI2 := {}
				Aadd( aItemsFI2, { GetMV('AUTNCCBX01', .F., '02'), ,Transform(nSaldoComp,X3Picture('E1_SALDO')), Transform(0,X3Picture('E1_SALDO')), 'E1_SALDO','N' } )
				aadd(axLog, '    Gravando FI2 para banco... ')
				FinGrvFI2()
			Endif
		EndIf
	EndIf
Return lRet

Static Function SchedDef()
	Local aParam := {}

	aParam := { ;
		"P"                                    ,; // Tipo: R para relatorio P para processo
		""                                     ,; // Pergunte do relatorio, caso nao use passar "PARAMDEF"
		"SE1"                                  ,; // Alias
		""                                     ,; // Array de ordens
		"Compensação Automática de Títulos NCC" ; // Título para relatórios ou rotinas
	}

Return aParam
