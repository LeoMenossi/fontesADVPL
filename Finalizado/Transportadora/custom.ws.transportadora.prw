#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL Transportadora DESCRIPTION 'Serviço para consulta de cadastro de tranportadora' FORMAT 'APPLICATION_JSON'
    WSDATA page       AS integer     Optional
    WSDATA pageSize   AS integer     Optional
    WSDATA order      AS character   Optional
    WSDATA fields     AS character   Optional 

    WSMETHOD GET Transportadora; 
        DESCRIPTION "Consulta de transportadora"; 
        WSSYNTAX "/api/faturamento/transportes/v2/transportadora"; 
        PATH "/api/faturamento/transportes/v2/transportadora"; 
        TTALK "v1";
        PRODUCES APPLICATION_JSON
End WSRESTFUL

WSMETHOD GET Transportadora QUERYPARAM page WSSERVICE TRANSPORTADORA
Return u_afat007(Self)
