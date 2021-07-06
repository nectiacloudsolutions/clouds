public class CONS_Poliza {
    public String idcas{get;set;}
    public String Naut{get;set;}
    public User tmpUser{get;set;}
    public CONS_Poliza() {
        idcas = ApexPages.currentPage().getParameters().get('id');
        Naut = ApexPages.currentPage().getParameters().get('Naut');
    }
    
    public PageReference terminopoliza(){
        idcas = ApexPages.currentPage().getParameters().get('id');
        system.debug('entro a terminopoliza');
        system.debug('idcas'+idcas);
        case cas=[select id,Accountid,Account.Name,Producto_del_Cliente_Nectia__c,Rut_del_Cliente__c,Seguros_producto__c,Linea_Producto_Seguros__c,CreatedDate,
                  Fecha_Fin_Vigencia__c,Motivo_Anulaci_n__c, CaseNumber,Type,Subtipo__c,SlaStartDate,ownerid,Account.Phone,Account.PersonEmail,Mensaje_Transaci_n__c,
                  transacion_ejecutada__c,N_de_Endoso__c,Codigo_de_Validacion_Autentia_Nectia__c,Description,Fecha_de_Vigencia_de_Tarjeta_Nectia__c
                  from case where id=:idcas];
        user  us=[select  id, Codigo_Usuario_Nectia__c, RUT__c,FederationIdentifier from user where id=:cas.ownerid limit 1];
        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId() limit 1];
        Producto_del_Cliente__c pro=[select id,Codigo_Plan_Nectia__c,Poliza_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c,Ramo_Nectia__c,RUT_intermediario_Nectia__c 
                                     from Producto_del_Cliente__c where id=:cas.Producto_del_Cliente_Nectia__c limit 1];
        Arbol_Comunicaciones__mdt   arcom;
        try{
            arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c 
                   FROM Arbol_Comunicaciones__mdt  where   Tipo__c=:cas.type  and Subtipo__c=:cas.Subtipo__c limit 1];
            system.debug('arcom'+arcom);
        }catch(Exception e){
            system.debug('plantilla   no  enctontrada ');
        }
        
        String fechaHoy = String.valueOf(Datetime.now().format('dd-MM-yyyy'));
        System.debug('fecha hoy string->'+fechaHoy);
        String defdate = fechaHoy;

        CONS_terminopoliza_JSON  j=new CONS_terminopoliza_JSON();
        
        j.nBranch=integer.valueOf(pro.Ramo_Nectia__c==null?'0':pro.Ramo_Nectia__c);
        j.nProduct=integer.valueOf(pro.Codigo_Plan_Nectia__c==null?'0':pro.Codigo_Plan_Nectia__c);
        j.nPolicy=integer.valueOf(pro.Poliza_Nectia__c==null?'0':pro.Poliza_Nectia__c);
        j.nCertif=integer.valueOf(pro.Numero_Certificado_Nectia__c==null?'0':pro.Numero_Certificado_Nectia__c);
        
        Date dp;
        if (cas.Fecha_de_Vigencia_de_Tarjeta_Nectia__c != null){
        	dp = cas.Fecha_de_Vigencia_de_Tarjeta_Nectia__c;
        }
        System.debug('dp->'+dp);
        
        String depoldate;
        if (dp != null){
        	depoldate = String.valueOf(dp.format());
        }else{
        	depoldate = '';
        }
        System.debug('fecha string depoldate->'+depoldate);

        if(pro.Esquema_Nectia__c=='CLONINSUDB'){
        	j.dPolicyNullDate=depoldate;//defdate;        //  fecha  anulacion endoso 
        }else{
             j.dPolicyNullDate=defdate;//defdate;    
        }
        //j.nUserCode=60000;//integer.valueOf(us.Codigo_Usuario_Nectia__c==null?'0':us.Codigo_Usuario_Nectia__c);
        j.nUserCode= (us.FederationIdentifier ==null?'':us.FederationIdentifier ); 
        j.nCase=integer.valueOf(cas.CaseNumber==null?'0':cas.CaseNumber);
        j.nNullCode=integer.valueOf(cas.Motivo_Anulaci_n__c==null?'0':cas.Motivo_Anulaci_n__c);
        j.sCaseName=cas.Type+'-'+cas.Subtipo__c;
        j.sClientName=cas.Account.Name;
        if(arcom!=null){
            j.sTemplate=arcom.Plantilla__c;
            j.nBusinessNumber=integer.valueOf(arcom.Numero_Linea__c==null?'0':arcom.Numero_Linea__c); 
        }else{
            j.sTemplate='';
            j.nBusinessNumber=0; 
        }
        
        //j.sClientCellphone=integer.valueOf(cas.Account.Phone==null?'0':cas.Account.Phone);   //Opcional

        String fr = String.valueOf(cas.CreatedDate.format('dd-MM-yyyy'));
        System.debug('fecha recepcion->'+fr);

        //DateTime d2 = cas.CreatedDate;
        //String fr = d2.format('dd-MM-yyyy');
        j.dRecceptionDate=fr;  //Opcional
        j.sClientEmail=cas.Account.PersonEmail;   //Opcional
        j.dEffecDate=defdate;                            //Opcional  //  fecha  anulacion endoso 
        string envio =JSON.serialize(j);
        
        Cons_callOutService  call= new Cons_callOutService();
        /*    string token=call.callOuttoken();
system.debug('token'+token);
CONS_token_JSON tok = (CONS_token_JSON)JSON.deserialize(token,CONS_token_JSON.class);  
system.debug('token=='+tok.access_token);*/
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);
        string str='';
        if(pro.Esquema_Nectia__c=='INSUDB'){
            str=call.callOutTermino_poliza_vida(access_token,envio, tmpUser);
            system.debug('este es cuando es Insudb'+str);
        }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){
            str=call.callOutTermino_poliza_generales(access_token, envio, tmpUser);
            system.debug('este es el llamdo si es clininsudb' +str);
        }else{
            system.debug('no pertenese a ningun  esquema  de coneccion');
            
        }
                   
        /*  if(str!=''){
system.debug('str=='+str);
CONS_RespuestaTerminoPoliza_JSON resp = (CONS_RespuestaTerminoPoliza_JSON)JSON.deserialize(str,CONS_RespuestaTerminoPoliza_JSON.class);  
//   system.debug('mensage del servicio == '+resp.mensaje +'  '+resp.RespuestaBase.mensaje); 
cas.Mensaje_Transaci_n__c=str;
cas.transacion_ejecutada__c=false;

update cas;
}*/
        if(test.isRunningTest()){
            str='{ "codigo": "99", "mensaje": "Ocurrió un error al ejecutar el servicio", "respuestaBase": { "codigo": "1", "mensaje": "Ingrese codigo de usuario valido", "nPropuesta": "0" }}';
        }
        if(!str.contains('ERROR -')){
            CONS_respuestaservicio_JSON res = (CONS_respuestaservicio_JSON)JSON.deserialize(str,CONS_respuestaservicio_JSON.class);  
            system.debug('mensage del servicio == '+res.mensaje); 
            if(res.codigo=='0'){
                alertaspin(pro.Poliza_Nectia__c, pro.Codigo_Plan_Nectia__c, cas.CaseNumber, pro.RUT_intermediario_Nectia__c, cas.Description);
                cas.Mensaje_Transaci_n__c=res.mensaje; 
                cas.N_de_Endoso__c=decimal.valueOf(res.RespuestaBase.nPropuesta==null?'0':res.RespuestaBase.nPropuesta);
                cas.transacion_ejecutada__c=true;
            }else{
                
                if(res.RespuestaBase!=null){
                    if(res.RespuestaBase.codigo=='0'){
                       alertaspin(pro.Poliza_Nectia__c, pro.Codigo_Plan_Nectia__c, cas.CaseNumber, pro.RUT_intermediario_Nectia__c, cas.Description);  
                    }
                    cas.Mensaje_Transaci_n__c=res.RespuestaBase.mensaje;
                    cas.N_de_Endoso__c=decimal.valueOf(res.RespuestaBase.nPropuesta==null?'0':res.RespuestaBase.nPropuesta);
                    
                }else{
                    cas.Mensaje_Transaci_n__c=res.mensaje; 
                    cas.transacion_ejecutada__c=false;
                }
                if(res.respuestaEmailmatico!=null){
                    cas.Mensaje_Transaci_n__c=cas.Mensaje_Transaci_n__c+ '/n '+res.respuestaEmailmatico.mensaje; 
                    
                }
            }
            cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
        }else{
            cas.Mensaje_Transaci_n__c=str;
            cas.transacion_ejecutada__c=false;
            cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
        }
        
        update cas;
        system.debug('respuesta del servicio=='+str);
        return null;
    }
    
    
    
    public PageReference Rehabilitacionpoliza(){
        idcas = ApexPages.currentPage().getParameters().get('id');
        system.debug('entro a Rehabilitacionpoliza');
        system.debug('idcas'+idcas);
        case cas=[select id,Accountid,Account.Name,Producto_del_Cliente_Nectia__c,Rut_del_Cliente__c,Seguros_producto__c,Linea_Producto_Seguros__c,type,Subtipo__c,
                  Motivo_Anulaci_n__c,ownerid ,CaseNumber,Account.Phone,SlaStartDate,N_de_Endoso__c,Account.PersonMobilePhone,
                  Account.PersonEmail,Codigo_de_Validacion_Autentia_Nectia__c  from case where id=:idcas limit 1];
        user  us=[select  id, Codigo_Usuario_Nectia__c, RUT__c,FederationIdentifier from user where id=:cas.ownerid limit 1];
        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId() limit 1];
        Producto_del_Cliente__c pro=[select id,Codigo_Plan_Nectia__c,Poliza_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c,Ramo_Nectia__c,RUT_intermediario_Nectia__c
                                     from Producto_del_Cliente__c where id=:cas.Producto_del_Cliente_Nectia__c limit 1];
        Arbol_Comunicaciones__mdt   arcom;
        try{
            system.debug('buscando plantilla ');
            arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c 
                   FROM Arbol_Comunicaciones__mdt  where   Tipo__c=:cas.type  and Subtipo__c=:cas.Subtipo__c limit 1];
            system.debug('arcom'+arcom);
        }catch(Exception e){
            system.debug('plantilla  no encontrada ');
            arcom=null;
        }
        CONS_Rehabilitacionpoliza_JSON    j=new CONS_Rehabilitacionpoliza_JSON();
        j.nBranch=integer.valueOf(pro.Ramo_Nectia__c==null?'0':pro.Ramo_Nectia__c);   //Obligatorio
        j.nProduct=integer.valueOf(pro.Codigo_Plan_Nectia__c==null?'0':pro.Codigo_Plan_Nectia__c);//Obligatorio
        j.nPolicy=integer.valueOf(pro.Poliza_Nectia__c==null?'0':pro.Poliza_Nectia__c);//Obligatorio
        j.nCertif=integer.valueOf(pro.Numero_Certificado_Nectia__c==null?'0':pro.Numero_Certificado_Nectia__c);//Obligatorio
        DateTime d1 = system.now();
        String defdate = d1.format('dd-MM-yyyy') ;
        j.dEffecDate=defdate;//string.valueOf(cas.SlaStartDate);                                              //Opcional
        //j.nUserCode=60000;//integer.valueOf(us.Codigo_Usuario_Nectia__c==null?'0':us.Codigo_Usuario_Nectia__c);//Obligatorio
        j.nUserCode= (us.FederationIdentifier ==null?'':us.FederationIdentifier ); 
        j.nCase=integer.valueOf(cas.CaseNumber==null?'0':cas.CaseNumber);//Obligatorio
        j.sCaseName=cas.Subtipo__c;//Obligatorio
        j.sClientName=cas.Account.Name;//Obligatorio
        if(arcom!=null){
            j.sTemplate=arcom.Plantilla__c;//Obligatorio
            j.nBusinessNumber=integer.valueOf(arcom.Numero_Linea__c==null?'0':arcom.Numero_Linea__c);//Obligatorio
        }else{
            j.sTemplate='';//Obligatorio
            j.nBusinessNumber=0;//Obligatorio
        }
        string telefono;
        if(cas.Account.PersonMobilePhone==null){
            telefono='0';
        }else{
            telefono=cas.Account.PersonMobilePhone.replace(' ','').replace('+','');
        }
        j.sClientCellphone=integer.valueOf(telefono);                //Opcional
        j.dRecceptionDate=defdate;//string.valueOf(cas.SlaStartDate);                                          //Opcional 
        j.sClientEmail=(cas.Account.PersonEmail==null?'':cas.Account.PersonEmail);                        //Opcional
        string envio =JSON.serialize(j);
        
        Cons_callOutService  call= new Cons_callOutService();
        /* string token=call.callOuttoken();
system.debug('token'+token);
CONS_token_JSON tok = (CONS_token_JSON)JSON.deserialize(token,CONS_token_JSON.class);  
system.debug('token=='+tok.access_token);*/
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);
        string str='';
        if(pro.Esquema_Nectia__c=='INSUDB'){
            
            str=call.callOutRehabilitacion_poliza_vida(access_token,envio,tmpUser);
        }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){
            
            str=call.callOutRehabilitacion_poliza_generales(access_token,envio,tmpUser);
        }else{
            system.debug('no pertenese a ningun  esquema  de coneccion');
            
        }
        
        /*  if(!str.contains('ERROR -')){
CONS_RespuestaRehabilitacionpoliza_JSON resp = (CONS_RespuestaRehabilitacionpoliza_JSON)JSON.deserialize(str,CONS_RespuestaRehabilitacionpoliza_JSON.class);  
system.debug('mensage del servicio == '+resp.httpMessage); 
}
cas.Mensaje_Transaci_n__c=str;
cas.transacion_ejecutada__c=false;
update cas;
*/
        if(test.isRunningTest()){
            str='{ "codigo": "99", "mensaje": "Ocurrió un error al ejecutar el servicio", "respuestaBase": { "codigo": "1", "mensaje": "Ingrese codigo de usuario valido", "nPropuesta": "0" }}';
        }
        
        if(!str.contains('ERROR -')){
            CONS_respuestaservicio_JSON res = (CONS_respuestaservicio_JSON)JSON.deserialize(str,CONS_respuestaservicio_JSON.class);  
            system.debug('mensage del servicio == '+res.mensaje); 
            if(res.codigo=='0'){
                cas.Mensaje_Transaci_n__c=res.mensaje; 
                cas.N_de_Endoso__c=decimal.valueOf(res.RespuestaBase.nPropuesta==null?'0':res.RespuestaBase.nPropuesta);
                cas.transacion_ejecutada__c=true;
                
            }else{
                
                if(res.RespuestaBase!=null){
                    cas.Mensaje_Transaci_n__c=res.RespuestaBase.mensaje; 
                    cas.N_de_Endoso__c=decimal.valueOf(res.RespuestaBase.nPropuesta==null?'0':res.RespuestaBase.nPropuesta);
                      if(res.RespuestaBase.codigo=='0'){
                         cas.transacion_ejecutada__c=true;   
                      }
                }else{
                    cas.Mensaje_Transaci_n__c=res.mensaje; 
                    cas.transacion_ejecutada__c=false;
                }
                if(res.respuestaEmailmatico!=null){
                    cas.Mensaje_Transaci_n__c=cas.Mensaje_Transaci_n__c+ '/n '+res.respuestaEmailmatico.mensaje; 
                    
                }
            }
            cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
        }else{
            cas.Mensaje_Transaci_n__c=str;
            cas.transacion_ejecutada__c=false;
            cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
        }
        
        update cas;
        system.debug('respuesta del servicio=='+str);
        return null;
    }
    
    public  PageReference continuar(){
        system.debug('entro a continuar'); 
        PageReference p = new PageReference('/'+idcas);
        p.setRedirect(true);
        return p;
    }
    
    
    public PageReference alertaspin( string poliza,string idproducto,string Numcas,string rutintermediario,string detalle){
        system.debug('entrpo a  alerta pin');
        DateTime fecha = system.now();
        String fechaingreso = fecha.format('dd-MM-yyyy');
        CONS_AlertaPin_JSON  ap=new CONS_AlertaPin_JSON();
        string []rutsindv=rutintermediario.split('-');
        integer i =rutsindv[0].length();
        string rutfinal='';
        for(integer r=i;r<14;r++){
            rutfinal=rutfinal+'0';
        }
        rutfinal=rutfinal+rutsindv[0];
        ap.nNumCaso=Numcas;
        ap.sProductId=idproducto;
        ap.nPoliza=poliza;
        ap.sDescr='Anulacion Poliza';
        ap.sFechaIngreso=fechaingreso;
        ap.sFechaCierre='';
        ap.sEstado='PENDE';
        ap.sMontoTrasp='';
        ap.sInstitTrasp='';
        ap.sRutIntermediario=rutfinal;
        ap.sDetalle=(detalle==null?'Termino de poliza':detalle);
        string envio =JSON.serialize(ap);
        system.debug('envio alerta pin'+envio);
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);
        string str='';

        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];

        Cons_callOutService  call= new Cons_callOutService();

        string resp=call.callOutAlertaPin_Solicitud(access_token, envio,tmpUser);

        system.debug('resp alerta pin'+resp);
        return null;
    }

	public void updateUser(){
		system.debug(tmpUser.AccessToken_Nectia__c);
		update tmpUser;
	}

	public PageReference orquestaMetodosRehab(){
		Rehabilitacionpoliza();
		updateUser();
		return null;
	}

	public PageReference orquestaMetodosTermino(){
		terminopoliza();
		updateUser();
		return null;
	}
    
}