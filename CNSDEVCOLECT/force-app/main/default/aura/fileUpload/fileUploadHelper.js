/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 07-23-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   07-22-2020   eayalcor@everis.com   Initial Version
**/
({
    MAX_FILE_SIZE: 5000000, //Max file size 5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 

    uploadHelper: function (component, event) {
        // start/show the loading spinner   
        component.set("v.showSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function
        console.log('Size', file.size);
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showSpinner", false);
            var toastEvent = $A.get("e.force:showToast");

            toastEvent.setParams({
                "title": "Correcto",
                "message": "El archivo excede " + self.MAX_FILE_SIZE + " bytes.\n" + "Archivo seleccionado " + file.size,
                "type": "warning"
            });

            toastEvent.fire();
            return;
        }

        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function () {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;

            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });

        objFileReader.readAsDataURL(file);
    },

    uploadProcess: function (component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },


    uploadInChunk: function (component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        console.log(fileContents.length);
        console.log(startPosition);
        console.log(endPosition);
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        var parentId = component.get("v.parentId");
        var namePdf = component.get("v.fileName");
        console.log(namePdf);
        action.setParams({
            parentId: parentId,
            fileName: namePdf,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });

        // set call back 
        action.setCallback(this, function (response) {
            // store the response / Attachment Id  
            console.log('ENTROOOOO');
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    this.callAlfresco(component, attachId, parentId);


                    // call the event   
                    var compEvent = component.getEvent("eventFileUpload");
                    // set the Selected sObject Record to the event attribute.  
                    compEvent.setParams({ "changePickList": true });
                    // fire the event  
                    compEvent.fire();
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },

    callAlfresco: function (component, attachId, parentId) {

        var idDocs = component.get("v.idDocs");
        var action = component.get("c.invokeUploadAlfresco");
        action.setParams({
            IdOpp: parentId,
            fileId: attachId,
            IdDocs: idDocs
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                component.set("v.showSpinner", false);
                if (rootObj.dtoResponseSetParametros.codigoError=='0') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Correcto",
                        "message": "Archivo subido correctamente.",
                        "type": "Success"
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

            } else {

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "Contacte con el administrador",
                    "type": "Error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    validateDocTypeRecopilation: function (cmp) {
        var lstDocs = JSON.parse(JSON.stringify(cmp.get("v.lstDocs")));
        var rootObject = JSON.parse(JSON.stringify(cmp.get("v.docWrapperFile")));

        if (rootObject.isPerfilEspecialista === 'OK' && rootObject.isPerfilVisado != 'OK') {
            if (lstDocs.estado_documento_sales__c === "No aplica") {
                cmp.set("v.isDisabledView", true);
                cmp.set("v.isDisabledDelete", true);
                cmp.set("v.isDisabledFile", true);
            } else if (lstDocs.estado_documento_sales__c === "Seleccionar" || lstDocs.estado_documento_sales__c == null || lstDocs.estado_documento_sales__c == '') {
                cmp.set("v.isDisabledView", true);
                cmp.set("v.isDisabledDelete", true);
                cmp.set("v.isDisabledFile", false);
            } else if (lstDocs.estado_documento_sales__c === "Aprobado") {
                cmp.set("v.isDisabledView", false);
                cmp.set("v.isDisabledDelete", true);
                cmp.set("v.isDisabledFile", true);
            } else if (lstDocs.estado_documento_sales__c === "Rechazado") {
                cmp.set("v.isDisabledView", false);
                cmp.set("v.isDisabledDelete", false);
                cmp.set("v.isDisabledFile", false);
            } else if (lstDocs.estado_documento_sales__c === "Ingresado") {
                cmp.set("v.isDisabledView", false);
                cmp.set("v.isDisabledDelete", false);
                cmp.set("v.isDisabledFile", false);
            }
        }else if(rootObject.isPerfilVisado === 'OK' || rootObject.isPerfilRiesgo === 'OK' || rootObject.isPerfilJefeVisador === 'OK'){
            cmp.set("v.isDisabledView", false);
            cmp.set("v.isDisabledDelete", true);
            cmp.set("v.isDisabledFile", true);
        }else{  
            cmp.set("v.isDisabledView", false);
            cmp.set("v.isDisabledDelete", true);
            cmp.set("v.isDisabledFile",true);
        }

    },
    validateDocTypeFormalization: function (cmp) {
        var lstDocs = JSON.parse(JSON.stringify(cmp.get("v.lstDocs")));
        var rootObject = JSON.parse(JSON.stringify(cmp.get("v.docWrapperFile")));
        
        if ((rootObject.isPerfilEjecutivo == true || rootObject.isPerfilPreVisado == true) && rootObject.isPerfilVisador == false) {

            if (lstDocs.estado_documento_sales__c === "No aplica") {
                cmp.set("v.isDisabledView", true);
                cmp.set("v.isDisabledDelete", true);
                cmp.set("v.isDisabledFile", true);
            } else if (lstDocs.estado_documento_sales__c === "Seleccionar" || lstDocs.estado_documento_sales__c == null || lstDocs.estado_documento_sales__c == '') {
                cmp.set("v.isDisabledView", true);
                cmp.set("v.isDisabledDelete", true);
                cmp.set("v.isDisabledFile", false);
            } else if (lstDocs.estado_documento_sales__c === "Aprobado") {
                cmp.set("v.isDisabledView", false);
                cmp.set("v.isDisabledDelete", true);
                cmp.set("v.isDisabledFile", true);
            } else if (lstDocs.estado_documento_sales__c === "Rechazado") {
                cmp.set("v.isDisabledView", false);
                cmp.set("v.isDisabledDelete", false);
                cmp.set("v.isDisabledFile", false);
            } else if (lstDocs.estado_documento_sales__c === "Ingresado") {
                /*EJECUTIVO COMERCIAL*/
                if (rootObject.isPerfilEjecutivo == true && rootObject.isPerfilPreVisado == false) {
                    if (rootObject.estadoAprobacionPreVisado === '' || rootObject.estadoAprobacionPreVisado === 'Rechazado' || typeof rootObject.estadoAprobacionPreVisado === 'undefined') {
                        lstDocs.Id_Alfresco_sales__c === '' ? cmp.set("v.isDisabledView", true) : cmp.set("v.isDisabledView", false);
                        cmp.set("v.isDisabledDelete", false);
                        cmp.set("v.isDisabledFile", false);
                    } else {
                        cmp.set("v.isDisabledView", false);
                        cmp.set("v.isDisabledDelete", true);
                        cmp.set("v.isDisabledFile", true);
                    }
                } else if (rootObject.isPerfilPreVisado == true) {
                    /*EJECUTIVO PREVISADO*/
                    if (rootObject.isPerfilPreVisado == true && rootObject.estadoAprobacionPreVisado === 'En Proceso') {
                        lstDocs.Id_Alfresco_sales__c === '' ? cmp.set("v.isDisabledView", true) : cmp.set("v.isDisabledView", false);
                        cmp.set("v.isDisabledDelete", false);
                        cmp.set("v.isDisabledFile", false);
                    } else {
                        cmp.set("v.isDisabledView", false);
                        cmp.set("v.isDisabledDelete", true);
                        cmp.set("v.isDisabledFile", true);
                    }
                }
            }

        } else if ((rootObject.isPerfilEjecutivo == false && rootObject.isPerfilPreVisado == false) && rootObject.isPerfilVisador == true) {

            if (lstDocs.estado_documento_sales__c === "No aplica") {
                cmp.set("v.isDisabledView", true);
                cmp.set("v.isDisabledDelete", true);
                cmp.set("v.isDisabledFile", true);
            } else if (lstDocs.estado_documento_sales__c === "Seleccionar" || lstDocs.estado_documento_sales__c == null || lstDocs.estado_documento_sales__c == '') {
                cmp.set("v.isDisabledView", true);
                cmp.set("v.isDisabledDelete", true);
                cmp.set("v.isDisabledFile", true);
            } else if (lstDocs.estado_documento_sales__c === "Aprobado") {
                cmp.set("v.isDisabledView", false);
                cmp.set("v.isDisabledDelete", true);
                cmp.set("v.isDisabledFile", true);
            } else if (lstDocs.estado_documento_sales__c === "Rechazado") {
                cmp.set("v.isDisabledView", false);
                cmp.set("v.isDisabledDelete", true);
                cmp.set("v.isDisabledFile", true);
            } else if (lstDocs.estado_documento_sales__c === "Ingresado") {
                cmp.set("v.isDisabledView", false);
                cmp.set("v.isDisabledDelete", true);
                cmp.set("v.isDisabledFile", true);
            }

        } else {
            cmp.set("v.isDisabledView", false);
            cmp.set("v.isDisabledDelete", true);
            cmp.set("v.isDisabledFile", true);
        }
    }
})