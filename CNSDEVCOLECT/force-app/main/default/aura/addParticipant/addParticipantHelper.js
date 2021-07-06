({
    validateRUT: function(cmp, event, helper) {
       var OpportunityId = cmp.get("v.recordId");
       
       var RUT = cmp.get("v.RUT").toLocaleUpperCase();
       
       if (RUT.length > 0 && OpportunityId.length > 0) {
           //CALL SERVER, Method validatedRUT
           if (helper.validateFormatAndDV(cmp)) {
               cmp.set("v.RUT", RUT);
               
               if (RUT.indexOf("-") < 0) {
                   RUT = RUT.slice(0, RUT.length - 1) + "-" + RUT.slice(RUT.length - 1, RUT.length);
                   cmp.set("v.RUT", RUT);
               }
               
               cmp.set("v.enabledSpinner", true);
               //console.log("HELPER START");
               //console.log("RUT: ", RUT);
               //
               var action = cmp.get("c.LeadAssign");
               var RUTL = cmp.get("v.RUT");
               
               action.setParams({ 
                   rut : RUTL,
                   OpportunityId : OpportunityId
               });
               
               action.setCallback(this, function(response) {
                   //console.log("ESTADO-->", response.getState());
                   //console.log("Respuesta--->", JSON.stringify((response.getReturnValue())));
                   cmp.set("v.enabledSpinner", false);
                   
                   if (response.getState() === "SUCCESS") {    
                       var res = response.getReturnValue();

                       if (res !== undefined && res != null) {
                            if (res.errorMessage !== undefined && res.errorMessage != null) {
                                var toastEvent = $A.get("e.force:showToast");
                                
                                toastEvent.setParams({
                                    "title": "Atención",
                                    "type": "Warning",
                                    "message": res.errorMessage
                                });
                                
                                toastEvent.fire();
                            }
                            else if (res.id !== undefined && res.id != null) {
                                cmp.set("v.showFields", true);
                                cmp.set("v.showHeader", false);
                                cmp.set("v.idLeadAccount", res.id);
                                
                                cmp.set("v.rutAccount", res.rut);
                                cmp.set("v.typeDocument", res.tipoDocument);
                                cmp.set("v.nameClient", res.firstName);
                                cmp.set("v.lastnameClient", res.lastName);
                                cmp.set("v.apellidomatClient", res.secondLastName);
                                cmp.set("v.dateofBirth", res.accountBirthDate);
                                
                                cmp.set("v.isAccount", res.isAccount);
                                cmp.set("v.isLead", res.isLead);
                            } else {
                                cmp.set("v.showFields", true);
                                cmp.set("v.showHeader", false);
                                cmp.set("v.idLeadAccount", '');
                                cmp.set("v.rutAccount", cmp.get("v.RUT"));
                                cmp.set("v.typeDocument", 'RUT');
                                cmp.set("v.nameClient", '');
                                cmp.set("v.lastnameClient", '');
                                cmp.set("v.apellidomatClient", '');
                                cmp.set("v.dateofBirth", '');
                                cmp.set("v.isAccount", true);
                                cmp.set("v.isLead", false);
                            }
                        }
                    }
                    else {
                       var toastEvent = $A.get("e.force:showToast");
                       
                       toastEvent.setParams({
                           "type": "Error",
                           "message": "Se ha producido un error. Por favor intente de nuevo"
                       });
                       
                       toastEvent.fire();
                    }
                });
                
                $A.enqueueAction(action);
            }
        } 
    },
    
    validateFormatAndDV: function(cmp) {
        var res = true;
        var rut = cmp.get("v.RUT");
        var inputField = cmp.find('RUTInput');
        
        // Despejar Puntos
        var valor = rut.replace(/\./g, '');
       
        // Despejar Guión
        valor = valor.replace('-', '');
        
        // Aislar Cuerpo y Dígito Verificador
        var cuerpo = valor.slice(0, -1);
        var dv = valor.slice(-1).toUpperCase();
        
        // Formatear RUN
        rut = cuerpo + '-' + dv;
        
        // Si no cumple con el mínimo ej. (n.nnn.nnn)
        if (cuerpo.length < 7) {
            inputField.setCustomValidity("Debe ingresar un RUT completo");
            inputField.reportValidity();
            return false;
        }
        
        // Calcular Dígito Verificador
        var suma = 0;
        var multiplo = 2;
       
        // Para cada dígito del Cuerpo
        for (var i = 1; i <= cuerpo.length; i++) {
            // Obtener su Producto con el Múltiplo Correspondiente
            var index = multiplo * valor.charAt(cuerpo.length - i);
            // Sumar al Contador General
            suma = suma + index;
            // Consolidar Múltiplo dentro del rango [2,7]
            if (multiplo < 7) {
                multiplo = multiplo + 1;
            } else {
                multiplo = 2;
            }
        }
        
        // Calcular Dígito Verificador en base al Módulo 11
        var dvEsperado = 11 - (suma % 11);
        
        // Casos Especiales (0 y K)
        dv = (dv == 'K') ? 10 : dv;
        dv = (dv == 0) ? 11 : dv;
        
        // Validar que el Cuerpo coincide con su Dígito Verificador
        if (dvEsperado != dv) {
            inputField.setCustomValidity("El RUT ingresado es incorrecto");
            inputField.reportValidity();
            return false;
        }
        
        // Si todo sale bien, eliminar errores (decretar que es válido)
        inputField.setCustomValidity("");
        inputField.reportValidity();
        return true;
    },
    
    createRegisterAccount : function(cmp, rut, typeDocument, nameClient, lastnameClient, apellidomatClient, 
                                     dateofBirth, remunerationAccount, mobileAccount, OpportunityId) {
        var action = cmp.get("c.registerParticipant");
        
        action.setParams({
            id : cmp.get('v.idLeadAccount'),
            isAccount : cmp.get('v.isAccount'),
            isLead : cmp.get('v.isLead'),
            rut : rut,
            tipoDocument : typeDocument,
            firstName : nameClient,
            lastName : lastnameClient,
            secondLastName : apellidomatClient,
            accountBirthDate : dateofBirth,
            remunerationAccount : remunerationAccount,
            mobileAccount : mobileAccount,
            OpportunityId : OpportunityId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            cmp.set("v.enabledSpinner", false);
            
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                       
                toastEvent.setParams({
                    "type": "Success",
                    "message": "Se ha agregado el participante con éxito"
                });
                
                toastEvent.fire();
                
                // Cerrar componente
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
        		dismissActionPanel.fire();
                
                // Refrescar componentes oportunidad
                $A.get('e.force:refreshView').fire();
            }
            else {
               var toastEvent = $A.get("e.force:showToast");
                var errorMsg = (response.getError() != null && response.getError()[0] != null) ? 
                    response.getError()[0].message : "Se ha producido un error. Por favor intente de nuevo";
           
               toastEvent.setParams({
                   "type": "Error",
                   "message": errorMsg
               });
               
               toastEvent.fire();
            }
        });
        
        cmp.set("v.enabledSpinner", true);
        $A.enqueueAction(action);
    }
    
})