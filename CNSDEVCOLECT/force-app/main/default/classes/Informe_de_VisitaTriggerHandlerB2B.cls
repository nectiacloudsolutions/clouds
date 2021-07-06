/*********************************************************************************************************
 @Author       mbeltrab@everis.com
 @name         Informe_de_VisitaTriggerHandlerB2B
 @CreateDate   13/08/2020
 @Description  Handler of the Informe_de_Visita__c object
 ***********************************************************************************************************
 History of changes:
 -----------------------------------------------------------------------------------------------------------
 Date                               Developer                         Comments
 -----------------------------------------------------------------------------------------------------------
 13/08/2020                    mbeltrab@everis.com           Initial Version
 **********************************************************************************************************/
public with sharing class Informe_de_VisitaTriggerHandlerB2B{
	
	private static Consorcio_Org_B2B__c orgB2B = ProcessControlHelper.shouldRunProcessB2B();

	/**
	 * @description       This method calls helper class methods on Before Insert event of sObject Informe_de_Visita__c
	 * @param1            new Records List<Event> : eventList
	 * @return            void
	 * @throws            NA
	 */
	public void onBeforeInsert(List<Informe_de_Visita__c> InsertInforme_de_Visita, Map<ID, Informe_de_Visita__c> oldInforme_de_Visita){
		if(orgB2B.Sales_Project_B2B__c){
			//Informe_de_VisitaTriggerHelperB2b.assignInformeVisitaGeneradoToLead(InsertInforme_de_Visita, oldInforme_de_Visita);
		}
	}

	/**
	 * @description       This method calls helper class methods on After Insert event of sObject Informe_de_Visita__c
	 * @param1            new Records List<Event> : eventList
	 * @return            void
	 * @throws            NA
	 */
	public void onAfterInsert(List<Informe_de_Visita__c> newInformeVisita){
		if(orgB2B.Sales_Project_B2B__c){
			Informe_de_VisitaTriggerHelperB2b.insertInformeVisita(newInformeVisita);
		}
	}

	/**
	 * @description       This method calls helper class methods on Before Update event of sObject Informe_de_Visita__c
	 * @param1            new Records List<Event> : eventList
	 * @return            void
	 * @throws            NA
	 */
	public void onBeforeUpdate(List<Informe_de_Visita__c> newList, Map<ID, Informe_de_Visita__c> oldMap){
		if(orgB2B.Sales_Project_B2B__c){
			Informe_de_VisitaTriggerHelperB2b.updateLeadByInformeVisitaGenerado(newList, oldMap);
			Informe_de_VisitaTriggerHelperB2b.validateAccountsFieldsToInformesGenerados(newList, oldMap);
		}
	}
}