@istest
private class ParkLocatorTest {
	 @isTest static  void testGetCallout() {
         
        Test.setMock(WebServiceMock.class,new ParkServiceMock());
        ParkLocator.country('Japan');
     }
}