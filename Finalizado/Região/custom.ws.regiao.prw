#INCLUDE "PROTHEUS.ch"
#INCLUDE "FWMVCDEF.ch"
#INCLUDE "RESTFUL.ch"

/*/{Protheus.doc} REGIAO
WebService para manipula��o das regi�es no Protheus
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 20/06/2024
/*/
WSRESTFUL Regiao DESCRIPTION "Servi�o para manipula��o da Regi�o" FORMAT APPLICATION_JSON

    WSMETHOD POST;
        DESCRIPTION "Cadastra regi�o";                 
        WSSYNTAX "/api/estrutura/genericas/v2/regiao"; 
        PATH "/api/estrutura/genericas/v2/regiao" ;
        TTALK "v1";
        PRODUCES APPLICATION_JSON
    WSMETHOD PUT;
        DESCRIPTION "Atualiza regi�o";
        WSSYNTAX "/api/estrutura/genericas/v2/regiao"; 
        PATH "/api/estrutura/genericas/v2/regiao" ;
        TTALK "v1";
        PRODUCES APPLICATION_JSON               
    WSMETHOD GET;
        DESCRIPTION "Consulta as regi�es cadastradas" ;
        WSSYNTAX "/api/estrutura/genericas/v2/regiao"; 
        PATH "/api/estrutura/genericas/v2/regiao" ;
        TTALK "v1";
        PRODUCES APPLICATION_JSON

End WSRESTFUL

/*/{Protheus.doc} POST - REGIAO
Metodo POST para inclus�o de regi�o
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 20/06/2024
/*/
WSMETHOD POST WSSERVICE REGIAO
    Local cErro    as char
    Local oJson    as object
    Local oJsonRet as object

    Self:SetContentType("application/json")

    oJson := JsonObject():New()
    cErro := oJson:fromJson(Self:GetContent())

    If Empty(cErro)
        If u_aesp001(oJson, @oJsonRet)
            ::SetResponse(EncodeUTF8(oJsonRet:ToJson()))
        EndIf
    Else
        ConErr(cErro)
        SetRestFault(400)
    EndIf

    FreeObj(oJson)
    FreeObj(oJsonRet)

Return

/*/{Protheus.doc} PUT - REGIAO
Metodo PUT para alterar a regi�o
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 20/06/2024
/*/
WSMETHOD PUT WSSERVICE REGIAO
    Local cErro    as char
    Local oJson    as object
    Local oJsonRet as object

    Self:SetContentType("application/json")

    oJson := JsonObject():New()
    cErro := oJson:fromJson(Self:getContent())

    If Empty(cErro)
        If u_aesp001A(oJson, @oJsonRet)
            ::SetResponse(EncodeUTF8(oJsonRet:ToJson()))
        EndIf
    Else
        ConErr(cErro)
        SetRestFault(400)
    EndIf

    FreeObj(oJson)
    FreeObj(oJsonRet)

Return

/*/{Protheus.doc} GET - REGIAO
Metodo GET para consultar as regi�es cadastradas
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 20/06/2024
/*/
WSMETHOD GET WSSERVICE REGIAO
    Local cResponse as char
    Local oJson     as object

    oJson := u_aesp001B()

    If oJson == NIL
        SetRestFault(400, EncodeUTF8("Regi�o n�o encontrada"))
        Return .F.
    EndIf

    cResponse := oJson:ToJson()
    Self:SetContentType("application/json")
    Self:SetResponse(EncodeUTF8(cResponse))

    FreeObj(oJson)

Return


