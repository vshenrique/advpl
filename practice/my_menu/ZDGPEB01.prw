#include "protheus.ch"

User function ZDGPEB01()
	
	Local   cAlias    := "SZ1"
    PRIVATE aRotina   := {}
    PRIVATE cCadastro := "Cadastro"

    aadd( aRotina, { "Pesquisa"  , "AxPesqui"   , 0, 1 } )
    aadd( aRotina, { "Visualizar", "U_MYGPEF01(2)", 0, 2 } )
    aadd( aRotina, { "Incluir"   , "U_MYGPEF01(3)", 0, 3 } )
    aadd( aRotina, { "Alterar"   , "U_MYGPEF01(4)", 0, 4 } )
    aadd( aRotina, { "Excluir"   , "U_MYGPEF01(5)", 0, 5 } )

    // dbSelectArea(cAlias)
    // dbSetOrder(1)
    mBrowse(6, 1, 22, 75, cAlias)

RETURN

//TGet():New( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, [ lReadOnly ], , , , , , , , , , , , , , [ cPlaceHold ], ,  )

User function MYGPEF01(nOption)

    Local cTable   := "SZ1"
    Local lRecLock := .F.
    Local lRedOnly := .F.

    DO CASE 

        CASE nOption == 2 .OR. nOption == 5 // Visualização ou Exclusão
            lRedOnly := .T.
            U_MYGPEA01(cTable, lRecLock, lRedOnly, nOption)

        CASE nOption == 3 // Inclusão
            lRecLock := .T.
            U_MYGPEA01(cTable, lRecLock, lRedOnly, nOption)

        CASE nOption == 4 // Alteração
            U_MYGPEA01(cTable, lRecLock, lRedOnly, nOption)

        OTHERWISE
            ALERT("ALGO DE ERRADO NÃO ESTÁ CERTO")        

    ENDCASE

return