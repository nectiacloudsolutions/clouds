/*********************************************************************************************************
@Author       zsuanaza@everis.com
@name         needsDetectorController
@CreateDate   15/11/2019
@Description  Controller of the Lead Wizard Component
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
15/11/2019                    zsuanaza@everis.com           W-XXXXX - INTEGRATION
27/11/2019					  fbizama.moreno@everis.com     W-XXXXX - Added functionality (CreateOpp Method for creating Opportunities)
**********************************************************************************************************/
public class needsDetectorController {
    /**
      * @description       This method gets products based on the received params
      * @param1            rut, rutEjecutivo, jsonDC, code
      * @return            DetectorClassProduct
      * @throws            NA
    */
	@AuraEnabled
    public static DetectorClassProduct getProducts(String rut, String rutEjecutivo, String jsonDC, String code){
        DetectorClass dc =  new DetectorClass();

        dc = (DetectorClass)JSON.deserialize(jsonDC, DetectorClass.class);
        DetectorClassResponse dcr = new DetectorClassResponse();
        
        dcr.codigoFormulario = code;
        dcr.rut = rut;
        dcr.rutEjecutivo = rutEjecutivo;
        List<DetectorClassResponse.respuesta> preguntaRespuesta = new List<DetectorClassResponse.respuesta>();
        
        list<DetectorClassResponse.respuesta> rList = new list<DetectorClassResponse.respuesta>();
        for(DetectorClass.pregunta p : dc.formulario.preguntas){
            if(p.visible){

                DetectorClassResponse.respuesta resTemp = new DetectorClassResponse.respuesta();
                resTemp.idPregunta = p.idPregunta;
                for(DetectorClass.Respuesta r : p.respuestas){
                    if(r.respuesta == '1'){
                        resTemp.idRespuesta = r.idRespuesta;
                        preguntaRespuesta.add(resTemp);
                        
                    }
                }
            }
        }
        dcr.respuestas = preguntaRespuesta;
        SalesCallout sc = new SalesCallout(Constants.ANALYTICSLEAD);
        DetectorClassProduct dtProduct = sc.getProductsOpp(dcr);

        return dtProduct;
    }
       /**
      * @description       This method returns the Id of a created opportunity based on a product code and an Account Id
      * @param1            cuenta (It's an Account Id), producto (The product's code)
      * @return            Id
      * @throws            NA
    */

    
    @AuraEnabled
    public static Id createOpp(string cuenta, string producto){  
        /*
		Get StandardPricebook if it's not testing
		*/
        List<Pricebook2> pvk ;
        if(test.isRunningTest()){
            pvk = [SELECT Id FROM PriceBook2 WHERE Name = 'test' Limit 1];
        }else{
            pvk = [SELECT Id,Name FROM PriceBook2 WHERE Name = :Constants.PRICEBOOK_NAME Limit 1];
        }
        /*
         Get products según el ProductCode
		*/
        List<Product2> produc = [SELECT Id,Name, ProductCode, tipo_producto_sales__c,Plazo_estimado_cierre__c  
                        FROM Product2 
                        WHERE ProductCode =: producto LIMIT 1]; 
        /*
		Get PricebookEntry según el Product2Id y el Pricebook2Id
		*/
        List<PricebookEntry> pentry = [SELECT Name, ProductCode
                                    FROM PricebookEntry
                                    WHERE Product2Id =: produc[0].Id
                                    AND Pricebook2Id =: pvk[0].Id 
                                    AND isActive = true LIMIT 1];  
        
        System.debug('PriceBookEntry:' +pentry);
        
        if(!produc.isEmpty()){
            List<RecordType> rec = [SELECT Id from RecordType where developerName =: produc[0].tipo_producto_sales__c];           
            List<Account>accList = [SELECT firstName, lastName 
                            FROM account WHERE id =: cuenta ];
            //Count Opportunity x Account
			Integer count =[SELECT COUNT() FROM Opportunity WHERE Accountid=:cuenta]+1;
            /*
            Creación Opportunity
            */
            Opportunity opp = new Opportunity();
            opp.StageName = Constants.OPPORTUNITY_STAGE_CONTACTO;
            Opp.CloseDate = Date.TODAY().addDays(Integer.valueOf(produc[0].Plazo_estimado_cierre__c));
            opp.AccountId = cuenta;
            opp.Pricebook2Id = pvk[0].Id;
            opp.Name = produc[0].Name+' - '+count+' - '+accList[0].firstName+' '+accList[0].lastName;
            opp.RecordTypeId = rec[0].Id;
            //opp.CurrencyIsoCode = pentry[0].CurrencyIsoCode; //COMENTAR LINEA ANTES DE DESPLEGAR EN AMBIENTES
            System.debug('Oportunida: '  +opp);
            insert opp;
            
            /* 
            Creación OppLineItem
            */        
            OpportunityLineItem opli = new OpportunityLineItem();
            opli.UnitPrice=0;
            opli.OpportunityId = opp.Id;
            opli.Quantity = 1;
            opli.Product2Id = produc[0].Id;
            opli.PricebookEntryId = pentry[0].Id;
            insert opli;
		
            return opp.Id;            
        }else{
            return null;
        }
    }    
}