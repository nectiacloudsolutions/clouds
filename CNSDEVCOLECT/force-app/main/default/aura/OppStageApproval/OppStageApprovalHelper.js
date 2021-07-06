({
    getDataForValidation: function(component, event) {
        component.set('v.enabledSpinner', true);
        
        var action = component.get("c.getInitialData");
        
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var val = response.getReturnValue();
            //console.log("Response value json: " + JSON.stringify(val));
            component.set('v.enabledSpinner', false);
            
            if (state === "SUCCESS") {
                if (($A.get('$SObjectType.CurrentUser.Id') === val.Manager[0].Id)  && (val.Opportunity[0].StageName == "Recopilación") && (val.Opportunity[0].aprobacion_visado_sales__c == 'Rechazado')) {
                    component.set("v.showEjecutiveProfile", true); // Ve el motivo de rechazo
                    component.set("v.supervisorObs", val.Opportunity[0].Motivo_otro_sales__c)
                    
                } else if ((((val.Manager[0].ManagerId != undefined && $A.get('$SObjectType.CurrentUser.Id') === val.Manager[0].ManagerId)) || $A.get('$SObjectType.CurrentUser.Id') == val.Manager[0].Id ||
                            ( val.Manager[0].ManagerId != undefined && val.Manager[0].Manager.ManagerId != undefined && 
                             $A.get('$SObjectType.CurrentUser.Id') === val.Manager[0].Manager.ManagerId)) && (val.Opportunity[0].StageName == "Recopilación") &&
                           (val.Opportunity[0].aprobacion_visado_sales__c == 'En Proceso')) {
                    component.set("v.showSalesManager", true);
               /* } else if ((((val.Manager[0].ManagerId != undefined && $A.get('$SObjectType.CurrentUser.Id') === val.Manager[0].ManagerId)) || 
                         ( val.Manager[0].ManagerId != undefined && val.Manager[0].Manager.ManagerId != undefined && 
                          $A.get('$SObjectType.CurrentUser.Id') === val.Manager[0].Manager.ManagerId)) && (val.Opportunity[0].StageName == "Ingreso del Negocio") && 
                           (val.Opportunity[0].aprobacion_visado_sales__c == 'En Proceso')) {
                    component.set("v.showSalesManager", true);
                    component.set("v.showFirstSection", false);
                    component.set("v.showSecondSection", false);
                    component.set("v.showThirdSection", true);
                    */
                }else if (($A.get('$SObjectType.CurrentUser.Id') === val.Id)  && (val.Opportunity[0].StageName == "Ingreso del Negocio" ) && (val.Opportunity[0].aprobacion_visado_sales__c == 'Rechazado')) {
                    component.set("v.showEjecutiveProfile", true); // Ve el motivo de rechazo
                    component.set("v.supervisorObs", val.Opportunity[0].Motivo_otro_sales__c)
                    
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "type": "Error",
                    "message": "Se ha producido un error al visualizar el componente de aprobación de documentos. Por favor intente de nuevo"
                });
                
                toastEvent.fire();
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    approveManagerHelper: function(component, oppId) {
        component.set('v.enabledSpinner', true);
        
        var action = component.get("c.stageApprovalManager");
        
        action.setParams({
            oppId: oppId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.enabledSpinner', false);
            
            var error = false;
            
            if (state === "SUCCESS") {
                var retValue = response.getReturnValue();
                
                if (retValue == 'OK') {
                    component.set("v.showModalConfirmation", false);
                    var toastEvent = $A.get("e.force:showToast");
                    
                    toastEvent.setParams({
                        "title": "Oportunidad Aprobada",
                        "message": "La aprobación será informada al ejecutivo",
                        "type": "success"
                        
                    });
                    
                    toastEvent.fire();
                    
                    $A.get('e.force:refreshView').fire();
                }else if(retValue == "ERRA03"){
                	var toastEvent = $A.get("e.force:showToast");
                	toastEvent.setParams({
						"message": 'El campo Número Oportunidad PCH es obligatorio y numérico',
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
    
    doReject: function(component) {
		component.set('v.enabledSpinner', true);
        
        var action = component.get("c.stageRejectManager");
        
        action.setParams({
            oppId: component.get('v.recordId'),
            motivo: component.get('v.supervisorObs')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.enabledSpinner', false);
            
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Oportunidad Evaluada",
                    "message": "Resultado: Rechazada",
                    "type": "success"                    
                });
                
                toastEvent.fire();
                component.set('v.showFourthSection', false);
                $A.get('e.force:refreshView').fire();
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "type": "Error",
                    "message": "Se ha producido un error al efectuar el rechazo. Por favor intente de nuevo"
                });
                
                toastEvent.fire();
            }
        });
        
        $A.enqueueAction(action);        
    },
        sendToEvaluate : function(component, oppId) {
        component.set('v.enabledSpinner', true);
        var action = component.get("c.sendToApproveManager");
        action.setParams({
            oppId: oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.enabledSpinner', false);
            var error = false;
            if (state === "SUCCESS") {
                var retValue = response.getReturnValue();
                
                if (retValue == 'OK') {
                    component.set("v.showSendTo", false);
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
    sendToClose : function(component, oppId) {
        component.set('v.enabledSpinner', true);
        var action = component.get("c.rejectProposalConfirmBoss");
        action.setParams({
            oppId: oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.enabledSpinner', false);
            var error = false;
            if (state === "SUCCESS") {
                var retValue = response.getReturnValue();
                
                if (retValue == 'OK') {
                    component.set("v.showSendTo", false);
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
    
})