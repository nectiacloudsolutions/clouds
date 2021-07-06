/**
 * @File Name          : OfferWithCmpController.js
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/1/2020, 4:29:27 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/1/2020   eayalcor@everis.com     Initial Version
**/
({
	doInit : function(cmp, evt, hp) {
    	hp.getData(cmp,evt);
	},
    generate: function(cmp, evt, hp) {	
    	hp.generateOpportunity(cmp,evt);
	},
    closeModal : function (cmp,evt,helper){
        $A.get("e.force:closeQuickAction").fire();
    },
})