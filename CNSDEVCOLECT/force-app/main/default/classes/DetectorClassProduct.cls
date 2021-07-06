/*********************************************************************************************************
@Author       eayalcor@everis.com
@name         DetectorClassProduct
@CreateDate   18/11/2019
@Description  response to analytics after Send Responses Detector
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
18/11/2019                          eayalcor@everis.com           W-XXXXX - INTEGRATION
**********************************************************************************************************/
public class DetectorClassProduct {
    @AuraEnabled public String code;
    @AuraEnabled public String message;
    @AuraEnabled public List<Producto> productos;
    
    public class Producto{
        @AuraEnabled public String idProducto;
        @AuraEnabled public String nombreProducto;
        @AuraEnabled public List<Cobertura> coberturas;
        @AuraEnabled public String helpText;
    }

    public class Cobertura{
        @AuraEnabled public String nombreCobertura;
        @AuraEnabled public String montoUF;
        @AuraEnabled public String helpText;
    }
}