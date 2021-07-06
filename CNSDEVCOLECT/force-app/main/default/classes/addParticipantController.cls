/**
 * @File Name          : addParticipantController.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 06-03-2020 13:01:40
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    06-03-2020   eayalcor@everis.com     Initial Version
**/
public without sharing class addParticipantController {
    
    @AuraEnabled
    public static WrapperAllow isAllowed(String oppId) {
        WrapperAllow wAllowed = new WrapperAllow();

        Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE Id =: oppId];
        
        if (opp != null && opp.StageName ==  CONSTANTS.HIPOTECARIO_STATUS_CONTACTO && Consorcio_Org__c.getInstance(UserInfo.getProfileId()).Participantes_Sales__c) {
            wAllowed.allowed = true;
            wAllowed.message = Constants.OK;
        }else if(opp != null && opp.StageName ==  CONSTANTS.HIPOTECARIO_STATUS_CONTACTO && !Consorcio_Org__c.getInstance(UserInfo.getProfileId()).Participantes_Sales__c){
            wAllowed.allowed = false;
            wAllowed.message = 'No posee permisos para agregar participantes';
        }else if(opp != null && opp.StageName !=  CONSTANTS.HIPOTECARIO_STATUS_CONTACTO && Consorcio_Org__c.getInstance(UserInfo.getProfileId()).Participantes_Sales__c){
            wAllowed.allowed = false;
            wAllowed.message = 'Sólo se puede incluir participantes en la etapa de Contacto';
        }else{
            wAllowed.allowed = false;
            wAllowed.message = 'Ha ocurrido un problema, favor contactar con el Administrador';
        }
        
        System.debug('Objeto Resultado:' + wAllowed);
        
        return wAllowed;
    }
    
    @AuraEnabled
    public static responseLeadAccount LeadAssign(String rut, String OpportunityId) {
        responseLeadAccount res = new responseLeadAccount();
        List<Id> lstFortransform = new List<Id>();
        String id;
        String opp;
        
        // 1. Validar que el rut ingresado no sea el cliente de la oportunidad, ni un participante de la oportunidad
        Opportunity oppty = [SELECT Id, AccountId FROM Opportunity WHERE Id =: OpportunityId];
        
        List<Account> lstAccount = [SELECT Id, RUT__c, Tipo_de_documento_de_identidad__c, FirstName, LastName, 
                                    Segundo_Apellido_Nectia__pc, PersonBirthdate FROM Account WHERE RUT__c =: rut];
        
        List<participante_sales__c> lstParticipante = [SELECT Id, rut_sales__c FROM participante_sales__c 
                                                       WHERE rut_sales__c =: rut and opportunity_participante_sales__c =: OpportunityId];
        
        if (oppty != null && lstAccount != null && !lstAccount.isEmpty()) {
            for (Account acc : lstAccount) {
                if (acc.Id == oppty.AccountId) {
                    res.errorMessage = 'El rut ingresado corresponde al cliente de la oportunidad';
                    return res;
                }
            }
        }
        
        if (oppty != null && lstParticipante != null && !lstParticipante.isEmpty()) {
            for (participante_sales__c participante : lstParticipante) {
                if (participante.rut_sales__c == rut) {
                    res.errorMessage = 'El rut ingresado ya corresponde a un participante de la oportunidad';
                    return res;
                }
            }
        }
        
        // 2. Si el rut esta ingresado como Account
        if (lstAccount != null && !lstAccount.isEmpty()) {
            for (Account acc : lstAccount) {
                res.isAccount = true;
                res.isLead = false;
                res.id = acc.Id; 
                res.rut = acc.RUT__c;
                res.tipoDocument = acc.Tipo_de_documento_de_identidad__c;
                res.firstName = acc.FirstName;
                res.lastName = acc.LastName;
                res.secondLastName = acc.Segundo_Apellido_Nectia__pc;
                res.accountBirthDate = acc.PersonBirthdate; 
                return res;
            }
        }
        
        // 3. Si el rut esta ingresado como Lead
        List<Lead> lstlead = [SELECT Id, numero_de_documento_sales__c, tipo_documento_sales__c, 
                              FirstName, LastName, fecha_nacimiento_sales__c FROM Lead 
                              WHERE numero_de_documento_sales__c =: rut and IsConverted = false];
        
        // OLD
        /*
        if (lstParticipante != null && !lstParticipante.isEmpty()) {
        	for (participante_sales__c idlstp: lstParticipante) {
          		id = idlstp.Id;
            }
            
            opp = id.right(18).substring(0, 3);
            
            if (opp == 'a0E') {
                res.idPar = opp;
            }
        }
		*/
        if (lstlead !=null && !lstlead.isEmpty()) {
            for (Lead les: lstlead) {
                res.isLead = true;
                res.isAccount = false;
                res.id = les.Id;
                res.rut = les.numero_de_documento_sales__c;
                res.tipoDocument = les.tipo_documento_sales__c;
                res.firstName = les.FirstName;
                res.lastName = les.LastName;
                res.secondLastName = les.LastName;
                res.accountBirthDate = les.fecha_nacimiento_sales__c;
                return res;
            }
        }
        
        return res;
    }
    
    @AuraEnabled
    public static void registerParticipant(String id, Boolean isAccount, Boolean isLead, String rut, String tipoDocument, String firstName, 
                                           String lastName, String secondLastName, String accountBirthDate, String remunerationAccount, String mobileAccount, String OpportunityId) {
        
        // 1. Se debe convertir de Lead -> Account (Si aplica)
        if (isLead && !String.isBlank(id)) {
            Lead lead = [SELECT id, numero_de_documento_sales__c, tipo_documento_sales__c, 
                         FirstName, LastName, fecha_nacimiento_sales__c FROM Lead WHERE id =: id];
            // Update datos existentes
            try {
                lead.FirstName = firstName;
                lead.LastName = lastName;
                lead.motherlastname_sales__c = secondLastName;
                lead.fecha_nacimiento_sales__c = Date.valueOf(accountBirthDate);
                lead.MobilePhone = mobileAccount;
                lead.tipo_documento_sales__c = tipoDocument;
                update lead;
            }
            catch (Exception e) {
                throw new AuraHandledException('Se ha producido un error al actualizar el Lead: ' + e.getMessage());
            }
            
            // Conversión Lead -> Account
            try {
	            List<Database.LeadConvertResult> lcrList = UtilitiesSales.autoConvertLead(new List<Id>{lead.Id});
                
                if (!lcrList[0].isSuccess()) {
                    throw new AuraHandledException('Error en conversión Lead -> Account');
                }
                
                id = lcrList[0].getAccountId();
                System.debug('AccountId (Converted) -> ' + id);
                isAccount = true;
                isLead = false;
            }
            catch (Exception e) {
                system.debug('EXCEPTION CONVERT--->'+e.getMessage());
                throw new AuraHandledException('Error en conversión Lead -> Account: ' + e.getMessage());
            }
        }
                                               
        // 2. Crear nuevo Account (si aplica)
        if (isAccount && String.isBlank(id)) {
            
            List<Account> accList = [SELECT Id, rut__c, Tipo_de_documento_de_identidad__c,FirstName,LastName,Segundo_Apellido_Nectia__pc,PersonBirthdate, Phone, Renta_Nectia__pc 
                                      FROM Account where RUT__c =: rut];
            
            System.debug('Largo lista' + accList.size());
            
            if(accList == null || accList.isEmpty()){
                System.debug('ENTRA A ADD ACCOUNT');
                Account acc = new Account();
                acc.RUT__c = rut;
                acc.Tipo_de_documento_de_identidad__c = tipoDocument;
                acc.FirstName = firstName;
                acc.LastName = lastName;
                acc.Segundo_Apellido_Nectia__pc = secondLastName;                                        
                acc.PersonBirthdate = Date.valueOf(accountBirthDate);
                acc.Phone = mobileAccount;
                acc.Renta_Nectia__pc = remunerationAccount;
                acc.recordTypeId=[SELECT Id FROM RecordType WHERE developerName='Cliente_Persona_Seguros' LIMIT 1].Id;
                accList.add(acc);
            }
            
            try {
                upsert accList;
                id = accList[0].Id;
            }
            catch (Exception e) {
                throw new AuraHandledException('Error en la creación de nueva Account: ' + e.getMessage());
            }
            
            
        }
                                               
        // 3. Finalmente, se ingresa el participante
        participante_sales__c participante = new participante_sales__c();
        participante.rut_sales__c = rut;
        participante.tipo_documento_sales__c = tipoDocument;
        participante.Name = firstName + ' ' + lastName + ' ' + secondLastName;
        participante.remuneracion_sales__c = Double.valueOf(remunerationAccount);
        participante.telefono_movil_sales__c = mobileAccount;
        participante.estado_participante_sales__c = CONSTANTS.PARTICIPANT_ESTADO_VIGENTE;
        participante.opportunity_participante_sales__c = OpportunityId;
        participante.Cliente_sales__c = id;
        
        try {
            insert participante;
        } catch(Exception e) {
            throw new AuraHandledException('Error al ingresar Participante: ' + e.getMessage());
        }
    }
    
    public class responseLeadAccount {
        @AuraEnabled public Boolean isAccount;
        @AuraEnabled public Boolean isLead;
        @AuraEnabled public String idPar;
        @AuraEnabled public String id; 
        @AuraEnabled public String rut;
        @AuraEnabled public String tipoDocument;
        @AuraEnabled public String firstName;
        @AuraEnabled public String lastName;
        @AuraEnabled public String secondLastName;
        @AuraEnabled public date accountBirthDate;
        @AuraEnabled public String errorMessage;
    }

    public class WrapperAllow{
        @AuraEnabled public Boolean allowed;
        @AuraEnabled public String message;  
    }
    
}