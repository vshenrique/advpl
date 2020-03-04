#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

user function Variables()

    local nNumber := 1
    local lLogic := .F.
    local cCarac := "Musk"
    local dDate := date()
    local aArray := { "test", "testing", "tested" }
    local bBlock := { |nValue| MSGALERT( "O numero é: " + cValToChar (nValue + nNumber), "Soma em bloco" ) }

    Alert(nNumber)
    Alert(lLogic)
    Alert(CVALTOCHAR( cCarac ))
    Alert(dDate)
    Alert(aArray[1])
    EVAL( bBlock, 2 )

return