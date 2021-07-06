({

    getOppStage: function (component, event) {
        var action = component.get("c.getOppStage");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var status = response.getReturnValue();
            if (component.isValid() && state === "SUCCESS") {
                component.set('v.stage', status);
                if (status) {
                    this.method1(component, event);
                } else {
                    component.set('v.loaded', !component.get('v.loaded'));
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": 'Error',
                    "type": "warning"
                });
            }

        });
        $A.enqueueAction(action);

    },

    method1: function (component, event) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getConsultVTime");
        // Set the parameters
        action.setParams({
            recordId: recordId
        });

        action.setCallback(this, function (response) {

            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                component.set('v.loaded', !component.get('v.loaded'));

                //component.set('v.resPropuesta', 'Espera revisión comercial');
                //component.set('v.resMandato', 'Espera revisión comercial');
                var rootObj = JSON.parse(JSON.stringify(response.getReturnValue()));
                console.log(rootObj);
                if (rootObj.codigo === 'OK') {

                    component.set('v.resPropuesta', rootObj.proposal);
                    component.set('v.resMandato', rootObj.mandate); 

                } else {
                    component.set('v.msg', rootObj.mensaje);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "message": rootObj.mensaje
                    });
                    toastEvent.fire();
                }

            } else {

                //Toast Generic Error
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "message": "Servicio no disponible por el momento"
                });
                //toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }

})