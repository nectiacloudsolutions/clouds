({
    doInit: function(component, event, helper) {
	var origin= event.getSource().toString();
	
		var pos = origin.indexOf("runtimeComponent");
        console.log(pos);
        if (origin.indexOf("runtimeComponent") != -1){
            
        } else {
            component.set('v.contador','true' );
            helper.getOppStage(component, event);
            //helper.method1(component, event);
            
        }

    },


})