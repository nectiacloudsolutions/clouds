public class CONS_Comunicaciones {
    public String idcas{get;set;}
    public String urlSF{get;set;}
    public CONS_Comunicaciones() {
        urlSF = URL.getSalesforceBaseUrl().toExternalForm()+'/';
        idcas = ApexPages.currentPage().getParameters().get('id');
        
    }
    public PageReference endosocomunicaciones(){
          system.debug('endoso comunicaciones'); 
        idcas = ApexPages.currentPage().getParameters().get('id');
        case cas=[select id,Accountid,Account.Name,Account.FirstName,Account.lastName,Producto_del_Cliente_Nectia__c,Rut_del_Cliente__c,Seguros_producto__c,Linea_Producto_Seguros__c,
                  V_a_de_Pago__c,D_a_de_Pago__c,Account.PersonBirthdate,Account.Genero_Nectia__pc,Account.PersonEmail,Tipo_de_cuenta__c,CaseNumber,Banco__c,Mensaje_Transaci_n__c,
                  CreatedDate,N_mandato__c,CreatedByid,Fecha_de_Vigencia_de_Tarjeta_Nectia__c,Fecha_Vencimiento_Tarjeta__c,type,Subtipo__c,Tel_fono_de_contacto__c from case where id=:idcas];
        system.debug('cas='+cas);
        string userid=UserInfo.getUserId();
        system.debug('userid'+userid);
        /*user  us=[select id,Codigo_Usuario_Nectia__c  from user where id=:userid];
        system.debug('us='+us);*/
        Producto_del_Cliente__c pro=[select id,Codigo_Plan_Nectia__c,Poliza_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c,Ramo_Nectia__c,L_nea__c
                                     from Producto_del_Cliente__c where id=:cas.Producto_del_Cliente_Nectia__c];
        system.debug('pro='+pro);
         Arbol_Comunicaciones__mdt   arcom;
        try{
           arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c 
                                           FROM Arbol_Comunicaciones__mdt  where   Tipo__c=:cas.type  and Subtipo__c=:cas.Subtipo__c 
                                            and Estado_del_caso__c=:'Nuevo' and Linea_de_negocio__c=:pro.L_nea__c limit 1];
        system.debug('arcom='+arcom);
        }catch(Exception e){
            arcom=null;
        }


        CONS_EndosoComunicaciones_JSON  ed=new CONS_EndosoComunicaciones_JSON();
        ed.nCelular=(cas.Tel_fono_de_contacto__c==null?'':cas.Tel_fono_de_contacto__c);   //opcional
        ed.nNumMandato=(cas.N_mandato__c==null?'':cas.N_mandato__c);         //opcional
        ed.nNumpoliza=pro.Poliza_Nectia__c;                                            //Obligatorio
        ed.nNumsolicitud=string.valueOf(integer.valueOf(cas.CaseNumber));               //Obligatorio
        ed.nResolucionCaso='';              //opcional
        ed.nTelefonoEjec='';                 //opcional
        ed.sBanco=cas.Banco__c;               //Obligatorio
        ed.sDoc_Adjunto='';                              //opcional
        ed.sEmail=cas.Account.PersonEmail;               //opcional
        ed.sFechaCierre='';                              //opcional
        ed.sFechaEfectivaEndoso='';                      //opcional
        DateTime d = cas.CreatedDate ;
        String dateStr =  d.format('dd-MM-yyyy') ;
        ed.sFechaRecepcion=dateStr;                     //opcional
        if(arcom!=null){
        ed.sLinNegocio= arcom.Linea_de_negocio__c;    //Obligatorio
        ed.nNegocio=arcom.Numero_Linea__c;            //Obligatorio
         ed.sPlantilla=arcom.Plantilla__c;            //Obligatorio
        }else{
           ed.sLinNegocio='';       //Obligatorio
        ed.nNegocio='';             //Obligatorio
         ed.sPlantilla='';          //Obligatorio
        }
        ed.sMailEjecutivo='';            //opcional
        ed.sMotivoRechazo='';          //opcional
        ed.sNomEjecutivo='';          //opcional
        ed.sNombcaso=cas.Type+'-'+cas.Subtipo__c;       //Obligatorio
        ed.sNombreCliente=cas.Account.Name;     //Obligatorio
       
        string envio =JSON.serialize(ed);
        system.debug('envio estructura salesforce= '+envio);
        /* envio='{'+
'"nCelular":"999999",'+
'"nNumMandato":"",'+
'"nNumpoliza":"12345",'+
'"nNumsolicitud":"435",'+
'"nResolucionCaso":"",'+
'"nTelefonoEjec":"",'+
'"sBanco":"",'+
'"sDoc_Adjunto":"",'+
'"sEmail":"dgaticapizarro@gmail.com",'+
'"sFechaCierre":"",'+
'"sFechaEfectivaEndoso":"",'+
'"sFechaRecepcion":"20-01-2019",'+
'"sLinNegocio":"1",'+
'"nNegocio":"1",'+
'"sMailEjecutivo":"dgaticapizarro@gmail.com",'+
'"sMotivoRechazo":"",'+
'"sNomEjecutivo":"",'+
'"sNombcaso":"caso 1",'+
'"sNombreCliente":"Diego",'+
'"sPlantilla":"PLA0000011"'+
'}';*/
        Cons_callOutService  call= new Cons_callOutService();
        string token=call.callOuttoken();
        system.debug('token'+token);
        CONS_token_JSON tok = (CONS_token_JSON)JSON.deserialize(token,CONS_token_JSON.class);  
        system.debug('token=='+tok.access_token);
        string str='';
        if(pro.Esquema_Nectia__c=='INSUDB'){
            if( !test.isrunningtest()){ 
      str=call.callOutEndoso_Comunicaciones_Vida(tok.access_token,envio,null); 
            } 
        }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){
          str= call.callOutEndoso_Comunicaciones_Generales(tok.access_token,envio,null);
        }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){
        //    str= call.callOutEndoso_Comunicaciones_RV(tok.access_token,envio);
                   system.debug('no esxiste servicio disponible');
        }
        system.debug('respuesta del servicio '+str);
        cas.Mensaje_Transaci_n__c=str;
        update cas;
        PageReference p = new PageReference('/'+idcas);
        p.setRedirect(true);
        return null;
        
        
    }
    
    public  PageReference continuar(){
        system.debug('entro a continuar'); 
        PageReference p = new PageReference('/'+idcas);
        p.setRedirect(true);
        return p;
    }
}