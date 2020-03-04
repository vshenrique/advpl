#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.ch"

user function essentials()

    Local aArea
    Local cQuery  := ""
    Local cTable  := "SB1"
    Local aInsReg := {}

    // -- Preparação do ambiente e conexão bom BD -- //
    PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "COM" // roda o script sem a necessidade do protheus aberto
    aArea := SB1->(GetArea())
    dbSelectArea(cTable)
    SB1->(dbSetOrder(1)) // indice 1
    SB1->(dbGoTop())
    // -- Preparação do ambiente e conexão bom BD -- //

    // -- Busca usando DBSEEK -- //
    if (SB1->(dbSeek(FWXFilial(cTable) + "2")))
        CONOUT(SB1->B1_DESC) // mostra o resultado do script dentro do console appserver
    endif
    // -- Busca usando DBSEEK -- //

    // -- Busca usando POSICIONE -- //
    CONOUT(Posicione( cTable, ;
        1, ;
        FWXFilial(cTable) + "PROD001", ;
        "B1_DESC" ))
    // -- Busca usando POSICIONE -- //

    // -- Busca usando query montada e alias, sendo o resultado um "objeto" -- //
    cQuery += "SELECT B1_COD, B1_DESC FROM " + RetSQLName(cTable) + " WHERE B1_MSBLQL != '1'"
    TCQuery cQuery new Alias "TEST"
    // -- Busca usando query montada e alias, sendo o resultado um "objeto" -- //

    while (!TEST->(EoF()))
        conout("CODIGO: " + TEST->B1_COD + "DESCRICAO: " + TEST->B1_DESC)
        TEST->(dbSkip())
    end
    TEST->(DBCLOSEAREA())

    // -- RecLock para alteração de dados na tabela -- //
    BEGIN Transaction
        conout("Alterando descricao do PROD001")
        if (SB1->(dbSeek(FWXFilial(cTable) + "PROD001")))
            RecLock(cTable, .F.) // FALSE trava registro para ALTERAÇÃO, TRUE trava para INCLUSÃO
            replace B1_DESC with "PRIMARY DESCRICAO"
            SB1->(MsUnlock())
        endif
    END Transaction

    CONOUT("Descricao alterada: " + ;
        Posicione( cTable, ;
        1, ;
        FWXFilial(cTable) + "PROD001", ;
        "B1_DESC" ))

    PRIVATE lMSErroAuto := .F. // se der erro torna-se TRUE

    aInsReg := {;
        {"B1_COD"    , "PROD003"    , NIL},;
        {"B1_DESC"   , "PRODUTO 003", NIL},;
        {"B1_TIPO"   , "PA"         , NIL},;
        {"B1_UM"     , "UN"         , NIL},;
        {"B1_LOCPAD" , "01"         , NIL},;
        {"B1_PICM"   , 0            , NIL},;
        {"B1_IPI"    , 0            , NIL},;
        {"B1_CONTRAT", "N"          , NIL},;
        {"B1_LOCALIZ", "N"          , NIL};
        }

    BEGIN Transaction
        /*/ Operações MSExecAuto:
        2 -> visualização
        3 -> inclusão
        4 -> alteração
        5 -> exclusão
        /*/
        MSExecAuto({ |x, y| MATA010(x, y)}, aInsReg, 3)
        // IF para teste de erro
        if lMSErroAuto
            conout("Erro!")
            MostraErro()
            DisarmTransaction()
        else
            conout("Registro inserido com sucesso!")
        endif
    END Transaction

    TCQuery cQuery new Alias "TEST"
    while (!TEST->(EoF()))
        conout("CODIGO: " + TEST->B1_COD + "DESCRICAO: " + TEST->B1_DESC)
        TEST->(dbSkip())
    end
    TEST->(DBCLOSEAREA())
    RestArea(aArea)

return