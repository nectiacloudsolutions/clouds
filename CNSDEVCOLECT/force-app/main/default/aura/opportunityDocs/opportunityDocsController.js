({
	doInit: function (component, event, helper) {
		helper.getData(component, event);
	},
    
    onChangeStage: function (component, event, helper) {

        if (event.getParam('type') !== undefined && event.getParam('type') == 'success') {
         
            if (event.getSource().getLocalId() !== undefined && event.getSource().getLocalId() == 'saveRecordCmp') {
                $A.enqueueAction(component.get('c.doInit'));
            }
        }
    },
    
	openModal: function (component, event, helper) {
		component.set("v.isOpen", true);
	},
    
	closeModal: function (component, event, helper) {
		component.set("v.isOpen", false);
	},
    
	onChange: function (cmp, evt, helper) {
		var slct = evt.getSource().get("v.value");
		var id = evt.getSource().get("v.name");
		var doc = cmp.get("v.docWrapper");
        cmp.set('v.disableButtonVisador', false);

	
		if (cmp.get('v.docWrapper.isPerfilEspecialista') == "OK" && cmp.get('v.docWrapper.isPerfilJefeVisador') != "OK") {
			var action = cmp.get("c.saveDoc");
			
            action.setParams({
				"oppDocId": id,
				"value": slct,
			});
			
            action.setCallback(this, function (response) {
                cmp.set('v.isLoading', false);
                
				var state = response.getState();
				var res = response.getReturnValue();
                if (cmp.isValid() && state === "SUCCESS") {
					var toastEvent = $A.get("e.force:showToast");
					
                    toastEvent.setParams({
						"title": "Correcto",
						"message": 'Se ha actualizado el estado del documento con éxito',
						"type": "success"
					});
					
                    toastEvent.fire();
                    
                    helper.setButtonsEnabled(cmp, cmp.get('v.docWrapper'));
                    
				}
                else {
                    var toastEvent = $A.get("e.force:showToast");
					
                    toastEvent.setParams({
						"message": 'Se ha producido un error al actualizar el estado del documento',
						"type": "Error"
					});
					
                    toastEvent.fire();
                }
			});
            
			$A.enqueueAction(action);
            cmp.set('v.isLoading', true);
		}
        else if (slct == 'Rechazado')  {
            doc.participantDoc.forEach(
                function myFunction(item, index) {
                    for (var i = 0; i < item.documentsList.length; i++) {
                        if (item.documentsList[i].Id == id) {
                            item.documentsList[i].motivo_rechazo_sales__c = '';
                            item.documentsList[i].observaciones_sales__c = '';
                        }
                    }
                }
            );
        }
        cmp.set("v.docWrapper",JSON.parse(JSON.stringify(doc)));
        
	},
    
	sendVisado: function (cmp, evt, helper) {
        var visadoOrJefatura = 'Revisión';
        var docWrapper = cmp.get("v.docWrapper");
        
        if (docWrapper.rtName == 'sales_banca_hipotecario' || docWrapper.rtName == 'sales_banca_hipotecario_lectura' || 
            docWrapper.rtName == 'sales_credito_consumo' || docWrapper.rtName == 'sales_credito_consumo_lectura') {
            visadoOrJefatura = 'Jefatura';
        }
        
        var action = '';
        
        if (visadoOrJefatura == 'Revisión') {
            action = cmp.get("c.sendToValidate");
        }
        else {
            action = cmp.get("c.sendToJefatura");  
        }
		
		action.setParams({
			"oppId": cmp.get("v.recordId"),
		});
        
		action.setCallback(this, function (response) {
			var state = response.getState();
			var res = response.getReturnValue();
            
            var toastEvent = $A.get("e.force:showToast");
            var error = false;
            
			if (cmp.isValid() && state === "SUCCESS") {
				if (res == "OK") {
					toastEvent.setParams({
						"title": "Correcto",
						"message": 'Se ha enviado a ' + visadoOrJefatura + ' con éxito',
						"type": "success"
					});
                    
					toastEvent.fire();
                    
                   
                    
					cmp.set("v.isEstadoDisabled", true);
					cmp.set("v.isMotivoDisabled", true);
					cmp.set("v.isObservacionDisabled", true);
					cmp.set("v.showButtonEjecutivo", false);
					cmp.set("v.showButtonVisador", false);
					cmp.set("v.showButtonVisadorGuardar", false);
                    
					$A.get('e.force:refreshView').fire();
				} else if(res === "ERRA01"){
                    if(docWrapper.rtName == 'plan_plus_lectura_sales' || docWrapper.rtName== 'plan_plus_sales' && 
                       docWrapper.profile == 'Jefe de Ventas' || docWrapper.profile == 'Ejecutivo de Venta'){
                        toastEvent.setParams({
                            "message": 'Error: Debe referir la oportunidad para continuar el flujo.',
                            "type": "Error"
                        });
                    }else{
                        toastEvent.setParams({
						"message": 'El campo Número Oportunidad Comercializadora es obligatorio y númerico',
						"type": "Error"
					});
                    }
                	
                    
					toastEvent.fire();
                }else if(res === "ERRA02"){
                
                	toastEvent.setParams({
						"message": 'El campo Número Solicitud es obligatorio y númerico',
						"type": "Error"
					});
                    
					toastEvent.fire();
                }else if(res == "ERRA04") {
                    toastEvent.setParams({
                        "message": 'Error: Debe referir la oportunidad para continuar el flujo.',
                        "type": "Error"
                    });
                    
                    toastEvent.fire();  
                }else{
                    toastEvent.setParams({
                    "message": 'Se ha producido un error al enviar a ' + visadoOrJefatura,
                    "type": "Error"
                    });
                    
                    toastEvent.fire();  
                }
			}
		});
        
		cmp.set("v.isOpen", false);
		$A.enqueueAction(action);
	},
    
    saveDocVisado : function (cmp, evt, helper) {
		var docWrapper = cmp.get("v.docWrapper");
        var countSeleccione = 0;
		var countValida = 0;
        var docList = [];
        
        docWrapper.participantDoc.forEach(
            function myFunction(item, index) {
                for (var i = 0; i < item.documentsList.length; i++) {
                    docList.push(item.documentsList[i]);
                    
                    if (item.documentsList[i].estado_documento_sales__c == "Seleccionar") {
                        countSeleccione++;
                    }
                    
                    if ((item.documentsList[i].estado_documento_sales__c == "Rechazado" && item.documentsList[i].motivo_rechazo_sales__c === "Seleccionar") || 
                        (item.documentsList[i].estado_documento_sales__c == "Rechazado" && item.documentsList[i].motivo_rechazo_sales__c === "")) {
                        countValida++;
                    }
                }
            }
        );
        
        var toastEvent = $A.get("e.force:showToast");
        
        if (countSeleccione > 0) {
            toastEvent.setParams({
				"title": "Atención",
				"message": 'Por favor, ingrese el estado de todos los documentos',
				"type": "warning"
			});
            
			toastEvent.fire();
        }
		else if (countValida > 0) {
			toastEvent.setParams({
				"title": "Atención",
				"message": 'Por favor, ingrese todos los motivo de rechazo requeridos',
				"type": "warning"
			});
            
			toastEvent.fire();
		} else {
			var action = cmp.get("c.saveAllDocs");
            action.setParams({
				"docOppList": docList,
			});
			
            action.setCallback(this, function (response) {
                
				var state = response.getState();
				var res = response.getReturnValue();
                cmp.set('v.isLoading', false);
				if (cmp.isValid() && state === "SUCCESS") {
					var toastEvent = $A.get("e.force:showToast");
					if (res == "OK") {
						toastEvent.setParams({
                            "title": "Correcto",
                            "message": 'Se han actualizado los documentos con éxito',
                            "type": "success"
                        });
						toastEvent.fire();
                        helper.setButtonsEnabled(cmp, cmp.get('v.docWrapper'));
					} else {
						toastEvent.setParams({
                            "message": 'Se ha producido un error al actualizar los documentos',
                            "type": "Error"
                        });
                        toastEvent.fire();
					}
				}
			});
            
			$A.enqueueAction(action);
            cmp.set('v.isLoading', true);
		}
        helper.setButtonsEnabled(cmp, cmp.get('v.docWrapper'));
	},
    
	finishVisado: function (cmp, evt) {
        var action = cmp.get("c.visadoDecision");
        var docWrapper = cmp.get("v.docWrapper");
		var estado = '';
        var count = 0;
        var countRechazos = 0;
        docWrapper.participantDoc.forEach(
            function myFunction(item, index) {
                for (var i = 0; i < item.documentsList.length; i++) {
                    if (item.documentsList[i].estado_documento_sales__c == "Rechazado" || 
                        item.documentsList[i].estado_documento_sales__c == "Ingresado" ||
                        item.documentsList[i].estado_documento_sales__c == "") {
                        count++;
                    }
                }
            }
        );
        
		if (count > 0) {
			estado = "RECHAZADO";
		} else {
			estado = "APROBADO";
		}
        
		action.setParams({
			"oppId": cmp.get("v.recordId"),
			"decision": estado
		});
        
		action.setCallback(this, function (response) {
			var state = response.getState();
			var res = response.getReturnValue();
            
			if (cmp.isValid() && state === "SUCCESS") {
				var toastEvent = $A.get("e.force:showToast");
                
				if (res == "OK") {
					toastEvent.setParams({
						"title": "Correcto",
						"message": 'Se ha finalizado la Revisión con éxito',
						"type": "success"
					});
					toastEvent.fire();
					$A.get('e.force:refreshView').fire();
                }else if(res === "ERRA01"){
                	toastEvent.setParams({
						"message": 'El campo Número Oportunidad Comercializador es obligatorio y númerico',
						"type": "Error"
					});
					toastEvent.fire();
				} else {
					toastEvent.setParams({
						"message": 'Se ha producido un error al finalizar la Revisión',
						"type": "Error"
					});
					toastEvent.fire();
				}
			}
		});
        
		cmp.set("v.isOpen", false);
		$A.enqueueAction(action);
	},
    
    disableFinalizarVisado : function (cmp, evt, helper) {
        cmp.set('v.disableButtonVisador', false);
    },
    
    getAditionalDocTypes : function(component, event, helper) {
        helper.getAditionalDocHelper(component);	
        
    },
    
    clickAddDocument :function(component, event, helper) {
        var selectedDocumentType = component.get("v.selectedDocumentType");
        var documentDetail = component.get("v.documentDetail");
        if (selectedDocumentType.trim() != '' && documentDetail.trim() != '') {
            var idParticipant = null;
            var selectedTabClient = component.get('v.selectedTabClient');
            if (selectedTabClient == 'participant') {
                var selectedTabParticipant = component.get('v.selectedTabParticipant');
                var partSplit = selectedTabParticipant.split("-");
                var partIdx = partSplit[1];
                var docWrapper = component.get("v.docWrapper");
                idParticipant = docWrapper.participantDoc[partIdx].idParticipante;
            }
            helper.saveAditionalDocBack(component, idParticipant);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            
            toastEvent.setParams({
                "title": "Atención",
				"message": 'Por favor, ingrese los campos requeridos',
				"type": "warning"
            });
            toastEvent.fire();
        }
    },
    sendToRisk: function(component, event, helper){
        component.set("v.headerSendTo", $A.get("$Label.c.OSA_BtnAcceptHeader"));
        component.set("v.textSendTo", $A.get("$Label.c.OSA_BtnAcceptBody"));
        component.set("v.showSendTo", true);
    },
    sendToExecutive : function(component, event, helper){
        component.set("v.showFirst", false);
    },
    sendToClose : function(component, event, helper){
        component.set("v.headerSendTo", $A.get("$Label.c.OSA_BtnCloseHeader"));
        component.set("v.textSendTo", $A.get("$Label.c.OSA_BtnCloseBody"));
        component.set("v.showSendTo", true); 
    },
    approveManagerOSA : function(component, event, helper){
        var oppId = component.get("v.recordId");
        if(component.get("v.textSendTo") ==  $A.get("$Label.c.OSA_BtnAcceptBody")){
            helper.sendToEvaluate(component,oppId);
        }
        if(component.get("v.textSendTo") ==  $A.get("$Label.c.OSA_BtnRejectBody")){
            helper.sendToReject(component,oppId);
        }
        if(component.get("v.textSendTo") ==  $A.get("$Label.c.OSA_BtnCloseBody")){
            helper.sendToClose(component,oppId);
        }
    },
        closeModalOSA : function(component, event, helper) {
        component.set("v.showSendTo", false);
        },
    onConfirmOSA: function(component, event, helper) {
        var supervisorObs = component.get("v.supervisorObs");
        if (supervisorObs != null && supervisorObs.trim() != '') {
            component.set("v.headerSendTo", $A.get("$Label.c.OSA_BtnRejectHeader"));
            component.set("v.textSendTo", $A.get("$Label.c.OSA_BtnRejectBody"));
            component.set("v.showSendTo", true);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Atención",
                "type": "Warning",
                "message": "Por favor, ingrese un motivo de rechazo"
            });
            
            toastEvent.fire();
        }
    },
    onCancelOSA: function(component, event, helper) {
        component.set("v.showFirst", true);
        component.set("v.supervisorObs", '');
    },
    
    changeDocState: function (cmp, evt, helper) {
        var action = cmp.get("c.setAllDocsStateTo");
        var docWrapper = cmp.get("v.docWrapper");
		var estado = 'Ingresado';
		action.setParams({
			"id": cmp.get("v.recordId"),
			"estado": estado
		});        
		action.setCallback(this, function (response) {
			var state = response.getState();
			var res = response.getReturnValue(); 
			if (cmp.isValid() && state === "SUCCESS") {
				var toastEvent = $A.get("e.force:showToast");
				if (res == "OK") {
					toastEvent.setParams({
						"title": "Correcto",
						"message": 'Los documentos han cambiado a estado Ingresado',
						"type": "success"
					});
					toastEvent.fire();
                   	docWrapper.participantDoc.forEach(
                        function myFunction(item, index) {
                            for (var i = 0; i < item.documentsList.length; i++) {           
                                    item.documentsList[i].estado_documento_sales__c = 'Ingresado';   
                            }
                        }
                    );
                    cmp.set("v.docWrapper",JSON.parse(JSON.stringify(docWrapper)));		
				} else {
					toastEvent.setParams({
						"message": 'Se ha producido un error al cambiar el estado de los documentos',
						"type": "Error"
					});
					toastEvent.fire();
				}
			}
		});
       
        
		$A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
	},
  changeDocStateAproved: function (cmp, evt, helper) {
        var action = cmp.get("c.setAllDocsStateTo");
        var docWrapper = cmp.get("v.docWrapper");
		var estado = 'Aprobado';
		action.setParams({
			"id": cmp.get("v.recordId"),
			"estado": estado
		});        
		action.setCallback(this, function (response) {
			var state = response.getState();
			var res = response.getReturnValue(); 
			if (cmp.isValid() && state === "SUCCESS") {
				var toastEvent = $A.get("e.force:showToast");
				if (res == "OK") {
					toastEvent.setParams({
						"title": "Correcto",
						"message": 'Los documentos han cambiado a estado Aprobado',
						"type": "success"
					});
					toastEvent.fire();
                   	docWrapper.participantDoc.forEach(
                        function myFunction(item, index) {
                            for (var i = 0; i < item.documentsList.length; i++) {           
                                    item.documentsList[i].estado_documento_sales__c = 'Aprobado';   
                            }
                        }
                    );
                 
                    cmp.set("v.docWrapper",JSON.parse(JSON.stringify(docWrapper)));
             		
				} else {
					toastEvent.setParams({
						"message": 'Se ha producido un error al cambiar el estado de los documentos',
						"type": "Error"
					});
                    
					toastEvent.fire();
				}
			}
		});
       
        
		$A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
    },  
    handleComponentEvent: function (component, event, helper) {
        helper.getData(component, event);
        
    },
    
})