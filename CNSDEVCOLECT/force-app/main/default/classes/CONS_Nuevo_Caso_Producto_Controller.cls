public with sharing class CONS_Nuevo_Caso_Producto_Controller {
    public Case nuevoCaso{get;set;}
    public Producto_del_Cliente__c prdCliente{get;set;}
    public Producto_de_Seguros__c seguro{get;set;}
    public Producto_de_Corredora__c corredora{get;set;}
    public Producto_Banco__c banca{get;set;}
    public string IdRecordTypePrd{get;set;}
    public string IdRecordTypeCase{get;set;}
    public string tipoRegistro{get;set;}
    
    private transient Schema.DescribeSObjectResult describe;
    private transient Map<Id, Schema.RecordTypeInfo> rtMapById;
    private transient Map<String, Schema.RecordTypeInfo> rtMapByName;
    public Id recordId;
    private Producto_del_Cliente__c record;
    
    public CONS_Nuevo_Caso_Producto_Controller(ApexPages.StandardController controller) {
        
        this.recordId = controller.getId();
        system.debug(this.recordId);
        this.record = (Producto_del_Cliente__c) controller.getRecord();
        system.debug(this.record);

        prdCliente = [select id, Producto_de_Seguros_Nectia__c, Producto_de_Banco_Nectia__c, Producto_de_Corredora_Nectia__c,RecordTypeId from Producto_del_Cliente__c where Id =: recordId];
        system.debug('prdCliente'+prdCliente);
        IdRecordTypePrd = ApexPages.currentPage().getParameters().get('idTipoRegistro');
        tipoRegistro = [Select DeveloperName from Tipo_de_registro_casos__mdt where Id_Producto__c =: IdRecordTypePrd].DeveloperName;
        IdRecordTypeCase = [Select Id__c from Tipo_de_registro_casos__mdt where Id_Producto__c =: IdRecordTypePrd].Id__c;
        nuevoCaso = new Case();
        if(tipoRegistro == 'Casos_Seguros'){
            //seguro = [Select Id, Area_Nectia__c from Producto_de_Seguros__c Where Id =: prdCliente.Producto_de_Seguros_Nectia__c];
            //nuevoCaso.Valores_Nectia__c = seguro.Area_Nectia__c;
        }
        system.debug('prdCliente.Producto_de_Corredora_Nectia__c'+prdCliente.Producto_de_Corredora_Nectia__c);
        system.debug('tipo de registro'+tipoRegistro);
        if(tipoRegistro == 'Casos_Corredora'){
            corredora = [Select Id, Tipo_Nectia__c from Producto_de_Corredora__c Where Id =: prdCliente.Producto_de_Corredora_Nectia__c];
            nuevoCaso.Valores_Nectia__c = corredora.Tipo_Nectia__c;
        }
        system.debug('producto banco'+ prdCliente.Producto_de_Banco_Nectia__c);
        if(tipoRegistro == 'Casos_Banco'){
            system.debug('entro a casos Banco'+prdCliente.Producto_de_Banco_Nectia__c);
            banca = [Select Id, Tipo_Nectia__c from Producto_Banco__c Where Id =: prdCliente.Producto_de_Banco_Nectia__c];
            system.debug('banca'+banca);
            nuevoCaso.Valores_Nectia__c = banca.Tipo_Nectia__c;
        }
        nuevoCaso.RecordTypeId = IdRecordTypeCase;
        nuevoCaso.AccountId = record.Cliente_Nectia__c;
        nuevoCaso.Producto_del_Cliente_Nectia__c = record.Id;
    }
    public pageReference saveAndClose(){
        System.debug('tipo->'+nuevoCaso.Type);
        if (nuevoCaso.Type != 'Reclamo' && nuevoCaso.Tipo_Auxiliar__c != 'Reclamo'){
            nuevoCaso.Status ='Cerrado';
            nuevoCaso.Comments = 'Caso cerrado en la punta';
            nuevoCaso.Tipo_de_cierre_Nectia__c = 'Caso cerrado en la punta';
            if(tipoRegistro == 'Casos_Banco'){
                nuevoCaso.Subtipo__c = nuevoCaso.Subtipo_Auxiliar__c;
                nuevoCaso.Type = nuevoCaso.Tipo_Auxiliar__c;
                nuevoCaso.Valores_Nectia__c = nuevoCaso.Tipo_de_producto_banco__c;
                nuevoCaso.Sub_estado_Nectia__c = 'Solucionado';
                System.debug('tipo->'+nuevoCaso.Type);
                if(nuevoCaso.ContactId == null){
                    nuevoCaso.ContactId = [Select Id from Contact Where AccountId =: nuevoCaso.AccountId].Id;
                }
            }
            
            if(!test.isRunningTest()){
                try{
                    insert nuevoCaso;
                    pageReference p = new PageReference('/'+nuevoCaso.Id);
                    return p;
                }catch(Exception e){
                    return null;
                }
            }else{
                return null;
            }
        }else{
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Reclamos no deben ser cerrados en la creación');
            //ApexPages.addMessages(myMsg);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Reclamos no deben ser cerrados en la creación','Reclamos no deben ser cerrados en la creación'));
            return null;
        }
    }
    public pageReference saveAndSee(){
        //CÓDIGO NECESARIO PARA QUE SE EJECUTEN LAS REGLAS DE ASIGNACIÓN
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        
        //Setting the DMLOption on Case instance
        nuevoCaso.setOptions(dmlOpts);
        if(tipoRegistro == 'Casos_Banco'){
            nuevoCaso.Subtipo__c = nuevoCaso.Subtipo_Auxiliar__c;
            nuevoCaso.Type = nuevoCaso.Tipo_Auxiliar__c;
            nuevoCaso.Valores_Nectia__c = nuevoCaso.Tipo_de_producto_banco__c;
            
        }
        system.debug('nuevoCaso.Subtipo_Auxiliar__c->'+nuevoCaso.Subtipo_Auxiliar__c);
        system.debug('nuevoCaso.Status->'+nuevoCaso.Status);
        system.debug('nuevoCaso.Tipo_de_medio_de_pago__c->'+nuevoCaso.Tipo_de_medio_de_pago__c);
        if(nuevoCaso.Subtipo_Auxiliar__c == 'Fraude - Desconoce transacción'&& nuevoCaso.Status!='Cerrado'&& 
           (nuevoCaso.Fecha_y_hora_del_evento__c==null||nuevoCaso.Tipo_de_medio_de_pago__c== '' ||nuevoCaso.Tipo_de_moneda__c=='' || nuevoCaso.Monto_reclamado__c==null)){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Para crear el subtipo "Fraude - Desconoce transacción" no puede quedar vacío el campo "Fecha y hora del evento, Tipo de medio de pago, Tipo de moneda, Monto reclamado"'));
              return null;
         }
        if(nuevoCaso.Subtipo_Auxiliar__c == 'Fraude - Desconoce transacción'&& nuevoCaso.Status=='Cerrado'&&nuevoCaso.Monto_recuperado__c==null){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Para cerrar el subtipo "Fraude - Desconoce transacción" no puede quedar vacío el campo "Monto recuperado "'));
              return null;
         }
        if(nuevoCaso.Subtipo_Auxiliar__c == 'Bloqueo Tarjeta'&& nuevoCaso.Status!='Cerrado'&&nuevoCaso.Tipo_de_medio_de_pago__c==null && nuevoCaso.Fecha_y_hora_del_evento__c==null){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Para crear el subtipo " Bloqueo Tarjeta " no puede quedar vacío el campo "Fecha y hora del evento, Tipo de medio de pago"'));
              return null;
         }
        if(nuevoCaso.Subtipo_Auxiliar__c == 'Bloqueo Cuenta'&& nuevoCaso.Status!='Cerrado'&&nuevoCaso.Tipo_de_medio_de_pago__c==null && nuevoCaso.Fecha_y_hora_del_evento__c==null) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Para crear el subtipo " Bloqueo Cuenta" no puede quedar vacío el campo "Fecha y hora del evento, Tipo de medio de pago"'));
              return null;
         }        

        if(nuevoCaso.ContactId == null){

            nuevoCaso.ContactId = [Select Id from Contact Where AccountId =: nuevoCaso.AccountId].Id;
        
        }

        if(!test.isRunningTest()){
            try{
                insert nuevoCaso;
                pageReference p = new PageReference('/'+nuevoCaso.Id);
                return p;
            }catch(Exception ex){
                ApexPages.addMessages(ex);
                return null;
            }
        }else{
            return null;
        }
    }
    public pageReference cerrar(){
       //PageReference p = new PageReference('/'+record.id);
       PageReference p = new PageReference('/'+record.Cliente_Nectia__c);
       //pageReference p = new PageReference('/');
       p.setRedirect(true); 
       return p;
       //return null;
    
    }

}