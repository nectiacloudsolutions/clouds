/**
 * @File Name          : opportunityCumbresButtonHelper.js
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/23/2020, 3:47:52 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/23/2020   eayalcor@everis.com     Initial Version
**/
({
	sendId : function(cmp,event,helper) {
		console.log(cmp.get("v.recordId"));
        var action = cmp.get("c.getCumbresInfo");

        action.setParams({
            "id": cmp.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var res = response.getReturnValue();
            var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));
            if (cmp.isValid() && state === "SUCCESS") { 
                cmp.set('v.loaded', !cmp.get('v.loaded'));
                cmp.set('v.respuesta', rootObj.dtoResponseSetParametros.msjError);                
            }else{
                const errorMsg = response.getError()[0].message;

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
        console.log(cmp.get("v.recordId"));
        var action = cmp.get("c.getOppStage");
		var self = this;
        action.setParams({
            "id": cmp.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var status = response.getReturnValue();
            
            if (cmp.isValid() && state === "SUCCESS") {
				cmp.set('v.stage', status);
                if(status){
                	self.sendId(cmp, event, helper);
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