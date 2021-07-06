({
    doInit: function(component, event, helper) {
        var data = component.get("v.analyticsData");
        console.log("Qdata = " + data);
        component.set("v.error", true);
        console.log(JSON.stringify(data));
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            if ((response.isSubtab && response.tabId != response.parentTabId) ||
                response.parentTabId === null && response.subtabs[0].isSubtab) {
                
                var focusedTabId = response.parentTabId === null ? response.subtabs[0].tabId : response.tabId
                
                workspaceAPI.setTabLabel({
                    tabId: focusedTabId,
                    label: data.formulario.nombreFormulario //set label you want to set
                });
                workspaceAPI.setTabIcon({
                    tabId: focusedTabId,
                    icon: "custom:custom18", //set icon you want to set
                    iconAlt: "Detector" //set label tooltip you want to set
                });
            }
        })
        
    },
    sendQuestions: function(component, event, helper) {
        component.set("v.loadingSpinner", true);
        var form = component.get("v.analyticsData");
        var json = JSON.stringify(component.get("v.analyticsData"));
        
        var numQues = 0;
        var numAnswer = 0;
        console.log("Preguntas= "+ form.formulario.preguntas);
        form.formulario.preguntas.forEach(function(question) {
            console.log(question);
            if(question.visible == true){
                numQues++;
                
                question.respuestas.forEach(function(answer){
                    console.log(answer);
                    if(answer.respuesta == "1"){numAnswer++} 
                });
            }
        });
        console.log("numQues: "+numQues);
        console.log("numAnswer: "+numAnswer);
        if(numQues == numAnswer){
            var rClient = component.get("v.rutClient");
            var code = component.get("v.code");
            var rEjecutivo = component.get("v.rutEjecutivo");
            // Instance the action
            var action = component.get("c.getProducts");
            // Set the parameters
            action.setParams({
                rut: rClient,
                rutEjecutivo: rEjecutivo,
                code: code,
                jsonDC: json
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                component.set("v.loadingSpinner", false);
                component.set("v.errorProd", false);
                console.log("state --->"+state);
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();
                    console.log('1'+res);
                    console.log(JSON.stringify(res));
                    if (res.code == '1') {
                        component.set("v.productos", res);
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "error",
                            "message": res.message
                        });
                        toastEvent.fire();
                    }
                }
                //CASE ERROR || INCOMPLETE || ......
                else {
                    component.set("v.loadingSpinner", false);
                    //Toast Generic Error
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "message": "Error en el componente. Contactar con el Adminstrador"
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
        else {
            component.set("v.loadingSpinner", false);
            //Toast Generic Error
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "Se deben responder todas las preguntas antes de enviar las preguntas."
            });
            toastEvent.fire();
        }
        
        
    },
    handleComponentEvent: function(component, event, helper) {
        var message = event.getParam("message");
        var visible = event.getParam("visible");
        var refresh = false;
        var data = component.get("v.analyticsData");
        if (visible) {
            data.formulario.preguntas.forEach(function(x) {
                if (x.idPregunta == message) {
                    x.visible = visible;
                    refresh = true;
                }
            });
        } else {
            var num = parseInt(message) - 1;
            data.formulario.preguntas[num].respuestas.forEach(function(x) {
                if (x.idPreguntaHija != "0") {
                    var num1 = parseInt(x.idPreguntaHija) - 1;
                    data.formulario.preguntas[num1].visible = false;
                    refresh = true;
                    data.formulario.preguntas[num1].respuestas.forEach(function(y) {
                        y.respuesta = "";
                        if (y.idPreguntaHija != "0") {
                            var num2 = parseInt(y.idPreguntaHija) - 1;
                            data.formulario.preguntas[num2].visible = false;
                            data.formulario.preguntas[num2].respuestas.forEach(function(z) {
                                z.respuesta = "";
                            });
                        }
                    });
                }
            });
        }
        if (refresh) {
            component.set("v.analyticsData", JSON.parse(JSON.stringify(data)));
        }
    },
    handleClick: function(component, event, helper) {
        var IDPro = event.getSource().get("v.value");
        var IDAcc = component.get("v.accountId");
        
        var action = component.get("c.createOpp");
        // Set the parameters
        action.setParams({
            cuenta: IDAcc,
            producto: IDPro
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var IdOp = response.getReturnValue();
                if (IdOp != null) {
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": IdOp,
                        "slideDevName": "Detail"
                    });
                    navEvt.fire();
                } else {
                    //Toast Generic Error
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "message": "Error el Producto no es valido"
                    });
                    toastEvent.fire();
                }
                //CASE ERROR || INCOMPLETE || ......
            } else {
                
                //Toast Generic Error
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "message": "Error en el componente. Contactar con el Adminstrador"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})