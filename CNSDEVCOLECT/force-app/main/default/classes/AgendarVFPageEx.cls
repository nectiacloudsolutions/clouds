public class AgendarVFPageEx {

  //private final CampaignMember cM;
    
  public AgendarVFPageEx(ApexPages.StandardController stdController) {
      //this.cM = (CampaignMember)stdController.getRecord();

      }
        public String getGreeting() {
        RecordType Rp=[SELECT id FROM RecordType WHERE DeveloperName='Evento_No_Relacionado_sales'];
        String iD = Rp.id;
        System.debug(Rp);
        return iD;
    }
}