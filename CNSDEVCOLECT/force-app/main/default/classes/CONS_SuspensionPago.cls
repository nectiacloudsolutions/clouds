public class CONS_SuspensionPago {
    public   string  idcas{get;set;}
    public User tmpUser{get;set;}
    public CONS_SuspensionPago(){
        idcas = ApexPages.currentPage().getParameters().get('id');
    }
    public PageReference suspenciondepago(){
        
        case cas=[select id,Accountid,Account.Name,Account.PersonMobilePhone,CaseNumber,Banco__c,N_mandato__c,Account.PersonEmail,Type,Subtipo__c,Rut_del_Cliente__c,
                  Producto_del_Cliente_Nectia__c,Status,Sub_estado_Nectia__c,CreatedDate,Mensaje_Transaci_n__c,transacion_ejecutada__c,Fecha_Inicio_Suspensi_n__c,
                  Fecha_Fin_Suspensi_n__c,Motivo_de_Suspensi_n__c,Description
                  from case where id=:idcas];
        system.debug('cas='+cas);
        string userid=UserInfo.getUserId();
        system.debug('userid'+userid);
        user  us=[select id,Codigo_Usuario_Nectia__c,FederationIdentifier  from user where id=:userid];
        system.debug('us='+us);
        user tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId() limit 1];
        system.debug('tmpUser='+tmpUser);
        Producto_del_Cliente__c pro=[select id,Codigo_Plan_Nectia__c,Poliza_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c,Ramo_Nectia__c, L_nea__c
                                     from Producto_del_Cliente__c where id=:cas.Producto_del_Cliente_Nectia__c];
        Arbol_Comunicaciones__mdt   arcom;
        try{
            system.debug('try casos');
            
            if(cas.Status!='Cerrado'){
                
                arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c 
                       FROM Arbol_Comunicaciones__mdt  where   Tipo__c=:cas.type  and Subtipo__c=:cas.Subtipo__c  and Estado_del_caso__c=:cas.Status and Linea_de_negocio__c=: pro.L_nea__c limit 1];
                system.debug('arcom1'+arcom);
            }else if(cas.Sub_estado_Nectia__c!=null &&  cas.Sub_estado_Nectia__c!=''){
                
                // agregar forma de pago
                arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c 
                       FROM Arbol_Comunicaciones__mdt  where   Tipo__c=:cas.type  and 
                       Subtipo__c=:cas.Subtipo__c  and Estado_del_caso__c=:cas.Status  and Subestado_del_caso__c=:cas.Sub_estado_Nectia__c and Linea_de_negocio__c=: pro.L_nea__c limit 1];
                
                system.debug('arcom2'+arcom);
            }else{
                
                system.debug('estructura  no encontrada ');
                arcom=null;
            }
            
        }catch(Exception e){
            system.debug('catch error');
            arcom=null;
        } 
        
          string []resp=cas.Description.split('\n');
        string []fecha1;
        string []fecha2;
        for(integer i=0;i<resp.size();i++){
            if(resp[i].contains('Fecha Inicio Suspensión:')){
                fecha1=resp[i].split(': ');
            }
            if(resp[i].contains('Fecha Fin Suspensión:')){
                fecha2=resp[i].split(': ');
            }
        }
        CONS_SuspensionPago_JSON  j=new CONS_SuspensionPago_JSON();
        
        CONS_SuspensionPago_JSON.DatosSuspension   ds=new CONS_SuspensionPago_JSON.DatosSuspension();
        ds.codigoISPL='CO633';//fijo
        ds.codigoAreaSeguro=integer.valueOf(pro.Esquema_Nectia__c=='INSUDB'?'1':pro.Esquema_Nectia__c=='CLONINSUDB'?'2':'0');   //fijo     1  generales  2   vida 
        ds.numeroPoliza=integer.valueOf(pro.Poliza_Nectia__c==null?'0':pro.Poliza_Nectia__c);
        ds.codigoBranch=integer.valueOf(pro.Ramo_Nectia__c);
        ds.codigoProducto=integer.valueOf(pro.Codigo_Plan_Nectia__c);
        DateTime d1 = cas.CreatedDate ;
        String defdate = d1.format('dd-MM-yyyy'); 
        ds.deffecDate=defdate;
        ds.codigoTipoOperacion=1;    //fijo    1  suspencion     2  rehabilitacion    (solo se utilizara  suspencion)
         DateTime difs = Datetime.valueOf(fecha1[1]);
        if (difs != null){
            String datestr = difs.format('dd-MM-yyyy') ;
            ds.fechaInicioSuspencion=datestr;
        }else{
           ds.fechaInicioSuspencion='';
        }
       
         DateTime dffs = Datetime.valueOf(fecha2[1]);
        if (dffs != null){
            String fechafin = dffs.format('dd-MM-yyyy') ;
           ds.fechaFinSuspencion=fechafin;
        }else{
            ds.fechaFinSuspencion='';
        }
       
        ds.codigoRazonSuspencion=integer.valueOf(cas.Motivo_de_Suspensi_n__c);    //  ingresa por pantalla
        
        ds.codigoTipoSuspencion=0;      //    0   parcial
        ds.numeroCaso=integer.valueOf(cas.CaseNumber);  
        ds.codigoUsuario=(us.FederationIdentifier==null?'':us.FederationIdentifier);
        j.DatosSuspension=ds;
        
        
        CONS_SuspensionPago_JSON.ParamsEmailmatico   dpe=new CONS_SuspensionPago_JSON.ParamsEmailmatico();
        dpe.nCelular=integer.valueOf(cas.Account.PersonMobilePhone==null?'0':cas.Account.PersonMobilePhone);
        dpe.nNumMandato=integer.valueOf(cas.N_mandato__c==null?'0':cas.N_mandato__c);
        dpe.nNumpoliza=integer.valueOf(pro.Poliza_Nectia__c==null?'0':pro.Poliza_Nectia__c);
        dpe.nNumsolicitud=integer.valueOf(cas.CaseNumber);
        dpe.nResolucionCaso='';
        dpe.nTelefonoEjec=0;
        dpe.sBanco=(cas.Banco__c==null?'':cas.Banco__c);
        dpe.sEmail=(cas.Account.PersonEmail==null?'':cas.Account.PersonEmail);
        dpe.sFechaCierre='';
        dpe.sFechaEfectivaEndoso='';
        DateTime d = cas.CreatedDate ;
        if (d != null){
            String dateStr =  d.format('dd-MM-yyyy') ;
            dpe.sFechaRecepcion=dateStr;
        }else{
            dpe.sFechaRecepcion='';
        }
        dpe.sMailEjecutivo='';
        dpe.sMotivoRechazo='';
        dpe.sNombcaso=cas.Type+'-'+cas.Subtipo__c;
        dpe.sNombreCliente=cas.Account.Name;
        dpe.sNomEjecutivo='';
        if(arcom!=null){
            dpe.nNegocio = integer.valueOf(arcom.Numero_Linea__c);
            dpe.sLinNegocio = arcom.Linea_de_negocio__c;
            dpe.sPlantilla='PLA0000003';//arcom.Plantilla__c;
        }else{
            dpe.nNegocio = integer.valueOf(pro.Esquema_Nectia__c=='INSUDB'?'1':pro.Esquema_Nectia__c=='CLONINSUDB'?'2':pro.Esquema_Nectia__c=='SISRVOWCNS'?'1':pro.Esquema_Nectia__c=='SISRVOWPCNS'?'1':pro.Esquema_Nectia__c=='SISRVOWCNL'?'1':'0');
            dpe.sLinNegocio = (pro.Esquema_Nectia__c=='INSUDB'?'Vida':pro.Esquema_Nectia__c=='CLONINSUDB'?'Generales':pro.Esquema_Nectia__c=='SISRVOWCNS'?'RV':pro.Esquema_Nectia__c=='SISRVOWPCNS'?'RV':pro.Esquema_Nectia__c=='SISRVOWCNL'?'RV':'');
            dpe.sPlantilla='';   
        }
        
        dpe.sRutCliente=cas.Rut_del_Cliente__c;
        
        j.ParamsEmailmatico=dpe;
        
        
        string envio =JSON.serialize(j);
        
        
        Cons_callOutService  call= new Cons_callOutService();
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);
        string str='';
        if(pro.Esquema_Nectia__c=='INSUDB'){

            str=call.callOutSuspension_pagos_Vida(access_token,envio,tmpUser);
			System.debug('token->'+tmpUser.AccessToken_Nectia__c);
			updateUser(tmpUser.AccessToken_Nectia__c);

        }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){
            system.debug('no existe servicio para  este tipo de producto ');
        }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){
            system.debug('no existe servicio para  este tipo de producto ');
        }
          if(test.isRunningTest()){
            str='{"codigo": "99", "mensaje": "Ocurrió un error al ejecutar el servicio", "respuestaBase": { "codigo": "1", "mensaje": "Ingrese codigo de usuario valido"  }}';
        }
        
        
        if(!str.contains('ERROR -')){
            CONS_respuestaservicio_JSON res = (CONS_respuestaservicio_JSON)JSON.deserialize(str,CONS_respuestaservicio_JSON.class);  
            system.debug('mensage del servicio == '+res.mensaje); 
            if(res.codigo=='0'){
                cas.Mensaje_Transaci_n__c=res.mensaje; 
                cas.N_de_Endoso__c=decimal.valueOf(res.RespuestaBase.nPropuesta==null?'0':res.RespuestaBase.nPropuesta);
                cas.transacion_ejecutada__c=true;
                cas.Status='Cerrado';
                cas.Sub_estado_Nectia__c='Solucionado';
            }else{
                if(res.RespuestaBase!=null){
                     system.debug('respuesta base');
                    cas.Mensaje_Transaci_n__c=res.RespuestaBase.mensaje.left(255); 
                    cas.transacion_ejecutada__c=true;
                }else{
                    cas.Mensaje_Transaci_n__c=res.mensaje; 
                    cas.transacion_ejecutada__c=false;
                }
                if(res.respuestaEmailmatico!=null){
                    cas.Mensaje_Transaci_n__c=cas.Mensaje_Transaci_n__c+ '/n '+res.respuestaEmailmatico.mensaje; 
                }
            }
        }else{
            cas.Mensaje_Transaci_n__c=str;
            cas.transacion_ejecutada__c=false;
        }
        update cas;
        
        
        return null;
    }
    
    public  PageReference continuar(){
        system.debug('entro a continuar'); 
        PageReference p = new PageReference('/'+idcas);
        p.setRedirect(true);
        return p;
    }

  	public void updateUser(String tokenActualizado){
		system.debug('token actualizado->'+tokenActualizado);
		User usuarioParaActualizar = [SELECT Id,AccessToken_Nectia__c FROM User WHERE Id =: UserInfo.getUserId()];

		usuarioParaActualizar.AccessToken_Nectia__c = tokenActualizado;
		update usuarioParaActualizar;
	}
}