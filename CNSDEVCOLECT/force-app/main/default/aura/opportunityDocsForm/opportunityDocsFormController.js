/**
 * @File Name          : opportunityDocsFormController.js
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 7/3/2020, 1:39:45 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    7/3/2020   eayalcor@everis.com     Initial Version
**/
({
    doInit: function (component, event, helper) {
        helper.getData(component, event);
    },
    sendToPreVisado: function (component, event, helper) {

        component.set("v.enablePreVisadoButton", false);
    },
    onChange: function (cmp, evt, helper) {
        var slct = evt.getSource().get("v.value");
        var id = evt.getSource().get("v.name");
        var doc = cmp.get("v.docWrapper");
        var action = cmp.get("c.saveDoc");

        action.setParams({
            "oppDocId": id,
            "value": slct,
        });

        action.setCallback(this, function (response) {

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

                helper.setButtonsEnabled(cmp, doc);

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
        
        cmp.set("v.docWrapper", JSON.parse(JSON.stringify(doc)));
        helper.getData(cmp, evt);
        
    },
    sendToExecutive: function (component, event, helper) {
        component.set("v.showButtonsPreVisado", false);       
    },
    onCancelOSA: function (component, event, helper) {
        
        component.set("v.showButtonsPreVisado", true);
        component.set("v.supervisorObs", '');
    },
    openModel: function (component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    closeModel: function (component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    saveContactRecord: function (component, event, helper) {
        if (component.get("v.selectedLookUpRecord").Id != undefined) {
            
            var userId = component.get("v.selectedLookUpRecord").Id;
        }
        
        //call apex class method
        var action = component.get("c.saveApproval");
        var doc = component.get("v.docWrapper");
        action.setParams({
            "userId": userId,
            "recordId": component.get("v.recordId")
        })
        action.setCallback(this, function (response) {
            //var result = response.getReturnValue();
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "message": "Se agrego Pre-Visado"
                });
                toastEvent.fire();
                
                component.set("v.isOpen", false);
                component.set("v.readOnly", true);
                component.set("v.isEstadoDisabled", true);
                component.set("v.disablePreVisadoButton", true);
                
                helper.getData(component, event);
                
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
    disableFinalizarVisado: function (cmp, evt, helper) {
        // cmp.set('v.disableButtonVisador', false);
    },
    sendToCurse: function (component, event, helper) {
        component.set("v.headerSendTo", $A.get("$Label.c.OSA_BtnAcceptHeader"));
        component.set("v.textSendTo", $A.get("$Label.c.ODF_BtnApprovePre"));
        component.set("v.showSendTo", true);
    },
    onConfirmOSA: function (component, event, helper) {
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
    
    approveManagerOSA: function (component, event, helper) {
        var oppId = component.get("v.recordId");

        if (component.get("v.textSendTo") == $A.get("$Label.c.ODF_BtnApprovePre")) {
            helper.sendToEvaluate(component, oppId);
        }
        if (component.get("v.textSendTo") == $A.get("$Label.c.OSA_BtnRejectBody")) {
            helper.sendToReject(component, oppId);
        }
        if (component.get("v.textSendTo") == $A.get("$Label.c.OSA_BtnCloseBody")) {
            helper.sendToClose(component, oppId);
        }
    },
    closeModalOSA: function (component, event, helper) {
        component.set("v.showSendTo", false);
    },
    deleteFile: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title": "Atención",
            "type": "Warning",
            "message": "Por favor, ingrese un motivo de rechazo"
        });
        
        toastEvent.fire();
    },
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent: function (component, event, helper) {
        // get the selected Account record from the COMPONETN event 	 
        var changeP = event.getParam("changePickList");
        helper.getData(component, event);
        
    },
    saveDocVisado : function (cmp, evt, helper) {
        var docWrapper = cmp.get("v.docWrapper");
        var countSeleccione = 0;
        var countValida = 0;
        var docList = [];
        docWrapper = JSON.parse(JSON.stringify(docWrapper));
        console.log('Lista de docs: '+ JSON.parse(JSON.stringify(docWrapper.listaDocs)));
        
        console.log('ACAAAAA '+cmp.get('v.docWrapper'));
        cmp.get('v.docWrapper').listaDocs.forEach(
            function myFunction(item, index) {
                console.log('ENTRO' + item); 
                docList.push(item);    
                if (item.estado_documento_sales__c == "Seleccionar") {
                    countSeleccione++;
                }     
                if ((item.estado_documento_sales__c == "Rechazado" && item.motivo_rechazo_sales__c === "Seleccionar") || 
                    (item.estado_documento_sales__c == "Rechazado" && item.motivo_rechazo_sales__c === "")) {
                    countValida++;
                }                
            });
        
        
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
                "docOppList": cmp.get('v.docWrapper').listaDocs,
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
    finishVisado: function (cmp, evt,helper) {
        var action = cmp.get("c.visadoDecision");
        var docWrapper = cmp.get("v.docWrapper");
        var estado = '';
        var count = 0;
        var countRechazos = 0;
        
        docWrapper = JSON.parse(JSON.stringify(docWrapper));

        cmp.get('v.docWrapper').listaDocs.forEach(
            function myFunction(item, index) {;    
                if (item.estado_documento_sales__c == "Rechazado" ) {
                    count++;
                }     
            });
        
     
        
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
            cmp.set("v.isLoading",false);
            var state = response.getState();
            var res = response.getReturnValue();
            
            if (cmp.isValid() && state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                
                if (res == "OK") {
                    cmp.set("v.disableButtonVisador", true);
                    toastEvent.setParams({
                        "title": "Correcto",
                        "message": 'Se ha finalizado el Visado con éxito',
                        "type": "success"
                    });
                    
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    
                } else {
                    toastEvent.setParams({
                        "message": 'Se ha producido un error al finalizar el Visado',
                        "type": "Error"
                    });
                    
                    toastEvent.fire();
                }
            }
        });
        
        cmp.set("v.isOpenVisador", false);
        $A.enqueueAction(action);
        cmp.set("v.isLoading",true);
        helper.getData(cmp, evt);
    },
    
    disableFinalizarVisado : function (cmp, evt, helper) {
        cmp.set('v.disableButtonVisador', false);
    },
    
    onChangeCurse: function (cmp, evt, helper) {
        var slct = evt.getSource().get("v.value");
        var id = evt.getSource().get("v.name");
        var docWrapper = cmp.get("v.docWrapper");

        if (slct == 'Rechazado')  {
            docWrapper.listaDocs.forEach(
                function myFunction(item, index) {
                    
                    if (item.Id == id) {
                        item.motivo_rechazo_sales__c = '';
                        item.observaciones_sales__c = '';
                        cmp.set("v.disableButtonVisador",false);
                    }
                    
                }
            );
            
        }else if(slct == 'Aprobado'){
            docWrapper.listaDocs.forEach(
                function myFunction(item, index) {
                    
                    if (item.Id == id) {
                        item.motivo_rechazo_sales__c = '';
                        item.observaciones_sales__c = '';
                        cmp.set("v.disableButtonVisador",false);
                    }
                    
                }
            );
        }else if(slct == 'Ingresado'){
            docWrapper.listaDocs.forEach(
                function myFunction(item, index) {
                    if (item.Id == id) {
                        cmp.set("v.disableButtonVisador",false);
                    }
                }
            );
        }else if(slct == 'No aplica'){
            docWrapper.listaDocs.forEach(
                function myFunction(item, index) {
                    if (item.Id == id) {
                        cmp.set("v.disableButtonVisador",false);
                    }
                }
            );
        }
        
        
        
        cmp.set("v.docWrapper", JSON.parse(JSON.stringify(docWrapper)));
        
    },
    openModal: function (component, event, helper) {
        component.set("v.isOpenVisador", true);
    },
    closeModal: function (component, event, helper) {
		component.set("v.isOpenVisador", false);
	},

})