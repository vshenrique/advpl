#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.ch"

user function AXCAD()

    Local   cTitle := "AX - Cadastro"
    Local   cVldExc := ".T."
    Local   cVldAlt := ".T."
    PRIVATE cTableAlias := "SB1"

    AxCadastro(cTableAlias, CTitle, cVldExc, cVldAlt)

return nil

user function MBRWSE()

    Local   cAlias    := "SB1"
    PRIVATE aRotina   := {}
    PRIVATE cCadastro := "Cadastro"

    aadd( aRotina, { "Pesquisa"  , "AxPesqui", 0, 1 } )
    aadd( aRotina, { "Visualizar", "AxVisual", 0, 2 } )
    aadd( aRotina, { "Incluir"   , "AxInclui", 0, 3 } )
    aadd( aRotina, { "Alterar"   , "AxAltera", 0, 4 } )
    aadd( aRotina, { "Excluir"   , "AxDeleta", 0, 5 } )

    dbSelectArea(cAlias)
    dbSetOrder(1)
    mBrowse(6, 1, 22, 75, cAlias)

return nil

user function FILBRWSE()

    LOCAL   cAlias    := "SA2"
    LOCAL   aCores    := {}
    LOCAL   cFiltra   := "A2_FILIAL == '" + FWXFilial("SA2") + "'"
    PRIVATE cCadastro := "Cadastro MBROWSE"
    PRIVATE aRotina   := {}
    PRIVATE aIndexSA2 := {}
    PRIVATE bFilBrw   := { || FilBrowse(cAlias, @aIndexSA2, @cFiltra) }

    AADD( aRotina, { "Pesquisa"  , "AxPesqui" , 0, 1 } )
    AADD( aRotina, { "Visualizar", "AxVisual" , 0, 2 } )
    AADD( aRotina, { "Incluir"   , "U_BInclui", 0, 3 } )
    AADD( aRotina, { "Alterar"   , "U_BAltera", 0, 4 } )
    AADD( aRotina, { "Excluir"   , "U_BDeleta", 0, 5 } )
    AADD( aRotina, { "Excluir"   , "U_BLegend", 0, 6 } )

    aCores := {;
        {"A2_TIPO == 'F'", "BR_VERDE"  },;
        {"A2_TIPO == 'J'", "BR_AMARELO"},;
        {"A2_TIPO == 'X'", "BR_LARANJA"},;
        {"A2_TIPO == 'R'", "BR_MARROM" },;
        {"Empty(A2_TIPO)", "BR_PRETO"  }}

    dbSelectArea(CALIAS)
    DBSETORDER(1)

    EVAL(bFilBrw)

    dbGoTop()
	mBrowse(6, 1, 22, 75, cAlias, , , , , , aCores)
	
	EndFilBrw(cAlias,aIndexSA2)

return nil

User Function BINCLUI(cAlias, nReg, nOpc)

    LOCAL nOpcao := 0

    nOpcao := AxInclui(cAlias, nReg, nOpc)

    if (nOpcao == 1)
        MSGINFO("Cadastro realizado com sucesso!")
    else
        MSGALERT("Erro de cadastro!")
    endif

Return NIL

User Function BALTERA(cAlias, nReg, nOpc)

    LOCAL nOpcao := 0

    nOpcao := AxAltera(cAlias, nReg, nOpc)

    if (nOpcao == 1)
        MSGINFO("Cadastro alterado com sucesso!")
    else
        MSGALERT("Erro de alteração!")
    endif

Return NIL

User Function BDELETA(cAlias, nReg, nOpc)

    LOCAL nOpcao := 0

    nOpcao := AxDeleta(cAlias, nReg, nOpc)

    if (nOpcao == 1)
        MSGALERT("Erro na exclusão!")
    else
        MSGINFO("Cadastro excluido com sucesso!")
    endif

Return NIL

user function BLEGEND()

    Local aLegenda := {;
        {"BR_VERDE"  , "Pessoa Física"   },;
        {"BR_AMARELO", "Pessoa Jurídica" },;
        {"BR_LARANJA", "Exportação"      },;
        {"BR_MARROM" , "Fornecedor Rural"},;
        {"BR_PRETO"  , "Não Classificado"}}

    BrwLegenda(cCadastro, "Legenda", aLegenda)

return nil