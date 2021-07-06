/**
 * @File Name          : offerWithoutCmpHelper.js
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/12/2020, 1:12:44 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/1/2020   eayalcor@everis.com     Initial Version
**/
({
    getData: function (component, event) {
        var action = component.get("c.getInitialData");
        action.setParams({
            "offerId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();   
            console.log(state);
            
            if (component.isValid() && state === "SUCCESS") {
                var res = response.getReturnValue();
                var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));
                console.log('Estado:' + res.offer.Estado_Oferta_sales__c);
                if(res.offer.Estado_Oferta_sales__c == 'Gestionado'){
                    component.set("v.showMotive",false);
                    component.set("v.textMessage","Oferta ya gestionada");
                    component.set("v.buttonControl",false); 
                    component.set("v.loading",false);
                }else if(!res.offer.Vigente_sales__c && res.offer.Estado_Oferta_sales__c == 'No Gestionado'){
                    component.set("v.showMotive",false);
                    component.set("v.textMessage","Oferta sin Vigencia");
                    component.set("v.buttonControl",false); 
                    component.set("v.loading",false);
                }else{
                    component.set("v.buttonControl",true);
                    component.set("v.offer",res.offer);
                    component.set("v.loading",false);
                    component.set("v.motiveList",res.reasons);
                }

            }else {
                component.set('v.loading', false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": 'Error',
                    "type": "warning"
                });
                
            }
        });
        $A.enqueueAction(action);   
    },
    rejectOffer : function(component,evt) {
        component.set('v.loading', true);
        
        var motiv = component.find("motivo");
		motiv = Array.isArray(motiv) ? motiv[0].get("v.value") : motiv.get("v.value");
        if(motiv!=undefined && motiv=='')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "Complete el motivo de No Interés"
            });
            toastEvent.fire();
            component.set("v.loading",false);
        }else{
            
            var action = component.get("c.rejectOffer");
            action.setParams({
                "offerId": component.get("v.recordId"),
                "reason" : component.get("v.motiveValue")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();

                component.set("v.buttonControl",false);
                if (component.isValid() && state === "SUCCESS") {
                    var res = response.getReturnValue();
                    component.set('v.loading', false);
                    if(res.includes("ERROR")){
                        component.set("v.textMessage",res);
                    }else if(res.includes("OK")){
                        component.set("v.showMotive",false);
                        component.set("v.textMessage","¡Oferta actualizada con éxito!");
                        $A.get('e.force:refreshView').fire();
                    }else{
                        component.set("v.textMessage","ERROR: Contacte a su administrador");
                    }
                }else {
                    component.set('v.loading', false);
                    component.set("v.textMessage","ERROR: Contacte a su administrador");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message": 'Error',
                        "type": "warning"
                    });
                    
                }
            });
            $A.enqueueAction(action); 
        }
        
    }
})