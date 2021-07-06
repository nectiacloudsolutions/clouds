@RestResource(urlMapping='/Casos/*')   //https://xxx.salesforce.com/services/apexrest/Casos/crearcaso
global with sharing   class Cons_RESTCasoController {
    global string test{get;set;}   
    
   @HttpGet
    global static CONS_Estructurarespuestacaso_JSON   buscarcasos() { 
        RestRequest req = RestContext.request;
        
        String rut = req.params.get('rut');
        String numero = req.params.get('numerocaso');
        string extencion='where' ;
        if(rut!='' && rut!=null){
            extencion+= ' Rut_del_Cliente__c=\''+rut+'\'';
        }
        if(numero!='' && numero!=null ){
            if(!extencion.equals('where')){
               extencion+=' and '; 
            }
            extencion+= ' CaseNumber=\''+numero+'\'';
        }
        
        system.debug('rut'+rut);
        system.debug('numero'+numero);
        system.debug('extencion'+extencion);
        CONS_Estructurarespuestacaso_JSON  estcas=new CONS_Estructurarespuestacaso_JSON(); 
        
        try{
            string query='SELECT CaseNumber,Rut_del_Cliente__c, Semaforo__c, Valores_Nectia__c, Subtipo__c, Tipo_de_cierre_Nectia__c,'+
                'SLA_Nectia__c, Sub_estado_Nectia__c, Producto_del_Cliente_Nectia__c, Anio__c, Status, RecordTypeId, Id,'+
                'SlaStartDate,SlaExitDate,Entitlement.name,Owner.name,Origin,Parentid,parent.CaseNumber,Description,Type,Ownerid,Entitlementid '+
                ' FROM Case '+extencion;
            system.debug('query'+query);
            list<case> cas =Database.query(query);
            system.debug('cas'+cas);
            system.debug('cantidad'+cas.size());
            estcas.cliente_rut=cas.get(0).Rut_del_Cliente__c;
            List <CONS_Estructurarespuestacaso_JSON.listacaso> listacasos = new List <CONS_Estructurarespuestacaso_JSON.listacaso>();
            for(integer i=0;i < cas.size();i++){
                CONS_Estructurarespuestacaso_JSON.listacaso  lcas=new  CONS_Estructurarespuestacaso_JSON.listacaso();
                lcas.id=cas.get(i).Id;
                lcas.numero_de_caso=cas.get(i).CaseNumber;
                lcas.caso_principal=cas.get(i).Parentid==null?null:cas.get(i).Parent.CaseNumber;
                lcas.descripcion=cas.get(i).Description;
                lcas.origen_del_caso=cas.get(i).Origin;
                lcas.propietario_del_caso=cas.get(i).Ownerid==null?null:cas.get(i).Owner.name;
                lcas.estado=cas.get(i).Status;
                lcas.sub_estado=cas.get(i).Sub_estado_Nectia__c==null?null:cas.get(i).Sub_estado_Nectia__c;
                lcas.nombre_asignacion=cas.get(i).Entitlementid==null?null:cas.get(i).Entitlement.name;
                lcas.tipo=cas.get(i).Type;
                lcas.subtipo=cas.get(i).Subtipo__c;
                lcas.asignacion_hora_inicio=cas.get(i).SlaStartDate;
                lcas.asignacion_hora_finalizacion=cas.get(i).SlaExitDate;  
                system.debug('lcas='+lcas);
                system.debug('estcas.casos=='+estcas.casos);
                listacasos.add(lcas);
                system.debug('estcas.casos=='+estcas.casos);
            }
            estcas.casos=listacasos;
        }catch(Exception e){
            system.debug('e'+e);
        }
        return estcas;
    }
    
      @HttpPost
    global static Cons_RESTCasoController.mensage   crearcaso(string rut,string productocuenta,string tipo,string subtipo,string prioridad,string origen,string asunto,string glosa,string clasificacionSBIF,string causa,string tipoproducto) { 
        string user=UserInfo.getUserId();
        //---------------- estructura encargada de verificar el usuario que envia el caso  ---------------------------//
        User us=[SELECT Id, AccountId, UserRole.name FROM User where id=:user limit 1];
        system.debug('us: '+us.UserRole.name);
        string recor='';
        if(us.UserRole.name=='corredora'){
          recor='Casos_Corredora';  
        }else if(us.UserRole.name=='banco'){
          recor='Casos_Banco';  
        }else if(us.UserRole.name=='seguros'){
           recor='Casos_Seguros'; 
        }else if(us.UserRole.name=='Consorcio'){
            recor='Casos_Banco';
        }
        if(test.isRunningTest()) {
            if(tipoproducto=='0'){
            recor='Casos_Corredora';
            }else {
               recor='Casos_Banco';  
            }
        } 
        //----------------------------------------------------------------------//
        Case cas=new Case();
        
        //--------------------- creacion del caso -------------------------------//
          Cons_RESTCasoController.mensage rm=new Cons_RESTCasoController.mensage();
        
   //     try{  
        if( recor=='Casos_Corredora'){
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and  DeveloperName =:recor ].id;
        cas.Accountid=[select id from account where rut__c=:rut].id;
        Account tmpAcc = [select id, isPersonAccount, PersonContactId from account where rut__c=:rut];
        if(tmpAcc.isPersonAccount){
         	cas.ContactId =  tmpAcc.PersonContactId;  
        }else{
            Contact tmpCto = [Select id from Contact where AccountId =: tmpAcc.Id limit 1];
            cas.ContactId = tmpCto.Id;
        }
        cas.Rut_del_Cliente__c=rut;
        cas.Status='Nuevo';
        cas.Type=tipo;
        cas.Subtipo__c=subtipo;
        cas.Priority=prioridad;
        cas.Origin=origen;
        cas.Description=glosa;
        cas.Subject=asunto;
        
        system.debug('cas='+cas);
        insert cas;
         
      
        rm.mensage='caso creado en salesforce';
        rm.codigo='0';
         //----------------------------------------------------------------------//
        }else   if( recor=='Casos_Banco'){
          
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and  DeveloperName =:recor ].id;
          string idcliente=[select id from account where rut__c=:rut].id;
        cas.Accountid=idcliente;
        Account tmpAcc = [select id, isPersonAccount, PersonContactId from account where rut__c=:rut];
        if(tmpAcc.isPersonAccount){
         	cas.ContactId =  tmpAcc.PersonContactId;  
        }else{
            Contact tmpCto = [Select id from Contact where AccountId =: tmpAcc.Id limit 1];
            cas.ContactId = tmpCto.Id;
        }
        system.debug(' cas.Accountid'+ cas.Accountid);
            if(tipoproducto!='Multiproducto' && productocuenta!='' && productocuenta!=null){ 
                 string producclientid;
                try{
                       producclientid = [select id from Producto_del_Cliente__c where Name=:productocuenta and  Cliente_Nectia__c=:idcliente].id;
                } catch(Exception e){
                     rm.mensage='producto no se encuentra reacionado al cliente';
                    rm.codigo='1'; 
                    return rm;
                }      
            
                
                  if(producclientid!=null){  
        cas.Producto_del_Cliente_Nectia__c=producclientid;
                  }
            }
        cas.Rut_del_Cliente__c=rut;
        cas.Status='Nuevo';
            system.debug('tipo'+tipo);
        cas.Type=tipo;
        cas.Tipo_Auxiliar__c=tipo;
        cas.Tipo_de_producto_banco__c=tipoproducto;
        cas.Valores_Nectia__c=tipoproducto;
        cas.Clasificaci_n_SBIF_nectia__c=clasificacionSBIF==''?null:clasificacionSBIF;
        cas.Causa_nectia__c=causa==''?null:causa;
        cas.Subtipo__c=subtipo==''?null:subtipo;
        cas.Subtipo_Auxiliar__c =subtipo==''?null:subtipo;
        cas.Priority=prioridad==''?'media':prioridad==null?'media':prioridad;
        cas.Origin=origen==''?'web':origen==null?'web':origen=='WEB'?'web':origen;
        cas.Description=glosa;
        cas.Subject=asunto;
        
        system.debug('cas='+cas);
        insert cas;
            string idcaso= cas.id; 
            Case cas1 = [SELECT CaseNumber, Id FROM Case where  id =:idcaso];
       rm.mensage='caso creado en salesforce numero: '+cas1.CaseNumber;
         // rm.mensage='caso creado en salesforce';
          rm.codigo='0';  
         
        }
     /*   }catch(Exception e){
            rm.mensage='error en el proseso de creacion de casos';
            rm.codigo='1'; 
        }*/
         return rm;
    }
    
    global class mensage {
        public string mensage;
        public string codigo;
        
        
    }
    
    
}