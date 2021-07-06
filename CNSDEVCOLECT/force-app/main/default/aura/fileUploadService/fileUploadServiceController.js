({
    doInit: function (cmp, event, helper) {
        
        var action = cmp.get("c.validateManagerId");
        action.setParams({  });

        // Create a callback
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				cmp.set("v.managerOk",response.getReturnValue());
                
				var x=response.getReturnValue();
                console.log(response.getReturnValue());
                if(x==true){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warnign",
                    "message": "El usuario debe tener manager",
                    "type": "warning"
                });
                toastEvent.fire();
                }
            }
            else if (state === "ERROR") {

            }
        });

        $A.enqueueAction(action);
    },
    handleFilesChange: function (component, event, helper) {
        if (event.getSource().get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        }
    }
})