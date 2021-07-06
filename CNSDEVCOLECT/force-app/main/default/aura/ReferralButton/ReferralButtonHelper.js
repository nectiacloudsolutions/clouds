({

    getOppStage: function (component, event) {
        var action = component.get("c.validateOppStage");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var status = response.getReturnValue();

            if (component.isValid() && state === "SUCCESS") {
                component.set('v.validStage', status);
                
                if (status == "OK") {
                    component.set('v.confirm', true);
                    //this.refer(component, event);
                } else if (status == "ERROR_USUARIO" ) {
                    component.set('v.stageErrorText', "Error: Usuario no autorizado para referir.");
                    component.set('v.confirm', false);
                    
                }else if (status == "ERROR_ETAPA") {
                    component.set('v.stageErrorText', "Error: No se puede referir en esta etapa, o no cuenta con los permisos para referir esta oportunidad.");
                    component.set('v.confirm', false);
                   
                }else if (status == "ERROR_DOCUMENTOS") {
                    component.set('v.stageErrorText', "Error: Debe ingresar correctamente todos los documentos antes de referir.");
                    component.set('v.confirm', false);
                   
                }else{
                    component.set('v.stageErrorText', "Error: Ha ocurrido un error, favor contactar con el Administrador.");
                    component.set('v.confirm', false);
                }
                component.set('v.loading', false);
            } else {
                component.set('v.loading', false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": 'Error',
                    "type": "warning"
                });
            }

        });
        $A.enqueueAction(action);

    },

    refer: function (component, event) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getNewExecutive");
        // Set the parameters
        component.set("v.questionText","");
        component.set("v.buttonControl",false);
        component.set("v.loading",true);
        component.set("v.disableButton",true);
        // 
        action.setParams({
            recordId: recordId
        });
        
        action.setCallback(this, function (response) {
            var res;
            var state = response.getState();
            
            if (state === "SUCCESS") {
                res = response.getReturnValue();
                
                if(res==null){
                    component.set("v.stageErrorText","Error: La oportunidad esta incompleta");
                }else if(res.includes("ERROR")){
             
                    component.set("v.loading",false);
                    component.set("v.disableButton",false);
                    component.set("v.questionText",res);
                }else{
               
                    component.set("v.questionText","Referido exitosamente a "+res);
                    component.set("v.loading",false);
                    component.set("v.disableButton",false);
            	}
          
            
            } else {
                           
                //Toast Generic Error
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "message": "No es posible referir en estos momentos"
                });
                //toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }

})