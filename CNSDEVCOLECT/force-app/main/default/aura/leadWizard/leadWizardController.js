({
    //This functions calls a function that.....
    doInit: function (cmp, event, helper) { 
    },
	clickCreateWithRUT : function(cmp, event, helper) {
		helper.validateRUT(cmp,event,helper);
	},
    clickCreateWithOutRUT : function(cmp, event, helper) {
        //cmp.set("v.obj","Lead");
		//var obj = cmp.get("v.obj");
		helper.openCreateRecord(cmp,"Lead");
    },
    buttonAssign : function(cmp, event, helper){
        helper.changeLeadOwner(cmp,helper);
        cmp.set("v.question", false);
        cmp.set("v.RUT", "");
        cmp.set("v.ID","");
    },
    buttonCancel : function(cmp, event, helper){
        cmp.set("v.question", false);
        cmp.set("v.RUT", "");
        cmp.set("v.ID","");
    },
    rutFormat : function(cmp, event, helper){
        helper.validateFormatAndDV(cmp);
    },
    closeModel : function(cmp, event, helper){
        cmp.set("v.isOpen",false);
    },
    createLead : function(cmp, event, helper){
        cmp.set("v.isOpen",false);
    },
   	clickCreate : function(cmp, event, helper){
        cmp.set("v.isOpen",false);
    },
    
    
    
    
    
})