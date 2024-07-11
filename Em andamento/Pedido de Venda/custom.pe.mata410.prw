#INCLUDE "PROTHEUS.CH"


User Function A410EXC()
	Local aAreaSC5  := SC5->(FWGetArea())
	Local aAreaSC6  := SC6->(FWGetArea())
	Local cNumPed   := SC5->C5_NUM
	Local cFilPed   := SC5->C5_FILIAL
	Local lRet      := .T.

	If !Empty(SC5->C5_XPEDSOG)
		FwAlertWarning("Os Pedidos com origem no Sogivendas não podem ser excluidos, apenas eliminar os residuo", "Pedido com origem Sogivenda")
		lRet := .F.
	EndIf

	FWRestArea(aAreaSC5)
	FWRestArea(aAreaSC6)
Return lRet

User Function M410INIC()

	Local aAreaSC5  := SC5->(FWGetArea())
	Local aAreaSC6  := SC6->(FWGetArea())

    If IsInCallStack("u_afat003")

        DbSelectArea("SC5")
	    M->C5_TIPO     := "N" //Campo que será gravado na SC5
	    M->C5_CLIENT   := CJ_CLIENTE //Campo que será gravado na SC5
	    M->C5_LOJENT   := CJ_LOJA //Campo que será gravado na SC5
	    M->C5_TIPOCLI  := CJ_TIPOCLI //Campo que será gravado na SC5
	    M->C5_TRANSP   := CJ_XTRANSP //Campo que será gravado na SC5
	    M->C5_EMISSAO  := dDataBase //Campo que será gravado na SC5
	    M->C5_XMENNOTA := CJ_XMENNOT //Campo que será gravado na SC5
	    M->C5_VEND1    := CJ_XVEND1 //Campo que será gravado na SC5
	    M->C5_REDESP   := CJ_XTRARD //Campo que será gravado na SC5
	    M->C5_XPED     := CJ_XPEDCOM //Campo que será gravado na SC5

        DbSelectArea("SC6")
        M->C6_PEDCLI := CJ_XPEDCOM
        M->C6_OPER   := CK_OPER
    EndIf

	FwRestArea(aAreaSC5)
	FwRestArea(aAreaSC6)

Return()

