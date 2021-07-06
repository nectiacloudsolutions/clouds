({
    doInit: function(component, event, helper) {
        component.set('v.showFirstSection', true);
        component.set('v.showSecondSection', false);
        component.set('v.showSalesManager', false);
        component.set('v.showEjecutiveProfile', false);
        component.set('v.showModalConfirmation', false);
        component.set('v.showModalReject', false);
        component.set('v.supervisorObs', '');
        
        helper.getDataForValidation(component, event);
    },
    
    openModalConfirmation : function(component) {
        component.set("v.showModalConfirmation", true);   
    },
    
    rejectManager: function(component, event, helper) {
        component.set("v.showSecondSection", true);
        component.set("v.showFirstSection", false);
    },
    
    approveManager: function(component, event, helper) {
        var oppId = component.get("v.recordId");
        helper.approveManagerHelper(component, oppId);
    },
    
    onCancel: function(component, event, helper) {
        component.set("v.showSecondSection", false);
        component.set("v.showFirstSection", true);
        component.set("v.supervisorObs", '');
    },
    
    onConfirm: function(component, event, helper) {
        var supervisorObs = component.get("v.supervisorObs");
        
        if (supervisorObs != null && supervisorObs.trim() != '') {
            component.set("v.showModalReject", true);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            
            toastEvent.setParams({
                "title": "Atención",
                "type": "Warning",
                "message": "Por favor, ingrese un motivo de rechazo"
            });
            
            toastEvent.fire();
        }
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
    
    closeModal : function(component, event, helper) {
        component.set("v.showModalConfirmation", false);
    },
    
    approveModalReject : function(component, event, helper){
        helper.doReject(component);
    },
    
    closeModalReject : function(component, event, helper){
        component.set("v.showModalReject", false);  
    },
    sendToRisk: function(component, event, helper){
        component.set("v.headerSendTo", $A.get("$Label.c.OSA_BtnAcceptHeader"));
        component.set("v.textSendTo", $A.get("$Label.c.OSA_BtnAcceptBody"));
        component.set("v.showSendTo", true);
    },
    sendToExecutive : function(component, event, helper){
        component.set("v.showThirdSection", false);
        component.set("v.showFourthSection", true);

    },
    sendToClose : function(component, event, helper){
        component.set("v.headerSendTo", $A.get("$Label.c.OSA_BtnCloseHeader"));
        component.set("v.textSendTo", $A.get("$Label.c.OSA_BtnCloseBody"));
        component.set("v.showSendTo", true); 
    },
    approveManagerOSA : function(component, event, helper){
        var oppId = component.get("v.recordId");
        if(component.get("v.textSendTo") ==  $A.get("$Label.c.OSA_BtnAcceptBody")){
            helper.sendToEvaluate(component,oppId);
        }
        if(component.get("v.textSendTo") ==  $A.get("$Label.c.OSA_BtnRejectBody")){
            component.set("v.headerSendTo", $A.get("$Label.c.OSA_BtnRejectHeader"));
            component.set("v.textSendTo", $A.get("$Label.c.OSA_BtnRejectBody"));
            component.set("v.showSendTo", true); 
        }
        if(component.get("v.textSendTo") ==  $A.get("$Label.c.OSA_BtnCloseBody")){
            helper.sendToClose(component,oppId);
        }
        // Logica
        
    },
        closeModalOSA : function(component, event, helper) {
        component.set("v.showSendTo", false);
    },
        onConfirmOSA: function(component, event, helper) {
        var supervisorObs = component.get("v.supervisorObs");
        
        if (supervisorObs != null && supervisorObs.trim() != '') {
            component.set("v.showModalReject", true);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            
            toastEvent.setParams({
                "title": "Atención",
                "type": "Warning",
                "message": "Por favor, ingrese un motivo de rechazo"
            });
            
            toastEvent.fire();
        }
    },
    onCancelOSA: function(component, event, helper) {
        component.set("v.showFourthSection", false); 
        component.set("v.showThirdSection", true);
        component.set("v.supervisorObs", '');
    },
})