#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

user function Decisions()

    Local cAnswer   := ""
    Local lEndWhile := .F.
    Local cLoopFor  := 0
    Local nTroll    := 0

    While (lEndWhile = .F.)

        // cria um msginfo com a  mensagem escrita e respostas 'Sim' ou 'N�o', retornando TRUE ou FALSE
        // MSGYESNO("Voc� gosta de ADVPL?")

        cAnswer := FWInputBox("Voc� gosta de ADVPL? Responda com 'sim' ou 'nao': ", "")

        if (nTroll >= 3)
            msgalert("Ta de brincadeira?")
        elseif (cAnswer <> "sim" .AND. cAnswer <> "nao" )
            msgalert( "ERROU!" )
            nTroll++
        elseif (cAnswer = "sim")
            msginfo( "Tamo junto!" )
        else
            msginfo( "'Poxa vida', Prof Bugatti. 1965" )
        endif

        lEndWhile := msgyesno("Deseja tentar novamente?")

    End
    
    for cLoopFor := 5 to 0 step -1

        cAnswer := val(FWInputBox("Escolha um numero de 1 a 5: ", ""))

        do case

            case cAnswer == 1
                msginfo("N�o tenha medo da mudan�a. Coisas boas se v�o para que melhores possam vir.")

            case cAnswer == 2
                msginfo("Vencedor n�o � aquele que sempre vence, mas sim aquele que nunca para de lutar.")

            case cAnswer == 3
                msginfo("�s vezes voc� tem que levantar sozinho e seguir em frente.")

            case cAnswer == 4
                msginfo("At� o maior dos pr�dios come�a no ch�o.")

            case cAnswer == 5
                msginfo("Jamais desista de ser feliz!")

            otherwise
                msgalert("Por favor digite apenas um NUMERO de 1 a 5!")

        endcase

    next

return