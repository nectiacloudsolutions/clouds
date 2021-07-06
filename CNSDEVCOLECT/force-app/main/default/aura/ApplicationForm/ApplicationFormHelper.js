({
	recordssort: function(records){
		var sortrecords = records.sort(this.sortBySeccionAndOrden);
		return sortrecords;
	},
	sortBySeccionAndOrden : function(a, b) {

		if (parseInt(a.value.seccion_nro__c) > parseInt(b.value.seccion_nro__c)) return 1;
		if (parseInt(a.value.seccion_nro__c) < parseInt(b.value.seccion_nro__c)) return -1;
		if (parseInt(a.value.nro_orden__c) > parseInt(b.value.nro_orden__c)) return 1;
		if (parseInt(a.value.nro_orden__c) < parseInt(b.value.nro_orden__c)) return -1;
		return 0;
	},
	sortByCaseNumber2 : function(a, b) {

		var aa = parseFloat(a.value.seccion_nro__c + '.' + a.value.nro_orden__c);
		var bb = parseFloat(b.value.seccion_nro__c + '.' + b.value.nro_orden__c);

		return  parseFloat(a.value.seccion_nro__c + '.' + a.value.nro_orden__c) - parseFloat(b.value.seccion_nro__c + '.' + b.value.nro_orden__c)
	}
		
})