#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.ch"
#INCLUDE "RESTFUL.ch"

#DEFINE INCLUI 3
#DEFINE ALTERA 4

/*/{Protheus.doc} Orçamento
WebService para manipulação de Orçamento no Protheus
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSRESTFUL Orcamento DESCRIPTION "Serviço para cadastro e manutenção de Orçamentos" FORMAT APPLICATION_JSON

    WSDATA codigoOrcamento as string Optional

    WSMETHOD POST;
        DESCRIPTION "Cadastra orçamento"; 
        WSSYNTAX "/api/faturamento/v2/orcamento"; 
        PATH "/api/faturamento/v2/orcamento";
        TTALK "v1";
        PRODUCES APPLICATION_JSON
    WSMETHOD PUT;
        DESCRIPTION "Atualiza orçamento"; 
        WSSYNTAX "/api/faturamento/v2/orcamento/{codigoOrcamento}"; 
        PATH "/api/faturamento/v2/orcamento/{codigoOrcamento}";
        TTALK "v1";
        PRODUCES APPLICATION_JSON

End WSRESTFUL

/*/{Protheus.doc} POST - Orçamento
Metodo POST para inclusão de Orçamento
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSMETHOD POST WSSERVICE ORCAMENTO
    Local cErro    as char
    Local oJson    as object
    Local oJsonRet as object

    Self:SetContentType("application/json")

    oJson := JsonObject():New()
    cErro := oJson:fromJson(Self:GetContent())

    If Empty(cErro)
        If u_afat003(oJson, @oJsonRet, INCLUI)
            ::SetResponse(EncodeUTF8(oJsonRet:ToJson()))
        EndIf
    Else
        SetRestFault( 400, "Parser Json com erro")
    EndIf

    FreeObj(oJson)
    FreeObj(oJsonRet)

Return

/*/{Protheus.doc} PUT - Orçamento
Metodo PUT para atualizar os dados de um orçamento
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSMETHOD PUT WSSERVICE ORCAMENTO
    Local cErro    as char
    Local cCodigoOrcamento     as char
    Local oJson    as object
    Local oJsonRet as object

    Self:SetContentType("application/json")

    cCodigoOrcamento := IIF(Len(::aUrlParms) > 0, ::aUrlParms[1], "")

    If !Empty(cCodigoOrcamento)
        oJson := JsonObject():New()
        cErro := oJson:fromJson(Self:GetContent())

        If Empty(cErro)
            If u_afat003A(oJson, @oJsonRet, cCodigoOrcamento, ALTERA)
                ::SetResponse(EncodeUTF8(oJsonRet:ToJson()))
            EndIf
        Else
            SetRestFault( 400, "Parser Json com erro")
        EndIf
    Else
        SetRestFault(400, EncodeUTF8("Codigo do orçamento não informado"))
    EndIf

    FreeObj(oJson)
    FreeObj(oJsonRet)
Return
