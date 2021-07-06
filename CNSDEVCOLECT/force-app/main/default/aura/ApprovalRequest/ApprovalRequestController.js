({
    doInit: function(component, event, helper) {
        helper.getData(component, event);
    },
    approveRisk : function (cmp,evt,helper){
        helper.approveR(cmp,evt);
    },
    rejectRisk : function (cmp,evt,helper){
        helper.rejectR(cmp,evt);
    },
    approveBoss : function (cmp,evt,helper){
        helper.approveB(cmp,evt);
    },
    rejectBtn : function(cmp,evt,helper){
        cmp.set("v.hasReason",true);
    },
   
    cancelBtn  : function(cmp,evt,helper){
        cmp.set("v.hasReason",false);
        cmp.set("v.indicacionesRiskText","");

    },
    sendExecutive : function (cmp,evt,helper){
        cmp.set("v.hasReason",true);
        cmp.set("v.sendMsg","Ejecutivo Especialista");
        
    },
    sendRisk : function (cmp,evt,helper){
        cmp.set("v.hasReason",true);
        cmp.set("v.sendMsg","Ejecutivo de Riesgo");
        var profi = cmp.get("v.sendMsg");
        
    },
    okBtnBoss : function(component,evt,helper){
     
        var profi = component.get("v.sendMsg");
        helper.updateBossDecision(component,evt,profi);
        $A.get('e.force:refreshView').fire();
        
    },
    cancelBtnBoss  : function(cmp,evt,helper){
        cmp.set("v.hasReason",false);
    }
})