#include "protheus.ch"

User Function ZDGPEB01()

    PRIVATE aRotina   := {}
    PRIVATE cCadastro := "Cadastro Personalizado de Pessoas"

    aadd( aRotina, { "Pesquisa"  , "AxPesqui"   , 0, 1 } )
    aadd( aRotina, { "Visualizar", "U_MYGPEF01(2)", 0, 2 } )
    aadd( aRotina, { "Incluir"   , "U_MYGPEF01(3)", 0, 3 } )
    aadd( aRotina, { "Alterar"   , "U_MYGPEF01(4)", 0, 4 } )
    aadd( aRotina, { "Excluir"   , "U_MYGPEF01(5)", 0, 5 } )

    mBrowse(6, 1, 22, 75, "SZ1")

Return

User Function MYGPEF01(nOption)

    Local cTable   := "SZ1"
    Local lRecLock := .F.
    Local lRedOnly := .F.

    Do Case 

        Case nOption == 2 .OR. nOption == 5 // Visualização ou Exclusão
            lRedOnly := .T.
            U_MYGPEA01(cTable, lRecLock, lRedOnly, nOption)

        Case nOption == 3 // Inclusão
            lRecLock := .T.
            U_MYGPEA01(cTable, lRecLock, lRedOnly, nOption)

        Case nOption == 4 // Alteração
            U_MYGPEA01(cTable, lRecLock, lRedOnly, nOption)

        Otherwise
            ALERT("Ocorreu um erro interno na função, contate o suporte!")

    EndCase

Return