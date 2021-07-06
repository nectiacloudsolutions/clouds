@RestResource(urlMapping='/productoBanco/*')  //  https://xxx.salesforce.com/services/apexrest/productoBanco/CrearActuaizarproductoclienteBanco
global with sharing  class CONS_RESTProductoBancoController {

    
    @HttpPost
    global static Cons_Respuestaproducto_JSON  CrearActuaizarproductoclienteBanco(list<CONS_EstructuraproductoBanco_JSON> producto) { 
        Cons_Respuestaproducto_JSON res=new Cons_Respuestaproducto_JSON();
        list<string>  buscaproducto=new list<string>();
        list<Producto_del_Cliente__c>  actualizarproduc=new list<Producto_del_Cliente__c>();
        list<Producto_del_Cliente__c>  insertarproduc=new list<Producto_del_Cliente__c>();
        for(integer i=0;i<producto.size();i++){
            buscaproducto.add(producto.get(i).id_operacion);
        }
        list<Producto_del_Cliente__c> productoex =[SELECT Id,Id__c,Fecha_de_apertura_Nectia__c, Name, Cliente_Nectia__c, Producto_de_Banco_Nectia__c, Rut_del_Cliente__c,Estado_Nectia__c 
                                             FROM Producto_del_Cliente__c WHERE Id__c in:buscaproducto];
        system.debug('productoex'+productoex);
        integer contadorantiguo=0 ;
        integer contadornuevo=0 ;
       // string recortype='';
        try{
        string recortypeproducto=[SELECT Id, Name FROM RecordType where DeveloperName='Producto_cliente_Banco'].id;
    
        for(integer i=0;i<producto.size();i++){
           for(integer j=0;j<productoex.size();j++){
                if(producto.get(i).id_operacion ==productoex.get(j).Id__c){
                    contadorantiguo ++; 
                    contadornuevo ++; 
                }
                if(contadorantiguo>0){
                  Producto_del_Cliente__c prod=new Producto_del_Cliente__c();
                    prod.id=productoex.get(j).id;
                    prod.id__c=productoex.get(j).id__c;
                   // prod.name=productoex.get(j).name;
                    prod.Producto_de_Banco_Nectia__c=productoex.get(j).Producto_de_Banco_Nectia__c;
                    //prod.RecordTypeId=recortypeproducto;
                    prod.Estado_Nectia__c=producto.get(i).estado;
                    prod.Cliente_Nectia__c=productoex.get(j).Cliente_Nectia__c;
                    actualizarproduc.add(prod);
                    contadorantiguo=0;
                }
            }
             if(contadornuevo==0){
               system.debug('producto.get(i).id_producto'+producto.get(i).id_producto);
                 try{
                Producto_Banco__c   idproductobanco=[SELECT Id,name FROM Producto_Banco__c WHERE Id_Interno_Nectia__c =:producto.get(i).id_producto limit 1];
                 
                 string idclientebanco=[select id  from account where RUT__c =:producto.get(i).rut_cliente limit 1].id;
                 Producto_del_Cliente__c prod=new Producto_del_Cliente__c();
                  //  prod.id=productoex.get(j).id;
                   string rr=producto.get(i).id_operacion;
                      system.debug('producto.get(i).id_operacion'+rr.length());
                     string idop=rr.substring(rr.length()-3,rr.length());
                   
                    system.debug('producto.get(i).id_operacion'+idop);
                    prod.id__c=producto.get(i).id_operacion;
                    prod.name=idproductobanco.name+' '+idop;
                    prod.Producto_de_Banco_Nectia__c=idproductobanco.id;
                    prod.RecordTypeId=recortypeproducto;
                    prod.Estado_Nectia__c=producto.get(i).estado;
                    prod.Cliente_Nectia__c=idclientebanco;
                     system.debug('prod'+prod);
                    insertarproduc.add(prod);
                    contadornuevo=0;
                  }catch(Exception e){
                    res.codigo='1';
                   res.mensage='producto banco no encontrado';      
                 }
             }else{
                  contadornuevo=0; 
             }
            }
         
            try{
            if(insertarproduc.size()>0){
               
         insert insertarproduc;
                system.debug('insertarproduc'+insertarproduc);
            }
            if(actualizarproduc.size()>0){
         update actualizarproduc;
                   system.debug('actualizarproduc'+actualizarproduc);
            }
       res.codigo='0';
       res.mensage='Productos  actualizados';    
            }catch(DmlException e){
              res.codigo='1';
            res.mensage='a ocurrido un error al momneto de ingresar la informcion campos no cumplen con parametros salesforce ';       
            }
        }catch(DmlException e){
            system.debug('e'+e);
            res.codigo='1';
            res.mensage='a ocurrido un error al  momento de  actualizar la  informacion idproducto no encontrado';    
        }
        
        
        
            return res;
        }
    }