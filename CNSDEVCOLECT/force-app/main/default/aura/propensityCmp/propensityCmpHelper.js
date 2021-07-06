/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 09-29-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   09-29-2020   eayalcor@everis.com   Initial Version
**/
({
	getPropensity : function(cmp,event,helper) {
        var action = cmp.get("c.getPropensityAnalytics");
        action.setParams({
            "id": cmp.get("v.recordId"),
            "nameObject" : cmp.get("v.sobjecttype")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                var res = response.getReturnValue();
                console.log(JSON.stringify(res));
                var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));

                if(rootObj.code === '1'){
                    cmp.set('v.propensityObject', res);
                    cmp.set('v.rut',rootObj.rutClient);
                    cmp.set('v.rutExecutive',rootObj.rutExec);
                    cmp.set('v.resultService', true);
                    $A.get('e.force:refreshView').fire();

                }else{
                    cmp.set('v.resultService', false);
                    cmp.set('v.messageService', rootObj.message);
                }

                cmp.set("v.enabledSpinner",false)
            }            
        }); 
        $A.enqueueAction(action);
		
    },
    getQuestions :  function(cmp,event,helper) {
        var code = event.currentTarget.dataset.prod;
        var accountId = cmp.get("v.recordId");
        var rut = cmp.get("v.rut");
        var rutExecutive = cmp.get("v.rutExecutive");

        var action = cmp.get("c.getQuestionsDetector");
        action.setParams({
            "cod": code,
            "rut" : cmp.get("v.rut"),
            "rutExecutive" : cmp.get("v.rutExecutive")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('Resultado getQuestions: ' + state);
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var rootObj = JSON.parse(response.getReturnValue());


                if(rootObj.formulario.code === '1'){
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:needsDetector",
                        componentAttributes: {
                            analyticsData : rootObj,
                            accountId : accountId,
                            rutClient : rut,
                            rutEjecutivo : rutExecutive,
                            code : code
                        }
                    });
                    evt.fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message": rootObj.formulario.message,
                        "type" : "warning"
                    });
                    toastEvent.fire();
                    /*cmp.set('v.resultService', false);
                    cmp.set('v.messageService', rootObj.formulario.message);*/
                }
                
                cmp.set("v.enabledSpinner",false)
                
            }            
        }); 
        $A.enqueueAction(action);
    }
})