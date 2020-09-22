({
	onSearch : function(component,event) {
		var action = component.get("c.getBoats");
        var boatTypeID = component.get('v.selectedBoatID');
		action.setParams({boatTypeID : boatTypeID});
		 action.setCallback(this, function(response) {
             var state = response.getState();
            if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				component.set('v.boats',JSON.parse(resp.getReturnValue()));
            }
        });
        
        $A.enqueueAction(action);
		
	}
})