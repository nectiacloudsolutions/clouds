public class renderEmailNAController {
 Public String body {get;set;}
    Public Id IdAcc {get;set;}
    public renderEmailNAController() {
        try {
            List<Account> acc = [SELECT Id, Name, Rut__c FROM Account WHERE Id =: ApexPages.currentPage().getParameters().get('IdAcc') LIMIT 1];
            if(!acc.isEmpty()){
                List<EmailTemplate> et = [SELECT Id,body,DeveloperName,HtmlValue, Markup, Name 
                                          FROM EmailTemplate Where DeveloperName =: Constants.TEMPLATE_PDF_LEGAL_NOTAGREE LIMIT 1];
                if(et.isEmpty()){
                    body = Constants.TEMPLATE_PDF_ERROR_TEMPLATE;
                }else{
                    body = et[0].Body.replace('##NAME##', acc[0].Name);
                    body = body.replace('##RUT##', UtilitiesSales.formatRut(acc[0].Rut__c, Constants.WITHDOT));
                    body = body.replace('##FECHA##', String.valueOf(Date.Today().format()));
                } 
            }else{
                body = Constants.CASE_ERROR_ACNOTFOUND;
            }         
        } catch(exception e) {
            body = Constants.TEMPLATE_PDF_ERROR +' : ' +e.getMessage() + ' ' +e.getStackTraceString(); 
        }
    }
}