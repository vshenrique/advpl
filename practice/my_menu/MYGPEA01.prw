#INCLUDE "protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

user function MYGPEA01(cTable, lRecLock, lRedOnly, nOption)

    Local lRecAct

    Local oStLabel     := Space(1)
    Local oAdrLabel    := Space(1)
    Local oAtvLabel    := Space(1)
    Local oCepLabel    := Space(1)
    Local oConLabel    := Space(1)
    Local oCPFLabel    := Space(1)
    Local oObsLabel    := Space(1)
    Local oSexLabel    := Space(1)
    Local oCityLabel   := Space(1)
    Local oNameLabel   := Space(1)
    Local oNbhdLabel   := Space(1)
    Local oAdrNBrLabel := Space(1)
    Local oBirthLabel  := Space(1)
    Local oEmailLabel  := Space(1)
 
    Local bCpf         := {|u| If(PCount()>0,cXcpf   :=u,cXcpf  )}
    Local bName        := {|u| If(PCount()>0,cName   :=u,cName  )}
    Local bBirth       := {|u| If(PCount()>0,dBirth  :=u,dBirth )}
    Local bBtSex       := {|u| If(PCount()>0,nSex    :=u,nSex   )}
    Local bCon         := {|u| If(PCount()>0,cCon    :=u,cCon   )}
    Local bEmail       := {|u| If(PCount()>0,cEmail  :=u,cEmail )}
    Local bCep         := {|u| If(PCount()>0,cCep    :=u,cCep   )}
    Local bAdr         := {|u| If(PCount()>0,cAdr    :=u,cAdr   )}
    Local bAdrNbr      := {|u| if(PCount()>0,cAdrNbr :=u,cAdrNbr)}
    Local bNbhd        := {|u| If(PCount()>0,cNbhd   :=u,cNbhd  )}
    Local bCity        := {|u| If(PCount()>0,cCity   :=u,cCity  )}
    Local bBtSt        := {|u| If(PCount()>0,nSt     :=u,nSt    )}
    Local bObs         := {|u| If(PCount()>0,cObs    :=u,cObs   )}
    Local bLocDat      := {| | checkCep(cCep                    )}
    Local bGetCpf      := {| | checkCpf(cTable, cXcpf, @lRecAct )}
    Local bAtv         := {| | lAtv                              }
    Local bSetAtv      := {| | lAtv:=!lAtv                       }
 
    Local aSexes       := {"Indefinido", "Feminino", "Masculino"}
    Local aStates      := {;
        "AC", ; 
        "AL", ; 
        "AP", ; 
        "AM", ; 
        "BA", ; 
        "CE", ; 
        "DF", ; 
        "ES", ; 
        "GO", ; 
        "MA", ; 
        "MT", ; 
        "MS", ; 
        "MG", ; 
        "PA", ; 
        "PB", ; 
        "PR", ; 
        "PE", ; 
        "PI", ; 
        "RJ", ; 
        "RN", ; 
        "RS", ; 
        "RO", ; 
        "RR", ; 
        "SC", ; 
        "SP", ; 
        "SE", ; 
        "TO"} 
 
    PRIVATE cAdr       := Space(100)
    PRIVATE cCep       := Space(8)
    PRIVATE cCon       := Space(15)
    PRIVATE cObs       := Space(100)
    PRIVATE cCity      := Space(50)
    PRIVATE cXcpf      := Space(11)
    PRIVATE cName      := Space(50)
    PRIVATE cNbhd      := Space(50)
    PRIVATE dBirth     := STOD("")
    PRIVATE cEmail     := Space(100)
    PRIVATE cAdrNbr    := Space(5)
    PRIVATE lAtv       := .F.
    PRIVATE nSt
    PRIVATE nSex

    lRecAct := lRecLock

    if (nOption != 3) // Popula o form caso não seja uma inclusão
        GetZ1Dat()
    endif

    oNewEmployee := MSDialog():New( 090,218,548,632,"Cadastro de Funcionário",,,.F.,,,,,,.T.,,,.T. )

    oCPFLabel    := TSay():New( 012,012,{||"CPF:"               },oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,012,008)
    oNameLabel   := TSay():New( 025,012,{||"Nome:"              },oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
    oBirthLabel  := TSay():New( 037,012,{||"Data de Nascimento:"},oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
    oSexLabel    := TSay():New( 050,012,{||"Sexo:"              },oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
    oConLabel    := TSay():New( 062,012,{||"Contato:"           },oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
    oEmailLabel  := TSay():New( 075,012,{||"E-mail:"            },oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
    oCepLabel    := TSay():New( 087,012,{||"CEP:"               },oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
    oAdrLabel    := TSay():New( 100,012,{||"Endereço:"          },oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
    oAdrNbrLabel := TSay():New( 112,012,{||"Número:"            },oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
    oNbhdLabel   := TSay():New( 125,012,{||"Bairro:"            },oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oCityLabel   := TSay():New( 137,012,{||"Cidade:"            },oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oStLabel     := TSay():New( 150,012,{||"Estado:"            },oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oAtvLabel    := TSay():New( 162,012,{||"Ativo:"             },oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oObsLabel    := TSay():New( 175,012,{||"Observações:"       },oNewEmployee,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

    oCpf         := TGet():New(     012,067,bCpf   ,oNewEmployee,075,008,"@R 999.999.999-99",bGetCpf,  CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,lRedOnly,.F.,"","cXcpf" ,,)
    oName        := TGet():New(     025,067,bName  ,oNewEmployee,125,008,"@!"               ,       ,  CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,lRedOnly,.F.,"","cName" ,,)
    oBirth       := TGet():New(     037,067,bBirth ,oNewEmployee,060,008,""                 ,       ,  CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,lRedOnly,.F.,"","dBirth",,)
    oSex         := TComboBox():New(050,067,bBtSex ,aSexes      ,061,010,oNewEmployee       ,,,     ,  CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nSex )
    oCon         := TGet():New(     062,067,bCon   ,oNewEmployee,060,008,"@R (99)99999-9999",       ,  CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,lRedOnly,.F.,"","cCon"  ,,)
    oEmail       := TGet():New(     075,067,bEmail ,oNewEmployee,125,008,""                 ,       ,  CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,lRedOnly,.F.,"","cEmail",,)
    oCep         := TGet():New(     087,067,bCep   ,oNewEmployee,060,008,"@R 99999-999"     ,bLocDat,  CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,lRedOnly,.F.,"","cCep"  ,,)
    oAdr         := TGet():New(     100,067,bAdr   ,oNewEmployee,125,008,"@!"               ,       ,  CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,lRedOnly,.F.,"","cAdr"  ,,)
    oAdrNbr      := TGet():New(     112,067,bAdrNbr,oNewEmployee,125,008,"@!"               ,       ,  CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,lRedOnly,.F.,"","cAdrNbr"  ,,)
    oNbhd        := TGet():New(     125,067,bNbhd  ,oNewEmployee,100,008,"@!"               ,       ,  CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,lRedOnly,.F.,"","cNbhd" ,,)
    oCity        := TGet():New(     137,067,bCity  ,oNewEmployee,087,008,"@!"               ,       ,  CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,lRedOnly,.F.,"","cCity" ,,)
    oSt          := TComboBox():New(150,067,bBtSt  ,aStates     ,028,010,oNewEmployee       ,,,     ,  CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nSt  )
    oAtv         := TCheckBox():New(162,067,"",bAtv,oNewEmployee,008,008,                   ,bSetAtv,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
    oObs         := TMultiGet():New(175,067,bObs   ,oNewEmployee,125,030,                   ,       ,  CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,lRedOnly,,,.F.,, )

    if (nOption == 2)
        oDataAlter   := TButton():New( 214,156,"OK"  ,oNewEmployee,{||oNewEmployee:End()},037,012,,,,.T.,,"",,,,.F. )
    elseif (nOption == 5)
        oDataAlter   := TButton():New( 214,112,"EXCLUIR" ,oNewEmployee,{||U_DelReg(cTable, lRecAct), oNewEmployee:End() },037,012,,,,.T.,,"",,,,.F. )
        oCancel      := TButton():New( 214,156,"CANCELAR",oNewEmployee,{||oNewEmployee:End()},037,012,,,,.T.,,"",,,,.F. )
    else
        oDataAlter   := TButton():New( 214,112,"SALVAR"  ,oNewEmployee,{||U_DatAlter(lRecAct, cTable, cName, cXcpf, dBirth, nSex, cCon, cEmail, cCep, cAdr, cAdrNbr, cNbhd, cCity, nSt, lAtv, cObs), oNewEmployee:End() },037,012,,,,.T.,,"",,,,.F. )
        oCancel      := TButton():New( 214,156,"CANCELAR",oNewEmployee,{||oNewEmployee:End()},037,012,,,,.T.,,"",,,,.F. )
    endif

    oNewEmployee:Activate(,,,.T.)

return

Static Function checkCpf(cTable, cXcpf, lRecAct)

    DBSETORDER(2)

    if (SZ1->( DBSEEK( xFilial(cTable) + cXcpf )))
        alert("CADASTRO JÁ EXISTE, OS DADOS SERÃO CARREGADOS!")
        GetZ1Dat()
        lRecAct := .F.
    endif

return .T.

Static Function checkCep(cCep)

    Local aInfo := {}

    aInfo := U_GETLOCDT(cCep)
    if (VALTYPE(aInfo) == "A")
        cAdr  := aInfo[1]
        cNbhd := aInfo[2]
        cCity := aInfo[3]
        nSt   := aInfo[4]
    else
        if (MSGYESNO("Erro no processamento do CEP, deseja encerrar?"))
            oNewEmployee:End()
        endif
    endif

return

Static Function GetZ1Dat()

    cXcpf   := SZ1->Z1_CPF
    cName   := SZ1->Z1_NAME
    dBirth  := SZ1->Z1_BIRTH
    nSex    := SZ1->Z1_SEX
    cCon    := SZ1->Z1_CON
    cEmail  := SZ1->Z1_EMAIL
    cCep    := SZ1->Z1_CEP
    cAdr    := SZ1->Z1_ADR
    cAdrNbr := SZ1->Z1_ADRNUM
    cNbhd   := SZ1->Z1_NBHD
    cCity   := SZ1->Z1_CITY
    nSt     := SZ1->Z1_STATE
    lAtv    := SZ1->Z1_ACTIVE
    cObs    := SZ1->Z1_OBS

return 
