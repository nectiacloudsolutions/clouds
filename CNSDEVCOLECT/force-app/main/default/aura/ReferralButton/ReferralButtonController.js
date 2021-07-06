({
    doInit: function(component, event, helper) {
	var origin= event.getSource().toString();
	console.log(origin);
		var pos = origin.indexOf("runtimeComponent");
        console.log('ORIGIN --->'+pos);
        if (origin.indexOf("runtimeComponent") != -1){
            
        } else {
            helper.getOppStage(component, event);
            //helper.method1(component, event);
            
        }

    },
    referral : function (cmp,evt,helper){
        helper.refer(cmp,evt);
    },
    closeModal : function (cmp,evt,helper){
        $A.get("e.force:closeQuickAction").fire();
    },


})