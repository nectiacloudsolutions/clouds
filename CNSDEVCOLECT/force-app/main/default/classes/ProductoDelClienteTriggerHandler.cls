/*********************************************************************************************************
@Author       curbinav@everis.com
@name         ProductoDelClienteTriggerHandler
@CreateDate   01/10/2019
@Description  Handler of the ProductoDelCliente object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
07/11/2019    curbinav@everis.com           W-000073 - (Vista 360° Cliente) - Ingreso Sección Cliente (Resumen)
**********************************************************************************************************/
public class ProductoDelClienteTriggerHandler {
    // Singleton instance
    private static ProductoDelClienteTriggerHandler instance = null;

    /**
      * @description       This method calls helper class methods on Singleton pattern for sObject ProductoDelCliente 
      * @param             void
      * @return            ProductoDelClienteTriggerHandler
      * @throws            NA 
    */
    public static ProductoDelClienteTriggerHandler getInstance() {
        if (instance == null){
            instance = new ProductoDelClienteTriggerHandler();
        }    
        return instance;
    }

    /**
      * @description       This method calls helper class methods on After Insert event of sObject ProductoDelCliente
      * @param1            new Records List<Producto_Del_Cliente__c> : newProductoDelClienteList
      * @return            void
      * @throws            NA
    */
    public void onAfterInsert(List<Producto_Del_Cliente__c> newProductoDelClienteList){
      	ProductoDelClienteTriggerHelper.onAfterInsert(newProductoDelClienteList);
    }
}