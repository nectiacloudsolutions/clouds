/*********************************************************************************************************
 @Author       mbeltrab@everis.com
 @name         DatoComplementarioTriggerHandlerB2B
 @CreateDate   12/08/2020
 @Description  Handler of the Dato_Complementarios__c object
 ***********************************************************************************************************
 History of changes:
 -----------------------------------------------------------------------------------------------------------
 Date                               Developer                         Comments
 -----------------------------------------------------------------------------------------------------------
 12/08/2020                    mbeltrab@everis.com           Initial Version
 **********************************************************************************************************/
public with sharing class DatoComplementarioTriggerHandlerB2B{

    /**
     * @description       This method calls helper class methods on Before Insert event of sObject Dato_Complementarios__c
     * @param1            new Records List<Event> : eventList
     * @return            void
     * @throws            NA
     */
    public void onBeforeInsert(List<Dato_Complementarios__c> newList, Map<ID, Dato_Complementarios__c> oldMap){

        for (Dato_Complementarios__c iDatos : newList) {
            if (iDatos.Contacto_Principal__c == true &&  
                iDatos.RecordTypeId != DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CONTACTO_DEVELOPERNAME)) {
                iDatos.addError('No puede ser Contacto Principal un Dato Complementario que no es tipo Contacto');
            } 
        }
        DatoComplementarioTriggerHelperB2b.addErrorInvalidRUT(newList, null);
        //DatoComplementarioTriggerHelperB2b.datosComplementariosByLeadIdTipoContact(newList, oldMap);
    }
    
    /**
     * @description       This method calls helper class methods on Before Update event of sObject Dato_Complementarios__c
     * @param1            new Records List<Event> : eventList
     * @return            void
     * @throws            NA
     */
    public void onBeforeUpdate(List<Dato_Complementarios__c> newList, Map<ID, Dato_Complementarios__c> oldMap){
        for (Dato_Complementarios__c iDatos : newList) {
            Dato_Complementarios__c oldDC = oldMap.get(iDatos.Id);

            if (DatoComplementarioTriggerHelperB2b.isChangeContact(iDatos,oldDC) && iDatos.Contacto_Principal__c) {
                if (iDatos.RecordTypeId != DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CONTACTO_DEVELOPERNAME)) {
                    iDatos.addError('No puede ser Contacto Principal un Dato Complementario que no es tipo Contacto');
                } 
            }
        }

        DatoComplementarioTriggerHelperB2b.addErrorInvalidRUT(newList, oldMap);
        DatoComplementarioTriggerHelperB2b.populateCtcPrincipalInfoTolead(newList, oldMap);
    }

    /**
     * @description       This method calls helper class methods on After Insert event of sObject Dato_Complementarios__c
     * @param1            new Records List<Event> : eventList
     * @return            void
     * @throws            NA
     */
    public void onAfterInsert(List<Dato_Complementarios__c> newList){
        DatoComplementarioTriggerHelperB2b.assignCtcPrincipalTrue(newList);
    }

    public void onAfterUpdate(List<Dato_Complementarios__c> newList, Map<Id, Dato_Complementarios__c> oldMap){
        DatoComplementarioTriggerHelperB2b.updateLeadByNewCtcPrincipal(newList, oldMap);
    }

}