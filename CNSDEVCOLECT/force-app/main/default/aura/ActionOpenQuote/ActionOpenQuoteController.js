/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 08-21-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-19-2020   eayalcor@everis.com   Initial Version
**/
({
    doInit : function(component, event, helper) {
        var action = component.get("c.getData");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();   
            console.log(state);
            
            if (component.isValid() && state === "SUCCESS") {
                var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));
                console.log(rootObj);
                if(rootObj.status){
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                    "url": rootObj.url
                    });
                    urlEvent.fire();
                    
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Alerta!",
                        "message": rootObj.message,
                        "type": rootObj.typeAlert
                    });
                    toastEvent.fire();
                }
                
            }else {
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": 'Ha ocurrido un problema, contacte al Administrador',
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action); 
    }
})