({
	onFormSubmit : function(component, event, helper) {
		var formData = event.getParam("formData");
        var comp = component.find('boatSearchIdForm');
        comp.search(formData.boatTypeId);
        //component.set('v.selectedBoatID',formData.boatTypeId);

	}
})