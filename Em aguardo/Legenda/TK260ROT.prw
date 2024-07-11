#Include "FWMVCDEF.CH"
#Include "Protheus.ch"


User Function TK260ROT()
    Local aRotina := {}

    aAdd(aRotina, {"Legenda customizada", "u_LegCustom()", 0, 1})


Return aRotina


User Function LegCustom()
    Local oLegenda := FWLegend():New()

    oLegenda:Add("SUS->US_NATUREZ == '' .AND. SUS->US_VEND == '' .AND. SUS->US_LC == 0 .AND. SUS->US_VENCLC == ''", "BR_AZUL" , "Ped. Cad. Financeiro") 
    oLegenda:Add("SUS->US_FILIAL == '' .AND. 'SUS->US_COD == '' .AND. SUS->US_LOJA == '' .AND. SUS->US_NOME == '' .AND. SUS->US_NREDUZ == '' .AND. SUS->US_TIPO == '' .AND. SUS->US_PESSOA == '' .AND. SUS->US_CGC == '' .AND. SUS->US_END == '' .AND. SUS->US_BAIRRO == '' .AND. SUS->US_CEP == '' .AND. SUS->US_EST == '' .AND. SUS->US_COD_MUN == '' .AND. SUS->US_INSCR == '' .AND. SUS->US_CONTRIB == '' .AND. SUS->US_GRPTRIB == '' .AND. SUS->US_PAIS == ''", "BR_VERMELHO" , "Ped. Cad. Fiscal") 
    oLegenda:Add("SUS->US_FILIAL == '' .AND. 'SUS->US_COD == '' .AND. SUS->US_LOJA == '' .AND. SUS->US_NOME == '' .AND. SUS->US_NREDUZ == '' .AND. SUS->US_TIPO == '' .AND. SUS->US_PESSOA == '' .AND. SUS->US_CGC == '' .AND. SUS->US_END == '' .AND. SUS->US_BAIRRO == '' .AND. SUS->US_CEP == '' .AND. SUS->US_EST == '' .AND. SUS->US_COD_MUN == '' .AND. SUS->US_INSCR == '' .AND. SUS->US_CONTRIB == '' .AND. SUS->US_GRPTRIB == '' .AND. SUS->US_PAIS == '' .AND. SUS->US_NATUREZ == '' .AND. SUS->US_VEND == '' .AND. SUS->US_LC == 0 .AND. SUS->US_VENCLC == ''", "BR_AMARELO" , "Ped. Cad. Fin e Fisca") 

    oLegenda:Activate()
    oLegenda:View()
    oLegenda:DeActivate()   

Return

