#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

user function Maths()

    Local cInput1      := FWInputBox("Primeiro valor", "")
    Local cInput2      := FWInputBox("Segundo valor", "")
    Local nVal1        := val(cInput1)
    Local nVal2        := val(cInput2)

    Sum( nVal1, nVal2 )
    Sub( nVal1, nVal2 )
    Mult( nVal1, nVal2 ) 
    Div( nVal1, nVal2 )
    Rest( nVal1, nVal2 )
    Pow( nVal1, nVal2 )

return

Static Function Sum( nVal1, nVal2 )  
    Local nAnswer := nVal1 + nVal2
    MSGINFO( "Soma: " - STR(nAnswer) )
return

Static Function Sub( nVal1, nVal2 )  
    Local nAnswer := nVal1 - nVal2
    MSGINFO( "Subitração: " - STR(nAnswer) )
return

Static Function Mult( nVal1, nVal2 )  
    Local nAnswer := nVal1 * nVal2
    MSGINFO( "Multiplicação: " - STR(nAnswer) )
return

Static Function Div( nVal1, nVal2 )  
    Local nAnswer := nVal1 / nVal2
    MSGINFO( "Divisão: " - STR(nAnswer) )
return

Static Function Rest( nVal1, nVal2 )  
    Local nAnswer := nVal1 % nVal2
    MSGINFO( "Resto: " - STR(nAnswer) )
return

Static Function Pow( nVal1, nVal2 )  
    Local nAnswer := nVal1 ^ nVal2
    MSGINFO( "Potenciação: " - STR(nAnswer) )
return