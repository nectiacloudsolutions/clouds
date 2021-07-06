({
    
    openmodal1: function(component, event, helper) {
        var n1 = component.get("v.recordId");
       // window.location.assign("/apex/Cons_visualizar_documento?id="+n1);
        window.location.assign("/apex/CONS_Copia_Poliza?id="+n1);
        
    },
    openmodal2: function(component, event, helper) {
        var idp = component.get("v.recordId");
        window.location.assign("/apex/CONS_Certificado_Pagos?id="+idp);
        //  var n2 =" "+component.find("num3").get("v.Account");
        //alert(" adsfghgfds "+n2);
    }, 
    openmodal3: function(component, event, helper) {
        var idc = component.get("v.recordId");
        window.location.assign("/apex/CONS_Certificado_Cargas_Legales?id="+idc);
       
     },
    openmodal4: function(component, event, helper) {
         var idc = component.get("v.recordId");
        window.location.assign("/apex/CONS_Copia_SOAP?id="+idc);
    },
    openmodal5: function(component, event, helper) {
         var idlp = component.get("v.recordId");
        window.location.assign("/apex/CONS_Certificado_liquidacion_pension?id="+idlp);
    },
    openmodal6: function(component, event, helper) {
        var idv = component.get("v.recordId");
        window.location.assign("/apex/CONS_Certificado_Vigencia?id="+idv);
    },
    openmodal7: function(component, event, helper) {
        var id = component.get("v.recordId");
        window.location.assign("/apex/CONS_Certificado_Cobertura?id="+id);
    },	
     openmodal8: function(component, event, helper) {
       
    },	
   
   /* init : function(component, event, helper) {
        window.open("/"+component.get("v.recordId"));
    },
    clickAdd: function(component, event, helper) {
        
        // Get the values from the form
        var n1 = component.find("num1").get("v.value");
        var n2 = component.find("num2").get("v.value");
        
        // Display the total in a "toast" status message
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Quick Add: " + n1 + " + " + n2,
            "message": "The total is: " + (n1 + n2) + "."
        });
        resultsToast.fire();
        
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    doInit : function(component, event, helper) {
        
        // Prepare the action to load account record
        var action = component.get("c.getAccount");
        action.setParams({"accountId": component.get("v.recordId")});
        
        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            console.log('Problem getting account, response state: ' + state);
            
        });
        $A.enqueueAction(action);
    },*/
})