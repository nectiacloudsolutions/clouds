/**
 * @description       : 
 * @author            : pcelisbe@everis.com
 * @group             : 
 * @last modified on  : 07-27-2020
 * @last modified by  : pcelisbe@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   07-08-2020   eayalcor@everis.com   Initial Version
**/
({
    doInit: function (cmp, event, helper) {        
        var typeFunction = cmp.get("v.docsType");
        var rootObject = JSON.parse(JSON.stringify(cmp.get("v.docWrapperFile")));
 
        if( ((rootObject.stageName === 'Recopilación' || rootObject.stageName === 'Revisión') || rootObject.stageName === 'Evaluación' ) ||
          (rootObject.stageName === 'Ingreso del Negocio' || rootObject.stageName === 'Formalización' || rootObject.stageName === 'Curse') ){
            if(typeFunction === 'Recopilacion'){
                helper.validateDocTypeRecopilation(cmp);
            }else{
                helper.validateDocTypeFormalization(cmp);
            }
        }else{                        
            cmp.set("v.isDisabledView", false);           
            cmp.set("v.isDisabledDelete", true);
            cmp.set("v.isDisabledFile",true);
        }
    },
    doSave: function (component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert("Please Select a Valid File");
        }
    },

    handleFilesChange: function (component, event, helper) {
        if (event.getSource().get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        }
    },
    deleteFile: function (component, event, helper) {
        component.set("v.showSpinner", true);
        var idDocs = component.get("v.idDocs");
        var action = component.get("c.updateDocs");
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
        var action = cmp.get("c.viewDoc");
        cmp.set("v.pdfContainer", '');
        action.setParams({
            idDoc: idDoc,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));
                //console.log('OBJETO-->' +rootObj.mensaje);
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
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenPdf", false);
    }

});