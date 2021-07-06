global class CONS_servicios_wsdl {
    /*********************************************************************************

* @author         Nectia

* @description    WSDL  para  informar  direcion url  de ficha cliente  a genesis

* @date                2018-11-29

* @group          

**********************************************************************************/
    
 global class Validacliente{
     //parametros  de entrada del servicio
        webservice String rut;
        webservice String idcrossnet;
       // webservice String uuid;
       
   }
        webservice static Respuestaurl consultaclienteURL(Validacliente datos){
        Respuestaurl r=new  Respuestaurl();
            //busqueda de la  informacion en salesforce 
            list<Account>  existe =[SELECT Id , Name, RecordTypeId, Type, Phone, RUT__c, RUT_Nectia__pc FROM Account where RUT__c=:datos.rut limit 1 ];
           
            if(existe.size()>0){
               // r.url='https://cs93.salesforce.com/console?tsid=02u4F0000008ZdF#%2F'+existe[0].id;
               r.url='https://na78.salesforce.com/apex/CONS_entraraconsola?id='+existe[0].id;
              //r.url='https://cs93.salesforce.com/'+existe[0].id;//+'?conid='+datos.conid;
              //r.url='https://cs93.lightning.force.com/lightning/r/Account/'+existe[0].id;
              r.mensaje='cliente encontrado';
              r.nombre=existe[0].Name;
              r.rut=existe[0].RUT__c ;
              r.codigo=0; 
              r.idcrossnet=datos.idcrossnet;
             // r.uuid=datos.uuid;  
            }else{
             // r.url='https://cs93.salesforce.com/001/e?RecordType=0121N000000oBigQAE';
               r.url='https://na78.salesforce.com/apex/CONS_entraraconsola?';     
              //r.url='url no encontrada';
              r.mensaje='cliente no existe en salesforce';
              r.codigo=1;
                }
            
            
             
           return r; 
    }
    
 global class Respuestaurl{
            //datos  de salida del servicio 
        webservice String url;
        webservice String mensaje;
        webservice String nombre;
        webservice String rut;
        webservice Integer codigo;
        webservice String idcrossnet;
      //  webservice String uuid;
 }
}