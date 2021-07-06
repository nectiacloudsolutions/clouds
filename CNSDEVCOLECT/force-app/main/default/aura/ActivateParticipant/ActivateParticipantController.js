({
	doInit : function(component, event, helper) {
        console.log("DoInit");
		helper.getData(component,event);
	},
    activePart: function(component, event, helper) {
		console.log("active");	
    	helper.activeParticipant(component,event);
	},
    closeModal : function (cmp,evt,helper){
        $A.get("e.force:closeQuickAction").fire();
    },
})