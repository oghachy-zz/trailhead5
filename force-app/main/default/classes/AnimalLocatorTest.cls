@istest
private class AnimalLocatorTest
{
     @isTest static  void testGetCallout() {
         
         Test.setMock(HttpCalloutMock.class,new AnimalLocatorMock());
         System.debug('result '+AnimalLocator.getAnimalNameById(1));
     }
}