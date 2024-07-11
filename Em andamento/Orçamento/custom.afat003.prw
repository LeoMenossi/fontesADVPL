#INCLUDE "PROTHEUS.CH"

#DEFINE INCLUI 3
#DEFINE ALTERA 4

User Function afat003(oJson, oJsonRet, nOperation)
    Local aDadosCabec := {}
	Local aDadosItens := {}
	Local aErros      := {}
	Local aAreaSCJ    := SCJ->(FwGetArea())
	Local aAreaSCK    := SCK->(FwGetArea())
	Local cPasta      := GetNewPar("MV_PASTA", "\cfglog\")
    Local cArquivo    := "log_inclui_orcamento" + DTOS(dDataBase) + ".txt"
	Local cLog        := ""
	Local nI          := 0
	Local lRet        := .F.
	Local lCliente    := .F.

	Private lMsErroAuto    := .F.
	Private lAutoErrNoFile := .T.
	Private lMsHelpAuto    := .T.

	Begin Transaction

	afat003B(oJson, @aDadosCabec, @aDadosItens, , nOperation)

	DbSelectArea("SCJ")
	SCJ->(DbSelectOrder(1))

	If SCJ->(!DbSeek(xFilial("SCJ") + aDadosCabec[2][1] + PadR(oJson["cliente"], FwSX3Util():GetFieldStruct("CJ_CLIENTE")[3]) + PadR(oJson["loja"], FwSX3Util():GetFieldStruct("CJ_LOJA")[3])))

		MATA415(aDadosCabec, aDadosItens, nOperation) 

		If lMsErroAuto
			aErros := GetAutoGRLog()

			For nI := 1 To Len(aErros)
				cLog += aErros[nI] + CRLF
			Next nI

			SetRestFault(400, EncodeUTF8("Erro na gravação do orçamento. Mais detalhes no arquivo de log"))
			RollBackSX8()
			DisarmTransaction()
		Else
			ConfirmSX8()

			If !Empty(oJson["cliente"]) .AND. !Empty(oJson["loja"]) .AND. Empty(oJson["motivoPerda"]) .AND. Empty(oJson["descricaoPerda"])
				lCliente := .T.

				afat003D(@aDadosCabec, @aDadosItens, lCliente)

				MATA416(aDadosCabec, aDadosItens)

				If lMsErroAuto
					aErros := GetAutoGRLog()

					For nI := 1 To Len(aErros)
						cLog += aErros[nI] + CRLF
					Next nI

					SetRestFault(400, EncodeUTF8("Erro na aprovação do orçamento. Mais detalhes no arquivo de log"))
				Else
					oJsonRet := afat003C(aDadosCabec[1][2], nOperation)
					lRet := .T.
				EndIf

			ElseIf !Empty(oJson["prospect"]) .AND. !Empty(oJson["lojaProspect"]) .AND. Empty(oJson["motivoPerda"]) .AND. Empty(oJson["descricaoPerda"])

				afat003D(@aDadosCabec, @aDadosItens)

				MATA416(aDadosCabec, aDadosItens)

				If lMsErroAuto
					aErros := GetAutoGRLog()

					For nI := 1 To Len(aErros)
						cLog += aErros[nI] + CRLF
					Next nI

					SetRestFault(400, EncodeUTF8("Erro na aprovação do orçamento. Mais detalhes no arquivo de log"))
				Else
					oJsonRet := afat003C(aDadosCabec[1][2], nOperation)
					lRet := .T.
				EndIf
			EndIf
		EndIf
	Else

		SetRestFault(400, EncodeUTF8("Orçamento " + aDadosCabec[2][1] + " já cadastrado"))

		DisarmTransaction()

	EndIf

	End Transaction

	If !Empty(cLog)
		MemoWrite(cPasta + cArquivo, cLog)
	EndIf

    FwRestArea(aAreaSCJ)
    FwRestArea(aAreaSCK)
Return lRet

User Function afat003A(oJson, oJsonRet, cCodOrc, nOperation)
    Local aDadosCabec := {}
	Local aDadosItens := {}
	Local aErros      := {}
	Local aAreaSCJ    := SCJ->(FwGetArea())
	Local aAreaSCK    := SCK->(FwGetArea())
	Local cPasta      := GetNewPar("MV_PASTA", "\cfglog\")
    Local cArquivo    := "log_altera_orcamento" + DTOS(dDataBase) + ".txt"
	Local cLog        := ""
	Local nI          := 0
	Local lRet        := .F.

	Private lMsErroAuto    := .F.
	Private lAutoErrNoFile := .T.
	Private lMsHelpAuto    := .T.

	Begin Transaction

	afat003B(oJson, @aDadosCabec, @aDadosItens, cCodOrc, nOperation)

	DbSelectArea("SCJ")
	SCJ->(DbSelectOrder(1))

	If SCJ->(DbSeek(xFilial("SCJ") + cCodOrc + PadR(oJson["cliente"], FwSX3Util():GetFieldStruct("CJ_CLIENTE")[3]) + PadR(oJson["loja"], FwSX3Util():GetFieldStruct("CJ_LOJA")[3])))

		MATA415(aDadosCabec, aDadosItens, nOperation) 

		If lMsErroAuto
			aErros := GetAutoGRLog()

			For nI := 1 To Len(aErros)
				cLog += aErros[nI] + CRLF
			Next nI

			SetRestFault(400, EncodeUTF8("Erro na gravação do orçamento. Mais detalhes no arquivo de log"))
			DisarmTransaction()
		Else
				oJsonRet := afat003C(cCodOrc, nOperation)
                lRet := .T.
		EndIf
	Else
		SetRestFault(404, EncodeUTF8("Orçamento " + cCodOrc + " não encontrado, revisar o CPF/CNPJ"))
		DisarmTransaction()
	EndIf

	End Transaction

	If !Empty(cLog)
		MemoWrite(cPasta + cArquivo, cLog)
	EndIf

    FwRestArea(aAreaSCJ)
    FwRestArea(aAreaSCK)
Return lRet

Static Function afat003B(oJson, aDadosCabec, aDadosItens, cCodOrc, nOperation)

	Default cCodOrc := ""

	aAdd(aDadosCabec,{"CJ_FILIAL", xFilial("SCJ"), Nil})
	aAdd(aDadosCabec,{IIF(Empty(cCodOrc),GetSXENum("SCJ","CJ_NUM"), cCodOrc),"CJ_NUM", Nil})
	aAdd(aDadosCabec,{"CJ_TIPOCLI", oJson["tipo"], Nil})
	aAdd(aDadosCabec,{"CJ_CLIENTE", oJson["cliente"], Nil})
	aAdd(aDadosCabec,{"CJ_LOJA"   , oJson["loja"], Nil})
	aAdd(aDadosCabec,{"CJ_CLIENT" , oJson["clienteEntrega"], Nil})
	aAdd(aDadosCabec,{"CJ_LOJAENT", oJson["lojaEntrega"], Nil})
	aAdd(aDadosCabec,{"CJ_PROSPE" , oJson["prospect"], Nil})
	aAdd(aDadosCabec,{"CJ_LOJPRO" , oJson["lojaProspect"], Nil})
	aAdd(aDadosCabec,{"CJ_CONDPAG", oJson["condicaoPagamento"], Nil})
	aAdd(aDadosCabec,{"CJ_XTRANSP", oJson["transportadora"], Nil})
	aAdd(aDadosCabec,{"CJ_XTRARD" , oJson["transportadoraRedespacho"], Nil})
	aAdd(aDadosCabec,{"CJ_EMISSAO", STOD(oJson["emissao"]), Nil})
	aAdd(aDadosCabec,{"CJ_TPFRETE", oJson["tipoFrete"], Nil})
	aAdd(aDadosCabec,{"CJ_FRETE"  , Val(oJson["frete"]), Nil})
	aAdd(aDadosCabec,{"CJ_SEGURO" , Val(oJson["seguro"]), Nil})
	aAdd(aDadosCabec,{"CJ_DESPESA", Val(oJson["despesa"]), Nil})
	aAdd(aDadosCabec,{"CJ_XMENNOT", oJson["mensagemNota"], Nil})
	aAdd(aDadosCabec,{"CJ_TABELA" , oJson["tabela"], Nil})
	aAdd(aDadosCabec,{"CJ_XVEND1" , oJson["vendedor"], Nil})
	aAdd(aDadosCabec,{"CJ_XVENNO" , oJson["nomeVendedor"], Nil})
	aAdd(aDadosCabec,{"CJ_XPEDCOM", "", Nil})
	aAdd(aDadosCabec,{"CJ_XPEDSOG", oJson["pedidoSogivendas"], Nil})
	aAdd(aDadosCabec,{"CJ_XPEDVEN", "", Nil})
	aAdd(aDadosCabec,{"CJ_TPCARGA", oJson["tipoCarga"], Nil})
	aAdd(aDadosCabec,{"CJ_XPERDA" , oJson["motivoPerda"], Nil})
	aAdd(aDadosCabec,{"CJ_XPERDES", oJson["descricaoPerda"], Nil})

	aAdd(aDadosItens,{"CK_FILIAL",xFilial("SC5"), NIL})
	aAdd(aDadosItens,{"CK_ITEM"   ,oJson["item"], NIL})
	aAdd(aDadosItens,{"CK_PRODUTO",oJson["produto"], NIL})
	aAdd(aDadosItens,{"CK_QTDVEN" ,Val(oJson["quantidade"]), NIL})
	aAdd(aDadosItens,{"CK_PRCVEN" ,Val(oJson["precoUnitario"]), NIL})
	aAdd(aDadosItens,{"CK_VALOR"  ,Val(oJson["valorTotal"]), NIL})
	aAdd(aDadosItens,{"CK_OPER"   ,"01", NIL})
	aAdd(aDadosItens,{"CK_DESCONT",Val(oJson["desconto"]), NIL})
	aAdd(aDadosItens,{"CK_ENTREG" ,STOD(oJson["dataEntrega"]), NIL})
	aAdd(aDadosItens,{"CK_PEDCLI" ,oJson["pedidoCompra"], NIL})
	aAdd(aDadosItens,{"CK_OBS"    ,oJson["obeservacao"], NIL})

Return

Static Function afat003C(cCodigo, nOperation)
    Local oJsonRet := NIL
    Local cMsg     := ""

    Do Case
    Case nOperation == INCLUI
        cMsg := "Orçamento incluido e aprovado com sucesso."
    Case nOperation == ALTERA
        cMsg := "Cliente atualizado com sucesso."
    Otherwise
        cMsg := "Cliente deletado com sucesso."
    EndCase

    oJsonRet := JsonObject():New()

    oJsonRet["codigo"]   := cCodigo
    oJsonRet["mensagem"] := cMsg

Return oJsonRet

Static Function afat003D(aDadosCabec, aDadosItens, lCliente)
	Local aCabecAprov  := {}
	Local aItensAprov  := {}
	Local cClientePros := SubStr(GetNewPar("MV_ORCLIPD", "00000101"),1,7)
	Local cLojaPros    := SubStr(GetNewPar("MV_ORCLIPD", "00000101"),7,2)

	Default lCliente := .F.

	If lCliente
		aAdd(aCabecAprov, {aDadosCabec[2][1] , aDadosCabec[2][2] , Nil})
		aAdd(aCabecAprov, {aDadosCabec[4][1] , aDadosCabec[4][2] , Nil})
		aAdd(aCabecAprov, {aDadosCabec[5][1] , aDadosCabec[5][2] , Nil})
		aAdd(aCabecAprov, {aDadosCabec[6][1] , aDadosCabec[6][2] , Nil})
		aAdd(aCabecAprov, {aDadosCabec[7][1] , aDadosCabec[7][2] , Nil})
		aAdd(aCabecAprov, {aDadosCabec[10][1], aDadosCabec[10][2], Nil})

		aAdd(aItensAprov, {aDadosItens[2][1], aDadosItens[2][2], Nil})
		aAdd(aItensAprov, {aDadosItens[3][1], aDadosItens[3][2], Nil})
		aAdd(aItensAprov, {aDadosItens[4][1], aDadosItens[4][2], Nil})
		aAdd(aItensAprov, {aDadosItens[5][1], aDadosItens[5][2], Nil})
		aAdd(aItensAprov, {aDadosItens[6][1], aDadosItens[6][2], Nil})
		aAdd(aItensAprov, {aDadosItens[7][1], aDadosItens[7][2], Nil})

	Else
		aAdd(aCabecAprov, {aDadosCabec[2][1] , aDadosCabec[2][2] , Nil})
		aAdd(aCabecAprov, {aDadosCabec[8][1] , aDadosCabec[8][2] , Nil})
		aAdd(aCabecAprov, {aDadosCabec[9][1] , aDadosCabec[9][2] , Nil})
		aAdd(aCabecAprov, {aDadosCabec[5][1] , cClientePros      , Nil})
		aAdd(aCabecAprov, {aDadosCabec[6][1] , cLojaPros         , Nil})
		aAdd(aCabecAprov, {aDadosCabec[10][1], aDadosCabec[10][2], Nil})

		aAdd(aItensAprov, {aDadosItens[2][1], aDadosItens[2][2], Nil})
		aAdd(aItensAprov, {aDadosItens[3][1], aDadosItens[3][2], Nil})
		aAdd(aItensAprov, {aDadosItens[4][1], aDadosItens[4][2], Nil})
		aAdd(aItensAprov, {aDadosItens[5][1], aDadosItens[5][2], Nil})
		aAdd(aItensAprov, {aDadosItens[6][1], aDadosItens[6][2], Nil})
		aAdd(aItensAprov, {aDadosItens[7][1], aDadosItens[7][2], Nil})
	EndIf

	aDadosCabec := aCabecAprov
	aDadosItens := aItensAprov

Return

