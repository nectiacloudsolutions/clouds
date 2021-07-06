/*********************************************************************************************************
@Author       zsuanaza@everis.com
@name         SalesCallout
@CreateDate   03/10/2019
@Description  Callouts to update and inform Analytics 
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
03/10/2019                    zsuanaza@everis.com                Initial Version 
25/11/2019                    zsuanaza@everis.com                Add new Login 
**********************************************************************************************************/
public class SalesCallout {
    
    protected Sales_Connect__mdt sc;
    public String sourceIp {get;set;} // Mejora para metodos futuros;
    
    public SalesCallout(String nameCredentials){
        this.sc = [SELECT password__c,URL_sales__c,username__c,user_pool_id__c,x_api_key__c,token__c,Callback_url__c,
                client_id__c,Client_Secret__c,Codigo_App__c,Codigo_Canal__c,Empresa_App__c,Modalidad__c
                FROM Sales_Connect__mdt WHERE DeveloperName=:nameCredentials LIMIT 1];
    }
    
    public SalesCallout(){
        
    }

/**
========================================================================================================================
----------------------------------------------------WRAPPERS----------------------------------------------------------
========================================================================================================================
*/
    
    public class AccessToken{
        public String access_token;
        public String token_type;
    }
    
    public class TokenResponse{
        public string AccessToken;
        public integer ExpiresIn;
        public string TokenType;
        public string RefreshToken;
        public string IdToken;
    }

    public class LeadData{
        public string action;
        public string code;
        public string message;
        public Lead lead;
    }
    
    public class LeadDataList{
        public string action;
        public string code;
        public string message;
        public List<lead> leadList;
    }

    public class OpportunityDataList{
        public string action;
        public string statusCode;
        public string message;
        public List<OppObj> jsonMap;
    }

    public class OppObj{
        public string telefono_Sales;
        public string telefono_Opp;
        public string stageName;
        @AuraEnabled  public string rut_ejecutivo;
        public string rut_cuenta;
        public string ownerId;
        public string idOportunidad;
        public string description;
        public string correoOportunidad;
        public string cod_prod;
        public string Accountid;
    }

    public class UserDataList{
        public string action;
        public string StatusCode;
        public string message;
        public string success;
         public List<UsrObj> jsonMap;
    }

    public class UsrObj{
        public string RUT_Ejecutivo;
        public string ProfileName;
        public string FirstName;
        public string ManagerId;
        public string UserName;
        public string LastName;
        public string RUT_Jefe;
        public string isActive;
        public string RolName;
        public string Email;
        public string Name;
        public string id;
    }



/**
========================================================================================================================
----------------------------------------------------HEADERS----------------------------------------------------------
========================================================================================================================
*/

    /**
    * @description 
    * @author eayalcor@everis.com | 6/23/2020 
    * @param String url 
    * @param String x_api_key 
    * @param String json 
    * @param String method 
    * @param String token 
    * @return HttpRequest 
    **/
    private  HttpRequest requestAnalytics(String url, String x_api_key, String json, String method,String token){
        
        HttpRequest request = new HttpRequest();
        
        request.setTimeout(120000);
        request.setEndpoint(url);                    
        request.setHeader('content-type','application/json');
        request.setHeader('x-api-key',x_api_key);  
        request.setHeader('Authorization', token);
        request.setMethod(method);
        request.setBody(json);
        
        return request;
    }
    
    /**
    * @description 
    * @author eayalcor@everis.com | 6/23/2020 
    * @param String url 
    * @param String json 
    * @param String method 
    * @return HttpRequest 
    **/
    private  HttpRequest requestVTime(String url, String json, String method,String typeCall){
        String realToken;
        if(typeCall=='Manual'){
                    AuthProvider authPrv = [SELECT Id, ConsumerKey, ConsumerSecret,TokenUrl
                FROM AuthProvider WHERE DeveloperName =: Constants.CONSORCIO_SEGUROS];

        String token = Test.isRunningTest() ? 'token' : Auth.AuthToken.getAccessToken(authPrv.Id, Constants.OPENCONNECT);
		           
        if(token==null){
            throw new UtilitiesSales.SalesException('ERROR_401');
        }
        
        Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(authPrv.Id,Constants.OPENCONNECT, token);
        realToken=responseMap.get('AccessToken');
        }else{
           realToken=Test.isRunningTest() ? 'tokenTest' : getTokenByClientCredencial(); 
        }

        HttpRequest request = new HttpRequest();
        
        request.setTimeout(120000);
        request.setMethod(method);
        request.setHeader('content-type','application/json');
        request.setEndpoint(url); 
        if(!Test.isRunningTest()){request.setHeader('Authorization','Bearer '+realToken);}
        if(method.equalsIgnoreCase(Constants.REQUEST_METHOD_POST)){
            request.setBody(json);
        }
        
        return request;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 07-06-2020 
    * @param String url 
    * @param String json 
    * @param String method 
    * @param String token 
    * @return HttpRequest 
    **/
    private  HttpRequest requestCumbres(String url,String json,String method,String token){
        
        HttpRequest request = new HttpRequest();
        
        request.setTimeout(120000);
        request.setEndpoint(url);                    
        request.setHeader('content-type','application/json');
        request.setHeader('codigoAplicacion',sc.Codigo_App__c);  
        request.setHeader('codigoCanal',sc.Codigo_Canal__c);  
        request.setHeader('Authorization', token);
        //if(!Test.isRunningTest()){request.setHeader('ipCliente', Auth.SessionManagement.getCurrentSession().get('SourceIp'));}
        if(!System.Test.isRunningTest()){
        	this.sourceIp = (this.sourceIp == null ? Auth.SessionManagement.getCurrentSession().get('SourceIp') : this.sourceIp); // Mejora metodo Future
        	request.setHeader('ipCliente', this.sourceIp);            
        }        
        request.setHeader('modalidad', sc.Modalidad__c);
        request.setHeader('empresaAplicacion', sc.Empresa_App__c);
        request.setMethod(method);
        request.setBody(json);
        
        return request;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 07-06-2020 
    * @param String url 
    * @param String json 
    * @param String method 
    * @param String token 
    * @return HttpRequest 
    **/
    private  HttpRequest requestAlfresco(String url,String json,String method,String token){
        
        HttpRequest request = new HttpRequest();
        
        request.setTimeout(120000);
        request.setEndpoint(url);                    
        request.setHeader('content-type','application/json');
        request.setHeader('codigoAplicacion',sc.Codigo_App__c);  
        request.setHeader('codigoCanal',sc.Codigo_Canal__c);  
        request.setHeader('Authorization', token);
        if(!System.Test.isRunningTest()){
        	this.sourceIp = (this.sourceIp == null ? Auth.SessionManagement.getCurrentSession().get('SourceIp') : this.sourceIp); // Mejora metodo Future
        	request.setHeader('ipCliente', this.sourceIp);            
        }
        request.setHeader('modalidad', sc.Modalidad__c);
        request.setHeader('empresaAplicacion', sc.Empresa_App__c);
        request.setMethod(method);
        request.setBody(json);
        
        return request;
    }
    
  
        /**
    * @description 
    * @author eayalcor@everis.com | 07-06-2020 
    * @param String url 
    * @param String json 
    * @param String method 
    * @param String token 
    * @return HttpRequest 
    **/
    private  HttpRequest requestDocuware(String url,String json,String method,String token){
        
        HttpRequest request = new HttpRequest();
        
        request.setTimeout(120000);
        request.setEndpoint(url);                    
        request.setHeader('content-type','application/json');
        request.setHeader('Authorization', token);
        request.setMethod(method);
        request.setBody(json);
        
        return request;
    }
    
     private  HttpRequest requestRRHH(String url,String json,String method,String token){
        
        HttpRequest request = new HttpRequest();
        
        request.setTimeout(120000);
        request.setEndpoint(url);                    
        request.setHeader('content-type','application/json');
        request.setHeader('Authorization','Bearer ' +  token);
        request.setMethod(method);
        request.setBody(json);
        
        return request;
    }

/**
========================================================================================================================
----------------------------------------------------ANALYTICS----------------------------------------------------------
========================================================================================================================
*/

    /**
    * @description 
    * @author eayalcor@everis.com | 6/23/2020 
    * @return String 
    **/
    @TestVisible
    private String getAnalyticsToken(){
        
        String res;
        String url = sc.URL_sales__c + '?grant_type=client_credentials';
        String authorization = sc.token__c;   
        
        try{
            
            Http http =new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod(Constants.REQUEST_METHOD_POST);
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.setHeader('Authorization', authorization);
            request.setTimeout(120000);
            request.setEndpoint(url);  
            HttpResponse response = http.send(request);
            System.debug('Authorization: '+ authorization);
            System.debug('REQUEST: '+ request);
            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                   res=response.getbody();
                   System.debug(res);
                   
               }else{
                   res='{"access_token": "-1", "token_type": "Servicio no disponible"}';
               }
            
        }catch(Exception e){
            res='{"access_token": "-1", "token_type": "Servicio no disponible"}';
        } 
        
        AccessToken accToken = (AccessToken) System.JSON.deserialize(res, AccessToken.class);
        
        return accToken.access_token;
    }
    
    /**
	 * dynamicRequestAnalytics create a dynamic request to analytics integration
	 * @param  endPoint The end point of the service 
	 * @param  body     body Json string to the body request
	 * @param  method   method Rest method
	 * @return          return The response body 
	 */
	public String dynamicRequestAnalytics(String endPoint, String body, String method ){
		String token = Test.isRunningTest() ? 'tokenTest' : getAnalyticsToken(); 
		String url=sc.Callback_url__c + endPoint; 
		Http h =new Http();
		HttpRequest request=
		requestAnalytics(url, sc.x_api_key__c, body, Constants.REQUEST_METHOD_POST,token);
		HttpResponse response = h.send(request);
		String res;
		if(response.getStatus()=='200' || response.getStatus()=='201'||response.getStatus()=='ok' ){
			res=response.getbody();
		}else{
			res='{ "code": "-1", "message": "Error: Servicio no disponible"}';
		}
		return res;
	}

    /**
* @name			   consultLeadAnalytics
* @description       post the lead information to Analytics Service
* @param1            String token
* @param2			   Lead lead
* @param3			   String action
* @return            String res
* @throws            NA
*/
    public string consultLeadAnalytics(Lead lead,String action){
        
        String token = Test.isRunningTest() ? 'tokenTest' : getAnalyticsToken();
        
        String res;
        String url=sc.Callback_url__c +'/lead/gestion-leads'; 
        try{
            leadData result = new leadData();
            leadData dl = new leadData();
            dl.lead = lead;
            dl.action = action;
            
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);                    
            req.setHeader('content-type','application/json'); 
            req.setHeader('x-api-key',sc.x_api_key__c);
            req.setHeader('Authorization',token);
            req.setMethod('POST');   
            req.setBody(JSON.serialize(dl));
            //system.debug('SERIALIZE '+ JSON.serialize(dl));  
            HttpResponse res1;
            res1 = h.send(req);
            system.debug('res1.getStatus()'+res1.getStatus());
            if(res1.getStatus()=='200' || res1.getStatus()=='201'||res1.getStatus()=='ok' ){
                res=res1.getbody();
                system.debug('Resultado Success = '+res);                
            }else{
                //system.debug('Resultado Fail = '+res);  
                res='{ "code": "-1", "message": "Error: Servicio no disponible"}';
            }
        }catch(Exception e){
            
            res=null;
        } 
        
        return res;
    }
    
    
    /**
* @name getNextBestOffer
* @description 
* @author eayalcor@everis.com | 03-12-2019 
* @param sObject sobj 
* @return string 
**/
    public string getNextBestOffer(sObject sobj){
        
        String token = Test.isRunningTest() ? 'tokenTest' : getAnalyticsToken();
        
        String res;
        String url=sc.Callback_url__c +'/nbo/next-best-offer'; 
        String jsonString = json.serialize(sobj);
        
        Map<String, Object> m = 
            (Map<String, Object>)
            JSON.deserializeUntyped(jsonString); 
        m.remove('url');
        
        String finalJson = json.serialize(m);
        
        System.debug('JSON: '+ finalJson);
        
        try{
            
            Http http =new Http();
            HttpRequest request = requestAnalytics(url, sc.x_api_key__c, finalJson, Constants.REQUEST_METHOD_POST,token);
            
            System.debug('REQUEST: ' + request);
            HttpResponse response = http.send(request);
            
            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                   res=response.getbody();
                   
               }else{
                   res='{ "Code": "-1", "message": "Error: Servicio no disponible"}';
               }
        }catch(Exception e){
            res='{ "Code": "-1", "message": "Servicio no disponible"}';
            System.debug('Exception SalesCallout:' +e.getMessage());
        } 
        return res;
    }
    
    
    /**
* @name getQuestionsDetector
* @description 
* @author eayalcor@everis.com | 03-12-2019 
* @param PropensityController.RequestQuestion req 
* @return string 
**/
    public string getQuestionsDetector(PropensityController.RequestQuestion req){
        
        String token = Test.isRunningTest() ? 'tokenTest' : getAnalyticsToken();
        
        String res;
        String url=sc.Callback_url__c +'/detector-necesidades/formulario-preguntas';
        
        String finalJson = json.serializePretty(req);
        
        System.debug('JSON: '+ finalJson);
        
        try{
            
            Http http =new Http();
            HttpRequest request = requestAnalytics(url, sc.x_api_key__c, finalJson, Constants.REQUEST_METHOD_POST,token);
            HttpResponse response = http.send(request);
            
            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                   res=response.getbody();
                   
                   System.debug(res);
                   
               }else{
                   res='{"formulario": {"Code": "-1", "message": "Servicio no disponible"}}';
               }
        }catch(Exception e){
            res='{"formulario": {"Code": "-1", "message": "Servicio no disponible"}}';
        } 
        return res;
    }
    
    
    /**
* @name getProductsOpp
* @description 
* @author eayalcor@everis.com | 03-12-2019 
* @param DetectorClassResponse dtResponse 
* @return DetectorClassProduct 
**/
    public DetectorClassProduct getProductsOpp(DetectorClassResponse dtResponse){
        
        String token = Test.isRunningTest() ? 'tokenTest' : getAnalyticsToken();
        
        String res;
        String url = sc.Callback_url__c + '/detector-necesidades/respuestas-producto';  
        String json = JSON.serializePretty(dtResponse);
        
        try{
            
            Http http =new Http();
            HttpRequest request = requestAnalytics(url,sc.x_api_key__c, json, Constants.REQUEST_METHOD_POST,token);
            
            HttpResponse response = http.send(request);
            
            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                   res=response.getbody();
                   
               }else{
                   res='{"code": "-1","message": "error"}';
               }
        }catch(Exception e){
            res='{"code": "-1","message": "Exception: ' + e.getMessage() +' "}';
        } 
        System.debug('JSON --->'+res);
        DetectorClassProduct dtProduct = (DetectorClassProduct) System.JSON.deserialize(res, DetectorClassProduct.class);
        
        return dtProduct;
    }
    
    /**
* @name consultLeadAnalyticsAsync
* @description 
* @author eayalcor@everis.com | 03-12-2019 
* @param Id leadId 
* @param String action 
* @param String nCredential 
* @return void 
**/
    @future(callout=true)
    public static void consultLeadAnalyticsAsync(Id leadId,String action, String nCredential )
    {   
        String res;
        SalesCallout co = new SalesCallout(nCredential);
        List<lead> leadList = [SELECT Id, FirstName, LastName, motherlastname_sales__c, rut_ejecutivo_sales__c, 
                               numero_de_documento_sales__c, other_phone_sales__c, Email, nuevo_correo_sales__c,
                               LeadSource, genero_sales__c, calle_sales__c, numero_sales__c, numero_de_piso_sales__c, 
                               numero_departamento_sales__c, comuna_sales__c, villa_sales__c, region_sales__c, sla_sales__c, 
                               fecha_nacimiento_sales__c,tipo_documento_sales__c, zona_sales__c, sucursal_sales__c,status  FROM LEAD Where ID=: leadId limit 1];
        if(leadList.size() >0){
            // Perform a callout to an external service
            res =  co.consultLeadAnalytics(leadList[0], action);
            system.debug('consultLeadAnalyticsAsync ---->'+res);
        }
    }
    
    /**
* @name consultLeadAnalyticsAsyncMassive
* @description 
* @author eayalcor@everis.com | 03-12-2019 
* @param List<String> leadsIds 
* @param String action 
* @param String nCredential 
* @return void 
**/
    @future(callout=true)
    public static void consultLeadAnalyticsAsyncMassive(List<String> leadsIds,String action, String nCredential )
    {   
        String res;
        SalesCallout co = new SalesCallout(nCredential);
        
        List<lead> leadList = [SELECT Id, FirstName, LastName, motherlastname_sales__c, rut_ejecutivo_sales__c, 
                               numero_de_documento_sales__c, Phone, reasignaciones_del_lead_sales__c, other_phone_sales__c, Email, nuevo_correo_sales__c,
                               LeadSource, Status, genero_sales__c, calle_sales__c, numero_sales__c, numero_de_piso_sales__c, 
                               numero_departamento_sales__c, comuna_sales__c, villa_sales__c, region_sales__c,provincia_sales__c, sla_sales__c, 
                               fecha_nacimiento_sales__c,tipo_documento_sales__c, zona_sales__c, sucursal_sales__c,rating FROM LEAD Where ID=: leadsIds];
        if(leadList.size() >0){
            
            // Perform a callout to an external service
            res =  co.consultLeadAnalyticsMassive(leadList, action);
            system.debug('consultLeadAnalyticsMassive ---->'+res);
        }
    }
    
    /**
* @name consultLeadAnalyticsMassive
* @description Informa Lead creados a Analytics.
* @author eayalcor@everis.com | 03-12-2019 
* @param List<Lead> leadList 
* @param String action 
* @return string 
**/
    public string consultLeadAnalyticsMassive(List<Lead> leadList,String action){
        
        String token = Test.isRunningTest() ? 'tokenTest' : getAnalyticsToken();
        
        String res;
        String url=sc.Callback_url__c +'/lead/gestion-leads';
        try{
            leadDataList result = new leadDataList();
            leadDataList dl = new leadDataList();
            dl.leadList = leadList;
            dl.action = action;
            system.debug('LeadData -> '+dl);
            Http http =new Http();
            system.debug('JSON'+JSON.serializePretty(dl));
            HttpRequest request = requestAnalytics(url,sc.x_api_key__c, JSON.serialize(dl), Constants.REQUEST_METHOD_POST,token);
            
            HttpResponse response = http.send(request);
            system.debug('response -> '+response);
            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                   res=response.getbody();
                   system.debug('consultLeadAnalyticsMassive --->'+res);
                   
               }else{ 
                   res='{ "code": "-1", "message": "Error: Servicio no disponible"}';
               }
        }catch(Exception e){
            system.debug('Catch Error' +e);
            res=null;
        } 
        
        return res;
    }
    
    public OpportunityDataList reassignExecutive(Opportunity opp, string prodCode){
        //Modificar response.
        String token = Test.isRunningTest() ? 'tokenTest' : getAnalyticsToken();
        OpportunityDataList result = new OpportunityDataList();
        String res;
        String url=sc.Callback_url__c +'/oportunidad/gestion-oportunidad'; 
        system.debug('url '+url);
        try{
            List<OppObj> lstOp = new List<OppObj>();
            OppObj opOb = new OppObj();
            opOb.telefono_Sales= opp.telefono_sales__c;
            opOb.telefono_Opp=opp.telefono_oportunidad_sales__c;
            opOb.stageName=opp.StageName;
            opOb.rut_ejecutivo=UtilitiesSales.formatRut(opp.Owner.RUT__c, 'WITHOUTDOT');
            opOb.rut_cuenta=opp.Numero_de_documento_sales__c;
            opOb.ownerId=opp.OwnerId;
            opOb.idOportunidad= opp.id;
            opOb.description= opp.Description;
            opOb.correoOportunidad=opp.correo_oportunidad_sales__c;
            opOb.cod_prod=prodCode;
            opOb.Accountid=opp.AccountId;
            lstOp.add(opOb);

            OpportunityDataList OppData = new OpportunityDataList();
            OppData.action=Constants.REFER_EXECUTIVE;
            OppData.StatusCode='200';
            OppData.message='OK';
            OppData.jsonMap=lstOp;
            system.debug('OppData -> '+OppData);
            Http h =new Http();
            HttpRequest req = requestAnalytics(url,sc.x_api_key__c, JSON.serialize(OppData), Constants.REQUEST_METHOD_POST,token);
           
            HttpResponse httpRes;
            httpRes = h.send(req);
            system.debug('httpRes.getStatus()'+httpRes.getStatus());
            if(httpRes.getStatus()=='200' || httpRes.getStatus()=='201'||httpRes.getStatus()=='ok' ){
                res = httpRes.getbody();
                result = (OpportunityDataList) System.JSON.deserialize(res, OpportunityDataList.class);
                system.debug('Resultado Success = '+res);    
            }else{
                //system.debug('Resultado Fail = '+res);  
                //result.jsonMap.rut_Ejecutivo = '"Error: Servicio no disponible"';
            }
        }catch(Exception e){
            System.debug('cacrggw'+e.getStackTraceString() + ' Error: ' + e.getMessage());
            OpportunityDataList OppData = new OpportunityDataList();
            OppData.action=Constants.REFER_EXECUTIVE;
            OppData.StatusCode='400';
            OppData.message='NOk';
            OppData.jsonMap=null;
            result = OppData;
        } 
        return result;
    }

    /**
    * @description 
    * @author pcelis@everis.com | 04-02-2020 
    * @param List<String> oppIds 
    * @param String action 
    * @param String nCredential 
    * @return void 
    **/
    @future(callout=true)
    public static void consultOppAnalyticsAsyncMassive(List<String> oppIds,String action, String nCredential )
    {   

        String res;
        SalesCallout co = new SalesCallout(nCredential);
        
        List<Opportunity> oppList = [SELECT Id,telefono_sales__c,telefono_oportunidad_sales__c,StageName,
                                        Owner.RUT__c,Description,correo_oportunidad_sales__c,Account.RUT__c,(SELECT Id,ProductCode FROM OpportunityLineItems) FROM Opportunity Where ID=: oppIds];
        if(oppList.size() >0){

        List<OppObj> lstOp = new List<OppObj>();
        for (Opportunity opp: oppList) {
            OppObj opOb = new OppObj();
            opOb.telefono_Sales= opp.telefono_sales__c;
            opOb.telefono_Opp=opp.telefono_oportunidad_sales__c;
            opOb.stageName=opp.StageName;
            opOb.rut_ejecutivo=UtilitiesSales.formatRut(opp.Owner.RUT__c, 'WITHOUTDOT');
            opOb.rut_cuenta=opp.Account.RUT__c;
            opOb.ownerId=opp.OwnerId;
            opOb.idOportunidad= opp.id;
            opOb.description= opp.Description;
            opOb.correoOportunidad=opp.correo_oportunidad_sales__c;
            opOb.cod_prod=opp.OpportunityLineItems[0].ProductCode;
            opOb.Accountid=opp.AccountId;
            lstOp.add(opOb);
        }
            System.debug('LISTA OPP  : '+lstOp);
            // Perform a callout to an external service
            res =  co.consultOppAnalyticsMassive(lstOp, action);
            system.debug('consultOppAnalyticsMassive ---->'+res);
        }
    }
    

    /**
    * @description 
    * @author pcelis@everis.com | 04-02-2020 
    * @param List<OppObj> oppList 
    * @param String action 
    * @return string 
    **/
    public string consultOppAnalyticsMassive(List<OppObj> oppList,String action){
        
        String token = Test.isRunningTest() ? 'tokenTest' : getAnalyticsToken();
        
        String res;
       String url=sc.Callback_url__c +'/oportunidad/gestion-oportunidad';
        try{
            OpportunityDataList OppData = new OpportunityDataList();
            OppData.action=action;
            OppData.StatusCode='200';
            OppData.message='OK';
            OppData.jsonMap=oppList;
            system.debug('OppData -> '+OppData);
            Http http =new Http();
            system.debug('JSON'+JSON.serializePretty(OppData));
            HttpRequest request = requestAnalytics(url,sc.x_api_key__c, JSON.serialize(OppData), Constants.REQUEST_METHOD_POST,token);
            
            HttpResponse response = http.send(request);
            system.debug('response -> '+response);
            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                System.debug(response.getBody());
                   res=response.getbody();
                   system.debug('consultOppAnalyticsMassive --->'+res);
                   
               }else{ 
                   res='{ "code": "-1", "message": "Error: Servicio no disponible"}';
               }
        }catch(Exception e){
            system.debug('Catch Error' +e);
            res=null;
        } 
        
        return res;
    }

    
    /**
    * @description 
    * @author pcelis@everis.com | 04-02-2020 
    * @param List<String> oppIds 
    * @param String action 
    * @param String nCredential 
    * @return void 
    **/
    @future(callout=true)
    public static void consultUserAnalyticsAsyncMassive(List<String> userIds,String action, String nCredential )
    {   
        String res;
        SalesCallout co = new SalesCallout(nCredential);
        List<UsrObj> usList = New List<UsrObj>();
        List<User> UserList = [SELECT id,RUT__c,Profile.name,FirstName,ManagerId,Username,LastName,isActive,userrole.name,Email,name FROM User Where ID=: userIds];
        
        Map<id,String> getRut_Jefe = new Map<id,String>();
        Set<string> managerIds = new Set<string>();
        for (User usr: UserList) {
            managerIds.add(usr.ManagerId);
        }
			System.debug('SET DE ID MANAGER---------> '+managerIds);
        for (User usr: [SELECT id,RUT__c FROM User WHERE id IN: managerIds]) {
            getRut_Jefe.put(usr.Id, usr.RUT__c);
        }
			System.debug('MAPS MANAGER---------> '+getRut_Jefe);
        for(User u : UserList){
        	UsrObj us =new UsrObj();
            us.RUT_Ejecutivo=UtilitiesSales.formatRut(u.RUT__c, 'WITHOUTDOT');
        	us.ProfileName=u.Profile.name;
            us.FirstName=u.FirstName;
            us.ManagerId=u.ManagerId;
            us.UserName=u.UserName;
            us.LastName=u.LastName;
            us.RUT_Jefe=UtilitiesSales.formatRut(getRut_Jefe.get(u.ManagerId),'WITHOUTDOT');
            us.isActive=string.valueOf(u.IsActive);
            us.RolName=u.userrole.name;
            us.Email=u.Email;
            us.Name=u.Name;
            us.id=u.Id;
            
            usList.add(us);
        }

            System.debug('LISTA USER  : '+usList);
            // Perform a callout to an external service
            res =  co.consultUserAnalyticsMassive(usList, action);
            system.debug('consultOppAnalyticsMassive ---->'+res);
        
    }
    

    /**
    * @description 
    * @author pcelis@everis.com | 04-02-2020 
    * @param List<OppObj> oppList 
    * @param String action 
    * @return string 
    **/
    public string consultUserAnalyticsMassive(List<UsrObj> userList,String action){
        
        String token = Test.isRunningTest() ? 'tokenTest' : getAnalyticsToken();
        
        String res;
       String url=sc.Callback_url__c +'/ejecutivo/gestion-ejecutivo';
        try{
            UserDataList userData = new UserDataList();
            userData.action=action;
            userData.message='OK';
            userData.StatusCode='200';
            userData.success='true';
           	userData.jsonMap=userList;
            system.debug('userDATAAAAA -> '+userData);
            Http http =new Http();
            system.debug('JSON'+JSON.serializePretty(userData));
            HttpRequest request = requestAnalytics(url,sc.x_api_key__c, JSON.serialize(userData), Constants.REQUEST_METHOD_POST,token);
            
            HttpResponse response = http.send(request);
            system.debug('response -> '+response);
            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                System.debug(response.getBody());
                   res=response.getbody();
                   system.debug('consultOppAnalyticsMassive --->'+res);
                   
               }else{ 
                   res='{ "code": "-1", "message": "Error: Servicio no disponible"}';
               }
        }catch(Exception e){
            system.debug('Catch Error' +e);
            res=null;
        } 
        
        return res;
    }
    
    /**
    * @description 
    * @author eayalcor@everis.com | 07-07-2020 
    * @param Set<Id> setOffers 
    * @param String action 
    **/
    @future(callout=true)
    public static void futureNotifyAnalyticsOffer(Set<Id> setOffers,String action){

        List<Oferta__c> lstOffers = [SELECT Id,Name,Ejecutivo_sales__c,Rut_Cliente_sales__c,Vigencia_Oferta_sales__c,Familia_Producto_sales__c,
                        Descripcion_oferta_sales__c,Detalle_sales__c,Origen_sales__c,Interes_Oferta_sales__c,OpportunityId__c, Motivo_no_interes_sales__c, 
                        comentario_oferta_sales__c, telefono_ivr_sales__c FROM Oferta__c WHERE Id IN : setOffers];
        
        if(lstOffers != null && !lstOffers.isEmpty()){

            for(Oferta__c offer : lstOffers){
                offer.OpportunityId__c = offer.OpportunityId__c == null ? null : offer.OpportunityId__c;
                offer.Motivo_no_interes_sales__c = offer.Motivo_no_interes_sales__c == null ? null : offer.Motivo_no_interes_sales__c;  
                offer.comentario_oferta_sales__c = offer.comentario_oferta_sales__c == null ? null : offer.comentario_oferta_sales__c; 
            }

            SalesCallout sc = new SalesCallout(Constants.ANALYTICSLEAD);
            OfferCmpController.NotifyAnalyticOffer obj = new OfferCmpController.NotifyAnalyticOffer();
            obj.code = 200;
            obj.message = null;
            obj.action = Constants.INSERTED;
            obj.OfertaList = lstOffers;

            sc.notifyAnalyticsOffer(obj);

        }

    }

    /**
    * @description 
    * @author eayalcor@everis.com | 6/3/2020 
    * @param OfferCmpController.NotifyAnalyticOffer offers 
    * @return void 
    **/
    public void notifyAnalyticsOffer(OfferCmpController.NotifyAnalyticOffer lstOffers){
        String token = Test.isRunningTest() ? 'tokenTest' : getAnalyticsToken();

        String res;
        String url=sc.Callback_url__c +'/oferta/gestion-oferta';
        String json = JSON.serializePretty(lstOffers);
        System.debug('JSON REQUEST: ' + json);
        
        try{
            
            Http http =new Http();
            HttpRequest request = requestAnalytics(url,sc.x_api_key__c, json, Constants.REQUEST_METHOD_POST,token);
            
            HttpResponse response = http.send(request);
            
            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                   res=response.getbody();
                   
               }else{
                   res='{"code": "-1","message": "error"}';
               }
        }catch(Exception e){
            res='{"code": "-1","message": "Exception: ' + e.getMessage() +' "}';
        } 

        System.debug('Response Analytics: ' + res);
    }

/**
========================================================================================================================
----------------------------------------------------ANALYTICS MARCA----------------------------------------------------------
========================================================================================================================
*/
    public PropensityController.ResponseMarca checkBrandStatus(PropensityController.RequestMarca requestMarca){
        String token = Test.isRunningTest() ? 'tokenTest' : getAnalyticsToken();

        String res;
        String url=sc.Callback_url__c +'/consultar-marcas';
        String json = JSON.serializePretty(requestMarca);

        
        try{
            
            Http http =new Http();
            HttpRequest request = requestAnalytics(url,sc.x_api_key__c, json, Constants.REQUEST_METHOD_POST,token);
            
            HttpResponse response = http.send(request);
            
            if(response.getStatus()== Constants.RESPONSE_200 
            || response.getStatus()== Constants.RESPONSE_201
            ||response.getStatus()== Constants.RESPONSE_OK ){
                
                res=response.getbody();
                
            }else{
                res='{"codigo": "-1","mensaje": "error"}';
            }
        }catch(Exception e){
            res='{"codigo": "-1","mensaje": "Exception: ' + e.getMessage() +' "}';
        } 

        PropensityController.ResponseMarca rspMarca = (PropensityController.ResponseMarca) System.JSON.deserialize(res, PropensityController.ResponseMarca.class);

        return rspMarca;
    }
    


    /**
    * @description 
    * @author eayalcor@everis.com | 08-20-2020 
    * @param DTOCaseAnalytics.RequestDtoCaseAnalytics dto 
    **/
    public void updateBrand(DTOCaseAnalytics.RequestDtoCaseAnalytics dto){
        
        String token = Test.isRunningTest() ? 'tokenTest' : getAnalyticsToken();

        String res;
        String url=sc.Callback_url__c +'/actualizar-marcas';
        String json = JSON.serializePretty(dto);
        json = json.replace('type_z', 'type');
        json = json.replace('RUT_z', 'RUT__c');
        json = json.replace('Tipo_de_documento_de_identidad', 'Tipo_de_documento_de_identidad__c');
        System.debug(json);
        
        try{
             
            Http http =new Http();
            HttpRequest request = requestAnalytics(url,sc.x_api_key__c, json, Constants.REQUEST_METHOD_POST,token);
            
            HttpResponse response = http.send(request);
            
            if(response.getStatus()== Constants.RESPONSE_200 
            || response.getStatus()== Constants.RESPONSE_201
            ||response.getStatus()== Constants.RESPONSE_OK ){
                
                res=response.getbody();
                
            }else{
                res='{"codigo": "-1","mensaje": "error"}';
            }
        }catch(Exception e){
            res='{"codigo": "-1","mensaje": "Exception: ' + e.getMessage() +' "}';
        } 

        System.debug('Response:' + res);
    }


    /**
    * @description 
    * @author eayalcor@everis.com | 08-20-2020 
    * @param String json 
    * @param String nCredential 
    **/
 	@future(callout=true)
    public static void notifyBrand(String json, String nCredential,Set<Id> lstIds) 
    {   
        try{
            
            System.debug('Json deserilize:' + json);
            DTOCaseAnalytics.ListCaseTmp dtoTmpCase = (DTOCaseAnalytics.ListCaseTmp) System.JSON.deserialize(json,DTOCaseAnalytics.ListCaseTmp.class);
    
            Map<String,Integer> mapMarca = UtilitiesSales.getCaseFieldNotify();
            Map<String,String> mapIdsExecutive = UtilitiesSales.getRutByIdExecutive(lstIds);
            System.debug('Maps:' + mapIdsExecutive);
    
            String res;
            SalesCallout co = new SalesCallout(nCredential);
    
            for(DtoCaseAnalytics.CaseTmp cs : dtoTmpCase.lstCase){
                system.debug(Boolean.valueOf(cs.caseTmp.Desuscribir_Email__c));
                system.debug(Boolean.valueOf(cs.caseTmp.Desuscribir_Telefono__c));
                
                DTOCaseAnalytics.RequestDtoCaseAnalytics request = new DTOCaseAnalytics.RequestDtoCaseAnalytics();
                
                DTOCaseAnalytics.ProcesoOrigenMarca procesoOrigen = new DTOCaseAnalytics.ProcesoOrigenMarca();
                procesoOrigen.idProceso = cs.fieldName.equalsIgnoreCase('Status') ? 8 : 7;
                
                DTOCaseAnalytics.Detalle detalle = new DTOCaseAnalytics.Detalle();
                detalle.Id = cs.caseTmp.CaseNumber;
                detalle.type_z = Constants.CASE_OBJECT;
                detalle.Rut_Creador_Caso = mapIdsExecutive.get(cs.createdId);
                detalle.Rut_Cierre_Caso = mapIdsExecutive.get(cs.ownerId);
                
                List<DTOCaseAnalytics.DetalleMarcas> lstDetalleMarca = new List<DTOCaseAnalytics.DetalleMarcas>();
                
                if(cs.fieldName.equalsIgnoreCase('Comparte_Datos__c')){
                    DTOCaseAnalytics.DetalleMarcas objDetalle = new DTOCaseAnalytics.DetalleMarcas();
                    objDetalle.idTipoMarca = mapMarca.get(cs.fieldName);
                    objDetalle.vigente = cs.caseTmp.Comparte_Datos__c.equalsIgnoreCase('Si') ? true : false;
                    
                    lstDetalleMarca.add(objDetalle);
                    if(cs.caseTmp.Comparte_Datos__c.equalsIgnoreCase('Si')){
                        DTOCaseAnalytics.DetalleMarcas objDetalle2 = new DTOCaseAnalytics.DetalleMarcas();
                        objDetalle2.idTipoMarca = 2;
                        objDetalle2.vigente = cs.caseTmp.Comparte_Datos__c.equalsIgnoreCase('Si') ? true : false;
                        lstDetalleMarca.add(objDetalle2);
                    }
                    
                }else if(cs.fieldName.equalsIgnoreCase('Status')){
                    DTOCaseAnalytics.DetalleMarcas objDetalle = new DTOCaseAnalytics.DetalleMarcas();
                    objDetalle.idTipoMarca = mapMarca.get(cs.fieldName);
                    objDetalle.vigente = cs.caseTmp.Comparte_Datos__c.equalsIgnoreCase('Si') ? true : false;
                    if(cs.caseTmp.Status == Constants.CASE_STATUS_CERRADO && cs.caseTmp.Comparte_Datos__c.equalsIgnoreCase('Si')){
                        objDetalle.vigente = false;
                    }else{
                        objDetalle.vigente = true;
                    }
                    lstDetalleMarca.add(objDetalle);
                    if(cs.caseTmp.Comparte_Datos__c.equalsIgnoreCase('Si')) {
                        DTOCaseAnalytics.DetalleMarcas objDetalle2 = new DTOCaseAnalytics.DetalleMarcas();
                        objDetalle2.idTipoMarca = 2;
                        objDetalle2.vigente = cs.caseTmp.Comparte_Datos__c.equalsIgnoreCase('Si') ? true : false;
                        if(cs.caseTmp.Status == Constants.CASE_STATUS_CERRADO){
                            objDetalle2.vigente = false;
                        }
                        lstDetalleMarca.add(objDetalle2);
                    }
                    
                }else{
                    DTOCaseAnalytics.DetalleMarcas objDetalle = new DTOCaseAnalytics.DetalleMarcas();
                    objDetalle.idTipoMarca = mapMarca.get(cs.fieldName);
                    objDetalle.vigente =  Boolean.valueOf(cs.caseTmp.get(cs.fieldName));
                    
                    if(objDetalle.idTipoMarca == 12){
                        objDetalle.vigente = true; 
                    }
                    if(Boolean.valueOf(cs.caseTmp.Desuscribir_Email__c) && Boolean.valueOf(cs.caseTmp.Desuscribir_Telefono__c)){
                        DTOCaseAnalytics.DetalleMarcas objDetalle2 = new DTOCaseAnalytics.DetalleMarcas();
                        objDetalle2.idTipoMarca = objDetalle.idTipoMarca==12 ? 4 : 12; 
                        if(cs.caseTmp.Sub_estado_Nectia__c == Constants.CASE_SUBESTADONECTIA_CANCELADO || 
                           cs.caseTmp.sub_estado_nectia__c == constants.CASE_SUBESTADONECTIA_RECHAZADO ){
                               objDetalle2.vigente = false;
                           }else{
                               objDetalle2.vigente = true;
                           }
                        
                        lstDetalleMarca.add(objDetalle2);
                    }
                    if(cs.caseTmp.Sub_estado_Nectia__c == Constants.CASE_SUBESTADONECTIA_CANCELADO || 
                       cs.caseTmp.sub_estado_nectia__c == constants.CASE_SUBESTADONECTIA_RECHAZADO ){
                           procesoOrigen.idProceso = 8;
                           if(objDetalle.idTipoMarca == 12 || objDetalle.idTipoMarca == 4){
                               objDetalle.vigente = false;
                           }  
                       }  
                    lstDetalleMarca.add(objDetalle);
                } 
                request.detalleMarcas = lstDetalleMarca;
                request.detalle = detalle;
                request.procesoOrigenMarca = procesoOrigen;
                request.type_z = Constants.ACCOUNT;
                request.Tipo_de_documento_de_identidad = Constants.RUT;
                request.RUT_z = cs.caseTmp.Rut_del_Cliente__c;    
                co.updateBrand(request);
            }
        }catch(Exception ex){
            System.debug('Exception: '+ ex.getStackTraceString() + ex.getMessage()); 
        }
        
    }

/**
========================================================================================================================
----------------------------------------------------VISUALTIME----------------------------------------------------------
========================================================================================================================
*/
      
    /**
    * @description 
    * @author eayalcor@everis.com | 2/19/2020 
    * @param String proposalNumber 
    * @param String branchNumber 
    * @param String productNumber 
    * @return VTimeClass.ProposalClass 
    **/
    public VTimeClass.ProposalClass getProposalStatus(String proposalNumber, String branchNumber, String productNumber){
        
        String res;
        String url = sc.Callback_url__c +'/v1/integracion-crm-ventas/estado/propuesta/'+proposalNumber+'/'+branchNumber+'/'+productNumber;  
        //String url = sc.Callback_url__c +'/v1/integracion-crm-ventas/estado/propuesta/5504053/1/360';  
        
        System.debug('URL: '+ url);

        try{
            
            Http http =new Http();
            HttpRequest request = new HttpRequest();
            request = requestVTime(url, '', Constants.REQUEST_METHOD_GET,Constants.TYPECALL_MANUAL);          
            
            HttpResponse response = http.send(request);
            System.debug('Response ' +response.getStatus());
            System.debug('Response ' +response.getStatuscode());

            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                   res=response.getbody();
                   
            }else{
                res='{"resultado": 0,"descripcion": "error servicio"}';
            }
        }catch(Exception e){
            if(e.getMessage().equalsIgnoreCase('ERROR_401')){
                res='{"resultado": 0,"descripcion": "Favor iniciar sesión SSO"}';
            }else{
                res='{"resultado": 0,"descripcion": "Error en Servicio "}';
            }
        } 
        
        VTimeClass.ProposalClass prpStatus = (VTimeClass.ProposalClass) System.JSON.deserialize(res, VTimeClass.ProposalClass.class);
        
        return prpStatus;
    }
    /**
    * @description 
    * @author eayalcor@everis.com | 2/19/2020 
    * @param String proposalNumber 
    * @param String branchNumber 
    * @param String productNumber 
    * @return VTimeClass.MandateClass 
    **/
    public VTimeClass.MandateClass getMandateStatus(String proposalNumber, String branchNumber, String productNumber){
        
        String res;
        String url = sc.Callback_url__c +'/v1/integracion-crm-ventas/estado/mandato/'+proposalNumber+'/'+branchNumber+'/'+productNumber;  
        //String url = sc.Callback_url__c +'/v1/integracion-crm-ventas/estado/mandato/4033873/1/36';
        System.debug('Mandato URL:' +url);
        
        try{
            
            Http http =new Http();
            HttpRequest request = new HttpRequest();
            request = requestVTime(url, '', Constants.REQUEST_METHOD_GET,Constants.TYPECALL_MANUAL);
            
            HttpResponse response = http.send(request);
            
            System.debug('Response ' +response.getStatus());
            System.debug('Response ' +response.getStatuscode());
            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                   res=response.getbody();
                   System.debug('Mandato:' + res);
                   
               }else{
                   res='{"resultado": 0,"descripcion": "error servicio"}';
               }
        }catch(Exception e){
            
            if(e.getMessage().equalsIgnoreCase('ERROR_401')){
                res='{"resultado": 0,"descripcion": "Favor iniciar sesión SSO"}';
            }else{
                res='{"resultado": 0,"descripcion": "Error en Servicio "}';
            }
        } 
        
        VTimeClass.MandateClass mdtStatus = (VTimeClass.MandateClass) System.JSON.deserialize(res, VTimeClass.MandateClass.class);
        mdtStatus.message = mdtStatus.resultado == 0 ? Constants.OK : mdtStatus.message;
        
        return mdtStatus;
    }
    /**
    * @description 
    * @author eayalcor@everis.com | 2/19/2020 
    * @param ProposalController.ProposalResponse prpResponse 
    * @param String refreshToken 
    * @return ProposalController.StoreProposalClass 
    **/
    public ProposalController.StoreProposalClass setProposal(ProposalController.ProposalResponse prpResponse, String refreshToken,String typeCall){
        
        String res;
        ProposalController.StoreProposalClass stProposal;
        String url = sc.Callback_url__c +'/v1/integracion-crm-ventas/propuesta';   
        System.debug('URL: ' +url);
        String json = JSON.serializePretty(prpResponse);
        system.debug('JSON: ' +json);
        
        
        try{
            
            Http http =new Http();
            HttpRequest request = new HttpRequest();
            request = requestVTime(url, json, Constants.REQUEST_METHOD_POST,typeCall);
            
            HttpResponse response = http.send(request);

            System.debug('Response: '+ response.getBody());
            System.debug('Code: '+ response.getStatusCode());

            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               || response.getStatus()== Constants.RESPONSE_OK ){
                   
                res=response.getbody();

            }else{
                res= '{"estado": -1,"mensaje": "El servicio esta con problemas temporalmente"}';
            }   
        }catch(Exception e){
			System.debug('errores'+e.getMessage());
            if(e.getMessage().equalsIgnoreCase('ERROR_401')){
                res='{"estado": -1,"mensaje": "Favor iniciar sesión SSO"}';
            }else{
                res='{"estado": -1,"mensaje": "Ha ocurrido un error. Favor contactar al Administrador."}';
            }

        } 

        stProposal = (ProposalController.StoreProposalClass) System.JSON.deserialize(res, ProposalController.StoreProposalClass.class);
        
        return stProposal;
    }

/**
========================================================================================================================
----------------------------------------------------CUMBRES----------------------------------------------------------
========================================================================================================================
*/

    /**
    * @description 
    * @author eayalcor@everis.com | 6/23/2020 
    * @return String 
    **/
    @TestVisible
    private String getTokenByClientCredencial(){
        
        String res;
        String url = sc.URL_sales__c;
        String payload = 'client_id='+EncodingUtil.urlEncode(sc.client_id__c ,'UTF-8')+'&client_secret='+
            EncodingUtil.urlEncode(sc.Client_Secret__c,'UTF-8')+'&grant_type=client_credentials';
        
        System.debug('Payload --> ' + payload);
               
        try{
            
            Http http =new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod(Constants.REQUEST_METHOD_POST);
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.setTimeout(120000);
            request.setEndpoint(url); 
            request.setBody(payload);  
            HttpResponse response = http.send(request);
            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){

                   res=response.getbody();
                   
               }else{
                   res='{"access_token": "-1", "token_type": "Servicio no disponible"}';
               }
            
        }catch(Exception e){
            res='{"access_token": "-1", "token_type": "Servicio no disponible"}';
            System.debug('Error -->' + e.getStackTraceString());
        } 

        AccessToken accToken = (AccessToken) System.JSON.deserialize(res, AccessToken.class); 
        System.debug('Pbject Token -->' + accToken);
        return accToken.access_token;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 6/23/2020 
    * @param OppCumbresButtonController.dtoRequestSetParametros request 
    * @return OppCumbresButtonController.ResponseDto 
    **/
    public OppCumbresButtonController.ResponseDto setCumbres(OppCumbresButtonController.RequestDto dto){
        OppCumbresButtonController.ResponseDto infCumbres = new OppCumbresButtonController.ResponseDto();
        String token = Test.isRunningTest() ? 'tokenTest' : getTokenByClientCredencial();

        String res;
        String url = sc.Callback_url__c; //+'/Banca/OperacionCargaMasiva/API/RegistraNroOportunidadSalesForce';
        String json = JSON.serializePretty(dto);

        System.debug('JSON: ' + json);
        
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request = requestCumbres(url, json, Constants.REQUEST_METHOD_POST, token);
            HttpResponse response = http.send(request);

            if(response.getStatus() == Constants.RESPONSE_200 || response.getStatus() == Constants.RESPONSE_201 || response.getStatus() == Constants.RESPONSE_OK){
                res = response.getbody();
            }else{
                res = '{"dtoResponseCodigosEstadoHttp": {"codigo": "200","mensaje": "OK","descripcion": "OK"},"dtoResponseSetParametros": {"codigoError": "1","msjError": "Error"}}';
            }   
        }catch(Exception e){    
            res = res = '{"dtoResponseCodigosEstadoHttp": {"codigo": "200","mensaje": "OK","descripcion": "OK"},"dtoResponseSetParametros": {"codigoError": "1","msjError": "Contactar con Administrador"}}';
        }
        
        infCumbres = (OppCumbresButtonController.ResponseDto) System.JSON.deserialize(res, OppCumbresButtonController.ResponseDto.class);
            
        return infCumbres;
    }
/**
========================================================================================================================
----------------------------------------------------ALFRESCO----------------------------------------------------------
========================================================================================================================
*/
    public ResponseDTOAlfresco uploadFileAlfresco(RequestDTOAlfresco dto){
        ResponseDTOAlfresco rspAlfresco = new ResponseDTOAlfresco();
        String token = Test.isRunningTest() ? 'tokenTest' : getTokenByClientCredencial();

        String res;
        String url = sc.Callback_url__c +'/BancaPersonas/API/Documentos/Subir';
        String json = JSON.serialize(dto,true);

        System.debug('JSON: ' + json);
        
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request = requestAlfresco(url, json, Constants.REQUEST_METHOD_POST, token);
            HttpResponse response = http.send(request);

            if(response.getStatus() == Constants.RESPONSE_200 || response.getStatus() == Constants.RESPONSE_201 || response.getStatus() == Constants.RESPONSE_OK){
                res = response.getbody();
            }else{
                res = '{"dtoResponseCodigosEstadoHttp":{"codigo":"400","mensaje":"ERROR","descripcion":"Error Request"},"dtoResponseSetParametros":{"codigoError":"301","msjError":"Ha ocurrido un error inesperado en la ejecucion"},"salidaAlfresco":{"codigo":"400","idAlfresco":null,"mensaje":"Ha ocurrido un problema - Contacte con el Administrador"}}';
            }   
        }catch(Exception e){
            System.debug('Response:' + e.getMessage());
            res = res = '{"dtoResponseCodigosEstadoHttp":{"codigo":"500","mensaje":"ERROR","descripcion":"Internal Server Error"},"dtoResponseSetParametros":{"codigoError":"301","msjError":"Ha ocurrido un error inesperado en la ejecucion"},"salidaAlfresco":{"codigo":"400","idAlfresco":null,"mensaje":"Ha ocurrido un problema - Contacte con el Administrador"}}';
        }
        
        rspAlfresco = (ResponseDTOAlfresco) System.JSON.deserialize(res, ResponseDTOAlfresco.class);
        System.debug('response salescallout'+rspAlfresco);    
        return rspAlfresco;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 07-08-2020 
    * @param RequestDTOAlfresco dto 
    * @return ResponseDTOAlfresco 
    **/
    public ResponseDTOAlfresco viewFileAlfresco(RequestDTOAlfresco dto){
        ResponseDTOAlfresco rspAlfresco = new ResponseDTOAlfresco();
        String token = Test.isRunningTest() ? 'tokenTest' : getTokenByClientCredencial();

        String res;
        String url = sc.Callback_url__c +'/BancaPersonas/API/Documentos/ObtenerDocumentoPorId';
        String json = JSON.serialize(dto,true);

        System.debug('JSON: ' + json);
        
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request = requestAlfresco(url, json, Constants.REQUEST_METHOD_POST, token);
            HttpResponse response = http.send(request);

            if(response.getStatus() == Constants.RESPONSE_200 || response.getStatus() == Constants.RESPONSE_201 || response.getStatus() == Constants.RESPONSE_OK){
                res = response.getbody();
            }else{
                res = '{"dtoResponseCodigosEstadoHttp":{"codigo":"500","mensaje":"ERROR","descripcion":"Internal Server Error"},"dtoResponseSetParametros":{"codigoError":"500","msjError":"Ha ocurrido un error inesperado en la ejecucion"},"salidaDocAlfresco":{"bytes":null,"codigo":null,"contentType":null,"mensaje":null,"nombreArchivo":null}}';
            }   
        }catch(Exception e){
            res = res = '{"dtoResponseCodigosEstadoHttp":{"codigo":"500","mensaje":"ERROR","descripcion":"Internal Server Error"},"dtoResponseSetParametros":{"codigoError":"500","msjError":"Ha ocurrido un error inesperado en la ejecucion"},"salidaDocAlfresco":{"bytes":null,"codigo":null,"contentType":null,"mensaje":null,"nombreArchivo":null}}';
        }
        
        rspAlfresco = (ResponseDTOAlfresco) System.JSON.deserialize(res, ResponseDTOAlfresco.class);
            
        return rspAlfresco;
    }

/**
========================================================================================================================
----------------------------------------------------DOCUWARE----------------------------------------------------------
========================================================================================================================
*/
    
    /**
    * @description 
    * @author eayalcor@everis.com | 6/23/2020 
    * @return String 
    **/
    @TestVisible
    private String getDocuwareToken(){
        
        String res;
        String url = sc.URL_sales__c;
        String payload = 'client_id='+EncodingUtil.urlEncode(sc.client_id__c ,'UTF-8')+'&client_secret='+
            EncodingUtil.urlEncode(sc.Client_Secret__c,'UTF-8')+'&username='+ EncodingUtil.urlEncode(sc.username__c,'UTF-8')+
            +'&password='+ EncodingUtil.urlEncode(sc.password__c,'UTF-8')+'&grant_type=password';
        
        System.debug('Payload: ' + payload);
               
        try{
            
            Http http =new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod(Constants.REQUEST_METHOD_POST);
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.setTimeout(120000);
            request.setEndpoint(url); 
            request.setBody(payload);  
            HttpResponse response = http.send(request);
            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){

                   res=response.getbody();
                   
               }else{
                   System.debug('Response :' +response.getbody());
                   res='{"access_token": "-1", "token_type": "Servicio no disponible"}';
               }
            
        }catch(Exception e){
            res='{"access_token": "-1", "token_type": "Servicio no disponible"}';
        } 
		
        System.debug('Response : ' + res);

        
        AccessToken accToken = (AccessToken) System.JSON.deserialize(res, AccessToken.class);
                
        return accToken.access_token;
    }
    
    public DTODocuware.ResponseUploadDocuware uploadFileDocuware(DTODocuware.RequestUploadDocuware dto){
        DTODocuware.ResponseUploadDocuware rspDocuware = new DTODocuware.ResponseUploadDocuware();
        String token = Test.isRunningTest() ? 'tokenTest' : getDocuwareToken();
        String res;
        String url = sc.Callback_url__c +'documento/actualizar';
        String json = JSON.serialize(dto,true);
        System.debug('JSON: ' + json);
        
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request = requestDocuware(url, json, Constants.REQUEST_METHOD_POST, token);

            HttpResponse response = http.send(request);

            if(response.getStatus() == Constants.RESPONSE_200 || response.getStatus() == Constants.RESPONSE_201 || response.getStatus() == Constants.RESPONSE_OK){
                res = response.getbody();
            }else{
                res = '{"dwDocId": null,"mensajeServicio": "NOK","codigoServicio": "1","mensaje": "Ha ocurrido un error, contacte su administrador","codigo": "0000"}';
            }   
        }catch(Exception e){
            System.debug('Response:' + e.getMessage());
            res = res = '{"dwDocId": null,"mensajeServicio": "NOK","codigoServicio": "1","mensaje": "Ha ocurrido un error, contacte su administrador","codigo": "0000"}';
        }
        
        rspDocuware = (DTODocuware.ResponseUploadDocuware) System.JSON.deserialize(res, DTODocuware.ResponseUploadDocuware.class);
            System.debug('Response:' +rspDocuware);
        return rspDocuware;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 08-10-2020 
    * @param DTODocuware.RequestUploadDocuware dto 
    * @return DTODocuware.ResponseUploadDocuware 
    **/
    public DTODocuware.ResponseGetDocuware getFileDocuware(DTODocuware.RequestGetDocuware dto){
        DTODocuware.ResponseGetDocuware rspDocuware = new DTODocuware.ResponseGetDocuware();
        String token = Test.isRunningTest() ? 'tokenTest' : getDocuwareToken();
        String res;
        String url = sc.Callback_url__c +'documento/obtener';
        String json = JSON.serialize(dto,true);
        System.debug('JSON: ' + json);
        
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request = requestDocuware(url, json, Constants.REQUEST_METHOD_POST, token); 

            HttpResponse response = http.send(request);

            if(response.getStatus() == Constants.RESPONSE_200 || response.getStatus() == Constants.RESPONSE_201 || response.getStatus() == Constants.RESPONSE_OK){
                res = response.getbody();
            }else{
                res = '{"codigo": "0000","mensaje": "Ha ocurrido un error, contacte su administrador","mensajeServicio": "NOK","codigoServicio": "1","documents": {"documentResult":[]}}';
            }   
        }catch(Exception e){
            res = '{"codigo": "0000","mensaje": "Ha ocurrido un error, contacte su administrador","mensajeServicio": "NOK","codigoServicio": "1","documents": {"documentResult":[]}}';
        }
        
        rspDocuware = (DTODocuware.ResponseGetDocuware) System.JSON.deserialize(res, DTODocuware.ResponseGetDocuware.class);
            
        return rspDocuware;
    }
  
    /**
----------------------------------------------------RRHH----------------------------------------------------------
========================================================================================================================
*/
    

    public InfoUserBatch.ResponseRRHH getInfoUserRRHH (InfoUserBatch.RequestRRHH dto){
        InfoUserBatch.ResponseRRHH rspRRHH = new InfoUserBatch.ResponseRRHH();
        
        String token = Test.isRunningTest() ? 'tokenTest' :  getTokenByClientCredencial();
        String res;
        String url = sc.Callback_url__c + '/consulta/usuarios';
        String json = JSON.serialize(dto,true);
       
        
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request = requestRRHH(url, json, Constants.REQUEST_METHOD_POST, token); 

            HttpResponse response = http.send(request);

            if(response.getStatus() == Constants.RESPONSE_200 || response.getStatus() == Constants.RESPONSE_201 || response.getStatus() == Constants.RESPONSE_OK){
                res = response.getbody();
            }else{
                res = '{"codigo":1,"mensaje":"NOK","registros":[{}]}';
            }   
        }catch(Exception e){
            res = '{"codigo":2,"mensaje":"NOK","registros":[{}]}';
        } Finally {
			rspRRHH = (InfoUserBatch.ResponseRRHH) System.JSON.deserialize(res, InfoUserBatch.ResponseRRHH.class);
        }
        
        return rspRRHH;
    }
    
/**
========================================================================================================================
---------------------------------------------------- CUMBRES PF --------------------------------------------------------
========================================================================================================================
*/   
    /**
    * @description 
    * @author gcabrerp@everis.com | 12/01/2020 
    * @return String 
    **/
    public String callServiceCumbres (String dto){
        ResponseDTO cumbresToken = getTokenCumbres();
        String token = cumbresToken.dtoResponseSetParametros.dataToken.token;
        String requestId = cumbresToken.dtoResponseSetParametros.dataToken.requestID;
        dto = '{"dtoRequestSetParametros":'+dto+'}'; // Encabezado dtoRequestSetParametros
        String res;
        String url = sc.Callback_url__c;
        
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request = requestCumbres(url, dto, 'POST', token, requestID); 
            HttpResponse response = http.send(request);

            if(response.getStatus() == Constants.RESPONSE_200 || response.getStatus() == Constants.RESPONSE_201 || response.getStatus() == Constants.RESPONSE_OK){
                res = response.getbody();
                System.debug('callServiceCumbres '+response.getbody());
            }else{
                res=response.getbody();
                System.debug('Error callServiceCumbres '+response.getbody());
            }   
        }catch(Exception e){
            system.debug('Exception callServiceCumbres '+e.getMessage());
            res = '{"registros":[{}]}';
        } Finally {
        }
        
        return res;
    }
    /**
    * @description 
    * @author cagonzle@everis.com | 18/12/2020 
    * @return String 
    **/
    @TestVisible
    private ResponseDTO getTokenCumbres(){

        String mockRes = '{"dtoResponseSetParametros": {"dataToken": {"token": "test","requestID": "test","minutosRestantes": 180}}}';
        
        String[] codApp = sc.Codigo_App__c.split('\\.');
        String codAppHeader = codApp[0];
        String codAppBody = codApp[1];

        String res;
        String url = sc.URL_sales__c;
        String jsonBody = '{"user": "'+sc.username__c+'","pass": "'+sc.password__c+'","codigoAplicacion": "'+codAppBody+'"}';
        try{
            Http http =new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod(Constants.REQUEST_METHOD_POST);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('codigoAplicacion', codAppHeader);
            request.setHeader('empresaAplicacion', sc.Empresa_App__c);
            if(!System.Test.isRunningTest()){
                this.sourceIp = (this.sourceIp == null ? Auth.SessionManagement.getCurrentSession().get('SourceIp') : this.sourceIp); // Mejora metodo Future
                request.setHeader('ipCliente', this.sourceIp);            
            }             
            request.setHeader('codigoCanal', sc.Codigo_Canal__c);
            request.setHeader('modalidad', sc.Modalidad__c);
            request.setTimeout(120000);
            request.setEndpoint(url); 
            request.setBody(jsonBody);  
            HttpResponse response = http.send(request);
            if(response.getStatus()== Constants.RESPONSE_200 || response.getStatus()== Constants.RESPONSE_201 ||response.getStatus()== Constants.RESPONSE_OK ){
                   res=response.getbody();                   
            }else{
                res=response.getbody();
                System.debug('Error Token Cumbres'+response.getbody());
            }            
        }catch(Exception e){
            System.debug('Error Token Cumbres'+e.getMessage());
            res='{"dtoResponseCodigosEstadoHttp": {"codigo": "102","mensaje": "DENIED","descripcion": "'+e.getMessage()+'"},"dtoResponseSetParametros": null}';
        } 
        res = (Test.isRunningTest() ? mockRes : res );
        ResponseDTO cumbresToken = (ResponseDTO) System.JSON.deserialize(res, ResponseDTO.class);     
        return cumbresToken;
    }

    /**
    * @description 
    * @author cagonzle@everis.com | 18-12-2020 
    * @param String url 
    * @param String json 
    * @param String method 
    * @param String token 
    * @return HttpRequest 
    **/
    private  HttpRequest requestCumbres(String url,String json,String method,String token, String requestid){
        
        HttpRequest request = new HttpRequest();
        String[] codApp = sc.Codigo_App__c.split('\\.');
        String codAppHeader = codApp[0];
        String codAppBody = codApp[1];
        
        request.setTimeout(120000);
        request.setEndpoint(url);                    
        request.setHeader('content-type','application/json');
        request.setHeader('codigoAplicacion',codAppHeader); 
        request.setHeader('empresaAplicacion', sc.Empresa_App__c); 
        request.setHeader('codigoCanal',sc.Codigo_Canal__c);  
        request.setHeader('token-authorization', token);
        request.setHeader('requestid', requestid);
        if(!System.Test.isRunningTest()){
        	this.sourceIp = (this.sourceIp == null ? Auth.SessionManagement.getCurrentSession().get('SourceIp') : this.sourceIp); // Mejora metodo Future
        	request.setHeader('ipcliente', this.sourceIp);            
        }        
        request.setHeader('modalidad', sc.Modalidad__c);
        request.setHeader('ClientId', sc.username__c);
        request.setMethod(method);
        request.setBody(json);
        System.debug('BODY CUMBRES '+json);
        
        return request;
    }    

    public class ResponseDTO {
        public DtoResponseCodigosEstadoHttp dtoResponseCodigosEstadoHttp;
        public DtoResponseSetParametros dtoResponseSetParametros;
    } 
    
    public class DtoResponseCodigosEstadoHttp {
        public String codigo {get; set;}
        public String mensaje {get; set;}
        public String descripcion {get; set;}
    }

    public class DtoResponseSetParametros {
        public String codigoError {get; set;}
        public String msjError {get; set;}
        public DataToken dataToken {get; set;}
    }

    public class DataToken {
        public String token {get; set;}
        public String requestID {get; set;}
    } 
}