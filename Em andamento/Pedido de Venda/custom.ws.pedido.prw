#INCLUDE "PROTHEUS.ch"
#INCLUDE "FWMVCDEF.ch"
#INCLUDE "RESTFUL.ch"

/*/{Protheus.doc} Pedido
WebService para manipulação de residuos de pedidos no Protheus
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSRESTFUL Pedido DESCRIPTION "Serviço para Limpeza de residuos" FORMAT APPLICATION_JSON

    WSDATA pedido as string Optional

    WSMETHOD PUT;
        DESCRIPTION "Elimina residuos do pedido"; 
        WSSYNTAX "/api/faturamento/v2/pedido/{pedido}"; 
        PATH "/api/faturamento/v2/pedido/{pedido}";
        TTALK "v1";
        PRODUCES APPLICATION_JSON

End WSRESTFUL

/*/{Protheus.doc} PUT - Pedido
Metodo PUT para eliminar os residudos de um pedido
@type Function Webservice
@version  12.1.2310
@author leonardo.JAVBCODE
@since 21/06/2024
/*/
WSMETHOD PUT WSSERVICE PEDIDO
    Local cErro    as char
    Local cPedido  as char
    Local oJson    as object
    Local oJsonRet as object

    cPedido := IIF(Len(::aUrlParms) > 0, ::aUrlParms[1], "")

    If !Empty(cPedido)
        oJson := JsonObject():New()
        cErro := oJson:fromJson(Self:GetContent())

        If Empty(cErro)
            If u_afat004(oJson, @oJsonRet, cPedido)
                ::SetResponse(EncodeUTF8(oJsonRet:ToJson()))
            EndIf
        Else
            SetRestFault( 400, 'Parser Json com erro' )
        EndIf
    Else
        SetRestFault(400, EncodeUTF8("Pedido Sogivendas não informado"))
    EndIf

    FreeObj(oJson)
    FreeObj(oJsonRet)
Return
