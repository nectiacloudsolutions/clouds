/*********************************************************************************************************
@Author       fbizamam@everis.com
@name         dataAuthorizationController
@CreateDate   04/08/2020
@Description  Bussines logic for the dataAuthorization component
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
04/08/2020                    fbizamam@everis.com                Initial Version
**********************************************************************************************************/
public class dataAuthorizationController {
    
    @AuraEnabled
    public static String viewDoc(Id IdAcc){
        PageReference pdf = Page.renderEmailTemplate;
        pdf.getParameters().put('IdAcc',IdAcc);
        //Blob body = pdf.getContentAsPdf();
        
        Blob body;
        if(Test.isRunningTest()){
            body = Blob.valueOf('Test.Unitario');
        }else{
            body = pdf.getContentAsPdf();
        }

        String base64 = EncodingUtil.base64Encode(body);
        return base64;   
    } 
    public static Set<Id> lstIds = new Set<Id>();
    @AuraEnabled
    public static String DataAuthorizeAndInsertCase(Id idAcc){
        List<DTOCaseAnalytics.CaseTmp> lstCaseNotify = new List<DTOCaseAnalytics.CaseTmp>();
        try{
            system.debug(idAcc);
            Account ac = [SELECT Rut__c FROM Account WHERE Id =: idAcc];
            Id UserId = UserInfo.getUserId();
            User us = [SELECT Id FROM User WHERE Id =: UserId];
            List<RecordType> rt = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_CASE_CORPORATIVOS LIMIT 1];
            if(!rt.isEmpty()){
                Case csToInsert = new Case();
                csToInsert.AccountId = idAcc;
                csToInsert.Subject = Constants.CASE_SUBJECT_DEFAULT;
                csToInsert.Rut_del_Cliente__c = ac.Rut__c;
                csToInsert.Description = Constants.CASE_DESCRIPTION_AUTORIZA;
                csToInsert.Origin = Constants.CASE_CASE_ORIGIN_PRESENCIAL;
                csToInsert.RecordTypeId = rt[0].Id;
                csToInsert.Type = Constants.CASE_TYPE_SOLICITUD;
                csToInsert.Subtipo__c = Constants.CASE_SUBTIPO_AUTORIZA;
                csToInsert.Status = Constants.CASE_STATUS_NUEVO;
                csToInsert.OwnerId = UserId;
                csToInsert.Comparte_Datos__c = Constants.CASE_COMPARTEDATOS_SI;
                insert csToInsert;
                Case InsertedCase = new Case();
                InsertedCase = [SELECT Id, Rut_del_Cliente__c, CaseNumber, CreatedById, Subject, Description,RecordTypeId, type, AccountId,Origin,Subtipo__c, Status,OwnerId,Comparte_Datos__c FROM Case Where Id =: csToInsert.Id LIMIT 1];
                lstCaseNotify.add(generatWrapperCaseTmp(InsertedCase,'Comparte_Datos__c'));   
                if(!lstCaseNotify.isEmpty() && lstCaseNotify != null){
                    DTOCaseAnalytics.ListCaseTmp lstJson = new DTOCaseAnalytics.ListCaseTmp();
                    lstJson.lstCase = lstCaseNotify;
                    System.debug('List Ids:' + lstIds);
                    SalesCallout.notifyBrand(JSON.serialize(lstJson),Constants.ANALYTICSMARCA,lstIds);
                }
                ac.Autoriza_uso_de_datos__c = true;
                update ac;
                
            }

            
            return Constants.TEMPLATE_PDF_SUCCESS;
        }catch(Exception e){
            system.debug(e.getMessage());
            system.debug(e.getStackTraceString());
             return Constants.NOK;
        }
    }
    
    
    
    @AuraEnabled 
    public static String getAccessPerfilEjecutivo() {
        Profile p = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId() LIMIT 1];
        String perfil = p.Name;
        List<CaseDataFunctionality__c> func = [SELECT Id, Name FROM CaseDataFunctionality__c WHERE funcionalidad__c=: CONSTANTS.CASE_FUNCTIONALITY_NAME
                                       and perfil__c =: perfil LIMIT 1];
        String retorno = Constants.NOK;
        if (func.size()>0){
            retorno=CONSTANTS.OK; 
        }
        return retorno;
    }
    
    private static DTOCaseAnalytics.CaseTmp generatWrapperCaseTmp(Case tmp, String field){
        DTOCaseAnalytics.CaseTmp obj = new DTOCaseAnalytics.CaseTmp();
        obj.id = tmp.Id;
        obj.ownerId = tmp.OwnerId;
        obj.createdId = tmp.CreatedById;
        obj.fieldName = field;
        obj.caseTmp = tmp;
        
        if(!lstIds.contains(tmp.OwnerId)){lstIds.add(tmp.OwnerId);}
        if(!lstIds.contains(tmp.CreatedById)){lstIds.add(tmp.CreatedById);}
        
        return obj;
    }
}