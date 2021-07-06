/**
 * @File Name          : offerWithoutCmpController.js
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/1/2020, 1:03:30 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/1/2020   eayalcor@everis.com     Initial Version
**/
({
    doInit : function(cmp, evt, hp) {
        hp.getData(cmp);
    },reject : function(cmp,evt,hp){
        hp.rejectOffer(cmp,evt);
    },closeModal : function (cmp,evt,helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    onChange : function (cmp,evt,helper){
        //$A.get("e.force:closeQuickAction").fire();
    },
})