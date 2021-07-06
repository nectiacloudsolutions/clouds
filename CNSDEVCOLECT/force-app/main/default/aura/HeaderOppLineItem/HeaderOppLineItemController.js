({
	init : function(component, event, helper) {
        var fieldSetName = 'PF_Header';
        var sobjectName = 'OpportunityLineItem';
        var recordId = component.get('v.recordId');
        
        if (!fieldSetName) {
        	return;
        }
        
        var getFormAction = component.get('c.getForm');

        getFormAction.setParams({
            fieldSetName: fieldSetName,
            objectName: sobjectName,
            recordId: recordId
        });

        getFormAction.setCallback(this, 
            function(response) {
            	var state = response.getState();
            	if (component.isValid() && state === "SUCCESS") {
	                var form = response.getReturnValue();
	                component.set('v.fields', form);
                    var campos = component.get('v.fields');
                }
            }
        );
        $A.enqueueAction(getFormAction);
    },

	closeFlowModal : function(component, event, helper) {
        component.set("v.isOpen", false);
    },

	closeModalOnFinish : function(component, event, helper) {
        if(event.getParam('status') === "FINISHED") {
            component.set("v.isOpen", false);
            $A.get('e.force:refreshView').fire();
        }
    },
    
    runFlow : function(component, event, helper) {
        var recordId = component.get('v.recordId');  
        var inputVariables = [
            { name : "recordId", type : "String", value: recordId }
        ];
       component.set('v.isOpen', true);
       var flow = component.find('flow');
       flow.startFlow('modificacion_productos_PF',inputVariables);
    }
})