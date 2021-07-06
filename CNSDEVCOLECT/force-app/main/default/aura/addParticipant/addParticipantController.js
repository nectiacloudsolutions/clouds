({
    doInit : function(cmp, event, helper) {
        var action = cmp.get("c.isAllowed");
        
        action.setParams({ 
            oppId : cmp.get('v.recordId')
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));
                console.log(rootObj);
                //var isAllowed = response.getReturnValue();
                
                if (rootObj.allowed) {
                    cmp.set('v.cmpEnabled', true);
                }
                else {
                    var toastEvent = $A.get("e.force:showToast");
                    
                    toastEvent.setParams({
                        "type": "Warning",
                        "title": "Atención",
                        "message": rootObj.message
                    });
                    
                    toastEvent.fire();
                    
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
        			dismissActionPanel.fire();
                }
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "type": "Error",
                    "message": "Se ha producido un error al inicializar el componente. Por favor intente de nuevo"
                });
                
                toastEvent.fire();
                
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
        		dismissActionPanel.fire();
            }
        });
        
        $A.enqueueAction(action);
    },
    
    clickCreateWithRUT : function(cmp, event, helper) {
		helper.validateRUT(cmp,event,helper);
	},
    
    onCancel: function(cmp, event, helper) {
        cmp.set("v.showFields", false);
        cmp.set("v.showHeader", true); 
        cmp.set("v.RUT",'');
    },
       
    onRegisterAccount : function(cmp, event, helper) {
       var OpportunityId = cmp.get("v.recordId"); 
       var rut = cmp.get("v.rutAccount");
       var typeDocument = cmp.get("v.valuesforTypeDocument[0]");
       var nameClient = cmp.get("v.nameClient"); 
       var lastnameClient = cmp.get("v.lastnameClient") 
       var apellidomatClient = cmp.get("v.apellidomatClient");
       var dateofBirth = cmp.get("v.dateofBirth");
       var remunerationAccount = cmp.get("v.remunerationAccount");
       var mobileAccount = cmp.get("v.mobileAccount");
       
        if ((rut !=null && rut.trim() !='') && (typeDocument !=null && typeDocument.trim() !='') && 
           (nameClient != null && nameClient.trim() != '') && (lastnameClient !=null && lastnameClient.trim() !='') && 
           (apellidomatClient !=null && apellidomatClient.trim() !='') && (dateofBirth !=null && dateofBirth.trim() !='') && 
           (remunerationAccount !=null && remunerationAccount.trim() !='') && (mobileAccount != null && mobileAccount.trim() !='')) {
            
            if (remunerationAccount > 0) {
                // TODO. Obs hvogelva - No me pongan tantos parametros por favor, just this time
           		helper.createRegisterAccount(cmp, rut, typeDocument, nameClient, lastnameClient, apellidomatClient, 
                                             dateofBirth, remunerationAccount, mobileAccount, OpportunityId);
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
           
         		toastEvent.setParams({
                    "title": "Atención",
                    "type": "Warning",
                    "message": "Por favor, ingrese una remuneración valida"
              	});
                
                toastEvent.fire(); 
            }
       }
       else {
           var toastEvent = $A.get("e.force:showToast");
           
           toastEvent.setParams({
               "title": "Atención",
               "type": "Warning",
               "message": "Por favor, rellene los campos obligatorios"
           });
           
           toastEvent.fire();
       }
    },
    
})