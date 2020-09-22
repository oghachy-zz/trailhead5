({
	doInit : function(component, event, helper) {
		 var action = component.get("c.retrieveBoatTypes");
		action.setCallback(this, function(response) {
             var state = response.getState();
            if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				component.set('v.boatTypes',resp);
            }
        });
        
        $A.enqueueAction(action);
	},
    newBoat : function(component,event,helper)
    {
        var createBoatEvent = $A.get("e.force:createRecord");
        var selectedType =component.find("selectedType").get("v.value");
		createBoatEvent.setParams({
    				"entityApiName": "Boat__c",
    				"defaultFieldValues": {
        			'BoatType__c' :selectedType
    	}
		});
		createBoatEvent.fire();
    },
    onFormSubmit : function(component,event,helper)
    {
        var typeId = component.find("selectedType").get("v.value");
        var cmpEvent = cmp.getEvent("formSubmit");
        cmpEvent.setParams({
            "formData":{"boatTypeId" : typeId}
        });
        cmpEvent.fire();

    }
})