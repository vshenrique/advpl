#include "TopConn.ch"

/** Função de inserir ou alterar, sendo alterada pelo valor da variável
    lRecLock, podendo ser TRUE para inserir e FALSE para alterar. **/
USER Function DatAlter(lRecLock, cTable, cName, cXcpf, dBirth, nSex, cCon, cEmail, cCep, cAdr, cAdrNum, cNbhd, cCity, nSt, lAtv, cObs)

    BEGIN Transaction
        RecLock(cTable, lRecLock)

        SZ1->Z1_FILIAL := XFilial(cTable)
        if (lRecLock == .T.)                              // O if trata se o código já existe no banco e se existir apenas não altera o valor.
            SZ1->Z1_COD    := GetSxeNum(cTable, "Z1_COD") // GetSxeNum automáticamente pega o ultimo número do campo Z1_COD e soma um
        endif
        SZ1->Z1_NAME   := cName
        SZ1->Z1_CPF    := cXcpf
        SZ1->Z1_BIRTH  := dBirth
        SZ1->Z1_SEX    := nSex
        SZ1->Z1_CON    := cCon
        SZ1->Z1_EMAIL  := cEmail
        SZ1->Z1_CEP    := cCep
        SZ1->Z1_ADR    := cAdr
        SZ1->Z1_ADRNUM := cAdrNum
        SZ1->Z1_NBHD   := cNbhd
        SZ1->Z1_CITY   := cCity
        SZ1->Z1_STATE  := nSt
        SZ1->Z1_ACTIVE := lAtv
        SZ1->Z1_OBS    := cObs
        ConfirmSx8() 
        
        MsUnlock()
    END Transaction

Return

/** Função básica para deletar o registro selecionado. **/
User Function DelReg(cTable, lReclock)

    if (MSGNOYES( "DESEJA REALMENTE EXCLUIR ESSE REGISTRO?", "EXCLUSÃO DE REGISTRO" ))
        RecLock(cTable, lReclock)
        DbDelete()
        MsUnlock()
    endif

return