({
    getData: function(component, event, helper) {
        component.set('v.isLoading', true);
        
        var action = component.get("c.getData");
        
        action.setParams({
            recordIdObject: component.get("v.recordId"),
            sObjectType: component.get("v.sObjectName"),
            CSType: component.get("v.CSType"),
        });
        
        action.setCallback(this, function(response) {
            component.set('v.isLoading', false);
            
            var state = response.getState();
            console.log('STATE: ' + state);
            
            if (state === "SUCCESS") {
                var docWrapperReturned = response.getReturnValue();
                console.log("wrapper valores:", docWrapperReturned);
                component.set("v.docWrapper", docWrapperReturned);
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "type": "Error",
                    "message": "Se ha producido un error al visualizar los documentos. Por favor intente de nuevo"
                });
                
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
})