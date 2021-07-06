({
    getData : function(cmp,evt, helper) { 
        var action = cmp.get("c.getInitialData");
        action.setParams({
            "oppId": cmp.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var val = response.getReturnValue();
            cmp.set("v.dataVisibility", val);
            if (cmp.isValid() && state === "SUCCESS") {
                var rootObj = JSON.parse(JSON.stringify(val.Reason));
                cmp.set("v.actions",val.Actions);
                cmp.set("v.motives",val.Reason);
                cmp.set("v.recordType", val.Opportunity[0].RecordType.lDeveloperName)
                cmp.set("v.executiveAction",val.Opportunity[0].motivo_reingreso_sales__c);
				cmp.set("v.result",val.Opportunity[0].Aprobacion_Riesgo_sales__c);
               
                if(($A.get('$SObjectType.CurrentUser.Id') === val.Manager[0].Id) && 
                   (val.Opportunity[0].StageName=="Evaluación" || val.Opportunity[0].StageName=="Simulación" || val.Opportunity[0].StageName=="Contacto") && 
                   val.Opportunity[0].Aprobacion_Riesgo_sales__c != "Rechazado"){
                   
                    if(val.Opportunity[0].Indicaciones_ejecutivo_sales__c == null){
                        cmp.set("v.visibleEnable",false);
                    }
                    if(( val.Opportunity[0].StageName=="Simulación" ||val.Opportunity[0].StageName=="Contacto") && val.Opportunity[0].Indicaciones_ejecutivo_sales__c != null){
                        cmp.set("v.visibleEnable",true);
                    
                        cmp.set("v.rejectReason",val.Opportunity[0].Motivo_rechazo_riesgo_sales__c);
                        cmp.set("v.indicacionesBossText",val.Opportunity[0].Indicaciones_ejecutivo_sales__c);
                        cmp.set("v.executiveEnable",true);
                        cmp.set("v.hasReason",true);
                    }else if (val.Opportunity[0].StageName=="Evaluación"){
                
                        cmp.set("v.executiveEnable", true);
                        cmp.set("v.riskEnable", true);//linea agregada para que el ejecutivo apruebe sprint 15
                        cmp.set("v.visibleEnable", true);
                        cmp.set("v.rejectReason",val.Opportunity[0].Motivo_rechazo_riesgo_sales__c);
                        cmp.set("v.indicacionesBossText",val.Opportunity[0].Indicaciones_ejecutivo_sales__c);
                    }
                }else if( val.Opportunity[0].StageName == "Evaluación" && 
                         
                         val.Opportunity[0].Aprobacion_Riesgo_sales__c === "En Proceso" && 
                         val.Risk.length > 0 ){
                    
                    if(val.Opportunity[0].Indicaciones_ejecutivo_sales__c != null){
                        cmp.set("v.hasReasonRisk",true);
                    }
                    cmp.set("v.visibleEnable",true);
                    cmp.set("v.rejectReason",val.Opportunity[0].Motivo_rechazo_riesgo_sales__c);
                    cmp.set("v.indicacionesBossText",val.Opportunity[0].Indicaciones_ejecutivo_sales__c);
                    cmp.set("v.riskEnable", true);
                    
                    
                }else if((((val.Manager[0].ManagerId != undefined && $A.get('$SObjectType.CurrentUser.Id') === val.Manager[0].ManagerId)) || 
                         (val.Manager[0].ManagerId != undefined && val.Manager[0].Manager.ManagerId != undefined && $A.get('$SObjectType.CurrentUser.Id') ===
                          val.Manager[0].Manager.ManagerId) || $A.get('$SObjectType.CurrentUser.Id') == val.Manager[0].Id) && 
                         (val.Opportunity[0].StageName == "Evaluación" && 
                          val.Opportunity[0].Aprobacion_Riesgo_sales__c == "Rechazado")){
                    
               
                    cmp.set("v.rejectReason",val.Opportunity[0].Motivo_rechazo_riesgo_sales__c);
                    cmp.set("v.indicacionesBossText",val.Opportunity[0].Indicaciones_riesgo_sales__c);
                   
                    cmp.set("v.visibleEnable",true);
                    cmp.set("v.bossEnable", true);
                }else if(val.Opportunity[0].StageName=="Evaluación" && val.ProfileVApp == 'OK' ){
             
                     cmp.set("v.executiveEnable", true);
                        cmp.set("v.visibleEnable", true);
                        cmp.set("v.rejectReason",val.Opportunity[0].Motivo_rechazo_riesgo_sales__c);
                        cmp.set("v.indicacionesBossText",val.Opportunity[0].Indicaciones_ejecutivo_sales__c);
                }
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": 'Error',
                    "type": "warning"
                });
                toastEvent.fire();
            }

            if(val.VisibilityApproval[0]=='OK' && val.Opportunity[0].StageName == "Evaluación" && 
               val.Opportunity[0].Aprobacion_Riesgo_sales__c === "En Proceso"){
 
                if(val.Opportunity[0].Indicaciones_ejecutivo_sales__c != null){
                    cmp.set("v.hasReasonRisk",true);
                }
                cmp.set("v.visibleEnable",true);
                cmp.set("v.rejectReason",val.Opportunity[0].Motivo_rechazo_riesgo_sales__c);
                cmp.set("v.indicacionesBossText",val.Opportunity[0].Indicaciones_ejecutivo_sales__c);
                cmp.set("v.riskEnable", true);                    
            }        
        });

        $A.enqueueAction(action);

        
    },
    approveR : function(component,event){
        component.set("v.btnDisable",true);
        var action = component.get("c.saveApproval");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var status = response.getReturnValue();           
            if (component.isValid() && state === "SUCCESS") {
                if(status == "OK"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Oportunidad Aprobada",
                        "message": "Esta aprobación se le informará al ejecutivo",
                        "type": "success"
                    });
                    toastEvent.fire();
                    component.set("v.btnDisable",false);
                    component.set("v.visibleEnable",false);
                    $A.get('e.force:refreshView').fire();
                }else if(status == "NOOK") {
                    component.set("v.btnDisable",false);
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "Ha ocurrido un problema, por favor contáctese con el administrador",
                        "type": "error"
                    });
                    toastEvent.fire();
                }else if(status == "INVALID") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "Hay documentos con el campo 'Estado' sin completar",
                        "type": "warning"
                    });
                    toastEvent.fire();
                
                }
                
                
            }else{
                component.set("v.btnDisable",false);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "Ha ocurrido un problema, por favor contáctese con el administrador",
                    "type": "error"
                });
                toastEvent.fire();
                
            }
            
        });
        $A.enqueueAction(action);
        
    },
    rejectR : function(component,event){
        
        var action = component.get("c.rejectProposalRisk");
        
        action.setParams({
            "oppId": component.get("v.recordId"),
            "reason": component.get("v.rejectReason"),
            "obs": component.get("v.indicacionesRiskText")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var status = response.getReturnValue();
            if (component.isValid() && state === "SUCCESS") {
                if(status == "OK"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Oportunidad Evaluada",
                        "message": "Resultado : Rechazada",
                        "type": "success"
                    });
                    toastEvent.fire();
                    
                    component.set("v.riskEnable",false);
                    component.set("v.visibleEnable",false);
                    component.set("v.showProfile",false);
                    $A.get('e.force:refreshView').fire();
                    
                }else{
                    component.set("v.btnDisable",false);
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "Ha ocurrido un problema, por favor contáctese con el administrador",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
                
            }else{
                component.set("v.btnDisable",false);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "Ha ocurrido un problema, por favor contáctese con el administrador",
                    "type": "error"
                });
                toastEvent.fire();
                
            }
            
        });
        $A.enqueueAction(action);
    },
    approveB : function(component,event){
        var action = component.get("c.rejectProposalConfirmBoss");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var status = response.getReturnValue();
            if (component.isValid() && state === "SUCCESS") {
                if(status == "OK"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Oportunidad Evaluada",
                        "message": "Resultado : Rechazo Aprobado",
                        "type": "success"
                    });
                    toastEvent.fire();
                    component.set("v.visibleEnable",false);
               
                    $A.get('e.force:refreshView').fire();
                }else{
                 
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "Ha ocurrido un problema, por favor contáctese con el administrador",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
                
            }else{
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "Ha ocurrido un problema, por favor contáctese con el administrador",
                    "type": "error"
                });
                toastEvent.fire();
                
            }
            
        });
        $A.enqueueAction(action);
    },
    updateBossDecision : function(component,event,profile){
        var action = component.get("c.rejectProposalNotification");
        action.setParams({
            "oppId": component.get("v.recordId"),
            "profile": profile,
            "obs": component.get("v.indicacionesRiskText"),
            "action" : component.get("v.executiveAction")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var status = response.getReturnValue();
            if (component.isValid() && state === "SUCCESS") {
                if(status == "OK"){
                    if (profile == "Ejecutivo Especialista"){
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Oportunidad Evaluada",
                            "message": "Resultado : Oportunidad Actualizada, enviada a Ejecutivo",
                            "type": "success"
                        });
                        toastEvent.fire();
                        component.set("v.visibleEnable",false);
                        $A.get('e.force:refreshView').fire();
                    }else if(profile == "Ejecutivo de Riesgo"){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Oportunidad Evaluada",
                            "message": "Resultado : Oportunidad Actualizada, enviada a Riesgo",
                            "type": "success"
                        });
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                        component.set("v.visibleEnable",false);
                    }
                    
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "Oportunidad Perdida, el flujo de los estados ha finalizado",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
                
            }else{   
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "Ha ocurrido un problema, por favor contáctese con el administrador",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    
    },
    getVisibility : function(component, event, val) {
        var action = component.get("c.getVisibilityApproval");
        var val = component.get("v.dataVisibility");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        component.set("v.showProfile", false);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var value = response.getReturnValue();
                if(value === 'OK' && val.Opportunity[0].StageName == "Evaluación" && val.Opportunity[0].Aprobacion_Riesgo_sales__c === "En Proceso"){
                    component.set("v.showProfile", true);      
                }else if(value === 'NOK'){     
                }else{           
                } 
            }
            
        });
        
        $A.enqueueAction(action);
    }
})