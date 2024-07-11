#INCLUDE "PROTHEUS.CH"

User Function afat004(oJson, oJsonRet, cPedido)
    Local lRet      := .F.
    Local lExistPed := .F.
    Local aAreaSC5  := SC5->(FwGetArea())
    Local aAreaSC6  := SC6->(FwGetArea())
    Local aAreaSC9  := SC9->(FwGetArea())
    Local cQuery    := ""
    Local cCliente  := ""
    Local cLojaCli  := ""
    Local nRecno    := 0

    cQuery := afat004A(cPedido)

    DbUseArea(.T., "TOPCONN", TCGenQry( , , cQuery), "QRYSC5", .F., .T.)

    While QRYSC5->(!EoF())

        lExistPed := .T.
        cCliente  := QRYSC5->C5_CLIENTE
        cLojaCli  := QRYSC5->C5_LOJACLI
        nRecno    := QRYSC5->RECNO

        //Continuar a eliminação de residuo

    EndDo

    If !lExistPed
        SetRestFault(404, EncodeUTF8("Pedido " + cPedido + " não encontrado, favor revisar"))
    EndIf

    FwRestArea(aAreaSC5)
    FwRestArea(aAreaSC6)
    FwRestArea(aAreaSC9)
Return lRet


Static Function afat004(cPedido)
    Local cQuery := ""

    cQuery := "SELECT C5_FILIAL,"
    cQuery +=       " C5_NUM,"
    cQuery +=       " C5_CLIENTE,"
    cQuery +=       " C5_LOJACLI,"
    cQuery +=       " R_E_C_N_O_ RECNO"
    cQuery += "WHERE C5_FILAIL = '" + xFilial("SC5") + "'"
    cQuery +=      " AND C5_NUM = '" + cPedido + "'"
    cQuery +=      " AND D_E_L_E_T_ = ''

    cQuery := ChangeQuery(cQuery)

Return cQuery
