({
	saveContactRecord : function(component, event, helper) {
        if(component.get("v.selectedLookUpRecord").Id != undefined){
          var userId = component.get("v.selectedLookUpRecord").Id;
        } 
        
       //call apex class method
      var action = component.get("c.save");
        action.setParams({
            "userId": userId,
            "recordId": component.get("v.recordId")
        })
      action.setCallback(this, function(response) {
        var result = response.getReturnValue();
        //store state of response
        var state = response.getState();
        if (state === "SUCCESS" && result===true) {
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
              "type": "success",
              "message": "Se agrego aprobador"
          });
          toastEvent.fire();
            $A.get('e.force:refreshView').fire();
            $A.get("e.force:closeQuickAction").fire();

        }else{
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
              "type": "error",
              "message": "No tiene permisos para agregar"
          });
          toastEvent.fire();
        }
      });
      $A.enqueueAction(action);
        
       
	},
        closeQuickAction : function(cmp, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})