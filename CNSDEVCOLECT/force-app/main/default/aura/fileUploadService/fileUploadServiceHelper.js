({
    MAX_FILE_SIZE: 5000000, //Max file size 5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event) {
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
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
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
        
        objFileReader.readAsDataURL(file);
    },
    
    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
    
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        var parentId = component.get("v.recordId");
        action.setParams({
            parentId: parentId,
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
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
            
                    this.callDocumentManager(component, attachId, parentId);
                    
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
    callDocumentManager: function (component, attachId, parentId) {
        
        var idDocs = component.get("v.idDocs");
        var action = component.get("c.callDocumentManager");
        action.setParams({
            caseId: parentId,
            fileId: attachId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            //var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));
                console.log(rootObj);
                var toastEvent = $A.get("e.force:showToast");
                if(!rootObj.isError){
                    toastEvent.setParams({
                        "title": "Correcto",
                        "message": "Archivo subido correctamente",
                        "type": "Success"
                	});
                }else{
                    toastEvent.setParams({
                        "title": "Alerta",
                        "message": rootObj.msj,
                        "type": "Warning"
                	});
                }
                
                
                                
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();


                
            } else {

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "Contacte con el administrador",
                    "type": "Error"
                });
                toastEvent.fire();
            }
            component.set("v.showLoadingSpinner", false);

        });
        $A.enqueueAction(action);
    }
})