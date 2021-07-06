/*********************************************************************************************************
@Author       eayalcor@everis.com
@name         UtilitiesSales
@CreateDate   01/10/2019
@Description  UtilitiesSales class for Sales cloud
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
01/10/2019                    eayalcor@everis.com           Initial Version
14/01/2020					  eayalcor@everis.com			ADD Profile Injection Lead
**********************************************************************************************************/
public without sharing class UtilitiesSales {
    /**
      * @description       This method sets a flag field required for a process builder that sends a notification
      * @param1            RUT del ejecutivo
      * @return            String ID of the account or lead that have RUT
      * @throws            NA
	*/
    public static boolean notifyExecutive(String leadId){
        List<Lead> u = [SELECT Id, Flag_Notificacion_Propietario_sales__c FROM Lead Where Id =: leadId LIMIT 1];
        List<Account> lstAccount = [SELECT Id, Flag_Propietario_Cliente_sales__c FROM Account 
                               WHERE Id =: leadId LIMIT 1];
        
        if(u != null && !u.isEmpty()){
            u[0].Flag_Notificacion_Propietario_sales__c = true;
            update u;
            return true;
        }
        if(lstAccount != null && !lstAccount.isEmpty()){
            lstAccount[0].Flag_Propietario_Cliente_sales__c = true;
            update lstAccount;
            return true;
        }
       
		 return false;        
    }
    /**
      * @description       This method verify if the RUT is an account or lead
      * @param1            RUT del ejecutivo
      * @return            String ID of the account or lead that have RUT
      * @throws            NA
	*/
    public static string validateSingleRUT(String RUT){
        String result = null;
        if(!String.isBlank(RUT)){
            system.debug('Inside If ');
            List<Account> accListResult = [SELECT id, OwnerId  FROM Account WHERE Tipo_de_documento_de_identidad__c =: Constants.RUT AND rut__c=:RUT];
            List<Lead> leadListResult = [SELECT id,OwnerId FROM lead WHERE numero_de_documento_sales__c	=:RUT];
            if(!accListResult.isEmpty()){
                system.debug('Found Acc ');
                result = accListResult[0].id;
            }else if(!leadListResult.isEmpty()){
                system.debug('Found Lead ');
                result = leadListResult[0].id;
            }
        }
        return result;
    }

    /**
      * @description       This method return Maps with List Accounts and Leads
      * @param1            Set<String> RUT del ejecutivo - Format field RUT 11111111-1
      * @return            Map<String,List<sObjects>> List Account . List Leads
      * @throws            NA
	*/
    public static Map<String,List<SObject>> existAccountLead(Set<String> rut){
        Map<String,List<SObject>> mapObject = new Map<String,List<SObject>>();

        List<Account> lstAccount = [SELECT Id,Rut__c,OwnerId,name FROM Account 
                                WHERE (Tipo_de_documento_de_identidad__c =: Constants.RUT 
                                AND rut__c IN : rut) OR (rut__c IN : rut)];

        List<Lead> lstLead = [SELECT Id, numero_de_documento_sales__c, rut_ejecutivo_sales__c,OwnerId,Email,Phone,total_tareas_sales__c, Status FROM Lead 
                            WHERE numero_de_documento_sales__c IN : rut];
        
        if(lstLead != null && !lstLead.isEmpty()){
            List<User> lstLeadOwner = [SELECT Id, Name FROM User where Id =: lstLead[0].OwnerId];
            mapObject.put(Constants.LEAD_OWNER, lstLeadOwner);
        }
         if(lstAccount != null && !lstAccount.isEmpty()){
            List<User> lstAccountOwner = [SELECT Id, Name FROM User where Id =: lstAccount[0].OwnerId];
            mapObject.put(Constants.ACCOUNT_OWNER, lstAccountOwner);
        }
        
        
        mapObject.put(Constants.ACCOUNT, lstAccount);
        mapObject.put(Constants.LEAD, lstLead);
     


        return mapObject;
    }

    /**
      * @description       This method return Maps with the Rut and Id executive
      * @param1            Set<String> RUT del ejecutivo - Format field RUT 11111111-1
      * @return            Map<String,Id> List Account . List Leads
      * @throws            NA
	*/
    public static Map<String,Id> getIdsExecutive(Set<String> rutExecutive){
        Map<String,Id> maps = new Map<String,Id>();

        for(User u : [SELECT Id,Rut__C FROM User WHERE Rut__C IN : rutExecutive AND isActive = true AND profileId IN : getProfileInjectionLead()]){
            maps.put(u.Rut__c, u.Id);
        }

        return maps;
    }
    
    
    
      /**
      * @description       This method validate the RUT Field (Algoritm mod11)
      * @param1            Set<String> RUT to validated
      * @return            Boolean, True if is valid otherwise false
      * @throws            NA
	  */
    public static boolean validarRunRut(String runRut){
        Integer[] factores = new Integer[]{7, 6, 5, 4, 3, 2, 7, 6, 5, 4, 3, 2};
        if (runRut.length() > 2){
            Integer indFactor = factores.size() - 1;
            string cadnumero = runRut.substring(0,runRut.length()-2);
            string guion = runRut.substring(runRut.length()-2, runRut.length()-1);           
            string digitoverificador = runRut.substring(runRut.length()-1);           
            string digitoCalculado;
            Integer calculodigito = 0;
            if (guion == '-' && cadnumero.isNumeric()){
                for (Integer i = cadnumero.length() - 1; i >= 0; i--) {                   
                    calculodigito = calculodigito + (factores[indFactor]*Integer.valueof(cadnumero.substring(i,i+1)));
                    indFactor--;
                }
                Integer resultadoModulo = 11 - (math.mod(calculodigito,11));
                if (resultadoModulo == 11){
                    digitoCalculado = '0';
                } else if (resultadoModulo == 10) {
                    digitoCalculado = 'K';
                } else {
                    digitoCalculado = string.valueof(resultadoModulo);
                }
                System.debug('DigitoCalculado: ' + digitoCalculado);
                if (digitoCalculado != digitoverificador){
                    return false;
                }
            } else {
                System.debug('Primer false');
                return false;
            }
        } else {
            System.debug('Segundo false');
            return false;
        }
        return true;
    }

    /**
      * @description       This method evaluate the field required for the Lead Object 
      * @param1            Lead lead
      * @return            ValidateData data
      * @throws            NA
	**/
    public static ValidateData evaluateRequiredDataLead(Lead lead){
        ValidateData data = new ValidateData();
        data.isValid = false;

        System.debug('LEAD TO VALIDATE : '+ lead);

        System.debug('Validate contact data');
        if(String.isBlank(Lead.Phone) && String.isBlank(Lead.Email) && String.isBlank(Lead.other_phone_sales__c)){
            data.error = 'ERROR_DATACONTACT';
        }else if(String.isBlank(Lead.rut_ejecutivo_sales__c)){
            data.error = 'ERROR_RUTEXECUTIVE'; 
        }else if(Lead.sla_sales__c == null){
            data.error = 'ERROR_SLA';
        }else if(String.isBlank(Lead.Rating) || Lead.Rating == null){
            data.error = 'ERROR_RATING';
        }else if(String.isBlank(Lead.Lastname) || Lead.Lastname == null){
            data.error = 'ERROR_LASTNAME';
        }else if(String.isBlank(Lead.LeadSource) || Lead.LeadSource == null){
            data.error = 'ERROR_LEADSOURCE';
        }else if(!String.isBlank(Lead.numero_de_documento_sales__c)){
            if(!validarRunRut(Lead.numero_de_documento_sales__c)){
                data.error = 'ERROR_FORMATRUT';
            }else{
                data.error = 'OK';
                data.isValid = true;
            }
        }else{
            data.error = 'OK';
            data.isValid = true;
        }

        System.debug('VALIDATE DATA: '+ data);

        return data;
    }

    /**
      * @description       This method formated rut with o whithout dots
      * @param1            String rut , String typeFormat (WITHDOT/WITHOUTDOT)
      * @return            String formatRut
      * @throws            NA
	*/
    public static String formatRut(String rut, String typeFormat){

        Integer cont = 0;
        String format;

        try{
            rut = rut.contains('.') ? rut.replace('.', '') : rut;
            rut = rut.contains('-') ? rut.replace('-', '') : rut;
            format = '-' + rut.substring(rut.length() - 1);
            for (Integer i = rut.length() - 2; i >= 0; i--) {
                format = rut.substring(i, i + 1) + format;
                cont++;
                if (cont == 3 && i != 0 && typeFormat.equals('WITHDOT')) {
                    format = '.' + format;
                    cont = 0;
                }
            }
        }catch(Exception e){
            format = null;
        }
    
        return format;
    }


   
    /**
      * @className         ValidateData
      * @description       Class utility for return valid data 
	**/
    public Class ValidateData{
        public String error {get;set;}
        public Boolean isValid{get;set;}
    }
    
    /**
      * @description       This method re-asign the owner of a case
      * @param1            String leadId , String newOwnerId ID del nuevo owner
      * @return            True if was successfully found and update
      * @throws            NA
	**/
    public static boolean changeLeadOwner(String leadID, String newOwnerId){
        boolean res = False;
        system.debug('LeadId'+leadID);
        List<lead> leadList = [SELECT id, ownerId FROM Lead Where id =:leadID];
        System.debug('Cantidad '+leadList);
        if(leadList.size()>0){
            leadList[0].ownerId = newOwnerId;
            update leadList;
            res = true;
        }
        System.debug('Res ---->'+res);
        return res;
    }

    /**
      * @description       This method return List Lead By Id
      * @param1            List<Id> Id Leads
      * @return            List<Lead> lstLeads
      * @throws            NA
	*/
    public static List<Lead> getLeadByIds(List<Id> idsLeads){

        List<Lead> lstLeads = [SELECT Id,Flag_Lead_sales__c, numero_de_documento_sales__c, rut_ejecutivo_sales__c,OwnerId,Email,Phone,total_tareas_sales__c,Status,Name FROM Lead 
                            WHERE Id IN : idsLeads];
        return lstLeads;
    }
    /**
      * @description       This method auto convert Lead
      * @param1            List<Id> leadIds
      * @return            List<Database.LeadConvertResult> Error/Success convert Lead
      * @throws            NA
	**/
    public static List<Database.LeadConvertResult> autoConvertLead(List<Id> leadIds)
    {
        List<Database.LeadConvertResult> lcr;
        //Get Status convert Lead. 
        LeadStatus cLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        List<Database.LeadConvert> massLeadconvert = new List<Database.LeadConvert>();
        for(Id currentlead: leadIds){
            Database.LeadConvert leadConvert = new Database.LeadConvert();
            leadConvert.setLeadId(currentlead);                
            leadConvert.setConvertedStatus(cLeadStatus.MasterLabel);
            leadConvert.setDoNotCreateOpportunity(TRUE); //Don't create opportunity to convert.
            //leadConvert.setOverwriteLeadSource(TRUE);
            massLeadconvert.add(leadConvert);
        }
        SYSTEM.debug('MASS LEAD CONVERT'+massLeadconvert);
        if (!massLeadconvert.isEmpty()) {

                lcr = Database.convertLead(massLeadconvert);
    			System.debug('Lead: '+lcr);
        }
        
        return lcr;
    }

    /**
      * @name              SalesException 
      * @description       Exception custom Sales project
	**/
    public class SalesException extends exception{}

    /**
    * @description method that searches for the product object with a Quote id
    * @author pcelis@everis.com | 16-12-2019 
    * @param String recordId 
    * @return List<Product2> 
    **/
    public static List<Product2> getProduct2ByQuoteId(String recordId){
         
        List<QuoteLineItem> lstLineIt=[SELECT PricebookEntryId,Id FROM QuoteLineItem WHERE QuoteId=:recordId];
        List<PricebookEntry> ListPri=[SELECT Product2Id FROM PricebookEntry WHERE Id=:lstLineIt[0].PricebookEntryId ];
        List<Product2> lstPro=[SELECT codigo_producto_sales__c,Codigo_Macroproducto_Operacional_sales__c   FROM Product2 WHERE Id=:ListPri[0].Product2Id];
        
        return lstPro;
    }
    
    /**
    * @description method that return List<String> with the name of profiles
    * @author eayalcor@everis.com 
    * @return List<Id> 
     */
    private static List<Id> getProfileInjectionLead(){
        List<String> lstNames = new List<String>();
        
        List<ProfileInjectionLead__c > lstProfile = new List<ProfileInjectionLead__c>();
        
        lstProfile = [Select Name, ProfileName__c
                        From  ProfileInjectionLead__c];
        
        for(ProfileInjectionLead__c lst : lstProfile){
            lstNames.add(lst.ProfileName__c);
        }
        
        List<Id> lstIds = new List<Id>();

        List<Profile> lstPro = [SELECT Id FROM Profile WHERE Name IN : lstNames];
        for(Profile pro : lstPro){
            lstIds.add(pro.Id);
        }
        
        return lstIds;
    }

    /**
    * @description Obtener Value/Label de una picklist
    * @author eayalcor@everis.com | 1/20/2020 
    * @param Schema.sObjectField fieldToken 
    * @return List<Data> 
    **/
    public static List<String> getPicklistData(Schema.sObjectField fieldToken){
        List<String> lstData = new List<String>();
        Schema.DescribeFieldResult fieldResult = fieldToken.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();

        for( Schema.PicklistEntry value : values) {
            lstData.add(value.getValue());
        }

        return lstdata;
    }

    /**
    * @description Obtener dependencias, Valor controlador + Dependencias.
    * @author eayalcor@everis.com | 1/20/2020 
    * @param Schema.sObjectField dependToken 
    * @return Map<String, List<String>> 
    **/
    public static Map<String, List<String>> getDependentPicklistValues(Schema.sObjectField dependToken) {
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return new Map<String, List<String>>();
        }
    
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
    
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
                List<String> base64chars =
                        String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    Object controlValue =
                            (controlEntries == null
                                    ?   (Object) (index == 1)
                                    :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                            );
                    Integer bitIndex = index / 6, bitShift = 5 - Math.mod( index, 6 );
                    if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                        continue;
                    if (!dependentPicklistValues.containsKey((String) controlValue)) {
                        dependentPicklistValues.put((String) controlValue, new List<String>());
                    }
                    dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
                }
            }
        }
        return dependentPicklistValues;
    }

	/**
	* @description 
	* @author pcelisbe@everis.com | 30-01-2020 
	* @param Set<String> codPro 
	* @return Map<String, Product2> 
	**/
	public static Map<String,Product2> getProduct(Set<String> codPro){
        Map<String,Product2> maps = new Map<String,Product2>();
        List<Product2> lstProduct = new List<Product2>();
        //Set<String> tipProd = new Set<String>();
        Set<String> rType = new Set<String>();
        for(Product2 p : [SELECT Id,Name,tipo_producto_sales__c,codigo_producto_sales__c,Description,ProductCode,(SELECT id,Pricebook2Id,Product2Id FROM PricebookEntries WHERE IsActive=true) test FROM Product2 WHERE ProductCode IN : codPro ]){
            //maps.put(p.codigo_producto_sales__c, p);
            //System.debug(p.PricebookEntries);
            lstProduct.add(p);
            rType.add(p.tipo_producto_sales__c) ;

        }
    
        List<RecordType> rT =[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName IN : rType];

        for(Product2 pro : lstProduct){
            for(RecordType rct : rT){
                if(pro.tipo_producto_sales__c.equalsIgnoreCase(rct.DeveloperName) && pro.PricebookEntries!=null){
                    pro.Description = rct.Id+'/'+pro.PricebookEntries[0].id+'/'+pro.PricebookEntries[0].Pricebook2Id+'/'+pro.name+'/'+pro.ProductCode;
                    maps.put(pro.ProductCode, pro);
                    break;
                }
            }
        }

        return maps;
    } 

    /**
    * @description 
    * @author eayalcor@everis.com | 4/20/2020 
    * @return Map<Id, String> 
    **/
    public static Map<Id,String> getSpecifictRTypeOpp(List<String> lstValues){
        Map<Id,String> mapRcd = new Map<Id,String>();
        List<RecordType> lstRcd = new List<RecordType>();

        lstRcd = [SELECT Id,DeveloperName FROM RecordType WHERE SobjectType =: Constants.OPPORTUNITY];

        for(Recordtype rt : lstRcd){
            for(String value : lstValues){
                if(value.equalsIgnoreCase(rt.DeveloperName)){
                    mapRcd.put(rt.Id, rt.DeveloperName);
                }
            }
        }

        return mapRcd;
    }          

    /**
    * @description 
    * @author eayalcor@everis.com | 4/20/2020 
    * @param Set<Id> lstIds 
    * @return Map<Id, Opportunity> 
    **/
    public static Map<Id,Opportunity> getOppByIds(Set<Id> lstIds){
        Map<Id,Opportunity> mapOpp = new Map<Id,Opportunity>();
        List<Opportunity> lstOpp = [SELECT Id,RecordTypeId,StageName,Name,Estado_Generacion_y_Entrega_sales__c,
                        Fecha_de_Cambio_de_Estado_Entrega_sales__c,Estado_activacion_sales__c,Fecha_cambio_estado_activacion_sales__c FROM Opportunity
                        WHERE Id IN : lstIds];

        for(Opportunity opp : lstOpp){
            mapOpp.put(opp.Id, opp);
        }

        return mapOpp;
    } 

    /**
    * @description 
    * @author eayalcor@everis.com | 4/20/2020 
    * @return Map<String, String> 
    **/
    public static Map<String,FinalStageBancaBE__c> getStageFinalBE(String product){
        List<FinalStageBancaBE__c> lstfStage = [SELECT Name,FinalStatus__c,Id_Stage__c,Product_Bank__c,Stage__c,
                                Id_FinalStatus__c  FROM FinalStageBancaBE__c];
        Map<String,FinalStageBancaBE__c> mapStageFinal = new Map<String,FinalStageBancaBE__c>();

        for(FinalStageBancaBE__c tmp : lstfStage){
            mapStageFinal.put(tmp.Name, tmp);
        } 

        return mapStageFinal;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 5/18/2020 
    * @param String product 
    * @return Map<String, String> 
    **/
    public static Map<String,String> getReasonLossBE(String product){
        List<LossReasonBank__c> lstLoss = [SELECT Name,ReasonSF__c,Product_Bank__c FROM LossReasonBank__c];
        Map<String,String> mapLoss = new Map<String,String>();

        for(LossReasonBank__c tmp : lstLoss){
            mapLoss.put(tmp.Name, tmp.ReasonSF__c);
        } 

        return mapLoss;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 6/1/2020 
    * @param String family 
    * @return string 
    **/
    public static string  getRTbyFamilyProduct(String family){
        List<Product2> lstProduct = [SELECT tipo_producto_sales__c FROM Product2 
                        WHERE Family =: family LIMIT 1];
        
        if(lstProduct!= null && !lstProduct.isEmpty()){
            return lstProduct[0].tipo_producto_sales__c;
        }else{
            return NULL;
        }
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 6/1/2020 
    * @param List<id> lstIdsOpp 
    * @return Map<Id, Boolean> 
    **/
    public static Map<Id,Boolean> validateHasPlanPlus(List<id> lstIdsOpp){
        List<id> lstAcc = new List<id>();
        for (Opportunity Opp :[SELECT AccountId FROM Opportunity WHERE Id IN :lstIdsOpp]) {
            lstAcc.add(Opp.AccountId);
        }
        Map<Id,Boolean> mpsV= new  Map<Id,Boolean> ();
        for (Opportunity opp : [select Id,AccountId from Opportunity where (RecordType.DeveloperName=:Constants.RECORDTYPE_BANCA_PLAN_PLUS or  RecordType.DeveloperName=:Constants.RECORDTYPE_BANCA_PLAN_PLUS_LECTURA) and StageName!=:Constants.OPPORTUNITY_STAGENAME_CIERRE_PERDIDA and AccountId IN :lstAcc ]) {
            mpsV.put(opp.AccountId,true);
        }
        Return mpsV;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 07-07-2020 
    * @param String rut 
    * @return String 
    **/
    public static String cleanRut(String rut){
        if(rut != null && rut.contains('-')) { 
            rut = rut.remove('-');
        } else{
            return rut;
        }
        return rut;
    }
    
    public static String getRutExecutiveWithDot(Id idExcutive,String format){
        String rut = [SELECT Rut__C FROM User WHERE Id=:idExcutive LIMIT 1].Rut__c;

        return formatRut(rut, format);
    }


    /**
    * @description 
    * @author eayalcor@everis.com | 08-05-2020 
    * @param Map<String String> mapMetadata 
    * @return String 
    **/
    public static String generateMetadataDocuware(Map<String,String> mapMetadata){
        String xmlMeta = '<IndexList>';
        for(String key : mapMetadata.keySet()) {
            xmlMeta = xmlMeta + '<Index Label="' + key + '" Value="' + mapMetadata.get(key) + '"/>';
        }

        xmlMeta = xmlMeta + '</IndexList>';

        return xmlMeta;
    }
    
    /**
    * @description 
    * @author eayalcor@everis.com | 08-12-2020 
    * @param List<SObject> lstObj 
    * @return Map<String, String> 
    **/
    public static Map<String,String> getManagerIdbyOwner(List<SObject> lstObj){
        Set<String> lstIds = new Set<String>();
        Map<String,String> mapUsrManager = new Map<String,String>();

        for(SObject sobj : lstObj){
            lstIds.add(String.valueOf(sobj.get('OwnerId')));
        }

        List<User> lstUser = [SELECT Id,ManagerId FROM USER WHERE Id IN : lstIds];

        for(User usr : lstUser){
            mapUsrManager.put(usr.Id, usr.ManagerId);
        }

        return mapUsrManager;
    }
    
    /**
    * @description 
    * @author eayalcor@everis.com | 08-14-2020 
    * @param String objectType 
    * @return Map<String, String> 
    **/
    public static Map<String,String> getSlaProcessByType(String objectType){
        
        Map<String,String> mapsSlasProcess = new Map<String,String>();
        List<String> nameList = new List<String>();
        List<SLAProcessSales__c> csList = [SELECT Name FROM SLAProcessSales__c WHERE Object_Type__c =:objectType];
        
        for(SLAProcessSales__c cs : csList){
        	nameList.add(cs.Name);   
        }
        List<SlaProcess> slaList = [SELECT Id,Name FROM SlaProcess WHERE Name IN : nameList];
        
        for(SlaProcess slas : slaList){
        	mapsSlasProcess.put(slas.Id,slas.Name);  
        }
        
        return mapsSlasProcess;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 08-20-2020 
    * @return Map<String, Integer> 
    **/
    public static Map<String,Integer> getCaseFieldNotify(){
        Map<String,Integer> mapsFields = new Map<String,Integer>();
        List<CaseNotifiesToAnalytics__c> lstCaseNotify = [SELECT IdTipoMarca__c,SalesforceField__c FROM CaseNotifiesToAnalytics__c];
        for(CaseNotifiesToAnalytics__c tmp : lstCaseNotify){
            mapsFields.put(tmp.SalesforceField__c, (Integer)tmp.IdTipoMarca__c);
        } 
        return mapsFields;
    }
    
    /**
    * @description 
    * @author eayalcor@everis.com | 08-20-2020 
    * @return Map<String, Integer> 
    **/
    public static Map<String,String> getRutByIdExecutive(Set<Id> lstIds){
        Map<String,String> mapsFields = new Map<String,String>();
        List<User> lstExecutive = [SELECT Id,Rut__c FROM User WHERE Id IN : lstIds];
        for(User tmp : lstExecutive){
            mapsFields.put(tmp.Id, formatRut(tmp.Rut__c,Constants.WITHOUTDOT));
        } 
        return mapsFields;
    }

    public static String homologateCode(String origin,  List <Codigo_Origen_CMF__mdt> cmfCodes){
        for(Codigo_Origen_CMF__mdt code : cmfCodes){
            if(origin == code.MasterLabel){
                return String.ValueOf(code.value__c);
            }
        }
        return '';
    }

    public static void shareFileToUserProfile(string contentVersionId){
        String integracionBancoUserId = '0051N000006zBJkQAM';
        String systemAdministratorProfileId = '00e1N000001ztV3QAI';
        String ownerProcessId = '0051N000005HvBOQA0'; // debe ser el id del usuario que ejecuta el proceso

        List<User> lstUserSystemAdministrator = [SELECT Id FROM User WHERE ProfileId=:systemAdministratorProfileId and IsActive=true];
        
        for(User listUser: lstUserSystemAdministrator){
            if(listUser.id != ownerProcessId){
                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersionId].ContentDocumentId;
                ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId = listUser.id;
                conDocLink.ContentDocumentId = conDoc;
                conDocLink.shareType = 'V';
                insert conDocLink;  
            } 
        }

        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersionId].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = integracionBancoUserId;
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;    

    }
    

    public static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
        
        Set<ID> currentRoleIds = new Set<ID>();
        for(UserRole userRole :[select Id from UserRole where ParentRoleId IN :roleIds AND ParentRoleID != null]) {
            currentRoleIds.add(userRole.Id);
        }

        if(currentRoleIds.size() > 0) {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
        return currentRoleIds;
    }

    public static Set<ID> getParentRoleId(Set<ID> roleIds) {
        Set<ID> currentRoleIds = new Set<ID>();
        for(UserRole ur :[select Id, ParentRoleId from UserRole where Id IN: roleIds]) {
            currentRoleIds.add(ur.ParentRoleId);
        }

        if(currentRoleIds.size() > 0) {
            currentRoleIds.addAll(getParentRoleId(currentRoleIds));
        }
        return currentRoleIds;
    }
    
    public static Map<String,String> getCompanyName(){
        Map<String,String> mapsFields = new Map<String,String>();
        List<CompanyNameListUsr__c> lstCompanyName = [SELECT Name,CompanyNameSalesForce__c FROM CompanyNameListUsr__c];
        for(CompanyNameListUsr__c tmp : lstCompanyName){
            mapsFields.put(tmp.Name, tmp.CompanyNameSalesForce__c);
        } 
        return mapsFields;
    }
    
    public static Map<String,String> getSucursalName(){
        Map<String,String> mapsFields = new Map<String,String>();
        List<SucursalNameUsr__c> lstSucursalName = [SELECT Name,NombreApiSalesForce__c FROM SucursalNameUsr__c];
        for(SucursalNameUsr__c tmp : lstSucursalName){
            mapsFields.put(tmp.Name, tmp.NombreApiSalesForce__c);
        } 
        return mapsFields;
    }
    
}