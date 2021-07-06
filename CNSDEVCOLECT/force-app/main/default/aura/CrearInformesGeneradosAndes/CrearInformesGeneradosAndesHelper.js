({
	showSuccessToast: function (component, event, helper, typ, tittle, msg) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: tittle,
			duration: '25000',
			key: 'info_alt',
			type: typ,
			message: msg
		});
		$A.get("e.force:closeQuickAction").fire();
		toastEvent.fire();
		$A.get("e.force:refreshView").fire();
	},

	showInfoToast: function (component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: '',
			message: 'No hubo respuesta del servicio',
			duration: ' 25000',
			key: 'info_alt',
			type: 'info',
			mode: 'dismissible'
		});
		$A.get("e.force:closeQuickAction").fire();
		toastEvent.fire();
		$A.get("e.force:refreshView").fire();
	}
})