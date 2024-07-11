#INCLUDE "PROTHEUS.ch"
#INCLUDE "FWMVCDEF.ch"
#INCLUDE "RESTFUL.ch"

#DEFINE INCLUI 3
#DEFINE ALTERA 4
#DEFINE DELETA 5

/*/{Protheus.doc} Cliente
WebService para manipulação de Cliente no Protheus
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSRESTFUL Cliente DESCRIPTION "Serviço para cadastro e manutenção de Clientes" FORMAT APPLICATION_JSON

    WSDATA cgc as string Optional

    WSMETHOD POST;
        DESCRIPTION "Cadastra cliente"; 
        WSSYNTAX "/api/faturamento/v2/cliente"; 
        PATH "/api/faturamento/v2/cliente";
        TTALK "v1";
        PRODUCES APPLICATION_JSON
    WSMETHOD PUT;
        DESCRIPTION "Atualiza cliente"; 
        WSSYNTAX "/api/faturamento/v2/cliente/{cgc}"; 
        PATH "/api/faturamento/v2/cliente/{cgc}";
        TTALK "v1";
        PRODUCES APPLICATION_JSON
    WSMETHOD DELETE;
        DESCRIPTION "Deleta cliente"; 
        WSSYNTAX "/api/faturamento/v2/cliente/{cgc}"; 
        PATH "/api/faturamento/v2/cliente/{cgc}";
        TTALK "v1";
        PRODUCES APPLICATION_JSON
    WSMETHOD GET;
        DESCRIPTION "Consulta cliente"; 
        WSSYNTAX "/api/faturamento/v2/cliente?cgc={cgc}"; 
        PATH "/api/faturamento/v2/cliente";
        TTALK "v1";
        PRODUCES APPLICATION_JSON

End WSRESTFUL

/*/{Protheus.doc} POST - Cliente
Metodo POST para inclusão de Cliente
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSMETHOD POST WSSERVICE CLIENTE
    Local cErro    as char
    Local oJson    as object
    Local oJsonRet as object

    Self:SetContentType("application/json")

    oJson := JsonObject():New()
    cErro := oJson:fromJson(Self:GetContent())

    If Empty(cErro)
        If u_afat002(oJson, @oJsonRet, INCLUI)
            ::SetResponse(EncodeUTF8(oJsonRet:ToJson()))
        EndIf
    Else
        ConErr(cErro)
        SetRestFault(400)
    EndIf

    FreeObj(oJson)
    FreeObj(oJsonRet)

Return

/*/{Protheus.doc} PUT - Cliente
Metodo PUT para atualizar os dados de um Cliente
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSMETHOD PUT WSSERVICE CLIENTE
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
            If u_afat002G(oJson, @oJsonRet, cCGC, ALTERA)
                ::SetResponse(EncodeUTF8(oJsonRet:ToJson()))
            EndIf
        Else
            ConErr(cErro)
            SetRestFault(400)
        EndIf
    Else
        SetRestFault(400, EncodeUTF8("Codigo do Cliente não informado"))
    EndIf

    FreeObj(oJson)
    FreeObj(oJsonRet)
Return

/*/{Protheus.doc} DELETE - Cliente
Metodo DELETE para excluir um Cliente do protheus
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSMETHOD DELETE WSSERVICE CLIENTE
    Local cCGC     as char
    Local oJsonRet as object

    Self:SetContentType("application/json")

    cCGC := IIF(Len(::aUrlParms) > 0, ::aUrlParms[1], "")

    If !Empty(cCGC)
        If u_afat002H(@oJsonRet, cCGC, DELETA)
            ::SetResponse(EncodeUTF8(oJsonRet:ToJson()))
        EndIf
    Else
        SetRestFault(400, EncodeUTF8("Codigo do Cliente não informado"))
    EndIf

    FreeObj(oJsonRet)
Return

/*/{Protheus.doc} GET - Cliente
Metodo GET para consulta dos dados de um Cliente
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSMETHOD GET QUERYPARAM cgc WSSERVICE CLIENTE
    Local cCGC  as char
    Local oJson as object

    Self:SetContentType("application/json")

    cCGC := AllTrim(::cgc)

    If !Empty(cCGC)
        If (Len(cCGC) >= 11 .AND. Len(cCGC) <= 14)
            oJson := u_afat002I(cCGC)

            If oJson == NIL
                SetRestFault(404, EncodeUTF8("Cliente não encontrado"))
                Return .F.
            EndIf

            cResponse := oJson:ToJson()
            Self:SetContentType("application/json")
            Self:SetResponse(EncodeUTF8(cResponse))
        Else
            SetRestFault(400, EncodeUTF8("CPF/CNPJ informado incorretamente"))
        EndIf
    Else
        SetRestFault(400, EncodeUTF8("CPF/CNPJ do Cliente não informado"))
    EndIf

    FreeObj(oJson)
Return
