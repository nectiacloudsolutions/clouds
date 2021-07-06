/*********************************************************************************************************
@Author       sortiztr@everis.com
@name         LeadTriggerHandlerB2b
@CreateDate   29/07/2020
@Description  Handler of the Lead object B2b
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
29/07/2020                    sortiztr@everis.com           Initial Version
**********************************************************************************************************/
public class LeadTriggerHandlerB2b {
    
     private static Consorcio_Org_B2B__c orgB2B = ProcessControlHelper.shouldRunProcessB2B();

    /**
      * @description       This method calls helper class methods on Before Insert event of sObject Lead B2b
      * @param1            new Records List<Lead> : updateLead
      * @return            void
      * @throws            NA
    */
    public static void onBeforeInsert(List<Lead> newList){
      if(orgB2B.Carga_Masiva_de_Prospectos__c){
        LeadTriggerHelperB2b.assignRutEmpresaFilial(newList);
        LeadTriggerHelperB2b.assignCuotasByEjecutivosInsert(newList);
      }
      if(orgB2B.Sales_Project_B2B__c){
        LeadTriggerHelperB2b.populateRutEmpresaFilialByPropio(newList, null); 
        LeadTriggerHelperB2b.Insertrackingfields(newList);    // revisar con mauro hay error en el metodo con old en el insert.
      }
    }

    /**
      * @description       This method calls helper class methods on Before Update event of sObject Lead B2b
      * @param1            new Records List<Lead> : updateLead
      * @return            void
      * @throws            NA
    */
    public static void onBeforeUpdate(List<Lead> newList, Map<ID,Lead> oldMap){
      if(orgB2B.Carga_Masiva_de_Prospectos__c){
        LeadTriggerHelperB2b.assignCuotasByEjecutivos(newList, oldMap);
        LeadTriggerHelperB2b.reasignOwnerToLeadAndRelated(newList, oldMap);
      }
      if(orgB2B.Sales_Project_B2B__c){
        LeadTriggerHelperB2b.populateRutEmpresaFilialByPropio(newList, oldMap); 

        LeadTriggerHelperB2b.cambiosEtapasProspecto(newList, oldMap);
        LeadTriggerHelperB2b.Updatetrackingfields(newList, oldMap);
      }
    }

    public static void onAfterUpdate(List<Lead> newList, Map<Id, Lead> oldMap){
      if(orgB2B.Sales_Project_B2B__c){
        LeadTriggerHelperB2b.leadConvertedFields(newList, oldMap);
      }
    }


}