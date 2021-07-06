({
    getData: function(component, event, helper) {
        component.set('v.isLoading', true);
        
        var action = component.get("c.getData");
        
        action.setParams({
            oppId: component.get("v.recordId"),
        });
        
        action.setCallback(this, function(response) {
            component.set('v.isLoading', false);
            component.set("v.isEjecutivoEspecialista", false);
            component.set("v.isPerfilRiesgo", false);
            
            var state = response.getState();
        
            
            if (state === "SUCCESS") {
                var docWrapperReturned = response.getReturnValue();
               
                component.set("v.docWrapper", docWrapperReturned);
                if (docWrapperReturned.isPerfilEspecialista == 'OK') {
                    component.set("v.isEjecutivoEspecialista", true);
                }
                if (docWrapperReturned.isPerfilRiesgo == 'OK') {
                    component.set("v.isPerfilRiesgo", true);
                }
                if(docWrapperReturned.isPerfilJefeVisador == 'OK'){
                    component.set("v.isPerfilJefeVisador", true);
                }
                if (!docWrapperReturned.profile.indexOf('Jefe')!= -1) {
                    component.set("v.isPerfilJefe", true);
                }
                if (component.get('v.docWrapper') == null) {
                    component.set("v.docWrapper", docWrapperReturned);
                }
                else {
                    var docWrapperActual = component.get('v.docWrapper');
                    var sizeWrapperActual = this.countDocumentSize(docWrapperActual);
                    var sizeWrapperReturned = this.countDocumentSize(docWrapperReturned);
                    
                    if (sizeWrapperActual == sizeWrapperReturned && (docWrapperReturned.rtName == 'sales_banca_hipotecario' ||
                                                                      docWrapperReturned.rtName == 'sales_banca_hipotecario_lectura')) {
                        docWrapperReturned.participantDoc = docWrapperActual.participantDoc;
                    }                 
                    component.set("v.docWrapper", this.fixEstadoDocumento(docWrapperReturned));
                }
                
                this.setButtonVisibility(component, component.get('v.docWrapper'));
                this.setButtonsEnabled(component, component.get('v.docWrapper'));
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "type": "Error",
                    "message": "Se ha producido un error al visualizar los documentos. Por favor intente de nuevo"
                });
                
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    setButtonVisibility: function(component, docWrapper) {
        component.set("v.isEstadoDisabled", true);
        component.set("v.isMotivoDisabled", true);
        component.set("v.isObservacionDisabled", true);
        component.set("v.showButtonEjecutivo", false);
        component.set("v.showButtonVisador", false);
        component.set("v.showButtonVisadorGuardar", false);
        component.set("v.showMoreDocsSection", false);
        if (component.get('v.docWrapper.isPerfilEspecialista') == "OK" && component.get('v.docWrapper.isPerfilJefeVisador') != "OK" &&
            (docWrapper.stageName == "Recopilación" || docWrapper.stageName == "Ingreso del Negocio" )){
            component.set("v.isEstadoDisabled", false);
            component.set("v.isMotivoDisabled", true);
            component.set("v.isObservacionDisabled", true);
            component.set("v.showButtonVisador", false);
            component.set("v.showButtonVisadorGuardar", false);
            component.set("v.showButtonEjecutivo", true);
        }else if (component.get('v.docWrapper.isPerfilEspecialista') == "OK"  && docWrapper.stageName == "Revisión") {
            component.set("v.isEstadoDisabled", true);
            component.set("v.isMotivoDisabled", true);
            component.set("v.isObservacionDisabled", true);
            component.set("v.showButtonEjecutivo", false);
            component.set("v.showButtonVisador", false);
            component.set("v.showButtonVisadorGuardar", false);
        }else if (component.get('v.docWrapper.isPerfilEspecialista') == "OK"  && docWrapper.stageName == "Contacto" && docWrapper.rtName == "plan_plus_sales" ){
                  component.set("v.isEstadoDisabled", false);
        }else if (component.get('v.docWrapper.isPerfilEspecialista') == "OK" && 
                 (docWrapper.stageName == "Ingreso del Negocio") &&
                  docWrapper.estadoAprobacionJefatura == 'Rechazado') {
            component.set("v.isEstadoDisabled", false);
            component.set("v.isMotivoDisabled", true);
            component.set("v.isObservacionDisabled", true);
            component.set("v.showButtonVisador", false);
            component.set("v.showButtonVisadorGuardar", false);
            component.set("v.showButtonEjecutivo", true);
        }else if (component.get('v.docWrapper.isPerfilEspecialista') == "OK" && component.get('v.docWrapper.isPerfilJefeVisador') != "OK" &&
            (docWrapper.stageName == "Recopilación" || docWrapper.stageName == "Ingreso del Negocio" ) &&
           	(docWrapper.rtName == "plan_plus_sales" || docWrapper.rtName == "sales_banca_hipotecario")) {
            component.set("v.isEstadoDisabled", false);
            component.set("v.isMotivoDisabled", true);
            component.set("v.isObservacionDisabled", true);
            component.set("v.showButtonVisador", false);
            component.set("v.showButtonVisadorGuardar", false);
            component.set("v.showButtonEjecutivo", true);
        }else if((component.get('v.docWrapper.isPerfilEspecialista') == "OK" && component.get('v.docWrapper.isPerfilJefeVisador') != "OK" &&
            (docWrapper.stageName == "Recopilación") &&
           	docWrapper.estadoAprobacionJefatura == 'Rechazado' && docWrapper.profile == 'Ejecutivo Especialista')) {
            component.set("v.isEstadoDisabled", false);
            component.set("v.isMotivoDisabled", true);
            component.set("v.isObservacionDisabled", true);
            component.set("v.showButtonVisador", false);
            component.set("v.showButtonVisadorGuardar", false);
            component.set("v.showButtonEjecutivo", true);
        }
        if ((component.get('v.docWrapper.isPerfilVisado') == "OK" || component.get('v.docWrapper.isPerfilJefeVisador'))  && docWrapper.stageName == "Revisión") {
            component.set("v.isEstadoDisabled", false);
            component.set("v.isMotivoDisabled", false);
            component.set("v.isObservacionDisabled", false);
            component.set("v.showButtonEjecutivo", false);
            component.set("v.showButtonVisador", true);
            component.set("v.showButtonVisadorGuardar", true);
        }   else if (component.get('v.docWrapper.isPerfilVisado') == "OK" && docWrapper.stageName == "Recopilación") {
            component.set("v.isEstadoDisabled", true);
            component.set("v.isMotivoDisabled", true);
            component.set("v.isObservacionDisabled", true);
            component.set("v.showButtonEjecutivo", false);
            component.set("v.showButtonVisador", false);
            component.set("v.showButtonVisadorGuardar", false);
        }
        if (component.get('v.docWrapper.isPerfilRiesgo') == "OK" && docWrapper.stageName == "Evaluación" 
            && (docWrapper.rtName == "sales_banca_hipotecario" || docWrapper.rtName == "sales_banca_hipotecario_lectura")
            && docWrapper.estadoAprobacionRiesgo == 'En Proceso') {
            component.set("v.showMoreDocsSection", true);
        }
       if ((component.get('v.docWrapper.isPerfilJefeVisador') == "OK" || component.get('v.docWrapper.isPerfilEspecialista') == "OK") && docWrapper.stageName == "Ingreso del Negocio" &&
            (docWrapper.rtName == "sales_credito_consumo_lectura" || docWrapper.rtName == "sales_credito_consumo") &&
            docWrapper.estadoAprobacionJefatura == "En Proceso") {
            component.set("v.isEstadoDisabled", false);
            component.set("v.isMotivoDisabled", false);
            component.set("v.isObservacionDisabled", false);
            component.set("v.showButtonEjecutivo", false);
            component.set("v.showButtonJefeVisador", true);
            component.set("v.showButtonJefeVisadorGuardar", true);
            component.set("v.showFirst", true);    
        }  
    },
    
    setButtonsEnabled: function(component, docWrapper) {
        var count = 0;
        var countGeneral = 0;
        var countVisador = 0;
        var countReject = 0;
        docWrapper.participantDoc.forEach(
            function myFunction(item, index) {
                for (var i = 0; i < item.documentsList.length; i++) {
                    countGeneral++;
                    if (item.documentsList[i].estado_documento_sales__c == "Ingresado" || item.documentsList[i].estado_documento_sales__c == "Aprobado" || 
                        item.documentsList[i].estado_documento_sales__c == "No aplica") {
                        count++;
                    }
                    
                    if ((item.documentsList[i].estado_documento_sales__c == "Aprobado"|| item.documentsList[i].estado_documento_sales__c == "No aplica") || 
                        (item.documentsList[i].estado_documento_sales__c == "Rechazado" && item.documentsList[i].motivo_rechazo_sales__c != "")) {
                        countVisador++;
                    }
                    if(item.documentsList[i].estado_documento_sales__c == "Rechazado" || item.documentsList[i].estado_documento_sales__c == ""){
                        countReject++;
                    }
                }
            }
        );
        
        if (count == countGeneral && component.get('v.docWrapper.isPerfilJefeVisador') != 'OK') {
            component.set("v.disableButtonEjecutivo", true);
            if ((docWrapper.rtName == "sales_banca_hipotecario" || docWrapper.rtName == "sales_banca_hipotecario_lectura" ||
                 docWrapper.rtName == "sales_credito_consumo" || docWrapper.rtName == "sales_credito_consumo_lectura")
                && (docWrapper.stageName == 'Recopilación' || docWrapper.stageName == 'Ingreso del Negocio' ) && docWrapper.estadoAprobacionJefatura == 'En Proceso') {
                component.set("v.disableButtonEjecutivo", false);
                if(docWrapper.rtName == "sales_banca_hipotecario" || docWrapper.rtName == "sales_banca_hipotecario_lectura"){
                     component.set("v.isEstadoDisabled", true);
                }else{
                    component.set("v.isEstadoDisabled", false); 
                } 
            }
        } else {
            component.set("v.disableButtonEjecutivo", false);
        }
            if (countVisador == countGeneral) {
                component.set("v.disableButtonVisador", true);
            } else {;
                component.set("v.disableButtonVisador", false);
            }
            if (countVisador == countGeneral) {   
                if(countReject == 0){
                    component.set("v.disableApproveButtonJefeVisador", false);
                    component.set("v.disableButtonJefeVisador", true);
                }else{
                    component.set("v.disableApproveButtonJefeVisador", true);
                    component.set("v.disableButtonJefeVisador", false);
                }
            } else {
                component.set("v.disableButtonJefeVisador", true);
            }   
    },
    
    getAditionalDocHelper : function(component) {
        var action = component.get("c.getValuesDocumentClient");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.documentTypeValues", data);    
            }      
        });
        $A.enqueueAction(action);
    },
    saveAditionalDocBack: function(component, idParticipant) {
        component.set('v.enabledSpinner', true);
    	var action = component.get("c.addNewDocumentType");
        action.setParams({
            "oppId": component.get('v.recordId'),
            "name": component.get('v.selectedDocumentType'),
            "detail": component.get('v.documentDetail'),
            "idParticipant": idParticipant
        });
        action.setCallback(this, function (response) {
            component.set('v.enabledSpinner', false);
            var state = response.getState();
            if (state === "SUCCESS") {
                this.getData(component, event);
                component.set('v.selectedDocumentType', '');
                component.set('v.documentDetail', '');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Correcto",
                    "message": 'Se ha ingresado el documento solicitado con éxito',
                    "type": "success"
                });
                toastEvent.fire();
            } else {
                var errorMsg = (response.getError() != null && response.getError()[0] != null) ? 
                    response.getError()[0].message : "Se ha producido un error al solicitar el documento";
                var type = (response.getError() != null && response.getError()[0] != null) ? "Warning" : "Error";
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": errorMsg,
                    "type": type
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);  
    },
    
    countDocumentSize: function (wrapper) {
    	var size = 0;
    	wrapper.participantDoc.forEach(
            function myFunction(item, index) {
                for (var i = 0; i < item.documentsList.length; i++) {
                    size++;
                }
            }
        );
    	return size;
	},
    
    fixEstadoDocumento: function (wrapper) {
    	wrapper.participantDoc.forEach(
            function myFunction(item, index) {
                for (var i = 0; i < item.documentsList.length; i++) {
                    if (item.documentsList[i].estado_documento_sales__c == null || 
                        item.documentsList[i].estado_documento_sales__c === undefined) {
                        item.documentsList[i].estado_documento_sales__c = '';
                    }
                }
            }
        );
    	return wrapper;
	},
    sendToEvaluate : function(component, oppId) {
        component.set('v.enabledSpinnerModal', true);
        var action = component.get("c.sendToApproveManager");
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
                    component.set("v.showSendTo", false);
                    component.set("v.showButtonJefeVisador", false);
                    component.set("v.showButtonJefeVisadorGuardar", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Oportunidad Aprobada",
                        "message": "La aprobación será informada al ejecutivo",
                        "type": "success"  
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }else if(retValue === "ERRA02"){
                	var toastEvent = $A.get("e.force:showToast");
                	toastEvent.setParams({
						"message": 'El campo Número Solicitud es obligatorio y numérico',
						"type": "Error"
					});
                    
					toastEvent.fire();
                }else {
                   var toastEvent = $A.get("e.force:showToast"); 
                  toastEvent.setParams({
                    "message": 'Se ha producido un error contacte al Administrador ',
                    "type": "Error"
                    });
                    toastEvent.fire();  
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    sendToClose : function(component, oppId) {
        component.set('v.enabledSpinnerModal', true);
        var action = component.get("c.rejectProposalConfirmBoss");
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
                    component.set("v.showSendTo", false);
                    component.set("v.showButtonJefeVisador", false);
                    component.set("v.showButtonJefeVisadorGuardar", false);
                    var toastEvent = $A.get("e.force:showToast");   
                    toastEvent.setParams({
                        "title": "Oportunidad Cerrada",
                        "message": "La Opportunidad ha sido cerrada perdidad",
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
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oportunidad Rechazada",
                    "message": "La Opportunidad ha sido rechazada",
                    "type": "success"
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
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
    
})