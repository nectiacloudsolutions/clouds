({
    //This functions calls a method to validate the RUT and take action with the answer
    //Test111123132131231312
    validateRUT : function(cmp,event,helper) {    
        var RUT = cmp.get("v.RUT").toLocaleUpperCase();
        if(RUT.length >0)
        {
            //CALL SERVER, Method validatedRUT
            if(helper.validateFormatAndDV(cmp)){
                cmp.set("v.RUT", RUT);
                if(RUT.indexOf("-") < 0){
                    RUT = RUT.slice(0, RUT.length-1) + "-" + RUT.slice(RUT.length-1,RUT.length);
                    console.log("RUT222: "+RUT);
                    cmp.set("v.RUT", RUT);
                }
                cmp.set("v.enabledSpinner",true);
                
                console.log("HELPER START");
                console.log("RUT: " + RUT);
                var action = cmp.get("c.validatedRUT");
                action.setParams({ RUT : cmp.get("v.RUT")});
                action.setCallback(this, function(response) {
                     var val = response.getReturnValue();
                   
                    if(response.getState() === "SUCCESS"){
                        //If value is an ID exist otherwise is null and does not exist
                        var res = response.getReturnValue();
                        console.log("Respuesta: "+res);
                        if(res == undefined || res == null){
                            /*
                        console.log("Entro en Null");
                        cmp.set("v.hasErrors", true);
                        cmp.set("v.errorMessage", "El RUT ingresado es incorrecto.");
                        var inputField = cmp.find('RUTInput');
                        inputField.setCustomValidity("El RUT ingresado es incorrecto.");
                        inputField.reportValidity();
                        */
                    }else if(res.Account.length > 0){
                        if($A.get("$SObjectType.CurrentUser.Id") == res.Account[0].OwnerId){
                            console.log("dentro de if Account");
                            console.log(res.Account[0].Id);
                            cmp.set("v.enabledSpinner", false);
                            cmp.set("v.RUT", "");
                            helper.openRecord(res.Account[0].Id);
                        }else{
                            cmp.set("v.LeadId", val.Account[0].Id);
                             cmp.set("v.ownerId",val.Account[0].OwnerId);
                            cmp.set("v.leadNot",true);
                            cmp.set("v.notifiText", "El cliente que buscas ya está siendo gestionado por el ejecutivo "+ val.AccountOwner[0].Name +" favor contactarlo de ser necesario");
                            cmp.set("v.enabledSpinner", false);
                            console.log('ENTROOOO account');
                            console.log(cmp.get("v.ownerId",val.Account[0].OwnerId));
                            helper.Notify(cmp,helper);
                        }
                        
                        
                    }else if(res.Lead.length > 0){
                        cmp.set("v.ID",res.Lead[0].Id);
                        console.log("dentro de if Lead");
                        console.log("Lead ID"+res.Lead);
                        console.log("Lead ID"+res.Lead[0].OwnerId);
                        console.log("User ID "+$A.get("$SObjectType.CurrentUser.Id"));
                        console.log("User Boolean "+$A.get("$SObjectType.CurrentUser.Id") == res.Lead[0].OwnerId);
                        if($A.get("$SObjectType.CurrentUser.Id") == res.Lead[0].OwnerId){
                            cmp.set("v.enabledSpinner", false);
                            cmp.set("v.RUT", "");
                            helper.openRecord(res.Lead[0].Id);
                        }else if(res.Lead[0].Status == 'No Gestionado'){
                            cmp.set("v.LeadId", val.Lead[0].Id);
                             cmp.set("v.ownerId",val.Lead[0].OwnerId);
                            cmp.set("v.leadNot",true);
                            cmp.set("v.notifiText", "El prospecto que buscas está asignado al ejecutivo "+ val.LeadOwner[0].Name +" favor contactarlo de ser necesario");
                            cmp.set("v.enabledSpinner", false);
                            helper.Notify(cmp,helper);
                        }else if(res.Lead[0].Status == 'Gestionado' || res.Lead[0].Status == 'No_Interesado'){
                            cmp.set("v.LeadId", val.Lead[0].Id);
                             cmp.set("v.ownerId",val.Lead[0].OwnerId);
                            cmp.set("v.leadNot",true);
                            cmp.set("v.notifiText", "El prospecto que buscas ya está siendo gestionado por el ejecutivo "+ val.LeadOwner[0].Name +" favor contactarlo de ser necesario");
                            cmp.set("v.enabledSpinner", false);
                            helper.Notify(cmp,helper);

                        }else if(res.Lead[0].Status == 'Convertido'){
                            cmp.set("v.LeadId", val.Lead[0].Id);
                             cmp.set("v.ownerId",val.Lead[0].OwnerId);
                            cmp.set("v.leadNot",true);
                            cmp.set("v.notifiText", "El cliente que buscas ya está siendo gestionado por el ejecutivo "+ val.LeadOwner[0].Name +" favor contactarlo de ser necesario");
                            cmp.set("v.enabledSpinner", false);
                            helper.Notify(cmp,helper);

                        }else{
                            //esta variavle cuestion va en el iff de arriba 
                           // cmp.set("v.question", true);
                            //aca entrara si el lead no tiene estado  "No Gestionado" y mostrará el toast
                            /*
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Prospecto en gestión",
                                "message": "El prospecto que buscas ya esta siendo gestionado por el ejecutivo "+ val.LeadOwner[0].Name +" favor contactarlo de ser necesario",
                                "type": "info"
                            });
                            toastEvent.fire();
                            */
                            cmp.set("v.LeadId", val.Lead[0].Id);
                             cmp.set("v.ownerId",val.Lead[0].OwnerId);
                            cmp.set("v.leadNot",true);
                            cmp.set("v.notifiText", "El cliente que buscas ya está siendo gestionado por el ejecutivo "+ val.LeadOwner[0].Name +" favor contactarlo de ser necesario");
                            cmp.set("v.enabledSpinner", false);
                            console.log(cmp.get("v.LeadId"));
                            console.log('ENTROOOO');
                            console.log(cmp.get("v.ownerId",val.Lead[0].OwnerId));
                            helper.Notify(cmp,helper);
                        }
                    }else{
                        console.log("Entro en Ninguna respuesta");
                        helper.consultAnalytis(cmp,helper);
                    }
                }
                //Case ERROR, Show error message
                else {
                    cmp.set("v.hasErrors", true);      
                }
                
            });
                        $A.enqueueAction(action);
                    }
        } else{
            helper.openCreateRecord(cmp,"Lead");
        }

    },
    openCreateLeadWithParam : function(cmp) {      
        var l = cmp.get("v.lead");
        console.log(JSON.stringify(l));
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Lead",
            "defaultFieldValues": {
                'FirstName': l.FirstName,
                'LastName':l.LastName,
                'motherlastname_sales__c': l.motherlastname_sales__c,
                'rut_ejecutivo_sales__c': l.rut_ejecutivo_sales__c,
                'numero_de_documento_sales__c': l.numero_de_documento_sales__c,
                'tipo_documento_sales__c': l.tipo_documento_sales__c, 
                'other_phone_sales__c': l.other_phone_sales__c,
                'Email': l.Email,
                'nuevo_correo_sales__c': l.nuevo_correo_sales__c,
                'LeadSource': l.LeadSource,
                'genero_sales__c': l.genero_sales__c,
                'calle_sales__c': l.calle_sales__c,
                'numero_sales__c': l.numero_sales__c,
                'numero_de_piso_sales__c': l.numero_de_piso_sales__c,
                'numero_departamento_sales__c': l.numero_departamento_sales__c,
            	'comuna_sales__c': l.comuna_sales__c,
                'villa_sales__c': l.villa_sales__c,
                'region_sales__c': l.region_sales__c,
                'sla_sales__c': l.sla_sales__c,
                'fecha_nacimiento_sales__c': l.fecha_nacimiento_sales__c,
                'Rating': l.Rating,
                'genero_sales__c':l.genero_sales__c
        	}
        });
        createRecordEvent.fire();
    },
    openCreateLeadWithRut : function(cmp,RUT) {        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Lead",
            "defaultFieldValues": {
                'numero_de_documento_sales__c': RUT,
                'tipo_documento_sales__c': 'RUT'
            }
        });
        createRecordEvent.fire();
    },
    openCreateRecord : function(cmp,obj) {        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": obj
        });
        createRecordEvent.fire();
    },
    //This functions navigate to an existing record
    openRecord : function(id) {  
        console.log("ID: "+id);
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": id,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    //This functions create an activity
    openCreateEvent: function(cmp) {        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Event",
            "defaultFieldValues": {
                'WhoId' : cmp.get("v.ID")
            }
            
        });
        createRecordEvent.fire();
    },
    // Valida el rut con su cadena completa "XXXXXXXX-X"
    validateFormatAndDV : function(cmp) {
        var res = true;
        var rut = cmp.get("v.RUT");
        var inputField = cmp.find('RUTInput');
        // Despejar Puntos
        var valor = rut.replace('.','');
        // Despejar Guión
        valor = valor.replace('-','');
        // Aislar Cuerpo y Dígito Verificador
        var cuerpo = valor.slice(0,-1);
        var dv = valor.slice(-1).toUpperCase();
        // Formatear RUN
        rut = cuerpo + '-'+ dv;
        // Si no cumple con el mínimo ej. (n.nnn.nnn)

        if(cuerpo.length < 7) {
            inputField.setCustomValidity("Debe ingresar un RUT completo.");
            inputField.reportValidity();
            return false;
        }
        // Calcular Dígito Verificador
        var suma = 0;
        var multiplo = 2;
        // Para cada dígito del Cuerpo
        for(var i=1;i<=cuerpo.length;i++) {
            // Obtener su Producto con el Múltiplo Correspondiente
            var index = multiplo * valor.charAt(cuerpo.length - i);
            // Sumar al Contador General
            suma = suma + index;
            // Consolidar Múltiplo dentro del rango [2,7]
            if(multiplo < 7) {
                multiplo = multiplo + 1; 
            } else { 
                multiplo = 2; 
            }
        }
        // Calcular Dígito Verificador en base al Módulo 11
        var dvEsperado = 11 - (suma % 11);
        // Casos Especiales (0 y K)
        dv = (dv == 'K')?10:dv;
        dv = (dv == 0)?11:dv;
        // Validar que el Cuerpo coincide con su Dígito Verificador
        if(dvEsperado != dv) {
            inputField.setCustomValidity("El RUT ingresado es incorrecto.");
            inputField.reportValidity();
            return false;
        }
        // Si todo sale bien, eliminar errores (decretar que es válido)
        inputField.setCustomValidity("");
        inputField.reportValidity();
        return true;
    },
    consultAnalytis : function(cmp,helper){
    	//CALL SERVER, Method consultAnalyticsForLead
            var action = cmp.get("c.consultAnalyticsForLead");
            action.setParams({ RUT : cmp.get("v.RUT")});
            action.setCallback(this, function(response) {
                if(response.getState() === "SUCCESS"){
                    console.log("response ---->"+response);
                    //If value is an ID exist otherwise is null and does not exist
                    var res = JSON.parse(response.getReturnValue());
                    console.log("res-----> "+res);
                    if(res.code == undefined || res.code == null){
                        console.log("UNDEFINED --- Functionality TBD");
                        console.log("openCreateLeadWithParamCODE=nul");
                        cmp.set("v.lead",res.leadList[0]);
                        console.log("LEAD--->"+res.leadList[0]);
                        helper.openCreateLeadWithParam(cmp);
                        cmp.set("v.enabledSpinner", false);
                        
                    }else if(res.code < 1){
                        console.log("Negative Code ERROR --- Functionality TBD");
						
                        helper.openCreateLeadWithRut(cmp,cmp.get("v.RUT"));
                    }else if(code >= 1){
                        console.log("SUCCESS RETURN ---- Functionality TBD");
                        console.log("openCreateLeadWithParamCODE>1");
                        cmp.set("v.lead",res.lead[0]);
                        helper.openCreateLeadWithParam(cmp);
                        
                    }else{
                        console.log("openCreateLeadWithRut");
                        cmp.set("v.lead",res.lead[0]);
                        helper.openCreateLeadWithRut(cmp,cmp.get("v.RUT"));
                        
                    }
                    cmp.set("v.enabledSpinner", false);
                }
                //Case ERROR, Show error message
                else {
                    //Functionality TBD
                    return false;
                }
            });
            $A.enqueueAction(action);
	},
    changeLeadOwner : function(cmp,helper){
        //CALL SERVER, Method changeLeadOwner
        var action = cmp.get("c.changeLeadOwner");
        var leadID = cmp.get("v.ID");
        console.log("IDIDIDID"+cmp.get("v.ID"));
        console.log("newOwnerId"+ $A.get("$SObjectType.CurrentUser.Id"));
        action.setParams({ leadID : cmp.get("v.ID"),
                          newOwnerId : $A.get("$SObjectType.CurrentUser.Id")});
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS"){
                console.log("LEAD--->"+cmp.get("v.ID"));
                console.log("LEADID BEFORE"+leadID);
                this.openRecord(leadID);
                return response.getReturnValue();
            }
            //Case ERROR, Show error message
            else {
                //Functionality TBD
                return false;
            }
            
        });
        $A.enqueueAction(action);
    },
    Notify : function(cmp,helper){
        //CALL SERVER, Method notify
        var action = cmp.get("c.notifyExecutive");
        var leadId = cmp.get("v.LeadId");
        //var leadId 
        console.log('entro notify' + leadId);
   
       
        action.setParams({leadId : leadId});
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS"){
                console.log('Se envió notificación');
               // this.openRecord(leadID);
               // return response.getReturnValue();
            }
            //Case ERROR, Show error message
            else {
                //Functionality TBD
                return false;
            }
            
        });
        $A.enqueueAction(action);
    }
})