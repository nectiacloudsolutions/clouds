public with sharing class relatedProductsExtension {

    public List<Producto_del_Cliente__c> listaProductos{get;set;}
    public Account accId{get;set;}
    public String tipoRegistroPrd{get;set;}
    public String tipoRegistroCaso{get;set;}
    public String idProducto{get;set;}
    public String nombreCliente{get;set;}
    public relatedProductsExtension(ApexPages.StandardController controller) {
        accId = (Account)controller.getRecord();
        nombreCliente = [Select Id, Name from Account Where id =: accId.Id].Name;
        listaProductos = [Select Id, Name, Estado_Nectia__c, RecordTypeId from Producto_del_Cliente__c where Cliente_Nectia__c =: accId.Id];
        
    }

    public void crearCaso(){
        //https://bcoconsorcio--devbancorr.cs71.my.salesforce.com/500/e?ent=Case&cas4=Nectia&RecordType=0124D000000CjJL&CF00N4D000000Tc81=Hogar%20Full%2015954778-7&retURL=%2F500%2Fo
        PageReference p; 
        system.debug(tipoRegistroPrd);
        if(!test.isRunningTest()){
        tipoRegistroCaso = [Select Id__c  from Tipo_de_registro_casos__mdt where Id_Producto__c =: tipoRegistroPrd].Id__c;
        }
        system.debug(tipoRegistroCaso);
        p = new PageReference('/apex/CONS_Nuevo_Caso_Producto?id='+idProducto+'&idTipoRegistro='+tipoRegistroCaso);
            
        system.debug(p);
         
        //return p;
    }   
    
    
    
}