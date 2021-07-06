public class CONS_ProcesaCambioDatos{
    
    public String idcaso{get;set;}
    public String urlSF{get;set;}
    public User us {get;set;}
    public String autorizacion {get;set;}
    public PageReference pagina;
    public User tmpUser{get;set;}
    
    public CONS_ProcesaCambioDatos(){
        idcaso = ApexPages.currentPage().getParameters().get('id');
        autorizacion = ApexPages.currentPage().getParameters().get('Naut');
        urlSF = URL.getSalesforceBaseUrl().toExternalForm()+'/';
    }
    
    public PageReference cambiodatos(){
        
        us = [SELECT Id,FederationIdentifier,ProfileId FROM User WHERE Id =: UserInfo.getUserId()];
        system.debug('usuario->'+us.FederationIdentifier);
        system.debug('perfil usuario->'+us.ProfileId);
        
        Profile perfil = [SELECT Id,Name FROM Profile WHERE Id =: us.ProfileId];
        system.debug('nombre perfil->'+perfil.Name);
        
        Case datos_caso = [SELECT Id,CaseNumber, AccountId,Nombre_calle__c,Numero_Nectia__c,Nombre_Villa__c,Numero_piso__c,Numero_de_departamento__c,C_digo_regi_n__c,toLabel(Comuna__c),Correo_electr_nico__c,Tel_fono_de_contacto__c,Otro_telefono__c,Telefono_movil__c,CreatedDate,Cambio_de_Direcci_n__c,Cambio_de_Email__c,Cambio_de_Tel_fono__c FROM Case WHERE Id =: idcaso];
        
        String numeroCaso = datos_caso.CaseNumber;
        system.debug('número de caso->'+numeroCaso);
        
        Account datos_cliente = [SELECT Name,RUT__c,Id,Calle_Nectia__c,Numero_Nectia__c,Villa_Nectia__c,Numero_de_piso_Nectia__c,Numero_departamento_Nectia__c,Region_Nectia__c,toLabel(Comuna_Nectia__c),Phone,PersonOtherPhone,PersonAssistantPhone,PersonEmail,PersonMobilePhone,NuevoCorreo__c,CambioMail__c FROM Account WHERE Id =: datos_caso.AccountId];
        
        String direccion = datos_caso.Nombre_calle__c + ' ' + datos_caso.Numero_Nectia__c + ' ' + (datos_caso.Nombre_Villa__c==null?'':datos_caso.Nombre_Villa__c) + ' ' + (datos_caso.Numero_piso__c==null?'':datos_caso.Numero_piso__c) + ' ' + (datos_caso.Numero_de_departamento__c==null?'':datos_caso.Numero_de_departamento__c);
        
        Integer fonoMovil;
        String fonoMovil2;
        Integer fonoFijo;
        
        fonoMovil2 = (datos_caso.Telefono_movil__c.replaceAll('[^0-9]', ''));
        //fonoMovil = Integer.valueOf(datos_caso.Telefono_movil__c.replaceAll('[^0-9]', ''));
        //fonoFijo = Integer.valueOf(datos_caso.Otro_telefono__c.replaceAll('[^0-9]', ''));
        CONS_DatosContacto_JSON.OFono infoFonoMovil = new CONS_DatosContacto_JSON.OFono();
        infoFonoMovil.sTipotelefono = '2';
        infoFonoMovil.sCodarea = '9';		
        //infoFonoMovil.nNumeroTelefono = datos_cliente.PersonMobilePhone;
        infoFonoMovil.nNumeroTelefono = fonoMovil2;
        //infoFonoMovil.nNumeroTelefono = String.valueOf(fonoMovil);
        infoFonoMovil.sExtension1 = '';
        infoFonoMovil.sExtension2 = '';
        system.debug('oFonoMovil->'+infoFonoMovil);
        
        CONS_DatosContacto_JSON.ODireccion infoDireccion = new CONS_DatosContacto_JSON.ODireccion();
        if (datos_caso.Cambio_de_Direcci_n__c){
            infoDireccion.sCalle = datos_caso.Nombre_calle__c;
            infoDireccion.nNumero = datos_caso.Numero_Nectia__c;
            //(datos_cliente.PersonEmail==''?datos_caso.Correo_electr_nico__c:datos_cliente.PersonEmail);
            infoDireccion.nPiso = (datos_caso.Numero_piso__c==null?'':datos_caso.Numero_piso__c); 
            infoDireccion.sDepartamento = (datos_caso.Numero_de_departamento__c==null?'':datos_caso.Numero_de_departamento__c);
            infoDireccion.sVillapoblacion = (datos_caso.Nombre_Villa__c==null?'':datos_caso.Nombre_Villa__c);
            infoDireccion.sCasilla = '';
            infoDireccion.sCodigopostal = '';
            infoDireccion.sComuna = datos_caso.Comuna__c;
        }
        system.debug('ODireccion->'+infoDireccion);
        
        CONS_DatosContacto_JSON.OCorreo infoCorreo = new CONS_DatosContacto_JSON.OCorreo();
        
        if (datos_caso.Cambio_de_Email__c){
            infoCorreo.sMailPrincipal = datos_caso.Correo_electr_nico__c;
        }else{
            infoCorreo.sMailPrincipal = (datos_cliente.PersonEmail==''?datos_caso.Correo_electr_nico__c:datos_cliente.PersonEmail);
        }
        system.debug('OCorreo->'+infoCorreo);
        system.debug('correo electrónico->'+datos_cliente.PersonEmail==''?datos_caso.Correo_electr_nico__c:datos_cliente.PersonEmail);
        
        system.debug('fonos->'+fonoMovil + ' ' + fonoFijo);
        
        CONS_DatosContacto_JSON.DatosEmail infoEmail = new CONS_DatosContacto_JSON.DatosEmail();
        infoEmail.nCelular = fonoMovil;
        infoEmail.nTelefono = fonoMovil;
        infoEmail.nNumSolicitud = Integer.valueOf(numeroCaso);
        infoEmail.nNegocio = 1;
        infoEmail.sLinNegocio = 'Vida';
        infoEmail.sPlantilla = 'PLA0000038';
        infoEmail.sNombreCliente = datos_cliente.Name;
        if (datos_caso.Cambio_de_Email__c){
            infoEmail.sEmail = datos_caso.Correo_electr_nico__c;
            infoEmail.sEmail2 = datos_caso.Correo_electr_nico__c;
        }else{
            infoEmail.sEmail = (datos_cliente.PersonEmail==''?datos_caso.Correo_electr_nico__c:datos_cliente.PersonEmail);
            infoEmail.sEmail2 = (datos_cliente.PersonEmail==''?datos_caso.Correo_electr_nico__c:datos_cliente.PersonEmail);
        }
        
        DateTime fechaRecepcion = datos_caso.CreatedDate ;
        String sFecha = fechaRecepcion.format('dd-MM-yyyy') ;
        infoEmail.sFechaRecepcion = sFecha;
        
        //infoEmail.sEmail2 = '';
        infoEmail.sDireccion = direccion;
        system.debug('DatosEmail->'+infoEmail);
        
        CONS_DatosContacto_JSON.DatosContacto infoContacto = new CONS_DatosContacto_JSON.DatosContacto(); 
        infoContacto.sRut = datos_cliente.RUT__c;
        infoContacto.sUsuario = us.FederationIdentifier;
        infoContacto.oCorreo = infoCorreo;
        infoContacto.oFono = infoFonoMovil;
        if (datos_caso.Cambio_de_Direcci_n__c){
            infoContacto.oDireccion = infoDireccion;
        }
        infoContacto.nCase_Id = Integer.valueOf(numeroCaso);
        system.debug('DatosContacto->'+infoContacto);
        
        CONS_DatosContacto_JSON nuevoContacto = new CONS_DatosContacto_JSON();
        nuevoContacto.DatosContacto =  infoContacto;
        nuevoContacto.DatosEmail = infoEmail;
        system.debug('Nuevo contacto->'+nuevoContacto);
        
        String jEnvio = JSON.serialize(nuevoContacto);
        system.debug('json->'+jEnvio);
        
        Cons_callOutService  call= new Cons_callOutService();
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);
        string str='';
        
        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId() limit 1];

        String respuesta;
        if(!Test.isRunningTest()){
            respuesta = call.callOutActualiza_Datos_Contacto(access_token,jEnvio,tmpUser);
            system.debug('respuesta del servicio->'+respuesta);
        }else{
            respuesta = '{"codigo": "99","mensaje": "Ocurrió un error al ejecutar el servicio","respuestaBase": {"nCase_Id": "60","estado": {"nCodigo": "0","sMensaje": "OK"}},"respuestaEmailmatico": { "codigo": "0","mensaje": "ok" }}';
        }
        
        Case datos_caso2 = [SELECT Id,Mensaje_Transaci_n__c,transacion_ejecutada__c FROM Case WHERE Id =:datos_caso.Id];
        if (!respuesta.contains('ERROR') ){
            //if (!str.startsWith('ERROR -')){
            
            CONS_respuestaserviciobase_JSON res = (CONS_respuestaserviciobase_JSON)JSON.deserialize(respuesta,CONS_respuestaserviciobase_JSON.class);  
            //CONS_respuestaservicio_JSON res = (CONS_respuestaservicio_JSON)JSON.deserialize(respuesta,CONS_respuestaservicio_JSON.class);  
            system.debug('json res->'+res);
            system.debug('mensage del servicio == '+res.mensaje); 
            system.debug('respuesta base->'+res.RespuestaBase.estado);
            system.debug('codigo error->'+res.codigo);
            
            if(res.codigo=='0'){
                datos_caso2.Mensaje_Transaci_n__c=res.mensaje; 
                datos_caso2.transacion_ejecutada__c=true;
                //insert attach;
            }else{
                if(res.RespuestaBase!=null){
                    system.debug('respuesta base != null'+res.RespuestaBase.estado.sMensaje);
                    datos_caso2.Mensaje_Transaci_n__c=res.RespuestaBase.estado.sMensaje; 
                    datos_caso2.transacion_ejecutada__c=true;
                }else{
                    system.debug('respuesta base == null'+res.RespuestaBase.estado.sMensaje);
                    system.debug('mensaje->'+res.mensaje);
                    datos_caso2.Mensaje_Transaci_n__c=res.mensaje; 
                    datos_caso2.transacion_ejecutada__c=false;
                }
                
                if(res.respuestaEmailmatico!=null){
                    datos_caso2.Mensaje_Transaci_n__c=datos_caso2.Mensaje_Transaci_n__c+ '/n '+res.respuestaEmailmatico.mensaje; 
                }
            }
        }else{
            datos_caso2.Mensaje_Transaci_n__c=respuesta;
            datos_caso2.transacion_ejecutada__c=false;
        }
        
        datos_caso2.Status = 'Cerrado';
        //datos_caso2.Sub_estado_Nectia__c = 'Solucionado';
        update datos_caso2;
        
        
        
        Account datos_cliente2 = [SELECT Id,NuevoCorreo__c,CambioMail__c FROM Account WHERE Id =: datos_caso.AccountId];
        if (datos_caso2.transacion_ejecutada__c && datos_caso.Cambio_de_Email__c){
            datos_cliente2.NuevoCorreo__c = datos_caso.Correo_electr_nico__c;
            datos_cliente2.CambioMail__c = true;
            update datos_cliente2;
        }
        
        String url = '/'+datos_caso2.Id;
        PageReference pr = new PageReference(url);
        pr.setRedirect(true);
        return pr;
    }
    
    public  PageReference continuar(){
        system.debug('entro a continuar'); 
        PageReference p = new PageReference('/'+idcaso);
        p.setRedirect(true);
        return p;
    }

	public void updateUser(){
		system.debug(tmpUser.AccessToken_Nectia__c);
		update tmpUser;
	}

	public PageReference orquestaMetodos(){
		cambiodatos();
		updateUser();
		return null;
	}
    
}