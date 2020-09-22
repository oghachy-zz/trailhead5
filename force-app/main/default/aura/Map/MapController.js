({
    jsLoaded: function(component) {
        component.set("v.jsLoaded", true);
    }  ,
    updateLocation : function(component,event)
    {
    	var long = event.getParams('long');
    	var lat  = event.getParams('lat');
    	component.set('v.location.Geolocation__latitude__s','lat');
    	component.set('v.Geolocation__longitude__s','long');
    }
})