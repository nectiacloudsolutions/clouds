/**
* @File Name          : OpportunityAnalytics.cls
* @Description        : 
* @Author             : pcelis@everis.com
* @Group              : 
* @Last Modified By   : eayalcor@everis.com
* @Last Modified On   : 31-01-2020 10:57:28
* @Modification Log   : 
* Ver       Date            Author      		    Modification
* 1.0    16-01-2020   pcelis@everis.com     Initial Version
**/

@RestResource(urlMapping='/Opportunity/*')
global with sharing class UpdateOpportunityAnalytics {

    private static List<Opportunity> lstUpsertOpp = new List<Opportunity>();
    private static List<Task> lstTask = new List<Task>();
    private static Set<String> lstIdUpdate = new Set<String>();
    private static List<data> lstOpp = new List<data>();
    private static List<UtilitiesOppREST.Data> lstData = new List<UtilitiesOppREST.Data>();
    private static UtilitiesOppREST.Response response = new UtilitiesOppREST.Response();
    
    @HttpPatch
    global static UtilitiesOppREST.Response UpdateOpp(){
        
        Request newRequest = (Request)JSON.deserialize(RestContext.request.requestBody.toString(), Request.class);
        
        lstOpp = newRequest.registros;
        system.debug(lstOpp);
        Set<String> IdOpp = new Set<String>();
        
        for (data  Opp : lstOpp) {
            IdOpp.add(Opp.idOportunidad);
        }
        
        List<Opportunity> lstOppInSales=[SELECT id,StageName,OwnerId,Flag_cierre_ganada_sales__c FROM Opportunity WHERE id=:IdOpp];
   
        for (data Opp:   lstOpp ) {
            
            Boolean isEvaluation = false;
            for (Opportunity OppInSales : lstOppInSales) {
                
                if (oppInSales.StageName=='Evaluación' && lstIdUpdate.contains(OppInSales.Id)==false) {
                    
                    oppInSales.StageName='Cierre Ganada';
                    oppInSales.CloseDate=date.valueOf(Opp.fecha);
                    oppInSales.Flag_cierre_ganada_sales__c = true; 
                    addDataResponse(OppInSales.Id,'OK','Oportunidad Ganada');
                    lstIdUpdate.add(OppInSales.Id);
                    //lstOppInSales.add(Opp);
                    break;
                }
                else if(oppInSales.StageName=='Cierre Ganada' && lstIdUpdate.contains(OppInSales.Id)==false)     
                {
                    addDataResponse(OppInSales.Id,'NOK','Error, la Opp ya esta cerrada');
                    lstIdUpdate.add(OppInSales.Id);
                }
                else if(lstIdUpdate.contains(OppInSales.Id)==false) 
                {
                    createTaskOwner(OppInSales.OwnerId,OppInSales.Id);
                    addDataResponse(OppInSales.Id,'NOK','Error, para cerrar la oportunidad debe estar en Evaluación');
                    lstIdUpdate.add(OppInSales.Id);
                }
            }
        }
        
        for(data  Opp : lstOpp){
            if(!lstIdUpdate.contains(Opp.idOportunidad) ){
                addDataResponse(Opp.idOportunidad,'NOK','Error, verifique el id');
            }
        }
        
        //UPDATE OPPORTUNITY
        if(lstOppInSales.size()>0){UPDATE lstOppInSales;}
        //INSERT TASKS
        if(lstTask.size()>0){insert lstTask;}
        
        response.resultados = lstData;
        
        return response;
    }
        
    /**
    * @description 
    * @author eayalcor@everis.com | 30-01-2020 
    * @param String Id 
    * @param String status 
    * @param String message 
    * @return void 
    **/
    private static void addDataResponse(String Id,String status,String message){
        UtilitiesOppREST.Data data = new UtilitiesOppREST.Data();
        data.idOportunidad = Id;
        data.estado = status;
        data.mensaje = message;
        lstData.add(data);   
    }

    global class Request{
        public String fecha  {get;set;}
        public List<Data> registros;
    }
    
    global class Data{
        public String idOportunidad  {get;set;}
        public String estado {get;set;}
        public String usuario {get;set;}
        public String mensaje {get;set;}
        public String fecha {get;set;}
        
    }


    
    /******************** WEBSERVICE CREATE OPPORTUNITY *****************************************************/

    /*Static WebService Create Opportunity*/
    private static List<Opportunity> lstCreateOp = new List<Opportunity>();
    private static List<DataCreate> lstCreateOpp = new List<DataCreate>();
    private static List<OpportunityLineItem> lstOppLineItem= new List<OpportunityLineItem>();
    private static List<Opportunity> lstOppTmp= new List<Opportunity>();
    private static Set<String> lstIds = new Set<String>();
    private static UtilitiesSalesREST.Response resCreate = new UtilitiesSalesREST.Response();
    private static List<UtilitiesSalesREST.Data> lstDataCreate = new List<UtilitiesSalesREST.Data>();
    
    /**
    * @description method invoke webservice
    * @author eayalcor@everis.com | 30-01-2020 
    * @return UtilitiesOppREST.ResponseCreate 
    **/
    @HttpPost
    global static UtilitiesSalesREST.Response CreateOpp(){
        
        RequestCreate newRequest = (RequestCreate)JSON.deserialize(RestContext.request.requestBody.toString(), RequestCreate.class);
        lstCreateOpp = newRequest.registros;
        
        String owner;
        String idProduct;
        String RecordType;
        String prBookId;
        String prEntry;
        String idCuenta;
        Account ac; 
        String accName;
        String proName;
        String proCod;
        Set<String> rutExecutive = new Set<String>();
        Set<String> rutAcc = new Set<String>();
        Set<String> codPro = new Set<String>();
        
            System.debug('Registros: ' + lstCreateOpp);
        
        for(DataCreate l : lstCreateOpp){
            
            rutAcc.add(l.rut_cuenta);
            codPro.add(l.ProductCode);
            if(l.rut_ejecutivo != null && l.rut_ejecutivo.contains('-')) { 
                rutExecutive.add(l.rut_ejecutivo.remove('-'));
            } else{
                rutExecutive.add(l.rut_ejecutivo);
            }
        }

        Map<String,Id> mapIdExecutive = UtilitiesSales.getIdsExecutive(rutExecutive);
        Map<String,List<SObject>> mapObject = UtilitiesSales.existAccountLead(rutAcc);
        List<Account> lstAcc = mapObject.get(Constants.ACCOUNT);
        Map<String,Product2> mapsProduct = UtilitiesSales.getProduct(codPro);
        
        System.debug('EJECUTIVOS'+mapIdExecutive);
        System.debug('CUENTAS'+lstAcc);
        System.debug('PRODUCTOS'+codPro);       
        System.debug('PRODUCTOS'+mapsProduct);
        
        for(DataCreate Opp : lstCreateOpp){
            
            String rutExec = Opp.rut_ejecutivo.contains('-') ? Opp.rut_ejecutivo.remove('-') : Opp.rut_ejecutivo; 
            Boolean existExec = true;
            Boolean existAcc = false;
            Boolean existPro = true;
            
            if(mapIdExecutive.get(rutExec) != null){
                owner = mapIdExecutive.get(rutExec);
                System.debug('OWNER :'+Owner);
            }else{
                addDataResponseCreate(false,'ERROR_EXECUTIVE',Constants.RESPONSE_400,'',Opp.rut_cuenta,Opp.rut_ejecutivo,'','',Opp.ProductCode, '', '','','', '');
                existExec = false;
                
            }
            System.debug(existExec);
            if (existExec) {
                if(Opp.rut_cuenta != null){
                    //Validación Account
                    for(Account acc : lstAcc){
                        if(Opp.rut_cuenta.equals(acc.Rut__C)){
                            ac = acc;
                            existAcc = true;
                            break;
                        }
                    }
                if(!existAcc){addDataResponseCreate(false,'ERROR_ACCOUNT',Constants.RESPONSE_400,'',Opp.rut_cuenta,Opp.rut_ejecutivo,'','',Opp.ProductCode, '','','','', '');}
                }
            }
                      
            if (existExec && existAcc) {
                //Validacion Product
                if (mapsProduct.get(Opp.ProductCode) != null) {
                    System.debug('entro en los productos');
                    idProduct= mapsProduct.get(Opp.ProductCode).id;
                    String[] data =mapsProduct.get(Opp.ProductCode).Description.split('/');
                    System.debug('DATA GET:' +data);
                    recordType= data[0];
                    prEntry= data[1];
                    prBookId= data[2];
                    proName= data[3];
                    data.add(Opp.rut_ejecutivo);
                    createOppWithProduct(owner, ac, idProduct, Opp, data);
                    
                }else{
                    addDataResponseCreate(false,'ERROR_PRODUCT',Constants.RESPONSE_400,'',Opp.rut_cuenta,Opp.rut_ejecutivo,'','',Opp.ProductCode, '','','','', '');
                    existPro = false; 
                }
            }        
        }   
        
        if(lstCreateOp.size()>0){
            System.debug('LISTA A INSERTAR: ' +lstCreateOp);
            Database.upsert(lstCreateOp, false);
            insertOpp();
        }

        resCreate.response=lstDataCreate;
        
        return resCreate;
    }
    
    /**
    * @description 
    * @author eayalcor@everis.com | 30-01-2020 
    * @return void 
    **/
    private static void insertOpp(){
	    
        List<Database.UpsertResult> srList = Database.upsert(lstCreateOp, false);	        
        // Iterate through each returned result
        for (Database.UpsertResult sr : srList) {
            if (sr.isSuccess()) {
 				lstIds.add(sr.getId());     
                System.debug('ID NUEVA OPORTUNIDAD: '+sr.getId());
            }else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    addDataResponseCreate(false,'ERROR_INSERT',Constants.RESPONSE_400,'','','','','','', '','','','','');                      
                }
            }
        }

        /* Creación de OppLineItem*/
        lstOppTmp = [SELECT Id,NextStep,AccountId,telefono_sales__c,Description,correo_oportunidad_sales__c,
                telefono_oportunidad_sales__c, OwnerId, origen_de_oportunidad_sales__c, Type FROM Opportunity WHERE Id IN : lstIds];
        
        List<OpportunityLineItem> lstOppItems = new List<OpportunityLineItem>();


        for(Opportunity opp : lstOppTmp){
            OpportunityLineItem itemTmp = new OpportunityLineItem();
            String[] data = opp.NextStep.split('/');
            itemTmp.OpportunityId = opp.Id;
            itemTmp.PricebookEntryId = data[0];
            itemTmp.Product2Id = data[1];
            itemTmp.Quantity = 1;
            itemTmp.UnitPrice = 1;
            lstOppItems.add(itemTmp);
        }

        Database.UpsertResult[] srListLineItem = Database.upsert(lstOppItems, false);
        Set<Id> lstIdsTmp = new Set<Id>();
        for (Database.UpsertResult sr : srListLineItem) {
            if (sr.isSuccess()) {
 				lstIdsTmp.add(sr.getId());           
            }
        }

        getOppByLineItem(lstIdsTmp);
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 31-01-2020 
    * @param Set<Id> ids 
    * @return void 
    **/
    private static void getOppByLineItem(Set<Id> ids){
        Set<String> setOppOk = new Set<String>();
        List<OpportunityLineItem> lstOppItem = [SELECT OpportunityId,ProductCode FROM OpportunityLineItem
                                        WHERE Id IN : ids];
        
        for(OpportunityLineItem item : lstOppItem){
            for(Opportunity oppTmp : lstOppTmp){
                if(oppTmp.Id.equals(item.OpportunityId)){
                    String[] data = oppTmp.NextStep.split('/');
                    addDataResponseCreate(true,Constants.OK,Constants.RESPONSE_200,oppTmp.Id,data[2],data[4],oppTmp.AccountId,oppTmp.OwnerId,item.ProductCode, oppTmp.correo_oportunidad_sales__c, oppTmp.telefono_oportunidad_sales__c,oppTmp.telefono_sales__c, oppTmp.origen_de_oportunidad_sales__c, oppTmp.Type);
                    setOppOk.add(oppTmp.Id);
                    break;
                }
            }
        }

        for (String x : lstIds) {
            for (String tmp : setOppOk) {
                if(x.equals(tmp)){
                    lstIds.remove(tmp); 
                }
            }
        }

        if(lstIds.size()>0){ 

            List<Opportunity> deleteOpp = [SELECT Id,NextStep,AccountId,telefono_sales__c,Description,correo_oportunidad_sales__c,
                telefono_oportunidad_sales__c,OwnerId FROM Opportunity WHERE Id IN : lstIds];
            
            for(Opportunity opp : deleteOpp){
                String[] data = opp.NextStep.split('/');
                addDataResponseCreate(false,'ERROR_INSERT',Constants.RESPONSE_400,'',data[2],data[4],'','',data[3], '','','','', '');
            }

            delete deleteOpp;
        }
    }
    
    /**
    * @description Mehtod
    * @author pcelis@everis.com | 16-01-2020 
    * @param String assignTo 
    * @param String relatedTo 
    * @return void 
    **/
    private static void createOppWithProduct(String assignTo, Account acc, String idProd, DataCreate dataOpp,String[] data){
		
        Integer numeroOpp =[SELECT COUNT() FROM Opportunity WHERE Accountid=:acc.Id]+1;
        Decimal plazoCierreOpp = [SELECT Plazo_estimado_cierre__c FROM Product2 WHERE ProductCode =: dataOpp.ProductCode LIMIT 1].Plazo_estimado_cierre__c; 

        
        //Create a new Opportunity
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = data[3]+' - '+numeroOpp+' - '+acc.Name;
        opp.StageName = Constants.OPPORTUNITY_STAGE_CONTACTO;
        opp.OwnerId= assignTo;
        opp.RecordTypeId = data[0];
        opp.CloseDate = Date.TODAY().addDays(Integer.valueOf(plazoCierreOpp));
        //opp.Description= des;
        opp.Descripcion_Analitycs__c=dataOpp.descripcion;
        opp.Pricebook2Id = data[2];
        opp.NextStep = data[1]+'/'+idProd+'/'+acc.Rut__c+'/'+data[4]+'/'+data[5];     
        
        opp.telefono_oportunidad_sales__c = dataOpp.telefono_Opp;
        opp.correo_oportunidad_sales__c = dataOpp.correoOportunidad;
        opp.origen_de_oportunidad_sales__c = dataOpp.origenOportunidad;
		opp.Type = dataOpp.tipoOportunidad;
            
        lstCreateOp.add(opp);
    }    

    /**
    * @description 
    * @author eayalcor@everis.com | 30-01-2020 
    * @param String assignTo 
    * @param String relatedTo 
    * @return void 
    **/
    private static void createTaskOwner(String assignTo, String relatedTo){
        Task newTask = new Task();
        newTask.OwnerId = assignTo; //Propietario de la Oportunidad
        newTask.Subject = 'Cambiar Stage de Oportunidad';
        newTask.WhatId = relatedTo; //Oportunidad relacionada
        
        lstTask.add(newTask); 
    }
    
    /**
    * @description 
    * @author eayalcor@everis.com | 30-01-2020 
    * @param String Id 
    * @param String status 
    * @param String message 
    * @param String nDocument 
    * @param String rEjec 
    * @param String accId 
    * @param String ownerId 
    * @param String codProd 
    * @return void 
    **/
    private static void addDataResponseCreate(Boolean success, String message, String statusCode,String Id,String nDocument,String rEjec,String accId,String ownerId,String codProd, String correoOportunidad, String telefonoOportunidad, String telefono, String origenOportunidad, String tipoOportunidad){
        UtilitiesOppREST.DataCreate dataC = new UtilitiesOppREST.DataCreate();
        dataC.idOportunidad = Id;
        dataC.rut_cuenta=nDocument;
        dataC.rut_ejecutivo=rEjec;
        dataC.AccountId=accId;
        dataC.correoOportunidad = correoOportunidad;
        dataC.description = '';
        dataC.ownerId=ownerId;
        dataC.stageName= success ? 'Contacto' : '';
        dataC.telefono_Opp = telefonoOportunidad;
        dataC.telefono_Sales= telefono;
        dataC.origenOportunidad = origenOportunidad;
        dataC.tipoOportunidad = tipoOportunidad;        
        dataC.cod_prod=codProd;
        String json = JSON.serialize(dataC);

        UtilitiesSalesREST.Data data = new UtilitiesSalesREST.Data();
        data.success = success;
        data.message = message;
        data.statusCode = statusCode;
        data.jsonMap = json;
        lstDataCreate.add(data);
        
    }

    global class RequestCreate{
        public List<DataCreate> registros;
    }
    
    global class DataCreate{
        public String ProductCode  {get;set;}
        public String rut_cuenta {get;set;}
        public String descripcion {get;set;}
        public String rut_ejecutivo {get;set;}
        
        public String telefono_Opp {get;set;}
        public String correoOportunidad {get;set;}
        public String origenOportunidad {get;set;}
        public String tipoOportunidad {get;set;}        
        
    }
    
}