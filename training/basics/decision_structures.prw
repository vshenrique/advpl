#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

user function Decisions()

    Local cAnswer   := ""
    Local lEndWhile := .F.
    Local cLoopFor  := 0
    Local nTroll    := 0

    While (lEndWhile = .F.)

        // cria um msginfo com a  mensagem escrita e respostas 'Sim' ou 'Não', retornando TRUE ou FALSE
        // MSGYESNO("Você gosta de ADVPL?")

        cAnswer := FWInputBox("Você gosta de ADVPL? Responda com 'sim' ou 'nao': ", "")

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
                msginfo("Não tenha medo da mudança. Coisas boas se vão para que melhores possam vir.")

            case cAnswer == 2
                msginfo("Vencedor não é aquele que sempre vence, mas sim aquele que nunca para de lutar.")

            case cAnswer == 3
                msginfo("Às vezes você tem que levantar sozinho e seguir em frente.")

            case cAnswer == 4
                msginfo("Até o maior dos prédios começa no chão.")

            case cAnswer == 5
                msginfo("Jamais desista de ser feliz!")

            otherwise
                msgalert("Por favor digite apenas um NUMERO de 1 a 5!")

        endcase

    next

return