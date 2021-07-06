({
	doInit : function(component, event, helper) {
		helper.getData(component,event);
	},
    deactivePart: function(component, event, helper) {
		console.log("deactive");	
    	helper.deactiveParticipant(component,event);
	},
    closeModal : function (cmp,evt,helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    onChange : function (cmp,evt,helper){
        //$A.get("e.force:closeQuickAction").fire();
    },
})