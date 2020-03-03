#INCLUDE "protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.ch"

USER Function DatAlter(lRecLock, cTable, cName, cXcpf, dBirth, nSex, cCon, cEmail, cCep, cAdr, cAdrNum, cNbhd, cCity, nSt, lAtv, cObs)

    BEGIN Transaction
        RecLock(cTable, lRecLock) // FALSE trava registro para ALTERAÇÃO, TRUE trava para INCLUSÃO

        SZ1->Z1_FILIAL := XFilial(cTable)
        if (lRecLock == .T.)
            SZ1->Z1_COD    := GetSxeNum(cTable, "Z1_COD")
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

User Function DelReg(cTable, lReclock)

    if (MSGNOYES( "DESEJA REALMENTE EXCLUIR ESSE REGISTRO?", "EXCLUSÃO DE REGISTRO" ))
        RecLock(cTable, lReclock)
        DbDelete()
        MsUnlock()
    endif

return