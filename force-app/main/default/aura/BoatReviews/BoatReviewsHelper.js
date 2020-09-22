({
	onInit : function(component,event) {
		var action = component.get("c.getAll");
        var boatId = component.get("v.boat").Id;
        action.setParams({boatId : boatId});
		action.setCallback(this, function(response) {
             var state = response.getState();
            if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				component.set('v.BoatReviews',JSON.parse(resp.getReturnValue()));
            }
            else
            {
                console.log('error');
            }
        });
        
        $A.enqueueAction(action);
        
	}
})