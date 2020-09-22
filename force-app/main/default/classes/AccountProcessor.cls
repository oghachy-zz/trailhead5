public class AccountProcessor {
	
    @future
    public static void countContacts(List<Id> lstAccId)
    {
        List<Account> lstAcc = new List<Account>();
        lstAcc = [Select Id,Number_of_Contacts__c,(Select Id from Contacts ) from Account where Id IN : lstAccId];
        
        for(Account acc:lstAcc)
        {
            Integer index = 0;
            
            for(Contact cont:acc.contacts)
            {
                index++;
            }
            
            acc.Number_of_Contacts__c = index;
        }
        
        update lstAcc;
    }
    
}