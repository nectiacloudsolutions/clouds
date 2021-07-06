({
	doInit : function(component, event, helper) {
        var options = [];
		var question = component.get("v.pregunta");
        console.log("Tipo de Pregunta = "+question.tipoSeleccionRespuesta);
        if(question.visible){
            question.respuestas.forEach(function(x) {
                if(x.respuesta == "1"){
                    console.log("Respuesta desde analytics");
                    component.set("v.value",x.idRespuesta);
                }
                var temp = {"label": x.descripcionRespuesta, 
                            "value": x.idRespuesta};
                console.log(temp);
                options.push(temp);
                var valll = component.get("v.value");
            });
            component.set("v.options",options);
            if(question.tipoSeleccionRespuesta == 'EXCLUYENTE'){
                component.set("v.mostrarSM",true);
            }else if(question.tipoSeleccionRespuesta == 'PICKLIST'){
                component.set("v.mostrarPickList",true);
            }
        }
	},
    handleChange: function(component, event, helper) {
		helper.responseHandle(component, event);
    },
    onChangePickList : function(component, event, helper) {
        var val = component.find("select").get("v.value");
        console.log("PICKLIST VALUE-->"+val);
        helper.responseHandle(component, event);
        
    }
})