global class ParkServiceMock implements WebServiceMock{

    global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType)
    {
        ParkService.byCountryResponse response_x = new ParkService.byCountryResponse();
    	response_x.return_x =new List<String>();
        response_x.return_x.add('Germany');
        response_x.return_x.add('Japan');
        response_x.return_x.add('India');
        response_x.return_x.add('United States');
        response.put('response_x',response_x);
    }
    
}