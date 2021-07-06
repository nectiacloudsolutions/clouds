({
    responseHandle : function(component, event) {
        var msg;
        var act;
        var val = event.getParam("value");
        var question = component.get("v.pregunta");
        if(val == undefined){
            
            // alert("RESPUESTA: "+ component.find("select").get("v.value"));
            val = component.find("select").get("v.value");
            question.respuestas.forEach(function(x) {
                if(x.idRespuesta == val){
                    x.respuesta = "1";
                    if(x.idPreguntaHija != undefined && x.idPreguntaHija != "0"){
                        msg	= x.idPreguntaHija;
                        act = true;
                    }else{
                        msg = question.idPregunta;
                        act = false;
                    }
                }else{
                    
                    x.respuesta = "0";
                }
                
            });
            console.log("msg"+msg);
            if(msg != undefined){
                component.set("v.pregunta",question);
                var cmpEvent = component.getEvent("cmpEvent"); 
                cmpEvent.setParams({"message" : msg,
                                    "visible" : act });
                cmpEvent.fire();
            }
            
            
        }else if(val != "0"){
            question.respuestas.forEach(function(x) {
                if(x.idRespuesta == val){
                    x.respuesta = "1";
                    if(x.idPreguntaHija != undefined && x.idPreguntaHija != "0"){
                        msg	= x.idPreguntaHija;
                        act = true;
                    }else{
                        msg = question.idPregunta,
                            act = false;
                    }
                }else{
                    x.respuesta = "0";
                }
                
            });
            component.set("v.pregunta",question);
            var cmpEvent = component.getEvent("cmpEvent"); 
            cmpEvent.setParams({"message" : msg,
                                "visible" : act });
            cmpEvent.fire();
        }
        
        
    }
})