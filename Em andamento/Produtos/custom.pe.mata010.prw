#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"

User Function ITEM()
    Local cIdPonto := ""
    Local cIdModel := ""
    Local aParam   := PARAMIXB
    Local aDados   := {}
    Local lRet     := .T.
    Local oModel   := NIL
    Local oJson    := NIL

    If aParam <> NIL
        oModel   := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := "SB1MASTER"

        If cIdPonto == "MODELCOMMITNTTS"
            aAdd(aDados, {"codigo"              , oModel:GetValue(cIdModel, "B1_COD")})
            aAdd(aDados, {"descricao"           , oModel:GetValue(cIdModel, "B1_DESC")})
            aAdd(aDados, {"nomenclaturaMercosul", oModel:GetValue(cIdModel, "B1_POSIPI")})
            aAdd(aDados, {"armazem"             , oModel:GetValue(cIdModel, "B1_LOCPAD")})
            aAdd(aDados, {"unidadeMedida"       , oModel:GetValue(cIdModel, "B1_UM")})
            aAdd(aDados, {"segundaUnidade"      , oModel:GetValue(cIdModel, "B1_SEGUM")})
            aAdd(aDados, {"conversorUnidade"    , oModel:GetValue(cIdModel, "B1_CONV")})
            aAdd(aDados, {"tipoConversao"       , oModel:GetValue(cIdModel, "B1_TIPCONV")})
            aAdd(aDados, {"grupo"               , oModel:GetValue(cIdModel, "B1_GRUPO")})
            
            oJson := afat008(aDados)

            afat008A(oJson, aDados)
        EndIf
    EndIf

Return lRet

Static Function afat008(aDados)
	Local nI    := 0
    Local oJson := NIL

	oJson := JsonObject():New()

    For nI := 1 To Len(aDados)
        oJson[aDados[nI,1]] := AllTrim(aDados[nI,2])
    Next nI

Return oJson


Static Function afat008A(oJson, aDados)
	Local cURL    := ""
	Local cPath   := ""
    Local cToken  := ""
	Local aHeader := {}
    Local lRet    := .T.
    Local oRest   := NIL

	cURL   := "" //a ser definido
	cPath  := "" //a ser definido
	cToken := "" //a ser definido

	aAdd(aHeader, "Content-Type: application/json")
	aAdd(aHeader, "Authorization: Basic " + cToken)

	oRest := FwRest():New(cURL)
	oRest:setPath(cPath)

	If !oRest:Put(aHeader, oJson:ToJson())
		cResult := oRest:GetLastError()
		FWAlertError("Integração com Sogivendas falhou, erro: " + cResult, "Erro")
		lRet := .F.
	EndIf

Return lRet




