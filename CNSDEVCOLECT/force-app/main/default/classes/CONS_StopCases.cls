public  with sharing  class CONS_StopCases {
      ApexPages.StandardSetController setCon;

    public CONS_StopCases(ApexPages.StandardController controller) {
        
    }

    public CONS_StopCases(ApexPages.StandardSetController controller) {
        setCon=controller;
    }
    
    

    public PageReference  Stopcases(){
        list<Case>	Casos = [SELECT Id, CaseNumber, IsStopped,RecordType.name FROM Case where IsClosed=false and RecordType.name='Casos_Corredora'];
        System.debug('Casos=='+Casos);
        for(integer i=0;i<Casos.size();i++){
            Casos.get(i).IsStopped=true;
        }

        System.debug('Casos1=='+Casos);
        update casos;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,'Todos los casos abiertos han sido pausado.');
        ApexPages.addMessage(myMsg); 
        return null;
    }
    
    public PageReference  StartCases(){
        list<Case>	Casos = [SELECT Id, CaseNumber, IsStopped FROM Case where IsClosed=false and RecordType.name='Casos_Corredora'];
        System.debug('Casos=='+Casos);
        for(integer i=0;i<Casos.size();i++){
            Casos.get(i).IsStopped=false;
        }

        System.debug('Casos1=='+Casos);
        update casos;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,'Todos los casos abiertos que se encontraban pausados  han sido reactivados.');
        ApexPages.addMessage(myMsg); 
        return null;
    }
     public PageReference  continuar(){
          
        PageReference pageRef = new PageReference('/500');
        pageRef.setRedirect(true);
        return pageRef;
    }
  
   
}