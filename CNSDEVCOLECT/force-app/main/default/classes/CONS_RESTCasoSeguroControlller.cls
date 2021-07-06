@RestResource(urlMapping='/Casoseguro/*')   //https://xxx.salesforce.com/services/apexrest/Casoseguro/crearcaso
global with sharing   class CONS_RESTCasoSeguroControlller { 
 @HttpPost
    global static CONS_RESTCasoSeguroControlller.mensage   crearcaso(string numero_poliza,string rut,string tipo,string subtipo,string subestado,string estado,string tipoDeGestion, string tipoModificacion) { 
        system.debug('tipoDeGestion'+tipoDeGestion);
        
       string user=UserInfo.getUserId();
        CONS_RESTCasoSeguroControlller.mensage  ms=new  CONS_RESTCasoSeguroControlller.mensage ();
        //---------------- estructura encargada de verificar el usuario que envia el caso  ---------------------------//
        User us=[SELECT Id, AccountId, UserRole.name FROM User where id=:user limit 1];
        system.debug('us: '+us.UserRole.name);
        string recor='Casos_Seguros';
        if(us.UserRole.name=='seguros'){
           recor='Seguros_Solicitud'; 
        }
         account acc;
        try{
         acc=[select id from account where RUT__C=:rut limit 1];
        }catch(Exception e){
             ms.error='1';
            ms.estado='rut  no existe';  
            return ms;
            }
         Producto_del_Cliente__c prdCliente;
        if(numero_poliza!=''&&numero_poliza!=null && acc.id!=null){
         prdCliente = [SELECT Id, Name, Id__c, Estado_Nectia__c, E_Mail_Poliza__c, Estado_de_poliza_Nectia__c, Poliza_Nectia__c, Producto_de_Seguros_Nectia__c 
                                              FROM Producto_del_Cliente__c where Poliza_Nectia__c!=null  and Poliza_Nectia__c=:numero_poliza and Cliente_Nectia__c=:acc.id limit 1];
    }
        Case cas=new case();
        cas.AccountId=acc.id;
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and  DeveloperName =:recor ].id;
          if(numero_poliza!=''&&numero_poliza!=null){
        cas.Producto_del_Cliente_Nectia__c=prdCliente.id;
              }
        cas.Status=estado==''?null:estado;
        cas.Sub_estado_Nectia__c=subestado==''?null:subestado;
        cas.Type=tipo==''?null:tipo;
        cas.Subtipo__c=subtipo==''?null:subtipo;
        cas.Tipo_de_Gestion__c=tipoDeGestion;

        boolean existente = new CONS_RESTCasoSeguroControlller().getPickListValuesIntoList(tipoModificacion); 

        if(existente == true){
            cas.Tipo_de_Modificaci_n__c=tipoModificacion;
        }
        
        system.debug('cas'+cas);
        insert cas;
        
        Case cas2=[select id,Account.PersonEmail,CaseNumber,Account.name,Account.phone,Account.PersonMobilePhone,CreatedDate from Case where id=:cas.id limit 1];
        
        Long telefono=0;
        ms.Numero_de_Caso=cas2.CaseNumber;
        ms.Email_Cliente=cas2.Account.PersonEmail;
        ms.Nombre_Cliente=cas2.Account.name;
        string phone = '';
        if(cas2.Account.PersonMobilePhone!=null){
            
             phone = cas2.Account.PersonMobilePhone.replace('+','').replace(' ','');
            
        }
        
        if(cas2.Account.PersonMobilePhone!=null && phone.isNumeric() ){
            telefono=Long.valueOf(phone);
            
        }
        ms.Celular_Cliente=telefono;//integer.valueOf(cas2.Account.phone);
        ms.Fecha_Creacion=string.valueOf(cas2.CreatedDate);
        
        return ms;
    }
    
    global class mensage {
        public string Numero_de_Caso;
        public string Email_Cliente;
        public string Nombre_Cliente;
        public Long Celular_Cliente;
        public string Fecha_Creacion;
        public string error;
        public string estado;
        public string NombreEjec;
        public integer FonoEjec;
        public string EmailEjec;
        
     
     
    }

    public Boolean getPickListValuesIntoList(string tipoMod){
        Boolean esValido = false;
         Schema.DescribeFieldResult fieldResult = Case.Tipo_de_Modificaci_n__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         for( Schema.PicklistEntry pickListVal : ple){
             if(pickListVal.getValue() == tipoMod){
                esValido = true;

            }
         }     
         return esValido;
     }

}