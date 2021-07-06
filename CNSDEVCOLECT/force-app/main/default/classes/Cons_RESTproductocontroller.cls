@RestResource(urlMapping='/producto/*')  //  https://bcoconsorcio--devbancorr.cs71.my.salesforce.com/services/apexrest/producto/crearproducto
global with sharing  class Cons_RESTproductocontroller {
    @HttpPost
    global static Cons_estructuraproducto_JSON.respuesta   crearproducto(Cons_estructuraproducto_JSON producto ) { 
        // Cons_estructuraproducto_JSON estprod=new Cons_estructuraproducto_JSON();
        Cons_estructuraproducto_JSON.respuesta estprodresp=new Cons_estructuraproducto_JSON.respuesta();
        list<AggregateResult> cantidad =[select count(rut__c) cantidad from account where rut__c=:producto.rut ];
        if(cantidad[0].get('cantidad')!=0){
            account ac=[select id from account where rut__c=:producto.rut];
            for(integer i=0;i<producto.productos.size();i++){
                system.debug('producto'+producto.productos);
                list<AggregateResult> existeproducto=[ select Count(Codigo_de_producto_corredora__c) total FROM Producto_de_Corredora__c 
                                                      where Codigo_de_producto_corredora__c=:decimal.valueOf(producto.productos.get(i).codigo) ];
                system.debug('existeproducto'+existeproducto);
                Producto_de_Corredora__c pro =new Producto_de_Corredora__c(); 
                if(existeproducto[0].get('total')==0){
                    
                    pro.Estado_Nectia__c=producto.productos.get(i).estado;
                    pro.Tipo_Nectia__c=producto.productos.get(i).tipo;
                    pro.Producto__c=producto.productos.get(i).producto;
                    pro.name=producto.productos.get(i).nombreproducto;//codigo de producto
                    pro.Codigo_de_producto_corredora__c=decimal.valueOf(producto.productos.get(i).codigo);
                    insert pro;
                }else{
                    pro =[select id  FROM Producto_de_Corredora__c where Codigo_de_producto_corredora__c=:decimal.valueOf(producto.productos.get(i).codigo) limit 1];                
                }
                system.debug('pro'+pro);
                list<AggregateResult> existeproductocliente=[ select Count(Id__c) total FROM Producto_del_Cliente__c 
                                                          where Id__c=:producto.productos.get(i).id];
                    system.debug('existeproductocliente'+existeproductocliente);
                    Producto_del_Cliente__c proc =new Producto_del_Cliente__c();
                    if(existeproductocliente[0].get('total')==0){
                proc.Cliente_Nectia__c=ac.id;
                proc.Producto_de_Corredora_Nectia__c=pro.id;
                proc.Id__c=producto.productos.get(i).id;
                proc.Estado_Nectia__c=producto.productos.get(i).estado;
                proc.Fecha_de_apertura_Nectia__c=date.valueOf(producto.productos.get(i).fecha);
                proc.RecordTypeId=[ SELECT Id, Name, SobjectType FROM RecordType where name=:'Producto cliente Corredora'].id;
                insert proc;
                estprodresp.mensage='producto guardado en salesforce';
                estprodresp.estado='guardado';
                estprodresp.codigo='0';
                    }else{
                      proc=[select id, Cliente_Nectia__c,Producto_de_Corredora_Nectia__c,Id__c,Estado_Nectia__c,Fecha_de_apertura_Nectia__c
                            FROM Producto_del_Cliente__c where Id__c=:producto.productos.get(i).id];  
                      proc.Cliente_Nectia__c=ac.id;
                      proc.Producto_de_Corredora_Nectia__c=pro.id;
                      proc.Id__c=producto.productos.get(i).id;
                      proc.Estado_Nectia__c=producto.productos.get(i).estado;
                      proc.Fecha_de_apertura_Nectia__c=date.valueOf(producto.productos.get(i).fecha);
                      proc.RecordTypeId=[ SELECT Id, Name, SobjectType FROM RecordType where name=:'Producto cliente Corredora'].id;
                      update proc;  
                     estprodresp.mensage='producto actualizado en salesforce';
                     estprodresp.estado='actualizado';
                     estprodresp.codigo='0';   
                    }
            }
            estprodresp.mensage='producto guardado en salesforce';
            estprodresp.estado='guardado';
            estprodresp.codigo='0';
        }else{
            estprodresp.mensage='rut no registrado en salesforce no se puede guardar producto';
            estprodresp.estado='denegado';
            estprodresp.codigo='1';   
        }
        producto.respuesta=estprodresp;
        
        return producto.respuesta;
    }
    
    public class respuesta {
        public String mensage;
        public String estado;
        public String codigo;
    }
}