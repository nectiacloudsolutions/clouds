({
    doInit: function (component, event, helper) {
        var array = [];
        array = component.get("v.statusActionButton").split(',');

        component.set("v.isDisabledFile", array[0] == 'f' ? false : true);
        component.set("v.isDisabledDelete", array[1] == 'f' ? false : true);
        component.set("v.isDisabledView", array[2] == 'f' ? false : true);
    },
    handleFilesChange: function (component, event, helper) {
        var confirmed = true;
        if (event.getSource().get("v.files").length > 0) {
            if(component.get("v.needConfirm")){
                confirmed = confirm("Documento: "+component.get("v.fileName")+"\n ¿Confirma que el documento cumple con los criterios para ser enviado?");
            }
            if(confirmed){
                helper.uploadHelper(component, event);
            }
        }
    },
    deleteFile: function (component, event, helper) {
        component.set("v.showSpinner", true);
        var idDocs = component.get("v.idDocs");
        var action = component.get("c.updateDocsNew");
        action.setParams({
            IdDocs: idDocs,
            IdAlfresco: "",
            EstadoDoc: ""
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSpinner", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Correcto",
                    message: "Archivo eliminado correctamente.",
                    type: "Success"
                });

                // call the event   
                var compEvent = component.getEvent("eventFileUpload");
                // set the Selected sObject Record to the event attribute.  
                compEvent.setParams({ "changePickList": true });
                // fire the event  
                compEvent.fire();
                toastEvent.fire();
            } else {
                console.log("Unknown error");
            }
        });
        $A.enqueueAction(action);
    },
    viewFile: function (cmp, event, helper) {
        cmp.set("v.showSpinner", true);
        var idDoc = cmp.get("v.idDocs");
        var action = cmp.get("c.viewDocNew");
        cmp.set("v.pdfContainer", '');
        action.setParams({
            idDoc: idDoc,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));
                if (rootObj.dtoResponseSetParametros.codigoError=='0') {
                    cmp.set("v.UploadAlfresco", rootObj);
                    
                    var pdfData = rootObj.salidaDocAlfresco.bytes;

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
                            }
                            else if (status === "INCOMPLETE") {
                                console.log("No response from server or client is offline.")
                            }
                            else if (status === "ERROR") {
                                console.log("Error: " + errorMessage);
                            }
                        }
                    );
                }else if(rootObj.dtoResponseSetParametros.codigoError=='999'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Precaución!",
                        "message":rootObj.dtoResponseSetParametros.msjError,
                        "type": "Warning"
                    });
                    toastEvent.fire();
                }else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Ha ocurrido un error",
                        "message": "Error del Servicio :"+rootObj.dtoResponseSetParametros.msjError,
                        "type": "Error"
                    });
                    toastEvent.fire();
                }
                cmp.set("v.showSpinner", false);

            } else {
                console.log("Unknown error");
            }
        });
        $A.enqueueAction(action);
    },
    closeModel: function (component, event, helper) {
        component.set("v.isOpenPdf", false);
    }

});