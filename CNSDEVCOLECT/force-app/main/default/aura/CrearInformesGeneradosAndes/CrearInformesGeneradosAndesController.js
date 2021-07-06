({
	doInit: function (component, event, helper) {
		component.set("v.isOpen", true);
		component.set("v.Spinner", true);

		var informeId = component.get("v.recordId");
		var action = component.get("c.procesaEnvioInformesAndes");
		action.setParams({ "informeId": informeId });

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var res = response.getReturnValue();
				//console.log(JSON.stringify(res));
				if (res === null) {
					helper.showInfoToast(component, event, helper);
					return; 
				}
				if (res != null) {
					if (res.codeAPI == 200) {
						if (res.dtoResponseCodigosEstadoHttp.codigo === '200') {
							if (res.dtoResponseSetResultados.codigoSalida === 1) {
								var tittle = 'Código: ' + res.dtoResponseCodigosEstadoHttp.codigo + ' Descripción: ' + res.dtoResponseCodigosEstadoHttp.mensaje;
								var msg = res.dtoResponseSetResultados.mensajeSalida;
								helper.showSuccessToast(component, event, helper, 'success', tittle, msg);
							} else {
								var tittle = 'Código: ' + res.dtoResponseCodigosEstadoHttp.codigo + ' Descripción: ' + res.dtoResponseCodigosEstadoHttp.mensaje;
								var msg = res.dtoResponseSetResultados.mensajeSalida;
								helper.showSuccessToast(component, event, helper, 'warning', tittle, msg);
							}
						} else if (res.dtoResponseCodigosEstadoHttp.codigo != '200') {
							var tittle = 'Código: ' + res.dtoResponseCodigosEstadoHttp.codigo + ' Mensaje: ' + res.dtoResponseCodigosEstadoHttp.mensaje;
							var msg = res.dtoResponseCodigosEstadoHttp.descripcion;
							helper.showSuccessToast(component, event, helper, 'error', tittle, msg);
						}
					} 
					else if (res.codeAPI == 100) {
						var tittle = 'Info.';
						var msg = res.msjAPI;
						helper.showSuccessToast(component, event, helper, 'warning', tittle, msg);
					}
					else {
						var tittle = 'Error en servicio ANDES';
						var msg = 'Código: ' + res.codeAPI + ' Descripción: ' + res.msjAPI;
						helper.showSuccessToast(component, event, helper, 'error', tittle, msg);
					}
				}
			} 
			else if (state === "ERROR") { 
				var errors = response.getError();
				helper.showSuccessToast(component, event, helper, 'error', 'Error!', errors[0].message);
			} 
			else {
				var tittle = 'Error!';
				var msg = 'Error Desconocido.'
				helper.showSuccessToast(component, event, helper, 'error', tittle, msg);
			}
			component.set("v.Spinner", false);
		});
		$A.enqueueAction(action);
	},

	doCancel: function (component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	}
})