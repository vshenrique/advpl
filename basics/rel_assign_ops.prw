#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

#DEFINE CRLF Chr(13)+Chr(10)

user function RelAssign()

    Local nVal1     := FWInputBox("Primeiro valor", "")
    Local nVal2     := FWInputBox("Segundo valor", "")
    Local cMsg      := ""
    Local nSum      := val(nVal1) + val(nVal2)
    Local nSub      := val(nVal1) - val(nVal2)
    Local nMult     := val(nVal1) * val(nVal2)
    Local nDiv      := val(nVal1) / val(nVal2)
    Local nRest     := val(nVal1) % val(nVal2)


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

    cMsg := "+= soma o valor da direita na variavel da esquerda: " + str(nSum) + CRLF
    cMsg += "-= subtrai o valor da direita da variavel da esquerda: " + str(nSub) + CRLF
    cMsg += "*= multiplica o valor da direita pela variavel da esquerda: " + str(nMult) + CRLF
    cMsg += "/= divide o valor da direita pela variavel da esquerda: " + str(nDiv) + CRLF
    cMsg += "%= retorna o resto da divisão do valor da direita pela variavel da esquerda: " + str(nRest)

    MSGINFO(cMsg, "Loucura")

return