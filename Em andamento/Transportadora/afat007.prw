#INCLUDE "PROTHEUS.CH"


User Function afat007(oService)
    Local lRet      As Logical
    Local oAdapter  As Object
   
    DEFAULT oService:Page      := 1 
    DEFAULT oService:PageSize  := 100
    DEFAULT oService:Fields    := ""
   
    lRet        := .T.
    
    /*
    TransportadoraAdapter ser� nossa classe que fornece os dados para o servi�o
    O primeiro parametro define que iremos usar o GET
    */
    oAdapter := TransportadoraAdapter():New('GET')

    /*
    O m�todo setPage indica qual p�gina deveremos retornar
    Ex: nossa consulta tem como resultado 100 produtos, e retornamos sempre uma listagem de 10 itens por p�gina.
    a p�gina 1 retorna os itens de 1 a 10
    a p�gina 2 retorna os itens de 11 a 20
    e assim at� chegar ao final de nossa listagem de 100 produtos
    */   
    oAdapter:SetPage(oService:Page)
    /*
    setPageSize indica que nossa p�gina ter� no m�ximo 100 itens
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
    SetFields indica os campos que ser�o retornados via querystring
    */
    oAdapter:SetFields(oService:Fields)  
    /*
    Esse m�todo ir� processar as informa��es
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
   faz a desaloca��o de objetos e arrays utilizados
   */
   oAdapter:DeActivate()
   oAdapter := NIL   
Return lRet
