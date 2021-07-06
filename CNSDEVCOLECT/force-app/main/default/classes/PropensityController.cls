/*********************************************************************************************************
@Author       eayalcor@everis.com
@name         PropensityController
@CreateDate   15/10/2019
@Description  Controller of the propensity Component 
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
15/10/2019                    eayalcor@everis.com           W-000057 - (LEAD) Propensión
29/05/2020            		  eduardo.ojeda@consorcio.cl  FIX  Envío de rut ejecutivo en NBO
**********************************************************************************************************/
public without sharing class PropensityController {
	/*
      * 
      * @description       This method return a propensityAnalytics
      * @param1            String rut 
      * @return            void 
      * @throws            NA
    */
    @AuraEnabled 
    public static Propensity getPropensityAnalytics(String id,String nameObject){ 

        Boolean execBrand = false;
        Propensity nbo = new Propensity();
        List<String> lstRut = getRutsObject(id, nameObject);
        SObject sObj;
   
        
        //Obtención del RUT del usuario en sesión
        String rutEjecutivo = getRutExecutive(UserInfo.getUserId());
        
        
        if(lstRut[0].equalsIgnoreCase('SINRUT') || rutEjecutivo == null){
	    String txtMsg = nameObject.equalsIgnoreCase(Constants.LEAD) ? 'Prospecto' : 'Cliente';
            nbo.code = '-1';
            nbo.message = txtMsg + ' no posee oferta';
        }else{
            if(nameObject.equalsIgnoreCase(Constants.LEAD)){
                Lead lead = new Lead(); 
                lead.Id = id;
                lead.numero_de_documento_sales__c = lstRut[0];
                //lead.rut_ejecutivo_sales__c = lstRut[1];
                lead.rut_ejecutivo_sales__c = rutEjecutivo;
                lead.tipo_documento_sales__c = Constants.RUT;
                sObj = lead;
            }else{
                execBrand = true;
                Account acc = new Account();
                acc.Id = id;
                acc.Rut__c = lstRut[0];
                //acc.Rut_Ejecutivo_Banco__c = lstRut[1];
                acc.Rut_Ejecutivo_Banco__c = rutEjecutivo;
                acc.Tipo_de_documento_de_identidad__c = Constants.RUT;
                sObj = acc;
            }

            SalesCallout callOut = new SalesCallout(Constants.ANALYTICSLEAD);
            String response =callOut.getNextBestOffer(sObj);
            nbo = (Propensity) System.json.deserialize(response, Propensity.class);
            nbo.rutClient = lstRut[0];
            //nbo.rutExec = lstRut[1];
            nbo.rutExec = rutEjecutivo;

            if(execBrand && !Test.isRunningTest()){checkBrandStatusAnalytics(id,lstRut[0]);}

        }

        return nbo; 
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 07-07-2020 
    * @param String cod 
    * @param String rut 
    * @param String rutExecutive 
    * @return String 
    **/
    @AuraEnabled
    public static String getQuestionsDetector(String cod, String rut,String rutExecutive){
        RequestQuestion request = new RequestQuestion();
        request.rut = rut;
        request.rutEjecutivo = rutExecutive;
        request.origin = Constants.REQUEST_ANALYTICS_ORIGIN;
        request.codigoFormulario = cod;
        DetectorClass dt = new DetectorClass();
        SalesCallout callOut = new SalesCallout(Constants.ANALYTICSLEAD);
        String response =callOut.getQuestionsDetector(request);
        System.debug('Respuesta:' +response);
        dt = (DetectorClass) System.json.deserialize(response, DetectorClass.class);

        System.debug(EncodingUtil.urlEncode(response,'UTF-8'));

        return response;
    }

    /**
      * @description       This method return Rut executive by ID user
      * @param1            Id user
      * @return            String Rut formated
      * @throws            NA
	*/
    private static String getRutExecutive(Id idExcutive){
        String rut = [SELECT Rut__C FROM User WHERE Id=:idExcutive LIMIT 1].Rut__c;

        return UtilitiesSales.formatRut(rut, Constants.WITHOUTDOT);
    }

    /**
      * @description       This method return Maps with the Rut and Id executive
      * @param1            Set<String> RUT del ejecutivo - Format field RUT 11111111-1
      * @return            Map<String,Id> List Account . List Leads
      * @throws            NA
	*/

    private static List<String> getRutsObject(String idObject, String typeObject){
        
        List<String> ruts = new List<String>();
        String rut;
        String rutExecutive;

        try{

            if(typeObject.equalsIgnoreCase(Constants.LEAD)){
                List<Lead> lstLead = [SELECT numero_de_documento_sales__C, OwnerId FROM Lead WHERE Id=: idObject LIMIT 1];
                rut = lstLead[0].numero_de_documento_sales__C != null ? lstLead[0].numero_de_documento_sales__C : 'SINRUT';
                rutExecutive = getRutExecutive(lstLead[0].OwnerId);
            }else{
                List<Account> lstAccount = [SELECT RUT__c, OwnerId FROM Account WHERE Id=: idObject LIMIT 1];
                rut = lstAccount[0].RUT__c != null ? lstAccount[0].RUT__c : 'SINRUT';
                rutExecutive = getRutExecutive(lstAccount[0].OwnerId);
            }

            ruts.add(rut);
            ruts.add(rutExecutive);

            
        }catch(Exception e){
            System.debug('Exception: '+e.getStackTraceString() + ' Message: ' + e.getMessage());
            ruts = null;
        }

        return ruts;

    }

    /**
    * @description 
    * @author eayalcor@everis.com | 07-07-2020 
    * @param String accId 
    * @param String rutAcc 
    **/
    
    public static void checkBrandStatusAnalytics(String accId,String rutAcc){
        SalesCallout sc = new SalesCallout(Constants.ANALYTICSMARCA);
        RequestMarca rqMarca = new RequestMarca();
        rqMarca.rut = rutAcc;
        rqMarca.rutEjecutivo = getRutExecutive(UserInfo.getUserId());
        ResponseMarca rspMarca  = sc.checkBrandStatus(rqMarca);
        Map<Integer,DetalleMarcas> mapsDetail = new Map<Integer,DetalleMarcas>();
        for(DetalleMarcas dtMarca : rspMarca.detalleMarcas){
            mapsDetail.put(dtMarca.idTipoMarca, dtMarca);
        }

        Account acc = new Account();
        acc.Id = accId;
        acc.Autoriza_uso_de_datos__c = mapsDetail.get(1).vigente;
        if(mapsDetail.get(1).obtenerAutorizacion!=null){
           acc.obtenerAutorizacion__c=mapsDetail.get(1).obtenerAutorizacion;
        }
        acc.almacenamiento_datos_nube_sales__c = mapsDetail.get(2).vigente;
        acc.uso_canales_remotos_sales__c = mapsDetail.get(3).vigente;
        acc.PersonHasOptedOutOfEmail = mapsDetail.get(4).vigente;
        acc.PersonDoNotCall = mapsDetail.get(12).vigente;
        acc.isAnalytics__c=true;
        update acc;

        acc.isAnalytics__c=false;
        update acc;

        System.debug('ResponseMarca' + rspMarca);

    }
/**
========================================================================================================================
----------------------------------------------------PROPENSION----------------------------------------------------------
========================================================================================================================
*/ 

    public class RequestQuestion{
        public String origin;
        public String codigoFormulario;
        public String rut;
        public String rutEjecutivo;
    }
    
    
    public class Propensity{
        @AuraEnabled public String code{get;set;}
        @AuraEnabled public String message{get;set;}
        @AuraEnabled public String rutClient{get;set;}
        @AuraEnabled public String rutExec{get;set;}
        @AuraEnabled public List<ProductPropensity> products;
    }
    
    public class ProductPropensity{
        @AuraEnabled public String prodCod{get;set;}
        @AuraEnabled public String prodFamDesc{get;set;}
        @AuraEnabled public String order{get;set;}
        @AuraEnabled public String propension{get;set;}
        @AuraEnabled public String descripcion{get;set;}
        @AuraEnabled public String icon{get;set;}
    }

/**
========================================================================================================================
----------------------------------------------------MARCAS----------------------------------------------------------
========================================================================================================================
*/ 
    //REQUEST
    public class RequestMarca{
        public String rut;
        public String rutEjecutivo;
    }

    //RESPONSE
    public class ResponseMarca{
        public String rut;
        public String codigo;
        public String mensaje;
	    public List<DetalleMarcas> detalleMarcas;
    }

    public class DetalleMarcas {
		public Integer idTipoMarca;
        public Boolean vigente;
        public String obtenerAutorizacion;
        public String fechaActualizacion;
        public String fechaInicioVigencia;
	}
}