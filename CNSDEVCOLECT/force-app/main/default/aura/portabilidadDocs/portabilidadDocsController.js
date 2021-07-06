({
	doInit: function (component, event, helper) {
		helper.getData(component, event);
	},
    onChangeStage: function (component, event, helper) {
        // Es un toast success
        if (event.getParam('type') !== undefined && event.getParam('type') == 'success') {
            // Es un saveRecord
            if (event.getSource().getLocalId() !== undefined && event.getSource().getLocalId() == 'saveRecordCmp') {
                $A.enqueueAction(component.get('c.doInit'));
            }
        }
    },
    openModal: function (component, event, helper) {
		component.set("v.isOpen", true);
	},
    
	closeModal: function (component, event, helper) {
		component.set("v.isOpen", false);
	},
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent: function (component, event, helper) {
        // get the selected Account record from the COMPONETN event 	 
        //var changeP = event.getParam("changePickList");
        helper.getData(component, event);
        
    },   
    
})