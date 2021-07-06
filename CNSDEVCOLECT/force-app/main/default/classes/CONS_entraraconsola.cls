public with sharing class CONS_entraraconsola{
    public string id {get;set;}
public CONS_entraraconsola(ApexPages.StandardController controller) {
       
        id = ApexPages.currentPage().getParameters().get('id');
       system.debug('id'+id);
       
    }
}