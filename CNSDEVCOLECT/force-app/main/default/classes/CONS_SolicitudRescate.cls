public class CONS_SolicitudRescate {
    public String idcas{get;set;}
    public String Naut{get;set;}
    public User tmpUser{get;set;}

    public CONS_SolicitudRescate() {
        
        idcas = ApexPages.currentPage().getParameters().get('id');
        Naut = ApexPages.currentPage().getParameters().get('Naut');
        
        
    }
    
    public PageReference  solicitud_rescate(){
        
        case cas=[select id,Rut__c,Accountid,Account.Name,Account.FirstName,Account.lastName,Producto_del_Cliente_Nectia__c,Rut_del_Cliente__c,Seguros_producto__c,Linea_Producto_Seguros__c,
                  V_a_de_Pago__c,D_a_de_Pago__c,Account.PersonBirthdate,Account.Genero_Nectia__pc,Account.PersonEmail,Tipo_de_cuenta__c,CaseNumber,Banco__c,Mensaje_Transaci_n__c,Monto_UF__c,Monto__c,
                  N_Cta_o_Tarjeta__c,CreatedDate,N_mandato__c,CreatedByid,Fecha_de_Vigencia_de_Tarjeta_Nectia__c,Fecha_Vencimiento_Tarjeta__c,Type,Subtipo__c,Genero_Nectia__c,Nombres__c,
                  Apellido_Paterno__c,Apellido_Materno__c,Fecha_de_nacimiento__c,transacion_ejecutada__c,N_de_Endoso__c,Account.Personotherphone,IdDocumentoDocuware__c,Descripci_n_Causa__c,Forma_de_Pago__c,
                  Account.PersonMobilePhone,Telefono_movil__c,Status,Codigo_Empleador__c,Codigo_de_Validacion_Autentia_Nectia__c,Fecha_Inicio_Vigencia__c,Fecha_Fin_Vigencia__c,Description,Tipo_Rescate__c,
                  Producto_del_Cliente_Nectia__r.name
                  from case where id=:idcas];
        system.debug('cas='+cas);
        string userid=UserInfo.getUserId();
        system.debug('userid'+userid);
        user  us=[select id,Codigo_Usuario_Nectia__c,FederationIdentifier,Sucursal__c   from user where id=:userid];
        system.debug('us='+us);
        user tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId() limit 1];
        system.debug('tmpUser='+tmpUser);
        Producto_del_Cliente__c pro=[select id,Codigo_Plan_Nectia__c,Poliza_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c,Ramo_Nectia__c,L_nea__c,RUT_intermediario_Nectia__c
                                     from Producto_del_Cliente__c where id=:cas.Producto_del_Cliente_Nectia__c];
        Arbol_Comunicaciones__mdt  arcom;
        try{
            arcom=[SELECT Numero_Linea__c, Id, Tipo__c, Subtipo__c, Plantilla__c, Estado_del_caso__c, Subestado_del_caso__c,Linea_de_negocio__c 
                   FROM Arbol_Comunicaciones__mdt  where   Tipo__c=:cas.Type  and 
                   Subtipo__c=:cas.Subtipo__c  and Estado_del_caso__c=:cas.Status  and Linea_de_negocio__c=:pro.L_nea__c limit 1];
            system.debug('arcom2'+arcom);
        }catch(Exception e){
            system.debug('entro a la  estructura catch');
            arcom=null;     
        }
        
        Cons_callOutService  call=new  Cons_callOutService(); 
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);
        
        
        string []resp=null;
        
        string []respcotA;
        string []respcotB;
        string []respdepA;
        string []respdepB;
        string []Norigen;
        string []respcotBMayor;
        string []respdepBMayor;
        string []datosbanco;
        string []datosnumcuenta;
        string []tipocuenta;
        system.debug('cas.Description'+cas.Description);
        if(cas.Description!=null && cas.Description!=''){
            resp=cas.Description.split('\n');
        }
        if(resp!=null){
            for(integer i=0;i<resp.size();i++){
                if(resp[i].contains('Banco:')){
                    datosbanco=resp[i].split(': ');
                   
                }
                if(resp[i].contains('Nº de cuenta:')){
                    datosnumcuenta=resp[i].split(': ');
                    
                }
                if(resp[i].contains('Tipo de cuenta:')){
                    tipocuenta=resp[i].split(': ');
                  
                }
                
                
                if(resp[i].contains('Monto UF Cotizacion A:')){
                    respcotA=resp[i].split(': ');
                    respcotA[0]='5';
                    double  res=double.valueOf(respcotA[1]);
                    if(res==0){
                        respcotA=null;
                    }
                }
                if(resp[i].contains('Monto UF Cotizacion B:')){
                    respcotB=resp[i].split(': ');
                    respcotB[0]='1';
                    double  res=double.valueOf(respcotB[1]);
                    if(res==0){
                        respcotB=null;
                    }
                }
                if(resp[i].contains('Monto UF Deposito A:')){
                    respdepA=resp[i].split(': ');
                    respdepA[0]='6';
                    double  res=double.valueOf(respdepA[1]);
                    if(res==0){
                        respdepA=null;
                    }
                }
                if(resp[i].contains('Monto UF Deposito B:')){
                    respdepB=resp[i].split(': ');
                    respdepB[0]='2';
                    double  res=double.valueOf(respdepB[1]);
                    if(res==0){
                        respdepB=null;
                    }
                }
                if(resp[i].contains('Monto UF Deposito APV B:')){
                    respdepBMayor=resp[i].split(': ');
                    respdepBMayor[0]='14';
                    double  res=double.valueOf(respdepBMayor[1]);
                    if(res==0){
                        respdepBMayor=null;
                    }
                }
                if(resp[i].contains('Monto UF Cotizacion Voluntaria B:')){
                    respcotBMayor=resp[i].split(': ');
                    respcotBMayor[0]='13';
                    double  res=double.valueOf(respcotBMayor[1]);
                    if(res==0){
                        respcotBMayor=null;
                    }
                    
                }
                if(resp[i].contains('N° Origen:')){
                    
                    Norigen=resp[i].split(': ');
                    
                }
            }
            
            system.debug('respcotA=='+respcotA);
            system.debug('respcotB=='+respcotB);
            system.debug('respdepA=='+respdepA);
            system.debug('respdepB=='+respdepB);
            system.debug('Norigen=='+Norigen);
            system.debug('respcotBMayor=='+respcotBMayor);
            system.debug('respdepBMayor=='+respdepBMayor);
            if(cas.Tipo_Rescate__c=='2'){
                DateTime fecharecalcular = system.now();
                String fechaformateada = fecharecalcular.format('dd/MM/yyyy');
                CONS_RespuestaRecalcular_JSON  recres;
                string respuesta;
                string  recarcular='';
                string  recarcular1='{'+
                    '"nRamoProducto":'+integer.valueOf(pro.Ramo_Nectia__c)+','+
                    '"nCodigoProducto":'+integer.valueOf(pro.Codigo_Plan_Nectia__c)+','+
                    '"nPoliza":'+integer.valueOf(pro.Poliza_Nectia__c)+','+
                    '"sFecha":"'+fechaformateada+'",';
                if(respcotA!=null){
                    recarcular=recarcular1+ '"nOrigin":'+integer.valueOf(respcotA[0])+','+
                        '"nRescateEstimado":'+double.valueOf(respcotA[1])+','+
                        '}';
                    if(!test.isRunningTest()){

                        respuesta=call.callOutRescate_Recalcular(access_token,recarcular,tmpUser);
                        System.debug('token->'+tmpUser.AccessToken_Nectia__c);
            			//updateUser(tmpUser.AccessToken_Nectia__c);

                    }else{
                        respuesta='{"listaCuentas":[{"nCodigoProducto":360,"nOrigin":14,"nPoliza":11598323,"nRamoProducto":1,"nRescate":0,"nRescateEstimado":0.48309175000000026,"sOrigin":"Depósito APV B > 16-12-11"}],"nRescateSobrecargado":2,"nTotalEstimado":0.48309175000000026,"responseError":{"nCodigo":0}}';
                    }
                    recres = (CONS_RespuestaRecalcular_JSON)JSON.deserialize(respuesta,CONS_RespuestaRecalcular_JSON.class);  
                    respcotA[1]=string.valueOf(decimal.valueOf(recres.nRescateSobrecargado).setscale(6));
                }  
                if(respcotB!=null){
                    recarcular=recarcular1+ '"nOrigin":'+integer.valueOf(respcotB[0])+','+
                        '"nRescateEstimado":'+double.valueOf(respcotB[1])+
                        '}';
                    if(!test.isRunningTest()){

                        respuesta=call.callOutRescate_Recalcular(access_token,recarcular,tmpUser);   
			            System.debug('token->'+tmpUser.AccessToken_Nectia__c);
			            //updateUser(tmpUser.AccessToken_Nectia__c);

                    }else{
                        respuesta='{"listaCuentas":[{"nCodigoProducto":360,"nOrigin":14,"nPoliza":11598323,"nRamoProducto":1,"nRescate":0,"nRescateEstimado":0.48309175000000026,"sOrigin":"Depósito APV B > 16-12-11"}],"nRescateSobrecargado":2,"nTotalEstimado":0.48309175000000026,"responseError":{"nCodigo":0}}';
                    }
                    recres = (CONS_RespuestaRecalcular_JSON)JSON.deserialize(respuesta,CONS_RespuestaRecalcular_JSON.class);  
                    respcotB[1]=string.valueOf(decimal.valueOf(recres.nRescateSobrecargado).setscale(6));
                }   
                if(respdepA!=null){
                    recarcular=recarcular1+ '"nOrigin":'+integer.valueOf(respdepA[0])+','+
                        '"nRescateEstimado":'+double.valueOf(respdepA[1])+
                        '}';
                    if(!test.isRunningTest()){

                        respuesta=call.callOutRescate_Recalcular(access_token,recarcular,tmpUser);   
			            System.debug('token->'+tmpUser.AccessToken_Nectia__c);
			            //updateUser(tmpUser.AccessToken_Nectia__c);

                    }else{
                        respuesta='{"listaCuentas":[{"nCodigoProducto":360,"nOrigin":14,"nPoliza":11598323,"nRamoProducto":1,"nRescate":0,"nRescateEstimado":0.48309175000000026,"sOrigin":"Depósito APV B > 16-12-11"}],"nRescateSobrecargado":2,"nTotalEstimado":0.48309175000000026,"responseError":{"nCodigo":0}}';
                    }
                    recres = (CONS_RespuestaRecalcular_JSON)JSON.deserialize(respuesta,CONS_RespuestaRecalcular_JSON.class);  
                    respdepA[1]=string.valueOf(decimal.valueOf(recres.nRescateSobrecargado).setscale(6));
                }   
                if(respdepB!=null){
                    recarcular=recarcular1+ '"nOrigin":'+integer.valueOf(respdepB[0])+','+
                        '"nRescateEstimado":'+double.valueOf(respdepB[1])+
                        '}';
                    if(!test.isRunningTest()){

                        respuesta=call.callOutRescate_Recalcular(access_token,recarcular,tmpUser);   
			            System.debug('token->'+tmpUser.AccessToken_Nectia__c);
			            //updateUser(tmpUser.AccessToken_Nectia__c);

                    }else{
                        respuesta='{"listaCuentas":[{"nCodigoProducto":360,"nOrigin":14,"nPoliza":11598323,"nRamoProducto":1,"nRescate":0,"nRescateEstimado":0.48309175000000026,"sOrigin":"Depósito APV B > 16-12-11"}],"nRescateSobrecargado":2,"nTotalEstimado":0.48309175000000026,"responseError":{"nCodigo":0}}';
                    }
                    recres = (CONS_RespuestaRecalcular_JSON)JSON.deserialize(respuesta,CONS_RespuestaRecalcular_JSON.class);  
                    respdepB[1]=string.valueOf(decimal.valueOf(recres.nRescateSobrecargado).setscale(6));
                } 
                if(respcotBMayor!=null){
                    recarcular=recarcular1+ '"nOrigin":'+integer.valueOf(respcotBMayor[0])+','+
                        '"nRescateEstimado":'+double.valueOf(respcotBMayor[1])+
                        '}';
                    if(!test.isRunningTest()){

                        respuesta=call.callOutRescate_Recalcular(access_token,recarcular,tmpUser);   
            			System.debug('token->'+tmpUser.AccessToken_Nectia__c);
            			//updateUser(tmpUser.AccessToken_Nectia__c);

                    }else{
                        respuesta='{"listaCuentas":[{"nCodigoProducto":360,"nOrigin":14,"nPoliza":11598323,"nRamoProducto":1,"nRescate":0,"nRescateEstimado":0.48309175000000026,"sOrigin":"Depósito APV B > 16-12-11"}],"nRescateSobrecargado":2,"nTotalEstimado":0.48309175000000026,"responseError":{"nCodigo":0}}';
                    }
                    recres = (CONS_RespuestaRecalcular_JSON)JSON.deserialize(respuesta,CONS_RespuestaRecalcular_JSON.class);  
                    respcotBMayor[1]=string.valueOf(decimal.valueOf(recres.nRescateSobrecargado).setscale(6));
                }
                if(respdepBMayor!=null){
                    recarcular=recarcular1+ '"nOrigin":'+integer.valueOf(respdepBMayor[0])+','+
                        '"nRescateEstimado":'+double.valueOf(respdepBMayor[1])+
                        '}';
                    if(!test.isRunningTest()){

                        respuesta=call.callOutRescate_Recalcular(access_token,recarcular,tmpUser);   
            			System.debug('token->'+tmpUser.AccessToken_Nectia__c);
            			//updateUser(tmpUser.AccessToken_Nectia__c);

                    }else{
                        respuesta='{"listaCuentas":[{"nCodigoProducto":360,"nOrigin":14,"nPoliza":11598323,"nRamoProducto":1,"nRescate":0,"nRescateEstimado":0.48309175000000026,"sOrigin":"Depósito APV B > 16-12-11"}],"nRescateSobrecargado":2,"nTotalEstimado":0.48309175000000026,"responseError":{"nCodigo":0}}';
                    }
                    
                    recres = (CONS_RespuestaRecalcular_JSON)JSON.deserialize(respuesta,CONS_RespuestaRecalcular_JSON.class);  
                    respdepBMayor[1]=string.valueOf(decimal.valueOf(recres.nRescateSobrecargado).setscale(6));
                }
                if(Norigen!=null){
                    system.debug('Norigen'+Norigen);
                    recarcular=recarcular1+ '"nOrigin":'+integer.valueOf(Norigen[1])+','+
                        '"nRescateEstimado":'+double.valueOf(cas.Monto_UF__c)+
                        '}';
                    if(!test.isRunningTest()){

                        respuesta=call.callOutRescate_Recalcular(access_token,recarcular,tmpUser);   
			            System.debug('token->'+tmpUser.AccessToken_Nectia__c);
			            //updateUser(tmpUser.AccessToken_Nectia__c);
                        
                    }else{
                        respuesta='{"listaCuentas":[{"nCodigoProducto":360,"nOrigin":14,"nPoliza":11598323,"nRamoProducto":1,"nRescate":0,"nRescateEstimado":0.48309175000000026,"sOrigin":"Depósito APV B > 16-12-11"}],"nRescateSobrecargado":2,"nTotalEstimado":0.48309175000000026,"responseError":{"nCodigo":0}}';
                    }
                    recres = (CONS_RespuestaRecalcular_JSON)JSON.deserialize(respuesta,CONS_RespuestaRecalcular_JSON.class);  
                    Norigen[0]=string.valueOf(decimal.valueOf(recres.nRescateSobrecargado).setscale(6));
                    
                }  
            }
            
        }
        double  montorescate=0;
        
        list<CONS_RescateSolicitud_JSON.SARRAYACCOUNT>  lt=new list<CONS_RescateSolicitud_JSON.SARRAYACCOUNT>();
        if(respcotA!=null){
            CONS_RescateSolicitud_JSON.SARRAYACCOUNT DS=new CONS_RescateSolicitud_JSON.SARRAYACCOUNT();
            DS.nOrigin=integer.valueOf(respcotA[0]);
            DS.namount=double.valueOf(respcotA[1]);
            montorescate=montorescate+double.valueOf(respcotA[1]);
            lt.add(DS);  
        }
        if(respcotB!=null){
            CONS_RescateSolicitud_JSON.SARRAYACCOUNT DS=new CONS_RescateSolicitud_JSON.SARRAYACCOUNT();
            DS.nOrigin=integer.valueOf(respcotB[0]);
            DS.namount=double.valueOf(respcotB[1]);
            montorescate=montorescate+double.valueOf(respcotB[1]);
            lt.add(DS);    
        }
        if(respdepA!=null){
            CONS_RescateSolicitud_JSON.SARRAYACCOUNT DS=new CONS_RescateSolicitud_JSON.SARRAYACCOUNT();
            DS.nOrigin=integer.valueOf(respdepA[0]);
            DS.namount=double.valueOf(respdepA[1]);
            montorescate=montorescate+double.valueOf(respdepA[1]);
            lt.add(DS);    
        }
        if(respdepB!=null){
            CONS_RescateSolicitud_JSON.SARRAYACCOUNT DS=new CONS_RescateSolicitud_JSON.SARRAYACCOUNT();
            DS.nOrigin=integer.valueOf(respdepB[0]);
            DS.namount=double.valueOf(respdepB[1]);
            montorescate=montorescate+double.valueOf(respdepB[1]);
            lt.add(DS);    
        }
        if(respcotBMayor!=null){
            CONS_RescateSolicitud_JSON.SARRAYACCOUNT DS=new CONS_RescateSolicitud_JSON.SARRAYACCOUNT();
            DS.nOrigin=integer.valueOf(respcotBMayor[0]);
            DS.namount=double.valueOf(respcotBMayor[1]);
            montorescate=montorescate+double.valueOf(respcotBMayor[1]);
            lt.add(DS);    
        }
        if(respdepBMayor!=null){
            CONS_RescateSolicitud_JSON.SARRAYACCOUNT DS=new CONS_RescateSolicitud_JSON.SARRAYACCOUNT();
            DS.nOrigin=integer.valueOf(respdepBMayor[0]);
            DS.namount=double.valueOf(respdepBMayor[1]);
            montorescate=montorescate+double.valueOf(respdepBMayor[1]);
            lt.add(DS);    
        }
        if(Norigen!=null){
            CONS_RescateSolicitud_JSON.SARRAYACCOUNT DS=new CONS_RescateSolicitud_JSON.SARRAYACCOUNT();
            DS.nOrigin=integer.valueOf(Norigen[1]);
            DS.namount=double.valueOf(cas.Monto_UF__c);
            montorescate=montorescate+double.valueOf(cas.Monto_UF__c);
            lt.add(DS);    
        }
        if(montorescate==0){
            montorescate=double.valueOf(cas.Monto_UF__c);
        }
        
        CONS_RescateSolicitud_JSON.datosRescate DR=new CONS_RescateSolicitud_JSON.datosRescate();
        DR.nBranch=integer.valueOf(pro.Ramo_Nectia__c);
        DR.nProduct=integer.valueOf(pro.Codigo_Plan_Nectia__c);
        DR.nPolicy=integer.valueOf(pro.Poliza_Nectia__c);
        DateTime d1 = system.now();
        String fecha = d1.format('dd-MM-yyyy');
        DR.deffecdate=fecha;
        if(cas.Tipo_Rescate__c=='Parcial'){
            DR.sSurrType='2';
        }else{
            DR.sSurrType=cas.Tipo_Rescate__c;
        }
        DR.nPayWay=1;
        DR.nAgency=(us.Sucursal__c ==null?'0':us.Sucursal__c );
        DR.nUsercode=(us.FederationIdentifier ==null?'0':us.FederationIdentifier );
        if(cas.Forma_de_Pago__c=='Depósito'){
            DR.sRequestTy='5';
            if(datosbanco!=null){
                DR.nBankCode=datosbanco[1];
            }else{
                DR.nBankCode='0';
            }
            if(datosnumcuenta!=null){
                DR.sAccount=datosnumcuenta[1];
            }else{
                DR.sAccount='';
            }
            if(tipocuenta!=null){
               system.debug('tipocuenta'+tipocuenta); 
                 system.debug('tipocuenta[1]'+tipocuenta[1]); 
                string  tipcuen=tipocuenta[1].replace(' ','');
                if(tipcuen.contains('CuentaVista')){
                    DR.ntypAcc='10'; 
                }else if(tipcuen.contains('CuentadeAhorro')){
                    DR.ntypAcc='1'; 
                }else if(tipcuen.contains('CuentaCorriente')){
                    DR.ntypAcc= '2'; 
                }else{
                    DR.ntypAcc='0';    
                }
                
            }else{
                DR.ntypAcc='0';
            }
            
        }else if(cas.Forma_de_Pago__c=='Vale Vista'){
            DR.sRequestTy='2';
        }else{
            DR.sRequestTy=null;
        }
        
        DR.nSurrAmount=montorescate;
        
        
        DR.nSurrReas=1;
        DR.sClientDest=null;
        DR.nDocTransfer=null;
        DR.nCase=integer.valueOf(cas.CaseNumber);
        DR.SARRAYACCOUNT=lt;
        CONS_RescateSolicitud_JSON.datosAlarma A=new CONS_RescateSolicitud_JSON.datosAlarma();
        string []rutsindv=(pro.RUT_intermediario_Nectia__c).split('-');
        integer i =rutsindv[0].length();
        string rutfinal='';
        for(integer r=i;r<14;r++){
            rutfinal=rutfinal+'0';
        }
        rutfinal=rutfinal+rutsindv[0];


        A.nNumCaso=cas.CaseNumber;
        A.sProductId=pro.Codigo_Plan_Nectia__c;
        A.nPoliza=pro.Poliza_Nectia__c;
        if(cas.Tipo_Rescate__c=='2'){
            A.sDescr='Rescate Parcial';
        }else if(cas.Tipo_Rescate__c=='1'){
            A.sDescr='Rescate Total';
        }
        
        
        //  if( cas.Fecha_Inicio_Vigencia__c!=null){
        DateTime dfi = system.now();//cas.Fecha_Inicio_Vigencia__c;
        String dinicio = dfi.format('dd-MM-yyyy') ;
        A.sFechaIngreso=dinicio;
        /* }else{
A.sFechaIngreso='';
}*/
        
        /*  if( cas.Fecha_Fin_Vigencia__c!=null){
DateTime dfv = cas.Fecha_Fin_Vigencia__c;
String dfin = dfv.format('dd-MM-yyyy') ;
A.sFechaCierre=dfin; 
}else{*/
        A.sFechaCierre='';
        // }
        
        A.sEstado='PENDE';//cas.Status;
        A.sMontoTrasp='';
        A.sInstitTrasp='';
        A.sRutIntermediario=rutfinal;//'5511048';
        A.sDetalle=(cas.Description==null?'solicitud rescate':cas.Description);
        CONS_RescateSolicitud_JSON.datosEmail DE=new CONS_RescateSolicitud_JSON.datosEmail();
        DE.nCelular=cas.Account.PersonMobilePhone;
        DE.nNegocio='1';
        DE.nNumpoliza=pro.Poliza_Nectia__c;
        DE.nNumsolicitud=string.valueOf(integer.valueOf(cas.CaseNumber));
        DE.nMontoRescate=integer.valueOf(cas.Monto__c);   // monto  en pesos  no en uf
        DE.nNumRescate='111';
        DE.sNombreCliente=cas.Account.name;
        DE.sEmail=cas.Account.PersonEmail;
        DateTime fechainicio = system.now();
        String fresep = fechainicio.format('dd-MM-yyyy') ;
        DE.sFechaRecepcion=fresep;
        DE.sNombcaso=cas.type+'-'+cas.Subtipo__c;
        DE.sNombreProducto =cas.Producto_del_Cliente_Nectia__r.name;
        DE.sDoc_Adjunto=(cas.IdDocumentoDocuware__c==null?'':cas.IdDocumentoDocuware__c);
        DE.sTipoPago=cas.Forma_de_Pago__c;
        DE.sBancoRescate='1111';
        DE.sDestinoChequeRescate='11111';
        DE.sCuentaDepositoRescate='1111';
        if(arcom!=null){
            DE.sPlantilla=arcom.Plantilla__c;
            DE.sLinNegocio=arcom.Linea_de_negocio__c;
            
        }else{
            DE.sPlantilla=''; 
            DE.sLinNegocio='';
        }
        
        DE.sNombreSucursal=null;
        CONS_RescateSolicitud_JSON    RS=new  CONS_RescateSolicitud_JSON();
        RS.DatosAlarma=A;
        RS.DatosEmail=DE;
        RS.datosRescate=DR;
        
        String estructura=JSON.serialize(RS);
        system.debug('estructura=='+estructura);
        /*  Cons_callOutService  call=new  Cons_callOutService(); 
CONS_estructuratoken est=new  CONS_estructuratoken();
string access_token=est.token();
system.debug('token=='+access_token);*/
        
        string  str=''; 
        system.debug('pro.Esquema_Nectia__c'+pro.Esquema_Nectia__c);
        
        if(pro.Esquema_Nectia__c=='INSUDB'){
            str=call.callOutRescate_Solicitud_Vida(access_token,estructura,tmpUser);
            updateUser(tmpUser.AccessToken_Nectia__c);
            
        }else{
            system.debug('el producto ingresado no corresponde a ninguno de los esquemas  de vida o generales no se puede llamar al servicio ');  
        } 
        system.debug('respuesta del servicio '+str);   
        if(test.isRunningTest()){
            str='{"codigo":"0","mensaje":"El servicio terminó la ejecución exitosamente","respuestaAlarmas":{"codigo":"0","mensaje":"Ok"},"respuestaBase":{"codigo":"0","mensaje":"Se generó propuesta número: 901019934","nPropuesta":901019934},"respuestaEmailmatico":{"codigo":"0","mensaje":"Ok."}}';
        }
        
        if(!str.contains('ERROR -')){
            CONS_respuestaservicio_JSON res = (CONS_respuestaservicio_JSON)JSON.deserialize(str,CONS_respuestaservicio_JSON.class);  
            system.debug('mensage del servicio == '+res.mensaje); 
            if(res.codigo=='0'){
                cas.Mensaje_Transaci_n__c=res.mensaje.left(255); 
                  if(res.RespuestaBase!=null){
                if(res.RespuestaBase.nPropuesta!=null){
                    cas.N_de_Endoso__c=decimal.valueOf(res.RespuestaBase.nPropuesta);  
                    
                }
                  }
                cas.transacion_ejecutada__c=true;
                cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
            }else{
                if(res.RespuestaBase!=null){
                    cas.Mensaje_Transaci_n__c=res.RespuestaBase.mensaje.left(255); 
                    if(res.RespuestaBase.nPropuesta!=null){
                        cas.N_de_Endoso__c=decimal.valueOf(res.RespuestaBase.nPropuesta);  
                    }
                    if(res.RespuestaBase.codigo=='0'){
                        cas.transacion_ejecutada__c=true;
                    }
                    cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
                }else{
                    cas.Mensaje_Transaci_n__c=res.mensaje.left(255); 
                    cas.transacion_ejecutada__c=false;
                    cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
                }
                if(res.respuestaEmailmatico!=null){
                    cas.Mensaje_Transaci_n__c=cas.Mensaje_Transaci_n__c+ '/n '+res.respuestaEmailmatico.mensaje; 
                    cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
                }
            }
        }else{
            cas.Mensaje_Transaci_n__c=str;
            cas.transacion_ejecutada__c=false;
            cas.Codigo_de_Validacion_Autentia_Nectia__c=Naut;
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