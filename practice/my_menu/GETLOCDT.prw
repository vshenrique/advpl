#include 'protheus.ch'
#INCLUDE "APWEBSRV.CH"

/** ----------------------------------------------------------------

Fonte original de Jerfferson Silva, em:
    https://github.com/jerfweb/buscacep/blob/master/fBuscaCep.prw

-----------------------------------------------------------------**/

//-- Location Data -- //
User Function GETLOCDT(cCEP)

    Local aHead 	 := {"Content-Type: application/json"}
    Local nTimeOut	 := 200
    Local aLocData	 := {}
    Local cWSReturn	 := ""
    Local cGetHeader := ""
    Local oJson

    PRIVATE cUrl     := "viacep.com.br/ws/" + cCEP + "/json/"

    if (ValidLoc(cCep, cUrl))
        cWSReturn := HttpGet(cUrl,, nTimeOut, aHead, @cGetHeader)
        if !FWJsonDeserialize(cWSReturn, @oJson)
            return .F.
        elseif AttIsMemberOf(oJson,"ERRO")
            return .F.
        else
            aadd(aLocData, DecodeUTF8(oJson:logradouro))
            aadd(aLocData, DecodeUTF8(oJson:bairro))
            aadd(aLocData, DecodeUTF8(oJson:localidade))
            aadd(aLocData, DecodeUTF8(oJson:uf))
        endif
    endif
Return aLocData

//-- Validate Location --//
Static Function ValidLoc(cCep,cUrl)
    Local lRet := .F.
    if (Empty(Alltrim(cCep))) // Validar se o conteudo passado está vazio.
        alert("Favor informar o CEP.")
        Return (lRet)
    elseif (Len(Alltrim(cCep)) < 8) // Validar se o CEP informado tem menos de 8 digitos.
        alert("O CEP informado não contem a quantidade de dígito correta, favor informe um CEP válido.")
        Return (lRet)
    elseif At("-",cCep,) > 0 //Validar se o CEP está separado por "-".
        if Len(StrTran(AllTrim(cCep),"-")) == 8 //Valida se o CEP tratado tem 8 digitos.
            cUrl += StrTran(AllTrim(cCep),"-")+"/json/"
            lRet := .T.
        else
            alert("O CEP informado não contem a quantidade de dígito correta, favor informe um CEP válido.")
            Return (lRet)
        endif
    else
        lRet := .T.
    endif
Return lRet