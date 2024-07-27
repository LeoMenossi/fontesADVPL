#INCLUDE "PROTHEUS.CH"


User Function afat007(oService)
    Local lRet      As Logical
    Local oAdapter  As Object
   
    DEFAULT oService:Page      := 1 
    DEFAULT oService:PageSize  := 100
    DEFAULT oService:Fields    := ""
   
    lRet        := .T.
    
    /*
    TransportadoraAdapter será nossa classe que fornece os dados para o serviço
    O primeiro parametro define que iremos usar o GET
    */
    oAdapter := TransportadoraAdapter():New('GET')

    /*
    O método setPage indica qual página deveremos retornar
    Ex: nossa consulta tem como resultado 100 produtos, e retornamos sempre uma listagem de 10 itens por página.
    a página 1 retorna os itens de 1 a 10
    a página 2 retorna os itens de 11 a 20
    e assim até chegar ao final de nossa listagem de 100 produtos
    */   
    oAdapter:SetPage(oService:Page)
    /*
    setPageSize indica que nossa página terá no máximo 100 itens
    */
    oAdapter:SetPageSize(oService:PageSize)
    /*
    SetOrderQuery indica a ordem definida por querystring
    */
    oAdapter:SetOrderQuery(oService:Order)
    /*
    setUrlFilter indica o filtro querystring recebido (pode se utilizar um filtro oData)
    */
    oAdapter:SetUrlFilter(oService:aQueryString)
    /*
    SetFields indica os campos que serão retornados via querystring
    */
    oAdapter:SetFields(oService:Fields)  
    /*
    Esse método irá processar as informações
    */
    oAdapter:Buscar()
    /*
    Se tudo ocorreu bem, retorna os dados via Json
    */
    IF oAdapter:lOk
       oService:SetResponse(oAdapter:GetJsonResponse())
    ELSE
        /*
        Ou retorna o erro encontrado durante o processamento
        */
        SetRestFault(oAdapter:GetCode(),oAdapter:GetMessage())
        lRet := .F.
   EndIF
   /*
   faz a desalocação de objetos e arrays utilizados
   */
   oAdapter:DeActivate()
   oAdapter := NIL   
Return lRet
