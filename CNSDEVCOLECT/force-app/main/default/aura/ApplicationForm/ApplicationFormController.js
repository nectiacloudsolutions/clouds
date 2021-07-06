({
    init: function(cmp, event, helper) {
        var recordId = cmp.get('v.recordId');        
        var getFormAction = cmp.get('c.getForm');

        getFormAction.setParams({
            recordId: recordId
        });

        getFormAction.setCallback(this, 
            function(response) {
            	var state = response.getState();
                
            	if (cmp.isValid() && state === "SUCCESS") {

                    var form = response.getReturnValue();
                    var custs = [];
                    var custsSort = [];
                    var section =[];

                    for(var key in form ){
                        custs.push({key:form[key].valor__c, value:form[key]});
                    }

                    var section = []; 
                    custsSort = helper.recordssort(custs);

                    for (var i = 0; i < custsSort.length; i++) {  
                        if(custsSort[i].value.Section__c  != undefined){
                           section.push({section:custsSort[i].value.Section__c, nro_sec: custsSort[i].value.seccion_nro__c	});
                        }
                   }
                   
                   cmp.set('v.records', custsSort);
                   cmp.set('v.section', section);
                }
            }
        );
        $A.enqueueAction(getFormAction);
    },
})