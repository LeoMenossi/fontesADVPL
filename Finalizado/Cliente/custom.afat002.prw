#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"

#DEFINE INCLUI 3
#DEFINE ALTERA 4

/*/{Protheus.doc} afat002
Função responsável pela inclusão de clientes no Protheus
@type Function
@version 12.1.2310 
@author leonardo.JAVBCode
@since 7/4/2024
@param oJson, object, Objeto com as informações recebidas pelo Sogivendas
@param oJsonRet, object, Objeto com retorno
@param nOperation, numeric, Operação realizada
@return variant, lRet, Variavel lógica de controle
/*/
User Function afat002(oJson, oJsonRet, nOperation)

	Local aDadosExec := {}
	Local aDadosComp := {}
	Local aErros     := {}
	Local aAreaSA1   :=  SA1->(FwGetArea())
	Local cPasta     := GetNewPar("MV_PASTA", "\cfglog\")
    Local cArquivo   := "log_inclui_cliente" + DTOS(dDataBase) + ".txt"
	Local cLog       := ""
	Local nI         := 0
	Local lRet       := .F.

	Private lMsErroAuto    := .F.
	Private lAutoErrNoFile := .T.
	Private lMsHelpAuto    := .T.

	Begin Transaction

	afat002A(oJson, @aDadosExec, @aDadosComp, /*cCodCli*/, /*cLojaCli*/, nOperation)

	DbSelectArea("SA1")
	SA1->(DbSetOrder(3))

	If SA1->(!DbSeek(xFilial("SA1") + AllTrim(oJson["cpfCnpj"])))

		MSExecAuto({|a,b,c| CRMA980(a,b,c)}, aDadosExec, nOperation, aDadosComp)

		If lMsErroAuto
			aErros := GetAutoGRLog()

			For nI := 1 To Len(aErros)
				cLog += aErros[nI] + CRLF
			Next nI

			SetRestFault(400, EncodeUTF8("Erro na gravação. Mais detalhes no arquivo de log"))
			RollBackSX8()
			DisarmTransaction()
		Else
			oJsonRet := afat002F(aDadosExec[2][2], nOperation)
			ConfirmSX8()
			lRet := .T.
		EndIf
	Else

		SetRestFault(400, EncodeUTF8("Cliente " + AllTrim(oJson["cpfCnpj"]) + " já cadastrado"))

		DisarmTransaction()
	EndIf

	End Transaction

	If !Empty(cLog)
		MemoWrite(cPasta + cArquivo, cLog)
	EndIf

	FwRestArea(aAreaSA1)
Return lRet

/*/{Protheus.doc} afat002G
Função responsável pela alteração de clientes no Protheus
@type Function
@version 12.1.2310 
@author leonardo.JAVBCode
@since 7/4/2024
@param oJson, object, Objeto com as informações recebidas pelo Sogivendas
@param oJsonRet, object, Objeto com retorno
@param cCGC, character, CPF/CNPJ do cliente
@param nOperation, numeric, Operação realizada
@return variant, lRet, Variavel lógica de controle
/*/
User Function afat002G(oJson, oJsonRet, cCGC, nOperation)
	Local aDadosExec := {}
	Local aDadosComp := {}
	Local aErros     := {}
	Local aAreaSA1   :=  SA1->(FwGetArea())
	Local cPasta     := GetNewPar("MV_PASTA", "\cfglog\")
    Local cArquivo   := "log_altera_cliente" + DTOS(dDataBase) + ".txt"
	Local cCodCli    := ""
	Local cLojaCli   := ""
	Local cLog       := ""
	Local nI         := 0
	Local lRet       := .F.

	Private lMsErroAuto    := .F.
	Private lAutoErrNoFile := .T.
	Private lMsHelpAuto    := .T.

	Begin Transaction

	DbSelectArea("SA1")
	SA1->(DbSetOrder(3))

	If SA1->(DbSeek(xFilial("SA1") + AllTrim(cCGC)))

		cCodCli  := PadR(SA1->A1_COD, FwSx3Util():GetFieldStruct("A1_COD")[3])
		cLojaCli := PadR(SA1->A1_LOJA, FwSx3Util():GetFieldStruct("A1_LOJA")[3])

		afat002A(oJson, @aDadosExec, @aDadosComp, cCodCli, cLojaCli, nOperation)

		MSExecAuto({|a,b,c| CRMA980(a,b,c)}, aDadosExec, nOperation, aDadosComp)

		If lMsErroAuto
			aErros := GetAutoGRLog()

			For nI := 1 To Len(aErros)
				cLog += aErros[nI] + CRLF
			Next nI

			SetRestFault(400, EncodeUTF8("Erro na gravação. Mais detalhes no arquivo de log"))
			DisarmTransaction()
		Else
			oJsonRet := afat002F(cCodCli, nOperation)
			lRet := .T.
		EndIf
	Else

		SetRestFault(404, EncodeUTF8("Cliente " + AllTrim(oJson["cpfCnpj"]) + " não encontrado, revisar o CPF/CNPJ"))
		DisarmTransaction()
	EndIf

	End Transaction

	If !Empty(cLog)
		MemoWrite(cPasta + cArquivo, cLog)
	EndIf

	FwRestArea(aAreaSA1)
Return lRet

/*/{Protheus.doc} afat002H
Função responsável pela exclusão de clientes no Protheus
@type Function
@version 12.1.2310 
@author leonardo.JAVBCode
@since 7/4/2024
@param cCGC, character, CPF/CNPJ do cliente
@param oJsonRet, object, Objeto com retorno
@param nOperation, numeric, Operação realizada
@return variant, lRet, Variavel lógica de controle
/*/
User Function afat002H(oJsonRet, cCGC, nOperation)
    Local cLog       := ""
    Local cPasta     := GetNewPar("MV_PASTA", "\cfglog\")
    Local cArquivo   := "log_deleta_cliente" + DTOS(dDataBase) + ".txt"
    Local aAreaSA1   := SA1->(FwGetArea())
	Local aDadosComp := {}
    Local aDadosExec := {}
    Local aErros     := {}
    Local nI         := 0
    Local lRet       := .F.

    Private lMsErroAuto := .F.
    Private lAutoErrNoFile := .T.
    Private lMsHelpAuto :=.T.

    Begin Transaction

    DbSelectArea("SA1")
    SA1->(DbSetOrder(3))
    If SA1->(DbSeek(xFilial("SA1") + AllTrim(cCGC)))

        aAdd(aDadosExec, {"A1_FILIAL", xFilial("SA1", Nil)})
        aAdd(aDadosExec, {"A1_COD"   , SA1->A1_COD  , Nil})
        aAdd(aDadosExec, {"A1_LOJA"  , SA1->A1_LOJA , Nil})

        If !Empty(aDadosExec)
            MsExecAuto({|x,y,z| CRMA980(x,y,z)}, aDadosExec, nOperation, aDadosComp) //3- Inclusão, 4- Alteração, 5- Exclusão
            If lMsErroAuto
                aErros := GetAutoGRLog()

                For nI := 1 To Len(aErros)
                    cLog += aErros[nI] + CRLF
                Next nI
            Else
                oJsonRet := afat002F(cCGC, nOperation)
                lRet := .T.
            EndIf
        EndIf
    Else
        SetRestFault(404, EncodeUTF8("Cliente " + cCGC + " não encontrado, revisar o CPF/CNPJ"))
        DisarmTransaction()
    EndIf

    End Transaction 

    If !Empty(cLog)
		MemoWrite(cPasta + cArquivo, cLog)
	EndIf

	FwRestArea(aAreaSA1)
Return lRet

/*/{Protheus.doc} afat002I
Função responsável pela consulta de clientes no Protheus
@type Function
@version 12.1.2310 
@author leonardo.JAVBCode
@since 7/4/2024
@param cCGC, character, CPF/CNPJ do cliente
@return variant, oJson, Objeto com o retorno da consulta
/*/
User Function afat002I(cCGC)
    Local aAreaSA1 := SA1->(FwGetArea())
	Local aAreaAI0 := AI0->(FwGetArea())
    Local oJson    := NIL

    DbSelectArea("SA1")
    SA1->(DbSetOrder(3))
    If SA1->(DbSeek(xFilial("SA1") + AllTrim(cCGC)))
        oJson := JsonObject():New()

		oJson["filial"]             := AllTrim(SA1->A1_FILIAL)
		oJson["codigo"]             := AllTrim(SA1->A1_COD)
		oJson["loja"]               := AllTrim(SA1->A1_LOJA)
		oJson["nome"]               := AllTrim(SA1->A1_NOME)
		oJson["pessoa"]             := AllTrim(SA1->A1_PESSOA)
		oJson["nomeReduzido"]       := AllTrim(SA1->A1_NREDUZ)
		oJson["endereco"]           := AllTrim(SA1->A1_END)
		oJson["bairro"]             := AllTrim(SA1->A1_BAIRRO)
		oJson["tipo"]               := AllTrim(SA1->A1_TIPO)
		oJson["estado"]             := AllTrim(SA1->A1_EST)
		oJson["cep"]                := AllTrim(SA1->A1_CEP)
		oJson["codigoMunicipio"]    := AllTrim(SA1->A1_COD_MUN)
		oJson["municipio"]          := AllTrim(SA1->A1_MUN)
		oJson["pais"]               := AllTrim(SA1->A1_PAIS)
		oJson["complemento"]        := AllTrim(SA1->A1_COMPLEM)
		oJson["telefone"]           := AllTrim(SA1->A1_TEL)
		oJson["cpfCnpj"]            := AllTrim(SA1->A1_CGC)
		oJson["inscricaoEstadual"]  := AllTrim(SA1->A1_INSCR)
		oJson["inscriçãoMunicipal"] := AllTrim(SA1->A1_INSCRM)
		oJson["email"]              := AllTrim(SA1->A1_EMAIL)
		oJson["enderecoEntrega"]    := AllTrim(SA1->A1_ENDENT)
		oJson["cepEntrega"]         := AllTrim(SA1->A1_CEPE)
		oJson["municipioEntrega"]   := AllTrim(SA1->A1_MUNE)
		oJson["estadoEntrega"]      := AllTrim(SA1->A1_ESTE)
		oJson["complementoEntrega"] := AllTrim(SA1->A1_COMPENT)
		oJson["bairroEntrega"]      := AllTrim(SA1->A1_BAIRROE)
		oJson["enderecoCobranca"]   := AllTrim(SA1->A1_ENDCOB)
		oJson["cepCobranca"]        := AllTrim(SA1->A1_CEPC)
		oJson["municipioCobranca"]  := AllTrim(SA1->A1_MUNC)
		oJson["estadoCobranca"]     := AllTrim(SA1->A1_ESTC)
		oJson["bairroCobranca"]     := AllTrim(SA1->A1_BAIRROC)
		oJson["bloqueado"]          := AllTrim(SA1->A1_MSBLQL)
		oJson["grupoVendas"]        := AllTrim(SA1->A1_GRPVEN)
		oJson["regiao"]             := AllTrim(SA1->A1_REGIAO)
		oJson["contato"]            := AllTrim(SA1->A1_CONTATO)
		oJson["conta"]              := AllTrim(SA1->A1_CONTA)
		oJson["vendedor"]           := AllTrim(SA1->A1_VEND)
		oJson["condicaoPagamento"]  := AllTrim(SA1->A1_COND)
		oJson["nomeVendedor"]       := AllTrim(SA1->A1_XNOMVED)
		oJson["tipoFrete"]          := AllTrim(SA1->A1_TPFRET)
		oJson["transportadora"]     := AllTrim(SA1->A1_TRANSP)
		oJson["prioridade"]         := AllTrim(SA1->A1_PRIOR)
		oJson["risco"]              := AllTrim(SA1->A1_RISCO)
		oJson["limiteCredito"]      := SA1->A1_LC
		oJson["vencimentoCredito"]  := SA1->A1_VENCLC
		oJson["maiorSaldo"]         := SA1->A1_MSALDO
		oJson["maiorCompra"]        := SA1->A1_MCOMPRA
		oJson["mediaAtrasos"]       := SA1->A1_METR
		oJson["primeiraCompra"]     := SA1->A1_PRICOM
		oJson["ultimaCompra"]       := SA1->A1_ULTCOM
		oJson["numeroCompras"]      := SA1->A1_NROCOM
		oJson["classificacaoVendas"]:= AllTrim(SA1->A1_CLASVEN)
		oJson["codigoMensagem"]     := AllTrim(SA1->A1_MENSAGE)
		oJson["saldoTitulos"]       := SA1->A1_SALDUP
		oJson["valorCarteira"]      := SA1->A1_VACUM
		oJson["saldoPedidos"]       := SA1->A1_SALPED
		oJson["tabela"]             := AllTrim(SA1->A1_TABELA)
		oJson["boletoEmail"]        := AllTrim(SA1->A1_BLEMAIL )

		DbSelectArea("AI0")
		AI0->(DbSetOrder(1))

		If AI0->(DbSeek(xFilial("AI0") + SA1->A1_COD + SA1->A1_LOJA))
			oJson["statusCredito"] := AllTrim(AI0->AI0_STATUS)
			oJson["geraPix"]       := AllTrim(AI0->AI0_RECPIX)
			oJson["emailPix"]      := AllTrim(AI0->AI0_EMAPIX)
		EndIf

    Else
        SetRestFault(404, EncodeUTF8("Cliente " + cCGC + " não encontrado, revisar o CPF/CNPJ"))
    EndIf

    FwRestArea(aAreaSA1)
    FwRestArea(aAreaAI0)

Return oJson

/*/{Protheus.doc} afat002A
Função que alimenta o array que será executado no EXECAUTO
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param oJson, object, Objeto com as informações recebidas pelo Sogivendas
@param aDadosExec, array, Array que será preenchido com os dados do objeto
@param aDadosComp, array, Array que será preenchido com os dados do objeto
@param cCodCli, character, Codigo do cliente caso seja uma alteração
@param cLojaCli, character, Loja do cliente caso seja uma alteração
@param nOperation, numeric, Operação realizada
/*/
Static Function afat002A(oJson, aDadosExec, aDadosComp, cCodCli, cLojaCli, nOperation)
	Local cCodMun       := ""
	Local cDescPais     := ""
	Local cNomeVendedor := ""

	Default cCodCli  := ""
	Default cLojaCli := ""

	aAdd(aDadosExec, {"A1_FILIAL" , xFilial("SA1")                                                                                                , Nil})
	aAdd(aDadosExec, {"A1_COD"    , IIF(Empty(cCodCli),GetSXENum("SA1","A1_COD"), cCodCli)                                                        , Nil})
	aAdd(aDadosExec, {"A1_LOJA"   , IIF(Empty(cLojaCli),IIF(oJson["pessoa"] == "F", "0001", SubStr(oJson["cpfCnpj"],9,4)), cLojaCli)              , Nil})
	aAdd(aDadosExec, {"A1_NOME"   , DecodeUTF8(AllTrim(oJson["razaoSocial"]))                                                                     , Nil})
	aAdd(aDadosExec, {"A1_PESSOA" , oJson["pessoa"]                                                                                               , Nil})
	aAdd(aDadosExec, {"A1_NREDUZ" , DecodeUTF8(Iif(Len(AllTrim(oJson["razaoSocial"])) > 20, SubStr(oJson["razaoSocial"],1,20), AllTrim(oJson["razaoSocial"]))), Nil})
	aAdd(aDadosExec, {"A1_END"    , DecodeUTF8(AllTrim(oJson["endereco"]) + ", " + oJson["numero"])                                               , Nil})
	aAdd(aDadosExec, {"A1_BAIRRO" , DecodeUTF8(AllTrim(oJson["bairro"]))                                                                          , Nil})
	aAdd(aDadosExec, {"A1_TIPO"   , oJson["tipo"]                                                                                                 , Nil})
	aAdd(aDadosExec, {"A1_EST"    , oJson["estado"]                                                                                               , Nil})
	aAdd(aDadosExec, {"A1_COD_MUN", cCodMun :=  afat002B(oJson["estado"], oJson["municipio"])                                                     , Nil})
	aAdd(aDadosExec, {"A1_CEP"    , oJson["cep"]                                                                                                  , Nil})
	aAdd(aDadosExec, {"A1_MUN"    , DecodeUTF8(oJson["municipio"])                                                                                , Nil})
	aAdd(aDadosExec, {"A1_TEL"    , oJson["telefone"]                                                                                             , Nil})
	If nOperation <> ALTERA
		aAdd(aDadosExec, {"A1_CGC", oJson["cpfCnpj"]                                                                                              , Nil})
	EndIf
	aAdd(aDadosExec, {"A1_INSCR"  , oJson["inscricao"]                                                                                            , Nil})
	aAdd(aDadosExec, {"A1_INSCRM" , oJson["inscricaoMunicipal"]                                                                                   , Nil})
	aAdd(aDadosExec, {"A1_PAIS"   , cDescPais := afat002C(oJson["pais"])                                                                          , Nil})                                                                                                 
	aAdd(aDadosExec, {"A1_EMAIL"  , oJson["email"]                                                                                                , Nil})
	aAdd(aDadosExec, {"A1_COMPLEM", DecodeUTF8(AllTrim(oJson["complemento"]) + "/" + AllTrim(oJson["pontoReferencia"]))                           , Nil})
	aAdd(aDadosExec, {"A1_ENDENT" , IIF(Empty(oJson["enderecoEntrega"])   ,aDadosExec[7][2] , DecodeUTF8(AllTrim(oJson["enderecoEntrega"])))      , Nil})
	aAdd(aDadosExec, {"A1_CEPE"   , IIF(Empty(oJson["cepEntrega"])        ,oJson["cep"]     , DecodeUTF8(AllTrim(oJson["cepEntrega"])))           , Nil})
	aAdd(aDadosExec, {"A1_MUNE"   , IIF(Empty(oJson["municipioEntrega"])  ,aDadosExec[11][2], DecodeUTF8(AllTrim(oJson["municipioEntrega"])))     , Nil})
	aAdd(aDadosExec, {"A1_ESTE"   , IIF(Empty(oJson["estadoEntrega"])     ,aDadosExec[10][2], DecodeUTF8(AllTrim(oJson["estadoEntrega"])))        , Nil})
	aAdd(aDadosExec, {"A1_COMPENT", DecodeUTF8(IIF(Empty(oJson["complementoEntrega"]),AllTrim(oJson["complemento"]) + "/" + AllTrim(oJson["pontoReferencia"]), AllTrim(oJson["complementoEntrega"]))), Nil})
	aAdd(aDadosExec, {"A1_BAIRROE", IIF(Empty(oJson["bairroEntrega"])     ,aDadosExec[8][2] , DecodeUTF8(AllTrim(oJson["bairroEntrega"])))        , Nil})
	aAdd(aDadosExec, {"A1_ENDCOB" , IIF(Empty(oJson["enderecoCobranca"])  ,aDadosExec[7][2] , DecodeUTF8(AllTrim(oJson["enderecoCobranca"])))     , Nil})
	aAdd(aDadosExec, {"A1_CEPC"   , IIF(Empty(oJson["cepCobranca"])       ,oJson["cep"]     , DecodeUTF8(AllTrim(oJson["cepCobranca"])))          , Nil})
	aAdd(aDadosExec, {"A1_MUNC"   , IIF(Empty(oJson["municipioCobranca"]) ,aDadosExec[11][2], DecodeUTF8(AllTrim(oJson["municipiCobranca"])))     , Nil})
	aAdd(aDadosExec, {"A1_ESTC"   , IIF(Empty(oJson["estadoCobranca"])    ,aDadosExec[10][2], DecodeUTF8(AllTrim(oJson["estadoCobranca"])))       , Nil})
	aAdd(aDadosExec, {"A1_BAIRROC", IIF(Empty(oJson["bairroCobranca"])    ,aDadosExec[8][2] , DecodeUTF8(AllTrim(oJson["bairroCobranca"])))       , Nil})
	If nOperation == INCLUI
		aAdd(aDadosExec, {"A1_MSBLQL" , "1"                                                                                                       , Nil})
	Else
		aAdd(aDadosExec, {"A1_MSBLQL" , oJson["bloqueado"]                                                                                        , Nil})
	EndIf
	aAdd(aDadosExec, {"A1_GRPVEN" , oJson["grupoVendas"]                                                                                          , Nil})
	aAdd(aDadosExec, {"A1_REGIAO" , oJson["regiao"]                                                                                               , Nil})
	aAdd(aDadosExec, {"A1_CONTATO", oJson["contato"]                                                                                              , Nil})
	aAdd(aDadosExec, {"A1_CONTA"  , oJson["conta"]                                                                                                , Nil})
	aAdd(aDadosExec, {"A1_VEND"   , oJson["vendedor"]                                                                                             , Nil})
	aAdd(aDadosExec, {"A1_COND"   , oJson["condicaoPagamento"]                                                                                    , Nil})
	aAdd(aDadosExec, {"A1_XNOMVED", cNomeVendedor := afat002D(oJson["vendedor"])                                                                  , Nil})
	aAdd(aDadosExec, {"A1_TPFRET" , oJson["tipoFrete"]                                                                                            , Nil})
	aAdd(aDadosExec, {"A1_TRANSP" , oJson["transportadora"]                                                                                       , Nil})
	aAdd(aDadosExec, {"A1_PRIOR"  , oJson["prioridade"]                                                                                           , Nil})
	aAdd(aDadosExec, {"A1_RISCO"  , oJson["risco"]                                                                                                , Nil})
	aAdd(aDadosExec, {"A1_LC"     , Val(oJson["limiteCredito"])                                                                                   , Nil})
	aAdd(aDadosExec, {"A1_VENCLC" , STOD(oJson["vencimentoCredito"])                                                                              , Nil})
	aAdd(aDadosExec, {"A1_MSALDO" , Val(oJson["maiorSaldo"])                                                                                      , Nil})
	aAdd(aDadosExec, {"A1_MCOMPRA", Val(oJson["maiorCompra"])                                                                                     , Nil})
	aAdd(aDadosExec, {"A1_METR"   , Val(oJson["mediaAtrasos"])                                                                                    , Nil})
	aAdd(aDadosExec, {"A1_PRICOM" , STOD(oJson["primeiraCompra"])                                                                                 , Nil})
	aAdd(aDadosExec, {"A1_ULTCOM" , STOD(oJson["ultimaCompra"])                                                                                   , Nil})
	aAdd(aDadosExec, {"A1_NROCOM" , Val(oJson["numeroCompras"])                                                                                   , Nil})
	aAdd(aDadosExec, {"A1_CLASVEN", oJson["classificacaoVendas"]                                                                                  , Nil})
	aAdd(aDadosExec, {"A1_MENSAGE", oJson["codigoMensagem"]                                                                                       , Nil})
	aAdd(aDadosExec, {"A1_SALDUP" , Val(oJson["saldoTitulos"])                                                                                    , Nil})
	aAdd(aDadosExec, {"A1_VACUM"  , Val(oJson["valorCarteira"])                                                                                   , Nil})
	aAdd(aDadosExec, {"A1_SALPED" , Val(oJson["saldoPedidos"])                                                                                    , Nil})
	aAdd(aDadosExec, {"A1_TABELA" , oJson["tabela"]                                                                                               , Nil})
	aAdd(aDadosExec, {"A1_BLEMAIL", oJson["boletoEmail"]                                                                                          , Nil})

	aAdd(aDadosComp,{"AI0_FILIAL", xFilial("AI0")        , Nil})
	aAdd(aDadosComp,{"AI0_STATUS", oJson["statusCredito"], Nil})
	aAdd(aDadosComp,{"AI0_RECPIX", oJson["geraPix"]      , Nil})
	aAdd(aDadosComp,{"AI0_EMAPIX", oJson["emailPix"]     , Nil})

Return

/*/{Protheus.doc} afat002B
Função que coleta o codigo do municipio
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param cEstado, character, Estado do cliente
@param cCidade, character, Cidade do cliente
@return variant, cCodMun, Codigo do municipio do cliente
/*/
Static Function afat002B(cEstado, cCidade)
	Local cCodMun  := ""
	Local aAreaCC2 := CC2->(FwGetArea())

	DbSelectArea("CC2")
	CC2->(DbSetOrder(4))

	If CC2->(DbSeek(xFilial("CC2") + Upper(cEstado) + AllTrim(Upper(cCidade))))
		cCodMun := CC2->CC2_CODMUN
	EndIf

	FwRestArea(aAreaCC2)
Return cCodMun

/*/{Protheus.doc} afat002C
Coleta o codigo do pais
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param cPais, character, Pais do cliente
@return variant, cCodPais, Codigo do pais
/*/
Static Function afat002C(cPais)
	Local cCodPais := ""
	Local aAreaSYA := SYA->(FwGetArea())

	DbSelectArea("SYA")
	SYA->(DbSetOrder(2))

	If SYA->(DbSeek(xFilial("SYA") + AllTrim(Upper(cPais))))
		cCodPais := SYA->YA_CODGI
	EndIf
	FwRestArea(aAreaSYA)
Return cCodPais

/*/{Protheus.doc} afat002D
Coleta o nome do vendedor
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param cCodVend, character, Codigo do vendedor
@return variant, cNomeVendedor, Nome do vendedor
/*/
Static Function afat002D(cCodVend)
	Local cNomeVendedor := ""
	Local aAreaSA3      := SA3->(FwGetArea())

	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))

	If SA3->(DbSeek(xFilial("SA3") + cCodVend))
		cNomeVendedor := SA3->A3_NOME
	EndIf

	FwRestArea(aAreaSA3)
Return cNomeVendedor

/*/{Protheus.doc} afat002F
Responsável por gerar a mensagem de retorno
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param cCodCliente, character, Codigo do cliente
@param nOperation, numeric, Operação realizada
@return variant, oJsonRet, Json com a mensagem
/*/
Static Function afat002F(cCodCliente, nOperation)
    Local oJsonRet := NIL
    Local cMsg     := ""

    Do Case
    Case nOperation == INCLUI
        cMsg := "Cliente cadastrado com sucesso."
    Case nOperation == ALTERA
        cMsg := "Cliente atualizado com sucesso."
    Otherwise
        cMsg := "Cliente deletado com sucesso."
    EndCase

    oJsonRet := JsonObject():New()

    oJsonRet["codigo"]   := cCodCliente
    oJsonRet["mensagem"] := cMsg

Return oJsonRet
