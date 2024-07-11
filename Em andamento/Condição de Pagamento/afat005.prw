#INCLUDE "PROTHEUS.CH"

#DEFINE INCLUI 3
#DEFINE ALTERA 4

User Function afat005(oJson, oJsonRet, nOperation)
    Local aDadosCabec := {}
	Local aErros      := {}
	Local aAreaSE4    := SE4->(FwGetArea())
	Local cPasta      := GetNewPar("MV_PASTA", "\cfglog\")
    Local cArquivo    := "log_inclui_condicaoPagamento" + DTOS(dDataBase) + ".log"
	Local cLog        := ""
	Local nI          := 0
	Local lRet        := .F.

	Private lMsErroAuto    := .F.
	Private lAutoErrNoFile := .T.
	Private lMsHelpAuto    := .T.

	Begin Transaction

    cLog := "[afat005 - Condição de Pagamento] Hora inicio: " + Time() + CRLF

	afat005B(oJson, @aDadosCabec, , nOperation)

	DbSelectArea("SE4")
	SE4->(DbSelectOrder(1))

	If SE4->(!DbSeek(xFilial("SE4") + AllTrim(oJson["codigo"])))

		MSExecAuto({|x,y,z|MATA360(x,y,z)},aDadosCabec,, INCLUI)

		If lMsErroAuto
			aErros := GetAutoGRLog()

			For nI := 1 To Len(aErros)
				cLog += aErros[nI] + CRLF
			Next nI

			SetRestFault(400, EncodeUTF8("Erro na gravação da condição de pagamento. Mais detalhes no arquivo de log"))
			DisarmTransaction()
		Else

            oJsonRet := afat005D(aDadosCabec[2][2], nOperation)
            lRet     := .T.
		EndIf
	Else
		SetRestFault(400, EncodeUTF8("Condição de pagamento " + aDadosCabec[2][2] + " já cadastrado"))
		DisarmTransaction()
	EndIf

	End Transaction

    cLog += "[afat005 - Condição de Pagamento] Hora termino: " + Time()

    afat005C(cLog, cPasta, cArquivo)

    FwRestArea(aAreaSE4)
Return lRet

User Function afat005A(oJson, oJsonRet, cCodigo, nOperation)
    Local aDadosCabec := {}
	Local aErros      := {}
	Local aAreaSE4    := SE4->(FwGetArea())
	Local cPasta      := GetNewPar("MV_PASTA", "\cfglog\")
    Local cArquivo    := "log_altera_condicaoPagamento" + DTOS(dDataBase) + ".log"
	Local cLog        := ""
	Local nI          := 0
	Local lRet        := .F.

	Private lMsErroAuto    := .F.
	Private lAutoErrNoFile := .T.
	Private lMsHelpAuto    := .T.

	Begin Transaction

    cLog := "[afat005A - Condição de Pagamento] Hora inicio: " + Time() + CRLF

	afat005B(oJson, @aDadosCabec, cCodigo, nOperation)

	DbSelectArea("SE4")
	SE4->(DbSelectOrder(1))

	If SE4->(DbSeek(xFilial("SE4") + AllTrim(oJson["codigo"])))

		MSExecAuto({|x,y,z|MATA360(x,y,z)},aDadosCabec,, ALTERA)

		If lMsErroAuto
			aErros := GetAutoGRLog()

			For nI := 1 To Len(aErros)
				cLog += aErros[nI] + CRLF
			Next nI

			SetRestFault(400, EncodeUTF8("Erro na gravação da condição de pagamento. Mais detalhes no arquivo de log"))
			DisarmTransaction()
		Else

            oJsonRet := afat005D(cCodigo, nOperation)
            lRet     := .T.
		EndIf
	Else
		SetRestFault(400, EncodeUTF8("Condição de pagamento " + aDadosCabec[2][2] + " não encontrado"))
		DisarmTransaction()
	EndIf

	End Transaction

    cLog += "[afat005A - Condição de Pagamento] Hora termino: " + Time()

    afat005C(cLog, cPasta, cArquivo)

    FwRestArea(aAreaSE4)
Return lRet

Static Function afat005B(oJson, aDadosExec, cCodigo, nOperation)
    Default cCodigo := ""

    aAdd(aDadosExec, {"E4_FILIAL" ,xFilial("SE4")                              , Nil})
    aAdd(aDadosExec, {"E4_CODIGO" ,IIF(Empty(cCodigo),oJson["codigo"], cCodigo), Nil})
    aAdd(aDadosExec, {"E4_TIPO"   ,oJson["tipo"]                               , Nil})
    aAdd(aDadosExec, {"E4_COND"   ,oJson["condicao"]                           , Nil})
    aAdd(aDadosExec, {"E4_DESCRI" ,oJson["descricao"]                          , Nil})
    aAdd(aDadosExec, {"E4_XCUSFIN",oJson["custoFinanceiro"]                    , Nil})
    If nOperarion == ALTERA
        aAdd(aDadosExec, {"E4_MSBLQL",oJson["status"]                          , Nil})
    Else
        aAdd(aDadosExec, {"E4_MSBLQL", "2"                                     , Nil})
    EndIf

Return

Static Function afat005C(cLog, cPasta, cArquivo)

    Local cPath   := ""
    Local nHandle := 0
    Local nLinhas := 0

    cPath := cPasta + cArquivo

    If !File(cPath)
        nHandle := FCreate(cPath)
        If nHandle == -1
            ConOut("Erro ao criar arquivo - ferror " + Str(FError()))
            Return
        EndIf
    EndIf

    nHandle := FOpen(cPath, FO_READWRITE + FO_SHARED)

    If nHandle == -1
        ConOut("Erro ao abrir o arquivo - ferror " + Str(FError()))
    Else
        FSeek(nHandle, 0, FS_END)
        FWrite(nHandle, cLog, Len(cLog))
        fClose(nHandle)
    EndIf

Return

Static Function afat005D(cCondPag, nOperation)
    Local oJsonRet := NIL
    Local cMsg     := ""

    Do Case
    Case nOperation == INCLUI
        cMsg := "Condição de pagamento cadastrada com sucesso."
    Case nOperation == ALTERA
        cMsg := "Condição de pagamento atualizada com sucesso."
    EndCase

    oJsonRet := JsonObject():New()

    oJsonRet["codigo"]   := cCondPag
    oJsonRet["mensagem"] := cMsg

Return oJsonRet
