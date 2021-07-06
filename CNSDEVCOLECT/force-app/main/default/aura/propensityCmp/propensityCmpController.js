({
	doInit : function(cmp, evt, hlp) {
        hlp.getPropensity(cmp, evt, hlp);
	},
    needDetector : function(cmp,evt,hlp) {
		cmp.set("v.enabledSpinner",true)
		hlp.getQuestions(cmp, evt, hlp);
    }
})