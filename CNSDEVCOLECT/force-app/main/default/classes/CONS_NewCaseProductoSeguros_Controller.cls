public class CONS_NewCaseProductoSeguros_Controller extends CONS_CaseTempFields{
    public Case nuevoCaso { get;set; }
    CONS_CaseTempFields controladorCampos;
    public Id id_producto { get; set; }
    public Id id_producto_record { get; set; }
    public Id id_cliente { get; set; }
    public Id rtid_producto { get; set; }
    public Arbol_Familias_Tipos_Seguros__mdt[] secciones{get;set;}
    public Arbol_Familias_Tipos_Seguros__mdt mdt{get;set;}
    public Arbol_Familias_Tipos_Seguros__mdt tmpMdt{get;set;}
    //public ListasSeleccionSeguros__mdt[] arrayCampos{get;set;}
    public SelectOption[] listaBancos { get; set; }
    public String selectedBancos { get; set; }
    public String selectedBancoLabel { get; set; }
    public String selectedBancoValor { get; set; }
    
    public SelectOption[] listaTipoCtas { get; set; }
    public String selectedTipoCta { get; set; }
    public String selectedTipoCtaLabel { get; set; }
    
    public SelectOption[] listaRegimenSII { get; set; }
    public String selectedRegimenSII { get; set; }
    public String selectedRegimenSIILabel { get; set; }
    
    public SelectOption[] listaMesInicio { get; set; }
    public String selectedMesInicio { get; set; }
    public String selectedMesInicioLabel { get; set; }
    
    public SelectOption[] listaMesFin { get; set; }
    public String selectedMesFin { get; set; }
    public String selectedMesFinLabel { get; set; }
    
    public SelectOption[] listaFormaEnvio { get; set; }
    public String selectedFormaEnvio { get; set; }
    public String selectedFormaEnvioLabel { get; set; }
    
    public String ufserv { get; set; }
    
    
    //public String selectedGiroIdAnt { get; set; }
    //public String selectedGComunaId { get; set; }
    //public String selectedComunaIdAnt { get; set; }
    
    public String seccion{get;set;}
    public String subseccion_1{get;set;}
    public String subseccion_2{get;set;}
    public String subseccion_3{get;set;}
    public Boolean tipoDoc{get;set;}
    public Id rt_caso;
    private Producto_del_Cliente__c record;
    public Producto_del_Cliente__c prdCliente{get;set;}
    public CONS_CaseTempFields tmpFields;
    public boolean perfilPresencial {get;set;}
    public Boolean presencial;
    public Boolean remoto;
    public User usuario {get;set;}

    public User tmpUser{get;set;}
    public Boolean BoolTokenActualizado;
    
    public CONS_NewCaseProductoSeguros_Controller(ApexPages.StandardController controller) {
        id_producto = ApexPages.currentPage().getParameters().get('id');
        record = (Producto_del_Cliente__c) controller.getRecord();
        id_cliente = record.Cliente_Nectia__c;
        id_producto_record = record.id;
        rtid_producto = record.RecordTypeId;        
        rt_caso = [SELECT Id FROM RecordType WHERE RecordType.Name = 'Casos Seguros'].id;
        listaBancos = new SelectOption[0];
        listaTipoCtas = new SelectOption[0];
        listaRegimenSII = new SelectOption[0];
        listaFormaEnvio = new SelectOption[0];
        listaMesInicio = new SelectOption[0];
        listaMesFin = new SelectOption[0];
        System.debug('Los datos traÃ­dos son:');
        System.debug('id_cliente: '+id_cliente);
        System.debug('id_producto: '+id_producto);
        System.debug('record: '+record);
        System.debug('rtid_producto: '+rtid_producto);
        System.debug('rt_caso: '+rt_caso);
        
        nuevoCaso = new Case();
        nuevoCaso.RecordTypeId = rt_caso;
        try{
            prdCliente = [select Id, Producto_de_Seguros_Nectia__c, Producto_de_Seguros_Nectia__r.Familia__c, Producto_de_Seguros_Nectia__r.L_nea__c,
                          Numero_Certificado_Nectia__c,Ramo_Nectia__c,Codigo_Plan_Nectia__c,Poliza_Nectia__c,Esquema_Nectia__c from Producto_del_Cliente__c Where Id =: id_producto];
        }catch(Exception e){
            prdCliente = [select Id, Producto_de_Seguros_Nectia__c, Producto_de_Seguros_Nectia__r.Familia__c, Producto_de_Seguros_Nectia__r.L_nea__c,
                          Numero_Certificado_Nectia__c,Ramo_Nectia__c,Codigo_Plan_Nectia__c,Poliza_Nectia__c,Esquema_Nectia__c from Producto_del_Cliente__c Where Id =: id_producto_record];
        }
        system.debug('prdCliente'+prdCliente);
        listaBancos.add(new SelectOption('-1', '--Seleccione--'));
        for(ListasSeleccionSeguros__mdt record: [Select MasterLabel, Valor__c from ListasSeleccionSeguros__mdt Where Etiqueta_Campo__c =: 'Banco' ORDER BY MasterLabel ASC]) {
            listaBancos.add(new SelectOption(record.Valor__c, record.MasterLabel));
        }
        listaTipoCtas.add(new SelectOption('-1', '--Seleccione--'));
        for(ListasSeleccionSeguros__mdt listadoTiposCtas: [Select MasterLabel, Valor__c from ListasSeleccionSeguros__mdt Where Etiqueta_Campo__c =: 'Tipo de cuenta' ORDER BY MasterLabel ASC]) {
            listaTipoCtas.add(new SelectOption(listadoTiposCtas.Valor__c, listadoTiposCtas.MasterLabel));
        }
        for(ListasSeleccionSeguros__mdt listadoRegimenSII: [Select MasterLabel, Valor__c from ListasSeleccionSeguros__mdt Where Etiqueta_Campo__c =: 'Régimen SII' ORDER BY MasterLabel ASC]) {
            listaRegimenSII.add(new SelectOption(listadoRegimenSII.Valor__c, listadoRegimenSII.MasterLabel));
        }
        for(ListasSeleccionSeguros__mdt listadoFormaEnvio: [Select MasterLabel, Valor__c from ListasSeleccionSeguros__mdt Where Etiqueta_Campo__c =: 'Forma envío' ORDER BY MasterLabel ASC]) {
            listaFormaEnvio.add(new SelectOption(listadoFormaEnvio.Valor__c, listadoFormaEnvio.MasterLabel));
        }
        for(ListasSeleccionSeguros__mdt listadoMesInicio: [Select MasterLabel, Valor__c from ListasSeleccionSeguros__mdt Where Etiqueta_Campo__c =: 'Mes' ORDER BY MasterLabel ASC]) {
            listaMesInicio.add(new SelectOption(listadoMesInicio.Valor__c, listadoMesInicio.MasterLabel));
        }
        for(ListasSeleccionSeguros__mdt listadoMesFin: [Select MasterLabel, Valor__c from ListasSeleccionSeguros__mdt Where Etiqueta_Campo__c =: 'Mes' ORDER BY MasterLabel ASC]) {
            listaMesFin.add(new SelectOption(listadoMesFin.Valor__c, listadoMesFin.MasterLabel));
        }
        usuario = [SELECT Id,ProfileId FROM User WHERE Id =: UserInfo.getUserId()];
        
        Profile perfil = [SELECT Id,Name FROM Profile WHERE Id =: usuario.ProfileId];
        system.debug('perfil->'+perfil);
        system.debug('perfil n->'+perfil.Name);
        
        if (perfil.Name=='Ejecutivos de Atención al Cliente Seguros Remoto' || perfil.Name=='Jefe de Atención al Cliente Seguros Remoto' || perfil.Name=='Usuario Seguros Estándar' || perfil.Name=='Ejecutivos de Atención al Cliente Seguros MAC' || perfil.Name=='Jefe de Atención al Cliente Seguros MAC' ){
            PerfilPresencial = true;
        }else{
            PerfilPresencial = false;
        }
        system.debug('perfil presencial->'+PerfilPresencial);
        
    }
    public void validaSeccion(){
        
        
        try{
            secciones = [Select Id, Origen__c, Clasificaci_n_de_Solicitud__c, Seccion__c,subseccion_1__c,subseccion_2__c,subseccion_3__c, Motivo_Anulaci_n__c , V_a_de_pago__c, Clasificaci_n_de_Consulta__c, Tipo_Pago__c,Tipo__c, Subtipo__c, 
                         Tipo_documento__c, Tipo_de_documento__c, Clasificaci_n_del_Reclamo__c, Tipo_Gesti_n_Pago__c, Tipo_Modificaci_n__c, Familia__c,Linea_Producto_Seguros__c,No_requiere_subclasificacion__c, Usar_Familia__c
                         from Arbol_Familias_Tipos_Seguros__mdt where Tipo__c =: nuevoCaso.Type AND Subtipo__c =: nuevoCaso.Subtipo__c];
            
            for(integer i = 0; i < secciones.size(); i++){
                system.debug(nuevoCaso);
                system.debug(secciones[i]);
                system.debug(secciones[i].Seccion__c);
                system.debug(secciones[i].Origen__c);
                system.debug(subseccion_1);
                system.debug(subseccion_2);
                system.debug(subseccion_3);
                system.debug(prdCliente.Producto_de_Seguros_Nectia__r.Familia__c.contains(';'));
                system.debug(prdCliente.Producto_de_Seguros_Nectia__r.L_nea__c);
                if(secciones[i].Origen__c != null){
                    seccion = secciones[i].Seccion__c != null ? secciones[i].Seccion__c : seccion;
                }else{
                    if(secciones[i].Tipo__c == nuevoCaso.Type && secciones[i].Subtipo__c == nuevoCaso.Subtipo__c && secciones[i].Familia__c == prdCliente.Producto_de_Seguros_Nectia__r.Familia__c && !secciones[i].Familia__c.contains(';'))
                    {
                        seccion = secciones[i].Seccion__c != null ? secciones[i].Seccion__c : seccion;
                        if(
                            (secciones[i].Tipo_de_documento__c == nuevoCaso.Tipo_de_documento__c && nuevoCaso.Tipo_de_documento__c != null) || 
                            (secciones[i].Tipo_Modificaci_n__c == nuevoCaso.Tipo_de_Modificaci_n__c && nuevoCaso.Tipo_de_Modificaci_n__c != null) || 
                            (secciones[i].Tipo_Pago__c == nuevoCaso.Tipo_Pago__c && nuevoCaso.Tipo_Pago__c != null) ||
                            (secciones[i].Tipo_Pago__c == nuevoCaso.Forma_de_Pago__c && nuevoCaso.Forma_de_Pago__c != null) ||
                            (secciones[i].V_a_de_pago__c == nuevoCaso.V_a_de_Pago__c && nuevoCaso.V_a_de_Pago__c != null) ||
                            (secciones[i].V_a_de_pago__c == nuevoCaso.Nueva_V_a_de_Pago__c && nuevoCaso.Nueva_V_a_de_Pago__c != null) ||
                            (secciones[i].Clasificaci_n_de_Consulta__c == nuevoCaso.Clasificaci_n_de_Consulta__c && nuevoCaso.Clasificaci_n_de_Consulta__c != null) ||
                            (nuevoCaso.Tipo_Rescate__c != null) ||
                            (secciones[i].Tipo_Gesti_n_Pago__c == nuevoCaso.Tipo_Gesti_n_Pago__c && nuevoCaso.Tipo_Gesti_n_Pago__c != null)
                        )
                        {
                            system.debug(secciones[i].Tipo_Pago__c);
                            system.debug(nuevoCaso.Forma_de_Pago__c);
                            system.debug(secciones[i].subseccion_2__c);
                            subseccion_1 = secciones[i].subseccion_1__c != null ? secciones[i].subseccion_1__c : subseccion_1;
                            if(secciones[i].Tipo_Pago__c == nuevoCaso.Forma_de_Pago__c && nuevoCaso.Forma_de_Pago__c != null && secciones[i].subseccion_2__c == null){
                                subseccion_2 = secciones[i].subseccion_2__c;
                                
                                
                            }else{
                                if(secciones[i].Tipo_Pago__c == nuevoCaso.Forma_de_Pago__c && nuevoCaso.Forma_de_Pago__c != null){
                                    subseccion_2 = secciones[i].subseccion_2__c;
                                    subseccion_3 = secciones[i].subseccion_3__c != null ? secciones[i].subseccion_3__c : subseccion_3;
                                    system.debug('AQUIIII');
                                    if(secciones[i].Usar_Familia__c){
                                        break;
                                    }
                                }else{
                                    subseccion_2 = secciones[i].subseccion_2__c != null ? secciones[i].subseccion_2__c : subseccion_2;
                                }
                            }
                            subseccion_3 = secciones[i].subseccion_3__c != null ? secciones[i].subseccion_3__c : subseccion_3;
                            system.debug('primer if');
                            system.debug(subseccion_1);
                            system.debug(subseccion_2);
                            system.debug(subseccion_3);
                            
                        } 
                        system.debug(subseccion_1);
                        system.debug(subseccion_2);
                        system.debug(subseccion_3);
                        
                    }else{
                        system.debug('else');
                        
                        system.debug(secciones[i].subseccion_1__c);
                        if(secciones[i].Tipo__c == nuevoCaso.Type && secciones[i].Subtipo__c == nuevoCaso.Subtipo__c && (secciones[i].Linea_Producto_Seguros__c == prdCliente.Producto_de_Seguros_Nectia__r.L_nea__c && secciones[i].Familia__c.contains(';')))
                        {
                            if(secciones[i].subseccion_1__c != null && secciones[i].subseccion_2__c != null && !secciones[i].No_requiere_subclasificacion__c){
                                seccion = secciones[i].Seccion__c != null ? secciones[i].Seccion__c : seccion;
                                system.debug('if else 1');
                            }else{
                                if(!secciones[i].No_requiere_subclasificacion__c){
                                    seccion = secciones[i].Seccion__c != null && seccion == null ? secciones[i].Seccion__c : seccion;
                                    system.debug('if else 2');
                                }
                                
                            }
                            if(secciones[i].No_requiere_subclasificacion__c && secciones[i].Tipo_Modificaci_n__c == null && nuevoCaso.Tipo_de_Modificaci_n__c == null && secciones[i].Clasificaci_n_del_Reclamo__c == null && nuevoCaso.Clasificaci_n_del_Reclamo__c == null && secciones[i].Clasificaci_n_de_Solicitud__c == null && nuevoCaso.Clasificaci_n_de_Solicitud__c == null && secciones[i].Clasificaci_n_de_Consulta__c == null && nuevoCaso.Clasificaci_n_de_Consulta__c == null){
                                seccion = secciones[i].Seccion__c != null ? secciones[i].Seccion__c : seccion;
                                subseccion_1 = secciones[i].subseccion_1__c != null ? secciones[i].subseccion_1__c : subseccion_1;
                                subseccion_2 = secciones[i].subseccion_2__c != null ? secciones[i].subseccion_2__c : subseccion_2;
                                subseccion_3 = secciones[i].subseccion_3__c != null ? secciones[i].subseccion_3__c : subseccion_3;
                                break;
                            }
                            if(
                                (secciones[i].Tipo_de_documento__c == nuevoCaso.Tipo_de_documento__c && nuevoCaso.Tipo_de_documento__c != null) || 
                                (secciones[i].Tipo_Modificaci_n__c == nuevoCaso.Tipo_de_Modificaci_n__c && nuevoCaso.Tipo_de_Modificaci_n__c != null) || 
                                (secciones[i].Tipo_Pago__c == nuevoCaso.Tipo_Pago__c && nuevoCaso.Tipo_Pago__c != null) ||
                                nuevoCaso.Motivo_de_Devoluci_n__c != null ||
                                (nuevoCaso.Tipo_Rescate__c != null) ||
                                (secciones[i].Clasificaci_n_del_Reclamo__c == nuevoCaso.Clasificaci_n_del_Reclamo__c && nuevoCaso.Clasificaci_n_del_Reclamo__c != null) ||
                                (secciones[i].Clasificaci_n_de_Solicitud__c == nuevoCaso.Clasificaci_n_de_Solicitud__c && nuevoCaso.Clasificaci_n_de_Solicitud__c != null) ||
                                (secciones[i].V_a_de_pago__c == nuevoCaso.V_a_de_Pago__c && nuevoCaso.V_a_de_Pago__c != null) ||
                                (secciones[i].V_a_de_pago__c == nuevoCaso.Nueva_V_a_de_Pago__c && nuevoCaso.Nueva_V_a_de_Pago__c != null) ||
                                (secciones[i].Tipo_Pago__c == nuevoCaso.Forma_de_Pago__c && nuevoCaso.Forma_de_Pago__c != null) ||
                                (secciones[i].Clasificaci_n_de_Consulta__c == nuevoCaso.Clasificaci_n_de_Consulta__c && nuevoCaso.Clasificaci_n_de_Consulta__c != null) ||
                                (secciones[i].Tipo_Gesti_n_Pago__c == nuevoCaso.Tipo_Gesti_n_Pago__c && nuevoCaso.Tipo_Gesti_n_Pago__c != null)
                            )
                            {
                                system.debug('IF tipos');
                                system.debug(secciones[i].Tipo_Pago__c);
                                system.debug(nuevoCaso.Forma_de_Pago__c);
                                system.debug(nuevoCaso.V_a_de_Pago__c);
                                if((secciones[i].V_a_de_pago__c == nuevoCaso.Nueva_V_a_de_Pago__c && nuevoCaso.Nueva_V_a_de_Pago__c != null) || (secciones[i].Tipo_Pago__c == nuevoCaso.Nueva_V_a_de_Pago__c && nuevoCaso.Nueva_V_a_de_Pago__c != null) || (secciones[i].V_a_de_pago__c == nuevoCaso.V_a_de_Pago__c && nuevoCaso.V_a_de_Pago__c != null && secciones[i].V_a_de_pago__c != null) || (secciones[i].Tipo_Pago__c == nuevoCaso.Forma_de_Pago__c && nuevoCaso.Forma_de_Pago__c != null)  || (secciones[i].Motivo_Anulaci_n__c == nuevoCaso.Motivo_Anulaci_n__c && nuevoCaso.Motivo_Anulaci_n__c != null && secciones[i].Motivo_Anulaci_n__c != null)){
                                    system.debug(subseccion_1);
                                    system.debug(subseccion_2);
                                    system.debug(subseccion_3);
                                    subseccion_1 = secciones[i].subseccion_1__c != null ? secciones[i].subseccion_1__c : subseccion_1;
                                    subseccion_2 = secciones[i].subseccion_2__c != null ? secciones[i].subseccion_2__c : subseccion_2;
                                    subseccion_3 = secciones[i].subseccion_3__c != null ? secciones[i].subseccion_3__c : subseccion_3;
                                    
                                    system.debug('1 if');
                                    system.debug(subseccion_1);
                                    system.debug(subseccion_2);
                                    system.debug(subseccion_3);
                                }else{
                                    subseccion_1 = secciones[i].subseccion_1__c != null && subseccion_1 == null ? secciones[i].subseccion_1__c : subseccion_1;
                                    system.debug(subseccion_1);
                                    subseccion_2 = secciones[i].subseccion_2__c != null && subseccion_2 == null  ? secciones[i].subseccion_2__c : subseccion_2;
                                    subseccion_3 = secciones[i].subseccion_3__c != null && subseccion_3 == null  ? secciones[i].subseccion_3__c : subseccion_3;
                                    if((secciones[i].Tipo_Pago__c != nuevoCaso.Forma_de_Pago__c && nuevoCaso.Forma_de_Pago__c != null) || (secciones[i].V_a_de_pago__c != nuevoCaso.Nueva_V_a_de_Pago__c && nuevoCaso.Nueva_V_a_de_Pago__c != null)){
                                        //subseccion_2 = '';
                                        system.debug('3 if');
                                    }
                                    system.debug('2 if');
                                    system.debug(subseccion_2);
                                    
                                    
                                    
                                }
                                system.debug('segundo if');
                                system.debug(subseccion_1);
                                system.debug(subseccion_2);
                                system.debug(subseccion_3);
                                
                            }
                            system.debug(seccion);
                            system.debug(secciones[i].subseccion_1__c);
                            system.debug(subseccion_1);
                            system.debug(subseccion_2);
                            system.debug(subseccion_3);
                        }
                    }
                }    
                
            }
            system.debug('seccion=='+seccion);
            system.debug(subseccion_1);
            system.debug(subseccion_2);
            system.debug(subseccion_3);
            
            if(nuevoCaso.V_a_de_Pago__c=='1' || nuevoCaso.V_a_de_Pago__c=='2' || nuevoCaso.V_a_de_Pago__c=='3' ){
                DateTime fd = system.now();
                String fechasiaconsulta =  fd.format('dd-MM-yyyy') ;
                CONS_estructuratoken est=new  CONS_estructuratoken();
                string access_token=est.token();
                system.debug('token=='+access_token);
                string usid= UserInfo.getUserId();
                User us=[select  id,FederationIdentifier from User where id=:usid limit 1 ];
                string  envio='{'+
                    '"codigoBranch": '+prdCliente.Ramo_Nectia__c+','+
                    '"codigoProducto": '+prdCliente.Codigo_Plan_Nectia__c+','+
                    '"numeroPoliza": '+prdCliente.Poliza_Nectia__c+','+
                    '"numeroCertificado": '+prdCliente.Numero_Certificado_Nectia__c+','+
                    '"deffecDate": "'+fechasiaconsulta+'",'+
                    '"codigoUsuario": "'+(us.FederationIdentifier ==null?'0':us.FederationIdentifier )+'"'+
                    '}';
                system.debug('envio'+envio);
                
                Cons_callOutService  call= new Cons_callOutService();
                string str;

                tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];

                if(prdCliente.Esquema_Nectia__c=='INSUDB'){

                    str=call.callOutconsulta_via_pago_Vida(access_token,envio,tmpUser);

                                        System.debug('token->'+tmpUser.AccessToken_Nectia__c);
                                        updateUser(tmpUser.AccessToken_Nectia__c);

                }else if(prdCliente.Esquema_Nectia__c=='CLONINSUDB'){

                    str=call.callOutconsulta_via_pago_Generales(access_token,envio,tmpUser);

                                        System.debug('token->'+tmpUser.AccessToken_Nectia__c);
                                        updateUser(tmpUser.AccessToken_Nectia__c);

                }
                system.debug('str'+str);
                if(test.isRunningTest()){
                    str='{    "codigoViaPago": 2,    "diaPago": 20,    "codigoBanco": 2, "rutEmpleador":"15555555-5",  "numeroCuenta": "6656777785954444",    "mandatoPoliza": "13263",    "codigoTipoCuenta": 0,    "codigoTipoTarjeta": 3,    "fechaExpiracionTarjeta": "10-10-2023",    "fechaVigenciaTarjeta": "24-01-2019",    "frecuenciaPagos": 5,    "rutPagador": "00000014761486",    "digitoPagador": "1",    "nombrePagador": "iXWkzNRCKrdFtXAMatg",    "apellidoPPagador": "VDEaxEMBFKQciblMOkY",    "apellidoMPagador": "qvOPFDnvslfaiWVnnmk",    "fechaNaciminetoPagador": "17-02-1976",    "sexoPagador": "1",    "codigoEmpleador": 0,    "numeroCalle": 0,    "codigoComuna": 0,    "codigoCiudad": 0,    "codigo": 0}';
                }
                if(!str.contains('ERROR -')){
                    CONS_RespuestaConsultaViaPago_JSON resp;
                    
                    
                    resp = (CONS_RespuestaConsultaViaPago_JSON)JSON.deserialize(str,CONS_RespuestaConsultaViaPago_JSON.class);  
                    
                    nuevoCaso.Banco__c=string.valueOf(resp.codigoBanco==0?null:resp.codigoBanco);
                    nuevoCaso.N_mandato__c=resp.mandatoPoliza;
                    nuevoCaso.Tipo_de_cuenta__c=string.valueOf(resp.codigoTipoTarjeta);
                    
                    if(resp.fechaVigenciaTarjeta!=null && resp.fechaVigenciaTarjeta!=''){
                        string []fecha=resp.fechaVigenciaTarjeta.split('-');
                        Date fechavigencia = Date.valueOf(fecha[2]+'-'+fecha[1]+'-'+fecha[0]);  
                        nuevoCaso.Fecha_de_Vigencia_de_Tarjeta_Nectia__c=fechavigencia;
                    }else{
                        nuevoCaso.Fecha_de_Vigencia_de_Tarjeta_Nectia__c=null;  
                    }
                    if(resp.fechaExpiracionTarjeta!=null && resp.fechaExpiracionTarjeta!=''){
                        string []fecha=resp.fechaExpiracionTarjeta.split('-');
                        Date fechavencimiento = Date.valueOf(fecha[2]+'-'+fecha[1]+'-'+fecha[0]);  
                        nuevoCaso.Fecha_Vencimiento_Tarjeta__c=fechavencimiento;
                    }else{
                        nuevoCaso.Fecha_Vencimiento_Tarjeta__c=null;  
                    }
                    nuevoCaso.D_a_de_Pago__c=string.valueOf(resp.diaPago);
                    //nuevoCaso.Frecuencia_de_Pago__c=string.valueOf(resp.frecuenciaPagos);
                    if(resp.rutPagador!=null){
                        nuevoCaso.Rut__c=integer.valueOf(resp.rutPagador)+'-'+resp.digitoPagador;
                    }
                    nuevoCaso.Nombres__c=resp.nombrePagador;
                    nuevoCaso.Apellido_Paterno__c=resp.apellidoPPagador;
                    nuevoCaso.Apellido_Materno__c=resp.apellidoMPagador;
                    if(resp.sexoPagador!='3'){
                        nuevoCaso.Genero_Nectia__c=resp.sexoPagador;   
                    }
                    
                    if(resp.fechaNaciminetoPagador!=null && resp.fechaNaciminetoPagador!=''){
                        string []fecha=resp.fechaNaciminetoPagador.split('-');
                        Date fechanacimiento = Date.valueOf(fecha[2]+'-'+fecha[1]+'-'+fecha[0]);  
                        nuevoCaso.Fecha_de_nacimiento__c=fechanacimiento;
                    }else{
                        nuevoCaso.Fecha_de_nacimiento__c=null;  
                    }
                    
                    nuevoCaso.Datos_Empleador__c=resp.nombreEmpleador;
                    if(resp.codigoEmpleador!=null   ){
                        nuevoCaso.Codigo_Empleador__c=string.valueOf(resp.codigoEmpleador);
                    }
                    if(resp.rutEmpleador!=null && resp.rutEmpleador!=''){
                        string []rut=resp.rutEmpleador.split('-');
                        if(rut.size()>0){
                            nuevoCaso.RUT_Empleador_Nectia__c=integer.valueOf(rut[0])+'-'+rut[1];
                        }else{
                            integer  q=rut[0].length();
                            string rutsin = rut[0].substring(1,q-1);
                            string dv = rut[0].substring(q-1,q);
                            
                            nuevoCaso.RUT_Empleador_Nectia__c=''+integer.valueOf(rutsin)+'-'+dv;
                        }
                        
                        
                    }
                    nuevoCaso.N_Cta_o_Tarjeta__c=double.valueOf(resp.numeroCuenta) ;
                }
                system.debug('nuevoCaso'+nuevoCaso);
            }
            system.debug('');
            if(nuevoCaso.Tipo_Rescate__c=='2' || nuevoCaso.Tipo_Rescate__c=='1'   || nuevoCaso.Tipo_Rescate__c=='Préstamo'){
                DateTime fd = system.now();
                String fechasiaconsulta =  fd.format('dd/MM/yyyy') ;
                CONS_estructuratoken est=new  CONS_estructuratoken();
                string access_token=est.token();
                system.debug('token=='+access_token);
                string usid= UserInfo.getUserId();
                User us=[select  id,FederationIdentifier from User where id=:usid limit 1 ];
                string  estructura='{'+
                    '"nRamoProducto": '+prdCliente.Ramo_Nectia__c+','+
                    '"nCodigoProducto": '+prdCliente.Codigo_Plan_Nectia__c+','+
                    '"nPoliza": '+prdCliente.Poliza_Nectia__c+','+
                    '"sFecha": "'+fechasiaconsulta+'",'+
                    '"nTipoRescate": "'+nuevoCaso.Tipo_Rescate__c+'"'+
                    '}';
                
                tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];

                Cons_callOutService  call= new Cons_callOutService();
                string str;
                string respuestaservida='';

                if(prdCliente.Esquema_Nectia__c=='INSUDB'){
                    if ((nuevoCaso.Tipo_Rescate__c=='2' || nuevoCaso.Tipo_Rescate__c=='1' )&&(prdCliente.Codigo_Plan_Nectia__c=='362'  ||
                                                                                              prdCliente.Codigo_Plan_Nectia__c=='360'  ||
                                                                                              prdCliente.Codigo_Plan_Nectia__c=='293'  ||
                                                                                              prdCliente.Codigo_Plan_Nectia__c=='294'  ||
                                                                                              prdCliente.Codigo_Plan_Nectia__c=='13'  ||
                                                                                              prdCliente.Codigo_Plan_Nectia__c=='600'  ||
                                                                                              prdCliente.Codigo_Plan_Nectia__c=='650'  )){

                                                                                                                                                                        BoolTokenActualizado = false;

                                                                                                                                                                                                str=call.callOutCalcular_Rescate_Vida(access_token,estructura,tmpUser);

                                                                                                                                                                                                System.debug('token->'+tmpUser.AccessToken_Nectia__c);
                                                                                                                                                                                                //updateUser(tmpUser.AccessToken_Nectia__c);
                                                                                              }else{

                                                                                                  system.debug('Debido al código de producto  no tiene integracion de consulta de saldos ');
                                                                                              }
                    string  envio='{'+
                        '"codigoBranch": '+prdCliente.Ramo_Nectia__c+','+
                        '"codigoProducto": '+prdCliente.Codigo_Plan_Nectia__c+','+
                        '"numeroPoliza": '+prdCliente.Poliza_Nectia__c+','+
                        '"numeroCertificado": '+prdCliente.Numero_Certificado_Nectia__c+','+
                        '"deffecDate": "'+fechasiaconsulta+'",'+
                        '"codigoUsuario": "'+(us.FederationIdentifier ==null?'0':us.FederationIdentifier )+'"'+
                        '}';
                    system.debug('envio'+envio);
                    
                    respuestaservida=call.callOutconsulta_via_pago_Vida(access_token,envio,tmpUser);
                    system.debug('respuestaservida'+respuestaservida);

                    /*if (!BoolTokenActualizado){
                                                System.debug('token->'+tmpUser.AccessToken_Nectia__c);
                                                updateUser(tmpUser.AccessToken_Nectia__c);
                                        }*/
                    
                    string resUF=call.callOutValor_UF(access_token,tmpUser);
                    system.debug('resUF'+resUF);

                    if (!BoolTokenActualizado){
                                                System.debug('token->'+tmpUser.AccessToken_Nectia__c);
                                                updateUser(tmpUser.AccessToken_Nectia__c);
                                        }
                    
                    DOM.Document doc = new DOM.Document();
                    if(resUF!='ERROR -'){
                        doc.load(resUF);    
                        DOM.XMLNode root = doc.getRootElement();
                        system.debug('root'+root);
                        
                        parseXML(root);   
                    }else{
                        
                        ufVal=double.valueOf('20000');  
                    }
                    
                    system.debug('ufVal'+ufVal);  
                }else{
                    system.debug('no existe servicio');
                }
                
                system.debug('str'+str);
                if(test.isRunningTest()){
                    str = '{"listaCuentas":[{"nCodigoProducto": 294,"nOrigin": 2,"nPoliza": 11511650,"nRamoProducto": 1,"nRescateEstimado": 4245,"sOrigin": "Cuenta Unificada" },{"nCodigoProducto": 294,"nOrigin": 7,"nPoliza": 11511650,"nRamoProducto": 1,"nRescateEstimado": 4245,"sOrigin": "Cuenta Unificada" },{"nCodigoProducto": 294,"nOrigin": 6,"nPoliza": 11511650,"nRamoProducto": 1,"nRescateEstimado": 4245,"sOrigin": "Cuenta Unificada" },{"nCodigoProducto": 294,"nOrigin": 1,"nPoliza": 11511650,"nRamoProducto": 1,"nRescateEstimado": 4245,"sOrigin": "Cuenta Unificada" },{"nCodigoProducto": 294,"nOrigin": 4,"nPoliza": 11511650,"nRamoProducto": 1,"nRescateEstimado": 4245,"sOrigin": "Cuenta Unificada" },{"nCodigoProducto": 294,"nOrigin": 5,"nPoliza": 11511650,"nRamoProducto": 1,"nRescateEstimado": 4245,"sOrigin": "Cuenta Unificada" }], "nTipoRescate": 1,"nTotalEstimado": 4245,"responseError": {"nCodigo": 0,"sMensaje": "OK TOTAL" }}';
                }
                if(!str.contains('ERROR -')){
                    try{
                        CONS_ConsultaRescate_JSON resp = (CONS_ConsultaRescate_JSON)JSON.deserialize(str,CONS_ConsultaRescate_JSON.class);  
                        if(prdCliente.Producto_de_Seguros_Nectia__r.Familia__c!='APV'){
                            MontoMaximo = double.valueOf(decimal.valueOf(resp.listaCuentas.get(0).nRescateEstimado).setScale(2));
                        }
                        for(integer i=0;i<resp.listaCuentas.size();i++){
                            
                            if(resp.listaCuentas.get(i).nOrigin==5){
                                CheckboxCotizacionAUF=true;
                                nuevoCaso.Cotizaciones_Voluntarias_Reg_Tribut_A__c='SI';
                                MontoUFDepositoA=double.valueOf(resp.listaCuentas.get(i).nRescateEstimado);
                                
                            }else if(resp.listaCuentas.get(i).nOrigin==1 ){
                                CheckboxCotizacionBUF=true;
                                nuevoCaso.Cotizaciones_Voluntarias_Reg_Tribut_B__c='SI';
                                MontoUFDepositoB=double.valueOf(resp.listaCuentas.get(i).nRescateEstimado);
                                
                            }else if( resp.listaCuentas.get(i).nOrigin==13){
                                CheckboxCotizacionBUFMayor=true;
                                MontoUFDepositoBMayor=double.valueOf(resp.listaCuentas.get(i).nRescateEstimado);
                                
                            }else if(resp.listaCuentas.get(i).nOrigin==6){
                                CheckboxDepositoAUF=true;
                                nuevoCaso.Dep_sitos_de_APV_A__c='SI';
                                MontoUFDepositoAPVA=double.valueOf(resp.listaCuentas.get(i).nRescateEstimado);
                                
                            }else if(resp.listaCuentas.get(i).nOrigin==2){
                                CheckboxDepositoBUF=true;
                                nuevoCaso.Dep_sitos_de_APV_B__c ='SI'; 
                                MontoUFDepositoAPVB=double.valueOf(resp.listaCuentas.get(i).nRescateEstimado);
                                
                            }else if(resp.listaCuentas.get(i).nOrigin==14){
                                CheckboxDepositoAPVBMayor=true;
                                MontoUFDepositoAPVBMayor=double.valueOf(resp.listaCuentas.get(i).nRescateEstimado);
                                
                            }else   if(resp.listaCuentas.get(i).nOrigin==7){
                                CheckboxAporFiscal=true;
                                MontoUFAporFiscal=double.valueOf(resp.listaCuentas.get(i).nRescateEstimado);
                                
                            }else if(resp.listaCuentas.get(i).nOrigin==3 || resp.listaCuentas.get(i).nOrigin==12){
                                CheckboxDevConv =true;
                                MontoUFDevConv=double.valueOf(resp.listaCuentas.get(i).nRescateEstimado);
                                
                            }else{
                                numcuentaorigen =resp.listaCuentas.get(i).nOrigin;
                                system.debug('numcuentaorigen'+numcuentaorigen);
                            }
                            
                            
                        }
                    }catch(Exception e){
                        system.debug(e);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'','servicio sin fondos')); 
                        
                    }
                    
                }
                if(!respuestaservida.contains('ERROR -') && respuestaservida!=''){
                    CONS_RespuestaConsultaViaPago_JSON respvia;
                    
                    
                    respvia = (CONS_RespuestaConsultaViaPago_JSON)JSON.deserialize(respuestaservida,CONS_RespuestaConsultaViaPago_JSON.class);  
                    
                    if(respvia.codigoViaPago==1){
                        NoCtaTarjeta= respvia.numeroCuenta;
                        selectedBancos=string.valueOf(respvia.codigoBanco);
                        selectedTipoCta=string.valueOf(respvia.codigoTipoCuenta); 
                    }
                    
                    
                    
                }
            }
            
            
        }catch(Exception e){  
            system.debug(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'','Reclamos no deben ser cerrados en la creación'));
        }
        
    }
    public pageReference saveAndClose(){
        try{
            if (nuevoCaso.Type != 'Reclamo'){
                if( prdCliente.Producto_de_Seguros_Nectia__r.Familia__c!='APV' ){
                    if(nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='Rescate'){
                        nuevoCaso.Monto__c=TotalPesos;
                        nuevoCaso.Monto_UF__c=TotalUF;
                        system.debug('debug 1 Monto'+nuevoCaso.Monto__c);
                        system.debug('debug 1 Monto Maximo'+MontoMaximo);
                        
                        if(TotalUF == 0 || TotalUF == null){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El monto en pesos debe ser  mayor que "0" '));
                            return null;
                        } 
                        if(nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c == null){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Debe ingresar Fecha Real Solicitud'));
                            return null;
                        }
                        if(NoCtaTarjeta == null){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El numero de la cuenta no debe ser vacio'));
                            return null;
                        }
                        if( MontoMaximo != null && nuevoCaso.Monto_UF__c > MontoMaximo ){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El monto a retirar no puede ser mayor que el monto máximo '));
                            return null;
                        } 
                    }
                } else {
                    system.debug('tipo'+nuevoCaso.Type);
                    system.debug('nuevoCaso.Subtipo__c'+nuevoCaso.Subtipo__c);
                    if(nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='Rescate'){
                        system.debug('Tarjeta 1'+NoCtaTarjeta);
                         system.debug('forma de pago2'+nuevoCaso.Forma_de_Pago__c);
                        if(NoCtaTarjeta == null && nuevoCaso.Forma_de_Pago__c != 'Vale Vista' ){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Debe ingresar N° de Cuenta'));
                            return null;
                        }
                        if(nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c == null){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Debe ingresar Fecha Real Solicitud'));
                            return null;
                        }
                        if(MontoPesoCotizacionA != null){
                            if(MontoPesoCotizacionAUF > MontoUFDepositoA){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El Monto Cotizaciones Voluntarias Régimen Tributario A no debe ser mayor a '+MontoUFDepositoA+ ' UF'));
                                return null;
                            }
                        }
                        
                        if(MontoPesoCotizacionB != null){
                            if(MontoPesoCotizacionBUF > MontoUFDepositoB){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El Monto Cotizaciones Voluntarias Régimen Tributario B no debe ser mayor a '+MontoUFDepositoB+' UF'));
                                return null;
                            }
                        }
                        if(MontoPesoDepositoA != null){
                            if(MontoPesoDepositoAUF > MontoUFDepositoAPVA){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'el Monto Depósitos de APV A no debe ser mayor a '+MontoUFDepositoAPVA +' UF'));
                                return null;
                            }
                        }
                        if(MontoPesoDepositoB != null){
                            if(MontoPesoDepositoBUF > MontoUFDepositoAPVB){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'el Monto Depósitos de APV B no debe ser mayor a '+MontoUFDepositoAPVB+' UF'));
                                return null;
                            }
                        }
                        if(MontoPesoCotizacionBMayor != null){
                            if(MontoPesoCotizacionBUFMayor > MontoUFDepositoBMayor){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'el Monto Cotizaciones Voluntaria B > 16-12-11 no debe ser mayor a '+MontoUFDepositoBMayor+' UF'));
                                return null;
                            }
                        }   
                        
                        long totalAux = ((MontoPesoDepositoBMayor == null) ? 0:MontoPesoDepositoBMayor) +
                            ((MontoPesoCotizacionBMayor == null) ? 0:MontoPesoCotizacionBMayor) +
                            ((MontoPesoDepositoB == null) ? 0:MontoPesoDepositoB) +
                            ((MontoPesoDepositoA == null) ? 0:MontoPesoDepositoA) + 
                            ((MontoPesoCotizacionB == null) ? 0:MontoPesoCotizacionB) + 
                            ((MontoPesoCotizacionA == null) ? 0:MontoPesoCotizacionA) ;
                        if(totalAux <= 0 && prdCliente.Producto_de_Seguros_Nectia__r.Familia__c=='APV'){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El monto total debe ser mayor que "0" '));
                            return null;
                        }
                        if(MontoPesoDepositoBMayor != null){
                            if(MontoPesoDepositoBUFMayor > MontoUFDepositoAPVBMayor){                            
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'el Monto Depósito APV B > 16-12-11 no debe ser mayor a '+MontoUFDepositoAPVBMayor+' UF'));
                                return null;
                            }
                        }
                    }                    
                }
                
                // se va a comentar el numero de la cuenta
                // if(NoCtaTarjeta == null || NoCtaTarjeta == ''){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El numero de la cuenta  debe ser mayor que 0'));
                // return null;
                //} else {
                //nuevoCaso.RecordTypeId = rt_caso;
                String CaseRecordTypeId;
                
                Producto_del_Cliente__c pdcs = [SELECT Id,L_nea__c FROM Producto_del_Cliente__c WHERE Id =: record.Id];
                String tipo = nuevoCaso.Type;
                String linea;
                if (pdcs.L_nea__c == 'Rentas Vitalicias'){
                    linea = 'Renta';
                } else {
                    linea = pdcs.L_nea__c;
                }
                
                if (tipo != '' && linea != ''){
                    String TipoDeRegistro = 'Seguros - '+ tipo + ' - ' + linea;
                    System.debug('tipo de registro->'+TipoDeRegistro);
                    Schema.DescribeSObjectResult caseDesribe = Schema.SObjectType.Case;
                    Map<String,Schema.RecordTypeInfo> rtMapByName = caseDesribe.getRecordTypeInfosByName();
                    Schema.RecordTypeInfo rtByName =  rtMapByName.get(TipoDeRegistro);
                    CaseRecordTypeId = rtByName.getRecordTypeId();
                    System.debug('Id Tipo de registro->'+CaseRecordTypeId); 
                }
                
                nuevoCaso.AccountId = record.Cliente_Nectia__c;
                nuevoCaso.Producto_del_Cliente_Nectia__c = record.Id;
                
                if (CaseRecordTypeId != '' || CaseRecordTypeId != null){
                    nuevoCaso.RecordTypeId = CaseRecordTypeId;
                } else {
                    nuevoCaso.RecordTypeId = rt_caso;
                }
                
                nuevoCaso.Status ='Cerrado';
                nuevoCaso.Comments = 'Caso cerrado en la punta';
                nuevoCaso.Tipo_de_cierre_Nectia__c = 'Caso cerrado en la punta';
                nuevoCaso.Type = nuevoCaso.Type;
                nuevoCaso.Valores_Nectia__c = nuevoCaso.Valores_Nectia__c;
                nuevoCaso.Subject = nuevoCaso.Subject;
                nuevoCaso.Description = nuevoCaso.Description;
                nuevoCaso.Subtipo__c = nuevoCaso.Subtipo__c;
                nuevoCaso.Priority = nuevoCaso.Priority;
                nuevoCaso.Origin = nuevoCaso.Origin;
                
                
                if(!test.isRunningTest()){
                    insert nuevoCaso;
                    pageReference p = new PageReference('/'+nuevoCaso.Id);
                    return p;
                } else {
                    return null;
                }
                // se debe descomentar para el numero de la cuenta
                //}
            } else {
                //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Reclamos no deben ser cerrados en la creaciÃ³n');
                //ApexPages.addMessages(myMsg);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'','Reclamos no deben ser cerrados en la creación'));
                return null;
            }
        }
        catch(System.DmlException e){
            ApexPages.addMessages(e);
        }
        return null;
    }
    
    public pageReference saveAndSee(){
        system.debug('saveandsee');
        try{
            system.debug('TotalUF->'+TotalUF);
            // else {
            
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            
            //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
            
            //Setting the DMLOption on Case instance
            nuevoCaso.setOptions(dmlOpts);
            
            nuevoCaso.AccountId = record.Cliente_Nectia__c;
            nuevoCaso.Producto_del_Cliente_Nectia__c = record.Id;
            nuevoCaso.RecordTypeId = rt_caso;       
            
            nuevoCaso.Type = nuevoCaso.Type;
            nuevoCaso.Valores_Nectia__c = nuevoCaso.Valores_Nectia__c;
            nuevoCaso.Subject = nuevoCaso.Subject;
            nuevoCaso.Description = nuevoCaso.Description;
            nuevoCaso.Subtipo__c = nuevoCaso.Subtipo__c;
            nuevoCaso.Priority = nuevoCaso.Priority;
            nuevoCaso.Origin = nuevoCaso.Origin;
            nuevoCaso.Fecha_Inicio_Vigencia__c = nuevoCaso.Fecha_Inicio_Vigencia__c;
            nuevoCaso.Fecha_Fin_Vigencia__c = nuevoCaso.Fecha_Fin_Vigencia__c;
            
            if(nuevoCaso.V_a_de_Pago__c=='1'){
                nuevoCaso.RUT_Empleador_Nectia__c=null;  
                nuevoCaso.Datos_Empleador__c=null; 
                nuevoCaso.D_a_de_Pago__c=nuevoCaso.D_a_de_Pago__c; 
                
            }else if(nuevoCaso.V_a_de_Pago__c=='2'){
                nuevoCaso.RUT_Empleador_Nectia__c=null;  
                nuevoCaso.Datos_Empleador__c=null;  
                nuevoCaso.D_a_de_Pago__c=nuevoCaso.D_a_de_Pago__c; 
                
            }else if(nuevoCaso.V_a_de_Pago__c=='3'){
                nuevoCaso.Banco__c=null;  
                nuevoCaso.D_a_de_Pago__c=nuevoCaso.D_a_de_Pago__c; 
            }
            if(FechaInicioSuspension != null || FechaFinSuspension != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description + '\n ' + 'Fecha Inicio Suspensión: '+FechaInicioSuspension+ '\n ' + 'Fecha Fin Suspensión: '+FechaFinSuspension : 'Fecha Inicio Suspensión: '+FechaInicioSuspension+ '\n ' + 'Fecha Fin Suspensión: '+FechaFinSuspension;
            }
            if(NuevaPrimaProyectada != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description + '\n ' + 'Nueva Prima Proyectada: '+NuevaPrimaProyectada : 'Nueva Prima Proyectada: '+NuevaPrimaProyectada;
            }
            if(selectedBancos != null && selectedBancos !='-1'  &&  selectedBancos !='--Seleccione--'){
                selectedBancoLabel = [Select MasterLabel,Valor__c  from ListasSeleccionSeguros__mdt Where Etiqueta_Campo__c =: 'Banco' AND Valor__c =:selectedBancos].MasterLabel;
                selectedBancoValor = [Select MasterLabel,Valor__c  from ListasSeleccionSeguros__mdt Where Etiqueta_Campo__c =: 'Banco' AND Valor__c =:selectedBancos].Valor__c;
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nBanco nombre: '+selectedBancoLabel : 'Banco nombre: '+selectedBancoLabel;
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nBanco: '+selectedBancoValor : 'Banco: '+selectedBancoValor;
                
            }
            if(selectedTipoCta != null && selectedTipoCta != '-1' &&  selectedTipoCta !='--Seleccione--'){
                selectedTipoCtaLabel = [Select MasterLabel from ListasSeleccionSeguros__mdt Where Etiqueta_Campo__c =: 'Tipo de cuenta' AND Valor__c =:selectedTipoCta].MasterLabel;
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Tipo de cuenta: '+selectedTipoCtaLabel : 'Tipo de cuenta: '+selectedTipoCtaLabel;
            }
            if(NoCtaTarjeta != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Nº de cuenta: '+NoCtaTarjeta : 'Nº de cuenta: '+NoCtaTarjeta;
            }
            if(NombreTerceroAfectado != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nNombre de tercero afectado: '+NombreTerceroAfectado : 'Nombre de tercero afectado: '+NombreTerceroAfectado;
            }
            if(RutTerceroAfectado != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nRut de tercero afectado: '+RutTerceroAfectado : 'Rut de tercero afectado: '+RutTerceroAfectado;
            }
            if(NoDeclaracionBeneficiarios != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nNº Declaración Beneficiarios: '+NoDeclaracionBeneficiarios : 'Nº Declaración Beneficiarios: '+NoDeclaracionBeneficiarios;
            }
            if(NuevoPlan != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nNuevo Plan: '+NuevoPlan : 'Nuevo Plan: '+NuevoPlan;
            }
            if(Fumador != null){
                String fuma = Fumador == true ? 'Si' : 'No';                               
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nFumador: '+fuma : 'Fumador: '+fuma;
            }
            if(selectedRegimenSII != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nNuevo Régimen SII: '+selectedRegimenSII : 'Nuevo Régimen SII: '+selectedRegimenSII;
            }
            if(selectedFormaEnvio != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nForma de Envío: '+selectedFormaEnvio : 'Forma de Envío: '+selectedFormaEnvio;
            }
            if(NombreApoderado != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nNombre Apoderado: '+NombreApoderado : 'Nombre Apoderado: '+NombreApoderado;
            }
            if(ApellidoPatApoderado != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nApellido Paterno Apoderado: '+ApellidoPatApoderado : 'Apellido Paterno Apoderado: '+ApellidoPatApoderado;
            }
            if(ApellidoMatApoderado != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nApellido Materno Apoderado: '+ApellidoMatApoderado : 'Apellido Materno Apoderado: '+ApellidoMatApoderado;
            }
            if(NoPropuesta != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nNº Propuesta: '+NoPropuesta : 'Nº Propuesta: '+NoPropuesta;
            }
            if(NuevaPrima != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nNueva Prima: '+NuevaPrima : 'Nueva Prima: '+NuevaPrima;
            }
            if(Deducible != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nDeducible: '+Deducible : 'Deducible: '+Deducible;
            }
            if(NuevaCobertura != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nNueva Cobertura: '+NuevaCobertura : 'Nueva Cobertura: '+NuevaCobertura;
            }
            if(RutServipag != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nRut Receptor Pago Servipag: '+RutServipag : 'Rut Receptor Pago Servipag: '+RutServipag;
            }
            if(NombreServipag != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nNombre Receptor Pago Servipag: '+NombreServipag : 'Nombre Receptor Pago Servipag: '+NombreServipag;
            }
            if(ApellidoPatServipag != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nApellidos Receptor Pago Servipag: '+ApellidoPatServipag : 'Apellidos Receptor Pago Servipag: '+ApellidoPatServipag;
            }
            if(MesInicio != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nMes inicio: '+MesInicio : 'Mes inicio: '+MesInicio;
            }
            if(MesFin != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nMes fin: '+MesFin : 'Mes fin: '+MesFin;
            }
            if(RutNuevoBeneficiario != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nRut: '+RutNuevoBeneficiario : 'Rut: '+RutNuevoBeneficiario;
            }
            if(NombreNuevoBeneficiario != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nNombres: '+NombreNuevoBeneficiario : 'Nombres: '+NombreNuevoBeneficiario;
            }
            if(ApellidoPatNuevoBeneficiario != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\nApellidos: '+ApellidoPatNuevoBeneficiario : 'Apellidos : '+ApellidoPatNuevoBeneficiario;
            }
            
            if(nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='Rescate'){
                /*
if(nuevoCaso.Monto__c == 0 || nuevoCaso.Monto__c == null){
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El monto en pesos debe ser mayor que "0" '));
return null;
}

if( MontoMaximo != null && nuevoCaso.Monto__c > MontoMaximo ){
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El monto a retirar no puede ser mayor que el monto máximo'));
return null;
}
*/
                system.debug('NoCtaTarjeta->('+NoCtaTarjeta+')');
                system.debug('forma de pago'+nuevoCaso.Forma_de_Pago__c);
                if(NoCtaTarjeta == null){
                    if(nuevoCaso.Forma_de_Pago__c != 'Vale Vista'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Debe ingresar N° de Cuenta'));
                    return null;
                    }
                }
                if(nuevoCaso.Fecha_Real_Solicitud_solicitud_rescates__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Debe ingresar Fecha Real Solicitud'));
                    return null;
                }
                if(prdCliente.Producto_de_Seguros_Nectia__r.Familia__c=='APV'){
                    if(MontoPesoCotizacionA != null){
                        nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Monto Peso Cotizacion A: '+MontoPesoCotizacionA : 'Monto Peso Cotizacion A: '+MontoPesoCotizacionA;
                        nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Monto UF Cotizacion A: '+MontoPesoCotizacionAUF : 'Monto UF Cotizacion A: '+MontoPesoCotizacionAUF;
                        if(MontoPesoCotizacionAUF > MontoUFDepositoA){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'el Monto Cotizaciones Voluntarias Régimen Tributario A no debe ser mayor a '+MontoUFDepositoA+ ' UF'));
                            return null;
                        }
                    }
                    if(MontoPesoCotizacionB != null){
                        nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Monto Peso Cotizacion B: '+MontoPesoCotizacionB : 'Monto Peso Cotizacion B: '+MontoPesoCotizacionB;
                        nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Monto UF Cotizacion B: '+MontoPesoCotizacionBUF : 'Monto UF Cotizacion B: '+MontoPesoCotizacionBUF;
                        if(MontoPesoCotizacionBUF > MontoUFDepositoB){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El Monto Cotizaciones Voluntarias Régimen Tributario B no debe ser mayor a '+MontoUFDepositoB+' UF'));
                            return null;
                        }
                        
                    }
                    if(MontoPesoDepositoA != null){
                        nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Monto Peso Deposito A: '+MontoPesoDepositoA : 'Monto Peso Deposito A: '+MontoPesoDepositoA;
                        nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Monto UF Deposito A: '+MontoPesoDepositoAUF : 'Monto UF Deposito A: '+MontoPesoDepositoAUF;
                        if(MontoPesoDepositoAUF > MontoUFDepositoAPVA){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'el Monto Depósitos de APV A no debe ser mayor a '+MontoUFDepositoAPVA +' UF'));
                            return null;
                        }
                    }
                    if(MontoPesoDepositoB != null){
                        nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Monto Peso Deposito B: '+MontoPesoDepositoB : 'Monto Peso Deposito B: '+MontoPesoDepositoB;
                        nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Monto UF Deposito B: '+MontoPesoDepositoBUF : 'Monto UF Deposito B: '+MontoPesoDepositoBUF;
                        if(MontoPesoDepositoBUF > MontoUFDepositoAPVB){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'el Monto Depósitos de APV B no debe ser mayor a '+MontoUFDepositoAPVB+' UF'));
                            return null;
                        }
                    }
                    if(MontoPesoCotizacionBMayor != null){
                        nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Monto Peso Cotizacion Voluntaria B: '+MontoPesoCotizacionBMayor : 'Monto Peso Cotizacion Voluntaria B: '+MontoPesoCotizacionBMayor;
                        nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Monto UF Cotizacion Voluntaria B: '+MontoPesoCotizacionBUFMayor : 'Monto UF Cotizacion Voluntaria B: '+MontoPesoCotizacionBUFMayor;
                        if(MontoPesoCotizacionBUFMayor > MontoUFDepositoBMayor){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'el Monto Cotizaciones Voluntaria B > 16-12-11 no debe ser mayor a '+MontoUFDepositoBMayor+' UF'));
                            return null;
                        }
                    }                        
                    if(MontoPesoDepositoBMayor != null){
                        nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Monto Peso Deposito APV B: '+MontoPesoDepositoBMayor : 'Monto Peso Deposito APV B: '+MontoPesoDepositoBMayor;
                        nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n Monto UF Deposito APV B: '+MontoPesoDepositoBUFMayor : 'Monto UF Deposito APV B: '+MontoPesoDepositoBUFMayor;
                        if(MontoPesoDepositoBUFMayor > MontoUFDepositoAPVBMayor){                            
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'el Monto Depósito APV B > 16-12-11 no debe ser mayor a '+MontoUFDepositoAPVBMayor+' UF'));
                            return null;
                        }
                    }
                    
                    
                    long totalAux = ((MontoPesoDepositoBMayor == null) ? 0:MontoPesoDepositoBMayor) +
                        ((MontoPesoCotizacionBMayor == null) ? 0:MontoPesoCotizacionBMayor) +
                        ((MontoPesoDepositoB == null) ? 0:MontoPesoDepositoB) +
                        ((MontoPesoDepositoA == null) ? 0:MontoPesoDepositoA) + 
                        ((MontoPesoCotizacionB == null) ? 0:MontoPesoCotizacionB) + 
                        ((MontoPesoCotizacionA == null) ? 0:MontoPesoCotizacionA) ;
                    if(totalAux <= 0){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El monto total debe ser mayor que "0" '));
                        return null;
                    }
                    system.debug('TotalPesos->'+TotalPesos);
                    system.debug('TotalUF->'+TotalUF);
                    /*
if(TotalPesos == 0 || TotalPesos == null){
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El monto en pesos debe ser mayor que "0" '));
return null;
}*/
                    nuevoCaso.Monto__c=TotalPesos;
                    nuevoCaso.Monto_UF__c=TotalUF;
                }else{
                    system.debug('nuevoCaso.Monto__c'+nuevoCaso.Monto__c);
                    system.debug('nuevoCaso.Monto_UF__c'+nuevoCaso.Monto_UF__c);
                    system.debug('TotalPesos'+TotalPesos);
                    system.debug('TotalUF'+TotalUF);
                    nuevoCaso.Monto__c=TotalPesos;
                    nuevoCaso.Monto_UF__c=TotalUF;
                    
                    if( MontoMaximo != null && nuevoCaso.Monto_UF__c > MontoMaximo ){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El monto a retirar no puede ser mayor que el monto máximo '));
                        return null;
                    } 
                    
                    if(nuevoCaso.Monto__c == 0 || nuevoCaso.Monto__c == null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El monto en pesos debe ser mayor que "0" '));
                        return null;
                    }
                }
            }
            if(numcuentaorigen != null){
                nuevoCaso.Description = nuevoCaso.Description != null ? nuevoCaso.Description+'\n N° Origen: '+numcuentaorigen : 'N° Origen: '+numcuentaorigen;
            } 
            
            if(nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='Modificación de Póliza' &&  nuevoCaso.Tipo_de_Modificaci_n__c=='Asignación Apoderado'){
                nuevoCaso.Apellidos_Nuevo_Apoderado__c=nuevoCaso.Apellido_Paterno__c+' '+nuevoCaso.Apellido_Materno__c;
            }
            insert nuevoCaso;
            system.debug('nuevo caso->'+nuevoCaso);
            
            //UserInfo.getUserId()
            
            String perfilId;
            perfilId = UserInfo.getProfileId();
            String nombrePerfil = [SELECT Id,Name FROM Profile WHERE Id =: perfilId].Name;
            PerfilesSeguridad__mdt PerfilesMeta = [SELECT id,Actualiza_Datos__c,Crea_Clave__c,
                                                   Id_Perfil__c,Nombre_Perfil__c,
                                                   Pide_huella__c FROM PerfilesSeguridad__mdt 
                                                   WHERE Id_Perfil__c =: perfilId];
            // /*List<User> usuario = [SELECT Id,ProfileId FROM User WHERE Id =: UserInfo.getUserId()];
            // if (usuario.size() != 0){
            // //String perfilId = String.valueOf(usuario.get(0).ProfileId);
            // system.debug('perfil->'+perfilId);
            // List<Profile> perfil = [SELECT Id,Name FROM Profile WHERE Id =: perfilId];
            // system.debug('perfil->'+perfil);
            // if (perfil.size() != 0){
            // system.debug('validacion perfil logueado=='+perfil.get(0).Name);
            // if (perfil.get(0).Name == 'Ejecutivos de Atención al Cliente Seguros Remoto' || perfil.get(0).Name=='Administrador del sistema' ){
            // system.debug('perfil remoto');
            // presencial = false;
            // remoto = true;
            // } else if(perfil.get(0).Name == 'Ejecutivos de Atención al Cliente Seguros Presencial' || perfil.get(0).Name=='Jefe de Atención al Cliente Seguros Presencial'  || perfil.get(0).Name=='Ejecutivos de Atención al Cliente Seguros Comercial' ){
            // system.debug('perfil presencial');
            // presencial = true;
            // remoto = false;
            // }
            // }
            // }
            // */           //   presencial = false;
            //remoto = true;
            // if (nombrePerfil == 'Ejecutivos de Atención al Cliente Seguros Remoto'){
            if(PerfilesMeta.Pide_huella__c == false){
                system.debug('perfil remoto');
                presencial = false;
                remoto = true;
            } else{
                
                //  if(nombrePerfil == 'Ejecutivos de Atención al Cliente Seguros Presencial' || nombrePerfil == 'Jefe de Atención al Cliente Seguros Presencial'   ){
                if(PerfilesMeta.Pide_huella__c == true){
                    system.debug('perfil presencial');
                    presencial = true;
                    remoto = false;   
                }else{
                    if(!test.isRunningTest()){
                        presencial = false;
                        remoto = true;
                    }
                }
            }
            
            system.debug('if de proceso de integracion');
            system.debug('nuevoCaso.Type=='+nuevoCaso.Type);
            system.debug('nuevoCaso.Subtipo__c=='+nuevoCaso.Subtipo__c);
            system.debug('nuevoCaso.Tipo_de_Modificaci_n__c=='+nuevoCaso.Tipo_de_Modificaci_n__c);
            system.debug('nuevoCaso.V_a_de_Pago__c=='+nuevoCaso.V_a_de_Pago__c);
            
            if (nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='Modificación de Póliza' && ((nuevoCaso.Tipo_de_Modificaci_n__c=='Vía de Pago' && (nuevoCaso.V_a_de_Pago__c=='1' || nuevoCaso.V_a_de_Pago__c=='2' || nuevoCaso.V_a_de_Pago__c=='3')) || nuevoCaso.Tipo_de_Modificaci_n__c=='Día de Pago' ))
            {
                system.debug('entro a proceso via de pago');
                if (presencial == true){
                    // AUNTENTIA
                    PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+nuevoCaso.id+'&tipo=VP&obj=c');
                    return pageRef;
                }
                
                if (remoto == true){
                    system.debug('a servicio de modificación de vía de pago');
                    pageReference p = new PageReference('/apex/CONS_CambioviaPago?id='+nuevoCaso.Id+'&CodBco='+selectedBancos);
                    return p;
                    //CONS_Via_Pago servicio = new CONS_Via_Pago();
                    //String retorno = servicio.cambioviapago(nuevoCaso.Id);
                }
            }
            if (nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='Modificación de Póliza' && nuevoCaso.Tipo_de_Modificaci_n__c=='Vía de Pago Pensión')
            {
                if(presencial == true){
                    PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+nuevoCaso.id+'&tipo=VPR&obj=c');
                    return pageRef;
                } else{
                    //   /*   system.debug('a servicio de modificación de Vía de Pago Pensión');
                    //        pageReference p = new PageReference('/apex/CONS_CambioviaPagoRV?id='+nuevoCaso.Id+'&CodBco='+selectedBancos);
                    //        return p;*/
                    
                }
            }
            
            if (nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='Modificación de Póliza' && nuevoCaso.Tipo_de_Modificaci_n__c=='Rehabilitación')
            {
                system.debug('entro a proceso rehabilitación');
                if (presencial == true){
                    system.debug('rehabilitación presencial autentia');
                    // AUNTENTIA
                    PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+nuevoCaso.id+'&tipo=RP&obj=c');
                    return pageRef;
                }
                
                if (remoto == true){
                    system.debug('a servicio de rehabilitación de póliza');
                    system.debug('rehabilitación remoto');
                    
                    pageReference p = new PageReference('/apex/CONS_Rehabilitacionpoliza?id='+nuevoCaso.Id);
                    return p;
                }
            }
            
            if (nuevoCaso.Type=='Solicitud' && ((nuevoCaso.Subtipo__c=='Modificación de Póliza'  && nuevoCaso.Tipo_de_Modificaci_n__c=='Terminos de Pólizas (Solo Vida Tradicional)' ) || nuevoCaso.Subtipo__c=='Término de Póliza') )
            {
                system.debug('entro a proceso modificación-Termino');
                if (presencial == true){
                    // AUNTENTIA
                    PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+nuevoCaso.id+'&tipo=TP&obj=c');
                    return pageRef;
                }
                
                if (remoto == true){
                    system.debug('a servicio de término de póliza');
                    //CONS_Poliza servicio = new CONS_Poliza();
                    //String retorno = servicio.terminopoliza(nuevoCaso.Id);
                    pageReference p = new PageReference('/apex/CONS_TerminoPoliza?id='+nuevoCaso.Id+'&CodBco='+selectedBancos);
                    return p;
                }
            }
            
            if (nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='Otros Pagos')
            {
                system.debug('entro a proceso otros pagos');
                if (presencial == true){
                    PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+nuevoCaso.id+'&tipo=OP&obj=c');
                    return pageRef; 
                }
            }
            
            if (nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='No Pago Pensión')
            {
                system.debug('entro a proceso no pago pensión');
                if (presencial){
                    PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+nuevoCaso.id+'&tipo=PP&obj=c');
                    return pageRef;
                }
            }
            
            if (nuevoCaso.Type=='Solicitud' && ( nuevoCaso.Subtipo__c=='Rescate FFMM'))
            {
                system.debug('entro a proceso rescate');
                if (presencial){
                    PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+nuevoCaso.id+'&tipo=Res&obj=c');
                    return pageRef;
                }
            }
            
            if (nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='Modificación de Póliza'  &&  nuevoCaso.Tipo_de_Modificaci_n__c=='Prima Proyectada' ){
                system.debug('entro a proceso modificación prima proyectada');
                if(decimal.valueOf(NuevaPrimaProyectada)>399){
                    pageReference p = new PageReference('/'+nuevoCaso.Id);
                    return p;
                }else{
                    if (presencial == true){
                        PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+nuevoCaso.id+'&tipo=CP&obj=c');
                        return pageRef;
                    }
                    
                    if (remoto == true){
                        pageReference p = new PageReference('/apex/CONS_CambioPrimaProyectada?id='+nuevoCaso.Id);
                        return p;  
                        
                    }
                    
                }
            }
            
            if (nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='Modificación de Póliza'  &&  nuevoCaso.Tipo_de_Modificaci_n__c=='Suspensión de Pagos' ){
                system.debug('entro a proceso modificación póliza suspensión de pagos');
                if (presencial == true){
                    PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+nuevoCaso.id+'&tipo=SP&obj=c');
                    return pageRef;
                }
                
                if (remoto == true){
                    pageReference p = new PageReference('/apex/CONS_SuspensionPago?id='+nuevoCaso.Id);
                    return p;
                    
                }
                
                
            }
            
            if (nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='Modificación de Póliza'  &&  nuevoCaso.Tipo_de_Modificaci_n__c=='Asignación Apoderado' ){
                if (presencial == true){
                    PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+nuevoCaso.id+'&tipo=AA&obj=c');
                    return pageRef;
                }
                
                if (remoto == true){
                    ///*   system.debug('entro a proceso modificación póliza apoderado');
                    //pageReference p = new PageReference('/apex/CONS_Cambio_Apoderado?id='+nuevoCaso.Id);
                    //return p;*/
                    
                }
                
            }
            
            if (nuevoCaso.Type=='Solicitud' && (nuevoCaso.Subtipo__c=='Rescate' ))
            {
                
                //                   /*    if(nuevoCaso.Description==null){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'NO  TIENE RESCATES DISPONIBLES'));
                //return null;
                //}else{*/
                if (presencial == true){
                    PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+nuevoCaso.id+'&tipo=RR&obj=c');
                    return pageRef;
                }else{
                    pageReference p = new PageReference('/apex/CONS_SolicitudRescate?id='+nuevoCaso.Id);
                    return p; 
                }
                
                //   }                
            }
            
            
            if (
                (nuevoCaso.Type=='Reclamo' && (
                    nuevoCaso.Subtipo__c=='Asociadas a Producción S. Vida' || nuevoCaso.Subtipo__c=='Reclamos Siniestros S. Vida' || 
                    nuevoCaso.Subtipo__c=='Asociadas a Producción S. Generales' || nuevoCaso.Subtipo__c=='Sobre Denuncio y Asignación Siniestro'  || 
                    nuevoCaso.Subtipo__c=='Atención de Siniestro de Pérdida Parcial' || nuevoCaso.Subtipo__c=='Servicio de Asistencia Vehicular' || 
                    nuevoCaso.Subtipo__c=='Atención del Tercero Afectado en Siniestro' || nuevoCaso.Subtipo__c=='Atención de Siniestro de Pérdida Total' || 
                    nuevoCaso.Subtipo__c=='Descuento' || nuevoCaso.Subtipo__c=='No Pago Pensión' || 
                    nuevoCaso.Subtipo__c == 'Modificación No Efectuada' || nuevoCaso.Subtipo__c == 'No Gestión Beneficio Estatal')
                ) || 
                (nuevoCaso.Type=='Solicitud' &&  (
                    nuevoCaso.Subtipo__c=='Sobre Denuncio y Asignación Siniestro' ||  nuevoCaso.Subtipo__c=='Traspaso APV' ||  
                    nuevoCaso.Subtipo__c=='Devolución Primas')
                )
            ){
                system.debug('entra a proceso reclamos');
                pageReference p = new PageReference('/apex/CONS_Reclamos?id='+nuevoCaso.Id);
                return p;
            }
            
            
            if (nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='Modificación de Póliza' &&(nuevoCaso.Tipo_de_Modificaci_n__c=='Frecuencia de Pago' ||
                                                                                                 nuevoCaso.Tipo_de_Modificaci_n__c=='Aumento Capital' || nuevoCaso.Tipo_de_Modificaci_n__c=='Beneficiarios' ||nuevoCaso.Tipo_de_Modificaci_n__c=='Contratante' ||
                                                                                                 nuevoCaso.Tipo_de_Modificaci_n__c=='Plan' || nuevoCaso.Tipo_de_Modificaci_n__c=='Tipo Fumador' || nuevoCaso.Tipo_de_Modificaci_n__c=='Ingreso/Modifica Coberturas' ||
                                                                                                 nuevoCaso.Tipo_de_Modificaci_n__c=='Régimen SII (Factura)' || nuevoCaso.Tipo_de_Modificaci_n__c=='Traspasos Cobertura' || nuevoCaso.Tipo_de_Modificaci_n__c=='Disminución Capital Asegurado' ||
                                                                                                 nuevoCaso.Tipo_de_Modificaci_n__c=='Elimina Cobertuas' || nuevoCaso.Tipo_de_Modificaci_n__c=='Regimen Tributario' || nuevoCaso.Tipo_de_Modificaci_n__c=='Actualización Patente (solo provisoria a definitiva)' ||
                                                                                                 nuevoCaso.Tipo_de_Modificaci_n__c=='Datos Materia Asegurada' || nuevoCaso.Tipo_de_Modificaci_n__c=='Día de Pago') )
            {
                if (presencial == true){
                    PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+nuevoCaso.id+'&tipo=com&obj=c');
                    return pageRef;
                }else{
                    system.debug('endoso Comunicaciones');
                    pageReference p = new PageReference('/apex/CONS_Comunicaciones?id='+nuevoCaso.Id);
                    return p;
                }                
            }
            system.debug('nuevoCaso.Type'+nuevoCaso.Type);
            system.debug('nuevoCaso.Subtipo__c'+nuevoCaso.Subtipo__c);
            system.debug('prdCliente.Producto_de_Seguros_Nectia__r.L_nea__c'+prdCliente.Producto_de_Seguros_Nectia__r.L_nea__c);
            system.debug('nuevoCaso.Tipo_de_Modificaci_n__c'+nuevoCaso.Tipo_de_Modificaci_n__c);
            if(nuevoCaso.Type=='Solicitud' && nuevoCaso.Subtipo__c=='Modificación de Póliza' &&  
               (prdCliente.Producto_de_Seguros_Nectia__r.L_nea__c=='Generales' &&  (nuevoCaso.Tipo_de_Modificaci_n__c=='Anulación de Endoso' ||
                                                                                    nuevoCaso.Tipo_de_Modificaci_n__c=='Anulación de Propuesta' ||
                                                                                    nuevoCaso.Tipo_de_Modificaci_n__c=='Refinanciamiento Simple' ||
                                                                                    nuevoCaso.Tipo_de_Modificaci_n__c=='Renovación'))  ||
               (prdCliente.Producto_de_Seguros_Nectia__r.L_nea__c=='Rentas Vitalicias' && (nuevoCaso.Tipo_de_Modificaci_n__c=='Forma Envío Liquidación' ||
                                                                                           nuevoCaso.Tipo_de_Modificaci_n__c=='Cambio Receptor Pago Servipag' ||
                                                                                           nuevoCaso.Tipo_de_Modificaci_n__c=='Cambio Institución de Salud' ||
                                                                                           nuevoCaso.Tipo_de_Modificaci_n__c=='Cambio Beneficiario Designado'))  ||
               (prdCliente.Producto_de_Seguros_Nectia__r.L_nea__c=='Vida' && (nuevoCaso.Tipo_de_Modificaci_n__c=='Fondos de Inversión '  ||
                                                                              nuevoCaso.Tipo_de_Modificaci_n__c=='Elimina Cobertuas'  ||
                                                                              nuevoCaso.Tipo_de_Modificaci_n__c=='Anula/Desiste Endoso'  ||
                                                                              nuevoCaso.Tipo_de_Modificaci_n__c=='Regimen Tributario'))      ){
                                                                                  
                                                                                  if (presencial){
                                                                                      PageReference pageRef = new PageReference('/apex/CONS_pruebahuellero?id='+nuevoCaso.id+'&tipo=SI&obj=c');
                                                                                      return pageRef;
                                                                                  }
                                                                                  
                                                                              }
            system.debug('ningún proceso');
            pageReference p = new PageReference('/'+nuevoCaso.Id);
            return p;
            //}
        }
        catch(System.DmlException e){
            system.debug('catch error');
            ApexPages.addMessages(e);
        }
        return null;
    }
    public pageReference cerrar(){
        //PageReference p = new PageReference('/'+record.id);
        PageReference p = new PageReference('/'+record.Name);
        //pageReference p = new PageReference('/');
        p.setRedirect(true); 
        return p;
        //return null;
        
    }
    
    
    public void parseXML(DOM.XMLNode node) {
        
        system.debug('node'+node);
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            system.debug('node.getName()'+node.getName());  
            if(node.getName()=='ufVal' ){
                ufserv = node.getText().trim();
                system.debug('ufserv'+ufserv);
                if(ufserv!=null && ufserv!='' ){
                    ufVal=double.valueOf(ufserv);
                    system.debug('ufVal'+ufVal); 
                }
            }
            for (Dom.XMLNode child: node.getChildElements()) {
                if(node.getName()=='ufVal' ){
                    system.debug('entro por ufVal');
                    parseXML(child);
                }else{
                    system.debug('no entro por ufVal');
                    parseXML(child);
                }
                
            }
        }
    }

        public void updateUser(String tokenActualizado){
                system.debug('token actualizado->'+tokenActualizado);
                User usuarioParaActualizar = [SELECT Id,AccessToken_Nectia__c FROM User WHERE Id =: UserInfo.getUserId()];

                usuarioParaActualizar.AccessToken_Nectia__c = tokenActualizado;

                BoolTokenActualizado = true;
                update usuarioParaActualizar;
        }
    ///*
    //public pageReference saveAndClose(){
    //System.debug('tipo->'+nuevoCaso.Type);
    //if (nuevoCaso.Type != 'Reclamo'){
    //nuevoCaso.Status ='Cerrado';
    //nuevoCaso.Comments = 'Caso cerrado en la punta';
    //nuevoCaso.Tipo_de_cierre_Nectia__c = 'Caso cerrado en la punta';
    //if(tipoRegistro == 'Casos_Seguros'){
    //nuevoCaso.Type = nuevoCaso.Tipo_Auxiliar__c;
    //nuevoCaso.Subtipo__c = nuevoCaso.Subtipo_Auxiliar__c;
    //nuevoCaso.Valores_Nectia__c = nuevoCaso.Tipo_de_producto_banco__c;
    //}
    //
    //if(!test.isRunningTest()){
    //insert nuevoCaso;
    //pageReference p = new PageReference('/'+nuevoCaso.Id);
    //return p;
    //}else{
    //return null;
    //}
    //}else{
    ////ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Reclamos no deben ser cerrados en la creaciÃ³n');
    ////ApexPages.addMessages(myMsg);
    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'','Reclamos no deben ser cerrados en la creaciÃ³n'));
    //return null;
    //}
    //}
    //public pageReference saveAndSee(){
    ////CÃDIGO NECESARIO PARA QUE SE EJECUTEN LAS REGLAS DE ASIGNACIÃN
    //AssignmentRule AR = new AssignmentRule();
    //AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
    //
    ////Creating the DMLOptions for "Assign using active assignment rules" checkbox
    //Database.DMLOptions dmlOpts = new Database.DMLOptions();
    //dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
    //
    ////Setting the DMLOption on Case instance
    //nuevoCaso.setOptions(dmlOpts);
    //if(tipoRegistro == 'Casos_Seguros'){
    //nuevoCaso.Type = nuevoCaso.Tipo_Auxiliar__c;
    //
    //nuevoCaso.Subtipo__c = nuevoCaso.Subtipo_Auxiliar__c;
    //nuevoCaso.Valores_Nectia__c = nuevoCaso.Tipo_de_producto_banco__c;
    //
    //}
    //if(!test.isRunningTest()){
    //try{
    //insert nuevoCaso;
    //pageReference p = new PageReference('/'+nuevoCaso.Id);
    //return p;
    //}catch(Exception ex){
    //ApexPages.addMessages(ex);
    //return null;
    //}
    //}else{
    //return null;
    //}
    //}
    //
    //public pageReference cerrar(){
    ////PageReference p = new PageReference('/'+record.id);
    //PageReference p = new PageReference('/'+record.Cliente_Nectia__c);
    ////pageReference p = new PageReference('/');
    //p.setRedirect(true); 
    //return p;
    ////return null;
    //
    //}
    //*/
    
}