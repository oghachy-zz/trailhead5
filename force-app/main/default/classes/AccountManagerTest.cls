@istest
private class AccountManagerTest {
     @isTest static  void testGetCallout() {
		
		Account acc = new Account(Name='Test');
        Contact cont = new Contact(AccountId=acc.Id,LastName='Cont');
        insert acc;
        
         Test.startTest();
         RestRequest req = new RestRequest();
         req.requestURI ='/services/apexrest/Accounts/'+acc.Id+'/contacts';
         RestContext.request = req;
         
         AccountManager.getAccount();
         Test.stopTest();
			         
     }
}