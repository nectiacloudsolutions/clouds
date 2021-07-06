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
                    if(res.Participant.estado_participante_sales__c == 'No Vigente'){
                        component.set("v.showMotive",false);
                        component.set("v.textMessage","Participante ya desactivado!");
                        component.set("v.buttonControl",false);
                        component.set("v.loading",false);
                    }else{
                        component.set("v.buttonControl",true);
                        component.set("v.participant",res.Participant);
                        component.set("v.motiveList",res.Motivos);
                        component.set("v.loading",false);
                    }
                    
                }else{
                    component.set("v.showMotive",false);
                    component.set("v.textMessage","Para desactivar un participante, la oportunidad debe estar en etapa Contacto");
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
    deactiveParticipant : function(component,evt) {
        component.set('v.loading', true);
        if(component.find("motivo")!=undefined && component.find("motivo").get("v.value")=='')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "Complete el motivo de desactivación"
            });
            toastEvent.fire();
            component.set("v.loading",false);
        }else{
            
            var action = component.get("c.deactivateOppParticipant");
            action.setParams({
                "participantId": component.get("v.recordId"),
                "motivo" : component.get("v.motiveValue")
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
                        console.log("Desactivado");
                        component.set("v.showMotive",false);
                        component.set("v.textMessage","Participante desactivado con exito!");
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
        
    }
})