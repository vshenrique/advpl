#include "protheus.ch"

User Function TstNome()

    Local cNome

    cNome := GetNome("Insira seu nome",50,"@!")

    If empty(cNome)
        MsgStop("Nenhum nome foi digitado","Nome Digitado")
    Else
        MsgInfo("["+cNome+"]","Nome Digitado")
    Endif

Return

STATIC Function GetNome(cTitulo,nTam,cPicture)

    Local oDlg
    Local oGet
    Local oBtn1
    Local oBtn2
    Local cGetVar := space(nTam)
    Local lOk     := .F.

    DEFINE DIALOG oDlg TITLE (cTitulo) ;
        FROM 0,0 TO 100,500            ;
        COLOR CLR_BLACK, CLR_HBLUE PIXEL

    @ 05,05 GET oGet       ;
        VAR cGetVar        ;
        PICTURE (cPicture) ;
        SIZE (nTam*4),12 OF oDlg PIXEL

    @ 25,05  BUTTON oBtn1 PROMPT "Confirmar" ;
        SIZE 40,15                           ;
        ACTION (lOk := .T. , oDlg:End()) OF oDlg PIXEL

    @ 25,50  BUTTON oBtn2 PROMPT "Voltar" ;
        SIZE 40,15                        ;
        ACTION (oDlg:End()) OF oDlg PIXEL

    ACTIVATE DIALOG oDlg CENTER

    If !lOk
        cGetVar := space(nTam)
    Endif

Return cGetVar