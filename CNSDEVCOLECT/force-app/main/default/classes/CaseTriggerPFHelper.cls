/*********************************************************************************************************
@Author       cagonzle@everis.com
@name         PF_CrearCaso_WSRest
@CreateDate   06/08/2020
@Description  Trigger helper - Portabilidad Financiera
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
06/08/2020                    cagonzle@everis.com                 Initial Version
26/08/2020                    cagonzle@everis.com                 Mejora Primer Propietario
16/10/2020                    lmunogar@everis.com                 Incorporación de nuevos envíos de correos a MB
20/10/2020                    cagonzle@everis.com                 Marca caso duplicado 
02/11/2020                    cagonzle@everis.com                 Marca No Cliente 
**********************************************************************************************************/
public class CaseTriggerPFHelper {

	private static final String OPP_STAGE_NAME = 'Contacto';
	private static final Set<String> statusFirstOwner = new Set<String>{Label.PF_Evaluacion};
	private static Map<String,String> mapUsrManager;
	private static Map<String,Account> cuentasMap;
    private static Id casoRT = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(Label.PF_Caso_RecordType).getRecordTypeId();
    private static Id casoRTSalida = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(Label.PF_Caso_RecordType_Salida).getRecordTypeId();
	private static Id oppRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('RT_Portabilidad_financiera').getRecordTypeId();
    private static Set<Id> lstCasosRT = new Set<Id>{casoRT, casoRTSalida};

	public static void onAfter(){ 
		if(Trigger.isInsert || Trigger.isUpdate){
            Account acc;
            string rut;
			List<Case> lstCasos = (List<Case>) Trigger.new;
			List<Case> lstACasos = new List<Case>();
            Map<String,String> mapsManagerId = getManagerIdbyOwner(lstCasos);
			List<String> lstReci = new List<String>();
			List<String> lstOpp = new List<String>(); 
			List<String> lstAcc = new List<String>();  
            List<Case> lstCaseQuery = [Select RecordTypeId, lista_notificacion__c, Caso_PF_Primer_propietario_Formula__c, 
							 OwnerId, status, Notificacion_Ejecutivo__c, Notificacion_Gestor__c, Correo_electr_nico__c, Tel_fono_de_contacto__c,
                             Rut__c, CaseNumber, Type, Subtipo__c, Sub_estado_Nectia__c, Causa_Origen__c, Account.RUT__c, // Campos para Analytics
							 AccountId, Account.Name, Account.OwnerId, Account.PF_Oportunidades__c, Rut_del_Cliente__c
							 from Case where id IN: lstCasos AND RecordTypeId IN: lstCasosRT];
			for (Case caso: lstCaseQuery){
                acc = null;
                if(caso.Rut_del_Cliente__c != null){
					rut = caso.Rut_del_Cliente__c.replaceAll( '\\s+', '');
					acc = cuentasMap.get(rut.toLowerCase());
					if(acc.Productos_de_cliente__r.size() == 0 && Trigger.isInsert){
						lstAcc.add(System.JSON.serialize(new Account(Id=acc.Id, NoClientePortabilidad__c = true)));
					}
					caso.AccountId = acc.Id;                    
                }
				if (caso.lista_notificacion__c != null){                
					if(caso.Notificacion_Gestor__c || caso.Notificacion_Ejecutivo__c){
						lstReci.add(caso.OwnerId);
						if(mapsManagerId.containsKey(caso.OwnerId)){lstReci.add(mapsManagerId.get(caso.OwnerId));}
						CnsCustomNotification.notifyCurrentUser(JSON.serialize(caso), caso.lista_notificacion__c, lstReci);
						lstReci.clear();
					}
				}
                if(Trigger.isInsert && caso.RecordTypeId == casoRT && acc != null ){
                    caso.Account = acc;
                    lstOpp.add(System.JSON.serialize( createOppByCase(caso, caso.OwnerId, oppRT, getOppNameByAcc(acc, 'Portabilidad Entrada'))));
                }				
			}
			if(lstOpp.size() > 0){ System.enqueueJob(new CallIntegrations('UPSERT_SOBJECT_LIST', lstOpp, true )); }
			if(lstAcc.size() > 0){ System.enqueueJob(new CallIntegrations('UPSERT_SOBJECT_LIST', lstAcc, false )); }
		}
	}

    public static void onBeforeUpdate(){
		List<Case> caseList = (List<Case>) Trigger.new;
		Map<Id,Case> newMap = (Map<Id,Case>) Trigger.newMap;
		Map<Id,Case> caseOldMap = (Map<Id,Case>)Trigger.oldMap;
		List<Case> lstCasosMB = new List<Case>();
        Map<Id, Case> caseListMap = new Map<Id, Case>();
        Map<Id, User> mapUsuario = new Map<Id, User>();
        Set<Id> idUsua = new Set<Id>();

        String cuentaRUT = '';
		List<String> lstRUT = new List<String>();
		List<Id> lstIds = new List<Id>();
		for(Case caso : caseList){
			if(lstCasosRT.contains(caso.recordTypeId)){
				if (caso.AccountId != null) {
					lstIds.add(caso.AccountId);
				}
				cuentaRUT = caso.Rut_del_Cliente__c;
				if(String.isNotBlank(cuentaRUT)){ lstRUT.add(cuentaRUT); }
			}
            if(caso.RecordTypeId == casoRTSalida){
                caso.Subject = 'Solicitud de Retención';
            }
		}		
		if(lstRUT.size() > 0 || lstIds.size() > 0 ){ buscarCuentas(lstRUT, lstIds); }
		
		string rut;
		Account acc;
		Case[] lCasos;
        for (Case caso: [Select AccountId, Account.RUT__c, Rut_del_Cliente__c, RecordTypeId, lista_notificacion__c, Caso_PF_Primer_propietario_Formula__c,
						 OwnerId, status, Notificacion_Ejecutivo__c, Notificacion_Gestor__c,Subject,
						 Correo_electr_nico__c, PF_fecha_creacion__c, Account.Name, account.PersonEmail, // Campos PF_EnvioMail_MB.enviarCorreoMB
						 contact.email, CreatedDate, LastModifiedDate, ContactEmail, type, Subtipo__c,  // Campos PF_EnvioMail_MB.enviarCorreoMB
						 Sub_estado_Nectia__c, Caso_PF_Cliente_apto__c,  // Campos PF_EnvioMail_MB.enviarCorreoMB
						 Nombres__c, CaseNumber, Flag_envio_mail__c	 // Campos PF_EnvioMail_MB.enviarCorreoMB					 
                         from Case where id IN: caseList AND RecordTypeId IN: lstCasosRT]){ // OJO: Agregar Filtros puede afectar varios procesos
			if(caso.RecordTypeId == casoRT){ /* HOTFIX 15092020 - Ajuste validacion RT Entrada */
				assignFirstOwner(newMap, caso);
			}
                             
			if(caseOldMap != null && caseOldMap.get(caso.Id).status != null 
               && newMap.get(caso.Id).status == 'Cerrado'
              	&& caso.RecordTypeId == casoRTSalida ){
            	newMap.get(caso.Id).Ultimo_estado_cierre__c = caseOldMap.get(caso.Id).status;                     
			}
			//SINCRONIZACION NEW FIELDS
            caso.type = (String.isBlank(caso.type) ? newMap.get(caso.Id).type : caso.type);
            caso.Subtipo__c = (String.isBlank(caso.Subtipo__c) ? newMap.get(caso.Id).Subtipo__c : caso.Subtipo__c);
            caso.status = (String.isBlank(caso.status) ? newMap.get(caso.Id).status : caso.status);
            caso.Sub_estado_Nectia__c = (String.isBlank(caso.Sub_estado_Nectia__c) ? newMap.get(caso.Id).Sub_estado_Nectia__c : caso.Sub_estado_Nectia__c);
            caso.Caso_PF_Cliente_apto__c = (caso.Caso_PF_Cliente_apto__c == null ? newMap.get(caso.Id).Caso_PF_Cliente_apto__c : caso.Caso_PF_Cliente_apto__c);
			caso.Correo_electr_nico__c = (String.isBlank(caso.Correo_electr_nico__c) ? newMap.get(caso.Id).Correo_electr_nico__c : caso.Correo_electr_nico__c); 
			caso.Rut_del_Cliente__c = (String.isBlank(caso.Rut_del_Cliente__c) ? newMap.get(caso.Id).Rut_del_Cliente__c : caso.Rut_del_Cliente__c); 
			caso.AccountId = (String.isBlank(caso.AccountId) ? newMap.get(caso.Id).AccountId : caso.AccountId); 

			if (String.isNotBlank(caso.Caso_PF_Primer_propietario_Formula__c)){
            	idUsua.add(caso.Caso_PF_Primer_propietario_Formula__c);
            }
 
			if(caso.Rut_del_Cliente__c!=null || caso.AccountId != null){
				caso.Rut_del_Cliente__c = (caso.Rut_del_Cliente__c == null ? caso.Account.RUT__c : caso.Rut_del_Cliente__c );
				rut = caso.Rut_del_Cliente__c.replaceAll( '\\s+', '');
				acc = cuentasMap.get(rut.toLowerCase());
				newMap.get(caso.Id).AccountId = acc.Id;
				newMap.get(caso.Id).ContactId = acc.PersonContactId;
				lCasos = acc.Cases;
				for(Case oCaso : lCasos){
					if(caso.RecordTypeId == oCaso.RecordTypeId && oCaso.RecordTypeId == casoRT && oCaso.Id != caso.Id){
						newMap.get(caso.Id).Caso_PF_Cliente_atendido_Ent__c = true;
					}
					if(caso.RecordTypeId == oCaso.RecordTypeId && oCaso.RecordTypeId == casoRTSalida && oCaso.Id != caso.Id){
						newMap.get(caso.Id).Caso_PF_Cliente_atendido_Sal__c = true;
					}
				}
			}
            caso.Account = acc; // Bugfix
			lstCasosMB.add(caso);
		}
		
        List<User> lstUsuario = [Select name, email, phone from User where Id in: idUsua];
        for (User usua : lstUsuario){
            mapUsuario.put(usua.id, usua);
        }
        if(lstCasosMB.size() > 0){ System.enqueueJob(new CallIntegrations('PF_EnvioMail_MB',lstCasosMB, newMap, caseOldMap, mapUsuario)); } 
	}
	
	/**
	 * assignFirstOwner Definicion del primer propietario
	 * @param  newMap   newMap Mapa de casos del trigger
	 * @param  casoEnBD casoEnBD Caso existente en BD
	 */ 
    private static void assignFirstOwner(Map<Id,Case> newMap, Case casoEnBD){
		String ownerStr = '';
		Case cs = newMap.get(casoEnBD.Id);
		ownerStr = (String) cs.OwnerId;

		if (String.isBlank(casoEnBD.Caso_PF_Primer_propietario_Formula__c) && ownerStr.substring(0, 3) == '005'){
			cs.Caso_PF_Primer_propietario_Formula__c = cs.OwnerId;
			casoEnBD.Caso_PF_Primer_propietario_Formula__c = cs.OwnerId; // Sincronizar triggernew y mapa
		}
		casoEnBD.status = (cs.status != null ?  cs.status : casoEnBD.status);

        if (ownerStr.substring(0, 3) != '005'){/* HOTFIX 23092020 - Ajuste cambio ownerId manual */
        	cs.OwnerId = (statusFirstOwner.contains(casoEnBD.status) ? casoEnBD.Caso_PF_Primer_propietario_Formula__c : cs.OwnerId);
        }

    }

	/**
	 * getManagerIdbyOwner Buscar el manager del owner de un Objeto
	 * @param  lstObj lstObj Lista de sObject. Ejemplo: Cases
	 * @return        return Mapa de relacion Usuario y Manager
	 */
    private static Map<String,String> getManagerIdbyOwner(List<SObject> lstObj){
		mapUsrManager = (mapUsrManager == null ? new Map<String,String>() : mapUsrManager);
		if(mapUsrManager.size()==0){
			Set<String> lstIds = new Set<String>();
	
			for(SObject sobj : lstObj){
				lstIds.add(String.valueOf(sobj.get('OwnerId')));
			}
	
			List<User> lstUser = [SELECT Id,ManagerId FROM USER WHERE Id IN : lstIds];
	
			for(User usr : lstUser){
				mapUsrManager.put(usr.Id, usr.ManagerId);
			}	
		}
        return mapUsrManager;
    }

	/**
	 * buscarCuentas Lista de Cuentas por numero de RUT
	 * @param  cuentaRUT Lista de Numeros RUT de las cuentas 
	 * @param  cuentaIds Lista de Ids de las cuentas 
	 */
    private static void buscarCuentas(List<String> cuentaRUT, List<Id> cuentaIds){
        cuentasMap = new Map<String,Account>();
		string rut = '';
        for(Account acc : [SELECT RUT__c, PersonContactId, Name, PF_Oportunidades__c, OwnerId,
								(SELECT AccountId, CaseNumber, RecordTypeId FROM Cases WHERE RecordTypeId IN: lstCasosRT AND Status != 'Cerrado' ORDER BY CreatedDate LIMIT 1),
                           		(SELECT Id FROM Productos_de_cliente__r WHERE Estado_Nectia__c = 'Activo' LIMIT 1),
								(SELECT Id FROM Opportunities WHERE RecordTypeId =: oppRT)
							FROM Account WHERE RUT__c IN: cuentaRUT OR Id IN: cuentaIds]){
			if(acc.RUT__c != null ){
				rut = acc.RUT__c.replaceAll( '\\s+', '');
				cuentasMap.put(rut.toLowerCase(), acc);
			}
        }
    }

    /**
     * createOppByCase Crear una oportunadad desde el registro de Caso de PF
     * @param  CaseId  CaseId Id del Caso PF
     * @param  ownerId ownerId Propietario de la Oportinudad, que puede ser diferente al propietario del caso
     * @param  rtOppId rtOppId Tipo de Registro de la Oportunidad
     * @param  name    name Nombre dinamico de la Oportunidad
     * @return         return La oportunidad relacionada al caso
     */ 
    private static Opportunity createOppByCase(Case caso, Id ownerId, Id rtOppId, String name){
        Opportunity newOpp = new Opportunity(AccountId =  caso.AccountId,
        Caso_PF__c = caso.Id,
        Name = name,
        OwnerId = ownerId,
        StageName = OPP_STAGE_NAME,
        CloseDate = Date.Today().addDays(30),
        RecordTypeId = rtOppId,
		PF_Rut__c = caso.Rut_del_Cliente__c,
		Telefono_portabilidad__c = caso.Tel_fono_de_contacto__c,
		PF_Correo_Electronico_Digital__c = caso.Correo_electr_nico__c);
        return newOpp;
    }
    
    /**
     * getOppNameByAcc Generar el nombre la oportunidad con consecutivo x cantidad de Opps del cliente
     * @param  acc acc Cuanta relacionada al caso/oportunidad PF
     * @return     return description
     */
    private static String getOppNameByAcc(Account acc, String prefix){
        Decimal countOpp = acc.Opportunities.size() + 1;
        return prefix + ' - ' + countOpp + ' - ' + acc.Name;
    }

	@future
	private static void upsertSObjetsList(List<String> lstJSObject, Boolean isInsert){
		try{
			List<sObject> lstSObject = new List<sObject>();
			for(String jSObject : lstJSObject){
				lstSObject.add((sObject) System.JSON.deserialize(jSObject, SObject.Class)  );	
			}
			if(isInsert){ Insert  lstSObject;
			}else{ Update  lstSObject; }
		}catch(Exception e){
			System.debug('Error Upsert sObject: '+e.getMessage());
		}
	} 		
    
    public class CallIntegrations implements Queueable {
        public String funcName;
        public List<Case> lstCasosMB;
        public Map<Id,Case> caseNewMap;
        public Map<Id,Case> caseOldMap;
        public Map<Id, User> mapUsuario;
        public List<Case> lstACasos;
		public List<String> lstJSObject;
		public Boolean isInsert;
       
        public CallIntegrations(String funcName, List<Case> lstCasosMB, Map<Id,Case> caseNewMap, Map<Id,Case> caseOldMap, Map<Id, User> mapUsuario){
            this.funcName = funcName;
            this.lstCasosMB = lstCasosMB; 
            this.caseNewMap = caseNewMap;
            this.caseOldMap = caseOldMap;
            this.mapUsuario = mapUsuario;
        }

        public CallIntegrations(String funcName, List<Case> lstACasos){            
            this.funcName = funcName;
            this.lstACasos = lstACasos;
        }

        public CallIntegrations(String funcName, List<String> lstJSObject, Boolean isInsert){            
            this.funcName = funcName;
            this.lstJSObject = lstJSObject;
			this.isInsert = isInsert;
        }		
        
        public void execute(QueueableContext context) {
            System.debug('Queueable Job -> '+funcName);
            if(funcName.equals('PF_EnvioMail_MB')){
                PF_EnvioMail_MB.enviarCorreoMB(lstCasosMB, caseNewMap, caseOldMap, mapUsuario); 
            }
			if(funcName.equals('UPSERT_SOBJECT_LIST')){
				upsertSObjetsList(lstJSObject, isInsert);
			}
        }
    }    
}