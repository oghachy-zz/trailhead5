({
	doInit : function(component, event, helper) {
		helper.onSearch(component,event);
	},
    doSearch : function(component,event,helper){
        var boatTypeId = event.getParam("boatTypeId");
        component.set('v.selectedBoatID',boatTypeId);
        helper.onSearch(component,event);
    },
    onBoatSelect : function(component,event,helper)
    {
        var boatTypeId = event.getParam("boatTypeId");
        component.set('v.selectedBoatID',boatTypeId);
        
    }
})