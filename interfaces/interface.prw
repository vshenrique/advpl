#include "protheus.ch"

User Function APPINT01()

    Local oDlg
    Local oBtn1, oSay1

    DEFINE DIALOG oDlg TITLE "Rick and Morty" FROM 0,0 TO 240,480 COLOR CLR_BLACK,CLR_WHITE PIXEL

    @ 25,05 SAY oSay1 PROMPT "Apenas um show" SIZE 60,12 OF oDlg PIXEL

    @ 50,05 BUTTON oBtn1 PROMPT "Adventure Time!" ACTION ( oDlg:End() ) SIZE 40, 013 OF oDlg PIXEL

    ACTIVATE DIALOG oDlg CENTER

Return

User Function APPINT02()

    Local oDlg
    Local oBtn1, oSay1

    oDlg  := TDialog():New( 0, 0, 150, 300, "Exemplo" ,,,,, CLR_BLACK,CLR_WHITE ,,, .T. )
    oSay1 := TSay   ():New( 25, 05, {|| "Apenas uma mensagem"} ,oDlg,,,,,,.T.,,, 60, 12 )
    oBtn1 := TButton():New( 50, 05, "Sair", oDlg,{|| oDlg:End() }, 40, 013,,,,.T. )

    oDlg:Activate( , , , .T. )

Return