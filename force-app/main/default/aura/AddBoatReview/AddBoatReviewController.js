({
	doInit : function(component, event, helper) {
		helper.onInit(component,event);
	},
    onSave : function(component, event, helper) {
        var toast = $A.get("e.force:showToast");
        component.find("service").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                if (!$A.util.isUndefinedOrNull(toast)) {
                    toast
                    .setParams({"title":"Saved",
                                "message":"The record was saved."})
                    .fire();
                } else {
                    alert("error");
                }
            } else {
                console.log('Error: ' + JSON.stringify(saveResult.error));
            }
        });
        component.getEvent("BoatReviewAdded").fire();
        helper.onInit(component, event);
    },
    onRecordUpdated : function(component,event,helper)
    {
                 var resultsToast = $A.get("e.force:showToast");
                	resultsToast.setParams({
                        "title": "Record Saved",
                        "message": "The new record was created."
                    });
                resultsToast.fire();
        
    }
})