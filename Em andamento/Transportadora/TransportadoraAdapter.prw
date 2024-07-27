#include 'totvs.ch'
#include 'parmtype.ch'

CLASS TransportadoraAdapter FROM FWAdapterBaseV2
    METHOD New()
    METHOD Buscar()
ENDCLASS

METHOD New(cVerbo) CLASS TransportadoraAdapter
    _Super:New(cVerbo, .T.)
Return

METHOD Buscar() CLASS TransportadoraAdapter
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
    Self:SetOrder('A4_COD')

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
    oSelf:AddMapFields('filial',                    'A4_FILIAL',    .T., .F., {'A4_FILIAL',     'C', TamSX3('A4_FILIAL')[01],   0})
    oSelf:AddMapFields('codigo',                    'A4_COD',       .T., .F., {'A4_COD',        'C', TamSX3('A4_COD')[01],      0})
    oSelf:AddMapFields('nome',                      'A4_NOME',      .T., .F., {'A4_NOME',       'C', TamSx3('A4_NOME')[01],     0})
    oSelf:AddMapFields('nomereduzido',              'A4_NREDUZ',    .T., .F., {'A4_NREDUZ',     'C', TamSx3('A4_NREDUZ')[01],   0})
    oSelf:AddMapFields('via',                       'A4_VIA',       .T., .F., {'A4_VIA',        'C', TamSx3('A4_VIA')[01],      0})
    oSelf:AddMapFields('cep',                       'A4_CEP',       .T., .F., {'A4_CEP',        'C', TamSX3('A4_CEP')[01],      0})
    oSelf:AddMapFields('endereco',                  'A4_END',       .T., .F., {'A4_END',        'C', TamSX3('A4_END')[01],      0})
    oSelf:AddMapFields('municipio',                 'A4_MUN',       .T., .F., {'A4_MUN',        'C', TamSX3('A4_MUN')[01],      0})
    oSelf:AddMapFields('estado',                    'A4_EST',       .T., .F., {'A4_EST',        'C', TamSX3('A4_EST')[01],      0})
    oSelf:AddMapFields('cgc',                       'A4_CGC',       .T., .F., {'A4_CGC',        'C', TamSX3('A4_CGC')[01],      0})
    oSelf:AddMapFields('inscricaoestadual',         'A4_INSEST',    .T., .F., {'A4_INSEST',     'C', TamSX3('A4_INSEST')[01],   0})
    oSelf:AddMapFields('telefone',                  'A4_TEL',       .T., .F., {'A4_TEL',        'C', TamSX3('A4_TEL')[01],      0})
    oSelf:AddMapFields('telex',                     'A4_TELEX',     .T., .F., {'A4_TELEX',      'C', TamSX3('A4_TELEX')[01],    0})
    oSelf:AddMapFields('email',                     'A4_EMAIL',     .T., .F., {'A4_EMAIL',      'C', TamSX3('A4_EMAIL')[01],    0})
    oSelf:AddMapFields('homepage',                  'A4_HPAGE',     .T., .F., {'A4_HPAGE',      'C', TamSX3('A4_HPAGE')[01],    0})
    oSelf:AddMapFields('dataexportado',             'A4_DATAEXP',   .T., .F., {'A4_DATAEXP',    'D', TamSX3('A4_DATAEXP')[01],  0})
    oSelf:AddMapFields('dataimportadoo',            'A4_DATAIMP',   .T., .F., {'A4_DATAIMP',    'D', TamSX3('A4_DATAIMP')[01],  0})
    oSelf:AddMapFields('exportado',                 'A4_EXPORT',    .T., .F., {'A4_EXPORT',     'C', TamSX3('A4_EXPORT')[01],   0})
    oSelf:AddMapFields('importado',                 'A4_IMPORT',    .T., .F., {'A4_IMPORT',     'C', TamSX3('A4_IMPORT')[01],   0})
    oSelf:AddMapFields('bairro',                    'A4_BAIRRO',    .T., .F., {'A4_BAIRRO',     'C', TamSX3('A4_BAIRRO')[01],   0})
    oSelf:AddMapFields('ddi',                       'A4_DDI',       .T., .F., {'A4_DDI',        'C', TamSX3('A4_DDI')[01],      0})
    oSelf:AddMapFields('ddd',                       'A4_DDD',       .T., .F., {'A4_DDD',        'C', TamSX3('A4_DDD')[01],      0})
    oSelf:AddMapFields('enderecopadrao',            'A4_ENDPAD',    .T., .F., {'A4_ENDPAD',     'C', TamSX3('A4_ENDPAD')[01],   0})
    oSelf:AddMapFields('estruturafisica',           'A4_ESTFIS',    .T., .F., {'A4_ESTFIS',     'C', TamSX3('A4_ESTFIS')[01],   0})
    oSelf:AddMapFields('local',                     'A4_LOCAL',     .T., .F., {'A4_LOCAL',      'C', TamSX3('A4_LOCAL')[01],    0})
    oSelf:AddMapFields('tipotransportadora',        'A4_TPTRANS',   .T., .F., {'A4_TPTRANS',    'C', TamSX3('A4_TPTRANS')[01],  0})
    oSelf:AddMapFields('complemento',               'A4_COMPLEM',   .T., .F., {'A4_COMPLEM',    'C', TamSX3('A4_COMPLEM')[01],  0})
    oSelf:AddMapFields('paisbacen',                 'A4_CODPAIS',   .T., .F., {'A4_CODPAIS',    'C', TamSX3('A4_CODPAIS')[01],  0})
    oSelf:AddMapFields('codigomunicipio',           'A4_COD_MUN',   .T., .F., {'A4_COD_MUN',    'C', TamSX3('A4_COD_MUN')[01],  0})
    oSelf:AddMapFields('fomezero',                  'A4_FOMEZER',   .T., .F., {'A4_FOMEZER',    'C', TamSX3('A4_FOMEZER')[01],  0})
    oSelf:AddMapFields('suframa',                   'A4_SUFRAMA',   .T., .F., {'A4_SUFRAMA',    'C', TamSX3('A4_SUFRAMA')[01],  0})
    oSelf:AddMapFields('endereconaoformatado',      'A4_ENDNOT',    .T., .F., {'A4_ENDNOT',     'C', TamSX3('A4_ENDNOT')[01],   0})
    oSelf:AddMapFields('ecommerce',                 'A4_ECSERVI',   .T., .F., {'A4_ECSERVI',    'C', TamSX3('A4_ECSERVI')[01],  0})
    oSelf:AddMapFields('rntrc',                     'A4_ANTT',      .T., .F., {'A4_ANTT',       'C', TamSX3('A4_ANTT')[01],     0})
    oSelf:AddMapFields('bloqueado',                 'A4_MSBLQL',    .T., .F., {'A4_MSBLQL',     'C', TamSX3('A4_MSBLQL')[01],   0})
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
