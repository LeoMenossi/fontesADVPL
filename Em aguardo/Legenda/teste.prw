#Include "protheus.ch"
  
/*/{Protheus.doc} User Function MBlkColor
Altera a cor da linha bloqueada
@type  Function
@author Atilio
@since 27/04/2022
@see http://tdn.totvs.com/display/public/mp/MBlkColor+-+Retorna+cores+a+utilizar
/*/
  
User Function MBlkColor()
    Local aArea     := FWGetArea()
    Local oBrowse   := Nil

    Local nX        := 0
    Local aCores 		:= {{ "SUS->US_MSBLQL == 1 .AND. Empty(SUS->US_NATUREZ)  .AND. Empty(SUS->US_VEND)  .AND. Empty(SUS->US_LC) .AND. Empty(SUS->US_VENCLC)  ", "ORANGE",  "Ped. Cad. Financeiro"},; // Classificado
		   					{ "SUS->US_MSBLQL == 1 .AND. Empty(SUS->US_FILIAL)  .AND. 'Empty(SUS->US_COD)  .AND. Empty(SUS->US_LOJA)  .AND. Empty(SUS->US_NOME)  .AND. Empty(SUS->US_NREDUZ)  .AND. Empty(SUS->US_TIPO)  .AND. Empty(SUS->US_PESSOA)  .AND. Empty(SUS->US_CGC)  .AND. Empty(SUS->US_END)  .AND. Empty(SUS->US_BAIRRO)  .AND. Empty(SUS->US_CEP)  .AND. Empty(SUS->US_EST)  .AND. Empty(SUS->US_COD_MUN)  .AND. Empty(SUS->US_INSCR)  .AND. Empty(SUS->US_CONTRIB)  .AND. Empty(SUS->US_GRPTRIB)  .AND. Empty(SUS->US_PAIS) ", "PINK",  "Ped. Cad. Fiscal"},; // Desenvolvimento
		   					{ "SUS->US_MSBLQL == 1 .AND. Empty(SUS->US_FILIAL)  .AND. 'Empty(SUS->US_COD)  .AND. Empty(SUS->US_LOJA)  .AND. Empty(SUS->US_NOME)  .AND. Empty(SUS->US_NREDUZ)  .AND. Empty(SUS->US_TIPO)  .AND. Empty(SUS->US_PESSOA)  .AND. Empty(SUS->US_CGC)  .AND. Empty(SUS->US_END)  .AND. Empty(SUS->US_BAIRRO)  .AND. Empty(SUS->US_CEP)  .AND. Empty(SUS->US_EST)  .AND. Empty(SUS->US_COD_MUN)  .AND. Empty(SUS->US_INSCR)  .AND. Empty(SUS->US_CONTRIB)  .AND. Empty(SUS->US_GRPTRIB)  .AND. Empty(SUS->US_PAIS)  .AND. Empty(SUS->US_NATUREZ)  .AND. Empty(SUS->US_VEND)  .AND. Empty(SUS->US_LC)  .AND. Empty(SUS->US_VENCLC) ", "GRAY", "Ped. Cad. Fin e Fiscal"},; // Desenvolvimento
		   					{ "SUS->US_STATUS == '1'", "BR_MARROM"		, "Classificado" 	},; // Desenvolvimento
		   					{ "SUS->US_STATUS == '2'", "BR_VERMELHO" 	, "Desenvolvimento" 	},; // Desenvolvimento
		   					{ "SUS->US_STATUS == '3'", "BR_AZUL"	  	, "Gerente"	},; // Gerente
							{ "SUS->US_STATUS == '4'", "BR_AMARELO"  	, "Standy by" 	},; // Standy by
							{ "SUS->US_STATUS == '5'", "BR_PRETO"	  	, "Cancelado"	},; // Cancelado
							{ "SUS->US_STATUS == '6'", "BR_VERDE"	  	, "Cliente "  },;  // Cliente 
							{ "Empty(SUS->US_STATUS)", "BR_BRANCO"	   	, "Maling (sem status)	"  } }  // Maling (sem status)	*/
  
    //Se a última tabela aberta for a de Fornecedor e vier da rotina MATA020
    If aArea[1] == 'SUS' .And. FWIsInCallStack("TMKA260")
        //Intercepta o Browse - similar a antiga GetObjBrow()
        oBrowse := FWmBrwActive()
          
        //Se o Browse já estiver na memória
        If ValType(oBrowse) == "O"
            oBrowse:aLegends := {}

            //Se não tiver legendas, irá adicionar
            //oBrowse:AddLegend( "SUS->US_MSBLQL == 1 .AND. Empty(SUS->US_NATUREZ)  .AND. Empty(SUS->US_VEND)  .AND. Empty(SUS->US_LC) .AND. Empty(SUS->US_VENCLC)  ", "ORANGE",  "Ped. Cad. Financeiro")
            //oBrowse:AddLegend( "SUS->US_MSBLQL == 1 .AND. Empty(SUS->US_FILIAL)  .AND. 'Empty(SUS->US_COD)  .AND. Empty(SUS->US_LOJA)  .AND. Empty(SUS->US_NOME)  .AND. Empty(SUS->US_NREDUZ)  .AND. Empty(SUS->US_TIPO)  .AND. Empty(SUS->US_PESSOA)  .AND. Empty(SUS->US_CGC)  .AND. Empty(SUS->US_END)  .AND. Empty(SUS->US_BAIRRO)  .AND. Empty(SUS->US_CEP)  .AND. Empty(SUS->US_EST)  .AND. Empty(SUS->US_COD_MUN)  .AND. Empty(SUS->US_INSCR)  .AND. Empty(SUS->US_CONTRIB)  .AND. Empty(SUS->US_GRPTRIB)  .AND. Empty(SUS->US_PAIS) ", "PINK",  "Ped. Cad. Fiscal")
            //oBrowse:AddLegend( "SUS->US_MSBLQL == 1 .AND. Empty(SUS->US_FILIAL)  .AND. 'Empty(SUS->US_COD)  .AND. Empty(SUS->US_LOJA)  .AND. Empty(SUS->US_NOME)  .AND. Empty(SUS->US_NREDUZ)  .AND. Empty(SUS->US_TIPO)  .AND. Empty(SUS->US_PESSOA)  .AND. Empty(SUS->US_CGC)  .AND. Empty(SUS->US_END)  .AND. Empty(SUS->US_BAIRRO)  .AND. Empty(SUS->US_CEP)  .AND. Empty(SUS->US_EST)  .AND. Empty(SUS->US_COD_MUN)  .AND. Empty(SUS->US_INSCR)  .AND. Empty(SUS->US_CONTRIB)  .AND. Empty(SUS->US_GRPTRIB)  .AND. Empty(SUS->US_PAIS)  .AND. Empty(SUS->US_NATUREZ)  .AND. Empty(SUS->US_VEND)  .AND. Empty(SUS->US_LC)  .AND. Empty(SUS->US_VENCLC) ", "GRAY", "Ped. Cad. Fin e Fiscal")
            For nX := 1 To Len(aCores)
                aAdd(oBrowse:aLegends,{aCores[nX][1], aCores[nX][2], aCores[nX][3]})
            Next nX
        EndIf
    EndIf
  
    FWRestArea(aArea)
Return
