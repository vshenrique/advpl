#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

user function RelAssign()

    Local nVal1     := FWInputBox("Primeiro valor", "")
    Local nVal2     := FWInputBox("Segundo valor", "")
    Local cSumAsgn  := ""
    Local cSubAsgn  := ""
    Local cMultAsgn := ""
    Local cDivAsgn  := ""
    Local cRestAsgn := ""
    Local nSum  := val(nVal1) + val(nVal2)
    Local nSub  := val(nVal1) - val(nVal2)
    Local nMult := val(nVal1) * val(nVal2)
    Local nDiv  := val(nVal1) / val(nVal2)
    Local nRest := val(nVal1) % val(nVal2)


    do case

        //MAIOR
        case nVal1 > nVal2
            MSGINFO("WHAT")
        
        // MENOR
        case nVal1 < nVal2
            MSGINFO("what")
        
        // EXATAMENTE IGUAL
        case nVal1 == nVal2
            MSGINFO("WHAT WHAT")

        // IGUAL MAS PODE SER TIPO DIFERENTE
        case nVal1 = nVal2
            MSGINFO("what WHAT") 

        // MAIOR OU IGUAL
        case nVal1 >= nVal2
            MSGINFO("WHATWAT")

        // MENOR OU IGUAL
        case nVal1 <= nVal2
            MSGINFO("watWHAT")  

    endCase

    cSumAsgn  := "+= soma o valor da direita na variavel da esquerda: " + str(nSum)
    cSubAsgn  := "-= subtrai o valor da direita da variavel da esquerda: " + str(nSub)
    cMultAsgn := "*= multiplica o valor da direita pela variavel da esquerda: " + str(nMult)
    cDivAsgn  := "/= divide o valor da direita pela variavel da esquerda: " + str(nDiv)
    cRestAsgn := "%= retorna o resto da divisão do valor da direita pela variavel da esquerda: " + str(nRest)

    MSGINFO( cSumAsgn  + CRLF + ;
             cSubAsgn  + CRLF + ;
             cMultAsgn + CRLF + ;
             cDivAsgn  + CRLF + ;
             cRestAsgn + CRLF )

return