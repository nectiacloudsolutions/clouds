({
	getProposal : function(cmp,event,helper) {
        console.log("Entro get proposal");
		var action = cmp.get("c.getStoreProposal");
        console.log("action "+action);
        action.setParams({
            "id": cmp.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            console.log("response "+response);
            
            var state = response.getState();
            var res = response.getReturnValue();
            var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));
            if (cmp.isValid() && state === "SUCCESS") { 
                cmp.set('v.loaded', !cmp.get('v.loaded'));
                cmp.set('v.resPropuesta', rootObj.mensaje);                
            }else{
                const errorMsg = response.getError()[0].message;
                console.log("Errors "+errorMsg);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": errorMsg,
                    "type" : "warning"
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            
        }); 
        $A.enqueueAction(action);
        
	},
    getOppStage : function(cmp,event,helper) {
		console.log('entro 1');
		var action = cmp.get("c.getOppStage");
		var self = this;
        action.setParams({
            "id": cmp.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var status = response.getReturnValue();
            
            console.log('entro 2 '+status);
            console.log('State '+state);
            console.log('IsValid '+cmp.isValid());
            if (cmp.isValid() && state === "SUCCESS") {
              
				cmp.set('v.stage', status);
                if(status){
                	self.getProposal(cmp, event, helper);
                }else{
                    cmp.set('v.loaded', !cmp.get('v.loaded'));
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": 'Error',
                    "type" : "warning"
                });
            }
            
        }); 
        $A.enqueueAction(action);
        
	}
    
})