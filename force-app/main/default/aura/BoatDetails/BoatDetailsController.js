({
	onBoatSelected : function(component, event, helper) {
		var boat= event.getParam("boat");
       
        //component.set('v.boat' , boat);
        component.set('v.id' , boat.Id);
       	var boatRecord = component.find("service");
        boatRecord.set("v.recordId", boat.Id);
        boatRecord.reloadRecord();



	},
    onRecordUpdated : function(component,event,helper){
        var brcmp = component.find("brcmp");
        brcmp.refresh();

    },
    onInit : function(component,event,helper)
    {
        
    },
    onBoatReviewAdded : function(component,event,helper){
        component.find("tabs").set("v.selectedTabId", "boatreviewtab");
        var brcmp = component.find("brcmp");
        brcmp.refresh();        
    }
})