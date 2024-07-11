#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

#DEFINE INCLUI 1
#DEFINE ALTERA 2

/*/{Protheus.doc} aesp001
Função responsável pela inclusão da Região
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param oJson, object, Objeto com a nova região
@param oJsonRet, object, Mensagem de retorno
/*/
User Function aesp001(oJson, oJsonRet)
	Local lRet       := .F.
	Local cRegiao    := ""
	Local cChave     := ""

	cRegiao := DecodeUTF8(oJson["regiao"])

	If !Empty(cRegiao)

		cChave := aesp001D()

		If !aesp001F(cRegiao)

			FwPutSX5(/*cFlavour*/, "A2", cChave, AllTrim(cRegiao), /*cTextoEng*/, /*cTextoEsp*/, /*cTextoAlt*/)

			If aesp001G(cChave, cRegiao)
				oJsonRet := aesp001C(cRegiao, cChave, INCLUI)
				lRet := .T.
			Else
				SetRestFault(400, EncodeUTF8("Cadastro não realizado."))
			EndIf
		Else
			SetRestFault(400, EncodeUTF8("Regiao já existente no sistema!"))
		EndIf
	Else
		SetRestFault(400, EncodeUTF8("Chave 'regiao' não encontrada.")) // TODO mudar tag
	EndIf

Return lRet

/*/{Protheus.doc} aesp001A
Função responsável pela alteração da Região
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param oJson, object, Objeto com a região a ser alterada
@param oJsonRet, object, Mensagem de retorno
/*/
User Function aesp001A(oJson, oJsonRet)
	Local lRet       := .F.
	Local cRegiao    := ""
	Local cRegiaoAnt := ""
	Local cChave     := ""

	cRegiao := DecodeUTF8(oJson["regiao"])

	If !Empty(cRegiao)

		cRegiaoAnt := oJson["regiaoAnterior"]

		cChave := aesp001E(cRegiaoAnt)

		If Empty(cChave)
			Return .F.
		EndIf

		If !aesp001F(cRegiao)

			FwPutSX5(/*cFlavour*/, "A2", cChave, AllTrim(cRegiao), /*cTextoEng*/, /*cTextoEsp*/, /*cTextoAlt*/)

			If aesp001G(cChave, cRegiao)
				oJsonRet := aesp001C(cRegiao, cChave, ALTERA)
				lRet := .T.
			Else
				SetRestFault(400, EncodeUTF8("Atualização não realizada"))
			EndIf
		Else
			SetRestFault(400, EncodeUTF8("Regiao já existente no sistema!"))
		EndIf
	Else
		SetRestFault(400, EncodeUTF8("Chave 'regiao' não encontrada")) // TODO mudar tag
	EndIf

Return lRet

/*/{Protheus.doc} aesp001B
Função responsável pela consulta de Região
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
/*/
User Function aesp001B()
    Local oJson   := NIL
    Local nI      := 0
    Local aChaves := {}
	Local aJson   := {}

    aChaves := FwGetSX5("A2")

    oJson := JsonObject():New()

    For nI := 1 To Len(aChaves)
        aAdd(aJson, JsonObject():New())

		aJson[nI]["chave"]  := AllTrim(aChaves[nI][3])
		aJson[nI]["regiao"] := AllTrim(aChaves[nI][4])

    Next nI

	oJson:Set(aJson)

Return oJson

/*/{Protheus.doc} aesp001C
Função responsável pela mensagem de retorno
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param cRegiao, character, Região
@param cChave, character, Chave da região
@param nOperacao, numeric, Operação realizada
/*/
Static Function aesp001C(cRegiao, cChave, nOperacao)
	Local oJsonRet := NIL

	oJsonRet := JsonObject():New()

	oJsonRet["chave"]    := AllTrim(cChave)
	oJsonRet["regiao"]   := cRegiao
	oJsonRet["mensagem"] := IIF(nOperacao == INCLUI, "Região cadastrada com sucesso.", "Região atualizada com sucesso")

Return oJsonRet

/*/{Protheus.doc} aesp001D
Função responsável pela coleta do proximo numero
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
/*/
Static Function aesp001D()
	Local aRegioes := {}
	Local cChave   := ""

	aRegioes := FwGetSX5("A2")

	cChave := Len(aRegioes) + 1
	cChave := PadR(PadL(cValToChar(cChave), 3, '0'),FwSx3Util():GetFieldStruct("X5_CHAVE")[3])

Return cChave

/*/{Protheus.doc} aesp001E
Função responsável pela coleta da chave da região a ser alterada
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param cChave, character, Chave da região que está sendo alterada
/*/
Static Function aesp001E(cRegiaoAnt)
	Local cChave  := ""
	Local aChaves := {}
	Local nI      := 0
	Local lAchou  := .F.

	aChaves := FwGetSX5("A2")

	For nI := 1 To Len(aChaves)
		If cRegiaoAnt == aChaves[nI][4]
			lAchou := .T.
			Exit
		EndIf
	Next nI

	If lAchou
		cChave := aChaves[nI][3]
	Else
		SetRestFault(400, EncodeUTF8("Região anterior não existente. Favor revisar!"))
	EndIf

Return cChave

/*/{Protheus.doc} aesp001F
Função responsável pela consulta se o registro existe
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param cRegiao, character, Região
/*/
Static Function aesp001F(cRegiao)
	Local aRegioes := {}
	Local lExiste  := .F.
	Local nI       := 0

	aRegioes := FwGetSX5("A2")

	For nI := 1 To Len(aRegioes)
		lExiste := cRegiao == aRegioes[nI][4]
	Next nI

Return lExiste

/*/{Protheus.doc} aesp001G
Função responsável por verificar se a região foi incluida com sucesso
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param cRegiao, character, Região
@param cChave, character, Chave da região
/*/
Static Function aesp001G(cChave, cRegiao)
	Local lRet := .F.
	Local aChave := {}

	aChave := FwGetSX5("A2", cChave)

	If !Empty(aChave) .And. AllTrim(aChave[1][4]) == cRegiao
		lRet := .T.
	EndIf

Return lRet
