#INCLUDE "PROTHEUS.ch"
#INCLUDE "FWMVCDEF.ch"
#INCLUDE "RESTFUL.ch"

#DEFINE INCLUI 3
#DEFINE ALTERA 4

WSRESTFUL condicaoPagamento DESCRIPTION "Serviço para cadastro e manutenção de condições de pagamento" FORMAT APPLICATION_JSON

    WSDATA codigoCondicao as string Optional

    WSMETHOD POST;
        DESCRIPTION "Cadastra condição de pagamento"; 
        WSSYNTAX "/api/faturamento/v2/condicaoPagamento"; 
        PATH "/api/faturamento/v2/condicaoPagamento";
        TTALK "v1";
        PRODUCES APPLICATION_JSON
    WSMETHOD PUT;
        DESCRIPTION "Atualiza condição de pagamento"; 
        WSSYNTAX "/api/faturamento/v2/condicaoPagamento/{codigoCondicao}"; 
        PATH "/api/faturamento/v2/condicaoPagamento/{codigoOrcamento}";
        TTALK "v1";
        PRODUCES APPLICATION_JSON

End WSRESTFUL


WSMETHOD POST WSSERVICE CONDICAOPAGAMENTO
    Local cErro    as char
    Local oJson    as object
    Local oJsonRet as object

    Self:SetContentType("application/json")

    oJson := JsonObject():New()
    cErro := oJson:fromJson(Self:GetContent())

    If Empty(cErro)
        If u_afat005(oJson, @oJsonRet, INCLUI)
            ::SetResponse(EncodeUTF8(oJsonRet:ToJson()))
        EndIf
    Else
        SetRestFault( 400, "Parser Json com erro")
    EndIf

    FreeObj(oJson)
    FreeObj(oJsonRet)

Return


WSMETHOD PUT WSSERVICE CONDICAOPAGAMENTO
    Local cErro            as char
    Local cCodigoCondicao as char
    Local oJson            as object
    Local oJsonRet         as object

    Self:SetContentType("application/json")

    cCodigoCondicao := IIF(Len(::aUrlParms) > 0, ::aUrlParms[1], "")

    If !Empty(cCodigoCondicao)
        oJson := JsonObject():New()
        cErro := oJson:fromJson(Self:GetContent())

        If Empty(cErro)
            If u_afat005A(oJson, @oJsonRet, AllTrim(cCodigoCondicao), ALTERA)
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
