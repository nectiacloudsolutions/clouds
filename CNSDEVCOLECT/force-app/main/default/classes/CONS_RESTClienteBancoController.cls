@RestResource(urlMapping='/ClienteBanco/*')  //  https://xxx.salesforce.com/services/apexrest/ClienteBanco/CrearActuaizarclientesBanco
global with sharing class CONS_RESTClienteBancoController {
     
    @HttpPost
    global static CONS_Respuestabanco_JSON  CrearActuaizarclientesBanco(list<CONS_EstructuraClienteBanco_JSON> cuenta) { 
        CONS_Respuestabanco_JSON res=new CONS_Respuestabanco_JSON();
        list<string>  buscarut=new list<string>();
        list<Account>  actualizarlist=new list<Account>();
        list<Account>  insertarlist=new list<Account>();
        list<Contact>  contactos=new list<Contact>();
        for(integer i=0;i<cuenta.size();i++){
            buscarut.add(cuenta.get(i).RUT);
        }
        list<Account> clienteex =[select id,RUT__c,FirstName,LastName,name,RecordTypeid  from account where RUT__c  in:buscarut];
        system.debug('clienteex'+clienteex);
        integer contadorantiguo=0 ;
        integer contadornuevo=0 ;
        string recortype='';
        
        string recortypepersona=[SELECT Id, Name FROM RecordType where DeveloperName='Cliente_Persona_Banco'].id;
        string recortypeempresa=[SELECT Id, Name FROM RecordType where DeveloperName='Cliente_Empresa_Banco'].id;
        for(integer i=0;i<cuenta.size();i++){
            if(cuenta.get(i).tipo=='0'){
                recortype=recortypepersona;
            }else if(cuenta.get(i).tipo=='1'){
                recortype=recortypeempresa;
            }
            system.debug('recortype'+recortype);
            for(integer j=0;j<clienteex.size();j++){
                if(cuenta.get(i).RUT ==clienteex.get(j).RUT__c){
                    contadorantiguo ++; 
                    contadornuevo ++; 
                }
                if(contadorantiguo>0){
                    Account  ac=new Account();
                    ac.id=clienteex.get(j).id;
                    if(recortypepersona==clienteex.get(j).RecordTypeid){
                          
                        ac.FirstName=cuenta.get(i).Nombre;
                        ac.LastName=cuenta.get(i).Apellido_paterno +' '+cuenta.get(i).Apellido_materno;
                        ac.PersonEmail=cuenta.get(i).Correoelectronico;
                    }else if(recortypeempresa==clienteex.get(j).RecordTypeid){
                        ac.Name=cuenta.get(i).Nombre;
                    /*    if(cuenta.get(i).Contacto!=null){
                            Contact  con=new Contact(); 
                            con.AccountId=ac.id;
                            con.LastName=cuenta.get(i).Contacto.get(0).Nombre;
                            con.FirstName=cuenta.get(i).Contacto.get(0).Apellido;
                            con.Email=cuenta.get(i).Contacto.get(0).Correoelectronicocontacto;
                            contactos.add(con); 
                        }*/
                        
                        
                    }
                    ac.RUT__c=cuenta.get(i).RUT;
                    ac.Segmento_Nectia__c=null;
                    ac.Phone=cuenta.get(i).Telefono;
                    
                    ac.Cliente_Banco__c=true;
                    
                    actualizarlist.add(ac);
                    contadorantiguo=0;
                    
                    
                    
                }
            }
            if(contadornuevo==0){
                Account  ac=new Account();
                ac.RecordTypeId=recortype;
                if(cuenta.get(i).tipo=='0'){
                    
                    ac.FirstName=cuenta.get(i).Nombre;
                    ac.LastName=cuenta.get(i).Apellido_paterno +' '+cuenta.get(i).Apellido_materno;
                    ac.PersonEmail=cuenta.get(i).Correoelectronico;
                }else if(cuenta.get(i).tipo=='1'){
                    ac.Name=cuenta.get(i).Nombre;
                    
                    
                }
                ac.RUT__c=cuenta.get(i).RUT;
                ac.Segmento_Nectia__c=null;
                ac.Phone=cuenta.get(i).Telefono;
                
                ac.Cliente_Banco__c=true;
                
                insertarlist.add(ac);
                
            }else{
                contadornuevo=0; 
            }
        }
        system.debug('insertarlist'+insertarlist.size());  
        system.debug('insertarlist'+insertarlist);
        
        system.debug('actualizarlist'+actualizarlist.size());     
        system.debug('actualizarlist'+actualizarlist);
        try{
            
            if(insertarlist.size()>0){
                insert insertarlist;
                res.mensaje='Datos ingresados correctamente';  
                res.codigo='0';
                system.debug('insertarlist'+insertarlist);
            }
            if(actualizarlist.size()>0){ 
                update actualizarlist;
                res.mensaje='Datos ingresados correctamente';  
                res.codigo='0';
                system.debug('actualizarlist'+actualizarlist);
                if(insertarlist.size()>0){
                    
                }
            }
            
       /*     
            list<Account> clientesactualizados =[select id,RUT__c,FirstName,LastName,name,RecordTypeid  from account where RUT__c  in:buscarut];  
            list<string>  buscarid=new list<string>();
            for(integer i=0;i<clientesactualizados.size();i++){
                buscarid.add(clientesactualizados.get(i).id);
            }
            string recortypeproductobanco=[SELECT Id, Name FROM RecordType where DeveloperName='Producto_cliente_Banco'].id;
            list<Producto_del_Cliente__c> productoex =[select Id, Name, Cliente_Nectia__c, Rut_del_Cliente__c,Producto_de_Banco_Nectia__r.Id_Interno_Nectia__c   from Producto_del_Cliente__c  where Cliente_Nectia__c   in:buscarid and RecordTypeId =:recortypeproductobanco ];//recortipe perteneciente a producto banco    
            
            for(integer k=0;k<cuenta.size();k++){
                for(integer t=0;t<productoex.size();t++){
                    if(cuenta.get(k).RUT ==productoex.get(t).Rut_del_Cliente__c){
                        if(cuenta.get(k).Productos!=null){
                            for(integer r=0;r<cuenta.get(k).Productos.size();r++){
                          //      for(integer u=0;u<cuenta.get(k).Productos.size();u++){
                                    string idprod=productoex.get(t).Producto_de_Banco_Nectia__r.Id_Interno_Nectia__c;
                                    if(cuenta.get(k).Productos.get(r).id==idprod){
                                        contador++;
                                    }

                             //   }
                            }
                            
                            
                            
                        }
                    }                    
                }  
            }
           */ 
            
            
        }catch(DmlException e){
            system.debug('e'+e);
            res.mensaje='Ocurrido un error iacconterno al momento de cargar la informacion del cliente';  
            res.codigo='1'; 
        }
        return res;
    }
}