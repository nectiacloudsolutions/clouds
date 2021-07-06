({
	doInit : function(component, event, helper) {
		var origin= event.getSource().toString();
	
		var pos = origin.indexOf("runtimeComponent");
        console.log(pos);
        if (origin.indexOf("runtimeComponent") != -1){
            //
        } else {
            console.log('entro');
            component.set('v.contador','true' );
            helper.getOppStage (component, event);
            console.log('Stage: '+component.get('v.stage'));

        }
       /* window.setTimeout(
              $A.getCallback(function() {
					$A.get("e.force:closeQuickAction").fire();
              }), 5000
       );  */      
	},
        closeModal : function (cmp,evt,helper){
        $A.get("e.force:closeQuickAction").fire();
    }

})