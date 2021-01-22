#Include "Protheus.ch"
#Include "BEL.CH"
#include 'tbiconn.ch'

User Function AUTEMPTR()
    Private cxAlias   := GetNextAlias()
    Private aBrowse   := {}
    Private aFields   := {}
    Private cMarca    := GetMark()
    Private nValor    := 0
    Private oDlg
    Private oMarked   := LoadBitmap( GetResources(), "LBOK" )
    Private oNoMarked := LoadBitmap( GetResources(), "LBNO" )
    Private cFornec   := "011011"
    Private cLoja     := "02"
    Private cBancoZD  := ""
    Private cAgenZD   := ""
    Private cContaZD  := ""
    Private dDataIni  := ""
    Private dDataFim  := ""

    If !Pergunte("AUTEMPTR", .T.)
        Return .F.
    EndIf

    cBancoZD  := MV_PAR03
    cAgenZD   := MV_PAR04
    cContaZD  := MV_PAR05
    dDataIni  := MV_PAR01
    dDataFim  := MV_PAR02

    BEGINSQL Alias cxAlias
        SELECT
            E2_FILORIG
            ,E2_PREFIXO
            ,E2_NUM
            ,E2_PARCELA
            ,E2_TIPO
            ,E2_FORNECE
            ,E2_LOJA
            ,E2_SALDO
            ,E1_FILORIG
            ,E1_PREFIXO
            ,E1_NUM
            ,E1_PARCELA
            ,E1_TIPO
            ,E1_CLIENTE
            ,E1_LOJA
            ,E1_SALDO
            ,SE1.R_E_C_N_O_ AS RECNOE1
        FROM SE2010 AS SE2
            INNER JOIN SE1070 AS SE1
                ON  E1_FILIAL  = E2_FILIAL
                AND E1_PREFIXO = E2_PREFIXO
                AND E1_NUM     = E2_NUM
                AND E1_SALDO   = E2_SALDO
                AND E1_SALDO > 0
        WHERE
                E2_FILIAL          = '  '
            AND E2_FORNECE         = %exp:cFornec%
            AND E2_LOJA            = %exp:cLoja%
            AND E2_EMISSAO  BETWEEN  %exp:MV_PAR01% AND %exp:MV_PAR02%
            AND E2_MOEDA           =  1
            AND E2_FATURA          = ''
            AND E2_NUMBOR          = ''
            AND E2_TIPO       NOT IN ('PA ','PR ','AB-','CF-','CS-','FC-','FE-','FU-','GN-','I2-','IB-','IM-','IN-','IR-','IS-','IV-','PI-','FC-','FE-')
            AND E2_SALDO           > 0
            AND E2_ORIGEM     NOT IN ('SIGAEFF ', 'FINA667 ', 'FINA677 ', 'FINI055 ')
            AND E2_IDDARF          = ''
            AND (
                    E2_DATALIB <> ' '
                OR (E2_SALDO+E2_SDACRES-E2_SDDECRE<=0.00)
            )
            AND E2_DATALIB        <> ''
            AND E2_DATALIB        <= %exp:MV_PAR02%
            AND E2_X_SACAD        <> 'S'
            AND SE2.D_E_L_E_T_     = ''
        ORDER BY E1_EMISSAO, E1_PREFIXO, E1_NUM
    ENDSQL

    DEFINE DIALOG oDlg TITLE "Títulos para Baixa" FROM 180,180 TO 755,1360 PIXEL
  
        If (cxAlias)->( EOF() )
            MsgInfo("AUTEMPTR", "Não há títulos para pagar!")
            Return
        Else
            While !(cxAlias)->( EOF() )
                // Vetor com elementos do Browse
                aadd( aBrowse, {.T.                  ,;  // [01]
                                (cxAlias)->E2_FILORIG,;  // [02]
                                (cxAlias)->E2_PREFIXO,;  // [03]
                                (cxAlias)->E2_NUM    ,;  // [04]
                                (cxAlias)->E2_PARCELA,;  // [05]
                                (cxAlias)->E2_TIPO   ,;  // [06]
                                (cxAlias)->E2_FORNECE,;  // [07]
                                (cxAlias)->E2_LOJA   ,;  // [08]
                                (cxAlias)->E2_SALDO  ,;  // [09]
                                (cxAlias)->E1_FILORIG,;  // [10]
                                (cxAlias)->E1_PREFIXO,;  // [11]
                                (cxAlias)->E1_NUM    ,;  // [12]
                                (cxAlias)->E1_PARCELA,;  // [13]
                                (cxAlias)->E1_TIPO   ,;  // [14]
                                (cxAlias)->E1_CLIENTE,;  // [15]
                                (cxAlias)->E1_LOJA   ,;  // [16]
                                (cxAlias)->E1_SALDO  ,;  // [17]
                                (cxAlias)->RECNOE1    }) // [18]

                (cxAlias)->(dbSkip())
            End
        EndIf

        DbSelectArea(cxAlias)
        dbGotop()

        aFields := {''               ,; // [01]
                    'Fil. Origem SE2',; // [02]
                    'Prefixo SE2'    ,; // [03]
                    'Numero SE2'     ,; // [04]
                    'Parcela SE2'    ,; // [05]
                    'Tipo SE2'       ,; // [06]
                    'Fornecedor SE2' ,; // [07]
                    'Loja SE2'       ,; // [08]
                    'Saldo SE2'      ,; // [09]
                    'Fil. Origem SE1',; // [10]
                    'Prefixo SE1'    ,; // [11]
                    'Numero SE1'     ,; // [12]
                    'Parcela SE1'    ,; // [13]
                    'Tipo SE1'       ,; // [14]
                    'Fornecedor SE1' ,; // [15]
                    'Loja SE1'       ,; // [16]
                    'Saldo SE1'       } // [17]

        // Cria Browse
        oBrowse := TCBrowse():New(  01, 01, 590, 260, , aClone(aFields), { 20, 50, 50, 50 }, oDlg, , , , , {||}, , , , , , , .F., , .T., , .F., , , )

        // Seta vetor para a browse
        oBrowse:SetArray(aBrowse)

        oBrowse:AddColumn( TcColumn():New( ''               , { || IIF(aBrowse[oBrowse:nAt, 01], oMarked, oNoMarked) }, "@!"                  , , , "CENTER", 015, .T., .F., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[02], { ||     aBrowse[oBrowse:nAt, 02]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[03], { ||     aBrowse[oBrowse:nAt, 03]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[04], { ||     aBrowse[oBrowse:nAt, 04]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[05], { ||     aBrowse[oBrowse:nAt, 05]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[06], { ||     aBrowse[oBrowse:nAt, 06]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[07], { ||     aBrowse[oBrowse:nAt, 07]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[08], { ||     aBrowse[oBrowse:nAt, 08]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[09], { ||     aBrowse[oBrowse:nAt, 09]                      }, '@E 99,999,999,999.99', , , "RIGHT" ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[10], { ||     aBrowse[oBrowse:nAt, 10]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[11], { ||     aBrowse[oBrowse:nAt, 11]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[12], { ||     aBrowse[oBrowse:nAt, 12]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[13], { ||     aBrowse[oBrowse:nAt, 13]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[14], { ||     aBrowse[oBrowse:nAt, 14]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[15], { ||     aBrowse[oBrowse:nAt, 15]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[16], { ||     aBrowse[oBrowse:nAt, 16]                      },                       , , , "LEFT"  ,    , .F., .T., , , , .F., ) )
        oBrowse:AddColumn( TCColumn():New( aFields[17], { ||     aBrowse[oBrowse:nAt, 17]                      }, '@E 99,999,999,999.99', , , "RIGHT" ,    , .F., .T., , , , .F., ) )

        // Evento de duplo click na celula
        oBrowse:bLDblClick := { || MarcaBrw() }

        // Cria Botoes com metodos básicos
        TButton():New( 270, 002, "Voltar ao topo" , oDlg, { || oBrowse:GoTop()   ,oBrowse:setFocus()    }, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 270, 052, "Ir para o Fim"  , oDlg, { || oBrowse:GoBottom(),oBrowse:setFocus()    }, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 270, 102, "Total de Linhas", oDlg, { || MsgInfo(oBrowse:nLen, 'Total de linhas') }, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 270, 175, "Cancelar"       , oDlg, { || oDlg:End()                               }, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 270, 225, "Marcar Todos"   , oDlg, { || MarcaTudo()                              }, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 270, 275, "Desmarcar Todos", oDlg, { || DesmarcarTodos()                         }, 50, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
        TButton():New( 270, 335, "Criar Fatura"   , oDlg, { || FatTitulos()                             }, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )

    ACTIVATE DIALOG oDlg CENTERED
Return

Static Function MarcaBrw()
	If aBrowse[oBrowse:nAt,01]
        aBrowse[oBrowse:nAt,01] := .F.
	Else
		aBrowse[oBrowse:nAt,01] := .T.
	Endif

	oBrowse:Refresh()
	oDlg:Refresh()
Return

Static Function MarcaTudo()
    Local nx := 0

    For nx := 1 to Len(aBrowse)
        If !aBrowse[nx, 01]
            aBrowse[nx, 01] := .T.
        EndIf
    Next

    oBrowse:Refresh()
	oDlg:Refresh()
Return

Static Function DesmarcarTodos()
    Local nx := 0

    For nx := 1 to Len(aBrowse)
        If aBrowse[nx, 01]
            aBrowse[nx, 01] := .F.
        EndIf
    Next

    oBrowse:Refresh()
	oDlg:Refresh()
Return

Static Function FatTitulos()
    Private lRet := .T.

    Processa({|| ProcSE1() }, "Processando Títulos")
Return lRet

Static Function ProcSE1()
    Local aTam     := {}
	Local aBxFat   := Array(8)
	Local aFatura  := {}
    Local aRecnos  := {}
    Local aTitulos := {}
    Local cFatura  := ""
    Local lRet     := .T.
    Local nx       := 0

    Private cNomeCli
    Private cDescHist
	Private lMsErroAuto := .F.

    For nx := 1 to Len(aBrowse)
        If aBrowse[nx, 01]
            aadd(aTitulos, { aBrowse[nx, 03], aBrowse[nx, 04], aBrowse[nx, 05], aBrowse[nx, 06], .T. })
            aadd(aRecnos , aBrowse[nx, 18])
            nValor += aBrowse[nx, 09]
        Endif

        If nx == Len(aFields)
            Exit
        EndIf
    Next

    aTam    := TamSx3("E2_NUM")
    cFatura	:= Soma1(GetMv("MV_NUMFATP"), aTam[1])
    cFatura	:= Pad(cFatura,aTam[1])

    Pergunte("AFI290", .F.)
    MV_PAR01 := 2
    MV_PAR02 := 1
    MV_PAR03 := 1
    MV_PAR04 := 1
    MV_PAR05 := 1
    MV_PAR06 := 1

	aFatura := {"FAT"         ,; // [01] - Prefixo
                "FT "         ,; // [02] - Tipo
                cFatura       ,; // [03] - Numero da Fatura (se o numero estiver em branco obtem pelo FINA290)
                "23006"       ,; // [04] - Natureza "23006"
                dDataIni      ,; // [05] - Data de
                dDataFim      ,; // [06] - Data Ate
                cFornec       ,; // [07] - Fornecedor
                cLoja         ,; // [08] - Loja
                cFornec       ,; // [09] - Fornecedor para geracao
                cLoja         ,; // [10] - Loja do fornecedor para geracao
                "006"         ,; // [11] - Condicao de pagto
                              ,; // [12] - Moeda
                aTitulos       } // [13] - ARRAY com os titulos da fatura, [13,1] - Prefixo, [13,2] - Numero, [13,3] - Parcela, [13,4] - Tipo, [13,5] - Título localizado na geracao de fatura (lógico). Iniciar com falso.} // [13] - ARRAY com os titulos da fatura, [13,1] - Prefixo, [13,2] - Numero, [13,3] - Parcela, [13,4] - Tipo, [13,5] - Título localizado na geracao de fatura (lógico). Iniciar com falso.

	MsExecAuto( { |x,y| FINA290(x, y) }, 3, aFatura )

	If lMsErroAuto
		lRet := .F.
		MostraErro()
	Else
        SE2->( dbSetOrder(1) )
        If SE2->( dbSeek(xFilial("SE2") + "FAT" + AllTrim(cFatura) ) ) //.AND. Empty(SE2->E2_DATALIB)
            MsgInfo("Fatura Gerada", cFatura)

            If Empty( SE2->E2_DATALIB )
                RecLock("SE2",.F.)
                SE2->E2_EMIS1   := dDataBase
                SE2->E2_DATALIB := dDataBase
                SE2->E2_USUALIB := cUserName

                If SE2->( FieldPos('E2_X_USULB')) > 0
                    SE2->E2_X_USULB := u_UserE2LIB()
                Endif

                SE2->E2_STATLIB := "03"
                SE2->E2_CODAPRO := Fa006User( __cUserId, .F., 2 )
                SE2->( MsUnlock() )
            EndIf
        Else
            MsgAlert("Falha na criação da fatura!")
            Return .F.
        EndIf

        aBxFat := { ;
            { "E2_PREFIXO", SE2->E2_PREFIXO   , Nil }, ;
            { "E2_NUM"    , SE2->E2_NUM       , Nil }, ;
            { "E2_PARCELA", SE2->E2_PARCELA   , Nil }, ;
            { "E2_TIPO"   , SE2->E2_TIPO      , Nil }, ;
            { "AUTMOTBX"  , "NOR"             , Nil }, ;
            { "AUTDTBAIXA", dDatabase         , Nil }, ;
            { "AUTHIST"   , "Bx Auto AUTEMPTR - Fat " + cFatura, Nil }, ;
            { "AUTVLRPG"  , SE2->E2_SALDO     , Nil }  ;
        }
        
        MSExecAuto ( { |x| FINA080(x) }, aBxFat )

        If lMsErroAuto
            lRet  := .F.
            MostraErro()
            MsgAlert("AUTEMPTR", "Erro ao baixar fatura " + cFatura)
        Else
            MsgInfo("Fatura Baixada", cFatura)
            lRet := StartJob( "U_BXEMPRE2", GetEnvServer(), .T., aRecnos, cFatura )

            If lRet
                MsgInfo("Títulos da fatura ZD " + cFatura + "baixados com sucesso!", "AUTEMPTR")
            Else
                MsgAlert("Erro na baixa de títulos a receber Bel Logística, favor consultar o log!", "AUTEMPTR")
            EndIf
        EndIf
	EndIf

    IncProc()
Return lRet

User Function BXEMPRE2( aRecnos, cFatura )
    Local lRet   := .T.
    Local aBxSE1 := {}
    Local nx     := 0

    Private lMsErroAuto := .F.

    RpcSetType(3)
    PREPARE ENVIRONMENT EMPRESA "07" FILIAL "01" MODULO "FIN"
        For nx := 1 to Len(aRecnos)
            SE1->( dbGoTo( aRecnos[nx] ) )

            aBxSE1 := {;
                { "E1_PREFIXO"  , SE1->E1_PREFIXO      , Nil },;
                { "E1_NUM"      , SE1->E1_NUM          , Nil },;
                { "E1_PARCELA"  , SE1->E1_PARCELA      , Nil },;
                { "E1_TIPO"     , SE1->E1_TIPO         , Nil },;
                { "AUTMOTBX"    , "NOR"                , Nil },;
                { "AUTBANCO"    , "237"                , Nil },;
                { "AUTAGENCIA"  , "34932"              , Nil },;
                { "AUTCONTA"    , PadR( "130-9", TamSX3("E1_CONTA")[1] ), Nil },;
                { "AUTDTBAIXA"  , dDataBase            , Nil },;
                { "AUTHIST"     , "Bx Auto AUTEMPTR - Fat " + cFatura, Nil },;
                { "AUTVALREC"   , SE1->E1_SALDO        , Nil };
            }

            lMsErroAuto := .F.
            MSExecAuto( { |x| Fina070( x ) }, aBxSE1 )
            If lMsErroAuto
                lRet := .F.
                MostraErro('\log\AUTEMPTR\', 'Fat_' + cFatura + '.log')
            EndIf
        Next
    RpcClearEnv()
Return lRet
