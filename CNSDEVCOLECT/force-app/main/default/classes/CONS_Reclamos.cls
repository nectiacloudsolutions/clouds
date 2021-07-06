public class CONS_Reclamos {

	public User tmpUser{get;set;}
    public String idcas{get;set;}

    public CONS_Reclamos() {
       
        idcas = ApexPages.currentPage().getParameters().get('id');
        
        // cambioviapago();
    }
    public PageReference Reclamos_Vida_Generales_RV(){
        
        case cas=[select id,Accountid,Account.Name,Account.FirstName,Account.lastName,Producto_del_Cliente_Nectia__c,Status,Rut_del_Cliente__c,Seguros_producto__c,Linea_Producto_Seguros__c,Tel_fono_de_contacto__c,
                  V_a_de_Pago__c,D_a_de_Pago__c,Account.PersonBirthdate,Account.Genero_Nectia__pc,Account.PersonEmail,Tipo_de_cuenta__c,CaseNumber,Banco__c,Mensaje_Transaci_n__c,
                  CreatedDate,N_mandato__c,CreatedByid,Fecha_de_Vigencia_de_Tarjeta_Nectia__c,Subtipo__c,Sub_estado_Nectia__c,type,SlaStartDate,Fecha_Vencimiento_Tarjeta__c,
                   transacion_ejecutada__c,Nueva_Instituci_n__c,Description from case where id=:idcas];
        system.debug('cas='+cas);
        string userid=UserInfo.getUserId();
        system.debug('userid'+userid);
        user  us=[select id,Codigo_Usuario_Nectia__c  from user where id=:userid];
        system.debug('us='+us);
        Producto_del_Cliente__c pro=[select id,Codigo_Plan_Nectia__c,Poliza_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c,Ramo_Nectia__c, L_nea__c,RUT_intermediario_Nectia__c
                                     from Producto_del_Cliente__c where id=:cas.Producto_del_Cliente_Nectia__c];
         Arbol_Comunicaciones__mdt   arcom;
        try{
        	system.debug('try casos');
            system.debug('cas.Sub_estado_Nectia__c'+cas.Sub_estado_Nectia__c);
            if(cas.Status!='Cerrado'){

           		arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c 
                                           FROM Arbol_Comunicaciones__mdt  where   Tipo__c=:cas.type  and Subtipo__c=:cas.Subtipo__c  and Estado_del_caso__c=:cas.Status and Linea_de_negocio__c=: pro.L_nea__c limit 1];
            	system.debug('arcom1'+arcom);
            }else if(cas.Sub_estado_Nectia__c!=null &&  cas.Sub_estado_Nectia__c!=''){
            	// agregar forma de pago
				arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c FROM Arbol_Comunicaciones__mdt  where
						Tipo__c=:cas.type  and 
						Subtipo__c=:cas.Subtipo__c  and 
						Estado_del_caso__c=:cas.Status and 
						Subestado_del_caso__c=:cas.Sub_estado_Nectia__c and 
						Linea_de_negocio__c=: pro.L_nea__c limit 1];

            system.debug('arcom2'+arcom);
            }else{
                
                system.debug('estructura  no encontrada ');
                arcom=null;
            }
            
        }catch(Exception e){
        		system.debug('catch error');
                arcom=null;
        }
       
        system.debug('pro='+pro);
        CONS_EnvioReclamos_JSON  j=new CONS_EnvioReclamos_JSON();
        j.nCelular=(cas.Tel_fono_de_contacto__c==null?'':cas.Tel_fono_de_contacto__c);
        j.nMandato=(cas.N_mandato__c==null?'':cas.N_mandato__c);
        j.nNumpoliza=(pro.Poliza_Nectia__c==null?'':pro.Poliza_Nectia__c);
        j.nNumsolicitud=string.valueOf(integer.valueOf(cas.CaseNumber));
        j.sResolucionCaso='';
        j.nTelefonoEjec='';
        j.sBanco=(cas.Banco__c==null?'':cas.Banco__c);
        j.sDoc_Adjunto='';
        j.sEmail=(cas.Account.PersonEmail==null?'':cas.Account.PersonEmail);
        j.sFechaCierre='';
        j.sNombreLiquidador='';
        j.sNombreTaller='';    
        j.sNominstitucion=(cas.Nueva_Instituci_n__c==null?'':cas.Nueva_Instituci_n__c);
         DateTime fechaendoso = null;
        if (fechaendoso != null){
        	String fendoso =  fechaendoso.format('dd-MM-yyyy') ;
        	j.sFechaEfectivaEndoso=fendoso;
        }else{
           j.sFechaEfectivaEndoso='';
        }
        DateTime d = cas.CreatedDate ;
        if (d != null){
        	String dateStr =  d.format('dd-MM-yyyy') ;
        	j.sFechaRecepcion=dateStr;
        }else{
            j.sFechaRecepcion='';
        }
        j.sMailEjecutivo='';
        j.sMotivoRechazo='';
        j.sNombcaso=cas.Type+'-'+cas.Subtipo__c;
        j.sNombreCliente=cas.Account.Name;
        j.sNomEjecutivo='';
        if(arcom!=null){
        //j.nNegocio=(pro.Esquema_Nectia__c=='INSUDB'?'1':pro.Esquema_Nectia__c=='CLONINSUDB'?'2':pro.Esquema_Nectia__c=='SISRVOWCNS'?'1':pro.Esquema_Nectia__c=='SISRVOWPCNS'?'1':pro.Esquema_Nectia__c=='SISRVOWCNL'?'1':'0');
        j.nNegocio = arcom.Numero_Linea__c;
        //j.sLinNegocio=arcom.Numero_Linea__c;
        j.sLinNegocio = arcom.Linea_de_negocio__c;
        j.sPlantilla=arcom.Plantilla__c;
        }else{
         j.nNegocio = (pro.Esquema_Nectia__c=='INSUDB'?'1':pro.Esquema_Nectia__c=='CLONINSUDB'?'2':pro.Esquema_Nectia__c=='SISRVOWCNS'?'1':pro.Esquema_Nectia__c=='SISRVOWPCNS'?'1':pro.Esquema_Nectia__c=='SISRVOWCNL'?'1':'0');
         j.sLinNegocio = (pro.Esquema_Nectia__c=='INSUDB'?'Vida':pro.Esquema_Nectia__c=='CLONINSUDB'?'Generales':pro.Esquema_Nectia__c=='SISRVOWCNS'?'RV':pro.Esquema_Nectia__c=='SISRVOWPCNS'?'RV':pro.Esquema_Nectia__c=='SISRVOWCNL'?'RV':'0');
         j.sPlantilla='';   
        }
        
        j.sRutCliente=cas.Rut_del_Cliente__c;
        string envio =JSON.serialize(j);

        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];
        
        Cons_callOutService  call= new Cons_callOutService();
        CONS_estructuratoken est=new  CONS_estructuratoken();
            string access_token=est.token();
            system.debug('token=='+access_token);
        string str='';
         if(pro.Esquema_Nectia__c=='INSUDB'){

            str=call.callOutReclamos_Vida(access_token,envio,tmpUser);
            
        }else if(pro.Esquema_Nectia__c=='CLONINSUDB'|| pro.Esquema_Nectia__c=='SOAP'){

            str= call.callOutReclamos_Generales(access_token,envio,tmpUser);

        }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){

            str= call.callOutReclamos_RV(access_token,envio,tmpUser);

        }else{
             system.debug('no existe  servicio  pro.Esquema_Nectia__c '+pro.Esquema_Nectia__c); 
               PageReference p = new PageReference('/'+idcas);
          p.setRedirect(true);
        return p;
        }
         system.debug('respuesta del servicio '+str);
        if(!str.contains('ERROR -')){
            CONS_respuestaservicio_JSON res = (CONS_respuestaservicio_JSON)JSON.deserialize(str,CONS_respuestaservicio_JSON.class);  
            system.debug('mensage del servicio == '+res.mensaje); 
            if(res.codigo=='0'){
                  if(cas.Subtipo__c=='Traspaso APV'){
                               alertaspin(pro.Poliza_Nectia__c, pro.Codigo_Plan_Nectia__c, cas.CaseNumber, pro.RUT_intermediario_Nectia__c, cas.Description);  
                          }
                cas.Mensaje_Transaci_n__c=res.mensaje; 
             
                cas.transacion_ejecutada__c=true;
            }else{
                if(res.RespuestaBase!=null){
                      if(res.RespuestaBase.codigo=='0'){
                          if(cas.Subtipo__c=='Traspaso APV'){
                               alertaspin(pro.Poliza_Nectia__c, pro.Codigo_Plan_Nectia__c, cas.CaseNumber, pro.RUT_intermediario_Nectia__c, cas.Description);  
                          }
                      
                    }
                     cas.Mensaje_Transaci_n__c=res.RespuestaBase.mensaje; 
                 
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
        ap.sDescr='Traspaso APV';
        ap.sFechaIngreso=fechaingreso;
        ap.sFechaCierre='';
        ap.sEstado='PENDE';
        ap.sMontoTrasp='';
        ap.sInstitTrasp='';
        ap.sRutIntermediario=rutfinal;
        ap.sDetalle=(detalle==null?'Traspaso APV':detalle);
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
    
    public PageReference continuar(string id){
        idcas=id;
        System.debug('idcas'+idcas);
        Reclamos_Vida_Generales_RV();
        return null;
    }
}