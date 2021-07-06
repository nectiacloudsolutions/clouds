({
    
    getData: function (cmp, event, helper) {  
        var IdAcc = cmp.get("v.recordId");
        var acttion = cmp.get("c.getAccessPerfilEjecutivo");
        cmp.set("v.loading",true);
        acttion.setCallback(this, function (response){
            var state = response.getState();
            var respuesta = response.getReturnValue();
            if(state === "SUCCESS"){
                if(respuesta == "OK"){      
                    cmp.set("v.loading", true);
                    var action = cmp.get("c.viewDoc");
                    cmp.set("v.pdfContainer", '');
                    action.setParams({
                        IdAcc: IdAcc,
                    });
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        console.log(response.getReturnValue());
                        if (state === "SUCCESS") {
                            cmp.set("v.ShowCmp",true);
                            var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));    
                            // console.log('OBJETO-->' +rootObj); 
                            var pdfData = rootObj;
                            $A.createComponent(
                                "c:pdfViewer",
                                {
                                    "pdfData": pdfData
                                },
                                function (pdfViewer, status, errorMessage) {
                                    if (status === "SUCCESS") {
                                        var pdfContainer = cmp.get("v.pdfContainer");
                                        pdfContainer.push(pdfViewer);
                                        cmp.set("v.pdfContainer", pdfContainer);
                                        cmp.set("v.isOpenPdf", true);
                                        cmp.set("v.loading",false);
                                    }
                                    else {
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "title": "Error",
                                            "message": "Ha ocurrido un error, revise la plantilla de correo asignada.",
                                            "type": "error"
                                        });
                                        toastEvent.fire();
                                        cmp.set("v.loading",false);
                                    }   
                                }
                            );         
                            cmp.set("v.loading", false);
                        } else {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error",
                                "message": "Ha ocurrido un error, por favor contacte al administrador.",
                                "type": "error"
                            });
                            toastEvent.fire();
                        }
                    });
                    $A.enqueueAction(action);
                }else{
                    cmp.set("v.loading",false);
                    cmp.set("v.ShowCmp",false); 
                }
            }else{
                toastEvent.setParams({
                    "title": "Error",
                    "message": "Ha ocurrido un error, por favor contacte al administrador.",
                    "type": "error"
                });
                toastEvent.fire();
                cmp.set("v.loading",false);
            }
        });
        $A.enqueueAction(acttion);
    },
    confirm: function (cmp, accId) {
        cmp.set("v.loading", true);
        var IdAcc = accId;
        console.log(IdAcc);
        var action = cmp.get("c.DataNotAuthorizeAndInsertCase");
        action.setParams({
            idAcc: IdAcc,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));    
                //console.log('OBJETO-->' +rootObj);
                if (state === "SUCCESS") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Desautoriza Uso de Datos",
                        "message": "Se ha ingresado el caso exitosamente.",
                        "type": "success"
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
                else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "Ha ocurrido un error, contacte al administrador.",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
                
                cmp.set("v.loading", false);
                $A.get('e.force:refreshView').fire();
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "Ha ocurrido un error, por favor contacte al administrador.",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})