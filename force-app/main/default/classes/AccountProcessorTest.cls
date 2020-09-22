@isTest
private class AccountProcessorTest {

    @isTest
    public static void countCont()
    {
        Account acc= new Account(Name='Test',Number_of_Contacts__c=0);
        insert acc;
        
        Contact cont = new Contact(LastName='Test',AccountId=acc.Id);
        insert cont;
        
        Test.startTest();
        AccountProcessor.countContacts(new List<Id>{acc.Id});
        Test.stopTest();
    }  
    
}