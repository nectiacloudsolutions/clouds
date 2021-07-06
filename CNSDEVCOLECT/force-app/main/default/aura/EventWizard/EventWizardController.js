({
    doInit: function(component, event, helper) {
        helper.getInitialData(component, event);
    },
    createEvent : function (cmp,evt,helper){
        helper.createCallEvent(cmp,evt);
    },
    closeModal : function (cmp,evt,helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    onChangeState : function (cmp,evt,helper){
        helper.checkResult(cmp,evt);
        //$A.get("e.force:closeQuickAction").fire();
    },
    onChangeTelf  : function (cmp,evt,helper){
        helper.checkOther(cmp,evt);
        //$A.get("e.force:closeQuickAction").fire();
    },
    onChangeResultado : function (cmp,evt,helper){
        helper.checkMotivo(cmp,evt);
        //$A.get("e.force:closeQuickAction").fire();
    },
    onChangeDate : function (cmp,evt,helper){
        console.log(cmp.get("v.dateValue"));
        //$A.get("e.force:closeQuickAction").fire();
    }
})