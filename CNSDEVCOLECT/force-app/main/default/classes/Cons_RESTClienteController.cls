@RestResource(urlMapping='/Cliente/*')  //  https://xxx.salesforce.com/services/apexrest/Cliente/CrearActuaizarCuenta
global with sharing  class Cons_RESTClienteController {
    
    
    
    
    @HttpPost
    global static Cons_Respuesta_JSON  CrearActuaizarCuenta(Cons_EstructuraCliente_JSON cuenta) { 
        Account  ac=new Account();
        Cons_Respuesta_JSON  res=new Cons_Respuesta_JSON();
        system.debug('JSON entrada='+cuenta);
        try{
            for(integer  i=0; i<cuenta.Clientes.size();i++){
                boolean cuentaingresada=false;
                
                list<AggregateResult> cantidad2=[select Count(RUT__c) total from Account where RUT__c=:cuenta.Clientes.get(i).RUT ];
               
                integer tipooperacion2= integer.valueOf(cantidad2[0].get('total'));
                if((tipooperacion2 == 0 )){
                    system.debug('Cliente no existe');
                    if(cuenta.Clientes.get(i).Estado=='Prospecto'){
                        //------------------cracion de cliente prospecto nuevo----------------//
                        ac.RecordTypeId=[SELECT Id, Name FROM RecordType where name='Cliente Nuevo'].id;
                        ac.FirstName=cuenta.Clientes.get(i).Nombrecompleto;
                        
                        ac.LastName=cuenta.Clientes.get(i).PrimerApellido;
                        ac.Segundo_Apellido_Nectia__pc=cuenta.Clientes.get(i).SegundoApellido;
                        
                        ac.RUT__c=cuenta.Clientes.get(i).RUT;
                        ac.Segmento_Nectia__c=cuenta.Clientes.get(i).Segmento;
                        ac.Phone=cuenta.Clientes.get(i).Telefono;
                        ac.PersonOtherPhone=cuenta.Clientes.get(i).TelefonoOtro;
                       ac.PersonEmail=cuenta.Clientes.get(i).Correoelectronico;
                        ac.Nacionalidad_Nectia__pc=cuenta.Clientes.get(i).Nacionalidad;
                        ac.PersonBirthdate=date.valueOf(cuenta.Clientes.get(i).Fechadenacimiento);
                        ac.Estado_Civil_Nectia__pc=cuenta.Clientes.get(i).EstadoCivil;
                        ac.Genero_Nectia__pc=cuenta.Clientes.get(i).Genero;
                        ac.R_gimen_conyugal_Nectia__pc=cuenta.Clientes.get(i).Regimenconyugal;
                        ac.Profesi_n_Nectia__pc=cuenta.Clientes.get(i).Profesion;
                        ac.cargo__pc=cuenta.Clientes.get(i).cargo;
                        ac.Raz_n_Social_Empleador_Nectia__pc=cuenta.Clientes.get(i).razonsocialempleador;
                        ac.Renta_Nectia__pc=cuenta.Clientes.get(i).renta;
                        ac.Estado_Nectia__c=cuenta.Clientes.get(i).Estado;
                        //ac.Sub_estado_Nectia__pc=cuenta.Clientes.get(i).Subestado;
                        ac.Codigo_de_Agente_Nectia__pc=cuenta.Clientes.get(i).CodigodeAgente;
                        ac.Agente_Nectia__pc=cuenta.Clientes.get(i).Agente;
                        ac.Plantilla_de_Comision_Nectia__pc=cuenta.Clientes.get(i).PlantilladeComision;
                        ac.Simult_neas_Nectia__pc=cuenta.Clientes.get(i).Simultaneas==1?true:false;
                        ac.NCG_380_Nectia__pc=cuenta.Clientes.get(i).NCG380==1?true:false;
                        ac.PEP_Nectia__pc=cuenta.Clientes.get(i).PEP==1?true:false;
                        ac.US_Person_Entity_Nectia__pc=cuenta.Clientes.get(i).US_PersonEntity==1?true:false;
                        ac.CRS_OCDE_Nectia__pc=cuenta.Clientes.get(i).crs==1?true:false;
                        ac.ID_Nectia__c=string.valueOf(cuenta.Clientes.get(i).ID);
                        ac.BillingStreet=cuenta.Clientes.get(i).direccion;
                        ac.BillingCity=cuenta.Clientes.get(i).ciudad;
                        ac.BillingState=cuenta.Clientes.get(i).region;
                        ac.BillingCountry=cuenta.Clientes.get(i).pais;
                        ac.Cliente_Corredora__c=true;
                        ac.Sub_estado_Nectia__c=cuenta.Clientes.get(i).Subestado;
                        ac.Fecha_de_Incorporacion_Nectia__c=cuenta.Clientes.get(i).fechaincorporacion==null?null:date.valueOf(cuenta.Clientes.get(i).fechaincorporacion);
                        
                        system.debug('ac='+ac);
                        insert ac;
                        cuentaingresada=true;
                    }else  if(cuenta.Clientes.get(i).Tipo=='Cliente Persona Corredora' || cuenta.Clientes.get(i).Tipo=='0' || cuenta.Clientes.get(i).Tipo=='Cuenta Personal'   ){
                        system.debug('Cliente Persona Corredora');
                        //-----------------cliente persona-------------------------------//
                        ac.RecordTypeId=[SELECT Id, Name FROM RecordType where name='Cliente Persona Corredora'].id;
                        ac.FirstName=cuenta.Clientes.get(i).Nombrecompleto;
                        
                        ac.LastName=cuenta.Clientes.get(i).PrimerApellido;
                        ac.Segundo_Apellido_Nectia__pc=cuenta.Clientes.get(i).SegundoApellido;
                        ac.Sub_estado_Nectia__c=cuenta.Clientes.get(i).Subestado;
                        ac.RUT__c=cuenta.Clientes.get(i).RUT;
                        ac.Segmento_Nectia__c=cuenta.Clientes.get(i).Segmento;
                        ac.Phone=cuenta.Clientes.get(i).Telefono;
                        ac.PersonOtherPhone=cuenta.Clientes.get(i).TelefonoOtro;
                       ac.PersonEmail=cuenta.Clientes.get(i).Correoelectronico;
                        ac.Nacionalidad_Nectia__pc=cuenta.Clientes.get(i).Nacionalidad;
                        ac.PersonBirthdate=date.valueOf(cuenta.Clientes.get(i).Fechadenacimiento);
                        ac.Estado_Civil_Nectia__pc=cuenta.Clientes.get(i).EstadoCivil;
                        ac.Genero_Nectia__pc=cuenta.Clientes.get(i).Genero;
                        ac.R_gimen_conyugal_Nectia__pc=cuenta.Clientes.get(i).Regimenconyugal;
                        ac.Profesi_n_Nectia__pc=cuenta.Clientes.get(i).Profesion;
                        ac.cargo__pc=cuenta.Clientes.get(i).cargo;
                        ac.Raz_n_Social_Empleador_Nectia__pc=cuenta.Clientes.get(i).razonsocialempleador;
                        ac.Renta_Nectia__pc=cuenta.Clientes.get(i).renta;
                        ac.Estado_Nectia__c=cuenta.Clientes.get(i).Estado;
                        //ac.Sub_estado_Nectia__pc=cuenta.Clientes.get(i).Subestado;
                        ac.Codigo_de_Agente_Nectia__pc=cuenta.Clientes.get(i).CodigodeAgente;
                        ac.Agente_Nectia__pc=cuenta.Clientes.get(i).Agente;
                        ac.Plantilla_de_Comision_Nectia__pc=cuenta.Clientes.get(i).PlantilladeComision;
                        ac.Simult_neas_Nectia__pc=cuenta.Clientes.get(i).Simultaneas==1?true:false;
                        ac.NCG_380_Nectia__pc=cuenta.Clientes.get(i).NCG380==1?true:false;
                        ac.PEP_Nectia__pc=cuenta.Clientes.get(i).PEP==1?true:false;
                        ac.US_Person_Entity_Nectia__pc=cuenta.Clientes.get(i).US_PersonEntity==1?true:false;
                        ac.CRS_OCDE_Nectia__pc=cuenta.Clientes.get(i).crs==1?true:false;
                        ac.ID_Nectia__c=string.valueOf(cuenta.Clientes.get(i).ID);
                        ac.BillingStreet=cuenta.Clientes.get(i).direccion;
                        ac.BillingCity=cuenta.Clientes.get(i).ciudad;
                        ac.BillingState=cuenta.Clientes.get(i).region;
                        ac.BillingCountry=cuenta.Clientes.get(i).pais;
                        ac.Cliente_Corredora__c=true;
                        ac.Fecha_de_Incorporacion_Nectia__c=cuenta.Clientes.get(i).fechaincorporacion==null?null:date.valueOf(cuenta.Clientes.get(i).fechaincorporacion);
                        
                        system.debug('ac='+ac);
                        insert ac;
                        cuentaingresada=true;
                        //---------------------------------------------------//
                    }else if (cuenta.Clientes.get(i).Tipo=='Cliente Empresa Corredora' || cuenta.Clientes.get(i).Tipo=='1'){
                        //-----------------cliente empresa-------------------------------//
                        ac.RecordTypeId=[SELECT Id, Name FROM RecordType where name='Cliente Empresa Corredora'].id;
                        ac.Name=cuenta.Clientes.get(i).Nombrecompleto;
                        
                        ac.Segmento_Nectia__c=cuenta.Clientes.get(i).Segmento;
                        ac.Phone=cuenta.Clientes.get(i).Telefono;
                        ac.Perfil_Inversionista_Nectia__c=cuenta.Clientes.get(i).perfilinv;
                        ac.Cliente_Corredora__c=true;
                        ac.Autoriza_uso_de_datos__c=false;
                        ac.Estado_Nectia__c=cuenta.Clientes.get(i).Estado;
                        ac.Sub_estado_Nectia__c=cuenta.Clientes.get(i).Subestado;
                        ac.Codigo_de_Agente_Nectia__c=cuenta.Clientes.get(i).CodigodeAgente;
                        ac.RUT__c=cuenta.Clientes.get(i).RUT;
                        ac.BillingStreet=cuenta.Clientes.get(i).direccion;
                        ac.BillingCity=cuenta.Clientes.get(i).ciudad;
                        ac.BillingState=cuenta.Clientes.get(i).region;
                        ac.BillingCountry=cuenta.Clientes.get(i).pais;
                        ac.Fecha_de_Incorporacion_Nectia__c=cuenta.Clientes.get(i).fechaincorporacion==null?null:date.valueOf(cuenta.Clientes.get(i).fechaincorporacion);
                        system.debug('ac='+ac);
                        insert ac;
                        cuentaingresada=true;
                        //--------------------------------------------//
                        //---------------------------actualizacion se contacto  para enpresa --------------------------//
                        system.debug('cuenta.Clientes.get(i).contactos'+cuenta.Clientes.get(i).contactos);
                        if(cuenta.Clientes.get(i).contactos!=null){
                        if(cuenta.Clientes.get(i).contactos.size()>0){    
                            list<AggregateResult> existecontac=   [SELECT count(name) total  FROM Contact where RUT_Nectia__c=:cuenta.Clientes.get(i).contactos.get(0).Rutcontacto ];
                            Contact ct=new Contact();
                            if(existecontac[0].get('total')==0){
                                ct.FirstName=cuenta.Clientes.get(i).contactos.get(0).nombrecontacto;
                                ct.LastName=cuenta.Clientes.get(i).contactos.get(0).apellidocontacto;
                                ct.AccountId=ac.id;
                                ct.MailingStreet=cuenta.Clientes.get(i).direccion;
                                ct.MailingCity=cuenta.Clientes.get(i).ciudad;
                                ct.MailingState=cuenta.Clientes.get(i).region;
                                ct.MailingCountry=cuenta.Clientes.get(i).pais;
                                ct.Phone=cuenta.Clientes.get(i).Telefono;
                                ct.MobilePhone=cuenta.Clientes.get(i).contactos.get(0).telefonomovil;
                                ct.Email=cuenta.Clientes.get(i).Correoelectronico;
                                ct.cargo__c=cuenta.Clientes.get(i).contactos.get(0).Cargo;
                                ct.Genero_Nectia__c=cuenta.Clientes.get(i).contactos.get(0).Genero;
                                ct.RUT_Nectia__c=cuenta.Clientes.get(i).contactos.get(0).Rutcontacto;
                                insert ct;
                                system.debug('contacto no existe ct'+ct); 
                            }else{
                                ct=   [SELECT FirstName, LastName, Id, AccountId, MailingStreet, MailingCity, MailingState, MailingCountry, Phone, MobilePhone, Email, Title, Department FROM Contact where RUT_Nectia__c=:cuenta.Clientes.get(i).contactos.get(0).Rutcontacto ];
                                system.debug('contacto existe ct'+ct); 
                                list<AggregateResult> relacioncclientecontacto=   [SELECT count(id) total  FROM AccountContactRelation where AccountId=:ac.id and ContactId=:ct.id];
                                if(relacioncclientecontacto[0].get('total')==0){
                                    AccountContactRelation  acccout=new AccountContactRelation();
                                    acccout.AccountId=ac.id;
                                    acccout.ContactId=ct.id;
                                    insert acccout;
                                }
                            }
                        }
                        }
                        //--------------------------------------------//
                    }
                    
                    
                    //--------------------insercion de producto------------------------//  
                     if(cuenta.Clientes.get(i).productos!=null){ 
                    for(integer t=0;t<cuenta.Clientes.get(i).productos.size();t++){
                        system.debug('producto'+cuenta.Clientes.get(i).productos);
                        list<AggregateResult> existeproducto=[ select Count(Codigo_de_producto_corredora__c) total FROM Producto_de_Corredora__c 
                                                              where Codigo_de_producto_corredora__c=:decimal.valueOf(cuenta.Clientes.get(i).productos.get(t).codigo) ];
                        system.debug('existeproducto'+existeproducto);
                        Producto_de_Corredora__c pro =new Producto_de_Corredora__c(); 
                        if(existeproducto[0].get('total')==0){
                            //--------------------insercion de producto- corredora nuevo-----------------------//  
                            pro.Estado_Nectia__c=cuenta.Clientes.get(i).productos.get(t).estado;
                            pro.Tipo_Nectia__c=cuenta.Clientes.get(i).productos.get(t).tipo;
                            //pro.Producto__c=cuenta.Clientes.get(i).productos.get(t).producto;
                            pro.name=cuenta.Clientes.get(i).productos.get(t).tipo;//codigo de producto
                            pro.Codigo_de_producto_corredora__c=decimal.valueOf(cuenta.Clientes.get(i).productos.get(t).codigo);
                            insert pro;
                            //--------------------------------------------------------- ----------------------//  
                        }else{
                            //--------------------busqueda producto corredora antiguo  ----------------------//  
                            pro =[select id  FROM Producto_de_Corredora__c where Codigo_de_producto_corredora__c=:decimal.valueOf(cuenta.Clientes.get(i).productos.get(t).codigo) limit 1];              
                            //--------------------------------------------------------- ----------------------//  
                        }
                        system.debug('pro'+pro);
                        
                        
                        list<AggregateResult> existeproductocliente=[ select Count(Id__c) total FROM Producto_del_Cliente__c 
                                                                     where Id__c=:cuenta.Clientes.get(i).productos.get(t).id];
                        system.debug('existeproductocliente'+existeproductocliente);
                        Producto_del_Cliente__c proc =new Producto_del_Cliente__c();
                        if(existeproductocliente[0].get('total')==0){
                            proc.Cliente_Nectia__c=ac.id;
                            proc.name=cuenta.Clientes.get(i).productos.get(t).producto+cuenta.Clientes.get(i).productos.get(t).secuencia;
                            proc.Producto_de_Corredora_Nectia__c=pro.id;
                            proc.Id__c=cuenta.Clientes.get(i).productos.get(t).id;
                            proc.Estado_Nectia__c=cuenta.Clientes.get(i).productos.get(t).estado;
                            proc.Fecha_de_apertura_Nectia__c=date.valueOf(cuenta.Clientes.get(i).productos.get(t).fecha);
                            proc.RecordTypeId=[ SELECT Id, Name, SobjectType FROM RecordType where name=:'Producto cliente Corredora'].id;
                            proc.Secuencia_Nectia__c=cuenta.Clientes.get(i).productos.get(t).secuencia;
                            system.debug('proc==='+proc);
                            
                            insert proc;
                            system.debug('proc==='+proc);
                        }
                    }
                     }
                    //------------------------------------------------//         
                    
                    
                    if(cuentaingresada==true){
                        res.rut= cuenta.Clientes.get(i).RUT ;
                    res.mensaje='Cliente  ingresado  en  salesforce ';
                    res.estado='ingresado'; 
                    res.codigo='0'; 
                    }else{
                          res.rut= cuenta.Clientes.get(i).RUT ;
                    res.mensaje='se a producido un error  al momento de ingresar el cliente';
                    res.estado='ingresado'; 
                    res.codigo='1'; 
                    }
                    
                    
                }else if(tipooperacion2 > 0 ){
                    //---------------------------------------------------------------actualisa cliente persona o empresa ----------------//
                    system.debug('Cliente  existe');
                    
                    
                    
                    
                    if(cuenta.Clientes.get(i).Tipo=='Cliente Persona Corredora'|| cuenta.Clientes.get(i).Tipo=='Cuenta Personal' || cuenta.Clientes.get(i).Tipo=='0' || cuenta.Clientes.get(i).Estado=='Prospecto' ){
                        //---------------update--cliente persona-------------------------------// 
                        ac= [select id,Agente_Nectia__pc,Clasificaci_n_Riesgo_Nectia__pc,Codigo_de_Agente_Nectia__pc,
                             Autorizo_uso_de_datos_nectia__pc ,Estado_Civil_Nectia__pc,FATCA_Nectia__pc,Genero_Nectia__pc,ID_Nectia__c,Nacionalidad_Nectia__pc,
                             NCG_380_Nectia__pc,PEP_Nectia__pc,Plantilla_de_Comision_Nectia__pc,Fecha_de_Incorporacion_Nectia__c,
                             LastName,Profesi_n_Nectia__pc,R_gimen_conyugal_Nectia__pc,Segmento_Nectia__c,Sub_estado_Nectia__c,
                             Segundo_Apellido_Nectia__pc,Simult_neas_Nectia__pc,Sub_estado_Nectia__pc,PersonOtherPhone,Estado_Nectia__c,
                             US_Person_Entity_Nectia__pc,PersonEmail,PersonMobilePhone,Phone,PersonBirthdate,FirstName,PersonHomePhone,fax,Codigo_de_Agente_Nectia__c,RecordTypeId,
                             RUT__c,BillingCountry,BillingState,BillingCity,BillingStreet,Cliente_Corredora__c  
                             from Account where RUT__c=:cuenta.Clientes.get(i).RUT ];
                        system.debug('ac'+ac);    
                        system.debug('Cliente Persona Corredora');
                        
                       //ac.RecordTypeId=[SELECT Id, Name FROM RecordType where name='Cliente Persona Corredora'].id;
                        //ac.FirstName=cuenta.Clientes.get(i).Nombrecompleto;
                        
                        //ac.LastName=cuenta.Clientes.get(i).PrimerApellido;
                        ac.Segundo_Apellido_Nectia__pc=cuenta.Clientes.get(i).SegundoApellido;
                        
                        //ac.RUT__c=cuenta.Clientes.get(i).RUT;
                        ac.Segmento_Nectia__c=cuenta.Clientes.get(i).Segmento;
                        ac.Phone=cuenta.Clientes.get(i).Telefono;
                        ac.PersonOtherPhone=cuenta.Clientes.get(i).TelefonoOtro;
                       ac.PersonEmail=cuenta.Clientes.get(i).Correoelectronico;
                        ac.Nacionalidad_Nectia__pc=cuenta.Clientes.get(i).Nacionalidad;
                        ac.PersonBirthdate=date.valueOf(cuenta.Clientes.get(i).Fechadenacimiento);
                        ac.Estado_Civil_Nectia__pc=cuenta.Clientes.get(i).EstadoCivil;
                        ac.Genero_Nectia__pc=cuenta.Clientes.get(i).Genero;
                        ac.R_gimen_conyugal_Nectia__pc=cuenta.Clientes.get(i).Regimenconyugal;
                        ac.Profesi_n_Nectia__pc=cuenta.Clientes.get(i).Profesion;
                        ac.cargo__pc=cuenta.Clientes.get(i).cargo;
                        ac.Raz_n_Social_Empleador_Nectia__pc=cuenta.Clientes.get(i).razonsocialempleador;
                        ac.Renta_Nectia__pc=cuenta.Clientes.get(i).renta;
                        ac.Estado_Nectia__c=cuenta.Clientes.get(i).Estado;
                        ac.Sub_estado_Nectia__c=cuenta.Clientes.get(i).Subestado;
                        ac.Codigo_de_Agente_Nectia__pc=cuenta.Clientes.get(i).CodigodeAgente;
                        ac.Agente_Nectia__pc=cuenta.Clientes.get(i).Agente;
                        ac.Plantilla_de_Comision_Nectia__pc=cuenta.Clientes.get(i).PlantilladeComision;
                        ac.Simult_neas_Nectia__pc=cuenta.Clientes.get(i).Simultaneas==1?true:false;
                        ac.NCG_380_Nectia__pc=cuenta.Clientes.get(i).NCG380==1?true:false;
                        ac.PEP_Nectia__pc=cuenta.Clientes.get(i).PEP==1?true:false;
                        ac.US_Person_Entity_Nectia__pc=cuenta.Clientes.get(i).US_PersonEntity==1?true:false;
                        ac.CRS_OCDE_Nectia__pc=cuenta.Clientes.get(i).crs==1?true:false;
                        ac.ID_Nectia__c=string.valueOf(cuenta.Clientes.get(i).ID);
                        ac.BillingStreet=cuenta.Clientes.get(i).direccion;
                        ac.BillingCity=cuenta.Clientes.get(i).ciudad;
                        ac.BillingState=cuenta.Clientes.get(i).region;
                        ac.BillingCountry=cuenta.Clientes.get(i).pais;
                        ac.Cliente_Corredora__c=true;
                        ac.Codigo_de_Agente_Nectia__c=cuenta.Clientes.get(i).CodigodeAgente;
                        ac.Fecha_de_Incorporacion_Nectia__c=cuenta.Clientes.get(i).fechaincorporacion==null?null:date.valueOf(cuenta.Clientes.get(i).fechaincorporacion);
                        system.debug('ac='+ac);
                        
                        update ac;
                       
                        
                        
                    }else if (cuenta.Clientes.get(i).Tipo=='Cliente Empresa Corredora' || cuenta.Clientes.get(i).Tipo=='Cuenta Empresa' || cuenta.Clientes.get(i).Tipo=='1' ){
                        system.debug('ac.'+ac);
                        //-----------------update cliente empresa-------------------------------//
                        ac=[select id, RecordTypeId,name,Phone,Perfil_Inversionista_Nectia__c,Cliente_Corredora__c,Autoriza_uso_de_datos__c,
                            Estado_Nectia__c,Segmento_Nectia__c,Sub_estado_Nectia__c, RUT__c,BillingCountry,BillingState,BillingCity,BillingStreet,Fecha_de_Incorporacion_Nectia__c 
                            from Account where RUT__c=:cuenta.Clientes.get(i).RUT];
                        
                        
                        ac.Segmento_Nectia__c=cuenta.Clientes.get(i).Segmento;
                        ac.Phone=cuenta.Clientes.get(i).Telefono;
                        ac.Cliente_Corredora__c=true;
                        ac.Autoriza_uso_de_datos__c=false;
                        ac.Estado_Nectia__c=cuenta.Clientes.get(i).Estado;
                        ac.Sub_estado_Nectia__c=cuenta.Clientes.get(i).Subestado;
                        ac.Codigo_de_Agente_Nectia__c=cuenta.Clientes.get(i).CodigodeAgente;
                        ac.BillingStreet=cuenta.Clientes.get(i).direccion;
                        ac.BillingCity=cuenta.Clientes.get(i).ciudad;
                        ac.BillingState=cuenta.Clientes.get(i).region;
                        ac.BillingCountry=cuenta.Clientes.get(i).pais;
                        ac.Fecha_de_Incorporacion_Nectia__c=cuenta.Clientes.get(i).fechaincorporacion==null?null:date.valueOf(cuenta.Clientes.get(i).fechaincorporacion);
                        system.debug('ac='+ac);
                        
                        update ac;
                        
                        //---------------------------actualizacion se contacto  para enpresa --------------------------//
                        
                        if(cuenta.Clientes.get(i).contactos.size()>0){    
                            list<AggregateResult> existecontac=   [SELECT count(name) total  FROM Contact where RUT_Nectia__c=:cuenta.Clientes.get(i).contactos.get(0).Rutcontacto ];
                            Contact ct=new Contact();
                            if(existecontac[0].get('total')==0){
                                
                                ct.FirstName=cuenta.Clientes.get(i).contactos.get(0).nombrecontacto;
                                ct.LastName=cuenta.Clientes.get(i).contactos.get(0).apellidocontacto;
                                ct.AccountId=ac.id;
                                ct.MailingStreet=cuenta.Clientes.get(i).direccion;
                                ct.MailingCity=cuenta.Clientes.get(i).ciudad;
                                ct.MailingState=cuenta.Clientes.get(i).region;
                                ct.MailingCountry=cuenta.Clientes.get(i).pais;
                                ct.Phone=cuenta.Clientes.get(i).Telefono;
                                ct.MobilePhone=cuenta.Clientes.get(i).contactos.get(0).telefonomovil;
                                ct.Email=cuenta.Clientes.get(i).Correoelectronico;
                                ct.cargo__c=cuenta.Clientes.get(i).contactos.get(0).Cargo;
                                ct.Genero_Nectia__c=cuenta.Clientes.get(i).contactos.get(0).Genero;
                                ct.RUT_Nectia__c=cuenta.Clientes.get(i).contactos.get(0).Rutcontacto;
                                system.debug('ct'+ct);
                                insert ct;
                                
                            }else{
                                ct=   [SELECT FirstName, LastName, Id, AccountId, MailingStreet, MailingCity, MailingState, MailingCountry, Phone, MobilePhone, Email, Title, Department FROM Contact where RUT_Nectia__c=:cuenta.Clientes.get(i).contactos.get(0).Rutcontacto];
                                list<AggregateResult> relacioncclientecontacto=   [SELECT count(id) total  FROM AccountContactRelation where AccountId=:ac.id and ContactId=:ct.id];
                                if(relacioncclientecontacto[0].get('total')==0){
                                    AccountContactRelation  acccout=new AccountContactRelation();
                                    acccout.AccountId=ac.id;
                                    acccout.ContactId=ct.id;
                                    insert acccout;
                                }
                            }
                        }
                        //--------------------------------------------//
                    }
                    //---------------------------actualizacion de producto  o inserta producto --------------------------//
                    if(cuenta.Clientes.get(i).productos!=null){
                    for(integer t=0;t<cuenta.Clientes.get(i).productos.size();t++){
                        system.debug('producto'+cuenta.Clientes.get(i).productos);
                        list<AggregateResult> existeproducto=[ select Count(Codigo_de_producto_corredora__c) total FROM Producto_de_Corredora__c 
                                                              where Codigo_de_producto_corredora__c=:decimal.valueOf(cuenta.Clientes.get(i).productos.get(t).codigo) ];
                        system.debug('existeproducto'+existeproducto);
                        Producto_de_Corredora__c pro =new Producto_de_Corredora__c(); 
                        if(existeproducto[0].get('total')==0){
                            
                            pro.Estado_Nectia__c=cuenta.Clientes.get(i).productos.get(t).estado;
                            pro.Tipo_Nectia__c=cuenta.Clientes.get(i).productos.get(t).tipo;
                            pro.name=cuenta.Clientes.get(i).productos.get(t).tipo;//codigo de producto
                            pro.Codigo_de_producto_corredora__c=decimal.valueOf(cuenta.Clientes.get(i).productos.get(t).codigo);
                            insert pro;
                            
                        }else{
                            pro =[select id  FROM Producto_de_Corredora__c where Codigo_de_producto_corredora__c=:decimal.valueOf(cuenta.Clientes.get(i).productos.get(t).codigo) limit 1];                
                        }
                        system.debug('pro'+pro);
                        
                        
                        list<AggregateResult> existeproductocliente=[ select Count(Id__c) total FROM Producto_del_Cliente__c 
                                                                     where Id__c=:cuenta.Clientes.get(i).productos.get(t).id];
                        system.debug('existeproductocliente'+existeproductocliente);
                        Producto_del_Cliente__c proc =new Producto_del_Cliente__c();
                        if(existeproductocliente[0].get('total')==0){
                            proc.Cliente_Nectia__c=ac.id;
                            proc.name=cuenta.Clientes.get(i).productos.get(t).producto+cuenta.Clientes.get(i).productos.get(t).secuencia;
                            proc.Producto_de_Corredora_Nectia__c=pro.id;
                            proc.Id__c=cuenta.Clientes.get(i).productos.get(t).id;
                            proc.Estado_Nectia__c=cuenta.Clientes.get(i).productos.get(t).estado;
                            proc.Fecha_de_apertura_Nectia__c=date.valueOf(cuenta.Clientes.get(i).productos.get(t).fecha);
                            proc.RecordTypeId=[ SELECT Id, Name, SobjectType FROM RecordType where name=:'Producto cliente Corredora'].id;
                            proc.Secuencia_Nectia__c=cuenta.Clientes.get(i).productos.get(t).secuencia;
                            system.debug('proc==='+proc);
                            
                            insert proc;
                            
                        }else{
                            proc  =  [ select id,Cliente_Nectia__c,name,Producto_de_Corredora_Nectia__c,Id__c,Estado_Nectia__c,Fecha_de_apertura_Nectia__c,RecordTypeId 
                                      FROM Producto_del_Cliente__c  where Id__c=:cuenta.Clientes.get(i).productos.get(t).id];
                            
                            proc.Cliente_Nectia__c=ac.id;
                            proc.name=cuenta.Clientes.get(i).productos.get(t).producto;
                            proc.Producto_de_Corredora_Nectia__c=pro.id;
                            proc.Id__c=cuenta.Clientes.get(i).productos.get(t).id;
                            proc.Estado_Nectia__c=cuenta.Clientes.get(i).productos.get(t).estado;
                            proc.Fecha_de_apertura_Nectia__c=date.valueOf(cuenta.Clientes.get(i).productos.get(t).fecha);
                            proc.RecordTypeId=[ SELECT Id, Name, SobjectType FROM RecordType where name=:'Producto cliente Corredora'].id;
                            system.debug('proc==='+proc);
                            
                            update proc;
                            
                            
                        }
                    }
                    }
                    
                    
                    
                    //-----------------------------------------------------//
                    res.rut= cuenta.Clientes.get(i).RUT ;
                    res.mensaje='Cliente  actualizado  en  salesforce ';
                    res.estado='actualizado'; 
                    res.codigo='0';  
                }
                
                
                
                
                
                
            }
       }catch(QueryException e){
            
            res.rut= cuenta.Clientes.get(0).RUT ;
            res.mensaje='a ocurrido un error interno al momento de ingresar la solicitud';
            res.estado='error'; 
            res.codigo='1'; 
            system.debug('e'+e);
        }
        
        
        return res;
    }
    
    
    
    
    
}