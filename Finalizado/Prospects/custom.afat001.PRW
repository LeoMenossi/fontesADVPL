#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

#DEFINE INCLUI 3
#DEFINE ALTERA 4
#DEFINE DELETA 5

/*/{Protheus.doc} afat001
Função responsável pela inclusão de Prospects no Protheus
@type Function
@version 12.1.2310 
@author leonardo.JAVBCode
@since 7/4/2024
@param oJson, object, Objeto com as informações recebidas pelo Sogivendas
@param oJsonRet, object, Objeto com retorno
@param nOperation, numeric, Operação realizada
@return variant, lRet, Variavel lógica de controle
/*/
User Function afat001(oJson, oJsonRet, nOperation)

    Local cLog       := ""
    Local cPasta     := GetNewPar("MV_PASTA", "\cfglog\")
    Local cArquivo   := "log_inclui_prospect" + DTOS(dDataBase) + ".txt"
    Local aDadosExec := {}
    Local aErros     := {}
    Local nI         := 0
    Local lRet       := .F.

    Private lMsErroAuto    := .F.
    Private lAutoErrNoFile := .T.
    Private lMsHelpAuto    := .T.

    Begin Transaction

    afat001D(oJson, @aDadosExec, , , nOperation)

    DbSelectArea("SUS")
    SUS->(DbSetOrder(4))
    If SUS->(!DbSeek(xFilial("SUS") + AllTrim(oJson["cpfCnpj"])))
        MsExecAuto({|x,y| TMKA260(x,y)}, aDadosExec, nOperation) //3- Inclusão, 4- Alteração, 5- Exclusão
        If lMsErroAuto
            aErros := GetAutoGRLog()

            For nI := 1 To Len(aErros)
                cLog += aErros[nI] + CRLF
            Next nI

            SetRestFault(400, EncodeUTF8("Erro na gravação. Mais detalhes no arquivo de log"))
            RollBackSX8()
            DisarmTransaction()
        Else
            oJsonRet := afat001E(aDadosExec[2][2], nOperation)
            lRet := .T.
            ConfirmSX8()
        EndIf
    Else
        SetRestFault(400, EncodeUTF8("Prospect " + AllTrim(oJson["cpfCnpj"]) + " já cadastrado"))
        DisarmTransaction()
    EndIf

    End Transaction 

    If !Empty(cLog)
		MemoWrite(cPasta + cArquivo, cLog)
	EndIf

Return lRet

/*/{Protheus.doc} afat001A
Função responsável pela alteração de prospect no Protheus
@type Function
@version 12.1.2310 
@author leonardo.JAVBCode
@since 7/4/2024
@param oJson, object, Objeto com as informações recebidas pelo Sogivendas
@param oJsonRet, object, Objeto com retorno
@param cCGC, character, CPF/CNPJ do prospect
@param nOperation, numeric, Operação realizada
@return variant, lRet, Variavel lógica de controle
/*/
User Function afat001A(oJson, oJsonRet, cCGC, nOperation)

    Local cLog       := ""
    Local cCodPros   := ""
    Local cLojaPros  := ""
    Local cPasta     := GetNewPar("MV_PASTA", "\cfglog\")
    Local cArquivo   := "log_altera_prospect" + DTOS(dDataBase) + ".txt"
    Local aAreaSUS   := SUS->(FwGetArea())
    Local aDadosExec := {}
    Local aErros     := {}
    Local nI         := 0
    Local lRet       := .F.

    Private lMsErroAuto := .F.
    Private lAutoErrNoFile := .T.
    Private lMsHelpAuto :=.T.

    Begin Transaction

    DbSelectArea("SUS")
    SUS->(DbSetOrder(4))
    If SUS->(DbSeek(xFilial("SUS") + AllTrim(cCGC)))

        cCodPros  := PadR(SUS->US_COD, FwSX3Util():GetFieldStruct("US_COD")[3])
        cLojaPros := PadR(SUS->US_LOJA, FwSX3Util():GetFieldStruct("US_LOJA")[3])

        afat001D(oJson, @aDadosExec, cCodPros, cLojaPros, nOperation)

        MsExecAuto({|x,y| TMKA260(x,y)}, aDadosExec, nOperation) //3- Inclusão, 4- Alteração, 5- Exclusão
        If lMsErroAuto
            aErros := GetAutoGRLog()

            For nI := 1 To Len(aErros)
                cLog += aErros[nI] + " "
            Next nI

            SetRestFault(400, EncodeUTF8(cLog))
            DisarmTransaction()
        Else
            oJsonRet := afat001E(cCodPros, nOperation)
            lRet := .T.
        EndIf
    Else
        SetRestFault(400, EncodeUTF8("Prospect " + cCGC + " não encontrado, revisar o CPF/CNPJ"))
        DisarmTransaction()
    EndIf

    End Transaction 

    MemoWrite(cPasta + cArquivo, cLog)
    FwRestArea(aAreaSUS)

Return lRet

/*/{Protheus.doc} afat001B
Função responsável pela exclusão de prospect no Protheus
@type Function
@version 12.1.2310 
@author leonardo.JAVBCode
@since 7/4/2024
@param cCGC, character, CPF/CNPJ do prospect
@param oJsonRet, object, Objeto com retorno
@param nOperation, numeric, Operação realizada
@return variant, lRet, Variavel lógica de controle
/*/
User Function afat001B(oJsonRet, cCGC, nOperation)

    Local cLog       := ""
    Local cPasta     := GetNewPar("MV_PASTA", "\cfglog\")
    Local cArquivo   := "log_deleta_prospect" + DTOS(dDataBase) + ".txt"
    Local aAreaSUS   := SUS->(FwGetArea())
    Local aDadosExec := {}
    Local aErros     := {}
    Local nI         := 0
    Local lRet       := .F.

    Private lMsErroAuto := .F.
    Private lAutoErrNoFile := .T.
    Private lMsHelpAuto :=.T.

    Begin Transaction

    DbSelectArea("SUS")
    SUS->(DbSetOrder(4))
    If SUS->(DbSeek(xFilial("SUS") + AllTrim(cCGC)))
        aDadosExec := afat001F(cCGC)
        If !Empty(aDadosExec)
            MsExecAuto({|x,y| TMKA260(x,y)}, aDadosExec, nOperation) //3- Inclusão, 4- Alteração, 5- Exclusão
            If lMsErroAuto
                aErros := GetAutoGRLog()

                For nI := 1 To Len(aErros)
                    cLog += aErros[nI] + CRLF
                Next nI
            Else
                oJsonRet := afat001E(cCGC, nOperation)
                lRet := .T.
            EndIf
        EndIf
    Else
        SetRestFault(400, EncodeUTF8("Prospect " + cCGC + " não encontrado, revisar o CPF/CNPJ"))
        DisarmTransaction()
    EndIf

    For nI := 1 To Len(aErros)
        cLog += aErros[nI] + CRLF
    Next nI

    End Transaction 

    MemoWrite(cPasta + cArquivo, cLog)
    FwRestArea(aAreaSUS)

Return lRet

/*/{Protheus.doc} afat001C
Função responsável pela consulta de prospect no Protheus
@type Function
@version 12.1.2310 
@author leonardo.JAVBCode
@since 7/4/2024
@param cCGC, character, CPF/CNPJ do prospect
@return variant, oJson, Objeto com o retorno da consulta
/*/
User Function afat001C(cCGC)

    Local aAreaSUS := SUS->(FwGetArea())
    Local oJson    := NIL

    DbSelectArea("SUS")
    SUS->(DbSetOrder(4))
    If SUS->(DbSeek(xFilial("SUS") + AllTrim(cCGC)))
        oJson := JsonObject():New()

        oJson["filial"]        := AllTrim(SUS->US_FILIAL)
        oJson["codigo"]        := AllTrim(SUS->US_COD)
        oJson["loja"]          := AllTrim(SUS->US_LOJA)
        oJson["razaoSocial"]   := AllTrim(SUS->US_NOME)
        oJson["nomeFantasia"]  := AllTrim(SUS->US_NREDUZ)
        oJson["tipo"]          := AllTrim(SUS->US_TIPO)
        oJson["pessoa"]        := AllTrim(SUS->US_PESSOA)
        oJson["cpfCnpj"]       := AllTrim(SUS->US_CGC)
        oJson["endereco"]      := AllTrim(SUS->US_END)
        oJson["bairro"]        := AllTrim(SUS->US_BAIRRO)
        oJson["cep"]           := AllTrim(SUS->US_CEP)
        oJson["estado"]        := AllTrim(SUS->US_EST)
        oJson["codMunicipal"]  := AllTrim(SUS->US_COD_MUN)
        oJson["regiao"]        := AllTrim(SUS->US_REGIAO)
        oJson["ddd"]           := AllTrim(SUS->US_DDD)
        oJson["telefone"]      := AllTrim(SUS->US_TEL)
        oJson["email"]         := AllTrim(SUS->US_EMAIL)
        oJson["inscrEstadual"] := AllTrim(SUS->US_INSCR)
        oJson["contribICMS"]   := AllTrim(SUS->US_CONTRIB)
        oJson["grupoTrib"]     := AllTrim(SUS->US_GRPTRIB)
        oJson["pais"]          := AllTrim(SUS->US_PAIS)
        oJson["natureza"]      := AllTrim(SUS->US_NATUREZ)
        oJson["vendedor"]      := AllTrim(SUS->US_VEND)
        oJson["limiteCredito"] := cValToChar(SUS->US_LC)
        oJson["vencLimite"]    := DTOS(SUS->US_VENCLC)
        oJson["observacao"]    := AllTrim(SUS->US_OBS)
        oJson["bloqueado"]     := AllTrim(SUS->US_MSBLQL)

    Else
        SetRestFault(400, EncodeUTF8("Prospect " + cCGC + " não encontrado, revisar o CPF/CNPJ"))
    EndIf

    FwRestArea(aAreaSUS)

Return oJson

/*/{Protheus.doc} afat001D
Função que alimenta o array que será executado no EXECAUTO
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param oJson, object, Objeto com as informações recebidas pelo Sogivendas
@param aDadosExec, array, Array que será preenchido com os dados do objeto
@param cCodPros, character, Codigo do prospect caso seja uma alteração
@param cLojaPros, character, Loja do prospect caso seja uma alteração
@param nOperation, numeric, Operação realizada
/*/
Static Function afat001D(oJson, aDadosExec, cCodPros, cLojaPros, nOperation)
    Local cCodMun   := ""
    Local cDescPais := ""

    Default cCodPros  := ""
    Default cLojaPros := ""

    aAdd(aDadosExec, {"US_FILIAL" ,xFilial("SUS")                                                , NIL})
    aAdd(aDadosExec, {"US_COD"    ,IIF(Empty(cCodPros),GetSXENum("SUS","US_COD"), cCodPros)      , NIL})
    aAdd(aDadosExec, {"US_LOJA"   ,IIF(Empty(cLojaPros), oJson["loja"], cLojaPros)               , NIL})
    aAdd(aDadosExec, {"US_NOME"   ,DecodeUTF8(oJson["razaoSocial"])                              , NIL})
    aAdd(aDadosExec, {"US_NREDUZ" ,DecodeUTF8(Iif(Len(AllTrim(oJson["nomeFantasia"])) > 20, SubStr(oJson["nomeFantasia"],1,20), AllTrim(oJson["nomeFantasia"]))), NIL})
    aAdd(aDadosExec, {"US_TIPO"   ,oJson["tipo"]                                                 , NIL})
    aAdd(aDadosExec, {"US_PESSOA" ,oJson["pessoa"]                                               , NIL})
    If nOperation <> ALTERA
        aAdd(aDadosExec, {"US_CGC"    ,oJson["cpfCnpj"]                                          , NIL})
    EndIf
    aAdd(aDadosExec, {"US_END"    ,DecodeUTF8(oJson["endereco"])                                 , NIL})
    aAdd(aDadosExec, {"US_BAIRRO" ,DecodeUTF8(oJson["bairro"])                                   , NIL})
    aAdd(aDadosExec, {"US_CEP"    ,oJson["cep"]                                                  , NIL})
    aAdd(aDadosExec, {"US_EST"    ,oJson["estado"]                                               , NIL})
    aAdd(aDadosExec, {"US_MUN"    ,DecodeUTF8(oJson["municipio"])                                , NIL})
    aAdd(aDadosExec, {"US_COD_MUN",cCodMun := afat001G(oJson["estado"],oJson["municipio"])       , NIL})
    aAdd(aDadosExec, {"US_REGIAO" ,oJson["regiao"]                                               , NIL})
    aAdd(aDadosExec, {"US_DDD"    ,oJson["ddd"]                                                  , NIL})
    aAdd(aDadosExec, {"US_TEL"    ,oJson["telefone"]                                             , NIL})
    aAdd(aDadosExec, {"US_EMAIL"  ,oJson["email"]                                                , NIL})
    aAdd(aDadosExec, {"US_INSCR"  ,oJson["inscricao"]                                            , NIL})
    aAdd(aDadosExec, {"US_CONTRIB",oJson["contribuicaoICMS"]                                     , NIL})
    aAdd(aDadosExec, {"US_GRPTRIB",oJson["grupoTributacao"]                                      , NIL})
    aAdd(aDadosExec, {"US_PAIS"   ,cDescPais := afat001H(oJson["pais"])                          , NIL})
    aAdd(aDadosExec, {"US_NATUREZ",oJson["natureza"]                                             , NIL})
    aAdd(aDadosExec, {"US_VEND"   ,oJson["vendedor"]                                             , NIL})
    aAdd(aDadosExec, {"US_LC"     ,Val(oJson["limiteCredito"])                                   , NIL})
    aAdd(aDadosExec, {"US_VENCLC" ,STOD(oJson["vencimentoCredito"]), NIL})
    aAdd(aDadosExec, {"US_OBS"    ,oJson["observacao"]                                           , NIL})
    If nOperation == INCLUI
        aAdd(aDadosExec, {"US_MSBLQL" ,"1"                                                       , NIL})
    Else
        aAdd(aDadosExec, {"US_MSBLQL" ,oJson["bloqueado"]                                        , NIL})
    EndIf
Return

/*/{Protheus.doc} afat001E
Responsável por gerar a mensagem de retorno
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param cIdProspect, character, Codigo do prospect
@param nOperation, numeric, Operação realizada
@return variant, oJsonRet, Json com a mensagem
/*/
Static Function afat001E(cIdProspect, nOperation)
    Local oJsonRet := NIL
    Local cMsg     := ""

    Do Case
    Case nOperation == INCLUI
        cMsg := "Prospect cadastrado com sucesso."
    Case nOperation == ALTERA
        cMsg := "Prospect atualizado com sucesso."
    Otherwise
        cMsg := "Prospect deletado com sucesso."
    EndCase

    oJsonRet := JsonObject():New()

    oJsonRet["codigo"]   := cIdProspect
    oJsonRet["mensagem"] := cMsg

Return oJsonRet

/*/{Protheus.doc} afat001F
Função que coleta as informações para a exclusão
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param cCGC, character, CPF/CNPJ do prospect
@return variant, aCampos, campos para serem posicionados na exclusão
/*/
Static Function afat001F(cCGC)
    Local aCampos := {}
    Local aAreaSUS := SUS->(FwGetArea())

    DbSelectArea("SUS")
    SUS->(DbSetOrder(4))
    If SUS->(DbSeek(xFilial("SUS") + AllTrim(cCGC)))
        aAdd(aCampos, {"US_FILIAL" , xFilial("SUS") , NIL})
        aAdd(aCampos, {"US_COD"    , SUS->US_COD    , NIL})
        aAdd(aCampos, {"US_LOJA"   , SUS->US_LOJA   , NIL})
    Else
        SetRestFault(400, EncodeUTF8("Prospect " + cCGC + " não encontrado, revisar o CPF/CNPJ"))
    EndIF

    FwRestArea(aAreaSUS)
Return aCampos

/*/{Protheus.doc} afat001G
Função que coleta o codigo do municipio
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param cEstado, character, Estado do prospect
@param cCidade, character, Cidade do prospect
@return variant, cCodMun, Codigo do municipio do prospect
/*/
Static Function afat001G(cEstado, cCidade)
	Local cCodMun  := ""
	Local aAreaCC2 := CC2->(FwGetArea())

	DbSelectArea("CC2")
	CC2->(DbSetOrder(4))

	If CC2->(DbSeek(xFilial("CC2") + Upper(cEstado) + AllTrim(Upper(cCidade))))
		cCodMun := CC2->CC2_CODMUN
	EndIf

	FwRestArea(aAreaCC2)
Return cCodMun

/*/{Protheus.doc} afat001H
Coleta o codigo do pais
@type Function
@version  12.1.2310
@author leonardo.JAVBCode
@since 7/4/2024
@param cPais, character, Pais do prospect
@return variant, cCodPais, Codigo do pais
/*/
Static Function afat001H(cPais)
	Local cCodPais := ""
	Local aAreaSYA := SYA->(FwGetArea())

	DbSelectArea("SYA")
	SYA->(DbSetOrder(2))

	If SYA->(DbSeek(xFilial("SYA") + AllTrim(Upper(cPais))))
		cCodPais := SYA->YA_CODGI
	EndIf

	FwRestArea(aAreaSYA)
Return cCodPais
