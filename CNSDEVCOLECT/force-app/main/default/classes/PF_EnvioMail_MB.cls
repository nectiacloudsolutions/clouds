/*********************************************************************************************************
@Author       lmunogar@everis.com
@name         PF_CrearCaso_WSRest
@CreateDate   21/08/2020
@Description  Service que envía correo a MasterBase
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
21/08/2020                    lmunogar@everis.com                 Initial Version
16/10/2020                    lmunogar@everis.com                 Incorporación de nuevos envíos de correos a MB
30/12/2020                    mbeltrab@everis.com                 Cambio de emisor de correos de Digital a Masterbase directo
**********************************************************************************************************/
public class PF_EnvioMail_MB {
    private static Sales_Connect__mdt sc;
	private static String endpointMasterBase;
    private static StaticResource docMail;
    private static String nombreDocAdj;
	private static List<PF_Envio_Masterbase__e> lstEventos;
	private static Map<String, List<NotificacionPorMasterBase__c>> mapNotiMB;
    private static Map<String,Master_Base_Logger__c> mapLogger;
    private static List<Master_Base_Logger__c> newMBLogger;
    
    private static void loadConfig(){
        if(String.isEmpty(endpointMasterBase)){
            sc = [SELECT password__c,URL_sales__c,username__c,user_pool_id__c,x_api_key__c,token__c,Callback_url__c,
                   client_id__c,Client_Secret__c,Codigo_App__c,Codigo_Canal__c,Empresa_App__c,Modalidad__c
                   FROM Sales_Connect__mdt WHERE DeveloperName= 'MASTERBASE' LIMIT 1];
           endpointMasterBase = sc.Callback_url__c;            
       }        
    }

    private static void loadEmailStatus(Set<Id> relatedIds, String fieldRelated){
        if(mapLogger != null ){ return; }

        mapLogger = new Map<String,Master_Base_Logger__c>();
        String key = '';
        for(Master_Base_Logger__c mbl : (List<Master_Base_Logger__c>)
        Database.query('SELECT Key__c, Status__c, '+fieldRelated+' FROM Master_Base_Logger__c WHERE '+fieldRelated+' IN: relatedIds ') ){
            mapLogger.put(mbl.Key__c, mbl);
        }
    }
    
    private static void programarEnvios(){
        List<Database.SaveResult> sr = EventBus.publish(lstEventos);
    }
    
    private static void crearEventos(Datetime fechaHora, String json){
        PF_Envio_Masterbase__e evento = new PF_Envio_Masterbase__e();
        evento.PF_FechaHora_Envio__c = fechaHora;
        evento.PF_BodyJson__c = json;
        lstEventos.add(evento);
    }
    
	public static void enviarCorreoMB(List<Case> lstCaso, Map<Id,Case> mapNew, Map<Id,Case> mapCaseOld, Map<Id, User> mapUsuario){
        if (lstCaso == null || lstCaso.Size() == 0){ return;}
        newMBLogger = (newMBLogger == null ? new List<Master_Base_Logger__c>() : newMBLogger );
        loadConfig();
        
		lstEventos = new List<PF_Envio_Masterbase__e>();
		cargarMapaNotificaciones();
        loadEmailStatus(mapNew.keySet(), 'Related_Case__c');
        List<NotificacionPorMasterBase__c> notifMB = new List<NotificacionPorMasterBase__c>();
		PF_EnvioMail_MB_JSON.BodyMail BodyMail = new PF_EnvioMail_MB_JSON.BodyMail();
        String emailCaso='';

        for(Case cs: lstCaso){
            if( String.isNotBlank(cs.Correo_electr_nico__c)  || (mapNew != null && String.isNotBlank(mapNew.get(cs.Id).Correo_electr_nico__c) )){
                Case csOldSt = (mapCaseOld != null && mapCaseOld.containsKey(cs.Id)) ? mapCaseOld.get(cs.Id) : new Case(Status = null);
                notifMB = validarSiEnviarCorreo(cs, csOldSt);


                for (NotificacionPorMasterBase__c notMB : notifMB){
                    emailCaso = (String.isNotBlank(cs.Correo_electr_nico__c) ? cs.Correo_electr_nico__c : mapNew.get(cs.Id).Correo_electr_nico__c);
                    cs.Nombres__c = cs.Account.Name;

                    if (String.isNotBlank(emailCaso)){
                        List<String> emailTo = new List<String>{emailCaso};
                        
                        BodyMail.GeneralData = crearDeliberyMail(emailTo, notMB);
                        BodyMail.GeneralData.Message = crearMessageMail(cs,notMB, mapUsuario);
                        BodyMail.GeneralData.Options = crearOptionsMail();
                        
                        String json = System.JSON.serialize(BodyMail);
                        json = json.replace('"FromMail":','"From":'); 

                        
                        if(mapNew != null && mapNew.containsKey(cs.Id)){
                            mapNew.get(cs.Id).Flag_envio_mail__c = true;
                        }
                        if(notMB.SLA__c > 0){
                            Datetime dt = cs.LastModifiedDate;
                            dt = dt.addMinutes(Integer.valueOf(notMB.SLA__c));
                            crearEventos(dt,json);
                        }else{
                            envioCorreo_A_MasterBase(json);
                        }
                    }
                }
            }
        }
        if(lstEventos.size()>0){ programarEnvios(); }
        if(newMBLogger.size()>0){ Upsert newMBLogger Key__c; }    }

    @TestVisible
	private static String getToken(){
        if(Test.isRunningTest()){ loadConfig();}
        
		Blob headerValue = Blob.valueOf(sc.username__c + ':' + sc.password__c);
		String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        return authorizationHeader;
    }

    // está público, porque se ejecutará inmediatamente y también se encolará
    // **********************************************************************
    @Future(callout=true)
    public static void envioCorreo_A_MasterBase(string jSonRequest){
		loadConfig();
        String token = '';
        if(String.isBlank(sc.x_api_key__c)){ // cambio por límite de token. Se quita temporalmente 13102020
            token = Test.isRunningTest() ? 'tokenTest' : getToken();
        }
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointMasterBase+sc.Modalidad__c);
		request.setMethod('POST');
        request.setHeader('Authorization', token);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jSonRequest);

        HTTP http = new HTTP();
        HttpResponse response = new HttpResponse();
        String mensjExp = '';
        
        try {
            response = http.send(request);
        } catch(Exception e) { 
            mensjExp = e.getMessage(); 
        }

        boolean respuesta = (response.getStatus() == 'OK' && response.getStatusCode() == 200);
    }   
    
    private static List<NotificacionPorMasterBase__c> validarSiEnviarCorreo(Case cs, Case csOldSt){
		List<NotificacionPorMasterBase__c> listaNotif = new List<NotificacionPorMasterBase__c>();
        String statusOld = null;
        String llaveFormula = cs.type + cs.Subtipo__c + statusOld + cs.Status + cs.Sub_estado_Nectia__c + cs.Caso_PF_Cliente_apto__c;

        Boolean flag = false;
        String loggerKey = '';
        for(String key : mapNotiMB.keySet()){ // Toco hacer esto por las llaves extrañas
            if(key == llaveFormula){
                loggerKey = cs.Id+'-'+key;
                if(mapLogger.containsKey(loggerKey)){
                    if(mapLogger.get(loggerKey).Status__c == 'Pendiente'){ flag = true; }
                }else{
                    flag = true;
                }

                if(flag){ 
                    listaNotif =  mapNotiMB.get(key);
                    Master_Base_Logger__c mbl = new Master_Base_Logger__c();
                    mbl.Status__c = 'Enviado';
                    mbl.Related_Case__c = cs.Id;
                    mbl.Key__c = loggerKey;
                    newMBLogger.add(mbl); 
                    mapLogger.put(loggerKey, mbl);
                }
            }
            
            flag = false;                
        }
        if(cs.Caso_PF_Primer_propietario_Formula__c != null){
            if(cs.Caso_PF_Primer_propietario_Formula__c != csOldSt.Caso_PF_Primer_propietario_Formula__c ){
                listaNotif.add(mapNotiMB.get('CambioPrimerPropietario')[0]);
            }
        }
        return listaNotif;
	}
	
	private static void cargarMapaNotificaciones(){
		if(mapNotiMB == null){
			mapNotiMB = new Map<String,List<NotificacionPorMasterBase__c>>();
		
			for(NotificacionPorMasterBase__c row : [SELECT Nombre__c, FromId__c, Adjunto__c, Asunto__c, Cliente_Apto__c, Estado_Previo__c, Estado__c, ID_Notificacion__c, Name,Plantilla__c,
											SLA__c, SubTipo__c, Sub_Estado__c, Tipo__c, Nombre_Adjunto__c, Campos_Plantilla__c, FromMail__c, FromName__c
											FROM NotificacionPorMasterBase__c WHERE Nombre__c != null]){
                                                if(mapNotiMB.containsKey(row.Nombre__c) ){
                                                    mapNotiMB.get(row.Nombre__c).add(row);   
                                                }else{
                                                    mapNotiMB.put(row.Nombre__c, new List<NotificacionPorMasterBase__c>{row});
                                                }
			}
		}
	}
    
    private static PF_EnvioMail_MB_JSON.GeneralData crearDeliberyMail(List<String> emailTo, NotificacionPorMasterBase__c notifMB){
        
        PF_EnvioMail_MB_JSON.To emlTo = new PF_EnvioMail_MB_JSON.To();
        emlTo.Email = emailTo;
        
        PF_EnvioMail_MB_JSON.GeneralData generalData = new PF_EnvioMail_MB_JSON.GeneralData();
        generalData.To = emlTo;
        generalData.FromName = notifMB.FromName__c;
		generalData.FromMail = notifMB.FromMail__c;

        return generalData;
    }
    private static PF_EnvioMail_MB_JSON.Options crearOptionsMail(){

        PF_EnvioMail_MB_JSON.Options options = new PF_EnvioMail_MB_JSON.Options();
        options.OpenTracking = true;
        options.ClickTracking = true;
        options.TextHtmlTracking = true;
        options.AutoTextBody = false;
        options.Personalization = true;
        return options;

    }    
    private static List<PF_EnvioMail_MB_JSON.Attachment> crearAttachmentMail(NotificacionPorMasterBase__c notifMB){

        PF_EnvioMail_MB_JSON.Attachment attach = new PF_EnvioMail_MB_JSON.Attachment();
        List<PF_EnvioMail_MB_JSON.Attachment> attachment = new List<PF_EnvioMail_MB_JSON.Attachment>();

        if (notifMB.Adjunto__c == 'si'){

            docMail = [SELECT Id, name, body, BodyLength, ContentType
                       FROM StaticResource 
                       WHERE Name =: notifMB.Nombre_Adjunto__c LIMIT 1];
            
            nombreDocAdj = notifMB.Nombre_Adjunto__c +'.' + docMail.ContentType.split('/')[1];
            
            attach = new PF_EnvioMail_MB_JSON.Attachment();
            attach.FileName = nombreDocAdj;
            attach.Encode = 'Base64';
            attach.Size = '' + docMail.BodyLength;
            attach.Value =  EncodingUtil.base64Encode(docMail.Body);

            attachment.add(attach);

        }

        return attachment;
    }

    private static PF_EnvioMail_MB_JSON.Message crearMessageMail(Case cs, NotificacionPorMasterBase__c notifMB, Map<Id, User> mapUsuario){
        boolean variable = true;
        boolean adjunto = true;
        
        PF_EnvioMail_MB_JSON.Body body = new PF_EnvioMail_MB_JSON.Body();
		PF_EnvioMail_MB_JSON.BasedOn basedOn = new PF_EnvioMail_MB_JSON.BasedOn();
		PF_EnvioMail_MB_JSON.Message message = new PF_EnvioMail_MB_JSON.Message();

		basedOn.Id = Integer.valueOf(notifMB.ID_Notificacion__c);
		basedOn.Type = 'Template';

        body.Format = 'html';
		body.Value = 'obligatorio';

        message.Subject = notifMB.Asunto__c;
		message.Classification ='C';
		message.BasedOn = BasedOn;
        message.Attachment = crearAttachmentMail(notifMB);

        List<PF_EnvioMail_MB_JSON.Variables> variables = new List<PF_EnvioMail_MB_JSON.Variables>();

		// variables que se pasan, para colocar en la plantilla
		// ****************************************************
		List<String> nombreCampo = notifMB.Campos_Plantilla__c.split(';');
        List<String> val;
        List<String> rel;

        if (nombreCampo!=null){
            for(String valores2 : nombreCampo){
                PF_EnvioMail_MB_JSON.Variables variab = new PF_EnvioMail_MB_JSON.Variables();
                val = valores2.split(',');
                variab.Name = val.get(0).trim();
                if(val.get(1).contains('.')){
                   
                    variab.Value = '' + buscarValorRelacionado(val.get(1).trim(), mapUsuario, cs.Caso_PF_Primer_propietario_Formula__c);
                }else{
                	variab.Value = '' + cs.get(val.get(1));
                }
                variables.add(variab);
            }
            if (variables.Size() > 0){
                body.Variables = Variables;
            }
        }

        message.Body = body;

        return message;
    }
    
    private static String buscarValorRelacionado(String valor, Map<Id, User> mapUsuario, Id usuario){
        String respuesta;
        List<String> rel = valor.split('\\.');
        if (rel[1] == 'name') { respuesta = String.isBlank(mapUsuario.get(usuario).name) ? '' :mapUsuario.get(usuario).name ;}
        if (rel[1] == 'email'){ respuesta = String.isBlank(mapUsuario.get(usuario).email) ? '' :mapUsuario.get(usuario).email ;}
        if (rel[1] == 'phone'){ respuesta = String.isBlank(mapUsuario.get(usuario).phone) ? '' :mapUsuario.get(usuario).phone ;}

        return respuesta;
    }
   
}