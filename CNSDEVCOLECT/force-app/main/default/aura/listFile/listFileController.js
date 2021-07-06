({
	doInit : function(component, event, helper) {
		helper.InitData(component,event);
	},
    previewFile : function(component, event, helper){  
		var idRepo=event.currentTarget.id;
        var repo=event.currentTarget.dataset.prod;
        component.set("v.showSpinner", true);
        if(repo==='Banco'){
            helper.callviewFileAlfresco(component, event,idRepo);
        }else if(repo==='Seguros'){
            helper.callviewFileDocuware(component, event,idRepo);
        }       
    },
   	closeModel: function (component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpenPdf", false);
        component.set("v.pdfContainer", '');
    }
})