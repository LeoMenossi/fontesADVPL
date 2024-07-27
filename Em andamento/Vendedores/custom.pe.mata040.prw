#INCLUDE "PROTHEUS.CH"

User Function MA040DIN()
    Local aDados := {}
    Local oJson  := NIL    

    aAdd(aDados,{"filial"            , M->A3_FILIAL})
    aAdd(aDados,{"codigo"            , M->A3_COD})
    aAdd(aDados,{"nome"              , M->A3_NOME})
    aAdd(aDados,{"nomeReduzido"      , M->A3_NREDUZ})
    aAdd(aDados,{"endereco"          , M->A3_END})
    aAdd(aDados,{"bairro"            , M->A3_BAIRRO})
    aAdd(aDados,{"municipio"         , M->A3_MUN})
    aAdd(aDados,{"estado"            , M->A3_EST})
    aAdd(aDados,{"ddd"               , M->A3_DDDTEL})
    aAdd(aDados,{"cep"               , M->A3_CEP})
    aAdd(aDados,{"telefone"          , M->A3_TEL})
    aAdd(aDados,{"bloqueado"         , M->A3_MSBLQL})
    aAdd(aDados,{"tipo"              , M->A3_TIPO})
    aAdd(aDados,{"cpfCnpj"           , M->A3_CGC})
    aAdd(aDados,{"inscricao"         , M->A3_INSCR})
    aAdd(aDados,{"inscricaoMunicipal", M->A3_INSCRM})
    aAdd(aDados,{"email"             , M->A3_EMAIL})
    aAdd(aDados,{"homePage"          , M->A3_HPAGE})

    oJson := afat006A(aDados)

    If afat006B(oJson)
        FwAlertSuccess("Integração realizada com sucesso!", "Sucesso")
    EndIf

Return

User Function MA040DAL()
    Local aDados := {}
    Local oJson  := NIL    

    aAdd(aDados,{"filial"            , M->A3_FILIAL})
    aAdd(aDados,{"codigo"            , M->A3_COD})
    aAdd(aDados,{"nome"              , M->A3_NOME})
    aAdd(aDados,{"nomeReduzido"      , M->A3_NREDUZ})
    aAdd(aDados,{"endereco"          , M->A3_END})
    aAdd(aDados,{"bairro"            , M->A3_BAIRRO})
    aAdd(aDados,{"municipio"         , M->A3_MUN})
    aAdd(aDados,{"estado"            , M->A3_EST})
    aAdd(aDados,{"ddd"               , M->A3_DDDTEL})
    aAdd(aDados,{"cep"               , M->A3_CEP})
    aAdd(aDados,{"telefone"          , M->A3_TEL})
    aAdd(aDados,{"bloqueado"         , M->A3_MSBLQL})
    aAdd(aDados,{"tipo"              , M->A3_TIPO})
    aAdd(aDados,{"cpfCnpj"           , M->A3_CGC})
    aAdd(aDados,{"inscricao"         , M->A3_INSCR})
    aAdd(aDados,{"inscricaoMunicipal", M->A3_INSCRM})
    aAdd(aDados,{"email"             , M->A3_EMAIL})
    aAdd(aDados,{"homePage"          , M->A3_HPAGE})

    oJson := afat006A(aDados)

    If afat006B(oJson)
        FwAlertSuccess("Integração realizada com sucesso!", "Sucesso")
    EndIf
Return 

Static Function afat006A(aDados)
	Local oJson := NIL
    Local nI    := 0

	oJson := JsonObject():New()

    For nI := 1 To Len(aDados)
        oJson[aDados[nI][1]] := AllTrim(aDados[nI][2])
    Next nI

Return oJson

Static Function afat006B(oJson)
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

