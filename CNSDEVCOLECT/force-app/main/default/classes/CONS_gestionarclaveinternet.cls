public class CONS_gestionarclaveinternet {
    public integer  folio {get;set;}
    public string  id {get;set;}
    public string  tipo {get;set;}
    public string  opcion {get;set;}
    public boolean  paso1 {get;set;}
    public boolean  paso2 {get;set;}
    public boolean  paso3 {get;set;}
    public boolean  paso4 {get;set;}
    public string  Naut {get;set;}
    public string  Rech {get;set;}
    public string  registro {get;set;}
    public string  menser {get;set;}
    public User  us {get;set;}
    public Account  ac {get;set;}
    public Profile  pro {get;set;}
    public String origen;
    public string  email {get;set;}
    public PerfilesSeguridad__mdt PerfilesMeta {get;set;}
    public User tmpUser{get;set;}

    
    public case  cas {get;set;}
    
    
    public CONS_gestionarclaveinternet(ApexPages.StandardController controller) {
        id = ApexPages.currentPage().getParameters().get('id');
        tipo = ApexPages.currentPage().getParameters().get('tipo');
        Naut = ApexPages.currentPage().getParameters().get('Naut');
        Rech = ApexPages.currentPage().getParameters().get('T');
        string user=UserInfo.getUserId();
        us=[SELECT Id, AccountId, UserRole.name, Username, LastName, FirstName, Name, ProfileId,RUT__c  FROM User where id=:user limit 1];
        system.debug('us'+us);
        ac=[SELECT Id, name,PersonEmail,RUT__c,FirstName ,LastName,CambioMail__c,NuevoCorreo__c FROM Account where id=:id limit 1];
        system.debug('ac'+ac);
        pro=[SELECT Id, Name FROM Profile WHERE Id = :us.ProfileId];
        
        PerfilesMeta = [SELECT id,Actualiza_Datos__c,Crea_Clave__c,
                                           Id_Perfil__c,Nombre_Perfil__c,
                                           Pide_huella__c FROM PerfilesSeguridad__mdt 
                                              WHERE Id_Perfil__c =: pro.id];
        //id='0014F00000FmciK';
        paso4=false;
          if(ac.CambioMail__c==true){
            email = ac.NuevoCorreo__c;
        }else{
            email = ac.PersonEmail;
        }
        system.debug('tipo'+tipo);
        system.debug('id'+id);
        system.debug('Naut'+Naut);
    }    
    
    public PageReference tipodeseguro(){
        if(tipo==null){
            paso1=true;
            paso2=false;
            paso3=false;
        }else if(tipo=='Desbloquear'){
            paso1=false;
            paso2=true;
            paso3=false;
            return   desbloquear(); 
        }else if(tipo=='Nueva_clave'){
           /* if(Rech=='RHA'){
                return rechazaclave();
            }else{*/
            	origen = 'Presencial';
                return verificaemail(); 
            //}
            
            
        }
        
        
        return null;
    }
    public PageReference siguiente(){
        system.debug('opcion'+opcion);
        if(opcion=='Desbloquear'){
            paso1=false;
            paso2=false;
            return   desbloquear(); 
            
        }else  if(opcion=='Nueva Clave'){
            
            string iduser=userinfo.getUserId();
            system.debug('iduser'+iduser);
            
            
            system.debug('pro'+pro);
            
           // if( pro.name=='Ejecutivos de Atención al Cliente Seguros Presencial' || pro.name=='Jefe de Atención al Cliente Seguros Presencial' || pro.name=='Jefe de Atención al Cliente Seguros Comercial' || pro.name=='Ejecutivos de Atención al Cliente Seguros Comercial' || pro.name=='Administrador del sistema'  ){
            if(PerfilesMeta.Pide_huella__c == true && PerfilesMeta.Crea_Clave__c == true){                
                PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+id+'&tipo=Nueva_Clave&obj=p');
                return pageRef;  
            }else //if( pro.name=='Ejecutivos de Atención al Cliente Seguros Remoto' || pro.name=='Jefe de Atención al Cliente Seguros Remoto' || pro.name=='Usuario Seguros Administrador' ){
                if(PerfilesMeta.Pide_huella__c== false && PerfilesMeta.Crea_Clave__c == true){
				origen = 'Teléfono';
                paso1=false;
                paso2=false;
                paso3=false;  
                paso4=true;
                
                //   return  verificaemail();
                
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'su perfil no corresponde con los  perfiles registrados para esta operacion');//+cas1.CaseNumber);
                ApexPages.addMessage(myMsg); 
                paso1=false;
                paso2=false; 
                paso3=false;
            }
            
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'debe selecionar un tipo de operacion');//+cas1.CaseNumber);
            ApexPages.addMessage(myMsg); 
            paso1=true;
            paso2=false;
        }
        
        return null;
    }
    public PageReference verificaemail(){
        if(email!=null  && Rech!='RHA'){
            string []rut= ac.RUT__c.split('-');
            
            string estructura ='{'+
                '"rut": "'+rut[0]+'",'+
                '"emailCliente": "'+email+'",'+
                '"nombres": "'+ac.FirstName+'",'+
                '"apellidoPaterno": "'+ac.LastName+'",'+
                '"apellidoMaterno": " "'+
                '}';
            
            system.debug('json->'+estructura);
            
            
            CONS_estructuratoken est=new  CONS_estructuratoken();
            string access_token=est.token();
            system.debug('token=='+access_token);
            Cons_callOutService  call=new Cons_callOutService();

            tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];

            string resp=call.callOutSolisitud_clave_email(access_token,estructura,tmpUser);
            
            system.debug('respuesta->'+resp);
            if(!resp.contains('ERROR -')){
                system.debug('llamado a servicio');
                paso1=false;
                paso2=false;  
                paso3=true;
                paso4=false;
                updateUser();
                CONS_Respuestasolicitudclave_JSON  rescla=(CONS_Respuestasolicitudclave_JSON)JSON.deserialize(resp,CONS_Respuestasolicitudclave_JSON.class);  
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'se llamo al servicio email');
                ApexPages.addMessage(myMsg);  
                ApexPages.Message mens = new ApexPages.Message(ApexPages.Severity.CONFIRM,'correo enviado a  '+email);
                ApexPages.addMessage(mens); 
                menser=rescla.mensaje;
                nuevaclave();
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'se genero el siguiente error '+resp);
                ApexPages.addMessage(myMsg);  
                menser=resp;
                servicioerror();
            }
        }else{
           // if( pro.name=='Ejecutivos de Atención al Cliente Seguros Remoto' || pro.name=='Jefe de Atención al Cliente Seguros Remoto'  || pro.name=='Usuario Seguros Administrador' ){
            if(PerfilesMeta.Pide_huella__c == false){ 
                paso1=false;
                paso2=false;  
                paso3=true;
                paso4=false;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cliente no registra correo electrónico, debe actualizar datos ');
                ApexPages.addMessage(myMsg);  
                
                
            }else{
                if(email==null){
                paso1=false;
                paso2=true;
                paso3=false;
                }else{
                return rechazaclave();   
                }
            }
            
        }
        
        
        
        return null;
        
    }
    
    
    
    
    
    public PageReference guardar(){
        if( Rech!='RHA'){
        string iduser=userinfo.getUserId();
        
        //  user us =[SELECT Id, RUT__c  FROM User WHERE Id = :iduser];
        string []rutejec= us.RUT__c.split('');
        integer i=rutejec.size();
        string rutejecutivo='';
        for(integer j=0;j<=i-2;j++){
            rutejecutivo=rutejecutivo+rutejec[j];  
        }
        //    Account ac=[SELECT Id, name,PersonEmail,RUT__c  FROM Account where id=:id limit 1];
        string []rut= ac.RUT__c.split('-');
        string estructura='{'+
            '"rut": "'+rut[0]+'",'+    //sin dijito  verificador 
            '"folio": "'+folio+'",'+
            '"rutEjecutivo": "'+rutejecutivo+'"'+     //sin dijito  verificador   es obligatorio 
            '}';
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);

		tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId() limit 1];

        Cons_callOutService  call=new Cons_callOutService();
        string resp=call.callOutSolisitud_clave_folio(access_token, estructura,tmpUser);
        
        CONS_Respuestasolicitudclave_JSON rescla;
        paso1=false;
        paso2=false;  
        paso3=true;
        if(!resp.contains('ERROR -')){
        	updateUser();
            rescla=(CONS_Respuestasolicitudclave_JSON)JSON.deserialize(resp,CONS_Respuestasolicitudclave_JSON.class);  
            if(rescla.codigo=='0'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Respuesta: '+rescla.mensaje);
                ApexPages.addMessage(myMsg); 
                 menser=rescla.mensaje;
                nuevaclave();
            }else{
                paso1=false;
                paso2=true;  
                paso3=false;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: '+rescla.mensaje);
                ApexPages.addMessage(myMsg);   
            }
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'se genero el siguiente error '+resp);
            ApexPages.addMessage(myMsg);  
            
        }
        }else{
            system.debug('ooosi');
            return rechazaclave();
        }
        
        
        
        return null;
    }
    
    
    
    public PageReference Guardarremoto(){
        if(registro==null || registro=='' ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ingrese  Codigo de Validacion ');
            ApexPages.addMessage(myMsg);   
        }else{
            return  verificaemail();
        }
        return null;
        
    }
    
    
    public PageReference desbloquear(){
        string user=UserInfo.getUserId();
        
        system.debug('se creara el caso');
        cas=new case();
        
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
        //Setting the DMLOption on Case instance
        cas.setOptions(dmlOpts);
        
        // User us=[SELECT Id, AccountId, UserRole.name FROM User where id=:user limit 1];
        //Account ac=[SELECT Id, name,PersonEmail  FROM Account where id=:id limit 1];
        string canal =us.UserRole.name;
        
        RecordType rec=[SELECT Id, Name, DeveloperName, SobjectType, IsActive, IsPersonType FROM RecordType where DeveloperName=:'Casos_Seguros' limit 1];
        
        cas.RecordTypeId=rec.id; 
        cas.AccountId=ac.id;
        cas.Status='Nuevo';
        cas.Subtipo__c='Gestión Clave';
        cas.Type='Solicitud';
        cas.Origin='Presencial';
        cas.Priority='Media';
        cas.Subject='Solicitud de desbloqueo de clave';
        cas.Autoriza_huella_Nectia__c=false;
        cas.Origin = origen;
        insert cas;
        system.debug('se creo el caso');
        
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'se genero caso desbloqueo de cuenta ');//+cas1.CaseNumber);
        ApexPages.addMessage(myMsg); 
        paso3=true;
        return null;
        // PageReference pageRef = new PageReference('/'+cas.id);
        //  return pageRef;
        
    }
    
    
    public PageReference nuevaclave(){
        
        string canal =us.UserRole.name;
        
        RecordType rec=[SELECT Id, Name, DeveloperName, SobjectType, IsActive, IsPersonType FROM RecordType where DeveloperName=:'Seguros_Solicitud' limit 1];
        
        //Cons_callOutService   call=new Cons_callOutService();
        string str='';
        
        cas=new case();
        cas.RecordTypeId=rec.id; 
        cas.AccountId=ac.id;
        cas.Status='Cerrado';
        cas.Subtipo__c='Gestión Clave';
        cas.Type='Solicitud';
        //cas.Origin='Presencial';
        cas.Priority='Media';
        cas.Subject='nueva clave';
        cas.Sub_estado_Nectia__c='Solucionado';
        cas.Codigo_de_Validacion_Autentia_Nectia__c=(Naut=='huella_rechazada'?'huella rechazada':Naut);
        cas.Folio_nueva_clave_Nectia__c=(folio==0?null:folio==null?null:string.valueOf(folio));
        cas.Mensaje_Transaci_n__c=menser;
        cas.Origin = origen;
        insert cas;
        //Case cas1=[SELECT Id, CaseNumber FROM Case where id=:cas.id limit 1];
        
        //  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'sea creado el caso numero');//+cas1.CaseNumber);
        //  ApexPages.addMessage(myMsg);      
        
        
        return null;
    }
    
    public PageReference rechazaclave(){ 
        
        RecordType rec=[SELECT Id, Name, DeveloperName, SobjectType, IsActive, IsPersonType FROM RecordType where DeveloperName=:'Seguros_Solicitud' limit 1];
        
        string str='';
        cas=new case();
        cas.RecordTypeId=rec.id; 
        cas.AccountId=ac.id;
        cas.Status='Nuevo';
        cas.Subtipo__c='Gestión Clave';
        cas.Type='Solicitud';
        cas.Subject='se requierer validacion';
        cas.Priority='Media';
        cas.Subject='nueva clave';
        cas.Codigo_de_Validacion_Autentia_Nectia__c=(Naut=='huella_rechazada'?'huella rechazada':Naut);
        cas.Folio_nueva_clave_Nectia__c=(folio==0?null:folio==null?null:string.valueOf(folio));
        cas.Sub_estado_Nectia__c='Derivado a Supervisor';
        cas.Autoriza_huella_Nectia__c=false;
        cas.Origin = origen;
        insert cas;
        system.debug('cas.sas'+cas);
        PageReference pageRef = new PageReference('/'+cas.id);
        return pageRef;
        
    }
    
    public PageReference servicioerror(){ 
        
        RecordType rec=[SELECT Id, Name, DeveloperName, SobjectType, IsActive, IsPersonType FROM RecordType where DeveloperName=:'Seguros_Solicitud' limit 1];
        
        string str='';
        cas=new case();
        cas.RecordTypeId=rec.id; 
        cas.AccountId=ac.id;
        cas.Status='Nuevo';
        cas.Subtipo__c='Gestión Clave';
        cas.Type='Solicitud';
        cas.Subject='se requierer validacion';
        cas.Priority='Media';
        cas.Subject='nueva clave';
        cas.Codigo_de_Validacion_Autentia_Nectia__c=(Naut=='huella_rechazada'?'huella rechazada':Naut);
        cas.Folio_nueva_clave_Nectia__c=(folio==0?null:folio==null?null:string.valueOf(folio));
        cas.Sub_estado_Nectia__c='Derivado a Supervisor';
        cas.Autoriza_huella_Nectia__c=false;
        cas.Mensaje_Transaci_n__c=menser;
        cas.Origin = origen;
        insert cas;
        PageReference pageRef = new PageReference('/'+cas.id);
        return pageRef;
        
    }
    
    public PageReference volver(){
        PageReference pageRef = new PageReference('/'+id);
        return pageRef;
    }
    public PageReference continuar(){
        if(cas!=null){
            PageReference pageRef = new PageReference('/'+cas.id);
            return pageRef; 
        }else{
            PageReference pageRef = new PageReference('/'+id);
            return pageRef; 
        }
        
    }

	public void updateUser(){
		system.debug(tmpUser.AccessToken_Nectia__c);
		update tmpUser;
	}

	public PageReference orquestaMetodos(){
		tipodeseguro();
		updateUser();
		return null;
	}
}