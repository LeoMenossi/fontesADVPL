#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"

CLASS GetTransportadora FROM FWAdapterBaseV2
    METHOD New()
    METHOD Buscar()
ENDCLASS

METHOD New(cVerbo) CLASS GetTransportadora
    _Super:New(cVerbo, .T.)
Return

METHOD Buscar() CLASS GetTransportadora
    Local aArea     As Array
    Local cWhere    As Char

    aArea   := FWGetArea()

    /*
    Adiciona o mapa de campos
    */
    AddFields(Self)

    /*
    Informa a query
    */
    Self:SetQuery(GetQuery())

    /*
    informa o Where utilizado na Query
    */
    cWhere := " A4_FILIAL = '" + FWxFilial('SA4') + "' AND SA4.D_E_L_E_T_ = ' ' "
    Self:SetWhere( cWhere )
    
    /*
    Informa a ordenação padrão a ser Utilizada pela Query
    */    
    Self:SetOrder("A4_COD")

    /*
    Executa a consulta, se retornar .T. tudo ocorreu conforme esperado
    */
    
    IF Self:Execute()
        /*
        Gera o arquivo Json com o retorno da Query
        */
        Self:FillGetResponse()
    EndIF
    FWRestArea(aArea)
Return

Static Function AddFields(oSelf)
    oSelf:AddMapFields("filial",                    "A4_FILIAL",    .T., .F., {"A4_FILIAL",     "C", FwSX3Util():GetFieldStruct("A4_FILIAL")[3],   0})
    oSelf:AddMapFields("codigo",                    "A4_COD",       .T., .F., {"A4_COD",        "C", FwSX3Util():GetFieldStruct("A4_COD")[3],      0})
    oSelf:AddMapFields("nome",                      "A4_NOME",      .T., .F., {"A4_NOME",       "C", FwSX3Util():GetFieldStruct("A4_NOME")[3],     0})
    oSelf:AddMapFields("nomereduzido",              "A4_NREDUZ",    .T., .F., {"A4_NREDUZ",     "C", FwSX3Util():GetFieldStruct("A4_NREDUZ")[3],   0})
    oSelf:AddMapFields("via",                       "A4_VIA",       .T., .F., {"A4_VIA",        "C", FwSX3Util():GetFieldStruct("A4_VIA")[3],      0})
    oSelf:AddMapFields("endereco",                  "A4_END",       .T., .F., {"A4_END",        "C", FwSX3Util():GetFieldStruct("A4_END")[3],      0})
    oSelf:AddMapFields("bairro",                    "A4_BAIRRO",    .T., .F., {"A4_BAIRRO",     "C", FwSX3Util():GetFieldStruct("A4_BAIRRO")[3],   0})
    oSelf:AddMapFields("codigomunicipio",           "A4_COD_MUN",   .T., .F., {"A4_COD_MUN",    "C", FwSX3Util():GetFieldStruct("A4_COD_MUN")[3],  0})
    oSelf:AddMapFields("municipio",                 "A4_MUN",       .T., .F., {"A4_MUN",        "C", FwSX3Util():GetFieldStruct("A4_MUN")[3],      0})
    oSelf:AddMapFields("estado",                    "A4_EST",       .T., .F., {"A4_EST",        "C", FwSX3Util():GetFieldStruct("A4_EST")[3],      0})
    oSelf:AddMapFields("cep",                       "A4_CEP",       .T., .F., {"A4_CEP",        "C", FwSX3Util():GetFieldStruct("A4_CEP")[3],      0})
    oSelf:AddMapFields("cgc",                       "A4_CGC",       .T., .F., {"A4_CGC",        "C", FwSX3Util():GetFieldStruct("A4_CGC")[3],      0})
    oSelf:AddMapFields("inscricaoestadual",         "A4_INSEST",    .T., .F., {"A4_INSEST",     "C", FwSX3Util():GetFieldStruct("A4_INSEST")[3],   0})
    oSelf:AddMapFields("email",                     "A4_EMAIL",     .T., .F., {"A4_EMAIL",      "C", FwSX3Util():GetFieldStruct("A4_EMAIL")[3],    0})

Return

Static Function GetQuery()
    Local cQuery    As Char
    /*
    Obtem a ordem informada na requisição, a query exterior SEMPRE deve ter o id #QueryFields# ao invés dos campos fixos
    necessáriamente não precisa ser uma subquery, desde que não contenha agregadores no retorno ( SUM, MAX... )
    o id #QueryWhere# é onde será inserido o clausula Where informado no método SetWhere()
    */
    cQuery  := " SELECT #QueryFields#"
    cQuery  += " FROM " + RetSqlName('SA4') + " SA4 "
    cQuery  += " WHERE #QueryWhere#"
Return cQuery
