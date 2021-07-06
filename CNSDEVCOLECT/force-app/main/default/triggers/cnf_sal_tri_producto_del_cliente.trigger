/*********************************************************************************************************
@Author       curbinav@everis.com
@name         cnf_sal_tri_producto_del_cliente
@CreateDate   01/10/2019
@Description  Main Trigger of the ProductoDelCliente object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
07/11/2019    curbinav@everis.com           W-000073 - (Vista 360° Cliente) - Ingreso Sección Cliente (Resumen)
**********************************************************************************************************/
trigger cnf_sal_tri_producto_del_cliente on Producto_del_Cliente__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Consorcio_Org__c org;

    if (Consorcio_Org__c.getInstance(UserInfo.getUserId()) == null) {
        org = Consorcio_Org__c.getInstance(UserInfo.getProfileId());
    } else {
        org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
    }

    /**Before Insert/Update Event*/
    /*if((Trigger.isInsert) && Trigger.isBefore){
        if(org.Sales_project__c){
            ProductoDelClienteTriggerHandler.getInstance().onBeforeInsert(Trigger.new);
        }
    }*/
        
    /**After Insert/Update Event*/
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
        if(org.Sales_project__c){
            ProductoDelClienteTriggerHandler.getInstance().onAfterInsert(Trigger.new);
        }
    }
    
    /**Before Update Event*/
    /*else if(Trigger.isUpdate && Trigger.isBefore){ 
        //ProductoDelClienteTriggerHandler.getInstance().onAfterInsert(Trigger.new);
    }*/
    
    /**After Update Event*/
    /*else if(Trigger.isUpdate && Trigger.isAfter){

}*/
    
    /**Before Delete Event*/
    /*else if(Trigger.isDelete && Trigger.isBefore){

}*/
    
    /**After Delete Event*/
    else if(Trigger.isDelete && Trigger.isAfter){
        List<Producto_Del_Cliente__c> lista = new List<Producto_Del_Cliente__c>();
        lista.addAll(Trigger.old);
        ProductoDelClienteTriggerHandler.getInstance().onAfterInsert(lista);
    }

    /**After UnDelete Event*/
    /*else if(Trigger.isUnDelete && Trigger.isAfter){

}*/
    
}