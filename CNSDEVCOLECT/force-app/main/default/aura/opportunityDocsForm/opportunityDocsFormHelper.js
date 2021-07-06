({
	getData: function(component, event, helper) {
        console.log("::::::::::::::GETDATA:::::::::::::::");
        //component.set('v.isLoading', true);
       
        var action = component.get("c.getData");
        
        //console.log(event.getParam("changePickList"));
        action.setParams({
            oppId: component.get("v.recordId"),
        });
        
        action.setCallback(this, function(response) {
        
            
            var state = response.getState();
            //console.log('STATE: ' + state);
            
            if (state === "SUCCESS") {
                var docWrapperReturned = response.getReturnValue();
                component.set("v.docWrapper", docWrapperReturned);
                console.log("wrapper valores:", docWrapperReturned);
                if (docWrapperReturned.isPerfilEjecutivo) {
                     component.set("v.readOnly",true);
                    component.set("v.isPerfilEjecutivo", true);
                }else{
                    component.set("v.readOnly",false);
                }
               
                // Si docWrapper esta null (no es un reRender)
                if (component.get('v.docWrapper') == null) {
                   
                    component.set("v.docWrapper", docWrapperReturned);
                }

            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "type": "Error",
                    "message": "Se ha producido un error al visualizar los documentos. Por favor intente de nuevo"
                });
                
                toastEvent.fire();
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                
            }
            
            /* Verifca estado de los documentos */
            var count = 0;
            var countGeneral = 0;
            component.get('v.docWrapper').listaDocs.forEach(
                function myFunction(item, index) {
                    
                    countGeneral++;
                    if (item.estado_documento_sales__c == "Ingresado"  || 
                        item.estado_documento_sales__c == "No aplica"  ||
                        item.estado_documento_sales__c == "Aprobado") {
                        count++;
                    }     
                    
                });
            
    		
            if ( component.get("v.docWrapper.estadoAprobacionPreVisado") != 'En Proceso' &&
                count == countGeneral && component.get("v.docWrapper.isPerfilEjecutivo"))  {
                component.set("v.disablePreVisadoButton", false);
                console.log('ENTRO4');
               
             /*Deshabilita el botón de enviar a pre visado y el campo estado luego de enviar los documentos form a pre-visado */
            }
            else if(count == countGeneral && component.get("v.docWrapper.isPerfilEjecutivo")  && component.get("v.docWrapper.estadoAprobacionPreVisado") == 'En Proceso'){
                component.set("v.isEstadoDisabled",true);
                component.set("v.disablePreVisadoButton", true);
                component.set("v.showPreVisadoSection",false);
                
                console.log('ENTRO1');
               // console.log(component.get("v.showPreVisadoSection"));
              
                
            }//en este else, entrará cuando este logeado como pre visado, y checkear el campo estado del pre_visado
                else{
                    component.set("v.showPreVisadoSection",false);
                    //component.set("v.showPreVisadoButton",false);
                    component.set("v.disablePreVisadoButton", true)
                   
                
                   console.log('ENTRO2');
                    
            }
            /* Habilita Botonera para Pre-Visador*/
            if( component.get("v.docWrapper.estadoAprobacionPreVisado") == 'En Proceso' && component.get("v.docWrapper.isPerfilPreVisado") && count == countGeneral){
                component.set("v.showPreVisadoSection",true);
                component.set("v.showButtonsPreVisado",true);
                component.set("v.showPreVisadoButton",false);
                component.set("v.readOnly",true);
                console.log('ENTRO3');

            }
            /*Habilita campo estado doc para el ejecutivo comercial*/
            if((docWrapperReturned.stageName == 'Formalización' && docWrapperReturned.isPerfilEjecutivo && component.get("v.docWrapper.estadoAprobacionPreVisado") != 'En Proceso') ||
              (docWrapperReturned.stageName == 'Formalización' && docWrapperReturned.isPerfilPreVisado && component.get("v.docWrapper.estadoAprobacionPreVisado") === 'En Proceso')){
                
                component.set('v.isEstadoDisabled',false);
                console.log('ENTRO4');
               
            }else if(docWrapperReturned.stageName == 'Curse' ){
                component.set("v.showPreVisadoSection",false);
                component.set("v.showPreVisadoButton",false);
                component.set("v.disablePreVisadoButton", true)
                if(docWrapperReturned.isPerfilVisador ){
                    component.set("v.isEstadoDisabled",false);
                }
                if(docWrapperReturned.estadoAprobacionVisado == 'Aprobado' || (docWrapperReturned.estadoAprobacionPreVisado == 'Aprobado' && docWrapperReturned.isPerfilVisador === false)){
                    
                        component.set("v.isEstadoDisabled",true);
                    
                    console.log('ENTRO5');
                } 
                console.log('ENTRO6');
            }
            
             this.setButtonsEnabled(component, component.get('v.docWrapper'));
            console.log('::::::::::::::::::::::::');
            console.log(docWrapperReturned.isPerfilEjecutivo + ' '+ docWrapperReturned.stageName);
            if(docWrapperReturned.isPerfilEjecutivo && docWrapperReturned.stageName == 'Curse'){
                component.set("v.isMotivoDisabled",true);
                component.set("v.isObservacionDisabled",true);
                console.log('ENTRO7');
            }
       
        });
        $A.enqueueAction(action);
    },
    sendToEvaluate : function(component, oppId) {
        component.set('v.enabledSpinnerModal', true);
        var action = component.get("c.sendToApproveVisador");
        action.setParams({
            oppId: oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.enabledSpinnerModal', false);
            var error = false;
            if (state === "SUCCESS") {
                var retValue = response.getReturnValue();
                
                if (retValue == 'OK') {
                    console.log("ENTRO APROBAR");
                    component.set("v.showSendTo", false);
                    //component.set("v.showButtonJefeVisador", false);
                   // component.set("v.showButtonJefeVisadorGuardar", false);
                    var toastEvent = $A.get("e.force:showToast");
                    
                    toastEvent.setParams({
                        "title": "Oportunidad Aprobada",
                        "message": "La aprobación será informada al ejecutivo",
                        "type": "success"  
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
                else {
                    error = true;
                }
            }
            else {
                error = true;
            }
            if (error) {
                component.set("v.showSendTo", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Error",
                    "message": "Se ha producido un error. Por favor intente comunicarse con su administrador."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    sendToReject : function(component, oppId) {
        component.set('v.enabledSpinnerModal', true);
        var action = component.get("c.stageRejectManager");
        var doc = component.get("v.docWrapper");
        action.setParams({
            oppId: oppId,
            motivo: component.get("v.supervisorObs")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.enabledSpinnerModal', false);
            var error = false;
            if (state === "SUCCESS") {
                component.set("v.showSendTo", false);
                component.set("v.showButtonJefeVisador", false);
                component.set("v.showButtonJefeVisadorGuardar", false);
                component.set("v.showPreVisadoSection",false);
                //console.log(component.get("v.showButtonJefeVisador"));
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Oportunidad Rechazada",
                    "message": "La Opportunidad ha sido Rechazada",
                    "type": "success"
                });
                toastEvent.fire();
               
                component.set("v.docWrapper",JSON.parse(JSON.stringify(doc)));
               
                
                  //$A.get('e.force:refreshView').fire();
              	 //location.reload();
            }
            else {
                error = true;
            }
            
            if (error) {
                component.set("v.showSendTo", false);
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "type": "Error",
                    "message": "Se ha producido un error. Por favor intente comunicarse con su administrador."
                });
                
                toastEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
         // $A.get('e.force:refreshView').fire();
    }, 
    setButtonsEnabled: function(component, docWrapper) {
        var count = 0;
        var countGeneral = 0;
        var countVisador = 0;
        var countReject = 0;
		console.log("ENTRA EN SET BUTTONS");
        docWrapper = JSON.parse(JSON.stringify(docWrapper));
       
      
        component.get('v.docWrapper').listaDocs.forEach(
            function myFunction(item, index) {
                 countGeneral++;
                    if (item.estado_documento_sales__c == "Ingresado" || item.estado_documento_sales__c == "Aprobado" || 
                        item.estado_documento_sales__c == "No aplica") {
                        count++;
                    }
                    
                    if ((item.estado_documento_sales__c == "Aprobado"|| item.estado_documento_sales__c == "No aplica") || 
                        (item.estado_documento_sales__c == "Rechazado" && item.motivo_rechazo_sales__c != "")) {
                        countVisador++;
                    }
                    if(item.estado_documento_sales__c == "Rechazado" || item.estado_documento_sales__c == ""){
                        countReject++;
                    }              
            });
   
        
      
        
       
            console.log("Visador count DIFF "+countVisador);
            console.log("countGeneral  DIFF"+countGeneral);
            if (countVisador == countGeneral) {
                console.log("test2");
                component.set("v.disableButtonVisador", true);
            } else {
                console.log("test3");
                component.set("v.disableButtonVisador", false);
            }
       
            console.log("test4");
            console.log("Visador count "+countVisador);
            console.log("countGeneral  "+countGeneral);
            console.log("countReject  "+countReject);
            if (countVisador == countGeneral) {
                
                if(countReject == 0){
                    console.log("test5");
                    component.set("v.disableApproveButtonJefeVisador", false);
                    component.set("v.disableButtonJefeVisador", true);
                }else{
                    console.log("test6");
                    component.set("v.disableApproveButtonJefeVisador", true);
                    component.set("v.disableButtonJefeVisador", false);
                }
            } else {
                console.log("ENTRO EN TRUE");
               // component.set("v.disableButtonJefeVisador", true);
            }
        
        
    },

    
})