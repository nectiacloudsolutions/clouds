({
	closeModel : function (cmp,evt,helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    doInit: function (component, event, helper) {
		helper.getData(component, event);
	},
    confirmUse: function (cmp, event, helper) {
        var accId = cmp.get("v.recordId");
        console.log(accId);
        helper.confirm(cmp,accId);
    }
})