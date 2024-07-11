#INCLUDE "PROTHEUS.ch"
#INCLUDE "FWMVCDEF.ch"
#INCLUDE "RESTFUL.ch"

#DEFINE INCLUI 3
#DEFINE ALTERA 4
#DEFINE DELETA 5

/*/{Protheus.doc} PROSPECT
WebService para manipulação de Prospects no Protheus
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSRESTFUL Prospect DESCRIPTION "Serviço para cadastro e manutenção de Prospects" FORMAT APPLICATION_JSON

    WSDATA cgc as string Optional

    WSMETHOD POST;
        DESCRIPTION "Cadastra Prospect"; 
        WSSYNTAX "/api/faturamento/v2/prospect"; 
        PATH "/api/faturamento/v2/prospect";
        TTALK "v1";
        PRODUCES APPLICATION_JSON
    WSMETHOD PUT;
        DESCRIPTION "Atualiza Prospect"; 
        WSSYNTAX "/api/faturamento/v2/prospect/{cgc}"; 
        PATH "/api/faturamento/v2/prospect/{cgc}";
        TTALK "v1";
        PRODUCES APPLICATION_JSON
    WSMETHOD DELETE;
        DESCRIPTION "Deleta Prospect"; 
        WSSYNTAX "/api/faturamento/v2/prospect/{cgc}"; 
        PATH "/api/faturamento/v2/prospect/{cgc}";
        TTALK "v1";
        PRODUCES APPLICATION_JSON
    WSMETHOD GET;
        DESCRIPTION "Consulta Prospect"; 
        WSSYNTAX "/api/faturamento/v2/prospect?cgc={cgc}"; 
        PATH "/api/faturamento/v2/prospect";
        TTALK "v1";
        PRODUCES APPLICATION_JSON

End WSRESTFUL

/*/{Protheus.doc} POST - PROSPECT
Metodo POST para inclusão de Prospects
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSMETHOD POST WSSERVICE PROSPECT
    Local cErro    as char
    Local oJson    as object
    Local oJsonRet as object

    Self:SetContentType("application/json")

    oJson := JsonObject():New()
    cErro := oJson:fromJson(Self:GetContent())

    If Empty(cErro)
        If u_afat001(oJson, @oJsonRet, INCLUI)
            ::SetResponse(EncodeUTF8(oJsonRet:ToJson()))
        EndIf
    Else
        ConErr(cErro)
        SetRestFault(400)
    EndIf

    FreeObj(oJson)
    FreeObj(oJsonRet)

Return

/*/{Protheus.doc} PUT - PROSPECT
Metodo PUT para atualizar os dados de um prospect
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSMETHOD PUT WSSERVICE PROSPECT
    Local cErro    as char
    Local cCGC     as char
    Local oJson    as object
    Local oJsonRet as object

    Self:SetContentType("application/json")

    cCGC := IIF(Len(::aUrlParms) > 0, ::aUrlParms[1], "")

    If !Empty(cCGC)
        oJson := JsonObject():New()
        cErro := oJson:fromJson(Self:GetContent())

        If Empty(cErro)
            If u_afat001A(oJson, @oJsonRet, cCGC, ALTERA)
                ::SetResponse(EncodeUTF8(oJsonRet:ToJson()))
            EndIf
        Else
            ConErr(cErro)
            SetRestFault(400)
        EndIf
    Else
        SetRestFault(400, EncodeUTF8("Codigo do Prospect não informado"))
    EndIf

    FreeObj(oJson)
    FreeObj(oJsonRet)
Return

/*/{Protheus.doc} DELETE - PROSPECT
Metodo DELETE para excluir um prospect do protheus
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSMETHOD DELETE WSSERVICE PROSPECT
    Local cCGC     as char
    Local oJsonRet as object

    Self:SetContentType("application/json")

    cCGC := IIF(Len(::aUrlParms) > 0, ::aUrlParms[1], "")

    If !Empty(cCGC)
        If u_afat001B(@oJsonRet, cCGC, DELETA)
            ::SetResponse(EncodeUTF8(oJsonRet:ToJson()))
        EndIf
    Else
        SetRestFault(400, EncodeUTF8("Codigo do Prospect não informado"))
    EndIf

    FreeObj(oJsonRet)
Return

/*/{Protheus.doc} GET - PROSPECT
Metodo GET para consulta dos dados de um prospect
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSMETHOD GET QUERYPARAM cgc WSSERVICE PROSPECT
    Local cCGC  as char
    Local oJson as object

    Self:SetContentType("application/json")

    cCGC := AllTrim(::cgc)

    If !Empty(cCGC)
        oJson := u_afat001C(cCGC)

        If oJson == NIL
            SetRestFault(400, EncodeUTF8("Prospect não encontrado"))
            Return .F.
        EndIf

        cResponse := oJson:ToJson()
        Self:SetContentType("application/json")
        Self:SetResponse(EncodeUTF8(cResponse))
    Else
        SetRestFault(400, EncodeUTF8("Codigo do Prospect não informado"))
    EndIf

    FreeObj(oJson)
Return
