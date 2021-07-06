public class Cons_TomarCaso {
    public string caseid { get;set; }
    public Id userid { get;set; } 

	public Cons_TomarCaso(ApexPages.StandardController controller) {
    }
    
    public PageReference redirige(){
        System.debug('Ingresando al caso y recopilando información...');
   	    caseid = ApexPages.currentPage().getParameters().get('id');
		userid = UserInfo.getUserId();
        User nameuserid = [SELECT Name FROM User WHERE Id =: userid];
        System.debug('Case ID: '+caseid+' User Id: '+userid+' Name: '+nameuserid);
        Case datos_caso = [SELECT Id, OwnerId FROM Case WHERE Id =: caseid];
        datos_caso.OwnerId = userid;
        
        update datos_caso;
        
		System.debug('Nuevo owner del caso: '+datos_caso.OwnerId);
        PageReference pageref = new PageReference('/' + caseid);
        pageref.setRedirect(true);
        return pageref;
    }
    
    public PageReference volver(){
        
        PageReference pageRef = new PageReference('/');
        return pageRef;
    }
}