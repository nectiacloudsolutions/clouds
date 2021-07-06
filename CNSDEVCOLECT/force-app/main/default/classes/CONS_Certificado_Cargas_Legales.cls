public class CONS_Certificado_Cargas_Legales {
    
    
    public Transient String aux { get; set; }
    public Transient String extAux { get; set; }
    public  String error { get; set; }
    public  boolean errorpagina { get; set; }
    public  boolean continuarsinenviar { get; set; }
    
    public string nombre {get;set;}  
    public string id {get;set;}
    public string body {get;set;}
    public string respuestaerror {get;set;}
    public string resp {get;set;}
    public string email {get;set;}
    public string Conresser {get;set;}
    public list<Attachment> documentos = new list<Attachment>();
    //respuesta servicio = resser
    public Transient  CONS_RespuestaCertificadocargasl_JSON resser;
    public  Producto_del_Cliente__c pro{get;set;}
    public  Profile prof{get;set;} 
    public  case cas {get;set;}
    public integer contadorcaso {get;set;}
    public User tmpUser{get;set;}
    
    public CONS_Certificado_Cargas_Legales(ApexPages.StandardController controller) {
        system.debug('controller'+controller);
        string idusuario=userinfo.getUserId();
        user us =[SELECT Id, Username, LastName, FirstName, Name, ProfileId FROM User WHERE Id = :idusuario];
        system.debug('us'+us);
        prof=[SELECT Id, Name FROM Profile WHERE Id = :us.ProfileId];
        system.debug('prof'+prof);
        // Producto_del_Cliente__c rt = (Producto_del_Cliente__c) controller.getRecord(); 
        system.debug(Apexpages.currentPage().getUrl());
        id = ApexPages.currentPage().getParameters().get('id');
        system.debug(id);
        pro = [SELECT Id, Poliza_Nectia__c,Cliente_Nectia__r.PersonEmail,Rut_del_Cliente__c,Cliente_Nectia__c,Tipo_Registro_Nectia__c,Esquema_Nectia__c,Cliente_Nectia__r.name,
               Cliente_Nectia__r.NuevoCorreo__c,Cliente_Nectia__r.CambioMail__c,L_nea__c,Cliente_Nectia__r.PersonContactId
               FROM Producto_del_Cliente__c where  id=:id limit 1];
       system.debug('pro.Esquema_Nectia__c'+pro.Esquema_Nectia__c);
        system.debug('pro.L_nea__c'+pro.L_nea__c);
        if(pro.Cliente_Nectia__r.CambioMail__c==true){
            email = pro.Cliente_Nectia__r.NuevoCorreo__c;
        }else{
            email = pro.Cliente_Nectia__r.PersonEmail;
        }
        errorpagina = true;
        contadorcaso=0;
        
    }
    public PageReference siguiente(){
        system.debug('prof.id'+prof.id);
        continuarsinenviar=true;
        errorpagina = true;
        return verdocumento();   
    }
    public PageReference verdocumento(){
        
        string estructura='{'+
            '"poliza": "'+pro.Poliza_Nectia__c+'",'+
            '"codigoCompania": "'+pro.Tipo_Registro_Nectia__c+'",'+
            '"rut": "'+pro.Rut_del_Cliente__c+'"'+
            '}';

		tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId() limit 1];

        Cons_callOutService  call= new Cons_callOutService();
        // string token=call.callOuttoken();
        // system.debug('token'+token);
        // CONS_token_JSON tok = (CONS_token_JSON)JSON.deserialize(token,CONS_token_JSON.class);  
        // system.debug('token=='+tok.access_token);
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);
        string resp ='';
        system.debug('pro.Esquema_Nectia__c'+pro.Esquema_Nectia__c);
        system.debug('pro.L_nea__c'+pro.L_nea__c);
        if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){

            //resp = call.callOutCertificado_cargas_legales_RV(access_token, estructura);
            resp = call.callOutCertificado_cargas_legales_RV(access_token, estructura,tmpUser);

        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'no es posible consultar por este documento solo se puede consultar por los Rentas Vitalicias');
            ApexPages.addMessage(myMsg);
            errorpagina = false; 
            return null;
        }
        system.debug('resp=='+resp);
        if(!Test.isRunningTest()){
            resser = (CONS_RespuestaCertificadocargasl_JSON)JSON.deserialize(resp,CONS_RespuestaCertificadocargasl_JSON.class);  
        }else{
            String datosTest = '{"codigoError": '+Conresser+',"mensajeError": "abc123", "certificado":{"archivo": "1234567","nombreArchivo": "abc123"}}';
            resser = CONS_RespuestaCertificadocargasl_JSON.parse(datosTest);
        }
        system.debug('pro.L_nea__c'+pro.L_nea__c);
        system.debug('resser=='+resser);
        if(resser.codigoError =='0'){
            errorpagina = true; 
            aux = resser.certificado.archivo;
            extAux = 'applicacion/pdf';
            documentos=new list<Attachment>(); 
            Attachment at=new Attachment();
            at.ContentType='application/pdf';
            at.Name = resser.certificado.nombreArchivo;
            blob body1=  EncodingUtil.base64Decode(aux);
            at.Body =body1;
            documentos.add(at);
            
            if(contadorcaso==0){

				// tipo de registro para caso cerrado por emisión correcta
				String TipoDeRegistro;
				String CaseRecordTypeId;
				String linea;
				String tipo = 'Solicitud';
                system.debug('pro.L_nea__c '+pro.L_nea__c );
				if (pro.L_nea__c == 'Rentas Vitalicias'){
					linea = 'Renta';
				}else{
					linea = pro.L_nea__c;
				}
				TipoDeRegistro = 'Seguros - ' + tipo + ' - ' + linea;
				System.debug('tipo->'+TipoDeRegistro);

				Schema.DescribeSObjectResult caseDesribe = Schema.SObjectType.Case;
				Map<String,Schema.RecordTypeInfo> rtMapByName = caseDesribe.getRecordTypeInfosByName();
				Schema.RecordTypeInfo rtByName =  rtMapByName.get(TipoDeRegistro);
				CaseRecordTypeId = rtByName.getRecordTypeId();
				System.debug('Id Tipo de registro->'+CaseRecordTypeId); 
				
				System.debug('tipo de registro->'+CaseRecordTypeId);

                cas = new case();
                //cas.RecordTypeId = [SELECT Id, DeveloperName, SobjectType, IsActive, Description FROM RecordType  where  DeveloperName ='Casos_Seguros'].id;
                cas.RecordTypeId = CaseRecordTypeId;
                cas.Type = 'Solicitud';
                cas.Subtipo__c = 'Emisión Documentos';
                cas.Status='Cerrado';
                cas.Tipo_de_documento__c = 'Certificado de Cargas Legales';
                cas.Subject = 'Certificado de Cargas Legales generado exitosamente ';
                cas.AccountId = pro.Cliente_Nectia__c;
                cas.ContactId = pro.Cliente_Nectia__r.PersonContactId;
                cas.Producto_del_Cliente_Nectia__c = id;
                cas.Rut_del_Cliente__c = pro.Rut_del_Cliente__c;
                insert cas;
                contadorcaso++;
            }
            
            // 
        }else{
            cas = new case();
            cas.RecordTypeId = [SELECT Id, DeveloperName, SobjectType, IsActive, Description FROM RecordType  where  DeveloperName ='Casos_Seguros'].id;
            cas.Type = 'Solicitud';
            cas.Subtipo__c = 'Emisión Documentos';
            cas.Status = 'Nuevo';
            cas.Tipo_de_documento__c = 'Certificado de Cargas Legales';
            cas.Subject = 'Certificado de Cargas Legales no generado ';
            cas.Description = 'No se ha encontrado Certificado de Cargas Legales asociado  este cliente.';
            cas.AccountId = pro.Cliente_Nectia__c;
            cas.ContactId = pro.Cliente_Nectia__r.PersonContactId;
            cas.Producto_del_Cliente_Nectia__c = id;
            cas.Rut_del_Cliente__c = pro.Rut_del_Cliente__c;
            insert cas;
            // cas.OwnerId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Cola_Resoluci_n_Endosos_Simples_Grales' ].Id;
            
            continuarsinenviar=false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No se pudo encontrar el documento se generara un caso presione continuar para verificar el caso');
            ApexPages.addMessage(myMsg);
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: '+ resser.mensajeError);
            ApexPages.addMessage(myMsg1);
            errorpagina = false; 
        }
        return null;
    }
    public PageReference volver(){
        
        //cas.Status = 'Cerrado';
        cas.Sub_estado_Nectia__c='Solucionado';
        cas.Description = 'Documento descargado por usuario.';     
        update cas;
        
        PageReference pageRef = new PageReference('/'+id);
        return pageRef;
    }
    public PageReference enviar(){
        if(email!=null){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses;
            OrgWideEmailAddress owa=[select id, Address from OrgWideEmailAddress where Address='consorcio.informa@consorcio.cl' limit 1 ];
            mail.setOrgWideEmailAddressId(owa.id);
			EmailTemplate plantilla;
			
            if(!test.isRunningTest()){
            	plantilla = [SELECT Id,Subject, Body FROM EmailTemplate WHERE DeveloperName = 'TestCargasLegales'];    
                mail.setTemplateId(plantilla.Id);
            }						
          
            
           // mail.setSubject('Certificado de Cargas Legales');
            toAddresses = new String[] {email};
                mail.setToAddresses(toAddresses);
            mail.setBccSender(false); 
            mail.setUseSignature(false); 
          // mail.setSenderDisplayName('Servicio al cliente Consorcio');
            mail.setTargetObjectId(cas.ContactId);
            mail.setWhatId(cas.id);
            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType(documentos.get(0).ContentType);
            attach.setFileName(documentos.get(0).name);
            attach.setInline(false);
            attach.Body =documentos.get(0).Body;
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
            
            
            
            //String messageBody;
            //messageBody ='<html xmlns="http://www.w3.org/1999/xhtml"><head> <!--[if IE]> <style>a{text-decoration:none!important;color:#004292!important;border:none!important;outline:none!important}</style> <![endif]--> <style type="text/css">.ExternalClass,.ExternalClass p,.ExternalClass span,.ExternalClass font,.ExternalClass td,.ExternalClass div{line-height:100%}html,body{margin:0 auto!important;padding:0!important;width:100%!important;min-width:100%!important}.preheader{display:none!important;visibility:hidden;opacity:0;color:transparent;height:0;width:0}*{-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%}div[style*="margin: 16px 0"]{margin:0!important}table,td{mso-table-lspace:0!important;mso-table-rspace:0!important;table{border-collapse:collapse}}table{border-spacing:0!important;border-collapse:collapse!important;margin:0 auto!important;mso-table-lspace:0!important;mso-table-rspace:0!important}table table table{table-layout:auto}img{-ms-interpolation-mode:bicubic}*[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important}.x-gmail-data-detectors,.x-gmail-data-detectors *,.aBn{border-bottom:0!important;cursor:default!important}.a6S{display:none!important;opacity:.01!important}a{text-decoration:none!important;color:#004292!important;border:none!important;outline:none!important}.email-container{margin:auto!important;width:100%!important;max-width:600px!important}.fluid{margin:0 auto!important}.fluid-margen{margin:0 auto!important}.tabla-rrss{width:100%!important;max-width:130px!important;margin:0 auto!important}.fluid-info{width:100%!important;max-width:500px!important}th{font-weight:normal!important}@media only screen and (min-device-width:375px) and (max-device-width:413px){.email-container{min-width:375px!important}}</style> <style type="text/css">@media screen and (max-width:480px){.email-container{width:100%!important;border:none!important}.fluid{width:100%!important;max-width:100%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}.fluid-info{width:100%!important;max-width:100%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}.fluid-margen{width:90%!important;max-width:90%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}.fluid350{width:80%!important;max-width:80%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}.fluid450{width:90%!important;max-width:90%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}.fluid350-2{width:90%!important;max-width:90%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}.fluid300{width:80%!important;max-width:80%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}.fluid-logo{width:70%!important;max-width:70%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}.fluid-banner{width:100%!important;max-width:100%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}.fluid-btn{width:60%!important;max-width:60%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}.fluid-logo-footer{width:60%!important;max-width:60%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}.fluid-legales{width:90%!important;max-width:90%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}.fluid-txt{width:95%!important;max-width:95%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}.img-icon{width:84px!important;height:84px!important}.tabla-rrss{width:160px!important;max-width:160px!important;margin:0 auto!important}.force-col{display:block!important;width:100%!important;max-width:100%!important;float:left!important}.col-2{float:none!important;width:100%!important;margin-bottom:0!important;padding-bottom:0!important}.ocultar{display:none!important}.ocultar-d{display:block!important}img.rrss-icono{width:40px!important;height:40px!important}.txt-ver{font-size:13px!important}.titulo{font-size:30px!important}.sub-titulo{font-size:25px!important}.bajada{font-size:20px!important}.txt-cuerpo{font-size:16px!important}.txt-14{font-size:14px!important}.txt-16{font-size:16px!important}.txt-18{font-size:18px!important}.txt-20{font-size:20px!important}.txt-22{font-size:22px!important}.txt-24{font-size:24px!important}.txt-26{font-size:26px!important}.txt-msj{font-size:20px!important}.txt-a{font-size:16px!important}.txt-legal{font-size:13px!important}.txt-legal-fijo{font-size:12px!important}.txt-b{padding:0 24px!important}.txt-c{padding:15px 30px!important}.text-right{text-align:right!important}.text-left{text-align:left!important}.text-center{text-align:center!important}.text-justify{text-align:justify!important}.mostrar-ib{display:inline-block!important}.mostrar-i{display:inline!important}.mostrar-it{display:inline-table!important}.mostrar-tc{display:table-cell!important}.down-arrow{width:10%!important;max-width:10%!important;height:auto!important;margin-left:auto!important;margin-right:auto!important}span.txtMobile{display:block!important}.txtMobile{font-size:12px}.tablaMobile{width:100%!important}.colCrece{width:35%!important}}</style></head><body bgcolor="#ffffff" leftmargin="0" marginheight="0" marginwidth="0" topmargin="0"><!--[if gte mso 9]> <table align="center" border="0" cellspacing="0" cellpadding="0" width="600" style="width:600px"> <tr> <td align="center" valign="top" width="600" style="width:600px"> <![endif]--><table align="center" border="0" style="max-width:600px" width="100%"> <tbody> <tr> <td style="display:none!important;visibility:hidden;mso-hide:all;font-size:1px;color:#fff;line-height:1px;max-height:0;max-width:0;opacity:0;overflow:hidden">Conoce nuestro Newsletter</td> </tr> <tr> <td height="5">&nbsp;</td> </tr> <tr> <td class="txt-ver" style="font-family:Arial,Helvetica,sans-serif;font-size:11px;color:#454545;text-align:center">Si no visualizas bien este e-mail, haz <a href="#!vistamail3!#" style="color:#002b5f" target="_blank">click aqu&iacute;</a></td> </tr> <tr> <td height="5">&nbsp;</td> </tr> </tbody></table><table class="email-container" style="margin:0 auto;padding:0;max-width:600px;border:1px solid #d5d5d5" width="600"> <tbody> <tr> <td> <table align="center" border="0" cellpadding="0" cellspacing="0" class="fluid" style="border-bottom:3px solid #de2e21" width="600"> <tbody> <tr> <td height="25">&nbsp;</td> </tr> <tr> <td align="center" width="100%"><img alt="Consorcio" border="0" class="fluid-logo" height="55" src="https://bancoconsorcio--developcns--c.cs17.content.force.com/servlet/servlet.ImageServer?id=015g0000000w1f1&oid=00Dg0000006IIG0&lastMod=1553631070000" style="display:block" width="250" /></td> </tr> <tr> <td height="15">&nbsp;</td> </tr> </tbody> </table> <table align="center" border="0" cellpadding="0" cellspacing="0" class="fluid-margen" width="540"> <tbody> <tr> <td height="18">&nbsp;</td> </tr> <tr> <td align="center" class="titulo" style="font-family:Arial,Helvetica,sans-serif;font-size:32px;text-align:center;color:#004292;font-weight:bold;line-height:1.2"><br class="ocultar-d" style="display:none">'+cas.type+' <br> de '+cas.Tipo_de_documento__c+'</td> </tr> <tr> <td height="24">&nbsp;</td> </tr> <tr> <td class="txt-a" style="font-family:Arial,Helvetica,sans-serif;font-size:15px;text-align:left;color:#454545;font-weight:bold">Estimado '+pro.Cliente_Nectia__r.name+'</td> </tr> <tr> <td height="24">&nbsp;</td> </tr> <tr> <td class="txt-a" style="font-family:Arial,Helvetica,sans-serif;font-size:13px;color:#454545;text-align:center;line-height:normal">Junto con saludar, enviamos el '+cas.Tipo_de_documento__c+' con el n&ordm; de p&oacute;liza '+pro.Poliza_Nectia__c+' </td> </tr> <tr> <td height="14">&nbsp;</td> </tr> <tr> <td align="center" class="txt-a" style="font-family:Arial,Helvetica,sans-serif;font-size:13px;font-weight:bold;color:#454545;text-align:center;line-height:normal">Saluda Coordialmente <br>Consorcio Seguros.</td> </tr> <tr> <td height="24">&nbsp;</td> </tr> </tbody> </table> <table align="center" border="0" cellpadding="0" cellspacing="0" class="fluid-margen" style="border-bottom:1px solid #cecece" width="500"> <tbody> <tr> <td height="50">&nbsp;</td> </tr> <tr> <td align="center" width="100%"><img alt="Consorcio" border="0" class="fluid-logo-footer" height="34" src="https://bancoconsorcio--developcns--c.cs17.content.force.com/servlet/servlet.ImageServer?id=015g0000000w1nt&oid=00Dg0000006IIG0&lastMod=1553696253000" style="display:block" width="155" /></td> </tr> <tr> <td height="20">&nbsp;</td> </tr> </tbody> </table> <table align="center" bgcolor="#ffffff" border="0" cellpadding="0" cellspacing="0" class="fluid-info" width="520"> <tbody> <tr> <th colspan="3" height="6" width="100%">&nbsp;</th> </tr> <tr> <th align="center" class="force-col" style="display:inline-block;vertical-align:top" width="334"> <table align="center" border="0" cellpadding="0" cellspacing="0" class="col-2" width="334"> <tbody> <tr> <td align="center" height="35" width="166"><a href="tel:6002213000"><img alt="Contact Center" border="0" class="tel" height="35" src="https://bancoconsorcio--developcns--c.cs17.content.force.com/servlet/servlet.ImageServer?id=015g0000000w1oh&oid=00Dg0000006IIG0&lastMod=1553716789000" width="138" /></a></td> <td align="center" width="1"><img class="linea" height="38" src="https://bancoconsorcio--developcns--c.cs17.content.force.com/servlet/servlet.ImageServer?id=015g0000000w1ow&oid=00Dg0000006IIG0&lastMod=1553717304000" width="1px" /></td> <td align="center" height="38" width="166"><a href="https://www.consorcio.cl/seguros"><img alt="Chat en l&iacute;nea" border="0" class="redes" height="35" src="https://bancoconsorcio--developcns--c.cs17.content.force.com/servlet/servlet.ImageServer?id=015g0000000w1om&oid=00Dg0000006IIG0&lastMod=1553716825000" width="138" /></a></td> <td align="center" class="ocultar" width="1"><img class="linea" height="38" src="https://bancoconsorcio--developcns--c.cs17.content.force.com/servlet/servlet.ImageServer?id=015g0000000w1ow&oid=00Dg0000006IIG0&lastMod=1553717304000" width="1px" /></td> </tr> </tbody> </table> </th> <th class="force-col" style="display:inline-block;max-width:165px;vertical-align:top"> <table align="center" border="0" cellpadding="0" cellspacing="0" class="col-2" width="165"> <tbody> <tr> <td align="center" height="38" width="166"><a href="https://www.tuconsorcio.cl/app"><img alt="APP Consorcio" border="0" class="tel" height="35" src="https://bancoconsorcio--developcns--c.cs17.content.force.com/servlet/servlet.ImageServer?id=015g0000000w1or&oid=00Dg0000006IIG0&lastMod=1553716844000" width="138" /></a></td> </tr> </tbody> </table> </th> </tr> </tbody> </table> <table align="center" bgcolor="#ffffff" border="0" cellpadding="0" cellspacing="0" class="tabla-rrss" width="130"> <tbody> <tr> <td align="center" class="fluid-info" width="100%"> <table align="center" width="100%"> <tbody> <tr> <td width="15" height="25">&nbsp;</td> </tr> <tr> <td><a href="https://www.facebook.com/ConsorcioCL"><img align="Facebook" class="rrss-icono" height="30" src="https://bancoconsorcio--developcns--c.cs17.content.force.com/servlet/servlet.ImageServer?id=015g0000000w1oN&oid=00Dg0000006IIG0&lastMod=1553715354000" style="border:0;outline:0" width="30" /></a></td> <td width="20">&nbsp;</td> <td><a href="https://twitter.com/Consorcio_cl"><img align="Facebook" class="rrss-icono" height="30" src="https://bancoconsorcio--developcns--c.cs17.content.force.com/servlet/servlet.ImageServer?id=015g0000000w1oS&oid=00Dg0000006IIG0&lastMod=1553715385000" style="border:0;outline:0" width="30" /></a></td> <td width="20">&nbsp;</td> <td><a href="https://www.youtube.com/user/consorciocl"><img align="Facebook" class="rrss-icono" height="30" src="https://bancoconsorcio--developcns--c.cs17.content.force.com/servlet/servlet.ImageServer?id=015g0000000w1oX&oid=00Dg0000006IIG0&lastMod=1553715414000" style="border:0;outline:0" width="30" /></a></td> </tr> </tbody> </table> </td> </tr> <tr> <td height="20">&nbsp;</td> </tr> </tbody> </table> <table align="center" bgcolor="#eaeaea" border="0" cellpadding="0" cellspacing="0" class="fluid" width="100%"> <tbody> <tr> <td align="center"> <table border="0" cellpadding="0" cellspacing="0" class="fluid-margen" width="500"> <tbody> <tr> <td colspan="3" height="20">&nbsp;</td> </tr> <tr> <td><img height="46" src="https://bancoconsorcio--developcns--c.cs17.content.force.com/servlet/servlet.ImageServer?id=015g0000000w1oc&oid=00Dg0000006IIG0&lastMod=1553716714000" width="46" /></td> <td width="10">&nbsp;</td> <td> <table border="0" cellpadding="0" cellspacing="0" width="100%"> <tbody> <tr> <td align="justify" class="txt-legal" style="font-family:Arial,Helvetica,sans-serif;font-size:13px;color:#454545;text-align:left;vertical-align:top"><strong>&middot;</strong></td> <td width="5">&nbsp;</td> <td align="justify" class="txt-legal" style="font-family:Arial,Helvetica,sans-serif;font-size:11px;color:#454545;text-align:left;vertical-align:top"><strong>Nunca</strong> abras ni descargues archivos de remitentes desconocidos, ni facilites datos personales.</td> </tr> <tr> <td align="justify" class="txt-legal" style="font-family:Arial,Helvetica,sans-serif;font-size:13px;color:#454545;text-align:left;vertical-align:top"><strong>&middot;</strong></td> <td width="5">&nbsp;</td> <td align="justify" class="txt-legal" style="font-family:Arial,Helvetica,sans-serif;font-size:11px;color:#454545;text-align:left;vertical-align:top"><strong>Nunca</strong> uses la opci&oacute;n &quot;guardar contrase&ntilde;a&quot; en las pantallas iniciales de sitios de internet.</td> </tr> </tbody> </table> </td> </tr> <tr> <td colspan="3" height="20">&nbsp;</td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody></table><table align="center" border="0" cellpadding="0" cellspacing="0" class="fluid-legales" style="max-width:600px" width="100%"> <tbody> <tr> <td height="20">&nbsp;</td> </tr> <tr style="text-align:justify" valign="center"> <td class="txt-legal-fijo" style="font-family:arial;font-size:11px;text-align:justify;color:#7a7a7a">Este correo electr&oacute;nico ha sido enviado a #!email!#.</td> </tr> <tr> <td height="10">&nbsp;</td> </tr> <tr> <td class="txt-legal-fijo" style="font-family:arial;font-size:11px;text-align:justify;color:#7a7a7a">Por favor agradecemos No Contestar a esta casilla. Si requiere efectuar consultas, solicitudes, corregir errores en el env&iacute;o o en sus datos, cont&aacute;ctenos directamente en nuestro sitio www. consorcio. cl. Este correo electr&oacute;nico fue enviado a trav&eacute;s de MasterBase&reg; por Consorcio Financiero S.A. Direcci&oacute;n: El Bosque Sur 180, piso 1 Las Condes &middot; Santiago Chile.</td> </tr> <tr> <td height="10">&nbsp;</td> </tr> <tr> <td class="txt-legal-fijo" style="font-family:arial;font-size:11px;text-align:justify;color:#7a7a7a">Le informamos que si no desea recibir m&aacute;s de este tipo de mensajes, puede anular su suscripci&oacute;n <strong><a href="https://register.masterbase.com/v0/CONSORCIOMKTPRO/#!serial!#/#!contrasena!#/marcarusu?boletin=9&amp;habilitado=1&amp;opcion=1" style="color:#002b5f" target="_blank">aqu&iacute;</a></strong>, en Cumplimiento a la ley del Consumidor N&deg; 19.496 y sus posteriores modificaciones, especialmente lo prescrito por el Art&iacute;culo 28b que regula el env&iacute;o de correos electr&oacute;nicos.</td> </tr> <tr> <td height="20">&nbsp;</td> </tr> </tbody></table><table align="center" border="0" cellpadding="0" cellspacing="0" class="fluid" style="max-width:600px" width="100%"> <tbody> <tr> <td height="10">&nbsp;</td> </tr> </tbody></table><!--[if gte mso 9]> </td> </tr> </table> <![endif]--></body></html>';
                
            //    mail.setHtmlBody(messageBody); 
			if(!Test.isRunningTest()){
			  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			}
          
            //cas.Status = 'Cerrado';
            cas.Sub_estado_Nectia__c='Solucionado';
            cas.Description = 'Documento enviado con éxito a la casilla: '+email;
            update cas;      
            PageReference pageRef = new PageReference('/'+cas.id);
            return pageRef;
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cliente no tiene email válido');//+cas1.CaseNumber);
            ApexPages.addMessage(myMsg); 
            verdocumento();
            return null;
        }
    }
    public PageReference continuar(){
        system.debug('cas'+cas);
        if(cas==null){
            PageReference pageRef = new PageReference('/'+id);
            return pageRef;   
        }else{
            
            PageReference pageRef = new PageReference('/'+cas.id);
            return pageRef;
        }
    }
    public PageReference continuarcaso(){
        //cas.Status = 'Cerrado';
        cas.Sub_estado_Nectia__c='Solucionado';
        cas.Description = 'Documento descargado por usuario.';     
        update cas;
        PageReference pageRef = new PageReference('/'+cas.id);
        return pageRef;
    }

	public void updateUser(){
		system.debug(tmpUser.AccessToken_Nectia__c);
		update tmpUser;
	}

	public PageReference orquestaMetodos(){
		siguiente();
		updateUser();
		return null;
	}
}