({
    validateRUT : function(cmp,event,helper) {    
		cmp.set("v.leadNot", false);

		var RUT = cmp.get("v.RUT").toLocaleUpperCase();
		if(RUT.length >0)
        {
            if(helper.validateFormatAndDV(cmp)){
                cmp.set("v.RUT", RUT);
                if(RUT.indexOf("-") < 0){
                    RUT = RUT.slice(0, RUT.length-1) + "-" + RUT.slice(RUT.length-1,RUT.length);
                    cmp.set("v.RUT", RUT);
                }
                cmp.set("v.enabledSpinner",true);

                console.log("RUT: " + RUT);
                var action = cmp.get("c.validatedRUTBBEE");
                action.setParams({ RUT : cmp.get("v.RUT")});
                action.setCallback(this, function(response) {
                	var val = response.getReturnValue();

                    if(response.getState() === "SUCCESS"){
						cmp.set("v.enabledSpinner",false);
                        var res = response.getReturnValue();
		
						if(res == undefined || res == null){
							cmp.set("v.leadNot", true);
							cmp.set("v.notifiText", "Error al procesar los datos");

                    	}else if(res.Account.length > 0){
							cmp.set("v.enabledSpinner", false);
							//cmp.set("v.RUT", "");

							if(res.Account[0].Estado_Cliente_Banca_Empresas__c == "" || res.Account[0].Estado_Cliente_Banca_Empresas__c == null){
								cmp.set("v.leadNot", true);
								cmp.set("v.notifiText", 'Cliente no tiene estado asignado (Prospecto o Cliente). Contacte a Analista de Inteligencia de Negocios');
                            }else if(res.Account[0].Estado_Cliente_Banca_Empresas__c == "Prospecto"){
								cmp.set("v.leadNot", true);
								cmp.set("v.notifiText", 'Prospecto existe como cliente, contacte a Analista de Inteligencia de Negocios');
							}else{
                                var RegistrosAccTeams = res.AccountTeamMemberOwner.filter(acc => acc.UserId == $A.get("$SObjectType.CurrentUser.Id"));    

                                if($A.get("$SObjectType.CurrentUser.Id") == res.Account[0].OwnerId || RegistrosAccTeams.length >0){
									helper.openRecord(res.Account[0].Id);
								}
								else{
									cmp.set("v.leadNot", true);
									cmp.set("v.notifiText", "Cliente pertenece a ejecutivo " + val.AccountOwner[0].Name + helper.concatenarEjecutivos(res.AccountTeamMemberOwner));
                                }
							}
						}else if(res.Lead.length > 0){
							cmp.set("v.ID",res.Lead[0].Id);

							if(res.Lead[0].Status == 'No_Interesado'){
								cmp.set("v.leadNot", true);
								cmp.set("v.notifiText", 'Prospecto No Convertido, contacte a Analista de Inteligencia de Negocios');
							
							}else if($A.get("$SObjectType.CurrentUser.Id") == res.Lead[0].OwnerId){
								helper.openRecord(res.Lead[0].Id);
							
							}else{
								cmp.set("v.leadNot", true);
								cmp.set("v.notifiText", "Prospecto pertenece a ejecutivo " + val.LeadOwner[0].Name);

								/*
								var toastEvent = $A.get("e.force:showToast");
								toastEvent.setParams({
									"title": "Prospecto en gestión",
									"message": "El prospecto que buscas ya esta siendo gestionado por el ejecutivo "+ val.LeadOwner[0].Name +" favor contactarlo de ser necesario",
									"type": "info"
								});
								toastEvent.fire();
								*/	
							}
							cmp.set("v.enabledSpinner", false);
						}else{
                            // Abrir Registro de nuevo Lead
							cmp.set("v.leadNot", true);
							helper.openCreateLeadWithRut(cmp,cmp.get("v.RUT"));
						}
					}
					//Case ERROR, Show error message
					else {
                        cmp.set("v.enabledSpinner",false);
                        cmp.set("v.notifiText", 'Existe error al obtener los registros ');
						cmp.set("v.hasErrors", true);      
					}
				});
	            $A.enqueueAction(action);
			}
		}
		else{
            cmp.set("v.leadNot", true);
            cmp.set("v.notifiText", "Ingrese un Rut para continuar.");
            //helper.openCreateRecord(cmp,"Lead");			
		}
	},
	openCreateRecord : function(cmp,obj) {        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": obj
        });
        createRecordEvent.fire();
	},
	validateFormatAndDV : function(cmp) {
        var res = true;
        var rut = cmp.get("v.RUT");
        var inputField = cmp.find('RUTInput');
        // Despejar Puntos
        var valor = rut.replace('.','');
        // Despejar Guión
        valor = valor.replace('-','');

        // Validar que no contenga mas digitos de nos necesarios
        if(valor.length > 9) {
            inputField.setCustomValidity("El RUT ingresado es incorrecto.");
            inputField.reportValidity();
            return false;
        }


        // Aislar Cuerpo y Dígito Verificador
        var cuerpo = valor.slice(0,-1);
        var dv = valor.slice(-1).toUpperCase();
        // Formatear RUN
        rut = cuerpo + '-'+ dv;
        // Si no cumple con el mínimo ej. (n.nnn.nnn)

        if(cuerpo.length < 7) {
            inputField.setCustomValidity("Debe ingresar un RUT completo.");
            inputField.reportValidity();
            return false;
        }
        // Calcular Dígito Verificador
        var suma = 0;
        var multiplo = 2;
        // Para cada dígito del Cuerpo
        for(var i=1;i<=cuerpo.length;i++) {
            // Obtener su Producto con el Múltiplo Correspondiente
            var index = multiplo * valor.charAt(cuerpo.length - i);
            // Sumar al Contador General
            suma = suma + index;
            // Consolidar Múltiplo dentro del rango [2,7]
            if(multiplo < 7) {
                multiplo = multiplo + 1; 
            } else { 
                multiplo = 2; 
            }
        }
        // Calcular Dígito Verificador en base al Módulo 11
        var dvEsperado = 11 - (suma % 11);
        // Casos Especiales (0 y K)
        dv = (dv == 'K')?10:dv;
        dv = (dv == 0)?11:dv;
        // Validar que el Cuerpo coincide con su Dígito Verificador
        if(dvEsperado != dv) {
            inputField.setCustomValidity("El RUT ingresado es incorrecto.");
            inputField.reportValidity();
            return false;
        }
        // Si todo sale bien, eliminar errores (decretar que es válido)
        inputField.setCustomValidity("");
        inputField.reportValidity();
        return true;
    },
    openCreateLeadWithRut : function(cmp,RUT) {        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Lead",
            "defaultFieldValues": {
                'RUTEmpresa__c': RUT,
                'EmpresaGrupoFilial__c':"1"                
            }
        });
        createRecordEvent.fire();
	},
	    //This functions navigate to an existing record
	openRecord : function(id) {  
		console.log("ID: "+id);
		var navEvt = $A.get("e.force:navigateToSObject");
		navEvt.setParams({
			"recordId": id,
			"slideDevName": "detail"
		});
		navEvt.fire();
    },
    concatenarEjecutivos : function(lst){
        var strOwner = '';
        for(var i=0; i < lst.length; ++i){
            strOwner += ", " + lst[i].User.Name;
            //strOwner += ", " + lst[i].Account.Owner.Name;
        }
        return strOwner;
    }

})