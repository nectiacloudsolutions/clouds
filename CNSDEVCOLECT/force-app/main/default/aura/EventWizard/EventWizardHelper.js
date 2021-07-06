({
    getInitialData: function (component, event) {
        var now = new Date();
        var nowPlus3 = new Date(Date.now() + 1095*24*60*60*1000);
        var minDate = $A.localizationService.formatDate(now, "YYYY-MM-DDThh:mm:ssZ");
        var maxDate = $A.localizationService.formatDate(nowPlus3, "YYYY-MM-DDThh:mm:ssZ");
        console.log("minDate--->"+minDate);
        console.log("maxDate--->"+maxDate);
        
        component.set("v.dateMin",minDate);
        component.set("v.dateMax",maxDate);
        var action = component.get("c.getInitialData");
        console.log(component.get("v.recordId"));
        action.setParams({
            "leadId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var res = response.getReturnValue();
            console.log("state-->"+state);
            console.log("status" + res);
            console.log("status" + JSON.stringify(res));
            
            if (component.isValid() && state === "SUCCESS") {
                component.set('v.eventWrapper', res);
				var a = component.get("v.eventWrapper.Rut");
                		console.log(JSON.parse(JSON.stringify(a)));
                console.log('ACAAA');
                component.set('v.loading', false);
            } else {
                component.set('v.loading', false);
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

    createCallEvent: function (component, event) {
        component.set("v.disableButtonListo",true);
        component.set("v.loading",true);
        component.get("v.textMessage","");
        var action = component.get("c.saveEvent");
        // Set the parameters
        var cinco = component.find("lbDate");
        console.log("===========>"+cinco);
		var FlagError = new Boolean(false);
        var FlagErrorMotivo = new Boolean(false);
        var FlagErrorRut = new Boolean(false);
        console.log("TELEFONO--->"+component.find("Tel"));
        //console.log("TELEFONO VALUE--->"+component.find("Tel").get("v.value"));
        if(component.find("Tel")!=undefined && component.get("v.phoneValue") == ''){
            console.log("============PRIMER IF===================");
            FlagError = true;
        }
        if(component.find("lbOtro")!=undefined && component.get("v.OtherphoneValue") == ''){
            console.log("============IF OTRO===================");
            FlagError = true;
        }
        if(component.find("lbEstado")!=undefined && component.get("v.stateValue") == ''){
            console.log("============SEGUNDO IF===================");
            FlagError = true;
        }
        if(component.find("lbResultado")!=undefined && component.get("v.resultValue") == ''){
            console.log("============TERCERO IF===================");
            FlagError = true;
        }
        if(component.find("lbMotivo")!=undefined && component.get("v.motivoValue") == ''){
            console.log("============CUARTO IF===================");
            FlagError = true;
        }
        if(component.find("lbDate")!=undefined && component.get("v.dateValue") == null){
            console.log("============CUARTO IF===================");
            FlagError = true;
        }
        if(component.get("v.motivoValue") === '--Ninguno--'){
            console.log("============ERROR MOTIVO IF===================");
            FlagErrorMotivo = true;
        }
         if((component.get("v.eventWrapper.Rut") == 'OK') && (component.get("v.stateValue")== 'Contactado') && 
                           (component.get("v.phoneValue") != 'Seleccione un Teléfono') && (component.get("v.resultValue") == 'Llamada Exitosa')){
             console.log("==========ERROR RUT======================");
             FlagErrorRut = true;
                   
         }
        
        console.log("FLAG ERROR BEFORE INVOKE "+FlagError);
        console.log("FLAGMOTIVO ERROR BEFORE INVOKE "+FlagErrorMotivo);
        console.log("FLAGRUT ERROR BEFORE INVOKE "+FlagErrorMotivo);
        if(FlagError != true && FlagErrorMotivo != true && FlagErrorRut != true){
            component.set("v.buttonControl",false);
            
            var num = component.get("v.phoneValue");
            if(component.get("v.phoneValue") == "Otro"){
                num = component.get("v.OtherphoneValue");
            }
			action.setParams({
                phone: num,
                status: component.get("v.stateValue"),
                result: component.get("v.resultValue"),
                reason: component.get("v.motivoValue"),
                comment: component.get("v.commentaries"),
                leadId: component.get("v.recordId"),
                nextDate: component.get("v.dateValue")
        	});
        
			action.setCallback(this, function (response) {
                var res = response.getReturnValue();
                var state = response.getState();
                console.log("state-->"+state);
                console.log("status" + JSON.stringify(res));
                console.log("status" + res);
                
                
                component.set("v.eventId",res);
                if (state === "SUCCESS") {
                    if(res==null){
                      //  var a = component.get("v.eventWrapper.Rut");
                      //  console.log(JSON.parse(JSON.stringify(a)));
                      
                        
                        component.set("v.textMessage","Error: No se pudo crear el evento");
                        component.set("v.disableButtonListo",false);
                        component.set("v.loading",false);
                        component.set("v.showMessage",true);
                        component.set("v.disableButton",false);
                        
                    }else{
                        component.set("v.disableButtonListo",false);
                        component.set("v.loading",false);
                        component.set("v.showMessage",true);
                        component.set("v.textMessage","Evento llamada ha sido creado exitosamente");
                        
                        component.set("v.disableButton",false);
                    }
                    
                    $A.get('e.force:refreshView').fire();
                } else {
                    component.set("v.loading",false);          
                    //Toast Generic Error
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "message": "No es posible referir en estos momentos"
                    });
                    //toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
            
        }else if(FlagError != true && FlagErrorMotivo == true){
            component.set("v.loading",false);
         	var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                 "type": "error",
                 "message": "El motivo de no interés debe ser diferente a ninguno"
            });
            toastEvent.fire();
        }else if(FlagError == true && FlagErrorMotivo != true){
            component.set("v.loading",false);
         	var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                 "type": "error",
                 "message": "Complete todos los campos"
            });
            toastEvent.fire();
            
        }else if (FlagErrorRut == true){
          
            component.set("v.loading",false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "Debes completar con el RUT/Número de documento antes de convertir"
            });
            toastEvent.fire();
        }

    },
    checkComplete : function (cmp,evt){
        var slct = evt.getSource().get("v.value");
        if(slct != ""){
            
        }
        //$A.get("e.force:closeQuickAction").fire();
    },
    checkMotivo : function(cmp, evt){
        var list = cmp.get("v.dateList");
        var slct = evt.getSource().get("v.value");
        if(slct == "No interesado"){
            cmp.set("v.showMotivo",true);
        }else{
            cmp.set("v.showMotivo",false);
        }
        console.log("True????-->"+list.includes(slct));
        if(list.includes(slct)){

            //cmp.set("v.dateMin",minDate);
            //cmp.set("v.dateMax",maxDate);
            
            cmp.set("v.showDate",true);
        }else{
            cmp.set("v.showDate",false);
        }

        
        
    },
    checkResult : function(cmp, evt){
        var slct = evt.getSource().get("v.value");
        if(slct == "Contactado" || slct == "No Contactado" ){
            cmp.set("v.showResult",true);
        }else{
            cmp.set("v.showResult",false);
            cmp.set("v.resultValue","");
            
        }
    },
    checkOther : function(cmp, evt){
        var slct = evt.getSource().get("v.value");
        if(slct == "Otro"){
            cmp.set("v.showOtherNumber",true);
        }else{
            cmp.set("v.showOtherNumber",false);
            cmp.set("v.OtherphoneValue","");
            
        }
    },

})