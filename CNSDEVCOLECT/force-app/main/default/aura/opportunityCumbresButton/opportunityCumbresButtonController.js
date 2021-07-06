({
	doInit : function(component, event, helper) {
		var origin= event.getSource().toString();
		var pos = origin.indexOf("runtimeComponent");
        if (origin.indexOf("runtimeComponent") != -1){
            //
        } else {
            component.set('v.contador','true' );
            helper.getOppStage (component, event);
        }   
	},
        closeModal : function (cmp,evt,helper){
        $A.get("e.force:closeQuickAction").fire();
    }

})