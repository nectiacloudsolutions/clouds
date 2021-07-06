/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 08-24-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-24-2020   eayalcor@everis.com   Initial Version
**/
({
    helperMethod : function(cmp) {
        window.setTimeout(
            $A.getCallback(function () {
                $A.get("e.force:closeQuickAction").fire();
            }), 500
        ); 
    },
})