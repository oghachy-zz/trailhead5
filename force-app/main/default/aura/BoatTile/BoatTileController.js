({
	onBoatClick : function(component, event, helper) {
		var boatSelect = component.getEvent("boatSelect");
        
        var PlotMapMarker = $A.get('e.c:PlotMapMarker');
        
        var boat = component.get('v.boat');
		
        boatSelect.setParams({
            boatId : boat.Id
        });
    	

        
        boatSelect.fire();
        var boatSelected = $A.get('e.c:BoatSelected');
        boatSelected.setParams({
            boat : boat
        });
        boatSelected.fire();


     PlotMapMarker.setParams({
        sObjectId:boat.Id,
        lat:boat.Geolocation__latitude__s,
        long:boat.Geolocation__longitude__s,
        label:boat.Name

     });
    PlotMapMarker.fire();

	}
    
})