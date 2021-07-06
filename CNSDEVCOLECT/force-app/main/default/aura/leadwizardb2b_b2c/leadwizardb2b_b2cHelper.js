({
	GetComponent : function(cmp,event,helper) {
		//helper.RedirectComponent('c:leadWizardB2B');
        
        var action = cmp.get("c.GetComponentAccess");
    	action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS" && cmp.isValid()){
                var result = response.getReturnValue();
                helper.RedirectComponent(result);
                //component.set("v.user", result);
            }else{
                helper.RedirectComponent('c:leadWizard');
                console.error("fail:" + response.getError()[0].message); 
            }
   		});
  		$A.enqueueAction(action);

	},
    RedirectComponent: function(Str_Component){
		//var Componente = 'c:leadWizardB2B'
        var evt = $A.get("e.force:navigateToComponent");
	   	evt.setParams({
            componentDef: Str_Component
            ,
       		componentAttributes: {
       			//myAttribute: component.get("v.someAttribute")
       		},
            isredirect : true
    	});
    	evt.fire();
    }
})