public class CONS_Comunicacionescierre  {

	public User tmpUser{get;set;}
    
    @InvocableMethod(label='cierre de caso' description='determina el cierre del caso')
    public static List<String> getproductocliente(List<id> ids) {
        System.debug('ids'+ids);
        System.debug('estoy  en el  metodo  invocable ');
        string idcas=ids[0];
        case cas=[select id, Type,Subtipo__c,Tipo_de_Modificaci_n__c from case where id=:idcas  limit 1];
        System.debug('cas'+cas);
        
        if ((cas.Type=='Reclamo' && 
             (cas.Subtipo__c=='Asociadas a Producción S. Vida' || cas.Subtipo__c=='Reclamos Siniestros S. Vida' ||
              cas.Subtipo__c=='Asociadas a Producción S. Generales' ||
              cas.Subtipo__c=='Sobre Denuncio y Asignación Siniestro'  || cas.Subtipo__c=='Atención de Siniestro de Pérdida Parcial' || 
              cas.Subtipo__c=='Servicio de Asistencia Vehicular' || cas.Subtipo__c=='Atención del Tercero Afectado en Siniestro' || 
              cas.Subtipo__c=='Atención de Siniestro de Pérdida Total' ||cas.Subtipo__c=='Descuento'  || 
              cas.Subtipo__c=='No Pago Pensión') || cas.Subtipo__c == 'Modificación No Efectuada' || 
              cas.Subtipo__c == 'No Gestión Beneficio Estatal' ) || 
            (cas.Type=='Solicitud' && 
             cas.Subtipo__c=='Sobre Denuncio y Asignación Siniestro' ||  cas.Subtipo__c=='Traspaso APV' 
             ||  cas.Subtipo__c=='Devolución Primas' ) ){
                 
                 system.debug('a reclamos');
                 // CONS_Reclamos  rec=new CONS_Reclamos();
                 
                 // rec.continuar(cas.id);
                 Reclamos_Vida_Generales_RV(cas.id);
                 
             }
        
        if (cas.Type=='Solicitud' && cas.Subtipo__c=='Modificación de Póliza' &&(cas.Tipo_de_Modificaci_n__c=='Aumento Capital'
                                                                                 || cas.Tipo_de_Modificaci_n__c=='Beneficiarios' ||cas.Tipo_de_Modificaci_n__c=='Contratante' ||
                                                                                 cas.Tipo_de_Modificaci_n__c=='Plan' || cas.Tipo_de_Modificaci_n__c=='Tipo Fumador' || cas.Tipo_de_Modificaci_n__c=='Ingreso/Modifica Coberturas' ||
                                                                                 cas.Tipo_de_Modificaci_n__c=='Régimen SII (Factura)' || cas.Tipo_de_Modificaci_n__c=='Traspasos Cobertura' || cas.Tipo_de_Modificaci_n__c=='Disminución Capital Asegurado' ||
                                                                                 cas.Tipo_de_Modificaci_n__c=='Elimina Cobertuas' || cas.Tipo_de_Modificaci_n__c=='Regimen Tributario' || cas.Tipo_de_Modificaci_n__c=='Actualización Patente (solo provisoria a definitiva)' ||
                                                                                 cas.Tipo_de_Modificaci_n__c=='Datos Materia Asegurada'  || cas.Tipo_de_Modificaci_n__c=='Frecuencia de Pago' || cas.Tipo_de_Modificaci_n__c=='Refinanciamiento Simple' || cas.Tipo_de_Modificaci_n__c=='Renovación') ){
                                                                                     system.debug('endoso Comunicasiones');
                                                                                     system.debug('a comunicaciones');
                                                                                     //         CONS_Comunicaciones  com=new CONS_Comunicaciones(); 
                                                                                     endosocomunicaciones(cas.id);
                                                                                 }
        if (cas.Type=='Solicitud' && cas.Subtipo__c=='Rescate' ){
            Cierre_Rescate(cas.id);
        }
        
        return null;
    }
    @future (callout=true)
    public static void Reclamos_Vida_Generales_RV(string idcas){
        
        case cas=[select id,Accountid,Account.Name,Account.FirstName,Account.lastName,Producto_del_Cliente_Nectia__c,Status,Rut_del_Cliente__c,Seguros_producto__c,Linea_Producto_Seguros__c,Tel_fono_de_contacto__c,
                  V_a_de_Pago__c,D_a_de_Pago__c,Account.PersonBirthdate,Account.Genero_Nectia__pc,Account.PersonEmail,Tipo_de_cuenta__c,CaseNumber,Banco__c,Mensaje_Transaci_n__c,
                  CreatedDate,N_mandato__c,CreatedByid,Fecha_de_Vigencia_de_Tarjeta_Nectia__c,Subtipo__c,Nueva_Instituci_n__c,type,SlaStartDate,IdDocumentoDocuware__c,
                  Fecha_Vencimiento_Tarjeta__c,Sub_estado_Nectia__c,Forma_de_Pago__c,Account.PersonMobilePhone,Clasificaci_n_de_Solicitud__c from case where id=:idcas];
        
        system.debug('cas='+cas);
        string userid=UserInfo.getUserId();
        system.debug('userid'+userid);
        user  us=[select id,Codigo_Usuario_Nectia__c  from user where id=:userid];
        system.debug('us='+us);
        
        Producto_del_Cliente__c pro=[select id,Codigo_Plan_Nectia__c,Poliza_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c,Ramo_Nectia__c,L_nea__c
                                     from Producto_del_Cliente__c where id=:cas.Producto_del_Cliente_Nectia__c];
        
        
        Arbol_Comunicaciones__mdt   arcom;
        
        try{
            
            if (cas.Type=='Solicitud'){
                
                if (cas.Clasificaci_n_de_Solicitud__c != 'Cambio de Liquidador Asignado'){
                    arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c,Clasificacion__c FROM Arbol_Comunicaciones__mdt  where  Tipo__c=:cas.type  and Subtipo__c=:cas.Subtipo__c  and Estado_del_caso__c=:cas.Status AND Linea_de_negocio__c=:pro.L_nea__c AND Clasificacion__c=: cas.Forma_de_Pago__c limit 1];
                    system.debug('arcom solicitud ->'+arcom);
                }else{
                    arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c,Clasificacion__c FROM Arbol_Comunicaciones__mdt  where  Tipo__c=:cas.type  and Subtipo__c=:cas.Subtipo__c  and Estado_del_caso__c=:cas.Status AND Linea_de_negocio__c=:pro.L_nea__c AND Clasificacion__c=: cas.Clasificaci_n_de_Solicitud__c limit 1];
                    system.debug('arcom cambio de liqudador asignado ->'+arcom);
                }
                
                
            }else if (cas.Type=='Reclamo'){
                
                arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c FROM Arbol_Comunicaciones__mdt  where   Tipo__c=:cas.type  and Subtipo__c=:cas.Subtipo__c  and Estado_del_caso__c=:cas.Status limit 1];
                system.debug('arcom reclamo'+arcom);
                /*            }else if(cas.Sub_estado_Nectia__c!=null &&  cas.Sub_estado_Nectia__c!=''  &&  cas.Sub_estado_Nectia__c!='Solucionado'){
arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c 
FROM Arbol_Comunicaciones__mdt  where   Tipo__c=:cas.type  and 
Subtipo__c=:cas.Subtipo__c  and Estado_del_caso__c=:cas.Status  and Subestado_del_caso__c=:cas.Sub_estado_Nectia__c  limit 1];
system.debug('arcom2'+arcom);
system.debug('cuando solo es estado cerrado y no existe Sub_estado_Nectia__c');
}else{
arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c 
FROM Arbol_Comunicaciones__mdt  where   Tipo__c=:cas.type  and 
Subtipo__c=:cas.Subtipo__c  and Estado_del_caso__c=:cas.Status   limit 1];
system.debug('arcom3'+arcom);}*/
            }
            
        }catch(Exception e){
            system.debug('estructura no encontrada');
            arcom=null;
        }
        
        system.debug('pro='+pro);
        CONS_EnvioReclamos_JSON  j=new CONS_EnvioReclamos_JSON();
        j.nCelular=(cas.Account.PersonMobilePhone==null?'':cas.Account.PersonMobilePhone);
        j.nMandato=(cas.N_mandato__c==null?'':cas.N_mandato__c);
        j.nNumpoliza=(pro.Poliza_Nectia__c==null?'':pro.Poliza_Nectia__c);
        j.nNumsolicitud=string.valueOf(integer.valueOf(cas.CaseNumber));
        j.sResolucionCaso='';
        j.nTelefonoEjec='';
        j.sBanco=(cas.Banco__c==null?'':cas.Banco__c);
        j.sDoc_Adjunto=(cas.IdDocumentoDocuware__c==null?'':cas.IdDocumentoDocuware__c);
        j.sEmail=(cas.Account.PersonEmail==null?'':cas.Account.PersonEmail);
        DateTime d1 = cas.CreatedDate ;
        if (d1 != null){
            String dateStr1 =  d1.format('dd-MM-yyyy') ;
            j.sFechaCierre=dateStr1;
        }else{
            j.sFechaCierre='';
        }
        
        j.sNombreLiquidador='test';
        j.sNombreTaller='test';  
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
        
        Cons_callOutService  call= new Cons_callOutService();
        String token;
        
        if (!Test.isRunningTest()){
            token = call.callOuttoken();
        }else{
            token = '{"access_token": "eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiI5MjczMDE2Zi0yODZiLTRhZDUtYTg3Ni1hMzk5ZGY3NzUwNjIiLCJleHAiOjE1NTQ3OTg1NzYsIm5iZiI6MCwiaWF0IjoxNTU0Nzk3Njc2LCJpc3MiOiJodHRwczovL2Rlc2Fycm9sbG8uY29uc29yY2lvLmNsL2F1dGgvcmVhbG1zL0NSTSIsImF1ZCI6InNmLWNybSIsInN1YiI6IjIyY2Q3YmY0LTI2MTItNDIzYy05MGU1LTlkNGQ4YjdhMzEwMyIsInR5cCI6IkJlYXJlciIsImF6cCI6InNmLWNybSIsInNlc3Npb25fc3RhdGUiOiJmYWViYmMyNi1hNjc3LTQ3ZGYtYTYwNS05NDg2NTYxM2U3NjMiLCJjbGllbnRfc2Vzc2lvbiI6ImE2NmE5MDc2LWQ2OTktNDg5OC1hMzY4LWJiNzg5YWE5NDJlMiIsImFsbG93ZWQtb3JpZ2lucyI6WyJodHRwczovL2JhbmNvY29uc29yY2lvLS1QYXJjaWFsQ05TLmNzOTMubXkuc2FsZXNmb3JjZS5jb20iXSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJ2aWV3LXByb2ZpbGUiXX19LCJuYW1lIjoiRXh0ZXJubyBOZWN0aWEgMDMgTmVjdGlhIDAzIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiZXhuZWN0MDMiLCJnaXZlbl9uYW1lIjoiRXh0ZXJubyBOZWN0aWEgMDMiLCJmYW1pbHlfbmFtZSI6Ik5lY3RpYSAwMyIsImVtYWlsIjoiZXh0ZXJuby5uZWN0aWEwM0Bjb25zb3JjaW8uY2wifQ.ari-pr_7lZOu04TPneORslTSYI1RpOMCPk-QTp0byOlteLD-HMGQoCyjnjblxgrI0U2ktHZBv_kbE5xn5DpqBaNXdX5FgtNtAxqKsM0SV_K-pjKq-mH19WG5i_8p8BeBxbXYJyy6bgZyovlJNz6uENYyu5EQ5m53xSXyxuusne72bRGaNP3C0WIWMeZ1W-UI-f76_5N_UoXa8z0d4pIOul8HXX8piqXk0f5bkoLZnBDWeb7Ug1tk54j5yHbWKhBbXaLnVUmWv9sOGqhZ1aP_qKSlkjpGphL2EmJYQIJYdJEGHZkfBOcWUzGWYf-n9oAIXlCgQUkl2Tpx60QzyS7ynQ","expires_in": 900,"refresh_expires_in": 1800,"refresh_token": "eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiIwNGU1OGU4ZC01NjZhLTQzOTEtYjMyNi05ODhlNzU5Y2QyYTgiLCJleHAiOjE1NTQ3OTk0NzYsIm5iZiI6MCwiaWF0IjoxNTU0Nzk3Njc2LCJpc3MiOiJodHRwczovL2Rlc2Fycm9sbG8uY29uc29yY2lvLmNsL2F1dGgvcmVhbG1zL0NSTSIsImF1ZCI6InNmLWNybSIsInN1YiI6IjIyY2Q3YmY0LTI2MTItNDIzYy05MGU1LTlkNGQ4YjdhMzEwMyIsInR5cCI6IlJlZnJlc2giLCJhenAiOiJzZi1jcm0iLCJzZXNzaW9uX3N0YXRlIjoiZmFlYmJjMjYtYTY3Ny00N2RmLWE2MDUtOTQ4NjU2MTNlNzYzIiwiY2xpZW50X3Nlc3Npb24iOiJhNjZhOTA3Ni1kNjk5LTQ4OTgtYTM2OC1iYjc4OWFhOTQyZTIiLCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsInZpZXctcHJvZmlsZSJdfX19.BE07lVl_UYaNCyGqRc16IMBql9HLEotahYy42j9GpnmSZzpQCR9AYzcB33o1MvzZVGrAJ5v82aQqVMtcI434s_NewCPURp6jIjwjqNZ7R_FnKVpOh6JPmkrpOlsUHPsMt31UD09NFQ9vcaMlYx5wrShRLEblXvCyUDkPYA6NIG9gNgxJ3ah-TturXz-J0T4hhA7yD0rQ0deqgg7T5V4oojp9GeGMazQGccWQrTkVFJmRjbQjbyO4jNDnnGCxIM71krRrli6gKkj_V54l8ALfcrioP-dTznCLQ3WHcl3oA9uIS0_mqF4sfwvmigy1PvFAB6utgiPF0zFSSAEOpfwORw","token_type": "bearer","id_token": "eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiJkMjA1MmE4YS00NGNlLTQ0N2MtYjQwZC1lNzYxYmNmZWJhNWQiLCJleHAiOjE1NTQ3OTg1NzYsIm5iZiI6MCwiaWF0IjoxNTU0Nzk3Njc2LCJpc3MiOiJodHRwczovL2Rlc2Fycm9sbG8uY29uc29yY2lvLmNsL2F1dGgvcmVhbG1zL0NSTSIsImF1ZCI6InNmLWNybSIsInN1YiI6IjIyY2Q3YmY0LTI2MTItNDIzYy05MGU1LTlkNGQ4YjdhMzEwMyIsInR5cCI6IklEIiwiYXpwIjoic2YtY3JtIiwic2Vzc2lvbl9zdGF0ZSI6ImZhZWJiYzI2LWE2NzctNDdkZi1hNjA1LTk0ODY1NjEzZTc2MyIsIm5hbWUiOiJFeHRlcm5vIE5lY3RpYSAwMyBOZWN0aWEgMDMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJleG5lY3QwMyIsImdpdmVuX25hbWUiOiJFeHRlcm5vIE5lY3RpYSAwMyIsImZhbWlseV9uYW1lIjoiTmVjdGlhIDAzIiwiZW1haWwiOiJleHRlcm5vLm5lY3RpYTAzQGNvbnNvcmNpby5jbCJ9.G8Pto2vQC8Bs9eFPEtCHGEFWiuW7ehOrsEWJY-yKt0_st8pViXgoma7D88x3ybzSZYjUa_jfmPz3cDRgJTqxijxqWKr1NT1EiNXKppFEJeyShr1S7vEi9BcdTh2lyRPjqsiEXvBj5fvRhbx5IywNmQPJAy74iZmB5K6ENcoxexTIsrGC-L89Tkxhpyhm5CfHv6VhkBdbUImU3FrhOEcBTvUN8OpxoYr2qYsgHLJab5P1iWo8p-mPJxweUBvgZ3x2WLKXL1_woB8APWWDjSoE7yIFdF1JjQvkvvekmM3zXa-xub82OuWSq3M6PUOH2zPx6WZDprVgAZCXcJvtbM62FQ","not-before-policy": 0,"session_state": "faebbc26-a677-47df-a605-94865613e763"}';
        }
        system.debug('token'+token);

        User tmpUser;
        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];
        
        CONS_token_JSON tok = (CONS_token_JSON)JSON.deserialize(token,CONS_token_JSON.class);  
        system.debug('token=='+tok.access_token);
        string str='';
        if(pro.Esquema_Nectia__c=='INSUDB'){

            str=call.callOutReclamos_Vida(tok.access_token,envio,tmpUser);
            
        }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){

            str= call.callOutReclamos_Generales(tok.access_token,envio,tmpUser);

        }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){

            str= call.callOutReclamos_RV(tok.access_token,envio,tmpUser);
        }
        system.debug('respuesta del servicio '+str);
        //------------------------------   estructura  para  alerta pin cierre --------------------------------------------
        if(cas.Subtipo__c=='Traspaso APV'){
            system.debug('entrpo a  alerta pin cierre');
            DateTime fecha = system.now();
            String fechacierre = fecha.format('dd-MM-yyyy');
            CONS_AlertaPinCierre_JSON  apc=new CONS_AlertaPinCierre_JSON();
            apc.nNumCaso=string.valueOf(integer.valueOf(cas.CaseNumber));
            apc.nPoliza=(pro.Poliza_Nectia__c==null?'':pro.Poliza_Nectia__c);
            apc.sFechaCierre=fechacierre;
            apc.sEstado='RESOL';
            string estructura_cierre =JSON.serialize(apc);
            system.debug('envio alerta pin'+envio);

            string resp=call.callOutAlertaPin_Cierre(tok.access_token, estructura_cierre,tmpUser);

            system.debug('resp alerta pin'+resp); 
        }else{
           system.debug('no cumple con subtipo  para  alerta pin (solo puede ser Traspaso APV ) sub tipo ='+cas.Subtipo__c);  
        }
        
        //----------------------------- ---------------------------------------------------------------------------------------
        if(!str.contains('ERROR -')){
            CONS_respuestaservicio_JSON res = (CONS_respuestaservicio_JSON)JSON.deserialize(str,CONS_respuestaservicio_JSON.class);  
            system.debug('mensage del servicio == '+res.mensaje); 
            if(res.codigo=='0'){
                cas.Mensaje_Transaci_n__c=res.mensaje; 
            }else{
                if(res.RespuestaBase!=null){
                    cas.Mensaje_Transaci_n__c=res.RespuestaBase.mensaje; 
                }else{
                    cas.Mensaje_Transaci_n__c=res.mensaje; 
                }
                if(res.respuestaEmailmatico!=null){
                    cas.Mensaje_Transaci_n__c=cas.Mensaje_Transaci_n__c+ '/n '+res.respuestaEmailmatico.mensaje; 
                }
            }
        }else{
            cas.Mensaje_Transaci_n__c=str;
        }
        update cas;
    }
    
    @future (callout=true)
    public static void endosocomunicaciones(string idcas){
        system.debug('endoso comunicaciones'); 
        case cas=[select id,Accountid,Account.Name,Account.FirstName,Account.lastName,Producto_del_Cliente_Nectia__c,Rut_del_Cliente__c,Seguros_producto__c,Linea_Producto_Seguros__c,
                  V_a_de_Pago__c,D_a_de_Pago__c,Account.PersonBirthdate,Account.Genero_Nectia__pc,Account.PersonEmail,Tipo_de_cuenta__c,CaseNumber,Banco__c,Mensaje_Transaci_n__c,IdDocumentoDocuware__c,
                  CreatedDate,N_mandato__c,CreatedByid,Fecha_de_Vigencia_de_Tarjeta_Nectia__c,Fecha_Vencimiento_Tarjeta__c,type,Subtipo__c,Tel_fono_de_contacto__c from case where id=:idcas];
        system.debug('cas='+cas);
        string userid=UserInfo.getUserId();
        system.debug('userid'+userid);
        user  us=[select id,Codigo_Usuario_Nectia__c  from user where id=:userid];
        system.debug('us='+us);
        
        Producto_del_Cliente__c pro=[select id,Codigo_Plan_Nectia__c,Poliza_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c,Ramo_Nectia__c
                                     from Producto_del_Cliente__c where id=:cas.Producto_del_Cliente_Nectia__c];
        system.debug('pro='+pro);
        Arbol_Comunicaciones__mdt   arcom;
        try{
            arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c 
                   FROM Arbol_Comunicaciones__mdt  where   Tipo__c=:cas.type  and Subtipo__c=:cas.Subtipo__c limit 1];
            system.debug('arcom='+arcom);
        }catch(Exception e){
            arcom=null;
        }
        CONS_EndosoComunicaciones_JSON  ed=new CONS_EndosoComunicaciones_JSON();
        ed.nCelular=(cas.Tel_fono_de_contacto__c==null?'':cas.Tel_fono_de_contacto__c);
        ed.nNumMandato=(cas.N_mandato__c==null?'':cas.N_mandato__c);
        ed.nNumpoliza=pro.Poliza_Nectia__c;
        ed.nNumsolicitud=string.valueOf(integer.valueOf(cas.CaseNumber));
        ed.nResolucionCaso='';
        ed.nTelefonoEjec='';
        ed.sBanco=cas.Banco__c;
        ed.sDoc_Adjunto=(cas.IdDocumentoDocuware__c==null?'':cas.IdDocumentoDocuware__c);
        ed.sEmail=cas.Account.PersonEmail;
        ed.sFechaCierre='';
        ed.sFechaEfectivaEndoso='';
        DateTime d = cas.CreatedDate ;
        String dateStr =  d.format('dd-MM-yyyy') ;
        ed.sFechaRecepcion=dateStr;
        if(arcom!=null){
            ed.sLinNegocio= arcom.Linea_de_negocio__c;
            ed.nNegocio=arcom.Numero_Linea__c;
            ed.sPlantilla=arcom.Plantilla__c;
        }else{
            ed.sLinNegocio='';
            ed.nNegocio='';
            ed.sPlantilla='';  
        }
        ed.sMailEjecutivo='';
        ed.sMotivoRechazo='';
        ed.sNomEjecutivo='';
        ed.sNombcaso=cas.Type+'-'+cas.Subtipo__c;
        ed.sNombreCliente=cas.Account.Name;
        
        string envio =JSON.serialize(ed);
        system.debug('envio estructura salesforce= '+envio);
        
        Cons_callOutService  call= new Cons_callOutService();
        String token;
        
        if (!Test.isRunningTest()){
            token = call.callOuttoken();
        }else{
            token = '{"access_token": "eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiI5MjczMDE2Zi0yODZiLTRhZDUtYTg3Ni1hMzk5ZGY3NzUwNjIiLCJleHAiOjE1NTQ3OTg1NzYsIm5iZiI6MCwiaWF0IjoxNTU0Nzk3Njc2LCJpc3MiOiJodHRwczovL2Rlc2Fycm9sbG8uY29uc29yY2lvLmNsL2F1dGgvcmVhbG1zL0NSTSIsImF1ZCI6InNmLWNybSIsInN1YiI6IjIyY2Q3YmY0LTI2MTItNDIzYy05MGU1LTlkNGQ4YjdhMzEwMyIsInR5cCI6IkJlYXJlciIsImF6cCI6InNmLWNybSIsInNlc3Npb25fc3RhdGUiOiJmYWViYmMyNi1hNjc3LTQ3ZGYtYTYwNS05NDg2NTYxM2U3NjMiLCJjbGllbnRfc2Vzc2lvbiI6ImE2NmE5MDc2LWQ2OTktNDg5OC1hMzY4LWJiNzg5YWE5NDJlMiIsImFsbG93ZWQtb3JpZ2lucyI6WyJodHRwczovL2JhbmNvY29uc29yY2lvLS1QYXJjaWFsQ05TLmNzOTMubXkuc2FsZXNmb3JjZS5jb20iXSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJ2aWV3LXByb2ZpbGUiXX19LCJuYW1lIjoiRXh0ZXJubyBOZWN0aWEgMDMgTmVjdGlhIDAzIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiZXhuZWN0MDMiLCJnaXZlbl9uYW1lIjoiRXh0ZXJubyBOZWN0aWEgMDMiLCJmYW1pbHlfbmFtZSI6Ik5lY3RpYSAwMyIsImVtYWlsIjoiZXh0ZXJuby5uZWN0aWEwM0Bjb25zb3JjaW8uY2wifQ.ari-pr_7lZOu04TPneORslTSYI1RpOMCPk-QTp0byOlteLD-HMGQoCyjnjblxgrI0U2ktHZBv_kbE5xn5DpqBaNXdX5FgtNtAxqKsM0SV_K-pjKq-mH19WG5i_8p8BeBxbXYJyy6bgZyovlJNz6uENYyu5EQ5m53xSXyxuusne72bRGaNP3C0WIWMeZ1W-UI-f76_5N_UoXa8z0d4pIOul8HXX8piqXk0f5bkoLZnBDWeb7Ug1tk54j5yHbWKhBbXaLnVUmWv9sOGqhZ1aP_qKSlkjpGphL2EmJYQIJYdJEGHZkfBOcWUzGWYf-n9oAIXlCgQUkl2Tpx60QzyS7ynQ","expires_in": 900,"refresh_expires_in": 1800,"refresh_token": "eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiIwNGU1OGU4ZC01NjZhLTQzOTEtYjMyNi05ODhlNzU5Y2QyYTgiLCJleHAiOjE1NTQ3OTk0NzYsIm5iZiI6MCwiaWF0IjoxNTU0Nzk3Njc2LCJpc3MiOiJodHRwczovL2Rlc2Fycm9sbG8uY29uc29yY2lvLmNsL2F1dGgvcmVhbG1zL0NSTSIsImF1ZCI6InNmLWNybSIsInN1YiI6IjIyY2Q3YmY0LTI2MTItNDIzYy05MGU1LTlkNGQ4YjdhMzEwMyIsInR5cCI6IlJlZnJlc2giLCJhenAiOiJzZi1jcm0iLCJzZXNzaW9uX3N0YXRlIjoiZmFlYmJjMjYtYTY3Ny00N2RmLWE2MDUtOTQ4NjU2MTNlNzYzIiwiY2xpZW50X3Nlc3Npb24iOiJhNjZhOTA3Ni1kNjk5LTQ4OTgtYTM2OC1iYjc4OWFhOTQyZTIiLCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsInZpZXctcHJvZmlsZSJdfX19.BE07lVl_UYaNCyGqRc16IMBql9HLEotahYy42j9GpnmSZzpQCR9AYzcB33o1MvzZVGrAJ5v82aQqVMtcI434s_NewCPURp6jIjwjqNZ7R_FnKVpOh6JPmkrpOlsUHPsMt31UD09NFQ9vcaMlYx5wrShRLEblXvCyUDkPYA6NIG9gNgxJ3ah-TturXz-J0T4hhA7yD0rQ0deqgg7T5V4oojp9GeGMazQGccWQrTkVFJmRjbQjbyO4jNDnnGCxIM71krRrli6gKkj_V54l8ALfcrioP-dTznCLQ3WHcl3oA9uIS0_mqF4sfwvmigy1PvFAB6utgiPF0zFSSAEOpfwORw","token_type": "bearer","id_token": "eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiJkMjA1MmE4YS00NGNlLTQ0N2MtYjQwZC1lNzYxYmNmZWJhNWQiLCJleHAiOjE1NTQ3OTg1NzYsIm5iZiI6MCwiaWF0IjoxNTU0Nzk3Njc2LCJpc3MiOiJodHRwczovL2Rlc2Fycm9sbG8uY29uc29yY2lvLmNsL2F1dGgvcmVhbG1zL0NSTSIsImF1ZCI6InNmLWNybSIsInN1YiI6IjIyY2Q3YmY0LTI2MTItNDIzYy05MGU1LTlkNGQ4YjdhMzEwMyIsInR5cCI6IklEIiwiYXpwIjoic2YtY3JtIiwic2Vzc2lvbl9zdGF0ZSI6ImZhZWJiYzI2LWE2NzctNDdkZi1hNjA1LTk0ODY1NjEzZTc2MyIsIm5hbWUiOiJFeHRlcm5vIE5lY3RpYSAwMyBOZWN0aWEgMDMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJleG5lY3QwMyIsImdpdmVuX25hbWUiOiJFeHRlcm5vIE5lY3RpYSAwMyIsImZhbWlseV9uYW1lIjoiTmVjdGlhIDAzIiwiZW1haWwiOiJleHRlcm5vLm5lY3RpYTAzQGNvbnNvcmNpby5jbCJ9.G8Pto2vQC8Bs9eFPEtCHGEFWiuW7ehOrsEWJY-yKt0_st8pViXgoma7D88x3ybzSZYjUa_jfmPz3cDRgJTqxijxqWKr1NT1EiNXKppFEJeyShr1S7vEi9BcdTh2lyRPjqsiEXvBj5fvRhbx5IywNmQPJAy74iZmB5K6ENcoxexTIsrGC-L89Tkxhpyhm5CfHv6VhkBdbUImU3FrhOEcBTvUN8OpxoYr2qYsgHLJab5P1iWo8p-mPJxweUBvgZ3x2WLKXL1_woB8APWWDjSoE7yIFdF1JjQvkvvekmM3zXa-xub82OuWSq3M6PUOH2zPx6WZDprVgAZCXcJvtbM62FQ","not-before-policy": 0,"session_state": "faebbc26-a677-47df-a605-94865613e763"}';
        }
        system.debug('token'+token);
        
        CONS_token_JSON tok = (CONS_token_JSON)JSON.deserialize(token,CONS_token_JSON.class);  
        system.debug('token=='+tok.access_token);
        string str='';

		User tmpUser;
		tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];

        if(pro.Esquema_Nectia__c=='INSUDB'){
            
            str=call.callOutEndoso_Comunicaciones_Vida(tok.access_token,envio,tmpUser);

        }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){

            str= call.callOutEndoso_Comunicaciones_Generales(tok.access_token,envio,tmpUser);

        }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){

            cas.Mensaje_Transaci_n__c='no esxiste servicio disponible';
            system.debug('no esxiste servicio disponible');
        }
        system.debug('respuesta del servicio '+str);
        cas.Mensaje_Transaci_n__c=str;
        update cas;
        
        
        
        
    }
    
    @future (callout=true)
    public static void Cierre_Rescate(string idcas){
        
        case cas=[select id,Accountid,Account.Name,Account.FirstName,Account.lastName,Producto_del_Cliente_Nectia__c,Status,Rut_del_Cliente__c,Seguros_producto__c,
                  Linea_Producto_Seguros__c,Tel_fono_de_contacto__c,V_a_de_Pago__c,Sub_estado_Nectia__c,D_a_de_Pago__c,Account.PersonBirthdate,Account.Genero_Nectia__pc,
                  Account.PersonEmail,Tipo_de_cuenta__c,CaseNumber,Banco__c,Mensaje_Transaci_n__c,Account.PersonMobilePhone,IdDocumentoDocuware__c,
                  CreatedDate,N_mandato__c,Monto_UF__c,Forma_de_Pago__c,CreatedByid,Fecha_de_Vigencia_de_Tarjeta_Nectia__c,Subtipo__c,type,SlaStartDate,
                  Fecha_Vencimiento_Tarjeta__c,Nueva_Instituci_n__c from case where id=:idcas];
        system.debug('cas='+cas);
        Producto_del_Cliente__c pro=[select id,Codigo_Plan_Nectia__c,Poliza_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c,Ramo_Nectia__c,L_nea__c
                                     from Producto_del_Cliente__c where id=:cas.Producto_del_Cliente_Nectia__c];
        
        String linea;
        if (pro.L_nea__c == 'Rentas Vitalicias' || pro.L_nea__c == 'Colectivos' || pro.L_nea__c == 'FFMM'){
            linea = 'Vida';
        }else{
            linea = pro.L_nea__c;
        }
        system.debug('linea nueva->'+linea);
        
        Arbol_Comunicaciones__mdt   arcom;
        if (cas.Producto_del_Cliente_Nectia__c != null){ // si tiene producto
            arcom = [SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c 
                     FROM Arbol_Comunicaciones__mdt  
                     where   Tipo__c='Solicitud'  and Subtipo__c='Rescate' and Estado_del_caso__c='Cerrado'  and Clasificacion__c =: cas.Forma_de_Pago__c limit 1];
        }
        
        system.debug('pro='+pro);
        DateTime fc = system.now();
        String Fechacierre =  fc.format('dd-MM-yyyy') ;
        CONS_EstructuraRescateCierre_JSON.DatosAlarma  DA=new CONS_EstructuraRescateCierre_JSON.DatosAlarma();
        DA.nNumCaso=cas.CaseNumber;
        DA.nPoliza=pro.Poliza_Nectia__c;
        DA.sFechaCierre=Fechacierre;
        
        if(cas.Sub_estado_Nectia__c=='Solucionado'){
            DA.sEstado='SOLU';  
        }else{
            DA.sEstado='PENDE';
        }
        CONS_EstructuraRescateCierre_JSON.DatosEmail  DE=new CONS_EstructuraRescateCierre_JSON.DatosEmail();
        DE.nCelular=cas.Account.PersonMobilePhone;
        DE.nNegocio='1';
        DE.nNumpoliza=pro.Poliza_Nectia__c;
        DE.nNumsolicitud=cas.CaseNumber;
        DE.nMontoRescate=string.valueOf(cas.Monto_UF__c);
        DE.nNumRescate='';
        DE.sLinNegocio=arcom.Numero_Linea__c;
        DE.sNombreCliente=cas.Account.Name;
        DE.sEmail=cas.Account.PersonEmail;
        DE.sFechaRecepcion=Fechacierre;
        DE.sNombcaso=cas.Type+'-'+cas.Subtipo__c;
        DE.sNombreProducto='';
        DE.sDoc_Adjunto=(cas.IdDocumentoDocuware__c==null?'':cas.IdDocumentoDocuware__c);
        DE.sTipoPago='';
        DE.sBancoRescate='';
        DE.sDestinoChequeRescate='';
        DE.sCuentaDepositoRescate='';
        DE.sPlantilla=arcom.Plantilla__c;
        DE.sNombreSucursal='';
        CONS_EstructuraRescateCierre_JSON  ERC=new CONS_EstructuraRescateCierre_JSON();
        ERC.DatosAlarma=DA;
        ERC.DatosEmail=DE;
        string estructuraentrada =JSON.serialize(ERC);
        

		User tmpUser;
		tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];
        
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);
        
        Cons_callOutService  call= new Cons_callOutService();
        string str='';
        if(pro.Esquema_Nectia__c=='INSUDB'){

            str=call.callOutRescate_Cierre_Vida(access_token,estructuraentrada,tmpUser);
            
        }else {
            system.debug('no existe servicio disponible aun ');
        }
        
        
    }  
    
    @future (callout=true)
    public static void Reclamos_21dias(string idcas){
        
        case cas=[select id,Accountid,Account.Name,Account.FirstName,Account.lastName,Producto_del_Cliente_Nectia__c,Status,Rut_del_Cliente__c,Seguros_producto__c,Linea_Producto_Seguros__c,Tel_fono_de_contacto__c,
                  V_a_de_Pago__c,D_a_de_Pago__c,Account.PersonBirthdate,Account.Genero_Nectia__pc,Account.PersonEmail,Tipo_de_cuenta__c,CaseNumber,Banco__c,Mensaje_Transaci_n__c,Account.PersonMobilePhone,IdDocumentoDocuware__c,
                  CreatedDate,N_mandato__c,CreatedByid,Fecha_de_Vigencia_de_Tarjeta_Nectia__c,Subtipo__c,type,SlaStartDate,Fecha_Vencimiento_Tarjeta__c,Nueva_Instituci_n__c from case where id=:idcas];
        system.debug('cas='+cas);
        Producto_del_Cliente__c pro=[select id,Codigo_Plan_Nectia__c,Poliza_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c,Ramo_Nectia__c,L_nea__c
                                     from Producto_del_Cliente__c where id=:cas.Producto_del_Cliente_Nectia__c];
        
        String linea;
        if (pro.L_nea__c == 'Rentas Vitalicias' || pro.L_nea__c == 'Colectivos' || pro.L_nea__c == 'FFMM'){
            linea = 'Vida';
        }else{
            linea = pro.L_nea__c;
        }
        system.debug('linea nueva->'+linea);
        
        Arbol_Comunicaciones__mdt   arcom;
        if (cas.Producto_del_Cliente_Nectia__c != null){ // si tiene producto
            arcom = [SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c FROM Arbol_Comunicaciones__mdt  where   Tipo__c='21 dias'  and Subtipo__c='21 dias' and Linea_de_negocio__c =: linea limit 1];
        }else{ // sin producto
            // no aplica
            //arcom = [SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c FROM Arbol_Comunicaciones__mdt  where   Tipo__c='21 dias'  and Subtipo__c='21 dias' and Linea_de_negocio__c =:  limit 1];
        }
        
        
        /*Arbol_Comunicaciones__mdt   arcom;
try{
system.debug('try casos');
if(cas.Status!='Cerrado'){
arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c 
FROM Arbol_Comunicaciones__mdt  where   Tipo__c=:cas.type  and Subtipo__c=:cas.Subtipo__c  and Estado_del_caso__c=:cas.Status limit 1];
system.debug('arcom1'+arcom);
}else if(cas.Sub_estado_Nectia__c!=null &&  cas.Sub_estado_Nectia__c!=''){
arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c 
FROM Arbol_Comunicaciones__mdt  where   Tipo__c='21 dias'  and 
Subtipo__c='21 dias'   limit 1];
system.debug('arcom2'+arcom);
}else{
system.debug('estructura  no encontrada ');
arcom=null;
}

}catch(Exception e){
system.debug('catch error');
arcom=null;
}*/
        
        system.debug('pro='+pro);
        CONS_EnvioReclamos_JSON  j=new CONS_EnvioReclamos_JSON();
        j.nCelular=(cas.Account.PersonMobilePhone==null?'':cas.Account.PersonMobilePhone);
        j.nMandato=(cas.N_mandato__c==null?'':cas.N_mandato__c);
        j.nNumpoliza=(pro.Poliza_Nectia__c==null?'':pro.Poliza_Nectia__c);
        j.nNumsolicitud=string.valueOf(integer.valueOf(cas.CaseNumber));
        j.sResolucionCaso='';
        j.nTelefonoEjec='';
        j.sBanco=(cas.Banco__c==null?'':cas.Banco__c);
        j.sDoc_Adjunto=(cas.IdDocumentoDocuware__c==null?'':cas.IdDocumentoDocuware__c);
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
        
        String nombre = (cas.Type!=''?cas.Type:'') + '-' + (cas.Subtipo__c!=''?cas.Subtipo__c:'');
        System.debug('nombre->'+nombre);
        j.sNombcaso=nombre;
        
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
        
        User tmpUser;
        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];
        
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);
        
        Cons_callOutService  call= new Cons_callOutService();
        string str='';
        if(pro.Esquema_Nectia__c=='INSUDB'){

            str=call.callOutReclamos_Vida(access_token,envio,tmpUser);
            
        }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){

            str= call.callOutReclamos_Generales(access_token,envio,tmpUser);

        }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){

            str= call.callOutReclamos_RV(access_token,envio,tmpUser);

        }
        system.debug('respuesta del servicio '+str);
        
        cas.Mensaje_Transaci_n__c='solicitud de 21 dias';
        
        update cas;
        
    }  
    
    
  
}