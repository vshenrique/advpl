#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

#DEFINE CRLF Chr(13)+Chr(10)

user function arrays ()

    Local aTest    := { "boring" }
    Local lLWhile  := .F.
    Local nLFor    := 0
    Local nUserNum := 0
    Local cMsg     := ""
    Local bDouble  := { |nNum| nNum * 2 }

    while (lLWhile == .F.)
        nUserNum := fwinputbox("Digite um numero cujo dobro sera adicionado ao array: ", "")
        if (isnumeric(nUserNum))
            aadd(aTest, eval(bDouble, val(nUserNum)))
            lLWhile := .T.
        endif
    end

    asize(aTest, len(aTest) + 1)
    ains(aTest, 1)
    aTest[1] := "Hello, uordi"

    for nLFor := 1 to len(aTest)
        alert(aTest[nLfor])
    next

    aDele := aclone(aTest)

    adel(aDele, 1)
    asize(aDele, len(aDele) - 1)

    cMsg := ""
    for nLFor := 1 to len(aDele)
        cMsg += "Posição [" + cvaltochar(nlfor) + "] conteúdo: " + cvaltochar(aDele[nlfor]) + CRLF
    next

    msginfo( cMsg, "Array Adele")

return