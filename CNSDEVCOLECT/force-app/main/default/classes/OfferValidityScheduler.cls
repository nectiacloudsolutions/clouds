/**
 * @File Name          : OfferValidityScheduler.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/12/2020, 3:35:59 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/12/2020   eayalcor@everis.com     Initial Version
**/
public class OfferValidityScheduler implements Schedulable{
    public void execute(SchedulableContext SC) {
        OfferValidityBatch myBatch = new OfferValidityBatch(); 
        Id batchId = Database.executeBatch(myBatch,10);
    }
}