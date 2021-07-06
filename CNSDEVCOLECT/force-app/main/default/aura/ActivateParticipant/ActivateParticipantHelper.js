({
    getData: function (component, event) {
        var action = component.get("c.getInitialData");
        action.setParams({
            "participantId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            console.log(state);
            console.log("res-->"+JSON.stringify(response.getReturnValue()));
            
            if (component.isValid() && state === "SUCCESS") {
                var res = response.getReturnValue();
                if(res.Participant != null){
                    if(res.Participant.estado_participante_sales__c == 'Vigente'){
                        component.set("v.textMessage","Participante ya activo!");
                        component.set("v.buttonControl",false);
                        component.set("v.loading",false);
                        
                    }else{
                        component.set("v.buttonControl",true);
                        component.set("v.participant",res.Participant);
                        component.set("v.loading",false);
                    }
                }else{
                    component.set("v.textMessage","Para activar un participante, la oportunidad debe estar en etapa Contacto");
                    component.set("v.loading",false);
                }
            }else {
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
    activeParticipant : function(component,evt) {
        component.set('v.loading', true);
         var action = component.get("c.activateOppParticipant");
        action.setParams({
            "participantId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            console.log("res-->"+JSON.stringify(res));
            component.set("v.buttonControl",false);
            if (component.isValid() && state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set('v.loading', false);
                if(res.includes("ERROR")){
                    component.set("v.textMessage",res);
                }else if(res.includes("OK")){
                    component.set("v.textMessage","Participante Activado con exito!");
                    $A.get('e.force:refreshView').fire();
                }else{
                    component.set("v.textMessage","ERROR: Contacte a su administrador");
                }
            }else {
                component.set('v.loading', false);
                component.set("v.textMessage","ERROR: Contacte a su administrador");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": 'Error',
                    "type": "warning"
                });
                
            }
        });
        $A.enqueueAction(action);
    }
})