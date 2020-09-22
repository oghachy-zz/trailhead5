({
    afterRender: function(component, helper) {
        var svg = component.find("svg_content");
        
        
       // while (svg) {
	    	
        //    svg.style.fill = '/#999999/g';
		//	svg = svg.previousElementSibling;    		        
        //}
        
        var value = svg.getElement().innerText;
        value = value.replace("<![CDATA[", "").replace("]]>", "");
        svg.getElement().innerHTML = value;        
}})